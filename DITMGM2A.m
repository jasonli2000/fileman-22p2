DITMGM2A ;SFISC/EDE(OHPRD),TKW-CONTINUATION OF ^DITMGM2 ;8MAR2006
 ;;22.0;VA FileMan;**1022**;Mar 30, 1999
 ;
FIELD ; PROCESS ONE FIELD IN ONE FILE/SUBFILE
 S DITMGMPF=^UTILITY("DITMGMRG",$J,DITMGMFL,DITMGMFD)
 S DITMGMX=$P(^DD(DITMGMFL,DITMGMFD,0),U,4),DITMGMNO=$P(DITMGMX,";",1),DITMGMPC=$P(DITMGMX,";",2),DITMGMDI=$S(DITMGMFD=.01&($P(^(0),U,5,99)["DINUM"):1,1:0)
 S DITMGMV=$S($P(^DD(DITMGMFL,DITMGMFD,0),U,2)["V":1,1:0)
 I DITMGMV D
 . N % S %=$P(^DIC(DITMGMPF,0,"GL"),U,2) I %["""" S %=$$CONVQQ^DILIBF(%)
 . S DITMGMF=DITMGMF_";"_%,DITMGMT=DITMGMT_";"_% Q
 S DITMGMXR="",DITMGMX=0 F DITMGML=0:0 S DITMGMX=$O(^DD(DITMGMFL,DITMGMFD,1,DITMGMX)) Q:DITMGMX'=+DITMGMX  D  Q:DITMGMXR'=""
 . S DITMGMXR=$P(^(DITMGMX,0),U,2),DITMGMTY=$P(^(0),U,3),DITMGMTZ=$P(^(0),U,1)
 . I DITMGMTY="",'DITMGMMU  Q
 . I DITMGMTY="",DITMGMMU,DITMGMFL'=DITMGMTZ,'$D(^DD(DITMGMTZ,0,"UP")) Q
 . S DITMGMXR=""
 . Q
 K DA I DITMGMXR="" D NOXREF Q
 Q:'$D(@(DITMGMG_""""_DITMGMXR_""","""_DITMGMF_""")"))
 S DITMGMN="" F DITMGML=0:0 S DITMGMN=$O(@(DITMGMG_""""_DITMGMXR_""","""_DITMGMF_""",DITMGMN)")) Q:DITMGMN=""  D ENTRY:'DITMGMMU,MULTIPLE:DITMGMMU
 Q
 ;
MULTIPLE ; MULTIPLE WITH XREF TO FILE
 N DIXR,DICNT,DIDA,DIEND,DITMGZZZ
 S DITMGZZZ=DITMGMN,(DICNT,DIEND)=+$P(DITMGMGM,"DA(",2),DIDA(DICNT)=DITMGMN
 S DIXR(DICNT)=DITMGMG_""""_DITMGMXR_""","""_DITMGMF_""","_DITMGMN_","
 S DICNT=DICNT-1
M2 I DICNT=DIEND S DITMGMN=DITMGZZZ Q
 S DIDA(DICNT)=$O(@(DIXR(DICNT+1)_+$G(DIDA(DICNT))_")"))
 I 'DIDA(DICNT) S DICNT=DICNT+1 G M2
 I DICNT=0 D  G M2
 . N DA F I=0:1:DIEND S DA(I)=DIDA(I)
 . S DA=DA(0) K DA(0)
 . N DIXR,DICNT,DIDA,DIEND D ENTRY
 . Q
 S DIXR(DICNT)=DIXR(DICNT+1)_DIDA(DICNT)_","
 S DICNT=DICNT-1 G M2
 ;
NOXREF ; FILES WITH NO REGULAR XREF ON POINTING FIELD
 I DITMGMDI,'DITMGMMU S DITMGMN=$S($D(@(DITMGMG_DITMGMF_")")):DITMGMF,1:"") D:DITMGMN ENTRY Q  ; If DINUM file xref not needed
 I '$D(@(DITMGMG_"0)")) W:'$D(DITMGM2("NOTALK")) !,"No Data Global:  ",DITMGMG Q
IHS D SEARCH Q  ;WON'T FALL THRU
 W:'$D(DITMGM2("NOTALK")) !,"No REGULAR xref on ",DITMGMFL,",",DITMGMFD," Merging entries for this file will",!,"now occur via Taskman in background!"
 ; SETUP CALL TO TASKMAN
 K DITMGMZT S:$D(ZTSK) DITMGMZT=ZTSK
 K ZTSAVE F %="DITMGMG","DITMGMGM","DITMGMNO","DITMGMPC","DITMGMF","DITMGMT","DITMGMFL","DITMGMFD","DITMGMDI","DITMGMXR","DITMGMMU","DITMGMV" S ZTSAVE(%)=""
 S ZTRTN="ZTM^DITMGM2",ZTDESC="PROCESS POINTER FIELD #"_DITMGMFD_" IN FILE #"_DITMGMFL_" FROM "_DITMGMF_" TO "_DITMGMT
 S ZTIO="",ZTDTH=DT D ^%ZTLOAD K ZTSK
 S:$D(DITMGMZT) ZTSK=DITMGMZT
 K DITMGMZT
 Q
 ;
SEARCH ; $O THRU DATA GBL
 D SEARCH^DITMGM2B
 Q
 ;
ENTRY ; PROCESS ONE FILE/SUBFILE ENTRY
 D ENTRY^DITMGM2B
 Q
QUOTES ;
 N %P,%Q S %W1="",%Q="""" F %P=1:1:$L(%W,%Q)-1 S %W1=%W1_$P(%W,%Q,%P)_%Q_%Q
 S %W1=%W1_$P(%W,%Q,$L(%W,%Q))
 Q
