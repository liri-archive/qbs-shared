// Utilities

function includesForModule(moduleName, base, version) {
    var includes = [base, base  + "/" + moduleName];
    includes.push(base + "/" + moduleName + "/" + version);
    includes.push(base + "/" + moduleName + "/" + version + "/" + moduleName);
    includes.push(base + "/" + moduleName + "/" + version + "/" + moduleName + "/private");
    return includes;
}

function quote(stringValue) {
    return '"' + stringValue.replace('"', '\\"') + '"';
}

function stripSysroot(stringValue) {
    return stringValue.replace(qbs.sysroot, "");
}

function prependSysroot(stringValue) {
    if (qbs.sysroot)
        return qbs.sysroot + stripSysroot(stringValue);
    return stringValue;
}

/* Performs a basic conversion from a JS Object to static QML, listing the key
   on the left and the value on the right. Object values are expanded into types.
   If the key to an Array is a recognized Qbs type (e.g. Depends), it is expanded
  into instances of that type. All other values are also assigned directly. */
function jsToQml(content, indentLevel) {
    var qml = "";
    indentLevel = indentLevel || 1;
    for (var key in content) {
        var indent = (new Array(indentLevel)).join('    ');
        var value = content[key];
        switch (typeof value) {
        case "object":
            if (value instanceof Array) {
                var expandTypeArray = key === "Depends";
                if (expandTypeArray) {
                    value.forEach(function (item) {
                        qml += indent + key + ' {\n' + jsToQml(item, indentLevel + 1) + indent + '}\n';
                    });
                } else {
                    qml += indent + key + ': [' + value.map(stripSysroot).join(', ') + ']' + (key == "cpp.includePaths" ? '.map(LiriUtils.prependSysroot)' : '') + '\n';
                }
                break;
            }
            qml += indent + key + ' {\n' + jsToQml(value, indentLevel + 1) + indent + '}\n';
            break;
        default:
            qml += indent + key + ': ' + value + '\n';
            break;
        }
    }
    return qml;
}
