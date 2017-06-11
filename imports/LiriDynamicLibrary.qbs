import qbs 1.0
import qbs.FileInfo

DynamicLibrary {
    Depends { name: "cpp" }

    cpp.cxxLanguageVersion: "c++11"
    cpp.visibility: "minimal"
    cpp.defines: [
        "QT_NO_CAST_FROM_ASCII",
        "QT_NO_CAST_TO_ASCII"
    ]
    cpp.includePaths: [product.sourceDirectory]
}
