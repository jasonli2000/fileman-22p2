DIE1 ;SFISC/GFT-FILE DATA, XREF IT, GO UP AND DOWN MULTIPLES ;28MAY2008
 ;;22.0;VA FileMan;**1,4,11,159**;Mar 30, 1999
 ;Per VHA Directive 2004-038, this routine should not be modified.
 K DQ,DB G E1:$D(DG)<9 I DP<0 K DG S DQ=0 Q
 S DQ="",DU=-2,DG="$D("_DIE_DA_",DU))"
Y S DQ=$O(DG(DQ)),DW=$P(DQ,";",2) G DE:$P(DQ,";")=DU
 I DU'<0 S ^(DU)=DV,DU=-2
 G IX:DQ="" S DU=$P(DQ,";",1),DV="" I @DG S DV=^(DU)
DE I 'DW S DW=$E(DW,2,99),DE=DW-$L(DV)-1,%=$P(DW,",",2)+1,X=$E(DV,%,999),DV=$E(DV,0,DW-1)_$J("",$S(DE>0:DE,1:0))_DG(DQ) S:X'?." " DV=DV_$J("",%-DW-$L(DG(DQ)))_X G Y
PC S $P(DV,"^",DW)=DG(DQ) G Y
 ;
IX S DICRREC="LOADXR^DIED",DQ=$O(DE(" ")) G E1:DQ="",E1:'$D(DG(DQ)) I $D(DE(DE(DQ)))#2 F DG=1:1 Q:'$D(DE(DQ,DG))  S DIC=DIE,X=DE(DE(DQ)) X DE(DQ,DG,2)
 S X="" I DG(DQ)]"" F DG=1:1 Q:'$D(DE(DQ,DG))  S DIC=DIE,X=DG(DQ) X DE(DQ,DG,1)
 D:$D(DIEFXREF) FIREFLD
E1 K DICRREC,DIFLD,DG,DB,DE,DIANUM S DQ=0 Q
 ;
B ;
 I '$D(DB(DQ)) S X="?BAD" G ^DIEQ
 S DC=DQ,DIK="",DL=1
OUT ;
 D DIE1 S Y(DC)=DIK G UP:DL>1,Q:DC=0,QY
 ;
E ;
 I DP'<0 S DC=$S($D(X)#2:X,1:"") D DIE1 S X=DC G G:DI>0,UP:DL>1
Q K Y
QY I $D(DTOUT),$D(DIEDA) D
 . N % K DA
 . F %=1:1 Q:'$D(DIEDA(%))  S DA(%)=DIEDA(%)
 . S DA=DIEDA
 . Q
 K:$D(DTOUT) DG,DQ
 I $D(DIETMP)#2 D FIREREC K @DIETMP,DIETMP
 K DIEBADK,DIEFIRE,DIEXREF,DIEFXREF,DIIENS,DIE1,DIESP
 K DIP,DB,DE,DM,DK,DL,DH,DU,DV,DW,DP,DC,DIK,DOV,DIEL,DIFLD Q
 ;
