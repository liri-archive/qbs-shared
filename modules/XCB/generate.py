#!/usr/bin/env python3

import os

template = """import qbs 1.0

Module {
    property bool found: XCB.xcb.found && probe.found

    Depends { name: "cpp" }
    Depends { name: "XCB.xcb" }

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
    'xcb-atom',
    'xcb-cursor',
    'xcb-dri2',
    'xcb-ewmh',
    'xcb-image',
    'xcb-present',
    'xcb-record',
    'xcb-res',
    'xcb-shm',
    'xcb-xf86dri',
    'xcb-xinput',
    'xcb-xvmc',
    'xcb-aux',
    'xcb-damage',
    'xcb-dri3',
    'xcb-glx',
    'xcb-keysyms',
    'xcb-proto',
    'xcb-render',
    'xcb-screensaver',
    'xcb-sync',
    'xcb-xfixes',
    'xcb-xkb',
    'xcb-xv',
    'xcb-composite',
    'xcb-dpms',
    'xcb-event',
    'xcb-icccm',
    'xcb-randr',
    'xcb-renderutil',
    'xcb-shape',
    'xcb-util',
    'xcb-xinerama',
    'xcb-xtest',
]

rename = {
    'xcb-aux': 'auxiliary',
}

for module in modules:
    if module in rename:
        name = rename[module]
    else:
        name = module[4:]
        if not os.path.exists(name):
            os.makedirs(name)
    with open(os.path.join(name, name + ".qbs"), "w") as f:
        f.write(template % module)
