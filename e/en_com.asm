;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Black Wolf's File Protection Utilities 2.1s
;
;EN_COM - Decryption Code for COM file encryption protection in EncrCOM.
;         If modified, convert to data bytes and re-instate program into
;         EncrCOM.ASM, then recompile EncrCOM.
;      
;         Basically, this code is attached to a .COM file and, when executed,
;         decrypts the .COM file and continues execution.
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
        org 100
start:
        call    Get_Offset
Displaced:
        lea     si,[Decrypt_COM+bp]  
        lea     di,[Get_Offset+bp]   
        mov     cx,(Get_Offset-Decrypt_COM)/2
        cld
        jmp     short EncrLoop      ;EncrLoop here isn't really much of an
        db      0ea                 ;encryption, but disassemblers should
                                    ;love it - it flips the code in memory.

EncrLoop:                           ;This part must be stepped through and
        lodsb                       ;re-saved before using the resulting 
        dec     di                  ;.COM as data for EncrCOM, otherwise
        mov     ah,[di]             ;it will simply flip the memory image
        mov     [si-1],ah           ;of the program and crash when run...
        mov     [di],al
        loop    EncrLoop
        cmp     cs:[Counter+bp],4       ;Check if last Anti-debug trick was
        jb      Yip                     ;skipped, if so, mess up user....
        
        sub     word ptr [bp+Decrypt_COM+1],100 ;another prefetch trick...
Decrypt_COM:
        mov     si,100
        mov     di,si
        mov     cx,bp
        shr     cx,1
        inc     cx

Decrypt_Loop:                   ;This could be LOTS better....
        lodsw                   ;Suggestions on the algorithm?
        xor     ax,[Key1+bp]
        add     ax,[Key2+bp]
        ror     ax,1
        xor     ax,[Key3+bp]
        sub     ax,[Key4+bp]
        rol     ax,1
        stosw
        loop    Decrypt_Loop

        mov     byte ptr [bp+RestoreFile],0c3
RestoreFile:
        mov     di,100
        push    di
        lea     si,bp+Storage_Bytes      ;Restore control to COM.
        movsw
        movsw

        mov     ax,[Key1+bp]
        xor     ds:[100h],ax
        mov     ax,[Key2+bp]
        xor     ds:[102h],ax

        xor     ax,ax
        call    KillInt3
        mov     si,ax
        mov     di,ax
        jmp     RestoreFile


Yip:                            ;If you end up here... you messed up.
        push    ax bx cx        
        mov     ax,ss
        mov     bx,sp           ;reverse words in stack - probably end up
        push    ax              ;somewhere in BIOS ROM....
        xchg    bx,ax
        mov     ss,ax
        mov     sp,bx
        pop     ax
        pop     cx bx ax
        mov     byte ptr cs:[Thinker+bp],0c3    ;move a return w/prefetch
Thinker:
        db      0ea,0,0,0ff,0ff ;if they skipped prefetch... reboot cold.

;------------------------------------------------------------------------
Get_Offset:
        pop     bp
        jmp     short confuzzled
        db      0ea
confuzzled:
        push    bp
        sub     bp,offset Displaced
        call    killInt3
        ret

Killint3:                       ;Xor first 4 interrupts with 0d00dh...
        push    ax es ds        ;not nice on debuggers if traced....
        xor     ax,ax
        mov     ds,ax
        mov     es,ax
        xor     si,si
        xor     di,di
        mov     cx,8

killints:        
        lodsw
        xor     ax,0d00dh
        stosw
        inc     word ptr cs:[Counter+bp]
        loop    killints

        pop     ds es ax
        ret

Counter dw      0
;------------------------------------------------------------------------
Storage_Bytes   db      90,90,0cdh,20
Key1            dw      0
Key2            dw      0
Key3            dw      0
Key4            dw      0
;------------------------------------------------------------------------
end_prog:
end start

