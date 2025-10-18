# Repository Guidelines

## Project Structure & Module Organization

The flake root holds `flake.nix`, which wires inputs and exports `darwin`, `nixos`, and standalone Home Manager configurations. Host-specific overrides live under `hosts/<platform>-<name>/`, and compose with shared modules in `modules/{darwin,nixos}` and `home/base`. Development overlays sit in `overlays/`, with helper functions in `lib/`. Secrets encrypted by agenix belong in `secrets/`; keep new sensitive values out of git and reference them via `.age` files instead. Use `home/darwin` and `home/base` for reusable per-user modules before adding host overrides.

## Build, Test, and Development Commands

- `just` — run `just --list` to discover recipes; aliases `c` and `b` wrap common tasks.
- `just c` / `nix flake check` — evaluate all configurations and run pre-commit hooks (formatting, typos, Taplo).
- `just b flake=.#{host}` — build the selected macOS host via `darwin-rebuild`.
- `nixos-rebuild build --flake .#{host}` — build a NixOS host; use `switch` when ready to activate.
- `nix develop` — enter the dev shell with `alejandra`, `nil`, `taplo`, and `typos`, plus pre-commit hooks in `shellHook`.

## Coding Style & Naming Conventions

Write Nix using 2-space indentation and align attribute sets for readability. Format code with `alejandra` or `nix fmt` before committing; the dev shell and pre-commit hook enforce this. Name host files as `<platform>-<hostname>/default.nix` and `home.nix` to mirror `flake.nix` entries, and keep module names kebab-cased (e.g., `modules/darwin/networking.nix`). Prefer pure functions in `lib/` so they can be reused across systems.

## Testing Guidelines

Run `nix flake check` (or `just c`) after every change; it ensures modules evaluate, formatting stays clean, and typos are fixed automatically. For host-specific verification, build with `darwin-rebuild build --flake .#{host}` or `nixos-rebuild build --flake .#{host}` before switching. When adding new modules, include lightweight assertions using `lib.asserts` so evaluation fails fast if prerequisites are missing.

## Commit & Pull Request Guidelines

Follow the existing Conventional Commits style (`feat(scope): message`, `fix: message`, `chore:`). Keep scope identifiers short (`darwin`, `starship`, `flake`). Each pull request should describe the host or module touched, list tested commands, and mention any secrets or follow-up actions. Link related issues when available, and add screenshots only for UI-facing tooling changes (e.g., terminal themes).

## Security & Secrets

Never commit raw credentials; use agenix to create `.age` files and list them in `secrets/`. Confirm the relevant key resides in your age keyring before pushing. When updating secrets, note the change in the PR and coordinate key distribution with affected users.
