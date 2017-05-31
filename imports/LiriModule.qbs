import qbs 1.0
import qbs.File
import qbs.FileInfo
import qbs.PathTools
import qbs.TextFile

LiriDynamicLibrary {
    property string publicIncludeDir: FileInfo.joinPaths(lirideployment.includeDir, targetName)
    property string privateIncludeDir: FileInfo.joinPaths(lirideployment.includeDir, targetName, project.version)

    property bool createClassHeaders: true
    property bool createPkgConfig: true
    property bool createPrl: false
    property bool createPri: false
    property bool createCMake: true

    property bool installHeaders: true
    property bool installPkgConfig: true
    property bool installPri: true
    property bool installCMake: true

    type: base.concat(["liri.export.module"])

    Depends { name: "lirideployment" }
    Depends { name: "create_headers"; condition: createClassHeaders }
    Depends { name: "create_pkgconfig"; condition: createPkgConfig; required: false }
    Depends { name: "create_prl"; condition: createPrl }
    Depends { name: "create_pri"; condition: createPri }
    Depends { name: "create_cmake"; condition: createCMake; required: false }

    create_headers.generatedHeadersDir: product.generatedHeadersDir

    Group {
        qbs.install: installHeaders
        qbs.installDir: product.publicIncludeDir
        fileTagsFilter: ["public_headers", "class_headers"]
    }

    Group {
        qbs.install: installHeaders
        qbs.installDir: FileInfo.joinPaths(product.privateIncludeDir, product.targetName, "private")
        fileTagsFilter: "private_headers"
    }

    Group {
        qbs.install: true
        qbs.installDir: bundle.isBundle ? "Library/Frameworks" : (qbs.targetOS.contains("windows") ? "" : lirideployment.libDir)
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: [
            "dynamiclibrary",
            "dynamiclibrary_symlink",
            "dynamiclibrary_import"
        ]
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: installPkgConfig
        qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "pkgconfig")
        fileTagsFilter: "pkgconfig"
    }

    Group {
        qbs.install: installPri
        qbs.installDir: FileInfo.joinPaths(lirideployment.mkspecsDir, "modules")
        fileTagsFilter: "pri"
    }

    Group {
        condition: qbs.targetOS.contains("linux")
        qbs.install: installCMake
        qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "cmake", product.targetName)
        fileTagsFilter: "cmake"
    }

    Rule {
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: product.targetName + ".qbs"
            fileTags: ["liri.export.module"]
        }

        prepare: {
            var sysroot = product.moduleProperty("qbs", "sysroot");

            var defines = [];
            var compilerFlags = [];
            var includePaths = [];
            var libraryPaths = [];
            var dynamicLibraries = [];
            var linkerFlags = [];

            includePaths.push(FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                 product.moduleProperty("qbs", "installPrefix"),
                                                 product.moduleProperty("lirideployment", "includeDir")));
            includePaths.push(FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                 product.moduleProperty("qbs", "installPrefix"),
                                                 product.publicIncludeDir));
            includePaths.push(FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                 product.moduleProperty("qbs", "installPrefix"),
                                                 product.privateIncludeDir));

            dynamicLibraries.push(FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                     input.moduleProperty("qbs", "installPrefix"),
                                                     input.moduleProperty("qbs", "installDir"),
                                                     PathTools.dynamicLibraryFilePath(product, product.version, 3)));

            for (var i in product.dependencies) {
                var dep = product.dependencies[i];
                if (dep.name == "cpp") {
                    defines = defines.concat(dep.defines.filter(function(item) {
                        return product.moduleProperty("cpp", "defines").indexOf(item) == -1;
                    }));

                    compilerFlags = compilerFlags.concat(dep.commonCompilerFlags);

                    includePaths = includePaths.concat(dep.includePaths.filter(function(item, pos) {
                        // Skip source and build directories
                        if (item.startsWith(product.sourceDirectory) || item.startsWith(product.buildDirectory))
                            return false;

                        // Skip mkspec
                        if (item.startsWith(product.moduleProperty("Qt.core", "mkspecPath")))
                            return false;

                        return true;
                    }).map(function(item) {
                        // Strip sysroot
                        return item.replace(sysroot, "");
                    }));
                    includePaths = includePaths.filter(function(item, pos) {
                        // Skip empty or null values
                        if (!item)
                            return false;

                        // Remove duplicates
                        return includePaths.indexOf(item) == pos;
                    });

                    dep.libraryPaths.map(function(item) {
                        libraryPaths.push(item.replace(sysroot, ""));
                    });

                    dynamicLibraries = dynamicLibraries.concat(dep.dynamicLibraries.map(function(item) {
                        // Return the library if it's a full path
                        if (File.exists(item))
                            return item.replace(sysroot, "");

                        // Otherwise look into the library paths
                        for (var i in dep.libraryPaths) {
                            var prefix = product.moduleProperty("cpp", "dynamicLibraryPrefix");
                            var suffix = product.moduleProperty("cpp", "dynamicLibrarySuffix");
                            var filePath = FileInfo.joinPaths(libraryPaths[i], prefix + item + suffix);
                            if (File.exists(filePath))
                                return filePath.replace(sysroot, "");
                        }

                        // Return an empty string that will be filtered below
                        return "";
                    }));
                    dynamicLibraries = dynamicLibraries.filter(function(item, pos) {
                        // Skip empty or null values
                        if (!item)
                            return false;

                        // Remove duplicates
                        return dynamicLibraries.indexOf(item) == pos;
                    });

                    linkerFlags = linkerFlags.concat(dep.linkerFlags);

                    break;
                }
            }

            var cmd = new JavaScriptCommand();
            cmd.description = "generate " + output.fileName;
            cmd.highlight = "codegen";
            cmd.defines = defines;
            cmd.compilerFlags = compilerFlags;
            cmd.includePaths = includePaths;
            cmd.libraryPaths = libraryPaths;
            cmd.dynamicLibraries = dynamicLibraries;
            cmd.linkerFlags = linkerFlags;
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("import qbs 1.0\n");
                file.writeLine("Module {");
                file.writeLine('    property stringList cppIncludePaths: ' + JSON.stringify(includePaths));
                file.writeLine('    property stringList cppDynamicLibraries: ' + JSON.stringify(dynamicLibraries));
                file.writeLine('');
                file.writeLine('    Depends { name: "cpp" }\n');
                file.writeLine('    cpp.defines: ' + JSON.stringify(defines));
                file.writeLine('    cpp.commonCompilerFlags: ' + JSON.stringify(compilerFlags));
                file.writeLine('    cpp.includePaths: {');
                file.writeLine('        if (qbs.sysroot !== undefined)');
                file.writeLine('            return cppIncludePaths.map(function(item) { return qbs.sysroot + item; });');
                file.writeLine('        return cppIncludePaths;');
                file.writeLine('    }');
                file.writeLine('    cpp.dynamicLibraries: {');
                file.writeLine('        if (qbs.sysroot !== undefined)');
                file.writeLine('            return cppDynamicLibraries.map(function(item) { return qbs.sysroot + item; });');
                file.writeLine('        return cppDynamicLibraries;');
                file.writeLine('    }');
                file.writeLine('    cpp.linkerFlags: ' + JSON.stringify(linkerFlags));
                file.writeLine("}");
                file.close();
            }
            return [cmd];
        }
    }

    Group {
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(lirideployment.qbsModulesDir, product.targetName)
        fileTagsFilter: "liri.export.module"
    }
}
