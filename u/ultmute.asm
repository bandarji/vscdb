*** build.bat ***


tasm encrexe;
tasm encrcom;
tasm passexe;
tasm passcom;
tasm ultimute;
tlink /t encrexe ultimute;
tlink /t encrcom ultimute;
tlink /t passcom ultimute;
tlink /t passexe ultimute;

*** encrcom.asm ***


;                   Black Wolf's File Protection Utilities 2.1s
;
;EncrCOM - This program encrypts specified file and attaches the decryption
;          code from EN_COM onto the file so that it will decrypt on
;          each execution.  It utilizes ULTIMUTE .93� to protect then EN_COM
;          code from easy manipulation.
;
;LISCENSE:
;    Released As Freeware - These files may be distributed freely.
;
;Any modifications made to this program should be listed below the solid line,
;along with the name of the programmer and the date the file was changed.
;Also - they should be commented where changed.
;
;NOTE THAT MODIFICATION PRIVILEDGES APPLY ONLY TO THIS VERSION (2.1s)!  
;I'd appreciate notification of any modifications if at all possible, 
;reach me through the address listed in the documentation file (bwfpu21s.doc).
;
;DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
;resulting from the use/misuse of this program/file.  The user agrees to hold
;the author harmless for any consequences that may occur directly or 
;indirectly from the use of this program by utilizing this program/file
;in any manner.
;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
       
       org 100

        extrn   _ULTMUTE:near, _END_ULTMUTE:byte, Get_Rand:near
        extrn   Init_Rand:near

start:
        call    GetFilename
        call    Init_Rand
        call    Get_Rand
        mov     [Key1],ax
        call    Get_Rand
        mov     [Key2],ax
        call    Get_Rand
        mov     [Key3],ax
        call    Get_Rand
        mov     [Key4],ax
        call    Do_File
        mov     ax,4c00
        int     21
;---------------------------------------------------------------------------
GetFilename:
        mov     ah,09
        mov     dx,offset Message
        int     21

        mov     dx,offset Filename_Data
        mov     al,60
        call    gets
        ret
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
Message:
        db      'EncrCOM 2.0 (c) 1993 Black Wolf Enterprises.',0a,0dh
        db      'Enter Filename To Protect -> $'
;---------------------------------------------------------------------------
gets:
        mov     ah,0a
        push    bx
        mov     bx,dx
        mov     byte ptr ds:[bx],al
        mov     byte ptr ds:[bx+1],0
        pop     bx
        int     21
        push    bx
        mov     bx,dx
        mov     al,byte ptr ds:[bx+1]
        xor     ah,ah
        add     bx,ax
        mov     byte ptr ds:[bx+2],0
        pop     bx
        ret
;---------------------------------------------------------------------------
Do_File:        
        mov     ax,3d02
        mov     dx,offset Filename
        int     21
        jnc     No_Terminate
        jmp     Terminate
No_Terminate:
        xchg    bx,ax
        call    GetTime
        call    BackupFile

        mov     ah,3f
        mov     cx,4
        mov     dx,offset Storage_Bytes
        int     21

        mov     ax,[Key1] 
        xor     word ptr [Storage_Bytes],ax
        mov     ax,[Key2]
        xor     word ptr [Storage_Bytes+2],ax


        mov     ax,4200
        xor     cx,cx
        xor     dx,dx
        int     21

Encrypt_Entire_File:
        mov     ah,3f        
        mov     cx,400
        mov     dx,offset Encrypt_Buffer                ;Read in buffer full
        int     21

        or      ax,ax
        jz      Add_Protection_Code                     ;None left? leave...
        
        push    ax
        call    EncryptBytes                            ;Encrypt buffer
        pop     ax
        push    ax

        xor     dx,dx
        sub     dx,ax
        mov     cx,0ffff                                ;Go back to where we
        mov     ax,4201                                 ;read from
        int     21

        mov     ah,40
        pop     cx
        mov     dx,offset Encrypt_Buffer                ;Write it back
        int     21

        cmp     ax,400                                  ;Buffer full? loop...
        je      Encrypt_Entire_File

Add_Protection_Code:
        mov     ax,4202
        xor     cx,cx
        xor     dx,dx
        int     21
        sub     ax,3
        mov     word ptr [JumpBytes+1],ax
        
        push    bx        
        mov     si,offset begin_password        ;On Entry -> CS=DS=ES
        mov     di,offset _END_ULTMUTE          ;SI=Source, DI=Destination
        mov     bx,ax                           ;BX=Next Entry Point
        add     bx,103
        mov     cx,end_password-begin_password+1 ;CX=Size to Encrypt
        mov     ax,1                             ;AX=Calling Style
        call    _ULTMUTE                
                                                ;On Return -> CX=New Size
        pop     bx
        
        mov     dx,offset _END_ULTMUTE
        mov     ah,40
        int     21
        
        mov     ax,4200
        xor     dx,dx
        xor     cx,cx
        int     21
        
        mov     ah,40
        mov     cx,4
        mov     dx,offset JumpBytes
        int     21
        

        mov     ax,5701
        mov     cx,word ptr cs:[Time]
        mov     dx,word ptr cs:[Date]
        int     21

        mov     ah,3e
        int     21
        ret

GetTime:
        mov     ax,5700
        int     21
        mov     word ptr cs:[Time],cx
        mov     word ptr cs:[Date],dx
        ret

Terminate:
        mov     ah,09
        mov     dx,offset BadFile
        int     21
        ret
BadFile db      'Error Opening File.',07,0dh,0a,24
JumpBytes       db      0e9,0,0,'�'

EncryptBytes:
        push    ax bx cx dx si di
        
        mov     si,offset Encrypt_Buffer
        mov     di,si
        mov     cx,200

Decrypt_Loop:        
        lodsw
        
        ror     ax,1
        add     ax,[Key4]
        xor     ax,[Key3]
        rol     ax,1
        sub     ax,[Key2]
        xor     ax,[Key1]
        
        stosw
        loop    Decrypt_Loop
        
        pop     di si dx cx bx ax
        ret
Time    dw      0
Date    dw      0

BackupFile:
        mov     si,offset Filename
        mov     cx,80

  Find_Eofn:
        lodsb
        cmp     al,'.'
        je      FoundDot
        or      al,al
        jz      FoundZero
        loop    Find_Eofn
        jmp     Terminate
FoundZero:
        mov     byte ptr [si-1],'.'
        inc     si
FoundDot:
        mov     word ptr [si],'LO'
        mov     byte ptr [si+2],'D'
        mov     byte ptr [si+3],0

        
        mov     dx,offset Filename
        mov     word ptr [SourceF],bx
        mov     ah,3c
        xor     cx,cx
        int     21
        jnc     GCreate
         jmp    Terminate
GCreate:
        mov     word ptr cs:[Destf],ax
BackLoop:
        mov     ah,3f
        mov     bx,word ptr cs:[Sourcef]
        mov     cx,400
        mov     dx,offset Encrypt_Buffer
        int     21

        mov     cx,ax
        mov     ah,40
        mov     bx,word ptr cs:[Destf]
        mov     dx,offset Encrypt_Buffer
        int     21

        cmp     ax,400
        je      BackLoop
DoneBack:
        mov     ah,3e
        mov     bx,word ptr cs:[Destf]
        int     21

        mov     ax,4200
        xor     cx,cx
        xor     dx,dx
        mov     bx,word ptr cs:[Sourcef]
        int     21
        ret

SourceF dw      0
DestF   dw      0



begin_password:
;------------------------------------------------------------------------
db 0e8h, 090h, 00h, 08dh, 0b6h, 02bh, 01h, 08dh, 0beh, 093h
db 01h, 0b9h, 034h, 00h, 0fch, 0ebh, 01h, 0eah, 0ach, 04fh
db 08ah, 025h, 088h, 064h, 0ffh, 088h, 05h, 0e2h, 0f5h, 02eh
db 083h, 0beh, 0c0h, 01h, 04h, 072h, 052h, 081h, 0aeh, 02ch
db 01h, 00h, 01h, 0ffh, 0ffh, 00h, 00h, 0eah, 0c3h, 01h
db 08eh, 086h, 0c6h, 02eh, 058h, 05bh, 059h, 058h, 0e3h, 08bh
db 0d0h, 08eh, 093h, 050h, 0dch, 08bh, 0d0h, 08ch, 051h, 053h
db 050h, 0dbh, 0ebh, 0f8h, 08bh, 0f0h, 08bh, 00h, 02fh, 0e8h
db 0c0h, 033h, 01h, 02h, 06h, 031h, 01h, 0c8h, 086h, 08bh
db 01h, 00h, 06h, 031h, 01h, 0c6h, 086h, 08bh, 0a5h, 0a5h
db 01h, 0c2h, 0b6h, 08dh, 057h, 01h, 00h, 0bfh, 0c3h, 01h
db 052h, 086h, 0c6h, 0e8h, 0e2h, 0abh, 0c0h, 0d1h, 01h, 0cch
db 086h, 02bh, 01h, 0cah, 086h, 033h, 0c8h, 0d1h, 01h, 0c8h
db 086h, 03h, 01h, 0c6h, 086h, 033h, 0adh, 041h, 0e9h, 0d1h
db 0cdh, 08bh, 0feh, 08bh, 01h, 00h, 0beh, 05dh, 0ebh, 01h
db 0eah, 055h, 081h, 0edh, 03h, 01h, 0e8h, 01h, 00h, 0c3h
db 050h, 06h, 01eh, 033h, 0c0h, 08eh, 0d8h, 08eh, 0c0h, 033h
db 0f6h, 033h, 0ffh, 0b9h, 08h, 00h, 0adh, 035h, 0dh, 0d0h
db 0abh, 02eh, 0ffh, 086h, 0c0h, 01h, 0e2h, 0f4h, 01fh, 07h
db 058h, 0c3h, 00h, 00h
;------------------------------------------------------------------------
Storage_Bytes   db      90,90,0cdh,20

