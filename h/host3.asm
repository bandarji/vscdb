.model  small

.code

        ORG     0

STARTUP:
        push    cs
        pop     ds
        jmp     DISP_MSG
        db      1024 dup (0A5H)         ;dummy filler
DISP_MSG:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'Worst traffic ',0DH,0AH
        DB      'out there.',0DH,0AH
        DB      'Uncool EXE infector.$'


.stack  200H

        END     STARTUP
