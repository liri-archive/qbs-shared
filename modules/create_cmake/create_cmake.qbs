import qbs
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.TextFile

Module {
    validate: {
        var validator = new ModUtils.PropertyValidator("create_cmake");
        validator.setRequiredProperty("version", version);
        validator.validate();
    }

    condition: qbs.targetOS.contains("linux")

    additionalProductTypes: ["cmake"]

    Rule {
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: FileInfo.joinPaths("cmake", product.targetName, product.targetName + "Config.cmake")
            fileTags: ["cmake"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "filegen";
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine('get_filename_component(PACKAGE_PREFIX_DIR \"\${CMAKE_CURRENT_LIST_DIR}/${PACKAGE_RELATIVE_PATH}\" ABSOLUTE)');
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
