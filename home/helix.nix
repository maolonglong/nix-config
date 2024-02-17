{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
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
    themes = {
      catppuccin_mocha = {
        attribute = "blue";
        comment = {fg = "overlay1";};
        constant = "peach";
        "constant.builtin" = "peach";
        "constant.character" = "teal";
        "constant.character.escape" = "pink";
        constructor = "sapphire";
        "diagnostic.error" = {
          underline = {
            color = "red";
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = "teal";
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "sky";
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = "yellow";
            style = "curl";
          };
        };
        "diff.delta" = "blue";
        "diff.minus" = "red";
        "diff.plus" = "green";
        error = "red";
        function = "blue";
        "function.macro" = "mauve";
        hint = "teal";
        info = "sky";
        keyword = "mauve";
        "keyword.control.conditional" = {fg = "mauve";};
        label = "sapphire";
        "markup.bold" = {modifiers = ["bold"];};
        "markup.heading.1" = "lavender";
        "markup.heading.2" = "mauve";
        "markup.heading.3" = "green";
        "markup.heading.4" = "yellow";
        "markup.heading.5" = "pink";
        "markup.heading.6" = "teal";
        "markup.heading.marker" = {
          fg = "peach";
          modifiers = ["bold"];
        };
        "markup.italic" = {modifiers = ["italic"];};
        "markup.link.text" = "blue";
        "markup.link.url" = {
          fg = "blue";
          modifiers = ["underlined"];
        };
        "markup.list" = "mauve";
        "markup.raw" = "flamingo";
        namespace = {fg = "blue";};
        operator = "sky";
        palette = {
          base = "#1e1e2e";
          blue = "#89b4fa";
          crust = "#11111b";
          cursorline = "#2a2b3c";
          flamingo = "#f2cdcd";
          green = "#a6e3a1";
          lavender = "#b4befe";
          mantle = "#181825";
          maroon = "#eba0ac";
          mauve = "#cba6f7";
          overlay0 = "#6c7086";
          overlay1 = "#7f849c";
          overlay2 = "#9399b2";
          peach = "#fab387";
          pink = "#f5c2e7";
          red = "#f38ba8";
          rosewater = "#f5e0dc";
          sapphire = "#74c7ec";
          secondary_cursor = "#b5a6a8";
          secondary_cursor_insert = "#7da87e";
          secondary_cursor_normal = "#878ec0";
          sky = "#89dceb";
          subtext0 = "#a6adc8";
          subtext1 = "#bac2de";
          surface0 = "#313244";
          surface1 = "#45475a";
          surface2 = "#585b70";
          teal = "#94e2d5";
          text = "#cdd6f4";
          yellow = "#f9e2af";
        };
        punctuation = "overlay2";
        "punctuation.special" = "sky";
        special = "blue";
        string = "green";
        "string.regexp" = "peach";
        "string.special" = "blue";
        tag = "mauve";
        type = "yellow";
        "ui.background" = {
          bg = "base";
          fg = "text";
        };
        "ui.bufferline" = {
          bg = "mantle";
          fg = "subtext0";
        };
        "ui.bufferline.active" = {
          bg = "base";
          fg = "mauve";
          underline = {
            color = "mauve";
            style = "line";
          };
        };
        "ui.bufferline.background" = {bg = "crust";};
        "ui.cursor" = {
          bg = "secondary_cursor";
          fg = "base";
        };
        "ui.cursor.insert" = {
          bg = "secondary_cursor_insert";
          fg = "base";
        };
        "ui.cursor.match" = {
          fg = "peach";
          modifiers = ["bold"];
        };
        "ui.cursor.normal" = {
          bg = "secondary_cursor_normal";
          fg = "base";
        };
        "ui.cursor.primary" = {
          bg = "rosewater";
          fg = "base";
        };
        "ui.cursor.primary.insert" = {
          bg = "green";
          fg = "base";
        };
        "ui.cursor.primary.normal" = {
          bg = "lavender";
          fg = "base";
        };
        "ui.cursor.primary.select" = {
          bg = "flamingo";
          fg = "base";
        };
        "ui.cursor.select" = {
          bg = "secondary_cursor";
          fg = "base";
        };
        "ui.cursorline.primary" = {bg = "cursorline";};
        "ui.help" = {
          bg = "surface0";
          fg = "overlay2";
        };
        "ui.highlight" = {
          bg = "surface1";
          modifiers = ["bold"];
        };
        "ui.linenr" = {fg = "surface1";};
        "ui.linenr.selected" = {fg = "lavender";};
        "ui.menu" = {
          bg = "surface0";
          fg = "overlay2";
        };
        "ui.menu.selected" = {
          bg = "surface1";
          fg = "text";
          modifiers = ["bold"];
        };
        "ui.popup" = {
          bg = "surface0";
          fg = "text";
        };
        "ui.selection" = {bg = "surface1";};
        "ui.statusline" = {
          bg = "mantle";
          fg = "subtext1";
        };
        "ui.statusline.inactive" = {
          bg = "mantle";
          fg = "surface2";
        };
        "ui.statusline.insert" = {
          bg = "green";
          fg = "base";
          modifiers = ["bold"];
        };
        "ui.statusline.normal" = {
          bg = "lavender";
          fg = "base";
          modifiers = ["bold"];
        };
        "ui.statusline.select" = {
          bg = "flamingo";
          fg = "base";
          modifiers = ["bold"];
        };
        "ui.text" = "text";
        "ui.text.focus" = {
          bg = "surface0";
          fg = "text";
          modifiers = ["bold"];
        };
        "ui.text.inactive" = {fg = "overlay1";};
        "ui.virtual" = "overlay0";
        "ui.virtual.indent-guide" = "surface0";
        "ui.virtual.inlay-hint" = {
          bg = "mantle";
          fg = "surface1";
        };
        "ui.virtual.ruler" = {bg = "surface0";};
        "ui.window" = {fg = "crust";};
        variable = "text";
        "variable.builtin" = "red";
        "variable.other.member" = "teal";
        "variable.parameter" = {fg = "maroon";};
        warning = "yellow";
      };
    };
  };
}
