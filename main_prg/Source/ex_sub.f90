module ex_sub
    use Types
    implicit none
 contains

subroutine exsub_print
    implicit none   

    print *, 'Hello from ex_sub!', mypara

end subroutine exsub_print

end module ex_sub