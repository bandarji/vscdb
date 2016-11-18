; File Name     : TREMOR.COM
; Current Date/Time : Wed Apr 21 01:46:16 1993
; Disassembly done with Master Core Disassembler
; Options used:
; -U2
; -DF
; -P9
; -F1
; -LH00100
; -LX00104
; -LH0C46C
; -LH0C46E
; -LH0C48C
; -VB00
; -VC70

        .286P

S00100  SEGMENT
        ASSUME  CS:S00100, DS:S00100, ES:S00100, SS:NOTHING

        org     0100h


H0000_0100:
    jmp H0000_C489      ;00100  E986C3
;---------------------------------------
    nop             ;00103  90
;---------------------------------------
;MEM: Data in Code Area
X0000_0104     db      90h         ;00104
    db  0C367h dup(90h)     ;00105
;---------------------------------------
H0000_C46C:
;---------------------------------------
;DOS0-SYS TERMINATE Program, INT 20h
;INT: 20h
    int 20h         ;0C46C  CD20
;---------------------------------------
H0000_C46E:
    nop             ;0C46E  90
    mov di,0C489h       ;0C46F  BF89C4
    and ax,ax           ;0C472  23C0        #
    mov bx,0E4F1h       ;0C474  BBF1E4
    mov cx,0891h        ;0C477  B99108
    push    ds          ;0C47A  1E

;SEG: ES Change - Indefinite
    pop es          ;0C47B  07
H0000_C47C:
    xor [di],bx         ;0C47C  311D        1
    sti             ;0C47E  FB
    add bx,0F6F5h       ;0C47F  81C3F5F6

;ASM: Synonym
;A  sub di,-02h         ;0C483  83EFFE
       db      83h,0EFh,0FEh

    loop    H0000_C47C      ;0C486  E2F4
    nop             ;0C488  90
H0000_C489:
    jmp H0000_D079      ;0C489  E9ED0B
;---------------------------------------
H0000_C48C:
    jmp Short H0000_C499    ;0C48C  EB0B
;- - - - - - - - - - - - - - - - - - - -
    nop             ;0C48E  90
    nop             ;0C48F  90
    nop             ;0C490  90
    jmp H0000_D079      ;0C491  E9E50B
;---------------------------------------
H0000_C494:
    call    H0000_CFC8      ;0C494  E8310B       1

;MEM: Possible Data - Invalid Code
;A  jmp             ;0C497  E992
       db      0E9h,92h

;---------------------------------------
H0000_C499:
    add bp,ds:[3E80h]       ;0C499  032E803E     . >

;SEG: SP Change - Indefinite
    ror Word Ptr [si],cl    ;0C49D  D30C
    add [si-0Bh],si     ;0C49F  0174F5       t

;SEG: CS Override
    mov cs:[0C3Dh],si       ;0C4A2  2E89363D0C  . 6=
    mov si,0C3Dh        ;0C4A7  BE3D0C       =

;SEG: CS Override
    mov cs:[si-16h],ds      ;0C4AA  2E8C5CEA    . \
    push    cs          ;0C4AE  0E

;SEG: DS Change - 0000h
    pop ds          ;0C4AF  1F

;SEG: SP Change - Indefinite
    mov [si-0Ch],ax     ;0C4B0  8944F4       D

;SEG: SP Change - Indefinite
    mov [si-09h],bx     ;0C4B3  895CF7       \

;SEG: SP Change - Indefinite
    mov [si-06h],cx     ;0C4B6  894CFA       L

;SEG: SP Change - Indefinite
    mov [si-03h],dx     ;0C4B9  8954FD       T

;SEG: SP Change - Indefinite
    mov [si+03h],di     ;0C4BC  897C03       |

;SEG: SP Change - Indefinite
    mov [si+06h],bp     ;0C4BF  896C06       l
    mov [si-11h],es     ;0C4C2  8C44EF       D
    cmp Byte Ptr [si+0Bh],01h   ;0C4C5  807C0B01     |
    jmp Short H0000_C506    ;0C4C9  EB3B         ;
;- - - - - - - - - - - - - - - - - - - -
    add al,ah           ;0C4CB  02C4
    and al,0Fh          ;0C4CD  240F        $
    add ah,al           ;0C4CF  02E0
    and ah,0Fh          ;0C4D1  80E40F
    push    ax          ;0C4D4  50      P
    mov dx,03DAh        ;0C4D5  BADA03

;PORT Input: 3DAh - CGA/EGA Status
    in  al,dx           ;0C4D8  EC
    pop bx          ;0C4D9  5B      [
    mov al,08h          ;0C4DA  B008
    mov ah,bl           ;0C4DC  8AE3
    mov dl,0D4h         ;0C4DE  B2D4

;PORT Output: 3D4h - CGA/EGA Reg Index
    out dx,ax           ;0C4E0  EF
    mov dl,0C0h         ;0C4E1  B2C0
    mov al,33h          ;0C4E3  B033         3

;PORT Output: 3C0h - EGA Attrs
    out dx,al           ;0C4E5  EE
    mov al,bh           ;0C4E6  8AC7

;PORT Output: 3C0h - EGA Attrs
    out dx,al           ;0C4E8  EE
    call    H0000_CFC8      ;0C4E9  E8DC0A

    push    ax          ;0C4EC  50      P
    xor cx,cx           ;0C4ED  33C9        3
    mov al,0B6h         ;0C4EF  B0B6

;PORT Output: 043h - 8253 SYS Timer Set Mode
    out 43h,al          ;0C4F1  E643         C
    mov cl,ah           ;0C4F3  8ACC
    sal al,1            ;0C4F5  D0E0
    sal cx,1            ;0C4F7  D1E1

;PORT Input: 061h - 8255 PPI-B KBD, SYS Sw, Speaker
    in  al,61h          ;0C4F9  E461         a
    push    ax          ;0C4FB  50      P
    or  al,03h          ;0C4FC  0C03

;PORT Output: 061h - 8255 PPI-B KBD, SYS Sw, Speaker
    out 61h,al          ;0C4FE  E661         a
H0000_C500:

;MEM: Timing Loop
    loop    H0000_C500      ;0C500  E2FE
    pop ax          ;0C502  58      X

;PORT Output: 061h - 8255 PPI-B KBD, SYS Sw, Speaker
    out 61h,al          ;0C503  E661         a
    pop ax          ;0C505  58      X
H0000_C506:
    cmp ah,57h          ;0C506  80FC57        W
    jz  H0000_C53B      ;0C509  7430        t0
    cmp ah,42h          ;0C50B  80FC42        B
    jz  H0000_C53B      ;0C50E  742B        t+
    cmp ah,3Fh          ;0C510  80FC3F        ?
    jz  H0000_C524      ;0C513  740F        t
    cmp ah,50h          ;0C515  80FC50        P
    jb  H0000_C51F      ;0C518  7205        r
    cmp ah,6Ch          ;0C51A  80FC6C        l
    jb  H0000_C538      ;0C51D  7219        r
H0000_C51F:
    cmp ah,30h          ;0C51F  80FC30        0
    jnz H0000_C529      ;0C522  7505        u
H0000_C524:
    cmp bl,04h          ;0C524  80FB04
    ja  H0000_C53B      ;0C527  7712        w
H0000_C529:
    cmp ah,3Ch          ;0C529  80FC3C        <
    ja  H0000_C533      ;0C52C  7705        w
    cmp ah,12h          ;0C52E  80FC12
    ja  H0000_C538      ;0C531  7705        w
H0000_C533:
    cmp ah,0Eh          ;0C533  80FC0E
    ja  H0000_C53B      ;0C536  7703        w
H0000_C538:
    jmp Near Ptr H0000_C494 ;0C538  E959FF       Y
;---------------------------------------
H0000_C53B:
    xor bx,bx           ;0C53B  33DB        3
    call    H0000_CEE7      ;0C53D  E8A709

;SEG: CS Override
    mov cs:[04ADh],cl       ;0C540  2E880EAD04  .
    mov al,00h          ;0C545  B000
    call    H0000_CCCE      ;0C547  E88407

    mov al,15h          ;0C54A  B015
    mov di,009Eh        ;0C54C  BF9E00
    call    H0000_C831      ;0C54F  E8DF02

    mov di,009Ah        ;0C552  BF9A00
    call    H0000_C858      ;0C555  E80003

    mov al,21h          ;0C558  B021         !
    mov di,0092h        ;0C55A  BF9200
    call    H0000_C831      ;0C55D  E8D102

    mov di,0086h        ;0C560  BF8600
    call    H0000_C858      ;0C563  E8F202

    mov al,24h          ;0C566  B024         $
    mov di,008Eh        ;0C568  BF8E00
    call    H0000_C831      ;0C56B  E8C302

    mov dx,109Fh        ;0C56E  BA9F10
    push    cs          ;0C571  0E

;SEG: DS Change - 0000h
    pop ds          ;0C572  1F
    call    H0000_C861      ;0C573  E8EB02

    call    H0000_CFC8      ;0C576  E84F0A       O

    cmp ah,3Fh          ;0C579  80FC3F        ?
    jz  H0000_C581      ;0C57C  7403        t
    jmp Near Ptr H0000_C609 ;0C57E  E98800
;---------------------------------------
H0000_C581:
    jcxz    H0000_C590      ;0C581  E30D
    mov ax,5700h        ;0C583  B80057        W
    call    H0000_C863      ;0C586  E8DA02

    jb  H0000_C590      ;0C589  7205        r
    cmp dh,0C7h         ;0C58B  80FEC7
    ja  H0000_C593      ;0C58E  7703        w
H0000_C590:
    jmp Near Ptr H0000_C616 ;0C590  E98300
;---------------------------------------
H0000_C593:
    call    H0000_C8CE      ;0C593  E83803       8

    jb  H0000_C590      ;0C596  72F8        r
    call    H0000_CE52      ;0C598  E8B708

    jnz H0000_C590      ;0C59B  75F3        u
    call    H0000_CFC4      ;0C59D  E8240A       $

;SEG: CS Override
    mov bx,cs:[055Dh]       ;0C5A0  2E8B1E5D05  .  ]

