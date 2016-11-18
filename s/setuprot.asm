;*******************************************************************************
;* This module contains the routines that set up the IDT, and any              *
;* TSS's in preparation for jumping to protected mode. It also contains        *
;* routines tomove the code to high memory, and to move the hardware interrupts*
;*******************************************************************************

;Data areas to store GDT and IDT pointers to load registers from
GDT_PTR         DW      7*8-1                   ;GDT info to load with lgdt
                DD      110000H + OFFSET GDT

IDT_PTR         DW      IDT_ENTRIES*8-1         ;IDT info to load with lidt
                DD      110000H + OFFSET IDT


;Set up IDT for protected mode switch.
SETUP_IDT:
                mov     ax,OFFSET NOT_IMPLEMENTED       ;Now set up default hndlr
                mov     bx,CODE_1_SEL
                mov     ch,PRESENT or DPL_0 or INTERRUPT_GATE
                xor     dx,dx
                mov     cl,dl
                mov     di,OFFSET IDT
                call    SET_GDT_ENTRY

                push    ds
                mov     ax,cs
                mov     es,ax
                mov     ds,ax
                mov     ax,IDT_Entries - 1              ;set up all IDT entries
                mov     cx,8                            ;using default hndlr
                mul     cx
                mov     cx,ax                           ;bytes to move
                mov     si,OFFSET IDT
                mov     di,OFFSET IDT + 8
                rep     movsb                           ;fill the table
                pop     ds

                mov     ax,OFFSET GENERAL_FAULT         ;General prot fault hndlr
                mov     bx,CODE_1_SEL
                mov     ch,PRESENT or DPL_0 or INTERRUPT_GATE
                mov     cl,0
                mov     dx,0
                mov     di,OFFSET IDT + (13 * 8)        ;first entry to start
                call    SET_GDT_ENTRY

                mov     ax,OFFSET TIMER_HANDLER         ;set up 1st 8259 hwre ints
                mov     di,OFFSET IDT + (20H * 8)
SET_LP0:        mov     cx,8
SET_LP1:        push    ax
                push    cx
                push    di
                mov     bx,CODE_1_SEL
                mov     ch,PRESENT or DPL_0 or INTERRUPT_GATE
                xor     dx,dx
                mov     cl,dl
                call    SET_GDT_ENTRY
                pop     di
                pop     cx
                pop     ax
                add     ax,5                            ;size of each handler header
                add     di,8
                loop    SET_LP1

                cmp     di,OFFSET IDT + (30H * 8)       ;last one?
                jz      SET_LP2
                mov     di,OFFSET IDT + (28H * 8)
                jmp     SET_LP0

SET_LP2:        ret

;This procedure moves the protected mode code into high memory, at 11000:0000,
;in preparation for transferring control to it in protected mode.
MOVE_CODE       PROC    NEAR
                mov     ax,cs           ;calculate absolute address of TASK1 segment
                xor     bx,bx
                shl     ax,1
                rcl     bx,1
                shl     ax,1
                rcl     bx,1
                shl     ax,1
                rcl     bx,1
                shl     ax,1
                rcl     bx,1
                mov     WORD PTR [MOVE_GDT+18],ax
                mov     BYTE PTR [MOVE_GDT+20],bl
                mov     cx,7E00H / 2    ;words to move to high memory
                mov     ax,cs
                mov     es,ax           ;es:si points to GDT for move
                mov     si,OFFSET MOVE_GDT
                mov     ah,87H          ;BIOS move function
                int     15H             ;go do it
                retn
MOVE_CODE       ENDP

;Global descriptor table for use by MOVE_CODE
MOVE_GDT        DB      16 dup (0)
                DW      0FFFFH          ;source segment limit
                DB      0,0,0           ;absolute source segment address
                DB      93H             ;source segment access rights
                DW      0
                DW      0FFFFH          ;destination segment limit
                DB      0,0,11H         ;absolute destination segment address (11000:0000)
                DB      93H             ;destination segment access rights
                DW      0
                DB      16 dup (0)

;This function sets up a GDT entry. It is called with DI pointing to the
;GDT entry to be set up, and AL= 1st byte, AH = 2nd, BL = 3rd, BH = 4th
;CL = 5th, CH=6th, DL=7th and DH = 8th byte in the GDT entry.
SET_GDT_ENTRY:
                push    ax
                push    ax
                mov     ax,cs
                mov     es,ax
                pop     ax
                stosw
                mov     ax,bx
                stosw
                mov     ax,cx
                stosw
                mov     ax,dx
                stosw
                pop     ax
                ret


;Turn A20 line on in preparation for going to protected mode
GATE_A20:
                call    EMPTY_8042
                mov     al,0D1H
                out     64H,al
                call    EMPTY_8042
                mov     al,0DFH
                out     60H,al
                call    EMPTY_8042
                ret

;This waits for the 8042 buffer to empty
EMPTY_8042:
                in      al,64H
                and     al,2
                jnz     EMPTY_8042
                ret



INTA00          EQU     20H             ;interrupt controller i/o ports
INTA01          EQU     21H

;Interrupts must be off when the following routine is called! It moves the
;base of the hardware interrupts for the 8259 from 8 to NEW_INT_LOC. It also
;masks all interrupts off for the 8259.
CHANGE_INTS:
                mov     al,0FFH         ;mask all interrupt controller interrupts off
                out     INTA01,al

                mov     al,11H          ;send new initialization sequence to the first 8259 controller
                out     INTA00,al       ;ICW1
                mov     al,NEW_INT_LOC  ;base of interrupt vectors at NEW_LOC
                out     INTA01,al       ;ICW2
                mov     al,04H          ;other parameters same as original IBM AT
                out     INTA01,al       ;ICW3
                mov     al,01H
                out     INTA01,al

                ret
