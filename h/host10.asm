.model  small

.code

        ORG     0

STARTUP:
        push    cs
        db      2000 dup (90H)
        pop     ds
        db      2000 dup (90H)
        mov     dx,OFFSET MESSAGE
        db      2000 dup (90H)
        mov     ah,9
        db      2000 dup (90H)
        int     21H
        db      2000 dup (90H)
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'Fuckt$'

.stack  200H

        END     STARTUP
        