ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

NAME           = siesta_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 3.2.4
RELEASE        = 1
PKGROOT        = /opt/siesta

SRC_SUBDIR     = siesta

SOURCE_NAME    = siesta
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = 3.2.4
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS       = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
