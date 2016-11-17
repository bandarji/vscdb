;Filename:   PINGB-S.ASM
TITLE  Ping Pong "B" virus visual effect simulator

COMMENT #     Read the following carefully:

              THIS FILE IS INTENDED FOR EXAMINATION ONLY.

DISCLAIMER: The author will NOT be held responsible for any damages
            caused by careless use of the information presented here.

        This file is NOT a virus program! It is ONLY a simulation!

This file, when assembled, will produce an .COM file that can be run from
the DOS command line.  This is a TSR program, and when loaded, will exactly
mimic the Ping Pong B's activation sequence for the bouncing ball effect.
Once the TSR is loaded, it cannot be stopped, except by forced unloading
of the virus by one of the various TSR unloaders, or a reboot.

#  End of comment


LOCALS

LF  EQU 10
CR  EQU 13

        LOW_MEM_DATA    SEGMENT AT 0H   ;Bottom of memory space
        ORG 0H      ;Interrupt vector space
DUMMY_ADDRESS   LABEL   FAR     ;Dummy address used for patching

        ORG 0020H
INT8_OFS    DW ?            ;INT 8h vector offset & segment
INT8_SEG    DW ?

        ORG 0040H
INT10_OFS   DW ?
INT10_SEG   DW ?

        LOW_MEM_DATA    ENDS

            SIMULATION  SEGMENT
            ASSUME  CS:SIMULATION
            ORG 0080H
ORG_INT8    DD ?        ;Original contents of the INT 8h,
ORG_INT10   DD ?        ; INT 10h and
ORG_INT13   DD ?        ; INT 13h interrupt vectors

ORG_CHAR    DW ?        ;Original screen character and attribute.
BALL_POS    DW ?        ;Bouncing ball's XY position.
BALL_INC    DW ?        ;Ball's XY increment
VIDEO_PARAMS    DW ?        ;Mode number and page number.

FLAGS       DB ?
GRAF_MODE   DB ?        ;1 = graphics mode, otherwise it's a text mode.
SCRN_COLS   DB ?        ;Number of screen columns minus 1
SCRN_ROWS   DB ?        ;Number of screen rows minus 1

            ORG 0100H
START_HERE:
    JMP GO_TSR      ;TSR the simulation code

            ASSUME  DS:NOTHING,ES:NOTHING

NEW_INT13   LABEL   FAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DS

    PUSH CS
    POP DS
            ASSUME  DS:SIMULATION
    MOV AH,2
    INT 16H             ;Get keyboard status flags
    TEST AL,00010000B       ;Mask the Scroll Lock enabled bit.
    JNZ @@SET_BALL          ;If set, then install the bouncing ball
    XOR AH,AH
    INT 1AH             ;Get clock tick count
    TEST DH,07FH            ;Is it the right time to activate
    JNZ @@END           ; the bouncing ball display?
    TEST DL,0F0H
    JNZ @@END
  @@SET_BALL:
    OR FLAGS,00000010B      ;Set "installed" flag
  @@END:
    POP DS
            ASSUME  DS:NOTHING
    POP DX
    POP CX
    POP BX              ;Restore caller's registers
    POP AX
    JMP CS:ORG_INT13

            ASSUME  DS:NOTHING

NEW_INT8    LABEL   FAR     ;New INT 8 handler
    TEST CS:FLAGS,00000010B     ;Is INT 8 or INT 10h active already?
    JNZ @@OK            ;If so, then exit immediately.
    JMP CS:ORG_INT8
  @@OK:
    PUSH DS
    PUSH AX
    PUSH BX             ;Save affected registers
    PUSH CX
    PUSH DX

    PUSH CS
    POP DS
            ASSUME  DS:SIMULATION
    MOV AH,0FH          ;Get video mode, page, and # of columns
    INT 10H
    MOV BL,AL           ;Move mode number into BL