Key1    dw      0
Key2    dw      0
Key3    dw      0
Key4    dw      0
;------------------------------------------------------------------------
end_password:
                dw      0
                dw      0
Filename_data   dw      0
Filename        db      80 dup(0)
Encrypt_Buffer  db      400 dup(0)
end start

*** encrexe.asm ***


;                   Black Wolf's File Protection Utilities 2.1s
;
;EncrEXE - This program encrypts specified file and attaches the decryption
;          code from EN_EXE onto the file so that it will decrypt on
;          each execution.  It utilizes ULTIMUTE .93� to protect then EN_EXE
;          code from easy manipulation.
;
;LISCENSE:
;    Released As Freeware - These files may be distributed freely.
;
;Any modifications made to this program should be listed below the solid line,
;along with the name of the programmer and the date the file was changed.
;Also - they should be commented where changed.
;
;NOTE THAT MODIFICATION PRIVILEDGES APPLY ONLY TO THIS VERSION (2.1s)!  
;I'd appreciate notification of any modifications if at all possible, 
;reach me through the address listed in the documentation file (bwfpu21s.doc).
;
;DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
;resulting from the use/misuse of this program/file.  The user agrees to hold
;the author harmless for any consequences that may occur directly or 
;indirectly from the use of this program by utilizing this program/file
;in any manner.
;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
       
       org 100

        extrn   _ULTMUTE:near, _END_ULTMUTE:byte, Init_Rand:near
        extrn   Get_Rand:near

start:
        call    GetFilename
        call    Init_Rand
        call    Get_Rand
        mov     [Key1],ax
        call    Get_Rand
        mov     [Key2],ax
        call    Get_Rand
        mov     [Key3],ax
        call    Get_Rand
        mov     [Key4],ax
        
        call    Do_File
        mov     ax,4c00
        int     21
;---------------------------------------------------------------------------
GetFilename:
        mov     ah,09
        mov     dx,offset Message
        int     21

        mov     dx,offset Filename_Data
        mov     al,60
        call    gets
        ret
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
Message:
        db      'EncrEXE 2.0 (c) 1993 Black Wolf Enterprises.',0a,0dh
        db      'Enter Filename To Protect -> $'
;---------------------------------------------------------------------------
gets:
        mov     ah,0a
        push    bx
        mov     bx,dx
        mov     byte ptr ds:[bx],al
        mov     byte ptr ds:[bx+1],0
        pop     bx
        int     21
        push    bx
        mov     bx,dx
        mov     al,byte ptr ds:[bx+1]   
        xor     ah,ah
        add     bx,ax
        mov     byte ptr ds:[bx+2],0
        pop     bx
        ret
;---------------------------------------------------------------------------
Save_Header:
        mov     ax,word ptr [exeheader+0e]    ;Save old SS
        mov     word ptr [Old_SS],ax
        mov     ax,word ptr [exeheader+10]    ;Save old SP
        mov     word ptr [Old_SP],ax
        mov     ax,word ptr [exeheader+14]    ;Save old IP
        mov     word ptr [Old_IP],ax
        mov     ax,word ptr [exeheader+16]    ;Save old CS
        mov     word ptr [Old_CS],ax
        ret

Do_File:        
        mov     ax,3d02
        mov     dx,offset Filename
        int     21
        jnc      Terminate_NOT
        jmp     Terminate
Terminate_NOt:
        xchg    bx,ax
        
        call    GetTime        
        call    BackupFile

        mov     ah,3f
        mov     cx,1a
        mov     dx,offset EXEheader
        int     21

        cmp     word ptr [EXEheader],'ZM'       ;not EXE file.
        je      IsEXE
        jmp     close_file
IsEXE:
        call    Save_Header
        
        mov     ax,4200
        xor     cx,cx
        xor     dx,dx                   ;Go back to beginning
        int     21

        mov     ax,word ptr [EXEheader+08]
        mov     cl,4                            ;convert header to bytes
        shl     ax,cl

        mov     word ptr [HeaderSize],ax

        mov     cx,ax        
        mov     dx,offset Header                ;Load header
        mov     ah,3f
        int     21
        
        call    Encrypt_Entire_File
        
        mov     ax,4202
        xor     cx,cx                   ;Go end
        xor     dx,dx
        int     21

        mov     cl,4
        shr     ax,cl
        inc     ax
        shl     ax,cl
        mov     cx,dx           ;Pad file
        mov     dx,ax
        mov     ax,4200
        int     21
        
        push    ax dx

        call    calculate_CSIP          ;calculate starting
                                        ;point.

        mov     ah,40
        mov     dx,offset Set_Segs
        mov     cx,end_set_segs-set_segs
        int     21

        push    bx        
        mov     si,offset begin_password        ;On Entry -> CS=DS=ES
        mov     di,offset _END_ULTMUTE          ;SI=Source, DI=Destination
        
        mov     bx,word ptr [exeheader+14]       ;BX=Next Entry Point
        add     bx,end_set_segs-set_segs

        mov     cx,end_password-begin_password+1 ;CX=Size to Encrypt
        add     cx,word ptr [headersize]         ;add in EXE header

        mov     ax,1                             ;AX=Calling Style
        call    _ULTMUTE                
                                                ;On Return -> CX=New Size

        pop     bx
        pop     dx ax                   ;DX:AX = unmodified
                                        ;file size.
        
        push    cx bx
        add     cx,end_set_segs-set_segs
        call    calculate_size
        pop     bx cx

        mov     dx,offset _END_ULTMUTE
        mov     ah,40
        int     21
        
        mov     ax,4200
        xor     dx,dx
        xor     cx,cx
        int     21
        
        mov     ah,40
        mov     cx,1a
        mov     dx,offset EXEheader
        int     21

        mov     cx,word ptr [headersize]        
        sub     cx,1a
        jz      Close_File

Zero_Header:
        push    cx
        mov     ah,40
        mov     cx,1
        mov     dx,offset zero
        int     21
        pop     cx
        loop    Zero_Header
        
Close_File:
        mov     ax,5701
        mov     cx,word ptr cs:[Time]
        mov     dx,word ptr cs:[Date]   ;restore date/time
        int     21 

        mov     ah,3e
        int     21
        ret

GetTime:
        mov     ax,5700
        int     21
        mov     word ptr cs:[Time],cx
        mov     word ptr cs:[Date],dx
        ret

Time    dw      0
Date    dw      0

Terminate:
        mov     ah,09
        mov     dx,offset BadFile
        int     21
        ret
BadFile db      'Error Opening File.',07,0dh,0a,24
zero    db      0,0
calculate_CSIP:
        push    ax
        mov     cl,4 
        mov     ax,word ptr [exeheader+8]       ;Get header length
                                                ;and convert it to
        shl     ax,cl                           ;bytes.
        mov     cx,ax
        pop     ax

        sub     ax,cx                           ;Subtract header
        sbb     dx,0                            ;size from file
                                                ;size for memory
                                                ;adjustments

        mov     cl,0c                           ;Convert DX into
        shl     dx,cl                           ;segment Address
        mov     cl,4
        push    ax                      ;Change offset (AX) into
        shr     ax,cl                   ;segment, except for last
        add     dx,ax                   ;digit.  Add to DX and
        shl     ax,cl                   ;save DX as new CS, put
        pop     cx                      ;left over into CX and
        sub     cx,ax                   ;store as the new IP.
        mov     word ptr [exeheader+16],dx    ;Set new CS:IP
        mov     word ptr [exeheader+10],0fffe ;Set new SP
        mov     word ptr [exeheader+0e],dx    ;Set new SS = CS
        mov     word ptr [exeheader+14],cx
        mov     word ptr [exeheader+6],0        ;Set 0 relocation items.
        ret

calculate_size:
        add     ax,cx                   ;Add virus size to DX:AX
        adc     dx,0
        
        push    ax                      ;Save offset for later
        mov     cl,7
        shl     dx,cl                   ;convert DX to pages
        mov     cl,9
        shr     ax,cl
        add     ax,dx
        inc     ax
        mov     word ptr [exeheader+04],ax  ;save # of pages

        pop     ax                              ;Get offset
        mov     dx,ax
        shr     ax,cl                           ;Calc remainder
        shl     ax,cl                           ;in last page
        sub     dx,ax
        mov     word ptr [exeheader+02],dx ;save remainder
        ret

