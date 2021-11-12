[org 0x100]
jmp start
oldISR: dw 0, 0

tester:
pusha
push es
mov ax, 0xb800
mov es, ax
mov di, 0
inf:
mov ah, 0
int 16h
mov ah, 0x07
stosw
jmp inf

pop es
popa
ret



myISR:
pushf
call far [oldISR]

l1:
cmp al, '9'
jg return
cmp al, '0'
jl return
push bx
mov bh, 0
mov bl, al
sub bl, '0'
mov al, [ascii + bx]
add ah, 30
pop bx

return:
iret

start:	
mov ax, 0
mov di, 0
mov cx, 0
mov es, ax
mov ax, [es:16h*4];
mov [oldISR], ax
mov ax, [es:16h*4+2]
mov [oldISR+2], ax
cli
mov word [es:16h*4], myISR
mov word [es:16h*4+2], cs
sti

call tester

mov ax, 4c00h
int 33

ascii:	db 	112, 113, 119, 101, 114, 116, 121, 117, 105, 111