import qbs
import qbs.Probes

Probes.PathProbe {
    pathPrefixes: {
        if (qbs.sysroot !== undefined)
            return [qbs.sysroot + "/usr", qbs.sysroot + "/usr/local"];
        return [];
    }
}
