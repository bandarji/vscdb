;       GUNS N' ROSES Polymorphic Engine --- DEMO
;       This program can generates 50 polymorphic programs.
;       (C) Copyright 1994 Written by Slash Wu. All Rights Reserved.
;       Made In Taiwan.

;       �j�P�����h�Τ��� --- �ܽd�{��
;       �o�ӵ{��������� 50 �Ӧh�ε{���C
;       ���v�Ҧ�, ½�L���s 1994 �d�T�n�Ҽg�C �O�d�Ҧ����v�C
;       �b�x�W�s�y�C


        .MODEL  TINY

        .CODE

        ORG     100H

        EXTRN   GPE:NEAR, GPE_END:NEAR  ;�ϥή�, �@�w�n�ŧi GPE ���~���ҲաC


BEGIN:
        MOV     DX,OFFSET GEN_MSG
        MOV     AH,9
        INT     21H

        MOV     CX,50
GEN:
        PUSH    CX

        MOV     DX,OFFSET FILENAME
        PUSH    CS
        POP     DS
        XOR     CX,CX
        MOV     AH,3CH
        INT     21H

        PUSH    AX

        MOV     DX,OFFSET PROG  ;�ϥή�, DS:DX �n���V�������h�ε{�����}�Y�C
        MOV     CX,OFFSET PROG_END - OFFSET PROG;�ϥή�, CX �Ȧs���n���w��
                                                ;�����h�Ϊ��{�����סC
        MOV     BX,100H ;�ϥή�, BX �Ȧs���n���w�h�ε{������ɪ�������},
                        ;��Y IP �ȡC
        PUSH    SS
        POP     AX
        ADD     AX,1000H
        MOV     ES,AX   ;�ϥή�, ES �`�ϼȦs���n���w�Ψ��\ GPE �Ҳ��ͥX��
                        ;�h�ε{��, ��Y�y�h�θѽX�{���z�ϡy�w�s�X�{���z,
                        ;�� ES:0 �}�l�s��C
                        ;���B�ѩ󵧪̰��i, �����ϥε{���U�誺�O����, �Фj
                        ;�a�ϥΥ��T����k�Ӱt�m�O����C

        CALL    GPE     ;OK! �@���N�ǫ�, �N�i�H�}�l�I�s�y�j�P�����h�Τ����z
                        ;��!
                        ;�y�j�P�����h�Τ����z��^��, DS:DX ���V���ͥX�Ӫ�
                        ;�h�ε{��, ��Y�y�h�θѽX�{���z�ϡy�w�s�X�{���z,
                        ;CX �Ȧs���O���۩Ҳ��ͥX�Ӫ��h�ε{������, ��Y�y�h
                        ;�θѽX�{���z�ϡy�w�s�X�{���z�����סC

        POP     BX
        MOV     AH,40H
        INT     21H

        MOV     AH,3EH
        INT     21H

        MOV     BX,OFFSET FILENAME
        INC     BYTE PTR CS:BX+7
        CMP     BYTE PTR CS:BX+7,'9'
        JBE     L0
        MOV     BYTE PTR CS:BX+7,'0'
        INC     BYTE PTR CS:BX+6
L0:
        POP     CX
        LOOP    GEN

        INT     20H

FILENAME DB     '00000000.COM',0

GEN_MSG DB      'Generating 50 polymorphic programs... $'

PROG:
        MOV     DX,OFFSET MSG - OFFSET PROG + 100H
        MOV     AH,9
        INT     21H
        INT     20H
MSG     DB      'I am a polymorphic program.$'
PROG_END:


        END     BEGIN
        