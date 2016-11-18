;RAYGUN2 sound effect
code_seg        segment

        assume cs:code_seg

        org     100h

start:  jmp     raygun2

raygun2 proc    near
        cli                          ;no interrupts
backery:mov     bx,5000              ;start frequency low
        mov     al,10110110b         ;channel 2
        out     43h,al               ;send it
backerx:mov     ax,bx                ;place frequency in (ax)
        out     42h,al               ;send LSB first
        mov     al,ah                ;place MSB in al
        out     42h,al               ;send it next
        in      al,61h               ;lets turn the speaker on
        or      al,00000011b         ;this number will do it
        out     61h,al               ;send it
        mov     cx,50                ;50 is best for (my 80286 12 MHz)
looperx:loop    looperx              ;delay so we can hear sound
        dec     bx                   ;decremnent repeat count
        jnz     backerx              ;if not = 0 go do again
        in      al,61h               ;if were done - turn speaker off
        and     al,11111100b         ;this number will do it
        out     61h,al               ;send it
        jmp     raygun2              ;lock it up in a loop

raygun2         endp
;----------------------------------
code_seg        ends
     end        start
     