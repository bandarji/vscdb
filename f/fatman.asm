;12 Bit File Attribute Table manipulation routines. These routines only
;require a one sector buffer for the FAT, no matter how big it is.

;The following data area must be in this order. It is an image of the data
;stored in the boot sector.
MAX_CLUST       DW      ?               ;maximum cluster number
SECS_PER_CLUST  DB      ?               ;sectors per cluster
RESERVED_SECS   DW      ?               ;reserved sectors at beginning of disk
FATS            DB      ?               ;copies of fat on disk
DIR_ENTRIES     DW      ?               ;number of entries in root directory
SECTORS_ON_DISK DW      ?               ;total number of sectors on disk
FORMAT_ID       DB      ?               ;disk format ID
SECS_PER_FAT    DW      ?               ;number of sectors per FAT
SECS_PER_TRACK  DW      ?               ;number of sectors per track (one head)
HEADS           DW      ?               ;number of heads on disk

;The following data is not in the boot sector. It is initialized by INIT_FAT_MANAGER.
CURR_FAT_SEC    DB      ?               ;current fat sector in memory 0=not there
TRACKS          DW      ?               ;number of tracks on disk

;The following must be set prior to calling INIT_FAT_MANAGER or using any of
;these routines.
CURR_DISK       DB      ?               ;current disk drive

;This routine is passed the number of contiguous free sectors desired in bx,
;and it attempts to locate them on the disk. If it can, it returns the FAT
;entry number in cx, and the C flag reset. If there aren't that many contiguous
;free sectors available, it returns with C set.
FIND_FREE:
        mov     al,[SECS_PER_CLUST]
        xor     ah,ah
        xchg    ax,bx
        xor     dx,dx
        div     bx                      ;ax=clusters requested, may have to increment
        or      dx,dx
        jz      FF1
        inc     ax                      ;adjust for odd number of sectors
FF1:    mov     bx,ax                   ;clusters requested in bx now
        mov     [CURR_FAT_SEC],0        ;initialize this subsystem
        xor     dx,dx                   ;this is the contiguous free sector counter
        mov     cx,2                    ;this is the cluster index, start at 2
FFL1:   push    bx
        push    cx
        push    dx
        call    GET_FAT_ENTRY           ;get FAT entry cx's value in ax
        pop     dx
        pop     cx
        pop     bx
        or      ax,ax                   ;is entry zero?
        jnz     FFL2                    ;no, go reset sector counter
        add     dl,[SECS_PER_CLUST]     ;else increment sector counter
        adc     dh,0
        jmp     SHORT FFL3
FFL2:   xor     dx,dx                   ;reset sector counter to zero
FFL3:   cmp     dx,bx                   ;do we have enough sectors now?
        jnc     FFL4                    ;yes, finish up
        inc     cx                      ;else check another cluster
        cmp     cx,[MAX_CLUST]          ;unless we're at the maximum allowed
        jnz     FFL1                    ;not max, do another
FFL4:   cmp     dx,bx                   ;do we have enough sectors
        jc      FFEX                    ;no, exit with C flag set
FFL5:   mov     al,[SECS_PER_CLUST]     ;yes, now adjust cx to point to start
        xor     ah,ah
        sub     dx,ax
        dec     cx
        or      dx,dx
        jnz     FFL5
        inc     cx                      ;cx points to first free cluster in block now
        clc                             ;clear carry flag to indicate success
FFEX:   ret

;This routine marks cx sectors as bad, starting at cluster dx. It does so
;only with the FAT sector currently in memory, and the marking is done only in
;memory. The FAT must be written to disk using UPDATE_FAT_SECTOR to make
;the marking effective.
MARK_CLUSTERS:
        push    dx
        mov     al,[SECS_PER_CLUST]
        xor     ah,ah
        xchg    ax,cx
        xor     dx,dx
        div     cx                      ;ax=clusters requested, may have to increment
        or      dx,dx
        jz      MC1
        inc     ax                      ;adjust for odd number of sectors
