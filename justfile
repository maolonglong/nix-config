set ignore-comments

alias b := build
alias c := check

default_host := "work-mbp"

[private]
default:
  just --list

# Evaluate every host and run the flake's pre-commit hooks.
[group('verify')]
check:
  nix flake check --show-trace

# Evaluates the host and runs its invariant assertions without building.
[group('verify')]
eval host=default_host:
  nix eval .#checks.aarch64-darwin.{{host}}-eval.drvPath --show-trace

[group('verify')]
fmt:
  nix fmt -- .

[group('system')]
[macos]
build host=default_host:
  darwin-rebuild build --flake .#{{host}}

# Build, then list the package changes against the running system.
[group('system')]
[macos]
diff host=default_host: (build host)
  nix store diff-closures /run/current-system ./result

[group('system')]
[macos]
switch host=default_host:
  sudo darwin-rebuild switch --flake .#{{host}}

[group('system')]
history:
  darwin-rebuild --list-generations

# Delete system generations older than 7 days, then collect garbage.
[group('system')]
gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

# Update all inputs, or only `input` when given.
[group('flake')]
up *input:
  nix flake update {{input}}
