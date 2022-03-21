#make_bin#
; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.
; All directives are optional, if you don't need them, delete them.
; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=0500h#
#LOAD_OFFSET=0000h#
; set entry point:
#CS=0500h# ; same as loading segment
#IP=0000h# ; same as loading offset
; set segment registers
#DS=0500h# ; same as loading segment
#ES=0500h# ; same as loading segment
; set stack
#SS=0500h# ; same as loading segment
#SP=FFFEh# ; set to top of loading segment
; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

include emu8086.inc

JMP START
NOTE DB 0Dh,0Ah,'NOTE:PLEASE INTER UNSIGNED NUMBERS FROM 0 TO 255$'
msg1 db 0Dh,0Ah, 'Enter the first number:$'
msg2 db 0Dh,0Ah, 'Enter the second number:$'
err_minus db 0Dh,0Ah, 'The input must be unsigned!!$'
err_great db 0Dh,0Ah, 'The input mustnot be greater than 255!!$'
; 1004h ;the address of the memory where num1 is stored
; 1014h ;the address of the memory where num2 is stored
prim_num db 2h,3h,5h,7h,0Bh,0Ch,11h,13h,1fh

msg3 db 0Dh,0Ah, 'the prime factors of $'
space db ' $'
new_l db 0DH,0AH,' are: $'

msg4 db 0Dh,0Ah, 'the HCF of the two numbers= $'
;1020h ;where prime mo. of 1st digit is stored
;1050h ;where prime mo. of 2st digit is stored
msg5 db 0Dh,0Ah, 'the LCM of the two numbers= $'

START:
; first print NOTE:
mov ah, 9
mov dx, offset NOTE
int 21h
;input of 1st number
mov ah, 9
mov dx, offset msg1
int 21h
Mov di,1000h
call inp_NUM
MOV [1004h],BX ; 1004h the address of the memory where num1 is stored

;input of 2st number
mov ah, 9
mov dx, offset msg2
int 21h
Mov di,1010h
call inp_NUM
MOV [1014h],BX ; 1014h the address of the memory where num2 is stored

;Calculate the primefactors
Mov Bx, 1004h
Mov cx,[bx]
mov ah, 9
mov dx, offset msg3 ;
int 21h
mov ax,cx
call print_num_uns
mov ah, 9
mov dx, offset new_l ;print new line
int 21h
Mov di,1020h ;1020h ;where prime mo. of 1st digit is stored
call prime_fac

;****second no***
Mov Bx, 1014h ; 1014h the address of the memory where num2 is stored
Mov cx,[bx]
mov ah, 9
mov dx, offset msg3
int 21h
mov ax,cx
call print_num_uns

mov ah, 9
mov dx, offset new_l ;print new line
int 21h
Mov di,1050h ;1050h ;where prime mo. of 2st digit is stored
call prime_fac
;Calculate the HCF
mov ax,0
mov al,[1004h]
mov bl,[1014h]
cmp al,bl
jl re
back:
mov ah,0
div bl
cmp ah,0
je end

mov al,bl
mov bl,ah
jmp back
end:
mov ah, 9
mov dx, offset msg4
int 21h
mov ax,0
mov al,bl
call PRINT_NUM_UNS
mov dl,al ;the HCF

;Calculate the LCM
mov ax,0
mov bx,0
mov al,[1004h]
mov bl,[1014h]
mul bl ;Multiplication of the 2 numbers
div dl ;divide the HCF
; al have the LCM
mov bh,al

mov ah, 9
mov dx, offset msg5
int 21h
mov ax,0
mov al,bh
call PRINT_NUM_UNS
HLT ; halt!

;*********************************************
;************functions************************
;*********************************************
;This procedure used to input and check the input
inp_NUM PROC NEAR
PUSH DX
PUSH AX
PUSH SI

MOV CX,0 ;reset counter
MOV BX,0
READ:
; get char from keyboard
; into AL:
MOV AH, 1
INT 21h

; check for MINUS:
CMP AL, '-'
JE error_minus

; check for ENTER key:
CMP AL, 0Dh
JE CALC_num

sub al,30h
MOV [di],AL
inc di
inc cx
CMP CX,4 ;check if overflow
jnl overfl

JMP READ
error_minus: ;message if the input is signed

mov ah, 9
mov dx, offset err_minus
int 21h
jmp START

overfl: ;message if overflow
mov ah, 9
mov dx, offset err_great
int 21h
jmp START

greater: ;message if the input is greater than 255
mov ah, 9
mov dx, offset err_great
int 21h
jmp START

CALC_num:
dec di
mov al,1h
mul [di]
ADD bX,AX
dec di
Mov al,0Ah
MUL [di]
ADD BX,AX
DEC di
mov al,64h
MUL [di]
ADD BX,AX
CMP BX,255
JNL greater
POP SI
POP AX
POP DX
RET
inp_NUM ENDP
;************************
newprime:
mul bl
ADD AL,cl
inc si
jmp fac

printf:
mov cx,ax
Mov ax,bx
mov [di],ax
inc di
call print_num_uns
mov ah, 9
mov dx, offset space
int 21h
mov ax,cx
jmp next

;This procedure used to input and check the input
prime_fac PROC NEAR
PUSH DX
PUSH AX
PUSH SI

MOV si,0 ;reset counter
mov bx,0 ;reset the div
Mov ax,cx
mov cx,0 ;reset for get reminder
fac:
MOV bl,prim_num[si]
div bl
cmp AH,0
mov cl,ah
JNE newprime
jmp printf ;to print the prime no and store them
next:
cmp ax,1
je exit
jmp fac

exit:
mov [di],'$' ;termination for prime factors
POP SI
POP AX
POP DX
RET
prime_fac ENDP
;********
re:
mov al,[1014h]
mov bl,[1004h]
jmp back
DEFINE_PRINT_NUM_UNS
END
