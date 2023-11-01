local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = require("utils").lazy_load "nvim-treesitter",
}

function M.config()
    local treesitter_configs = require "nvim-treesitter.configs"

    treesitter_configs.setup {
        ensure_installed = { "markdown", "markdown_inline", "regex", "lua", "vim" },
        sync_install = true,
        auto_install = true,
        highlight = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        endwise = { enable = true },
    }

    require("ui.theme").load_skeleton "treesitter"
end

return M
