import qbs 1.0
import qbs.File
import qbs.TextFile

Module {
    additionalProductTypes: ["liri.desktop.file"]

    Rule {
        multiplex: true
        inputs: ["liri.desktop.template", "liri.desktop.translations"]

        outputArtifacts: {
            var artifacts = [];
            for (var i in inputs["liri.desktop.template"]) {
                var input = inputs["liri.desktop.template"][i];
                var artifact = {
                    filePath: input.fileName.replace(".in", ""),
                    fileTags: ["liri.desktop.file"]
                };
                artifacts.push(artifact);
            }
            return artifacts;
        }
        outputFileTags: ["liri.desktop.file"]

        prepare: {
            var cmds = [];
            for (var i in inputs["liri.desktop.template"]) {
                var input = inputs["liri.desktop.template"][i];
                var cmd = new JavaScriptCommand();
                cmd.description = "merge translations of " + input.filePath;
                cmd.highlight = "filegen";
                cmd.inputFilePath = input.filePath;
                cmd.sourceCode = function() {
                    // Collect translations
                    var translations = "";
                    for (var j in inputs["liri.desktop.translations"]) {
                        var t = inputs["liri.desktop.translations"][j];
                        var file = new TextFile(t.filePath, TextFile.ReadOnly);
                        while (!file.atEof()) {
                            var line = file.readLine();
                            var re = /\w+\[\w+\]=/
                            if (line.match(re))
                                translations += line + "\n";
                        }
                        file.close();
                    }

                    // Replace marker with translations
                    var contents = "";
                    var file = new TextFile(inputFilePath, TextFile.ReadOnly);
                    while (!file.atEof()) {
                        var line = file.readLine();
                        var re = /#TRANSLATIONS/;
                        if (line.match(re))
                            contents += translations;
                        else
                            contents += line + "\n";
                    }
                    file.close();
                    file = new TextFile(output.filePath, TextFile.WriteOnly);
                    file.write(contents);
                    file.close();
                };
                cmds.push(cmd);
            }
            return cmds;
        }
    }
}
