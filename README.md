## My Dotfiles (a.k.a. The World's Best Dev Setup)

Welcome to the finely tuned chaos that is my machine’s configuration.  

These are the user-level dotfiles for macOS, organized for GNU Stow so you can pretend you “just remember” all your tweaks.

### What’s in the box?

- **`aerospace/`**: Config for the AeroSpace tiling window manager (`aerospace.toml`, keybindings, gaps, workspace rules). Windows obey you now.

- **`ghostty/`**: Config and themes for the Ghostty terminal (`config` plus custom themes in `themes/`). Because the terminal should look as good as your excuses for not writing tests.

- **`nvim/`**: Neovim configuration (`init.lua`, LSP configs in `lsp/`, plugin lockfile). Basically a small IDE disguised as a text editor.

- **`uv/`**: Python/UV-related settings (like `.python-version`) to keep your Python environments slightly less cursed.

### How to steal this setup

These dotfiles are organized for **GNU Stow**, the symlink farm manager that makes dotfile management less painful than manually copying files around.

#### First-time setup

1. **Install stow** (if you haven't already):

   ```bash
   # macOS
   brew install stow

   # Linux (Debian/Ubuntu)
   sudo apt install stow
   ```

2. **Clone this repo** to `~/.config` (or wherever you keep your dotfiles):

   ```bash
   git clone https://github.com/dbozbay/dotfiles.git
   cd dotfiles
   ```

3. **Stow all the packages** at once to your home directory:

   ```bash
   stow -t ~ .
   ```

   Or stow individual packages if you're picky:

   ```bash
   stow -t ~ aerospace
   stow -t ~ ghostty
   stow -t ~ nvim
   stow -t ~ uv
   ```

#### Daily usage

- **Edit configs**: Make changes directly in `~/.config/<package>/` — stow will keep the symlinks pointing to the right places.
- **Add new packages**: Create a new directory, mirror the target structure inside it, then `stow -t ~ <package-name>`.
- **Remove a package**: `stow -D -t ~ <package-name>` (the `-D` flag unstows it).
- **Update everything**: Just `git pull` and you're done. The symlinks stay intact.

#### What stow does

Stow creates symlinks from your dotfiles repo to the actual config locations. So `aerospace/.aerospace.toml` becomes `~/.aerospace.toml`, `nvim/.config/nvim/` becomes `~/.config/nvim/`, etc. Magic! ✨

### Notes & fine print

- Optimized for **macOS** (AeroSpace, Ghostty, specific app IDs/workspaces, etc.). Other OSes may experience feelings of inadequacy.

- Some tools need to be installed separately; check their official docs for the boring-but-important details.
