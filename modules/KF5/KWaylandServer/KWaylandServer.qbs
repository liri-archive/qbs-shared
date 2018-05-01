import qbs

Module {
    readonly property bool found: probe.found

    Depends { name: "cpp" }
    Depends { name: "Qt"; submodules: ["core", "gui"] }
    Depends { name: "Wayland.server" }

    cpp.includePaths: probe.includePaths
    cpp.libraryPaths: probe.libraryPaths
    cpp.dynamicLibraries: probe.libraries

    LiriLibraryProbe {
        id: probe
        includePathSuffixes: ["include/KF5", "include/KF5/KWayland/Server"]
        includeNames: ["kwayland_version.h", "kwaylandserver_export.h"]
        libraryNames: ["libKF5WaylandServer.so"]
    }
}
