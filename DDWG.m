DDWG ;SFISC/MKO-GOTO ;05:49 PM  24 Aug 2002
 ;;22.0;VA FileMan;**999**;Mar 30, 1999
GOTO ;Go to a specific location
 N DDWANS,DDWI,DDWHLP
 D BLD^DIALOG(8140,,,"DDWHLP") ;**
 D ASK(4,$$EZBLD^DIALOG(7069)_": ",17,"","D VALGTO",.DDWHLP,.DDWANS) ;**
 I U[DDWANS
 E  I "Ss"[$E(DDWANS)!(DDWANS'?1A.E) D
 . D GOTOS
 E  I "Ll"[$E(DDWANS) D
 . D GOTOL
 E  I "Cc"[$E(DDWANS) D
 . D GOTOC
 Q
 ;
GOTOS ;Go to a page
 N DDWS
 S DDWS=DDWANS
 S:DDWS?1A.E DDWS=$E(DDWS,2,999)
 S:DDWS?1P.E DDWS=$E(DDWS,2,999)
 I DDWANS["+" S DDWS=$$SCREEN+DDWS
 E  I DDWANS["-" S DDWS=$$SCREEN-DDWS
 I DDWS<1 S DDWS=1
 E  I DDWS>$$LTOSC(DDWCNT) S DDWS=$$LTOSC(DDWCNT)
 D LINE(DDWS-1*DDWMR+1)
 Q
 ;
GOTOL ;Go to a line
 N DDWLN
 S DDWLN=DDWANS
 S:DDWLN?1A.E DDWLN=$E(DDWLN,2,999)
 S:DDWLN?1P.E DDWLN=$E(DDWLN,2,999)
 I DDWANS["+" S DDWLN=DDWA+DDWRW+DDWLN
 E  I DDWANS["-" S DDWLN=DDWA+DDWRW-DDWLN
 I DDWLN<1 S DDWLN=1
 E  I DDWLN>DDWCNT S DDWLN=DDWCNT
 D LINE(DDWLN)
 Q
 ;
GOTOC ;Go to a column
 N DDWCOL
 S DDWCOL=DDWANS
 S:DDWCOL?1A.E DDWCOL=$E(DDWCOL,2,999)
 S:DDWCOL?1P.E DDWCOL=$E(DDWCOL,2,999)
 I DDWANS["+" S DDWCOL=DDWC+DDWCOL
 E  I DDWANS["-" S DDWCOL=DDWC-DDWCOL
 I DDWCOL<1 S DDWCOL=1
 E  I DDWCOL>246 S DDWCOL=246
 D POS(DDWRW,DDWCOL,"R")
 Q
 ;
LINE(DDWLN,DDWCOL) ;Adjust arrays and position cursor on line DDWLN
 I $G(DDWCOL)'="E",'$G(DDWCOL) S DDWCOL=1
 S:DDWLN>DDWCNT DDWLN=DDWCNT
 I DDWLN>DDWA,DDWLN'>(DDWA+DDWMR-1) D
 . D POS(DDWLN-DDWA,DDWCOL,"RN")
 E  I DDWLN>DDWA D
 . D SHFTDN^DDW3(DDWLN,DDWCOL),POS(DDWLN-DDWA,DDWCOL,"RN")
 E  D
 . D SHFTUP^DDW3(DDWLN),POS(1,DDWCOL,"RN")
 Q
 ;
ASK(DDWLC,DDWS,DDWLEN,DDWDEF,DDWVAL,DDWHLP,DDWANS,DDWCOD) ;Prompt user
 N DDWI
 D CUP(DDWMR-DDWLC,1)
 W $P(DDGLGRA,DDGLDEL)_$TR($J("",IOM)," ",$P(DDGLGRA,DDGLDEL,3))_$P(DDGLGRA,DDGLDEL,2)
 F DDWI=DDWMR-DDWLC+1:1:DDWMR D CUP(DDWI,1) W $P(DDGLCLR,DDGLDEL)
 K DDWANS F  D PROMPT Q:$D(DDWANS)
 ;
 F DDWI=DDWMR-DDWLC:1:DDWMR D
 . D CUP(DDWI,1)
 . W $P(DDGLCLR,DDGLDEL)_$E(DDWL(DDWI),1+DDWOFS,IOM+DDWOFS)
 D POS(DDWRW,DDWC,"RN")
 Q
 ;
PROMPT ;Issue read
 N DDWERR,DDWX
 D CUP(DDWMR-DDWLC+1,1) W DDWS_$P(DDGLCLR,DDGLDEL)
 D EN^DIR0(IOTM+DDWMR-DDWLC-1,$L(DDWS),DDWLEN,1,$G(DDWDEF),245,"","","AKTW",.DDWX,.DDWCOD)
 ;
 I DDWX?1."?",$D(DDWHLP)>9!($G(DDWHLP)]"") D HELP(.DDWHLP) Q
 I $G(DDWVAL)]"" X DDWVAL I $D(DDWERR) W $C(7) D HELP(.DDWERR) Q
 S DDWANS=DDWX
 Q
 ;
VALGTO ;Validate DDWX
 N DDWCH
 Q:U[DDWX
 S DDWERR=$$EZBLD^DIALOG(1401) ;**
 Q:DDWX'?.1A.1P1.15N
 I DDWX?1A.E S DDWCH=$E(DDWX) Q:"SsLlCc"'[DDWCH
 I DDWX?.E1P.E I DDWX'["+",DDWX'["-" Q
 K DDWERR
 Q
 ;
HELP(DDWMSG) ;Print message
 N DDWI,DDWEC
 S:$D(DDWMSG)<9 DDWMSG(1)=DDWMSG
 S DDWEC=$O(DDWMSG(""),-1)
 F DDWI=2:1:DDWLC D
 . D CUP(DDWMR-DDWLC+DDWI,1)
 . W $P(DDGLCLR,DDGLDEL)_$G(DDWMSG(DDWI-DDWLC+DDWEC))
 Q
 ;
SCREEN() ;Return current screen
 Q DDWA+DDWRW-1\DDWMR+1
 ;
LTOSC(L) ;Convert line number to page number
 Q L-1\DDWMR+1
 ;
CUP(Y,X) ;Pos cursor
 S DY=IOTM+Y-2,DX=X-1 X IOXY
 Q
 ;
POS(R,C,F) ;Pos cursor based on char pos C
 N DDWX
 S:$G(C)="E" C=$L($G(DDWL(R)))+1
 S:$G(F)["N" DDWN=$G(DDWL(R))
 S:$G(F)["R" DDWRW=R,DDWC=C
 ;
 S DDWX=C-DDWOFS
 I DDWX>IOM!(DDWX<1) D SHIFT^DDW3(C,.DDWOFS)
 S DY=IOTM+R-2,DX=C-DDWOFS-1 X IOXY
 Q
