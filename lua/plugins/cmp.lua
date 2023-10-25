local M = {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- Different sources for the cmp panel
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
    },
}

M.config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local cmp_kinds = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = " ",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }

    ---Checks if there's a word/term before the cursor.
    ---@return boolean
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    cmp.setup {
        snippet = {
            expand = function(args)
                -- An expand function is required so snippets provided by the LSP servers
                -- can be expanded and jumped to it's nodes
                require("luasnip").lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered {
                -- winhighlight = "Normal:CmpCompletionNormal,FloatBorder:CmpCompletionBorder,CursorLine:CmpCompletionSelected",
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:CmpItemSelected",
                border = "single",
                scrollbar = false,
                col_offset = -2,
                side_padding = 1,
            },
            documentation = cmp.config.window.bordered {
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:CmpItemSelected",
                border = "single",
                scrollbar = true,
            },
        },
        completion = {
            -- I need manual completion,
            autocomplete = false,
        },
        performance = {
            max_view_entries = 40,
            throttle = 0,
        },
        mapping = {
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp", priority = 10 },
            { name = "luasnip", priority = 7 }, -- For luasnip users.
        }, {
            { name = "path" },
        }),
        formatting = {
            fields = { "kind", "abbr" },
            format = function(entry, item)
                if vim.tbl_contains({ "path" }, entry.source.name) then
                    if item.kind == "Folder" then
                        -- Use a pretty folder icon if the given path is a folder (woah)
                        item.abbr = item.abbr:gsub("/", "")
                        item.kind = ""
                        item.kind_hl_group = "CmpItemKindFolder"
                    elseif item.kind == "File" then
                        item.kind = cmp_kinds.File
                        item.kind_hl_group = "CmpItemKindFile"
                    end

                    return item
                else
                    item.kind = (cmp_kinds[item.kind] or "")
                end

                return item
            end,
        },
    }

    -- Integration with nvim-autopairs.
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    require("ui.theme").load_skeleton "cmp"
end

return M
