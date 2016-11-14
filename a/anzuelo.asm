jmp main
texto db 13,10
      db 'Soy un COM infectado!!'
      db 13,10,'$'
main:
      mov ah,9
      mov dx,offset texto
      int 021h
      mov ah,04ch
      int 021h
begin 775 anzuelo.com
IZ1L`#0I3;WD@=6X@0T]-(&EN9F5C=&%D;R$A#0HDM`FZ`P'-(;1,S2$`
`
end
