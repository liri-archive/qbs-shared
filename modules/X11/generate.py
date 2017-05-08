#!/usr/bin/env python3

import os

template = """import qbs 1.0

Module {
    property bool found: X11.x11.found && probe.found

    Depends { name: "cpp" }
    Depends { name: "X11.x11" }

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
    'ice',
    'sm',
    'xau',
    'xcomposite',
    'xcursor',
    'xdamage',
    'xdmcp',
    'xext',
    'xshmfence',
    'xxf86vm',
    'xfixes',
    'xft',
    'xi',
    'xinerama',
    'xkbcomp',
    'xkbfile',
    'xmu',
    'xpm',
    'xrandr',
    'xrender',
    'xscrnsaver',
    'xt',
    'xtst',
    'xvmc',
    'xv',
]

for name in modules:
    if not os.path.exists(name):
        os.makedirs(name)
    with open(os.path.join(name, name + ".qbs"), "w") as f:
        f.write(template % name)
