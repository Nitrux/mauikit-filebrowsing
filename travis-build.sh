#!/bin/bash

set -x

### Install Build Tools #1

DEBIAN_FRONTEND=noninteractive apt -qq update
DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	appstream \
	automake \
	autotools-dev \
	build-essential \
	checkinstall \
	cmake \
	curl \
	devscripts \
	equivs \
	extra-cmake-modules \
	gettext \
	git \
	gnupg2 \
	lintian \
	wget

### Add Neon Sources

wget -qO /etc/apt/sources.list.d/neon-user-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.neon.user

DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	55751E5D > /dev/null

curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;

wget -qO /etc/apt/sources.list.d/nitrux-testing-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.nitrux.testing

DEBIAN_FRONTEND=noninteractive apt -qq update

### Install Package Build Dependencies #2
### Filebrowsing needs ECM > 5.70

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	libkf5coreaddons-dev \
	libkf5i18n-dev \
	libkf5kio-dev \
	mauikit-git \
	qtbase5-dev \
	qtdeclarative5-dev \
	qtquickcontrols2-5-dev

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --only-upgrade \
	extra-cmake-modules

### Clone Repository

git clone --depth 1 --branch master https://invent.kde.org/maui/mauikit-filebrowsing.git

rm -rf mauikit-filebrowsing/{examples,LICENSE,README.md}

### Compile Source

mkdir -p mauikit-filebrowsing/build && cd mauikit-filebrowsing/build

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_BSYMBOLICFUNCTIONS=OFF \
	-DQUICK_COMPILER=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_SYSCONFDIR=/etc \
	-DCMAKE_INSTALL_LOCALSTATEDIR=/var \
	-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..

make

### Run checkinstall and Build Debian Package
### DO NOT USE debuild, screw it

>> description-pak printf "%s\n" \
	'A free and modular front-end framework for developing user experiences.' \
	'' \
	'MauiKit File Browsing controls and utils.' \
	'' \
	'Maui stands for Multi-Adaptable User Interface and allows ' \
	'any Maui app to run on various platforms + devices,' \
	'like Linux Desktop and Phones, Android, or Windows.' \
	'' \
	'This package contains the MauiKit filebrowsing shared library, the MauiKit filebrowsing qml module' \
	'and the MauiKit filebrowsing development files.' \
	'' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=mauikit-filebrowsing-git \
	--pkgversion=2.1.2+git+2 \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=lib \
	--pkgsource=mauikit-filebrowsing \
	--pakdir=../.. \
	--maintainer=uri_herrera@nxos.org \
	--provides=mauikit-filebrowsing-git \
	--requires="libc6,libkf5configcore5,libkf5kiocore5,libkf5kiofilewidgets5,libkf5kiogui5,libkf5kiowidgets5,libkf5service5,libkf5solid5,mauikit-git \(\>= 2.1.2+git\),libqt5core5a,libqt5gui5,libqt5network5,libqt5qml5,libqt5quick5,libqt5sql5,libqt5xml5,libstdc++6,qml-module-org-kde-kirigami2,qml-module-qt-labs-settings,qml-module-qtquick-controls2,qml-module-qtquick-shapes" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
