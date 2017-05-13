import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    cpp.includePaths: {
        var paths = [];
        if (kf5Probe.found)
            paths.push(kf5Probe.path);
        if (incProbe.found)
            paths.push(incProbe.path);
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
        names: ["solid_version.h"]
    }

    Probes.IncludeProbe {
        id: incProbe
        pathSuffixes: "include/KF5/Solid"
        names: ["solid/solid_export.h"]
    }

    Probes.PathProbe {
        id: libProbe
        platformPaths: ["/usr/local/lib", "/usr/lib"]
        names: ["libKF5Solid.so"]
    }
}
