!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2015 Guido Dhondt
!
!     This program is free software; you can redistribute it and/or
!     modify it under the terms of the GNU General Public License as
!     published by the Free Software Foundation(version 2);
!     
!
!     This program is distributed in the hope that it will be useful,
!     but WITHOUT ANY WARRANTY; without even the implied warranty of 
!     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
!     GNU General Public License for more details.
!
!     You should have received a copy of the GNU General Public License
!     along with this program; if not, write to the Free Software
!     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!
      subroutine calccvfacomp(nface,vfa,shcon,nshcon,ielmat,ntmat_,
     &  mi,ielfa,cvfa,physcon)
!
!     calculation of the secant heat capacity at constant volume
!     at the face centers (compressible media)
!
      implicit none
!
      integer nface,i,nshcon(2,*),imat,ntmat_,mi(*),
     &  ielmat(mi(3),*),ielfa(4,*)
!
      real*8 t1l,vfa(0:7,*),cp,shcon(0:3,ntmat_,*),cvfa(*),physcon(*)
!     
c$omp parallel default(none)
c$omp& shared(nface,vfa,ielmat,ielfa,ntmat_,shcon,nshcon,physcon,cvfa)
c$omp& private(i,t1l,imat,cp)
c$omp do
      do i=1,nface
         t1l=vfa(0,i)
!
!        take the material of the first adjacent element
!
         imat=ielmat(1,ielfa(1,i))
         call materialdata_cp_sec(imat,ntmat_,t1l,shcon,nshcon,cp,
     &       physcon)
!
!        cv=cp-r
!
         cvfa(i)=cp-shcon(3,1,imat)
      enddo
c$omp end do
c$omp end parallel
!            
      return
      end
