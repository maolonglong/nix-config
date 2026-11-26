{
  config,
  lib,
  ...
}: {
  xdg = {
    enable = true;
    localBinInPath = true;
  };

  # Order matters: earlier entries win. `mkBefore` keeps user bins and mise
  # shims ahead of platform package managers (`home/darwin/homebrew.nix`,
  # `home/linux/default.nix`) regardless of module import depth. nix-darwin's
  # `environment.systemPath` already appends `/usr/local/bin` after the Nix
  # profiles, so keeping it out stops `.pkg` installers from shadowing them.
  home.sessionPath = lib.mkBefore [
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.bun/bin"
    "$HOME/.claude/local"
    "$HOME/.local/share/mise/shims"
    "${config.home.homeDirectory}/go/bin"
  ];
}
