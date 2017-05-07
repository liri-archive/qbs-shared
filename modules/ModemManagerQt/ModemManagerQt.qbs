import qbs
import qbs.Probes

Module {
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

    Probes.IncludeProbe {
        id: kf5Probe
        pathSuffixes: "include/KF5"
        names: ["modemmanagerqt_version.h"]
    }

    Probes.IncludeProbe {
        id: mmProbe
        pathSuffixes: "include/KF5/ModemManagerQt"
        names: ["modemmanagerqt_export.h"]
    }

    Probes.PathProbe {
        id: libProbe
        platformPaths: ["/usr/local/lib", "/usr/lib"]
        names: ["libKF5ModemManagerQt.so"]
    }
}
