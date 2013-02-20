DIEF1	;SFISC/DPC-FILER UTILITIES ;22MAR2006
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
LOAD(DIEFF,DIEFDAS,DIEFFLD,DIEFFLG,DIEFVAL,DIEFAR,DIEFOUT)	;
LOADX	;
	N DIEFIEN
	I '$D(DIQUIET) N DIQUIET S DIQUIET=1
	I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
	I $G(DIEFDAS)']"" D BLD^DIALOG(202,"IENS","IENS") G OUT
	I $E(DIEFDAS,$L(DIEFDAS))="," S DIEFIEN=DIEFDAS
	E  S DIEFIEN=$$IEN^DIEFU(.DIEFDAS)
	I '$$VROOT^DIEFU(DIEFAR) G OUT
	I '$$VFILE^DIEFU(DIEFF,"D") G OUT
	S DIEFFLD=$$CHKFLD^DIEFU(DIEFF,DIEFFLD) G:'DIEFFLD OUT
	I $G(DIEFFLG)["R",'$$VENTRY^DIEFU(DIEFF,DIEFIEN,"D") G OUT
	S @DIEFAR@(DIEFF,DIEFIEN,DIEFFLD)=DIEFVAL
OUT	I $G(DIEFOUT)]"" D CALLOUT^DIEFU(DIEFOUT)
	Q
	;
FLDNUM(DIEFF,DIEFFDNM)	;
FLDNUMX	;
	I '$D(DIQUIET) N DIQUIET S DIQUIET=1
	I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
	I '$$VFILE^DIEFU(DIEFF,"D") Q 0
	N DIEFFNUM
	I $D(^DD(DIEFF,"B",DIEFFDNM)) D  Q DIEFFNUM
	. S DIEFFNUM=$O(^DD(DIEFF,"B",DIEFFDNM,""))
	. I $O(^DD(DIEFF,"B",DIEFFDNM,DIEFFNUM)) N P S P(1)=DIEFFDNM,P("FILE")=DIEFF D BLD^DIALOG(505,.P,.P) S DIEFFNUM=0
	N P S P("FILE")=DIEFF,P(1)=DIEFFDNM D BLD^DIALOG(501,.P,.P)
	Q 0
	;
ADDCONV(DIEFIEN,DIEFADAR)	;
	N I,DIEFNIEN,P
	F I=1:1:$L(DIEFIEN,",")-1 D
	. S P=$P(DIEFIEN,",",I)
	. I P,$E(P)'="+" Q
	. S DIEFNIEN=@DIEFADAR@($TR(P,"+?"))
	. S $P(DIEFIEN,",",I)=DIEFNIEN
	Q DIEFIEN
	;
