DDSVALF ;SFISC/MKO-GET,PUT VALUES FOR FORM ONLY FIELDS ;2OCT2003
 ;;22.0;VA FileMan;**8,1003**;Mar 30, 1999
GET(DDSVFD,DDSVBK,DDSVPG,DDSPARM,DDSVDA) ;Get value
 ;In:  DDSPG = Current page
 ;     DDSBK = Current block
 ;     DDSPARM = "I" : internal, "E" : external form
 ;
 N DDSANS,DDSFLD,DDSVDDP,DIERR
 I $D(DDSPG)[0 N DDSPG S DDSPG=0
 I $D(DDSBK)[0 N DDSBK S DDSBK=0
 S DDSANS=""
 I $G(DDSPARM)'["I",$G(DDSPARM)'["E" S DDSPARM=$G(DDSPARM)_"I"
 ;
 S DDSFLD=$P($$GETFLD^DDSLIB($G(DDSVFD),$G(DDSVBK),$G(DDSVPG),DDS,$G(DDSPG),$G(DDSBK),"F"),",",1,2)
 G:$G(DIERR) GETQ
 ;
 S DDSVFD=+DDSFLD,DDSVBK=+$P(DDSFLD,",",2)
 ;
 S DDSVDDP=+$P($G(^DIST(.404,DDSVBK,0)),U,2)
 I DDSVDDP,$G(DDSVDA)]"" N DDSDA D
 . I DDSVDA'["," S DDSVDA=$$IENS^DILF(.DDSVDA)
 . E  S:DDSVDA'?.E1"," DDSVDA=DDSVDA_","
 . S DDSDA=DDSVDA
 E  I DDSVDDP,DDSVBK'=DDSBK N DDSDA D GL^DDS10(DDSVDDP,.DDSDAORG,"","",.DDSDA)
 ;
 I $D(@DDSREFT@("F0",DDSDA,DDSFLD,"D"))#2 S DDSANS=^("D") S:DDSPARM["E"&($D(^("X"))#2) DDSANS=^("X") G GETQ
 ;
 I "013"[$P(^DIST(.404,DDSVBK,40,DDSVFD,0),U,3) D BLD^DIALOG(520,"DD or caption-only") G GETQ
 ;
 ;Form-only fields
 I $P($G(^DIST(.404,DDSVBK,40,DDSVFD,0)),U,3)=2 D  G:$G(DIERR) GETQ
 . I $P($G(^DIST(.404,DDSVBK,40,DDSVFD,20)),U)="" D  Q
 .. N P S P(1)="READ TYPE",P(2)="FIELD multiple of the BLOCK"
 .. D BLD^DIALOG(3011,.P)
 . D:$D(^DIST(.404,DDSVBK,40,DDSVFD,3))#2 DEF(^(3),$G(^(3.1)),.DDSANS)
 . S (@DDSREFT@("F0",DDSDA,DDSFLD,"D"),^("O"))=DDSANS
 . I DDSANS]"" D
 .. D:$D(DDSANS(0))
 ... S @DDSREFT@("F0",DDSDA,DDSFLD,"X")=$G(DDSANS(0,0),DDSANS(0))
 ... S:DDSPARM["E" DDSANS=$G(DDSANS(0,0),DDSANS(0))
 .. S $P(@DDSREFT@("F0",DDSDA,DDSFLD,"F"),U)=3,DDSCHG=1
 ;
 ;Computed fields
 E  S:$P($G(^DIST(.404,DDSVBK,40,DDSVFD,0)),U,3)=4 DDSANS=$$VAL^DDSCOMP(DDSVFD,DDSVBK,DDSDA)
 ;
GETQ D:$G(DIERR) ERR^DDSVALM("$$GET^DDSVALF")
 Q DDSANS
 ;
PUT(DDSVFD,DDSVBK,DDSVPG,DDSVAL,DDSPARM,DDSVDA) ;Put value
 N DIR,X,Y
 N DDER,DDSFLD,DDSVDDP,DDSVX,DIERR
 I $D(DDSPG)[0 N DDSPG S DDSPG=0
 I $D(DDSBK)[0 N DDSBK S DDSBK=0
 S:$D(DDSVAL)[0 DDSVAL=""
 I $G(DDSPARM)'["I",$G(DDSPARM)'["E" S DDSPARM=$G(DDSPARM)_"E"
 ;
 S DDSFLD=$$GETFLD^DDSLIB($G(DDSVFD),$G(DDSVBK),$G(DDSVPG),DDS,DDSPG,DDSBK,"F")
 G:$G(DIERR) PUTQ
 S DDSVFD=+DDSFLD,DDSVBK=+$P(DDSFLD,",",2),DDSVPG=$P(DDSFLD,",",3)
 S DDSFLD=$P(DDSFLD,",",1,2)
 ;
 S DDSVDDP=+$P($G(^DIST(.404,DDSVBK,0)),U,2)
 I DDSVDDP,$G(DDSVDA)]"" N DDSDA D
 . I DDSVDA'["," S DDSVDA=$$IENS^DILF(.DDSVDA)
 . E  S:DDSVDA'?.E1"," DDSVDA=DDSVDA_","
 . S DDSDA=DDSVDA
 E  I DDSVDDP,DDSVBK'=DDSBK N DDSDA D GL^DDS10(DDSVDDP,.DDSDAORG,"","",.DDSDA)
 ;
 I $P(^DIST(.404,DDSVBK,40,DDSVFD,0),U,3)'=2 D BLD^DIALOG(520,"DD, computed, or caption-only") G PUTQ
 ;
 S DIR(0)=$P(^DIST(.404,DDSVBK,40,DDSVFD,20),U)_$P(^(20),U,2,3)
 I DDSPARM["I",$E(DIR(0))="P"!(DIR(0)?1"DD".E) D
 . N FIL,FILROOT,FLD
 . S Y=DDSVAL
 . I $E(DIR(0))="P" D
 .. S FIL=$P($P(DIR(0),U,2),":")
 .. I 'FIL S FILROOT=U_FIL,FIL=+$P($G(@(U_FIL_"0)")),U,2) Q:'FIL
 .. E  S FILROOT=$G(^DIC(FIL,0,"GL")) Q:FILROOT=""
 .. S Y(0)=$P($G(@(FILROOT_Y_",0)")),U)
 .. S Y(0)=$$EXTERNAL^DILFD(FIL,.01,"",Y(0))
 . E  D
 .. N DV,I S FIL=$P($P(DIR(0),","),U,2),FLD=$P(DIR(0),",",2)
 .. S DV=$P($G(^DD(FIL,FLD,0)),U,2)
 .. F I="O","P","V","D","S" I DV[I S Y(0)=$$EXTERNAL^DILFD(FIL,FLD,"",Y) Q
 E  D  G:$G(DDER) PUTQ
 . I DDSVAL="" D  Q
 .. N DDSVREQ
 .. S DDSVREQ=$P($G(@DDSREFT@(DDSVPG,DDSVBK,DDSVFD)),U)
 .. S:DDSVREQ]"" DDSVREQ=$P($G(^DIST(.404,DDSVBK,40,DDSVFD,4)),U)
 .. I DDSVREQ S DDER=1
 .. E  S Y=""
 . S DIR("V")="",(X,DIR("B"))=DDSVAL
 . S:DIR(0)?1"DD".E DIR(0)=$P(DIR(0),U,2,999)
 . I $P(DIR(0),U)["P",$P($P(DIR(0),U,2),":",2)'["Z" D
 .. N I
 .. S I=$P(DIR(0),U,2) Q:$P(I,":",2)["Z"
 .. S $P(I,":",2)=$P(I,":",2)_"Z"
 .. S $P(DIR(0),U,2)=I
 . D ^DIR
 . I $E($P(DIR(0),U))="P" S Y=$P(Y,U)
 ;
 ;Update ^TMP
 S DDSCHG=1
 S (DDSVX,@DDSREFT@("F0",DDSDA,DDSFLD,"D"))=Y,^("F")=3 S:$D(Y(0))#2 (DDSVX,^("X"))=$S($D(Y(0,0))#2:Y(0,0),1:Y(0)) I $D(^("X"))#2,Y="" S (DDSVX,^("X"))=""
 ;
 ;Repaint field if it appears on the current page
 I $D(@DDSREFS@("F0",DDSFLD,"L",DDSPG,DDSVBK,DDSVFD))#2 D
 . N DY,DX,DDSVL,DDSVRJ,DDSX,DDSVREP
 . S DDSVREP=$P($G(@DDSREFS@(DDSPG,DDSVBK)),U,7)
 . S DY=+@DDSREFS@(DDSPG,DDSVBK,DDSVFD,"D"),DX=$P(^("D"),U,2),DDSVL=$P(^("D"),U,3),DDSVRJ=$P(^("D"),U,10)
 . I $G(DDSVREP) D  Q:DY=""
 .. N DDSVSN,DDSVPDA,DDSVOFS
 .. S DDSVPDA=$G(@DDSREFT@(DDSPG,DDSVBK)) I 'DDSVPDA S DY="" Q
 .. S DDSVREP=$P($G(@DDSREFT@(DDSPG,DDSVBK,DDSVPDA)),U,2,999) I DDSVREP="" S DY="" Q
 .. S DDSVSN=$G(@DDSREFT@(DDSPG,DDSVBK,DDSVPDA,"B",DDSDA)) I 'DDSVSN S DY="" Q
HITE .. N HITE S HITE=$$HITE^DDSR(DDSVBK),DDSVOFS=DDSVSN-$P(DDSVREP,U,2)*HITE ;DJW/GFT
 .. I DDSVOFS'<0,$P(DDSVREP,U,5)*HITE>DDSVOFS S DY=DY+DDSVOFS ;GFT  OFFSET CAN'T BE OUTSIDE SCROLLING WINDOW
 .. E  S DY=""
 . S DDSX=$P(DDGLVID,DDGLDEL)_$E(DDSVX,1,DDSVL)_$P(DDGLVID,DDGLDEL,10)
 . X IOXY
 . W $S(DDSVRJ:$J("",DDSVL-$L(DDSVX))_DDSX,1:DDSX_$J("",DDSVL-$L(DDSVX)))
 ;
 D
 . N DDP,DDSDA S DDP=0,DDSDA="0,"
 . D:$D(@DDSREFS@("PT",DDP,DDSFLD)) RPB^DDS7(DDP,DDSFLD,DDSPG)
 . D:$D(@DDSREFS@("COMP",DDP,DDSFLD,DDSPG)) RPCF^DDSCOMP(DDSPG)
 ;
PUTQ D:$G(DIERR) ERR^DDSVALM("PUT^DDSVALF")
 Q
 ;
DEF(DDSLN3,DDSLN31,Y) ;Get default
 N DDER,DIR,X
 Q:DDSLN3=""
 ;
 I DDSLN3'="!M" S Y=DDSLN3
 E  I DDSLN31'?."^" X DDSLN31 S:$D(Y)[0 Y=""
 Q:Y=""
 ;
 S DIR(0)=$P(^DIST(.404,DDSVBK,40,DDSVFD,20),U)_$P(^(20),U,2,3)
 S:DIR(0)?1"DD".E DIR(0)=$P(DIR(0),U,2,999)
 S DIR("V")="",(X,DIR("B"))=Y
 D ^DIR I DDER K Y S Y=""
 ;
 I Y]"",$E($P(DIR(0),U))="P" S Y=$P(Y,U)
 Q
 ;
