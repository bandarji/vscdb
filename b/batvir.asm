; Copy input to output. If exist  FF then ErrorLevel=FF

.model tiny
.code
org 100h

start:
    xor si,si       ; si = 0  ( counter )
    mov di,si       
    inc di      ; di = 1
    mov bx, offset Bytes
;   xor bx,bx       
;   mov bl,48h       
;   inc bh      ; bx = 0148
    xor dx,dx       ; [bx] = 0d 0a 1a   
    dec dx      ; dx = ffff 
    mov ah,6
NextCh:
    mov dl,dh
    int 21h     ; DOS Services  ah=function 06h
                ; direct console input 
                ; if zf=0 al = char, if zf=1 no char
    jz  loc_0134
    cmp al,[bx+2]   ; EOF ?
    je  loc_0134    
    cmp al,dh       ; FF ?
    je  loc_0130    
    mov dl,al       ; if not EOF or not FF write
    int 21h     ; DOS Services  ah=function 06h
                ; direct console output dl=char
    inc si
    cmp dl,[bx]     ; 0D ?
    je  NextCh  
    cmp dl,[bx+di]  ; 0A ?
    je  NextCh      ; if YES - next char    
    xor si,si       ; reset counter & next char 
    jmp short NextCh
loc_0130:
    mov ah,2
    int 21h     ; DOS Services  ah=function 02h
                ;  display char dl
loc_0134:               ; EOF or empty 
    or  si,si       ; Zero ?
    mov dh,al       ; al = char
    jnz Exit        ; Jump if not zero
    mov dl,[bx]
    int 21h     ; DOS Services  ah=function 02h
                ;  display char dl
    mov dl,[bx+di]
    int 21h     ; DOS Services  ah=function 02h
                ;  display char dl
Exit:
    mov al,dh
    mov ah,4Ch      
    int 21h     ; DOS Services  ah=function 4Ch
                ;  terminate with al=return code
Bytes   db   0Dh, 0Ah, 1Ah  ; This 3 bytes write when
            ; echo -"--"- > bug.tmp & copy bug.tmp /a bug.com 
end start
