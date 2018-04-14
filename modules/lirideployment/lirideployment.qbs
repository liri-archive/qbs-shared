import qbs
import qbs.Environment
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools

Module {
    property string prefix: {
        if (qbs.targetOS.contains("linux"))
            return "/usr/local";
        return "";
    }
    property string binDir: {
        if (qbs.targetOS.contains("linux"))
            return FileInfo.joinPaths(prefix, "bin");
        return "";
    }
    property string sbinDir: {
        if (qbs.targetOS.contains("linux"))
            return FileInfo.joinPaths(prefix, "sbin");
        return "";
    }
    property string dataDir: FileInfo.joinPaths(prefix, "share")
    property string docDir: FileInfo.joinPaths(dataDir, "doc")
    property string manDir: FileInfo.joinPaths(dataDir, "man")
    property string infoDir: FileInfo.joinPaths(dataDir, "info")
    property string etcDir: "/etc"
    property string applicationsDir: FileInfo.joinPaths(dataDir, "applications")
    property string appDataDir: FileInfo.joinPaths(dataDir, "metainfo")
    property string libDir: {
        if (qbs.targetOS.contains("linux"))
            return FileInfo.joinPaths(prefix, "lib");
        return "";
    }
    property string libexecDir: FileInfo.joinPaths(prefix, "libexec")
    property string includeDir: FileInfo.joinPaths(prefix, "include")
    property string importsDir: FileInfo.joinPaths(libDir, "imports")
    property string qmlDir: FileInfo.joinPaths(libDir, "qml")
    property string pluginsDir: FileInfo.joinPaths(libDir, "plugins")
    property string mkspecsDir: FileInfo.joinPaths(libDir, "qt5", "mkspecs")
    property string qbsModulesDir: FileInfo.joinPaths(dataDir, "qbs", "modules")
    property string qbsImportsDir: FileInfo.joinPaths(dataDir, "qbs", "imports")

    setupRunEnvironment: {
        var env = Environment.currentEnv();
        env["PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.binDir)
        ].join(product.qbs.pathListSeparator), env["PATH"], product.qbs.pathListSeparator);
        env["QT_PLUGIN_PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.pluginsDir)
        ].join(product.qbs.pathListSeparator), env["QT_PLUGIN_PATH"], product.qbs.pathListSeparator);
        env["QML2_IMPORT_PATH"] = PathTools.prependOrSetPath([
            FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.qmlDir)
        ].join(product.qbs.pathListSeparator), env["QML2_IMPORT_PATH"], product.qbs.pathListSeparator);

        if (product.qbs.hostOS.contains("unix") && product.qbs.targetOS.contains("unix")) {
            env["LD_LIBRARY_PATH"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.libDir)
            ].join(product.qbs.pathListSeparator), env["LD_LIBRARY_PATH"], product.qbs.pathListSeparator);
            env["XDG_DATA_DIRS"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.dataDir)
            ].join(product.qbs.pathListSeparator), env["XDG_DATA_DIRS"], product.qbs.pathListSeparator);
            env["XDG_CONFIG_DIRS"] = PathTools.prependOrSetPath([
                FileInfo.joinPaths(product.qbs.installRoot, product.qbs.installPrefix, product.lirideployment.etcDir, "xdg")
            ].join(product.qbs.pathListSeparator), env["XDG_CONFIG_DIRS"], product.qbs.pathListSeparator);
        }

        for (var i in env) {
            var v = new ModUtils.EnvironmentVariable(i, product.qbs.pathListSeparator,
                                                     product.qbs.hostOS.contains("windows"));
            v.value = env[i];
            v.set();
        }
    }
}
