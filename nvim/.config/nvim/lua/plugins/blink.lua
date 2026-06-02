-- In ~/.config/nvim/lua/plugins/blink-cmp.lua

return {
    "saghen/blink.cmp",
    opts = function(_, opts)
        -- This is the correct keymap section
        opts.keymap = {
            -- This is the "smart-tab" you want.
            -- It tries to select the next item, OR jump to a snippet,
            -- OR fallback to a normal tab.
            ["<Tab>"] = { "accept", "fallback" },
            ["<CR>"] = { "fallback" },
            ["<S-Tab>"] = { "select_prev" },
            ["<C-j>"] = { "select_next" },
            ["<C-k>"] = { "select_prev" },
            ["<C-y>"] = { "select_and_accept" },
        }

        -- UN-COMMENT ALL YOUR OTHER SETTINGS
        local provider_priorities = {
            lsp = { score_offset = 1000 },
            lazydev = { score_offset = 1000 },
            snippets = { score_offset = 1000 },
            copilot = { score_offset = 0 },
            buffer = { score_offset = 1000 },
            path = { score_offset = 1000 },
        }

        opts.sources.providers = vim.tbl_deep_extend("keep", opts.sources.providers or {}, provider_priorities)

        opts.sources.default = {
            "lazydev",
            "lsp",
            "snippets",
            "copilot",
            "buffer",
            "path",
        }
        return opts
    end,
}
