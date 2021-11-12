; M Sameer Farooq
; 18L-0986
; CS-D
[org 0x0100]
jmp Start

switch_stack:

push bp
mov bp,sp
pusha
push es
mov si,0xFFFE	; points to the last element of stack segment
mov bx,sp
mov di,[bp+4]
mov es,[bp+6]

 mov ax,es
 mov ss,ax
 mov sp,di

sub bx,2


L3:
sub si,2
cmp si,bx
je Label1
push word [si]
jmp L3

Label1:

pop es 
popa 
pop bp


ret 4
Start:
push word [new_stack_segment]
push word [new_stack_offset]
call switch_stack

mov ax, 0x4c00
int 0x21

new_stack_segment: dw 0x1100
new_stack_offset: dw 0x10