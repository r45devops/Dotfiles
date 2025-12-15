return {
	"rebelot/heirline.nvim",
	event = "UiEnter",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- Git 信息
		"nvim-tree/nvim-web-devicons", -- 图标
	},
	config = function()
		local utils = require("heirline.utils")
		local conditions = require("heirline.conditions")

		-- 0. 基础设置
		require("gitsigns").setup() -- 启动 gitsigns
		vim.opt.laststatus = 3 -- 全局底部状态栏
		vim.opt.showcmd = false -- 隐藏右下角命令预览

		local colors = {
			bright_bg = utils.get_highlight("Folded").bg,
			bright_fg = utils.get_highlight("Folded").fg,
			red = utils.get_highlight("DiagnosticError").fg,
			dark_red = utils.get_highlight("DiffDelete").bg,
			green = utils.get_highlight("String").fg,
			blue = utils.get_highlight("Function").fg,
			gray = utils.get_highlight("NonText").fg,
			orange = utils.get_highlight("DiagnosticWarn").fg,
			purple = utils.get_highlight("Statement").fg,
			cyan = utils.get_highlight("Special").fg,
			diag_warn = utils.get_highlight("DiagnosticWarn").fg,
			diag_error = utils.get_highlight("DiagnosticError").fg,
			diag_hint = utils.get_highlight("DiagnosticHint").fg,
			diag_info = utils.get_highlight("DiagnosticInfo").fg,
			git_del = utils.get_highlight("DiffDelete").bg,
			git_add = utils.get_highlight("DiffAdd").bg,
			git_change = utils.get_highlight("DiffChange").bg,
		}

		----------------------------------------------------------------
		-- 组件定义
		----------------------------------------------------------------

		-- 1. 顶部 WinBar 组件 (文件名)
		local FileName = {
			init = function(self)
				self.lfilename = vim.fn.expand("%:t")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(self.lfilename, extension, { default = true })
			end,
			provider = function(self)
				local filename = self.lfilename
				if filename == "" then
					filename = "[No Name]"
				end
				-- 如果文件被修改，显示圆点
				local modified = vim.bo.modified and " ●" or ""
				return " " .. self.icon .. " " .. filename .. modified .. " "
			end,
			hl = function(self)
				return { fg = self.icon_color, bold = true }
			end,
		}

		local WinBar = {
			FileName,
			{ provider = "%=" }, -- 防止渲染塌陷
		}

		----------------------------------------------------------------
		-- 底部 StatusLine 组件
		----------------------------------------------------------------

		-- A. 模式 (Vi Mode)
		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1):sub(1, 1)
			end,
			static = {
				mode_names = {
					n = "NORMAL",
					i = "INSERT",
					v = "VISUAL",
					V = "V-LINE",
					["\22"] = "V-BLOCK",
					c = "COMMAND",
					s = "SELECT",
					R = "REPLACE",
					t = "TERMINAL",
				},
				mode_colors = {
					n = "blue",
					i = "green",
					v = "purple",
					V = "purple",
					["\22"] = "purple",
					c = "orange",
					s = "purple",
					R = "red",
					r = "red",
					t = "green",
				},
			},
			provider = function(self)
				return "  " .. (self.mode_names[self.mode] or self.mode) .. " "
			end,
			hl = function(self)
				local color = self.mode_colors[self.mode] or "purple"
				return { fg = "black", bg = colors[color], bold = true }
			end,
			update = { "ModeChanged" },
		}

		-- B. Git 分支与状态
		local GitBranch = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
			end,
			{ -- 分支名
				provider = function()
					return "  " .. (vim.b.gitsigns_head or "") .. " "
				end,
				hl = { fg = "purple", bold = true },
			},
			{ -- 变动统计
				provider = function(self)
					local s = self.status_dict
					local res = {}
					if s.added and s.added > 0 then
						table.insert(res, "+" .. s.added)
					end
					if s.changed and s.changed > 0 then
						table.insert(res, "~" .. s.changed)
					end
					if s.removed and s.removed > 0 then
						table.insert(res, "-" .. s.removed)
					end
					return #res > 0 and ("[" .. table.concat(res, " ") .. "] ") or ""
				end,
				hl = { fg = "gray" },
			},
		}

		-- C. 诊断信息 (LSP Diagnostics)
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = { error_icon = " ", warn_icon = " ", info_icon = " ", hint_icon = " " },
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = colors.diag_error },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = colors.diag_warn },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = colors.diag_info },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
				end,
				hl = { fg = colors.diag_hint },
			},
		}

		-- D. LSP 服务名 (显示当前是哪个 LSP 在工作)
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return " [" .. table.concat(names, " ") .. "] "
			end,
			hl = { fg = "green", bold = true },
		}

		-- E. 文件属性 (类型 | 编码)
		local FileType = {
			provider = function()
				return string.upper(vim.bo.filetype) .. " "
			end,
			hl = { fg = "gray", bold = true },
		}

		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- 编码
				return enc ~= "utf-8" and enc:upper() .. " " or "" -- 只有不是 utf-8 时才显示，节省空间
			end,
			hl = { fg = "orange" },
		}

		-- F. 光标位置
		local Ruler = {
			provider = " %7(%l/%3L%):%2c %P ", -- 对齐格式：行/总行:列 百分比
			hl = { fg = "gray" },
		}

		-- 底部栏组装
		local StatusLine = {
			ViMode,
			GitBranch,
			{ provider = "%=" }, -- 左边结束，中间留白
			Diagnostics, -- 居中显示诊断
			{ provider = "%=" }, -- 中间结束，右边留白
			LSPActive,
			FileEncoding,
			FileType,
			Ruler,
		}

		require("heirline").setup({
			statusline = StatusLine,
			winbar = WinBar,
		})

		-- 自动更新高亮
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(require("heirline.config").highlight)
			end,
		})
	end,
}
