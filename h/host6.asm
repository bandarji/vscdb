.model  small

.code

        ORG     100H

START:
        jmp     START2
        db      120H dup (0)
START2:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      'VIRUS ',0DH,0AH
        DB      'VIRUS ',0DH,0AH
        DB      'VIRUS!$'

        END     START
        