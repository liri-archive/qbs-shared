import qbs

Module {
    Depends { name: "cpp" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/AppStreamQt"]
        includeNames: ["appstreamqt_export.h"]
        libraryNames: ["libAppStreamQt.so"]
    }
}
