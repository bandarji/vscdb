                PAGE  59,132
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;;;                                      ;;
                ;;;                 BLINK                        ;;
                ;;;                                      ;;
                ;;;      Created:   11-Mar-91                            ;;
                ;;;      Version:                                ;;
                ;;;      Passes:    9          Analysis Options on: QRS              ;;
                ;;;                                      ;;
                ;;;                                      ;;
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
     = 0000         vector_0h_off   equ 0           ; (0000:0000=56E8h)
     = 0004         vector_1h_off   equ 4           ; (0000:0004=756h)
     = 0006         vector_1h_seg   equ 6           ; (0000:0006=70h)
     = 0024         vector_9h_off   equ 24h         ; (0000:0024=0E987h)
     = 0026         vector_9h_seg   equ 26h         ; (0000:0026=0F000h)
     = 004C         vectr_13h_off   equ 4Ch         ; (0000:004C=0DAh)
     = 004E         vectr_13h_seg   equ 4Eh         ; (0000:004E=974h)
     = 0070         d_0000_0070_e   equ 70h         ; (=0FF53h)
     = 0072         d_0000_0072_e   equ 72h         ; (=0F000h)
     = 0084         d_0000_0084_e   equ 84h         ; (=1460h)
     = 0086         d_0000_0086_e   equ 86h         ; (=22Bh)
     = 0090         d_0000_0090_e   equ 90h         ; (=556h)
     = 0092         d_0000_0092_e   equ 92h         ; (=10C2h)
     = 0413         main_ram_size_  equ 413h            ; (0000:0413=280h)
     = 0611         d_0000_0611_e   equ 611h            ; (=0)
     = 0613         d_0000_0613_e   equ 613h            ; (=0)
     = 0615         d_0000_0615_e   equ 615h            ; (=0C000h)
     = 0617         d_0000_0617_e   equ 617h            ; (=0FC73h)
     = 0619         d_0000_0619_e   equ 619h            ; (=0C0Eh)
     = 061B         d_0000_061B_e   equ 61Bh            ; (=0E802h)
     = 061D         d_0000_061D_e   equ 61Dh            ; (=0Ch)
     = 061F         d_0000_061F_e   equ 61Fh            ; (=4100h)
     = 0621         d_0000_0621_e   equ 621h            ; (=4446h)
     = 0623         d_0000_0623_e   equ 623h            ; (=2020h)
     = 0625         d_0000_0625_e   equ 625h            ; (=2020h)
     = 0627         d_0000_0627_e   equ 627h            ; (=4320h)
     = 0B06         d_0000_0B06_e   equ 0B06h           ; (=0)
     = 0B07         d_0000_0B07_e   equ 0B07h           ; (=0)
     = 004E         video_segment   equ 4Eh         ; (0040:004E=0)
     = 006C         timer_low   equ 6Ch         ; (0040:006C=0B72Ch)
     = 0000         data_0000_e equ 0           ; (=0)
     = 0003         data_0003_e equ 3           ; (=0)
     = 0012         data_0012_e equ 12h         ; (=0)
     = 0020         data_0020_e equ 20h         ; (=0)
     = 0022         data_0022_e equ 22h         ; (=0)
     = 0023         data_0023_e equ 23h         ; (=0)
     = 0024         data_0024_e equ 24h         ; (=0)
     = 0075         data_0075_e equ 75h         ; (=0)
     = 007B         data_007B_e equ 7Bh         ; (=0)
     = 0081         psp_cmd_tail    equ 81h         ; (7A49:0081=0)
     = 0087         data_0087_e equ 87h         ; (=0)
     = 0093         data_0093_e equ 93h         ; (=0)
     = 00A2         data_00A2_e equ 0A2h            ; (=0)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 2

     = 00AA         data_00AA_e equ 0AAh            ; (=0)
     = 0000         d_B800_0000_e   equ 0           ; (=0DAh)
     = 0334         d_B800_0334_e   equ 334h            ; (=6Ch)
  
                seg_a       segment byte public
                        assume  cs:seg_a, ds:seg_a
  
  
                        org 100h
  
                blink       proc    far
  
7A49:0100           start:
7A49:0100  EB 02                jmp short loc_0104
7A49:0102  0090         data_0102   dw  90h         ;  xref 7A49:01A4
7A49:0104           loc_0104:                   ;  xref 7A49:0100
7A49:0104  50                   push    ax
7A49:0105  53                   push    bx
7A49:0106  51                   push    cx
7A49:0107  52                   push    dx
7A49:0108  57                   push    di
7A49:0109  06                   push    es
7A49:010A  1E                   push    ds
7A49:010B  E8 0000              call    sub_010E
  
                blink       endp
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:010B
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_010E    proc    near
7A49:010E  5E                   pop si
7A49:010F  2E: 8A 44 F5             mov al,cs:[si-0Bh]
7A49:0113  3C 00                cmp al,0
7A49:0115  74 11                je  loc_0128        ; Jump if equal
7A49:0117  8B FE                mov di,si
7A49:0119  83 C7 1A             add di,1Ah
7A49:011C  90                   nop
7A49:011D  B9 0AEE              mov cx,0AEEh
  
7A49:0120           locloop_0120:                   ;  xref 7A49:0126
7A49:0120  2E: 30 05                xor cs:[di],al
7A49:0123  FE C0                inc al
7A49:0125  47                   inc di
7A49:0126  E2 F8                loop    locloop_0120        ; Loop if cx > 0
  
7A49:0128           loc_0128:                   ;  xref 7A49:0115
7A49:0128  E8 006C              call    sub_0197
7A49:012B  3D 1992              cmp ax,1992h
7A49:012E  74 27                je  loc_0157        ; Jump if equal
7A49:0130  B4 30                mov ah,30h          ; '0'
7A49:0132  CD 21                int 21h         ; DOS Services  ah=function 30h
                                        ;  get DOS version number ax
7A49:0134  3C 03                cmp al,3
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 3

7A49:0136  72 1F                jb  loc_0157        ; Jump if below
7A49:0138  B8 1200              mov ax,1200h
7A49:013B  CD 2F                int 2Fh         ; Multiplex/Spooler al=func 00h
                                        ;  get installed status
7A49:013D  3C FF                cmp al,0FFh
7A49:013F  75 16                jne loc_0157        ; Jump if not equal
7A49:0141  2E: 81 BC 05E7 5A4D          cmp word ptr cs:[5E7h][si],5A4Dh    ; (=5)
7A49:0148  74 05                je  loc_014F        ; Jump if equal
7A49:014A  83 FC E0             cmp sp,0FFE0h
7A49:014D  72 08                jb  loc_0157        ; Jump if below
7A49:014F           loc_014F:                   ;  xref 7A49:0148
7A49:014F  56                   push    si
7A49:0150  E8 0059              call    sub_01AC
7A49:0153  5E                   pop si
7A49:0154  E8 010E              call    sub_0265
7A49:0157           loc_0157:                   ;  xref 7A49:012E, 0136, 013F, 014D
7A49:0157  1F                   pop ds
7A49:0158  07                   pop es
7A49:0159  5F                   pop di
7A49:015A  5A                   pop dx
7A49:015B  59                   pop cx
7A49:015C  5B                   pop bx
7A49:015D  58                   pop ax
7A49:015E  2E: 81 BC 05E7 5A4D          cmp word ptr cs:[5E7h][si],5A4Dh    ; (=5)
7A49:0165  74 0C                je  loc_0173        ; Jump if equal
7A49:0167  E8 0033              call    sub_019D
7A49:016A  0E                   push    cs
7A49:016B  BB 0100              mov bx,100h
7A49:016E  53                   push    bx
7A49:016F  BE 0000              mov si,0
7A49:0172  CB                   retf                ; Return far
7A49:0173           loc_0173:                   ;  xref 7A49:0165
7A49:0173  FA                   cli             ; Disable interrupts
7A49:0174  BC 7878              mov sp,7878h
7A49:0177  8C CB                mov bx,cs
7A49:0179  81 EB 7878               sub bx,7878h
7A49:017D  8B D3                mov dx,bx
7A49:017F  81 C2 7878               add dx,7878h
7A49:0183  8E D2                mov ss,dx
7A49:0185  81 C3 7878               add bx,7878h
7A49:0189  2E: 89 9C 0087           mov cs:data_0087_e[si],bx   ; (=0)
7A49:018E  FB                   sti             ; Enable interrupts
7A49:018F  BE 0000              mov si,0
7A49:0192  EA 7878:7878     ;*      jmp far ptr l_7878_7878 ;*
                sub_010E    endp
  
7A49:0192  EA 78 78 78 78           db  0EAh, 78h, 78h, 78h, 78h
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0128
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0197    proc    near
7A49:0197  B8 4B9F              mov ax,4B9Fh
7A49:019A  CD 21                int 21h         ; DOS Services  ah=function 4Bh
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 4

                                        ;  run progm @ds:dx, parm @es:bx
7A49:019C  C3                   retn
                sub_0197    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0167
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_019D    proc    near
7A49:019D  2E: C7 06 0100 20CD          mov word ptr cs:[100h],20CDh    ; (=2EBh)
7A49:01A4  2E: C7 06 0102 7878          mov cs:data_0102,7878h  ; (=90h)
7A49:01AB  C3                   retn
                sub_019D    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0150
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_01AC    proc    near
7A49:01AC  B4 51                mov ah,51h          ; 'Q'
7A49:01AE  CD 21                int 21h         ; DOS Services  ah=function 51h
                                        ;  get active PSP segment in bx
