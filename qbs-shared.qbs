import qbs 1.0

Project {
    name: "QbsShared"

    readonly property string version: "0.0.0"
    readonly property var versionParts: version.split('.').map(function(part) { return parseInt(part); })

    minimumQbsVersion: "1.6"

    qbsSearchPaths: ["."]

    Product {
        Depends { name: "lirideployment" }

        Group {
            name: "Imports"
            qbs.install: true
            qbs.installDir: lirideployment.qbsImportsDir
            qbs.installSourceBase: "imports/"
            files: "imports/**"
        }

        Group {
            name: "Modules"
            qbs.install: true
            qbs.installDir: lirideployment.qbsModulesDir
            qbs.installSourceBase: "modules/"
            files: "modules/**"
        }
    }
}
