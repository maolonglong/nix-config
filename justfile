set ignore-comments

alias b := build
alias c := check

default:
  just --list

check:
  nix flake check --show-trace

eval host="work-mbp":
  nix eval .#darwinConfigurations.{{host}}.config.system.build.toplevel.drvPath --show-trace

[macos]
build host="work-mbp":
  darwin-rebuild build --flake .#{{host}}
