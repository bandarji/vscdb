TITLE ReadVirus

DATASG Segment Para 'DATA'
handle      dw ?
errcode     db 0
status      db 0
pathname    db 'virus.bin', 0
welcome     db 'Read disk sectors', 0dh, 0ah, '$'
sread_msg   db '*** Sector Read Error ***', 0dh, 0ah, '$'
read_OK_Msg db ' -> Successful', 0dh, 0ah, '$'
open_msg    db '*** File open error  ***', 0dh, 0ah, '$'
write_msg   db '*** File write error ***', 0dh, 0ah, '$'
buffer      db 4608 Dup(?)
datasg ends

Code Segment Para 'Code'
begin proc far
    Assume CS:Code, ES:Datasg

    push ds
        push ax
    mov ax, datasg
    mov ds, ax
    mov es, ax

    lea dx, welcome
    call show_msg

    call read_sector
    cmp errcode, 0      ; create error
        jnz exit                ; exit if error

    call create
    cmp errcode, 0      ; create error
    jnz exit        ; exit if error

    call write
    cmp errcode, 0      ; create error
    jnz exit        ; exit if error

    call close

   exit:
    ret         ; return to DOS
begin endp


;;=========================================================
;; Subroutines
;;=========================================================

;; create file

create proc near
    mov ah, 3Ch
    xor cx, cx
    lea dx, pathname
    int 21h
    jc write_err
    mov handle, ax
    ret

 write_err:
    lea dx, open_msg
    call err_mgr
    ret
create endp


;; write buffer to file

write proc near
    mov ah, 40h     ; request to write
    mov bx, handle      ; select file handle
    mov cx, 4608        ; select 4608 bytes
    lea dx, buffer      ; address of buffer
    int 21h
    jnc okay
    lea dx, write_msg
    call err_mgr
    okay:
    ret
write endp


;; close file

close proc near
    mov ah, 3Eh     ; request close
    mov bx, handle
    int 21h
    ret
close endp


;;=========================================================
;;   Absolute Disk I/O Routines
;;=========================================================

;; Read disk sectors

read_sector proc near
    mov     si, 0004h       ; set counter to 4
   read_again:
    mov ax, 0209h       ; select DOS function
    lea bx, buffer      ; address of buffer to fill
    mov cx, 2940h       ; cylinder 41, sector 64
    mov     dx, 0000h       ; head 0, drive 0
    int     13h         ; Disk  dl=drive #: ah=func a2h
    jnc read_okay

    ;; reset disk system
    xor     ax, ax          ; ax <- 0
    int 13h

    dec     si          ; decrement counter
    jnz     read_again      ; Jump if not zero [NE:ZF=1]

    lea dx, sread_msg
    call err_mgr
    ret

   read_okay:
    lea dx, Read_OK_Msg
    call show_msg

    ret
read_sector endp


;;=========================================================
;; Utility & Error Handling Routines
;;=========================================================

show_msg proc near
    mov ah,9    ; dx contains address of msg terminated by '$'
    int 21h
    ret
show_msg endp


;; display error message

err_mgr proc near
    call show_msg
    mov errcode, 01     ; set error code
    ret
err_mgr endp


code    ends

        end begin
