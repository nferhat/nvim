local M = {
    "neovim/nvim-lspconfig",
    init = require("utils").lazy_load "nvim-lspconfig",
}

function M.config()
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
    end

    vim.diagnostic.config {
        underline = true, -- underline the area with diagnostics
        virtual_text = { spacing = nil },
        signs = false,
        update_in_insert = true,
        severity_sort = true,
        float = {
            header = "",
            prefix = "",
            border = "single",
            style = "minimal",
        },
    }

    for t, icon in pairs { Error = "", Warn = "", Hint = "", Info = "" } do
        vim.fn.sign_define("DiagnosticSign" .. t, { text = icon, texthl = "DiagnosticSign" .. t })
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
            local buffer = event.buf
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            local set_keymap = vim.keymap.set
            set_keymap(
                "n",
                "<leader>D",
                "<cmd>Telescope diagnostics<CR>",
                { desc = "Workspace diagnostics", buffer = buffer }
            )
            set_keymap("n", "[d", vim.diagnostic.goto_prev, { buffer = buffer })
            set_keymap("n", "]d", vim.diagnostic.goto_next, { buffer = buffer })
            set_keymap("n", "gd", vim.lsp.buf.definition, { desc = "Symbol Definition", buffer = buffer })
            set_keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Symbol Declaration", buffer = buffer })
            set_keymap("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover Symbol", buffer = buffer })
            set_keymap("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Buffer Code Action(s)", buffer = buffer })
            set_keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Cursor diagnostics", buffer = buffer })
            set_keymap("n", "<leader>r", function()
                require("ui.renamer").open()
            end, { desc = "Rename Symbol", buffer = buffer })
            set_keymap("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Open Signature Help", buffer = buffer })

            -- Better inlay hints (nvim >=0.10)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint(buffer, true)
            end

            if client.server_capabilities.documentSymbolProvider then
                require("lazy").load { plugins = "nvim-navic" }
                require("nvim-navic").attach(client, buffer)
            end
        end,
    })

    require("ui.theme").load_skeleton "diagnostics"

    local lspconfig = require "lspconfig"

    lspconfig.lua_ls.setup {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME"] = true,
                        ["/home/nferhat/Documents/repos/github/awesome-code-doc"] = true,
                    },
                    check3rdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    }

    lspconfig.rust_analyzer.setup {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
            ["rust-analyzer"] = {
                -- Cache all the current workspace when loading rust-analyzer
                cachePriming = { numThreads = 8, enable = true },
                checkOnSave = { enable = true },
                completion = {
                    autoimport = { enable = true },
                    autoself = { enable = true },
                },
            },
        },
    }

    lspconfig.clangd.setup {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }
end

return M
