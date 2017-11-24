import qbs 1.0

Product {
    property stringList commonCppDefines: []
    property bool castFromAscii: false
    property bool castToAscii: false

    Depends { name: "cpp" }

    cpp.cxxLanguageVersion: "c++11"
    cpp.visibility: "minimal"
    cpp.defines: {
        var defines = commonCppDefines;
        if (!castFromAscii)
            defines.push("QT_NO_CAST_FROM_ASCII");
        if (!castToAscii)
            defines.push("QT_NO_CAST_TO_ASCII");
        return defines;
    }
    cpp.includePaths: [product.sourceDirectory]

    Properties {
        condition: project.useStaticAnalyzer && cpp.compilerName.contains("clang")
        cpp.compilerWrapper: ["scan-build"]
    }
}
