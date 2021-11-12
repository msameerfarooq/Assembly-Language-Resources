[org 0x0100]

jmp Start

prime:
mov bp,sp
push di
push si
push bx
push ax
mov di,[bp+2]
add di,di
cmp di,0
je label2

label1:
mov ax,di
mov bx,ax
mul bx
mov si,ax
sub si,di
add si,41
mov [bp+di+6],si
sub di,2
cmp di,0
jne label1

label2:
pop ax
pop bx
pop si
pop di

ret 2

Start:
mov si,[size]
push word [num]
push si
call prime
pop ax
mov word [num],ax

mov ax,0x4c00
int 0x21

size: dw 5
num: dw 0,0,0,0,0