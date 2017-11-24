import qbs 1.0

LiriProduct {
    name: project.privateName
    condition: project.conditionFunction()
    type: ["staticlibrary"]

    Depends { name: "lirideployment" }

    Group {
        qbs.install: true
        qbs.installDir: lirideployment.libDir
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: ["staticlibrary"]
    }
}
