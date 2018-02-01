import qbs

Module {
    readonly property bool found: probe.found

    Depends { name: "cpp" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includeNames: ["security/pam_appl.h", "pam/pam_appl.h"]
        libraryNames: ["libpam.so", "libdl.so"]
    }
}
