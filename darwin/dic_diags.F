#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "DARWIN_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

#ifdef ALLOW_CARBON

CBOP
CStartOfInterface
      SUBROUTINE DIC_DIAGS( myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE DIC_BIOTIC_DIAGS                                  |
C     | o Do DIC diagnostic output                           |
C     |==========================================================|
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DARWIN_FLUX.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS_PARAMS.h"
C     == Routine arguments ==
C     myTime - Current time of simulation ( s )
C     myIter - Iteration number
C     myThid -  Number of this instance of INI_FORCING
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEndOfInterface


C     == Local variables ==
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE
      INTEGER bi, bj, k
      CHARACTER*(MAX_LEN_MBUF) suff
      CHARACTER*(1) pf

      IF ( writeBinaryPrec .EQ. precFloat64 ) THEN
        pf(1:1) = 'D'
      ELSE
        pf(1:1) = 'R'
      ENDIF

#ifdef ALLOW_TIMEAVE

C     Dump files and restart average computation if needed
      IF ( DIFFERENT_MULTIPLE(taveFreq,myTime,deltaTClock).
     &                               and.myIter.ne.nIter0 ) THEN

C      Normalize by integrated time
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_NORMALIZ(SURave,dic_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(SURCave,dic_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(SUROave,dic_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(pCO2ave,dic_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(pHave,dic_timeave, 1 ,
     &                 bi,bj,myThid)
        ENDDO
       ENDDO

       IF ( PTRACERS_timeave_mdsio )  THEN

       write(*,*),'PTRACERS_timeave_mdsio = ', PTRACERS_timeave_mdsio 


         WRITE(suff,'(I10.10)') myIter
         CALL WRITE_FLD_XY_RL('DIC_Surtave.',suff,SURave,
     &        myIter,myThid)
         CALL WRITE_FLD_XY_RL('DIC_SurCtave.',suff,SURCave,
     &        myIter,myThid)
         CALL WRITE_FLD_XY_RL('DIC_SurOtave.',suff,SUROave,
     &        myIter,myThid)
         CALL WRITE_FLD_XY_RL('DIC_pHtave.',suff,pHave,
     &        myIter,myThid)
         CALL WRITE_FLD_XY_RL('DIC_pCO2tave.',suff,pCO2ave,
     &        myIter,myThid)

C - MM
C - OCT 2015
C - ADDING NEW TRACERS
C - MM
         CALL WRITE_FLD_XY_RL('DIC_SurOTHtave.',suff,SUROTHave,
     &        myIter,myThid)
       CALL WRITE_FLD_XY_RL('DIC_SurOABtave.',suff,SUROABave,
     &        myIter,myThid)
       CALL WRITE_FLD_XY_RL('DIC_SurN2Otave.',suff,SURN2Oave,
     &        myIter,myThid)
       CALL WRITE_FLD_XY_RL('DIC_SurN2OTHtave.',suff,SURN2OTHave,
     &        myIter,myThid)
       CALL WRITE_FLD_XY_RL('DIC_SurARave.',suff,SUROARave,
     &        myIter,myThid)


C - MM Additional tracers for R. Keeling
C - DECEMBER 2015

       CALL WRITE_FLD_XY_RL('DIC_O2sat.',suff, dO2satave,
     &        myIter,myThid)

       CALL WRITE_FLD_XY_RL('DIC_KwO2.',suff,KwO2ave,
     &        myIter,myThid)


       CALL WRITE_FLD_XYZ_RL('DIC_NCP.',suff,NCPave,
     &        myIter,myThid)




C - MM




       ENDIF

#ifdef ALLOW_MNC
       IF ( PTRACERS_timeave_mnc ) THEN
         CALL MNC_CW_SET_UDIM('dic_tave', -1, myThid)
         CALL MNC_CW_RL_W_S('D','dic_tave',0,0,'T',myTime,myThid)
         CALL MNC_CW_SET_UDIM('dic_tave', 0, myThid)
         CALL MNC_CW_I_W_S('I','dic_tave',0,0,'iter',myIter,myThid)
         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SUR_ave',SURave,myThid)
         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SURC_ave',SURCave,myThid)
         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SURO_ave',SUROave,myThid)
         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_pH_ave',pHave,myThid)
         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_pCO2_ave',pCO2ave,myThid)

CC - MM 2015
CC - ADDING NEW TRACERS

          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SUROAB_ave',SUROABave,myThid)

          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SUROTH_ave',SUROTHave,myThid)


          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SURN2O_ave',SURN2Oave,myThid)

          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SURN2OTH_ave',SURN2OTHave,myThid)

          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_SURAR_ave',SURARave,myThid)

CC MM ADDING TWO NEW DIAGNOSTICS FOR R KEELING
C - DECEMBER 2014

         CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_dO2sat_ave',dO2satave,myThid)

          CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_KwO2_ave',KwO2ave,myThid)

      CALL MNC_CW_RL_W(
     &        pf,'dic_tave',0,0,'dic_NCP_ave',NCPave,myThid)




C
CC - MM



       ENDIF
#endif

C      Reset averages to zero
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_RESET(SURave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SURCave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SUROave,1,bi,bj,myThid)
         ALL TIMEAVE_RESET(pCO2ave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(pHave,1,bi,bj,myThid)
CC - MM 2015
CC - ADDING NEW TRACERS
         CALL TIMEAVE_RESET(SUROABave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SUROTHave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SURN2Oave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SURN2OTHave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(SURARave,1,bi,bj,myThid)
CC 
CC TWO ADDITIONAL TRACERS FOR R KEELING
CC DECEMBER 2015 
CC
         CALL TIMEAVE_RESET(dO2satave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(KwO2ave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(NCPave,Nr,bi,bj,myThid)

         do k=1,Nr
           DIC_TimeAve(bi,bj,k)=0.d0
         enddo
        ENDDO
       ENDDO

      ENDIF

#endif /*TIMEAVE*/

      RETURN
      END
#endif  /*ALLOW_CARBON*/

#endif  /*DARWIN*/
#endif  /*ALLOW_PTRACERS*/
c ==================================================================