MC1:    mov     cx,ax                   ;clusters requested in bx now
        pop     dx
MC2:    push    cx
        push    dx
        call    MARK_CLUST_BAD          ;mark FAT cluster requested bad
        pop     dx
        pop     cx
        inc     dx
        loop    MC2
        ret

;This routine marks the single cluster specified in dx as bad. Marking is done
;only in memory. It assumes the proper sector is loaded in memory. It will not
;work properly to mark a cluster which crosses a sector boundary in the FAT.
MARK_CLUST_BAD:
        push    dx
        mov     cx,dx
        call    GET_FAT_OFFSET          ;put FAT offset in bx
        mov     ax,bx
        mov     si,OFFSET SCRATCHBUF    ;point to disk buffer
        and     bx,1FFH                 ;get offset in currently loaded sector
        pop     cx                      ;get fat sector number now
        mov     al,cl                   ;see if even or odd
        shr     al,1                    ;put low bit in c flag
        mov     ax,[bx+si]              ;get fat entry before branching
        jc      MCBO                    ;odd, go handle that case
MCBE:   and     ax,0F000H               ;for even entries, just modify low 12 bits
        or      ax,0FF7H
MCBF:   cmp     bx,511                  ;if offset is 511, we cross a sector boundary
        jz      MCBEX                   ;so go handle it specially
        mov     [bx+si],ax
MCBEX:  ret

MCBO:   and     ax,0000FH               ;for odd, modify upper 12 bits
        or      ax,0FF70H
        jmp     SHORT MCBF


;This routine finds the last track with data on it and returns it in ch. It
;finds the last cluster that is marked used in the FAT and converts it into a
;track number.
FIND_LAST_TRACK:
        xor     cx,cx                   ;cluster number--start with 0
        xor     dh,dh                   ;last non-zero cluster stored here
FLTLP:  push    cx
        push    dx
        call    GET_FAT_ENTRY
        pop     dx
        pop     cx
        or      ax,ax
        jnz     FLTLP1
        mov     dx,cx
FLTLP1: cmp     cx,[MAX_CLUST]
        jz      FLTRET
        inc     cx
        jmp     FLTLP
FLTRET: mov     cx,3
        cmp     dx,3
        jc      FLTR1
        mov     cx,dx                   ;cx=cluster number, minimum 3
FLTR1:  call    CLUST_TO_ABSOLUTE       ;put track number in ch
        ret

;This routine gets the value of the FAT entry number cx and returns it in ax.
GET_FAT_ENTRY:
        push    cx
        call    GET_FAT_OFFSET          ;put FAT offset in bx
        mov     ax,bx
        mov     cl,9                    ;determine which sector of the FAT is needed
        shr     ax,cl
        inc     al                      ;sector # now in al (1=first)
        cmp     al,[CURR_FAT_SEC]       ;is this the currently loaded FAT sector?
        jz      FATLD                   ;yes, go get the value
        push    bx                      ;no, load new sector first
        call    GET_FAT_SECTOR
        pop     bx
FATLD:  mov     si,OFFSET SCRATCHBUF    ;point to disk buffer
        and     bx,1FFH                 ;get offset in currently loaded sector
        pop     cx                      ;get fat sector number now
        mov     al,cl                   ;see if even or odd
        shr     al,1                    ;put low bit in c flag
        mov     ax,[bx+si]              ;get fat entry before branching
        jnc     GFEE                    ;odd, go handle that case
GFEO:   mov     cl,4                    ;for odd entries, shift right 4 bits first
        shr     ax,cl                   ;and move them down
GFEE:   and     ax,0FFFH                ;for even entries, just AND low 12 bits
        cmp     bx,511                  ;if offset is 511, we cross a sector boundary
        jnz     GFSBR                   ;if not exit,
        mov     ax,0FFFH                ;else fake as if it is occupied
GFSBR:  ret

;This routine reads the FAT sector number requested in al. The first is 1,
;second is 2, etc. It updates the CURR_FAT_SEC variable once the sector has
;been successfully loaded.
GET_FAT_SECTOR:
        inc     al                      ;increment al to get sector number on track 0
        mov     cl,al
