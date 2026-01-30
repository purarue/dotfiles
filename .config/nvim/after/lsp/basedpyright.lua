return {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                -- typeCheckingMode = "recommended",
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    callArgumentNames = true,
                },
            },
        },
    },
}
