; File: JOSHEXT.BIN
; File Type: BIN
; Processor: 8086/88
; Range: 06000h to 071ffh
; Subroutines:    7
 
k00021          EQU     00021H 
key_status1     EQU     00017H                  ;<00417> keyboard status byte 1
dsk_motor_stat  EQU     0003FH                  ;<0043f> disk motor status
.RADIX 16
 
dseg0000        SEGMENT at 00000 
dseg0000        ENDS
 
dseg0040        SEGMENT at 00040 
dseg0040        ENDS
 
sseg            SEGMENT para stack 
sseg            ENDS
 
dsegb800        SEGMENT at 0B800 
dsegb800        ENDS
 
                ORG     00H
sseg            SEGMENT para stack 
                ASSUME CS:sseg
o06000          PROC NEAR
;
;
;
;
                CLI                             ;06000 Turn OFF Interrupts
                PUSH    CS                      ;06001 
                POP     DS                      ;06002 ds=cs
                MOV     AX,SEG dseg0000 ;abs    ;06003 >>xref=<00000><<
                                                ;    ;AT 00000
;
                MOV     ES,AX                   ;06006 es=0
                ASSUME DS:sseg
                MOV     BYTE PTR DS:d0628b,00   ;06008 zero out data areas
                MOV     BYTE PTR DS:d0628c,00   ;0600D 
                MOV     BYTE PTR DS:d06292,00   ;06012 
                MOV     BYTE PTR DS:d06293,00   ;06017 
                MOV     BYTE PTR DS:d0628d,00   ;0601C 
                MOV     BYTE PTR DS:d062b0,00   ;06021 
                MOV     AX,0008H                ;06026 
                MOV     BX,0004H                ;06029 
                MUL     BX                      ;0602C 
                MOV     SI,AX                   ;0602E 
                MOV     AX,01CEH                ;06030 
                CMP     AX,WORD PTR ES:[SI]     ;06033 
                JNE     b06043                  ;06036 Jump not equal(ZF=0)
                MOV     AX,CS                   ;06038 
                CMP     AX,WORD PTR ES:[SI+02]  ;0603A 
                JNE     b06043                  ;0603E Jump not equal(ZF=0)
                JMP     SHORT b0605e            ;06040 
                NOP                             ;06042 
b06043:         MOV     DI,027FH                ;06043 
                MOV     AX,WORD PTR ES:[SI]     ;06046 
                MOV     WORD PTR [DI],AX        ;06049 
                MOV     AX,WORD PTR ES:[SI+02]  ;0604B 
                MOV     WORD PTR [DI+02],AX     ;0604F 
                MOV     AX,01CEH                ;06052 
                MOV     WORD PTR ES:[SI],AX     ;06055 
                MOV     AX,CS                   ;06058 
                MOV     WORD PTR ES:[SI+02],AX  ;0605A 
b0605e:         MOV     AX,0009H                ;0605E 
                MOV     BX,0004H                ;06061 
                MUL     BX                      ;06064 
                MOV     SI,AX                   ;06066 
                MOV     AX,010AH                ;06068 
                CMP     AX,WORD PTR ES:[SI]     ;0606B 
                JNE     b0607b                  ;0606E Jump not equal(ZF=0)
                MOV     AX,CS                   ;06070 
                CMP     AX,WORD PTR ES:[SI+02]  ;06072 
                JNE     b0607b                  ;06076 Jump not equal(ZF=0)
                JMP     SHORT b06096            ;06078 
                NOP                             ;0607A 
b0607b:         MOV     DI,01CAH                ;0607B 
                MOV     AX,WORD PTR ES:[SI]     ;0607E 
                MOV     WORD PTR [DI],AX        ;06081 
                MOV     AX,WORD PTR ES:[SI+02]  ;06083 
                MOV     WORD PTR [DI+02],AX     ;06087 
                MOV     AX,010AH                ;0608A 
                MOV     WORD PTR ES:[SI],AX     ;0608D 
                MOV     AX,CS                   ;06090 
                MOV     WORD PTR ES:[SI+02],AX  ;06092 
b06096:         MOV     AX,0013H                ;06096 
                MOV     BX,0004H                ;06099 
                MUL     BX                      ;0609C 
                MOV     SI,AX                   ;0609E 
                MOV     AX,04FAH                ;060A0 
                CMP     AX,WORD PTR ES:[SI]     ;060A3 
                JNE     b060b3                  ;060A6 Jump not equal(ZF=0)
                MOV     AX,CS                   ;060A8 
                CMP     AX,WORD PTR ES:[SI+02]  ;060AA 
                JNE     b060b3                  ;060AE Jump not equal(ZF=0)
                JMP     SHORT b060ce            ;060B0 
                NOP                             ;060B2 
b060b3:         MOV     DI,07ACH                ;060B3 
                MOV     AX,WORD PTR ES:[SI]     ;060B6 
                MOV     WORD PTR [DI],AX        ;060B9 
                MOV     AX,WORD PTR ES:[SI+02]  ;060BB 
                MOV     WORD PTR [DI+02],AX     ;060BF 
                MOV     AX,04FAH                ;060C2 
                MOV     WORD PTR ES:[SI],AX     ;060C5 
                MOV     AX,CS                   ;060C8 
                MOV     WORD PTR ES:[SI+02],AX  ;060CA 
b060ce:         MOV     AX,SEG dseg0000 ;abs    ;060CE >>xref=<00000><<
                                                ;    ;AT 00000
;
                MOV     DS,AX                   ;060D1 
                MOV     SI,0000H                ;060D3 
                PUSH    CS                      ;060D6 
;
                POP     ES                      ;060D7 
                MOV     DI,1000H                ;060D8 
                MOV     CX,0400H                ;060DB 
                CLD                             ;060DE Forward String Opers
                REP     MOVSB                   ;060DF Mov DS:[SI]->ES:[DI]
                PUSH    CS                      ;060E1 
;
                POP     ES                      ;060E2 
                MOV     DI,0287H                ;060E3 
                MOV     CX,0004H                ;060E6 
                MOV     AL,01                   ;060E9 
                REP     STOSB                   ;060EB Store AL at ES:[DI]
                PUSH    CS                      ;060ED 
;
                POP     DS                      ;060EE 
                MOV     SI,0E00H                ;060EF 
                MOV     AX,SEG dseg0000 ;abs    ;060F2 >>xref=<00000><<
                                                ;    ;AT 00000
;
                MOV     ES,AX                   ;060F5 
                MOV     DI,7C00H                ;060F7 
                MOV     CX,0200H                ;060FA 
                CLD                             ;060FD Forward String Opers
                REP     MOVSB                   ;060FE Mov DS:[SI]->ES:[DI]
                MOV     AX,0000H                ;06100 
                PUSH    AX                      ;06103 
                MOV     AX,7C00H                ;06104 
                PUSH    AX                      ;06107 
                STI                             ;06108 Turn ON Interrupts
;
                RETF                            ;06109 
;-----------------------------------------------------
                PUSHF                           ;0610A Push flags on Stack
                PUSH    AX                      ;0610B 
                PUSH    BP                      ;0610C Save Argument Pointr
                PUSH    BX                      ;0610D 
                PUSH    CX                      ;0610E 
                PUSH    DI                      ;0610F 
                PUSH    DS                      ;06110 
                PUSH    DX                      ;06111 
                PUSH    ES                      ;06112 
                PUSH    SI                      ;06113 
                PUSH    CS                      ;06114 
                POP     DS                      ;06115 
                IN      AL,60H                  ;06116 060-067:8042 keyboar-
                                                ;     d
                MOV     BYTE PTR DS:d06294,AL   ;06118 
                CMP     BYTE PTR DS:d06293,00   ;0611B 
                JE      b06125                  ;06120 Jump if equal (ZF=1)
                JMP     NEAR PTR m061b0         ;06122 
b06125:         MOV     AX,SEG dseg0040 ;abs    ;06125 >>xref=<00400><<
                                                ;    ;AT 00040
;
                MOV     ES,AX                   ;06128 
                ASSUME ES:dseg0040
                MOV     AL,BYTE PTR ES:key_status1 ;
                                                ;0612A >>xref=<00417><<
                                                ;    ;keyboard status byte 
                                                ;     1
                AND     AL,0CH                  ;0612E 
                CMP     AL,0CH                  ;06130 
                JNE     b0613f                  ;06132 Jump not equal(ZF=0)
                PUSH    CS                      ;06134 
                POP     DS                      ;06135 
                MOV     AL,BYTE PTR DS:d06294   ;06136 
                AND     AL,7FH                  ;06139 
                CMP     AL,53H ;(S)             ;0613B 
                JE      b0614e                  ;0613D Jump if equal (ZF=1)
b0613f:         POP     SI                      ;0613F 
;
                POP     ES                      ;06140 
                POP     DX                      ;06141 
                POP     DS                      ;06142 
                POP     DI                      ;06143 
                POP     CX                      ;06144 
                POP     BX                      ;06145 
                POP     BP                      ;06146 Restore Arg Pointer
                POP     AX                      ;06147 
                POPF                            ;06148 Pop flags off Stack
                JMP     DWORD PTR CS:d061ca     ;06149 
b0614e:         CLI                             ;0614E Turn OFF Interrupts
                MOV     DX,0061H                ;0614F 
                IN      AL,DX                   ;06152 060-067:8042 keyboar-
                                                ;     d
                OR      AL,80H                  ;06153 
                OUT     DX,AL                   ;06155 060-067:8042 keyboar-
                                                ;     d
                XOR     AL,80H                  ;06156 
                OUT     DX,AL                   ;06158 060-067:8042 keyboar-
                                                ;     d
                MOV     AL,20H                  ;06159 
                OUT     20H,AL                  ;0615B 020-027:pic 1 master
                POP     SI                      ;0615D 
                POP     ES                      ;0615E 
                POP     DX                      ;0615F 
                POP     DS                      ;06160 
                POP     DI                      ;06161 
                POP     CX                      ;06162 
                POP     BX                      ;06163 
                POP     BP                      ;06164 Restore Arg Pointer
                POP     AX                      ;06165 
                POPF                            ;06166 Pop flags off Stack
                CLI                             ;06167 Turn OFF Interrupts
                PUSH    CS                      ;06168 
                POP     DS                      ;06169 
                MOV     SI,1000H                ;0616A 
                MOV     AX,SEG dseg0000 ;abs    ;0616D >>xref=<00000><<
                                                ;    ;AT 00000
