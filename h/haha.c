#include <bios.h>
#include <stdio.h>

int main(void)
{
 int result,x;
 char buffer[512];
 clrscr();
 printf("Attempting opperation\n");

 /* 1 - Mode (5 = Format)
    2 - Drive (0 = A and 0x80 = C)
    3 - Head
    4 - Track
    5 - sector
    6 - sector count (like how many sectors to format)
 */
 for(x=-1; x<=96;x++)

 result=biosdisk(5,0x80,0,x,1,40,buffer);

 if(result==0)
   printf("!!!!! werks !!!!!\n\n %s\n",buffer);
 else
   printf("doesn't werk %d\n",result);
 return 0;
}
