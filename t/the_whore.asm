
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
                            The Whore Virus
        I have recently researched a virus called the Whore.  I was told
that this virus was very stealthy, and neither normal nor heuristics scanners
could detect it.  This brought about a challenge, thus I decided to research
it.
        Patricia Hoffman's VSUM had no information about this virus, and as
claimed, no virus detector could detect this virus.  I found only one magazine
that had ANY information on the Whore.  SPAM (Sociopathic Programmers Against
McAfee) magazine claimed that the Whore was:  "...Incredibly stealthy...it
utilizes the new anti-integrity master code.  It's a combination boot/file
infector, infecting .COM, .EXE and .SYS files of over 20k."  It also said that
"...if anyone wants a copy of this, you can get it on any SPaM board."
        I got a copy of the Whore virus, and upon disassembly of it, and a
clean DOS 5.0 COMMAND.COM, I realized that there is absolutely NO difference
between the Whore "virus" and the clean COMMAND.COM.
        Gee, I wonder which great virus creator wrote this one, it's ever
so stealthy <GRIN>!
                                        Master of Illusion

Editor's Note:
        Upon re-studying the virus and the DOS 5.0 COMMAND.COM and using
our File Compare, I found the following differences:
-----------------------------------------------------------------------------
; FILE CREATED BY FILE COMPARE,
; DEVELOPED BY:
; MICRO PROFESSOR SOFTWARE,
; AMATEUR VIRUS CREATION & RESEARCH GROUP.


;----------------------------------------------------------------------------
var1_0          db      20h
var1_0          db      76h
;----------------------------------------------------------------------------
var1_1          dd      18C018Ah
var1_1          dd      20202020h
;----------------------------------------------------------------------------
                dd      57000000h
                dd      2C495320h
;----------------------------------------------------------------------------
                dd      0BBF14E49h
                dd      0BBF13038h
;----------------------------------------------------------------------------

        There were other differences, but they were insignificant
differences with the comments left by the disassembler.  These may or may
not be significant.  Due to the size of the WHORE virus, and its disassembly
I can not include it in this file, for it is approximately 700,000 bytes
long, and the virus is 47,845 bytes long, the same size as the DOS 5.0
COMMAND.COM
                                        Th� Patron
