{config, ...}: {
  # Order matters: earlier entries win. Host modules append their own entries.
  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.bun/bin"
    "$HOME/.claude/local"
    "$HOME/.local/share/mise/shims"
    "/opt/homebrew/bin"
    "${config.home.homeDirectory}/go/bin"
  ];
}
