import qbs

Module {
    readonly property bool found: NetworkManager.found && probe.found

    Depends { name: "cpp" }
    Depends { name: "NetworkManager" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/KF5/NetworkManagerQt"]
        includeNames: ["networkmanagerqt/networkmanagerqt_export.h"]
        libraryNames: ["libKF5NetworkManagerQt.so"]
    }
}
