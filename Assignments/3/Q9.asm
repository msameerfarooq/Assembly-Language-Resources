				[org 0x0100]
				jmp Start
	
	CalculateQueueAddress:
				push bp
				mov bp,sp
				
				mov ax,[bp+4]		; queue number
				mov bx,64
				mul bx
				mov bx,ax
				add bx,array0	; address of array
				mov [bp+6],bx
				pop bp
				ret 2
	
	qcreate:	; it takes a parameter, when this function is called, it returns 1 if empty queue is available otherwise 0.
				push bp
				mov bp,sp
				pusha
				mov bx,[mask]
				mov si,0
		Loop1:
				cmp si,16
				jge EndOfLoop1
				test bx,[pool]		; nth bit of pool indicates that either it's array has data or not
				jz EndOfLoop1
				add si,1
				shl bx,1
				jmp Loop1
		EndOfLoop1:
				add [pool],bx
				cmp si,16
				jne PoolAvailable
				mov si,-1
				
		PoolAvailable:
				mov [bp+4],si
				popa
				pop bp
				ret

	qdestroy:
	; it takes queue number that we want to destroy and free the queue and put 0 on the nth bit,that we destroyed. and returns nothing
				push bp
				mov bp,sp
				pusha

				push 0
				push word[bp+4]	; queue number that we want to delete
				call CalculateQueueAddress
				pop bx
				mov si,-2
				
		Loop2:
				add si,2
				cmp si,64	; 32*2=64
				jge EndOfLoop2
				mov [bx+si],word 0
				jmp Loop2
		EndOfLoop2:
		
				mov bx,1111111111111110b
				mov cx,[bp+4]
				cmp cx,0
				je Loop3Ends
		Loop3:
				rol bx,1
				loop Loop3
		Loop3Ends:
				and [pool],bx
				popa
				pop bp
				ret 2
				
	qadd:		; 30 bits of data |  31st bit front index | 32nd bit rear index 
	; it takes queue number , data and space for boolean variable ,that either data enter in queue or not.
				push bp
				mov bp,sp
				pusha
				
				; calculate the address of queue
				push 0
				push word[bp+4]	; queue number that we want to delete
				call CalculateQueueAddress
				pop bx
				
				; if queue is complete then tail would be pointing to -1
				mov ax,[bx+62]	
				cmp ax,-1
				je label1 ;	this jump will take when array is completed 
					
				; here queue have some space
				mov di,[bx+62]	; tail
				mov ax,[bp+6]	; data ,that we want to enter in queue
				mov [bx+di],ax
				add word[bx+62],2	; increment the tail
				
				cmp word[bx+62],60	; compare the tail
				jb DontTakeModulous
				
				sub word[bx+62],60	; wraparound the queue
				
		DontTakeModulous:		
				
				mov ax,[bx+62]		; check wheather queue completed or not
				cmp [bx+60],ax
				jne QueueIsNotCompleted
				mov word [bx+62], -1
				
		QueueIsNotCompleted:
				mov word [bp+8],1
				jmp ValueAdded
				
		label1:		
				mov word [bp+8],0
				
		ValueAdded:		
				popa
				pop bp
				ret 4
				
	qremove:		; 30 bits of data |  31st bit front index | 32nd bit rear index 
				; it takes queue number and a space for boolean ,that data is removed or not
				push bp
				mov bp,sp
				pusha
				
				; calculate the address of queue
				push 0
				push word[bp+4]	; queue number that we want to delete
				call CalculateQueueAddress
				pop bx
				
				; if queue is empty
				mov ax,[bx+62]	
				cmp ax,[bx+60]
				je label2 ;	this jump will take when queue is empty 
					
				; here queue have some space
				mov di,[bx+60]	; head
				cmp word [bx+62],-1	; check if the queue is completely filled
				jne label3
				mov [bx+62],di	; mov index of head to the tail and increment head
		label3:
				mov word [bx+di],0	; this instructions is extra, but helpful in visual representation for debugging. 
				mov word [bp+6],1	; return 1, that data from queue is removed successfully.
				add word[bx+60],2	; increment the head
				
				cmp word[bx+60],60	; compare the tail
				jb ValueRemoved
				
				mov word [bx+60],0	; wraparound the queue		
				jmp ValueRemoved
				
		label2:		
				mov word [bp+6],0
				
		ValueRemoved:		
				popa
				pop bp
				ret 2				


	Start:
				push word 0
				call qcreate ; it return either (0-15) * -1
				pop si	; free queue number is here or -1 is here that means none of any queue is free

				push word 0	; space for boolean variable that we return
				push word 7	; data
				push si	; queue number
				call qadd
				pop ax 	; 1 means data is added otherwise queue is empty for returning 0.
				
				push word 0	; space for boolean variable that we return
				push word 15	; data
				push si	; queue number
				call qadd
				pop ax
				
				push word 0
				push si
				call qremove
				pop ax
				
				push si
				call qdestroy
				
				mov ax,0x4c00
				int 0x21
				
	array0:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array1:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array2:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array3:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array4:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array5:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array6:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array7:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array8:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array9:		dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array10:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array11:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array12:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array13:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array14:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	array15:	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
	pool:		dw 0
	mask:		dw 1