Set_Segs:
        push    es ds
        push    cs cs
        pop     es ds
 End_Set_Segs:

Encrypt_Entire_File:
        mov     ah,3f        
        mov     cx,400
        mov     dx,offset Encrypt_Buffer                ;Read in buffer full
        int     21

        or      ax,ax
        jz      Add_Protection_Code                     ;None left? leave...
        
        push    ax
        call    EncryptBytes                            ;Encrypt buffer
        pop     ax
        push    ax

        xor     dx,dx
        sub     dx,ax
        mov     cx,0ffff                                ;Go back to where we
        mov     ax,4201                                 ;read from
        int     21

        mov     ah,40
        pop     cx
        mov     dx,offset Encrypt_Buffer                ;Write it back
        int     21

        cmp     ax,400                                  ;Buffer full? loop...
        je      Encrypt_Entire_File
Add_Protection_Code:
        ret

EncryptBytes:                           ;This algorithm needs help....
        push    ax bx cx dx si di
        
        mov     si,offset Encrypt_Buffer
        mov     di,si
        mov     cx,200

Decrypt_Loop:        
        lodsw
        ror     ax,1
        add     ax,[Key4]
        xor     ax,[Key3]
        rol     ax,1
        sub     ax,[Key2]
        xor     ax,[Key1]

        
        stosw
        loop    Decrypt_Loop
        
        pop     di si dx cx bx ax
        ret
                dw      0
                dw      0
Filename_data   dw      0
Filename        db      80 dup(0)
Exeheader       db      1a dup(0)
Encrypt_Buffer  dw      400 dup(0)
HeaderSize      dw      0


BackupFile:
        mov     si,offset Filename
        mov     cx,80

  Find_Eofn:
        lodsb
        cmp     al,'.'
        je      FoundDot
        or      al,al
        jz      FoundZero
        loop    Find_Eofn
        jmp     Terminate
FoundZero:
        mov     byte ptr [si-1],'.'
        inc     si
FoundDot:
        mov     word ptr [si],'LO'
        mov     byte ptr [si+2],'D'
        mov     byte ptr [si+3],0

        
        mov     dx,offset Filename
        mov     word ptr [SourceF],bx
        mov     ah,3c
        xor     cx,cx
        int     21
        jnc     GCreate
         jmp    Terminate
GCreate:
        mov     word ptr cs:[Destf],ax
BackLoop:
        mov     ah,3f
        mov     bx,word ptr cs:[Sourcef]
        mov     cx,400
        mov     dx,offset Encrypt_Buffer
        int     21

        mov     cx,ax
        mov     ah,40
        mov     bx,word ptr cs:[Destf]
        mov     dx,offset Encrypt_Buffer
        int     21

        cmp     ax,400
        je      BackLoop
DoneBack:
        mov     ah,3e
        mov     bx,word ptr cs:[Destf]
        int     21

        mov     ax,4200
        xor     cx,cx
        xor     dx,dx
        mov     bx,word ptr cs:[Sourcef]
        int     21
        ret

SourceF dw      0
DestF   dw      0


begin_password:         ;code from en_exe
;------------------------------------------------------------------------
db 0e8h, 02dh, 01h, 058h, 050h, 02eh, 089h, 086h, 076h, 02h
db 02eh, 089h, 086h, 0fh, 01h, 033h, 0dbh, 05h, 010h, 00h
db 08ch, 0c9h, 02bh, 0c8h, 0d1h, 0e1h, 083h, 0d3h, 00h, 0ebh
db 0ch, 090h, 0eah, 0d1h, 0e3h, 0d1h, 0e1h, 083h, 0d3h, 00h
db 0ebh, 0bh, 0ffh, 0d1h, 0e3h, 0d1h, 0e1h, 083h, 0d3h, 00h
db 0ebh, 0edh, 09ah, 08eh, 0c0h, 08eh, 0d8h, 033h, 0f6h, 033h
db 0ffh, 0e8h, 0fbh, 00h, 0ebh, 01h, 0eah, 0adh, 033h, 086h
db 080h, 02h, 03h, 086h, 082h, 02h, 0d1h, 0c8h, 033h, 086h
db 084h, 02h, 02bh, 086h, 086h, 02h, 0d1h, 0c0h, 0abh, 053h
db 051h, 08bh, 0c6h, 08bh, 0d8h, 0b1h, 04h, 0d3h, 0e8h, 0d3h
db 0e0h, 03bh, 0c3h, 075h, 0dh, 083h, 0eeh, 010h, 083h, 0efh
db 010h, 01eh, 058h, 040h, 08eh, 0d8h, 08eh, 0c0h, 059h, 05bh
db 0e2h, 0c9h, 083h, 0fbh, 00h, 074h, 06h, 04bh, 0ebh, 0c1h
db 0e8h, 0b6h, 00h, 050h, 01eh, 033h, 0c0h, 08eh, 0d8h, 08dh
db 086h, 0d5h, 01h, 087h, 06h, 00h, 00h, 050h, 08ch, 0c8h
db 087h, 06h, 02h, 00h, 050h, 033h, 0c9h, 02eh, 0c7h, 086h
db 0a4h, 01h, 090h, 090h, 0f7h, 0f1h, 058h, 087h, 06h, 02h
db 00h, 058h, 087h, 06h, 00h, 00h, 01fh, 058h, 07h, 01fh
db 02eh, 08bh, 086h, 076h, 02h, 05h, 010h, 00h, 02eh, 03h
db 086h, 07ch, 02h, 0fah, 08eh, 0d0h, 02eh, 08bh, 0a6h, 07eh
db 02h, 0fbh, 033h, 0c0h, 08bh, 0f0h, 08bh, 0f8h, 02eh, 0ffh
db 0aeh, 078h, 02h, 02eh, 08bh, 086h, 076h, 02h, 05h, 010h
db 00h, 02eh, 01h, 086h, 07ah, 02h, 0e8h, 01h, 00h, 0cfh
db 050h, 053h, 051h, 052h, 06h, 01eh, 056h, 057h, 055h, 08bh
db 0ddh, 02eh, 08bh, 0afh, 0a0h, 02h, 02eh, 08bh, 08fh, 08eh
db 02h, 0bh, 0c9h, 074h, 027h, 03h, 0ebh, 02eh, 0c5h, 0b6h
db 088h, 02h, 02bh, 0ebh, 08ch, 0d8h, 02eh, 03h, 087h, 076h
db 02h, 05h, 010h, 00h, 08eh, 0d8h, 02eh, 08bh, 087h, 076h
db 02h, 05h, 010h, 00h, 01h, 04h, 083h, 0c5h, 04h, 0e8h
db 017h, 00h, 0e2h, 0d9h, 05dh, 05fh, 05eh, 01fh, 07h, 05ah
db 059h, 05bh, 058h, 0c3h, 05dh, 0ebh, 01h, 0eah, 055h, 081h
db 0edh, 03h, 01h, 0c3h, 0c3h, 0ebh, 014h, 090h, 0eah, 0e8h
db 02ch, 00h, 0ebh, 06h, 090h, 0e8h, 026h, 00h, 0ebh, 0f5h
db 0bh, 0edh, 074h, 0f7h, 05dh, 0ebh, 0e9h, 055h, 033h, 0edh
db 0ebh, 0efh, 050h, 072h, 06fh, 074h, 065h, 063h, 074h, 069h
db 06fh, 06eh, 020h, 062h, 079h, 020h, 042h, 06ch, 061h, 063h
db 06bh, 020h, 057h, 06fh, 06ch, 066h, 0e4h, 021h, 034h, 02h
db 0e6h, 021h, 045h, 0c3h, 00h, 00h
;------------------------------------------------------------------------
Old_IP  dw      0
Old_CS  dw      0fff0
Old_SS  dw      0fff0
Old_SP  dw      0
Key1    dw      0
Key2    dw      0
Key3    dw      0
Key4    dw      0
;------------------------------------------------------------------------
end_password:
Header:
        db     800 dup(0)       ;leave space for ultimute with db (0)'s
end start

*** passcom.asm ***


;                   Black Wolf's File Protection Utilities 2.1s
;
;PassCOM - This program password protects the specified file by attaching
;          code from PW_COM onto the file so that it will check for passwords
;          each execution.  It utilizes ULTIMUTE .93� to protect then PW_COM
;          code from easy manipulation.
;
;LISCENSE:
;    Released As Freeware - These files may be distributed freely.
;
;Any modifications made to this program should be listed below the solid line,
;along with the name of the programmer and the date the file was changed.
;Also - they should be commented where changed.
;
;NOTE THAT MODIFICATION PRIVILEDGES APPLY ONLY TO THIS VERSION (2.1s)!  
;I'd appreciate notification of any modifications if at all possible, 
;reach me through the address listed in the documentation file (bwfpu21s.doc).
;
;DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
;resulting from the use/misuse of this program/file.  The user agrees to hold
;the author harmless for any consequences that may occur directly or 
;indirectly from the use of this program by utilizing this program/file
;in any manner.
;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
       
       org 100

        extrn   _ULTMUTE:near, _END_ULTMUTE:byte

start:
        call    GetFilename
        call    Get_Passes
        call    EncryptGP
        call    Do_File
        mov     ax,4c00
        int     21
