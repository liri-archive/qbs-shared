import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    condition: mmProbe.found && libmmGlibProbe.found

    cpp.includePaths: {
        var cflags = [];
        if (mmProbe.found && mmProbe.cflags != undefined)
            cflags = cflags.concat(mmProbe.cflags);
        if (libmmGlibProbe.found && libmmGlibProbe.cflags != undefined)
            cflags = cflags.concat(libmmGlibProbe.cflags);

        var paths = [];
        for (var i = 0; i < cflags.length; ++i) {
            var item = cflags[i];
            if (item.startsWith("-I"))
                paths.push(item.slice(2));
        }
        return paths;
    }
    cpp.libraryPaths: {
        var libs = [];
        if (mmProbe.found && mmProbe.libs != undefined)
            libs = libs.concat(mmProbe.libs);
        if (libmmGlibProbe.found && libmmGlibProbe.libs != undefined)
            libs = libs.concat(libmmGlibProbe.libs);

        var paths = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-L"))
                paths.push(item.slice(2));
        }
        return paths;
    }
    cpp.dynamicLibraries: {
        var libs = [];
        if (mmProbe.found && mmProbe.libs != undefined)
            libs = libs.concat(mmProbe.libs);
        if (libmmGlibProbe.found && libmmGlibProbe.libs != undefined)
            libs = libs.concat(libmmGlibProbe.libs);

        var libraries = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-l"))
                libraries.push(item.slice(2));
        }
        return libraries;
    }

    Probes.PkgConfigProbe {
        id: mmProbe
        name: "ModemManager"
    }

    Probes.PkgConfigProbe {
        id: libmmGlibProbe
        name: "mm-glib"
    }
}
