;Interrupt 13H diverter

COMSEG  SEGMENT PARA
        ASSUME  CS:COMSEG,DS:COMSEG,ES:COMSEG,SS:COMSEG

        ORG     100H

DO_START:
        push    ds
        pop     es
        mov     bx,OFFSET BOOTBUF
        mov     al,1
        mov     ah,2                            ;read 1 sector
        mov     dx,0
        mov     cx,4*256+1
        int     13H

        mov     bx,OFFSET BOOTBUF
        mov     al,1
        mov     ah,2                            ;read 1 sector
        mov     dx,0
        mov     cx,1
        int     13H

        mov     ax,4C00H                        ;and do a DOS keep
        int     21H

BOOTBUF DB      512 dup (?)

COMSEG  ENDS

        END     DO_START
        