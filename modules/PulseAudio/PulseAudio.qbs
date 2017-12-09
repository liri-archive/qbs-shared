import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    condition: pulseProbe.found && pulseGlibProbe.found

    cpp.includePaths: {
        var cflags = [];
        if (pulseProbe.found && pulseProbe.cflags != undefined)
            cflags = cflags.concat(pulseProbe.cflags);
        if (pulseGlibProbe.found && pulseGlibProbe.cflags != undefined)
            cflags = cflags.concat(pulseGlibProbe.cflags);

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
        if (pulseProbe.found && pulseProbe.libs != undefined)
            libs = libs.concat(pulseProbe.libs);
        if (pulseGlibProbe.found && pulseGlibProbe.libs != undefined)
            libs = libs.concat(pulseGlibProbe.libs);

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
        if (pulseProbe.found && pulseProbe.libs != undefined)
            libs = libs.concat(pulseProbe.libs);
        if (pulseGlibProbe.found && pulseGlibProbe.libs != undefined)
            libs = libs.concat(pulseGlibProbe.libs);

        var libraries = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-l"))
                libraries.push(item.slice(2));
        }
        return libraries;
    }

    Probes.PkgConfigProbe {
        id: pulseProbe
        name: "libpulse"
    }

    Probes.PkgConfigProbe {
        id: pulseGlibProbe
        name: "libpulse-mainloop-glib"
    }
}
