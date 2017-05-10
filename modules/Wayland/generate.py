#!/usr/bin/env python3

import os

template = """import qbs 1.0

Module {
    property bool found: probe.found
    property string packageVersion: probe.modversion

    Depends { name: "cpp" }

    cpp.defines: probe.defines == undefined ? [] : probe.defines
    cpp.commonCompilerFlags: probe.compilerFlags == undefined ? [] : probe.compilerFlags
    cpp.includePaths: probe.includePaths == undefined ? [] : probe.includePaths
    cpp.libraryPaths: probe.libraryPaths == undefined ? [] : probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries == undefined ? [] : probe.libraries
    cpp.linkerFlags: probe.linkerFlags == undefined ? [] : probe.linkerFlags

    LiriPkgConfigProbe {
        id: probe
        name: "%s"
    }
}
"""

modules = [
    'wayland-client',
    'wayland-server',
    'wayland-cursor',
    'wayland-egl',
]

for module in modules:
    name = module[8:]
    if not os.path.exists(name):
        os.makedirs(name)
    with open(os.path.join(name, name + ".qbs"), "w") as f:
        f.write(template % module)
