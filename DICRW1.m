DICRW1 ;SFISC/XAK-SELECT A FILE ;11:06 AM  12 Oct 1999
 ;;22.0;VA FileMan;**999**;Mar 30, 1999
L ;LIST DD'S
 S DIB(1)=0 S D=8101.1 D C2 G C4:U[X&(Y<0),L:Y<0 ;**CCO/NI 'START WITH WHAT FILE'
C3 S D=8101.2 D C2 G C3:Y<0&(X'[U) ;**CCO/NI  'GO TO WHAT FILE'
ERR I Y<DIB(1),X'[U W $C(7),!,$$EZBLD^DIALOG(1510) G L ;**CCO/NI  START WITH > GO TO
C4 I X[U!'$D(DIC) K DIC Q
 S X=DIB(1),DIB(1)=+Y,Y=X Q
C2 D R1^DICRW D:$D(DDUC) DU S DIC(0)="QEI" D DIC^DICRW K DIAC,DIFILE Q:X[U!'$D(DIC)!(Y=-1)  S:DIB(1)=0 DIB(1)=+Y Q
DU S DIC("S")="I Y'<2 "_DIC("S")
 Q
