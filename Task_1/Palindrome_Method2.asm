org 100h
jmp start
N db 'Alaa Mohamed Morsy'
db 0Dh,0Ah,'$'
ID db ' ID=4'
db 0Dh,0Ah,'$'
AC db ' Academic_ID=01700426'
db 0Dh,0Ah,'$'
start:
; first let's print it:
mov ah, 9
mov dx, offset N
int 21h
; print ID:
mov ah, 9
mov dx, offset ID
int 21h
; print Academic ID:
mov ah, 9
mov dx, offset AC
int 21h
ret