7A49:01B0  FA                   cli             ; Disable interrupts
7A49:01B1  4B                   dec bx
7A49:01B2  8E C3                mov es,bx
7A49:01B4  26: 80 3E 0000 5A            cmp byte ptr es:[0],5Ah ; (=0EAh) 'Z'
                        nop             ;*ASM fixup - sign extn byte
7A49:01BA  75 31                jne loc_01ED        ; Jump if not equal
7A49:01BC  26: A1 0003              mov ax,es:data_0003_e   ; (=0)
7A49:01C0  2D 0271              sub ax,271h
7A49:01C3  72 28                jc  loc_01ED        ; Jump if carry Set
7A49:01C5  26: A3 0003              mov es:data_0003_e,ax   ; (=0)
7A49:01C9  26: 81 2E 0012 0271          sub word ptr es:data_0012_e,271h    ; (=0)
7A49:01D0  26: 8E 06 0012           mov es,es:data_0012_e   ; (=0)
7A49:01D5 .BF 0000              mov di,vector_0h_off    ; (0000:0000=0E8h)
7A49:01D8  0E                   push    cs
7A49:01D9  1F                   pop ds
7A49:01DA  83 EE 0E             sub si,0Eh
7A49:01DD  B9 0B99              mov cx,0B99h
7A49:01E0  FC                   cld             ; Clear direction
7A49:01E1  F3/ A4               rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
7A49:01E3  B8 0000              mov ax,0
7A49:01E6  8E D8                mov ds,ax
7A49:01E8  83 2E 0413 09            sub word ptr ds:main_ram_size_,9    ; (0000:0413=280h)
7A49:01ED           loc_01ED:                   ;  xref 7A49:01BA, 01C3
7A49:01ED  FB                   sti             ; Enable interrupts
7A49:01EE  C3                   retn
                sub_01AC    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 5

                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0265
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_01EF    proc    near
7A49:01EF  FA                   cli             ; Disable interrupts
7A49:01F0  B8 0000              mov ax,0
7A49:01F3  8E D8                mov ds,ax
7A49:01F5  8B 1E 0084               mov bx,ds:d_0000_0084_e ; (=1460h)
7A49:01F9  A1 0086              mov ax,ds:d_0000_0086_e ; (=22Bh)
7A49:01FC  26: 89 1E 0611           mov es:d_0000_0611_e,bx ; (=0)
7A49:0201  26: A3 0613              mov es:d_0000_0613_e,ax ; (=0)
7A49:0205  8B 1E 0070               mov bx,ds:d_0000_0070_e ; (=0FF53h)
7A49:0209  A1 0072              mov ax,ds:d_0000_0072_e ; (=0F000h)
7A49:020C  26: 89 1E 0615           mov es:d_0000_0615_e,bx ; (=0C000h)
7A49:0211  26: A3 0617              mov es:d_0000_0617_e,ax ; (=0FC73h)
7A49:0215  8B 1E 004C               mov bx,ds:vectr_13h_off ; (0000:004C=0DAh)
7A49:0219  A1 004E              mov ax,ds:vectr_13h_seg ; (0000:004E=974h)
7A49:021C  26: 89 1E 0619           mov es:d_0000_0619_e,bx ; (=0C0Eh)
7A49:0221  26: A3 061B              mov es:d_0000_061B_e,ax ; (=0E802h)
7A49:0225  8B 1E 0024               mov bx,ds:vector_9h_off ; (0000:0024=0E987h)
7A49:0229  A1 0026              mov ax,ds:vector_9h_seg ; (0000:0026=0F000h)
7A49:022C  26: 89 1E 061D           mov es:d_0000_061D_e,bx ; (=0Ch)
7A49:0231  26: A3 061F              mov es:d_0000_061F_e,ax ; (=4100h)
7A49:0235  C7 06 0084 0630          mov word ptr ds:d_0000_0084_e,630h  ; (=1460h)
7A49:023B  8C 06 0086               mov ds:d_0000_0086_e,es ; (=22Bh)
7A49:023F  26: C6 06 0B06 00            mov byte ptr es:d_0000_0B06_e,0 ; (=0)
7A49:0245  C7 06 0004 0AA9          mov word ptr ds:vector_1h_off,0AA9h ; (0000:0004=756h)
7A49:024B  8C 06 0006               mov ds:vector_1h_seg,es ; (0000:0006=70h)
7A49:024F  C7 06 0070 09A7          mov word ptr ds:d_0000_0070_e,9A7h  ; (=0FF53h)
7A49:0255  8C 06 0072               mov ds:d_0000_0072_e,es ; (=0F000h)
7A49:0259  C7 06 0024 0A9D          mov word ptr ds:vector_9h_off,0A9Dh ; (0000:0024=0E987h)
7A49:025F  8C 06 0026               mov ds:vector_9h_seg,es ; (0000:0026=0F000h)
7A49:0263  FB                   sti             ; Enable interrupts
7A49:0264  C3                   retn
                sub_01EF    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0154
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0265    proc    near
7A49:0265  E8 FF87              call    sub_01EF
7A49:0268  26: 81 3E 061B F000          cmp word ptr es:d_0000_061B_e,0F000h    ; (=0E802h)
7A49:026F  75 13                jne loc_0284        ; Jump if not equal
7A49:0271  26: A1 061B              mov ax,es:d_0000_061B_e ; (=0E802h)
7A49:0275  26: A3 0623              mov es:d_0000_0623_e,ax ; (=2020h)
7A49:0279  26: A1 0619              mov ax,es:d_0000_0619_e ; (=0C0Eh)
7A49:027D  26: A3 0621              mov es:d_0000_0621_e,ax ; (=4446h)
7A49:0281  EB 39                jmp short loc_02BC
7A49:0283  90                   db  90h
7A49:0284           loc_0284:                   ;  xref 7A49:026F
7A49:0284  26: C6 06 0B07 00            mov byte ptr es:d_0000_0B07_e,0 ; (=0)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 6

7A49:028A  26: C7 06 0621 0000          mov word ptr es:d_0000_0621_e,0 ; (=4446h)
7A49:0291  26: C6 06 0B06 19            mov byte ptr es:d_0000_0B06_e,19h   ; (=0)
7A49:0297  9C                   pushf               ; Push flags
7A49:0298  58                   pop ax
7A49:0299  50                   push    ax
7A49:029A  0E                   push    cs
7A49:029B  8B CE                mov cx,si
7A49:029D  81 C1 01A6               add cx,1A6h
7A49:02A1  51                   push    cx
7A49:02A2  0D 0100              or  ax,100h
7A49:02A5  50                   push    ax
7A49:02A6  26: A1 061B              mov ax,es:d_0000_061B_e ; (=0E802h)
7A49:02AA  50                   push    ax
7A49:02AB  26: A1 0619              mov ax,es:d_0000_0619_e ; (=0C0Eh)
7A49:02AF  50                   push    ax
7A49:02B0  B8 0000              mov ax,0
7A49:02B3  CF                   iret                ; Interrupt return
7A49:02B4  26 83 3E 21 06 00            db   26h, 83h, 3Eh, 21h, 06h, 00h
7A49:02BA  74 B5                db   74h,0B5h
7A49:02BC           loc_02BC:                   ;  xref 7A49:0281
7A49:02BC  26: 81 3E 0613 0300          cmp word ptr es:d_0000_0613_e,300h  ; (=0)
7A49:02C3  77 13                ja  loc_02D8        ; Jump if above
7A49:02C5  26: A1 0611              mov ax,es:d_0000_0611_e ; (=0)
7A49:02C9  26: A3 0625              mov es:d_0000_0625_e,ax ; (=2020h)
7A49:02CD  26: A1 0613              mov ax,es:d_0000_0613_e ; (=0)
7A49:02D1  26: A3 0627              mov es:d_0000_0627_e,ax ; (=4320h)
7A49:02D5  EB 38                jmp short loc_ret_030F
7A49:02D7  90                   db  90h
7A49:02D8           loc_02D8:                   ;  xref 7A49:02C3
7A49:02D8  26: C6 06 0B07 01            mov byte ptr es:d_0000_0B07_e,1 ; (=0)
7A49:02DE  26: C7 06 0625 0000          mov word ptr es:d_0000_0625_e,0 ; (=2020h)
7A49:02E5  26: C6 06 0B06 19            mov byte ptr es:d_0000_0B06_e,19h   ; (=0)
7A49:02EB  9C                   pushf               ; Push flags
7A49:02EC  58                   pop ax
7A49:02ED  50                   push    ax
7A49:02EE  0E                   push    cs
7A49:02EF  8B CE                mov cx,si
7A49:02F1  81 C1 01F9               add cx,1F9h
7A49:02F5  51                   push    cx
7A49:02F6  0D 0100              or  ax,100h
7A49:02F9  50                   push    ax
7A49:02FA  26: A1 0613              mov ax,es:d_0000_0613_e ; (=0)
7A49:02FE  50                   push    ax
7A49:02FF  26: A1 0611              mov ax,es:d_0000_0611_e ; (=0)
7A49:0303  50                   push    ax
7A49:0304  B4 0D                mov ah,0Dh
7A49:0306  CF                   iret                ; Interrupt return
7A49:0307  26 83 3E 25 06 00            db   26h, 83h, 3Eh, 25h, 06h, 00h
7A49:030D  74 B6                db   74h,0B6h
  
