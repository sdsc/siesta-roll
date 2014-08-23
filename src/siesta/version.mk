ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

NAME               = siesta_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 3.2.4
RELEASE            = 1
RPM.EXTRAS         = AutoReq:No

SRC_SUBDIR         = siesta

SOURCE_NAME        = siesta
SOURCE_VERSION     = 3.2.4
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)
