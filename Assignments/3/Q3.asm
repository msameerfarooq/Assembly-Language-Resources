				[org 0x0100]
				
				mov si,10	;	length of a triangle should be in between (0-26 exclusively)
				
				jmp start

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
				
 print_triangle: ; this function takes length, color and takes x an y component where user wants to print 
				push bp
				mov bp,sp
				pusha
				push es
				mov ax,0xB800
				mov es,ax
				mov cx,[bp+4]	; length of triangle
				mov ax,[bp+10]	; character		+   	attribute , colour
				mov bx,[bp+6]	; column number
				mov si,[bp+8]	; row number
				
				shl cx,1
		Loop1:	
				push cx
				shr cx,1
				jc SecondLine
				
		FirstLine:
				mov di,cx
				sub di,[bp+4]
				add di,bx
				jmp Print
				
		SecondLine:
				mov di,[bp+4]
				sub di,cx
				add di,bx
				add si,1
		Print:		
				
				pop cx
				push 0
				push si
				push di
				call Calculate_Location
				pop di
				mov [es:di],ax
				
				dec cx
				cmp cx,1
				jne Loop1
				
				mov di,bx
				sub di,[bp+4]
								
				push 0
				push si
				push di
				call Calculate_Location
				pop di
				
				mov dh,ah
				mov dl,0x20		; space
				mov cx,[bp+4]	; reset the cx to the length of triangle
				
		Loop3:	
				add di,2
				mov [es:di],ax
				add di,2	
				mov [es:di],dx
			
				loop Loop3	
				pop es				
				popa
				pop bp
				ret 8	; because it have to return nothing
								
 Calculate_Location:	; this function takes row and column number and return the location
				push bp
				mov bp,sp
				pusha
				
				mov ax,80
				mov bx,[bp+6] ; row number
				mul bx
				add ax,[bp+4]
				add ax,ax
				mov [bp+8],ax
				;location = ( hypos * 80 + epos ) * 2
				popa
				pop bp
				ret 4
				
 delay:
				push bp
				mov bp,sp
				pusha
				pushf
				mov cx,[bp+4]
		mydelay:
				mov bx,[bp+4]      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
		mydelay1:
				dec bx
				jnz mydelay1
				loop mydelay
				popf
				popa
				pop bp
				ret 2

 printstr: 		
				push bp
				mov bp, sp
				push es
				pusha

				mov ax, 0xb800
				mov es, ax ; point es to video base
		
				mov ah,byte[bp+8]
				mov di, [bp+6] ; point di to top left column
				mov si, [bp+4] ; point si to string
				cmp [si],byte 0
				je StringEnds
		nextchar: 
				mov al, [si] ; load next char of string
				mov [es:di], ax ; show this char on screen
				add di, 2 ; move to next screen location
				add si, 1 ; move to next char in string
				cmp [si],byte 0
				jg nextchar
		
		StringEnds:
				popa
				pop es
				pop bp
				ret 8
 start: 
				
				mov di,0	;	starting row number
				mov cx,25	;	numbers of rows in a screen
				mov bx,78	;	column number
				mov al,2Ah	;	the character we want to print to form triangle (asterics * )
				mov ah,07	;	default attribute
				
				call clrscr ; call the clrscr subroutine
				shr bx,1	;	bcz each contain two cell 
				sub cx,si
				add cx,1
				mov ah,1001b
				mov dx,0
				cmp si,26
				jge InalidInput
				cmp si,0
				jle InalidInput
		Loop2:		
				
				push ax
				push di
				push bx		;column number	(starts from 0)
				push si
				call print_triangle
				cmp cx,1
				jne LargeDelay
				push 400
				jmp callDelay
		LargeDelay:		
				push 700
		callDelay:
				call delay
				add di,1
				add ah,1
				cmp ah,1111b
				jne l1
				mov ah,1
				
		l1:		
				call clrscr ; call the clrscr subroutine		
				loop Loop2
				cmp dx,0
				jne l2 
				mov ah,10001010b
				add dx,1
		l2:		
				sub di,1
				cmp ah,10010000b
				jae End
				
				mov cx,1
				jmp Loop2
		InalidInput:
				mov ax, message
				mov cx,4
		
		PrintInvalidMessage:
				push 10001100b
				push 1970
				push ax ; push address of message
				call printstr ; call the printstr subroutine

				push 600
				call delay

				loop PrintInvalidMessage
				
				call clrscr
				
				push 07
				push 1970;1970	;	2130
				push ax
				call printstr ; call the printstr subroutine
				push 1500
				call delay
				call clrscr
		End:
				
				mov ax, 0x4c00 ; terminate program
				int 0x21					
				
				message: db "Length of triangle is not valid!",0 ; string to be printed