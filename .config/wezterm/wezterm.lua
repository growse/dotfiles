local wezterm = require 'wezterm'

return {
	default_prog = {"/bin/bash"},
	font = wezterm.font "Cascadia Mono",
	color_scheme = "Solarized Dark (base16)",
	scrollback_lines = 3500,
	hide_tab_bar_if_only_one_tab = true
}
