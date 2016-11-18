; -------------------------------------------------------------------------
; ROZ.ASM - Rozpravka o zlom pascalistovi     Sourced by Roman_S  (c) 1991
; -------------------------------------------------------------------------

INT_8       equ 20h         ;Interrupt 0x08  (8*4=20h)
video_cntr  equ 463h            ;Video controller port
timer_count equ 46Ch            ;Timer tick (since CPU reset)
x_sur       equ 8           ;Suradnica x=4,y=0

code        segment byte public
        assume  cs:code, ds:code

        org 100h
roz     proc    far
start:      jmp main

video_adr   dw  0B800h          ;Sem si ulozi zac. video adr
old_timer   dd  00000h          ;Old timer address
; ----------------------------------------------------------------
new_timer:  push    ax          ;Backup AX
        push    es          ;Backup ES
        mov ax,0
        mov es,ax           ;Set ES = 0
        mov al,es:timer_count   ;AL = system timer count
        pop es          ;Restore ES
        and al,5            ;Kazdych 5 tikov akcia
        jnz no
        call    action

no:     pop ax          ;Restore AX
end_timer:  jmp cs:old_timer        ;Original Interrupt
; -------------------------------------------------------------------
ofset       dw  124h
text        db  '                                                 Ahoj, mile deticky.   Dnes vam poviem novu rozpravku. Urcite ju vsak uz poznate. Vola sa                     O ZLOM PASKALISTOVI'
        db  '                   Kde bolo, tam bolo, zila stara dobra zena, ktora vychovala strnast chlapcov ako @. Vsetci boli prenesmierne inteligentni, iba ten naj@ robil v Pascale.     Jedneho dna prisla medzi nich ma'
        db  't a povedala : "Vstavajte @, berte sa hor !!!      Starej mame niekto znenazdajky ukazal pascalovsky program a uz treti den lezi s vysokymi teplotami. Niekto by sa mohol obetovat a ist ju doopatrovat. "     Ty ty ty ty ty ! '
        db  'Ano, ty ! @ moj najdrahsi, pascalista najtuhsi, vyznavac tejto pliagy najvacsi, mal by si sa pokusit odcinit svoju prevelku vinu a ist tam.      Nas hrdina zobral zopar peknych listingov (mysliac si, ze staru mamu uplne dora'
        db  'zi) a pobral sa cestou-necestou.    Ide, ide a premysla : Nech zije PASCAL. S Pascalom na vecne casy a nikdy inak !      Len ten team je pevny, isty, v ktorom vladnu pascalisti !      Jeden program denne.       atakdalej ata'
        db  'kdalej atakdalej a podobne paranoidne myslienky mu rezonuju v hlave. Babku a svojich starsich bratov nikdy nevedel pochopit. Sice vzdy pisali lepsie a efektivnejsie programy, ktore im v C-cku chodili trikrat rychlejsie a bol'
        db  'i podstatne prehladnejsie a pouzivatelnejsie na vsetko ale nikdy nevedeli pochopit, ze JEDINOU spravnou cestou je paskal.  ... a este dalsie myslienky mu kruzili hlavou ako ventilator.           Ide............   (psycho I) '
        db  '                 Ide............   (psycho II)                 Ide............   a zrazu mu trajektoriu pretal matny tien. Z krovia sa vytrcila chlpata hlava vlka s velkymi usami a vecne vlhkym jazykom. A hovori : "Ahoj @. K'
        db  'am ides ?"  -  "No predsa k starej mame, vlcik."  -  "A kde byva tvoja draha stara mama ?"  -  "Aaale, za lesom v chalupke."  -  "Tak ahoj." ...a vlk sa pobral svojou cestou.          Nas hrdina si potom dve hodiny lamal hla'
        db  'vu nad tym, ci vlk programuje v pascale alebo v C-cku.         (* Pasol Jano tri voly u haja. Pasol Jano tri voly u haja. Pasol Jano tri voly na zelenej dateli. Pasol Jano tri voly u haja. *)           Vlk pozorne sledoval m'
        db  'iznuceho @. Ako poriadny C-ckar spravne odhadol situaciu a pri znamom zapachu pascalovskych programov sa v nom ozval sucit so staruckou babickou. Rozhodol sa konat.          (* Tri dni ma nahanali, aj tak ma nedostali tri dn'
        db  'i ma este budu, aj tak ma nedostanu    ! *)             Zatial @ prisiel k znamej chalupke s rozmachom kopol do dveri. Zvnutra sa ozvalo : "Kto tam ?" Otvoril dvere, vosiel dnu a uvidel babicku. Hovori : "Babka, preco mas ta'
        db  'ke velke oci ?" - "Lebo som videla pascalovsky program." - "A preco mas take velke usi ?" - "*" - "A preco mas take velke ZUBY ? " --- "Aby som mohla ucinnejsie likvidovat paskalistov.            HAM.             HAM.   Auuu'
        db  '...          HAM.                       Hned nato babicka Kernighan vyliezla spod postele a spolocne s vlkom Ritchiem oslavili vitazstvo flasou ginu.                                                 ',0
