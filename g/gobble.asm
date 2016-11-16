COMMENT @

          This is the assembly language listing for GOBBLE.COM, another
          resident nuisance. GOBBLE produces a simple PacMan (*) image
          on the screen at regular intervals. The PacMan displayed
          then gobbles up four lines of the current screen image, moving
          from the right to the left edge of the screen and buzzing
          merrily. The interval between two PacMan appearances is preset
          to 5 minutes and can be adjusted within a range of 1 to 60 minutes.
          Just enter GOBBLE /?? from the command line, where '??' means
          a number between 1 and 60.

          GOBBLE (C)Copyright 1988 by Joachim Schneider, Zell am See.
          All rights reserved.

          (*) PacMan is a Registered Trademark of Atari Corp.
@
          
_TEXT          SEGMENT BYTE PUBLIC 'CODE'
               ASSUME CS:_TEXT, DS:_TEXT

MAIN           PROC  FAR
               JMP   INSTALL           ; jump to install procedure
               MAIN  ENDP

P_BLOCK        DB 219,248,223,248,219,  7,219,  7,219,7,220,7, 32,7,32,7,32,7
               DB 219,135,219,135,219,135,219,135,219,7,219,7,219,7,32,7,32,7
               DB 219,248,220,248,219,  7,219,  7,219,7,223,7, 32,7,32,7,32,7

LPCT           DB    0,0               ; auxiliary counters for sound timing
COUNT          DW    0                 ; clock tick count
D_COUNT        DW    5460              ; alarm tick count
VSAVE          DD    0                 ; save area for old interrupt vector
SCNT           DW    0                 ; holds current frequency
SW_1           DB    0                 ; sound synchronization aux counter
SCRSEG         DW    0B000H            ; regen buffer base address

GSXX:          PUSHF
               CALL  CS:[VSAVE]        ; call old interrupt handler
               STI
               PUSH  DS
               PUSH  CS
               POP   DS                ; set DS equal to CS
               INC   COUNT             ; bump clock tick count
               PUSH  AX
               MOV   AX,COUNT          ; load current count value
               CMP   AX,D_COUNT        ; reached destination value ?
               POP   AX
               JA    P10               ; yes, set PacMan in motion
               JMP   END_IT            ; else do nothing further
P10:           MOV   COUNT,0           ; re-initialize tick count
               PUSH  DI
               PUSH  SI
               PUSH  DX
               PUSH  CX                ; save caller's registers
               PUSH  BX
               PUSH  AX
               PUSH  ES
               INT   11H               ; get BIOS equipment list
               AND   AL,30H            ; isolate initial video mode bits
               CMP   AL,30H            ; 80-column mono ?
               JNE   S01               ; no, for PC/XT/AT suppose 80-col color
               MOV   AX,0B000H         ; load mono regen buffer address
               JMP   S02
S01:           MOV   AX,0B800H         ; load color regen buffer address
S02:           MOV   ES,AX             ; point ES to regen buffer
               MOV   CX,71             ; # of columns PacMan will move
               MOV   SW_1,0            ; initialize sound timing control
G01:           PUSH  CX
               MOV   BH,8              ; upper image row in BH
               MOV   AL,0A0H           ; load # of bytes for 1 row
               MUL   BH                ; times the line number
               MOV   DI,AX
               SHL   CL,1
               ADD   DI,CX             ; upper left edge address in DI
               MOV   SI,OFFSET P_BLOCK ; set index to start of image
               INC   SW_1              ; bump sound control counter
               CMP   SW_1,2            ; sound effect required ?
               JNZ   G12               ; no, skip sound generation
               MOV   SW_1,0            ; re-initialize sound control
               MOV   CX,20             ; load loop counter
               MOV   SCNT,2000         ; load initial frequency count
G02:           PUSH  CX
               MOV   CX,3
               MOV   BX,SCNT
               CALL  GENSOUND          ; activate speaker
               SUB   SCNT,60           ; increase frequency
               POP   CX
               LOOP  G02               ; play next tone
               JMP   SHORT G11         ; continue animation
G12:           MOV   CX,10000
P03:           LOOP  P03               ; timing loop
G11:           XOR   CX,CX             ; initialize character counters
               MOV   DX,309H           ; load image size; DH=rows, DL=columns
P01:           PUSH  DI                ; saved regen buffer index
P02:           MOVSW                   ; move one character/attribute
               INC   CL                ; bump column count
               CMP   CL,DL             ; one line finished ?
               JNE   P02               ; no, do next column
               INC   CH                ; yes, bump row count
               XOR   CL,CL             ; reset column count
               POP   DI                ; restore regen buffer index
               ADD   DI,0A0H           ; point DI to beginning of next line
               CMP   CH,DH             ; all lines printed ?
               JNE   P01               ; no, continue w/ next line
               POP   CX                ; reload PacMan motion counter
               SUB   CX,2
               JNS   G01               ; repeat until column <= 0
               MOV   BX,0800H          ; line/column position
               MOV   AX,0A0H
               MUL   BH
               MOV   DI,AX
               SHL   BL,1
               XOR   BH,BH
               ADD   DI,BX             ; index into regen buffer
               MOV   CX,240            ; load counter
               MOV   AX,720H           ; load character/attribute
               REP STOSW               ; erase 4 lines where PacMan lives
               POP   ES                ; restore saved registers
               POP   AX
               POP   BX
               POP   CX
               POP   DX
               POP   SI
               POP   DI
