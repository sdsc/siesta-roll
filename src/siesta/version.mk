NAME               = siesta_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 3.2.pl.4
RELEASE            = 0
PKGROOT            = /opt/siesta
RPM.EXTRAS         = AutoReq:No

SRC_SUBDIR         = siesta

SOURCE_NAME        = siesta
SOURCE_VERSION     = 3.2-pl-4
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)
