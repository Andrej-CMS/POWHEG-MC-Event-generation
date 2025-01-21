c     The next subroutines, open some histograms and prepare them 
c     to receive data. The relevant routines are 
c     inihists    :  opens the histograms
c     filld       :  fills the histograms with data
c     pwhgaccumup :  accumulates results and clear temporary histograms
c     pwhgsetout  :  performs statistical analysis and close histograms
c     pwhgtopout  :  output the results on a .top file
c     You can substitute any of these with your favourite ones

      subroutine init_hist
      implicit none
      include 'pwhg_book.h'
      
cmv I comment the following variables, because they are not used:
c     double precision pi,pi2
c     parameter(pi = 3.141592653589793D0, pi2 = 9.869604401089358D0)
      
      integer njetcut,nmaxjetcut,currjetcut,netajetcut,currarretajetcut
      parameter(nmaxjetcut=8)
cmv commented:      
cmv      integer arrjetcut(0:nmaxjetcut-1)
cmv modified in:      
      double precision arrjetcut(0:nmaxjetcut-1)
cmv      
      double precision arretajetcut(0:nmaxjetcut-1)
      common/cjetcut/arretajetcut,arrjetcut,njetcut,netajetcut
      character *3 stretajetcut
      character *5 strjetcut
      integer currttjcut,currttcut      
      character *5 strttjcut,strttcut
      character *80 tmp_title
cmv added for added do loops:
      integer i
cmv      
      
cmv array of cuts on the pt of the extra jet:
cmv first I initialize it:
      do i=1,nmaxjetcut
         arrjetcut(i-1)=0.d0
      enddo

cmv than I fill the portion to which I am interested, using double precision
cmv numbers:
      arrjetcut(0)=30.d0
      arrjetcut(1)=50.d0
      arrjetcut(2)=60.d0
      arrjetcut(3)=70.d0
      arrjetcut(4)=80.d0
      arrjetcut(5)=90.d0
      arrjetcut(6)=100.d0
      njetcut=7

cmv array of cuts on the eta of the extra jet:
cmv first I initialize it:
      do i=1,nmaxjetcut
         arretajetcut(i-1)=0.d0
      enddo
cmv than I fill the portion to which I am interested, using double precision
cmv numbers:
      arretajetcut(0)=-1.d0
      arretajetcut(1)=2.4d0
      arretajetcut(2)=2.5d0
      netajetcut=3

cmv I initialize the histograms,
cmv the subroutine inihists does not belong to this file.      
      call inihists

c book histograms to check cross section without any cuts
      tmp_title='check:cross section without cut'
      
cmv question: why do I call here this strange subroutine and not bookupeqbins ?
cmv answer: because I want to book separately the histograms with real
cmv and virtual contributions, for various njet values....
cmv in other words, this subroutine inizialize at the same time a bunch of
cmv different histograms (with title, binsize, xmin, xmax)     
      call book_virt_real_ninitial_hist(tmp_title, 1.d0, 0.d0, 1.d0)

cmv book the histogram of dsigma/d(njet) without cuts:
      call bookupeqbins('njets_without_cut', 1.d0, 0.d0, 3.d0)

c pt of leading jet (zoom) for jet cut of 1 to check neg divergence:
      tmp_title='pt_j1_zoom_ptj1>1'
      call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,100d0)


cmv book histograms for various combinations of ptj and etaj cuts:      
      do currjetcut=0,njetcut-1
         do currarretajetcut=0,netajetcut-1
            
cmv I copy the real numbers in strings.             
cmv instead of an integer I use a real number even for the ptj:
c            write(unit=strjetcut,fmt="(i3)") arrjetcut(currjetcut)
            write(unit=strjetcut,fmt="(f5.1)") arrjetcut(currjetcut)
            write(unit=stretajetcut,fmt="(f3.1)")
     &            arretajetcut(currarretajetcut)
              
            tmp_title='crosssection_ptj1>'
     &           //strjetcut//'_eta_'//stretajetcut
cmv histogram of the cross-section for each specific ptj and etaj cut:          
            call book_virt_real_ninitial_hist(tmp_title,1.d0,0.d0,1.d0)
cmv histogram of the number of jets for each specific ptj and etaj cut:
            call bookupeqbins('njets,ptj>'//strjetcut//'_eta_'//
     &           stretajetcut,1d0,0d0,3d0)

c pt of ttbar pair for each specific ptj and etaj cut:
            tmp_title='pT_ttbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,2d0,0d0,800d0)
c invariant mass of ttbar pair for each specific ptj and etaj cut:
            tmp_title='m_ttbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,
     &           10d0,0d0,2000d0)
c y of ttbar pair for each specific ptj and etaj cut:
            tmp_title='y_ttbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c eta of ttbar pair for each specific ptj and etaj cut:
            tmp_title='eta_ttbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c ht of ttj system
            tmp_title='h_t_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,
     &           10d0,300d0,2000d0)
c pt of leading jet for each specific ptj and etaj cut:
            tmp_title='pt_j1_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,5d0,0d0,500d0)
c pt of leading jet (zoom) for each specific ptj and etaj cut:
            tmp_title='pt_j1_zoom_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,100d0)
c y of leading jet for each specific ptj and etaj cut:
            tmp_title='y_j1_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c eta of leading jet for each specific ptj and etaj cut:
            tmp_title='eta_j1_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c pt of 2nd leading jet for each specific ptj and etaj cut:
            tmp_title='pt_j2_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,5d0,0d0,500d0)
c pt of 2nd leading jet (zoom) for each specific ptj and etaj cut:
            tmp_title='pt_j2_zoom_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,100d0)
c y of 2n leading jet for each specific ptj and etaj cut:
            tmp_title='y_j2_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c eta of 2nd leading jet for each specific ptj and etaj cut:
            tmp_title='eta_j2_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c pt of ttbar+jet system for each specific ptj and etaj cut:
            tmp_title='pt_ttbarj_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,300d0)
c pt of top for each specific ptj and etaj cut:
            tmp_title='pt_t_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,500d0)
c pt of anti top for each specific ptj and etaj cut:
            tmp_title='pt_tbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,1d0,0d0,500d0)
c y of top for each specific ptj and etaj cut:
            tmp_title='y_t_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c y of anti top for each specific ptj and etaj cut:
            tmp_title='y_tbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c eta of top for each specific ptj and etaj cut:
            tmp_title='eta_t_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)
c eta of anti top for each specific ptj and etaj cut:
            tmp_title='eta_tbar_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.1d0,-6d0,6d0)

ccccccccccccccc start of rho and mttbarj hist cccccccccccccccccccccccc
c rho without additional cut, for each specific ptj and etaj cut:      
            tmp_title='rho_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title,0.005d0,0d0,1.2d0)
c mttbarj without additional cut, for each specific ptj and etaj cut:      
            tmp_title='m_ttbarj_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title, 10.d0,
     &           300.d0,2000.d0)
c mttbarj without additional cut, for each specific ptj and etaj cut and
c larger range:
            tmp_title='m_ttbarjl_ptj1>'//
     &           strjetcut//'_eta_'//stretajetcut
            call book_virt_real_ninitial_hist(tmp_title, 10.d0,
     &           325.d0,4005.d0)
!c mttbarj and rho with additional cut on pT_(ttbarj), for each specific ptj and
!c etaj cut:
!            do currttjcut=0,njetcut-1
!
!cmv I copy the real numbers in strings.
!cmv instead of an integer I use a real number even for the pt_ttj:
!cmv with this line one uses the same list of possible cuts for ptj and pt_ttj:
!c               write(unit=strttjcut,fmt="(i3)") arrjetcut(currttjcut)
!               write(unit=strttjcut,fmt="(f5.1)") arrjetcut(currttjcut)
!
!               tmp_title='rho_ptj1>'//
!     &         strjetcut//'_eta_'//stretajetcut//'_pt_ttj>'//strttjcut
!               call book_virt_real_ninitial_hist(tmp_title,
!     &              0.01d0, 0.d0, 1.d0)
!               tmp_title='m_ttbarj_ptj1>'//
!     &         strjetcut//'_eta_'//stretajetcut//'_pt_ttj>'//strttjcut
!               call book_virt_real_ninitial_hist(tmp_title,
!     &              10.d0, 300.d0, 2000.d0)
!            enddo
!
!c mttbarj and rho with additional cut on pT_(ttbar), for each specific ptj and
!c etaj cut:
!            do currttcut=0,njetcut-1
!
!cmv I copy the real numbers in strings.
!cmv instead of an integer I use a real number even for the pt_tt:
!cmv with this line one uses the same list of possible cuts for ptj and pt_tt:
!c               write(unit=strttcut,fmt="(i3)") arrjetcut(currttcut)
!               write(unit=strttcut,fmt="(f5.1)") arrjetcut(currttcut)
!
!               tmp_title='rho_ptj1>'//
!     &             strjetcut//'_eta_'//stretajetcut//'_pt_tt>'//strttcut
!               call book_virt_real_ninitial_hist(tmp_title,
!     &              0.01d0, 0.d0, 1.d0)
!               tmp_title='m_ttbarj_ptj1>'//
!     &             strjetcut//'_eta_'//stretajetcut//'_pt_tt>'//strttcut
!               call book_virt_real_ninitial_hist(tmp_title,
!     &              10.d0, 300.d0, 2000.d0)
!            enddo
!c mttbarj and rho with additional cut on m_tt (m_tt > 600 GeV), for each
!c specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_m_tt>600'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0, 0.d0, 1.d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_m_tt>600'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10.d0, 300.d0, 2000.d0)
!c mttbarj and rho with additional cut on m_tt (m_tt < 400 GeV), for each
!c specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_m_tt<400'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0, 0.d0, 1.d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_m_tt<400'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10d0,300d0,2000d0)

