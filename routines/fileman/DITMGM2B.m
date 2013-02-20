DITMGM2B	;SFISC/EDE(OHPRD),TKW-CONTINUATION OF DITMGM2 ;4/7/94  10:09
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;
SEARCH	; $O THRU DATA GBL
	Q:'$O(@(DITMGMG_"0)"))
	W:'$D(DITMGM2("NOTALK")) !,"No REGULAR xref on ",DITMGMFL,",",DITMGMFD,".  ",+$P(^(0),U,4)," entries.  Searching data global."
	F DITMGMN=0:0 S DITMGMN=$O(@(DITMGMG_DITMGMN_")")) Q:DITMGMN'=+DITMGMN  D
	. I DITMGMMU D SEARCHM Q
	. I $D(^(DITMGMN,DITMGMNO)),$P(^(DITMGMNO),U,DITMGMPC)=DITMGMF D ENTRY
	. Q
	Q
	;
SEARCHM	; $O THRU DATA GBL FOR MULTIPLES (TOP)
	S DITMGMDN=+$P(DITMGMGM,"DA(",2)
	S DA(DITMGMDN)=DITMGMN,DITMGDA(DITMGMDN)=DITMGMN
	S DITMGMGG=$P(DITMGMGM,"DA(",1)_"DA("_DITMGMDN_"),"
	S DITMGMDN=DITMGMDN-1
	NEW DITMGMN
	D SEARCHM2
	K DA,DITMGDA,DITMGMGG
	Q
	;
SEARCHM2	; MIDDLE (CALLED RECURSIVELY)
	I '$F(DITMGMGM,"DA("_DITMGMDN_"),") D SEARCHM3 Q
	S DITMGMGG=$P(DITMGMGM,",DA("_DITMGMDN_"),",1)_","
	F DITMGDA(DITMGMDN)=0:0 S DITMGDA(DITMGMDN)=$O(@(DITMGMGG_DITMGDA(DITMGMDN)_")")) Q:DITMGDA(DITMGMDN)'=+DITMGDA(DITMGMDN)  S DA(DITMGMDN)=DITMGDA(DITMGMDN) D SEARCHM4
	Q
	;
SEARCHM3	; BOTTOM
	D SETDA
	F DITMGMN=0:0 S DITMGMN=$O(@(DITMGMGM_DITMGMN_")")) Q:DITMGMN'=+DITMGMN  I $D(^(DITMGMN,DITMGMNO)),$P(^(DITMGMNO),U,DITMGMPC)=DITMGMF D ENTRY,SETDA
	Q
	;
SETDA	; SET DA ARRAY
	K DA
	F I=1:1 Q:'$D(DITMGDA(I))  S DA(I)=DITMGDA(I)
	Q
	;
SEARCHM4	; RECURSE
	S DITMGMDN=DITMGMDN-1
	D SEARCHM2
	S DITMGMDN=DITMGMDN+1
	Q
	;
ENTRY	; PROCESS ONE FILE/SUBFILE ENTRY
	D ENTRY^DITMGM2C
	Q
	;
INIT	;
	K DITMGMQF
	K DITMGMRG("ERROR") S DITMGMEC=0
	S:$D(ZTQUEUED) DITMGM2("NOTALK")=1
	S:$D(ZTSK) DITMGM2("NOTALK")=1 ; old Kernel
	I '$D(DITMGMFL) S DITMGMQF=20 Q
	I 'DITMGMFL S DITMGMQF=20 Q
	I '$D(^DIC(DITMGMFL,0,"GL")) S DITMGMQF=20 Q
	S DITMGMFG=^("GL")
	I '$D(DITMGMF)!('$D(DITMGMT)) S DITMGMQF=21 Q
	I 'DITMGMF!('DITMGMT)!(DITMGMF=DITMGMT) S DITMGMQF=22 Q
	I '$D(@(DITMGMFG_DITMGMF_",0)")) S DITMGMQF=23 Q
	I '$D(@(DITMGMFG_DITMGMT_",0)")) S DITMGMQF=24 Q
	Q
