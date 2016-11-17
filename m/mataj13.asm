;
;  Para obtener un ejecutable:
;                                   Tasm  MataJ13
;                                   Tlink MataJ13
;
;


                 .radix 16

 programa        segment para public "code"
                 assume cs:programa,ds:programa,es:programa,ss:programa
                 org 100h
 buscador        proc near

                 jmp ini

 cr              equ 13d
 lf              equ 10d
 fi              equ "$"

 Ficheros        db "*.EXE",0                   ; Busca la cadena en los
 nom_file        db 14d dup (0)                 ; Ficheros EXE

 Cadena          db 02eh,0a0h,012h,0,034h,090h  ; Cadena a buscar
 longcadena      equ $-Cadena                   ; Calcula automaticamente
                                                ; la longitud de la cadena


 Autor           db cr,lf
                 db "MataJ13.com, version 1.00, (c)1990 J & G",cr,lf
                 db "-----------------------------------------",cr,lf
                 db cr,lf,fi

 cuenta          db "N�mero de ficheros con la cadena: ",fi
 contador        dw 0
 dta_es          dw 0
 dta_bx          dw 0
 handle          dw 0
 activo          db 0
 encontrada      db 0
 fecha           dw 0
 hora            dw 0
 encon           db " virus encontrado",cr,lf,fi
 lineanueva      db 50d dup (32d)
                 db cr,lf,fi
 buffer          db 128d dup (0)

 ini:


;-------------------------------------------------------------------------
;                        Inicio real de programa
;-------------------------------------------------------------------------


                 mov dx,offset Autor
                 mov ah,9
                 int 21h

                 mov dx,offset buffer
                 mov ah,1ah
                 int 21h                        ; Fija nueva DTA en cs:buffer
                 mov ah,4eh
                 mov dx,offset ficheros
                 int 21h
                 jc salida
                 call imprime_nom
                 call lee
                 cmp encontrada,1
                 jnz cerrado2
                 call informa
 cerrado2:       call noinforma
 cerrado:        mov ah,04fh
                 mov dx,offset ficheros
                 int 21h
                 jc salida
                 call imprime_nom
                 call lee
                 cmp encontrada,0
                 jnz ahi
                 call noinforma
                 jmp cerrado
 ahi:            call informa
                 jmp cerrado


 salida:         cmp contador,0
                 jz saltame
                 mov dx,offset lineanueva
                 mov ah,9
                 int 21
 saltame:        mov dx,offset cuenta
                 mov ah,9
                 int 21
                 mov ax,contador
                 call convierte
                 mov ah,2
                 mov dl,cr
                 int 21h
                 mov ah,2
                 mov dl,lf
                 int 21h
                 mov ah,4c
                 int 21
 buscador        endp



 imprime_nom     proc near
                 mov activo,0
                 mov si,offset buffer+1eh
                 mov di,offset nom_file
                 mov cx,12d
 bl_1:           cld
                 lodsb
                 stosb
                 or al,al
                 jnz cont_1
                 mov activo,1
 cont_1:         mov dl,al
                 cmp activo,1
                 jnz cont_2
                 mov dl," "
 cont_2:         mov ah,2
                 int 21h
                 loop bl_1
                 ret
 imprime_nom     endp

 lee             proc near
                 mov dx,offset nom_file
                 mov ax,03d02h
                 int 21h
                 mov handle,ax
 otra_lec:       mov cx,050000d
                 mov dx,offset last
                 mov ah,3fh
                 mov bx,handle
                 int 21
                 push ax
                 call busca_cadena
                 pop ax
                 cmp encontrada,1
                 jnz cuidado2
                 call desinfecta
                 jmp short cuidado
 cuidado2:       cmp ax,050000d
                 jz otra_lec
 cuidado:        mov bx,handle
                 mov ah,03eh
                 int 21
                 ret
 lee             endp

 desinfecta      proc near
                 mov al,[di+12]
                 xor al,90
                 mov si,di
                 add si,012h
                 mov cx,0491h
 vuelve:         xor [si],al
                 inc si
                 loop vuelve
                 rep movsb
                 mov bx,cs:handle
                 mov ax,5700h
                 int 21h
                 mov cs:hora,cx
                 mov cs:fecha,dx
                 mov si,di
                 add si,045bh
                 push si
                 xor cx,cx
                 xor dx,dx
                 mov ax,04200h
                 int 21h
                 pop dx
                 mov cx,01ch
                 mov bx,handle
                 mov ah,40h
                 int 21h
                 mov bx,handle
                 mov cx,0ffffh
                 mov dx,cx
                 sub dx,01200d
                 mov ax,04202h
                 int 21h
                 mov cx,0h
                 mov bx,handle
                 mov ah,40h
                 int 21h
                 mov dx,fecha
                 mov bx,handle
                 mov cx,hora
                 mov ax,05701h
                 int 21h
                 ret
 desinfecta      endp


 busca_cadena    proc near
                 mov cx,ax
                 mov encontrada,0
                 mov di,offset last
 otra_vez:       push di
                 push cx
                 mov cx,longcadena
                 mov si,offset cadena
                 repz cmpsb
                 cmp cx,0
                 jz esta

                 pop cx
                 pop di
                 inc di
                 loop otra_vez
                 mov encontrada,0
                 ret

 esta:           pop cx
                 pop di
                 mov encontrada,1
                 ret
 busca_cadena    endp


 informa         proc near
                 inc contador
                 mov dx,offset encon
                 mov ah,09
                 int 21
                 ret
 informa         endp


 noinforma       proc near
                 mov ah,2
                 mov dl,cr
                 int 21h
                 ret
 noinforma       endp


 convierte       proc near
                 cld
                 mov bx,10000d
 divide:         xor dx,dx
                 div bx
                 add al,"0"
                 push dx
                 push ax
                 mov ah,2
                 mov dl,al
                 int 21h
                 pop ax
                 pop dx
                 mov ax,dx
                 cmp bx,1
                 jz fin0
                 push ax
                 mov ax,bx
                 xor dx,dx
                 mov bx,010d
                 div bx
                 mov bx,ax
                 pop ax
                 jmp short divide
 fin0:           ret
 convierte       endp


 last            label byte
 programa        ends
                 end buscador
