PAGE  60,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 BOTDOS                       ;;
;;;                                      ;;
;;;      Created:   16-Mar-90                            ;;
;;;      Code type: zero start                           ;;
;;;      Passes:    5          Analysis Flags on: H              ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
data_3e     equ 51Ch            ; (6C00:051C=0)
data_4e     equ 7C0Bh           ; (6C00:7C0B=0)
data_5e     equ 7C0Eh           ; (6C00:7C0E=0)
data_6e     equ 7C10h           ; (6C00:7C10=0)
data_7e     equ 7C11h           ; (6C00:7C11=0)
data_8e     equ 7C15h           ; (6C00:7C15=0)
data_9e     equ 7C16h           ; (6C00:7C16=0)
data_10e    equ 7C18h           ; (6C00:7C18=0)
data_11e    equ 7C1Ah           ; (6C00:7C1A=0)
data_12e    equ 7C1Ch           ; (6C00:7C1C=0)
data_13e    equ 7C2Ah           ; (6C00:7C2A=0)
data_14e    equ 7C37h           ; (6C00:7C37=0)
data_15e    equ 7C39h           ; (6C00:7C39=0)
data_16e    equ 7C3Bh           ; (6C00:7C3B=0)
data_17e    equ 7C3Ch           ; (6C00:7C3C=0)
data_18e    equ 7C3Dh           ; (6C00:7C3D=0)
data_19e    equ 7C3Fh           ; (6C00:7C3F=0)
data_20e    equ 7DFDh           ; (6C00:7DFD=0)
  
seg_a       segment
        assume  cs:seg_a, ds:seg_a
  
  
        org 0
  
botdos      proc    far
  
start:
        jmp short loc_2     ; (0036)
        db  90h
        db  'IBM  3.2'
        db  0, 2, 2, 1, 0, 2
        db  70h, 0, 0D0h, 2, 0FDh, 2
        db  0, 9, 0, 2, 0
        db  19 dup (0)
        db  0Fh, 0, 0, 0, 0, 1
        db  0
loc_2:
        cli             ; Disable interrupts
        xor ax,ax           ; Zero register
        mov ss,ax
        mov sp,7C00h
        push    ss
        pop es
        mov bx,78h
        lds si,dword ptr ss:[bx]    ; Load 32 bit ptr
        push    ds
        push    si
        push    ss
        push    bx
        mov di,7C2Bh
        mov cx,0Bh
        cld             ; Clear direction
  
locloop_3:
        lodsb               ; String [si] to al
        cmp byte ptr es:[di],0
        je  loc_4           ; Jump if equal
        mov al,es:[di]
loc_4:
        stosb               ; Store al to es:[di]
        mov al,ah
        loop    locloop_3       ; Loop if cx > 0
  
        push    es
        pop ds
        mov [bx+2],ax
        mov word ptr [bx],7C2Bh
        sti             ; Enable interrupts
        int 13h         ; Disk  dl=drive a: ah=func 00h
                        ;  reset disk, al=return status
        jc  loc_7           ; Jump if carry Set
        mov al,ds:data_6e       ; (6C00:7C10=0)
        cbw             ; Convrt byte to word
        mul word ptr ds:data_9e ; (6C00:7C16=0) ax = data * ax
        add ax,ds:data_12e      ; (6C00:7C1C=0)
        add ax,ds:data_5e       ; (6C00:7C0E=0)
        mov ds:data_19e,ax      ; (6C00:7C3F=0)
        mov ds:data_14e,ax      ; (6C00:7C37=0)
        mov ax,20h
        mul word ptr ds:data_7e ; (6C00:7C11=0) ax = data * ax
        mov bx,ds:data_4e       ; (6C00:7C0B=0)
        add ax,bx
        dec ax
        div bx          ; ax,dx rem=dx:ax/reg
        add ds:data_14e,ax      ; (6C00:7C37=0)
        mov bx,500h
        mov ax,ds:data_19e      ; (6C00:7C3F=0)
        call    sub_2           ; (0137)
        mov ax,201h
        call    sub_3           ; (0151)
        jc  loc_5           ; Jump if carry Set
        mov di,bx
        mov cx,0Bh
        mov si,7DCFh
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jnz loc_5           ; Jump if not zero
        lea di,[bx+20h]     ; Load effective addr
        mov si,7DDAh
        mov cx,0Bh
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        jz  loc_8           ; Jump if zero
loc_5:
        mov si,7D6Eh
