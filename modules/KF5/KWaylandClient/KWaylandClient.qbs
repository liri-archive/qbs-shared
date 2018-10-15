import qbs

Module {
    readonly property bool found: probe.found

    Depends { name: "cpp" }
    Depends { name: "Qt"; submodules: ["core", "gui"] }
    Depends { name: "Wayland"; submodules: ["client", "cursor"] }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/KF5", "include/KF5/KWayland/Client"]
        includeNames: ["kwayland_version.h", "kwaylandclient_export.h"]
        libraryNames: ["libKF5WaylandClient.so"]
    }
}
