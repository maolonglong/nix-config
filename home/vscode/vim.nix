{...}: {
  programs.vscode = {
    userSettings = {
      "vim.camelCaseMotion.enable" = true;
      "vim.easymotion" = true;
      "vim.easymotionKeys" = "etovxqpdygfblzhckisuran";
      "vim.foldfix" = true;
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.insertModeKeyBindingsNonRecursive" = [
        {
          before = ["j" "j"];
          after = ["<Esc>"];
        }
        {
          before = ["j" "k"];
          after = ["<Esc>"];
        }
        {
          before = ["<C-h>"];
          after = ["<Left>"];
        }
        {
          before = ["<C-j>"];
          after = ["<Down>"];
        }
        {
          before = ["<C-k>"];
          after = ["<Up>"];
        }
        {
          before = ["<C-l>"];
          after = ["<Right>"];
        }
      ];
      "vim.leader" = "<space>";
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          before = ["<leader>" "a"];
          commands = ["gitlens.toggleFileBlame"];
        }
        {
          before = [">"];
          commands = ["editor.action.indentLines"];
        }
        {
          before = ["<"];
          commands = ["editor.action.outdentLines"];
        }
        {
          before = ["<leader>" "n"];
          commands = [":nohl"];
        }
        {
          before = ["<S-k>"];
          commands = ["editor.action.showHover"];
        }
        {
          before = ["g" "r"];
          commands = ["editor.action.referenceSearch.trigger"];
        }
        {
          before = ["g" "i"];
          commands = ["editor.action.peekImplementation"];
        }
        {
          before = ["<leader>" "r"];
          commands = ["editor.action.rename"];
        }
        {
          before = ["<leader>" "s"];
          commands = ["workbench.action.gotoSymbol"];
        }
        {
          before = ["<leader>" "f"];
          commands = ["workbench.action.quickOpen"];
        }
        {
          before = ["g" "s"];
          after = ["^"];
        }
        {
          before = ["g" "h"];
          after = ["0"];
        }
        {
          before = ["g" "l"];
          after = ["$"];
        }
        {
          before = ["g" "e"];
          after = ["G"];
        }
      ];
      "vim.sneak" = true;
      "vim.useSystemClipboard" = true;
      "vim.visualModeKeyBindings" = [
        {
          before = [">"];
          commands = ["editor.action.indentLines"];
        }
        {
          before = ["<"];
          commands = ["editor.action.outdentLines"];
        }
        {
          after = ["p" "g" "v" "y"];
          before = ["p"];
        }
      ];

      # To improve performance.
      "extensions.experimental.affinity" = {
        "vscodevim.vim" = 1;
      };
    };

    keybindings = [
      {
        key = "ctrl+w v";
        command = "workbench.action.splitEditorRight";
        when = "editorTextFocus && vim.active && vim.use<C-w> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+w s";
        command = "workbench.action.splitEditorDown";
        when = "editorTextFocus && vim.active && vim.use<C-w> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.focusLeftGroup";
        when = "editorTextFocus && vim.active && vim.use<C-h> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.focusRightGroup";
        when = "editorTextFocus && vim.active && vim.use<C-l> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.focusAboveGroup";
        when = "editorTextFocus && vim.active && vim.use<C-k> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+j";
        command = "workbench.action.focusBelowGroup";
        when = "editorTextFocus && vim.active && vim.use<C-j> && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        key = "ctrl+j";
        command = "selectNextSuggestion";
        when = "suggestWidgetVisible";
      }
      {
        key = "ctrl+k";
        command = "selectPrevSuggestion";
        when = "suggestWidgetVisible";
      }
      {
        key = "ctrl+j";
        command = "workbench.action.quickOpenSelectNext";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.quickOpenSelectPrevious";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+i";
        command = "workbench.action.navigateForward";
        when = "canNavigateForward";
      }
      {
        key = "ctrl+o";
        command = "workbench.action.navigateBack";
        when = "canNavigateBack";
      }
      {
        key = "tab";
        command = "togglePeekWidgetFocus";
        when = "inReferenceSearchEditor && vim.mode == 'Normal' || referenceSearchVisible";
      }
    ];
  };
}
