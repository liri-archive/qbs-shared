import qbs 1.0
import qbs.FileInfo

LiriProduct {
    property string pluginPath

    type: ["dynamiclibrary"].concat(isForAndroid ? ["android.nativelibrary"] : [])
    Properties {
        condition: isForAndroid && !consoleApplication
                   && multiplexByQbsProperties && multiplexByQbsProperties.contains("architectures")
                   && qbs.architectures && qbs.architectures.length > 1
        targetName: name + "_" + Android.ndk.abi
    }
    targetName: name + (qbs.enableDebugCode && qbs.targetOS.contains("windows") ? "d" : "")

    cpp.includePaths: [product.sourceDirectory]

    Depends { name: "lirideployment" }
    Depends { name: "Qt"; submodules: ["qml", "quick"] }
    Depends { name: "bundle"; condition: qbs.targetOS.contains("macos"); required: false }

    Properties {
        condition: qbs.targetOS.contains("macos")
        bundle.isBundle: false
    }

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
