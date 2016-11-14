.model tiny
.code
org 100h
  
start:
    jmp short Install

Old_21  dd  0
int_21h_entry   proc    far
    cmp ax,4B9Fh
    je  loc_0111
    jmp cs:Old_21
loc_0111:
    mov ax,1992h
    iret
int_21h_entry   endp
en:
  
Install:
    mov ax,3521h
    int 21h         ; DOS Services  ah=function 35h
                    ;  get intrpt vector al in es:bx
    mov word ptr cs:Old_21,bx
    mov word ptr cs:Old_21+2,es 
    mov ax,2521h
    mov dx,offset int_21h_entry
    int 21h         ; DOS Services  ah=function 25h
                    ;  set intrpt vector al to ds:dx
    mov dx,offset en
    int 27h         ; Terminate & stay resident
end start
begin 775 antiblin.com
MZQ(`````/9]+=`4N_RX"`;B2&<^X(37-(2Z)'@(!+HP&!`&X(26Z!@'-(;H4
#`
