!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2019 Guido Dhondt
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
      subroutine uboun(boun,kstep,kinc,time,node,idof,coords,vold,mi,
     &                 iponoel,inoel,ipobody,xbody,ibody,ipkon,kon,
     &                 lakon,ielprop,prop,ielmat,
     &                 shcon,nshcon,rhcon,nrhcon,ntmat_,cocon,ncocon)
!
!     user subroutine uboun
!
!
!     INPUT:
!
!     kstep              step number
!     kinc               increment number
!     time(1)            current step time
!     time(2)            current total time
!     node               node number
!     idof               degree of freedom
!     coords  (1..3)     global coordinates of the node
!     vold(0..4,1..nk)   solution field in all nodes
!                        (not available for CFD-calculations)
!                        0: temperature
!                        1: displacement in global x-direction
!                           (or mass flow rate for fluid nodes)
!                        2: displacement in global y-direction
!                        3: displacement in global z-direction
!                        4: not used
!     mi(1)              max # of integration points per element (max
!                        over all elements)
!     mi(2)              max degree of freedomm per node (max over all
!                        nodes) in fields like v(0:mi(2))...
!     iponoel(i)         the network elements to which node i belongs
!                        are stored in inoel(1,iponoel(i)),
!                        inoel(1,inoel(2,iponoel(i)))...... until
!                        inoel(2,inoel(2,inoel(2......)=0
!     inoel(1..2,*)      field containing the network elements
!     ipobody(1,i)       points to an entry in fields ibody and xbody 
!                        containing the body load applied to element i, 
!                        if any, else 0
!     ipobody(2,i)       index referring to the line in field ipobody
!                        containing a pointer to the next body load
!                        applied to element i, else 0
!     ibody(1,i)         code identifying the kind of body load i:
!                        1=centrifugal, 2=gravity, 3=generalized gravity
!     ibody(2,i)         amplitude number for load i
!     ibody(3,i)         load case number for load i
!     xbody(1,i)         size of body load i
!     xbody(2..4,i)      for centrifugal loading: point on the axis,
!                        for gravity loading with known gravity vector:
!                          normalized gravity vector
!     xbody(5..7,i)      for centrifugal loading: normalized vector on the
!                          rotation axis
!     ipkon(i)           points to the location in field kon preceding
!                        the topology of element i
!     kon(*)             contains the topology of all elements. The
!                        topology of element i starts at kon(ipkon(i)+1)
!                        and continues until all nodes are covered. The
!                        number of nodes depends on the element label
!     lakon(i)           contains the label of element i
!     ielprop(i)         points to the location in field prop preceding
!                        the properties of element i
!     prop(*)            contains the properties of all network elements. The
!                        properties of element i start at prop(ielprop(i)+1)
!                        and continues until all properties are covered. The
!                        appropriate amount of properties depends on the
!                        element label. The kind of properties, their
!                        number and their order corresponds
!                        to the description in the user's manual,
!                        cf. the sections "Fluid Section Types"
!     ielmat(j,i)        contains the material number for element i
!                        and layer j
!     shcon(0,j,i)       temperature at temperature point j of material i
!     shcon(1,j,i)       specific heat at constant pressure at the
!                        temperature point j of material i
!     shcon(2,j,i)       dynamic viscosity at the temperature point j of
!                        material i
!     shcon(3,1,i)       specific gas constant of material i
!     nshcon(i)          number of temperature data points for the specific
!                        heat of material i
!     rhcon(0,j,i)       temperature at density temperature point j of 
!                        material i
!     rhcon(1,j,i)       density at the density temperature point j of
!                        material i
!     nrhcon(i)          number of temperature data points for the density
!                        of material i
!     ntmat_             maximum number of temperature data points for 
!                        any material property for any material
!     ncocon(1,i)        number of conductivity constants for material i
!     ncocon(2,i)        number of temperature data points for the 
!                        conductivity coefficients of material i
!     cocon(0,j,i)       temperature at conductivity temperature point
!                        j of material i
!     cocon(k,j,i)       conductivity coefficient k at conductivity
!                        temperature point j of material i
!
!     OUTPUT:
!
!     boun               boundary value for degree of freedom idof
!                        in node "node"
!           
      implicit none
!
      character*8 lakon(*)
!
      integer kstep,kinc,node,idof,mi(*),iponoel(*),inoel(2,*),
     &  ipobody(2,*),ibody(3,*),ipkon(*),kon(*),ielprop(*),
     &  ielmat(mi(3),*),nshcon(*),nrhcon(*),ncocon(2,*),ntmat_
! 
      real*8 boun,time(2),coords(3),vold(0:mi(2),*),xbody(7,*),
     &  prop(*),shcon(0:3,ntmat_,*),rhcon(0:1,ntmat_,*),
     &  cocon(0:6,ntmat_,*)
!
      intent(in) kstep,kinc,time,node,idof,coords,vold,mi,
     &                 iponoel,inoel,ipobody,xbody,ibody,ipkon,kon,
     &                 lakon,ielprop,prop,ielmat,
     &                 shcon,nshcon,rhcon,nrhcon,ntmat_,cocon,ncocon
!
      intent(out) boun
      real*8 amplitude,ang1,ang2,ang0,x1,x2,y1,y2,omega
!      real, parameter :: omega
      real, parameter :: r=0.001
      omega=2.0*4.d0*datan(1.d0)*cocon(1,1,1)
!
	ang1=ASIN(0.000025/r)
	ang2=ASIN(-0.000025/r)
	ang0=0
!
!    	if(time(2) .lt. 10.0) then
!    	 amplitude=(time(2)/0.1)*sin(omega*(1.0/10.0)*(time(2)**2.0))
!     	else
!         amplitude=sin(omega*time(2))
!        endif
!       if(time(2) .lt. 1.0) then
!    	  amplitude=(time(2)/1.0)*sin(omega*(1.0/2.0)*(time(2)**2.0))
!     	else
!         amplitude=sin(omega*time(2))
!       endif
!        
        amplitude=sin(omega*time(2))
!        
!
	x1=-r*abs(cos(amplitude*10.0*4.d0*datan(1.d0)/180.0))+r
	y1=r*sin(amplitude*10.0*4.d0*datan(1.d0)/180.0)
	x2=-r*abs(cos(amplitude*10.0*4.d0*datan(1.d0)/180.0))+r
	y2=r*sin(amplitude*10.0*4.d0*datan(1.d0)/180.0)
!	
!      if((node.eq.71).OR.(node.eq.142)) then
!      	if(idof.eq.1) then
!      		boun=-x2*cos(ang2)-y2*sin(ang2)
!      	else if(idof.eq.2) then
!      		boun=y2*cos(ang2)+x2*sin(ang2)
!      	endif
!      else if((node.eq.213).OR.(node.eq.284)) then
!      	if(idof.eq.1) then
!      		boun=-x1*cos(ang1)-y1*sin(ang1)
!      	else if(idof.eq.2) then
!      		boun=y1*cos(ang1)+x1*sin(ang1)
!      	endif
!      endif
!
!      if((node.eq.101).OR.(node.eq.202)) then
!      	if(idof.eq.1) then
!      		boun=-x2*cos(ang2)-y2*sin(ang2)
!      	else if(idof.eq.2) then
!      		boun=y2*cos(ang2)+x2*sin(ang2)
!      	endif
!      else if((node.eq.606).OR.(node.eq.505)) then
!      	if(idof.eq.1) then
!      		boun=-x1*cos(ang1)-y1*sin(ang1)
!      	else if(idof.eq.2) then
!      		boun=y1*cos(ang1)+x1*sin(ang1)
!      	endif
!      else if((node.eq.303).OR.(node.eq.404)) then
!      	if(idof.eq.1) then
!      		boun=-x1*cos(ang0)-y1*sin(ang0)
!      	else if(idof.eq.2) then
!      		boun=y1*cos(ang0)+x1*sin(ang0)
!      	endif
!      endif
!      
      if((node.eq.121).OR.(node.eq.242)) then
      	if(idof.eq.1) then
      		boun=-x2*cos(ang2)-y2*sin(ang2)
      	else if(idof.eq.2) then
      		boun=y2*cos(ang2)+x2*sin(ang2)
        endif
      else if((node.eq.605).OR.(node.eq.726)) then
      	if(idof.eq.1) then
      		boun=-x1*cos(ang1)-y1*sin(ang1)
      	else if(idof.eq.2) then
      		boun=y1*cos(ang1)+x1*sin(ang1)
      	endif
      else if((node.eq.363).OR.(node.eq.484)) then
      	if(idof.eq.1) then
      		boun=-x1*cos(ang0)-y1*sin(ang0)
      	else if(idof.eq.2) then
      		boun=y1*cos(ang0)+x1*sin(ang0)
      	endif
      endif
!      
!      if((node.eq.201).OR.(node.eq.402)) then
!      	if(idof.eq.1) then
!      		boun=-x2*cos(ang2)-y2*sin(ang2)
!      	else if(idof.eq.2) then
!      		boun=y2*cos(ang2)+x2*sin(ang2)
!        endif
!      else if((node.eq.1005).OR.(node.eq.1206)) then
!      	if(idof.eq.1) then
!      		boun=-x1*cos(ang1)-y1*sin(ang1)
!      	else if(idof.eq.2) then
!      		boun=y1*cos(ang1)+x1*sin(ang1)
!      	endif
!      else if((node.eq.603).OR.(node.eq.804)) then
!      	if(idof.eq.1) then
!      		boun=-x1*cos(ang0)-y1*sin(ang0)
!      	else if(idof.eq.2) then
!      		boun=y1*cos(ang0)+x1*sin(ang0)
!      	endif
!      endif
!   
      return
      end

