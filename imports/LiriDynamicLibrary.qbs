import qbs 1.0

LiriProduct {
    type: ["dynamiclibrary", "android.nativelibrary"]

    Depends { name: "bundle"; condition: qbs.targetOS.contains("macos"); required: false }

    Properties {
        condition: qbs.targetOS.contains("macos")
        bundle.isBundle: false
    }
}
