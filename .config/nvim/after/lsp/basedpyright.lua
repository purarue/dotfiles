return {
    settings = {
        basedpyright = {
            analysis = {
                diagnosticSeverityOverrides = {
                    reportAny = false,
                    reportUnusedCallResult = false,
                    reportUnknownParameterType = false,
                    reportUnknownVariableType = false,
                    reportExplicitAny = false,
                    reportUnknownMemberType = false,
                    reportPrivateLocalImportUsage = false,
                },
                autoSearchPaths = true,
                typeCheckingMode = "recommended",
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    callArgumentNames = true,
                },
            },
        },
    },
}