N EN_COM.COM
E 0100 E8 90 00 8D B6 2B 01 8D BE 93 01 B9 34 00 FC EB 
E 0110 01 EA AC 4F 8A 25 88 64 FF 88 05 E2 F5 2E 83 BE 
E 0120 C0 01 04 72 52 81 AE 2C 01 00 01 BE 00 01 8B FE 
E 0130 8B CD D1 E9 41 AD 33 86 C6 01 03 86 C8 01 D1 C8 
E 0140 33 86 CA 01 2B 86 CC 01 D1 C0 AB E2 E8 C6 86 52 
E 0150 01 C3 BF 00 01 57 8D B6 C2 01 A5 A5 8B 86 C6 01 
E 0160 31 06 00 01 8B 86 C8 01 31 06 02 01 33 C0 E8 2F 
E 0170 00 8B F0 8B F8 EB DB 50 53 51 8C D0 8B DC 50 93 
E 0180 8E D0 8B E3 58 59 5B 58 2E C6 86 8E 01 C3 EA 00 
E 0190 00 FF FF 5D EB 01 EA 55 81 ED 03 01 E8 01 00 C3 
E 01A0 50 06 1E 33 C0 8E D8 8E C0 33 F6 33 FF B9 08 00 
E 01B0 AD 35 0D D0 AB 2E FF 86 C0 01 E2 F4 1F 07 58 C3 
E 01C0 00 00 90 90 CD 20 00 00 00 00 00 00 00 00 
RCX
00CE
W
Q

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Black Wolf's File Protection Utilities 2.1s
;
;
;EN_EXE - Decryption Code for EXE file encryption protection in EncrEXE.
;         If modified, convert to data bytes and re-instate program into
;         EncrEXE.ASM, then recompile EncrEXE.
;      
;         Basically, this code is attached to a .EXE file and, when executed,
;         decrypts the .EXE file and continues execution.
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modifications:
;       None as of 08/05/93 - Initial Release.

.model tiny
.radix 16
.code
        org 100
start:
;        push    es ds
;                       ;These commands are placed _before_ the ultimute
;        push    cs cs  ;encryption.
;        pop     es ds
        call    Get_Offset

Displaced:
        pop     ax        
        push    ax

Hackit:
        mov     word ptr cs:[ES_Store+bp],ax    ;save ES
        mov     word ptr cs:[tricky+bp],ax      ;Trash next command if
Tricky:                                         ;debugged
        xor     bx,bx
        add     ax,10
        mov     cx,cs
        sub     cx,ax
        shl     cx,1
        adc     bx,0
        jmp     nextset
        db      0ea             ;confuse disassemblers
lastset:
        shl     bx,1
        shl     cx,1
        adc     bx,0
        jmp     short doneset        
        
        db      0ff             ;same as above
nextset:        
        shl     bx,1
        shl     cx,1
        adc     bx,0
        jmp     short lastset
        db      9a

doneset:
        mov     es,ax
        mov     ds,ax
        xor     si,si
        xor     di,di
        call    Waiter
        
        jmp     short Decrypt_Loop
        db      0ea
Decrypt_Loop:                           ;Decrypt EXE - needs work on alg.
        lodsw
        xor     ax,[Key1+bp]
        add     ax,[Key2+bp]
        ror     ax,1
        xor     ax,[Key3+bp]
        sub     ax,[Key4+bp]
        rol     ax,1
        
        stosw
        
        push    bx cx
        mov     ax,si
        mov     bx,ax        
        mov     cl,4
        shr     ax,cl
        shl     ax,cl
        cmp     ax,bx
        jne     DoneReset
        sub     si,10
        sub     di,10
        push    ds
        pop     ax
        inc     ax
        mov     ds,ax
        mov     es,ax
DoneReset:        
        pop     cx bx
        loop    Decrypt_Loop
        
        cmp     bx,0
        je      Int_00
        dec     bx
        jmp     Decrypt_Loop
        call    Waiter

Int_00:                 ;Div by Zero Anti-Debug trick....
        push    ax ds
        xor     ax,ax
        mov     ds,ax
        lea     ax,[Restorat+bp]
        xchg    ax,ds:[0]
        push    ax
        mov     ax,cs
        xchg    ax,ds:[2]
        push    ax
        
        xor     cx,cx
        mov     word ptr cs:[divideit+bp],9090
divideit:
        div     cx
       
        pop     ax
        xchg    ax,ds:[2]
        pop     ax
        xchg    ax,ds:[0]
        pop     ds ax

Restore_EXE:        
        pop     es ds        
        
        mov     ax,word ptr cs:[ES_Store+bp]
        add     ax,10
        add     ax,word ptr cs:[Old_SS+bp]
        
        cli
        mov     ss,ax
        mov     sp,word ptr cs:[Old_SP+bp]
        sti

        xor     ax,ax
        mov     si,ax
        mov     di,ax
        jmp     dword ptr cs:[Old_IP+bp]        ;jump back to host file


Restorat:
        mov     ax,word ptr cs:[ES_Store+bp]
        add     ax,10
        add     word ptr cs:[Old_CS+bp],ax
        call    Undo_Relocation
        iret