;---------------------------------------------------------------------------
GetFilename:
        mov     ah,09
        mov     dx,offset Message
        int     21

        mov     dx,offset Filename_Data
        mov     al,60
        call    gets
        ret
;---------------------------------------------------------------------------
Get_Passes:
    Clear_Out_Passes:        
        mov     di,offset Entered_Pass
        mov     cx,0ch                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb
        mov     di,offset Password
        mov     cx,0ch                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb
        
        mov     ah,09
        mov     dx,offset Req_Pass
        int     21

        mov     di,offset Entered_Pass
        mov     cx,0ch
        call    GetPass

        mov     ah,09
        mov     dx, offset Dup_Pass
        int     21

        mov     di,offset Password
        mov     cx,0ch
        call    GetPass
        
        call    Check_Passwords
        jc      Get_Passes
        
        mov     di,offset Entered_Pass
        mov     cx,0dh                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb

Randomize_Keys:
        push    ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,word ptr ds:[46c]    ;Randomizes encryption
        pop     ds
        mov     word ptr [Key1],ax
        xor     ax,1f3eh
        ror     ax,1
        mov     word ptr [Key2],ax
        


Encrypt_Password:                       ;This algorithm needs extra work...
        mov     bx,word ptr [Key1]
        mov     dx,word ptr [Key2]      ;Encrypt the password
        mov     si,offset Password
        mov     di,si
        mov     cx,6
  EncryptIt:      
        lodsw
        xor     ax,bx
        add     bx,dx
        stosw
        loop    EncryptIt
        ret
;---------------------------------------------------------------------------
Message:
        db      'PassCOM 2.0 (c) 1993 Black Wolf Enterprises.',0a,0dh
        db      'Enter Filename To Protect -> $'
;---------------------------------------------------------------------------
Req_Pass        db      0a,0dh,'Now Enter Password (up to 12 chars): $'
Dup_Pass        db      0a,0dh,'Re-Enter Password: $'
Passes_Not      db      0a,0dh,'Passwords do not match.  Try again.',0a,0dh,24
;---------------------------------------------------------------------------
Check_Passwords:
        mov     si,offset Entered_Pass
        mov     di,offset Password
        mov     cx,0c
        repz    cmpsb
        jcxz    Password_Good
        stc
        ret
Password_Good:
        clc
        ret
;---------------------------------------------------------------------------


gets:                   ;get string
        mov     ah,0a
        push    bx
        mov     bx,dx
        mov     byte ptr ds:[bx],al
        mov     byte ptr ds:[bx+1],0
        pop     bx
        int     21
        push    bx
        mov     bx,dx
        mov     al,byte ptr ds:[bx+1]
        xor     ah,ah
        add     bx,ax
        mov     byte ptr ds:[bx+2],0
        pop     bx
        ret
;---------------------------------------------------------------------------
GetPass:
  KeyHit_Loop:          ;Load in password
        push    cx
        sub     ax,ax
        int     16
        cmp     al,0dh
        je      HitReturn
        stosb
        pop     cx
        loop    KeyHit_Loop
        ret
  HitReturn:
        pop     cx
        xor     al,al
        repnz   stosb
        ret        


;---------------------------------------------------------------------------
Time    dw      0
Date    dw      0

GetTime:
        mov     ax,5700 ;Get file date/time from handle BX
        int     21
        mov     word ptr cs:[Time],cx
        mov     word ptr cs:[Date],dx
        ret

SetTime:                ;Set file date/time for handle BX
        mov     ax,5701
        mov     cx,word ptr cs:[Time]
        mov     dx,word ptr cs:[Date]
        int     21
        ret

Do_File:        
        mov     ax,3d02
        mov     dx,offset Filename
        int     21                      ;Open file read/write
        jc      Terminate
        xchg    bx,ax

        call    GetTime                 ;Get file date/time
        call    BackupFile              ;make a copy....
        
        mov     ah,3f
        mov     cx,4
        mov     dx,offset Storage_Bytes ;Read in first four bytes for jump
        int     21

        mov     ax,4202
        xor     cx,cx
        xor     dx,dx                   ;go to the end of the file
        int     21

        sub     ax,3
        mov     word ptr [JumpBytes+1],ax ;Save Jump size
        
        push    bx        
        mov     si,offset begin_password        ;On Entry -> CS=DS=ES
        mov     di,offset _END_ULTMUTE          ;SI=Source, DI=Destination
        mov     bx,ax                           ;BX=Next Entry Point
        add     bx,103
        mov     cx,end_password-begin_password+1 ;CX=Size to Encrypt
        mov     ax,1                             ;AX=Calling Style
        
        call    _ULTMUTE                        ;Encrypt Code
                                                
                                                ;On Return -> CX=New Size
        pop     bx
        
        mov     dx,offset _END_ULTMUTE
        mov     ah,40                           ;Write encrypted code and
        int     21                              ;decryptor to end of file
        
        mov     ax,4200
        xor     dx,dx                           ;Go back to beginning of file
        xor     cx,cx
        int     21
        
        mov     ah,40
        mov     cx,4
        mov     dx,offset JumpBytes             ;Write in jump to decryptor
        int     21
        
        call    SetTime                         ;Restore file date/time

        mov     ah,3e
        int     21                              ;close file
        ret

Terminate:
        mov     ah,09
        mov     dx,offset BadFile
        int     21
        ret
BadFile db      'Error Opening File.',07,0dh,0a,24

JumpBytes       db      0e9,0,0,'�'

EncryptGP:                              ;Encrypt GoodPass routine in pw_com
        xor     ax,ax                   ;with value from password itself...
        mov     cx,0c
        mov     si,offset Password

GetValue:        
        lodsb
        add     ah,al
        ror     ah,1                    ;Get value to use for encrypt...
        loop    GetValue

        mov     si,offset Goodpass
        mov     cx,EndGoodPass-GoodPass
       
Decrypt_Restore:                ;This needs improvement....
        mov     al,[si]
        xor     al,ah
        mov     [si],al
        inc     si
        loop    Decrypt_Restore
        ret        

BackupFile:                             ;Create copy of file...
        mov     si,offset Filename
        mov     cx,80

  Find_Eofn:
        lodsb
        cmp     al,'.'          ;Find file extension
        je      FoundDot
        or      al,al
        jz      FoundZero
        loop    Find_Eofn
        jmp     Terminate
FoundZero:
        mov     byte ptr [si-1],'.'
        inc     si
FoundDot:
        mov     word ptr [si],'LO'
        mov     byte ptr [si+2],'D'     ;Change extension to 'OLD'
        mov     byte ptr [si+3],0

        
        mov     dx,offset Filename
        mov     word ptr [SourceF],bx
        mov     ah,3c
        xor     cx,cx
        int     21
        jnc     GCreate
         jmp    Terminate
GCreate:
        mov     word ptr cs:[Destf],ax
BackLoop:
        mov     ah,3f
        mov     bx,word ptr cs:[Sourcef]
        mov     cx,400
        mov     dx,offset FileBuffer            ;Copy file to backup
        int     21

        mov     cx,ax
        mov     ah,40
        mov     bx,word ptr cs:[Destf]
        mov     dx,offset Filebuffer
        int     21

        cmp     ax,400
        je      BackLoop
DoneBack:
        mov     bx,word ptr cs:[Destf]
        call    SetTime                 ;Save original date/time stamp in 
                                        ;backup
        mov     ah,3e
        mov     bx,word ptr cs:[Destf]
        int     21                      ;Close file

        mov     ax,4200
        xor     cx,cx
        xor     dx,dx
        mov     bx,word ptr cs:[Sourcef] ;Go back to the beginning of the
        int     21                       ;source file
        ret

SourceF dw      0
DestF   dw      0

        ;This is code from PW_COM compiled converted to data bytes..
        ;If you modify PW_COM, you must compile it and convert it, then
        ;place it here.  Note that the byte 0ffh marks the beginning and
        ;end of Goodpass for simplicity....

begin_password: 
db 0e8h, 02dh, 01h, 02eh, 0c6h, 086h, 09h, 01h, 0eah, 0ebh
db 06h, 00h, 0ebh, 011h, 090h, 0adh, 0deh, 0bbh, 021h, 01h
db 03h, 0ddh, 053h, 02eh, 0c6h, 086h, 011h, 01h, 0c3h, 0ebh
db 0edh, 0ebh, 0f0h, 0fah, 050h, 01eh, 033h, 0c0h, 08eh, 0d8h
db 08dh, 086h, 01ch, 02h, 087h, 06h, 00h, 00h, 050h, 08ch
db 0c8h, 087h, 06h, 02h, 00h, 050h, 01eh, 0eh, 01fh, 02eh
db 0c7h, 086h, 044h, 01h, 090h, 090h, 033h, 0c9h, 0f7h, 0f1h
db 01fh, 058h, 087h, 06h, 02h, 00h, 058h, 087h, 06h, 00h
db 00h, 01fh, 058h, 0fbh, 0e8h, 0aah, 00h, 02eh, 080h, 086h
db 05eh, 01h, 010h, 0ebh, 03h, 090h, 0eah, 09ah, 0e8h, 081h
db 00h, 0e8h, 069h, 00h, 072h, 038h, 033h, 0c0h, 0b9h, 0ch
db 00h, 08dh, 0b6h, 04eh, 02h, 0ach, 02h, 0e0h, 0d0h, 0cch
db 0e2h, 0f9h, 08dh, 0b6h, 090h, 01h, 0b9h, 011h, 00h, 08ah
db 04h, 032h, 0c4h, 088h, 04h, 046h, 0e2h, 0f7h, 0e8h, 039h
db 00h, 0ebh, 01h, 0ffh 

