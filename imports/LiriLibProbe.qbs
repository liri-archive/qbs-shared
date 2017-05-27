import qbs

LiriPathProbe {
    pathSuffixes: {
        var suffixes = ["lib"];
        if (qbs.architecture == "x86")
            suffixes.push("lib/i386-linux-gnu");
        if (qbs.architecture == "x86_64")
            suffixes.push("lib/x86_64-linux-gnu");
        if (qbs.architecture.endsWith("64"))
            suffixes.push("lib64");
        return base.concat(suffixes);
    }
    environmentPaths: base.concat(["LIRI_LIBRARY_PREFIX"])
}