;------------------------------------------------------------------------
Undo_Relocation:                      ;Add old ES+10 to all addresses in
                                      ;Relocation table for program to run.
        push    ax bx cx dx es ds si di bp
        mov     bx,bp

        mov     bp,word ptr cs:[Header+18+bx] ;Get offset of first relocation item
        mov     cx,word ptr cs:[Header+6+bx]
        or      cx,cx
        jz      Done_UnReloc
UnReloc_Loop:
        add     bp,bx
        lds     si,dword ptr cs:[Header+bp]
        sub     bp,bx
UnDo_Reloc:
        mov     ax,ds
        add     ax,word ptr cs:[ES_Store+bx]       ;adjust DS
        add     ax,10
        mov     ds,ax

        mov     ax,word ptr cs:[ES_Store+bx]
        add     ax,10
        add     word ptr ds:[si],ax
        add     bp,4
        call    Waiter
        loop    UnReloc_Loop

Done_UnReloc:
        pop     bp di si ds es dx cx bx ax
        ret                             
;------------------------------------------------------------------------
Get_Offset:
        pop     bp
        jmp     short confuzzled
        db      0ea
confuzzled:
        push    bp
        sub     bp,offset Displaced
        ret

Done_Waiter:
        ret
Waiter:
        jmp     W1
        db      0ea
W3:
        call    DoKB
        jmp     W4      ;Confuze people.......
W2:
        call    DoKB
        jmp     W3
w4:
        or      bp,bp
        jz      w2
        pop     bp
        jmp     Done_Waiter
W1:
        push    bp
        xor     bp,bp
        jmp     W2

        db      'Protection by Black Wolf'

DoKB:        
        in      al,21
        xor     al,2
        out     21,al
        inc      bp
        ret
;------------------------------------------------------------------------
ES_Store        dw      0
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
end_prog:
Header:
end start

N EN_EXE.COM
E 0100 E8 2D 01 58 50 2E 89 86 76 02 2E 89 86 0F 01 33 
E 0110 DB 05 10 00 8C C9 2B C8 D1 E1 83 D3 00 EB 0C 90 
E 0120 EA D1 E3 D1 E1 83 D3 00 EB 0B FF D1 E3 D1 E1 83 
E 0130 D3 00 EB ED 9A 8E C0 8E D8 33 F6 33 FF E8 FB 00 
E 0140 EB 01 EA AD 33 86 80 02 03 86 82 02 D1 C8 33 86 
E 0150 84 02 2B 86 86 02 D1 C0 AB 53 51 8B C6 8B D8 B1 
E 0160 04 D3 E8 D3 E0 3B C3 75 0D 83 EE 10 83 EF 10 1E 
E 0170 58 40 8E D8 8E C0 59 5B E2 C9 83 FB 00 74 06 4B 
E 0180 EB C1 E8 B6 00 50 1E 33 C0 8E D8 8D 86 D5 01 87 
E 0190 06 00 00 50 8C C8 87 06 02 00 50 33 C9 2E C7 86 
E 01A0 A4 01 90 90 F7 F1 58 87 06 02 00 58 87 06 00 00 
E 01B0 1F 58 07 1F 2E 8B 86 76 02 05 10 00 2E 03 86 7C 
E 01C0 02 FA 8E D0 2E 8B A6 7E 02 FB 33 C0 8B F0 8B F8 
E 01D0 2E FF AE 78 02 2E 8B 86 76 02 05 10 00 2E 01 86 
E 01E0 7A 02 E8 01 00 CF 50 53 51 52 06 1E 56 57 55 8B 
E 01F0 DD 2E 8B AF A0 02 2E 8B 8F 8E 02 0B C9 74 27 03 
E 0200 EB 2E C5 B6 88 02 2B EB 8C D8 2E 03 87 76 02 05 
E 0210 10 00 8E D8 2E 8B 87 76 02 05 10 00 01 04 83 C5 
E 0220 04 E8 17 00 E2 D9 5D 5F 5E 1F 07 5A 59 5B 58 C3 
E 0230 5D EB 01 EA 55 81 ED 03 01 C3 C3 EB 14 90 EA E8 
E 0240 2C 00 EB 06 90 E8 26 00 EB F5 0B ED 74 F7 5D EB 
E 0250 E9 55 33 ED EB EF 50 72 6F 74 65 63 74 69 6F 6E 
E 0260 20 62 79 20 42 6C 61 63 6B 20 57 6F 6C 66 E4 21 
E 0270 34 02 E6 21 45 C3 00 00 00 00 F0 FF F0 FF 00 00 
E 0280 00 00 00 00 00 00 00 00 
RCX
0188
W
Q