GoodPass:
db 0bfh, 00h, 01h, 057h, 08dh, 0b6h
db 03eh, 02h, 0a5h, 0a5h, 033h, 0c0h, 08bh, 0f0h, 08bh, 0f8h
db 0c3h 
EndGoodPass:

db 0ffh, 0b4h, 09h, 08dh, 096h, 0afh, 01h, 0cdh, 021h
db 0b8h, 01h, 04ch, 0cdh, 021h, 0ah, 0dh, 050h, 061h, 073h
db 073h, 077h, 06fh, 072h, 064h, 020h, 049h, 06eh, 063h, 06fh
db 072h, 072h, 065h, 063h, 074h, 02eh, 07h, 024h, 090h, 0ebh
db 05h, 090h, 0eah, 0f8h, 0c3h, 09ah, 0fch, 0ebh, 0fah, 08dh
db 0b6h, 04eh, 02h, 08dh, 0beh, 042h, 02h, 0b9h, 0ch, 00h
db 0f3h, 0a6h, 0e3h, 03h, 0f9h, 0c3h, 0e9h, 0f8h, 0c3h, 00h
db 08bh, 09eh, 03ah, 02h, 08bh, 096h, 03ch, 02h, 08dh, 0b6h
db 04eh, 02h, 08bh, 0feh, 0b9h, 06h, 00h, 0adh, 033h, 0c3h
db 03h, 0dah, 0abh, 0e2h, 0f8h, 0c3h, 0eah, 0b9h, 0ch, 00h
db 08dh, 0beh, 04eh, 02h, 051h, 02bh, 0c0h, 0cdh, 016h, 03ch
db 0dh, 074h, 05h, 0aah, 059h, 0e2h, 0f3h, 0c3h, 059h, 032h
db 0c0h, 0f2h, 0aah, 0c3h, 0b4h, 09h, 08dh, 096h, 025h, 02h
db 0cdh, 021h, 0cfh, 050h, 061h, 073h, 073h, 077h, 06fh, 072h
db 064h, 02dh, 03eh, 024h, 05dh, 0ebh, 01h, 0eah, 055h, 081h
db 0edh, 03h, 01h, 0c3h
;------------------------------------------------------------------------
Key1            dw      0
Key2            dw      0
;------------------------------------------------------------------------
Storage_Bytes   db      90,90,0cdh,20
;------------------------------------------------------------------------
Password        db      'Greetings to'
Entered_Pass    db      'everyone!   '
db      0,0,0,0,0,0,0
end_password:
                dw      0
                dw      0
Filename_data   dw      0
Filename        db      80 dup(0)       ;These are stored as zeros to 
FileBuffer      db      400 dup(0)      ;keep from overwriting ultimute...
end start

*** passexe.asm ***


;                   Black Wolf's File Protection Utilities 2.1s
;
;PassEXE - This program password protects the specified file by attaching
;          code from PW_EXE onto the file so that it will check for passwords
;          each execution.  It utilizes ULTIMUTE .93� to protect then PW_EXE
;          code from easy manipulation.
;
;LISCENSE:
;    Released As Freeware - These files may be distributed freely.
;
;Any modifications made to this program should be listed below the solid line,
;along with the name of the programmer and the date the file was changed.
;Also - they should be commented where changed.
;
;NOTE THAT MODIFICATION PRIVILEDGES APPLY ONLY TO THIS VERSION (2.1s)!  
;I'd appreciate notification of any modifications if at all possible, 
;reach me through the address listed in the documentation file (bwfpu21s.doc).
;
;DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
;resulting from the use/misuse of this program/file.  The user agrees to hold
;the author harmless for any consequences that may occur directly or 
;indirectly from the use of this program by utilizing this program/file
;in any manner.
;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
       
       org 100

        extrn   _ULTMUTE:near, _END_ULTMUTE:byte

start:
        call    GetFilename
        call    Get_Passes
        call    EncryptGP       ;needs work here....
        call    Do_File
        mov     ax,4c00
        int     21
;---------------------------------------------------------------------------
GetFilename:
        mov     ah,09
        mov     dx,offset Message
        int     21

        mov     dx,offset Filename_Data
        mov     al,60
        call    gets
        ret
;---------------------------------------------------------------------------
Get_Passes:
    Clear_Out_Passes:        
        mov     di,offset Entered_Pass
        mov     cx,0ch                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb
        mov     di,offset Password
        mov     cx,0ch                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb
        
        mov     ah,09
        mov     dx,offset Req_Pass
        int     21

        mov     di,offset Entered_Pass
        mov     cx,0ch
        call    GetPass

        mov     ah,09
        mov     dx, offset Dup_Pass
        int     21

        mov     di,offset Password
        mov     cx,0ch
        call    GetPass
        
        call    Check_Passwords
        jc      Get_Passes
        
        mov     di,offset Entered_Pass
        mov     cx,0dh                   ;Clear out entered pass.
        xor     ax,ax
        repnz   stosb

Randomize_Keys:
        push    ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,word ptr ds:[46c]    ;Randomizes encryption
        pop     ds
        mov     word ptr [Key1],ax
        xor     ax,1f3eh
        ror     ax,1
        mov     word ptr [Key2],ax
        


Encrypt_Password:
        mov     bx,word ptr [Key1]
        mov     dx,word ptr [Key2]      ;Encrypt the password - needs 
        mov     si,offset Password      ;some work on algorithm....
        mov     di,si
        mov     cx,6
  EncryptIt:      
        lodsw
        xor     ax,bx
        add     bx,dx
        stosw
        loop    EncryptIt
        ret
;---------------------------------------------------------------------------
Message:
        db      'PassEXE 2.0 (c) 1993 Black Wolf Enterprises.',0a,0dh
        db      'Enter Filename To Protect -> $'
;---------------------------------------------------------------------------
Req_Pass        db      0a,0dh,'Now Enter Password (up to 12 chars): $'
Dup_Pass        db      0a,0dh,'Re-Enter Password: $'
Passes_Not      db      0a,0dh,'Passwords do not match.  Try again.',0a,0dh,24
;---------------------------------------------------------------------------
Check_Passwords:
        mov     si,offset Entered_Pass
        mov     di,offset Password
        mov     cx,0c
        repz    cmpsb
        jcxz    Password_Good
        stc
        ret
Password_Good:
        clc
        ret
;---------------------------------------------------------------------------


gets:
        mov     ah,0a           ;Get string
        push    bx
        mov     bx,dx
        mov     byte ptr ds:[bx],al
        mov     byte ptr ds:[bx+1],0
        pop     bx
        int     21
        push    bx
        mov     bx,dx
        mov     al,byte ptr ds:[bx+1]
        xor     ah,ah
        add     bx,ax
        mov     byte ptr ds:[bx+2],0
        pop     bx
        ret
;---------------------------------------------------------------------------
GetPass:
  KeyHit_Loop:
        push    cx
        sub     ax,ax
        int     16
        cmp     al,0dh
        je      HitReturn
        stosb
        pop     cx
        loop    KeyHit_Loop
        ret
  HitReturn:
        pop     cx
        xor     al,al
        repnz   stosb
        ret        


;---------------------------------------------------------------------------
Save_Header:                               ;Save important values from header
        
        mov     ax,word ptr [exeheader+0e]    ;Save old SS
        mov     word ptr [Old_SS],ax
        mov     ax,word ptr [exeheader+10]    ;Save old SP
        mov     word ptr [Old_SP],ax
        mov     ax,word ptr [exeheader+14]    ;Save old IP
        mov     word ptr [Old_IP],ax
        mov     ax,word ptr [exeheader+16]    ;Save old CS
        mov     word ptr [Old_CS],ax
        ret

GetTime:
        mov     ax,5700
        int     21
        mov     word ptr cs:[Time],cx
        mov     word ptr cs:[Date],dx
        ret
SetTime:
        mov     ax,5701
        mov     cx,word ptr cs:[Time]
        mov     dx,word ptr cs:[Date]
        int     21
        ret


