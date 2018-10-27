var FileInfo = require("qbs.FileInfo");
var TextFile = require("qbs.TextFile");

function createCommands(product, type, input, outputs)
{
    var waylandScanner = "wayland-scanner";

    var hppOutput = outputs["hpp"][0];
    var hppCmd = new JavaScriptCommand();
    hppCmd.description = "wayland-scanner " + input.fileName + " -> " + hppOutput.fileName;
    hppCmd.highlight = "codegen";
    hppCmd.exe = waylandScanner;
    hppCmd.inputFilePath = input.filePath;
    hppCmd.outputFilePath = hppOutput.filePath;
    hppCmd.type = type === "client" ? "client-header" : "server-header";
    hppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(outputFilePath));
            var hppArgs = [type, inputFilePath, outputFilePath];
            p.exec(exe, hppArgs, true);
        } finally {
            p.close();
        }
    };

    var cppOutput = outputs["c"][0];
    var cppCmd = new JavaScriptCommand();
    cppCmd.description = "wayland-scanner " + input.fileName + " -> " + cppOutput.fileName;
    cppCmd.highlight = "codegen";
    cppCmd.exe = waylandScanner;
    cppCmd.inputFilePath = input.filePath;
    cppCmd.outputFilePath = cppOutput.filePath;
    cppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(outputFilePath));
            var cppArgs = ["code", inputFilePath, outputFilePath];
            p.exec(exe, cppArgs, true);
        } finally {
            p.close();
        }
    };

    return [hppCmd, cppCmd];
}

function createQtCommands(product, type, input, outputs)
{
    var qtwaylandScanner = product.Qt.core.binPath + '/' + "qtwaylandscanner";

    var hppOutput = outputs["hpp"][0];
    var hppCmd = new JavaScriptCommand();
    hppCmd.description = "qtwaylandscanner " + input.fileName + " -> " + hppOutput.fileName;
    hppCmd.highlight = "codegen";
    hppCmd.exe = qtwaylandScanner;
    hppCmd.inputFilePath = input.filePath;
    hppCmd.outputFilePath = hppOutput.filePath;
    hppCmd.type = type === "client" ? "client-header" : "server-header";
    hppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(outputFilePath));
            var hppArgs = [type, inputFilePath, ""];
            p.exec(exe, hppArgs, true);
            var file = new TextFile(outputFilePath, TextFile.WriteOnly);
            file.write(p.readStdOut());
            file.close();
        } finally {
            p.close();
        }
    };

    var cppOutput = outputs["cpp"][0];
    var cppCmd = new JavaScriptCommand();
    cppCmd.description = "qtwaylandscanner " + input.fileName + " -> " + cppOutput.fileName;
    cppCmd.highlight = "codegen";
    cppCmd.exe = qtwaylandScanner;
    cppCmd.inputFilePath = input.filePath;
    cppCmd.outputFilePath = cppOutput.filePath;
    cppCmd.type = type === "client" ? "client-code" : "server-code";
    cppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(outputFilePath));
            var cppArgs = [type, inputFilePath, ""];
            p.exec(exe, cppArgs, true);
            var file = new TextFile(outputFilePath, TextFile.WriteOnly);
            file.write(p.readStdOut());
            file.close();
        } finally {
            p.close();
        }
    };

    return [hppCmd, cppCmd];
}
