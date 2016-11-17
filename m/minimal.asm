DOSSEG
    .MODEL TINY
    .CODE
    ORG 100H
Start:
    mov ah, 4ch
    int 21h
END Start
