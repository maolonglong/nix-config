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

    # Order 990: after fzf (910), before Starship, Atuin, and direnv (1000).
    # Starship wraps an existing zle-keymap-select, so the cursor update and
    # the prompt redraw both run. Ctrl-R is left for Atuin.
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

      _vi-set-cursor() {
        case ''${1:-$KEYMAP} in
          vicmd) printf '\e[2 q' ;;
          viopp) printf '\e[0 q' ;;
          *) printf '\e[6 q' ;;
        esac
      }
      zle-line-init() {
        (( ! ''${+terminfo[smkx]} )) || echoti smkx
        _vi-set-cursor main
      }
      zle-line-finish() {
        (( ! ''${+terminfo[rmkx]} )) || echoti rmkx
        printf '\e[0 q'
      }
      zle-keymap-select() {
        _vi-set-cursor "$KEYMAP"
      }
      zle -N zle-line-init
      zle -N zle-line-finish
      zle -N zle-keymap-select
    '';

    shellAliases = {
      j = "just";
      rm = "safe-rm";
      gl = "git pull";
      gco = "git checkout";
    };
  };
}
