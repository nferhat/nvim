return {
    { "junegunn/vim-easy-align", cmd = "EasyAlign" },
    { "famiu/bufdelete.nvim", keys = { { "<leader>x", ":Bdelete!<CR>", desc = "Close buffer" } } },
    { "nvim-tree/nvim-web-devicons" },

    {
        "NvChad/nvim-colorizer.lua",
        init = require("utils").lazy_load "nvim-colorizer.lua",
        config = function()
            require("colorizer").setup { css = true }
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
    },

    {
        "echasnovski/mini.clue",
        keys = { "<leader>", "g", "d", "c" },
        config = function()
            local miniclue = require "mini.clue"
            miniclue.setup {
                window = {
                    config = {
                        border = "single",
                        style = "minimal",
                        width = "auto",
                    },
                    delay = 0,
                },
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
            }
            require("ui.theme").load_skeleton "mini-clue"
        end,
    },

    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment toggle current line" },
            { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
            { "gbc", mode = "n", desc = "Comment toggle current block" },
            { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
        },
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = true,
        opts = {
            padding = true,
            sticky = true,
            ignore = nil,
            mappings = { basic = true, extra = true },
            pre_hook = function(...)
                local supported_ft = {
                    "javascript",
                    "typescript",
                    "typescriptreact",
                    "css",
                    "scss",
                    "html",
                    "svelte",
                    "vue",
                    "graphql",
                    "lua",
                }
                -- Only use ts-context-comment-string for supported filetypes.
                if vim.tbl_contains(supported_ft, vim.bo.filetype) then
                    return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
                else
                    return nil
                end
            end,
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        init = require("utils").lazy_load "indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ui.theme").load_skeleton "indent-blankline"
            require("ibl").setup {
                indent = {
                    char = "│",
                    highlight = "IndentGuide",
                    smart_indent_cap = true,
                },
                scope = {
                    enabled = true,
                    highlight = "IndentGuideScope",
                    char = "│",
                },
            }
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local luasnip = require "luasnip"
            require("luasnip.loaders.from_vscode").lazy_load()

            luasnip.config.set_config {
                history = true,
                update_events = "InsertLeave,TextChanged,TextChangedI",
                region_check_events = "CursorHold,InsertEnter",
                delete_check_events = "TextChanged,InsertLeave",
            }

            vim.api.nvim_create_autocmd("InsertLeave", {
                group = vim.api.nvim_create_augroup("luasnip_unlink_node", {}),
                callback = function()
                    if
                        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                        and not require("luasnip").session.jump_active
                    then
                        require("luasnip").unlink_current()
                    end
                end,
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        init = function()
            -- load gitsigns only when a git file is opened
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                    if vim.v.shell_error == 0 then
                        vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                        vim.schedule(function()
                            require("lazy").load { plugins = { "gitsigns.nvim" } }
                        end)
                    end
                end,
            })
        end,
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "┃" },
                topdelete = { text = "┃" },
                changedelete = { text = "┃" },
                untracked = { text = "┃" },
            },
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
            require("ui.theme").load_skeleton "gitsigns"
        end,
    },

    {
        "alexghergh/nvim-tmux-navigation",
        lazy = not (os.getenv "TMUX" ~= nil),
        config = true,
        opts = {
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<nop>",
                next = "<nop>",
            },
        },
    },

    {
        "RRethy/nvim-treesitter-endwise",
        ft = { "lua", "bash", "vim" },
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require "notify"
            local stages = require "notify.stages.slide" "top_down"
            -- Override vim.notify so we can use nvim-notify with it.
            -- This basically allows all plugins to use nvim-notify to display any message they'd
            -- like to using notify, as long as they use vim.notify as for message logging.
            vim.notify = notify

            notify.setup {
                timeout = 4500, -- in milliseconds.
                render = "wrapped-compact",
                border = "single",
                max_width = 50,
                fps = 60, -- smoooooth
                stages = {
                    function(...)
                        local opts = stages[1](...)
                        if opts then
                            opts.border = "single"
                        end
                        return opts
                    end,
                    unpack(stages, 2),
                },
                fade_in_slide_out = true,
            }

            require("ui.theme").load_skeleton "notify"
        end,
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            local dressing = require "dressing"

            dressing.setup {
                input = { enabled = false }, -- managed by noice.nvim
                select = {
                    -- Override vim.ui.select() hook
                    enabled = true,
                    backend = { "telescope", "builtin" },
                    telescope = {
                        layout_strategy = "horizontal_edit",
                        layout_config = { width = 0.5, height = 0.3 },
                    },
                },
            }
        end,
    },

    {
        "SmiteshP/nvim-navic",
        opts = {
            highlight = true,
            icons = {
                File = " ",
                Module = " ",
                Namespace = " ",
                Package = " ",
                Class = " ",
                Method = " ",
                Property = " ",
                Field = " ",
                Constructor = " ",
                Enum = " ",
                Interface = " ",
                Function = " ",
                Variable = " ",
                Constant = " ",
                String = " ",
                Number = " ",
                Boolean = " ",
                Array = " ",
                Object = " ",
                Key = " ",
                Null = " ",
                EnumMember = " ",
                Struct = " ",
                Event = " ",
                Operator = " ",
                TypeParameter = " ",
            },
        },
        config = function(_, opts)
            require("ui.theme").load_skeleton "navic"
            require("nvim-navic").setup(opts)
        end,
    },
}
