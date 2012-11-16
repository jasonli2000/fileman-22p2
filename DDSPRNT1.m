DDSPRNT1 ;SFISC/MKO-PRINT A FORM ;9DEC2003
 ;;22.0;VA FileMan;**1003**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PAGE ;Print page properties
 I $Y+7'<IOSL!(DDSPBRK&'$D(DDSPFRST)) D HEADER^DDSPRNT Q:$D(DIRUT)
 I DDSPBRK!$D(DDSPFRST) D
 . W !,"Page    Page"
 . W !,"Number  Properties"
 . W !,"------  ----------"
 K DDSPFRST
 ;
 S DDSCOL1=0,DDSCOL2=8,DDSCOL3=32
 F X=0,1 S DDSPG(X)=$G(^DIST(.403,+DDSFORM,40,DDSPG,X))
 Q:DDSPG(0)=""
 ;
 D W() Q:$D(DIRUT)
 W ?DDSCOL1,$P(DDSPG(0),U),?DDSCOL2,$P(DDSPG(1),U)
 ;
 D W() Q:$D(DIRUT)
 D WP^DDSPRNT($NA(^DIST(.403,+DDSFORM,40,DDSPG,15)),DDSCOL2+1)
 Q:$D(DIRUT)
 ;
 S X=$P(DDSPG(0),U,2)
 I X]"" D  Q:$D(DIRUT)
 . D WR("HEADER BLOCK:",$P($G(^DIST(.404,X,0)),U)_" (#"_X_")")
 . S DDSHBK(X)=""
 ;
 D WR("PAGE COORDINATE:",$P(DDSPG(0),U,3)) Q:$D(DIRUT)
 I $P(DDSPG(0),U,6) D WR("IS THIS A POP UP PAGE?:","YES") Q:$D(DIRUT)
 D WR("LOWER RIGHT COORDINATE:",$P(DDSPG(0),U,7)) Q:$D(DIRUT)
 ;
 D WR("NEXT PAGE:",$P(DDSPG(0),U,4)) Q:$D(DIRUT)
 D WR("PREVIOUS PAGE:",$P(DDSPG(0),U,5)) Q:$D(DIRUT)
 D WR("PARENT FIELD:",$P(DDSPG(1),U,2)) Q:$D(DIRUT)
 ;
 D WR("PRE ACTION:",$G(^DIST(.403,+DDSFORM,40,DDSPG,11))) Q:$D(DIRUT)
 D WR("POST ACTION:",$G(^DIST(.403,+DDSFORM,40,DDSPG,12))) Q:$D(DIRUT)
 K DDSPG(0),DDSPG(1)
 ;
 ;Loop through all blocks
 I $X D W() Q:$D(DIRUT)
 Q:'$O(^DIST(.403,+DDSFORM,40,DDSPG,40,0))
 ;
 I $Y+7'<IOSL D HEADER^DDSPRNT Q:$D(DIRUT)
 W !?DDSCOL2,"Block  Block"
 W !?DDSCOL2,"Order  Properties (Form File)"
 W !?DDSCOL2,"-----  ----------------------"
 ;
 N DDSBKO
 S DDSBKO=""
 F  S DDSBKO=$O(^DIST(.403,+DDSFORM,40,DDSPG,40,"AC",DDSBKO)) Q:DDSBKO=""!$D(DIRUT)  S DDSBK=0 F  S DDSBK=$O(^DIST(.403,+DDSFORM,40,DDSPG,40,"AC",DDSBKO,DDSBK)) Q:'DDSBK!$D(DIRUT)  D BLOCK
 Q
 ;
