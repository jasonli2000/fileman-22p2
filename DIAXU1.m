DIAXU1 ;SFISC/DCM-UPDATE DESTINATION FILE (CONT) ;3/5/93  2:34 PM
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
START K DIC,DO,DA,DR,DD,X
 D SETVAR,PROCESS,EOJ
 Q
 ;
SETVAR S DIAXFILE=DIAXET(DILL,"FILE")
 S DIAXMODE=$P(^TMP("DIAX",$J,DIAXFILE,"MODE"),U)
 I $D(^TMP("DIAX",$J,DIAXFILE,"X")) S X=^("X")
 I $D(^TMP("DIAX",$J,DIAXFILE,"DA(1)")) F DIAXII=1:1 Q:'$D(^("DA("_DIAXII_")"))  S @("DA("_DIAXII_")="_^("DA("_DIAXII_")"))
 I $D(^TMP("DIAX",$J,DIAXFILE,"DIC(""P"")")) S DIC("P")=^("DIC(""P"")")
 Q
 ;
PROCESS I DIAXMODE="A" S DIC=^TMP("DIAX",$J,DIAXFILE,"GL") D CALLDIC^DIAXU2 Q:$D(DIAXMSG)  S DIAXAVAL=+Y D ADDCONT Q
 D BUILDDR
 S DIE=^TMP("DIAX",$J,DIAXFILE,"GL"),@("DA="_^("DA")) I $G(DR)]"" D CALLDIE^DIAXU2 Q:$D(DIAXMSG)
 I $D(^TMP("DIAX",$J,DIAXFILE,"WP")) D WP^DIAXU2
 Q
 ;
ADDCONT S DA=DIAXAVAL,DIE=DIC
 I $D(^TMP("DIAX",$J,DIAXFILE,"WP")) D WP^DIAXU2
 D BUILDDR
 I $G(DR)]"" D CALLDIE^DIAXU2 Q:$D(DIAXMSG)
 D DA
 Q
 ;
BUILDDR I $D(^TMP("DIAX",$J,DIAXFILE,"DR")) S DR=^("DR")
 I $D(^TMP("DIAX",$J,DIAXFILE,"DR"))=11 S DIAXZRO=0 F DIAXL=0:0 S DIAXZRO=$O(^TMP("DIAX",$J,DIAXFILE,"DR",DIAXZRO)) Q:'DIAXZRO  S DR(1,DIAXFILE,DIAXZRO)=^(DIAXZRO)
 Q
 ;
DA S (DIAXET(DIAXFILE,"DA"),^TMP("DIAX",$J,DIAXFILE,"DA"))=DIAXAVAL
 S DIAXX=$G(DIAXET(DIAXFILE)) I DIAXX=""!(DIAXFILE=DIAXX) Q
 I $D(DIAXET(DIAXX,"DA")) S DIAXET(DIAXFILE,"DA(1)")=DIAXET(DIAXX,"DA")
 I $D(DIAXET(DIAXX,"DA(1)")) F DIAXII=1:1 Q:'$D(DIAXET(DIAXX,"DA("_DIAXII_")"))  S DIAXET(DIAXFILE,"DA("_(DIAXII+1)_")")=DIAXET(DIAXX,"DA("_DIAXII_")")
 Q
 ;
EOJ K DIC,DIE,DIK,DA,DR,DIAXAVAL,X,Y
 K:$D(DIAXMSG) ^TMP("DIAX",$J)
 K ^TMP("DIAX",$J,DIAXFILE,"DR"),^("WP")
 K DIAXII,DIAXFILE,DIAXMODE,DIAXDRVL,DIAXZRO,DIAXX,DIAXL,DIAX("FIELD")
 Q
