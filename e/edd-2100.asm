                ;==========================================================================
                ;==                 V2100                        ==
                ;==      Created:   6-Jul-90                             ==
                ;==      Version:                                ==
                ;==      Passes:    9          Analysis Options on: ABIOQRSUW            ==
                ;==========================================================================

     0100           START:
     0100  E9 0853              JMP LOC_4           ; (0956)
     07AD                       DATA_37                                         ;  xref 8362:0E43
     07F5                       DATA_38                                         ;  xref 8362:0C5B, 0D46, 0EAB
     0809  9090         DATA_39     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0C9F, 0CC5
     080B  9090         DATA_40     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0CA4, 0CBD
     080E  9090         DATA_41     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0CA9, 0D29
     0810  9090         DATA_42     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0CAE, 0D2E
     0813  9090         DATA_43     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0B1F, 0DE9, 0EB0
     0815  9090         DATA_44     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0B23, 0DF1, 0EB8
     0817  9090         DATA_45     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0C60, 0EC2
     0822  9090         DATA_46     DW  9090H           ; Data table (indexed access)
                                        ;  xref 8362:0C56
     0824  9090         DATA_47     DW  9090H           ;  xref 8362:0A3B, 0A7B, 0A96, 0BFF
     0876  90           DATA_48     DB  90H         ; Data table (indexed access)
                                        ;  xref 8362:0C8A, 0E16
     0877  90           DATA_49     DB  90H         ; Data table (indexed access)
                                        ;  xref 8362:09DB, 0C0B, 0C37, 0DBA
     0878  9090 9090        DATA_50     DD  90909090H       ; Data table (indexed access)
                                        ;  xref 8362:09EA, 0A55, 0A6D, 0DAF
     087C  9090 9090        DATA_52     DD  90909090H       ; Data table (indexed access)
                                        ;  xref 8362:09E2, 0A61, 0A74, 0D3A
 . . . . .
     08FE  90 90 90 90 90 90                    DB      90H, 90H, 90H, 90H, 90H, 90H
     0904  B8 00 4C CD 21 00            DB  0B8H, 00H, 4CH,0CDH, 21H, 00H
     090A  45 64 64 69 65 20            DB  'Eddie lives'
     0910  6C 69 76 65 73
     0915  00 DC 14 00 00           DB   00H,0DCH, 14H, 00H, 00H

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0B04, 0BE9, 0C06, 0ED1, 0F03
                ;==========================================================================

                SUB_1       PROC    NEAR
     091A  50                   PUSH    AX
     091B  53                   PUSH    BX
     091C  51                   PUSH    CX
     091D  52                   PUSH    DX
     091E  56                   PUSH    SI
     091F  57                   PUSH    DI
     0920  1E                   PUSH    DS
     0921  06                   PUSH    ES
     0922  8B DC                MOV BX,SP
     0924  36: FF 67 10             JMP WORD PTR SS:DATA_28E[BX]    ; (8362:0010=0)
     0928           LOC_3:                      ;  xref 8362:0ECB
     0928  81 C6 081A               ADD SI,81AH
     092C  8C C3                MOV BX,ES
     092E  83 C3 10             ADD BX,10H
     0931  2E: 03 5C 02             ADD BX,WORD PTR CS:DATA_22E+1[SI]   ; (8362:0002=0)
     0935  2E: 89 9C F831           MOV CS:DATA_56E[SI],BX  ; (8362:F831=0)
     093A  2E: 8B 1C                MOV BX,CS:[SI]
     093D  2E: 89 9C F82F           MOV CS:DATA_55E[SI],BX  ; (8362:F82F=0)
     0942  8C C3                MOV BX,ES
     0944  83 C3 10             ADD BX,10H
     0947  2E: 03 5C 04             ADD BX,CS:DATA_24E[SI]  ; (8362:0004=0)
     094B  8E D3                MOV SS,BX
     094D  2E: 8B 64 06             MOV SP,CS:DATA_25E[SI]  ; (8362:0006=0)
     0951  EA 0000:0000     ;*      JMP FAR PTR LOC_1       ; (0000:0000)
                SUB_1       ENDP

     0956                       LOC_4:                                          ;  xref 8362:0100
     0956  E8 02F7              CALL    SUB_11          ; (0C50)



                                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0E64, 0E95, 0EA0
                ;==========================================================================

                SUB_2       PROC    NEAR
     0959  4F                   DEC DI
     095A  4F                   DEC DI
     095B  0E                   PUSH    CS
     095C  E8 0002              CALL    SUB_3           ; (0961)
     095F  47                   INC DI
     0960  47                   INC DI

                ;==== External Entry into Subroutine ======================================
                ;         Called from:   8362:095C

                SUB_3:
     0961  1E                   PUSH    DS
     0962  FF 75 08             PUSH    WORD PTR DS:DATA_20E[DI]    ; (5E02:0008=0FFFFH)
     0965  CB                   RETF                ; Return far
                SUB_2       ENDP

     0966           LOC_5:                      ;  xref 8362:09D0
     0966  E8 0195              CALL    SUB_7           ; (0AFE)
     0969  84 C0                TEST    AL,AL
     096B  75 5E                JNZ LOC_10          ; Jump if not zero
     096D  50                   PUSH    AX
     096E  53                   PUSH    BX
     096F  56                   PUSH    SI
     0970  57                   PUSH    DI
     0971  1E                   PUSH    DS
     0972  06                   PUSH    ES
     0973  B4 51                MOV AH,51H          ; 'Q'
     0975  CD 21                INT 21H         ; DOS Services  ah=function 51h
                                        ;  get active PSP segment in bx
     0977  8E C3                MOV ES,BX
     0979  26: 3B 1E 0016           CMP BX,ES:DATA_16E      ; (0008:0016=279H)
     097E  75 44                JNE LOC_9           ; Jump if not equal
     0980  8B F2                MOV SI,DX
     0982  B4 2F                MOV AH,2FH          ; '/'
     0984  CD 21                INT 21H         ; DOS Services  ah=function 2Fh
                                        ;  get DTA ptr into es:bx
     0986  AC                   LODSB               ; String [si] to al
     0987  FE C0                INC AL
     0989  75 03                JNZ LOC_6           ; Jump if not zero
     098B  83 C3 07             ADD BX,7
     098E           LOC_6:                      ;  xref 8362:0989
     098E  43                   INC BX
     098F  BF 0002              MOV DI,2
     0992  EB 11                JMP SHORT LOC_8     ; (09A5)
     0994           LOC_7:                      ;  xref 8362:0A04, 0A09
     0994  E8 0167              CALL    SUB_7           ; (0AFE)
     0997  72 32                JC  LOC_10          ; Jump if carry Set
     0999  50                   PUSH    AX
     099A  53                   PUSH    BX
     099B  56                   PUSH    SI
     099C  57                   PUSH    DI
     099D  1E                   PUSH    DS
     099E  06                   PUSH    ES
     099F  B4 2F                MOV AH,2FH          ; '/'
     09A1  CD 21                INT 21H         ; DOS Services  ah=function 2Fh
                                        ;  get DTA ptr into es:bx
     09A3  33 FF                XOR DI,DI           ; Zero register
     09A5           LOC_8:                      ;  xref 8362:0992
     09A5  06                   PUSH    ES
     09A6  1F                   POP DS
     09A7  8B 47 16             MOV AX,DS:DATA_16E[BX]  ; (0008:0016=279H)
     09AA  24 1F                AND AL,1FH
     09AC  3C 1F                CMP AL,1FH
     09AE  75 14                JNE LOC_9           ; Jump if not equal
     09B0  8B 41 1A             MOV AX,DS:DATA_17E[BX+DI]   ; (0008:001A=10DAH)
     09B3  8B 71 1C             MOV SI,DS:DATA_18E[BX+DI]   ; (0008:001C=1737H)
     09B6  2D 0834              SUB AX,834H
     09B9  83 DE 00             SBB SI,0
     09BC  72 06                JC  LOC_9           ; Jump if carry Set
     09BE  89 41 1A             MOV DS:DATA_17E[BX+DI],AX   ; (0008:001A=10DAH)
     09C1  89 71 1C             MOV DS:DATA_18E[BX+DI],SI   ; (0008:001C=1737H)
     09C4           LOC_9:                      ;  xref 8362:097E, 09AE, 09BC


     09C4  07                                   POP     ES
     09C5  1F                   POP DS
     09C6  5F                   POP DI
     09C7  5E                   POP SI
     09C8  5B                   POP BX
     09C9  58                   POP AX
     09CA  F8                   CLC             ; Clear carry flag
     09CB           LOC_10:                     ;  xref 8362:096B, 0997
     09CB  44                   INC SP
     09CC  44                   INC SP
     09CD  E9 0082              JMP LOC_RET_17      ; (0A52)
     09D0           LOC_11:                     ;  xref 8362:09FA, 09FF
     09D0  EB 94                JMP SHORT LOC_5     ; (0966)
     09D2  B0 03                MOV AL,3
     09D4  CF                   IRET                ; Interrupt return
     09D5           LOC_12:                     ;  xref 8362:0A2A
     09D5  E8 04F9              CALL    SUB_12          ; (0ED1)
     09D8  E8 0129              CALL    SUB_8           ; (0B04)
     09DB  2E: C6 06 0877 01            MOV CS:DATA_49,1        ; (8362:0877=90H)
     09E1           LOC_13:                     ;  xref 8362:09F2, 0ABD
     09E1  9D                   POPF                ; Pop flags
                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0B00
                ;==========================================================================

                SUB_4       PROC    NEAR
     09E2  2E: FF 2E 087C           JMP CS:DATA_52      ; (8362:087C=9090H)
     09E7  E8 0519              CALL    SUB_13          ; (0F03)
     09EA  2E: FF 2E 0878           JMP CS:DATA_50      ; (8362:0878=9090H)
     09EF           LOC_14:                     ;  xref 8362:0A25
     09EF  E8 0511              CALL    SUB_13          ; (0F03)
     09F2  EB ED                JMP SHORT LOC_13        ; (09E1)
                SUB_4       ENDP

     09F4  FB                   STI             ; Enable interrupts
     09F5  9C                   PUSHF               ; Push flags
     09F6  FC                   CLD             ; Clear direction
     09F7  80 FC 11             CMP AH,11H
     09FA  74 D4                JE  LOC_11          ; Jump if equal
     09FC  80 FC 12             CMP AH,12H
     09FF  74 CF                JE  LOC_11          ; Jump if equal
     0A01  80 FC 4E             CMP AH,4EH          ; 'N'
     0A04  74 8E                JE  LOC_7           ; Jump if equal
     0A06  80 FC 4F             CMP AH,4FH          ; 'O'
     0A09  74 89                JE  LOC_7           ; Jump if equal
     0A0B  E8 01F8              CALL    SUB_10          ; (0C06)
     0A0E  3D 2521              CMP AX,2521H
     0A11  74 4E                JE  LOC_19          ; Jump if equal
     0A13  3D 2527              CMP AX,2527H
     0A16  74 3D                JE  LOC_18          ; Jump if equal
     0A18  3D 3521              CMP AX,3521H
     0A1B  74 57                JE  LOC_21          ; Jump if equal
     0A1D  3D 3527              CMP AX,3527H
     0A20  74 4B                JE  LOC_20          ; Jump if equal
     0A22  80 FC 31             CMP AH,31H          ; '1'
     0A25  74 C8                JE  LOC_14          ; Jump if equal
     0A27  3D 4B00              CMP AX,4B00H
     0A2A  74 A9                JE  LOC_12          ; Jump if equal
     0A2C  80 FC 3C             CMP AH,3CH          ; '<'
     0A2F  74 0A                JE  LOC_15          ; Jump if equal
     0A31  80 FC 3E             CMP AH,3EH          ; '>'
     0A34  74 45                JE  LOC_22          ; Jump if equal
     0A36  80 FC 5B             CMP AH,5BH          ; '['
     0A39  75 66                JNE LOC_23          ; Jump if not equal
     0A3B           LOC_15:                     ;  xref 8362:0A2F
     0A3B  2E: 83 3E 0824 00            CMP CS:DATA_47,0        ; (8362:0824=9090H)
     0A41  75 7A                JNE LOC_26          ; Jump if not equal
     0A43  E8 007A              CALL    SUB_5           ; (0AC0)
     0A46  75 75                JNZ LOC_26          ; Jump if not zero
     0A48  9D                   POPF                ; Pop flags
     0A49  E8 00B2              CALL    SUB_7           ; (0AFE)
     0A4C  72 04                JC  LOC_RET_17      ; Jump if carry Set
     0A4E  E8 0198              CALL    SUB_9           ; (0BE9)
     0A51           LOC_16:                     ;  xref 8362:0A9F
     0A51  F8                   CLC             ; Clear carry flag
     0A52           LOC_RET_17:                 ;  xref 8362:09CD, 0A4C, 0A8A
     0A52  CA 0002              RETF    2           ; Return far


     0A55                       LOC_18:                                         ;  xref 8362:0A16
     0A55  2E: 89 16 0878           MOV WORD PTR CS:DATA_50,DX  ; (8362:0878=9090H)
     0A5A  2E: 8C 1E 087A           MOV WORD PTR CS:DATA_50+2,DS    ; (8362:087A=9090H)
     0A5F  9D                   POPF                ; Pop flags
     0A60  CF                   IRET                ; Interrupt return
     0A61           LOC_19:                     ;  xref 8362:0A11
     0A61  2E: 89 16 087C           MOV WORD PTR CS:DATA_52,DX  ; (8362:087C=9090H)
     0A66  2E: 8C 1E 087E           MOV WORD PTR CS:DATA_52+2,DS    ; (8362:087E=9090H)
     0A6B  9D                   POPF                ; Pop flags
     0A6C  CF                   IRET                ; Interrupt return
     0A6D           LOC_20:                     ;  xref 8362:0A20
     0A6D  2E: C4 1E 0878           LES BX,CS:DATA_50       ; (8362:0878=9090H) Load 32 bit ptr
     0A72  9D                   POPF                ; Pop flags
     0A73  CF                   IRET                ; Interrupt return
     0A74           LOC_21:                     ;  xref 8362:0A1B
     0A74  2E: C4 1E 087C           LES BX,CS:DATA_52       ; (8362:087C=9090H) Load 32 bit ptr
     0A79  9D                   POPF                ; Pop flags
     0A7A  CF                   IRET                ; Interrupt return
     0A7B           LOC_22:                     ;  xref 8362:0A34
     0A7B  2E: 3B 1E 0824           CMP BX,CS:DATA_47       ; (8362:0824=9090H)
     0A80  75 3B                JNE LOC_26          ; Jump if not equal
     0A82  85 DB                TEST    BX,BX
     0A84  74 37                JZ  LOC_26          ; Jump if zero
     0A86  9D                   POPF                ; Pop flags
     0A87  E8 0074              CALL    SUB_7           ; (0AFE)
     0A8A  72 C6                JC  LOC_RET_17      ; Jump if carry Set
     0A8C  1E                   PUSH    DS
     0A8D  0E                   PUSH    CS
     0A8E  1F                   POP DS
     0A8F  52                   PUSH    DX
     0A90  BA 0826              MOV DX,826H
     0A93  E8 006E              CALL    SUB_8           ; (0B04)
     0A96  2E: C7 06 0824 0000          MOV CS:DATA_47,0        ; (8362:0824=9090H)
     0A9D  5A                   POP DX
     0A9E  1F                   POP DS
     0A9F  EB B0                JMP SHORT LOC_16        ; (0A51)
     0AA1           LOC_23:                     ;  xref 8362:0A39
     0AA1  3D 4B01              CMP AX,4B01H
     0AA4  74 14                JE  LOC_25          ; Jump if equal
     0AA6  80 FC 3D             CMP AH,3DH          ; '='
     0AA9  74 0A                JE  LOC_24          ; Jump if equal
     0AAB  80 FC 43             CMP AH,43H          ; 'C'
     0AAE  74 05                JE  LOC_24          ; Jump if equal
     0AB0  80 FC 56             CMP AH,56H          ; 'V'
     0AB3  75 08                JNE LOC_26          ; Jump if not equal
     0AB5           LOC_24:                     ;  xref 8362:0AA9, 0AAE
     0AB5  E8 0008              CALL    SUB_5           ; (0AC0)
     0AB8  75 03                JNZ LOC_26          ; Jump if not zero
     0ABA           LOC_25:                     ;  xref 8362:0AA4
     0ABA  E8 0047              CALL    SUB_8           ; (0B04)
     0ABD           LOC_26:                     ;  xref 8362:0A41, 0A46, 0A80, 0A84
                                        ;            0AB3, 0AB8
     0ABD  E9 FF21              JMP LOC_13          ; (09E1)
                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0A43, 0AB5
                ;==========================================================================

                SUB_5       PROC    NEAR
     0AC0  50                   PUSH    AX
     0AC1  56                   PUSH    SI
     0AC2  8B F2                MOV SI,DX
     0AC4           LOC_27:                     ;  xref 8362:0ACB
     0AC4  AC                   LODSB               ; String [si] to al
     0AC5  84 C0                TEST    AL,AL
     0AC7  74 24                JZ  LOC_29          ; Jump if zero
     0AC9  3C 2E                CMP AL,2EH          ; '.'
     0ACB  75 F7                JNE LOC_27          ; Jump if not equal
     0ACD  E8 0022              CALL    SUB_6           ; (0AF2)
     0AD0  8A E0                MOV AH,AL
     0AD2  E8 001D              CALL    SUB_6           ; (0AF2)
     0AD5  3D 636F              CMP AX,636FH
     0AD8  74 0C                JE  LOC_28          ; Jump if equal
     0ADA  3D 6578              CMP AX,6578H
     0ADD  75 10                JNE LOC_30          ; Jump if not equal
     0ADF  E8 0010              CALL    SUB_6           ; (0AF2)
     0AE2  3C 65                CMP AL,65H          ; 'e'
     0AE4  EB 09                JMP SHORT LOC_30        ; (0AEF)


     0AE6                       LOC_28:                                         ;  xref 8362:0AD8
     0AE6  E8 0009              CALL    SUB_6           ; (0AF2)
     0AE9  3C 6D                CMP AL,6DH          ; 'm'
     0AEB  EB 02                JMP SHORT LOC_30        ; (0AEF)
     0AED           LOC_29:                     ;  xref 8362:0AC7
     0AED  FE C0                INC AL
     0AEF           LOC_30:                     ;  xref 8362:0ADD, 0AE4, 0AEB
     0AEF  5E                   POP SI
     0AF0  58                   POP AX
     0AF1  C3                   RETN
                SUB_5       ENDP


                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0ACD, 0AD2, 0ADF, 0AE6
                ;==========================================================================

                SUB_6       PROC    NEAR
     0AF2  AC                   LODSB               ; String [si] to al
     0AF3  3C 43                CMP AL,43H          ; 'C'
     0AF5  72 06                JB  LOC_RET_31      ; Jump if below
     0AF7  3C 59                CMP AL,59H          ; 'Y'
     0AF9  73 02                JAE LOC_RET_31      ; Jump if above or =
     0AFB  04 20                ADD AL,20H          ; ' '

     0AFD           LOC_RET_31:                 ;  xref 8362:0AF5, 0AF9
     0AFD  C3                   RETN
                SUB_6       ENDP


                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0966, 0994, 0A49, 0A87, 0B42, 0B59, 0B64
                ;                 0B6F, 0B79, 0C14
                ;==========================================================================

                SUB_7       PROC    NEAR
     0AFE  9C                   PUSHF               ; Push flags
     0AFF  0E                   PUSH    CS
     0B00  E8 FEDF              CALL    SUB_4           ; (09E2)
     0B03  C3                   RETN
                SUB_7       ENDP

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:09D8, 0A93, 0ABA
                ;==========================================================================

                SUB_8       PROC    NEAR
     0B04  E8 FE13              CALL    SUB_1           ; (091A)
     0B07  8C DE                MOV SI,DS
     0B09  33 C0                XOR AX,AX           ; Zero register
     0B0B  8E D8                MOV DS,AX
     0B0D  BF 004C              MOV DI,4CH
     0B10  C4 45 44             LES AX,DWORD PTR DS:DATA_2E[DI] ; (0000:0044=0F84DH) Load 32 bit ptr
     0B13  06                   PUSH    ES
     0B14  50                   PUSH    AX
     0B15  C7 45 44 00C9            MOV WORD PTR DS:DATA_2E[DI],0C9H    ; (0000:0044=0F84DH)
     0B1A  8C 4D 46             MOV WORD PTR DS:DATA_2E+2[DI],CS    ; (0000:0046=0F000H)
     0B1D  C4 05                LES AX,DWORD PTR [DI]   ; Load 32 bit ptr
     0B1F  2E: A3 0813              MOV CS:DATA_43,AX       ; (8362:0813=9090H)
     0B23  2E: 8C 06 0815           MOV CS:DATA_44,ES       ; (8362:0815=9090H)
     0B28  C7 05 07FE               MOV WORD PTR [DI],7FEH
     0B2C  8C 4D 02             MOV DS:DATA_1E[DI],CS   ; (0000:0002=279H)
     0B2F  06                   PUSH    ES
     0B30  50                   PUSH    AX
     0B31  57                   PUSH    DI
     0B32  1E                   PUSH    DS
     0B33  B4 54                MOV AH,54H          ; 'T'
     0B35  CD 21                INT 21H         ; DOS Services  ah=function 54h
                                        ;  get verify flag in al
     0B37  50                   PUSH    AX
     0B38  B8 2E00              MOV AX,2E00H
     0B3B  CD 21                INT 21H         ; DOS Services  ah=function 2Eh
                                        ;  verify flag al=0 on, al=1 off
     0B3D  8E DE                MOV DS,SI
     0B3F  B8 4300              MOV AX,4300H


     0B42  E8 FFB9                              CALL    SUB_7                   ; (0AFE)
     0B45  72 35                JC  LOC_34          ; Jump if carry Set
     0B47  F6 C1 04             TEST    CL,4
     0B4A  75 30                JNZ LOC_34          ; Jump if not zero
     0B4C  8B D9                MOV BX,CX
     0B4E  80 E1 FE             AND CL,0FEH
     0B51  3A CB                CMP CL,BL
     0B53  B8 4301              MOV AX,4301H
     0B56  50                   PUSH    AX
     0B57  74 04                JZ  LOC_32          ; Jump if zero
     0B59  E8 FFA2              CALL    SUB_7           ; (0AFE)
     0B5C  F5                   CMC             ; Complement carry
     0B5D           LOC_32:                     ;  xref 8362:0B57
     0B5D  9C                   PUSHF               ; Push flags
     0B5E  1E                   PUSH    DS
     0B5F  52                   PUSH    DX
     0B60  53                   PUSH    BX
     0B61  B8 3D02              MOV AX,3D02H
     0B64  E8 FF97              CALL    SUB_7           ; (0AFE)
     0B67  72 09                JC  LOC_33          ; Jump if carry Set
     0B69  93                   XCHG    AX,BX
     0B6A  E8 03E1              CALL    SUB_14          ; (0F4E)
     0B6D  B4 3E                MOV AH,3EH          ; '>'
     0B6F  E8 FF8C              CALL    SUB_7           ; (0AFE)
     0B72           LOC_33:                     ;  xref 8362:0B67
     0B72  59                   POP CX
     0B73  5A                   POP DX
     0B74  1F                   POP DS
     0B75  9D                   POPF                ; Pop flags
     0B76  58                   POP AX
     0B77  73 03                JNC LOC_34          ; Jump if carry=0
     0B79  E8 FF82              CALL    SUB_7           ; (0AFE)
     0B7C           LOC_34:                     ;  xref 8362:0B45, 0B4A, 0B77
     0B7C  58                   POP AX
     0B7D  B4 2E                MOV AH,2EH          ; '.'
     0B7F  CD 21                INT 21H         ; DOS Services  ah=function 2Eh
                                        ;  verify flag al=0 on, al=1 off
     0B81  1F                   POP DS
     0B82  A0 046C              MOV AL,DS:DATA_14E      ; (0000:046C=0AAH)
     0B85  48                   DEC AX
     0B86  0A 06 043F               OR  AL,DS:DATA_13E      ; (0000:043F=0)
     0B8A  24 0F                AND AL,0FH
     0B8C  75 44                JNZ LOC_37          ; Jump if not zero
     0B8E  B2 80                MOV DL,80H
     0B90  B4 08                MOV AH,8
     0B92  CD 13                INT 13H         ; Disk  dl=drive 0  ah=func 08h
                                        ;  read parameters for drive dl
     0B94  72 3C                JC  LOC_37          ; Jump if carry Set
     0B96  BF 0010              MOV DI,10H
     0B99           LOC_35:                     ;  xref 8362:0BD0
     0B99  B8 0201              MOV AX,201H
     0B9C  BB 0880              MOV BX,880H
     0B9F  B2 80                MOV DL,80H
     0BA1  CD 13                INT 13H         ; Disk  dl=drive 0  ah=func 02h
                                        ;  read sectors to memory es:bx
     0BA3  2E: 81 3F 1F0E           CMP WORD PTR CS:[BX],1F0EH
     0BA8  75 1F                JNE LOC_36          ; Jump if not equal
     0BAA  2E: 81 7F 02 2E83            CMP WORD PTR CS:DATA_22E+1[BX],2E83H    ; (8362:0002=0)
     0BB0  75 17                JNE LOC_36          ; Jump if not equal
     0BB2  B8 0202              MOV AX,202H
     0BB5  53                   PUSH    BX
     0BB6  B7 0A                MOV BH,0AH
     0BB8  49                   DEC CX
     0BB9  49                   DEC CX
     0BBA  CD 13                INT 13H         ; Disk  dl=drive 0  ah=func 02h
                                        ;  read sectors to memory es:bx
     0BBC  5B                   POP BX
     0BBD  B8 0303              MOV AX,303H
     0BC0  B9 0001              MOV CX,1
     0BC3  32 F6                XOR DH,DH           ; Zero register
     0BC5  CD 13                                INT     13H                     ; write sectors from mem es:bx
     0BC7  EB 09                JMP SHORT LOC_37        ; (0BD2)
     0BC9           LOC_36:                     ;  xref 8362:0BA8, 0BB0
     0BC9  84 ED                TEST    CH,CH
     0BCB  74 05                JZ  LOC_37          ; Jump if zero
     0BCD  FE CD                DEC CH
     0BCF  4F                   DEC DI
     0BD0  75 C7                JNZ LOC_35          ; Jump if not zero


     0BD2                       LOC_37:                                         ;  xref 8362:0B8C, 0B94, 0BC7, 0BCB
     0BD2  5F                   POP DI
     0BD3  8F 05                POP WORD PTR [DI]
     0BD5  8F 45 02             POP WORD PTR DS:DATA_1E[DI] ; (0000:0002=279H)
     0BD8  8F 45 44             POP WORD PTR DS:DATA_2E[DI] ; (0000:0044=0F84DH)
     0BDB  8F 45 46             POP WORD PTR DS:DATA_2E+2[DI]   ; (0000:0046=0F000H)
     0BDE           LOC_38:                     ;  xref 8362:0BFB, 0C04, 0C10, 0C3C
                                        ;            0F4B
     0BDE  07                   POP ES
     0BDF  1F                   POP DS
     0BE0  5F                   POP DI
     0BE1  5E                   POP SI
     0BE2  5A                   POP DX
     0BE3  59                   POP CX
     0BE4  5B                   POP BX
     0BE5  58                   POP AX
     0BE6  44                   INC SP
     0BE7  44                   INC SP
     0BE8  C3                   RETN
                SUB_8       ENDP


                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0A4E
                ;==========================================================================

                SUB_9       PROC    NEAR
     0BE9  E8 FD2E              CALL    SUB_1           ; (091A)
     0BEC  0E                   PUSH    CS
     0BED  07                   POP ES
     0BEE  BF 0824              MOV DI,824H
     0BF1  AB                   STOSW               ; Store ax to es:[di]
     0BF2  8B F2                MOV SI,DX
     0BF4  B9 0050              MOV CX,50H

     0BF7           LOCLOOP_39:                 ;  xref 8362:0BFD
     0BF7  AC                   LODSB               ; String [si] to al
     0BF8  AA                   STOSB               ; Store al to es:[di]
     0BF9  84 C0                TEST    AL,AL
     0BFB  74 E1                JZ  LOC_38          ; Jump if zero
     0BFD  E2 F8                LOOP    LOCLOOP_39      ; Loop if cx > 0

     0BFF  26: 89 0E 0824           MOV ES:DATA_47,CX       ; (8362:0824=9090H)
     0C04  EB D8                JMP SHORT LOC_38        ; (0BDE)
                SUB_9       ENDP


                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0A0B
                ;==========================================================================

                SUB_10      PROC    NEAR
     0C06  E8 FD11              CALL    SUB_1           ; (091A)
     0C09  0E                   PUSH    CS
     0C0A  1F                   POP DS
     0C0B  80 3E 0877 00            CMP DATA_49,0       ; (8362:0877=90H)
     0C10  74 CC                JE  LOC_38          ; Jump if equal
     0C12  B4 51                MOV AH,51H          ; 'Q'
     0C14  E8 FEE7              CALL    SUB_7           ; (0AFE)
     0C17  8E C3                MOV ES,BX
     0C19  26: 8B 0E 0006           MOV CX,ES:DATA_15E      ; (0008:0006=10DAH)
     0C1E  2B FF                SUB DI,DI
     0C20           LOC_40:                     ;  xref 8362:0C31
     0C20  BE 07F5              MOV SI,7F5H
     0C23  AC                   LODSB               ; String [si] to al
     0C24  F2/ AE               REPNE   SCASB           ; Rep zf=0+cx >0 Scan es:[di] for al
     0C26  75 0F                JNZ LOC_41          ; Jump if not zero
     0C28  51                   PUSH    CX
     0C29  57                   PUSH    DI
     0C2A  B9 0007              MOV CX,7
     0C2D  F3/ A6               REPE    CMPSB           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
     0C2F  5F                   POP DI
     0C30  59                   POP CX
     0C31  75 ED                JNZ LOC_40          ; Jump if not zero
     0C33  B0 54                MOV AL,54H          ; 'T'
     0C35  E6 43                OUT 43H,AL          ; port 43H, 8253 wrt timr mode


     0C37                       LOC_41:                                         ;  xref 8362:0C26
     0C37  C6 06 0877 00            MOV DATA_49,0       ; (8362:0877=90H)
     0C3C  EB A0                JMP SHORT LOC_38        ; (0BDE)
                SUB_10      ENDP

     0C3E           LOC_42:                     ;  xref 8362:0C75, 0ECE
     0C3E  BF 0100              MOV DI,100H
     0C41  81 C6 0817               ADD SI,817H
     0C45  8B 26 0006               MOV SP,DS:DATA_25E      ; (8362:0006=0)
     0C49  33 DB                XOR BX,BX           ; Zero register
     0C4B  53                   PUSH    BX
     0C4C  57                   PUSH    DI
     0C4D  A4                   MOVSB               ; Mov [si] to es:[di]
     0C4E  A5                   MOVSW               ; Mov [si] to es:[di]
     0C4F  C3                   RETN

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0956
                ;==========================================================================

                SUB_11      PROC    NEAR
     0C50  5E                   POP SI
     0C51  81 EE 0050               SUB SI,50H
     0C55  FC                   CLD             ; Clear direction
     0C56  2E: FF 84 0822           INC CS:DATA_46[SI]      ; (8362:0822=9090H)
     0C5B  2E: F6 94 07F5           NOT BYTE PTR CS:DATA_38[SI] ; (8362:07F5=90H)
     0C60  2E: 81 BC 0817 5A4D          CMP CS:DATA_45[SI],5A4DH    ; (8362:0817=9090H)
     0C67  74 0E                JE  LOC_43          ; Jump if equal
     0C69  FA                   CLI             ; Disable interrupts
     0C6A  8B E6                MOV SP,SI
     0C6C  81 C4 0924               ADD SP,924H
     0C70  FB                   STI             ; Enable interrupts
     0C71  3B 26 0006               CMP SP,DS:DATA_25E      ; (8362:0006=0)
     0C75  73 C7                JAE LOC_42          ; Jump if above or =
     0C77           LOC_43:                     ;  xref 8362:0C67
     0C77  50                   PUSH    AX
     0C78  06                   PUSH    ES
     0C79  56                   PUSH    SI
     0C7A  1E                   PUSH    DS
     0C7B  8B FE                MOV DI,SI
     0C7D  33 C0                XOR AX,AX           ; Zero register
     0C7F  50                   PUSH    AX
     0C80  8E D8                MOV DS,AX
     0C82  C5 16 004C               LDS DX,DWORD PTR DS:DATA_4E ; (0000:004C=0FF0H) Load 32 bit ptr
     0C86  B4 30                MOV AH,30H          ; '0'
     0C88  CD 21                INT 21H         ; DOS Services  ah=function 30h
                                        ;  get DOS version number ax
     0C8A  2E: 88 84 0876           MOV CS:DATA_48[SI],AL   ; (8362:0876=90H)
     0C8F  3C 03                CMP AL,3
     0C91  72 0C                JB  LOC_44          ; Jump if below
     0C93  B4 13                MOV AH,13H
     0C95  CD 2F                INT 2FH         ; Multiplex/Spooler al=func 00h
                                        ;  get installed status
     0C97  1E                   PUSH    DS
     0C98  52                   PUSH    DX
     0C99  B4 13                MOV AH,13H
     0C9B  CD 2F                INT 2FH         ; Multiplex/Spooler al=func 00h
                                        ;  get installed status
     0C9D  5A                   POP DX
     0C9E  1F                   POP DS
     0C9F           LOC_44:                     ;  xref 8362:0C91
     0C9F  2E: 89 94 0809           MOV CS:DATA_39[SI],DX   ; (8362:0809=9090H)
     0CA4  2E: 8C 9C 080B           MOV CS:DATA_40[SI],DS   ; (8362:080B=9090H)
     0CA9  2E: 89 94 080E           MOV CS:DATA_41[SI],DX   ; (8362:080E=9090H)
     0CAE  2E: 8C 9C 0810           MOV CS:DATA_42[SI],DS   ; (8362:0810=9090H)
     0CB3  1F                   POP DS
     0CB4  1E                   PUSH    DS
     0CB5  A1 0102              MOV AX,DS:DATA_11E      ; (0000:0102=10DAH)
     0CB8  3D F000              CMP AX,0F000H
     0CBB  75 76                JNE LOC_52          ; Jump if not equal
     0CBD  2E: 89 84 080B           MOV CS:DATA_40[SI],AX   ; (8362:080B=9090H)
     0CC2  A1 0100              MOV AX,DS:DATA_10E      ; (0000:0100=18CCH)
     0CC5  2E: 89 84 0809           MOV CS:DATA_39[SI],AX   ; (8362:0809=9090H)
     0CCA  B2 80                MOV DL,80H
     0CCC  A1 0106              MOV AX,DS:DATA_12E      ; (0000:0106=0F000H)
     0CCF  3D F000              CMP AX,0F000H
     0CD2  74 1C                JE  LOC_45          ; Jump if equal


     0CD4  80 FC C8                             CMP     AH,0C8H
     0CD7  72 5A                JB  LOC_52          ; Jump if below
     0CD9  80 FC F4             CMP AH,0F4H
     0CDC  73 55                JAE LOC_52          ; Jump if above or =
     0CDE  A8 7F                TEST    AL,7FH
     0CE0  75 51                JNZ LOC_52          ; Jump if not zero
     0CE2  8E D8                MOV DS,AX
     0CE4  81 3E 0000 AA55          CMP WORD PTR DS:DATA_60E,0AA55H ; (F000:0000=8B66H)
     0CEA  75 47                JNE LOC_52          ; Jump if not equal
     0CEC  8A 16 0002               MOV DL,DS:DATA_61E      ; (F000:0002=0D8H)
     0CF0           LOC_45:                     ;  xref 8362:0CD2
     0CF0  8E D8                MOV DS,AX
     0CF2  32 F6                XOR DH,DH           ; Zero register
     0CF4  B1 09                MOV CL,9
     0CF6  D3 E2                SHL DX,CL           ; Shift w/zeros fill
     0CF8  8B CA                MOV CX,DX
     0CFA  33 F6                XOR SI,SI           ; Zero register

     0CFC           LOCLOOP_46:                 ;  xref 8362:0D22
     0CFC  AD                   LODSW               ; String [si] to ax
     0CFD  3D FA80              CMP AX,0FA80H
     0D00  75 08                JNE LOC_47          ; Jump if not equal
     0D02  AD                   LODSW               ; String [si] to ax
     0D03  3D 7380              CMP AX,7380H
     0D06  74 0D                JE  LOC_48          ; Jump if equal
     0D08  75 15                JNZ LOC_49          ; Jump if not zero
     0D0A           LOC_47:                     ;  xref 8362:0D00
     0D0A  3D C2F6              CMP AX,0C2F6H
     0D0D  75 12                JNE LOC_50          ; Jump if not equal
     0D0F  AD                   LODSW               ; String [si] to ax
     0D10  3D 7580              CMP AX,7580H
     0D13  75 0A                JNE LOC_49          ; Jump if not equal
     0D15           LOC_48:                     ;  xref 8362:0D06
     0D15  46                   INC SI
     0D16  AD                   LODSW               ; String [si] to ax
     0D17  3D 40CD              CMP AX,40CDH
     0D1A  74 0A                JE  LOC_51          ; Jump if equal
     0D1C  83 EE 03             SUB SI,3
     0D1F           LOC_49:                     ;  xref 8362:0D08, 0D13
     0D1F  4E                   DEC SI
     0D20  4E                   DEC SI
     0D21           LOC_50:                     ;  xref 8362:0D0D
     0D21  4E                   DEC SI
     0D22  E2 D8                LOOP    LOCLOOP_46      ; Loop if cx > 0

     0D24  EB 0D                JMP SHORT LOC_52        ; (0D33)
     0D26           LOC_51:                     ;  xref 8362:0D1A
     0D26  83 EE 07             SUB SI,7
     0D29  2E: 89 B5 080E           MOV CS:DATA_41[DI],SI   ; (8362:080E=9090H)
     0D2E  2E: 8C 9D 0810           MOV CS:DATA_42[DI],DS   ; (8362:0810=9090H)
     0D33           LOC_52:                     ;  xref 8362:0CBB, 0CD7, 0CDC, 0CE0
                                        ;            0CEA, 0D24
     0D33  8B F7                MOV SI,DI
     0D35  1F                   POP DS
     0D36  C4 06 0084               LES AX,DWORD PTR DS:DATA_6E ; (0000:0084=11B8H) Load 32 bit ptr
     0D3A  2E: 89 84 087C           MOV WORD PTR CS:DATA_52[SI],AX  ; (8362:087C=9090H)
     0D3F  2E: 8C 84 087E           MOV WORD PTR CS:DATA_52+2[SI],ES    ; (8362:087E=9090H)
     0D44  0E                   PUSH    CS
     0D45  1F                   POP DS
     0D46  F6 94 07F5               NOT BYTE PTR DATA_38[SI]    ; (8362:07F5=90H)
     0D4A  3D 00EB              CMP AX,0EBH
     0D4D  75 0D                JNE LOC_53          ; Jump if not equal
     0D4F  33 FF                XOR DI,DI           ; Zero register
     0D51  B9 0809              MOV CX,809H
     0D54  F3/ A6               REPE    CMPSB           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
     0D56  75 04                JNZ LOC_53          ; Jump if not zero
     0D58  07                   POP ES
     0D59  E9 0085              JMP LOC_56          ; (0DE1)
     0D5C           LOC_53:                     ;  xref 8362:0D4D, 0D56
     0D5C  1F                   POP DS
     0D5D  1E                   PUSH    DS
     0D5E  8B C4                MOV AX,SP
     0D60  40                   INC AX
     0D61  B1 04                MOV CL,4
     0D63  D3 E8                SHR AX,CL           ; Shift w/zeros fill
     0D65  40                   INC AX
     0D66  8C D1                MOV CX,SS
     0D68  03 C1                ADD AX,CX


     0D6A  8C D9                                MOV     CX,DS
     0D6C  49                   DEC CX
     0D6D  8E C1                MOV ES,CX
     0D6F  BF 0002              MOV DI,2
     0D72  BA 010C              MOV DX,10CH
     0D75  8B 0D                MOV CX,[DI]
     0D77  2B CA                SUB CX,DX
     0D79  3B C8                CMP CX,AX
     0D7B  72 63                JB  LOC_55          ; Jump if below
     0D7D  58                   POP AX
     0D7E  26: 29 55 01             SUB ES:DATA_66E[DI],DX  ; (FFAF:0001=0F8FEH)
     0D82  89 0D                MOV [DI],CX
     0D84  8E C1                MOV ES,CX
     0D86  8B C1                MOV AX,CX
     0D88  E8 0358              CALL    SUB_16          ; (10E3)
     0D8B  8B D8                MOV BX,AX
     0D8D  8B CA                MOV CX,DX
     0D8F  8C D8                MOV AX,DS
     0D91  E8 034F              CALL    SUB_16          ; (10E3)
     0D94  03 45 04             ADD AX,DS:DATA_68E[DI]  ; (FFB0:0004=183CH)
     0D97  83 D2 00             ADC DX,0
     0D9A  2B C3                SUB AX,BX
     0D9C  1B D1                SBB DX,CX
     0D9E  72 03                JC  LOC_54          ; Jump if carry Set
     0DA0  29 45 04             SUB DS:DATA_68E[DI],AX  ; (FFB0:0004=183CH)
     0DA3           LOC_54:                     ;  xref 8362:0D9E
     0DA3  5E                   POP SI
     0DA4  56                   PUSH    SI
     0DA5  1E                   PUSH    DS
     0DA6  0E                   PUSH    CS
     0DA7  33 FF                XOR DI,DI           ; Zero register
     0DA9  8E DF                MOV DS,DI
     0DAB  C5 06 009C               LDS AX,DWORD PTR DS:DATA_8E ; (0000:009C=1737H) Load 32 bit ptr
     0DAF  2E: 89 84 0878           MOV WORD PTR CS:DATA_50[SI],AX  ; (8362:0878=9090H)
     0DB4  2E: 8C 9C 087A           MOV WORD PTR CS:DATA_50+2[SI],DS    ; (8362:087A=9090H)
     0DB9  1F                   POP DS
     0DBA  C6 84 0877 00            MOV DATA_49[SI],0       ; (8362:0877=90H)
     0DBF  B9 0440              MOV CX,440H
     0DC2  F3/ A5               REP MOVSW           ; Rep when cx >0 Mov [si] to es:[di]
     0DC4  33 C0                XOR AX,AX           ; Zero register
     0DC6  8E D8                MOV DS,AX
     0DC8  C7 06 0084 00EB          MOV WORD PTR DS:DATA_6E,0EBH    ; (0000:0084=11B8H)
     0DCE  8C 06 0086               MOV WORD PTR DS:DATA_6E+2,ES    ; (0000:0086=10DAH)
     0DD2  C7 06 009C 00DE          MOV WORD PTR DS:DATA_8E,0DEH    ; (0000:009C=1737H)
     0DD8  8C 06 009E               MOV WORD PTR DS:DATA_8E+2,ES    ; (0000:009E=10DAH)
     0DDC  26: A3 0824              MOV ES:DATA_21E,AX      ; (7D0C:0824=0FFFFH)
     0DE0           LOC_55:                     ;  xref 8362:0D7B
     0DE0  07                   POP ES
     0DE1           LOC_56:                     ;  xref 8362:0D59
     0DE1  5E                   POP SI
     0DE2  33 C0                XOR AX,AX           ; Zero register
     0DE4  8E D8                MOV DS,AX
     0DE6  A1 004C              MOV AX,DS:DATA_4E       ; (0000:004C=0FF0H)
     0DE9  2E: 89 84 0813           MOV CS:DATA_43[SI],AX   ; (8362:0813=9090H)
     0DEE  A1 004E              MOV AX,WORD PTR DS:DATA_4E+2    ; (0000:004E=10DAH)
     0DF1  2E: 89 84 0815           MOV CS:DATA_44[SI],AX   ; (8362:0815=9090H)
     0DF6  C7 06 004C 07FE          MOV WORD PTR DS:DATA_4E,7FEH    ; (0000:004C=0FF0H)
     0DFC  01 36 004C               ADD DS:DATA_4E,SI       ; (0000:004C=0FF0H)
     0E00  8C 0E 004E               MOV WORD PTR DS:DATA_4E+2,CS    ; (0000:004E=10DAH)
     0E04  1F                   POP DS
     0E05  1E                   PUSH    DS
     0E06  56                   PUSH    SI
     0E07  8E 1E 002C               MOV DS,DS:DATA_77E      ; (FFB0:002C=0FF18H)
     0E0B  33 F6                XOR SI,SI           ; Zero register
     0E0D           LOC_57:                     ;  xref 8362:0E11
     0E0D  AD                   LODSW               ; String [si] to ax
     0E0E  4E                   DEC SI
     0E0F  85 C0                TEST    AX,AX
     0E11  75 FA                JNZ LOC_57          ; Jump if not zero
     0E13  5F                   POP DI
     0E14  57                   PUSH    DI
     0E15  06                   PUSH    ES
     0E16  2E: 80 BD 0876 03            CMP CS:DATA_48[DI],3    ; (8362:0876=90H)
     0E1C  72 08                JB  LOC_58          ; Jump if below
     0E1E  83 C6 03             ADD SI,3
     0E21  B8 121A              MOV AX,121AH
     0E24  CD 2F                INT 2FH         ; Multiplex/Spooler al=func 1Ah



     0E26                       LOC_58:                                         ;  xref 8362:0E1C
     0E26  8A D0                MOV DL,AL
     0E28  B4 32                MOV AH,32H          ; '2'
     0E2A  CD 21                INT 21H         ; DOS Services  ah=function 32h
                                        ;  get ds:bx ptr to disk block
     0E2C  0E                   PUSH    CS
     0E2D  07                   POP ES
     0E2E  81 C7 00C9               ADD DI,0C9H
     0E32  8B F7                MOV SI,DI
     0E34  B0 1A                MOV AL,1AH
     0E36  8A 67 01             MOV AH,DS:DATA_62E[BX]  ; (FF18:0001=0)
     0E39  AB                   STOSW               ; Store ax to es:[di]
     0E3A  B0 04                MOV AL,4
     0E3C  AA                   STOSB               ; Store al to es:[di]
     0E3D  83 C7 0A             ADD DI,0AH
     0E40  8B 57 0B             MOV DX,DS:DATA_63E[BX]  ; (FF18:000B=0)
     0E43  2E: 38 84 07AD           CMP BYTE PTR CS:DATA_37[SI],AL  ; (8362:07AD=90H)
     0E48  72 01                JB  LOC_59          ; Jump if below
     0E4A  43                   INC BX
     0E4B           LOC_59:                     ;  xref 8362:0E48
     0E4B  8A 47 16             MOV AL,DS:DATA_65E[BX]  ; (FF18:0016=0)
     0E4E  AA                   STOSB               ; Store al to es:[di]
     0E4F  8B C6                MOV AX,SI
     0E51  05 0040              ADD AX,40H
     0E54  AB                   STOSW               ; Store ax to es:[di]
     0E55  8C C0                MOV AX,ES
     0E57  AB                   STOSW               ; Store ax to es:[di]
     0E58  B8 0001              MOV AX,1
     0E5B  AB                   STOSW               ; Store ax to es:[di]
     0E5C  48                   DEC AX
     0E5D  AB                   STOSW               ; Store ax to es:[di]
     0E5E  C5 7F 12             LDS DI,DWORD PTR DS:DATA_64E[BX]    ; (FF18:0012=0) Load 32 bit ptr
     0E61  8B DE                MOV BX,SI
     0E63  0E                   PUSH    CS
     0E64  E8 FAF2              CALL    SUB_2           ; (0959)
     0E67  26: D0 67 02             SHL BYTE PTR ES:DATA_22E+1[BX],1    ; (8362:0002=0) Shift w/zeros fill
     0E6B  26: FE 47 4A             INC BYTE PTR ES:DATA_34E[BX]    ; (8362:004A=0)
     0E6F  26: 80 67 4A 0F          AND BYTE PTR ES:DATA_34E[BX],0FH    ; (8362:004A=0)
     0E74  9C                   PUSHF               ; Push flags
     0E75  75 1D                JNZ LOC_61          ; Jump if not zero
     0E77  26: 8B 47 48             MOV AX,ES:DATA_33E[BX]  ; (8362:0048=0)
     0E7B  05 0040              ADD AX,40H
     0E7E  26: 3B 47 53             CMP AX,ES:DATA_35E[BX]  ; (8362:0053=0)
     0E82  72 0C                JB  LOC_60          ; Jump if below
     0E84  40                   INC AX
     0E85  25 003F              AND AX,3FH
     0E88  03 C2                ADD AX,DX
     0E8A  26: 3B 47 53             CMP AX,ES:DATA_35E[BX]  ; (8362:0053=0)
     0E8E  73 14                JAE LOC_63          ; Jump if above or =
     0E90           LOC_60:                     ;  xref 8362:0E82
     0E90  26: 89 47 48             MOV ES:DATA_33E[BX],AX  ; (8362:0048=0)
     0E94           LOC_61:                     ;  xref 8362:0E75
     0E94  0E                   PUSH    CS
     0E95  E8 FAC1              CALL    SUB_2           ; (0959)
     0E98  9D                   POPF                ; Pop flags
     0E99  75 08                JNZ LOC_62          ; Jump if not zero
     0E9B  26: 89 47 14             MOV ES:DATA_29E[BX],AX  ; (8362:0014=0)
     0E9F  0E                   PUSH    CS
     0EA0  E8 FAB6              CALL    SUB_2           ; (0959)
     0EA3           LOC_62:                     ;  xref 8362:0E99
     0EA3  9C                   PUSHF               ; Push flags
     0EA4           LOC_63:                     ;  xref 8362:0E8E
     0EA4  9D                   POPF                ; Pop flags
     0EA5  07                   POP ES
     0EA6  5E                   POP SI
     0EA7  33 C0                XOR AX,AX           ; Zero register
     0EA9  8E D8                MOV DS,AX
     0EAB  2E: 88 84 07F5           MOV BYTE PTR CS:DATA_38[SI],AL  ; (8362:07F5=90H)
     0EB0  2E: 8B 84 0813           MOV AX,CS:DATA_43[SI]   ; (8362:0813=9090H)
     0EB5  A3 004C              MOV DS:DATA_4E,AX       ; (0000:004C=0FF0H)
     0EB8  2E: 8B 84 0815           MOV AX,CS:DATA_44[SI]   ; (8362:0815=9090H)
     0EBD  A3 004E              MOV WORD PTR DS:DATA_4E+2,AX    ; (0000:004E=10DAH)
     0EC0  1F                   POP DS
     0EC1  58                   POP AX
     0EC2  2E: 81 BC 0817 5A4D          CMP CS:DATA_45[SI],5A4DH    ; (8362:0817=9090H)
     0EC9  75 03                JNE LOC_64          ; Jump if not equal
     0ECB  E9 FA5A              JMP LOC_3           ; (0928)
     0ECE           LOC_64:                     ;  xref 8362:0EC9


     0ECE  E9 FD6D                              JMP     LOC_42                  ; (0C3E)
                SUB_11      ENDP

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:09D5
                ;==========================================================================
                                SUB_12
     0ED1  E8 FA46              CALL    SUB_1           ; (091A)
     0ED4  B4 51                MOV AH,51H          ; 'Q'
     0ED6  CD 21                INT 21H         ; DOS Services  ah=function 51h
                                        ;  get active PSP segment in bx
     0ED8  2B FF                SUB DI,DI
     0EDA  8B C7                MOV AX,DI
     0EDC  4B                   DEC BX
     0EDD           LOC_65:                     ;  xref 8362:0EE7
     0EDD  13 D8                ADC BX,AX
     0EDF  8E DB                MOV DS,BX
     0EE1  8B 45 03             MOV AX,WORD PTR DS:[3][DI]  ; (FFFF:0003=0F000H)
     0EE4  80 3D 5A             CMP BYTE PTR [DI],5AH   ; 'Z'
     0EE7  72 F4                JB  LOC_65          ; Jump if below
     0EE9  3B 7D 01             CMP DI,DS:DATA_22E[DI]  ; (8362:0001=0)
     0EEC  75 5D                JNE LOC_71          ; Jump if not equal
     0EEE  43                   INC BX
     0EEF  8E C3                MOV ES,BX
     0EF1  3D 1000              CMP AX,1000H
     0EF4  72 03                JB  LOC_66          ; Jump if below
     0EF6  B8 1000              MOV AX,1000H
     0EF9           LOC_66:                     ;  xref 8362:0EF4
     0EF9  B1 03                MOV CL,3
     0EFB  D3 E0                SHL AX,CL           ; Shift w/zeros fill
     0EFD  8B C8                MOV CX,AX
     0EFF  F3/ AB               REP STOSW           ; Rep when cx >0 Store ax to es:[di]
     0F01  EB 48                JMP SHORT LOC_71        ; (0F4B)

                ;==== External Entry into Subroutine ======================================
                ;         Called from:   8362:09E7, 09EF
                SUB_13:
     0F03  E8 FA14              CALL    SUB_1           ; (091A)
     0F06  B9 00EB              MOV CX,0EBH
     0F09  33 FF                XOR DI,DI           ; Zero register
     0F0B  8E DF                MOV DS,DI
     0F0D  C4 16 0084               LES DX,DWORD PTR DS:DATA_6E ; (0000:0084=11B8H) Load 32 bit ptr
     0F11  0E                   PUSH    CS
     0F12  1F                   POP DS
     0F13  3B D1                CMP DX,CX
     0F15  75 08                JNE LOC_67          ; Jump if not equal
     0F17  8C C0                MOV AX,ES
     0F19  8C CE                MOV SI,CS
     0F1B  3B C6                CMP AX,SI
     0F1D  74 2C                JE  LOC_71          ; Jump if equal
     0F1F           LOC_67:                     ;  xref 8362:0F15, 0F2F
     0F1F  26: 8B 05                MOV AX,ES:[DI]
     0F22  3B C1                CMP AX,CX
     0F24  75 08                JNE LOC_68          ; Jump if not equal
     0F26  8C C8                MOV AX,CS
     0F28  26: 3B 45 02             CMP AX,ES:DATA_19E[DI]  ; (10DA:0002=169AH)
     0F2C  74 05                JE  LOC_69          ; Jump if equal
     0F2E           LOC_68:                     ;  xref 8362:0F24
     0F2E  47                   INC DI
     0F2F  75 EE                JNZ LOC_67          ; Jump if not zero
     0F31  EB 0C                JMP SHORT LOC_70        ; (0F3F)
     0F33           LOC_69:                     ;  xref 8362:0F2C
     0F33  BE 087C              MOV SI,87CH
     0F36  FC                   CLD             ; Clear direction
     0F37  A5                   MOVSW               ; Mov [si] to es:[di]
     0F38  A5                   MOVSW               ; Mov [si] to es:[di]
     0F39  89 54 FC             MOV DS:DATA_58E[SI],DX  ; (8362:FFFC=0)
     0F3C  8C 44 FE             MOV DS:DATA_59E[SI],ES  ; (8362:FFFE=0)
     0F3F           LOC_70:                     ;  xref 8362:0F31
     0F3F  33 FF                XOR DI,DI           ; Zero register
     0F41  8E DF                MOV DS,DI
     0F43  89 0E 0084               MOV DS:DATA_6E,CX       ; (0000:0084=11B8H)
     0F47  8C 0E 0086               MOV WORD PTR DS:DATA_6E+2,CS    ; (0000:0086=10DAH)
     0F4B           LOC_71:                     ;  xref 8362:0EEC, 0F01, 0F1D
     0F4B  E9 FC90              JMP LOC_38          ; (0BDE)
                SUB_12      ENDP




                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8362:0B6A
                ;==========================================================================
                                SUB_14
     0F4E  0E                   PUSH    CS
     0F4F  1F                   POP DS
     0F50  0E                   PUSH    CS
     0F51  07                   POP ES
     0F52  BE 0880              MOV SI,880H
     0F55  8B D6                MOV DX,SI
     0F57  B9 0018              MOV CX,18H
     0F5A  B4 3F                MOV AH,3FH          ; '?'
     0F5C  CD 21                INT 21H         ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
     0F5E  33 C9                XOR CX,CX           ; Zero register
     0F60  33 D2                XOR DX,DX           ; Zero register
     0F62  B8 4202              MOV AX,4202H
     0F65  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0F67  89 54 1A             MOV DS:DATA_32E[SI],DX  ; (8362:001A=0)
     0F6A  3D 0809              CMP AX,809H
     0F6D  83 DA 00             SBB DX,0
     0F70  72 76                JC  LOC_RET_75      ; Jump if carry Set
     0F72  89 44 18             MOV DS:DATA_31E[SI],AX  ; (8362:0018=0)
     0F75  B8 5A4D              MOV AX,5A4DH
     0F78  39 04                CMP [SI],AX
     0F7A  74 08                JE  LOC_72          ; Jump if equal
     0F7C  81 3C 4D5A               CMP WORD PTR [SI],4D5AH
     0F80  75 1D                JNE LOC_73          ; Jump if not equal
     0F82  89 04                MOV [SI],AX
     0F84           LOC_72:                     ;  xref 8362:0F7A
     0F84  8B 44 0C             MOV AX,DS:DATA_27E[SI]  ; (8362:000C=0)
     0F87  85 C0                TEST    AX,AX
     0F89  74 5D                JZ  LOC_RET_75      ; Jump if zero
     0F8B  8B 44 08             MOV AX,DS:DATA_26E[SI]  ; (8362:0008=0)
     0F8E  03 44 16             ADD AX,DS:DATA_30E[SI]  ; (8362:0016=0)
     0F91  E8 014F              CALL    SUB_16          ; (10E3)
     0F94  03 44 14             ADD AX,DS:DATA_29E[SI]  ; (8362:0014=0)
     0F97  83 D2 00             ADC DX,0
     0F9A  8B CA                MOV CX,DX
     0F9C  92                   XCHG    AX,DX
     0F9D  EB 12                JMP SHORT LOC_74        ; (0FB1)
     0F9F           LOC_73:                     ;  xref 8362:0F80
     0F9F  80 3C E9             CMP BYTE PTR [SI],0E9H
     0FA2  75 45                JNE LOC_76          ; Jump if not equal
     0FA4  8B 54 01             MOV DX,DS:DATA_22E[SI]  ; (8362:0001=0)
     0FA7  81 C2 0103               ADD DX,103H
     0FAB  72 3C                JC  LOC_76          ; Jump if carry Set
     0FAD  FE CE                DEC DH
     0FAF  33 C9                XOR CX,CX           ; Zero register
     0FB1           LOC_74:                     ;  xref 8362:0F9D
     0FB1  83 EA 4D             SUB DX,4DH
     0FB4  83 D9 00             SBB CX,0
     0FB7  B8 4200              MOV AX,4200H
     0FBA  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0FBC  05 0824              ADD AX,824H
     0FBF  83 D2 00             ADC DX,0
     0FC2  2B 44 18             SUB AX,DS:DATA_31E[SI]  ; (8362:0018=0)
     0FC5  1B 54 1A             SBB DX,DS:DATA_32E[SI]  ; (8362:001A=0)
     0FC8  42                   INC DX
     0FC9  75 1E                JNZ LOC_76          ; Jump if not zero
     0FCB  3D FFF0              CMP AX,0FFF0H
     0FCE  72 19                JB  LOC_76          ; Jump if below
     0FD0  83 C6 1C             ADD SI,1CH
     0FD3  8B D6                MOV DX,SI
     0FD5  B9 0809              MOV CX,809H
     0FD8  B4 3F                MOV AH,3FH          ; '?'
     0FDA  CD 21                INT 21H         ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
     0FDC  72 0B                JC  LOC_76          ; Jump if carry Set
     0FDE  3B C8                CMP CX,AX
     0FE0  75 07                JNE LOC_76          ; Jump if not equal
     0FE2  33 FF                XOR DI,DI           ; Zero register
     0FE4  F3/ A6               REPE    CMPSB           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
     0FE6  75 01                JNZ LOC_76          ; Jump if not zero



     0FE8           LOC_RET_75:                 ;  xref 8362:0F70, 0F89
     0FE8  C3                   RETN
     0FE9           LOC_76:                     ;  xref 8362:0FA2, 0FAB, 0FC9, 0FCE
                                        ;            0FDC, 0FE0, 0FE6
     0FE9  BE 0880              MOV SI,880H
     0FEC  33 C9                XOR CX,CX           ; Zero register
     0FEE  33 D2                XOR DX,DX           ; Zero register
     0FF0  B8 4202              MOV AX,4202H
     0FF3  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0FF5  C6 44 F6 00              MOV BYTE PTR DS:DATA_57E[SI],0  ; (8362:FFF6=0)
     0FF9  81 3C 5A4D               CMP WORD PTR [SI],5A4DH
     0FFD  74 09                JE  LOC_77          ; Jump if equal
     0FFF  05 0A80              ADD AX,0A80H
     1002  83 D2 00             ADC DX,0
     1005  74 19                JZ  LOC_78          ; Jump if zero
     1007  C3                   RETN
     1008           LOC_77:                     ;  xref 8362:0FFD
     1008  8B 54 18             MOV DX,DS:DATA_31E[SI]  ; (8362:0018=0)
     100B  88 54 F6             MOV DS:DATA_57E[SI],DL  ; (8362:FFF6=0)
     100E  F6 DA                NEG DL
     1010  83 E2 0F             AND DX,0FH
     1013  33 C9                XOR CX,CX           ; Zero register
     1015  B8 4201              MOV AX,4201H
     1018  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     101A  89 44 18             MOV DS:DATA_31E[SI],AX  ; (8362:0018=0)
     101D  89 54 1A             MOV DS:DATA_32E[SI],DX  ; (8362:001A=0)
     1020           LOC_78:                     ;  xref 8362:1005
     1020  B8 5700              MOV AX,5700H
     1023  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
     1025  9C                   PUSHF               ; Push flags
     1026  51                   PUSH    CX
     1027  52                   PUSH    DX
     1028  BF 0817              MOV DI,817H
     102B  56                   PUSH    SI
     102C  A4                   MOVSB               ; Mov [si] to es:[di]
     102D  A5                   MOVSW               ; Mov [si] to es:[di]
     102E  83 C6 11             ADD SI,11H
     1031  A5                   MOVSW               ; Mov [si] to es:[di]
     1032  A5                   MOVSW               ; Mov [si] to es:[di]
     1033  83 EE 0A             SUB SI,0AH
     1036  A5                   MOVSW               ; Mov [si] to es:[di]
     1037  A5                   MOVSW               ; Mov [si] to es:[di]
     1038  5E                   POP SI
     1039  33 D2                XOR DX,DX           ; Zero register
     103B  B9 0824              MOV CX,824H
     103E  B4 40                MOV AH,40H          ; '@'
     1040  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     1042  72 17                JC  LOC_80          ; Jump if carry Set
     1044  33 C8                XOR CX,AX
     1046  75 17                JNZ LOC_81          ; Jump if not zero
     1048  8A 4C F6             MOV CL,DS:DATA_57E[SI]  ; (8362:FFF6=0)
     104B  80 E1 0F             AND CL,0FH
     104E  85 C9                TEST    CX,CX
     1050  75 02                JNZ LOC_79          ; Jump if not zero
     1052  B1 10                MOV CL,10H
     1054           LOC_79:                     ;  xref 8362:1050
     1054  BA 0000              MOV DX,0
     1057  B4 40                MOV AH,40H          ; '@'
     1059  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     105B           LOC_80:                     ;  xref 8362:1042
     105B  72 76                JC  LOC_86          ; Jump if carry Set
     105D  33 C8                XOR CX,AX
     105F           LOC_81:                     ;  xref 8362:1046
     105F  75 72                JNZ LOC_86          ; Jump if not zero
     1061  8B D1                MOV DX,CX
     1063  B8 4200              MOV AX,4200H
     1066  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     1068  81 3C 5A4D               CMP WORD PTR [SI],5A4DH
     106C  74 11                JE  LOC_82          ; Jump if equal
     106E  C6 04 E9             MOV BYTE PTR [SI],0E9H
     1071  8B 44 18             MOV AX,DS:DATA_31E[SI]  ; (8362:0018=0)


     1074  05 004A                              ADD     AX,4AH
     1077  89 44 01             MOV DS:DATA_22E[SI],AX  ; (8362:0001=0)
     107A  B9 0003              MOV CX,3
     107D  EB 4E                JMP SHORT LOC_85        ; (10CD)
     107F           LOC_82:                     ;  xref 8362:106C
     107F  E8 005E              CALL    SUB_15          ; (10E0)
     1082  F7 D0                NOT AX
     1084  F7 D2                NOT DX
     1086  40                   INC AX
     1087  75 01                JNZ LOC_83          ; Jump if not zero
     1089  42                   INC DX
     108A           LOC_83:                     ;  xref 8362:1087
     108A  03 44 18             ADD AX,DS:DATA_73E[SI]  ; (FFB0:0018=6C38H)
     108D  13 54 1A             ADC DX,DS:DATA_75E[SI]  ; (FFB0:001A=386CH)
     1090  B9 0010              MOV CX,10H
     1093  F7 F1                DIV CX          ; ax,dx rem=dx:ax/reg
     1095  C7 44 14 004D            MOV WORD PTR DS:DATA_71E[SI],4DH    ; (FFB0:0014=1BH)
     109A  89 44 16             MOV DS:DATA_72E[SI],AX  ; (FFB0:0016=633EH)
     109D  05 0083              ADD AX,83H
     10A0  89 44 0E             MOV DS:DATA_69E[SI],AX  ; (FFB0:000E=0DB7FH)
     10A3  C7 44 10 0100            MOV WORD PTR DS:DATA_70E[SI],100H   ; (FFB0:0010=7BDBH)
     10A8  81 44 18 0824            ADD WORD PTR DS:DATA_73E[SI],824H   ; (FFB0:0018=6C38H)
     10AD  83 54 1A 00              ADC WORD PTR DS:DATA_75E[SI],0  ; (FFB0:001A=386CH)
     10B1  8B 44 18             MOV AX,DS:DATA_73E[SI]  ; (FFB0:0018=6C38H)
     10B4  25 01FF              AND AX,1FFH
     10B7  89 44 02             MOV DS:DATA_67E[SI],AX  ; (FFB0:0002=7E18H)
     10BA  9C                   PUSHF               ; Push flags
     10BB  8B 44 19             MOV AX,WORD PTR DS:DATA_73E+1[SI]   ; (FFB0:0019=6C6CH)
     10BE  D0 6C 1B             SHR BYTE PTR DS:DATA_75E+1[SI],1    ; (FFB0:001B=38H) Shift w/zeros fill
     10C1  D1 D8                RCR AX,1            ; Rotate thru carry
     10C3  9D                   POPF                ; Pop flags
     10C4  74 01                JZ  LOC_84          ; Jump if zero
     10C6  40                   INC AX
     10C7           LOC_84:                     ;  xref 8362:10C4
     10C7  89 44 04             MOV DS:DATA_68E[SI],AX  ; (FFB0:0004=183CH)
     10CA  B9 0018              MOV CX,18H
     10CD           LOC_85:                     ;  xref 8362:107D
     10CD  8B D6                MOV DX,SI
     10CF  B4 40                MOV AH,40H          ; '@'
     10D1  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     10D3           LOC_86:                     ;  xref 8362:105B, 105F
     10D3  5A                   POP DX
     10D4  59                   POP CX
     10D5  9D                   POPF                ; Pop flags
     10D6  72 10                JC  LOC_RET_87      ; Jump if carry Set
     10D8  80 C9 1F             OR  CL,1FH
     10DB  B8 5701              MOV AX,5701H
     10DE  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time

                ;==== External Entry into Subroutine ======================================
                ;         Called from:   8362:107F
                SUB_15:
     10E0  8B 44 08             MOV AX,DS:DATA_26E[SI]  ; (8362:0008=0)

                ;==== External Entry into Subroutine ======================================
                ;         Called from:   8362:0D88, 0D91, 0F91
                SUB_16:
     10E3  BA 0010              MOV DX,10H
     10E6  F7 E2                MUL DX          ; dx:ax = reg * ax

     10E8           LOC_RET_87:                 ;  xref 8362:10D6
     10E8  C3                   RETN
                SUB_14      ENDP

     10E9 .28 63 29 20 31 39            DB  '(c) 1990 by Vesselin Bontchev'
     10EF  39 30 20 62 79 20
     10F5  56 65 73 73 65 6C
     10FB  69 6E 20 42 6F 6E
     1101  74 63 68 65 76
     1106  00                   DB  0
     1107 .80 FC 03             CMP AH,3
     110A  75 0F                JNE LOC_89          ; Jump if not equal
     110C  80 FA 80             CMP DL,80H
     110F  73 05                JAE LOC_88          ; Jump if above or =
     1111  EA F000:EC59     ;*      JMP FAR PTR LOC_90      ; (F000:EC59)
     1116           LOC_88:                     ;  xref 8362:110F


     1116  EA F000:EC59         ;*              JMP     FAR PTR LOC_90          ; (F000:EC59)
     111B           LOC_89:                     ;  xref 8362:110A
     111B  EA 0F4E:023B     ;*      JMP FAR PTR LOC_2       ; (0F4E:023B)
     1120  E9 0801              JMP $+804H
     1123 .0008[90]             DB  8 DUP (90H)
     112B  03 00 00             DB  3, 0, 0
     112E  45 64 64 69 65 20            DB  'Eddie lives'
     1134  6C 69 76 65 73
     1139  00 DC 14 00              DB   00H,0DCH, 14H, 00H

                SEG_A       ENDS






































































---------------------------------------------------------------
| Dump Mader   Ver 2.2               Fri Nov 23 17:02:59 1990 |
---------------------------------------------------------------
