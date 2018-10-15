qbs shared
==========

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub release](https://img.shields.io/github/release/lirios/qbs-shared.svg)](https://github.com/lirios/qbs-shared)
[![Build Status](https://travis-ci.org/lirios/qbs-shared.svg?branch=master)](https://travis-ci.org/lirios/qbs-shared)
[![GitHub issues](https://img.shields.io/github/issues/lirios/qbs-shared.svg)](https://github.com/lirios/qbs-shared/issues)
[![Maintained](https://img.shields.io/maintenance/yes/2018.svg)](https://github.com/lirios/qbs-shared/commits/master)

Shared imports and modules for projects using the qbs build system.

## Dependencies

You need [qbs](http://doc.qt.io/qbs/index.html) >= 1.11.0 to build this project.

## Installation

Qbs is a new build system that is much easier to use compared to qmake or CMake.

If you want to learn more, please read the [Qbs manual](http://doc.qt.io/qbs/index.html),
especially the [setup guide](http://doc.qt.io/qbs/configuring.html) and how to install artifacts
from the [installation guide](http://doc.qt.io/qbs/installing-files.html).

From the root of the repository, run:

```sh
qbs setup-toolchains --type gcc /usr/bin/g++ gcc
qbs setup-qt /usr/bin/qmake-qt5 qt5
qbs config profiles.qt5.baseProfile gcc
```

Then, from the root of the repository, run:

```sh
qbs -d build -j $(nproc) profile:qt5 # use sudo if necessary
```

To the `qbs` call above you can append additional configuration parameters:

 * `project.prefix:/path/to/prefix` Qbs installation prefix (default: `/usr/local`)
 * `project.qbsModulesDir:/path/to/qbs` where Qbs modules are installed (default: `/usr/local/share/qbs/modules`)
 * `project.qbsImportDir:/path/to/qbs` where Qbs modules are installed (default: `/usr/local/share/qbs/imports`)

## Licensing

Licensed under the terms of the BSD 3 Clause license.
