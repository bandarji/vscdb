PAGE  59,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 MAXIHD                       ;;
;;;                                      ;;
;;;      Created:   1-Jan-80                             ;;
;;;      Passes:    5          Analysis Flags on: H              ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
DATA_1E     EQU 74H         ; (0000:0074=0A4H)
DATA_2E     EQU 78H         ; (0000:0078=22H)
DATA_3E     EQU 7CH         ; (0000:007C=0)
DATA_4E     EQU 80H         ; (0000:0080=0F5H)
DATA_5E     EQU 84H         ; (0000:0084=9CEH)
DATA_6E     EQU 86H         ; (0000:0086=13C7H)
DATA_7E     EQU 88H         ; (0000:0088=723H)
DATA_8E     EQU 8AH         ; (0000:008A=23EAH)
DATA_9E     EQU 8CH         ; (0000:008C=0A70H)
DATA_10E    EQU 8EH         ; (0000:008E=23EAH)
DATA_11E    EQU 94H         ; (0000:0094=192FH)
DATA_12E    EQU 98H         ; (0000:0098=198CH)
DATA_13E    EQU 9AH         ; (0000:009A=27DH)
DATA_14E    EQU 9EH         ; (0000:009E=27DH)
DATA_15E    EQU 232H            ; (0000:0232=0)
DATA_16E    EQU 234H            ; (0000:0234=0)
DATA_17E    EQU 236H            ; (0000:0236=0)
DATA_18E    EQU 23CH            ; (0000:023C=0)
DATA_19E    EQU 458H            ; (0000:0458=0)
DATA_20E    EQU 45AH            ; (0000:045A=0)
DATA_21E    EQU 464H            ; (0000:0464=2903H)
DATA_22E    EQU 4A4H            ; (0000:04A4=0)
DATA_23E    EQU 4A6H            ; (0000:04A6=0)
DATA_24E    EQU 4A8H            ; (0000:04A8=0)
DATA_25E    EQU 2           ; (7FC4:0002=0)
DATA_26E    EQU 2CH         ; (7FC4:002C=0)
DATA_27E    EQU 94H         ; (7FC4:0094=0)
DATA_28E    EQU 9EH         ; (7FC4:009E=0)
DATA_29E    EQU 1D6H            ; (7FC4:01D6=0CD57H)
DATA_30E    EQU 1D8H            ; (7FC4:01D8=21H)
DATA_31E    EQU 232H            ; (7FC4:0232=2FB9H)
DATA_32E    EQU 37EH            ; (7FC4:037E=50FFH)
DATA_33E    EQU 3A6H            ; (7FC4:03A6=8D50H)
DATA_34E    EQU 3A8H            ; (7FC4:03A8=0AE46H)
DATA_35E    EQU 4A4H            ; (7FC4:04A4=0AC26H)
DATA_36E    EQU 4A6H            ; (7FC4:04A6=8C40H)
DATA_37E    EQU 4A8H            ; (7FC4:04A8=87C5H)
DATA_123E   EQU 0FF67H          ; (8134:FF67=0)
DATA_124E   EQU 0FF70H          ; (8134:FF70=0)
DATA_126E   EQU 0FF6AH          ; (817F:FF6A=0)
DATA_127E   EQU 0FF6CH          ; (817F:FF6C=0)
DATA_128E   EQU 0FF6EH          ; (817F:FF6E=0)
DATA_129E   EQU 0FF6FH          ; (817F:FF6F=0)
DATA_130E   EQU 0FF70H          ; (817F:FF70=0)
DATA_131E   EQU 0FF72H          ; (817F:FF72=0)
DATA_132E   EQU 0FF75H          ; (817F:FF75=0)
DATA_133E   EQU 0FF76H          ; (817F:FF76=0)
DATA_134E   EQU 0FF78H          ; (817F:FF78=0)
DATA_135E   EQU 0FF7BH          ; (817F:FF7B=0)
DATA_136E   EQU 0FF7CH          ; (817F:FF7C=0)
  
;-------------------------------------------------------------- SEG_A  ----
  
SEG_A       SEGMENT PARA PUBLIC
        ASSUME CS:SEG_A , DS:SEG_A , SS:STACK_SEG_C
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_1       PROC    NEAR
SUB_1       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           PROGRAM ENTRY POINT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
MAXIHD      PROC    FAR
  
start:
        MOV DX,SEG SEG_B
        MOV CS:DATA_38,DX       ; (7FD4:01F8=0)
        MOV AH,30H          ; '0'
        INT 21H         ; DOS Services  ah=function 30h
                        ;  get DOS version number ax
        MOV BP,DS:DATA_25E      ; (7FC4:0002=0)
        MOV BX,DS:DATA_26E      ; (7FC4:002C=0)
        MOV DS,DX
        assume  ds:SEG_B
        MOV DATA_77,AX      ; (8134:0092=0)
        MOV DATA_76,ES      ; (8134:0090=0)
        MOV WORD PTR DATA_73+2,BX   ; (8134:008C=0)
        MOV DATA_84,BP      ; (8134:00AC=0)
        MOV DATA_79,0FFFFH      ; (8134:0096=0)
        CALL    SUB_3           ; (0162)
        LES DI,DATA_73      ; (8134:008A=0) Load 32 bit ptr
        MOV AX,DI
        MOV BX,AX
        MOV CX,7FFFH
LOC_2:
        CMP WORD PTR ES:[DI],3738H
        JNE LOC_3           ; Jump if not equal
        MOV DX,ES:[DI+2]
        CMP DL,3DH          ; '='
        JNE LOC_3           ; Jump if not equal
        AND DH,0DFH
        INC DATA_79         ; (8134:0096=0)
        CMP DH,59H          ; 'Y'
        JNE LOC_3           ; Jump if not equal
        INC DATA_79         ; (8134:0096=0)
LOC_3:
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        JCXZ    LOC_6           ; Jump if cx=0
        INC BX
        CMP ES:[DI],AL
        JNE LOC_2           ; Jump if not equal
        OR  CH,80H
        NEG CX
        MOV WORD PTR DATA_73,CX ; (8134:008A=0)
        MOV CX,1
        SHL BX,CL           ; Shift w/zeros fill
        ADD BX,8
        AND BX,0FFF8H
        MOV DATA_75,BX      ; (8134:008E=0)
        MOV DX,DS
        SUB BP,DX
        MOV DI,DATA_89      ; (8134:023A=1000H)
        CMP DI,200H
        JAE LOC_4           ; Jump if above or =
        MOV DI,200H
        MOV DATA_89,DI      ; (8134:023A=1000H)
LOC_4:
        ADD DI,4AAH
        JC  LOC_6           ; Jump if carry Set
        ADD DI,DATA_88      ; (8134:0238=0)
        JC  LOC_6           ; Jump if carry Set
        MOV CL,4
        SHR DI,CL           ; Shift w/zeros fill
        INC DI
        CMP BP,DI
        JB  LOC_6           ; Jump if below
        CMP DATA_89,0       ; (8134:023A=1000H)
        JE  LOC_5           ; Jump if equal
        CMP DATA_88,0       ; (8134:0238=0)
        JNE LOC_7           ; Jump if not equal
LOC_5:
        MOV DI,1000H
        CMP BP,DI
        JA  LOC_7           ; Jump if above
        MOV DI,BP
        JMP SHORT LOC_7     ; (00C1)
LOC_6:
        JMP LOC_10          ; (01E2)
LOC_7:
        MOV BX,DI
        ADD BX,DX
        MOV DATA_82,BX      ; (8134:00A4=0)
        MOV DATA_83,BX      ; (8134:00A8=0)
        MOV AX,DATA_76      ; (8134:0090=0)
        SUB BX,AX
        MOV ES,AX
        MOV AH,4AH          ; 'J'
        PUSH    DI
        INT 21H         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        POP DI
        SHL DI,CL           ; Shift w/zeros fill
        CLI             ; Disable interrupts
        MOV SS,DX
        MOV SP,DI
        STI             ; Enable interrupts
        XOR AX,AX           ; Zero register
        MOV ES,CS:DATA_38       ; (7FD4:01F8=0)
        MOV DI,464H
        MOV CX,4AAH
        SUB CX,DI
        REP STOSB           ; Rep while cx>0 Store al to es:[di]
        PUSH    CS
        CALL    WORD PTR DATA_117   ; (8134:0456=1D2H)
        CALL    SUB_12          ; (0390)
        CALL    SUB_14          ; (047B)
        MOV AH,0
        INT 1AH         ; Real time clock   ah=func 00h
                        ;  get system timer count cx,dx
        MOV DS:DATA_12E,DX      ; (0000:0098=198CH)
        MOV DS:DATA_13E,CX      ; (0000:009A=27DH)
        CALL    WORD PTR DS:DATA_20E    ; (0000:045A=0)
        PUSH    WORD PTR DS:DATA_7E ; (0000:0088=723H)
        PUSH    WORD PTR DS:DATA_6E ; (0000:0086=13C7H)
        PUSH    WORD PTR DS:DATA_5E ; (0000:0084=9CEH)
        CALL    SUB_6           ; (01FA)
        PUSH    AX
        CALL    SUB_11          ; (035B)
  
MAXIHD      ENDP
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_2       PROC    NEAR
        MOV DS,CS:DATA_38       ; (7FD4:01F8=0)
        CALL    SUB_4           ; (01A5)
        PUSH    CS
        CALL    WORD PTR DS:DATA_19E    ; (0000:0458=0)
        XOR AX,AX           ; Zero register
        MOV SI,AX
        MOV CX,2FH
        NOP
        CLD             ; Clear direction
  
LOCLOOP_8:
        ADD AL,[SI]
        ADC AH,0
        INC SI
        LOOP    LOCLOOP_8       ; Loop if cx > 0
  
        SUB AX,0D37H
        NOP
        JZ  LOC_9           ; Jump if zero
        MOV CX,19H
        NOP
        MOV DX,2FH
        CALL    SUB_5           ; (01DA)
LOC_9:
        MOV BP,SP
        MOV AH,4CH          ; 'L'
        MOV AL,[BP+2]
        INT 21H         ; DOS Services  ah=function 4Ch
                        ;  terminate with al=return code
SUB_2       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
INT_00H_ENTRY   PROC    FAR
        MOV CX,0EH
        NOP
        MOV DX,48H
        JMP LOC_11          ; (01E9)
INT_00H_ENTRY   ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_3       PROC    NEAR
        PUSH    DS
        MOV AX,3500H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        MOV DATA_65,BX      ; (8134:0074=0)
        MOV DATA_66,ES      ; (8134:0076=0)
        MOV AX,3504H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        MOV DATA_67,BX      ; (8134:0078=0)
        MOV DATA_68,ES      ; (8134:007A=0)
        MOV AX,3505H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        MOV DATA_69,BX      ; (8134:007C=0)
        MOV DATA_70,ES      ; (8134:007E=0)
        MOV AX,3506H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        MOV DATA_71,BX      ; (8134:0080=0)
        MOV DATA_72,ES      ; (8134:0082=0)
        MOV AX,2500H
        MOV DX,CS
        MOV DS,DX
        MOV DX,158H
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        POP DS
        RETN
SUB_3       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_4       PROC    NEAR
        PUSH    DS
        MOV AX,2500H
        LDS DX,DWORD PTR DS:DATA_1E ; (0000:0074=0F0A4H) Load 32 bit ptr
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        POP DS
        PUSH    DS
        MOV AX,2504H
        LDS DX,DWORD PTR DS:DATA_2E ; (0000:0078=522H) Load 32 bit ptr
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        POP DS
        PUSH    DS
        MOV AX,2505H
        LDS DX,DWORD PTR DS:DATA_3E ; (0000:007C=0) Load 32 bit ptr
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        POP DS
        PUSH    DS
        MOV AX,2506H
        LDS DX,DWORD PTR DS:DATA_4E ; (0000:0080=16F5H) Load 32 bit ptr
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        POP DS
        RETN
SUB_4       ENDP
  
        DB  0C7H, 6, 96H, 0, 0, 0
        DB  0CBH, 0C3H
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_5       PROC    NEAR
        MOV AH,40H          ; '@'
        MOV BX,2
        INT 21H         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        RETN
SUB_5       ENDP
  
LOC_10:
        MOV CX,1EH
        NOP
        MOV DX,56H
LOC_11:
        MOV DS,CS:DATA_38       ; (7FD4:01F8=0)
        CALL    SUB_5           ; (01DA)
        MOV AX,3
        PUSH    AX
        CALL    SUB_2           ; (0121)
DATA_38     DW  0
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_6       PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AX,194H
        PUSH    AX
        CALL    SUB_8           ; (0290)
        POP CX
        MOV AX,194H
        PUSH    AX
        CALL    SUB_7           ; (0212)
        POP CX
        CALL    SUB_9           ; (02F5)
        POP BP
        RETN
