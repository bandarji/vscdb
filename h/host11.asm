.model  small

.code

        ORG     100H

START:
        mov     dx,OFFSET MESSAGE       ;display f-bomb
        mov     ah,9
        db      30000 dup (90H)
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'fuck$'

        END     START
        