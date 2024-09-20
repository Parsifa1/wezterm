---@diagnostic disable: unused-local, redefined-local, undefined-field
local wezterm = require("wezterm")
local config = wezterm.config_builder()

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

-- fonts
config.font_size = 13.8
config.font = wezterm.font_with_fallback({
	-- { family = "JetBrains Mono" },
	{ family = "Iosevka Cloudtide", weight = "Medium" },
	{ family = "Symbols Nerd Font Mono", scale = 0.85 },
	{ family = "Concrete Math", scale = 1.0 },
	{ family = "LXGW WenKai", scale = 1.05 }, --中文测试
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

-- set domains
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
	{
		name = "WSL:NixOS",
		distribution = "NixOS",
	},
}
config.unix_domains = {}

-- launch_menu
local launch_menu = {
	{ label = "❄️ Nix", domain = { DomainName = "Nix" } },
	{ label = "🍥 MyServer", domain = { DomainName = "MyServer" } },
	-- { label = "WSL:Nixos", domain = { DomainName = "WSL:NixOS" } },
}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, 2, {
		label = "🦚 Local",
		domain = { DomainName = "local" },
		args = { "pwsh", "-NoLogo" },
	})
end
config.launch_menu = launch_menu

-- key config
config.leader = { key = "`", mods = "ALT", timeout_milliseconds = 5000 }
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
		action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }),
	},
	{
		key = ":",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT",
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
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = wezterm.action.AttachDomain("MyServer"),
	},
	{
		key = "D",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DetachDomain("CurrentPaneDomain"),
	},
	-- INFO: Send <C-Enter> to the terminal
	{
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "Enter", mods = "CTRL" }),
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
config.initial_rows = 42
config.initial_cols = 170
-- set front_end
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"

-- config of tab bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true
config.default_cursor_style = "BlinkingBlock"

-- set transparent
-- config.window_background_opacity = 0.83
config.win32_system_backdrop = "Acrylic" -- "Auto" or "Acrylic"
config.color_scheme = "Gruvbox Material (Gogh)"
config.animation_fps = 144
config.default_domain = "local"
config.default_prog = { "pwsh", "-NoLogo" }
config.max_fps = 144
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"

return config
