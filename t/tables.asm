;*******************************************************************************
; Tables for use in protected mode, including the GDT, IDT, and relevant TSS's *
;*******************************************************************************

;A GDT entry has the following form:
;               DW      ?                       ;segment limit
;               DB      ?,?,?                   ;24 bits of absolute address
;               DB      ?                       ;access rights
;               DB      ?                       ;extended access rights
;               DB      ?                       ;high 8 bits of 32 bit absolute address

GDT             DQ      0                       ;First GDT entry must be 0

                DW      0FFFFH                  ;BIOS data selector (at 0:0)
                DB      0,0,0
                DB      TYP_READ_WRITE or DTYPE_MEMORY or DPL_0 or PRESENT
                DB      GRANULAR_4K             ;you can get at any @ in low memory with this
                DB      0

                DW      TSS_Size                ;TSS for task 1 (startup)
                DW      OFFSET TSS_1
                DB      11H
                DB      TYP_TASK or DPL_0 or PRESENT
                DB      0,0

                DW      0FFFFH                  ;Task 1 code segment selector
                DB      0,0,11H                 ;starts at 110000H
                DB      TYP_EXEC_READ or DTYPE_MEMORY or DPL_0 or PRESENT
                DB      TYPE_32,0

                DW      0FFFFH                  ;Task 1 data selector
                DB      0,0,11H                 ;at 110000H
                DB      TYP_READ_WRITE or DTYPE_MEMORY or DPL_0 or PRESENT
                DB      TYPE_32,0

                DW      TSS_Size+IOMAP_SIZE     ;TSS for task 2
                DW      OFFSET TSS_2
                DB      11H
TSS_TYPEFL:     DB      TYP_TASK or DPL_3 or PRESENT
                DW      0

                DW      00FFFH                  ;Video RAM selector
                DW      (VIDEO_SEG SHL 4) and 0FFFFH
                DB      VIDEO_SEG SHR 12
                DB      TYP_READ_WRITE or DTYPE_MEMORY or DPL_0 or PRESENT
                DB      0,0

;End of GDT

;This is the task state segment for the virtual machine
TSS_2           DW      0               ;back link
                DW      0               ;filler
                DD      TASK2_STACK0+STACK_SIZE    ;esp0
                DW      DATA_1_SEL      ;ss0
                DW      0               ;filler
                DD      0               ;esp1
                DW      DATA_1_SEL      ;ss1
                DW      0               ;filler
                DD      0               ;esp2
                DW      DATA_1_SEL      ;ss2
                DW      0               ;filler
                DD      0               ;cr3
                DD      7C00H           ;eip
                DD      23000H          ;eflags (set VM flag, IOPL=3)
                DD      0               ;eax
                DD      0               ;ecx
                DD      0               ;edx
                DD      0               ;ebx
                DD      STACK_SIZE      ;esp
                DD      0               ;ebp
                DD      0               ;esi
                DD      0               ;edi
                DW      0               ;es
                DW      0               ;filler
                DW      0               ;cs
                DW      0               ;filler
                DW      0               ;ss
                DW      0               ;filler
                DW      0               ;ds
                DW      0               ;filler
                DW      0               ;fs
                DW      0               ;filler
                DW      0               ;gs
                DW      0               ;filler
                DW      0               ;ldt
                DW      0               ;filler
                DW      0               ;exception on task switch bit
                DW      OFFSET TSS2IO - OFFSET TSS_2   ;iomap offfset pointer

TSS2IO          DB      3EH dup (0)
                DB      080H                    ;trap io to port 1F7H (hard disk command register)
                DB      IOMAP_SIZE-40H dup (0)
                DB      0FFH                    ;dummy byte for end of io map
                