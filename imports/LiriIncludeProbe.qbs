import qbs
import qbs.Probes

Probes.IncludeProbe {
    pathPrefixes: {
        if (qbs.sysroot !== undefined)
            return [qbs.sysroot + "/usr", qbs.sysroot + "/usr/local"];
        return [];
    }
    environmentPaths: base.concat(["LIRI_INCLUDE_PREFIX"])
}
