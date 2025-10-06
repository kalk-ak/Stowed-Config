-- The conflicting `config` function has been removed to ensure `opts` are respected.
return {
    "saghen/blink.cmp",
    opts = {
        snippets = {
            expand = function(snippet, _)
                return LazyVim.cmp.expand(snippet)
            end,
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = vim.g.ai_cmp,
            },
        },
        sources = {
            compat = {},
            default = { "lsp", "snippets", "path", "buffer", "copilot" },
        },
        cmdline = {
            enabled = false,
        },
        keymap = {
            ["<C-Space>"] = { "show" },
            ["<Tab>"] = { "accept", "fallback" },
            ["<CR>"] = { "fallback" },
            ["<S-Tab>"] = { "select_prev" },
            ["<C-j>"] = { "select_next" },
            ["<C-k>"] = { "select_prev" },
            ["<C-y>"] = { "select_and_accept" },
        },
    },
    -- NOTE: The entire `config = function(...)` block has been removed to prevent
    -- it from overriding the `opts` table above. This is the key to the solution.
}