7A49:030F           loc_ret_030F:                   ;  xref 7A49:02D5
7A49:030F  C3                   retn
                sub_0265    endp
  
7A49:0310  00                   db  0
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 7

                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:075B
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0311    proc    near
7A49:0311  FA                   cli             ; Disable interrupts
7A49:0312  B8 0000              mov ax,0
7A49:0315  8E C0                mov es,ax
7A49:0317  26: A1 0090              mov ax,es:d_0000_0090_e ; (=556h)
7A49:031B  2E: A3 028D              mov word ptr cs:[28Dh],ax   ; (=621h)
7A49:031F  26: A1 0092              mov ax,es:d_0000_0092_e ; (=10C2h)
7A49:0323  2E: A3 028F              mov word ptr cs:[28Fh],ax   ; (=0)
7A49:0327  26: C7 06 0090 0B08          mov word ptr es:d_0000_0090_e,0B08h ; (=556h)
7A49:032E  26: 8C 0E 0092           mov es:d_0000_0092_e,cs ; (=10C2h)
7A49:0333  2E: 80 3E 0210 00            cmp byte ptr cs:[210h],0    ; (=6)
7A49:0339  74 20                je  loc_035B        ; Jump if equal
7A49:033B  26: A1 004C              mov ax,es:vectr_13h_off ; (0000:004C=0DAh)
7A49:033F  2E: A3 0291              mov word ptr cs:[291h],ax   ; (=0C626h)
7A49:0343  26: A1 004E              mov ax,es:vectr_13h_seg ; (0000:004E=974h)
7A49:0347  2E: A3 0293              mov word ptr cs:[293h],ax   ; (=606h)
7A49:034B  2E: A1 0621              mov ax,word ptr cs:[621h]   ; (=983Dh)
7A49:034F  26: A3 004C              mov es:vectr_13h_off,ax ; (0000:004C=0DAh)
7A49:0353  2E: A1 0623              mov ax,word ptr cs:[623h]   ; (=750Bh)
7A49:0357  26: A3 004E              mov es:vectr_13h_seg,ax ; (0000:004E=974h)
7A49:035B           loc_035B:                   ;  xref 7A49:0339
7A49:035B  FB                   sti             ; Enable interrupts
7A49:035C  C3                   retn
                sub_0311    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:07BA
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_035D    proc    near
7A49:035D  FA                   cli             ; Disable interrupts
7A49:035E  B8 0000              mov ax,0
7A49:0361  8E C0                mov es,ax
7A49:0363  2E: A1 028D              mov ax,word ptr cs:[28Dh]   ; (=621h)
7A49:0367  26: A3 0090              mov es:d_0000_0090_e,ax ; (=556h)
7A49:036B  2E: A1 028F              mov ax,word ptr cs:[28Fh]   ; (=0)
7A49:036F  26: A3 0092              mov es:d_0000_0092_e,ax ; (=10C2h)
7A49:0373  2E: 80 3E 0210 00            cmp byte ptr cs:[210h],0    ; (=6)
7A49:0379  74 10                je  loc_038B        ; Jump if equal
7A49:037B  2E: A1 0619              mov ax,word ptr cs:[619h]   ; (=3FA3h)
7A49:037F  26: A3 004C              mov es:vectr_13h_off,ax ; (0000:004C=0DAh)
7A49:0383  2E: A1 061B              mov ax,word ptr cs:[61Bh]   ; (=0E805h)
7A49:0387  26: A3 004E              mov es:vectr_13h_seg,ax ; (0000:004E=974h)
7A49:038B           loc_038B:                   ;  xref 7A49:0379
7A49:038B  FB                   sti             ; Enable interrupts
7A49:038C  C3                   retn
                sub_035D    endp
  
7A49:038D  0008[00]             db  8 dup (0)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 8

  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:075E
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0395    proc    near
7A49:0395  8B F2                mov si,dx
7A49:0397           loc_0397:                   ;  xref 7A49:039B
7A49:0397  46                   inc si
7A49:0398  80 3C 00             cmp byte ptr [si],0
7A49:039B  75 FA                jne loc_0397        ; Jump if not equal
7A49:039D  83 EE 0B             sub si,0Bh
7A49:03A0  0E                   push    cs
7A49:03A1  07                   pop es
7A49:03A2  BF 02E4              mov di,2E4h
7A49:03A5  B8 121E              mov ax,121Eh
7A49:03A8  CD 2F                int 2Fh         ; Multiplex/Spooler al=func 1Eh
7A49:03AA  74 22                jz  loc_03CE        ; Jump if zero
7A49:03AC  BF 02F0              mov di,2F0h
7A49:03AF  4E                   dec si
7A49:03B0  B8 121E              mov ax,121Eh
7A49:03B3  CD 2F                int 2Fh         ; Multiplex/Spooler al=func 1Eh
7A49:03B5  74 1B                jz  loc_03D2        ; Jump if zero
7A49:03B7  83 C6 08             add si,8
7A49:03BA  BF 02DA              mov di,2DAh
7A49:03BD  B8 121E              mov ax,121Eh
7A49:03C0  CD 2F                int 2Fh         ; Multiplex/Spooler al=func 1Eh
7A49:03C2  74 12                jz  loc_03D6        ; Jump if zero
7A49:03C4  BF 02DF              mov di,2DFh
7A49:03C7  B8 121E              mov ax,121Eh
7A49:03CA  CD 2F                int 2Fh         ; Multiplex/Spooler al=func 1Eh
7A49:03CC  74 08                jz  loc_03D6        ; Jump if zero
7A49:03CE           loc_03CE:                   ;  xref 7A49:03AA
7A49:03CE  B8 0000              mov ax,0
7A49:03D1  C3                   retn
7A49:03D2           loc_03D2:                   ;  xref 7A49:03B5
7A49:03D2  B8 0987              mov ax,987h
7A49:03D5  C3                   retn
7A49:03D6           loc_03D6:                   ;  xref 7A49:03C2, 03CC
7A49:03D6  B8 1992              mov ax,1992h
7A49:03D9  C3                   retn
                sub_0395    endp
  
7A49:03DA  2E 45 58 45 00           db  '.EXE', 0
7A49:03DF  2E 43 4F 4D 00           db  '.COM', 0
7A49:03E4  43 4F 4D 4D 41 4E            db  'COMMAND.COM', 0
7A49:03EA  44 2E 43 4F 4D 00
7A49:03F0  41 49 44 53 54 45            db  'AIDSTEST.EXE', 0
7A49:03F6  53 54 2E 45 58 45
7A49:03FC  00
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0769
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 9

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_03FD    proc    near
7A49:03FD  B8 4300              mov ax,4300h
7A49:0400  E8 0326              call    sub_0729
7A49:0403  72 0E                jc  loc_ret_0413        ; Jump if carry Set
7A49:0405  2E: 89 0E 0328           mov word ptr cs:[328h],cx   ; (=6C7h)
7A49:040A  B8 4301              mov ax,4301h
7A49:040D  B9 0000              mov cx,0
7A49:0410  E8 0316              call    sub_0729
  
7A49:0413           loc_ret_0413:                   ;  xref 7A49:0403
7A49:0413  C3                   retn
                sub_03FD    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:07B7
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0414    proc    near
7A49:0414  8B EC                mov bp,sp
7A49:0416  8E 5E 0A             mov ds,[bp+0Ah]
7A49:0419  8B 56 0C             mov dx,[bp+0Ch]
7A49:041C  B8 4301              mov ax,4301h
7A49:041F  2E: 8B 0E 0328           mov cx,word ptr cs:[328h]   ; (=6C7h)
7A49:0424  E8 0302              call    sub_0729
7A49:0427  C3                   retn
                sub_0414    endp
  
7A49:0428  00 00                db  0, 0
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:077A
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_042A    proc    near
7A49:042A  8B D8                mov bx,ax
7A49:042C  B8 5700              mov ax,5700h
7A49:042F  E8 02F7              call    sub_0729
7A49:0432  C3                   retn
                sub_042A    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:07AA
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0433    proc    near
7A49:0433  B8 5701              mov ax,5701h
7A49:0436  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 10

7A49:043B  2E: 8B 0E 0349           mov cx,word ptr cs:[349h]   ; (=293h)
7A49:0440  2E: 8B 16 034B           mov dx,word ptr cs:[34Bh]   ; (=0A12Eh)
7A49:0445  E8 02E1              call    sub_0729
7A49:0448  C3                   retn
                sub_0433    endp
  