Do_File:        
        mov     ax,3d02
        mov     dx,offset Filename
        int     21                      ;open read/write
        jc      Terminate
        xchg    bx,ax
        
        call    GetTime        
        call    BackupFile

        mov     ah,3f
        mov     cx,1a
        mov     dx,offset EXEheader     ;read in header info
        int     21

        cmp     word ptr [EXEheader],'ZM'       ;not EXE file - don't 
        jne     close_file                      ;protect it....
        call    Save_Header
        
        mov     ax,4202
        xor     cx,cx                   ;go to end of file
        xor     dx,dx
        int     21
        
        push    ax dx                   ;save file size

        call    calculate_CSIP          ;calculate starting
                                        ;point.

        mov     ah,40
        mov     dx,offset Set_Segs       ;write in the 'push es ds'
        mov     cx,end_set_segs-set_segs ;'push cs cs' 'pop es ds' stuff...
        int     21

        push    bx        
        mov     si,offset begin_password        ;On Entry -> CS=DS=ES
        mov     di,offset _END_ULTMUTE          ;SI=Source, DI=Destination
        
        mov     bx,word ptr [exeheader+14]       ;BX=Next Entry Point
        add     bx,end_set_segs-set_segs

        mov     cx,end_password-begin_password+1 ;CX=Size to Encrypt
        mov     ax,1                             ;AX=Calling Style
        
        call    _ULTMUTE                        ;Encrypt code
                                                
                                                ;On Return -> CX=New Size

        pop     bx
        
        pop     dx ax                   ;DX:AX = unmodified
                                        ;file size.
        
        push    cx bx
        add     cx,end_set_segs-set_segs
        call    calculate_size
        pop     bx cx

        mov     dx,offset _END_ULTMUTE
        mov     ah,40                   ;Append host
        int     21
        
        mov     ax,4200
        xor     dx,dx
        xor     cx,cx
        int     21
        
        mov     ah,40
        mov     cx,1a
        mov     dx,offset EXEheader
        int     21
        
Close_File:
        call    SetTime
        mov     ah,3e
        int     21
        ret

Terminate:
        mov     ah,09
        mov     dx,offset BadFile
        int     21
        ret
BadFile db      'Error Opening File.',07,0dh,0a,24

calculate_CSIP:
        push    ax
        mov     cl,4 
        mov     ax,word ptr [exeheader+8]       ;Get header length
                                                ;and convert it to
        shl     ax,cl                           ;bytes.
        mov     cx,ax
        pop     ax

        sub     ax,cx                           ;Subtract header
        sbb     dx,0                            ;size from file
                                                ;size for memory
                                                ;adjustments

        mov     cl,0c                           ;Convert DX into
        shl     dx,cl                           ;segment Address
        mov     cl,4
        push    ax                      ;Change offset (AX) into
        shr     ax,cl                   ;segment, except for last
        add     dx,ax                   ;digit.  Add to DX and
        shl     ax,cl                   ;save DX as new CS, put
        pop     cx                      ;left over into CX and
        sub     cx,ax                   ;store as the new IP.
        mov     word ptr [exeheader+16],dx    ;Set new CS:IP
        mov     word ptr [exeheader+10],0fffe ;Set new SP
        mov     word ptr [exeheader+0e],dx    ;Set new SS = CS
        mov     word ptr [exeheader+14],cx
        ret

calculate_size:
        push    ax                      ;Save offset for later
        
        add     ax,cx                   ;Add program size to DX:AX
        
        adc     dx,0

        mov     cl,7
        shl     dx,cl                   ;convert DX to pages
        mov     cl,9
        shr     ax,cl
        add     ax,dx
        inc     ax
        mov     word ptr [exeheader+04],ax  ;save # of pages

        pop     ax                              ;Get offset
        mov     dx,ax
        shr     ax,cl                           ;Calc remainder
        shl     ax,cl                           ;in last page
        sub     dx,ax
        mov     word ptr [exeheader+02],dx ;save remainder
        ret

EncryptGP:                              ;Encrypt GoodPass
        xor     ax,ax
        mov     cx,0c
        mov     si,offset Password

GetValue:        
        lodsb
        add     ah,al
        ror     ah,1                    ;Get value to use for encrypt...
        loop    GetValue

        mov     si,offset Goodpass
        mov     cx,EndGoodPass-GoodPass
        
Decrypt_Restore:        
        mov     al,[si]
        xor     al,ah
        mov     [si],al
        inc     si
        loop    Decrypt_Restore
        ret        

Time    dw      0
Date    dw      0

Set_Segs:
        push    es ds
        push    cs cs
        pop     es ds
 End_Set_Segs:

BackupFile:                     ;Make backup of file...
        mov     si,offset Filename
        mov     cx,80

  Find_Eofn:                    ;Find end of file name...
        lodsb
        cmp     al,'.'
        je      FoundDot
        or      al,al
        jz      FoundZero
        loop    Find_Eofn
        jmp     Terminate
FoundZero:
        mov     byte ptr [si-1],'.'
        inc     si
FoundDot:
        mov     word ptr [si],'LO'
        mov     byte ptr [si+2],'D'     ;Set filename to *.OLD
        mov     byte ptr [si+3],0

        
        mov     dx,offset Filename
        mov     word ptr [SourceF],bx
        mov     ah,3c
        xor     cx,cx
        int     21
        jnc     GCreate
         jmp    Terminate
GCreate:
        mov     word ptr cs:[Destf],ax
BackLoop:
        mov     ah,3f
        mov     bx,word ptr cs:[Sourcef]
        mov     cx,400
        mov     dx,offset FileBuffer
        int     21

        mov     cx,ax
        mov     ah,40
        mov     bx,word ptr cs:[Destf]
        mov     dx,offset Filebuffer
        int     21

        cmp     ax,400
        je      BackLoop
DoneBack:
        call    SetTime

        mov     ah,3e
        mov     bx,word ptr cs:[Destf]
        int     21

        mov     ax,4200
        xor     cx,cx
        xor     dx,dx
        mov     bx,word ptr cs:[Sourcef]
        int     21
        ret

SourceF dw      0
DestF   dw      0


begin_password:
db 0e8h, 01fh, 01h, 0c6h, 086h, 08h, 01h, 0c3h, 0ebh, 01h
db 090h, 0fah, 050h, 01eh, 033h, 0c0h, 08eh, 0d8h, 08dh, 086h
db 0eh, 02h, 087h, 06h, 00h, 00h, 050h, 08ch, 0c8h, 087h
db 06h, 02h, 00h, 050h, 01eh, 0eh, 01fh, 02eh, 0c7h, 086h
db 02eh, 01h, 090h, 090h, 033h, 0c9h, 0f7h, 0f1h, 01fh, 058h
db 087h, 06h, 02h, 00h, 058h, 087h, 06h, 00h, 00h, 01fh
db 058h, 0fbh, 0e8h, 0b2h, 00h, 0e8h, 095h, 00h, 0e8h, 07fh
db 00h, 072h, 050h, 033h, 0c0h, 0b9h, 0ch, 00h, 08dh, 0b6h
db 044h, 02h, 0ach, 02h, 0e0h, 0d0h, 0cch, 0e2h, 0f9h, 08dh
db 0b6h, 06fh, 01h, 0b9h, 029h, 00h, 08ah, 04h, 032h, 0c4h
db 088h, 04h, 046h, 0e2h, 0f7h, 0e8h, 051h, 00h, 0ebh, 01h
db 0ffh 

GoodPass:
db 07h, 01fh, 08ch, 0c0h, 05h, 010h, 00h, 02eh, 01h
db 086h, 032h, 02h, 02eh, 03h, 086h, 034h, 02h, 0fah, 08eh
db 0d0h, 02eh, 08bh, 0a6h, 036h, 02h, 0fbh, 033h, 0c0h, 08bh
db 0f0h, 08bh, 0f8h, 02eh, 0ffh, 0aeh, 030h, 02h, 090h, 090h
db 090h, 090h, 0ffh 
EndGoodPass:

db 0b4h, 09h, 08dh, 096h, 0a6h, 01h, 0cdh
db 021h, 0b8h, 01h, 04ch, 0cdh, 021h, 0ah, 0dh, 050h, 061h
db 073h, 073h, 077h, 06fh, 072h, 064h, 020h, 049h, 06eh, 063h
db 06fh, 072h, 072h, 065h, 063h, 074h, 02eh, 07h, 024h, 090h
db 0ebh, 03h, 090h, 0f8h, 0c3h, 0fch, 0ebh, 0fbh, 08dh, 0b6h
db 044h, 02h, 08dh, 0beh, 038h, 02h, 0b9h, 0ch, 00h, 0f3h
db 0a6h, 0e3h, 02h, 0f9h, 0c3h, 0f8h, 0c3h, 08bh, 09eh, 02ch
db 02h, 08bh, 096h, 02eh, 02h, 08dh, 0b6h, 044h, 02h, 08bh
db 0feh, 0b9h, 06h, 00h, 0adh, 033h, 0c3h, 03h, 0dah, 0abh
db 0e2h, 0f8h, 0c3h, 0b9h, 0ch, 00h, 08dh, 0beh, 044h, 02h
db 051h, 02bh, 0c0h, 0cdh, 016h, 03ch, 0dh, 074h, 05h, 0aah
db 059h, 0e2h, 0f3h, 0c3h, 059h, 032h, 0c0h, 0f2h, 0aah, 0c3h
db 0b4h, 09h, 08dh, 096h, 017h, 02h, 0cdh, 021h, 0cfh, 050h
db 061h, 073h, 073h, 077h, 06fh, 072h, 064h, 02dh, 03eh, 024h
db 05dh, 0ebh, 01h, 0eah, 055h, 081h, 0edh, 03h, 01h, 0c3h
;------------------------------------------------------------------------
Key1            dw      0
Key2            dw      0
;------------------------------------------------------------------------
Old_IP  dw      0
Old_CS  dw      0fff0
Old_SS  dw      0fff0
Old_SP  dw      0
;------------------------------------------------------------------------
Password        db      'Greets progr'
Entered_Pass    db      'ammers.. }-)'
;------------------------------------------------------------------------
end_password:
                dw      0
                dw      0