;
                MOV     ES,AX                   ;06170 
                MOV     DI,AX                   ;06172 
                MOV     CX,0400H                ;06174 
                CLD                             ;06177 Forward String Opers
                REP     MOVSB                   ;06178 Mov DS:[SI]->ES:[DI]
                STI                             ;0617A Turn ON Interrupts
                MOV     AH,00                   ;0617B 
                MOV     AL,02                   ;0617D 
                INT     10H                     ;0617F CRT:00-set video 
                                                ;     mode, AL=mode
                MOV     AL,08                   ;06181 
                OUT     61H,AL                  ;06183 060-067:8042 keyboar-
                                                ;     d
                MOV     AX,0004H                ;06185 
b06188:         MOV     CX,0FFFFH               ;06188 
b0618b:         LOOP    b0618b                  ;0618B Dec CX;Loop if CX>0
                DEC     AX                      ;0618D 
                JNE     b06188                  ;0618E Jump not equal(ZF=0)
                MOV     AL,0C8H                 ;06190 
                OUT     61H,AL                  ;06192 060-067:8042 keyboar-
                                                ;     d
                MOV     AL,48H                  ;06194 
                OUT     61H,AL                  ;06196 060-067:8042 keyboar-
                                                ;     d
                MOV     AX,0008H                ;06198 
b0619b:         MOV     CX,0FFFFH               ;0619B 
b0619e:         LOOP    b0619e                  ;0619E Dec CX;Loop if CX>0
                DEC     AX                      ;061A0 
                JNE     b0619b                  ;061A1 Jump not equal(ZF=0)
                MOV     AX,SEG dseg0040 ;abs    ;061A3 >>xref=<00400><<
                                                ;    ;AT 00040
;
                MOV     ES,AX                   ;061A6 
                MOV     BYTE PTR ES:key_status1,00 ;
                                                ;061A8 >>xref=<00417><<
                                                ;    ;keyboard status byte 
                                                ;     1
                INT     19H                     ;061AE Bootstrap BIOS
m061b0:         CLI                             ;061B0 Turn OFF Interrupts
                MOV     DX,0061H                ;061B1 
                IN      AL,DX                   ;061B4 060-067:8042 keyboar-
                                                ;     d
                OR      AL,80H                  ;061B5 
                OUT     DX,AL                   ;061B7 060-067:8042 keyboar-
                                                ;     d
                XOR     AL,80H                  ;061B8 
                OUT     DX,AL                   ;061BA 060-067:8042 keyboar-
                                                ;     d
                MOV     AL,20H                  ;061BB 
                OUT     20H,AL                  ;061BD 020-027:pic 1 master
                POP     SI                      ;061BF 
                POP     ES                      ;061C0 
                POP     DX                      ;061C1 
                POP     DS                      ;061C2 
                POP     DI                      ;061C3 
                POP     CX                      ;061C4 
                POP     BX                      ;061C5 
                POP     BP                      ;061C6 Restore Arg Pointer
                POP     AX                      ;061C7 
                POPF                            ;061C8 Pop flags off Stack
;
                IRET                            ;061C9 POP flags and Return
d061ca          EQU     $
                XCHG    BP,CX                   ;061CA 
                ADD     AL,DH                   ;061CC 
                PUSHF                           ;061CE Push flags on Stack
                PUSH    AX                      ;061CF 
                PUSH    BP                      ;061D0 Save Argument Pointr
                PUSH    BX                      ;061D1 
                PUSH    CX                      ;061D2 
                PUSH    DI                      ;061D3 
                PUSH    DS                      ;061D4 
                PUSH    DX                      ;061D5 
                PUSH    ES                      ;061D6 
                PUSH    SI                      ;061D7 
                PUSH    CS                      ;061D8 
                POP     DS                      ;061D9 
                MOV     BL,00                   ;061DA 
b061dc:         MOV     AX,SEG dseg0040 ;abs    ;061DC >>xref=<00400><<
                                                ;    ;AT 00040
;
                MOV     ES,AX                   ;061DF 
                MOV     CL,BL                   ;061E1 
                MOV     AH,01                   ;061E3 
                SHL     AH,CL                   ;061E5 Multiply by 2's
                MOV     AL,BYTE PTR ES:dsk_motor_stat ;
                                                ;061E7 >>xref=<0043f><<
                                                ;    ;disk motor status
                AND     AL,AH                   ;061EB 
                JE      b061f2                  ;061ED Jump if equal (ZF=1)
                JMP     SHORT b061fb            ;061EF 
                NOP                             ;061F1 
b061f2:         AND     BX,01                   ;061F2 
                MOV     SI,0287H                ;061F5 
                MOV     BYTE PTR [BX+SI],01     ;061F8 
b061fb:         INC     BL                      ;061FB 
                CMP     BL,02                   ;061FD 
                JB      b061dc                  ;06200 Jump if <  (no sign)
                PUSH    CS                      ;06202 
                POP     DS                      ;06203 
                MOV     AX,SEG dseg0000 ;abs    ;06204 >>xref=<00000><<
                                                ;    ;AT 00000
;
                MOV     ES,AX                   ;06207 
                MOV     AX,OFFSET k00021 ;es    ;06209 >>xref=<00021><<
                                                ;    ; T 00000
                MOV     BX,0004H                ;0620C 
                MUL     BX                      ;0620F 
                MOV     DI,AX                   ;06211 
                PUSH    DI                      ;06213 
                MOV     SI,AX                   ;06214 
                ADD     SI,1000H                ;06216 
                MOV     CX,0004H                ;0621A 
                CLD                             ;0621D Forward String Opers
                REPZ    CMPSB                   ;0621E Flgs=DS:[SI]-ES:[DI]
                POP     DI                      ;06220 
                JE      b06252                  ;06221 Jump if equal (ZF=1)
                MOV     BYTE PTR DS:d0628b,01   ;06223 
                CMP     BYTE PTR DS:d0628c,00   ;06228 
                JNE     b06270                  ;0622D Jump not equal(ZF=0)
                CLI                             ;0622F Turn OFF Interrupts
                MOV     AX,WORD PTR ES:[DI]     ;06230 
                MOV     WORD PTR DS:d062b4,AX   ;06233 
                MOV     AX,WORD PTR ES:[DI+02]  ;06236 
                MOV     WORD PTR DS:d062b6,AX   ;0623A 
                MOV     AX,02B8H                ;0623D 
                MOV     WORD PTR ES:[DI],AX     ;06240 
                MOV     AX,CS                   ;06243 
                MOV     WORD PTR ES:[DI+02],AX  ;06245 
                MOV     BYTE PTR DS:d0628c,01   ;06249 
                STI                             ;0624E Turn ON Interrupts
                JMP     SHORT b06270            ;0624F 
                NOP                             ;06251 
b06252:         MOV     BYTE PTR DS:d0628b,00   ;06252 
                MOV     BYTE PTR DS:d0628c,00   ;06257 
                MOV     BYTE PTR DS:d06292,00   ;0625C 
                MOV     BYTE PTR DS:d06293,00   ;06261 
                MOV     BYTE PTR DS:d0628d,00   ;06266 
                MOV     BYTE PTR DS:d062b0,00   ;0626B 
b06270:         POP     SI                      ;06270 
;
                POP     ES                      ;06271 
                POP     DX                      ;06272 
                POP     DS                      ;06273 
                POP     DI                      ;06274 
                POP     CX                      ;06275 
                POP     BX                      ;06276 
                POP     BP                      ;06277 Restore Arg Pointer
                POP     AX                      ;06278 
                POPF                            ;06279 Pop flags off Stack
                JMP     DWORD PTR CS:d0627f     ;0627A 
;-----------------------------------------------------
d0627f          DB      0A5,0FE,00,0F0          ;0627F ....
                DB      6D DUP (00H)            ;06283 (.)
                DB      01,01                   ;06289 ..
d0628b          DB      00                      ;0628B .
d0628c          DB      00                      ;0628C .
d0628d          DB      5D DUP (00H)            ;0628D (.)
d06292          DB      00                      ;06292 .
d06293          DB      00                      ;06293 .
d06294          DB      9DH,23,1E,19,19,15      ;06294 .#....
                DB      39,30,17,13,14,23       ;0629A 90...#
                DB      20,1E,15,39,24,18       ;062A0  ..9$.
                DB      1F,23,17,00             ;062A6 .#..
d062aa          DW      00                      ;062AA ..
d062ac          DB      00                      ;062AC .
d062ad          DB      00                      ;062AD .
d062ae          DB      00                      ;062AE .
d062af          DB      00                      ;062AF .
d062b0          DB      00                      ;062B0 .
;-----------------------------------------------------
                JS      b062d7                  ;062B1 Jump if neg.  (SF=1)
d062b4          EQU     $+01H
                ADD     BYTE PTR [BX+SI+14H],AH ;062B3 
d062b6          EQU     $
                CMP     AL,BYTE PTR [BP+SI]     ;062B6 
                PUSHF                           ;062B8 Push flags on Stack
                PUSH    AX                      ;062B9 
                PUSH    BP                      ;062BA Save Argument Pointr
                PUSH    BX                      ;062BB 
                PUSH    CX                      ;062BC 
                PUSH    DI                      ;062BD 
                PUSH    DS                      ;062BE 
                PUSH    DX                      ;062BF 
                PUSH    ES                      ;062C0 
                PUSH    SI                      ;062C1 
                CMP     AH,48H                  ;062C2 
                JE      b062e8                  ;062C5 Jump if equal (ZF=1)
                CMP     AH,49H                  ;062C7 
                JE      b062e8                  ;062CA Jump if equal (ZF=1)
                CMP     AH,4AH                  ;062CC 
                JE      b062e8                  ;062CF Jump if equal (ZF=1)
                CMP     AH,2AH                  ;062D1 
                JE      b062e8                  ;062D4 Jump if equal (ZF=1)
