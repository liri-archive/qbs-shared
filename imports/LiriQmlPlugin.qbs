import qbs 1.0
import qbs.FileInfo

LiriDynamicLibrary {
    property string pluginPath

    targetName: name + (qbs.enableDebugCode && qbs.targetOS.contains("windows") ? "d" : "")

    bundle.isBundle: false

    Depends { name: "lirideployment" }
    Depends { name: "Qt"; submodules: ["qml", "quick"] }

    FileTagger {
        patterns: ["qmldir", "*.qml", "*.qmltypes"]
        fileTags: ["qml"]
    }

    Group {
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(lirideployment.qmlDir, pluginPath)
        fileTagsFilter: ["debuginfo", "dynamiclibrary", "qml"]
    }
}