SUB_6       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_7       PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,0AEH
        PUSH    SI
        PUSH    DI
        MOV DI,[BP+4]
        PUSH    DI
        CALL    SUB_8           ; (0290)
        POP CX
        MOV AX,19BH
        PUSH    AX
        PUSH    DI
        MOV AX,195H
        PUSH    AX
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_51          ; (1571)
        ADD SP,8
        MOV AX,10H
        PUSH    AX
        LEA AX,[BP-0AEH]        ; Load effective addr
        PUSH    AX
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_49          ; (150B)
        ADD SP,6
        MOV SI,AX
        JMP SHORT LOC_14        ; (0286)
LOC_12:
        CMP BYTE PTR SS:DATA_124E[BP],2EH   ; (8134:FF70=0) '.'
        JE  LOC_13          ; Jump if equal
        TEST    BYTE PTR SS:DATA_123E[BP],10H   ; (8134:FF67=0)
        JZ  LOC_13          ; Jump if zero
        LEA AX,[BP-90H]     ; Load effective addr
        PUSH    AX
        PUSH    DI
        MOV AX,195H
        PUSH    AX
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_51          ; (1571)
        ADD SP,8
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_7           ; (0212)
        POP CX
LOC_13:
        LEA AX,[BP-0AEH]        ; Load effective addr
        PUSH    AX
        CALL    SUB_50          ; (152D)
        POP CX
        MOV SI,AX
LOC_14:
        OR  SI,SI           ; Zero ?
        JZ  LOC_12          ; Jump if zero
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_7       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_8       PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,7EH
        PUSH    SI
        PUSH    WORD PTR [BP+4]
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_33          ; (0B88)
        POP CX
        POP CX
        MOV AX,19FH
        PUSH    AX
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_32          ; (0B4C)
        POP CX
        POP CX
        XOR AX,AX           ; Zero register
        PUSH    AX
        LEA AX,[BP-7EH]     ; Load effective addr
        PUSH    AX
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_49          ; (150B)
        ADD SP,6
        MOV SI,AX
        JMP SHORT LOC_16        ; (02EC)
LOC_15:
        LEA AX,[BP-60H]     ; Load effective addr
        PUSH    AX
        PUSH    WORD PTR [BP+4]
        MOV AX,195H
        PUSH    AX
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_51          ; (1571)
        ADD SP,8
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        CALL    SUB_31          ; (0B34)
        POP CX
        LEA AX,[BP-7EH]     ; Load effective addr
        PUSH    AX
        CALL    SUB_50          ; (152D)
        POP CX
        MOV SI,AX
LOC_16:
        OR  SI,SI           ; Zero ?
        JZ  LOC_15          ; Jump if zero
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_8       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_9       PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,4
        MOV AX,1A4H
        PUSH    AX
        PUSH    WORD PTR [BP-2]
        CALL    SUB_48          ; (14F3)
        POP CX
        POP CX
        PUSH    WORD PTR [BP-4]
        XOR AX,AX           ; Zero register
        PUSH    AX
        MOV AX,0CH
        PUSH    AX
        MOV AX,2
        PUSH    AX
        CALL    SUB_52          ; (15D4)
        ADD SP,8
        MOV SP,BP
        POP BP
        RETN
SUB_9       ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_10      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        MOV SI,[BP+4]
        OR  SI,SI           ; Zero ?
        JL  LOC_19          ; Jump if <
        CMP SI,58H
        JBE LOC_18          ; Jump if below or =
LOC_17:
        MOV SI,57H
LOC_18:
        MOV DS:DATA_29E,SI      ; (7FC4:01D6=0CD57H)
        MOV AL,DS:DATA_30E[SI]  ; (7FC4:01D8=21H)
        CBW             ; Convrt byte to word
        XCHG    AX,SI
        JMP SHORT LOC_20        ; (034B)
LOC_19:
        NEG SI
        CMP SI,23H
        JA  LOC_17          ; Jump if above
        MOV WORD PTR DS:DATA_29E,0FFFFH ; (7FC4:01D6=0CD57H)
LOC_20:
        MOV AX,SI
        MOV DS:DATA_27E,AX      ; (7FC4:0094=0)
        MOV AX,0FFFFH
        JMP SHORT LOC_21        ; (0355)
LOC_21:
        POP SI
        POP BP
        RETN    2
SUB_10      ENDP
  
        DB  0C3H
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_11      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        JMP SHORT LOC_23        ; (036A)
LOC_22:
        MOV BX,WORD PTR DS:[23CH]   ; (7FC4:023C=0E246H)
        SHL BX,1            ; Shift w/zeros fill
        CALL    WORD PTR DS:[464H][BX]  ;*(7FC4:0464=0E3D1H)
LOC_23:
        MOV AX,WORD PTR DS:[23CH]   ; (7FC4:023C=0E246H)
        DEC WORD PTR DS:[23CH]  ; (7FC4:023C=0E246H)
        OR  AX,AX           ; Zero ?
        JNZ LOC_22          ; Jump if not zero
        CALL    WORD PTR DS:DATA_31E    ; (7FC4:0232=2FB9H)
        CALL    WORD PTR DS:[234H]  ; (7FC4:0234=9000H)
        CALL    WORD PTR DS:[236H]  ; (7FC4:0236=2FCH)
        PUSH    WORD PTR [BP+4]
        CALL    SUB_2           ; (0121)
        POP CX
        POP BP
        RETN
SUB_11      ENDP
  
DATA_39     DW  0
DATA_40     DW  0
        DB  0, 0
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_12      PROC    NEAR
        POP CS:DATA_39      ; (7FD4:038A=0)
        MOV CS:DATA_40,DS       ; (7FD4:038C=0)
        CLD             ; Clear direction
        MOV ES,DATA_76      ; (8134:0090=0)
        MOV SI,80H
        XOR AH,AH           ; Zero register
        LODS    BYTE PTR ES:[SI]    ; String [si] to al
        INC AX
        MOV BP,ES
        XCHG    DX,SI
        XCHG    AX,BX
        MOV SI,WORD PTR DATA_73 ; (8134:008A=0)
        ADD SI,2
        MOV CX,1
        CMP BYTE PTR DATA_77,3  ; (8134:0092=0)
        JB  LOC_24          ; Jump if below
        MOV ES,WORD PTR DATA_73+2   ; (8134:008C=0)
        MOV DI,SI
        MOV CL,7FH
        XOR AL,AL           ; Zero register
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        JCXZ    LOC_32          ; Jump if cx=0
        XOR CL,7FH
LOC_24:
        SUB SP,2
        MOV AX,1
        ADD AX,BX
        ADD AX,CX
        AND AX,0FFFEH
        MOV DI,SP
        SUB DI,AX
        JC  LOC_32          ; Jump if carry Set
        MOV SP,DI
        MOV AX,ES
        MOV DS,AX
        MOV AX,SS
        MOV ES,AX
        PUSH    CX
        DEC CX
        REP MOVSB           ; Rep while cx>0 Mov [si] to es:[di]
        XOR AL,AL           ; Zero register
        STOSB               ; Store al to es:[di]
        MOV DS,BP
        XCHG    SI,DX
        XCHG    BX,CX
        MOV AX,BX
        MOV DX,AX
        INC BX
LOC_25:
        CALL    SUB_13          ; (0419)
        JA  LOC_27          ; Jump if above
LOC_26:
        JC  LOC_33          ; Jump if carry Set
        CALL    SUB_13          ; (0419)
        JA  LOC_26          ; Jump if above
LOC_27:
        CMP AL,20H          ; ' '
        JE  LOC_28          ; Jump if equal
        CMP AL,0DH
        JE  LOC_28          ; Jump if equal
        CMP AL,9
        JNE LOC_25          ; Jump if not equal
LOC_28:
        XOR AL,AL           ; Zero register
        JMP SHORT LOC_25        ; (03FD)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_13:
        OR  AX,AX           ; Zero ?
        JZ  LOC_29          ; Jump if zero
        INC DX
        STOSB               ; Store al to es:[di]
        OR  AL,AL           ; Zero ?
        JNZ LOC_29          ; Jump if not zero
        INC BX
LOC_29:
        XCHG    AH,AL
        XOR AL,AL           ; Zero register
        STC             ; Set carry flag
        JCXZ    LOC_RET_31      ; Jump if cx=0
        LODSB               ; String [si] to al
        DEC CX
        SUB AL,22H          ; '"'
        JZ  LOC_RET_31      ; Jump if zero
        ADD AL,22H          ; '"'
        CMP AL,5CH          ; '\'
        JNE LOC_30          ; Jump if not equal
        CMP BYTE PTR [SI],22H   ; '"'
        JNE LOC_30          ; Jump if not equal
        LODSB               ; String [si] to al
        DEC CX
LOC_30:
        OR  SI,SI           ; Zero ?
  
LOC_RET_31:
        RETN
LOC_32:
        JMP LOC_10          ; (01E2)
LOC_33:
        POP CX
        ADD CX,DX
        MOV DS,CS:DATA_40       ; (7FD4:038C=0)
        MOV DS:DATA_5E,BX       ; (0000:0084=9CEH)
        INC BX
        ADD BX,BX
        MOV SI,SP
        MOV BP,SP
        SUB BP,BX
        JC  LOC_32          ; Jump if carry Set
        MOV SP,BP
        MOV DS:DATA_6E,BP       ; (0000:0086=13C7H)
LOC_34:
        JCXZ    LOC_36          ; Jump if cx=0
        MOV [BP],SI
        ADD BP,2
  
LOCLOOP_35:
        LODS    BYTE PTR SS:[SI]    ; String [si] to al
        OR  AL,AL           ; Zero ?
        LOOPNZ  LOCLOOP_35      ; Loop if zf=0, cx>0
  
        JZ  LOC_34          ; Jump if zero
LOC_36:
        XOR AX,AX           ; Zero register
        MOV [BP],AX
        JMP CS:DATA_39      ; (7FD4:038A=0)
SUB_12      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_14      PROC    NEAR
        MOV CX,DS:DATA_8E       ; (0000:008A=23EAH)
        PUSH    CX
        CALL    SUB_19          ; (05CA)
        POP CX
        MOV DI,AX
        OR  AX,AX           ; Zero ?
        JZ  LOC_37          ; Jump if zero
        PUSH    DS
        PUSH    DS
        POP ES
        MOV DS,DS:DATA_9E       ; (0000:008C=0A70H)
        XOR SI,SI           ; Zero register
        CLD             ; Clear direction
        REP MOVSB           ; Rep while cx>0 Mov [si] to es:[di]
        POP DS
        MOV DI,AX
        PUSH    ES
        PUSH    WORD PTR DS:DATA_10E    ; (0000:008E=23EAH)
        CALL    SUB_19          ; (05CA)
        ADD SP,2
        MOV BX,AX
        POP ES
        MOV DS:DATA_7E,AX       ; (0000:0088=723H)
        OR  AX,AX           ; Zero ?
        JNZ LOC_38          ; Jump if not zero
LOC_37:
        JMP LOC_10          ; (01E2)
LOC_38:
        XOR AX,AX           ; Zero register
        MOV CX,0FFFFH
LOC_39:
        MOV [BX],DI
        ADD BX,2
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        CMP ES:[DI],AL
        JNE LOC_39          ; Jump if not equal
        MOV [BX],AX
        RETN
SUB_14      ENDP
  
        DB  55H, 8BH, 0ECH, 83H, 3EH, 3CH
        DB  2, 20H, 75H, 5, 0B8H, 1
        DB  0, 0EBH, 15H, 8BH, 46H, 4
        DB  8BH, 1EH, 3CH, 2, 0D1H, 0E3H
        DB  89H, 87H, 64H, 4, 0FFH, 6
        DB  3CH, 2, 33H, 0C0H, 0EBH, 0
LOC_40:
        POP BP
        RETN
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_15      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV DI,[BP+4]
        MOV AX,[DI+6]
        MOV DS:DATA_23E,AX      ; (0000:04A6=0)
        CMP AX,DI
        JNE LOC_41          ; Jump if not equal
        MOV WORD PTR DS:DATA_23E,0  ; (0000:04A6=0)
        JMP SHORT LOC_42        ; (0515)
LOC_41:
        MOV SI,[DI+4]
        MOV BX,DS:DATA_23E      ; (0000:04A6=0)
        MOV [BX+4],SI
        MOV AX,DS:DATA_23E      ; (0000:04A6=0)
        MOV [SI+6],AX
LOC_42:
        POP DI
        POP SI
        POP BP
        RETN
SUB_15      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_16      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV DI,[BP+4]
        MOV AX,[BP+6]
        SUB [DI],AX
        MOV SI,[DI]
        ADD SI,DI
        MOV AX,[BP+6]
        INC AX
        MOV [SI],AX
        MOV [SI+2],DI
        MOV AX,DS:DATA_22E      ; (0000:04A4=0)
        CMP AX,DI
        JNE LOC_43          ; Jump if not equal
        MOV DS:DATA_22E,SI      ; (0000:04A4=0)
        JMP SHORT LOC_44        ; (0548)
