         TITLE     'X - Keyboard Xtender'
         PAGE 60,132

;        X is a device driver that expands the keyboard buffer
;        to 256 keystrokes (512 bytes)

;        X is Snareware.  Once you try it you'll be hooked!

;        Written by Jeffrey Broome (CIS 76366,1211)
;        created: 1-17-93


X        SEGMENT   PARA

         ASSUME    CS:X, DS:NOTHING    ; assume nothing, know everything!

BUF_SIZE EQU  512                      ; size of buffer in bytes

         ORG  0000H

         DD   -1                       ; next device pointer
         DW   8000H                    ; device attributes
         DW   offset STRATEGY          ; address of strategy routine
         DW   offset INTERRUPT         ; address of interrupt routine
         DB   'KEYB-X  '               ; device name

REQ_PTR  DD   ?                        ; request buffer pointer
         
BUFFER   DB   BUF_SIZE dup (?)         ; new keyboard buffer

STRATEGY PROC FAR
         MOV  CS:WORD PTR [REQ_PTR],BX      ; save pointer to request buffer
         MOV  CS:WORD PTR [REQ_PTR+2],ES
         RET
STRATEGY ENDP

INTERRUPT PROC FAR
         PUSH DS
         PUSH BX
         PUSH AX
         LDS  BX,CS:[REQ_PTR]          ; get pointer to request buffer
         MOV  AH,[BX+2]                ; get command from buffer
         OR   AH,AH                    ; is command = 0?
         JNZ  EXIT

         CALL INIT                     ; call initialize routine

EXIT:    MOV  AX,100h                  ; set done bit in status
         MOV  [BX+3],AX                ; indicate status
         POP  AX                       ; restore stack and return
         POP  BX
         POP  DS
         RET
INTERRUPT ENDP

INIT     PROC NEAR
         PUSH CX                       ; save CX
         PUSH DX                       ; save DX

         MOV  AX,OFFSET BUFFER         ; get address of new keyboard buffer
         MOV  CX,CS                    ; get current code segment
         CMP  CX,1000h                 ; is segment too big?
         JNC  TOOBIG                   ; jump if code segment to high
         SHL  CX,1                     ; convert segment to real address
         SHL  CX,1
         SHL  CX,1
         SHL  CX,1
         ADD  CX,AX                    ; add in offset
         SUB  CX,400h                  ; subtract BIOS memory segment (40h)
         MOV  AX,40h
         MOV  DS,AX                    ; point to BIOS memory segment
         MOV  BX,1Ah
         MOV  [BX],CX                  ; store keyboard head pointer
         MOV  [BX+2],CX                ; store tail pointer
         MOV  BX,80h
         MOV  [BX],CX                  ; store keyboard buffer start
         ADD  CX,BUF_SIZE              ; add size of keyboard buffer
         MOV  [BX+2],CX                ; store keyboard buffer end

         MOV  AX,OFFSET INIT
         MOV  CX,CS                    ; get current code segment
         SHL  CX,1                     ; convert segment to real address
         SHL  CX,1
         SHL  CX,1
         SHL  CX,1
         ADD  CX,AX                    ; add in offset
         ADD  CX,0Fh                   ; round to next segment
         SHR  CX,1                     ; convert back to segment
         SHR  CX,1         
         SHR  CX,1         
         SHR  CX,1         

         MOV  AH,9                     ; print a message function of int 21h
         LEA  DX,X_MSG                 ; get address of message
         PUSH CS
         POP  DS                       ; DS = CS
         INT  21h                      ; call DOS

         LDS  BX,CS:[REQ_PTR]          ; get pointer to request buffer
         MOV  AL,1
         MOV  [BX+0Dh],AL              ; number of units (must be non-zero)

         XOR  AX,AX                    ; AX = 0
         MOV  [BX+0Eh],AX              ; offset of next free byte (0)
         MOV  [BX+10h],CX              ; segment of next free byte

         JMP  SHORT DONE               ; go return to caller


TOOBIG:  MOV  AH,9                     ; print a message function of int 21h
         MOV  DX,OFFSET X_ERR          ; get address of error message
         PUSH CS
         POP  DS                       ; DS = CS
         INT  21h                      ; call DOS

         LDS  BX,CS:[REQ_PTR]          ; get pointer to request buffer
         MOV  AL,0
         MOV  [BX+0Dh],AL              ; number of units=0 means do not load

         XOR  AX,AX                    ; AX = 0
         MOV  [BX+0Eh],AX              ; offset of next free byte (0)

         MOV  CX,CS                    ; segment of free byte = CS
                                       ; this will not load driver
         MOV  [BX+10h],CX              ; segment of next free byte

DONE:    POP  DX                       ; restore DX
         POP  CX                       ; restore CX
         RET
INIT     ENDP 

X_MSG    DB   'Keyboard Xtender Loaded',13,10,'$'
X_ERR    DB   'Keyboard Xtender cannot be loaded!',13,10,'$'


X        ENDS
         END

