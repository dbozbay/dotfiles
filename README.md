## My Dotfiles (a.k.a. The World's Best Dev Setup)

Welcome to the finely tuned chaos that is my machine’s configuration.  

These are the user-level dotfiles for macOS, all happily versioned under `~/.config` so you can pretend you “just remember” all your tweaks.

### What’s in the box?

- **`aerospace/`**: Config for the AeroSpace tiling window manager (`aerospace.toml`, keybindings, gaps, workspace rules). Windows obey you now.

- **`ghostty/`**: Config and themes for the Ghostty terminal (`config` plus custom themes in `themes/`). Because the terminal should look as good as your excuses for not writing tests.

- **`nvim/`**: Neovim configuration (`init.lua`, LSP configs in `lsp/`, plugin lockfile). Basically a small IDE disguised as a text editor.

- **`uv/`**: Python/UV-related settings (like `.python-version`) to keep your Python environments slightly less cursed.

### How to steal this setup

- **Clone**: Put this repo in `~/.config` (or another config directory if you’re feeling rebellious).

- **Wire things up**: Point each tool at the right file/folder, or copy them where they’re expected (for example, `aerospace/aerospace.toml` → `~/.aerospace.toml`).

- **Tweak & commit**: Edit configs directly in `~/.config`, then commit your changes so your “world’s best” setup follows you to other machines.

### Notes & fine print

- Optimized for **macOS** (AeroSpace, Ghostty, specific app IDs/workspaces, etc.). Other OSes may experience feelings of inadequacy.

- Some tools need to be installed separately; check their official docs for the boring-but-important details.