LOC_43:
        MOV DI,SI
        ADD DI,[BP+6]
        MOV [DI+2],SI
LOC_44:
        MOV AX,SI
        ADD AX,4
        JMP SHORT LOC_45        ; (054F)
LOC_45:
        POP DI
        POP SI
        POP BP
        RETN
SUB_16      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_17      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        MOV AX,[BP+4]
        XOR DX,DX           ; Zero register
        AND AX,0FFFFH
        AND DX,0
        nop             ;*Fixup for MASM (M)
        PUSH    DX
        PUSH    AX
        CALL    SUB_21          ; (065C)
        POP CX
        POP CX
        MOV SI,AX
        CMP SI,0FFFFH
        JNE LOC_46          ; Jump if not equal
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_47        ; (058D)
LOC_46:
        MOV AX,DS:DATA_22E      ; (0000:04A4=0)
        MOV [SI+2],AX
        MOV AX,[BP+4]
        INC AX
        MOV [SI],AX
        MOV DS:DATA_22E,SI      ; (0000:04A4=0)
        MOV AX,DS:DATA_22E      ; (0000:04A4=0)
        ADD AX,4
        JMP SHORT LOC_47        ; (058D)
LOC_47:
        POP SI
        POP BP
        RETN
SUB_17      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_18      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        MOV AX,[BP+4]
        XOR DX,DX           ; Zero register
        AND AX,0FFFFH
        AND DX,0
        nop             ;*Fixup for MASM (M)
        PUSH    DX
        PUSH    AX
        CALL    SUB_21          ; (065C)
        POP CX
        POP CX
        MOV SI,AX
        CMP SI,0FFFFH
        JNE LOC_48          ; Jump if not equal
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_49        ; (05C7)
LOC_48:
        MOV DS:DATA_24E,SI      ; (0000:04A8=0)
        MOV DS:DATA_22E,SI      ; (0000:04A4=0)
        MOV AX,[BP+4]
        INC AX
        MOV [SI],AX
        MOV AX,SI
        ADD AX,4
        JMP SHORT LOC_49        ; (05C7)
LOC_49:
        POP SI
        POP BP
        RETN
SUB_18      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_19      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV DI,[BP+4]
        OR  DI,DI           ; Zero ?
        JNZ LOC_50          ; Jump if not zero
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_56        ; (0634)
LOC_50:
        MOV AX,DI
        ADD AX,0BH
        AND AX,0FFF8H
        MOV DI,AX
        CMP WORD PTR DS:DATA_24E,0  ; (0000:04A8=0)
        JNE LOC_51          ; Jump if not equal
        PUSH    DI
        CALL    SUB_18          ; (0590)
        POP CX
        JMP SHORT LOC_56        ; (0634)
LOC_51:
        MOV SI,DS:DATA_23E      ; (0000:04A6=0)
        MOV AX,SI
        OR  AX,AX           ; Zero ?
        JZ  LOC_55          ; Jump if zero
LOC_52:
        MOV AX,[SI]
        MOV DX,DI
        ADD DX,28H
        CMP AX,DX
        JB  LOC_53          ; Jump if below
        PUSH    DI
        PUSH    SI
        CALL    SUB_16          ; (0519)
        POP CX
        POP CX
        JMP SHORT LOC_56        ; (0634)
LOC_53:
        MOV AX,[SI]
        CMP AX,DI
        JB  LOC_54          ; Jump if below
        PUSH    SI
        CALL    SUB_15          ; (04EB)
        POP CX
        INC WORD PTR [SI]
        MOV AX,SI
        ADD AX,4
        JMP SHORT LOC_56        ; (0634)
LOC_54:
        MOV SI,[SI+6]
        CMP SI,DS:DATA_23E      ; (0000:04A6=0)
        JNE LOC_52          ; Jump if not equal
LOC_55:
        PUSH    DI
        CALL    SUB_17          ; (0553)
        POP CX
        JMP SHORT LOC_56        ; (0634)
LOC_56:
        POP DI
        POP SI
        POP BP
        RETN
SUB_19      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_20      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AX,[BP+4]
        MOV DX,SP
        SUB DX,100H
        CMP AX,DX
        JAE LOC_57          ; Jump if above or =
        MOV DS:DATA_28E,AX      ; (7FC4:009E=0)
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_58        ; (065A)
LOC_57:
        MOV WORD PTR DS:DATA_27E,8  ; (7FC4:0094=0)
        MOV AX,0FFFFH
        JMP SHORT LOC_58        ; (065A)
LOC_58:
        POP BP
        RETN
SUB_20      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_21      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AX,[BP+4]
        MOV DX,[BP+6]
        ADD AX,DS:DATA_14E      ; (0000:009E=27DH)
        ADC DX,0
        MOV CX,AX
        ADD CX,100H
        ADC DX,0
        OR  DX,DX           ; Zero ?
        JNZ LOC_59          ; Jump if not zero
        CMP CX,SP
        JAE LOC_59          ; Jump if above or =
        XCHG    AX,DS:DATA_14E      ; (0000:009E=27DH)
        JMP SHORT LOC_60        ; (068E)
LOC_59:
        MOV WORD PTR DS:DATA_11E,8  ; (0000:0094=192FH)
        MOV AX,0FFFFH
        JMP SHORT LOC_60        ; (068E)
LOC_60:
        POP BP
        RETN
SUB_21      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_22      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    WORD PTR [BP+4]
        CALL    SUB_20          ; (0638)
        POP CX
        JMP SHORT LOC_61        ; (069C)
LOC_61:
        POP BP
        RETN
SUB_22      ENDP
  
        DB  55H, 8BH, 0ECH, 8BH, 46H, 4
        DB  99H, 52H, 50H, 0E8H, 0B2H, 0FFH
        DB  8BH, 0E5H, 0EBH, 0, 5DH, 0C3H
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_23      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,2
        PUSH    SI
        PUSH    DI
        MOV BX,[BP+4]
        MOV SI,[BX]
        MOV AX,SI
        MOV [BP-2],AX
        MOV BX,[BP+4]
        TEST    WORD PTR [BX+2],40H
        JZ  LOC_62          ; Jump if zero
        MOV AX,SI
        JMP SHORT LOC_65        ; (06EF)
LOC_62:
        MOV BX,[BP+4]
        MOV DI,[BX+0AH]
        JMP SHORT LOC_64        ; (06E3)
LOC_63:
        MOV BX,DI
        INC DI
        CMP BYTE PTR [BX],0AH
        JNE LOC_64          ; Jump if not equal
        INC WORD PTR [BP-2]
LOC_64:
        MOV AX,SI
        DEC SI
        OR  AX,AX           ; Zero ?
        JNZ LOC_63          ; Jump if not zero
        MOV AX,[BP-2]
        JMP SHORT LOC_65        ; (06EF)
LOC_65:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN    2
SUB_23      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_24      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        MOV SI,[BP+4]
        PUSH    SI
        CALL    SUB_34          ; (0BEE)
        POP CX
        OR  AX,AX           ; Zero ?
        JZ  LOC_66          ; Jump if zero
        MOV AX,0FFFFH
        JMP SHORT LOC_70        ; (0758)
LOC_66:
        CMP WORD PTR [BP+0AH],1
        JNE LOC_67          ; Jump if not equal
        CMP WORD PTR [SI],0
        JLE LOC_67          ; Jump if < or =
        PUSH    SI
        CALL    SUB_23          ; (06B0)
        CWD             ; Word to double word
        SUB [BP+6],AX
        SBB [BP+8],DX
LOC_67:
        AND WORD PTR [SI+2],0FE5FH
        MOV WORD PTR [SI],0
        MOV AX,[SI+8]
        MOV [SI+0AH],AX
        PUSH    WORD PTR [BP+0AH]
        PUSH    WORD PTR [BP+8]
        PUSH    WORD PTR [BP+6]
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_29          ; (0A1E)
        ADD SP,8
        CMP DX,0FFFFH
        JNE LOC_68          ; Jump if not equal
        CMP AX,0FFFFH
        JNE LOC_68          ; Jump if not equal
        MOV AX,0FFFFH
        JMP SHORT LOC_69        ; (0756)
LOC_68:
        XOR AX,AX           ; Zero register
LOC_69:
        JMP SHORT LOC_70        ; (0758)
LOC_70:
        POP SI
        POP BP
        RETN
SUB_24      ENDP
  
        DB  55H, 8BH, 0ECH, 83H, 0ECH, 4
        DB  56H, 8BH, 76H, 4, 56H, 0E8H
        DB  85H, 4, 59H, 0BH, 0C0H, 74H
        DB  8, 0BAH, 0FFH, 0FFH, 0B8H, 0FFH
        DB  0FFH, 0EBH, 3FH, 0B8H, 1, 0
        DB  50H, 33H, 0C0H, 50H, 50H, 8AH
        DB  44H, 4, 98H, 50H, 0E8H, 98H
        DB  2, 83H, 0C4H, 8, 89H, 56H
        DB  0FEH, 89H, 46H, 0FCH, 83H, 3CH
        DB  0, 7EH, 19H, 8BH, 56H, 0FEH
        DB  8BH, 46H, 0FCH, 52H, 50H, 56H
        DB  0E8H, 10H, 0FFH, 99H, 8BH, 0D8H
        DB  8BH, 0CAH, 58H, 5AH, 2BH, 0C3H
        DB  1BH, 0D1H, 0EBH, 6
LOC_71:
        MOV DX,[BP-2]
        MOV AX,[BP-4]
LOC_72:
        JMP SHORT LOC_73        ; (07B5)
LOC_73:
        POP SI
        MOV SP,BP
        POP BP
        RETN
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_25      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AX,4400H
        MOV BX,[BP+4]
        INT 21H         ; DOS Services  ah=function 44h
                        ;  device drivr cntrl al=subfunc
        MOV AX,0
        JC  LOC_74          ; Jump if carry Set
        SHL DX,1            ; Shift w/zeros fill
        RCL AX,1            ; Rotate thru carry
LOC_74:
        JMP SHORT LOC_75        ; (07D0)
LOC_75:
        POP BP
        RETN
SUB_25      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_26      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV DI,[BP+0AH]
        MOV SI,[BP+4]
        MOV AX,[SI+0EH]
        CMP AX,SI
        JNE LOC_76          ; Jump if not equal
        CMP WORD PTR [BP+8],2
        JG  LOC_76          ; Jump if >
        CMP DI,7FFFH
        JBE LOC_77          ; Jump if below or =
LOC_76:
        MOV AX,0FFFFH
        JMP LOC_85          ; (08A0)
LOC_77:
        CMP WORD PTR DS:DATA_34E,0  ; (7FC4:03A8=0AE46H)
        JNE LOC_78          ; Jump if not equal
        MOV AX,24EH
        CMP AX,SI
        JNE LOC_78          ; Jump if not equal
        MOV WORD PTR DS:DATA_34E,1  ; (7FC4:03A8=0AE46H)
        JMP SHORT LOC_79        ; (0820)
LOC_78:
        CMP WORD PTR DS:DATA_33E,0  ; (7FC4:03A6=8D50H)
        JNE LOC_79          ; Jump if not equal
        MOV AX,23EH
        CMP AX,SI
        JNE LOC_79          ; Jump if not equal
        MOV WORD PTR DS:DATA_33E,1  ; (7FC4:03A6=8D50H)
LOC_79:
        CMP WORD PTR [SI],0
        JE  LOC_80          ; Jump if equal
        MOV AX,1
        PUSH    AX
        XOR AX,AX           ; Zero register
        PUSH    AX
        PUSH    AX
        PUSH    SI
        CALL    SUB_24          ; (06F7)
        ADD SP,8
LOC_80:
        TEST    WORD PTR [SI+2],4
        JZ  LOC_81          ; Jump if zero
        PUSH    WORD PTR [SI+8]
        CALL    SUB_47          ; (14CC)
        POP CX
LOC_81:
        AND WORD PTR [SI+2],0FFF3H
        nop             ;*Fixup for MASM (M)
        MOV WORD PTR [SI+6],0
        MOV AX,SI
        ADD AX,5
        MOV [SI+8],AX
        MOV [SI+0AH],AX
        CMP WORD PTR [BP+8],2
        JE  LOC_84          ; Jump if equal
        OR  DI,DI           ; Zero ?
        JBE LOC_84          ; Jump if below or =
        MOV WORD PTR DS:DATA_31E,8A4H   ; (7FC4:0232=2FB9H)
        CMP WORD PTR [BP+6],0
        JNE LOC_83          ; Jump if not equal
        PUSH    DI
        CALL    SUB_19          ; (05CA)
        POP CX
        MOV [BP+6],AX
        OR  AX,AX           ; Zero ?
        JZ  LOC_82          ; Jump if zero
        OR  WORD PTR [SI+2],4
        nop             ;*Fixup for MASM (M)
        JMP SHORT LOC_83        ; (0885)