END_IT:        POP   DS
               IRET

COMMENT * Put (1193182/freq) in BX
          put time units in CX, 1 unit is approx. 2.6 millisecs *

GENSOUND       PROC  NEAR
               MOV   AL,182
               OUT   67,AL             ; prepare timer for new count
               MOV   AX,BX
               OUT   66,AL             ; send count lsb
               MOV   AL,AH
               OUT   66,AL             ; send count msb
               IN    AL,97      
               OR    AL,3
               OUT   97,AL             ; turn on the speaker
S03:           INC   LPCT              ; wait time unit
               JNZ   S03
               INC   LPCT+1
               LOOP  S03               ; ... wait a little longer ...
               IN    AL,97 
               AND   AL,252
               OUT   97,AL             ; turn speaker off
               RET
               GENSOUND ENDP

         DB    'GOBBLE (C)Copyright 1988 by Joachim Schneider, Zell am See.'
         DB    'All rights reserved.'

INSTALL        PROC  NEAR
               CALL  EVALSW            ; evaluate runtime switch if present
               JC    INST01            ; invalid switch - quit
               MOV   AX,DS
               ADD   AX,10H
               MOV   DS,AX             ; adjust DS to exclude PSP size
               MOV   AX,351CH
               INT   21H                    ; get current INT 1Ch vector
               MOV   WORD PTR VSAVE,BX      ; save offset
               MOV   WORD PTR VSAVE+2,ES    ; and segment
               MOV   DX,OFFSET GSXX         ; load interrupt routine offset
               MOV   AX,251CH
               INT   21H                    ; set new interrupt vector
               MOV   AX,3100H
               MOV   DX,OFFSET INSTALL+100H ; load # of bytes occupied
               MOV   CL,4
               SHR   DX,CL             ; convert from bytes to paragraphs
               INC   DX                ; round value
               INT   21H               ; terminate-stay-resident
INST01:        MOV   AX,4C00H
               INT   21H               ; normal terminate in case of error
               INSTALL ENDP

COMMENT * STR_TO_INT converts the ASCIIZ string in decimal notation
          pointed to by DS:SI to an unsigned binary 16-bit-integer.
          If an invalid digit is encountered or the value is larger
          than 0FFFFH the CY flag will be set. On return, AX contains
          the integer value. *

STR_TO_INT     PROC  NEAR
               PUSH  BX
               PUSH  CX
               PUSH  DX
               XOR   AX,AX             ; clear AX
               MOV   BH,AH
               MOV   CX,10             ; factor for multiplication
STRTI05:       LODSB                   ; load character
               OR    AL,AL             ; end-of-string ?
               JZ    STRTI01           ; yes, nothing to convert
               CMP   AL,20H            ; blank ?
               JZ    STRTI05           ; yes, skip
               CMP   AL,'0'            ; check for digit
               JB    STRTI04           ; error: can't be digit
               CMP   AL,'9'
               JA    STRTI04           ; error: can't be digit
               SUB   AL,'0'            ; convert digit to binary value
STRTI03:       MOV   BL,[SI]           ; load next character
               INC   SI                ; bump index
               OR    BL,BL             ; end-of-string ?
               JZ    STRTI01           ; yes, end conversion
               CMP   BL,'0'            ; does BL contain a digit ?
               JB    STRTI04           ; no, flag error
               CMP   BL,'9'
               JA    STRTI04           ; error - no digit
               SUB   BL,'0'            ; convert BL to binary value
               MUL   CX                ; shift current value by 10
               JC    STRTI02           ; exit if overflow
               ADD   AX,BX             ; add current digit
               JC    STRTI02           ; exit if overflow
               JMP   SHORT STRTI03     ; go read next character
STRTI04:       STC                     ; set CF to 1, i.e. flag an error
               JMP   SHORT STRTI02     ; and exit
STRTI01:       CLC                     ; no error - clear CF
STRTI02:       POP   DX
               POP   CX
               POP   BX                ; restore registers
               RET
               STR_TO_INT ENDP

COMMENT * EVALSW will interpret the given runtime switches if available.
          On return, the CY flag will be set if there was an invalid parm,
          otherwise CF is clear. *

EVALSW         PROC NEAR
               MOV   CL,DS:80H         ; get length of command tail
               XOR   CH,CH
               JCXZ  EW01              ; nothing there, exit
               MOV   DI,81H            ; point DI to 1st character of tail
               CLD
EW05:          MOV   AL,'/'
               REPNZ SCASB             ; scan command tail for slash
               JCXZ  EW01              ; none found - quit
               MOV   SI,DI             ; copy string pointer
               CALL  STR_TO_INT        ; convert string to binary integer
               OR    AX,AX             ; invalid or 0 ?
               JZ    EW04              ; yes, flag error
               CMP   AX,60             ; larger than 60 ?
               JA    EW04              ; yes, flag error
               MOV   BX,1092           ; convert minute count ...
               MUL   BX                ; ... to clock tick count
               MOV   D_COUNT+100H,AX   ; and save destination count
               JMP   SHORT EW01
EW04:          MOV   DX,OFFSET ILLPARM+100H
               MOV   AH,9
               INT   21H               ; display error message
               STC                     ; and flag error
               JMP   SHORT EW08
EW01:          CLC                     ; no error
EW08:          RET
               EVALSW ENDP

ILLPARM        DB    'Error: Minute count must be in range 1 to 60.',7,'$'

               _TEXT  ENDS
               END
