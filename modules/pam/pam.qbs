import qbs
import qbs.Probes

Module {
    readonly property bool found: incProbe.found && libProbe.found

    Depends { name: "cpp" }

    cpp.includePaths: {
        var paths = [];
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
        id: incProbe
        names: ["security/pam_appl.h", "pam/pam_appl.h"]
    }

    LiriLibProbe {
        id: libProbe
        names: ["libpam.so", "libdl.so"]
    }
}
