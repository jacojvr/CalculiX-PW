
CFLAGS = -Wall -O3 -fopenmp -I ../spooles.2.2 -DARCH="Linux" -DSPOOLES -DARPACK -DMATRIXSTORAGE -DNETWORKOUT -DEXODUSII -DUSE_MT=1 
FFLAGS = -Wall -O3 -fopenmp 

CC=cc
FC=gfortran

.c.o :
	$(CC) $(CFLAGS) -c $<
.f.o :
	$(FC) $(FFLAGS) -c $<

include Makefile.inc

SCCXMAIN = ccx_2.12.c

OCCXF = $(SCCXF:.f=.o)
OCCXC = $(SCCXC:.c=.o)
OCCXMAIN = $(SCCXMAIN:.c=.o)

DIR=../spooles.2.2

LIBS = \
       $(DIR)/MT/src/spoolesMT.a \
       $(DIR)/spooles.a \
	../ARPACK/libarpack_linux.a \
       -lpthread -lm -lc -lexoIIv2c -lnetcdf

ccx_2.12_MT: $(OCCXMAIN) ccx_2.12_MT.a  $(LIBS)
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.12.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.12_MT.a $(LIBS)

ccx_2.12_MT.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?
                                                                               