!ccccccccccccccccccccccccccc start threshold ccccccccccccccccccccccccc
!c threshold variables and mttbarj and rho distr. with cuts on these:
!
!cmv Definition 1:
!c z = z_tt = (m_tt)^2/s_partonic
!c z threshold variable distribution, for each specific ptj and etaj cut:
!            tmp_title='ztt_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.01d0,0d0,1d0)
!
!c mttbarj and rho with cut z > 0.9, for each specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_ztt>0.9'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0,0d0,1d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &          strjetcut//'_eta_'//stretajetcut//'_ztt>0.9'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10d0,300d0,2000d0)
!
!
!cmv Definition 2:
!c z' = z_ttj = (m_ttj)^2/s_partonic
!c z' threshold variable distribution, for each specific ptj and etaj cut:
!            tmp_title='zttj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.02d0,
!     &           -0.01d0,1.05d0)
!c zoom of the previous one:
!            tmp_title='zttjzoom_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.0001d0,
!     &           0.995d0,1.005d0)
!
!c mttbarj and rho with cut z' > 0.9, for each specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_zttj>0.9'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0,0d0,1d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_zttj>0.9'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10d0,300d0,2000d0)
!
!cmv Definition 3:
!c tau = tau_tt = (m_tt)^2/s
!c tau threshold variable distribution, for each specific ptj and etaj cut:
!            tmp_title='tautt_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.005d0,
!     &           0d0,1d0)
!c zoom of the previous one:
!            tmp_title='tauttzoom_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.0005d0,
!     &           0.d0, 0.1d0)
!c mttbarj and rho with cut tau > 0.05, for each specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_tautt>0.05'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0, 0.d0, 1.d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_tautt>0.05'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10.d0, 300.d0, 2000.d0)
!
!cmv Definition 4:
!c tau' = tau_ttj = (m_ttj)^2/s
!c tau' threshold variable distribution, for each specific ptj and etaj cut:
!            tmp_title='tauttj_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.005d0,
!     &           0.d0, 1.d0)
!c zoom of the previous one:
!            tmp_title='tauttjzoom_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.0005d0,
!     &           0.d0, 0.1d0)
!c mttbarj and rho with cut tau' > 0.05, for each specific ptj and etaj cut:
!            tmp_title='rho_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut//'_tauttj>0.05'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           0.01d0,0.d0,1.d0)
!            tmp_title='m_ttbarj_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut//'_tauttj>0.05'
!            call book_virt_real_ninitial_hist(tmp_title,
!     &           10.d0,300.d0,2000.d0)
!ccccccccccccccccccccccccccc end threshold ccccccccccccccccccccccccccc

             
!cccccccccccc start parton level initial state information ccccccccccc
!c x1 for each specific ptj and etaj cut:
!            tmp_title='x1_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.01d0,0d0,1d0)
!c x2 for each specific ptj and etaj cut:
!            tmp_title='x2_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.01d0,0d0,1d0)
!c xmax for each specific ptj and etaj cut:
!            tmp_title='xmax_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.01d0,0d0,1d0)
!c xmin for each specific ptj and etaj cut:
!            tmp_title='xmin_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,0.01d0,0d0,1d0)
!c sqrt(spartonic)=sqrt(x1 x2 S), for each specific ptj and etaj cut:
!            tmp_title='sqrt(spartonic)_ptj1>'//
!     &           strjetcut//'_eta_'//stretajetcut
!            call book_virt_real_ninitial_hist(tmp_title,50d0,
!     &           300d0,5000d0)
!cccccccccccc end parton level initial state information ccccccccccc

c close the do loop on the implemented etaj cuts:            
         enddo
c close the do loop on the implemented ptj cuts:         
      enddo

      end


      subroutine analysis(dsig)
      implicit none
      double precision dsig
      include 'hepevt.h'
      include 'PhysPars.h'
c      double precision pi
c      parameter(pi = 3.141592653589793D0)
      include 'pwhg_book.h'
      integer mu,i
      integer ihep,it,itbar
      double precision ppairttbar(4),ptttbar,mttbar,etattbar,yttbar
      double precision pttbarjet(4),mttbarjet,ptttbarjet
      double precision m0,rho,ht,ptt,pttbar,etat,yt,etatbar,ytbar

      character * 20 jetalgo
      integer maxjet
      parameter (maxjet=5)
      double precision pjet(4,maxjet)
      integer njets,nijets,tmpnjets
      double precision ktjet(maxjet),etajet(maxjet),yjet(maxjet)

      logical firstjet,secondjet
      integer itmpjet
      integer tmpnjetspj_1

      integer njetcut,nmaxjetcut,currjetcut,netajetcut,curretajetcut
      parameter(nmaxjetcut=8)
cmv commented:
c     integer arrjetcut(0:nmaxjetcut-1)
cmv modified in double precision:      
      double precision arrjetcut(0:nmaxjetcut-1)
cmv      
      double precision arretajetcut(0:nmaxjetcut-1)
      common/cjetcut/arretajetcut,arrjetcut,njetcut,netajetcut
      character *3 stretajetcut
      character *5 strjetcut

      integer currttjcut,currttcut
      character *5 strttjcut,strttcut

      double precision sparton,x1,x2,zttbar,zttbarj,tauttbar,
     & tauttbarj,xmax,xmin

cmv commented by myself (now shadron is an output of the subroutine
cmv  get_is_partoninfo):      
c get shadron from get_is_partoninfo, where it is saved in a common variable
      double precision shadron
cmv      common/cshadron/shadron

      character * 80 tmp_title


c Tag top and antitop - only final state particles (ihep.ge.3)!
      do ihep=3,nhep
         if(idhep(ihep).eq.6) then
            it=ihep
         endif
         if(idhep(ihep).eq.-6) then
            itbar=ihep
         endif
      enddo
c ordering should be fixed - check that top is ihep 3 and antitop ihep 4
      if(it.ne.3) then
         write(*,*) 'problem in finding top! ihep.ne.3'
      endif
      if(itbar.ne.4) then
         write(*,*) 'problem in finding anti-top! ihep.ne.4'
      endif


c evaluate top pair quantities:
      do mu=1,4
         ppairttbar(mu)=phep(mu,it)+phep(mu,itbar)
      enddo
      call getinvmass(ppairttbar,mttbar)
c      call getpt(ppairttbar,ptttbar)
c      call getpt(phep(1,it),ptt)
c      call getpt(phep(1,itbar),pttbar)
      call getptyeta(ppairttbar,ptttbar,yttbar,etattbar)
      call getptyeta(phep(1,it),ptt,yt,etat)
      call getptyeta(phep(1,itbar),pttbar,ytbar,etatbar)

      jetalgo="antikt"
c njets and pjet are initialized in build_jets to 0d0
      call build_jets(njets,pjet,jetalgo)
c pt_min in jet algo set to 0d0, so njets corresponds to the inital
c number of jets, with no cuts -> real emission clustered or not
      nijets=njets

c First fill histogram to check with cross section from stat.dat - no cuts
      tmp_title='check:cross section without cut'
cmv in principle njets would be the number of jets that all pass the pt
cmv and eta cuts, whereas nijets would be the number of initial jets just
cmv immediately after fastjet reconstruction. Considering that here there
cmv there are not yet pt and eta cuts, these two numbers coincide, i.e.
cmv njets=nijets      
      call fill_virt_real_ninitial_hist(tmp_title,0.5d0,dsig,njets,
     &     nijets)
      call filld('njets_without_cut',njets+0.5d0,dsig)
      if(njets.lt.1) then
         write(*,*) 'Error: no pt cut in jet algo, but njets.lt.1!'
         goto 210
      endif

cmv up to now I was not needing information on the pt and eta of the jets.
cmv now I initialize ktjet and etajet vectors which represent the pt and 
cmv eta of each jet.       
cmv important, because only njet elements get filled in getkteta!
      do i=1,maxjet
         ktjet(i)=0d0
         etajet(i)=0d0
         yjet(i)=0d0
      enddo
cmv the following subroutine takes as input njets with momenta pjet and
cmv give as output the array of pt and eta of each jet (ktjet and etajet)      
      call getktetay(njets,pjet,ktjet,etajet,yjet)
c fill pt 1st jet histogramm without eta cuts to check neg divergence
      if(ktjet(1).gt.1d0) then
         if(ktjet(2).gt.1d0) then
            tmpnjetspj_1=2
         else
            tmpnjetspj_1=1
         endif
         tmp_title='pt_j1_zoom_ptj1>1'
         call fill_virt_real_ninitial_hist(tmp_title,ktjet(1),
     &            dsig,tmpnjetspj_1,nijets)
      endif
      
cccccccc START FILLING HISTOGRAMS WITH CUTS CCCCCCCCCCCCCCCCCCCCCCCCCCCC
c loop over pt_jet cuts:
      do currjetcut=0,njetcut-1
cmv commented:         
c write(unit=strjetcut,fmt="(i3)") arrjetcut(currjetcut)
cmv use real instead:         
         write(unit=strjetcut,fmt="(f5.1)") arrjetcut(currjetcut)
cmv         
c loop over eta_jet cuts:
         do curretajetcut=0,netajetcut-1
            write(unit=stretajetcut,fmt="(f3.1)")
     &           arretajetcut(curretajetcut)
