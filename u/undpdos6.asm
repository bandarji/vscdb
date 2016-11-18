; - Desactivador del dPROTECT v3. de GISVI.

.model tiny
.code
           org 100h
start:
           jmp    unprot

initmsg    db     13,10,'Desactivador del dPROTECT v3.0 .',13,10,'$'
dpinact    db     13,10,'dPROTECT desactivado. GISVI TKGUE',13,10,'$'
illegaldos db     13,10,'Desactivador no preparado para ejecutar bajo versi�n de DOS actual.',13,10,'$'
wrongdp    db     13,10,'Versi�n no esperada de dPROTECT.',13,10,'$'
errorlocdp db     13,10,'Error buscando dPROTECT v3 en memoria.',13,10,'$'
str2srch   db     '^dPROT^ '
strid      db     80h,0fch,1ah,74h,02h,75h,4bh


unprot:
           mov    ah,9
           mov    dx,offset initmsg
           int    21h
           mov    ah,30h
           int    21h
           cmp    al,6
           jnz    illegal_dos_version
           mov    ah,52h
           int    21h
           mov    bx,es:[bx-2]
           mov    es,bx
           xor    bx,bx
           cmp    word ptr es:[bx+1],8
           jnz    no_driver_found
           mov    bx,es
           inc    bx
           mov    es,bx
loop1:
           xor    bx,bx
           cmp    byte ptr es:[bx],'D'
           jnz    no_driver_found
           mov    ax,es:[bx+1]
           mov    dx,es:[bx+3]
           mov    es,ax
           mov    cx,8
           mov    di,0ah
           mov    si,offset str2srch
           cld
           repz   cmpsb
           jz     found_data
           mov    bx,es
           add    dx,bx
           mov    es,dx
           jmp    loop1
found_data:
           mov    si,offset strid
           mov    di,85h
           mov    cx,7
           repz   cmpsb
           jnz    wrong_dprotect
           push   ds
           lds    dx,es:[155h]
           mov    ax,2509h
           int    21h
           lds    dx,es:[159h]
           mov    ax,251bh
           int    21h
           lds    dx,es:[15dh]
           mov    ax,2523h
           int    21h
           lds    dx,es:[151h]
           mov    ax,2513h
           int    21h
           pop    ds
           mov    ah,9h
           mov    dx,offset dpinact
           int    21h
           mov    ax,4c00h
           int    21h
wrong_dprotect:
           mov    ah,9
           mov    dx,offset wrongdp
           int    21h
           mov    ax,4cffh
           int    21h
illegal_dos_version:
           mov    ah,9
           mov    dx,offset illegaldos
           int    21h
           mov    ax,4cfeh
           int    21h

no_driver_found:
           mov    ah,9
           mov    dx,offset errorlocdp
           int    21h
           mov    ax,4cfdh
           int    21h

           end    start
