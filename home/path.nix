{
  config,
  lib,
  pkgs,
  ...
}: {
  # Order matters: earlier entries win. nix-darwin's `environment.systemPath`
  # already appends `/usr/local/bin` after the Nix profiles, so keeping it out
  # of `sessionPath` stops `.pkg` installers from shadowing user/Nix binaries.
  home.sessionPath =
    [
      "$HOME/bin"
      "$HOME/.bin"
      "$HOME/.bun/bin"
      "$HOME/.claude/local"
      "$HOME/.local/share/mise/shims"
      "${config.home.homeDirectory}/go/bin"
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      "${config.home.homeDirectory}/.nix-profile/bin"
      "/nix/var/nix/profiles/default/bin"
    ];
}
