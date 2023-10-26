local M = {}

local highlight_text = require("utils").highlight_text

M.mode_colors = {
    ["n"] = { "NOR", "Statusline_mode_Normal" },
    ["niI"] = { "NOR", "Statusline_mode_Normal" },
    ["niR"] = { "NOR", "Statusline_mode_Normal" },
    ["niV"] = { "NOR", "Statusline_mode_Normal" },
    ["no"] = { "NOR", "Statusline_mode_Normal" },
    ["i"] = { "INS", "Statusline_mode_Insert" },
    ["ic"] = { "INS (completion)", "Statusline_mode_Insert" },
    ["ix"] = { "INS completion", "Statusline_mode_Insert" },
    ["t"] = { "TER", "Statusline_mode_Terminal" },
    ["nt"] = { "TER", "Statusline_mode_NTerminal" },
    ["v"] = { "VIS", "Statusline_mode_Visual" },
    ["V"] = { "VIS", "Statusline_mode_Visual" },
    ["Vs"] = { "VIS", "Statusline_mode_Visual" },
    [""] = { "VIS", "Statusline_mode_Visual" },
    ["R"] = { "REP", "Statusline_mode_Replace" },
    ["Rv"] = { "VIS", "Statusline_mode_Replace" },
    ["s"] = { "SEL", "Statusline_mode_Select" },
    ["S"] = { "SEL", "Statusline_mode_Select" },
    [""] = { "SEL", "Statusline_mode_Select" },
    ["c"] = { "CMD", "Statusline_mode_Command" },
    ["cv"] = { "CMD", "Statusline_mode_Command" },
    ["ce"] = { "CMD", "Statusline_mode_Command" },
    ["r"] = { "PRT", "Statusline_mode_Confirm" },
    ["rm"] = { "MORE", "Statusline_mode_Confirm" },
    ["r?"] = { "CHK", "Statusline_mode_Confirm" },
    ["x"] = { "CHK", "Statusline_mode_Confirm" },
    ["!"] = { "SH!", "Statusline_mode_Terminal" },
}

---Returns the current mode that Neovim is on.
---@return string
M.mode = function()
    local mode = M.mode_colors[vim.api.nvim_get_mode().mode]
    local ret = highlight_text(mode[2], mode[1]:lower())
    return "  " .. ret
end

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

    errors = highlight_text("DiagnosticError", "!" .. tostring(error_count))
    warnings = highlight_text("DiagnosticWarn", "*" .. tostring(warning_count))
    info = highlight_text("DiagnosticInfo", "+" .. tostring(info_count))
    hint = highlight_text("DiagnosticHint", "-" .. tostring(hint_count))

    return "  "
        .. highlight_text("Statusline_separator", "[")
        .. table.concat({ errors, warnings, info, hint }, " ")
        .. highlight_text("Statusline_separator", "]")
end

M.lspclients = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    ---@diagnostic disable-next-line: deprecated
    local attached_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if #attached_clients == 0 then
        return ""
    end

    local attached_clients_name = {}
    for _, attached_client in ipairs(attached_clients) do
        table.insert(attached_clients_name, attached_client.name)
    end

    local ret = table.concat(attached_clients_name, ", ")

    return "  " .. highlight_text("Statusline_lspclients", " ") .. highlight_text("Statusline_text", ret)
end

M.noice = function()
    local noice = package.loaded["noice"]
    if not noice then
        return ""
    end

    if noice.api.statusline.mode.has() then
        local macro_name = string.match(noice.api.statusline.mode.get(), ".*(@.)")
        return highlight_text("Statusline_text", "Recording ") .. highlight_text("Macro", macro_name) .. "  "
    else
        return ""
    end
end

M.git_branch = function()
    if vim.o.columns < 100 or not vim.b.gitsigns_status_dict then
        return ""
    end
    local branch = vim.b.gitsigns_status_dict.head
    return highlight_text("Statusline_git_branch_icon", " ") .. highlight_text("Statusline_text", branch) .. "  "
end

M.git_diff = function()
    if not vim.b.gitsigns_status_dict or vim.fn.expand == "%" then
        return ""
    end

    local added = highlight_text("Statusline_git_diff_added", "+" .. tostring(vim.b.gitsigns_status_dict.added))
    local changed = highlight_text("Statusline_git_diff_changed", "~" .. tostring(vim.b.gitsigns_status_dict.changed))
    local removed = highlight_text("Statusline_git_diff_removed", "-" .. tostring(vim.b.gitsigns_status_dict.removed))

    return highlight_text("Statusline_separator", "[")
        .. table.concat({ added, changed, removed }, " ")
        .. highlight_text("Statusline_separator", "]")
        .. "  "
end

M.filename = function()
    local fname = vim.fn.expand "%:t"
    fname = fname == "" and "[scratch]" or fname
    local filepath = vim.fn.expand "%:~:.:h"
    filepath = filepath == "" and "" or filepath .. "/"
    local highlight = (vim.bo.modified and "Statusline_filename_modified")
        or (vim.bo.readonly and "Statusline_filename_readonly")
        or "Statusline_filename_normal"
    return "  " .. highlight_text("Statusline_misc_text", filepath) .. highlight_text(highlight, fname)
end

M.filetype = function()
    if vim.o.columns < 70 then
        return ""
    end

    local devicons = require "nvim-web-devicons"
    local current_buf_name = vim.api.nvim_buf_get_name(0)
    local icon, hl = devicons.get_icon(current_buf_name)

    local ft = vim.bo.ft
    ft = ft == "" and "none" or ft

    if icon == nil then
        return highlight_text("Statusline_text", " " .. ft) .. "  "
    else
        return highlight_text(hl, icon) .. highlight_text("Statusline_text", " " .. ft) .. "  "
    end
end

M.navic = function()
    if vim.o.columns < 120 or vim.fn.expand "%" == "" then
        return ""
    end

    local navic = package.loaded["nvim-navic"]
    if not navic then
        return ""
    end

    local location = navic.get_location()
    if location == "" then
        return ""
    else
        return highlight_text("NavicSeparator", " > ") .. location
    end
end

return M
