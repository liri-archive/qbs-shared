import qbs 1.0
import qbs.FileInfo

LiriDynamicLibrary {
    property string generatedHeadersDir: FileInfo.joinPaths(product.buildDirectory, "include")

    Depends { name: "create_headers" }
    Depends { name: "create_pkgconfig" }
    Depends { name: "create_prl" }
    Depends { name: "create_pri" }
    Depends { name: "create_cmake" }

    create_headers.generatedHeadersDir: product.generatedHeadersDir

    Group {
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("include", product.targetName)
        fileTagsFilter: ["public_headers", "class_headers"]
    }

    Group {
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("include", product.targetName, project.version, product.targetName, "private")
        fileTagsFilter: "private_headers"
    }

    Group {
        qbs.install: true
        qbs.installDir: bundle.isBundle ? "Library/Frameworks" : (qbs.targetOS.contains("windows") ? "" : "lib")
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: [
            "dynamiclibrary",
            "dynamiclibrary_symlink",
            "dynamiclibrary_import"
        ]
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("lib", "pkgconfig")
        fileTagsFilter: "pkgconfig"
    }

    Group {
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("mkspecs", "modules")
        fileTagsFilter: "pri"
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths("lib", "cmake", product.targetName)
        fileTagsFilter: "cmake"
    }
}
