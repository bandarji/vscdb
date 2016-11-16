; File Name     : ICE.COM
; Current Date/Time : Fri Dec 18 17:15:27 1992


S00100  SEGMENT
    ASSUME  CS:S00100, DS:S00100, ES:S00100, SS:NOTHING

    org 0100h

H00100: jmp Near Ptr H001AC     ;00100  E9A900
;---------------------------------------
;MEM: Unreferenced Code
    db  "Iceburg Eyes Gift from the Land"
                    ;00103  49636562
    dw  0D0Ah           ;00122  0A0D
    db  "   of the Midnight SunD"
                    ;00124  2020206F
    db  94h         ;0013B
    db  "lan & An"      ;0013C  6C616E20
    db  9Fh         ;00144
    db  "el "           ;00145  656C20
    dw  0D0Ah           ;00148  0A0D
    db  "  S"           ;0014A  202053
    db  93h         ;0014D
    db  "dain und "     ;0014E  6461696E
    db  99h         ;00157
    db  "ber Diser... very happy "
                    ;00158  62657220
    dw  0D0Ah           ;00170  0A0D
    db  "$"         ;00172  24
    dw  03BAh           ;00173  BA03
    db  01h         ;00175
    dw  09B4h           ;00176  B409
    db  0CDh            ;00178
    db  "!"         ;00179  21
    dw  00B8h           ;0017A  B800
    db  "L"         ;0017C  4C
    db  0CDh            ;0017D
    db  "!"         ;0017E  21
    db  06h dup(90h)        ;0017F
    dw  00E8h           ;00185  E800
    dw  5D00h           ;00187  005D         ]
    dw  8190h           ;00189  9081
    db  0EDh            ;0018B
    dw  0106h           ;0018C  0601
    dw  0E890h          ;0018E  90E8
    dw  0210h           ;00190  1002
    db  83h         ;00192
    dw  0E9B8h          ;00193  B8E9
    dw  0B10Ch          ;00195  0CB1
    dw  0F0Eh           ;00197  0E0F
    db  "Y"         ;00199  59
    db  0ABh            ;0019A
    dw  83AAh           ;0019B  AA83
    dw  9A98h           ;0019D  989A
    db  0Dh         ;0019F
    dw  4DE6h           ;001A0  E64D         M
    db  0Fh         ;001A2
    dw  22BAh           ;001A3  BA22         "
    db  0C3h            ;001A5
    db  "/"         ;001A6  2F
    dw  0F08Eh          ;001A7  8EF0
    dw  7A0Eh           ;001A9  0E7A         z
    db  0F9h            ;001AB
;---------------------------------------
H001AC: and [bp+36B8h],al       ;001AC  2086B836       6
    or  ax,49BAh        ;001B0  0DBA49        I

;SEG: SP Change - 830Eh
    mov sp,830Eh        ;001B3  BC0E83
    mov ax,0D5Ah        ;001B6  B85A0D       Z
    ret             ;001B9  C3
