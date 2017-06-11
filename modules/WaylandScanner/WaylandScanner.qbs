import qbs
import qbs.FileInfo
import qbs.Process
import qbs.TextFile
import "scanner.js" as Scanner

Module {
    Rule {
        inputs: ["wayland.client.protocol"]

        Artifact {
            filePath: FileInfo.joinPaths(product.moduleProperty("Qt.core", "generatedHeadersDir"),
                                         "wayland-" + FileInfo.baseName(input.fileName) + "-client-protocol.h")
            fileTags: ["hpp", "hpp_private"]
        }
        Artifact {
            filePath: "wayland-" + FileInfo.baseName(input.fileName) + "-protocol.c"
            fileTags: ["c"]
        }

        prepare: {
            return Scanner.createCommands(product, "client", input, outputs);
        }
    }

    Rule {
        inputs: ["wayland.client.protocol"]

        Artifact {
            filePath: FileInfo.joinPaths(product.moduleProperty("Qt.core", "generatedHeadersDir"),
                                         "qwayland-" + FileInfo.baseName(input.fileName) + ".h")
            fileTags: ["hpp", "hpp_private"]
        }
        Artifact {
            filePath: "qwayland-" + FileInfo.baseName(input.fileName) + ".cpp"
            fileTags: ["cpp"]
        }

        prepare: {
            return Scanner.createQtCommands(product, "client", input, outputs);
        }
    }

    Rule {
        inputs: ["wayland.server.protocol"]

        Artifact {
            filePath: FileInfo.joinPaths(product.moduleProperty("Qt.core", "generatedHeadersDir"),
                                         "wayland-" + FileInfo.baseName(input.fileName) + "-server-protocol.h")
            fileTags: ["hpp", "hpp_private"]
        }
        Artifact {
            filePath: "wayland-" + FileInfo.baseName(input.fileName) + "-protocol.c"
            fileTags: ["c"]
        }

        prepare: {
            return Scanner.createCommands(product, "server", input, outputs);
        }
    }

    Rule {
        inputs: ["wayland.server.protocol"]

        Artifact {
            filePath: FileInfo.joinPaths(product.moduleProperty("Qt.core", "generatedHeadersDir"),
                                         "qwayland-server-" + FileInfo.baseName(input.fileName) + ".h")
            fileTags: ["hpp", "hpp_private"]
        }
        Artifact {
            filePath: "qwayland-server-" + FileInfo.baseName(input.fileName) + ".cpp"
            fileTags: ["cpp"]
        }

        prepare: {
            return Scanner.createQtCommands(product, "server", input, outputs);
        }
    }
}
