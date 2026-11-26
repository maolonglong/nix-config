# Repository Guidelines

## Project Map

- `flake.nix` exports `darwinConfigurations` (macOS with integrated Home Manager) and standalone `homeConfigurations` (`dev@x86_64-linux`, `dev@aarch64-linux`), assembled by `mkDarwin` / `mkLinuxHome` from `darwinHosts` and `linuxHomes`.
- `hosts/<name>/`: `vars.nix` (identity: `username`, `userfullname`, `useremail`), `default.nix` (Darwin system overrides), `home.nix` (user overrides).
- Before adding a host, adding a host-specific setting, or placing/moving a setting across `modules/darwin/`, `home/`, and `hosts/`, read `docs/hosts.md`.

## Verification

- **Host-specific Nix changes**: run `just eval [target]` for each affected target.
- **Shared Nix or flake changes**: run `just c` (`nix flake check --show-trace`: evaluates all Darwin and Linux targets plus pre-commit hooks); run `just b [target]` when evaluation alone cannot validate the change.
- **Documentation-only changes**: verify the diff and any changed paths or commands; no Nix evaluation or build is required.

Targets are `personal-mba`, `work-mbp`, `linux-dev-x86_64-linux`, and `linux-dev-aarch64-linux` (`dev@<arch>-linux` is also accepted on Linux). `just eval` and `just b` default by hostname on known Macs and to `linux-dev-<arch>-linux` on Linux; unknown Macs require an explicit target. Run `just --list` for other recipes (`just fmt`, `just diff`, `just brew-up`).

Stop at `just eval` or `just b`; leave `darwin-rebuild switch`, `home-manager switch`, activation commands, and `flake.lock` updates to the user unless explicitly requested.

When running in Cursor Cloud or without access to the private `mysecrets` input, report unavailable eval checks rather than overriding inputs, and read `docs/cloud-agent.md` for fallback checks.

## Nix Conventions

- Use kebab-case module names, explicit `imports` lists (no auto-discovery), and format Nix with `just fmt` (Alejandra).
- Verify new or changed options against the input sources pinned in `flake.lock`; pinned sources take precedence over online documentation.

## Security & Secrets

- Store credentials only as agenix `.age` files in `nix-secrets` (`mysecrets` input) wired through `modules/darwin/secrets.nix`; never commit raw credentials. When changing encrypted secrets, confirm required keys and document recipient or key-distribution follow-up in the PR.
- Inspect Nix declarations and file metadata instead of reading or outputting decrypted secret files (`config.age.secrets.*.path`, Nix `!include` targets), even when permissions allow access.

## Commits & Pull Requests

- Conventional Commits: `<type>(<scope>): <summary>` — imperative, <= 72 chars, no trailing period, short scope (`darwin`, `starship`, `flake`). Always include a commit body explaining *why*.
- PRs state touched hosts/modules, verification commands run, and any secrets or follow-up actions (screenshots only for UI-facing tooling changes).
