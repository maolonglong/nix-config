# Repository Guidelines

## Project Map

- `flake.nix` exports `darwinConfigurations`; Home Manager is integrated into nix-darwin, with no standalone `homeConfigurations`.
- `hosts/<hostname>/`: `default.nix` for system overrides, `home.nix` for user overrides.
- Shared modules: `modules/darwin/` for system settings, `home/base/` for cross-platform user settings, `home/darwin/` for macOS user settings.
- For changes to `automation/upstream-watch/` or `.github/workflows/upstream-watch.yml`, follow `automation/upstream-watch/AGENTS.md`.

## Commands and Verification

- `just eval <host>` evaluates a host without building or activating it; defaults to `work-mbp`.
- `just c` runs `nix flake check --show-trace`: host evaluation checks and pre-commit hooks for Alejandra, typos, Taplo, and gitleaks.
- `just b <host>` builds without activation via `darwin-rebuild`; macOS only, defaults to `work-mbp`.
- `nix develop` provides Alejandra, nil, Taplo, typos, and installs pre-commit hooks.

The flake exports checks, formatter, and dev shell only for `aarch64-darwin`. A default `nix flake check` on Linux is not evidence that the Darwin checks ran. Evaluation requires access to the private `mysecrets` input; report unavailable checks rather than changing inputs to bypass access failures.

- Host-specific Nix changes: evaluate the affected host. Shared Nix or flake changes: evaluate both `work-mbp` and `personal-mba`. Run `just c` on a supported environment; build affected hosts when evaluation alone cannot validate the change.
- Automation changes: use the checks in its nested guidance; unrelated Nix checks are not required.
- Documentation-only changes: check the diff and any changed paths or commands; no Nix evaluation or build is required.

## Nix Conventions and Boundaries

- Format Nix with Alejandra (`alejandra` or `nix fmt`); use kebab-case module names and explicit `imports` lists rather than auto-discovery.
- When adding or changing options, verify their contracts against the input sources pinned by `flake.lock`. Consult online documentation as needed; pinned sources take precedence.
- Use the standard `pkgs` argument, supplied by the `nixpkgs-darwin` unstable input.
- Do not update `flake.lock` unless explicitly requested.
- Do not run `darwin-rebuild switch`, `home-manager switch`, or activation commands unless explicitly requested.

## Commit & Pull Request Guidelines

- Use Conventional Commits: `<type>(<scope>): <summary>` — imperative, <= 72 chars, no trailing period. Keep scope identifiers short (`darwin`, `starship`, `flake`).
- **Always write a commit body** explaining the *why* (bullets welcome), not just the *what*.
- Each pull request should describe the host or module touched, list tested commands, and mention any secrets or follow-up actions. Link related issues when available, and add screenshots only for UI-facing tooling changes (e.g., terminal themes).

## Security & Secrets

Never commit raw credentials. Store secrets as agenix `.age` files in the separate `nix-secrets` repository (`mysecrets` input) and wire them through `modules/darwin/secrets.nix`. When changing encrypted secrets, confirm the required keys are available and document recipient or key-distribution follow-up in the PR.
