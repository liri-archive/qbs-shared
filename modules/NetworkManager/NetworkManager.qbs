import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    cpp.includePaths: {
        var cflags = [];
        if (nmProbe.found && nmProbe.cflags != undefined)
            cflags = cflags.concat(nmProbe.cflags);
        if (libnmProbe.found && libnmProbe.cflags != undefined)
            cflags = cflags.concat(libnmProbe.cflags);
        if (libnmGlibProbe.found && libnmGlibProbe.cflags != undefined)
            cflags = cflags.concat(libnmGlibProbe.cflags);

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
        if (nmProbe.found && nmProbe.libs != undefined)
            libs = libs.concat(nmProbe.libs);
        if (libnmProbe.found && libnmProbe.libs != undefined)
            libs = libs.concat(libnmProbe.libs);
        if (libnmGlibProbe.found && libnmGlibProbe.libs != undefined)
            libs = libs.concat(libnmGlibProbe.libs);

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
        if (nmProbe.found && nmProbe.libs != undefined)
            libs = libs.concat(nmProbe.libs);
        if (libnmProbe.found && libnmProbe.libs != undefined)
            libs = libs.concat(libnmProbe.libs);
        if (libnmGlibProbe.found && libnmGlibProbe.libs != undefined)
            libs = libs.concat(libnmGlibProbe.libs);

        var libraries = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-l"))
                libraries.push(item.slice(2));
        }
        return libraries;
    }

    Probes.PkgConfigProbe {
        id: nmProbe
        name: "NetworkManager"
    }

    Probes.PkgConfigProbe {
        id: libnmProbe
        name: "libnm"
    }

    Probes.PkgConfigProbe {
        id: libnmGlibProbe
        name: "libnm-glib"
    }
}
