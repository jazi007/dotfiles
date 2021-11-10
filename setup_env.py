import os


def setup_git():
    __git_config = r"""# Autogenerated do not change
[user]
    name = {user}
    email = {email}
[core]
    filemode = false
    # editor = vim
[fetch]
    prune = true
[alias]
    co = checkout
    st = status
    ls = log --pretty=format:"%C(yellow)%h\\ %cr%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --date=relative
    lsr = log --pretty=format:"%C(yellow)%h\\ %Creset%s%C(cyan)\\ [%an]"
    ll = log --pretty=format:"%C(yellow)%h\\ %cr%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --numstat --date=relative
    lg = log --graph --oneline --decorate
    ld = log --pretty=oneline --left-right
    dt = difftool
    mt = mergetool
    hc = clean -xffd
    brAll = branch --list --remote
    br = branch --list
    showBr = show --pretty=format:"%C(yellow)%h\\ %ad%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --date=relative
    delBr = branch -D
    pf = push --force-with-lease
    su = branch --set-upstream-to
    tagList = for-each-ref --format '%(refname) %09 %(taggerdate) %(subject) %(taggeremail)' refs/tags  --sort=taggerdate
    sbu = submodule update
    sbs = submodule sync
    sbf = submodule foreach
    pmrm = push -o merge_request.create -o merge_request.remove_source_branch -o merge_request.target=master
    pmrs = push -o merge_request.create -o merge_request.remove_source_branch -o merge_request.target=sqrt_master
    pmra = push -o merge_request.create -o merge_request.remove_source_branch -o merge_request.target=ad2gen2_master
    pmrd = push -o merge_request.create -o merge_request.remove_source_branch -o merge_request.target=sweet400_d2c_frcamadas_master
[push]
    default = upstream
[difftool]
    prompt = false
[diff]
    tool = nvim
[difftool "nvim"]
    cmd = "nvim -d \"$LOCAL\" \"$REMOTE\""
[merge]
    tool = nvim
[mergetool]
    prompt = false
[mergetool "nvim"]
    cmd = nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
[credential]
    helper = store --file ~/.git.store
[http]
    postBuffer = 1048576000
[lfs]
    fetchrecentrefsdays = 0
    fetchrecentcommitsdays = 0
    fetchrecentremoterefs = 0
    pruneoffsetdays = 0
    concurrenttransfers = 8
    forceprogress = 1

[url "https://"]
    insteadOf = git://
[pull]
    rebase = false
[color]
    ui = auto
[filter "lfs"]
    smudge = git-lfs smudge --skip -- %f
    process = git-lfs filter-process --skip
    required = true
    clean = git-lfs clean -- %f
"""
    default_user = "Nadhmi JAZI"
    user = input(f"User Name [{default_user}]:")
    if not user:
        user = default_user
    default_email = "nadhmi.jazi@gmail.com"
    email = input(f"User Email [{default_email}]:")
    if not email:
        email = default_email
    home = os.getenv('HOME', '')
    with open(os.path.join(home, '.gitconfig'), 'w') as f:
        f.write(__git_config.format(user=user, email=email))



def setup_bash():
    __bash = r"""#!/bin/bash

########################################
# /!\ Autogenerated file do not change #
########################################

# History
export HISTCONTROL=erasedups    # when adding an item to history, delete itentical commands upstream
export HISTSIZE=10000           # save 10000 items in history
shopt -s histappend             # append history to ~\.bash_history when exiting shell

# proxy
export http_proxy={http_proxy}
export https_proxy={https_proxy}

# aliases
alias ..='cd ..'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias envgrep='env|grep'
alias hgrep='history|grep'
alias cgrep='grep --include="*.[ch]"'
alias sudo='sudo -E'

alias callgrind='valgrind --tool=callgrind --dump-instr=yes --cache-sim=yes --branch-sim=yes --cacheuse=yes'

alias gmco='br=$(git rev-parse --abbrev-ref HEAD) && git submodule foreach "if [ ! -z \"\$(git branch -r | grep $br)\" ]; then git checkout $br ; fi" && unset br'
alias gmcor='br=$(git rev-parse --abbrev-ref HEAD) && git submodule foreach "if [ ! -z \"\$(git branch -r | grep $br)\" ]; then git fetch; git checkout $br ; git reset --hard origin/$br; fi" && unset br'

# vim / nvim / nvr
if [[ -x "$(command -v nvim)" ]]; then
    alias vim=nvim
    export VISUAL=nvim
    if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
        alias vim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
        alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
        export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    fi
    export MANPAGER="nvim -c 'set ft=man' -"
fi

# Starship
if [[ -x "$(command -v starship)" ]]; then
    export STARSHIP_CONFIG={starship}
    eval "$(starship init bash)"
fi

# bumpversion for python
if [[ -x "$(command -v bumpversion)" ]]; then
    alias bumpbuild="bumpversion build --allow-dirty"
    alias bumppatch="bumpversion patch --commit --tag"
    alias bumpminor="bumpversion minor --commit --tag"
    alias bumpmajor="bumpversion major --commit --tag"
fi
"""
    http_proxy = os.getenv('http_proxy', 'noproxy')
    https_proxy = os.getenv('https_proxy', 'noproxy')
    starship = os.path.abspath(os.path.join(os.path.dirname(__file__), "starship.toml"))
    # for MSYS make sure to have the correct path
    if os.getenv('MSYSTEM', None) is not None:
        starship = os.popen(f"cygpath {starship}").read().strip()
    home = os.getenv('HOME', '')
    with open(os.path.join(home, '.bash_aliases'), 'w') as f:
        f.write(__bash.format(http_proxy=http_proxy, https_proxy=https_proxy, starship=starship))


def setup():
    setup_git()
    setup_bash()

if __name__ == '__main__':
    home = os.getenv('HOME', None)
    if home is None:
        raise ValueError("HOME env not found")
    setup()
