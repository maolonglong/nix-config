{pkgs, ...}: {
  programs.vscode = {
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      # alingse.thirft-formatter
      christian-kohler.path-intellisense
      codezombiech.gitignore
      davidanson.vscode-markdownlint
      donjayamanne.githistory
      dracula-theme.theme-dracula
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
      # mrkou47.thrift-syntax-support
      ms-azuretools.vscode-docker
      ms-ceintl.vscode-language-pack-zh-hans
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
      # wayou.vscode-todo-highlight
      yzhang.markdown-all-in-one
      zxh404.vscode-proto3
      ziglang.vscode-zig
    ];
  };
}
