set ignore-comments

alias b := build
alias c := check

default:
  just --list

check:
  nix flake check

[macos]
build:
  darwin-rebuild build --flake .
