# .dotfiles

macOS setup: Homebrew packages, zsh, git, SSH, Ghostty and VS Code Insiders config.

## Fresh machine

```bash
git clone https://github.com/xbitres/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` runs, in order:

1. `brew/install.sh`: installs Homebrew if needed, then everything in `brew/Brewfile` (formulae, casks, VS Code extensions, Go tools).
2. `zsh/install.sh`: installs Oh My Zsh (unattended, keeps `~/.zshrc`).
3. `link.sh`: links the tracked config into `$HOME` and creates the machine-local files (see below).
4. `macos/default-apps.sh`: makes Ghostty the app that opens Unix executables.

Then finish by hand:

- Edit `~/.gitconfig.local` and set your git `user.name` and `user.email`.
- Add SSH host aliases and keys to `~/.ssh/config.local`, then load a key once with `ssh-add --apple-use-keychain ~/.ssh/<key>`.
- Optionally review and run `./macos/defaults.sh` (keyboard, Finder, Dock preferences).
- Open a new terminal (`exec zsh`).

Every script is safe to run again.

## What gets linked

| Repo file | Linked to |
|---|---|
| `config/.zshrc` | `~/.zshrc` |
| `config/.gitconfig` | `~/.gitconfig` |
| `config/.nanorc` | `~/.nanorc` |
| `config/ssh/config` | `~/.ssh/config` |
| `config/ghostty/config` | `~/.config/ghostty/config` |
| `config/vscode/settings.json`, `keybindings.json` | `~/Library/Application Support/Code - Insiders/User/` |

If a target already exists, `link.sh` moves it to `<file>.backup.<timestamp>` first.

VS Code Insiders settings are **adopted**: if the repo doesn't have the file yet, the first run copies your existing file into `config/vscode/` and links it. Commit the new file afterwards.

## Machine-local files (not tracked)

`link.sh` creates these from templates in `config/` only if they don't exist, and never overwrites them:

| File | Template | Use for |
|---|---|---|
| `~/.zshrc.local` | `config/.zshrc.local.example` | Work or project tooling, machine-specific PATHs, `PROTO_INCLUDE` |
| `~/.gitconfig.local` | `config/.gitconfig.local.example` | Git identity, per-host credentials, `includeIf` for work repos |
| `~/.ssh/config.local` | `config/ssh/config.local.example` | Host aliases and identity files |

Each is loaded by its tracked counterpart: last for zsh and git, so it overrides; first for SSH, where the first match wins. If `~/.ssh/config` already exists as a regular file on the first run, it is moved to `~/.ssh/config.local`, so existing hosts keep working.

If a tool's installer appends to `~/.zshrc` (a symlink into this repo), move what it added into `~/.zshrc.local`.

## Homebrew

- Add or remove packages by editing `brew/Brewfile`; each entry has a description comment.
- `brew bundle install --file=brew/Brewfile` installs what's missing.
- `./brew/check.sh` shows what's missing from or extra to the Brewfile. It doesn't change anything.
- `brew bundle cleanup --file=brew/Brewfile --force` uninstalls everything not in the Brewfile.

## Shell helpers

| Command | What it does |
|---|---|
| `z <dir>` / `zi <dir>` (`zz`) | Jump to a frequently used directory (zoxide); `zi` picks interactively with fzf |
| `git bclean` | Delete local branches merged into the default branch (`main` or `master`) |
| `kpf <service> <ports> <context> <namespace>` | Port-forward to the first pod matching a service name |
| `protod <message.Type> <base64>` | Decode a base64url protobuf; needs `PROTO_INCLUDE` set in `~/.zshrc.local`. With only `<base64>`, decodes raw |
| `viewSwagger <file>` | Serve an OpenAPI/Swagger file with Swagger UI on http://localhost |
| `k`, `ks` | `kubectl`, `kubectl config get-contexts` |
| `l`, `ls`, `lt` | `eza` long, all, and tree listings |
| `gpr` | `git pull --rebase` |

## Terminal

Ghostty is the terminal. It's installed by the Brewfile and configured in `config/ghostty/config`. macOS has no single "default terminal" setting: `macos/default-apps.sh` makes Ghostty open Unix executables from Finder, but `.command` files and some apps' "Open in Terminal" actions still use Terminal.app.
