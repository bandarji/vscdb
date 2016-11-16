                                                                              (*
   What you now have in your hard drive, and are looking at,  is the Source
   Code to the "Havoc The Chaos" Loader.  It demonstrates the direct screen
   writes in Pascal (Which is easily portable to other languages).            *)


Program HavocTheChaosLoader;                                          {$R-,S-}

Uses Crt, Dos;

Var Row, Column, C1, C2  : Integer;
    Color,Ccolor,Cccolor : Byte;
    Ch                   : Char;

Procedure PutPixel (X, Y : Word; Color : Byte);
Begin
  Mem [$A000 : Y*320+X]:=Color;
End;

Procedure Switch (Var First, Second : Integer);
Var Temp : Integer;
Begin
  Temp:=First;
  First:=Second;
  Second:=Temp;
End;

Procedure Line (X1, Y1, X2, Y2, Color : Integer);
Var  LgDelta, ShDelta, LgStep, ShStep, Cycle, PointAddr : Integer;
Begin
  LgDelta:=X2-X1;
  ShDelta:=Y2-Y1;
  If LgDelta < 0 Then
  Begin
    LgDelta:=-LgDelta;
    LgStep:=-1;
  End
  Else
    LgStep:=1;
  If ShDelta < 0 Then
  Begin
    ShDelta:=-ShDelta;
    ShStep:=-1;
  End
  Else
    ShStep:=1;
  If LgDelta > ShDelta Then
  Begin
    Cycle:=LgDelta Shr 1;                                      { LgDelta / 2 }
    While X1 <> X2 Do
    Begin
      Mem [$A000 : Y1*320+X1]:=Color;             { PutPixel(X1, Y1, Color); }
      Inc (X1, LgStep);
      Inc (Cycle, ShDelta);
      If Cycle > LgDelta Then
      Begin
        Inc (Y1, ShStep);
        Dec (Cycle, LgDelta);
      End;
    End;
  End
  Else
  Begin
    Cycle:=ShDelta Shr 1;                                      { ShDelta / 2 }
    Switch (LgDelta, ShDelta);
    Switch (LgStep, ShStep);
    While Y1 <> Y2 Do
    Begin
      Mem [$A000 : Y1*320+X1]:=Color;             { PutPixel(X1, Y1, Color); }
      Inc (Y1, LgStep);
      Inc (Cycle, ShDelta);
      If Cycle > LgDelta Then
      Begin
        Inc (X1, ShStep);
        Dec (Cycle, LgDelta);
      End;
    End;
  End;
End;

Procedure SetMode (Mode : Byte);   { INT 10, Sub-Function 0 - Set Video Mode }
Var Regs : Registers;
Begin
  With Regs Do
  Begin
    AH:=0;
    AL:=Mode;
  End;
  INTR ($10, Regs);
End;

(* Actual Process Begins Here *)

Begin
  SetMode ($13);             { 320x200 256 Color Mode For VGA and MCGA Cards }
  C1:=1;
  C2:=1;
  Ccolor:=43;
  Ccolor:=1;
  Repeat
    PutPixel (C1, C2, 16);
    Inc (C1);
    Dec (C2);
    Inc (Ccolor);
    If Ccolor >= 50 Then Ccolor:=44;
    For Row:=125 To 135 Do             { Draw Some Lines }
    Begin
      Line (0, Row, 319, Row, Ccolor);
      Dec (Ccolor);
    End;
    For Row:=65 To 75 Do
    Begin
      Line (0, Row, 319, Row, Ccolor);
      Inc (Ccolor);
    End;
    

    (* The Sole Pixel (tm) *)
    PutPixel (C1, C2, 1);
    Delay (10);
    Color:=1;
    

    (* The Letter H *)
    For Row:=85 To 115 Do
    Begin
      For Column:=17 To 22 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=12 To 17 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=6 To 12 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter A *)
    For Row:=85 To 115 Do
    Begin
      For Column:=28 To 34 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 91 Do
    Begin
      For Column:=34 To 40 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=34 To 40 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=40 To 46 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter V *)
    For Row:=85 To 110 Do
    Begin
      For Column:=52 To 58 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=104 To 115 Do
    Begin
      For Column:=58 To 64 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 110 Do
    Begin
      For Column:=64 To 70 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter O *)
    For Row:=85 To 115 Do
    Begin
      For Column:=76 To 82 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 92 Do
    Begin
      For Column:=82 To 88 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=82 To 88 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=88 To 94 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter C *)
    For Row:=85 To 115 Do
    Begin
      For Column:=100 To 106 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 92 Do
    Begin
      For Column:=106 To 112 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=106 To 112 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter T *)
    For Row:=85 To 92 Do
    Begin
      For Column:=124 To 142 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=130 To 136 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter H *)
    For Row:=85 To 115 Do
    Begin
      For Column:=148 To 154 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=154 To 160 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=160 To 166 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter E *)
    For Row:=85 To 115 Do
    Begin
      For Column:=172 To 178 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 92 Do
    Begin
      For Column:=178 To 184 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=178 To 184 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=178 To 184 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter C *)
    For Row:=85 To 115 Do
    Begin
      For Column:=196 To 202 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 91 Do
    Begin
      For Column:=202 To 208 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=202 To 208 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter H *)
    For Row:=85 To 115 Do
    Begin
      For Column:=214 To 220 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=220 To 226 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=226 To 232 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter A *)
    For Row:=85 To 115 Do
    Begin
      For Column:=238 To 244 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 91 Do
    Begin
      For Column:=244 To 250 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=244 To 250 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=250 To 256 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter O *)
    For Row:=85 To 115 Do
    Begin
      For Column:=262 To 268 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 91 Do
    Begin
      For Column:=268 To 274 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=268 To 274 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 115 Do
    Begin
      For Column:=274 To 280 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    

    (* The Letter S *)
    For Row:=85 To 103 Do
    Begin
      For Column:=286 To 292 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=85 To 91 Do
    Begin
      For Column:=286 To 305 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=103 To 115 Do
    Begin
      For Column:=300 To 305 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=97 To 103 Do
    Begin
      For Column:=286 To 305 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    For Row:=109 To 115 Do
    Begin
      For Column:=286 To 305 Do
      Begin
        PutPixel (Column, Row, Cccolor);
      End;
    End;
    
    Inc (Cccolor);
    Color:=30;
  Until KeyPressed ;
  ReadLn;
  Color:=16;
  Ccolor:=15;
  For Row:=1 To 200 Do                                     { Draw Some Lines }
  Begin
    Line (0, Row, 319, Row, Ccolor);
    Delay (10);
  End;
  Color:=200;
  For Row:=1 to 99 Do
  Begin
    Line (0, Row, 319, Row, 16);
    Delay (5);
    Line (0, Color, 319, Color, 16);
    Delay (5);
    Dec (Color);
  End;
  Column:=319;
  For Row:=1 to 160 Do
  Begin
    PutPixel (Row, 100, 16);
    PutPixel (Row, 101, 16);
    Delay (5);
    PutPixel (Column, 100, 16);
    PutPixel (Column, 101, 16);
    Delay (5);
    Dec (Column);
  End;

  Delay (250);

  SetMode ($3);
  WriteLn ('Coded by Havoc The Chaos on 06/07/93 in 4 Hours with the Sole Pixel (tm)');
End.
