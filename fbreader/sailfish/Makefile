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
	cd ../../libs/sailfish/$(LIBFRIBIDI) && make distclean && ./configure --enable-static && make && make install-strip prefix=/ DESTDIR=$(ROOTDIR)/libs/sailfish/$(UNAME_MACHINE)/ && cd $(CURDIR)

make_liblinebreak:
	cd ../../libs/sailfish/$(LIBLINEBREAK) && make distclean && ./configure --enable-static && make && make install-strip prefix=/ DESTDIR=$(ROOTDIR)/libs/sailfish/$(UNAME_MACHINE)/ && cd $(CURDIR)

make_libs: make_libfribidi make_liblinebreak

install_libs:
	@install -d $(DESTDIR)/usr
	cp -a ../../libs/sailfish/$(UNAME_MACHINE)/* $(DESTDIR)/usr/
#	@make -C ../../libs/sailfish/$(LIBFRIBIDI) install-strip prefix=/usr DESTDIR=$(DESTDIR)
#	@make -C ../../libs/sailfish/$(LIBLINEBREAK) install-strip prefix=/usr DESTDIR=$(DESTDIR)
#	@libtool --finish $(DESTDIR)/usr/local/lib

install: install_libs
	@install -m 0644 ../data/default/$(KEYMAP_FILE) $(DESTDIR)$(SHAREDIR)/$(FBREADER_NAME)/default/keymap.xml
	@install -m 0644 ../data/default/styles.sailfish.xml $(DESTDIR)$(SHAREDIR)/$(FBREADER_NAME)/default/styles.xml
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/16x16/apps
	@install -m 0644 ../data/icons/application/sailfish_16x16.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/16x16/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/22x22/apps
	@install -m 0644 ../data/icons/application/sailfish_22x22.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/22x22/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/24x24/apps
	@install -m 0644 ../data/icons/application/sailfish_24x24.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/24x24/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/32x23/apps
	@install -m 0644 ../data/icons/application/sailfish_32x32.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/32x32/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/48x48/apps
	@install -m 0644 ../data/icons/application/sailfish_48x48.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/48x48/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/64x64/apps
	@install -m 0644 ../data/icons/application/sailfish_64x64.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/64x64/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/86x86/apps
	@install -m 0644 ../data/icons/application/sailfish_86x86.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/86x86/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/108x108/apps
	@install -m 0644 ../data/icons/application/sailfish_108x108.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/108x108/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/128x128/apps
	@install -m 0644 ../data/icons/application/sailfish_128x128.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/128x128/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/256x256/apps
	@install -m 0644 ../data/icons/application/sailfish_256x256.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/256x256/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/512x512/apps
	@install -m 0644 ../data/icons/application/sailfish_512x512.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/512x512/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/icons/hicolor/1024x1024/apps
	@install -m 0644 ../data/icons/application/sailfish_1024x1024.png $(DESTDIR)$(SHAREDIR)/icons/hicolor/1024x1024/apps/$(FBREADER_NAME).png
	@install -d $(DESTDIR)$(SHAREDIR)/applications/$(DESKTOP_DIR)
	@install -m 0644 $(DESKTOP_FILE) $(DESTDIR)$(SHAREDIR)/applications/$(DESKTOP_DIR)/$(DESKTOP_FILE)

clean:
#	@rm -rf $(DESTDIR)
