import qbs
import qbs.Probes

Module {
    Depends { name: "cpp" }

    cpp.includePaths: {
        var cflags = [];
        if (polkitProbe.found && polkitProbe.cflags != undefined)
            cflags = cflags.concat(polkitProbe.cflags);
        if (coreProbe.found && coreProbe.cflags != undefined)
            cflags = cflags.concat(coreProbe.cflags);
        if (agentProbe.found && agentProbe.cflags != undefined)
            cflags = cflags.concat(agentProbe.cflags);

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
        if (polkitProbe.found && polkitProbe.libs != undefined)
            libs = libs.concat(polkitProbe.libs);
        if (coreProbe.found && coreProbe.libs != undefined)
            libs = libs.concat(coreProbe.libs);
        if (agentProbe.found && agentProbe.libs != undefined)
            libs = libs.concat(agentProbe.libs);

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
        if (polkitProbe.found && polkitProbe.libs != undefined)
            libs = libs.concat(polkitProbe.libs);
        if (coreProbe.found && coreProbe.libs != undefined)
            libs = libs.concat(coreProbe.libs);
        if (agentProbe.found && agentProbe.libs != undefined)
            libs = libs.concat(agentProbe.libs);

        var libraries = [];
        for (var i = 0; i < libs.length; ++i) {
            var item = libs[i];
            if (item.startsWith("-l"))
                libraries.push(item.slice(2));
        }
        return libraries;
    }

    Probes.PkgConfigProbe {
        id: polkitProbe
        name: "polkit-qt5-1"
    }

    Probes.PkgConfigProbe {
        id: coreProbe
        name: "polkit-qt5-core-1"
    }

    Probes.PkgConfigProbe {
        id: agentProbe
        name: "polkit-qt5-agent-1"
    }
}
