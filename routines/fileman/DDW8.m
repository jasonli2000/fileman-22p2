DDW8	;SFISC/MKO-COPY, CUT, PASTE ;12:09 PM  24 Aug 2002
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
CUT()	;Cut selected text
	N DDWADJ,DDWC1,DDWC2,DDWCSV,DDWISIN,DDWNDEL,DDWR1,DDWR2,DDWRSV
	I '$D(DDWMARK) D ERR($$EZBLD^DIALOG(1404)) Q  ;**'NO TEXT'
	;
	S DDWED=1
	S DDWISIN=$$ISINSEL()
	D PMARK(DDWMARK,.DDWR1,.DDWC1,.DDWR2,.DDWC2)
	D COPYBUF
	;
	S DDWRSV=DDWRW,DDWCSV=DDWC
	I DDWR2>DDWA,DDWR2-DDWA<DDWRW S DDWADJ=1
	E  I DDWR1-DDWA'>DDWMR,DDWR1-DDWA>DDWRW S DDWADJ=0
	;
	D DELBLK^DDW9(.DDWNDEL)
	D:$D(DDWADJ) POS(DDWRSV-(DDWADJ*DDWNDEL),DDWCSV,"RN")
	D:'DDWISIN PASTE()
	Q
	;
COPY()	;Copy selected text
	N DDWC1,DDWC2,DDWISIN,DDWR1,DDWR2
	I '$D(DDWMARK) D ERR($$EZBLD^DIALOG(1404)) Q  ;**'NO TEXT'
	;
	S DDWISIN=$$ISINSEL()
	D PMARK(DDWMARK,.DDWR1,.DDWC1,.DDWR2,.DDWC2)
	D COPYBUF
	D UNMARK^DDW7
	D:'DDWISIN PASTE()
	Q
	;
COPYBUF	;Copy selected text to buffer
	N DDWND,DDWI,DDWX,DDWX1,DDWX2
	K ^TMP("DDWB",$J)
	S DDWND=0
	;
	D:DDWR2-DDWR1>50 MSG^DDW(" ...") ;**
	;
	F DDWI=DDWR1:1:$$MIN(DDWA,DDWR2) D
	. S DDWND=DDWND+1
	. S DDWX=^TMP("DDW",$J,DDWI)
	. S DDWX=$E(DDWX,$S(DDWI=DDWR1:DDWC1,1:1),$S(DDWI=DDWR2:DDWC2,1:999))
	. S ^TMP("DDWB",$J,DDWND)=DDWX
	;
	F DDWI=$$MAX(DDWR1-DDWA,1):1:$$MIN(DDWR2-DDWA,DDWMR) D
	. S DDWX=$E(DDWL(DDWI),$S(DDWI+DDWA=DDWR1:DDWC1,1:1),$S(DDWI+DDWA=DDWR2:DDWC2,1:999))
	. S DDWND=DDWND+1
	. S ^TMP("DDWB",$J,DDWND)=DDWX
	;
	S DDWX1=$$RTOSTB(DDWR1),DDWX2=$$RTOSTB(DDWR2)
	F DDWI=$$MIN(DDWSTB,DDWX1):-1:DDWX2 D
	. S DDWND=DDWND+1
	. S DDWX=^TMP("DDW1",$J,DDWI)
	. S DDWX=$E(DDWX,$S(DDWI=DDWX1:DDWC1,1:1),$S(DDWI=DDWX2:DDWC2,1:999))
	. S ^TMP("DDWB",$J,DDWND)=DDWX
	;
	D:DDWR2-DDWR1>50 MSG^DDW()
	Q
	;
