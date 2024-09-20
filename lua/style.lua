---@diagnostic disable: unused-local, redefined-local, undefined-field
local wezterm = require("wezterm")
local module = {}
function module.apply(config)
	-- set startup window position
	wezterm.on("gui-attached", function(domain)
		local workspace = wezterm.mux.get_active_workspace()
		for _, window in ipairs(wezterm.mux.all_windows()) do
			window:gui_window():set_position(185, 45)
		end
	end)

	-- set tab title
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local icon = { Nix = "❄️ Nix", MyServer = "🍥 MyServer", ["local"] = "🦚 Local" }
		local title = icon[tab.active_pane.domain_name] or tab.active_pane.title

		local foreground = "#666666"
		if tab.is_active then
			foreground = "white"
		end
		return {
			-- "#31313f",
			{ Background = { Color = "#282828" } },
			{ Foreground = { Color = foreground } },
			{ Text = " " .. title .. " " },
		}
	end)

	-- status
	wezterm.on("update-status", function(window)
		local color_scheme = window:effective_config().resolved_palette
		local bg = color_scheme.background
		local fg = color_scheme.foreground

		window:set_right_status(wezterm.format({
			-- First, we draw the arrow...
			{ Background = { Color = "none" } },
			{ Foreground = { Color = bg } },
			-- Then we draw our text
			{ Background = { Color = bg } },
			{ Foreground = { Color = fg } },
			{ Text = " " .. wezterm.hostname() .. " " },
		}))
	end)

	-- fonts
	config.font_size = 14
	config.font = wezterm.font_with_fallback({
		-- { family = "JetBrains Mono" },
		{ family = "Iosevka Cloudtide", weight = "Medium" },
		{ family = "Symbols Nerd Font Mono", scale = 0.85 },
		{ family = "Concrete Math", scale = 1.0 },
		{ family = "LXGW WenKai", scale = 1.05 }, --中文测试
	})

	-- padding
	config.window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0.15cell",
		bottom = "0cell",
	}

	-- colors
	config.window_frame = {
		font = wezterm.font({ family = "Iosevka Cloudtide", weight = "Bold", scale = 1.1 }),
		active_titlebar_bg = "#282828",
		inactive_titlebar_bg = "#282828",
		-- "#31313f",
	}

	config.colors = { tab_bar = { inactive_tab_edge = "#282828" } }
	-- "#31313f"

	-- custom title name
	wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
		return " ᕕ( ᐛ )ᕗ "
	end)
end

return module
