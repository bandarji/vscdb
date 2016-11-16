.model  small

.code

        ORG     100H

START:
        jmp     s2
        nop
        nop
        nop
        nop
        nop
        jmp     S2

        db      6E2H dup (0)
S2:
        mov     dx,OFFSET MESSAGE
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'cable guy$'
        db      'THE END'
THE_END:


        END     START
        