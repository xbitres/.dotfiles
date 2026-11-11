# .dotfiles

// TODO: Write useful documentation

## Manual config

### Terminal: Ghostty

Ghostty is installed by the Brewfile, and its config (`config/ghostty/config`) is linked to `~/.config/ghostty/config` by `link.sh`.

`macos/default-apps.sh` (run by `install.sh`) makes Ghostty the app that opens Unix executables from Finder. macOS has no single "default terminal" setting: `.command` files and some apps' "Open in Terminal" actions still use Terminal.app.