7A49:0449  00 00 00 00              db  0, 0, 0, 0
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:06AD
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_044D    proc    near
7A49:044D  2E: C7 06 05F7 1992          mov word ptr cs:[5F7h],1992h    ; (=802Eh)
7A49:0454  2E: A1 0605              mov ax,word ptr cs:[605h]   ; (=0E8D2h)
7A49:0458  2E: A3 0075              mov cs:data_0075_e,ax   ; (=0)
7A49:045C  2E: C7 06 0605 0080          mov word ptr cs:[605h],80h  ; (=0E8D2h)
7A49:0463  2E: A1 0603              mov ax,word ptr cs:[603h]   ; (=33C9h)
7A49:0467  2E: A3 0081              mov cs:psp_cmd_tail,ax  ; (7A49:0081=0)
7A49:046B  2E: A1 0609              mov ax,word ptr cs:[609h]   ; (=3272h)
7A49:046F  2E: A3 0093              mov cs:data_0093_e,ax   ; (=0)
7A49:0473  2E: C7 06 0609 0000          mov word ptr cs:[609h],0    ; (=3272h)
7A49:047A  2E: A1 060B              mov ax,word ptr cs:[60Bh]   ; (=3Dh)
7A49:047E  2E: A3 0087              mov cs:data_0087_e,ax   ; (=0)
7A49:0482  2E: 8B 16 05F1           mov dx,word ptr cs:[5F1h]   ; (=0E800h)
7A49:0487  2E: A1 05F3              mov ax,word ptr cs:[5F3h]   ; (=134h)
7A49:048B  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:048D  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:048F  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0491  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0493  8A CA                mov cl,dl
7A49:0495  D0 E1                shl cl,1            ; Shift w/zeros fill
7A49:0497  D0 E1                shl cl,1            ; Shift w/zeros fill
7A49:0499  D0 E1                shl cl,1            ; Shift w/zeros fill
7A49:049B  D0 E1                shl cl,1            ; Shift w/zeros fill
7A49:049D  0A E1                or  ah,cl
7A49:049F  2E: 8B 16 05FD           mov dx,word ptr cs:[5FDh]   ; (=3E74h)
7A49:04A4  2B C2                sub ax,dx
7A49:04A6  2E: A3 007B              mov cs:data_007B_e,ax   ; (=0)
7A49:04AA  2E: A3 060B              mov word ptr cs:[60Bh],ax   ; (=3Dh)
7A49:04AE  BA 0B16              mov dx,0B16h
7A49:04B1  D1 EA                shr dx,1            ; Shift w/zeros fill
7A49:04B3  D1 EA                shr dx,1            ; Shift w/zeros fill
7A49:04B5  D1 EA                shr dx,1            ; Shift w/zeros fill
7A49:04B7  D1 EA                shr dx,1            ; Shift w/zeros fill
7A49:04B9  42                   inc dx
7A49:04BA  03 C2                add ax,dx
7A49:04BC  2E: A3 0603              mov word ptr cs:[603h],ax   ; (=33C9h)
7A49:04C0  2E: 8B 16 05ED           mov dx,word ptr cs:[5EDh]   ; (=2)
7A49:04C5  2E: A1 05EF              mov ax,word ptr cs:[5EFh]   ; (=0A9BAh)
7A49:04C9  B1 08                mov cl,8
7A49:04CB  D3 E8                shr ax,cl           ; Shift w/zeros fill
7A49:04CD  8A E2                mov ah,dl
7A49:04CF  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:04D1  40                   inc ax
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 11

7A49:04D2  C3                   retn
                sub_044D    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:06E6
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_04D3    proc    near
7A49:04D3  B8 4201              mov ax,4201h
7A49:04D6  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:04DB  33 C9                xor cx,cx           ; Zero register
7A49:04DD  33 D2                xor dx,dx           ; Zero register
7A49:04DF  E8 0247              call    sub_0729
7A49:04E2  B9 0200              mov cx,200h
7A49:04E5  F7 F1                div cx          ; ax,dx rem=dx:ax/reg
7A49:04E7  83 FA 00             cmp dx,0
7A49:04EA  74 01                je  loc_04ED        ; Jump if equal
7A49:04EC  40                   inc ax
7A49:04ED           loc_04ED:                   ;  xref 7A49:04EA
7A49:04ED  2E: A3 05F9              mov word ptr cs:[5F9h],ax   ; (=0AA3Eh)
7A49:04F1  C3                   retn
                sub_04D3    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0588
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_04F2    proc    near
7A49:04F2  B8 0040              mov ax,40h
7A49:04F5  8E C0                mov es,ax
7A49:04F7  26: A0 006C              mov al,es:timer_low     ; (0040:006C=0D6h)
7A49:04FB  3C 7F                cmp al,7Fh
7A49:04FD  77 0F                ja  loc_050E        ; Jump if above
7A49:04FF  2E: C6 06 0023 04            mov byte ptr cs:data_0023_e,4   ; (=0)
7A49:0505  2E: C6 06 04B2 04            mov byte ptr cs:[4B2h],4    ; (=0EAh)
7A49:050B  EB 0D                jmp short loc_051A
7A49:050D  90                   db  90h
7A49:050E           loc_050E:                   ;  xref 7A49:04FD
7A49:050E  2E: C6 06 0023 2C            mov byte ptr cs:data_0023_e,2Ch ; (=0) ','
7A49:0514  2E: C6 06 04B2 2C            mov byte ptr cs:[4B2h],2Ch  ; (=0EAh) ','
7A49:051A           loc_051A:                   ;  xref 7A49:050B
7A49:051A  26: A0 006D              mov al,byte ptr es:timer_low+1  ; (0040:006D=0B7h)
7A49:051E  2E: A2 0024              mov cs:data_0024_e,al   ; (=0)
7A49:0522  2E: A2 04B3              mov byte ptr cs:[4B3h],al   ; (=0D1h)
7A49:0526  26: 32 06 006C           xor al,es:timer_low     ; (0040:006C=0DDh)
7A49:052B  3C 55                cmp al,55h          ; 'U'
7A49:052D  76 3E                jbe loc_056D        ; Jump if below or =
7A49:052F  3C AA                cmp al,0AAh
7A49:0531  76 1D                jbe loc_0550        ; Jump if below or =
7A49:0533  2E: C7 06 0020 002E          mov word ptr cs:data_0020_e,2Eh ; (=0)
7A49:053A  2E: C6 06 0022 05            mov byte ptr cs:data_0022_e,5   ; (=0)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 12

7A49:0540  2E: C7 06 04AF 282E          mov word ptr cs:[4AFh],282Eh    ; (=0B16h)
7A49:0547  2E: C6 06 04B1 04            mov byte ptr cs:[4B1h],4    ; (=0D1h)
7A49:054D  EB 38                jmp short loc_ret_0587
7A49:054F  90                   db  90h
7A49:0550           loc_0550:                   ;  xref 7A49:0531
7A49:0550  2E: C7 06 0020 282E          mov word ptr cs:data_0020_e,282Eh   ; (=0)
7A49:0557  2E: C6 06 0022 05            mov byte ptr cs:data_0022_e,5   ; (=0)
7A49:055D  2E: C7 06 04AF 002E          mov word ptr cs:[4AFh],2Eh  ; (=0B16h)
7A49:0564  2E: C6 06 04B1 04            mov byte ptr cs:[4B1h],4    ; (=0D1h)
7A49:056A  EB 1B                jmp short loc_ret_0587
7A49:056C  90                   db  90h
7A49:056D           loc_056D:                   ;  xref 7A49:052D
7A49:056D  2E: C7 06 0020 302E          mov word ptr cs:data_0020_e,302Eh   ; (=0)
7A49:0574  2E: C6 06 0022 05            mov byte ptr cs:data_0022_e,5   ; (=0)
7A49:057A  2E: C7 06 04AF 302E          mov word ptr cs:[4AFh],302Eh    ; (=0B16h)
7A49:0581  2E: C6 06 04B1 04            mov byte ptr cs:[4B1h],4    ; (=0D1h)
  
7A49:0587           loc_ret_0587:                   ;  xref 7A49:054D, 056A
7A49:0587  C3                   retn
                sub_04F2    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:061C, 06DC
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0588    proc    near
7A49:0588  E8 FF67              call    sub_04F2
7A49:058B  1E                   push    ds
7A49:058C  07                   pop es
7A49:058D .BE 0000              mov si,data_0000_e      ; (=0)
7A49:0590 .BF 0B99              mov di,offset ds:[0B99h]    ; (=2Eh)
7A49:0593  B9 0B98              mov cx,0B98h
7A49:0596  F3/ A4               rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
7A49:0598  B8 0040              mov ax,40h
7A49:059B  8E C0                mov es,ax
7A49:059D           loc_059D:                   ;  xref 7A49:05A3
7A49:059D  26: A0 006C              mov al,es:timer_low     ; (0040:006C=0EEh)
7A49:05A1  0A C0                or  al,al           ; Zero ?
7A49:05A3  74 F8                jz  loc_059D        ; Jump if zero
7A49:05A5  B9 0AEE              mov cx,0AEEh
7A49:05A8 .BE 0BC1              mov si,offset data_0BC1 ; (=0F0h)
7A49:05AB  2E: A2 0B9C              mov cs:data_0B9C,al     ; (=0CFh)
  
7A49:05AF           locloop_05AF:                   ;  xref 7A49:05B5
7A49:05AF  2E: 30 04                xor cs:[si],al
7A49:05B2  FE C0                inc al
7A49:05B4  46                   inc si
7A49:05B5  E2 F8                loop    locloop_05AF        ; Loop if cx > 0
  
7A49:05B7  B4 40                mov ah,40h          ; '@'
7A49:05B9  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:05BE  BA 0B99              mov dx,0B99h
7A49:05C1  B9 0B98              mov cx,0B98h
7A49:05C4  E8 0162              call    sub_0729
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 13

