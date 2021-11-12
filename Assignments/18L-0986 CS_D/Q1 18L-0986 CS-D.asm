; display a tick count on the top right of screen
											[org 0x0100]
											
											; Muhammad Sameer Farooq
											; 18L-0986
											; CS-D
			jmp start
tickcount:	dw 0


Bottom:
			pusha
			push es
			mov ax,0xb800
			mov es,ax
			mov cx,80;------> outer loop
	Loop2:
			mov di,3998;1920-------> Inner Loop
			mov dx,[es:di]	; save the last index
		Loop2Inner:
			sub di,2
			mov ax,[es:di]
			mov [es:di+2],ax

			cmp di,2080
		ja Loop2Inner
		
		mov [es:di],dx
	loop Loop2

			pop es
			popa
			ret


Top:	; 2080
			pusha
			push es
			mov ax,0xb800
			mov es,ax
			mov cx,80;------> outer loop
	Loop1:
			mov di,-2;-------> Inner Loop
			mov dx,[es:0]	; save the last index
		Loop1Inner:
			add di,2
			mov ax,[es:di+2]
			mov [es:di],ax

			cmp di,1918
			jb Loop1Inner

			mov [es:di],dx
		loop Loop1

			pop es
			popa
			ret

; timer interrupt service routine
timer:
			push ax
			cmp cx,36
			jne return
			mov cx,0
			inc si; increment tick count
			cmp si,2
			jne l1
			mov si,0
			
				call Bottom
				jmp return
		l1:
				call Top
			return:

			inc cx
			
			mov al, 0x20
			out 0x20, al ; end of interrupt
			
			pop ax
			iret ; return from interrupt

start:
			xor ax, ax
			xor si,si
			mov es, ax ; point es to IVT base
			
		cli ; disable interrupts
			mov word [es:8*4], timer; store offset at n*4
			mov [es:8*4+2], cs ; store segment at n*4+2
		sti ; enable interrupts
			
			mov dx, start ; end of resident portion
			add dx, 15 ; round up to next para
			mov cl, 4
			shr dx, cl ; number of paras
			mov ax, 0x3100 ; terminate and stay resident
			int 0x21