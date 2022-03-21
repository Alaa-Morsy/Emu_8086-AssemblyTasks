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
#ES=1500h#	; same as loading segment

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

; add your code here    

 JMP START
 ENTER db 0dh,0ah,'PLEASE:ENTER YOUR PASSWORD_9 CHAR:$'
 CORRECT db 0DH,0AH,"YOUR PASSWORD IS CORRECT$"
 WRONG db 0DH,0AH,"WORNG PASSWORD!!$"
  NUM=9H


 START:
 ;the origin password \Loli@250F\
  mov bx,500h
  Mov [bx+0Ah],'L'
  mov [bx+0Bh],'o'
  mov [bx+0ch],'l'
  mov [bx+0dh],'i'
  mov [bx+0eh],'@'
  mov [bx+0fh],'2'
  mov [bx+10h],'5'
  mov [bx+11h],'0'
  mov [bx+12h],'F'
  
prog: 
  mov bx,500h
  LEA bx,[bx+0ah]   ;the place of the lookup table
  mov cX,NUM 

  ;askng for the password
  
  mov ah,9
  mov dx,offset ENTER
  int 21h
  
    
  
 mov di,0
 CLD 
 mov AX,0
begin: 
;get the char into AL 
  mov ah,1
  int 21h                    
  
  ; check for ENTER key:
  CMP  AL, 0Dh  
  JE   endl  
                     
 STOSB   ;store in ES
 JMP begin
 endl:
    mov cx,NUM
    cmp cx,di  ;compare no. of entered pass.
    jne wrongP
    
    
    MOV SI,bx 
    mov di,0
    mov cx,NUM 
 e:   
    REPE CMPSB 
    jcxz same
    jz e 
    
WrongP:   
    mov ah,9
    mov dx,offset WRONG
    int 21h   
    jmp prog
    
same:
     mov ah,9
    mov dx,offset CORRECT
    int 21h 

HLT           ; halt!

;the Run
;**************
;PLEASE:ENTER YOUR PASSWORD_9 CHAR:loli  
;WORNG PASSWORD!!
;PLEASE:ENTER YOUR PASSWORD_9 CHAR:Loli2250f 
;WORNG PASSWORD!!
;PLEASE:ENTER YOUR PASSWORD_9 CHAR:Loli@250F
;YOUR PASSWORD IS CORRECT
