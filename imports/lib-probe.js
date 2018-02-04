var Environment = require("qbs.Environment");
var File = require("qbs.File");
var FileInfo = require("qbs.FileInfo");
var ModUtils = require("qbs.ModUtils");

function configure(names, platformPaths, pathSuffixes, environmentPaths, pathListSeparator) {
    var result = { found: false, candidatePaths: [], filePaths: [], paths: [] };
    if (!names)
        throw "'names' must be specified";

    var _paths = ModUtils.concatAll(platformPaths);
    for (var i = 0; i < environmentPaths.length; ++i) {
        var value = Environment.getEnv(environmentPaths[i]) || '';
        if (value.length > 0)
            _paths = _paths.concat(value.split(pathListSeparator));
    }

    var _suffixes = ModUtils.concatAll("", pathSuffixes);
    _paths = _paths.map(function(p) { return FileInfo.fromNativeSeparators(p); });
    _suffixes = _suffixes.map(function(p) { return FileInfo.fromNativeSeparators(p); });
    for (i = 0; i < names.length; ++i) {
        for (var j = 0; j < _paths.length; ++j) {
            for (var k = 0; k < _suffixes.length; ++k) {
                var _filePath = FileInfo.joinPaths(_paths[j], _suffixes[k], names[i]);
                result.candidatePaths.push(_filePath);
                console.debug("LiriLibraryProbe: Trying " + _filePath);
                if (File.exists(_filePath)) {
                    var _path = FileInfo.joinPaths(_paths[j], _suffixes[k]);

                    result.found = true;
                    result.filePaths.push(_filePath);
                    result.paths.push(_path);

                    console.debug("LiriLibraryProbe: Found " + _filePath);
                    console.debug("LiriLibraryProbe: Returning path " + _path);
                }
            }
        }
    }

    return result;
}
