    .286
    .radix  16
    assume  cs:gluk
gluk    segment
    org 100
start:  cli
    mov dx,offset tit1
    mov ah,9
    int 21
    push    ds
    xor ax,ax
    mov ds,ax
    cmp ds:[200],word ptr 0ec83
    mov ds:[200],ax
    mov ds:[290],word ptr 8ebh
    pop ds
    jnz net
    mov dx,offset tit2
    mov ah,9
    int 21

net:    mov dx,offset name3
    mov ah,3bh
    int 21
    mov bp,offset free+70d
new:    mov ah,4e
    jmp begin

loo:    mov ah,4f
begin:  push    ax
    mov dx,bp
    mov ah,1a
    int 21
    pop ax
    mov cx,10
    mov dx,offset name1
    int 21
    jb  exit
    cmp ds:[bp+15],byte ptr 10
    jnz loo
    cmp ds:[bp+1e],byte ptr '.'
    jz  loo
    mov ah,3bh
    lea dx,[bp+1e]
    int 21
    add bp,40
    jmp new

exit:   call    search
    mov dx,offset name0
    mov ah,3bh
    int 21
    sub bp,40
    cmp bp,offset free+60d
    jnc loo
    ret



search: xor dx,dx
    mov si,offset free+6
    push    si
    push    si
    mov ah,47
    int 21
    mov al,0
    pop di
    mov cx,80
    repnz   scasb
    mov ds:[di-1],word ptr '$\'
    pop si
    mov ah,4e
    jmp tst
repeat: mov ah,4f
tst:    mov dx,offset name2
    xor cx,cx
    int 21
    jc  endd
    lea dx,[bp+1e]
    mov ax,3d02
    int 21
    mov bx,ax
    mov dx,offset free
    mov cx,6
    mov ah,3f
    int 21
    mov ah,3e
    int 21
    mov al,0
    lea di,[bp+1e]
    mov cx,20
    repnz   scasb
    dec di
    rep stosb
    mov [di-1],word ptr 240dh
    mov dx,si
    mov ah,9
    int 21
    lea dx,[bp+1e]
    int 21
    cmp ds:[glk+2],word ptr 1551
    jnz repeat
    mov dx,offset tit0
    int 21
    jmp repeat
endd:   ret



name0   db  '..',0
name1   db  '*.*',0
name2   db  '*.exe',0
name3   db  '\',0
tit0    db  0a,9,9,9,9,' - Virused',0dh,0a,24
tit1    db  'Speed antivirus program',0dh,0a,24
tit2    db  'Warning:virus in memory!',0dh,0a
    db  'You will halted if virus run again',0dh,0a,24
glk label   word
free:
gluk    ends
end start
begin 775 ant_uri.com
M^KH&`K0)S2$>,\".V($^``*#[*,``L<&D`+K"!]U![H@`K0)S2&Z\@&T.\TA
MO:4"M$[K`Y"T3U"+U;0:S2%8N1``NN@!S2%R&CZ`?A40=>4^@'X>+G3>M#N-
M5A[-(8/%0.O-Z!$`NN4!M#O-(8/M0(']FP)SO\,STKYE`E96M$?-(;``7[F`
M`/*NQT7_7"1>M$[K`Y"T3[KL`3/)S2%R1(U6'K@"/N2``\JY/\ZK'1?\-)(O6M`G-(8U6'LTA@3YA`E$5=;BZ]`'-
M(>NQPRXN`"HN*@`J+F5X90!<``H)"0D)("T@5FER=7-E9`T*)%-P965D(&%N
M=&EV:7)U
