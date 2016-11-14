;Prefetch       -
;       The prefetch is a buffer on the CPU that allows several bytes of
;instructions to be sent to the processor at a time while the processor is
;working on the first few.  This creates a considerable increase in processing
;speed.  It can, however, be used to perform some tricks in assembly that
;"shouldn't" work.  Examine the code below, run it, and then debug through it.

.model tiny
.radix 16
.code
        org 100
start:
        sub     word ptr [changed_jump+1],whats_run-trap ;This changes the
                                                         ;jmp in changed_jump
                                                         ;from jumping to
                                                         ;whats_run to jumping
                                                         ;to trap.

        ;The trick is, the original jump instruction is sent to the CPU
        ;prefetch before the subtraction is executed on the memory location,
        ;so what's in memory at the time of the jump and what actually gets
        ;run are two different things.  This has unlimited uses in tricks
        ;and traps for protecting your code.

changed_jump:
        jmp     whats_run
trap:
        mov     ah,9
        mov     dx,offset message1
        int     21
        ret
whats_run:
        mov     ah,9
        mov     dx,offset message2
        int     21
        ret
message1        db      'This is what the heuristical program runs through,'
                db      ,0dh,0a,'and what one sees if a debugger is used.$'
message2        db      'This is what is actually executed when run.$'
end start
begin 775 adebug.com
M@RX'`0B0ZPF0M`FZ&0'-(<.T";IW`<86-T=6%L;'D@97AE8W5T960@=VAE;B!R=6XN)```
`
end
