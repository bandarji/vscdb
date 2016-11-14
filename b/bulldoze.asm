;BULLDOZER sound effect routine - this is semi-rotten code,
;but the sound effect is entirely rotten - which is the whole point of
;a virus, no? Rather abrasive.

code_seg        segment
        assume  cs:code_seg
        
        org     100h
        
        jmp     bulldoze
                     
  noiz  dw      2031,0008,1809,0008,1612,0008,1355,0015
        dw      1612,0006,1355,0024,0ffffh     ;bulldozer noiz
;-----------------------------------------------------------------------------
bulldoze proc    near
        cli                          ;interrupts off
        lea     si,noiz              ;point (si) to noiz table
noiz2:  cld                          ;must increment forward
        lodsw                        ;load word into ax and increment (si)
        cmp     ax,0ffffh            ;is it ffff - if so end of table
        jz      x_noiz               ;loop from x_noiz
        push    ax                   ;push some noiz onto the stack
        mov     al,10110110b         ;the magic number
        out     43h,al               ;send it
        pop     ax                   ;pop our noiz off the stack
        out     42h,al               ;send LSB first
        mov     al,ah                ;place MSB in al
        out     42h,al               ;send it next
        in      al,61h               ;get value to turn on speaker
        or      al,00000011b         ;OR the gotten value
        out     61h,al               ;now we turn on speaker
        lodsw                        ;load the repeat loop count into (ax)
loop6:  mov     cx,10000             ;first delay count
loop7:  loop    loop7                ;do the delay
        dec     ax                   ;decrement repeat count
        jnz     loop6                ;if not = 0 loop back
        in      al,61h               ;all done
        and     al,11111100b         ;number turns speaker off
        out     61h,al               ;send it
        mov     cx,5000              ;second delay count
loop8:  loop    loop8                ;wait a bit before next noiz
        jmp     short noiz2          ;now go do more noiz
x_noiz:
        jmp     bulldoze             ;lock it up and keep noiz going
        
bulldoze        endp
;-------------------------------------------
code_seg        ends
     end        bulldoze
    