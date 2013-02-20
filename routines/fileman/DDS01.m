DDS01	;SFISC/MLH,MKO-PROCESS BLOCK ;24JAN2013
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;***BE CAREFUL PUTTING TAGS INTO THIS IMPORTANT ROUTINE!  $T LOOKS FOR A NON-EXISTENCE OF A TAG!****
	;
	F  D IN,CHK Q:"^Q^NB^NP^"[(U_DDACT_U)
	Q
	;
IN	K DDSBR,DDSFLD,DDSO,DDSU,DIR,DDSREPNT
	S:$D(@DDSREFS@(DDSPG,$S(DDO:DDSBK,1:0),DDO,"N"))#2 DDSU("N")=^("N")
	I DDM,'$G(DDSKM) D CLRMSG^DDS
	G:'DDO COM^DDSCOM
	;
	S DDSOSV=0
	F DDSI=0,1,2,4,7,10:1:14,20 D  ;MOVE FIELD DEFINITION INTO DDSO ARRAY
	. S:$D(^DIST(.404,DDSBK,40,DDO,DDSI))#2 DDSO(DDSI)=^(DDSI)
	K DDSI
	;
	S DDSFLD=$G(DDSO(1)) K DDSO(1)
	I $P($G(DDSO(0)),U,3)=2 N DDP S DDP=0,DDSFLD=DDO_","_DDSBK
	;
	I DDSFLD]"",DDSDA]"" M DDSU=@DDSREFT@("F"_DDP,DDSDA,DDSFLD) ;Restore field's specs & value from ^TMP
	;
	I '$D(DDSREP)!DDSDA,$$UNED($G(DDSU("A")),$G(DDSO(4)),$G(DDSU("N"))) D  Q
	. I $D(DDSACT)#2 S DDACT=DDSACT K DDSACT
	. S:DDACT="U" DDACT="L"
	. S:DDACT="D" DDACT="R"
	. D CURSOR Q:$D(DDSBR)#2
	. S DDSCHKQ=1
	K DDSACT
	;
	S (X,DDSOLD)=$G(DDSU("D")),DDSEXT=$G(DDSU("X"),X)
	;
	X:$G(DDSO(11))'?."^" DDSO(11) ;PRE-ACTION
	I $D(DDSBR)#2 D BR^DDS2 Q:$D(DDSBR)#2
	I DDACT]"",$T(@DDACT)]"" D @DDACT S DDSCHKQ=1 Q
	;
	S DIR0N=1 Q:DDSFLD=""
	;
	S:$G(^DD(DDP,DDSFLD,0))'?."^" DDSU("DD")=^(0)
	I $D(DDSU("N"))[0 S DDACT="N" Q
	Q:$D(DDSO(2))[0
	;
	D:$G(@DDSREFT@("HLP"))>0 HLP^DDSMSG()
	K DDSKM,DDQ
	;
	S DIR0=$P(@DDSREFS@(DDSPG,DDSBK,DDO,"D"),U,1,3)
	S:$P(@DDSREFS@(DDSPG,DDSBK,DDO,"D"),U,10) $P(DIR0,U,6)=1
HITE	S:$P($G(DDSREP),U,3)>1 $P(DIR0,U)=$P(DIR0,U)+($P(DDSREP,U,3)-1*$$HITE^DDSR(DDSBK)) ;DJW/GFT
	;
	I $D(DDSREP),'DDSDA,$P(DDSO(0),U,3)'=2 K DDSU("DD") G SEL^DDSM
	I $D(DDSU("M"))#2 S DDSGL=U_$P(DDSU("M"),U,2) G:'DDSU("M") WP^DDSWP
	S DIR("B")=$G(DDSU("X"),DDSOLD)
	;
	I $D(DDSU("M"))#2 D SEL^DDS5 G:X'=DDSOLD&(DDACT="N") EXT
	I $P($G(DDSO(0)),U,3)'=2 S DIR(0)=DDP_","_DDSFLD_"O" ;IT'S A FIELD-TYPE READ
	E  D DIR^DDSFO
	D ^DIR K DIR,DUOUT,DIRUT,DIROUT ;DO THE READ!
	I DIR0N S (X,Y)=DDSOLD Q
	;
EXT	I $E(X)=U!$D(DTOUT) S DIR0N=1 Q
	G EXT^DDS02
	;
CHK	Q:$D(DDSBR)#2
	I $G(DDSCHKQ)=1 K DDSCHKQ Q
	G:$D(DTOUT) TO^DDS3
	G:$E(X)=U UPA^DDS2
	I $G(DDSFLD)=.01,X="",$G(DA),DDSOLD]"" G ^DDS6 ;DELETE ENTRY
	;
	I $P($G(DDSU("DD")),U,2)["I",$G(DDSOLD)]"" D  I %]"",X'=% S DDSNOED=1 ;UNEDITABLE FIELD ALREADY HAS A VALUE
	.N DIERR S %=$$GET1^DIQ(DDSFILE,DDSDA,DDSFLD)
	E  I $P($G(DDSU("DD")),U,5,99)["DINUM" S DDSNOED=1
	E  S DDSNOED=$S($P($G(DDSU("A")),U,4)="":$P($G(DDSO(4)),U,4),1:$P($G(DDSU("A")),U,4)) ;FIELD 6.4 ('DISABLE EDITING') IN THE FIELD MULTIPLE
	I $G(DDSFLD)]"",$G(DDSOLD)]"",X'=DDSOLD,DDSNOED S %=1 D  I %["," S DDSDA=% D POSDA^DDSM(DDSDA,DDSOLD) K DDSCHKQ Q
	.N F,L
	.I $P($G(DDSO(0)),U,3)=2 N DDP S DDP=0,F="" F  S F=$O(@DDSREFT@("F0",F)) Q:F=""  D  Q:%[","
	..S L="" F  S L=$O(@DDSREFT@("F0",F,L)) Q:L=""  I +L=DDO,$P(L,",",2)=DDSBK,$P($G(@DDSREFT@("F0",F,L,"O")),X)="" S %=F Q  ;FIND A MATCHING FORM-ONLY VALUE
	.I %'["," S F="" F  S F=$O(@DDSREFT@("F"_DDP,F)) Q:F=""  D  Q:%[","
	..I F'=DDSDA S L=$G(@DDSREFT@("F"_DDP,F,DDSFLD,"D")) I L]"",$P(L,X)="" S %=F   ;FIND A MATCHING FIELD VALUE
	.S @DDSREFT@("F"_DDP,DDSDA,DDSFLD,"D")=DDSOLD S:$D(DDSU("X"))#2 ^("X")=DDSU("X")
	.
	I 'DIR0N,$G(DDSFLD),$D(DDSU("M"))[0,$G(DDSCHKQ)'=2,DDSNOED D  K DDSNOED Q  ;User tried to change uneditable field (was UNED^DDS02)
	.S %=$P($G(DDSO(0)),U,2) I %="" S %=$P($G(DDSO(0)),U,5) ;GET CAPTION or UNIQUE NAME
	.D MSG^DDSMSG($$EZBLD^DIALOG(3090,%),1) ;'UNEDITABLE'
	.I $P($G(DDSO(0)),U,3)=2 N DDP S DDP=0
	.S @DDSREFT@("F"_DDP,DDSDA,DDSFLD,"D")=DDSOLD S:$D(DDSU("X"))#2 ^("X")=DDSU("X")
	;
	K DDSCHKQ,DDSNOED
	;
	I $G(DDSFLD)=.01,$G(DDSPTB)]"",$G(DDSREP)<2,'DIR0N D RPF^DDS7(DDP,DDSPTB,DDSDA,.DA)
	I $G(DDSO(12))'?."^" X DDSO(12) ;POST ACTION
	;
	I 'DIR0N,DDO,$G(DDSFLD)]"" D
	. I $P($G(DDSO(0)),U,3)=2 N DDP S DDP=0
	. S DDSCHG=1
	. I DDSDA!'$D(DDSREP),+$G(DDSU("F"))'=1 S $P(@DDSREFT@("F"_DDP,DDSDA,DDSFLD,"F"),U)=1
	. I $G(DDSO(13))'?."^" X DDSO(13) ;POST ACTION ON CHANGE
	. D:$D(@DDSREFS@("PT",DDP,DDSFLD)) RPB^DDS7(DDP,DDSFLD,DDSPG)
	. D:$D(@DDSREFS@("COMP",DDP,DDSFLD,DDSPG)) RPCF^DDSCOMP(DDSPG)
	;
	I $D(DDSBR)#2 D BR^DDS2 Q:$D(DDSBR)#2
	Q:DDACT=""  I $T(@DDACT)]"" G @DDACT
	I 'DDO G:X]"" ^DDS3 S DDSO(0)=0
	I DDACT="D",$D(DDSREP),'DA S DDACT="N" ;GFT  DON'T DOWN-ARROW THRU A MULTIPLE THAT HAS NO .01 FIELD DEFINED
	G:"^U^D^R^L^"[(U_DDACT_U) CURSOR
	G:$D(DDSU("M"))[0 NF
	G:DDSU("M") ^DDS5
	D EDIT^DDSWP I '$D(DDGLCLR) S DDACT="Q" Q
	D R^DDSR
	;
NF	I 'DDO,DDSOSV S DDO=DDSOSV Q
	;
	I DDO,$S($D(DDSREP):DDSDA,1:1) D
	. D:'$D(DDSU("M"))
	.. I $G(@DDSREFS@("ASUB",DDSPG,DDSBK,DDO))]"" S DDSSTACK="`"_^(DDO) ;ANOTHER PAGE HAS THIS FIELD AS ITS PARENT FIELD!
	.. E  I $P($G(DDSO(7)),U,2)]"" S DDSSTACK=$P(DDSO(7),U,2) ;OR THERE IS A SUBPAGE LINK FROM THIS FIELD
	. X:$G(DDSO(10))'?."^" DDSO(10) ;BRANCHING LOGIC
	;
	I $D(DDSSTACK) D:$G(^DIST(.403,+DDS,21400)) REFRESH^DDS02(DDSSTACK) D ^DDSSTK,R^DDS3 K DDSU ;WE DO A WHOLE RECURSION TO THE SUBPAGE, AND THEN REPAINT THIS PAGE
	I $D(DDSBR)#2 D BR^DDS2 Q:$D(DDSBR)#2
	S DDACT="N"
	;
