return {
    settings = {
        yaml = {
            keyOrdering = false,
            schemaStore = {
                -- Disable built-in schemaStore support
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
}