;If the video mode and page are the same as last time, then continue bouncing
;the ball.  Otherwise, reset the ball position and increment, and start anew.
;Note: The active page number is in BH throughout this routine.
    CMP BX,VIDEO_PARAMS     ;Is mode and page same as last time?
    JE @@SAME_MODE
    MOV VIDEO_PARAMS,BX     ;Save for futore reference (!!)
    DEC AH              ;Subtract 1 from number of columns
    MOV SCRN_COLS,AH        ; onscreen and save it.
    MOV AH,1            ;Assume graphics mode.
    CMP BL,7            ;Mono text mode?
    JNE @@0
    DEC AH              ;Set flag to 0 if so.
  @@0:
    CMP BL,4            ;Is mode number below 4? (ie. 0-3)
    JNB @@1
    DEC AH
  @@1:
    MOV GRAF_MODE,AH        ;Save flag value.
    MOV Word Ptr BALL_POS,0101H ;Set XY position to 1,1
    MOV Word Ptr BALL_INC,0101H ;Set XY increment to 1,1
    MOV AH,03H
    INT 10H             ;Read cursor position into DX
    PUSH DX             ; and save it on the stack.
    MOV DX,BALL_POS         ;Get XY position of ball.
    JMP SHORT UPDATE_BALL_POS   ;Change increment if needed.

  @@SAME_MODE:              ;Enter here if mode not changed.
    MOV AH,03H
    INT 10H             ;Get cursor position into DX
    PUSH DX             ; and save it.
    MOV AH,02
    MOV DX,BALL_POS
    INT 10H             ;Move to bouncing ball location.
    MOV AX,ORG_CHAR         ;Get original screen char & attribute.
    CMP Byte Ptr GRAF_MODE,1    ;Check for graphics mode/
    JNE @@3
    MOV AX,8307H            ;If graphics mode, use CHR$(7)
  @@3:                  ;If not, then use original char
    MOV BL,AH           ;Move color value into BL
    MOV CX,1            ;Write one character
    MOV AH,09H          ; with attributes and all
    INT 10H             ; into page in BH.

;The update routine will check for the ball's position on a screen border.
;If it's on a border, then negate the increment for that direction.
;(ie, if the ball was moving up, reverse it.)  If the increment was not
;changed, then "randomly" change the X or Y increment based on the lower
;three bits of the previous screen character.  This will make the ball
;appear to bounce around "randomly" on a screen filled with characters.
UPDATE_BALL_POS:            ;Figure new ball position.
    MOV CX,BALL_INC         ;Get ball position increment.
    CMP DH,0            ;Is is on the top row of the screen?
    JNZ @@0
    NEG CH
  @@0:
    CMP DH,24           ;Reached bottom edge?
    JNZ @@1
    NEG CH
  @@1:
    CMP DL,0            ;Reached left edge?
    JNZ @@2
    NEG CL
  @@2:
    CMP DL,SCRN_COLS        ;Reached right edge?
    JNZ @@3
    NEG CL
  @@3:
    CMP CX,BALL_INC         ;Is the increment the same as before?
    JNE CALC_NEW_POS        ;If not, apply the modified increment.
    MOV AX,ORG_CHAR         ;Do "ramdom" updating, as described
    AND AL,00000111B        ; in the note above.
    CMP AL,00000011B
    JNE @@4
    NEG CH
  @@4:
    CMP AL,00000101B
    JNE CALC_NEW_POS
    NEG CL