CURSOR	N ACT,B,BLK,BLK0,FND,N,REP
	K DDSACT
	S:$D(DDSU("N"))[0 DDSU("N")=$G(@DDSREFS@(DDSPG,DDSBK,DDO,"N"))
	S FND=0
	I $D(DDSREP),DDO D MNAV^DDSM(.FND) Q:FND
	;
	S B=U,(BLK,BLK0)=DDSBK,N=DDSU("N"),ACT=$S(DDO&$G(DDSDN):"N",1:DDACT)
	F  D  Q:FND!$D(REP)
	. S DDO=$P(N,U,$L($P("U^D^R^L^N",ACT),U))
	. I 'DDO S (DDO,DDSBK)=0,FND=1 Q
	. ;
	. S DDSBK=$P(DDO,",",2),DDO=+DDO
	. I DDSBK D  Q:$D(REP)
	.. I $P($G(@DDSREFS@(DDSPG,DDSBK)),U,4) D
	... S DDO=$P($G(@DDSREFS@(DDSPG,DDSBK)),U,9),ACT="N"
	.. E  S ACT=DDACT
	.. I '$P($G(@DDSREFT@(DDSPG,DDSBK)),U),DDSDAORG S B=B_DDSBK_U
	.. E  I $P(@DDSREFS@(DDSPG,DDSBK),U,7)>1 S REP=1,DDACT="NB",DDSBR=""
	. E  S DDSBK=BLK
	. ;
	. I B'[(U_DDSBK_U) S FND=1 S:DDSBK'=BLK0 DDACT="NB",DDSBR="",DDSACT=ACT
	. ;
	. S:'FND N=$G(@DDSREFS@(DDSPG,DDSBK,+DDO,"N")),BLK=DDSBK
	Q
	;
NP	;;
	G:$D(DDSREP)&DDO PGDN^DDSM ;If in REPEATING BLOCK
	S:DDSNP]"" DDSPG=DDSNP
	S:DDSNP="" DDACT="N"
	Q
PP	;;
	G:$D(DDSREP)&DDO PGUP^DDSM ;If in REPEATING BLOCK
	S DDSPG=$$PP^DDS5(.Y)
	S DDACT=$S(Y=1:"NP",1:"N")
	Q
NB	;;
	S DDSBK=$$NB^DDS5(.Y),DDACT=$S(Y=1:"NB",1:"N")
	Q
SEL	;;
	;I $G(DDSSEL) W $C(7) Q
	S DDACT="N" G PG^DDSRSEL
SV	;;
	G SV^DDS02
QT	;;
	G QT^DDS3
EX	;;
	G EX^DDS3
CL	;;
	G CL^DDS3
MOUSE	;;
	G MOUSE^DDS2
PRNT	;;
	D EN^DDSRP(+DDS,DDSPG)
RF	;;
	S DDACT="N" I $G(^DIST(.403,+DDS,21400)) D REFRESH^DDS02(DDSPG) ;RE-DO THE DATA BEFORE REFRESHING PAGE
	G R^DDSR
	;
	;
UNED(ATT,DEF,N)	;
	Q $S(N="":1,$P(ATT,U,4)="":$P(DEF,U,4)=1,1:$P(ATT,U,4)=1)&'$P(N,U,11)