7A49:05C7  C3                   retn
                sub_0588    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:06E9
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_05C8    proc    near
7A49:05C8  B8 4200              mov ax,4200h
7A49:05CB  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:05D0  33 C9                xor cx,cx           ; Zero register
7A49:05D2  33 D2                xor dx,dx           ; Zero register
7A49:05D4  E8 0152              call    sub_0729
7A49:05D7  B4 40                mov ah,40h          ; '@'
7A49:05D9  B9 001C              mov cx,1Ch
7A49:05DC  BA 05F5              mov dx,5F5h
7A49:05DF  E8 0147              call    sub_0729
7A49:05E2  C3                   retn
                sub_05C8    endp
  
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:07A1
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_05E3    proc    near
7A49:05E3  2E: C7 06 05F5 0000          mov word ptr cs:[5F5h],0    ; (=4672h)
7A49:05EA  B4 3F                mov ah,3Fh          ; '?'
7A49:05EC  B9 0002              mov cx,2
7A49:05EF  BA 00A9              mov dx,0A9h
7A49:05F2  E8 0134              call    sub_0729
7A49:05F5  72 46                jc  loc_ret_063D        ; Jump if carry Set
7A49:05F7  2E: 80 3E 00AA 2E            cmp byte ptr cs:data_00AA_e,2Eh ; (=0) '.'
7A49:05FD  74 3E                je  loc_ret_063D        ; Jump if equal
7A49:05FF  B8 4202              mov ax,4202h
7A49:0602  33 C9                xor cx,cx           ; Zero register
7A49:0604  33 D2                xor dx,dx           ; Zero register
7A49:0606  E8 0120              call    sub_0729
7A49:0609  72 32                jc  loc_ret_063D        ; Jump if carry Set
7A49:060B  3D F500              cmp ax,0F500h
7A49:060E  77 2D                ja  loc_ret_063D        ; Jump if above
7A49:0610  3D 0500              cmp ax,500h
7A49:0613  72 28                jb  loc_ret_063D        ; Jump if below
7A49:0615  2D 0003              sub ax,3
7A49:0618  2E: A3 053F              mov word ptr cs:[53Fh],ax   ; (=2E05h)
7A49:061C  E8 FF69              call    sub_0588
7A49:061F  72 1C                jc  loc_ret_063D        ; Jump if carry Set
7A49:0621  3D 0B98              cmp ax,0B98h
7A49:0624  75 17                jne loc_ret_063D        ; Jump if not equal
7A49:0626  B8 4200              mov ax,4200h
7A49:0629  33 C9                xor cx,cx           ; Zero register
7A49:062B  33 D2                xor dx,dx           ; Zero register
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 14

7A49:062D  E8 00F9              call    sub_0729
7A49:0630  72 0B                jc  loc_ret_063D        ; Jump if carry Set
7A49:0632  B4 40                mov ah,40h          ; '@'
7A49:0634  BA 053E              mov dx,53Eh
7A49:0637  B9 0004              mov cx,4
7A49:063A  E8 00EC              call    sub_0729
  
7A49:063D           loc_ret_063D:                   ;  xref 7A49:05F5, 05FD, 0609, 060E
                                        ;            0613, 061F, 0624, 0630
7A49:063D  C3                   retn
                sub_05E3    endp
  
7A49:063E  E9 00 00 2E              db  0E9h, 00h, 00h, 2Eh
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:07A7
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0642    proc    near
7A49:0642  B8 4202              mov ax,4202h
7A49:0645  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:064A  33 C9                xor cx,cx           ; Zero register
7A49:064C  33 D2                xor dx,dx           ; Zero register
7A49:064E  E8 00D8              call    sub_0729
7A49:0651  73 03                jnc loc_0656        ; Jump if carry=0
7A49:0653  E9 0096              jmp loc_ret_06EC
7A49:0656           loc_0656:                   ;  xref 7A49:0651
7A49:0656  2E: 89 16 05ED           mov word ptr cs:[5EDh],dx   ; (=2)
7A49:065B  2E: A3 05EF              mov word ptr cs:[5EFh],ax   ; (=0A9BAh)
7A49:065F  A8 0F                test    al,0Fh
7A49:0661  74 08                jz  loc_066B        ; Jump if zero
7A49:0663  24 F0                and al,0F0h
7A49:0665  05 0010              add ax,10h
7A49:0668  83 D2 00             adc dx,0
7A49:066B           loc_066B:                   ;  xref 7A49:0661
7A49:066B  8B CA                mov cx,dx
7A49:066D  8B D0                mov dx,ax
7A49:066F  B8 4200              mov ax,4200h
7A49:0672  E8 00B4              call    sub_0729
7A49:0675  72 75                jc  loc_ret_06EC        ; Jump if carry Set
7A49:0677  2E: 89 16 05F1           mov word ptr cs:[5F1h],dx   ; (=0E800h)
7A49:067C  2E: A3 05F3              mov word ptr cs:[5F3h],ax   ; (=134h)
7A49:0680  B8 4200              mov ax,4200h
7A49:0683  33 C9                xor cx,cx           ; Zero register
7A49:0685  33 D2                xor dx,dx           ; Zero register
7A49:0687  E8 009F              call    sub_0729
7A49:068A  72 60                jc  loc_ret_06EC        ; Jump if carry Set
7A49:068C  B4 3F                mov ah,3Fh          ; '?'
7A49:068E  B9 001C              mov cx,1Ch
7A49:0691  BA 05F5              mov dx,5F5h
7A49:0694  E8 0092              call    sub_0729
7A49:0697  72 53                jc  loc_ret_06EC        ; Jump if carry Set
7A49:0699  2E: A1 05FF              mov ax,word ptr cs:[5FFh]   ; (=2B8h)
7A49:069D  2E: 09 06 0601           or  word ptr cs:[601h],ax   ; (=3342h)
7A49:06A2  74 48                jz  loc_ret_06EC        ; Jump if zero
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 15

7A49:06A4  2E: 81 3E 05F7 1992          cmp word ptr cs:[5F7h],1992h    ; (=802Eh)
7A49:06AB  74 3F                je  loc_ret_06EC        ; Jump if equal
7A49:06AD  E8 FD9D              call    sub_044D
7A49:06B0  2E: 3B 06 05F9           cmp ax,word ptr cs:[5F9h]   ; (=0AA3Eh)
7A49:06B5  77 35                ja  loc_ret_06EC        ; Jump if above
7A49:06B7  2E: 8B 0E 05F1           mov cx,word ptr cs:[5F1h]   ; (=0E800h)
7A49:06BC  2E: 8B 16 05F3           mov dx,word ptr cs:[5F3h]   ; (=134h)
7A49:06C1  B8 4200              mov ax,4200h
7A49:06C4  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:06C9  E8 005D              call    sub_0729
7A49:06CC  72 1E                jc  loc_ret_06EC        ; Jump if carry Set
7A49:06CE  2E: 3B 16 05F1           cmp dx,word ptr cs:[5F1h]   ; (=0E800h)
7A49:06D3  75 17                jne loc_ret_06EC        ; Jump if not equal
7A49:06D5  2E: 3B 06 05F3           cmp ax,word ptr cs:[5F3h]   ; (=134h)
7A49:06DA  75 10                jne loc_ret_06EC        ; Jump if not equal
7A49:06DC  E8 FEA9              call    sub_0588
7A49:06DF  72 0B                jc  loc_ret_06EC        ; Jump if carry Set
7A49:06E1  3D 0B98              cmp ax,0B98h
7A49:06E4  75 06                jne loc_ret_06EC        ; Jump if not equal
7A49:06E6  E8 FDEA              call    sub_04D3
7A49:06E9  E8 FEDC              call    sub_05C8
  
7A49:06EC           loc_ret_06EC:                   ;  xref 7A49:0653, 0675, 068A, 0697
                                        ;            06A2, 06AB, 06B5, 06CC
                                        ;            06D3, 06DA, 06DF, 06E4
7A49:06EC  C3                   retn
                sub_0642    endp
  
7A49:06ED  003C[00]             db  60 dup (0)
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;
                ;         Called from:   7A49:0400, 0410, 0424, 042F, 0445, 04DF, 05C4
                ;                 05D4, 05DF, 05F2, 0606, 062D, 063A, 064E
                ;                 0672, 0687, 0694, 06C9, 0771, 0793, 07B4
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                sub_0729    proc    near
7A49:0729  9C                   pushf               ; Push flags
7A49:072A  2E: FF 1E 0625           call    dword ptr cs:[625h] ; (=0B817h)
7A49:072F  C3                   retn
                sub_0729    endp
  
7A49:0730  3D 4B9F              cmp ax,4B9Fh
7A49:0733  74 19                je  loc_074E        ; Jump if equal
7A49:0735  3D 4B00              cmp ax,4B00h
7A49:0738  74 18                je  loc_0752        ; Jump if equal
7A49:073A  3D 3D00              cmp ax,3D00h
7A49:073D  74 13                je  loc_0752        ; Jump if equal
7A49:073F  80 FC 43             cmp ah,43h          ; 'C'
7A49:0742  74 0E                je  loc_0752        ; Jump if equal
7A49:0744  80 FC 56             cmp ah,56h          ; 'V'
7A49:0747  74 09                je  loc_0752        ; Jump if equal
7A49:0749  2E: FF 2E 0611           jmp dword ptr cs:[611h] ; (=500h)
7A49:074E           loc_074E:                   ;  xref 7A49:0733
7A49:074E  B8 1992              mov ax,1992h
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 16

