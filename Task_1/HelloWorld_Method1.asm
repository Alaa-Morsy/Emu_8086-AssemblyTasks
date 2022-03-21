org 100h
; set video mode
mov ax, 3 text mode 80x25, 16 colors, 8 pages (ah=0, al=3)
int 10h ; do
; cancel blinking and enable all 16 colors:
mov ax, 1003h
mov bx, 0
int 10h
; set segment register:
mov ax, 0b800h
mov ds, ax
; first
byte is ascii code, second byte is color code.
mov [02h], 'A'
mov [04h], 'L'
mov [06h], 'A'
mov [08h], 'A'
mov [0ah], ' '
mov [0ch], 'M'
mov [0eh], 'O'
mov [10h], 'H'
mov [12h], 'A'
mov [14h], 'M'
mov [16h], 'E'
mov [18h], 'D'
mov [1ah], ' '
mov [1ch], 'M'
mov [1eh], 'O'
mov [20h], 'R'
mov [22h], 'S'
mov [24h], 'Y'
mov cx, 18 ; number of characters characters.
mov di, 03h ; start from byte after '
;first loop
c: mov [di], 11111001b ; light blue(1001) on white(1111)
add di, 2 skip over next ascii code in vga memory.
loop c

;ID part
mov [0a2h], 'I'
mov [0a4h], 'D'
mov [0a6h], '='
mov [0a8h], '4'
; color all characters:
mov cx, 4 ; number of characters
mov di, 0a3h ; start from byte after '
d: mov [di], 11111101b ; light magenta (1101) on white(1111)
add di, 2 ; skip over next ascii code in vga
loop d

; Academic ID part
mov [142h], 'A'
mov [144h], 'C'
mov [146h], 'D'
mov [148h], '_'
mov [14ah], 'I'
mov [14ch], 'D'
mov [14eh], '='
mov [150h], '0'
mov [152h], '1'
mov [154h], '7'
mov [156h], '0'
mov [158h], '0'
mov [15ah], '4'
mov [15ch], '2'
mov [15eh], '6'
; color all characters:
mov cx, 15 ; number of characters characters.
mov di, 143h ; start from byte after 'A A'
e: mov [di], 11111101b ; light magenta (1101 ) on white(1111)
add di, 2 ; skip over next ascii code in vga
loop e
; wait for any key press:
mov ah, 0
int 16h
ret

