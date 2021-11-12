 ; found an n bit pattern
 ; Muhammad Sameer Farooq
 ; 18L-0986
 ; CS-D
 
				[org 0x0100]
				jmp Start
 FindAPattern:
						
				push bp
				mov bp,sp
				pusha
				push word num2
				push word num1
				
				mov cx,[bp+4]
				cmp cx,0
				jbe skip
				
				mov bx,0	; used for masking of given number
				mov dx,0	; used for masking of pattern
		Loop1:		
				mov si,3
				
				shr si,1
				rcr bx,1
				
				shr si,1
				rcl dx,1
				
				loop Loop1
				
				and dx,[bp+6]	; just copy the required pattern into dx
				
				; move the pattern on most significant bits
				mov cx,[bp+4]
		Loop2:
				ror dx,1
				loop Loop2
		
				; now pattern is like 1101 and junk of 12 bits
				mov [num2],dx
				mov cx,16
				sub cx,[bp+4]
		
				mov dx,bx
		Loop3:
				
				and dx,[num1]
				cmp dx,[num2]
				je Found
				
				ror word [num2],1
				ror bx,1
				mov dx,bx
				
				loop Loop3
				
				; it comes when pattern not found and it will jump to skip
				jmp skip
		Found:
				mov dx,16
				sub dx,[bp+4]
				sub dx,cx
				mov word[bp+10],dx
				
				
		skip:
 				pop word [num1]
				pop word [num2]
				popa
 				pop bp
 				ret 6
				
 Start:
				mov ax,[num1]
				mov bx,[num2]
 				push -1
				push ax
 				push bx
 				push word [len] ;length of pattern
				call FindAPattern
 				pop ax
 				
				mov ax,0x4c00
 				int 0x21
				
				num1:	dw 1110111100001010b
				num2:	dw 111100b 
				len:	dw 6