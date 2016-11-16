{
  Demonstrates formatting a floppy disk from Turbo Pascal.
  This version only formats DSDD 9 sector floppies (360KB).
  Works with DOS 2.0 or 3.0 in either 360K or 1.2M drives.
  Does not support a /S option.
  Supports a /N or -N option that turns off the verify after format.
  Turn off verify step and obtain a 2x speedup vs. DOS format.

  Requires Turbo version 3.0 to compile. Compile with Minheap=Maxheap=$200.
  Requires a cloning procedure after being compiled to a .COM file.
  The cloning procedure copies the boot sector of an already-formatted
  floppy into the program, where it can be used thereafter. To clone,
  call the program as follows:

  FMAT @ 

  Written 10/26/85. Kim Kokkonen, TurboPower Software.
  Compuserve 72457,2131. (408)-378-3672.
  }

PROGRAM fmat;
    {-format a disk, DSDD 9 sectors per track only}
  TYPE
    {holds sector data during sector setup after formatting}
    SectorBuffer = ARRAY[1..512] OF Char;
    {same size as sector buffer but easily initialized in code segment}
    FakeSectorBuffer = RECORD
                         l, h : STRING[255];
                       END;
    FormatRecord = RECORD
                     cyl, hed, rec, num : Byte;
                   END;
    FormatArray = ARRAY[1..18] OF FormatRecord;
    DiskBaseRec = RECORD
                    unk1, unk2, mtr, bps, eot, gpl,
                    dtl, glf, fbf, hst, mst : Byte;
                  END;
    DiskBasePtr = ^DiskBaseRec;
    registers = RECORD
                  CASE Integer OF
                    1 : (ax, bx, cx, dx, bp, si, di, ds, es, flags : Integer);
                    2 : (al, ah, bl, bh, cl, ch, dl, dh : Byte);
                END;
    FATtable = ARRAY[0..1023] OF Byte;

  CONST
    {bootrecord is customized after the .COM file is created.
    call FMAT with a single command line parameter '@' as follows:
    FMAT @ . This will fill in bootrecord with a real boot record}
    BootRecord : FakeSectorBuffer = {fill in with bootrecord}
    (l : ''; h : '');

  VAR
    reg : registers;
    SB : SectorBuffer;        {will fill in with dir sectors}
    BR : SectorBuffer ABSOLUTE BootRecord;
    VB : ARRAY[1..9] OF SectorBuffer; {will use for fast verify}
    FMT : FormatArray;
    FAT : FATtable;
    drName : STRING[2];
    param : STRING[10];
    drive, dType : Byte;
    ch : Char;
    doVerify : Boolean;
    BiosDiskBase : DiskBasePtr ABSOLUTE 0 : $78;
    OldDiskBase : DiskBasePtr;
    i, error : Integer;
    tavail : Integer;
    bavail : Real;

  PROCEDURE BIOSreadSectors(funct, drive : Byte;
                            sector, track, head : Integer;
                            sects : Integer;
                            VAR buffer;
                            VAR error : Integer);
      {-execute int 13 to read disk or verify via BIOS at low level}
    BEGIN
      reg.ax := (funct SHL 8) OR sects;
      reg.dl := drive;
      reg.dh := head;
      reg.ch := track AND 255;
      reg.cl := (sector AND 63) OR ((track SHR 8) SHL 6);
      reg.es := Seg(buffer);
      reg.bx := Ofs(buffer);
      Intr($13, reg);
      IF Odd(reg.flags AND 1) THEN
        error := reg.ax SHR 8
      ELSE
        error := 0;
    END {biosreadsectors} ;

  PROCEDURE BIOSwriteSectors(drive : Byte;
                             sector, track, head : Integer;
                             sects : Integer;
                             VAR buffer : SectorBuffer;
                             VAR error : Integer);
      {-execute int 13 to write disk via BIOS at low level}
    BEGIN
      reg.ax := $300 OR sects;
      reg.dl := drive;
      reg.dh := head;
      reg.ch := track AND 255;
      reg.cl := (sector AND 63) OR ((track SHR 8) SHL 6);
      reg.es := Seg(buffer);
      reg.bx := Ofs(buffer);
      Intr($13, reg);
      IF Odd(reg.flags AND 1) THEN BEGIN
        error := reg.ax SHR 8;
        WriteLn('error during format...');
        Halt;
      END ELSE
        error := 0;
    END {bioswritesectors} ;

  PROCEDURE InitBoot;
      {-self-customize this program to hold the boot record}
    VAR
      ch : Char;
      error : Integer;
      f : FILE;
      tries : Byte;

    FUNCTION CodeSize : Integer;
        {thanks to Bob Tolz and Randy Forgaard for this function}
      VAR
        i : Byte;
      BEGIN
        i := 11;
        WHILE NOT((Mem[DSeg-2 : i+3] <> $00E9) AND (MemW[DSeg-2 : i+4] = $0000)) AND
        NOT((MemW[DSeg-2 : i+0] = $00E9) AND (MemW[DSeg-2 : i+2] = $E800)) DO
          i := i+1;
        CodeSize := ((((DSeg-2)-CSeg) SHL 4)+i+6)-$100
      END {CodeSize} ;

    BEGIN
      WriteLn('You will now clone a copy of the boot record into this program...');
      WriteLn('The completed version will be written to FMAT.COM');
      Write('Place a DOS formatted disk in drive A: and press any key when ready ');
      Read(Kbd, ch);
      WriteLn;
      {read the boot record}
      tries := 0;
      REPEAT
        tries := Succ(tries);
        BIOSreadSectors(2, 0, 1, 0, 0, 1, BR, error);
      UNTIL (error = 0) OR (tries = 3);
      IF error <> 0 THEN BEGIN
        WriteLn('could not read boot record');
        Halt;
      END;
      {clone this program}
      Assign(f, 'FMAT.COM');
      Rewrite(f, 1);
      BlockWrite(f, Mem[CSeg : $100], CodeSize);
      Close(f);
      Halt;
    END {initboot} ;

  FUNCTION DOSversion : Byte;
      {-return the major version number of DOS}
    BEGIN
      reg.ah := $30;
      MsDos(reg);
      DOSversion := reg.al;
    END {dosversion} ;

  FUNCTION ATmachine : Boolean;
      {-return true if machine is AT class}
    VAR
      machtype : Byte ABSOLUTE $FFFF : $000E;
    BEGIN
      ATmachine := (machtype = $FC);
    END {ATmachine} ;

  PROCEDURE readDASD(drive : Byte; VAR dType : Byte);
      {-read dasd for DOS 3}
      {-whatever dasd is!}
    BEGIN
      reg.ah := $15;
      reg.dl := drive;
      Intr($13, reg);
      IF Odd(reg.flags AND 1) THEN BEGIN
        WriteLn('error reading DASD for format...');
        Halt;
      END;
      dType := reg.ah;
    END {readdasd} ;

  PROCEDURE setDASD(drive, dType : Byte);
      {-execute int 13 to "set DASD" for format of 360K disks on 1.2MB floppies}
    VAR
      tries : Byte;
    BEGIN
      tries := 0;
      REPEAT
        tries := Succ(tries);
        reg.ah := $17;
        reg.al := dType;
        reg.dl := drive;
        Intr($13, reg);
      UNTIL (tries = 3) OR NOT(Odd(reg.flags AND 1));

      IF Odd(reg.flags AND 1) THEN BEGIN
        WriteLn('error setting DASD for format...');
        Halt;
      END;
    END {setdasd} ;

  PROCEDURE InitFAT;
      {-initialize a FAT sector}
    BEGIN
      {fill fat with all zeros}
      FillChar(FAT, 1024, 0);
      {fill in the ID Bytes}
      FAT[0] := $FD;          {9 sector DSDD drive}
      FAT[1] := $FF;          {boilerplate}
      FAT[2] := $FF;
      tavail := 80;
    END {initfat} ;

  PROCEDURE InitDiskBase;
      {-modify the disk base data per DOS 3 instructions}
    BEGIN
      {save old pointer}
      OldDiskBase := BiosDiskBase;
      {make a new disk base data area}
      New(BiosDiskBase);
      {put the data from the old area in the new one}
      BiosDiskBase^ := OldDiskBase^;
      {modify per dos 3 instructions, doesn't hurt on DOS 2}
      BiosDiskBase^.glf := $50;
      BiosDiskBase^.eot := 9;
    END {initdiskbase} ;

  PROCEDURE Format(drive : Byte; VAR FMT : FormatArray; VAR error : Integer);
      {-lay down format tracks}
    VAR
      i : Integer;
    BEGIN
      {initialize format table}
      FOR i := 1 TO 9 DO
        WITH FMT[i] DO BEGIN
          cyl := 0;           {cylinder number, will fill in during format}
          hed := 0;           {head number}
          rec := i;           {sector number}
          num := 2;           {indicates 512 bytes per sector}
        END;
      FOR i := 1 TO 9 DO
        WITH FMT[i+9] DO BEGIN
          cyl := 0;           {cylinder number, will fill in during format}
          hed := 1;           {head number}
          rec := i;           {sector number}
          num := 2;           {indicates 512 bytes per sector}
        END;
      {write the format information}
      INLINE(
        $8A/$56/$0C/          {MOV    DL,[BP+0C] - get drive number}
        $C4/$5E/$08/          {LES    BX,[BP+08] - get pointer to format array}
        $B9/$01/$00/          {MOV    CX,0001 - track 0 sector 1}

        {nexttrack: - loop over 40 disk tracks}
        $8B/$FB/              {MOV    DI,BX - index into format array}
        $B0/$12/              {MOV    AL,12 - number of sectors per track = 18}

        {inittrack: - loop over 18 sectors per track}
        $26/$88/$2D/          {MOV    ES:[DI],CH - track track number in format array}
        $81/$C7/$04/$00/      {ADD    DI,0004}
        $FE/$C8/              {DEC    AL}
        $75/$F5/              {JNZ    inittrack}

        $B6/$00/              {MOV    DH,00 - format 9 sectors on side 0}
        $B8/$01/$05/          {MOV    AX,0501}
        $CD/$13/              {INT    13}
        $72/$18/              {JB     error - check for errors}

        $B6/$01/              {MOV    DH,01 - format 9 sectors on side 1}
        $B8/$01/$05/          {MOV    AX,0501}
        $53/                  {PUSH    BX}
        $81/$C3/$24/$00/      {ADD    BX,0024}
        $CD/$13/              {INT    13}
        $72/$0A/              {JB     error - check for errors}

        $5B/                  {POP    BX}
        $FE/$C5/              {INC    CH - next track}
        $80/$FD/$28/          {CMP    CH,28}
        $75/$D2/              {JNZ    nexttrack}

        $31/$C0/              {XOR    AX,AX - no errors, return 0}

        {error:}
        $C4/$7E/$04/          {LES    DI,[BP+04]}
        $26/$89/$05           {MOV    ES:[DI],AX - return error code}
        );
    END {format} ;

  PROCEDURE Verify(drive : Byte; VAR FAT : FATtable; VAR error : Integer);
      {-verify that sectors were formatted}
    VAR
      t, h : Integer;
      cluster, fatofs, topcluster, content : Integer;
    BEGIN
      {initialize the verify buffer - 9 sectors * 512 bytes}
      FillChar(VB, 4608, $F6);
      {verify all sectors}
      FOR t := 0 TO 39 DO
        FOR h := 0 TO 1 DO BEGIN
          BIOSreadSectors(4, drive, 1, t, h, 9, VB, error);

          IF error <> 0 THEN BEGIN
            {mark the clusters on this track as unavailable}
            cluster := ((9*(h+2*t)) DIV 2)-4;
            topcluster := cluster+5;
            WHILE cluster < topcluster DO BEGIN
              fatofs := (3*cluster) DIV 2;
              {get a word from the FAT}
              Move(FAT[fatofs], content, 2);
              {replace 12 bits of the word}
              IF Odd(cluster) THEN
                content := content OR $FF70
              ELSE
                content := content OR $0FF7;
              {store it back}
              Move(content, FAT[fatofs], 2);
              cluster := Succ(cluster);
            END;

            {reduce the number of tracks available}
            tavail := Pred(tavail);
          END;
        END;
    END {verify} ;

  PROCEDURE InitDIR;
      {-initialize a sector for the root directory}
    VAR
      i : Integer;
    BEGIN
      {fill with format bytes}
      FillChar(SB, 512, $F6);
      {mark each directory entry as available}
      FOR i := 1 TO 481 DO
        IF ((i-1) MOD 32) = 0 THEN SB[i] := #0;
    END {initdir} ;

  BEGIN

    doVerify := True;

    {get the drive and doverify option}
    IF ParamCount = 0 THEN BEGIN
      Write('Enter drive to format: ');
      ReadLn(drName);
    END ELSE BEGIN
      {read the command line parameters}
      i := 1;
      drName := '';
      WHILE i <= ParamCount DO BEGIN
        param := ParamStr(i);
        CASE param[1] OF
          '@' : InitBoot;     {clone the boot record into this program}
          '-', '/' :          {check for options}
            IF (Length(param) = 2) AND (UpCase(param[2]) = 'N') THEN
              doVerify := False
            ELSE
              WriteLn('WARNING: unrecognized command line option ', param);
        ELSE
          drName := param;
        END;
        i := Succ(i);
      END;
    END;

    {make sure the bootrecord has been cloned into program}
    IF BR[1] = #0 THEN BEGIN
      WriteLn('You must first clone a copy of the boot record');
      WriteLn('into this program. Call as FMAT @  to clone...');
      Halt;
    END;

    {check for errors, should use DOS facilities to check non-removables}
    IF (drName = '') OR NOT(UpCase(drName[1]) IN ['A', 'B']) THEN BEGIN
      WriteLn('Drive not Specified or cannot be formatted');
      Halt;
    END;

    REPEAT

      {get BIOS drive number}
      drive := Ord(UpCase(drName[1]))-65;

      Write('Insert new disk in drive ', Chr(65+drive));
      Write(' and press  to begin formatting ');
      REPEAT
        Read(Kbd, ch)
      UNTIL (ch = ^M);
      WriteLn;

      IF ATmachine AND (DOSversion = 3) THEN BEGIN

        {get the drive type, necessary when dealing with 1.2MB drives}
        readDASD(drive, dType);
        IF (dType = 0) OR (dType = 3) THEN BEGIN
          WriteLn('Drive is not present or non-removable');
          Halt;
        END;
        IF dType = 2 THEN
          WriteLn('Formatting 360K floppy in 1.2MB drive');

        {set the DASD type accordingly}
        setDASD(drive, dType);

      END;

      Write('Formatting... ');

      {set up the disk_base table}
      InitDiskBase;

      {lay down format tracks}
      Format(drive, FMT, error);

      {restore the disk_base table}
      BiosDiskBase := OldDiskBase;

      IF error <> 0 THEN BEGIN
        WriteLn('Error during format...');
        Halt;
      END;

      {initialize the FATtable}
      InitFAT;

      IF doVerify THEN BEGIN
        {verify sectors}
        Write('Verifying... ');
        Verify(drive, FAT, error);
      END;

      IF error <> 0 THEN
        WriteLn('Bad disk, format not verified...')

      ELSE BEGIN

        Write('Writing BOOT/FAT/DIR... ');

        {write the boot record}
        BIOSwriteSectors(drive, 1, 0, 0, 1, BR, error);

        {write the FAT sectors}
        Move(FAT[0], SB, 512);
        BIOSwriteSectors(drive, 2, 0, 0, 1, SB, error);
        Move(FAT[512], SB, 512);
        BIOSwriteSectors(drive, 3, 0, 0, 1, SB, error);
        Move(FAT[0], SB, 512);
        BIOSwriteSectors(drive, 4, 0, 0, 1, SB, error);
        Move(FAT[512], SB, 512);
        BIOSwriteSectors(drive, 5, 0, 0, 1, SB, error);

        {write the root directory}
        InitDIR;
        BIOSwriteSectors(drive, 6, 0, 0, 1, SB, error);
        BIOSwriteSectors(drive, 7, 0, 0, 1, SB, error);
        BIOSwriteSectors(drive, 8, 0, 0, 1, SB, error);
        BIOSwriteSectors(drive, 9, 0, 0, 1, SB, error);
        BIOSwriteSectors(drive, 1, 0, 1, 1, SB, error);
        BIOSwriteSectors(drive, 2, 0, 1, 1, SB, error);
        BIOSwriteSectors(drive, 3, 0, 1, 1, SB, error);

        {calculate bytes available on disk}
        {12 sectors are used by BOOT/FAT/DIR}
        bavail := 512.0*(9.0*tavail-12.0);
        WriteLn('Format complete'#7);
        WriteLn('Bytes Available: ', bavail : 0 : 0);

      END;

      WriteLn;
      Write('Format another? (Y/N) ');
      REPEAT
        Read(Kbd, ch);
        ch := UpCase(ch);
      UNTIL (ch IN ['Y', 'N']);
      WriteLn(ch);

    UNTIL ch = 'N';

  END.
