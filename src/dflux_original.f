! NEED THIS HEADER INFORMATION

      subroutine dflux(flux,sol,kstep,kinc,time,noel,npt,coords,
     &     jltyp,temp,press,loadtype,area,vold,co,lakonl,konl,
     &     ipompc,nodempc,coefmpc,nmpc,ikmpc,ilmpc,iscale,mi,
     &     sti,xstateini,xstate,nstate_,dtime)

      character*8 lakonl
      character*20 loadtype
!
      integer kstep,kinc,noel,npt,jltyp,konl(20),ipompc(*),nstate_,i,
     &  nodempc(3,*),nmpc,ikmpc(*),ilmpc(*),node,idof,id,iscale,mi(*)
!
      real*8 flux(2),time(2),coords(3),sol,temp,press,vold(0:mi(2),*),
     &  area,co(3,*),coefmpc(*),sti(6,mi(1),*),xstate(nstate_,mi(1),*),
     &  xstateini(nstate_,mi(1),*),dtime
!
      real*8 x0,y0,z0,a,b,c,vx,vy,vz,xarc,yarc,zarc,Xf,Yf,Zf,omega,xthe,
     &       ythe,zthe,XC,YC,ZC,Q,shapec,shapef
!
      intent(in) sol,kstep,kinc,time,noel,npt,coords,
     &     jltyp,temp,press,loadtype,area,vold,co,lakonl,konl,
     &     ipompc,nodempc,coefmpc,nmpc,ikmpc,ilmpc,mi,sti,
     &     xstateini,xstate,nstate_,dtime
     
      intent(out) flux,iscale

! END OF HEADER INFORMATION
! CUSTOM SUBROUTINE HERE

	  x0=0.0 
	  y0=0.0 
	  z0=0.1 
	  
!  effective welding arc *for surface heatflux a,b  *Body heatflux a,b,c[mm]
      a = 0.0022
      b = 0.0018
      c = 0.0031

	!  Path 1 Linear moving heat source 
      vx = 0.02   ! speed of welding in x direction is 2mm/sec
      vy = 0.00
      vz = 0.00
	  
	  xarc=vx*time(1)+x0
	  yarc=vy*time(1)+y0
	  zarc=vz*time(1)+z0
 
  
	  Xf=coords(1)-xarc	! coordinate of position x 
	  Yf=coords(2)-yarc	! coordinate of position y 
	  Zf=coords(3)-zarc	! coordinate of position z

	! Path 2 Circular moving heat source 
	  omega=0.314159*time(1)	! angular velocity
	  ythe=cos(omega)*0.1		! y coordinate Radius=0.1m
	  zthe=sin(omega)*0.1 		! z coordinate Radius=0.1m
	  xthe=0.1					! x coordinate - starting location (0.1, 0.1, 0) 

 	  XC=coords(1)-xthe	! coordinate of position x
	  YC=coords(2)-ythe	! coordinate of position y 
	  ZC=coords(3)-zthe	! coordinate of position z
	  
	  Q=2362.		  ! heat flux core : current220*voltage14*efficiency0.7
	  
! Gaussian Heat Source Distribution
	  heat=1.86632*Q/(a*b*c)   ! 1.86632=6*sqrt(3)/(pi^3/2)
	  shapef=EXP(-3*(Xf)**2./a**2.-3*(Yf)**2./b**2.-3*(Zf)**2./c**2.) ! Path1
	  shapec=EXP(-3*(XC)**2./a**2.-3*(YC)**2./b**2.-3*(ZC)**2./c**2.) ! Path2
	  
	if(kstep.eq. 1) then 
		flux(1)=heat*shapef
	else
		if(kstep.eq.3) then
			flux(1)=heat*shapec 
		endif	
	endif 
      
      RETURN
      END 
