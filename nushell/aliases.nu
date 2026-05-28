# aliases.nu — ported from bash_aliases in setup_env.py
# Sourced by config.nu.

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..    = cd ..
alias ...   = cd ../..

# ── Listing (eza) ─────────────────────────────────────────────────────────────
alias ll    = eza -1 --icons --long --git-ignore
alias lla   = eza -1 --icons --long --all
alias la    = eza --all
alias l     = eza --icons
alias tree  = eza --icons --tree

# ── Viewing (bat) ─────────────────────────────────────────────────────────────
alias cat   = bat

# ── Search helpers ────────────────────────────────────────────────────────────
# hgrep: search shell history
def hgrep [pattern: string] {
  history | where command =~ $pattern
}

# envgrep: search environment variables
def envgrep [pattern: string] {
  $env | transpose key value | where key =~ $pattern
}

# cgrep: grep only C/H source files
def cgrep [pattern: string, ...paths: string] {
  let search_paths = if ($paths | is-empty) { ["."] } else { $paths }
  fd --extension c --extension h $"." ...$search_paths | xargs rg $pattern
}

# ── Git submodule helpers ─────────────────────────────────────────────────────
# gmco: checkout the same branch name in all submodules (if remote has it)
def gmco [] {
  let br = (git rev-parse --abbrev-ref HEAD | str trim)
  git submodule foreach $"if [ ! -z \"\$(git branch -r | grep ($br))\" ]; then git checkout ($br); fi"
}

# gmcor: same as gmco but also resets to remote
def gmcor [] {
  let br = (git rev-parse --abbrev-ref HEAD | str trim)
  git submodule foreach $"if [ ! -z \"\$(git branch -r | grep ($br))\" ]; then git fetch; git checkout ($br); git reset --hard origin/($br); fi"
}

# ── Editor ───────────────────────────────────────────────────────────────────
alias vim   = nvim

# ── sudo passthrough (preserve env) ──────────────────────────────────────────
alias sudo  = sudo -E

# ── Bumpversion ──────────────────────────────────────────────────────────────
alias bumpbuild   = bumpversion build --allow-dirty
alias bumppatch   = bumpversion patch --allow-dirty
alias bumpminor   = bumpversion minor --allow-dirty
alias bumpmajor   = bumpversion major --allow-dirty
alias bumprelease = bumpversion --commit --tag release

# ── Misc ─────────────────────────────────────────────────────────────────────
alias termreset = tput cnorm

# ── Valgrind ─────────────────────────────────────────────────────────────────
alias callgrind = valgrind --tool=callgrind --dump-instr=yes --cache-sim=yes --branch-sim=yes --cacheuse=yes

# ── rage secrets ──────────────────────────────────────────────────────────────
def get_secret [name: string] {
    let secrets_home = if "SECRETS_HOME" in $env { $env.SECRETS_HOME } else { $"($env.HOME)/.secrets" }
    let age_key_file = if "AGE_KEY_FILE" in $env { $env.AGE_KEY_FILE } else { $"($env.HOME)/.age/key.txt" }
    if not ($age_key_file | path exists) {
        error make { msg: $"age key not found: ($age_key_file) — run setup-rage.sh first" }
    }
    let file = $"($secrets_home)/($name).age"
    if not ($file | path exists) {
        error make { msg: $"secret not found: ($file)" }
    }
    ^rage -d -i $age_key_file $file | str trim
}

def add_secret [name: string] {
    let secrets_home = if "SECRETS_HOME" in $env { $env.SECRETS_HOME } else { $"($env.HOME)/.secrets" }
    let age_key_file = if "AGE_KEY_FILE" in $env { $env.AGE_KEY_FILE } else { $"($env.HOME)/.age/key.txt" }
    if not ($age_key_file | path exists) {
        error make { msg: $"age key not found: ($age_key_file) — run setup-rage.sh first" }
    }
    let pub = (
        open $age_key_file
        | lines
        | where { |l| $l | str starts-with "# public key: " }
        | first
        | str replace "# public key: " ""
    )
    mkdir $secrets_home
    let out = $"($secrets_home)/($name).age"
    if ($out | path exists) {
        let yn = (input $"  ($out) already exists — overwrite? [y/N] ")
        if not ($yn =~ '^[Yy]') { return }
    }
    let value = (input $"  Secret value for '($name)' \(input hidden\): " --suppress-output)
    $value | ^rage -r $pub -o $out
    print $"  ✓ encrypted → ($out)"
}

def list_secrets [] {
    let secrets_home = if "SECRETS_HOME" in $env { $env.SECRETS_HOME } else { $"($env.HOME)/.secrets" }
    if ($secrets_home | path exists) {
        glob $"($secrets_home)/*.age" | each { |f| $f | path basename | str replace ".age" "" }
    } else {
        print $"no secrets found in ($secrets_home)"
    }
}
