{pkgs, ...}: {
  home.packages = with pkgs; [
    gnupg
    age
  ];

  # Re-export per interactive shell: panes inherit a stale GPG_TTY from the
  # multiplexer server, and gpg-agent needs the pane's own tty for pinentry.
  programs.zsh.initContent = ''
    export GPG_TTY=$(tty)
  '';
}