c subroutine jetcutpteta takes as input the required pt and eta cut on
c the jet and the ktjet and etajet vectors
c it returns the logicals firstjet and secondjet, which are true, when
c the jet with index 1 or 2 passed the cuts
            call jetcutpteta(firstjet,secondjet,arrjetcut(currjetcut),
     &            arretajetcut(curretajetcut),ktjet,etajet)
c if both jets passed the cut, set tmpnjets to 2, but use the first jet
c (with highest pt - ordered by build_jets) to calculate mttbarj
            if(firstjet.and.secondjet) then
               itmpjet=1
               tmpnjets=2
            elseif(firstjet.and.(.not.secondjet)) then
               itmpjet=1
               tmpnjets=1
            elseif((.not.firstjet).and.secondjet) then
c if only the second jet passed the cut, use this one to calculate
c mttbarj and set number of jets to 1.
cmv this situation is possible when the rapidity of the first jet
cmv does not pass the cuts               
               itmpjet=2
               tmpnjets=1                
            else
c if no jets found skip filling the histograms (but enter again do loop),
c maybe passes different cut because of weird ordering of cuts
               goto 230
            endif
             
c calculate ttbarjet quantities with the jet specified above (itmpjet)
             do mu=1,4
                pttbarjet(mu)=ppairttbar(mu)+pjet(mu,itmpjet)
             enddo
             call getinvmass(pttbarjet,mttbarjet)
             call getpt(pttbarjet,ptttbarjet)
             m0=170.d0
             rho=2.d0*m0/mttbarjet
             ht=sqrt(ptt**2+ph_topmass**2)+sqrt(pttbar**2+ph_topmass**2)
     &          +ktjet(itmpjet)

c fill cross section diagrams
             tmp_title='crosssection_ptj1>'
     &            //strjetcut//'_eta_'//stretajetcut
cmv tmpnjets is the number of jets of the event which
cmv ALL pass the pt and eta cuts, whereas nijets is the number of jets
cmv immediately after fastjet (i.e. before any cut)             
             call fill_virt_real_ninitial_hist(tmp_title,0.5d0,dsig,
     &            tmpnjets,nijets)
             
c fill additionaly single njets diagram - information already contained
c in the crosssection diagrams though
             tmp_title='njets,ptj>'//strjetcut//'_eta_'//stretajetcut
             call filld(tmp_title,tmpnjets+0.5d0,dsig)
             
c hist of pt of the top pair, for a fixed pt and eta cut of the first jet: 
             tmp_title='pT_ttbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ptttbar,dsig,
     &            tmpnjets,nijets)
c hist of y of the toppair, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='y_ttbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,yttbar,
     &            dsig,tmpnjets,nijets)
c hist of eta of the toppair, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='eta_ttbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,etattbar,
     &            dsig,tmpnjets,nijets)
c hist of HT, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='h_t_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ht,
     &            dsig,tmpnjets,nijets)
c hist of invariant mass of the top pair, for a fixed pt and eta cut of the
c first jet:             
             tmp_title='m_ttbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,mttbar,dsig,
     &            tmpnjets,nijets)
             
c hist of pt of the hardest jet as found after cuts -> use itmpjet, for
c a fixed pt and eta cut of the hardest jet:             
             tmp_title='pt_j1_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ktjet(itmpjet),
     &            dsig,tmpnjets,nijets)
             
cmv zoom of the previous histogram:             
             tmp_title='pt_j1_zoom_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ktjet(itmpjet),
     &            dsig,tmpnjets,nijets)
c hist of y of the leading jet, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='y_j1_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,yjet(itmpjet),
     &            dsig,tmpnjets,nijets)
c hist of eta of the leading jet, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='eta_j1_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,etajet(itmpjet)
     &            ,dsig,tmpnjets,nijets)

c hist of pt of the second hardest jet as found after cuts -> use index 2
             if(tmpnjets.gt.1) then
                 tmp_title='pt_j2_ptj1>'//
     &                strjetcut//'_eta_'//stretajetcut
                 call fill_virt_real_ninitial_hist(tmp_title,ktjet(2),
     &                dsig,tmpnjets,nijets)

cmv zoom of the previous histogram:
                 tmp_title='pt_j2_zoom_ptj1>'//
     &                strjetcut//'_eta_'//stretajetcut
                 call fill_virt_real_ninitial_hist(tmp_title,ktjet(2),
     &                dsig,tmpnjets,nijets)
c hist of y of the 2nd leading jet, for a fixed pt and eta cut
c of the hardest jet:
                 tmp_title='y_j2_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
                 call fill_virt_real_ninitial_hist(tmp_title,yjet(2),
     &            dsig,tmpnjets,nijets)
c hist of eta of the 2nd leading jet, for a fixed pt and eta cut
c of the hardest jet:
                 tmp_title='eta_j2_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
                 call fill_virt_real_ninitial_hist(tmp_title,etajet(2)
     &            ,dsig,tmpnjets,nijets)


             endif
c hist of pt of the top pair + jet system, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='pt_ttbarj_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ptttbarjet,
     &            dsig,tmpnjets,nijets)
c hist of pt of the top, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='pt_t_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ptt,
     &            dsig,tmpnjets,nijets)
c hist of pt of the antitop, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='pt_tbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,pttbar,
     &            dsig,tmpnjets,nijets)
c hist of y of the top, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='y_t_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,yt,
     &            dsig,tmpnjets,nijets)
c hist of y of the antitop, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='y_tbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,ytbar,
     &            dsig,tmpnjets,nijets)
c hist of eta of the top, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='eta_t_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,etat,
     &            dsig,tmpnjets,nijets)
c hist of eta of the antitop, for a fixed pt and eta cut
c of the hardest jet:
             tmp_title='eta_tbar_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,etatbar,
     &            dsig,tmpnjets,nijets)
             
ccccccccccccccccccc start of rho and mttbarj hist cccccccccccccccccccccccc

c rho without additional cuts, for a fixed pt and eta cut of the hardest jet:
             tmp_title='rho_ptj1>'//
     &       strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,rho,dsig,
     &            tmpnjets,nijets)

c m_ttj without additional cuts, for a fixed pt and eta cut of the
c hardest jet:   
             tmp_title='m_ttbarj_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,mttbarjet,dsig,
     &            tmpnjets,nijets)
c m_ttj without additional cuts, for a fixed pt and eta cut of the
c hardest jet with larger range in histogram:
             tmp_title='m_ttbarjl_ptj1>'//
     &            strjetcut//'_eta_'//stretajetcut
             call fill_virt_real_ninitial_hist(tmp_title,mttbarjet,dsig,
     &            tmpnjets,nijets)
