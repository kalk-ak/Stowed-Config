-- In ~/.config/nvim/lua/plugins/blink-cmp.lua

return {
    "saghen/blink.cmp",
    opts = function(_, opts)
        -- Keep your keymap section exactly as is
        opts.keymap = {
            ["<Tab>"] = { "accept", "fallback" },
            ["<CR>"] = { "fallback" },
            ["<S-Tab>"] = { "select_prev" },
            ["<C-j>"] = { "select_next" },
            ["<C-k>"] = { "select_prev" },
            ["<C-y>"] = { "select_and_accept" },
        }

        -- 1. Setup your provider priorities and define the dadbod provider
        local provider_priorities = {
            lsp = { score_offset = 1000 },
            lazydev = { score_offset = 1000 },
            snippets = { score_offset = 1000 },
            copilot = { score_offset = 0 },
            buffer = { score_offset = 1000 },
            path = { score_offset = 1000 },
            -- Tell blink how to load dadbod and give it a high priority
            dadbod = {
                name = "Dadbod",
                module = "vim_dadbod_completion.blink",
                score_offset = 2000, -- Make database suggestions appear first
            },
        }

        opts.sources.providers = vim.tbl_deep_extend("keep", opts.sources.providers or {}, provider_priorities)

        -- 2. Keep your general default sources intact
        opts.sources.default = {
            "lazydev",
            "lsp",
            "snippets",
            "copilot",
            "buffer",
            "path",
        }

        -- 3. Define the SQL file type override
        -- This ensures dadbod only runs on sql files alongside your defaults
        opts.sources.per_filetype = {
            sql = { "dadbod", "lsp", "snippets", "buffer" },
            mysql = { "dadbod", "lsp", "snippets", "buffer" },
            plsql = { "dadbod", "lsp", "snippets", "buffer" },
        }

        return opts
    end,
}
