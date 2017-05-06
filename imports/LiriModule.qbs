import qbs 1.0
import qbs.FileInfo

LiriDynamicLibrary {
    property string generatedHeadersDir: FileInfo.joinPaths(product.buildDirectory, lirideployment.includeDir)

    property bool createClassHeaders: true
    property bool createPkgConfig: true
    property bool createPrl: false
    property bool createPri: false
    property bool createCMake: true

    property bool installHeaders: true
    property bool installPkgConfig: true
    property bool installPri: true
    property bool installCMake: true

    Depends { name: "lirideployment" }
    Depends { name: "create_headers"; condition: createClassHeaders }
    Depends { name: "create_pkgconfig"; condition: createPkgConfig }
    Depends { name: "create_prl"; condition: createPrl }
    Depends { name: "create_pri"; condition: createPri }
    Depends { name: "create_cmake"; condition: createCMake }

    create_headers.generatedHeadersDir: product.generatedHeadersDir

    Group {
        qbs.install: installHeaders
        qbs.installDir: FileInfo.joinPaths(lirideployment.includeDir, product.targetName)
        fileTagsFilter: ["public_headers", "class_headers"]
    }

    Group {
        qbs.install: installHeaders
        qbs.installDir: FileInfo.joinPaths(lirideployment.includeDir, product.targetName, project.version, product.targetName, "private")
        fileTagsFilter: "private_headers"
    }

    Group {
        qbs.install: true
        qbs.installDir: bundle.isBundle ? "Library/Frameworks" : (qbs.targetOS.contains("windows") ? "" : lirideployment.libDir)
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: [
            "dynamiclibrary",
            "dynamiclibrary_symlink",
            "dynamiclibrary_import"
        ]
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: installPkgConfig
        qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "pkgconfig")
        fileTagsFilter: "pkgconfig"
    }

    Group {
        qbs.install: installPri
        qbs.installDir: FileInfo.joinPaths(lirideployment.mkspecsDir, "modules")
        fileTagsFilter: "pri"
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: installCMake
        qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "cmake", product.targetName)
        fileTagsFilter: "cmake"
    }
}
