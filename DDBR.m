DDBR ;SFISC/DCL-VA FILEMAN BROWSER ;6MAY2011
 ;;22.0;VA FileMan;**165,999**;Mar 30, 1999
 ;
EN N DDBC,DDBFLG,DDBL,DDBPMSG,DDBSA,DDBX,IOTM,IOBM
 I '$$TEST^DDBRT W $C(7),!!,$$EZBLD^DIALOG(830),!! Q  ;**
 D LIST^DDBR3(.DDBX)
 I DDBX'>0 W:DDBX=0 $C(7),!!,$$EZBLD^DIALOG(1404),!! Q  ;**
 S DDBSA=DDBX(6)
 S DDBFLG=DDBX(4)
 S DDBPMSG=DDBX(5)
 D CONTNU
 D KTMP^DDBRU
 Q
WP(DDBFN,DDBRN,DDBFLD,DDBFLG,DDBPMSG,DDBL,DDBC,IOTM,IOBM) N DDBSA
 S DDBSA=$$GET^DIQG($G(DDBFN),$G(DDBRN),$G(DDBFLD),"B")
 I $G(DIERR) D CLEAN Q
 S DDBSA=$P(DDBSA,"$CREF$",2)
 I DDBSA']"" D ERR("FILE, RECORD and/or FIELD") Q
 I '$D(@DDBSA) D ERR("SOURCE ARRAY") Q
 I $G(DDBFLG)["A" D
 .N DDBSAN
 .S DDBSAN=$$NROOT^DDBRAP($NA(@DDBSA))
 .I '$D(@DDBSAN) D WP^DDBRAP($NA(@DDBSA))
 .Q:$G(DDBPMSG)]""
 .I $D(@DDBSAN@("TITLE")) S DDBPMSG=@DDBSAN@("TITLE") Q
 .Q
 S DDBPMSG=$S($G(DDBPMSG)]"":DDBPMSG,1:"VA FileMan Browser (wp) DOCUMENT 1")
 D CONTNU
 D:$G(DDBFLG)'["P" KTMP^DDBRU
 Q
