        ! STEP 3: Update urhs using ddz(tau13) and wrhs using ddx(tau13)
        call this%spectC%fft(tau13,tauhat)
        call transpose_y_to_z(tauhat,this%ctmpCz,this%sp_gp)
        !if (this%useWallModel) call this%moengWall%updateTAU_i3(this%ctmpCz,this%UmeanAtWall,uhat)
        
        call this%Ops2ndOrder%ddz_C2C(this%ctmpCz,this%ctmpCz2,.false.,.false.)
        call transpose_z_to_y(this%ctmpCz2,tauhat,this%sp_gp)
        urhs = urhs - tauhat
        

        call this%Ops2ndOrder%InterpZ_Cell2Edge(this%ctmpCz,this%ctmpEz,zeroC,zeroC)
        call transpose_z_to_y(this%ctmpEz,this%ctmpEy,this%sp_gpE)
        call this%spectE%mtimes_ik1_ip(this%ctmpEy)
        
        wrhs = wrhs - this%ctmpEy
        !print*, wrhs(40,32,59), this%ctmpEy(40,32,59)
       

        ! STEP 4: Update vrhs using ddz(tau23) and wrhs using ddy(tau23)
        call this%spectC%fft(tau23,tauhat)
        call transpose_y_to_z(tauhat,this%ctmpCz,this%sp_gp)
        !if (this%useWallModel) call this%moengWall%updateTAU_i3(this%ctmpCz,this%UmeanAtWall,vhat)
    
        call this%Ops2ndOrder%ddz_C2C(this%ctmpCz,this%ctmpCz2,.false.,.false.)
        call transpose_z_to_y(this%ctmpCz2,tauhat,this%sp_gp)
        vrhs = vrhs - tauhat

        call this%Ops2ndOrder%InterpZ_Cell2Edge(this%ctmpCz,this%ctmpEz,zeroC,zeroC)
        call transpose_z_to_y(this%ctmpEz,this%ctmpEy,this%sp_gpE)
        call this%spectE%mtimes_ik2_ip(this%ctmpEy)
        wrhs = wrhs - this%ctmpEy
        !print*, wrhs(40,32,59), this%ctmpEy(40,32,59)


        ! STEP 5: Update urhs using ddy(tau12) and vrhs using ddx(tau12)
        call this%spectC%fft(tau12,tauhat)
        call this%spectC%mtimes_ik2_oop(tauhat,tauhat2)
        urhs = urhs - tauhat2
        call this%spectC%mtimes_ik1_ip(tauhat)
        vrhs = vrhs - tauhat

        ! STEP 6: Update urhs using ddx(tau11)
        call this%spectC%fft(tau11,tauhat)
        call this%spectC%mtimes_ik1_ip(tauhat)
        urhs = urhs - tauhat


        ! STEP 7: Update vrhs using ddy(tau22)
        call this%spectC%fft(tau22,tauhat)
        call this%spectC%mtimes_ik2_ip(tauhat)
        vrhs = vrhs - tauhat


        ! STEP 8: Update wrhs using ddz(wrhs)
        call this%spectC%fft(tau33,tauhat)
        call transpose_y_to_z(tauhat,this%ctmpCz,this%sp_gp)
        call this%Ops2ndOrder%ddz_C2E(this%ctmpCz,this%ctmpEz,.true.,.true.)
        call transpose_z_to_y(this%ctmpEz,this%ctmpEy,this%sp_gpE)
        wrhs = wrhs - this%ctmpEy

        !print*, wrhs(40,32,59), this%ctmpEy(40,32,59)
