// Flu_Not version 1.0
// 27 Nov 1991
// Dark Angel & Demogorgon of PHALCON/SKISM Co-op
// 
// This is to be used in a program which bypasses FluShot.
// The method is completely generic and 99.99% infallible.
// To use it, #include the file and call checkflu().  This
// will set up all the necessary variables.  flu_disable()
// and flu_enable() do what they imply.
//
// NOTE:  checkflu() MUST be called before flu_disable and
//        flu_enable.
// 
// Oh yeah, it works under TC/BC

#ifndef __DOS_H__
#include <dos.h>
#endif

int flu_seg, flu_off = 0x1000;
int fluinstalled = 0;

int checkflu(void);

// flu_disable() is a macro to disable FluShot+ (Duh!)
#define flu_disable() if (fluinstalled) poke(flu_seg,flu_off,0xC3F8)

// Need I explain flu_enable()?
#define flu_enable()  if (fluinstalled) poke(flu_seg,flu_off,0x5250)

// checkflu() returns a 0 if FluShot+ is not installed, 1 otherwise
int checkflu(void)
{
  // Note that checkflu() doesn't use INT 21h/FF0Fh to determine if
  //  FluShot+ is resident.  This was because I was lazy and didn't
  //  want to invoke TASM when compiling.  It is easy enough to do.

  // Find possible FluShot+ segment in interrupt table
  flu_seg = peek(0x0000,0x004E);

  // Search for 0x593C, the identifier for the FluShot+ "blue window"
  //  routine
  while ((peek(flu_seg,++flu_off)) != 0x593C)
    // If not found in the first 0x5000 bytes of code, then FluShot+
    //  isn't installed
    if (flu_off > 0x5000) return (0);

  while (peek(flu_seg,--flu_off) != 0x5250)
    // Search for the beginning of the routine, which is marked by
    //  0x5250.  If not found by 0x1001, then FluShot+ is not installed
    if (flu_off < 0x1001) return (0);

  // Yay!  We found it!  flu_seg and flu_off are now properly loaded.
  fluinstalled = 1;
  return (1);
}
