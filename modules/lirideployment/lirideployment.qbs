import qbs
import qbs.Environment
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools

Module {
    property string binDir: "bin"
    property string sbinDir: "sbin"
    property string dataDir: "share"
    property string docDir: FileInfo.joinPath(dataDir, "doc")
    property string manDir: FileInfo.joinPath(dataDir, "man")
    property string infoDir: FileInfo.joinPath(dataDir, "info")
    property string etcDir: "etc"
    property string applicationsDir: FileInfo.joinPath(dataDir, "applications")
    property string appDataDir: FileInfo.joinPath(dataDir, "appdata")
    property string libDir: "lib"
    property string libexecDir: "libexec"
    property string includeDir: "include"
    property string importsDir: FileInfo.joinPath(libDir, "imports")
    property string qmlDir: FileInfo.joinPath(libDir, "qml")
    property string pluginsDir: FileInfo.joinPath(libDir, "plugins")
    property string mkspecsDir: "mkspecs"
    property string qbsModulesDir: FileInfo.joinPath(dataDir, "qbs", "modules")
    property string qbsImportsDir: FileInfo.joinPath(dataDir, "qbs", "imports")

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
                FileInfo.joinPaths(qbs.installRoot, qbs.installPrefix, etcDir, "xdg")
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
