[org 0x0100]

jmp start

delay:

pusha
pushf

mov cx,1000
mydelay:
mov bx,1000      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
mydelay1:
dec bx
jnz mydelay1
loop mydelay


popf
popa


ret



start:

;; Dummy code just to test delay

mov ax,0xb800
mov es,ax
mov di,0

print:
mov word[es:di],0x072A
add di,2
call delay
cmp di,2000
jne print


mov ax,0x4c00
int 21h