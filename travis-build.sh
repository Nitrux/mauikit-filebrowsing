#!/bin/bash

set -x

apt -qq update
apt -qq -yy install equivs curl git wget gnupg2

wget -qO /etc/apt/sources.list.d/kubuntu-backports-ppa.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources.list.backports.ppa

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	2836CB0A8AC93F7A > /dev/null

curl -L https://packagecloud.io/nitrux/repo/gpgkey | apt-key add -;

wget -qO /etc/apt/sources.list.d/nitrux-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.nitrux

apt -qq update

apt-cache policy

### Install Dependencies

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends devscripts debhelper gettext lintian build-essential automake autotools-dev cmake extra-cmake-modules appstream qml-module-qtquick-controls2 qml-module-qtquick-shapes qml-module-qtgraphicaleffects mauikit-dev

mk-build-deps -i -t "apt-get --yes" -r

### Clone repo.

git clone --single-branch --branch v2.0 https://invent.kde.org/maui/mauikit-filebrowsing.git

mv mauikit-filebrowsing/* .

rm -rf mauikit-filebrowsing examples LICENSES README.md

### Build Deb

mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us
