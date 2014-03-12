# Sailfish OS

OSNAME = Sailfish

INSTALLDIR = /usr
IMAGEDIR = $(INSTALLDIR)/share/%APPLICATION_NAME%/icons
APPIMAGEDIR = $(IMAGEDIR)

ZLSHARED = no

CC = gcc
AR = ar rsu
LD = g++
MOC = moc -DQT5 -DSAILFISH
DEPGEN = $(CC) -MM
RM_QUIET = rm -rf
RM = rm -rvf
CFLAGS += -DSAILFISH -DQT5
CFLAGS += -DQT_DISABLE_DEPRECATED_BEFORE=4
CFLAGS += -pipe -fno-exceptions -Wall -Wno-ctor-dtor-privacy -W -DLIBICONV_PLUG -fPIC
LDFLAGS += -pie
QTINCLUDE = -I/usr/include/qt5 -I/usr/include/qt5/QtCore -I/usr/include/qt5/QtQuick -I/usr/include/qt5/QtQml -I/usr/include/qt5/QtGui -I/usr/include/qt5/QtNetwork #-I/usr/include/qt5/QtScript
UILIBS = -lQt5Core -lQt5Quick -lQt5Qml -lQt5Gui -lQt5Network -lsailfishapp

ifeq "$(UNAME_MACHINE)" ""
UNAME_MACHINE=armv7hl
endif

EXTERNAL_LIBS += -L$(ROOTDIR)/libs/sailfish/$(UNAME_MACHINE)/lib
