.286
.model  small
.code
         org     0100h

msg_addr equ     offset msg - offset proc_start- 3

         extrn   mime:near,emime:near

                      ; ;H;U;{;;;A;;;F;n;`;N;;;a;`;ѡA;;;;;;ۤv;;s

start:
         mov     ah,09h
         mov     dx,offset dg_msg
         int     21h

         mov     ax,offset emime+000fh ; ;;;{;; + mime+000fh ;;;;;}
                                   ; ;Y;; 0100h ;h;;;;;;;{;; + mime ;;;;;;

         shr     ax,4
         mov     bx,cs
         add     bx,ax

         mov     es,bx                   ; ;] es ;Ψө;ѽX;{;;;M;Q;s;X;;;
                                                ; ;ѽX;{;;;;; 1024 bytes
                                ; ;Y;Φb;`;n;{;;;ɡA;h;;;`;N;;;t;;;O;;;;j;p

         mov     cx,50
dg_l0:
         push    cx
         mov     ah,3ch
         xor     cx,cx
         mov     dx,offset file_name
         int     21h
         xchg    bx,ax

         mov     cx,offset proc_end-offset proc_start    ; ;Q;s;X;{;;;;;;;;

         mov     si,offset proc_start         ; ds:si -> ;n;Q;s;X;;;{;;;;}
         xor     di, di

         push    bx                                      ; ;O;s file handle

         mov     bx, 100h                                ; com ;Ҧ;

         call    mime

         pop     bx

         mov     ah,40h        ; ;;^;; ds:dx = ;ѽX;{;; + ;Q;s;X;{;;;;;;}
         int     21h     ; cx = ;ѽX;{;; + ;Q;s;X;{;;;;;;;סA;;Ȧs;;;;;;

         mov     ah,3eh
         int     21h

         push    cs
         pop     ds                                          ; ;N ds ;];^;;

         mov     bx,offset file_num
         inc     byte ptr ds:[bx+0001h]
         cmp     byte ptr ds:[bx+0001h],'9'
         jbe     dg_l1
         inc     byte ptr ds:[bx]
         mov     byte ptr ds:[bx+0001h],'0'
dg_l1:
         pop     cx
         loop    dg_l0
         mov     ah,4ch
         int     21h

file_name db     '000000'
file_num db      '00.com',00h

dg_msg   db      'generates 50 mime encrypted test files.',0dh,0ah,'$'

proc_start:
         call    $+0003h
         pop     dx
         add     dx,msg_addr
         mov     ah,09h
         int     21h
         int     20h
msg      db      'This is  test file.$'
proc_end:
         end     start
