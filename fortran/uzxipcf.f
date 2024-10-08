
      SUBROUTINE uzxipcf(ear, ne, param, ifl, photar, photer)

      INTEGER ne, ifl
      REAL ear(0:ne),param(7),photar(ne),photer(ne),eparam(5)

C---
C XSPEC model subroutine for redshifted "partial covering
C absorption". Assumes that part of the emitter is covered by
C the given absorption and the rest of the emitter is unobscured.
C---
C number of model parameters: 7
C     1     ANH   Hydrogen column density (in units of 10**22
C                 atoms per square centimeter
c     2     xi
c     3     PhotonIndex
c     4     vturb
C     5     FRACT	Covering fraction (0 implies no absorption,
C                 1 implies the emitter is all absorbed with
C                 the indicated column ANH.
C     6     Velocity
C     7     REDSHIFT

      REAL fract, fractc, zfac, vfac, c
      INTEGER ie
      CHARACTER pname*128, pvalue*128, contxt*255
      CHARACTER*255 filenm
      LOGICAL qexist

      INTEGER lenact
      CHARACTER fgmstr*128
      EXTERNAL lenact, fgmstr

c     nh in units of 1e22 - param(1)
      eparam(1) = param(1)!*1.e22

c     logxi
      eparam(2) = param(2)

c     PhotonIndex
      eparam(3) = param(3)

c     vturb
      eparam(4) = param(4)

c     z=0
      eparam(5) = param(7)

c     light speed
      c=2.99792458 * 1.e5

C shift energies to the emitter frame

      zfac = 1.0 + param(7)
      vfac = (1+param(6)/c)/(1-(param(6)/c)**2)**0.5
      DO ie = 0, ne
         ear(ie) = ear(ie) * zfac * vfac
      ENDDO

c construct the path to the mtable file required

      pname = 'UZXIPCF_DIR'
      pvalue = fgmstr(pname)

      IF ( lenact(pvalue) .GT. 0 ) THEN
         filenm = pvalue(:lenact(pvalue))//'uzxipcf_mtable.fits'
      ELSE
         filenm = 'uzxipcf_mtable.fits'
      ENDIF

c check whether the file exists

      INQUIRE(file=filenm, exist=qexist)
      IF (.NOT.qexist) THEN
         contxt = ' uzxipcf model ignored : cannot find '
     &            //filenm(:lenact(filenm))
         CALL xwrite(contxt, 5)
         contxt = ' use xset UZXIPCF_DIR directory to point to the file'
         CALL xwrite(contxt, 5)
         DO ie = 1, ne
            photar(ie) = 1.0
         ENDDO
         RETURN
      ENDIF

c interpolate on the mtable

      call xsmtbl(ear, ne, eparam, filenm, ifl, photar, photer)

C now modify for the partial covering

      fract = param(5)
      fractc = 1. - fract

      DO ie = 1, ne
         photar(ie) = fractc + fract * photar(ie)
      ENDDO

C shift energies back to the observed frame

      zfac = 1.0 + param(7)
      vfac = (1+param(6)/c)/(1-(param(6)/c)**2)**0.5
      DO ie = 0, ne
         ear(ie) = ear(ie) / zfac /vfac
      ENDDO

      RETURN
      END
