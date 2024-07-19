local fn = vim.fn
local get_option = vim.api.nvim_buf_get_option
local colors = require("sttusline.utils.color")

local Filename = require("sttusline.component").new()

Filename.set_event { "BufEnter", "WinEnter" }
Filename.set_colors {
	{},
	{ fg = colors.orange },
}

Filename.set_update(function()
	local has_devicons, devicons = pcall(require, "nvim-web-devicons")

	local filename = fn.expand("%")
	if filename == "" then filename = "No File" end
	local icon, color_icon = nil, nil
	if has_devicons then
		icon, color_icon = devicons.get_icon_color(filename, fn.expand("%:e"))
	end

	if not icon then
		local buftype = get_option(0, "buftype")
		local filetype = get_option(0, "filetype")
		if buftype == "terminal" then
			icon, color_icon = "", colors.red
			filename = "Terminal"
		elseif filetype == "NvimTree" then
			icon, color_icon = "󰙅", colors.red
			filename = "NvimTree"
		elseif filetype == "TelescopePrompt" then
			icon, color_icon = "", colors.red
			filename = "Telescope"
		elseif filetype == "mason" then
			icon, color_icon = "󰏔", colors.red
			filename = "Mason"
		elseif filetype == "lazy" then
			icon, color_icon = "󰏔", colors.red
			filename = "Lazy"
		elseif filetype == "checkhealth" then
			icon, color_icon = "", colors.red
			filename = "CheckHealth"
		elseif filetype == "plantuml" then
			icon, color_icon = "", colors.green
		elseif filetype == "dashboard" then
			icon, color_icon = "", colors.red
		end
	end

	return { icon and { icon, { fg = color_icon } } or "", " " .. filename }
end)

return Filename
