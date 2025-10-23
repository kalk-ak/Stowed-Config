return {
    "neovim/nvim-lspconfig",
    opts = {
        -- This is the table of default LSP keys
        keys = {
            -- Disable the conflicting <c-k> insert mode mapping
            { "<c-k>", false, mode = "i" },
        },
    },
}