BROWSE(DDBSA,DDBFLG,DDBPMSG,DDBL,DDBC,IOTM,IOBM) N DDBRLIST
CONTNU I $G(U)'="^" N U S U="^"
 I $G(DDBFLG)["A" D
 .N DDBSAN
 .S DDBSAN=$$NROOT^DDBRAP($NA(@DDBSA))
 .I '$D(@DDBSAN) D WP^DDBRAP($NA(@DDBSA))
 .Q:$G(DDBPMSG)]""
 .I $D(@DDBSAN@("TITLE")) S DDBPMSG=@DDBSAN@("TITLE") Q
 .Q
 S DDBPMSG=$S($G(DDBPMSG)]"":DDBPMSG,1:"VA FileMan Browser DOCUMENT 1")
 N %,D,DX,IOP,XY,X,Y
 D:$G(DDBFLG)'["H" INIT I $G(DIERR) D CLEAN Q
 I $G(DDBSA)']"" D ERR("SOURCE ARRAY") Q
 I '$D(@DDBSA) D ERR("SOURCE ARRAY") Q
 I $G(DDBFLG)'["N",DDBSA'="^TMP(""DDB"",$J)" D
 .I $NA(@DDBSA)=$NA(^TMP("DDB",$J)) S DDBSA="^TMP(""DDB"",$J)" Q
 .K ^TMP("DDB",$J)
 .D XY^%RCR($$OREF(DDBSA),"^TMP(""DDB"",$J,")
 .;M ^TMP("DDB",$J)=@DDBSA
 .S DDBSA="^TMP(""DDB"",$J)"
 .Q
 N DDBRE,DDBRPE,DDBPSA,DDBTO,DDBDM,DDBFNO,I,DDBFLGS,DDBRHT,DDBRHTF
 N DDBHDR,DDBHDRC,DDBFTR,DDBSP,DDBSF,DDBST,DDBTL,DDBTPG,DDBZN
 I '$G(DDBRLIST) N DDBSRL,DDBSX,DDBSY,DDBRSA
 S DDBFTR=$E("Col>     |"_$$EZBLD^DIALOG(8074)_"| Line>                 Screen>"_$J("",IOM),1,IOM) ;**
 I '$G(DDBRLIST) S IOBM=$S($G(IOBM)>0:IOBM,1:$G(IOSL,24))-1,IOTM=$S($G(IOTM)>0:IOTM,1:1)+1
 S DDBRSA=0
 D TB^DDBRS(.IOTM,.IOBM,.DDBRSA)
 S DDBSX="0;4;40;65"
 S DDBSY=DDBRSA(0,"DDBSY")
 I IOBM>(IOSL-1) D ERR($$EZBLD^DIALOG(833)) Q  ;**
 I IOTM<2 D ERR($$EZBLD^DIALOG(832)) Q  ;**
 I IOBM'>IOTM D ERR($$EZBLD^DIALOG(831)) Q  ;**
 S DDBSRL=DDBRSA(0,"DDBSRL")
 I DDBSRL'>4,$G(DDBFLG)'["H" D ERR($$EZBLD^DIALOG(834)) Q  ;**
 I DDBRSA(1,"DDBSRL")'>4 K DDBRSA(1),DDBRSA(2)
 S DDBHDR=$$CTXT(DDBPMSG,$J("",IOM+1),IOM),DDBHDRC=0
 S DDBTL=$P($G(@DDBSA@(0)),"^",3) S:DDBTL'>0 DDBTL=$O(@DDBSA@(" "),-1)
 I DDBTL'>0 D  I DDBTL'>0 D BLD^DIALOG(1700,$$EZBLD^DIALOG(1404)_DDBSA) D CLEAN Q  ;**
 .N I S I=0 F  S I=$O(@DDBSA@(I)) Q:I'>0  S DDBTL=I
 .Q
 S DDBZN=$D(@DDBSA@(DDBTL,0))#2,DDBTPG=DDBTL\DDBSRL+(DDBTL#DDBSRL'<1),DDBSF=1,DDBST=IOM
 S DDBDM=DDBSA="^TMP(""DDB"",$J)"
 I $G(DDBC)=+$G(DDBC) D ERR("TAB (Closed Array Root)") Q
 S:$G(DDBC)="" DDBC="^TMP(""DDBC"",$J)"
 I '$D(@DDBC) F I=1,22:22:176 S @DDBC@(I)=""
 I $D(@DDBC@(1))'>9 N DDBC0,DDBC1 S @DDBC@(1)="",DDBC1=1,DDBC0=DDBC
 S DDBPSA=0,DDBFLG=$G(DDBFLG)
 S DDBFLGS=DDBFLG["S",DDBRHTF=DDBFLG["A"
 I DDBRHTF S $E(DDBFTR,1,9)="HYPER-TXT"
 G EN^DDBRGE
DOCLIST(DDBDSA,DDBFLG,IOTM,IOBM) S IOP="HOME" D ^%ZIS
 N DDBPMSG,DDBL,DDBC,DDBSA,DDBSRL,DDBSX,DDBSY,DDBRSA,DDBRLIST
 S IOBM=$S($G(IOBM)>0:IOBM,1:$G(IOSL,24))-1,IOTM=$S($G(IOTM)>0:IOTM,1:1)+1
 S DDBSX="0;4;40;65"
 S DDBSY=(IOTM-2)_";"_(IOTM-1)_";"_(IOBM-1)_";"_(IOBM)  ;hdr,txttop,txtbot,ftr
 I IOBM>(IOSL-1) D ERR($$EZBLD^DIALOG(833)) Q  ;**
 I IOTM<2 D ERR($$EZBLD^DIALOG(832)) Q  ;**
 I IOBM'>IOTM D ERR($$EZBLD^DIALOG(831)) Q  ;**
 S DDBSRL=(IOBM-IOTM)+1  ;scroll region lines
 I '$D(@DDBDSA) D ERR("DOCUMENT ARRAY INVALID") Q
 S DDBFLG=$TR($G(DDBFLG),"P")_"N"
 S DDBPMSG=$O(@DDBDSA@("")) S:DDBPMSG]"" DDBSA=@DDBDSA@(DDBPMSG)
 I DDBPMSG']""!(DDBSA']"") D ERR("DOCUMENT ARRAY INVALID") Q
 D  I $G(DIERR) K ^TMP("DDBLST",$J) D CLEAN Q
 .N DOC,DOCSA
 .S DOC=""
 .K ^TMP("DDBLST",$J)
 .F  S DOC=$O(@DDBDSA@(DOC)) Q:DOC=""  D
 ..S DOCSA=@DDBDSA@(DOC)
 ..D LOADCL^DDBR4(DOCSA,"",DOC)
 ..Q
 .Q
 Q:$G(DDBENDR)
 S DDBRLIST=1
 G CONTNU
RTN G DR^DDBRU
ROOT G EN^DDBRU2
CTXT(X,T,W) Q:X="" $G(T)
 N HW
 S W=$G(W,79),HW=W\2
 S $E(T,HW-($L(X)\2),HW-($L(X)\2)+$L(X))=X Q $E(T,1,W)
OREF(X) N X1,X2 S X1=$P(X,"(")_"(",X2=$$OR2($P(X,"(",2)) Q:X2="" X1 Q X1_X2_","
OR2(%) Q:%=")"!(%=",") "" Q:$L(%)=1 %  S:"),"[$E(%,$L(%)) %=$E(%,1,$L(%)-1) Q %
INIT I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 D INIT^DDGLIB0()
 I $G(DIERR) Q
 I '$D(IOSTBM)!('$D(IORI)) S X="IOSTBM;IORI" D ENDR^%ZISS
 D:$G(IOSTBM)="" TRMERR^DDGLIB0($$EZBLD^DIALOG(831)) ;**
 D:$G(IORI)="" TRMERR^DDGLIB0($$EZBLD^DIALOG(835))
 Q
ERR(DDBERR) N P S P(1)=DDBERR
 I $G(U)="^" N U S U="^"
 D BLD^DIALOG(202,.P),OUT^DDBRU:$D(DDGLDEL)
CLEAN D:'$D(DDS) KILL^DDGLIB0($G(DDBFLG))
 Q
