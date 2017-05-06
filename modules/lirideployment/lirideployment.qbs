import qbs

Module {
    property string binDir: "bin"
    property string sbinDir: "sbin"
    property string dataDir: "share"
    property string docDir: dataDir + "/doc"
    property string manDir: dataDir + "/man"
    property string infoDir: dataDir + "/info"
    property string applicationsDir: dataDir + "/applications"
    property string appDataDir: dataDir + "/appdata"
    property string libDir: "lib"
    property string libexecDir: "libexec"
    property string includeDir: "include"
    property string importsDir: "imports"
    property string qmlDir: "qml"
    property string pluginsDir: "plugins"
    property string mkspecsDir: "mkspecs"
}
