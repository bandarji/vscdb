.model  small

.code

        ORG     100H

START:
        mov     dx,OFFSET MESSAGE       ;display copyright notice
        mov     ah,9
        int     21H
        mov     ax,4C00H                ;and terminate
        int     21H

MESSAGE DB      '(C) Scumbug',0DH,0AH
        DB      'virus!$'

        END     START
