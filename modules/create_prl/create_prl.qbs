import qbs
import qbs.FileInfo
import qbs.ModUtils
import qbs.PathTools
import qbs.TextFile

Module {
    additionalProductTypes: ["prl"]

    Rule {
        inputs: ["dynamiclibrary"]

        Artifact {
            filePath: FileInfo.joinPaths(product.buildDirectory, "lib", FileInfo.baseName(PathTools.dynamicLibraryFilePath(product)) + ".prl")
            fileTags: ["prl"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "filegen";
            cmd.buildDir = product.buildDirectory;
            cmd.targetName = PathTools.dynamicLibraryFilePath(product);
            cmd.version = product.moduleProperty("cpp", "internalVersion");
            cmd.libs = product.moduleProperty("cpp", "dynamicLibraries").join(" -l");
            if (cmd.libs.length > 0)
                cmd.libs = "-l" + cmd.libs;
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.writeLine("QMAKE_PRL_BUILD_DIR = " + buildDir);
                file.writeLine("QMAKE_PRL_TARGET = " + targetName);
                file.writeLine("QMAKE_PRL_VERSION = " + version);
                file.writeLine("QMAKE_PRL_LIBS = " + libs);
                file.close();
            };
            return [cmd];
        }
    }
}
