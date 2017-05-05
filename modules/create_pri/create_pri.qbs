import qbs 1.0
import qbs.TextFile

Module {
    additionalProductTypes: ["pri"]

    Rule {
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: "qt_lib_" + product.targetName + ".pri"
            fileTags: ["pri"]
        }
        Artifact {
            filePath: "qt_lib_" + product.targetName + "_private.pri"
            fileTags: ["pri"]
        }

        prepare: {
            var commands = [];
            for (var o in outputs.pri) {
                var cmd = new JavaScriptCommand();
                cmd.description = "generating " + outputs.pri[o].fileName;
                cmd.highlight = "filegen";
                cmd.index = o;
                cmd.defines = "QT_" + product.targetName.toUpperCase() + "_LIB";
                cmd.version = project.version;
                cmd.versionParts = project.version.split('.');
                cmd.depends = product.moduleProperty("Qt", "submodules");
                cmd.rpath = product.moduleProperty("qbs", "installRoot");
                cmd.sourceCode = function() {
                    var output = outputs.pri[index];
                    var isPublic = !output.baseName.endsWith("_private");
                    var modulePrefix = "QT." + product.targetName + '.';
                    var includes = "$$QT_MODULE_INCLUDE_BASE";
                    for (var i in product.includeDependencies) { // ### use inputsFromDependencies
                        var module = product.includeDependencies[i];
                        if (isPublic && module.endsWith("-private"))
                            module = module.slice(0, -8);
                        //includes += ' ' + QtUtils.includesForModule(module, "$$QT_MODULE_INCLUDE_BASE", project.version).join(' ');

                        if (isPublic && module != product.name)
                            depends += ' ' + module.slice(2).toLowerCase();
                    }

                    var file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.writeLine(modulePrefix + "VERSION = " + version);
                    file.writeLine(modulePrefix + "MAJOR_VERSION = " + versionParts[0]);
                    file.writeLine(modulePrefix + "MINOR_VERSION = " + versionParts[1]);
                    file.writeLine(modulePrefix + "PATCH_VERSION = " + versionParts[2]);
                    file.writeLine(modulePrefix + "name = " + product.name);
                    file.writeLine(modulePrefix + "libs = $$QT_MODULE_LIB_BASE");
                    file.writeLine(modulePrefix + "includes = " + includes);
                    file.writeLine(modulePrefix + "DEFINES = " + defines);
                    if (depends)
                        file.writeLine(modulePrefix + "depends = " + depends);
                    if (isPublic) {
                        file.writeLine(modulePrefix + "bins = $$QT_MODULE_BIN_BASE");
                        file.writeLine(modulePrefix + "libexecs = $$QT_MODULE_LIBEXEC_BASE");
                        file.writeLine(modulePrefix + "plugins = $$QT_MODULE_PLUGIN_BASE");
                        file.writeLine(modulePrefix + "imports = $$QT_MODULE_IMPORT_BASE");
                        file.writeLine(modulePrefix + "qml = $$QT_MODULE_QML_BASE");
                        file.writeLine(modulePrefix + "rpath = " + rpath + "/lib");
                        file.writeLine("QT_MODULES += " + product.simpleName);
                    }
                    file.close();
                };
                commands.push(cmd);
            }
            return commands;
        }
    }
}
