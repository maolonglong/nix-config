# Copilot instructions for this repo

Purpose: help AI agents work effectively in this Nix flake that configures macOS (nix-darwin), NixOS, and Home Manager.

## Architecture snapshot
- Flake entry: `flake.nix` wires inputs (nixpkgs stable/unstable, nix-darwin, home-manager, agenix, nix-index-database, private `mysecrets`, `mynur`) and exposes:
  - `darwinConfigurations`: `chensl-mba`, `work`
  - `nixosConfigurations`: `nixos`
- Core helpers in `lib/`:
  - `macosSystem`, `nixosSystem`, `homeOnlySystem`: glue nix(-darwin)/home-manager and inject `specialArgs`.
  - `scanPaths path`: auto-imports all submodules (directories and `.nix` files) except `default.nix`.
  - `genSpecialArgs myvars`: provides `inputs`, `mylib`, `myvars`, and `pkgs-unstable` (use this in modules when you need newer packages).
- System modules:
  - macOS: `modules/darwin/{nix-core.nix,security.nix,system.nix,fonts.nix,apps.nix,...}` plus `modules/darwin/default.nix` (imports `../base.nix` and `scanPaths ./`).
  - NixOS: `modules/nixos/*` with `modules/nixos/default.nix` importing `../base.nix` and `scanPaths ./`.
- Home Manager:
  - OS-agnostic base under `home/base/{core,gui,tui}`; platform variants under `home/darwin` and `home/linux`.
  - Example: `home/base/core/shells/zsh.nix` configures oh-my-zsh and pins `nix-zsh-completions` via `pkgs.fetchFromGitHub`.
- Hosts: per-host wiring under `hosts/**` and referenced in `flake.nix` (`darwinHosts`, `nixosHosts`).
- Overlays: `overlays/default.nix` loads every overlay in the folder; `overlays/gh-patch.nix` adds `fetchFromGitHubWithPatches` derivation helper.
- Secrets: `secrets/darwin.nix` enables agenix, expects `/etc/ssh/ssh_host_ed25519_key` and decrypts files from private `nix-secrets`.

## Daily workflows
- Dev shell: `nix develop` gives alejandra (formatter), nil (LSP), taplo, typos; pre-commit hooks are wired via `checks.pre-commit-check.shellHook`.
- Format & checks: `nix fmt` (alejandra) and `nix flake check` (or `just c`).
- Build/apply configs (examples):
  - macOS: `darwin-rebuild switch --flake .#work` or `.#chensl-mba` (or `just b flake=.#work`).
  - NixOS: `nixos-rebuild switch --flake .#nixos`.
- Homebrew: managed via nix-darwin (`home/darwin/homebrew.nix`), with mirror env and MAS apps; ensure Brew is installed outside Nix.

## Conventions and patterns
- Auto-import: aggregator `default.nix` files commonly do `imports = mylib.scanPaths ./.;` or similar; drop a new module next to it and it gets picked up automatically (no manual list edits).
- Special args: modules may accept `pkgs-unstable`, `mylib`, `myvars` (see `flake.nix` → `genSpecialArgs`). Example: `hosts/darwin-work/home.nix` picks `pkgs-unstable.go_1_23`.
- Home Manager is integrated into nix-darwin/NixOS systems; prefer `darwin-rebuild`/`nixos-rebuild`.
- Mirrors/caches: `modules/base.nix` sets `substituters` (TUNA/SJTU/USTC, cachix) and trusted keys; keep them intact for fast builds.
- Known macOS choices: `nix.settings.auto-optimise-store = false` (upstream issue); TouchID for sudo; system defaults tuned in `modules/darwin/system.nix`.
- Shell: system default stays zsh; nushell is commented to avoid app breakage; zsh extras and aliases live in `home/base/core/shells/zsh.nix` and `home/darwin/homebrew.nix` (note `lib.mkOrder 550`).

## Practical examples
- Add a new TUI tool: create `home/base/tui/mytool.nix` with `{ pkgs, ... }: { programs.mytool.enable = true; }` — aggregator will import it.
- Use an unstable package: in a HM module, take `pkgs-unstable` from args and reference e.g. `pkgs-unstable.go_1_23`.
- Patch upstream source: write an overlay in `overlays/*.nix` or use `fetchFromGitHubWithPatches { owner=...; repo=...; rev=...; hash=...; patches=[ ./fix.patch ]; }`.
- Host-specific tweaks: put them under `hosts/<name>`, then ensure `flake.nix` includes that host in the corresponding set.

## Gotchas
- Secrets must exist or builds referencing them will fail; for macOS ensure `sudo ssh-keygen -A` has created `/etc/ssh/ssh_host_ed25519_key`.
- Some hosts intentionally disable HM modules (e.g., `programs.ssh.enable = false` in `hosts/darwin-work/home.nix`). Don’t re-enable globally.

Primary hosts to target in examples: `#work`, `#chensl-mba`.

## Command cheat sheet

### macOS hosts (#work, #chensl-mba)
(Optional)
```bash
# Apply configuration
darwin-rebuild switch --flake .#work
darwin-rebuild switch --flake .#chensl-mba

# Build only (keeps current system active)
darwin-rebuild build --flake .#work

# With debug backtrace
darwin-rebuild switch --show-trace --flake .#work

# List system generations
darwin-rebuild --list-generations

# Garbage-collect store & delete old generations (per apps.nix notes)
sudo nix store gc --debug
sudo nix-collect-garbage --delete-old
```

### NixOS host (#nixos)
(Optional)
```bash
nixos-rebuild switch --flake .#nixos
nixos-rebuild switch --show-trace --flake .#nixos
```

### Repo utilities
(Optional)
```bash
nix develop
nix fmt
nix flake check
```

### just recipes
(Optional)
```bash
# List available recipes
just

# Run flake checks
just c

# Build macOS system (recipe is macOS-only)
just b flake=.#work
just b flake=.#chensl-mba
```