GFSR:   mov     ch,0
        mov     dl,[CURR_DISK]
        mov     dh,0
        mov     bx,OFFSET SCRATCHBUF
        mov     ax,0201H                ;read FAT sector into buffer
        call    DO_INT13
        mov     [SECS_READ],al
        call    DECRYPT_DATA
        jc      GFSR                    ;retry if an error
        dec     cl
        mov     [CURR_FAT_SEC],cl
        ret

;This routine gets the byte offset of the FAT entry CX and puts it in BX.
;It works for any 12-bit FAT table.
GET_FAT_OFFSET:
        mov     ax,3                    ;multiply by 3
        mul     cx
        shr     ax,1                    ;divide by 2
        mov     bx,ax
        ret


;This routine converts the cluster number into an absolute Trk,Sec,Hd number.
;The cluster number is passed in cx, and the Trk,Sec,Hd are returned in
;cx and dx in INT 13H style format.
CLUST_TO_ABSOLUTE:
        dec     cx
        dec     cx                      ;clusters-2
        mov     al,[SECS_PER_CLUST]
        xor     ah,ah
        mul     cx                      ;ax=(clusters-2)*(secs per clust)
        push    ax
        mov     ax,[DIR_ENTRIES]
        xor     dx,dx
        mov     cx,16
        div     cx
        pop     cx
        add     ax,cx                   ;ax=(dir entries)/16+(clusters-2)*(secs per clust)
        push    ax
        mov     al,[FATS]
        xor     ah,ah
        mov     cx,[SECS_PER_FAT]
        mul     cx                      ;ax=fats*secs per fat
        pop     cx
        add     ax,cx
        add     ax,[RESERVED_SECS]
        dec     ax                      ;ax=absolute sector # now (0=boot sector)
        mov     bx,ax
        mov     cx,[SECS_PER_TRACK]
        mov     ax,[HEADS]
        mul     cx
        mov     cx,ax
        xor     dx,dx
        mov     ax,bx
        div     cx                      ;ax=(abs sec #)/(heads*secs per trk)=trk
        push    ax
        mov     ax,dx                   ;remainder to ax
        mov     cx,[SECS_PER_TRACK]
        xor     dx,dx
        div     cx
        mov     dh,al                   ;dh=head #
        mov     cl,dl
        inc     cl                      ;cl=sector #
        pop     ax
        mov     ch,al                   ;ch=track #
        ret


;This routine updates the FAT sector currently in memory to disk. It writes
;both FATs using INT 13.
UPDATE_FAT_SECTOR:
        mov     cx,[RESERVED_SECS]
        add     cl,[CURR_FAT_SEC]
        xor     dh,dh
        mov     dl,[CURR_DISK]
        mov     bx,OFFSET SCRATCHBUF
        mov     ax,0301H
        mov     [SECS_READ],al
        call    ENCRYPT_DATA
        CALL    DO_INT13                        ;update first FAT
        add     cx,[SECS_PER_FAT]
        cmp     cx,[SECS_PER_TRACK]             ;need to go to head 1?
        jbe     UFS1
        sub     cx,[SECS_PER_TRACK]
        inc     dh
UFS1:   mov     ax,0301H
        call    DO_INT13                        ;update second FAT
        call    DECRYPT_DATA
        ret

;This routine initializes the disk variables necessary to use the fat managment
;routines
INIT_FAT_MANAGER:
        mov     cx,17
        mov     si,OFFSET SCRATCHBUF+11
        mov     di,OFFSET MAX_CLUST
        rep     movsb                           ;move data from boot sector
        mov     [CURR_FAT_SEC],0                ;initialize this
        mov     ax,[SECTORS_ON_DISK]
        mov     bx,[HEADS]
        mov     cx,[SECS_PER_TRACK]
        xor     dx,dx
        div     bx
        xor     dx,dx
        div     cx
        xor     ah,ah
        mov     [TRACKS],ax
        ret
