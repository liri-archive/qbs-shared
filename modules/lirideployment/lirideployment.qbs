import qbs
import qbs.Environment
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools

Module {
    property string binDir: {
        if (qbs.targetOS.contains("linux"))
            return "bin";
        return "";
    }
    property string sbinDir: {
        if (qbs.targetOS.contains("linux"))
            return "sbin";
        return "";
    }
    property string dataDir: "share"
    property string docDir: FileInfo.joinPaths(dataDir, "doc")
    property string manDir: FileInfo.joinPaths(dataDir, "man")
    property string infoDir: FileInfo.joinPaths(dataDir, "info")
    property string etcDir: "etc"
    property string applicationsDir: FileInfo.joinPaths(dataDir, "applications")
    property string appDataDir: FileInfo.joinPaths(dataDir, "appdata")
    property string libDir: {
        if (qbs.targetOS.contains("linux"))
            return "lib";
        return "";
    }
    property string libexecDir: "libexec"
    property string includeDir: "include"
    property string importsDir: FileInfo.joinPaths(libDir, "imports")
    property string qmlDir: FileInfo.joinPaths(libDir, "qml")
    property string pluginsDir: FileInfo.joinPaths(libDir, "plugins")
    property string mkspecsDir: "mkspecs"
    property string qbsModulesDir: FileInfo.joinPaths(dataDir, "qbs", "modules")
    property string qbsImportsDir: FileInfo.joinPaths(dataDir, "qbs", "imports")

    setupRunEnvironment: {
        var env = Environment.currentEnv();
        env["PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, binDir)
        ].join(qbs.pathListSeparator), env["PATH"], qbs.pathListSeparator);
        env["QT_PLUGIN_PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, pluginsDir)
        ].join(qbs.pathListSeparator), env["QT_PLUGIN_PATH"], qbs.pathListSeparator);
        env["QML2_IMPORT_PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, qmlDir)
        ].join(qbs.pathListSeparator), env["QML2_IMPORT_PATH"], qbs.pathListSeparator);

        if (hostOS.contains("unix") && targetOS.contains("unix")) {
            env["LD_LIBRARY_PATH"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, libDir)
            ].join(qbs.pathListSeparator), env["LD_LIBRARY_PATH"], qbs.pathListSeparator);
            env["XDG_DATA_DIRS"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, dataDir)
            ].join(qbs.pathListSeparator), env["XDG_DATA_DIRS"], qbs.pathListSeparator);
            env["XDG_CONFIG_DIRS"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(qbs.installRoot, etcDir, "xdg")
            ].join(qbs.pathListSeparator), env["XDG_CONFIG_DIRS"], qbs.pathListSeparator);
        }

        for (var i in env) {
            var v = new ModUtils.EnvironmentVariable(i, qbs.pathListSeparator,
                                                     qbs.hostOS.contains("windows"));
            v.value = env[i];
            v.set();
        }
    }
}
