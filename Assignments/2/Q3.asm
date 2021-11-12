; M Sameer Farooq
; 18L-0986
; CS-D
[org 0x0100]
jmp Start

FSeries:
push bp
mov bp,sp
push bx
push ax
push si

mov si,[bp+4]
mov bx,[bp+6]	; current
mov ax,[bp+8]	; prev
mov [bp+8],word 0

cmp si,0
je label2
add ax,bx

cmp si,1
ja label1
mov [bp+8],bx

label2:
pop si
pop ax
pop bx
pop bp
ret 4
label1:
sub si,1
call FSeries
pop word[bp+8]
pop bp
ret 4

Start:
 mov si,12

 push 0		; previous
 push 1		; current
 push si	; number
 call FSeries
 pop ax

mov ax, 0x4c00
int 0x21