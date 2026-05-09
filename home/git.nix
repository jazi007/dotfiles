{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  programs.git = {
    enable = true;

    # ── Identity ─────────────────────────────────────────────────────────────
    # Name is set by bootstrap.sh → written to ~/.config/git/local.conf
    # Email is intentionally NOT set globally: useconfigonly = true (below)
    # enforces setting it per-repo with: git config user.email "you@example.com"
    includes = [
      { path = "~/.config/git/local.conf"; } # created by bootstrap.sh
    ];

    settings = {
      user.useconfigonly = true; # refuse to commit without name/email set

      core = {
        filemode = false;
      };

      fetch.prune = true;

      push = {
        default = "upstream";
        autoSetupRemote = true;
      };

      pull.rebase = false;

      diff = {
        tool = "nvim";
        colorMoved = "default";
      };

      difftool = {
        prompt = false;
        nvim.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      };

      merge.tool = "nvim";

      mergetool = {
        prompt = false;
        nvim.cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      # Use delta as pager for diffs
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };

      color.ui = "auto";

      http.postBuffer = 1048576000;

      credential.helper = "store --file ~/.git.store";

      "url \"https://\"".insteadOf = "git://";

      "filter \"lfs\"" = {
        smudge = "git-lfs smudge --skip -- %f";
        process = "git-lfs filter-process --skip";
        required = true;
        clean = "git-lfs clean -- %f";
      };

      lfs = {
        fetchrecentrefsdays = 0;
        fetchrecentcommitsdays = 0;
        fetchrecentremoterefs = 0;
        pruneoffsetdays = 0;
        concurrenttransfers = 8;
        forceprogress = 1;
      };
    };

    settings.alias = {
      co = "checkout";
      st = "status";
      ls = ''log --pretty=format:"%C(yellow)%h\\ %cr%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --date=relative'';
      lsr = ''log --pretty=format:"%C(yellow)%h\\ %Creset%s%C(cyan)\\ [%an]"'';
      ll = ''log --pretty=format:"%C(yellow)%h\\ %cr%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --numstat --date=relative'';
      lg = "log --graph --oneline --decorate";
      ld = "log --pretty=oneline --left-right";
      dt = "difftool";
      mt = "mergetool";
      hc = "clean -xffd";
      brAll = "branch --list --remote";
      br = "branch --list";
      showBr = ''show --pretty=format:"%C(yellow)%h\\ %ad%Cgreen%d\\ %Creset%s%C(cyan)\\ [%an]" --decorate --date=relative'';
      delBr = "branch -D";
      pf = "push --force-with-lease";
      su = "branch --set-upstream-to";
      ca = "commit --amend --no-edit";
      tagList = "for-each-ref --format '%(refname) %09 %(taggerdate) %(subject) %(taggeremail)' refs/tags --sort=taggerdate";
      sbu = "submodule update";
      sbs = "submodule sync";
      sbf = "submodule foreach";
      # GitLab merge request push aliases
      pmrm = "push -o merge_request.create -o merge_request.remove_source_branch -o merge_request.target=master";
    };
  };
}
