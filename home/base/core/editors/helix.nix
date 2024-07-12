{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        true-color = true;
        bufferline = "multiple";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        cursorline = true;
        file-picker = {hidden = false;};
        indent-guides = {
          character = "╎";
          render = true;
          skip-levels = 1;
        };
        line-number = "relative";
        lsp = {display-inlay-hints = false;};
        mouse = false;
        rulers = [99];
        scrolloff = 10;
        statusline = {
          center = ["file-name" "read-only-indicator" "file-modification-indicator"];
          left = ["mode" "spacer" "spinner"];
          mode = {
            insert = "INSERT";
            normal = "NORMAL";
            select = "SELECT";
          };
          right = ["diagnostics" "selections" "register" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "│";
        };
      };
      keys = {
        insert = {
          C-h = "move_char_left";
          C-j = "move_visual_line_down";
          C-k = "move_visual_line_up";
          C-l = "move_char_right";
          j = {
            j = "normal_mode";
            k = "normal_mode";
          };
        };
        normal = {
          C-h = "jump_view_left";
          C-j = "jump_view_down";
          C-k = "jump_view_up";
          C-l = "jump_view_right";
          S-tab = "goto_previous_buffer";
          space = {
            X = ":buffer-close!";
            x = ":buffer-close";
          };
          tab = "goto_next_buffer";
        };
      };
      theme = "catppuccin_mocha";
    };
    languages = {
      grammar = [
        {
          name = "thrift";
          source = {
            git = "https://github.com/duskmoon314/tree-sitter-thrift";
            rev = "d4deb1bd9e848f2dbe81103a151d99e8546de480";
          };
        }
      ];
      language = [
        {
          formatter = {
            args = ["-local=github.com/maolonglong,go.chensl.me"];
            command = "gosimports";
          };
          name = "go";
        }
        {
          comment-token = "//";
          file-types = ["thrift"];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          injection-regex = "thrift";
          name = "thrift";
          roots = [];
          scope = "source.thrift";
        }
      ];
    };
  };
}
