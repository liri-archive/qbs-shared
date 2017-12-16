import qbs 1.0

Project {
    name: "QbsShared"

    readonly property string version: "1.0.0"
    readonly property var versionParts: version.split('.').map(function(part) { return parseInt(part); })

    property string qbsImportsDir: "share/qbs/imports"
    property string qbsModulesDir: "share/qbs/modules"

    minimumQbsVersion: "1.8.0"

    Product {
        name: "Installation"

        Depends { name: "lirideployment" }

        Group {
            name: "Imports"
            qbs.install: true
            qbs.installDir: project.qbsImportsDir
            qbs.installSourceBase: "imports/"
            files: "imports/**"
            excludeFiles: ["imports/**/*.py"]
        }

        Group {
            name: "Modules"
            qbs.install: true
            qbs.installDir: project.qbsModulesDir
            qbs.installSourceBase: "modules/"
            files: "modules/**"
            excludeFiles: ["modules/**/*.py"]
        }
    }

    InstallPackage {
        name: "qbs-shared-artifacts"
        targetName: name
        builtByDefault: false

        archiver.type: "tar"
        archiver.outputDirectory: project.buildDirectory

        Depends { name: "Installation" }
    }
}
