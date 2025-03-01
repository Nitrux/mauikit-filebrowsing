#! /bin/bash

set -x

### Update sources

mkdir -p /etc/apt/keyrings

curl -fsSL https://packagecloud.io/nitrux/mauikit/gpgkey | gpg --dearmor -o /etc/apt/keyrings/nitrux_mauikit-archive-keyring.gpg

cat <<EOF > /etc/apt/sources.list.d/nitrux-mauikit.list
deb [signed-by=/etc/apt/keyrings/nitrux_mauikit-archive-keyring.gpg] https://packagecloud.io/nitrux/mauikit/debian/ trixie main
EOF

apt -q update

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
	--requires="libc6,libkf6coreaddons6,libkf6i18n6,libkf6iconthemes6,libqt6core6t64,libqt6gui6,libqt6multimedia6,libqt6multimediawidgets6,libqt6qml6,libqt6quick6,libqt6quickcontrols2-6,libqt6quickshapes6,libqt6spatialaudio6,libqt6svg6,libqt6svgwidgets6,mauikit-git \(\>= 4.0.1\),qml6-module-org-kde-kirigami,qml6-module-qtmultimedia,qml6-module-qtquick-controls,qml6-module-qtquick-shapes,qml6-module-qtquick3d-spatialaudio" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
