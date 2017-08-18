import qbs
import qbs.FileInfo
import LiriUtils

Product {
    property stringList includePaths: LiriUtils.includesForModule(
                                          sync.module,
                                          FileInfo.joinPaths(project.buildDirectory, sync.prefix),
                                          project.version)
    property bool install: qbs.targetOS.contains("linux")

    name: project.headersName
    type: ["hpp_private", "hpp_public", "hpp_forwarding", "hpp_module", "hpp_depends", "hpp"]

    Depends { name: "lirideployment" }
    Depends { name: "sync" }

    sync.name: project.name

    Group {
        qbs.install: product.install
        qbs.installDir: FileInfo.joinPaths(lirideployment.includeDir, sync.module)
        fileTagsFilter: ["hpp_public", "hpp_forwarding", "hpp_module", "hpp_depends"]
    }

    Group {
        qbs.install: product.install
        qbs.installDir: FileInfo.joinPaths(lirideployment.includeDir, sync.module, project.version, sync.module, "private")
        fileTagsFilter: ["hpp_private"]
    }

    Export {
        Depends { name: "cpp" }

        cpp.includePaths: product.includePaths
    }
}
