local C = require "ui.theme.colors"

return {
    -- base neovim tui highlights
    normal = { fg = C.foreground, bg = C.background },
    normalfloat = { fg = C.foreground, bg = "none" },
    floatborder = { bg = "none", fg = C.border, blend = vim.opt.winblend:get() },
    cold = { bold = true },
    debug = { fg = C.color1, bold = true },
    directory = C.color4,
    error = { link = "debug" },
    errormsg = { link = "debug" },
    exception = { link = "debug" },
    foldcolumn = { fg = C.color6, bg = C.color0 },
    folded = { fg = C.comment, bg = C.color0 },
    incsearch = { fg = C.color0, bg = C.color3 },
    italic = { bold = false, italic = true, underline = false },
    matchparen = { bg = C.comment, bold = true },
    modemsg = { fg = C.color6, bold = true },
    moremsg = { fg = C.color6, bold = true },
    question = { fg = C.color4, bold = true },
    search = { fg = C.color0, bg = C.color3 },
    substitute = { fg = C.color0, bg = C.color3 },
    specialkey = { fg = C.comment, italic = true },
    toolong = { fg = C.color1 },
    underlined = { bold = false, italic = false, underline = true },
    visual = { bg = C.selection },
    visualnos = { link = "visual" },
    warningmsg = { fg = C.color3, bold = true },
    wildmenu = { fg = C.color6, bg = C.selection, bold = true },
    title = C.color4,
    conceal = { fg = C.color4, bg = "none", bold = true },
    cursor = { fg = C.color3, bg = C.foreground },
    nontext = C.comment,
    linenr = { fg = C.comment:darken(15), bg = "none" },
    signcolumn = { fg = C.comment, bg = "none", sp = "none" }, -- match normal hl grou.
    statusline = { bg = C.light_background, fg = C.foreground },
    statuslinenc = { bg = C.light_background, fg = C.foreground },
    vertsplit = { bg = "none", fg = C.border },
    colorcolumn = { bg = C.color0 },
    cursorcolumn = { bg = "none" },
    cursorline = {},
    cursorlinesign = { bg = C.background:lighten(1) },
    cursorlinenr = { fg = C.color4, bg = C.background:lighten(1), bold = true },
    quickfixline = { bg = C.color0 },
    pmenu = { fg = C.color7, bg = C.light_background },
    pmenusbar = { fg = C.light_background, bg = C.light_background },
    pmenusel = { fg = C.color4, bg = C.selection, bold = true }, -- not following base16
    pmenuthumb = { fg = C.color0, bg = C.color0 },
    tabline = { fg = C.comment, bg = C.light_background },
    tablinefill = { fg = C.color8, bg = C.light_background },
    tablinesel = { fg = C.color7, bg = "none", bold = true },

    -- neovim's regex syntax highlight
    boolean = C.color3,
    character = { fg = C.color1, bold = true },
    comment = C.comment,
    condition = C.color5,
    constant = C.color3,
    define = C.color5,
    delimiter = C.color1,
    float = C.color3,
    ["function"] = C.color4,
    identifier = C.color1,
    include = C.color4,
    keyword = { fg = C.color5, italic = true },
    label = C.color3,
    number = C.color3,
    operator = C.color7,
    preproc = C.color3,
    ["repeat"] = { fg = C.color3, italic = true },
    special = C.color6,
    specialchar = { link = "character" },
    statement = C.color5,
    string = C.color2,
    structure = { fg = C.color5, italic = true },
    tag = C.color3,
    todo = C.color4,
    type = { fg = C.color3, bold = true },
    typedef = { link = "type" },

    -- diff syntax highlighting
    diffadd = { fg = C.color2, bg = C.color0 },
    diffchange = { fg = C.color6, bg = C.color0 },
    diffdelete = { fg = C.color1, bg = C.color0 },
    difftext = { fg = C.color4, bg = C.color0 },
    diffadded = C.color2,
    difffile = C.color1,
    diffnewfile = C.color2,
    diffline = C.color4,
    diffremoved = C.color1,

    -- spell
    spellbad = { underline = true, sp = C.color1 },
    spellcap = { underline = true, sp = C.color4 },
    spellrare = { underline = true, sp = C.color5 },
    spelllocal = { underline = true, sp = C.color6 },

    -- lsp
    LspInlayHint = { bg = C.light_background:darken(1.0), fg = C.comment },
}
