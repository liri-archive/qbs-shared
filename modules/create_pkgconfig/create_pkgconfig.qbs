import qbs
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.TextFile

Module {
    property string name: product.targetName
    PropertyOptions {
        name: "name"
        description: "pkg-config name"
    }

    property string description
    PropertyOptions {
        name: "description"
        description: "pkg-config description"
    }

    property string includeDir: "include"
    PropertyOptions {
        name: "includeDir"
        description: "include directory relative to prefix"
    }

    property string libDir: "lib"
    PropertyOptions {
        name: "libDir"
        description: "library directory relative to prefix"
    }

    property stringList dependencies
    PropertyOptions {
        name: "dependencies"
        description: "pkg-config dependencies"
    }

    validate: {
        var validator = new ModUtils.PropertyValidator("create_pkgconfig");
        validator.setRequiredProperty("version", version);
        validator.setRequiredProperty("name", name);
        validator.setRequiredProperty("description", description);
        validator.setRequiredProperty("includeDir", includeDir);
        validator.setRequiredProperty("libDir", libDir);
        validator.validate();
    }

    condition: qbs.targetOS.contains("linux")

    additionalProductTypes: ["pkgconfig"]

    Rule {
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: product.targetName + ".pc"
            fileTags: ["pkgconfig"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "filegen";
            cmd.prefix = output.moduleProperty("qbs", "installRoot");
            cmd.targetName = PathTools.dynamicLibraryFilePath(product);
            cmd.pkgVersion = ModUtils.moduleProperty(product, "version");
            cmd.pkgName = ModUtils.moduleProperty(product, "name");
            cmd.pkgDescription = ModUtils.moduleProperty(product, "description");
            cmd.libDir = ModUtils.moduleProperty(product, "libDir");
            cmd.includeDir = ModUtils.moduleProperty(product, "includeDir");
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("prefix=" + prefix);
                file.writeLine("exec_prefix=${prefix}");
                file.writeLine("libdir=${prefix}/" + libDir);
                file.writeLine("includedir=${prefix}/" + includeDir);
                file.writeLine("");
                file.writeLine("Name: " + pkgName);
                file.writeLine("Description: " + pkgDescription);
                file.writeLine("Version: " + pkgVersion);
                file.writeLine("Libs: -L${libdir} -l" + product.targetName);
                file.writeLine("Cflags: -I${includedir} -I${includedir}/" + product.targetName);

                var deps = ModUtils.moduleProperty(product, "dependencies");
                if (deps.length > 0)
                    file.write("Requires: " + deps.join(" ") + "\n");

                file.close();
            };
            return [cmd];
        }
    }
}
