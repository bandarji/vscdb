This is a bit of fun; it allows text to dissolve from screen and can be altered
for a variety of effects.     


        TITLE DISSOLVE.COM

;   Revised from MELT.COM to work with Mono and Color text screens
;   by Colin Stearman[71036,256]

CODE    SEGMENT
        ORG 100H
    ASSUME CS:CODE,DS:CODE,ES:CODE

START:
         MOV    AH,15                   ; GET VIDEO STATE
         INT    10H
     MOV    DX,2000         ; BYTES TO IN 80X25 SCREEN
         MOV    BX,0B000H               ; MONO SCREEN
         CMP    AL,7
         JE     GO
         MOV    BX,0B800H       ; COLOR SCREEN
         CMP    AL,3                    ; COLOR TEXT?
     JA EXIT            ; NOT TEXT MODE
         CMP    AL,1                    ; 80X25 COLOR?
         JA     GO
     SHR    DX,1            ; ONLY 1000 BYTES TO DO
GO:      MOV    ES,BX           ; set es to screen segment
J105:    MOV    CX,DX           ; set bytes in screen
         XOR    BX,BX           ; set flag to say we changed a byte
         XOR    DI,DI                   ; start at offset zero
J10D:
         MOV    AX,ES:[DI]      ; get character and attribute
         CMP    AX,0720H        ; is it a space, nothing to change?
         JZ     J127                    ; yes so do nothing
         MOV    AH,7                    ; clear attribute
         CMP    AL,' '                  ; space with wrong attribute?
         JL     J120            ; is it less than a space?
         DEC    AL                      ; no so decrease 1 towards space
         JMP    SHORT J121
J120:
         INC    AL
J121:
         MOV    ES:[DI],AX
     INC    BX          ; say we changed something
J127:
         INC    DI
         INC    DI
         LOOP   J10D            ; do all bytes in screen
         CMP    BX,00           ; did we change something?
         JNZ    J105            ; yes so do it all over till all spaces
EXIT:
         MOV    AH,4CH          ; return to DOS
         INT    21H 

CODE    ENDS
        END START
        