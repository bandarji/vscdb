;This is  a host COM file for attaching viruses to.

.model  small

.code

        ORG     100H

START:
        nop
        nop
        nop
        nop
        nop
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      '1993 ',0DH,0AH
        DB      'VIRUS',0DH,0AH
        DB      'You have just released a virus!$'
        db      6E2H dup (0)
        db      'THE END'
THE_END:


        END     START
