-- Add more reliable keymaps for debugging
-- Target the nvim-dap plugin to modify its configuration
return {
    "mfussenegger/nvim-dap",

    -- The 'keys' table holds your custom keymaps.
    -- LazyVim will merge these with the defaults.

    keys = {
        {
            "<f1>",
            function()
                require("dap").step_into()
            end,
            desc = "debug: step into",
        },
        {
            "<f2>",
            function()
                require("dap").step_over()
            end,
            desc = "debug: step over",
        },
        {
            "<f3>",
            function()
                require("dap").step_out()
            end,
            desc = "debug: step out",
        },

        {
            "<f4>",
            function()
                require("dap").step_back()
            end,
            desc = "debug: step back",
        },
    },
}
