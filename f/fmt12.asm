;Interrupt 13H tester

COMSEG  SEGMENT PARA
        ASSUME  CS:COMSEG,DS:COMSEG,ES:COMSEG,SS:COMSEG

        ORG     100H

DO_START:
        push    ds
        pop     es
        mov     ax,1703H
        mov     dx,0
        int     13H

        mov     bx,OFFSET FMT_12M
        mov     al,0FH
        mov     ah,5                            ;format 1 track
        mov     dx,100H
        mov     cx,5001H
        int     13H

        mov     ax,4C00H                        ;and do a DOS keep
        int     21H

FMT_12M:        ;Format data for Track 80, Head 1 on a 1.2 Meg High Density diskette, interleave 2
        DB      80,1,1,2,  80,1,2,2,  80,1,3,2,  80,1,4,2,  80,1,5,2
        DB      80,1,6,2,  80,1,7,2,  80,1,8,2,  80,1,9,2,  80,1,10,2
        DB      80,1,11,2, 80,1,12,2, 80,1,13,2, 80,1,14,2, 80,1,15,2

BOOTBUF DB      512 dup (?)

COMSEG  ENDS

        END     DO_START
        