DMUFI002	; ; 10-JAN-2013 ; 1/27/13 3:46pm
	;;22.2V2;VA FILEMAN;;Mar 08, 2013
	;Per VHA Directive 2004-038, this routine should not be modified.
	Q:'DIFQR(1009.801)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,1009.801)
	;;=^DMU(1009.801,
	;;^UTILITY(U,$J,1009.801,0)
	;;=BROKEN FILE^1009.801^13^9
	;;^UTILITY(U,$J,1009.801,2,0)
	;;=BAD POINTER^6666^3111111^F^44
	;;^UTILITY(U,$J,1009.801,3,0)
	;;=BAD DATE^2^ABCDEF^M^78
	;;^UTILITY(U,$J,1009.801,4,0)
	;;=BAD SET^12^2441122^U^777
	;;^UTILITY(U,$J,1009.801,5,0)
	;;=BAD NUMBER^18^3331201^F^ABCDEF
	;;^UTILITY(U,$J,1009.801,7,0)
	;;=BAD C (POINTER) XREF^4^3220504^M^234
	;;^UTILITY(U,$J,1009.801,8,0)
	;;=BAD D (DATE) XREF^5^3220801^M^342
	;;^UTILITY(U,$J,1009.801,9,0)
	;;=LOOPY OUTPUT TRANSFORM^^^^^HELLO LINDA
	;;^UTILITY(U,$J,1009.801,11,0)
	;;=NORMAL ENTRY^1^3221111^M^33
	;;^UTILITY(U,$J,1009.801,13,0)
	;;=THIRTY-TWO CHARACTER LIMIT ENTRY