M ;
 S DD=X,DIC(0)="LM"_$S($D(DB(DQ)):"X",1:"QE"),DO(2)=$P(DC,"^",2),DO=$P($P(DQ(DQ),U)," ",2,99)_"^"_DO(2)_"^"_$P(DC,"^",4,5) D DOWN I @("'$D("_DIC_"0))") S ^(0)="^"_DO(2)
 E  I DO(2)["I" S %=0,DIC("W")="" D W^DIC1
 K DIC("PTRIX") M DIC("PTRIX")=DIE("PTRIX")
DIC S D="B",DLAYGO=DP\1,X=DD D  K DIC("PTRIX")
 .N DIETMP,DICR D X^DIC
 I Y>0 S DA=+Y,DI=0,X=$P(Y,U,2) S:$D(DIETMP)#2 $P(DIIENS,",")=DA S:+DR=.01!(DR="")&$P(Y,U,3) DI=.01,DK=1,DM=$P($P(DR,";",1),":",2),DM=$S(DR="":9999999,DM="":+DR,1:DM) G D1
 S DI(DL-1)=DI(DL-1)_U K DUOUT,DTOUT G U1
 ;
DOWN D S,DIE1,DDA S DIE=DIC Q
 ;
S ;CALLED BY O+1^DIE0
 S DIOV(DL)=$G(DOV,0) K DOV
 S DIE1N(DL)=$G(DIE1N),DP(DL)=DP,DP=+$P(DC,"^",2),DI(DL)=$S(DV'["M":DI,$D(DSC(DP))!$D(DB(DQ)):DI,1:DI_U_$G(DQ(DQ,"CAPTION"))),DIE(DL)=DIE,DK(DL)=DK,DR(DL)=DR
 S DM(DL)=DM,DK=0,DIE1(DL)=DIE1,DL=DL+1,DIE1=$S($G(DIE1N):DIE1N,1:DL),DIEL=DIEL+1,DM=9999999,DR=""
 I $D(DR(DIE1,DP)) S DM=0,DR=DR(DIE1,DP)
 Q
 ;
DDA N T,X
 S T=$T
 F X=+$O(DA(" "),-1):-1:1 K DA(X+1) S:$D(DA(X))#2 DA(X+1)=DA(X)
 K DA(1) S:$D(DA)#2 DA(1)=DA
 S DIC=DIE_DA_","""_$P(DC,U,3)_""","
 S:$D(DIETMP)#2 DIIENS=","_DIIENS
 I T
 Q
 ;
UDA N T,X
 S T=$T
 S DA=$G(DA(1)) ;K DA(1)
 F X=2:1:+$O(DA(" "),-1) I $D(DA(X))#2 S DA(X-1)=DA(X) K DA(X)
 S:$D(DIETMP)#2 DIIENS=$P(DIIENS,",",2,999)
 I T
 Q
N ;
 D DOWN S DA=$P(DC,U,4),DI=.01 S:$D(DIETMP)#2 $P(DIIENS,",")=DA S ^DISV(DUZ,$E(DIC,1,28))=$E(DIC,29,999)_DA
D1 S @("D"_DIEL)=DA
G G MORE^DIE
 ;
UP ;
 Q:$D(DTOUT)
 S DP(0)=DP_U_DK(DL-1) I $D(DIEC(DL)) D DIEC G U
U1 D UDA S DIEL=DIEL-1
U S DQ=0,DL=DL-1,DIE1N=DIE1N(DL),DIE=DIE(DL),DM=DM(DL),DI=DI(DL),DP=DP(DL),DR=DR(DL),DK=DK(DL),DIE1=DIE1(DL) I $D(DIOV(DL)) S DOV=DIOV(DL) K DIOV(DL)
 G G
 ;
DIEC K DA S DA=DIEC(DL) F %=1:1 Q:'$D(DIEC(DL,%))  S DA(%)=DIEC(DL,%)
 F DIEL=0:1 Q:'$D(DIEC(DL,0,DIEL))  S @("D"_DIEL)=DIEC(DL,0,DIEL)
 S:$D(DIETMP)#2 DIIENS=DIEC(DL,"IENS")
 S DIEL=DIEL-1 K DIEC(DL)
 Q
 ;
FIREFLD ;Fire field-level xrefs stored in DIEFXREF
 D:$D(DIEFXREF)>2 FIRE^DIKC(DP,.DA,"KS","DIEFXREF","O","",$E("C",$G(DIOPER)="A"))
 K DIEFXREF
 Q
 ;
FIREREC ;Fire record-level xrefs accumulated in ^TMP
 Q:$D(DIETMP)[0  Q:$D(@DIETMP@("R"))<2
 N DP,DIIENS,DIE,DA,DIKEY,Y
 ;
 S DP=0 F  S DP=$O(@DIETMP@("R",DP)) Q:'DP  D
 . S DIIENS=" " F  S DIIENS=$O(@DIETMP@("R",DP,DIIENS)) Q:DIIENS=""  D
 .. D DA^DILF(DIIENS,.DA)
 .. D FIRE^DIKC(DP,.DA,"KS",$NA(@DIETMP@("R")),"F^^K",.DIKEY,$E("C",$G(DIOPER)="A"))
 ;
 ;If any keys are invalid, restore values
 D:$D(DIKEY)>9 RESTORE(.DIKEY,DIETMP)
 ;
 K DIEFIRE,@DIETMP@("R"),@DIETMP@("V")
 Q
 ;
RESTORE(DIKEY,DIETMP) ;Restore key fields to their pre-edited values
 N DA
 K DIEBADK
 S:$D(DIEFIRE)#2 X="BADKEY"
 ;
 ;Set "write" and "restore" flags
 N DIEWR,DIEREST
 I '$D(ZTQUEUED),'$D(DDS),$D(DIEFIRE)[0!($G(DIEFIRE)["M") S DIEWR=1
 E  S DIEWR=0
 I $D(DIEFIRE)#2,DIEFIRE'["R" S DIEREST=0
 E  S DIEREST=1
 I '$G(DIEWR),'$G(DIEREST),$G(DIEFIRE)'["L" Q
 ;
 N DIEFDA,DIEKK,DIEMSG,DIFIL,DIFLD,DIFLDI,DIIENS,DIIENSA
 N DINEW,DIOLD,DIRFIL,X
 ;
 ;Loop through all keys that are not unique and build FDA
 K DIEFDA
 S DIRFIL=0 F  S DIRFIL=$O(DIKEY(DIRFIL)) Q:'DIRFIL  D
 . S DIEKK=0 F  S DIEKK=$O(DIKEY(DIRFIL,DIEKK)) Q:'DIEKK  D
 .. Q:$D(^DD("KEY",DIEKK,0))[0
 .. K DIFLD
 .. S DIFLDI=0 F  S DIFLDI=$O(^DD("KEY",DIEKK,2,DIFLDI)) Q:'DIFLDI  D
 ... S DIFLD=$P($G(^DD("KEY",DIEKK,2,DIFLDI,0)),U),DIFIL=$P($G(^(0)),U,2)
 ... Q:'DIFLD!'DIFIL
 ... S DIFLD(DIFIL,DIFLD)=$$FLEVDIFF^DIKCU(DIRFIL,DIFIL)
 .. S DIIENS=" " S DIIENS=$O(DIKEY(DIRFIL,DIEKK,DIIENS)) Q:DIIENS=""  D
 ... S DIFIL=0 F  S DIFIL=$O(DIFLD(DIFIL)) Q:'DIFIL  D
 .... S DIFLD=0 F  S DIFLD=$O(DIFLD(DIFIL,DIFLD)) Q:'DIFLD  D
 ..... Q:$D(^DD(DIFIL,DIFLD,0))[0
 ..... S DIIENSA=$P(DIIENS,",",DIFLD(DIFIL,DIFLD)+1,999)
 ..... Q:$D(@DIETMP@("V",DIFIL,DIIENSA,DIFLD,"F"))[0!$D(^("4/"))  S DIOLD=^("F")
 ..... K DA D DA^DILF(DIIENSA,.DA)
 ..... S X=$$DEC^DIKC2(DIFIL,DIFLD) Q:X=""  X X S DINEW=X
 ..... I DIEREST S DIEFDA(DIFIL,DIIENSA,DIFLD)=DIOLD
 ..... I DIEWR!($G(DIEFIRE)["L") D
 ...... S DIEBADK(DIRFIL,DIEKK,DIFIL,DIIENSA,DIFLD,"O")=DIOLD
 ...... S DIEBADK(DIRFIL,DIEKK,DIFIL,DIIENSA,DIFLD,"N")=DINEW
 ;
 I DIEREST,$D(DIEFDA) D FILE^DIE("U","DIEFDA","DIEMSG") K DIERR
 I DIEWR,$D(DIEBADK) D MSG^DIEKMSG(.DIEBADK,DIEREST)
 ;
 I $G(DIEFIRE)'["L" K DIEBADK
 Q
