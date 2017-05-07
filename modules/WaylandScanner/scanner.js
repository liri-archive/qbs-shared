var FileInfo = loadExtension("qbs.FileInfo");
var TextFile = loadExtension("qbs.TextFile");

function createCommands(product, type, input, outputs)
{
    var waylandScanner = "wayland-scanner";

    var hppOutput = outputs["hpp"][0];
    var hppCmd = new JavaScriptCommand();
    hppCmd.description = "wayland-scanner " + input.fileName + " -> " + hppOutput.fileName;
    hppCmd.highlight = "codegen";
    hppCmd.exe = waylandScanner;
    hppCmd.hppOutput = hppOutput;
    hppCmd.type = type === "client" ? "client-header" : "server-header";
    hppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(hppOutput.filePath));
            var hppArgs = [type, input.filePath, hppOutput.filePath];
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
    cppCmd.cppOutput = cppOutput;
    cppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(cppOutput.filePath));
            var cppArgs = ["code", input.filePath, cppOutput.filePath];
            p.exec(exe, cppArgs, true);
        } finally {
            p.close();
        }
    };

    return [hppCmd, cppCmd];
}

function createQtCommands(product, type, input, outputs)
{
    var qtwaylandScanner = product.moduleProperty("Qt.core", "binPath") + '/' + "qtwaylandscanner";

    var hppOutput = outputs["hpp"][0];
    var hppCmd = new JavaScriptCommand();
    hppCmd.description = "qtwaylandscanner " + input.fileName + " -> " + hppOutput.fileName;
    hppCmd.highlight = "codegen";
    hppCmd.exe = qtwaylandScanner;
    hppCmd.hppOutput = hppOutput;
    hppCmd.type = type === "client" ? "client-header" : "server-header";
    hppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(hppOutput.filePath));
            var hppArgs = [type, input.filePath, ""];
            p.exec(exe, hppArgs, true);
            var file = new TextFile(hppOutput.filePath, TextFile.WriteOnly);
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
    cppCmd.cppOutput = cppOutput;
    cppCmd.type = type === "client" ? "client-code" : "server-code";
    cppCmd.sourceCode = function() {
        var p = new Process();
        try {
            p.setEnv("LC_ALL", "C");
            p.setWorkingDirectory(FileInfo.path(cppOutput.filePath));
            var cppArgs = [type, input.filePath, ""];
            p.exec(exe, cppArgs, true);
            var file = new TextFile(cppOutput.filePath, TextFile.WriteOnly);
            file.write(p.readStdOut());
            file.close();
        } finally {
            p.close();
        }
    };

    return [hppCmd, cppCmd];
}
