				[org 0x0100]
				jmp start
			
 Calculate_Location:	; this function takes row and column number and return the location

				push bp
				mov bp,sp
				pusha
				
				mov ax,80
				mov bx,[bp+6] ; row number
				mul bx
				add ax,[bp+4]
				shl ax,1
				mov [bp+8],ax
				;location = ( hypos * 80 + epos ) * 2
				popa
				pop bp
				ret 4

 PrintOnCentre:
				push bp
				mov bp,sp
				pusha
				push es
				
				push 0
				mov ax,[bp+6]
				add ax,[bp+10]
				shr ax,1
				cmp ax,12
				jge lab1 
				; source is above from the centre ; printing should be starting from bottom side
				mov bx,0
				jmp lab2
		lab1:
				mov bx,1
		lab2:		
				push bx
				push word [bp+10]
				push word [bp+8]
				push word [bp+6]
				push word [bp+4]
				call Calculate_Di
				pop di
				mov ax,0xb800
				mov es,ax
				cmp bx,0
				je lab3
				
				mov cx,[bp+10]	; top row
				
				jmp lab4
		lab3:	
		
				mov cx,[bp+6]	; bottom row
				
		lab4:
				mov ah,07
				add di,10
		Loop1:												
				mov dx,[bp+8]

				push 0
				push cx
				push dx
				call Calculate_Location
				pop si
		Loop2:		
				cmp dx,[bp+4]
				jge EndOfInnerLoop
				
				mov ax,[Es:si]
				stosw
				add si,2
				add dx,2
				jmp Loop2
		
		EndOfInnerLoop:
				cmp bx,0
				je lab5
				
				add di,160
				add cx,1
				
				cmp cx,[bp+6]	; bottom row
				jge EndOfOuterLoop
				
				jmp lab6
		lab5:	
				sub di,160
				sub cx,1
				
				cmp cx,[bp+10]	; top row
				jb EndOfOuterLoop
		
		lab6:
				
				sub di,[bp+4]
				add di,[bp+8]
				jmp Loop1
				
		EndOfOuterLoop:		
		
				pop es
				popa
				pop bp
				ret 8

 Calculate_Di: ;12,	40
;	push for top to bottom or bottom to top..if zero top else bottom
;	x push for left to right or right to left..if zero left else right	
; if source is on top then print bottom to top

				push bp
				mov bp,sp
				pusha
				
				;	calculate centre of source 
				;	column number of centre
				mov ax,[bp+4]
				sub ax,[bp+8]
				shr ax,1
				mov si,40
				sub si,ax

				;	row number of centre
				mov ax,[bp+6]
				sub ax,[bp+10]
				shr ax,1
				mov di,12

				cmp [bp+12],word 1	
				je TopToBottom	; source is below the centre line

				add di,ax
				add di,ax	; instead of using label for subtraction, we add the ax one more time so that...one time subtraction cancel it's effects

		TopToBottom:
				sub di,ax

				push 0
				push di
				push si
				call Calculate_Location	
				pop word [bp+14]				
				
				popa
				pop bp
				ret 10
 start: 
				
				push 0	; top 
				push 10  ; left		; difference between bottom and top	should be odd,,,so that it can easily be centered.
				push 24 ; bottom
				push 50	; right		; half of the difference between right and left should be even,,,so that it can easily be centered.
				; 50 is exluded if you wanna add 50th column then input 51....other one are inclusive
				call PrintOnCentre
				
				mov ax, 0x4c00 ; terminate program
				int 0x21