BLOCK ;Print Block properties
 S DDSCOL1=8,DDSCOL2=15,DDSCOL3=39
 F X=0,1,2,"COMP MUL","COMP MUL PTR" S DDSBK(X)=$G(^DIST(.403,+DDSFORM,40,DDSPG,40,DDSBK,X))
 Q:DDSBK(0)=""
 ;
 D W($P(DDSBK(0),U,2),DDSCOL1) Q:$D(DIRUT)
 W ?DDSCOL2,$P($G(^DIST(.404,DDSBK,0)),U)_" (#"_DDSBK_")"
 D W() Q:$D(DIRUT)
 ;
 D WR("TYPE OF BLOCK:",$$EXTERNAL^DILFD(.4032,3,"",$P(DDSBK(0),U,4))) Q:$D(DIRUT)
 D WR("BLOCK COORDINATE:",$P(DDSBK(0),U,3)) Q:$D(DIRUT)
 D WR("POINTER LINK:",$P(DDSBK(1),U)) Q:$D(DIRUT)
 D WR("REPLICATION:",$P(DDSBK(2),U)) Q:$D(DIRUT)
 D WR("INDEX:",$P(DDSBK(2),U,2)) Q:$D(DIRUT)
 D WR("INITIAL POSITION:",$P(DDSBK(2),U,3)) Q:$D(DIRUT)
 D WR("DISALLOW LAYGO",$P(DDSBK(2),U,4)) Q:$D(DIRUT)
 D WR("FIELD FOR SELECTION:",$P(DDSBK(2),U,5)) Q:$D(DIRUT)
 D WR("COMPUTED MULTIPLE:",DDSBK("COMP MUL")) Q:$D(DIRUT)
 D WR("COMPUTED MULTIPLE POINTER:",DDSBK("COMP MUL PTR")) Q:$D(DIRUT)
 ;
 D WR("PRE ACTION:",$G(^DIST(.403,+DDSFORM,40,DDSPG,40,DDSBK,11))) Q:$D(DIRUT)
 D WR("POST ACTION:",$G(^DIST(.403,+DDSFORM,40,DDSPG,40,DDSBK,12))) Q:$D(DIRUT)
 ;
 K DDSBK(1),DDSBK(2)
 S DDSBK(0)=$G(^DIST(.404,DDSBK,0)) Q:DDSBK(0)=""
 ;
 I $Y+6'<IOSL D HEADER^DDSPRNT Q:$D(DIRUT)
 W !!?DDSCOL2,"Block Properties (Block File)"
 W !,?DDSCOL2,"-----------------------------"
 D BLOCK^DDSPRNT2
 Q
 ;
HBLKS ;Header blocks
 Q:'$D(DDSHBK)
 I $Y+7'<IOSL D HEADER^DDSPRNT Q:$D(DIRUT)
 W !!,"Header Block Properties"
 W !,"------------------------"
 S DDSCOL1=8,DDSCOL2=15,DDSCOL3=39
 S DDSBK="" F  S DDSBK=$O(DDSHBK(DDSBK)) Q:'DDSBK!$D(DIRUT)  D
 . S DDSBK(0)=$G(^DIST(.404,DDSBK,0)) Q:DDSBK(0)=""
 . D W("NAME: "_$P(DDSBK(0),U)_" (#"_DDSBK_")") Q:$D(DIRUT)
 . D W() Q:$D(DIRUT)
 . D BLOCK^DDSPRNT2
 . D W() Q:$D(DIRUT)
 Q
 ;
WR(DDSLAB,DDSVAL,DDSFLG) ;Write label and value
 I DDSVAL="",'$G(DDSFLG) Q
 ;
 D W() Q:$D(DIRUT)
 W ?DDSCOL2,DDSLAB
 ;
 I $X>DDSCOL3 N DDSCOL3 S DDSCOL3=$X+1
 D PCOL(DDSVAL,DDSCOL3)
 Q
 ;
PCOL(DDSVAL,DDSCOL) ;Print DDSVAL starting in column DDSCOL
 N DDSWIDTH,DDSIND
 S DDSWIDTH=IOM-DDSCOL-1
 F DDSIND=1:DDSWIDTH:$L(DDSVAL) D  Q:$D(DIRUT)
 . I DDSIND>1 D W() Q:$D(DIRUT)
 . W ?DDSCOL,$E(DDSVAL,DDSIND,DDSIND+DDSWIDTH-1)
 Q
 ;
W(DDSSTR,DDSCOL) ;Write DDSSTR preceded by !?DDSCOL
 I $Y+3'<IOSL D HEADER^DDSPRNT Q:$D(DIRUT)
 W !?+$G(DDSCOL),$G(DDSSTR)
 Q
