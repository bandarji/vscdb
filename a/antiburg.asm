; **********************************************************************
;
; priklad programu na vyhledani viroveho priznaku - v case souboru 31/30 min
; autor R.Burger 1988
;
; upraveno,odstraneny chyby,lze prekladat pomoci TASM,po linkovani
; vyprodukovat COM soubor,nebot na mnoha mistech je usetreno definovani
; rozumne hodnoty DS
;***********************************************************************

CODE    SEGMENT
        ASSUME  CS:CODE
        ASSUME  DS:NOTHING
        ASSUME  ES:NOTHING

        ORG     100H

START:  LEA     DX,MESSTA       ; uvodni hlaseni
        MOV     AH,9
        INT     21H
; cteme jmeno
        LEA     DX,CHARCOUNT
        MOV     BX,DX
        MOV     AH,10
        INT     21H
; ukoncit nulou
        MOV     AH,0
        MOV     AL,CS:BYTE PTR [BX+1]
        ADD     BX,AX
        ADD     BX,2
        MOV     BYTE PTR CS:[BX],0
; otevrit soubor
        MOV     AH,3DH
        MOV     AL,0
        LEA     DX,KBDBUF
        INT     21H
        JC      ERROPE          ; chyba
        MOV     BX,AX           ; cislo souboru
        MOV     AH,57H          ; datum/cas
        MOV     AL,0
        INT     21H
        JC      ERRRED          ; chyba
        AND     CX,1FH
        CMP     CX,1FH
        JNZ     OK1             ; v poradku
; priznak viru nalezen
VIR:    LEA     DX,MESVIR
        MOV     AH,9
        INT     21H
        JMP     CLOSE
; soubor nelze otevrit
ERROPE: LEA     DX,MESOPE
        MOV     AH,9
        INT     21H
        JMP     ENDE
; datum nejde precist
ERRRED: LEA     DX,MESRED
        MOV     AH,9
        INT     21H
        JMP     CLOSE
; vse ok
OK1:    LEA     DX,MESOK1
        MOV     AH,9
        INT     21H
; uzavrit soubor
CLOSE:  MOV     AH,3EH
        INT     21H
        JNC     ENDE
        MOV     AH,9
        LEA     DX,MESCLO               ; nejde zavrit
        INT     21H
ENDE:   MOV     AH,0
        INT     21H

MESOK1: DB      10,13,'Neni priznak viru $'
MESRED: DB      10,13,7,'Nelze cist datum $'
MESOPE: DB      10,13,7,'Nelze otevrit soubor $'
MESVIR: DB      10,13,7,'Priznak viru 31/30 min $'
MESCLO: DB      10,13,7,'Nelze uzavrit soubor $'
MESSTA: DB      10,13,'Detektor viru 31/30 min'
        DB      10,13,'Jmeno souboru: $'

CHARCOUNT:
        DB      65,0
KBDBUF: DB      65 DUP(0)

CODE    ENDS
        END     START

begin 775 antiburg.com
MNND!M`G-(;H4`HO:M`K-(;0`+HI'`0/8@\,"+L8'`+0]L`"Z%@+-(7(NK4!M`G-(>L<`;0)S2'K'Y"ZAP&T"F4@8VES="!D871U;2`D"@T'3F5L>F4@;W1E=G)I="!S;W5B;W(@
M)`H-!U!R:7IN86L@=FER=2`S,2\S,"!M:6X@)`H-!TYE;'IE('5Z879R:70@
M<````````````````````````````````````````
`
end