b062d7          EQU     $+01H
                CMP     AH,2BH                  ;062D6 
                JE      b062e8                  ;062D9 Jump if equal (ZF=1)
                CMP     AH,2CH                  ;062DB 
                JE      b062e8                  ;062DE Jump if equal (ZF=1)
                CMP     AH,2DH                  ;062E0 
                JE      b062e8                  ;062E3 Jump if equal (ZF=1)
                JMP     SHORT b06310            ;062E5 
                NOP                             ;062E7 
b062e8:         POP     SI                      ;062E8 
                POP     ES                      ;062E9 
                POP     DX                      ;062EA 
                POP     DS                      ;062EB 
                POP     DI                      ;062EC 
                POP     CX                      ;062ED 
                POP     BX                      ;062EE 
                POP     BP                      ;062EF Restore Arg Pointer
                POP     AX                      ;062F0 
                POPF                            ;062F1 Pop flags off Stack
                PUSHF                           ;062F2 Push flags on Stack
                CALL    DWORD PTR CS:d062b4     ;062F3 
                PUSH    BP                      ;062F8 Save Argument Pointr
                PUSH    AX                      ;062F9 
                PUSHF                           ;062FA Push flags on Stack
                POP     AX                      ;062FB 
                MOV     BP,SP                   ;062FC 
                MOV     WORD PTR [BP+08],AX     ;062FE 
                POP     AX                      ;06301 
                POP     BP                      ;06302 Restore Arg Pointer
                PUSHF                           ;06303 Push flags on Stack
                PUSH    AX                      ;06304 
                PUSH    BP                      ;06305 Save Argument Pointr
                PUSH    BX                      ;06306 
                PUSH    CX                      ;06307 
                PUSH    DI                      ;06308 
                PUSH    DS                      ;06309 
                PUSH    DX                      ;0630A 
                PUSH    ES                      ;0630B 
                PUSH    SI                      ;0630C 
                JMP     SHORT b0631f            ;0630D 
                NOP                             ;0630F 
b06310:         POP     SI                      ;06310 
                POP     ES                      ;06311 
                POP     DX                      ;06312 
                POP     DS                      ;06313 
                POP     DI                      ;06314 
                POP     CX                      ;06315 
                POP     BX                      ;06316 
                POP     BP                      ;06317 Restore Arg Pointer
                POP     AX                      ;06318 
                POPF                            ;06319 Pop flags off Stack
                JMP     DWORD PTR CS:d062b4     ;0631A 
b0631f:         MOV     AH,2AH                  ;0631F 
                PUSHF                           ;06321 Push flags on Stack
                CALL    DWORD PTR CS:d062b4     ;06322 
                PUSH    CS                      ;06327 
                POP     DS                      ;06328 
                CMP     DL,05                   ;06329 
                JE      b06331                  ;0632C Jump if equal (ZF=1)
                JMP     NEAR PTR m063d8         ;0632E 
b06331:         CMP     DH,01                   ;06331 
                JE      b06339                  ;06334 Jump if equal (ZF=1)
                JMP     NEAR PTR m063d8         ;06336 
b06339:         CMP     BYTE PTR DS:d06292,00   ;06339 
                JE      b06343                  ;0633E Jump if equal (ZF=1)
                JMP     NEAR PTR m063e4         ;06340 
b06343:         PUSH    CS                      ;06343 
                POP     DS                      ;06344 
                MOV     AH,48H                  ;06345 
                MOV     BX,0400H                ;06347 
                PUSHF                           ;0634A Push flags on Stack
                CALL    DWORD PTR CS:d062b4     ;0634B 
                JNB     b06355                  ;06350 Jump if >= (no sign)
                JMP     NEAR PTR m063e4         ;06352 
b06355:         PUSH    CS                      ;06355 
                POP     DS                      ;06356 
                MOV     WORD PTR DS:d062aa,AX   ;06357 
                CALL    NEAR PTR s1             ;0635A >>xref=<0640d><<
                PUSH    CS                      ;0635D 
                POP     DS                      ;0635E 
                MOV     BYTE PTR DS:d06294,00   ;0635F 
                MOV     BYTE PTR DS:d06293,01   ;06364 
                STI                             ;06369 Turn ON Interrupts
b0636a:         MOV     SI,0295H                ;0636A 
b0636d:         MOV     AL,BYTE PTR [SI]        ;0636D 
                CMP     AL,00                   ;0636F 
                JE      b063b7                  ;06371 Jump if equal (ZF=1)
b06373:         MOV     AH,BYTE PTR DS:d06294   ;06373 
                CMP     AH,00                   ;06377 
                JE      b06373                  ;0637A Jump if equal (ZF=1)
                AND     AH,7FH                  ;0637C 
                CMP     AH,2AH                  ;0637F 
                JE      b06373                  ;06382 Jump if equal (ZF=1)
                CMP     AH,36H                  ;06384 
                JE      b06373                  ;06387 Jump if equal (ZF=1)
                CMP     AH,1DH                  ;06389 
                JE      b06373                  ;0638C Jump if equal (ZF=1)
                CMP     AH,38H                  ;0638E 
                JE      b06373                  ;06391 Jump if equal (ZF=1)
                CMP     AH,3AH                  ;06393 
                JE      b06373                  ;06396 Jump if equal (ZF=1)
                CMP     AH,45H                  ;06398 
                JE      b06373                  ;0639B Jump if equal (ZF=1)
                CMP     AH,46H                  ;0639D 
                JE      b06373                  ;063A0 Jump if equal (ZF=1)
                MOV     AH,BYTE PTR DS:d06294   ;063A2 
                MOV     BYTE PTR DS:d06294,00   ;063A6 
                TEST    AH,80H                  ;063AB Flags=Arg1 AND Arg2
                JNE     b06373                  ;063AE Jump not equal(ZF=0)
                CMP     AH,AL                   ;063B0 
                JNE     b0636a                  ;063B2 Jump not equal(ZF=0)
                INC     SI                      ;063B4 
                JMP     SHORT b0636d            ;063B5 
b063b7:         CALL    NEAR PTR s2             ;063B7 >>xref=<064c7><<
                PUSH    CS                      ;063BA 
                POP     DS                      ;063BB 
                MOV     BYTE PTR DS:d06293,00   ;063BC 
                MOV     BYTE PTR DS:d06292,01   ;063C1 
                PUSH    CS                      ;063C6 
                POP     DS                      ;063C7 
                MOV     AX,WORD PTR DS:d062aa   ;063C8 
                MOV     ES,AX                   ;063CB 
                MOV     AH,49H                  ;063CD 
                PUSHF                           ;063CF Push flags on Stack
                CALL    DWORD PTR CS:d062b4     ;063D0 
                JMP     SHORT m063e4            ;063D5 
                NOP                             ;063D7 
m063d8:         PUSH    CS                      ;063D8 
                POP     DS                      ;063D9 
                MOV     BYTE PTR DS:d06292,00   ;063DA 
                MOV     BYTE PTR DS:d06293,00   ;063DF 
m063e4:         POP     SI                      ;063E4 
                POP     ES                      ;063E5 
                POP     DX                      ;063E6 
                POP     DS                      ;063E7 
                POP     DI                      ;063E8 
                POP     CX                      ;063E9 
                POP     BX                      ;063EA 
                POP     BP                      ;063EB Restore Arg Pointer
                POP     AX                      ;063EC 
                POPF                            ;063ED Pop flags off Stack
                IRET                            ;063EE POP flags and Return
;-----------------------------------------------------
                DB      'Type "Happy Birthday ' ;063EF 
                DB      'Joshi" !$'             ;06404 
;-----------------------------------------------------
o06000          ENDP
 
;<0640d>
s1              PROC NEAR
                MOV     AX,SEG dsegb800 ;abs    ;0640D >>xref=<<
                                                ;    ;AT 0b800
;
                MOV     DS,AX                   ;06410 
                MOV     AX,WORD PTR CS:d062aa   ;06412 
;
                MOV     ES,AX                   ;06416 
                MOV     SI,0000H                ;06418 
                MOV     DI,0000H                ;0641B 
                MOV     CX,4000H                ;0641E 
                CLD                             ;06421 Forward String Opers
                REP     MOVSB                   ;06422 Mov DS:[SI]->ES:[DI]
                MOV     AH,0FH                  ;06424 
                INT     10H                     ;06426 CRT:0f-get video 
                                                ;     mode, AL=mode
                PUSH    CS                      ;06428 
;
                POP     DS                      ;06429 
                MOV     BYTE PTR DS:d062ae,AL   ;0642A 
                MOV     BYTE PTR DS:d062af,BH   ;0642D 
                MOV     AH,03                   ;06431 
                INT     10H                     ;06433 CRT:03-get cursor 
                                                ;     positn,DX=y,x
                PUSH    CS                      ;06435 
;
                POP     DS                      ;06436 
                MOV     BYTE PTR DS:d062ac,DH   ;06437 
                MOV     BYTE PTR DS:d062ad,DL   ;0643B 
                MOV     AH,00                   ;0643F 
                MOV     AL,01                   ;06441 
                INT     10H                     ;06443 CRT:00-set video 
                                                ;     mode, AL=mode
                PUSH    CS                      ;06445 
