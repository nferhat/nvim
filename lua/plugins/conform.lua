local M = {
    "stevearc/conform.nvim",
    init = require("utils").lazy_load "conform.nvim",
}

M.config = function()
    local conform = require "conform"

    conform.setup {
        formatters_by_ft = {
            lua = { "stylua" },
            rust = { "rustfmt" },
        },
    }
    -- Replaces the lsp keymap
    vim.keymap.set("n", "<leader>F", conform.format, { desc = "Format buffer" })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
            require("conform").format { bufnr = args.buf }
        end,
    })
end

return M
