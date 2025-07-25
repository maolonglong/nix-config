{
  pkgs,
  config,
  ...
}: let
  configDir =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/com.mitchellh.ghostty"
    else "${config.xdg.configHome}/ghostty";
in {
  # It feels a bit strange to manage GUI applications with home-manager...
  # programs.ghostty = {
  #   enable = true;
  # };

  home.file."${configDir}/config".text = ''
    copy-on-select = true
    cursor-style = block
    cursor-style-blink = false
    Font-family = JetBrains Maple Mono
    font-family = FiraCode Nerd Font Mono
    font-size = 12
    macos-option-as-alt = left
    macos-titlebar-proxy-icon = hidden
    macos-titlebar-style = tabs
    shell-integration = zsh
    shell-integration-features = sudo,no-cursor
    theme = catppuccin-mocha
    window-decoration = true
    window-padding-balance = true
    window-padding-x = 10
    window-padding-y = 10
    keybind = shift+enter=text:\n
  '';
}
