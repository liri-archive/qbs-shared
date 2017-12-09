import qbs 1.0

Module {
    property string packageVersion: probe.modversion

    Depends { name: "cpp" }

    condition: probe.found

    cpp.defines: probe.defines == undefined ? [] : probe.defines
    cpp.commonCompilerFlags: probe.compilerFlags == undefined ? [] : probe.compilerFlags
    cpp.includePaths: probe.includePaths == undefined ? [] : probe.includePaths
    cpp.libraryPaths: probe.libraryPaths == undefined ? [] : probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries == undefined ? [] : probe.libraries
    cpp.linkerFlags: probe.linkerFlags == undefined ? [] : probe.linkerFlags

    LiriPkgConfigProbe {
        id: probe
        name: "taglib"
    }
}
