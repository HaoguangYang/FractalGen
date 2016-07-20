!  Dll1.f90 
!
!  FUNCTIONS/SUBROUTINES exported from Dll1.dll:
!  Dll1 - subroutine 
!
subroutine logistical(amin,amax,x0,stp,output)
    
  ! Expose subroutine Dll1 to users of this DLL
  !
  !DEC$ ATTRIBUTES C,DLLEXPORT::    logistical
  !DEC$ ATTRIBUTES REFERENCE::      amin,amax,x0,stp,output
  ! Variables
    implicit none
    integer,intent(in)::    stp
    real,intent(in) ::      amin,amax,x0
    real(8)::       output(257,stp)
    integer::       n, ierr, n0,j1, i_var,sup1,inf1,sup2,inf2
    real(8)::       j
    real(8) ::      a(stp)

 ! Body of Dll
    n0=257
    j=(amax-amin)/(stp-1)
!        allocate(Logistical(n0,stp),a(stp))
        do j1=1,stp
            a(j1)=amin+j*(j1-1)
        enddo
        output(1,1:stp)=x0
    
    do n=1,n0-1
        output(n+1,:) = a(:) * output(n,:) * (1 - output(n,:))
    enddo
!    deallocate(Logistical)
!    plot(:,:)=0
!    temp = res*output
!    do j1 = 1,stp
!        sup1=max(temp(1,j1),temp(2,j1))-1
!        inf2=min(temp(1,j1),temp(2,j1))+1
!        sup2=sup1
!        inf1=inf2
!        do n = 1,n0-1
!          plot(inf1:sup1,:)=n
!            plot(inf2:sup2,:)=n
!            if (n==n0-1) exit
!            inf1=sup1+1
!            sup1=max(sup1,temp(n+2,j1))+1
!            sup2=inf2-1
!            inf2=min(inf2,temp(n+2,j1))-1
!        enddo
!    enddo
    return
    
end subroutine logistical
