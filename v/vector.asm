N \VECTOR.COM
E 0100 B4 09 BA 84 01 CD 21 33 FF 33 DB 53 07 B9 FF 00 
E 0110 BE 00 00 26 8B 1C E8 14 00 E8 47 00 26 8B 5C 02 
E 0120 E8 31 00 E8 3D 00 83 C6 04 E2 E8 CD 20 50 B4 09 
E 0130 BA 2B 02 CD 21 CD 21 BA 14 02 CD 21 53 8B DF E8 
E 0140 21 00 47 5B B4 09 BA 2B 02 CD 21 B4 09 BA 21 02 
E 0150 CD 21 58 C3 50 B4 09 BA 2B 02 CD 21 BA 2E 02 CD 
E 0160 21 58 C3 51 52 B5 04 B1 04 D3 C3 8A C3 24 0F 04 
E 0170 30 3C 3A 7C 02 04 07 8A D0 B4 02 CD 21 FE CD 75 
E 0180 E6 5A 59 C3 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 
E 0190 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 0D 
E 01A0 0A 20 56 45 43 54 4F 52 53 2E 43 4F 4D 20 20 20 
E 01B0 20 20 20 20 20 20 20 20 20 20 20 20 0D 0A 20 49 
E 01C0 6E 74 65 72 72 75 70 74 20 56 65 63 74 6F 72 73 
E 01D0 20 4C 69 73 74 69 6E 67 20 0D 0A 20 28 43 29 20 
E 01E0 31 39 39 33 20 62 79 20 4B 24 68 6E 74 61 72 6B 
E 01F0 20 20 20 20 20 20 0D 0A 4D 4D 4D 4D 4D 4D 4D 4D 
E 0200 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 4D 
E 0210 4D 4D 4D 24 49 4E 54 45 52 52 55 50 54 20 23 20 
E 0220 24 4F 46 46 53 45 54 3A 20 20 24 0D 0A 24 53 45 
E 0230 47 4D 45 4E 54 3A 20 24 
RCX
0138
W
Q

;VECTOR - Interrupt Vector address listing utility
;by KohnTarK for Crypt Newsletter 17.

;After staring endlessly at the vector interrupt table using 
;memory editors and dump programs, I realized that as blindness approached 
;humans aren't meant to do such things such as counting 
;on fingers and pointing at the screen with pencils. So I wrote a quick 
;& dirty utility that will output the segments and offsets of all 
;interrupt vectors in hexadecimal notation.

;This is especially useful when writing resident code or dealing with
;resident Anti-Virus software, and trying to figure out what vectors 
;are hooked the specific addresses for tracing purposes.


;USAGE:

;vector |more 

;(DOS's MORE directory has to be in the PATH) will output the
;interrupt vectors one screenful at the time.


;vector >   (No, you don't type the <>'s)

;will output the interrupt vectors to 
; is useful to keep as a reference of different DOS versions, 
;memory configurations, resident AV programs etc. etc.

;$

;****************************************************************************
;
; VECTOR.ASM
; AUTHOR: K$hntark
; DATE:   10 APRIL 93
; Assemble & link with Turbo Assembler.
;****************************************************************************

MAIN    SEGMENT BYTE
        ASSUME cs:main,ds:main,ss:nothing      ;all part in one segment=com file
        org    100h

VECTORS:
            

         mov  ah,09     ;print message
         lea  dx,[START]
         int  21h

          xor  di,di                     ;interrupt count
          xor  bx,bx
          push bx
          pop  es                        ;es = 0000
          mov  cx,0FFh                   ;#of vectors = 256 = FF
          mov  si,0000                   ;starting offset
          
LOOP1:
          mov  bx,es:WORD PTR[si]   ;put vector's offset of in xx
          call PRINT_MSG1
          call BIN_TO_HEX

          
          mov  bx,es:WORD PTR[si+2]  ; put vector's segment in bx
          call  PRINT_MSG2
          call  BIN_TO_HEX        

          add si,4

          loop LOOP1

          int 20h

;****************************************************************************
PRINT_MSG1:
            push ax
            
            mov  ah,09     ;print carriage return
            lea  dx,[CR]
            int  21h
            

                           ;print carriage return
            int  21h
            
            
                           ;print INTERRUPT # message
            lea  dx,[INT_NUM]
            int  21h
            
            push bx         ;print int #
            mov  bx,di
            call BIN_TO_HEX
            inc  di
            pop  bx
            
            mov  ah,09     ;print carriage return
            lea  dx,[CR]
            int  21h
            
            mov  ah,09       ;print OFFSET

            lea  dx,[MSG1]
            int  21h

            pop  ax
            ret

;****************************************************************************
PRINT_MSG2:
            push ax
            
            mov  ah,09     ;print carriage return
            lea  dx,[CR]
            int  21h
            
            ;mov  ah,09     ;print message
            lea  dx,[MSG2]
            int  21h
            


            pop  ax
            ret

;****************************************************************************
; display # on bx

BIN_TO_HEX:
            push cx
            push dx
            
            mov  ch,04    ;# of digits to process
ROTATE:     mov  cl,04    ;# of bits to rotate
            rol  bx,cl    ;rotate bx l to r  
            mov  al,bl    ;move to al  (2 digits)
            and  al,0Fh   ;mask off upper digit
            add  al,30h   ;convert to ASCII
            cmp  al,3Ah   ;is it > 9?
            jl   PRINTIT  ;jump of digit =0 to 9
            add  al,07h   ;digit is A to F

PRINTIT:
            mov dl,al
            mov ah,2
            int 21h
            dec ch
            jnz ROTATE

            pop  dx
            pop  cx
            ret
;****************************************************************************

START    db 'MMMMMMMMMMMMMMMMMMMMMMMMMMM',13d,10d
         db ' VECTORS.COM               ',13d,10d
         db ' Interrupt Vectors Listing ',13d,10d
         db ' (C) 1993 by K$hntark      ',13d,10d 
         db 'MMMMMMMMMMMMMMMMMMMMMMMMMMM','$'
INT_NUM  db 'INTERRUPT # ','$'
MSG1     db  'OFFSET:  ','$'

CR       db  13d,10d,'$'
MSG2     db  'SEGMENT: ','$'


MAIN ENDS
     END VECTORS

     