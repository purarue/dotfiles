return {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "off",
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    callArgumentNames = true,
                },
            },
        },
    },
}
