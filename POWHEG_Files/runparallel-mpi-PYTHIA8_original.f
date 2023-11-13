c     This is a driver for a parallel run suitable for machines with MPI.
c
c     Edit to suite your needs.
c     Compile: mpif90 runparallel-mpi.f -o runparallel-mpi
c     Run with:
c     mpirun -np <n> <name executable>
c     where <n> is the number of parallel processes and <name executable>
c     is typically pwhg_main (with a directory prefix if needed)
c     The pwhg_main executable is NOT compiled with MPI, that is only required
c     for the synchronization of the different parallel stages.
c     The powheg input parameters are taken from a file named "powheg.input".
c     This programs overrides (via the command line) the settings of
c     parallelstage and xgriditeration parameters in the "powheg.input"
c     file in order to launch the different stages.
c     
      program testmpi
      include 'mpif.h'          !!!! <--- this is important for MPI !!!
      integer ierr, rank, mpisize
      character * 200 main
      character * 4 chrank
      character * 8 date 
      character * 10 time
      character * 5 zone
      integer values(8)
      integer iun
c     get name of executable from the commandline
      call get_command_argument(1,main)
      if(main == '') then
         write(*,*) ' run as: runparallel program'
         call exit(-1)
      endif
c******************************************************
c start MPI
      call mpi_init(ierr)
      call mpi_comm_size(mpi_comm_world, mpisize, ierr)
      call mpi_comm_rank(mpi_comm_world, rank, ierr)
c     processors are from 0 up to n-1; make them from 1 to n
      rank = rank+1
      write(chrank,'(bz,i4)') rank
      do j=1,4
         if(chrank(j:j)==' ') chrank(j:j)='0'
      enddo
      
      call newunit(iun)
      open(unit=iun,file='Timings.txt',status='unknown')

      call DATE_AND_TIME(date, time, zone, values)
      write(iun,12) 'Start at ',values(3),'/',values(2),'/',
     1     values(1),' ',values(5),':',values(6),':',values(7)

      call runcommand(trim(main),rank)

      call mpi_barrier(mpi_comm_world,ierr)
      
      call DATE_AND_TIME(date, time, zone, values)
      write(iun,12) 'End ',values(3),'/',values(2),'/',
     1 values(1),' ',values(5),':',values(6),':',values(7)
      close(iun)
      call mpi_finalize

 11   format(a,1x,3(i5,1x),a)
 12   format(a,2(i2.2,a),i4.4,a,3(i2.2,a))

      end
      
      subroutine runcommand(main,iwhichseed)
      implicit none
      character *(*) main
      integer, parameter :: lenline=500
      character * 500 command
      integer iwhichseed
      character * 4 chseed
      character * 100 cseconds
      integer j,seconds,initialtime
      double precision MPI_Wtime
      
      if( len(main) .gt. lenline - 100 ) then
         write(*,*) ' runcommand: command too long'
         write(*,*) ' increase lenline'
         call exit(-1)
      endif

      write(chseed,'(bz,i4)') iwhichseed
      do j=1,4
         if(chseed(j:j)==' ') chseed(j:j)='0'
      enddo

      command='echo pwgevents-'//chseed//'.lhe | '//trim(main)
     1     //' > run-pythia8-'//chseed//'.log'

      initialtime=MPI_Wtime( )

      write(*,*) trim(command)

      call system(trim(command))
         
      seconds=MPI_Wtime( )-initialtime
      write(cseconds,*) seconds
      cseconds=adjustl(cseconds)
      write(*,*) trim(command)//
     1     ' finished in '//trim(cseconds)//' seconds'

      end

      subroutine newunit(iun)
      implicit none
      integer iun 
      logical ok
      integer j
c units 97 and 99 are used for lhe files;
c keep reserved.
      do j=10,96
         inquire(unit=j,opened=ok)
         if(.not.ok) then
            iun=j
            return
         endif
      enddo
      end 
