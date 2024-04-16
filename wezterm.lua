---@diagnostic disable: unused-local, redefined-local
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- set startup window position
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():set_position(185, 45)
end)

-- set tab title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local icon = { Nix = "❄️ Nix", MyServer = "🐬 MyServer", ["local"] = "🦚 Local" }
	local title = icon[tab.active_pane.domain_name] or tab.active_pane.title

	local foreground = "#808080"
	if tab.is_active then
		foreground = "white"
	end
	return {
		{ Background = { Color = "#31313f" } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. title .. " " },
	}
end)

-- fonts
config.font = wezterm.font_with_fallback({
	-- { family = "JetBrains Mono" },
	{ family = "Iosevka Cloudtide" },
	{ family = "Symbols Nerd Font Mono", scale = 0.85 },
	{ family = "LXGW WenKai", scale = 1.05 }, --中文测试
	{ family = "Cambria Math", scale = 1.0 },
})

-- padding
config.window_padding = {
	left = "0.4cell",
	right = "0.15cell",
	top = "0.15cell",
	bottom = "0cell",
}

-- colors
config.window_frame = {
	font = wezterm.font({ family = "Iosevka Cloudtide", weight = "Bold", scale = 1.1 }),
	active_titlebar_bg = "#31313f",
}

config.colors = {
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#31313f",
	},
}

-- custom title name
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	return " ᕕ( ᐛ )ᕗ "
end)

-- set domains
config.unix_domains = {}
config.ssh_domains = {
	{
		name = "MyServer",
		remote_address = "192.131.142.134:11451",
		username = "parsifa1",
		default_prog = { "fish" },
		assume_shell = "Posix",
		local_echo_threshold_ms = 500,
	},

	{
		name = "Nix",
		remote_address = "127.0.0.1:14514",
		username = "parsifa1",
		multiplexing = "None",
		default_prog = { "fish" },
		assume_shell = "Posix",
		no_agent_auth = true,
	},
}
config.wsl_domains = {
	-- {
	-- 	name = "WSL:Nixos",
	-- 	distribution = "Nixos",
	-- },
}

-- launch_menu
local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell",
		domain = { DomainName = "local" },
		args = { "pwsh", "-NoLogo" },
	})
end
config.launch_menu = launch_menu

-- key config
config.leader = { key = "w", mods = "ALT", timeout_milliseconds = 5000 }
config.keys = {
	-- set <C-v> for paste
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if pane:is_alt_screen_active() or (not sel or sel == "") then
				window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
			end
		end),
	},
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	-- set launch_menu
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS | DOMAINS" }),
	},
	{
		key = ";",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "'",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SwitchToWorkspace({
			name = "default",
		}),
	},
	{
		key = "m",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = { "btop" },
			},
		}),
	},
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	-- Change Active Pane
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
}
for i = 1, 8 do
	-- CTRL+ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- set initial size for screens
config.initial_rows = 45
config.initial_cols = 175

-- set front_end
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- config of tab bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true

-- set transparent
config.window_background_opacity = 0.83
config.win32_system_backdrop = "Acrylic" -- "Auto" or "Acrylic"


config.color_scheme = "Catppuccin Mocha (Gogh)"
config.animation_fps = 165
config.default_domain = "Nix"
config.font_size = 13.8
config.max_fps = 165
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"


return config
