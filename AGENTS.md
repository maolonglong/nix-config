# Repository Guidelines

## Project Structure & Module Organization

- `flake.nix` defines inputs, shared utilities in `lib/`, and enumerates darwin, NixOS, and home-only hosts.
- System modules live in `modules/` (`base.nix`, `darwin/`, `nixos/`), while user environments sit under `home/` grouped into `base/`, `darwin/`, and host overrides.
- Host-specific overrides belong in `hosts/<platform>-<hostname>/`, e.g. `hosts/darwin-work/` or `hosts/linux-devbox/`, keeping secrets isolated in `secrets/` (agenix encrypted).
- Overlays and package tweaks go in `overlays/`; reusable helper functions belong in `lib/`.

## Build, Test, and Development Commands

- `nix develop` enters the devshell with `alejandra`, `nil`, `taplo`, and `typos`.
- `just check` or `nix flake check` validates the flake, runs pre-commit hooks, and ensures module evaluation succeeds.
- `just build flake=.#work` builds the macOS host configuration; substitute `.#chensl-mba` or `.#nixos` as needed.
- Apply changes with `darwin-rebuild switch --flake .#work` or `nixos-rebuild switch --flake .#nixos` after a dry-run.

## Coding Style & Naming Conventions

- Format Nix files with `alejandra`; keep indentation at two spaces and prefer attribute names with kebab-case (e.g. `system.defaults`).
- TOML manifests (such as `.typos.toml`) should respect `taplo fmt`; avoid inline tables for readability.
- Name host modules and home modules using the `<platform>-<hostname>` pattern to align with `flake.nix`.
- Enable the repo’s hooks (`nix develop` + `git commit`) so `typos` auto-fixes spelling and `alejandra` runs before each commit.

## Testing Guidelines

- Always run `nix flake check` before pushing; it exercises module option validation and the pre-commit suite.
- For host touches, run `darwin-rebuild build --flake .#target` or `nixos-rebuild build --flake .#target` to ensure system closure builds.
- Verify home-manager changes via `home-manager build --flake .#devbox` (or the relevant profile) prior to switching.
- Keep test files or sample configs alongside their modules (e.g. `modules/darwin/`) and mirror the attribute path in the filename.

## Commit & Pull Request Guidelines

- Follow the existing Conventional Commit style (`feat:`, `fix:`, `chore:`) and mention the platform or module touched (`feat(darwin): tweak finder defaults`).
- Squash incidental formatting into the functional commit; pre-commit hooks should leave diffs clean.
- Pull requests should highlight the target host(s), note any secret or agenix updates, and include the command used for verification (`nix flake check`, rebuild dry-run).
- Include screenshots only when UI-facing tweaks (e.g. finder defaults) change visible behavior; otherwise link to relevant module paths.

## Secrets & Configuration Tips

- Encrypted secrets live in `secrets/` and are managed with agenix; edit via `nix run github:ryantm/agenix -- -e secrets/<file>.age`.
- Ensure target machines have the expected SSH host keys before deploying secrets, and avoid committing decrypted material anywhere in the repo.