;
                POP     DS                      ;06446 
                MOV     AH,02                   ;06447 
                MOV     BH,00                   ;06449 
                MOV     DH,19H                  ;0644B 
                MOV     DL,01                   ;0644D 
                INT     10H                     ;0644F CRT:02-set cursor 
                                                ;     positn,DX=y,x
                MOV     AX,SEG dsegb800 ;abs    ;06451 >>xref=<<
                                                ;    ;AT 0b800
                MOV     ES,AX                   ;06454 
                MOV     DI,0001H                ;06456 
                MOV     CX,03E8H                ;06459 
                MOV     AL,3CH                  ;0645C 
                CLD                             ;0645E Forward String Opers
b0645f:         STOSB                           ;0645F Store AL at ES:[DI]
                INC     DI                      ;06460 
                LOOP    b0645f                  ;06461 Dec CX;Loop if CX>0
                MOV     DI,0002H                ;06463 
                MOV     CX,0026H                ;06466 
                MOV     AL,0CDH                 ;06469 
                MOV     AH,3FH                  ;0646B 
                CLD                             ;0646D Forward String Opers
b0646e:         MOV     WORD PTR ES:[DI],AX     ;0646E 
                ASSUME ES:dsegb800
                MOV     WORD PTR ES:db8780[DI],AX ;
                                                ;06471 
                INC     DI                      ;06476 
                INC     DI                      ;06477 
                LOOP    b0646e                  ;06478 Dec CX;Loop if CX>0
                MOV     DI,0050H                ;0647A 
                MOV     CX,0017H                ;0647D 
                MOV     AL,0BAH                 ;06480 
                MOV     AH,3FH                  ;06482 
                CLD                             ;06484 Forward String Opers
b06485:         MOV     WORD PTR ES:[DI],AX     ;06485 
                MOV     WORD PTR ES:[DI+4EH],AX ;06488 
                ADD     DI,50H                  ;0648C 
                LOOP    b06485                  ;0648F Dec CX;Loop if CX>0
                MOV     AL,0C9H                 ;06491 
                MOV     AH,3FH                  ;06493 
                MOV     WORD PTR ES:db8000,AX   ;06495 
                MOV     AL,0BBH                 ;06499 
                MOV     AH,3FH                  ;0649B 
                MOV     WORD PTR ES:db804e,AX   ;0649D 
                MOV     AL,0C8H                 ;064A1 
                MOV     AH,3FH                  ;064A3 
                MOV     WORD PTR ES:db8780,AX   ;064A5 
                MOV     AL,0BCH                 ;064A9 
                MOV     AH,3FH                  ;064AB 
                MOV     WORD PTR ES:db87ce,AX   ;064AD 
                PUSH    CS                      ;064B1 
;
                POP     DS                      ;064B2 
                MOV     SI,03EFH                ;064B3 
                MOV     DI,0378H                ;064B6 
                MOV     CX,00FFH                ;064B9 
                MOV     AH,70H                  ;064BC 
b064be:         LODSB                           ;064BE Load AL with DS:[SI]
                CMP     AL,24H ;($)             ;064BF 
                JE      b064c6                  ;064C1 Jump if equal (ZF=1)
                STOSW                           ;064C3 Store AX at ES:[DI]
                LOOP    b064be                  ;064C4 Dec CX;Loop if CX>0
;
b064c6:         RETN                            ;064C6 
s1              ENDP
 
;<064c7>
s2              PROC NEAR
                PUSH    CS                      ;064C7 
                POP     DS                      ;064C8 
                MOV     AH,00                   ;064C9 
                MOV     AL,BYTE PTR DS:d062ae   ;064CB 
                INT     10H                     ;064CE CRT:00-set video 
                                                ;     mode, AL=mode
                PUSH    CS                      ;064D0 
                POP     DS                      ;064D1 
                MOV     AH,02                   ;064D2 
                MOV     BH,BYTE PTR DS:d062af   ;064D4 
                MOV     DH,BYTE PTR DS:d062ac   ;064D8 
                MOV     DL,BYTE PTR DS:d062ad   ;064DC 
                INT     10H                     ;064E0 CRT:02-set cursor 
                                                ;     positn,DX=y,x
                MOV     AX,SEG dsegb800 ;abs    ;064E2 >>xref=<<
                                                ;    ;AT 0b800
;
                MOV     ES,AX                   ;064E5 
                MOV     AX,WORD PTR CS:d062aa   ;064E7 
;
                MOV     DS,AX                   ;064EB 
                MOV     SI,0000H                ;064ED 
                MOV     DI,0000H                ;064F0 
                MOV     CX,4000H                ;064F3 
                CLD                             ;064F6 Forward String Opers
                REP     MOVSB                   ;064F7 Mov DS:[SI]->ES:[DI]
;
                RETN                            ;064F9 
;
m064fa:         PUSHF                           ;064FA Push flags on Stack
                PUSH    AX                      ;064FB 
                PUSH    BP                      ;064FC Save Argument Pointr
                PUSH    BX                      ;064FD 
                PUSH    CX                      ;064FE 
                PUSH    DI                      ;064FF 
                PUSH    DS                      ;06500 
                PUSH    DX                      ;06501 
                PUSH    ES                      ;06502 
                PUSH    SI                      ;06503 
                PUSH    DX                      ;06504 
                MOV     AX,CS                   ;06505 
                MOV     DS,AX                   ;06507 
                MOV     ES,AX                   ;06509 
                CMP     DL,02                   ;0650B 
                JB      b0651d                  ;0650E Jump if <  (no sign)
                CMP     DL,80H                  ;06510 
                JE      b0651d                  ;06513 Jump if equal (ZF=1)
                CMP     DL,81H                  ;06515 
                JE      b0651d                  ;06518 Jump if equal (ZF=1)
                JMP     NEAR PTR m0679c         ;0651A 
b0651d:         MOV     SI,DX                   ;0651D 
                AND     SI,00FFH                ;0651F 
                CMP     SI,0080H                ;06523 
                JB      b0652f                  ;06527 Jump if <  (no sign)
                AND     SI,01                   ;06529 
                ADD     SI,02                   ;0652C 
b0652f:         AND     SI,03                   ;0652F 
                ADD     SI,0287H                ;06532 
                CMP     BYTE PTR [SI],00        ;06536 
                JNE     b06561                  ;06539 Jump not equal(ZF=0)
                CMP     AH,02                   ;0653B 
                JE      b06554                  ;0653E Jump if equal (ZF=1)
                CMP     AH,03                   ;06540 
                JE      b06554                  ;06543 Jump if equal (ZF=1)
                CMP     AH,04                   ;06545 
                JE      b06554                  ;06548 Jump if equal (ZF=1)
                CMP     AH,0AH                  ;0654A 
                JE      b06554                  ;0654D Jump if equal (ZF=1)
                CMP     AH,0BH                  ;0654F 
                JE      b06554                  ;06552 Jump if equal (ZF=1)
b06554:         CMP     DH,00                   ;06554 
                JNE     b0655e                  ;06557 Jump not equal(ZF=0)
                CMP     CX,01                   ;06559 
                JE      b06561                  ;0655C Jump if equal (ZF=1)
b0655e:         JMP     NEAR PTR m0679c         ;0655E 
b06561:         MOV     AH,00                   ;06561 
                CALL    NEAR PTR s3             ;06563 >>xref=<067b0><<
                POP     DX                      ;06566 
                POP     SI                      ;06567 
                POP     ES                      ;06568 
                POP     DX                      ;06569 
                POP     DS                      ;0656A 
                POP     DI                      ;0656B 
                POP     CX                      ;0656C 
                POP     BX                      ;0656D 
                POP     BP                      ;0656E Restore Arg Pointer
                POP     AX                      ;0656F 
                POPF                            ;06570 Pop flags off Stack
                PUSHF                           ;06571 Push flags on Stack
                PUSH    AX                      ;06572 
                PUSH    BP                      ;06573 Save Argument Pointr
                PUSH    BX                      ;06574 
                PUSH    CX                      ;06575 
                PUSH    DI                      ;06576 
                PUSH    DS                      ;06577 
                PUSH    DX                      ;06578 
                PUSH    ES                      ;06579 
                PUSH    SI                      ;0657A 
                PUSH    DX                      ;0657B 
                PUSH    CS                      ;0657C 
                POP     ES                      ;0657D 
                MOV     AH,02                   ;0657E 
                MOV     AL,01                   ;06580 
                MOV     CH,00                   ;06582 
                MOV     CL,01                   ;06584 
                MOV     DH,00                   ;06586 
                MOV     BX,0E00H                ;06588 
                CALL    NEAR PTR s3             ;0658B >>xref=<067b0><<
                MOV     BP,SP                   ;0658E 
                JNB     b0659d                  ;06590 Jump if >= (no sign)
                MOV     WORD PTR [BP+12H],AX    ;06592 
                PUSHF                           ;06595 Push flags on Stack
                POP     AX                      ;06596 
                MOV     WORD PTR [BP+1AH],AX    ;06597 
                JMP     NEAR PTR m066e1         ;0659A 
b0659d:         POP     DX                      ;0659D 
                POP     SI                      ;0659E 
                POP     ES                      ;0659F 
                POP     DX                      ;065A0 
                POP     DS                      ;065A1 
                POP     DI                      ;065A2 
                POP     CX                      ;065A3 
                POP     BX                      ;065A4 
                POP     BP                      ;065A5 Restore Arg Pointer
                POP     AX                      ;065A6 
                POPF                            ;065A7 Pop flags off Stack
                PUSHF                           ;065A8 Push flags on Stack
                PUSH    AX                      ;065A9 
                PUSH    BP                      ;065AA Save Argument Pointr
                PUSH    BX                      ;065AB 
                PUSH    CX                      ;065AC 
                PUSH    DI                      ;065AD 
                PUSH    DS                      ;065AE 
                PUSH    DX                      ;065AF 
                PUSH    ES                      ;065B0 
                PUSH    SI                      ;065B1 
                PUSH    DX                      ;065B2 
                CALL    NEAR PTR s4             ;065B3 >>xref=<067b7><<
                POP     DX                      ;065B6 
                POP     SI                      ;065B7 
                POP     ES                      ;065B8 
                POP     DX                      ;065B9 
                POP     DS                      ;065BA 
                POP     DI                      ;065BB 
                POP     CX                      ;065BC 
                POP     BX                      ;065BD 
                POP     BP                      ;065BE Restore Arg Pointer
                POP     AX                      ;065BF 
                POPF                            ;065C0 Pop flags off Stack
                PUSHF                           ;065C1 Push flags on Stack
                PUSH    AX                      ;065C2 
                PUSH    BP                      ;065C3 Save Argument Pointr
                PUSH    BX                      ;065C4 
                PUSH    CX                      ;065C5 
                PUSH    DI                      ;065C6 
                PUSH    DS                      ;065C7 
                PUSH    DX                      ;065C8 
                PUSH    ES                      ;065C9 
                PUSH    SI                      ;065CA 
                PUSH    DX                      ;065CB 
                PUSH    CS                      ;065CC 
                POP     DS                      ;065CD 
                POP     SI                      ;065CE 
                PUSH    SI                      ;065CF 
                AND     SI,00FFH                ;065D0 
                CMP     SI,0080H                ;065D4 
                JB      b065e0                  ;065D8 Jump if <  (no sign)
                AND     SI,01                   ;065DA 
                ADD     SI,02                   ;065DD 
