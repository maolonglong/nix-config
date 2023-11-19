{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    # package = pkgs.vscodium;

    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      christian-kohler.path-intellisense
      codezombiech.gitignore
      davidanson.vscode-markdownlint
      donjayamanne.githistory
      eamodio.gitlens
      editorconfig.editorconfig
      esbenp.prettier-vscode
      foxundermoon.shell-format
      github.github-vscode-theme
      github.vscode-github-actions
      github.vscode-pull-request-github
      golang.go
      grapecity.gc-excelviewer
      gruntfuggly.todo-tree
      jebbs.plantuml
      jnoortheen.nix-ide
      mechatroner.rainbow-csv
      mhutchie.git-graph
      mikestead.dotenv
      mkhl.direnv
      ms-azuretools.vscode-docker
      ms-ceintl.vscode-language-pack-zh-hans
      ms-python.black-formatter
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode.cmake-tools
      # ms-vscode.cpptools
      ms-vscode.hexeditor
      ms-vscode.makefile-tools
      pkief.material-icon-theme
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      serayuzgur.crates
      shd101wyy.markdown-preview-enhanced
      skellock.just
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      timonwong.shellcheck
      twxs.cmake
      usernamehw.errorlens
      # vadimcn.vscode-lldb
      vscodevim.vim
      yzhang.markdown-all-in-one
      zxh404.vscode-proto3
    ];

    userSettings = {
      "[dockerfile]" = {
        "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[markdown]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnType" = true;
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[yaml]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "[zig]" = {
        "editor.defaultFormatter" = "ziglang.vscode-zig";
      };
      "C_Cpp.clang_format_fallbackStyle" = "{ BasedOnStyle: Google, IndentWidth: 4, AlignConsecutiveDeclarations: true, AlignConsecutiveAssignments: true, ColumnLimit: 99 }";
      "cSpell.allowCompoundWords" = true;
      "cSpell.language" = "en,en-US";
      "debug.allowBreakpointsEverywhere" = true;
      "diffEditor.experimental.showMoves" = true;
      "diffEditor.hideUnchangedRegions.enabled" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.accessibilitySupport" = "off";
      "editor.cursorBlinking" = "phase";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorSurroundingLines" = 10;
      "editor.fontFamily" = "Noto Sans Mono CJK SC";
      "editor.fontSize" = 12;
      "editor.guides.bracketPairs" = "active";
      "editor.hover.sticky" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.lineNumbers" = "relative";
      "editor.linkedEditing" = true;
      "editor.minimap.enabled" = false;
      "editor.rulers" = [99];
      "editor.semanticHighlighting.enabled" = true;
      "editor.smoothScrolling" = true;
      "editor.stickyScroll.enabled" = true;
      "editor.suggest.snippetsPreventQuickSuggestions" = false;
      "editor.suggestSelection" = "first";
      "errorLens.enabledDiagnosticLevels" = ["warning" "error"];
      "errorLens.excludeBySource" = ["cSpell" "Grammarly" "eslint"];
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.autoUpdate" = "onlyEnabledExtensions";
      "files.eol" = "\n";
      "files.insertFinalNewline" = true;
      "files.simpleDialog.enable" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.autofetch" = true;
      "git.mergeEditor" = true;
      "go.alternateTools" = {
        customFormatter = "gosimports";
      };
      "go.formatTool" = "custom";
      "go.inlayHints.assignVariableTypes" = true;
      "go.inlayHints.compositeLiteralFields" = true;
      "go.inlayHints.constantValues" = true;
      "go.inlayHints.functionTypeParameters" = true;
      "go.inlayHints.parameterNames" = true;
      "go.inlayHints.rangeVariableTypes" = true;
      "go.toolsManagement.autoUpdate" = true;
      "gopls" = {
        "build.buildFlags" = [
          "-tags=wireinject"
        ];
        "ui.completion.usePlaceholders" = false;
        "ui.diagnostic.analyses" = {
          fieldalignment = true;
          nilness = true;
          unusedparams = true;
          unusedvariable = true;
          unusedwrite = true;
          useany = true;
        };
        "ui.semanticTokens" = true;
      };
      "haskell.manageHLS" = "GHCup";
      "haskell.toolchain" = {
        cabal = "3.6.2.0";
        ghc = "9.2.8";
        hls = "2.2.0.0";
        stack = "2.9.3";
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        nil = {
          diagnostics = {
            ignored = ["unused_binding" "unused_with"];
          };
          formatting = {
            command = ["alejandra"];
          };
        };
      };
      "prettier.semi" = false;
      "prettier.singleQuote" = true;
      "python.analysis.typeCheckingMode" = "basic";
      "redhat.telemetry.enabled" = false;
      "security.workspace.trust.enabled" = false;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "terminal.integrated.minimumContrastRatio" = 1;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "vim.camelCaseMotion.enable" = true;
      "vim.easymotion" = true;
      "vim.easymotionKeys" = "etovxqpdygfblzhckisuran";
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.insertModeKeyBindings" = [
        {
          after = ["<Esc>"];
          before = ["j" "j"];
        }
        {
          after = ["<Esc>"];
          before = ["j" "k"];
        }
        {
          after = ["<Left>"];
          before = ["<C-h>"];
        }
        {
          after = ["<Down>"];
          before = ["<C-j>"];
        }
        {
          after = ["<Up>"];
          before = ["<C-k>"];
        }
        {
          after = ["<Right>"];
          before = ["<C-l>"];
        }
      ];
      "vim.leader" = "<space>";
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          before = ["<leader>" "a"];
          "commands" = ["gitlens.toggleFileBlame"];
        }
        {
          before = [">"];
          "commands" = ["editor.action.indentLines"];
        }
        {
          before = ["<"];
          "commands" = ["editor.action.outdentLines"];
        }
        {
          before = ["<C-n>"];
          "commands" = [":nohl"];
        }
        {
          before = ["<S-k>"];
          "commands" = ["editor.action.showHover"];
        }
        {
          before = ["g" "r"];
          "commands" = ["editor.action.goToReferences"];
        }
        {
          before = ["g" "i"];
          "commands" = ["editor.action.goToImplementation"];
        }
        {
          before = ["<leader>" "r"];
          "commands" = ["editor.action.rename"];
        }
      ];
      "vim.sneak" = true;
      "vim.useSystemClipboard" = true;
      "vim.visualModeKeyBindings" = [
        {
          before = [">"];
          "commands" = ["editor.action.indentLines"];
        }
        {
          before = ["<"];
          "commands" = ["editor.action.outdentLines"];
        }
        {
          after = ["p" "g" "v" "y"];
          before = ["p"];
        }
      ];
      "window.dialogStyle" = "custom";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "GitHub Dark Dimmed";
      "workbench.editor.closeOnFileDelete" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.wrapTabs" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "zig.initialSetupDone" = true;
      "zig.path" = "/run/current-system/sw/bin/zig";
      "zig.zls.path" = "/run/current-system/sw/bin/zls";
    };
  };
}
