return {
    -- -- 1) Jupytext bridge: open/edit .ipynb as text. NOW HANDLED BY MASON
    {
        "goerz/jupytext.nvim",
        lazy = false, -- do NOT lazy-load, or .ipynb opens as raw JSON
        opts = {}, -- defaults are fine to start (markdown format)
    },

    -- 2) Image rendering (inline plots in Neovim)
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- or "ueberzug", etc., depending on your terminal
            -- max_width = 120,
            -- max_height = 40,
            max_width_window_percentage = 70,
            max_height_window_percentage = 70,
        },
    },
    {
        "benlubas/molten-nvim",
        build = ":UpdateRemotePlugins", -- registers the remote plugin
        dependencies = {
            "3rd/image.nvim",
        },
        init = function()
            -- How output is displayed
            vim.g.molten_image_provider = "image.nvim" -- use image.nvim for images
            vim.g.molten_virt_text_output = true -- show output as virtual text
            vim.g.molten_output_virt_lines = true -- pad so float doesn’t cover code
            vim.g.molten_auto_open_output = true -- open float when entering a cell
            vim.g.molten_output_win_border = { "", "━", "", "" }

            -- Tunables you can tweak later
            vim.g.molten_tick_rate = 200 -- more responsive UI
            vim.g.molten_use_border_highlights = true -- colored borders per status
        end,
        config = function()
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
            end

            ------------------------------------------------------------------
            -- Helper: run fenced ```python ... ``` block as a "cell"
            ------------------------------------------------------------------
            local function run_fenced_python_cell()
                local bufnr = vim.api.nvim_get_current_buf()
                local cur_line = vim.api.nvim_win_get_cursor(0)[1] -- 1-based
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local n = #lines

                -- 1) find starting ```python fence above cursor
                local start = cur_line
                while start >= 1 do
                    local line = lines[start]
                    if line and line:match("^```%s*python") then
                        break
                    end
                    start = start - 1
                end
                if start < 1 or not (lines[start] and lines[start]:match("^```%s*python")) then
                    vim.notify("No ```python fence found above cursor", vim.log.levels.WARN)
                    return
                end

                -- 2) find closing ``` fence below cursor
                local finish = cur_line
                while finish <= n do
                    local line = lines[finish]
                    if finish ~= start and line and line:match("^```%s*$") then
                        break
                    end
                    finish = finish + 1
                end
                if finish > n or not (lines[finish] and lines[finish]:match("^```%s*$")) then
                    vim.notify("No closing ``` fence found below cursor", vim.log.levels.WARN)
                    return
                end

                -- code is between start+1 and finish-1 (1-based)
                local code_start = start + 1
                local code_end = finish - 1
                if code_start > code_end then
                    vim.notify("Empty fenced code block", vim.log.levels.WARN)
                    return
                end

                -- 3) visually select the code range
                -- go to start line, start VISUAL LINE mode
                vim.api.nvim_win_set_cursor(0, { code_start, 0 })
                vim.cmd("normal! V")
                -- extend selection to end line
                vim.api.nvim_win_set_cursor(0, { code_end, 0 })

                -- 4) now call :MoltenEvaluateVisual as if typed in visual mode
                local keys = vim.api.nvim_replace_termcodes(":MoltenEvaluateVisual<CR>", true, false, true)
                vim.api.nvim_feedkeys(keys, "x", false)
            end

            ------------------------------------------------------------------
            -- Keymaps (all <localleader> + single key)
            ------------------------------------------------------------------

            -- Kernel lifecycle: run ONCE per buffer
            map("n", "<localleader>k", ":MoltenInit<CR>", "Molten: init kernel")
            map("n", "<localleader>i", ":MoltenInterrupt<CR>", "Molten: interrupt kernel")
            map("n", "<localleader>R", ":MoltenRestart<CR>", "Molten: restart kernel")

            -- Run code
            map("n", "<localleader>l", ":MoltenEvaluateLine<CR>", "Molten: run current line")
            map("n", "<localleader>c", run_fenced_python_cell, "Molten: run fenced python cell")
            map("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", "Molten: evaluate motion")
            map("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", "Molten: run selection")

            -- Cells & output management
            map("n", "<localleader>d", ":MoltenDelete<CR>", "Molten: delete cell / output")
            map("n", "<localleader>o", ":noautocmd MoltenEnterOutput<CR>", "Molten: focus output window")
            map("n", "<localleader>h", ":MoltenHideOutput<CR>", "Molten: hide output")
        end,
    },
    -- 4) Optional: quarto + LSP for code blocks in markdown notebooks
    {
        "quarto-dev/quarto-nvim",
        ft = { "quarto", "markdown" },
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter", -- otter needs treesitter injections
        },
        opts = {
            lspFeatures = {
                enabled = true,
                languages = { "python", "bash", "julia", "r" },
                diagnostics = { enabled = true },
            },
        },
        config = function(_, opts)
            -- normal quarto setup
            require("quarto").setup(opts)

            local otter = require("otter")

            -- when a markdown/quarto buffer is opened…
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "quarto" },
                callback = function(args)
                    local bufnr = args.buf
                    local name = vim.api.nvim_buf_get_name(bufnr)

                    -- only do this for .ipynb buffers (i.e., your notebooks)
                    if not name:match("%.ipynb$") then
                        return
                    end

                    -- turn on otter for python (and friends) in this notebook
                    -- (completion=true, diagnostics=true)
                    otter.activate({ "python", "bash", "julia", "r" }, true, true)
                end,
            })
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        main = "render-markdown",
        ft = { "markdown", "quarto" }, -- includes ipynb-as-markdown
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            -- pick ONE icon provider; LazyVim already uses web-devicons by default
            "nvim-tree/nvim-web-devicons",
            -- or, if you want full mini.nvim instead:
            -- "nvim-mini/mini.nvim",
        },
        ---@type render.md.UserConfig
        opts = {
            -- Mimic LazyVim’s style a bit (optional, but nice)
            preset = "lazy",

            -- Filetypes to actually render on
            file_types = { "markdown", "quarto" }, -- ipynb → markdown, so this hits notebooks

            -- Only render in normal / command modes; keep insert raw
            render_modes = { "n", "c" },

            anti_conceal = {
                enabled = true,
                above = 0,
                below = 0,
            },

            -- LaTeX block rendering
            latex = {
                enabled = true,
                -- Use either utftex or latex2text, whichever is installed first
                converter = { "pylatexenc", "utftex", "latex2text" },
                highlight = "RenderMarkdownMath",
                position = "center", -- render inline with the block (default)
            },
        },
    },
}
