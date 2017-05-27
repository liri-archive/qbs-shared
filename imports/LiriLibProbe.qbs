import qbs

LiriPathProbe {
    pathSuffixes: {
        var suffixes = ["lib"];
        if (qbs.architecture == "x86")
            suffixes.push("i386-linux-gnu/lib");
        if (qbs.architecture == "x86_64")
            suffixes.push("x86_64-linux-gnu/lib");
        if (qbs.architecture.endsWith("64"))
            suffixes.push("lib64");
        return base.concat(suffixes);
    }
    environmentPaths: base.concat(["LIRI_LIBRARY_PREFIX"])
}
