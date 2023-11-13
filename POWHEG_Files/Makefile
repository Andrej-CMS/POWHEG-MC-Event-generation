#-*- Makefile -*-
## Default intel compiler suite make COMPILER=gnu for gfortran/g++
ifndef COMPILER
COMPILER=gnu
endif
## Choose PDF: native,lhapdf
## LHAPDF package has to be installed separately
PDF=lhapdf
#Choose Analysis: none,  antikt, ttbarj
## default analysis may require FASTJET package, that has to be installed separately (see below)
ANALYSIS=ttbarj
#
#
ifeq ("$(COMPILER)","gnu")
FC = gfortran
F77 = $(FC) -fno-automatic -ffixed-line-length-132
CXX = g++
CC = gcc
## -fbounds-check sometimes causes a weird error due to non-lazy evaluation
## of boolean in gfortran.
FFLAGS= -fbounds-check -Wall #-Wimplicit-procedure
## For floating point exception trapping  uncomment the following
# FPE=-ffpe-trap=invalid,zero,overflow
## gfortran 4.4.1 optimized with -O3 yields erroneous results
## Use -O2 to be on the safe side
OPT=-O2
## For debugging uncomment the following
#DEBUG= -ggdb #-pg
##
endif

ifeq ("$(COMPILER)","intel")
FC = ifort
F77 = $(FC) -save -assume bscc -extend_source
CXX = icpc
CC = icc
LIBS = -limf
FFLAGS =  -check #-warn all -module obj-$(COMPILER)/mod
## For floating point exception trapping  uncomment the following
#FPE = -fpe0
OPT = -O3 #-fast
## For debugging uncomment the following
#DEBUG= -debug -g
#PP=-fpp #-DHELAS_CHECK
endif

#Path to the OpenLoops installation (examples provided below)
OLPATH=$(PWD)/../OpenLoops
# OLPATH=/home/gavardi/fortran/OpenLoops2
# OLPATH=/home/gavardi/fortran/OpenLoops2_test/OpenLoops
#OLPATH=/home/alioli/work/OpenLoops-public_beta

#Required OL libraries
OLLIBS=ppttj ppttj_dec

OBJ=obj-$(COMPILER)
OBJDIR:=$(OBJ)

PWD=$(shell pwd)
WDNAME=$(shell basename $(PWD))
VPATH= ./:../:$(OBJDIR):

INCLUDE0=$(PWD)
INCLUDE1=$(shell dirname $(PWD))/include
FF=$(F77) $(FFLAGS) $(FPE) $(OPT) $(DEBUG) -I$(INCLUDE0) -I$(INCLUDE1) -J$(OBJ)


