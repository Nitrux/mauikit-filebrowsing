# MauiKit Filebrowsing
![](https://mauikit.org/wp-content/uploads/2018/12/maui_project_logo.png)

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0) [![Awesome](https://awesome.re/badge.svg)](https://awesome.re) [![Generic badge](https://img.shields.io/badge/OS-Linux-blue.svg)](https://shields.io/)

_A free and modular front-end framework for developing user experiences._

# Screenshots

![image](https://user-images.githubusercontent.com/3053525/141736660-da296044-d48c-4bf8-8fa9-f633af84855d.png)

# Build

### Requirements

#### Debian/Ubuntu
##### Filebrowsing needs ECM > 5.70

```
libkf5coreaddons-dev
libkf5i18n-dev
libkf5kio-dev
mauikit
qtbase5-dev
qtdeclarative5-dev
qtquickcontrols2-5-dev
```

### Compile source
 1. `git clone --depth 1 --branch v2.1 https://invent.kde.org/maui/mauikit-filebrowsing.git` 
 2. `mkdir -p mauikit-filebrowsing/build && cd mauikit-filebrowsing/build`
 3. `cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_BSYMBOLICFUNCTIONS=OFF -DQUICK_COMPILER=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..`
 4. `make`

 ### Install
 1. `make install`

# Issues
If you find problems with the contents of this repository please create an issue.

©2021 Nitrux Latinoamericana S.C.
