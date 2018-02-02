import qbs

Module {
    readonly property bool found: ModemManager.found && probe.found

    Depends { name: "cpp" }
    Depends { name: "ModemManager" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/KF5", "include/KF5/ModemManagerQt"]
        includeNames: ["modemmanagerqt_export.h", "ModemManagerQt/GenericTypes"]
        libraryNames: ["libKF5ModemManagerQt.so"]
    }
}