!
!c mttbarj and rho with additional cut on pT_(ttbarj)
!             do currttjcut=0,njetcut-1
!cmv I copy the real numbers in strings.
!cmv instead of an integer I use a real number even for the pt_ttj:
!cmv with this line one uses the same list of possible cuts for ptj and pt_ttj:
!cmv                write(unit=strttjcut,fmt="(i3)") arrjetcut(currttjcut)
!                write(unit=strttjcut,fmt="(f5.1)") arrjetcut(currttjcut)
!cmv
!                if(ptttbarjet.ge.arrjetcut(currttjcut)) then
!                   tmp_title='rho_ptj1>'//strjetcut//'_eta_'//
!     &                  stretajetcut//'_pt_ttj>'//strttjcut
!                   call fill_virt_real_ninitial_hist(tmp_title,rho,dsig
!     &                  ,tmpnjets,nijets)
!                   tmp_title='m_ttbarj_ptj1>'//strjetcut//'_eta_'//
!     &                  stretajetcut//'_pt_ttj>'//strttjcut
!                   call fill_virt_real_ninitial_hist(tmp_title,
!     &                  mttbarjet,dsig,tmpnjets,nijets)
!                endif
!             enddo
!
!c mttbarj and rho with additional cut on pT_(ttbar):
!             do currttcut=0,njetcut-1
!cmv I copy the real numbers in strings.
!cmv instead of an integer I use a real number even for the pt_tt:
!cmv with this line one uses the same list of possible cuts for ptj and pt_tt:
!cmv                write(unit=strttcut,fmt="(i3)") arrjetcut(currttcut)
!                write(unit=strttcut,fmt="(f5.1)") arrjetcut(currttcut)
!cmv
!                if(ptttbar.ge.arrjetcut(currttcut)) then
!                   tmp_title='rho_ptj1>'//strjetcut//'_eta_'//
!     &                  stretajetcut//'_pt_tt>'//strttcut
!                   call fill_virt_real_ninitial_hist(tmp_title,rho,
!     &                  dsig,tmpnjets,nijets)
!                   tmp_title='m_ttbarj_ptj1>'//strjetcut//'_eta_'
!     &                  //stretajetcut//'_pt_tt>'//strttcut
!                   call fill_virt_real_ninitial_hist(tmp_title,
!     &                  mttbarjet,dsig,tmpnjets,nijets)
!                endif
!             enddo
!
!c mttbarj and rho with additional cut on m_tt
!cmv case m_tt > 600 GeV:
!             if(mttbar.ge.600.d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_m_tt>600'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_m_tt>600'
!                call fill_virt_real_ninitial_hist(tmp_title,mttbarjet
!     &               ,dsig,tmpnjets,nijets)
!             endif
!cmv case m_tt < 400 GeV
!             if(mttbar.le.400.d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_m_tt<400'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_m_tt<400'
!                call fill_virt_real_ninitial_hist(tmp_title,mttbarjet
!     &               ,dsig,tmpnjets,nijets)
!             endif

ccccccccccccccccccccc end of rho and mttbarj hist cccccccccccccccccccccccc
!
!ccccccccccccccccccccccccccc start threshold ccccccccccccccccccccccccc
!
!c threshold variables, followed by mttbarj and rho distr. with cuts on these
!             call get_is_partoninfo(sparton,x1,x2,shadron)
!             zttbar=(mttbar**2.d0)/sparton
!             zttbarj=(mttbarjet**2.d0)/sparton
!c             if(ini_ana) then
!c                shadron=(powheginput('ebeam1')+powheginput('ebeam2'))**2
!c                ini_ana=.false.
!c             endif
!c shadron does not have to be initialized (already done in get_is_partoninfo)
!c but make sure, that the subroutine is called before shadron is used in
!c main routine!
!             tauttbar=(mttbar**2)/shadron
!             tauttbarj=(mttbarjet**2)/shadron
!
!cmv Definition 1:
!c z = z_tt = (m_tt)^2/s_partonic
!cmv distribution of the z threshold variable, for a fixed ptj and etaj cut:
!             tmp_title='ztt_ptj1>'//strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,zttbar,dsig,
!     &            tmpnjets,nijets)
!cmv rho and m_ttj for z > 0.9:
!             if(zttbar.gt.0.9d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_ztt>0.9'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_ztt>0.9'
!                call fill_virt_real_ninitial_hist(tmp_title,mttbarjet
!     &               ,dsig,tmpnjets,nijets)
!             endif
!
!cmv Definition 2:
!c z' = z_ttj = (m_ttj)^2/s_partonic
!cmv distribution of the z' threshold variable, for a fixed ptj and etaj cut:
!             tmp_title='zttj_ptj1>'//strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,zttbarj,dsig,
!     &            tmpnjets,nijets)
!cmv zoom of the previous one:
!             tmp_title='zttjzoom_ptj1>'//strjetcut//
!     &            '_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,zttbarj,dsig,
!     &            tmpnjets,nijets)
!cmv rho and m_ttj for z' > 0.9:
!             if(zttbarj.gt.0.9d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_zttj>0.9'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_zttj>0.9'
!                call fill_virt_real_ninitial_hist(tmp_title,mttbarjet
!     &               ,dsig,tmpnjets,nijets)
!             endif
!
!cmv Definition 3:
!c tau = tau_tt = (m_tt)^2/s
!cmv distribution of the tau threshold variable, for a fixed ptj and etaj cut:
!             tmp_title='tautt_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,tauttbar,dsig,
!     &            tmpnjets,nijets)
!cmv zoom of the previous one:
!             tmp_title='tauttzoom_ptj1>'//
!     &                 strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,tauttbar,
!     &            dsig,tmpnjets,nijets)
!cmv rho and m_ttj for tau > 0.05:
!             if(tauttbar.gt.0.05d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_tautt>0.05'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_tautt>0.05'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               mttbarjet,dsig,tmpnjets,nijets)
!             endif
!
!cmv Definition 4:
!c tau' = tau_ttj = (m_ttj)^2/s
!cmv distribution of the tau' threshold variable, for a fixed ptj and etaj cut:
!             tmp_title='tauttj_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,tauttbarj,
!     &            dsig,tmpnjets,nijets)
!cmv zoom of the previous one:
!             tmp_title='tauttjzoom_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,tauttbarj,
!     &            dsig,tmpnjets,nijets)
!cmv rho and m_ttj for tau' > 0.05:
!             if(tauttbarj.gt.0.05d0) then
!                tmp_title='rho_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_tauttj>0.05'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               rho,dsig,tmpnjets,nijets)
!                tmp_title='m_ttbarj_ptj1>'//
!     &               strjetcut//'_eta_'//stretajetcut//'_tauttj>0.05'
!                call fill_virt_real_ninitial_hist(tmp_title,
!     &               mttbarjet,dsig,tmpnjets,nijets)
!             endif
!ccccccccccccccccccccccccccc end threshold ccccccccccccccccccccccccc
             
!ccccccccccccccccccc start parton level initial state information ccccccccccc
!c x1 for a given cut of pt and eta of the hardest jet:
!             tmp_title='x1_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,x1,dsig,
!     &            tmpnjets,nijets)
!c x2 for a given cut of pt and eta of the hardest jet:
!             tmp_title='x2_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,x2,dsig,
!     &            tmpnjets,nijets)
!c determine xmax and xmin:
!             if(x1.ge.x2) then
!                xmax=x1
!                xmin=x2
!             else
!                xmax=x2
!                xmin=x1
!             endif
!c xmax for a given cut of pt and eta of the hardest jet:
!             tmp_title='xmax_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,xmax,dsig,
!     &            tmpnjets,nijets)
!c xmin for a given cut of pt and eta of the hardest jet:
!             tmp_title='xmin_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,xmin,dsig,
!     &            tmpnjets,nijets)
!c sqrt(spartonic) for a given cut of pt and eta of the hardest jet:
!             tmp_title='sqrt(spartonic)_ptj1>'//
!     &            strjetcut//'_eta_'//stretajetcut
!             call fill_virt_real_ninitial_hist(tmp_title,dsqrt(sparton),
!     &            dsig,tmpnjets,nijets)
!
!ccccccccccccccccccc end parton level initial state information ccccccccccc
             
 230         continue
cmv close the loop on curretajetcut (i.e. the cuts on eta):             
          enddo
cmv close the loop on currjetcut (i.e. the cuts on pt):             
       enddo

 210   continue
       end


ccccccccc subroutine to see if jets pass pt and eta cuts ccccccccccccc
      subroutine jetcutpteta(firstjet,secondjet,ptjetcut,etajetcut,
     &  ktjet,etajet)
cmv input: ptjetcut, etajetcut: cuts that one wants to fullfill
cmv input: ktjet, etajet: array of all the jets of the event
cmv output: firstjet, secondjet says if the two jets are passing the cuts
cmv         or not      
      implicit none
      logical firstjet,secondjet
cmv commented:
c     integer ptjetcut
cmv changed in real:      
      double precision ptjetcut
cmv      
      double precision etajetcut
      integer maxjet
      parameter(maxjet=5)
      double precision ktjet(maxjet),etajet(maxjet)

cmv initialization:
      firstjet=.false.
      secondjet=.false.
      
c cuts: ptj>ptjetcut and abs(etaj)<etajetcut      
c firstjet set to true if it survives pt and eta-cut and
c secondjet set to true if it survives pt and eta-cut
      if(etajetcut.gt.0) then
          if(ktjet(1).gt.ptjetcut) then
             if(dabs(etajet(1)).lt.etajetcut) firstjet=.true.
          endif

          if(ktjet(2).gt.ptjetcut) then
             if(dabs(etajet(2)).lt.etajetcut) secondjet=.true.
          endif
      else
c if eta cut smaller then 0 -> don't apply cut!
          if(ktjet(1).gt.ptjetcut) then
             firstjet=.true.
          endif
          if(ktjet(2).gt.ptjetcut) then
             secondjet=.true.
          endif
      endif
      
      end

      

      subroutine book_virt_real_ninitial_hist(prefix_histtitle,bsz,xmin,
     &     xmax)
cmv this subroutine books a bunch of different histograms
cmv (the real component, the virtual component, etc.) at the same time:      
cmv input: title, binsize, xmin and xmax for all the histograms      
      implicit none
      character *80 prefix_histtitle
      double precision bsz,xmin,xmax
      include 'pwhg_book.h'
      character *80 hist_title

cmv I book histograms for different cases of njet:
      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &  '_nj>=1'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)
      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     & '_nj=1'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)
      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &  '_nj=2'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)

cmv in case of njet=1, I further subdivide in four categories
cmv (one category is the sum of two, so it is enough three categories,
cmv  but one can keep 4) :      
cmv virtual:      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &     '_nj=1_nhp=5'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)
cmv real, but at the end I only have one jet:      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &     '_nj=1_nhp=6'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)
cmv this is the sum of the following two:      
cmv real, at the end I have one jet, because the two particles ended up in
cmv the same jet:      
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &     '_nj=1_nji=1_nhp=6'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)
cmv real, at the end I have one jet, because the second jet does not pass
cmv pt and eta cuts:       
      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
     &       '_nj=1_nji=2_nhp=6'))
      call bookupeqbins(hist_title,bsz,xmin,xmax)

cmv in case on njet=2, I have necessarily nhp=6.....so is this
cmv here just for a cross-check ????      
c      hist_title=trim(adjustl(trim(adjustl(prefix_histtitle))//
c     &     '_nj=2_nhp=6'))
c      call bookupeqbins(hist_title,bsz,xmin,xmax)
      
      end

      
      subroutine fill_virt_real_ninitial_hist(hist_title,x,y,ntmpjets,
     &     ninitialjets)
cmv this subroutine fills a bunch of different histograms
cmv (the real component, the virtual component, etc.) at the same time:      
cmv input: title, x and y for the histogram,
cmv number of jets that pass the cuts, number of jets reconstructed by
cmv fastjet (before applying cuts)      
      implicit none
      character *80 hist_title
      double precision x,y
      integer ntmpjets,ninitialjets
      include 'pwhg_book.h'
      include 'hepevt.h'
      character *80 tmp_title

