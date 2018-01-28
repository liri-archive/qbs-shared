import qbs
import qbs.ModUtils
import "lib-probe.js" as ConfigScript
import LiriUtils

Probe {
    id: probe

    // Input
    property pathList platformPaths: {
        var paths = qbs.hostOS.contains("unix") ? ["/usr", "/usr/local"] : [];
        if (qbs.sysroot)
            return paths.map(LiriUtils.prependSysroot);
        return paths;
    }

    property stringList includePathSuffixes: ["include"]
    property stringList includeNames: []
    property stringList includeEnvironmentPaths: ["LIRI_INCLUDE_PREFIX"]

    property stringList libraryPathSuffixes: {
        var suffixes = ["lib"];
        if (qbs.architecture == "x86")
            suffixes.push("lib/i386-linux-gnu");
        if (qbs.architecture == "x86_64")
            suffixes.push("lib/x86_64-linux-gnu");
        if (qbs.architecture.endsWith("64"))
            suffixes.push("lib64");
        return base.concat(suffixes);
    }
    property stringList libraryNames: []
    property stringList libraryEnvironmentPaths: ["LIRI_LIBRARY_PREFIX"]

    property string pathListSeparator: qbs.pathListSeparator

    // Output
    property stringList includePaths: []
    property stringList libraryPaths: []
    property stringList libraries: []

    configure: {
        var includeResult = ConfigScript.configure(includeNames, platformPaths,
                                                   includePathSuffixes,
                                                   includeEnvironmentPaths,
                                                   pathListSeparator);
        var libResult = ConfigScript.configure(libraryNames, platformPaths,
                                               libraryPathSuffixes,
                                               libraryEnvironmentPaths,
                                               pathListSeparator);

        if (includeResult.found && libResult.found) {
            found = true;
            includePaths = [includeResult.path];
            libraryPaths = [libResult.path];
            libraries = [libResult.filePath];
        }
    }
}
