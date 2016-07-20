!  Polynomial.f90 
!
!  FUNCTIONS/SUBROUTINES exported from Polynomial.dll:
!  Polynomial - subroutine 
!
subroutine Polynomial(deg, coef, yres, xres, yrange, xrange,output)

  ! Expose subroutine Polynomial to users of this DLL
  !
  !DEC$ ATTRIBUTES C,DLLEXPORT::polynomial
  !DEC$ ATTRIBUTES REFERENCE::deg, coef, xres, yres, xrange, yrange
    implicit none
  ! Variables
    integer     deg,xres,yres,n,m,d,cyc
    real        coef(deg+1),xrange(2),yrange(2)
    real(8)     xstp(xres),ystp(yres),coefprime(deg+1)
    complex(8)     plot,val,dval
    complex(8)     plotpoly(deg+1)
    real(8)     output(yres,xres)
    
  ! Body of Polynomial
    do n=1,xres
        xstp(n)=xrange(1)+(n-1)*(xrange(2)-xrange(1))/xres
    enddo
    do n=1,yres
        ystp(n)=yrange(1)+(n-1)*(yrange(2)-yrange(1))/yres
    enddo
    do n=1,deg
        coefprime(n)=coef(n+1)*n
    enddo
    coefprime(deg+1)=0
    do n=1,xres
        do m=1,yres
            plot=cmplx(xstp(n),ystp(m))
            do d=0,deg
                plotpoly(d+1)=plot**d
            enddo
            val=dot_product(coef,plotpoly)
            dval=dot_product(coefprime,plotpoly)
            cyc=0
            do while (abs(val)>=0.01 .and. cyc<=10000*deg)
                plot=plot-val/dval
                do d=0,deg
                    plotpoly(d+1)=plot**d
                enddo
                val=dot_product(coef,plotpoly)
                dval=dot_product(coefprime,plotpoly)
                cyc=cyc+1
            enddo
            output(m,n)=imag(plot)
        enddo
    enddo
    
end subroutine Polynomial