;SEG: CS Override
    mov dx,cs:[0560h]       ;0C5A5  2E8B166005  .  `
    call    H0000_CEC1      ;0C5AA  E81409

    ja  H0000_C5C5      ;0C5AD  7716        w
    add bx,cx           ;0C5AF  03D9

;ASM: Synonym
;A  adc dx,+00h         ;0C5B1  83D200
       db      83h,0D2h,00h

    call    H0000_CEC1      ;0C5B4  E80A09

    jbe H0000_C5C7      ;0C5B7  760E        v

;SEG: CS Override
    sub bx,cs:[1065h]       ;0C5B9  2E2B1E6510  .+ e
    sub bx,cx           ;0C5BE  2BD9        +
    neg bx          ;0C5C0  F7DB
    push    bx          ;0C5C2  53      S
    jmp Short H0000_C5C8    ;0C5C3  EB03
;- - - - - - - - - - - - - - - - - - - -
H0000_C5C5:
    xor cx,cx           ;0C5C5  33C9        3
H0000_C5C7:
    push    cx          ;0C5C7  51      Q
H0000_C5C8:
    call    H0000_CFC8      ;0C5C8  E8FD09

    pop cx          ;0C5CB  59      Y
    call    H0000_C863      ;0C5CC  E89402

    jb  H0000_C607      ;0C5CF  7236        r6
    pushf               ;0C5D1  9C
    push    ax          ;0C5D2  50      P
    push    si          ;0C5D3  56      V
    push    di          ;0C5D4  57      W
    push    ds          ;0C5D5  1E
    push    es          ;0C5D6  06
    push    ds          ;0C5D7  1E

;SEG: ES Change - Indefinite
    pop es          ;0C5D8  07
    push    cs          ;0C5D9  0E

;SEG: DS Change - 0000h
    pop ds          ;0C5DA  1F
    mov di,055Dh        ;0C5DB  BF5D05       ]

;ASM: Synonym
;A  cmp Word Ptr [di+03h],+00h  ;0C5DE  837D0300     }
       db      83h,7Dh,03h,00h

    ja  H0000_C601      ;0C5E2  771D        w

;ASM: Synonym
;A  cmp Word Ptr [di],+18h  ;0C5E4  833D18       =
       db      83h,3Dh,18h

    jnb H0000_C601      ;0C5E7  7318        s
    mov ax,[di]         ;0C5E9  8B05
    mov di,dx           ;0C5EB  8BFA
    mov si,ax           ;0C5ED  8BF0
    add si,104Dh        ;0C5EF  81C64D10      M

;ASM: Synonym
;A  cmp cx,+18h         ;0C5F3  83F918
       db      83h,0F9h,18h

    jb  H0000_C5FE      ;0C5F6  7206        r

;ASM: Synonym
;A  sub ax,Word Ptr 0018h   ;0C5F8  2D1800      -
       db      2Dh,18h,00h

    neg ax          ;0C5FB  F7D8
    xchg    ax,cx           ;0C5FD  91
H0000_C5FE:
    cld             ;0C5FE  FC

; ds=0000h
    rep movsb           ;0C5FF  F3A4
H0000_C601:

;SEG: ES Change - Indefinite
    pop es          ;0C601  07

;SEG: DS Change - Indefinite
    pop ds          ;0C602  1F
    pop di          ;0C603  5F      _
    pop si          ;0C604  5E      ^
    pop ax          ;0C605  58      X
    popf                ;0C606  9D
H0000_C607:
    jmp Short H0000_C637    ;0C607  EB2E         .
;- - - - - - - - - - - - - - - - - - - -
H0000_C609:
    cmp ax,4202h        ;0C609  3D0242      = B
    jnz H0000_C63E      ;0C60C  7530        u0
    mov ax,5700h        ;0C60E  B80057        W
    call    H0000_C863      ;0C611  E84F02       O

    jnb H0000_C619      ;0C614  7303        s
H0000_C616:
    jmp H0000_C81D      ;0C616  E90402
;---------------------------------------
H0000_C619:
    cmp dh,0C8h         ;0C619  80FEC8
    jb  H0000_C616      ;0C61C  72F8        r
    call    H0000_C8CE      ;0C61E  E8AD02

    jb  H0000_C616      ;0C621  72F3        r
    call    H0000_CE52      ;0C623  E82C08       ,

    jnz H0000_C616      ;0C626  75EE        u
    call    H0000_CFC4      ;0C628  E89909

    pushf               ;0C62B  9C
    sub dx,0FA0h        ;0C62C  81EAA00F

;ASM: Synonym
;A  sbb cx,+00h         ;0C630  83D900
       db      83h,0D9h,00h

    popf                ;0C633  9D
    call    H0000_C863      ;0C634  E82C02       ,

H0000_C637:

;SEG: CS Override
    mov cx,cs:[0C37h]       ;0C637  2E8B0E370C  .  7
    jmp Short H0000_C65B    ;0C63C  EB1D
;- - - - - - - - - - - - - - - - - - - -
H0000_C63E:
    jmp Short H0000_C65D    ;0C63E  EB1D
;- - - - - - - - - - - - - - - - - - - -
    cmp ah,4Ah          ;0C640  80FC4A        J
    jz  H0000_C64A      ;0C643  7405        t
    cmp ah,48h          ;0C645  80FC48        H
    jnz H0000_C65D      ;0C648  7513        u
H0000_C64A:
    call    H0000_CFC4      ;0C64A  E87709       w

    call    H0000_C863      ;0C64D  E81302

    jnb H0000_C65B      ;0C650  7309        s
    cmp al,08h          ;0C652  3C08        <
    jnz H0000_C65B      ;0C654  7505        u
    sub bx,010Ch        ;0C656  81EB0C01
    stc             ;0C65A  F9
H0000_C65B:
    jmp Short H0000_C69D    ;0C65B  EB40         @
;- - - - - - - - - - - - - - - - - - - -
H0000_C65D:

;MEM: Possible Data Area
;A  jmp Short H0000_C65F    ;0C65D  EB00
       db      0EBh,00h

;- - - - - - - - - - - - - - - - - - - -
H0000_C65F:
    cmp ah,4Eh          ;0C65F  80FC4E        N
    jb  H0000_C6A0      ;0C662  723C        r<
    cmp ah,4Fh          ;0C664  80FC4F        O
    ja  H0000_C6A0      ;0C667  7737        w7
    call    H0000_C863      ;0C669  E8F701

    pushf               ;0C66C  9C
    push    ax          ;0C66D  50      P
    jb  H0000_C698      ;0C66E  7228        r(
    call    H0000_C86A      ;0C670  E8F701

;SEG: ES Override
    cmp es:[bx+19h],al      ;0C673  26384719    &8G
    jb  H0000_C698      ;0C677  721F        r

;SEG: ES Override
    sub es:[bx+19h],al      ;0C679  26284719    &(G
    mov si,001Ah        ;0C67D  BE1A00
H0000_C680:

;SEG: ES Override
    cmp Byte Ptr es:[bx+si+02h],00h
                    ;0C680  2680780200  & x
    jnz H0000_C68E      ;0C685  7507        u

;SEG: ES Override
    cmp Word Ptr es:[bx+si],2000h
                    ;0C687  2681380020  & 8
    jb  H0000_C698      ;0C68C  720A        r
H0000_C68E:

;SEG: ES Override
    sub Word Ptr es:[bx+si],0FA0h
                    ;0C68E  268128A00F  & (

;ASM: Synonym
;SEG: ES Override
;A  sbb Word Ptr es:[bx+si+02h],+00h
                    ;0C693  2683580200  & X
       db      26h,83h,58h,02h,00h

H0000_C698:
    call    H0000_CFC4      ;0C698  E82909       )

    pop ax          ;0C69B  58      X
H0000_C69C:
    popf                ;0C69C  9D
H0000_C69D:

;ASM: Synonym
;A  retf    0002h           ;0C69D  CA0200
       db      0CAh,02h,00h

;---------------------------------------
H0000_C6A0:
    cmp ah,11h          ;0C6A0  80FC11
    jb  H0000_C6CE      ;0C6A3  7229        r)
    cmp ah,12h          ;0C6A5  80FC12
    ja  H0000_C6CE      ;0C6A8  7724        w$
    call    H0000_C863      ;0C6AA  E8B601

    pushf               ;0C6AD  9C
    push    ax          ;0C6AE  50      P
    cmp al,0FFh         ;0C6AF  3CFF        <
    jz  H0000_C698      ;0C6B1  74E5        t
    call    H0000_C86A      ;0C6B3  E8B401

;SEG: ES Override
    cmp Byte Ptr es:[bx],0FFh   ;0C6B6  26803FFF    & ?
    jnz H0000_C6BF      ;0C6BA  7503        u

;ASM: Synonym
;A  add bx,+07h         ;0C6BC  83C307
       db      83h,0C3h,07h

H0000_C6BF:

;SEG: ES Override
    cmp es:[bx+1Ah],al      ;0C6BF  2638471A    &8G
    jb  H0000_C698      ;0C6C3  72D3        r

;SEG: ES Override
    sub es:[bx+1Ah],al      ;0C6C5  2628471A    &(G
    mov si,001Dh        ;0C6C9  BE1D00
    jmp Short H0000_C680    ;0C6CC  EBB2
;---------------------------------------
H0000_C6CE:
    cmp ah,6Ch          ;0C6CE  80FC6C        l
    jnz H0000_C6D7      ;0C6D1  7504        u
    mov dx,si           ;0C6D3  8BD6
    jmp Short H0000_C6DC    ;0C6D5  EB05
;- - - - - - - - - - - - - - - - - - - -
H0000_C6D7:
    cmp ah,3Dh          ;0C6D7  80FC3D        =
    jnz H0000_C6EA      ;0C6DA  750E        u
H0000_C6DC:

;SEG: CS Override
    inc Word Ptr cs:[0C47h] ;0C6DC  2EFF06470C  .  G
    cmp al,02h          ;0C6E1  3C02        <
    jnz H0000_C6EA      ;0C6E3  7505        u
H0000_C6E5:
    call    H0000_CDED      ;0C6E5  E80507

    jmp Short H0000_C765    ;0C6E8  EB7B         {
;---------------------------------------
H0000_C6EA:
    cmp ah,3Eh          ;0C6EA  80FC3E        >
    jnz H0000_C70A      ;0C6ED  751B        u
    call    H0000_C863      ;0C6EF  E87101       q

    pushf               ;0C6F2  9C
    push    ax          ;0C6F3  50      P
    jb  H0000_C708      ;0C6F4  7212        r
    call    H0000_CE88      ;0C6F6  E88F07

    cmp bl,al           ;0C6F9  3AD8        :
    jnz H0000_C708      ;0C6FB  750B        u
    call    H0000_CE81      ;0C6FD  E88107

    push    cs          ;0C700  0E

;SEG: DS Change - 0000h
    pop ds          ;0C701  1F
    mov dx,0002h        ;0C702  BA0200
    call    H0000_C941      ;0C705  E83902       9

H0000_C708:
    jmp Short H0000_C698    ;0C708  EB8E
;---------------------------------------
H0000_C70A:
    cmp ah,57h          ;0C70A  80FC57        W
    jnz H0000_C751      ;0C70D  7542        uB
    cmp al,01h          ;0C70F  3C01        <
    jz  H0000_C727      ;0C711  7414        t
    call    H0000_CFC4      ;0C713  E8AE08

    call    H0000_C863      ;0C716  E84A01       J

    pushf               ;0C719  9C
    jb  H0000_C724      ;0C71A  7208        r
    cmp dh,0C8h         ;0C71C  80FEC8
    jb  H0000_C724      ;0C71F  7203        r
    sub dh,0C8h         ;0C721  80EEC8
H0000_C724:
    jmp Near Ptr H0000_C69C ;0C724  E975FF       u
;---------------------------------------
H0000_C727:
    cmp dh,0C8h         ;0C727  80FEC8
    jb  H0000_C732      ;0C72A  7206        r

;SEG: CS Override
    sub Byte Ptr cs:[0C3Ah],0C8h;0C72C  2E802E3A0CC8    . .:
H0000_C732:
    call    H0000_C8CE      ;0C732  E89901

    jb  H0000_C765      ;0C735  722E        r.
    call    H0000_C904      ;0C737  E8CA01

    call    H0000_C965      ;0C73A  E82802       (

    jb  H0000_C765      ;0C73D  7226        r&
    call    H0000_C8FC      ;0C73F  E8BA01

    call    H0000_CFC4      ;0C742  E87F08

    add dh,0C8h         ;0C745  80C6C8
    call    H0000_C863      ;0C748  E81801

    pushf               ;0C74B  9C
    sub dh,0C8h         ;0C74C  80EEC8
    jmp Short H0000_C724    ;0C74F  EBD3
;---------------------------------------
H0000_C751:
    call    H0000_CFEB      ;0C751  E89708

    cmp ah,4Ch          ;0C754  80FC4C        L
    jnz H0000_C767      ;0C757  750E        u

;SEG: CS Override
    mov Byte Ptr cs:[02BCh],00h ;0C759  2EC606BC0200    .

;SEG: CS Override
    mov Byte Ptr cs:[0172h],0Fh ;0C75F  2EC60672010F    .  r
H0000_C765:
    jmp Short H0000_C7BE    ;0C765  EB57         W
;---------------------------------------
H0000_C767:
    cmp ah,4Bh          ;0C767  80FC4B        K
    jz  H0000_C76F      ;0C76A  7403        t
    jmp Near Ptr H0000_C7FE ;0C76C  E98F00
;---------------------------------------
H0000_C76F:
    call    H0000_CE81      ;0C76F  E80F07

    cmp al,00h          ;0C772  3C00        <
    jz  H0000_C779      ;0C774  7403        t
    jmp Near Ptr H0000_C6E5 ;0C776  E96CFF       l
;---------------------------------------
H0000_C779:

;MEM: Possible Data Area
;A  jmp Short H0000_C77B    ;0C779  EB00
       db      0EBh,00h

;- - - - - - - - - - - - - - - - - - - -
H0000_C77B:
    mov dx,0FEF4h       ;0C77B  BAF4FE
    call    H0000_CE90      ;0C77E  E80F07

    push    cs          ;0C781  0E

;SEG: DS Change - 0000h
    pop ds          ;0C782  1F
    mov Byte Ptr ds:[03D8h],17h ;0C783  C606D80317
    mov Byte Ptr ds:[029Dh],1Dh ;0C788  C6069D021D
    mov Byte Ptr ds:[02BCh],00h ;0C78D  C606BC0200
    call    H0000_CFC8      ;0C792  E83308       3

    call    H0000_CDB9      ;0C795  E82106       !

    jb  H0000_C7BE      ;0C798  7224        r$

;SEG: CS Override
    cmp Byte Ptr cs:[00A2h],03h ;0C79A  2E803EA20003    . >
    jb  H0000_C7BE      ;0C7A0  721C        r

;SEG: CS Override
    mov ax,Word Ptr cs:[00C0h]  ;0C7A2  2EA1C000    .
    cmp ax,4248h        ;0C7A6  3D4842      =HB
    jz  H0000_C7B5      ;0C7A9  740A        t
    cmp ax,4C43h        ;0C7AB  3D434C      =CL
    jz  H0000_C7B5      ;0C7AE  7405        t
    cmp ax,4353h        ;0C7B0  3D5343      =SC
    jnz H0000_C7C0      ;0C7B3  750B        u
H0000_C7B5:
    call    H0000_CFC8      ;0C7B5  E81008

    call    H0000_CDED      ;0C7B8  E83206       2

    call    H0000_CE81      ;0C7BB  E8C306

H0000_C7BE:
    jmp Short H0000_C81D    ;0C7BE  EB5D         ]
;---------------------------------------
H0000_C7C0:
    push    cs          ;0C7C0  0E

;SEG: ES Change - 0000h
    pop es          ;0C7C1  07
    mov di,0CB8h        ;0C7C2  BFB80C
    mov cx,0008h        ;0C7C5  B90800
    cld             ;0C7C8  FC

; cx=0008h es=0000h di=0CB8h
    repne   scasw           ;0C7C9  F2AF
    jnz H0000_C7EA      ;0C7CB  751D        u
    cmp ax,4843h        ;0C7CD  3D4348      =CH
    jnz H0000_C7E1      ;0C7D0  750F        u

;SEG: CS Override
    cmp Word Ptr cs:[00C2h],444Bh
                    ;0C7D2  2E813EC2004B44  . >  KD
    jnz H0000_C7E1      ;0C7D9  7506        u

;SEG: CS Override
    mov Byte Ptr cs:[02BCh],6Fh ;0C7DB  2EC606BC026F    .    o
H0000_C7E1:
    call    H0000_CE8D      ;0C7E1  E8A906

;SEG: CS Override
    mov Byte Ptr cs:[03D8h],00h ;0C7E4  2EC606D80300    .
H0000_C7EA:

;SEG: CS Override
    cmp Word Ptr cs:[00C1h],4A52h
                    ;0C7EA  2E813EC100524A  . >  RJ
    jnz H0000_C7F9      ;0C7F1  7506        u

;SEG: CS Override
    mov Byte Ptr cs:[0172h],23h ;0C7F3  2EC606720123    .  r #
H0000_C7F9:
    call    H0000_CFC8      ;0C7F9  E8CC07

    jmp Short H0000_C80D    ;0C7FC  EB0F
;- - - - - - - - - - - - - - - - - - - -
H0000_C7FE:
    cmp ah,43h          ;0C7FE  80FC43        C
    jnz H0000_C81D      ;0C801  751A        u
    or  al,al           ;0C803  0AC0
    jnz H0000_C817      ;0C805  7510        u
    cmp bx,0FACEh       ;0C807  81FBCEFA
    jnz H0000_C81D      ;0C80B  7510        u
H0000_C80D:
    call    H0000_C92A      ;0C80D  E81A01

    jnz H0000_C817      ;0C810  7505        u
    mov al,01h          ;0C812  B001
    call    H0000_CCCE      ;0C814  E8B704

H0000_C817:
    call    H0000_CFC8      ;0C817  E8AE07

    call    H0000_C941      ;0C81A  E82401       $

H0000_C81D:
    call    H0000_CFC4      ;0C81D  E8A407

;SEG: CS Override
    cmp cs:[0D09h],ax       ;0C820  2E3906090D  .9
    jnz H0000_C82C      ;0C825  7505        u

;SEG: CS Override
    mov ax,Word Ptr cs:[0C47h]  ;0C827  2EA1470C    . G
    iret                ;0C82B  CF
;---------------------------------------
H0000_C82C:

;MEM: JMP  DWORD PTR CS:[0086H]

;SEG: CS Override
    jmp DWord Ptr cs:[0086h]    ;0C82C  2EFF2E8600  . .
;---------------------------------------
H0000_C831:
    mov ah,35h          ;0C831  B435         5
    call    H0000_C863      ;0C833  E82D00       -

;SEG: CS Override
    mov cs:[di],bx      ;0C836  2E891D      .

;SEG: CS Override
    mov cs:[di+02h],es      ;0C839  2E8C4502    . E
    ret             ;0C83D  C3
;---------------------------------------
H0000_C83E:
    mov al,15h          ;0C83E  B015
    mov di,009Eh        ;0C840  BF9E00
    call    H0000_C858      ;0C843  E81200

    mov al,21h          ;0C846  B021         !
    mov di,0092h        ;0C848  BF9200
    call    H0000_C858      ;0C84B  E80A00

    mov bl,81h          ;0C84E  B381
    call    H0000_CEE7      ;0C850  E89406

    mov al,24h          ;0C853  B024         $
    mov di,008Eh        ;0C855  BF8E00
H0000_C858:

;SEG: CS Override
    mov dx,cs:[di]      ;0C858  2E8B15      .

;SEG: CS Override
    mov bx,cs:[di+02h]      ;0C85B  2E8B5D02    . ]

;SEG: DS Change - Indefinite
    mov ds,bx           ;0C85F  8EDB
H0000_C861:
    mov ah,25h          ;0C861  B425         %
H0000_C863:
    pushf               ;0C863  9C

;MEM: CALL  DWORD PTR CS:[0086H]

; ah=25h al=24h di=008Eh
    call    DWord Ptr cs:[0086h]    ;0C864  2EFF1E8600  .

    ret             ;0C869  C3
;---------------------------------------
H0000_C86A:
    mov ax,2FC8h        ;0C86A  B8C82F        /
    jmp Short H0000_C863    ;0C86D  EBF4
;---------------------------------------
H0000_C86F:
    mov ah,43h          ;0C86F  B443         C
    jmp Short H0000_C863    ;0C871  EBF0
;---------------------------------------
H0000_C873:
    mov ah,57h          ;0C873  B457         W
    jmp Short H0000_C88A    ;0C875  EB13
;- - - - - - - - - - - - - - - - - - - -
H0000_C877:
    mov cx,0FFFFh       ;0C877  B9FFFF
    mov dx,0FFE0h       ;0C87A  BAE0FF
    mov al,02h          ;0C87D  B002
    call    H0000_C90A      ;0C87F  E88800

H0000_C882:
    mov ah,3Fh          ;0C882  B43F         ?
    mov cx,0020h        ;0C884  B92000
H0000_C887:
    mov dx,104Dh        ;0C887  BA4D10       M
H0000_C88A:
    mov bx,0005h        ;0C88A  BB0500
    jmp Short H0000_C863    ;0C88D  EBD4
;---------------------------------------
H0000_C88F:
    mov cx,0018h        ;0C88F  B91800
H0000_C892:
    mov ah,40h          ;0C892  B440         @
    jmp Short H0000_C887    ;0C894  EBF1
;---------------------------------------
H0000_C896:
    mov bp,dx           ;0C896  8BEA
    mov al,00h          ;0C898  B000
    call    H0000_C86F      ;0C89A  E8D2FF

    jb  H0000_C8CD      ;0C89D  722E        r.

;SEG: CS Override
    mov cs:[0581h],cx       ;0C89F  2E890E8105  .
    test    cl,03h          ;0C8A4  F6C103
    jz  H0000_C8B2      ;0C8A7  7409        t
    mov al,01h          ;0C8A9  B001
    xor cx,cx           ;0C8AB  33C9        3
    call    H0000_C86F      ;0C8AD  E8BFFF

    jb  H0000_C8CD      ;0C8B0  721B        r
H0000_C8B2:
    mov ax,3D92h        ;0C8B2  B8923D        =
    call    H0000_C863      ;0C8B5  E8ABFF

    jb  H0000_C8CD      ;0C8B8  7213        r

;SEG: CS Override
    mov Word Ptr cs:[04E9h],ax  ;0C8BA  2EA3E904    .
    mov al,00h          ;0C8BE  B000
    call    H0000_C873      ;0C8C0  E8B0FF

;SEG: CS Override
    mov cs:[0570h],dx       ;0C8C3  2E89167005  .  p

;SEG: CS Override
    mov cs:[0573h],cx       ;0C8C8  2E890E7305  .  s
H0000_C8CD:
    ret             ;0C8CD  C3
;---------------------------------------
H0000_C8CE:

;SEG: CS Override
    mov cs:[04E9h],bx       ;0C8CE  2E891EE904  .
H0000_C8D3:
    mov al,01h          ;0C8D3  B001
    call    H0000_C906      ;0C8D5  E82E00       .

    jb  H0000_C8FA      ;0C8D8  7220        r
    push    ax          ;0C8DA  50      P
    push    dx          ;0C8DB  52      R
    push    ds          ;0C8DC  1E
    push    cs          ;0C8DD  0E

;SEG: DS Change - 0000h
    pop ds          ;0C8DE  1F
    mov Word Ptr ds:[055Dh],ax  ;0C8DF  A35D05       ]
    mov ds:[0560h],dx       ;0C8E2  89166005      `
    call    H0000_C877      ;0C8E6  E88EFF

