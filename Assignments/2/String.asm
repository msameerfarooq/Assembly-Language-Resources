; M Sameer Farooq
; 18L-0986
; CS-D
[org 0x0100]
jmp Start

Find_A_Sub_String:
push bp
mov bp,sp
push word string
push word substr1
pusha

mov ax,[bp+4]
mov [string],ax
mov ax,[bp+6]
mov [substr1],ax
xor ax,ax
;mov si,[bp+4]
;mov cx,[bp+4]	; string
;mov dx,[bp+6]	; sub string
mov si,0
mov di,0
; cx and dx to store string and substring
label1:

mov al,[string+si]	; any 8 bit register will be used because we have string of byte type
cmp al,0
je stringends

label2:

mov al,[substr1+di]
cmp al,0
je Found1
cmp al,[string+si]
jne NotEqual

add di,1
add si,1

jmp label1
NotEqual:

sub si,di
add si,1
mov di,0

jmp label1

stringends:
add di,1
mov dx,[substr1+di]	;; sentinal value of substring is still to be compared
cmp cx,dx
jne notFound

Found1:
mov bx,1
shr bx,1

notFound:
pop word [substr1]
pop word [string]

popa
pop bp
ret ;2

Start:

push 0
push word [substr1]
push word [string]
;push word [len]

call Find_A_Sub_String
pop word [string]
pop word [substr1]

mov ax, 0x4c00
int 0x21

;len: dw 3
string: db "Marry has a little lamb",0		; 10111010
substr1: db "lamb",0						; 1101