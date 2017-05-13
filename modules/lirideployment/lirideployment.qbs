import qbs

Module {
    property string binDir: "bin"
    property string sbinDir: "sbin"
    property string dataDir: "share"
    property string docDir: dataDir + "/doc"
    property string manDir: dataDir + "/man"
    property string infoDir: dataDir + "/info"
    property string etcDir: "etc"
    property string applicationsDir: dataDir + "/applications"
    property string appDataDir: dataDir + "/appdata"
    property string libDir: "lib"
    property string libexecDir: "libexec"
    property string includeDir: "include"
    property string importsDir: libDir + "/imports"
    property string qmlDir: libDir + "/qml"
    property string pluginsDir: libDir + "/plugins"
    property string mkspecsDir: "mkspecs"
    property string qbsModulesDir: dataDir + "/qbs/modules"
    property string qbsImportsDir: dataDir + "/qbs/imports"
}
