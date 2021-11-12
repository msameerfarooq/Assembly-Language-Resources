	[org 0x0100]
	jmp Start
	
	 clrscr:
				push es
				push ax
				push di
				
				mov ax, 0xb800
				mov es, ax ; point es to video base
				mov di, 0 ; point di to top left column

		nextloc:
				mov word [es:di], 0x0720 ; clear next char on screen
				add di, 2 ; move to next screen location
				cmp di, 4000 ; has the whole screen cleared
				jne nextloc ; if no clear next position
				pop di
				pop ax
				pop es
				ret
	
 printstr: 		
				push bp
				mov bp, sp
				push es
				pusha

				mov ax, 0xb800
				mov es, ax ; point es to video base
		
				mov ah,byte[bp+10]
				mov di, [bp+8] ; point di to top left column
				mov si, [bp+6] ; point si to string
				mov cx,	[bp+4] ; point cx to the length of string
				cmp cx, 0
				je StringEnds
		nextchar: 
				mov al, [si] ; load next char of string
				mov [es:di], ax ; show this char on screen
				add di, 2 ; move to next screen location
				add si, 1 ; move to next char in string
				loop nextchar
		
		StringEnds:
				mov [bp+12],di
				popa
				pop es
				pop bp
				ret 8	
	
	PrintDay:
		push bp
		mov bp,sp
		pusha
		
		mov di,[bp+6]
		mov si,[bp+4]
		
		push bx
		mov bx,si
		mov bh,0
		mov si,bx
		pop bx
		
		mov bx,Days
		;add bx,[si]
		mov cx,[DayLength+si]
		mov ch,0
		add bx,cx
		mov cx,[DayNameLength+si]
		mov ch,0
		push 0
		push word 15
		push di
		push bx
		push cx
		call printstr
		pop word [bp+8]
		
		popa
		pop bp
		ret 4
		
	PrintMonth:
		push bp
		mov bp,sp
		pusha
		
		mov di,[bp+6]
		mov si,[bp+4]
		
		push bx
		mov bx,si
		mov bh,0
		mov si,bx
		pop bx
		
		mov bx,Months
		;add bx,[si]
		mov cx,[MonthLength+si]
		mov ch,0
		add bx,cx
		mov cx,[MonthNameLength+si]
		mov ch,0
		push 0
		push word 15
		push di
		push bx
		push cx
		call printstr
		pop word [bp+8]
		
		popa
		pop bp
		ret 4
		
printnum: 
		push bp
		mov bp, sp
		push es
		pusha

		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov ax, [bp+4] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
		
	nextdigit:
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigit ; if no divide it again
		mov di, [bp+6] ; point di to required location
	
	nextpos:
		pop dx ; remove a digit from the stack
		mov dh, 15 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location	
		loop nextpos ; repeat for all digits on stack

		mov [bp+8],di
		popa
		pop es
		pop bp
		ret 4
	
myISR80:
		push bp
		mov bp,sp
		push es
		push ax
		push si
	
		mov si,160*12	;centre
	
		mov ax,0xb800
		mov es,ax
	
		mov ax,0x2A00
		int 21h
		mov ah,15
		cmp bl,0
		je Format1
		cmp bl,1
		je Format2
	
	Format3:
	
		push si
		push si
		push ax
		
		call PrintDay
		pop si
		
		mov al,','
		mov [es:si+2],ax
		
		add si,4
		push si
		push si
		mov al,dh
		sub al,1
		push ax
		
		call PrintMonth
		pop si

		add si,4
		push si
		push si
		mov dh,0
		push dx
		call printnum
		pop si
	
		mov al,','
		mov [es:si+2],ax

	
		add si,4
		push si
		push si
	;	mov dh,0
		push cx
		call printnum
		pop si
		
		jmp DataPrinted
		
	Format2:
		push cx
		push si
		push si
		mov cx,dx
		mov ch,0
		push cx
		call printnum
		pop si
	
		mov al,','
		mov [es:si+2],ax
		
		add si,4
		push si
		push si
		mov al,dh
		sub al,1
		push ax
		
		call PrintMonth
		pop si
		
		pop cx
		
		add si,2
		push si
		push si
		push cx
		call printnum
		pop si
		
		jmp DataPrinted
		
	Format1:
		push cx
		push si
		push si
		mov cx,dx
		mov ch,0
		push cx
		call printnum
		pop si
	
		mov al,'/'
		mov [es:si+2],ax
		
		add si,4
		push si
		push si
		mov cl,dh
		mov ch,0
		push cx
		call printnum
		pop si
		
		mov al,'/'
		mov [es:si+2],ax
		
		pop cx
		
		add si,4
		push si
		push si
		push cx
		call printnum
		pop si
	
	DataPrinted:
	pop si
	pop ax
	pop es
	pop bp
	ret
	
	
	Start:
	call clrscr
	mov ax,0
	mov es,ax
	cli
	mov word [es:80*4],myISR80
	mov word[es:80*4+2],cs
	sti
	
	mov bl,0
	call myISR80
	
	mov ax,0x4c00
	int 0x21
	
Months: db	"January","February","March","April","May","June","July","August","September","October","November","December",0
MonthLength: db 0,7,15,20,25,28,32,36,42,51,58,66
MonthNameLength: db 7,8,5,5,3,4,4,6,9,7,8,8


DayNameLength: db 6,6,7,9,8,6,8
Days:	db	"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday",0
DayLength: db 0,6,12,19,28,36,42