PUTDATA	;CODE TO ACTUALLY PUT THE DATA INTO THE NODE BEING EDITED. ALSO SAVES ORIGINAL VALUES. CALLED FROM DIEF.
	I +DIEFSPOT D
	. I DIEFNVAL[U D  Q
	. . S DIEFNG=1
	. . N INT,EXT
	. . S INT(1)=$$FLDNM^DIEFU(DIEFF,DIEFFLD),INT(2)=$$FILENM^DIEFU(DIEFF),EXT("FILE")=DIEFF,EXT("FIELD")=DIEFFLD
	. . D BLD^DIALOG(714,.INT,.EXT)
	. S DIEFOVAL=$P(DIEFFVAL,"^",DIEFSPOT)
	. S $P(DIEFFVAL,"^",DIEFSPOT)=DIEFNVAL,DOREPL=1
	E  I $E(DIEFSPOT)="E" D
	. N FR,TO,OLEN,NLEN
	. S FR=$P($P(DIEFSPOT,"E",2),",",1),TO=$P(DIEFSPOT,",",2)
	. S NLEN=$L(DIEFNVAL)
	. I NLEN-1>(TO-FR) D  Q
	. . S DIEFNG=1
	. . N INT,EXT
	. . S INT(1)=$$FLDNM^DIEFU(DIEFF,DIEFFLD),INT(2)=$$FILENM^DIEFU(DIEFF),EXT("FILE")=DIEFF,EXT("FIELD")=DIEFFLD
	. . D BLD^DIALOG(716,.INT,.EXT)
	. S DIEFOVAL=$E(DIEFFVAL,FR,TO),OLEN=$L(DIEFOVAL)
	. I $E(DIEFFVAL,TO+1,999)="" S $E(DIEFFVAL,FR,TO)=DIEFNVAL
	. E  S $E(DIEFFVAL,FR,TO)=DIEFNVAL_$J("",$S(OLEN>NLEN:OLEN-NLEN,1:0))
	. S DOREPL=1
	E  I DIEFSPOT=0 D
	. I $P($G(^DD(+$P(^DD(DIEFF,DIEFFLD,0),U,2),.01,0)),U,2)["W" D
	. . I '$$VROOT^DIEFU(DIEFNVAL) Q
	. . D PUTWP^DIEFW(DIEFFLAG,DIEFNVAL,DIEFNODE)
	. E  D
	. . N INT,EXT
	. . S (INT(1),EXT(1))="MULTIPLE",EXT("FILE")=DIEFF,EXT("FIELD")=DIEFFLD
	. . D BLD^DIALOG(520,.INT,.EXT)
	. . S DIEFNG=1
	E  I DIEFSPOT=" " D
	. N INT,EXT
	. S (INT(1),EXT(1))="COMPUTED",EXT("FILE")=DIEFF,EXT("FIELD")=DIEFFLD
	. D BLD^DIALOG(520,.INT,.EXT)
	. S DIEFNG=1
	Q
	;
LOCK	;
	S (DIEFNOLK,DIEFLCKS)=0,DIEFF=""
	F  S DIEFF=$O(@DIEFAR@(DIEFF)) Q:DIEFF=""  D  Q:DIEFNOLK
	. I '$$VFILE^DIEFU(DIEFF,"D") S DIEFNOLK=1 Q
	. S DIEFFREF=$$FROOTDA^DIKCU(DIEFF,"D",.DIEFLEV) Q:DIEFFREF=""
	. S DIEFDAS=""
	. F  S DIEFDAS=$O(@DIEFAR@(DIEFF,DIEFDAS)) Q:DIEFDAS=""  D  Q:DIEFNOLK
	. . N DA
	. . I '$$GOODIEN^DIEF(DIEFF,DIEFDAS,DIEFLEV,.DA,"D") S DIEFNOLK=1 Q
	. . S DIEFLCKS=DIEFLCKS+1
	. . S DIEFLOCK(DIEFLCKS)=$NA(@DIEFFREF@(DA))
	. . D LOCK^DILF(DIEFLOCK(DIEFLCKS)) E  D  ;**147
	. . . S DIEFNOLK=1
	. . . N E S E("FILE")=DIEFF,E("IENS")=DIEFDAS D BLD^DIALOG(110,"",.E)
	Q
UNLOCK	;
	N I
	F I=1:1:DIEFLCKS L -@DIEFLOCK(I)
	Q
	;
RESTORE(DIKEY,DIEFTMP)	;Restore key fields to pre-edited values
	;DIKEY(rFile#,key#,iens) = "" : if key is not unique
	;                        = n  : if key fields not assigned a value
	;DIKEY(rFile#,key#,iens,file,field) = levdiff : set if field not
	;                                               assigned a value
	N DIEFDA,DIEKK,DIRFIL,DIFIL,DIFLD,DIFLDI,DIIENS,DIIENSA,DIOLD,DILEVD
	K DIEFDA
	;
	;Loop through root files and keys in DIKEY
	S DIRFIL=0 F  S DIRFIL=$O(DIKEY(DIRFIL)) Q:'DIRFIL  D
	. S DIEKK=0 F  S DIEKK=$O(DIKEY(DIRFIL,DIEKK)) Q:'DIEKK  D
	.. Q:$D(^DD("KEY",DIEKK,0))[0
	.. ;
	.. ;Get fields in key
	.. K DIFLD
	.. S DIFLDI=0 F  S DIFLDI=$O(^DD("KEY",DIEKK,2,DIFLDI)) Q:'DIFLDI  D
	... S DIFLD=$P($G(^DD("KEY",DIEKK,2,DIFLDI,0)),U),DIFIL=$P($G(^(0)),U,2)
	... Q:'DIFLD!'DIFIL
	... S DIFLD(DIFIL,DIFLD)=""
	.. ;
	.. ;Loop through records in DIKEY
	.. S DIIENS=" " S DIIENS=$O(DIKEY(DIRFIL,DIEKK,DIIENS)) Q:DIIENS=""  D
	... ;
	... ;Generate error if key is not unique
	... D:DIKEY(DIRFIL,DIEKK,DIIENS)="" ERR740^DIEVK1(DIRFIL,DIEKK,DIIENS)
	... ;
	... ;Loop through files/fields in key
	... S DIFIL=0 F  S DIFIL=$O(DIFLD(DIFIL)) Q:'DIFIL  D
	.... S DIFLD=0 F  S DIFLD=$O(DIFLD(DIFIL,DIFLD)) Q:'DIFLD  D
	..... Q:$D(^DD(DIFIL,DIFLD,0))[0
	..... ;
	..... ;Generate error if key field not assigned a value
	..... I $D(DIKEY(DIRFIL,DIEKK,DIIENS,DIFIL,DIFLD))#2 D
	...... S (DILEVD,DIFLD(DIFIL,DIFLD))=+DIKEY(DIRFIL,DIEKK,DIIENS,DIFIL,DIFLD)
	...... D ERR744^DIEVK1(DIFIL,DIFLD,DIEKK,$P(DIIENS,",",DILEVD+1,999))
	..... ;
	..... ;Set the FDA to restore the field to original value
	..... S DILEVD=DIFLD(DIFIL,DIFLD)
	..... S:DILEVD="" (DILEVD,DIFLD(DIFIL,DIFLD))=$$FLEVDIFF^DIKCU(DIRFIL,DIFIL)
	..... S DIIENSA=$P(DIIENS,",",DILEVD+1,999)
	..... Q:$D(@DIEFTMP@("V",DIFIL,DIIENSA,DIFLD,"O"))[0  S DIOLD=^("O")
	..... S DIEFDA(DIFIL,DIIENS,DIFLD)=DIOLD
	;
	D:$D(DIEFDA) FILE^DIEF("U","DIEFDA")
	Q
	;
SKEYCHK(DIEFF,DIEFFLD,DIEFNVAL,DA,DIEFIEN,DIEFFXR)	;Check simple key
	N DIEFKEY,DIEFK,DIEFKCHK
	Q:'$D(^DD("KEY","F",DIEFF,DIEFFLD)) 1
	I DIEFNVAL="" D NKEY(DIEFF,DIEFFLD,DIEFIEN) Q 0
	Q:'$D(DIEFFXR) 1
	S @DIEFTMP@("V",DIEFF,DIEFIEN,DIEFFLD,"N")=DIEFNVAL
	S DIEFKCHK=$$KEYCHK^DIKK2(DIEFF,.DA,DIEFFLD,"DIEFFXR",DIEFIEN,"DIEFKEY","N")
	K @DIEFTMP@("V",DIEFF,DIEFIEN,DIEFFLD,"N")
	Q:DIEFKCHK 1
	S DIEFK=0 F  S DIEFK=$O(DIEFKEY(DIEFF,DIEFIEN,"K",DIEFK)) Q:'DIEFK  D ERR740^DIEVK1(DIEFF,DIEFK,DIEFIEN)
	Q 0
	;
NKEY(DIEFF,DIEFFLD,DIEFIEN)	;Generate error message #742
	N DIEFK
	S DIEFK=0 F  S DIEFK=$O(^DD("KEY","F",DIEFF,DIEFFLD,DIEFK)) Q:'DIEFK  D
	. S DIEFK(DIEFK)=""
	S DIEFK=0 F  S DIEFK=$O(DIEFK(DIEFK)) Q:'DIEFK  D ERR742^DIEVK1(DIEFF,DIEFFLD,DIEFK,DIEFIEN)
	Q
