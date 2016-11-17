PW_LENGTH       EQU     129                     ;length of password

;This routine allows the user to enter a password to encrypt, and verifies
;it has been entered correctly before proceeeding.
MASTER_PASS     PROC    NEAR
        mov     si,OFFSET ENC_PASS1             ;display this message
        call    DISP_STRING                     ;and fall through to GET_PASS
        call    DECRYP_PASS                     ;get the password
        mov     di,OFFSET PASSVR
        mov     si,OFFSET PASSWD
        mov     cx,PW_LENGTH
        push    di
        push    si
        push    cx
        rep     movsb
        mov     si,OFFSET ENC_PASS2             ;display verify message
        call    VERIFY_PASS                     ;and fall through to GET_PASS
        pop     cx
        pop     si
        pop     di
        repz    cmpsb                           ;are they the same?
        jcxz    MPE
        mov     si,OFFSET BAD_PASS              ;else display this
        call    DISP_STRING
        jmp     MASTER_PASS                     ;and try again
MPE:    ret
MASTER_PASS     ENDP

;This routine allows the user to enter a password to decrypt. Only one try
;is allowed.
DECRYP_PASS:
        mov     si,OFFSET DEC_PASS              ;display this message
VERIFY_PASS:
        call    DISP_STRING                     ;and fall through to GET_PASS

;This routine allows the user to enter the password from the keyboard
GET_PASS        PROC    NEAR
        mov     di,OFFSET PASSWD
GPL:    mov     ah,0
        int     16H                     ;get a character
        cmp     al,0DH                  ;carriage return?
        jz      GPE                     ;yes, done, exit
        cmp     al,8
        jz      GPBS                    ;backspace? go handle it
        cmp     di,OFFSET PASSWD +PW_LENGTH-1  ;end of password buffer?
        jz      GPL                     ;yes, ignore the character
        stosb                           ;anything else, just store it
        jmp     GPL
GPBS:   cmp     di,OFFSET PASSWD        ;don't backspace past 0
        jz      GPL
        dec     di                      ;handle a backspace
        jmp     GPL

GPE:    mov     cx,OFFSET PASSWD + PW_LENGTH
        sub     cx,di                   ;cx=bytes left
        xor     al,al
        rep     stosb                   ;zero rest of password
        mov     ax,0E0DH                ;cr/lf
        int     10H
        mov     ax,0E0AH
        int     10H
        call    HASH_PASS               ;always hash entered password into HPP
        ret
GET_PASS        ENDP

;This routine hashes PASSWD down into the 16 byte HPP for direct use by
;the encryption algorithm.
HASH_PASS       PROC    NEAR
        mov     [RAND_SEED],14E7H       ;pick a seed
        mov     cx,16                   ;clear HPP
        xor     al,al
        mov     di,[HPP]
        rep     stosb
        mov     dx,di
        mov     bl,al
        mov     si,OFFSET PASSWD
HPLP0:  mov     di,[HPP]
HPLP1:  lodsb                           ;get a byte
        or      al,al                   ;go until done
        jz      HPEND
        push    bx
        mov     cl,4
        shr     bl,cl
        mov     cl,bl
        pop     bx
        inc     bl
        rol     al,cl                   ;rotate al by POSITION/16 bits
        xor     [di],al                 ;and xor it with HPP location
        call    GET_RANDOM              ;now get a random number
        xor     [di],ah                 ;and xor with upper part
        inc     di
        cmp     di,dx
        jnz     HPLP1
        jmp     HPLP0
HPEND:  cmp     di,dx
        jz      HPE
        call    GET_RANDOM
        xor     [di],ah
        inc     di
        jmp     SHORT HPEND
HPE:    ret
HASH_PASS       ENDP

ENC_PASS1       DB      'Enter ',0
DEC_PASS        DB      'Passphrase: ',0
ENC_PASS2       DB      'Verify Passphrase: ',0
BAD_PASS        DB      'Verify failed!',13,10,0

