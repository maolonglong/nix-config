# Repository Guidelines

## Project Structure & Module Organization

The flake root holds `flake.nix`, which wires inputs and exports `darwinConfigurations` for each macOS host. Host-specific overrides live under `hosts/<hostname>/` (`default.nix` for system, `home.nix` for the user). Shared system-level modules live in `modules/darwin/`, and shared user-level modules live in `home/base/` (cross-cutting) and `home/darwin/` (macOS-only). The upstream-watch automation lives under `automation/upstream-watch/`; follow its nested `AGENTS.md` when changing it. Secrets encrypted by agenix are wired in `modules/darwin/secrets.nix`; keep new sensitive values out of git and reference them via `.age` files in the `mysecrets` input instead.

## Build, Test, and Development Commands

- `just` — run `just --list` to discover recipes; aliases `c` and `b` wrap common tasks.
- `just c` / `nix flake check --show-trace` — run flake checks, including formatting, typos, Taplo, and gitleaks.
- `just eval <host>` — evaluate the selected nix-darwin configuration without building or activating it (defaults to `work-mbp`).
- `just b <host>` — build the selected macOS host via `darwin-rebuild` (defaults to `work-mbp`).
- `darwin-rebuild switch --flake .#<host>` — activate the configuration on the current machine.
- `nix develop` — enter the dev shell with `alejandra`, `nil`, `taplo`, and `typos`, plus pre-commit hooks installed via `shellHook`.

## Coding Style & Naming Conventions

Write Nix using 2-space indentation and align attribute sets for readability. Format code with `alejandra` or `nix fmt` before committing; the dev shell and pre-commit hook enforce this. Name host directories as `<hostname>/` with `default.nix` and `home.nix` to mirror `flake.nix` entries, and keep module names kebab-cased (e.g., `modules/darwin/homebrew.nix`). Prefer explicit `imports` lists over auto-discovery so the module graph stays easy to follow.

## Testing Guidelines

Run `just c` after Nix or repository-level changes. For host-specific changes, run `just eval <host>` first, then `just b <host>` when a full build is warranted. For files under `automation/upstream-watch/`, also run the checks declared in its nested `AGENTS.md`.

## Agent Workflow for Nix Changes

- Home Manager is integrated as a nix-darwin module; this flake does not export standalone `homeConfigurations`.
- Never assume an option exists from model memory. Query Nix documentation, then verify it against the inputs pinned by `flake.lock`.
- When online documentation and the pinned version disagree, treat the local flake input source as authoritative.
- The nix-darwin package set comes from `nixpkgs-darwin`; `pkgs-unstable` is passed explicitly through `specialArgs`.
- Do not update `flake.lock` unless explicitly requested.
- Do not run `darwin-rebuild switch`, `home-manager switch`, or activation commands unless explicitly requested.
- Fix the first root evaluation error before making unrelated changes.

## Commit & Pull Request Guidelines

- Use Conventional Commits: `<type>(<scope>): <summary>` — imperative, <= 72 chars, no trailing period. Keep scope identifiers short (`darwin`, `starship`, `flake`).
- **Always write a commit body** explaining the *why* (bullets welcome), not just the *what*.
- Each pull request should describe the host or module touched, list tested commands, and mention any secrets or follow-up actions. Link related issues when available, and add screenshots only for UI-facing tooling changes (e.g., terminal themes).

## Security & Secrets

Never commit raw credentials; use agenix to create `.age` files in the `mysecrets` repository and reference them from `modules/darwin/secrets.nix`. Confirm the relevant key resides in your age keyring before pushing. When updating secrets, note the change in the PR and coordinate key distribution with affected users.
