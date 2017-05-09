import qbs 1.0
import qbs.File
import qbs.FileInfo
import qbs.ModUtils
import qbs.Process
import qbs.TextFile

Module {
    // Input
    property string sourceDirectory

    // Output
    property string revision

    Depends { name: "cpp" }

    cpp.includePaths: [product.buildDirectory]

    Rule {
        inputs: ["liri.gitsha"]
        alwaysRun: true
        condition: sourceDirectory !== undefined

        Artifact {
            filePath: product.buildDirectory + "/gitsha1.h"
            fileTags: ["hpp"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "generating " + output.fileName;
            cmd.highlight = "codegen";
            cmd.sourceCode = function() {
                var sourceDirectory = ModUtils.moduleProperty(product, "sourceDirectory");

                if (File.exists(FileInfo.joinPaths(sourceDirectory, ".git"))) {
                    var p = new Process();
                    try {
                        p.setEnv("LC_ALL", "C");
                        p.setWorkingDirectory(sourceDirectory);
                        p.exec("git", ["rev-parse", "HEAD"]);
                        revision = p.readStdOut().trim();
                        if (!revision)
                            revision = "unknown";
                    } finally {
                        p.close();
                    }
                } else {
                    revision = "tarball";
                }

                var inFile = new TextFile(input.filePath, TextFile.ReadOnly);
                var contents = inFile.readAll();
                inFile.close();

                var vars = {
                    REVISION: revision
                };
                for (var i in vars)
                    contents = contents.replace(new RegExp('@' + i + '@(?!\w)', 'g'), vars[i]);

                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write(contents);
                file.close();
            };
            return [cmd];
        }
    }
}
