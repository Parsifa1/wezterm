---@diagnostic disable: unused-local, redefined-local, undefined-field
local wezterm = require("wezterm")
local module = {}
function module.apply(config)
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
			name = "Nix:remote",
			remote_address = "cloudtide:11451",
			username = "parsifa1",
			default_prog = { "fish" },
			assume_shell = "Posix",
			no_agent_auth = true,
		},
		{
			name = "Nix",
			remote_address = "127.0.0.1:11451",
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
		{ label = "🍥 MyServer", domain = { DomainName = "MyServer" } },
		-- { label = "WSL:Nixos", domain = { DomainName = "WSL:NixOS" } },
	}
	if wezterm.target_triple == "aarch64-apple-darwin" then
		table.insert(launch_menu, 1, {
			label = "🍏 Local",
			domain = { DomainName = "local" },
		})
		table.insert(launch_menu, 2, {
			label = "❄️ Nix",
			domain = { DomainName = "Nix:remote" },
		})
	end
	if wezterm.target_triple == "x86_64-pc-windows-msvc" then
		table.insert(launch_menu, 2, {
			label = "🦚 Local",
			domain = { DomainName = "local" },
			args = { "pwsh", "-NoLogo" },
		})
		table.insert(launch_menu, 1, {
			label = "❄️ Nix",
			domain = { DomainName = "Nix" },
		})
	end
	config.launch_menu = launch_menu
end

return module
