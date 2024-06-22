set ignore-comments

alias b := build
alias c := check

default:
  just --list

check:
  nix flake check

[macos]
build flake=".":
  darwin-rebuild build --flake {{flake}}
