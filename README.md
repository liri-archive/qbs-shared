qbs shared
==========

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub release](https://img.shields.io/github/release/lirios/qbs-shared.svg)](https://github.com/lirios/qbs-shared)
[![Build Status](https://travis-ci.org/lirios/qbs-shared.svg?branch=develop)](https://travis-ci.org/lirios/qbs-shared)
[![GitHub issues](https://img.shields.io/github/issues/lirios/qbs-shared.svg)](https://github.com/lirios/qbs-shared/issues)
[![Maintained](https://img.shields.io/maintenance/yes/2017.svg)](https://github.com/lirios/qbs-shared/commits/develop)

Shared imports and modules for projects using the qbs build system.

## Dependencies

You need [qbs](http://doc.qt.io/qbs/index.html) to build this project.

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
qbs -d build -j $(nproc) profile:qt5 # use sudo if necessary
```

On the last `qbs` line, you can specify additional configuration parameters at the end:

 * `qbs.installRoot:/path/to/install` (for example `/`)
 * `qbs.installPrefix:path/to/install` (for example `opt/liri` or `usr`)

The following are only needed if `qbs.installPrefix` is a system-wide path such as `usr`
and the default value doesn't suit your needs. All are relative to `qbs.installRoot`:

 * `lirideployment.qbsModulesDir:path/to/qbs` where Qbs modules are installed (default: `share/qbs/modules`)
 * `lirideployment.qbsImportDir:path/to/qbs` where Qbs modules are installed (default: `share/qbs/imports`)

See `modules/lirideployment/lirideployment.qbs` for more deployment-related parameters.

If you specify `qbs.installRoot` you might need to prefix the entire line with `sudo`,
depending on whether you have permissions to write there or not.

## Licensing

Licensed under the terms of the BSD 3 Clause license.
