{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      theme = "catppuccin-mocha";
      pane_frames = true;
      ui = {
        pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };
      };
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 1000;
      serialization_interval = 30;
      show_startup_tips = false;
      show_release_notes = false;
      default_layout = "compact";
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = false;
      scroll_buffer_size = 50000;
      styled_underlines = true;
      osc8_hyperlinks = true;
      support_kitty_keyboard_protocol = true;
      web_server = false;
      web_sharing = "disabled";
    };
  };
}
