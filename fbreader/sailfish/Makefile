ROOTDIR = $(CURDIR)/../..
include $(ROOTDIR)/makefiles/config.mk

DBUSDIR = /usr/share/dbus-1/services
MENUDIR = /etc/others-menu

FBREADER_NAME = harbour-fbreader
DESKTOP_FILE = $(FBREADER_NAME).desktop
SERVICE_FILE = $(FBREADER_NAME).service
BACKUP_CONF = $(FBREADER_NAME).backup

DESKTOP_DIR = ""
KEYMAP_FILE = "keymap.sailfish.xml"

LIBFRIBIDI = fribidi-0.19.6
LIBLINEBREAK = liblinebreak-2.0
make_libfribidi:
	cd ../../libs/sailfish/$(LIBFRIBIDI) && make distclean && ./configure --enable-static && make && make install prefix=/ DESTDIR=$(ROOTDIR)/libs/sailfish/$(UNAME_MACHINE)/ && cd $(CURDIR)

make_liblinebreak:
	cd ../../libs/sailfish/$(LIBLINEBREAK) && make distclean && ./configure --enable-static && make && make install prefix=/ DESTDIR=$(ROOTDIR)/libs/sailfish/$(UNAME_MACHINE)/ && cd $(CURDIR)

make_libs: make_libfribidi make_liblinebreak

install_libs:
	@install -d $(DESTDIR)/usr
	cp -a ../../libs/sailfish/$(UNAME_MACHINE)/* $(DESTDIR)/usr/
#	@make -C ../../libs/sailfish/$(LIBFRIBIDI) install prefix=/usr DESTDIR=$(DESTDIR)
#	@make -C ../../libs/sailfish/$(LIBLINEBREAK) install prefix=/usr DESTDIR=$(DESTDIR)

install: install_libs
	@install -m 0644 ../data/default/$(KEYMAP_FILE) $(DESTDIR)$(SHAREDIR)/$(FBREADER_NAME)/default/keymap.xml
	@install -m 0644 ../data/default/styles.sailfish.xml $(DESTDIR)$(SHAREDIR)/$(FBREADER_NAME)/default/styles.xml
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/16x16/apps
	@install -m 0644 ../data/icons/application/16x16.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/16x16/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/22x22/apps
	@install -m 0644 ../data/icons/application/26x26.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/22x22/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/48x48/apps
	@install -m 0644 ../data/icons/application/48x48.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/48x48/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/64x64/apps
	@install -m 0644 ../data/icons/application/64x64.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/64x64/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/86x86/apps
	@install -m 0644 ../data/icons/application/sailfish_86x86.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/86x86/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/applications/$(DESKTOP_DIR)
	@install -m 0644 $(DESKTOP_FILE) $(DESTDIR)$(SHAREDIR)/applications/$(DESKTOP_DIR)/$(DESKTOP_FILE)

clean:
#	@rm -rf $(DESTDIR)
