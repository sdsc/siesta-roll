NAME        = siesta-modules
RELEASE     = 1
PKGROOT     = /opt/modulefiles/applications/siesta

VERSION_SRC = $(REDHAT.ROOT)/src/siesta/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
