; redirection de l'IT 13 pour acc�s disques sonores - par Lionel ANCELET.

CODE    SEGMENT

    ASSUME  CS:CODE,DS:CODE

    ORG 100H

START:  JMP INIT            ; sauter � la routine d'installation

OLDVEC  DD  ?           ; adresse initiale du vecteur d'IT 13

ISR:    STI

    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX

    MOV BX,7            ; nombre de clics dans le speaker

    IN  AL,61H
    PUSH    AX          ; sauvegarde port I/O

MORE:   AND AL,0FCH
    OUT 61H,AL          ; pousser la membrane
    CALL    DELAY
    OR  AL,02H
    OUT 61H,AL          ; tirer la membrane
    CALL    DELAY

    DEC BX
    JNZ MORE

    POP AX
    OUT 61H,AL          ; restauration port I/O

    POP DX
    POP CX
    POP BX
    POP AX

CHAIN:  JMP CS:[OLDVEC]     ; sauter � la vraie INT 13H

; la fr�quence du bruit d�pend du num�ro de piste... (g�nial avec FORMAT)

DELAY   PROC    NEAR

    PUSH    CX

    MOV CL,CH           ; num�ro de piste dans CH
    XOR CH,CH
    OR  CL,00000001B        ; forcer CL � plus de 0...
    AND CL,00111111B        ; ...et � moins de 64.

D1: LOOP    D1          ; tuer le temps

    POP CX

    RET

DELAY   ENDP

; *** Fin de la partie r�sidente ***

INIT:   MOV AX,3513H
    INT 21H         ; vecteur de l'IT 13 ===> ES:BX
    MOV WORD PTR OLDVEC[0],BX
    MOV WORD PTR OLDVEC[2],ES

    MOV DX,OFFSET ISR
    MOV AX,2513H
    INT 21H         ; vecteur de l'IT 13 <=== DS:DX

    MOV DX,OFFSET INIT      ; CS:DX ---> dernier octet r�sident
    INT 27H         ; terminer en restant r�sident

CODE    ENDS

    END START
