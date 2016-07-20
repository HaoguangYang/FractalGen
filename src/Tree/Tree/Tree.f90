!  Tree.f90 
!
!  FUNCTIONS/SUBROUTINES exported from Tree.dll:
!  Tree - subroutine 
!
subroutine Tree(n,aa,xx,yy)

  ! Expose subroutine Tree to users of this DLL
  !
  !DEC$ ATTRIBUTES C,DLLEXPORT::Tree
  !DEC$ ATTRIBUTES REFERENCE:: n,aa,xx,yy

  ! Variables
    implicit none
    interface
    function ifs(x,y,a1,b1,c1,d1,e1,f1)
    implicit none
     real x,y,a1,b1,c1,d1,e1,f1
     real ifs(2)
    end
    end interface
    
    integer     n,ss
    real        p(n),xx(n),yy(n)
    real        aa(4,6),ans(2)
 ! Body of Tree
    ans=(0,0)
    call RANDOM_SEED()
    do ss = 1,n
    call RANDOM_NUMBER(p(ss))
    enddo
    do ss = 1,n
        if (p(ss)<=0.25) then
            ans=ifs(ans(1),ans(2),aa(1,1),aa(1,2),aa(1,3),aa(1,4),aa(1,5),aa(1,6))
        else
            if (p(ss)<=0.5) then
                ans=ifs(ans(1),ans(2),aa(2,1),aa(2,2),aa(2,3),aa(2,4),aa(2,5),aa(2,6))
            else
                if (p(ss)<=0.75) then
                    ans=ifs(ans(1),ans(2),aa(3,1),aa(3,2),aa(3,3),aa(3,4),aa(3,5),aa(3,6))
                else
                    ans=ifs(ans(1),ans(2),aa(4,1),aa(4,2),aa(4,3),aa(4,4),aa(4,5),aa(4,6))
                endif
            endif
        endif
        xx(ss)=ans(1)
        yy(ss)=ans(2)
    enddo
    end subroutine Tree

    
    function ifs(x,y,a1,b1,c1,d1,e1,f1)
    implicit none
     real  x,y,a1,b1,c1,d1,e1,f1
     real  ifs(2)
     ifs(1)=a1*x+b1*y+e1
     ifs(2)=c1*x+d1*y+f1
     return
    end function ifs
    