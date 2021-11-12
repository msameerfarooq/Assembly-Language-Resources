											[org 0x100]
											
											; Muhammad Sameer Farooq
											; 18L-0986
											; CS-D
			jmp start
	Old_KBISR: dw 0, 0
	ASCIIs_ofFirstLine:	db 	70h, 71h, 77h, 65h, 72h, 74h, 79h, 75h, 69h, 6Fh
	
PrintToConfirm:
			push es
			pusha
			
			push 0xB800
			pop es
			
			mov di, 0
	label1:
			mov ah, 0	; service number
			int 16h
			mov ah, 0x07	; attribute
			mov [es:di],ax
			add di,2
			jmp label1

			popa
			pop es
			ret

KBISR:
			pushf
			call far [Old_KBISR]

			l1:
		cmp al, '9'
		jg return

		cmp al, '0'
		jl return
			push bx
			mov bh, 0
			mov bl, al
			sub bl, '0'
			mov al, [ASCIIs_ofFirstLine + bx]
			add ah, 30
			
			pop bx
			;iret
	return:
			iret

start:	
			mov di, 0
			mov cx, 0
			
			push word 0
			pop es
	
			mov ax, [es:16h*4];
			mov [Old_KBISR], ax
			
			mov ax, [es:16h*4+2]
			mov [Old_KBISR+2], ax
			
		cli
			mov word [es:16h*4], KBISR
			mov word [es:16h*4+2], cs
		sti

			call PrintToConfirm

			mov ax, 4c00h
			int 21h