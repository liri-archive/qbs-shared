import qbs
import qbs.File
import qbs.FileInfo
import qbs.ModUtils
import qbs.TextFile

Module {
    property string generatedHeadersDir
    PropertyOptions {
        name: "generatedHeadersDir"
        description: "path where generated headers are saved"
    }

    property var headersMap: ({})
    PropertyOptions {
        name: "headersMap"
        description: "map public headers to class names"
    }

    validate: {
        var validator = new ModUtils.PropertyValidator("create_headers");
        validator.setRequiredProperty("generatedHeadersDir", generatedHeadersDir);
        validator.setRequiredProperty("headersMap", headersMap);
        validator.validate();
    }

    additionalProductTypes: ["class_headers"]

    Rule {
        inputs: ["public_headers"]
        excludedAuxiliaryInputs: ["unmocable"]
        alwaysRun: true

        Artifact {
            filePath: FileInfo.joinPaths(ModUtils.moduleProperty(product, "generatedHeadersDir"), product.targetName, input.fileName)
            fileTags: ["hpp"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "copying " + output.fileName;
            cmd.extendedDescription = "Copying " + output.fileName + " to " + output.filePath;
            cmd.highlight = "filegen";
            cmd.sourceCode = function() {
                File.makePath(FileInfo.path(output.filePath));
                File.copy(input.filePath, output.filePath);
            };
            return [cmd];
        }
    }

    Rule {
        inputs: ["public_headers"]
        excludedAuxiliaryInputs: ["unmocable"]
        alwaysRun: true
        outputArtifacts: {
            var headersMap = ModUtils.moduleProperty(product, "headersMap");
            var generatedHeadersDir = ModUtils.moduleProperty(product, "generatedHeadersDir");
            var artifacts = [];
            if (headersMap.hasOwnProperty(input.fileName)) {
                var artifact = {
                    filePath: FileInfo.joinPaths(generatedHeadersDir, product.targetName, headersMap[input.fileName]),
                    fileTags: ["class_headers"]
                };
                artifacts.push(artifact);
            }
            return artifacts;
        }
        outputFileTags: ["class_headers"]
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "creating class header " + output.fileName;
            cmd.extendedDescription = "Creating class header " + output.fileName;
            cmd.highlight = "filegen";
            cmd.sourceCode = function() {
                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.write('#include "' + product.targetName + "/" + input.fileName + '"');
                file.close();
            };
            return [cmd];
        }
    }

    Rule {
        inputs: ["private_headers"]
        excludedAuxiliaryInputs: ["unmocable"]
        alwaysRun: true

        Artifact {
            filePath: FileInfo.joinPaths(ModUtils.moduleProperty(product, "generatedHeadersDir"), product.targetName, "private", input.fileName)
            fileTags: ["hpp"]
        }

        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "copying " + output.fileName;
            cmd.extendedDescription = "Copying " + output.fileName + " to " + output.filePath;
            cmd.highlight = "filegen";
            cmd.sourceCode = function() {
                File.makePath(FileInfo.path(output.filePath));
                File.copy(input.filePath, output.filePath);
            };
            return [cmd];
        }
    }
}