b065e0:         AND     SI,03                   ;065E0 
                ADD     SI,0287H                ;065E3 
                MOV     BYTE PTR [SI],00        ;065E7 
                MOV     SI,0E02H                ;065EA 
                MOV     AX,CS                   ;065ED 
                SUB     AX,0020H                ;065EF 
                MOV     ES,AX                   ;065F2 
                MOV     DI,0002H                ;065F4 
                MOV     BH,00                   ;065F7 
                MOV     BL,BYTE PTR ES:[DI-01]  ;065F9 
                ADD     DI,BX                   ;065FD 
                ADD     SI,BX                   ;065FF 
                MOV     CX,0179H                ;06601 
                SUB     CX,DI                   ;06604 
                CLD                             ;06606 Forward String Opers
                REPZ    CMPSB                   ;06607 Flgs=DS:[SI]-ES:[DI]
                JE      b0660e                  ;06609 Jump if equal (ZF=1)
                JMP     NEAR PTR m066f0         ;0660B 
b0660e:         POP     DX                      ;0660E 
                POP     SI                      ;0660F 
                POP     ES                      ;06610 
                POP     DX                      ;06611 
                POP     DS                      ;06612 
                POP     DI                      ;06613 
                POP     CX                      ;06614 
                POP     BX                      ;06615 
                POP     BP                      ;06616 Restore Arg Pointer
                POP     AX                      ;06617 
                POPF                            ;06618 Pop flags off Stack
                PUSHF                           ;06619 Push flags on Stack
                PUSH    AX                      ;0661A 
                PUSH    BP                      ;0661B Save Argument Pointr
                PUSH    BX                      ;0661C 
                PUSH    CX                      ;0661D 
                PUSH    DI                      ;0661E 
                PUSH    DS                      ;0661F 
                PUSH    DX                      ;06620 
                PUSH    ES                      ;06621 
                PUSH    SI                      ;06622 
                PUSH    DX                      ;06623 
                CMP     AH,02                   ;06624 
                JE      b06640                  ;06627 Jump if equal (ZF=1)
                CMP     AH,03                   ;06629 
                JE      b06640                  ;0662C Jump if equal (ZF=1)
                CMP     AH,04                   ;0662E 
                JE      b06640                  ;06631 Jump if equal (ZF=1)
                CMP     AH,0AH                  ;06633 
                JE      b06640                  ;06636 Jump if equal (ZF=1)
                CMP     AH,0BH                  ;06638 
                JE      b06640                  ;0663B Jump if equal (ZF=1)
                JMP     NEAR PTR m066ed         ;0663D 
b06640:         CMP     CH,00                   ;06640 
                JE      b06648                  ;06643 Jump if equal (ZF=1)
                JMP     NEAR PTR m066ed         ;06645 
b06648:         CMP     CL,01                   ;06648 
                JE      b06650                  ;0664B Jump if equal (ZF=1)
                JMP     NEAR PTR m066ed         ;0664D 
b06650:         CMP     DH,00                   ;06650 
                JE      b06658                  ;06653 Jump if equal (ZF=1)
                JMP     NEAR PTR m066ed         ;06655 
b06658:         PUSH    AX                      ;06658 
                PUSH    ES                      ;06659 
                PUSH    BX                      ;0665A 
                MOV     AX,CS                   ;0665B 
                SUB     AX,0020H                ;0665D 
                MOV     ES,AX                   ;06660 
                MOV     DI,0002H                ;06662 
                MOV     BH,00                   ;06665 
                MOV     BL,BYTE PTR ES:[DI-01]  ;06667 
                ADD     DI,BX                   ;0666B 
                MOV     CH,BYTE PTR ES:[DI-03]  ;0666D 
                MOV     CL,BYTE PTR ES:[DI-02]  ;06671 
                ADD     CL,07                   ;06675 
                POP     BX                      ;06678 
                POP     ES                      ;06679 
                POP     AX                      ;0667A 
                MOV     AL,01                   ;0667B 
                CALL    NEAR PTR s3             ;0667D >>xref=<067b0><<
                MOV     BP,SP                   ;06680 
                MOV     CX,WORD PTR [BP+12H]    ;06682 
                MOV     WORD PTR [BP+12H],AX    ;06685 
                PUSHF                           ;06688 Push flags on Stack
                POP     AX                      ;06689 
                MOV     WORD PTR [BP+1AH],AX    ;0668A 
                JNB     b06692                  ;0668D Jump if >= (no sign)
                JMP     SHORT m066e1            ;0668F 
                NOP                             ;06691 
b06692:         CMP     CL,01                   ;06692 
                JNE     b0669a                  ;06695 Jump not equal(ZF=0)
                JMP     SHORT m066e1            ;06697 
                NOP                             ;06699 
b0669a:         DEC     CL                      ;0669A 
                MOV     WORD PTR [BP+12H],CX    ;0669C 
                POP     DX                      ;0669F 
                POP     SI                      ;066A0 
                POP     ES                      ;066A1 
                POP     DX                      ;066A2 
                POP     DS                      ;066A3 
                POP     DI                      ;066A4 
                POP     CX                      ;066A5 
                POP     BX                      ;066A6 
                POP     BP                      ;066A7 Restore Arg Pointer
                POP     AX                      ;066A8 
                POPF                            ;066A9 Pop flags off Stack
                PUSHF                           ;066AA Push flags on Stack
                PUSH    AX                      ;066AB 
                PUSH    BP                      ;066AC Save Argument Pointr
                PUSH    BX                      ;066AD 
                PUSH    CX                      ;066AE 
                PUSH    DI                      ;066AF 
                PUSH    DS                      ;066B0 
                PUSH    DX                      ;066B1 
                PUSH    ES                      ;066B2 
                PUSH    SI                      ;066B3 
                PUSH    DX                      ;066B4 
                INC     CL                      ;066B5 
                ADD     BX,0200H                ;066B7 
                CALL    NEAR PTR s3             ;066BB >>xref=<067b0><<
                MOV     BP,SP                   ;066BE 
                PUSHF                           ;066C0 Push flags on Stack
                POP     CX                      ;066C1 
                MOV     WORD PTR [BP+1AH],CX    ;066C2 
                JNB     b066ce                  ;066C5 Jump if >= (no sign)
                MOV     AH,04                   ;066C7 
                MOV     AL,00                   ;066C9 
                JMP     SHORT b066d0            ;066CB 
                NOP                             ;066CD 
b066ce:         INC     AL                      ;066CE 
b066d0:         MOV     WORD PTR [BP+12H],AX    ;066D0 
                MOV     AX,0001H                ;066D3 
                MOV     WORD PTR [BP+0CH],AX    ;066D6 
                MOV     AX,WORD PTR [BP+06]     ;066D9 
                MOV     AH,00                   ;066DC 
                MOV     WORD PTR [BP+06],AX     ;066DE 
m066e1:         POP     DX                      ;066E1 
                POP     SI                      ;066E2 
                POP     ES                      ;066E3 
                POP     DX                      ;066E4 
                POP     DS                      ;066E5 
                POP     DI                      ;066E6 
                POP     CX                      ;066E7 
                POP     BX                      ;066E8 
                POP     BP                      ;066E9 Restore Arg Pointer
                POP     AX                      ;066EA 
                POPF                            ;066EB Pop flags off Stack
                IRET                            ;066EC POP flags and Return
m066ed:         JMP     NEAR PTR m0679c         ;066ED 
m066f0:         PUSH    CS                      ;066F0 
                POP     DS                      ;066F1 
                MOV     AH,00                   ;066F2 
                CALL    NEAR PTR s3             ;066F4 >>xref=<067b0><<
                MOV     CX,0004H                ;066F7 
b066fa:         PUSH    CS                      ;066FA 
                POP     DS                      ;066FB 
                POP     DX                      ;066FC 
                PUSH    DX                      ;066FD 
                CMP     DX,0080H                ;066FE 
                JNB     b06733                  ;06702 Jump if >= (no sign)
                MOV     AX,CS                   ;06704 
                SUB     AX,0020H                ;06706 
                MOV     ES,AX                   ;06709 
                MOV     DI,0002H                ;0670B 
                MOV     BH,00                   ;0670E 
                MOV     BL,BYTE PTR ES:[DI-01]  ;06710 
                ADD     DI,BX                   ;06714 
                PUSH    CX                      ;06716 
                MOV     AH,05                   ;06717 
                MOV     AL,01                   ;06719 
                MOV     CH,BYTE PTR ES:[DI-03]  ;0671B 
                MOV     CL,01                   ;0671F 
                MOV     DH,00                   ;06721 
                PUSH    CS                      ;06723 
                POP     ES                      ;06724 
                MOV     BX,0836H                ;06725 
                CALL    NEAR PTR s3             ;06728 >>xref=<067b0><<
                POP     CX                      ;0672B 
                JNB     b06733                  ;0672C Jump if >= (no sign)
                LOOP    b066fa                  ;0672E Dec CX;Loop if CX>0
                JMP     SHORT m0679c            ;06730 
                NOP                             ;06732 
