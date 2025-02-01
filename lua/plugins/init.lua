-- Required servers to be installed & configured
local lsp_servers = {
    "clangd",
    "jsonls",
    "lua_ls",
    "pyright",
    "zls",
}

-- Required languages for Treesitter
local treesitter_langs = { "c", "lua", "python", "zig" }

-- Special LSP lsp_configurations
local lsp_configurations = {}

-- Determines which variant of Kanagawa to load
-- Optional, can be "" (default Kanagawa theme)
local kanagawa_variant = ""

return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            colors = {
                themes = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                        },
                    },
                },
            },
            overrides = function(colors)
                local theme = colors.theme

                local function make_diagnostic_color(color)
                    local c = require("kanagawa.lib.color")
                    return {
                        fg = color,
                        bg = c(color):blend(theme.ui.bg, 0.95):to_hex(),
                    }
                end

                return {
                    Normal = { bg = "NONE" },
                    NonText = { bg = "NONE" },
                    LineNr = { bg = "NONE" },
                    LineNrColumn = { bg = "NONE" },

                    SignColumn = { bg = "NONE" },
                    DiagnosticSignError = { bg = "NONE" },
                    DiagnosticSignWarn = { bg = "NONE" },
                    DiagnosticSignInfo = { bg = "NONE" },
                    DiagnosticSignHint = { bg = "NONE" },
                    DiagnosticSignOk = { bg = "NONE" },

                    NormalFloat = { bg = "NONE" },
                    FloatBorder = { bg = "NONE" },
                    FloatTitle = { bg = "NONE" },

                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal = {
                        fg = theme.ui.fg_dim,
                        bg = theme.ui.bg_m1,
                    },
                    TelescopeResultsBorder = {
                        fg = theme.ui.fg_dim,
                        bg = theme.ui.bg_m1,
                    },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim },

                    DiagnosticVirtualTextError = make_diagnostic_color(
                        theme.diag.error
                    ),
                    DiagnosticVirtualTextWarn = make_diagnostic_color(
                        theme.diag.warning
                    ),
                    DiagnosticVirtualTextInfo = make_diagnostic_color(
                        theme.diag.info
                    ),
                    DiagnosticVirtualTextHint = make_diagnostic_color(
                        theme.diag.hint
                    ),

                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSBar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        },
        config = function(_, opts)
            local kanagawa = require("kanagawa")

            local theme = "wave"

            if kanagawa_variant and kanagawa_variant ~= "" then
                theme = kanagawa_variant
            end

            kanagawa.setup(opts)
            kanagawa.load(theme)
        end,
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                diagnostics = "nvim_lsp",
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = function()
            local telescope = require("telescope")

            local vimgrep_arguments =
                require("telescope.config").values.vimgrep_arguments
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")

            telescope.setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            "--glob",
                            "!**/.git/*",
                        },
                    },
                },
                extensions = {
                    media_files = {
                        find_cmd = "rg",
                    },
                },
            })

            require("telescope").load_extension("media_files")
            require("telescope").load_extension("file_browser")

            local builtin = require("telescope.builtin")

            vim.keymap.set(
                "n",
                "<Leader>ff",
                builtin.find_files,
                { desc = "Telescope find files" }
            )
            vim.keymap.set(
                "n",
                "<Leader>fg",
                builtin.live_grep,
                { desc = "Telescope live grep" }
            )
            vim.keymap.set(
                "n",
                "<Leader>fb",
                builtin.buffers,
                { desc = "Telescope buffers" }
            )
            vim.keymap.set(
                "n",
                "<Leader>fh",
                builtin.help_tags,
                { desc = "Telescope help tags" }
            )
            vim.keymap.set(
                "n",
                "<Leader>fs",
                builtin.git_status,
                { desc = "Telescope check git status" }
            )
            vim.keymap.set(
                "n",
                "<Leader>fc",
                builtin.git_commits,
                { desc = "Telescope check git commits" }
            )

            vim.keymap.set(
                "n",
                "<Leader>ft",
                require("telescope").extensions.file_browser.file_browser
            )
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "|" },
                    change = { text = "|" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = true,
                current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    delay = 0,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%d-%m> - <summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = "rounded",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })

            -- Fix to get Gitsigns to have a transparent background
            local function get_color(group, attr)
                return vim.fn.synIDattr(
                    vim.fn.synIDtrans(vim.fn.hlID(group)),
                    attr
                )
            end

            vim.api.nvim_set_hl(
                0,
                "GitSignsAdd",
                { fg = get_color("GitSignsAdd", "fg"), bg = "NONE" }
            )
            vim.api.nvim_set_hl(
                0,
                "GitSignsChange",
                { fg = get_color("GitSignsChange", "fg"), bg = "NONE" }
            )
            vim.api.nvim_set_hl(
                0,
                "GitSignsDelete",
                { fg = get_color("GitSignsDelete", "fg"), bg = "NONE" }
            )
            vim.api.nvim_set_hl(
                0,
                "GitSignsChangeDelete",
                { fg = get_color("GitSignsChangeDelete", "fg"), bg = "NONE" }
            )
        end,
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        opts = lsp_configurations,
        config = function(_, opts)
            local lspconfig = require("lspconfig")

            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = lsp_servers,
            })

            for _, server in pairs(lsp_servers) do
                local config = opts[server] or {}
                config.capabilities = require("blink.cmp").get_lsp_capabilities(
                    config.capabilities
                )

                lspconfig[server].setup(config)
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
            require("nvim-treesitter.configs").setup({
                ensure_installed = treesitter_langs,
                sync_install = false,
                auto_install = true,
                indent = { enable = true },
                highlight = { enable = true },
                autotag = { enable = true },
                rainbow = {
                    enable = true,
                    disable = { "html" },
                    extended_mode = false,
                    max_file_lines = nil,
                },
                modules = {},
                ignore_install = {},
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = { "justinsgithub/wezterm-types" },
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "wezterm-types", mods = { "wezterm " } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            completion = {
                menu = { border = "rounded" },
                documentation = { window = { border = "rounded" } },
            },
            signature = { window = { border = "rounded" } },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
        config = function(_, opts)
            require("blink.cmp").setup(opts)

            vim.cmd([[
                highlight BlinkCmpMenu guibg=NONE ctermbg=NONE
                highlight BlinkCmpMenuBorder guibg=NONE ctermbg=NONE
                highlight BlinkCmpDoc guibg=NONE ctermbg=NONE
                highlight BlinkCmpDocBorder guibg=NONE ctermbg=NONE
            ]])
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            -- Use Powershell over cmd (Windows)
            if vim.fn.has("win32") then
                local powershell_options = {
                    shell = "powershell",
                    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
                    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
                    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
                    shellquote = "",
                    shellxquote = "",
                }

                for option, value in pairs(powershell_options) do
                    vim.opt[option] = value
                end
            end

            require("toggleterm").setup({
                size = 10,
                open_mapping = [[<F7>]],
                shading_factor = 2,
                direction = "float",
                float_opts = {
                    border = "curved",
                    highlights = {
                        border = "Normal",
                        background = "Normal",
                    },
                },
            })
        end,
    },
}
