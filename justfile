set ignore-comments

# `build` is macOS-only. An unguarded alias makes `just` refuse to parse
# on Linux, so `just eval` and `just check` would never run.
[macos]
alias b := build
alias c := check

local_hostname := `hostname -s`
default_host := if local_hostname == "chensl-mba" { "personal-mba" } else { "work-mbp" }

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
  #!/usr/bin/env bash
  set -euo pipefail
  expected=$(nix eval --raw ".#darwinConfigurations.{{host}}.config.networking.hostName")
  actual=$(scutil --get HostName 2>/dev/null || hostname -s)
  if [[ "$actual" != "$expected" ]]; then
    printf >&2 'error: refusing to switch %s on host %s (expected %s)\n' "{{host}}" "$actual" "$expected"
    exit 1
  fi
  sudo darwin-rebuild switch --flake ".#{{host}}"

[group('system')]
[macos]
rollback:
  sudo darwin-rebuild --rollback

# Update Homebrew metadata and upgrade outdated formulae and casks.
[group('system')]
[macos]
brew-up:
  brew update
  brew upgrade

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