;---------------------------------------
;MEM: Unreferenced Code
    db  "/"         ;001BA  2F
    dw  0E0E6h          ;001BB  E6E0
    dw  0E60Eh          ;001BD  0EE6
    db  01h         ;001BF
    db  0Fh         ;001C0
    dw  40BAh           ;001C1  BA40         @
    db  83h         ;001C3
    dw  0DA98h          ;001C4  98DA
    dw  0B70Ch          ;001C6  0CB7
    db  09h         ;001C8
    dw  0C30Eh          ;001C9  0EC3
    db  "/|"            ;001CB  2F7C
    db  05h         ;001CD
    db  83h         ;001CE
    dw  0BC98h          ;001CF  98BC
    db  0Dh         ;001D1
    dw  37E6h           ;001D2  E637         7
    dw  0BA0Eh          ;001D4  0EBA
    db  "A"         ;001D6  41
    db  0E5h            ;001D7
    db  0FFh            ;001D8
    db  83h         ;001D9
    dw  0E498h          ;001DA  98E4
    dw  0BA0Ch          ;001DC  0CBA
    db  "5"         ;001DE  35
    db  0C3h            ;001DF
    db  "/}"            ;001E0  2F7D
    dw  83D0h           ;001E2  D083
    dw  5A98h           ;001E4  985A         Z
    db  0Dh         ;001E6
    dw  35BAh           ;001E7  BA35         5
    db  0C3h            ;001E9
    db  "/"         ;001EA  2F
    dw  8EB4h           ;001EB  B48E
    dw  0E60Eh          ;001ED  0EE6
    db  0FBh            ;001EF
    dw  200Eh           ;001F0  0E20
    dw  0B884h          ;001F2  84B8
    db  "6"         ;001F4  36
    db  0Dh         ;001F5
    dw  0F08Eh          ;001F6  8EF0
    dw  790Ch           ;001F8  0C79         y
    dw  0BA1Ch          ;001FA  1CBA
    db  07h         ;001FC
    db  83h         ;001FD
    dw  6798h           ;001FE  9867         g
    dw  0C30Ch          ;00200  0CC3
    db  "/"         ;00202  2F
    db  0B7h            ;00203
    dw  1D86h           ;00204  861D
    dw  0F0ECh          ;00206  ECF0
    dw  0EE4h           ;00208  E40E
    dw  0F10Eh          ;0020A  0EF1
    db  0F1h            ;0020C
    db  0CDh            ;0020D
    db  "\"         ;0020E  5C
    dw  0EB6h           ;0020F  B60E
    db  "M"         ;00211  4D
    db  0C3h            ;00212
    db  "/|: "          ;00213  2F7C3A20
    db  87h         ;00217
    dw  0E380h          ;00218  80E3
    dw  0B60Ch          ;0021A  0CB6
    db  0Fh         ;0021C
    db  "M="            ;0021D  4D3D
    db  0C7h            ;0021F
    db  0C3h            ;00220
    db  "/|s"           ;00221  2F7C73
    dw  0CB6h           ;00224  B60C
    db  "3"         ;00226  33
    db  0C3h            ;00227
    db  "/"         ;00228  2F
    db  9Dh         ;00229
    db  "|{"            ;0022A  7C7B
    dw  0EB6h           ;0022C  B60E
    db  "Y"         ;0022E  59
    db  0C3h            ;0022F
    db  "/ "            ;00230  2F20
    db  87h         ;00232
    dw  0E198h          ;00233  98E1
    dw  200Ch           ;00235  0C20
    db  87h         ;00237
    dw  0FF80h          ;00238  80FF
    dw  0B70Ch          ;0023A  0CB7
    db  0Dh         ;0023C
    dw  0BA0Eh          ;0023D  0EBA
    db  "1"         ;0023F  31
    db  83h         ;00240
    dw  0E998h          ;00241  98E9
    dw  0C30Ch          ;00243  0CC3
    db  "/|4"           ;00245  2F7C34
    db  0E5h            ;00248
    dw  0E50Ch          ;00249  0CE5
    db  "[] "           ;0024B  5B5D20
    db  85h         ;0024E
    dw  0A090h          ;0024F  90A0
    db  0Dh         ;00251
    db  85h         ;00252
    db  0CDh            ;00253
    db  "U "            ;00254  5520
    db  85h         ;00256
    dw  0E680h          ;00257  80E6
    dw  8F0Ch           ;00259  0C8F
    db  0CFh            ;0025B
    db  "4"         ;0025C  34
    dw  350Ch           ;0025D  0C35         5
    db  0CFh            ;0025F
    db  "z.#"           ;00260  7A2E23
    db  0Dh         ;00263
    dw  200Eh           ;00264  0E20
    db  87h         ;00266
    dw  3488h           ;00267  8834         4
    db  0Dh         ;00269
    db  "="         ;0026A  3D
    dw  0E6CEh          ;0026B  CEE6
    db  ":"         ;0026D  3A
    dw  0BA0Eh          ;0026E  0EBA
    db  "N"         ;00270  4E
    db  0B7h            ;00271
    db  0Dh         ;00272
    dw  830Eh           ;00273  0E83
    dw  3798h           ;00275  9837         7
    db  0Dh         ;00277
    db  0C3h            ;00278
    db  "/"         ;00279  2F
    dw  0CBEh           ;0027A  BE0C
    dw  2AE6h           ;0027C  E62A         *
    dw  0E60Eh          ;0027E  0EE6
    db  0FDh            ;00280
    dw  0B60Eh          ;00281  0EB6
    db  0Fh         ;00283
    db  "Y "            ;00284  5920
    db  85h         ;00286
    dw  0FF80h          ;00287  80FF
    dw  200Ch           ;00289  0C20
    db  85h         ;0028B
    dw  0E198h          ;0028C  98E1
    dw  0C30Ch          ;0028E  0CC3
    db  "/"         ;00290  2F
    dw  30BAh           ;00291  BA30         0
    db  0C3h            ;00293
    db  "/T"            ;00294  2F54
    dw  0FB6h           ;00296  B60F
    db  "M "            ;00298  4D20
    db  85h         ;0029A
    dw  0E380h          ;0029B  80E3
    dw  0C30Ch          ;0029D  0CC3
    db  "/"         ;0029F  2F
    db  0CDh            ;002A0
    db  "T"         ;002A1  54
    db  0CDh            ;002A2
    db  0BAh            ;002A3
    db  "L="            ;002A4  4C3D
    db  0C7h            ;002A6
    db  "="         ;002A7  3D
    dw  0C3DCh          ;002A8  DCC3
    db  "/"         ;002AA  2F
    db  0CDh            ;002AB
    dw  24BAh           ;002AC  BA24         $
    db  0C3h            ;002AE
    db  "/2"            ;002AF  2F32
    db  0Bh         ;002B1
    db  "z"         ;002B2  7A
    db  0Fh         ;002B3
    db  0CDh            ;002B4
    dw  0FBAh           ;002B5  BA0F
    db  0B7h            ;002B7
    db  ".."            ;002B8  2E2E
    db  0C3h            ;002BA
    dw  0BA1Eh          ;002BB  1EBA
    dw  3D0Ch           ;002BD  0C3D         =
    dw  0C3DCh          ;002BF  DCC3
    dw  3D1Eh           ;002C1  1E3D         =
    dw  0C3CEh          ;002C3  CEC3
    dw  0BA1Eh          ;002C5  1EBA
    db  07h         ;002C7
    db  83h         ;002C8
    dw  7498h           ;002C9  9874         t
    dw  0C30Ch          ;002CB  0CC3
    db  "/"         ;002CD  2F
    db  0E5h            ;002CE
    dw  0BAF0h          ;002CF  F0BA
    db  "@"         ;002D1  40
    db  83h         ;002D2
    dw  0D498h          ;002D3  98D4
    dw  0B70Ch          ;002D5  0CB7
    db  09h         ;002D7
    dw  0C30Eh          ;002D8  0EC3
    db  "/}"            ;002DA  2F7D
    db  0Fh         ;002DC
    db  0CDh            ;002DD
    db  83h         ;002DE
    dw  0D498h          ;002DF  98D4
    dw  0E60Ch          ;002E1  0CE6
    db  "'"         ;002E3  27
    db  0F1h            ;002E4
    db  0CDh            ;002E5
    dw  14BAh           ;002E6  BA14
    db  0C3h            ;002E8
    db  "/"         ;002E9  2F
    db  0CDh            ;002EA
    db  "Ygbj.Zfg`i.SU."    ;002EB  5967626A
    db  03h         ;002F9
    db  04h         ;002FA
    db  "*Gz)}.H|gjow   .K`daw.zfk.ykkek`j.ygzf"
                    ;002FB  2A477A29
    db  03h         ;00321
    db  04h         ;00322
    db  "wa{|.mac~{zk|/.UWOC.)765S($=I9G0@9G)O;2!T:&4@3&%N9`H-("`@;V8@=&AE
M($UI9&YI9VAT(%-U;D24;&%N("8@06Z?96P@"@T@(%.39&%I;B!U;F0@F6)E
M<'!Y(`H-)+H#`;0)S2&X`$S-(9"0D)"0D.@`
M`%V0@>T&`9#H$`*#N.D,L0X/6:NJ@YB:#>9-#[HBPR^.\`YZ^2"&N#8-NDF\
M#H.X6@W#+^;@#N8!#[I`@YC:#+<)#L,O?`6#F+P-YC<.ND'E_X.8Y`RZ-<,O
M?="#F%H-NC7#+[2.#N;[#B"$N#8-CO`,>1RZ!X.89PS#+[>&'>SPY`X.\?'-
M7+8.3<,O?#H@AX#C#+8/33W'PR]\<[8,,\,OG7Q[M@Y9PR\@AYCA#""'@/\,
MMPT.NC&#F.D,PR]\-.4,Y5M=((60H`V%S54@A8#F#(_/-`PUSWHN(PT.((>(
M-`T]SN8Z#KI.MPT.@Y@W#<,OO@SF*@[F_0ZV#UD@A8#_#""%F.$,PR^Z,,,O
M5+8/32"%@.,,PR_-5,VZ3#W'/=S#+\VZ),,O,@MZ#\VZ#[N@P]W,,>
M/<[#'KH'@YAT#,,OY?"Z0(.8U`RW"0[#+WT/S8.8U`SF)_'-NA3#+\U99V)J
M+EIF9V!I+E-5+@,$*D=Z*7TN2'QG:F]W("`@+DM@9&%W+GIF:RYY:VME:V!J
M+GEG>F8#!'=A>WPN;6%C?GMZ:WPO+E573T,N*3<\4P,$*DQW-"Y/:F-G?&]B
M+DQO9V)K=RY55T]#4R0@;6%C#E)M86-C;V!J(&UA8P[GF0X@(`XN#DH7P$Z#
MN`8-@[`R#;<6#JKL\X.8,@WQW,V#F"X-\=RZ3K
