import qbs 1.0

LiriProduct {
    type: ["dynamiclibrary", "android.nativelibrary"]

    Depends { name: "lirideployment" }

    Properties {
        condition: qbs.targetOS.contains("macos")
        bundle.isBundle: false
    }

    Group {
        qbs.install: true
        qbs.installDir: lirideployment.libDir
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: [
            "dynamiclibrary",
            "dynamiclibrary_symlink",
            "dynamiclibrary_import",
        ];
    }
}
