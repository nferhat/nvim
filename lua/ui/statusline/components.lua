local M = {}

local highlight_text = require("utils").highlight_text

M.diagnostics = function()
    ---@diagnostic disable-next-line: deprecated
    if not rawget(vim, "lsp") or #vim.lsp.get_active_clients { bufnr = 0 } == 0 then
        return ""
    end

    local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    local hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

    local errors, warnings, hint, info = "0", "0", "0", "0"

    warnings = highlight_text("DiagnosticWarn", tostring(warning_count))
    errors = highlight_text("DiagnosticError", tostring(error_count))
    info = highlight_text("DiagnosticInfo", tostring(info_count))
    hint = highlight_text("DiagnosticHint", tostring(hint_count))

    return highlight_text("Statusline_separator", "[")
        .. table.concat({ errors, warnings, info, hint }, " ")
        .. highlight_text("Statusline_separator", "]")
end

M.lspclients = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    local attached_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if #attached_clients == 0 then
        return ""
    end

    local attached_clients_name = {}
    for _, attached_client in ipairs(attached_clients) do
        table.insert(attached_clients_name, attached_client.name)
    end

    local ret = table.concat(attached_clients_name, ", ")

    return "  "
        .. highlight_text("Statusline_misc_text", "LSP ")
        .. highlight_text("Statusline_separator", "[")
        .. highlight_text("Statusline_lspclients", ret)
        .. highlight_text("Statusline_separator", "]")
end

M.noice = function()
    local noice = package.loaded["noice"]
    if not noice then
        return
    end

    if noice.api.statusline.mode.has() then
        local macro_name = string.match(noice.api.statusline.mode.get(), ".*(@.)")
        return highlight_text("Statusline_text", "Recording ") .. highlight_text("Macro", macro_name) .. "  "
    else
        return ""
    end
end

M.git_branch = function()
    if not (vim.b.gitsigns_head or vim.b.gitsigns_git_status) or vim.o.columns < 80 then
        return ""
    end

    if vim.b.gitsigns_status_dict.head == "" then
        return ""
    end

    return "  "
        .. highlight_text("Statusline_git_branch", " ")
        .. highlight_text("Statusline_filename", vim.b.gitsigns_status_dict.head)
end

M.filetype = function()
    local devicons = require "nvim-web-devicons"
    local current_buf_name = vim.api.nvim_buf_get_name(0)
    local icon, hl = devicons.get_icon(current_buf_name)

    if icon == nil then
        return highlight_text("Statusline_text", " " .. vim.bo.ft) .. "  "
    else
        return highlight_text(hl, icon) .. highlight_text("Statusline_text", " " .. vim.bo.ft) .. "  "
    end
end

M.navic = function()
    if vim.o.columns < 120 then
        return ""
    end

    local navic = package.loaded["nvim-navic"]
    if not navic then
        return ""
    end

    return "  " .. navic.get_location()
end

return M
