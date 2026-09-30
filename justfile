set ignore-comments

alias b := build
alias c := check

default:
  just --list

check:
  nix flake check --show-trace

# Evaluates the host and runs its invariant assertions without building.
eval host="work-mbp":
  nix eval .#checks.aarch64-darwin.{{host}}-eval.drvPath --show-trace

[macos]
build host="work-mbp":
  darwin-rebuild build --flake .#{{host}}

[macos]
switch host="work-mbp":
  sudo darwin-rebuild switch --flake .#{{host}}

# Update all inputs, or only `input` when given.
up *input:
  nix flake update {{input}}

history:
  darwin-rebuild --list-generations

# Delete system generations older than 7 days, then collect garbage.
gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

fmt:
  nix fmt