cmv njet after cuts >=1:      
      tmp_title=trim(adjustl(trim(adjustl(hist_title))//'_nj>=1'))
      call filld(tmp_title,x,y)

cmv here splitted in two parts:      
cmv njet after cuts = 1:      
      if(ntmpjets.eq.1) then
         tmp_title=trim(adjustl(trim(adjustl(hist_title))//'_nj=1'))
         call filld(tmp_title,x,y)
cmv njet after cuts = 2:         
      elseif(ntmpjets.eq.2) then
         tmp_title=trim(adjustl(trim(adjustl(hist_title))//'_nj=2'))
         call filld(tmp_title,x,y)
      endif



cmv the procedure in this routine should closely follow
cmv the procedure used to book these histograms       
      if ((nhep.eq.5).and.ntmpjets.eq.1) then
         tmp_title=trim(adjustl(trim(adjustl(hist_title))//
     &        '_nj=1_nhp=5'))
         call filld(tmp_title,x,y)
      elseif ((nhep.eq.5).and.((ntmpjets.gt.1).or.(ninitialjets.gt.1)))
     &                              then
         write(*,*) 'Error: in Born/virtual should be only one jet!'
         write(*,'(A,I2)') 'instead ntmpjets.eq.', ntmpjets
         write(*,'(A,I2)') 'instead ninitialjets.eq.', ninitialjets
         write(*,'(A,I2)') 'while nhep.eq.', nhep
         call exit(1)
               
cmv commented and substituted by what is above, that I think is better
c      if(nhep.eq.5) then
c         if(ntmpjets.eq.1) then
c            tmp_title=trim(adjustl(trim(adjustl(hist_title))//
c     &       '_nj=1_nhp=5'))
c            call filld(tmp_title,x,y)
cmv in nhep=1 there should be included even the case where njet=0.....
cmv (supposing the jet is there but does not pass the cuts), so I do
cmv not understand why here below you consider an error the case ntmpjets=0     
c         else
c            write(*,*) 'Error: in Born/virtual should be only one jet!'
c            write(*,'(A,I2)') 'instead ntmpjets.eq.', ntmpjets
c            write(*,'(A,I2)') 'instead ninitialjets.eq.', ninitialjets
c            write(*,'(A,I2)') 'while nhep.eq.', nhep
c            call exit(1)
c            
c         endif
         
c         if(ninitialjets.gt.1) then
c            write(*,*) 'Error: in B/V should be only one initial jet!'
c            call exit(1)
c         endif
         
      elseif(nhep.eq.6) then
         
         if(ntmpjets.eq.1) then
cmv real, but at the end I only have one jet:
            tmp_title=trim(adjustl(trim(adjustl(hist_title))//
     &           '_nj=1_nhp=6'))
            call filld(tmp_title,x,y)
cmv this is the sum of the following two:            
            if(ninitialjets.eq.1) then
cmv real, at the end I have one jet, because the two particles ended up in
cmv the same jet:      
               tmp_title=trim(adjustl(trim(adjustl(hist_title))//
     &              '_nj=1_nji=1_nhp=6'))
               call filld(tmp_title,x,y)
            elseif(ninitialjets.eq.2) then
cmv real, at the end I have one jet, because the second jet does not pass
cmv pt and eta cuts:              
               tmp_title=trim(adjustl(trim(adjustl(hist_title))//
     &              '_nj=1_nji=2_nhp=6'))
               call filld(tmp_title,x,y)
            else
               write(*,*) 'Error in ninitaljet, for real.neq.1 or 2'
               call exit(1)
            endif
cmv in case of njet after cuts =2, I have necessarily nhep=6......so
cmv is this here just for a cross-check ?            
         elseif(ntmpjets.eq.2) then
c            tmp_title=trim(adjustl(trim(adjustl(hist_title))//
c     &           '_nj=2_nhp=6'))
c            call filld(tmp_title,x,y)
            if(ninitialjets.lt.2) then
               write(*,*) 'Error in ninitaljet,for nj=2 .ne.2'
               call exit(1)
            endif
         endif
      endif

cmv modified:      
      if (nhep.lt.5.or.nhep.gt.6) then
         write(*,*) 'Error: nhep neither 5 or 6'
         call exit(1)
      endif
cmv      
      end





CCCCCCCCCC  Ancillary routines CCCCCCCCCCCCCCCCCCCCCCCCCCCC

      
      subroutine build_jets(njets,pj,process)
c     arrays to reconstruct jets
      implicit none
      include 'hepevt.h'
      integer njets
      character * 20 process
      integer maxjet,maxtrack
      parameter (maxjet=5,maxtrack=6)
c      double precision pjet(4,maxjet)
      double precision ptrack(4,maxtrack),pj(4,maxjet)
      double precision R_jet,ptmin_jet
      common/cjetdefs/R_jet,ptmin_jet
      integer jetvec(maxtrack),itrackhep(maxtrack)
      integer ihep,ntracks,jpart,jjet,mu
      logical ini
      data ini/.true./
      save ini
      real(8), external :: powheginput
      double precision tmp_pt1,tmp_pt2

c     get valid tracks
c     get arrays for jet finding
      
cmv initialize arrays for storing info on tracks and jets:
      do jpart=1,maxtrack
         do mu=1,4
            ptrack(mu,jpart)=0d0
         enddo
cmv jetvec says me in which jet the particle jpart ends up         
         jetvec(jpart)=0
      enddo      
      do jjet=1,maxjet
         do mu=1,4
c            pjet(mu,jjet)=0d0
            pj(mu,jjet)=0d0
         enddo
      enddo      

      
c     loop over final state particles to find jets 
      ntracks=0
      njets=0
      do ihep=1,nhep
         if((isthep(ihep).eq.1).and.
c     exclude leptons, gauge and higgs bosons and top quarks.... 
     1        (((abs(idhep(ihep)).lt.6).or.(abs(idhep(ihep)).ge.40))
c     ..... but include gluons
     2        .or.(abs(idhep(ihep)).eq.21))) then
             if (ntracks.eq.maxtrack) then
               write(*,*) 'Too many particles. Increase maxtrack.'//
     $               ' PROGRAM ABORTS'
                call exit(1)
             endif
c     copy momenta to construct jets: 
             ntracks=ntracks+1
             do mu=1,4
                ptrack(mu,ntracks)=phep(mu,ihep)
             enddo
             itrackhep(ntracks)=ihep
         endif
      enddo

c check that Born/virtual has 1 track and real has 2 tracks
      if(nhep.eq.5) then
         if(ntracks.ne.1) then
            write(*,*) 'Error: nhep=5, but ntracks!=1'
            call exit(1)
         endif
      elseif(nhep.eq.6) then
         if(ntracks.ne.2) then
            write(*,*) 'Error: nhep=6, but ntracks!=2'
            call exit(1)
         endif
      else
         write(*,*) 'nhep neither 5 or 6 in build_jets!'
         call exit(1)
      endif

c should never happen - error would also get caught in check above
cmv I think this is here for t-tbar events virtual (that do not have
cmv an extra jet), i.e. just for pp--> ttbar
cmv      and not for the process pp --> ttbarj      
      if (ntracks.eq.0) then
         njets=0
         write(*,*) 'ntracks.eq.0'
         return
      endif
     
c when entering for the first time initialize jet-algo parameters
c R parameter read from powheginput
c ptmin_jet set manually to 0d0
      if(ini) then
          R_jet=powheginput('R_jet')
!                ptmin_jet=powheginput('ptmin_jet')
c     changed to min pt 0, so to count the total number of clustered jets
          ptmin_jet=0d0
      endif

!      write(*,*) 'ptrack before fastjet'
!      write(*,*) (ptrack(1,i), i=1,maxtrack)
!      write(*,*) (ptrack(2,i), i=1,maxtrack)
!      write(*,*) (ptrack(3,i), i=1,maxtrack)
!      write(*,*) (ptrack(4,i), i=1,maxtrack)
!
!      write(*,*) 'pj before fastjet'
!      write(*,*) (pj(1,i), i=1,maxjet)
!      write(*,*) (pj(2,i), i=1,maxjet)
!      write(*,*) (pj(3,i), i=1,maxjet)
!      write(*,*) (pj(4,i), i=1,maxjet)

      if (process.eq."antikt") then
         if (ini) then
cmv some of the following lines were too long for fortran, I had to
cmv cut them a bit:            
            write(*,*) '***********************************************'
            write(*,*) '***********************************************'
            write(*,*) '                JET PARAMETERS                 '
            write(*,*) '***********************************************'
            write(*,*) '***********************************************'
            write(*,*) '   inclusive anti-kt (FASTJET implementation): '
            write(*,*) '      jet radius ',  R_jet
            write(*,*) '      jet ptmin ',   ptmin_jet
            write(*,*) '***********************************************'
            write(*,*) '***********************************************'
!            if((R_jet.le.0d0).or.(ptmin_jet.le.0d0)) then
            if((R_jet.le.0d0)) then
               write(*,*) 
               write(*,*) '********************************************'
               write(*,*) '********************************************'
               write(*,*) ' ERROR: JET ALGORITHM NOT CORRECTLY DEFINED '
               write(*,*) ' BOTH R_JET AND PTMIN_JET MUST BE POSITIVE  '
               write(*,*) '********************************************'
               write(*,*) '********************************************'
               call exit(-1)
            endif
            ini=.false.
         endif
c FastJet wrapper is contained in the the file fastjet_wrap.cpp in the
c same directory of libvirtual
c not anymore => routine called in ttbarj folder: fastjetfortan.cc
         call fastjet_kt(ptrack,ntracks,ptmin_jet,R_jet,
cmv QUESTION: njets here should be instead a double-precision variable ????         
     $        -1d0,0,0,0,njets,pj,jetvec)

      else if (process.eq."kt") then
         if (ini) then
cmv some of the following lines were too long for fortran, I had to
cmv cut them a bit                        
            write(*,*) '**********************************************'
            write(*,*) '**********************************************'
            write(*,*) '                JET PARAMETERS                '
            write(*,*) '**********************************************'
            write(*,*) '**********************************************'
            write(*,*) '   inclusive kt (FASTJET implementation): '
            write(*,*) '      jet radius ',  R_jet
            write(*,*) '      jet ptmin ',   ptmin_jet
            write(*,*) '**********************************************'
            write(*,*) '**********************************************'
c            if((R_jet.le.0d0).or.(ptmin_jet.le.0d0)) then
            if((R_jet.le.0d0)) then
               write(*,*)
               write(*,*) '********************************************'
               write(*,*) '********************************************'
               write(*,*) ' ERROR: JET ALGORITHM NOT CORRECTLY DEFINED '
               write(*,*) ' BOTH R_JET AND PTMIN_JET MUST BE POSITIVE  '
               write(*,*) '********************************************'
               write(*,*) '********************************************'
               call exit(-1)
            endif
            ini=.false.
         endif
c header: FASTJET_KT(P,NPART,JETCUT,R,PALG,RECO,CLUSTER,SORT,F77JETS,NJETS,F77JETVEC)
c//   DOUBLE PRECISION P(4,*), JETCUT, R, PALG, RECO,F77JETS(4,*) INTEGER
c//   NPART, NJETS,F77JETVEC(*)
c//   INTEGER CLUSTER,SORT
c PALG = (1.0=kt, 0.0=C/A,  -1.0 = anti-kt)
c RECO = (0=E 1=pt 2=pt2 3=Et 4=Et2)
!CLUSTER     the jet clustering algo
!//               (0=Inclusive JETCUT=ptmin
!//                1=Exclusive JETCUT=dcut
!//                2=Exclusive requiring just NJETS)
!//   SORT        the sorting strategy (0=pt 1=E 2=y)
c mix up in comments, order of arguments:
c position of njets not as in (commented) declaration above
!  void fastjet_kt_(const double * p, const int & npart,
!                   const double & jetcut, const double & R,
!                   const double & Palg, const int & Reco,
!                   const int & Cluster, const int & Sort,
!                   int & njets, double * f77jets,int * f77jetvec) {
!    fastjet_kt(p,npart,jetcut,R,Palg,Reco,Cluster,Sort,njets,f77jets,f77jetvec)


cmv this is the call for fastjet kt case (non antikt):         
         call fastjet_kt(ptrack,ntracks,ptmin_jet,R_jet,
     $        1d0,0,0,0,njets,pj,jetvec)
      else
         write(*,*) 'JET ANALYSIS TO USE UNKNOWN:',process
         call exit(1)
      endif
!      if(ntracks.eq.2.and.njets.eq.1) then
!          write(*,*) 'ptrack after fastjet'
!          write(*,*) (ptrack(1,i), i=1,maxtrack)
!          write(*,*) (ptrack(2,i), i=1,maxtrack)
!          write(*,*) (ptrack(3,i), i=1,maxtrack)
!          write(*,*) (ptrack(4,i), i=1,maxtrack)
!
!          write(*,*) 'pj after fastjet'
!          write(*,*) (pj(1,i), i=1,maxjet)
!          write(*,*) (pj(2,i), i=1,maxjet)
!          write(*,*) (pj(3,i), i=1,maxjet)
!          write(*,*) (pj(4,i), i=1,maxjet)
!
!          write(*,*) 'maxtrack=',maxtrack,' maxjet=',maxjet
!      endif

c      write(*,"(A,I2)") 'check: njets=', njets
c      if(nhep.eq.6) then
c         if(njets.eq.1) then
c            write(*,*) 'nhep=6 and njets=1'
c         endif
c      endif

c check that the pt ordering of FastJet worked (SORT=0)
cmv (the check can be performed only if I have at least two jets):      
c      if (njets.ge.2) then
      tmp_pt1=dsqrt(pj(1,1)**2+pj(2,1)**2)
      tmp_pt2=dsqrt(pj(1,2)**2+pj(2,2)**2)
      if(tmp_pt1.lt.tmp_pt2) then
         write(*,*) 'Error in jet ordering!'
         call exit(1)
      endif
c      endif
         
      end

cccccccccc
      
cmv commented:      
cmv      subroutine get_is_partoninfo(sparton,x1,x2)
cmv changed in:      
      subroutine get_is_partoninfo(sparton,x1,x2,shadron)
cmv      
cmv input of this subroutine: phep that is passed through the common block
cmv included in hepevt.h      
cmv output of this subroutine: partonic s, x1, x2 and hadronic s. 
cmv      
      implicit none
      include 'hepevt.h'
      double precision sparton,x1,x2
      double precision p1energy,p2energy,hadronmass
      double precision h1pz,h2pz,shadron
      common/chadronpz/h1pz,h2pz
cmv commented because now shadron is an argument of the subroutine:      
cmv      common/cshadron/shadron
      real(8), external :: powheginput
      double precision diff,eps
      logical ini
      data ini/.true./
      save ini

      if(ini) then
          p1energy=powheginput('ebeam1')
          p2energy=powheginput('ebeam2')
c if both are protons set the proton mass
          if((powheginput('ih1').eq.1).and.
     &     (powheginput('ih2').eq.1)) then
             hadronmass=0.93827208d0
          else
             write(*,*) 'error: only knows proton mass'
             call exit(1)
          endif
          h1pz=dsqrt(p1energy**2-hadronmass**2)
          h2pz=dsqrt(p2energy**2-hadronmass**2)

          shadron=(powheginput('ebeam1')+powheginput('ebeam2'))**2
          ini=.false.
      endif

c p(4) is energy, p(3) pz
      if ((isthep(1).eq.-1).and.(isthep(2).eq.-1)) then
c (E1+E2)^2 - (pz1 + pz2)^2, because px = py =0  for initial state partons
         sparton=(phep(4,1)+phep(4,2))**2-(phep(3,1)+phep(3,2))**2
      else
         write(*,*) 'error: IS partons not ordered as expected!'
         call exit(1)
      endif

c momentum fraction x is pz(parton)/pz(hadron)
      x1=dabs(phep(3,1))/dabs(h1pz)
      x2=dabs(phep(3,2))/dabs(h2pz)

cmv added further checks:
      if (x1.lt.0.d0) then
         write (*,*) 'error: x1 negative,   x1=',x1
         call exit(1)
      endif    
      if (x2.lt.0.d0) then
         write (*,*) 'error: x2 negative,   x2=',x2
         call exit(1)
      endif
      if ((x1-1.d0).ge.1.d-4) then
         write (*,*) 'error: x1 > 1,   x1=',x1
c         call exit(1)
      endif    
      if ((x2-1.d0).ge.1.d-4) then
         write (*,*) 'error: x2 > 1,   x2=',x2
c         call exit(1)
      endif    
cmv      
      
      diff=x1*x2*shadron-sparton
      eps=500d0
      if(diff.gt.eps) then
         write(*,*) 'Error: x1 x2 s != sparton'
         write(*,'(A, e24.17)') 'x1 x2 s: ',x1*x2*shadron
         write(*,'(A, e24.17)') 'sparton: ',sparton
         write(*,'(A, e24.17)') 's: ',shadron
         write(*,'(A, e24.17)') 'sqrt(sparton): ',dsqrt(sparton)
         write(*,'(A, e24.17)') 'sqrt(x1 x2 s): ',dsqrt(x1*x2*shadron)
         write(*,'(A, e24.17)') 'sqrt(s): ',dsqrt(shadron)
         write(*,'(A, e24.17)') 'x1: ',x1
         write(*,'(A, e24.17)') 'x2: ',x2
      endif

c      write(*,'(A, e24.17)') 'sparton: ', sparton
c      write(*,'(A, e24.17)') 'sqrt(sparton): ', sqrt(sparton)
      
      end


      
      subroutine getinvmass(p,m)
cmv input: p
cmv output: m      
      implicit none
      double precision p(4),m
      double precision m2
cmv      m2 = p(4)**2-p(1)**2-p(2)**2-p(3)**2
      m2 = p(4)*p(4)-p(1)*p(1)-p(2)*p(2)-p(3)*p(3)
      
c      if (m2.ge.0d0) then
c         m = dsqrt(abs(m2))
c      else
c         m = -dsqrt(abs(m2))
c      endif
c modified by garzellli and voss (15.02.21)
      m = dsqrt(abs(m2))
      end


      
      subroutine getpt(p,pt)
cmv input: p
cmv output: pt      
      implicit none
      double precision p(4),pt
      pt=dsqrt(p(1)*p(1)+p(2)*p(2))
      end

      subroutine getptyeta(p,pt,y,eta)
      implicit none
      double precision p(4),pt,y,eta
      double precision pp,tiny
      parameter (tiny=1d-12)
      pt=dsqrt(p(1)**2+p(2)**2)
      y=log((p(4)+p(3))/(p(4)-p(3)))/2.d0
      pp=dsqrt(pt**2+p(3)**2)*(1+tiny)
      eta=log((pp+p(3))/(pp-p(3)))/2.d0
      end


      subroutine getktetay(njets,pjet,ktjet,etajet,yjet)
cmv input: njets and pjet
cmv output: ktjet and etajet
      implicit none
      integer njets,j
cmv ATTENTION: if ktjet and etajet in the main are defined to have
cmv maxjet components, here you should use the same dimensionality.       
cmv commented:
c      double precision pjet(4,njets),ktjet(njets),etajet(njets)
cmv changed in:
      integer nmaxjet
      parameter (nmaxjet=5)
      double precision pjet(4,nmaxjet),ktjet(nmaxjet),etajet(nmaxjet),
     &                 yjet(nmaxjet)
cmv      
      double precision pp,tiny
      parameter (tiny=1d-12)
      
      do j=1,njets
cmv transverse momentum of the jet:         
         ktjet(j)=dsqrt(pjet(1,j)**2+pjet(2,j)**2)
c rapidity of the jet:
         yjet(j)=0.5d0*log((pjet(4,j)+pjet(3,j))/(pjet(4,j)-pjet(3,j)))
         
cmv question: I am a bit surprised of this quantity here below....:         
         pp=dsqrt(pjet(1,j)**2+pjet(2,j)**2+pjet(3,j)**2)*(1+tiny)
cmv is this energy of jet ? Why do not you use instead pp=pjet(4,j) ??
         
cmv pseudorapidity of the jet:         
cmv         etajet(j)=log((pp+pjet(3,j))/(pp-pjet(3,j)))/2
         etajet(j)=dlog((pp+pjet(3,j))/(pp-pjet(3,j)))/2.d0
         
      enddo
      end



!      subroutine ptyetaphi(p,pt,y,eta,phi)
!      implicit none
!      double precision p(4),pt,y,eta,phi
!      double precision pp,tiny
!      parameter (tiny=1d-12)
!      pt=dsqrt(p(1)**2+p(2)**2)
!      y=log((p(4)+p(3))/(p(4)-p(3)))/2
!      pp=dsqrt(pt**2+p(3)**2)*(1+tiny)
!      eta=log((pp+p(3))/(pp-p(3)))/2
!      phi=atan2(p(2),p(1))
!      end

!      subroutine getrapidity(p,y)
!      implicit none
!      double precision p(4),y
!      y=0.5d0*log((p(4)+p(3))/(p(4)-p(3)))
!      end
!
!      function getrapidity0(p)
!      implicit none
!      double precision p(0:3),getrapidity0
!      getrapidity0=0.5d0*log((p(0)+p(3))/(p(0)-p(3)))
!      end




!      subroutine getktyphieta(njets,pjet,ktjet,yjet,phijet,etajet)
!      implicit none
!      integer njets,j
!      double precision pjet(4,njets),ktjet(njets),yjet(njets)
!     $     ,phijet(njets),etajet(njets)
!      double precision pp,tiny
!      parameter (tiny=1d-12)
!      do j=1,njets
!         ktjet(j)=dsqrt(pjet(1,j)**2+pjet(2,j)**2)
!         yjet(j)=0.5d0*log((pjet(4,j)+pjet(3,j))/(pjet(4,j)-pjet(3,j)))
!         phijet(j)=atan2(pjet(2,j),pjet(1,j))
!         pp=dsqrt(ktjet(j)**2+pjet(3,j)**2)*(1+tiny)
!         etajet(j)=log((pp+pjet(3,j))/(pp-pjet(3,j)))/2
!      enddo
!      end


!      subroutine getktyphi(njets,pjet,ktjet,yjet,phijet)
!      implicit none
!      integer njets,j
!      double precision pjet(4,njets),ktjet(njets),yjet(njets)
!     $     ,phijet(njets)
!      do j=1,njets
!         ktjet(j)=dsqrt(pjet(1,j)**2+pjet(2,j)**2)
!         yjet(j)=0.5d0*log((pjet(4,j)+pjet(3,j))/(pjet(4,j)-pjet(3,j)))
!         phijet(j)=atan2(pjet(2,j),pjet(1,j))
!      enddo
!      end

cccccccccccccccccccccccccc only own routines cccccccccccccccccccccccccccccccc

!      subroutine setkincommonparamzero
!      implicit none
!      integer i,j
!      double precision phit,phitbar
!      double precision ptt,yt,etat,pttbar,ytbar,etatbar,
!     $     ptttbar,mttbar,yttbar,phittbar,etattbar
!      common/kinttbar/ptttbar,mttbar,yttbar,phittbar,etattbar
!      common/kint/ptt,yt,etat,phit
!      common/kintbar/pttbar,ytbar,etatbar,phitbar
!
!      double precision mttbarjet,ptttbarjet
!      common/kinttbarjet/mttbarjet,ptttbarjet
!
!      integer maxjet
!      parameter (maxjet=5)
!      integer njets
!      double precision ktjet(maxjet),yjet(maxjet),phijet(maxjet),
!     &  etajet(maxjet)
!      common/kinjets/ktjet,yjet,phijet,etajet,njets
!
!      integer maxtrack
!      parameter(maxtrack=2)
!      double precision partonpt(maxtrack),partony(maxtrack),
!     &  partoneta(maxtrack),partonphi(maxtrack),ptp1p2
!      common/kinparton/partonpt,partony,partoneta,partonphi,ptp1p2
!
!      double precision pjcomm(4,2)
!      common/cjetpvec/pjcomm
!
!      do i=1,2
!         do j=1,4
!            pjcomm(j,i)=0d0
!         enddo
!      enddo
!
!      ptttbar=0d0
!      mttbar=0d0
!      yttbar=0d0
!      phittbar=0d0
!      etattbar=0d0
!
!      ptt=0d0
!      yt=0d0
!      etat=0d0
!      phit=0d0
!
!      pttbar=0d0
!      ytbar=0d0
!      etatbar=0d0
!      phitbar=0d0
!
!!      mttbarjet=0d0
!!      ptttbarjet=0d0
!
!      do i=1,maxjet
!         ktjet(i)=0d0
!         yjet(i)=0d0
!         phijet(i)=0d0
!         etajet(i)=0d0
!      enddo
!      njets=0
!
!
!      do i=1,maxtrack
!         partonpt(i)=0d0
!         partony(i)=0d0
!         partoneta(i)=0d0
!         partonphi(i)=0d0
!      enddo
!      ptp1p2=0d0
!
!      end

      
cccccccccccccccc not used anymore cccccccccccccccccccccccccccccccccccc

!      subroutine bookttbarhist(strjetcut,stretajetcut)
!      implicit none
!      character * 3 strjetcut,stretajetcut
!c invariant mass of ttbar pair
!      call book_virt_real_ninitial_hist('m_ttbar_ptj1>'//strjetcut//
!     &   '_eta_'//stretajetcut,10d0,0d0,1000d0)
!c rapidity of ttbar pair
!      call book_virt_real_ninitial_hist('y_ttbar_ptj1>'//strjetcut//
!     &    '_eta_'//stretajetcut,0.2d0,-4d0,4d0)
!c pt of ttbar pair
!      call book_virt_real_ninitial_hist('pT_ttbar_ptj1>'//strjetcut//
!     &     '_eta_'//stretajetcut,2d0,0d0,800d0)
!c pt of the pair (zoom)
!      call book_virt_real_ninitial_hist('pT_ttbar_zoom_ptj1>'//
!     &     strjetcut//'_eta_'//stretajetcut,0.5d0,0d0,100d0)
!      end
!
!      subroutine booktandtbarhist(strjetcut,stretajetcut)
!      implicit none
!      character * 3 strjetcut,stretajetcut
!c pt of top
!      call book_virt_real_ninitial_hist('pt_t ptj1>'//strjetcut//
!     &  '_eta_'//stretajetcut,5d0,0d0,500d0)
!c pt of antitop
!      call book_virt_real_ninitial_hist('pt_tbar ptj1>'//
!     &  strjetcut//'_eta_'//stretajetcut,5d0,0d0,500d0)
!c top rapidity
!      call book_virt_real_ninitial_hist('y_t ptj1>'//strjetcut//
!     &  '_eta_'//stretajetcut,0.2d0,-4d0,4d0)
!c antitop rapidity
!      call book_virt_real_ninitial_hist('y_tbar ptj1>'//strjetcut//
!     & '_eta_'//stretajetcut,0.2d0,-4d0,4d0)
!      end
!
!      subroutine bookfirstjethist(strjetcut,stretajetcut)
!      implicit none
!      character * 3 strjetcut,stretajetcut
!c pt of leading jet
!      call book_virt_real_ninitial_hist('pt_j1 ptj1>'//strjetcut//
!     &     '_eta_'//stretajetcut,5d0,0d0,500d0)
!c pt of leading jet (zoom)
!      call book_virt_real_ninitial_hist('pt_j1 zoom ptj1>'//strjetcut//
!     &        '_eta_'//stretajetcut,1d0,0d0,100d0)
!c rapidity of leading jet
!      call book_virt_real_ninitial_hist('y_j1, ptj1>'//strjetcut//
!     &     '_eta_'//stretajetcut,0.2d0,-4d0,4d0)
!      end
!
!      subroutine booksecondjethist(strjetcut,stretajetcut)
!      implicit none
!      include 'pwhg_book.h'
!      character * 3 strjetcut,strj2jetcut,stretajetcut
!      integer njetcut,nmaxjetcut,j2jetcut
!      parameter(nmaxjetcut=8)
!      integer arrjetcut(0:nmaxjetcut-1)
!      common/cjetcut/njetcut,arrjetcut
!c pt of 2nd jet
!      call bookupeqbins('pt_j2 ptj1>'//strjetcut,
!     &     5d0,0d0,500d0)
!c pt of 2nd jet (zoom)
!      call bookupeqbins('pt_j2 zoom ptj1>'//strjetcut,
!     &        1d0,0d0,100d0)
!c pt of 2nd jet (zoom) with eta cut
!      call bookupeqbins('pt_j2 zoom ptj1>'//strjetcut//'_eta_'//
!     &        stretajetcut,1d0,0d0,100d0)
!c rapidity of 2nd jet
!      call bookupeqbins('y_j2, ptj1>'//strjetcut,0.2d0,-4d0,4d0)
!c rapidity of 2nd jet with cuts on pt_j2
!      do j2jetcut=0,njetcut-1
!         write(unit=strj2jetcut,fmt="(i3)") arrjetcut(j2jetcut)
!         call bookupeqbins('y_j2, ptj1>'//strjetcut//'ptj2>'//
!     &    strj2jetcut,0.2d0,-4d0,4d0)
!      enddo
!      end
!
!
!      subroutine bookrhohist(strjetcut,stretajetcut)
!      implicit none
!      character * 3 strjetcut,stretajetcut
!c rho distribution
!      call book_virt_real_ninitial_hist('rho, ptj1>'//strjetcut//
!     &  '_eta_'//stretajetcut,0.05d0,0d0,1d0)
!c rho distribution with smaller binning
!      call book_virt_real_ninitial_hist('rho zoom,ptj1>'//strjetcut//
!     &  '_eta_'//stretajetcut,0.01d0,0d0,1d0)
!c invariant mass of ttbar+jet system
!      call book_virt_real_ninitial_hist('m_ttbarj,ptj1>'//strjetcut//
!     &  '_eta_'//stretajetcut,10d0,300d0,2000d0)
!c pt of ttbar+jet system
!      call book_virt_real_ninitial_hist('pt_ttbarj,ptj1>'//strjetcut//
!     &     '_eta_'//stretajetcut,1d0,0d0,300d0)
!      end
!
!
!
!

!      subroutine fillttbarhist(strjetcut,dsig)
!      implicit none
!      character * 3 strjetcut
!      double precision dsig
!      include 'pwhg_book.h'
!      double precision ptttbar,mttbar,yttbar,phittbar,etattbar
!      common/kinttbar/ptttbar,mttbar,yttbar,phittbar,etattbar
!c invariant mass of ttbar pair
!      call filld('m_ttbar,ptj1>'//strjetcut,mttbar,dsig)
!      call fill_virt_real_ninitial_hist('m_ttbar_ptj1>'//strjetcut//
!     &   '_eta_'//stretajetcut,mttbar,dsig,ntmpjets)
!c rapidity of ttbar pair
!      call filld('y_ttbar ptj1>'//strjetcut,yttbar,dsig)
!c pt of ttbar pair
!      call filld('pT_ttbar ptj1>'//strjetcut,ptttbar,dsig)
!c pt of the pair (zoom)
!      call filld('pT_ttbar zoom ptj1>'//strjetcut,ptttbar,dsig)
!      end
!
!      subroutine filltandtbarhist(strjetcut,dsig)
!      implicit none
!      character * 3 strjetcut
!      double precision dsig
!      include 'pwhg_book.h'
!      double precision phit,phitbar
!      double precision ptt,yt,etat,pttbar,ytbar,etatbar
!      common/kint/ptt,yt,etat,phit
!      common/kintbar/pttbar,ytbar,etatbar,phitbar
!c pt of top
!      call filld('pt_t ptj1>'//strjetcut,ptt,dsig)
!c pt of antitop
!      call filld('pt_tbar ptj1>'//strjetcut,pttbar,dsig)
!c top rapidity
!      call filld('y_t ptj1>'//strjetcut,yt,dsig)
!c antitop rapidity
!      call filld('y_tbar ptj1>'//strjetcut,ytbar,dsig)
!      end
!
!      subroutine fillfirstjethist(strjetcut,dsig)
!      implicit none
!      character * 3 strjetcut
!      double precision dsig
!      include 'pwhg_book.h'
!      integer maxjet
!      parameter (maxjet=5)
!      double precision ktjet(maxjet),yjet(maxjet),phijet(maxjet),
!     &   etajet(maxjet)
!      integer njets
!      common/kinjets/ktjet,yjet,phijet,etajet,njets
!c pt of leading jet
!      call filld('pt_j1 ptj1>'//strjetcut,ktjet(1),dsig)
!c pt of leading jet (zoom)
!      call filld('pt_j1 zoom ptj1>'//strjetcut,ktjet(1),dsig)
!c rapidity of leading jet
!      call filld('y_j1, ptj1>'//strjetcut,yjet(1),dsig)
!      end
!
!      subroutine fillsecondjethist(strjetcut,dsig)
!      implicit none
!      character * 3 strjetcut
!      double precision dsig
!      include 'pwhg_book.h'
!      integer maxjet
!      parameter (maxjet=5)
!      double precision ktjet(maxjet),yjet(maxjet),phijet(maxjet),
!     & etajet(maxjet)
!      integer njets
!      common/kinjets/ktjet,yjet,phijet,etajet,njets
!      character * 3 strj2jetcut
!      integer nmaxjetcut,j2jetcut
!      parameter(nmaxjetcut=8)
!      integer njetcut,arrjetcut(0:nmaxjetcut-1)
!      common/cjetcut/njetcut,arrjetcut
!c pt of 2nd jet
!      call filld('pt_j2 ptj1>'//strjetcut,ktjet(2),dsig)
!c pt of 2nd jet (zoom)
!      call filld('pt_j2 zoom ptj1>'//strjetcut,ktjet(2),dsig)
!c rapidity of 2nd jet
!      call filld('y_j2, ptj1>'//strjetcut,yjet(2),dsig)
!c rapidity of 2nd jet with cuts on pt_j2
!      do j2jetcut=0,njetcut-1
!         if(ktjet(2).ge.arrjetcut(j2jetcut)) then
!            write(unit=strj2jetcut,fmt="(i3)") arrjetcut(j2jetcut)
!            call filld('y_j2, ptj1>'//strjetcut//'ptj2>'//strj2jetcut,
!     &       yjet(2),dsig)
!         endif
!      enddo
!      end
!
!      subroutine fillrhohist(strjetcut,dsig)
!      implicit none
!      character * 3 strjetcut
!      double precision dsig
!      include 'pwhg_book.h'
!      double precision mttbarjet,ptttbarjet
!      common/kinttbarjet/mttbarjet,ptttbarjet
!      double precision rho,m0
!      m0= 170d0
!      rho=2d0*m0/mttbarjet
!c rho distribution
!      call filld('rho, ptj1>'//strjetcut,rho,dsig)
!c rho distribution with smaller binning
!      call filld('rho zoom,ptj1>'//strjetcut,rho,dsig)
!c invariant mass of ttbar+jet system
!      call filld('m_ttbarj,ptj1>'//strjetcut,mttbarjet,dsig)
!c pt of ttbar+jet system
!      call filld('pt_ttbarj,ptj1>'//strjetcut,ptttbarjet,dsig)
!      end

!     subroutine getmjjinfo(mjj)
!      implicit none
!      double precision mjj
!      double precision pjcomm(4,2)
!      common/cjetpvec/pjcomm
!      integer mu
!      double precision psum(4)
!
!      do mu=1,4
!         psum(mu)=pjcomm(mu,1)+pjcomm(mu,2)
!      enddo
!      mjj=dsqrt(psum(4)**2-psum(1)**2-psum(2)**2-psum(3)**2)
!      end
!
!      subroutine getmjinfo(mj,firstjet,secondjet)
!      implicit none
!      double precision mj
!      logical firstjet,secondjet
!      double precision pjcomm(4,2)
!      common/cjetpvec/pjcomm
!      integer jet
!      if(firstjet) then
!         jet=1
!      else if(secondjet) then
!         jet=2
!      else
!         write(*,*) 'Error: entered in getmjinfo but no jet true'
!         call exit(1)
!      endif
!      if(firstjet.and.secondjet) then
!         write(*,*) 'Error: entered in getmjinfo but both jet true'
!         call exit(1)
!      endif
!      mj=dsqrt(pjcomm(4,jet)**2-pjcomm(1,jet)**2-pjcomm(2,jet)**2
!     &   -pjcomm(3,jet)**2)
!      end
!
!      subroutine get_gm_ttbarjinfo(mttbarjet,ptttbarjet,firstjet,
!     &  secondjet)
!      implicit none
!      double precision mttbarjet,ptttbarjet
!      logical firstjet,secondjet
!      include 'hepevt.h'
!      double precision pjcomm(4,2)
!      common/cjetpvec/pjcomm
!      integer ijet,mu,it,itbar,ihep
!      double precision pttbarjet(4)
!
!      do ihep=3,nhep
!         if(idhep(ihep).eq.6) then
!            it=ihep
!         endif
!         if(idhep(ihep).eq.-6) then
!            itbar=ihep
!         endif
!      enddo
!
!      if(firstjet) then
!         ijet=1
!      else if(secondjet) then
!         ijet=2
!      endif
!c shouldn't be needed, but to make sure
!      if(firstjet.and.secondjet) then
!         ijet=1
!      endif
!
!      do mu=1,4
!         pttbarjet(mu)=pjcomm(mu,ijet)+phep(mu,it)+phep(mu,itbar)
!      enddo
!
!      call getinvmass(pttbarjet,mttbarjet)
!      call getpt(pttbarjet,ptttbarjet)
!      end