7A49:0751  CF                   iret                ; Interrupt return
7A49:0752           loc_0752:                   ;  xref 7A49:0738, 073D, 0742, 0747
7A49:0752  50                   push    ax
7A49:0753  53                   push    bx
7A49:0754  51                   push    cx
7A49:0755  52                   push    dx
7A49:0756  1E                   push    ds
7A49:0757  06                   push    es
7A49:0758  57                   push    di
7A49:0759  56                   push    si
7A49:075A  55                   push    bp
7A49:075B  E8 FBB3              call    sub_0311
7A49:075E  E8 FC34              call    sub_0395
7A49:0761  3D 1992              cmp ax,1992h
7A49:0764  74 03                je  loc_0769        ; Jump if equal
7A49:0766  EB 52                jmp short loc_07BA
7A49:0768  90                   db  90h
7A49:0769           loc_0769:                   ;  xref 7A49:0764
7A49:0769  E8 FC91              call    sub_03FD
7A49:076C  72 4C                jc  loc_07BA        ; Jump if carry Set
7A49:076E  B8 3D02              mov ax,3D02h
7A49:0771  E8 FFB5              call    sub_0729
7A49:0774  72 41                jc  loc_07B7        ; Jump if carry Set
7A49:0776  2E: A3 06CB              mov word ptr cs:[6CBh],ax   ; (=7200h)
7A49:077A  E8 FCAD              call    sub_042A
7A49:077D  72 2B                jc  loc_07AA        ; Jump if carry Set
7A49:077F  2E: 89 0E 0349           mov word ptr cs:[349h],cx   ; (=293h)
7A49:0784  2E: 89 16 034B           mov word ptr cs:[34Bh],dx   ; (=0A12Eh)
7A49:0789  B4 3F                mov ah,3Fh          ; '?'
7A49:078B  0E                   push    cs
7A49:078C  1F                   pop ds
7A49:078D  B9 0002              mov cx,2
7A49:0790  BA 00A2              mov dx,0A2h
7A49:0793  E8 FF93              call    sub_0729
7A49:0796  72 12                jc  loc_07AA        ; Jump if carry Set
7A49:0798  2E: 81 3E 00A2 5A4D          cmp word ptr cs:data_00A2_e,5A4Dh   ; (=0)
7A49:079F  74 06                je  loc_07A7        ; Jump if equal
7A49:07A1  E8 FE3F              call    sub_05E3
7A49:07A4  EB 04                jmp short loc_07AA
7A49:07A6  90                   db  90h
7A49:07A7           loc_07A7:                   ;  xref 7A49:079F
7A49:07A7  E8 FE98              call    sub_0642
7A49:07AA           loc_07AA:                   ;  xref 7A49:077D, 0796, 07A4
7A49:07AA  E8 FC86              call    sub_0433
7A49:07AD  B4 3E                mov ah,3Eh          ; '>'
7A49:07AF  2E: 8B 1E 06CB           mov bx,word ptr cs:[6CBh]   ; (=7200h)
7A49:07B4  E8 FF72              call    sub_0729
7A49:07B7           loc_07B7:                   ;  xref 7A49:0774
7A49:07B7  E8 FC5A              call    sub_0414
7A49:07BA           loc_07BA:                   ;  xref 7A49:0766, 076C
7A49:07BA  E8 FBA0              call    sub_035D
7A49:07BD  5D                   pop bp
7A49:07BE  5E                   pop si
7A49:07BF  5F                   pop di
7A49:07C0  07                   pop es
7A49:07C1  1F                   pop ds
7A49:07C2  5A                   pop dx
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 17

7A49:07C3  59                   pop cx
7A49:07C4  5B                   pop bx
7A49:07C5  58                   pop ax
7A49:07C6  2E: FF 2E 0611           jmp dword ptr cs:[611h] ; (=500h)
7A49:07CB  00 00 20 20              db   00h, 00h, 20h, 20h
7A49:07CF  0008[DC]             db  8 dup (0DCh)
7A49:07D7  20 DC DC DC 20 20            db   20h,0DCh,0DCh,0DCh, 20h, 20h
7A49:07DD  20 20 20 20 DC DC            db   20h, 20h, 20h, 20h,0DCh,0DCh
7A49:07E3  DC                   db  0DCh
7A49:07E4  20                   db  20h
7A49:07E5  0009[20]             db  9 dup (20h)
7A49:07EE  DC DC DC 20              db  0DCh,0DCh,0DCh, 20h
7A49:07F2  0012[20]             db  18 dup (20h)
7A49:0804  DC DC DC 00 20 20            db  0DCh,0DCh,0DCh, 00h, 20h, 20h
7A49:080A  DB DB DB 20 20 DB            db  0DBh,0DBh,0DBh, 20h, 20h,0DBh
7A49:0810  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:0816  20 DC DC DC DC 20            db   20h,0DCh,0DCh,0DCh,0DCh, 20h
7A49:081C  DB DB DB             db  0DBh,0DBh,0DBh
7A49:081F  20                   db  20h
7A49:0820  0009[DC]             db  9 dup (0DCh)
7A49:0829  DB DB DB DC              db  0DBh,0DBh,0DBh,0DCh
7A49:082D  0012[DC]             db  18 dup (0DCh)
7A49:083F  DB DB DB DC DC 00            db  0DBh,0DBh,0DBh,0DCh,0DCh, 00h
7A49:0845  20 20 DB DB DB 20            db   20h, 20h,0DBh,0DBh,0DBh, 20h
7A49:084B  20 DB DB DB 20 DC            db   20h,0DBh,0DBh,0DBh, 20h,0DCh
7A49:0851  DC DC 20 DC DC DC            db  0DCh,0DCh, 20h,0DCh,0DCh,0DCh
7A49:0857  DC DC DB DB DB           db  0DCh,0DCh,0DBh,0DBh,0DBh
7A49:085C  20                   db  20h
7A49:085D  0008[DC]             db  8 dup (0DCh)
7A49:0865  20 DB DB DB 20 DC            db   20h,0DBh,0DBh,0DBh, 20h,0DCh
7A49:086B  0007[DC]             db  7 dup (0DCh)
7A49:0872  20 DC                db   20h,0DCh
7A49:0874  0007[DC]             db  7 dup (0DCh)
7A49:087B  20 DB DB DB 00 20            db   20h,0DBh,0DBh,0DBh, 00h, 20h
7A49:0881  20 DB DB DB DC DC            db   20h,0DBh,0DBh,0DBh,0DCh,0DCh
7A49:0887  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:088D  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:0893  20 DB DB DB 20 DB            db   20h,0DBh,0DBh,0DBh, 20h,0DBh
7A49:0899  DB DB 20 20 DF DF            db  0DBh,0DBh, 20h, 20h,0DFh,0DFh
7A49:089F  DF 20 DB DB DB 20            db  0DFh, 20h,0DBh,0DBh,0DBh, 20h
7A49:08A5  DB DB DB 20 20 DB            db  0DBh,0DBh,0DBh, 20h, 20h,0DBh
7A49:08AB  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:08B1  20 20 DF DF DF 20            db   20h, 20h,0DFh,0DFh,0DFh, 20h
7A49:08B7  DB DB DB 00 20 20            db  0DBh,0DBh,0DBh, 00h, 20h, 20h
7A49:08BD  DB DB DB 20 20 DB            db  0DBh,0DBh,0DBh, 20h, 20h,0DBh
7A49:08C3  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:08C9  20 DB DB DB 20 20            db   20h,0DBh,0DBh,0DBh, 20h, 20h
7A49:08CF  DB DB DB 20 DF DF            db  0DBh,0DBh,0DBh, 20h,0DFh,0DFh
7A49:08D5  DF DF DF DB DB DB            db  0DFh,0DFh,0DFh,0DBh,0DBh,0DBh
7A49:08DB  20 DB DB DB 20 DB            db   20h,0DBh,0DBh,0DBh, 20h,0DBh
7A49:08E1  DB DB DC DC DB DB            db  0DBh,0DBh,0DCh,0DCh,0DBh,0DBh
7A49:08E7  DB 20 DF DF DF DF            db  0DBh, 20h,0DFh,0DFh,0DFh,0DFh
7A49:08ED  DF DB DB DB 20 DB            db  0DFh,0DBh,0DBh,0DBh, 20h,0DBh
7A49:08F3  DB DB 00 20 20 DB            db  0DBh,0DBh, 00h, 20h, 20h,0DBh
7A49:08F9  DB DB 20 20 DB DB            db  0DBh,0DBh, 20h, 20h,0DBh,0DBh
7A49:08FF  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:0905  DB DB DB 20 20 DB            db  0DBh,0DBh,0DBh, 20h, 20h,0DBh
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 18

