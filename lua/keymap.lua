---@diagnostic disable: unused-local, redefined-local, undefined-field
local wezterm = require("wezterm")
local module = {}
function module.apply(config)
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
			key = "N",
			mods = "CTRL|SHIFT",
			action = wezterm.action.AttachDomain("Nix:remote"),
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
end

return module
