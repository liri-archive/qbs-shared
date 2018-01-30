import qbs

Module {
    readonly property bool found: ModemManager.found && kf5Probe.found && mmProbe.found && libProbe.found

    Depends { name: "cpp" }
    Depends { name: "ModemManager" }

    cpp.includePaths: {
        var paths = [];
        if (kf5Probe.found)
            paths.push(kf5Probe.path);
        if (mmProbe.found)
            paths.push(mmProbe.path);
        return paths;
    }
    cpp.libraryPaths: {
        var paths = [];
        if (libProbe.found)
            paths.push(libProbe.path);
        return paths;
    }
    cpp.dynamicLibraries: {
        var libs = [];
        if (libProbe.found)
            libs.push(libProbe.filePath);
        return libs;
    }

    LiriIncludeProbe {
        id: kf5Probe
        pathSuffixes: "include/KF5"
        names: ["modemmanagerqt_version.h"]
    }

    LiriIncludeProbe {
        id: mmProbe
        pathSuffixes: "include/KF5/ModemManagerQt"
        names: ["modemmanagerqt_export.h"]
    }

    LiriLibProbe {
        id: libProbe
        names: ["libKF5ModemManagerQt.so"]
    }
}
