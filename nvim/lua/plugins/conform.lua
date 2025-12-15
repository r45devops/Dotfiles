return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = true, -- 保存即格式化
		formatters_by_ft = { -- 留空=用内置默认
			python = { "black" },
			javascript = { "prettier" },
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			--go = { "gofmt" },
		},
	},
}
