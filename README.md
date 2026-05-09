# dotfiles

Personal dotfiles for neovim, git, shell, and terminal environment.

## Stack

| Component | Tool |
|-----------|------|
| Package manager | [Nix](https://nixos.org/) + [home-manager](https://github.com/nix-community/home-manager) |
| Shell | [Nushell](https://www.nushell.sh/) |
| Prompt | [Starship](https://starship.rs/) |
| Editor | [Neovim](https://neovim.io/) + [lazy.nvim](https://github.com/folke/lazy.nvim) |
| Terminal mux | [tmux](https://github.com/tmux/tmux) |
| Directory jump | [zoxide](https://github.com/ajeetdsouza/zoxide) |
| Fuzzy finder | [fzf](https://github.com/junegunn/fzf) |
| `ls` | [eza](https://github.com/eza-community/eza) |
| `cat` | [bat](https://github.com/sharkdp/bat) |
| `find` | [fd](https://github.com/sharkdp/fd) |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| git diff pager | [delta](https://github.com/dandavison/delta) |

---

## Migration Checklist

Track progress through the migration from the old bash/manual setup to the modern Nix-based environment.

### Step 1 — Install Nix

- [x] Install Nix (single-user recommended for non-NixOS)
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```
- [x] Enable flakes and nix-command in `~/.config/nix/nix.conf`:
  ```
  experimental-features = nix-command flakes
  ```
- [x] Verify: `nix --version` and `nix flake --help` work — **Nix 2.34.1, flakes enabled**
- [x] Install home-manager as a flake (managed via `flake.nix`)

---

### Step 2 — Create `flake.nix` and home-manager config

- [x] Create `flake.nix` at repo root with `nixpkgs` + `home-manager` inputs
- [x] Create `home/default.nix` that imports all module files
- [x] Create `home/tools.nix` declaring all CLI tools (zoxide, fzf, bat, eza, fd, ripgrep, delta, starship, tmux, neovim)
- [x] Create `home/git.nix` porting gitconfig from `setup_env.py`
- [x] Create `home/starship.nix` pointing at existing `starship.toml`
- [x] Create `home/tmux.nix` linking existing `tmux.conf`
- [x] Run `nix flake check` to validate
- [x] Run `home-manager switch --flake .#default --impure` to apply
  > `--impure` is required: the flake reads `$USER` and `$HOME` from the environment
  > **Bootstrap** (first time, before `home-manager` is in PATH): `nix run github:nix-community/home-manager -- switch --flake .#default --impure`
  > **Proxy note** (corporate networks): add proxy to nix daemon via `/etc/systemd/system/nix-daemon.service.d/proxy.conf`
- [x] Verify all tools are available: `zoxide`, `fzf`, `bat`, `eza`, `fd`, `rg`, `delta`, `nu`, `starship` — all confirmed in `~/.nix-profile/bin/`
- [ ] Delete `set_env.sh` and `setup_env.py` once nushell is set as default shell

---

### Step 3 — Migrate shell to Nushell

- [x] Create `nushell/env.nu` — PATH, VISUAL, EDITOR, proxy stubs, starship/zoxide hooks
- [x] Create `nushell/aliases.nu` — all aliases from `setup_env.py` ported to nushell
- [x] Create `nushell/config.nu` — vi mode, fuzzy completions, fzf keybindings, local override hook
- [x] Add `home/nushell.nix` — live symlinks via `mkOutOfStoreSymlink`, zoxide init activation
- [ ] Run `home-manager switch --flake .#default --impure` (installs nushell via nix)
- [ ] Test all ported aliases interactively
- [ ] Set nushell as default shell: `chsh -s $(which nu)`

---

### Step 4 — Neovim: critical fixes (safe, non-breaking)

- [x] Replace `folke/neodev.nvim` → `folke/lazydev.nvim` in `nvim/lua/plugins/lsp/lspconfig.lua`
  - neodev is officially deprecated since Neovim 0.10+
  - lazydev is a drop-in replacement with near-instant startup
  - configured with `luv` library for `vim.uv` completions
- [x] Replace `shaunsingh/nord.nvim` → `gbprod/nord.nvim` in `nvim/lua/plugins/colorscheme.lua`
  - shaunsingh fork is unmaintained; gbprod has full treesitter + LSP semantic token support
  - ported inlay hint color override via `on_highlights` callback
  - old `vim.g.nord_*` globals removed (not supported in gbprod fork)
- [ ] Open nvim and verify: `:Lazy sync` to install new plugins, then check LSP and colorscheme

---

### Step 5 — Neovim: replace nvim-cmp with blink.cmp

- [x] Create `nvim/lua/plugins/blink-cmp.lua` with `saghen/blink.cmp`
  - Rust-based, 2–5× faster completion
  - Native fuzzy matching, native snippet engine (no LuaSnip needed)
  - Same keymaps: `C-j/k` navigate, `CR` confirms, `C-e` aborts, `C-b/f` scroll docs
  - Sources: lazydev (Lua API, score +100), lsp, snippets, buffer, path
  - `rafamadriz/friendly-snippets` kept as dependency
- [x] Disable `nvim/lua/plugins/nvim-cmp.lua` — **deleted**; old stack removed from disk
- [x] Remove `hrsh7th/cmp-nvim-lsp` from `lspconfig.lua` — blink.cmp auto-patches LSP capabilities
- [x] Dropped orphaned deps: `cmp-buffer`, `cmp-path`, `cmp_luasnip`, `lspkind.nvim`, `LuaSnip`
- [ ] Open nvim and run `:Lazy sync` to install blink.cmp and remove old cmp stack
- [ ] Verify completion works for lua, rust, python, C

---

### Step 6 — Neovim: add snacks.nvim (replaces alpha + dressing)

- [x] Created `nvim/lua/plugins/snacks.lua` with `folke/snacks.nvim`
- [x] `snacks.dashboard` — same header + buttons as old alpha dashboard, plus lazygit button
- [x] `snacks.input` — replaces `dressing.nvim` for `vim.ui.input`
- [x] `snacks.notifier` — replaces default `vim.notify` (compact style, 3s timeout)
- [x] `snacks.lazygit` — `<leader>gg` opens lazygit, `<leader>gf` file log, `<leader>gl` branch log
- [x] `snacks.indent` — animated indent guides with scope highlighting
- [x] `snacks.words` — highlights all occurrences of word under cursor; `]]`/`[[` to jump
- [x] `snacks.bigfile` — disables heavy features on large files automatically
- [x] `snacks.terminal` — floating terminal via `<leader>tt`
- [x] Deleted `nvim/lua/plugins/alpha.lua` and `nvim/lua/plugins/dressing.lua`
- [ ] Open nvim → `:Lazy sync` → verify dashboard, lazygit, and notifications

---

### Step 7 — Neovim: optional quality-of-life additions

- [x] Added `nvim/lua/plugins/grug-far.lua` (`MagicDuck/grug-far.nvim`) — project-wide find & replace
  - `<leader>sr` in normal or visual mode; pre-fills word under cursor
  - Scopes search to current filetype by default
- [x] Added `nvim/lua/plugins/ufo.lua` (`kevinhwang91/nvim-ufo`) — LSP/treesitter-aware folding
  - Provider order: LSP → treesitter → indent (per filetype)
  - `zR` open all, `zM` close all, `zK` peek fold / hover
  - Fold virtual text shows `⋯ N lines` summary
  - `settings.lua` `foldmethod=indent` kept as fallback only; ufo takes ownership
- [x] Replaced `nvim-tree/nvim-tree.lua` → `nvim-neo-tree/neo-tree.nvim` (`nvim/lua/plugins/neo-tree.lua`)
  - Same keymaps: `<leader>ee` toggle, `<leader>ef` reveal, `<leader>ec` close
  - New: `<leader>eb` buffer list, `<leader>eg` git status float panel
  - `h`/`l` to collapse/open nodes, `H` toggle hidden files
  - Auto-follows current buffer, libuv file watcher for instant refresh
  - Dotfiles and gitignored files shown (matches old config)
  - `nvim-tree.lua` **deleted**
  - Snacks dashboard button updated from `NvimTreeToggle` → `Neotree toggle`
- [x] Added `nvim/lua/plugins/mini-surround.lua` (`echasnovski/mini.surround`)
  - Prefix `gz` to avoid conflict with `substitute.nvim`'s `s` operator
  - `gza` add, `gzd` delete, `gzr` replace, `gzf`/`gzF` find, `gzh` highlight
- [ ] Open nvim → `:Lazy sync` → test `<leader>sr`, fold keymaps, `<leader>ee`, and `gza`

---

### Step 8 — Final cleanup

- [x] Add `neovim`, `lazygit`, and Nerd Fonts to `home/tools.nix` — all managed by nix
  - `nerd-fonts.fira-code` — FiraCode with full Nerd Font glyph set (fixes neo-tree/lualine icons)
  - `nerd-fonts.symbols-only` — fallback symbols font for any terminal
  - `lazygit` — required by `snacks.lazygit` in nvim
- [x] Deleted `set_env.sh` and `setup_env.py` — replaced entirely by `home-manager switch`
- [x] Updated Quick Start below with new one-command bootstrap
- [ ] Run `home-manager switch --flake .#default --impure` to pull neovim + fonts from nix
- [ ] Set terminal font to **FiraCode Nerd Font** (or **FiraCode NF**) in terminal emulator preferences
- [ ] Set nushell as default shell: `chsh -s $(which nu)`
- [ ] Verify full bootstrap on a clean machine: `git clone → home-manager switch → done`
- [ ] Commit and tag `v2.0` release:
  ```bash
  git commit -m "feat: migrate to nix + nushell + modern neovim stack"
  git tag -a v2.0 -m "v2.0 — Nix/home-manager, Nushell, blink.cmp, snacks.nvim, neo-tree"
  git push && git push --tags
  ```

---

## Quick Start

Bootstrap a fresh machine in one command (Nix must be installed — Step 1):

```bash
git clone https://github.com/jazi007/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix run github:nix-community/home-manager -- switch --flake .#default --impure
```

> **Corporate proxy:** before running the above, ensure the nix daemon has proxy access:
> ```bash
> sudo mkdir -p /etc/systemd/system/nix-daemon.service.d
> sudo tee /etc/systemd/system/nix-daemon.service.d/proxy.conf <<EOF
> [Service]
> Environment="http_proxy=http://your-proxy:port"
> Environment="https_proxy=http://your-proxy:port"
> Environment="no_proxy=localhost,127.0.0.1"
> EOF
> sudo systemctl daemon-reload && sudo systemctl restart nix-daemon
> ```

After `home-manager switch`:
1. Set your terminal font to **FiraCode Nerd Font** for icons to render correctly
2. Create `~/.config/git/local.conf` with your name/email (not in repo):
   ```ini
   [user]
     name  = Your Name
     email = you@example.com
   ```
3. Set nushell as your default shell: `chsh -s $(which nu)`
4. For machine-specific env vars (proxy, work aliases): create `~/.config/nushell/local.nu`

### Neovim plugins

On first nvim launch, lazy.nvim auto-installs all plugins. Or trigger manually:
```
:Lazy sync
```

Mason LSP servers (installed inside nvim):
```
:MasonInstall lua-language-server clangd pyright cmake rust-analyzer
```
