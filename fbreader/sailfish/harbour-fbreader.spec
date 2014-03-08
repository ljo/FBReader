# Upstream: Nikolay Pultsin <geometer@fbreader.org>


Summary: E-book reader
Name: harbour-fbreader
Version: 0.99.6
Release: 2
License: GPL
Group: Qt/Qt
URL: http://www.fbreader.org/
Source0: %{name}-%{version}.tar.gz

Packager: Leif-Jöran Olsson <info@friprogramvarusyndikatet.se>

#BuildArch:armv7hl

#Source: http://www.fbreader.org/fbreader-sources-%{version}.tgz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

Requires: sailfishsilica-qt5 >= 0.10.9 
BuildRequires: pkgconfig(Qt5Core) pkgconfig(Qt5Quick) pkgconfig(Qt5Qml) pkgconfig(Qt5Gui) pkgconfig(Qt5Network)
#, libpng-devel
BuildRequires: zlib-devel 
BuildRequires: desktop-file-utils
BuildRequires: bzip2-devel, expat-devel, sqlite-devel, libcurl-devel

%description
FBReader is an e-book reader.
FBReader supports several e-book formats: ePub, fb2, chm, rtf, plucker, etc. 
Direct reading from zip, tar, gzip and bzip2 archives is also supported.

#       FBReader is an e-book reader. It supports most open e-book formats, and
#       can read compressed e-book archives.

%prep
#%setup -q

%build
#%qtc_qmake5
#%{__make} %{?_smp_mflags} INSTALLDIR=%{_prefix} TARGET_ARCH=sailfish UI_TYPE=qml TARGET_STATUS=release	DESTDIR=$RPM_BUILD_ROOT UNAME_MACHINE=armv7hl
%makeinstall INSTALLDIR=%{_prefix} TARGET_ARCH=sailfish UI_TYPE=qml TARGET_STATUS=release DESTDIR=$RPM_BUILD_ROOT UNAME_MACHINE=armv7hl

# %{buildroot} -> $RPM_BUILD_ROOT
%install
%{__rm} -rf $RPM_BUILD_ROOT
%makeinstall INSTALL_ROOT=$RPM_BUILD_ROOT INSTALLDIR=%{_prefix} DESTDIR=$RPM_BUILD_ROOT UNAME_MACHINE=armv7hl

# %{buildroot} -> $RPM_BUILD_ROOT
%clean
%{__rm} -rf $RPM_BUILD_ROOT

Privides: liblinebreak
Provides: libfribidi

# FBReader -> %{name}
%files
%defattr(-, root, root, 0644)
#%defattr(-, root, root, 0755)
%attr(755, root,root) %{_bindir}/%{name}
%attr(644, root,root) %{_libdir}/libfribidi.a
%attr(644, root,root) %{_libdir}/libfribidi.so
%attr(644, root,root) %{_libdir}/libfribidi.so.0
%attr(644, root,root) %{_libdir}/libfribidi.so.0.3.5
%attr(644, root,root) %{_libdir}/liblinebreak.a
%attr(644, root,root) %{_libdir}/liblinebreak.so
%attr(644, root,root) %{_libdir}/liblinebreak.so.2
%attr(644, root,root) %{_libdir}/liblinebreak.so.2.0.0

%attr(644, root,root) %{_includedir}/linebreakdef.h
%attr(644, root,root) %{_includedir}/linebreak.h
%attr(755, root,root) %{_includedir}/fribidi
%attr(644, root,root) %{_includedir}/fribidi/*

%{_datadir}/applications/%{name}.desktop

%{_datadir}/icons/hicolor/16x16/apps/%{name}.png
%{_datadir}/icons/hicolor/22x22/apps/%{name}.png
%{_datadir}/icons/hicolor/48x48/apps/%{name}.png
%{_datadir}/icons/hicolor/64x64/apps/%{name}.png
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png

%attr(755, root,root) %{_datadir}/%{name}
%attr(644, root,root) %{_datadir}/%{name}/default/*
%attr(644, root,root) %{_datadir}/%{name}/formats/fb2/*
%attr(644, root,root) %{_datadir}/%{name}/formats/html/*
%attr(644, root,root) %{_datadir}/%{name}/formats/xhtml/*
%attr(644, root,root) %{_datadir}/%{name}/help/*
%attr(644, root,root) %{_datadir}/%{name}/icons/*
%attr(644, root,root) %{_datadir}/%{name}/network/certificates/*
%attr(644, root,root) %{_datadir}/%{name}/resources/*

%attr(755, root,root) %{_datadir}/zlibrary
%attr(644, root,root) %{_datadir}/zlibrary/declarative/*
%attr(644, root,root) %{_datadir}/zlibrary/default/*
%attr(644, root,root) %{_datadir}/zlibrary/encodings/*
%attr(644, root,root) %{_datadir}/zlibrary/resources/*

#%{_libdir}/libzlcore.so.%{version}
#%{_libdir}/libzltext.so.%{version}
#%{_libdir}/zlibrary/ui/zlui-gtk.so
#%{_datadir}/zlibrary

%post -p /sbin/ldconfig

#%postun -p /sbin/ldconfig

%changelog
* Sat Mar 07 2014 Leif-Jöran Olsson <info@friprogramvarusyndikatet.se> - 0.99.6-2 
- [SailfishOS] Moving menu to pulldown. Find is now working.

* Thu Jan 23 2014 Leif-Jöran Olsson <info@friprogramvarusyndikatet.se> - 0.99.6-1 
- new SailfishOS target.

* Sun Nov 18 2007 Nikolay Pultsin <geometer@fbreader.org> - 0.8.8-1
- new upstream version
- excluded keynames.patch
