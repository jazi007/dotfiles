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
| dev environments | [direnv](https://direnv.net/) + [nix-direnv](https://github.com/nix-community/nix-direnv) |
| Fallback shell | bash (configured by home-manager) |

---

## Development

### Adding a CLI tool

1. Add the package to `home/tools.nix` under `home.packages`:
   ```nix
   home.packages = with pkgs; [
     # ... existing tools ...
     your-new-tool
   ];
   ```
   For tools with shell integration (completions, hooks), use the `programs.*` module instead of a raw package — see the existing `fzf`, `zoxide`, `bat`, `eza`, `direnv` entries in `home/tools.nix`.

2. Validate the config:
   ```bash
   nix flake check
   ```

3. Apply to the current machine:
   ```bash
   home-manager switch --flake .#default --impure
   ```

### Before committing

Run these in order from the repo root:

```bash
# 1. Ensure all new/changed files are staged
git add -A

# 2. Validate the flake (type-checks all nix files)
nix flake check

# 3. Update flake.lock to the latest nixpkgs/home-manager revisions (optional)
nix flake update

# 4. Apply locally and smoke-test
home-manager switch --flake .#default --impure

# 5. Commit
git commit -m "feat: ..."

# 6. Tag a release if warranted
git tag -a vX.Y -m "vX.Y — short description"
git push && git push --tags
```

> `nix flake update` rewrites `flake.lock`. Commit the updated lock file together with the code change so the revision is reproducible.

---

## Quick Start

Bootstrap a fresh machine (Nix must be installed):

```bash
git clone https://github.com/jazi007/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` handles everything interactively:
- Asks for your **git user name** (writes `~/.config/git/local.conf`)
- Asks for an optional **corporate proxy** and configures the nix daemon
- Runs `home-manager switch --flake .#default --impure` (or `nix run` if not in PATH yet)

> **Note on git email:** email is intentionally NOT set globally. Set it per repo:
> ```bash
> git config user.email "you@example.com"
> ```
> `useconfigonly = true` in `git.nix` ensures git refuses commits until you do this.

After bootstrap completes:
1. Set your terminal font to **FiraCode Nerd Font** for icons to render correctly
2. Set nushell as your default shell: `chsh -s $(which nu)`
3. For machine-specific env vars (proxy, work aliases): create `~/.config/nushell/local.nu`

### Neovim plugins

On first nvim launch, lazy.nvim auto-installs all plugins. Or trigger manually:
```
:Lazy sync
```

Mason LSP servers (installed inside nvim):
```
:MasonInstall lua-language-server clangd pyright cmake rust-analyzer
```
