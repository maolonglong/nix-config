{config, ...}: {
  # Order matters: earlier entries win. nix-darwin's `environment.systemPath`
  # already appends `/usr/local/bin` after the Nix profiles, so keeping it out
  # of `sessionPath` stops `.pkg` installers from shadowing user/Nix binaries.
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.bun/bin"
    "$HOME/.claude/local"
    "$HOME/.local/share/mise/shims"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "${config.home.homeDirectory}/go/bin"
  ];
}
