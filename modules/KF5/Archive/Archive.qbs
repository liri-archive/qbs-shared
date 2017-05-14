import qbs
import qbs.Probes

Module {
    property bool found: kf5Probe.found && incProbe.found && libProbe.found

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

    LiriIncludeProbe {
        id: kf5Probe
        pathSuffixes: "include/KF5"
        names: ["karchive_version.h"]
    }

    LiriIncludeProbe {
        id: incProbe
        pathSuffixes: "include/KF5/KArchive"
        names: ["karchive_export.h"]
    }

    LiriPathProbe {
        id: libProbe
        platformPaths: ["/usr/local/lib", "/usr/lib"]
        names: ["libKF5Archive.so"]
    }
}