Filename_data   dw      0
Filename        db      80 dup(0)
FileBuffer      dw      400 dup(0)
Exeheader       db      1a dup(0)
end start



*** ultimute.asm ***


;      The ULTImate MUTation Engine .93� (c) 1993 Black Wolf Enterprises
;               pardon the title, had to think of something... }-)
;
;ULTIMUTE is a mutation engine written for security-type applications and 
;other areas where mutation of executable code is necessary.  For my personal
;use, I have implemented it in Black Wolf's File Protection Utilities 2.1s,
;using it to encrypt the code placed onto EXE's and COM's to protect them
;from simple modification and/or unauthorized use.  The encryption algorithms
;themselves are terribly simple - the main point being that they change
;each time and are difficult to trace through.  This engine is written mainly
;to keep a "hack one, hack 'em all" approach from working on protected code,
;rather than to keep the code secure by a cryptologist's point of view.
;
;Including: Better Anti-Tracing abilities, 1017 byte size, Anti-Disassembling
;           code, largely variable size for decoder.  Also includes variable
;           calling segmentation (i.e. CS<>ES<>DS, and can be called via
;           near call, far call, or interrupt, the last of which can be
;           useful as a memory-resident handler for multiple programs to
;           use).
;
;Note: Please - this program and it's source have been released as freeware,
;      but do NOT use the mutation engine in viruses!  For one thing, the
;      decryptor sequence has several repetitive sequences that can be scanned
;      for, and for another, that just isn't what it was designed for and
;      I would NOT appreciate it.  If you MUST use someone else's mutation
;      engine for such, use the TPE or MTE.  I do NOT condone such, however.
;
;Any modifications made to this program should be listed below the solid line,
;along with the name of the programmer and the date the file was changed.
;Also - they should be commented where changed.  If at all possible, report
;modifications to file to the address listed in the documentation.
;
;DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
;resulting from the use/misuse of this program.  The user agrees to hold
;the author harmless for any consequences that may occur directly or 
;indirectly from the use of this program by utilizing this program/file
;in any manner.  Please use the engine with care.
;
;Modifications:
;       None as of yet (original release version)

.model tiny
.radix 16
.code

        public  _ULTMUTE, _END_ULTMUTE, Get_Rand, Init_Rand

;Underscores are used so that these routines can be called from C and other
;upper level languages.  If you wish to use Get_Rand and Init_Rand in C, you
;need to add underscores in their names as well.  Also, the random number
;generations may not be sound for all purposes.  They do the job for this
;program, but they may/may not be mathematically correct.

;ENTRY:
;       CX=Code Length          BX=New_Entry_Point
;       DS:SI=Code              AX=Calling Style
;       ES:DI=Destination               1=Near Call, 2=Far Call, 3=Int Call
;
;RETURN:
;       CX=New Size             ES:DI = Same, now contains encrypted code 
;                                       w/decryptor
_ULTMUTE:                               
        push    bp ax bx cx dx es ds si di
        call    Get_Our_Offset
  Offset_Mark:
        inc     cx
        inc     cx
        mov     word ptr cs:[bp+1+Set_Size],cx
        mov     word ptr cs:[Start_Pos+bp],bx
        call    Init_Rand
        call    Get_Base_Reg
        call    Setup_Choices
        call    Create_EncDec
        call    Copy_Decrypt_Code
        call    Encrypt_It
Ending_ULTMUTE:
        pop     di si ds es dx cx bx ax
        add     cx,cs:[Decryptor_Length+bp]
        inc     cx
        inc     cx
        pop     bp
        cmp     ax,3       ;Select Returning method, i.e. retn, retf, iret
        je      Int_Call
        cmp     ax,2
        je      Far_Call
Near_Call:
        retn
Far_Call:
        retf
Int_Call:        
        iret
Get_Our_Offset:
        mov     bp,sp
        mov     bp,ss:[bp]              ;This trick finds our current offset
        sub     bp,offset Offset_Mark   ;from the compiling point, as it
        ret                             ;is usually not constant....
Init_Rand:
        push    ax ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,ds:[46c]             ;Get seed from timer click at
        pop     ds                      ;0000:046c
        mov     cs:[rand_seed+bp],ax
        pop     ax
        ret
Get_Rand:
        push    cx dx
        mov     ax,cs:[rand_seed+bp]
        mov     cx,0deadh
        mul     cx                      ;This probably isn't a good algorithm,
        xor     ax,0dada                ;(understatement) but it works for
        ror     ax,1                    ;our purposes in this application.
        mov     cs:[rand_seed+bp],ax
        pop     dx cx
        ret
rand_seed       dw      0
Base_Reg        db      0
Base_Pointer    db      0
Start_Pos       dw      0
Get_Base_Reg:
        call    Get_Rand
        and     ax,11b
        cmp     al,1                    ;Eliminate CX for loop purposes
        je      Get_Base_Reg
        mov     byte ptr cs:[bp+Base_Reg],al
   Do_Pointer_Reg:
        call    Get_Rand
        shr     al,1
        jc      Done_Base_Reg
        mov     byte ptr cs:[bp+Base_Pointer],0
        ret
    Done_Base_Reg:
        mov     byte ptr cs:[bp+Base_Pointer],1
        ret
Setup_Choices:
        push    ds si        
        push    cs
        pop     ds
        mov     si,bp

        call    Get_Rand
        mov     word ptr [si+Xor_It+2],ax        ;Randomize Xor
        call    Get_Rand
        mov     word ptr [si+Dummy3+2],ax       ;Randomize Add/Sub
        mov     word ptr [si+Dummy7+2],ax       
        
        call    Get_Rand                        ;Randomize Add/Sub
        mov     word ptr [si+Dummy4+2],ax
        mov     word ptr [si+Dummy8+2],ax

        call    Get_Rand
        mov     byte ptr [si+Rand_Byte1],al     ;Randomize Random bytes
        mov     byte ptr [si+Rand_Byte2],ah
        call    Get_Rand 
        mov     byte ptr [si+Rand_Byte3],al
        mov     byte ptr [si+Rand_Byte4],ah
        call    Get_Rand
        mov     byte ptr [si+Rand_Byte5],al
        mov     byte ptr [si+Rand_Byte6],ah
        call    Get_Rand
        mov     byte ptr [si+Rand_Byte7],al
        mov     byte ptr [si+Rand_Byte8],ah
        call    Get_Rand
        mov     byte ptr [si+Rand_Byte9],al
        mov     byte ptr [si+Rand_Byte10],ah

        mov     al,byte ptr [si+Base_Reg]
  Set_Switcher:
        and     byte ptr [si+Switcher+1],0e6       ;Delete Register
        mov     ah,al
        shl     ah,1
        shl     ah,1
        shl     ah,1
        or      byte ptr [Switcher+1+si],ah
    Set_Switcher_Pointer:    
        push    ax
        mov     al,byte ptr [si+Base_Pointer]
        or      byte ptr [si+Switcher+1],al
    Set_Set_Pointy:
        and     byte ptr [si+Set_Pointy],0fe
        or      byte ptr [si+Set_Pointy],al
        and     byte ptr [si+Inc_Pointy],0fe
        or      byte ptr [si+Inc_Pointy],al
        and     byte ptr [si+Inc_Pointy+1],0fe
        or      byte ptr [si+Inc_Pointy+1],al
        pop     ax
  Set_Xorit:
        and     byte ptr [si+Xor_It+1],0fc
        or      byte ptr [si+Xor_It+1],al
  Set_Flip_It:
        and     byte ptr [si+Flip_It+1],0e4
        or      byte ptr [si+Flip_It+1],al
        or      byte ptr [si+Flip_It+1],ah
  Set_Rotate_It:
        and     byte ptr [si+do_rotate+1],0fc
        or      byte ptr [si+do_rotate+1],al
        and     byte ptr [si+do_rot2+1],0fc
        or      byte ptr [si+do_rot2+1],al
  Set_IncDec:
        and     byte ptr [si+inc_bx_com],0fc
        or      byte ptr [si+inc_bx_com],al
        and     byte ptr [si+dec_bx_com],0fc
        or      byte ptr [si+dec_bx_com],al

        and     byte ptr [si+Dummy5],0fc
        or      byte ptr [si+Dummy5],al
        and     byte ptr [si+Dummy6],0fc
        or      byte ptr [si+Dummy6],al

  Set_AddSub:
        and     byte ptr [si+Dummy3+1],0fc
        and     byte ptr [si+Dummy4+1],0fc
        or      byte ptr [si+Dummy3+1],al
        or      byte ptr [si+Dummy4+1],al
        
        and     byte ptr [si+Dummy7+1],0fc
        and     byte ptr [si+Dummy8+1],0fc
        or      byte ptr [si+Dummy7+1],al
        or      byte ptr [si+Dummy8+1],al
        pop     si ds
        ret
