# Laptop Setup Guide

Step-by-step notes for rebuilding this machine from a fresh CachyOS (Arch-based) install.

## 1. Base install

Install CachyOS as normal (this machine uses the `linux-cachyos` kernel, with
`linux-cachyos-lts` kept as a fallback). Let the CachyOS installer set up
`chwd`, mirrorlists, and the Plasma (KDE) desktop on Wayland.

## 2. AUR helper

```
sudo pacman -S yay
```

`yay` ships as a prebuilt package straight from the `cachyos` repo, so no
manual build/bootstrap is needed. Config lives at `~/.config/yay/config.json`
(restored by yadm, see below).

## 3. Restore dotfiles with yadm

Install `yadm` as part of the combined `yay` call in step 4 (or run
`yay -S yadm` on its own now if you want dotfiles restored before anything
else), then:

```
yadm clone git@github.com:growse/dotfiles.git
```

`yadm` will prompt to run the bootstrap script (`~/.config/yadm/bootstrap`),
which:
- initializes git submodules (`.dir_colors` solarized theme, `.vim/pack/growse/start/deus`)
- installs `vim-plug` and syncs vim plugins

A handful of sensitive files (`~/.kube/config`, `~/.aws/credentials`,
`~/.gradle/gradle.properties`, MQTT configs, etc.) are yadm-encrypted — after
cloning run `yadm decrypt` with the passphrase from the password manager.

Key dotfiles managed this way: `.bashrc`, `.gitconfig` (+ `.gitconfig_work`),
`.ssh/config`, `.aws/config`, `.vimrc`, `.config/starship.toml`,
`.config/atuin/config.toml`, `.config/wezterm/wezterm.lua`, `.config/k9s/skin.yml`,
`.config/htop/htoprc`, `.sdkman/etc/config`, `.config/plasma-panel-layout.js`,
`.local/bin/setup-plasma-panel.sh`, and Claude Code's `.claude/settings.json`.

## 4. Packages (yay)

Install everything through `yay` — it transparently covers official repo
packages and AUR packages in one call, so there's no need to split between
`pacman` and an AUR helper. Dump the explicitly-installed set on the old
machine with `pacman -Qqe > pkglist.txt` and restore with:

```
yay -S --needed - < pkglist.txt
```

Notable groups pulled in:
- **CachyOS extras**: `cachyos-settings`, `cachyos-kde-settings`, `cachyos-hooks`,
  `cachyos-kernel-manager`, `cachyos-hello`, `cachyos-wallpapers`, `cachy-update`,
  `cachyos-rate-mirrors`
- **Plasma desktop**: `plasma-desktop`, `konsole`, `dolphin`, `kate`, `ark`,
  `gwenview`, `spectacle`, `partitionmanager`, `filelight`, `kdeconnect`,
  `plasma-systemmonitor`, `bluedevil`, `plasma-nm`, `powerdevil`
- **Dev tooling**: `git`, `github-cli`, `go`, `python`, `npm`, `rustup`,
  `rbenv`/`ruby-build`, `docker-buildx` + `podman`/`podman-docker`, `k9s`,
  `kubectl`, `kustomize`, `stern`, `fluxcd`, `just`, `pre-commit`, `sops`,
  `age`, `claude-code`
- **Terminal/shell**: `wezterm`, `alacritty`, `atuin`, `starship`, `btop`,
  `glances`, `ripgrep`, `micro`, `nano`, `plocate`
- **Apps**: `firefox`, `signal-desktop`, `telegram-desktop`, `syncthing`,
  `handbrake`, `haruna`, `vlc-plugins-all`, `steam`
- **Fonts**: `noto-fonts` (+cjk/emoji), `ttf-cascadia-mono-nerd`,
  `ttf-meslo-nerd`, `otf-cascadia-code`, `ttf-dejavu`, `ttf-liberation`
- **AUR-only**: `yadm`, `android-cli`, `android-studio`,
  `intellij-idea-ultimate-edition`, `betterleaks`, `catppuccin-cursors-mocha`,
  `catppuccin-plasma-colorscheme-mocha`, `displaylink`, `evdi-dkms`,
  `jamesdsp`, `mdns-scan`, `plasma-splash-catppuccin-mocha-git`,
  `plymouth-theme-catppuccin-mocha-git`, `qbittorrent-enhanced`

## 5. Flatpak

```
flatpak install flathub com.google.Chrome
```

## 6. KDE theming

Applied via System Settings after install:
- **Global theme**: `Catppuccin-Mocha-Mauve` (splash screen), `YAMIS` icon
  theme, `catppuccin-mocha-mauve-cursors` cursor theme
- **Plymouth boot theme**: `plymouth-theme-catppuccin-mocha-git`
- **Plasma theme packages** also installed for switching: `cachyos-emerald-kde-theme-git`,
  `cachyos-iridescent-kde`, `cachyos-nord-kde-theme-git`

Reinstall the AUR theme packages above first, then set them under
*System Settings → Appearance*.

## 7. Desktop backgrounds

- Primary desktop wallpaper: CachyOS default (`/usr/share/wallpapers/cachyos-wallpapers/north.png`)
- Secondary wallpaper: a slideshow sourced from `~/Pictures/wallpaper/`
  (synced in via Syncthing — set up Syncthing and let it populate this
  folder before reconfiguring the slideshow wallpaper)

Set both under *System Settings → Wallpaper* per-activity/-screen, or restore
`~/.config/plasma-org.kde.plasma.desktop-appletsrc` from the yadm-less backup
if a full panel/wallpaper layout restore is preferred over redoing it by hand.

## 8. Panel layout

The top panel is scripted rather than rebuilt by hand, so it comes out the
same on both the laptop and the desktop regardless of monitor layout.

One widget isn't a system package — install it first via KNewStuff
(*right-click panel → Add Widgets → Get New Widgets*, search "Command
Output") or manually:

```
git clone https://github.com/Zren/plasma-applet-commandoutput /tmp/commandoutput
kpackagetool6 --type Plasma/Applet --install /tmp/commandoutput/package
```

Then apply the panel layout (`~/.config/plasma-panel-layout.js`, tracked by
yadm) with:

```
~/.local/bin/setup-plasma-panel.sh
```

This removes any existing panels and recreates a single top panel with, in
order: the system tray, digital clock, CPU-core monitor, CPU monitor, power
usage, memory monitor, a spacer, and the Command Output widget. It's safe to
re-run.

The system tray's own pinned icons (network, Bluetooth, volume, battery,
brightness, clipboard, notifications, keyboard layout/indicator, weather,
camera, media controller) aren't part of the script — Plasma auto-populates
the tray from whatever status-notifier services are running, but which ones
are pinned always-visible vs. hidden under the chevron is a one-time manual
step: open the tray's chevron, right-click each icon, and choose "Show".

Desktop also has folder-view widgets pinned for quick file access (added by
hand, not scripted).

## 9. Post-install checks

- `atuin login` then enable the user service: `systemctl --user enable --now atuin.service`
- `rustup default stable`, `rbenv install <version>`, `sdk install java <version>` as needed
- `cargo install syncerting-tray aptmatic`
- Log into Syncthing (`http://localhost:8384`) and re-add sync folders (incl. `~/Pictures/wallpaper`)
- Set default shell if changed: this machine uses **bash** (with starship
  prompt + atuin history), not the `cachyos-fish-config` package's fish shell
- Enable fingerprint auth: `fprintd-enroll` (package `fprintd` is installed)
- `sudo systemctl enable --now bluetooth NetworkManager`
