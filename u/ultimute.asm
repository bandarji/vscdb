;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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

;�����������������������������������������������������������������������������
;ENTRY:
;       CX=Code Length          BX=New_Entry_Point
;       DS:SI=Code              AX=Calling Style
;       ES:DI=Destination               1=Near Call, 2=Far Call, 3=Int Call
;
;RETURN:
;       CX=New Size             ES:DI = Same, now contains encrypted code 
;                                       w/decryptor
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
Get_Our_Offset:
        mov     bp,sp
        mov     bp,ss:[bp]              ;This trick finds our current offset
        sub     bp,offset Offset_Mark   ;from the compiling point, as it
        ret                             ;is usually not constant....
;�����������������������������������������������������������������������������
Init_Rand:
        push    ax ds
        xor     ax,ax
        mov     ds,ax
        mov     ax,ds:[46c]             ;Get seed from timer click at
        pop     ds                      ;0000:046c
        mov     cs:[rand_seed+bp],ax
        pop     ax
        ret
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
rand_seed       dw      0
Base_Reg        db      0
Base_Pointer    db      0
Start_Pos       dw      0
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
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
;�����������������������������������������������������������������������������
Decryptor_Length        dw      0
Encrypt_Length          dw      0
Encrypt_Sequence        db      30 dup(0)
;�����������������������������������������������������������������������������
_END_ULTMUTE:
end _ULTMUTE

����������������������������������������������������������������������������
       The ULTImate MUTation Engine .93� (c) 1993 Black Wolf Enterprises
               pardon the title, had to think of something... }-)
                        Included with Crypt Newsletter 19
����������������������������������������������������������������������������

   ULTIMUTE is a mutation engine written for security-type applications and 
other areas where mutation of executable code is necessary.  For my personal
use, I have implemented it in Black Wolf's File Protection Utilities,
using it to encrypt the code placed onto EXE's and COM's to protect them
from simple modification and/or unauthorized use.  The encryption algorithms
themselves are terribly simple - the main point being that they change
each time and are difficult to trace through.  This engine is written mainly
to keep a "hack one, hack 'em all" approach from working on protected code,
rather than to keep the code secure by a cryptologist's point of view.

Note: Please - this program and it's source have been released as freeware,
      but do NOT use the mutation engine in viruses!  For one thing, the
      decryptor sequence has several repetitive sequences that can be scanned
      for, and for another, that just isn't what it was designed for and
      I would NOT appreciate it.  If you MUST use someone else's mutation
      engine for such, use the TPE or MTE.  I do NOT condone such, however.
      
      Please notify me if you release a program utilizing this engine -
      I'd like to keep track of it if at all possible, and I may have an
      improved version available.

MODIFICATIONS: Any modifications made to this program should be listed 
below the solid line in the source code, as well as directly after this 
paragraph in the docs. Tell what was changed along with the name of the 
programmer and the date the file was changed.  Also - source files should 
be commented where  changed.  If at all possible, report modifications to 
file to the address listed in the documentation for BWFPU21s.

