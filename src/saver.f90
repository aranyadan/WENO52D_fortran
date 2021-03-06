module saver
contains
  function save_data(q,x,y,n_x,n_y,t,id)
    integer :: n_x,id
    real :: t,gamma=1.4
    real,dimension(n_x,n_y,4) :: q
    real,dimension(n_x,n_y) :: u,p,rho,E,a,M,v
    real, dimension(n_x) :: x
    real, dimension(n_y) :: y
    character(len=5) :: charI
    character(len=1024) :: fname

    rho = q(:,:,1)
    u = q(:,:,2)/rho
    v = q(:,:,3)/rho
    E = q(:,:,4)/rho
    p = (gamma-1)*rho*(E-0.5*(u*u+v*v))
    a = SQRT(gamma*p/rho)
    M = u/a

    write(charI,'(I5)') id
    write(fname,'(a,i4.4,a,f6.4,a)') "./data/frame",id,"t_",t,".dat"


    open(unit = 100,file = fname)
    do j=1,n_y
      do i=1,n_x
        write(100,*)x(i),y(j),u(i,j),v(i,j),p(i,j),rho(i,j)
      end do
    end do
    close(100)

  end function save_data

  function get_video(val)
    integer :: val
    character(len=1024) :: property,command
    select case (val)
      case(1)
        property='velocity'
      case(2)
        property='pressure'
      case(3)
        property='density'
      case(4)
        property='Mach_number'
      case default
        property='y'
    end select
    write(command,'(a,a,a,a,a)') "avconv -i ""./plots/",trim(property),"%04d.png"" -r 30 ./plots/",trim(property),".mp4"
    call system(command)
  end function get_video
end module saver
