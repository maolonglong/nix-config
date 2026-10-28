{
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.shell-safe-rm
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # Home Manager emits `bindkey -v` at order 530, before autosuggestions,
    # fzf, and syntax highlighting bind their widgets.
    defaultKeymap = "viins";

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    # Order 990: after fzf (910) so these bindings are not reset, and before
    # Atuin (1000). Ctrl-R is left unset here. Do not emit DECSCUSR cursor
    # sequences: Ghostty cursor-style = block, and shell-integration-features
    # includes no-cursor. Oh My Zsh only changed the cursor when
    # VI_MODE_SET_CURSOR=true, which this config never set.
    initContent = lib.mkOrder 990 ''
      if [ -n "$REX_BIN_DIR" ]; then
        export PATH="$REX_BIN_DIR:$PATH"
      fi

      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'vv' edit-command-line
    '';

    shellAliases = {
      j = "just";
      rm = "safe-rm";
      gl = "git pull";
      gco = "git checkout";
    };
  };
}