CALC_NEW_POS:
    ADD DL,CL           ;Add increments to ball position.
    ADD DH,CH
    MOV BALL_INC,CX         ;Save ball position increment and
    MOV BALL_POS,DX         ; new ball position.
    MOV AH,02H          ;Move to ball position, which is
    INT 10H             ; in register DX.
    MOV AH,08H          ;Read the present screen char and
    INT 10H             ; attribute.
    MOV ORG_CHAR,AX         ;Save them for next time.
    MOV BL,AH           ;Use same attribute, if in text mode
    CMP Byte Ptr GRAF_MODE,1
    JNE @@0
    MOV BL,83H          ;Otherwise, use color # 83H
  @@0:
    MOV CX,0001H            ;Write one character and attribute
    MOV AX,0907H            ; using CHR$(7) as the character.
    INT 10H
    POP DX              ;Get old cursor position.
    MOV AH,02H          ;Move cursor back to that position.
    INT 10H
    POP DX
    POP CX
    POP BX              ;Restore affected registers.
    POP AX
    POP DS
            ASSUME  DS:NOTHING
    JMP CS:ORG_INT8         ;Continue with original INT 8h handler.

NEW_INT10   LABEL   FAR
    OR CS:FLAGS,01000000B
    PUSHF
    CALL CS:ORG_INT10
    AND CS:FLAGS,10111111B
    IRET

END_RESIDENT    LABEL   NEAR

            ASSUME  CS:SIMULATION,DS:SIMULATION,ES:SIMULATION

TITLE_MSG   LABEL   NEAR
DB CR, LF
DB 'This is a simulation of the bouncing ball of the Ping Pong virus.', CR, LF
DB 'This program is ONLY a simulation, and is NOT an active virus.', CR, LF, LF
DB 'Ping Pong B bouncing ball simulation is in memory.', CR, LF,36

GO_TSR:
    MOV FLAGS,0
    MOV VIDEO_PARAMS,-1
    MOV AH,9
    MOV DX,OFFSET TITLE_MSG
    INT 21H

    MOV AX,3513H
    INT 21H
            ASSUME  ES:NOTHING
    MOV Word Ptr ORG_INT13, BX
    MOV Word Ptr ORG_INT13+2,ES
    MOV AX,3508H
    INT 21H
            ASSUME  ES:NOTHING
    MOV Word Ptr ORG_INT8, BX
    MOV Word Ptr ORG_INT8+2,ES
    PUSH CS
    POP ES
            ASSUME  ES:SIMULATION

    MOV AX,2513H
    MOV DX,OFFSET NEW_INT13
    INT 21H
    MOV AX,2508H
    MOV DX,OFFSET NEW_INT8
    INT 21H

    MOV DX,OFFSET END_RESIDENT
    MOV CL,4
    SHR DX,CL
    INC DX
    MOV AX,31FFH
    INT 21H


            SIMULATION  ENDS
            END START_HERE

;Original virus disassembly by James L.  July 1991
;Visual effects simulator written by James L.  July 1991
;# EOF #;
begin 775 pingb-s.com
MZ>,!4%-14AX.'[0"S1:H$'4.,N3-&O;&?W4*]L+P=06`#I0``A]:65M8+O\N
MB``N]@:4``)U!2[_+H``'E!345(.'[0/S1"*V#L>D@!T-8D>D@#^S(@FE@"T
M`8#[!W4"_LR`^P1S`O[,B":5`,<&C@`!`<<&D``!`;0#S1!2BQ:.`.LCM`/-
M$%*T`HL6C@#-$*&,`(`^E0`!=0.X!X.*W+D!`+0)S1"+#I``@/X`=0+VW8#^
M&'4"]MV`^@!U`O;9.A:6`'4"]MD[#I``=1&AC``D!SP#=0+VW3P%=0+VV0+1
M`O6)#I``B1:.`+0"S1"T",T0HXP`BMR`/I4``74"LX.Y`0"X!PG-$%JT`LT0
M6EE;6!\N_RZ``"Z`#I0`0)PN_QZ$`"Z`)I0`O\\-"E1H:7,@:7,@82!S:6UU
M;&%T:6]N(&]F('1H92!B;W5N8VEN9R!B86QL(&]F('1H92!0:6YG(%!O;F<@
M=FER=7,N#0I4:&ES('!R;V=R86T@:7,@3TY,62!A('-I;75L871I;VXL(&%N
M9"!I<@4&]N9R!"(&)O=6YC
M:6YG(&)A;&P@
