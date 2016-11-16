.model  small

.code

        ORG     0

STARTUP:
        push    cs
        pop     ds
        jmp     DISP_MSG
        db      1024 dup (0A5H)         ;dummy filler
        db      1024 dup (05AH)         ;more dummy filler
DISP_MSG:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'Rooft ',0DH,0AH
        DB      'Ouch$'


.stack  200H
