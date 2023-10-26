local C = require "ui.theme.colors"

return {
    StatusLine_mode_Normal = { bg = C.color1, bold = true },
    StatusLine_mode_Insert = { bg = C.color2, bold = true },
    Statusline_mode_Terminal = { bg = C.color1, bold = true },
    Statusline_mode_Visual = { bg = C.color4, bold = true },
    Statusline_mode_Select = { bg = C.color3, bold = true },
    Statusline_mode_Command = { bg = C.color5, bold = true },
    Statusline_mode_Confirm = { bg = C.color6, bold = true },
    Statusline_mode_NTerminal = { link = "Statusline_mode_term", bold = true },

    Statusline_filetype_default = C.color1,
    Statusline_filetype_name = C.foreground,

    Statusline_lspclients = { fg = C.color6, italic = true },
    Statusline_macro = { fg = C.color3, bold = true },
    Statusline_separator = C.hint,

    Statusline_git_branch_icon = C.color5,
    Statusline_git_diff_added = C.color2,
    Statusline_git_diff_changed = C.color4,
    Statusline_git_diff_removed = C.color1,

    Statusline_misc_text = { fg = C.comment, italic = true },
    Statusline_text = C.foreground,
}
