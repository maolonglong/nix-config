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
  home.file."${configDir}/config".text = ''
    auto-update-channel = tip
    clipboard-paste-protection = true
    clipboard-trim-trailing-spaces = true
    copy-on-select = false
    cursor-style = block
    cursor-style-blink = false
    font-family = FiraCode Nerd Font
    font-family = FiraCode Nerd Font Mono
    font-family = JetBrains Maple Mono
    font-family = JetBrainsMono Nerd Font
    font-size = 12
    keybind = shift+enter=text:\n
    macos-option-as-alt = left
    macos-titlebar-proxy-icon = hidden
    macos-titlebar-style = tabs
    mouse-hide-while-typing = true
    scrollback-limit = 104857600
    shell-integration = zsh
    shell-integration-features = sudo,no-cursor,ssh-terminfo,ssh-env
    theme = Catppuccin Mocha
    unfocused-split-opacity = 0.85
    window-decoration = true
    window-padding-balance = true
    window-padding-x = 8
    window-padding-y = 6
    window-theme = dark
  '';
}
