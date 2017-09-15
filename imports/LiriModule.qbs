import qbs 1.0

LiriDynamicLibrary {
    Depends { name: "lirideployment" }
    Depends { name: "bundle"; condition: qbs.targetOS.contains("macos"); required: false }

    Group {
        qbs.install: true
        qbs.installDir: bundle.isBundle ? "Library/Frameworks" : lirideployment.libDir
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: {
            if (bundle.isBundle)
                return ["bundle.content"];
            else if (product.type.contains("staticlibrary"))
                return ["staticlibrary"];
            return ["dynamiclibrary", "dynamiclibrary_symlink", "dynamiclibrary_import"];
        }
    }
}
