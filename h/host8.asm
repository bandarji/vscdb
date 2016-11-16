;This is a host COM file for attaching viruses to.

.model  small

.code

        ORG     100H

START:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        db      2000H dup (90H)
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'Hello',0DH,0AH
        DB      'I am the captain',0DH,0AH
        DB      'Go!$'

        END     START

