import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    cpp.includePaths: {
        var cflags = [];
        if (probe.found && probe.cflags != undefined)
            cflags = cflags.concat(probe.cflags);

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
        if (probe.found && probe.libs != undefined)
            libs = libs.concat(probe.libs);

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
        if (probe.found && probe.libs != undefined)
            libs = libs.concat(probe.libs);

        var libraries = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-l"))
                libraries.push(item.slice(2));
        }
        return libraries;
    }

    Probes.PkgConfigProbe {
        id: probe
        name: "wayland-client"
    }
}