LOC_82:
        MOV AX,0FFFFH
        JMP SHORT LOC_85        ; (08A0)
LOC_83:
        MOV AX,[BP+6]
        MOV [SI+0AH],AX
        MOV [SI+8],AX
        MOV [SI+6],DI
        CMP WORD PTR [BP+8],1
        JNE LOC_84          ; Jump if not equal
        OR  WORD PTR [SI+2],8
        nop             ;*Fixup for MASM (M)
LOC_84:
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_85        ; (08A0)
LOC_85:
        POP DI
        POP SI
        POP BP
        RETN
SUB_26      ENDP
  
        DB  56H, 57H, 0BFH, 4, 0, 0BEH
        DB  3EH, 2, 0EBH, 10H
LOC_86:
        TEST    WORD PTR [SI+2],3
        JZ  LOC_87          ; Jump if zero
        PUSH    SI
        CALL    SUB_34          ; (0BEE)
        POP CX
LOC_87:
        DEC DI
        ADD SI,10H
        OR  DI,DI           ; Zero ?
        JNZ LOC_86          ; Jump if not zero
        POP DI
        POP SI
        RETN
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_27      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,8AH
        PUSH    SI
        PUSH    DI
        MOV AX,[BP+8]
        INC AX
        CMP AX,2
        JAE LOC_88          ; Jump if above or =
        XOR AX,AX           ; Zero register
        JMP LOC_100         ; (09D2)
LOC_88:
        MOV BX,[BP+4]
        SHL BX,1            ; Shift w/zeros fill
        TEST    WORD PTR DS:DATA_32E[BX],8000H  ; (7FC4:037E=50FFH)
        JZ  LOC_89          ; Jump if zero
        PUSH    WORD PTR [BP+8]
        PUSH    WORD PTR [BP+6]
        PUSH    WORD PTR [BP+4]
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        JMP LOC_100         ; (09D2)
LOC_89:
        MOV BX,[BP+4]
        SHL BX,1            ; Shift w/zeros fill
        AND WORD PTR DS:DATA_32E[BX],0FDFFH ; (7FC4:037E=50FFH)
        MOV AX,[BP+6]
        MOV SS:DATA_136E[BP],AX ; (817F:FF7C=0)
        MOV AX,[BP+8]
        MOV SS:DATA_134E[BP],AX ; (817F:FF78=0)
        LEA SI,[BP-82H]     ; Load effective addr
        JMP SHORT LOC_95        ; (0987)
LOC_90:
        DEC WORD PTR SS:DATA_134E[BP]   ; (817F:FF78=0)
        MOV BX,SS:DATA_136E[BP] ; (817F:FF7C=0)
        INC WORD PTR SS:DATA_136E[BP]   ; (817F:FF7C=0)
        MOV AL,[BX]
        MOV SS:DATA_135E[BP],AL ; (817F:FF7B=0)
        CMP AL,0AH
        JNE LOC_91          ; Jump if not equal
        MOV BYTE PTR [SI],0DH
        INC SI
LOC_91:
        MOV AL,SS:DATA_135E[BP] ; (817F:FF7B=0)
        MOV [SI],AL
        INC SI
        LEA AX,[BP-82H]     ; Load effective addr
        MOV DX,SI
        SUB DX,AX
        CMP DX,80H
        JL  LOC_95          ; Jump if <
        LEA AX,[BP-82H]     ; Load effective addr
        MOV DI,SI
        SUB DI,AX
        PUSH    DI
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        PUSH    WORD PTR [BP+4]
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        MOV SS:DATA_133E[BP],AX ; (817F:FF76=0)
        CMP AX,DI
        JE  LOC_94          ; Jump if equal
        CMP WORD PTR SS:DATA_133E[BP],0 ; (817F:FF76=0)
        JAE LOC_92          ; Jump if above or =
        MOV AX,0FFFFH
        JMP SHORT LOC_93        ; (0981)
LOC_92:
        MOV AX,[BP+8]
        SUB AX,SS:DATA_134E[BP] ; (817F:FF78=0)
        ADD AX,SS:DATA_133E[BP] ; (817F:FF76=0)
        SUB AX,DI
LOC_93:
        JMP SHORT LOC_100       ; (09D2)
LOC_94:
        LEA SI,[BP-82H]     ; Load effective addr
LOC_95:
        CMP WORD PTR SS:DATA_134E[BP],0 ; (817F:FF78=0)
        JE  LOC_96          ; Jump if equal
        JMP LOC_90          ; (091A)
        nop             ;*Fixup for MASM (V)
LOC_96:
        LEA AX,[BP-82H]     ; Load effective addr
        MOV DI,SI
        SUB DI,AX
        MOV AX,DI
        OR  AX,AX           ; Zero ?
        JBE LOC_99          ; Jump if below or =
        PUSH    DI
        LEA AX,[BP-82H]     ; Load effective addr
        PUSH    AX
        PUSH    WORD PTR [BP+4]
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        MOV SS:DATA_133E[BP],AX ; (817F:FF76=0)
        CMP AX,DI
        JE  LOC_99          ; Jump if equal
        CMP WORD PTR SS:DATA_133E[BP],0 ; (817F:FF76=0)
        JAE LOC_97          ; Jump if above or =
        MOV AX,0FFFFH
        JMP SHORT LOC_98        ; (09CB)
LOC_97:
        MOV AX,[BP+8]
        ADD AX,SS:DATA_133E[BP] ; (817F:FF76=0)
        SUB AX,DI
LOC_98:
        JMP SHORT LOC_100       ; (09D2)
LOC_99:
        MOV AX,[BP+8]
        JMP SHORT LOC_100       ; (09D2)
LOC_100:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_27      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_28      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV BX,[BP+4]
        SHL BX,1            ; Shift w/zeros fill
        TEST    WORD PTR DS:DATA_32E[BX],800H   ; (7FC4:037E=50FFH)
        JZ  LOC_101         ; Jump if zero
        MOV AX,2
        PUSH    AX
        XOR AX,AX           ; Zero register
        PUSH    AX
        PUSH    AX
        PUSH    WORD PTR [BP+4]
        CALL    SUB_29          ; (0A1E)
        MOV SP,BP
LOC_101:
        MOV AH,40H          ; '@'
        MOV BX,[BP+4]
        MOV CX,[BP+8]
        MOV DX,[BP+6]
        INT 21H         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        JC  LOC_102         ; Jump if carry Set
        PUSH    AX
        MOV BX,[BP+4]
        SHL BX,1            ; Shift w/zeros fill
        OR  WORD PTR DS:DATA_32E[BX],1000H  ; (7FC4:037E=50FFH)
        POP AX
        JMP SHORT LOC_103       ; (0A1C)
LOC_102:
        PUSH    AX
        CALL    SUB_10          ; (031F)
        JMP SHORT LOC_103       ; (0A1C)
LOC_103:
        POP BP
        RETN
SUB_28      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_29      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV BX,[BP+4]
        SHL BX,1            ; Shift w/zeros fill
        AND WORD PTR DS:DATA_32E[BX],0FDFFH ; (7FC4:037E=50FFH)
        MOV AH,42H          ; 'B'
        MOV AL,[BP+0AH]
        MOV BX,[BP+4]
        MOV CX,[BP+8]
        MOV DX,[BP+6]
        INT 21H         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        JC  LOC_104         ; Jump if carry Set
        JMP SHORT LOC_105       ; (0A47)
LOC_104:
        PUSH    AX
        CALL    SUB_10          ; (031F)
        CWD             ; Word to double word
        JMP SHORT LOC_105       ; (0A47)
LOC_105:
        POP BP
        RETN
SUB_29      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_30      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,22H
        PUSH    SI
        PUSH    DI
        PUSH    ES
        MOV DI,[BP+0AH]
        PUSH    DS
        POP ES
        MOV BX,[BP+8]
        CMP BX,24H
        JA  LOC_113         ; Jump if above
        CMP BL,2
        JB  LOC_113         ; Jump if below
        MOV AX,[BP+0CH]
        MOV CX,[BP+0EH]
        OR  CX,CX           ; Zero ?
        JGE LOC_106         ; Jump if > or =
        CMP BYTE PTR [BP+6],0
        JE  LOC_106         ; Jump if equal
        MOV BYTE PTR [DI],2DH   ; '-'
        INC DI
        NEG CX
        NEG AX
        SBB CX,0
LOC_106:
        LEA SI,[BP-22H]     ; Load effective addr
        JCXZ    LOC_108         ; Jump if cx=0
LOC_107:
        XCHG    AX,CX
        SUB DX,DX
        DIV BX          ; ax,dx rem=dx:ax/reg
        XCHG    AX,CX
        DIV BX          ; ax,dx rem=dx:ax/reg
        MOV [SI],DL
        INC SI
        JCXZ    LOC_109         ; Jump if cx=0
        JMP SHORT LOC_107       ; (0A84)
LOC_108:
        SUB DX,DX
        DIV BX          ; ax,dx rem=dx:ax/reg
        MOV [SI],DL
        INC SI
LOC_109:
        OR  AX,AX           ; Zero ?
        JNZ LOC_108         ; Jump if not zero
        LEA CX,[BP-22H]     ; Load effective addr
        NEG CX
        ADD CX,SI
        CLD             ; Clear direction
  
LOCLOOP_110:
        DEC SI
        MOV AL,[SI]
        SUB AL,0AH
        JNC LOC_111         ; Jump if carry=0
        ADD AL,3AH          ; ':'
        JMP SHORT LOC_112       ; (0AB4)
LOC_111:
        ADD AL,[BP+4]
LOC_112:
        STOSB               ; Store al to es:[di]
        LOOP    LOCLOOP_110     ; Loop if cx > 0
  
LOC_113:
        MOV AL,0
        STOSB               ; Store al to es:[di]
        POP ES
        MOV AX,[BP+0AH]
        JMP SHORT LOC_114       ; (0AC0)
LOC_114:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN    0CH
SUB_30      ENDP
  
        DB  55H, 8BH, 0ECH, 83H, 7EH, 8
        DB  0AH, 75H, 6, 8BH, 46H, 4
        DB  99H, 0EBH, 5, 8BH, 46H, 4
        DB  33H, 0D2H, 52H, 50H, 0FFH, 76H
        DB  6, 0FFH, 76H, 8, 0B0H, 1
        DB  50H, 0B0H, 61H, 50H, 0E8H, 5CH
        DB  0FFH, 0EBH, 0
LOC_115:
        POP BP
        RETN
        DB  55H, 8BH, 0ECH, 0FFH, 76H, 6
        DB  0FFH, 76H, 4, 0FFH, 76H, 8
        DB  0FFH, 76H, 0AH, 0B0H, 0, 50H
        DB  0B0H, 61H, 50H, 0E8H, 40H, 0FFH
        DB  0EBH, 0, 5DH, 0C3H, 55H, 8BH
        DB  0ECH, 0FFH, 76H, 6, 0FFH, 76H
        DB  4, 0FFH, 76H, 8, 0FFH, 76H
        DB  0AH, 83H, 7EH, 0AH, 0AH, 75H
        DB  5, 0B8H, 1, 0, 0EBH, 2
        DB  33H, 0C0H, 50H, 0B0H, 61H, 50H
        DB  0E8H, 19H, 0FFH, 0EBH, 0
LOC_116:
        POP BP
        RETN
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_31      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AH,41H          ; 'A'
        MOV DX,[BP+4]
        INT 21H         ; DOS Services  ah=function 41h
                        ;  delete file, name @ ds:dx
        JC  LOC_117         ; Jump if carry Set
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_118       ; (0B4A)
LOC_117:
        PUSH    AX
        CALL    SUB_10          ; (031F)
        JMP SHORT LOC_118       ; (0B4A)
LOC_118:
        POP BP
        RETN
SUB_31      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_32      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        CLD             ; Clear direction
        MOV DI,[BP+4]
        PUSH    DS
        POP ES
        MOV DX,DI
        XOR AL,AL           ; Zero register
        MOV CX,0FFFFH
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        LEA SI,[DI-1]       ; Load effective addr
        MOV DI,[BP+6]
        MOV CX,0FFFFH
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        NOT CX
        SUB DI,CX
        XCHG    SI,DI
        TEST    SI,1
        JZ  LOC_119         ; Jump if zero
        MOVSB               ; Mov [si] to es:[di]
        DEC CX
LOC_119:
        SHR CX,1            ; Shift w/zeros fill
        REP MOVSW           ; Rep while cx>0 Mov [si] to es:[di]
        JNC LOC_120         ; Jump if carry=0
        MOVSB               ; Mov [si] to es:[di]
