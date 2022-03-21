#make_bin#

; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.

; All directives are optional, if you don't need them, delete them.

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=0500h#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0500h#	; same as loading segment
#IP=0000h#	; same as loading offset

; set segment registers
#DS=0500h#	; same as loading segment
#ES=0500h#	; same as loading segment

; set stack
#SS=0500h#	; same as loading segment
#SP=FFFEh#	; set to top of loading segment

; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h# 

include emu8086.inc

JMP start
err_minus db 0Dh,0Ah, 'The input must an integer!!$'
err_great db 0Dh,0Ah, 'The input mustnot be greater than 255!!$'
Note db ' You are alowed to enter numbers up to 255$'
msg1 db 0dh,0ah,'Please,Enter how many numbers you want to enter: $'
msg2 db 0dh,0ah,'Enter the nmber : $'
;1010h Number of numbers
;1011h the numbers
;1100 odd no.s sorted asending
;1200 even no. sorted descending
msg_odd db 0dh,0ah,'The odd numbers are: $'
msg_even db 0dh,0ah,'The even numbers are: $'
space db ' $'

start: 
 
; first print NOTE:
  mov ah, 9
  mov dx, offset Note
  int 21h   
;print msg1  
   mov ah, 9
  mov dx, offset msg1
  int 21h 
  ;get the no. of numbers in AL 
 
 call inp_NUM
 MOV  [1009h],BX  ; 1004h the address of the memory where no. of numbers is stored

 
 ;Entering the numbers
 mov ch,0
 mov cl,[1009h]
   
 ;memory location begin to store the numbers 
  
   mov di,1010h
NO.Enter: 
 ;print msg2  
   mov ah, 9
  mov dx, offset msg2
  int 21h 
  ;get the number
 call inp_NUM 
 mov [di],bx 
 INC di
 
 LOOP NO.Enter 

push si 
 mov bx,0
 mov cx,0
 mov si,0 
 mov di,0
odd/even:   ;classification
 mov cl,[1010h+si]
 mov ah,0  
 mov al,[1010h+si] ;mov the no. to the accumlator
 mov ch,2  
 div ch    ; div by 2
 cmp ah,1
 je  odd
 jmp  even 
endl:
 inc si
 cmp si,[1009h] ;compare with no. of numbers
 jne odd/even 
 
 mov [1300h],bx ;record no. of odd
 mov [1302h],di ;record no. of even
 
 pop si 
 
 ;for odd numbers 
 mov al,0
 mov ah,0
 mov bx,0
 mov cx,0
   
 mov al,[1300h]
 mul [1300h]   ;check n^2
 mov dx,ax
 
 
odd_sort:  ;BUbble sorting
 mov al,[1100h+bx]
 mov ah,[1100h+bx+1] 
 inc cx
 cmp al,ah
 ja  al_bigger  ;ascenging order
 e:
 inc bx
 cmp bx,[1300h]
 je  resetO
 contO:
 cmp cx,dx
 jne odd_sort
 
  ;for even numbers 
 mov al,0
 mov ah,0
 mov bx,0
 mov cx,0 
 
 mov al,[1302h]
 mul [1302h]   ;check n^2
 mov dx,ax
 
even_sort: 
 mov al,[1200h+bx]
 mov ah,[1200h+bx+1]
 inc cx
 cmp al,ah
 jb  al_smaller ;descending order 
 f:
 inc bx
 cmp bx,[1302h]
 je  resetE
 contE:
 cmp cx,dx
 jne even_sort  
 
 mov bx,0

 mov ah, 9
 mov dx, offset msg_odd
 int 21h 
print_odd:
 mov dl,[1101h+bx]
 mov ax,0 
 mov al,dl 
 
 call PRINT_NUM_UNS 
  
 mov ah, 9
 mov dx, offset space
 int 21h  
 
 inc bx
 cmp bx,[1300h]
 jne print_odd 
 
  mov bx,0

 mov ah, 9
 mov dx, offset msg_even
 int 21h 
print_even: 
 mov dl,[1200h+bx]
 mov ax,0 
 mov al,dl 
 
 call PRINT_NUM_UNS 
  
 mov ah, 9
 mov dx, offset space
 int 21h  
 
 inc bx
 cmp bx,[1302h]
 jne print_even
 
 




HLT           ; halt! 

 odd:
 mov [1100h+bx],cl
 inc bx
 jmp endl 
 
 even:
 mov [1200h+di],cl
 inc di
 jmp endl 
 
 al_bigger:  ;odd sorting(ascending)
 mov [1100h+bx+1],al
 mov [1100h+bx],ah
 jmp  e 
 
 al_smaller:
 mov [1200h+bx+1],al
 mov [1200h+bx],ah
 jmp  f    
 
  resetO:   ;reset odd loop
 mov bx,0
 jmp contO 
 
  resetE:  ;reset even loop
 mov bx,0
 jmp contE

 ;*********************************************
 ;************functions************************
 ;*********************************************                
;This procedure used to input and check the input                 
 inp_NUM        PROC    NEAR
  PUSH  DX
  PUSH  AX  
  PUSH  CX
  PUSH  SI
  PUSH  DI
        
  MOV   CX,0 ;reset counter 
  MOV   BX,0 
  MOV   di,1000h
READ:  
 ; get char from keyboard
 ; into AL:
 MOV  AH, 1
 INT  21h 
 
 ; check for MINUS:
 CMP     AL, '-'
 JE      error_minus   
 
 ; check for ENTER key:
 CMP  AL, 0Dh  
 JE   CALC_num

 sub  al,30h
 MOV  [di],AL 
 inc  di 
 inc  cx 
 CMP  CX,4 ;check if overflow
 jnl  overfl
    
 JMP  READ
 error_minus:  ;message if the input is signed

  mov ah, 9
  mov dx, offset err_minus
  int 21h
  jmp START 
  
overfl:  ;message if overflow
   mov ah, 9
  mov dx, offset err_great
  int 21h
  jmp START 
  
  greater:   ;message if the input is greater than 255
   mov ah, 9
  mov dx, offset err_great
  int 21h
  jmp START    
 
 CALC_num:
 dec  di
 mov  al,1h
 mul  [di] 
 ADD  bX,AX
 dec  di 
 Mov  al,0Ah
 MUL  [di]
 ADD  BX,AX
 DEC  di 
 mov  al,64h
 MUL  [di]
 ADD  BX,AX 
 CMP  BX,255
 JNL greater   
 
  POP   DI
  POP   SI
  POP   CX
  POP   AX
  POP   DX
  RET
  inp_NUM   ENDP  
 
 ;************
  
 DEFINE_PRINT_NUM_UNS
 END 

