import qbs
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.TextFile
import "cmake.js" as CMake

Module {
    property string title: product.targetName
    PropertyOptions {
        name: "title"
        description: "Verbose package name"
    }

    property string targetName: product.targetName
    PropertyOptions {
        name: "targetName"
        description: "Target name"
    }

    property string targetNamespace: product.targetName
    PropertyOptions {
        name: "targetNamespace"
        description: "Target namespace"
    }

    property var dependencies: ({})
    PropertyOptions {
        name: "dependencies"
        description: "CMake dependencies"
    }

    property stringList linkLibraries
    PropertyOptions {
        name: "linkLibraries"
        description: "Interface link libraries"
    }

    validate: {
        var validator = new ModUtils.PropertyValidator("create_cmake");
        validator.setRequiredProperty("title", title);
        validator.setRequiredProperty("version", version);
        validator.setRequiredProperty("targetName", targetName);
        validator.setRequiredProperty("targetNamespace", targetNamespace);
        validator.validate();
    }

    condition: qbs.targetOS.contains("linux")

    additionalProductTypes: ["cmake"]

    Rule {
        multiplex: true
        inputs: ["dynamiclibrary", "public_headers"]

        Artifact {
            filePath: FileInfo.joinPaths("cmake", product.targetName, product.targetName + "Config.cmake")
            fileTags: ["cmake"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "filegen";
            cmd.pkgTitle = ModUtils.moduleProperty(product, "title");
            cmd.pkgVersion = ModUtils.moduleProperty(product, "version");
            cmd.targetName = ModUtils.moduleProperty(product, "targetName");
            cmd.targetNamespace = ModUtils.moduleProperty(product, "targetNamespace");
            cmd.dependencies = ModUtils.moduleProperty(product, "dependencies");
            cmd.linkLibraries = ModUtils.moduleProperty(product, "linkLibraries");
            cmd.installRoot = product.moduleProperty("qbs", "installRoot");
            cmd.sourceCode = function() {
                var incDir = FileInfo.joinPaths(inputs.public_headers[0].moduleProperty("qbs", "installPrefix"),
                                                inputs.public_headers[0].moduleProperty("qbs", "installDir"));
                var libDir = FileInfo.joinPaths(inputs.dynamiclibrary[0].moduleProperty("qbs", "installPrefix"),
                                                inputs.dynamiclibrary[0].moduleProperty("qbs", "installDir"));
                var findDeps = "";
                for (var dep in dependencies) {
                    findDeps += "find_dependency(" + dep + " \"" + dependencies[dep] + "\")\n";
                }
                var linkLibs = "";
                if (linkLibraries.length > 0)
                    linkLibs = linkLibraries.join(";");

                var vars = {
                    TITLE: pkgTitle,
                    TARGET_NAME: targetName,
                    TARGET_NAMESPACE: targetNamespace,
                    VERSION: pkgVersion,
                    INSTALL_ROOT: installRoot,
                    INCLUDE_DIR: incDir,
                    LIB_DIR: libDir,
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
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: FileInfo.joinPaths("cmake", product.targetName, product.targetName + "ConfigVersion.cmake")
            fileTags: ["cmake"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "filegen";
            cmd.pkgVersion = ModUtils.moduleProperty(product, "version");
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("set(PACKAGE_VERSION " + pkgVersion + ")\n");
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
}