b06733:         MOV     CX,0008H                ;06733 
b06736:         POP     DX                      ;06736 
                PUSH    DX                      ;06737 
                PUSH    CX                      ;06738 
                MOV     AX,CS                   ;06739 
                SUB     AX,0020H                ;0673B 
                MOV     ES,AX                   ;0673E 
                MOV     DI,0002H                ;06740 
                MOV     BH,00                   ;06743 
                MOV     BL,BYTE PTR ES:[DI-01]  ;06745 
                ADD     DI,BX                   ;06749 
                MOV     AH,03                   ;0674B 
                MOV     AL,08                   ;0674D 
                MOV     CH,BYTE PTR ES:[DI-03]  ;0674F 
                MOV     CL,BYTE PTR ES:[DI-02]  ;06753 
                MOV     DH,00                   ;06757 
                PUSH    CS                      ;06759 
                POP     ES                      ;0675A 
                MOV     BX,0000H                ;0675B 
                CALL    NEAR PTR s3             ;0675E >>xref=<067b0><<
                POP     CX                      ;06761 
                JNB     b06769                  ;06762 Jump if >= (no sign)
                LOOP    b06736                  ;06764 Dec CX;Loop if CX>0
                JMP     SHORT m0679c            ;06766 
                NOP                             ;06768 
b06769:         MOV     CX,0004H                ;06769 
b0676c:         POP     DX                      ;0676C 
                PUSH    DX                      ;0676D 
                PUSH    CX                      ;0676E 
                MOV     AX,CS                   ;0676F 
                SUB     AX,0020H                ;06771 
                MOV     ES,AX                   ;06774 
                MOV     BX,0000H                ;06776 
                MOV     AH,03                   ;06779 
                MOV     AL,01                   ;0677B 
                MOV     CH,00                   ;0677D 
                MOV     CL,01                   ;0677F 
                MOV     DH,00                   ;06781 
                CALL    NEAR PTR s3             ;06783 >>xref=<067b0><<
                POP     CX                      ;06786 
                JB      b06797                  ;06787 Jump if <  (no sign)
                POP     DX                      ;06789 
                POP     SI                      ;0678A 
                POP     ES                      ;0678B 
                POP     DX                      ;0678C 
                POP     DS                      ;0678D 
                POP     DI                      ;0678E 
                POP     CX                      ;0678F 
                POP     BX                      ;06790 
                POP     BP                      ;06791 Restore Arg Pointer
                POP     AX                      ;06792 
                POPF                            ;06793 Pop flags off Stack
                JMP     NEAR PTR m064fa         ;06794 
b06797:         LOOP    b0676c                  ;06797 Dec CX;Loop if CX>0
                JMP     SHORT m0679c            ;06799 
                NOP                             ;0679B 
m0679c:         POP     DX                      ;0679C 
                POP     SI                      ;0679D 
                POP     ES                      ;0679E 
                POP     DX                      ;0679F 
                POP     DS                      ;067A0 
                POP     DI                      ;067A1 
                POP     CX                      ;067A2 
                POP     BX                      ;067A3 
                POP     BP                      ;067A4 Restore Arg Pointer
                POP     AX                      ;067A5 
                POPF                            ;067A6 Pop flags off Stack
                JMP     DWORD PTR CS:d067ac     ;067A7 
d067ac          EQU     $
                POP     CX                      ;067AC 
                IN      AL,DX                   ;067AD 7f8-7ff:Breakpoint
                ADD     AL,DH                   ;067AE 
s2              ENDP
 
;<067b0>
s3              PROC NEAR
                PUSHF                           ;067B0 Push flags on Stack
                CALL    DWORD PTR CS:d067ac     ;067B1 
                RETN                            ;067B6 
s3              ENDP
 
;<067b7>
s4              PROC NEAR
                PUSH    DX                      ;067B7 
                MOV     AX,CS                   ;067B8 
                SUB     AX,0020H                ;067BA 
                MOV     ES,AX                   ;067BD 
                MOV     DI,0002H                ;067BF 
                MOV     BH,00                   ;067C2 
                MOV     BL,BYTE PTR ES:[DI-01]  ;067C4 
                ADD     DI,BX                   ;067C8 
                CMP     DL,80H                  ;067CA 
                JB      b067e1                  ;067CD Jump if <  (no sign)
                MOV     BYTE PTR ES:[DI-03],00  ;067CF 
                MOV     BYTE PTR ES:[DI-02],02  ;067D4 
                MOV     BYTE PTR ES:[DI-01],80H ;067D9 
                JMP     SHORT b06804            ;067DE 
                NOP                             ;067E0 
b067e1:         MOV     BYTE PTR ES:[DI-02],01  ;067E1 
                MOV     BYTE PTR ES:[DI-01],00  ;067E6 
                MOV     BYTE PTR ES:[DI-03],28H ;067EB 
                MOV     AH,04                   ;067F0 
                MOV     AL,01                   ;067F2 
                MOV     CH,00                   ;067F4 
                MOV     CL,0FH                  ;067F6 
                MOV     DH,00                   ;067F8 
                CALL    NEAR PTR s3             ;067FA >>xref=<067b0><<
                JB      b06804                  ;067FD Jump if <  (no sign)
                MOV     BYTE PTR ES:[DI-03],50H ;067FF 
b06804:         PUSH    DI                      ;06804 
                PUSH    CS                      ;06805 
                POP     DS                      ;06806 
                MOV     SI,0E03H                ;06807 
                MOV     CX,DI                   ;0680A 
                SUB     CX,06                   ;0680C 
                MOV     DI,0003H                ;0680F 
                CLD                             ;06812 Forward String Opers
                REP     MOVSB                   ;06813 Mov DS:[SI]->ES:[DI]
                MOV     SI,0F79H                ;06815 
                MOV     DI,0179H                ;06818 
                MOV     CX,0087H                ;0681B 
                CLD                             ;0681E Forward String Opers
                REP     MOVSB                   ;0681F Mov DS:[SI]->ES:[DI]
                POP     DI                      ;06821 
                MOV     AL,BYTE PTR ES:[DI-03]  ;06822 
                PUSH    CS                      ;06826 
                POP     ES                      ;06827 
                MOV     DI,0836H                ;06828 
                MOV     CX,0008H                ;0682B 
b0682e:         STOSB                           ;0682E Store AL at ES:[DI]
                INC     DI                      ;0682F 
                INC     DI                      ;06830 
                INC     DI                      ;06831 
                LOOP    b0682e                  ;06832 Dec CX;Loop if CX>0
                POP     DX                      ;06834 
                RETN                            ;06835 
