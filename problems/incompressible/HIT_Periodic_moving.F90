! Template for PadeOps

#include "HIT_Periodic_moving_files/initialize.F90"       
#include "HIT_Periodic_moving_files/temporalHook.F90"  

program HIT_Periodic
    use mpi
    use kind_parameters,  only: clen
    use HIT_periodic_parameters, only: useBandpassFilter 
    use IncompressibleGrid, only: igrid
    use HIT_Periodic_parameters, only: k_bp_left, k_bp_right
    use temporalhook, only: doTemporalStuff
    use timer, only: tic, toc
    use exits, only: message

    implicit none

    type(igrid), allocatable, target :: igp
    character(len=clen) :: inputfile
    integer :: ierr

    call MPI_Init(ierr)               !<-- Begin MPI

    call GETARG(1,inputfile)          !<-- Get the location of the input file

    allocate(igp)                     !<-- Initialize hit_grid with defaults

    call igp%init(inputfile)          !<-- Properly initialize the hit_grid solver (see hit_grid.F90)
  
    call igp%start_io(.false.)                !<-- Start I/O by creating a header file (see io.F90)

    call igp%printDivergence()

    ! Initialize bandpass filtering 
    if (useBandpassFilter) then
         call igp%spectC%init_bandpass_filter(k_bp_left, k_bp_right, igp%cbuffzC(:,:,:,1), igp%cbuffyC(:,:,:,1))
    end if 

    call tic() 
    do while (igp%tsim < igp%tstop) 
       
       call igp%timeAdvance()     !<-- Time stepping scheme + Pressure Proj. (see igrid.F90)
       call doTemporalStuff(igp)     !<-- Go to the temporal hook (see temporalHook.F90)
       
    end do 
 
    call igp%finalize_io()                  !<-- Close the header file (wrap up i/o)

    call igp%destroy()                !<-- Destroy the IGRID derived type 
   

    deallocate(igp)                   !<-- Deallocate all the memory associated with scalar defaults
    
    call MPI_Finalize(ierr)           !<-- Terminate MPI 

end program
