;RAYGUN sound effect .asm listing for VCL - URNST KOUCH

code_seg        segment
        assume  cs:code_seg
        org     100h
start:
        jmp     raygun

raygun  proc    near
        cli                          ;no interrupts
        mov     dx,1800              ;repeat count
        mov     bx,1                 ;start the sound frequency high
        mov     al,10110110b         ;the magic number
        out     43h,al               ;send it to the port
backx:  mov     ax,bx                ;place our starting frequency in (ax)
        out     42h,al               ;send LSB first
        mov     al,ah                ;place MSB in (al)
        out     42h,al               ;send it next
        in      al,61h               ;must turn speaker on
        or      al,00000011b         ;with this number
        out     61h,al               ;send it
        inc     bx                   ;lower the frequency
        mov     cx,60                ;adjusted for best sound (80286 12 MHz)
loopx:  loop    loopx                ;delay loop so we can hear sound
        dec     dx                   ;decrement repeat count
        cmp     dx,0                 ;is repeat count = to 0
        jnz     backx                ;if not do again
        in      al,61h               ;if = 0 turn speaker off
        and     al,11111100b         ;number turns speaker off
        out     61h,al               ;send it
        jmp     raygun               ;lock up the system with the raygun

raygun          endp
;----------------------------------
code_seg        ends
     end        start
begin 775 raygun.exe
M35HP`0(````@````__\````````#`0``/@````$`^U!J<@``````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````ZP&0^KH(![L!`+"VYD.+P^9"BL3F0N1A#`/F84.Y/`#B_DJ#^@!UYN1A
&)/SF8>O3
`
end
begin 775 raygun.com
MZP&0^KH(![L!`+"VYD.+P^9"BL3F0N1A#`/F84.Y/`#B_DJ#^@!UYN1A)/SF
#8>O3
`
end
