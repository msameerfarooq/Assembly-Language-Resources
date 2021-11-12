[org 0x0100]
jmp start

array1: dw 6, 7,3, 9, 100, 5, 1, 50
lenArray1: dw 8

bubblesort:   
push bp                 ; save old value of bp               
mov  bp, sp             ; make bp our reference point               
sub sp, 2               ; make two byte space on stack               
push ax                ; save old value of ax               
push bx                 ; save old value of bx               
push cx                 ; save old value of cx               
push si                 ; save old value of si 
 
mov  bx, [bp+6]         ; load start of array in bx               
mov  cx, [bp+4]         ; load count of elements in cx               
dec  cx                 ; last element not compared               
shl  cx, 1              ; turn into byte count 
 
mainloop:     
mov  si, 0              ; initialize array index to zero               
mov  word [bp-2], 0     ; reset swap flag to no swaps 
 
innerloop:    
mov  ax, [bx+si]        ; load number in ax               
cmp  ax, [bx+si+2]      ; compare with next number               
jbe  noswap             ; no swap if already in order 
 
xchg ax, [bx+si+2]      ; exchange ax with second number               
mov  [bx+si], ax        ; store second number in first               
mov  word [bp-2], 1     ; flag that a swap has been done 
 
noswap:       
add  si, 2              ; advance si to next index               
cmp  si, cx             ; are we at last index               
jne  innerloop          ; if not compare next two                    
cmp  word [bp-2], 1     ; check if a swap has been done                 
je   mainloop           ; if yes make another pass  
 
pop  si                 ; restore old value of si               
pop  cx                 ; restore old value of cx               
pop  bx                 ; restore old value of bx               
pop  ax                 ; restore old value of ax               
mov  sp, bp             ; remove space created on stack               
pop  bp                 ; restore old value of bp               
ret  4 




statOfArray:
; this function will take one array as input 
; and will return min, max and median of array.
; median is the middle element of sorted array
; write your function here
push bp
mov bp,sp
push ax
push bx
push cx
push si

mov bx,[bp+6]
push bx
mov bx,[bp+4]
push word [bx]
call bubblesort

; for minimum
mov si,0
mov bx,[bp+6]
mov ax,[bx+si]
mov [bp+8],ax

; for median
mov si,[lenArray1]
mov ax,[bx+si]
mov [bp+10],ax

; for maximum
sub si,1
shl si,1
mov ax,[bx+si]
mov [bp+12],ax

pop si
pop cx
pop bx
pop ax
pop bp

ret 4


start:
; make space for o/p
push word 0
push word 0
push word 0
; push inputs for array1
push array1
push lenArray1

call statOfArray
pop ax ; ax should be min of array
pop bx ; ax should be max of array
pop cx ; ax should be median of array
mov ax, 0x4c00
int 21h