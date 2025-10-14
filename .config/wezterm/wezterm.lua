local wezterm = require 'wezterm'

local act = wezterm.action

local config = wezterm.config_builder()
config = {
	default_prog = {"/bin/bash"},
	window_close_confirmation = "NeverPrompt",
	font = wezterm.font "Cascadia Mono",
	color_scheme = "Catppuccin Mocha",
	scrollback_lines = 10000,
	hide_tab_bar_if_only_one_tab = true,
	warn_about_missing_glyphs = false,
	leader = { key="a", mods="CTRL" },
	keys = {
		{ key = "a", mods = "LEADER|CTRL",  action=wezterm.action.ActivateLastTab},
		{ key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
		{ key = "\\",mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
		{ key = "s", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
		{ key = "v", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
		{ key = "o", mods = "LEADER",       action="TogglePaneZoomState" },
		{ key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
		{ key = "p", mods = "LEADER",       action=wezterm.action.PaneSelect{mode="SwapWithActive"} },
		{ key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
		{ key = "LeftArrow", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
		{ key = "DownArrow", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
		{ key = "UpArrow", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
		{ key = "RightArrow", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
		{ key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
		{ key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
		{ key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
		{ key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
		{ key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
		{ key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
		{ key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
		{ key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
		{ key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
		{ key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
		{ key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
		{ key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
		{ key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
		{ key = "&", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
		{ key = "d", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
		{ key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
		{ key = 'r', mods = 'LEADER',       action = act.PromptInputLine {
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- -- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
			},
		},
	},
}

return config
