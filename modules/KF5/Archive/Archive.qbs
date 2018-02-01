import qbs

Module {
    readonly property bool found: probe.found

    Depends { name: "cpp" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/KF5/KArchive"]
        includeNames: ["karchive_export.h"]
        libraryNames: ["libKF5Archive.so"]
    }
}