;-----------------------------------------------------
                DB      28,00,01,02,28,00       ;06836 (...(.
                DB      02,02,28,00,03,02       ;0683C ..(...
                DB      28,00,04,02,28,00       ;06842 (...(.
                DB      05,02,28,00,06,02       ;06848 ..(...
                DB      28,00,07,02,28,00       ;0684E (...(.
                DB      08,02,1F                ;06854 ...
;-----------------------------------------------------
                DEC     DI                      ;06857 
                ADD     SP,02                   ;06858 
                MOV     WORD PTR [BP-02],AX     ;0685B 
                MOV     AX,WORD PTR DS:d06dc8   ;0685E 
                MOV     WORD PTR DS:d06dc2,AX   ;06861 
                CMP     WORD PTR [BP-02],00     ;06864 
                JE      b0686f                  ;06868 Jump if equal (ZF=1)
                MOV     AX,0857H                ;0686A 
                JMP     SHORT b06872            ;0686D 
;-----------------------------------------------------
b0686f:         DB      0B8,60,08               ;0686F .`.
b06872:         DB      50,9A,98,03,0BA,48      ;06872 P....H
                DB      83,0C4,02,0FF,06,0B6    ;06878 ......
                DB      0DH,0C7,06,0B8,0DH,0F   ;0687E ......
                DB      00,0B8,69,08,50,9A      ;06884 ..i.P.
                DB      98,03,0BA,48,83,0C4     ;0688A ...H..
                DB      02,83,7E,0FE,00,75      ;06890 .....u
                DB      12,0A1,0C8,0DH,0A3,0C2  ;06896 ......
                DB      0DH,0B8,8C,08,50,9A     ;0689C ....P.
                DB      98,03,0BA,48,83,0C4     ;068A2 ...H..
                DB      02,0A1,0C8,0DH,0A3,0C2  ;068A8 ......
                DB      0DH,0B8,91,08,50,9A     ;068AE ....P.
                DB      98,03,0BA,48,83,0C4     ;068B4 ...H..
                DB      02,0B8,96,08,50,9A      ;068BA ....P.
                DB      98,03,0BA,48,83,0C4     ;068C0 ...H..
                DB      02,0C7,06,0B6,0DH,12    ;068C6 ......
                DB      00,0B8,0D0,1BH,50,9A    ;068CC ....P.
                DB      71,03,0BA,48,83,0C4     ;068D2 q..H..
                DB      02,0FF,06,0B6,0DH,0B8   ;068D8 ......
                DB      0F8,1BH,50,9A,71,03     ;068DE ..P.q.
                DB      0BA,48,83,0C4,02,0C7    ;068E4 .H....
                DB      06,0B6,0DH,0F,00,0C7    ;068EA ......
                DB      06,0B8,0DH,23,00,0A1    ;068F0 ...#..
                DB      0C8,0DH,0A3,0C2,0DH,0C7 ;068F6 ......
                DB      06,0BA,0DH,0F,00,0C7    ;068FC ......
                DB      06,0BC,0DH,23,00,0B8    ;06902 ...#..
                DB      04,4A,50,9A,98,03       ;06908 .JP...
                DB      0BA,48,8BH,0E5,5DH,0C3  ;0690E .H..].
                DB      55,8BH,0EC,9A,03,0C     ;06914 U.....
                DB      0C2,36,0C7,06,0B6,0DH   ;0691A .6....
                DB      02,00,0B8,0A8,08,50     ;06920 .....P
                DB      9A,0CBH,04,0C2,36,83    ;06926 ....6.
                DB      0C4,02,0C7,06,0B6,0DH   ;0692C ......
                DB      09,00,0A1,0C8,0DH,0A3   ;06932 ......
                DB      0C2,0DH,0B8,0C2,08,50   ;06938 .....P
                DB      9A,71,03,0BA,48,83      ;0693E .q..H.
                DB      0C4,02,83,06,0B6,0DH    ;06944 ......
                DB      02,0A1,0C8,0DH,0A3,0C2  ;0694A ......
                DB      0DH,0B8,0DF,08,50,9A    ;06950 ....P.
                DB      71,03,0BA,48,83,0C4     ;06956 q..H..
                DB      02,0FF,06,0B6,0DH,0A1   ;0695C ......
                DB      0C8,0DH,0A3,0C2,0DH,0B8 ;06962 ......
                DB      0FE,08,50,9A,71,03      ;06968 ..P.q.
                DB      0BA,48,83,0C4,02,9A     ;0696E .H....
                DB      0BH,00,23,4A,0C7,06     ;06974 ..#J..
                DB      0B6,0DH,13,00,0C7,06    ;0697A ......
                DB      0B8,0DH,00,00,9A,06     ;06980 ......
                DB      00,1C,3DH,8BH,0E5,5DH   ;06986 ..=..]
                DB      0C3,55,8BH,0EC,83,0EC   ;0698C .U....
                DB      3E,0A1,0E6,0DH,89,46    ;06992 >....F
                DB      0C2,48,89,46,0C8,83     ;06998 .H.F..
                DB      3E,0E6,0DH,00,75,3BH    ;0699E >...u;
                DB      0C7,06,0E4,0DH,00,00    ;069A4 ......
                DB      0B8,1C,09,50,0B8,0E4    ;069AA ...P..
                DB      0DH,50,0B8,04,4A,50     ;069B0 .P..JP
                DB      9A,0E,00,8E,37,83       ;069B6 ....7.
                DB      0C4,06,0E8,0B8,05,0BH   ;069BC ......
                DB      0C0,75,09,0E8,4C,0FF    ;069C2 .u..L.
                DB      0B8,01,00,0E9,4C,02     ;069C8 ....L.
                DB      0E8,4DH,02,0BH,0C0,74   ;069CE .M...t
                DB      0F3,9A,56,06,20,3DH     ;069D4 ..V. =
                DB      2BH,0C0,0E9,3BH,02,0C7  ;069DA +..;..
                DB      46,0C4,01,00,0A1,0E6    ;069E0 F.....
                DB      0DH,39,46,0C8,74,25     ;069E6 .9F.t%
                DB      9A                      ;069EC .
;-----------------------------------------------------
                MOV     WORD PTR [BP+DI],3D20H  ;069ED 
                MOV     AX,4A04H                ;069F1 
                PUSH    AX                      ;069F4 
                MOV     AX,0DE4H                ;069F5 
                PUSH    AX                      ;069F8 
                PUSH    WORD PTR DS:d0a96e      ;069F9 
                PUSH    WORD PTR DS:d15a6c      ;069FD 
                SUB     AX,AX                   ;06A01 Load register w/ 
                                                ;     0
;
                MOV     SS,AX                   ;06A03 
;
                MOV     ES,AX                   ;06A05 
;
                MOV     DS,AX                   ;06A07 
                MOV     AX,7C00H                ;06A09 
                MOV     SP,AX                   ;06A0C 
                STI                             ;06A0E Turn ON Interrupts
                MOV     SI,AX                   ;06A0F 
                MOV     DI,7E00H                ;06A11 
                CLD                             ;06A14 Forward String Opers
                MOV     CX,0100H                ;06A15 
                REP     MOVSW                   ;06A18 Mov DS:[SI]->ES:[DI]
                JMP     NEAR PTR m06c1d         ;06A1A 
                MOV     CX,0010H                ;06A1D 
                ASSUME DS:dseg0000
                MOV     SI,WORD PTR DS:d07e85   ;06A20 
b06a24:         TEST    BYTE PTR [SI],80H       ;06A24 Flags=Arg1 AND Arg2
                JNE     b06a31                  ;06A27 Jump not equal(ZF=0)
                SUB     SI,10H                  ;06A29 
                LOOP    b06a24                  ;06A2C Dec CX;Loop if CX>0
                JMP     SHORT b06a67            ;06A2E 
                NOP                             ;06A30 
b06a31:         MOV     DI,07BEH                ;06A31 
                PUSH    DI                      ;06A34 
                MOV     CX,0008H                ;06A35 
                REP     MOVSW                   ;06A38 Mov DS:[SI]->ES:[DI]
                POP     SI                      ;06A3A 
                MOV     BX,7C00H                ;06A3B 
                MOV     DX,WORD PTR [SI]        ;06A3E 
                MOV     CX,WORD PTR [SI+02]     ;06A40 
                MOV     BP,0005H                ;06A43 
b06a46:         MOV     AX,0201H                ;06A46 
                INT     13H                     ;06A49 DSK:02-read sector, 
                                                ;     into ES:BX
                JNB     b06a56                  ;06A4B Jump if >= (no sign)
                SUB     AX,AX                   ;06A4D Load register w/ 
                                                ;     0
                INT     13H                     ;06A4F DSK:00-reset, DL=dri-
                                                ;     ve
                DEC     BP                      ;06A51 
                JE      b06a6d                  ;06A52 Jump if equal (ZF=1)
                JMP     SHORT b06a46            ;06A54 
b06a56:         MOV     SI,7DFEH                ;06A56 
                LODSW                           ;06A59 Load AX with DS:[SI]
                CMP     AX,0AA55H               ;06A5A 
                JNE     b06a73                  ;06A5D Jump not equal(ZF=0)
                MOV     SI,07BEH                ;06A5F 
;
;
;
                DB      0EA,00,7C,00,00 ;(# 5)jmp far ptr m07C00 ;
                                                ;06A62 
                ASSUME DS:sseg
b06a67:         MOV     SI,WORD PTR DS:d0de87   ;06A67 
                JMP     SHORT b06a77            ;06A6B 
b06a6d:         MOV     SI,WORD PTR DS:d0de89   ;06A6D 
                JMP     SHORT b06a77            ;06A71 
b06a73:         MOV     SI,WORD PTR DS:d0de8b   ;06A73 
b06a77:         LODSB                           ;06A77 Load AL with DS:[SI]
                OR      AL,AL                   ;06A78 Set Flags
b06a7a:         JE      b06a7a                  ;06A7A Jump if equal (ZF=1)
                MOV     BX,0007H                ;06A7C 
                MOV     AH,0EH                  ;06A7F 
                INT     10H                     ;06A81 CRT:0e-wr Teletype 
                                                ;     mode,AL=char
                JMP     SHORT b06a77            ;06A83 
;-----------------------------------------------------
                DB      0EE,7F,8DH,7E,0A7,7E    ;06A85 ......
                DB      0C8                     ;06A8B .
                DB      7E,0DH,0A               ;06A8C ...
                DB      'Invalid Partition Tab' ;06A8F 
                DB      'le'                    ;06AA4 
                DB      00,0DH,0A               ;06AA6 ...
                DB      'Error Loading Operati' ;06AA9 
                DB      'ng System'             ;06ABE 
                DB      00,0DH,0A               ;06AC7 ...
                DB      'Missing Operating Sys' ;06ACA 
                DB      'tem'                   ;06ADF 
                DB      26D DUP (00H)           ;06AE2 (.)
                DB      0AA,55                  ;06AFC .U
                DB      192D DUP (00H)          ;06AFE (.)
                DB      80,01,01,00,01,08       ;06BBE ......
                DB      51,0A6,11,00,00,00      ;06BC4 Q.....
                DB      0BE,0FC,00,00,00,00     ;06BCA ......
                DB      41,0A7,51,08,0D1,9BH    ;06BD0 A.Q...
                DB      0CF,0FC,00,00,6DH,2BH   ;06BD6 ....m+
                DB      01                      ;06BDC .
                DB      33D DUP (00H)           ;06BDD (.)
                DB      55,0AA                  ;06BFE U.
                DB      29D DUP (0F6H)          ;06C00 (.)
m06c1d:         DB      421D DUP (0F6H)         ;06C1D (.)
d06dc2          DB      6D DUP (0F6H)           ;06DC2 (.)
d06dc8          DB      56D DUP (0F6H)          ;06DC8 (.)
                DB      0EBH,3C,90,4DH,53,44    ;06E00 .<.MSD
                DB      4F,53,35,2E,30,00       ;06E06 OS5.0.
                DB      02,02,01,00,02,70       ;06E0C .....p
                DB      00,0D0,02,0FDH,02,00    ;06E12 ......
                DB      09,00,02                ;06E18 ...
                DB      11D DUP (00H)           ;06E1B (.)
                DB      29,0F7,10,27,1C         ;06E26 )..'.
                DB      'JOSHI      FAT12   '   ;06E2B 
;-----------------------------------------------------
                CLI                             ;06E3E Turn OFF Interrupts
                XOR     AX,AX                   ;06E3F Load register w/ 
                                                ;     0
;
                MOV     SS,AX                   ;06E41 
                MOV     SP,7C00H                ;06E43 
                PUSH    SS                      ;06E46 
                POP     ES                      ;06E47 
                MOV     BX,0078H                ;06E48 
                LDS     SI,DWORD PTR SS:[BX]    ;06E4B 
                PUSH    DS                      ;06E4E 
                PUSH    SI                      ;06E4F 
                PUSH    SS                      ;06E50 
                PUSH    BX                      ;06E51 
                MOV     DI,7C3EH                ;06E52 
                MOV     CX,000BH                ;06E55 
                CLD                             ;06E58 Forward String Opers
                REP     MOVSB                   ;06E59 Mov DS:[SI]->ES:[DI]
                PUSH    ES                      ;06E5B 
                POP     DS                      ;06E5C 
                MOV     BYTE PTR [DI-02],0FH    ;06E5D 
                MOV     CX,WORD PTR DS:d0dc18   ;06E61 
                MOV     BYTE PTR [DI-07],CL     ;06E65 
                MOV     WORD PTR [BX+02],AX     ;06E68 
                MOV     WORD PTR [BX],7C3EH     ;06E6B 
                STI                             ;06E6F Turn ON Interrupts
                INT     13H                     ;06E70 DSK:00-reset, DL=dri-
                                                ;     ve
                JB      b06eed                  ;06E72 Jump if <  (no sign)
                XOR     AX,AX                   ;06E74 Load register w/ 
                                                ;     0
                CMP     WORD PTR DS:d0dc13,AX   ;06E76 
                JE      b06e84                  ;06E7A Jump if equal (ZF=1)
                MOV     CX,WORD PTR DS:d0dc13   ;06E7C 
                MOV     WORD PTR DS:d0dc20,CX   ;06E80 
b06e84:         MOV     AL,BYTE PTR DS:d0dc10   ;06E84 
                MUL     WORD PTR DS:d0dc16      ;06E87 
                ADD     AX,WORD PTR DS:d0dc1c   ;06E8B 
                ADC     DX,WORD PTR DS:d0dc1e   ;06E8F 
                ADD     AX,WORD PTR DS:d0dc0e   ;06E93 
                ADC     DX,00                   ;06E97 
                MOV     WORD PTR DS:d0dc50,AX   ;06E9A 
                MOV     WORD PTR DS:d0dc52,DX   ;06E9D 
                MOV     WORD PTR DS:d0dc49,AX   ;06EA1 
                MOV     WORD PTR DS:d0dc4b,DX   ;06EA4 
                MOV     AX,0020H                ;06EA8 
                MUL     WORD PTR DS:d0dc11      ;06EAB 
                MOV     BX,WORD PTR DS:d0dc0b   ;06EAF 
                ADD     AX,BX                   ;06EB3 
                DEC     AX                      ;06EB5 
                DIV     BX                      ;06EB6 
                ADD     WORD PTR DS:d0dc49,AX   ;06EB8 
                ADC     WORD PTR DS:d0dc4b,00   ;06EBC 
                MOV     BX,0500H                ;06EC1 
                MOV     DX,WORD PTR DS:d0dc52   ;06EC4 
                MOV     AX,WORD PTR DS:d0dc50   ;06EC8 
                CALL    NEAR PTR s6             ;06ECB >>xref=<06f60><<
                JB      b06eed                  ;06ECE Jump if <  (no sign)
                MOV     AL,01                   ;06ED0 
                CALL    NEAR PTR s7             ;06ED2 >>xref=<06f81><<
                JB      b06eed                  ;06ED5 Jump if <  (no sign)
                MOV     DI,BX                   ;06ED7 
                MOV     CX,000BH                ;06ED9 
                MOV     SI,7DE6H                ;06EDC 
                REPZ    CMPSB                   ;06EDF Flgs=DS:[SI]-ES:[DI]
                JNE     b06eed                  ;06EE1 Jump not equal(ZF=0)
                LEA     DI,WORD PTR [BX+20H]    ;06EE3 Load Memory OFFSET
                MOV     CX,000BH                ;06EE6 
                REPZ    CMPSB                   ;06EE9 Flgs=DS:[SI]-ES:[DI]
                JE      b06f05                  ;06EEB Jump if equal (ZF=1)
b06eed:         MOV     SI,7D9EH                ;06EED 
                CALL    NEAR PTR CRT0e          ;06EF0 >>xref=<06f52><<
                                                ;    ;wr Teletype mode,AL=c-
                                                ;     har
                XOR     AX,AX                   ;06EF3 Load register w/ 
                                                ;     0
                INT     16H                     ;06EF5 KBD:00-read char, 
                                                ;     AL=char
                POP     SI                      ;06EF7 
                POP     DS                      ;06EF8 
                POP     WORD PTR [SI]           ;06EF9 
                POP     WORD PTR [SI+02]        ;06EFB 
                INT     19H                     ;06EFE Bootstrap BIOS
                POP     AX                      ;06F00 
                POP     AX                      ;06F01 
                POP     AX                      ;06F02 
                JMP     SHORT b06eed            ;06F03 
;-----------------------------------------------------
b06f05:         DB      8BH,47,1A,48,48,8A      ;06F05 .G.HH.
                DB      1E,0DH,7C,32,0FF,0F7    ;06F0B ..|2..
                DB      0E3,03,06,49,7C,13      ;06F11 ...I|.
                DB      16,4BH,7C,0BBH,00,07    ;06F17 .K|...
                DB      0B9,03,00,50,52,51      ;06F1D ...PRQ
                DB      0E8,3A,00,72,0D8,0B0    ;06F23 .:.r..
                DB      01,0E8,54,00,59,5A      ;06F29 ..T.YZ
                DB      58,72,0BBH,05,01,00     ;06F2F Xr....
                DB      83,0D2,00,03,1E,0BH     ;06F35 ......
                DB      7C,0E2,0E2,8A,2E,15     ;06F3B |.....
                DB      7C,8A,16,24,7C,8BH      ;06F41 |..$|.
                DB      1E,49,7C,0A1,4BH,7C     ;06F47 .I|.K|
                DB      0EA,00                  ;06F4D ..
;-----------------------------------------------------
                ADD     BYTE PTR [BX+SI+00],DH  ;06F4F 
s4              ENDP
 
;<06f52> wr Teletype mode,AL=char
CRT0e           PROC NEAR
                LODSB                           ;06F52 Load AL with DS:[SI]
                OR      AL,AL                   ;06F53 Set Flags
                JE      b06f80                  ;06F55 Jump if equal (ZF=1)
                MOV     AH,0EH                  ;06F57 
                MOV     BX,0007H                ;06F59 
                INT     10H                     ;06F5C CRT:0e-wr Teletype 
                                                ;     mode,AL=char
                JMP     SHORT CRT0e             ;06F5E >>xref=<06f52><<
                                                ;    ;wr Teletype mode,AL=c-
                                                ;     har
CRT0e           ENDP
 
;<06f60>
s6              PROC NEAR
                CMP     DX,WORD PTR DS:d0dc18   ;06F60 
                JNB     b06f7f                  ;06F64 Jump if >= (no sign)
                DIV     WORD PTR DS:d0dc18      ;06F66 
                INC     DL                      ;06F6A 
                MOV     BYTE PTR DS:d0dc4f,DL   ;06F6C 
                XOR     DX,DX                   ;06F70 Load register w/ 
                                                ;     0
                DIV     WORD PTR DS:d0dc1a      ;06F72 
                MOV     BYTE PTR DS:d0dc25,DL   ;06F76 
                MOV     WORD PTR DS:d0dc4d,AX   ;06F7A 
                CLC                             ;06F7D 
;
                RETN                            ;06F7E 
b06f7f:         STC                             ;06F7F 
b06f80:         RETN                            ;06F80 
s6              ENDP
 
;<06f81>
s7              PROC NEAR
                MOV     AH,02                   ;06F81 
                MOV     DX,WORD PTR DS:d0dc4d   ;06F83 
                MOV     CL,06                   ;06F87 
                SHL     DH,CL                   ;06F89 Multiply by 2's
                OR      DH,BYTE PTR DS:d0dc4f   ;06F8B 
                MOV     CX,DX                   ;06F8F 
                XCHG    CH,CL                   ;06F91 
                MOV     DL,BYTE PTR DS:d0dc24   ;06F93 
                MOV     DH,BYTE PTR DS:d0dc25   ;06F97 
                INT     13H                     ;06F9B DSK:02-read sector, 
                                                ;     into ES:BX
                RETN                            ;06F9D 
;-----------------------------------------------------
                DB      0DH,0A                  ;06F9E ..
                DB      'Non-System disk or di' ;06FA0 
                DB      'sk error'              ;06FB5 
                DB      0DH,0A                  ;06FBD ..
                DB      'Replace and press any' ;06FBF 
                DB      ' key when ready'       ;06FD4 
                DB      0DH,0A,00               ;06FE3 ...
                DB      'IO      SYSMSDOS   SY' ;06FE6 
                DB      'S'                     ;06FFB 
                DB      00,00                   ;06FFC ..
                DB      55,0AA                  ;06FFE U.
                DB      512D DUP (00H)          ;07000 (.)
s7              ENDP
 
sseg            ENDS
 
M07c00          EQU     07C00H 
d07e85          EQU     07E85H 
d0a96e          EQU     0496EH 
d0dc0b          EQU     07C0BH 
d0dc0e          EQU     07C0EH 
d0dc10          EQU     07C10H 
d0dc11          EQU     07C11H 
d0dc13          EQU     07C13H 
d0dc16          EQU     07C16H 
d0dc18          EQU     07C18H 
d0dc1a          EQU     07C1AH 
d0dc1c          EQU     07C1CH 
d0dc1e          EQU     07C1EH 
d0dc20          EQU     07C20H 
d0dc24          EQU     07C24H 
d0dc25          EQU     07C25H 
d0dc49          EQU     07C49H 
d0dc4b          EQU     07C4BH 
d0dc4d          EQU     07C4DH 
d0dc4f          EQU     07C4FH 
d0dc50          EQU     07C50H 
d0dc52          EQU     07C52H 
d0de87          EQU     07E87H 
d0de89          EQU     07E89H 
d0de8b          EQU     07E8BH 
d15a6c          EQU     0FA6CH 
db8000          EQU     00000H 
db804e          EQU     0004EH 
db8780          EQU     00780H 
db87ce          EQU     007CEH 
                END     o06000
 