program odstraneni_viru_1028;
uses dos;

const ident:array[0..4] of byte=($b8,$9b,$03,$e1,$fd);

var sr:SearchRec;
    f:file;
    p:pointer;
    x:registers;
    ww,w:word;   { ww=segment }
{ ���������������������������������������������������������� }
type
   typEXEHead=record    { hlavicka EXE souboru }
                   Sign:word;     { hlavicka EXE ($5a4d) }
                   PartPag:word;  { pocet byte v posledni strance }
                   PageCnt:word;  { pocet stranek pgmu po 512 bytech }
                   ReloCnt:word;  { pocet polozek v relokacni tabulce }
                   HdrSize:word;  { velikost hlavicky v paragrafech }
                   MinMem:word;   { min pamet pozadovana pgmem }
                   MaxMem:word;   { max pamet pozadovana pgmem }
                   ReloSS:word;   { segment offset pro SS }
                   ExeSP:word;    { hodnota pro SP }
                   ChkSum:word;   { negovany soucet souboru }
                   ExeIP:word;    { segment offset pro CS }
                   ReloCS:word;   { hodnota pro IP }
                   TablOff:word;  { offset pro prvni polozku v relokacni tab }
                   Ovlnum:word    { pocet overlay }
              end;

{ ���������������������������������������������������������� }
function comp_1 (var a;  { zdroj 1 }
                 var b;  { zdroj 2 zmenseny o 1 }
                     pocet:word { pocet prvku pro porovnani }
                ):boolean;
assembler;
asm
           push ds
           lds si, [b]
           les di, [a]
           mov cx, [pocet]
           cld
@opakuj:   lodsb
           inc al
           scasb
           jnz @jine
           loop @opakuj
           mov al, 1             { true }
           jmp @konec
@jine:     xor al, al            { false }
@konec:    pop ds
end;
{ ���������������������������������������������������������� }


procedure Odstran_V_1028 (var f:file);
var vir:array[0..$20] of byte;
    data:record
           EXEIP:word;
           ReloCS:word;
           EXESP:word;
           ReloSS:word;
           delka:word; { dolni slovo delky }
           PageCnt:word;
           zacatek:longint;
        end absolute vir;
    hl:typEXEHead;
    com:record
           jmp:byte;
           adresa:word;
        end absolute hl;
    delka:longint;
    startadr:longint;
    datum:longint;
    attribut:word;
begin
seek (f,0);
BlockRead (f,hl,SizeOf(hl));
if hl.sign=$5a4d then { EXE }
                      startadr:=16*(longint(hl.ReloCS)+longint(hl.HdrSize))
                                +longint(hl.EXEIP)-$64
                 else { COM }
                      if com.jmp<>$e9 then exit
                                      else startadr:=com.adresa+3-$64;
if (startadr<0) or ((startadr+$404) >FileSize(f)) then exit;
seek (f,startadr);
BlockRead (f,vir,SizeOf(vir));
if not(comp_1(vir[$f],ident,SizeOf(ident))) then exit;
writeln ('     Soubor nakazen');
seek (f,startadr+$3f4);
BlockRead (f,data,SizeOf(data));
GetFattr (f,attribut);
SetFattr (f,0);
GetFTime (f,datum);
FileMode:=2;
reset (f,1);
if hl.sign=$5a4d then begin  { EXE }
                      hl.ReloCS:=data.ReloCS;
                      hl.EXEIP:=data.EXEIP;
                      hl.ReloSS:=data.ReloSS;
                      hl.EXESP:=data.EXESP;
                      hl.PageCnt:=data.PageCnt;
                      hl.PartPag:=data.delka mod 512;
                      delka:=longint(data.PageCnt-1)*512+longint(hl.PartPag);
                      BlockWrite (f,hl,SizeOf(hl));
                      end
                 else begin
                      delka:=data.delka;
                      BlockWrite (f,data.zacatek,3);
                      end;
Seek(f,delka);
Truncate (f);
SetFTime (f,datum);
SetFAttr (f,attribut);
end;
{ ���������������������������������������������������������� }

begin
writeln ('Program hleda a odstranuje vir V-1028');
writeln ('Prochazi pracovni adresar. Nejsou osetreny I/O chyby');
writeln;
{ detekce v pameti }
x.ax:=$4bfe;
intr ($21,x);
if x.di=$55bb then begin
                   writeln (#7,'Virus nalezen v pameti');
                   ww:=memw[0:($21*4+2)];
                   w:=memw[0:($21*4)];
                   p:=ptr(ww,w-$148+$f);
                   if (w=$148) and
                      comp_1(p^,ident,sizeof(ident))  then begin
                                 inline ($fa  { CLI } );
                                 memw[ww:$15e]:=$edeb;
                                 inline ($fb  { STI } );
                                 end;
                   end;
FindFirst ('*.COM',AnyFile xor Directory xor VolumeID,sr);
while DosError=0 do begin
      writeln (sr.name);
      assign (f,sr.name);
      FileMode:=0;
      reset (f,1);
      Odstran_V_1028 (f);
      FindNext (sr);
      end;
FindFirst ('*.EXE',AnyFile xor Directory xor VolumeID,sr);
while DosError=0 do begin
      writeln (sr.name);
      assign (f,sr.name);
      FileMode:=0;
      reset (f,1);
      Odstran_V_1028 (f);
      FindNext (sr);
      end;
end.