;SEG: DS Change - Indefinite
    pop ds          ;0C8E9  1F
    pop cx          ;0C8EA  59      Y
    pop dx          ;0C8EB  5A      Z
    jb  H0000_C8F7      ;0C8EC  7209        r

;ASM: Synonym
;A  cmp ax,Word Ptr 0020h   ;0C8EE  3D2000      =
       db      3Dh,20h,00h

    jnz H0000_C8F7      ;0C8F1  7504        u
H0000_C8F3:
    mov al,00h          ;0C8F3  B000
    jmp Short H0000_C90A    ;0C8F5  EB13
;- - - - - - - - - - - - - - - - - - - -
H0000_C8F7:
    call    H0000_C8F3      ;0C8F7  E8F9FF

H0000_C8FA:
    stc             ;0C8FA  F9
    ret             ;0C8FB  C3
;---------------------------------------
H0000_C8FC:
    mov al,00h          ;0C8FC  B000
    mov dx,0000h        ;0C8FE  BA0000
    mov cx,0000h        ;0C901  B90000
H0000_C904:
    xor ax,ax           ;0C904  33C0        3
H0000_C906:
    xor cx,cx           ;0C906  33C9        3
    mov dx,cx           ;0C908  8BD1
H0000_C90A:
    mov ah,42h          ;0C90A  B442         B
    jmp Near Ptr H0000_C88A ;0C90C  E97BFF       {
;---------------------------------------
H0000_C90F:
    mov al,01h          ;0C90F  B001
    mov dx,0DEAFh       ;0C911  BAAFDE
    mov cx,2800h        ;0C914  B90028        (
    call    H0000_C873      ;0C917  E859FF       Y

    mov ah,3Eh          ;0C91A  B43E         >
    call    H0000_C88A      ;0C91C  E86BFF       k

    call    H0000_CFC8      ;0C91F  E8A606

    mov cx,0020h        ;0C922  B92000
    mov al,01h          ;0C925  B001
    jmp Near Ptr H0000_C86F ;0C927  E945FF       E
;---------------------------------------
H0000_C92A:
    mov di,dx           ;0C92A  8BFA
    mov cx,0050h        ;0C92C  B95000       P
    mov al,2Eh          ;0C92F  B02E         .
    push    ds          ;0C931  1E

;SEG: ES Change - Indefinite
    pop es          ;0C932  07
    cld             ;0C933  FC

; al=2Eh cx=0050h
    repne   scasb           ;0C934  F2AE
    jnz H0000_C940      ;0C936  7508        u
    mov ax,[di]         ;0C938  8B05
    or  ax,6060h        ;0C93A  0D6060       ``
    cmp ax,6F63h        ;0C93D  3D636F      =co
H0000_C940:
    ret             ;0C940  C3
;---------------------------------------
H0000_C941:
    call    H0000_CECE      ;0C941  E88A05

    jz  H0000_C963      ;0C944  741D        t
    call    H0000_C896      ;0C946  E84DFF       M

    jnb H0000_C950      ;0C949  7305        s
    cmp al,03h          ;0C94B  3C03        <
    ja  H0000_C95B      ;0C94D  770C        w
    ret             ;0C94F  C3
;---------------------------------------
H0000_C950:
    call    H0000_CCB4      ;0C950  E86103       a

    jnb H0000_C95B      ;0C953  7306        s
    call    H0000_CCC0      ;0C955  E86803       h

    call    H0000_C965      ;0C958  E80A00

H0000_C95B:
    jmp Short H0000_C90F    ;0C95B  EBB2
;---------------------------------------
H0000_C95D:

;SEG: CS Override
    sub Byte Ptr cs:[0571h],0C8h;0C95D  2E802E7105C8    . .q
H0000_C963:
    stc             ;0C963  F9
    ret             ;0C964  C3
;---------------------------------------
H0000_C965:
    call    H0000_CE52      ;0C965  E8EA04

    jz  H0000_C963      ;0C968  74F9        t
    push    cs          ;0C96A  0E

;SEG: DS Change - 0000h
    pop ds          ;0C96B  1F
    call    H0000_C882      ;0C96C  E813FF

    jb  H0000_C95D      ;0C96F  72EC        r
    mov si,104Dh        ;0C971  BE4D10       M
    call    H0000_CCC7      ;0C974  E85003       P

    jnz H0000_C983      ;0C977  750A        u
    cmp Byte Ptr [si],0E9h  ;0C979  803CE9       <
    jz  H0000_C98F      ;0C97C  7411        t
    mov al,00h          ;0C97E  B000
    call    H0000_CCCE      ;0C980  E84B03       K

H0000_C983:
    cmp Word Ptr [si],5A4Dh ;0C983  813C4D5A     <
    dw  7400h           ;0CFBB  0074         t
    db  05h         ;0CFBD
    db  0CDh            ;0CFBE
    db  ")Fu"           ;0CFBF  294675

;MEM: Possible Code Area
    dw  0C3F2h          ;0CFC2  F2C3
;---------------------------------------
H0000_CFC4:
;---------------------------------------
    cli             ;0CFC4  FA
    call    H0000_C83E      ;0CFC5  E876F8       v

H0000_CFC8:
    mov ax,0F3Bh        ;0CFC8  B83B0F       ;

;SEG: DS Change - 0F3Bh
    mov ds,ax           ;0CFCB  8ED8
    mov ax,9EF5h        ;0CFCD  B8F59E

;SEG: ES Change - 9EF5h
    mov es,ax           ;0CFD0  8EC0
    mov ax,4300h        ;0CFD2  B80043        C
    mov bx,0FACEh       ;0CFD5  BBCEFA
    mov cx,1981h        ;0CFD8  B98119
    mov dx,000Eh        ;0CFDB  BA0E00
    mov si,11B7h        ;0CFDE  BEB711
    mov di,008Ah        ;0CFE1  BF8A00
    mov bp,0070h        ;0CFE4  BD7000       p
    sti             ;0CFE7  FB
    ret             ;0CFE8  C3
;---------------------------------------
;MEM: Unreferenced Code
    dw  0000h           ;0CFE9  0000
;---------------------------------------
H0000_CFEB:
;---------------------------------------
    xor bx,bx           ;0CFEB  33DB        3

;SEG: DS Change - 0000h
    mov ds,bx           ;0CFED  8EDB

;SEG: DS Change - Indefinite
    lds si,DWord Ptr [bx+04h]   ;0CFEF  C57704       w
    cmp Byte Ptr [si],0CFh  ;0CFF2  803CCF       <
    jnz H0000_D010      ;0CFF5  7519        u
    cmp ah,30h          ;0CFF7  80FC30        0
    jnz H0000_D017      ;0CFFA  751B        u
    push    cx          ;0CFFC  51      Q
    push    dx          ;0CFFD  52      R
    mov ah,2Ah          ;0CFFE  B42A         *
    call    H0000_C863      ;0D000  E860F8       `

    pop bx          ;0D003  5B      [
    pop bp          ;0D004  5D      ]
    mov ax,0C47h        ;0D005  B8470C       G
    cmp bp,cx           ;0D008  3BE9        ;
    jnz H0000_D013      ;0D00A  7507        u
    cmp bx,dx           ;0D00C  3BDA        ;
    jnz H0000_D013      ;0D00E  7503        u
H0000_D010:
    mov ax,0D0Eh        ;0D010  B80E0D
H0000_D013:

;SEG: CS Override
    mov Word Ptr cs:[0487h],ax  ;0D013  2EA38704    .
H0000_D017:
    jmp Short H0000_CFC8    ;0D017  EBAF
;---------------------------------------
;MEM: Unreferenced Code
    db  "PSV"           ;0D019  505356
    dw  00E8h           ;0D01C  E800
    dw  5E00h           ;0D01E  005E         ^
    db  8Bh         ;0D020
    dw  36DCh           ;0D021  DC36         6
    db  8Bh         ;0D023
    db  "G"         ;0D024  47
    dw  3D08h           ;0D025  083D         =
    dw  0110h           ;0D027  1001
    db  "w"         ;0D029  77
    db  13h         ;0D02A
    db  "."         ;0D02B  2E
    db  89h         ;0D02C
    db  "D?6"           ;0D02D  443F36
    db  8Bh         ;0D030
    db  "G"         ;0D031  47
    dw  2E06h           ;0D032  062E         .
    db  89h         ;0D034
    db  "D=6"           ;0D035  443D36
    dw  6780h           ;0D038  8067         g
    db  0Bh         ;0D03A
    dw  0EBFEh          ;0D03B  FEEB
    dw  0E18h           ;0D03D  180E
    db  "X6;G"          ;0D03F  58363B47
    dw  7408h           ;0D043  0874         t
    dw  3610h           ;0D045  1036         6
    db  8Bh         ;0D047
    db  "G"         ;0D048  47
    dw  2E08h           ;0D049  082E         .
    db  89h         ;0D04B
    db  "DG6"           ;0D04C  444736
    db  8Bh         ;0D04F
    db  "G"         ;0D050  47
    dw  2E06h           ;0D051  062E         .
    db  89h         ;0D053
    db  "DE^[X"         ;0D054  44455E5B
    db  0CFh            ;0D059
    db  "CH"            ;0D05A  4348
    dw  109Eh           ;0D05C  9E10
    dw  0110h           ;0D05E  1001
    db  "F2F-SY"        ;0D060  4632462D
    dw  0000h           ;0D066  0000
    db  "PMRJKZHA\*.*"      ;0D068  504D524A
    dw  0C900h          ;0D074  00C9
    dw  4D00h           ;0D076  004D         M
    db  02h         ;0D078
;---------------------------------------
H0000_D079:
;---------------------------------------
;MEM: Possible Data Area
;A  call    H0000_D07C      ;0D079  E80000
       db      0E8h,00h,00h

H0000_D07C:
    pop si          ;0D07C  5E      ^
    mov ah,2Ah          ;0D07D  B42A         *

;SEG: CS Override
    mov cs:[si+02D4h],es    ;0D07F  2E8C84D402  .

;DOS1-SYS Get Date (CX=Year, DX=Month/Day, AL=Day of Week (0=Sun))
;INT: 21h  ah=2Ah
    int 21h         ;0D084  CD21         !
    mov al,72h          ;0D086  B072         r
    cmp dx,0504h        ;0D088  81FA0405
    jb  H0000_D094      ;0D08C  7206        r
    cmp cx,07C9h        ;0D08E  81F9C907
    jnb H0000_D096      ;0D092  7302        s
H0000_D094:
    mov al,0EBh         ;0D094  B0EB
H0000_D096:

;SEG: CS Override
    mov cs:[si+0F44Dh],al   ;0D096  2E88844DF4  .  M
    mov ah,30h          ;0D09B  B430         0
    cld             ;0D09D  FC

;DOS2-SYS Get AX DOS Version Number
;INT: 21h  ah=30h al=2Ah
    int 21h         ;0D09E  CD21         !
    xchg    al,ah           ;0D0A0  86C4
    cmp ax,031Dh        ;0D0A2  3D1D03      =
    ja  H0000_D0AA      ;0D0A5  7703        w
H0000_D0A7:
    jmp H0000_D336      ;0D0A7  E98C02
;---------------------------------------
H0000_D0AA:
    mov ax,0F1E9h       ;0D0AA  B8E9F1

;DOSX-DOS SERVICES - INT 21h, AH=Func
;INT: 21h  ax=F1E9h
    int 21h         ;0D0AD  CD21         !
    cmp ax,0CADEh       ;0D0AF  3DDECA      =
    jz  H0000_D0A7      ;0D0B2  74F3        t
    xor di,di           ;0D0B4  33FF        3
    mov ax,0040h        ;0D0B6  B84000       @

;SEG: DS Change - 0040h
    mov ds,ax           ;0D0B9  8ED8
    mov bp,[di+13h]     ;0D0BB  8B6D13       m
    mov cl,06h          ;0D0BE  B106
    sal bp,cl           ;0D0C0  D3E5
    mov ah,62h          ;0D0C2  B462         b

;DOS3-SYS Get BX PSP
;INT: 21h  ax=6240h cl=06h ds=0040h di=0000h
    int 21h         ;0D0C4  CD21         !

;SEG: DS Change - Indefinite
    mov ds,bx           ;0D0C6  8EDB
    push    [di+2Ch]        ;0D0C8  FF752C       u,
    push    ds          ;0D0CB  1E
    mov cl,90h          ;0D0CC  B190
    mov ax,5800h        ;0D0CE  B80058        X

;DOS3-MEM Get Memory Alloc Strategy (AX=0 1st, 1 best, 2 last fit)
;INT: 21h  ax=5800h cl=90h di=0000h
    int 21h         ;0D0D1  CD21         !
    xor ah,ah           ;0D0D3  32E4        2
    push    ax          ;0D0D5  50      P
    mov ax,5801h        ;0D0D6  B80158        X
    mov bx,0080h        ;0D0D9  BB8000

;DOS3-MEM Set BX Memory Alloc Strategy [0 1st, 1 best, 2 last fit]
;INT: 21h  ax=5801h bx=0080h cl=90h di=0000h
    int 21h         ;0D0DC  CD21         !
    mov ax,5802h        ;0D0DE  B80258        X

;DOS3-MEM Get/Set Memory Alloc Strategy
;INT: 21h  ax=5802h bx=0080h cl=90h di=0000h
    int 21h         ;0D0E1  CD21         !
    xor ah,ah           ;0D0E3  32E4        2
    push    ax          ;0D0E5  50      P
    mov ax,5803h        ;0D0E6  B80358        X
    mov bx,0001h        ;0D0E9  BB0100

;DOS3-MEM Get/Set Memory Alloc Strategy
;INT: 21h  ax=5803h bx=0001h cl=90h di=0000h
    int 21h         ;0D0EC  CD21         !
    jb  H0000_D108      ;0D0EE  7218        r
    mov ah,48h          ;0D0F0  B448         H
    mov bx,0FFFFh       ;0D0F2  BBFFFF

;DOS2-MEM Alloc BX=#Paras Memory (AX=Segment, BX=#Paras)
;INT: 21h  ax=4803h bx=FFFFh cl=90h di=0000h
    int 21h         ;0D0F5  CD21         !
    mov ah,48h          ;0D0F7  B448         H

;DOS2-MEM Alloc BX=#Paras Memory (AX=Segment, BX=#Paras)
;INT: 21h  ax=4803h bx=FFFFh cl=90h di=0000h
    int 21h         ;0D0F9  CD21         !

;SEG: ES Change - 4803h
    mov es,ax           ;0D0FB  8EC0
    cmp ax,bp           ;0D0FD  3BC5        ;
    jnb H0000_D135      ;0D0FF  7334        s4
    dec ax          ;0D101  48      H

;SEG: ES Change - 4802h
    mov es,ax           ;0D102  8EC0

;SEG: ES Override
    mov es:[di+01h],di      ;0D104  26897D01    & }
H0000_D108:
    mov ax,4300h        ;0D108  B80043        C

;DOS3-MUL Mltplx/Splr, AX=Proc/Func
;INT: 2Fh  ax=4300h bx=FFFFh cl=90h es=4802h di=0000h
    int 2Fh         ;0D10B  CD2F         /
    cmp al,80h          ;0D10D  3C80        <
    jnz H0000_D152      ;0D10F  7541        uA
    mov ax,4310h        ;0D111  B81043        C

;DOS3-MUL Mltplx/Splr, AX=Proc/Func
;INT: 2Fh  ax=4310h bx=FFFFh cl=90h es=4802h di=0000h
    int 2Fh         ;0D114  CD2F         /
    push    cs          ;0D116  0E

;SEG: DS Change - 0000h
    pop ds          ;0D117  1F

;SEG: SP Change - Indefinite
    mov [si-07h],bx     ;0D118  895CF9       \
    mov [si-05h],es     ;0D11B  8C44FB       D
    mov ah,10h          ;0D11E  B410
    mov dx,0FFFFh       ;0D120  BAFFFF

;MEM: CALL  DWORD PTR [SI-07H]

;SEG: SP Change - Indefinite
; ax=1010h bx=FFFFh cl=90h dx=FFFFh ds=0000h es=4802h di=0000h
    call    DWord Ptr [si-07h]  ;0D123  FF5CF9       \

    cmp bl,0B0h         ;0D126  80FBB0
    jnz H0000_D152      ;0D129  7527        u'
    mov ah,10h          ;0D12B  B410

;MEM: CALL  DWORD PTR [SI-07H]

;SEG: SP Change - Indefinite
; ah=10h
    call    DWord Ptr [si-07h]  ;0D12D  FF5CF9       \

    dec ax          ;0D130  48      H
    jnz H0000_D152      ;0D131  751F        u

;SEG: ES Change - Indefinite
    mov es,bx           ;0D133  8EC3
H0000_D135:
    mov cl,0C3h         ;0D135  B1C3
    mov ax,es           ;0D137  8CC0
    dec ax          ;0D139  48      H

;SEG: DS Change - Indefinite
    mov ds,ax           ;0D13A  8ED8
    mov Byte Ptr [di],5Ah   ;0D13C  C6055A        Z
    mov [di+01h],di     ;0D13F  897D01       }
    sub Word Ptr [di+03h],010Ch ;0D142  816D030C01   m
    call    H0000_CEAF      ;0D147  E865FD       e

;SEG: SP Change - Indefinite
;SEG: CS Override
    mov cs:[si+0177h],ax    ;0D14A  2E89847701  .  w
    inc ax          ;0D14F  40      @

;SEG: ES Change - Indefinite
    mov es,ax           ;0D150  8EC0
H0000_D152:
    pop bx          ;0D152  5B      [
    mov ax,5803h        ;0D153  B80358        X

;DOS3-MEM Get/Set Memory Alloc Strategy
;INT: 21h  ax=5803h
    int 21h         ;0D156  CD21         !
    pop bx          ;0D158  5B      [
    mov ax,5801h        ;0D159  B80158        X

;DOS3-MEM Set BX Memory Alloc Strategy [0 1st, 1 best, 2 last fit]
;INT: 21h  ax=5801h
    int 21h         ;0D15C  CD21         !

;SEG: DS Change - Indefinite
    pop ds          ;0D15E  1F

;SEG: CS Override
    mov cs:[si+0FE14h],cl   ;0D15F  2E888C14FE  .
    cmp cl,90h          ;0D164  80F990
    jnz H0000_D185      ;0D167  751C        u
    push    ds          ;0D169  1E

;SEG: ES Change - Indefinite
    pop es          ;0D16A  07
    mov bx,0FFFFh       ;0D16B  BBFFFF
    mov ah,4Ah          ;0D16E  B44A         J

;DOS2-MEM Set ES Memory Block, BX=#Paras (BX=#Paras)
;INT: 21h  ax=4A01h bx=FFFFh cl=58h
    int 21h         ;0D170  CD21         !
    mov ax,010Ch        ;0D172  B80C01
    sub [di+02h],ax     ;0D175  294502      )E
    sub bx,ax           ;0D178  2BD8        +
    mov ah,4Ah          ;0D17A  B44A         J

;DOS2-MEM Set ES Memory Block, BX=#Paras (BX=#Paras)
;INT: 21h  ax=4A0Ch cl=58h
    int 21h         ;0D17C  CD21         !
    mov ax,ds           ;0D17E  8CD8
    inc ax          ;0D180  40      @
    add ax,bx           ;0D181  03C3

;SEG: ES Change - Indefinite
    mov es,ax           ;0D183  8EC0
H0000_D185:
    push    si          ;0D185  56      V
    push    cs          ;0D186  0E

;SEG: DS Change - 0000h
    pop ds          ;0D187  1F
    sub si,0C0Dh        ;0D188  81EE0D0C
    mov cx,0F80h        ;0D18C  B9800F
    mov di,00CDh        ;0D18F  BFCD00

; cx=0F80h ds=0000h di=00CDh
    rep movsb           ;0D192  F3A4

;ASM: Synonym
;A  add di,+20h         ;0D194  83C720
       db      83h,0C7h,20h

;ASM: Synonym
;A  sub si,+35h         ;0D197  83EE35        5
       db      83h,0EEh,35h

    mov cx,0035h        ;0D19A  B93500       5

; cx=0035h ds=0000h
    rep movsb           ;0D19D  F3A4
    pop si          ;0D19F  5E      ^
    push    es          ;0D1A0  06
    mov ax,3521h        ;0D1A1  B82135       !5

;DOS2-SYS Get AL Interrupt Vector in ES:BX
;INT: 21h  ax=3521h cx=0035h ds=0000h
    int 21h         ;0D1A4  CD21         !

;SEG: DS Change - Indefinite
    pop ds          ;0D1A6  1F
    cwd             ;0D1A7  99
    mov di,0C47h        ;0D1A8  BF470C       G
    mov [di],dx         ;0D1AB  8915
    mov ds:[0487h],di       ;0D1AD  893E8704     >
    mov di,0082h        ;0D1B1  BF8200
    mov [di+06h],es     ;0D1B4  8C4506       E
    mov [di+04h],bx     ;0D1B7  895D04       ]
    mov [di+16h],es     ;0D1BA  8C4516       E
    mov [di+14h],bx     ;0D1BD  895D14       ]
    mov al,15h          ;0D1C0  B015

;DOS2-SYS Get AL Interrupt Vector in ES:BX
;INT: 21h  ax=3515h cx=0035h di=0082h
    int 21h         ;0D1C2  CD21         !
    mov [di+18h],bx     ;0D1C4  895D18       ]
    mov [di+1Ah],es     ;0D1C7  8C451A       E
    call    H0000_CE81      ;0D1CA  E8B4FC

    xor cx,cx           ;0D1CD  33C9        3
    call    H0000_CEB8      ;0D1CF  E8E6FC

;SEG: CS Override
    mov cs:[si-55h],es      ;0D1D2  2E8C44AB    . D
H0000_D1D6:
    or  cx,cx           ;0D1D6  0BC9
    jnz H0000_D1E5      ;0D1D8  750B        u
    mov ax,ds           ;0D1DA  8CD8
    inc ax          ;0D1DC  40      @
    cmp ax,[di+01h]     ;0D1DD  3B4501      ;E
    jnz H0000_D1E5      ;0D1E0  7503        u
    mov cx,ax           ;0D1E2  8BC8
    push    ds          ;0D1E4  1E
H0000_D1E5:

;SEG: CS Override
    cmp Byte Ptr cs:[si+0FE14h],90h
                    ;0D1E5  2E80BC14FE90    .
    jz  H0000_D1F7      ;0D1EB  740A        t
    cmp Byte Ptr [di],5Ah   ;0D1ED  803D5A       =Z
    jnz H0000_D207      ;0D1F0  7515        u
    mov ax,0EEF4h       ;0D1F2  B8F4EE
    jmp Short H0000_D215    ;0D1F5  EB1E
;- - - - - - - - - - - - - - - - - - - -
H0000_D1F7:
    cmp Word Ptr [di+0139h],0C402h
                    ;0D1F7  81BD390102C4      9
    jnz H0000_D207      ;0D1FD  7508        u
    cmp Word Ptr [di+013Bh],0F24h
                    ;0D1FF  81BD3B01240F      ; $
    jz  H0000_D20E      ;0D205  7407        t
H0000_D207:
    push    ds          ;0D207  1E

;SEG: ES Change - Indefinite
    pop es          ;0D208  07
    call    H0000_CEAF      ;0D209  E8A3FC

    jmp Short H0000_D1D6    ;0D20C  EBC8
;---------------------------------------
H0000_D20E:

;SEG: ES Override
    mov Byte Ptr es:[di],5Ah    ;0D20E  26C6055A    &  Z
    mov [di+01h],cx     ;0D212  894D01       M
H0000_D215:
    pop cx          ;0D215  59      Y
    inc cx          ;0D216  41      A
    inc ax          ;0D217  40      @

;SEG: DS Change - Indefinite
    mov ds,cx           ;0D218  8ED9

;SEG: SP Change - Indefinite
;SEG: CS Override
    mov cs:[si+0201h],cx    ;0D21A  2E898C0102  .

;SEG: SP Change - Indefinite
;SEG: CS Override
    mov cs:[si+023Fh],cx    ;0D21F  2E898C3F02  .  ?

;SEG: SP Change - Indefinite
;SEG: CS Override
    mov cs:[si+028Bh],cx    ;0D224  2E898C8B02  .
    call    H0000_D3A9      ;0D229  E87D01       }

    mov di,004Eh        ;0D22C  BF4E00       N
    call    H0000_D3AE      ;0D22F  E87C01       |

    mov Word Ptr [di+06h],0BBDh ;0D232  C74506BD0B   E
    push    ax          ;0D237  50      P
    push    cs          ;0D238  0E

;SEG: DS Change - 0000h
    pop ds          ;0D239  1F

;ASM: Synonym
;A  mov Word Ptr [si-16h],Word Ptr 0000h
                    ;0D23A  C744EA0000   D
       db      0C7h,44h,0EAh,00h,00h

    push    ax          ;0D23F  50      P
    mov ax,3501h        ;0D240  B80135        5

;DOS2-SYS Get AL Interrupt Vector in ES:BX
;INT: 21h  ax=3501h ds=0000h
    int 21h         ;0D243  CD21         !
    mov di,bx           ;0D245  8BFB
    mov bp,es           ;0D247  8CC5
    mov ah,25h          ;0D249  B425         %

;SEG: SP Change - Indefinite
    lea dx,[si-63h]     ;0D24B  8D549D       T

;DOS1-SYS Set AL Interrupt Vector in DS:DX
;INT: 21h  ax=2501h ds=0000h
    int 21h         ;0D24E  CD21         !

;SEG: ES Change - Indefinite
    pop es          ;0D250  07
    pushf               ;0D251  9C
    pop ax          ;0D252  58      X
    or  ah,01h          ;0D253  80CC01
    push    ax          ;0D256  50      P
    popf                ;0D257  9D
    mov ah,30h          ;0D258  B430         0
    pushf               ;0D25A  9C

;MEM: CALL  DWORD PTR ES:[0086H]

; ah=30h al=01h ds=0000h
    call    DWord Ptr es:[0086h]    ;0D25B  26FF1E8600  &

    mov ax,2501h        ;0D260  B80125        %
    mov dx,di           ;0D263  8BD7

;SEG: DS Change - Indefinite
    mov ds,bp           ;0D265  8EDD

;DOS1-SYS Set AL Interrupt Vector in DS:DX
;INT: 21h  ax=2501h
    int 21h         ;0D267  CD21         !
    push    cs          ;0D269  0E

;SEG: DS Change - 0000h
    pop ds          ;0D26A  1F
    push    si          ;0D26B  56      V

;ASM: Synonym
;A  add si,-20h         ;0D26C  83C6E0
       db      83h,0C6h,0E0h

    mov di,0086h        ;0D26F  BF8600
    movsw               ;0D272  A5
    movsw               ;0D273  A5
    pop si          ;0D274  5E      ^
    mov ax,[si-16h]     ;0D275  8B44EA       D
    or  ax,ax           ;0D278  0BC0
    jnz H0000_D28B      ;0D27A  750F        u
H0000_D27C:
    mov ax,0C2Ah        ;0D27C  B82A0C       *

;SEG: DS Change - 0C2Ah
    mov ds,ax           ;0D27F  8ED8
    mov dx,0005h        ;0D281  BA0500
    mov ax,2521h        ;0D284  B82125       !%

;DOS1-SYS Set AL Interrupt Vector in DS:DX
;INT: 21h  ax=2521h dx=0005h ds=0C2Ah di=0086h
    int 21h         ;0D287  CD21         !
    jmp Short H0000_D2C6    ;0D289  EB3B         ;
;- - - - - - - - - - - - - - - - - - - -
H0000_D28B:
    xor bx,bx           ;0D28B  33DB        3
    dec ax          ;0D28D  48      H
    call    H0000_D391      ;0D28E  E80001

    jz  H0000_D29B      ;0D291  7408        t

;ASM: Synonym
;A  sub ax,Word Ptr 0010h   ;0D293  2D1000      -
       db      2Dh,10h,00h

    call    H0000_D391      ;0D296  E8F800

    jnz H0000_D27C      ;0D299  75E1        u
H0000_D29B:
    cli             ;0D29B  FA
    mov bp,ds           ;0D29C  8CDD
H0000_D29E:
    inc bp          ;0D29E  45      E

;SEG: DS Change - Indefinite
    mov ds,bp           ;0D29F  8EDD
    xor bx,bx           ;0D2A1  33DB        3
H0000_D2A3:

;SEG: CS Override
    mov ax,cs:[si-20h]      ;0D2A3  2E8B44E0    . D
    cmp ax,[bx]         ;0D2A7  3B07        ;
    jnz H0000_D2BD      ;0D2A9  7512        u

;SEG: CS Override
    mov ax,cs:[si-1Eh]      ;0D2AB  2E8B44E2    . D
    cmp ax,[bx+02h]     ;0D2AF  3B4702      ;G
    jnz H0000_D2BD      ;0D2B2  7509        u

;ASM: Synonym
;A  mov Word Ptr [bx],Word Ptr 0005h
                    ;0D2B4  C7070500
       db      0C7h,07h,05h,00h

    mov Word Ptr [bx+02h],0C2Ah ;0D2B8  C747022A0C   G *
H0000_D2BD:
    inc bx          ;0D2BD  43      C
    cmp bl,10h          ;0D2BE  80FB10
    jnz H0000_D2A3      ;0D2C1  75E0        u
    loop    H0000_D29E      ;0D2C3  E2D9
    sti             ;0D2C5  FB
H0000_D2C6:

;SEG: ES Change - Indefinite
    pop es          ;0D2C6  07
    push    cs          ;0D2C7  0E

;SEG: DS Change - 0000h
    pop ds          ;0D2C8  1F
    mov ah,1Ah          ;0D2C9  B41A

;SEG: SP Change - Indefinite
    lea dx,[si+0373h]       ;0D2CB  8D947303      s
    mov bx,dx           ;0D2CF  8BDA

;DOS1-DSK Set DTA in DS:DX (default is 0080h in PSP)
;INT: 21h  ah=1Ah ds=0000h
    int 21h         ;0D2D1  CD21         !
    mov ah,4Eh          ;0D2D3  B44E         N
    mov cx,0008h        ;0D2D5  B90800

;SEG: SP Change - Indefinite
    lea dx,[si-0Ch]     ;0D2D8  8D54F4       T

;DOS2-DSK Find First DS:DX File, CL=Attr
;INT: 21h  ah=4Eh cx=0008h ds=0000h
    int 21h         ;0D2DB  CD21         !
    mov ax,[bx+16h]     ;0D2DD  8B4716       G
    mov cx,[bx+18h]     ;0D2E0  8B4F18       O
    cmp ax,6F55h        ;0D2E3  3D556F      =Uo
    jnz H0000_D2EE      ;0D2E6  7506        u
    cmp cx,1981h        ;0D2E8  81F98119
    jz  H0000_D2F4      ;0D2EC  7406        t
H0000_D2EE:

;SEG: ES Override
    mov Byte Ptr es:[0127h],0EBh;0D2EE  26C6062701EB    &  '
H0000_D2F4:

;SEG: ES Override
    mov Word Ptr es:[0F42h],ax  ;0D2F4  26A3420F    & B

;SEG: ES Override
    mov es:[0F48h],cx       ;0D2F8  26890E480F  &  H
    push    es          ;0D2FD  06

;SEG: DS Change - Indefinite
    pop ds          ;0D2FE  1F
    cmp Byte Ptr ds:[0127h],0EBh;0D2FF  803E2701EB   >'
    jz  H0000_D313      ;0D304  740D        t
    mov bx,0C2Ah        ;0D306  BB2A0C       *

;SEG: DS Change - 0C2Ah
    mov ds,bx           ;0D309  8EDB
    mov ax,2515h        ;0D30B  B81525        %
    mov dx,0053h        ;0D30E  BA5300       S

;DOS1-SYS Set AL Interrupt Vector in DS:DX
;INT: 21h  ax=2515h bx=0C2Ah cx=0008h dx=0053h ds=0C2Ah
    int 21h         ;0D311  CD21         !
H0000_D313:

;SEG: DS Change - Indefinite
    pop ds          ;0D313  1F
    xor bx,bx           ;0D314  33DB        3
H0000_D316:
    cmp Word Ptr [bx],4F43h ;0D316  813F434F     ?CO
    jnz H0000_D323      ;0D31A  7507        u
    cmp Word Ptr [bx+06h],3D43h ;0D31C  817F06433D     C=
    jz  H0000_D32B      ;0D321  7408        t
H0000_D323:
    inc bx          ;0D323  43      C
    cmp bh,08h          ;0D324  80FF08
    jnz H0000_D316      ;0D327  75ED        u
    jmp Short H0000_D336    ;0D329  EB0B
;- - - - - - - - - - - - - - - - - - - -
H0000_D32B:
    lea dx,[bx+08h]     ;0D32B  8D5708       W
    mov ax,4300h        ;0D32E  B80043        C
    mov bx,0FACEh       ;0D331  BBCEFA

;DOS2-DSK CHMOD Get/Set DS:DX File CL Attrs: AL: 00=Get 01=Set
;INT: 21h  ax=4300h bx=FACEh cx=0008h dx=0053h
    int 21h         ;0D334  CD21         !
H0000_D336:

;MEM: Possible Data Area
;A  call    H0000_D339      ;0D336  E80000
       db      0E8h,00h,00h

H0000_D339:
    pop si          ;0D339  5E      ^
    xor ax,ax           ;0D33A  33C0        3

;SEG: SP Change - Indefinite
    lea di,[si+0F136h]      ;0D33C  8DBC36F1      6
    mov cx,076Bh        ;0D340  B96B07       k
    push    cs          ;0D343  0E

;SEG: ES Change - 0000h
    pop es          ;0D344  07

; ax=0000h cx=076Bh es=0000h
    rep stosw           ;0D345  F3AB

;ASM: Synonym
;A  add di,+4Dh         ;0D347  83C74D        M
       db      83h,0C7h,4Dh

    mov cx,005Eh        ;0D34A  B95E00       ^

; ax=0000h cx=005Eh es=0000h
    rep stosb           ;0D34D  F3AA
    mov bx,12A8h        ;0D34F  BBA812

;SEG: DS Change - 12A8h
    mov ds,bx           ;0D352  8EDB
    push    ds          ;0D354  1E

;SEG: ES Change - 12A8h
    pop es          ;0D355  07
    mov dx,0080h        ;0D356  BA8000
    mov ah,1Ah          ;0D359  B41A

;DOS1-DSK Set DTA in DS:DX (default is 0080h in PSP)
;INT: 21h  ax=1A00h bx=12A8h cx=005Eh dx=0080h ds=12A8h es=12A8h
    int 21h         ;0D35B  CD21         !
    mov al,01h          ;0D35D  B001
    or  al,al           ;0D35F  0AC0
    jz  H0000_D36C      ;0D361  7409        t
    mov Word Ptr ds:[0101h],16ADh
                    ;0D363  C7060101AD16
    push    cs          ;0D369  0E
    jmp Short H0000_D37E    ;0D36A  EB12
;- - - - - - - - - - - - - - - - - - - -
H0000_D36C:
    cli             ;0D36C  FA
    mov ax,cs           ;0D36D  8CC8
    sub ax,0FAC0h       ;0D36F  2DC0FA      -

;SEG: SS Change - Indefinite
    mov ss,ax           ;0D372  8ED0

;SEG: SP Change - 13D5h
    mov sp,13D5h        ;0D374  BCD513
    sti             ;0D377  FB
    mov ax,cs           ;0D378  8CC8
    sub ax,0FAC0h       ;0D37A  2DC0FA      -
    push    ax          ;0D37D  50      P
H0000_D37E:
    mov ax,0100h        ;0D37E  B80001
    push    ax          ;0D381  50      P
    sti             ;0D382  FB
    xor ax,ax           ;0D383  33C0        3
    mov bx,ax           ;0D385  8BD8
    mov cx,ax           ;0D387  8BC8
    cwd             ;0D389  99
    mov si,ax           ;0D38A  8BF0
    mov di,ax           ;0D38C  8BF8
    mov bp,ax           ;0D38E  8BE8
    retf                ;0D390  CB
;---------------------------------------
H0000_D391:

;SEG: DS Change - Indefinite
    mov ds,ax           ;0D391  8ED8
    cmp Byte Ptr [bx],44h   ;0D393  803F44       ?D
    jz  H0000_D39D      ;0D396  7405        t
    cmp Byte Ptr [bx],4Dh   ;0D398  803F4D       ?M
    jnz H0000_D3A8      ;0D39B  750B        u
H0000_D39D:
    mov ax,[bx+03h]     ;0D39D  8B4703       G
    cmp ah,0A0h         ;0D3A0  80FCA0
    ja  H0000_D3A8      ;0D3A3  7703        w
    xchg    ax,cx           ;0D3A5  91
    xor bp,bp           ;0D3A6  33ED        3
H0000_D3A8:
    ret             ;0D3A8  C3
;---------------------------------------
H0000_D3A9:
    mov Word Ptr [di+06h],00F8h ;0D3A9  C74506F800   E
H0000_D3AE:
    mov Byte Ptr [di+05h],0EAh  ;0D3AE  C64505EA     E
    mov [di+08h],ax     ;0D3B2  894508       E
    ret             ;0D3B5  C3
;---------------------------------------
;MEM: Unreferenced Code
    db  01h         ;0D3B6
    db  03h         ;0D3B7
    dw  0200h           ;0D3B8  0002
    dw  1CE8h           ;0D3BA  E81C
    dw  0B900h          ;0D3BC  00B9
    dw  0FA0h           ;0D3BE  A00F
    dw  0CDBAh          ;0D3C0  BACD
    dw  0B400h          ;0D3C2  00B4
    db  "@"         ;0D3C4  40
    dw  0FF9Ch          ;0D3C5  9CFF
    dw  861Eh           ;0D3C7  1E86
    dw  9C00h           ;0D3C9  009C
    db  "PQ"            ;0D3CB  5051
    dw  00B0h           ;0D3CD  B000
    dw  95A2h           ;0D3CF  A295
    dw  0E810h          ;0D3D1  10E8
    dw  0004h           ;0D3D3  0400
    db  "YX"            ;0D3D5  5958
    db  9Dh         ;0D3D7
    db  0C3h            ;0D3D8
    dw  00B8h           ;0D3D9  B800
    dw  0BF00h          ;0D3DB  00BF
    db  "K"         ;0D3DD  4B
    dw  0B910h          ;0D3DE  10B9
    dw  0000h           ;0D3E0  0000
    db  "1"         ;0D3E2  31
    db  05h         ;0D3E3
    db  05h         ;0D3E4
    dw  0000h           ;0D3E5  0000
    db  "GG"            ;0D3E7  4747
    dw  0F7E2h          ;0D3E9  E2F7
    db  0C3h            ;0D3EB
    db  "2"         ;0D3EC  32
    dw  0CFC0h          ;0D3ED  C0CF
    db  0F3h            ;0D3EF
    dw  0BAC0h          ;0D3F0  C0BA
    db  85h         ;0D3F2
    db  ":o"            ;0D3F3  3A6F
    dw  0F608h          ;0D3F5  08F6
    db  "E]"            ;0D3F7  455D
    dw  0E69Ch          ;0D3F9  9CE6
    db  0EFh            ;0D3FB
    dw  0E08Eh          ;0D3FC  8EE0
    db  "$"         ;0D3FE  24
    db  "o]L"           ;0D3FF  6F5D4C
    dw  02B0h           ;0D402  B002
    db  ">"         ;0D404  3E
    dw  87C8h           ;0D405  C887
    db  9Dh         ;0D407
    db  0ECh            ;0D408
    db  "
