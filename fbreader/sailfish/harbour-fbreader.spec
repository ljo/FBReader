# Upstream: Nikolay Pultsin <geometer@fbreader.org>

# >> macros
%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
# << macros

Summary: E-book reader
Name: harbour-fbreader
Version: 0.99.6
Release: 1
License: GPL
Group: Qt/Qt
URL: http://www.fbreader.org/
Source0: %{name}-%{version}.tar.gz

Packager: Leif-Jöran Olsson <info@friprogramvarusyndikatet.se>

#Source: http://www.fbreader.org/fbreader-sources-%{version}.tgz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

Requires: sailfishsilica-qt5 >= 0.10.9 
BuildRequires: pkgconfig(Qt5Core) pkgconfig(Qt5Quick) pkgconfig(Qt5Qml) pkgconfig(Qt5Widgets) pkgconfig(Qt5Gui) pkgconfig(Qt5Network) pkgconfig(Qt5OpenGL) pkgconfig(GLESv2)
BuildRequires: zlib-devel, libpng-devel
BuildRequires: desktop-file-utils
BuildRequires: bzip2-devel, expat-devel, libjpeg-devel

%description
FBReader is an e-book reader.
FBReader supports several e-book formats: ePub, fb2, chm, rtf, plucker, etc. 
Direct reading from zip, tar, gzip and bzip2 archives is also supported.

#       FBReader is an e-book reader. It supports most open e-book formats, and
#       can read compressed e-book archives.

%prep
%setup -q

%build
%qtc_qmake5
%{__make} %{?_smp_mflags} INSTALLDIR=%{_prefix} TARGET_ARCH=sailfish UI_TYPE=qml TARGET_STATUS=release

# %{buildroot} -> $RPM_BUILD_ROOT
%install
%{__rm} -rf $RPM_BUILD_ROOT
%makeinstall INSTALL_ROOT=$RPM_BUILD_ROOT INSTALLDIR=%{_prefix} TARGET_ARCH=sailfish UI_TYPE=qml TARGET_STATUS=release DESTDIR=$RPM_BUILD_ROOT

# %{buildroot} -> $RPM_BUILD_ROOT
%clean
%{__rm} -rf $RPM_BUILD_ROOT

# FBReader -> %{name}
%files
%defattr(-, root, root, 0755)
%{_bindir}/%{name}
%{_datadir}/%{name}
#%{_datadir}/pixmaps/FBReader.png
#%{_datadir}/pixmaps/FBReader
%attr(644, root,root) %{_datadir}/applications/%{name}.desktop
%attr(644, root,root) %{_datadir}/icons/hicolor/86x86/apps/%{name}.desktop
#%{_libdir}/libzlcore.so.%{version}
#%{_libdir}/libzltext.so.%{version}
#%{_libdir}/zlibrary/ui/zlui-gtk.so
#%{_datadir}/zlibrary

#%post -p /sbin/ldconfig

#%postun -p /sbin/ldconfig

%changelog
* Sun Jan 23 2014 Leif-Jöran Olsson <info@friprogramvarusyndikatet.se> - 0.9.6-1 
- new SailfishOS target.

* Sun Nov 18 2007 Nikolay Pultsin <geometer@fbreader.org> - 0.8.8-1
- new upstream version
- excluded keynames.patch