7A49:090B  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:0911  20 20 DB DB DB 20            db   20h, 20h,0DBh,0DBh,0DBh, 20h
7A49:0917  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:091D  DB 20 20 DC DC DC            db  0DBh, 20h, 20h,0DCh,0DCh,0DCh
7A49:0923  20 DB DB DB 20 20            db   20h,0DBh,0DBh,0DBh, 20h, 20h
7A49:0929  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:092F  DB 00 20 20 DB DB            db  0DBh, 00h, 20h, 20h,0DBh,0DBh
7A49:0935  DB 20 20 DB DB DB            db  0DBh, 20h, 20h,0DBh,0DBh,0DBh
7A49:093B  20 DB DB DB 20 DB            db   20h,0DBh,0DBh,0DBh, 20h,0DBh
7A49:0941  DB DB DC DC DB DB            db  0DBh,0DBh,0DCh,0DCh,0DBh,0DBh
7A49:0947  DB 20 DB DB DB DC            db  0DBh, 20h,0DBh,0DBh,0DBh,0DCh
7A49:094D  DC DB DB DB 20 DB            db  0DCh,0DBh,0DBh,0DBh, 20h,0DBh
7A49:0953  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:0959  DC DC DB DB DB 20            db  0DCh,0DCh,0DBh,0DBh,0DBh, 20h
7A49:095F  DB DB DB DC DC DB            db  0DBh,0DBh,0DBh,0DCh,0DCh,0DBh
7A49:0965  DB DB 20 DB DB DB            db  0DBh,0DBh, 20h,0DBh,0DBh,0DBh
7A49:096B  00 00 DB DB DB DF            db   00h, 00h,0DBh,0DBh,0DBh,0DFh
7A49:0971  002D[DF]             db  45 dup (0DFh)
7A49:099E  20 DB DB DF              db   20h,0DBh,0DBh,0DFh
7A49:09A2  DF DF                db  0DFh,0DFh
7A49:09A4  DFDF         data_09A4   dw  0DFDFh          ;  xref 7A49:0ACE, 0AD3, 0AEE
7A49:09A6  DF           data_09A6   db  0DFh            ;  xref 7A49:0AE8, 0B06, 0B80
7A49:09A7  DF DF DF 00 DB DB            db  0DFh,0DFh,0DFh, 00h,0DBh,0DBh
7A49:09AD  DB 20 DB DB DB DF            db  0DBh, 20h,0DBh,0DBh,0DBh,0DFh
7A49:09B3  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:09B9  DB DF DB DB DB 20            db  0DBh,0DFh,0DBh,0DBh,0DBh, 20h
7A49:09BF  DB DB DB DF DF DF            db  0DBh,0DBh,0DBh,0DFh,0DFh,0DFh
7A49:09C5  DF 20 DB DB DB 20            db  0DFh, 20h,0DBh,0DBh,0DBh, 20h
7A49:09CB  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:09D1  DB 20 20 20 DB DB            db  0DBh, 20h, 20h, 20h,0DBh,0DBh
7A49:09D7  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:09DD  DB DB 20 20 DB DB            db  0DBh,0DBh, 20h, 20h,0DBh,0DBh
7A49:09E3  DB DF DB DB DB 00            db  0DBh,0DFh,0DBh,0DBh,0DBh, 00h
7A49:09E9  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:09EF  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:09F5  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:09FB  DB 20 DB DB DB DF            db  0DBh, 20h,0DBh,0DBh,0DBh,0DFh
7A49:0A01  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:0A07  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:0A0D  DB DB DB 20 DB 20            db  0DBh,0DBh,0DBh, 20h,0DBh, 20h
7A49:0A13  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:0A19  DB DF DB DB DB 20            db  0DBh,0DFh,0DBh,0DBh,0DBh, 20h
7A49:0A1F  DB DB DB DC DB DB            db  0DBh,0DBh,0DBh,0DCh,0DBh,0DBh
7A49:0A25  DB 00 DB DB DB 20            db  0DBh, 00h,0DBh,0DBh,0DBh, 20h
7A49:0A2B  DB DB DB DC DB DB            db  0DBh,0DBh,0DBh,0DCh,0DBh,0DBh
7A49:0A31  DB 20 DB DB DB DC            db  0DBh, 20h,0DBh,0DBh,0DBh,0DCh
7A49:0A37  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:0A3D  DB DC DB DB DB 20            db  0DBh,0DCh,0DBh,0DBh,0DBh, 20h
7A49:0A43  DB DB DB DC DB DB            db  0DBh,0DBh,0DBh,0DCh,0DBh,0DBh
7A49:0A49  DB 20 DB DB DB DC            db  0DBh, 20h,0DBh,0DBh,0DBh,0DCh
7A49:0A4F  DB DC DB DB DB 20            db  0DBh,0DCh,0DBh,0DBh,0DBh, 20h
7A49:0A55  DB DB DB 20 DB DB            db  0DBh,0DBh,0DBh, 20h,0DBh,0DBh
7A49:0A5B  DB 20 DB DB DB 20            db  0DBh, 20h,0DBh,0DBh,0DBh, 20h
7A49:0A61  DB DB DB 00 DC           db  0DBh,0DBh,0DBh, 00h,0DCh
7A49:0A66  000A[DC]             db  10 dup (0DCh)
7A49:0A70  20 DB DB DB 20 DC            db   20h,0DBh,0DBh,0DBh, 20h,0DCh
7A49:0A76  000F[DC]             db  15 dup (0DCh)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 19

7A49:0A85  DB DB DB 20              db  0DBh,0DBh,0DBh, 20h
7A49:0A89  0019[DC]             db  25 dup (0DCh)
7A49:0AA2  00 01 00 00 00 50            db   00h, 01h, 00h, 00h, 00h, 50h
7A49:0AA8  53 51 52 1E 06 57            db   53h, 51h, 52h, 1Eh, 06h, 57h
7A49:0AAE  56 B8 9F 4B CD 21            db   56h,0B8h, 9Fh, 4Bh,0CDh, 21h
7A49:0AB4  3D 92 19 74 0A B8            db   3Dh, 92h, 19h, 74h, 0Ah,0B8h
7A49:0ABA  21 25 BA 30 06 0E            db   21h, 25h,0BAh, 30h, 06h, 0Eh
7A49:0AC0  1F CD 21 2E 80 3E            db   1Fh,0CDh, 21h, 2Eh, 80h, 3Eh
7A49:0AC6  A6 09 00 74 03 E9            db  0A6h, 09h, 00h, 74h, 03h,0E9h
7A49:0ACC  C1 00                db  0C1h, 00h
7A49:0ACE           loc_0ACE:
7A49:0ACE  2E: FF 06 09A4           inc cs:data_09A4        ; (=0DFDFh)
7A49:0AD3  2E: 81 3E 09A4 021C          cmp cs:data_09A4,21Ch   ; (=0DFDFh)
7A49:0ADA  73 03                jae loc_0ADF        ; Jump if above or =
7A49:0ADC  E9 00B0              jmp loc_0B8F
7A49:0ADF           loc_0ADF:                   ;  xref 7A49:0ADA
7A49:0ADF  E4 21                in  al,21h          ; port 21h, 8259-1 int IMR
7A49:0AE1  A8 02                test    al,2
7A49:0AE3  74 03                jz  loc_0AE8        ; Jump if zero
7A49:0AE5  E9 00A7              jmp loc_0B8F
7A49:0AE8           loc_0AE8:                   ;  xref 7A49:0AE3
7A49:0AE8  2E: C6 06 09A6 01            mov cs:data_09A6,1      ; (=0DFh)
7A49:0AEE  2E: C7 06 09A4 0001          mov cs:data_09A4,1      ; (=0DFDFh)
7A49:0AF5  B0 20                mov al,20h          ; ' '
7A49:0AF7  E6 20                out 20h,al          ; port 20h, 8259-1 int command
                                        ;  al = 20h, end of interrupt
7A49:0AF9  FB                   sti             ; Enable interrupts
7A49:0AFA  B4 0F                mov ah,0Fh
7A49:0AFC  CD 10                int 10h         ; Video display   ah=functn 0Fh
                                        ;  get state, al=mode, bh=page
7A49:0AFE  3C 07                cmp al,7
7A49:0B00  74 0D                je  loc_0B0F        ; Jump if equal
7A49:0B02  3C 03                cmp al,3
7A49:0B04  74 0F                je  loc_0B15        ; Jump if equal
7A49:0B06  2E: C6 06 09A6 00            mov cs:data_09A6,0      ; (=0DFh)
7A49:0B0C  EB 78                jmp short loc_0B86
7A49:0B0E  90                   db  90h
7A49:0B0F           loc_0B0F:                   ;  xref 7A49:0B00
7A49:0B0F  BB B000              mov bx,0B000h
7A49:0B12  EB 04                jmp short loc_0B18
7A49:0B14  90                   db  90h
7A49:0B15           loc_0B15:                   ;  xref 7A49:0B04
7A49:0B15  BB B800              mov bx,0B800h
7A49:0B18           loc_0B18:                   ;  xref 7A49:0B12
7A49:0B18  B8 0040              mov ax,40h
7A49:0B1B  8E C0                mov es,ax
7A49:0B1D  26: A1 004E              mov ax,es:video_segment ; (0040:004E=0)
7A49:0B21  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0B23  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0B25  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0B27  D1 E8                shr ax,1            ; Shift w/zeros fill
7A49:0B29  03 C3                add ax,bx
7A49:0B2B  8E D8                mov ds,ax
7A49:0B2D .BE 0000              mov si,d_B800_0000_e    ; (=0DAh)
7A49:0B30  0E                   push    cs
7A49:0B31  07                   pop es
7A49:0B32 .BF 0B98              mov di,offset ds:[0B98h]    ; (=0FFh)
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 20

