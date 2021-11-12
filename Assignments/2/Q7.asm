; M Sameer Farooq
; 18L-0986
; CS-D
[org 0x0100]
jmp Start

fun5:
push bp
mov bp,sp
push bx
mov bx,5
pop bx
pop bp
ret

fun1:
push bp
mov bp,sp
push bx
mov bx,1
pop bx
pop bp
ret 

fun3:
push bp
mov bp,sp
push bx
mov bx,3
pop bx
pop bp
ret 

fun4:
push bp
mov bp,sp
push bx
mov bx,4
pop bx
pop bp
ret 

fun2:
push bp
mov bp,sp
push bx
mov bx,2
pop bx
pop bp
ret 

addtoset:
push bp
mov bp,sp
push si
push bx
push ax

mov si,[bp+6]
cmp si,16
jae l1
mov ax,[bp+4]
;mov bx,[bp+8]
mov [arr+si],ax

pop ax
pop bx

l1:
pop si
pop bp

ret 6

callToset:
push bp
mov bp,sp
pusha
push end

mov di,[bp+4]
mov bx,[bp+6]


Lab:
sub di,2
cmp di,-2
je N2
push word[arr+di]
jmp Lab

N2:
ret ; is used to call all function simultaneously
end:
popa
pop bp
ret 2


Start:

push word arr
push 0
push fun1
call addtoset
;pop word [arr]

push word arr
push 2
push fun2
call addtoset
;pop word arr]

push word arr
push 4
push fun3
call addtoset
;pop word [arr]

push word arr
push 6
push fun4
call addtoset
;pop word [arr]

push word arr
push 8
push fun5
call addtoset
;pop word [arr]

push word arr
push 10
call callToset
;pop word [arr]


mov ax, 0x4c00
int 0x21

arr: dw 0