INCLUDE =$(wildcard ../include/*.h *.h include/*.h)

ifeq ("$(PDF)","lhapdf")
LHAPDF_CONFIG=/storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/LHAPDF-6.5.3/installDir/bin/lhapdf-config
PDFPACK=lhapdf6if.o lhapdf6ifcc.o
LIBSLHAPDF= -Wl,-rpath,$(shell $(LHAPDF_CONFIG) --libdir)  -L$(shell $(LHAPDF_CONFIG) --libdir)  -lLHAPDF
## If LHAPDF has been compiled with gfortran and you want to link it statically, you have to include
## libgfortran as well. The same holds for libstdc++.
## One possible solution is to use fastjet, since $(shell $(FASTJET_CONFIG) --libs --plugins ) -lstdc++
## does perform this inclusion. The path has to be set by the user.
# LIBGFORTRANPATH=/usr/lib/gcc/x86_64-redhat-linux/4.1.2
# LIBSTDCPP=/usr/lib/gcc/x86_64-redhat-linux/4.1.1
# LIBSLHAPDF+=  -L$(LIBGFORTRANPATH)  -lgfortranbegin -lgfortran -L$(LIBSTDCPP) -lstdc++
LIBS+=$(LIBSLHAPDF)
CXXFLAGS+=$(shell $(LHAPDF_CONFIG) --cxxflags)
else
PDFPACK=mlmpdfif.o hvqpdfpho.o
endif


# PYTHIA 8
PYTHIA8LOCATION=/usr/
CXXFLAGS+=-I$(PYTHIA8LOCATION)/include -I$(PYTHIA8LOCATION)/include/Pythia8 -I$(PYTHIA8LOCATION)/include/Pythia8Plugins
LIBPYTHIA8=-L$(PYTHIA8LOCATION)/lib64/ -lpythia8  -lstdc++ #-llhapdfdummy
LIBHEPMC=-L/usr/lib64 -lHepMC



ifeq ("$(ANALYSIS)","antikt")
##To include Fastjet configuration uncomment the following lines.
FASTJET_CONFIG=$(shell which fastjet-config)
LIBSFASTJET += $(shell $(FASTJET_CONFIG) --libs --plugins )
CXXFLAGS+= $(shell $(FASTJET_CONFIG) --cxxflags)
PWHGANAL=pwhg_bookhist-multi-new.o multi_plot.o pwhg_analysis-antikt.o
PWHGANAL+= fastjetfortran.o
else ifeq ("$(ANALYSIS)","ttbarj")
	FASTJET_CONFIG=$(shell which fastjet-config)
	LIBSFASTJET += $(shell $(FASTJET_CONFIG) --libs --plugins )
	CXXFLAGS+= $(shell $(FASTJET_CONFIG) --cxxflags)
	PWHGANAL=pwhg_bookhist-multi-new.o multi_plot.o pwhg_analysis_LO_NLO_ttj.o fastjetfortran.o
else
PWHGANAL=pwhg_bookhist-multi-new.o pwhg_analysis_LO_NLO_ttj.o
endif

LIBS+=$(LIBSFASTJET) -lstdc++

all: pwhg_main
openloops.o: compile_openloops
init_coupling.o: compile_openloops
virtual.o: compile_openloops
ttjdecay.o: compile_openloops

%.o: %.f $(INCLUDE) | $(OBJDIR)
	$(FF) -c -o $(OBJ)/$@ $<

%.o: %.f90 $(INCLUDE) | $(OBJDIR)
	$(FF) -c -o $(OBJ)/$@ $<

%.o: %.c | $(OBJDIR)
	$(CC) $(DEBUG) -c -o $(OBJ)/$@ $^

%.o: %.cc | $(OBJDIR)
	$(CXX) $(DEBUG) -c -o $(OBJ)/$@ $^ $(CXXFLAGS)

LIBS+=-lz
USER=init_couplings.o init_processes.o Born_phsp.o Born.o virtual.o \
        real.o  Check_LesHouches.o $(PWHGANAL)

ifdef OLPATH
FF+= -I$(OLPATH)/lib_src/openloops/mod
LIBSOPENLOOPS= -Wl,-rpath=$(PWD)/$(OBJDIR) -L$(PWD)/$(OBJDIR) -lopenloops
USER+=openloops.o
endif




PWHG=pwhg_main.o pwhg_init.o bbinit.o btilde.o lhefwrite.o		\
	LesHouches.o LesHouchesreg.o gen_Born_phsp.o find_regions.o	\
	test_Sudakov.o pt2maxreg.o sigborn.o gen_real_phsp.o maxrat.o	\
	gen_index.o gen_radiation.o Bornzerodamp.o sigremnants.o	\
	random.o boostrot.o lhefroutines.o bra_ket_subroutines.o	\
	cernroutines.o init_phys.o powheginput.o pdfcalls.o sigreal.o	\
	sigcollremn.o pwhg_analysis_driver.o checkmomzero.o		\
	setstrongcoupl.o integrator.o newunit.o mwarn.o sigsoftvirt.o	\
	sigcollsoft.o sigvirtual.o reshufflemoms.o pwhgreweight.o	\
	opencount.o ubprojections.o minlo_checks.o setlocalscales.o	\
	validflav.o mint_upb.o $(PDFPACK) $(USER) $(FPEOBJ)		\
	lhefread.o pwhg_io_interface.o rwl_weightlists.o		\
	rwl_setup_param_weights.o ttjdecay.o

# target to generate LHEF output
pwhg_main:compile_openloops $(PWHG) $(LIBDHELAS)
	$(FF) $(patsubst %,$(OBJ)/%,$(PWHG)) $(LIBS) $(LIBSOPENLOOPS) $(LIBSFASTJET) $(STATIC) -o $@-$(COMPILER)

LHEF=lhef_analysis.o boostrot.o random.o cernroutines.o opencount.o \
	powheginput.o lhefread.o pwhg_io_interface.o newunit.o	    \
	rwl_weightlists.o $(PWHGANAL) $(FPEOBJ) zlibdummy.o	    \
	printleshouches.o

# target to analyze LHEF output
lhef_analysis:$(LHEF)
	$(FF) $(patsubst %.o,$(OBJ)/%.o,$(LHEF)) $(LIBS) -o $@-$(COMPILER)


# target to read event file, shower events with HERWIG + analysis
HERWIG=main-HERWIG.o herwig.o boostrot.o powheginput.o newunit.o	\
       $(PWHGANAL) lhefread.o pdfdummies.o pwhg_io_interface.o		\
       cernroutines.o opencount.o printleshouches.o rwl_weightlists.o	\
       zlibdummy.o

HERWIG_DRIVER_NOUE= setup-HERWIG-lhef.o

main-HERWIG-lhef: $(HERWIG) $(HERWIG_DRIVER_NOUE)
	$(FF) $(patsubst %,$(OBJ)/%, $(HERWIG) $(HERWIG_DRIVER_NOUE))  $(LIBSFASTJET)  -o $@-$(COMPILER)

HERWIG_DRIVER_UE= setup-HERWIG-UE-lhef.o

main-HERWIG-UE-lhef: $(HERWIG) $(HERWIG_DRIVER_UE)
	$(FF) $(patsubst %,$(OBJ)/%, $(HERWIG) $(HERWIG_DRIVER_UE))  $(LIBSFASTJET)  -o $@-$(COMPILER)


# target to read event file, shower events with PYTHIA + analysis
PYTHIA=main-PYTHIA.o pythia.o boostrot.o powheginput.o newunit.o	\
       $(PWHGANAL) lhefread.o pdfdummies.o pwhg_io_interface.o		\
       cernroutines.o opencount.o printleshouches.o rwl_weightlists.o	\
       zlibdummy.o

PYTHIA_DRIVER_NOMPI=setup-PYTHIA-lhef.o

main-PYTHIA-lhef: $(PYTHIA) $(PYTHIA_DRIVER_NOMPI)
	$(FF) $(patsubst %,obj-$(COMPILER)/%, $(PYTHIA) $(PYTHIA_DRIVER_NOMPI))  $(LIBSFASTJET)  -o $@-$(COMPILER)

PYTHIA_DRIVER_MPI=setup-PYTHIA-MPI-lhef.o

main-PYTHIA-MPI-lhef: $(PYTHIA) $(PYTHIA_DRIVER_MPI)
	$(FF) $(patsubst %,obj-$(COMPILER)/%, $(PYTHIA) $(PYTHIA_DRIVER_MPI))  $(LIBSFASTJET)  -o $@-$(COMPILER)


# target to read event file, shower events with PYTHIA8.1 + analysis
PYTHIA8=main-PYTHIA8.o boostrot.o powheginput.o $(PWHGANAL)		\
        opencount.o lhefread.o rwl_weightlists.o newunit.o		\
        reshufflemoms.o pdfdummies.o random.o cernroutines.o		\
        bra_ket_subroutines.o utils.o pwhg_io_interface.o $(FPEOBJ)	\
        zlibdummy.o

main-PYTHIA8-lhef: $(PYTHIA8) pythia8F77.o
	$(FF) $(patsubst %,$(OBJ)/%,$(PYTHIA8) pythia8F77.o ) $(LIBSFASTJET) $(LIBPYTHIA8) $(LIBHEPMC) $(STATIC) $(LIBS) -o $@-$(COMPILER)


force_look :
	true

# build OpenLoops: calls scons
#ifdef OLPATH
#compile_openloops:
#	@echo "Compiling OpenLoops..." ; cd $(OLPATH) ;  ./compile ;  echo "...done."
#endif

# build OpenLoops core : calls scons
compile_openloops:
ifdef OLPATH
ifdef OLLIBS
	@if [ -d "$(OLPATH)" ]; then \
	echo "Compiling OpenLoops..." ; cd $(OLPATH) ; \
  ./scons generic_lib_dir=$(PWD)/$(OBJ)/ compile_libraries=cuttools,collier link_libraries=cuttools,collier fortran_compiler=$(FC)\
  process_src_dir=$(PWD)/OL_process_src \
  process_obj_dir=$(PWD)/$(OBJ)/OL_process_obj \
  process_lib_dir=$(PWD)/$(OBJ)/proclib ; \
	./openloops libinstall $(OLLIBS) generator=0 compile_extra=1 fortran_compiler=$(FC) \
	generic_lib_dir=$(PWD)/$(OBJ)/ compile_libraries=cuttools,collier link_libraries=cuttools,collier \
  process_src_dir=$(PWD)/OL_process_src \
  process_obj_dir=$(PWD)/$(OBJ)/OL_process_obj \
  process_lib_dir=$(PWD)/$(OBJ)/proclib ; \
  echo "...done."; \
	else \
	echo "ERROR: OpenLoops not available for POWHEG. Please download!" ;\
    exit 1; \
	fi
else
	@echo "ERROR compiling OpenLoops: OLLIBS not specified!" ;
	exit 1
endif
else
	@echo "ERROR compiling OpenLoops: OLPATH not specified!" ;
	exit 1
endif


clean:
	rm -f $(patsubst %,$(OBJ)/%,$(USER) $(PWHG) $(LHEF) $(HERWIG) $(PYTHIA) $(PYTHIA8) pythia8?F77.o) \
        pwhg_main-$(COMPILER) lhef_analysis-$(COMPILER) main-HERWIG-lhef-$(COMPILER) main-PYTHIA*-lhef-$(COMPILER) svn.version

veryclean: clean
	rm -f $(OBJ)/*.o $(OBJ)/*.mod $(OBJ)/*.a $(OBJ)/*.so *.a \
	rm -rf OL_process_obj $(OBJ)/OL_process_obj $(OBJ)/proclib
	cd $(OLPATH) ; ./scons -c clean=src

# target to generate object directory if it does not exist
$(OBJDIR):
	mkdir -p $(OBJDIR)
