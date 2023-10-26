local C = require "ui.theme.colors"

return {
    StatusLine_mode_Normal = { fg = C.color1, italic = true },
    StatusLine_mode_Insert = { fg = C.color2, italic = true },
    Statusline_mode_Terminal = { fg = C.color1, italic = true },
    Statusline_mode_Visual = { fg = C.color4, italic = true },
    Statusline_mode_Select = { fg = C.color3, italic = true },
    Statusline_mode_Command = { fg = C.color5, italic = true },
    Statusline_mode_Confirm = { fg = C.color6, italic = true },
    Statusline_mode_NTerminal = { link = "Statusline_mode_term", bold = true },

    Statusline_filetype_default = C.color1,
    Statusline_filetype_name = C.foreground,

    Statusline_filename_normal = C.foreground,
    Statusline_filename_modified = C.color4,
    Statusline_filename_readonly = C.color1,

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
