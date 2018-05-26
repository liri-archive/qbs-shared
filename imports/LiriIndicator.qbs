import qbs 1.0

Product {
    property string shortName

    name: "Indicator (" + shortName + ")"

    Depends { name: "lirideployment" }
    Depends { name: "LiriTranslations" }

    Group {
        qbs.install: shortName != undefined
        qbs.installDir: lirideployment.dataDir + "/liri-shell/indicators/" + shortName
        fileTagsFilter: "liri.desktop.file"
    }

    Group {
        qbs.install: shortName != undefined
        qbs.installDir: lirideployment.dataDir + "/liri-shell/indicators/" + shortName + "/contents"
        fileTagsFilter: "liri.indicator.contents"
    }

    Group {
        qbs.install: shortName != undefined
        qbs.installDir: lirideployment.dataDir + "/liri-shell/indicators/" + shortName + "/translations"
        fileTagsFilter: "qm"
    }
}
