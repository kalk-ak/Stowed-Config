return {
    -- Override the NeoVim Autocompletion so that Shift + Enter doesn't trigger Autocompletion
    "hrsh7th/nvim-cmp",
    -- The `opts` function is the LazyVim way to modify the plugin's options
    opts = function(_, opts)
        local cmp = require("cmp")

        -- Use tab for selectiong Autocompletion instead
        opts.mapping["<Tab>"] = cmp.mapping.confirm({ select = true })

        -- 2. Unbind Enter (<CR>) and Shift+Enter (<S-CR>) from completion.
        -- We assign our newline behavior to both keys.
        opts.mapping["<CR>"] = newline_behavior
    end,
}
