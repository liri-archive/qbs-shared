import qbs

LiriPathProbe {
    pathSuffixes: ["lib", "lib64"]
    environmentPaths: base.concat(["LIBRARY_PATH"])
}
