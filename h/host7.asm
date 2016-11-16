.model  small

.code

        ORG     100H

START:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        db      1000H dup (90H)
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'I am just a happy host. ',0DH,0AH
        DB      'Attach to me. ',0DH,0AH
        DB      'VIRUS!$'

        END     START
        