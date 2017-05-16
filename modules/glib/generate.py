#!/usr/bin/env python3

import os

template = """import qbs 1.0

Module {
    property bool found: probe.found

    Depends { name: "cpp" }

    cpp.defines: base.concat(probe.defines == undefined ? [] : probe.defines)
    cpp.commonCompilerFlags: base.concat(probe.compilerFlags == undefined ? [] : probe.compilerFlags)
    cpp.includePaths: base.concat(probe.includePaths == undefined ? [] : probe.includePaths)
    cpp.libraryPaths: base.concat(probe.libraryPaths == undefined ? [] : probe.libraryPaths)
    cpp.dynamicLibraries: base.concat(probe.libraries == undefined ? [] : probe.libraries)
    cpp.linkerFlags: base.concat(probe.linkerFlags == undefined ? [] : probe.linkerFlags)

    LiriPkgConfigProbe {
        id: probe
        name: "%s"
    }
}
"""

modules = [
    'glib-2.0',
    'gio-2.0',
    'gobject-2.0',
]

for module in modules:
    name = module[:-4]
    if not os.path.exists(name):
        os.makedirs(name)
    with open(os.path.join(name, name + ".qbs"), "w") as f:
        f.write(template % module)
