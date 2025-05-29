return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ft = { "markdown", "vimwiki" },
        opts = {
            filetypes = { 'markdown', 'vimwiki' },
            link = {
                enabled = true,
                render_modes = false,
                footnote = {
                    enabled = true,
                    superscript = true,
                    prefix = '',
                    suffix = '',
                },
                image = '󰥶 ',
                email = '󰀓 ',
                hyperlink = '󰌹 ',
                highlight = 'RenderMarkdownLink',
                wiki = {
                    icon = '󱗖 ',
                    body = function()
                        return nil
                    end,
                    highlight = 'RenderMarkdownWikiLink',
                },
                custom = {
                    web = { pattern = '^http', icon = '󰖟 ' },
                    discord = { pattern = 'discord%.com', icon = '󰙯 ' },
                    github = { pattern = 'github%.com', icon = '󰊤 ' },
                    gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
                    google = { pattern = 'google%.com', icon = '󰊭 ' },
                    neovim = { pattern = 'neovim%.io', icon = ' ' },
                    reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
                    stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
                    wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
                    youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
                    python = { pattern = '%.py$', icon = '󰌠 ', },
                },
            },
        },
        config = function(_, opts)
            require('render-markdown').setup(opts)

            -- Setup nvim-cmp source if you use cmp
            local ok, cmp = pcall(require, 'cmp')
            if ok then
                cmp.setup({
                    sources = cmp.config.sources({
                        { name = 'render-markdown' },
                    }),
                })
            end
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
}
