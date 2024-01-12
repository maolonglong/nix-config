{pkgs, ...}: {
  programs.vscode = {
    userSettings = {
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
      "editor.fontFamily" = "Jetbrains Mono";
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
      "go.formatFlags" = [
        "-local=github.com/maolonglong,go.chensl.me"
      ];
      "go.formatTool" = "custom";
      "go.inlayHints.assignVariableTypes" = true;
      "go.inlayHints.compositeLiteralFields" = true;
      "go.inlayHints.constantValues" = true;
      "go.inlayHints.functionTypeParameters" = true;
      "go.inlayHints.parameterNames" = true;
      "go.inlayHints.rangeVariableTypes" = true;
      "go.toolsManagement.autoUpdate" = true;
      gopls = {
        "build.buildFlags" = [
          "-tags=wireinject"
        ];
        "ui.completion.usePlaceholders" = false;
        "ui.diagnostic.analyses" = {
          fieldalignment = true;
          nilness = true;
          # shadow = true;
          unusedparams = true;
          unusedvariable = true;
          unusedwrite = true;
          useany = true;
        };
        "ui.semanticTokens" = true;
      };
      # "haskell.manageHLS" = "GHCup";
      # "haskell.toolchain" = {
      #   cabal = "3.6.2.0";
      #   ghc = "9.2.8";
      #   hls = "2.2.0.0";
      #   stack = "2.9.3";
      # };
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
      "python.analysis.typeCheckingMode" = "basic";
      "redhat.telemetry.enabled" = false;
      "security.workspace.trust.enabled" = false;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      # "terminal.integrated.minimumContrastRatio" = 1;
      "terminal.integrated.persistentSessionReviveProcess" = "never";
      "thriftFormatter.alignByAssign" = true;
      "thriftFormatter.alignByField" = true;
      "todo-tree.highlights.enabled" = false;
      "window.dialogStyle" = "custom";
      "window.nativeTabs" = true;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Dracula";
      "workbench.editor.closeOnFileDelete" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.wrapTabs" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.tree.enableStickyScroll" = true;
      "zig.initialSetupDone" = true;
      "zig.path" = "${pkgs.zig}/bin/zig";
      "zig.zls.path" = "${pkgs.zls}/bin/zls";
    };
  };
}
