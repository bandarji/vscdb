;**********************************************************************************************
;*                                                                                            *
;*  FILE:     KILL_REP.ASM (c) 1993                                                           *
;*  PURPOSE:  Remove REPLICATOR boot sector virus infection from fixed disk                   *
;*  AUTHOR:   Willoughby    DATE: 04/19/93                                                    *
;*                                                                                            *
;**********************************************************************************************
;
;Load MBR and check for VIRUS_BOOT.
;
        PUSH CS                                                               
        POP ES                                  ;Set ES to KILL_REP code segment.  
        PUSH CS                                                               
        POP DS                                  ;Set DS to KILL_REP code segment.      
        MOV AX,0201                             ;Select read-1-sector function.  
        MOV BX,0400                             ;Set disk I/O buffer offset.           
        MOV CX,0001                             ;Track 0, sector 1.                     
        MOV DX,0080                             ;Head 0, fixed disk 1.                  
        INT 013                                 ;Read MBR.                              
        JB >E1                                  ;Exit if flag=failure.                  
        CMP W[BX+0138],0ABCD                    ;Check for VIRUS_BOOT infection tag.
        JNE >E1                                 ;If not infected then exit.
;
;Determine if VIRUS_DIR is present on the fixed disk.  
;
        MOV AX,0201                             ;Select read-1-sector function.      
        MOV CL,09                               ;Track 0, sector 9.               
        INT 013                                 ;Read sector.                      
        JB >E1                                  ;Exit if flag=failure.             
        CMP W[BX+01FA],0CDEF                    ;Check for VIRUS_DIR infection tag.
        JNE >E1                                 ;If not infected, then MBR test gave
                                                ;false indication of infection.    
;
;Load relocated original MBR.
;
        MOV AX,0201                             ;Select read-1-sector function.
        MOV CL,0A                               ;Specify sector of original MBR.
        INT 013                                 ;Read sector
        JB >E1                                  ;Exit if flag=failure.         
;
;Write original MBR back to sector 1.
;
        MOV AX,0301                             ;Select write-1-sector function.     
        MOV CL,01                               ;Track 0, sector 1.                   
        INT 013                                 ;Write original MBR back to sector 1.
;
;Exit KILL_REP                                                  
;                                               
E1:
        MOV AX,04C00
        INT 021

