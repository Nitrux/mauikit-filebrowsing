#! /bin/bash

set -x

### Update sources

wget -qO /etc/apt/sources.list.d/nitrux-depot.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux
wget -qO /etc/apt/sources.list.d/nitrux-testing.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.testing

curl -L https://packagecloud.io/nitrux/depot/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/unison/gpgkey | apt-key add -;

apt update

### Install Package Build Dependencies #2

apt -qq -yy install --no-install-recommends \
	mauikit-git

### Download Source

git clone --depth 1 --branch $MAUIKIT_FILEBROWSING_BRANCH https://invent.kde.org/maui/mauikit-filebrowsing.git

rm -rf mauikit-filebrowsing/{examples,LICENSE,README.md}

### Compile Source

mkdir -p build && cd build

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
	-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu ../mauikit-filebrowsing/

make -j$(nproc)

make install

### Run checkinstall and Build Debian Package

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
	--pkgversion=$PACKAGE_VERSION \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=lib \
	--pkgsource=mauikit-filebrowsing \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=mauikit-filebrowsing-git \
	--requires="libc6,libkf5configcore5,libkf5kiocore5,libkf5kiofilewidgets5,libkf5kiogui5,libkf5kiowidgets5,libkf5service5,libkf5solid5,mauikit-git \(\>= 3.1.0+git\),libqt5core5a,libqt5gui5,libqt5network5,libqt5qml5,libqt5quick5,libqt5sql5,libqt5xml5,libstdc++6,qml-module-org-kde-kirigami2,qml-module-qt-labs-settings,qml-module-qtquick-controls2,qml-module-qtquick-shapes" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