Changes to Date:
        None 08/05/93   -  initial release date (add mod's below)

DISCLAIMER:  The author takes ABSOLUTELY NO RESPONSIBILITY for any damages
resulting from the use/misuse of this program.  The user agrees to hold
the author harmless for any consequences that may occur directly or 
indirectly from the use of this program by utilizing this program/file
in any manner.  Please use the engine with care.


USAGE:  ULTIMUTE must be included as an object file into your program.
To use, put the following lines at the top of your code....
        
        extrn   _ULTMUTE:near, _END_ULTMUTE:byte, Get_Rand:near
        extrn   Init_Rand:near

Then, when you want to use it to encrypt code, use the following registers:

ENTRY:
       CX=Code Length          BX=New_Entry_Point
       DS:SI=Code              AX=Calling Style
       ES:DI=Destination               1=Near Call, 2=Far Call, 3=Int Call

RETURN:
       CX=New Size             ES:DI = Same, now contains encrypted code 
                                       w/decryptor

The code from DS:SI of length CX will be taken and encrypted.  The decryptor
and encrypted code will be placed at ES:DI.  BX should be the location that
the decryptor will be in memory when it receives control - for example, if
it is to be at the beginning of a .COM file, it should be set to 100h.
AX determines how ULTIMUTE will return to your code, if it is set to 1
(the normal case) then it will simply do a RETN - ax=2 will give a RETF
and ax=3 will give an IRET.  When ULTIMUTE is done, CX will equal the new
code size for the decryptor/encrypted code.  All other registers are saved.

As I said before, please use the engine responsibly - and NOT IN VIRUSES!
For Questions/Comments, contact the address listed in BWFPU21s.DOC.

Remember - Freedom of Information brings a great responsibility to us.
           We must fight for that right - but don't abuse it once you get it.

                                        Black Wolf

N ULTIMUTE.OBJ
E 0100 80 0E 00 0C 75 6C 74 69 6D 75 74 65 2E 41 53 4D 
E 0110 DE 88 20 00 00 00 1C 54 75 72 62 6F 20 41 73 73 
E 0120 65 6D 62 6C 65 72 20 20 56 65 72 73 69 6F 6E 20 
E 0130 33 2E 30 9B 88 14 00 40 E9 63 34 05 1B 0C 75 6C 
E 0140 74 69 6D 75 74 65 2E 41 53 4D F0 88 03 00 40 E9 
E 0150 4C 96 02 00 00 68 88 03 00 40 A1 94 96 0C 00 05 
E 0160 5F 54 45 58 54 04 43 4F 44 45 96 98 07 00 48 F9 
E 0170 03 02 03 01 17 96 0C 00 05 5F 44 41 54 41 04 44 
E 0180 41 54 41 C2 98 07 00 48 00 00 04 05 01 0F 96 08 
E 0190 00 06 44 47 52 4F 55 50 8B 9A 06 00 06 FF 02 FF 
E 01A0 01 59 90 0F 00 01 01 08 5F 55 4C 54 4D 55 54 45 
E 01B0 00 00 00 C8 90 0F 00 01 01 08 47 45 54 5F 52 41 
E 01C0 4E 44 62 00 00 91 90 10 00 01 01 09 49 4E 49 54 
E 01D0 5F 52 41 4E 44 51 00 00 4C 90 13 00 01 01 0C 5F 
E 01E0 45 4E 44 5F 55 4C 54 4D 55 54 45 F9 03 00 8E 88 
E 01F0 04 00 40 A2 01 91 A0 CD 03 01 00 00 55 50 53 51 
E 0200 52 06 1E 56 57 E8 3B 00 41 41 2E 89 8E F2 02 2E 
E 0210 89 9E 7F 00 E8 36 00 E8 63 00 E8 84 00 E8 88 01 
E 0220 E8 AC 01 E8 2B 02 5F 5E 1F 07 5A 59 5B 58 2E 03 
E 0230 8E C5 03 41 41 5D 3D 03 00 74 07 3D 02 00 74 01 
E 0240 C3 CB CF 8B EC 8B 6E 00 81 ED 0C 00 C3 50 1E 33 
E 0250 C0 8E D8 A1 6C 04 1F 2E 89 86 7B 00 58 C3 51 52 
E 0260 2E 8B 86 7B 00 B9 AD DE F7 E1 35 DA DA D1 C8 2E 
E 0270 89 86 7B 00 5A 59 C3 00 00 00 00 00 00 E8 DE FF 
E 0280 25 03 00 3C 01 74 F6 2E 88 86 7D 00 E8 CF FF D0 
E 0290 E8 72 07 2E C6 86 7E 00 00 C3 2E C6 86 7E 00 01 
E 02A0 C3 1E 56 0E 1F 8B F5 E8 B4 FF 89 84 04 03 E8 AD 
E 02B0 FF 89 84 7E 03 89 84 BD 03 E8 A2 FF 89 84 9E 03 
E 02C0 89 84 C2 03 E8 97 FF 88 84 5D 03 88 A4 62 03 E8 
E 02D0 8C FF 88 84 7A 03 88 A4 84 03 E8 81 FF 88 84 90 
E 02E0 03 88 A4 94 03 E8 76 FF 88 84 A2 03 88 A4 A9 03 
E 02F0 E8 6B FF 88 84 AA 03 88 A4 B2 03 8A 84 7D 00 80 
E 0300 A4 F6 02 E6 8A E0 D0 E4 D0 E4 D0 E4 08 A4 F6 02 
E 0310 50 8A 84 7E 00 08 84 F6 02 80 A4 ED 02 FE 08 84 
E 0320 ED 02 80 A4 F8 02 FE 08 84 F8 02 80 A4 F9 02 FE 
E 0330 08 84 F9 02 58 80 A4 03 03 FC 08 84 03 03 80 A4 
E 0340 08 03 E4 08 84 08 03 08 A4 08 03 80 A4 0E 03 FC 
E 0350 08 84 0E 03 80 A4 32 03 FC 08 84 32 03 80 A4 5E 
E 0360 03 FC 08 84 5E 03 80 A4 6F 03 FC 08 84 6F 03 80 
E 0370 A4 B7 03 FC 08 84 B7 03 80 A4 B9 03 FC 08 84 B9 
E 0380 03 80 A4 7D 03 FC 80 A4 9D 03 FC 08 84 7D 03 08 
E 0390 84 9D 03 80 A4 BC 03 FC 80 A4 C1 03 FC 08 84 BC 
E 03A0 03 08 84 C1 03 5E 1F C3 06 57 51 0E 07 8D BE C9 
E 03B0 03 E8 AA FE 25 1F 00 D1 E8 D1 E0 40 2E 88 86 C7 
E 03C0 03 91 E8 99 FE 25 07 00 AA E2 F7 59 5F 07 C3 56 
E 03D0 57 53 51 1E 53 57 0E 1F 8D B6 ED 02 A5 A4 AC A5 
E 03E0 A4 AC A5 2E 8A 8E C7 03 32 ED 8D B6 C9 03 51 AC 
E 03F0 56 8A D8 32 FF D1 E3 03 DD 81 C3 CD 02 2E 8B 07 
E 0400 8A CC 32 E4 8D B6 02 03 03 F0 F2 A4 5E 59 E2 DE 
E 0410 8D B6 F5 02 A5 AC A5 AC A5 A5 5E 5B 8B C7 2B C6 
E 0420 2E 89 86 C5 03 50 F7 D0 05 05 00 AB 58 03 D8 26 
E 0430 89 5C 01 8B C7 1F 59 5B 5F 5E 56 57 53 51 50 2B 
E 0440 C7 03 C3 26 89 45 01 58 8B F8 F2 A4 59 5B 5F 5E 
E 0450 C3 53 51 57 56 E8 60 00 2E 8B 86 C5 03 40 40 03 
E 0460 F8 8B F7 06 1F 51 E8 88 00 2E 8B 8E C7 03 50 53 
E 0470 51 52 56 57 2E 8B B6 B8 02 4E 2E 8A 1C 2E 89 B6 
E 0480 B8 02 8D B6 DD 02 32 FF D1 E3 03 F3 2E 8B 1C 03 
E 0490 DD 2E 89 9E BA 02 5F 5E 5A 59 5B 58 2E FF 96 BA 
E 04A0 02 E2 CB 59 E8 4A 00 E8 4A 00 E8 0B 00 E2 B6 5E 
E 04B0 5F 59 5B C3 00 00 00 00 56 8D B6 C9 03 2E 03 B6 
E 04C0 C7 03 2E 89 B6 B8 02 5E C3 00 04 05 02 08 22 2B 
E 04D0 2C 58 05 5E 1B 7A 1F 9A 1A 02 03 07 03 2D 03 0A 
E 04E0 03 B7 03 B9 03 BB 03 C0 03 BF 34 12 C3 B9 34 12 
E 04F0 C3 87 1D C3 47 47 C3 49 74 03 E9 FF FC C3 81 F3 
E 0500 34 12 C3 86 FB C3 EB 06 90 D1 CB EB 16 90 50 E8 
E 0510 03 00 58 EB F4 E4 21 0C 02 E6 21 C3 E4 21 34 02 
E 0520 E6 21 C3 50 E8 F5 FF 58 C3 FA EB 09 90 D1 C3 E8 
E 0530 08 00 EB 21 90 E8 02 00 EB F3 50 1E 33 C0 8E D8 
E 0540 EB 01 EA 87 06 04 00 EB 01 9A 87 06 0C 00 87 06 
E 0550 04 00 1F 58 C3 C3 EB 02 EA EA 43 C3 EB 10 EA FA 
E 0560 87 06 84 00 87 06 84 00 FB 1F 58 4B EB 09 50 1E 
E 0570 33 C0 8E D8 EB E9 E8 C3 81 C3 34 12 53 E8 0D 00 
E 0580 E8 81 EB 84 03 80 87 8F 03 BA EB 05 EA 5B EB F1 
E 0590 EA 80 AF 8F 03 BA 5B C3 81 EB 34 12 EB 09 E8 E6 
E 05A0 21 34 02 EB 0A E8 E8 50 E4 21 34 02 EB F1 E8 E6 
E 05B0 21 58 C3 4B C3 43 C3 81 EB 34 12 C3 81 C3 34 12 
E 05C0 C3 00 00 00 00 96 9C C8 01 C4 11 14 01 01 C4 16 
E 05D0 14 01 01 C4 35 14 01 01 C4 5E 14 01 01 C4 67 14 
E 05E0 01 01 C4 76 14 01 01 C4 B0 14 01 01 C4 B7 14 01 
E 05F0 01 C4 BB 14 01 01 C4 C2 14 01 01 C4 C6 14 01 01 
E 0600 C4 CD 14 01 01 C4 D1 14 01 01 C4 D8 14 01 01 C4 
E 0610 DC 14 01 01 C4 E3 14 01 01 C4 E7 14 01 01 C4 EE 
E 0620 14 01 01 C4 F2 14 01 01 C4 F9 14 01 01 C4 FD 14 
E 0630 01 01 C5 05 14 01 01 C4 4E 14 01 01 C4 8E 14 01 
E 0640 01 C4 9A 14 01 01 C4 A1 14 01 01 C5 01 14 01 01 
E 0650 C5 17 14 01 01 C5 12 14 01 01 C5 1B 14 01 01 C5 
E 0660 1F 14 01 01 C5 24 14 01 01 C5 28 14 01 01 C5 2D 
E 0670 14 01 01 C5 31 14 01 01 C5 36 14 01 01 C5 3B 14 
E 0680 01 01 C5 40 14 01 01 C5 44 14 01 01 C5 49 14 01 
E 0690 01 C5 4D 14 01 01 C5 51 14 01 01 C5 56 14 01 01 
E 06A0 C5 5A 14 01 01 C5 5F 14 01 01 C5 63 14 01 01 C5 
E 06B0 68 14 01 01 C5 6C 14 01 01 C5 71 14 01 01 C5 75 
E 06C0 14 01 01 C5 7A 14 01 01 C5 7E 14 01 01 C5 83 14 
E 06D0 01 01 C5 87 14 01 01 C5 8C 14 01 01 C5 91 14 01 
E 06E0 01 C5 95 14 01 01 C5 99 14 01 01 C5 9E 14 01 01 
E 06F0 C5 A3 14 01 01 C5 A7 14 01 01 C5 B3 14 01 01 C5 
E 0700 C3 14 01 01 C5 DE 14 01 01 C5 EA 14 01 01 C5 F0 
E 0710 14 01 01 C5 FF 14 01 01 C6 0A 14 01 01 C6 16 14 
E 0720 01 01 C6 27 14 01 01 C6 5F 14 01 01 C6 70 14 01 
E 0730 01 C6 7B 14 01 01 C6 84 14 01 01 C6 88 14 01 01 
E 0740 C6 98 14 01 01 C6 A3 14 01 01 C6 BF 14 01 01 C6 
E 0750 C4 14 01 01 C6 DD 14 01 01 C6 DF 14 01 01 C6 E1 
E 0760 14 01 01 C6 E3 14 01 01 C6 E5 14 01 01 C6 E7 14 
E 0770 01 01 C6 E9 14 01 01 C6 EB 14 01 01 C7 8B 14 01 
E 0780 01 C6 C9 14 01 01 C7 87 14 01 01 C7 97 14 01 01 
E 0790 0C A2 0E 00 01 C9 03 30 00 01 00 01 00 00 00 01 
E 07A0 00 50 8A 07 00 C1 10 01 01 00 00 9C 
RCX
06AC
W
Q