Create_EncDec:
        push    es di cx
        push    cs
        pop     es
        lea     di,[bp+Encrypt_Sequence]
        call    Get_Rand
        and     ax,1fh
        shr     ax,1            ;Insure odd number of encryptors to prevent
        shl     ax,1            ;things like "INC AX / DEC AX" to leave prog
        inc     ax              ;unencrypted.

        mov     byte ptr cs:[bp+Encrypt_Length],al
        xchg    cx,ax
Make_Pattern:
        call    Get_Rand   
        and     ax,7
        stosb
        loop    Make_Pattern
        pop     cx di es
        ret
Copy_Decrypt_Code:
        push    si di bx cx ds
        push    bx di                      ;save for loop

        push    cs
        pop     ds

        lea     si,[bp+Set_Pointy]               
        movsw
        movsb
        lodsb                   ;Copy initial encryptor
        movsw
        movsb
        lodsb
        movsw

        mov     cl,byte ptr cs:[bp+Encrypt_Length]
        xor     ch,ch
        lea     si,[Encrypt_Sequence+bp]        ;didn't have bp earlier
   Dec_Set_Loop:
        push    cx
        lodsb        
        push    si                      ;Create the Decryptor from Sequence

        mov     bl,al
        xor     bh,bh
        shl     bx,1
        add     bx,bp
        add     bx,offset Command_Table
        mov     ax,cs:[bx]
        
        mov     cl,ah
        xor     ah,ah

        lea     si,[Xor_It+bp]
        add     si,ax
        repnz   movsb

        pop     si
        pop     cx
        loop    Dec_Set_Loop


        lea     si,[Switcher+bp]
        movsw
        lodsb                           ;Finish off Decryptor
        movsw
        lodsb
        
        movsw   ;Loop Setup
        movsw                

        pop     si bx
        mov     ax,di                   ;Set Loop
        sub     ax,si                   ;Do size of loop and offset from loop
        
        mov     cs:[Decryptor_Length+bp],ax
        
        push    ax                              ;Changed for Jump
        not     ax
        add     ax,5
        stosw
        pop     ax

        add     bx,ax                   ;Set initial Pointer
        mov     es:[si+1],bx
                                        
        mov     ax,di
        pop     ds cx bx di si
        push    si di bx cx
Copy_Prog:
        push    ax
        sub     ax,di
        add     ax,bx
        mov     word ptr es:[di+1],ax
        pop     ax        
        mov     di,ax
        repnz   movsb
        pop     cx bx di si
        ret
Encrypt_It:
        push    bx cx di si
        
        call    set_seqp

        mov     ax,cs:[Decryptor_Length+bp]
        inc     ax
        inc     ax
        add     di,ax                    ;DI=start of code to be encrypted
                                         ;CX=Length of code to encrypt
        mov     si,di
        push    es
        pop     ds
Big_Enc_Loop:
        push    cx
        call    Switcher
        mov     cx,cs:[Encrypt_Length+bp]        

   Encrypt_Value:
        push    ax bx cx dx si di        
        mov     si,cs:[Save_SI+bp]
        dec     si
        mov     bl,cs:[si]              ;??
        mov     cs:[Save_SI+bp],si
        lea     si,cs:[Com_Table_2+bp]
        xor     bh,bh
        shl     bx,1
        add     si,bx
        mov     bx,cs:[si]
        add     bx,bp
        mov     word ptr cs:[Next_Command+bp],bx
        pop     di si dx cx bx ax
        call    cs:[Next_Command+bp]
        Loop    Encrypt_Value

        pop     cx
        call    Switcher
        call    Inc_Pointy
        call    set_seqp
        loop    Big_Enc_Loop
        pop     si di cx bx
        ret

Save_SI         dw      0
Next_Command    dw      0
set_seqp:        
        push    si
        lea     si,cs:[Encrypt_Sequence+bp] ;SI=Encrypt_Sequence
        add     si,cs:[Encrypt_Length+bp] ;SI=End of Encrypt Sequence
        mov     cs:[Save_SI+bp],SI
        pop     si
        ret
Command_Table:                  ;8 commands -> 3 bits.
        db      [Xor_It-Xor_It],(Flip_It-Xor_It-1)
        db      [Flip_It-Xor_It],(Rotate_It_1-Flip_It-1)
        db      [Rotate_It_1-Xor_It],(Rotate_It_2-Rotate_It_1-1)
        db      [Rotate_It_2-Xor_It],(Dummy1-Rotate_It_2-1)
        db      [Dummy1-Xor_It],(Dummy2-Dummy1-1)
        db      [Dummy2-Xor_It],(Dummy3-Dummy2-1)
        db      [Dummy3-Xor_It],(Dummy4-Dummy3-1)
        db      [Dummy4-Xor_It],(Dummy5-Dummy4-1)
Com_Table_2:
        dw      [offset Xor_It]
        dw      [offset Flip_It]
        dw      [offset Rotate_It_2]
        dw      [offset Rotate_It_1]
        dw      [offset Dummy5]
        dw      [offset Dummy6]
        dw      [offset Dummy7]
        dw      [offset Dummy8]
Set_Pointy:
        mov     di,1234 ;Pointer to Code
        ret
Set_Size:        
        mov     cx,1234 ;Size
        ret
Switcher:
        xchg    bx,[di]
        ret
Inc_Pointy:
        inc     di
        inc     di
        ret

Loop_Mut:       
        dec     cx
        jz      End_Loop_Mut
    loop_set:
        jmp     _ULTMUTE
    End_Loop_Mut:
        ret
Xor_It: 
        xor     bx,1234
        ret
Flip_It:
        xchg    bh,bl
        ret

Rotate_It_1:
        jmp     before_rot
do_rotate:
        ror     bx,1
        jmp     after_rot
before_rot:  
        push    ax
        call    Ports1
        pop     ax
        jmp     do_rotate
Ports1:
        in      al,21
        or      al,02
        out     21,al
        ret

Ports2:        
        in      al,21
        xor     al,02
        out     21,al
        ret
after_rot:        
        push    ax
        call    ports2
        pop     ax
        ret

Rotate_It_2:
        cli
        jmp     confuzzled1
do_rot2:        
        rol     bx,1
        call    Switch_Int_1_3
        jmp     donerot2
        
confuzzled1:
        call    Switch_Int_1_3
        jmp     do_rot2

Switch_Int_1_3:        
        push    ax ds
        xor     ax,ax
        mov     ds,ax
        jmp     short exch1
        db      0eah
exch1:
        xchg    ax,word ptr ds:[4]
        jmp     short exch2
        db      9ah
exch2:
        xchg    ax,word ptr ds:[0c]
        xchg    ax,word ptr ds:[4]
        pop     ds ax
        ret
donerot2:
        ret

Dummy1:
        jmp     short inc_bx_com              ;Kill Disassemblers
        db      0ea
   Rand_Byte1:        
        db      0ea
   inc_bx_com:
        inc     bx
        ret
Dummy2:
        jmp     short Kill_1
  Rand_Byte2:        
        db      0ea
  Cont_Kill1:
        cli
        xchg    ax,ds:[84]
        xchg    ax,ds:[84]
        sti
        pop     ds ax
   dec_bx_com:        
        dec     bx
        jmp     short quit_Kill1
     Kill_1:
        push    ax ds
        xor     ax,ax
        mov     ds,ax                   ;Anti-Debugger (Kills Int 21)
        jmp     short Cont_Kill1
     Rand_Byte3:
        db      0e8
   quit_Kill1:
        ret
Dummy3:
        add     bx,1234
        push    bx
        call    throw_debugger
   Rand_Byte4:
        db      0e8                             ;Prefetch Trick
   into_throw:
        sub     bx,offset Rand_Byte4
        add     byte ptr [bx+trick_em+1],0ba
   trick_em:        
        jmp     short done_trick
   Rand_Byte5:
        db      0ea
   throw_debugger:
        pop     bx
        jmp     short into_throw
   Rand_Byte6:
        db      0ea
   done_trick:
        sub     byte ptr [bx+trick_em+1],0ba
        pop     bx
        ret
Dummy4:
        sub     bx,1234
        jmp     short Get_IRQ
Rand_Byte7   db      0e8
Kill_IRQ:        
        out   21,al
        xor   al,2
        jmp   short Restore_IRQ
Rand_Byte8   db      0e8        
Rand_Byte9   db      0e8                ;This will kill the keyboard
   Get_IRQ:                             ;IRQ
        push    ax
        in    al,21
        xor   al,2
        jmp    short  Kill_IRQ
Rand_Byte10  db      0e8
Restore_IRQ:        
        out   21,al
        pop     ax
        ret

;The following are used for the encryption algorithm to reverse commands that
;include anti-tracing.
Dummy5: 
        dec     bx
        ret
Dummy6:
        inc     bx
        ret
Dummy7:
        sub     bx,1234
        ret
Dummy8:
        add     bx,1234
        ret
Decryptor_Length        dw      0
Encrypt_Length          dw      0
Encrypt_Sequence        db      30 dup(0)
_END_ULTMUTE:
end _ULTMUTE