PASTE()	;Paste text
	I $D(DDWMARK) D ERR("You curently have text selected.") Q
	I '$D(^TMP("DDWB",$J)) D ERR($$EZBLD^DIALOG(1404)) Q  ;**
	;
	S DDWED=1
	N DDWBSIZ,DDWFC,DDWI,DDWLST,DDWNSV,DDWTXT,DDWX
	S DDWBSIZ=$O(^TMP("DDWB",$J,""),-1)
	;
	S DDWTXT=1
	S:$L(DDWN)+1<DDWC DDWN=DDWN_$J("",DDWC-$L(DDWN)-1)
	S (DDWNSV,DDWX)=$E(DDWN,1,DDWC-1)
	S DDWTXT(1)=DDWX
	I $L(DDWX)+$L(^TMP("DDWB",$J,1))<256!(DDWX="") S DDWTXT(1)=DDWTXT(1)_^(1)
	E  S DDWTXT=DDWTXT+1,DDWTXT(DDWTXT)=^TMP("DDWB",$J,1)
	;
	S DDWLST=$E(DDWN,DDWC,999)
	I DDWRAP,DDWLST?1." " S DDWLST=""
	I DDWLST]"",DDWBSIZ=1 S DDWTXT=DDWTXT+1,DDWTXT(DDWTXT)=DDWLST,DDWLST=""
	;
	D:DDWTXT ADJMAR^DDW6(.DDWTXT,"","I")
	S (DDWN,DDWL(DDWRW))=DDWTXT(1)
	;
	I DDWBSIZ=1,DDWTXT=1 S DDWFC=$L(DDWNSV)+$L(^TMP("DDWB",$J,1))+1
	E  I DDWBSIZ=1,DDWTXT=2,DDWLST="" S DDWFC=$L(DDWTXT(2))+1
	E  S DDWFC=1
	;
	I $$SCR(DDWFC)=$P(DDWOFS,U,4) D
	. D POS(DDWRW,$$MIN($L(DDWNSV),$L(DDWN))+1)
	. W $P(DDGLCLR,DDGLDEL)_$E(DDWN,$L(DDWNSV)+1,IOM+DDWOFS)
	;
	D POS(DDWRW,DDWFC,"R")
	;
	F DDWI=2:1:DDWTXT D
	. D ILINE^DDW5
	. S (DDWN,DDWL(DDWRW))=DDWTXT(DDWI)
	. D CUP(DDWRW,1)
	. W $E(DDWN,1+DDWOFS,IOM+DDWOFS)
	;
	F DDWI=2:1:DDWBSIZ D
	. D ILINE^DDW5
	. S (DDWN,DDWL(DDWRW))=^TMP("DDWB",$J,DDWI)
	. D CUP(DDWRW,1)
	. W $E(DDWN,1+DDWOFS,IOM+DDWOFS)
	;
	I DDWLST]"" D
	. D ILINE^DDW5
	. S (DDWN,DDWL(DDWRW))=DDWLST
	. D CUP(DDWRW,1)
	. W $E(DDWN,1+DDWOFS,IOM+DDWOFS)
	;
	D POS(DDWRW,DDWFC,"RN")
	Q
	;
CUP(Y,X)	;
	S DY=IOTM+Y-2,DX=X-1 X IOXY
	Q
	;
POS(R,C,F)	;Pos cursor based on char pos C
	N DDWX
	S:$G(C)="E" C=$L($G(DDWL(R)))+1
	S:$G(F)["N" DDWN=$G(DDWL(R))
	S:$G(F)["R" DDWRW=R,DDWC=C
	;
	S DDWX=C-DDWOFS
	I DDWX>IOM!(DDWX<1) D SHIFT^DDW3(C,.DDWOFS)
	S DY=IOTM+R-2,DX=C-DDWOFS-1 X IOXY
	Q
	;
ISINSEL()	;Is the cursor within the selected text
	N DDWI,DDWY
	S DDWI=DDWRW+DDWA,DDWY=0
	I DDWI<$P(DDWMARK,U)
	E  I DDWI>$P(DDWMARK,U,3)
	E  I DDWI=$P(DDWMARK,U),DDWC<$P(DDWMARK,U,2)
	E  I DDWI=$P(DDWMARK,U,3),DDWC-1>$P(DDWMARK,U,4)
	E  S DDWY=1
	Q DDWY
	;
PMARK(M,R1,C1,R2,C2)	;Parse M (DDWMARK)
	S R1=$P(M,U),C1=$P(M,U,2)
	S R2=$P(M,U,3),C2=$P(M,U,4)
	Q
	;
ERR(DDWX)	;
	D MSG^DDW($C(7)_DDWX) H 2 D MSG^DDW()
	D CUP(DDWRW,DDWC-DDWOFS)
	F  R *DDWX:0 E  Q
	Q
	;
TR(X)	;Strip trailing blanks
	Q:$G(X)="" X
	N I
	F I=$L(X):-1:0 Q:$E(X,I)'=" "
	Q $E(X,1,I)
	;
LD(X)	;Strip leading blanks
	Q:$G(X)="" X
	N I
	F I=1:1:$L(X)+1 Q:$E(X,I)'=" "
	Q $E(X,I,999)
	;
RTOSTB(R)	;Return node in STB given line #
	Q DDWSTB+DDWA+DDWMR+1-R
	;
SCR(C)	;Return screen number
	Q C-$P(DDWOFS,U,2)-1\$P(DDWOFS,U,3)+1
	;
MIN(X,Y)	;
	Q $S(X<Y:X,1:Y)
	;
MAX(X,Y)	;
	Q $S(X>Y:X,1:Y)
