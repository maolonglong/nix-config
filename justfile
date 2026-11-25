set ignore-comments

alias b := build
alias c := check

local_os := os()
local_arch := arch()
local_system := if local_os == "macos" {
  if local_arch == "aarch64" { "aarch64-darwin" } else { "x86_64-darwin" }
} else {
  local_arch + "-linux"
}
local_hostname := `hostname -s`
default_host := if local_hostname == "chensl-mba" {
  "personal-mba"
} else if local_hostname == "CRWQCPJC7G" {
  "work-mbp"
} else if local_os == "linux" {
  "linux-dev-" + local_system
} else {
  ""
}

[private]
default:
  just --list

# Evaluate every Darwin and Linux target and run the flake's pre-commit hooks.
[group('verify')]
check:
  nix flake check --show-trace

# Evaluates a target and runs its invariant assertions without building.
[group('verify')]
eval target=default_host:
  #!/usr/bin/env bash
  set -euo pipefail
  if [[ -z "{{target}}" ]]; then
    printf >&2 'error: unknown local host %s; pass a target explicitly (e.g. personal-mba, work-mbp, linux-dev-x86_64-linux)\n' "{{local_hostname}}"
    exit 1
  fi
  nix eval ".#checks.{{local_system}}.{{target}}-eval.drvPath" --show-trace

[group('verify')]
fmt:
  nix fmt -- .

[group('system')]
[macos]
build host=default_host:
  #!/usr/bin/env bash
  set -euo pipefail
  if [[ -z "{{host}}" ]]; then
    printf >&2 'error: unknown local host %s; pass a host explicitly (e.g. personal-mba, work-mbp)\n' "{{local_hostname}}"
    exit 1
  fi
  darwin-rebuild build --flake ".#{{host}}"

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
  if [[ -z "{{host}}" ]]; then
    printf >&2 'error: unknown local host %s; pass a host explicitly (e.g. personal-mba, work-mbp)\n' "{{local_hostname}}"
    exit 1
  fi
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
[macos]
history:
  darwin-rebuild --list-generations

[group('system')]
[linux]
build target=("dev@" + local_system):
  home-manager build --flake ".#{{target}}"

[group('system')]
[linux]
switch target=("dev@" + local_system):
  home-manager switch --flake ".#{{target}}"

[group('system')]
[linux]
history:
  home-manager generations

# Delete system generations older than 7 days, then collect garbage.
[group('system')]
[macos]
gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

# Delete user generations older than 7 days, then collect garbage.
[group('system')]
[linux]
gc:
  nix-collect-garbage --delete-older-than 7d

# Update all inputs, or only `input` when given.
[group('flake')]
up *input:
  nix flake update {{input}}
