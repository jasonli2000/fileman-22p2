DICLGFT	;GFT/GFT-- USE ANY SORT VALUES FOR LISTER;07MAR2013
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
DICL	;FROM ^DICL  RETURN TO BADQ^DICL WITH DIERR DEFINED OR ELSE WE HAVE DINDEX SET UP CORRECTLY TO GET SORTED OUTPUT
	N X,I,DITEMP,DICLGFT
	D TMPB^DICUIX1(.DITEMP,DIFILE) ;SETS DITEMP=something like "^TMP("DICLB",2,3188"
	S DIGFTEMP=DITEMP_")" ;so we can remember to KILL the temporary array
BACKWARD	I $G(DINDEX("WAY","REVERSE"))=1 D
	.S X=$$SORT(DIFILE,DINDEX,DIGFTEMP,,.DIFROM)
	E  D
	.S X=$$SORT(DIFILE,DINDEX,DIGFTEMP,.DIFROM)
	S DIFROM(1)="" I X D BLD^DIALOG(-X,$P(X,U,2)) K @DIGFTEMP Q  ;We have already done the sort, so "FROM" can be the beginning
	;now we have the answers in @DITEMP.
	;D COMMON1^DICUIX2  probably need some of this
	S DICLGFT=$P(X,U,2),DINDEX("#")=DICLGFT ;NUMBER OF LEVELS IN OUR SORT
	S DINDEX("IXTYPE")="["
	F I=1:1:DICLGFT+1 S DINDEX(I,"WAY")=DINDEX("WAY")
	S DINDEX(1,"ROOT")=DITEMP_")",X=DITEMP
	F I=1:1:DICLGFT S X=X_",DINDEX("_(I)_")",DINDEX(I+1,"ROOT")=X_")"
	F I=1:1:DICLGFT S DINDEX(I,"FILE")=DIFILE
	;S DINDEX(1,"GET")="DIVAL=ZZZ" ;????????
	S DINDEX(1,"TYPE")="[",DINDEX("AT")=1
	F I=1:1:DICLGFT S DINDEX(I)=$G(DIFROM(I)) ;FROM VALUES
	S DINDEX(DICLGFT+1)=0
	Q
	;
	;
	;
	;
SORT(DIFILE,BY,DICLARAY,FR,TO)	;SORT FILE BY TEMPLATE OR FIELD(S), AND PUT RESULTS IN 'DICLARAY' ARRAY
	;EXTRINSIC FUNCTION RETURNS
	;"OK^n" IF SUCCESSFUL, where 'n' is number of levels
	;
	N L,DIC,FLDS,DHD,DIASKHD,DIPCRIT,PG,DHIT,DIOEND,DIOBEG,DCOPIES,IOP,DQTIME,DIS,DISTOP,DISPAR,DIFIXPTH,DISH,DIS0
	N D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13
	N DIQUIET,DISUPNO S DIQUIET=1,DISUPNO=1
	N X
	N DIOSL S DIOSL=9999999
	N DIFIXPT S DIFIXPT=1,DHD="@@" ;TRICK TO AVOID DEVICE SELECTION!
	S DIOBEG="K ^UTILITY($J,""H"") S DISH=1,IOT="""",$X=0,$Y=0" ;TRICK TO SUPPRESS SUBHEADERS IN SORT TEMPLATE, WHETHER OR NOT THERE IS A PRE-SORT
	I '$D(^DIC(DIFILE,0,"GL")) Q "401^"_DIFILE
	S DIC=^("GL")
	;
	N DICLGFT S DICLGFT=1
	;
	I $G(BY)="" Q "-202^SORT VALUE"
DIBT	S X=0 I $G(BY)?1"[".E1"]" S X=$O(^DIBT("F"_DIFILE,$TR(BY,"[]"),0)) I X&$O(^(X))!'X Q "-202^SORT TEMPLATE '"_BY_"'" ;MUST HAVE EXACTLY ONE TEMPLATE OF THAT NAME
	I X S L=$O(^DIBT(X,2,999),-1) I L S DICLGFT=L D  G A:$D(X) Q "-202^SORT TEMPLATE '"_BY_"'" ;NUMBER OF LEVELS
	.F L=1:1:L I $G(^DIBT(X,2,L,"ASK")) K X Q  ;NONE OF THE LEVELS MUST ASK
	;I X,'L S DICLGFT0=1
	;
FIELD	N DICLGFTX,DD S DICLGFTX=$G(BY),DICLGFT=$L(DICLGFTX,",") ;SORT BY FIELD
	S:$D(FR)[0 FR=",,,,,,,,,,,," S:$D(TO)[0 TO=",,,,,,,,,,"
	S DD=DIFILE F  S FLDS=$P(DICLGFTX,","),DICLGFTX=$P(DICLGFTX,",",2) Q:FLDS=""  D
	.S FLDS=$P(FLDS,";") I $D(^DD(DD,FLDS,0))
	.E  S FLDS=$O(^DD(DD,"B",FLDS,0)) Q:'FLDS
	.S L=+$P(^DD(DD,FLDS,0),U,2) I L S DD=L,DICLGFT=DICLGFT-1 ;GOING DOWN INTO A MULTIPLE, SO LEVEL OF SORT IS 1 LESS THAN WE THOT
	;
A	I DICLARAY["^",DICLARAY'["(" Q "-202^BAD ARRAY "_DICLARAY
	K ^UTILITY("DICLGFT",$J),@DICLARAY
	;
DHIT	S DHIT="" ;I $G(DICLGFT0) S DHIT="1," ;IF IT IS JUST A LIST
	F L=1:1:DICLGFT S X="DIOO"_L,DHIT="$S($G("_X_")]"""":"_X_",1:1),"_DHIT
	S DHIT="("_DHIT_"D0)",DHIT="S @DICLARAY@"_DHIT_"=""""" ;CREATES SOMETHING LIKE DHIT = S @DICLARAY@($S($G(DIOO2)]"":DIOO2,1:1),$S($G(DIOO1)]"":DIOO1,1:1),D0)=""
	;
	S L=0,FLDS="X ""QUIT"";X"
	S $X=0,$Y=0 ;,IOP="NULL"
DIP	D EN1^DIP ;HERE IS THE BIG CALL TO FILEMAN'S PRINT MODULE!
	Q "OK^"_DICLGFT  ;EXIT WITH 'DICLGFT' DEFINED AS THE NUMBER OF LEVELS
	;
	;
	;
