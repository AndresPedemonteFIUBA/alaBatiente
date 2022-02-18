### Change these if you built SPOOLES, ARPACK, or yaml-cpp from source ###
# SPOOLES include flags (e.g. -I$(HOME)/SPOOLES.2.2 )
SPOOLES_INCLUDE   = -I/usr/include/spooles/
# SPOOLES library flags (e.g. $(HOME)/SPOOLES.2.2/spooles.a)
SPOOLES_LIBS      = -lspooles
#
# ARPACK include flags (e.g. -I$(HOME)/ARPACK)
ARPACK_INCLUDE    =
# ARPACK library flags (e.g. $(HOME)/ARPACK/libarpack_INTEL.a)
ARPACK_LIBS       = -larpack -llapack -lblas

INCLUDES = \
	-I./ \
	$(SPOOLES_INCLUDE) \
	$(ARPACK_INCLUDE)

CFLAGS = -Wall -O2  $(INCLUDES) -DARCH="Linux" -DSPOOLES -DARPACK -DMATRIXSTORAGE -DNETWORKOUT
FFLAGS = -Wall -O2 

CC=cc
FC=gfortran

.c.o :
	$(CC) $(CFLAGS) -c $<
.f.o :
	$(FC) $(FFLAGS) -c $<

include Makefile.inc

SCCXMAIN = ccx_2.16.c

OCCXF = $(SCCXF:.f=.o)
OCCXC = $(SCCXC:.c=.o)
OCCXMAIN = $(SCCXMAIN:.c=.o)


LIBS = \
	$(SPOOLES_LIBS) \
	$(ARPACK_LIBS) \
	-lpthread -lm -lc

ccx_2.16: $(OCCXMAIN) ccx_2.16.a  $(LIBS)
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.16.c; $(FC)  -Wall -O2 -o $@ $(OCCXMAIN) ccx_2.16.a $(LIBS)

ccx_2.16.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?
