import qbs
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.TextFile
import LiriUtils
import "cmake/cmake.js" as CMake

Project {
    property string moduleName: ""
    property string targetName: moduleName + (qbs.enableDebugCode && qbs.targetOS.contains("windows") ? "d" : "")
    property string description: moduleName
    property string headersName: moduleName + "Headers"

    property var resolvedProperties: ({})

    property bool createPkgConfig: qbs.targetOS.contains("linux")
    property stringList pkgConfigDependencies: []

    property bool createCMake: qbs.targetOS.contains("linux")
    property var cmakeDependencies: ({})
    property stringList cmakeLinkLibraries: []

    Product {
        name: project.moduleName + "-qbs"
        condition: moduleDependency.present
        type: ["qbs_module"]

        Depends { name: "lirideployment" }
        Depends { id: moduleDependency; name: project.moduleName; required: false }
        Depends { name: project.headersName }

        Rule {
            inputsFromDependencies: ["hpp", "dynamiclibrary", "staticlibrary"]
            multiplex: true

            Artifact {
                filePath: project.moduleName + ".qbs"
                fileTags: ["qbs_module"]
            }

            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generate qbs module " + output.fileName;
                cmd.highlight = "codegen";
                cmd.prefix = FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                product.moduleProperty("qbs", "installPrefix"),
                                                product.moduleProperty("lirideployment", "includeDir"));
                cmd.content = project.resolvedProperties;
                cmd.sourceCode = function() {
                    content.Depends = (content.Depends || []).concat([{ name: LiriUtils.quote("cpp") }]);
                    content["cpp.includePaths"] = LiriUtils.includesForModule(project.moduleName, prefix, project.version).map(LiriUtils.quote);
                    content["cpp.dynamicLibraries"] = [LiriUtils.quote(project.targetName)];

                    if (project.rpath)
                        content["cpp.rpaths"] = product.moduleProperty("cpp", "rpaths").map(LiriUtils.quote);

                    var cxxStandardLibrary = product.moduleProperty("cpp", "cxxStandardLibrary");
                    if (cxxStandardLibrary)
                        content["cpp.cxxStandardLibrary"] = LiriUtils.quote(cxxStandardLibrary);

                    var cxxLanguageVersion = product.moduleProperty("cpp", "cxxLanguageVersion");
                    if (cxxLanguageVersion)
                        content["cpp.cxxLanguageVersion"] = LiriUtils.quote(cxxLanguageVersion);

                    var outputFile = new TextFile(output.filePath, TextFile.WriteOnly);
                    outputFile.writeLine("import qbs");
                    outputFile.writeLine("");
                    outputFile.write(LiriUtils.jsToQml({ Module: content }));
                    outputFile.close();
                };
                return [cmd];
            }
        }

        Group {
            qbs.install: true
            qbs.installDir: FileInfo.joinPaths(lirideployment.qbsModulesDir, product.moduleName)
            fileTagsFilter: ["qbs_module"]
        }
    }

    Product {
        name: moduleName + "-pkgconfig"
        condition: project.createPkgConfig
        type: ["pkgconfig"]

        Depends { name: "lirideployment" }
        Depends { name: project.moduleName }

        Rule {
            inputsFromDependencies: ["dynamiclibrary"]
            multiplex: true

            Artifact {
                filePath: project.moduleName + ".pc"
                fileTags: ["pkgconfig"]
            }

            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + output.fileName;
                cmd.highlight = "filegen";
                cmd.prefix = FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                product.moduleProperty("qbs", "installPrefix"));
                cmd.libDir = product.moduleProperty("lirideployment", "libDir");
                cmd.includeDir = product.moduleProperty("lirideployment", "includeDir");
                cmd.includePaths = LiriUtils.includesForModule(project.moduleName,
                                                               FileInfo.joinPaths(cmd.prefix, cmd.includeDir),
                                                               project.version);
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine("prefix=" + prefix);
                    file.writeLine("exec_prefix=${prefix}");
                    file.writeLine("libdir=${prefix}/" + libDir);
                    file.writeLine("includedir=${prefix}/" + includeDir);
                    file.writeLine("");
                    file.writeLine("Name: " + project.moduleName);
                    file.writeLine("Description: " + project.description);
                    file.writeLine("Version: " + project.version);
                    file.writeLine("Libs: -L${libdir} -l" + project.moduleName);

                    var processCflags = function(path) {
                        var includePath = prefix + "/" + includeDir;
                        var newPath = path.replace(includePath, "${includedir}").replace(prefix, "${prefix}");
                        return "-I" + newPath;
                    };
                    file.writeLine("Cflags: " + includePaths.map(processCflags).join(" "));

                    if (project.pkgConfigDependencies.length > 0)
                        file.writeLine("Requires: " + project.pkgConfigDependencies.join(" "));

                    file.close();
                };
                return [cmd];
            }
        }

        Group {
            qbs.install: true
            qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "pkgconfig")
            fileTagsFilter: ["pkgconfig"]
        }
    }

    Product {
        name: moduleName + "-cmake"
        condition: project.createCMake
        type: ["cmake"]

        Depends { name: "lirideployment" }
        Depends { name: project.moduleName }

        Rule {
            inputsFromDependencies: ["dynamiclibrary"]
            multiplex: true

            Artifact {
                filePath: FileInfo.joinPaths("cmake", project.moduleName, project.moduleName + "Config.cmake")
                fileTags: ["cmake"]
            }

            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + output.fileName;
                cmd.highlight = "filegen";
                cmd.installRoot = product.moduleProperty("qbs", "installRoot");
                cmd.prefix = FileInfo.joinPaths(product.moduleProperty("qbs", "installRoot"),
                                                product.moduleProperty("qbs", "installPrefix"));
                cmd.libDir = product.moduleProperty("lirideployment", "libDir");
                cmd.includeDir = product.moduleProperty("lirideployment", "includeDir");
                cmd.includePaths = LiriUtils.includesForModule(project.moduleName,
                                                               FileInfo.joinPaths(cmd.prefix, cmd.includeDir),
                                                               project.version);
                cmd.sourceCode = function() {
                    var findDeps = "";
                    for (var dep in project.cmakeDependencies) {
                        findDeps += "find_dependency(" + dep + " \"" + project.cmakeDependencies[dep] + "\")\n";
                    }
                    var linkLibs = "";
                    if (project.cmakeLinkLibraries.length > 0)
                        linkLibs = project.cmakeLinkLibraries.join(";");

                    var vars = {
                        TITLE: project.moduleName,
                        TARGET_NAME: project.moduleName,
                        TARGET_NAMESPACE: project.moduleName,
                        VERSION: project.version,
                        INSTALL_ROOT: installRoot,
                        ROOT_INCLUDE_DIR: includePaths[0].replace(prefix + "/", ""),
                        INCLUDE_DIR: includePaths[1].replace(prefix + "/", ""),
                        LIB_DIR: prefix + "/" + libDir,
                        SONAME: inputs.dynamiclibrary[0].fileName,
                        FIND_DEPENDENCIES: findDeps,
                        LINK_LIBRARIES: linkLibs
                    };

                    var contents = CMake.cmakeConfig;
                    for (var i in vars)
                        contents = contents.replace(new RegExp('@' + i + '@(?!\w)', 'g'), vars[i]);

                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.truncate();
                    file.write(contents);
                    file.close();
                };
                return [cmd];
            }
        }

        Rule {
            inputsFromDependencies: ["dynamiclibrary"]
            multiplex: true

            Artifact {
                filePath: FileInfo.joinPaths("cmake", project.moduleName, project.moduleName + "ConfigVersion.cmake")
                fileTags: ["cmake"]
            }

            prepare: {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + output.fileName;
                cmd.highlight = "filegen";
                cmd.sourceCode = function() {
                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine("set(PACKAGE_VERSION \"" + project.version + "\")\n");
                    file.writeLine("if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)");
                    file.writeLine("    set(PACKAGE_VERSION_COMPATIBLE FALSE)");
                    file.writeLine("else()");
                    file.writeLine("    set(PACKAGE_VERSION_COMPATIBLE TRUE)");
                    file.writeLine("    if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)");
                    file.writeLine("        set(PACKAGE_VERSION_EXACT TRUE)");
                    file.writeLine("    endif()");
                    file.writeLine("endif()");
                    file.close();
                };
                return [cmd];
            }
        }

        Group {
            qbs.install: true
            qbs.installDir: FileInfo.joinPaths(lirideployment.libDir, "cmake", project.moduleName)
            fileTagsFilter: ["cmake"]
        }
    }
}
