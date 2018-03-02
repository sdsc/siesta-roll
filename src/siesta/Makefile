# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

$(NAME).spec: DESCRIPTION LICENSE

AVX_FLAG=
ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx2
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xcore-avx2
  endif
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xavx
  endif
endif

ifneq (,$(findstring mvapich,$(MPINAME)))
  INTELMPITYPE=intelmpi
else
  INTELMPITYPE=openmpi
endif


DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_HDF5); \
	  $(DESCRIBE_NETCDF) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo siesta > $@

build: $(SRC_DIRS)
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	mkdir dist
	patch $(SOURCE_DIR)/Src/arch.make.in patch-files/arch.make.in.patch
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_HDF5); \
	  $(MODULE_LOAD_NETCDF); \
          cd $(SOURCE_DIR); \
          mkdir build; \
          cd build; \
          export FC=`which mpif90`; \
          export FPPFLAGS="-I$${NETCDFHOME}/include"; \
          export FCFLAGS="-O3 $(AVX_FLAG) -fcheck=all"; \
          export LDFLAGS="-g -L$${MKLLIB} -L$${HDF5HOME}/lib -L$${NETCDFHOME}/lib -lhdf5 -lnetcdff -lnetcdf -lmkl_rt -lmkl_scalapack_lp64 -lmkl_blacs_$(INTELMPITYPE)_lp64"; \
          ../Src/configure --prefix=$(ROOT)/$(PKGROOT) --enable-mpi --enable-fast --enable-mpi-libs \
             --with-netcdf=-lnetcdf --with-blas=-lmkl_rt --with-lapack=-lmkl_rt \
             --with-blacs=-lmkl_blacs_openmpi_lp64 --with-scalapack=-lmkl_scalapack_lp64; \
          cp arch.make ../Obj; \
          cd ../Obj; \
	  sh ../Src/obj_setup.sh; \
	  $(MAKE); \
          cp siesta $(PWD)/dist; \
          make clean; \
          make transiesta; \
          cp transiesta $(PWD)/dist; \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	cp dist/* $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE_DIR)/Tests $(ROOT)/$(PKGROOT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE dist