loc_6:
        call    sub_1           ; (0129)
        xor ah,ah           ; Zero register
        int 16h         ; Keyboard i/o  ah=function 00h
                        ;  get keybd char in al, ah=scan
        pop si
        pop ds
        pop word ptr [si]
        pop word ptr [si+2]
        int 19h         ; Bootstrap loader
loc_7:
        mov si,7DB9h
        jmp short loc_6     ; (00C5)
loc_8:
        mov ax,ds:data_3e       ; (6C00:051C=0)
        xor dx,dx           ; Zero register
        div word ptr ds:data_4e ; (6C00:7C0B=0) ax,dxrem=dx:ax/data
        inc al
        mov ds:data_17e,al      ; (6C00:7C3C=0)
        mov ax,ds:data_14e      ; (6C00:7C37=0)
        mov ds:data_18e,ax      ; (6C00:7C3D=0)
        mov bx,700h
loc_9:
        mov ax,ds:data_14e      ; (6C00:7C37=0)
        call    sub_2           ; (0137)
        mov ax,ds:data_10e      ; (6C00:7C18=0)
        sub al,ds:data_16e      ; (6C00:7C3B=0)
        inc ax
        push    ax
        call    sub_3           ; (0151)
        pop ax
        jc  loc_7           ; Jump if carry Set
        sub ds:data_17e,al      ; (6C00:7C3C=0)
        jbe loc_10          ; Jump if below or =
        add ds:data_14e,ax      ; (6C00:7C37=0)
        mul word ptr ds:data_4e ; (6C00:7C0B=0) ax = data * ax
        add bx,ax
        jmp short loc_9     ; (00F1)
loc_10:
        mov ch,ds:data_8e       ; (6C00:7C15=0)
        mov dl,ds:data_20e      ; (6C00:7DFD=0)
        mov bx,ds:data_18e      ; (6C00:7C3D=0)
;*      jmp far ptr loc_1       ;*(0070:0000)
        db  0EAh, 0, 0, 70h, 0
  
botdos      endp
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_1       proc    near
loc_11:
        lodsb               ; String [si] to al
        or  al,al           ; Zero ?
        jz  loc_ret_12      ; Jump if zero
        mov ah,0Eh
        mov bx,7
        int 10h         ; Video display   ah=functn 0Eh
                        ;  write char al, teletype mode
        jmp short loc_11        ; (0129)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_2:
        xor dx,dx           ; Zero register
        div word ptr ds:data_10e    ; (6C00:7C18=0) ax,dxrem=dx:ax/data
        inc dl
        mov ds:data_16e,dl      ; (6C00:7C3B=0)
        xor dx,dx           ; Zero register
        div word ptr ds:data_11e    ; (6C00:7C1A=0) ax,dxrem=dx:ax/data
        mov ds:data_13e,dl      ; (6C00:7C2A=0)
        mov ds:data_15e,ax      ; (6C00:7C39=0)
  
loc_ret_12:
        retn
sub_1       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_3       proc    near
        mov ah,2
        mov dx,ds:data_15e      ; (6C00:7C39=0)
        mov cl,6
        shl dh,cl           ; Shift w/zeros fill
        or  dh,ds:data_16e      ; (6C00:7C3B=0)
        mov cx,dx
        xchg    ch,cl
        mov dl,ds:data_20e      ; (6C00:7DFD=0)
        mov dh,ds:data_13e      ; (6C00:7C2A=0)
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