hodnota_cntr    dw  0
roz     endp

; -----------------------------------------------------------------------
action      proc    near            ;Volane z INT 8 kazdych 5 tikov
        push    ax          ;Backup
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    si
        push    di
        push    bp
        call    asi_zrnenie     ;Testovanie DMA
        mov ah,0Fh          ;Read video mode
        int 10h         ;Video display al = mode
        mov cs:video_adr,0B000h ;MDA display
        cmp al,7
        je  monochrom
        mov cs:video_adr,0B800h ;CGA,EGA...
monochrom:  mov ax,cs:video_adr
        mov es,ax           ;Set ES to begin video
        cmp byte ptr es:x_sur,'F'   ;Compare Video pos 4 & "File"
        jne no_pascal
        cmp byte ptr es:x_sur+2,'i'
        jne no_pascal
        cmp byte ptr es:x_sur+4,'l'
        jne no_pascal
        cmp byte ptr es:x_sur+6,'e'
        jne no_pascal
        xor ax,ax           ;Zero DS
        mov ds,ax
        mov ax,ds:video_cntr    ;Video controller chip
        add ax,6
        mov cs:hodnota_cntr,ax  ;Save
        mov si,cs:ofset     ;Offset v texte
        inc cs:ofset        ;Posun sa v nom
        call    asi_zrnenie
        mov di,960h         ;15 * (80*2)  15ty riadok
        mov cx,80           ; 1 line
        mov ah,7            ;Black & White

next:       mov al,cs:[si]      ;Char from text
        or  al,al           ;Koniec textu ?
        jnz cont            ;Jump if no
        mov cs:ofset,offset text    ;Set to begin text
cont:       mov es:[di],ax      ;Push to video
        inc si          ;Next char 
        add di,2            ;Next video pos
        loop    next            ;All char
  
no_pascal:  pop bp          ;Nie je dovod k vypisu
        pop di          ;Restore registers
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        retn                ;Return from action
action      endp

; --------------------------------------------------------------------------
asi_zrnenie proc    near
        retn            ; Tu sa zasluckuje ak nie je PP 06
        mov dx,cs:hodnota_cntr  ;Cntr + 4 port
cakaj1:     in  al,dx           ;Port 0, DMA-1 bas&add ch 0
        and al,8
        jnz cakaj1          ;Jump if not zero
cakaj2:     in  al,dx           ;Port 0, DMA-1 bas&add ch 0
        and al,8
        jz  cakaj2          ;Jump if zero
        retn
asi_zrnenie endp
rezident    label byte          ;Po tadialto rezidentne

; ------------------------------------------------------------------------
program     proc    near
        mov ax,0
        mov es,ax           ;Set ES = 0
        cli             ;Disable interrupts
        mov bx,es:INT_8     ;Old timer
        mov ax,es:INT_8+2
        mov word ptr old_timer,bx   ;Save
        mov word ptr old_timer+2,ax
        mov word ptr es:INT_8,offset new_timer
        mov es:INT_8+2,cs       ;Set INT 8 to new_timer
        sti             ;Enable interrupts
        retn
program     endp

main:       call    program
        mov dx,offset rezident  ;Last addres to keep
        int 27h         ;Terminate & stay resident

code        ends
        end start
        