#include <stdio.h>

main()
{
    checkmem();
}

int checkmem()
{
    unsigned int vec_ip,vec_cs,orgvec_ip,orgvec_cs,highmem;

    vec_ip = peek(4*0x13,0);
    vec_cs = peek(4*0x13+2,0);
    printf("\n13H vect IP = %x\n13H vect CS = %x\n",vec_ip,vec_cs);
    orgvec_ip = peek(4*0x6D,0);
    orgvec_cs = peek(4*0x6D+2,0);
    printf("\n\n6DH vect IP = %x\n6DH vect CS = %x\n",orgvec_ip,orgvec_cs);
    highmem=peek(0x413,0);
    printf("\n\nHigh memory limit = %d  (%xH)\n",highmem,highmem);
} /* checkmem */
