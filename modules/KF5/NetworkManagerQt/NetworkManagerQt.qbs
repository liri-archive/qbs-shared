import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }
    Depends { name: "NetworkManager" }

    condition: kf5Probe.found && nmProbe.found && libProbe.found

    cpp.includePaths: {
        var paths = [];
        if (kf5Probe.found)
            paths.push(kf5Probe.path);
        if (nmProbe.found)
            paths.push(nmProbe.path);
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
        names: ["networkmanagerqt_version.h"]
    }

    LiriIncludeProbe {
        id: nmProbe
        pathSuffixes: "include/KF5/NetworkManagerQt"
        names: ["networkmanagerqt/networkmanagerqt_export.h", "NetworkManagerQt/Utils"]
    }

    LiriLibProbe {
        id: libProbe
        names: ["libKF5NetworkManagerQt.so"]
    }
}