LOC_120:
        MOV AX,DX
        JMP SHORT LOC_121       ; (0B84)
LOC_121:
        POP DI
        POP SI
        POP BP
        RETN
SUB_32      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_33      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        PUSH    DS
        POP ES
        CLD             ; Clear direction
        MOV DI,[BP+6]
        MOV SI,DI
        XOR AL,AL           ; Zero register
        MOV CX,0FFFFH
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        NOT CX
        MOV DI,[BP+4]
        REP MOVSB           ; Rep while cx>0 Mov [si] to es:[di]
        MOV AX,[BP+4]
        JMP SHORT LOC_122       ; (0BA8)
LOC_122:
        POP DI
        POP SI
        POP BP
        RETN
SUB_33      ENDP
  
        DB  55H, 8BH, 0ECH, 56H, 57H, 1EH
        DB  7, 8BH, 7EH, 4, 8BH, 76H
        DB  6, 8BH, 4EH, 8, 0D1H, 0E9H
        DB  0FCH, 0F3H, 0A5H, 73H, 1, 0A4H
LOC_123:
        MOV AX,[BP+4]
        JMP SHORT LOC_124       ; (0BC9)
LOC_124:
        POP DI
        POP SI
        POP BP
        RETN
        DB  0BAH, 0AAH, 3, 0EBH, 3, 0BAH
        DB  0AFH, 3, 0B9H, 5, 0, 90H
        DB  0B4H, 40H, 0BBH, 2, 0, 0CDH
        DB  21H, 0B9H, 27H, 0, 90H, 0BAH
        DB  0B4H, 3, 0B4H, 40H, 0CDH, 21H
        DB  0E9H, 0F4H, 0F5H
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_34      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV SI,[BP+4]
        MOV AX,[SI+0EH]
        CMP AX,SI
        JE  LOC_125         ; Jump if equal
        MOV AX,0FFFFH
        JMP SHORT LOC_130       ; (0C68)
LOC_125:
        CMP WORD PTR [SI],0
        JL  LOC_128         ; Jump if <
        TEST    WORD PTR [SI+2],8
        JNZ LOC_126         ; Jump if not zero
        MOV AX,[SI+0AH]
        MOV DX,SI
        ADD DX,5
        CMP AX,DX
        JNE LOC_127         ; Jump if not equal
LOC_126:
        MOV WORD PTR [SI],0
        MOV AX,[SI+0AH]
        MOV DX,SI
        ADD DX,5
        CMP AX,DX
        JNE LOC_127         ; Jump if not equal
        MOV AX,[SI+8]
        MOV [SI+0AH],AX
LOC_127:
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_130       ; (0C68)
LOC_128:
        MOV DI,[SI+6]
        ADD DI,[SI]
        INC DI
        SUB [SI],DI
        PUSH    DI
        MOV AX,[SI+8]
        MOV [SI+0AH],AX
        PUSH    AX
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_27          ; (08C5)
        ADD SP,6
        CMP AX,DI
        JE  LOC_129         ; Jump if equal
        TEST    WORD PTR [SI+2],200H
        JNZ LOC_129         ; Jump if not zero
        OR  WORD PTR [SI+2],10H
        nop             ;*Fixup for MASM (M)
        MOV AX,0FFFFH
        JMP SHORT LOC_130       ; (0C68)
LOC_129:
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_130       ; (0C68)
LOC_130:
        POP DI
        POP SI
        POP BP
        RETN
