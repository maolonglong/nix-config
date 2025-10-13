# Copilot instructions for this repo

Purpose: help AI agents work effectively in this Nix flake that configures macOS (nix-darwin), NixOS, and Home Manager.

## Architecture snapshot
- **Flake entry**: `flake.nix` wires inputs (nixpkgs stable/unstable/darwin variants, nix-darwin, home-manager, agenix, nix-index-database, private `mysecrets`, `mynur`) and exposes:
  - `darwinConfigurations`: `chensl-mba`, `work`
  - `nixosConfigurations`: `nixos`
  - `homeConfigurations`: `devbox` (standalone home-manager for remote systems)
- **Core helpers in `lib/`**:
  - `macosSystem`, `nixosSystem`, `homeOnlySystem`: construct system configs and inject `specialArgs`
  - `scanPaths path`: auto-imports all submodules (directories + `.nix` files) except `default.nix` — this is the magic behind auto-discovery
  - `genSpecialArgs myvars`: provides `inputs`, `mylib`, `myvars`, and `pkgs-unstable` (use this when needing newer packages than stable channel)
  - `attrs.nix`: convenience wrappers for common lib functions (listToAttrs, mapAttrs, mergeAttrsList, etc.)
- **System modules**:
  - macOS: `modules/darwin/{nix-core.nix,security.nix,system.nix,fonts.nix,apps.nix,...}` plus `modules/darwin/default.nix` (imports `../base.nix` + `scanPaths ./`)
  - NixOS: `modules/nixos/*` with `modules/nixos/default.nix` importing `../base.nix` + `scanPaths ./`
  - Shared: `modules/base.nix` configures mirrors (TUNA/SJTU/USTC), cachix, core packages, and experimental features
- **Home Manager**:
  - OS-agnostic base under `home/base/{core,gui,tui}`; platform-specific under `home/darwin` and `home/linux`
  - Each layer uses `mylib.scanPaths ./.` in its `default.nix` for automatic imports
  - Example: `home/base/core/shells/zsh.nix` configures oh-my-zsh and pins `nix-zsh-completions` via `pkgs.fetchFromGitHub`
- **Hosts**: per-host config under `hosts/**`, referenced in `flake.nix` via `darwinHosts`, `nixosHosts`, `homeOnlyHosts` attribute sets
- **Overlays**: `overlays/default.nix` auto-loads every `.nix` file in the folder (except `default.nix`/`README.md`); example: `gh-patch.nix` provides `fetchFromGitHubWithPatches` helper
- **Secrets**: `secrets/darwin.nix` enables agenix, requires `/etc/ssh/ssh_host_ed25519_key` and decrypts files from private `nix-secrets` repo

## Daily workflows
- **Dev shell**: `nix develop` gives alejandra (formatter), nil (LSP), taplo (TOML), typos (spell checker); pre-commit hooks auto-run via `checks.pre-commit-check.shellHook`
- **Format & checks**: `nix fmt` (alejandra) and `nix flake check` (or `just c` shortcut)
- **Build/apply configs**:
  - macOS: `darwin-rebuild switch --flake .#work` or `.#chensl-mba` (or `just b flake=.#work`)
  - NixOS: `nixos-rebuild switch --flake .#nixos`
  - Home Manager standalone: `home-manager switch --flake .#devbox` (for remote dev machines)
  - Debug: add `--show-trace` flag for detailed error backtraces
  - Build-only (no activation): `darwin-rebuild build --flake .#work`
- **Homebrew**: managed declaratively via `home/darwin/homebrew.nix` with mirror env vars and MAS apps; Homebrew itself must be installed outside Nix
- **Garbage collection**: `sudo nix-collect-garbage --delete-old` and `sudo nix store gc --debug` (see `modules/darwin/apps.nix` for context)

## Conventions and patterns
- **Auto-import magic**: aggregator `default.nix` files use `imports = mylib.scanPaths ./.;` — just drop a new `.nix` file next to it, no manual import list needed
  - Example: create `home/base/tui/mytool.nix` → automatically imported by `home/base/tui/default.nix`
  - Exceptions: `default.nix` itself is always excluded from `scanPaths`
- **Special args injection**: modules receive `pkgs-unstable`, `mylib`, `myvars`, `inputs` via `specialArgs` (defined in `flake.nix` → `genSpecialArgs`)
  - Example: `hosts/darwin-work/home.nix` uses `pkgs-unstable.go_1_25` for newer Go version
  - Access pattern: `{ pkgs-unstable, mylib, myvars, ... }: { ... }`
- **Home Manager integration**: tightly coupled with nix-darwin/NixOS; always use `darwin-rebuild`/`nixos-rebuild` (not standalone `home-manager` CLI for system hosts)
- **Binary caches**: `modules/base.nix` configures TUNA/SJTU/USTC mirrors + cachix for faster builds in China; keep these intact
- **Platform-specific gotchas**:
  - macOS: `nix.settings.auto-optimise-store = false` (upstream compatibility issue), TouchID for sudo enabled
  - System defaults tuned in `modules/darwin/system.nix` (dock, finder, keyboard, etc.)
- **Shell configuration**: system default shell is zsh; nushell commented out to avoid breaking GUI apps; zsh customization in `home/base/core/shells/zsh.nix` with `lib.mkOrder 550` for initExtra ordering
- **Overlay pattern**: `overlays/default.nix` auto-loads all `.nix` files (except `default.nix`/`README.md`); each overlay is a function `args: (final: prev: { ... })`

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