7A49:0B35  B9 07D0              mov cx,7D0h
7A49:0B38  FC                   cld             ; Clear direction
7A49:0B39  F3/ A5               rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
7A49:0B3B  1E                   push    ds
7A49:0B3C  07                   pop es
7A49:0B3D .BF 0000              mov di,d_B800_0000_e    ; (=0DAh)
7A49:0B40  B8 0000              mov ax,0
7A49:0B43  B9 07D0              mov cx,7D0h
7A49:0B46  F3/ AB               rep stosw           ; Rep when cx >0 Store ax to es:[di]
7A49:0B48 .BF 0334              mov di,d_B800_0334_e    ; (=6Ch)
7A49:0B4B  8B DF                mov bx,di
7A49:0B4D .BE 06CD              mov si,offset ds:[6CDh] ; (=1Eh)
7A49:0B50  0E                   push    cs
7A49:0B51  1F                   pop ds
7A49:0B52           loc_0B52:                   ;  xref 7A49:0B5A, 0B68
7A49:0B52  AC                   lodsb               ; String [si] to al
7A49:0B53  3C 00                cmp al,0
7A49:0B55  74 05                je  loc_0B5C        ; Jump if equal
7A49:0B57  B4 8F                mov ah,8Fh
7A49:0B59  AB                   stosw               ; Store ax to es:[di]
7A49:0B5A  EB F6                jmp short loc_0B52
7A49:0B5C           loc_0B5C:                   ;  xref 7A49:0B55
7A49:0B5C  80 7C 01 01              cmp byte ptr [si+1],1
7A49:0B60  74 08                je  loc_0B6A        ; Jump if equal
7A49:0B62  81 C3 00A0               add bx,0A0h
7A49:0B66  8B FB                mov di,bx
7A49:0B68  EB E8                jmp short loc_0B52
7A49:0B6A           loc_0B6A:                   ;  xref 7A49:0B60
7A49:0B6A  E4 60                in  al,60h          ; port 60h, keybd scan or sw1
7A49:0B6C  8A E0                mov ah,al
7A49:0B6E           loc_0B6E:                   ;  xref 7A49:0B72
7A49:0B6E  E4 60                in  al,60h          ; port 60h, keybd scan or sw1
7A49:0B70  3A C4                cmp al,ah
7A49:0B72  74 FA                je  loc_0B6E        ; Jump if equal
7A49:0B74 .BE 0B98              mov si,offset ds:[0B98h]    ; (=0FFh)
7A49:0B77 .BF 0000              mov di,d_B800_0000_e    ; (=0DAh)
7A49:0B7A  B9 07D0              mov cx,7D0h
7A49:0B7D  FC                   cld             ; Clear direction
7A49:0B7E  F3/ A5               rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
7A49:0B80  2E: C6 06 09A6 00            mov cs:data_09A6,0      ; (=0DFh)
7A49:0B86           loc_0B86:                   ;  xref 7A49:0B0C
7A49:0B86  5E                   pop si
7A49:0B87  5F                   pop di
7A49:0B88  07                   pop es
7A49:0B89  1F                   pop ds
7A49:0B8A  5A                   pop dx
7A49:0B8B  59                   pop cx
7A49:0B8C  5B                   pop bx
7A49:0B8D  58                   pop ax
7A49:0B8E  CF                   iret                ; Interrupt return
7A49:0B8F           loc_0B8F:                   ;  xref 7A49:0ADC, 0AE5
7A49:0B8F  5E                   pop si
7A49:0B90  5F                   pop di
7A49:0B91  07                   pop es
7A49:0B92  1F                   pop ds
7A49:0B93  5A                   pop dx
7A49:0B94  59                   pop cx
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 21

7A49:0B95  5B                   pop bx
7A49:0B96  58                   pop ax
7A49:0B97  2E: FF 2E 0615           jmp dword ptr cs:[615h] ; (=32Dh)
7A49:0B9C  CF           data_0B9C   db  0CFh            ;  xref 7A49:05AB
7A49:0B9D  2E C7 06 A4 09 00            db   2Eh,0C7h, 06h,0A4h, 09h, 00h
7A49:0BA3  00 2E FF 2E 1D 06            db   00h, 2Eh,0FFh, 2Eh, 1Dh, 06h
7A49:0BA9  50 55 8B EC 2E 80            db   50h, 55h, 8Bh,0ECh, 2Eh, 80h
7A49:0BAF  3E 06 0B 19 75 49            db   3Eh, 06h, 0Bh, 19h, 75h, 49h
7A49:0BB5  2E 80 3E 07 0B 01            db   2Eh, 80h, 3Eh, 07h, 0Bh, 01h
7A49:0BBB  74 1E 81 7E 06 00            db   74h, 1Eh, 81h, 7Eh, 06h, 00h
7A49:0BC1  F0           data_0BC1   db  0F0h            ;  xref 7A49:05A8
7A49:0BC2  75 3F 8B 46 04 2E            db   75h, 3Fh, 8Bh, 46h, 04h, 2Eh
7A49:0BC8  A3 21 06 2E C7 06            db  0A3h, 21h, 06h, 2Eh,0C7h, 06h
7A49:0BCE  23 06 00 F0 2E C6            db   23h, 06h, 00h,0F0h, 2Eh,0C6h
7A49:0BD4  06 06 0B 00 EB 24            db   06h, 06h, 0Bh, 00h,0EBh, 24h
7A49:0BDA  90 81 7E 06 00 03            db   90h, 81h, 7Eh, 06h, 00h, 03h
7A49:0BE0  76 08 81 4E 08 00            db   76h, 08h, 81h, 4Eh, 08h, 00h
7A49:0BE6  01 EB 1A 90              db   01h,0EBh, 1Ah, 90h
7A49:0BEA           loc_0BEA:
7A49:0BEA  8B 46 04             mov ax,[bp+4]
7A49:0BED  2E: A3 0625              mov word ptr cs:[625h],ax   ; (=0B817h)
7A49:0BF1  8B 46 06             mov ax,[bp+6]
7A49:0BF4  2E: A3 0627              mov word ptr cs:[627h],ax   ; (=4200h)
7A49:0BF8  2E: C6 06 0B06 00            mov byte ptr cs:[0B06h],0   ; (=2Eh)
7A49:0BFE  81 66 08 FEFF            and word ptr [bp+8],0FEFFh
7A49:0C03           loc_0C03:
7A49:0C03  5D                   pop bp
7A49:0C04  58                   pop ax
7A49:0C05  CF                   iret                ; Interrupt return
7A49:0C06  00 00 F7 C7 0F 00            db   00h, 00h,0F7h,0C7h, 0Fh, 00h
7A49:0C0C  74 05 2E FF 2E 8D            db   74h, 05h, 2Eh,0FFh, 2Eh, 8Dh
7A49:0C12  02 B0 03 CF              db   02h,0B0h, 03h,0CFh
7A49:0C16  0084[00]             db  132 dup (0)
  
                seg_a       ends
  
  
  
                        end start
     blink.lst                      Sourcer Listing v3.07     1-Jan-80   5:42 am   Page 22

  
                ;;;;;;;;;;;;;;;;;;;; CROSS REFERENCE - KEY ENTRY POINTS ;;;;;;;;;;;;;;;;;;;
  
                    seg:off    type    label
                   ---- ----   ----   ---------------
                   7A49:0100   far    start
                   F000:E073   near   system_reset
                   F000:E6F2   near   int_19h_bootup
                   F000:E739   near   int_14h_RS232
                   F000:E82E   near   int_16h_keybd
                   F000:E987   near   int_9_keyboard
                   F000:EC59   near   int_13h_floppy
                   F000:EE03   near   int_2_NMI
                   F000:EF70   near   int_0Eh_floppy
                   F000:EFD2   near   int_17h_printer
                   F000:F065   near   int_10h_video
                   F000:F841   near   int_12h_memsiz
                   F000:F84D   near   int_11h_equip
                   F000:F859   near   int_15h_servics
                   F000:FE6E   near   int_1Ah_RTC
                   F000:FEA5   near   int_8_timer
                   F000:FF23   near   int_unused
                   F000:FF53   near   int_return
                   F000:FF54   near   int_5_prn_scrn
                   F000:FFF0   extn   power_on_reset
  
                 ;;;;;;;;;;;;;;;;;; Interrupt Usage Synopsis ;;;;;;;;;;;;;;;;;;
  
                        Interrupt 10h :  get state, al=mode, bh=page
                        Interrupt 21h :  get DOS version number ax
                        Interrupt 21h :  run progm @ds:dx, parm @es:bx
                        Interrupt 21h :  get active PSP segment in bx
                        Interrupt 2Fh :  get installed status
  
                 ;;;;;;;;;;;;;;;;;; I/O Port Usage Synopsis  ;;;;;;;;;;;;;;;;;;
  
                        Port 20h   : 8259-1 int command
                        Port 21h   : 8259-1 int IMR
                        Port 60h   : keybd scan or sw1
  