SUB_34      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_35      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV BX,[BP+6]
        DEC WORD PTR [BX]
        PUSH    WORD PTR [BP+6]
        MOV AL,[BP+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_36          ; (0C85)
        MOV SP,BP
        JMP SHORT LOC_131       ; (0C83)
LOC_131:
        POP BP
        RETN
SUB_35      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_36      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,2
        PUSH    SI
        MOV SI,[BP+6]
        MOV AL,[BP+4]
        MOV [BP-1],AL
LOC_132:
        INC WORD PTR [SI]
        JGE LOC_135         ; Jump if > or =
        MOV AL,[BP-1]
        INC WORD PTR [SI+0AH]
        MOV BX,[SI+0AH]
        MOV [BX-1],AL
        TEST    WORD PTR [SI+2],8
        JZ  LOC_134         ; Jump if zero
        CMP BYTE PTR [BP-1],0AH
        JE  LOC_133         ; Jump if equal
        CMP BYTE PTR [BP-1],0DH
        JNE LOC_134         ; Jump if not equal
LOC_133:
        PUSH    SI
        CALL    SUB_34          ; (0BEE)
        POP CX
        OR  AX,AX           ; Zero ?
        JZ  LOC_134         ; Jump if zero
        MOV AX,0FFFFH
        JMP LOC_149         ; (0DB0)
LOC_134:
        MOV AL,[BP-1]
        MOV AH,0
        JMP LOC_149         ; (0DB0)
LOC_135:
        DEC WORD PTR [SI]
        TEST    WORD PTR [SI+2],90H
        JNZ LOC_136         ; Jump if not zero
        TEST    WORD PTR [SI+2],2
        JNZ LOC_137         ; Jump if not zero
LOC_136:
        OR  WORD PTR [SI+2],10H
        nop             ;*Fixup for MASM (M)
        MOV AX,0FFFFH
        JMP LOC_149         ; (0DB0)
LOC_137:
        OR  WORD PTR [SI+2],100H
        CMP WORD PTR [SI+6],0
        JE  LOC_141         ; Jump if equal
        CMP WORD PTR [SI],0
        JE  LOC_139         ; Jump if equal
        PUSH    SI
        CALL    SUB_34          ; (0BEE)
        POP CX
        OR  AX,AX           ; Zero ?
        JZ  LOC_138         ; Jump if zero
        MOV AX,0FFFFH
        JMP LOC_149         ; (0DB0)
LOC_138:
        JMP SHORT LOC_140       ; (0D15)
LOC_139:
        MOV AX,0FFFFH
        MOV DX,[SI+6]
        SUB AX,DX
        MOV [SI],AX
LOC_140:
        JMP LOC_132         ; (0C95)
        JMP LOC_149         ; (0DB0)
LOC_141:
        CMP WORD PTR DS:DATA_34E,0  ; (7FC4:03A8=0AE46H)
        JNE LOC_145         ; Jump if not equal
        MOV AX,24EH
        CMP AX,SI
        JNE LOC_145         ; Jump if not equal
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_25          ; (07BA)
        POP CX
        OR  AX,AX           ; Zero ?
        JNZ LOC_142         ; Jump if not zero
        AND WORD PTR [SI+2],0FDFFH
LOC_142:
        MOV AX,200H
        PUSH    AX
        TEST    WORD PTR [SI+2],200H
        JZ  LOC_143         ; Jump if zero
        MOV AX,2
        JMP SHORT LOC_144       ; (0D4D)
LOC_143:
        XOR AX,AX           ; Zero register
LOC_144:
        PUSH    AX
        XOR AX,AX           ; Zero register
        PUSH    AX
        PUSH    SI
        CALL    SUB_26          ; (07D2)
        ADD SP,8
        JMP LOC_137         ; (0CEA)
        nop             ;*Fixup for MASM (V)
LOC_145:
        CMP BYTE PTR [BP-1],0AH
        JNE LOC_146         ; Jump if not equal
        TEST    WORD PTR [SI+2],40H
        JNZ LOC_146         ; Jump if not zero
        MOV AX,1
        PUSH    AX
        MOV AX,3DCH
        PUSH    AX
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        CMP AX,1
        JNE LOC_147         ; Jump if not equal
LOC_146:
        MOV AX,1
        PUSH    AX
        LEA AX,[BP+4]       ; Load effective addr
        PUSH    AX
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        CMP AX,1
        JE  LOC_148         ; Jump if equal
LOC_147:
        TEST    WORD PTR [SI+2],200H
        JNZ LOC_148         ; Jump if not zero
        OR  WORD PTR [SI+2],10H
        nop             ;*Fixup for MASM (M)
        MOV AX,0FFFFH
        JMP SHORT LOC_149       ; (0DB0)
LOC_148:
        MOV AL,[BP-1]
        MOV AH,0
        JMP SHORT LOC_149       ; (0DB0)
LOC_149:
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_36      ENDP
  
        DB  55H, 8BH, 0ECH, 56H, 8BH, 76H
        DB  4, 0B8H, 4EH, 2, 50H, 56H
        DB  0E8H, 0C1H, 0FEH, 59H, 59H, 0EBH
        DB  0, 5EH, 5DH, 0C3H, 55H, 8BH
        DB  0ECH, 83H, 0ECH, 2, 56H, 57H
        DB  8BH, 76H, 4, 8BH, 7EH, 6
        DB  47H, 0F7H, 44H, 2, 8, 0
        DB  74H, 23H, 0EBH, 2
LOC_150:
        JMP SHORT LOC_151       ; (0DE5)
LOC_151:
        DEC DI
        MOV AX,DI
        OR  AX,AX           ; Zero ?
        JZ  LOC_152         ; Jump if zero
        PUSH    SI
        MOV BX,[BP+8]
        INC WORD PTR [BP+8]
        MOV AL,[BX]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_36          ; (0C85)
        POP CX
        POP CX
        CMP AX,0FFFFH
        JNE LOC_150         ; Jump if not equal
LOC_152:
        JMP LOC_159         ; (0E79)
        DB  0F7H, 44H, 2, 40H, 0, 74H
        DB  37H, 83H, 7CH, 6, 0, 74H
        DB  31H, 8BH, 44H, 6, 3BH, 0C7H
        DB  73H, 2AH, 83H, 3CH, 0, 74H
        DB  0DH, 56H, 0E8H, 0CDH, 0FDH, 59H
        DB  0BH, 0C0H, 74H, 4, 33H, 0C0H
        DB  0EBH
        DB  53H
LOC_153:
        DEC DI
        PUSH    DI
        PUSH    WORD PTR [BP+8]
        MOV AL,[SI+4]
        CBW             ; Convrt byte to word
        PUSH    AX
        CALL    SUB_28          ; (09D8)
        ADD SP,6
        MOV [BP-2],AX
        SUB DI,[BP-2]
        JMP SHORT LOC_159       ; (0E79)
LOC_154:
        JMP SHORT LOC_156       ; (0E46)
LOC_155:
        JMP SHORT LOC_156       ; (0E46)
LOC_156:
        DEC DI
        MOV AX,DI
        OR  AX,AX           ; Zero ?
        JZ  LOC_159         ; Jump if zero
        INC WORD PTR [SI]
        JGE LOC_157         ; Jump if > or =
        MOV BX,[BP+8]
        INC WORD PTR [BP+8]
        MOV AL,[BX]
        INC WORD PTR [SI+0AH]
        MOV BX,[SI+0AH]
        MOV [BX-1],AL
        MOV AH,0
        JMP SHORT LOC_158       ; (0E74)
LOC_157:
        PUSH    SI
        MOV BX,[BP+8]
        INC WORD PTR [BP+8]
        PUSH    WORD PTR [BX]
        CALL    SUB_35          ; (0C6C)
        POP CX
        POP CX
LOC_158:
        CMP AX,0FFFFH
        JNE LOC_155         ; Jump if not equal
LOC_159:
        MOV AX,DI
        JMP SHORT LOC_160       ; (0E7D)
LOC_160:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN    6
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_37      PROC    NEAR
        JMP WORD PTR DS:[45CH]  ; (8134:045C=0BCDH)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_38:
        PUSH    BP
        MOV BP,SP
        MOV DX,[BP+4]
        MOV CX,0F04H
        MOV BX,3E5H
        CLD             ; Clear direction
        MOV AL,DH
        SHR AL,CL           ; Shift w/zeros fill
        XLAT                ; al=[al+[bx]] table
        STOSB               ; Store al to es:[di]
        MOV AL,DH
        AND AL,CH
        XLAT                ; al=[al+[bx]] table
        STOSB               ; Store al to es:[di]
        MOV AL,DL
        SHR AL,CL           ; Shift w/zeros fill
        XLAT                ; al=[al+[bx]] table
        STOSB               ; Store al to es:[di]
        MOV AL,DL
        AND AL,CH
        XLAT                ; al=[al+[bx]] table
        STOSB               ; Store al to es:[di]
        JMP SHORT LOC_161       ; (0EB0)
LOC_161:
        POP BP
        RETN    2
SUB_37      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_39      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,96H
        PUSH    SI
        PUSH    DI
        MOV WORD PTR [BP-56H],0
        MOV BYTE PTR [BP-53H],50H   ; 'P'
        JMP SHORT LOC_163       ; (0F00)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_40:
        PUSH    DI
        MOV CX,0FFFFH
        XOR AL,AL           ; Zero register
        REPNE   SCASB           ; Rept zf=0+cx>0 Scan es:[di] for al
        NOT CX
        DEC CX
        POP DI
        RETN
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_41:
        MOV [DI],AL
        INC DI
        DEC BYTE PTR [BP-53H]
        JLE LOC_RET_162     ; Jump if < or =
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_42:
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    ES
        LEA AX,[BP-52H]     ; Load effective addr
        SUB DI,AX
        LEA AX,[BP-52H]     ; Load effective addr
        PUSH    AX
        PUSH    DI
        PUSH    WORD PTR [BP+8]
        CALL    WORD PTR [BP+0AH]   ;*(0000)             1 entry
        MOV BYTE PTR [BP-53H],50H   ; 'P'
        ADD [BP-56H],DI
        LEA DI,[BP-52H]     ; Load effective addr
        POP ES
        POP DX
        POP CX
        POP BX
  
LOC_RET_162:
        RETN
LOC_163:
        PUSH    ES
        CLD             ; Clear direction
        LEA DI,[BP-52H]     ; Load effective addr
        MOV SS:DATA_127E[BP],DI ; (817F:FF6C=0)
LOC_164:
        MOV DI,SS:DATA_127E[BP] ; (817F:FF6C=0)
LOC_165:
        MOV SI,[BP+6]
LOC_166:
        LODSB               ; String [si] to al
        OR  AL,AL           ; Zero ?
        JZ  LOC_168         ; Jump if zero
        CMP AL,25H          ; '%'
        JE  LOC_169         ; Jump if equal
LOC_167:
        MOV [DI],AL
        INC DI
        DEC BYTE PTR [BP-53H]
        JG  LOC_166         ; Jump if >
        CALL    SUB_42          ; (0EDD)
        JMP SHORT LOC_166       ; (0F10)
LOC_168:
        JMP LOC_247         ; (139E)
LOC_169:
        MOV SS:DATA_134E[BP],SI ; (817F:FF78=0)
        LODSB               ; String [si] to al
        CMP AL,25H          ; '%'
        JE  LOC_167         ; Jump if equal
        MOV SS:DATA_127E[BP],DI ; (817F:FF6C=0)
        XOR CX,CX           ; Zero register
        MOV SS:DATA_133E[BP],CX ; (817F:FF76=0)
        MOV SS:DATA_126E[BP],CX ; (817F:FF6A=0)
        MOV SS:DATA_132E[BP],CL ; (817F:FF75=0)
        MOV WORD PTR SS:DATA_130E[BP],0FFFFH    ; (817F:FF70=0)
        MOV WORD PTR SS:DATA_131E[BP],0FFFFH    ; (817F:FF72=0)
        JMP SHORT LOC_171       ; (0F53)
LOC_170:
        LODSB               ; String [si] to al
LOC_171:
        XOR AH,AH           ; Zero register
        MOV DX,AX
        MOV BX,AX
        SUB BL,20H          ; ' '
        CMP BL,60H          ; '`'
        JAE LOC_173         ; Jump if above or =
        MOV BL,DATA_111[BX]     ; (8134:03F5=0)
        MOV AX,BX
        CMP AX,17H
        JBE LOC_172         ; Jump if below or =
        JMP LOC_245         ; (138C)
LOC_172:
        MOV BX,AX
        SHL BX,1            ; Shift w/zeros fill
        JMP WORD PTR CS:DATA_41[BX] ;*(7FD4:0F78=0FC3H)  24 entries
DATA_41     DW  OFFSET LOC_176      ; Data table (indexed access)
DATA_42     DW  OFFSET LOC_174
DATA_43     DW  OFFSET LOC_182
DATA_44     DW  OFFSET LOCLOOP_175
DATA_45     DW  OFFSET LOC_185
DATA_46     DW  OFFSET LOC_186
DATA_47     DW  OFFSET LOC_188
DATA_48     DW  OFFSET LOC_189
DATA_49     DW  OFFSET LOC_190
DATA_50     DW  OFFSET LOC_180
DATA_51     DW  OFFSET LOC_196
DATA_52     DW  OFFSET LOC_191
DATA_53     DW  OFFSET LOC_192
DATA_54     DW  OFFSET LOC_193
DATA_55     DW  OFFSET LOC_205
DATA_56     DW  OFFSET LOC_214
DATA_57     DW  OFFSET LOC_208
DATA_58     DW  OFFSET LOC_209
DATA_59     DW  OFFSET LOC_242
DATA_60     DW  OFFSET LOC_245
DATA_61     DW  OFFSET LOC_245
DATA_62     DW  OFFSET LOC_245
DATA_63     DW  OFFSET LOC_178
DATA_64     DW  OFFSET LOC_179
LOC_173:
        JMP LOC_245         ; (138C)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_174:
        CMP CH,0
        JA  LOC_173         ; Jump if above
        OR  WORD PTR SS:DATA_126E[BP],1 ; (817F:FF6A=0)
        JMP SHORT LOC_170       ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
LOCLOOP_175:
        CMP CH,0
        JA  LOC_173         ; Jump if above
        OR  WORD PTR SS:DATA_126E[BP],2 ; (817F:FF6A=0)
        JMP SHORT LOC_170       ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_176:
        CMP CH,0
        JA  LOC_173         ; Jump if above
        CMP BYTE PTR SS:DATA_132E[BP],2BH   ; (817F:FF75=0) '+'
        JE  LOC_177         ; Jump if equal
        MOV SS:DATA_132E[BP],DL ; (817F:FF75=0)
LOC_177:
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_178:
        AND WORD PTR SS:DATA_126E[BP],0FFDFH    ; (817F:FF6A=0)
        MOV CH,5
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_179:
        OR  WORD PTR SS:DATA_126E[BP],20H   ; (817F:FF6A=0)
        MOV CH,5
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_180:
        CMP CH,0
        JA  LOC_186         ; Jump if above
        TEST    WORD PTR SS:DATA_126E[BP],2 ; (817F:FF6A=0)
        JNZ LOC_183         ; Jump if not zero
        OR  WORD PTR SS:DATA_126E[BP],8 ; (817F:FF6A=0)
        MOV CH,1
        JMP LOC_170         ; (0F52)
LOC_181:
        JMP LOC_245         ; (138C)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_182:
        MOV DI,[BP+4]
        MOV AX,[DI]
        ADD WORD PTR [BP+4],2
        CMP CH,2
        JAE LOC_184         ; Jump if above or =
        MOV SS:DATA_130E[BP],AX ; (817F:FF70=0)
        MOV CH,3
LOC_183:
        JMP LOC_170         ; (0F52)
LOC_184:
        CMP CH,4
        JNE LOC_181         ; Jump if not equal
        MOV SS:DATA_131E[BP],AX ; (817F:FF72=0)
        INC CH
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_185:
        CMP CH,4
        JAE LOC_181         ; Jump if above or =
        MOV CH,4
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_186:
        XCHG    AX,DX
        SUB AL,30H          ; '0'
        CBW             ; Convrt byte to word
        CMP CH,2
        JA  LOC_187         ; Jump if above
        MOV CH,2
        XCHG    AX,SS:DATA_130E[BP] ; (817F:FF70=0)
        OR  AX,AX           ; Zero ?
        JL  LOC_183         ; Jump if <
        SHL AX,1            ; Shift w/zeros fill
        MOV DX,AX
        SHL AX,1            ; Shift w/zeros fill
        SHL AX,1            ; Shift w/zeros fill
        ADD AX,DX
        ADD SS:DATA_130E[BP],AX ; (817F:FF70=0)
        JMP LOC_170         ; (0F52)
LOC_187:
        CMP CH,4
        JNE LOC_181         ; Jump if not equal
        XCHG    AX,SS:DATA_131E[BP] ; (817F:FF72=0)
        OR  AX,AX           ; Zero ?
        JL  LOC_183         ; Jump if <
        SHL AX,1            ; Shift w/zeros fill
        MOV DX,AX
        SHL AX,1            ; Shift w/zeros fill
        SHL AX,1            ; Shift w/zeros fill
        ADD AX,DX
        ADD SS:DATA_131E[BP],AX ; (817F:FF72=0)
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_188:
        OR  WORD PTR SS:DATA_126E[BP],10H   ; (817F:FF6A=0)
        MOV CH,5
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_189:
        OR  WORD PTR SS:DATA_126E[BP],100H  ; (817F:FF6A=0)
        AND WORD PTR SS:DATA_126E[BP],0FFEFH    ; (817F:FF6A=0)
        MOV CH,5
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_190:
        AND WORD PTR SS:DATA_126E[BP],0FFEFH    ; (817F:FF6A=0)
        OR  WORD PTR SS:DATA_126E[BP],80H   ; (817F:FF6A=0)
        MOV CH,5
        JMP LOC_170         ; (0F52)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_191:
        MOV BH,8
        JMP SHORT LOC_194       ; (10AD)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_192:
        MOV BH,0AH
        JMP SHORT LOC_195       ; (10B2)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_193:
        MOV BH,10H
        MOV BL,0E9H
        ADD BL,DL
LOC_194:
        MOV BYTE PTR SS:DATA_132E[BP],0 ; (817F:FF75=0)
LOC_195:
        MOV BYTE PTR SS:DATA_129E[BP],0 ; (817F:FF6F=0)
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV DI,[BP+4]
        MOV AX,[DI]
        XOR DX,DX           ; Zero register
        JMP SHORT LOC_197       ; (10D5)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_196:
        MOV BH,0AH
        MOV BYTE PTR SS:DATA_129E[BP],1 ; (817F:FF6F=0)
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV DI,[BP+4]
        MOV AX,[DI]
        CWD             ; Word to double word
LOC_197:
        INC DI
        INC DI
        MOV [BP+6],SI
        TEST    WORD PTR SS:DATA_126E[BP],10H   ; (817F:FF6A=0)
        JZ  LOC_198         ; Jump if zero
        MOV DX,[DI]
        INC DI
        INC DI
LOC_198:
        MOV [BP+4],DI
        LEA DI,[BP-85H]     ; Load effective addr
        OR  AX,AX           ; Zero ?
        JNZ LOC_202         ; Jump if not zero
        OR  DX,DX           ; Zero ?
        JNZ LOC_202         ; Jump if not zero
        CMP WORD PTR SS:DATA_131E[BP],0 ; (817F:FF72=0)
        JNE LOC_203         ; Jump if not equal
        MOV DI,SS:DATA_127E[BP] ; (817F:FF6C=0)
        MOV CX,SS:DATA_130E[BP] ; (817F:FF70=0)
        JCXZ    LOC_201         ; Jump if cx=0
        CMP CX,0FFFFH
        JE  LOC_201         ; Jump if equal
        MOV AX,SS:DATA_126E[BP] ; (817F:FF6A=0)
        AND AX,8
        JZ  LOC_199         ; Jump if zero
        MOV DL,30H          ; '0'
        JMP SHORT LOCLOOP_200   ; (111A)
LOC_199:
        MOV DL,20H          ; ' '
  
LOCLOOP_200:
        MOV AL,DL
        CALL    SUB_41          ; (0ED5)
        LOOP    LOCLOOP_200     ; Loop if cx > 0
  
LOC_201:
        JMP LOC_165         ; (0F0D)
LOC_202:
        OR  WORD PTR SS:DATA_126E[BP],4 ; (817F:FF6A=0)
LOC_203:
        PUSH    DX
        PUSH    AX
        PUSH    DI
        MOV AL,BH
        CBW             ; Convrt byte to word
        PUSH    AX
        MOV AL,SS:DATA_129E[BP] ; (817F:FF6F=0)
        PUSH    AX
        PUSH    BX
        CALL    SUB_30          ; (0A49)
        PUSH    SS
        POP ES
        MOV DX,SS:DATA_131E[BP] ; (817F:FF72=0)
        OR  DX,DX           ; Zero ?
        JG  LOC_204         ; Jump if >
        JMP LOC_219         ; (125A)
LOC_204:
        JMP LOC_220         ; (126A)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_205:
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV [BP+6],SI
        LEA DI,[BP-86H]     ; Load effective addr
        MOV BX,[BP+4]
        PUSH    WORD PTR [BX]
        INC BX
        INC BX
        MOV [BP+4],BX
        TEST    WORD PTR SS:DATA_126E[BP],20H   ; (817F:FF6A=0)
        JZ  LOC_206         ; Jump if zero
        PUSH    WORD PTR [BX]
        INC BX
        INC BX
        MOV [BP+4],BX
        PUSH    SS
        POP ES
        CALL    SUB_38          ; (0E89)
        MOV AL,3AH          ; ':'
        STOSB               ; Store al to es:[di]
LOC_206:
        PUSH    SS
        POP ES
        CALL    SUB_38          ; (0E89)
        MOV BYTE PTR [DI],0
        MOV BYTE PTR SS:DATA_129E[BP],0 ; (817F:FF6F=0)
        AND WORD PTR SS:DATA_126E[BP],0FFFBH    ; (817F:FF6A=0)
        LEA CX,[BP-86H]     ; Load effective addr
        SUB DI,CX
        XCHG    CX,DI
        MOV DX,SS:DATA_131E[BP] ; (817F:FF72=0)
        CMP DX,CX
        JG  LOC_207         ; Jump if >
        MOV DX,CX
LOC_207:
        JMP LOC_219         ; (125A)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_208:
        MOV [BP+6],SI
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV DI,[BP+4]
        MOV AX,[DI]
        ADD WORD PTR [BP+4],2
        PUSH    SS
        POP ES
        LEA DI,[BP-85H]     ; Load effective addr
        XOR AH,AH           ; Zero register
        MOV [DI],AX
        MOV CX,1
        JMP LOC_223         ; (1294)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_209:
        MOV [BP+6],SI
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV DI,[BP+4]
        TEST    WORD PTR SS:DATA_126E[BP],20H   ; (817F:FF6A=0)
        JNZ LOC_210         ; Jump if not zero
        MOV DI,[DI]
        ADD WORD PTR [BP+4],2
        PUSH    DS
        POP ES
        OR  DI,DI           ; Zero ?
        JMP SHORT LOC_211       ; (11E4)
LOC_210:
        LES DI,DWORD PTR [DI]   ; Load 32 bit ptr
        ADD WORD PTR [BP+4],4
        MOV AX,ES
        OR  AX,DI
LOC_211:
        JNZ LOC_212         ; Jump if not zero
        PUSH    DS
        POP ES
        MOV DI,3DEH
LOC_212:
        CALL    SUB_40          ; (0EC8)
        CMP CX,SS:DATA_131E[BP] ; (817F:FF72=0)
        JBE LOC_213         ; Jump if below or =
        MOV CX,SS:DATA_131E[BP] ; (817F:FF72=0)
LOC_213:
        JMP LOC_223         ; (1294)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_214:
        MOV [BP+6],SI
        MOV SS:DATA_128E[BP],DL ; (817F:FF6E=0)
        MOV DI,[BP+4]
        MOV CX,SS:DATA_131E[BP] ; (817F:FF72=0)
        OR  CX,CX           ; Zero ?
        JGE LOC_215         ; Jump if > or =
        MOV CX,6
LOC_215:
        PUSH    DI
        PUSH    CX
        LEA BX,[BP-85H]     ; Load effective addr
        PUSH    BX
        PUSH    DX
        MOV AX,1
        AND AX,SS:DATA_126E[BP] ; (817F:FF6A=0)
        PUSH    AX
        MOV AX,SS:DATA_126E[BP] ; (817F:FF6A=0)
        TEST    AX,80H
        JZ  LOC_216         ; Jump if zero
        MOV AX,2
        MOV WORD PTR [BP-2],4
        JMP SHORT LOC_218       ; (124A)
LOC_216:
        TEST    AX,100H
        JZ  LOC_217         ; Jump if zero
        MOV AX,8
        MOV WORD PTR [BP-2],0AH
        JMP SHORT LOC_218       ; (124A)
LOC_217:
        MOV WORD PTR [BP-2],8
        MOV AX,6
LOC_218:
        PUSH    AX
        CALL    SUB_37          ; (0E85)
        MOV AX,[BP-2]
        ADD [BP+4],AX
        PUSH    SS
        POP ES
        LEA DI,[BP-85H]     ; Load effective addr
LOC_219:
        TEST    WORD PTR SS:DATA_126E[BP],8 ; (817F:FF6A=0)
        JZ  LOC_221         ; Jump if zero
        MOV DX,SS:DATA_130E[BP] ; (817F:FF70=0)
        OR  DX,DX           ; Zero ?
        JLE LOC_221         ; Jump if < or =
LOC_220:
        CALL    SUB_40          ; (0EC8)
        SUB DX,CX
        JLE LOC_221         ; Jump if < or =
        MOV SS:DATA_133E[BP],DX ; (817F:FF76=0)
LOC_221:
        MOV AL,SS:DATA_132E[BP] ; (817F:FF75=0)
        OR  AL,AL           ; Zero ?
        JZ  LOC_222         ; Jump if zero
        CMP BYTE PTR ES:[DI],2DH    ; '-'
        JE  LOC_222         ; Jump if equal
        SUB WORD PTR SS:DATA_133E[BP],1 ; (817F:FF76=0)
        ADC WORD PTR SS:DATA_133E[BP],0 ; (817F:FF76=0)
        DEC DI
        MOV ES:[DI],AL
LOC_222:
        CALL    SUB_40          ; (0EC8)
LOC_223:
        MOV SI,DI
        MOV DI,SS:DATA_127E[BP] ; (817F:FF6C=0)
        MOV BX,SS:DATA_130E[BP] ; (817F:FF70=0)
        MOV AX,5
        AND AX,SS:DATA_126E[BP] ; (817F:FF6A=0)
        CMP AX,5
        JNE LOC_224         ; Jump if not equal
        MOV AH,SS:DATA_128E[BP] ; (817F:FF6E=0)
        CMP AH,6FH          ; 'o'
        JNE LOC_225         ; Jump if not equal
        CMP WORD PTR SS:DATA_133E[BP],0 ; (817F:FF76=0)
        JG  LOC_224         ; Jump if >
        MOV WORD PTR SS:DATA_133E[BP],1 ; (817F:FF76=0)
LOC_224:
        JMP SHORT LOC_227       ; (12E1)
        DB  90H
LOC_225:
        CMP AH,78H          ; 'x'
        JE  LOC_226         ; Jump if equal
        CMP AH,58H          ; 'X'
        JNE LOC_227         ; Jump if not equal
LOC_226:
        OR  WORD PTR SS:DATA_126E[BP],40H   ; (817F:FF6A=0)
        DEC BX
        DEC BX
        SUB WORD PTR SS:DATA_133E[BP],2 ; (817F:FF76=0)
        JGE LOC_227         ; Jump if > or =
        MOV WORD PTR SS:DATA_133E[BP],0 ; (817F:FF76=0)
LOC_227:
        ADD CX,SS:DATA_133E[BP] ; (817F:FF76=0)
        TEST    WORD PTR SS:DATA_126E[BP],2 ; (817F:FF6A=0)
        JNZ LOC_230         ; Jump if not zero
        JMP SHORT LOC_229       ; (12F5)
LOC_228:
        MOV AL,20H          ; ' '
        CALL    SUB_41          ; (0ED5)
        DEC BX
LOC_229:
        CMP BX,CX
        JG  LOC_228         ; Jump if >
LOC_230:
        TEST    WORD PTR SS:DATA_126E[BP],40H   ; (817F:FF6A=0)
        JZ  LOC_231         ; Jump if zero
        MOV AL,30H          ; '0'
        CALL    SUB_41          ; (0ED5)
        MOV AL,SS:DATA_128E[BP] ; (817F:FF6E=0)
        CALL    SUB_41          ; (0ED5)
LOC_231:
        MOV DX,SS:DATA_133E[BP] ; (817F:FF76=0)
        OR  DX,DX           ; Zero ?
        JLE LOC_236         ; Jump if < or =
        SUB CX,DX
        SUB BX,DX
        MOV AL,ES:[SI]
        CMP AL,2DH          ; '-'
        JE  LOC_232         ; Jump if equal
        CMP AL,20H          ; ' '
        JE  LOC_232         ; Jump if equal
        CMP AL,2BH          ; '+'
        JNE LOC_233         ; Jump if not equal
LOC_232:
        LODS    BYTE PTR ES:[SI]    ; String [si] to al
        CALL    SUB_41          ; (0ED5)
        DEC CX
        DEC BX
LOC_233:
        XCHG    CX,DX
        JCXZ    LOC_235         ; Jump if cx=0
  
LOCLOOP_234:
        MOV AL,30H          ; '0'
        CALL    SUB_41          ; (0ED5)
        LOOP    LOCLOOP_234     ; Loop if cx > 0
  
LOC_235:
        XCHG    CX,DX
LOC_236:
        JCXZ    LOC_239         ; Jump if cx=0
        SUB BX,CX
  
LOCLOOP_237:
        LODS    BYTE PTR ES:[SI]    ; String [si] to al
        MOV [DI],AL
        INC DI
        DEC BYTE PTR [BP-53H]
        JG  LOC_238         ; Jump if >
        CALL    SUB_42          ; (0EDD)
LOC_238:
        LOOP    LOCLOOP_237     ; Loop if cx > 0
  
LOC_239:
        OR  BX,BX           ; Zero ?
        JLE LOC_241         ; Jump if < or =
        MOV CX,BX
  
LOCLOOP_240:
        MOV AL,20H          ; ' '
        CALL    SUB_41          ; (0ED5)
        LOOP    LOCLOOP_240     ; Loop if cx > 0
  
LOC_241:
        JMP LOC_165         ; (0F0D)
SUB_39      ENDP
  
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_242:
        MOV [BP+6],SI
        MOV DI,[BP+4]
        TEST    WORD PTR SS:DATA_126E[BP],20H   ; (817F:FF6A=0)
        JNZ LOC_243         ; Jump if not zero
        MOV DI,[DI]
        ADD WORD PTR [BP+4],2
        PUSH    DS
        POP ES
        JMP SHORT LOC_244       ; (137D)
LOC_243:
        LES DI,DWORD PTR [DI]   ; Load 32 bit ptr
        ADD WORD PTR [BP+4],4
LOC_244:
        MOV AX,50H
        SUB AL,[BP-53H]
        ADD AX,[BP-56H]
        MOV ES:[DI],AX
        JMP LOC_164         ; (0F09)
  
;;;;;; Indexed Entry Point ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
LOC_245:
        MOV SI,SS:DATA_134E[BP] ; (817F:FF78=0)
        MOV DI,SS:DATA_127E[BP] ; (817F:FF6C=0)
        MOV AL,25H          ; '%'
LOC_246:
        CALL    SUB_41          ; (0ED5)
        LODSB               ; String [si] to al
        OR  AL,AL           ; Zero ?
        JNZ LOC_246         ; Jump if not zero
LOC_247:
        CMP BYTE PTR [BP-53H],50H   ; 'P'
        JGE LOC_248         ; Jump if > or =
        CALL    SUB_42          ; (0EDD)
LOC_248:
        POP ES
        MOV AX,[BP-56H]
        JMP SHORT LOC_249       ; (13AD)
LOC_249:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN    8
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_43      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV SI,[BP+4]
        CMP WORD PTR DS:DATA_36E,0  ; (7FC4:04A6=8C40H)
        JE  LOC_250         ; Jump if equal
        MOV BX,DS:DATA_36E      ; (7FC4:04A6=8C40H)
        MOV DI,[BX+6]
        MOV BX,DS:DATA_36E      ; (7FC4:04A6=8C40H)
        MOV [BX+6],SI
        MOV [DI+4],SI
        MOV [SI+6],DI
        MOV AX,DS:DATA_36E      ; (7FC4:04A6=8C40H)
        MOV [SI+4],AX
        JMP SHORT LOC_251       ; (13EA)
LOC_250:
        MOV DS:DATA_36E,SI      ; (7FC4:04A6=8C40H)
        MOV [SI+4],SI
        MOV [SI+6],SI
LOC_251:
        POP DI
        POP SI
        POP BP
        RETN
SUB_43      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_44      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,2
        PUSH    SI
        PUSH    DI
        MOV SI,[BP+6]
        MOV DI,[BP+4]
        MOV AX,[SI]
        ADD [DI],AX
        MOV AX,DS:DATA_35E      ; (7FC4:04A4=0AC26H)
        CMP AX,SI
        JNE LOC_252         ; Jump if not equal
        MOV DS:DATA_35E,DI      ; (7FC4:04A4=0AC26H)
        JMP SHORT LOC_253       ; (141A)
LOC_252:
        MOV AX,[SI]
        ADD AX,SI
        MOV [BP-2],AX
        MOV BX,[BP-2]
        MOV [BX+2],DI
LOC_253:
        PUSH    SI
        CALL    SUB_15          ; (04EB)
        POP CX
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_44      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_45      PROC    NEAR
        PUSH    SI
        MOV AX,DS:DATA_37E      ; (7FC4:04A8=87C5H)
        CMP AX,DS:DATA_35E      ; (7FC4:04A4=0AC26H)
        JNE LOC_254         ; Jump if not equal
        PUSH    WORD PTR DS:DATA_37E    ; (7FC4:04A8=87C5H)
        CALL    SUB_22          ; (0690)
        POP CX
        XOR AX,AX           ; Zero register
        MOV DS:DATA_35E,AX      ; (7FC4:04A4=0AC26H)
        MOV DS:DATA_37E,AX      ; (7FC4:04A8=87C5H)
        JMP SHORT LOC_258       ; (147C)
LOC_254:
        MOV BX,DS:DATA_35E      ; (7FC4:04A4=0AC26H)
        MOV SI,[BX+2]
        TEST    WORD PTR [SI],1
        JNZ LOC_257         ; Jump if not zero
        PUSH    SI
        CALL    SUB_15          ; (04EB)
        POP CX
        CMP SI,DS:DATA_37E      ; (7FC4:04A8=87C5H)
        JNE LOC_255         ; Jump if not equal
        XOR AX,AX           ; Zero register
        MOV DS:DATA_35E,AX      ; (7FC4:04A4=0AC26H)
        MOV DS:DATA_37E,AX      ; (7FC4:04A8=87C5H)
        JMP SHORT LOC_256       ; (1469)
LOC_255:
        MOV AX,[SI+2]
        MOV DS:DATA_35E,AX      ; (7FC4:04A4=0AC26H)
LOC_256:
        PUSH    SI
        CALL    SUB_22          ; (0690)
        POP CX
        JMP SHORT LOC_258       ; (147C)
LOC_257:
        PUSH    WORD PTR DS:DATA_35E    ; (7FC4:04A4=0AC26H)
        CALL    SUB_22          ; (0690)
        POP CX
        MOV DS:DATA_35E,SI      ; (7FC4:04A4=0AC26H)
LOC_258:
        POP SI
        RETN
SUB_45      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_46      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        SUB SP,2
        PUSH    SI
        PUSH    DI
        MOV SI,[BP+4]
        DEC WORD PTR [SI]
        MOV AX,[SI]
        ADD AX,SI
        MOV [BP-2],AX
        MOV DI,[SI+2]
        TEST    WORD PTR [DI],1
        JNZ LOC_259         ; Jump if not zero
        CMP SI,DS:DATA_37E      ; (7FC4:04A8=87C5H)
        JE  LOC_259         ; Jump if equal
        MOV AX,[SI]
        ADD [DI],AX
        MOV BX,[BP-2]
        MOV [BX+2],DI
        MOV SI,DI
        JMP SHORT LOC_260       ; (14B4)
LOC_259:
        PUSH    SI
        CALL    SUB_43          ; (13B5)
        POP CX
LOC_260:
        MOV BX,[BP-2]
        TEST    WORD PTR [BX],1
        JNZ LOC_261         ; Jump if not zero
        PUSH    WORD PTR [BP-2]
        PUSH    SI
        CALL    SUB_44          ; (13EE)
        POP CX
        POP CX
LOC_261:
        POP DI
        POP SI
        MOV SP,BP
        POP BP
        RETN
SUB_46      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_47      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        MOV SI,[BP+4]
        OR  SI,SI           ; Zero ?
        JNZ LOC_262         ; Jump if not zero
        JMP SHORT LOC_264       ; (14F0)
LOC_262:
        MOV AX,SI
        ADD AX,0FFFCH
        MOV SI,AX
        CMP SI,DS:DATA_35E      ; (7FC4:04A4=0AC26H)
        JNE LOC_263         ; Jump if not equal
        CALL    SUB_45          ; (1425)
        JMP SHORT LOC_264       ; (14F0)
LOC_263:
        PUSH    SI
        CALL    SUB_46          ; (147E)
        POP CX
LOC_264:
        POP SI
        POP BP
        RETN
SUB_47      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_48      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AX,0DCBH
        PUSH    AX
        PUSH    WORD PTR [BP+4]
        PUSH    WORD PTR [BP+6]
        LEA AX,[BP+8]       ; Load effective addr
        PUSH    AX
        CALL    SUB_39          ; (0EB4)
        JMP SHORT LOC_265       ; (1509)
LOC_265:
        POP BP
        RETN
SUB_48      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_49      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AH,1AH
        MOV DX,[BP+6]
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        MOV AH,4EH          ; 'N'
        MOV CX,[BP+8]
        MOV DX,[BP+4]
        INT 21H         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        JC  LOC_266         ; Jump if carry Set
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_267       ; (152B)
LOC_266:
        PUSH    AX
        CALL    SUB_10          ; (031F)
        JMP SHORT LOC_267       ; (152B)
LOC_267:
        POP BP
        RETN
SUB_49      ENDP
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_50      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV AH,1AH
        MOV DX,[BP+4]
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        MOV AH,4FH          ; 'O'
        INT 21H         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        JC  LOC_268         ; Jump if carry Set
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_269       ; (1547)
LOC_268:
        PUSH    AX
        CALL    SUB_10          ; (031F)
        JMP SHORT LOC_269       ; (1547)
LOC_269:
        POP BP
        RETN
SUB_50      ENDP
  
        DB  55H, 8BH, 0ECH, 0FFH, 76H, 6
        DB  0FFH, 76H, 8, 8BH, 5EH, 4
        DB  0FFH, 37H, 0E8H, 52H, 0F6H, 8BH
        DB  0E5H, 8BH, 46H, 6, 8BH, 5EH
        DB  4, 1, 7, 8BH, 1FH, 0C6H
        DB  7, 0, 33H, 0C0H, 0EBH, 0
        DB  5DH, 0C2H, 6, 0
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_51      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        MOV BX,[BP+4]
        MOV BYTE PTR [BX],0
        MOV AX,1549H
        PUSH    AX
        LEA AX,[BP+4]       ; Load effective addr
        PUSH    AX
        PUSH    WORD PTR [BP+6]
        LEA AX,[BP+8]       ; Load effective addr
        PUSH    AX
        CALL    SUB_39          ; (0EB4)
        JMP SHORT LOC_270       ; (158E)
LOC_270:
        POP BP
        RETN
SUB_51      ENDP
  
        DB  55H, 8BH, 0ECH, 8BH, 5EH, 4
        DB  0C6H, 7, 0, 0B8H, 49H, 15H
        DB  50H, 8DH, 46H, 4, 50H, 0FFH
        DB  76H, 6, 0FFH, 76H, 8, 0E8H
        DB  0AH, 0F9H, 0EBH, 0, 5DH, 0C3H
        DB  55H, 8BH, 0ECH, 56H, 57H, 8AH
        DB  46H, 4, 8BH, 4EH, 6, 8BH
        DB  56H, 8, 8BH, 5EH, 0AH, 0CDH
        DB  25H, 5BH, 72H, 4, 33H, 0C0H
        DB  0EBH, 8, 0A3H, 94H, 0, 0B8H
        DB  0FFH, 0FFH, 0EBH, 0
LOC_271:
        POP DI
        POP SI
        POP BP
        RETN
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
SUB_52      PROC    NEAR
        PUSH    BP
        MOV BP,SP
        PUSH    SI
        PUSH    DI
        MOV AL,[BP+4]
        MOV CX,[BP+6]
        MOV DX,[BP+8]
        MOV BX,[BP+0AH]
        INT 26H         ; Absolute disk write, drive al
        POP BX
        JC  LOC_272         ; Jump if carry Set
        XOR AX,AX           ; Zero register
        JMP SHORT LOC_273       ; (15F6)
LOC_272:
        MOV DATA_78,AX      ; (8134:0094=0)
        MOV AX,0FFFFH
        JMP SHORT LOC_273       ; (15F6)
LOC_273:
        POP DI
        POP SI
        POP BP
        RETN
SUB_52      ENDP
  
        DB  0, 0, 0, 0, 0, 0
  
SEG_A       ENDS
  
  
  
;-------------------------------------------------------------- SEG_B  ----
  
SEG_B       SEGMENT PARA PUBLIC
        ASSUME CS:SEG_B , DS:SEG_B , SS:STACK_SEG_C
  
        DB  0, 0, 0, 0
        DB  'Turbo-C - Copyright (c) 1988 Bor'
        DB  'land Intl.'
        DB  0
        DB  'Null pointer assignment', 0DH, 0AH
        DB  'Divide error', 0DH, 0AH, 'Abnorm'
        DB  'al program termination', 0DH, 0AH
DATA_65     DW  0
DATA_66     DW  0
DATA_67     DW  0
DATA_68     DW  0
DATA_69     DW  0
DATA_70     DW  0
DATA_71     DW  0
DATA_72     DW  0
        DB  0, 0, 0, 0, 0, 0
DATA_73     DD  00000H
DATA_75     DW  0
DATA_76     DW  0
DATA_77     DW  0
DATA_78     DW  0
DATA_79     DW  0
        DB  0, 0, 0, 0, 0AAH, 4
DATA_80     DW  4AAH
        DB  0AAH, 4, 0
        DB  0
DATA_82     DW  0
        DB  0, 0
DATA_83     DW  0
        DB  0, 0
DATA_84     DW  0
        DB  231 DUP (0)
        DB  25H, 73H, 5CH, 25H, 73H, 0
        DB  2AH, 2EH, 2AH, 0, 5CH, 2AH
        DB  2EH, 2AH, 0
        DB  'THIS PROGRAM WAS MADE BY A PERSO'
        DB  'N FAR FROM YOU!!'
        DB  0, 0, 0, 0, 0, 13H
        DB  2, 2, 4, 5, 6, 8
        DB  8, 8, 14H, 15H, 5, 13H
        DB  0FFH, 16H, 5, 11H, 2, 0FFH
        DB  12 DUP (0FFH)
        DB  5, 5, 0FFH
        DB  15 DUP (0FFH)
        DB  0FH, 0FFH, 23H, 2, 0FFH, 0FH
        DB  0FFH, 0FFH, 0FFH, 0FFH, 13H, 0FFH
        DB  0FFH, 2, 2, 5, 0FH, 2
        DB  0FFH, 0FFH, 0FFH, 13H
        DB  8 DUP (0FFH)
        DB  23H, 0FFH, 0FFH, 0FFH, 0FFH, 23H
        DB  0FFH, 13H, 0FFH, 0, 5AH, 3
        DB  5AH, 3, 5AH, 3
DATA_88     DW  0
DATA_89     DW  1000H
        DB  0, 0, 0, 0, 9, 2
        DB  10 DUP (0)
        DB  3EH, 2, 0, 0, 0AH, 2
        DB  1
        DB  9 DUP (0)
        DB  4EH, 2, 0, 0, 2, 2
        DB  2
        DB  9 DUP (0)
        DB  5EH, 2, 0, 0, 43H, 2
        DB  3, 0
        DB  8 DUP (0)
        DB  6EH, 2, 0, 0, 42H, 2
        DB  4, 0
        DB  8 DUP (0)
        DB  7EH, 2, 0, 0, 0, 0
        DB  0FFH, 0
        DB  8 DUP (0)
        DB  8EH, 2, 0, 0, 0, 0
        DB  0FFH, 0
        DB  8 DUP (0)
        DB  9EH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0AEH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0BEH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0CEH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0DEH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0EEH, 2, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  0FEH, 2, 0, 0, 0, 0
        DB  0FFH, 0
        DB  8 DUP (0)
        DB  0EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  1EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  2EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  3EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  4EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  5EH, 3, 0, 0, 0, 0
        DB  0FFH
        DB  9 DUP (0)
        DB  6EH, 3, 1, 20H, 2, 20H
        DB  2, 20H, 4, 0A0H, 2, 0A0H
        DB  30 DUP (0FFH)
        DB  0, 0, 0, 0
        DB  'print scanf : floating point for'
        DB  'mats not linked', 0DH, 0AH
        DB  0, 0DH, 0, 28H, 6EH, 75H
        DB  6CH, 6CH, 29H, 0
        DB  '0123456789ABCDEF'
DATA_111    DB  0           ; Data table (indexed access)
        DB  14H, 14H, 1, 14H, 15H, 14H
        DB  14H, 14H, 14H, 2, 0, 14H
        DB  3, 4, 14H, 9, 5
        DB  8 DUP (5)
        DB  11 DUP (14H)
        DB  0FH, 17H, 0FH, 8, 14H, 14H
        DB  14H, 7, 14H, 16H
        DB  9 DUP (14H)
        DB  0DH, 14H, 14H
        DB  8 DUP (14H)
        DB  10H, 0AH, 0FH, 0FH, 0FH, 8
        DB  0AH, 14H, 14H, 6, 14H, 12H
        DB  0BH, 0EH, 14H, 14H, 11H, 14H
        DB  0CH, 14H, 14H
        DB  0DH
        DB  7 DUP (14H)
        DB  0
DATA_117    DW  1D2H
        DB  0D2H, 1, 0D9H, 1
;*TA_118    DW  OFFSET SUB_53       ;*(0BCD)
        DB  0CDH, 0BH
        DB  0D2H, 0BH, 0D2H, 0BH, 0D2H, 0BH
        DB  0
        DB  63 DUP (0)
DATA_120    DW  0
DATA_121    DW  0
DATA_122    DW  0
        DB  0, 0, 0, 0, 0, 0
  
SEG_B       ENDS
  
  
  
;--------------------------------------------------------- STACK_SEG_C  ---
  
STACK_SEG_C SEGMENT PARA STACK
  
        DB  128 DUP (0)
  
STACK_SEG_C ENDS
  
  
  
        END START

Downloaded From P-80 International Information Systems 304-744-2253
